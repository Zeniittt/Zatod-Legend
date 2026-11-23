local base = ed.ui.commonscene
local Package = newclass(base.mt)
ed.ui.package = Package
local scope = {}
local lsr = ed.ui.packagelsr.create()

function Package:getCanComposeList()
  local canComposeList = {}
  local list = self.packageList.fragment.all or {}
  for k, v in ipairs(list) do
    local fragmentTb = ed.getDataTable("fragment")
    local amount = ed.player:getEquipAmount(v.id) or 0
    local need = fragmentTb[v.makeId]["Fragment Count"]
    local cost = fragmentTb[v.makeId].Expense
    if amount >= need then
      table.insert(canComposeList, {
        id = v.id,
        amount = amount,
        need = need,
        makeId = v.makeId,
        cost = cost
      })
    end
  end
  return canComposeList
end

function Package:sortFragmentList()
  local tb = self.packageList.fragment.all
  for i = 1, #tb do
    tb[i].orderId = i
  end
  table.sort(tb, function(a, b)
    local fragmentTB = ed.getDataTable("fragment")
    local aAmount = a.amount
    local aNeed = fragmentTB[a.makeId]["Fragment Count"]
    local bAmount = b.amount
    local bNeed = fragmentTB[b.makeId]["Fragment Count"]
    if aAmount < aNeed and bAmount >= bNeed then
      return false
    elseif aAmount >= aNeed and bAmount < bNeed then
      return true
    elseif aAmount >= aNeed and bAmount >= bNeed then
      return a.orderId < b.orderId
    else
      return a.orderId < b.orderId
    end
  end)
end

function Package:sortEquips()
  for k, v in pairs(self.packageList.equip) do
    table.sort(v, ed.cmpSort({
      {
        getValue = function(o)
          if o.category == T("\229\144\136\230\136\144\229\147\129") then
            return 1
          end
          if o.category == T("\233\155\182\228\187\182") then
            return 2
          end
          return 3
        end
      },
      {
        getValue = function(o)
          return ed.readequip.quality(o.id)
        end,
        reverse = true
      },
      {key = "id"}
    }))
  end
end

function Package:RefreshPackage()
  if self.identity == "package" then
    self.ui.bg_sub_tag:setVisible(true)
    self.ui.layer_sub_btn:setVisible(true)
    self.ui.btn_quick_compose:setVisible(false)
  elseif self.identity == "stone" then
    self.ui.bg_sub_tag:setVisible(false)
  elseif self.identity == "fragment" then
    local canComposeList = self:getCanComposeList()
    if #canComposeList == 0 then
      self.ui.bg_sub_tag:setVisible(false)
    else
      self.ui.bg_sub_tag:setVisible(true)
      self.ui.layer_sub_btn:setVisible(false)
      self.ui.btn_quick_compose:setVisible(true)
    end
  elseif self.identity == "equip" then
    self.ui.bg_sub_tag:setVisible(true)
    self.ui.layer_sub_btn:setVisible(true)
    self.ui.btn_quick_compose:setVisible(false)
  end
  for k, v in pairs(self.tbview) do
    if k ~= self.identity then
      v.dragList.listLayer:setVisible(false)
      v.isCanDoScroll = false
    else
      v.dragList.listLayer:setVisible(true)
      v.isCanDoScroll = true
    end
  end
  if self.tbview[self.identity] == nil then
    if self.identity ~= "stone" then
      self:createListLayer()
    else
      self:createStoneDraglist()
      self:refreshStoneDraglist()
    end
  elseif self.identity ~= "stone" then
    if self.identity == "fragment" then
      self:sortFragmentList()
    elseif self.identity == "equip" then
      self:sortEquips()
    end
    self.load_item_list = self.packageList[self.identity][self.clid]
    if #self.load_item_list == 0 then
      self.ui.fox:setVisible(true)
      self.ui.fox_tip:setVisible(true)
      self.ui.bg_detail:setVisible(false)
      self.tbview[self.identity].dragList:clearList()
    else
      self.ui.fox:setVisible(false)
      self.ui.fox_tip:setVisible(false)
      self.ui.bg_detail:setVisible(true)
      self.tbview[self.identity].dragList:setListPos(self.initPos[self.identity])
      self.tbview[self.identity]:staticSync()
    end
  else
    self.ui.bg_detail:setVisible(true)
    self:refreshStoneDraglist()
  end
  self:refreshLeftPanel()
end

function Package:playAttAnim(amount)
  amount = amount or 1
  local effect = ed.createFcaNode("eff_UI_skill_level_up")
  effect:setPosition(ccp(168, 405))
  self.selectCellUI[self.selectData.key]:setVisible(true)
  self.mainLayer:addChild(effect)
  self:addFca(effect)
  local vital = ed.getDataTable("equip")[self.selectData.id].Vitality
  local label = ed.createNode({
    t = "Label",
    base = {
      text = T("\228\189\147\229\138\155+") .. vital * amount,
      size = 20
    },
    layout = {
      position = ccp(168, 405)
    },
    config = {
      color = ccc3(231, 206, 19),
      stroke = {
        color = ccc3(0, 0, 0),
        size = 2
      },
      visible = false
    }
  }, self.mainLayer)
  label:setZOrder(10)
  local a1 = CCDelayTime:create(0)
  local a2 = CCCallFunc:create(function()
    label:setVisible(true)
  end)
  local a3 = CCMoveBy:create(0.5, ccp(0, 15))
  local a4 = CCFadeOut:create(0.1)
  local a5 = CCCallFunc:create(function()
    label:removeFromParentAndCleanup(true)
  end)
  label:runAction(ed.readaction.create({
    t = "seq",
    a1,
    a2,
    a3,
    a4,
    a5
  }))
end

function Package:getUseHandler()
  local function handler(useAmount)
    lsr:report("clickUseProp")
    
    useAmount = useAmount or 1
    local selectId = self.selectData.id
    local insid = self.selectData.insid
    local equip_info = ed.getDataTable("equip")[selectId]
    local vital = equip_info.Vitality
    if vital and 0 < vital then
      local itemInfo = ed.packItem(selectId, useAmount)
      if self.consumeItem then
        return
      end
      self.consumeItem = {
        id = selectId,
        amount = useAmount,
        insid = insid
      }
      CloseEvent("EatVitalitySuccess")
      ListenEventOnce("EatVitalitySuccess", function()
        self.packageList = self.packageItemsSort(ed.player.packageGoods)
        self:playAttAnim(useAmount)
        self:RefreshPackage(true)
      end, scope)
      if insid then
        local msg = ed.upmsg.consume_timely_item()
        msg._insid = insid
        msg._amount = useAmount
        ed.send(msg, "consume_timely_item")
      else
        local msg = ed.upmsg.consume_item()
        msg._item = itemInfo
        ed.send(msg, "consume_item")
      end
      return
    end
    local use_type = equip_info["Use Type"]
    if not use_type then
      ed.showToast(T("\232\175\183\229\142\187\228\184\147\231\148\168\231\149\140\233\157\162\228\189\191\231\148\168\232\175\165\233\129\147\229\133\183\239\188\129"))
    end
    if use_type and use_type == "Open Chest Combination ID" then
      local useTypeNum = equip_info["Use Type Variable"]
      local chestInfo = ed.getDataTable("ChestCombination")[useTypeNum]
      local isChooseBox = chestInfo.IsChooseBox
      if isChooseBox then
        local params = {
          info = chestInfo,
          id = selectId,
          count = useAmount,
          parentLogic = self
        }
        ed.ui.NewItemMultipleChoice.create(params):popWindow()
      else
        self:doOpenBox(selectId, useAmount)
      end
    end
    if use_type and use_type == "MonthCard" then
      local itemInfo = ed.packItem(selectId, useAmount)
      ListenEventOnce("userMonthCard", function(data)
        self:doUseMonthCard(data, selectId, useAmount)
        ed.showToast(T("\230\130\168\232\142\183\229\190\151\228\186\134\230\156\136\229\141\161\239\188\129"))
      end, scope)
      local msg = ed.upmsg.consume_item()
      msg._item = itemInfo
      ed.send(msg, "consume_item")
    end
    if use_type and use_type == "Simple Chest" then
      self:doUseConsumeAddNewItem(useAmount)
    end
  end
  
  return handler
