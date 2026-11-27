local FiveAmRefreshManager = {}
FiveAmRefreshManager.currentTimerName = nil
FiveAmRefreshManager.enterBackgroundTime = 0
FiveAmRefreshManager.debugMode = true

local function formatServerTime(timestamp)
  return ed.getYMDHMSTime(ed.getYMDHMS(timestamp + ed.getTimeDiff2Server()))
end

ed.FiveAmRefreshManager = FiveAmRefreshManager
ListenEvent("applicationDidEnterBackground", function()
  ed.FiveAmRefreshManager:enterBackground()
end)
ListenEvent("applicationWillEnterForeground", function()
  ed.FiveAmRefreshManager:enterForeground()
end)

function FiveAmRefreshManager:startNext5AmTimer()
  if self.currentTimerName then
    CloseEvent(self.currentTimerName)
    self.currentTimerName = nil
  end
  local nextFiveAmTime = self:getNext5AmTime()
  if not nextFiveAmTime then
    if self.debugMode then
      EDLog("[FiveAmRefreshManager] \230\151\160\230\179\149\232\142\183\229\143\150\228\184\139\228\184\128\228\184\1705\231\130\185\230\151\182\233\151\180\230\136\179")
    end
    return
  end
  local currentTime = ed.getServerTime()
  local delaySeconds = nextFiveAmTime - currentTime
  if self.debugMode then
    EDLog(string.format("[FiveAmRefreshManager] \232\174\190\231\189\1745\231\130\185\229\174\154\230\151\182\229\153\168: \228\184\139\228\184\128\228\184\1705\231\130\185=%s, \229\189\147\229\137\141\230\151\182\233\151\180=%s, \229\187\182\232\191\159=%d\231\167\146", formatServerTime(nextFiveAmTime), formatServerTime(currentTime), delaySeconds))
  end
  if delaySeconds <= 0 then
    self:triggerRefreshEvent()
    return
  end
  if 60 < delaySeconds then
    self.currentTimerName = "FiveAmRefresh_Timer_" .. tostring(nextFiveAmTime)
    local fiveAmTimer = Timer:Once(delaySeconds, self.currentTimerName)
    ListenTimer(fiveAmTimer, function()
      self:onTimerReached(nextFiveAmTime)
    end)
    if self.debugMode then
      EDLog("[FiveAmRefreshManager] \228\189\191\231\148\168\228\184\128\230\172\161\230\128\167\229\174\154\230\151\182\229\153\168\239\188\140\229\187\182\232\191\159: " .. delaySeconds .. "\231\167\146")
    end
  else
    self.currentTimerName = "FiveAmRefresh_AlwaysTimer_" .. tostring(nextFiveAmTime)
    local alwaysTimer = Timer:Always(1)
    ListenTimer(alwaysTimer, function()
      self:checkFiveAmByAlways(nextFiveAmTime)
    end)
    if self.debugMode then
      EDLog("[FiveAmRefreshManager] \228\189\191\231\148\168\230\175\143\231\167\146\230\163\128\230\159\165\229\174\154\230\151\182\229\153\168\239\188\140\231\155\174\230\160\1355\231\130\185: " .. formatServerTime(nextFiveAmTime))
    end
  end
end

function FiveAmRefreshManager:onTimerReached(targetFiveAmTime)
  local currentTime = ed.getServerTime()
  if self.debugMode then
    EDLog(string.format("[FiveAmRefreshManager] \228\184\128\230\172\161\230\128\167\229\174\154\230\151\182\229\153\168\229\136\176\230\156\159\239\188\140\231\155\174\230\160\1355\231\130\185=%s, \229\189\147\229\137\141\230\151\182\233\151\180=%s", formatServerTime(targetFiveAmTime), formatServerTime(currentTime)))
  end
  if targetFiveAmTime <= currentTime then
    self:triggerRefreshEvent()
  else
    if self.debugMode then
      EDLog("[FiveAmRefreshManager] \230\151\182\233\151\180\230\156\170\229\136\176\239\188\140\233\135\141\230\150\176\232\174\190\231\189\174\229\174\154\230\151\182\229\153\168")
    end
    self:startNext5AmTimer()
  end
end

