local GuildRaidManager = {}
GuildRaidManager.__index = GuildRaidManager
local instance

function GuildRaidManager.getInstance()
  if not instance then
    instance = GuildRaidManager.create()
  end
  return instance
end

function GuildRaidManager.create()
  local self = {}
  setmetatable(self, GuildRaidManager)
  self:initData()
  return self
end

function GuildRaidManager.isDebug()
  return false
end

GuildRaidManager.MaxStageProgress = 10000

function GuildRaidManager:initData()
  local raidTable = ed.getDataTable("Raid")
  self.raidInfo = {}
  self.curWeeklyRaidPoint = 0
  self.maxWeeklyRaidPoint = 999999
  self.curDiscountTimes = 0
  self.maxDiscountTimes = 1
  for k, v in ipairs(raidTable) do
    local raidItem = {
      raidId = k,
      chapterID = v["Chapter ID"],
      difficulty = v.Difficulty,
      name = v["Display Name"],
      icon = v.Icon,
      cost = v["Guild Active Cost"],
      discountCost = v["Guild Active Weekly Discount"],
      chanllengeGold = v["Gold Reward"],
      completeItem = {
        type = v["Complete Reward Type"],
        id = v["Complete Reward ID"],
        amount = v["Complete Reward Amount"]
      },
      isPassed = false,
      isOpen = false,
      progress = 0,
      fastDeadline = 0,
      fastRaidPoint = 0,
      curBattleTimes = 0,
      maxBattleTimes = 0,
      topDamageBonus = 0,
      gsLevelBonus = 0,
      raidPoint = 0
    }
    local stages = {}
    for i = 1, v["Stages Count"] do
      local stage = {
        stageId = v["Begin Stage ID"] + i - 1,
        stageProgress = 0,
        wave = 1,
        hpList = {
          100,
          100,
          100,
          100,
          100
        },
        curChallenge = {},
        fcaPlayed = false
      }
      table.insert(stages, stage)
    end
    raidItem.stages = stages
    table.insert(self.raidInfo, raidItem)
  end
end

function GuildRaidManager:getRaidByChapterIdAndDifficulty(chapterId, difficult)
  local raids = ed.getDataTable("Raid")
  for _, raid in ipairs(raids) do
    if raid["Chapter ID"] == chapterId and raid.Difficulty == difficult then
      return raid
    end
  end
end

function GuildRaidManager:isRaidOpened(raidId)
  local raids = ed.getDataTable("Raid")
  local curRaid = raids[raidId]
  local preId = 0
  if curRaid.Difficulty > 1 then
    preId = self:getRaidByChapterIdAndDifficulty(curRaid["Chapter ID"], curRaid.Difficulty - 1)["Raid ID"]
  else
    local temp = self:getRaidByChapterIdAndDifficulty(curRaid["Chapter ID"] - 1, 1)
    if temp then
      preId = temp["Raid ID"]
      print(preId)
    else
      return true
    end
  end
  return self.raidInfo[preId].isPassed
end

function GuildRaidManager:refreshInstanceSummary(data)
  local raid = self.raidInfo[data._raid_id]
  raid.progress = data._progress
  raid.fastDeadline = data._fast_deadline
  raid.fastRaidPoint = data._fast_raid_point
  raid.curBattleTimes = data._cur_battle_times
  raid.maxBattleTimes = data._max_battle_times
end

function GuildRaidManager:getRaidIdByStageId(stageId)
  for k, v in ipairs(self.raidInfo) do
    if stageId >= v.stages[1].stageId and stageId < v.stages[1].stageId + #v.stages then
      return k
    end
  end
end

function GuildRaidManager:refreshRaidList(data)
  for _, value in ipairs(data._passed_raid_ids or {}) do
    self.raidInfo[value].isPassed = true
    self.raidInfo[value].progress = ed.GuildRaidConfig.MaxStageProgress
  end
  self.curWeeklyRaidPoint = data._cur_weekly_liveness
  self.maxWeeklyRaidPoint = data._max_weekly_liveness
  self.curDiscountTimes = data._cur_discount_times
  self.maxDiscountTimes = data._max_discount_times
  self.openInstanceInfo = {}
  for k, v in ipairs(data._open_instances or {}) do
    local raid = self.raidInfo[v._raid_id]
    raid.isOpen = true
    self:refreshInstanceSummary(v)
  end
  table.sort(self.raidInfo, function(a, b)
    return a.raidId < b.raidId
  end)
end

function GuildRaidManager:handleRaidOpenPanelReply(data)
  self:refreshRaidList(data)
  FireEvent("GuildRaidOpenPanel")
end

function GuildRaidManager:handleRaidOpenInstanceReply(data)
  if data._result == "success" then
    ed.GuildManager.vitality = data._left_liveness
    local instance = data._instance
    local raid = self.raidInfo[instance._raid_id]
    raid.isOpen = true
    self:refreshInstanceSummary(instance)
    FireEvent("GuildRaidOpenSuccess")
  end
end

function GuildRaidManager:handleRaidResetInstanceReply(data)
  if data._result == "success" then
    ed.GuildManager.vitality = data._left_liveness
    local instance = data._instance
    local raid = self.raidInfo[instance._raid_id]
    for k, v in ipairs(raid.stages) do
      v.fcaPlayed = false
    end
    raid.isOpen = true
    self:refreshInstanceSummary(instance)
    FireEvent("GuildRaidResetSuccess")
  end
end

function GuildRaidManager:refreshStageDataInRaid(raidInfo, stageDatas)
  for k, serverStageData in ipairs(stageDatas) do
    for k, stage in ipairs(raidInfo.stages) do
      if serverStageData._stage_id == stage.stageId then
        stage.stageProgress = serverStageData._progress
        stage.wave = serverStageData._wave
        stage.hpList = serverStageData._hp_list
        stage.curChallenge = serverStageData._challenger
      end
    end
  end
