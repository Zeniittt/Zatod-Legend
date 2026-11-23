local class = {}
class.__index = class
class.KnockState = {Prepare = "Prepare", Out = "Out"}
class.TeamCount = {Audition = 5, Knockout = 7}

function class.getInstance(...)
  local object = {}
  setmetatable(object, class)
  object:initData()
  object:registerEvents()
  return object
end

function class:isDebug()
  return false
end

function class:initData()
  self.isOpen = true
  self.isSkipBattle = nil
  self.season = 0
  self.rank = 0
  self.totalRank = 0
  self.medal = 0
  self.totalMedal = 0
  self.score = 0
  self.challengeCount = 0
  self.challengeCD = 0
  self.changeLineupCD = 0
  self.buyCount = 0
  self.campRank = 0
  self.scoreMax = 0
  self.medalRewardFlags = {}
  self.gambleRedFlag = false
  self.entryRedFlag = false
  self.challengeRecordRedFlag = false
  self.taskRedFlag = false
  self.firstChallengeRedFlag = false
  self.medalRewardRedFlag = false
  self.taskDeadline = 0
  self.campId = 0
  self.scheduleId = 0
  self.eventScrope = {}
end

function class:getZoneId()
  return self.zoneId
end

function class:setZoneId(zoneId)
  self.zoneId = zoneId or 0
end

function class:getCampId()
  return self.campId
end

function class:setCampId(campId)
  self.campId = campId or 1
end

function class:getScheduleId()
  return self.scheduleId
end

function class:setScheduleId(scheduleId)
  self.scheduleId = scheduleId or 1
end

function class:getEndTime()
  return self.endTime
end

function class:setEndTime(endTime)
  self.endTime = endTime or 1
end

function class:setTaskDeadline(deadline)
  self.taskDeadline = deadline
end

function class:getTaskDeadline()
  return self.taskDeadline
end

function class:checkTaskDeadline()
  return ed.getServerTime() < self.taskDeadline
end

function class:getRank(...)
  return self.rank
end

function class:setRank(rank)
  self.rank = rank or 0
end

function class:getTotalRank(...)
  return self.totalRank
end

function class:setTotalRank(totalRank)
  self.totalRank = totalRank or 0
end

function class:getTotalMedal(...)
  return self.totalMedal
end

function class:setTotalMedal(medal)
  self.totalMedal = medal or 0
end

function class:getCampRank(...)
  return self.campRank
end

function class:setCampRank(rank)
  self.campRank = rank or 0
end

function class:getMedal(...)
  return self.medal
end

function class:setMedal(medal)
  self.medal = medal or 0
end

function class:getScore(...)
  return self.score
end

function class:setScore(score)
  self.score = score or 0
end

function class:getChallengeCount(...)
  return self.challengeCount
end

function class:setChallengeCount(count)
  self.challengeCount = count or 0
end

function class:setChallengeCD(cd)
  self.challengeCD = cd or 0
  if self.challengeCD > 0 then
    self.challengeCD = self.challengeCD + 10
  end
end

function class:getChallengeCD(...)
  return self.challengeCD
end

function class:setChangeLineupCD(cd)
  self.changeLineupCD = cd or 0
  if self.changeLineupCD > 0 then
    self.changeLineupCD = self.changeLineupCD + 300
  end
end

function class:getChangeLineupCD(...)
  return self.changeLineupCD
end

function class:getIsCanEntry(...)
  return self.isCanEntry
end

function class:getCupArenaConfig(key)
  if nil == self.cupArenaConfigTab then
    self.cupArenaConfigTab = {}
  end
  local value = self.cupArenaConfigTab[key]
  if nil == value then
    local tableItem = ed.getDataTable("CupArenaConfig")[key]
    if nil ~= tableItem then
      value = tableItem.Value
      if 1 == #value then
        value = value[1]
      end
      self.cupArenaConfigTab[key] = value
    end
  end
  return value
