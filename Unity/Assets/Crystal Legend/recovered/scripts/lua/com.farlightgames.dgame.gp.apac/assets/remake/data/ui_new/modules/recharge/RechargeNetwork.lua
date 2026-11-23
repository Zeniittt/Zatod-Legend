local RechargeNetwork = {}
RechargeNetwork.__index = RechargeNetwork
local instance
local printNetData = false
local clickTime = os.time()

function RechargeNetwork.getInstance()
  if not instance then
    instance = RechargeNetwork.create()
  end
  return instance
end

function RechargeNetwork.create()
  local self = {}
  setmetatable(self, RechargeNetwork)
  return self
end

function RechargeNetwork:requestChargeState()
  if not ed.isMainLand() then
    return
  end
  local msg = ed.rechargeNetwork.upmsg.charge_query()
  msg.platform_type = EDSDKType
  if not EDFLAGWIN32 then
    ed.rechargeNetwork.send(msg, "charge_query")
  end
end

function RechargeNetwork:syncLimit()
  local msg = ed.upmsg.recharge_polling()
  local sync = ed.upmsg.recharge_sync()
  sync._types = {
    "recharge_limit"
  }
  msg._sync = sync
  ed.send(msg, "recharge_polling")
end

function RechargeNetwork:reqRmbData(rechargeItem, isUseTicket)
  local rechargeItem = rechargeItem or ed.RechargeManager:getRechargeItem()
  if not rechargeItem then
    return
  end
  ed.RechargeManager.rechargeItem = rechargeItem
  local msg = ed.upmsg.recharge_polling()
  local submit = ed.upmsg.recharge_submit()
  local sync = ed.upmsg.recharge_sync()
  if rechargeItem.inRecharge then
    sync._types = {
      "diamond",
      "recharge_limit"
    }
    if rechargeItem.type == "MonthlyCard" then
      sync._monthcard_types = {}
      table.insert(sync._types, "monthcard")
      table.insert(sync._monthcard_types, "payed")
    elseif rechargeItem.type == "FreeCard" then
      sync._monthcard_types = {}
      table.insert(sync._types, "monthcard")
      table.insert(sync._monthcard_types, "free")
    elseif rechargeItem.type == "Item" then
      sync._item_ids = {}
      table.insert(sync._types, "item")
      table.insert(sync._item_ids, rechargeItem.itemId)
    elseif rechargeItem.type == "Hero" then
      sync._hero_ids = {}
      table.insert(sync._types, "hero")
      table.insert(sync._hero_ids, rechargeItem.itemId)
    end
    if isUseTicket then
      submit._action = "gift_ticket_buy_goods"
      submit._buy_goods_id = rechargeItem.id
      if rechargeItem.useTicketItem then
        submit._ticket_item_id = rechargeItem.equipId
        self.useItemId = submit._ticket_item_id
      else
        submit._ticket_item_id = 0
      end
      msg._submit = submit
    elseif rechargeItem.canUseTicket then
      submit._action = "gift_ticket_buy_goods"
      submit._buy_goods_id = rechargeItem.id
      if rechargeItem.useTicketItem then
        submit._ticket_item_id = rechargeItem.equipId
        self.useItemId = submit._ticket_item_id
      else
        submit._ticket_item_id = 0
      end
      local ticketNum, ticketItemNum, equipId = ed.RechargeManager:getTicketAndTicketEquipNum(rechargeItem.CNYCost)
      if 0 < ticketNum or 0 < ticketItemNum then
        msg._submit = submit
      end
    end
  else
    sync._types = {
      "recharge_limit"
    }
    submit._buy_other = {}
    self.buyGiftId = rechargeItem.giftId
    submit._action = "gift_ticket_buy_other"
    if rechargeItem.giftType == "daily" then
      submit._buy_other._mall_gift_buy_daily = {}
      submit._buy_other._mall_gift_buy_daily._gift_id = rechargeItem.giftId
    elseif rechargeItem.giftType == "weekly" then
      submit._buy_other._mall_gift_buy_weekly = {}
      submit._buy_other._mall_gift_buy_weekly._gift_id = rechargeItem.giftId
    elseif rechargeItem.giftType == "once" then
      submit._buy_other._mall_gift_buy_once = {}
      submit._buy_other._mall_gift_buy_once._gift_id = rechargeItem.giftId
    elseif rechargeItem.giftType == "timely" then
      submit._buy_other._mall_gift_buy_timely = {}
      submit._buy_other._mall_gift_buy_timely._gift_id = rechargeItem.giftId
    elseif rechargeItem.giftType == "pass" then
      submit._buy_other._simple_pass_buy_rank = {}
      submit._buy_other._simple_pass_buy_rank._pass_id = rechargeItem.passId
      submit._buy_other._simple_pass_buy_rank._pass_rank = rechargeItem.passRank
    elseif rechargeItem.giftType == "impulse_gift" then
      submit._buy_other._impulse_gift_buy = {}
      submit._buy_other._impulse_gift_buy._gift_id = rechargeItem.giftId
    elseif rechargeItem.giftType == "forge_queue" then
      submit._buy_other._forge_queue_buy = {}
      submit._buy_other._forge_queue_buy._queue_id = rechargeItem.queueId
    elseif rechargeItem.giftType == "dragon_boat_upgrade" then
      submit._buy_other._dragon_boat_buy_skin = {}
      submit._buy_other._dragon_boat_buy_skin._skin = rechargeItem.skin
    elseif rechargeItem.giftType == "hero_haggle_buy_hero" then
      submit._buy_other._hero_haggle_buy_hero = {}
      submit._buy_other._hero_haggle_buy_hero._hero_id = rechargeItem.hero_id
    end
    if rechargeItem.useTicketItem then
      submit._ticket_item_id = rechargeItem.equipId
      self.useItemId = submit._ticket_item_id
    else
      submit._ticket_item_id = 0
    end
    local ticketNum, ticketItemNum, equipId = ed.RechargeManager:getTicketAndTicketEquipNum(rechargeItem.CNYCost)
    if 0 < ticketNum or 0 < ticketItemNum then
      msg._submit = submit
    end
  end
  msg._sync = sync
  EDLog("========= >>>request data by client")
  ed.send(msg, "recharge_polling")
