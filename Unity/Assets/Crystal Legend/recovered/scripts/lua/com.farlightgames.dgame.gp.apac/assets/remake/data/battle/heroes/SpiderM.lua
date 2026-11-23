module("ed.battlehero", package.seeall)
local ed = ed
local math = ed.math
NekoNinja = {}
NekoNinja.name = "NekoNinja"
NekoNinja.spMove_maxAttackCounter = 7
NekoNinja.cobwebTieTargetId = 228
NekoNinja.cobwebTieTargetBuff = 1480
NekoNinja.atk4_boundBuffId = 1476
NekoNinja.atk3_invisibleBuff = 1477
NekoNinja.atk3_stableBuff = 1478
NekoNinja.atk3_boundedIntervalTicks = 200
NekoNinja.atk3_boundedAoeRange = 90
NekoNinja.atk3_boundBuffId = 1479
NekoNinja.awake_rollingR = 90
NekoNinja.awake_firstPhaseTime = 0.4
NekoNinja.awake_secondPhaseTime = 0.9
NekoNinja.awake_secondPhase_rx = 100
NekoNinja.awake_secondPhase_ry = 25
NekoNinja.atk4_holyratio = 5
NekoNinja.atk3_mp = 150
NekoNinja.atk3_shield_buffid = 1481
NekoNinja.awake_base_ds = 100
NekoNinja.knock_notoutBuffID = 1484

function NekoNinja.support_deleteCobwebTieTarget(unit, target)
  local cobweb = unit.skills[NekoNinja.name .. "_cobweb"]
  if cobweb and type(cobweb.cobwebTargetList) == "table" then
    local chain = cobweb.cobwebTargetList[target]
    if chain and chain.class == ed.Chain and chain.chainEffect then
      local z = 0
      ed.scene:removeEffect(chain.chainEffect, z)
    end
    cobweb.cobwebTargetList[target] = nil
    if target:isAlive() then
      target:die()
    end
  end
end