end

function Package:dispatchTimelyGoods(msg)
  if not msg._new_timely_item then
    return
  end
  local timelyTb = ed.getDataTable("TimelyItem")
  local rewards = {}
  for k, v in ipairs(msg._new_timely_item) do
    local itemId = timelyTb[v._timely_id]["Item ID"]
    ed.player:addEquip(itemId, v._amount, v._insid, v._expire_time)
    table.insert(rewards, {
      type = "Item",
      id = itemId,
      amount = v._amount
    })
  end
  if 0 < #rewards then
    ed.announce({
      type = "getProp",
      param = {
        title = T("\228\189\160\232\142\183\229\190\151\228\186\134\230\150\176\231\137\169\229\147\129"),
        items = rewards
      }
    })
  end
end

function Package:doUseMonthCard(data, itemId, amount)
  if not data._error_code then
    if ed.getUserid() then
      local msg = ed.upmsg.ask_monthcard_info()
      ed.send(msg, "ask_monthcard_info")
    end
    self.packageList = self.packageItemsSort(ed.player.packageGoods)
    self:RefreshPackage()
  end
end

function Package:getHeroIdByFragId(fid)
  if fid then
    local frag_info = ed.getDataTable("fragment")
    for frag_idx, item in pairs(frag_info) do
      if fid == item["Fragment ID"] then
        return item["Item ID"]
      end
    end
  end
end

function Package:doOpenBox(itemId, useAmount)
  if self.consumeItem then
    return
  end
  self.consumeItem = {id = itemId, amount = useAmount}
  
  function ed.netreply.openSimpleChestReply(data)
    ed.player:consumeEquip(itemId, useAmount)
    ed.record:useItemCount(itemId, useAmount)
    self:handleRewards(data._rewards or {})
    self.packageList = self.packageItemsSort(ed.player.packageGoods)
    self:RefreshPackage(true)
    self.consumeItem = nil
  end
  
  local itemInfo = ed.packItem(itemId, useAmount)
  local msg = ed.upmsg.consume_item()
  msg._item = itemInfo
  ed.send(msg, "consume_item")
end

local function getPosAndHide(ui, key)
  local x, y = ui[key]:getPosition()
  ui[key]:setVisible(false)
  return ccp(x, y)
end

function Package.createExpireTimeIcon(param)
  local id, insid, time = param.id, param.insid, param.time
  local expireTime, expireTimeBg
  if time then
    expireTime = time
  else
    expireTime = id and ed.player:getExpireTimeByInsid(id, insid) or 0
  end
  expireTimeBg = ed.createSprite("UI/alpha/1080P/package/bg_time.png")
  expireTimeBg:setPosition(ccp(30, 70))
  local iconTime
  local labelTimeStr = T("\229\183\178\232\191\135\230\156\159")
  if 0 < expireTime - ed.getServerTime() then
    labelTimeStr = ed.time2dhmOnly(expireTime - ed.getServerTime())
  end
  local labelTime = ed.createLabelTTF(labelTimeStr, 14)
  if expireTime - ed.getServerTime() < 259200 then
    ed.setLabelColor(labelTime, ccc3(255, 108, 108))
    ed.setLabelStroke(labelTime, ccc3(85, 26, 12), 2)
    iconTime = ed.createSprite("UI/alpha/1080P/package/icon_time.png")
  else
    ed.setLabelColor(labelTime, ccc3(119, 255, 84))
    ed.setLabelStroke(labelTime, ccc3(23, 49, 31), 2)
    iconTime = ed.createSprite("UI/alpha/1080P/package/icon_time1.png")
    iconTime:setRotation(-30)
  end
  iconTime:setPosition(ccp(9, 8))
  expireTimeBg:addChild(iconTime)
  labelTime:setAnchorPoint(ccp(0, 0.5))
  labelTime:setPosition(ccp(18, 9))
  expireTimeBg:addChild(labelTime)
  return expireTimeBg
end

