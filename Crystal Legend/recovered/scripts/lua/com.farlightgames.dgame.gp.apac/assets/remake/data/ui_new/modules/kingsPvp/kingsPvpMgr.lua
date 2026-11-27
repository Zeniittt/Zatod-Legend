module("ed.realarena", package.seeall)
stage_id = {
  -39,
  -49,
  -50,
  -39,
  -49
}
local ed = ed
rule_map = {
  "bo3",
  "bo1",
  "bo5"
}
role_map = {
  [1] = "host",
  [0] = "slave"
}
match_type = {
  "athletics",
  "casual",
  "playoff",
  "direct",
  "point"
}
oppo_info_show_time = 2
RealArenaMgrScope = {}
RealArenaMgrGlobeScope = {}
RealArenaMgr = {}
RealArenaMgr.__index = RealArenaMgr

function ed.showKingsPvpInvite(teamId)
  if ed.getCurrentScene().identity ~= "KingsPvpMainScene" then
    ed.UITool.openView("KingsPvpMainScene")
    ed.TeamNetwork.sendTeamApply("team_real_arena", teamId)
  else
    ed.TeamNetwork.sendTeamApply("team_real_arena", teamId)
  end
end

function RealArenaMgr.Create()
  local real_arena_mgr = {}
  setmetatable(real_arena_mgr, RealArenaMgr)
  real_arena_mgr.what = "RealArenaMgr"
  local seq_mgr = Sequence.SequenceMgr.Current()
  if seq_mgr == nil then
    seq_mgr = Sequence.SequenceMgr.Create()
    Sequence.SequenceMgr.SetCurrent(seq_mgr)
  end
  real_arena_mgr.sequence = Sequence.Sequence.Create(tostring(real_arena_mgr), seq_mgr)
  real_arena_mgr:initRealArenaRed()
  real_arena_mgr:RegisterGlobeEvent()
  real_arena_mgr:RegisterEvents()
  return real_arena_mgr
end

function RealArenaMgr:Destroy()
  self:UnregisterEvents()
  self:UnregisterGlobeEvent()
  self.sequence:Reset()
  self.sequence = nil
  self.season_info = nil
end

function RealArenaMgr:handleNotify(notify)
  local hasGradeReward = notify._has_grade_reward
  local seasonId = notify._season_id or 0
  local legendEquipOpen = notify._legend_equip_open
  self.seasonId = seasonId
  self.hasGradeReward = hasGradeReward == 1
  self:updateRewardRedPoint()
  ed.redPointMgr.getInstance():setNodeValue("kings_pvp_legend_equip_open", legendEquipOpen)
end

function RealArenaMgr:initRealArenaRed()
  local redPointMgr = ed.redPointMgr.getInstance()
  redPointMgr:registerValueChange("tavern_entry", self, {
    handle = function(value)
      local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
      FireEvent("MainBuildRedTagChange", BuilddingType.Tavern)
    end
  })
end

function RealArenaMgr:updateRewardRedPoint()
  local redPointMgr = ed.redPointMgr.getInstance()
  if self.hasGradeReward then
    self.hasGradeReward = false
    redPointMgr:setNodeValue("kings_pvp_grade_reward", 1)
  else
    local hasRed = false
    local maxScore = self:GetMaxScore()
    local maxGrade = self:GetGradeByScore(maxScore)
    for rewardGrade, rewardCfg in pairs(ed.getDataTable("KingsGradeReward")[self.seasonId] or {}) do
      local gradeRewardFlag = self:gerGradeRewardFlag({gradeId = rewardGrade})
      if not gradeRewardFlag and rewardGrade <= maxGrade then
        hasRed = true
        break
      end
    end
    redPointMgr:setNodeValue("kings_pvp_grade_reward", hasRed)
  end
end

function RealArenaMgr:RegisterGlobeEvent()
  ListenEvent("RealArenaChallenging", function(valid_time)
    self:ShowChallengingWindow(valid_time)
  end, RealArenaMgrGlobeScope)
  ListenEvent("RealArenaChallengeCancelled", function()
    self:CloseChallengingWindow()
  end, RealArenaMgrGlobeScope)
  ListenEvent("RealArenaChallengeNotify", function(proto_data)
    self:ChallengeNotify(proto_data)
  end, RealArenaMgrGlobeScope)
  ListenEvent("RealArenaChallengeAccepted", function()
    self:ChallengeAccept()
  end, RealArenaMgrGlobeScope)
  ListenEvent("RealArenaChallengeRefused", function()
    self:ChallengeRefuse()
  end, RealArenaMgrGlobeScope)
  ListenEvent("RealArenaNotify", function(notify)
    self:handleNotify(notify)
  end, RealArenaMgrGlobeScope)
  FireEvent("registerPlayoffsManager")
end

function RealArenaMgr:UnregisterGlobeEvent()
  CloseScope(RealArenaMgrGlobeScope)
end