end

function RechargeNetwork:getRechargePid(id)
  return ed.getDataTable("Recharge")[id][ed.getIAPTitle()]
end

function RechargeNetwork:goRechargeIOS(info)
  local park_env = ed.getChargeENV()
  local pid = self:getRechargePid(info.id)
  local _cost = ed.RechargeManager:getLocalCostByCNYCost(info.CNYCost)
  EDBuyDiamond(1, pid, _cost, info.id, game_server_id, game_server_id, park_env)
end

function RechargeNetwork:goRechargeAndriod(info)
  local itemid = tostring(info.id)
  if os.time() - clickTime < 1 then
    return
  end
  local clickTime = os.time()
  local _cost = ed.RechargeManager:getLocalCostByCNYCost(info.CNYCost)
  local pInfo = {
    cpInfo = {item = itemid, serverid = game_server_id},
    item = itemid,
    id = ed.getUserid(),
    pid = self:getRechargePid(info.id),
    serverid = game_server_id,
    servername = game_server_name,
    itemName = info.title,
    cost = _cost,
    currentCost = _cost,
    userid = ed.getDeviceId(),
    serverip = game_server_ip,
    ip = game_server_ip,
    url = ed.getRechargeURL(),
    level = ed.player:getLevel(),
    roleName = ed.ignoreEmj(ed.player:getName()),
    park_env = ed.getChargeENV()
  }
  EDAndroidPurchase(ed.getJson(pInfo))
end

function RechargeNetwork:dispatchNewGift(msg)
  if printNetData then
  end
  if msg._open_panel then
    ed.RechargeManager:handleNewGiftOpenPanel(msg._open_panel)
  elseif msg._free_reward then
    ed.RechargeManager:handleFreeRewardReply(msg._free_reward)
  elseif msg._buy_daily then
    ed.RechargeManager:handleBuyRewardReply(msg._buy_daily)
  elseif msg._buy_weekly then
    ed.RechargeManager:handleBuyRewardReply(msg._buy_weekly)
  elseif msg._buy_once then
    ed.RechargeManager:handleBuyRewardReply(msg._buy_once)
  elseif msg._buy_timely then
    ed.RechargeManager:handleBuyRewardReply(msg._buy_timely)
  elseif msg._view_timely then
    ed.RechargeManager:handleViewTimelyReply(msg._view_timely)
  elseif msg._error_code then
    ed.RechargeManager:handleNewGiftErrorCode(msg._error_code)
  end
end

