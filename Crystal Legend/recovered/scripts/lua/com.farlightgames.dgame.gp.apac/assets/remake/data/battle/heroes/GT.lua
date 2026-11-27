module("ed.battlehero", package.seeall)
local ed = ed
GT = {}
GT.mineInterval = 0.6
GT.mineRange = 80
GT.hookRange = 100
GT.goblinBirthTime = -0.3
GT.mineLastTime = 15
GT.mineStartTime = 0.5
GT.killpercent = 0.15
GT.dyingTimer_GT = 1.3
GT.damageMine = "damageMine"
GT.stunMine = "stunMine"
GT.noDamageBox = "noDamageBox"
GT.interval = {
  {100, 20},
  {100, 5},
  {100, -15},
  {150, 20},
  {150, 5},
  {150, -15}
}
GT.Goblin_Y_Position = {
  25,
  0,
  -25
}
GT.TrapmineLoction = {
  {-100, 15},
  {0, -19},
  {100, 23}
}

function GT.atk2_mine_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local skill = projectile.skill
  local caster = projectile.caster
  local mineRange = caster.father.skillatk2_evo_rank3 and GT.mineRange * 1.2 or GT.mineRange
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.totalTime > GT.mineLastTime then
    skill:takeEffectAt(projectile.position, projectile)
    projectile:terminate()
  elseif projectile.totalTime > GT.mineStartTime then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if not unit.buff_effects.invulnerable then
        local p = ed.edpSub(unit.position, projectile.position)
        if p[1] * p[1] + p[2] * p[2] <= mineRange * mineRange then
          skill:takeEffectAt(projectile.position, projectile)
          projectile:terminate()
          break
        end
      end
    end
  end
end

function GT.atk3_mine_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local skill = projectile.skill
  local mineRange = GT.mineRange
  if projectile.mineType and projectile.mineType ~= GT.noDamageBox then
    mineRange = GT.hookRange
  end
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.totalTime > GT.mineLastTime then
    skill:takeEffectAt(projectile.position, projectile)
    projectile:terminate()
  elseif projectile.totalTime > GT.mineStartTime then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if not unit.buff_effects.invulnerable then
        local p = ed.edpSub(unit.position, projectile.position)
        if p[1] * p[1] + p[2] * p[2] <= mineRange * mineRange then
          skill:takeEffectAt(projectile.position, projectile)
          projectile:terminate()
          break
        end
      end
    end
  end
end

function GT.skillatk5_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = 5
  return buff
end

function GT.skillult_interrupt(basefunc, skill)
  if skill.attack_counter == 1 then
    skill:onAttackFrame()
  end
  basefunc(skill)
end

function GT.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.ultIng_GT then
    return false, "ultIng"
  end
  return true
end

function GT.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.caster.ultIng_GT = true
  local bid = 10006908
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = skill.caster:addBuff(binfo, skill.caster)
end

function GT.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.ultIng_GT = nil
  if skill.flyGoblinAppear and skill.flyGoblinAppear == 2 then
    skill:onAttackFrame()
    skill.flyGoblinAppear = 1
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10006908 then
      tbuff.timer = -1
    end
  end
end

function GT.FlyGoblin_skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local bid = 10006907
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  local target = skill.target
  target = target or skill:selectTarget()
  local v = 700
  local targetpos = target.position
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    targetxyV[1] * u,
    targetxyV[2] * u,
    targetzV * u
  }
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
  projectile.zSpeed = projectile.zSpeed + targetV[3] * v
  return projectile
end

