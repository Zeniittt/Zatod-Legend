module("ed.battlehero", package.seeall)
local ed = ed
WorldUD = {}
WorldUD.tombstone_deviation = 150
WorldUD.zombie_Rmin = 15
WorldUD.zombie_Rmax = 35
WorldUD.UD_atk2_HPheal = 2
WorldUD.zombieDuration_UD = 15
WorldUD.ragelosthp = 600000
WorldUD.rage2losthp = 200000
WorldUD.smallzombie_bombcount = 5
WorldUD.ult_interval = 2
WorldUD.ult2_interval = 0.25
WorldUD.stage2hp = 30000000
WorldUD.stage2ragelosthp = 400000

function WorldUD.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldUD.rage_buff_update)
  hero.lastrageStack = 0
  hero.UD_smallzombielist = {}
  hero.UD_tombstone = nil
  hero.UD_DamageLine = 200000
  hero.UD_atk4summon_times = 0
  hero.UD_atk3totalDamage = 0
  hero.instageDamage = hero.battledata.beardmg
  hero.ultBuff_UD = nil
  hero.smallzombie_count = 0
end

function WorldUD.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.3)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.3)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.3)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.3)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldUD.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type)
  if damage_type then
    return 1
  else
    return basefunc(hero, damage, immunity, damage_type)
  end
end

function WorldUD.hero_takeHeal(basefunc, hero, amount, _type, source)
  basefunc(hero, 1, _type, source)
end

function WorldUD.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.UD_smallzombielist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  if hero.UD_tombstone and hero.UD_tombstone:isAlive() then
    hero.UD_tombstone:die()
  end
  basefunc(hero, hero, killer)
end

function WorldUD.smallzombie_skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function WorldUD.smallzombie_skillatk_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local atkbuff
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 564 then
      atkbuff = true
    end
  end
  if atkbuff then
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
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

function WorldUD.smallzombie_die(basefunc, hero, killer)
  local UD = hero.config.summoner
  local skillatk2s = UD.skills.WorldUD_atk2s
  local hp_amount = skillatk2s.info["Script Arg2"]
  local mp_amount = skillatk2s.info["Script Arg3"]
  UD:takeHeal(hp_amount, "hp", UD)
  UD:takeHeal(mp_amount, "mp", UD)
  for i, tbuff in ipairs(UD.buff_list) do
    if tbuff.info.ID == 565 then
      tbuff.timer = 0
    end
  end
  basefunc(hero, killer)
  UD.smallzombie_count = UD.smallzombie_count - 1
end

function WorldUD.smallzombie_update(basefunc, hero, dt)
  hero.zombieDuration_UD = hero.zombieDuration_UD - dt
  if hero.zombieDuration_UD <= 0 and hero:isAlive() then
    hero:die()
  else
    basefunc(hero, dt)
  end
  if hero:isAlive() and hero.config.summoner.smallzombie_count >= WorldUD.smallzombie_bombcount then
    local smallzombie_skill_boom = hero.skills.Worldsmallzombie_boom
    smallzombie_skill_boom:takeEffectAt(hero.position)
    hero:die()
  end
end

function WorldUD.smallzombie_atk_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local ai_target = skill.caster.ai.target
  if result and target ~= ai_target then
    result = nil
  end
  return result
end

function WorldUD.smallzombie_takeEffectOn(basefunc, skill, target, source)
  local result, dmg = basefunc(skill, target, source)
  local smallzombie = skill.caster
  local UD = smallzombie.config.summoner
  local bid = 564
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = smallzombie:addBuff(binfo, smallzombie)
  local skillawake = UD.skills.WorldUD_awake
  if skillawake and ed.protoAwake(UD.proto, 237) then
    skillawake:takeEffectOn(target, source)
  end
end

function WorldUD.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function WorldUD.smallzombie_ai_searchTarget(basefunc, ai)
  local smallzombie = ai.owner
  local target, minDistanSQ = basefunc(ai)
  local skillatk = smallzombie.skills.Worldsmallzombie_atk
  local distanceSQ = 9999
  local maxINT = 0
  for unit in ed.engine:foreachAliveUnit(smallzombie.foecamp) do
    if unit ~= smallzombie and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.config.is_summoned and unit.position[1] <= ed.engine.stage_rect.maxX and unit.position[1] >= ed.engine.stage_rect.minX then
      local int = unit.attribs.INT
      if maxINT < int then
        maxINT = int
        target = unit
        distanceSQ = WorldUD.twoPointDistanceSQ(smallzombie.position, unit.position)
      end
    end
  end
  return target, distanceSQ
