local CupArenaNetwork = {}
CupArenaNetwork.__index = CupArenaNetwork

function CupArenaNetwork.create()
  local objetc = {}
  setmetatable(objetc, CupArenaNetwork)
  return objetc
end

function CupArenaNetwork:dispatch(msg)
  if msg._error_code then
    return
  end
  if msg._season then
    ed.CupArenaManager:setCurrentSeason(msg._season)
  end
  if msg._not_entry then
    ed.CupArenaManager:handleNotEntry(msg._not_entry)
  elseif msg._entry then
    ed.CupArenaManager:handleEntry(msg._entry)
  elseif msg._audition then
    ed.CupArenaManager:handleAudition(msg._audition)
  elseif msg._match_prepare then
    ed.CupArenaManager:handleKnockout(msg._match_prepare, ed.CupArenaManager.KnockState.Prepare)
  elseif msg._match_out then
    ed.CupArenaManager:handleKnockout(msg._match_out, ed.CupArenaManager.KnockState.Out)
  elseif msg._get_lineup then
    ed.CupArenaManager:handleGetDefensiveLineup(msg._get_lineup)
  elseif msg._set_lineup then
    ed.CupArenaManager:handleSetDefensiveLineup(msg._set_lineup, false)
  elseif msg._open_challenge then
    ed.CupArenaManager:handleOpenChallenge(msg._open_challenge)
  elseif msg._refresh_oppo then
    ed.CupArenaManager:handleRefreshOppos(msg._refresh_oppo)
  elseif msg._oppo_teams then
    ed.CupArenaManager:handleOppoTeams(msg._oppo_teams)
  elseif msg._challenge then
    ed.CupArenaManager:handleChallengeResult(msg._challenge)
  elseif msg._clear_cd then
    FireEvent("EventCupArenaClearCD")
  elseif msg._buy_count then
    ed.CupArenaManager:handleBuyCount(msg._buy_count)
  elseif msg._challenge_record then
    ed.CupArenaManager:handleBattleRecord(msg._challenge_record, false)
  elseif msg._get_replay then
    ed.CupArenaManager:handleGetReplay(msg._get_replay)
  elseif msg._query_summary then
    ed.CupArenaManager:handleQuerySummary(msg._query_summary)
  elseif msg._medal_reward then
    FireEvent("EventCupArenaMedalReward", msg._medal_reward)
  elseif msg._match_schedule then
    ed.CupArenaManager:handleMatchFinalSchedule(msg._match_schedule)
  elseif msg._match_group then
    ed.CupArenaManager:handleMatchGroupSchedule(msg._match_group)
  elseif msg._view_user then
    ed.CupArenaManager:handleViewUser(msg._view_user)
  elseif msg._open_bet then
    ed.CupArenaManager:handleOpenGamblePanel(msg._open_bet)
  elseif msg._bet_match then
    ed.CupArenaManager:handleGambleReply(msg._bet_match)
  elseif msg._bet_record then
    ed.CupArenaManager:handleGambleRecord(msg._bet_record)
  elseif msg._history then
    ed.CupArenaManager:handleSeasonHistoryData(msg._history)
  elseif msg._top_rankboard then
    ed.CupArenaManager:handleTopRankboard(msg._top_rankboard)
  elseif msg._user_rankboard then
    FireEvent("EventCupArenaUserRankboard", msg._user_rankboard)
  elseif msg._camp_rankboard then
    FireEvent("EventCupArenaCampRankboard", msg._camp_rankboard)
  elseif msg._match_rankboard then
    FireEvent("EventCupArenaMatchRankboard", msg._match_rankboard)
  elseif msg._time_schedule then
    ed.CupArenaManager:handleTimelineReply(msg._time_schedule)
  elseif msg._open_reward then
    ed.CupArenaManager:handleRewardData(msg._open_reward)
  elseif msg._set_match_lineup then
    ed.CupArenaManager:handleSetDefensiveLineup(msg._set_match_lineup, true)
  elseif msg._match_record then
    ed.CupArenaManager:handleBattleRecord(msg._match_record, true)
  elseif msg._open_task then
    ed.CupArenaManager:handleOpenTask(msg._open_task)
  elseif msg._audition_achievement then
    ed.CupArenaManager:handleAuditionSummary(msg._audition_achievement)
  elseif msg._open_camp_reward then
    FireEvent("EventCupArenaOpenCampReward", msg._open_camp_reward)
  elseif msg._paint_trigger then
    ed.CupArenaManager:handlePaintTrigger(msg._paint_trigger)
  end
end

function CupArenaNetwork:logPrint(msg)
  print("+++++++++++++++++ CupArenaNetwork:send ++++++++++++")
  ed.pt(msg)
end

