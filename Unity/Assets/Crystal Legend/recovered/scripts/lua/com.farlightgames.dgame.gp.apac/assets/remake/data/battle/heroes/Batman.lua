module("ed.battlehero", package.seeall)
local ed = ed
Batman = {}
Batman.Batman_atk3_buffID = 1011
Batman.Batman_atk3b_buffID = 1012
Batman.Batman_burn_levelLimit = 5
Batman.Batman_atk4_linex = 250
Batman.Batman_atk4_liney = 200
Batman.Batman_atk4_knockuptime = 0.6
Batman.Batman_atk4_knockupdistance = 25
Batman.Batman_atk4_boomDelay = 1.8
Batman.Batman_awake_oilBabyTimeInit = 5
Batman.Batman_awake_oilBabyTime = 20
Batman.Batman_awake_cataBabyTimeInit = 12
Batman.Batman_awake_cataBabyTime = 15
Batman.Bat_babyUntargetBuffID = 1013
Batman.Batman_awake_cataHast = 4
Batman.Batman_ultBuffIDSelf = 1016
Batman.Batman_ultMoveSpeedX = 250
Batman.Batman_ultMoveChooseSpeedX = 115
Batman.Batman_ultBackSpeedX = 260
Batman.Batman_ultSpeedYLimit = 40
Batman.Batman_ultTrapBuffID = 1018
Batman.Batman_ultLooseDis = 140
Batman.Batman_ultRange = 86
Batman.Batman_poseTimeLimit = 0.7
Batman.Batman_screenSave = 51
Batman.Batman_ultStateSkillStart = 0
Batman.Batman_ultStateStart = 1
Batman.Batman_ultStateOut = 2
Batman.Batman_ultStateGoUp = 3
Batman.Batman_ultStateBack = 4
Batman.Batman_ultStateFinish = 5

function Batman.setPortraitLocal(hero, panel)
  local portrait_res
  if hero.fashion_id and hero.fashion_id ~= 0 then
    portrait_res = ed.lookupDataTable("Fashion", "Portrait Switch", hero.fashion_id)
  elseif ed.protoSuperAwake(hero.proto) then
    portrait_res = ed.getUnitPortraitSwitch2(hero.tid) or ed.getUnitPortraitSwitch(hero.tid) or ed.getUnitPortrait(hero.tid)
  elseif ed.protoAwake(hero.proto) then
    portrait_res = ed.getUnitPortraitSwitch(hero.tid) or ed.getUnitPortrait(hero.tid)
  else
    portrait_res = ed.getUnitPortrait(hero.tid)
  end
  panel:setPortrait(portrait_res)
end

function Batman.testInRange(skill, unit, caster, range)
  local p = ed.edpSub(unit.position, caster.position)
  return skill.testPointInShape(p, "circle", range, 0)
end

function Batman.meetStrongDemand(unit, caster, skill)
  local isOK = false
  if not unit:isAlive() then
  elseif unit.config.is_summoned then
  elseif unit.buff_effects.building then
  elseif unit.buff_effects.stable then
  elseif unit.buff_effects.untargetable then
  elseif unit.buff_effects.uncontrollable then
  elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
  elseif unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
  elseif not Batman.testInRange(skill, unit, caster, Batman.Batman_ultRange) then
  else
    local isOut = false
    for _, outman in pairs(skill.outList) do
      if outman == unit then
        isOut = true
      end
    end
    if isOut then
    else
      isOK = true
    end
  end
  return isOK
end

function Batman.getSpeed(originPos, destPos, xSpeed, caster)
  local finalSpeed = {
    caster.direction,
    0
  }
  local d = ed.edpSub(destPos, originPos)
  if d[1] ~= 0 then
    local v = {
      d[1] / (d[1] * d[1]) ^ 0.5,
      d[2] / (d[1] * d[1]) ^ 0.5
    }
    finalSpeed[1] = v[1] * xSpeed
    finalSpeed[2] = v[2] * xSpeed <= Batman.Batman_ultSpeedYLimit and v[2] * xSpeed or Batman.Batman_ultSpeedYLimit
  end
  return finalSpeed
end

function Batman.oilLevel(target)
  local level = 0
  for _, buff in ipairs(target.buff_list) do
    if buff.info.ID == Batman.Batman_atk3_buffID then
      level = level + 1
    end
  end
  if level == 0 then
    return false
  else
    return level
  end
