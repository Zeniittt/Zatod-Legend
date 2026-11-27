local class = newclass("g")
ed.legendEquipMgr = class
class.instance = nil

function class.getInstance()
  if not class.instance then
    class.instance = class.create()
  end
  return class.instance
end

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
  self.legendEquipData = {}
  self.legendEquipQueueData = {}
  self.wishData = {}
  self.handBookData = {}
  self.normalTimes = 0
  self.firstOnlyTimes = 0
  self:initRedDot()
  self:addEventListen()
end

function class:initRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("fire_forge_entry", self, {
    notImmediately = true,
    handle = function(value)
      FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.LegendEquipForge)
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.FIRE_FORGE)
    end
  })
end

function class:getNewLegendEquipTypeList()
  local newEquipIdList = ed.getDataTable("LegendEquipForgeParam")["New Equip ID"]["Param Content 3"]
  return newEquipIdList or {}
end

function class:checkNewLegendEquip(key)
  local newEquipIdList = self:getNewLegendEquipTypeList()
  local value = ed.storage.getString(ed.getRoleKey(key))
  return table.concat(newEquipIdList, "-") ~= value
end

function class:saveNewLegendEquipTypeList(key)
  local newEquipIdList = self:getNewLegendEquipTypeList()
  ed.storage.setValue(ed.getRoleKey(key), table.concat(newEquipIdList, "-"))
end

function class:addEventListen()
  ListenEvent("ResourceNumChange", function(resType, id)
    if resType == "item" then
      local typeId = ed.legendEquipTool.getTypeIdByFragmentId(id)
      if typeId and 0 < typeId then
        self:refreshComposeRedDot()
      end
    end
  end)
end

function class:getHandBookByTypeId(typeId)
  return self.handBookData[typeId]
end

function class:initLegendEquip(legendEquips)
  for index, equip in ipairs(legendEquips or {}) do
    self:addEquip(equip, false)
  end
end

function class:initQueueData(queues)
  self.legendEquipQueueData = {}
  for _, queue in ipairs(queues or {}) do
    queue._forge_list = queue._forge_list or {}
    self.legendEquipQueueData[queue._queue_id] = queue
  end
end

function class:getLeftResetTimes()
  return self.leftResetTimes or 0
end

function class:getNormalTimes()
  return self.normalTimes
end

function class:setNormalTimes(times)
  self.normalTimes = times
end

function class:getFirstOnlyTimes()
  return self.firstOnlyTimes
end

function class:initWishData(wishes)
  self.wishData = {}
  for _, wish in ipairs(wishes or {}) do
    local wishType = wish._wish_type
    local equipIds = wish._wish_list
    self.wishData[wishType] = equipIds
  end
end

function class:getLegendEquip(id)
  return self.legendEquipData[id]
end

function class:getAllLegendEquip()
  return self.legendEquipData
end

function class:getLegendEquipByTypeId(typeId)
  local list = {}
  for id, legendEquip in pairs(self.legendEquipData) do
    if legendEquip._type_id == typeId then
      table.insert(list, legendEquip)
    end
  end
  return list
end

function class:getLegendEquipAmount()
  local amount = 0
  for _, _ in pairs(self.legendEquipData) do
    amount = amount + 1
  end
  return amount
end

function class:getLegendEquipAmountByTypeId(typeId)
  return #self:getLegendEquipByTypeId(typeId)
end

function class:getCanCostEquipAmount(targetTypeId, ignoreId)
  local amount = 0
  for id, equip in pairs(self.legendEquipData) do
    local typeId = equip._type_id
    local star = equip._star
    local rank = equip._rank
    local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
    if typeId == targetTypeId and star == legendEquipCfg["Basic Star"] and rank == legendEquipCfg["Basic Rank"] and (not equip._carried_hero_id or equip._carried_hero_id == 0) and id ~= ignoreId then
      amount = amount + 1
    end
  end
  return amount
end

function class:getCanUseEquip()
  local canUseEquip = {}
  for id, equip in pairs(self.legendEquipData) do
    if self:checkEquipCanUse(id) then
      table.insert(canUseEquip, equip)
    end
  end
  return canUseEquip
