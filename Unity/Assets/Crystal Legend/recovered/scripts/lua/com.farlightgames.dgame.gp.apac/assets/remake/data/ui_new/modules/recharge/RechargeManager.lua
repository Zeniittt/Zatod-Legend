local RechargeManager = {}
RechargeManager.__index = RechargeManager
RechargeManager.PriceType = {Diamond = "Diamond", GiftTicket = "GiftTicket"}
RechargeManager.GiftType = {Enjoy = "common", Dreamland = "dreamland"}

function RechargeManager.create()
  local self = {}
  setmetatable(self, RechargeManager)
  self:initData()
  return self
end

function RechargeManager:initData()
  self.enableRecharge = {status = "open", showText = ""}
  self.bbbNumber = 0
  self.freeRewardCanLootFlag = 0
  self.unreadViewFlag = 0
  self.newGiftsCache = {}
  self.ticketData = {}
  self.needNoticeTicket = true
  self.allRechargeItem = {}
  self.tickItemData = {}
  self:initGiftTicketsInfo()
  self.pid_CNYCost = {}
  self.CNYCost_CostDisplay = {}
  self:initCNYCost()
end

function RechargeManager:initCNYCost()
  local rechargeTB = ed.getDataTable("Recharge")
  local pidCNYCost = {}
  local CNYCostCostDisplay = {}
  for id, row in pairs(rechargeTB) do
    if type(id) == "number" then
      local pid = row[ed.getIAPTitle()]
      if not pidCNYCost[pid] then
        local CNYCost = row.Cost
        pidCNYCost[pid] = CNYCost
        CNYCostCostDisplay[CNYCost] = {
          localCost = CNYCost,
          formattedPrice = string.format("%d\229\133\131", CNYCost)
        }
      end
    end
  end
  self.pid_CNYCost = pidCNYCost
  self.CNYCost_CostDisplay = CNYCostCostDisplay
  print("self.pid_CNYCost", self.pid_CNYCost)
  print("self.CNYCost_CostDisplay", self.CNYCost_CostDisplay)
end

function RechargeManager:getCNYCostByPID(pid)
  return self.pid_CNYCost[pid]
end

function RechargeManager:getCostDisplayByCNYCost(CNYCost)
  print("getCostDisplayByCNYCost", CNYCost)
  if CNYCost == 0 then
    return T("\229\133\141\232\180\185\233\162\134\229\143\150")
  end
  return self.CNYCost_CostDisplay[CNYCost].formattedPrice
end

function RechargeManager:getLocalCostByCNYCost(CNYCost)
  if CNYCost == 0 then
    return 0
  end
  return self.CNYCost_CostDisplay[CNYCost].localCost
end

function RechargeManager:initLocalCostWithSkuItemDetails(SkuItemDetails)
  local goods = SkuItemDetails.goods
  for k, v in pairs(goods) do
    local pid = v.productId
    local CNYCost = self:getCNYCostByPID(pid)
    self.CNYCost_CostDisplay[CNYCost].formattedPrice = v.formattedPrice
    self.CNYCost_CostDisplay[CNYCost].localCost = v.priceCent
  end
end

function RechargeManager:initGiftTicketsInfo()
  self.giftTicketsInfo = {}
  local rechargeTB = ed.getDataTable("Recharge")
  for id, row in pairs(rechargeTB) do
    if type(id) == "number" and row.Type == "GiftTicket" then
      table.insert(self.giftTicketsInfo, {
        rechargeId = id,
        CNYCost = row.Cost,
        USDCost = row["Cost USD"],
        equipId = row["Item ID"],
        iconRes = row.Icon
      })
    end
  end
  table.sort(self.giftTicketsInfo, function(e1, e2)
    return e1.CNYCost < e2.CNYCost
  end)
end

function RechargeManager:getTicketAndTicketEquipNum(CNYCost)
  local ticketNum = self:getTicketNumber(CNYCost)
  local ticketItemNum = 0
  local equipId = 0
  for i, v in ipairs(self:getGiftTicketsInfo()) do
    if v.CNYCost == CNYCost then
      ticketItemNum = ed.player:getEquipAmount(v.equipId) or 0
      equipId = v.equipId
      break
    end
  end
  return ticketNum, ticketItemNum, equipId
