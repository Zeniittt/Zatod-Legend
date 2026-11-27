module("ed.battlehero", package.seeall)
local ed = ed
TitanMW = {}
TitanMW.TitanMW_buff_disarm_ID = 4159
TitanMW.TitanMW_buff_atk2_stun_ID = 4160
TitanMW.TitanMW_buff_atk3_escape = 4162
TitanMW.TitanMW_buff_atk4_shield = 4163
TitanMW.TitanMW_buff_invis_ID = 4164
TitanMW.TitanMW_buff_mist_ID = 4165
TitanMW.TitanMW_buff_atk2_charm = 4166
TitanMW.TitanMW_buff_ult_misthide = 4174
TitanMW.TitanMW_buff_atk3_shield_ID = 4161
TitanMW.TitanMW_buff_mist3_ID = 4178
TitanMW.TitanMW_Arcana_mist_buffID = 4264
TitanMW.TitanMW_Arcana_mist_PIMU_debuffID = 4265
TitanMW.TitanMW_fashionID = 100821
TitanMW.mistUIPosition = {25, 14}

function TitanMW.hero_reset(basefunc, hero)
  basefunc(hero)
  local alive = true
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit ~= hero and not unit.config.is_summoned and not unit.config.is_monster and not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and not unit.buff_effects.enchanted and not unit.buffManager.invisible and unit.position[1] > -100 and unit.position[1] < 900 and unit:isAlive() then
      alive = false
    end
  end
  if alive == false and not hero.buff_effects.polymorph then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_invis_ID)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
    TitanMW.SHBuffEffect(hero, false)
  elseif alive == true then
    hero.TitanMW_hide = false
    local skillenter = hero.skills.TitanMW_enter
    if skillenter then
      skillenter.cd_remaining = 999
    end
  end
  local skillatk2 = hero.skills.TitanMW_atk2
  local skillatk3 = hero.skills.TitanMW_atk3
  local skillatk2a = hero.skills.TitanMW_atk2a
  local skillatk3a = hero.skills.TitanMW_atk3a
  if hero.TitanMW_hasArcana and hero.TitanMW_hasArcana > 2 then
    if skillatk2 then
      skillatk2.cd_remaining = 999
      skillatk2a.cd_remaining = skillatk2.info["Init CD"]
    end
    if skillatk3 then
      skillatk3.cd_remaining = 999
      skillatk3a.cd_remaining = skillatk3.info["Init CD"]
    end
  end
end

function TitanMW.skillenter_finish(basefunc, skill, reason)
  basefunc(skill)
  local hero = skill.caster
  if ed.run_with_scene then
    local effectx = "eff_point_TitanMW_mist.cha"
    hero.TitanMW_mist_effect = ed.scene:playEffectOnScene(effectx, {400, -40}, nil, nil, 1)
  end
  hero:walkTowards({
    hero.position[1],
    hero.position[2] - 10
  })
end

function TitanMW.count_distance(unita, unitb)
  local dis
  dis = math.abs(unita.position[1] - unitb.position[1])
  return dis
end

function TitanMW.count_unit(hero)
  local unit_a, unit_b, unit_c, d_a, d_b, d_c
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    local jump_out = false
    for i, buff in ipairs(unit.buff_list) do
      if buff.info.ID == TitanMW.TitanMW_buff_mist_ID and buff.rank > 2 then
        jump_out = true
      end
    end
    if jump_out == false and TitanMW.count_distance(unit, hero) > 0 then
      local unit_temp = unit_a and unit_b and unit_c
      if not unit_temp then
        if unit_temp == unit_a then
          unit_a = unit
          d_a = TitanMW.count_distance(unit, hero)
        elseif unit_temp == unit_b then
          unit_b = unit
          d_b = TitanMW.count_distance(unit, hero)
        else
          unit_c = unit
          d_c = TitanMW.count_distance(unit, hero)
        end
      else
        local d_temp = TitanMW.count_distance(unit, hero)
        if d_a > d_temp then
          unit_a = unit
          d_a = d_temp
        elseif d_b > d_temp then
          unit_b = unit
          d_b = d_temp
        elseif d_c > d_temp then
          unit_c = unit
          d_c = d_temp
        end
      end
    end
  end
  return unit_a, unit_b, unit_c
