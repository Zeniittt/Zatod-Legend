module("ed.battlehero", package.seeall)
local ed = ed
POP = {}
POP.name = "POP"
POP.sandBuff_killCoef = 0.7
POP.sandBuff_killEffect = "eff_point_POP_sand.cha"
POP.sandBuff_maxExtraDamage = 30000
POP.sandKillMarkBuff = 894
POP.sandKillGainMp = 0
POP.sandBuffBeDamagedGainMp = 200
POP.getSandEffect_sandKill = "eff_impact_POP_addmp.cha"
POP.getSandEffect_sandOnDamaged = "eff_impact_POP_addmp.cha"
POP.effect_sandOnDamaged = "eff_impact_POP_sand.cha"
POP.atk_sandBuff = 889
POP.atk2_sandTime = 1.25
POP.atk2_wallMode_cd = 10
POP.atk2_aoeMode_cd = 10
POP.atk2_darkMode_cd = 4
POP.atk2_wallMode_checkEnemyRange = 140
POP.atk2_wallMode_distance = 135
POP.atk2_wallMode_actionDistance = 50
POP.atk2_wallMode_shapeLength = 350
POP.atk2_wallMode_shapeWidth = 300
POP.atk2_aoeMode_checkEnemyRange = 120
POP.atk2_aoeMode_enemyCondition = 2
POP.atk2_normalMode_checkEnemyRange = 120
POP.atk2_normalMode_buffId = 890
POP.atk2_darkMode_checkEnemyRange = 220
POP.atk2_darkMode_noKnockBackRange = 60
POP.atk2_plusRatio = {
  [1] = {
    0.25,
    0.25,
    0.7,
    1.1
  },
  [2] = {
    0.2,
    0.4,
    0.65,
    0.65,
    0.65
  },
  [3] = {
    0.3,
    0.3,
    0.7,
    1
  },
  [4] = {
    1,
    1,
    1.2
  },
  [-1] = {0}
}
POP.atk2_gainMp = {
  [1] = {
    8,
    8,
    15,
    30
  },
  [2] = {
    10,
    10,
    15,
    15,
    15
  },
  [3] = {
    10,
    10,
    20,
    40
  },
  [4] = {
    30,
    30,
    30
  },
  [-1] = {0}
}
POP.atk2_finishX = {
  [1] = {
    32.5,
    65,
    110,
    175
  },
  [2] = {
    85,
    100,
    160,
    160,
    288
  },
  [3] = {
    -35,
    -35,
    -15,
    -191
  },
  [4] = {
    15,
    30,
    15
  }
}
POP.atk3_scaleChangeBuffId = 899
POP.atk3_scale = 0.8
POP.atk3_attackRange = 100
POP.atk3_wallHeight = 10
POP.atk3_moveY = 60
POP.atk3_moveYRatio = 0.5
POP.atk3_walkSpeed = 300
POP.atk3_extraDamageCoef1 = 0.15
POP.atk3_extraDamageCoef2 = 0.25
POP.atk3_invulnerableBuff = 891
POP.atk3_leastMove = 150
POP.atk3_attackCounterTime = 0.33
POP.atk3_jumpBackTime = 0.4
POP.atk3_wallEffectName = "eff_point_POP_atk3_wall.cha"
POP.atk4_maxSaveCd = 1.5
POP.atk4_timeOneCircle = 0.54
POP.atk4_timePoint1 = 0.25
POP.atk4_timePoint2 = 0.5
POP.atk4_breakRatio = 0.35
POP.atk4_dodgBuffId = 888
POP.atk4_powerupBuffId = 893
POP.atk4_minTumbleRange = 150
POP.atk4_maxTumbleRange = 400
POP.atk4_s_enemyCheckRange = 200
POP.atk4_s_hpRatioPoint = 0.5
POP.atk4_s_enemyValueMax = 0.5
POP.atk4_s_enemyValueMin = -0.1
POP.atk4_s_useAtk4Prior = -0.5
POP.atk4_s_useAtk4 = 3
POP.atk4_s_tooNearRange = 40
POP.ult_useMpCondition = 1000
POP.ult_useSandCd = 2.25
POP.ult_sandTime = 0.75
POP.ult_useSandCost = 250
POP.awake_darkenedSpeed = 1.7
POP.awake_darkenedPhaseEffectList = {
  {
    20,
    "eff_point_POP_awake.cha"
  },
  {
    40,
    "eff_point_POP_awake.cha"
  },
  {
    60,
    "eff_point_POP_awake.cha"
  },
  {
    80,
    "eff_point_POP_awake.cha"
  },
  {
    90,
    "eff_point_POP_awake.cha"
  },
  {
    100,
    "eff_point_POP_awake.cha"
  }
}
POP.awake_darkenedPhaseBuff = 900
POP.awake_panel = "UI/DOTA-HERO/SwitchPOP_dark.jpg"
POP.awake_darkenCondition = 100
POP.awake_uncontrollableBuffId = 895
POP.awake_powerupBuffId = 896
POP.awake_powerupBuffLostHpCoef = 0.04
POP.awakeb_fixCoef = 1
POP.awakeb_minAdd = 0.3
POP.awakeb_maxAdd = 7.5
POP.awakeb_maxAddNeedLostHp = 0.5
POP.dieWordEffect = "eff_point_POP_death.cha"
POP.emptyBuffID = 233
POP.classicalFashionId = 100441

function POP.isNearDest(pos1, pos2, range)
  local delta_X = pos1[1] - pos2[1]
  local delta_Y = pos1[2] - pos2[2]
  if delta_X * delta_X + delta_Y * delta_Y <= range * range then
    return true
  end
  return false
end

function POP.getVirtualPosition(unit)
  local atk2 = unit.skills[POP.name .. "_atk2"]
  if atk2 and atk2.casting and atk2 == atk2.caster.current_skill then
    local mode = atk2.current_phase_idx or 0
    local attackCounter = atk2.attack_counter or 0
    local virtualPos = {}
    virtualPos[1] = unit.position[1]
    virtualPos[2] = unit.position[2]
    if POP.atk2_finishX[mode][attackCounter] then
      local deltaX = POP.atk2_finishX[mode][attackCounter]
      if deltaX then
        local minX = ed.engine.stage_rect.minX
        local maxX = ed.engine.stage_rect.maxX
        virtualPos[1] = math.max(minX, math.min(maxX, virtualPos[1] + unit.direction * deltaX))
      end
    end
    return virtualPos
  end
  return unit.position
end

function POP.sandBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
  local killLine = buff.owner.hp * POP.sandBuff_killCoef
  local maxkillLine = buff.owner.hp - POP.sandBuff_maxExtraDamage
  killLine = math.max(maxkillLine, killLine)
  local owner = buff.owner
  local caster = buff.caster
  local immunity
  if damage_type == "AD" then
    immunity = owner.attribs.PIMU or 0
  elseif damage_type == "AP" then
    immunity = owner.attribs.MIMU or 0
  elseif damage_type == "Holy" then
    immunity = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local dmgAfterImmunity = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  local lostRatio = math.min(1, math.max(0, dmgAfterImmunity / owner.attribs.HP))
  local gainMp = lostRatio * POP.sandBuffBeDamagedGainMp
  caster:setMP(caster.mp + gainMp)
  if ed.run_with_scene then
    local casterVirtualPos = POP.getVirtualPosition(caster)
    local direction = owner.position[1] >= casterVirtualPos[1] and 1 or -1
    local effect_name = POP.getSandEffect_sandOnDamaged
    if effect_name then
      ed.scene:playEffectOnScene(effect_name, casterVirtualPos, {direction, 1}, nil, 1)
    end
    local effect_name = POP.effect_sandOnDamaged
    ed.scene:playEffectOnScene(effect_name, owner.position, {
      -direction,
      1
    }, nil, 1)
  end
  if killLine <= dmgAfterImmunity then
    local binfo = ed.lookupDataTable("Buff", nil, POP.sandKillMarkBuff)
    local buff = owner:addBuff(binfo, caster)
    local atk2c = caster.skills[POP.name .. "_atk2c"]
    if atk2c then
      local sandKillProjectile = atk2c:createProjectile()
      sandKillProjectile.POP_watchTarget = owner
      sandKillProjectile.POP_alreadySandKill = false
      ed.engine:addProjectile(sandKillProjectile)
      if ed.run_with_scene then
        local effect_name = POP.sandBuff_killEffect
        ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 0)
      end
    end
    caster:setMP(caster.mp + POP.sandKillGainMp)
    if ed.run_with_scene then
      local direction = owner.position[1] >= caster.position[1] and 1 or -1
      local effect_name = POP.getSandEffect_sandKill
      ed.scene:playEffectOnScene(effect_name, caster.position, {direction, 1}, nil, 0)
    end
    return damage
  else
    return damage
  end
