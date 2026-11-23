module("ed.battlehero", package.seeall)
local ed = ed
BossTitanGT = {}
BossTitanGT.ult_uncontrollableBuff = 1646
BossTitanGT.init_emptyBuff = 233
BossTitanGT.enter_buff = 1316
BossTitanGT.ult_GuardPanel = "UI/DOTA-HERO/TitanGT2.jpg"
BossTitanGT.ult_TowerPanel = "UI/DOTA-HERO/TitanGT.jpg"
BossTitanGT.BossTitanGTIMUBuff_ID = 4364
BossTitanGT.rageBuffID = 4361
BossTitanGT.ragelosthp = 100000

function BossTitanGT.refreshPanelPic(unit)
  if ed.run_with_scene and unit.name == "BossTitanGT" then
    local panel = unit.heroPanel
    if panel then
      local pic = BossTitanGT.ult_TowerPanel
      if unit:isGuard() then
        pic = BossTitanGT.ult_GuardPanel
      end
      if pic then
        panel:setPortrait(pic)
      end
    end
  end
end

function BossTitanGT.atk2_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local target = skill.target
  local skillatk2 = hero.skills.BossTitanGT_atk2
  local attack_counter = skill.attack_counter
  local target = skill.target
  local originfo = skill.info
  local atk2_power = hero.atk2_power or skillatk2.info["Basic Num"]
  local atk2_extraDmg = skillatk2.info["Script Arg2"] / 100
  local Arcana_power = 0
  if skillatk2 and skill.info["Skill Name"] == skillatk2.info["Skill Name"] then
    if attack_counter == 0 then
      skill.info = ed.wraptable(skill.info, {
        ["Chain Effect"] = "eff_chain_TitanGT_atk2b.cha"
      })
      basefunc(skill)
      skill.info = originfo
    elseif attack_counter == 1 then
      if target and target:isAlive() then
        target:takeDamage(atk2_power * 1.1, "Holy", "hp", hero)
      else
        skill:finish()
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 2 then
      if target and target:isAlive() then
        if not hero.config.is_boss then
          target:takeDamage(atk2_extraDmg * hero.attribs.HP, "Holy", "hp", hero)
        elseif hero.config.is_boss then
          target:takeDamage(atk2_extraDmg * target.attribs.HP, "Holy", "hp", hero)
        end
      else
        skill:finish()
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function BossTitanGT.atk2b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skilatk2 = caster.skills.BossTitanGT_atk2
  local skilatk2b = caster.skills.BossTitanGT_atk2b
  local stunbuff_time = skilatk2.info["Script Arg3"] + 3
  local con_temp = 0
  if caster.attribs.CON then
    con_temp = caster.attribs.CON
  end
  if skilatk2b then
    if target.attribs.TEN then
      buff.timer = math.floor(caster.attribs.INT / 4000 + stunbuff_time) * (1 - (target.attribs.TEN - con_temp) / 100)
    else
      buff.timer = math.floor(caster.attribs.INT / 4000 + stunbuff_time)
    end
  end
  return buff
end

function BossTitanGT.need_interrupt(skill)
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

function BossTitanGT.atk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.BossTitanGT_atk3
  if caster:isAlive() and skillatk3 then
    buff.update = override(buff.update, BossTitanGT.atk3Buff_update)
    buff.onRemoved = override(buff.onRemoved, BossTitanGT.atk3Buff_onRemoved)
  end
  buff.paralyzeTime = 0
  return buff
end

function BossTitanGT.atk3Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.skills.BossTitanGT_atk3
  local paralyizeRatio = (skillatk3.info["Script Arg4"] + caster.attribs.INT * 5.0E-4) / 100
  local target_need_interrupt = BossTitanGT.need_interrupt(owner.current_skill)
  if caster:isAlive() then
    buff.paralyzeTime = buff.paralyzeTime and buff.paralyzeTime + dt or dt
    local target_casting1 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
    if owner and owner:isAlive() and target_casting1 ~= nil and target_casting1 ~= owner.info["Basic Skill"] then
      local interruptRand = ed.rand()
      if paralyizeRatio > interruptRand then
        owner:hurt()
        local target_casting2 = owner.current_skill and owner.current_skill.info["Skill Group ID"]
        local interrupt = false
        if target_casting2 == nil and target_need_interrupt == true then
          interrupt = true
        end
        if interrupt == true and owner:isAlive() and not owner.buff_effects.invulnerable then
          local amount = 0
          if owner.config.is_boss then
            amount = caster.hp * 0.1
          else
            amount = owner.hp * 0.1
          end
          owner:takeDamage(amount, "Holy", "hp", caster, 1, 1)
        end
      end
    end
  else
    buff.timer = -1
  end
