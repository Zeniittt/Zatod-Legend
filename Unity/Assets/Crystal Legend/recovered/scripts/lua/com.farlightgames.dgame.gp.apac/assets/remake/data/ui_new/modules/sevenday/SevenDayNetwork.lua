local SevenDayNetwork = {}
SevenDayNetwork.__index = SevenDayNetwork
local instance
local printNetData = false

function SevenDayNetwork.getInstance()
  if not instance then
    instance = SevenDayNetwork.create()
  end
  return instance
end

function SevenDayNetwork.create()
  local self = {}
  setmetatable(self, SevenDayNetwork)
  return self
end

function SevenDayNetwork:dispatch(msg)
  if printNetData then
    print("------------------------SevenDayNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.SevenDayManager:handleOpenPanel(msg._open_panel)
  elseif msg._get_task_rewards then
    ed.SevenDayManager:handleGetTaskRewards(msg._get_task_rewards)
  elseif msg._get_line_rewards then
    ed.SevenDayManager:handleGetLineRewards(msg._get_line_rewards)
  end
end

function SevenDayNetwork:doSendReq(msg)
  if printNetData then
    print("------------------------SevenDayNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "sevenday_assist")
end

function SevenDayNetwork:getReq()
  return ed.upmsg.sevenday_assist_req()
end

function SevenDayNetwork:sendOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.sevenday_assist_open_panel()
  self:doSendReq(msg)
end

function SevenDayNetwork:sendGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.sevenday_assist_get_task_rewards()
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end

function SevenDayNetwork:sendGetLineReward(lineId)
  self.tmpLineId = lineId
  local msg = self:getReq()
  msg._get_line_rewards = ed.upmsg.sevenday_assist_get_line_rewards()
  msg._get_line_rewards._line_id = lineId
  self:doSendReq(msg)
end

ed.SevenDayNetwork = SevenDayNetwork.getInstance()
return SevenDayNetwork
