module("ed.battlehero", package.seeall)
local ed = ed
Timber = {}
Timber.Timber_hookTopSpeed = 550
Timber.Timber_treeBuffID = 11002905
Timber.Timber_diskRadius = 65
Timber.Timber_diskDestRadius = 50
Timber.Timber_diskOutTime = 4
Timber.Timber_diskBackSpeedUpTime = 4
Timber.Timber_diskBackTime = 8
Timber.Timber_diskSpinTime = 5
Timber.Timber_treeDistance = 45
Timber.Timber_ultSelfBuff = 11002907
Timber.Timber_ultUnctlBuff = 11002908
Timber.Timber_atk2TreeRange = 45
Timber.Timber_atk2PeopleRange = 55

function Timber.skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    basefunc(skill)
  elseif skill.attack_counter == 1 then
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Timber.isNearDest(posStart, posDest, range)
  local disX = posStart[1] - posDest[1]
  local disY = posStart[2] - posDest[2]
  if disX * disX + disY * disY <= range * range then
    return true
  else
    return false
  end
end

function Timber.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Timber.Timber_ultSelfBuff)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
  skill.selfInvalueBuff = selfBuff
end

function Timber.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    basefunc(skill)
    skill.caster.knockup_v = {0, 0}
    local skillultb = caster.skills.Timber_ultb
    if skillultb then
      skillultb:takeEffectAt(caster.position, caster)
      if ed.run_with_scene then
        local effect_name = "eff_point_Timber_ult_2"
        ed.scene:playEffectOnScene(effect_name, {
          ed.engine.stage_rect.maxX / 2,
          0
        }, {1, 1}, nil, 1)
      end
    end
  elseif skill.attack_counter == 1 then
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Timber.skillult_startPhase(basefunc, skill, idx)
  basefunc(skill, idx)
  local caster = skill.caster
  if idx == 1 and ed.run_with_scene then
    caster:setAllBuffVisible(false)
    caster:setHpVisible(false)
  end
  if idx == 2 then
    if ed.run_with_scene then
      caster:setAllBuffVisible(true)
      caster:setHpVisible(true)
    end
    if skill.selfInvalueBuff then
      skill.caster:removeBuff(skill.selfInvalueBuff)
      skill.selfInvalueBuff = nil
    end
    local binfo = ed.lookupDataTable("Buff", nil, Timber.Timber_ultUnctlBuff)
    local selfBuff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(selfBuff, caster)
    skill.selfUnctlBuff = selfBuff
    local originDir = caster:getInitDir()
    caster.position = {
      ed.engine.stage_rect.maxX / 2 - originDir * 200,
      caster.position[2]
    }
    caster.direction = originDir
  end
end