end

function BossTitanGT.atk3Buff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.paralyzeTime = 0
end

function BossTitanGT.atk3s_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local HPLine = 0.2
  if caster:isAlive() and target.hp < target.attribs.HP * HPLine then
    local bid = 1642
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local atk3sBuff = ed.BuffCreate(binfo, target, caster)
    caster.atk3sBuff = target:addBuff(atk3sBuff, caster)
  end
end

function BossTitanGT.atk3s_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local skillatk3b = caster.skills.BossTitanGT_atk3b
  local minhp_unit
  local minhp = math.huge
  if skill.attack_counter == 1 and caster.TitanGT_hasArcana >= 2 then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if target and target == unit then
        break
      end
      if unit.config.is_boss then
        break
      end
      if unit.buffManager.invisible then
        break
      end
      if unit.buff_effects.invulnerable then
        break
      end
      if minhp > unit.hp then
        minhp_unit = unit
        minhp = unit.hp
      end
    end
    if minhp_unit then
      skillatk3b:takeEffectOn(minhp_unit, caster)
    end
  end
end

function BossTitanGT.ult_func_hideBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function BossTitanGT.ult_func_resetBuffEffect(unit)
  for _, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function BossTitanGT.ult_func_GuardChangeToTower(unit)
  if unit:isAlive() and unit.name == "BossTitanGT" and not unit:isGuard() then
    return
  end
  unit:enterActionStageFromOneStage(unit:getTowerPeriod(), 10100)
  BossTitanGT.refreshPanelPic(unit)
  unit.TitanGT_isGuard = false
  if not unit.TowerBuff then
    local bid = 4366
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local TowerBuff = ed.BuffCreate(binfo, unit, unit)
    local skillult = unit.skills.BossTitanGT_ult
    local PIMU = skillult.info["Script Arg3"]
    local MIMU = skillult.info["Script Arg3"]
    if skillult then
      TowerBuff:setAttribute("PIMU", PIMU)
      TowerBuff:setAttribute("MIMU", MIMU)
    end
    local Tower_Buff = unit:addBuff(TowerBuff, unit)
    unit.TowerBuff = Tower_Buff
  end
  if unit.GuardBuff and unit.GuardBuff.class == ed.Buff and unit.GuardBuff.timer > 0 then
    unit:removeBuff(unit.GuardBuff)
    unit.GuardBuff = nil
  end
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/common/mp_rage.png"))
    end
  end
end

function BossTitanGT.ult_func_TowerChangeToGuard(unit)
  if unit:isAlive() and unit.name == "BossTitanGT" and unit:isGuard() then
    return
  end
  unit:enterActionStageFromOneStage(unit:getGuardPeriod(), 10100)
  BossTitanGT.refreshPanelPic(unit)
  unit.TitanGT_isGuard = true
  if unit.TowerBuff and unit.TowerBuff.class == ed.Buff and unit.TowerBuff.timer > 0 then
    unit:removeBuff(unit.TowerBuff)
    unit.TowerBuff = nil
  end
  if not unit.GuardBuff then
    local bid = 1639
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local GuardBuff = ed.BuffCreate(binfo, unit, unit)
    if unit.TitanGT_hasArcana >= 4 then
      local skillult = unit.skills.BossTitanGT_ult
      local PIMU = skillult.info["Script Arg3"]
      local MIMU = skillult.info["Script Arg3"]
      if skillult then
        GuardBuff:setAttribute("PIMU", PIMU)
        GuardBuff:setAttribute("MIMU", MIMU)
      end
    end
    local Guard_buff = unit:addBuff(GuardBuff, unit)
    unit.GuardBuff = Guard_buff
  end
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/common/mp_rage.png"))
    end
  end
  unit.info["Walk Speed"] = 100
  unit.walk_v = {0, 0}
end