function GT.FlyGoblin_skillatk2_onAttackFrame(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  caster:die()
  caster.config.summoner.GT_ult_Fly_die = true
end

function GT.skillult_onAttackFrame(basefunc, skill, location, source)
  local caster = skill.caster
  if caster.manually_casting then
    ed.engine:unfreeze()
    caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 1 then
    local proto = {
      _tid = 164,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _skill_levels = {
        [2] = skill.level or 1
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local Goblin = ed.UnitCreate(proto, caster.camp, config)
    Goblin.father = caster
    skill.flygoblin = Goblin
    local locationGoblin = {-50, -55}
    Goblin.direction = 1
    ed.engine:summonUnit(Goblin, locationGoblin, caster)
    local bid = 10006904
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = Goblin:addBuff(binfo, caster)
    Goblin.flying = true
    local skillatk = Goblin.skills.FlyGoblin_atk
    skillatk.GTSkill = skill
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, GT.Goblin_skill_takeEffectOn)
    local skillatk2 = Goblin.skills.FlyGoblin_atk2
    skillatk2.GTSkill = skill
    skillatk2.createProjectile = override(skillatk2.createProjectile, GT.FlyGoblin_skillatk2_createProjectile)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, GT.FlyGoblin_skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GT.FlyGoblin_skillatk2_takeEffectOn)
    table.insert(caster.goblinList, Goblin)
    local proto = {
      _tid = 164,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _skill_levels = {
        [2] = skill.level or 1
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local Goblin2 = ed.UnitCreate(proto, caster.camp, config)
    Goblin2.father = caster
    skill.flygoblin2 = Goblin2
    local locationGoblin2 = {850, -55}
    Goblin2.direction = -1
    ed.engine:summonUnit(Goblin2, locationGoblin2, caster)
    local bid = 10006904
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = Goblin2:addBuff(binfo, caster)
    Goblin2.flying = true
    local skillatk = Goblin2.skills.FlyGoblin_atk
    skillatk.GTSkill = skill
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, GT.Goblin_skill_takeEffectOn)
    local skillatk2 = Goblin2.skills.FlyGoblin_atk2
    skillatk2.GTSkill = skill
    skillatk2.createProjectile = override(skillatk2.createProjectile, GT.FlyGoblin_skillatk2_createProjectile)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, GT.FlyGoblin_skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GT.FlyGoblin_skillatk2_takeEffectOn)
    table.insert(caster.goblinList, Goblin2)
    skill.ultbegin = skill.current_phase_elapsed
    skill.flyGoblinAppear = 2
  else
    if skill.attack_counter == 2 then
      skill.flyGoblinAppear = 1
    else
    end
  end
end

function GT.FlyGoblin_skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  if target and skill.GTSkill then
    skill.GTSkill:takeEffectOn(target, source, shift)
  end
  if skill.GTSkill and skill.GTSkill.evo_rank and skill.GTSkill.evo_rank >= 3 and target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 10006906)
    target:addBuff(binfo, skill.caster)
  end
end

function GT.skillatk5_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if not source or source.mineType == GT.noDamageBox then
  elseif source.mineType == GT.damageMine then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0,
      ["Damage Type"] = "AP"
    })
    basefunc(skill, location, source)
    skill.info = originfo
    if ed.run_with_scene then
      local effect_name = "eff_point_burst.cha"
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, location, {
        caster.direction * 0.8,
        0.8
      }, nil, effect_z)
    end
  elseif source.mineType == GT.stunMine then
    basefunc(skill, location, source)
  end
end

function GT.skillatk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 20 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_GT_atk4.cha", {
        projectile.position[1],
        projectile.position[2] - 1
      }, {
        projectile.direction,
        1
      }, nil, 0)
    end
    projectile:terminate()
    local skill = caster.skills.GT_atk5
    if skill then
      local originfo = skill.info
      local pic = "eff_tile_GT_atk4_2.cha"
      local ran = math.floor(ed.rand() * 3)
      if ran == 2 then
        pic = "eff_tile_GT_atk4_3.cha"
      end
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = pic
      })
      skill:selectTarget()
      local projectile2 = ed.ProjectileCreate(skill)
      if ran < 2 then
        projectile2.mineType = GT.stunMine
      else
        projectile2.mineType = GT.damageMine
      end
      projectile2.height = 1
      projectile2.position = {
        projectile.position[1],
        projectile.position[2] - 20
      }
      projectile2.update = override(projectile2.update, GT.atk3_mine_update)
      ed.engine:addProjectile(projectile2)
      skill.info = originfo
    end
  end
end

function GT.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.update = override(projectile.update, GT.skillatk3_projectile_update)
  projectile.mineType = GT.noDamageBox
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local ran = math.floor(ed.rand() * 6) + 1
  local target_position = {
    GT.interval[ran][1] * caster.direction + caster.position[1],
    GT.interval[ran][2]
  }
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function GT.Goblin_skill_takeEffectOn(basefunc, skill, target, source, shift)
  if target and skill.GTSkill then
    skill.GTSkill:takeEffectOn(target, source, shift)
  end
end

function GT.Goblin_skill_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.update = override(projectile.update, GT.atk2_mine_update)
  local interval = 20
  if caster.tempUnit.position[1] < 0 then
    interval = -20
  end
  projectile.position = {
    caster.position[1] + interval,
    caster.position[2]
  }
  projectile.height = 1
  return projectile
end

function GT.Goblin_ai_update(basefunc, ai, dt)
  local owner = ai.owner
  local skill = owner.father.skills.GT_atk2
  owner.totalTime = owner.totalTime + dt
  if owner.totalTime < GT.mineInterval then
    ai:walkTo(owner.tempUnit)
    if owner.lastPosition and owner.lastPosition == owner.position[1] and (owner.position[1] > 700 or owner.position[1] < 100) then
      owner.crossScreen = true
      owner:die()
    end
    owner.lastPosition = owner.position[1]
  else
    owner.totalTime = owner.totalTime - GT.mineInterval
    local skill = owner.skills.Goblin_atk
    owner:castSkill(skill, skill.target)
  end
