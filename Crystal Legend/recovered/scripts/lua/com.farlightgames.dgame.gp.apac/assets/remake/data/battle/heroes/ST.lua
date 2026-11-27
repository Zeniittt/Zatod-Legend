module("ed.battlehero", package.seeall)
local ed = ed
ST = {}
ST.distancegap_ult = 100
ST.distancegap_atk2 = 75
ST.ult2time = 0.375
ST.ultFlyingTime = 1
ST.minFlyingTime = 0.63
ST.maxTime = 1
ST.ratio = 0.6
ST.offsets = 55
ST.stormVelocity = 603.1999999999999

function ST.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  local skillatk3 = caster.skills.ST_atk3
  local skillatk4 = caster.skills.ST_atk4
  local skillatk2_cd = 0
  skillatk2_cd = caster.skills.ST_atk2.cd_remaining
  local skillatk4_cd = 0
  if skillatk4 then
    skillatk4_cd = caster.skills.ST_atk4.cd_remaining
  end
  if skillatk3 then
    caster:enterActionStageFromOneStage(2, 59)
    caster.skills.ST_ult.cd_remaining = 0
    caster.stormEnergy_ST = true
    if skillatk4 then
      caster.skills.ST_atk4.cd_remaining = skillatk4_cd
    end
    caster.skills.ST_atk2.cd_remaining = skillatk2_cd
  end
end

function ST.skillatk4_finish(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  local skillatk3 = caster.skills.ST_atk3
  local skillatk2 = caster.skills.ST_atk2
  local skillatk2_cd = 0
  local skillatk4_cd = 0
  skillatk4_cd = caster.skills.ST_atk4.cd_remaining
  if skillatk2 then
    skillatk2_cd = caster.skills.ST_atk2.cd_remaining
  end
  if skillatk3 then
    caster:enterActionStageFromOneStage(2, 59)
    caster.skills.ST_ult.cd_remaining = 0
    caster.stormEnergy_ST = true
    if skillatk2 then
      caster.skills.ST_atk2.cd_remaining = skillatk2_cd
    end
    caster.skills.ST_atk4.cd_remaining = skillatk4_cd
  end
end

function ST.atk2_p_update(basefunc, projectile, dt)
  projectile.totalTime = projectile.totalTime + dt
  if projectile.totalTime > ST.maxTime then
    projectile:hit(projectile.skill.target)
    projectile:terminate()
  end
  basefunc(projectile, dt)
end

function ST.atk2_hit(basefunc, projectile, target)
  local caster = projectile.skill.caster
  caster.skills.ST_atk2:takeEffectAt(projectile.position, projectile)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_ST_atk4.cha", {
      projectile.position[1],
      projectile.position[2] + 1
    }, {
      projectile.direction,
      1
    }, nil, 0)
  end
end

function ST.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = skill.target
  local caster = skill.caster
  if projectile.skill.info["Skill Name"] == "ST_atk2" then
    if caster.ultIng_ST and skill.origintarget and skill.origintarget:isAlive() then
      target = skill.origintarget
    end
    local direction = target.position[1] - caster.position[1] > 0 and 1 or -1
    local targetx = target.position[1] + ST.distancegap_atk2 * direction
    if 799 < targetx or targetx < 1 then
      targetx = targetx - 2 * ST.distancegap_atk2 * direction
    end
    projectile.position = {
      targetx,
      target.position[2]
    }
    projectile.totalTime = 0
    projectile.hit = override(projectile.hit, ST.atk2_hit)
    projectile.update = override(projectile.update, ST.atk2_p_update)
  end
  return projectile
end

function ST.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  basefunc(skill, location, source)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_ST_atk4.cha", {
      location[1],
      location[2] + 1
    }, {1, 1}, nil, 0)
  end
end

function ST.skillatk3_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.stormEnergy_ST then
    return basefunc(skill, target)
  end
  return false, "storm"
end

function ST.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.ST_atk2
  local skillatk4 = caster.skills.ST_atk4
  local skillatk2_cd = 0
  local skillatk4_cd = 0
  if skillatk2 then
    skillatk2_cd = caster.skills.ST_atk2.cd_remaining
  end
  if skillatk4 then
    skillatk4_cd = caster.skills.ST_atk4.cd_remaining
  end
  basefunc(skill)
  if caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
    if caster.currentActionStage == 2 then
      caster:enterActionStageFromOneStage(1, 59)
    elseif caster.currentActionStage == 4 then
      caster:enterActionStageFromOneStage(3, 59)
    else
      caster:enterActionStageFromOneStage(5, 59)
    end
    caster.skills.ST_ult.cd_remaining = 0
    if skillatk2 then
      caster.skills.ST_atk2.cd_remaining = skillatk2_cd
    end
    if skillatk4 then
      caster.skills.ST_atk4.cd_remaining = skillatk4_cd
    end
    caster.stormEnergy_ST = nil
  end