function BossTitanGT.ult_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, BossTitanGT.ult_uncontrollableBuff)
  if caster:isTower() then
    skill.changeMode = "TtoG"
    local buff = caster:addBuff(binfo, caster)
    buff.timer = 1
    skill.TitanGT_uncontrollableBuff = buff
  elseif caster:isGuard() then
    skill.changeMode = "GtoT"
    local buff = caster:addBuff(binfo, caster)
    buff.timer = 1.25
    skill.TitanGT_uncontrollableBuff = buff
  end
  BossTitanGT.ult_func_hideBuffEffect(caster)
end

function BossTitanGT.ult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.changeMode == "TtoG" and caster:isTower() then
    local skillultc = caster.skills.BossTitanGT_ultc
    if skillultc then
      skillultc:takeEffectAt(caster.position)
    end
  elseif skill.changeMode ~= "GtoT" or caster:isGuard() then
  end
end

function BossTitanGT.ult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function BossTitanGT.ult_finish(basefunc, skill)
  local caster = skill.caster
  if skill.TitanGT_uncontrollableBuff then
    skill.TitanGT_uncontrollableBuff.timer = -1
    skill.TitanGT_uncontrollableBuff = nil
  end
  if skill.changeMode == "TtoG" and caster:isTower() then
    BossTitanGT.ult_func_TowerChangeToGuard(caster)
  elseif skill.changeMode == "GtoT" and caster:isGuard() then
    BossTitanGT.ult_func_GuardChangeToTower(caster)
  end
  skill.changeMode = nil
  BossTitanGT.ult_func_resetBuffEffect(caster)
  basefunc(skill)
end

function BossTitanGT.ult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster:isTower() and caster.mp < 500 then
    return false, "mp not enough"
  end
  if caster:isGuard() then
    return false, "Already changed"
  end
  if caster.canCastUlt == false then
    return false, "TitanGT_Ult Casting"
  end
  return basefunc(skill, target)
end

function BossTitanGT.hero_reset(basefunc, hero)
  hero.canCastUlt = true
  hero.TitanGT_isGuard = false
  hero.atk_range_index = 0
  hero.BossIMUBuff_level = 0
  hero:setPosition({200, 0})
  local forntUnit = 0
  local midUnit = 0
  local backUnit = 0
  local forntPosition = 120.1
  local midPosition = 220.1
  local backPosition = 320.1
  basefunc(hero)
  if hero.name == "BossTitanGT" and not hero.config.is_summoned then
    local binfo = ed.lookupDataTable("Buff", nil, BossTitanGT.init_emptyBuff)
    local buff = hero:addBuff(binfo, hero)
    if buff then
      buff.onRemoved = override(buff.onRemoved, BossTitanGT.listener_buff_onRemoved)
    end
  end
end

function BossTitanGT.listener_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local unit = buff.caster
  if unit:isAlive() and unit:isTower() then
    BossTitanGT.ult_func_TowerChangeToGuard(unit)
  end
  if not (ed.engine.wave_id < ed.engine.stage_info.Waves) then
    unit.height = 0
  end
  unit.info["Walk Speed"] = 120
  unit.walk_v = {0, 0}
end

function BossTitanGT.backPositionBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  if damage and 0 < damage then
    caster.backPosition_buff_notgetDamaged = false
    buff.notgetDamagedTime = 0
  else
    caster.backPosition_buff_notgetDamaged = true
  end
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred)
  return dmg
end

function BossTitanGT.backPositionBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  buff.notgetDamagedTime = buff.notgetDamagedTime and buff.notgetDamagedTime + dt or dt
  if buff.notgetDamagedTime >= 3 and buff.shield and buff.shield < buff.info["Shield Value"] then
    buff.shield = buff.info["Shield Value"] / 50 + buff.shield
  end
end

