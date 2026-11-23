module("ed.battlehero", package.seeall)
local ed = ed
NW = {}
NW.NW_skillatk3ReturnTime = 6
NW.NW_skillatk3DeathReturnTime = 3
NW.NW_skillatk2WalkSpeed = 280
NW.NW_skillatk2Distance = 75
NW.NW_atk2PeopleRange = 55
NW.NW_skillultWalkSpeed = 566
NW.NW_skillatk2StealthBuffID = 1105
NW.NW_skillatk4SelfBuffID = 1106
NW.NW_skillultSelfBuffID = 1107
NW.NW_skillatk3SelfBuffID = 1108
NW.NW_skillatk2FastBuffID = 1109
NW.NW_awakeSelfBuffID = 1110
NW.NW_skillultOrbReserveTime = 0.5
NW.NW_speicalBuffID = 400

function NW.NW_skillMoveTo(unit, dest, speed)
  local distanceSQ = ed.edpDistanceSQ(dest, unit.position)
  if distanceSQ <= speed * 0.125 * (speed * 0.125) then
    return true
  end
  local base_speed = speed
  local direction = ed.edpSub(dest, unit.position)
  if direction[1] == 0 and direction[2] == 0 then
    unit.walk_v = {0, 0}
  else
    direction = {
      direction[1] * math.abs(direction[1]),
      direction[2] * math.abs(direction[2])
    }
    unit.walk_v = ed.edpMult(ed.edpNormalize(direction), base_speed)
  end
  return false
end

function NW.isNearDest(posStart, posDest, range)
  local disX = posStart[1] - posDest[1]
  local disY = posStart[2] - posDest[2]
  if disX * disX + disY * disY <= range * range then
    return true
  else
    return false
  end
end

function NW.skill_purify(unit)
  local list = unit.buff_list
  local debuff_list = {}
  local my_camp = unit.camp
  for i = 1, #list do
    local buff = list[i]
    if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    unit:removeBuff(debuff_list[i])
  end
  for i, debuff in ipairs(unit.buff_list) do
    if debuff.info.ID == NW.NW_speicalBuffID then
      unit:removeBuff(debuff)
      return
    end
  end
end

function NW.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, NW.NW_skillatk2StealthBuffID)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
  skill.selfStealthBuff = selfBuff
end

function NW.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.selfStealthBuff then
    skill.caster:removeBuff(skill.selfStealthBuff)
    skill.selfStealthBuff = nil
  end
end

function NW.skillatk2_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.casting then
    local dest = skill.current_dest
    local due = NW.NW_skillMoveTo(caster, dest, NW.NW_skillatk2WalkSpeed)
    if due and caster.action_elapsed >= 0.3 then
      skill:onPhaseFinished()
    end
  end
  if skill.casting and skill.attack_counter == skill.current_phase_idx then
    local skillatk2b = caster.skills.NW_atk2b
    for unit in ed.engine:foreachAliveUnit(skillatk2b:targetCamp()) do
      if unit.buff_effects.invulnerable then
      elseif skill.phase_affect_times[unit] then
      elseif NW.isNearDest(caster.position, unit.position, NW.NW_atk2PeopleRange) then
        skillatk2b:takeEffectOn(unit, caster)
        if caster.NW_double then
          skillatk2b:takeEffectOn(unit, caster)
        end
        if ed.protoSuperAwake(caster.proto, 10041) then
          NW.sawake_Operation(caster)
        end
        skill.phase_affect_times[unit] = (skill.phase_affect_times[unit] or 0) + 1
      end
    end
  end
end