end

function ST.skillult_power(basefunc, skill, source, target, damage_type)
  if skill.attack_counter == 1 or skill.attack_counter == 9 then
    return 0, 1
  else
    return basefunc(skill, source, target, damage_type)
  end
end

function ST.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local target2 = skill:selectTarget(nil)
  if not target2 then
    skill:finish()
    return
  end
  local bid = 10005901
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("PIMU", skill.evo_rank3["Script Arg1"])
    buff:setAttribute("MIMU", skill.evo_rank3["Script Arg1"])
  end
  local bid2 = 10005903
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = caster:addBuff(binfo2, caster)
  caster.ultIng_ST = true
  caster.originposition_ST = {
    caster.position[1],
    caster.position[2]
  }
  local direction = target2.position[1] - caster.position[1] > 0 and 1 or -1
  local targetx = target2.position[1] + direction * ST.distancegap_ult
  if target2.buff_effects.stable then
    targetx = target2.position[1] - direction * ST.distancegap_ult
  end
  if 799 < targetx or targetx < 1 then
    targetx = 400 + direction * 380
  end
  caster.targetposition_ST = {
    targetx,
    target2.position[2]
  }
  local distance = targetx - caster.position[1]
  local directiontag = 1
  if distance < 0 then
    directiontag = -1
    distance = -distance
  end
  local flyingTime = distance / ST.stormVelocity
  local stormVelocity = ST.stormVelocity
  if flyingTime < ST.minFlyingTime then
    flyingTime = ST.minFlyingTime
    stormVelocity = distance / flyingTime
  end
  caster.flyingTime_ST = flyingTime
  caster.stormVelocity_ST = stormVelocity
  caster.walk_v = {
    stormVelocity * directiontag,
    0
  }
  caster.flyingTag_ST = 1
end

function ST.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local atk3 = caster.skills.ST_atk3
  if attack_counter == 2 then
    location = skill.caster.originposition_ST
    basefunc(skill, location, source)
  elseif attack_counter == 10 then
    location = skill.caster.targetposition_ST
    basefunc(skill, location, source)
  elseif attack_counter == 4 then
    basefunc(skill, location, source)
  elseif atk3 and (attack_counter == 3 or attack_counter == 6 or attack_counter == 8) then
    basefunc(atk3, location, source)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_ST_atk4.cha", {
        location[1],
        location[2] + 1
      }, {1, 1}, nil, 0)
    end
  end
end

function ST.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local current_phase_idx = skill.current_phase_idx
  if attack_counter == 1 then
    local direction = caster.targetposition_ST[1] - caster.originposition_ST[1] > 0 and 1 or -1
    local xx = (caster.targetposition_ST[1] - caster.originposition_ST[1]) * direction
    local xx2 = (caster.originposition_ST[1] - caster.position[1]) * direction
    caster.targetposition_ST_true = {
      caster.position[1],
      caster.position[2]
    }
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = xx,
      ["X Shift"] = xx2
    })
    basefunc(skill)
    skill.info = originfo
    skill.origintarget = skill.target
    local bid = 10005906
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  elseif attack_counter == 0 or attack_counter == 8 then
    basefunc(skill)
  elseif attack_counter == 2 then
    local atk = caster.skills.ST_atk3
    atk = atk or caster.skills.ST_atk
    skill.info = ed.wraptable(atk.info, {})
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter == 3 then
    local atk = caster.skills.ST_atk4
    if atk then
      caster.ST_atk4_target = skill.target
    end
    atk = atk or caster.skills.ST_atk
    skill.info = ed.wraptable(atk.info, {})
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter == 4 then
    if caster.ST_atk4_target then
      local bid = 10005905
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster.ST_atk4_target, caster)
      buff.update = override(buff.update, ST.skillatk4_buffUpdate)
      caster.ST_atk4_target:addBuff(buff, caster)
    end
    basefunc(skill)
  elseif attack_counter == 5 then
    local atk = caster.skills.ST_atk3
    atk = atk or caster.skills.ST_atk
    skill.info = ed.wraptable(atk.info, {})
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter == 6 then
    local atk = caster.skills.ST_atk2
    atk = atk or caster.skills.ST_atk
    skill.info = ed.wraptable(atk.info, {})
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter == 7 then
    local atk = caster.skills.ST_atk3
    atk = atk or caster.skills.ST_atk
    skill.info = ed.wraptable(atk.info, {})
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter == 9 then
    local direction = caster.targetposition_ST[1] - caster.originposition_ST[1] > 0 and 1 or -1
    local xx = (caster.targetposition_ST_true[1] or caster.targetposition_ST[1] - caster.position[1]) * direction
    local xx2 = 0
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = xx,
      ["X Shift"] = xx2
    })
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 10005906 then
        caster:removeBuff(tbuff)
        break
      end
    end
    basefunc(skill)
  else
    basefunc(skill)
  end
