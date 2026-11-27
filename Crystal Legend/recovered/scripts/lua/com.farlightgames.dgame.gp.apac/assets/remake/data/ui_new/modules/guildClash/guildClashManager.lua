local GuildClashManager = {}
GuildClashManager.__index = GuildClashManager
local stateCN = {
  closed = T("\230\156\170\229\188\128\229\144\175"),
  preview = T("\233\162\132\229\145\138\233\152\182\230\174\181"),
  grading = T("\229\174\154\231\186\167\228\184\173"),
  grade_show = T("\229\174\154\231\186\167\231\187\147\230\158\156\229\177\149\231\164\186"),
  match_prepare = T("\232\181\155\229\137\141\229\135\134\229\164\135\233\152\182\230\174\181"),
  rune_refresh = T("\231\165\158\231\172\166\229\136\183\230\150\176"),
  rune_head_modify = T("\231\165\158\231\172\166\228\188\154\233\149\191\232\176\131\230\149\180"),
  rune_gank = T("\231\165\158\231\172\166\230\138\162\229\164\186"),
  rune_disappear = T("\231\165\158\231\172\166\230\182\136\229\164\177(\230\136\144\229\145\152\232\176\131\230\149\180\230\156\159)"),
  head_modify = T("\228\188\154\233\149\191\232\176\131\230\149\180"),
  march = T("\232\161\140\229\134\155\230\156\159"),
  clash_show = T("\230\175\148\232\181\155\232\161\168\230\188\148\228\184\173"),
  clash_end = T("\230\175\148\232\181\155\231\187\147\230\157\159")
}
local GRADE_ID_TO_ICON = {
  [1] = "UI/alpha/1080P/guild/guild_grading/silver_icon.png",
  [2] = "UI/alpha/1080P/guild/guild_grading/silver_icon.png",
  [3] = "UI/alpha/1080P/guild/guild_grading/gold_icon.png",
  [4] = "UI/alpha/1080P/guild/guild_grading/king_icon.png"
}
GuildClashManager.GRADE_ID_TO_ICON = GRADE_ID_TO_ICON
local TOP = 1
local MID = 2
local BOTTOM = 3

function GuildClashManager:initData()
  self.seasonId = 0
  self.state = "closed"
  self.stateEndTime = 0
  self.stateStartTime = 0
  self.userSummayMap = {}
  self.replayList = {}
  self.eventMap = {}
  self.maxEventTime = 0
  self.clashShowEnd = 0
  self.teamList = {}
  ed.UITool.registViewOpenFunc("GuildClashMainScene", function()
    local ds = ed.playerlimit.getAreaUnlockPrompt("GuildClash")
    if ds then
      ed.showToast(ds)
      return
    else
      ReloadModule("ui_new/modules/guildClash/guildClashModuleList")
      ed.GuildClashNetwork:sendOpenPanel()
    end
  end)
end

function GuildClashManager:getStateCN(state)
  return stateCN[state] or T("\233\148\153\232\175\175\231\138\182\230\128\129")
end

function GuildClashManager:isOffSeason()
  return self.isDuringSeason ~= 1
end

function GuildClashManager:getSeasonId()
  return self.seasonId or 0
end

function GuildClashManager:setSeasonId(value)
  self.seasonId = value or 0
end

function GuildClashManager:getCurState()
  return self.state or "closed"
end

function GuildClashManager:setCurState(value)
  self.state = value or "closed"
end

function GuildClashManager:getStateEndTime()
  return self.stateEndTime
end

function GuildClashManager:setStateEndTime(value)
  self.stateEndTime = value
end

function GuildClashManager:getStateStartTime()
  return self.stateStartTime
end

function GuildClashManager:setStateStartTime(value)
  self.stateStartTime = value
end

function GuildClashManager:getRoundId()
  return self.roundId or 1
end

function GuildClashManager:setRoundId(value)
  self.roundId = value or 1
end