end

function class:getMaxRefreshTimes()
  return self:getCupArenaConfig("Max Refresh Time")
end

function class:getLeftRefreshTimes()
  return self.leftRefreshTimes or 0
end

function class:setLeftRefreshTimes(times)
  self.leftRefreshTimes = ed.clamp(times, 0, self:getMaxRefreshTimes())
end

function class:getLastRefreshRecoverTime()
  return self.lastRefreshRecoverTime or ed.getServerTime()
end

function class:setLastRefreshRecoverTime(time)
  self.lastRefreshRecoverTime = time
end

function class:getPerRefreshRecoverTime()
  return self:getCupArenaConfig("Refresh Interval") * 60
end

function class:setChallengeCountBuyCount(count)
  self.buyCount = count or 0
end

function class:getChallengeCountBuyCount(...)
  return self.buyCount
end

function class:setScoreMax(scoreMax)
  self.scoreMax = scoreMax or 0
end

function class:getScoreMax()
  return self.scoreMax
end

function class:setGambleRedFlag(flag)
  self.gambleRedFlag = flag
  FireEvent("EventCupArenaGambleEntryRed")
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CUPARENA)
end

function class:getGambleRedFlag()
  return self.gambleRedFlag
end

function class:setEntryRedFlag(flag)
  self.entryRedFlag = flag
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CUPARENA)
end

function class:getEntryRedFlag()
  return self.entryRedFlag
end

function class:setChallengeRecordRedFlag(flag)
  self.challengeRecordRedFlag = flag
  FireEvent("EventCupArenaChalleneRecordRed")
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CUPARENA)
end

function class:getChallengeRecordRedFlag()
  return self.challengeRecordRedFlag
end

function class:setTaskRedFlag(flag)
  self.taskRedFlag = flag
  FireEvent("EventCupArenaTaskEntryRed")
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CUPARENA)
end

function class:getTaskRedFlag()
  return self.taskRedFlag
end

function class:setFirstChallengeRedFlag(flag)
  self.firstChallengeRedFlag = flag
  FireEvent("EventCupArenaFirstChallengeRed")
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CUPARENA)
end

function class:getFirstChallengeRedFlag()
  return self.firstChallengeRedFlag
end

function class:setMedalRewardRedFlag(flag)
  self.medalRewardRedFlag = flag
  FireEvent("EventCupArenaMedalRewardRed")
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CUPARENA)
end

function class:getMedalRewardRedFlag()
  return self.medalRewardRedFlag
end

function class:setCurrentSeason(season)
  self.season = season
end

function class:getCurrentSeason(...)
  return self.season
end

function class:setSkipBattle(flag)
  self.isSkipBattle = flag
  ed.storage.setValue("CUPARENA_SKIP_BATTLE", self.isSkipBattle)
end

function class:getSkipBattle()
  if nil == self.isSkipBattle then
    self.isSkipBattle = ed.storage.getBool("CUPARENA_SKIP_BATTLE")
  end
  return self.isSkipBattle
end

function class:registerEvents()
  self:closeEvents()
  ListenEvent("EventCupArenaMedalReward", function(data)
    local rewardId = data._reward_id
    local rewards = data._rewards
    table.insert(self.medalRewardFlags, rewardId)
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(rewards)
  end, self.eventScrope)
  ListenEvent("NetworkError", function(reply)
    self:handleErrorCode(reply)
  end, self.eventScrope)
end

function class:closeEvents()
  CloseScope(self.eventScrope)
end