end

function class:setLegendEquipDiscard(id, isDiscard)
  local legendEquip = self:getLegendEquip(id)
  legendEquip._is_discard = isDiscard
  self:updateLegendEquip(legendEquip)
end

function class:updateLegendEquip(legendEquip)
  local id = legendEquip._id
  self.legendEquipData[id] = legendEquip
  FireEvent("UpdateLegendEquip", id)
  FireEvent("ChangeLegendEquip")
end

function class:updateHeroLegendEquip(legendEquip, param)
  param = param or {}
  local heroId = param.heroId
  local gs = param.gs
  local reason = param.reason
  heroId = heroId or legendEquip._carried_hero_id
  local hero = ed.player:getHero(heroId)
  if not hero then
    return
  end
  if heroId == legendEquip._carried_hero_id then
    hero:updateLegendEquip(legendEquip)
  else
    hero:deleteLegendEquip()
  end
  if gs then
    hero:resetgs(gs)
  end
  FireEvent("UpdateHeroLegendEquip", heroId, reason)
end

function class:addEquip(equip, isNew)
  local id = equip._id
  self.legendEquipData[id] = equip
  self.redPointMgr:addNode("new_legend_equip_" .. id, {
    "fire_forge_package_entry_new_equip"
  }, isNew and 1 or 0)
end

function class:deleteEquip(id, isFireEvent)
  self.legendEquipData[id] = nil
  self.redPointMgr:deleteNode("new_legend_equip_" .. id)
  if isFireEvent then
    FireEvent("DeleteLegendEquip", id)
    FireEvent("ChangeLegendEquip")
  end
end

function class:checkEquipCanUse(id)
  local equip = self:getLegendEquip(id)
  if not equip then
    return false
  end
  if not equip._carried_hero_id or equip._carried_hero_id == 0 then
    return true
  end
  return false
end

function class:getHeroLegendEquip(heroId)
  local hero = ed.player:getHero(heroId)
  if not hero then
    return
  end
  return hero._legend_equip
end

function class:updateForgeQueue(queue)
  local queueId = queue._queue_id
  self.legendEquipQueueData[queueId] = queue
  queue._forge_list = queue._forge_list or {}
  self:refreshForgeRedDot()
  FireEvent("FireForgeUpdateQueue", queueId)
end

function class:updateAllForgeQueue(queues)
  self:initQueueData(queues)
  self:refreshForgeRedDot()
  FireEvent("FireForgeUpdateQueue")
end

function class:getAllForgeQueue()
  return self.legendEquipQueueData
end

function class:getForgeQueueByQueueId(queueId)
  return self.legendEquipQueueData[queueId]
end

function class:getForgeNeedItemAmount()
  local forgeNeedCfg = ed.getDataTable("LegendEquipForgeParam")["Forge Need"]
  local itemId = forgeNeedCfg["Param Content 1"]
  local itemAmount = ed.player:getEquipAmount(itemId)
  return itemAmount, forgeNeedCfg["Param Content 2"]
end

function class:getWishByType(wishType)
  return self.wishData[wishType]
end

