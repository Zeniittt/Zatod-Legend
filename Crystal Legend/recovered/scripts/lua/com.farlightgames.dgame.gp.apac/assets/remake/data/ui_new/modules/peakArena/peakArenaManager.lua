local PeakArenaManager = {UNKNOWN_HERO_ID = 0, TEAM_COUNT = 3}
PeakArenaManager.__index = PeakArenaManager
PeakArenaManager.masked = {
  name = "\231\137\155\230\136\152\229\163\171",
  guild = "\231\165\158\231\167\152\231\187\132\231\187\135",
  isMasked = function(grade)
    local tb = ed.getDataTable("PeakArenaGrade")
    return tb[grade] and tb[grade]["Arena Step"] == "high"
  end,
  avatar = 116
}
PeakArenaManager.reserve = {grade = 6}
ed.UITool.registViewOpenFunc("PeakArenaPvpScene", function()
  if ed.PeakArenaManager:getState() == ed.peakArenaState.Preparing then
    ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\176\154\230\156\170\229\188\128\229\144\175"))
    return
  end
  local ds = ed.playerlimit.getAreaUnlockPrompt("PeakArena")
  if ds then
    ed.showToast(ds)
    return
  else
    ReloadModule("ui_new/modules/peakArena/peakArenaModuleList")
    ed.PeakArenaNetwork:sendOpenPanel()
  end
end)

function PeakArenaManager.getInstance()
  if not PeakArenaManager.instance then
    PeakArenaManager.instance = PeakArenaManager.create()
  end
  return PeakArenaManager.instance
end

function PeakArenaManager.create()
  local self = {}
  setmetatable(self, PeakArenaManager)
  self:initData()
  return self
end

function PeakArenaManager:initData()
  self.dataReady = false
  self.season = 0
  self.state = ed.peakArenaState.OffSeason
  self.endTime = 0
  self.openTime = 0
  self.gradePhase = ed.peakArenaGradePhase.Low
  self.grade = 1
  self.score = 0
  self.zone = 1
  self.medal = 0
  self.medalRank = 0
  self.leftRefreshTimes = 0
  self.maxRefreshTimes = 10
  self.countingInfo = {}
  self.countingResult = {}
  self.leftTimes = 0
  self.maxTimes = 5
  self.ticketUseCount = 0
  self.ticketMaxUseCount = 0
  self.gradeRewardFlags = {}
  self.medalRewardFlags = {}
  self.leftSaluteTimes = 0
  self.seasonBuffs = {}
  self.oppos = {}
  self.lineups = {}
  self.maxLineupAmount = ed.getDataTable("PeakArenaConfig")["High Grade Team Amount"].Value[1]
end

function PeakArenaManager:getScore()
  return self.score or 0
end

function PeakArenaManager:setScore(value)
  self.score = value or 0
end

function PeakArenaManager:getLeftSaluteTimes()
  return self.leftSaluteTimes or 0
end

function PeakArenaManager:setLeftSaluteTimes(value)
  self.leftSaluteTimes = value or 0
end

function PeakArenaManager:getSeason()
  return self.season or 0
end

function PeakArenaManager:setSeason(value)
  self.season = value or 0
end

function PeakArenaManager:getGradeRewardFlags()
  return self.gradeRewardFlags or {}
end

function PeakArenaManager:setGradeRewardFlags(value)
  self.gradeRewardFlags = value or {}
end

function PeakArenaManager:getMaxGradeRewardFlag()
  local maxGradeFlag
  for _, gradeFlag in pairs(self.gradeRewardFlags or {}) do
    if not maxGradeFlag then
      maxGradeFlag = gradeFlag
    else
      maxGradeFlag = math.max(maxGradeFlag, gradeFlag)
    end
  end
  return maxGradeFlag
end

function PeakArenaManager:getMedalRank()
  return self.medalRank or 0
end

function PeakArenaManager:setMedalRank(value)
  self.medalRank = value or 0
end

function PeakArenaManager:getLeftTimes()
  return self.leftTimes or 0
end

function PeakArenaManager:getLeftTicketUseTimes()
  return self:getTicketMaxUseCount() - self:getTicketUseCount()
end

