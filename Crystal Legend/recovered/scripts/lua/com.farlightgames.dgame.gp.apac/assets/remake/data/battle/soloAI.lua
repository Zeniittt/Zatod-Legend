local base = ed.Ai
local soloAI = newclass(base.mt)

function ed.createSoloAIForUnit(unit)
  return soloAI.create(unit)
end

local function twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function soloAI:walkTo(dest)
  if dest.position then
    dest = dest.position
  end
  local owner = self.owner
  local distanceSQ = ed.edpDistanceSQ(dest, owner.position)
  if distanceSQ <= owner.attack_range ^ 2 and not owner:isOutOfStage() then
    owner:idle()
    return
  end
  owner:walkTowards(dest)
end

function soloAI:findCanAutoCastSkill(skill)
  if skill.is_update then
    local cast = skill:canCastWithTarget(self.target, true)
    if cast and skill:willCast() then
      return true
    end
  end
  return false
end

function soloAI:findSkillToCast()
  local list = self.owner.skill_list
  for i = 1, #list do
    local skill = list[i]
    if self:findCanAutoCastSkill(skill) then
      return skill
    end
  end
  return nil
end

function soloAI:update(dt)
  self.target = self:searchTarget()
  if self.target then
    local skill = self:findSkillToCast()
    if skill then
      self.owner:castSkill(skill, self.target)
    else
      self:walkTo(self.target)
    end
  elseif self.destination then
    self:walkTo(self.destination)
  else
    self.owner:idle()
  end
end

function soloAI:searchTarget()
  for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
    if unit:isAlive() and not unit.config.is_summoned then
      return unit, twoPointDistanceSQ(self.owner.position, unit.position)
    end
  end
  return nil, math.huge
end

function soloAI:stMinDisTarget(ftList)
  ftList = ftList or {}
  local owner = self.owner
  local minDistanSQ = math.huge
  local target
  for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
    if unit ~= owner then
      local distanceSQ = (owner.position[1] - unit.position[1]) * (owner.position[1] - unit.position[1])
      if minDistanSQ > distanceSQ and not ftList[unit.tid] then
        minDistanSQ = distanceSQ
        target = unit
      end
    end
  end
  return target, minDistanSQ
end

function soloAI.create(owner)
  local self = base.create(owner)
  self.atkInterval = 2
  self.nextAtkTime = self.atkInterval
  setmetatable(self, soloAI.mt)
  return self
end
