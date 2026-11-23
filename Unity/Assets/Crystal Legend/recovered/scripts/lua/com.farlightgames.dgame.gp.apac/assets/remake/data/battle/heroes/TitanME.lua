module("ed.battlehero", package.seeall)
local ed = ed
TitanME = {}

function TitanME.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skilllevel = {
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level
  }
  local proto = {
    _tid = 292,
    _level = skill.level or 1,
    _stars = caster.stars,
    _skill_levels = skilllevel,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local TitanMEbot1 = ed.UnitCreate(proto, caster.camp, config)
  TitanMEbot1.direction = caster.direction
  local locationTitanMEbot1 = {
    caster.position[1] + 90 * caster.direction,
    caster.position[2] - 3
  }
  ed.engine:summonUnit(TitanMEbot1, locationTitanMEbot1, caster, "Enter")
  TitanMEbot1.father = caster
  TitanMEbot1.notPopupBattleInfo = true
  local TitanMEbot1_skillatk = TitanMEbot1.skills.TitanMEbot1_atk
  TitanMEbot1.TitanMEbot1_atk_casted = false
  TitanMEbot1:setHpVisible(false)
  TitanMEbot1.update = override(TitanMEbot1.update, TitanME.TitanMEbot1_update)
  TitanMEbot1_skillatk.finish = override(TitanMEbot1_skillatk.finish, TitanME.TitanMEbot1_skillatk_finish)
  TitanMEbot1_skillatk.takeEffectAt = override(TitanMEbot1_skillatk.takeEffectAt, TitanME.TitanMEbot1_skillatk_takeEffectAt)
  TitanMEbot1.ai.searchTarget = override(TitanMEbot1.ai.searchTarget, TitanME.TitanMEbot1_ai_searchTarget)
  if caster.TitanME_hasArcana and 1 < caster.TitanME_hasArcana then
    TitanMEbot1_skillatk.createBuff = override(TitanMEbot1_skillatk.createBuff, TitanME.TitanMEbot1_skillatk_createBuff)
  end
  TitanMEbot1.flying = true
  local bid = 4303
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot1, caster)
  buff:setAttribute("AP", math.max(1, caster.attribs.AP - TitanMEbot1.attribs.AP))
  buff:setAttribute("MCRIT", math.max(1, caster.attribs.MCRIT - TitanMEbot1.attribs.MCRIT))
  TitanMEbot1:addBuff(buff, caster)
end

function TitanME.TitanMEbot1_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk = hero.skills.TitanMEbot1_atk
  if skillatk and hero.state == ed.emUnitState_Dying and not hero.TitanMEbot1_atk_casted and skillatk then
    skillatk:takeEffectAt(hero.position)
    hero.TitanMEbot1_atk_casted = true
  end
  if hero.alive_time and hero:isAlive() then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 and not hero.TitanMEbot_time_out then
      hero.TitanMEbot_time_out = true
      hero:die()
    end
  else
    hero.alive_time = 8
  end
end

function TitanME.TitanMEbot1_skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.TitanMEbot1_atk_casted = true
  caster:setDeathWithEffectOrNot(true)
  caster:die()
end

function TitanME.TitanMEbot1_ai_searchTarget(basefunc, ai)
  local TitanMEbot1 = ai.owner
  local target, minDistanSQ = basefunc(ai)
  local distanceSQ = 999
  local maxHp = 0
  for unit in ed.engine:foreachAliveUnit(TitanMEbot1.foecamp) do
    if unit ~= TitanMEbot1 and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.config.is_summoned and unit.position[1] <= ed.engine.stage_rect.maxX and unit.position[1] >= ed.engine.stage_rect.minX then
      local Hp = unit.hp
      if maxHp < Hp then
        maxHp = Hp
        target = unit
        distanceSQ = TitanME.twoPointDistanceSQ(TitanMEbot1.position, unit.position)
      end
    end
  end
  return target, distanceSQ
end

function TitanME.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function TitanME.TitanMEbot1_skillatk_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
end

function TitanME.TitanMEbot1_skillatk_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 4317)
    local bbuff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(bbuff, caster)
  end
  return buff
end

function TitanME.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skilllevel = {
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level
  }
  local proto = {
    _tid = 293,
    _level = skill.level or 1,
    _stars = caster.stars,
    _skill_levels = skilllevel,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local TitanMEbot2 = ed.UnitCreate(proto, caster.camp, config)
  TitanMEbot2.direction = caster.direction
  local bot2_position_x = caster.position[1] + 60 * caster.direction
  if 800 < bot2_position_x then
    bot2_position_x = 799
  elseif bot2_position_x < 0 then
    bot2_position_x = 1
  end
  local locationTitanMEbot2 = {
    bot2_position_x,
    caster.position[2] - 1
  }
  ed.engine:summonUnit(TitanMEbot2, locationTitanMEbot2, caster, "Enter")
  TitanMEbot2.father = caster
  TitanMEbot2.notPopupBattleInfo = true
  TitanMEbot2:setHpVisible(false)
  local TitanMEbot2_skillatk = TitanMEbot2.skills.TitanMEbot2_atk
  TitanMEbot2_skillatk.finish = override(TitanMEbot2_skillatk.finish, TitanME.TitanMEbot2_skillatk_finish)
  TitanMEbot2.update = override(TitanMEbot2.update, TitanME.TitanMEbot2_update)
  local bid = 4306
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot2, caster)
  buff:setAttribute("AP", math.max(1, caster.attribs.AP - TitanMEbot2.attribs.AP))
  buff:setAttribute("MCRIT", math.max(1, caster.attribs.MCRIT - TitanMEbot2.attribs.MCRIT))
  TitanMEbot2:addBuff(buff, caster)