function RealArenaMgr:RegisterEvents()
  ListenEvent("RealPVPEnterRoomReply", function(data)
    self:EnterRoomReply(data)
  end, RealArenaMgrScope)
  ListenEvent("RealPVPHeroSelectBegin", function(data)
    EDLog("mgr hero select begin:" .. self.match_rule)
    ed.ui.realArena.hideOppoInfo()
    local scene = ed.getCurrentScene()
    if scene.identity == "battle" then
      ed.popScene()
    end
    if self.match_rule == rule_map[1] then
      self:EnterHeroSelectAlternation(data)
    elseif self.match_rule == rule_map[2] then
      self:EnterHeroSelectAlone(data)
    elseif self.match_rule == rule_map[3] then
      self:EnterHeroSelectAlternation(data)
    end
  end, RealArenaMgrScope)
  ListenEvent("RealPVPBattleStartCountdown", function(data)
    self:BattleStartCountdown(data)
  end, RealArenaMgrScope)
  ListenEvent("RealPVPStart", function(data)
    self:EnterBattle(data)
  end, RealArenaMgrScope)
  ListenEvent("RealPVPRoundReset", function()
    self:RoundReset()
  end, RealArenaMgrScope)
  ListenEvent("RealPVPBattleEnd", function(result, reason, my_hero_dynas, oppo_hero_dynas)
    self:BattleEnd(result, reason, my_hero_dynas, oppo_hero_dynas)
  end, RealArenaMgrScope)
  ListenEvent("RealPVPBattleRoundEndReply", function(data)
    self:RoundEndRelpy(data)
  end, RealArenaMgrScope)
  ListenEvent("RealArenaAchievementUpdate", function(data)
    self:SetAchievement(data)
    FireEvent("RealArenaShowAchievement")
  end, RealArenaMgrScope)
  ListenEvent("RealArenaBattleResult", function(result_data)
    self:BattleResultEnd(result_data)
  end, RealArenaMgrScope)
  ListenEvent("RealArenaRecordInfo", function(data)
    self:SetRecordInfo(data)
    FireEvent("RealArenaShowRecord")
  end, RealArenaMgrScope)
  ListenEvent("RealArenaReplayInfo", function(data)
    self:SetReplyInfo(data)
    FireEvent("RealArenaShowReplay")
  end, RealArenaMgrScope)
  ListenEvent("RealArenaHeroInfo", function(hero_infos)
    hero_mgr:UpdateData(hero_infos)
  end, RealArenaMgrScope)
  ListenEvent("RealPVPOpponentLost", function()
    ListenTimer(Timer:Once(2), function()
      if ed.getCurrentScene().identity == "battle" then
        ed.popScene()
        self:showBattleResultWindow()
      end
    end, RealArenaMgrScope)
  end, RealArenaMgrScope)
  ListenEvent("RealArenaNetworkException", function()
    self:NetworkException()
  end, RealArenaMgrScope)
  ListenEvent("RealPVPChatReply", function(chatReply)
    self:dealRealPvpChatReply(chatReply)
  end, RealArenaMgrScope)
  ListenEvent("RealPvpBan", function(pvp_ban)
    self:dealRealPvpBanReply(pvp_ban)
  end, RealArenaMgrScope)
  ListenEvent("RealPvpPick", function(pvp_pick)
    self:dealRealPvpPickReply(pvp_pick)
  end, RealArenaMgrScope)
  ListenEvent("RealArenaGradeReward", function(_grade_rewards)
    self:dealRealPvpGradeReward(_grade_rewards)
  end, RealArenaMgrScope)
end

function RealArenaMgr:NetworkException()
  self:LeaveMatching()
end

function RealArenaMgr:UnregisterEvents()
  CloseScope(RealArenaMgrScope)
end

function RealArenaMgr:Init(data)
  self:SetSeasonInfo(data._season_info)
  self:SetRankInfo(data._my_rank_info)
  self:SetMaxScore(data._max_score)
  self:SetGradeRewardFlags(data._grade_reward_flags)
  self:SetBlockTime(data._block_time)
end

function RealArenaMgr:SetSeasonInfo(season_info)
  self.season_info = season_info
  self.seasonId = self.season_info._index or 0
end

function RealArenaMgr:GetSeasonInfo()
  return self.season_info
end

function RealArenaMgr:getSeasonId()
  return self.seasonId
end

function RealArenaMgr:SetPlayoffsSeasonInfo(info)
  self.playoffsInfo = info
end

function RealArenaMgr:GetPlayoffsSeasonInfo()
  return self.playoffsInfo
end

function RealArenaMgr:isOpenPlayoff()
  if self.playoffsInfo then
    local status = self.playoffsInfo._status
    if status ~= "idle" and status ~= "season_end" then
      return true
    end
  end
  return false
end

function RealArenaMgr:SetRankInfo(info)
  self.rank_info = info
  self.maxScore = math.max(self.rank_info._score, self.maxScore or 0)
  self:updateRewardRedPoint()
end

function RealArenaMgr:GetRankInfo()
  return self.rank_info or {}