end

function TitanMW.mist3Buff_onRemoved(basefunc, buff)
  local unit = buff.owner
  for i, Mbuff3 in ipairs(unit.buff_list) do
    if Mbuff3.info.ID == TitanMW.TitanMW_buff_mist3_ID then
      Mbuff3.timer = 0
    end
  end
  basefunc(buff)
end

function TitanMW.addMistBuff(unit, hero)
  local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_mist_ID)
  local buff = ed.BuffCreate(binfo, unit, hero)
  local temp_judge = true
  for i, Mbuff3 in ipairs(unit.buff_list) do
    if Mbuff3.info.ID == TitanMW.TitanMW_buff_mist_ID then
      temp_judge = false
    end
  end
  if temp_judge == true then
    buff.onRemoved = override(buff.onRemoved, TitanMW.mist3Buff_onRemoved)
  end
  local skillatk4 = hero.skills.TitanMW_atk4
  unit:addBuff(buff, hero)
  if hero.TitanMW_hasArcana and hero.TitanMW_hasArcana > 1 then
    local hasbuff
    for i, bbbuff in ipairs(unit.buff_list) do
      if bbbuff.info.ID == TitanMW.TitanMW_Arcana_mist_buffID then
        hasbuff = true
      end
    end
    if not hasbuff then
      local bbinfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_Arcana_mist_buffID)
      local bbuff = ed.BuffCreate(bbinfo, unit, hero)
      bbuff.update = override(bbuff.update, TitanMW.Arcana_mist_buff_update)
      unit:addBuff(bbuff, hero)
    end
  end
  for i, Mbuff in ipairs(unit.buff_list) do
    if Mbuff.info.ID == TitanMW.TitanMW_buff_mist_ID and Mbuff.rank > 2 then
      local binfo3 = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_mist3_ID)
      local buff3 = ed.BuffCreate(binfo3, unit, hero)
      unit:addBuff(buff3, hero)
      if skillatk4 then
        hero.TitanMW_shield = hero.TitanMW_shield + skillatk4.info["Script Arg2"] * hero.attribs.AP
      end
      if unit.camp == hero.camp and not unit.TitanMW_buff_triggered then
        unit.TitanMW_buff_triggered = true
        local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk3_escape)
        local buffE = ed.BuffCreate(binfo, unit, hero)
        buffE.onDamaged = override(buffE.onDamaged, TitanMW.skillatk3_buff_onDamaged)
        unit:addBuff(buffE, hero)
      elseif unit.camp ~= hero.camp and not unit.TitanMW_buff_triggered then
        unit.TitanMW_buff_triggered = true
        local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk2_charm)
        local buffC = ed.BuffCreate(binfo, unit, hero)
        unit:addBuff(buffC, hero)
      end
    end
  end
end

function TitanMW.skillatk3_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if damage > buff.owner.attribs.HP * 0.15 and damage < buff.owner.attribs.HP then
    damage = 0
    buff.timer = 0
  end
  return damage
end

function TitanMW.skills_onPhaseFinished(basefunc, skill)
  local hero = skill.caster
  local alive = false
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit ~= hero and not unit.config.is_summoned and not unit.config.is_monster and not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and not unit.buff_effects.enchanted and not unit.buffManager.invisible and unit.position[1] > -100 and unit.position[1] < 900 and unit:isAlive() then
      alive = true
    end
  end
  if alive == false then
    hero.TitanMW_hide = false
  else
    hero.TitanMW_hide = true
  end
  if skill.current_phase_idx == 2 and hero.TitanMW_show == true then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk4_shield)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.shield = hero.TitanMW_shield
    hero:addBuff(buff, hero)
    hero.TitanMW_show = nil
    skill:finish()
    return
  elseif skill.current_phase_idx == 2 and hero.TitanMW_hide == false then
    skill:finish()
    return
  else
    basefunc(skill)
  end
end

function TitanMW.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local counter = 40
  if not hero.TitanMW_hasArcana or hero.TitanMW_hasArcana > 3 then
  end
  if counter <= hero.TitanMW_MistCount then
    hero.TitanMW_MistCount = 0
    local unit_a, unit_b, unit_c = TitanMW.count_unit(hero)
    if unit_a then
      TitanMW.addMistBuff(unit_a, hero)
    end
    if unit_b then
      TitanMW.addMistBuff(unit_b, hero)
    end
    if unit_c then
      TitanMW.addMistBuff(unit_c, hero)
    end
  end
  hero.TitanMW_MistCount = hero.TitanMW_MistCount + 1
