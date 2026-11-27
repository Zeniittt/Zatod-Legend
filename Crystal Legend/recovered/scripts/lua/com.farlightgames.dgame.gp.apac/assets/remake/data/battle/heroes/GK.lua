module("ed.battlehero", package.seeall)
local ed = ed
GK = {}
GK.name = "GK"
GK.changeDirDeltaX = 30
GK.interruptEffectList = {
  "parasitism",
  "derangedOwner",
  "stun",
  "disarm",
  "taunt",
  "doom",
  "polymorph",
  "frozen",
  "icefrozen",
  "imprisonment"
}
GK.interruptProtectList = {
  "doom",
  "parasitism",
  "derangedOwner"
}
GK.scaleCoef = 0.6
GK.atk2_teammate_reduceDamageCoef = -0.15
GK.atk2_enemy_extraDamageCoef = 0.1
GK.atk2_cd = 3.5
GK.atk2_highEffectCondition = 0.2
GK.atk2_distanceCondition = 100
GK.atk2d_distanceCondition = 170
GK.awake_coefRatio = 2
GK.atk3_knockCoefMax = 4
GK.atk3_knockCoefMaxTime = 20
GK.atk4_teammateBuff = 910
GK.atk4_selfUncontrollableBuff = 911
GK.atk4_selfInvisibleBuff = 908
GK.atk4_protectLeftBuff = 906
GK.atk4_protectRightBuff = 907
GK.atk4_protectLogicBuff = 912
GK.atk4_deltaX = 65
GK.atk4_protectReduceDamage = 50
GK.atk4_protectMaxMoveRange = 25
GK.atk4_walkSpeedCoef = 0.6
GK.enterBuffId_invisible = 915
GK.enterBuffId_stable = 914
GK.ult_absorbLevelCoef = 0.07
GK.ult_absorbLevelZeroBuff = 916
GK.ult_maxLevel = 4
GK.ult_stunBuffId = 913
GK.awake_defenceTileHeight = 999
GK.awake_reboundEffect = "eff_point_GK_awake_tileRebound.cha"
GK.awake_reboundChance = 1
GK.awake_reboundTileMaxPower = 100000
GK.awake_reboundDeltaX = 55
GK.awake_knockHeroDistance = 30

function GK.addAbsorbDamage(unit, amount)
  if unit.ult_absorbDamage and unit.name == GK.name and not unit.config.is_summoned and 0 <= amount then
    unit.ult_absorbDamage = unit.ult_absorbDamage + amount
  end
  return unit.ult_absorbDamage
end

function GK.defenceBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
  if ed.run_with_scene then
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
    local sourceHero = source and source.caster or source
    if sourceHero and sourceHero.position and 0 < owner.direction * (sourceHero.position[1] - owner.position[1]) and ed.run_with_scene then
      local effectName = "eff_impact_GK_atk2_1.cha"
      if dmgAfterImmunity > owner.attribs.HP * GK.atk2_highEffectCondition then
        effectName = "eff_impact_GK_atk2_2.cha"
      end
      local pos = owner.position
      local scaleX = 0 <= owner.direction and 1 or -1
      ed.scene:playEffectOnScene(effectName, pos, {
        GK.scaleCoef * scaleX,
        GK.scaleCoef
      }, owner.height, 1, nil, nil, nil)
    end
  end
  return damage
end

function GK.defenceBuff_onRemoved(basefunc, buff)
  local owner = buff.owner
  basefunc(buff)
  if owner.name == GK.name and owner.awake_uncontrollableBuff then
    owner.awake_uncontrollableBuff.timer = 0
    owner.awake_uncontrollableBuff = nil
  end
end

function GK.func_hideBuffEffect(unit)
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

function GK.func_resetBuffEffect(unit)
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

function GK.atk2_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local caster = skill.caster
    if caster.atk2_defenceModeBuff then
      return false, "already defence mode"
    end
    local nearEnemy = false
    for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
      local distanceSQ = ed.edpDistanceSQ(enemy.position, caster.position)
      if distanceSQ <= GK.atk2_distanceCondition ^ 2 then
        nearEnemy = true
        break
      end
    end
    if not nearEnemy then
      return false, "no near enemy "
    end
  end
  return canUse, reason
end

function GK.atk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local enemyRightMinusLeft = 0
  for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
    local value = 1
    if enemy.config.is_summoned then
      value = 0.45
    end
    if enemy.position[1] >= caster.position[1] then
      enemyRightMinusLeft = enemyRightMinusLeft + value
    else
      enemyRightMinusLeft = enemyRightMinusLeft - value
    end
  end
  if 0 > caster.direction * enemyRightMinusLeft then
    caster.direction = -caster.direction
  end
  caster.GK_atk2_lockDirection = caster.direction
end

function GK.atk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local atk2e = caster.skills[GK.name .. "_atk2e"]
  if atk2e then
    atk2e:takeEffectAt(caster.position)
  end
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
  end
end

function GK.atk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.onDamaged = override(buff.onDamaged, GK.defenceBuff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, GK.defenceBuff_onRemoved)
  if caster.atk2_defenceModeBuff then
    caster.atk2_defenceModeBuff.timer = 0
    caster.atk2_defenceModeBuff = nil
  end
  caster.atk2_defenceModeBuff = buff
  return buff
end

function GK.atk2_finish(basefunc, skill)
  local caster = skill.caster
  local notInterrupted = skill.attack_counter >= 1 and true or false
  basefunc(skill)
  if notInterrupted then
    caster:enterActionStageFromOneStage(caster:getDefencePeriod(), 10048)
  end
end

function GK.atk3_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local caster = skill.caster
    local direction = caster.direction
    local origin = {
      caster.position[1] + skill.info["X Shift"] * direction,
      caster.position[2]
    }
    local effectTargetList = skill:collectAoeTarget(origin, direction)
    if type(effectTargetList) ~= "table" or next(effectTargetList) == nil then
      return false, "no enemy in aoe shape"
    end
  end
  return canUse, reason
end