end

function Batman.extraBurnDamage(skill, target)
  local level = Batman.oilLevel(target)
  if level then
    local skillatk3b = skill.caster.skills.Batman_atk3b
    if skillatk3b then
      if level >= Batman.Batman_burn_levelLimit then
        level = Batman.Batman_burn_levelLimit
      end
      local binfo = skillatk3b.info.buff_info
      local burnBuff = ed.BuffCreate(binfo, target, skill.caster)
      if ed.protoSuperAwake(skill.caster.proto, 10032) then
        local skillsawake = skill.caster.skills.Batman_sawake
        local sawake_multi = skillsawake.info["Script Arg2"] / 100
        burnBuff:setAttribute("HPR", burnBuff.info.HPR * level * sawake_multi)
        burnBuff:setAttribute("HPR.a", burnBuff.info["HPR.a"] * level)
      else
        burnBuff:setAttribute("HPR", burnBuff.info.HPR * level)
        burnBuff:setAttribute("HPR.a", burnBuff.info["HPR.a"] * level)
      end
      target:addBuff(burnBuff, skill.caster)
    end
  end
end

function Batman.hero_canPanelTrigger(basefunc, unit)
  if not unit:isAlive() then
    return false, "dead"
  end
  if unit.buff_effects.stun then
    return false, "stun"
  end
  if unit.buff_effects.silence then
    return false, "silence"
  end
  if unit.buff_effects.doom then
    return false, "doom"
  end
  local skillult = unit.skills.Batman_ult
  local canTrigger = false
  if skillult.doTrigger then
    return false, "already triggered"
  end
  if skillult and skillult.casting and skillult.poseTarget and skillult.state == Batman.Batman_ultStateOut then
    canTrigger = true
  end
  return canTrigger
end

function Batman.hero_shouldTrigger(basefunc, caster)
  local skillult = caster.skills.Batman_ult
  if skillult and skillult.casting and skillult.poseTarget then
    return true
  end
  basefunc(caster)
end

function Batman.skillult_canTrigger(basefunc, skill)
  return Batman.hero_canPanelTrigger(nil, skill.caster)
end

function Batman.skillult_trigger(basefunc, skill)
  skill.dragTarget = skill.poseTarget
  skill:startPhase(3)
  skill.doTrigger = true
end

function Batman.skillult_createProjectile(basefunc, skill)
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
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function Batman.skillult_canCastWithTarget(basefunc, skill, target)
  local ret, why = basefunc(skill, target)
  if ret and skill.casting then
    return false, "ult casting"
  end
  return ret, why
end

function Batman.skillult_startPhase(basefunc, skill, idx)
  basefunc(skill, idx)
  local caster = skill.caster
  if idx == 2 then
    skill.state = Batman.Batman_ultStateOut
    skill.dragTarget = false
  end
  if idx == 3 then
    skill.state = Batman.Batman_ultStateGoUp
    local dragTarget = skill.dragTarget
    local binfo = ed.lookupDataTable("Buff", nil, Batman.Batman_ultTrapBuffID)
    local trapBuff = ed.BuffCreate(binfo, dragTarget, caster)
    dragTarget:addBuff(trapBuff, caster)
    caster.walk_v = {
      caster.direction,
      0
    }
  end
  if idx == 4 then
    skill.state = Batman.Batman_ultStateBack
    local dragTarget = skill.dragTarget
    skill.dragTick = ed.engine.ticks
    caster.walk_v = Batman.getSpeed(caster.position, skill.startPoint, Batman.Batman_ultBackSpeedX, caster)
  end
  if idx == 5 then
    skill.state = Batman.Batman_ultStateFinish
    if ed.run_with_scene then
      local panel = skill.caster.heroPanel
      if panel then
        Batman.setPortraitLocal(skill.caster, panel)
      end
    end
  end
end

function Batman.skillult_onPhaseFinished(basefunc, skill)
  if skill.current_phase_idx == 2 then
    skill:startPhase(5)
  else
    basefunc(skill)
  end
end

