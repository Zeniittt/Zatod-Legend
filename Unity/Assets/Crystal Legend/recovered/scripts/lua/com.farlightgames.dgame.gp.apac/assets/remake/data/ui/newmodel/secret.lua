local SecretMode = {}
ed.SecretMode = SecretMode
local instance
local startTime = T("2016/10/31 5:00:00")

function SecretMode.getInstance()
  if instance == nil then
    instance = SecretMode.create()
  end
  return instance
end

function SecretMode.create()
  local self = {}
  setmetatable(self, SecretMode)
  SecretMode.__index = SecretMode
  self:initData()
  return self
end

function SecretMode:initData()
  self.openedTime = 57600
end

function SecretMode:isOpened()
  local timeString = startTime
  local openTime = ed.getTimeByYMDHMS(timeString)
  local serverTime = ed.getServerTime()
  if openTime < serverTime and serverTime < openTime + self.openedTime then
    return true
  end
  return false
end

function SecretMode:isNeedHideRecord()
  local timeString = startTime
  local endTime = ed.getTimeByYMDHMS(timeString) + self.openedTime
  local serverTime = ed.getServerTime()
  if serverTime > endTime - 5 then
    return true
  end
  return false
end

function SecretMode:isInActivityTime(time)
  local timeString = startTime
  local openTime = ed.getTimeByYMDHMS(timeString)
  if time > openTime and time < openTime + self.openedTime then
    return true
  end
  return false
end

function SecretMode:getOpenTime()
  return self.openedTime
end

function SecretMode:getDefaultConfig()
  local defaultConfig = {
    level = 11,
    avatar = 524399,
    name = T("\231\139\130\230\172\162\231\154\132\233\173\133\229\189\177"),
    guildName = T("???"),
    rank = T("\230\156\170\231\159\165")
  }
  return defaultConfig
end