end

function TitanMW.Arcana_mist_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local unit = buff.owner
  local caster = buff.caster
  buff.TitanMW_mist_timer = buff.TitanMW_mist_timer and buff.TitanMW_mist_timer + dt or dt
  if buff.TitanMW_mist_timer > 15 and unit.TitanMW_buff_triggered then
    buff.TitanMW_mist_timer = 0
    unit.TitanMW_buff_triggered = nil
    for i, bbuff in ipairs(unit.buff_list) do
      if bbuff.info.ID == TitanMW.TitanMW_buff_mist_ID and bbuff.rank > 2 and caster and unit then
        if unit.camp == caster.camp and not unit.TitanMW_buff_triggered then
          unit.TitanMW_buff_triggered = true
          local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk3_escape)
          local buffE = ed.BuffCreate(binfo, unit, caster)
          buffE.onDamaged = override(buffE.onDamaged, TitanMW.skillatk3_buff_onDamaged)
          unit:addBuff(buffE, caster)
        elseif unit.camp ~= caster.camp and not unit.TitanMW_buff_triggered then
          unit.TitanMW_buff_triggered = true
          local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk2_charm)
          local buffC = ed.BuffCreate(binfo, unit, caster)
          unit:addBuff(buffC, caster)
        end
      end
    end
  end
end

function TitanMW.skills_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    power = 0
  end
  return power, coeff
end

function TitanMW.skills_finish(basefunc, skill, reason)
  local caster = skill.caster
  basefunc(skill, reason)
  skill.TitanMW_mistattack = nil
  skill.TitanMW_mistunit = nil
  if caster.TitanMW_hide == true and not caster.buff_effects.polymorph then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_invis_ID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
    TitanMW.SHBuffEffect(caster, false)
  end
end

function TitanMW.skillult_finish(basefunc, skill, reason)
  local caster = skill.caster
  basefunc(skill, reason)
  if caster.TitanMW_hide == true and not caster.buff_effects.polymorph then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_invis_ID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
    TitanMW.SHBuffEffect(caster, false)
  end
end

function TitanMW.skillatk_finish(basefunc, skill, reason)
  local caster = skill.caster
  basefunc(skill, reason)
  if caster.TitanMW_hide == true and not caster.buff_effects.polymorph then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_invis_ID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
    TitanMW.SHBuffEffect(caster, false)
  end
end

function TitanMW.skills_start(basefunc, skill, target)
  local caster = skill.caster
  local phaseidx = 1
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanMW.TitanMW_buff_invis_ID then
      TitanMW.SHBuffEffect(caster, true)
      buff.timer = 0
    end
  end
  local info = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  if skill.caster.taunter and skill.info["Target Type"] ~= "self" then
    if target then
      if target.camp ~= skill:targetCamp() then
        skill:selectTarget(target)
      else
      end
    else
      skill:selectTarget(target)
    end
  else
    skill:selectTarget(target)
  end
  local target2 = skill.target
  if caster.TitanMW_hide == true then
    local alive = false
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit ~= caster and not unit.config.is_summoned and not unit.config.is_monster and not unit.config.is_monster and not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and not unit.buff_effects.enchanted and not unit.buff_effects.enchanted and not unit.buffManager.invisible and unit.position[1] > -100 and unit.position[1] < 900 and unit:isAlive() then
        alive = true
      end
    end
    if alive == false then
      caster.TitanMW_show = true
    end
    if target2.camp ~= caster.camp then
      if skill.info["Skill Name"] == "TitanMW_atk" or skill.info["Skill Name"] == "TitanMW_atktrue" then
        caster.position[1] = math.max(math.min(target2.position[1] - target2.direction * 80, 780), 20)
      else
        caster.position[1] = math.max(math.min(target2.position[1] - target2.direction * 120, 780), 20)
      end
      caster.direction = target2.direction
    else
      caster.position[1] = math.max(math.min(target2.position[1] - target2.direction * 100, 780), 20)
      caster.direction = target2.direction
    end
    caster.position[2] = target2.position[2] - 20
  else
    phaseidx = 2
  end
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  skill:startPhase(phaseidx)
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function TitanMW.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    return false
  end
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk2_stun_ID)
  local buff = ed.BuffCreate(binfo, target, caster)
  target:addBuff(buff, caster)
  basefunc(skill, target, source, shift)
  if caster.TitanMW_hasArcana and caster.TitanMW_hasArcana > 2 and target and target:isAlive() then
    if target.attribs.PIMU > 500 then
      return
    end
    local bbinfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_Arcana_mist_PIMU_debuffID)
    local bbuff = ed.BuffCreate(bbinfo, target, caster)
    local pimu = math.floor(target.attribs.PIMU / 10) + 1
    local pimu_new = -1 * math.min(50, pimu * 5)
    bbuff:setAttribute("PIMU", pimu_new)
    target:addBuff(bbuff, caster)
  end