end

function RechargeManager:getGiftTicketsInfo()
  return self.giftTicketsInfo
end

function RechargeManager:getTicketNumber(price)
  return self.ticketData["price_" .. price] or 0
end

function RechargeManager:getAllTicketNumber()
  local amounts = 0
  for k, v in pairs(self.ticketData or {}) do
    amounts = amounts + v
  end
  local tickedNum = amounts
  local ticketsInfo = self:getGiftTicketsInfo()
  for k, v in ipairs(ticketsInfo) do
    local amount = ed.player:getEquipAmount(v.equipId) or 0
    amounts = amounts + amount
  end
  return amounts, tickedNum
end

function RechargeManager:setTicketData(data)
  self.ticketData = {}
  for k, v in ipairs(data._gift_tickets or {}) do
    local price = v._id
    self.ticketData["price_" .. price] = v._amount
  end
  for k, v in ipairs(data._gift_ticket_items or {}) do
    self.tickItemData[v._id] = v._amount
    if ed.player.equip_qunty[v._id] then
      if v._amount > ed.player:getEquipAmount(v._id) then
        ed.player:addEquip(v._id, v._amount - ed.player:getEquipAmount(v._id))
      else
        ed.player:consumeEquip(v._id, ed.player:getEquipAmount(v._id) - v._amount)
      end
    end
  end
  FireEvent("RefreshGiftTickets")
end

local function isOnline(timeString, offlineString)
  local serverTime = ed.getServerTime()
  local onlineTime = ed.getTimeByYMDHMS(timeString)
  local offlineTime = ed.getTimeByYMDHMS(offlineString)
  if type(onlineTime) ~= "number" then
    return false
  end
  if serverTime > onlineTime then
    if offlineString and type(offlineTime) == "number" then
      if serverTime < offlineTime then
        return true
      else
        return false
      end
    else
      return true
    end
  end
  return false
end

function RechargeManager:doRechargeBuyId(rechargeId)
  self:doRecharge(self.allRechargeItem[rechargeId])
end

function RechargeManager:doRecharge(rechargeItem)
  if not rechargeItem then
    EDLog("-->>>>>>doRecharge rechargeItem is nil")
    return
  end
  self.rechargeItem = rechargeItem
  if self:shouldUseTicket(rechargeItem) then
    return
  end
  local enableRecharge = self:getEnableRecharge()
  if enableRecharge.status ~= "open" then
    if enableRecharge.showText ~= "" then
      ed.showToast(enableRecharge.showText)
    end
    return
  end
  if EDReportEvent and EDSDKType > 301 then
    EDReportEvent("Purchase_Click", "")
  end
  EDLog("-->>>>>>doRecharge")
  EDLog("-->>>>>>" .. rechargeItem.title .. " CNYCost:" .. rechargeItem.CNYCost .. " " .. rechargeItem.id .. " " .. game_server_ip)
  if not rechargeItem.pid then
    local curItem = self.allRechargeItem[rechargeItem.id]
    rechargeItem.pid = curItem.pid
  end
  if EDFLAGWP8 then
    ed.showToast(T("\229\133\133\229\128\188\229\183\178\230\154\130\229\129\156\239\188\129"))
  elseif EDFLAGIOS then
    ed.RechargeNetwork:goRechargeIOS(rechargeItem)
  elseif EDFLAGANDROID then
    ed.RechargeNetwork:goRechargeAndriod(rechargeItem)
  else
    local _cost = ed.RechargeManager:getLocalCostByCNYCost(rechargeItem.CNYCost)
    rechargeItem._DEBUG_LOCAL_COST_ = _cost
    print("-->>>>>>Undefined platform or win32!", rechargeItem)
  end
end

