local class = {}
ed.awakeDungeonMgr = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self.seasonId = 1
  self.curChapterId = 1
  self.paragonLevel = nil
  self.paragonExp = nil
  self.curVitality = nil
  self.vitalityUpdateTime = nil
  self.vitalityBuyTime = nil
  self.levelRewardsFlags = {}
  self.sweepRewardNum = 0
  self.unlockChapterTab = {}
  self.chapterRewardTab = {}
  self.chapterDoneInfos = {}
  self.chapterProgressTab = {}
  self.curPlayerCellX = 0
  self.curPlayerCellY = 0
  self.curStageProgressTab = {}
  self.curStageFirstRecordTab = {}
  self.curStageChanged = {}
  self.battlePrepareInfo = {}
  self.maxChapterId = nil
  self.maxParagonLevel = nil
  self.stageRecord = {}
  self.redPointMgr = ed.redPointMgr.getInstance()
  self:addEventListener()
  self:initBuildingRedDot()
end

function class:initMaxChapterId()
  local maxChapterId = 1
  local chapterGroup = self:getChapterGroup()
  for chapterId, _ in pairs(ed.getDataTable("DungeonChapter")[chapterGroup] or {}) do
    maxChapterId = math.max(maxChapterId, chapterId)
  end
  self.maxChapterId = maxChapterId
end

function class:initMaxLevel()
  local groupId = self:getLevelGroup()
  local maxParagonLevel = 0
  for level, _ in pairs(ed.getDataTable("ParagonLevel")[groupId] or {}) do
    maxParagonLevel = math.max(maxParagonLevel, level)
  end
  self.maxParagonLevel = maxParagonLevel
end

function class:initBuildingRedDot()
  self.redPointMgr:registerValueChange("awake_dungeon_entry", self, {
    handle = function(value)
      FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.AwakeDungeon)
    end
  })
end

function class:awakeDungeonIsOpen()
  local startTime, endTime = self:getTimeInfo()
  if not startTime or not endTime then
    return false, T("\230\180\187\229\138\168\230\154\130\230\156\170\229\188\128\229\144\175")
  end
  if startTime > ed.getServerTime() or endTime < ed.getServerTime() then
    return false, T("\230\180\187\229\138\168\230\154\130\230\156\170\229\188\128\229\144\175")
  end
  local unlockLevel = ed.getDataTable("DungeonConfig").OpenLevel.Value[1]
  if unlockLevel > ed.player:getLevel() then
    return false, string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167\229\188\128\229\144\175"), unlockLevel)
  end
  return true
end

function class:setBattlePrepareInfo(battlePrepareInfo)
  self.battlePrepareInfo = battlePrepareInfo
end

function class:handleNotify(data)
  local isVitalityFull = data._is_vitality_full
  local hasReward = data._has_reward
  self.redPointMgr:setNodeValue("awake_dungeon_vitality_full", isVitalityFull)
  self.redPointMgr:setNodeValue("awake_dungeon_reward_entry", hasReward)
end

function class:handleOpenPanel(data)
  self.seasonId = data._season_id
  self.curChapterId = data._cur_chapter_id or 1
  self.paragonLevel = data._paragon_level or 0
  self.paragonExp = data._paragon_exp or 0
  self.curVitality = data._cur_vitality or 0
  self.vitalityUpdateTime = data._vitality_update_time or 0
  self.vitalityBuyTime = data._vitality_buy_time or 0
  self.chapterDoneInfos = {}
  self.chapterProgressTab = {}
  for _, v1 in ipairs(data._chapter_infos or {}) do
    local chapterTab = self.chapterDoneInfos[v1._chapter_id]
    if nil == chapterTab then
      chapterTab = {}
      self.chapterDoneInfos[v1._chapter_id] = chapterTab
    end
    for _, v2 in ipairs(v1._light_blocks or {}) do
      local x, y = self:convertXYFromServer(v2._x, v2._y)
      local yTab = chapterTab[x]
      if nil == yTab then
        yTab = {}
        chapterTab[x] = yTab
      end
      yTab[y] = true
    end
  end
  self.chapterRewardTab = {}
  for i, v in ipairs(data._reward_chapters or {}) do
    self.chapterRewardTab[v] = true
  end
  self.levelRewardsFlags = data._level_rewards_flags or {}
  self.sweepRewardNum = data._sweep_reward or 0
  self.unlockChapterTab = {}
  for i, v in ipairs(data._light_chapters or {}) do
    self.unlockChapterTab[v] = true
  end
  self:checkExpAndLevelChanged()
  self:updateVitalityRedPoint()
  self.redPointMgr:setNodeValue("awake_dungeon_reward_entry", self:canTakeLevelReward())
  FireEvent("awakeDungeonOpenPanel")