function NekoNinja.support_addCobwebTieTarget(unit, targetPos)
  local cobweb = unit.skills[NekoNinja.name .. "_cobweb"]
  if cobweb then
    local proto = {
      _tid = NekoNinja.cobwebTieTargetId,
      _level = unit.level or 1,
      _skill_levels = {
        [1] = unit.level
      },
      _stars = unit.stars,
      _rank = unit.rank,
      _fashion = {
        _current_fashion = unit.fashion_id
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = unit.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or unit.config.hp_mod,
      dps_mod = unit.config.dps_mod or 1
    }
    local cobwebTieTarget = ed.UnitCreate(proto, unit.camp, config)
    local binfo = ed.lookupDataTable("Buff", nil, NekoNinja.cobwebTieTargetBuff)
    local buff = cobwebTieTarget:addBuff(binfo, cobwebTieTarget)
    if not targetPos[1] or not targetPos[2] then
      return nil
    end
    local location = {
      targetPos[1],
      targetPos[2]
    }
    ed.engine:summonUnit(cobwebTieTarget, location, unit, "Idle")
    if type(cobweb.cobwebTargetList) == "table" then
      cobweb.cobwebTargetList[cobwebTieTarget] = false
    end
    return cobwebTieTarget
  end
  return nil
end

function NekoNinja.ults_projectile_update(basefunc, projectile, dt)
  projectile.position[1] = projectile.skill.tiletarget.position[1]
  projectile.position[2] = projectile.skill.tiletarget.position[2]
  basefunc(projectile, dt)
  projectile.ults_pre_position[1] = projectile.position[1]
  projectile.ults_pre_position[2] = projectile.position[2]
  if projectile.skill.tiletarget.knockup_time <= 0 or not projectile.skill.tiletarget:isAlive() then
    projectile:terminate()
  end
end

function NekoNinja.ults_projectile_collideCheck(basefunc, self, unit)
  if self.track_target and unit ~= self.track_target then
    return false
  end
  if not self.skill.info["Tile Piercing"] then
    if unit.buff_effects.untargetable then
      return false
    end
    if unit.buffManager.invisible and unit.camp ~= self.camp then
      return false
    end
  end
  local radius = unit.info["Collide Radius"]
  local ux = unit.position[1]
  local ux0 = unit.previous_position[1]
  local d = self.position[1] - ux
  local d0 = self.ults_pre_position[1] - ux0
  if 0 < d and 0 < d0 then
    d = d - radius
    d0 = d0 - radius
  elseif d < 0 and d0 < 0 then
    d = d + radius
    d0 = d0 + radius
  end
  local t = -d0 / (d - d0)
  if t < 0 or 1 < t then
    return false
  end
  return t
end

function NekoNinja.ults_takeEffectOn(basefunc, skill, target, source, shift)
  local maintarget = skill.tiletarget
  if maintarget ~= target then
    local result, dmg = basefunc(skill, target, source, shift)
    local maintarget = skill.tiletarget
    local caster = skill.caster
    if result and maintarget and maintarget:isAlive() then
      maintarget:takeDamage(dmg, "Holy", "hp", caster, 1, 0)
    end
    return result
  else
    return 0
  end
end

function NekoNinja.ults_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.position[1] = projectile.skill.tiletarget.position[1]
  projectile.position[2] = projectile.skill.tiletarget.position[2]
  projectile.ults_pre_position = {}
  projectile.ults_pre_position[1] = projectile.skill.tiletarget.position[1]
  projectile.ults_pre_position[2] = projectile.skill.tiletarget.position[2]
  projectile.update = override(projectile.update, NekoNinja.ults_projectile_update)
  projectile.collideCheck = override(projectile.collideCheck, NekoNinja.ults_projectile_collideCheck)
  return projectile
end

function NekoNinja.konckBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner and caster then
    if owner.position[1] < ed.engine.stage_rect.minX + 200 then
      owner.position[1] = ed.engine.stage_rect.maxX - 100
    elseif owner.position[1] > ed.engine.stage_rect.maxX - 200 then
      owner.position[1] = ed.engine.stage_rect.minX + 100
    end
    owner.knockup_v = {0, 0}
    buff.timer = 0
  end
end

function NekoNinja.ult_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillults = caster.skills.NekoNinja_ults
  if result and skillults and target and target:isAlive() then
    local bid = NekoNinja.knock_notoutBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.update = override(buff.update, NekoNinja.konckBuff_update)
    local buffresult = target:addBuff(buff, caster)
    local skillults = caster.skills.NekoNinja_ults
    skillults.tiletarget = target
    local projectile = skillults:createProjectile()
    ed.engine:addProjectile(projectile)
  end
  return result
end

function NekoNinja.ult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  skill.info["No Dodge"] = true
  if attack_counter == 0 and target then
    local binfo = ed.lookupDataTable("Buff", nil, NekoNinja.atk3_boundBuffId)
    local buff = target:addBuff(binfo, caster)
    skill.NekoNinja_ult_target = target
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 and target and target == skill.NekoNinja_ult_target then
    basefunc(skill)
  end
end

function NekoNinja.cobweb_launchPoint(basefunc, skill)
  if skill.launchPosX and skill.launchPosY and skill.launchHeight then
    return {
      skill.launchPosX,
      skill.launchPosY
    }, skill.launchHeight
  end
  return basefunc(skill)
end

function NekoNinja.spMove_support_calculateMoveTrail(time, startP, startH, endP, endH)
  local speedList = {}
  local posList = {}
  
  local function inverseLerp(list, time1, time2, xCoef, yCoef, hCoef)
    local ret
    if list[time1] and list[time2] then
      ret = {}
      ret[1] = list[time1][1] * xCoef + list[time2][1] * (1 - xCoef)
      ret[2] = list[time1][2] * yCoef + list[time2][2] * (1 - yCoef)
      ret[3] = list[time1][3] * hCoef + list[time2][3] * (1 - hCoef)
      ret[4] = list[time1][4] * 0.5 + list[time2][4] * 0.5
    end
    local newTime = (time1 + time2) / 2
    list[newTime] = ret
    return ret
  end
  
  posList[0] = {
    startP[1],
    startP[2],
    startH,
    0
  }
  posList[16] = {
    endP[1],
    endP[2],
    endH,
    time
  }
  local minHeightCoef = 0.65
  posList[8] = {
    (startP[1] + endP[1]) / 2,
    endP[2],
    endH * minHeightCoef,
    time / 2
  }
  local xCoef = 0.6
  local yCoef = 0.5
  local hCoef = 0.4
  inverseLerp(posList, 0, 8, xCoef, yCoef, hCoef)
  inverseLerp(posList, 0, 4, xCoef, yCoef, hCoef)
  inverseLerp(posList, 4, 8, xCoef, yCoef, hCoef)
  inverseLerp(posList, 0, 2, xCoef, yCoef, hCoef)
  inverseLerp(posList, 2, 4, xCoef, yCoef, hCoef)
  inverseLerp(posList, 4, 6, xCoef, yCoef, hCoef)
  inverseLerp(posList, 6, 8, xCoef, yCoef, hCoef)
  inverseLerp(posList, 16, 8, xCoef, yCoef, hCoef)
  inverseLerp(posList, 12, 8, xCoef, yCoef, hCoef)
  inverseLerp(posList, 16, 12, xCoef, yCoef, hCoef)
  inverseLerp(posList, 16, 14, xCoef, yCoef, hCoef)
  inverseLerp(posList, 14, 12, xCoef, yCoef, hCoef)
  inverseLerp(posList, 12, 10, xCoef, yCoef, hCoef)
  inverseLerp(posList, 10, 8, xCoef, yCoef, hCoef)
  local dt = time / 16
  for index = 0, 16 do
    local posCur = posList[index]
    local posNext = posList[index + 1]
    local c = dt ~= 0 and 1 / dt or 1
    local cTime = posList[index][4]
    if posNext and posCur then
      local speedData = {
        (posNext[1] - posCur[1]) * c,
        (posNext[2] - posCur[2]) * c,
        (posNext[3] - posCur[3]) * c
      }
      table.insert(speedList, {cTime, speedData})
    end
  end
  return speedList
end

function NekoNinja.spMove_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.actor then
    caster.NekoNinja_origin_pos = caster.actor.height
  end
  basefunc(skill, target)
  skill.currentSpeedPhase = 1
  local targetPos = {
    caster.moveTargetPos[1],
    caster.position[2]
  }
  local Y = caster.position[2]
  local dir = caster.position[1] >= targetPos[1] and -1 or 1
  local startX = caster.position[1] + 30 * dir
  local endX = targetPos[1] - 30 * dir
  local zeroPointPos = {400, 140}
  zeroPointPos[1] = (startX + endX) / 2
  skill.spmove_zeroPointPos = zeroPointPos
  local useTime = 0.5 + math.abs(endX - startX) / 600
  skill.willUseTime = useTime
  local v_x_average = (endX - startX) / useTime
  local v_y = 0
  skill.spMove_phase = 1
  local useTime_phase1 = useTime * 0.2
  local useTime_phase2 = useTime * 0.6
  local useTime_phase3 = useTime * 0.2
  skill.speedList = {}
  local speedList = NekoNinja.spMove_support_calculateMoveTrail(skill.willUseTime, {startX, Y}, 100, {endX, Y}, 100)
  skill.speedList = speedList
end

function NekoNinja.spMove_chain_update(basefunc, chain, dt)
  return nil
end

function NekoNinja.spMove_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.casting and skill == skill.caster.current_skill and skill.moveStartTime then
    local time = skill.current_phase_elapsed - skill.moveStartTime
    local currentPhase = skill.currentSpeedPhase
    if type(skill.speedList) == "table" then
      repeat
        if skill.speedList[currentPhase + 1] and time >= skill.speedList[currentPhase + 1][1] then
          currentPhase = currentPhase + 1
        end
      until not skill.speedList[currentPhase + 1] or time < skill.speedList[currentPhase + 1][1]
    end
    if 1 <= skill.attack_counter and skill.attack_counter < NekoNinja.spMove_maxAttackCounter then
      caster.walk_v = {
        skill.speedList[currentPhase][2][1],
        0
      }
      caster.zSpeed = skill.speedList[currentPhase][2][3]
    end
    if time >= skill.willUseTime then
      caster.walk_v = {0, 0}
      caster.zSpeed = 0
      if caster.actor then
        caster.actor.height = caster.height
      end
      caster:knockup(0.4, {0, 0}, false)
      if skill.tieTarget then
        NekoNinja.support_deleteCobwebTieTarget(caster, skill.tieTarget)
        skill.tieTarget = nil
      end
      skill:finish()
    end
  end
end

function NekoNinja.spMove_launchPoint(basefunc, skill)
  if skill.launchPosX and skill.launchPosY and skill.launchHeight then
    return {
      skill.launchPosX,
      skill.launchPosY
    }, skill.launchHeight
  end
  return basefunc(skill)
end

function NekoNinja.spMove_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 1 and skill.current_phase_idx == 1 then
    caster.position[1] = caster.position[1] + 40
    caster.height = 100
    skill.v0_x = 0
    skill.v0_h = 0
    local tieTarget = NekoNinja.support_addCobwebTieTarget(caster, skill.spmove_zeroPointPos)
    skill.tieTarget = tieTarget
    skill.moveStartTime = skill.current_phase_elapsed
  elseif skill.attack_counter < NekoNinja.spMove_maxAttackCounter then
  elseif skill.attack_counter == NekoNinja.spMove_maxAttackCounter then
  end
end

function NekoNinja.spMove_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.tieTarget then
    NekoNinja.support_deleteCobwebTieTarget(caster, skill.tieTarget)
    skill.tieTarget = nil
  end
end

function NekoNinja.atk_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function NekoNinja.atk4_start(basefunc, skill, target)
  skill.NekoNinja_atk4_target = skill:selectTarget(target)
  basefunc(skill, target)
  local caster = skill.caster
  local atk = caster.skills[NekoNinja.name .. "_atk"]
  if atk then
    atk.cd_remaining = 6
  end
end

function NekoNinja.atk4_takeEffectOn(basefunc, skill, target, source, shift)
  local hit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if hit then
    local willRemoveBuff
    for _, buff in ipairs(target.buff_list) do
      if buff.info.ID == skill.info["Buff ID"] and buff.rank >= 6 then
        local newBinfo = ed.lookupDataTable("Buff", nil, NekoNinja.atk4_boundBuffId)
        local newBuff = target:addBuff(newBinfo, skill.caster)
        if newBuff then
          local holyratio = skill.info["Script Arg2"]
          target:takeDamage(dmg * holyratio, "Holy", "hp", skill.caster, 1, 0)
          willRemoveBuff = buff
          local caster = skill.caster
          if target:isAlive() and not target.config.is_summoned then
            caster.awake_willAttackTarget = target
          end
          caster.global_cd = 0
        end
        break
      end
    end
    if willRemoveBuff then
      willRemoveBuff.timer = -1
      willRemoveBuff.owner:removeBuff(willRemoveBuff)
    end
  end
  return hit, dmg, Crit, lfs_amount
end

function NekoNinja.atk4_projectile_hit(basefunc, projectile, target)
  if projectile.skill.NekoNinja_atk4_target == target then
    basefunc(projectile, target)
    projectile:terminate()
  else
  end
end

function NekoNinja.atk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, NekoNinja.atk4_projectile_hit)
  return projectile