function Package:refreshLeftPanel()
  if not self.selectData then
    self.ui.bg_detail:setVisible(false)
    return
  end
  local id = self.selectData.id
  local insid = self.selectData.insid
  local amount = ed.player:getNewEquipAmount(id, insid) or 0
  if amount <= 0 and self.identity ~= "stone" then
    self.ui.bg_detail:setVisible(false)
    return
  else
    self.ui.bg_detail:setVisible(true)
    self.ui.btn_use:setVisible(true)
    self.ui.btn_soldout:setVisible(true)
    self.ui.bg_soldout:setVisible(true)
  end
  if self.selectData.state == "inOperable" then
    self.ui.btn_use:setVisible(false)
  elseif self.selectData.state == "evolve" then
    self.ui.Label_51:setString(T("\229\141\135\230\152\159"))
  elseif self.selectData.state == "summon" then
    self.ui.Label_51:setString(T("\229\143\172\229\148\164"))
  elseif self.identity == "fragment" then
    self.ui.Label_51:setString(T("\229\144\136\230\136\144"))
  elseif ed.getDataTable("equip")[id]["Consume Type"] == "\229\164\167\232\161\165\228\184\184" or ed.getDataTable("equip")[id]["Consume Type"] == "\233\154\143\230\156\186\229\174\157\231\174\177" then
    self.ui.Label_51:setString(T("\228\189\191\231\148\168"))
  else
    self.ui.btn_use:setVisible(false)
  end
  if not tolua.isnull(self.selectCellUI[self.selectData.key]) then
    self.selectCellUI[self.selectData.key]:setVisible(true)
  end
  local icon = ed.readequip.createIcon(id)
  icon:setPosition(getPosAndHide(self.ui, "icon_item"))
  self.ui.icon_item = icon
  self.ui.bg_main_attr:addChild(icon)
  if insid then
    local expireTimeBg = self.createExpireTimeIcon({id = id, insid = insid})
    icon:addChild(expireTimeBg)
  end
  self.ui.label_name:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.label_name, ccc3(39, 37, 36), 2)
  self.ui.label_name:setZOrder(10)
  self.ui.label_name:setString(ed.readequip.value(id, "Name") or "")
  self.ui.label_name:limitWidthByScale(self.ui.bg_detail:getContentSize().width * 0.62)
  local amountStr = T("<lable color=ccc3(107,97,81)>\230\140\129\230\156\137\239\188\154</lable><lable color=ccc3(44,82,167)>%d</lable>", amount)
  if ed.readequip.value(self.id, "Category") == T("\231\129\181\233\173\130\231\159\179") then
    local heroId = ed.readhero.getMakeid(self.id)
    local hero = ed.player.heroes[heroId]
    if not hero or hero and hero._stars < 5 then
      local stoneNeed = ed.readhero.getStoneNeed(heroId) or 9999999
      amountStr = T("<lable color=ccc3(107,97,81)>\230\140\129\230\156\137\239\188\154</lable><lable color=ccc3(44,82,167)>%d/%d</lable>", amount, stoneNeed)
    end
  end
  local autoTextLabel = ed.ui.autoText.new()
  autoTextLabel:initParam({
    context = amountStr,
    fontSize = 14,
    align = "CENTER",
    maxWidth = self.ui.amount:getContentSize().width
  })
  self.ui.amount:removeAllChildrenWithCleanup(true)
  self.ui.amount:addChild(autoTextLabel.node)
  autoTextLabel.node:setPositionY(self.ui.amount:getContentSize().height / 2)
  if self.identity == "stone" then
    self.ui.btn_info:setVisible(false)
    self.ui.btn_soldout:setVisible(false)
    self.ui.bg_soldout:setVisible(false)
  else
    self.ui.btn_info:setVisible(false)
    local type, price
    if ed.getDataTable("equip")[id].Category == "\231\172\166\230\150\135\231\159\179" then
      type = ed.getDataTable("equip")[id]["Contain Type1"]
    else
      type = ed.getDataTable("equip")[id]["Sell Price Type"]
    end
    if type ~= "Gold" and type ~= "Diamond" then
      self.ui.btn_soldout:setVisible(false)
      self.ui.bg_soldout:setVisible(false)
    else
      price = ed.getDataTable("equip")[id]["Sell Price"]
      if 0 < price then
        self.ui.bg_soldout:removeAllChildrenWithCleanup(true)
        local str
        if type == "Gold" then
          str = string.format("<sprite src=UI/alpha/1080P/icon/gold.png scale=0.8>" .. "<lable color=ccc3(195,117,16) strokeColor=strokeColor1 strokeSize=1>%d</lable>", price)
        else
          str = string.format("<sprite src=UI/alpha/1080P/icon/diamond.png scale=0.8>" .. "<lable color=ccc3(195,117,16) strokeColor=strokeColor1 strokeSize=1>%d</lable>", price)
        end
        local autoText = ed.ui.autoText.new()
        autoText:initParam({context = str, fontSize = 15})
        local width = autoText:getCurContentSize()
        autoText.node:setPosition(ccp(60 - width / 2, 12))
        self.ui.bg_soldout:addChild(autoText.node)
      else
        self.ui.btn_soldout:setVisible(false)
        self.ui.bg_soldout:setVisible(false)
      end
    end
  end
  if self.ui.btn_use:isVisible() and (self.ui.btn_soldout:isVisible() or self.ui.btn_info:isVisible()) then
    self.ui.btn_use:setPositionX(self.usePosX)
    self.ui.btn_soldout:setPositionX(self.soldPosX)
    self.ui.bg_soldout:setPositionX(self.soldPosX)
    self.ui.btn_info:setPositionX(self.soldPosX)
  elseif self.ui.btn_use:isVisible() then
    self.ui.btn_use:setPositionX(self.soldPosX / 2 + self.usePosX / 2)
  elseif self.ui.btn_soldout:isVisible() then
    self.ui.btn_soldout:setPositionX(self.soldPosX / 2 + self.usePosX / 2)
    self.ui.bg_soldout:setPositionX(self.soldPosX / 2 + self.usePosX / 2)
  else
    self.ui.btn_info:setPositionX(self.soldPosX / 2 + self.usePosX / 2)
  end
  local desc = ed.readequip.getDescriptionNew(id)
  self.attrDraglist:clearList()
  local size = self.ui.layer_attr:getContentSize()
  local hei = 0
  for i = 1, #desc do
    local container = CCNode:create()
    local ui = {}
    ui.container = container
    local readnode = ed.readnode.create(container, ui)
    readnode:addNode(ed.uieditor.attr_item)
    ed.setString(ui.label_attr, desc[i][1])
    local normalHei = 25
    if ui.label_attr:getContentSize().width > 150 then
      local bgSize = ui.bg:getContentSize()
      ed.adaptLabel(ui.label_attr, {maxWidth = 150})
      ui.bg:setContentSize(CCSizeMake(bgSize.width, ui.label_attr:getContentSize().height + 5))
      normalHei = ui.label_attr:getContentSize().height + 5
    end
    hei = hei + normalHei
    ed.setString(ui.label_num, desc[i][2] or "")
    ui.bg:setVisible(i % 2 == 0)
    container:setPosition(ccp(15, size.height - hei + normalHei * 0.5))
    self.attrDraglist:addItem(container)
  end
  local desStr = ed.readequip.value(id, "Description")
  local commentStr = ed.readequip.value(id, "Comment")
  local posY = hei + 10
  if desStr and commentStr then
    local desLabel = ed.createLabelTTF(desStr, 15)
    desLabel:setAnchorPoint(ccp(0, 0.5))
    desLabel:setColor(ccc3(61, 48, 36))
    desLabel:setDimensions(CCSizeMake(240, 0))
    desLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = desLabel:getContentSize().height
    local width = desLabel:getContentSize().width
    desLabel:setPosition(ccp(4, size.height - (posY + height / 2)))
    self.attrDraglist:addItem(desLabel)
    posY = posY + height + 4
    local commentLabel = ed.createLabelTTF(commentStr, 15)
    commentLabel:setColor(ccc3(108, 92, 77))
    commentLabel:setDimensions(CCSizeMake(240, 0))
    commentLabel:setAnchorPoint(ccp(0, 0.5))
    commentLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    height = commentLabel:getContentSize().height
    width = desLabel:getContentSize().width
    commentLabel:setPosition(ccp(4, size.height - (posY + height / 2)))
    self.attrDraglist:addItem(commentLabel)
    posY = posY + height + 4
  elseif desStr then
    local desLabel = ed.createLabelTTF(desStr, 15)
    desLabel:setColor(ccc3(61, 48, 36))
    desLabel:setAnchorPoint(ccp(0, 0.5))
    desLabel:setDimensions(CCSizeMake(240, 0))
    desLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = desLabel:getContentSize().height
    local width = desLabel:getContentSize().width
    desLabel:setPosition(ccp(4, size.height - (posY + height / 2)))
    self.attrDraglist:addItem(desLabel)
    posY = posY + height + 4
  elseif commentStr then
    local commentLabel = ed.createLabelTTF(commentStr, 15)
    commentLabel:setColor(ccc3(61, 48, 36))
    commentLabel:setAnchorPoint(ccp(0, 0.5))
    commentLabel:setDimensions(CCSizeMake(240, 0))
    commentLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = commentLabel:getContentSize().height
    local width = commentLabel:getContentSize().width
    commentLabel:setPosition(ccp(4, size.height - (posY + height / 2)))
    self.attrDraglist:addItem(commentLabel)
    posY = posY + height + 4
  end
  local getWay = ed.packageGetWay(id)
  self.getWayItemList = {}
  if 0 < #getWay then
    posY = posY + 10
    local equipSource = ed.createSprite("UI/alpha/1080P/package/new/equip_source.png")
    local equipSourceLabel = ed.createLabelTTF(T("\232\142\183\229\143\150\233\128\148\229\190\132"), 15)
    local width = equipSourceLabel:getContentSize().width
    local height = equipSourceLabel:getContentSize().height
    equipSourceLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    equipSourceLabel:setColor(ccc3(61, 48, 36))
    equipSourceLabel:setPosition(ccp(30 + width / 2, size.height - (posY + height / 2)))
    equipSource:setPosition(ccp(20, size.height - (posY + height / 2)))
    self.attrDraglist:addItem(equipSource)
    self.attrDraglist:addItem(equipSourceLabel)
    posY = posY + height + 4
  end
  for index, data in ipairs(getWay or {}) do
    local container, ui = self:createGetWayItem(data)
    local width = container:getContentSize().width
    local height = container:getContentSize().height
    container:setPosition(ccp(size.width / 2, size.height - (posY + height / 2)))
    self.attrDraglist:addItem(container)
    posY = posY + height + 1
    table.insert(self.getWayItemList, {
      container = container,
      ui = ui,
      data = data
    })
  end
  self.attrDraglist:initListHeight(posY)
end

function Package:doCompose()
  local fragmentTb = ed.getDataTable("fragment")
  local amount = ed.player:getEquipAmount(self.selectData.id) or 0
  local need = fragmentTb[self.selectData.makeId]["Fragment Count"]
  local cost = fragmentTb[self.selectData.makeId].Expense
  if amount < need then
    ed.showToast(T("\231\162\142\231\137\135\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\239\188\129"))
    return
  end
  if cost > ed.player._money then
    ed.showHandyDialog("useMidas")
    return
  end
  if ed.player:hasMaxAmount(self.selectData.makeId) then
    ed.showToast(T("\231\137\169\229\147\129\229\183\178\232\190\190\230\156\128\229\164\167\230\149\176\233\135\143\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\227\128\130"))
    return
  end
  ed.netdata.fragmentCompose = {
    id = self.selectData.id,
    fragmentAmount = need,
    cost = cost,
    makeId = self.selectData.makeId,
    composeResultAmount = 1
  }
  ed.netreply.composeFragmentReply = self:doComposeReply()
  local msg = ed.upmsg.fragment_compose()
  msg._fragment = self.selectData.makeId
  msg._frag_amount = need
  msg._compose_amount = 1
  ed.send(msg, "fragment_compose")
end

