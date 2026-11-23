module("ed.battlehero", package.seeall)
local ed = ed
TitanHB = {}
TitanHB.TitanHB_ult_fear = 1617
TitanHB.TitanHB_atk2_silence = 1618
TitanHB.uncontrol_bid = 1623
TitanHB.threshold = 0.1
TitanHB.soulmaxcount = 50
TitanHB.TitanHB_atk3_period3 = 1624

function TitanHB.AtkAddEffect(caster, target, bid)
  local bid = bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  target:addBuff(binfo, caster)
end

function TitanHB.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target and target.hp < target.attribs.HP * 0.5 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanHB.TitanHB_ult_fear)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("fearrange", 5)
    target:addBuff(buff, caster)
  end
end

function TitanHB.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if ed.run_with_scene and attack_counter == 1 then
    local effect_ult = "eff_impact_TitanHB_ult.cha"
    local effect_ult2 = "eff_impact_TitanHB_ult2.cha"
    local effect1 = ed.scene:playEffectOnScene(effect_ult, caster.position, {
      caster.direction,
      1
    }, nil, -1)
    local effect2 = ed.scene:playEffectOnScene(effect_ult2, caster.position, {
      caster.direction,
      1
    }, nil, 1)
  end
end

function TitanHB.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanHB_atk3
  local skillatk3b = caster.skills.TitanHB_atk3b
  if isHit and skillatk3 and caster.TitanHB_soul_count and caster.TitanHB_soul_count >= 30 then
    skillatk3b:takeEffectAt(caster.position, caster)
    TitanHB.AtkAddEffect(caster, target, TitanHB.TitanHB_atk2_silence)
  elseif isHit and skillatk3 and caster.TitanHB_soul_count and caster.TitanHB_soul_count >= 15 then
    TitanHB.AtkAddEffect(caster, target, TitanHB.TitanHB_atk2_silence)
    return isHit, dmg
  end
end

function TitanHB.skillatk_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skillatk3 = caster.skills.TitanHB_atk3
  if skillatk3 then
    power = power + skillatk3.info["Script Arg2"] * caster.TitanHB_soul_count
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function TitanHB.hero_collectHPchange(basefunc, self, config)
  local unit = config.unit
  local hero = self
  if unit.camp ~= hero.camp and unit:isHero() and not unit.config.is_summoned and not unit.config.is_boss and math.abs(config.hp_change) > 0 then
    local index = math.abs(config.hp_change) / (unit.attribs.HP * TitanHB.threshold)
    hero.TitanHB_soul_count = math.min(hero.TitanHB_soul_count + index, TitanHB.soulmaxcount)
    hero.TitanHB_soul_count = math.floor(hero.TitanHB_soul_count)
  end
  if unit.camp ~= hero.camp and not unit.config.is_summoned and unit.config.is_boss and math.abs(config.hp_change) > 0 then
    local index = math.abs(config.hp_change) / math.min(unit.attribs.HP * TitanHB.threshold, 200000)
    hero.TitanHB_soul_count = math.min(hero.TitanHB_soul_count + index * 4, TitanHB.soulmaxcount)
    hero.TitanHB_soul_count = math.floor(hero.TitanHB_soul_count)
  end
end

function TitanHB.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanHB.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function TitanHB.skillatk4a_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, TitanHB.skillatk4a_buff_onDamaged)
  return buff
end

function TitanHB.True_damage(hero, damage, damage_type)
  local temp_damage = damage
  for _, buff in ipairs(hero.buff_list) do
    local info = buff.info
    if buff.shield then
      local stype = info["Shield Type"]
      if stype == damage_type or stype == "all" then
        local temp_shield = buff.shield
        temp_shield = temp_shield - temp_damage
        if temp_shield < 0 then
          temp_damage = -temp_shield
        end
      end
    end
  end
  local immunity
  if damage_type == "AD" then
    immunity = hero.attribs.PIMU or 0
  elseif damage_type == "AP" then
    immunity = hero.attribs.MIMU or 0
  elseif damage_type == "Holy" then
    immunity = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + hero.attribs.ALLIMU
  temp_damage = hero:getLostHPAfterImmunity(temp_damage, immunity, damage_type)
  return temp_damage
end

function TitanHB.skillatk4a_buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred)
  local temp_damage = basefunc(self, damage, damage_type, source, skill, transferred)
  local caster = self.caster
  local owner = self.owner
  local manualskill = caster.skills.TitanHB_ult
  local skillatk4 = caster.skills.TitanHB_atk4
  if caster.current_skill ~= manualskill and not caster.buff_effects.doom and not TitanHB.atk4_trigger and not caster.config.is_summoned and not owner.config.is_summoned and owner ~= caster and skillatk4 and caster.name == "TitanHB" and not caster.buff_effects.polymorph then
    local final_damage = TitanHB.True_damage(owner, temp_damage, damage_type)
    local maxDamage = owner.hp - 1
    if final_damage > maxDamage then
      for _, tbuff in ipairs(caster.buff_list) do
        local willBeRemove = tbuff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("derangedOwner", tbuff.info["Control Effects"])
        if willBeRemove then
          tbuff.timer = -1
        end
      end
      local owner = self.owner
      local skillatk4 = caster.skills.TitanHB_atk4
      if caster.current_skill then
        caster.current_skill:interrupt()
      end
      local bid = TitanHB.uncontrol_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      skillatk4:takeEffectOn(owner)
      TitanHB.atk4_trigger = true
      return 0
    end
    return final_damage
  end
  return temp_damage
