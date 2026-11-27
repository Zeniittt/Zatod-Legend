local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.TransitionScene = class

function class.create(transScene, luaScene, param)
  local self = {}
  param = param or {}
  setmetatable(self, {__index = class})
  self.fcaList = {}
  self.windowsStack = {}
  self.identity = "TransitionScene"
  self.onEnterNewSceneCallBack = param.onEnterNewSceneCallBack
  self.luaScene = luaScene
  self.scene = transScene
  self.scene:registerScriptHandler(self:baseHandler())
  self.ui = {}
  self.senceEventScope = {}
  return self
end

function class:init(scene)
  self.scene = scene
end

function class:onEnter()
end

function class:onExit()
  local length = #ed.scene_stack
  local findIndex
  for index = length, 1, -1 do
    local scene = ed.scene_stack[index]
    if scene.identity == self.identity then
      findIndex = index
      break
    end
  end
  if findIndex then
    ed.scene_stack[findIndex] = self.luaScene
  end
  if self.onEnterNewSceneCallBack then
    self.onEnterNewSceneCallBack()
  end
end

function class:baseHandler()
  local function handler(event)
    xpcall(function()
      if event == "enter" then
        self:onEnter()
      elseif event == "exit" then
        self:onExit()
      end
    end, EDDebug)
  end
  
  return handler
end