end

function WorldUD.tombstone_atk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local UD = skill.caster.config.summoner
  local tombstone = skill.caster
  local skillatk2 = UD.skills.WorldUD_atk2
  local dir = UD:getInitDir()
  local r = ed.rand() * (WorldUD.zombie_Rmax - WorldUD.zombie_Rmin) + WorldUD.zombie_Rmin
  local angle = ed.rand() * 360
  local smallzombie_position = {
    tombstone.position[1] + r * math.cos(math.rad(angle)),
    tombstone.position[2] + r * math.sin(math.rad(angle))
  }
  local skillevel = {
    skillatk2.level,
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 243,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = 1,
    _rank = UD.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = UD.config.dps_mod or 1
  }
  local smallzombie = ed.UnitCreate(proto, UD.camp, config)
  local smallzombie_atk = smallzombie.skills.Worldsmallzombie_atk
  smallzombie.zombieDuration_UD = WorldUD.zombieDuration_UD
  smallzombie.die = override(smallzombie.die, WorldUD.smallzombie_die)
  smallzombie.update = override(smallzombie.update, WorldUD.smallzombie_update)
  smallzombie.ai.searchTarget = override(smallzombie.ai.searchTarget, WorldUD.smallzombie_ai_searchTarget)
  smallzombie.getLostHPAfterImmunity = override(smallzombie.getLostHPAfterImmunity, WorldUD.hero_getLostHPAfterImmunity)
  smallzombie.takeHeal = override(smallzombie.takeHeal, WorldUD.hero_takeHeal)
  smallzombie_atk.takeEffectOn = override(smallzombie_atk.takeEffectOn, WorldUD.smallzombie_takeEffectOn)
  smallzombie_atk.canCastWithTarget = override(smallzombie_atk.canCastWithTarget, WorldUD.smallzombie_atk_canCastWithTarget)
  smallzombie_atk.start = override(smallzombie_atk.start, WorldUD.smallzombie_skillatk_start)
  smallzombie_atk.onPhaseFinished = override(smallzombie_atk.onPhaseFinished, WorldUD.smallzombie_skillatk_onPhaseFinished)
  smallzombie.direction = tombstone.direction
  tombstone:setHP(tombstone.hp - 1)
  ed.engine:summonUnit(smallzombie, smallzombie_position, UD)
  local bid = 563
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = smallzombie:addBuff(binfo, tombstone)
  local skillatk4 = UD.skills.WorldUD_atk4
  if skillatk4 then
    UD:addBuff(skillatk4:createBuff(UD), smallzombie)
  end
  table.insert(UD.UD_smallzombielist, smallzombie)
  UD.smallzombie_count = UD.smallzombie_count + 1
end

function WorldUD.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.UD_tombstone and caster.UD_tombstone:isAlive() then
    caster.UD_tombstone:setHP(caster.UD_tombstone.hp + WorldUD.UD_atk2_HPheal)
    if ed.run_with_scene then
      local effect_name = "eff_impact_heal.cha"
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, caster.UD_tombstone.position, {
        caster.UD_tombstone.direction,
        1
      }, nil, effect_z)
    end
  else
    local skillatk2 = caster.skills.WorldUD_atk2
    local dir = caster:getInitDir()
    local tombstone_position = {
      ed.engine.stage_rect.minX + WorldUD.tombstone_deviation,
      0
    }
    if dir == -1 then
      tombstone_position = {
        ed.engine.stage_rect.maxX - WorldUD.tombstone_deviation,
        0
      }
    end
    local skillevel = {
      skillatk2.level,
      skillatk2.level,
      skillatk2.level
    }
    local proto = {
      _tid = 214,
      _level = skillatk2.level or 1,
      _skill_levels = skillevel,
      _stars = 1,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 2,
      dps_mod = caster.config.dps_mod or 1
    }
    local tombstone = ed.UnitCreate(proto, caster.camp, config)
    tombstone.getLostHPAfterImmunity = override(tombstone.getLostHPAfterImmunity, WorldUD.hero_getLostHPAfterImmunity)
    tombstone.takeHeal = override(tombstone.takeHeal, WorldUD.hero_takeHeal)
    local tombstone_atk = tombstone.skills.tombstone_atk
    tombstone_atk.onAttackFrame = override(tombstone_atk.onAttackFrame, WorldUD.tombstone_atk_onAttackFrame)
    tombstone.direction = caster.direction
    ed.engine:summonUnit(tombstone, tombstone_position, caster)
    local bid = 562
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = tombstone:addBuff(binfo, tombstone)
    caster.UD_tombstone = tombstone
  end