function GK.atk3_onAttackFrame(basefunc, skill)
  local originInfo = skill.info
  if skill.attack_counter == 3 then
    local extraDamage = skill.info["Script Arg1"] or 0
    skill.info = ed.wraptable(originInfo, {
      ["Basic Num"] = extraDamage,
      ["Plus Ratio"] = 1,
      ["Knock Back"] = 30,
      ["Knock Up"] = 0.2
    })
  end
  basefunc(skill)
  skill.info = originInfo
end

function GK.atk3_takeEffectOn(basefunc, skill, target, source, shift)
  local originInfo = skill.info
  local caster = skill.caster
  if skill.attack_counter == 4 then
    local extraKnockCoef = math.abs(target.position[1] - caster.position[1]) <= 70 and 2 or 1
    local originKnock = skill.info["Knock Back"]
    if caster.direction * originKnock * (target.position[1] - caster.position[1]) < 0 then
      extraKnockCoef = -extraKnockCoef
    end
    skill.info = ed.wraptable(originInfo, {
      ["Knock Back"] = extraKnockCoef * originKnock
    })
  end
  local hit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  skill.info = originInfo
  return hit, dmg, Crit, lfs_amount
end

function GK.atk4b_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
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
  local targetCamp = caster.originCamp or caster.camp
  if caster ~= owner and owner.camp == targetCamp and not owner.controlledTarget then
    local maxDamage = owner.hp - 1
    if dmgAfterImmunity <= maxDamage then
      return dmgAfterImmunity
    elseif dmgAfterImmunity > maxDamage and caster.GK_canUseAtk4 and caster.name == GK.name and not caster.config.is_summoned and not owner.config.is_summoned and caster.current_skill ~= caster.manual_skill and not caster.buff_effects.doom and owner.info["Main Attrib"] == "INT" and (owner.info.ID <= 100 or owner.info.ID > 10000) then
      caster.GK_canUseAtk4 = false
      local atk4 = caster.skills[GK.name .. "_atk4"]
      if atk4 then
        caster:unfreeze()
        if caster.current_skill then
          caster.current_skill:interrupt()
        end
        if 0 > (owner.position[1] - caster.position[1]) * caster.direction then
          caster.direction = -caster.direction
        end
        for _, tbuff in ipairs(caster.buff_list) do
          local willBeRemove = tbuff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("derangedOwner", tbuff.info["Control Effects"])
          if willBeRemove then
            tbuff.timer = -1
          end
        end
        local defenceBuff = caster.atk2_defenceModeBuff
        if defenceBuff then
          caster:enterActionStageFromOneStage(caster:getNormalPeriod(), 10048)
          caster:removeBuff(defenceBuff)
          caster.atk2_defenceModeBuff = nil
        end
        local sourceHero = source and source.caster or source
        atk4.rescueTarget = owner
        if sourceHero and sourceHero.position then
          atk4.rescueDirection = sourceHero.position[1] >= owner.position[1] and "right" or "left"
        end
        local binfo = ed.lookupDataTable("Buff", nil, GK.atk4_selfUncontrollableBuff)
        local buff = caster:addBuff(binfo, caster)
        caster.atk4_uncontrollableBuff = buff
        caster:castSkill(atk4, owner)
      end
      local binfo = ed.lookupDataTable("Buff", nil, GK.atk4_teammateBuff)
      local buff = ed.BuffCreate(binfo, owner, caster)
      buff:setAttribute("ALLIMU", 99999)
      buff = owner:addBuff(buff, caster)
      atk4.teammateBuff = buff
      if caster.atk4_region then
        caster.atk4_region:finish()
        caster.atk4_region = nil
      end
      damage = maxDamage
      return damage
    end
  end
  return damage
end

function GK.atk4b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, GK.atk4b_buff_onDamaged)
  return buff
end

function GK.atk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
end

function GK.atk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.rescueTarget then
    skill.target = skill.rescueTarget
  end
  local target = skill.target
  local oriInfo = skill.info
  if skill.attack_counter == 0 then
    local deltaX = skill.rescueDirection and skill.rescueDirection == "right" and GK.atk4_deltaX or -GK.atk4_deltaX
    local maxX = ed.engine.stage_rect.maxX
    local minX = ed.engine.stage_rect.minX
    caster.position[1] = math.min(maxX, math.max(minX, target.position[1] + deltaX))
    caster.position[2] = target.position[2] - 1
    if 0 > caster.direction * deltaX then
      caster.direction = -caster.direction
    end
  elseif skill.attack_counter == 1 then
    skill.info = ed.wraptable(oriInfo, {
      ["Damage Type"] = "AD",
      ["Knock Up"] = 0.2,
      ["Knock Back"] = 75,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 200,
      ["Point Effect"] = "eff_point_SK_ult.cha"
    })
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(10, 0.3, 5)
    end
    if skill.teammateBuff then
      local owner = skill.teammateBuff.owner
      owner:removeBuff(skill.teammateBuff)
      skill.teammateBuff = nil
    end
    local target = target
    local buff
    if target:isAlive() then
      local binfo = ed.lookupDataTable("Buff", nil, GK.atk4_selfInvisibleBuff)
      buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("ALLIMU", GK.atk4_protectReduceDamage)
      buff = caster:addBuff(buff, caster)
    else
      if caster.atk4_logicBuff then
        caster.atk4_logicBuff = nil
        caster.atk4_logicBuff.timer = -1
        caster.atk4_logicBuff.owner:removeBuff(caster.atk4_logicBuff)
      end
      if caster.atk4_invisibleBuff then
        caster.atk4_invisibleBuff = nil
        caster.atk4_invisibleBuff.timer = -1
        caster.atk4_invisibleBuff.owner:removeBuff(caster.atk4_invisibleBuff)
      end
      return basefunc(skill)
    end
    if buff then
      buff.onDamaged = override(buff.onDamaged, GK.atk4_invBuff_onDamaged)
      buff.onRemoved = override(buff.onRemoved, GK.atk4_invBuff_onRemoved)
      caster.atk4_invisibleBuff = buff
      buff.guardDirection = skill.rescueDirection
      local enemyRightMinusLeft = buff.guardDirection == "right" and 1 or -1
      for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
        local value = 1
        if enemy.config.is_summoned then
          value = 0.45
        end
        if enemy.position[1] >= target.position[1] then
          enemyRightMinusLeft = enemyRightMinusLeft + value
        else
          enemyRightMinusLeft = enemyRightMinusLeft - value
        end
      end
      if enemyRightMinusLeft < 0 and buff.guardDirection == "right" then
        buff.guardDirection = "left"
      elseif 0 < enemyRightMinusLeft and buff.guardDirection == "left" then
        buff.guardDirection = "right"
      end
      caster.GK_origin_walk_speed_multiplier = caster.walk_speed_multiplier
      caster.walk_speed_multiplier = GK.atk4_walkSpeedCoef
    end
    local binfo = ed.lookupDataTable("Buff", nil, GK.atk4_protectLogicBuff)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff = target:addBuff(buff, caster)
    if buff then
      local protectTime = skill.info["Script Arg1"]
      if protectTime then
        buff.timer = protectTime
      end
      buff.ownerPerviousPositionX = target.position[1]
      buff.onDamaged = override(buff.onDamaged, GK.atk4_logicBuff_onDamaged)
      buff.update = override(buff.update, GK.atk4_logicBuff_update)
      buff.onRemoved = override(buff.onRemoved, GK.atk4_logicBuff_onRemoved)
      caster.atk4_logicBuff = buff
    end
  end
  basefunc(skill)
  skill.info = oriInfo