end

function ST.skillult_finish(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10005901 then
      caster:removeBuff(tbuff)
      break
    end
  end
  caster.ultIng_ST = false
  caster.walk_v = {0, 0}
  caster.flyingTime_ST = nil
  caster.flyingTag_ST = nil
  caster.targetposition_ST = nil
  caster.originposition_ST = nil
  caster.skills.ST_ult.origintarget = nil
  local skillatk2 = caster.skills.ST_atk2
  local skillatk4 = caster.skills.ST_atk4
  local skillatk2_cd = 0
  local skillatk4_cd = 0
  if skillatk2 then
    skillatk2_cd = caster.skills.ST_atk2.cd_remaining
  end
  if skillatk4 then
    skillatk4_cd = caster.skills.ST_atk4.cd_remaining
  end
  local skillatk3 = caster.skills.ST_atk3
  if skillatk3 then
    caster:enterActionStageFromOneStage(2, 59)
    caster.skills.ST_ult.cd_remaining = 0
    caster.stormEnergy_ST = true
    if skillatk2 then
      caster.skills.ST_atk2.cd_remaining = skillatk2_cd
    end
    if skillatk4 then
      caster.skills.ST_atk4.cd_remaining = skillatk4_cd
    end
  end
  if skill.origintarget and skill.origintarget:isAlive() then
    if 0 < (caster.position[1] - skill.origintarget.position[1]) * caster.direction then
      caster.direction = -caster.direction
    end
  else
    local target2 = caster.ai:searchTarget()
    if target2 and target2:isAlive() and 0 < (caster.position[1] - target2.position[1]) * caster.direction then
      caster.direction = -caster.direction
    end
  end
end

function ST.skillult_onPhaseFinished(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local atk2 = caster.skills.ST_atk2
  local atk3 = caster.skills.ST_atk3
  local atk4 = caster.skills.ST_atk4
  if attack_counter == 2 then
    caster.walk_v = {0, 0}
    if skill.origintarget and skill.origintarget:isAlive() then
      if 0 < (caster.position[1] - skill.origintarget.position[1]) * caster.direction then
        caster.direction = -caster.direction
      end
    else
      local target2 = caster.ai:searchTarget()
      if target2 and target2:isAlive() and 0 < (caster.position[1] - target2.position[1]) * caster.direction then
        caster.direction = -caster.direction
      end
    end
    if not atk2 then
      skill.attack_counter = skill.attack_counter + 6
      skill.current_phase_idx = skill.current_phase_idx + 5
    elseif not atk3 then
      skill.attack_counter = skill.attack_counter + 4
      skill.current_phase_idx = skill.current_phase_idx + 3
    elseif not atk4 then
      skill.attack_counter = skill.attack_counter + 3
      skill.current_phase_idx = skill.current_phase_idx + 2
    end
  elseif attack_counter == 3 or attack_counter == 7 then
    if not atk3 then
      skill.attack_counter = skill.attack_counter + 1
      skill.current_phase_idx = skill.current_phase_idx + 1
    end
  elseif attack_counter == 4 and not atk4 then
    skill.attack_counter = skill.attack_counter + 3
    skill.current_phase_idx = skill.current_phase_idx + 2
  end
  if not (attack_counter ~= 8 and (attack_counter ~= 3 and attack_counter ~= 7 or atk3) and (attack_counter ~= 2 or atk2)) or attack_counter == 4 and not atk4 then
    local distance = caster.originposition_ST[1] - caster.position[1]
    local directiontag = 1
    if distance < 0 then
      directiontag = -1
      distance = -distance
    end
    local flyingTime = distance / ST.stormVelocity
    local stormVelocity = ST.stormVelocity
    if flyingTime < ST.minFlyingTime then
      flyingTime = ST.minFlyingTime
      stormVelocity = distance / flyingTime
    end
    caster.flyingTime_ST = flyingTime
    caster.stormVelocity_ST = stormVelocity
    caster.walk_v = {
      stormVelocity * directiontag,
      0
    }
    caster.flyingTag_ST = 1
    local bid = 10005903
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
  if attack_counter == 9 then
    caster.walk_v = {0, 0}
    if skill.origintarget and skill.origintarget:isAlive() then
      if 0 < (caster.position[1] - skill.origintarget.position[1]) * caster.direction then
        caster.direction = -caster.direction
      end
    else
      local target2 = caster.ai:searchTarget()
      if target2 and target2:isAlive() and 0 < (caster.position[1] - target2.position[1]) * caster.direction then
        caster.direction = -caster.direction
      end
    end
  end
  basefunc(skill)
end

function ST.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.flyingTag_ST and hero.flyingTime_ST then
    if ed.run_with_scene and hero.flyingTag_ST > 0 then
      local offset = ST.offsets
      ed.scene:playEffectOnScene("eff_point_ST_ult.cha", {
        hero.position[1] - hero.direction * offset * ST.ratio,
        hero.position[2] + 1
      }, {
        hero.direction,
        1
      }, nil, 0)
    end
    hero.flyingTag_ST = hero.flyingTag_ST + 1
    if hero.flyingTime_ST < 0.126 then
      hero.remainDistance = hero.flyingTime_ST * hero.stormVelocity_ST
      local vx = hero.remainDistance / ST.ult2time
      if 0 > hero.walk_v[1] then
        vx = -vx
      end
      hero.walk_v = {vx, 0}
      hero.flyingTime_ST = nil
      hero.flyingTag_ST = nil
      if hero.current_skill then
        hero.current_skill:onPhaseFinished()
      end
    end
    if hero.flyingTime_ST then
      hero.flyingTime_ST = hero.flyingTime_ST - dt
    end
  end
end

function ST.hero_getRuntimeScale(basefunc, hero)
  return hero.direction, 1
end

function ST.hero_reset(basefunc, hero)
  basefunc(hero)
  hero:enterActionStageFromOneStage(1, 59)
  if hero.stormEnergy_ST then
    hero.stormEnergy_ST = nil
  end
  hero.ultIng_ST = false
  hero.walk_v = {0, 0}
  hero.flyingTime_ST = nil
  hero.flyingTag_ST = nil
  hero.targetposition_ST = nil
  hero.originposition_ST = nil
  if hero.skills.ST_ult then
    hero.skills.ST_ult.origintarget = nil
  end
end

function ST.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.ultIng_ST then
    return false, "ultIng"
  end
  return basefunc(skill, target)
end

function ST.skillatk4_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    basefunc(skill)
  else
    skill.attack_counter = skill.attack_counter + 1
    local target = skill.target
    local caster = skill.caster
    if target and target.buff_effects.stun then
      local bid = 10005905
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.update = override(buff.update, ST.skillatk4_buffUpdate)
      target:addBuff(buff, caster)
    end
  end
end

function ST.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local time = 0.05
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, caster.position)
  if owner.position[1] == caster.position[1] then
  elseif DistanceSQ < 2500 then
  else
    direction = ed.edpNormalize(ed.edpSub(owner.position, caster.position))
    owner:knockup(time, ed.edpMult(direction, -5), true)
  end
end

function ST.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = buff.timer + 1
  end
  return buff
end

function ST.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local Tr, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if Tr and target then
    local bid = 10005904
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
end

function ST.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.update = override(hero.update, ST.hero_update)
  if hero.name == "ST" then
    hero.getRuntimeScale = override(hero.getRuntimeScale, ST.hero_getRuntimeScale)
  end
  hero.reset = override(hero.reset, ST.hero_reset)
  local skillult = hero.skills.ST_ult
  if skillult then
    skillult.start = override(skillult.start, ST.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ST.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, ST.skillult_finish)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, ST.skillult_onPhaseFinished)
    skillult.power = override(skillult.power, ST.skillult_power)
    skillult.createProjectile = override(skillult.createProjectile, ST.skillatk2_createProjectile)
    skillult.takeEffectAt = override(skillult.takeEffectAt, ST.skillult_takeEffectAt)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ST.skillult_canCastWithTarget)
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
  local skillatk2 = hero.skills.ST_atk2
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, ST.skillatk2_createProjectile)
    skillatk2.finish = override(skillatk2.finish, ST.skillatk2_finish)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Shape Arg1"] = 125
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  local skillatk3 = hero.skills.ST_atk3
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, ST.skillatk3_canCastWithTarget)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, ST.skillatk3_takeEffectAt)
    skillatk3.finish = override(skillatk3.finish, ST.skillatk3_finish)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, ST.skillatk3_takeEffectOn)
    end
  end
  local skillatk4 = hero.skills.ST_atk4
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, ST.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, ST.skillatk4_createBuff)
    skillatk4.finish = override(skillatk4.finish, ST.skillatk4_finish)
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

return ST.init_hero
