local actiAdventureNet = {}
ed.actiAdventureNet = actiAdventureNet

function actiAdventureNet.openPanel()
  local msg = ed.upmsg.act_adventure_req()
  msg._open_panel = {}
  ed.send(msg, "act_adventure")
end

function actiAdventureNet.enterStage(actId, stageId, lineup)
  local msg = ed.upmsg.act_adventure_req()
  msg._enter_stage = {}
  msg._enter_stage._act_id = actId
  msg._enter_stage._stage_id = stageId
  msg._enter_stage._lineup = lineup
  ed.send(msg, "act_adventure")
end

function actiAdventureNet.exitStage(result, operations)
  local msg = ed.upmsg.act_adventure_req()
  msg._exit_stage = {}
  msg._exit_stage._result = result
  msg._exit_stage._operations = operations
  ed.send(msg, "act_adventure")
end

function actiAdventureNet.getRewards(actId, rewardsId)
  local msg = ed.upmsg.act_adventure_req()
  msg._get_rewards = {}
  msg._get_rewards._act_id = actId
  msg._get_rewards._rewards_id = rewardsId
  ed.send(msg, "act_adventure")
end

function actiAdventureNet.sweep(actId, stageId, sweepTimes)
  local msg = ed.upmsg.act_adventure_req()
  msg._sweep = {}
  msg._sweep._act_id = actId
  msg._sweep._stage_id = stageId
  msg._sweep._sweep_times = sweepTimes
  ed.send(msg, "act_adventure")
end

function actiAdventureNet.buyVitality(actId, times)
  local msg = ed.upmsg.act_adventure_req()
  msg._buy_vitality = {}
  msg._buy_vitality._act_id = actId
  msg._buy_vitality._times = times
  ed.send(msg, "act_adventure")
end

function actiAdventureNet.dispatch(netReply)
  if netReply._open_panel then
    actiAdventureNet.openPanelReply(netReply._open_panel)
  elseif netReply._enter_stage then
    actiAdventureNet.enterStageReply(netReply._enter_stage)
  elseif netReply._exit_stage then
    actiAdventureNet.exitStageReply(netReply._exit_stage)
  elseif netReply._get_rewards then
    actiAdventureNet.getRewardsReply(netReply._get_rewards)
  elseif netReply._sweep then
    actiAdventureNet.sweepReply(netReply._sweep)
  elseif netReply._buy_vitality then
    actiAdventureNet.buyVitalityReply(netReply._buy_vitality)
  end
end

function actiAdventureNet.openPanelReply(_open_panel)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  actiAdventureMgr:handleOpenPanel(_open_panel)
end

function actiAdventureNet.enterStageReply(_enter_stage)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  actiAdventureMgr:handleEnterStage(_enter_stage)
end

function actiAdventureNet.exitStageReply(_exit_stage)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  actiAdventureMgr:handleExitStage(_exit_stage)
end

function actiAdventureNet.getRewardsReply(_get_rewards)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  actiAdventureMgr:handleGetRewards(_get_rewards)
end

function actiAdventureNet.sweepReply(_sweep)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  actiAdventureMgr:handleSweep(_sweep)
end

function actiAdventureNet.buyVitalityReply(_buy_vitality)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  actiAdventureMgr:handleBuyVitality(_buy_vitality)
end