function PeakArenaManager:setTicketUseCount(value)
  self.ticketUseCount = value or 0
end

function PeakArenaManager:getTicketUseCount()
  return self.ticketUseCount
end

function PeakArenaManager:setTicketMaxUseCount(value)
  self.ticketMaxUseCount = value or 0
end

function PeakArenaManager:getTicketMaxUseCount()
  return self.ticketMaxUseCount
end

function PeakArenaManager:setMaxRefreshTimes(value)
  self.maxRefreshTimes = value or 0
end

function PeakArenaManager:getMaxRefreshTimes()
  return self.maxRefreshTimes
end

function PeakArenaManager:setLeftRefreshTimes(value)
  self.leftRefreshTimes = value or 0
end

function PeakArenaManager:getLeftRefreshTimes()
  return self.leftRefreshTimes
end

function PeakArenaManager:setLeftTimes(value)
  self.leftTimes = value or 0
end

function PeakArenaManager:getDataReady()
  return self.dataReady or false
end

function PeakArenaManager:setDataReady(value)
  self.dataReady = value or false
end

function PeakArenaManager:getEndTime()
  return self.endTime or 0
end

function PeakArenaManager:setEndTime(value)
  self.endTime = value or 0
end

function PeakArenaManager:getOpenTime()
  return self.openTime or 0
end

function PeakArenaManager:setOpenTime(value)
  self.openTime = value or 0
end

function PeakArenaManager:getMedalRewardFlags()
  return self.medalRewardFlags or {}
end

function PeakArenaManager:setMedalRewardFlags(value)
  self.medalRewardFlags = value or {}
end

function PeakArenaManager:canTakeMedalReward()
  return false
end

function PeakArenaManager:isMedalRewardTaken(index)
  return ed.isElementInTable(index, self.medalRewardFlags)
end

function PeakArenaManager:markMedalRewardTaken(index)
  table.insert(self.medalRewardFlags, index)
  FireEvent("PeakArenaRedDotChanged")
end

function PeakArenaManager:getGrade()
  return self.grade or 1
end

function PeakArenaManager:setGrade(value)
  self.grade = value or 1
end

function PeakArenaManager:getState()
  return self.state or ed.peakArenaState.OffSeason
end

function PeakArenaManager:setState(value)
  self.state = value or ed.peakArenaState.OffSeason
end

function PeakArenaManager:getZone()
  return self.zone
end

function PeakArenaManager:setZone(value)
  self.zone = value or self.zone
end

function PeakArenaManager:getGradePhase()
  return self.gradePhase or ed.peakArenaGradePhase.Low
end

function PeakArenaManager:setGradePhase(value)
  self.gradePhase = value or ed.peakArenaGradePhase.Low
end

function PeakArenaManager:getMaxTimes()
  return self.maxTimes or 0
end

function PeakArenaManager:setMaxTimes(value)
  self.maxTimes = value or 0
end

function PeakArenaManager:getCountingInfo()
  return self.countingInfo or {}
end

function PeakArenaManager:setCountingInfo(value)
  self.countingInfo = value or {}
end

function PeakArenaManager:getMedal()
  return self.medal or 0
end

function PeakArenaManager:setMedal(value)
  self.medal = value or 0
end

function PeakArenaManager:setOppos(oppos)
  self.oppos = oppos or {}
end

function PeakArenaManager:getOppo(index)
  return self.oppos[index]
end

function PeakArenaManager:setSummary(summary)
  self.summary = summary
end

function PeakArenaManager:getSummary()
  return self.summary
end

function PeakArenaManager:isOnSeason()
  return self.state == ed.peakArenaState.OnSeason
end

function PeakArenaManager:isOffSeason()
  return self.state == ed.peakArenaState.OffSeason
end

function PeakArenaManager:isPreparing()
  return self.state == ed.peakArenaState.Preparing
end

function PeakArenaManager:isPlayoff()
  return self.state == ed.peakArenaState.Playoff
end

function PeakArenaManager:isSelfHighGrade()
  local tb = ed.getDataTable("PeakArenaGrade")
  return tb[self.grade] and tb[self.grade]["Arena Step"] == "high"
end

