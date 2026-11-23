module("ed.battlehero", package.seeall)
local ed = ed
WhiteSnake = {}
WhiteSnake.guPercent = 10

function WhiteSnake.searchAddBuff(bid, target, source)
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff
  if target and next(target) then
    buff = ed.BuffCreate(binfo, target, source)
  end
  if buff then
    if bid == 931 or bid == 932 then
      buff.source = source
      buff.target = target
    end
    if bid == 929 then
      if not target.WhiteSnake_guRank then
        target.WhiteSnake_guRank = 1
        local cbinfo = ed.lookupDataTable("Buff", nil, 940)
        local appbuff = target:addBuff(cbinfo, source)
        target.WhiteSnake_guAppearanceBuff = appbuff
      elseif target.WhiteSnake_guRank < 5 then
        target.WhiteSnake_guRank = target.WhiteSnake_guRank + 1
      end
      return buff
    else
      local buffADD = target:addBuff(buff, source)
      return buffADD
    end
  end
end

function WhiteSnake.compareGu(count, target)
  local skillawake = target.skills.WhiteSnake_awake
  local guHP = math.floor(target.attribs.HP / WhiteSnake.guPercent)
  if not target.WhiteSnake_guCount then
    target.WhiteSnake_guCount = 0
  end
  if target.info.Name == "WhiteSnake" then
    target.WhiteSnake_guCount = target.WhiteSnake_guCount + count
    local buffAddCount = math.floor(target.WhiteSnake_guCount / guHP)
    if 1 <= buffAddCount then
      target.WhiteSnake_guCount = target.WhiteSnake_guCount - buffAddCount * guHP
      for i = 1, buffAddCount do
        local buff = WhiteSnake.searchAddBuff(929, target, target)
        if buff then
          buff.upgrade = override(buff.upgrade, WhiteSnake.guUpgrade)
          buff.update = override(buff.update, WhiteSnake.guUpdate)
          target:addBuff(buff, target)
          if skillawake and target.WhiteSnake_guRank and target.WhiteSnake_guRank == 5 and target.WhiteSnake_KnockRESSwitch == false then
            for selfUnit in ed.engine:foreachAliveUnit(target.camp) do
              local buff_temp = WhiteSnake.searchAddBuff(938, selfUnit, target)
            end
            target.WhiteSnake_KnockRESSwitch = true
          end
        end
      end
    end
  end
end

function WhiteSnake.skillult_update(basefunc, unit, dt)
  basefunc(unit, dt)
  unit.WhiteSnake_HPcollect_timer = unit.WhiteSnake_HPcollect_timer + 1
  if unit.WhiteSnake_HPcollect_timer == 8 then
    unit.WhiteSnake_HPcollect_timer = 0
    unit.WhiteSnake_ultHPCollect[unit.WhiteSnake_HPcollect_count] = unit.WhiteSnake_HeroHPCollect
    unit.WhiteSnake_HeroHPCollect = {}
    unit.WhiteSnake_HPcollect_count = unit.WhiteSnake_HPcollect_count + 1
    if unit.WhiteSnake_HPcollect_count == 4 then
      unit.WhiteSnake_HPcollect_count = 1
    end
  end
end

function WhiteSnake.guUpgrade(basefunc, buff, owner, caster, nextBuffInfo)
  local gu = basefunc(buff, owner, caster, nextBuffInfo)
  if owner then
    local bid = 939 + gu.rank
    WhiteSnake.searchAddBuff(bid, owner, owner)
    for i, ubuff in ipairs(owner.buff_list) do
      if ubuff.info.ID == bid - 1 then
        ubuff.timer = 0
      elseif ubuff.info.ID == bid then
        owner.WhiteSnake_guAppearanceBuff = ubuff
      end
    end
  end
  return gu
end

