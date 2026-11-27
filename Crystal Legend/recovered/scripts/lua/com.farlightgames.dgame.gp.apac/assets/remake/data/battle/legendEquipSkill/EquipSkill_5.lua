local class = newclass("g")
ed.LegendEquip_5 = class

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  master.LegendEquip_5_dmg_reduce = 500
  if skillatk1 then
    master:addBuff(skillatk1:createBuff(master), master)
  end
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
  local skillatk3 = self.skills.Skill_3
  if skillatk3 then
    master.LegendEquip_5_dmg_reduce = 625
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
  if damage and 0 < damage and damage_type == "AD" and owner.LegendEquip_5_dmg_reduce and ed.rand() < 0.6 then
    damage = math.max(1, damage - owner.LegendEquip_5_dmg_reduce)
    local dir = 1
    if 0 >= owner.position[1] - source.position[1] then
      dir = 1
    else
      dir = -1
    end
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_LegendEquip_5.cha", owner.position, {dir, 1}, nil, 1)
    end
  end
  return damage
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
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff)
  end
  local skillatk2 = LegendEquip.skills.Skill_2
  local skillatk3 = LegendEquip.skills.Skill_3
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