function GuildClashManager:getRoundId()
  return self.roundId or 1
end

function GuildClashManager:setRoundId(value)
  self.roundId = value or 1
end

function GuildClashManager:getRuneIds()
  return self.runeIds or {}
end

function GuildClashManager:setRuneIds(value)
  self.runeIds = value or {}
end

function GuildClashManager:setRateInfo(rateInfo)
  self.rateInfo = rateInfo or {}
end

function GuildClashManager:getRateInfo()
  return self.rateInfo or {}
end

function GuildClashManager:getSecondBetweenTwoState(schId1, schId2)
  local tb = ed.getDataTable("GuildClashSchedule")
  local endTime = ed.dateStringToTime(tb[schId2]["Start Time"])
  local second = endTime - ed.getFitServerTime()
  return second
end

function GuildClashManager:getScheduleId()
  return self.scheduleId
end

function GuildClashManager:getTimeToNextState()
  local tb = ed.getDataTable("GuildClashSchedule")
  local curStateID = tb[self.scheduleId]["State ID"]
  for k, v in ipairs(ed.getDataTable("GuildClashSchedule")) do
    if curStateID < v["State ID"] then
      local time = self:getSecondBetweenTwoState(self.scheduleId, k)
      return ed.time2dhms(time)
    end
  end
  return T("\229\183\178\231\187\147\230\157\159")
end

function GuildClashManager:getTimeToChairSetting()
  local keySchedule = {}
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    if v["State Type"] == "HeadModifyDefender" then
      table.insert(keySchedule, k)
    end
  end
  table.sort(keySchedule, function(a, b)
    return a < b
  end)
  for k, v in ipairs(keySchedule) do
    if v > self.scheduleId then
      local time = self:getSecondBetweenTwoState(self.scheduleId, v)
      return ed.time2dhms(time)
    end
  end
  return ""
end

function GuildClashManager:getNextPrepareBegin()
  local guildClashSchedule = {}
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    table.insert(guildClashSchedule, v)
  end
  table.sort(guildClashSchedule, function(a, b)
    return a["Schedule ID"] < b["Schedule ID"]
  end)
  for k, v in ipairs(guildClashSchedule) do
    if v["State Type"] == "PrepareBegin" and v["Schedule ID"] > self.scheduleId then
      return ed.time2dhms(ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()), ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()
    elseif v["State Type"] == "ClashEnd" and ed.dateStringToTime(v["Start Time"]) > ed.getServerTime() then
      return ed.time2dhms(ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()), ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()
    elseif v["State Type"] == "SeasonEnd" then
      return ed.time2dhms(ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()), ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()
    end
  end
  return 0, 0
end

function GuildClashManager:getSeasonEnd()
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    if v["State Type"] == "SeasonEnd" then
      return ed.time2dhms(ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()), ed.dateStringToServerTime(v["Start Time"])
    end
  end
  return 0, 0
end

function GuildClashManager:getGuildGradeIconRes(gradeId)
  return GuildClashManager.GRADE_ID_TO_ICON[gradeId]
end

