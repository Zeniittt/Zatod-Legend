local class = newclass("g")
ed.Enchult = class

function class:check(conditionCfg)
  local ultmaxtime = conditionCfg["Condition Param"][1]
  local result = true
  local battleDataCollect = ed.engine.battleDataCollect
  if ultmaxtime < battleDataCollect.ulttime then
    result = false
  end
  self.result = result
  return result
end

function class.collectSkill(basefunc, self, deliverer, skill, eventIdx)
  if skill.info["Skill Group ID"] == 450 and skill.caster and skill.caster.camp == ed.emCampEnemy and eventIdx and eventIdx == 1 then
    self.ulttime = self.ulttime + 1
  end
end

function class:getResult()
  return self.result
end

function class.create(conditionCfg)
  local self = setmetatable({}, {__index = class})
  local battleDataCollect = ed.engine.battleDataCollect
  battleDataCollect.ulttime = 0
  battleDataCollect.collectSkill = override(battleDataCollect.collectSkill, class.collectSkill)
  return self
end

return class