function Package:doComposeReply()
  local function handler(reply)
    if not self then
      return
    end
    if reply then
      local makeId = ed.netdata.fragmentCompose.makeId
      local amount = ed.netdata.fragmentCompose.composeResultAmount
      ed.announce({
        type = "getProp",
        param = {
          title = T("\228\189\160\232\142\183\229\190\151\228\186\134\230\150\176\231\137\169\229\147\129"),
          items = {
            {
              type = "Item",
              id = makeId,
              amount = amount
            }
          }
        }
      })
      self.packageList = self.packageItemsSort(ed.player.packageGoods)
      self:RefreshPackage()
    else
      lsr:report("craftFailed")
      ed.showToast(T("\229\144\136\230\136\144\229\164\177\232\180\165"))
    end
  end
  
  return handler
end

function Package:createEquipIcon(data)
  local id, amount, expireTime, insid = data.id, data.amount, data.expireTime, data.insid
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local icon = ed.readequip.createIcon(id)
  icon:setAnchorPoint(ccp(0, 0))
  container:addChild(icon)
  if insid then
    local expireTimeBg = self.createExpireTimeIcon({id = id, insid = insid})
    icon:addChild(expireTimeBg)
  end
  local selectFrame = ed.createSprite("UI/alpha/1080P/package/icon_selected.png")
  selectFrame:setAnchorPoint(ccp(0, 0))
  selectFrame:setPosition(ccp(-4.5, -5.5))
  selectFrame:setVisible(false)
  icon:addChild(selectFrame)
  self.selectCellUI[data.key] = selectFrame
  local amount = amount
  if 1 < amount then
    local amountLabel = ed.getNumberNode({
      text = amount,
      folder = "prop_amount",
      padding = -1
    }).node
    amountLabel:setAnchorPoint(ccp(1, 0))
    local center = ed.getCenterPos(icon)
    local size = icon:getContentSize()
    amountLabel:setScale(1.3)
    amountLabel:setPosition(ccpAdd(center, ccp(34, -36)))
    icon:addChild(amountLabel)
  end
  container.bg = icon
  local data = {
    id = id,
    insid = insid,
    key = data.key,
    bg = icon
  }
  return container, data
end

function Package:createFragmentIcon(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.package_fragment)
  ed.setLabelStroke(ui.label_percent, ed.toccc3(2565412), 1)
  local icon = ed.readequip.createIcon(data.id)
  icon:setPositionY(13)
  icon:setAnchorPoint(ccp(0, 0))
  container:addChild(icon)
  ui.percent:setPositionX(ui.percent:getPositionX())
  local selectFrame = ed.createSprite("UI/alpha/1080P/package/fragment_selected.png")
  selectFrame:setAnchorPoint(ccp(0, 0))
  selectFrame:setPosition(ccp(-4.5, -5.5))
  selectFrame:setVisible(false)
  icon:addChild(selectFrame)
  local info = {}
  local needAmount = ed.getDataTable("fragment")[data.makeId]["Fragment Count"]
  ed.setString(ui.label_percent, string.format("%d/%d", data.amount, needAmount))
  local scale = math.min(1, data.amount / needAmount)
  if scale == 1 then
    local iconCanCompose = ed.createSprite("UI/alpha/1080P/package/selected.png")
    iconCanCompose:setPosition(25, 25)
    iconCanCompose:setScale(0.7)
    icon:addChild(iconCanCompose)
  end
  ui.percent:setScaleX(scale)
  container.bg = icon
  self.selectCellUI[data.key] = selectFrame
  return container, {
    id = data.id,
    bg = icon,
    key = data.key,
    makeId = data.makeId
  }
end

function Package:createIconSelectFrame()
  local selectFrame = ed.createSprite("UI/alpha/1080P/package/hero_selected.png")
  selectFrame:setAnchorPoint(ccp(0, 0))
  selectFrame:setZOrder(10)
  selectFrame:setVisible(false)
  selectFrame:setPosition(ccp(-10, 3.2))
  return selectFrame
end

