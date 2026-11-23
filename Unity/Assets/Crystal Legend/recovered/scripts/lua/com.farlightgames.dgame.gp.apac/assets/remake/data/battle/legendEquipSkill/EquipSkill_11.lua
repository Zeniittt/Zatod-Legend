local class = newclass("g")
ed.LegendEquip_11 = class

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
    master.LegendEquip_11_CD = 2
    master.LegendEquip_11_canAtk3 = false
  end
end

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  self.dt = self.dt and self.dt + dt or dt
  local master = self.owner
  if master.LegendEquip_11_CD then
    master.LegendEquip_11_CD = master.LegendEquip_11_CD - dt
  end
  if master.LegendEquip_11_CD and master.LegendEquip_11_CD <= 0 then
    master.LegendEquip_11_canAtk3 = true
  end
end

function class.LegendEquip_skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, class.LegendEquip_skillatk3_onDamaged)
  return buff
end

function class.LegendEquip_skillatk3_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and owner then
    local DamageFromFront = (source.position[1] - owner.position[1]) * owner.direction >= 0
    if damage and 0 < damage and damage_type == "AD" and owner.LegendEquip_11_canAtk3 and ed.rand() <= 0.1 and DamageFromFront then
      damage = 0
      owner.LegendEquip_11_canAtk3 = false
      owner.LegendEquip_11_CD = 2
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_solo_card78.cha", owner.position, {
          owner.direction,
          1
        }, nil, 1)
      end
    end
  end
  return damage
end

function class.doInit(LegendEquip)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk2 = LegendEquip.skills.Skill_2
  local skillatk3 = LegendEquip.skills.Skill_3
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, class.LegendEquip_skillatk3_createBuff)
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