function PeakArenaManager:getGradeCount()
  if not self.gradeCount then
    self.gradeCount = #ed.getDataTable("topArenaGrade")
  end
  return self.gradeCount
end

function PeakArenaManager:isSelfMaxGrade()
  return self:getGrade() >= self:getGradeCount()
end

function PeakArenaManager:isSelfMinGrade()
  return self:getGrade() <= 1
end

function PeakArenaManager:isCoungting()
  return false
end

function PeakArenaManager:getUpgradeScore()
  return self.countingInfo._up_score or 0
end

function PeakArenaManager:getKeepgradeScore()
  return self.countingInfo._keep_score or 0
end

function PeakArenaManager:getCountingTime()
  return self.countingInfo._end_time or 0
end

function PeakArenaManager:getSeasonName(season)
  local row = ed.getDataTable("PeakArenaSeason")[season]
  local name = row["Season Name"]
  return name
end

function PeakArenaManager:getGradeName(gradeId)
  local tb = ed.getDataTable("PeakArenaGrade")
  return tb[gradeId]["Grade Name"]
end

function PeakArenaManager:getGradeTextRes(gradeId)
  gradeId = gradeId or self.grade
  local fixGradeGroupId = ed.getDataTable("PeakArenaSeason")[self:getSeason()]["Fix Grade Group"]
  if 0 < fixGradeGroupId then
    local fixGradeInfo = ed.getDataTable("PeakArenaGradeinfo")[fixGradeGroupId]
    return string.format("UI/alpha/1080P/toparena/rank/%s.png", fixGradeInfo[gradeId]["Grade Icon"])
  else
    local tb = ed.getDataTable("PeakArenaGrade")
    return string.format("UI/alpha/1080P/toparena/rank/%s.png", tb[gradeId]["Grade Icon"])
  end
end

function PeakArenaManager:getGradeIconRes(gradeId)
  gradeId = gradeId or self.grade
  local fixGradeGroupId = ed.getDataTable("PeakArenaSeason")[self:getSeason()]["Fix Grade Group"]
  if 0 < fixGradeGroupId then
    local fixGradeInfo = ed.getDataTable("PeakArenaGradeinfo")[fixGradeGroupId]
    return string.format("UI/alpha/1080P/toparena/rank/%s.png", fixGradeInfo[gradeId]["Grade Symbol Icon"])
  else
    local tb = ed.getDataTable("PeakArenaGrade")
    return string.format("UI/alpha/1080P/toparena/rank/%s.png", tb[gradeId]["Grade Symbol Icon"])
  end
end

function PeakArenaManager:getGradeScoreRange(gradeId)
  gradeId = gradeId or self.grade
  local fixGradeGroupId = ed.getDataTable("PeakArenaSeason")[self:getSeason()]["Fix Grade Group"]
  local tb
  if 0 < fixGradeGroupId then
    tb = ed.getDataTable("PeakArenaGradeinfo")[fixGradeGroupId]
  else
    tb = ed.getDataTable("PeakArenaGrade")
  end
  local startScore, endScore
  startScore = tb[gradeId]["Start Score"]
  if tb[gradeId + 1] then
    endScore = tb[gradeId + 1]["Start Score"]
    endScore = endScore and endScore - 1
  end
  return startScore, endScore
end

function PeakArenaManager:getTimesTicketEquipId()
  local row = ed.getDataTable("PeakArenaSeason")[self:getSeason()]
  local id = row["Challenge Ticket ID"]
  self.timesTicketEquipId = id
  return id
end

function PeakArenaManager:getTimesTicketAmount()
  return ed.player:getEquipAmount(self:getTimesTicketEquipId())
end

function PeakArenaManager:setPvpSceneInstance(pvpScene)
  self.pvpScene = pvpScene
end

function PeakArenaManager:setEvolveInfo(data)
  if data then
    self.evolveState = data._evolve_state
    self.evolveTime = data._evolve_end_time or 0
  else
    self.evolveState = nil
    self.evolveTime = 0
  end
end

function PeakArenaManager:setScoreRank(scoreRank)
  self.scoreRank = scoreRank or 0
end

function PeakArenaManager:getScoreRank()
  return self.scoreRank or 0
end

