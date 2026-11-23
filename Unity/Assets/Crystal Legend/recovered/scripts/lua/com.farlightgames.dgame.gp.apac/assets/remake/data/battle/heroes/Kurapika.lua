module("ed.battlehero", package.seeall)
local ed = ed
Kurapika = {}
Kurapika.invulnerableBuff = 4473
Kurapika.untargetableBuff = 4474
Kurapika.arcana2_HITDown = 4475
Kurapika.atk3self_bid = 4476
Kurapika.stun_bid = 4463

function Kurapika.skillatk_onAttackFrame(basefunc, skill)
  local skill_counter = skill.attack_counter
  if skill.attack_counter == 0 then
    basefunc(skill)
  else
    skill:finish()
  end
end

function Kurapika.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk2 = caster.skills.Kurapika_atk2
  if caster and skillatk2 and caster.Kurapika_hasArcana >= 2 then
    if isHit then
      local bid = Kurapika.arcana2_HITDown
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
      local bid = Kurapika.stun_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = ed.BuffCreate(binfo, minunit, caster)
      buff2.CreatedByHunterHunter = true
      buff2.timer = 4
      minunit:addBuff(buff2, caster)
    end
  end
end

function Kurapika.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.Kurapika_atk2
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

function Kurapika.skillatk3_buffOnDamaged(basefunc, buff, damage, damage_type)
  local caster = buff.caster
  local maxdmg = caster.hp - 1
  local skillatk3 = caster.skills.Kurapika_atk3
  local skillatk3s = caster.skills.Kurapika_atk3s
  local HP_HEAL = skillatk3.info["Script Arg2"] * 0.01
  if caster.atk3_DeathHealth and caster.atk3_DeathHealth > 0 then
    if damage <= maxdmg then
      return damage
    else
      damage = maxdmg
      caster:hurt()
      local bid = Kurapika.invulnerableBuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(buff, caster)
      caster.Kurapika_atk3sBuff = buff
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

function Kurapika.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk3 = caster.skills.Kurapika_atk3s
  caster.atk3_power = power
  return power, i
end

function Kurapika.skillatk3s_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  if caster.Kurapika_atk3sBuff then
    caster.Kurapika_atk3sBuff.timer = -1
  end
  caster.can_cast_manual = true
end

function Kurapika.need_interrupt(skill)
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

function Kurapika.skillatk4_selectTarget(basefunc, self, default)
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

function Kurapika.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.Kurapika_atk4
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
  if caster:isAlive() and skillatk4 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.CreatedByHunterHunter == true and tbuff.caster == caster and caster.Kurapika_hasArcana >= 3 then
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

function Kurapika.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Kurapika.skillatk4_chainBuff_update)
  buff.CreatedByHunterHunter = true
  return buff
end

function Kurapika.skillatk4_chainBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.Kurapika_atk4
  local skillatk4_power = caster.atk4_power
  local target_need_interrupt = Kurapika.need_interrupt(owner.current_skill)
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

function Kurapika.skillult_selectTarget(basefunc, self, default)
  local caster = self.caster
  local camp = caster.camp
  local target = Kurapika.maxDamageHero(-camp)
  if target then
    return target
  else
    return basefunc(self, default)
  end
end

function Kurapika.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.Kurapika_ult
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

function Kurapika.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillult = caster.skills.Kurapika_ult
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

function Kurapika.maxDamageHero(camp)
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

function Kurapika.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.Kurapika_atk4
  local skillult = caster.skills.Kurapika_ult
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

function Kurapika.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.Kurapika_atk3
  local skillatk3s = hero.skills.Kurapika_atk3s
  if skillatk3 and skillatk3s and not hero.config.is_boss then
    hero.KurapikaTime = hero.KurapikaTime and hero.KurapikaTime + dt or dt
    if hero.KurapikaTime == 1 then
      local bid = Kurapika.atk3self_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      buff.onDamaged = override(buff.onDamaged, Kurapika.skillatk3_buffOnDamaged)
      hero:addBuff(buff, hero)
    end
  end
end

function Kurapika.hero_reset(basefunc, hero)
  basefunc(hero)
end

function Kurapika.init_hero(hero)
  hero.reset = override(hero.reset, Kurapika.hero_reset)
  hero.update = override(hero.update, Kurapika.hero_update)
  hero.Kurapika_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if hero.Kurapika_hasArcana >= 4 then
    hero.atk3_DeathHealth = 2
  else
    hero.atk3_DeathHealth = 1
  end
  local skillult = hero.skills.Kurapika_ult
  local skillatk = hero.skills.Kurapika_atk
  local skillatk2 = hero.skills.Kurapika_atk2
  local skillatk3 = hero.skills.Kurapika_atk3
  local skillatk4 = hero.skills.Kurapika_atk4
  local skillatk3s = hero.skills.Kurapika_atk3s
  if skillult and not hero.config.is_summoned and hero.name == "Kurapika" then
    skillult.createBuff = override(skillult.createBuff, Kurapika.skillult_createBuff)
    skillult.power = override(skillult.power, Kurapika.skillult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Kurapika.skillult_takeEffectOn)
  end
  if skillatk and hero.name == "Kurapika" then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Kurapika.skillatk_onAttackFrame)
  end
  if skillatk2 and hero.name == "Kurapika" then
    skillatk2.createBuff = override(skillatk2.createBuff, Kurapika.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Kurapika.skillatk2_takeEffectOn)
  end
  if skillatk3 and hero.name == "Kurapika" then
    skillatk3.power = override(skillatk3.power, Kurapika.skillatk3_power)
  end
  if skillatk3s and hero.name == "Kurapika" then
    skillatk3s.finish = override(skillatk3s.finish, Kurapika.skillatk3s_finish)
  end
  if skillatk4 and hero.name == "Kurapika" then
    skillatk4.selectTarget = override(skillatk4.selectTarget, Kurapika.skillatk4_selectTarget)
    skillatk4.createBuff = override(skillatk4.createBuff, Kurapika.skillatk4_CreateBuff)
    skillatk4.power = override(skillatk4.power, Kurapika.skillatk4_power)
  end
  return hero
end

return Kurapika.init_hero