end

function POP.addSandBuff(target, duration, skill)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, POP.atk_sandBuff)
  local bsuccess, reason = ed.Buff.checkAddBuff(binfo, skill.level, target, caster)
  if bsuccess then
    local alreadyBuff
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == POP.atk_sandBuff then
        alreadyBuff = tbuff
        break
      end
    end
    if alreadyBuff then
      alreadyBuff.timer = math.max(duration, alreadyBuff.timer)
    else
      local buff = target:addBuff(binfo, caster)
      if buff then
        buff.timer = duration
        buff.onDamaged = override(buff.onDamaged, POP.sandBuff_onDamaged)
      end
    end
  else
    local color = target.camp == ed.emCampEnemy and "red" or "blue"
    local text = reason == "resist" and "resist" or "miss"
    if target.actor then
      ed.PopupCreate(text, color, target.actor, nil, "text")
    end
  end
end

function POP.skillatk2c_projectile_update(basefunc, projectile, dt)
  local watchTarget = projectile.POP_watchTarget
  local caster = projectile.caster
  if watchTarget then
    local hasBuff = false
    for _, buff in ipairs(watchTarget.buff_list) do
      if buff.info.ID == POP.sandKillMarkBuff then
        hasBuff = true
        break
      end
    end
    if not projectile.POP_alreadySandKill and watchTarget then
      projectile.POP_alreadySandKill = true
      if watchTarget:isAlive() and caster and hasBuff then
        watchTarget:onDying(projectile.caster)
        local remainHp = watchTarget.hp
        caster.battledata:addDamage(remainHp, "Holy")
        if ed.run_with_scene and watchTarget.actor then
          local str = "-" .. math.floor(remainHp + 0.5)
          if str ~= "-0" then
            local color
            if watchTarget.camp == ed.emCampPlayer then
              color = "red"
            else
              color = "orange"
            end
            if not watchTarget.notPopupBattleInfo then
              ed.PopupCreate(str, color, watchTarget.actor, false)
            end
          end
        end
      end
    end
    if hasBuff then
      if watchTarget.state == ed.emUnitState_Dying then
        watchTarget.state = ed.emUnitState_Dead
        watchTarget:setAction(nil)
        watchTarget.hasCorpse = false
        if watchTarget.actor and watchTarget.actor.node then
          watchTarget.actor.node:setVisible(false)
        end
        if not projectile.terminated then
          projectile:terminate()
        end
      elseif watchTarget.state == ed.emUnitState_Dead then
        if not projectile.terminated then
          projectile:terminate()
        end
      else
        return
      end
    elseif not projectile.terminated then
      projectile:terminate()
    end
  end
end

function POP.skillatk2c_createProjectile(basefunc, skill)
  local sandKillProjectile = basefunc(skill)
  sandKillProjectile.update = override(sandKillProjectile.update, POP.skillatk2c_projectile_update)
  sandKillProjectile.height = 999
  return sandKillProjectile
end

function POP.func_countNearEnemy(unit, position, range)
  local count = 0
  for enemy in ed.engine:foreachAliveUnit(unit.foecamp) do
    if enemy.buff_effects.invulnerable then
    elseif not POP.isNearDest(position, enemy.position, range) then
    else
      count = count + 1
    end
  end
  return count
end

function POP.skillatk2_func_hideBuffEffect(unit)
  for i, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function POP.skillatk2_func_resetBuffEffect(unit)
  for i, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function POP.skillatk2_normalMode_conditionFunc(skill, checkPosition)
  local caster = skill.caster
  if POP.func_countNearEnemy(caster, checkPosition, POP.atk2_normalMode_checkEnemyRange) < 1 then
    return false
  end
  return true
end

function POP.skillatk2_wallMode_conditionFunc(skill, checkPosition)
  local caster = skill.caster
  local minX = ed.engine.stage_rect.minX
  local minY = ed.engine.stage_rect.minY
  local maxX = ed.engine.stage_rect.maxX
  local maxY = ed.engine.stage_rect.maxY
  local tempCheckPos = {
    checkPosition[1],
    checkPosition[2]
  }
  tempCheckPos[1] = tempCheckPos[1] >= (ed.engine.stage_rect.minX + ed.engine.stage_rect.maxX) / 2 and ed.engine.stage_rect.maxX - POP.atk2_wallMode_actionDistance or ed.engine.stage_rect.minX + POP.atk2_wallMode_actionDistance
  if 1 > POP.func_countNearEnemy(caster, tempCheckPos, POP.atk2_wallMode_checkEnemyRange) then
    return false
  end
  if skill.wallModeCd > 0 then
    return false
  end
  if checkPosition[1] > minX + POP.atk2_wallMode_distance and checkPosition[1] < maxX - POP.atk2_wallMode_distance then
    return false
  end
  return true
end

function POP.skillatk2_aoeMode_conditionFunc(skill, checkPosition)
  local caster = skill.caster
  if skill.aoeModeCd > 0 then
    return false
  end
  if POP.func_countNearEnemy(caster, checkPosition, POP.atk2_aoeMode_checkEnemyRange) < POP.atk2_aoeMode_enemyCondition then
    return false
  end
  return true
end

function POP.skillatk2_darkMode_conditionFunc(skill, checkPosition)
  local caster = skill.caster
  if not caster.darkenedAlready then
    return false
  end
  if skill.darkModeCd > 0 then
    return false
  end
  if POP.func_countNearEnemy(caster, checkPosition, POP.atk2_darkMode_checkEnemyRange) < 1 then
    return false
  end
  return true
end

function POP.skillatk2_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local position = skill.caster and skill.caster.position
    local specialCondition = true
    if not position or POP.skillatk2_normalMode_conditionFunc(skill, position) then
    elseif POP.skillatk2_darkMode_conditionFunc(skill, position) then
    elseif POP.skillatk2_aoeMode_conditionFunc(skill, position) then
    elseif POP.skillatk2_wallMode_conditionFunc(skill, position) then
    else
      specialCondition = false
    end
    if not specialCondition then
      return false, "mode condition error"
    end
  end
  return canUse, reason
end

function POP.skillatk2_start(basefunc, skill)
  basefunc(skill)
  skill.nextHitWillStun = false
  skill.nextHitWillSand = false
  skill.knockBackFix = false
  skill.lockKnockDirection = nil
  skill.POP_atk2_normal_lockTarget = nil
  local caster = skill.caster
  POP.skillatk2_func_hideBuffEffect(caster)
  caster:setHpVisible(false)
  if caster.POP_atk4_adBuff then
    local buff = caster.POP_atk4_adBuff
    local addAd = buff.willAddAd or 0
    buff:setAttribute("AD", addAd)
    caster:resetBuffApply(buff)
  end
  if POP.skillatk2_wallMode_conditionFunc(skill, caster.position) then
    skill.wallModeCd = POP.atk2_wallMode_cd
    if caster.position[1] >= (ed.engine.stage_rect.minX + ed.engine.stage_rect.maxX) / 2 then
      caster.position[1] = ed.engine.stage_rect.maxX - POP.atk2_wallMode_actionDistance
      if 0 > caster.direction then
        caster.direction = -caster.direction
      end
    elseif caster.position[1] < (ed.engine.stage_rect.minX + ed.engine.stage_rect.maxX) / 2 then
      caster.position[1] = ed.engine.stage_rect.minX + POP.atk2_wallMode_actionDistance
      if 0 < caster.direction then
        caster.direction = -caster.direction
      end
    end
    skill.target = caster
    skill:startPhase(3)
  elseif POP.skillatk2_darkMode_conditionFunc(skill, caster.position) then
    skill.darkModeCd = POP.atk2_darkMode_cd
    if skill.target and 0 > (skill.target.position[1] - caster.position[1]) * caster.direction then
      caster.direction = -caster.direction
    end
    skill.target = caster
    skill:startPhase(4)
  elseif POP.skillatk2_aoeMode_conditionFunc(skill, caster.position) then
    skill.aoeModeCd = POP.atk2_aoeMode_cd
    for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
      local enemyCount = {0, 0}
      if enemy.buff_effects.invulnerable then
      else
        local deltaX = enemy.position[1] - caster.position[1]
        if math.abs(deltaX) > 200 then
        elseif 0 <= deltaX then
          enemyCount[2] = enemyCount[2] + 1
          if enemyCount[2] > enemyCount[1] then
            skill.target = enemy
          end
        else
          enemyCount[1] = enemyCount[1] + 1
          if enemyCount[1] > enemyCount[2] then
            skill.target = enemy
          end
        end
      end
    end
    if skill.target and 0 > (skill.target.position[1] - caster.position[1]) * caster.direction then
      caster.direction = -caster.direction
    end
    skill.target = caster
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
end

