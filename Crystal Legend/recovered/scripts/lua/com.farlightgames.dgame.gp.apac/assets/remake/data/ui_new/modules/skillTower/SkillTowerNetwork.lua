local class = {}
class.__index = class
local instance
local printNetData = false

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, class)
  return self
end

function class:dispatchTowerReply(msg)
  if printNetData then
    print("------------------------SkillTowerNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._error_code then
    ed.SkillTowerManager:handleTowerErrorCode(msg._error_code)
    return
  end
  if msg._open_panel then
    ed.SkillTowerManager:handleTowerOpenPanelReply(msg._open_panel)
  elseif msg._start_battle then
    ed.SkillTowerManager:handleTowerStartBattleReply(msg._start_battle)
  elseif msg._end_battle then
    ed.SkillTowerManager:handleTowerEndBattleReply(msg._end_battle)
  elseif msg._sweep then
    ed.SkillTowerManager:handleTowerSweepReply(msg._sweep)
  elseif msg._star_reward then
    ed.SkillTowerManager:handleTowerStarRewardReply(msg._star_reward)
  elseif msg._candle_buy then
    ed.SkillTowerManager:handleTowerCandleBuyReply(msg._candle_buy)
  end
end

function class:doSendTowerReq(msg)
  if printNetData then
    print("------------------------SkillTowerNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "fancy_tower")
end

function class:getTowerReq()
  return ed.upmsg.fancy_tower_req()
end

function class:sendTowerOpenPanel()
  local msg = self:getTowerReq()
  msg._open_panel = ed.upmsg.fancy_tower_open_panel()
  self:doSendTowerReq(msg)
end

function class:sendTowerStartBattle(towerId, floor, lineup)
  local msg = self:getTowerReq()
  msg._start_battle = ed.upmsg.fancy_tower_start_battle()
  msg._start_battle._tower_id = towerId
  msg._start_battle._floor = floor
  msg._start_battle._lineup = lineup
  self:doSendTowerReq(msg)
end

function class:sendTowerEndBattle(result, operations, stars)
  local msg = self:getTowerReq()
  msg._end_battle = ed.upmsg.fancy_tower_end_battle()
  msg._end_battle._result = result
  msg._end_battle._operations = operations
  msg._end_battle._stage_star = stars
  self:doSendTowerReq(msg)
end

function class:sendTowerSweep(towerId, floorId, times)
  local msg = self:getTowerReq()
  msg._sweep = ed.upmsg.fancy_tower_sweep()
  msg._sweep._tower_id = towerId
  msg._sweep._floor = floorId
  msg._sweep._times = times or 1
  self:doSendTowerReq(msg)
end

function class:sendTowerStarReward(rewardId)
  local msg = self:getTowerReq()
  msg._star_reward = ed.upmsg.fancy_tower_star_reward()
  msg._star_reward._star_id = rewardId
  ed.SkillTowerManager.curGetStarRewardId = rewardId
  self:doSendTowerReq(msg)
end

function class:sendTowerCandleBuy(times)
  local msg = self:getTowerReq()
  msg._candle_buy = ed.upmsg.fancy_tower_candle_buy()
  msg._candle_buy._count = times
  self:doSendTowerReq(msg)
end

function class:dispatchExTowerReply(msg)
  if printNetData then
    print("------------------------SkillAbyssNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.SkillTowerManager:handleAbyssOpenPanelReply(msg._open_panel)
  elseif msg._enter_floor then
    ed.SkillTowerManager:handleAbyssEnterStageReply(msg._enter_floor)
  elseif msg._exit_floor then
    ed.SkillTowerManager:handleAbyssExitStageReply(msg._exit_floor)
  elseif msg._rank then
    ed.SkillTowerManager:handleAbyssRankReply(msg._rank)
  elseif msg._pass_records then
    ed.SkillTowerManager:handleAbyssPassRecordsReply(msg._pass_records)
  end
end

function class:sendExTowerOpenPanel()
  local msg = ed.upmsg.fancy_abyss_req()
  msg._open_panel = ed.upmsg.fancy_abyss_open_panel()
  ed.send(msg, "fancy_abyss")
end

function class:sendExTowerEndBattle(result, operations, battleTime)
  local msg = ed.upmsg.fancy_abyss_req()
  msg._exit_floor = ed.upmsg.fancy_abyss_exit_floor()
  msg._exit_floor._result = result
  msg._exit_floor._operations = operations
  msg._exit_floor._battle_time = battleTime
  ed.send(msg, "fancy_abyss")
end

function class:sendExTowerStartBattle(floorId, lineup)
  if ed.SkillTowerManager.curEnterTime == 0 then
    ed.showToast(T("\230\136\152\230\150\151\230\172\161\230\149\176\228\184\141\232\182\179"))
    return
  end
  local msg = ed.upmsg.fancy_abyss_req()
  msg._enter_floor = ed.upmsg.fancy_abyss_enter_floor()
  msg._enter_floor._season_id = ed.SkillTowerManager.curAbyssSeason
  msg._enter_floor._floor_id = floorId
  msg._enter_floor._lineup = lineup
  ed.send(msg, "fancy_abyss")
end

function class:sendExTowerRankBoard(type)
  local msg = ed.upmsg.fancy_abyss_req()
  msg._time_rank = ed.upmsg.fancy_abyss_time_rankboard()
  msg._time_rank._type = type
  ed.send(msg, "fancy_abyss")
end

class.PassRecordType = {
  [1] = "self",
  [2] = "friends_and_guild"
}

function class:sendExTowerPassRecords(type, floor)
  local msg = ed.upmsg.fancy_abyss_req()
  msg._pass_records = ed.upmsg.fancy_abyss_pass_records()
  msg._pass_records._type = self.PassRecordType[type]
  msg._pass_records._floor_id = floor
  ed.send(msg, "fancy_abyss")
end

ed.SkillTowerNetwork = class.getInstance()
return class
