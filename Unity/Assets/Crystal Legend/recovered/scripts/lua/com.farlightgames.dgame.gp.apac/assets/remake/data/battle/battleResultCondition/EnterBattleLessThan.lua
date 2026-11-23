local class = newclass("g")
ed.EnterBattleLessThan = class

function class:check(conditionCfg)
  local maxnumber = conditionCfg["Condition Param"][1]
  local result = true
  local count = 0
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == ed.emCampPlayer and not unit.config.summoner then
      count = count + 1
    end
  end
  if maxnumber < count then
    result = false
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
