module("ed.battlehero", package.seeall)
local ed = ed
TitanLeorio = {}
TitanLeorio.invulnerableBuff = 4488
TitanLeorio.untargetableBuff = 4489
TitanLeorio.atk2_STRDown = 4486
TitanLeorio.atk3_STRDown = 4487
TitanLeorio.Charge_range = 75
TitanLeorio.charge_speed = 250

function TitanLeorio.skillatk_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk = caster.skills.TitanLeorio_atk
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster:isAlive() and skillatk and caster.TitanLeorio_hasArcana >= 4 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.STR and tbuff.info.STR <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.STR) + caster.attribs.STR)
      end
    end
  end
  return power, coeff
end

function TitanLeorio.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and caster.TitanLeorio_hasArcana >= 2 and target and isHit then
    local bid = TitanLeorio.atk2_STRDown
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo, target, caster)
    buff1.CreatedByHunterHunter = true
    buff1:setAttribute("STR", -math.min(target.attribs.STR * 0.3, caster.attribs.STR * 2))
    buff1:setAttribute("ARM", -math.min(target.attribs.ARM * 0.2, 3000))
    buff1:setAttribute("MR", -math.min(target.attribs.MR * 0.2, 3000))
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanLeorio.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLeorio_atk2
  if caster and skillatk2 then
    local invbid = TitanLeorio.invulnerableBuff
    local binfo1 = ed.lookupDataTable("Buff", nil, invbid)
    local buff1 = ed.BuffCreate(binfo1, caster, caster)
    caster.TitanLeorio_invbuff = caster:addBuff(buff1, caster)
  end
end

function TitanLeorio.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk2 = caster.skills.TitanLeorio_atk2
  if caster and skillatk2 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == TitanLeorio.invulnerableBuff then
        tbuff.timer = -1
      end
    end
    if target then
      target:hurt()
      local effect_name = "eff_impact_TitanLeorio_atk2.cha"
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, {
          target.position[1],
          target.position[2]
        }, {
          target.direction,
          1
        }, nil, 1)
      end
    end
  end
end

function TitanLeorio.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and caster.TitanLeorio_hasArcana >= 2 and target and isHit then
    local bid = TitanLeorio.atk2_STRDown
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo, target, caster)
    buff1.CreatedByHunterHunter = true
    buff1:setAttribute("STR", -math.min(target.attribs.STR * 0.3, caster.attribs.STR * 2))
    buff1:setAttribute("ARM", -math.min(target.attribs.ARM * 0.2, 3000))
    buff1:setAttribute("MR", -math.min(target.attribs.MR * 0.2, 3000))
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanLeorio.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local buff_stunTime = 0
  buff.CreatedByHunterHunter = true
  if caster and owner then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.STR and 0 >= tbuff.info.STR then
        buff_stunTime = math.abs(tbuff.info.STR * 0.01)
      end
    end
  end
  buff.timer = buff.timer + buff_stunTime
  buff.timer = math.min(buff.timer, 9)
  return buff
end

function TitanLeorio.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLeorio_atk2
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster:isAlive() and skillatk2 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.STR and tbuff.info.STR <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.STR) + caster.attribs.STR * 2)
      end
    end
  end
  return power, coeff
end

function TitanLeorio.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.CreatedByHunterHunter = true
  buff.onDamaged = override(buff.onDamaged, TitanLeorio.skillatk3_buffOnDamaged)
  return buff
end

function TitanLeorio.skillatk3_buffOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local info = buff.info
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanLeorio_atk3
  local Damage_down = (100 - skillatk3.info["Script Arg2"]) / 100
  local STR_down = (100 - skillatk3.info["Script Arg3"]) / 100
  if damage and damage_type and Damage_down then
    if Damage_down and owner ~= caster then
      Damage_down = (100 - skillatk3.info["Script Arg2"] / 2) / 100
    end
    damage = damage * Damage_down
  end
  if source and source:isAlive() and source.camp ~= caster.camp then
    local bid = TitanLeorio.atk3_STRDown
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo, source, caster)
    buff1.CreatedByHunterHunter = true
    buff1:setAttribute("STR", -math.min(source.attribs.STR * STR_down, caster.attribs.STR * 2))
    source:addBuff(buff1, caster)
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function TitanLeorio.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanLeorio_atk4
  local skillatk4s = caster.skills.TitanLeorio_atk4s
  caster.charge_direction = caster.direction
  local minhp_unit = caster
  local minhp = math.huge
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.buffManager.invisible then
    elseif unit.buff_effects.invulnerable then
    elseif unit.info.ID == 296 then
    elseif minhp > unit.hp then
      minhp_unit = unit
      minhp = unit.hp
    end
  end
  target = minhp_unit
  if target and target ~= caster then
    if target.position[1] >= caster.position[1] then
      caster.charge_direction = 1
    else
      caster.charge_direction = -1
    end
    skillatk4s:takeEffectOn(target, caster)
  end
  caster.orig_walkV = caster.walk_v
  caster.atk4_charge_target = target
  caster.charging = true
  basefunc(skill, target)
