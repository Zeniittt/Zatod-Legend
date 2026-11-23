local class = {}
ed.actiAdventureMgr = class
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
  self.currentActId = nil
  self.allAdventureData = {}
  self.battlePrepareActId = 0
  self.battlePrepareStageId = 0
  self.battle_prepare_info = {}
  self.stageOpenTime = {}
  self.actTimeInfo = {}
  self.addition = 0
  self.actAdventureStageTb = ed.getDataTable("ActivityAdventureStage")
  self.actAdventureTb = ed.getDataTable("ActivityAdventure")
  self.actAdventureBonusTb = ed.getDataTable("ActivityAdventureBonus")
  self.actAdventureLineRewardTb = ed.getDataTable("ActivityAdventureLineReward")
  self.showRedLight = false
  self.lastOpenTime = nil
  self.redPointMgr = ed.redPointMgr.getInstance()
  self:registerRedPoint()
end

function class:getOpenActId()
  return self.currentActId or 0
end

function class:handleOpenPanel(_open_panel)
  self:setAllAdventureInfo(_open_panel._single_infos)
end

function class:handleEnterStage(_enter_stage)
  self:enterStage(_enter_stage._rseed)
end

function class:handleExitStage(_exit_stage)
  local _result = _exit_stage._result
  local _is_retry = _exit_stage._is_retry
  local _checkid = _exit_stage._checkid
  local _coin_amount = _exit_stage._coin_amount
  local _rewards = _exit_stage._rewards or {}
  local _act_id = _exit_stage._act_id
  if _result == "unknown" and _checkid and 0 < _checkid and do_battle_log then
    ed.reportBattleLog(_checkid, "activityAdventure")
  end
  if _result == "unknown" then
    ed.popScene()
    ListenTimer(Timer:Once(1), function()
      ed.showToast(T("\230\136\152\230\150\151\231\187\147\230\158\156\229\135\186\233\148\153\239\188\140\232\175\183\233\135\141\230\150\176\229\176\157\232\175\149"))
    end)
    return
  end
  if _result == "canceled" then
    return
  end
  self:addAdventureToken(_act_id, _coin_amount)
  if _result == "victory" then
    ed.player:addRewards(_rewards or {})
    ed.playEffect(ed.sound.battle.win)
    local heroList = {}
    for _, heroId in ipairs(self.battle_prepare_info.team or {}) do
      local heroInfo = ed.getHeroInfo({}, heroId)
      table.insert(heroList, heroInfo)
    end
    if _coin_amount then
      table.insert(_rewards, {
        _type = "adventurePoint",
        _amount = _coin_amount
      })
    end
    local param = {
      noExp = true,
      stage_id = self.battlePrepareStageId,
      heroes = heroList,
      stageCsvName = "ActivityAdventureStage",
      rewards = _rewards,
      itemAdditionList = {
        {
          id = nil,
          type = "adventurePoint",
          addition = self:getBattleAddition()
        }
      },
      playerInfo = ed.getPlayerInfo({
        exp = ed.player:getExp(),
        addExp = 0,
        maxExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()].Exp,
        level = ed.player:getLevel()
      })
    }
    ListenTimer(Timer:Once(2), function()
      ed.playEffect(ed.sound.battle.pushResultScene)
      ed.ui.commonBattleWin.create(param)
    end)
  elseif _result == "defeat" then
    ed.playEffect(ed.sound.battle.lose)
    local param = {
      stage_id = self.battlePrepareStageId,
      stageCsvName = "ActivityAdventureStage",
      heroes = self.battle_prepare_info.team or {},
      loseType = "fail"
    }
    ListenTimer(Timer:Once(2), function()
      ed.ui.commonBattleFail.create(param)
    end)
  elseif _result == "timeout" then
    ed.playEffect(ed.sound.battle.lose)
    local param = {
      stage_id = self.battlePrepareStageId,
      stageCsvName = "ActivityAdventureStage",
      heroes = self.battle_prepare_info.team or {},
      loseType = "timeout"
    }
    ListenTimer(Timer:Once(2), function()
      ed.ui.commonBattleFail.create(param)
    end)
  end
end

function class:handleGetRewards(_get_rewards)
  local _rewards = _get_rewards._rewards
  ed.player:addRewards(_rewards or {})
  ed.UITool.showRewardsFromServer(_rewards)
end

function class:handleSweep(_sweep)
  local _act_id = _sweep._act_id
  local _token_amount = _sweep._token_amount
  self:addAdventureToken(_act_id, _token_amount)
  local rewards = {
    {
      _type = "adventurePoint",
      _amount = _token_amount
    }
  }
  ed.UITool.showRewardsFromServer(rewards)
