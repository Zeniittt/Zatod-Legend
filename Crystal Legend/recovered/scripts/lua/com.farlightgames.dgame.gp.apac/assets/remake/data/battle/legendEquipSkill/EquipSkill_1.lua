local class = newclass("g")
ed.LegendEquip_1 = class

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  local master = self.owner
  if not self.LegendEquip_1_casted and master.current_skill and master.current_skill.info.Manual then
    local skillatk1 = self.skills.Skill_1
    self:castSkill(skillatk1, master)
    self.LegendEquip_1_casted = true
  end
end

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  self.LegendEquip_1_casted = false
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
end

function class.LegendEquip_skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, class.LegendEquip_skillatk2_buff_onDamaged)
  return buff
end

function class.LegendEquip_skillatk2_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and damage and 0 < damage then
    local binfo = ed.lookupDataTable("Buff", nil, 80000102)
    source:addBuff(binfo, buff.owner)
  end
  return damage
end

function class.LegendEquip_skillatk1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = 8
  buff:setAttribute("HealRatio", -25)
  buff:setAttribute("LFSRatio", -25)
  return buff
end

function class.doInit(LegendEquip)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk2 = LegendEquip.skills.Skill_2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, class.LegendEquip_skillatk2_createBuff)
  end
  local skillatk3 = LegendEquip.skills.Skill_3
  if skillatk1 and skillatk3 then
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff)
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