function WhiteSnake.guUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.timer - dt <= 0 then
    for selfUnit in ed.engine:foreachAliveUnit(buff.owner.camp) do
      for i, ubuff in ipairs(selfUnit.buff_list) do
        if ubuff.info.ID == 938 then
          ubuff.timer = 0
          local binfo = ed.lookupDataTable("Buff", nil, 945)
          local buff = selfUnit:addBuff(binfo, buff.owner)
        end
      end
    end
    buff.owner.WhiteSnake_KnockRESSwitch = false
  end
  buff.WhiteSnake_Has_changed = true
end

function WhiteSnake.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  WhiteSnake.searchAddBuff(939, target, skill.caster)
end

function WhiteSnake.skillatk2_createBuff(basefunc, skill, target)
  local atk2_buff = basefunc(skill, target)
  if atk2_buff then
    atk2_buff.update = override(atk2_buff.update, WhiteSnake.buff_sleep_update)
  end
  return atk2_buff
end

function WhiteSnake.buff_sleep_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hprC = math.abs(buff.info.HPR + (buff.caster.attribs[buff.info["HPR.x"]] or 0) * buff.info["HPR.a"] * dt)
  hprC = math.min(hprC, buff.owner.hp) * buff.owner.dPSStatisticsRatio
  WhiteSnake.compareGu(hprC, buff.caster)
  if not buff.caster:isAlive() and buff.owner.skill_count then
    buff.owner.skill_count = nil
  end
end

function WhiteSnake.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.WhiteSnake_is_firstAffected = true
  projectile.hit = override(projectile.hit, WhiteSnake.skillatk3_projectileHit)
  return projectile
end

function WhiteSnake.skillatk3_projectileHit(basefunc, projectile, target)
  if projectile.pre_select then
    table.insert(projectile.hit_list, target)
  elseif projectile.WhiteSnake_is_firstAffected == true then
    projectile.skill:takeEffectAt(target.position, projectile)
    projectile.WhiteSnake_is_firstAffected = false
  else
    return
  end
end

function WhiteSnake.skillatk3_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local skillatk3sub = skill.caster.skills.WhiteSnake_atk3sub
  skillatk3sub:takeEffectAt(skill.caster.position, skill.caster)
end

function WhiteSnake.skillatk3sub_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  if skill.caster.WhiteSnake_guRank then
    power = math.min(target.mp, skill.info["Basic Num"] + math.floor(skill.info["Script Arg2"]) * skill.caster.WhiteSnake_guRank)
  else
    power = math.min(target.mp, skill.info["Basic Num"])
  end
  return power, coefficient
end

function WhiteSnake.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local mp_damage = 0
  if skill.caster.WhiteSnake_guRank then
    mp_damage = math.min(target.mp, skill.info["Script Arg2"] + math.floor(skill.info["Script Arg3"]) * skill.caster.WhiteSnake_guRank)
  else
    mp_damage = math.min(target.mp, skill.info["Script Arg2"])
  end
  target:takeDamage(mp_damage, "Holy", "mp", skill.caster, 1, 1, 0)
end