end

function class:handleEnterStage(data)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local rseed = data._rseed or 0
  local hero_list = {}
  for i, id in ipairs(self.battlePrepareInfo.team) do
    if self.battlePrepareInfo.mercenaryIndex == i then
      local hero = ed.GuildManager:getMercenaryHero(self.battlePrepareInfo.mercenaryUID, id)
      if hero then
        table.insert(hero_list, hero)
      end
    else
      local hero = ed.player:getHero(id)
      if hero then
        table.insert(hero_list, hero)
      end
    end
  end
  for i, v in ipairs(data._free_heroes or {}) do
    local hero = ed.HeroCreate()
    hero:setup(v)
    table.insert(hero_list, hero)
  end
  local stageId = self.battlePrepareInfo.stageId
  local stage = ed.lookupDataTable("DungeonStage", nil, stageId)
  local battle = ed.lookupDataTable("DungeonBattle", nil, stageId, 1)
  ed.srand(rseed)
  local buffInfo = self:getBuffInfoByStageId(stageId)
  ed.engine:enterAwakeStage(stage, hero_list, false, buffInfo, {
    groupId = self:getLevelGroup(),
    level = self:getParagonLevel(),
    maxLevel = self:getMaxParagonLevel()
  })
  local extra_info = {}
  extra_info.awakeStageInfo = {}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:isBossStage(stageId)
  local dungeonStageCfg = ed.getDataTable("DungeonStage")[stageId]
  if dungeonStageCfg and dungeonStageCfg["Boss Difficulty"] > 0 then
    return true
  end
  return false
end

