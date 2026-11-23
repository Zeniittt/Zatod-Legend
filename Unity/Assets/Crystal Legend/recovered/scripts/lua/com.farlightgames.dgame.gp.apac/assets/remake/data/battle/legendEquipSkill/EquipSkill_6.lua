local class = newclass("g")
ed.LegendEquip_6 = class

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  self.LegendEquip_1_casted = false
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
end

function class.LegendEquip_update(basefunc, self, dt)
  basefunc(self, dt)
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  if skillatk1 and not self.LegendEquip_1_casted and master.current_skill and master.current_skill.info.Manual then
    master:addBuff(skillatk1:createBuff(master), master)
    self.LegendEquip_1_casted = true
  end
end

function class.LegendEquip_skillatk1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = 10
  return buff
end

function class.doInit(LegendEquip)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  LegendEquip.update = override(LegendEquip.update, class.LegendEquip_update)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk2 = LegendEquip.skills.Skill_2
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