end

function NekoNinja.atk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local maxX = ed.engine.stage_rect.maxX
  local minX = ed.engine.stage_rect.minX
  caster.position[1] = (minX + maxX) / 2 - caster:getInitDir() * 200
  caster.direction = caster:getInitDir()
  if caster.SpiderM_enterBuff then
    caster.SpiderM_enterBuff.timer = -1
    caster.SpiderM_enterBuff = nil
  end
  local binfo = ed.lookupDataTable("Buff", nil, NekoNinja.atk3_stableBuff)
  local buff = caster:addBuff(binfo, caster)
  caster.SpiderM_enterBuff = buff
end

function NekoNinja.atk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.atk3_isEffective = true
  if ed.run_with_scene then
    local dir = caster:getInitDir()
    local effect_name = "eff_point_NekoNinjia_atk3.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, dir == 1 and {720, 0} or {80, 0}, {dir, 1}, nil, -1, nil, nil, nil)
    caster.atk3_region_effect = effect
  end
end

function NekoNinja.atk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.SpiderM_enterBuff then
    caster.SpiderM_enterBuff.timer = -1
    caster.SpiderM_enterBuff = nil
  end
end

function NekoNinja.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  local atk3
  if caster and next(caster) ~= nil then
    atk3 = caster.skills[NekoNinja.name .. "_atk3"]
  end
  if atk3 and caster.name == NekoNinja.name and (buff.info.ID == 1479 or buff.info.ID == 1476) and owner:isAlive() and caster.foecamp == owner.camp then
    caster:takeHeal(NekoNinja.atk3_mp, "mp", caster)
    local have_shieldbuff
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == NekoNinja.atk3_shield_buffid then
        have_shieldbuff = tbuff
      end
    end
    if have_shieldbuff and buff.shield then
      buff.shield = buff.shield + atk3.info["Script Arg2"]
    else
      local bid = NekoNinja.atk3_shield_buffid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.shield = atk3.info["Script Arg2"]
      caster:addBuff(buff, caster)
    end
  end
