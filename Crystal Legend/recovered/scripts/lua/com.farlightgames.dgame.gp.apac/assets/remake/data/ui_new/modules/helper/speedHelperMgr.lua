local class = newclass("g")
ed.speedHelperMgr = class
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
  self.speed = 1
  self.isPause = false
  self.isShowFloating = false
  self.isEnable = true
  self.eventScope = {}
  self.checkSceneIdList = {
    "KingsPvpMainScene",
    "AutoChessArenaScene",
    "AutoChessBattleScene",
    "SoloBattleScene"
  }
  self.firstEnterMainScene = false
  self:addEventListen()
end

function class:reportServer()
  local msg = ed.upmsg.sync_tiger_tool()
  msg._state = self.isPause and 0 or 1
  msg._speed = self.speed
  ed.send(msg, "sync_tiger_tool")
end

function class:refreshRedPoint()
  local redPoint = ed.storage.getBool("HelperRedPoint")
  local isUnlock = self:getSpeedUpUnlock()
  if isUnlock and not redPoint then
    ed.redPointMgr.getInstance():setNodeValue("player_info_speed_helper_entry", 1)
  end
end

function class:initLocalData()
  local isShowFloating = ed.storage.getBool(ed.getRoleKey("HelperFloating"))
  local speed = ed.storage.getInt(ed.getRoleKey("HelperSpeed"))
  local isPause = ed.storage.getBool(ed.getRoleKey("HelperPause"))
  self:setShowFloating(isShowFloating)
  self:setSpeed(speed)
  self:setPause(isPause)
end

function class:saveLocalData()
  ed.storage.setValue(ed.getRoleKey("HelperFloating"), self.isShowFloating)
  ed.storage.setValue(ed.getRoleKey("HelperSpeed"), self.speed)
  ed.storage.setValue(ed.getRoleKey("HelperPause"), self.isPause)
end

function class:refreshSpeed()
  if not self.isEnable then
    CCDirector:sharedDirector():getScheduler():setTimeScale(1)
    return
  end
  local realSpeed = 1
  if self.isPause then
    realSpeed = 1
  else
    local speedCfg = ed.speed_config[self.speed]
    realSpeed = speedCfg.realSpeed
  end
  if realSpeed == CCDirector:sharedDirector():getScheduler():getTimeScale() then
    return
  end
  CCDirector:sharedDirector():getScheduler():setTimeScale(realSpeed)
end

function class:setPause(isPause)
  self.isPause = isPause
  self:refreshSpeed()
  self:saveLocalData()
end

function class:getIsPause()
  return self.isPause
end

function class:checkSpeedIsUnlock(speed)
  local speedCfg = ed.speed_config[speed]
  if speedCfg then
    local playerLevelKey = speedCfg.playerLevelKey
    if playerLevelKey then
      return ed.playerlimit:moduleIsOpened(speedCfg.playerLevelKey)
    else
      return true
    end
  end
  return false
end

function class:getSpeedUpUnlock()
  return self:checkSpeedIsUnlock(2)
end

function class:setSpeed(speed)
  if not ed.speed_config[speed] then
    speed = 1
  end
  if not self:checkSpeedIsUnlock(speed) then
    return
  end
  self.speed = speed
  self:refreshSpeed()
  self:saveLocalData()
end

function class:setSpeedByIndex(index)
  local speed = ed.speed_list[index] or 1
  self:setSpeed(speed)
end

function class:getSpeed()
  return self.speed
end

function class:getIsShowFloating()
  return self.isShowFloating
end

function class:setShowFloating(isShow)
  if self.isShowFloating == isShow then
    return
  end
  self.isShowFloating = isShow
  ed.speedHelperFloating.showFloating(self.isShowFloating)
  self:saveLocalData()
end

function class:checkSceneEnable()
  local isEnable = true
  for index, scene in ipairs(ed.scene_stack or {}) do
    if ed.isElementInTable(scene.identity, self.checkSceneIdList) then
      isEnable = false
      break
    end
  end
  if isEnable == self.isEnable then
    return
  end
  self.isEnable = isEnable
  self:refreshSpeed()
end

function class:onEnterMainScene()
  if not self.firstEnterMainScene then
    self.firstEnterMainScene = true
    self:initLocalData()
    self:refreshRedPoint()
  end
end

function class:onLevelUp(level)
  self:refreshRedPoint()
end

function class:addEventListen()
  ListenEvent(ed.guide.eventNames.OPEN_VIEW, function()
    self:checkSceneEnable()
  end, self.eventScope)
  ListenEvent(ed.guide.eventNames.CLOSE_VIEW, function()
    self:checkSceneEnable()
  end, self.eventScope)
  ListenEvent("mainSceneEnter", function()
    self:onEnterMainScene()
  end, self.eventScope)
  ListenEvent("PlayerLevelUp", function(level)
    self:onLevelUp(level)
  end, self.eventScope)
end

ed.speedHelperMgr.getInstance()