function NW.skillatk2_startPhase(basefunc, skill, idx)
  basefunc(skill, idx)
  local caster = skill.caster
  skill:selectTarget(nil)
  skill.phase_affect_times = {}
  local target = skill.target
  local interval = {0, 0}
  local angle = 0.2 * math.pi * (ed.rand() - 0.5)
  if target then
    angle = 0 >= caster.position[2] - target.position[2] and 0.1 * math.pi or -0.1 * math.pi
    local dir = 0 < target.position[1] - caster.position[1] and 1 or -1
    interval[1] = dir * NW.NW_skillatk2Distance * math.cos(angle)
    interval[2] = NW.NW_skillatk2Distance * math.sin(angle)
    skill.current_dest = {
      target.position[1] + interval[1],
      target.position[2] + interval[2]
    }
  else
    local randDir = caster.position[1] > ed.engine.stage_rect.maxX / 2 and -1 or 1
    interval[1] = 2 * randDir * NW.NW_skillatk2Distance * math.cos(angle)
    interval[2] = randDir * NW.NW_skillatk2Distance * math.sin(angle)
    skill.current_dest = {
      caster.position[1] + interval[1],
      caster.position[2] + interval[2]
    }
  end
  if not caster.NW_ultRecord then
    caster.NW_ultRecord = {}
  end
  table.insert(caster.NW_ultRecord, {
    caster.position[1],
    caster.position[2]
  })
end

function NW.skillatk2_onPhaseFinished(basefunc, skill)
  local current_phase_idx = skill.current_phase_idx
  local caster = skill.caster
  basefunc(skill)
  caster.walk_v = {0, 0}
  if current_phase_idx == #skill.phase_list then
    local binfo = ed.lookupDataTable("Buff", nil, NW.NW_skillatk2FastBuffID)
    local fastBuff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(fastBuff, caster)
  end
end

function NW.specialProjectile_freeze(basefunc, projectile)
  basefunc(projectile)
  projectile.frozen_model = false
end

function NW.specialProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  local caster = projectile.caster
  if not caster.NW_stateRecord then
    caster.NW_stateRecord = {}
  end
  table.insert(caster.NW_stateRecord, {
    ed.engine.ticks,
    {
      caster.position[1],
      caster.position[2]
    },
    caster.direction,
    caster.hp
  })
  if not caster:isAlive() then
    projectile:terminate()
  end
end

function NW.skillatk3_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  local skillatk3b = caster.skills.NW_atk3b
  if skillatk3b and not caster.NW_hasCounter then
    local specialProjectile = skillatk3b:createProjectile()
    specialProjectile.height = 999
    specialProjectile.freeze = override(specialProjectile.freeze, NW.specialProjectile_freeze)
    specialProjectile.update = override(specialProjectile.update, NW.specialProjectile_update)
    ed.engine:addProjectile(specialProjectile)
    caster.NW_hasCounter = true
  end
end

function NW.skillatk3_meetDemond(caster, skill, preState)
  if caster.hp < 0.2 * caster.attribs.HP and caster.hp < preState[4] then
    return true
  end
  if caster.hp + 0.2 * caster.attribs.HP < preState[4] then
    return true
  end
  return false
end

function NW.skillatk3_canCastWithTarget(basefunc, skill, target)
  local ret, reason = basefunc(skill, target)
  local caster = skill.caster
  if ret then
    if caster.NW_skillatk3CastNum and caster.NW_skillatk3CastNum >= 2 then
      return false, "run out"
    elseif caster.NW_stateRecord then
      local timing = 1
      local recordLength = #caster.NW_stateRecord
      if recordLength <= NW.NW_skillatk3ReturnTime * 8 then
        timing = 1
      else
        timing = recordLength - NW.NW_skillatk3ReturnTime * 8
      end
      local preState = caster.NW_stateRecord[timing]
      local meetDemondAtk3 = NW.skillatk3_meetDemond(caster, skill, preState)
      if meetDemondAtk3 then
        skill.NW_timing = timing
        return true
      else
        return false, "bad timing"
      end
    end
  else
    return ret, reason
  end
end

function NW.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, NW.NW_skillatk3SelfBuffID)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
  skill.selfUnBuff = selfBuff
  if not caster.NW_skillatk3CastNum then
    caster.NW_skillatk3CastNum = 0
  end
  caster.NW_skillatk3CastNum = caster.NW_skillatk3CastNum + 1
end

function NW.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  if skill.selfUnBuff then
    skill.caster:removeBuff(skill.selfUnBuff)
    skill.selfUnBuff = nil
  end
end