function GuildClashManager:handleNotify(data)
  local oldIsOffState = self:isOffSeason()
  self:setSeasonId(data._season_id)
  self:setCurState(data._cur_state)
  self.scheduleId = data._schedule_id or 1
  local roundId = data._round_id or 1
  local hasOppo = data._has_oppo or 0
  self.isDuringSeason = data._is_during_season
  if self:isOffSeason() and ed.getCurrentScene().identity == "GuildClashMainScene" then
    ed.popScene()
    self.mainScene = nil
    ListenTimer(Timer:Once(0), function()
      ed.showToast(T("\230\156\172\232\189\174\229\133\172\228\188\154\230\136\152\229\183\178\231\187\147\230\157\159"))
    end)
  end
  local redPointMgr = ed.redPointMgr.getInstance()
  local stateType = ed.getDataTable("GuildClashSchedule")[self.scheduleId]["State Type"]
  local key1 = ed.getRoleKey("GuildClashEnter" .. self.seasonId)
  if stateType == "GradingBegin" and not ed.storage.getBool(key1) then
    redPointMgr:setNodeValue("guild_clash_grading_begin", true)
  end
  local key2 = ed.getRoleKey("GuildClashSetTeam" .. self.seasonId .. roundId)
  local stateType = ed.getDataTable("GuildClashSchedule")[self.scheduleId]["State Type"]
  if stateType == "PrepareBegin" and hasOppo == 1 and not ed.storage.getBool(key2) then
    redPointMgr:setNodeValue("guild_clash_set_team", true)
  else
    redPointMgr:setNodeValue("guild_clash_set_team", false)
  end
  redPointMgr:registerValueChange("guild_clash_enter", self, {
    handle = function(value)
      FireEvent("RefreshRightTopButtons")
    end,
    {notImmediately = true}
  })
  local newIsOffState = self:isOffSeason()
  if oldIsOffState ~= newIsOffState then
    FireEvent("RefreshRightTopButtons")
  end
end

function GuildClashManager:handleOpenPanel(data)
  self:setSeasonId(data._season_id)
  if data._season_id == 0 then
    ed.showToast(T("\230\154\130\230\156\170\229\188\128\229\144\175"))
    return
  end
  self:setCurState(data._cur_state)
  self:setStateEndTime(data._state_end_time)
  self:setStateStartTime(data._state_start_time)
  self:setRoundId(data._round_id)
  self:setRuneIds(data._rune_id)
  self:setRateInfo(data._rate_info)
  self.newData = true
  self.scheduleId = data._schedule_id or 0
  self.campId = data._camp_id or 1
  if not data._oppo_guild_summary then
    self.campId = 0
  end
  if self.campId == 1 then
    self.camp1GuildSummary = data._self_guild_summary or {}
    self.camp2GuildSummary = data._oppo_guild_summary or {}
  elseif self.campId == 2 then
    self.camp1GuildSummary = data._oppo_guild_summary or {}
    self.camp2GuildSummary = data._self_guild_summary or {}
  else
    self.camp1GuildSummary = data._self_guild_summary or {}
    self.camp2GuildSummary = nil
  end
  self.selfGuildSummary = data._self_guild_summary or {}
  self.oppoGuildSummary = data._oppo_guild_summary or {}
  self.battleInfos = data._battle_info or {}
  self.notice = data._match_declare
  self.stateType = ed.getDataTable("GuildClashSchedule")[self.scheduleId]["State Type"]
  self.stateName = ed.getDataTable("GuildClashSchedule")[self.scheduleId].Name
  self.totalRound = ed.getDataTable("GuildClashSeason")[data._season_id]["Total Round"]
  if self.scheduleId == 0 then
    ed.showToast(T("\229\133\172\228\188\154\230\136\152\229\176\154\230\156\170\229\188\128\229\144\175"))
  elseif self.stateType == "Preview" then
    ed.UITool.openView("guildClashPreviewScene", {data = data})
  elseif ed.isElementInTable(self.stateType, {
    "GradingBegin",
    "CountGradingResult",
    "DivideZone"
  }) then
    ed.UITool.openView("guildClashGradingScene", {data = data})
  elseif ed.isElementInTable(data._schedule_id, {5, 6}) or 1 >= self.rateInfo._grade and data._schedule_id > 6 then
    ed.UITool.openView("guildClashGradeResultScene", {data = data})
  elseif ed.isElementInTable(self.stateType, {
    "MatchGuilds",
    "PrepareBegin",
    "RuneRefresh",
    "HeadModifyGank",
    "GankBegin",
    "RuneRefresh",
    "RuneDisapper",
    "HeadModifyDefender",
    "MarchBegin",
    "CountClashResult",
    "ClashShow",
    "ClashEnd"
  }) then
    if self.mainScene then
      FireEvent("GuildClashDataRefresh")
      self.mainScene:refreshUI()
    else
      self.mainScene = ed.ui.GuildClashMainScene.create()
      local currentScene = ed.getCurrentScene()
      if currentScene and currentScene.identity == "guildClashGradeResultScene" then
        ed.replaceScene(self.mainScene)
      else
        ed.pushScene(self.mainScene)
      end
      ed.UITool.openView("guildClashBattlePop", {isOpen = true})
    end
  elseif self.stateType == "SeasonEnd" and self.mainScene then
    ed.popScene()
    self.mainScene = nil
    ListenTimer(Timer:Once(0), function()
      ed.showToast(T("\230\156\172\232\189\174\229\133\172\228\188\154\230\136\152\229\183\178\231\187\147\230\157\159"))
    end)
  end
  local key = ed.getRoleKey("GuildClashEnter" .. data._season_id)
  ed.storage.setValue(key, true)
  ed.redPointMgr.getInstance():setNodeValue("guild_clash_grading_begin", false)
