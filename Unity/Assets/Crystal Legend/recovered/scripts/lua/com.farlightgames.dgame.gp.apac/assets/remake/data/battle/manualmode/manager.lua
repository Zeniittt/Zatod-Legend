module("ed.ManualMode", package.seeall)
Manager = {}
Manager.__index = Manager

function Manager:Create()
  local obj = {}
  setmetatable(obj, Manager)
  obj:Init()
  return obj
end

function Manager:Init()
  self:Release()
end

function Manager:InitWindow()
  self.mainTouchPriority = -120
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:MainTouchHandler(), false, self.mainTouchPriority, false)
end

function Manager:Release()
  self.unit = nil
  self.skillLayer = nil
end

function Manager:SetUnit(unit)
  unit.manualController = true
  self.unit = unit
end

function Manager:SetSkillLayer()
  self.skillLayer = SkillLayer:Create()
  self.skillLayer:SetManager(self)
  self.skillLayer:InitSkills()
  self.mainLayer:addChild(self.skillLayer.mainLayer)
end

function Manager:MainTouchHandler()
  local function handler(event, x, y)
    xpcall(function()
      self:MoveTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

function Manager:MoveTouch(event, x, y)
  if event == "began" then
  elseif event == "moved" then
  elseif event == "ended" and y > Move_Min_Height and y < Move_Max_Height and ed.engine.running and not ed.engine:arenaMode() then
    ed.engine:manuallyWalkTowards({
      math.ceil(x),
      math.ceil(y)
    })
    ed.engine:manuallyLocationTarget({
      math.ceil(x),
      math.ceil(y)
    })
  end
end