function PeakArenaManager:handleOpenPanel(data)
  self:setSeason(data._season)
  self:setState(data._state)
  self:setZone(data._zone)
  self:setEndTime(data._end_time)
  self:setOpenTime(data._open_time)
  self:setGradePhase(data._step)
  self:setGrade(data._grade)
  self:setScore(data._score)
  self.lineupGs = data._lineup_gs
  self:setMedal(data._medal)
  self:setLeftTimes(data._left_times)
  self:setMaxTimes(data._max_times)
  self:setLeftRefreshTimes(data._left_refresh_times)
  self:setMaxRefreshTimes(data._refresh_max_times)
  self.refreshLastRecoverTime = data._refresh_last_recover_time or 0
  self:setTicketUseCount(data._ticket_use_count)
  self:setTicketMaxUseCount(data._ticket_max_use_count)
  self.keyUseCount = data._key_use_count or self.keyUseCount
  self.keyMaxUseCount = data._key_max_use_count or self.keyMaxUseCount
  self:setGradeRewardFlags(data._grade_reward_flags)
  self:setMedalRewardFlags(data._medal_reward_flags)
  self:setSummary(data._summary)
  self:setEvolveInfo(data._evolve_info)
  self:setScoreRank(data._score_rank)
  self.canChallenge = data._can_challenge
  self.gradeState = data._grade_state
  self.scorePunish = data._score_punish
  self.setLineupCD = data._set_lineup_cd_time or 0
  self.tallyResult = data._tally_result
  self.zoneRank = data._zone_rank or 0
  self.coins = data._coins or 0
  self.banSelected = data._ban_selected
  self.banedHeroes = data._baned_heroes
  self.seasonBuffs = data._season_buff or {}
  self.daychangeLineupTimes = data._day_change_lineup_times or 0
  self:setDataReady(true)
  ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.Counting, false)
  ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.MedalRewardNotify, false)
  ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.MedalTab, self:canTakeMedalReward())
  if self.banSelected then
    ed.storage.setValue(ed.getRoleKey("peakarenaBanHeroRed" .. data._season), true)
  end
  if self.banSelected or not self:isPlayoff() then
    ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.BanHero, false)
  end
  if self.pvpScene then
    self.pvpScene:popGradeUpDownWindow()
  else
    local pvpScene = ed.ui.PeakArenaPvpScene.create()
    self:setPvpSceneInstance(pvpScene)
    ed.pushScene(pvpScene)
    pvpScene:popGradeUpDownWindow()
  end
end

function PeakArenaManager:isEvolving()
  if self.evolveState == "prepare" or self.evolveState == "running" then
    return true
  else
    return false
  end
end

function PeakArenaManager:handleNotify(data)
  self:setSeason(data._season)
  self:setState(data._state)
  self:setEndTime(data._end_time)
  local keys = ed.PeakArenaRedDotTreeKeys
  if data._new_season == 1 then
    local ds = ed.playerlimit.getAreaUnlockPrompt("PeakArena")
    if not ds then
      local newSeasonList = ed.newSeasonOrActOpen
      newSeasonList[150] = T("\230\150\176\232\181\155\229\173\163\229\188\128\229\144\175")
    end
  end
  ed.PeakArenaRedDotTree:update(keys.MedalRewardNotify, data._medal_reward == 1)
  ed.PeakArenaRedDotTree:update(keys.Attack, data._challenge_record == 1)
  ed.PeakArenaRedDotTree:update(keys.Counting, data._tally_record == 1)
  if self:isPlayoff() and self:getBanAmount() > 0 and ed.player:getUUID() then
    local banHeroRed = ed.storage.getBool(ed.getRoleKey("peakarenaBanHeroRed" .. data._season))
    ed.PeakArenaRedDotTree:update(keys.BanHero, not banHeroRed)
  end
end

function PeakArenaManager:handleRefreshOppo(data)
  local newOppo = {
    false,
    false,
    false
  }
  for k, v in ipairs(data._oppos or {}) do
    if v._role_id ~= (self:getOppo(k) or {})._role_id then
      newOppo[k] = true
    end
  end
  self:setOppos(data._oppos)
  self:setLeftRefreshTimes(data._left_refresh_times)
  self:setMaxRefreshTimes(data._refresh_max_times)
  self.refreshLastRecoverTime = data._refresh_last_recover_time or self.refreshLastRecoverTime
  FireEvent("PeakArenaRefreshOppo", newOppo)