end

function GK.atk4_logicBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
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
  if caster ~= owner and not transferred then
    caster:takeDamage(dmgAfterImmunity, "Holy", "hp", source, nil, 0, true)
    local sourceHero = source and source.caster or source
    local name = "eff_impact_GK_atk4.cha"
    if ed.run_with_scene and sourceHero and sourceHero.position then
      local dir = sourceHero.position[1] >= owner.position[1] and -1 or 1
      if 0 <= (caster.position[1] - owner.position[1]) * dir then
        local effectPos = {
          owner.position[1] + 80 * dir,
          owner.position[2]
        }
        ed.scene:playEffectOnScene(name, effectPos, {
          dir * GK.scaleCoef,
          GK.scaleCoef
        }, nil, 1, nil, nil, nil)
      end
    end
  end
  if ed.run_with_scene and owner.actor then
    local color = owner.camp == ed.emCampEnemy and "red" or "blue"
    local str = "immune"
    if not owner.notPopupBattleInfo then
      ed.PopupCreate(str, color, owner.actor, nil, "text")
    end
  end
  damage = 0
  return damage
end

function GK.atk4_logicBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.timer >= 0 then
    local owner = buff.owner
    local caster = buff.caster
    local dir = 1
    local moveRange = math.abs(buff.ownerPerviousPositionX - owner.position[1])
    buff.ownerPerviousPositionX = owner.position[1]
    if moveRange > GK.atk4_protectMaxMoveRange then
      buff.timer = -1
      buff.owner:removeBuff(buff)
    end
  end
end

function GK.atk4_logicBuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  caster.atk4_logicBuff = nil
  if caster.atk4_invisibleBuff then
    local owner = caster.atk4_invisibleBuff.owner
    local endBuff = caster.atk4_invisibleBuff
    caster.atk4_invisibleBuff = nil
    owner:removeBuff(endBuff)
  end
  basefunc(buff)
end

function GK.atk4_invBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local damage = basefunc(buff, damage, damage_type, source, skill)
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
  local ALLIMU = buff.info.ALLIMU or 0
  local absorbDamage = ALLIMU ~= 100 and dmgAfterImmunity * ALLIMU / (100 - ALLIMU) or 0
  GK.addAbsorbDamage(caster, absorbDamage)
  if owner.name == GK.name and not owner.atk4_uncontrollableBuff then
    owner:setAction("Damaged3", false, false)
  end
  return damage
end

function GK.atk4_invBuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  caster.atk4_invisibleBuff = nil
  if caster.atk4_logicBuff then
    local owner = caster.atk4_logicBuff.owner
    local endBuff = caster.atk4_logicBuff
    caster.atk4_logicBuff = nil
    owner:removeBuff(endBuff)
  end
  owner.global_cd = 1.5
  local maxX = ed.engine.stage_rect.maxX
  local minX = ed.engine.stage_rect.minX
  local direction = owner.direction
  owner.position[1] = math.min(maxX, math.max(minX, owner.position[1] - direction * -20))
  basefunc(buff)
  owner:enterActionStageFromOneStage(owner:getNormalPeriod(), 10048)
  if owner.GK_origin_walk_speed_multiplier then
    owner.walk_speed_multiplier = owner.GK_origin_walk_speed_multiplier
  end
  owner:setAction("atk5", false, true)
end