function class:handleExitStage(data)
  local result = data._result
  local checkId = data._checkid
  local rewards = data._normal_rewards
  local fdRewards = data._fd_rewards
  local stageId = data._stage_id
  local oldProgress = data._old_progress
  local curProgress = data._cur_progress
  local maxProgress = data._max_progress
  local coordinate = data._coordinate
  if result == "unknown" then
    if checkId and 0 < checkId and do_battle_log then
      ed.reportBattleLog(checkId, "awakeStage")
    end
    return
  end
  ed.player:addRewards(rewards or {})
  ed.player:addRewards(fdRewards or {})
  local x, y = self:convertXYFromServer(coordinate._x, coordinate._y)
  if nil ~= maxProgress then
    self:setCurStageProgress(x, y, maxProgress)
    self:addCurStageChanged(x, y)
    if ed.awakeDungeonDefine.MAX_PROGRESS == maxProgress then
      local chapterId = self:getCurrentChapterId()
      self:addChapterStageProgress(chapterId, x, y)
    end
  end
  local firstRecord = data._stage_record
  if nil ~= firstRecord then
    local x, y = self:convertXYFromServer(firstRecord._coordinate._x, firstRecord._coordinate._y)
    self:setCurStageFirstRecord(x, y, firstRecord)
  end
  if nil ~= data._cur_vitality then
    self.curVitality = data._cur_vitality
  end
  if nil ~= data._sweep_reward then
    self.sweepRewardNum = data._sweep_reward
  end
  if nil ~= data._paragon_level then
    self.paragonLevel = data._paragon_level
  end
  if nil ~= data._paragon_exp then
    self.paragonExp = data._paragon_exp
  end
  self:updateVitalityRedPoint()
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  if nil == stageTableItem then
    print("DungeonStage \230\137\190\228\184\141\229\136\176\230\149\176\230\141\174:", stageId)
    return
  end
  if stageTableItem["Stage Category"] == "Boss" then
    if result == "victory" or result == "defeat" or result == "timeout" then
      ListenTimer(Timer:Once(1.5), function()
        ed.ui.awakeDungeonEndWin.create({
          stageId = stageId,
          oldProgress = oldProgress,
          curProgress = curProgress,
          maxProgress = maxProgress,
          rewards = rewards,
          progressReward = fdRewards
        })
        ed.playEffect(ed.sound.battle.pushResultScene)
      end)
      ed.player:increaseDailyjobCount({
        type = "FarmDungeonStage",
        add = 1
      })
    elseif result == "canceled" then
      FireEvent("awakeDungeonBattleCanceled")
    end
  elseif stageTableItem["Stage Category"] == "Special" then
    if result == "victory" or result == "defeat" or result == "timeout" then
      local conditionTab = {}
      if ed.engine.battleConditionList then
        for id, cond in pairs(ed.engine.battleConditionList) do
          conditionTab[id] = cond:getResult()
        end
      end
      local param = {
        stageId = stageId,
        conditionTab = conditionTab,
        result = result
      }
      ListenTimer(Timer:Once(1.5), function()
        ed.ui.awakeDungeonSpecialEndWin.create(param)
      end)
      if result == "victory" then
        ed.playEffect(ed.sound.battle.win)
        ed.player:increaseDailyjobCount({
          type = "FarmDungeonStage",
          add = 1
        })
      else
        ed.playEffect(ed.sound.battle.lose)
      end
    elseif result == "canceled" then
      FireEvent("awakeDungeonBattleCanceled")
    end
  else
    local hero_list = {}
    for _, heroId in ipairs(self.battlePrepareInfo.team or {}) do
      local heroInfo = ed.getHeroInfo({}, heroId)
      table.insert(hero_list, heroInfo)
    end
    if result == "victory" then
      local param = {
        isAwakeStageMode = true,
        stage_id = stageId,
        heroes = hero_list,
        stageCsvName = "DungeonStage",
        fdRewards = fdRewards,
        rewards = rewards,
        playerInfo = ed.getPlayerInfo({
          exp = ed.player:getExp(),
          addExp = 0,
          maxExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()].Exp,
          level = ed.player:getLevel()
        })
      }
      ed.playEffect(ed.sound.battle.win)
      ListenTimer(Timer:Once(1.5), function()
        ed.ui.commonBattleWin.create(param)
      end)
      ed.player:increaseDailyjobCount({
        type = "FarmDungeonStage",
        add = 1
      })
    elseif result == "defeat" then
      ed.playEffect(ed.sound.battle.lose)
      local param = {
        stage_id = stageId,
        ChapterID = 666,
        stageCsvName = "DungeonStage",
        heroes = self.battlePrepareInfo.team or {},
        loseType = "fail"
      }
      ListenTimer(Timer:Once(1.5), function()
        ed.ui.commonBattleFail.create(param)
      end)
    elseif result == "timeout" then
      ed.playEffect(ed.sound.battle.lose)
      local param = {
        stage_id = stageId,
        ChapterID = 666,
        stageCsvName = "DungeonStage",
        heroes = self.battlePrepareInfo.team or {},
        loseType = "timeout"
      }
      ListenTimer(Timer:Once(1.5), function()
        ed.ui.commonBattleFail.create(param)
      end)
    elseif result == "canceled" then
      FireEvent("awakeDungeonBattleCanceled")
    end
  end
end

function class:handleSweep(data, times)
  local rewards = data._rewards or {}
  self.curVitality = data._left_vit or 0
  self.paragonLevel = data._paragon_level or 0
  self.paragonExp = data._paragon_exp or 0
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards, nil, function()
    FireEvent("awakeDungeonSweepComplete")
  end)
  ed.player:increaseDailyjobCount({
    type = "FarmDungeonStage",
    add = times or 1
  })
  self:updateVitalityRedPoint()
end

function class:handleBuyVitality(data)
  local curVitality = data._cur_vitality
  local buyTimes = data._buy_time
  self.curVitality = curVitality
  self.vitalityBuyTime = buyTimes
  self:updateVitalityRedPoint()
  ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