function Package:createStoneIcon(id)
  local container, ui = ed.editorui(ed.uieditor.package_stone)
  ed.setLabelStroke(ui.label_percent, ed.toccc3(2565412), 1)
  local head, heroIcon
  local stoneAmount = ed.readhero.getStoneAmount(id)
  local stoneNeed = ed.readhero.getStoneNeed(id) or 9999999
  local stars = ed.lookupDataTable("Unit", "Initial Stars", id) or 1
  if ed.player.heroes[id] then
    head = ed.readhero.createIconByID(id, {state = "idle"})
  else
    head = ed.readhero.createIcon({
      id = id,
      rank = 1,
      stars = stars,
      withShade = stoneAmount < stoneNeed
    })
  end
  heroIcon = head.icon
  heroIcon:setPosition(getPosAndHide(ui, "frame"))
  local selectFrame = self:createIconSelectFrame()
  container:addChild(selectFrame)
  local state = "inOperable"
  if stoneAmount >= stoneNeed then
    if not ed.player.heroes[id] then
      head.stars[1]:getParent():setZOrder(10)
      local effect
      if ed.isAreaZh() then
        effect = ed.createFcaNode("eff_UI_bag_summon")
      else
        effect = ed.createFcaNode("eff_UI_bag_summon_Globe")
        local label = ed.createLabelTTF(T("\229\143\175\229\143\172\229\148\164"), 15, ed.fontBold)
        ed.setLabelColor(label, ed.toccc3(16769529))
        ed.setLabelStroke(label, ed.toccc3(10559136), 1)
        ed.adaptLabel(label, {maxWidth = 80, minScale = 0.8})
        local label_node = CCSprite:create()
        label_node:addChild(label)
        effect:addNodeToComponent(label_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      end
      effect:setPosition(ccp(36.5, 32.2))
      effect:setZOrder(6)
      heroIcon:addChild(effect)
      self:addFca(effect)
      state = "summon"
    else
      head.stars[1]:getParent():setZOrder(10)
      local effect3 = ed.createFcaNode("eff_UI_bag_evolve_bg")
      effect3:setPosition(ccp(35.5, 13))
      heroIcon:addChild(effect3)
      self:addFca(effect3)
      local effect2
      if ed.isAreaZh() then
        effect2 = ed.createFcaNode("eff_UI_bag_evolve_title")
      else
        effect2 = ed.createFcaNode("eff_UI_bag_evolve_title_Globe")
        local label = ed.createLabelTTF(T("\229\143\175\229\141\135\230\152\159"), 15, ed.fontBold)
        ed.setLabelColor(label, ed.toccc3(16776073))
        ed.setLabelStroke(label, ed.toccc3(10113285), 1)
        label:limitWidthByScale(80)
        local label_node = CCSprite:create()
        label_node:addChild(label)
        effect2:addNodeToComponent(label_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      end
      container:addChild(effect2, 6)
      effect2:setPosition(ccp(40, 78))
      self:addFca(effect2)
      state = "evolve"
    end
  end
  ed.below2(ui.bg_percent, heroIcon, 10)
  ui.bg_percent:setPositionX(5)
  local scale = stoneAmount / stoneNeed
  if 1 < scale then
    scale = 1
  end
  ui.percent:setScaleX(scale)
  if stoneNeed == 9999999 then
    ui.percent:setVisible(false)
    ui.label_percent:setVisible(false)
    ui.icon_stone:setVisible(false)
    local autoStr = string.format(T("<lable color=defaultColor>\229\183\178\230\139\165\230\156\137:</lable><lable color=headlineYellow>%d</lable>"), stoneAmount)
    local autoText = ed.ui.autoText.new()
    autoText:initParam({context = autoStr, fontSize = 12})
    autoText:limitWidthByScale(ui.bg_percent:getContentSize().width)
    local posX, posY = ui.label_percent:getPosition()
    autoText.node:setPosition(ccp(posX - autoText:getCurContentSize() / 2, posY))
    ui.bg_percent:addChild(autoText.node)
  else
    ed.setString(ui.label_percent, string.format(T("%d/%d"), stoneAmount, stoneNeed))
  end
  self.selectCellUI[ed.readhero.getStoneid(id)] = selectFrame
  container:addChild(heroIcon)
  ui.bg = heroIcon
  return container, ui, state
end

function Package:loadEquip(index)
  if index < 1 then
    return
  end
  local list = self.load_item_list
  if index > #list then
    return nil
  end
  local data = list[index]
  if self.identity == "package" then
    return self:createEquipIcon(data)
  elseif self.identity == "fragment" then
    return self:createFragmentIcon(data)
  elseif self.identity == "equip" then
    return self:createEquipIcon(data)
  end
end

function Package:onPress(x, y)
  for k, ui in pairs(self.tbview[self.identity].cellsUsed) do
    local node = ui.data.bg
    if ed.containsPoint(node, x, y) then
      return k
    end
  end
  return nil
end

function Package:getPressHandler()
  local function handler(x, y)
    return self:onPress(x, y)
  end
  
  return handler
end

function Package:onClick(x, y, k)
  local ui = self.tbview[self.identity].cellsUsed[k]
  local node = ui.data.bg
  if ed.containsPoint(node, x, y) then
    if not tolua.isnull(self.selectCellUI[self.selectData.key]) then
      self.selectCellUI[self.selectData.key]:setVisible(false)
    end
    self.selectData = ui.data
    self.selectCellUI[self.selectData.key]:setVisible(true)
    self:refreshLeftPanel()
  end
end

function Package:getClickHandler()
  local function handler(x, y, k)
    self:onClick(x, y, k)
  end
  
  return handler
end

function Package:createStoneDraglist()
  local left_x = 0
  local frameSize = self.ui.main_frame:getContentSize()
  local iconWidth = 80
  local minGapX = 2
  local dragWidth = frameSize.width - 30
  self.colNum = math.floor(dragWidth / iconWidth)
  if dragWidth % iconWidth < (self.colNum + 1) * minGapX then
    self.colNum = self.colNum - 1
  end
  local info = {
    cliprect = CCRectMake(15, 15, dragWidth, frameSize.height - 25),
    container = self.ui.main_frame,
    touchpriority = 5,
    zorder = 10,
    doPressIn = self:getPressHandler(),
    doClickIn = self:getClickHandler(),
    noshade = true
  }
  self.draglist = ed.draglist.create(info)
  self.tbview.stone = {
    dragList = self.draglist
  }
end

function Package:getStoneList()
  local all = ed.readhero.classify("all", "position")
  local heroList = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  local unHeroList = {}
  for i = 1, #all do
    local tid = all[i]._tid
    local initStar = ed.getDataTable("Unit")[tid]["Initial Stars"]
    local id = ed.readhero.getStoneid(tid)
    local stoneAmount = ed.readhero.getStoneAmount(tid)
    local stoneNeed = ed.readhero.getStoneNeed(tid) or 9999999
    local onlineTime = ed.dateStringToTime(ed.getDataTable("Unit")[tid]["Online Time"])
    local item = {
      id = id,
      makeId = tid,
      amount = stoneAmount,
      need = stoneNeed,
      onlineTime = onlineTime
    }
    if not ed.player.heroes[tid] then
      if stoneAmount < stoneNeed then
        table.insert(unHeroList, item)
      else
        table.insert(heroList[initStar], item)
      end
    else
      table.insert(heroList[initStar], item)
    end
  end
  return heroList, unHeroList
end

function Package:getHeroStoneData()
  self.heroList, self.unHeroList = self:getStoneList()
  for i = 1, 3 do
    table.sort(self.heroList[i], function(a, b)
      local aAmount = a.amount
      local aNeed = a.need
      local bAmount = b.amount
      local bNeed = b.need
      local aCanEvl = aAmount >= aNeed and 1 or 0
      local bCanEvl = bAmount >= bNeed and 1 or 0
      if aCanEvl == 1 and ed.player.heroes[a.makeId] then
        aCanEvl = 2
      end
      if bCanEvl == 1 and ed.player.heroes[b.makeId] then
        bCanEvl = 2
      end
      if aCanEvl ~= bCanEvl then
        return aCanEvl > bCanEvl
      elseif a.onlineTime ~= b.onlineTime then
        return a.onlineTime < b.onlineTime
      else
        return a.makeId < b.makeId
      end
    end)
  end
  table.sort(self.unHeroList, function(a, b)
    local aNeed = a.need
    local bNeed = b.need
    if aNeed > bNeed then
      return true
    elseif aNeed < bNeed then
      return false
    else
      return a.makeId < b.makeId
    end
  end)
end

function Package:refreshStoneDraglist()
  self:getHeroStoneData()
  self.tbview[self.identity].dragList:clearList()
  local frameSize = self.ui.main_frame:getContentSize()
  local dragWidth = frameSize.width - 30
  local dragHeight = frameSize.height
  local dx, dy = 80, 110
  local gapX = (dragWidth - self.colNum * dx) / (self.colNum + 1)
  local ox, oy = 16 + gapX, dragHeight - dy
  local i = 1
  
  local function getPos(isSep)
    local pos
    if isSep then
      if i == 1 then
        pos = ccp(frameSize.width / 2, oy + 73)
        oy = oy - 40
      else
        pos = ccp(frameSize.width / 2, oy - 36)
        oy = oy - dy - 40
      end
      ox = 16 + gapX
      i = 1
    else
      pos = ccp(ox, oy)
      if i < self.colNum then
        ox = ox + dx + gapX
        i = i + 1
      else
        ox = 16 + gapX
        oy = oy - dy
        i = 1
      end
    end
    return pos
  end
  
  local uiList = {}
  local cellData = {}
  local titleText = {
    [1] = T("\229\136\157\229\167\139\228\184\128\230\152\159"),
    [2] = T("\229\136\157\229\167\139\228\186\140\230\152\159"),
    [3] = T("\229\136\157\229\167\139\228\184\137\230\152\159")
  }
  for i = 3, 1, -1 do
    local heroes = self.heroList[i]
    if heroes and 0 < #heroes then
      local container = self:createStoneSegTitle(titleText[i])
      container:setPosition(getPos(true))
      self.draglist:addItem(container)
      for k, v in ipairs(heroes) do
        local container, ui, state = self:createStoneIcon(v.makeId)
        container:setPosition(getPos(false))
        self.draglist:addItem(container)
        table.insert(cellData, {
          data = {
            id = v.id,
            bg = ui.bg,
            makeId = v.makeId,
            key = v.id,
            state = state
          }
        })
        table.insert(uiList, ui)
      end
    end
  end
  if 0 < #self.unHeroList then
    local container, ui = ed.editorui(ed.uieditor.package_stone_deco)
    ui.container = container
    container:setPosition(getPos(true))
    self.draglist:addItem(container)
    for k, v in ipairs(self.unHeroList) do
      local container, ui = self:createStoneIcon(v.makeId)
      container:setPosition(getPos(false))
      self.draglist:addItem(container)
      table.insert(cellData, {
        data = {
          id = v.id,
          bg = ui.bg,
          amount = v.amount,
          makeId = v.makeId,
          key = v.id,
          state = "inOperable"
        }
      })
      table.insert(uiList, ui)
    end
  end
  local initPosX, initPosxY = self.draglist:getListPos()
  self.initPos[self.identity] = ccp(initPosX, initPosxY)
  if i == 1 then
    oy = oy + dy
  end
  self.draglist:initListHeight(dragHeight - oy)
  self.tbview.stone.cellsUsed = cellData
  if self.stoneOldPos then
    self.tbview[self.identity].dragList:setListPos(self.stoneOldPos)
  end
end

function Package:createListLayer()
  self.load_item_list = self.packageList[self.identity][self.clid]
  local frameSize = self.ui.main_frame:getContentSize()
  local frameWidth = frameSize.width
  local draglistWidth = frameWidth - 20
  local iconWidth = 87
  local iconHeight = iconWidth
  local colNum = math.floor(draglistWidth / iconWidth)
  iconWidth = iconWidth + (draglistWidth - iconWidth * colNum) / (colNum + 1)
  local draglistOx = self.ui.main_frame:getPositionX() - iconWidth * colNum / 2 + 4
  local draglistOy = 80
  local fixdraglistWidth = iconWidth * colNum
  local fixdraglistHeight = 390
  if self.identity == "package" then
  elseif self.identity == "fragment" then
    iconHeight = iconHeight + 14
    self:sortFragmentList()
  elseif self.identity == "equip" then
    self:sortEquips()
  end
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.load_item_list
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(iconWidth, iconHeight)
  end
  
  function dlgt.createCell(idx)
    return self:loadEquip(idx)
  end
  
  function dlgt.syncCell(cell, idx)
    return self:loadEquip(idx)
  end
  
  function dlgt.doPressIn(cell)
  end
  
  function dlgt.doClickIn(cell)
    local data = cell.data
    lsr:report("clickProp")
    if not tolua.isnull(self.selectCellUI[self.selectData.key]) then
      self.selectCellUI[self.selectData.key]:setVisible(false)
    end
    self.selectData = data
    self.selectCellUI[self.selectData.key]:setVisible(true)
    self:refreshLeftPanel()
  end
  
  function dlgt.cancelClickIn(cell)
  end
  
  function dlgt.cancelPressIn(cell)
  end
  
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(draglistOx, draglistOy, fixdraglistWidth, fixdraglistHeight),
    container = self.mainLayer,
    touchpriority = 5,
    zorder = 10,
    noshade = true,
    dragMode = 1,
    colNum = colNum
  }
  local tb_view = Tableview.create(param)
  local initPosX, initPosxY = tb_view.dragList:getListPos()
  self.initPos[self.identity] = ccp(initPosX, initPosxY)
  self.tbview[self.identity] = tb_view
end

function Package:consumeThenAddNewItem(reply)
  if not reply._items then
    return
  end
  local items = {}
  for _, v in pairs(reply._items) do
    local item = ed.analyzeItem(v)
    table.insert(items, {
      type = "Item",
      id = item.id,
      amount = item.amount
    })
  end
  local config = {
    type = "getProp",
    param = {
      title = T("\230\130\168\232\142\183\229\190\151\231\137\169\229\147\129\239\188\154"),
      items = items
    }
  }
  ed.announce(config)
end

function Package:handleRewards(rewards)
  ed.player:addRewards(rewards)
  local items = {}
  for k, v in ipairs(rewards) do
    table.insert(items, {
      type = v._type,
      id = v._id,
      amount = v._amount
    })
  end
  ed.ui.maillocalbox.create({type = "addItem", item = items}):popWindow()
end

function Package:doUseConsumeAddNewItem(useAmount)
  local itemID = self.selectData.id
  if self.consumeItem then
    return
  end
  self.consumeItem = {id = itemID, amount = useAmount}
  ListenEventOnce("ConsumeAddNewitems", function(data)
    self:consumeThenAddNewItem(data)
    self.packageList = self.packageItemsSort(ed.player.packageGoods)
    self:RefreshPackage(true)
  end, scope)
  
  function ed.netreply.openSimpleChestReply(data)
    ed.player:consumeEquip(itemID, useAmount)
    ed.record:useItemCount(itemID, useAmount)
    self:handleRewards(data._rewards or {})
    self.packageList = self.packageItemsSort(ed.player.packageGoods)
    self:RefreshPackage(true)
    self.consumeItem = nil
  end
  
  local itemInfo = ed.packItem(itemID, useAmount)
  local msg = ed.upmsg.consume_item()
  msg._item = itemInfo
  ed.send(msg, "consume_item")
end

function Package:createAttrListLayer()
  self.attrDraglist = ed.UITool.createDraglist(self.ui.layer_attr, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    priority = -300
  })