end

function NekoNinja.awake_func_canChangeTarget(caster, specialTarget)
  local changeTarget = false
  if not (specialTarget and caster) or not specialTarget:isAlive() then
  elseif specialTarget.buff_effects.untargetable then
  elseif specialTarget.buffManager.invisible and specialTarget.camp ~= caster.camp then
  elseif specialTarget.camp ~= caster.foecamp then
  elseif caster.buff_effects.enchanted then
  elseif specialTarget.controlledTarget then
  elseif specialTarget.position[1] < ed.engine.stage_rect.minX or specialTarget.position[1] > ed.engine.stage_rect.maxX or specialTarget.position[2] < ed.engine.stage_rect.minY or specialTarget.position[2] > ed.engine.stage_rect.maxY then
  else
    changeTarget = true
  end
  return changeTarget
end

function NekoNinja.awake_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local specialTarget = caster.awake_willAttackTarget
  if specialTarget and specialTarget:isAlive() and not specialTarget.config.is_summoned then
    skill.target = specialTarget
  else
    skill.target = nil
  end
  return skill.target
end

function NekoNinja.awake_canCastWithTarget(basefunc, skill, target)
  if not target:isAlive() or target.config.is_summoned then
    if skill.caster.awake_willAttackTarget then
      skill.caster.awake_willAttackTarget = nil
    end
    return nil
  else
    return basefunc(skill, target)
  end
