local ed = ed

local function createAiForUnit(unit)
  return ed.AiCreate(unit)
end

ed.createAiForUnit = createAiForUnit
local Ai = {
  mt = {}
}
ed.Ai = Ai
Ai.mt.__index = Ai

local function AiCreate(owner)
  local self = {
    owner = owner,
    destination = nil,
    target = nil,
    will_cast_manual_skill = true
  }
  setmetatable(self, Ai.mt)
  return self
end

Ai.create = AiCreate
ed.AiCreate = AiCreate

local function updateSkillAi(self, dt)
  local target = self:searchTarget()
  if target then
    self.target = target
    local skill = self:findSkillToCast()
    if skill then
      if skill.info.Manual and ed.engine:arenaMode() then
        self.owner:castManualSkill()
      else
        self.owner:castSkill(skill, target)
      end
    end
  end
end

Ai.updateSkillAi = updateSkillAi

local function update(self, dt)
  if self.owner.controlledTarget and not ed.engine:arenaMode() then
    local target = self:searchTarget()
    if target then
      self.target = target
      local skill = self:findSkillToCast()
      if skill then
        if skill.info.Manual and ed.engine:arenaMode() then
          self.owner:castManualSkill()
        else
          self.owner:castSkill(skill, target)
        end
      end
    end
    return
  end
  if self.owner.controlledTarget and ed.engine:arenaMode() then
    local minhp = 99999999
    local owner = self.owner
    local target
    for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
      if unit ~= owner and not unit.buff_effects.untargetable and not unit.buffManager.invisible and (not unit.controlledTarget or unit.controlledTarget.camp ~= self.owner.camp) and minhp > unit.hp then
        minhp = unit.hp
        target = unit
      end
    end
    if target then
      self.target = target
      local skill = self:findSkillToCast()
      if skill then
        if skill.info.Manual and ed.engine:arenaMode() then
        else
          self.owner:castSkill(skill, target)
        end
      elseif not self.owner.controlledTarget or ed.engine:arenaMode() then
        self:walkTo(target)
      end
    elseif self.destination then
      if not self.owner.controlledTarget or ed.engine:arenaMode() then
        self.walkTo(self.destination)
      end
    elseif not self.owner.controlledTarget or ed.engine:arenaMode() then
      self.owner:idle()
    end
    return
  end
  if self.owner.aiMode or self.owner.auto_combat then
    self.owner:autoTapBall()
  end
  if self.owner.buff_effects.building or self.owner.buff_effects.building_notfix then
    local target = self:searchTarget()
    if target then
      self.target = target
      local skill = self:findSkillToCast()
      if skill then
        if skill.info.Manual and ed.engine:arenaMode() then
          self.owner:castManualSkill()
        else
          self.owner:castSkill(skill, target)
        end
      elseif not self.owner.controlledTarget or ed.engine:arenaMode() then
        self.owner:idle()
      end
    elseif not self.owner.controlledTarget or ed.engine:arenaMode() then
      self.owner:idle()
    end
  else
    local target = self:searchTarget()
    if target then
      self.target = target
      local skill = self:findSkillToCast()
      if skill then
        if skill.info.Manual and (ed.engine:arenaMode() or ed.engine:specialPveMode(self.owner)) then
          self.owner:castManualSkill()
        else
          self.owner:castSkill(skill, target)
        end
      elseif not self.owner.controlledTarget or ed.engine:arenaMode() then
        self:walkTo(target)
      end
    elseif self.destination then
      if not self.owner.controlledTarget or ed.engine:arenaMode() then
        self.walkTo(self.destination)
      end
    elseif not self.owner.controlledTarget or ed.engine:arenaMode() then
      self.owner:idle()
    end
  end
end

Ai.update = update

local function twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

local function searchTarget(self)
  local owner = self.owner
  if owner.taunter then
    return owner.taunter, twoPointDistanceSQ(owner.position, owner.taunter.position)
  end
  if owner.detaunter then
    return owner.detaunter, twoPointDistanceSQ(owner.position, owner.detaunter.position)
  end
  if owner.buff_effects.derangedOwner then
    for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
      if unit ~= owner and unit.buff_effects.derangedTarget then
        return unit, twoPointDistanceSQ(owner.position, unit.position)
      end
    end
  end
  local target, minDistanSQ = self:stMinDisTarget()
  local ft, mdst = target, minDistanSQ
  local flst = {}
  local rect_cut = ed.engine.rect_cut
  if not rect_cut.isEmpty() then
    while not rect_cut.checkSameArea(owner, target) do
      flst[target.tid] = true
      target, minDistanSQ = self:stMinDisTarget(flst)
      if not target then
        target = ft
        mdst = minDistanSQ
        break
      end
    end
  end
  return target, minDistanSQ
end

Ai.searchTarget = searchTarget

function Ai:stMinDisTarget(ftList)
  ftList = ftList or {}
  local owner = self.owner
  local minDistanSQ = math.huge
  local target
  for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
    if unit ~= owner and not unit.buff_effects.untargetable and not unit.buffManager.invisible and (not unit.controlledTarget or unit.controlledTarget.camp ~= self.owner.camp) then
      local distanceSQ = twoPointDistanceSQ(owner.position, unit.position)
      if minDistanSQ > distanceSQ and not ftList[unit.tid] then
        minDistanSQ = distanceSQ
        target = unit
      end
    end
  end
  local enchanted = owner.buff_effects.enchanted
  local enchantedbyself = owner.buff_effects.enchantedbyself
  if target then
    return target, minDistanSQ
  else
    if not enchanted and not enchantedbyself then
      for unit in ed.engine:foreachAliveUnit(self.owner.camp) do
        if not unit.buff_effects.untargetable then
          local distanceSQ = twoPointDistanceSQ(owner.position, unit.position)
          if minDistanSQ > distanceSQ and not ftList[unit.tid] then
            minDistanSQ = distanceSQ
            target = unit
          end
        end
      end
    end
    return target, minDistanSQ
  end
end

local function findSkillToCast(self)
  if self.owner.global_cd > 0 then
    return nil
  end
  local list = self.owner.skill_list
  for i = 1, #list do
    local skill = list[i]
    if self.owner.controlledTarget and ed.engine:arenaMode() and skill.info.Manual then
    elseif self:findCanAutoCastSkill(skill) then
      return skill
    end
  end
  return nil
end

Ai.findSkillToCast = findSkillToCast

local function walkTo(self, dest)
  if dest.position then
    dest = dest.position
  end
  local owner = self.owner
  local distanceSQ = ed.edpDistanceSQ(dest, owner.position)
  if not (distanceSQ <= owner.attack_range ^ 2) or owner:isOutOfStage() then
  else
    owner:idle()
    return
  end
  owner:walkTowards(dest)
end

Ai.walkTo = walkTo

function Ai:findCanAutoCastSkill(skill)
  if ed.engine:manualBtMode() and self.owner.camp == ed.emCampPlayer and skill.info["Atk Manual"] then
    return false
  end
  if skill.is_update and (self.will_cast_manual_skill or not skill.info.Manual) then
    local cast = skill:canCastWithTarget(self.target, true)
    if cast and skill:willCast() then
      return true
    end
  end
  return false
end
