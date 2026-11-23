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

function class:dispatchReply(msg)
  if printNetData then
    print("------------------------pvpNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._error_code then
    ed.pvpManager:handleErrorCode(msg._error_code)
    return
  end
  if msg._open_panel then
    ed.pvpManager:handleOpenPanelReply(msg._open_panel)
  elseif msg._start_battle then
    ed.pvpManager:handleStartBattleReply(msg._start_battle)
  elseif msg._end_battle then
    ed.pvpManager:handleEndBattleReply(msg._end_battle)
  elseif msg._sweep_reward then
    ed.pvpManager:handleSweepReply(msg._sweep_reward, self.sweep or 1)
  elseif msg._clear_battle_cd then
    ed.pvpManager:handleClearBattleCDReply(msg._clear_battle_cd)
  elseif msg._buy_battle_chance then
    ed.pvpManager:handleBuyPvpTimes(msg._buy_battle_chance)
  elseif msg._set_lineup then
    ed.pvpManager:handleSetLineup(msg._set_lineup)
  elseif msg._apply_oppo then
    ed.pvpManager:handleApplyOppo(msg._apply_oppo)
  elseif msg._query_replay then
    ed.pvpManager:handleQueryReplay(msg._query_replay)
  elseif msg._query_summary then
    ed.pvpManager:handleQuerySummary(msg._query_summary)
  elseif msg._query_records then
    ed.pvpManager:handleQueryRecord(msg._query_records)
  elseif msg._query_oppo then
    ed.pvpManager:handleQueryOppo(msg._query_oppo)
  elseif msg._use_background then
    ed.pvpManager:handleUseBackground(msg._use_background)
  end
end

function class:doSendReq(msg)
  if printNetData then
    print("------------------------pvpNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "ladder")
end

function class:getReq()
  return ed.upmsg.ladder()
end

function class:sendOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.open_panel()
  self:doSendReq(msg)
end

function class:sendApplyOpponent(PVPId, floor, lineup)
  local msg = self:getReq()
  msg._apply_opponent = ed.upmsg.apply_opponent()
  self:doSendReq(msg)
end

function class:sendStartBattle(uid, lineup)
  local msg = self:getReq()
  msg._start_battle = ed.upmsg.start_battle()
  msg._set_lineup._oppo_user_id = uid
  msg._set_lineup._attack_lineup = lineup
  self:doSendReq(msg)
end

function class:sendEndBattle(result)
  local msg = self:getReq()
  msg._end_battle = ed.upmsg.end_battle()
  msg._end_battle._result = result
  self:doSendReq(msg)
end

function class:sendSetLineup(lineup, banhero)
  local msg = self:getReq()
  msg._set_lineup = ed.upmsg.set_lineup()
  msg._set_lineup._lineup = lineup
  msg._set_lineup._ban_hero = banhero
  self:doSendReq(msg)
end

function class:sendQueryRecords()
  local msg = self:getReq()
  msg._query_records = ed.upmsg.query_records()
  self:doSendReq(msg)
end

function class:sendBuyTimes()
  local msg = self:getReq()
  msg._buy_battle_chance = {}
  self:doSendReq(msg)
end

function class:sendClearBtCD()
  local msg = self:getReq()
  msg._clear_battle_cd = {}
  self:doSendReq(msg)
end

function class:sendApplyOpponent()
  local msg = self:getReq()
  msg._apply_opponent = {}
  self:doSendReq(msg)
end

function class:sendSweepPvp(uid, times)
  local msg = self:getReq()
  msg._sweep_reward = ed.upmsg.sweep_reward()
  msg._sweep_reward._oppo_uid = uid
  msg._sweep_reward._sweep_count = times
  self.sweep = times
  self:doSendReq(msg)
end

function class:sendQueryReplay(rid, svrid)
  local msg = self:getReq()
  msg._query_replay = ed.upmsg.query_replay()
  msg._query_replay._record_index = rid
  msg._query_replay._record_svrid = svrid
  self:doSendReq(msg)
end

function class:sendQueryOppo(uid)
  local msg = self:getReq()
  msg._query_oppo = ed.upmsg.query_oppo_info()
  msg._query_oppo._oppo_user_id = uid
  self:doSendReq(msg)
end

function class:sendLadderFight(content, chatType, accessory, channel, roleIdList)
  local msg = ed.upmsg.ladder()
  local targetInfo = {}
  for i, roleId in ipairs(roleIdList or {}) do
    local data = {}
    data._role_id = roleId
    table.insert(targetInfo, data)
  end
  msg._share_fight = {}
  msg._share_fight._chat_broad_say = {}
  msg._share_fight._chat_broad_say._content_type = chatType
  msg._share_fight._chat_broad_say._targets = targetInfo
  msg._share_fight._chat_broad_say._channel = channel
  msg._share_fight._chat_broad_say._content = content
  msg._share_fight._chat_broad_say._accessory = accessory
  ed.send(msg, "ladder")
end

function class:sendUseBackground(id)
  local msg = self:getReq()
  msg._use_background = ed.upmsg.arena_use_background()
  msg._use_background._background_id = id
  ed.pt(msg)
  self:doSendReq(msg)
end

ed.pvpNetwork = class.getInstance()
return class