function WhiteSnake.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.next_Target then
    if skill.count == 1 and skill.next_Target:isAlive() then
      target = skill.next_Target
    else
      for unit in ed.engine:foreachAliveUnit(skill.caster.foecamp) do
        if not unit.config.is_summoned then
          target = unit
          break
        end
      end
      skill.count = 0
      target.WhiteSnake_skill_reduce = 0
    end
  else
    for unit in ed.engine:foreachAliveUnit(skill.caster.foecamp) do
      if not unit.config.is_summoned then
        target = unit
        break
      end
    end
    skill.count = 0
    target.WhiteSnake_skill_reduce = 0
  end
  basefunc(skill, target, source, shift)
  if skill.count == 1 then
    if skill.caster.WhiteSnake_guRank then
      if not target.skill_count then
        target.skill_count = 0
      end
      if target.skill_count <= skill.caster.WhiteSnake_guRank then
        local max_damage = 200000
        if skill.caster.camp ~= ed.emCampPlayer and skill.caster.config.is_monster then
          max_damage = 50000
        end
        hp_damage = math.min(target.hp * skill.info["Script Arg2"], max_damage)
        target:takeDamage(hp_damage, "Holy", "hp", skill.caster, 1, 1, 0)
        target.WhiteSnake_skill_reduce = 0
        target.skill_count = 0
        skill.count = 0
        skill.next_Target = nil
        for _, buff in ipairs(target.buff_list) do
          if buff.info.ID == 930 then
            buff.timer = 0
          end
        end
      else
        local failBuff = WhiteSnake.searchAddBuff(937, target, skill.caster)
        if failBuff then
          failBuff.update = override(failBuff.update, WhiteSnake.buff_sleep_update)
        end
        target.skill_count = 0
        target.WhiteSnake_skill_reduce = target.WhiteSnake_skill_reduce + 1.5
        skill.cd_remaining = math.max(1, skill.cd_remaining - target.WhiteSnake_skill_reduce)
      end
    end
  else
    local stareBuff
    if target then
      stareBuff = WhiteSnake.searchAddBuff(930, target, skill.caster)
      if stareBuff then
        stareBuff.update = override(stareBuff.update, WhiteSnake.skillatk4_stareBuff_update)
        skill.next_Target = target
        target.skill_count = 0
        target.castSkill = override(target.castSkill, WhiteSnake.skillatk4_buffCast)
        skill.count = 1
      else
        skill.count = 0
        skill:finish("interrupt")
        skill.cd_remaining = 1
      end
    end
  end
end

function WhiteSnake.skillatk4_stareBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.caster:isAlive() then
    buff.timer = 0
    if buff.owner.skill_count then
      buff.owner.skill_count = nil
    end
  end
end

function WhiteSnake.skillatk4_buffCast(basefunc, unit, skill, target)
  basefunc(unit, skill, target)
  if skill and skill.info["Skill Name"] and string.sub(skill.info["Skill Name"], string.len(skill.info["Skill Name"]) - 3, string.len(skill.info["Skill Name"])) == "_atk" and unit.skill_count then
    unit.skill_count = unit.skill_count + 1
  end
end

function WhiteSnake.skillult_collectHPchange(basefunc, unit, config)
  basefunc(unit, config)
  if unit.quitCollectHPChange == true then
    return
  end
  if not config.unit.config.is_summoned then
    WhiteSnake.skillult_startChange(unit, config)
  end
end

function WhiteSnake.skillult_startChange(unit, config)
  local hp_change
  local skillawake = unit.skills.WhiteSnake_awake
  local skillult = unit.skills.WhiteSnake_ult
  hp_change = math.abs(config.hp_change)
  if hp_change ~= 0 then
    if config.hp_change < 0 then
      hp_change = math.min(hp_change, config.unit.hp)
    else
      hp_change = math.min(hp_change, config.unit.attribs.HP - config.unit.hp)
    end
    WhiteSnake.skillult_tableReset(unit, config)
    WhiteSnake.skillult_HPEXchange(skillult, config, unit, hp_change)
  end
  if skillawake then
    local percent = skillawake.info["Script Arg2"]
    local final_hpChange = hp_change * percent
    if config.unit.camp == unit.camp and config.hp_change < 0 then
      if not unit.WhiteSnake_guCount then
        unit.WhiteSnake_guCount = 0
      end
      local guHP = math.floor(unit.attribs.HP / WhiteSnake.guPercent)
      unit.WhiteSnake_guCount = unit.WhiteSnake_guCount + final_hpChange
      local buffAddCount = math.floor(unit.WhiteSnake_guCount / guHP)
      if 1 <= buffAddCount then
        unit.WhiteSnake_guCount = unit.WhiteSnake_guCount - buffAddCount * guHP
        for i = 1, buffAddCount do
          local buff = WhiteSnake.searchAddBuff(929, unit, unit)
          if buff then
            if unit.WhiteSnake_guRank == 1 then
              buff.WhiteSnake_Has_changed = false
            end
            if buff.WhiteSnake_Has_changed == false then
              buff.upgrade = override(buff.upgrade, WhiteSnake.guUpgrade)
              buff.update = override(buff.update, WhiteSnake.guUpdate)
            end
            unit:addBuff(buff, unit)
            if unit.WhiteSnake_guRank and unit.WhiteSnake_guRank == 5 and unit.WhiteSnake_KnockRESSwitch == false then
              for selfUnit in ed.engine:foreachAliveUnit(unit.camp) do
                WhiteSnake.searchAddBuff(938, selfUnit, unit)
              end
              unit.WhiteSnake_KnockRESSwitch = true
            end
          end
        end
      end
    end
  end
