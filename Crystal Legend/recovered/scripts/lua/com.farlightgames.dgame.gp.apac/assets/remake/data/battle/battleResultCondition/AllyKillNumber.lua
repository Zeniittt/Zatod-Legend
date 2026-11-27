local class = newclass("g")
ed.AllyKillNumber = class

function class:check(conditionCfg)
  local heroId = conditionCfg["Condition Param"][1]
  local requireNum = conditionCfg["Condition Param"][2]
  local killNum = 0
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == ed.emCampPlayer and (unit.tid == heroId or nil ~= unit.config.summoner and unit.config.summoner ~= unit and unit.config.summoner.tid == heroId) then
      killNum = killNum + unit.battledata:getKillNum()
    end
  end
  self.result = requireNum <= killNum
  return self.result
end

function class:getResult()
  return self.result
end

function class.create(specialConditionCfg)
  local self = setmetatable({}, {__index = class})
  return self
end

return class