end

function NekoNinja.awake_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1482
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function NekoNinja.awake_tieTarget_update(basefunc, unit, dt)
  basefunc(unit, dt)
  local followTarget = unit.SpiderM_followTarget
  if followTarget and followTarget.position then
    unit.position = {
      followTarget.position[1],
      followTarget.position[2]
    }
  end
end

function NekoNinja.awake_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if skill.attack_counter == 1 and target then
    local iniPos = {
      target.position[1],
      target.position[2]
    }
    local tieTarget = NekoNinja.support_addCobwebTieTarget(caster, iniPos)
    tieTarget.SpiderM_followTarget = target
    tieTarget.update = override(tieTarget.update, NekoNinja.awake_tieTarget_update)
    skill.tieTarget = tieTarget
    local firstPhaseTargetPos = {
      caster.position[1] + caster.direction * NekoNinja.awake_rollingR,
      caster.position[2]
    }
    skill.firstPhaseTargetPos = firstPhaseTargetPos
    local deltaP = ed.edpSub(skill.firstPhaseTargetPos, target.position)
    skill.firstPhaseSpeed = ed.edpMult(deltaP, 1 / NekoNinja.awake_firstPhaseTime)
    skill.firstPhaseFinishTime = skill.current_phase_elapsed
  elseif skill.attack_counter == 2 and skill.tieTarget then
  elseif skill.attack_counter ~= 3 or skill.tieTarget then
  end
end

