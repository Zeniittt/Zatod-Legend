local sweetPartyNetwork = {}
sweetPartyNetwork.__index = sweetPartyNetwork
local instance
local printNetData = false

function sweetPartyNetwork.getInstance()
  if not instance then
    instance = sweetPartyNetwork.create()
  end
  return instance
end

function sweetPartyNetwork.create()
  local self = {}
  setmetatable(self, sweetPartyNetwork)
  return self
end

function sweetPartyNetwork:dispatch(msg)
  if printNetData then
    print("------------------------sweetPartyNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.sweetPartyManager:handleOpenPanel(msg._open_panel)
  elseif msg._get_task_rewards then
    ed.sweetPartyManager:handleGetTaskRewards(msg._get_task_rewards)
  elseif msg._get_line_rewards then
    ed.sweetPartyManager:handleGetLineRewards(msg._get_line_rewards, self.tmpLineId)
  end
end

function sweetPartyNetwork:doSendReq(msg)
  if printNetData then
    print("------------------------sweetPartyNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "sweet_party")
end

function sweetPartyNetwork:getReq()
  return ed.upmsg.sweet_party_req()
end

function sweetPartyNetwork:sendOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.sweet_party_open_panel()
  self:doSendReq(msg)
end

function sweetPartyNetwork:sendGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.sweet_party_get_task_rewards()
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end

function sweetPartyNetwork:sendGetLineReward(lineId)
  self.tmpLineId = lineId
  local msg = self:getReq()
  msg._get_line_rewards = ed.upmsg.sweet_party_get_line_rewards()
  msg._get_line_rewards._line_id = lineId
  self:doSendReq(msg)
end

ed.sweetPartyNetwork = sweetPartyNetwork.getInstance()
