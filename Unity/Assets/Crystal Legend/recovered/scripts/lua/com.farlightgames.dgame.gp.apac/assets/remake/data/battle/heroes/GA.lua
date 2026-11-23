module("ed.battlehero", package.seeall)
local ed = ed
GA = {}

function GA.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  local lost = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if damage_type == "AD" then
    local skillult = hero.skills.GA_ult
    if skillult and hero.name ~= "Rubick" then
      if ed.run_with_scene then
        local effect_night = "eff_point_GA_ult_1.cha"
        local origin = hero.position
        ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
      end
      hero.GA_atk2_AD = hero.GA_atk2_AD + 1
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 510 and tbuff.caster == hero then
          hero.GA_atk2_AD = hero.GA_atk2_AD + 1
          break
        end
      end
    end
  elseif damage_type == "AP" then
    local skillult = hero.skills.GA_ult
    if skillult and hero.name ~= "Rubick" then
      if ed.run_with_scene then
        local effect_night = "eff_point_GA_ult_2.cha"
        local origin = hero.position
        ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
      end
      hero.GA_atk2_AP = hero.GA_atk2_AP + 1
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 510 and tbuff.caster == hero then
          hero.GA_atk2_AP = hero.GA_atk2_AP + 1
          break
        end
      end
    end
  end
  return lost
end