end

function class:handleLevelReward(data)
  local rewards = data._rewards or {}
  local levelRewardsFlags = data._level_rewards_flags
  self.levelRewardsFlags = levelRewardsFlags
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  self.redPointMgr:setNodeValue("awake_dungeon_reward_entry", self:canTakeLevelReward())
  FireEvent("awakeDungeonLevelReward")
end

function class:handleStageRecord(data)
  local stageId = data._stage_id
  if not data._user_summary then
    return
  end
  self.stageRecord[stageId] = {
    stageId = stageId,
    breakTime = data._break_time,
    userSummary = data._user_summary,
    heroes = data._heroes
  }
  FireEvent("awakeDungeonStageRecord", stageId)
end

function class:handleChapterRecord(data)
  FireEvent("awakeDungeonChapterRecord", data._chapter_record)
end

function class:handleBlockRewards(data)
  local rewards = data._rewards or {}
  ed.player:addRewards(rewards)
  if data._info then
    local coordinate = data._info._coordinate
    local progress = data._info._cur_progress or 0
    local x, y = self:convertXYFromServer(coordinate._x, coordinate._y)
    self:setCurStageProgress(x, y, progress)
    self:addCurStageChanged(x, y)
    if ed.awakeDungeonDefine.MAX_PROGRESS == progress then
      local chapterId = self:getCurrentChapterId()
      self:addChapterStageProgress(chapterId, x, y)
    end
  end
  ListenTimer(Timer:Once(1.3), function()
    ed.UITool.showRewardsFromServer(rewards, nil)
  end)
  FireEvent("dungeonBlockChanged")
end

function class:handleEnterChapter(data, chapterId)
  self.curChapterId = chapterId
  local curX, curY = self:convertXYFromServer(data._coordinate._x, data._coordinate._y)
  self:setCurPlayerCellXY(curX, curY, false)
  self.curStageProgressTab = {}
  self.curStageFirstRecordTab = {}
  for i, v in ipairs(data._stage_infos or {}) do
    local x, y = self:convertXYFromServer(v._coordinate._x, v._coordinate._y)
    self:setCurStageProgress(x, y, v._cur_progress)
  end
  local stageTable = ed.getDataTable("DungeonStage")
  for i, v in ipairs(data._stage_records or {}) do
    local x, y = self:convertXYFromServer(v._coordinate._x, v._coordinate._y)
    local stageTableItem = stageTable[v._stage_id]
    if stageTableItem and (stageTableItem["Stage Category"] ~= "Boss" or stageTableItem["Boss Difficulty"] == 4) then
      self:setCurStageFirstRecord(x, y, v)
    end
  end
  FireEvent("awakeDungeonEnterChapter")
end

function class:handleChapterReward(data, chapterId)
  if data._result == "success" then
    local rewards = data._rewards or {}
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(rewards)
    self.chapterRewardTab[chapterId] = true
    FireEvent("awakeDungeonChapterRewardComplete", chapterId)
  end
end

function class:handlePrepareBattle(data)
  FireEvent("awakeDungeonPrepareBattle", data)
end

function class:requestStageRecord(stageId, force)
  local stageRecord = self:getStageRecord(stageId)
  if force == nil then
    force = true
  end
  if not stageRecord or force then
    ed.AwakeDungeonNetwork.sendStageRecord(stageId)
  end
end

function class:getStageRecord(stageId)
  return self.stageRecord[stageId]
end

function class:checkParagonLevelInFlag(paragonLevel)
  if ed.isElementInTable(paragonLevel, self.levelRewardsFlags) then
    return true
  else
    return false
  end
end

function class:getLevelRewardState(level)
  local isComplete = self:checkParagonLevelInFlag(level)
  if isComplete then
    return ed.awakeDungeonDefine.LEVEL_REWARD_COMPLETED
  elseif level <= self:getParagonLevel() then
    return ed.awakeDungeonDefine.LEVEL_REWARD_AVAILABLE
  else
    return ed.awakeDungeonDefine.LEVEL_REWARD_UNCOMPLETED
  end