function NekoNinja.awake_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.casting and skill == skill.caster.current_skill then
    local target = skill.target
    if skill.attack_counter == 1 and skill.firstPhaseTargetPos and skill.firstPhaseSpeed and target then
      target.knockup_time = 0.25
      target.knockup_v = ed.edpMult(skill.firstPhaseSpeed, 1 / (0.25 * target.speeder))
    elseif skill.attack_counter == 2 and skill.tieTarget and target then
      local nextRad = 0
      nextRad = math.rad(nextRad + 360 * ((skill.current_phase_elapsed - skill.firstPhaseFinishTime) / NekoNinja.awake_secondPhaseTime))
      local deltaPos = {
        math.cos(nextRad) * NekoNinja.awake_secondPhase_rx,
        math.sin(nextRad) * NekoNinja.awake_secondPhase_ry
      }
      local nextPos = ed.edpAdd(caster.position, deltaPos)
      local ds = ed.edpSub(nextPos, target.position)
      target.knockup_time = 0.25
      target.knockup_v = ed.edpMult(ds, 1 / (0.25 * target.speeder))
    elseif skill.attack_counter == 3 and skill.tieTarget and target then
      local ds = ed.edpSub(caster.direction == 1 and {700, 0} or {100, 0}, target.position)
      target.knockup_time = 0.6
      target.knockup_v = ed.edpMult(ds, 1 / (0.6 * target.speeder))
      local ratio = ed.math.max(ed.math.min(4, math.abs(ds[1]) / NekoNinja.awake_base_ds), 1)
      local basedmg = skill.info["Script Arg2"]
      local bid = 1483
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.timer = buff.timer * ratio
      target:addBuff(buff, caster)
      target:takeDamage(basedmg * ratio, "Holy", "hp", caster, 1, 0)
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function NekoNinja.awake_finish(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if target then
    target.knockup_time = -1
    target.knockup_v = {0, 0}
  end
  if skill.tieTarget then
    NekoNinja.support_deleteCobwebTieTarget(caster, skill.tieTarget)
    skill.tieTarget = nil
  end
  if caster.awake_willAttackTarget then
    caster.awake_willAttackTarget = nil
  end
  basefunc(skill)
end

function NekoNinja.awake_interrupt(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  if target then
    target.knockup_time = -1
    target.knockup_v = {0, 0}
    if target.position[1] < ed.engine.stage_rect.minX then
      target.position[1] = ed.engine.stage_rect.minX + 25
    elseif target.position[1] > ed.engine.stage_rect.maxX then
      target.position[1] = ed.engine.stage_rect.maxX - 25
    end
  end
end

function NekoNinja.spMove_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local needUse = false
  caster.moveTargetPos = {
    caster.position
  }
  local atk2 = caster.skills[NekoNinja.name .. "_atk2"]
  local atk2_specialTarget = caster.atk2_willAttackTarget
  if not needUse and atk2_specialTarget and atk2_specialTarget:isAlive() and atk2 and not caster.buff_effects.stable then
    local distanceSQ = ed.edpDistanceSQ(atk2_specialTarget.position, caster.position)
    if distanceSQ > atk2.max_range_sq or distanceSQ < atk2.min_range_sq then
      needUse = true
      caster.moveTargetPos = {
        atk2_specialTarget.position[1],
        atk2_specialTarget.position[2]
      }
      return true
    end
  end
  return nil
end

function NekoNinja.actor_update(basefunc, actor, dt)
  local unit = actor.model
  local spMove = unit.skills[NekoNinja.name .. "_spMove"]
  if spMove and spMove.casting and spMove == spMove.caster.current_skill and spMove.attack_counter >= 1 and spMove.attack_counter < NekoNinja.spMove_maxAttackCounter then
    actor.height = unit.height + unit.zSpeed * unit.sumActorInterval
  end
  unit.sumActorInterval = unit.sumActorInterval + dt
  local cobweb = unit.skills[NekoNinja.name .. "_cobweb"]
  if cobweb and type(cobweb.cobwebTargetList) == "table" then
    local newList = {}
    for tieTarget, chain in pairs(cobweb.cobwebTargetList) do
      if chain and chain.chainEffect then
        local z = 0
        ed.scene:removeEffect(chain.chainEffect, z)
      end
      cobweb.launchPosX = unit.position[1] + unit.walk_v[1] * unit.sumActorInterval
      cobweb.launchPosY = unit.position[2]
      cobweb.launchHeight = unit.height + 50
      cobweb.target = tieTarget
      local chain = cobweb:createChain()
      unit.perviousSpiderChain = chain
      ed.engine:addChain(chain)
      newList[tieTarget] = chain
    end
    cobweb.cobwebTargetList = newList
  end
  basefunc(actor, dt)
end

function NekoNinja.reset(basefunc, unit)
  basefunc(unit)
  unit.originCamp = unit.camp
  unit.originEnemyCamp = -unit.camp
  unit.sumActorInterval = 0
  local spMove = unit.skills[NekoNinja.name .. "_spMove"]
  if spMove then
    spMove.launchPosX = 0
    spMove.launchPosY = 0
    spMove.launchHeight = 0
    spMove.speedList = {}
    spMove.currentSpeedPhase = 1
  end
  local cobweb = unit.skills[NekoNinja.name .. "_cobweb"]
  if cobweb then
    cobweb.cobwebTargetList = {}
  end
  local atk3 = unit.skills[NekoNinja.name .. "_atk3"]
  if atk3 and not unit.config.is_summoned then
    atk3.cd_remaining = 1
    local binfo = ed.lookupDataTable("Buff", nil, NekoNinja.atk3_invisibleBuff)
    local buff = unit:addBuff(binfo, unit)
    unit.SpiderM_enterBuff = buff
  end
  if atk3 then
    unit.atk3_isEffective = false
    unit.atk3_affectedHeroTickList = {}
  end
  local awake = unit.skills[NekoNinja.name .. "_awake"]
  if awake then
    unit.awake_willAttackTarget = nil
  end
end

function NekoNinja.atk3_hero_update(unit, dt)
  local atk3 = unit.skills[NekoNinja.name .. "_atk3"]
  local atk3b = unit.skills[NekoNinja.name .. "_atk3b"]
  if atk3 and atk3b and unit.atk3_isEffective then
    local curTick = ed.engine.ticks
    local maxX = ed.engine.stage_rect.maxX
    local minX = ed.engine.stage_rect.minX
    local xRange = {}
    if unit:getInitDir() > 0 then
      xRange.max = maxX
      xRange.min = maxX - NekoNinja.atk3_boundedAoeRange
    else
      xRange.min = minX
      xRange.max = minX + NekoNinja.atk3_boundedAoeRange
    end
    for enemy in ed.engine:foreachAliveUnit(unit.originEnemyCamp) do
      if unit.atk3_affectedHeroTickList[enemy] and curTick - unit.atk3_affectedHeroTickList[enemy] < NekoNinja.atk3_boundedIntervalTicks then
      elseif not enemy:isAlive() then
      elseif enemy.position[1] < xRange.min then
      elseif enemy.position[1] > xRange.max then
      elseif enemy.buff_effects.invulnerable then
      elseif enemy.buff_effects.uncontrollable then
      else
        local hit, dmg, Crit, lfs_amount, buff_miss = atk3b:takeEffectOn(enemy, unit)
        unit.atk3_affectedHeroTickList[enemy] = curTick
        for i, tbuff in ipairs(enemy.buff_list) do
          if tbuff.info.ID == NekoNinja.atk3_boundBuffId and enemy:isAlive() and not enemy.config.is_summoned then
            unit.awake_willAttackTarget = enemy
            unit.global_cd = 0
            break
          end
        end
      end
    end
  end
end

function NekoNinja.awake_hero_update(unit, dt)
end

function NekoNinja.atk2_finish(basefunc, skill)
  basefunc(skill)
  skill.caster.atk2_willAttackTarget = nil
end

function NekoNinja.atk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 3 then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 50
    })
    basefunc(skill)
    skill.info = originfo
  else
    basefunc(skill)
  end