end

function Package:doPressInList()
  local function handler(x, y)
    for k, item in pairs(self.getWayItemList or {}) do
      local ui = item.ui
      
      local container = ui.container
      local data = item.data
      if data.state == "Normal" and ed.containsPoint(ui.bg, x, y) then
        container:setScale(0.95)
        return item
      end
    end
  end
  
  return handler
end

function Package:doClickInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    local container = item.container
    local data = item.data
    local ui = item.ui
    if ed.containsPoint(ui.bg, x, y) then
      self:clickGetWay(data)
    end
  end
  
  return handler
end

function Package:cancelPressInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    local container = item.container
    if container then
      container:setScale(1)
    end
  end
  
  return handler
end

function Package:onExitPackage()
  CloseScope(scope)
end

function Package:doSummonReply(tid)
  local function handler(result)
    if not result then
      lsr:report("summonFailed")
    else
      lsr:report("summonSuccess")
      if tolua.isnull(self.mainLayer) then
        return
      end
      self.selectData.state = "evolve"
      self.packageList = self.packageItemsSort(ed.player.packageGoods)
      self:RefreshPackage(true)
      ed.ui.SummonRewardCardWindow.create({
        rewards = {
          {
            id = tid,
            amount = 1,
            type = "hero"
          }
        },
        noRewards = true
      }):popWindow()
    end
  end
  
  return handler
end

function Package:doSummon(tid)
  local cost = ed.readhero.getSummonCost(tid)
  if cost > ed.player._money then
    ed.showHandyDialog("useMidas")
    return
  end
  ed.netdata.evolve = {
    cost = cost,
    id = ed.readhero.getStoneid(tid),
    amount = ed.readhero.getStoneNeed(tid),
    hid = tid
  }
  ed.netreply.evolve = self:doSummonReply(tid)
  local msg = ed.upmsg.hero_evolve()
  msg._heroid = tid
  ed.send(msg, "hero_evolve")
end

function Package:doEvolveReply(tid)
  local function handler(result)
    if not result then
      ed.showToast(T("\232\139\177\233\155\132\232\191\155\229\140\150\229\164\177\232\180\165"))
    else
      lsr:report("evolveReply")
      ed.announce({
        type = "heroEvolve",
        param = {
          id = tid,
          preAtt = self.attBeforeEvolve
        }
      })
      if ed.readhero.checkHeroMaxStar(tid) then
        self.selectData.state = "inOperable"
      end
      self.packageList = self.packageItemsSort(ed.player.packageGoods)
      self:RefreshPackage(true)
    end
  end
  
  return handler
end

function Package:doUse()
  local id = self.selectData.id
  local insid = self.selectData.insid
  local selectEquip = ed.getDataTable("equip")[id]
  if selectEquip.Vitality > 0 and ed.player:getVitality() + selectEquip.Vitality >= ed.parameter.max_vitality_stock then
    ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    return
  end
  if insid then
    local expireTime = ed.player:getExpireTimeByInsid(id, insid)
    if expireTime and 0 > expireTime - ed.getServerTime() then
      ed.showToast(T("\233\129\147\229\133\183\229\183\178\232\191\135\230\156\159"))
      return
    end
  end
  local handler = self:getUseHandler()
  if selectEquip["Can Batch Use"] then
    local param = {
      id = id,
      callback = handler,
      insid = insid
    }
    local window = ed.ui.batchUse.create(param)
    window:popWindow()
  else
    handler()
  end
end

function Package:onClickSummon()
  local tid = self.selectData.makeId
  local eno = ed.readhero.checkStoneEnough(tid)
  if self.tbview[self.identity] then
    local x, y = self.tbview[self.identity].dragList:getListPos()
    self.stoneOldPos = ccp(x, y)
  end
  if eno then
    if not ed.player.heroes[tid] then
      local cost = ed.readhero.getSummonCost(tid)
      if cost > ed.player._money then
        ed.showHandyDialog("useMidas")
        return
      end
      local info = {
        autoText = string.format(T("\229\143\172\229\148\164\232\139\177\233\155\132\233\156\128\232\166\129\232\138\177\232\180\185<lable color=headlineOrange>%d</lable>\233\135\145\229\184\129\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"), cost),
        rightHandler = function()
          self:doSummon(tid)
        end
      }
      ed.showConfirmDialog(info)
    else
      local sa, sn = ed.readhero.getStoneAmount(tid), ed.readhero.getStoneNeed(tid)
      if sa < sn then
        ed.showToast(T("\231\129\181\233\173\130\231\159\179\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\191\155\229\140\150"))
        return
      end
      local cost = ed.heroDetailManager:getHeroEvolveCost(tid)
      if cost > ed.player._money then
        ed.showHandyDialog("useMidas")
        return
      end
      ed.netdata.evolve = {
        hid = tid,
        id = ed.readhero.getStoneid(tid),
        amount = sn,
        cost = cost
      }
      ed.netreply.evolve = self:doEvolveReply(tid)
      self.attBeforeEvolve = ed.readhero.getHeroAtt(tid)
      ed.ui.heroDetailEvolveWin.create({
        hero = ed.player.heroes[tid],
        callback = function()
          local msg = ed.upmsg.hero_evolve()
          msg._heroid = tid
          ed.send(msg, "hero_evolve")
        end
      })
    end
  else
    ed.showToast(T("\231\162\142\231\137\135\228\184\141\232\182\179"))
  end
