local CreviceDefendNetWork = {}
CreviceDefendNetWork.__index = CreviceDefendNetWork
local debugNet = false

function CreviceDefendNetWork.create()
  local self = {}
  setmetatable(self, CreviceDefendNetWork)
  self:registerEvents()
  return self
end

function CreviceDefendNetWork:registerEvents()
end

function CreviceDefendNetWork:notify(notify)
  if debugNet then
    print("-------------CreviceDefendManager:notify--------------")
    ed.pt(notify)
  end
  ed.CreviceDefendManager:handleNotify(notify)
end

function CreviceDefendNetWork:dispatch(msg)
  if debugNet then
    print("+++++++++++++++++ CreviceDefendManager:dispatch ++++++++++++")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.CreviceDefendManager:handleOpenPanel(msg._open_panel)
  elseif msg._zone_rankboard then
    ed.CreviceDefendManager:handleZoneRank(msg._zone_rankboard)
  elseif msg._recommend_lineup then
    ed.CreviceDefendManager:handleLineup(msg._recommend_lineup)
  elseif msg._query_summary then
    ed.CreviceDefendManager:handleQuerySummary(msg._query_summary)
  elseif msg._query_records then
    ed.CreviceDefendManager:handleQueryRecords(msg._query_records)
  elseif msg._buy_challenge_count then
    ed.CreviceDefendManager:handleBuyChallengeCount(msg._buy_challenge_count)
  elseif msg._task_reward then
    ed.CreviceDefendManager:handleOpenTask(msg._task_reward)
  elseif msg._challenge_record then
    ed.CreviceDefendManager:handleChallengeRecord(msg._challenge_record)
  elseif msg._open_recommend then
    ed.CreviceDefendManager:handleOpenRecommend(msg._open_recommend)
  elseif msg._challenge then
    ed.CreviceDefendBattleManager:handleChallenge(msg._challenge)
  end
end

function CreviceDefendNetWork:createReq()
  local req = ed.upmsg.crevice_defend_req()
  return req
end

function CreviceDefendNetWork:sendReq(req)
  if debugNet then
    print("-------------CrusadeNetwork:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "crevice_defend")
end

function CreviceDefendNetWork:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = ed.upmsg.crevice_defend_open_panel()
  self:sendReq(req)
end

function CreviceDefendNetWork:sendOpenRankPanel()
  local req = self:createReq()
  req._zone_rankboard = ed.upmsg.crevice_defend_zone_rankboard()
  self:sendReq(req)
end

function CreviceDefendNetWork:sendStartChallenge(line)
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_challenge()
  msg._lineups = {}
  for i = 1, #line do
    local lineup = ed.commonmsg.lineup()
    lineup._hero_id = line[i]
    msg._lineups[i] = lineup
  end
  req._challenge = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendOpenRecommendLineUp(roleId)
  local req = self:createReq()
  req._recommend_lineup = ed.upmsg.crevice_defend_recommend_lineup()
  req._recommend_lineup._role_id = roleId
  self:sendReq(req)
end

function CreviceDefendNetWork:sendOpenBattleReport(replay_id, round_id)
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_query_summary()
  msg._replay_id = replay_id
  msg._round_id = round_id
  req._query_summary = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendOpenBattleRecord(replay_id)
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_query_records()
  msg._replay_id = replay_id
  req._query_records = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendBuyChallengeTimes()
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_buy_challenge_count()
  req._buy_challenge_count = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendOpenTask()
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_open_task()
  req._open_task = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendGetTaskRewards(task_id)
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_task_reward()
  msg._task_id = task_id
  req._task_reward = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendSearchRecord()
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_challenge_record()
  req._challenge_record = msg
  self:sendReq(req)
end

function CreviceDefendNetWork:sendOpenRecommendView()
  local req = self:createReq()
  local msg = ed.upmsg.crevice_defend_open_recommend()
  req._open_recommend = msg
  self:sendReq(req)
end

ed.CreviceDefendNetWork = CreviceDefendNetWork.create()