function Batman.skillult_ultStateOut(skill, dt_action, dt_cd, caster)
  if (skill.midPoint[1] - caster.position[1]) * skill.startDirection < 0 and not skill.passMid then
    skill.passMid = true
  end
  if skill.passMid then
    local newSpeedX = 0
    local finalSpeedX = -skill.startDirection * Batman.Batman_ultMoveChooseSpeedX
    if skill.startDirection > 0 then
      newSpeedX = math.max(finalSpeedX, caster.walk_v[1] - skill.startDirection * 400 * (dt_action / caster.speeder))
    else
      newSpeedX = math.min(finalSpeedX, caster.walk_v[1] - skill.startDirection * 400 * (dt_action / caster.speeder))
    end
    caster.walk_v = {newSpeedX, 0}
    if caster.direction == -skill.startDirection then
      if skill.poseTarget then
        skill.poseTime = skill.poseTime + dt_action / caster.speeder
        if skill.poseTime >= Batman.Batman_poseTimeLimit then
          table.insert(skill.outList, skill.poseTarget)
          skill.poseTarget = false
        else
          if not Batman.meetStrongDemand(skill.poseTarget, caster, skill) then
            table.insert(skill.outList, skill.poseTarget)
            skill.poseTarget = false
          else
          end
        end
        if ed.run_with_scene then
          local panel = caster.heroPanel
          if panel and not skill.poseTarget then
            Batman.setPortraitLocal(caster, panel)
          end
        end
      end
      if not skill.poseTarget then
        local atLeast = {}
        local count = 0
        for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
          if Batman.meetStrongDemand(unit, caster, skill) then
            table.insert(atLeast, unit)
            count = count + 1
            if 2 <= count then
              break
            end
          end
        end
        if 1 <= count then
          local choose = math.ceil(ed.rand() * count)
          skill.poseTarget = atLeast[choose]
          skill.poseTime = 0
        end
      end
      if caster.ai.will_cast_manual_skill and Batman.skillult_canTrigger(nil, skill) and caster:shouldTrigger() then
        skill:trigger()
      end
      if ed.run_with_scene then
        local panel = caster.heroPanel
        local target = skill.poseTarget
        if panel and target then
          Batman.setPortraitLocal(target, panel)
        end
      end
    end
    if skill.casting and 0 >= (caster.position[1] - (skill.startDirection * skill.looseDis + skill.startPoint[1])) * skill.startDirection then
      skill:startPhase(5)
    end
  end
end

function Batman.skillult_ultStateGoUp(skill, dt_action, dt_cd, caster)
  local dragTarget = skill.dragTarget
  dragTarget.position[1] = 0.8 * dragTarget.position[1] + 0.2 * (caster.position[1] + skill.startDirection)
  dragTarget.position[2] = 0.8 * dragTarget.position[2] + 0.2 * caster.position[2]
end

function Batman.skillult_ultStateBack(skill, dt_action, dt_cd, caster)
  local dragTarget = skill.dragTarget
  if not skill.loose and skill.dragTick ~= ed.engine.ticks then
    dragTarget.knockup_v = {
      0.7 * caster.walk_v[1],
      0.7 * caster.walk_v[2]
    }
    dragTarget.position = {
      caster.position[1] + skill.startDirection,
      caster.position[2]
    }
  end
  if (caster.position[1] - (skill.startDirection * skill.looseDis + skill.startPoint[1])) * skill.startDirection <= 0 and not skill.loose then
    dragTarget.knockup_v = {0, 0}
    skill.loose = true
    for _, buff in ipairs(dragTarget.buff_list) do
      if buff.info.ID == Batman.Batman_ultTrapBuffID then
        dragTarget:removeBuff(buff)
      end
    end
    dragTarget:hurt()
    if ed.protoSuperAwake(caster.proto, 10032) then
      local bid = 4141
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      dragTarget:addBuff(binfo, caster)
    else
      local skillultc = caster.skills.Batman_ultc
      skillultc:takeEffectOn(dragTarget, caster)
    end
    skill:startPhase(5)
  end
end

function Batman.skillult_ultStateFinish(skill, dt_action, dt_cd, caster)
  if skill.startPoint then
    if (caster.position[1] - skill.startPoint[1]) * skill.startDirection <= 0 then
      caster.walk_v = {
        caster.direction,
        0
      }
    end
  else
    caster.walk_v = {
      caster.direction,
      0
    }
  end
end