end

function RealArenaMgr:GetMyGrade()
  local score = self:GetRankScore()
  return self:GetGradeByScore(score)
end

function RealArenaMgr:GetGradeByScore(score)
  local finalGrade = 0
  for grade, gradeCfg in ipairs(ed.getDataTable("KingsGrade")) do
    if score >= gradeCfg.Score then
      finalGrade = grade
    end
  end
  return finalGrade
end

function RealArenaMgr:GetRankScore()
  if self.rank_info == nil then
    return 0
  end
  return self.rank_info._score or 0
end

function RealArenaMgr:SetGradeRewardFlags(_grade_reward_flags)
  self.gradeRewardFlags = _grade_reward_flags or {}
  self:updateRewardRedPoint()
end

function RealArenaMgr:SetBlockTime(_block_time)
  self.blockTime = _block_time
end

function RealArenaMgr:GetBlockTime()
  return self.blockTime or 0
end

function RealArenaMgr:SetMaxScore(maxScore)
  self.maxScore = maxScore
end

function RealArenaMgr:GetMaxScore()
  return self.maxScore or 0
end

function RealArenaMgr:gerGradeRewardFlag(param)
  local gradeId = param.gradeId
  local gradeName = param.gradeName
  if gradeId then
    gradeName = ed.getDataTable("KingsGrade")[gradeId]["Grade Name"]
  end
  for index, gradeNameFlag in ipairs(self.gradeRewardFlags or {}) do
    if gradeName == gradeNameFlag then
      return true
    end
  end
  return false
end

function RealArenaMgr:getGradeCfgByGradeName(gradeName)
  if not self.gradeNameToGradeCfg then
    self.gradeNameToGradeCfg = {}
    for gradeId, gradeCfg in ipairs(ed.getDataTable("KingsGrade")) do
      self.gradeNameToGradeCfg[gradeCfg["Grade Name"]] = gradeCfg
    end
  end
  return self.gradeNameToGradeCfg[gradeName]
end

function RealArenaMgr:getGradeIconPath(param)
  local gradeId = param.gradeId
  local gradeName = param.gradeName
  local score = param.score
  local gradeCfg
  if score then
    gradeId = self:GetGradeByScore(score)
  end
  if gradeId then
    gradeCfg = ed.getDataTable("KingsGrade")[gradeId]
  elseif gradeName then
    gradeCfg = self:getGradeCfgByGradeName(gradeName)
  end
  if gradeCfg then
    return gradeCfg.Icon
  else
    return "UI/alpha/1080P/newkingspvp/rank/rank_1.png"
  end
end

function RealArenaMgr:getGradeSmallIconPath(param)
  local gradeId = param.gradeId
  local gradeName = param.gradeName
  local score = param.score
  local gradeCfg
  if score then
    gradeId = self:GetGradeByScore(score)
  end
  if gradeId then
    gradeCfg = ed.getDataTable("KingsGrade")[gradeId]
  elseif gradeName then
    gradeCfg = self:getGradeCfgByGradeName(gradeName)
  end
  if gradeCfg then
    return gradeCfg["Icon Small"]
  else
    return "UI/alpha/1080P/newkingspvp/rank/rank_1_s.png"
  end
end

function RealArenaMgr:GetBattleScoreInfo()
  return self.battleScoreInfo
end

function RealArenaMgr:ResetBattleScoreInfo()
  self.battleScoreInfo = nil
end

function RealArenaMgr:StartMatch(type, rule)
  self.match_type = type or match_type[1]
  self.match_rule = rule or rule_map[1]
  self.match_in_procedure = true
end

function RealArenaMgr:CancelMatch()
  self.match_in_procedure = false
end

function RealArenaMgr:LeaveMatching()
  self.match_in_procedure = false
end

function RealArenaMgr:IsMatching()
  return self.match_in_procedure
end

function RealArenaMgr:SetAchievement(data)
  if self.achievement == nil then
    self.achievement = Achievement.Create(data)
  else
    self.achievement:Init(data)
  end
end

function RealArenaMgr:SetRecordInfo(data)
  self.record_info = data or {}
end

function RealArenaMgr:SetReplyInfo(data)
  local replays, rule, result_final, summarys = data._record, data._rule, data._result, data._summary
  self.replay_info = {}
  self.replay_info.replays = replays or {}
  self.replay_info.summarys = summarys or {}
  self.replay_info.selfBan = data._self_ban or {}
  self.replay_info.oppoBan = data._oppo_ban or {}
  self.replay_info.isHost = data._host_role_id == ed.getRoleId()
  self.replay_info.isAudience = data._is_audience == 1
  if rule == "bo1" then
    self.replay_info.total_count = 1
  elseif rule == "bo3" then
    local replay_count = #replays
    if replay_count == 2 then
      local result_1 = replays[1]._result
      local result_2 = replays[2]._result
      if result_1 == result_2 then
        self.replay_info.total_count = 2
      else
        self.replay_info.total_count = 3
      end
    elseif replay_count == 1 then
      local result_1 = replays[1]._result
      local left_user_id = tostring(replays[1]._userid)
      local left_user_name = tostring(replays[1]._username)
      local is_left
      if tostring(ed.getUserid()) .. tostring(ed.player:getName()) == left_user_id .. left_user_name then
        is_left = true
      else
        is_left = false
      end
      if is_left then
        if result_1 == result_final then
          self.replay_info.total_count = 2
        else
          self.replay_info.total_count = 3
        end
      elseif result_1 ~= result_final then
        self.replay_info.total_count = 2
      else
        self.replay_info.total_count = 3
      end
    else
      self.replay_info.total_count = 3
    end
  elseif rule == "bo5" then
    local replay_count = #replays
    self.replay_info.total_count = replay_count
  end
  self.replay_info.result = result_final
