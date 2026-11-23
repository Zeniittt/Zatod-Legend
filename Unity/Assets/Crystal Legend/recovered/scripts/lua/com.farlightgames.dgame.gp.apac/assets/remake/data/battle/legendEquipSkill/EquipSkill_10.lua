local class = newclass("g")
ed.LegendEquip_10 = class

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
  local skillatk3 = self.skills.Skill_3
  if skillatk3 then
    master:addBuff(skillatk3:createBuff(master), master)
  end
end

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  self.dt = self.dt and self.dt + dt or dt
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  if skillatk1 and not self.LegendEquip_10_casted and master.hp <= master.attribs.HP * 0.6 then
    master:addBuff(skillatk1:createBuff(master), master)
    local bid = 80001004
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    master:addBuff(binfo, master)
    self.LegendEquip_10_casted = true
  end
end

function class.LegendEquip_skillatk1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, class.LegendEquip_skillatk1_onDamaged)
  return buff
end

function class.LegendEquip_skillatk1_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if damage and 0 < damage and damage_type ~= "Holy" and source and source.camp ~= owner.camp and source:isAlive() and not transferred then
    transferred = true
    source:takeDamage(damage * 0.85, "Holy", "hp", owner, 1, 1, transferred)
    if source.buff_effects.invulnerable and skill and skill.caster and skill.caster.DGultToAWultUnit and skill.caster.DGultToAWultUnit:isAlive() then
      skill.caster.DGultToAWultUnit:takeDamage(damage * 0.85, "Holy", "hp", owner, 1, 1, transferred)
    end
  end
  return damage
end

function class.LegendEquip_skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, class.LegendEquip_skillatk2_onDamaged)
  return buff
end

function class.LegendEquip_skillatk2_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if damage and 0 < damage and damage_type ~= "Holy" and source and source.camp ~= owner.camp and source:isAlive() and not transferred then
    transferred = true
    source:takeDamage(damage * 0.15 + owner.attribs.STR * 0.1, "Holy", "hp", owner, 1, 1, transferred)
    if source.buff_effects.invulnerable and skill and skill.caster and skill.caster.DGultToAWultUnit and skill.caster.DGultToAWultUnit:isAlive() then
      skill.caster.DGultToAWultUnit:takeDamage(damage * 0.15 + owner.attribs.STR * 0.1, "Holy", "hp", owner, 1, 1, transferred)
    end
  end
  return damage
end

function class.doInit(LegendEquip)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  local skillatk1 = LegendEquip.skills.Skill_1
  if skillatk1 then
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff)
  end
  local skillatk2 = LegendEquip.skills.Skill_2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, class.LegendEquip_skillatk2_createBuff)
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