function POP.skillatk2_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function POP.skillatk2_aoeMode_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local originInfo = skill.info
  local mode = skill.current_phase_idx or -1
  local attackCounter = skill.attack_counter and skill.attack_counter + 1 or 1
  if skill.attack_counter == 0 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -50,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 190,
      ["Knock Up"] = 0.05,
      ["Knock Back"] = 20
    })
    skill.lockKnockDirection = 1
    basefunc(skill)
    skill.lockKnockDirection = nil
    skill.info = originInfo
  elseif skill.attack_counter == 1 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -30,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 190,
      ["Knock Up"] = 0.4,
      ["Knock Back"] = 30
    })
    skill.lockKnockDirection = 1
    basefunc(skill)
    skill.lockKnockDirection = nil
    skill.info = originInfo
  elseif skill.attack_counter == 2 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = 150,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 100
    })
    basefunc(skill)
    skill.info = originInfo
  elseif skill.attack_counter == 3 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = 150,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 100,
      ["Plus Ratio"] = 0.6
    })
    basefunc(skill)
    skill.info = originInfo
  elseif skill.attack_counter == 4 then
    local extraDamage = skill.info["Script Arg1"] or 0
    skill.info = ed.wraptable(originInfo, {
      ["Basic Num"] = extraDamage,
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = 150,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 100
    })
    skill.nextHitWillSand = true
    basefunc(skill)
    skill.nextHitWillSand = false
    skill.info = originInfo
  end
end

function POP.skillatk2_normalMode_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local originInfo = skill.info
  local mode = skill.current_phase_idx or -1
  local attackCounter = skill.attack_counter and skill.attack_counter + 1 or 1
  if skill.attack_counter == 0 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["No Dodge"] = true,
      ["Knock Up"] = 0.1,
      ["Knock Back"] = 20
    })
    skill.nextHitWillStun = true
    basefunc(skill)
    skill.nextHitWillStun = false
    skill.POP_atk2_normal_lockTarget = skill.target
    skill:lockCasterDirection(true)
    skill.info = originInfo
  elseif skill.attack_counter == 1 then
    if skill.target == skill.POP_atk2_normal_lockTarget and skill.target and skill.target:isAlive() then
      skill.info = ed.wraptable(originInfo, {
        ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
        ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
        ["No Dodge"] = true,
        ["Knock Up"] = 0.1,
        ["Knock Back"] = 20
      })
      basefunc(skill)
      skill.info = originInfo
    else
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif skill.attack_counter == 2 then
    if skill.target == skill.POP_atk2_normal_lockTarget and skill.target and skill.target:isAlive() then
      skill.info = ed.wraptable(originInfo, {
        ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
        ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
        ["No Dodge"] = true,
        ["Knock Up"] = 0.5,
        ["Knock Back"] = 20
      })
      basefunc(skill)
      skill.info = originInfo
    else
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif skill.attack_counter == 3 then
    if skill.target == skill.POP_atk2_normal_lockTarget and skill.target and skill.target:isAlive() then
      local extraDamage = skill.info["Script Arg1"] or 0
      skill.info = ed.wraptable(originInfo, {
        ["Basic Num"] = extraDamage,
        ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
        ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
        ["No Dodge"] = true,
        ["Knock Up"] = 0.15,
        ["Knock Back"] = -50
      })
      skill.nextHitWillSand = true
      basefunc(skill)
      skill.nextHitWillSand = false
      skill.info = originInfo
    else
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function POP.skillatk2_wallMode_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local originInfo = skill.info
  local mode = skill.current_phase_idx or -1
  local attackCounter = skill.attack_counter and skill.attack_counter + 1 or 1
  if skill.attack_counter == 0 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -140,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 240,
      ["Shape Arg2"] = 240,
      ["Knock Up"] = 0.05,
      ["Knock Back"] = 5
    })
    skill.lockKnockDirection = -1
    basefunc(skill)
    skill.lockKnockDirection = nil
    skill.info = originInfo
  elseif skill.attack_counter == 1 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -140,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 240,
      ["Shape Arg2"] = 240,
      ["Knock Up"] = 0.05,
      ["Knock Back"] = 5
    })
    skill.lockKnockDirection = -1
    basefunc(skill)
    skill.lockKnockDirection = nil
    skill.info = originInfo
  elseif skill.attack_counter == 2 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -170,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 250,
      ["Shape Arg2"] = 240,
      ["Knock Up"] = 0.7,
      ["Knock Back"] = 60
    })
    skill.nextHitWillStun = true
    skill.lockKnockDirection = -1
    basefunc(skill)
    skill.nextHitWillStun = false
    skill.lockKnockDirection = nil
    skill.info = originInfo
  elseif skill.attack_counter == 3 then
    local extraDamage = skill.info["Script Arg1"] or 0
    skill.info = ed.wraptable(originInfo, {
      ["Basic Num"] = extraDamage,
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -240,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 180,
      ["Shape Arg2"] = 240,
      ["Knock Up"] = 0.35,
      ["Knock Back"] = -90
    })
    skill.nextHitWillSand = true
    skill.lockKnockDirection = 1
    basefunc(skill)
    skill.lockKnockDirection = nil
    skill.nextHitWillSand = false
    skill.info = originInfo
  end
end

function POP.skillatk2_darkMode_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local originInfo = skill.info
  local mode = skill.current_phase_idx or -1
  local attackCounter = skill.attack_counter and skill.attack_counter + 1 or 1
  if skill.attack_counter == 0 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -120,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 400,
      ["Shape Arg2"] = 300,
      ["Knock Up"] = 0.05,
      ["Knock Back"] = -20
    })
    skill.knockBackFix = true
    basefunc(skill)
    skill.knockBackFix = false
    skill.info = originInfo
  elseif skill.attack_counter == 1 then
    skill.info = ed.wraptable(originInfo, {
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -110,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 400,
      ["Shape Arg2"] = 300,
      ["Knock Up"] = 0.05,
      ["Knock Back"] = -20
    })
    skill.knockBackFix = true
    basefunc(skill)
    skill.knockBackFix = false
    skill.info = originInfo
  elseif skill.attack_counter == 2 then
    local extraDamage = skill.info["Script Arg1"] or 0
    skill.info = ed.wraptable(originInfo, {
      ["Basic Num"] = extraDamage,
      ["Gain MP"] = POP.atk2_gainMp[mode][attackCounter],
      ["Plus Ratio"] = POP.atk2_plusRatio[mode][attackCounter],
      ["X Shift"] = -105,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 340,
      ["Shape Arg2"] = 300,
      ["Knock Up"] = 0.05,
      ["Knock Back"] = -20
    })
    skill.knockBackFix = true
    skill.nextHitWillSand = true
    basefunc(skill)
    skill.knockBackFix = false
    skill.nextHitWillSand = false
    skill.info = originInfo
  end
end

function POP.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local currentPhase = skill.current_phase_idx
  if currentPhase then
    if skill.current_phase_idx == 3 then
      POP.skillatk2_wallMode_onAttackFrame(basefunc, skill)
    elseif skill.current_phase_idx == 4 then
      POP.skillatk2_darkMode_onAttackFrame(basefunc, skill)
    elseif skill.current_phase_idx == 2 then
      POP.skillatk2_aoeMode_onAttackFrame(basefunc, skill)
    elseif skill.current_phase_idx == 1 then
      POP.skillatk2_normalMode_onAttackFrame(basefunc, skill)
    end
  end
end