end

function PeakArenaManager:handleQueryPlayer(data)
  FireEvent("PeakArenaQueryPlayer", data)
end

function PeakArenaManager:handleHistoryBoard(data)
  local records = data._records or {}
  if #records == 0 then
    ed.showToast(T("\230\154\130\230\151\160\229\142\134\229\143\178\232\181\155\229\173\163\230\136\152\231\187\169\232\174\176\229\189\149"))
    return
  end
  FireEvent("PeakArenaHistoryBoard", records)
end

function PeakArenaManager:handleMedalReward(data)
  local rewardList = data._rewards or {}
  local rewardIdx = data._reward_idx
  if not ed.isElementInTable(rewardIdx, self.medalRewardFlags) then
    table.insert(self.medalRewardFlags, rewardIdx)
  end
  ed.player:addRewards(rewardList)
  ed.UITool.showRewardsFromServer(rewardList)
  ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.MedalTab, self:canTakeMedalReward())
  FireEvent("EventPeakArenaMedalReward")
end

function PeakArenaManager:handleGetLineup(data)
  FireEvent("PeakArenaGetLineup", data._lineups or {})
end

function PeakArenaManager:handleSetLineup(data)
  local success = data._result == "success"
  if success then
    self.lineupGs = data._lineup_gs
    self.setLineupCD = ed.getServerTime() + 300
    ed.showToast(success and T("\228\191\157\229\173\152\233\152\159\229\189\162\230\136\144\229\138\159") or T("\228\191\157\229\173\152\233\152\159\229\189\162\229\164\177\232\180\165"))
    FireEvent("PeakArenaSetLineUpSuccess")
  end
end

function PeakArenaManager:handleQueryOppo(data)
  FireEvent("PeakArenaQueryOppo", data)
end

function PeakArenaManager:handleChallengeResult(data)
  self:setScore(data._self_new_score)
  self.beforeScore = data._self_before_score
  self.scoreAction = self.score ~= self.beforeScore
  if data._new_grade then
    if self.grade < data._new_grade then
      self.gradeState = "raise"
    elseif self.grade > data._new_grade then
      self.gradeState = "fall"
    end
    self:setGrade(data._new_grade)
  end
  self:setLeftTimes(self:getLeftTimes() - 1)
  self:setEvolveInfo(data._evolve_info)
  self:setScoreRank(data._self_rank)
  self.scorePunish = data._score_punish or self.scorePunish
  self.zoneRank = data._zone_rank or self.zoneRank
  FireEvent("PeakArenaChallengeResult", data)
  if data._medal then
    self.medal = self.medal + data._medal
    self.medalAction = true
    FireEvent("PeakArenaMedalChange", data._medal)
    ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.MedalTab, self:canTakeMedalReward())
  end
  ed.player:increaseDailyjobCount({
    type = "PeakArenaBattle",
    add = 1
  })
  if data._coins then
    self.coins = (self.coins or 0) + data._coins
    FireEvent("ResourceNumChange", "PeakArenaPoint")
  end
end

function PeakArenaManager:handleEvolveChallengeResult(data)
  self:setScore(data._self_new_score)
  self.beforeScore = data._self_before_score
  self.scoreAction = self.score ~= self.beforeScore
  if data._new_grade then
    if self.grade < data._new_grade then
      self.gradeState = "raise"
    elseif self.grade > data._new_grade then
      self.gradeState = "fall"
    end
    self:setGrade(data._new_grade)
  end
  self:setEvolveInfo(data._evolve_info)
  self:setScoreRank(data._self_rank)
  FireEvent("PeakArenaEvolveChallengeResult", data)
  ed.player:increaseDailyjobCount({
    type = "PeakArenaBattle",
    add = 1
  })
end

function PeakArenaManager:shouldPopSeasonSummary()
  if self.state == ed.peakArenaState.Playoff and self:getSummary() then
    local isPoped = ed.storage.getBool(ed.getRoleKey("peakarenaSummary" .. self.season))
    return not isPoped
  end
  return false