end

function class:getParagonLevel()
  return self.paragonLevel or 1
end

function class:getParagonExp()
  return self.paragonExp or 0
end

function class:getCurrentChapterId()
  return self.curChapterId
end

function class:isChapterStageDone(chapterId, x, y)
  local chapterTab = self.chapterDoneInfos[chapterId]
  if nil == chapterTab then
    return false
  end
  local yTab = chapterTab[x]
  if nil == yTab then
    return false
  end
  local value = yTab[y]
  if nil == value then
    return false
  end
  return true
end

function class:addChapterStageProgress(chapterId, x, y)
  local chapterTab = self.chapterDoneInfos[chapterId]
  if nil == chapterTab then
    chapterTab = {}
    self.chapterDoneInfos[chapterId] = chapterTab
  end
  local yTab = chapterTab[x]
  if nil == yTab then
    yTab = {}
    chapterTab[x] = yTab
  end
  yTab[y] = true
  self.chapterProgressTab[chapterId] = nil
end

function class:getChapterProgress(chapterId)
  local progressVal = self.chapterProgressTab[chapterId]
  if nil == progressVal then
    if nil == self.chapterDoneInfos[chapterId] then
      progressVal = 0
    else
      local chapterTableItem = ed.getDataTable("DungeonChapter")[self:getChapterGroup()][chapterId]
      if nil == chapterTableItem then
        error("\230\137\190\228\184\141\229\136\176\233\133\141\231\189\174\230\149\176\230\141\174:" .. self:getChapterGroup() .. "-" .. chapterId)
      end
      local buildingData = self:getMapBuildingConfig(chapterTableItem.Map)
      if nil == buildingData then
        error("\230\137\190\228\184\141\229\136\176\229\156\176\229\155\190\230\149\176\230\141\174:" .. chapterTableItem.Map)
      end
      local stageTable = ed.getDataTable("DungeonStage")
      local rewardTable = ed.getDataTable("DungeonTreasureReward")
      local configTable = ed.getDataTable("DungeonConfig")
      local curWeight = 0
      local totalWeight = 0
      for k, v in ipairs(buildingData.tiles) do
        local w = 0
        if v.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_MONSTER then
          local stageTableItem = stageTable[v.id]
          if nil == stageTableItem then
            error("DungeonStage \230\137\190\228\184\141\229\136\176\230\149\176\230\141\174" .. v.id)
          end
          if stageTableItem["Stage Category"] == "Normal" then
            w = configTable.NormalBattleWeight.Value[1]
          elseif stageTableItem["Stage Category"] == "Special" then
            w = configTable.SpecialBattleWeight.Value[1]
          elseif stageTableItem["Stage Category"] == "Boss" then
            w = configTable.BossBattleWeight.Value[1]
          end
        elseif v.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_REWARD then
          local rewardTableItem = rewardTable[v.id]
          if rewardTableItem["Treasure Type"] == "Small" then
            w = configTable.SmallTreasureWeight.Value[1]
          elseif rewardTableItem["Treasure Type"] == "Big" then
            w = configTable.BigTreasureWeight.Value[1]
          end
        elseif v.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_END then
          w = configTable.EndWeight.Value[1]
        end
        if self:isChapterStageDone(chapterId, v.x, v.y) then
          curWeight = curWeight + w
        end
        totalWeight = totalWeight + w
      end
      progressVal = math.floor(curWeight / totalWeight * 100 + 0.5)
    end
    self.chapterProgressTab[chapterId] = progressVal
  end
  return progressVal
end

function class:setChapterUnlock(chapterId)
  self.unlockChapterTab[chapterId] = true
end

function class:isChapterUnlock(chapterId)
  if nil == self.unlockChapterTab[chapterId] then
    return false
  else
    return true
  end
end

function class:isChapterRewardComplete(chapterId)
  if nil == self.chapterRewardTab[chapterId] then
    return false
  else
    return true
  end
end

function class:getCurPlayerCellXY()
  return self.curPlayerCellX, self.curPlayerCellY
end