end

function TitanLeorio.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk4 = caster.skills.TitanLeorio_atk4
  local skillatk4s = caster.skills.TitanLeorio_atk4s
  local attack_counter = skill.attack_counter
  if skillatk4 and target ~= caster then
    if attack_counter == 0 then
      local MPGR = caster.attribs.MPGainRatio
      repeat
        if MPGR ~= nil then
        end
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
        do break end -- pseudo-goto
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      until true
      local bid = 1665
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.charge_stable_buff = caster:addBuff(binfo, caster)
      caster.walk_v = {
        caster.charge_direction * TitanLeorio.charge_speed,
        0
      }
      skill.attack_counter = skill.attack_counter + 1
      if not target or target and target.buff_effects.untargetable then
        skill:finish()
      end
    elseif attack_counter == 1 then
      if target then
        skillatk4:takeEffectOn(target, caster)
      end
      caster.charging = false
      caster.atk4_contact = false
      caster.charge_stable_buff.timer = -1
      caster.walk_v = caster.orig_walkV
      skill:finish()
    end
  end
end

function TitanLeorio.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.charge_stable_buff then
    caster.charge_stable_buff.timer = -1
  end
  caster.walk_v = caster.orig_walkV
  caster.charging = false
  caster.atk4_contact = false
  local bid = 4490
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff1 = ed.BuffCreate(binfo, caster, caster)
  buff1.CreatedByHunterHunter = true
  caster:addBuff(buff1, caster)
end

function TitanLeorio.skillatk4_trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function TitanLeorio.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  buff.CreatedByHunterHunter = true
  buff.onDamaged = override(buff.onDamaged, TitanLeorio.skillatk4s_buff_onDamaged)
  return buff
end

function TitanLeorio.skillatk4s_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.TitanLeorio_atk4
  local DMG_shift = skillatk4.info["Script Arg2"] / 100
  local max_dmg = owner.hp - 1
  local shift_dmg = 0
  if damage and transferred ~= true then
    if max_dmg < damage * (1 - DMG_shift) then
      shift_dmg = damage * (1 - DMG_shift) - max_dmg
    end
    caster:takeDamage(damage * DMG_shift + shift_dmg, damage_type, "hp", source, 1, 1, true)
    damage = math.min(damage * (1 - DMG_shift), max_dmg)
    local mp_gain = damage * owner.info["MP Gain Rate"] / owner.attribs.HP * (owner.attribs.MPRatio * 0.01 + 1)
    owner:setMP(owner.mp + mp_gain * ed.engine.mp_bonus)
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred)
end

function TitanLeorio.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.TitanLeorio_ult1stTarget = target
end

function TitanLeorio.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.CreatedByHunterHunter = true
  if owner and owner:isAlive() then
    owner.TitanLeorio_hasTaunt = true
  end
  buff.onRemoved = override(buff.onRemoved, TitanLeorio.skillult_buffonRemoved)
  return buff
end

function TitanLeorio.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanLeorio_ult
  local attack_counter = skill.attack_counter
  local firstTarget = skill.target
  if skillult and attack_counter == 1 and firstTarget and caster.TitanLeorio_hasArcana >= 3 then
    local minSTRunit
    local minSTR = math.huge
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      if not unit.buff_effects.invulnerable and not unit.config.is_summoned and unit ~= firstTarget then
        local unit_str = unit.attribs.STR
        if minSTR > unit_str then
          minSTR = unit_str
          minSTRunit = unit
        end
      end
    end
    if minSTRunit then
      skillult:takeEffectOn(minSTRunit, caster)
    end
  end
end

function TitanLeorio.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLeorio_atk2
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  if caster:isAlive() and skillatk2 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.STR and tbuff.info.STR <= 0 then
        power = power + multiplier * (math.abs(tbuff.info.STR) + caster.attribs.STR)
      end
    end
  end
  return power, coeff
end

function TitanLeorio.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and caster.TitanLeorio_hasArcana >= 2 and target and isHit then
    local bid = TitanLeorio.atk2_STRDown
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo, target, caster)
    buff1.CreatedByHunterHunter = true
    buff1:setAttribute("STR", -math.min(target.attribs.STR * 0.3, caster.attribs.STR * 2))
    buff1:setAttribute("ARM", -math.min(target.attribs.ARM * 0.2, 3000))
    buff1:setAttribute("MR", -math.min(target.attribs.MR * 0.2, 3000))
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function TitanLeorio.skillult_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner then
    owner.TitanLeorio_hasTaunt = false
  end
end

