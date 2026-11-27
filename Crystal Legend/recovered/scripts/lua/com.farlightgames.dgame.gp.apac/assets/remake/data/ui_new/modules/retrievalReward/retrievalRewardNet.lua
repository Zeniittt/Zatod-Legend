local class = newclass("g")
ed.retrievalRewardNet = class

function class.dispatch(data)
  local mgr = ed.retrievalRewardMgr.getInstance()
  if data._open_panel then
    mgr:handleOpenPanel(data._open_panel)
  elseif data._take_reward then
    mgr:handleTakeReward(data._take_reward)
  end
end

function class.notify(data)
  local mgr = ed.retrievalRewardMgr.getInstance()
  mgr:handleNotify(data)
end

function class.createReq()
  local req = ed.upmsg.retrieval_reward_req()
  return req
end

function class.sendOpenPanel()
  local req = class.createReq()
  req._open_panel = {}
  ed.send(req, "retrieval_reward")
end

function class.sendTakeReward(typeList)
  local req = class.createReq()
  req._take_reward = {}
  req._take_reward._type = typeList
  ed.send(req, "retrieval_reward")
end