function GK.atk4_finish(basefunc, skill)
  local caster = skill.caster
  local target = skill.target or skill.rescueTarget
  if skill.target ~= skill.rescueTarget or not target:isAlive() then
    if caster.atk4_logicBuff then
      caster.atk4_logicBuff = nil
      caster.atk4_logicBuff.timer = -1
      caster.atk4_logicBuff.owner:removeBuff(caster.atk4_logicBuff)
    end
    if caster.atk4_invisibleBuff then
      caster.atk4_invisibleBuff = nil
      caster.atk4_invisibleBuff.timer = -1
      caster.atk4_invisibleBuff.owner:removeBuff(caster.atk4_invisibleBuff)
    end
    return basefunc(skill)
  end
  basefunc(skill)
  if caster.atk4_uncontrollableBuff then
    caster:removeBuff(caster.atk4_uncontrollableBuff)
    caster.atk4_uncontrollableBuff = nil
  end
  local target = target
  if target:isAlive() and not caster.atk4_invisibleBuff and not caster.atk4_logicBuff then
    local binfo = ed.lookupDataTable("Buff", nil, GK.atk4_selfInvisibleBuff)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("ALLIMU", GK.atk4_protectReduceDamage)
    buff = caster:addBuff(buff, caster)
    if buff then
      buff.onDamaged = override(buff.onDamaged, GK.atk4_invBuff_onDamaged)
      buff.onRemoved = override(buff.onRemoved, GK.atk4_invBuff_onRemoved)
      caster.atk4_invisibleBuff = buff
      buff.guardDirection = skill.rescueDirection
      local enemyRightMinusLeft = buff.guardDirection == "right" and 1 or -1
      for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
        local value = 1
        if enemy.config.is_summoned then
          value = 0.45
        end
        if enemy.position[1] >= target.position[1] then
          enemyRightMinusLeft = enemyRightMinusLeft + value
        else
          enemyRightMinusLeft = enemyRightMinusLeft - value
        end
      end
      if enemyRightMinusLeft < 0 and buff.guardDirection == "right" then
        buff.guardDirection = "left"
      elseif 0 < enemyRightMinusLeft and buff.guardDirection == "left" then
        buff.guardDirection = "right"
      end
      caster.GK_origin_walk_speed_multiplier = caster.walk_speed_multiplier
      caster.walk_speed_multiplier = GK.atk4_walkSpeedCoef
    end
    local binfo = ed.lookupDataTable("Buff", nil, GK.atk4_protectLogicBuff)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff = target:addBuff(buff, caster)
    if buff then
      local protectTime = skill.info["Script Arg1"]
      if protectTime then
        buff.timer = protectTime
      end
      buff.ownerPerviousPositionX = target.position[1]
      buff.onDamaged = override(buff.onDamaged, GK.atk4_logicBuff_onDamaged)
      buff.update = override(buff.update, GK.atk4_logicBuff_update)
      buff.onRemoved = override(buff.onRemoved, GK.atk4_logicBuff_onRemoved)
      caster.atk4_logicBuff = buff
    end
  end
  local caster = skill.caster
  caster:enterActionStageFromOneStage(caster:getGuardPeriod(), 10048)
end

function GK.ult_willCast(basefunc, skill)
  local caster = skill.caster
  if caster.ult_currentAbsorbLevel == 1 and ed.engine:arenaMode() then
    return false
  end
  return basefunc(skill)
end

function GK.ult_func_levelChangeTo(unit, newLevel)
  newLevel = math.min(newLevel, GK.ult_maxLevel)
  if unit.name == GK.name and unit.ult_currentAbsorbLevel then
    unit.ult_currentAbsorbLevel = newLevel
  end
  if unit.ult_absorbLevelBuff then
    unit:removeBuff(unit.ult_absorbLevelBuff)
    unit.ult_absorbLevelBuff = nil
  end
  if unit.name == GK.name then
    local buffId = GK.ult_absorbLevelZeroBuff + newLevel - 1
    local binfo = ed.lookupDataTable("Buff", nil, buffId)
    local buff = unit:addBuff(binfo, unit)
    unit.ult_absorbLevelBuff = buff
  end
end

function GK.ult_start(basefunc, skill, target)
  basefunc(skill, target)
end

function GK.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local level = caster.ult_currentAbsorbLevel or 1
  if caster.name ~= GK.name then
    level = 4
  end
  if skill.attack_counter <= level - 1 then
    local originInfo = skill.info
    if level == 1 then
      skill.info = ed.wraptable(originInfo, {
        ["No Dodge"] = true,
        ["Shape Arg1"] = 200,
        ["Point Effect"] = "eff_tile_TS_atk2.cha"
      })
    else
      skill.info = ed.wraptable(originInfo, {
        ["No Dodge"] = true
      })
    end
    basefunc(skill)
    skill.info = originInfo
  end
end

function GK.ult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local level = caster.ult_currentAbsorbLevel or 1
  if caster.name ~= GK.name then
    level = 4
  end
  if skill.attack_counter == level - 1 then
    local binfo = ed.lookupDataTable("Buff", nil, GK.ult_stunBuffId)
    buff = ed.BuffCreate(binfo, target, caster)
    buff.timer = buff.timer + (level - 1) * 1.3
  end
  return buff
end

function GK.ult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  GK.ult_func_levelChangeTo(caster, 1)
  caster.ult_absorbDamage = 0
  local defenceBuff = caster.atk2_defenceModeBuff
  if defenceBuff then
    caster:enterActionStageFromOneStage(caster:getNormalPeriod(), 10048)
    caster:removeBuff(defenceBuff)
    caster.atk2_defenceModeBuff = nil
  end
end

function GK.awake_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local caster = skill.caster
    if not caster.atk2_defenceModeBuff then
      return false, "not defence mode"
    end
    if caster.awake_uncontrollableBuff then
      return false, "already use awake"
    end
  end
  return canUse, reason
end

