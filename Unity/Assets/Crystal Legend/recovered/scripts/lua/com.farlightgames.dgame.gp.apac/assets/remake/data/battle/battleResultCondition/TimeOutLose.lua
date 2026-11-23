local class = newclass("g")
ed.TimeOutLose = class

function class:check(conditionCfg)
  local result = true
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == ed.emCampEnemy and not unit.config.summoner and unit:isAlive() then
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

function class.create(conditionCfg)
  local self = setmetatable({}, {__index = class})
  return self
end

return class