function POP.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local lockKnock = skill.lockKnockDirection
  local originInfo = skill.info
  local caster = skill.caster
  if lockKnock then
    local originKnock = skill.info["Knock Back"]
    if lockKnock * caster.direction * originKnock * (target.position[1] - caster.position[1]) < 0 then
      skill.info = ed.wraptable(originInfo, {
        ["Knock Back"] = -originKnock
      })
    end
  elseif skill.knockBackFix and math.abs(target.position[1] - (caster.position[1] + caster.direction * 15)) <= POP.atk2_darkMode_noKnockBackRange then
    local knockDirc = skill.info["Knock Back"] >= 0 and 1 or -1
    skill.info = ed.wraptable(originInfo, {
      ["Knock Back"] = knockDirc
    })
  end
  local hit, dmg, Crit = basefunc(skill, target, source, shift)
  skill.info = originInfo
  if hit and target and target:isAlive() and skill.nextHitWillSand then
    local skillatk2 = caster.skills[POP.name .. "_atk2"]
    POP.addSandBuff(target, POP.atk2_sandTime, skillatk2)
  end
  if hit and target and target:isAlive() and skill.nextHitWillStun then
    local caster = skill.caster
    local binfo = ed.lookupDataTable("Buff", nil, POP.atk2_normalMode_buffId)
    local buff = target:addBuff(binfo, caster)
  end
  return hit, dmg, Crit
end

function POP.skillatk2_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  skill.aoeModeCd = skill.aoeModeCd and skill.aoeModeCd - dt_cd or 0
  skill.wallModeCd = skill.wallModeCd and skill.wallModeCd - dt_cd or 0
  skill.darkModeCd = skill.darkModeCd and skill.darkModeCd - dt_cd or 0
end

function POP.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.POP_atk4_adBuff then
    caster.POP_atk4_adBuff.timer = 0
    caster.POP_atk4_adBuff = nil
  end
  POP.skillatk2_func_resetBuffEffect(caster)
  caster:setHpVisible(true)
  local minX = ed.engine.stage_rect.minX
  local maxX = ed.engine.stage_rect.maxX
  local mode = skill.current_phase_idx or 0
  local attackCounter = skill.attack_counter or 0
  if POP.atk2_finishX[mode][attackCounter] then
    local deltaX = POP.atk2_finishX[mode][attackCounter]
    local newPosition1 = math.max(minX, math.min(maxX, caster.position[1] + caster.direction * deltaX))
    caster.position[1] = newPosition1
    if mode == 1 then
      caster.direction = -caster.direction
    end
  end
  skill:lockCasterDirection(false)
  caster.global_cd = 0.375
end

function POP.skillatk3_func_changeUnitScale(unit, scale, speed)
  local buff = unit.POP_atk3_scaleBuff
  if buff then
    if speed then
      buff:setAttribute("MSPD", speed)
      buff.owner:resetBuffApply(buff)
    end
    local info = buff.info
    local actor = unit.actor
    if type(info["Actor Scale"]) == "table" then
      info["Actor Scale"][1] = scale
      info["Actor Scale"][2] = scale
    end
    if actor and #info["Actor Scale"] ~= 0 then
      buff.scale_id = actor:useScale(info["Actor Scale"])
    end
  end
end

function POP.skillatk3_func_selectDirectionTarget(skill)
  local caster = skill.caster
  local direction = skill.moveDirection
  local casterX = caster.position[1]
  local startX = skill.startX
  local newTarget
  local minHpPercent = math.huge
  for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
    if enemy.buff_effects.untargetable then
    elseif enemy.buffManager.invisible and enemy.camp ~= caster.camp then
    elseif enemy.config.is_summoned then
    elseif math.abs(startX - enemy.position[1]) < POP.atk3_leastMove + 50 then
    elseif direction == "right" and enemy.position[1] < casterX - POP.atk3_attackRange then
    elseif direction == "left" and enemy.position[1] > casterX + POP.atk3_attackRange then
    else
      local hpPercent = enemy.hp / enemy.attribs.HP
      if minHpPercent > hpPercent then
        newTarget = enemy
        minHpPercent = hpPercent
      end
    end
  end
  skill.currentTargetHero = newTarget
  if newTarget then
    skill.currentTargetX = newTarget.position[1]
    skill.currentTargetY = newTarget.position[2]
    skill.currentTargetHero = newTarget
  end
end

function POP.skillatk3_func_checkExtraCondition(target, checkPosition)
  local targetX = target and target.position[1]
  if not (targetX and checkPosition) or math.abs(checkPosition[1] - targetX) <= POP.atk3_leastMove + 50 then
    return false
  end
  return true
end

function POP.skillatk3_func_createWall(positionX)
  if ed.run_with_scene and POP.atk3_wallEffectName then
    local position = {positionX, 70}
    local height = 0.9 + math.random() * 0.2
    ed.scene:playEffectOnScene(POP.atk3_wallEffectName, position, {1, height}, nil, -1)
  end
end

function POP.skillatk3_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local casterPos = skill.caster and skill.caster.position
    if not POP.skillatk3_func_checkExtraCondition(skill.target, casterPos) then
      return false, "weakest enemy is too near"
    end
  end
  return canUse, reason
end

function POP.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local target = skill.target
  local caster = skill.caster
  skill.startX = caster.position[1]
  skill.startY = caster.position[2]
  skill.currentTargetHero = skill.target
  skill.currentTargetX = skill.target.position[1]
  skill.currentTargetY = skill.target.position[2]
  if target.position[1] >= caster.position[1] then
    skill.moveDirection = "right"
    caster.direction = 1
  else
    skill.moveDirection = "left"
    caster.direction = -1
  end
  local binfo = ed.lookupDataTable("Buff", nil, POP.atk3_invulnerableBuff)
  local buff = caster:addBuff(binfo, caster)
  caster.POP_atk3_invulnerable = buff
  local binfo = ed.lookupDataTable("Buff", nil, POP.atk3_scaleChangeBuffId)
  local buff = caster:addBuff(binfo, caster)
  caster.POP_atk3_scaleBuff = buff
  skill.climbPhase = 1
  POP.skillatk3_func_createWall(caster.position[1])
  skill.startWallPosition = caster.position[1]
  POP.skillatk2_func_hideBuffEffect(caster)
end

function POP.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  skill.climbPhase = 2
  caster.position[2] = POP.atk3_moveYRatio * ed.engine.stage_rect.maxY
  POP.skillatk3_func_changeUnitScale(caster, POP.atk3_scale, 0)
end

function POP.skillatk3_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.casting and skill == skill.caster.current_skill then
    local caster = skill.caster
    if skill.climbPhase == 1 then
      local duration = skill.current_phase_elapsed
      local scale = 1 - (1 - POP.atk3_scale) * (duration / POP.atk3_attackCounterTime)
      POP.skillatk3_func_changeUnitScale(caster, scale)
      local startY = skill.startY
      local atk3_moveY = POP.atk3_moveYRatio * ed.engine.stage_rect.maxY
      local curY = startY + (atk3_moveY - startY) * ((duration - dt_action) / POP.atk3_attackCounterTime)
      caster.position[2] = curY
    elseif skill.climbPhase == 2 then
      POP.skillatk3_func_selectDirectionTarget(skill)
      local direction = skill.moveDirection == "right" and 1 or -1
      local targetX = skill.currentTargetX
      local casterX = caster.position[1]
      local startX = skill.startX
      if math.abs(casterX - targetX) < POP.atk3_attackRange and math.abs(startX - casterX) > POP.atk3_leastMove then
        if targetX <= caster.position[1] then
          caster.position[1] = math.min(ed.engine.stage_rect.maxX, targetX + POP.atk3_attackRange - 20)
        elseif targetX > caster.position[1] then
          caster.position[1] = math.max(ed.engine.stage_rect.minX, targetX - POP.atk3_attackRange + 20)
        end
        if (targetX - caster.position[1]) * caster.direction < 0 then
          caster.direction = -caster.direction
        end
        skill:finish()
        local skillatk3b = caster.skills[POP.name .. "_atk3b"]
        if skillatk3b then
          skillatk3b.targetY = skill.currentTargetY or skill.startY
          skillatk3b.lockTarget = skill.currentTargetHero
          caster:castSkill(skillatk3b, skill.currentTargetHero)
        end
      else
        caster.walk_v = {
          POP.atk3_walkSpeed,
          0
        }
        caster.walk_v[1] = caster.walk_v[1] * direction
        caster.height = POP.atk3_wallHeight
        local wallWidth = 43
        if skill.startWallPosition and wallWidth <= math.abs(caster.position[1] + direction * 100 - skill.startWallPosition) then
          POP.skillatk3_func_createWall(skill.startWallPosition + direction * 2 * wallWidth)
          skill.startWallPosition = skill.startWallPosition + direction * 2 * wallWidth
        end
      end
      if 0 < direction and casterX > ed.engine.stage_rect.maxX - 40 or direction < 0 and casterX < ed.engine.stage_rect.minX + 40 then
        caster.walk_v = {0, 0}
        skill:interrupt()
      end
    end
  end
end

