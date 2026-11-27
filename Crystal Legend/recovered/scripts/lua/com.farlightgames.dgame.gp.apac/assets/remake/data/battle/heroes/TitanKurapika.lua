module("ed.battlehero", package.seeall)
local ed = ed
TitanKurapika = {}
TitanKurapika.invulnerableBuff = 4473
TitanKurapika.untargetableBuff = 4474
TitanKurapika.arcana2_HITDown = 4475
TitanKurapika.atk3self_bid = 4476
TitanKurapika.stun_bid = 4463
TitanKurapika.TitanKurapika_fashionID = 101271
TitanKurapika.fashion_shieldID = 4491

function TitanKurapika.skillatk_onAttackFrame(basefunc, skill)
  local skill_counter = skill.attack_counter
  if skill.attack_counter == 0 then
    basefunc(skill)
  else
    skill:finish()
  end
end

function TitanKurapika.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanKurapika_atk2
  if caster and skillatk2 and caster.TitanKurapika_hasArcana >= 2 then
    if isHit then
      local bid = TitanKurapika.arcana2_HITDown
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff1 = ed.BuffCreate(binfo, target, caster)
      buff1.CreatedByHunterHunter = true
      buff1:setAttribute("HIT", -target.attribs.HIT * 0.5)
      target:addBuff(buff1, caster)
    end
    local minunit
    local mindis = 9999
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if not unit.buff_effects.invulnerable and not unit.config.is_summoned then
        local unitDistance = ed.edpDistanceSQ(unit.position, caster.position) ^ 0.5
        if mindis > unitDistance then
          mindis = unitDistance
          minunit = unit
        end
      end
    end
    if minunit then
      local bid = TitanKurapika.stun_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = ed.BuffCreate(binfo, minunit, caster)
      buff2.CreatedByHunterHunter = true
      buff2.timer = 4
      minunit:addBuff(buff2, caster)
    end
  end
end

function TitanKurapika.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanKurapika_atk2
  local CRITRES = -skillatk2.info["Script Arg2"]
  local MCRITRES = -skillatk2.info["Script Arg2"]
  local CSDR = -skillatk2.info["Script Arg3"]
  local MCSDR = -skillatk2.info["Script Arg3"]
  local INT_down = skillatk2.info["Script Arg4"]
  if caster and skillatk2 and target then
    buff:setAttribute("CRITRES", CRITRES)
    buff:setAttribute("MCRITRES", MCRITRES)
    buff:setAttribute("CSDR", CSDR)
    buff:setAttribute("MCSDR", MCSDR)
    if target.attribs.INT then
      buff:setAttribute("INT", -math.min(target.attribs.INT * 0.2, INT_down))
    else
      buff:setAttribute("INT", -math.min(target.attribs.AP * 0.2, caster.attribs.AP * 0.3))
    end
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanKurapika.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function TitanKurapika.hero_onDying(basefunc, self, killer)
  local caster = self
  local skillatk3s = caster.skills.TitanKurapika_atk3
  local skillatk3 = caster.skills.TitanKurapika_atk3
  local HP_HEAL = skillatk3.info["Script Arg2"] * 0.01
  if caster.atk3_DeathHealth and caster.atk3_DeathHealth > 0 then
    local bid = TitanKurapika.invulnerableBuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
    caster.TitanKurapika_atk3sBuff = buff
    caster:castSkill(skillatk3s, caster)
    caster:takeHeal(caster.attribs.HP * HP_HEAL, "hp", caster)
    caster.atk3_DeathHealth = caster.atk3_DeathHealth - 1
    caster.can_cast_manual = false
  else
    basefunc(self, killer)
  end
end

function TitanKurapika.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local TotalDamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local caster = self
  local maxdmg = math.max(caster.hp - 1, 1)
  local skillatk3 = caster.skills.TitanKurapika_atk3
  local skillatk3s = caster.skills.TitanKurapika_atk3s
  local HP_HEAL = skillatk3.info["Script Arg2"] * 0.01
  print("TotalDamage = " .. TotalDamage)
  print("maxdmg = " .. maxdmg)
  if caster.atk3_DeathHealth and caster.atk3_DeathHealth > 0 and not transferred then
    if TotalDamage < maxdmg then
      return TotalDamage, bc
    else
      TotalDamage = maxdmg
      local bid = TitanKurapika.invulnerableBuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(buff, caster)
      print("hero_skillatk3_buffOnDamaged = " .. TotalDamage)
      caster.TitanKurapika_atk3sBuff = buff
      caster:castSkill(skillatk3s, caster)
      caster:takeHeal(caster.attribs.HP * HP_HEAL, "hp", caster)
      caster.atk3_DeathHealth = caster.atk3_DeathHealth - 1
      caster.can_cast_manual = false
      return TotalDamage, bc
    end
  else
    return TotalDamage, bc
  end
end

