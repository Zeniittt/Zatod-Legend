local CreviceDefendBattleManager = {}
CreviceDefendBattleManager.__index = CreviceDefendBattleManager

function CreviceDefendBattleManager.create()
  local self = {}
  setmetatable(self, CreviceDefendBattleManager)
  self:initData()
  self:registerEvents()
  return self
end

function CreviceDefendBattleManager:initData()
  self.curBattleIndex = 1
  self.forceQuitBattle = false
end

function CreviceDefendBattleManager:getChallengeData()
  local params = {
    _new_rank = self.rank,
    _last_rank = self.last_rank,
    _new_damage = self.new_damage,
    _last_damage = self.last_damage,
    _battle_replay = self.replay,
    _battle_summary = self.summary,
    _target_damage = self.target_damage,
    _target_rank = self.target_rank,
    _best_lineup_damage = self.best_lineup_damage
  }
  return params
end

function CreviceDefendBattleManager:registerEvents()
  ListenEvent("EventCreviceDefendPlayNextBattle", function(data, index)
    if index == 999 then
      FireEvent("EventCreviceDefendStageEnd")
      ed.ui.CreviceDefendBattleResultWin.create(self:getChallengeData())
      return
    end
    if self.curBattleIndex ~= #self.replay._records then
      self.curBattleIndex = self.curBattleIndex + 1
      self:enterNextBattle()
    else
      FireEvent("EventCreviceDefendStageEnd")
      ed.ui.CreviceDefendBattleResultWin.create(self:getChallengeData())
    end
  end)
  ListenEvent("EventCreviceDefendAnimationDone", function()
    self:enterBattle()
  end)
  ListenEvent("EventCreviceDefendStageForceEnd", function()
    self.forceQuitBattle = true
  end)
end

function CreviceDefendBattleManager:setSkipBattle(flag)
  self.isSkipBattle = flag
  ed.storage.setValue("CreviceDefend_SKIP_BATTLE", self.isSkipBattle)
end

function CreviceDefendBattleManager:getSkipBattle()
  if nil == self.isSkipBattle then
    self.isSkipBattle = ed.storage.getBool("CreviceDefend_SKIP_BATTLE")
  end
  return self.isSkipBattle
end

function CreviceDefendBattleManager:handleChallenge(msg)
  FireEvent("EventCreviceDefendJumpBattle", msg)
  ed.CreviceDefendBattleManager:initData()
  self.replay = msg._battle_replay
  self.summary = msg._battle_summary
  self.rank = msg._new_rank
  self.last_rank = msg._last_rank
  self.new_damage = msg._new_damage
  self.last_damage = msg._last_damage
  self.target_damage = msg._target_damage
  self.target_rank = msg._target_rank
  self.best_lineup_damage = msg._best_lineup_damage
  ed.CreviceDefendManager:updateRemainCount()
  FireEvent("UpdateCreviceDefendChallengeCount")
  FireEvent("EventCreviceDefendHandleChallenge")
  if not self.isSkipBattle then
    local records = msg._battle_replay._records
    for k, record in ipairs(records) do
      for k, v in ipairs(record._self_heroes._heroes) do
        ed.asyncload.preloadFcaByUnitID(v._tid)
      end
    end
    ed.asyncload.registLoadingListener(function()
      FireEvent("EventCreviceDefendPreLoadDone")
    end)
  else
    FireEvent("EventCreviceDefendHandleSkipChallenge", msg)
  end
end

function CreviceDefendBattleManager:enterBattle()
  self:enterReplay(self.replay._records[self.curBattleIndex], self.curBattleIndex, true, true)
end

function CreviceDefendBattleManager:enterNextBattle()
  self:enterReplay(self.replay._records[self.curBattleIndex], self.curBattleIndex, true, true)
end

function CreviceDefendBattleManager:enterReplay(replayData, roundId, isNormalBattle, isAudition)
  local selfHeros = replayData._self_heroes._heroes
  if not selfHeros then
    ed.showToast(T("\229\183\177\230\150\185\232\139\177\233\155\132\230\149\176\230\141\174\229\188\130\229\184\184"))
    return
  end
  local mode = "crevicedefend"
  local format_data = ed.copyProto(replayData)
  format_data._self_heroes = selfHeros
  local stageid = replayData._stage_id
  ed.ui.vcdLayer.setData(format_data, "crevicedefend", stageid)
  local stage = ed.lookupDataTable("Stage", nil, -13)
  local battle = ed.lookupDataTable("CreviceDefendBattle", nil, stageid, 1)
  ed.srand(replayData._rseed)
  local params = {
    mode = mode,
    stageid = stageid,
    battleBonus = replayData._self_bonus,
    replayMode = not isNormalBattle
  }
  ed.asyncload.unregistLoadingListener()
  ed.engine:enterCreviceDefend(stage, selfHeros, params)
  if not isNormalBattle then
    ed.engine.replayMode = true
    ed.scene:reset(stage, battle, {
      replayInfo = {
        dreamlandReplay = true,
        checkid = replayData._checkid
      }
    })
  else
    ed.scene:reset(stage, battle, {
      creviceDefendInfo = {}
    })
  end
  ed.pushScene(ed.scene)
end

function CreviceDefendBattleManager:showReply(data, stageid)
  local stageid = stageid
  ed.ui.vcdLayer.setData(data, "crevicedefend", stageid)
  ed.srand(data._rseed)
  local stage = ed.lookupDataTable("Stage", nil, -13)
  local battle = ed.lookupDataTable("CreviceDefendBattle", nil, stageid, 1)
  local heroList = {}
  for k, v in ipairs(data._self_heroes) do
    local hero = ed.HeroCreate()
    hero:setup(v)
    table.insert(heroList, hero)
  end
  local params = {
    mode = "crevicedefend",
    stageid = stageid,
    replayMode = true
  }
  ed.engine:enterCreviceDefend(stage, data._self_heroes, params)
  ed.engine.replayMode = true
  ed.scene:reset(stage, battle, {
    replayInfo = {
      dreamlandReplay = true,
      checkid = data._checkid
    }
  })
  ed.pushScene(ed.scene)
end

ed.CreviceDefendBattleManager = CreviceDefendBattleManager.create()
