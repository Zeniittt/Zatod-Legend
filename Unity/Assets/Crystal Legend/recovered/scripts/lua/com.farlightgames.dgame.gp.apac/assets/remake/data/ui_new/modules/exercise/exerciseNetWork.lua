local exerciseNetWork = {}
exerciseNetWork.__index = exerciseNetWork

function exerciseNetWork.getInstance()
  if not exerciseNetWork.instance then
    exerciseNetWork.instance = exerciseNetWork.create()
  end
  return exerciseNetWork.instance
end

function exerciseNetWork.create()
  local self = {}
  setmetatable(self, exerciseNetWork)
  self:init()
  return self
end

function exerciseNetWork:init()
  self:initData()
  self:addEventListener()
end

function exerciseNetWork:initData()
  ed.defineProperty(self, "reqEnableStageTime", nil)
  ed.defineProperty(self, "queryActStageReply", nil)
  self.eventScope = {}
end

function exerciseNetWork:addEventListener()
end

function exerciseNetWork:dispatch(msg)
  if msg._query_act_stage_reply then
    self:setReqEnableStageTime(ed.getServerTime())
    self:setQueryActStageReply(msg._query_act_stage_reply)
    ed.exerciseManager:handleMsg(msg, "query_act_stage_reply")
  end
end

function exerciseNetWork:needReqEnableStage()
  if self:getReqEnableStageTime() then
    return ed.checkTwoDateod(self:getReqEnableStageTime(), ed.getServerTime())
  else
    return true
  end
end

function exerciseNetWork:sendQueryActStage()
  local msg = ed.upmsg.query_act_stage()
  ed.send(msg, "query_act_stage")
end

ed.exerciseNetWork = exerciseNetWork.getInstance()