function TitanKurapika.skillatk3_buffOnDamaged(basefunc, buff, damage, damage_type)
  local caster = buff.caster
  local maxdmg = caster.hp - 1
  local skillatk3 = caster.skills.TitanKurapika_atk3
  local skillatk3s = caster.skills.TitanKurapika_atk3s
  local HP_HEAL = skillatk3.info["Script Arg2"] * 0.01
  if caster.atk3_DeathHealth and caster.atk3_DeathHealth > 0 then
    if damage < maxdmg then
      return damage
    else
      damage = maxdmg
      local list = caster.buff_list
      local debuff_list = {}
      local my_camp = caster.camp
      for i = 1, #list do
        local buff = list[i]
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and (TitanKurapika.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") then
          debuff_list[#debuff_list + 1] = buff
        end
      end
      for i = 1, #debuff_list do
        caster:removeBuff(debuff_list[i])
      end
      caster:hurt()
      local bid = TitanKurapika.invulnerableBuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(buff, caster)
      caster.TitanKurapika_atk3sBuff = buff
      caster:castSkill(skillatk3s, caster)
      caster:takeHeal(caster.attribs.HP * HP_HEAL, "hp", caster)
      caster.atk3_DeathHealth = caster.atk3_DeathHealth - 1
      caster.can_cast_manual = false
      return damage
    end
  else
    return damage
  end
end

function TitanKurapika.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanKurapika_atk3s
  caster.atk3_power = power
  return power, i
end

function TitanKurapika.skillatk3s_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  if caster.TitanKurapika_atk3sBuff then
    caster.TitanKurapika_atk3sBuff.timer = -1
  end
  caster.can_cast_manual = true
end

function TitanKurapika.need_interrupt(skill)
  local current_phase_idx = skill and skill.current_phase_idx
  local max_phase_idx = skill and #skill.phase_list
  local max_event_idx = current_phase_idx and skill.current_phase and type(skill.current_phase.event_list) == "table" and #skill.current_phase.event_list
  local next_event_idx = current_phase_idx and skill.next_event_idx
  local need
  if skill and current_phase_idx and max_phase_idx and max_event_idx and next_event_idx then
    if current_phase_idx < max_phase_idx then
      need = true
    elseif current_phase_idx == max_phase_idx and max_event_idx >= next_event_idx then
      need = true
    end
  end
  return need
end

function TitanKurapika.skillatk4_selectTarget(basefunc, self, default)
  local target = basefunc(self, default)
  local caster = self.caster
  local minINT = math.huge
  local minINT_Unit = target
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.buff_effects.invulnerable then
      break
    end
    if unit.buffManager.invisible then
      break
    end
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.CreatedByHunterHunter and tbuff.info.INT < 0 and unit.attribs.INT and minINT > unit.attribs.INT then
        minINT_Unit = unit
        minINT = unit.attribs.INT
      end
    end
  end
  return minINT_Unit
end

function TitanKurapika.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanKurapika_atk4
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
  if caster:isAlive() and skillatk4 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster == caster and caster.TitanKurapika_hasArcana >= 3 then
        if tbuff.info.INT and 0 >= tbuff.info.INT then
          power = power + multiplier * (math.abs(tbuff.info.INT) + caster.attribs.INT)
        end
      elseif tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.INT and 0 >= tbuff.info.INT then
        power = power + math.abs(tbuff.info.INT) * multiplier
      end
    end
  end
  caster.atk4_power = power
  return power, i
end

function TitanKurapika.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanKurapika.skillatk4_chainBuff_update)
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanKurapika.skillatk4_chainBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.TitanKurapika_atk4
  local skillatk4_power = caster.atk4_power
  local target_need_interrupt = TitanKurapika.need_interrupt(owner.current_skill)
  if caster:isAlive() and skillatk4 then
    local target_casting1 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
    if owner and owner:isAlive() and target_casting1 ~= nil and target_casting1 ~= owner.info["Basic Skill"] then
      owner:hurt()
      local target_casting2 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
      local interrupt = false
      if target_casting2 == nil and target_need_interrupt == true then
        interrupt = true
      end
      if interrupt == true and owner:isAlive() and not owner.buff_effects.invulnerable then
        if skillatk4_power then
          owner:takeDamage(skillatk4_power, "AP", "hp", caster)
        else
          owner:takeDamage(math.min(owner.attribs.HP * 0.1, caster.attribs.HP * 0.1), "AP", "hp", caster)
        end
        buff.timer = -1
      end
    end
  else
    buff.timer = -1
  end
end

function TitanKurapika.skillult_selectTarget(basefunc, self, default)
  local caster = self.caster
  local camp = caster.camp
  local target = TitanKurapika.maxDamageHero(-camp)
  if target then
    return target
  else
    return basefunc(self, default)
  end
end

function TitanKurapika.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanKurapika_ult
  local HAST_ratio = skillult.info["Script Arg2"]
  local ADAPRatio = skillult.info["Script Arg3"] / 100
  if caster and skillult then
    buff:setAttribute("AD", caster.attribs.AP * ADAPRatio)
    buff:setAttribute("AP", caster.attribs.AP * ADAPRatio)
    buff:setAttribute("HAST", HAST_ratio)
    buff:setAttribute("MSPD", HAST_ratio)
  end
  buff.CreatedByHunterHunter = true
  return buff
end

function TitanKurapika.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillult = caster.skills.TitanKurapika_ult
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
  if caster:isAlive() and skillult then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster.camp == caster.camp and tbuff.info.INT and 0 >= tbuff.info.INT then
        power = power + multiplier * (math.abs(tbuff.info.INT) + caster.attribs.INT)
      end
    end
  end
  return power, coeff
end

function TitanKurapika.maxDamageHero(camp)
  local maxDamage = -1
  local targetEnemy
  local totalDamage = 0
  for enemy in ed.engine:foreachAliveUnit(camp) do
    if enemy.config.is_summoned then
    else
      totalDamage = totalDamage + enemy.battledata.damage
      if maxDamage <= enemy.battledata.damage then
        maxDamage = enemy.battledata.damage
        targetEnemy = enemy
      end
    end
  end
  return targetEnemy
end

function TitanKurapika.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanKurapika_atk4
  local skillult = caster.skills.TitanKurapika_ult
  if skillult and skillatk4 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster == caster and tbuff.info.ID == 4471 then
        local skillatk4_power = caster.atk4_power
        if skillatk4_power then
          target:takeDamage(skillatk4_power, "AP", "hp", caster)
        else
          target:takeDamage(math.min(target.attribs.HP * 0.1, caster.attribs.HP * 0.1), "AP", "hp", caster)
        end
        tbuff.timer = -1
      end
    end
  end
end

function TitanKurapika.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.TitanKurapika_atk3
  local skillatk3s = hero.skills.TitanKurapika_atk3s
  if skillatk3 and skillatk3s and not hero.config.is_boss then
    hero.KurapikaTime = hero.KurapikaTime and hero.KurapikaTime + dt or dt
    if hero.KurapikaTime == 1 then
      local bid = TitanKurapika.atk3self_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero.onDying = override(hero.onDying, TitanKurapika.hero_onDying)
      hero:addBuff(buff, hero)
    end
  end
  if TitanKurapika.TitanKurapika_fashionID and TitanKurapika.TitanKurapika_fashionID == hero.fashion_id and hero.hasFashionShield ~= true then
    local shieldbid = TitanKurapika.fashion_shieldID
    local shieldbinfo = ed.lookupDataTable("Buff", nil, shieldbid)
    local shieldbuff = ed.BuffCreate(shieldbinfo, hero, hero)
    shieldbuff.shield = hero.attribs.HP * 0.2
    hero:addBuff(shieldbuff, hero)
    hero.hasFashionShield = true
  end
end

function TitanKurapika.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hasFashionShield = false
end

function TitanKurapika.init_hero(hero)
  hero.reset = override(hero.reset, TitanKurapika.hero_reset)
  hero.update = override(hero.update, TitanKurapika.hero_update)
  hero.TitanKurapika_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.atk3_DeathHealth = 1
  if hero.TitanKurapika_hasArcana >= 4 then
    hero.atk3_DeathHealth = 2
  end
  local skillult = hero.skills.TitanKurapika_ult
  local skillatk = hero.skills.TitanKurapika_atk
  local skillatk2 = hero.skills.TitanKurapika_atk2
  local skillatk3 = hero.skills.TitanKurapika_atk3
  local skillatk4 = hero.skills.TitanKurapika_atk4
  local skillatk3s = hero.skills.TitanKurapika_atk3s
  if skillult and not hero.config.is_summoned and hero.name == "TitanKurapika" then
    skillult.createBuff = override(skillult.createBuff, TitanKurapika.skillult_createBuff)
    skillult.power = override(skillult.power, TitanKurapika.skillult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanKurapika.skillult_takeEffectOn)
  end
  if skillatk and hero.name == "TitanKurapika" then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, TitanKurapika.skillatk_onAttackFrame)
  end
  if skillatk2 and hero.name == "TitanKurapika" then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanKurapika.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanKurapika.skillatk2_takeEffectOn)
  end
  if skillatk3 and hero.name == "TitanKurapika" then
    skillatk3.power = override(skillatk3.power, TitanKurapika.skillatk3_power)
  end
  if skillatk3s and hero.name == "TitanKurapika" then
    skillatk3s.finish = override(skillatk3s.finish, TitanKurapika.skillatk3s_finish)
  end
  if skillatk4 and hero.name == "TitanKurapika" then
    skillatk4.selectTarget = override(skillatk4.selectTarget, TitanKurapika.skillatk4_selectTarget)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanKurapika.skillatk4_CreateBuff)
    skillatk4.power = override(skillatk4.power, TitanKurapika.skillatk4_power)
  end
  return hero
end

return TitanKurapika.init_hero