function POP.skillatk3_interrupt(basefunc, skill)
  local caster = skill.caster
  caster.position[2] = skill.currentTargetY or skill.startY
  POP.skillatk3_func_changeUnitScale(caster, 1)
  if caster.POP_atk3_scaleBuff then
    caster.POP_atk3_scaleBuff.timer = 0
    caster.POP_atk3_scaleBuff = nil
  end
  basefunc(skill)
end

function POP.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  caster.height = 0
  if caster.actor then
    caster.actor.height = 0
  end
  caster.walk_v = {0, 0}
  if caster.POP_atk3_invulnerable then
    caster.POP_atk3_invulnerable.timer = 0
    caster.POP_atk3_invulnerable = nil
  end
  POP.skillatk2_func_resetBuffEffect(caster)
end

function POP.skillatk3b_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, POP.atk3_invulnerableBuff)
  local buff = caster:addBuff(binfo, caster)
  caster.POP_atk3_invulnerable = buff
end

function POP.skillatk3b_selectTarget(basefunc, skill, default)
  local target = basefunc(skill, default)
  if skill.lockTarget then
    skill.target = skill.lockTarget
  end
  return skill.target
end

function POP.skillatk3b_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.POP_atk3_invulnerable then
    caster.POP_atk3_invulnerable.timer = 0
    caster.POP_atk3_invulnerable = nil
  end
end

function POP.skillatk3b_takeEffectOn(basefunc, skill, target, source, shift)
  local tPos = skill.target and skill.target.position
  local cPos = skill.caster and skill.caster.position
  local maxRange = skill.info["Max Range"] and skill.info["Max Range"] + 70 or POP.atk3_attackRange + 70
  if not POP.isNearDest(tPos, cPos, maxRange) then
    return false
  else
    local hit, dmg, Crit = basefunc(skill, target, source, shift)
    local caster = skill.caster
    if hit and target:isAlive() then
      local alreadyBuff
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == POP.atk_sandBuff then
          alreadyBuff = tbuff
          break
        end
      end
      local coef = alreadyBuff and POP.atk3_extraDamageCoef2 or POP.atk3_extraDamageCoef1
      local losthp = target.attribs.HP * coef
      local lostHpMax = skill.info["Script Arg1"] or 0
      losthp = math.min(losthp, lostHpMax)
      target:takeDamage(losthp / caster.attribs.PDM, "Holy", "hp", skill.caster, 1, 1)
    end
    return hit, dmg, Crit
  end
end

function POP.skillatk3b_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.casting and skill == skill.caster.current_skill then
    local caster = skill.caster
    local duration = skill.current_phase_elapsed
    if duration <= POP.atk3_jumpBackTime then
      local scale = POP.atk3_scale + (1 - POP.atk3_scale) * (duration / POP.atk3_jumpBackTime)
      POP.skillatk3_func_changeUnitScale(caster, scale)
      local targetY = skill.targetY
      local atk3_moveY = POP.atk3_moveYRatio * ed.engine.stage_rect.maxY
      local curY = atk3_moveY - (atk3_moveY - targetY) * (duration / POP.atk3_jumpBackTime)
      caster.position[2] = curY
    end
  end
end

function POP.skillatk3b_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.position[2] = skill.targetY or caster.position[2]
  POP.skillatk3_func_changeUnitScale(caster, 1)
  if caster.POP_atk3_scaleBuff then
    caster.POP_atk3_scaleBuff.timer = 0
    caster.POP_atk3_scaleBuff = nil
  end
  if caster.POP_atk3_invulnerable then
    caster.POP_atk3_invulnerable.timer = 0
    caster.POP_atk3_invulnerable = nil
  end
  local attackCounter = skill.attack_counter or 0
  if attackCounter == 1 then
    local minX = ed.engine.stage_rect.minX
    local maxX = ed.engine.stage_rect.maxX
    local newPosition1 = math.max(minX, math.min(maxX, caster.position[1] + caster.direction * 70))
    caster.position[1] = newPosition1
  end
end

function POP.skillatk4_func_calculateValue(caster, position, useatk4)
  local skillatk2 = caster.skills[POP.name .. "_atk2"]
  local skillatk3 = caster.skills[POP.name .. "_atk3"]
  local hpRatio = caster.hp / caster.attribs.HP
  local value = 0
  local minX = ed.engine.stage_rect.minX
  local maxX = ed.engine.stage_rect.maxX
  if skillatk3 and 0 >= skillatk3.cd_remaining then
    local atk3Target = skillatk3:selectTarget(caster.ai.target)
    if POP.skillatk3_func_checkExtraCondition(atk3Target, position) then
      value = value + 5
    end
  elseif skillatk2 and 0 >= skillatk2.cd_remaining then
    if 0 >= skillatk2.wallModeCd and POP.skillatk2_wallMode_conditionFunc(skillatk2, position) then
      value = value + 4.2
      local nearCount = POP.func_countNearEnemy(caster, position, POP.atk2_wallMode_checkEnemyRange)
      value = value + nearCount * 1.3
    elseif 0 >= skillatk2.darkModeCd and POP.skillatk2_darkMode_conditionFunc(skillatk2, position) then
      value = value + 2.1
      local nearCount = POP.func_countNearEnemy(caster, position, POP.atk2_darkMode_checkEnemyRange)
      value = value + nearCount * 2
    elseif 0 >= skillatk2.aoeModeCd and POP.skillatk2_aoeMode_conditionFunc(skillatk2, position) then
      value = value + 1.5
      local nearCount = POP.func_countNearEnemy(caster, position, POP.atk2_aoeMode_checkEnemyRange)
      value = value + nearCount * 1.5
    elseif POP.skillatk2_normalMode_conditionFunc(skillatk2, position) then
      value = value + 2.8
    end
  end
  local ultBuff = caster.POP_ult_buff
  if ultBuff then
    local skillultb = caster.skills[POP.name .. "_ultb"]
    local maxRange = skillultb.info["Max Range"] or 0
    local nearCount = POP.func_countNearEnemy(caster, position, maxRange)
    value = value + nearCount * 0.55
  end
  do
    local enemyValue = 0
    if hpRatio >= POP.atk4_s_hpRatioPoint then
      enemyValue = POP.atk4_s_enemyValueMax * (hpRatio - POP.atk4_s_hpRatioPoint) / (1 - POP.atk4_s_hpRatioPoint)
    else
      enemyValue = POP.atk4_s_enemyValueMin * (hpRatio - POP.atk4_s_hpRatioPoint) / (0 - POP.atk4_s_hpRatioPoint)
    end
    local nearEnemy = POP.func_countNearEnemy(caster, position, POP.atk4_s_enemyCheckRange)
    value = value + nearEnemy * enemyValue
  end
  local tooNearCount = POP.func_countNearEnemy(caster, position, POP.atk4_s_tooNearRange)
  value = value + tooNearCount * -0.1
  return value
end