function RechargeManager:shouldUseTicket(rechargeItem)
  if rechargeItem.canUseTicket then
    local ticketNum, ticketItemNum, equipId = self:getTicketAndTicketEquipNum(rechargeItem.CNYCost)
    if 0 < ticketNum or 0 < ticketItemNum then
      rechargeItem.equipId = equipId
      rechargeItem.useTicketItem = ticketNum <= 0 and 0 < ticketItemNum
      local display = self:getCostDisplayByCNYCost(rechargeItem.CNYCost)
      local info = {
        text = T("\228\189\160\230\139\165\230\156\137:\n\n\231\164\188\229\140\133\229\136\184\229\143\175\228\187\165\231\148\168\230\157\165\232\180\173\228\185\176%s\231\154\132\229\149\134\229\147\129\239\188\140\230\156\172\230\172\161\229\133\145\230\141\162\229\176\134\230\137\163\233\153\1641\229\188\160%s\231\164\188\229\140\133\229\136\184", display, display),
        leftText = T("\229\143\150\230\182\136"),
        rightText = T("\228\189\191\231\148\168\231\164\188\229\140\133\229\136\184"),
        rightHandler = function()
          ed.RechargeNetwork:reqRmbData(rechargeItem, true)
        end
      }
      ed.showConfirmDialog(info)
      return true
    end
  end
  return false
end

function RechargeManager:initItemData()
  local rechargeItems = {}
  local monthCard = {}
  local monthCardTb = ed.getDataTable("MonthCard")
  local rt = ed.getDataTable("Recharge")
  for k, v in pairs(rt) do
    if type(k) == "number" and ed.player:checkRechargeItemValid(k) then
      local t = {
        id = v.ID,
        type = v.Type,
        order = v.Order,
        title = v["Display Name"],
        CNYCost = v.Cost,
        USDCost = v["Cost USD"],
        get = v["Get Diamond"],
        tag = v.Recommended,
        des = v.Description,
        icon = v.Icon,
        limit = v.Limit,
        itemId = v["Item ID"],
        isBanner = v.Banner,
        isOnline = isOnline(v["Online Time"], v["Offline Time"]),
        giftType = v["Gift Type"],
        giftID = v["Gift ID"],
        giftAmount = v["Gift Amount"],
        trialStages = v["Trial Stage"],
        OnlineTime = v["Online Time"],
        canUseTicket = v["Can Use Gift Ticket"],
        inRecharge = true
      }
      self.allRechargeItem[v.ID] = t
      if t.type == "MonthlyCard" then
        if ed.player:isMonthCardValid("payed") then
          t.des = T("\229\137\169\228\189\153%d\229\164\169", ed.player:getMonthCardLeftTimes("payed"))
        end
        for k, v in pairs(monthCardTb) do
          if k == "Payed" then
            t.title = v["Display Name"]
            t.dailyDiamond = v["Daily Diamond Reward"]
            t.vitalityUp = v["Vitality Max Up"]
            t.autoObtainVitality = v["Auto obtain vitality"] or false
            t.freeMidasTimes = v["Free Midas Times"]
            t.candleMaxUp = v["Candle Max Up"]
          end
        end
        table.insert(monthCard, t)
      end
      if t.type == "DailyPass" then
        self.dailyPassItem = t
      end
      if t.type == "Instant" or t.type == "Item" then
        table.insert(rechargeItems, t)
      end
    end
  end
  for k, v in pairs(monthCardTb) do
    if k == "Free" then
      local FreeCard = {
        order = 1,
        type = "FreeCard",
        des = T("\230\176\184\228\185\133\230\156\136\229\141\161")
      }
      FreeCard.title = v["Display Name"]
      FreeCard.dailyDiamond = v["Daily Diamond Reward"]
      FreeCard.vitalityUp = v["Vitality Max Up"]
      FreeCard.autoObtainVitality = v["Auto obtain vitality"] or false
      FreeCard.freeMidasTimes = v["Free Midas Times"]
      FreeCard.candleMaxUp = v["Candle Max Up"]
      table.insert(monthCard, FreeCard)
    end
  end
  self.rechargeItems = rechargeItems
  self.monthCardItems = monthCard
end

function RechargeManager:setEnableRecharge(data)
  self.enableRecharge.status = data.status
  self.enableRecharge.showText = data.show_text
end

function RechargeManager:getEnableRecharge()
  return self.enableRecharge
end

local function orderItems(items)
  local list = items
  for i = 1, #list do
    for j = i, 2, -1 do
      if list[j].order < list[j - 1].order then
        local t = list[j]
        list[j] = list[j - 1]
        list[j - 1] = t
      end
    end
  end
  return list
end

function RechargeManager:getRechargeItems()
  local items = orderItems(self.rechargeItems)
  return items
