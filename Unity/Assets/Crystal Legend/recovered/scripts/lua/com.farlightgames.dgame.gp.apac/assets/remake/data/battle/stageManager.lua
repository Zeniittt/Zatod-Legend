local StageManager = {}
StageManager.__index = StageManager
ed.battle = {}
ed.battle.stageManager = StageManager

function StageManager.create(battleInfo)
  local self = {}
  setmetatable(self, StageManager)
  self:initData(battleInfo)
  return self
end

function StageManager:initData(battleInfo)
  self.battleInfo = battleInfo
  self.skillList = {}
  self.floorLevel = 20
end

function StageManager:manage(battleEngine)
  local stageSkill = self.battleInfo["Stage Skill ID"]
  if battleEngine.arena_mode then
    if battleEngine.pvpActivityId and battleEngine.pvpActivityId ~= 0 then
      self:createStageUnit(battleEngine)
    end
  elseif battleEngine.crusade_mode then
    if battleEngine.crusadeActivityId and battleEngine.crusadeActivityId ~= 0 then
      self:createStageUnit(battleEngine)
    end
  elseif battleEngine.peakArena_mode then
    if battleEngine.peakAreanSkillId and battleEngine.peakAreanSkillId ~= 0 then
      self:createStageUnit(battleEngine)
    end
  elseif stageSkill and 0 < stageSkill then
    self:createStageUnit(battleEngine)
  end
end

local uid = 242
local camp = ed.emCampEnemy

function StageManager:createStageUnit(engine)
  local proto = {
    _tid = uid,
    _level = self.floorLevel
  }
  local config = {
    estimate_rank = true,
    estimate_skill = true,
    estimate_max_rank = false
  }
  local unit = ed.UnitCreate(proto, camp, config)
  engine:addStageUint(unit)
  if engine.arena_mode then
    local pvpActivityId = engine.pvpActivityId
    if unit.setStageSkillId then
      unit:setStageSkillId(pvpActivityId)
    end
  end
  if engine.crusade_mode then
    local crusadeActivityId = engine.crusadeActivityId
    if unit.setStageSkillId then
      unit:setStageSkillId(crusadeActivityId)
    end
  end
  if engine.peakArena_mode then
    local peakAreanSkillId = engine.peakAreanSkillId
    if unit.setStageSkillId then
      unit:setStageSkillId(peakAreanSkillId)
    end
  end
  unit.position = {
    ed.engine.stage_rect.maxX / 2,
    0
  }
end
