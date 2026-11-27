module("ed.loading", package.seeall)
manager = {}
manager.__index = manager

function manager.create()
  local object = {}
  setmetatable(object, manager)
  object:initData()
  return object
end

function manager:initData()
  self.delay = 0.1
  self.time = 0
  self.loadsceneCallBack = nil
  self.scaleFactor = 1.28125
end

function manager:openLoadingScene(back)
  self.loadsceneCallBack = back
  CCDirector:sharedDirector():setContentScaleFactor(self.scaleFactor)
  local scene = scene.create()
  CCDirector:sharedDirector():runWithScene(scene:ccScene())
  self.id = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self:getGameUpdata(), 0, false)
end

function manager:getGameUpdata()
  local function gameUpdate(dt)
    xpcall(function()
      self.time = self.time + dt
      
      if self.time > self.delay then
        if self.loadsceneCallBack then
          self.loadsceneCallBack()
        end
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.id)
      end
    end, EDDebug)
  end
  
  return gameUpdate
end

manager = manager.create()