end

function RealArenaMgr:EnterRoomReply(data)
  if data._result == "success" then
    ed.udp_port_server = data._udp_port
    ed.socket_udp:SetPort(ed.udp_port_server)
    self:InitBattle(data)
    EnqueueDelayProcess(function()
      ListenTimer(Timer:Once(oppo_info_show_time), function()
        FireEvent("PVPSelectReady")
      end)
    end)
  else
    FireEvent("RealArenaMatchingCancelled")
    ed.showToast(T("\232\191\155\229\133\165\232\175\184\231\142\139\228\186\137\233\156\184\229\175\185\230\136\152\230\136\191\233\151\180\229\164\177\232\180\165\239\188\140\232\175\183\231\168\141\229\144\142\229\134\141\232\175\149"))
  end
end

function RealArenaMgr:InitBattle(data)
  if self.match_rule == nil then
    EDLog("ERROR:RealArenaMgr init battle fail! Match rule is nil!")
    return
  end
  local hostInfo = data._host_info
  local guestInfo = data._guest_info
  local role = role_map[data._is_host] or role_map[0]
  local opponent
  if data._is_host == 1 then
    opponent = {
      id = guestInfo._id,
      summary = guestInfo._summary
    }
  else
    opponent = {
      id = hostInfo._id,
      summary = hostInfo._summary
    }
  end
  self.battle = ed.localbattle.Battle.create(role, self.match_rule, opponent)
  self.battle.player_summary = {}
  self.roundBattleData = {}
  self.isHost = data._is_host == 1
  self.hostServerName = hostInfo._server_name
  self.hostUserSummary = hostInfo._summary
  self.guestServerName = guestInfo._server_name
  self.guestUserSummary = guestInfo._summary
  hero_mgr:setHostHeroes(hostInfo._heroes)
  hero_mgr:setGuestHeroes(guestInfo._heroes)
  self:closeChildBeforeInBattle()
end

function RealArenaMgr:closeChildBeforeInBattle()
  ed.ui.realArena:closeBattleWindow()
end

function RealArenaMgr:Countdown(time_countdown, call_back)
  local countdown_start = math.ceil(time_countdown)
  if 5 < countdown_start then
    countdown_start = 5
  end
  self.sequence:Reset()
  for i = countdown_start, 1, -1 do
    self.sequence:AddClip("BattleCountdown", i)
  end
  self.sequence:Play(call_back)
end

function RealArenaMgr:setPlayoffsInfo(param)
  local hero_all_list = hero_mgr:getAllHeroList()
  local awake_hero_list = {}
  local super_awake_hero_list = {}
  for k, hero in pairs(hero_all_list) do
    if hero._arousal._status == 1 then
      awake_hero_list[hero._tid] = true
    end
    if hero._hero_rune._status == 1 then
      super_awake_hero_list[hero._tid] = true
    end
  end
  param.hero_all_list = hero_all_list
  param.awakelist = awake_hero_list
  param.superAwakeList = super_awake_hero_list
  param.promotelist = nil
  param.employlist = nil
end

function RealArenaMgr:EnterHeroSelectAlternation(data)
  local param = {
    pvpMode = "realarena",
    turn = data._turn,
    isHost = data._is_host,
    select_time = data._select_time,
    select_count_limit = data._select_count,
    operateType = data._operate_type,
    backupTime = data._backup_time,
    usedHeroes = data._used_heroes,
    hostWinCnt = data._host_win_cnt,
    guestWinCnt = data._guest_win_cnt
  }
  ed.UITool.openView("KingsPvpBanPickScene", param)
end