function Batman.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.state and skill.state == Batman.Batman_ultStateOut and caster:isAlive() then
    Batman.skillult_ultStateOut(skill, dt_action, dt_cd, caster)
  end
  if skill.state and skill.state == Batman.Batman_ultStateGoUp and caster:isAlive() then
    Batman.skillult_ultStateGoUp(skill, dt_action, dt_cd, caster)
  end
  if skill.state and skill.state == Batman.Batman_ultStateBack and caster:isAlive() then
    Batman.skillult_ultStateBack(skill, dt_action, dt_cd, caster)
  end
  if skill.state and skill.state == Batman.Batman_ultStateFinish and caster:isAlive() then
    Batman.skillult_ultStateFinish(skill, dt_action, dt_cd, caster)
  end
end

function Batman.skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  local caster = skill.caster
  if skill.attack_counter == 1 then
    skill.state = Batman.Batman_ultStateStart
    caster.walk_v = Batman.getSpeed(skill.startPoint, skill.midPoint, Batman.Batman_ultMoveSpeedX, caster)
  end
  if skill.state == Batman.Batman_ultStateOut and not skill.passMid then
    local origin_info = skill.info
    skill.info = ed.wraptable(origin_info, {
      ["Target Type"] = "randominscreen"
    })
    skill:selectTarget(nil)
    if skill.target then
      local projectile = skill:createProjectile()
      ed.engine:addProjectile(projectile)
    end
    skill.info = origin_info
  end
end

function Batman.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillultb = caster.skills.Batman_ultb
  local binfo = skillultb.info.buff_info
  local unconBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(unconBuff, caster)
  caster.Batman_isCastingUlt = true
  if ed.protoSuperAwake(caster.proto, 10032) then
    local bid = 4143
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster.sawake_buff = caster:addBuff(binfo, caster)
  end
  skill.outList = {}
  skill.poseTarget = false
  skill.dragTarget = false
  skill.poseTime = 0
  skill.state = Batman.Batman_ultStateSkillStart
  skill.doTrigger = false
  skill.passMid = false
  skill.loose = false
  skill.startPoint = {
    caster.position[1],
    caster.position[2]
  }
  if skill.startPoint[1] > ed.engine.stage_rect.maxX - (Batman.Batman_screenSave + 1) then
    skill.startPoint[1] = ed.engine.stage_rect.maxX - (Batman.Batman_screenSave + 1)
  end
  if skill.startPoint[1] < ed.engine.stage_rect.minX + (Batman.Batman_screenSave + 1) then
    skill.startPoint[1] = ed.engine.stage_rect.minX + (Batman.Batman_screenSave + 1)
  end
  if caster.position[1] ~= skill.target.position[1] then
    skill.midPoint = {
      skill.target.position[1],
      skill.target.position[2]
    }
  else
    skill.midPoint = {
      skill.target.position[1] + caster.direction,
      skill.target.position[2]
    }
  end
  if skill.midPoint[1] > ed.engine.stage_rect.maxX - Batman.Batman_screenSave then
    skill.midPoint[1] = ed.engine.stage_rect.maxX - Batman.Batman_screenSave
  end
  if skill.midPoint[1] < ed.engine.stage_rect.minX + Batman.Batman_screenSave then
    skill.midPoint[1] = ed.engine.stage_rect.minX + Batman.Batman_screenSave
  end
  skill.startDirection = 0 < skill.midPoint[1] - skill.startPoint[1] and 1 or -1
  skill.looseDis = Batman.Batman_ultLooseDis
  if (skill.midPoint[1] - skill.startPoint[1]) * skill.startDirection < Batman.Batman_ultLooseDis then
    skill.looseDis = (skill.midPoint[1] - skill.startPoint[1]) * skill.startDirection
  end
end