end

function GuildRaidManager:handleRaidQueryInstanceReply(data)
  local instance = data._instance
  local raid = self.raidInfo[instance._raid_id]
  self:refreshInstanceSummary(instance)
  raid.topDamageBonus = data._top_damage_bonus
  raid.joinProcess = data._join_process
  raid.gsLevelBonus = data._gs_level_bonus
  raid.raidPoint = data._raid_point
  self:refreshStageDataInRaid(raid, data._stages)
  FireEvent("GuildRaidQueryInstance")
end

function GuildRaidManager:handleRaidQueryStageReply(data)
  local stage = data._stage
  local raidId = self:getRaidIdByStageId(stage._stage_id)
  self:refreshStageDataInRaid(self.raidInfo[raidId], {stage})
  self.raidInfo[raidId].curBattleTimes = data._cur_battle_times
  self.raidInfo[raidId].maxBattleTimes = data._max_battle_times
  FireEvent("GuildRaidQueryStage")
end

function GuildRaidManager:handleRaidPrepareBattleReply(data)
  local raidId = self.win.raidId
  if data._result == "success" then
    if data._stage then
      local stage = data._stage
      self:refreshStageDataInRaid(self.raidInfo[raidId], {stage})
    end
    self.raidInfo[raidId].curBattleTimes = data._cur_battle_times
    self.raidInfo[raidId].maxBattleTimes = data._max_battle_times
    self.nextPrepareTime = data._next_prepare_time
    local newtime = ed.getServerTime()
    self.leftTime = data._next_prepare_time - newtime
  elseif data._stage then
    local stage = data._stage
    self:refreshStageDataInRaid(self.raidInfo[raidId], {stage})
  end
  FireEvent("GuildRaidPrepareBattle", data)
end

function GuildRaidManager:handleRaidStartBattleReply(data)
  local stage = data._stage
  local raidId = self:getRaidIdByStageId(stage._stage_id)
  self:refreshStageDataInRaid(self.raidInfo[raidId], {stage})
  local instanceInfo = {
    wave = stage._wave,
    hpInfo = stage._hp_list
  }
  self.startTime = data._start_time
  self.retryLeft = data._retry_left
  ed.record:refreshCommonRecord("enterRaid")
  ed.srand(data._rseed)
  ed.netreply.enterGuildInstance(nil, nil, nil, nil, instanceInfo)
  ed.netreply.enterGuildInstance = nil
end

function GuildRaidManager:handleRaidEndBattleReply(data)
  if data._result == "canceled" then
    ed.ui.stageaccount.initialize({
      stage_id = ed.engine.stage_info["Stage ID"],
      victory = false,
      loseType = "fail",
      isPveMode = false
    })
    return
  end
  local instance = data._instance
  local raid = self.raidInfo[instance._raid_id]
  self:refreshInstanceSummary(instance)
  self:refreshStageDataInRaid(raid, data._stages)
  local progress = 0
  for k, v in ipairs(data._stages) do
    if v._stage_id == ed.engine.stage_info["Stage ID"] then
      progress = v._progress
    end
  end
  self.curChallengeStageId = ed.engine.stage_info["Stage ID"]
  local info = {
    oldProgress = data._stage_old_progress,
    gold = raid.chanllengeGold,
    damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer)),
    progress = progress
  }
  ed.player:addRewards(data._rewards)
  local args = {
    victory = true,
    stage_id = ed.engine.stage_info["Stage ID"],
    heroes = ed.engine.hero_id_list,
    loots = nil,
    isGuildRaid = true,
    breakHistory = data._break_history,
    guildInstanceData = info,
    mercenaryInfo = ed.engine:getTeamMercenaryInfo()
  }
  ed.player:takeStageReward(args.stage_id, nil, ed.engine.hero_list, nil)
  ed.ui.stageaccount.initialize(args)
end

function GuildRaidManager:handleRaidViewMembersReply(data)
end

function GuildRaidManager:handleRaidMemberRankReply(data)
  FireEvent("GuildRaidMemberRank", data)
end

function GuildRaidManager:handleRaidStageRankReply(data)
  FireEvent("GuildRaidStageRank", data)
end

function GuildRaidManager:getBossPosBySIdAndWave(stageId, wave)
  return ed.getDataTable("Battle")[stageId][wave]["Boss Position"] or 0
end

function GuildRaidManager:getEnemyInformation(stageId, wave)
  local enemyInfo = {}
  local battleTb = ed.getDataTable("Battle")[stageId][wave]
  local stageTb = ed.getDataTable("Stage")[stageId]
  local ids = {}
  for i = 1, 5 do
    local id = battleTb[string.format("Monster %d ID", i)]
    if id and id ~= 0 then
      enemyInfo[i] = {
        id = id,
        res = ed.getUnitPortrait(id),
        level = stageTb["Monster Level"],
        stars = battleTb["Stars " .. i],
        rank = battleTb["Rank " .. i],
        index = i
      }
    end
  end
  local bossPos = self:getBossPosBySIdAndWave(stageId, wave)
  enemyInfo.bossPos = bossPos
  if enemyInfo[bossPos] then
    enemyInfo[bossPos].isBoss = true
    local bossStage = enemyInfo[bossPos]
    table.remove(enemyInfo, bossPos)
    table.insert(enemyInfo, bossStage)
  end
  return enemyInfo
end

ed.GuildRaidManager = GuildRaidManager.getInstance()
return GuildRaidManager
