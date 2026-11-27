module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossUD = {}
AwakeBossUD.smallzombieattribs = 10035506
AwakeBossUD.tombstone_deviation = 150
AwakeBossUD.zombie_Rmin = 15
AwakeBossUD.zombie_Rmax = 35
AwakeBossUD.AwakeBossUD_atk2_HPheal = 4
AwakeBossUD.zombieDuration_AwakeBossUD = 15
AwakeBossUD.ult_interval = 2
AwakeBossUD.ult2_interval = 0.25

function AwakeBossUD.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.AwakeBossUD_smallzombielist = {}
  hero.AwakeBossUD_tombstone = nil
  hero.AwakeBossUD_DamageLine = hero.attribs.HP * 0.08
  hero.AwakeBossUD_atk4summon_times = 0
  hero.AwakeBossUD_atk3totalDamage = 0
  hero.instageDamage = hero.battledata.beardmg
  hero.ultBuff_AwakeBossUD = nil
end

function AwakeBossUD.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type)
  if damage_type then
    return 1
  else
    return basefunc(hero, damage, immunity, damage_type)
  end
end

function AwakeBossUD.hero_takeHeal(basefunc, hero, amount, _type, source)
  basefunc(hero, 1, _type, source)
end

function AwakeBossUD.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.AwakeBossUD_smallzombielist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  if hero.AwakeBossUD_tombstone1 and hero.AwakeBossUD_tombstone1:isAlive() then
    hero.AwakeBossUD_tombstone1:die()
  end
  if hero.AwakeBossUD_tombstone2 and hero.AwakeBossUD_tombstone2:isAlive() then
    hero.AwakeBossUD_tombstone2:die()
  end
  basefunc(hero, killer)
end

function AwakeBossUD.smallzombie_skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function AwakeBossUD.smallzombie_skillatk_start(basefunc, skill, target)
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
    if tbuff.info.ID == 10035504 then
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

function AwakeBossUD.smallzombie_die(basefunc, hero, killer)
  local AwakeBossUD = hero.config.summoner
  local skillatk2s = AwakeBossUD.skills.AwakeBossUD_atk2s
  local hp_amount = skillatk2s.info["Script Arg2"] * AwakeBossUD.attribs.HP / 100
  local mp_amount = skillatk2s.info["Script Arg3"]
  AwakeBossUD:takeHeal(hp_amount, "hp", AwakeBossUD)
  AwakeBossUD:takeHeal(mp_amount, "mp", AwakeBossUD)
  basefunc(hero, killer)
end

function AwakeBossUD.smallzombie_update(basefunc, hero, dt)
  hero.zombieDuration_AwakeBossUD = hero.zombieDuration_AwakeBossUD - dt
  if hero.zombieDuration_AwakeBossUD <= 0 and hero:isAlive() then
    hero:die()
  else
    basefunc(hero, dt)
  end
end

function AwakeBossUD.smallzombie_takeEffectOn(basefunc, skill, target, source)
  local result, dmg = basefunc(skill, target, source)
  local smallzombie = skill.caster
  local AwakeBossUD = smallzombie.config.summoner
  local bid = 10035504
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = smallzombie:addBuff(binfo, smallzombie)
end

function AwakeBossUD.smallzombie_skillatk_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local hero = caster.config.summoner
  local skillatk2 = hero.skills.AwakeBossUD_atk2
  local info = skill.info
  power = hero.attribs.AP * 0.55 + skillatk2.info["Script Arg3"]
  return power, coeff
end

function AwakeBossUD.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function AwakeBossUD.smallzombie_ai_searchTarget(basefunc, ai)
  local smallzombie = ai.owner
  local target, minDistanSQ = basefunc(ai)
  local skillatk = smallzombie.skills.smallzombie_atk2
  local distanceSQ = 9999
  local maxINT = 0
  for unit in ed.engine:foreachAliveUnit(smallzombie.foecamp) do
    if unit ~= smallzombie and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.config.is_summoned and unit.position[1] <= ed.engine.stage_rect.maxX and unit.position[1] >= ed.engine.stage_rect.minX then
      local int = unit.attribs.INT
      if maxINT < int then
        maxINT = int
        target = unit
        distanceSQ = AwakeBossUD.twoPointDistanceSQ(smallzombie.position, unit.position)
      end
    end
  end
  return target, distanceSQ
end