function Batman.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.Batman_isCastingUlt = nil
  for _, buff in ipairs(caster.buff_list) do
    if buff.info.ID == Batman.Batman_ultBuffIDSelf then
      caster:removeBuff(buff)
    end
  end
  if ed.protoSuperAwake(caster.proto, 10032) and caster.sawake_buff then
    caster.sawake_buff.timer = 0
  end
  local dragTarget = skill.dragTarget
  if dragTarget and not skill.loose then
    dragTarget.knockup_v = {0, 0}
    for _, buff in ipairs(dragTarget.buff_list) do
      if buff.info.ID == Batman.Batman_ultTrapBuffID then
        dragTarget:removeBuff(buff)
      end
    end
    if ed.protoSuperAwake(caster.proto, 10032) then
      local bid = 4141
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      dragTarget:addBuff(binfo, caster)
    else
      local skillultc = caster.skills.Batman_ultc
      skillultc:takeEffectOn(dragTarget, caster)
    end
  end
  if ed.run_with_scene then
    local panel = skill.caster.heroPanel
    if panel then
      Batman.setPortraitLocal(skill.caster, panel)
    end
  end
  skill.state = nil
  skill.dragTarget = nil
  skill.startDirection = nil
  skill.startPoint = nil
  skill.midPoint = nil
  skill.passMid = nil
  skill.loose = nil
  skill.outList = nil
  skill.poseTarget = nil
  skill.poseTime = nil
  skill.doTrigger = nil
  skill.looseDis = nil
end

function Batman.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local res, dmg = basefunc(skill, target, source, shift)
  if res then
    Batman.extraBurnDamage(skill, target)
    return res, dmg
  else
    return false
  end
end

function Batman.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local res, dmg = basefunc(skill, target, source, shift)
  if res then
    Batman.extraBurnDamage(skill, target)
    return res, dmg
  else
    return false
  end
end

function Batman.skillatk_update(basefunc, skill, dt_action, dt_cd)
  skill.cd_remaining = 9999
  basefunc(skill, dt_action, dt_cd)
end

function Batman.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.target and ed.run_with_scene then
    local gap = 0
    if skill.caster.position[2] < -20 then
      gap = 10
    else
      gap = -10
    end
    local position = {
      skill.caster.position[1] + skill.caster.direction * 240,
      skill.caster.position[2] + gap
    }
    local effect_name = "eff_point_Batman_atk3"
    local effect = ed.scene:playEffectOnScene(effect_name, position, {
      skill.caster.direction,
      1
    }, nil, 0)
    local effect_name2 = "eff_point_Batman_atk3b"
    local effect = ed.scene:playEffectOnScene(effect_name2, position, {
      skill.caster.direction,
      1
    }, nil, -1)
  end
end

function Batman.boomProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  projectile.passTime = projectile.passTime + dt
  if projectile.passTime >= Batman.Batman_atk4_boomDelay and not projectile.terminated then
    projectile.skill:takeEffectAt(projectile.position)
    projectile:terminate()
  end
end

function Batman.skillatk4_createProjectile(basefunc, skill)
  local boomProjectile = basefunc(skill)
  boomProjectile.update = override(boomProjectile.update, Batman.boomProjectile_update)
  boomProjectile.passTime = 0
  local direction = skill.caster.direction
  local target = skill.target
  local origin = target.position
  local centralPos = origin
  local sumX = 0
  local sumY = 0
  local sumUnit = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, origin)
    p2[1] = p2[1] * direction
    if skill.testPointInShape(p2, "rectangle", Batman.Batman_atk4_linex, Batman.Batman_atk4_liney) then
      sumX = sumX + unit.position[1]
      sumY = sumY + unit.position[2]
      sumUnit = sumUnit + 1
    end
  end
  if 0 < sumUnit then
    centralPos = {
      sumX / sumUnit + 5 * (ed.rand() - 0.5),
      sumY / sumUnit - 1
    }
  end
  boomProjectile.position = centralPos
  ed.engine:addProjectile(boomProjectile)
  if ed.run_with_scene and boomProjectile.actor then
    boomProjectile.actor.ownRotation = 0
    boomProjectile.actor.ownScaleX = 1
    boomProjectile.actor.ownScaleY = 1
  end
  return nil
end

function Batman.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local res, dmg = basefunc(skill, target, source, shift)
  if res then
    if skill.Batman_blowPos then
      local direction = {1, 0}
      if target.position[1] == skill.Batman_blowPos[1] and target.position[2] == skill.Batman_blowPos[2] then
        direction = {0, 0}
      else
        direction = ed.edpCompMult({1, 0.1}, ed.edpNormalize(ed.edpSub(target.position, skill.Batman_blowPos)))
      end
      target:knockup(Batman.Batman_atk4_knockuptime, ed.edpMult(direction, Batman.Batman_atk4_knockupdistance), shift)
    end
    Batman.extraBurnDamage(skill, target)
    return res, dmg
  else
    return false
  end