end

function RechargeManager:getRechargeItem()
  return self.rechargeItem
end

function RechargeManager:getDailyPassItem()
  if not self.dailyPassItem then
    self:initItemData()
  end
  return self.dailyPassItem
end

function RechargeManager:getFreeGiftInfo()
  local groupId = self.freeGroupId
  local dayIndex = self.dayAcc
  local row = ed.getDataTable("MallGiftFree")[groupId][dayIndex] or {}
  local r = {
    iconRes = row.Icon,
    rewards = {
      type = "Item",
      id = row["Reward ID"],
      amount = row["Reward Amount"]
    },
    buyCount = self.bFreeReward and 0 or 1,
    buyLimit = 1,
    order = 101,
    prio = 7,
    price = 0,
    canShowRedTag = self.bFreeReward,
    resType = 1,
    title = row["Display Name"]
  }
  return r
end

function RechargeManager:getGiftInfoByGiftId(giftId)
  local row = ed.getDataTable("MallGiftCommon")[giftId] or {}
  local rewards = {}
  for i = 1, 5 do
    local type = row["Reward Type " .. i]
    local id = row["Reward ID " .. i]
    local amount = row["Reward Amount " .. i]
    if type then
      table.insert(rewards, {
        type = type,
        id = id,
        amount = amount
      })
    end
  end
  local r = {
    title = row["Display Name"] or "",
    iconRes = row["Display Icon"] or "",
    price = row.Price or 0,
    rewards = rewards,
    order = row.Order or 0,
    showDiscount = row["Show Discount"],
    resType = row["Res Type"] or 1,
    classify = row.Classify,
    tab = row.Tab or "Normal"
  }
  return r
end

function RechargeManager:formatNewGiftItem(rawItem)
  local giftId = rawItem._gift_id
  local giftInfo = self:getGiftInfoByGiftId(giftId)
  giftInfo.giftId = giftId
  giftInfo.buyCount = rawItem._cur_buy_times
  giftInfo.buyLimit = rawItem._max_buy_times
  giftInfo.deadLine = rawItem._deadline
  giftInfo.bViewFlag = rawItem._view_flag == self.unreadViewFlag
  if giftInfo.deadLine then
    giftInfo.getLeftTime = math.max(giftInfo.deadLine - ed.getServerTime(), 0)
  end
  return giftInfo
end

function RechargeManager:alwaysShowTimelyGift(gift)
  local giftId = gift._gift_id or gift.giftId or 0
  local row = ed.getDataTable("MallGiftCommon")[giftId] or {}
  if row and row.Classify == "CNDOTA" then
    return true
  end
  return false
end

function RechargeManager:formatNewGifts()
  local list = {}
  for k, v in ipairs(self.dailyGift) do
    local item = self:formatNewGiftItem(v)
    item.type = "daily"
    table.insert(list, item)
  end
  for k, v in ipairs(self.weeklyGift) do
    local item = self:formatNewGiftItem(v)
    item.type = "weekly"
    table.insert(list, item)
  end
  for k, v in ipairs(self.timelyGifts) do
    if v._max_buy_times > v._cur_buy_times or self:alwaysShowTimelyGift(v) then
      local item = self:formatNewGiftItem(v)
      item.type = "timely"
      table.insert(list, item)
    end
  end
  for k, v in ipairs(self.onceGifts) do
    if v._max_buy_times > v._cur_buy_times then
      local item = self:formatNewGiftItem(v)
      item.type = "once"
      table.insert(list, item)
    end
  end
  return list
end

ListenEvent("mainSceneEnter", function()
  ed.RechargeManager:checkTriggerNewGif()
end)

function RechargeManager:checkTriggerNewGif()
  if self:getEnjoyGiftNewFlag() then
    ed.RechargeNetwork:sendOpenEnjoyGift(ed.RechargeManager.GiftType.Enjoy)
    return
  end
  if self:getDreamlandGiftNewFlag() then
    ed.RechargeNetwork:sendOpenEnjoyGift(ed.RechargeManager.GiftType.Dreamland)
    return
  end
end

function RechargeManager:handleGiftReply(data)
  self:setEnjoyGiftData(data)
  self:setDreamlandGiftData(data)
