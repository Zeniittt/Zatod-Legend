local dayAwardsNetwork = {}
dayAwardsNetwork.__index = dayAwardsNetwork
local instance
local printNetData = false

function dayAwardsNetwork.getInstance()
  if not instance then
    instance = dayAwardsNetwork.create()
  end
  return instance
end

function dayAwardsNetwork.create()
  local self = {}
  setmetatable(self, dayAwardsNetwork)
  return self
end

function dayAwardsNetwork:dispatch(msg)
  if printNetData then
    print("------------------------dayAwardsNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  local type = ""
  if msg._open_panel then
    type = msg._open_panel._simple_assist._type
  elseif msg._get_task_rewards then
    type = msg._get_task_rewards._type
  elseif msg._get_line_rewards then
    type = msg._get_line_rewards._type
  end
  if type ~= "legend_begin" then
    return
  end
  if msg._open_panel then
    ed.dayAwardsManager:handleOpenPanel(msg._open_panel)
  elseif msg._get_task_rewards then
    ed.dayAwardsManager:handleGetTaskRewards(msg._get_task_rewards)
  elseif msg._get_line_rewards then
    ed.dayAwardsManager:handleGetLineRewards(msg._get_line_rewards, self.tmpLineId)
  end
end

function dayAwardsNetwork:doSendReq(msg)
  if printNetData then
    print("------------------------dayAwardsNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "simple_assist")
end

function dayAwardsNetwork:getReq()
  return ed.upmsg.simple_assist_req()
end

function dayAwardsNetwork:sendOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.simple_assist_open_panel()
  msg._open_panel._type = ed.dayAwardsManager.type
  self:doSendReq(msg)
end

function dayAwardsNetwork:sendGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.simple_assist_get_task_rewards()
  msg._get_task_rewards._type = ed.dayAwardsManager.type
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end

function dayAwardsNetwork:sendGetLineReward(lineId)
  self.tmpLineId = lineId
  local msg = self:getReq()
  msg._get_line_rewards = ed.upmsg.simple_assist_get_line_rewards()
  msg._get_line_rewards._type = ed.dayAwardsManager.type
  msg._get_line_rewards._line_id = lineId
  self:doSendReq(msg)
end

ed.dayAwardsNetwork = dayAwardsNetwork.getInstance()