end

function NekoNinja:atk2_special_selectTarget(default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  local max = -math.huge
  local chosen
  local caster = self.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit:isOutOfStage() then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
    else
      local v = selector(unit)
      local shouldIgnore = Ignore(unit)
      if max < v and not shouldIgnore then
        max = v
        chosen = unit
      end
    end
  end
  self.target = chosen
  return self.target
end

function NekoNinja.ult_func_hideBuffEffect(unit)
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

function NekoNinja.ult_func_resetBuffEffect(unit)
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

function NekoNinja.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local awake = unit.skills[NekoNinja.name .. "_awake"]
  unit.sumActorInterval = 0
  local actor = unit.actor
  if actor and not unit.alreadyOverrideActor then
    unit.alreadyOverrideActor = true
    actor.update = override(actor.update, NekoNinja.actor_update)
  end
  local atk2 = unit.skills[NekoNinja.name .. "_atk2"]
  if atk2 and atk2:target_selector() and 0 >= atk2.cd_remaining and not unit.atk2_willAttackTarget then
    unit.atk2_willAttackTarget = NekoNinja.atk2_special_selectTarget(atk2, nil)
  end
  NekoNinja.atk3_hero_update(unit, dt)
  NekoNinja.awake_hero_update(unit, dt)
  local hero = unit
  local sawake = unit.skills[NekoNinja.name .. "_sawake"]
  local sawakeb = unit.skills[NekoNinja.name .. "_sawakeb"]
  if ed.protoSuperAwake(unit.proto, 10052) and hero.hp / hero.attribs.HP < 0.33 and hero:isAlive() and hero.current_skill ~= hero.manual_skill and not hero.NekoNinja_castsawake then
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    hero:castSkill(sawake, nil)
    hero.NekoNinja_castsawake = true
  end
end

function NekoNinja.sawake_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, NekoNinja.sawake_buff_onRemoved)
  target:setHpVisible(false)
  target:setFuryVisible(false)
  NekoNinja.ult_func_hideBuffEffect(target)
  caster.NekoNinja_sawakebuff = 1
  return buff
end

function NekoNinja.sawake_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local sawakeb = caster.skills[NekoNinja.name .. "_sawakeb"]
  basefunc(buff)
  if caster.NekoNinja_origin_pos and caster.actor then
    caster.actor.height = caster.NekoNinja_origin_pos
  end
  caster:castSkill(sawakeb, nil)
  caster:setHpVisible(true)
  caster:setFuryVisible(true)
  NekoNinja.ult_func_resetBuffEffect(caster)
  caster.NekoNinja_sawakebuff = nil
