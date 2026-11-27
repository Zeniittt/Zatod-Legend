module("ed.battlehero", package.seeall)
local ed = ed
BossTitanME = {}
BossTitanME.bossID = 2
BossTitanME.invulnerableBuffID = 1687

function BossTitanME.skillatk2_onAttackFrame(basefunc, skill)
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
  TitanMEbot1.update = override(TitanMEbot1.update, BossTitanME.TitanMEbot1_update)
  TitanMEbot1_skillatk.finish = override(TitanMEbot1_skillatk.finish, BossTitanME.TitanMEbot1_skillatk_finish)
  TitanMEbot1_skillatk.takeEffectAt = override(TitanMEbot1_skillatk.takeEffectAt, BossTitanME.TitanMEbot1_skillatk_takeEffectAt)
  TitanMEbot1.ai.searchTarget = override(TitanMEbot1.ai.searchTarget, BossTitanME.TitanMEbot1_ai_searchTarget)
  if caster.TitanME_hasArcana and 1 < caster.TitanME_hasArcana then
    TitanMEbot1_skillatk.createBuff = override(TitanMEbot1_skillatk.createBuff, BossTitanME.TitanMEbot1_skillatk_createBuff)
  end
  TitanMEbot1.flying = true
  local bid = 4303
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot1, caster)
  buff:setAttribute("AP", math.max(1, caster.attribs.AP - TitanMEbot1.attribs.AP))
  buff:setAttribute("MCRIT", math.max(1, caster.attribs.MCRIT - TitanMEbot1.attribs.MCRIT))
  TitanMEbot1:addBuff(buff, caster)
  local bid = BossTitanME.invulnerableBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot1, caster)
  TitanMEbot1:addBuff(buff, caster)
end

function BossTitanME.TitanMEbot1_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk = hero.skills.TitanMEbot1_atk
  if skillatk and hero.state == ed.emUnitState_Dying and not hero.TitanMEbot1_atk_casted and skillatk then
    skillatk:takeEffectAt(hero.position)
    hero.TitanMEbot1_atk_casted = true
  end
end

function BossTitanME.TitanMEbot1_skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.TitanMEbot1_atk_casted = true
  caster:setDeathWithEffectOrNot(true)
  caster:die()
end

function BossTitanME.TitanMEbot1_ai_searchTarget(basefunc, ai)
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
        distanceSQ = BossTitanME.twoPointDistanceSQ(TitanMEbot1.position, unit.position)
      end
    end
  end
  return target, distanceSQ
end

function BossTitanME.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function BossTitanME.TitanMEbot1_skillatk_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
end

function BossTitanME.TitanMEbot1_skillatk_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 4317)
    local bbuff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(bbuff, caster)
  end
  return buff
end

function BossTitanME.skillatk3_onAttackFrame(basefunc, skill)
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
  local locationTitanMEbot2 = {
    caster.position[1] + 60 * caster.direction,
    caster.position[2] - 1
  }
  ed.engine:summonUnit(TitanMEbot2, locationTitanMEbot2, caster, "Enter")
  TitanMEbot2.father = caster
  TitanMEbot2.notPopupBattleInfo = true
  TitanMEbot2:setHpVisible(false)
  local TitanMEbot2_skillatk = TitanMEbot2.skills.TitanMEbot2_atk
  TitanMEbot2_skillatk.finish = override(TitanMEbot2_skillatk.finish, BossTitanME.TitanMEbot2_skillatk_finish)
  local bid = 4306
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot2, caster)
  buff:setAttribute("AP", math.max(1, caster.attribs.AP * 0.01 - TitanMEbot2.attribs.AP))
  buff:setAttribute("MCRIT", math.max(1, caster.attribs.MCRIT - TitanMEbot2.attribs.MCRIT))
  TitanMEbot2:addBuff(buff, caster)
  local bid = BossTitanME.invulnerableBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot2, caster)
  TitanMEbot2:addBuff(buff, caster)
end

function BossTitanME.TitanMEbot2_skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die(caster)
end

