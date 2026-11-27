local class = newclass("g")
ed.EnemyKillNumber = class

function class:check(conditionCfg)
  local heroId = conditionCfg["Condition Param"][1]
  local MaxkillAmount = conditionCfg["Condition Param"][2]
  local result = false
  local killAmount = 0
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == ed.emCampEnemy and (unit.tid == heroId or nil ~= unit.config.summoner and unit.config.summoner ~= unit and unit.config.summoner.tid == heroId) then
      killAmount = killAmount + unit.battledata:getKillNum()
    end
  end
  if MaxkillAmount >= killAmount then
    result = true
  end
  self.result = result
  return result
end

function class:getResult()
  return self.result
end

function class.create(specialConditionCfg)
  local self = setmetatable({}, {__index = class})
  return self
end

return class
