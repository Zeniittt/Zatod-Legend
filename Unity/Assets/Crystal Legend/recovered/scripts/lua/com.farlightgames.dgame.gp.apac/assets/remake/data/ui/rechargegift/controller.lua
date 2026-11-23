local class = ed.Player

local function setRechargeGiftActivityid(self, id)
  self.rechargeGiftActivityid = id
end

class.setRechargeGiftActivityid = setRechargeGiftActivityid

local function resetRechargeGiftActivityid(self, id)
  self.rechargeGiftActivityid = nil
end

class.resetRechargeGiftActivityid = resetRechargeGiftActivityid

local function hasRechargeGiftActivity(self)
  if self.rechargeGiftActivityid then
    return true
  end
  return false
end

class.hasRechargeGiftActivity = hasRechargeGiftActivity

local function getRechargeGiftid(self)
  return self.rechargeGiftActivityid
end

class.getRechargeGiftid = getRechargeGiftid

local function setMagicBoxActivityId(self, id)
  self.magicBoxActivityId = id
end

class.setMagicBoxActivityId = setMagicBoxActivityId

local function resetMagicBoxActivityId(self, id)
  self.magicBoxActivityId = nil
end

class.resetMagicBoxActivityId = resetMagicBoxActivityId

local function hasMagicBoxActivity(self)
  if self.magicBoxActivityId then
    return true
  end
  return false
end

class.hasMagicBoxActivity = hasMagicBoxActivity

local function getMagicBoxActivityId(self)
  return self.magicBoxActivityId
end

class.getMagicBoxActivityId = getMagicBoxActivityId

local function setSuperExchangeActivityId(self, id)
  self.superExchangeActivityId = id
end

class.setSuperExchangeActivityId = setSuperExchangeActivityId

local function hasSuperExchangeActivity(self)
  if self.superExchangeActivityId then
    return true
  end
  return false
end

class.hasSuperExchangeActivity = hasSuperExchangeActivity

local function getSuperExchangeActivityId(self)
  return self.superExchangeActivityId
end

class.getSuperExchangeActivityId = getSuperExchangeActivityId

local function setDreamlandStageBuffActivityId(self, id, noNeedMod)
  self.dreamlandStageBuffActivityId = id
  self.noNeedMod = noNeedMod
end

class.setDreamlandStageBuffActivityId = setDreamlandStageBuffActivityId

local function hasDreamlandStageBuffActivity(self)
  if self.dreamlandStageBuffActivityId then
    return true
  end
  return false
end

class.hasDreamlandStageBuffActivity = hasDreamlandStageBuffActivity

local function getDreamlandStageBuffId(self)
  local activityId = self.noNeedMod and self.dreamlandStageBuffActivityId or self.dreamlandStageBuffActivityId % 1000
  local stageBuffId = ed.lookupDataTable("FixedActlist", "Extra_AN", activityId)
  if stageBuffId then
    return stageBuffId[1]
  end
end

class.getDreamlandStageBuffId = getDreamlandStageBuffId