end

function class:handleBuyVitality(_buy_vitality)
  local actId = _buy_vitality._act_id
  local cur_vitality = _buy_vitality._cur_vitality
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  local oldVitality = actiAdventureMgr:getAdventureVitality(actId)
  actiAdventureMgr:setAdventureVitality(actId, cur_vitality)
  local actAdventureCfg = ed.getDataTable("ActivityAdventure")[actId]
  local vitalityIncrease = actAdventureCfg["Vitality Increase"]
  local buyAmount = math.floor((cur_vitality - oldVitality) / vitalityIncrease)
  local price = actAdventureCfg["Vitality Price"]
  ed.player:subrmb(buyAmount * price)
  ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
end

function class:getStageState(actId, stageId)
  local stageCfgData = self.actAdventureStageTb[stageId]
  if not stageCfgData then
    return ed.adventureDefine.STAGE_STATE_LOCKED
  end
  local stageInfo = self:getStageInfoById(actId, stageId)
  local lastStageId = stageCfgData["Last Stage"]
  local lastStageInfo = self:getStageInfoById(actId, lastStageId)
  local openTime = self:getStageOpenTime(actId, stageId)
  local startTime, endTime = self:getAdventureTime(actId)
  local stageState
  if openTime > ed.getServerTime() then
    stageState = ed.adventureDefine.STAGE_STATE_TIME_LOCKED
  elseif endTime < ed.getServerTime() then
    stageState = ed.adventureDefine.STAGE_STATE_ENDING
  elseif (lastStageId == 0 or lastStageInfo) and not stageInfo then
    stageState = ed.adventureDefine.STAGE_STATE_CURRENT
  elseif (lastStageId == 0 or lastStageInfo) and stageInfo then
    stageState = ed.adventureDefine.STAGE_STATE_PASSED
  else
    stageState = ed.adventureDefine.STAGE_STATE_LOCKED
  end
  return stageState
end

function class:getAllBonusHeroInfo(actId)
  local actAdventureCfg = self.actAdventureTb[actId]
  local bonusGroupId = actAdventureCfg["Bonus Group ID"]
  return self.actAdventureBonusTb[bonusGroupId] or {}
end

function class:getHeroAddition(actId, heroId)
  local allHeroAddition = self:getAllBonusHeroInfo(actId)
  if allHeroAddition[heroId] then
    return allHeroAddition[heroId].BonusValue1
  end
  return 0
end

function class:setAllAdventureInfo(adventureInfos)
  for index, adventureInfo in ipairs(adventureInfos or {}) do
    local actId = adventureInfo._act_id
    local adventureData = {
      actId = actId,
      actVitality = adventureInfo._act_vitality,
      tokenAmount = adventureInfo._token_amount,
      vitalityUpdateTime = adventureInfo._vitality_update_time,
      vitalityBuy = adventureInfo._vitality_buy,
      stageInfos = adventureInfo._stage_infos,
      rewardsInfos = adventureInfo._rewards_infos,
      challengeLevel = adventureInfo._challenge_level
    }
    self.allAdventureData[actId] = adventureData
    FireEvent("refreshAdventureInfo", actId)
  end
  self.redPointMgr:setNodeValue("adventure_notify", 0)
  self.redPointMgr:setNodeValue("adventure_vitality_full", self:checkVitalityFull(self.currentActId))
  self.redPointMgr:setNodeValue("adventure_new_stage", self:checkNewStageOpen(self.currentActId))
  self.redPointMgr:setNodeValue("adventure_reward_entry", self:getRewardRedPointShow(self.currentActId))
end

function class:getAdventureData(actId)
  return self.allAdventureData[actId]
end

function class:setBattlePrepareInfo(actId, stageId, addition, battle_prepare_info)
  self.battlePrepareActId = actId
  self.battlePrepareStageId = stageId
  self.addition = addition
  self.battle_prepare_info = battle_prepare_info
  ed.actiAdventureNet.enterStage(actId, stageId, battle_prepare_info.team)
end