function FiveAmRefreshManager:checkFiveAmByAlways(targetFiveAmTime)
  local currentTime = ed.getServerTime()
  if targetFiveAmTime <= currentTime then
    if self.debugMode then
      EDLog(string.format("[FiveAmRefreshManager] \230\175\143\231\167\146\230\163\128\230\159\165\229\136\176\232\190\1905\231\130\185\239\188\140\231\155\174\230\160\135=%s, \229\189\147\229\137\141=%s", formatServerTime(targetFiveAmTime), formatServerTime(currentTime)))
    end
    if self.currentTimerName then
      CloseEvent(self.currentTimerName)
      self.currentTimerName = nil
    end
    self:triggerRefreshEvent()
  end
end

function FiveAmRefreshManager:getNext5AmTime()
  if not ed.timestamps or #ed.timestamps == 0 then
    return nil
  end
  local curTime = ed.getServerTime()
  local cnt = #ed.timestamps
  for i = 1, cnt do
    if ed.timestamps[i] and ed.timestamps[i].next_day_5am and curTime < ed.timestamps[i].next_day_5am then
      return ed.timestamps[i].next_day_5am
    end
  end
  return nil
end

function FiveAmRefreshManager:shouldTriggerRefreshEvent()
  if self.enterBackgroundTime <= 0 then
    return false
  end
  if not ed.timestamps or #ed.timestamps == 0 then
    return false
  end
  local currentTime = ed.getServerTime()
  local backgroundTime = self.enterBackgroundTime
  for i = 1, #ed.timestamps do
    local fiveAmTime = ed.timestamps[i].next_day_5am
    if fiveAmTime and backgroundTime < fiveAmTime and currentTime >= fiveAmTime then
      if self.debugMode then
        EDLog(string.format("[FiveAmRefreshManager] \230\163\128\230\181\139\229\136\176\232\183\168\232\191\1355\231\130\185: \229\144\142\229\143\176\230\151\182\233\151\180=%s, 5\231\130\185\230\151\182\233\151\180=%s, \229\189\147\229\137\141\230\151\182\233\151\180=%s", formatServerTime(backgroundTime), formatServerTime(fiveAmTime), formatServerTime(currentTime)))
      end
      return true
    end
  end
  return false
end

function FiveAmRefreshManager:triggerRefreshEvent()
  local currentTime = ed.getServerTime()
  if self.debugMode then
    EDLog(string.format("[FiveAmRefreshManager] \232\167\166\229\143\1455\231\130\185\229\136\183\230\150\176\228\186\139\228\187\182\239\188\140\230\151\182\233\151\180: %s", formatServerTime(currentTime)))
  end
  FireEvent("FiveAmRefresh", currentTime)
  self:startNext5AmTimer()
end

function FiveAmRefreshManager:enterBackground()
  self.enterBackgroundTime = ed.getServerTime()
  if self.debugMode then
    EDLog(string.format("[FiveAmRefreshManager] \229\186\148\231\148\168\232\191\155\229\133\165\229\144\142\229\143\176\239\188\140\230\151\182\233\151\180: %s", formatServerTime(self.enterBackgroundTime)))
  end
end

function FiveAmRefreshManager:enterForeground()
  if self.debugMode then
    local currentTime = ed.getServerTime()
    EDLog(string.format("[FiveAmRefreshManager] \229\186\148\231\148\168\229\155\158\229\136\176\229\137\141\229\143\176\239\188\140\230\151\182\233\151\180: %s", formatServerTime(currentTime)))
  end
  if self:shouldTriggerRefreshEvent() then
    if self.debugMode then
      EDLog("[FiveAmRefreshManager] \230\163\128\230\181\139\229\136\176\232\183\168\232\191\1355\231\130\185\239\188\140\232\167\166\229\143\145\229\136\183\230\150\176\228\186\139\228\187\182")
    end
    self:triggerRefreshEvent()
  else
    self:startNext5AmTimer()
  end
end

function FiveAmRefreshManager:enableDebug()
  self.debugMode = true
  EDLog("[FiveAmRefreshManager] \232\176\131\232\175\149\230\168\161\229\188\143\229\183\178\229\144\175\231\148\168")
end

function FiveAmRefreshManager:disableDebug()
  self.debugMode = false
end

function ed.startNext5AmTimer()
  ed.FiveAmRefreshManager:startNext5AmTimer()
end

function ed.enableFiveAmDebug()
  ed.FiveAmRefreshManager:enableDebug()
end

function ed.disableFiveAmDebug()
  ed.FiveAmRefreshManager:disableDebug()
end