end

function GuildClashManager:getTotalGuildTeam(lineId)
  local total = 0
  for i, member in ipairs(self.linesTeamInfo[lineId].guildUserTeamCount) do
    total = total + member._team_count
  end
  return total
end

function GuildClashManager:handleUserTeamInfo(data)
  self.linesTeamInfo = {
    [TOP] = {
      userTeam = {},
      guildUserTeamCount = {}
    },
    [MID] = {
      userTeam = {},
      guildUserTeamCount = {}
    },
    [BOTTOM] = {
      userTeam = {},
      guildUserTeamCount = {}
    }
  }
  local heroids = {}
  for k, v in ipairs(data._user_teams or {}) do
    table.insert(self.linesTeamInfo[v._line_id].userTeam, v)
    for i, h in ipairs(v._heroes or {}) do
      if not ed.isElementInTable(h._hero_id, heroids) then
        table.insert(heroids, h._hero_id)
      end
    end
  end
  self.usedHeroes = heroids
  for k, v in ipairs(data._guild_user_team_counts or {}) do
    table.insert(self.linesTeamInfo[v._line_id].guildUserTeamCount, v)
  end
  FireEvent("GuildClashLineTeamInfo")
end

function GuildClashManager:handleGuildUserTeam(data)
  self.linesTeamList = {
    {},
    {},
    {}
  }
  for k, team in ipairs(data._user_teams or {}) do
    table.insert(self.linesTeamList[team._line_id], team)
  end
  for k, teams in ipairs(self.linesTeamList) do
    table.sort(teams, function(a, b)
      local gsA = 0
      local gsB = 0
      for k, v in ipairs(a._heroes or {}) do
        gsA = gsA + v._hero_summary._gs
      end
      for k, v in ipairs(b._heroes or {}) do
        gsB = gsB + v._hero_summary._gs
      end
      return gsA > gsB
    end)
  end
  self.operateTime = data._start_operate_time
  self.operateUser = data._start_operate_user_summary
  FireEvent("GuildClashChairSetting")
end

function GuildClashManager:handleAddTeam(data)
  if data._team_id then
    FireEvent("GuildClashAddTeamSuccess", data._team_id)
  end
end

function GuildClashManager:getUserSummary(userid, side)
  if not userid then
    return
  end
  side = side or 1
  local ret = self.userSummayMap[tostring(userid) .. "-" .. tostring(side)]
  ret = ret or {
    _avatar = 1,
    _name = T("\230\156\170\229\145\189\229\144\141\231\142\169\229\174\182"),
    _vip = 1,
    _level = 1,
    _guild_name = "guildname"
  }
  return ret
end