end

function TitanHB.update(basefunc, hero, dt)
  basefunc(hero, dt)
  local atk4a = hero.skills.TitanHB_atk4a
  if atk4a and not hero.TitanHB_atk4_alreadyCreateRegion then
    hero.TitanHB_atk4_alreadyCreateRegion = true
    atk4a.target = hero
    local atk4a_region = atk4a:createRegion()
    atk4a_region.position[1] = atk4a_region.position[1] + 3
    hero.TitanHB_atk4_region = atk4a_region
    ed.engine:addRegion(atk4a_region)
  end
  local skillatk3 = hero.skills.TitanHB_atk3
  local effect_name = "eff_buff_TitanHB_atk3.cha"
  if skillatk3 and not hero.current_skill and hero.TitanHB_soul_count > 0 then
    if hero.TitanHB_soul_count >= 30 and not hero.TitanHB_ChangePeriod_3 then
      hero.TitanHB_ChangePeriod_3 = true
      if hero.actor and hero:isAlive() and effect_name and ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, hero.position, {1, 1}, nil, 1)
      end
      local binfo = ed.lookupDataTable("Buff", nil, TitanHB.TitanHB_atk3_period3)
      local buff = hero:addBuff(binfo, hero)
      hero:enterActionStageFromOneStage(hero.getThirdPeriod(), 10095)
    elseif hero.TitanHB_soul_count >= 15 and not hero.TitanHB_ChangePeriod_2 and not hero.TitanHB_ChangePeriod_3 then
      hero.TitanHB_ChangePeriod_2 = true
      if hero.actor and hero:isAlive() and effect_name and ed.run_with_scene then
        ed.scene:playEffectOnScene(effect_name, hero.position, {1, 1}, nil, 1)
      end
      hero:enterActionStageFromOneStage(hero.getSecondPeriod(), 10095)
    end
  end
end

function TitanHB.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.shield = buff.shield + skill.info["Script Arg2"] * caster.attribs.AP
  return buff
end

function TitanHB.die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanHB_atk4_region then
    hero.TitanHB_atk4_region:finish()
    hero.TitanHB_atk4_region = nil
  end
end

function TitanHB.hero_reset(basefunc, hero)
  hero.atk_count = 0
  local skillatk3 = hero.skills.TitanHB_atk3
  if skillatk3 then
    hero.TitanHB_atk3_alreadyCreateRegion = false
    hero.TitanHB_ChangePeriod_2 = false
    hero.TitanHB_ChangePeriod_3 = false
    hero.TitanHB_soul_count = 0
  end
  local skillatk4 = hero.skills.TitanHB_atk4
  if skillatk4 then
    TitanHB.atk4_trigger = false
    hero.TitanHB_atk4_alreadyCreateRegion = false
  end
  hero:enterActionStageFromOneStage(hero.getFirstPeriod(), 10095)
  basefunc(hero)
end

function TitanHB.skillatk1_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  if caster.atk_count % 2 == 0 then
    skill.info["Tile Art"] = "eff_tile_TitanHB_atk.cha"
    skill.info["Impact Effect"] = "eff_impact_TitanHB_atk.cha"
    skill:startPhase(1)
    caster.atk_count = caster.atk_count + 1
  else
    skill.info["Tile Art"] = "eff_tile_TitanHB_atkb.cha"
    skill.info["Impact Effect"] = "eff_impact_TitanHB_atk.cha"
    skill:startPhase(2)
    caster.atk_count = caster.atk_count + 1
  end
end

function TitanHB.skillatk1_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function TitanHB.init_hero(hero)
  local skillult = hero.skills.TitanHB_ult
  local skillatk1 = hero.skills.TitanHB_atk
  local skillatk2 = hero.skills.TitanHB_atk2
  local skillatk3 = hero.skills.TitanHB_atk3
  local skillatk4 = hero.skills.TitanHB_atk4
  local skillatk3a = hero.skills.TitanHB_atk3a
  local skillatk4a = hero.skills.TitanHB_atk4a
  if skillult then
    skillult.getDamage = override(skillult.getDamage, TitanHB.skillatk_getDamage)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanHB.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanHB.skillult_onAttackFrame)
  end
  if skillatk1 then
    skillatk1.start = override(skillatk1.start, TitanHB.skillatk1_start)
    skillatk1.onPhaseFinished = override(skillatk1.onPhaseFinished, TitanHB.skillatk1_onPhaseFinished)
  end
  if skillatk2 then
    skillatk2.getDamage = override(skillatk2.getDamage, TitanHB.skillatk_getDamage)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanHB.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    hero.TitanHB_soul_count = 0
    hero.collectHPchange = override(hero.collectHPchange, TitanHB.hero_collectHPchange)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanHB.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanHB.skillatk4_createBuff)
    if skillatk4a then
      skillatk4a.createBuff = override(skillatk4a.createBuff, TitanHB.skillatk4a_createBuff)
    end
  end
  hero.update = override(hero.update, TitanHB.update)
  hero.die = override(hero.die, TitanHB.die)
  hero.reset = override(hero.reset, TitanHB.hero_reset)
  hero:setActionStageChangeByManual(true)
  
  function hero.getFirstPeriod(unit)
    local period = 1
    return period
  end
  
  function hero.getSecondPeriod(unit)
    local period = 2
    return period
  end
  
  function hero.getThirdPeriod(unit)
    local period = 3
    return period
  end
  
  return hero
end

return TitanHB.init_hero
