local CrusadeManager = {}
CrusadeManager.__index = CrusadeManager

function CrusadeManager.getInstance()
  if not CrusadeManager.instance then
    CrusadeManager.instance = CrusadeManager.create()
  end
  return CrusadeManager.instance
end

ed.CrusadeEventNames = {
  QueryOppo = "QueryOppoReply",
  BattleEnd = "BattleEndReply",
  GetReward = "GetRewardReply",
  GetRushReward = "GetRushRewardReply",
  BattleRecord = "BattleRecordReply",
  QueryReplay = "QueryReplayReply",
  QueryBattleData = "QueryBattleDataReply",
  Reset = "ResetReply",
  GetWeeklyReward = "GetWeeklyReward"
}

function CrusadeManager.create()
  local self = {}
  setmetatable(self, CrusadeManager)
  self:initData()
  return self
end

function CrusadeManager:initData()
  self.curStageIndex = 1
  self.sumOfCrusadeStage = 15
  self.reliveItemId = 2548
  self.battleState = {}
  self.battleReward = {}
  self.weeklyRewardInfo = {}
  for i = 1, self.sumOfCrusadeStage do
    self.battleState[i] = false
  end
  self.LocalObjData = {}
end

function CrusadeManager:initCrusadeData(data)
  local info = data._info
  self.curStageIndex = info._cur_stage
  if self.curStageIndex == 0 then
    self.curStageIndex = self.sumOfCrusadeStage + 1
  end
  for i = 1, self.sumOfCrusadeStage do
    self.battleState[i] = info._stages[i]._status
    self.battleReward[i] = info._stages[i]._rewards
  end
  for i, v in pairs(info._heroes) do
    ed.player:setHeroCrusadeData(v)
  end
  ed.player:setEnergyBeanNum(info._energy_bean or 0)
  self.leftTime = 1 - info._reset_times
  self.weeklyRewardInfo = data._weekly_reward_info
  ed.GuildManager:setCrusadeMercenary(info._hire_hero)
  self.historyBestStage = info._history_best_stage or 0
  self.rushHeros = data._heroes or {}
end

function CrusadeManager:handleTbcRush(data)
  self.rushTimes = true
end

function CrusadeManager:handleOpenPanel(data)
  self:initCrusadeData(data)
  ed.pushScene(ed.ui.CrusadeMainScene.create(data))
end

function CrusadeManager:handleResetCrusade(data)
  self:initCrusadeData(data)
  FireEvent(ed.CrusadeEventNames.Reset, data)
end

function CrusadeManager:handleQueryOppo(data)
  FireEvent(ed.CrusadeEventNames.QueryOppo, data)
end

function CrusadeManager:handleBattleStart(data)
  if ed.netreply.gotoCrusadeBattleReply then
    ed.srand(data._rseed)
    local crusadeActivityId = data._self_bonus._buff_id
    ed.netreply.gotoCrusadeBattleReply(self.enemyHeros, self.enemyRobot, nil, self.crusadeData, nil, nil, nil, data._energy_bean, data._oppo_bonus, nil, crusadeActivityId)
    ed.netreply.gotoCrusadeBattleReply = nil
  end
end

function CrusadeManager:handleBattleEnd(data)
  if "victory" == data._result or "timeout" == data._result then
    ed.record:refreshCommonRecord("completeCrusadeStage")
    self.battleState[self.curStageIndex] = "passed"
    if self.curStageIndex < self.sumOfCrusadeStage then
      self.curStageIndex = self.curStageIndex + 1
    end
    self.weeklyRewardInfo = data._weekly_reward
  end
  if ed.netreply.exitStageReply then
    ed.netreply.exitStageReply(data._result)
    ed.netreply.exitStageReply = nil
  end
  if self.scene then
    self.scene.needRefresh = true
  end
end

function CrusadeManager:handleGetReward(data)
  if data._result == "success" then
    self.battleState[data._stage_id] = "rewarded"
    local reward = data._rewards or {}
    if data._beans > 0 then
      ed.player:setEnergyBeanNum(ed.player:getEnergyBeanNum() + data._beans)
      table.insert(reward, {
        _type = "energybean",
        _amount = data._beans
      })
    end
    ed.player:addRewards(reward)
    ed.UITool.showRewardsFromServer(reward)
  end
  FireEvent(ed.CrusadeEventNames.GetReward, data)
end

function CrusadeManager:handleBattleRecord(data)
  FireEvent(ed.CrusadeEventNames.BattleRecord, data)
end

function CrusadeManager:handleQueryReplay(data)
  FireEvent(ed.CrusadeEventNames.QueryReplay, data)
end

function CrusadeManager:handleQuerySummary(data)
  FireEvent(ed.CrusadeEventNames.QueryBattleData, data)
end

function CrusadeManager:handleReliveHero(data)
  if data == "success" then
    ed.player:consumeEquip(self.reliveItemId, 1)
    FireEvent("refreshHeroHpMp")
  end
end

function CrusadeManager:handleGetWeeklyReward(data)
  local reward = data._rewards or {}
  self.weeklyRewardInfo = data._weekly_reward_info
  ed.player:addRewards(reward)
  ed.UITool.showRewardsFromServer(reward)
  FireEvent(ed.CrusadeEventNames.GetWeeklyReward)
end

local maxBattleMax = 15

function CrusadeManager:canRush(hint)
  local currentStage = ed.CrusadeManager.curStageIndex
  local rushTimes = ed.CrusadeManager.rushTimes
  local historyBestStage = ed.CrusadeManager.historyBestStage
  local breakStr
  for _ = 1, 1 do
    if ed.player:getLevel() < 65 then
      breakStr = T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17665\231\186\167\229\188\128\230\148\190")
      break
    end
    if historyBestStage < maxBattleMax then
      breakStr = T("\229\176\154\230\156\170\233\128\154\229\133\179\232\191\135\230\153\174\233\128\154\232\191\156\229\190\129")
      break
    end
    if rushTimes then
      breakStr = T("\230\156\172\230\172\161\232\191\156\229\190\129\229\183\178\230\180\190\233\129\163\232\191\135\229\133\136\233\129\163\233\152\159")
      break
    end
    if currentStage ~= 1 then
      breakStr = T("\229\183\178\233\148\153\232\191\135\230\180\190\233\129\163\230\151\182\230\156\186")
      break
    end
    for _, hero in pairs(ed.player.heroes) do
      if hero:hp_perc("crusade") ~= 10000 then
        breakStr = T("\229\183\178\233\148\153\232\191\135\230\180\190\233\129\163\230\151\182\230\156\186")
        break
      end
    end
  end
  if breakStr and hint then
    ed.showToast(breakStr)
    return false
  elseif breakStr then
    return false
  else
    return true
  end
end

ed.CrusadeManager = CrusadeManager.getInstance()