function CupArenaNetwork:sendOpenPanel(isOpen, isFirst)
  ed.CupArenaManager:setOpenPanel(isOpen)
  ed.CupArenaManager.isFirstOpen = isFirst
  if ed.CupArenaManager:getEntryRedFlag() then
    ed.CupArenaManager:setEntryRedFlag(false)
  end
  local msg = ed.upmsg.cup_arena_req()
  msg._open_panel = ed.upmsg.cup_arena_open_panel()
  ed.send(msg, "cup_arena")
  ed.endTeach("openCupArena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendEntryRace()
  local msg = ed.upmsg.cup_arena_req()
  msg._entry = ed.upmsg.cup_arena_entry()
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendGetDefensiveLineup()
  local msg = ed.upmsg.cup_arena_req()
  msg._get_lineup = ed.upmsg.cup_arena_get_lineup()
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendSetDefensiveLineup(teamDatas)
  local msg = ed.upmsg.cup_arena_req()
  msg._set_lineup = ed.upmsg.cup_arena_set_lineup()
  msg._set_lineup._lineups = {}
  for i, heroArr in ipairs(teamDatas) do
    local idArr = {}
    local hiddenArr = {}
    for _, heroItem in ipairs(heroArr) do
      table.insert(idArr, heroItem.id)
      table.insert(hiddenArr, heroItem.isHidden and 1 or 0)
    end
    local lineup = ed.commonmsg.cup_arena_lineup()
    lineup._hero_ids = idArr
    lineup._hidden = hiddenArr
    msg._set_lineup._lineups[i] = lineup
  end
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendOpenChallenge()
  local msg = ed.upmsg.cup_arena_req()
  msg._open_challenge = ed.upmsg.cup_arena_open_challenge()
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
  if ed.CupArenaManager:getFirstChallengeRedFlag() then
    ed.CupArenaManager:setFirstChallengeRedFlag(false)
  end
end

function CupArenaNetwork:sendRefreshOppo(isForce)
  local msg = ed.upmsg.cup_arena_req()
  msg._refresh_oppo = ed.upmsg.cup_arena_refresh_oppo()
  msg._refresh_oppo._is_force = isForce and 1 or 0
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendGetOppoTeams(roleId)
  local msg = ed.upmsg.cup_arena_req()
  msg._oppo_teams = ed.upmsg.cup_arena_oppo_teams()
  msg._oppo_teams._role_id = roleId
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendChallengeOppo(roleId, teams)
  local msg = ed.upmsg.cup_arena_req()
  msg._challenge = ed.upmsg.cup_arena_challenge()
  msg._challenge._role_id = roleId
  msg._challenge._lineups = {}
  for i = 1, #teams do
    local lineup = ed.commonmsg.lineup()
    lineup._hero_id = teams[i]
    msg._challenge._lineups[i] = lineup
  end
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendClearChallengeCD()
  local msg = ed.upmsg.cup_arena_req()
  msg._clear_cd = ed.upmsg.cup_arena_clear_cd()
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendGetBattleRecord(isKnockout, isOpen)
  if ed.CupArenaManager:getChallengeRecordRedFlag() then
    ed.CupArenaManager:setChallengeRecordRedFlag(false)
  end
  ed.CupArenaManager:setOpenBattleRecordView(isOpen)
  if isKnockout then
    local msg = ed.upmsg.cup_arena_req()
    msg._match_record = ed.upmsg.cup_arena_match_record()
    ed.send(msg, "cup_arena")
    self:logPrint(msg)
  else
    local msg = ed.upmsg.cup_arena_req()
    msg._challenge_record = ed.upmsg.cup_arena_challenge_record()
    ed.send(msg, "cup_arena")
    self:logPrint(msg)
  end
end

function CupArenaNetwork:sendBuyChallengeCount()
  local msg = ed.upmsg.cup_arena_req()
  msg._buy_count = ed.upmsg.cup_arena_buy_count()
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendGetReply(replyId, matchId, data)
  local msg = ed.upmsg.cup_arena_req()
  msg._get_replay = ed.upmsg.cup_arena_get_replay()
  if nil ~= replyId then
    msg._get_replay._replay_id = replyId
  end
  if nil ~= matchId then
    msg._get_replay._match_id = matchId
  end
  ed.CupArenaManager:setReplayScoreData(data)
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendQuerySummary(replyId, roundId, matchId)
  local msg = ed.upmsg.cup_arena_req()
  msg._query_summary = ed.upmsg.cup_arena_query_summary()
  msg._query_summary._replay_id = replyId
  msg._query_summary._round_id = roundId
  msg._query_summary._match_id = matchId
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendMatchFinalSchedule(isOpen)
  ed.CupArenaManager:setOpenMatchFinalScheduleView(isOpen)
  local msg = ed.upmsg.cup_arena_req()
  msg._match_schedule = ed.upmsg.cup_arena_match_schedule()
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendMatchGroupSchedule(groupId, isOpen)
  ed.CupArenaManager:setOpenMatchGroupScheduleView(isOpen)
  local msg = ed.upmsg.cup_arena_req()
  msg._match_group = ed.upmsg.cup_arena_match_group()
  msg._match_group._group_id = groupId
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendViewUser(roleId, isChallenge)
  if isChallenge then
    ed.CupArenaManager:setChallengeRoleIdByInfo(roleId)
  else
    ed.CupArenaManager:setChallengeRoleIdByInfo(nil)
  end
  local msg = ed.upmsg.cup_arena_req()
  msg._view_user = ed.upmsg.cup_arena_view_user()
  msg._view_user._role_id = roleId
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendKnockoutSetDefensiveLineup(teamDatas)
  local msg = ed.upmsg.cup_arena_req()
  msg._set_match_lineup = ed.upmsg.cup_arena_set_lineup()
  msg._set_match_lineup._lineups = {}
  for i, heroArr in ipairs(teamDatas) do
    local idArr = {}
    local hiddenArr = {}
    for _, heroItem in ipairs(heroArr) do
      table.insert(idArr, heroItem.id)
      table.insert(hiddenArr, heroItem.isHidden and 1 or 0)
    end
    local lineup = ed.commonmsg.cup_arena_lineup()
    lineup._hero_ids = idArr
    lineup._hidden = hiddenArr
    msg._set_match_lineup._lineups[i] = lineup
  end
  ed.send(msg, "cup_arena")
  self:logPrint(msg)
end

function CupArenaNetwork:sendOpenGamble()
  if ed.CupArenaManager:getGambleRedFlag() then
    ed.CupArenaManager:setGambleRedFlag(false)
  end
  local msg = ed.upmsg.cup_arena_req()
  msg._open_bet = ed.upmsg.cup_arena_open_bet()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendMatchGamble(matchId, isHost, amount)
  local msg = ed.upmsg.cup_arena_req()
  msg._bet_match = ed.upmsg.cup_arena_bet_match()
  msg._bet_match._match_id = matchId
  msg._bet_match._pick_host = isHost and 1 or 0
  msg._bet_match._counter = amount
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendGambleRecord()
  local msg = ed.upmsg.cup_arena_req()
  msg._bet_record = ed.upmsg.cup_arena_bet_record()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendMedalReward(rewardId)
  local msg = ed.upmsg.cup_arena_req()
  msg._medal_reward = ed.upmsg.cup_arena_medal_reward()
  msg._medal_reward._reward_id = rewardId
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendHistory()
  local msg = ed.upmsg.cup_arena_req()
  msg._history = ed.upmsg.cup_arena_history()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendTopRankboard(season, zoneId)
  local msg = ed.upmsg.cup_arena_req()
  msg._top_rankboard = ed.upmsg.cup_arena_top_rankboard()
  msg._top_rankboard._season = season
  msg._top_rankboard._zone_id = zoneId
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendUserRankboard(campId)
  local msg = ed.upmsg.cup_arena_req()
  msg._user_rankboard = ed.upmsg.cup_arena_user_rankboard()
  msg._user_rankboard._camp_id = campId
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendMatchRankboard()
  local msg = ed.upmsg.cup_arena_req()
  msg._match_rankboard = ed.upmsg.cup_arena_match_rankboard()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendCampRankboard()
  local msg = ed.upmsg.cup_arena_req()
  msg._camp_rankboard = ed.upmsg.cup_arena_camp_rankboard()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendTimeline(scheduleIds)
  local scheduleTable = ed.getDataTable("CupArenaSchedule")
  local idArr = {}
  for i = 1, 9999 do
    local tableItem = scheduleTable[i]
    if nil == tableItem then
      break
    end
    if tableItem["Show To Player"] then
      table.insert(idArr, tableItem["Schedule ID"])
    end
  end
  local msg = ed.upmsg.cup_arena_req()
  msg._time_schedule = ed.upmsg.cup_arena_time_schedule()
  msg._time_schedule._schedule_ids = idArr
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendOpenReward()
  local msg = ed.upmsg.cup_arena_req()
  msg._open_reward = ed.upmsg.cup_arena_open_reward()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendOpenAudition()
  local msg = ed.upmsg.cup_arena_req()
  msg._open_audition = ed.upmsg.cup_arena_audition()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendOpenTask(isOpen)
  ed.CupArenaManager:setOpenTaskView(isOpen)
  local msg = ed.upmsg.cup_arena_req()
  msg._open_task = ed.upmsg.cup_arena_open_task()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
  if ed.CupArenaManager:getTaskRedFlag() then
    ed.CupArenaManager:setTaskRedFlag(false)
  end
end

function CupArenaNetwork:sendOpenAuditionSummary()
  local msg = ed.upmsg.cup_arena_req()
  msg._audition_achievement = ed.upmsg.cup_arena_audition_achievement()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

function CupArenaNetwork:sendClickPaint()
  local msg = ed.upmsg.cup_arena_req()
  msg._cup_arena_paint_trigger = ed.upmsg.cup_arena_paint_trigger()
  self:logPrint(msg)
  ed.send(msg, "cup_arena")
end

ed.CupArenaNetwork = CupArenaNetwork.create()
