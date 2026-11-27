module("ed.battlehero", package.seeall)
local ed = ed
RazorTitan = {}
RazorTitan.threshold = 0.2
RazorTitan.threshold_atk4s = 0.5

function RazorTitan.skillult_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  skill.info["No Dodge"] = true
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4629
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function RazorTitan.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4629 then
      tbuff.timer = -1
    end
  end
end

function RazorTitan.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local MDODG_ratio = skill.info["Script Arg2"]
  local caster = skill.caster
  local bid = 4632
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local AD = skill.info.buff_info.AD
  buff:setAttribute("AD", -AD)
  if caster.attribs.MDODG < 90 then
    buff:setAttribute("MDODG", MDODG_ratio)
  end
  caster:addBuff(buff, caster)
end

function RazorTitan.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.RazorTitan_TotalDamage = 0
  hero.RazorTitan_atk4s_Damage = 0
end

function RazorTitan.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local finaldamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if finaldamage then
    self.RazorTitan_TotalDamage = finaldamage + self.RazorTitan_TotalDamage
    self.RazorTitan_atk4s_Damage = finaldamage + self.RazorTitan_atk4s_Damage
  end
  return finaldamage, bc
end

function RazorTitan.update(basefunc, self, dt)
  basefunc(self, dt)
  local hp_per = self.attribs.HP * RazorTitan.threshold
  local hp_per_s = self.attribs.HP * RazorTitan.threshold_atk4s
  local Damagetotal = self.RazorTitan_TotalDamage
  local Damagetotal_s = self.RazorTitan_atk4s_Damage
  local HPRdamage = 0
  local skillatk4 = self.skills.RazorTitan_atk4
  local skillatk4s = self.skills.RazorTitan_atk4s
  if skillatk4 then
    if self.buff_list then
      for _, tbuff in ipairs(self.buff_list) do
        if 0 > tbuff.info.HPR then
          local hpr = tbuff.info.HPR * dt
          HPRdamage = math.min(-hpr, self.hp)
          HPRdamage = HPRdamage * self.dPSStatisticsRatio
        end
      end
    end
    Damagetotal = Damagetotal + HPRdamage
    Damagetotal_s = Damagetotal_s + HPRdamage
    if hp_per_s < Damagetotal_s then
      local bid = 4634
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      self:addBuff(binfo, self)
      skillatk4s:takeEffectAt(self.position)
      self.RazorTitan_atk4s_Damage = 0
    end
    if hp_per < Damagetotal then
      local bid = 4634
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      self:addBuff(binfo, self)
      skillatk4:takeEffectAt(self.position)
      local hero = skillatk4.caster
      local bid1 = 4633
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      hero:addBuff(binfo1, hero)
      self.RazorTitan_TotalDamage = 0
    end
  end
end

function RazorTitan.init_hero(hero)
  hero.update = override(hero.update, RazorTitan.update)
  hero.reset = override(hero.reset, RazorTitan.hero_reset)
  local skillult = hero.skills.RazorTitan_ult
  if skillult then
    skillult.start = override(skillult.start, RazorTitan.skillult_start)
    skillult.finish = override(skillult.finish, RazorTitan.skillult_finish)
  end
  local skillatk4 = hero.skills.RazorTitan_atk4
  if skillatk4 then
    hero.takeDamage = override(hero.takeDamage, RazorTitan.hero_takeDamage)
  end
  local skillatk3 = hero.skills.RazorTitan_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, RazorTitan.skillatk3_takeEffectOn)
  end
  return hero
end

return RazorTitan.init_hero