function BossTitanME.skillult_onAttackFrame(basefunc, skill)
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
  local bot3_position_x = 400
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
  local skillultb = caster.skills.BossTitanME_ultb
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
  TitanMEbot3.alive_time = caster.TitanME_hasArcana and caster.TitanME_hasArcana > 3 and 9999 or 9999
  TitanMEbot3.update = override(TitanMEbot3.update, BossTitanME.TitanMEbot3_update)
  local bid = 4304
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot3, caster)
  buff:setAttribute("AD", math.max(1, caster.attribs.AP * skill.info["Script Arg3"]))
  TitanMEbot3:addBuff(buff, caster)
  local skillatk4 = caster.skills.BossTitanME_atk4
  local TitanMEbot3_skillatk = TitanMEbot3.skills.TitanMEbot3_atk
  local TitanMEbot3_skillatk3 = TitanMEbot3.skills.TitanMEbot3_atk3
  if skillatk4 and TitanMEbot3_skillatk then
    TitanMEbot3.TitanME_skillatk4_casted = false
    TitanMEbot3_skillatk.start = override(TitanMEbot3_skillatk.start, BossTitanME.TitanMEbot3_skillatk_start)
  end
  TitanMEbot3_skillatk3.onAttackFrame = override(TitanMEbot3_skillatk3.onAttackFrame, BossTitanME.TitanMEbot3_skillatk3_onAttackFrame)
  if caster.TitanME_hasArcana and 2 < caster.TitanME_hasArcana then
    local bid = 4305
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, TitanMEbot3, caster)
    TitanMEbot3:addBuff(buff, caster)
  end
  local bid = BossTitanME.invulnerableBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, TitanMEbot3, caster)
  TitanMEbot3:addBuff(buff, caster)
end

function BossTitanME.TitanMEbot3_skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.father.skills.BossTitanME_atk4
  if skillatk4 and not caster.TitanME_skillatk4_casted then
    skillatk4:takeEffectOn(caster)
    caster.TitanME_skillatk4_casted = true
  end
end

function BossTitanME.TitanMEbot3_skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
end

function BossTitanME.TitanMEbot3_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 and not hero.TitanMEbot3_time_out then
      hero.TitanMEbot3_time_out = true
      hero:die()
    end
  end
end

function BossTitanME.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local result, reason = basefunc(skill, target)
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit:isAlive() and unit.info.Name == "TitanMEbot3" then
      return false
    end
  end
  return result
end

function BossTitanME.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.position[1] = caster.position[1] + 15 * caster.direction
end

function BossTitanME.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.shield = buff.shield + skill.info["Script Arg2"] * caster.attribs.AP
  return buff
end

function BossTitanME.hero_reset(basefunc, hero)
  basefunc(hero)
  hero:setPosition({650, 0})
  hero.TitanMEbot3_alive = false
  local info = ed.getDataTable("MythBossReward")
  hero.BossStageList = {}
  hero.BossTotalHp = hero.attribs.HP
  hero.Boss_nstage = 0
  hero.Boss_stageBuff = nil
  hero.mp = 1000
  for _, group in ipairs(info) do
    repeat
      if not group[BossTitanME.bossID] then
      else
        if group[BossTitanME.bossID]["Boss RewardLine ID"] == BossTitanME.bossID then
          table.insert(hero.BossStageList, group)
        else
        end
        break -- pseudo-goto
      end
    until true
  end
end

function BossTitanME.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local lostHp = hero.BossTotalHp - hero.hp
  local stagechange
  for i, Hpstage in ipairs(hero.BossStageList) do
    if lostHp >= Hpstage[BossTitanME.bossID]["Damage Value"] and i > hero.Boss_nstage then
      hero.Boss_nstage = i
      stagechange = true
    end
  end
  if stagechange then
    if hero.Boss_stageBuff then
      hero.Boss_stageBuff.timer = -1
    end
    local binfo = ed.lookupDataTable("Buff", nil, hero.BossStageList[hero.Boss_nstage][BossTitanME.bossID]["Buff ID"])
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero.Boss_stageBuff = hero:addBuff(buff, hero)
  end
end

function BossTitanME.skillatk_createProjectile(basefunc, skill)
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

function BossTitanME.init_hero(hero)
  local skillult = hero.skills.BossTitanME_ult
  local skillatk2 = hero.skills.BossTitanME_atk2
  local skillatk3 = hero.skills.BossTitanME_atk3
  local skillatk4 = hero.skills.BossTitanME_atk4
  hero.reset = override(hero.reset, BossTitanME.hero_reset)
  hero.update = override(hero.update, BossTitanME.hero_update)
  hero.TitanME_hasArcana = 4
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossTitanME.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BossTitanME.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, BossTitanME.skillult_finish)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BossTitanME.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, BossTitanME.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, BossTitanME.skillatk4_createBuff)
  end
  local skillatk = hero.skills.BossTitanME_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, BossTitanME.skillatk_createProjectile)
  end
  return hero
end

return BossTitanME.init_hero