function POP.skillatk4_func_selectTargetPosition(skill)
  local caster = skill.caster
  if caster.clickTumblePosition then
    local tempPos = caster.clickTumblePosition
    local dir = ed.edpSub(caster.clickTumblePosition, caster.position)
    local newDir = {
      dir[1],
      dir[2]
    }
    local zoomRatioMax = math.huge
    local zoomRatioMin = 0
    if tempPos[1] > ed.engine.stage_rect.maxX - 50 then
      local zoomRatio = (ed.engine.stage_rect.maxX - 50 - caster.position[1]) / dir[1]
      zoomRatioMax = math.min(zoomRatioMax, zoomRatio)
    elseif tempPos[1] < ed.engine.stage_rect.minX + 50 then
      local zoomRatio = (ed.engine.stage_rect.minX + 50 - caster.position[1]) / dir[1]
      zoomRatioMax = math.min(zoomRatioMax, zoomRatio)
    end
    if tempPos[2] > ed.engine.stage_rect.maxY - 75 then
      local zoomRatio = (ed.engine.stage_rect.maxY - 75 - caster.position[2]) / dir[2]
      zoomRatioMax = math.min(zoomRatioMax, zoomRatio)
    elseif tempPos[2] < ed.engine.stage_rect.minY + 60 then
      local zoomRatio = (ed.engine.stage_rect.minY + 60 - caster.position[2]) / dir[2]
      zoomRatioMax = math.min(zoomRatioMax, zoomRatio)
    end
    local tempRangeSQ = ed.edpLengthSQ(dir)
    if tempRangeSQ > POP.atk4_maxTumbleRange * POP.atk4_maxTumbleRange then
      local zoomRatio = (POP.atk4_maxTumbleRange * POP.atk4_maxTumbleRange / tempRangeSQ) ^ 0.5
      zoomRatioMax = math.min(zoomRatioMax, zoomRatio)
    elseif tempRangeSQ < POP.atk4_minTumbleRange * POP.atk4_minTumbleRange then
      local zoomRatio = (POP.atk4_minTumbleRange * POP.atk4_minTumbleRange / tempRangeSQ) ^ 0.5
      zoomRatioMin = math.max(zoomRatioMin, zoomRatio)
    end
    local trueZoomRatio = 1
    if zoomRatioMax < zoomRatioMin then
      caster.clickTumblePosition = nil
      return nil
    elseif 1 <= zoomRatioMax and zoomRatioMin <= 1 then
      trueZoomRatio = 1
    elseif zoomRatioMax < 1 then
      trueZoomRatio = zoomRatioMax
    elseif 1 < zoomRatioMin then
      trueZoomRatio = zoomRatioMin
    end
    newDir = ed.edpMult(dir, trueZoomRatio)
    local trueTargetPos = ed.edpAdd(newDir, caster.position)
    return trueTargetPos
  end
  local cPos = caster.position
  local maxValue = -math.huge
  local targetPosList = {}
  for dx = -POP.atk4_maxTumbleRange, POP.atk4_maxTumbleRange, 40 do
    for dy = -30, 15, 15 do
      if dx * dx + dy * dy > POP.atk4_maxTumbleRange * POP.atk4_maxTumbleRange then
      elseif dx * dx + dy * dy < POP.atk4_minTumbleRange * POP.atk4_minTumbleRange then
      else
        local newPos = ed.edpAdd(cPos, {dx, dy})
        if newPos[1] > ed.engine.stage_rect.maxX - 50 or newPos[1] < ed.engine.stage_rect.minX + 50 then
        elseif newPos[2] < ed.engine.stage_rect.minY + 60 or newPos[2] > ed.engine.stage_rect.maxY - 90 then
        else
          local value = POP.skillatk4_func_calculateValue(caster, newPos, true)
          if value == maxValue then
            table.insert(targetPosList, newPos)
          elseif maxValue < value then
            targetPosList = {}
            table.insert(targetPosList, newPos)
            maxValue = value
          end
        end
      end
    end
  end
  local n = #targetPosList
  if 0 < n then
    local rand_i = math.floor(ed.rand() * n) + 1
    return targetPosList[rand_i]
  else
    return nil
  end
end

function POP.skillatk4_willCast(basefunc, skill)
  local caster = skill.caster
  local touchPosition = caster.clickTumblePosition
  if caster.name == "POP" and not caster.ai.will_cast_manual_skill and (not touchPosition or next(touchPosition) == nil) then
    return false
  end
  if ed.run_with_scene and caster.name == "POP" and ed.scene.auto_combat and caster.current_skill then
    return false
  end
  return true
end

function POP.skillatk4_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local targetPos = POP.skillatk4_func_selectTargetPosition(skill)
    if targetPos then
      skill.defaultTargetPos = targetPos
    else
      return false, "no target Position"
    end
  end
  return canUse, reason
end

function POP.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local tumbleTargetPosition = POP.skillatk4_func_selectTargetPosition(skill)
  tumbleTargetPosition = tumbleTargetPosition or skill.defaultTargetPos
  skill.tumbleTargetPosition = tumbleTargetPosition
  local tumbleRange = ed.edpDistanceSQ(skill.tumbleTargetPosition, caster.position) ^ 0.5
  if tumbleRange < (POP.atk4_maxTumbleRange * 1 + POP.atk4_minTumbleRange * 2) / 3 then
    skill.tumbleCircle = 1
  else
    skill.tumbleCircle = 2
  end
  if (tumbleTargetPosition[1] - caster.position[1]) * caster.direction < 0 then
    caster.direction = -caster.direction
  end
  local tumbleStartPosition = caster.position
  local direction = ed.edpSub(tumbleTargetPosition, tumbleStartPosition)
  local time = POP.atk4_timeOneCircle * skill.tumbleCircle
  skill.tumbleSpeed1 = ed.edpMult(direction, 1 / time)
  skill.tumbleSpeed2 = ed.edpMult(direction, 1 / time)
  local addDodg = skill.info["Script Arg1"] or 0
  local binfo = ed.lookupDataTable("Buff", nil, POP.atk4_dodgBuffId)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("DODG", addDodg)
  local addbuff = caster:addBuff(buff, caster)
  caster.POP_atk4_buff = addbuff
  caster.clickTumblePosition = nil
  skill.willAddBuff = true
end

function POP.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.tumbleCircle == 1 then
    skill:finish()
  end
end

function POP.skillatk4_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.casting and skill == skill.caster.current_skill then
    local caster = skill.caster
    local time = skill.current_phase_elapsed + dt_action
    if time <= POP.atk4_timePoint1 then
      caster.walk_v = skill.tumbleSpeed1 or {0, 0}
    elseif time < skill.current_phase.duration then
      caster.walk_v = skill.tumbleSpeed2 or {0, 0}
    else
      caster.walk_v = {0, 0}
      skill:finish()
    end
  end
end

function POP.skillatk4_interrupt(basefunc, skill)
  skill.willAddBuff = false
  basefunc(skill)
end

function POP.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  skill.defaultTargetPos = nil
  caster.clickTumblePosition = nil
  if caster.POP_atk4_buff then
    caster.POP_atk4_buff.timer = 0
    caster.POP_atk4_buff = nil
  end
  if skill.willAddBuff then
    local addAd = skill.info["Script Arg2"] or 0
    local binfo = ed.lookupDataTable("Buff", nil, POP.atk4_powerupBuffId)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.willAddAd = addAd
    local addbuff = caster:addBuff(buff, caster)
    caster.POP_atk4_adBuff = addbuff
  end
  local reduceCd = math.min(skill.saveCd, POP.atk4_maxSaveCd)
  skill.cd_remaining = skill.cd_remaining - reduceCd
  skill.saveCd = 0
end

function POP.skillult_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  local caster = skill.caster
  if canUse and caster.mp < POP.ult_useMpCondition then
    return false, "mp not enough"
  end
  if canUse and caster.POP_ult_buff then
    return false, "using"
  end
  return canUse, reason
end

function POP.skillultb_func_countNearEnemy(skill)
  local caster = skill.caster
  local count = 0
  local range = skill.info["Shape Arg1"] or 0
  for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
    if enemy.buff_effects.invulnerable then
    else
      local virtualPos = POP.getVirtualPosition(caster)
      if not POP.isNearDest(virtualPos, enemy.position, POP.atk2_aoeMode_checkEnemyRange) then
      else
        count = count + 1
      end
    end
  end
  return count
end

function POP.skillult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.POP_ult_useSandCd = buff.POP_ult_useSandCd - dt
  local caster = buff.caster
  local owner = buff.owner
  if buff.POP_ult_useSandCd <= 0 and caster == owner then
    local skillatk3 = caster.skills[POP.name .. "_atk3"]
    if skillatk3 and skillatk3.casting and skillatk3 == skillatk3.caster.current_skill and skillatk3.climbPhase == 2 then
    else
      local scaleBuff = caster.POP_atk3_scaleBuff
      if scaleBuff and scaleBuff.info["Actor Scale"] and scaleBuff.info["Actor Scale"][1] <= 0.95 then
      else
        local virtualPos = POP.getVirtualPosition(caster)
        local skillultb = caster.skills[POP.name .. "_ultb"]
        if skillultb and 0 >= POP.skillultb_func_countNearEnemy(skillultb) then
        elseif caster.mp < POP.ult_useSandCost then
          buff.timer = 0
          owner:removeBuff(buff)
        else
          skillultb:takeEffectAt(virtualPos)
          caster:setMP(caster.mp - POP.ult_useSandCost)
          buff.POP_ult_useSandCd = POP.ult_useSandCd
        end
      end
    end
  end
end

function POP.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.POP_ult_buff = nil
  if ed.run_with_scene and buff.caster.name == "POP" then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
end

function POP.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.POP_ult_buff = nil
end

function POP.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.POP_ult_useSandCd = 0.125
  buff.update = override(buff.update, POP.skillult_buff_update)
  buff.onRemoved = override(buff.onRemoved, POP.skillult_buff_onRemoved)
  local caster = skill.caster
  caster.POP_ult_buff = buff
  if ed.run_with_scene and buff.caster.name == "POP" then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  return buff
end

