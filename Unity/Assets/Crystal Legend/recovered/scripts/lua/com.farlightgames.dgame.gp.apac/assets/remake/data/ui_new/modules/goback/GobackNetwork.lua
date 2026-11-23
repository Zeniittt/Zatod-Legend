local GobackNetwork = {}
GobackNetwork.__index = GobackNetwork
local instance
local printNetData = true

function GobackNetwork.getInstance()
  if not instance then
    instance = GobackNetwork.create()
  end
  return instance
end

function GobackNetwork.create()
  local self = {}
  setmetatable(self, GobackNetwork)
  return self
end

function GobackNetwork:dispatch(msg)
  if printNetData then
    print("------------------------GobackNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.GobackManager:handleOpenPanel(msg._open_panel)
  elseif msg._once_reward then
    ed.GobackManager:handleGetOnceReward(msg._once_reward)
  elseif msg._login_reward then
    ed.GobackManager:handleGetLoginRewards(msg._login_reward)
  elseif msg._buy_goods then
    ed.GobackManager:handleBuyGoods(msg._buy_goods)
  elseif msg._task_line_reward then
    ed.GobackManager:handleGetTaskRewards(msg._task_line_reward)
  end
end

function GobackNetwork:doSendReq(msg)
  if printNetData then
    print("------------------------GobackNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "goback")
end

function GobackNetwork:getReq()
  return ed.upmsg.goback_req()
end

function GobackNetwork:sendOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.goback_open_panel()
  self:doSendReq(msg)
end

function GobackNetwork:sendGobackConfirm()
  local msg = self:getReq()
  msg._once_reward = ed.upmsg.goback_once_reward()
  self:doSendReq(msg)
end

function GobackNetwork:sendLoginReward(index)
  local msg = self:getReq()
  msg._login_reward = ed.upmsg.goback_login_reward()
  msg._login_reward._index = index
  self:doSendReq(msg)
end

function GobackNetwork:sendBuyGift(index)
  local msg = self:getReq()
  msg._buy_goods = ed.upmsg.goback_buy_goods()
  msg._buy_goods._goods_id = index
  self:doSendReq(msg)
end

function GobackNetwork:getTaskReward(index)
  local msg = self:getReq()
  msg._task_line_reward = ed.upmsg.goback_task_line_reward()
  msg._task_line_reward._index = index
  self:doSendReq(msg)
end

ed.GobackNetwork = GobackNetwork.getInstance()
return GobackNetwork