function GA.hero_handleUnitDieEventToAll(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillult = self.skills.GA_ult
  if skillult and not unit.config.is_summoned and self.name ~= "Rubick" and self:isAlive() then
    if ed.run_with_scene then
      local effect_night = "eff_point_GA_ult_3.cha"
      local origin = self.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    end
    self.GA_atk2_SOUL = self.GA_atk2_SOUL + 1
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.ID == 510 and tbuff.caster == self then
        self.GA_atk2_SOUL = self.GA_atk2_SOUL + 1
        break
      end
    end
  end
end

function GA.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local originfo = skill.info
  if skill.attack_counter == 1 then
    basefunc(skill, location, source)
  else
    local skillatk3_1 = caster.skills.GA_atk3_1
    if skillatk3_1 then
      skillatk3_1:takeEffectAt(caster.position)
      skill.caster.GA_atk2_LOSE = skill.caster.GA_atk2_LOSE + 1
    end
  end
end

function GA.skillatk3_1_takeEffectOn(basefunc, skill, target)
  local originfo = skill.info
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 511 then
      local buff = tbuff
      skill.info = ed.wraptable(originfo, {
        ["Knock Up"] = 0.15,
        ["Knock Back"] = 10,
        ["Plus Ratio"] = 0.85
      })
    end
  end
  basefunc(skill, target)
  skill.info = originfo
end

function GA.skillatk2_takeEffectOn(basefunc, skill, target)
  local orig_mp = target.mp
  local orig_hp = target.hp
  local hp_percent = orig_hp / target.attribs.HP
  local mp_percent = orig_mp / 1000
  local skillsawake = skill.caster.skills.GA_sawake
  if skillsawake and skill.caster.mp_reduce_temp then
    local mp_reduce_percent = skill.caster.mp_reduce_temp / 1000
    local hp_enhance_percent = skill.caster.hp_enhance_temp / 1000
    mp_percent = math.max(mp_percent - mp_reduce_percent, 0)
    hp_percent = math.min(hp_percent + hp_enhance_percent, 1)
  end
  if mp_percent < hp_percent then
    local losthp = (hp_percent - mp_percent) * target.attribs.HP
    if skillsawake and skill.caster.STR_count then
      if losthp > skillsawake.info["Script Arg3"] then
        losthp = skill.info["Script Arg3"]
      end
    else
      if losthp > target.attribs.HP * 0.5 then
        losthp = target.attribs.HP * 0.5
      end
      if losthp > skill.info["Script Arg3"] then
        losthp = skill.info["Script Arg3"]
      end
    end
    target:takeDamage(losthp, "Holy", "hp", skill.caster, 1, 1)
    skill.caster.GA_atk2_LOSE = skill.caster.GA_atk2_LOSE + 1
    if ed.run_with_scene then
      local effect_night = "eff_impact_GA_atk2.cha"
      local origin = target.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    end
  else
    basefunc(skill, target)
  end
end

function GA.atk4_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4_1 = caster.skills.GA_atk4_1
  if skillatk4_1 then
    skillatk4_1.cd_remaining = 999
  end
  local skillatk = caster.skills.GA_atk
  if skillatk then
    skillatk.cd_remaining = 0
  end
  basefunc(buff)
end

function GA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onRemoved = override(buff.onRemoved, GA.atk4_buff_onRemoved)
  local skillawake = owner.skills.GA_awake
  if skillawake then
    local AP = skillawake.level * skillawake.info["Growth 1 Value"]
    local HPR = skillawake.level * skillawake.info["Growth 2 Value"]
    buff:setAttribute("AP", AP)
    buff:setAttribute("HPR", HPR)
  end
  local skillatk4_1 = owner.skills.GA_atk4_1
  if skillatk4_1 then
    skillatk4_1.cd_remaining = 0
  end
  local skillatk = owner.skills.GA_atk
  if skillatk then
    skillatk.cd_remaining = 999
  end
  return buff
end

function GA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.caster.GA_atk2_type == "AD" then
    buff:setAttribute("Control Effects", {"disarm"})
    buff:setAttribute("Effect", "eff_buff_Earth_atk2.cha")
  elseif skill.caster.GA_atk2_type == "AP" then
    buff:setAttribute("Control Effects", {"silence"})
    buff:setAttribute("Effect", "eff_buff_silence.cha")
  elseif skill.caster.GA_atk2_type == "SOUL" then
    buff:setAttribute("HAST", -5)
    buff:setAttribute("MSPD", -68)
  end
  return buff
end

function GA.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local skillult2 = caster.skills.GA_ult2
  if skillult2 then
    skillult2:takeEffectOn(caster)
  end
  basefunc(skill, target)
  local skillsawake = skill.caster.skills.GA_sawake
  skill.count_STR = 0
  skill.count_INT = 0
  skill.count_AGI = 0
  if skillsawake then
    for unit in ed.engine:foreachAliveUnit(-skill.caster.camp) do
      for _, buff in ipairs(unit.buff_list) do
        if buff.info.ID == 926 then
          skill.count_STR = skill.count_STR + buff.rank
          buff.rank = 1
        elseif buff.info.ID == 927 then
          skill.count_INT = skill.count_INT + buff.rank
          buff.rank = 1
        elseif buff.info.ID == 928 then
          skill.count_AGI = skill.count_AGI + buff.rank
          buff.rank = 1
        end
      end
    end
    if skill.count_STR then
      skill.caster.mp_reduce_temp = math.min(1000, skill.count_STR * 100)
      skill.caster.hp_enhance_temp = math.min(1000, skill.count_STR * 100)
      skill.caster.STR_count = true
    end
    skill.damage_enhance_temp = 0
    skill.attack_reduce_temp = 0
    if skill.count_INT then
      skill.damage_enhance_temp = math.min(1, skill.count_INT * skillsawake.info["Basic Num"])
    end
    if skill.count_AGI then
      skill.attack_reduce_temp = math.min(1, skill.count_AGI * skillsawake.info["Script Arg2"])
      for unit in ed.engine:foreachAliveUnit(skill.caster.camp) do
        unit.get_damage_buff = 1 - skill.attack_reduce_temp
        local buff = skillsawake:createBuff(unit)
        buff.onDamaged = override(buff.onDamaged, GA.ahero_buffonDamaged)
        unit:addBuff(buff)
      end
    end
  end
end

function GA.skillult_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  if skill.caster.GA_atk2_type == "AD" then
    local bid = 507
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  elseif skill.caster.GA_atk2_type == "AP" then
    local bid = 508
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  elseif skill.caster.GA_atk2_type == "SOUL" then
    local bid = 509
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  end
end

function GA.skillINT_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if skill.count_INT > 0 then
    power = power * (1 + skill.damage_enhance_temp)
  end
  return power, 1
end

function GA.ahero_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if buff.owner.get_damage_buff >= 0 and damage_type == "AD" then
    damage = damage * buff.owner.get_damage_buff
  end
  return damage
end

function GA.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    local potion_type
    if skill.caster.GA_atk2_AD > skill.caster.GA_atk2_AP * 3 and skill.caster.GA_atk2_AD > skill.caster.GA_atk2_SOUL * 9 then
      potion_type = "AD"
    elseif skill.caster.GA_atk2_AP * 3 > skill.caster.GA_atk2_AD and skill.caster.GA_atk2_AP * 3 > skill.caster.GA_atk2_SOUL * 9 then
      potion_type = "AP"
    else
      potion_type = "SOUL"
    end
    local num = skill.caster.GA_atk2_AD + skill.caster.GA_atk2_AP + skill.caster.GA_atk2_SOUL
    local ratio = 1.3 + num * 0.03
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = ratio,
      ["Point Effect"] = "eff_point_GA_ult_" .. potion_type .. ".cha"
    })
    skill.caster.GA_atk2_type = potion_type
    basefunc(skill)
    skill.info = originfo
    skill.caster.GA_atk2_AP = 0
    skill.caster.GA_atk2_AD = 0
    skill.caster.GA_atk2_SOUL = 0
  elseif attack_counter == 0 then
    if skill.caster.manually_casting and skill.attack_counter == 0 then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function GA.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 510 then
      local buff = tbuff
      buff.timer = 0
    end
  end