end

function Package:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_soldout", function()
    local itemid = self.selectData.id
    local type = ed.getDataTable("equip")[itemid]["Sell Price Type"]
    if (type == "Gold" or type == "Diamond") and ed.getDataTable("equip")[itemid]["Sell Price"] > 0 then
      ed.ui.PackagSoldoutWin.create({
        id = itemid,
        callback = function()
          self.packageList = self.packageItemsSort(ed.player.packageGoods)
          self:RefreshPackage(true)
        end
      }):popWindow()
    else
      ed.showToast(T("\230\178\161\230\156\137\229\149\134\228\186\186\230\132\191\230\132\143\230\148\182\232\180\173\232\191\153\231\167\141\231\137\169\229\147\129"))
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_quick_compose", function()
    self.load_item_list = self.packageList[self.identity][self.clid] or {}
    local canComposeList = self:getCanComposeList()
    if #canComposeList == 0 then
      ed.showToast(T("\230\178\161\230\156\137\231\162\142\231\137\135\229\143\175\229\144\136\230\136\144"))
    else
      local composeWin = ed.ui.PackageComposeWin.create({
        canComposeList = canComposeList,
        callback = function()
          self.packageList = self.packageItemsSort(ed.player.packageGoods)
          self:RefreshPackage(true)
        end
      })
      composeWin:popWindow(500)
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_use", function()
    if self.identity == "package" then
      self:doUse()
    elseif self.identity == "stone" then
      self:onClickSummon()
    elseif self.identity == "fragment" then
      self:doCompose()
    elseif self.identity == "equip" then
      self:doUse()
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_goods", function()
    self.clid = "all"
    self.identity = "package"
    self:refreshBtn()
    self:RefreshPackage()
    self:selectFirstOne()
    self:setSubBtn()
    self:refreshSubBtn("all", "tag_selected0")
  end, {})
  ed.UITool.registerBtn(self, "btn_fragment", function()
    self.clid = "all"
    self.identity = "fragment"
    self:refreshBtn()
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "btn_equipment", function()
    if self.identity == "package" then
      self.clid = self.lastClid
    end
    self.clid = "all"
    self.identity = "equip"
    self:refreshBtn()
    self:RefreshPackage()
    self:selectFirstOne()
    self:setSubBtn()
    self:refreshSubBtn("all", "tag_selected0")
  end, {})
  ed.UITool.registerBtn(self, "btn_stone", function()
    self.clid = "all"
    self.identity = "stone"
    self:refreshBtn()
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "tag0", function()
    self:refreshSubBtn("all", "tag_selected0")
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "tag1", function()
    local subType = self.identity == "package" and "Normal" or "Composite"
    self:refreshSubBtn(subType, "tag_selected1")
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "tag2", function()
    local subType = self.identity == "package" and "Activity" or "Spare"
    self:refreshSubBtn(subType, "tag_selected2")
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "tag3", function()
    local subType = self.identity == "package" and "Treasure" or "Reel"
    self:refreshSubBtn(subType, "tag_selected3")
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "tag4", function()
    self:refreshSubBtn("Ugc", "tag_selected4")
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "tag5", function()
    self:refreshSubBtn("Develop", "tag_selected5")
    self:RefreshPackage()
    self:selectFirstOne()
  end, {})
  ed.UITool.registerBtn(self, "btn_info", function()
    ed.showToast("\229\190\133\229\129\154 \232\139\177\233\155\132\232\175\166\230\131\133\230\159\165\231\156\139")
  end, {})
end

function Package:setSubBtn()
  local isGoods = self.identity == "package"
  ed.setString(self.ui.label_tag1, isGoods and T("\229\184\184\232\167\132") or T("\229\144\136\230\136\144\229\147\129"))
  ed.setString(self.ui.label_tag2, isGoods and T("\230\180\187\229\138\168") or T("\233\155\182\228\187\182"))
  ed.setString(self.ui.label_tag3, isGoods and T("\232\180\181\233\135\141") or T("\229\141\183\232\189\180"))
  self.ui.tag0:setPositionX(isGoods and -137.5 or -82.5)
  self.ui.tag1:setPositionX(isGoods and -82.5 or -27.5)
  self.ui.tag2:setPositionX(isGoods and -27.5 or 27.5)
  self.ui.tag3:setPositionX(isGoods and 27.5 or 82.5)
  self.ui.tag4:setVisible(isGoods)
  self.ui.tag5:setVisible(isGoods)
end

function Package:refreshSubBtn(clid, btn)
  self.clid = clid
  self.selectedCild:setVisible(false)
  self.selectedCild = self.ui[btn]
  self.selectedCild:setVisible(true)
end

function Package:refreshBtn()
  local btnName = "btn_" .. self.btnList[self.identity] .. "_selected"
  self.selectedBtn:setVisible(false)
  self.selectedBtn = self.ui[btnName]
  self.selectedBtn:setVisible(true)
end

function Package:initData()
  self.selectCellUI = {}
  self.btnList = {
    package = "goods",
    stone = "stone",
    equip = "equipment",
    fragment = "fragment"
  }
  self.packageClidList = {
    all = 0,
    Normal = 1,
    Activity = 2,
    Treasure = 3,
    Ugc = 4,
    Develop = 5
  }
  self.equipClidList = {
    all = 0,
    Composite = 1,
    Spare = 2,
    Reel = 3
  }
  self.tbview = {}
  self.initPos = {}
  self.packageList = self.packageItemsSort(ed.player.packageGoods)
end

function Package:selectFirstOne()
  if self.selectData and not tolua.isnull(self.selectCellUI[self.selectData.key]) then
    self.selectCellUI[self.selectData.key]:setVisible(false)
  end
  if #self.tbview[self.identity].cellsUsed > 0 then
    self.ui.bg_detail:setVisible(true)
    self.selectData = self.tbview[self.identity].cellsUsed[1].data
    self:refreshLeftPanel()
    self.ui.fox:setVisible(false)
    self.ui.fox_tip:setVisible(false)
  else
    self.ui.bg_detail:setVisible(false)
    self.ui.fox:setVisible(true)
    self.ui.fox_tip:setVisible(true)
  end
end

