local passNetWork = {}
ed.passNetWork = passNetWork
setmetatable(passNetWork, {__index = passNetWork})

function passNetWork:simplePassOpenPanel(id)
  local msg = ed.upmsg.simple_pass_req()
  msg._open_panel = {}
  msg._open_panel._pass_id = id
  ed.send(msg, "simple_pass")
end

function passNetWork:simplePassReq(param)
  local msg = ed.upmsg.simple_pass_req()
  msg._level_reward = {}
  msg._level_reward._pass_id = param.passId
  msg._level_reward._is_all_reward = param.isAllReward
  msg._level_reward._pos = param.rewardPos
  msg._level_reward._reward_index = param.rewardIndex
  ed.send(msg, "simple_pass")
end

function passNetWork:simplePassBuyRank(id, simplePassRank)
  local msg = ed.upmsg.simple_pass_req()
  msg._buy_rank = {}
  msg._buy_rank._pass_id = id
  msg._buy_rank._pass_rank = simplePassRank
  ed.send(msg, "simple_pass")
end

function passNetWork:dispatch(simplePassReply)
  if simplePassReply._open_panel then
    ed.passDataMgr:updatePassData(simplePassReply._open_panel._pass)
  end
  if simplePassReply._level_reward then
    local rewardList = simplePassReply._level_reward._rewards
    ed.passDataMgr:updatePassData(simplePassReply._level_reward._pass)
    ed.player:addRewards(rewardList)
    ed.UITool.showRewardsFromServer(rewardList)
  end
  if simplePassReply._buy_rank then
    FireEvent("QueryDataRsp", true)
    ed.passDataMgr:updatePassData(simplePassReply._buy_rank._pass)
    ed.passDataMgr:passBuySuccess(simplePassReply._buy_rank._pass)
  end
end