function NW.skillatk3_onPhaseFinished(basefunc, skill)
  local current_phase_idx = skill.current_phase_idx
  local caster = skill.caster
  basefunc(skill)
  if current_phase_idx == #skill.phase_list then
    local skillatk3b = caster.skills.NW_atk3b
    if skillatk3b then
      local binfo = skillatk3b.info.buff_info
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(buff, caster)
    end
  end
end

function NW.hero_onDying(basefunc, hero, killer)
  if hero.NW_skillatk3CastNum and hero.NW_skillatk3CastNum >= 2 then
    basefunc(hero, killer)
    return
  end
  if not hero.NW_reborn and hero.NW_stateRecord then
    local skillatk3 = hero.skills.NW_atk3
    hero.hp = 1
    local timing = 1
    local recordLength = #hero.NW_stateRecord
    if recordLength <= NW.NW_skillatk3DeathReturnTime * 8 then
      timing = 1
    else
      timing = recordLength - NW.NW_skillatk3DeathReturnTime * 8
    end
    skillatk3.NW_timing = timing
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    hero:castSkill(skillatk3, hero)
    hero.NW_reborn = true
  else
    basefunc(hero, killer)
  end
end

function NW.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.NW_timing then
    local preState = caster.NW_stateRecord[skill.NW_timing]
    caster:setPosition(preState[2])
    caster.direction = preState[3]
    caster:setHP(preState[4])
    skill.NW_timing = nil
    NW.skill_purify(caster)
    if ed.protoSuperAwake(caster.proto, 10041) then
      NW.sawake_Operation(caster)
    end
  end
  if skill.selfUnBuff then
    skill.caster:removeBuff(skill.selfUnBuff)
    skill.selfUnBuff = nil
  end
end

function NW.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, NW.NW_skillatk4SelfBuffID)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
end

function NW.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, reason = basefunc(skill, target)
  if ret then
    if caster.NW_ultRecord and #caster.NW_ultRecord >= 1 then
      return true
    else
      return false, "no record"
    end
  else
    return ret, reason
  end
end

function NW.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  table.insert(caster.NW_ultRecord, {
    caster.position[1],
    caster.position[2]
  })
  caster.NW_orbList = {}
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, NW.NW_skillultSelfBuffID)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
  skill.selfUnBuff = selfBuff
  NW.skill_purify(caster)
end

function NW.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.casting and skill.current_phase_idx > 1 then
    if skill.current_phase_idx < #skill.phase_list then
      local caster = skill.caster
      local recordCount = #caster.NW_ultRecord
      local recordPos = recordCount - (skill.current_phase_idx - 1) % recordCount
      local dest = caster.NW_ultRecord[recordPos]
      local ultSpeed = NW.NW_skillultWalkSpeed
      local due = NW.NW_skillMoveTo(caster, dest, ultSpeed)
      if due and caster.action_elapsed >= 0.3 then
        skill:onPhaseFinished()
      end
      local skillultb = caster.skills.NW_ultb
      for unit in ed.engine:foreachAliveUnit(skillultb:targetCamp()) do
        if unit.buff_effects.invulnerable then
        elseif skill.phase_affect_times[unit] then
        elseif NW.isNearDest(caster.position, unit.position, NW.NW_atk2PeopleRange) then
          skillultb:takeEffectOn(unit, caster)
          if ed.protoSuperAwake(caster.proto, 10041) then
            NW.sawake_Operation(caster)
          end
          skill.phase_affect_times[unit] = (skill.phase_affect_times[unit] or 0) + 1
        end
      end
      if not skill.deltaTime then
        skill.deltaTime = 0
      end
      if not skill.shadow then
        skill.shadow = false
      end
      skill.deltaTime = skill.deltaTime + dt_action / caster.speeder
      if skill.deltaTime >= 0.125 then
        skill.shadow = true
      end
      if ed.run_with_scene and skill.shadow then
        local effect_name = "eff_point_NW_ult3.cha"
        if ed.protoAwake(caster.proto, 10041) then
          effect_name = "eff_point_NW_ult5.cha"
        end
        local scene_effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
          caster.direction,
          1
        }, nil, 0)
      end
      if skill.shadow then
        skill.deltaTime = 0
        skill.shadow = false
      end
    else
      caster.walk_v = {0, 0}
    end
  end