function Package:refreshLabel()
  ed.setLabelStroke(self.ui.label_money, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_goods_selected, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_fragment_selected, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_equipment_selected, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_stone_selected, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_stone, ccc3(56, 38, 34), 2)
  ed.setLabelStroke(self.ui.label_equipment, ccc3(56, 38, 34), 2)
  ed.setLabelStroke(self.ui.label_fragment, ccc3(56, 38, 34), 2)
  ed.setLabelStroke(self.ui.label_goods, ccc3(56, 38, 34), 2)
  ed.setLabelStroke(self.ui.label_tag0, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_tag1, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_tag2, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_tag3, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_tag4, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_tag5, ccc3(0, 0, 0), 2)
  ed.setLabelShadow(self.ui.Label_51, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.Label_50, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelStroke(self.ui.Label_56, ccc3(144, 85, 15), 1)
  ed.setLabelStroke(self.ui.Label_1799, ccc3(39, 37, 36), 2)
end

function Package:initUI()
  local readnode = ed.readnode.create(self.mainLayer, self.ui)
  readnode:addNode(ed.uieditor.package)
  self:setBackground("UI/alpha/1080P/bg/herolist_bg.png")
  local rightBoundary = 40
  local leftBoundary = 60
  local btnWidth = 64.5
  local gap = -6
  local fixMainFrameWidth = ed.display.winSize.width - leftBoundary - rightBoundary - btnWidth - gap - self.ui.bg_detail:getContentSize().width
  local contentSize = self.ui.main_frame:getContentSize()
  local mainFrameHeight = contentSize.height
  local scaleX = fixMainFrameWidth / contentSize.width
  self.ui.main_frame:setContentSize(CCSizeMake(fixMainFrameWidth, mainFrameHeight))
  local posX, posY = self.ui.main_frame:getPosition()
  ed.layout.layoutWithMagin(self.ui.main_frame, {
    right = rightBoundary + btnWidth
  })
  ed.layout.layoutWithMagin(self.ui.bg_detail, {left = leftBoundary})
  self.ui.layer_button:setPositionX(self.ui.layer_button:getPositionX() * scaleX)
  self.ui.fox:setPositionX(82)
  self.ui.fox_tip:setPosition(ed.getCenterPos(self.ui.main_frame))
  self.ui.bg_sub_tag:setPositionX(fixMainFrameWidth / 2)
  for _, name in pairs(self.btnList) do
    ed.adaptLabel(self.ui["label_" .. name], {maxWidth = 63, minScale = 0.7})
    ed.adaptLabel(self.ui["label_" .. name .. "_selected"], {maxWidth = 63, minScale = 0.7})
  end
  for i = 0, 5 do
    ed.adaptLabel(self.ui["label_tag" .. i], {maxWidth = 50, minScale = 0.7})
  end
  local selectBtnName = "btn_" .. self.btnList[self.identity] .. "_selected"
  self.selectedBtn = self.ui[selectBtnName]
  self.selectedBtn:setVisible(true)
  if self.identity == "package" then
    local selectClidUIName = "tag_selected" .. self.packageClidList[self.clid]
    self.selectedCild = self.ui[selectClidUIName]
  elseif self.identity == "equip" then
    local selectClidUIName = "tag_selected" .. self.equipClidList[self.clid]
    self.selectedCild = self.ui[selectClidUIName]
  end
  self.usePosX = self.ui.btn_use:getPositionX()
  self.soldPosX = self.ui.btn_soldout:getPositionX()
  if self.identity ~= "stone" then
    self:createListLayer()
  else
    self:createStoneDraglist()
    self:refreshStoneDraglist()
  end
  self:createAttrListLayer()
  self:refreshLabel()
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:selectFirstOne()
end

function Package:refreshTimeUI()
  for i, data in ipairs(self.autoRefreshUI) do
    if data.expireTime < ed.getServerTime() then
      ed.setString(data.ui, "\229\183\178\232\191\135\230\156\159")
    else
      ed.setString(data.ui, getTimeStr(data.expireTime))
    end
  end
end

function Package:registerEvents()
  ListenEvent("PackageRefresh", function()
    self.packageList = self.packageItemsSort(ed.player.packageGoods)
    self:RefreshPackage(true)
  end, scope)
  ListenEvent("ConsumeItemSuccess", function()
    if self.consumeItem then
      ed.record:useItemCount(self.consumeItem.id, self.consumeItem.amount)
      ed.player:consumeEquip(self.consumeItem.id, self.consumeItem.amount, self.consumeItem.insid)
      self.consumeItem = nil
    end
  end, scope)
end

function Package:createGetWayItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "Normal" then
    readnode:addNode(ed.uieditor.accessNormalItem)
    ui.btn_go:setPositionX(200)
  elseif data.state == "Special" then
    readnode:addNode(ed.uieditor.accessSpecialItem)
  else
    readnode:addNode(ed.uieditor.accessLockItem)
    ui.label_lock:setPositionX(200)
    ui.label_lock:setHorizontalAlignment(kCCTextAlignmentCenter)
    ed.adaptLabel(ui.label_lock, {
      maxWidth = 45,
      minScale = 0.7,
      maxHeight = 60
    })
  end
  ui.bg:setContentSize(CCSizeMake(227, 46))
  container:setContentSize(ui.bg:getContentSize())
  ed.setString(ui.label_info, data.name)
  ed.setLabelStroke(self.ui.label_info, ccc3(255, 252, 231), 1)
  ed.adaptLabel(ui.label_info, {maxWidth = 160, minScale = 0.7})
  return container, ui
end

function Package:clickGetWay(data)
  if data.type == "stage" then
    local scene = ed.ui.stageselect.createByStage(data.id)
    ed.pushScene(scene)
    local panel = ed.ui.stagedetail.create(data.id):popWindow()
    ed.stageSelectParam = nil
  elseif data.type == "summon" then
    ed.summonMgr.noBottomButton = true
    ed.UITool.openView("summonScene")
  elseif data.type == "skillTower" then
    ed.UITool.openView("SkillTowerScene", data.id)
  elseif data.type == "shop" then
    local page = data.id
    local shopVisible = ed.shopData:getShopVis(page)
    if shopVisible then
      ed.UITool.openView("shopMain", {page = page})
    else
      ed.showToast(T("\229\149\134\229\186\151\230\156\170\229\188\128\230\148\190"))
    end
  elseif data.type == "heroExercise" then
    ed.exerciseManager:openExerciseMainScene()
  elseif data.type == "task" then
    ed.UITool.openView("taskScene", {})
  elseif data.type == "awakeDungeon" then
    ed.UITool.openView("awakeDungeonScene")
  elseif data.type == "nianMonster" then
    ed.UITool.openView("nianMonsterMainScene")
  elseif data.type == "chat" then
    ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.world_channel)
  elseif data.type == "NewYearDaysLogin" then
    local actId
    if ed.activityHints.data:getActivityIsOpenById(85) then
      actId = 85
    elseif ed.activityHints.data:getActivityIsOpenById(94) then
      actId = 94
    end
    ed.UITool.openView("activityScene", {actId = actId})
  elseif data.type == "CDKey" then
    if not ed.getPopWindow("playerInfoWindow") then
      ed.ui.playerInfoWindow.create():popWindow()
    end
  elseif data.type == "growPlan" then
    ed.UITool.openView("activityScene", {openActType = "grow_plan"})
  elseif data.type == "RechargeScene" then
    ed.pushScene(ed.ui.RechargeScene.create({page = "Gift"}))
  elseif data.type == "rogueMainScene" then
    ed.UITool.openView("rogueMainScene")
  elseif data.type == "fireForgeMainScene" then
    ed.UITool.openView("fireForgeMainScene")
  elseif data.type == "latestStageScene" then
    ed.UITool.openView("stageSelect")
  elseif data.type == "skillTowerMainScene" then
    ed.UITool.openView("SkillTowerScene", data.id)
  elseif data.type == "legendEquipShopScene" then
    ed.UITool.openView("legendEquipShopScene")
  elseif data.type == "dayAwardsScene" then
    ed.UITool.openView("dayAwardsScene", {})
  end
end

function Package.packageItemsSort(data)
  local data = ed.copyTable(data)
  
  local function sortFunc(a, b)
    local sub = {
      Activity = 1,
      Treasure = 2,
      Normal = 3,
      Develop = 4,
      Ugc = 5
    }
    if sub[ed.readequip.value(a.id, "Sub Tab")] == sub[ed.readequip.value(b.id, "Sub Tab")] then
      if ed.readequip.value(a.id, "Can Batch Use") == ed.readequip.value(b.id, "Can Batch Use") then
        return a.order > b.order
      else
        return ed.readequip.value(a.id, "Can Batch Use")
      end
    else
      return sub[ed.readequip.value(a.id, "Sub Tab") or "Normal"] < sub[ed.readequip.value(b.id, "Sub Tab") or "Normal"]
    end
  end
  
  table.sort(data.package.all, sortFunc)
  table.sort(data.package.Activity, sortFunc)
  table.sort(data.package.Treasure, sortFunc)
  table.sort(data.package.Normal, sortFunc)
  table.sort(data.package.Develop, sortFunc)
  table.sort(data.package.Ugc, sortFunc)
  return data
end

function Package.create(identity, clid)
  local self
  self = base.create(identity)
  self.identity = identity or "package"
  setmetatable(self, Package.mt)
  self.clid = clid
  if not self.clid then
    self.clid = "all"
  end
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerOnExitHandler("onExitPackage", function()
    self:onExitPackage()
  end)
  self:registerOnEnterHandler("onEnterPackage", function()
    self:registerEvents()
    ed.ui.packageExpireWin.checkExpireItem()
    if self.identity == "stone" then
      self:refreshStoneDraglist()
    end
  end)
  return self
end

function Package:createStoneSegTitle(text)
  local bg = ed.createSprite("UI/alpha/1080P/common/soul_stone_title_bg.png")
  local txt = ed.createLabelTTF(text, 15)
  ed.setLabelColor(txt, ed.toccc3(16776423))
  ed.setLabelStroke(txt, ed.toccc3(4932150), 2)
  bg:addChild(txt)
  ed.layout.centerInParent(txt)
  return bg
end