function class:setCurPlayerCellXY(x, y, isSyncServer)
  if self.curPlayerCellX ~= x or self.curPlayerCellY ~= y then
    self.curPlayerCellX, self.curPlayerCellY = x, y
    if isSyncServer then
      ed.AwakeDungeonNetwork.sendEnterBlock(x, y)
    end
  end
end

function class:getCurStageProgress(x, y)
  local yTab = self.curStageProgressTab[x]
  if nil == yTab then
    return -1
  end
  return yTab[y] or -1
end

function class:setCurStageProgress(x, y, progress)
  local yTab = self.curStageProgressTab[x]
  if nil == yTab then
    yTab = {}
    self.curStageProgressTab[x] = yTab
  end
  yTab[y] = progress
end

function class:setCurStageFirstRecord(x, y, summary)
  local yTab = self.curStageFirstRecordTab[x]
  if nil == yTab then
    yTab = {}
    self.curStageFirstRecordTab[x] = yTab
  end
  yTab[y] = summary
end

function class:getCurStageFirstRecord(x, y)
  local yTab = self.curStageFirstRecordTab[x]
  if nil == yTab then
    return nil
  end
  return yTab[y]
end

function class:addCurStageChanged(x, y)
  table.insert(self.curStageChanged, {x, y})
end

function class:popCurStageChanged()
  if #self.curStageChanged > 0 then
    local arr = self.curStageChanged
    self.curStageChanged = {}
    return arr
  else
    return nil
  end
end

function class:getCurVitality()
  return self.curVitality or 0
end

function class:getMaxVitality()
  local levelGroup = self:getLevelGroup()
  local level = self:getParagonLevel()
  return ed.getDataTable("ParagonLevel")[levelGroup][level]["Max Vitality"]
end

function class:getVitalityUpdateTime()
  return self.vitalityUpdateTime or 0
end

function class:getVitalityBuyTimes()
  return self.vitalityBuyTime or 0
end

function class:getMaxChapterId()
  if not self.maxChapterId then
    self:initMaxChapterId()
  end
  return self.maxChapterId
end

function class:getChapterGroup()
  return ed.activityHints.data:getDungeonActivityInfo().chapterGroup or 1
end

function class:getLevelGroup()
  return ed.activityHints.data:getDungeonActivityInfo().levelGroup or 1
end

function class:getTimeInfo()
  local data = ed.activityHints.data:getDungeonActivityInfo()
  return data.startTime, data.endTime
end

function class:getRulesText()
  local data = ed.activityHints.data:getDungeonActivityInfo()
  return data.rules
end

function class:getDropsId()
  local data = ed.activityHints.data:getDungeonActivityInfo()
  return data.dropsId or 0
end

function class:getSweepRewardNum(...)
  return self.sweepRewardNum or 0
end

function class:getMaxParagonLevel()
  if not self.maxParagonLevel then
    self:initMaxLevel()
  end
  return self.maxParagonLevel or 0
end

function class:getMaxExp(level)
  local levelGroup = self:getLevelGroup()
  level = level + 1
  if level <= self:getMaxParagonLevel() then
    return ed.getDataTable("ParagonLevel")[levelGroup][level].Exp
  else
    return nil
  end
end

function class:switchStage(param)
  local stageId = param.stageId
  local stageCfg = ed.getDataTable("DungeonStage")[stageId]
  if not stageCfg then
    return
  end
  local bossGroup = stageCfg["Boss Group"]
  local bossStageDetail = ed.getPopWindow("awakeDungeonBossStageDetail")
  local stageDetail = ed.getPopWindow("awakeDungeonStageDetail")
  if bossGroup and 0 < bossGroup then
    if stageDetail then
      stageDetail:destroy({skipAnim = true})
    end
    if not bossStageDetail then
      ed.UITool.openView("awakeDungeonBossStageDetail", {bossGroup = bossGroup})
    else
      FireEvent("awakeDungeonBossGroup", bossGroup)
    end
  else
    if bossStageDetail then
      bossStageDetail:destroy({skipAnim = true})
    end
    if not stageDetail then
      ed.UITool.openView("awakeDungeonStageDetail", {stageId = stageId})
    else
      FireEvent("awakeDungeonSetStage", stageId)
    end
  end