function class:createRewardIcon(reward, iconWidth)
  local type = reward.type
  local showAmount = true
  if type == "Item" then
    local icon
    if showAmount then
      icon = ed.readequip.createIconWithAmount(reward.id, iconWidth, reward.amount)
    else
      icon = ed.readequip.createIcon(reward.id, iconWidth)
    end
    return icon
  elseif type == "Diamond" then
    local icon = ed.createSprite("UI/alpha/HVGA/newshop/newshop_recharge_diamond_04.png")
    icon:setScale(iconWidth / icon:getContentSize().height * 1.5)
    local amountText = reward.amount > 1 and tostring(reward.amount) or ""
    if showAmount then
      local amountLabel = ed.getNumberNode({
        text = amountText,
        folder = "prop_amount",
        padding = -1,
        scale = 0.9
      })
      local alNode = amountLabel.node
      alNode:setAnchorPoint(ccp(1, 0.5))
      alNode:setPosition(ccp(100, 32))
      icon:addChild(alNode)
    end
    return icon
  elseif type == "Medal" then
    local res = ed.lookupDataTable("Medal", "Picture", tonumber(reward.id))
    local icon = ed.createSprite(res)
    icon:setScale(iconWidth / icon:getContentSize().height)
    return icon
  end
end

function class:readRewards(v)
  local list = {}
  for i = 1, 5 do
    local type = v["Reward Type " .. i]
    local id = v["Reward ID " .. i]
    local amount = v["Reward Amount " .. i]
    if type then
      table.insert(list, {
        type = type,
        id = id,
        amount = amount
      })
    end
  end
  return list
end

function class:getGradeInfoList(season)
  if nil == season then
    season = 1
  end
  if nil == self.gradeInfoTab then
    self.gradeInfoTab = {}
  end
  if nil == self.gradeInfoTab[season] then
    local list = {}
    self.gradeInfoTab[season] = list
    local dataTable = ed.getDataTable("CupArenaGrade")
    local seasonTable = dataTable[1]
    if nil ~= seasonTable then
      for i = 1, 999 do
        local tableItem = seasonTable[i]
        if nil == tableItem then
          break
        end
        local item = {
          id = tableItem.Grade,
          startScore = tableItem["Start Score"],
          name = tableItem["Grade Name"],
          iconRes = string.format("UI/alpha/1080P/cuparena/%s.png", tableItem["Grade Icon"]),
          nameIconRes = string.format("UI/alpha/1080P/cuparena/%s_name.png", tableItem["Grade Icon"]),
          rewards = self:readRewards(tableItem)
        }
        table.insert(list, item)
      end
    end
    table.sort(list, function(v1, v2)
      return v1.id < v2.id
    end)
    local nextLvStartScore
    for i = #list, 1, -1 do
      local v = list[i]
      v.endScore = nextLvStartScore and nextLvStartScore - 1 or nil
      nextLvStartScore = v.startScore
    end
  end
  return self.gradeInfoTab[season]
end

function class:getGradeInfoByGradeId(gradeId, season)
  if nil == season then
    season = self:getCurrentSeason() or 1
  end
  local list = self:getGradeInfoList(season)
  for k, v in ipairs(list) do
    if gradeId == v.id then
      return v
    end
  end
  return nil
end

function class:getGradeInfoByScore(score, season)
  if nil == season then
    season = self:getCurrentSeason() or 1
  end
  local list = self:getGradeInfoList(season)
  for i = #list, 1, -1 do
    local v = list[i]
    if score >= v.startScore then
      return v
    end
  end
  return list[1]
end

function class:getCampInfoList()
  local list = {}
  local dataTable = ed.getDataTable("CupArenaCamp")
  for k, v in pairs(dataTable) do
    if type(v) == "table" then
      local item = {
        id = v["Camp ID"],
        name = v["Camp Name"],
        heroId = v["Camp Hero ID"],
        description = v["Camp Describe"],
        iconRes = string.format("UI/alpha/HVGA/cuparena/%s.png", v["Camp Symbol"])
      }
      item.nameIconRes = string.format("UI/alpha/HVGA/cuparena/cuparena hall/cuparena_camp_name_%d.png", item.id)
      item.fullName = item.name .. "\233\152\181\232\144\165"
      table.insert(list, item)
    end
  end
  table.sort(list, function(v1, v2)
    return v1.id < v2.id
  end)
  return list
