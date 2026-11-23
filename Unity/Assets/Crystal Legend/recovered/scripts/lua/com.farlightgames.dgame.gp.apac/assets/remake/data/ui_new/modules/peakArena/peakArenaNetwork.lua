local PeakArenaNetwork = {}
PeakArenaNetwork.__index = PeakArenaNetwork

function PeakArenaNetwork.isDebug()
  return false
end

function PeakArenaNetwork.getInstance()
  if not PeakArenaNetwork.instance then
    PeakArenaNetwork.instance = PeakArenaNetwork.create()
  end
  return PeakArenaNetwork.instance
end

function PeakArenaNetwork.create()
  local self = {}
  setmetatable(self, PeakArenaNetwork)
  return self
end

function PeakArenaNetwork:dispatch(reply)
  if self.isDebug() then
    print("---------------PeakArenaNetwork:dispatchReply----------------")
    ed.pt(reply)
  end
  if reply._open_panel then
    ed.PeakArenaManager:handleOpenPanel(reply._open_panel)
  elseif reply._refresh_oppo then
    ed.PeakArenaManager:handleRefreshOppo(reply._refresh_oppo)
  elseif reply._get_lineup then
    ed.PeakArenaManager:handleGetLineup(reply._get_lineup)
  elseif reply._set_lineup then
    ed.PeakArenaManager:handleSetLineup(reply._set_lineup)
  elseif reply._query_oppo then
    ed.PeakArenaManager:handleQueryOppo(reply._query_oppo)
  elseif reply._query_player then
    ed.PeakArenaManager:handleQueryPlayer(reply._query_player)
  elseif reply._challenge then
    ed.PeakArenaManager:handleChallengeResult(reply._challenge)
  elseif reply._get_records then
    ed.PeakArenaManager:handleGetRecords(reply._get_records)
  elseif reply._add_count then
    ed.PeakArenaManager:handleAddChallengeTimes(reply._add_count)
  elseif reply._query_summary then
    ed.PeakArenaManager:handleQuerySummary(reply._query_summary)
  elseif reply._get_replay then
    ed.PeakArenaManager:handleGetReplay(reply._get_replay)
  elseif reply._history then
    ed.PeakArenaManager:handleHistoryBoard(reply._history)
  elseif reply._medal_reward then
    ed.PeakArenaManager:handleMedalReward(reply._medal_reward)
  elseif reply._check_evolve then
    local evolveInfo = reply._check_evolve._evolve_info
    ed.PeakArenaManager:setEvolveInfo(evolveInfo)
  elseif reply._score_rank then
    FireEvent("EventPeakArenaScoreRankBoard", reply._score_rank)
  elseif reply._challenge_evolve then
    ed.PeakArenaManager:handleEvolveChallengeResult(reply._challenge_evolve)
  elseif reply._query_goods then
    ed.PeakArenaManager:handleQueryGoods(reply._query_goods)
  elseif reply._buy_goods then
    ed.PeakArenaManager:handleBuyGoods(reply._buy_goods)
  elseif reply._query_ban_list then
    ed.PeakArenaManager:handleQueryBanList(reply._query_ban_list)
  elseif reply._vote_heroes then
    ed.PeakArenaManager:handleVoteHero(reply._vote_heroes)
  end
end

function PeakArenaNetwork:notify(msg)
  ed.PeakArenaManager:handleNotify(msg)
end

function PeakArenaNetwork:createReq()
  local req = ed.upmsg.peak_arena_req()
  return req
end