function TitanLeorio.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  local skillult = hero.skills.TitanLeorio_ult
  if source and source.TitanLeorio_hasTaunt == true and skillult then
    local Dmg_down = math.max((100 - skillult.info["Script Arg2"]) / 100, 0.05)
    local mp_gain = lost * hero.info["MP Gain Rate"] / hero.attribs.HP * (hero.attribs.MPRatio * 0.01 + 1)
    hero:setMP(hero.mp + mp_gain * ed.engine.mp_bonus)
    lost = lost * Dmg_down
  end
  return lost
end

function TitanLeorio.isNearDest(posStart, posDest, range)
  local disX = posStart[1] - posDest[1]
  local disY = posStart[2] - posDest[2]
  if disX * disX + disY * disY <= range * range then
    return true
  else
    return false
  end
end

function TitanLeorio.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanLeorio_atk4
  local skillatk4s = hero.skills.TitanLeorio_atk4s
  if skillatk4 and hero.current_skill == skillatk4 and skillatk4.current_phase_elapsed then
    local HP_HEAL = skillatk4.info["Script Arg3"] / 100
    if not hero.atk4_charge_target then
      skillatk4:finish()
      hero:hurt()
    end
    if hero.atk4_charge_target == hero then
      if not hero.config.is_boss then
        hero:takeHeal(hero.attribs.HP * HP_HEAL, "hp", hero)
      end
      skillatk4:trigger()
      skillatk4:finish()
    end
    if hero.charging == true and hero.atk4_charge_target then
      local atk4_chargeRange = TitanLeorio.Charge_range
      if hero.speeder and hero.speeder > 1 then
        atk4_chargeRange = atk4_chargeRange * math.min(hero.speeder, 2)
      else
        atk4_chargeRange = TitanLeorio.Charge_range
      end
      if hero.atk4_contact ~= true and hero.atk4_charge_target and TitanLeorio.isNearDest(hero.position, hero.atk4_charge_target.position, atk4_chargeRange) and hero.charging ~= false then
        hero.atk4_contact = true
        hero.charging = false
        skillatk4:trigger()
        hero.walk_v = hero.orig_walkV
      end
    end
    if hero.position[1] >= ed.engine.stage_rect.maxX or hero.position[1] <= ed.engine.stage_rect.minX then
      if not hero.X_0_800_Time then
        hero.X_0_800_Time = 0
      end
      hero.X_0_800_Time = hero.X_0_800_Time + dt
      if 2 <= hero.X_0_800_Time then
        skillatk4:finish()
        hero:hurt()
        hero.X_0_800_Time = 0
      end
    end
  end
  if hero.charging == true and not skillatk4.casting and hero.charge_stable_buff then
    hero.charge_stable_buff.timer = -1
    hero.walk_v = hero.orig_walkV
    hero.charging = false
  end
end

function TitanLeorio.die(basefunc, hero, killer)
  basefunc(hero, killer)
end

function TitanLeorio.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanLeorio.init_hero(hero)
  hero.reset = override(hero.reset, TitanLeorio.hero_reset)
  hero.update = override(hero.update, TitanLeorio.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanLeorio.hero_getLostHPAfterImmunity)
  hero.TitanLeorio_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  local skillult = hero.skills.TitanLeorio_ult
  local skillatk = hero.skills.TitanLeorio_atk
  local skillatk2 = hero.skills.TitanLeorio_atk2
  local skillatk3 = hero.skills.TitanLeorio_atk3
  local skillatk4 = hero.skills.TitanLeorio_atk4
  local skillatk4s = hero.skills.TitanLeorio_atk4s
  if skillult and not hero.config.is_summoned and hero.name == "TitanLeorio" then
    skillult.start = override(skillult.start, TitanLeorio.skillult_start)
    skillult.createBuff = override(skillult.createBuff, TitanLeorio.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanLeorio.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanLeorio.skillult_takeEffectOn)
    skillult.power = override(skillult.power, TitanLeorio.skillult_power)
  end
  if skillatk and hero.name == "TitanLeorio" then
    skillatk.power = override(skillatk.power, TitanLeorio.skillatk_power)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanLeorio.skillatk_takeEffectOn)
  end
  if skillatk2 and hero.name == "TitanLeorio" then
    skillatk2.start = override(skillatk2.start, TitanLeorio.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanLeorio.skillatk2_onAttackFrame)
    skillatk2.power = override(skillatk2.power, TitanLeorio.skillatk2_power)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanLeorio.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanLeorio.skillatk2_takeEffectOn)
  end
  if skillatk3 and hero.name == "TitanLeorio" then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanLeorio.skillatk3_createBuff)
  end
  if skillatk4 and hero.name == "TitanLeorio" then
    skillatk4.start = override(skillatk4.start, TitanLeorio.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanLeorio.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, TitanLeorio.skillatk4_finish)
    skillatk4.trigger = override(skillatk4.trigger, TitanLeorio.skillatk4_trigger)
  end
  if skillatk4s and hero.name == "TitanLeorio" then
    skillatk4s.createBuff = override(skillatk4s.createBuff, TitanLeorio.skillatk4s_createBuff)
  end
  return hero
end

return TitanLeorio.init_hero