end

function class:setMedalRewardFlags(flags)
  self.medalRewardFlags = flags or {}
end

function class:hasMedalRewardBeenTaken(rewardId)
  return ed.isElementInTable(rewardId, self.medalRewardFlags)
end

function class:handleSeasonHistoryData(data)
  local records = data._records or {}
  if #records == 0 then
    ed.showToast("\230\178\161\230\156\137\229\142\134\229\143\178\232\181\155\229\173\163\231\154\132\232\174\176\229\189\149")
  else
    ed.CupArenaSeasonHistoryWin.create(data)
  end
end

function class:handleTimelineReply(data)
  local timestamps = data._timestamps or {}
  if 0 < #timestamps then
    ed.ui.CupArenaTimelineWin.create(data)
  end
end

function class:handleRewardData(data)
  self:setCampRank(data._camp_rank)
  self:setScoreMax(data._score_max)
  self:setMedal(data._medal)
  self:setMedalRewardFlags(data._medal_reward_flags)
  FireEvent("EventHandleRewardData")
end

function class:handleOpenGamblePanel(data)
  local options = data._options or {}
  if 0 == #options and 5 == self:getScheduleId() then
    ed.showToast(T("\231\171\158\231\140\156\229\176\154\230\156\170\229\188\128\229\144\175"))
    return
  end
  ed.pushScene(ed.ui.CupArenaGambleScene.create(data))
end

function class:handleGambleReply(data)
  ed.player:addMoney(-(data._counter or 0))
  FireEvent("EventCupArenaGambleUpdate", data)
end

function class:setOpenTaskView(flag)
  self.isOpenBattleRecordView = flag
end

function class:handleOpenTask(data)
  self:setMedal(data._medal_amount)
  self:setTotalMedal(data._camp_medal)
  self:setTaskDeadline(data._end_time)
  if false then
    ed.showToast(T("\230\181\183\233\128\137\231\187\147\230\157\159\239\188\140\228\187\187\229\138\161\229\183\178\232\191\135\230\156\159"))
  elseif self.isOpenBattleRecordView then
    ed.ui.CupArenaTaskWin.create(data)
  else
    FireEvent("EventCupArenaFreshTask", data)
  end
end

function class:handleAuditionSummary(data)
  ed.ui.CupArenaAuditionSummaryWin.create(data)
end

function class:getPaintTriggerRewardTimes()
  return self:getCupArenaConfig("Point Art Times")
end

function class:getPaintTriggerTimes()
  return self.paintTriggerTimes or 0
end

function class:handlePaintTrigger(data)
  self.paintTriggerTimes = data._acc_times
  if nil ~= data._rewards then
    ed.player:addRewards(data._rewards)
    ed.UITool.showRewardsFromServer(data._rewards)
  end
end