function RechargeNetwork:dispatchEnjoyGift(msg)
  if printNetData then
    print("---------------enjoy_gift_reply---------------")
    ed.pt(msg)
  end
  if msg._open then
    if msg._open._gift_type == ed.RechargeManager.GiftType.Enjoy then
      ed.RechargeManager:handleEnjoyGiftOpenReply(msg._open)
    elseif msg._open._gift_type == ed.RechargeManager.GiftType.Dreamland then
      ed.RechargeManager:handleDreamlandGiftOpenReply(msg._open)
    end
  elseif msg._buy then
    ed.RechargeManager:handleEnjoyGiftBuyReply(msg._buy)
  elseif msg._error_code then
    ed.showToast(T("\229\188\130\229\184\184\239\188\154") .. msg._error_code)
  end
end

function RechargeNetwork:sendNewGiftOpenPanel()
  local msg = ed.upmsg.mall_gift_req()
  msg._open_panel = ed.upmsg.mall_gift_open_panel()
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendNewGiftFreeReward(dayAcc)
  local msg = ed.upmsg.mall_gift_req()
  msg._free_reward = ed.upmsg.mall_gift_free_reward()
  msg._free_reward._day_acc = dayAcc
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendNewGiftBuyDaily(giftId)
  local msg = ed.upmsg.mall_gift_req()
  ed.netdata.newGiftIdDaily = giftId
  msg._buy_daily = ed.upmsg.mall_gift_buy_daily()
  msg._buy_daily._gift_id = giftId
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendNewGiftBuyOnce(giftId)
  local msg = ed.upmsg.mall_gift_req()
  ed.netdata.newGiftIdOnce = giftId
  msg._buy_once = ed.upmsg.mall_gift_buy_once()
  msg._buy_once._gift_id = giftId
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendNewGiftBuyWeekly(giftId)
  local msg = ed.upmsg.mall_gift_req()
  ed.netdata.newGiftIdWeekly = giftId
  msg._buy_weekly = ed.upmsg.mall_gift_buy_weekly()
  msg._buy_weekly._gift_id = giftId
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendNewGiftBuyTimely(giftId)
  local msg = ed.upmsg.mall_gift_req()
  ed.netdata.newGiftIdTimely = giftId
  msg._buy_timely = ed.upmsg.mall_gift_buy_timely()
  msg._buy_timely._gift_id = giftId
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendNewGiftViewTimely(giftId)
  local msg = ed.upmsg.mall_gift_req()
  ed.netdata.newGiftIdViewTimely = giftId
  msg._view_timely = ed.upmsg.mall_gift_view_timely()
  msg._view_timely._gift_id = giftId
  ed.send(msg, "mall_gift")
end

function RechargeNetwork:sendGetMonthCardReward(type)
  local msg = ed.upmsg.monthcard_req()
  msg._daily_reward = {}
  msg._daily_reward._types = {type}
  ed.send(msg, "monthcard")
end

function RechargeNetwork:sendOpenSecretBox(type)
  local msg = ed.upmsg.charge_vault_req()
  msg._open_panel = {}
  ed.send(msg, "charge_vault")
end

function RechargeNetwork:sendGetSecretBoxReward(index, isCircle)
  if isCircle then
    local msg = ed.upmsg.charge_vault_req()
    msg._infinite_reward = {}
    ed.send(msg, "charge_vault")
  else
    local msg = ed.upmsg.charge_vault_req()
    msg._gain_reward = {}
    msg._gain_reward._index = index
    ed.send(msg, "charge_vault")
  end
end

function RechargeNetwork:sendOpenEnjoyGift(type)
  local msg = ed.upmsg.impulse_gift_req()
  msg._open = ed.upmsg.impulse_gift_open()
  msg._open._gift_type = type
  ed.send(msg, "impulse_gift")
end

function RechargeNetwork:sendBuyEnjoyGift(giftID)
  local msg = ed.upmsg.impulse_gift_req()
  msg._buy = ed.upmsg.impulse_gift_buy()
  msg._buy._gift_id = giftID
  ed.send(msg, "impulse_gift")
end

function RechargeNetwork:sendViewEnjoyGift(giftID)
  local msg = ed.upmsg.impulse_gift_req()
  msg._view = ed.upmsg.impulse_gift_view()
  msg._view._gift_id = giftID
  ed.send(msg, "impulse_gift")
end

ed.RechargeNetwork = RechargeNetwork.getInstance()
return RechargeNetwork