end

function WhiteSnake.skillult_tableReset(unit, config)
  if not unit.WhiteSnake_HeroHPCollect then
    unit.WhiteSnake_HeroHPCollect = {}
  end
  if not unit.WhiteSnake_HeroHPCollect[config.unit.camp] then
    unit.WhiteSnake_HeroHPCollect[config.unit.camp] = {}
    unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name] = {}
    unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name].hp_change = 0
  elseif not unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name] then
    unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name] = {}
    unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name].hp_change = 0
  end
  if not unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name].unit then
    unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name].unit = config.unit
  end
  unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name].hp_change = unit.WhiteSnake_HeroHPCollect[config.unit.camp][config.unit.info.Name].hp_change + config.hp_change
end

function WhiteSnake.skillult_HPEXchange(skill, config, unit, hp_change)
  if skill.unit_Blue and skill.unit_Red and skill.unit_Blue.WhiteSnake_connected and skill.unit_Red.WhiteSnake_connected then
    if skill.unit_Blue.WhiteSnake_no_cycle and skill.unit_Blue.WhiteSnake_no_cycle == true or skill.unit_Red.WhiteSnake_no_cycle and skill.unit_Red.WhiteSnake_no_cycle == true then
      skill.unit_Blue.WhiteSnake_no_cycle = false
      skill.unit_Red.WhiteSnake_no_cycle = false
      return
    end
    if not unit.WhiteSnake_guPercent then
      unit.WhiteSnake_guPercent = unit.skills.WhiteSnake_ult.info["Script Arg3"]
    end
    if config.unit == skill.unit_Blue then
      if config.unit.WhiteSnake_no_cycle == false then
        skill.unit_Red.WhiteSnake_no_cycle = true
        if math.floor(skill.unit_Blue.attribs.HPR * 0.125) == math.floor(config.hp_change) then
          skill.unit_Red.notPopupBattleInfo = true
        end
        local max_damage = 200000
        if unit.camp ~= ed.emCampPlayer and unit.config.is_monster then
          max_damage = 50000
        end
        local final_hpChange = math.min(max_damage, hp_change * unit.WhiteSnake_guPercent)
        unit.quitCollectHPChange = true
        if final_hpChange > skill.unit_Red.hp then
          final_hpChange = math.abs(skill.unit_Red.hp - 1)
        end
        skill.unit_Red:takeDamage(final_hpChange, "Holy", "hp", skill.unit_Blue, 1, 1, 0)
        unit.quitCollectHPChange = false
        skill.unit_Red.notPopupBattleInfo = false
      elseif config.unit.WhiteSnake_no_cycle == true then
        config.unit.WhiteSnake_no_cycle = false
      end
    elseif config.unit == skill.unit_Red then
      if config.unit.WhiteSnake_no_cycle == false then
        skill.unit_Blue.WhiteSnake_no_cycle = true
        if math.floor(skill.unit_Red.attribs.HPR * 0.125) == math.floor(config.hp_change) then
          skill.unit_Blue.notPopupBattleInfo = true
        end
        local max_damage = 200000
        if unit.camp ~= ed.emCampPlayer and unit.config.is_monster then
          max_damage = 50000
        end
        local final_hpChange = math.min(max_damage, hp_change * unit.WhiteSnake_guPercent)
        unit.quitCollectHPChange = true
        skill.unit_Blue:takeHeal(final_hpChange, "hp", skill.unit_Blue)
        unit.quitCollectHPChange = false
        skill.unit_Blue.notPopupBattleInfo = false
      elseif config.unit.WhiteSnake_no_cycle == true then
        config.unit.WhiteSnake_no_cycle = false
      end
    end
  end