function class:getForgeItemStateAmount(queueId)
  local queueList
  if queueId then
    queueList = {
      self:getForgeQueueByQueueId(queueId)
    }
  else
    queueList = self:getAllForgeQueue()
  end
  local idleAmount = 0
  local workingAmount = 0
  local finishAmount = 0
  local serverTime = ed.getServerTime()
  for _, queue in pairs(queueList) do
    local unlockPosList = queue._unlock_pos
    local forgeList = queue._forge_list
    local unlockPosAmount = 0
    for index, unlockPos in ipairs(unlockPosList) do
      if unlockPos == 1 then
        unlockPosAmount = unlockPosAmount + 1
      end
    end
    idleAmount = idleAmount + (unlockPosAmount - #forgeList)
    for index, forgeItem in ipairs(forgeList) do
      if serverTime >= forgeItem._end_time then
        finishAmount = finishAmount + 1
      else
        if serverTime >= forgeItem._start_time then
          workingAmount = workingAmount + 1
        else
        end
      end
    end
  end
  return idleAmount, workingAmount, finishAmount
end

function class:refreshAllRedDot()
  self:refreshForgeRedDot()
  self:refreshComposeRedDot()
end

function class:refreshForgeRedDot()
  local curItemAmount, needAmount = self:getForgeNeedItemAmount()
  local _, _, finishForgeItemAmount = self:getForgeItemStateAmount()
  local emptyForgeItemAmount = 0
  for queueId, _ in ipairs(ed.getDataTable("LegendEquipForgeQueue")) do
    local queue = self:getForgeQueueByQueueId(queueId)
    if 2 <= queueId and queue then
      local unlockPosList = queue._unlock_pos
      local forgeList = queue._forge_list
      local unlockPosAmount = 0
      for index, unlockPos in ipairs(unlockPosList) do
        if unlockPos == 1 then
          unlockPosAmount = unlockPosAmount + 1
        end
      end
      emptyForgeItemAmount = emptyForgeItemAmount + (unlockPosAmount - #forgeList)
      if 0 < emptyForgeItemAmount then
        break
      end
    end
  end
  self.redPointMgr:setNodeValue("fire_forge_overview_finish", finishForgeItemAmount, true)
  if needAmount <= curItemAmount and 0 < emptyForgeItemAmount then
    self.redPointMgr:setNodeValue("fire_forge_overview_empty", true, true)
  else
    self.redPointMgr:setNodeValue("fire_forge_overview_empty", false, true)
  end
end

function class:refreshComposeRedDot()
  local canCompose = false
  for typeId, legendEquipCfg in ipairs(ed.getDataTable("LegendEquip")) do
    local isOnly = legendEquipCfg["Is Only"]
    local needFrameAmount = legendEquipCfg["Fragment Amount"]
    local frameId = legendEquipCfg["Fragment Item"]
    local curTypeEquipAmount = #self:getLegendEquipByTypeId(typeId)
    local ownFrameAmount = ed.player:getEquipAmount(frameId)
    if needFrameAmount <= ownFrameAmount then
      if isOnly and curTypeEquipAmount == 0 then
        canCompose = true
      elseif not isOnly then
        canCompose = true
      end
    end
    if canCompose then
      break
    end
  end
  self.redPointMgr:setNodeValue("fire_forge_package_compose", canCompose)
end

function class:handleItemNotify(_legend_equip_item_notify)
  local legendEquips = _legend_equip_item_notify._legend_equips
  for index, legendEquip in ipairs(legendEquips or {}) do
    self:addEquip(legendEquip, true)
  end
  self.redPointMgr:getNode("fire_forge_package_entry_new_equip"):visit()
  FireEvent("ChangeLegendEquip")
end

function class:handleNotify(_legend_equip_notify)
  local forge = _legend_equip_notify._forge
  local lottery = _legend_equip_notify._lottery
  local firstOpenPanel = _legend_equip_notify._first_open_panel
  self.redPointMgr:setNodeValue("fire_forge_overview_empty", forge)
  self.redPointMgr:setNodeValue("fire_forge_overview_finish", lottery)
  self.redPointMgr:setNodeValue("fire_forge_first_open_panel", firstOpenPanel)
  self:refreshComposeRedDot()
end

function class:handleEquip(_equip)
  local legendEquip = _equip._legend_equip
  local heroGs = _equip._hero_gs
  self:updateLegendEquip(legendEquip)
  self:updateHeroLegendEquip(legendEquip, {reason = "equip", gs = heroGs})
end

function class:handleUnEquip(_unequip)
  local legendEquip = _unequip._legend_equip
  local heroGs = _unequip._hero_gs
  local heroId = _unequip._hero_id
  self:updateLegendEquip(legendEquip)
  self:updateHeroLegendEquip(legendEquip, {
    reason = "unequip",
    gs = heroGs,
    heroId = heroId
  })
  FireEvent("UnequipLegendEquip")
end

function class:handleStarUp(_starup)
  local legendEquip = _starup._legend_equip
  local heroGs = _starup._hero_gs
  local item = _starup._items
  local gold = _starup._gold or 0
  local costEquips = _starup._cost_equips or {}
  for k, v in pairs(item or {}) do
    local id = v._id
    local amount = v._amount
    ed.player:consumeEquip(id, amount)
  end
  ed.player:addMoney(-gold)
  for index, costLegendEquip in ipairs(costEquips) do
    self:deleteEquip(costLegendEquip._id, false)
  end
  self:updateLegendEquip(legendEquip)
  self:updateHeroLegendEquip(legendEquip, {reason = "star_up", gs = heroGs})
end

function class:handleRankUp(_rankup)
  local legendEquip = _rankup._legend_equip
  local heroGs = _rankup._hero_gs
  local item = _rankup._items
  local gold = _rankup._gold or 0
  local costEquips = _rankup._cost_equips or {}
  for k, v in pairs(item or {}) do
    local id = v._id
    local amount = v._amount
    ed.player:consumeEquip(id, amount)
  end
  ed.player:addMoney(-gold)
  for index, costLegendEquip in ipairs(costEquips) do
    self:deleteEquip(costLegendEquip._id, false)
  end
  self:updateLegendEquip(legendEquip)
  self:updateHeroLegendEquip(legendEquip, {reason = "rank_up", gs = heroGs})
end

function class:handleRecycle(_recycle)
  local idList = _recycle._ids
  local rewards = _recycle._return_items or {}
  for index, id in ipairs(idList or {}) do
    self:deleteEquip(id, false)
  end
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  FireEvent("ChangeLegendEquip")
end

function class:handleForgeEquip(_forge_equip)
  local queueId = _forge_equip._queue_id
  local item = _forge_equip._item
  local costItemList = _forge_equip._cost_items
  local task = _forge_equip._task
  ed.player:increaseDailyjobCount({
    type = "LegendEquipForgeTimes",
    add = 1
  })
  local queue = self:getForgeQueueByQueueId(queueId)
  if not queue._forge_list then
    queue._forge_list = {}
  end
  table.insert(queue._forge_list, item)
  for index, costItem in ipairs(costItemList or {}) do
    ed.player:consumeEquip(costItem._id, costItem._amount)
  end
  self:refreshForgeRedDot()
  FireEvent("FireForgeForgeEquip")
end

function class:handleUnlockQueue(_unlock_queue, costDiamond)
  local queue = _unlock_queue._queue
  if costDiamond and 0 < costDiamond then
    ed.player:addrmb(-costDiamond)
  else
    FireEvent("QueryDataRsp")
  end
  self:updateForgeQueue(queue)
end

function class:handleUnlockPos(_unlock_pos, unlockPosCostInfo)
  local queueId = _unlock_pos._queue_id
  local pos = _unlock_pos._pos
  local queue = self:getForgeQueueByQueueId(queueId)
  queue._unlock_pos[pos] = 1
  local costType = unlockPosCostInfo.costType
  local costAmount = unlockPosCostInfo.costAmount
  local costId = unlockPosCostInfo.costId
  if costType == "diamond" then
    ed.player:addrmb(-costAmount)
  elseif costType == "item" then
    ed.player:consumeEquip(costId, costAmount)
  end
  FireEvent("FireForgeUpdateQueue")
end

function class:handleForgePanel(_forge_panel)
  local queues = _forge_panel._queues
  local task = _forge_panel._task
  local wishes = _forge_panel._wishes
  local rewards = _forge_panel._rewards
  local normalTimes = _forge_panel._normal_times
  local firstOnlyTimes = _forge_panel._first_only_times
  local leftResetTimes = _forge_panel._left_reset_times
  self.normalTimes = normalTimes
  self.firstOnlyTimes = firstOnlyTimes
  self.leftResetTimes = leftResetTimes
  if rewards and 0 < #rewards then
    ed.player:addRewards(rewards)
  end
  self:updateAllForgeQueue(queues)
  self:initWishData(wishes)
  self:refreshAllRedDot()
  FireEvent("FireForgeOpenPanel")
end

function class:handleLottery(_lottery)
  local queueId = _lottery._queue_id
  local rewards = _lottery._rewards or {}
  local wishes = _lottery._wishes or {}
  local task = _lottery._task or {}
  local normalTimes = _lottery._normal_times
  local firstOnlyTimes = _lottery._first_only_times
  self.normalTimes = normalTimes
  self.firstOnlyTimes = firstOnlyTimes
  if rewards and 0 < #rewards then
    ed.player:addRewards(rewards)
  end
  self:initWishData(wishes)
  local queue = self:getForgeQueueByQueueId(queueId)
  if queue and 0 < #queue._forge_list then
    table.remove(queue._forge_list, 1)
  end
  self:refreshForgeRedDot()
  ed.UITool.openView("fireForgeLotteryEffectWindow", {
    rewards = rewards,
    closeCallBack = function()
      ed.UITool.openView("fireForgeRewardWindow", {rewards = rewards})
      FireEvent("FireForgeLottery")
    end
  })
end

function class:handleAccelerate(_accelerate)
  local queue = _accelerate._queue
  local costDiamond = _accelerate._cost_diamond
  local costItem = _accelerate._cost_item
  if costItem then
    ed.player:consumeEquip(costItem._id, costItem._amount)
  end
  if costDiamond and 0 < costDiamond then
    ed.player:addrmb(-costDiamond)
  end
  self:updateForgeQueue(queue)
  FireEvent("FireForgeAccelerate")
end

function class:handleOneKeyForge(_one_key_forge)
  local queues = _one_key_forge._queues
  local costItemList = _one_key_forge._cost_items
  local task = _one_key_forge._task
  local forgeTimes = _one_key_forge._forge_times or 0
  ed.player:increaseDailyjobCount({
    type = "LegendEquipForgeTimes",
    add = forgeTimes
  })
  for index, costItem in ipairs(costItemList or {}) do
    ed.player:consumeEquip(costItem._id, costItem._amount)
  end
  self:updateAllForgeQueue(queues)
  FireEvent("FireForgeForgeEquip")
end

function class:handleOneKeyLottery(_one_key_lottery)
  local queues = _one_key_lottery._queues
  local rewards = _one_key_lottery._rewards or {}
  local wishes = _one_key_lottery._wishes or {}
  local task = _one_key_lottery._task
  local normalTimes = _one_key_lottery._normal_times
  local firstOnlyTimes = _one_key_lottery._first_only_times
  self.normalTimes = normalTimes
  self.firstOnlyTimes = firstOnlyTimes
  self:initWishData(wishes)
  self:updateAllForgeQueue(queues)
  ed.player:addRewards(rewards)
  ed.UITool.openView("fireForgeLotteryEffectWindow", {
    rewards = rewards,
    closeCallBack = function()
      ed.UITool.openView("fireForgeRewardWindow", {rewards = rewards})
      FireEvent("FireForgeLottery")
    end
  })
end

function class:handleOneKeyAccelerate(_one_key_accelerate)
  local queue = _one_key_accelerate._queue
  local costDiamond = _one_key_accelerate._cost_diamond
  local costItem = _one_key_accelerate._cost_item
  if costItem then
    ed.player:consumeEquip(costItem._id, costItem._amount)
  end
  if costDiamond and 0 < costDiamond then
    ed.player:addrmb(-costDiamond)
  end
  self:updateForgeQueue(queue)
  FireEvent("FireForgeAccelerate")
end

function class:handleDiscard(_discard)
  local id = _discard._id
  local isDiscard = _discard._is_discard
  self:setLegendEquipDiscard(id, isDiscard)
end

function class.getLegendEquipShop(data)
  local forgeCfg = {}
  for _, v in pairs(ed.getDataTable("LegendEquipShop")) do
    forgeCfg[v["Group ID"]] = v
  end
  local goods = {}
  for _, v in ipairs(data) do
    local vv = ed.copyProto(v)
    if forgeCfg[vv._group_id] then
      vv.groupType = forgeCfg[vv._group_id]["Group Type"]
      vv.endTime = forgeCfg[vv._group_id]["End Time"]
      vv.weekSign = ed.getDataTable("LegendEquipGoods")[vv._index]["Week Sign"] or 0
    end
    table.insert(goods, vv)
  end
  return goods
end

function class:openShop(data)
  FireEvent("FireForgeOpenShop", {
    goods = self.getLegendEquipShop(data._goods or {}),
    refreshTime = data._next_auto_refresh_time
  })
end

function class:handleFragmentCompose(msg)
  if msg._rewards then
    local rewards = msg._rewards
    for _, reward in pairs(rewards) do
      local equipId = reward._id
      local equipInfo = ed.getDataTable("LegendEquip")[equipId]
      local fragmentId = equipInfo["Fragment Item"]
      local needAmount = equipInfo["Fragment Amount"]
      ed.player:consumeEquip(fragmentId, needAmount * reward._amount)
    end
    if 0 < #rewards then
      ed.UITool.showRewardsFromServer(rewards)
    end
    self:refreshComposeRedDot()
    FireEvent("UpdateFireForgePackage")
  end
end

function class:handleSetWish(_set_wish)
  local wish = _set_wish._wish
  local task = _set_wish._task
  local wishType = wish._wish_type
  local wishList = wish._wish_list
  self.wishData[wishType] = wishList
  FireEvent("FireForgeSetWish")
end

function class:handleSellFragment(msg)
  if msg._rewards then
    if self.sellFragmentId then
      ed.player:consumeEquip(self.sellFragmentId, self.sellFragmentAmount)
      self.sellFragmentId = nil
    end
    ed.player:addRewards(msg._rewards)
    ed.UITool.showRewardsFromServer(msg._rewards)
    FireEvent("UpdateFireForgePackage")
  end
end

function class:handleHandBook(_handbook)
  local equipIds = _handbook._equip_ids
  self.handBookData = {}
  for _, typeId in ipairs(equipIds or {}) do
    self.handBookData[typeId] = true
  end
  FireEvent("FireForgeHandBook")
end

function class:handleQueryRecords(_query_records)
  local records = _query_records._records
  self.records = records
  FireEvent("openForgingRecordWindow")
end

function class:handleEquipReset(_reset)
  self.leftResetTimes = _reset._left_reset_times
  local legendEquip = _reset._equip
  self:updateLegendEquip(legendEquip)
  self.redPointMgr:setNodeValue("new_legend_equip_" .. legendEquip._id, 1)
  if nil == _reset._return_items or 0 == #_reset._return_items then
    return
  end
  local rewards = {}
  for i, v in ipairs(_reset._return_items) do
    local isAdd = true
    for _, item in ipairs(rewards) do
      if item._type == v._type and item._id == v._id then
        item._amount = item._amount + v._amount
        isAdd = false
        break
      end
    end
    if isAdd then
      table.insert(rewards, v)
    end
  end
  local tipStr
  local addRewards = {}
  for i, v in ipairs(rewards) do
    if v._type == "legend_equip" then
      local equipCount = v._amount
      local equipName = ed.getDataTable("LegendEquip")[v._id]["Equip Name"]
      tipStr = T("\233\135\141\231\189\174\230\136\144\229\138\159\239\188\140\232\142\183\229\190\151<lable color=ccc3(250,247,226)> %d </lable>\228\187\182<lable color=ccc3(250,247,226)> %s</lable>", equipCount, equipName)
    else
      table.insert(addRewards, v)
    end
  end
  ed.player:addRewards(addRewards)
  ed.UITool.openView("legendEquipResetRewardWindow", {rewards = rewards, tipStr = tipStr})
  FireEvent("LegendEquipResetSuccess")
end

function class:handleBuyResetTimes(_buy_reset_times)
  self.leftResetTimes = _buy_reset_times._left_reset_times
  ed.player:subrmb(ed.legendEquipDefine.Reset_Times_Cost)
  FireEvent("UpdateLegendEquipResetTimes")
end