end

function Batman.skillatk4_takeEffectAt(basefunc, skill, location, source)
  local boomLocation = location
  skill.Batman_blowPos = boomLocation
  basefunc(skill, boomLocation, source)
  skill.Batman_blowPos = nil
end

function Batman.babyAtk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local bossSkillAwake2 = skill.boss.skills.Batman_awake2
  if bossSkillAwake2 then
    bossSkillAwake2:takeEffectOn(skill.boss, skill.boss)
  end
end

function Batman.babyAtk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.caster:isAlive() then
    skill.caster:die()
  end
end

function Batman.babyAtk2_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local p = ed.edpSub(skill.caster.position, skill.boss.position)
  if skill.testPointInShape(p, "circle", 70, 0) then
    skill.caster.position = ed.edpAdd(skill.boss.position, skill.gap)
  elseif skill.caster:isAlive() then
    skill.caster:die()
  end
end

function Batman.babyAtk3_finish(basefunc, skill)
  basefunc(skill)
  if skill.caster:isAlive() then
    skill.caster:die()
  end
end

function Batman.unseenTile_terminate(basefunc, tile)
  basefunc(tile)
  if tile.boss:isAlive() then
    tile.boss:die()
  end
end

function Batman.babyAtk3_createProjectile(basefunc, skill)
  local unseenTile = basefunc(skill)
  unseenTile.height = 999
  unseenTile.boss = skill.caster
  unseenTile.terminate = override(unseenTile.terminate, Batman.unseenTile_terminate)
  unseenTile.boss.walk_v = {
    unseenTile.velocity[1],
    unseenTile.velocity[2]
  }
  return unseenTile
end

function Batman.cataBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.timer > 0 then
    local owner = buff.owner
    for _, mybuff in ipairs(owner.buff_list) do
      if mybuff.info.ID == Batman.Batman_atk3b_buffID and not mybuff.isHasted then
        mybuff:setAttribute("HPR", mybuff.info.HPR * Batman.Batman_awake_cataHast)
        mybuff:setAttribute("HPR.a", mybuff.info["HPR.a"] * Batman.Batman_awake_cataHast)
        owner:rebuild()
        mybuff.timer = mybuff.timer / Batman.Batman_awake_cataHast
        mybuff.isHasted = true
      end
    end
  end
end

function Batman.babyAtk3_createBuff(basefunc, skill, target)
  local cataBuff = basefunc(skill, target)
  cataBuff.update = override(cataBuff.update, Batman.cataBuff_update)
  return cataBuff
end