function BossTitanGT.TitanGT_skillallpower(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local max_hp = hero.attribs.HP
  local Current_hp = hero.hp
  local DmgPlus = max_hp - Current_hp
  local skillatk4 = hero.skills.BossTitanGT_atk4
  local power_Ratio = skillatk4.info["Script Arg4"] / 100
  local power_plus = 1
  local Arcana_power = 0
  if hero.forntPositionBuff and hero:isAlive() and not hero.config.is_summoned then
    power_plus = power_Ratio * math.min(DmgPlus, 150000)
  end
  local power = power
  if self.info["Skill Name"] == "BossTitanGT_atk3" and hero.TitanGT_hasArcana >= 3 then
    Arcana_power = hero.attribs.HP * 0.15
  end
  if 0 < Arcana_power then
    power = power + power_plus + math.min(Arcana_power, 40000)
  else
    power = power + power_plus
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

function BossTitanGT.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.BossTitanGT_ult
  local skillatk = hero.skills.BossTitanGT_atk
  local skillatk2 = hero.skills.BossTitanGT_atk2
  local skillatk3 = hero.skills.BossTitanGT_atk3
  local skillultb = hero.skills.BossTitanGT_ultb
  local skillatkb = hero.skills.BossTitanGT_atkb
  local skillatk2b = hero.skills.BossTitanGT_atk2b
  local skillatk3b = hero.skills.BossTitanGT_atk3b
  if hero.atk_range_index then
    hero.atk_range_index = hero.atk_range_index + dt
  end
  if skillatk and hero.atk_range_index <= 0.125 then
    local originfo = skillatk.info
    skillatk.info = ed.wraptable(originfo, {
      ["Max Range"] = skillatk.info["Max Range"] - 200
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    BossTitanGT.refreshPanelPic(hero)
  end
  if hero:isAlive() and not hero:isTower() and hero.name == "TitanGT" then
    if skillatk and skillatk.casting or skillatk2 and skillatk2.casting or skillatk3 and skillatk3.casting or skillult and skillult.casting or skillultb and skillultb.casting or skillatkb and skillatkb.casting or skillatk2b and skillatk2b.casting or skillatk3b and skillatk3b.casting then
      hero.skillOncasting = true
    else
      hero.skillOncasting = false
    end
  end
  if skillult and hero:isAlive() and not hero.buff_effects.polymorph then
    if hero.mp <= 100 and hero.currentActionStage == 1 and hero.skillOncasting == false and hero.TitanGT_isGuard == true then
      hero:castSkill(skillultb, hero)
      hero.TitanGT_isGuard = false
    end
    if skillult.casting or skillultb.casting then
      hero.canCastUlt = false
    else
      hero.canCastUlt = true
    end
  end
  if not hero.BossIMUBuff then
    local bid = BossTitanGT.BossTitanGTIMUBuff_ID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local BossIMUBuff = ed.BuffCreate(binfo, hero, hero)
    hero.BossIMUBuff = hero:addBuff(BossIMUBuff, hero)
  end
  if not hero.BossIMUBuff_count then
    hero.BossIMUBuff_count = 10
  else
    hero.BossIMUBuff_count = hero.BossIMUBuff_count + dt
  end
  if hero.BossIMUBuff_count >= 10 and hero.BossIMUBuff and hero.BossIMUBuff_level <= 5 then
    hero.BossIMUBuff_count = 0
    hero.BossIMUBuff_level = hero.BossIMUBuff_level + 1
    local otherPIMU = hero.attribs.PIMU - (hero.BossIMUBuff_level - 1) * 15
    local otherMIMU = hero.attribs.MIMU - (hero.BossIMUBuff_level - 1) * 15
    hero.BossIMUBuff:setAttribute("PIMU", 0 - otherPIMU + hero.BossIMUBuff_level * 15)
    hero.BossIMUBuff:setAttribute("MIMU", 0 - otherMIMU + hero.BossIMUBuff_level * 15)
    hero:rebuild()
  end
  if not hero.BossTitanGT_knockCD then
    hero.BossTitanGT_knockCD = 0
  else
    hero.BossTitanGT_knockCD = hero.BossTitanGT_knockCD - dt
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  while hero.lastRageHp - hero.hp >= BossTitanGT.ragelosthp do
    local binfo
    local bid = BossTitanGT.rageBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
    hero.lastRageHp = hero.lastRageHp - BossTitanGT.ragelosthp
    hero.rageStack = hero.rageStack + 1
  end
end

function BossTitanGT.knockup(basefunc, hero, time, distance, shift)
  if 0 < time and math.abs(distance[1]) > 10 and hero.BossTitanGT_knockCD and 0 >= hero.BossTitanGT_knockCD and 0 < hero.BossIMUBuff_level then
    hero.BossIMUBuff_level = hero.BossIMUBuff_level - 1
    local otherPIMU = hero.attribs.PIMU - (hero.BossIMUBuff_level + 1) * 15
    local otherMIMU = hero.attribs.MIMU - (hero.BossIMUBuff_level + 1) * 15
    hero.BossIMUBuff:setAttribute("PIMU", 0 - otherPIMU + hero.BossIMUBuff_level * 15)
    hero.BossIMUBuff:setAttribute("MIMU", 0 - otherMIMU + hero.BossIMUBuff_level * 15)
    hero:rebuild()
    hero.BossTitanGT_knockCD = 0.2
  end
  basefunc(hero, time, distance, shift)
end

function BossTitanGT.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.forntPositionBuff then
    hero.forntPositionBuff.timer = -1
  end
  if hero.midPositionBuff then
    hero.midPositionBuff.timer = -1
  end
  if hero.backPositionBuff then
    hero.backPositionBuff.timer = -1
  end
  if hero.TowerBuff then
    hero.TowerBuff.timer = -1
  end
  if hero.GuardBuff then
    hero.GuardBuff.timer = -1
  end
end

function BossTitanGT.init_hero(hero)
  hero.skillOncasting = false
  hero.reset = override(hero.reset, BossTitanGT.hero_reset)
  hero.update = override(hero.update, BossTitanGT.hero_update)
  hero.die = override(hero.die, BossTitanGT.hero_die)
  hero.TitanGT_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.knockup = override(hero.knockup, BossTitanGT.knockup)
  local skillult = hero.skills.BossTitanGT_ult
  local skillatk = hero.skills.BossTitanGT_atk
  local skillatk2 = hero.skills.BossTitanGT_atk2
  local skillatk3 = hero.skills.BossTitanGT_atk3
  local skillultb = hero.skills.BossTitanGT_ultb
  local skillatkb = hero.skills.BossTitanGT_atkb
  local skillatk2b = hero.skills.BossTitanGT_atk2b
  local skillatk3b = hero.skills.BossTitanGT_atk3b
  local skillultc = hero.skills.BossTitanGT_ultc
  if skillatk then
    local originfo = skillatk.info
    skillatk.info = ed.wraptable(originfo, {
      ["Max Range"] = skillatk.info["Max Range"] - 200
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BossTitanGT.atk2_onAttackFrame)
  end
  if skillatk2b then
    skillatk2b.createBuff = override(skillatk2b.createBuff, BossTitanGT.atk2b_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, BossTitanGT.atk3_createBuff)
  end
  if skillatk3b then
    skillatk3b.takeEffectOn = override(skillatk3b.takeEffectOn, BossTitanGT.atk3s_takeEffectOn)
    if hero.TitanGT_hasArcana >= 2 then
      skillatk3b.onAttackFrame = override(skillatk3b.onAttackFrame, BossTitanGT.atk3s_onAttackFrame)
    end
  end
  if skillult then
    skillult.start = override(skillult.start, BossTitanGT.ult_start)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BossTitanGT.ult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossTitanGT.ult_onAttackFrame)
    skillult.finish = override(skillult.finish, BossTitanGT.ult_finish)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, BossTitanGT.ult_onPhaseFinished)
  end
  if skillultb then
    skillultb.start = override(skillultb.start, BossTitanGT.ult_start)
    skillultb.onAttackFrame = override(skillultb.onAttackFrame, BossTitanGT.ult_onAttackFrame)
    skillultb.finish = override(skillultb.finish, BossTitanGT.ult_finish)
    skillultb.onPhaseFinished = override(skillultb.onPhaseFinished, BossTitanGT.ult_onPhaseFinished)
  end
  local skillnames = {
    "_atk",
    "_atk2",
    "_atk3",
    "_atkb",
    "_atk2b",
    "_ultc"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["BossTitanGT" .. skillnames[i]]
    if hero.name == "BossTitanGT" and not hero.config.is_summoned then
      skill.getDamage = override(skill.getDamage, BossTitanGT.TitanGT_skillallpower)
    end
  end
  
  function hero.getGuardPeriod(unit)
    local period = 1
    return period
  end
  
  function hero.getTowerPeriod(unit)
    local period = 2
    return period
  end
  
  function hero.isGuard(unit)
    local current = unit.currentActionStage or 1
    if current == 2 then
      return false
    end
    return true
  end
  
  function hero.isTower(unit)
    local current = unit.currentActionStage or 2
    if current == 1 then
      return false
    end
    return true
  end
  
  hero:setActionStageChangeByManual(true)
  return hero
end

return BossTitanGT.init_hero
