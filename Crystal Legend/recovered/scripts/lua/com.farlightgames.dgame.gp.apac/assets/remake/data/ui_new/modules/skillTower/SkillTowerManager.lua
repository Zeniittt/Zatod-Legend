local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class:isTowerOpen(towerId)
  local ds = ed.playerlimit.getAreaUnlockPrompt("SkillTower")
  if ds then
    return false
  end
  return true
end

function class:getTowerDataFromServer()
  if self.hadDataFromServer == false then
    self.needOpenMainScene = false
    ed.SkillTowerNetwork:sendTowerOpenPanel()
  end
end

function class.isDebug()
  return false
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

function class:readFirstStageRewards(v)
  local list = {}
  for i = 1, 5 do
    local type = v["FDS Reward Type " .. i]
    local id = v["FDS Reward ID " .. i]
    local amount = v["FDS Reward Amount " .. i]
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

function class:initTowerStarNumRewards()
  local tb = ed.getDataTable("FancyTowerStarReward")
  local list = {}
  for k, v in ipairs(tb) do
    if type(v) == "table" then
      local item = {
        id = v.ID,
        needStars = v["Require Star Count"],
        rewards = self:readRewards(v),
        state = "unable"
      }
      table.insert(list, item)
    end
  end
  self.rewardList = list
end

function class:initTowerDatas()
  local tb = ed.getDataTable("FancyTowerNormal")
  local list = {}
  for key, value in pairs(tb) do
    if type(value) == "table" then
      local tower = {
        id = key,
        curfloor = 0,
        curStars = 0,
        stages = {}
      }
      for k, v in pairs(value) do
        if type(v) == "table" then
          local stage = {
            floorid = v.Floor,
            stageid = v["Fancy Tower Stage ID"],
            candle = v["Use Candle"],
            trigger1 = v["Star Collect Trigger Type 1"],
            triggerParam1 = v["Star Collect Trigger Target 1"],
            trigger2 = v["Star Collect Trigger Type 2"],
            triggerParam2 = v["Star Collect Trigger Target 2"],
            trigger3 = v["Star Collect Trigger Type 3"],
            triggerParam3 = v["Star Collect Trigger Target 3"],
            firstRewards = self:readFirstStageRewards(v),
            rewards = self:readRewards(v),
            unlockLevel = v["Unlock Player Level"],
            stars = 0,
            state = "unopen"
          }
          table.insert(tower.stages, stage)
        end
      end
      table.sort(tower.stages, function(v1, v2)
        return v1.floorid < v2.floorid
      end)
      tower.stages[1].state = "open"
      tower.maxFloor = #tower.stages
      tower.maxStars = #tower.stages * 3
      self.allStars = self.allStars + tower.maxStars
      table.insert(list, tower)
    end
  end
  table.sort(list, function(v1, v2)
    return v1.id < v2.id
  end)
  self.towerData = list
end

function class:initExTowerDatas()
  self.exTowerData = {}
  local tb = ed.getDataTable("FancyAbyssNormal")
  for key, value in pairs(tb) do
    if type(value) == "table" and key == self.curAbyssSeason then
      local startTime = 0
      local endTime = 0
      local tower = {
        season = key,
        passedFloors = 0,
        maxFloor = 0,
        stages = {},
        endTime = ed.getTimeByYMDHMS(endTime),
        startTime = ed.getTimeByYMDHMS(startTime),
        maxEnterTime = 50
      }
      for k, v in pairs(value) do
        if type(v) == "table" then
          local stage = {
            floorid = k,
            stageid = v["Stage ID"],
            firstRewards = self:readFirstStageRewards(v),
            unlockLevel = v["Unlock Player Level"],
            state = "unopen"
          }
          table.insert(tower.stages, stage)
        end
      end
      table.sort(tower.stages, function(v1, v2)
        return v1.floorid < v2.floorid
      end)
      tower.maxFloor = #tower.stages
      local firstStageId = tower.stages[1].stageid
      tower.buffId = ed.getDataTable("FancyAbyssBattle")[firstStageId][1]["Stage Skill ID"]
      self.exTowerData = tower
    end
  end
end

function class:initData()
  self.towerSceneInstance = nil
  self.power = 0
  self.maxPower = ed.getDataTable("FancyTowerConfiger").Candle_Recover_Limit.Value
  self.curStars = 0
  self.allStars = 0
  self.lastPowerTime = 0
  self.openTowerIds = {
    false,
    false,
    false,
    false,
    false,
    false
  }
  self.buyTimes = 0
  self.price = ed.getDataTable("FancyTowerConfiger").Candle_Price.Value
  self.hadDataFromServer = false
  self:initTowerDatas()
  self:initTowerStarNumRewards()