end

function RechargeManager:handleEnjoyGiftBuyReply(data)
  if data._result == "success" then
    ed.player:addRewards(data._rewards)
    ed.player:setrmb(data._diamond)
    ed.UITool.showRewardsFromServer(data._rewards)
    FireEvent("QueryDataRsp", data)
    FireEvent("EnjoyGiftBuyReply", data)
  else
    ed.showToast(T("\232\180\173\228\185\176\229\164\177\232\180\165"))
  end
end

function RechargeManager:handleEnjoyGiftOpenReply(data)
  self.isEnjoyGiftNewFlag = false
  ed.UITool.openView("EnjoyGiftWin", data)
end

function RechargeManager:setEnjoyGiftData(data)
  self.enjoyGiftNum = 0
  self.enjoyGiftEndTimeArr = {}
  local serverTime = ed.getServerTime()
  for i, v in ipairs(data._nearest_end_time or {}) do
    if v > serverTime then
      self.enjoyGiftNum = self.enjoyGiftNum + 1
      table.insert(self.enjoyGiftEndTimeArr, v)
    end
  end
  self.isEnjoyGiftNewFlag = false
  for i, v in ipairs(data._new_gift_flag or {}) do
    if v == ed.RechargeManager.GiftType.Enjoy then
      self.isEnjoyGiftNewFlag = true
      break
    end
  end
end

function RechargeManager:getEnjoyGiftNewFlag()
  return self.isEnjoyGiftNewFlag
end

function RechargeManager:getEnjoyGiftNum()
  return self.enjoyGiftNum or 0
end

function RechargeManager:getEnjoyGiftEndTime()
  if #self.enjoyGiftEndTimeArr > 0 then
    local serverTime = ed.getServerTime()
    repeat
      if 0 == #self.enjoyGiftEndTimeArr then
        self.enjoyGiftNum = 0
        return 0
      end
      if serverTime < self.enjoyGiftEndTimeArr[1] then
        return self.enjoyGiftEndTimeArr[1]
      end
      table.remove(self.enjoyGiftEndTimeArr, 1)
      self.enjoyGiftNum = self.enjoyGiftNum - 1
    until false
  else
    return 0
  end
end

function RechargeManager:handleDreamlandGiftOpenReply(data)
  self.isDreamlandGiftNewFlag = false
  ed.UITool.openView("DreamlandGiftWin", data)
end

function RechargeManager:setDreamlandGiftData(data)
  self.dreamlandGiftNum = 0
  self.dreamlandGiftEndTimeArr = {}
  local serverTime = ed.getServerTime()
  for i, v in ipairs(data._dreamland_end_time or {}) do
    if v > serverTime then
      self.dreamlandGiftNum = self.dreamlandGiftNum + 1
      table.insert(self.dreamlandGiftEndTimeArr, v)
    end
  end
  self.isDreamlandGiftNewFlag = false
  for i, v in ipairs(data._new_gift_flag or {}) do
    if v == ed.RechargeManager.GiftType.Dreamland then
      self.isDreamlandGiftNewFlag = true
      break
    end
  end
end

function RechargeManager:getDreamlandGiftNewFlag()
  return self.isDreamlandGiftNewFlag
end

function RechargeManager:getDreamlandGiftNum()
  return self.dreamlandGiftNum or 0
end

function RechargeManager:getDreamlandGiftEndTime()
  if #self.dreamlandGiftEndTimeArr > 0 then
    local serverTime = ed.getServerTime()
    repeat
      if 0 == #self.dreamlandGiftEndTimeArr then
        self.dreamlandGiftNum = 0
        return 0
      end
      if serverTime < self.dreamlandGiftEndTimeArr[1] then
        return self.dreamlandGiftEndTimeArr[1]
      end
      table.remove(self.dreamlandGiftEndTimeArr, 1)
      self.dreamlandGiftNum = self.dreamlandGiftNum - 1
    until false
  else
    return 0
  end
end