end

function WorldUD.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local result, reason = basefunc(skill, target)
  if not result or hero.mp < 500 or hero.ultBuff_UD or hero.current_skill == hero.manual_skill then
    return false
  end
  return true
end

function WorldUD.skillultswitch_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 575 then
      tbuff.owner:removeBuff(tbuff)
    end
  end
end

function WorldUD.skillult_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  local owner = buff.owner
  while timer <= 0 do
    timer = timer + WorldUD.ult_interval
    local skillult2 = buff.caster.skills.WorldUD_ult2
    local target = skillult2:selectTarget()
    if target and owner:isAlive() then
      local owner = skillult2.caster
      skillult2:takeEffectAt(owner.position)
      buff.total_times = buff.total_times + 1
    end
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function WorldUD.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = owner.skills.WorldUD_atk
  if skillatk then
    skillatk.info = skillatk.originfo
  end
  basefunc(buff)
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "WorldUD" then
        if ed.protoAwake(owner.proto, 237) then
          panel:setPortrait("UI/DOTA-HERO/SwitchUD.png")
        else
          panel:setPortrait("UI/DOTA-HERO/UD.png")
        end
      end
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
  if owner.changePeriod_UD then
    if not ed.engine.beingEnd or owner:isAlive() then
      owner:enterActionStageFromOneStage(owner:UDGetNormalPeriod(), 237)
    end
    owner.changePeriod_UD = nil
    owner.ultBuff_UD = nil
  end
end

function WorldUD.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, WorldUD.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, WorldUD.skillult_buffOnRemoved)
  buff.attack_timer = WorldUD.ult2_interval
  buff.total_times = 0
  buff.owner.ultBuff_UD = true
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "WorldUD" then
        if ed.protoAwake(caster.proto, 237) then
          panel:setPortrait("UI/DOTA-HERO/SwitchUDult.png")
        else
          panel:setPortrait("UI/DOTA-HERO/UDult.png")
        end
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  local skillatk = buff.owner.skills.WorldUD_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Plus Ratio"] = 1.2
    })
  end
  return buff
end

function WorldUD.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.changePeriod_UD = true
end

function WorldUD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_UD then
    caster:enterActionStageFromOneStage(caster:UDGetUltPeriod(), 237)
  end
end

function WorldUD.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local result, dmg = basefunc(skill, target, source)
  if result then
    local caster = skill.caster
    caster.UD_atk3totalDamage = caster.UD_atk3totalDamage + dmg
  end
end

function WorldUD.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.WorldUD_atk3s
  if skillatk3s then
    for i, unit in ipairs(caster.UD_smallzombielist) do
      if unit and unit:isAlive() then
        skillatk3s:takeEffectOn(unit)
      end
    end
    if caster.UD_tombstone and caster.UD_tombstone:isAlive() then
      skillatk3s:takeEffectOn(caster.UD_tombstone)
    end
    skillatk3s:takeEffectOn(caster)
    caster.UD_atk3totalDamage = 0
  end
end

function WorldUD.skillatk3s_power(basefunc, skill, source, target, damage_type)
  local percent = skill.info["Script Arg2"]
  local power = skill.caster.UD_atk3totalDamage * percent / 100
  return power
end

