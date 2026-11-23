local class = newclass("g")
ed.LegendEquip_7 = class

function class.LegendEquip_reset(basefunc, self)
  basefunc(self)
  local master = self.owner
  local skillatk1 = self.skills.Skill_1
  if skillatk1 then
    master:addBuff(skillatk1:createBuff(master), master)
  end
  local skillatk2 = self.skills.Skill_2
  if skillatk2 then
    master:addBuff(skillatk2:createBuff(master), master)
  end
  local skillatk3 = self.skills.Skill_3
  if skillatk3 then
    master:addBuff(skillatk3:createBuff(master), master)
  end
end

function class.doInit(LegendEquip)
  LegendEquip.reset = override(LegendEquip.reset, class.LegendEquip_reset)
  local skillatk1 = LegendEquip.skills.Skill_1
  local skillatk2 = LegendEquip.skills.Skill_2
  local skillatk3 = LegendEquip.skills.Skill_3
end

function class.init(LegendEquip)
  class.doInit(LegendEquip)
  return LegendEquip
end

return class.init