function GuildClashManager:handleSummaryInfo(data)
  local selfUserSummary = data._self_guild_clash_summary
  for k, v in ipairs(selfUserSummary or {}) do
    if self.campId == 1 then
      self.userSummayMap[tostring(v._id) .. "-1"] = v._user_summary
    else
      self.userSummayMap[tostring(v._id) .. "-2"] = v._user_summary
    end
  end
  local oppoUserSummary = data._oppo_guild_clash_summary
  for k, v in pairs(oppoUserSummary or {}) do
    if self.campId == 1 then
      self.userSummayMap[tostring(v._id) .. "-2"] = v._user_summary
    else
      self.userSummayMap[tostring(v._id) .. "-1"] = v._user_summary
    end
  end
end

function GuildClashManager:getBattleLineInfo(lineId)
  return self.linesBattle[lineId]
end

function GuildClashManager:handleQueryLine(data)
  FireEvent("GuildClashQueryLineBattle", data)
end

function GuildClashManager:handleSyncEvent(data)
  local curTime = ed.getServerTime() - self:getStateStartTime()
  for k, event in ipairs(data._events or {}) do
    if not self.eventMap[event._id] then
      self.maxEventTime = math.max(self.maxEventTime, event._time)
      self.eventMap[event._id] = event
      if event._type == "summary" then
        if curTime <= event._time then
          ListenTimer(Timer:Once(math.max(0, event._time - curTime - 0.2)), function()
            FireEvent("GuildClashBattleEventPop", event)
          end)
        end
      else
        ListenTimer(Timer:Once(math.max(0, event._time - curTime - 0.2)), function()
          print("eventId", event._id, "curTime:", curTime, "FireTime:", event._time)
          FireEvent("GuildClashBattleEventPop", event)
        end)
      end
    end
  end
end

function GuildClashManager:handleQueryReplay(data)
  self.replayList[data._checkid] = data
  FireEvent("GuildClashQueryReplay")
end

function GuildClashManager:handleQueryBattleSummary(data)
  self.battleSummary = data
  FireEvent("GuildClashBattleSummary", data)
end

function GuildClashManager:handleQueryRank(data)
  FireEvent("guildClashRankBreak", data)
end

function GuildClashManager:handleQueryRuneSummary(data)
end

function GuildClashManager:handleQueryBattleTeams(data)
  self.teamList[data._line_id] = data
  FireEvent("GuildClashBattleTeams", data)
end

function GuildClashManager:handleQueryGuildLiveness(data)
  FireEvent("GuildLiveness", data)
end

function GuildClashManager:handleQueryHistory(data)
  FireEvent("GuildClashHistory", data)
end

function GuildClashManager:handleQueryGoods(queryGoods)
  local shopTable = ed.getDataTable("GuildClashShop")
  self.shopList = {}
  local sellShort = {}
  for t, v in ipairs(queryGoods._goods or {}) do
    local groups = shopTable[v._group_id] or {}
    local shopData = groups[v._index]
    local amount = 999
    if v._max_buy_times and v._cur_buy_times then
      amount = v._max_buy_times - v._cur_buy_times
    end
    local items = {
      item = {
        id = shopData["Goods ID"],
        count = shopData["Goods Amount"],
        type = shopData["Goods Type"]
      },
      order = shopData["Order Number"],
      price = shopData["Goods Price"],
      priceType = "guildClashPoint",
      amountNew = v._cur_buy_times or 0,
      amountMax = v._max_buy_times or 1,
      index = v._index,
      zhe = shopData["Show Discount"],
      groupId = v._group_id
    }
    if amount <= 0 then
      table.insert(sellShort, items)
    else
      table.insert(self.shopList, items)
    end
  end
  table.sort(self.shopList, function(a, b)
    return a.order < b.order
  end)
  table.sort(sellShort, function(a, b)
    return a.order < b.order
  end)
  for _, v in ipairs(sellShort) do
    table.insert(self.shopList, v)
  end
  ed.UITool.openView("guildClashShopScene")
end