end

function NW.skyOrb_update(basefunc, projectile, dt)
  local caster = projectile.caster
  if projectile.isStill then
    if not projectile.stillTime then
      projectile.stillTime = 0
    end
    projectile.stillTime = projectile.stillTime + dt
    projectile.height = projectile.height + projectile.zSpeed * dt
    if projectile.stillTime >= 0.25 then
      projectile.zSpeed = 0.1
    end
    if projectile.actor and projectile.stillTime >= 0.25 then
      projectile.actor.puppet:setLoopAction("Stop")
    end
    return
  else
    projectile.reserveTime = projectile.reserveTime - dt
    if 0 >= projectile.reserveTime then
      if projectile.actor then
        projectile.actor.puppet:setLoopAction("Loop")
      end
      local skillultc = caster.skills.NW_ultc
      local info = skillultc.info
      local v = {800, -500}
      local weakTarget = skillultc.NW_currentTarget
      if skillultc.NW_currentTarget == nil or not skillultc.NW_currentTarget:isAlive() then
        weakTarget = skillultc:selectTarget(nil)
        skillultc.NW_currentTarget = weakTarget
      end
      if not projectile.dest then
        if weakTarget then
          projectile.track_target = weakTarget
          projectile.track = true
          local d = ed.edpSub(weakTarget.position, projectile.position)
          if d[1] == 0 and d[2] == 0 then
            projectile.velocity = {
              caster.direction,
              0
            }
          else
            projectile.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
          end
          local deltaTime = d[1] / projectile.velocity[1]
          local newZSpeed = v[2]
          if 0 < deltaTime then
            newZSpeed = -(projectile.height - 30) / deltaTime
          end
          projectile.zSpeed = math.max(v[2], newZSpeed)
          projectile.dest = true
        else
          local randPos = {
            caster.position[1] + 20 * (0.5 - ed.rand()),
            caster.position[2] + 10 * (0.5 - ed.rand())
          }
          local d = ed.edpSub(randPos, projectile.position)
          if d[1] == 0 and d[2] == 0 then
            projectile.velocity = {
              caster.direction,
              0
            }
          else
            projectile.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
          end
          projectile.zSpeed = v[2]
          projectile.dest = true
        end
        if ed.run_with_scene then
          local effect_name = "eff_point_NW_ult4.cha"
          local scene_effect = ed.scene:playEffectOnScene(effect_name, projectile.position, nil, projectile.height, 0)
        end
      else
        basefunc(projectile, dt)
      end
    else
      return
    end
  end
end

function NW.skillult_startPhase(basefunc, skill, idx)
  basefunc(skill, idx)
  local caster = skill.caster
  skill.phase_affect_times = {}
  if skill.current_phase_idx >= 2 and skill.current_phase_idx < #skill.phase_list then
    local skillultc = caster.skills.NW_ultc
    skillultc.NW_currentTarget = nil
    local skyOrb = skillultc:createProjectile()
    skyOrb.isStill = true
    skyOrb.velocity = {0, 0}
    skyOrb.zSpeed = 250
    skyOrb.height = 80 + 30 * ed.rand()
    skyOrb.reserveTime = skill.current_phase_idx * 0.125
    skyOrb.position = {
      caster.position[1] + 10 * (0.5 - ed.rand()),
      caster.position[2] + 10 * (0.5 - ed.rand())
    }
    skyOrb.update = override(skyOrb.update, NW.skyOrb_update)
    ed.engine:addProjectile(skyOrb)
    table.insert(caster.NW_orbList, skyOrb)
  end
  if skill.current_phase_idx == #skill.phase_list and skill.selfUnBuff then
    skill.caster:removeBuff(skill.selfUnBuff)
    skill.selfUnBuff = nil
  end
end