function AwakeBossUD.tombstone_atk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster.config.summoner
  local tombstone = skill.caster
  local skillatk2 = hero.skills.AwakeBossUD_atk2
  local dir = hero:getInitDir()
  local r = ed.rand() * (AwakeBossUD.zombie_Rmax - AwakeBossUD.zombie_Rmin) + AwakeBossUD.zombie_Rmin
  local angle = ed.rand() * 360
  local smallzombie_position = {
    tombstone.position[1] + r * math.cos(math.rad(angle)),
    tombstone.position[2] + r * math.sin(math.rad(angle))
  }
  local skillevel = {
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 215,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = 1,
    _rank = hero.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = 1.5
  }
  local smallzombie = ed.UnitCreate(proto, hero.camp, config)
  local smallzombie_atk2 = smallzombie.skills.smallzombie_atk2
  smallzombie.zombieDuration_AwakeBossUD = AwakeBossUD.zombieDuration_AwakeBossUD
  smallzombie.die = override(smallzombie.die, AwakeBossUD.smallzombie_die)
  smallzombie.update = override(smallzombie.update, AwakeBossUD.smallzombie_update)
  smallzombie.ai.searchTarget = override(smallzombie.ai.searchTarget, AwakeBossUD.smallzombie_ai_searchTarget)
  smallzombie.getLostHPAfterImmunity = override(smallzombie.getLostHPAfterImmunity, AwakeBossUD.hero_getLostHPAfterImmunity)
  smallzombie.takeHeal = override(smallzombie.takeHeal, AwakeBossUD.hero_takeHeal)
  smallzombie_atk2.takeEffectOn = override(smallzombie_atk2.takeEffectOn, AwakeBossUD.smallzombie_takeEffectOn)
  smallzombie_atk2.start = override(smallzombie_atk2.start, AwakeBossUD.smallzombie_skillatk_start)
  smallzombie_atk2.onPhaseFinished = override(smallzombie_atk2.onPhaseFinished, AwakeBossUD.smallzombie_skillatk_onPhaseFinished)
  smallzombie_atk2.power = override(smallzombie_atk2.power, AwakeBossUD.smallzombie_skillatk_power)
  smallzombie.direction = tombstone.direction
  tombstone:setHP(tombstone.hp - 1)
  ed.engine:summonUnit(smallzombie, smallzombie_position, hero)
  local bid = 10035503
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = smallzombie:addBuff(binfo, tombstone)
  table.insert(hero.AwakeBossUD_smallzombielist, smallzombie)
end

function AwakeBossUD.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.AwakeBossUD_tombstone1 and caster.AwakeBossUD_tombstone1:isAlive() then
    caster.AwakeBossUD_tombstone1:setHP(caster.AwakeBossUD_tombstone1.hp + AwakeBossUD.AwakeBossUD_atk2_HPheal)
    if ed.run_with_scene then
      local effect_name = "eff_impact_heal.cha"
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, caster.AwakeBossUD_tombstone1.position, {
        caster.AwakeBossUD_tombstone1.direction,
        1
      }, nil, effect_z)
    end
  else
    local skillatk2 = caster.skills.AwakeBossUD_atk2
    local dir = caster:getInitDir()
    local tombstone_position1 = {
      ed.engine.stage_rect.minX + AwakeBossUD.tombstone_deviation,
      0
    }
    local skillevel = {
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
      hp_mod = 1,
      dps_mod = 1.5
    }
    local tombstone1 = ed.UnitCreate(proto, caster.camp, config)
    tombstone1.getLostHPAfterImmunity = override(tombstone1.getLostHPAfterImmunity, AwakeBossUD.hero_getLostHPAfterImmunity)
    tombstone1.takeHeal = override(tombstone1.takeHeal, AwakeBossUD.hero_takeHeal)
    local tombstone_atk = tombstone1.skills.tombstone_atk
    tombstone_atk.onAttackFrame = override(tombstone_atk.onAttackFrame, AwakeBossUD.tombstone_atk_onAttackFrame)
    tombstone1.direction = caster.direction
    ed.engine:summonUnit(tombstone1, tombstone_position1, caster)
    local bid = 10035502
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = tombstone1:addBuff(binfo, tombstone1)
    caster.AwakeBossUD_tombstone1 = tombstone1
  end
  if caster.AwakeBossUD_tombstone2 and caster.AwakeBossUD_tombstone2:isAlive() then
    caster.AwakeBossUD_tombstone2:setHP(caster.AwakeBossUD_tombstone2.hp + AwakeBossUD.AwakeBossUD_atk2_HPheal)
    if ed.run_with_scene then
      local effect_name = "eff_impact_heal.cha"
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, caster.AwakeBossUD_tombstone2.position, {
        caster.AwakeBossUD_tombstone2.direction,
        1
      }, nil, effect_z)
    end
  else
    local skillatk2 = caster.skills.AwakeBossUD_atk2
    local dir = caster:getInitDir()
    local tombstone_position2 = {
      ed.engine.stage_rect.maxX - AwakeBossUD.tombstone_deviation,
      0
    }
    local skillevel = {
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
      hp_mod = 1,
      dps_mod = 1.5
    }
    local tombstone2 = ed.UnitCreate(proto, caster.camp, config)
    tombstone2.getLostHPAfterImmunity = override(tombstone2.getLostHPAfterImmunity, AwakeBossUD.hero_getLostHPAfterImmunity)
    tombstone2.takeHeal = override(tombstone2.takeHeal, AwakeBossUD.hero_takeHeal)
    local tombstone_atk = tombstone2.skills.tombstone_atk
    tombstone_atk.onAttackFrame = override(tombstone_atk.onAttackFrame, AwakeBossUD.tombstone_atk_onAttackFrame)
    tombstone2.direction = caster.direction
    ed.engine:summonUnit(tombstone2, tombstone_position2, caster)
    local bid = 10035502
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = tombstone2:addBuff(binfo, tombstone2)
    caster.AwakeBossUD_tombstone2 = tombstone2
  end