function POP.skillultb_takeEffectOn(basefunc, skill, target, source, shift)
  local alreadyBuff
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == POP.atk_sandBuff then
      alreadyBuff = tbuff
      break
    end
  end
  local originInfo = skill.info
  if alreadyBuff then
    skill.info = ed.wraptable(originInfo, {
      ["Damage Type"] = "AP"
    })
  end
  local hit, dmg, Crit = basefunc(skill, target, source, shift)
  skill.info = originInfo
  if hit then
    POP.addSandBuff(target, POP.ult_sandTime, skill)
  end
  return hit, dmg, Crit
end

function POP.skillawake_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local caster = skill.caster
    if caster.darkenedAlready then
      return false, "darkened already"
    end
    if not caster.darkenedPercent or caster.darkenedPercent < POP.awake_darkenCondition then
      return false, "darkened not enough"
    end
  end
  return canUse, reason
end

function POP.skillawake_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, POP.awake_uncontrollableBuffId)
  local buff = caster:addBuff(binfo, caster)
  caster.POP_awake_uncontrollable = buff
end

function POP.skillawake_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.darkenedAlready = true
  caster:enterActionStageFromOneStage(3, 10044)
  if caster.POP_awake_uncontrollable then
    caster.POP_awake_uncontrollable.timer = 0
    caster.POP_awake_uncontrollable = nil
  end
  if ed.run_with_scene and caster.name == POP.name then
    local panel = caster.heroPanel
    if panel then
      local pic = POP.awake_panel
      if pic then
        panel:setPortrait(pic)
      end
    end
  end
  if caster.awake_damageObserveRegion then
    caster.awake_damageObserveRegion:finish()
    caster.awake_damageObserveRegion = nil
  end
  local binfo = ed.lookupDataTable("Buff", nil, POP.awake_powerupBuffId)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local addAD = skill.info["Script Arg1"] or 0
  buff:setAttribute("AD", addAD)
  local lostHp = -caster.attribs.HP * POP.awake_powerupBuffLostHpCoef
  buff:setAttribute("HPR", lostHp)
  caster:addBuff(buff, caster)
  if buff.effect_id then
    local effect = buff.owner.actor:getEffectById(buff.effect_id)
    local scaleX = effect:getScaleX()
    local scaleY = effect:getScaleY()
    effect:setScaleX(scaleX * 0.75)
    effect:setScaleY(scaleY * 0.75)
  end
  caster.POP_awake_powerupBuff = buff
end

function POP.skillawakeb_func_damageToDark(lostHpPercent, fixCoef)
  local lostHpPerc = math.min(math.max(lostHpPercent, 0), POP.awakeb_maxAddNeedLostHp)
  local fixCoef = fixCoef and fixCoef or 1
  local add = lostHpPercent / POP.awakeb_maxAddNeedLostHp * (POP.awakeb_maxAdd - POP.awakeb_minAdd) + POP.awakeb_minAdd
  add = add * fixCoef
  return add
end

function POP.skillawakeb_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
  local owner = buff.owner
  local caster = buff.caster
  if caster:isAlive() and caster.name == POP.name and caster.darkenedPercent then
    local immunity
    if damage_type == "AD" then
      immunity = owner.attribs.PIMU or 0
    elseif damage_type == "AP" then
      immunity = owner.attribs.MIMU or 0
    elseif damage_type == "Holy" then
      immunity = 0
    else
      EDDebug("Unknown Damage Type '" .. damage_type .. "'")
    end
    immunity = immunity + owner.attribs.ALLIMU
    local dmgAfterImmunity = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
    local lostPercent = dmgAfterImmunity / owner.attribs.HP
    if owner == caster then
      caster.darkenedPercent = caster.darkenedPercent + POP.skillawakeb_func_damageToDark(lostPercent)
    end
    if owner ~= caster and owner.info.Gender == T("\229\165\179") then
      caster.darkenedPercent = caster.darkenedPercent + POP.skillawakeb_func_damageToDark(lostPercent, POP.awakeb_fixCoef)
    end
  end
  return damage
end

function POP.skillawakeb_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, POP.skillawakeb_buff_onDamaged)
  return buff
end

function POP.canTouchRespond(basefunc, unit)
  local canGet = false
  local skillatk4 = unit.skills[POP.name .. "_atk4"]
  if unit.camp ~= ed.emCampPlayer then
  elseif unit.ai.will_cast_manual_skill then
  elseif unit.name ~= POP.name then
  elseif unit.config.is_summoned then
  elseif not skillatk4 then
  elseif not unit:isAlive() then
  elseif skillatk4.cd_remaining > 0 then
  elseif unit.buff_effects.stun then
  elseif unit.buff_effects.disarm then
  elseif unit.buff_effects.silence then
  elseif unit.buff_effects.doom then
  elseif unit.buff_effects.unmanual then
  elseif battle_tick.getRealTimePvp() and ed.engine.freeze_camp and unit.camp ~= ed.engine.freeze_camp then
  else
    local ult = unit.skills[POP.name .. "_ult"]
    local atk3 = unit.skills[POP.name .. "_atk3"]
    local atk3b = unit.skills[POP.name .. "_atk3b"]
    local awake = unit.skills[POP.name .. "_awake"]
    if unit.current_skill then
      if unit.current_skill == ult then
      elseif unit.current_skill == atk3 then
      elseif unit.current_skill == skillatk4 then
      elseif unit.current_skill == atk3b then
      elseif unit.current_skill == awake then
      else
        canGet = true
      end
    end
  end
  if canGet then
    return 1
  end
  return canGet
end

function POP.touchPositionHandler(basefunc, unit, pos)
  basefunc(unit, pos)
  if type(pos) == "table" then
    unit.clickTumblePosition = {}
    unit.clickTumblePosition[1] = pos[1]
    unit.clickTumblePosition[2] = pos[2]
  end
  POP.skillatk3_func_changeUnitScale(unit, 1)
  if unit.POP_atk3_scaleBuff then
    unit.POP_atk3_scaleBuff.timer = 0
    unit.POP_atk3_scaleBuff = nil
  end
  if unit.current_skill then
    unit.current_skill:interrupt()
  end
  local atk4 = unit.skills[POP.name .. "_atk4"]
  if atk4:canCastWithTarget(unit) then
    unit:castSkill(atk4, unit)
  end
end

function POP.castManualSkill(basefunc, unit)
  if unit.name == POP.name then
    local skillatk4 = unit.skills[POP.name .. "_atk4"]
    local skillult = unit.skills[POP.name .. "_ult"]
    POP.skillatk3_func_changeUnitScale(unit, 1)
    if unit.POP_atk3_scaleBuff then
      unit.POP_atk3_scaleBuff.timer = 0
      unit.POP_atk3_scaleBuff = nil
    end
    if unit.current_skill then
      unit.current_skill:interrupt()
    end
    if skillult and skillult:canCastWithTarget(unit.ai.target) then
      basefunc(unit)
    elseif skillatk4 and skillatk4:canCastWithTarget(unit) then
      unit:castSkill(skillatk4, unit)
    end
  else
    basefunc(unit)
  end
end

function POP.listener_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local unit = buff.caster
  if unit:isAlive() and unit.darkenedAlready then
    unit:enterActionStageFromOneStage(2, 10044)
    if ed.run_with_scene and unit.name == POP.name then
      local panel = unit.heroPanel
      if panel then
        local pic = "UI/DOTA-HERO/SwitchPOP.jpg"
        if pic then
          panel:setPortrait(pic)
        end
      end
    end
  end
end

function POP.actor_update(basefunc, actor, dt)
  local unit = actor.model
  local skillatk3 = unit.skills[POP.name .. "_atk3"]
  if skillatk3 and skillatk3.casting and skillatk3 == skillatk3.caster.current_skill and skillatk3.climbPhase == 2 then
    actor.height = unit.height
  end
  basefunc(actor, dt)
end