function GuildClashManager:handleBuyGoods(buyGoods)
  ed.player:addRewards(buyGoods._rewards or {})
  for _, v in ipairs(self.shopList) do
    if v.groupId == buyGoods._group_id and v.index == buyGoods._goods_index then
      v.amountNew = buyGoods._cur_buy_times
    end
  end
  ed.player:setEquipAmount(ed.GuildClashManager:getSeasonShopCoinID(), buyGoods._left_coin)
  FireEvent("guildClashShopItemUpdate")
  FireEvent("ResourceNumChange", "guildClashPoint")
end

function GuildClashManager:handleLastSummary(lastSummarys)
  FireEvent("GuildClashQueryLastSummary", lastSummarys)
end

function GuildClashManager:getSeasonShopCoinID()
  return ed.getDataTable("GuildClashSeason")[self.seasonId]["Shop Coin ID"]
end

function GuildClashManager.enterReplay(replayData, notSkipBattle)
  local camp1Heros = replayData._camp1_heroes
  local camp2Heros = replayData._camp2_heroes
  if not camp1Heros then
    ed.showToast(T("\229\183\177\230\150\185\232\139\177\233\155\132\230\149\176\230\141\174\229\188\130\229\184\184"))
    return
  end
  if not camp2Heros then
    ed.showToast(T("\229\175\185\230\150\185\232\139\177\233\155\132\230\149\176\230\141\174\229\188\130\229\184\184"))
    return
  end
  local mode = "guildClash"
  local format_data = ed.copyProto(replayData)
  format_data._self_heroes = camp1Heros
  format_data._oppo_heroes = camp2Heros
  format_data._username = replayData._camp1_summary._name
  format_data._oppo_name = replayData._camp2_summary._name
  format_data._avatar = replayData._camp1_summary._avatar
  format_data._oppo_avatar = replayData._camp2_summary._avatar
  format_data._level = replayData._camp1_summary._level
  format_data._oppo_level = replayData._camp2_summary._level
  format_data._result = replayData._win_team == 1 and "victory" or "defeat"
  format_data._self_medal = replayData._camp1_summary._medal
  format_data._oppo_medal = replayData._camp2_summary._medal
  format_data._winTimes = {
    camp1WinTimes = replayData._camp1_win_times,
    camp2WinTimes = replayData._camp2_win_times
  }
  local stageid = -32
  ed.ui.vcdLayer.setData(format_data, mode, stageid)
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local info = {
    userId = replayData._camp1_summary._uid,
    userName = replayData._camp1_summary._name,
    userAvatar = replayData._camp1_summary._avatar,
    vip = replayData._camp1_summary._vip,
    oppoUserid = replayData._camp2_summary._uid,
    oppoUserName = replayData._camp2_summary._name,
    oppoUserAvatar = replayData._camp2_summary._avatar,
    oppovip = replayData._camp2_summary._vip,
    checkid = replayData._checkid,
    userMedal = replayData._camp1_summary._medal,
    oppoMedal = replayData._camp2_summary._medal,
    notShow = notSkipBattle
  }
  ed.srand(replayData._rseed)
  local data = {
    hero_list = camp1Heros,
    enemy_list = camp2Heros,
    stage_id = stageid,
    mode = mode,
    selfBonus = replayData._camp1_bonus or nil,
    oppoBonus = replayData._camp2_bonus or nil,
    self_dyna_list = replayData._camp1_hero_dynas,
    enemy_dyna_list = replayData._camp2_hero_dynas,
    winTimes = {
      camp1WinTimes = replayData._camp1_win_times,
      camp2WinTimes = replayData._camp2_win_times
    }
  }
  ed.engine:enterRelay(data)
  ed.scene:reset(stage, battle, {replayInfo = info})
  ed.pushScene(ed.scene)
end

function GuildClashManager.create()
  local self = {}
  setmetatable(self, GuildClashManager)
  self:initData()
  return self
end

function GuildClashManager.getInstance()
  if not GuildClashManager.instance then
    GuildClashManager.instance = GuildClashManager.create()
  end
  return GuildClashManager.instance
end

ed.GuildClashManager = GuildClashManager.getInstance()
