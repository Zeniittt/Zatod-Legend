local class = newclass("g")
ed.retrievalRewardMgr = class
class.instance = nil

function class.getInstance()
  if not class.instance then
    class.instance = class.create()
  end
  return class.instance
end

function class.create()
  local self = {}
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.actId = nil
  self.finishTypeList = {}
  self.retrievalRewardActTB = ed.getDataTable("RetrievalRewardAct")
end

function class:handleNotify(data)
  local retrievalRewardNotify = data
  self.retrievalRewardNotify = retrievalRewardNotify
end

function class:handleOpenPanel(data)
  self.retrievalRewardNotify = 0
  self.actId = data._act_id
  self.detail = data._details or {}
  self.finishTypeList = {}
  FireEvent("RetrievalRewardOpenPanel")
  FireEvent("updateRetrievalRewardTips")
end

function class:handleTakeReward(data)
  local typeList = data._type
  local rewards = data._rewards
  local cost = data._diamond
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  ed.player:subrmb(cost)
  for index, type in ipairs(typeList or {}) do
    self.finishTypeList[type] = 1
  end
  FireEvent("RetrievalRewardTakeReward")
end

function class:checkRewardIsFinished(type)
  if self.finishTypeList[type] then
    return true
  end
  return false
end

function class:isShowActPage()
  if self.retrievalRewardNotify ~= 0 then
    return true
  end
  local retrievalActCft = self.retrievalRewardActTB[1]
  if retrievalActCft and retrievalActCft.Show and self:hasReward() then
    return true
  end
  return false
end

function class:hasReward()
  if self.detail and #self.detail > 0 then
    for index, rewardsDetail in ipairs(self.detail) do
      local type = rewardsDetail._type
      if not self:checkRewardIsFinished(type) then
        return true
      end
    end
    return false
  end
  return false
end

function class:hasRed()
  return self.retrievalRewardNotify == 2
end

function class:getRewardDetail()
  return self.detail or {}
end

function class:getCostDiscount()
  if ed.player:isMonthCardValid("payed") then
    local retrievalActCft = self.retrievalRewardActTB[self.actId]
    if retrievalActCft then
      return retrievalActCft.Discount
    end
  end
  return 1
end