function GK.awake_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local deltaX = owner.direction >= 0 and GK.awake_reboundDeltaX or -GK.awake_reboundDeltaX
  local shieldX = owner.position[1] + deltaX
  for _, projectile in ipairs(ed.engine.projectile_list) do
    if projectile.camp == owner.camp then
    elseif not projectile.can_be_influenced then
    elseif projectile.is_region or projectile.is_chain then
    else
      local pos = projectile.position
      local v = projectile.velocity
      local nextTickPos = {}
      nextTickPos[1] = pos[1] + v[1] * ed.tick_interval
      nextTickPos[2] = pos[2] + v[2] * ed.tick_interval
      local nextTickHeight = projectile.height + projectile.zSpeed * ed.tick_interval
      local reboundChance = GK.awake_reboundChance
      local power = 0
      if projectile.skill then
        local damage_type = projectile.skill.info["Damage Type"]
        local source = projectile.skill.caster
      end
      if not projectile.GK_awake_reboundCheck and reboundChance >= ed.rand() and 0 >= (nextTickPos[1] - shieldX) * (pos[1] - shieldX) and nextTickHeight <= GK.awake_defenceTileHeight and power and power <= GK.awake_reboundTileMaxPower then
        projectile.GK_awake_reboundCheck = true
        local p = nextTickPos[1] == projectile.position[1] and 1 or (shieldX - projectile.position[1]) / (nextTickPos[1] - projectile.position[1])
        projectile.position[1] = (nextTickPos[1] - projectile.position[1]) * p + projectile.position[1]
        projectile.position[2] = (nextTickPos[2] - projectile.position[2]) * p + projectile.position[2]
        projectile.height = math.min(GK.awake_defenceTileHeight, (nextTickHeight - projectile.height) * p + projectile.height)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene(GK.awake_reboundEffect, pos, {1, 1}, projectile.height, 1, nil, nil, nil)
        end
        projectile.camp = -projectile.camp
        projectile.affect_camp = -projectile.affect_camp
        projectile.affect_times = {}
        projectile.distance = 0
        projectile.track = false
        local speedCoef = 0.75 + ed.rand() * 0.2
        projectile.zSpeed = projectile.zSpeed * -speedCoef
        projectile.velocity = ed.edpMult(projectile.velocity, -speedCoef)
        local skillinfo = projectile.skill.info
        if projectile.caster and (skillinfo and skillinfo["Tile Gravity"] >= -150 or projectile["No Gravity"]) then
          projectile:enableTrack(projectile.caster)
        end
      end
    end
  end
  local deltaX = owner.direction >= 0 and GK.awake_reboundDeltaX or -GK.awake_reboundDeltaX
  local shieldX = owner.position[1] + deltaX
  for enemy in ed.engine:foreachAliveUnit(owner.foecamp) do
    if buff.enemyHeroNoKnockTime[enemy] and 0 < buff.enemyHeroNoKnockTime[enemy] then
      buff.enemyHeroNoKnockTime[enemy] = buff.enemyHeroNoKnockTime[enemy] - dt
      break
    end
    if enemy.buff_effects.invulnerable then
      break
    end
    local knockBasic
    local perPos = buff.enemyHeroPositionList[enemy]
    local curPos = enemy.position
    if math.abs(curPos[1] - shieldX) <= GK.awake_knockHeroDistance then
      knockBasic = GK.awake_knockHeroDistance - math.abs(curPos[1] - shieldX)
    elseif perPos and 0 >= (curPos[1] - shieldX) * (perPos[1] - shieldX) and math.abs(curPos[1] - shieldX) <= 2 * GK.awake_knockHeroDistance then
      knockBasic = GK.awake_knockHeroDistance
    end
    if knockBasic then
      local dir = perPos and (shieldX < perPos[1] and 1 or -1) or owner.direction > 0 and 1 or -1
      knockBasic = dir * (2 * knockBasic + 100)
      local knockDistance = {knockBasic, 0}
      local knockTime = 0.5
      enemy:hurt()
      enemy:moveDrop(enemy.height)
      enemy:knockup(knockTime, knockDistance, nil)
      buff.enemyHeroNoKnockTime[enemy] = 0.75
    end
    buff.enemyHeroPositionList[enemy] = {
      enemy.position[1],
      enemy.position[2]
    }
  end
end

function GK.awake_buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  basefunc(buff)
  local awake = owner.skills[GK.name .. "_awake"]
  if owner.name == GK.name and owner.current_skill == awake and awake.current_phase_idx < 2 then
    awake:startPhase(2)
  end
end

function GK.awake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  caster.awake_uncontrollableBuff = buff
  buff.enemyHeroPositionList = {}
  buff.enemyHeroNoKnockTime = {}
  local awakeTime = skill.info["Script Arg1"]
  if awakeTime then
    buff.timer = awakeTime
  end
  buff.update = override(buff.update, GK.awake_buff_update)
  buff.onRemoved = override(buff.onRemoved, GK.awake_buff_onRemoved)
  return buff
end

function GK.awake_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local phase = skill.current_phase_idx or 2
  if phase == 1 and skill.attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    if ed.run_with_scene then
      local effectName = "eff_point_GK_ult_floor.cha"
      local pos = caster.position
      local scaleX = 0 <= caster.direction and 1 or -1
      skill.awake_effect1 = ed.scene:playEffectOnScene(effectName, pos, {
        GK.scaleCoef * scaleX,
        GK.scaleCoef
      }, nil, -1, nil, nil, nil)
    end
  elseif phase == 1 and skill.attack_counter == 1 then
    basefunc(skill)
    if ed.run_with_scene then
      local effectName = "eff_point_GK_ult_shield.cha"
      local pos = caster.position
      local scaleX = 0 <= caster.direction and 1 or -1
      skill.awake_effect2 = ed.scene:playEffectOnScene(effectName, pos, {
        GK.scaleCoef * scaleX,
        GK.scaleCoef
      }, nil, 1, nil, nil, nil)
    end
  end
end

function GK.awake_startPhase(basefunc, skill, idx)
  basefunc(skill, idx)
  local phase = skill.current_phase_idx or 2
  if phase == 2 and ed.run_with_scene then
    if skill.awake_effect1 then
      ed.scene:removeEffect(skill.awake_effect1, -1)
      skill.awake_effect1 = nil
    end
    if skill.awake_effect2 then
      ed.scene:removeEffect(skill.awake_effect2, 1)
      skill.awake_effect2 = nil
    end
  end
end