function PeakArenaNetwork:sendReq(req)
  if self.isDebug() then
    print("-------------PeakArenaNetwork:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "peak_arena")
end

function PeakArenaNetwork:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = ed.upmsg.peak_arena_open_panel()
  self:sendReq(req)
end

function PeakArenaNetwork:sendRefreshOppo(force)
  if ed.PeakArenaManager:isOffSeason() then
    return
  end
  local req = self:createReq()
  req._refresh_oppo = ed.upmsg.peak_arena_refresh_oppo()
  req._refresh_oppo._force = force and 1 or 0
  self:sendReq(req)
end

function PeakArenaNetwork:sendGetLineup()
  local req = self:createReq()
  req._get_lineup = ed.upmsg.peak_arena_get_lineup()
  self:sendReq(req)
end

function PeakArenaNetwork:sendSetLineup(lineups)
  local req = self:createReq()
  req._set_lineup = ed.upmsg.peak_arena_set_lineup()
  req._set_lineup._lineups = lineups
  self:sendReq(req)
end

function PeakArenaNetwork:sendQueryPlayer(roleId)
  local req = self:createReq()
  req._query_player = ed.upmsg.peak_arena_query_player()
  req._query_player._role_id = roleId
  self:sendReq(req)
end

function PeakArenaNetwork:sendQueryOppo(roleId)
  local req = self:createReq()
  req._query_oppo = ed.upmsg.peak_arena_query_oppo()
  req._query_oppo._role_id = roleId
  self:sendReq(req)
end

function PeakArenaNetwork:sendChallengeOppo(roleId, teamIds)
  local req = self:createReq()
  req._challenge = ed.upmsg.peak_arena_challenge()
  req._challenge._role_id = roleId
  local lineups = {}
  local teamCount = #teamIds
  for i = 1, teamCount do
    if teamIds[i] and teamIds[i][1] then
      local lineup = ed.commonmsg.lineup()
      lineup._hero_id = teamIds[i] or {}
      table.insert(lineups, lineup)
    end
  end
  req._challenge._lineups = lineups
  self:sendReq(req)
end

function PeakArenaNetwork:sendChallengeEvolveOppo(roleId, teamIds)
  local req = self:createReq()
  req._challenge_evolve = ed.upmsg.peak_arena_challenge_evolve()
  req._challenge_evolve._role_id = roleId
  local lineups = {}
  local teamCount = #teamIds
  for i = 1, teamCount do
    if teamIds[i] and teamIds[i][1] then
      local lineup = ed.commonmsg.lineup()
      lineup._hero_id = teamIds[i] or {}
      table.insert(lineups, lineup)
    end
  end
  req._challenge_evolve._lineups = lineups
  self:sendReq(req)
end

function PeakArenaNetwork:sendQuerySummary(recordid, roundid)
  local req = self:createReq()
  req._query_summary = ed.upmsg.peak_arena_query_summary()
  req._query_summary._replay_id = recordid
  req._query_summary._round_id = roundid
  self:sendReq(req)
end

function PeakArenaNetwork:sendGetReply(recordid)
  local req = self:createReq()
  req._get_replay = ed.upmsg.peak_arena_get_replay()
  req._get_replay._replay_id = recordid
  self:sendReq(req)
end

function PeakArenaNetwork:sendGetRecords()
  local req = self:createReq()
  req._get_records = ed.upmsg.peak_arena_get_records()
  self:sendReq(req)
end

function PeakArenaNetwork:sendAddCount(type)
  local req = self:createReq()
  req._add_count = ed.upmsg.peak_arena_add_count()
  req._add_count._type = type
  self:sendReq(req)
end

function PeakArenaNetwork:sendPlayerRankboard()
  local req = self:createReq()
  req._medal_rank = ed.upmsg.season_arena_medal_rankboard()
  self:sendReq(req)
end

function PeakArenaNetwork:sendBottomRankboard(step)
  local req = self:createReq()
  req._score_rank = ed.upmsg.peak_arena_score_rankboard()
  req._score_rank._step = step
  self:sendReq(req)
end

function PeakArenaNetwork:sendHistoryboard()
  local req = self:createReq()
  req._history = ed.upmsg.peak_arena_history()
  self:sendReq(req)
end

function PeakArenaNetwork:sendMedalReward(rewardIdx)
  local req = self:createReq()
  req._medal_reward = ed.upmsg.peak_arena_medal_reward()
  req._medal_reward._reward_idx = rewardIdx
  self:sendReq(req)
end

function PeakArenaNetwork:sendCheckEvolve()
  local req = self:createReq()
  req._check_evolve = ed.upmsg.peak_arena_check_evolve()
  self:sendReq(req)
end

function PeakArenaNetwork:sendQueryGoods()
  local req = self:createReq()
  req._query_goods = ed.upmsg.peak_arena_query_goods()
  self:sendReq(req)
end

function PeakArenaNetwork:sendBuyGoods(groupId, goodsIndex, amount)
  local req = self:createReq()
  req._buy_goods = ed.upmsg.peak_arena_buy_goods()
  req._buy_goods._group_id = groupId
  req._buy_goods._goods_index = goodsIndex
  req._buy_goods._amount = amount
  self:sendReq(req)
end

function PeakArenaNetwork:sendQueryBanList()
  local req = self:createReq()
  req._query_ban_list = ed.upmsg.peak_arena_query_ban_list()
  self:sendReq(req)
end

function PeakArenaNetwork:sendVoteHero(heroIdList)
  local req = self:createReq()
  req._vote_heroes = ed.upmsg.peak_arena_vote_heroes()
  req._vote_heroes._hero_ids = heroIdList
  self:sendReq(req)
end

ed.PeakArenaNetwork = PeakArenaNetwork.getInstance()