end

function AwakeBossUD.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local result, reason = basefunc(skill, target)
  if not result or hero.ultBuff_AwakeBossUD or hero.mp < 700 or hero.current_skill == hero.manual_skill then
    return false
  end
  return true
end

function AwakeBossUD.skillultswitch_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10035501 then
      tbuff.owner:removeBuff(tbuff)
    end
  end
end

function AwakeBossUD.skillult_buffUpdate(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  local owner = buff.owner
  local hpheal = owner.attribs.HP * 0.001
  while timer <= 0 do
    timer = timer + AwakeBossUD.ult_interval
    local skillult2 = buff.caster.skills.AwakeBossUD_ult2
    if skillult2 then
      owner:takeHeal(hpheal, "hp", owner)
    end
    local target = skillult2:selectTarget()
    if target and owner:isAlive() then
      local owner = skillult2.caster
      skillult2:takeEffectAt(owner.position)
      buff.total_times = buff.total_times + 1
    end
  end
  buff.attack_timer = timer
  if owner.mp <= 50 and not buff.owner.current_skill then
    local skillultswitch = owner.skills.AwakeBossUD_ultswitch
    owner:castSkill(skillultswitch, owner)
  end
  basefunc(buff, dt)
end

function AwakeBossUD.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = owner.skills.AwakeBossUD_atk
  if skillatk then
    skillatk.info = skillatk.originfo
  end
  basefunc(buff)
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      if buff.owner.name == "AwakeBossUD" then
        panel:setPortrait("UI/DOTA-HERO/UD.png")
      end
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
  if owner.changePeriod_AwakeBossUD then
    if not ed.engine.beingEnd or owner:isAlive() then
      owner:enterActionStageFromOneStage(owner:AwakeBossUDGetNormalPeriod(), 355)
    end
    owner.changePeriod_AwakeBossUD = nil
    owner.ultBuff_AwakeBossUD = nil
  end
end

function AwakeBossUD.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, AwakeBossUD.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, AwakeBossUD.skillult_buffOnRemoved)
  buff.attack_timer = AwakeBossUD.ult2_interval
  buff.total_times = 0
  buff.owner.ultBuff_AwakeBossUD = true
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel then
      if buff.owner.name == "AwakeBossUD" then
        panel:setPortrait("UI/DOTA-HERO/UDult.png")
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  local skillatk = buff.owner.skills.AwakeBossUD_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Plus Ratio"] = 1.2
    })
  end
  return buff
end

function AwakeBossUD.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.changePeriod_AwakeBossUD = true
end

function AwakeBossUD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_AwakeBossUD then
    caster:enterActionStageFromOneStage(caster:AwakeBossUDGetUltPeriod(), 355)
  end
end

function AwakeBossUD.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    position = {400, 0}
    return position
  end
end