function NW.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.NW_orbList and #caster.NW_orbList >= 1 then
    for _, orb in ipairs(caster.NW_orbList) do
      orb.isStill = false
    end
  end
  if skill.selfUnBuff then
    skill.caster:removeBuff(skill.selfUnBuff)
    skill.selfUnBuff = nil
  end
  if ed.run_with_scene then
    if skill.scene_effect then
      ed.scene:removeEffect(skill.scene_effect, -1)
    end
    if skill.scene_effect2 then
      ed.scene:removeEffect(skill.scene_effect2, 1)
    end
  end
end

function NW.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 1 and ed.run_with_scene then
    local effect_name = "eff_point_Luna_night.cha"
    local scene_effect = ed.scene:playEffectOnScene(effect_name, {
      ed.engine.stage_rect.maxX / 2,
      0
    }, nil, nil, -1)
    skill.scene_effect = scene_effect
    local effect_name2 = "eff_point_NW_ult.cha"
    local scene_effect2 = ed.scene:playEffectOnScene(effect_name2, {
      ed.engine.stage_rect.maxX / 2,
      0
    }, {1, 1}, nil, 1)
    skill.scene_effect2 = scene_effect2
  end
end

function NW.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.current_skill == nil and hero.NW_readyBack and hero:isAlive() then
    local skillult = hero.skills.NW_ult
    local skillatk = hero.skills.NW_atk
    local skillatk2 = hero.skills.NW_atk2
    local skillatk3 = hero.skills.NW_atk3
    local skillatk4 = hero.skills.NW_atk4
    if skillult then
      skillult.temp_cd = skillult.cd_remaining
    end
    if skillatk then
      skillatk.temp_cd = skillatk.cd_remaining
    end
    if skillatk2 then
      skillatk2.temp_cd = skillatk2.cd_remaining
    end
    if skillatk3 then
      skillatk3.temp_cd = skillatk3.cd_remaining
    end
    if skillatk4 then
      skillatk4.temp_cd = skillatk4.cd_remaining
    end
    if ed.protoSuperAwake(hero.proto, 10041) then
      hero:enterActionStageFromOneStage(4, 10041)
    else
      hero:enterActionStageFromOneStage(2, 10041)
    end
    hero.NW_readyBack = nil
    hero.NW_double = false
    if skillult then
      skillult.cd_remaining = skillult.temp_cd
    end
    if skillatk then
      skillatk.cd_remaining = skillatk.temp_cd
    end
    if skillatk2 then
      skillatk2.cd_remaining = skillatk2.temp_cd
    end
    if skillatk3 then
      skillatk3.cd_remaining = skillatk3.temp_cd
    end
    if skillatk4 then
      skillatk4.cd_remaining = skillatk4.temp_cd
    end
  end
end

function NW.skillawakebbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  caster.NW_readyBack = true
  basefunc(buff)
end

function NW.skillawakeb_createBuff(basefunc, skill, target)
  local tbuff = basefunc(skill, target)
  tbuff.onRemoved = override(tbuff.onRemoved, NW.skillawakebbuff_onRemoved)
  return tbuff
end

function NW.skillawake_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = NW.NW_awakeSelfBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  local skillawakeb = caster.skills.NW_awakeb
  caster:addBuff(skillawakeb:createBuff(caster))
  basefunc(skill, target)
end

function NW.skillawake_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.NW_ult
  local skillatk = caster.skills.NW_atk
  local skillatk2 = caster.skills.NW_atk2
  local skillatk3 = caster.skills.NW_atk3
  local skillatk4 = caster.skills.NW_atk4
  if skillult then
    skillult.temp_cd = skillult.cd_remaining
  end
  if skillatk then
    skillatk.temp_cd = skillatk.cd_remaining
  end
  if skillatk2 then
    skillatk2.temp_cd = skillatk2.cd_remaining
  end
  if skillatk3 then
    skillatk3.temp_cd = skillatk3.cd_remaining
  end
  if skillatk4 then
    skillatk4.temp_cd = skillatk4.cd_remaining
  end
  if ed.protoSuperAwake(caster.proto, 10041) then
    caster:enterActionStageFromOneStage(5, 10041)
  else
    caster:enterActionStageFromOneStage(3, 10041)
  end
  caster.NW_readyBack = false
  caster.NW_double = true
  if skillult then
    skillult.cd_remaining = skillult.temp_cd
  end
  if skillatk then
    skillatk.cd_remaining = skillatk.temp_cd
  end
  if skillatk2 then
    skillatk2.cd_remaining = skillatk2.temp_cd
  end
  if skillatk3 then
    skillatk3.cd_remaining = skillatk3.temp_cd
  end
  if skillatk4 then
    skillatk4.cd_remaining = skillatk4.temp_cd
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == NW.NW_awakeSelfBuffID then
      caster:removeBuff(tbuff)
      return
    end
  end
