local riseStarNet = {}
riseStarNet.__index = riseStarNet
local debugNet = false
local riseStarNet_type = 4

function riseStarNet.create()
  local self = {}
  setmetatable(self, riseStarNet)
  self:registerEvents()
  return self
end

function riseStarNet:registerEvents()
end

function riseStarNet:dispatch(msg)
  if debugNet then
    print("-------------riseStarNet:dispatch--------------")
    ed.pt(msg)
  end
  if msg._query_goods then
    ed.riseStarMgr:handleQueryGoods(msg._query_goods)
  elseif msg._choose_rewards then
    ed.riseStarMgr:handleChooseGoods(msg._choose_rewards)
  elseif msg._buy_goods then
    ed.riseStarMgr:handleBuyGoods(msg._buy_goods)
  end
  local type = ""
  if msg._open_panel then
    type = msg._open_panel._simple_assist._type
  elseif msg._get_task_rewards then
    type = msg._get_task_rewards._type
  elseif msg._get_line_rewards then
    type = msg._get_line_rewards._type
  end
  if type ~= "rise_star" then
    return
  end
  if msg._open_panel then
    ed.riseStarMgr:handleTaskOpenPanel(msg._open_panel)
  elseif msg._get_task_rewards then
    ed.riseStarMgr:handleGetTaskRewards(msg._get_task_rewards)
  elseif msg._get_line_rewards then
    ed.riseStarMgr:handleGetLineRewards(msg._get_line_rewards, self.tmpLineId)
  end
end

function riseStarNet:notifyTask(data)
  data = ed.copyProto(data)
  data = data._reward_hints and data._reward_hints[riseStarNet_type]
  if data and data._type ~= "rise_star" then
    return
  end
  ed.riseStarMgr:handleNotifyTask(data)
end

function riseStarNet:getReq()
  return ed.upmsg.simple_assist_req()
end

function riseStarNet:doSendReq(msg)
  ed.send(msg, "simple_assist")
end

function riseStarNet:sendOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.simple_assist_open_panel()
  msg._open_panel._type = riseStarNet_type
  self:doSendReq(msg)
end

function riseStarNet:sendGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.simple_assist_get_task_rewards()
  msg._get_task_rewards._type = riseStarNet_type
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end

function riseStarNet:sendGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.simple_assist_get_task_rewards()
  msg._get_task_rewards._type = riseStarNet_type
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end

function riseStarNet:sendQueryGoods()
  local msg = self:getReq()
  msg._query_goods = ed.upmsg.simple_assist_query_goods()
  msg._query_goods._type = riseStarNet_type
  self:doSendReq(msg)
end

function riseStarNet:sendChooseRewards(group_id, group_index, choose_group, choose_index)
  local msg = self:getReq()
  msg._choose_rewards = ed.upmsg.simple_assist_choose_rewards()
  msg._choose_rewards._type = riseStarNet_type
  msg._choose_rewards._group_id = group_id
  msg._choose_rewards._group_index = group_index
  msg._choose_rewards._choose_group = choose_group
  msg._choose_rewards._choose_index = choose_index
  self:doSendReq(msg)
end

function riseStarNet:sendBuyGoods(group_id, group_index, number, price)
  local msg = self:getReq()
  self.temp_costNum = price * number
  msg._buy_goods = ed.upmsg.simple_assist_buy_goods()
  msg._buy_goods._type = riseStarNet_type
  msg._buy_goods._group_id = group_id
  msg._buy_goods._group_index = group_index
  msg._buy_goods._amount = number
  self:doSendReq(msg)
end

ed.riseStarNet = riseStarNet.create()