function class:getChallengeCountBuyCost(times)
  local costArr = self:getCupArenaConfig("Challenge Buy Price")
  local index = times + 1
  if index > #costArr then
    return costArr[#costArr]
  else
    return costArr[index]
  end
end

function class:getMaxChallengeCount()
  return self:getCupArenaConfig("Initial Challenge Time")
end

function class:getAddChallengeCountByBuy()
  return self:getCupArenaConfig("Challenge Buy Add")
end

function class:handleKnockout(data, matchType)
  self:setZoneId(data._zone_id)
  self:setScheduleId(data._schedule_id)
  self:setEndTime(data._end_time)
  self:setCampId(data._camp_id)
  if self.isOpenPanel then
    self.isOpenPanel = false
    ed.pushScene(ed.ui.CupArenaKnockoutChallengeScene.create({data = data, matchType = matchType}))
  else
    FireEvent("EventCupArenaRefreshKnockoutChallenge", {data = data, matchType = matchType})
  end
end

function class:handleBaseInfo(data)
  self.isCanEntry = data._can_entry == 1
  self:setEntryRedFlag(data._refresh_challenge == 1)
  self:setChallengeRecordRedFlag(data._challenge_record == 1)
  self:setGambleRedFlag(data._bet_batch == 1)
  self:setTaskRedFlag(data._task == 1)
  self:setFirstChallengeRedFlag(data._first_challenge == 1)
  self:setMedalRewardRedFlag(data._medal_reward == 1)
end

function class:handleGetDefensiveLineup(data)
  FireEvent("EventCupArenaGetDefensiveLineup", data._lineups)
end

function class:handleSetDefensiveLineup(data, isKnockout)
  if not isKnockout then
    self:setChangeLineupCD(ed.getServerTime())
  end
  FireEvent("EventCupArenaSetDefensiveLineup", data)
end

function class:handleErrorCode(data)
  if data._info == "cup_arena_season_not_started" or data._info == T("\229\165\179\231\165\158\228\185\139\230\136\152\232\181\155\229\173\163\229\176\154\230\156\170\229\188\128\229\144\175") then
    FireEvent("EventCupArenaOver")
  elseif data._info == "cup_arena_oppo_args_error" or data._info == T("\229\183\178\230\140\145\230\136\152\232\191\135\232\175\165\229\175\185\230\137\139") then
    ListenTimer(Timer:Once(0.3), function(...)
      ed.showToast(T("\229\183\178\230\140\145\230\136\152\232\191\135\232\175\165\229\175\185\230\137\139"))
    end)
    FireEvent("EventCupChallengeFail")
  end
end

function class:handleNotEntry(data)
  ed.ui.CupArenaChooseCampWin.create():popWindow()
  FireEvent("EventCupArenaNotEntry", data)
end

function class:handleEntry(data)
  self:setLastGradeId(1)
  self:setIsFirstOpenKnockout(true)
  FireEvent("EventCupArenaEntry", data)
end

function class:handleAudition(data)
  self:setZoneId(data._zone_id)
  self:setScore(data._score)
  self:setMedal(data._medal)
  self:setCampRank(data._camp_rank)
  self:setTotalMedal(data._camp_medal)
  self:setRank(data._rank)
  self:setTotalRank(data._zone_score_rank)
  self:setMedalRewardFlags(data._medal_reward_flags)
  self:setCampId(data._camp_id)
  self:setScheduleId(data._schedule_id)
  self:setEndTime(data._end_time)
  self:setChangeLineupCD(data._change_lineup_time)
  if self.isOpenPanel then
    self.isOpenPanel = false
    ed.pushScene(ed.ui.CupArenaMatchPlazaScene.create(data))
  else
    FireEvent("EventCupArenaRefreshPlaza", data)
  end
end

function class:handleOpenChallenge(data)
  self:setChallengeCount(data._challenge_count)
  self:setChallengeCountBuyCount(data._buy_count)
  self:setChallengeCD(data._last_time)
  self:setLeftRefreshTimes(data._cur_refresh_times)
  self:setLastRefreshRecoverTime(data._refresh_times_update_time)
  FireEvent("EventCupArenaOpenChallenge", data)
end

function class:handleRefreshOppos(data)
  self:setLeftRefreshTimes(data._cur_refresh_times)
  self:setLastRefreshRecoverTime(data._refresh_times_update_time)
  FireEvent("EventCupArenaRefreshOppo", data)
end

function class:handleOppoTeams(data)
  FireEvent("EventCupArenaGetOppoTeams", data)
end

function class:handleChallengeResult(data)
  self:setRank(data._new_rank)
  self:setTotalRank(data._zone_score_rank)
  self:setScore(data._self_new_score)
  self:setCampRank(data._camp_rank)
  self:setTotalMedal(data._camp_medal)
  self:setMedal(self:getMedal() + (data._medal_change or 0))
  self:setChallengeCount(self:getChallengeCount() - 1)
  self:setChallengeCD(ed.getServerTime())
  FireEvent("EventCupArenaChallengeResult", data)
end

function class:setChallengeRoleIdByInfo(roleId)
  self.challengeRoleId = roleId
end

function class:handleViewUser(data)
  ed.ui.CupArenaOppoInfoWin.create(data, self.challengeRoleId)
end

function class:handleTopRankboard(data)
  if nil == data._rank_list or 0 == #data._rank_list then
    ed.showToast("\230\154\130\230\151\160\229\144\141\228\186\186\229\160\130\232\174\176\229\189\149")
    return
  end
  for i, v in ipairs(ed.scene_stack) do
    if v.identity == "CupArenaFamousScene" then
      FireEvent("EventCupArenaRefreshFamous", data)
      return
    end
  end
  ed.pushScene(ed.ui.CupArenaFamousScene.create(data))
end

function class:handleGambleRecord(data)
  ed.ui.CupArenaGambleRecordWin.create(data)
end

function class:setOpenBattleRecordView(flag)
  self.isOpenBattleRecordView = flag
end

function class:handleBattleRecord(data, isKnockout)
  if self.isOpenBattleRecordView then
    self.isOpenBattleRecordView = false
    ed.ui.CupArenaBattleRecordWin.create({
      isKnockout = isKnockout,
      records = data._records
    })
  else
    FireEvent("EventCupArenaBattleRecord", {
      isKnockout = isKnockout,
      records = data._records
    })
  end
end

function class:handleGetReplay(data)
  local replay = data._replay
  if not replay then
    ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\229\189\149\229\131\143"))
    return
  end
  local params = {
    isReplay = true,
    battleReplay = data._replay or {},
    medalChange = nil
  }
  if nil ~= self.replayScoreData then
    params.selfOldScore = self.replayScoreData._self_old_score
    params.selfNewScore = self.replayScoreData._self_new_score
    params.oppoOldScore = self.replayScoreData._oppo_old_score
    params.oppoNewScore = self.replayScoreData._oppo_new_score
    params.isAudition = true
  end
  ed.ui.CupArenaChallengeResultWin.create(params)
end

function class:handleQuerySummary(data)
  ed.ui.BattleStaticsWin.create(data._summary, "cupArena")
end

function class:setOpenMatchFinalScheduleView(flag)
  self.isOpenMatchFinalScheduleView = flag
end

function class:handleMatchFinalSchedule(data)
  self:setZoneId(data._zone_id)
  self:setScheduleId(data._schedule_id)
  self:setEndTime(data._end_time)
  if data._is_auto == 1 then
    if self.isOpenPanel then
      self.isOpenPanel = false
      ed.pushScene(ed.ui.CupArenaKnockoutFinalScheduleScene.create(data))
    else
      FireEvent("EventCupArenaRefreshSchedule", data)
    end
  elseif self.isOpenMatchFinalScheduleView then
    self.isOpenMatchFinalScheduleView = false
    ed.ui.CupArenaKnockoutFinalScheduleWin.create(data)
  else
    FireEvent("EventCupArenaRefreshSchedule", data)
  end
end

function class:setOpenMatchGroupScheduleView(flag)
  self.isOpenMatchGroupScheduleView = flag
end

function class:handleMatchGroupSchedule(data)
  self:setScheduleId(data._schedule_id)
  self:setEndTime(data._end_time)
  if self.isOpenMatchGroupScheduleView then
    self.isOpenMatchGroupScheduleView = false
    ed.ui.CupArenaKnockoutGroupScheduleWin.create(data)
  else
    FireEvent("EventCupArenaRefreshGroupSchedule", data)
  end
end

function class:handleBuyCount(data)
  local result = data._result
  if result == "success" then
    local buyCount = self:getChallengeCountBuyCount()
    local cost = self:getChallengeCountBuyCost(buyCount)
    ed.player._rmb = ed.player._rmb - cost
    self:setChallengeCount(self:getChallengeCount() + self:getAddChallengeCountByBuy())
    self:setChallengeCountBuyCount(buyCount + 1)
  end
  FireEvent("EventCupArenaBuyCount")
end

function class:setOpenPanel(flag)
  self.isOpenPanel = flag
end

function class:setReplayMatchId(matchId)
  self.replayMatchId = matchId
end

function class:getReplayMatchId()
  return self.replayMatchId
end

function class:isUnlock()
  local limitLv = self:getCupArenaConfig("Open Level")
  if limitLv > ed.player:getLevel() then
    return false, T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167\229\188\128\230\148\190", limitLv)
  end
  local heroNum = self:getCupArenaConfig("Hero Require")
  if heroNum > ed.player:getHeroCount() then
    return false, T("\233\156\128\232\135\179\229\176\145\230\139\165\230\156\137%d\229\144\141\232\139\177\233\155\132\230\137\141\229\143\175\229\143\130\228\184\142\229\165\179\231\165\158\228\185\139\230\136\152", heroNum)
  end
  return true
end

function class:isSelfByOppoData(oppoData)
  if nil == oppoData then
    return false
  end
  return oppoData._role_id == ed.getRoleId()
end

local TeamDataKey = {
  "CupArena_1",
  "CupArena_2",
  "CupArena_3",
  "CupArena_4",
  "CupArena_5",
  "CupArena_6",
  "CupArena_7"
}

function class:getLastTeamArr(isKnockout)
  local teamCount = isKnockout and ed.CupArenaManager.TeamCount.Knockout or ed.CupArenaManager.TeamCount.Audition
  local teamArr = {}
  for teamIndex = 1, teamCount do
    local tmpArr = ed.getTeamData(TeamDataKey[teamIndex])
    local idArr = {}
    table.insert(teamArr, idArr)
    for _, id in ipairs(tmpArr or {}) do
      if ed.player:getHero(id) then
        table.insert(idArr, id)
      end
    end
  end
  return teamArr
end

function class:saveNewTeamArr(teamArr)
  for teamIndex, idArr in ipairs(teamArr) do
    ed.setTeamData(TeamDataKey[teamIndex], idArr)
  end
end

function class:getLastAnimationScheduleID(group)
  if nil == self.animationScheduleIDTab then
    self.animationScheduleIDTab = {}
  end
  local id = self.animationScheduleIDTab[group]
  if nil == id then
    local key = ed.getRoleKey("ani_schedule_id_" .. group)
    id = ed.storage.getInt(key) or 0
    self.animationScheduleIDTab[group] = id
  end
  return id
end

function class:saveLastAnimationScheduleID(group, id)
  if nil == self.animationScheduleIDTab then
    self.animationScheduleIDTab = {}
  end
  self.animationScheduleIDTab[group] = id
  local key = ed.getRoleKey("ani_schedule_id_" .. group)
  ed.storage.setValue(key, id)
end

function class:getIsReadGambleAmount()
  if nil == self.isReadGambleAmount then
    local key = ed.getRoleKey("is_read_gamble_amount")
    self.isReadGambleAmount = ed.storage.getBool(key) or false
  end
  return self.isReadGambleAmount
end

function class:setIsReadGambleAmount()
  self.isReadGambleAmount = true
  local key = ed.getRoleKey("is_read_gamble_amount")
  ed.storage.setValue(key, true)
end

function class:getLastGradeId()
  if nil == self.lastGradeId then
    local key = ed.getRoleKey("last_grade_id")
    self.lastGradeId = ed.storage.getInt(key)
    if 0 == self.lastGradeId then
      self.lastGradeId = 1
    end
  end
  return self.lastGradeId
end

function class:setLastGradeId(id)
  self.lastGradeId = id
  local key = ed.getRoleKey("last_grade_id")
  ed.storage.setValue(key, id)
end

function class:getIsFirstOpenKnockout()
  if nil == self.isFirstOpenKnockout then
    local key = ed.getRoleKey("is_first_open_knockout")
    self.isFirstOpenKnockout = ed.storage.getBool(key) or false
  end
  return self.isFirstOpenKnockout
end

function class:setIsFirstOpenKnockout(flag)
  self.isFirstOpenKnockout = flag
  local key = ed.getRoleKey("is_first_open_knockout")
  ed.storage.setValue(key, flag)
end

function class:isHighestGrade(score)
  local list = self:getGradeInfoList(self:getCurrentSeason())
  if 0 < #list and score >= list[#list].startScore then
    return true
  end
  return false
end

function class:checkGradeChangeEffect(callback)
  local gradeTableInfo = self:getGradeInfoByScore(self:getScore())
  local newGradeId = gradeTableInfo.id
  local lastGradeId = self:getLastGradeId()
  if newGradeId ~= lastGradeId then
    self:setLastGradeId(newGradeId)
    if newGradeId > lastGradeId then
      lastGradeId = newGradeId - 1
    else
      lastGradeId = newGradeId + 1
    end
    ed.ui.CupArenaEffectPlayWin.create({
      type = "grade",
      data = {
        oldGrade = lastGradeId,
        newGrade = gradeTableInfo.id
      },
      callback = callback
    })
  elseif nil ~= callback then
    callback()
  end
end

function class:setReplayScoreData(data)
  self.replayScoreData = data
end

local legendArenaStageID = {
  -57,
  -58,
  -59,
  -60,
  -61,
  -62,
  -63,
  -63,
  -63
}

function class:enterReplay(replayData, roundId, isNormalBattle, isAudition)
  local selfHeros = replayData._self_heroes._heroes
  local oppoHeros = replayData._oppo_heroes._heroes
  if not selfHeros then
    ed.showToast(T("\229\183\177\230\150\185\232\139\177\233\155\132\230\149\176\230\141\174\229\188\130\229\184\184"))
    return
  end
  if not oppoHeros then
    ed.showToast(T("\229\175\185\230\150\185\232\139\177\233\155\132\230\149\176\230\141\174\229\188\130\229\184\184"))
    return
  end
  local mode = "cupArena"
  local format_data = ed.copyProto(replayData)
  format_data._self_heroes = selfHeros
  format_data._oppo_heroes = oppoHeros
  local stageid = legendArenaStageID[roundId]
  ed.ui.vcdLayer.setData(format_data, "cupArena", stageid)
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local info = {
    userId = replayData._self_user._uid,
    userName = replayData._self_user._name,
    userAvatar = replayData._self_user._avatar,
    vip = replayData._self_user._vip,
    oppoUserid = replayData._oppo_user._uid,
    oppoUserName = replayData._oppo_user._name,
    oppoUserAvatar = replayData._oppo_user._avatar,
    oppovip = replayData._oppo_user._vip,
    checkid = replayData._checkid
  }
  ed.srand(replayData._rseed)
  if isNormalBattle then
    ed.engine:enterRelay2({
      hero_list = selfHeros,
      enemy_list = oppoHeros,
      battleIdx = roundId,
      battleBOType = isAudition and 5 or 7,
      stage_id = stageid,
      mode = mode,
      selfBonus = replayData._self_bonus or nil,
      oppoBonus = replayData._oppo_bonus or nil
    })
    ed.scene:reset(stage, battle, {
      cupArenaInfo = {}
    })
    ed.pushScene(ed.scene)
  else
    ed.engine:enterRelay({
      hero_list = selfHeros,
      enemy_list = oppoHeros,
      battleBOType = isAudition and 5 or 7,
      stage_id = stageid,
      mode = mode,
      selfBonus = replayData._self_bonus or nil,
      oppoBonus = replayData._oppo_bonus or nil
    })
    ed.scene:reset(stage, battle, {replayInfo = info})
    ed.pushScene(ed.scene)
  end
end

ed.CupArenaManager = class.getInstance()