function RechargeManager:doRechargeEnjoyGift(cfgId, id)
  local rechargeId
  local giftTable = ed.getDataTable("ImpulseGift")[cfgId]
  local priceType = giftTable["Price Type"]
  if priceType == ed.RechargeManager.PriceType.Diamond then
    local point = ed.player:getPoint("diamond")
    if point < giftTable.Price then
      ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
      return
    end
    ed.RechargeNetwork:sendBuyEnjoyGift(id)
  elseif priceType == ed.RechargeManager.PriceType.GiftTicket then
    local price = giftTable.Price
    local rt = ed.getDataTable("Recharge")
    for id, row in pairs(rt) do
      if type(id) == "number" then
        local type = row.Type
        if type == "GiftTicket" and row.Cost == price then
          rechargeId = row.ID
        end
      end
    end
    if not rechargeId then
      error("unsupported gift ticket price: " .. price)
      return
    end
    local v = ed.getDataTable("Recharge")[rechargeId]
    local rechargeItem = {
      id = v.ID,
      pid = v[ed.getIAPTitle()],
      title = v["Display Name"],
      type = v.Type,
      order = v.Order,
      CNYCost = v.Cost,
      USDCost = v["Cost USD"],
      icon = v.Icon,
      limit = v.Limit,
      itemId = v["Item ID"],
      giftType = "impulse_gift",
      giftId = id,
      canUseTicket = true
    }
    ed.RechargeManager:doRecharge(rechargeItem)
  end
end

function RechargeManager:doRechargeForgeQueue(queueId)
  local rechargeId
  local unlockQueueCfg = ed.getDataTable("LegendEquipForgeParam")["Unlock Queue " .. queueId]
  if not unlockQueueCfg then
    return
  end
  local priceType = unlockQueueCfg["Param Content 1"]
  local price = unlockQueueCfg["Param Content 2"]
  if priceType == 1 then
    local point = ed.player:getPoint("diamond")
    if price > point then
      ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
      return
    end
    ed.legendEquipNet.sendUnlockQueue(queueId, price)
  else
    local rt = ed.getDataTable("Recharge")
    for id, row in pairs(rt) do
      if type(id) == "number" then
        local type = row.Type
        if type == "GiftTicket" and row.Cost == price then
          rechargeId = row.ID
        end
      end
    end
    if not rechargeId then
      error("unsupported gift ticket price: " .. price)
      return
    end
    local v = ed.getDataTable(resource_config.rechargecsv or "Recharge")[rechargeId]
    local cost
    if resource_config.recharge_use_locale_cost then
      local localeData = ed.localepurchase.getLocaleProduct(v.ID)
      cost = localeData.cost
    end
    local rechargeItem = {
      id = v.ID,
      pid = v[ed.getIAPTitle()],
      title = v["Display Name"],
      type = v.Type,
      order = v.Order,
      CNYCost = v.Cost,
      USDCost = v["Cost USD"],
      icon = v.Icon,
      limit = v.Limit,
      itemId = v["Item ID"],
      giftType = "forge_queue",
      queueId = queueId,
      canUseTicket = true
    }
    ed.RechargeManager:doRecharge(rechargeItem)
  end
end

function RechargeManager:setNewGiftNotifyFlag(flag)
  self.bNewGiftNotify = flag
end

function RechargeManager:canShowSecretRedTag()
  return self.SecretBoxRedLight
end

function RechargeManager:canShowTabButtonRedTag(key)
  if key == "Month" then
    return ed.player:getPayMonthCardState() == "DRAW" or ed.player:getFreeMonthCardState() == "DRAW"
  elseif key == "Gift" then
    for k, v in ipairs(self.giftItems or {}) do
      if v.bViewFlag and v.classify ~= "CNDOTA" and v.classify ~= "celebration" and v.classify ~= "allstar" and v.classify ~= "FestivalGift" then
        return true
      end
    end
    return false
  elseif key == "ActiveGift" then
    for k, v in ipairs(self.giftItems or {}) do
      if v.bViewFlag and v.classify == "CNDOTA" then
        return true
      end
    end
    return false
  elseif key == "CelebrateGift" then
    for k, v in ipairs(self.giftItems or {}) do
      if v.bViewFlag and v.classify == "celebration" then
        return true
      end
    end
    return false
  elseif key == "AllStarGift" then
    for k, v in ipairs(self.giftItems or {}) do
      if v.bViewFlag and v.classify == "allstar" then
        return true
      end
    end
    return false
  elseif key == "FestivalGift" then
    for k, v in ipairs(self.giftItems or {}) do
      if v.bViewFlag and v.classify == "FestivalGift" then
        return true
      end
    end
    return false
  end