function RealArenaMgr:BattleStartCountdown(data)
  local function battle_scene_init_handler()
    ed.playEffect(ed.sound.real_arena.enter_battle)
    
    ed.srand(data._rseed)
    if not self.battle then
      return
    end
    local my_role = self.battle.role
    local teams = self.battle.teams
    local is_host = my_role == "host"
    local isAudience = self.hostUserSummary._role_id ~= ed.getRoleId() and self.guestUserSummary._role_id ~= ed.getRoleId()
    local bonusInfo = {
      selfBonus = data._host_bonus,
      oppoBonus = data._slave_bonus
    }
    ed.engine:enterWCA(teams.host:GetHeroes(), teams.slave:GetHeroes(), is_host, bonusInfo)
    local stage = ed.lookupDataTable("Stage", nil, ed.realarena.stage_id[self.battle.round])
    local battle = ed.lookupDataTable("Battle", nil, ed.realarena.stage_id[self.battle.round], 1)
    ed.scene:reset(stage, battle, {
      pvpInfo = {
        pvpMode = "realarena",
        player_summary = self.battle.player_summary
      },
      obMode = isAudience
    })
    ed.scene.scene:retain()
  end
  
  local scene = ed.getCurrentScene()
  if scene.identity == "KingsPvpBanPickScene" then
    ed.popScene()
  end
  self:SetupBattle(data)
  local my_role = self.role and self.role or ed.realarena.mgr.battle.role
  local opponent_role = ed.localbattle.role_opposite[my_role]
  self.roundId = data._round
  local teams = self.battle.teams
  ed.UITool.openView("KingsLoadingWindow", {
    hostServerName = self.hostServerName,
    guestServerName = self.guestServerName,
    hostUserSummary = self.hostUserSummary,
    guestUserSummary = self.guestUserSummary,
    hostHeroList = teams.host:GetHeroes(),
    guestHeroList = teams.slave:GetHeroes(),
    loadHeroFinishCallBack = function()
      FireEvent("PVPRoundInitOver")
    end
  })
  battle_scene_init_handler()
end

function RealArenaMgr:SetupBattle(data)
  self.battle.round = data._round
  local my_heroes = {}
  local opponent_heroes = {}
  local my_role = self.battle.role
  local opponent_role = ed.localbattle.role_opposite[my_role]
  local teams = self.battle.teams
  local my_heroes_proto = data["_heroes_" .. my_role]
  if #teams[my_role]:GetHeroes() == 0 then
    for _, hero_proto_data in ipairs(my_heroes_proto) do
      local hero = ed.HeroCreate()
      hero:setup(hero_proto_data)
      table.insert(my_heroes, hero)
    end
    teams[my_role]:SetHeroes(my_heroes)
  end
  local opponent_heroes_proto = data["_heroes_" .. opponent_role]
  if #teams[opponent_role]:GetHeroes() == 0 then
    for _, hero_proto_data in ipairs(opponent_heroes_proto) do
      local hero = ed.HeroCreate()
      hero:setup(hero_proto_data)
      table.insert(opponent_heroes, hero)
    end
    teams[opponent_role]:SetHeroes(opponent_heroes)
  end
end

function RealArenaMgr:EnterBattle(data)
  ListenTimer(Timer:Once(0.1), function(...)
    ed.ui.realArena.needCloseTimer = false
    ed.replaceScene(ed.scene)
    ed.scene.scene:release()
  end)
end

function RealArenaMgr:BattleEnd(result, reason, my_hero_dynas, oppo_hero_dynas)
  ed.ui.realArena.needCloseTimer = true
  local round = 1
  if self.battle then
    round = self.battle.round
  end
  FireEvent("PVPSendRoundEnd", round, result, my_hero_dynas, oppo_hero_dynas)
  self.battle_result_reason = reason
end

function RealArenaMgr:RoundEndRelpy(data)
  if ed.socket_udp then
    ed.socket_udp:ResetResendQueue()
  end
  local result = data._result
  local isAudience = self.hostUserSummary._role_id ~= ed.getRoleId() and self.guestUserSummary._role_id ~= ed.getRoleId()
  local ct_result
  if isAudience then
    ct_result = result
  else
    ct_result = ed.engine.btResult2String()
  end
  if result ~= ct_result then
    ed.reportCtrBattleLog()
  end
  local heroData = {}
  for index, unit in ipairs(ed.engine.unit_list) do
    table.insert(heroData, {
      _tid = unit.tid,
      _level = unit.level,
      _stars = unit.stars,
      _rank = unit.rank,
      _fashion_id = unit.fashion_id,
      _camp = unit.camp,
      _shard_id = unit.proto._shard and unit.proto._shard._id or nil,
      _hp = unit.hp,
      _astrolabe = unit.proto._astrolabe,
      _damage = unit.battledata:getDamage(),
      _suffer_damage = unit.battledata:getBearDamage(),
      _healing = unit.battledata:getTakeHeal(),
      _kill = unit.battledata:getKillNum(),
      _legend_equip = unit.proto._legend_equip
    })
  end
  local teams = self.battle.teams
  self.roundBattleData[self.battle.round] = {
    round = self.battle.round,
    is_host = self.battle.role == "host",
    victory = data._result == "victory",
    hostHero = teams.host:GetHeroes(),
    guestHero = teams.slave:GetHeroes(),
    heroData = heroData
  }
  ListenTimer(Timer:Once(2), function()
    self:showBattleResultWindow(data._next_round)
  end, RealArenaMgrScope)
  self.battle.next_round = data._next_round
  self.battle.round_win_times = data._win_times
  self.battle.is_win = data._is_final_winner == 1