end

function TitanMW.skillatks_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if caster.TitanMW_hasArcana and caster.TitanMW_hasArcana > 2 and skill.current_phase_idx == 2 then
    local direction = caster.direction
    local origin = {
      location[1] + skill.info["X Shift"] * direction,
      location[2]
    }
    local list = skill:collectAoeTarget(origin, direction)
    for k, unit in ipairs(list) do
      for i, bbuff in ipairs(unit.buff_list) do
        if bbuff.info.ID == TitanMW.TitanMW_buff_mist_ID and unit.camp == skill:affectedCamp() then
          skill.TitanMW_mistunit = skill.TitanMW_mistunit and skill.TitanMW_mistunit + 1 or 1
          skill.TitanMW_mistattack = skill.TitanMW_mistattack and skill.TitanMW_mistattack + bbuff.rank or bbuff.rank
        end
      end
    end
  end
  basefunc(skill, location, source)
end

function TitanMW.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 3 then
    return false
  end
  local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_atk3_shield_ID)
  local buff = ed.BuffCreate(binfo, target, caster)
  local shield_level = 0
  for i, Mbuff in ipairs(target.buff_list) do
    if Mbuff.info.ID == TitanMW.TitanMW_buff_mist_ID then
      shield_level = Mbuff.rank
    end
  end
  if caster.TitanMW_hasArcana and 1 < caster.TitanMW_hasArcana and skill.TitanMW_mistattack then
    shield_level = skill.TitanMW_mistattack
  end
  buff.shield = buff.shield + skill.info["Script Arg4"] + shield_level * caster.attribs.AP * skill.info["Script Arg3"]
  buff.TitanMW_shieldlevel = shield_level
  if TitanMW.TitanMW_fashionID and TitanMW.TitanMW_fashionID == caster.fashion_id then
    buff:setAttribute("HPR", 3000)
  end
  buff.onRemoved = override(buff.onRemoved, TitanMW.atk3buff_onRemoved)
  target:addBuff(buff, caster)
  basefunc(skill, target, source, shift)
end

function TitanMW.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if skill.current_phase_idx ~= 1 and skill.current_phase_idx ~= 3 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_disarm_ID)
    local buff = ed.BuffCreate(binfo, target, caster)
    local disarm = power * skill.info["Script Arg2"]
    local counter = 0
    local rank = 0
    for i, Mbuff in ipairs(target.buff_list) do
      if Mbuff.info.ID == TitanMW.TitanMW_buff_mist_ID then
        rank = Mbuff.rank
        counter = Mbuff.rank
      end
    end
    if caster.TitanMW_hasArcana and 1 < caster.TitanMW_hasArcana then
      if skill.TitanMW_mistattack then
        counter = skill.TitanMW_mistattack
      end
      local units = skill.TitanMW_mistunit or 1
      if rank and counter and 1 < counter / rank then
        power = power * math.min(units, 3) * math.min(1 + 0.06 * counter, 1.5) * (rank + 1) / (counter + units)
      end
    end
    disarm = power * (skill.info["Script Arg2"] + counter * skill.info["Script Arg3"])
    disarm = -1 * disarm
    buff:setAttribute("ARM", disarm)
    buff:setAttribute("MR", disarm)
    target:addBuff(buff, caster)
  end
  return power, coeff
end