end

function WhiteSnake.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
end

function WhiteSnake.skillult_takeEffectAt(basefunc, skill, location, source)
  local HPcollect_temp = {}
  for count_temp, a_ in pairs(skill.caster.WhiteSnake_ultHPCollect) do
    for camp_temp, b_ in pairs(a_) do
      for unit, c_ in pairs(b_) do
        if not HPcollect_temp[camp_temp] then
          HPcollect_temp[camp_temp] = {}
          HPcollect_temp[camp_temp][unit] = {}
          HPcollect_temp[camp_temp][unit].hp_change = 0
        elseif not HPcollect_temp[camp_temp][unit] then
          HPcollect_temp[camp_temp][unit] = {}
          HPcollect_temp[camp_temp][unit].hp_change = 0
        end
        HPcollect_temp[camp_temp][unit].hp_change = HPcollect_temp[camp_temp][unit].hp_change + c_.hp_change
        if not HPcollect_temp[camp_temp][unit].unit then
          HPcollect_temp[camp_temp][unit].unit = c_.unit
        end
      end
    end
  end
  if skill.attack_counter == 1 then
    if HPcollect_temp[-skill.caster.camp] then
      for _, unit_r in pairs(HPcollect_temp[-skill.caster.camp]) do
        if not unit_r.unit.config.is_summoned and not unit_r.buff_effects_untargetable and unit_r.unit:isAlive() then
          if not skill.unit_Red.hp_change then
            skill.unit_Red = unit_r.unit
            skill.unit_Red.WhiteSnake_connected = false
          elseif unit_r.hp_change > skill.unit_Red.hp_change then
            skill.unit_Red = unit_r.unit
            skill.unit_Red.WhiteSnake_connected = false
          end
        end
      end
    else
      for unit in ed.engine:foreachAliveUnit(-skill.caster.camp) do
        if not unit.config.is_summoned then
          skill.unit_Red = unit
        end
      end
    end
    if HPcollect_temp[skill.caster.camp] then
      for _, unit_b in pairs(HPcollect_temp[skill.caster.camp]) do
        if not unit_b.unit.config.is_summoned and not unit_b.buff_effects_untargetable and unit_b.unit:isAlive() then
          if not skill.unit_Blue.hp_change then
            skill.unit_Blue = unit_b.unit
            skill.unit_Blue.WhiteSnake_connected = false
          elseif unit_b.hp_change > skill.unit_Blue.hp_change then
            skill.unit_Blue = unit_b.unit
            skill.unit_Blue.WhiteSnake_connected = false
          end
        end
      end
    else
      skill.unit_Blue = skill.caster
      skill.unit_Blue.WhiteSnake_connected = false
    end
    if skill.unit_Blue and skill.unit_Red then
      skill.buff_R2B = WhiteSnake.searchAddBuff(932, skill.unit_Blue, skill.unit_Red)
    end
  elseif skill.attack_counter == 2 then
    if skill.unit_Blue and skill.unit_Red then
      if next(skill.unit_Blue) == nil then
        for unitB in ed.engine:foreachAliveUnit(skill.caster.camp) do
          if not unitB.config.is_summoned then
            skill.unit_Blue = unitB
          end
        end
      end
      if next(skill.unit_Red) == nil then
        for unitR in ed.engine:foreachAliveUnit(-skill.caster.camp) do
          if not unitR.config.is_summoned then
            skill.unit_Red = unitR
          end
        end
      end
      skill.buff_B2R = WhiteSnake.searchAddBuff(931, skill.unit_Red, skill.unit_Blue)
    else
      skill.buff_R2B = nil
      skill.buff_B2R = nil
    end
    if skill.buff_R2B and skill.buff_B2R then
      skill.buff_R2B.WhiteSnake_ud = 0
      skill.buff_B2R.WhiteSnake_ud = 0
      skill.buff_R2B.WhiteSnake_coupBuff = skill.buff_B2R
      skill.buff_B2R.WhiteSnake_coupBuff = skill.buff_R2B
      if skill.buff_R2B.WhiteSnake_ud == 0 then
        skill.buff_R2B.update = override(skill.buff_R2B.update, WhiteSnake.skillult_buffUpdate)
      end
      if skill.buff_B2R.WhiteSnake_ud == 0 then
        skill.buff_B2R.update = override(skill.buff_B2R.update, WhiteSnake.skillult_buffUpdate)
      end
      if skill.caster.WhiteSnake_guRank then
        skill.caster.WhiteSnake_guPercent = skill.info["Script Arg2"] * skill.caster.WhiteSnake_guRank + skill.info["Script Arg3"]
      else
        skill.caster.WhiteSnake_guPercent = skill.info["Script Arg3"]
      end
      if skill.unit_Red and skill.unit_Blue then
        skill.unit_Red.WhiteSnake_connected = true
        skill.unit_Blue.WhiteSnake_connected = true
        skill.unit_Red.WhiteSnake_no_cycle = false
        skill.unit_Blue.WhiteSnake_no_cycle = false
        for i, obuff in ipairs(skill.caster.buff_list) do
          if obuff.info.ID == 929 then
            obuff.timer = 0
          elseif skill.caster.WhiteSnake_guAppearanceBuff and obuff.info.ID == skill.caster.WhiteSnake_guAppearanceBuff.info.ID then
            obuff.timer = 0
          end
        end
        skill.caster.WhiteSnake_guRank = nil
      end
    end
  end
  basefunc(skill, location, source)