end

function GT.Goblin_update(basefunc, hero, dt)
  local d = hero.direction
  basefunc(hero, dt)
  hero.direction = d
end

function GT.Goblin_die(basefunc, self, killer)
  if not self:isAlive() then
    return
  end
  if do_battle_log then
    btlog("%s died.", self:display())
  end
  self:removeSignedBuffer()
  if self.manually_casting then
    self.manually_casting = false
    ed.engine:unfreeze()
  end
  if self.current_skill then
    self.current_skill:interrupt()
  end
  self.state = ed.emUnitState_Dying
  self.can_cast_manual = false
  self.walk_v = {0, 0}
  self.hp = 0
  self.mp = 0
  if not self.isDeathWithEffect then
    if self.crossScreen then
      self:setAction("Death2", false, true)
    else
      self:setAction("Death", false, true)
    end
  else
    self.action_name = nil
    self.action_loop = false
    self.action_duration = 0
    self.action_elapsed = 0
    local origin = {
      self.position[1],
      self.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          self.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  end
  ed.engine:onUnitDie(self, killer)
  if 0 < #self.aura_skill_list then
    for unit in ed.engine:foreachAliveUnit(self.camp) do
      unit:rebuild()
    end
  end
  if 0 < #self.effect_enemy_aura_skill_list then
    for unit in ed.engine:foreachAliveUnit(-self.camp) do
      unit:rebuild()
    end
  end
  if self.actor then
    self.actor:onUnitDeath()
  end
end

function GT.Goblin_skill_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local effect_name = "eff_point_Goblin_atk.cha"
  basefunc(skill, location, source)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(effect_name, location, {
      caster.direction * 1,
      1
    }, nil, 1)
  end
end

function GT.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  caster:setMP(caster.mp + 120 * ed.engine.mp_bonus * (1 + (caster.attribs.MPGainRatio or 0) / 100))
  local proto = {
    _tid = 160,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local Goblin = ed.UnitCreate(proto, caster.camp, config)
  Goblin.direction = caster.direction
  local ran = math.floor(ed.rand() * 3) + 1
  local locationGoblin = {
    50,
    GT.Goblin_Y_Position[ran]
  }
  if caster.position[1] > 400 then
    locationGoblin[1] = 750
  end
  ed.engine:summonUnit(Goblin, locationGoblin, caster)
  Goblin.father = caster
  Goblin.ai.update = override(Goblin.ai.update, GT.Goblin_ai_update)
  Goblin.update = override(Goblin.update, GT.Goblin_update)
  Goblin.die = override(Goblin.die, GT.Goblin_die)
  Goblin.totalTime = -GT.goblinBirthTime
  Goblin.tempUnit = {}
  Goblin.flying = true
  local Goblinskill = Goblin.skills.Goblin_atk
  if caster.skillatk2_evo_rank3 then
    Goblinskill.info = ed.wraptable(Goblinskill.info, {
      ["Shape Arg1"] = 96
    })
  end
  Goblinskill.GTSkill = skill
  Goblinskill.createProjectile = override(Goblinskill.createProjectile, GT.Goblin_skill_createProjectile)
  Goblinskill.takeEffectOn = override(Goblinskill.takeEffectOn, GT.Goblin_skill_takeEffectOn)
  Goblinskill.takeEffectAt = override(Goblinskill.takeEffectAt, GT.Goblin_skill_takeEffectAt)
  if Goblin.direction == 1 then
    Goblin.tempUnit.position = {
      1600,
      Goblin.position[2]
    }
  else
    Goblin.tempUnit.position = {
      -800,
      Goblin.position[2]
    }
  end
  local bid = 10006904
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = Goblin:addBuff(binfo, caster)
  table.insert(caster.goblinList, Goblin)
end

function GT.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  caster.Boomed_GT = true
  caster:die(caster)
  skill:takeEffectAt(caster.position, target)
end

function GT.skillatk4_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  if ed.run_with_scene then
    local info = skill.info
    local direction = skill.caster.direction
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local effect_name = "eff_point_GT_bless.cha"
    ed.scene:playEffectOnScene(effect_name, origin, {1, 1}, nil, 1)
  end
end

function GT.skillatk4_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  if isHit and target and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, 10006905)
    target:addBuff(binfo, caster)
  end
  return isHit, dmg
end

function GT.hero_die(basefunc, hero, killer)
  if hero.goblinList then
    for i, tGoblin in ipairs(hero.goblinList) do
      if tGoblin and tGoblin:isAlive() then
        tGoblin:die()
      end
    end
  end
  hero.goblinList = {}
  if not hero.Boomed_GT and (hero.currentActionStage == 2 or hero.currentActionStage == 4) then
    hero:enterActionStageFromOneStage(hero:GTGetNormalPeriod(), 69)
    if hero.skillatk4_evo_rank2 then
      hero.Boomed_GT = true
      local skillatk4 = hero.skills.GT_atk4
      if skillatk4 then
        skillatk4:takeEffectAt(hero.position)
      end
    end
  end
  basefunc(hero, killer)
end

function GT.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.GT_ult_flydiecount then
    hero.GT_ult_flydiecount = 0
  else
    hero.GT_ult_flydiecount = hero.GT_ult_flydiecount - dt
  end
  local skillult = hero.skills.GT_ult
  if skillult and skillult.flyGoblinAppear and skillult.flyGoblinAppear == 1 and hero.GT_ult_flydiecount <= 0 then
    local skillfly1 = skillult.flygoblin.skills.FlyGoblin_atk2
    local skillfly2 = skillult.flygoblin2.skills.FlyGoblin_atk2
    skillult.flygoblin:castSkill(skillfly1, skillfly1.target)
    skillult.flygoblin2:castSkill(skillfly2, skillfly2.target)
    hero.GT_ult_flydiecount = 1.5
  end
  if hero.GT_ult_Fly_die then
    skillult.flyGoblinAppear = nil
  end
  local percent = hero.hp / hero.attribs.HP
  local skill4 = hero.skills.GT_atk4
  if skill4 then
    if percent < GT.killpercent and (hero.currentActionStage == 1 or hero.currentActionStage == 3 or hero.currentActionStage == 5) and hero:isAlive() and hero.current_skill ~= hero.skills.GT_ult then
      hero:enterActionStageFromOneStage(hero:GTGetAtk4Period(), 69)
      local bid = 10006903
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
    end
    if hero.state == ed.emUnitState_Dying and not hero.Boomed_GT then
      if not hero.dyingTimer_GT then
        hero.dyingTimer_GT = GT.dyingTimer_GT
      end
      hero.dyingTimer_GT = hero.dyingTimer_GT - dt
      if 0 >= hero.dyingTimer_GT then
        hero.dyingTimer_GT = 99999
        local skillatk4 = hero.skills.GT_atk4
        if skillatk4 then
          skillatk4:takeEffectAt(hero.position)
        end
      end
    end
  end
end

function GT.skillatk_createProjectile(basefunc, skill)
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

function GT.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Boomed_GT = nil
  hero.dyingTimer_GT = nil
  hero.ultIng_GT = nil
end

function GT.init_hero(hero)
  hero.goblinList = {}
  hero:setActionStageChangeByManual(true)
  hero.die = override(hero.die, GT.hero_die)
  hero.reset = override(hero.reset, GT.hero_reset)
  hero.update = override(hero.update, GT.hero_update)
  local skillult = hero.skills.GT_ult
  if skillult then
    skillult.start = override(skillult.start, GT.skillult_start)
    skillult.finish = override(skillult.finish, GT.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GT.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, GT.skillult_canCastWithTarget)
    skillult.interrupt = override(skillult.interrupt, GT.skillult_interrupt)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  local skillatk = hero.skills.GT_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, GT.skillatk_createProjectile)
  end
  local skillatk2 = hero.skills.GT_atk2
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, GT.skillatk2_onAttackFrame)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      hero.skillatk2_evo_rank3 = true
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Shape Arg1"] = 96
      })
    end
  end
  local skillatk3 = hero.skills.GT_atk3
  local skillatk5 = hero.skills.GT_atk5
  if skillatk3 and skillatk5 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, GT.skillatk3_createProjectile)
    skillatk5.takeEffectAt = override(skillatk5.takeEffectAt, GT.skillatk5_takeEffectAt)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk5.info = ed.wraptable(skillatk5.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk5.info = ed.wraptable(skillatk5.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk5.createBuff = override(skillatk5.createBuff, GT.skillatk5_createBuff)
    end
  end
  local skillatk4 = hero.skills.GT_atk4
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, GT.skillatk4_start)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, GT.skillatk4_takeEffectAt)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      hero.skillatk4_evo_rank2 = true
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, GT.skillatk4_takeEffectOn)
    end
  end
  
  function hero.GTGetNormalPeriod(unit)
    return 1
  end
  
  function hero.GTGetAtk4Period(unit)
    return 2
  end
  
  return hero
end

return GT.init_hero