function AwakeBossUD.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  if attack_counter == 0 then
    local aim_position = AwakeBossUD.DOP_in_battlefield(hero, 180, -hero.camp)
    skill:takeEffectAt(aim_position, hero)
    hero:setMP(hero.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function AwakeBossUD.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local result, dmg = basefunc(skill, target, source)
  if result then
    local caster = skill.caster
    caster.AwakeBossUD_atk3totalDamage = caster.AwakeBossUD_atk3totalDamage + dmg
  end
end

function AwakeBossUD.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.AwakeBossUD_atk3s
  if skillatk3s then
    for i, unit in ipairs(caster.AwakeBossUD_smallzombielist) do
      if unit and unit:isAlive() then
        skillatk3s:takeEffectOn(unit)
      end
    end
    if caster.AwakeBossUD_tombstone and caster.AwakeBossUD_tombstone:isAlive() then
      skillatk3s:takeEffectOn(caster.AwakeBossUD_tombstone)
    end
    skillatk3s:takeEffectOn(caster)
    caster.AwakeBossUD_atk3totalDamage = 0
  end
end

function AwakeBossUD.skillatk3s_power(basefunc, skill, source, target, damage_type)
  local percent = skill.info["Script Arg2"]
  local power = skill.caster.AwakeBossUD_atk3totalDamage * percent / 100
  return power
end

function AwakeBossUD.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() and not ed.engine.beingEnd and hero.battledata.beardmg - hero.instageDamage >= hero.AwakeBossUD_DamageLine * (hero.AwakeBossUD_atk4summon_times + 1) then
    local skillatk2 = hero.skills.AwakeBossUD_atk2
    local dir = hero:getInitDir()
    local r = ed.rand() * (AwakeBossUD.zombie_Rmax - AwakeBossUD.zombie_Rmin) + AwakeBossUD.zombie_Rmin
    local angle = ed.rand() * 360
    local smallzombie_position = {
      hero.position[1] + r * math.cos(math.rad(angle)),
      hero.position[2] + r * math.sin(math.rad(angle))
    }
    local skillevel = {
      skillatk2.level,
      skillatk2.level
    }
    local proto = {
      _tid = 215,
      _level = skillatk2.level or 1,
      _skill_levels = skillevel,
      _stars = 1,
      _rank = hero.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = 1.5
    }
    local smallzombie = ed.UnitCreate(proto, hero.camp, config)
    local smallzombie_atk2 = smallzombie.skills.smallzombie_atk2
    smallzombie.zombieDuration_AwakeBossUD = AwakeBossUD.zombieDuration_AwakeBossUD
    smallzombie.update = override(smallzombie.update, AwakeBossUD.smallzombie_update)
    smallzombie.die = override(smallzombie.die, AwakeBossUD.smallzombie_die)
    smallzombie.ai.searchTarget = override(smallzombie.ai.searchTarget, AwakeBossUD.smallzombie_ai_searchTarget)
    smallzombie.getLostHPAfterImmunity = override(smallzombie.getLostHPAfterImmunity, AwakeBossUD.hero_getLostHPAfterImmunity)
    smallzombie.takeHeal = override(smallzombie.takeHeal, AwakeBossUD.hero_takeHeal)
    smallzombie_atk2.takeEffectOn = override(smallzombie_atk2.takeEffectOn, AwakeBossUD.smallzombie_takeEffectOn)
    smallzombie_atk2.start = override(smallzombie_atk2.start, AwakeBossUD.smallzombie_skillatk_start)
    smallzombie_atk2.onPhaseFinished = override(smallzombie_atk2.onPhaseFinished, AwakeBossUD.smallzombie_skillatk_onPhaseFinished)
    smallzombie_atk2.power = override(smallzombie_atk2.power, AwakeBossUD.smallzombie_skillatk_power)
    smallzombie.direction = dir
    ed.engine:summonUnit(smallzombie, smallzombie_position, hero)
    local bid = 10035503
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
    table.insert(hero.AwakeBossUD_smallzombielist, smallzombie)
    hero.AwakeBossUD_atk4summon_times = hero.AwakeBossUD_atk4summon_times + 1
  end
end

function AwakeBossUD.init_hero(hero)
  local skillult = hero.skills.AwakeBossUD_ult
  local skillult2 = hero.skills.AwakeBossUD_ult2
  local skillatk2 = hero.skills.AwakeBossUD_atk2
  local skillatk3 = hero.skills.AwakeBossUD_atk3
  local skillatk3s = hero.skills.AwakeBossUD_atk3s
  local skillatk4 = hero.skills.AwakeBossUD_atk4
  hero:setActionStageChangeByManual(true)
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, AwakeBossUD.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, AwakeBossUD.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, AwakeBossUD.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, AwakeBossUD.skillult_finish)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, AwakeBossUD.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, AwakeBossUD.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, AwakeBossUD.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, AwakeBossUD.skillatk3_finish)
    skillatk3s.power = override(skillatk3s.power, AwakeBossUD.skillatk3s_power)
  end
  if skillatk4 then
    hero.update = override(hero.update, AwakeBossUD.hero_update)
  end
  local skillultswitch = hero.skills.AwakeBossUD_ultswitch
  if skillultswitch then
    skillultswitch.finish = override(skillultswitch.finish, AwakeBossUD.skillultswitch_finish)
  end
  hero.reset = override(hero.reset, AwakeBossUD.hero_reset)
  hero.die = override(hero.die, AwakeBossUD.hero_die)
  
  function hero.AwakeBossUDGetNormalPeriod(unit)
    return 1
  end
  
  function hero.AwakeBossUDGetUltPeriod(unit)
    return 2
  end
  
  return hero
end

return AwakeBossUD.init_hero