function GK.awake_finish(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  if caster.awake_uncontrollableBuff then
    caster.awake_uncontrollableBuff.timer = -1
    caster.awake_uncontrollableBuff = nil
  end
  if ed.run_with_scene then
    if skill.awake_effect1 then
      ed.scene:removeEffect(skill.awake_effect1, -1)
      skill.awake_effect1 = nil
    end
    if skill.awake_effect2 then
      ed.scene:removeEffect(skill.awake_effect2, 1)
      skill.awake_effect2 = nil
    end
  end
end

function GK.enter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local maxX = ed.engine.stage_rect.maxX
  local minX = ed.engine.stage_rect.minX
  caster.position[1] = (minX + maxX) / 2 - caster:getInitDir() * 40
  caster.direction = caster:getInitDir()
  if caster.GK_enterBuff then
    caster.GK_enterBuff.timer = 0
    caster.GK_enterBuff = nil
  end
  local binfo = ed.lookupDataTable("Buff", nil, GK.enterBuffId_stable)
  local buff = caster:addBuff(binfo, caster)
  caster.GK_enterBuff = buff
  GK.func_hideBuffEffect(caster)
end

function GK.enter_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.GK_enterBuff then
    caster.GK_enterBuff.timer = 0
    caster.GK_enterBuff = nil
  end
  GK.func_resetBuffEffect(caster)
end

function GK.enter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
end

function GK.atk2d_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local caster = skill.caster
    if not caster.atk2_defenceModeBuff then
      return false, "not defence mode"
    end
    if caster.awake_uncontrollableBuff then
      return false, "power shield ing "
    end
    local nearEnemy = false
    for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
      local distanceSQ = ed.edpDistanceSQ(enemy.position, caster.position)
      if distanceSQ <= GK.atk2d_distanceCondition ^ 2 then
        nearEnemy = true
        break
      end
    end
    if nearEnemy then
      return false, "near enemy exist"
    end
  end
  return canUse, reason
end

function GK.atk2d_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:enterActionStageFromOneStage(caster:getNormalPeriod(), 10048)
  if caster.atk2_defenceModeBuff then
    caster:removeBuff(caster.atk2_defenceModeBuff)
    caster.atk2_defenceModeBuff = nil
  end
end

function GK.atk2b_buff_checkExtraDamageCondition(basefunc, buff, source, damage_type, power)
  local damageChange = false
  local caster = buff.caster
  local owner = buff.owner
  local sourceHero = source and source.caster or source
  if caster.name ~= GK.name or not caster.atk2_defenceModeBuff then
  elseif not sourceHero then
  elseif caster.camp ~= owner.camp or caster.camp == sourceHero.camp then
  elseif not (caster.position and owner.position) or not sourceHero.position then
  elseif (caster.position[1] - owner.position[1]) * (caster.position[1] - sourceHero.position[1]) > 0 then
  elseif caster == owner and 0 > caster.direction * (sourceHero.position[1] - owner.position[1]) then
  else
    damageChange = true
  end
  local awakeAdd = false
  if not caster.awake_uncontrollableBuff then
  else
    awakeAdd = true
  end
  if damageChange then
    local maxChangeDamage = awakeAdd and buff.GK_maxChangeDamage * (1 + buff.GK_awakeCoef) or buff.GK_maxChangeDamage
    local maxExtraDamageValue = not (not (power <= 0) and maxChangeDamage) and 0 or maxChangeDamage / power
    buff.extraDamageValue = awakeAdd and GK.atk2_teammate_reduceDamageCoef * (1 + buff.GK_awakeCoef) or GK.atk2_teammate_reduceDamageCoef
    buff.extraDamageValue = math.max(-maxExtraDamageValue, buff.extraDamageValue)
    GK.addAbsorbDamage(caster, -buff.extraDamageValue * power)
  end
  return damageChange
end

function GK.atk2b_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("Effect", "eff_tile_TS_atk2.cha")
  buff.timer = buff.timer + 9999
  buff.GK_maxChangeDamage = skill.info["Script Arg1"] or 1000
  local caster = skill.caster
  local awake = caster.skills[GK.name .. "_awake"]
  if awake then
    buff.GK_awakeCoef = GK.awake_coefRatio or 3
  end
  buff.extraDamageValue = GK.atk2_teammate_reduceDamageCoef
  buff.checkExtraDamageCondition = override(buff.checkExtraDamageCondition, GK.atk2b_buff_checkExtraDamageCondition)
  return buff
end

function GK.atk2c_buff_checkExtraDamageCondition(basefunc, buff, source, damage_type, power)
  local damageChange = false
  local caster = buff.caster
  local owner = buff.owner
  local sourceHero = source and source.caster or source
  if caster.name ~= GK.name or not caster.atk2_defenceModeBuff then
  elseif not sourceHero then
  elseif caster.camp == owner.camp or caster.camp ~= sourceHero.camp then
  elseif not (caster.position and owner.position) or not sourceHero.position then
  elseif (caster.position[1] - owner.position[1]) * (caster.position[1] - sourceHero.position[1]) > 0 then
  elseif caster == sourceHero and 0 > caster.direction * (sourceHero.position[1] - owner.position[1]) then
  else
    damageChange = true
  end
  local awakeAdd = false
  if not caster.awake_uncontrollableBuff then
  else
    awakeAdd = true
  end
  if damageChange then
    local maxChangeDamage = awakeAdd and buff.GK_maxChangeDamage * (1 + buff.GK_awakeCoef) or buff.GK_maxChangeDamage
    local maxExtraDamageValue = not (not (power <= 0) and maxChangeDamage) and 0 or maxChangeDamage / power
    buff.extraDamageValue = awakeAdd and GK.atk2_enemy_extraDamageCoef * (1 + buff.GK_awakeCoef) or GK.atk2_enemy_extraDamageCoef
    buff.extraDamageValue = math.min(maxExtraDamageValue, buff.extraDamageValue)
  end
  return damageChange
end

function GK.atk2c_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("Effect", "eff_tile_TS_atk2.cha")
  buff.timer = buff.timer + 9999
  buff.GK_maxChangeDamage = skill.info["Script Arg1"] or 1000
  local caster = skill.caster
  local awake = caster.skills[GK.name .. "_awake"]
  if awake then
    buff.GK_awakeCoef = GK.awake_coefRatio or 3
  end
  buff.extraDamageValue = GK.atk2_enemy_extraDamageCoef
  buff.checkExtraDamageCondition = override(buff.checkExtraDamageCondition, GK.atk2c_buff_checkExtraDamageCondition)
  return buff
end

function GK.reset(basefunc, unit)
  basefunc(unit)
  unit.originCamp = unit.camp
  unit:enterActionStageFromOneStage(unit:getNormalPeriod(), 10048)
  local ult = unit.skills[GK.name .. "_ult"]
  if ult then
    unit.ult_absorbDamage = 0
    unit.ult_currentAbsorbLevel = 1
    if unit.name == GK.name then
      local binfo = ed.lookupDataTable("Buff", nil, GK.ult_absorbLevelZeroBuff)
      local buff = unit:addBuff(binfo, unit)
      unit.ult_absorbLevelBuff = buff
    end
  end
  local atk2 = unit.skills[GK.name .. "_atk2"]
  if atk2 then
    unit.atk2_alreadyCreateRegion = false
    unit.atk2_defenceModeBuff = nil
  end
  local awake = unit.skills[GK.name .. "_awake"]
  if awake then
    awake.awake_effect1 = nil
    awake.awake_effect2 = nil
  end
  local atk4 = unit.skills[GK.name .. "_atk4"]
  if atk4 then
    unit.GK_stayTime = 0
    unit.GK_canUseAtk4 = true
    unit.atk4_alreadyCreateRegion = false
    unit.atk4_uncontrollableBuff = nil
    unit.atk4_invisibleBuff = nil
    atk4.rescueTarget = nil
    atk4.rescueDirection = nil
    atk4.casterDirectionLocked = true
  end
  local enter = unit.skills[GK.name .. "_enter"]
  if enter and not unit.config.is_summoned then
    enter.cd_remaining = 0
    local binfo = ed.lookupDataTable("Buff", nil, GK.enterBuffId_invisible)
    local buff = unit:addBuff(binfo, unit)
    unit.GK_enterBuff = buff
  end
end

function GK.addBuff(basefunc, unit, buff_Or_Binfo, caster)
  local buff = basefunc(unit, buff_Or_Binfo, caster)
  local defenceBuff = unit.atk2_defenceModeBuff
  if defenceBuff and buff then
    local interruptDefence = false
    for i, effect in ipairs(buff.info["Control Effects"]) do
      for _, effect2 in ipairs(GK.interruptEffectList) do
        if effect == effect2 then
          interruptDefence = true
          break
        end
      end
      if interruptDefence then
        break
      end
    end
    if interruptDefence then
      unit:enterActionStageFromOneStage(unit:getNormalPeriod(), 10048)
      unit:removeBuff(defenceBuff)
      unit.atk2_defenceModeBuff = nil
      local atk2 = unit.skills[GK.name .. "_atk2"]
      if atk2 then
        atk2.cd_remaining = GK.atk2_cd
      end
      unit:setAction("Damaged2", false, true)
    end
  end
  if unit.atk4_logicBuff and unit.atk4_invisibleBuff and buff then
    local interruptProtect = false
    for i, effect in ipairs(buff.info["Control Effects"]) do
      for _, effect2 in ipairs(GK.interruptProtectList) do
        if effect == effect2 then
          interruptProtect = true
          break
        end
      end
      if interruptProtect then
        break
      end
    end
    if interruptProtect then
      unit.atk4_logicBuff.timer = -1
      unit.atk4_invisibleBuff.timer = -1
    end
  end
  return buff
end

function GK.hurt(basefunc, unit)
  basefunc(unit)
  local defenceBuff = unit.atk2_defenceModeBuff
  if defenceBuff then
    unit:enterActionStageFromOneStage(unit:getNormalPeriod(), 10048)
    unit:removeBuff(defenceBuff)
    unit.atk2_defenceModeBuff = nil
    local atk2 = unit.skills[GK.name .. "_atk2"]
    if atk2 then
      atk2.cd_remaining = GK.atk2_cd
    end
  end
end

function GK.ai_update(basefunc, ai, dt)
  local unit = ai.owner
  if unit.name == GK.name and unit.atk4_invisibleBuff and unit.atk4_logicBuff then
    local guardTarget = unit.atk4_logicBuff.owner
    if guardTarget and guardTarget:isAlive() then
      local deltaX = unit.atk4_invisibleBuff.guardDirection == "right" and GK.atk4_deltaX or -GK.atk4_deltaX
      local targetPos = {
        guardTarget.position[1] + deltaX,
        guardTarget.position[2] - 1
      }
      local distanceSQ = ed.edpDistanceSQ(targetPos, unit.position)
      if distanceSQ <= 225 then
        unit:idle()
      else
        unit:walkTowards(targetPos)
      end
    end
  else
    basefunc(ai, dt)
  end
end

function GK.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local maxHp = unit.attribs.HP
  local currentLevel = unit.ult_currentAbsorbLevel or 999
  if unit.ult_absorbDamage and currentLevel < GK.ult_maxLevel and unit.ult_absorbDamage >= currentLevel * GK.ult_absorbLevelCoef * maxHp then
    GK.ult_func_levelChangeTo(unit, currentLevel + 1)
  end
  local curDir = unit.direction
  local preDir = unit.GK_previousDirection or unit.direction
  local atk4 = unit.skills[GK.name .. "_atk4"]
  if curDir * preDir < 0 and not unit.buff_effects.polymorph and (not unit.current_skill or unit.current_skill ~= atk4) then
    local maxX = ed.engine.stage_rect.maxX
    local minX = ed.engine.stage_rect.minX
    unit.position[1] = math.min(maxX, math.max(minX, unit.position[1] + curDir * GK.changeDirDeltaX))
  end
  unit.GK_previousDirection = unit.direction
  local atk2 = unit.skills[GK.name .. "_atk2"]
  local atk2b = unit.skills[GK.name .. "_atk2b"]
  local atk2c = unit.skills[GK.name .. "_atk2c"]
  if atk2 and atk2b and atk2c and not unit.atk2_alreadyCreateRegion then
    unit.atk2_alreadyCreateRegion = true
    atk2b.target = unit
    atk2c.target = unit
    local region_teammate = atk2b:createRegion()
    local region_enemy = atk2c:createRegion()
    region_teammate.position[1] = region_teammate.position[1] + 1
    region_enemy.position[1] = region_enemy.position[1] + 2
    unit.atk2_teammateRegion = region_teammate
    unit.atk2_enemyRegion = region_enemy
    ed.engine:addRegion(region_teammate)
    ed.engine:addRegion(region_enemy)
  end
  local atk4b = unit.skills[GK.name .. "_atk4b"]
  if atk4b and not unit.atk4_alreadyCreateRegion then
    unit.atk4_alreadyCreateRegion = true
    atk4b.target = unit
    local atk4b_region = atk4b:createRegion()
    atk4b_region.position[1] = atk4b_region.position[1] + 3
    unit.atk4_region = atk4b_region
    ed.engine:addRegion(atk4b_region)
  end
  if not unit.GK_aiInitial then
    unit.GK_aiInitial = true
    local ai = unit.ai
    ai.update = override(ai.update, GK.ai_update)
  end
end

function GK.die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.atk4_logicBuff then
    local owner = hero.atk4_logicBuff.owner
    local endBuff = hero.atk4_logicBuff
    hero.atk4_logicBuff = nil
    owner:removeBuff(endBuff)
  end
  if hero.atk2_teammateRegion then
    hero.atk2_teammateRegion:finish()
    hero.atk2_teammateRegion = nil
  end
  if hero.atk2_enemyRegion then
    hero.atk2_enemyRegion:finish()
    hero.atk2_enemyRegion = nil
  end
  if hero.atk4_region then
    hero.atk4_region:finish()
    hero.atk4_region = nil
  end
end

function GK.getFixDir(basefunc, unit)
  local ret = basefunc(unit)
  if unit.GK_atk2_lockDirection and unit.GK_atk2_lockDirection * ret < 0 then
    ret = -ret
  end
  return ret
end

function GK.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, GK.reset)
  hero.update = override(hero.update, GK.update)
  hero.addBuff = override(hero.addBuff, GK.addBuff)
  hero.die = override(hero.die, GK.die)
  hero.hurt = override(hero.hurt, GK.hurt)
  hero.getFixDir = override(hero.getFixDir, GK.getFixDir)
  local atk2 = hero.skills[GK.name .. "_atk2"]
  local atk2b = hero.skills[GK.name .. "_atk2b"]
  local atk2c = hero.skills[GK.name .. "_atk2c"]
  local atk2d = hero.skills[GK.name .. "_atk2d"]
  if atk2 and atk2b and atk2c and atk2d then
    atk2.canCastWithTarget = override(atk2.canCastWithTarget, GK.atk2_canCastWithTarget)
    atk2.start = override(atk2.start, GK.atk2_start)
    atk2.onAttackFrame = override(atk2.onAttackFrame, GK.atk2_onAttackFrame)
    atk2.createBuff = override(atk2.createBuff, GK.atk2_createBuff)
    atk2.finish = override(atk2.finish, GK.atk2_finish)
    atk2b.createBuff = override(atk2b.createBuff, GK.atk2b_createBuff)
    atk2c.createBuff = override(atk2c.createBuff, GK.atk2c_createBuff)
    atk2d.canCastWithTarget = override(atk2d.canCastWithTarget, GK.atk2d_canCastWithTarget)
    atk2d.finish = override(atk2d.finish, GK.atk2d_finish)
  end
  local atk3 = hero.skills[GK.name .. "_atk3"]
  if atk3 then
    atk3.canCastWithTarget = override(atk3.canCastWithTarget, GK.atk3_canCastWithTarget)
    atk3.onAttackFrame = override(atk3.onAttackFrame, GK.atk3_onAttackFrame)
    atk3.takeEffectOn = override(atk3.takeEffectOn, GK.atk3_takeEffectOn)
  end
  local atk4 = hero.skills[GK.name .. "_atk4"]
  local atk4b = hero.skills[GK.name .. "_atk4b"]
  if atk4 and atk4b then
    atk4.onAttackFrame = override(atk4.onAttackFrame, GK.atk4_onAttackFrame)
    atk4.finish = override(atk4.finish, GK.atk4_finish)
    atk4b.createBuff = override(atk4b.createBuff, GK.atk4b_createBuff)
  end
  local ult = hero.skills[GK.name .. "_ult"]
  if ult then
    ult.willCast = override(ult.willCast, GK.ult_willCast)
    ult.start = override(ult.start, GK.ult_start)
    ult.onAttackFrame = override(ult.onAttackFrame, GK.ult_onAttackFrame)
    ult.createBuff = override(ult.createBuff, GK.ult_createBuff)
    ult.finish = override(ult.finish, GK.ult_finish)
  end
  local awake = hero.skills[GK.name .. "_awake"]
  if awake then
    awake.canCastWithTarget = override(awake.canCastWithTarget, GK.awake_canCastWithTarget)
    awake.createBuff = override(awake.createBuff, GK.awake_createBuff)
    awake.onAttackFrame = override(awake.onAttackFrame, GK.awake_onAttackFrame)
    awake.startPhase = override(awake.startPhase, GK.awake_startPhase)
    awake.finish = override(awake.finish, GK.awake_finish)
  end
  local enter = hero.skills[GK.name .. "_enter"]
  if enter then
    enter.start = override(enter.start, GK.enter_start)
    enter.onAttackFrame = override(enter.onAttackFrame, GK.enter_onAttackFrame)
    enter.finish = override(enter.finish, GK.enter_finish)
  end
  
  function hero.getNormalPeriod(unit)
    local period = 1
    if ed.protoAwake(unit.proto, 10048) then
      period = 4
    end
    return period
  end
  
  function hero.getDefencePeriod(unit)
    local period = 2
    if ed.protoAwake(unit.proto, 10048) then
      period = 5
    end
    return period
  end
  
  function hero.getGuardPeriod(unit)
    local period = 3
    if ed.protoAwake(unit.proto, 10048) then
      period = 6
    end
    return period
  end
  
  return hero
end

return GK.init_hero