end

function class:handleTowerOpenPanelReply(data)
  self.hadDataFromServer = true
  if data._records then
    for k, v in ipairs(data._records) do
      local towerId = v._id
      local tower = self.towerData[towerId]
      self.towerData[towerId].curfloor = v._cur_floor or 0
      tower.curStars = v._tower_stars or 0
      local stages = tower.stages
      for id, stage in ipairs(v._stage or {}) do
        stages[stage._floor].stars = stage._stage_star or 0
        stages[stage._floor].state = "passed"
      end
      if stages[#v._stage + 1] then
        stages[#v._stage + 1].state = "open"
      end
    end
  end
  self.power = data._candle_count or 0
  self.lastPowerTime = data._candle_last_recover_time or ed.getServerTime()
  self.curStars = data._stars or 0
  self.buyTimes = data._daily_candle_max_buy_times - data._daily_candle_cur_buy_times
  for k, v in ipairs(self.rewardList) do
    if v.needStars <= self.curStars then
      v.state = "enable"
    end
    for key, ids in ipairs(data._star_ids or {}) do
      if ids == v.id then
        v.state = "rewarded"
      end
    end
  end
  self.redLight = false
  for k, v in ipairs(self.rewardList) do
    if v.state == "enable" then
      self.redLight = true
    end
  end
  for k, v in ipairs(data._open_towers or {}) do
    self.openTowerIds[v] = true
  end
  if data._fancy_abyss then
    self.curAbyssSeason = data._fancy_abyss._season_id
    self:initExTowerDatas()
    self.exTowerData.selfAbyssTime = data._fancy_abyss._personal_min_total_time
    if data._fancy_abyss._season_end_time then
      self.exTowerData.endTime = data._fancy_abyss._season_end_time
    end
    if data._fancy_abyss._season_start_time then
      self.exTowerData.startTime = data._fancy_abyss._season_start_time
    end
    if data._fancy_abyss._cur_floor_id then
      self.exTowerData.passedFloors = data._fancy_abyss._cur_floor_id
    end
  end
  if ed.player:isMonthCardValid("payed") then
    local add = ed.getDataTable("MonthCard").Payed["Candle Max Up"]
    self.maxPower = ed.getDataTable("FancyTowerConfiger").Candle_Recover_Limit.Value + add
  end
  if self.needOpenMainScene then
    ed.pushScene(ed.ui.SkillTowerScene.create())
  end
  FireEvent("SkillTowerOpenPanel")
end

function class:requestTowerStartBattle(battleFloorInfo, lineup)
  self.battleFloorInfo = battleFloorInfo
  local towerId = battleFloorInfo.towerId
  local floorId = battleFloorInfo.floorId
  ed.SkillTowerNetwork:sendTowerStartBattle(towerId, floorId, lineup)
end

function class:handleTowerStartBattleReply(data)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local rseed = data._rseed or 0
  local attack_team = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(attack_team.team) do
    local hero = ed.player:getHero(id)
    table.insert(hero_list, hero)
  end
  local battleFloorInfo = self.battleFloorInfo
  local stageId = battleFloorInfo.stageId
  local stage = ed.lookupDataTable("FancyTowerStage", nil, stageId)
  local battle = ed.lookupDataTable("FancyTowerBattle", nil, stageId, 1)
  ed.srand(rseed)
  ed.engine:enterFancyTower(stage, hero_list, nil, nil, nil, battleFloorInfo, nil)
  local extra_info = {}
  extra_info.SkillTowerInfo = {}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:requestTowerEndBattle(result, stars)
  self.curBattleStars = stars
  ed.SkillTowerNetwork:sendTowerEndBattle(result, ed.engine:getOprationList(), stars)
end

function class:handleTowerEndBattleReply(data)
  local checkId = data._checkid
  local battleResult = data._result
  local rewards = data._rewards or {}
  local firstRewards = data._first_rewards or {}
  if data._candle_count then
    self.power = data._candle_count
  end
  if battleResult == "unknown" and checkId and 0 < checkId and do_battle_log then
    ed.reportBattleLog(checkId, "fancyTower")
  end
  local isVictory = battleResult == "victory"
  if battleResult == "victory" then
    ed.playEffect(ed.sound.battle.win)
  elseif battleResult == "defeat" then
    ed.playEffect(ed.sound.battle.lose)
  end
  if battleResult == "unknown" then
    ed.popScene()
    ListenTimer(Timer:Once(1), function()
      ed.showToast(T("\230\136\152\230\150\151\231\187\147\230\158\156\229\135\186\233\148\153\239\188\140\232\175\183\233\135\141\230\150\176\229\176\157\232\175\149"))
    end)
    return
  end
  if battleResult == "canceled" then
    return
  end
  ed.player:addRewards(rewards)
  local loots = {}
  for _, v in ipairs(rewards) do
    local loot = {
      type = v._type,
      id = v._id,
      amount = v._amount
    }
    table.insert(loots, loot)
  end
  ed.player:addRewards(firstRewards)
  for _, v in ipairs(firstRewards) do
    local loot = {
      type = v._type,
      id = v._id,
      amount = v._amount,
      first = true
    }
    table.insert(loots, 1, loot)
  end
  local towerId = self.battleFloorInfo.towerId
  local floorId = self.battleFloorInfo.floorId
  local curTowerData = self.towerData[towerId]
  if 0 < #firstRewards then
    curTowerData.curfloor = floorId
    curTowerData.stages[floorId].state = "passed"
    if curTowerData.stages[floorId + 1] then
      curTowerData.stages[floorId + 1].state = "open"
    end
  end
  local curStageData = curTowerData.stages[floorId]
  if isVictory and self.curBattleStars > curTowerData.stages[floorId].stars then
    self.curStars = self.curStars + self.curBattleStars - curTowerData.stages[floorId].stars
    curTowerData.curStars = curTowerData.curStars + self.curBattleStars - curTowerData.stages[floorId].stars
    curTowerData.stages[floorId].stars = self.curBattleStars
    for k, v in ipairs(self.rewardList) do
      if v.needStars <= self.curStars and v.state == "unable" then
        v.state = "enable"
        self.redLight = true
      end
    end
  end
  ListenTimer(Timer:Once(1), function()
    if isVictory then
      ed.ui.SkillTowerBattleEndWin.create({
        towerId = towerId,
        floorId = floorId,
        curStageData = curStageData,
        rewards = loots,
        nextFloor = 0 < #firstRewards
      })
      ed.record:refreshCommonRecord("FarmFancyTowerStage", 1)
      ed.playEffect(ed.sound.battle.pushResultScene)
    else
      local stage = ed.lookupDataTable("FancyTowerStage", nil, curStageData.stageid)
      ed.ui.commonBattleFail.create({
        ChapterID = stage["Chapter ID"]
      })
    end
  end)
end

function class:handleTowerSweepReply(data)
  local rewards = data._rewards or {}
  ed.player:addRewards(rewards)
  self.power = data._candle_count
  ed.UITool.showRewardsFromServer(rewards)
  FireEvent("SkillTowerSweepReply", rewards)
  ed.record:refreshCommonRecord("FarmFancyTowerStage", 1)
end

function class:handleTowerStarRewardReply(data)
  if data._result == "success" then
    local rewards = data._rewards or {}
    ed.player:addRewards(rewards)
    self.rewardList[self.curGetStarRewardId].state = "rewarded"
    self.curGetStarRewardId = nil
    ed.UITool.showRewardsFromServer(rewards)
    self.redLight = false
    for k, v in ipairs(self.rewardList) do
      if v.state == "enable" then
        self.redLight = true
      end
    end
    FireEvent("SkillTowerStarRewardReply")
  end
end

function class:handleTowerErrorCode(data)
  if self.needOpenMainScene then
    ed.showToast(data)
  end
end

function class:handleTowerCandleBuyReply(data)
  if data._result == "success" then
    local num = data._candle_count - self.power
    self.power = data._candle_count
    self.buyTimes = data._daily_candle_buy_times
    ed.player:subrmb(num * self.price)
    ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
    FireEvent("SkillTowerCandleBuyReply")
  end
end

function class:isOpenExTower()
  return self.exTowerData and self.exTowerData.endTime > ed.getServerTime() and self.exTowerData.startTime <= ed.getServerTime()
end

function class:handleAbyssOpenPanelReply(data)
  local tower = self.exTowerData
  if not tower then
    return
  end
  for k, stage in ipairs(tower.stages) do
    for id, serverStage in ipairs(data._floor_infos or {}) do
      if serverStage._floor_id == stage.floorid then
        if serverStage._personal_min_pass_time and serverStage._personal_min_pass_time > 0 then
          stage.passTime = serverStage._personal_min_pass_time
          stage.state = "passed"
        end
        if serverStage._server_min_pass_info then
          stage.serverPassInfo = serverStage._server_min_pass_info
        end
      end
    end
  end
  if tower.passedFloors + 1 <= #tower.stages then
    tower.stages[tower.passedFloors + 1].state = "open"
  end
  tower.curEnterTime = data._remain_enter_floor_time or 0
  FireEvent("SkillExTowerOpenPanel")
end

function class:handleAbyssEnterStageReply(data)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local rseed = data._rseed or 0
  self.exTowerData.curEnterTime = data._remain_enter_floor_time
  local attack_team = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(attack_team.team) do
    local hero = ed.player:getHero(id)
    table.insert(hero_list, hero)
  end
  local buffId
  local battleFloorInfo = self.battleFloorInfo
  local stageId = battleFloorInfo.stageid
  local stage = ed.lookupDataTable("FancyAbyssStage", nil, stageId)
  local battle = ed.lookupDataTable("FancyAbyssBattle", nil, stageId, 1)
  ed.srand(rseed)
  ed.engine:enterFancyAbyss(stage, hero_list, false, {})
  local extra_info = {}
  extra_info.fancyAbyssInfo = {}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:handleAbyssExitStageReply(data)
  local checkId = data._checkid
  local battleResult = data._result
  local floorId = self.battleFloorInfo.floorid
  local curTowerData = self.exTowerData
  local curStageData = self.battleFloorInfo
  if battleResult == "victory" then
    local rewards = data._rewards or {}
    ed.playEffect(ed.sound.battle.win)
    if curStageData.state == "open" then
      curStageData.state = "passed"
      curTowerData.passedFloors = floorId
      if curTowerData.stages[floorId + 1] then
        curTowerData.stages[floorId + 1].state = "open"
      end
    end
    ed.player:addRewards(rewards)
    local loots = {}
    for _, v in ipairs(rewards) do
      local loot = {
        type = v._type,
        id = v._id,
        amount = v._amount
      }
      table.insert(loots, loot)
    end
    if data._server_min_pass_info then
      curStageData.serverPassInfo = data._server_min_pass_info
    end
    if data._personal_min_total_time then
      curTowerData.selfAbyssTime = data._personal_min_total_time
    end
    ListenTimer(Timer:Once(1), function()
      ed.ui.SkillTowerExBattleEndWin.create({
        curStageData = curStageData,
        rewards = loots,
        breakHistory = data._is_break_record == 1
      })
      ed.record:refreshCommonRecord("FarmFancyAbyssStage", 1)
      ed.playEffect(ed.sound.battle.pushResultScene)
    end)
  elseif battleResult == "defeat" or battleResult == "timeout" then
    ed.playEffect(ed.sound.battle.lose)
    local stage = ed.lookupDataTable("FancyAbyssStage", nil, curStageData.stageid)
    ed.ui.commonBattleFail.create({
      ChapterID = stage["Chapter ID"]
    })
    return
  elseif battleResult == "unknown" then
    if checkId and 0 < checkId and do_battle_log then
      ed.reportBattleLog(checkId, "fancyAbyss")
    end
    ed.popScene()
    ListenTimer(Timer:Once(1), function()
      ed.showToast(T("\230\136\152\230\150\151\231\187\147\230\158\156\229\135\186\233\148\153\239\188\140\232\175\183\233\135\141\230\150\176\229\176\157\232\175\149"))
    end)
    return
  elseif battleResult == "canceled" then
    return
  end
end

function class:handleAbyssRankReply(data)
  FireEvent("SkillTowerExRanklist", data)
end

function class:handleAbyssPassRecordsReply(data)
  FireEvent("SkillTowerExPassRecords", data)
end

ed.UITool.registViewOpenFunc("SkillTowerScene", function()
  local cpl = ed.playerlimit.getAreaUnlockPrompt("SkillTower")
  if cpl then
    ed.showToast(cpl)
    return
  end
  if ReloadModule then
    ReloadModule("ui_new/modules/skillTower/SkillTowerModuleList")
  end
  if ed.SkillTowerManager.isDebug() then
    ed.pushScene(ed.ui.SkillTowerScene.create())
  else
    ed.SkillTowerManager.needOpenMainScene = true
    ed.SkillTowerNetwork:sendTowerOpenPanel()
  end
end)
ed.UITool.registViewOpenFunc("equipstrengthen", function()
  ed.pushScene(ed.ui.equipstrengthen.create())
end)
ed.SkillTowerManager = class.getInstance()
return class