end

function WhiteSnake.skillult_buffUpdate(basefunc, buff, dt)
  buff.WhiteSnake_ud = 1
  if not buff.WhiteSnake_coupBuff.owner:isAlive() or buff.owner.WhiteSnake_connected == false or buff.WhiteSnake_coupBuff.owner.buff_effects.untargetable then
    buff.timer = 0
    if buff.WhiteSnake_coupBuff then
      buff.WhiteSnake_coupBuff.timer = 0
    end
  end
  basefunc(buff, dt)
  if buff.timer < 0 then
    buff.owner.WhiteSnake_connected = nil
    buff.owner.WhiteSnake_no_cycle = nil
  end
end

function WhiteSnake.init_hero(hero)
  local skillatk = hero.skills.WhiteSnake_atk
  local skillatk2 = hero.skills.WhiteSnake_atk2
  local skillatk3 = hero.skills.WhiteSnake_atk3
  local skillatk4 = hero.skills.WhiteSnake_atk4
  local skillult = hero.skills.WhiteSnake_ult
  local skillatk3sub = hero.skills.WhiteSnake_atk3sub
  hero.WhiteSnake_KnockRESSwitch = false
  hero.WhiteSnake_guCount = 0
  hero.WhiteSnake_HeroHPCollect = {}
  hero.WhiteSnake_ultHPCollect = {}
  hero.WhiteSnake_HPcollect_timer = 0
  hero.WhiteSnake_HPcollect_count = 1
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WhiteSnake.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, WhiteSnake.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, WhiteSnake.skillatk3_createProjectile)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, WhiteSnake.skillatk3_takeEffectAt)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WhiteSnake.skillatk3_takeEffectOn)
    skillatk3sub.power = override(skillatk3sub.power, WhiteSnake.skillatk3sub_power)
  end
  if skillatk4 then
    skillatk4.count = 0
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WhiteSnake.skillatk4_takeEffectOn)
  end
  if skillult then
    skillult.unit_Blue = {}
    skillult.unit_Red = {}
    hero.collectHPchange = override(hero.collectHPchange, WhiteSnake.skillult_collectHPchange)
    hero.update = override(hero.update, WhiteSnake.skillult_update)
    skillult.start = override(skillult.start, WhiteSnake.skillult_start)
    skillult.takeEffectAt = override(skillult.takeEffectAt, WhiteSnake.skillult_takeEffectAt)
  end
  return hero
end

return WhiteSnake.init_hero
