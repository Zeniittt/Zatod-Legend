local class = newclass("g")
ed.LegendEquip_2 = class

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  self.dt = self.dt and self.dt + dt or dt
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  if skillatk1 and self.dt == 0.125 then
    master:addBuff(skillatk1:createBuff(master), master)
  end
  local skillatk3 = self.skills.Skill_3
  if skillatk3 and not self.LegendEquip_2_casted and master.hp <= master.attribs.HP * 0.3 then
    master:addBuff(skillatk3:createBuff(master), master)
    self.LegendEquip_2_casted = true
  end
end

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  self.LegendEquip_2_casted = false
end

function class.LegendEquip_skillatk1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setHealAffect(false)
  return buff
end

function class.LegendEquip_skillatk1_createBuff2(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, class.skillatk1_Buff_update)
  buff.count_timer = 1
  buff:setHealAffect(false)
  return buff
end

function class.skillatk1_Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if buff.count_timer then
    buff.count_timer = buff.count_timer - dt
  else
    buff.count_timer = 1
  end
  if owner.hp < owner.attribs.HP * 0.4 then
    if buff.count_timer <= 0 then
      buff:setAttribute("HPR.a", 0.0225)
      buff.count_timer = 1
      owner:rebuild()
    end
  elseif buff.count_timer <= 0 then
    buff:setAttribute("HPR.a", 0.018)
    buff.count_timer = 1
    owner:rebuild()
  end
end

function class.doInit(LegendEquip)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk2 = LegendEquip.skills.Skill_2
  if skillatk1 then
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff)
  end
  if skillatk1 and skillatk2 then
    skillatk1.createBuff = override(skillatk1.createBuff, class.LegendEquip_skillatk1_createBuff2)
  end
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
