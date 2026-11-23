local class = newclass("g")
ed.battleDataCollect = class

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
end

function class:update(dt)
end

function class:collectSkill(deliverer, skill, eventIdx)
end

function class:collectSkillStart(deliverer, skill, receiver)
end

function class:collectSkillHit(deliverer, skill, receiver)
end

function class:collectBuff(buff)
end

function class:collectHPchange(config)
end

function class:collectMPchange(config)
end

function class:handleUnitDieEventOnce(unit, killer_unit)
end