function Batman.skillawake_summon(skill, isOilBaby)
  local caster = skill.caster
  local proto = {
    _tid = 229,
    _level = skill.level or 1,
    _skill_levels = {
      [1] = skill.level,
      [2] = skill.level,
      [3] = skill.level
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
  local batBaby = ed.UnitCreate(proto, caster.camp, config)
  batBaby.direction = caster.direction
  local location = {
    ed.engine.stage_rect.maxX / 2,
    0
  }
  if isOilBaby then
    location = {
      caster.position[1] - caster.direction * 45,
      caster.position[2]
    }
    local babyAtk2 = batBaby.skills.BatBaby_atk2
    if babyAtk2 then
      babyAtk2.boss = caster
      babyAtk2.cd_remaining = 0
      babyAtk2.onAttackFrame = override(babyAtk2.onAttackFrame, Batman.babyAtk2_onAttackFrame)
      babyAtk2.finish = override(babyAtk2.finish, Batman.babyAtk2_finish)
      babyAtk2.gap = ed.edpSub(location, caster.position)
      babyAtk2.update = override(babyAtk2.update, Batman.babyAtk2_update)
    else
      return
    end
  end
  if not isOilBaby then
    location = {
      caster.position[1],
      caster.position[2] + 5 * (ed.rand() - 0.5)
    }
    local babyAtk3 = batBaby.skills.BatBaby_atk3
    if babyAtk3 then
      babyAtk3.cd_remaining = 0
      babyAtk3.finish = override(babyAtk3.finish, Batman.babyAtk3_finish)
      babyAtk3.createProjectile = override(babyAtk3.createProjectile, Batman.babyAtk3_createProjectile)
      babyAtk3.createBuff = override(babyAtk3.createBuff, Batman.babyAtk3_createBuff)
    else
      return
    end
  end
  local untargetBuffInfo = ed.lookupDataTable("Buff", nil, Batman.Bat_babyUntargetBuffID)
  batBaby:addBuff(untargetBuffInfo, caster)
  ed.engine:summonUnit(batBaby, location, caster)
  table.insert(caster.Bat_babyList, batBaby)
  return batBaby
end

function Batman.skillawake_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if not caster.Bat_babyList then
    caster.Bat_babyList = {}
  end
  if not caster.Bat_oilBabyTimer then
    caster.Bat_oilBabyTimer = Batman.Batman_awake_oilBabyTimeInit
  end
  caster.Bat_oilBabyTimer = caster.Bat_oilBabyTimer - dt_cd
  local notUltCasting = true
  local skillult = caster.skills.Batman_ult
  if skillult and skillult.casting then
    notUltCasting = false
  end
  if caster.Bat_oilBabyTimer < 0 and notUltCasting then
    Batman.skillawake_summon(skill, true)
    caster.Bat_oilBabyTimer = Batman.Batman_awake_oilBabyTime
  end
  if not caster.Bat_cataBabyTimer then
    caster.Bat_cataBabyTimer = Batman.Batman_awake_cataBabyTimeInit
  end
  caster.Bat_cataBabyTimer = caster.Bat_cataBabyTimer - dt_cd
  if 0 > caster.Bat_cataBabyTimer then
    Batman.skillawake_summon(skill, false)
    caster.Bat_cataBabyTimer = Batman.Batman_awake_cataBabyTime
  end
end

function Batman.hero_die(basefunc, hero, killer)
  for _, unit in ipairs(hero.Bat_babyList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Batman.hero_reset(basefunc, hero)
  hero.Batman_isCastingUlt = nil
  hero.Bat_babyList = {}
  hero.Bat_oilBabyTimer = nil
  hero.Bat_cataBabyTimer = nil
  basefunc(hero)
end

function Batman.init_hero(hero)
  local skillult = hero.skills.Batman_ult
  if skillult then
    hero.canPanelTrigger = override(hero.canPanelTrigger, Batman.hero_canPanelTrigger)
    hero.shouldTrigger = override(hero.shouldTrigger, Batman.hero_shouldTrigger)
    skillult.canTrigger = override(skillult.canTrigger, Batman.skillult_canTrigger)
    skillult.trigger = override(skillult.trigger, Batman.skillult_trigger)
    skillult.createProjectile = override(skillult.createProjectile, Batman.skillult_createProjectile)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Batman.skillult_canCastWithTarget)
    skillult.startPhase = override(skillult.startPhase, Batman.skillult_startPhase)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, Batman.skillult_onPhaseFinished)
    skillult.update = override(skillult.update, Batman.skillult_update)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Batman.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Batman.skillult_start)
    skillult.finish = override(skillult.finish, Batman.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Batman.skillult_takeEffectOn)
  end
  local skillatk = hero.skills.Batman_atk
  if skillatk and ed.protoSuperAwake(hero.proto, 10032) then
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Gain MP"] = 150
    })
  end
  local skillatk2 = hero.skills.Batman_atk2
  if skillatk2 then
    if ed.protoSuperAwake(hero.proto, 10032) then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Gain MP"] = 150
      })
    end
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Batman.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.Batman_atk3
  if skillatk3 then
    if ed.protoSuperAwake(hero.proto, 10032) then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Gain MP"] = 175
      })
    end
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Batman.skillatk3_onAttackFrame)
  end
  local skillatk4 = hero.skills.Batman_atk4
  if skillatk4 then
    if ed.protoSuperAwake(hero.proto, 10032) then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Gain MP"] = 150
      })
    end
    skillatk4.createProjectile = override(skillatk4.createProjectile, Batman.skillatk4_createProjectile)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Batman.skillatk4_takeEffectOn)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Batman.skillatk4_takeEffectAt)
  end
  local skillawake = hero.skills.Batman_awake
  if skillawake then
    hero.Bat_babyList = {}
    skillawake.update = override(skillawake.update, Batman.skillawake_update)
    hero.die = override(hero.die, Batman.hero_die)
  end
  hero.reset = override(hero.reset, Batman.hero_reset)
  return hero
end

return Batman.init_hero