function TitanMW.atk3buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk3b = caster.skills.TitanMW_atk3b
  if skillatk3b then
    skillatk3b.TitanMW_shieldlevel = buff.TitanMW_shieldlevel
    skillatk3b:takeEffectOn(buff.owner, caster)
  end
end

function TitanMW.skillatk3b_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and skill.caster.attribs[info["Plus Attr"]] or 0
  local shield_level = skill.TitanMW_shieldlevel or 1
  for i, Mbuff in ipairs(target.buff_list) do
    if Mbuff.info.ID == TitanMW.TitanMW_buff_mist_ID then
      shield_level = shield_level + Mbuff.rank
    end
  end
  local power = multiplier * base_attrib + info["Basic Num"] * shield_level
  local ratio1 = 0
  local ratio2 = 0
  if damage_type and damage_type ~= "Heal" then
    if target then
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.name == "ExtraDamageBuff_damaged" and tbuff:checkExtraDamageCondition(source, damage_type, power) and tbuff.extraDamageValue and ratio1 <= 1 then
          ratio1 = ratio1 + tbuff.extraDamageValue
        end
      end
    end
    if skill.extraDamageRatio then
      ratio2 = ratio2 + skill.extraDamageRatio
    end
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.name == "ExtraDamageBuff_attack" and tbuff.extraDamageValue and 0 < tbuff.timer and ratio2 <= 1 then
        ratio2 = ratio2 + tbuff.extraDamageValue
        tbuff.timer = 0
      end
    end
    skill.extraDamageRatio = ratio2
  end
  return power * (1 + ratio1 + ratio2), 1
end

function TitanMW.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 2 then
    if skill.TitanMW_ult_count == 0 then
      skill.TitanMW_ult_count = skill.TitanMW_ult_count + 1
      if ed.run_with_scene then
        local effectx = "eff_point_TitanMW_ult.cha"
        local effect = ed.scene:playEffectOnScene(effectx, caster.position, {
          caster.direction,
          1
        }, nil, -1)
      end
    else
      skill.TitanMW_ult_count = 0
      if caster.manually_casting then
        ed.engine:unfreeze()
        caster.manually_casting = false
      end
      skill.attack_counter = skill.attack_counter + 1
      local skillultb = caster.skills.TitanMW_ultb
      caster.TitanMW_ult_mist_counter = 0
      for Munit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
        for i, buff in ipairs(Munit.buff_list) do
          if buff.info.ID == TitanMW.TitanMW_buff_mist_ID then
            caster.TitanMW_ult_mist_counter = caster.TitanMW_ult_mist_counter + buff.rank
            if not caster.TitanMW_hasArcana or caster.TitanMW_hasArcana and caster.TitanMW_hasArcana < 4 then
              Munit:removeBuff(buff)
            end
          end
        end
      end
      if skillultb then
        skillultb:takeEffectAt(caster.position)
      end
      if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
        skill:selectTarget(nil)
      end
      if not skill.target then
        return
      end
      local info = skill.info
      local ttype = info["Track Type"]
      local MPGR = caster.attribs.MPGainRatio or 1
      skill:createTrackType(ttype)
      if MPGR then
        caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      end
      if info["Move Forward"] ~= 0 then
        caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
      end
    end
  end
end

function TitanMW.SHBuffEffect(unit, value)
  for i, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor and buff.timer > 0 then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(value)
      end
    end
  end
end

function TitanMW.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  if target and target:isAlive() and not target.config.is_summoned then
    target:addBuff(skill:createBuff(target))
  end
  basefunc(skill, target, source, shift)
end

function TitanMW.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  if skill.current_phase_idx == 2 then
    buff.onRemoved = override(buff.onRemoved, TitanMW.skillult_buff_onRemoved)
    buff.timer = buff.timer + skill.info["Script Arg3"] * caster.TitanMW_ult_mist_counter
    target.TitanMW_ultbuff_enemy = true
    target:setHpVisible(false)
    target:setFuryVisible(false)
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      local binfoMH = ed.lookupDataTable("Buff", nil, TitanMW.TitanMW_buff_ult_misthide)
      local buffMH = ed.BuffCreate(binfoMH, unit, caster)
      buffMH.onRemoved = override(buffMH.onRemoved, TitanMW.buffMH_onRemoved)
      buffMH.timer = buffMH.timer + skill.info["Script Arg3"] * caster.TitanMW_ult_mist_counter
      unit:addBuff(buffMH, caster)
      if unit.heroPanel then
        unit.heroPanel:setHpCloudVisible(true)
      end
    end
  end
  return buff