end

function RealArenaMgr:showBattleResultWindow(next_round)
  ed.UITool.openView("KingsBattleResultWindow", {
    is_host = self.isHost,
    hostUserSummary = self.hostUserSummary,
    guestUserSummary = self.guestUserSummary,
    roundBattleData = self.roundBattleData,
    isObMode = isAudience,
    realArenaData = {
      next_round = next_round or 0
    }
  })
end

function RealArenaMgr:RoundReset()
  self:ProcessRoundResult()
end

function RealArenaMgr:ProcessRoundResult()
  if self.battle.next_round == 0 then
    FireEvent("RealArenaCloseConnection")
    local scene = ed.getCurrentScene()
    if scene.identity == "battle" then
      ed.popScene()
    end
    ed.player:increaseDailyjobCount({
      type = "EnterKingsPVP",
      add = 1
    })
    if self.match_type == match_type[2] or self.match_type == match_type[4] then
      FireEvent("RealArenaBattleEnd", self.battle.is_win)
    elseif self.match_type == match_type[3] then
      FireEvent("enterNextRound")
    elseif self.match_type == match_type[5] then
      EnqueueDelayProcess(function()
        self:ShowPointEffect()
      end)
    else
      EnqueueDelayProcess(function()
        self:ShowRankEffect()
      end)
    end
    if ed.current_battle then
      ed.current_battle:destroy()
      ed.current_battle = nil
      self.battle = nil
    end
  else
    self.battle:RoundReset()
    FireEvent("PVPSelectReady")
  end
end

function RealArenaMgr:EnterHeroSelectAlone(data)
  local param = {
    pvpMode = "realarena",
    turn = data._turn,
    isHost = data._is_host,
    select_time = data._select_time,
    select_count_limit = data._select_count,
    operateType = data._operate_type,
    backupTime = data._backup_time,
    usedHeroes = data._used_heroes,
    hostWinCnt = data._host_win_cnt,
    guestWinCnt = data._guest_win_cnt
  }
  ed.UITool.openView("KingsPvpBanPickScene", param)
end

function RealArenaMgr:BattleResultEnd(result_data)
  self.new_result_flag = true
  self.battle_result = result_data._result
  self:SetRankInfo(result_data._rank_after)
  if self.match_type == match_type[1] then
    self.winning_streak = result_data._winning_streak or 0
  end
  self.result_reason = result_data._reason or "normal"
  if self.result_reason == "opponent_off_line" then
    self:OpponentOffLine()
  elseif self.result_reason == "opponent_quit" then
    self:OpponentQuit()
  elseif self.result_reason == "opponent_cheat" then
    self:OpponentOffLine(true)
  end
  self.battleScoreInfo = {
    selfScoreBefore = result_data._rank_before and result_data._rank_before._score or 0,
    selfScoreAfter = result_data._rank_after and result_data._rank_after._score or 0,
    oppoScoreBefore = result_data._oppo_score_before or 0,
    oppoScoreAfter = result_data._oppo_score_after or 0
  }
  FireEvent("RealArenaRefreshPanel", {
    selfScoreBefore = result_data._rank_before,
    selfScoreAfter = result_data._rank_after
  })
end

function RealArenaMgr:HasNewResult()
  return self.new_result_flag
end

function RealArenaMgr:ShowRankEffect()
  if self.new_result_flag then
    self.new_result_flag = false
  else
    return
  end
  self.result_reason = nil
end

function RealArenaMgr:ShowPointEffect()
  if self.new_result_flag then
    self.new_result_flag = false
  else
    return
  end
  if self.point_effect then
    self.point_effect:Destroy()
  end
  self.point_effect = PointEffect.Create(self.rank_info, self.battle_result)
  self.point_effect:Play()
  self.result_reason = nil
end

function RealArenaMgr:ShowAlertDialog(msg, handler)
  local info = {
    text = msg,
    buttonText = T("\231\161\174\229\174\154"),
    handler = handler
  }
  ed.showAlertDialog(info)
end

function RealArenaMgr:OpponentOffLine(cheat_flag)
  EDLog("OpponentOffLine")
  FireEvent("RealArenaCloseConnection")
  local scene = ed.getCurrentScene()
  if scene.identity == "KingsPvpBanPickScene" then
    ed.popScene()
  elseif scene.identity == "KingsLoadingWindow" then
    ed.popScene()
  elseif scene.identity == "stageFailed" or scene.identity == "stagedone" then
    ed.popScene()
  elseif scene.identity == "battle" then
    ed.popScene()
  elseif scene.identity == "realarena" then
  end
  EnqueueDelayProcess(function()
    ed.ui.realArena.HideAllLayers()
    if self.battle_result == "victory" then
      ListenTimer(Timer:Once(0.01), function()
        ed.engine:saveBattleLog()
        if cheat_flag then
          ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\230\150\173\229\188\128\232\191\158\230\142\165\239\188\140\228\189\160\232\142\183\229\190\151\228\186\134\232\131\156\229\136\169\239\188\129"))
        else
          ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\230\142\137\231\186\191\239\188\140\228\189\160\232\142\183\229\190\151\228\186\134\232\131\156\229\136\169\239\188\129"))
        end
        self:showBattleResultWindow()
      end, RealArenaMgrScope)
    end
    if self.match_type == match_type[1] then
      self:ShowRankEffect()
    elseif self.match_type == match_type[5] then
      self:ShowPointEffect()
    else
      FireEvent("RealArenaBattleEnd", self.battle_result == "victory")
      self.battle_result = nil
    end
    self:ResetBattleScoreInfo()
    if ed.current_battle then
      ed.current_battle:destroy()
      ed.current_battle = nil
      self.battle = nil
    end
  end)
