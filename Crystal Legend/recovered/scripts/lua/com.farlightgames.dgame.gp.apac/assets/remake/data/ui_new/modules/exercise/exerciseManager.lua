local exerciseManager = {}
exerciseManager.__index = exerciseManager
exerciseManager.dayMaxCount = 8
exerciseManager.entryStage = {
  [20001] = {
    type = "equip",
    key = "int",
    offset = ccp(0, -50),
    scale = 1,
    gs = 2
  },
  [20002] = {
    type = "equip",
    key = "int",
    offset = ccp(0, -50),
    scale = 1,
    gs = 2
  },
  [20003] = {
    type = "equip",
    key = "int",
    offset = ccp(0, -50),
    scale = 1,
    gs = 2
  },
  [20004] = {
    type = "equip",
    key = "agi",
    offset = ccp(0, -50),
    scale = 1,
    gs = 2
  },
  [20005] = {
    type = "equip",
    key = "str",
    offset = ccp(0, -50),
    scale = 1,
    gs = 2
  },
  [20006] = {
    type = "spring",
    key = "spring1",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20007] = {
    type = "spring",
    key = "spring2",
    fcaaction = "Idlefix",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20008] = {
    type = "spring",
    key = "spring3",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20009] = {
    type = "spring",
    key = "spring4",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20010] = {
    type = "spring",
    key = "spring5",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20011] = {
    type = "spring",
    key = "spring6",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20012] = {
    type = "spring",
    key = "spring7",
    offset = ccp(0, -50),
    scale = 1,
    gs = 3
  },
  [20013] = {
    type = "artifact",
    key = "artifact2",
    offset = ccp(0, -50),
    scale = 1,
    gs = 1
  },
  [20014] = {
    type = "artifact",
    key = "artifact1",
    offset = ccp(0, -50),
    scale = 1,
    gs = 1
  },
  [20015] = {
    type = "artifact",
    key = "artifact3",
    offset = ccp(0, -50),
    scale = 1,
    gs = 1
  },
  [20016] = {
    type = "artifact",
    key = "artifact4",
    offset = ccp(0, -50),
    scale = 1,
    gs = 1
  },
  [20017] = {
    type = "artifact",
    key = "artifact4",
    offset = ccp(0, -50),
    scale = 1,
    gs = 1
  },
  [20018] = {
    type = "artifact",
    key = "artifact4",
    offset = ccp(0, -50),
    scale = 0.75,
    gs = 1
  }
}

function exerciseManager.getInstance()
  if not exerciseManager.instance then
    exerciseManager.instance = exerciseManager.create()
  end
  return exerciseManager.instance
end

function exerciseManager.create()
  local self = {}
  setmetatable(self, exerciseManager)
  self:init()
  return self
end

function exerciseManager:init()
  self:initData()
end

function exerciseManager:initData()
  ed.defineProperty(self, "type", "")
  ed.defineProperty(self, "equipParam", nil)
  self.eventScope = {}
end

local handlers = {
  query_act_stage_reply = function(self, msg)
    FireEvent("refreshExercise")
    if self.query_act_stage_reply then
      self.query_act_stage_reply()
    end
  end
}

function exerciseManager:getHandle(msgName)
  return handlers[msgName]
end

function exerciseManager:handleMsg(msg, msgName)
  local handle = self:getHandle(msgName)
  if not handle then
    warn(msgName .. "`s handler not defined!")
    return
  end
  handle(self, msg)
end

function exerciseManager:openExerciseMainScene(type, equipParam)
  local cpl = ed.playerlimit.getAreaUnlockPrompt
  local ds = cpl("Exercise")
  if ds then
    ed.showToast(ds)
    return
  end
  self:setType(type or "spring")
  self:setEquipParam(equipParam)
  
  function self.query_act_stage_reply()
    ed.pushScene(ed.ui.exerciseMainScene.create())
    self.query_act_stage_reply = nil
  end
  
  ed.exerciseNetWork:sendQueryActStage()
end

ed.UITool.registViewOpenFunc("exerciseMainScene", function()
  ed.exerciseManager:openExerciseMainScene()
end)
ed.exerciseManager = exerciseManager.getInstance()