end

function PeakArenaManager:handleQuerySummary(data)
  ed.ui.BattleStaticsWin.create(data._summary, "peakArena")
end

function PeakArenaManager:handleGetReplay(data)
  if not data._replay then
    ed.showToast(T("\229\155\158\230\148\190\230\149\176\230\141\174\228\184\141\229\173\152\229\156\168"))
    return
  end
  FireEvent("PeakArenaGetReplay", data)
end

function PeakArenaManager:handleGetRecords(data)
  FireEvent("PeakArenaGetRecords", data or {})
end

function PeakArenaManager:handleAddChallengeTimes(data)
  self:setLeftTimes(data._left_times)
  self:setMaxTimes(data._max_times)
  self:setTicketUseCount(data._ticket_use_count)
  self.keyUseCount = data._key_use_count or self.keyUseCount
  self.keyMaxUseCount = data._key_max_use_count or self.keyMaxUseCount
  FireEvent("PeakArenaChallengeTimesChanged")
end

function PeakArenaManager:handleErrorCode(errorCode)
  ed.showToast(errorCode)
end

function PeakArenaManager:handleQueryGoods(queryGoods)
  local shopTable = ed.getDataTable("PeakArenaShop")
  self.shopList = {}
  local sellShort = {}
  local discount = {}
  for t, v in ipairs(queryGoods._goods or {}) do
    local groups = shopTable[v._group_id] or {}
    local shopData = groups[v._index]
    local amount = 999
    if v._max_buy_times and v._cur_buy_times then
      amount = v._max_buy_times - v._cur_buy_times
    end
    local items = {
      item = {
        id = shopData["Reward ID"],
        count = shopData["Reward Amount"],
        type = shopData["Reward Type"]
      },
      price = shopData.Price,
      priceType = "peakarenapoint",
      amountNew = v._cur_buy_times or 0,
      amountMax = v._max_buy_times or 1,
      index = v._index,
      zhe = shopData["Show Discount"],
      groupId = v._group_id
    }
    if amount <= 0 then
      table.insert(sellShort, items)
    elseif shopData["Show Discount"] then
      table.insert(discount, items)
    else
      table.insert(self.shopList, items)
    end
  end
  table.sort(self.shopList, function(a, b)
    local aQy = ed.readequip.quality(a.item.id) or ed.toKenQuality[a.item.type] or 0
    local bQy = ed.readequip.quality(b.item.id) or ed.toKenQuality[b.item.type] or 0
    if aQy == bQy then
      return a.item.id > b.item.id
    end
    return aQy > bQy
  end)
  table.sort(discount, function(a, b)
    local aQy = ed.readequip.quality(a.item.id) or ed.toKenQuality[a.item.type] or 0
    local bQy = ed.readequip.quality(b.item.id) or ed.toKenQuality[b.item.type] or 0
    if aQy == bQy then
      return a.item.id > b.item.id
    end
    return aQy < bQy
  end)
  for _, v in ipairs(sellShort) do
    table.insert(self.shopList, v)
  end
  for _, v in ipairs(discount) do
    table.insert(self.shopList, 1, v)
  end
  ed.pushScene(ed.ui.PeakArenaShopScene.create())
end

function PeakArenaManager:handleBuyGoods(buyGoods)
  ed.player:addRewards(buyGoods._rewards or {})
  for _, v in ipairs(self.shopList) do
    if v.groupId == buyGoods._group_id and v.index == buyGoods._goods_index then
      v.amountNew = buyGoods._cur_buy_times
    end
  end
  self.coins = buyGoods._left_coin
  FireEvent("peakArenaShopItemUpdate")
  FireEvent("ResourceNumChange", "PeakArenaPoint")
end

function PeakArenaManager:handleQueryBanList(banList)
  self.votedHeroList = banList._ban_heroes
  FireEvent("peakArenaBanList")
end

function PeakArenaManager:handleVoteHero(voteReply)
  local result = voteReply._result
  self.votedHeroList = voteReply._ban_heroes
  self.banSelected = voteReply._ban_selected
  ed.storage.setValue(ed.getRoleKey("peakarenaBanHeroRed" .. self.season), true)
  ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.BanHero, false)
  FireEvent("peakArenaBanList")