end

function class:getNearStageId(curStageId)
  local preStageId, nextStageId
  local dungeonStageTB = ed.getDataTable("DungeonStage")
  local curChapterId = dungeonStageTB[curStageId]["Chapter ID"]
  local startStageId, endStageId = self:getStageIdRange()
  for stageId = curStageId - 1, startStageId, -1 do
    local stageCfg = dungeonStageTB[stageId]
    if not stageCfg then
      break
    end
    local stageState = self:getStageState(stageId)
    local chapterId = dungeonStageTB[stageId]["Chapter ID"]
    if curChapterId ~= chapterId then
      break
    end
    if stageCfg["Key Stage"] then
      preStageId = stageId
      break
    elseif not stageCfg["Key Stage"] and stageState == ed.awakeDungeonDefine.STAGE_STATE_CURRENT then
      preStageId = stageId
      break
    end
  end
  for stageId = curStageId + 1, endStageId do
    local stageCfg = dungeonStageTB[stageId]
    if not stageCfg then
      break
    end
    local chapterId = dungeonStageTB[stageId]["Chapter ID"]
    if curChapterId ~= chapterId then
      break
    end
    if self:checkStageCanClick(stageId) then
      nextStageId = stageId
      break
    end
  end
  return preStageId, nextStageId
end

function class:getNextBossRewardItem(rewardId, progressVal)
  local rewardTableItemGroup = ed.getDataTable("DungeonBossReward")[rewardId]
  local nextRewardTableItemArr = {}
  for hp, v in pairs(rewardTableItemGroup) do
    if progressVal < hp then
      table.insert(nextRewardTableItemArr, v)
    end
  end
  if 0 < #nextRewardTableItemArr then
    table.sort(nextRewardTableItemArr, function(a, b)
      return a["Reward HP"] < b["Reward HP"]
    end)
    return nextRewardTableItemArr[1]
  else
    return nil
  end
end

function class:canTakeLevelReward()
  for level = 1, self:getParagonLevel() do
    local rewardState = self:getLevelRewardState(level)
    if rewardState == ed.awakeDungeonDefine.LEVEL_REWARD_AVAILABLE then
      return true
    end
  end
  return false
end

function class:checkExpAndLevelChanged(exp, level)
  local oe, ol = self.oldParagonExp, self.oldParagonLevel
  self.oldParagonExp = self.paragonExp
  self.oldParagonLevel = self.paragonLevel
  return oe, ol, self.paragonExp, self.paragonLevel
end

function class:updateVitalityRedPoint()
  local curVitality = self:getCurVitality()
  local maxVitality = self:getMaxVitality()
  self.redPointMgr:setNodeValue("awake_dungeon_vitality_full", curVitality >= maxVitality)
  FireEvent("dungeonVitalityChanged")
end

function class:checkStageCanClick(stageId, bossGroup)
  local isCanClick = true
  if bossGroup and 0 < bossGroup then
    stageId = ed.getDataTable("DungeonBoss")[bossGroup][1]["Stage ID"]
  end
  if stageId then
    local stageCfg = ed.getDataTable("DungeonStage")[stageId]
    local stageState = self:getStageState(stageId)
    if not stageCfg["Key Stage"] then
      if stageState == ed.awakeDungeonDefine.STAGE_STATE_PASSED or stageState == ed.awakeDungeonDefine.STAGE_STATE_LOCKED then
        isCanClick = false
      end
    elseif stageState == ed.awakeDungeonDefine.STAGE_STATE_LOCKED then
      isCanClick = false
    end
  end
  return isCanClick
end

function class:getStageIdRange()
  local minChapter = 1
  local maxChapterId = self:getMaxChapterId()
  local chapterGroup = self:getChapterGroup()
  local startStageId = ed.getDataTable("DungeonChapter")[chapterGroup][minChapter]["Start Paragon Stage"]
  local endStageId = ed.getDataTable("DungeonChapter")[chapterGroup][maxChapterId]["End Paragon Stage"]
  return startStageId, endStageId
end