end

function NW.skillatk_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 1 and not skill.caster.NW_double then
    return
  end
  if skill.attack_counter == 1 and skill.caster.NW_double then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = 30
    })
    basefunc(skill)
    skill.info = originInfo
    return
  end
  if skill.attack_counter == 0 then
    basefunc(skill)
  end
end

function NW.hero_reset(basefunc, hero)
  hero.NW_orbList = nil
  hero.NW_ultRecord = nil
  hero.NW_hasCounter = nil
  hero.NW_stateRecord = nil
  hero.NW_reborn = nil
  hero.NW_readyBack = nil
  hero.NW_double = nil
  hero.NW_skillatk3CastNum = nil
  basefunc(hero)
  if hero.currentActionStage == 3 then
    hero:enterActionStageFromOneStage(2, 10041)
  elseif hero.currentActionStage == 5 then
    hero:enterActionStageFromOneStage(4, 10041)
  end
end

function NW.sawake_Operation(hero)
  local skillsawake = hero.skills.NW_sawake
  hero:takeHeal(skillsawake.info["Script Arg2"], "hp", hero)
  hero:takeHeal(35, "mp", hero)
  local bid = 4156
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function NW.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillatk2 = hero.skills.NW_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, NW.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, NW.skillatk2_finish)
    skillatk2.update = override(skillatk2.update, NW.skillatk2_update)
    skillatk2.startPhase = override(skillatk2.startPhase, NW.skillatk2_startPhase)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, NW.skillatk2_onPhaseFinished)
  end
  local skillatk3 = hero.skills.NW_atk3
  if skillatk3 then
    skillatk3.update = override(skillatk3.update, NW.skillatk3_update)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, NW.skillatk3_canCastWithTarget)
    hero.onDying = override(hero.onDying, NW.hero_onDying)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, NW.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, NW.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, NW.skillatk3_finish)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, NW.skillatk3_onPhaseFinished)
  end
  local skillatk4 = hero.skills.NW_atk4
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, NW.skillatk4_onAttackFrame)
  end
  local skillult = hero.skills.NW_ult
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, NW.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, NW.skillult_start)
    skillult.update = override(skillult.update, NW.skillult_update)
    skillult.startPhase = override(skillult.startPhase, NW.skillult_startPhase)
    skillult.finish = override(skillult.finish, NW.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, NW.skillult_onAttackFrame)
  end
  local skillawake = hero.skills.NW_awake
  local skillawakeb = hero.skills.NW_awakeb
  local skillatk = hero.skills.NW_atk
  if skillawake then
    skillawake.start = override(skillawake.start, NW.skillawake_start)
    skillawake.finish = override(skillawake.finish, NW.skillawake_finish)
    skillawakeb.createBuff = override(skillawakeb.createBuff, NW.skillawakeb_createBuff)
    hero.update = override(hero.update, NW.hero_update)
  end
  local skillatk = hero.skills.NW_atk
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, NW.skillatk_onAttackFrame)
  end
  hero.reset = override(hero.reset, NW.hero_reset)
  if ed.protoSuperAwake(hero.proto, 10041) then
    hero:enterActionStageFromOneStage(4, 10041)
  elseif ed.protoAwake(hero.proto, 10041) then
    hero:enterActionStageFromOneStage(2, 10041)
  end
  return hero
end

return NW.init_hero
