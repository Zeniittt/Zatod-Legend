local class = newclass("g")
ed.LegendEquip_4 = class

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  self.LegendEquip_4_cd = 0
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
end

function class.LegendEquip_skillatk1_power(basefunc, skill, target, damage_type)
  local power = basefunc(skill, target, damage_type)
  if power and target and target.config.is_summoned then
    power = power * 2
  end
  return power
end

function class.LegendEquip_collectSkillHit(basefunc, self, caster, skill, target)
  basefunc(self, caster, skill, target)
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  local skillatk2 = self.skills.Skill_2
  if caster and master == caster and target and target:isAlive() and (skill == caster.basic_skill or skill.info["Skill Name"] == caster.name .. "_atk") and self.LegendEquip_4_cd <= 0 then
    self:castSkill(skillatk1, target)
    self.LegendEquip_4_cd = skillatk2 and 2.5 or 3
  end
end

function class.LegendEquip_skillatk1_launchPoint(basefunc, self)
  local pos, h = basefunc(self)
  return pos, h + 26
end

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  if self.LegendEquip_4_cd then
    self.LegendEquip_4_cd = self.LegendEquip_4_cd - dt
  end
end

function class.doInit(LegendEquip)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  local skillatk1 = LegendEquip.skills.Skill_1
  if skillatk1 then
    LegendEquip.collectSkillHit = override(LegendEquip.collectSkillHit, class.LegendEquip_collectSkillHit)
    skillatk1.launchPoint = override(skillatk1.launchPoint, class.LegendEquip_skillatk1_launchPoint)
    skillatk1.power = override(skillatk1.power, class.LegendEquip_skillatk1_power)
  end
  local skillatk2 = LegendEquip.skills.Skill_2
  local skillatk3 = LegendEquip.skills.Skill_3
  if skillatk1 and skillatk3 then
    skillatk1.info = ed.wraptable(skillatk1.info, {
      ["Chain Jumps"] = 5
    })
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
