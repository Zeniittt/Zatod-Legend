local passDataMgr = {}
ed.passDataMgr = passDataMgr
setmetatable(passDataMgr, {__index = passDataMgr})

function passDataMgr:init()
  self.allPassData = {}
  self.canReceiveRewardAmount = {}
  self.unReceiveRewardAmount = {}
  self.simplePassRewardList = {}
  self.eventScope = {}
  self:addEventListener()
end

function passDataMgr:initPassData(passList)
  self.allPassData = {}
  for index, packedSimplePass in ipairs(passList or {}) do
    local id = packedSimplePass._id
    self.allPassData[id] = {
      id = packedSimplePass._id,
      rank = packedSimplePass._rank,
      level = packedSimplePass._level,
      endTime = packedSimplePass._end_time,
      expireTime = packedSimplePass._expire_time,
      rewardFlags = packedSimplePass._reward_flags,
      extend = packedSimplePass._extend
    }
    self:updatePassRewardList(id)
  end
end

function passDataMgr:updatePassData(packedSimplePass)
  local id = packedSimplePass._id
  local passData = {
    id = packedSimplePass._id,
    rank = packedSimplePass._rank,
    level = packedSimplePass._level,
    endTime = packedSimplePass._end_time,
    expireTime = packedSimplePass._expire_time,
    rewardFlags = packedSimplePass._reward_flags,
    extend = packedSimplePass._extend
  }
  self.allPassData[id] = passData
  self:updatePassRewardList(id)
  FireEvent("UpdatePassData", id)
end

function passDataMgr:getDisplayPass()
  local displayPass = {}
  local simplePassTb = ed.getDataTable("SimplePass")
  for id, passData in pairs(self.allPassData) do
    local passConfig = simplePassTb[id]
    if passConfig then
      displayPass[id] = {
        id = id,
        type = passConfig.Type,
        extraStr = passConfig["Extra Str"],
        extraAN = passConfig["Extra AN"]
      }
    end
  end
  return displayPass
end

function passDataMgr:passBuySuccess(packedSimplePass)
  local id = packedSimplePass._id
  local rank = packedSimplePass._rank
  FireEvent("passBuySuccess", id, rank)
end

function passDataMgr:getPassData(id)
  return self.allPassData[id]
end

function passDataMgr:updatePassRewardList(id)
  local canReceiveAmount = 0
  local unReceiveAmount = 0
  local rewardDataList = {}
  for index, simplePassReward in ipairs(ed.getDataTable("SimplePassReward")[id] or {}) do
    for rank = 0, ed.passDefine.REWARD_RANK_MAX do
      for type = 1, ed.passDefine.REWARD_TYPE_MAX do
        local rewardType = simplePassReward[string.format("R%s Reward Type%s", rank, type)]
        local rewardId = simplePassReward[string.format("R%s Reward ID%s", rank, type)]
        local rewardAmount = simplePassReward[string.format("R%s Reward Amount%s", rank, type)]
        local requireLevel = simplePassReward["Require Level"]
        if rewardType then
          local rewardData = {
            rewardPos = rank * 10000 + requireLevel,
            rewardIndex = type,
            rewardType = rewardType,
            rewardId = rewardId,
            rewardAmount = rewardAmount,
            position = simplePassReward.Position,
            requireLevel = requireLevel,
            rewardState = self:getRewardState(id, simplePassReward["Require Level"], rank, type)
          }
          if not rewardDataList[requireLevel] then
            rewardDataList[requireLevel] = {}
          end
          table.insert(rewardDataList[requireLevel], rewardData)
          if rewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
            canReceiveAmount = canReceiveAmount + 1
          end
          if rewardData.rewardState ~= ed.passDefine.REWARD_STATE_COMPLETED then
            unReceiveAmount = unReceiveAmount + 1
          end
        end
      end
    end
  end
  self:setPassRewardCount(id, canReceiveAmount)
  self:setPassUnReceiveRewardCount(id, unReceiveAmount)
  self.simplePassRewardList[id] = rewardDataList
end

function passDataMgr:setPassRewardCount(id, rewardCount)
  self.canReceiveRewardAmount[id] = rewardCount
  FireEvent("UpdatePassRewardTips", {passId = id, rewardCount = rewardCount})
end

function passDataMgr:getPassRewardCount(id)
  return self.canReceiveRewardAmount[id] or 0
end

function passDataMgr:setPassUnReceiveRewardCount(id, unReceiveAmount)
  self.unReceiveRewardAmount[id] = unReceiveAmount
end

function passDataMgr:getPassUnReceiveRewardCount(id)
  return self.unReceiveRewardAmount[id] or 0
end

function passDataMgr:getPassRewardList(id)
  return self.simplePassRewardList[id] or {}
end

function passDataMgr:IsEnded(id)
  local passData = self:getPassData(id)
  if passData then
    return ed.getServerTime() > passData.endTime
  end
  return false
end

function passDataMgr:IsExpire(id)
  local passData = self:getPassData(id)
  if passData then
    return ed.getServerTime() > passData.expireTime
  end
  return false
end

function passDataMgr:getPassRank(id)
  local passData = self:getPassData(id)
  if passData then
    return passData.rank
  end
  return 0
end

function passDataMgr:getRewardState(id, targetLevel, targetRank, targetType)
  local passData = self:getPassData(id)
  local state = ed.passDefine.REWARD_STATE_NOT_REACHED
  local rewardFlags = passData.rewardFlags
  local beReceived = false
  for i, rewardFlag in ipairs(rewardFlags or {}) do
    local level = rewardFlag._pos % 10000
    local rank = math.floor(rewardFlag._pos / 10000)
    local indexList = rewardFlag._index_list
    if targetLevel == level and targetRank == rank then
      for key, type in pairs(indexList) do
        if type == targetType then
          state = ed.passDefine.REWARD_STATE_COMPLETED
          beReceived = true
          return state
        end
      end
    end
  end
  if targetRank > passData.rank then
    state = ed.passDefine.REWARD_STATE_LOCK
    return state
  end
  if targetLevel <= self:getCurrentLevel(id) and targetRank <= passData.rank and not beReceived then
    state = ed.passDefine.REWARD_STATE_AVAILABLE
    return state
  end
  if targetLevel > self:getCurrentLevel(id) and targetRank > passData.rank then
    state = ed.passDefine.REWARD_STATE_NOT_REACHED
    return state
  end
  return state
end

function passDataMgr:getCurrentLevel(id)
  local passData = self:getPassData(id)
  return passData.level
end

function passDataMgr:doRechargePass(passId, buyRank)
  local rechargeId
  local simplePassTbData = ed.getDataTable("SimplePass")[passId]
  local priceType = simplePassTbData[string.format("R%s Price Type", buyRank)]
  if priceType == ed.passDefine.RANK_BUY_TYPE_DIAMOND then
    ed.passNetWork:simplePassBuyRank(passId, buyRank)
    return
  elseif priceType == ed.passDefine.RANK_BUY_TYPE_GIFT_TICKET then
    local price = simplePassTbData[string.format("R%s Price Value", buyRank)]
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
      giftType = "pass",
      passId = passId,
      passRank = buyRank,
      canUseTicket = true
    }
    ed.RechargeManager:doRecharge(rechargeItem)
    return
  end
end

function passDataMgr:addEventListener()
end

passDataMgr:init()