function class:getBuffInfoByChapterId(chapterId, chapterGroup)
  local startTime, endTime = self:getTimeInfo()
  local chapterGroup = chapterGroup or self:getChapterGroup()
  local buffGroupId = ed.getDataTable("DungeonChapter")[chapterGroup][chapterId]["Buff Group ID"]
  if not buffGroupId or buffGroupId == 0 then
    return
  end
  local stagebuffCfg = ed.getDataTable("DungeonStagebuff")[buffGroupId]
  local buffInfo, nextBuffInfo
  for index = 1, 20 do
    local duration = stagebuffCfg["Duration" .. index]
    local nextDuration = stagebuffCfg["Duration" .. index + 1]
    if not duration or duration <= 0 then
      break
    end
    local serverTime = ed.getServerTime()
    if startTime < serverTime and serverTime < startTime + duration * 3600 then
      buffInfo = {
        buffGroupId = buffGroupId,
        duration = duration,
        buffEndTime = math.min(endTime, startTime + duration * 3600),
        buffId = stagebuffCfg["Buff ID" .. index],
        targetCamp = stagebuffCfg["Target" .. index],
        desc = stagebuffCfg["Des" .. index],
        shortDesc = stagebuffCfg["ShortDes" .. index]
      }
      if nextDuration then
        nextBuffInfo = {
          buffGroupId = buffGroupId,
          duration = nextDuration,
          buffEndTime = math.min(endTime, startTime + nextDuration * 3600),
          buffId = stagebuffCfg["Buff ID" .. index + 1],
          targetCamp = stagebuffCfg["Target" .. index + 1],
          desc = stagebuffCfg["Des" .. index + 1],
          shortDesc = stagebuffCfg["ShortDes" .. index + 1]
        }
      end
      break
    end
  end
  return buffInfo, nextBuffInfo
end

function class:getBuffInfoByStageId(stageId)
  local stageCfg = ed.getDataTable("DungeonStage")[stageId]
  local chapterGroup = stageCfg["Chapter Group ID"]
  local chapterId = stageCfg["Chapter ID"]
  local buffInfo = self:getBuffInfoByChapterId(chapterId, chapterGroup)
  return buffInfo
end

function class:isCellGuideComplete(chapterId, x, y)
  local key = ed.getRoleKey(string.format("cell_guide_%d_%d_%d", chapterId, x, y))
  return ed.storage.getBool(key) or false
end

function class:setCellGuideComplete(chapterId, x, y)
  local key = ed.getRoleKey(string.format("cell_guide_%d_%d_%d", chapterId, x, y))
  ed.storage.setValue(key, true)
end

function class:getShowFirstSummary()
  if nil == self.isShowFirstSummary then
    local key = ed.getRoleKey("is_hide_first_summary")
    self.isShowFirstSummary = not ed.storage.getBool(key)
  end
  return self.isShowFirstSummary
end

function class:setShowFirstSummary(flag)
  self.isShowFirstSummary = flag
  local key = ed.getRoleKey("is_hide_first_summary")
  ed.storage.setValue(key, not flag)
end

function class:convertXYToServer(x, y)
  return x + 10000, y + 10000
end

function class:convertXYFromServer(x, y)
  return x - 10000, y - 10000
end

function class:getMapGroudConfig(mapName)
  mapName = string.lower(mapName)
  local groundData = require(string.format("ui_new.modules.awakeDungeonPVE.map.config.%s_ground_data", mapName))
  return groundData
end

function class:getMapBuildingConfig(mapName)
  mapName = string.lower(mapName)
  local buildingData = require(string.format("ui_new.modules.awakeDungeonPVE.map.config.%s_building_data", mapName))
  return buildingData
end

function class:getMapColliderConfig(mapName)
  mapName = string.lower(mapName)
  local colliderData = require(string.format("ui_new.modules.awakeDungeonPVE.map.config.%s_collider_data", mapName))
  return colliderData
end

function class:getMapConfig(mapName)
  return self:getMapGroudConfig(mapName), self:getMapBuildingConfig(mapName), self:getMapColliderConfig(mapName)
end

function class:addEventListener()
end