end

function RechargeManager:getMonthCardItems()
  local items = orderItems(self.monthCardItems)
  return items
end

function RechargeManager:getGiftItems()
  local items = {}
  for k, v in ipairs(self.giftItems or {}) do
    if v.type == "once" or v.type == "timely" then
      if v.buyCount < v.buyLimit or self:alwaysShowTimelyGift(v) then
        table.insert(items, v)
      end
    else
      table.insert(items, v)
    end
  end
  table.sort(items, function(e1, e2)
    local function getPrio(e)
      local prio = 1
      
      if e.buyCount >= e.buyLimit and not e.isFreeReward then
        prio = 0
      end
      return prio
    end
    
    local prio1 = getPrio(e1)
    local prio2 = getPrio(e2)
    if prio1 ~= prio2 then
      return prio1 > prio2
    end
    if e1.order and e2.order then
      return e1.order < e2.order
    end
    return e1
  end)
  return items
end

function RechargeManager:handleNewGiftOpenPanel(data)
  self.dayAcc = data._day_acc or 1
  self.freeGroupId = data._free_group or 0
  self.bFreeReward = data._free_reward_flag == self.freeRewardCanLootFlag
  self.dailyGift = data._daily_gifts or {}
  self.weeklyGift = data._weekly_gifts or {}
  self.timelyGifts = data._timely_gifts or {}
  self.onceGifts = data._once_gifts or {}
  self.newGiftsCache = self:formatNewGifts()
  self.giftItems = {}
  for i, v in ipairs(self.newGiftsCache) do
    if v.getLeftTime and 0 >= v.getLeftTime then
    else
      table.insert(self.giftItems, v)
    end
  end
  for k, v in ipairs(self.giftItems) do
    if v.classify == "celebration" then
      FireEvent("RechargeOpenTabIndexNew", true)
    end
    if v.classify == "CNDOTA" then
      FireEvent("RechargeOpenTabIndex", true)
    end
    if v.classify == "allstar" then
      FireEvent("RechargeOpenTabAllStar", true)
    end
    if v.classify == "FestivalGift" then
      FireEvent("RechargeOpenTabFestival", true)
    end
  end
  FireEvent("NewGiftDataReady")
end

function RechargeManager:handleBuyRewardReply(data)
  if data._result == "success" then
    for k, v in ipairs(self.giftItems) do
      if v.giftId == ed.RechargeNetwork.buyGiftId then
        v.buyCount = v.buyCount + 1
        ed.player:addRewards(data._rewards or {})
        ed.UITool.showRewardsFromServer(data._rewards)
        self:buySuccessReply()
        ed.RechargeNetwork.buyGiftId = nil
      end
    end
    FireEvent("NewGiftBought")
  end
end

function RechargeManager:handleViewTimelyReply(data)
end