end

function NekoNinja.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local awake = hero.skills[NekoNinja.name .. "_awake"]
  if awake and hero.current_skill == awake or hero.NekoNinja_sawakebuff then
    return false
  end
  if hero.NekoNinja_origin_pos and hero.actor then
    hero.actor.height = hero.NekoNinja_origin_pos
  end
  return basefunc(skill, target)
end

function NekoNinja.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
end

function NekoNinja.init_hero(hero)
  ed.PreloadPuppetRcs("TimberTree")
  hero.reset = override(hero.reset, NekoNinja.reset)
  hero.update = override(hero.update, NekoNinja.update)
  hero.collectBuff = override(hero.collectBuff, NekoNinja.collectBuff)
  hero.die = override(hero.die, NekoNinja.hero_die)
  local spMove = hero.skills[NekoNinja.name .. "_spMove"]
  if spMove then
    spMove.canCastWithTarget = override(spMove.canCastWithTarget, NekoNinja.spMove_canCastWithTarget)
    spMove.start = override(spMove.start, NekoNinja.spMove_start)
    spMove.update = override(spMove.update, NekoNinja.spMove_update)
    spMove.onAttackFrame = override(spMove.onAttackFrame, NekoNinja.spMove_onAttackFrame)
    spMove.finish = override(spMove.finish, NekoNinja.spMove_finish)
    spMove.launchPoint = override(spMove.launchPoint, NekoNinja.spMove_launchPoint)
  end
  local cobweb = hero.skills[NekoNinja.name .. "_cobweb"]
  if cobweb then
    cobweb.launchPoint = override(cobweb.launchPoint, NekoNinja.cobweb_launchPoint)
  end
  local atk4 = hero.skills[NekoNinja.name .. "_atk4"]
  if atk4 then
    atk4.start = override(atk4.start, NekoNinja.atk4_start)
    atk4.takeEffectOn = override(atk4.takeEffectOn, NekoNinja.atk4_takeEffectOn)
    atk4.createProjectile = override(atk4.createProjectile, NekoNinja.atk4_createProjectile)
  end
  local atk3 = hero.skills[NekoNinja.name .. "_atk3"]
  if atk3 then
    atk3.start = override(atk3.start, NekoNinja.atk3_start)
    atk3.onAttackFrame = override(atk3.onAttackFrame, NekoNinja.atk3_onAttackFrame)
    atk3.finish = override(atk3.finish, NekoNinja.atk3_finish)
  end
  local ult = hero.skills[NekoNinja.name .. "_ult"]
  if ult then
    ult.takeEffectOn = override(ult.takeEffectOn, NekoNinja.ult_takeEffectOn)
    ult.onAttackFrame = override(ult.onAttackFrame, NekoNinja.ult_onAttackFrame)
    ult.canCastWithTarget = override(ult.canCastWithTarget, NekoNinja.skillult_canCastWithTarget)
  end
  local ults = hero.skills[NekoNinja.name .. "_ults"]
  if ults then
    ults.takeEffectOn = override(ults.takeEffectOn, NekoNinja.ults_takeEffectOn)
    ults.createProjectile = override(ults.createProjectile, NekoNinja.ults_createProjectile)
  end
  local atk2 = hero.skills[NekoNinja.name .. "_atk2"]
  if atk2 then
    atk2.finish = override(atk2.finish, NekoNinja.atk2_finish)
    atk2.onAttackFrame = override(atk2.onAttackFrame, NekoNinja.atk2_onAttackFrame)
  end
  local awake = hero.skills[NekoNinja.name .. "_awake"]
  if awake then
    awake.selectTarget = override(awake.selectTarget, NekoNinja.awake_selectTarget)
    awake.canCastWithTarget = override(awake.canCastWithTarget, NekoNinja.awake_canCastWithTarget)
    awake.start = override(awake.start, NekoNinja.awake_start)
    awake.onAttackFrame = override(awake.onAttackFrame, NekoNinja.awake_onAttackFrame)
    awake.update = override(awake.update, NekoNinja.awake_update)
    awake.finish = override(awake.finish, NekoNinja.awake_finish)
    awake.interrupt = override(awake.interrupt, NekoNinja.awake_interrupt)
  end
  local sawake = hero.skills[NekoNinja.name .. "_sawake"]
  if sawake then
    sawake.createBuff = override(sawake.createBuff, NekoNinja.sawake_createBuff)
  end
  return hero
end

return NekoNinja.init_hero