function Timber.skillult_finish(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    skill.caster:setAllBuffVisible(true)
    skill.caster:setHpVisible(true)
  end
  if skill.selfInvalueBuff then
    skill.selfInvalueBuff.timer = -1
    skill.selfInvalueBuff = nil
  end
  if skill.selfUnctlBuff then
    skill.selfUnctlBuff.timer = -1
    skill.selfUnctlBuff = nil
  end
end

function Timber.skillultb_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillult = caster.skills.Timber_ult
  if skillult and caster:isAlive() and power then
    local DoublePower_Ratio = skillult.info["Script Arg3"] / 100
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      DoublePower_Ratio = DoublePower_Ratio + skillult.evo_rank3["Script Arg1"] / 100
    end
    local rand = ed.rand()
    if DoublePower_Ratio >= rand then
      local Doublepower = power * 2
      return Doublepower, i
    end
  end
  return power, i
end

function Timber.hero_die(basefunc, hero, killer)
  for _, tree in ipairs(hero.Timber_TreeList) do
    if tree and tree:isAlive() then
      tree:die()
    end
  end
  basefunc(hero, killer)
end

function Timber.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local target = skill.target
  local caster = skill.caster
  if (target.position[1] - caster.position[1]) * caster.direction < 0 then
    caster.direction = -caster.direction
  end
  local proto = {
    _tid = 228,
    _level = skill.level or 1,
    _skill_levels = {
      [1] = skill.level
    },
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local timberTree = ed.UnitCreate(proto, caster.camp, config)
  local location = {0, 0}
  local interval = {0, 0}
  local angle = 0.3 * math.pi * (ed.rand() - 0.5)
  interval[1] = caster.direction * Timber.Timber_treeDistance * math.cos(angle)
  interval[2] = caster.direction * Timber.Timber_treeDistance * math.sin(angle)
  if interval[1] + skill.target.position[1] > ed.engine.stage_rect.maxX or interval[1] + skill.target.position[1] < ed.engine.stage_rect.minX then
    location[1] = skill.target.position[1] - interval[1]
  else
    location[1] = skill.target.position[1] + interval[1]
  end
  if interval[2] + skill.target.position[2] > ed.engine.stage_rect.maxY or interval[2] + skill.target.position[2] < ed.engine.stage_rect.minY then
    location[2] = skill.target.position[2] - interval[2]
  else
    location[2] = skill.target.position[2] + interval[2]
  end
  timberTree.direction = caster.direction
  ed.engine:summonUnit(timberTree, location, caster)
  local treeBuffInfo = ed.lookupDataTable("Buff", nil, Timber.Timber_treeBuffID)
  local treeBuff = ed.BuffCreate(treeBuffInfo, timberTree, timberTree)
  timberTree:addBuff(treeBuff, timberTree)
  table.insert(caster.Timber_TreeList, timberTree)
  skill.theTree = timberTree
  skill.target = timberTree
  skill.affect_times = {}
end

function Timber.skillatk2_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  if skill.attack_counter == 1 then
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  end
  if skill.attack_counter >= 1 then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  end
end

function Timber.skillatk2_update(basefunc, skill, dt_action, dt_cd)
  local caster = skill.caster
  basefunc(skill, dt_action, dt_cd)
  if skill.attack_counter >= 1 and skill.casting then
    local d = ed.edpSub(skill.theTree.position, caster.position)
    caster.knockup_v = ed.edpMult(ed.edpNormalize(d), Timber.Timber_hookTopSpeed)
    local skillatk2b = caster.skills.Timber_atk2b
    for unit in ed.engine:foreachAliveUnit(skillatk2b:targetCamp()) do
      if unit.buff_effects.invulnerable then
      elseif skill.affect_times[unit] then
      elseif Timber.isNearDest(caster.position, unit.position, Timber.Timber_atk2PeopleRange) then
        skillatk2b:takeEffectOn(unit, caster)
        skill.affect_times[unit] = (skill.affect_times[unit] or 0) + 1
      end
    end
    if skill.casting and Timber.isNearDest(caster.position, skill.theTree.position, Timber.Timber_atk2TreeRange) then
      skill:finish()
      caster.direction = -caster.direction
      return
    end
  end
end

function Timber.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.theTree and skill.theTree:isAlive() then
    skill.theTree:die()
  end
  skill.theTree = nil
  if not ed.engine.beingEnd then
    skill.caster.knockup_v = ed.edpMult(skill.caster.knockup_v, 0.2)
    skill.caster.knockup_time = 0.25
  end
end

function Timber.diskProjectile_collideCheck(basefunc, projectile, unit)
  return Timber.isNearDest(projectile.position, unit.position, Timber.Timber_diskRadius)
end

function Timber.diskProjectile_back(projectile)
  projectile.isOut = false
  projectile.isSpin = false
  projectile.isBack = true
  projectile.affect_times = {}
end

function Timber.diskProjectile_update_out(basefunc, projectile, dt)
  if not projectile.outTime then
    projectile.outTime = 0
  end
  projectile.outTime = projectile.outTime + dt
  if projectile.outTime > Timber.Timber_diskOutTime then
    Timber.diskProjectile_back(projectile)
    return
  end
  local pos = projectile.position
  local v = projectile.velocity
  local x = pos[1] + v[1] * 0.125
  local y = pos[2] + v[2] * 0.125
  local rect = ed.engine.stage_rect
  if x < rect.minX or x > rect.maxX or y < rect.minY or y > rect.maxY then
    Timber.diskProjectile_back(projectile)
    return
  end
  local nowPosition = projectile.position
  local destPosition = projectile.theDest
  local skill = projectile.skill
  local havePeople = false
  if Timber.isNearDest(nowPosition, destPosition, Timber.Timber_diskDestRadius) then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if unit.config.is_summoned then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        if Timber.isNearDest(nowPosition, unit.position, Timber.Timber_diskRadius) then
          havePeople = true
        else
        end
      end
      if havePeople then
        break
      end
    end
    if havePeople then
      projectile.isOut = false
      projectile.isSpin = true
      projectile.isBack = false
      return
    else
      Timber.diskProjectile_back(projectile)
      return
    end
  end
  basefunc(projectile, dt)
end

function Timber.diskProjectile_update_spin(basefunc, projectile, dt)
  projectile.velocity = {0, 0}
  local skill = projectile.skill
  local withinRange = false
  if not projectile.spinTime then
    projectile.spinTime = 0
    projectile.lastSpinTime = 0
  end
  projectile.spinTime = projectile.spinTime + dt
  projectile.lastSpinTime = projectile.lastSpinTime + dt
  if projectile.spinTime > Timber.Timber_diskSpinTime then
    Timber.diskProjectile_back(projectile)
    return
  end
  local Timber_diskSpinInterval = 1
  if skill.evo_rank and skill.evo_rank >= 3 then
    Timber_diskSpinInterval = 0.5
  end
  if Timber_diskSpinInterval <= projectile.lastSpinTime then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if not unit.config.is_summoned and Timber.isNearDest(unit.position, projectile.position, Timber.Timber_diskRadius) then
        withinRange = true
        break
      end
    end
    if withinRange then
      local skillatk3b = projectile.skill.caster.skills.Timber_atk3b
      if skillatk3b then
        skillatk3b:takeEffectAt(projectile.position)
      end
    else
      Timber.diskProjectile_back(projectile)
      return
    end
    projectile.lastSpinTime = 0
  end
end

function Timber.diskProjectile_update_back(basefunc, projectile, dt)
  local caster = projectile.caster
  if not projectile.backTime then
    projectile.backTime = 0
  end
  projectile.backTime = projectile.backTime + dt
  if projectile.backTime > Timber.Timber_diskBackTime and not projectile.terminated then
    projectile:terminate()
  end
  local info = projectile.skill.info
  local v = {
    info["Tile XY Speed"],
    info["Tile Z Speed"]
  }
  if projectile.backTime >= Timber.Timber_diskBackSpeedUpTime then
    v[1] = 2 * v[1]
  end
  local d = ed.edpSub(caster.position, projectile.position)
  if d[1] == 0 and d[2] == 0 then
    projectile.velocity = {
      caster.direction,
      0
    }
  else
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
  end
  basefunc(projectile, dt)
  if Timber.isNearDest(projectile.position, caster.position, 2.5 * caster.info["Collide Radius"]) then
    if not projectile.terminated then
      projectile:terminate()
    end
    return
  end
end

function Timber.diskProjectile_update(basefunc, projectile, dt)
  if ed.run_with_scene and projectile.actor then
    projectile.actor.ownRotation = 0
  end
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  if projectile.isOut then
    Timber.diskProjectile_update_out(basefunc, projectile, dt)
  end
  if projectile.isSpin then
    Timber.diskProjectile_update_spin(basefunc, projectile, dt)
  end
  if projectile.isBack then
    Timber.diskProjectile_update_back(basefunc, projectile, dt)
  end
  if not projectile.skill.caster:isAlive() and not projectile.terminated then
    projectile:terminate()
  end
end

function Timber.skillatk3_createProjectile(basefunc, skill)
  local diskProjectile = basefunc(skill)
  diskProjectile.collideCheck = override(diskProjectile.collideCheck, Timber.diskProjectile_collideCheck)
  diskProjectile.update = override(diskProjectile.update, Timber.diskProjectile_update)
  diskProjectile.isOut = true
  diskProjectile.isSpin = false
  diskProjectile.isBack = false
  diskProjectile.theDest = skill.target.position
  return diskProjectile
end

function Timber.skillatk3b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local HAST = buff.info.HAST
  local MSPD = buff.info.MSPD
  return buff
end

function Timber.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local timer = buff.timer
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = timer + 2 * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Timber.hero_reset(basefunc, hero)
  hero.Timber_APDamageSum = nil
  hero.Timber_ADDamageSum = nil
  hero.Timber_TreeList = {}
  hero.knockup_v = {0, 0}
  hero.knockup_time = -1
  basefunc(hero)
  hero.Start_time = 0
end

function Timber.init_hero(hero)
  local skillult = hero.skills.Timber_ult
  local skillultb = hero.skills.Timber_ultb
  local skillatk = hero.skills.Timber_atk
  local skillatk2 = hero.skills.Timber_atk2
  local skillatk3 = hero.skills.Timber_atk3
  local skillatk4 = hero.skills.Timber_atk4
  local skillatk2b = hero.skills.Timber_atk2b
  local skillatk3b = hero.skills.Timber_atk3b
  hero.reset = override(hero.reset, Timber.hero_reset)
  hero.die = override(hero.die, Timber.hero_die)
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Timber.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, Timber.skillult_finish)
    skillult.startPhase = override(skillult.startPhase, Timber.skillult_startPhase)
    skillult.start = override(skillult.start, Timber.skillult_start)
    if skillultb then
      skillultb.power = override(skillultb.power, Timber.skillultb_power)
      if skillult.evo_rank and skillult.evo_rank >= 1 then
        skillultb.info = ed.wraptable(skillultb.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 2 then
        skillultb.info = ed.wraptable(skillultb.info, {
          ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
        })
      end
    end
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Timber.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Timber.skillatk2_onAttackFrame)
    skillatk2.update = override(skillatk2.update, Timber.skillatk2_update)
    skillatk2.finish = override(skillatk2.finish, Timber.skillatk2_finish)
    if skillatk2b then
      if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
        skillatk2b.info = ed.wraptable(skillatk2b.info, {
          ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
        })
      end
    end
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, Timber.skillatk3_createProjectile)
    if skillatk3b then
      skillatk3b.createBuff = override(skillatk3b.createBuff, Timber.skillatk3b_createBuff)
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
      if skillatk3b then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
      if skillatk3b then
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Timber.skillatk4_createBuff)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
  end
  return hero
end

return Timber.init_hero
