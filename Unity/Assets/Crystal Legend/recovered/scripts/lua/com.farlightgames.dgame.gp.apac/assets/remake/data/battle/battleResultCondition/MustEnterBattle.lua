local class = newclass("g")
ed.MustEnterBattle = class

function class:check(conditionCfg)
  local heroIdList = conditionCfg["Condition Param"] or {}
  local result = true
  for index, heroId in ipairs(heroIdList) do
    local isExist
    for _, unit in ipairs(ed.engine.unit_list) do
      if unit.tid == heroId and unit.camp == ed.emCampPlayer then
        isExist = true
        break
      end
    end
    if not isExist then
      result = false
      break
    end
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