end

function RealArenaMgr:OpponentQuit()
  EDLog("OpponentQuit")
  FireEvent("RealArenaCloseConnection")
  local scene = ed.getCurrentScene()
  if scene.identity == "KingsPvpBanPickScene" or scene.identity == "stageFailed" or scene.identity == "stagedone" or scene.identity == "battle" then
    ed.popScene()
  end
  EnqueueDelayProcess(function()
    ed.ui.realArena.HideAllLayers()
    if self.battle_result == "victory" then
      ListenTimer(Timer:Once(0.01), function()
        ed.engine:saveBattleLog()
        ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\233\128\128\229\135\186\230\175\148\232\181\155\239\188\140\228\189\160\232\142\183\229\190\151\228\186\134\232\131\156\229\136\169\239\188\129"))
        ed.loadEnd()
        self:showBattleResultWindow()
      end, RealArenaMgrScope)
    end
    if self.match_type == match_type[1] or self.match_type == match_type[3] then
      self:ShowRankEffect()
    elseif self.match_type == match_type[5] then
      self:ShowPointEffect()
    else
      FireEvent("RealArenaBattleEnd", self.battle_result == "victory")
      self.battle_result = nil
    end
    self:ResetBattleScoreInfo()
    if ed.current_battle then
      ed.current_battle:destroy()
      ed.current_battle = nil
      self.battle = nil
    end
  end)
end

function RealArenaMgr:OpponentLost()
  EDLog("OpponentLost")
  if self.result_reason then
    self:OpponentOffLine()
  else
    FireEvent("RealArenaCloseConnection")
    local scene = ed.getCurrentScene()
    if scene.identity == "KingsPvpBanPickScene" or scene.identity == "stageFailed" or scene.identity == "stagedone" or scene.identity == "battle" then
      ed.popScene()
    end
  end
end

function RealArenaMgr:ShowChallengingWindow(valid_time)
  local scene = ed.getCurrentScene()
  local challenge_wait_win = ed.realarena.ChallengeWaitWindow.Create(scene, challenge_type, battle_rule, valid_time)
  scene.scene:addChild(challenge_wait_win.mainLayer, 500)
end

function RealArenaMgr:CloseChallengingWindow()
  local scene = ed.getCurrentScene()
  if scene.challenge_wait_window then
    scene.challenge_wait_window:Destroy()
    ed.showToast(T("\230\140\145\230\136\152\233\130\128\232\175\183\229\183\178\231\187\143\229\143\150\230\182\136"))
  elseif scene.challenge_notify_window then
    scene.challenge_notify_window:Destroy({skipAnim = true})
    ed.showToast(T("\229\175\185\230\137\139\230\148\190\229\188\131\228\186\134\230\140\145\230\136\152"))
  end
end

function RealArenaMgr:createNormalChallengeNotifyWindow(param)
  local scene = ed.getCurrentScene()
  local challenge_notify_win = ed.realarena.ChallengeNotifyWindow.Create(scene, param)
  scene.scene:addChild(challenge_notify_win.mainLayer, 500)
  ListenTimer(Timer:Once(param.valid_time or 60), function()
    if scene.challenge_notify_window then
      scene.challenge_notify_window:Destroy()
      ed.showToast(T("\232\191\153\230\172\161\230\140\145\230\136\152\229\183\178\231\187\143\232\191\135\230\156\159"))
    end
  end, RealArenaMgrGlobeScope)
end

function RealArenaMgr:ChallengeNotify(proto_data)
  local scene = ed.getCurrentScene()
  local type = proto_data._type
  local param = {
    type = type,
    pvp_rule = proto_data._pvp_rule,
    id = proto_data._challenger._id,
    name = proto_data._challenger._summary._name,
    server_id = proto_data._challenger._server_id,
    server_name = proto_data._challenger._server_name,
    valid_time = proto_data._valid_time
  }
  if scene.identity == "main" or scene.identity == "realarena" then
    if scene.challenge_notify_window then
      scene.challenge_notify_window:Destroy({skipAnim = true})
    end
    self:createNormalChallengeNotifyWindow(param)
  else
    challenge_notify_param = param
    self.timer_notify_param_update = ListenTimer(Timer:Always(1), function()
      if challenge_notify_param then
        challenge_notify_param.valid_time = challenge_notify_param.valid_time - 1
        if challenge_notify_param.valid_time <= 0 then
          challenge_notify_param = nil
          ed.showToast(T("\232\191\153\230\172\161\230\140\145\230\136\152\229\183\178\231\187\143\232\191\135\230\156\159"))
        end
      end
    end, RealArenaMgrGlobeScope)
  end