end

function TitanMW.buffMH_onRemoved(basefunc, buff)
  local owner = buff.owner
  if owner.heroPanel then
    owner.heroPanel:setHpCloudVisible(false)
  end
  basefunc(buff)
end

function TitanMW.skillult_buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  owner.TitanMW_ultbuff_enemy = nil
  if owner.TitanMW_ultbuff_return_mp and owner.TitanMW_ultbuff_return_mp == true then
    owner.TitanMW_ultbuff_return_mp = nil
  end
  owner:setHpVisible(true)
  owner:setFuryVisible(true)
  basefunc(buff)
end

function TitanMW.skillultb_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  power = power + skill.info["Script Arg2"] * skill.caster.TitanMW_ult_mist_counter
  return power, coeff
end

function TitanMW.hero_onDying(basefunc, hero, skiller)
  if hero.TitanMW_mist_effect then
    ed.scene:removeEffect(hero.TitanMW_mist_effect, 1)
  end
  basefunc(hero, skiller)
end

function TitanMW.init_hero(hero)
  local skillatk = hero.skills.TitanMW_atk
  local skillatk2 = hero.skills.TitanMW_atk2
  local skillatk3 = hero.skills.TitanMW_atk3
  local skillatk3b = hero.skills.TitanMW_atk3b
  local skillult = hero.skills.TitanMW_ult
  local skillultb = hero.skills.TitanMW_ultb
  local skillenter = hero.skills.TitanMW_enter
  hero.TitanMW_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if hero.TitanMW_hasArcana > 2 then
    skillatk2 = hero.skills.TitanMW_atk2a
    skillatk3 = hero.skills.TitanMW_atk3a
  end
  hero.TitanMW_ally_alive = true
  hero.reset = override(hero.reset, TitanMW.hero_reset)
  hero.update = override(hero.update, TitanMW.hero_update)
  hero.TitanMW_shield = 0
  hero.TitanMW_MistCount = 0
  hero.TitanMW_ult_mist_counter = 0
  hero.TitanMW_hide = true
  hero.onDying = override(hero.onDying, TitanMW.hero_onDying)
  if skillenter then
    skillenter.finish = override(skillenter.finish, TitanMW.skillenter_finish)
  end
  if skillatk then
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, TitanMW.skills_onPhaseFinished)
    skillatk.power = override(skillatk.power, TitanMW.skills_power)
    skillatk.finish = override(skillatk.finish, TitanMW.skillatk_finish)
    skillatk.start = override(skillatk.start, TitanMW.skills_start)
  end
  if skillatk2 then
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, TitanMW.skills_onPhaseFinished)
    skillatk2.power = override(skillatk2.power, TitanMW.skillatk2_power)
    skillatk2.finish = override(skillatk2.finish, TitanMW.skills_finish)
    skillatk2.start = override(skillatk2.start, TitanMW.skills_start)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanMW.skillatk2_takeEffectOn)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, TitanMW.skillatks_takeEffectAt)
  end
  if skillatk3 then
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, TitanMW.skills_onPhaseFinished)
    skillatk3.power = override(skillatk3.power, TitanMW.skills_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanMW.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, TitanMW.skills_finish)
    skillatk3.start = override(skillatk3.start, TitanMW.skills_start)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, TitanMW.skillatks_takeEffectAt)
    skillatk3b.power = override(skillatk3b.power, TitanMW.skillatk3b_power)
  end
  if skillult then
    skillult.TitanMW_ult_count = 0
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, TitanMW.skills_onPhaseFinished)
    skillult.finish = override(skillult.finish, TitanMW.skillult_finish)
    skillult.start = override(skillult.start, TitanMW.skills_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanMW.skillult_onAttackFrame)
    skillultb.power = override(skillultb.power, TitanMW.skillultb_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanMW.skillult_takeEffectOn)
    skillult.createBuff = override(skillult.createBuff, TitanMW.skillult_createBuff)
  end
  return hero
end

return TitanMW.init_hero