function class:enterStage(rseed)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local attack_team = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(attack_team.team) do
    local hero = ed.player:getHero(id)
    table.insert(hero_list, hero)
  end
  local stageId = self.battlePrepareStageId
  local stageInfo = ed.lookupDataTable("ActivityAdventureStage", nil, stageId)
  local battle = ed.lookupDataTable("ActivityAdventureBattle", nil, stageId, 1)
  ed.srand(rseed)
  local minDay = self.actAdventureTb[self.currentActId]["Min day"]
  local maxDay = self.actAdventureTb[self.currentActId]["Max day"]
  ed.engine:enterActivityAdventure(stageInfo, hero_list, nil, nil, nil, nil, {
    difficultyRatio = self:getDifficultyRatio(self.currentActId)
  })
  local extra_info = {}
  extra_info.activityAdventureInfo = {}
  ed.scene:reset(stageInfo, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:getDifficultyRatio(actId)
  local challengeLevel = self:getChallengeLevel(actId)
  local minDay = self.actAdventureTb[actId]["Min day"]
  local maxDay = self.actAdventureTb[actId]["Max day"]
  challengeLevel = math.max(challengeLevel, minDay)
  challengeLevel = math.min(challengeLevel, maxDay)
  local k = (challengeLevel - minDay) / (maxDay - minDay)
  return k
end

function class:getAdventureVitality(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.actVitality
  end
  return 0
end

function class:setAdventureVitality(actId, vitalityAmount)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    adventureData.actVitality = vitalityAmount
  end
  FireEvent("ResourceNumChange", "adventureVitality")
end

function class:getAdventureToken(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.tokenAmount
  end
  return 0
end

function class:addAdventureToken(actId, addAmount)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    adventureData.tokenAmount = adventureData.tokenAmount + addAmount
  end
  FireEvent("ResourceNumChange", "adventurePoint")
end

function class:getAllStageInfo(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.stageInfos
  end
  return nil
end

function class:getStageInfoById(actId, stageId)
  local stageInfos = self:getAllStageInfo(actId)
  for _, stageInfo in ipairs(stageInfos or {}) do
    if stageInfo._stage_id == stageId then
      return stageInfo
    end
  end
  return nil
end

function class:getVitalityBuyTimes(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.vitalityBuy
  end
  return 0
end

function class:getRewardInfo(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.rewardsInfos
  end
  return nil
end

function class:getRedLight()
  if self.showRedLight then
    return true
  end
  local actId = self:getOpenActId()
  if self:getRewardRedPointShow(actId) then
    return true
  end
  if self:checkNewStageOpen(actId) then
    return true
  end
  local startTime, endTime = self:getAdventureTime(actId)
  if self:getAdventureVitality(actId) >= ed.adventureDefine.VITALITY_UPPER_LIMIT and endTime >= ed.getServerTime() and self:getRewardRedPointShow(actId, ed.adventureDefine.TASK_UNCOMPLETE) then
    return true
  end
  return false
end

function class:registerRedPoint()
  self.redPointMgr:registerValueChange("adventure_entry", self, {
    handle = function(value)
      FireEvent("RefreshRightTopButtons")
    end
  })
end

function class:getVitalityUpdateTime(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.vitalityUpdateTime
  end
  return nil
end

function class:getRewardRedPointShow(actId, checkType)
  if actId == 0 then
    return false
  end
  if not self.actAdventureTb[actId] then
    return false
  end
  checkType = checkType or ed.adventureDefine.TASK_AVAILABLE
  local medalRewardGroupId = self.actAdventureTb[actId]["Medal Reward Group ID"]
  local progressData = self.actAdventureLineRewardTb[medalRewardGroupId]
  for progressId, rewardDataCfg in pairs(progressData or {}) do
    local rewardState = self:getRewardState(actId, progressId)
    if rewardState == checkType then
      return true
    end
  end
  return false
end

function class:getBattleAddition()
  return self.addition
end

function class:getRewardState(actId, progressId)
  local medalRewardGroupId = self.actAdventureTb[actId]["Medal Reward Group ID"]
  local rewardDataCfg = self.actAdventureLineRewardTb[medalRewardGroupId][progressId]
  local rewardIdList = self:getRewardInfo(actId)
  local tokenAmount = self:getAdventureToken(actId)
  local rewardBuyTimes = 0
  local requireMedalCount = rewardDataCfg["Require Token Count"]
  local rewardState
  for index, rewardId in ipairs(rewardIdList or {}) do
    if rewardId == progressId then
      rewardBuyTimes = 1
      break
    end
  end
  if 0 < rewardBuyTimes then
    rewardState = ed.adventureDefine.TASK_COMPLETE
  elseif tokenAmount >= requireMedalCount then
    rewardState = ed.adventureDefine.TASK_AVAILABLE
  else
    rewardState = ed.adventureDefine.TASK_UNCOMPLETE
  end
  return rewardState
end

function class:checkAdventurenOpen(actId)
  local startTime, endTime = self:getAdventureTime(actId)
  local rewardEndTime = self:getAdventureRewardEndTime(actId)
  local reason = ""
  if not startTime then
    reason = T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159")
    return false, reason
  end
  if startTime > ed.getServerTime() then
    reason = T("\230\180\187\229\138\168\230\156\170\229\188\128\229\144\175")
    return false, reason
  end
  if rewardEndTime < ed.getServerTime() then
    reason = T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159")
    return false, reason
  end
  local level = ed.player:getLevel() or 0
  if level < 35 then
    reason = T("\231\173\137\231\186\167\232\190\190\229\136\17635\231\186\167\232\167\163\233\148\129")
    return false, reason
  end
  return true, reason
end

function class:initCheckStageOpenTimer()
  local actId = self:getOpenActId()
  if actId == 0 then
    return
  end
  local rewardEndTime = self:getAdventureRewardEndTime(actId)
  if rewardEndTime < ed.getServerTime() then
    return
  end
  ListenTimer(Timer:Always(10), function()
    if self:checkNewStageOpen(actId) then
      self.redPointMgr:setNodeValue("adventure_new_stage", 1)
    else
      self.redPointMgr:setNodeValue("adventure_new_stage", 0)
    end
  end)
end

function class:checkNewStageOpen(actId)
  if not self:checkAdventurenOpen(actId) then
    return false
  end
  if not self.lastOpenTime then
    local lastOpenTime = ed.storage.getInt(ed.adventureDefine.LAST_OPEN_TIME_KEY)
    self.lastOpenTime = lastOpenTime
  end
  local currentTime = ed.getServerTime()
  if not self.actAdventureTb[actId] then
    return false
  end
  local stageGroup = self.actAdventureTb[actId]["Stage Group"]
  if not stageGroup then
    return false
  end
  for stageId = stageGroup + 1, stageGroup + 100 do
    local stageCfgData = self.actAdventureStageTb[stageId]
    if not stageCfgData then
      break
    end
    local openTimeStr = stageCfgData["Open Time"]
    local openTime = ed.dateStringToTime(openTimeStr)
    if currentTime > openTime and openTime > self.lastOpenTime then
      return true
    end
  end
  return false
end

function class:checkVitalityFull(actId)
  local startTime, endTime = self:getAdventureTime(actId)
  if self:getAdventureVitality(actId) >= ed.adventureDefine.VITALITY_UPPER_LIMIT and endTime >= ed.getServerTime() and self:getRewardRedPointShow(actId, ed.adventureDefine.TASK_UNCOMPLETE) then
    return true
  end
  return false
end

function class:setLastOpenTime()
  local time = ed.getServerTime()
  self.lastOpenTime = time
  ed.storage.setValue(ed.adventureDefine.LAST_OPEN_TIME_KEY, time)
end

function class:setAdventureNotify(actAdventureNotify)
  self.stageOpenTime = {}
  self.actTimeInfo = {}
  local hasReward = actAdventureNotify._has_reward or 0
  for index, actInfo in ipairs(actAdventureNotify._act_info or {}) do
    if actInfo then
      local actId = actInfo._act_id
      self.currentActId = actId
      local stageInfo = {}
      for _, adventureNotifyStage in ipairs(actInfo._stage_info or {}) do
        local stageId = adventureNotifyStage._stage_id
        local openTime = adventureNotifyStage._open_time
        stageInfo[stageId] = openTime
      end
      self.stageOpenTime[actId] = stageInfo
      self.actTimeInfo[actId] = {
        startTime = actInfo._start_time,
        endTime = actInfo._end_time,
        medalEndTime = actInfo._medal_end_time
      }
    end
  end
  self.redPointMgr:setNodeValue("adventure_notify", 0 < hasReward)
  self:initCheckStageOpenTimer()
end

function class:getStageOpenTime(actId, stageId)
  local stageInfo = self.stageOpenTime[actId]
  if stageInfo then
    return stageInfo[stageId] or 0
  end
  return 0
end

function class:getActTimeInfo(actId)
  return self.actTimeInfo[actId]
end

function class:getAdventureRewardEndTime(actId)
  local actTimeInfo = self:getActTimeInfo(actId)
  if not actTimeInfo then
    return 0
  end
  return actTimeInfo.medalEndTime
end

function class:getAdventureTime(actId)
  local actTimeInfo = self:getActTimeInfo(actId)
  if not actTimeInfo then
    return 0, 0
  end
  return actTimeInfo.startTime, actTimeInfo.endTime
end

function class:getChallengeLevel(actId)
  local adventureData = self:getAdventureData(actId)
  if adventureData then
    return adventureData.challengeLevel
  end
  return 0
end