end

function RealArenaMgr:ChallengeAccept()
  local scene = ed.getCurrentScene()
  if scene.challenge_notify_window then
    scene.challenge_notify_window:Destroy()
  end
  if scene.challenge_wait_window then
    scene.challenge_wait_window:Destroy()
  end
  if scene.guild_challenge_window then
    scene.guild_challenge_window:Destroy()
  end
  self.match_type = match_type[2]
  if scene.identity == "main" or scene.identity == "guild" then
    network_mgr:UnregisterEvents()
    network_mgr:RegisterEvents()
    self:UnregisterEvents()
    self:RegisterEvents()
    network_mgr:RequestOpenPanel()
  elseif scene.identity == "realarena" then
    network_mgr:DoEnterRoom()
  end
end

function RealArenaMgr:ChallengeRefuse()
  self.match_rule = nil
  local scene = ed.getCurrentScene()
  if scene.challenge_notify_window then
    scene.challenge_notify_window:ChangeAppearance()
  end
  if scene.challenge_wait_window then
    scene.challenge_wait_window:Destroy()
    ed.playEffect(ed.sound.deo.common_popup_small)
    ed.showAlertDialog({
      text = T("\229\175\185\230\137\139\230\139\146\231\187\157\228\186\134\228\189\160\231\154\132\230\140\145\230\136\152")
    })
  end
end

function RealArenaMgr:dealRealPvpChatReply(chatReply)
  if chatReply._result == "success" then
    local scene = ed.getCurrentScene()
    if scene and scene.identity == "battle" then
      ed.sceneui:showRealPvpChatContentUI(chatReply)
    else
      FireEvent("RealPVPChatShow", chatReply)
    end
  elseif chatReply._result == "frequency_limit" then
    ed.showToast(T("\232\175\183\228\184\141\232\166\129\233\162\145\231\185\129\229\156\176\229\143\145\233\128\129\229\175\185\232\175\157"))
  end
end

function RealArenaMgr:dealRealPvpBanReply(pvp_ban)
  FireEvent("RealPvpOppoBanHero", pvp_ban._banned_hero_id)
end

function RealArenaMgr:dealRealPvpPickReply(pvp_pick)
  FireEvent("RealPvpOppoPickHero", pvp_pick._picked_hero_id)
end

function RealArenaMgr:dealRealPvpGradeReward(gradeRewards)
  local rewards = gradeRewards._rewards or {}
  local grade = gradeRewards._grade
  if 0 < #rewards then
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(rewards)
    table.insert(self.gradeRewardFlags, grade)
    self:updateRewardRedPoint()
    FireEvent("RealPvpGradeReward")
  end
end

function RealArenaMgr.showReplay(record_data, stageid)
  if not record_data then
    return
  end
  local mode = "real_pvp"
  ed.ui.vcdLayer.setData(record_data, mode, stageid)
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local info = {
    userId = record_data._userid,
    userName = record_data._username,
    userAvatar = record_data._avatar,
    vip = record_data._vip,
    oppoUserid = record_data._oppo_userid,
    oppoUserName = record_data._oppo_name,
    oppoUserAvatar = record_data._oppo_avatar,
    oppovip = record_data._oppo_vip,
    checkid = record_data._checkid
  }
  ed.srand(record_data._rseed)
  ed.engine:enterRelay({
    hero_list = record_data._self_heroes,
    hero_is_bot = 0 < (record_data._self_robot or 0),
    enemy_list = record_data._oppo_heroes,
    enemy_is_bot = 0 < (record_data._oppo_robot or 0),
    stage_id = stageid,
    operations = record_data._operations,
    right_operations = record_data._oppo_operations,
    mode = mode,
    selfBonus = record_data._self_bonus or nil,
    oppoBonus = record_data._oppo_bonus or nil
  })
  ed.scene:reset(stage, battle, {replayInfo = info})
  ed.pushScene(ed.scene)
end

function _G.TestEffect(before, after, winning_streak)
  ed.realarena.mgr.rank_info:Reset({_level_id = before})
  local data = {
    _result = "victory",
    _rank_before = {_level_id = before, _score = 500},
    _rank_after = {_level_id = after, _score = 300},
    _winning_streak = winning_streak or 1,
    _reason = "normal"
  }
  ed.realarena.mgr:BattleResultEnd(data)
  ed.realarena.mgr:ShowPointEffect()
end

function _G.TestCloseConn()
  ed.socket_long_realarena.close()
end

ed.realarena.mgr = ed.realarena.RealArenaMgr.Create()