end

function GA.reset(basefunc, hero)
  basefunc(hero)
  hero.GA_atk2_AP = 0
  hero.GA_atk2_AD = 0
  hero.GA_atk2_SOUL = 0
  hero.GA_atk2_LOSE = 0
  hero.GA_atk2_type = nil
  hero.index = 0
end

function GA.update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.index = hero.index + dt
  if hero.index == 1 then
    local skillsawake = hero.skills.GA_sawake
    if skillsawake then
      for ounit in ed.engine:foreachAliveUnit(-hero.camp) do
        if ounit.info["Main Attrib"] == "STR" or ounit.info["Main Attrib"] == "INT" or ounit.info["Main Attrib"] == "AGI" then
          if ounit.info["Main Attrib"] == "STR" then
            local binfo_STR = ed.lookupDataTable("Buff", nil, 926)
            ounit:addBuff(binfo_STR, ounit)
            ounit.sawake_counter = 0
            ounit.castSkill = override(ounit.castSkill, GA.ohero_castSkill)
          elseif ounit.info["Main Attrib"] == "INT" then
            local binfo_INT = ed.lookupDataTable("Buff", nil, 927)
            ounit:addBuff(binfo_INT, ounit)
            ounit.sawake_counter = 0
            ounit.castSkill = override(ounit.castSkill, GA.ohero_castSkill)
          else
            local binfo_AGI = ed.lookupDataTable("Buff", nil, 928)
            ounit:addBuff(binfo_AGI, ounit)
            ounit.sawake_counter = 0
            ounit.castSkill = override(ounit.castSkill, GA.ohero_castSkill)
          end
          hero.mp = math.min(hero.mp + 20, 1000)
        end
      end
    end
  end
end

function GA.ohero_castSkill(basefunc, unit, skill, target)
  basefunc(unit, skill, target)
  unit.sawake_counter = unit.sawake_counter + 1
  if unit.sawake_counter == 2 then
    unit.sawake_counter = 0
    if unit.info["Main Attrib"] == "STR" then
      local binfo_STR = ed.lookupDataTable("Buff", nil, 926)
      unit:addBuff(binfo_STR, unit)
    elseif unit.info["Main Attrib"] == "INT" then
      local binfo_INT = ed.lookupDataTable("Buff", nil, 927)
      unit:addBuff(binfo_INT, unit)
    else
      local binfo_AGI = ed.lookupDataTable("Buff", nil, 928)
      unit:addBuff(binfo_AGI, unit)
    end
  end
  for unit_temp in ed.engine:foreachAliveUnit(-unit.camp) do
    if unit_temp.info.Name == "GA" then
      unit_temp.mp = math.min(unit_temp.mp + 20, 1000)
    end
  end
end

function GA.init_hero(hero)
  hero.reset = override(hero.reset, GA.reset)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, GA.hero_handleUnitDieEventToAll)
  hero.takeDamage = override(hero.takeDamage, GA.hero_takeDamage)
  local skillatk3 = hero.skills.GA_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, GA.skillatk3_takeEffectAt)
  end
  local skillatk3_1 = hero.skills.GA_atk3_1
  if skillatk3_1 then
    skillatk3_1.takeEffectOn = override(skillatk3_1.takeEffectOn, GA.skillatk3_1_takeEffectOn)
  end
  local skillatk2 = hero.skills.GA_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GA.skillatk2_takeEffectOn)
  end
  local skillatk4 = hero.skills.GA_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, GA.skillatk4_createBuff)
  end
  local skillult = hero.skills.GA_ult
  local skillsawake = hero.skills.GA_sawake
  if skillult then
    if skillsawake then
      skillult.power = override(skillult.power, GA.skillINT_power)
    end
    skillult.start = override(skillult.start, GA.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GA.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, GA.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, GA.skillult_createBuff)
  end
  if skillsawake then
    hero.update = override(hero.update, GA.update)
  end
  return hero
end

return GA.init_hero
