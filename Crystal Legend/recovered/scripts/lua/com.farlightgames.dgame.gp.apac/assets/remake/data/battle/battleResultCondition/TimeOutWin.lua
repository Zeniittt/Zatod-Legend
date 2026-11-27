local class = newclass("g")
ed.TimeOutWin = class

function class:check(conditionCfg)
  local result = false
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == ed.emCampPlayer and not unit.config.summoner and unit:isAlive() then
      result = true
      break
    end
  end
  self.result = result
  return result
end

function class:getResult()
  return self.result
end

function class.create(conditionCfg)
  local self = setmetatable({}, {__index = class})
  return self
end

return class