function WorldUD.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() and not ed.engine.beingEnd and hero.battledata.beardmg - hero.instageDamage >= hero.UD_DamageLine * (hero.UD_atk4summon_times + 1) then
    local skillatk2 = hero.skills.WorldUD_atk2
    local dir = hero:getInitDir()
    local r = ed.rand() * (WorldUD.zombie_Rmax - WorldUD.zombie_Rmin) + WorldUD.zombie_Rmin
    local angle = ed.rand() * 360
    local smallzombie_position = {
      hero.position[1] + r * math.cos(math.rad(angle)),
      hero.position[2] + r * math.sin(math.rad(angle))
    }
    local skillevel = {
      skillatk2.level,
      skillatk2.level,
      skillatk2.level
    }
    local proto = {
      _tid = 243,
      _level = skillatk2.level or 1,
      _skill_levels = skillevel,
      _stars = 1,
      _rank = hero.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = hero.config.dps_mod or 1
    }
    local smallzombie = ed.UnitCreate(proto, hero.camp, config)
    local smallzombie_atk = smallzombie.skills.Worldsmallzombie_atk
    smallzombie.zombieDuration_UD = WorldUD.zombieDuration_UD
    smallzombie.update = override(smallzombie.update, WorldUD.smallzombie_update)
    smallzombie.die = override(smallzombie.die, WorldUD.smallzombie_die)
    smallzombie.ai.searchTarget = override(smallzombie.ai.searchTarget, WorldUD.smallzombie_ai_searchTarget)
    smallzombie.getLostHPAfterImmunity = override(smallzombie.getLostHPAfterImmunity, WorldUD.hero_getLostHPAfterImmunity)
    smallzombie.takeHeal = override(smallzombie.takeHeal, WorldUD.hero_takeHeal)
    smallzombie_atk.takeEffectOn = override(smallzombie_atk.takeEffectOn, WorldUD.smallzombie_takeEffectOn)
    smallzombie_atk.start = override(smallzombie_atk.start, WorldUD.smallzombie_skillatk_start)
    smallzombie_atk.onPhaseFinished = override(smallzombie_atk.onPhaseFinished, WorldUD.smallzombie_skillatk_onPhaseFinished)
    smallzombie.direction = dir
    ed.engine:summonUnit(smallzombie, smallzombie_position, hero)
    local bid = 563
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = smallzombie:addBuff(binfo, hero)
    if ed.run_with_scene then
      local effect_name = "eff_point_UD_atk4.cha"
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, hero.position, {
        hero.direction,
        1
      }, nil, effect_z)
    end
    local skillatk4 = hero.skills.WorldUD_atk4
    if skillatk4 then
      hero:addBuff(skillatk4:createBuff(hero), smallzombie)
    end
    table.insert(hero.UD_smallzombielist, smallzombie)
    hero.smallzombie_count = hero.smallzombie_count + 1
    hero.UD_atk4summon_times = hero.UD_atk4summon_times + 1
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldUD.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldUD.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldUD.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldUD.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldUD.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldUD.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldUD.stage2hp and hero.hp - lost <= WorldUD.stage2hp then
    return hero.hp - WorldUD.stage2hp
  else
    return lost
  end
end

function WorldUD.init_hero(hero)
  local skillult = hero.skills.WorldUD_ult
  local skillult2 = hero.skills.WorldUD_ult2
  local skillatk2 = hero.skills.WorldUD_atk2
  local skillatk3 = hero.skills.WorldUD_atk3
  local skillatk3s = hero.skills.WorldUD_atk3s
  local skillatk4 = hero.skills.WorldUD_atk4
  hero:setActionStageChangeByManual(true)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldUD.getLostHPAfterImmunity)
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, WorldUD.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, WorldUD.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldUD.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, WorldUD.skillult_finish)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldUD.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldUD.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, WorldUD.skillatk3_finish)
    skillatk3s.power = override(skillatk3s.power, WorldUD.skillatk3s_power)
  end
  if skillatk4 then
    hero.update = override(hero.update, WorldUD.hero_update)
  end
  local skillultswitch = hero.skills.WorldUD_ultswitch
  if skillultswitch then
    skillultswitch.finish = override(skillultswitch.finish, WorldUD.skillultswitch_finish)
  end
  hero.reset = override(hero.reset, WorldUD.hero_reset)
  hero.die = override(hero.die, WorldUD.hero_die)
  
  function hero.UDGetNormalPeriod(unit)
    return ed.protoAwake(unit.proto, 237) and 3 or 1
  end
  
  function hero.UDGetUltPeriod(unit)
    return ed.protoAwake(unit.proto, 237) and 4 or 2
  end
  
  if ed.protoAwake(hero.proto, 237) then
    hero:enterActionStageFromOneStage(hero:UDGetNormalPeriod(), 237)
  end
  return hero
end

return WorldUD.init_hero