function POP.reset(basefunc, unit)
  basefunc(unit)
  unit.alreadyOverrideActor = nil
  unit.clickTumblePosition = nil
  unit.POP_ult_buff = nil
  if unit.name == "POP" and not unit.config.is_summoned then
    local deltaX = unit:getInitDir() >= 0 and -100 or 100
    unit.position[1] = unit.position[1] + deltaX
  end
  if not unit.battleEndListenerBuff and unit.name == "POP" then
    local binfo = ed.lookupDataTable("Buff", nil, POP.emptyBuffID)
    local buff = unit:addBuff(binfo, unit)
    unit.battleEndListenerBuff = buff
    if buff then
      buff.onRemoved = override(buff.onRemoved, POP.listener_buff_onRemoved)
    end
  end
  local skillatk2 = unit.skills[POP.name .. "_atk2"]
  if skillatk2 then
    skillatk2.aoeModeCd = POP.atk2_aoeMode_cd - 3
    skillatk2.wallModeCd = POP.atk2_wallMode_cd - 7
    skillatk2.darkModeCd = POP.atk2_darkMode_cd
  end
  local skillatk4 = unit.skills[POP.name .. "_atk4"]
  if skillatk4 then
    skillatk4.saveCd = 0
  end
  if ed.protoAwake(unit.proto, 10044) then
    if POP.classicalFashionId and POP.classicalFashionId == unit.fashion_id then
      unit:enterActionStageFromOneStage(1, 10044)
    else
      unit:enterActionStageFromOneStage(2, 10044)
    end
  else
    unit:enterActionStageFromOneStage(1, 10044)
  end
  local skillawake = unit.skills[POP.name .. "_awake"]
  if skillawake then
    unit.darkenedPercent = 0
    unit.darkenedPhase = 0
    unit.darkenedAlready = false
    unit.alreadyCreateRegion = false
  end
end

function POP.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local actor = unit.actor
  if actor and not unit.alreadyOverrideActor then
    unit.alreadyOverrideActor = true
    actor.update = override(actor.update, POP.actor_update)
  end
  local skillatk4 = unit.skills[POP.name .. "_atk4"]
  local skillatk3 = unit.skills[POP.name .. "_atk3"]
  local skillatk3b = unit.skills[POP.name .. "_atk3b"]
  local skillawake = unit.skills[POP.name .. "_awake"]
  local skillatk2 = unit.skills[POP.name .. "_atk2"]
  local skillult = unit.skills[POP.name .. "_ult"]
  if not (unit.name == "POP" and not unit.config.is_summoned and skillatk4 and unit:isAlive() and skillatk4:canCastWithTarget(unit)) or unit.current_skill and (unit.current_skill == skillult or unit.current_skill == skillatk3 or unit.current_skill == skillatk3b or unit.current_skill == skillawake or unit.current_skill == skillatk4) or ed.run_with_scene and ed.scene.auto_combat and unit.current_skill then
  else
    unit.can_cast_manual = true
  end
  local skillawakeb = unit.skills[POP.name .. "_awakeb"]
  if skillawakeb and not unit.alreadyCreateRegion then
    unit.alreadyCreateRegion = true
    skillawakeb.target = unit
    local region = skillawakeb:createRegion()
    unit.awake_damageObserveRegion = region
    ed.engine:addRegion(region)
  end
  local skillatk4 = unit.skills[POP.name .. "_atk4"]
  if skillatk4 and skillatk4.cd_remaining <= 0 and unit:isAlive() then
    skillatk4.saveCd = skillatk4.saveCd + dt
  end
  local skillawake = unit.skills[POP.name .. "_awake"]
  if skillawake and unit:isAlive() and unit.darkenedPercent and not unit.darkenedAlready then
    unit.darkenedPercent = unit.darkenedPercent + dt * POP.awake_darkenedSpeed
    for phaseIndex, phaseInfo in ipairs(POP.awake_darkenedPhaseEffectList) do
      if phaseIndex <= unit.darkenedPhase then
      elseif phaseInfo[1] <= unit.darkenedPercent then
        unit.darkenedPhase = phaseIndex
        local skillatk2 = unit.skills[POP.name .. "_atk2"]
        if skillatk2 == skillatk2.caster.current_skill then
          if ed.run_with_scene then
            local effect_name = phaseInfo[2]
            local pos = POP.getVirtualPosition(unit)
            if effect_name then
              ed.scene:playEffectOnScene(effect_name, pos, {1, 1}, nil, 1)
            end
          end
        else
          local binfo = ed.lookupDataTable("Buff", nil, POP.awake_darkenedPhaseBuff)
          local buff = unit:addBuff(binfo, unit)
        end
      end
    end
  end
end

function POP.die(basefunc, hero, killer)
  if hero.awake_damageObserveRegion then
    hero.awake_damageObserveRegion:finish()
    hero.awake_damageObserveRegion = nil
  end
  if ed.run_with_scene and not hero.config.is_summoned then
    local effect_name = POP.dieWordEffect
    if effect_name then
      local pos = {}
      pos[1] = hero.position[1]
      pos[2] = hero.position[2]
      if hero.direction < 0 then
        pos[1] = hero.position[1] - 90
      end
      ed.scene:playEffectOnScene(effect_name, pos, {1, 1}, nil, 0)
    end
  end
  basefunc(hero, killer)
end

function POP.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, POP.reset)
  hero.update = override(hero.update, POP.update)
  hero.die = override(hero.die, POP.die)
  hero.castManualSkill = override(hero.castManualSkill, POP.castManualSkill)
  hero.canTouchRespond = override(hero.canTouchRespond, POP.canTouchRespond)
  hero.touchPositionHandler = override(hero.touchPositionHandler, POP.touchPositionHandler)
  local skillatk2 = hero.skills[POP.name .. "_atk2"]
  if skillatk2 then
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, POP.skillatk2_canCastWithTarget)
    skillatk2.start = override(skillatk2.start, POP.skillatk2_start)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, POP.skillatk2_onPhaseFinished)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, POP.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, POP.skillatk2_takeEffectOn)
    skillatk2.update = override(skillatk2.update, POP.skillatk2_update)
    skillatk2.finish = override(skillatk2.finish, POP.skillatk2_finish)
  end
  local skillatk2c = hero.skills[POP.name .. "_atk2c"]
  if skillatk2c then
    skillatk2c.createProjectile = override(skillatk2c.createProjectile, POP.skillatk2c_createProjectile)
  end
  local skillatk3 = hero.skills[POP.name .. "_atk3"]
  local skillatk3b = hero.skills[POP.name .. "_atk3b"]
  if skillatk3 and skillatk3b then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, POP.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, POP.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, POP.skillatk3_onAttackFrame)
    skillatk3.update = override(skillatk3.update, POP.skillatk3_update)
    skillatk3.finish = override(skillatk3.finish, POP.skillatk3_finish)
    skillatk3.interrupt = override(skillatk3.interrupt, POP.skillatk3_interrupt)
    skillatk3b.start = override(skillatk3b.start, POP.skillatk3b_start)
    skillatk3b.selectTarget = override(skillatk3b.selectTarget, POP.skillatk3b_selectTarget)
    skillatk3b.onAttackFrame = override(skillatk3b.onAttackFrame, POP.skillatk3b_onAttackFrame)
    skillatk3b.takeEffectOn = override(skillatk3b.takeEffectOn, POP.skillatk3b_takeEffectOn)
    skillatk3b.update = override(skillatk3b.update, POP.skillatk3b_update)
    skillatk3b.finish = override(skillatk3b.finish, POP.skillatk3b_finish)
  end
  local skillatk4 = hero.skills[POP.name .. "_atk4"]
  if skillatk4 then
    skillatk4.willCast = override(skillatk4.willCast, POP.skillatk4_willCast)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, POP.skillatk4_canCastWithTarget)
    skillatk4.start = override(skillatk4.start, POP.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, POP.skillatk4_onAttackFrame)
    skillatk4.update = override(skillatk4.update, POP.skillatk4_update)
    skillatk4.interrupt = override(skillatk4.interrupt, POP.skillatk4_interrupt)
    skillatk4.finish = override(skillatk4.finish, POP.skillatk4_finish)
  end
  local skillult = hero.skills[POP.name .. "_ult"]
  local skillultb = hero.skills[POP.name .. "_ultb"]
  if skillult and skillultb then
    skillult.start = override(skillult.start, POP.skillult_start)
    skillult.createBuff = override(skillult.createBuff, POP.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, POP.skillult_canCastWithTarget)
    skillultb.takeEffectOn = override(skillultb.takeEffectOn, POP.skillultb_takeEffectOn)
  end
  local skillawake = hero.skills[POP.name .. "_awake"]
  local skillawakeb = hero.skills[POP.name .. "_awakeb"]
  if skillawake and skillawakeb then
    skillawake.canCastWithTarget = override(skillawake.canCastWithTarget, POP.skillawake_canCastWithTarget)
    skillawake.start = override(skillawake.start, POP.skillawake_start)
    skillawake.finish = override(skillawake.finish, POP.skillawake_finish)
    skillawakeb.createBuff = override(skillawakeb.createBuff, POP.skillawakeb_createBuff)
  end
  return hero
end

return POP.init_hero