end

function PeakArenaManager:readRewards(v)
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

function PeakArenaManager:getSeasonBuff(key)
  return ed.getDataTable("PeakArenaBuff")[key]
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

function PeakArenaManager.enterReplay(replayData, notSkipBattle, battleIdx)
  local roundId = replayData._round
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
  local mode = "peakArena"
  local format_data = ed.copyProto(replayData)
  format_data._self_heroes = selfHeros
  format_data._oppo_heroes = oppoHeros
  format_data._username = replayData._self_user._name
  format_data._oppo_name = replayData._oppo_user._name
  format_data._avatar = replayData._self_user._avatar
  format_data._oppo_avatar = replayData._oppo_user._avatar
  format_data._season_buff_key = replayData._season_buff_key
  local stageid = legendArenaStageID[roundId] or -57
  ed.ui.vcdLayer.setData(format_data, mode, stageid)
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
    checkid = replayData._checkid,
    userMedal = replayData._self_user._medal,
    oppoMedal = replayData._oppo_user._medal,
    seasonBuffIds = replayData._season_buff_key
  }
  ed.srand(replayData._rseed)
  if notSkipBattle then
    ed.engine:enterRelay2({
      hero_list = selfHeros,
      enemy_list = oppoHeros,
      battleIdx = battleIdx,
      stage_id = stageid,
      mode = mode,
      selfBonus = replayData._self_bonus or nil,
      oppoBonus = replayData._oppo_bonus or nil,
      seasonBuffIds = replayData._season_buff_key
    })
    ed.scene:reset(stage, battle, {
      peakArenaInfo = {}
    })
    ed.pushScene(ed.scene)
  else
    ed.engine:enterRelay({
      hero_list = selfHeros,
      enemy_list = oppoHeros,
      stage_id = stageid,
      mode = mode,
      selfBonus = replayData._self_bonus or nil,
      oppoBonus = replayData._oppo_bonus or nil,
      seasonBuffIds = replayData._season_buff_key
    })
    ed.scene:reset(stage, battle, {replayInfo = info})
    ed.pushScene(ed.scene)
  end
end

PeakArenaManager.peakArenaAchievementLineId = 102

function PeakArenaManager:peakArenaAchFcaGroup(type, data)
  if type == "add" then
    self.AchGroup = self.AchGroup or {}
    table.insert(self.AchGroup, data)
  elseif type == "clear" then
    self.AchGroup = nil
  elseif self.AchGroup then
    local achData = ed.taskData:getPageDataObj("ach")
    local num = 0
    for _, v in ipairs(self.AchGroup) do
      ed.showAchFcaGroup(achData:getAchCupType(v._line_id, v._id), T("\230\136\144\229\176\177:%s", achData:getAchName(v._line_id, v._id)))
      num = num + 1
    end
    ed.taskData:achievementRed(num)
    return self:peakArenaAchFcaGroup("clear")
  end
  return self.AchGroup
end

function PeakArenaManager:getRealitySeason()
  local seasonName = ed.getDataTable("PeakArenaSeason")[self:getSeason()]["Season Name"]
  local season = string.gsub(seasonName, "S", "")
  return tonumber(season)
end

function PeakArenaManager:getBanSelected()
  return self.banSelected
end

function PeakArenaManager:getBanedHeroes()
  return self.banedHeroes
end

function PeakArenaManager:getAllVotedHero()
  return self.votedHeroList or {}
end

function PeakArenaManager:getBanAmount()
  local banAmount = ed.getDataTable("PeakArenaSeason")[self:getSeason()]["Ban Amount"]
  return banAmount or 0
end

function PeakArenaManager:getBanAmount()
  local banAmount = ed.getDataTable("PeakArenaSeason")[self:getSeason()]["Ban Amount"]
  return banAmount or 0
end

function PeakArenaManager:isSetLineup()
  return self.daychangeLineupTimes < ed.getDataTable("PeakArenaConfig")["Set Lineup Max"].Value[1]
end

function PeakArenaManager:setDaychangeLineupTimes(num)
  self.daychangeLineupTimes = num
end

ed.PeakArenaManager = PeakArenaManager.getInstance()