end

function TitanME.TitanMEbot2_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time and hero:isAlive() then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 and not hero.TitanMEbot_time_out then
      hero.TitanMEbot_time_out = true
      hero:die()
    end
  else
    hero.alive_time = 8
  end
end

function TitanME.TitanMEbot2_skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die(caster)
end

function TitanME.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skilllevel = {
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level
  }
  local proto = {
    _tid = 294,
    _level = skill.level or 1,
    _stars = caster.stars,
    _skill_levels = skilllevel,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local TitanMEbot3 = ed.UnitCreate(proto, caster.camp, config)
  TitanMEbot3.direction = caster.direction
  local bot3_position_x = caster.position[1] + 230 * caster.direction
  if 800 < bot3_position_x then
    bot3_position_x = 799
  elseif bot3_position_x < 0 then
    bot3_position_x = 1
  end
  local locationTitanMEbot3 = {
    bot3_position_x,
    caster.position[2] - 1
  }
  ed.engine:summonUnit(TitanMEbot3, locationTitanMEbot3, caster, "Enter")
  local skillultb = caster.skills.TitanME_ultb
  if skillultb and locationTitanMEbot3 then
    skillultb:takeEffectAt(locationTitanMEbot3)
  end
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
  TitanMEbot3.father = caster
  TitanMEbot3.die = override(TitanMEbot3.die, function(basefunc, unit, killer)
    if not ed.engine.running then
      unit:setDeathWithEffectOrNot(true)
    end
    basefunc(unit, killer)
  end)
  TitanMEbot3.alive_time = caster.TitanME_hasArcana and caster.TitanME_hasArcana > 3 and 20 or 15
  TitanMEbot3.update = override(TitanMEbot3.update, TitanME.TitanMEbot3_update)
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 4386)
  TitanME.changeBuffInfo(AttriBinfo, skill.info["Script Arg3"], TitanMEbot3, 1)
  local buff = TitanMEbot3:addBuff(AttriBinfo, skill.caster)
  TitanMEbot3:takeHeal(TitanMEbot3.attribs.HP, "hp", caster)
  local skillatk4 = caster.skills.TitanME_atk4
  local TitanMEbot3_skillatk = TitanMEbot3.skills.TitanMEbot3_atk
  local TitanMEbot3_skillatk3 = TitanMEbot3.skills.TitanMEbot3_atk3
  if skillatk4 and TitanMEbot3_skillatk then
    TitanMEbot3.TitanME_skillatk4_casted = false
    TitanMEbot3_skillatk.start = override(TitanMEbot3_skillatk.start, TitanME.TitanMEbot3_skillatk_start)
  end
  TitanMEbot3_skillatk3.onAttackFrame = override(TitanMEbot3_skillatk3.onAttackFrame, TitanME.TitanMEbot3_skillatk3_onAttackFrame)
  if caster.TitanME_hasArcana and 2 < caster.TitanME_hasArcana then
    local bid = 4305
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, TitanMEbot3, caster)
    TitanMEbot3:addBuff(buff, caster)
  end
end

function TitanME.TitanMEbot3_skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.father.skills.TitanME_atk4
  if skillatk4 and not caster.TitanME_skillatk4_casted then
    skillatk4:takeEffectOn(caster)
    caster.TitanME_skillatk4_casted = true
  end
end

function TitanME.TitanMEbot3_skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
end

function TitanME.changeBuffInfo(buffInfo, enhance, target, mode)
  local attrib_temp = {}
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
    end
  end
  if buffInfo.ID == 4386 then
    buffInfo.TEN = 10
  end
end

function TitanME.TitanMEbot3_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 and not hero.TitanMEbot3_time_out then
      hero.TitanMEbot3_time_out = true
      hero:die()
    end
  end
end

function TitanME.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local result, reason = basefunc(skill, target)
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit:isAlive() and unit.info.Name == "TitanMEbot3" then
      return false
    end
  end
  return result
end

function TitanME.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.position[1] = caster.position[1] + 15 * caster.direction
end

function TitanME.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.shield = buff.shield + skill.info["Script Arg2"] * caster.attribs.AP
  return buff
end

function TitanME.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanMEbot3_alive = false
end

function TitanME.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local caster_position, height = skill:launchPoint()
  local distance = ed.edpSub(target_position, caster_position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function TitanME.init_hero(hero)
  local skillult = hero.skills.TitanME_ult
  local skillatk2 = hero.skills.TitanME_atk2
  local skillatk3 = hero.skills.TitanME_atk3
  local skillatk4 = hero.skills.TitanME_atk4
  hero.reset = override(hero.reset, TitanME.hero_reset)
  hero.TitanME_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanME.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanME.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, TitanME.skillult_finish)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanME.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanME.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, TitanME.skillatk4_createBuff)
  end
  local skillatk = hero.skills.TitanME_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, TitanME.skillatk_createProjectile)
  end
  return hero
end

return TitanME.init_hero