local function OnSkuItemDetails(jsonstr)
  EDLog("querySkuItemDetails: OnSkuItemDetails->" .. jsonstr)
  local json = require("json/json")
  local SkuItemDetails = json.decode(jsonstr)
  if SkuItemDetails and SkuItemDetails.success then
    if ed.debug_mode then
      ed.showToast("\232\142\183\229\143\150SkuItemsDetails\230\136\144\229\138\159")
    end
    EDLog(string.format("querySkuItemDetails: OnSkuItemDetails-> success:%s, errCode:%d, goods:%d", SkuItemDetails.success and "true" or false, SkuItemDetails.errCode, #SkuItemDetails.goods))
    ed.RechargeManager:initLocalCostWithSkuItemDetails(SkuItemDetails)
  elseif ed.debug_mode then
    ed.showToast(T("\230\179\168\230\132\143\239\188\154\232\142\183\229\143\150SkuItemsDetails\229\164\177\232\180\165!!!"))
  end
end

ListenEvent("SkuItemDetails", OnSkuItemDetails)

function RechargeManager:querySkuItemDetails()
  if ed.isAreaOverSea() then
    local itemIDs = {}
    for k, v in pairs(self.pid_CNYCost) do
      table.insert(itemIDs, k)
    end
    if 20 < #itemIDs then
      print("qurey less than 20 every time!!!", #itemIDs)
      return
    end
    if ed.debug_mode then
      ed.showToast("\229\188\128\229\167\139\232\142\183\229\143\150SkuItemsDetails")
    end
    if EDFLAGANDROID then
      EDAndroidExtra("querySkuItems", ed.getJson({itemIDs = itemIDs}))
    elseif EDFLAGIOS then
      EDIOSExtra("querySkuItems", ed.getJson({itemIDs = itemIDs}))
    else
      local debug_jsonstr = "{\"success\":true,\"errCode\":0,\"goods\":[{\"productId\":\"com.farlightgames.dgame.gp.apac.d201\",\"priceCent\":499,\"formattedPrice\":\"US$4.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5001\",\"priceCent\":99,\"formattedPrice\":\"US$0.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5002\",\"priceCent\":499,\"formattedPrice\":\"US$4.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5003\",\"priceCent\":1499,\"formattedPrice\":\"US$14.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5004\",\"priceCent\":2999,\"formattedPrice\":\"US$29.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5005\",\"priceCent\":4999,\"formattedPrice\":\"US$49.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5006\",\"priceCent\":9999,\"formattedPrice\":\"US$99.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5007\",\"priceCent\":999,\"formattedPrice\":\"US$9.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5008\",\"priceCent\":49,\"formattedPrice\":\"US$0.49\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5011\",\"priceCent\":199,\"formattedPrice\":\"US$1.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5012\",\"priceCent\":29,\"formattedPrice\":\"US$0.29\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5014\",\"priceCent\":1999,\"formattedPrice\":\"US$19.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5015\",\"priceCent\":99,\"formattedPrice\":\"US$0.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5016\",\"priceCent\":499,\"formattedPrice\":\"US$4.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5017\",\"priceCent\":1499,\"formattedPrice\":\"US$14.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5018\",\"priceCent\":2999,\"formattedPrice\":\"US$29.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5019\",\"priceCent\":4999,\"formattedPrice\":\"US$49.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d5020\",\"priceCent\":9999,\"formattedPrice\":\"US$99.99\"},{\"productId\":\"com.farlightgames.dgame.gp.apac.d6001\",\"priceCent\":999,\"formattedPrice\":\"US$9.99\"}]}"
      OnSkuItemDetails(debug_jsonstr)
    end
  end
end

function RechargeManager:onPayResult()
  EDLog("onPayResult")
  ed.RechargeManager.enableRecharge.status = "InBuy"
  ed.RechargeManager.enableRecharge.showText = T("\232\191\152\230\156\137\232\174\162\229\141\149\230\173\163\229\156\168\229\164\132\231\144\134\239\188\140\232\175\183\231\168\141\229\144\142\232\191\155\232\161\140\232\180\173\228\185\176\227\128\130")
  ed.RechargeNetwork:reqRmbData()
  self:loopReqRmbData()
end

function RechargeManager:loopReqRmbData()
  local intervals = {
    2,
    4,
    7,
    10,
    14,
    18,
    23,
    28,
    33,
    38,
    43,
    48
  }
  local interval = 0
  local idx = 1
  local timer = Timer:Times(1, 45)
  timer:setName("rmbQueryData")
  ListenTimer(timer, function()
    interval = interval + 1
    if interval > intervals[idx] then
      idx = idx + 1
      ed.RechargeNetwork:reqRmbData()
    end
  end)
end

function RechargeManager:buySuccessReply(msg)
  ed.RechargeNetwork:sendNewGiftOpenPanel()
  ed.RechargeManager:initItemData()
  ed.RechargeManager.enableRecharge.status = "open"
  ed.RechargeManager.enableRecharge.showText = T("")
  ed.RechargeManager.rechargeItem = nil
  CloseTimer("rmbQueryData")
end

ListenEvent("PayResult", function(msg)
  ed.RechargeManager:onPayResult(msg)
end)
ListenEvent("QueryDataRsp", function()
  ed.RechargeManager:buySuccessReply()
end)
local instance

function RechargeManager.getInstance()
  if not instance then
    instance = RechargeManager.create()
  end
  return instance
end

ed.RechargeManager = RechargeManager.getInstance()
return RechargeManager
