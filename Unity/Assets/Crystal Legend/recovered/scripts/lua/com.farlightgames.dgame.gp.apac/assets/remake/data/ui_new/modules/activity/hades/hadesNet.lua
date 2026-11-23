local class = {}
ed.hadesHeatNet = class

function class.sendOpenPanel(groupId)
  local msg = ed.upmsg.heat_req()
  msg._open_panel = {}
  msg._open_panel._group_id = groupId
  ed.send(msg, "heat")
end

function class.sendEnterStage(groupId, stageId, lineup, itemId)
  local msg = ed.upmsg.heat_req()
  msg._enter_stage = {}
  msg._enter_stage._group_id = groupId
  msg._enter_stage._stage_id = stageId
  msg._enter_stage._lineup = lineup
  msg._enter_stage._item_id = itemId
  ed.send(msg, "heat")
end

function class.sendExitStage(groupId, result, operations, battleTime, chooseHeat, totalHeat)
  local msg = ed.upmsg.heat_req()
  msg._exit_stage = {}
  msg._exit_stage._group_id = groupId
  msg._exit_stage._result = result
  msg._exit_stage._operations = operations
  msg._exit_stage._battle_time = battleTime
  msg._exit_stage._choose_heat = chooseHeat
  msg._exit_stage._total_heat = totalHeat
  ed.send(msg, "heat")
end

function class.sendRankboard(groupId)
  local msg = ed.upmsg.heat_req()
  msg._rankboard = {}
  msg._rankboard._group_id = groupId
  ed.send(msg, "heat")
end

function class.sendTaskRewards(groupId, lineId, taskId)
  local msg = ed.upmsg.heat_req()
  msg._get_task_rewards = {}
  msg._get_task_rewards._group_id = groupId
  msg._get_task_rewards._line_id = lineId
  msg._get_task_rewards._task_id = taskId
  ed.send(msg, "heat")
end

function class.dispatch(netReply)
  if netReply._open_panel then
    class.openPanelReply(netReply._open_panel)
  elseif netReply._enter_stage then
    class.enterStageReply(netReply._enter_stage)
  elseif netReply._exit_stage then
    class.exitStageReply(netReply._exit_stage)
  elseif netReply._rankboard then
    class.rankboardReply(netReply._rankboard)
  elseif netReply._get_task_rewards then
    class.getTaskRewardsReply(netReply._get_task_rewards)
  end
end

function class.notify(netReply)
  local hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  hadesHeatMgr:handleNotify(netReply)
end

function class.openPanelReply(_open_panel)
  local hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  hadesHeatMgr:handleOpenPanel(_open_panel)
end

function class.enterStageReply(_enter_stage)
  local hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  hadesHeatMgr:handleEnterStage(_enter_stage)
end

function class.exitStageReply(_exit_stage)
  local hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  hadesHeatMgr:handleExitStage(_exit_stage)
end

function class.rankboardReply(_rankboard)
  local hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  hadesHeatMgr:handleRankboard(_rankboard)
end

function class.getTaskRewardsReply(_get_task_rewards)
  local hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  hadesHeatMgr:handleGetTaskRewards(_get_task_rewards)
end
