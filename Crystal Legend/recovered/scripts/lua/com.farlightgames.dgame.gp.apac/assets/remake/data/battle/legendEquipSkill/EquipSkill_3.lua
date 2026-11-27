local class = newclass("g")
ed.LegendEquip_3 = class

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  local master = self.owner
  local skillatk3 = self.skills.Skill_3
  if master.LegendEquip_3_atk1_timer then
    master.LegendEquip_3_atk1_timer = master.LegendEquip_3_atk1_timer - dt
  end
  if master.LegendEquip_3_atk2_timer then
    master.LegendEquip_3_atk2_timer = master.LegendEquip_3_atk2_timer - dt
  end
  if master.LegendEquip_3_atk1_timer and master.LegendEquip_3_atk1_timer <= 0 and master:isAlive() then
    local skillatk1 = self.skills.Skill_1
    skillatk1:takeEffectAt(master.position, master)
    master.LegendEquip_3_atk1_timer = 1
  end
  if master.LegendEquip_3_atk2_timer and master.LegendEquip_3_atk2_timer <= 0 and master:isAlive() then
    local skillatk2 = self.skills.Skill_2
    skillatk2:takeEffectAt(master.position, master)
    master.LegendEquip_3_atk2_timer = 1
  end
  if skillatk3 and not self.LegendEquip_3_casted and master.hp <= master.attribs.HP * 0.4 then
    master:addBuff(skillatk3:createBuff(master), master)
    self.LegendEquip_3_casted = true
  end
end

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  master.LegendEquip_3_atk1_timer = 1
  local skillatk3 = self.skills.Skill_3
  local skillatk2 = self.skills.Skill_2
  local skillatk1 = self.skills.Skill_1
  if skillatk1 then
    local binfo = ed.lookupDataTable("Buff", nil, 80000302)
    master:addBuff(binfo, master)
  end
  if skillatk2 then
    master.LegendEquip_3_atk2_timer = 1
  end
  if skillatk3 then
    self.LegendEquip_3_casted = false
  end
end

function class.LegendEquip_skillatk1_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if isHit and target and ed.run_with_scene then
    local dir = 1
    if caster.position[1] - target.position[1] <= 0 then
      dir = -1
    else
      dir = 1
    end
    ed.scene:playEffectOnScene("eff_impact_LegendEquip_3.cha", target.position, {dir, 1}, nil, 1)
  end
  return isHit, dmg
end

function class.LegendEquip_skillatk1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.config.is_summoned then
    local HPR_value = buff.info.HPR
    buff:setAttribute("HPR", HPR_value * 2)
  end
  return buff
end

function class.doInit(LegendEquip)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk3 = LegendEquip.skills.Skill_3
  if skillatk1 then
    skillatk1.takeEffectOn = override(skillatk1.takeEffectOn, class.LegendEquip_skillatk1_takeEffectOn)
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff)
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
