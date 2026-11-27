module("ed.battlehero", package.seeall)
local ed = ed
BossFV = {}
BossFV.name = "BossFV"
BossFV.emptyBuffID = 233
BossFV.atkbRatioList = {
  5,
  5,
  5,
  5,
  5,
  5,
  7,
  8,
  6,
  10,
  5,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1
}
BossFV.atkbRatio2 = 0.15
BossFV.atkbKnockUpList = {
  0.1,
  0.06,
  0.06,
  0.06,
  0.12,
  0.06,
  0.12,
  0.2,
  0.15,
  0.3,
  0.1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1
}
BossFV.atkbKnockBackList = {
  1,
  0.6,
  0.6,
  0.6,
  0.6,
  0.8,
  5,
  8,
  15,
  30,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1
}
BossFV.atkbMoveForwardList = {
  1,
  0.6,
  0.6,
  0.6,
  0.6,
  0.8,
  1,
  1,
  0,
  0,
  0,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1
}
BossFV.atkbCameraShakeHList = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  5,
  0,
  10,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
BossFV.atkbAOEOriginList = {
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  "self",
  "self",
  "self",
  "self",
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
BossFV.rec = "rectangle"
BossFV.cir = "circle"
BossFV.atkbAOEShapeList = {
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  BossFV.rec,
  BossFV.rec,
  BossFV.rec,
  BossFV.cir,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
BossFV.atkbShapeArg1List = {
  150,
  150,
  150,
  150,
  150,
  150,
  150,
  140,
  120,
  150,
  80,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
BossFV.atkbXShiftList = {
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  0,
  0,
  0,
  -55,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
BossFV.IEb = "eff_impact_FV_atkb.cha"
BossFV.IEc1 = "eff_impact_FV_atkc1.cha"
BossFV.IEc2 = "eff_impact_FV_atkc2.cha"
BossFV.IEc3 = "eff_impact_FV_atkc3.cha"
BossFV.ImpactEffectList = {
  BossFV.IEb,
  BossFV.IEb,
  BossFV.IEb,
  BossFV.IEb,
  BossFV.IEb,
  BossFV.IEb,
  BossFV.IEb,
  BossFV.IEc1,
  BossFV.IEc2,
  BossFV.IEc3,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
BossFV.atkbBuffIDList = {
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  292,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
BossFV.TimeZoneTime = 10
BossFV.ZoneXRange = 9
BossFV.Waiting_Buff_ID = 94
BossFV.auraID = "FVult_timezone"
BossFV.zoneFg = "eff_tile_FV_timezone.cha"
BossFV.zoneBg = "eff_tile_FV_timezone_far.cha"

function BossFV.listener_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local unit = buff.caster
  local holdingWeaponPeriod = unit:getHoldingWeaponPeriod()
  if unit.currentActionStage ~= holdingWeaponPeriod then
    unit:enterActionStageFromOneStage(holdingWeaponPeriod, 177)
    unit.skills[BossFV.name .. "_return"].cd_remaining = 0
  end
end

function BossFV.reset(basefunc, unit)
  basefunc(unit)
  unit:enterActionStageFromOneStage(unit:getHoldingWeaponPeriod(), 177)
  local binfo = ed.lookupDataTable("Buff", nil, BossFV.emptyBuffID)
  local buff = unit:addBuff(binfo, unit)
  if buff then
    buff.onRemoved = override(buff.onRemoved, BossFV.listener_buff_onRemoved)
  end
  if unit.name == "BossFV" then
    local dir = unit:getInitDir()
    unit.position[1] = 400 - 250 * dir
    unit.direction = dir
    unit.skills[BossFV.name .. "_exercise"].cd_remaining = 0
  end
end

function BossFV.playBlinkEffect(unit, startPos, endPos, direction, offset)
  offset = offset or 60
  direction = direction or endPos[1] > startPos[1] and 1 or -1
  local effect_name = unit:getShadowEffect()
  if not effect_name then
    return
  end
  local effect_z = 0
  local n = math.floor(math.abs(startPos[1] - endPos[1]) / offset)
  for i = 1, n do
    local x = startPos[1] * i / (n + 1) + endPos[1] * (n + 1 - i) / (n + 1)
    local y = startPos[2] * i / (n + 1) + endPos[2] * (n + 1 - i) / (n + 1)
    ed.scene:playEffectOnScene(effect_name, {x, y}, {direction, 1}, nil, effect_z)
  end
end

function BossFV.ult_buff_onRemoved(basefunc, buff)
  buff.owner[BossFV.auraID] = nil
  basefunc(buff)
end

function BossFV.ult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, BossFV.ult_buff_onRemoved)
  target[BossFV.auraID] = buff
  return buff
end

function BossFV.timezone_update(basefunc, projectile, dt)
  if projectile.birthtick ~= ed.engine.ticks then
    projectile.previous_position = {
      projectile.position[1],
      projectile.position[2]
    }
    ed.Entity.update(projectile, dt)
  end
  if not projectile.terminated then
    projectile.timer = projectile.timer - dt
    local skill = projectile.skill
    if projectile.timer < 0 then
      projectile:terminate()
      if skill.caster.TimeZone == projectile then
        skill.caster.TimeZone = nil
      end
      projectile.BG:terminate()
    else
      local direction = 1
      local info = skill.info
      local location = projectile.position
      local origin = {
        location[1] + info["X Shift"] * direction,
        location[2]
      }
      local shape = info["AOE Shape"]
      local arg1 = info["Shape Arg1"]
      local arg2 = info["Shape Arg2"]
      for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
        if not unit.ImmuneTimeZone and projectile.skill.caster.name ~= unit.name then
          local p2 = ed.edpSub(unit.position, origin)
          p2[1] = p2[1] * direction
          if ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
            if unit[BossFV.auraID] then
              unit[BossFV.auraID].timer = 0.25
            else
              if not unit[projectile] then
                local bSucess, reason = ed.Buff.checkAddBuff(info.buff_info, skill.level, unit, projectile.caster)
                if not bSucess and reason == "level" then
                  unit[projectile] = 0
                  if unit.actor then
                    local target = unit
                    local color = target.camp == ed.emCampEnemy and "red" or "blue"
                    local text = reason == "resist" and "resist" or "miss"
                    ed.PopupCreate(text, color, target.actor, nil, "text")
                  end
                end
              end
              if unit[projectile] ~= 0 then
                local buff = unit:addBuff(skill:createBuff(unit))
                if not unit[projectile] and buff then
                  unit[projectile] = 1
                end
              end
            end
          end
        end
      end
    end
  end
end

function BossFV.clamp(n, min, max)
  if n < min then
    return min
  end
  if max < n then
    return max
  end
  return n
end

function BossFV.ult_start(basefunc, skill, target)
  basefunc(skill, target)
  local info = skill.info
  local caster = skill.caster
  local enemyFV
  if skill.BossFVUltIndex then
    skill.BossFVUltIndex = skill.BossFVUltIndex + 1
    if skill.BossFVUltIndex > #ed.engine.alive_units[skill:targetCamp()] then
      skill.BossFVUltIndex = 1
    end
  else
    skill.BossFVUltIndex = 1
  end
  local curTarget = ed.engine.alive_units[skill:targetCamp()][skill.BossFVUltIndex]
  local position = curTarget and {
    curTarget.position[1],
    0
  } or {0, 0}
  if math.abs(position[1] - caster.position[1]) > 160 then
    caster.FVultOriPos = {
      caster.position[1],
      caster.position[2]
    }
  end
  local dir = position[1] > caster.position[1] and 1 or -1
  position[1] = position[1]
  caster:setPosition(position)
  caster.direction = dir
  skill.target = nil
end

function BossFV.ult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    local self = skill
    self.attack_counter = self.attack_counter + 1
  else
    basefunc(skill)
  end
  skill.target = nil
end

function BossFV.ult_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 2 then
    local info = skill.info
    local caster = skill.caster
    local position = caster.position
    skill.info["Tile Art"] = BossFV.zoneFg
    local projectile = skill:createProjectile()
    projectile.position = {
      position[1],
      position[2]
    }
    projectile.height = 0
    projectile.timer = BossFV.TimeZoneTime
    projectile.update = override(projectile.update, BossFV.timezone_update)
    ed.engine:addProjectile(projectile)
    if projectile.actor then
      projectile.actor.ownScaleX = caster.DoneRadius / 220
      projectile.actor.ownScaleY = caster.DoneRadius / 220
      projectile.actor.ownZOrder = 800 - projectile.position[2] / 100
      projectile.actor.ownRotation = 0
    end
    caster.TimeZone = projectile
    skill.info["Tile Art"] = BossFV.zoneBg
    local projectileBg = skill:createProjectile()
    projectileBg.position = {
      position[1],
      position[2]
    }
    projectileBg.height = 0
    projectileBg.timer = BossFV.TimeZoneTime
    projectileBg.update = override(projectileBg.update, function(basefunc, projectile, dt)
      ed.Entity.update(projectile, dt)
    end)
    ed.engine:addProjectile(projectileBg)
    if projectileBg.actor then
      projectileBg.actor.ownScaleX = caster.DoneRadius / 220
      projectileBg.actor.ownScaleY = caster.DoneRadius / 220
      projectileBg.actor.ownZOrder = -998
      projectileBg.actor.ownRotation = 0
    end
    projectile.BG = projectileBg
  end
end

function BossFV.ult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  unit:enterActionStageFromOneStage(unit:getNoWeaponPeriod(), 177)
  local caster = skill.caster
end

function BossFV.atkb_selectTarget2(skill, default)
  local self = skill
  local target_type = self.info["Target Type"]
  local selector = self.target_selectors.nearest
  local Ignore = self:Ignore_Target_Type()
  local max = -math.huge
  local chosen
  local caster = self.caster
  if not caster.TimeZone then
    return self.target
  end
  local zone_position = caster.TimeZone.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - zone_position[1]) ^ 2 + (unit.position[2] - zone_position[2]) ^ 2
      if distanceSQ <= caster.DoneRadius ^ 2 then
        local v = selector(unit)
        local shouldIgnore = Ignore(unit)
        if max < v and not shouldIgnore then
          max = v
          chosen = unit
        end
      end
    end
  end
  self.target = chosen
  return self.target
end

function BossFV.atkb_onAttackFrame(basefunc, skill)
  local info = skill.info
  info["Plus Ratio"] = BossFV.atkbRatioList[skill.attack_counter + 1] * BossFV.atkbRatio2
  info["Knock Up"] = BossFV.atkbKnockUpList[skill.attack_counter + 1]
  info["Knock Back"] = BossFV.atkbKnockBackList[skill.attack_counter + 1]
  info["Move Forward"] = BossFV.atkbMoveForwardList[skill.attack_counter + 1]
  info["AOE Origin"] = BossFV.atkbAOEOriginList[skill.attack_counter + 1]
  info["AOE Shape"] = BossFV.atkbAOEShapeList[skill.attack_counter + 1]
  info["Shape Arg1"] = BossFV.atkbShapeArg1List[skill.attack_counter + 1]
  info["X Shift"] = BossFV.atkbXShiftList[skill.attack_counter + 1]
  info["Impact Effect"] = BossFV.ImpactEffectList[skill.attack_counter + 1]
  local bid = BossFV.atkbBuffIDList[skill.attack_counter + 1]
  if bid then
    info["Buff ID"] = bid
    info.buff_info = ed.lookupDataTable("Buff", nil, bid)
  else
    info["Buff ID"] = nil
  end
  local self = skill
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if skill.attack_counter <= 8 and not self.target then
    BossFV.atkb_selectTarget2(self, nil)
  end
  local caster = self.caster
  local aoe = self.info["AOE Origin"]
  if self.target then
    self:takeEffectAt(self.target.position)
  elseif aoe then
    self:takeEffectAt(caster.position)
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
  if skill.attack_counter <= 7 then
    local casterPosition = skill.caster.position
    local target = skill.target
    if target and math.abs(target.position[1] - casterPosition[1]) < caster.DoneRadius and not target.buff_effects.stable then
      target.position = {
        casterPosition[1] + skill.caster.direction * 65,
        casterPosition[2]
      }
      target.direction = -skill.caster.direction
      if target[BossFV.auraID] and target[BossFV.auraID].info["Control Effects"][1] ~= "stun" then
        target[BossFV.auraID]:setAttribute("Control Effects", {"stun"})
        target:rebuild()
      end
    end
  end
  local target = skill.target
  if target and target:isAlive() and not target.buff_effects.uncontrollable and (not target.current_skill or not not target.current_skill.info.Interruptable) then
    skill.target:hurt()
  end
  if ed.run_with_scene and BossFV.atkbCameraShakeHList[skill.attack_counter] ~= nil and 0 < BossFV.atkbCameraShakeHList[skill.attack_counter] then
    ed.scene:startCameraShakeAnimationY(BossFV.atkbCameraShakeHList[skill.attack_counter], 0.1, 3)
  end
end

function BossFV.atkb_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local attack_counter = skill.attack_counter
  if BossFV.atkbRatioList[attack_counter] == nil then
    skill.attack_counter = 10
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skillTags = skill.info["Skill Tags"],
    coefficient = BossFV.atkbRatioList[skill.attack_counter] * BossFV.atkbRatio2,
    skill = skill
  })
  return dmg
end

function BossFV.atkb_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  if unit:isAlive() then
    local holdingWeaponPeriod = unit:getHoldingWeaponPeriod()
    unit:enterActionStageFromOneStage(holdingWeaponPeriod, 177)
    local caster = skill.caster
    if caster.name == "Rubick" and caster.FVultOriPos then
      caster:setPosition(caster.FVultOriPos)
      caster.FVultOriPos = nil
    end
  end
end

function BossFV.getLostHPAfterImmunity(basefunc, unit, damage, immunity)
  local lostHP = basefunc(unit, damage, immunity)
  local skillinfo = unit.skills[BossFV.name .. "_atk3"].info
  local holyDodgeRate = skillinfo["Script Arg1"] / 100
  local holyDodge = holyDodgeRate > ed.rand()
  if holyDodge then
    local dodgeDamage = skillinfo["Script Arg2"]
    lostHP = math.max(0, lostHP - dodgeDamage)
    local effect_name = unit.BossFVRage and "eff_impact_FV2_atk3.cha" or skillinfo["Impact Effect"]
    if effect_name and unit.actor then
      local effect_z = skillinfo["Impact Zorder"]
      unit.actor:addEffect(effect_name, effect_z)
    end
  end
  return lostHP
end

function BossFV.return_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.FVultOriPos then
    local nextDirection = caster.FVultOriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.FVultOriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.FVultOriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    BossFV.playBlinkEffect(caster, caster.FVultOriPos, caster.position, nextDirection)
    caster.direction = nextDirection
    caster.position = caster.FVultOriPos
    caster.FVultOriPos = nil
  end
end

function BossFV.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossFV.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
  skill.info["Init CD"] = 99999
end

function BossFV.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.BossFVRage = true
  caster:enterActionStageFromOneStage(caster:getHoldingWeaponPeriod(), 177)
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
  caster.skills[BossFV.name .. "_ult"].cd_remaining = 10
end

function BossFV.init_hero(hero)
  if hero.name ~= "Rubick" then
    hero.ImmuneTimeZone = true
  end
  local skillult = hero.skills[BossFV.name .. "_ult"]
  if skillult then
    hero.DoneRadius = skillult.info["Shape Arg1"]
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossFV.ult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, BossFV.ult_takeEffectAt)
    skillult.start = override(skillult.start, BossFV.ult_start)
    skillult.createBuff = override(skillult.createBuff, BossFV.ult_createBuff)
    skillult.finish = override(skillult.finish, BossFV.ult_finish)
  end
  local skillatkb = hero.skills[BossFV.name .. "_atkb"]
  if skillatkb then
    skillatkb.info["No Dodge"] = true
    skillatkb.onAttackFrame = override(skillatkb.onAttackFrame, BossFV.atkb_onAttackFrame)
    skillatkb.atkb_selectTarget2 = BossFV.atkb_selectTarget2
    skillatkb.getDamage = override(skillatkb.getDamage, BossFV.atkb_getDamage)
    skillatkb.finish = override(skillatkb.finish, BossFV.atkb_finish)
  end
  local skill3 = hero.skills[BossFV.name .. "_atk3"]
  if skill3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, BossFV.getLostHPAfterImmunity)
  end
  local skillreturn = hero.skills[BossFV.name .. "_return"]
  if skillreturn then
    skillreturn.start = override(skillreturn.start, BossFV.return_start)
  end
  local skill6 = hero.skills[BossFV.name .. "_turn"]
  if skill6 then
    skill6.start = override(skill6.start, BossFV.skill6_start)
    skill6.finish = override(skill6.finish, BossFV.skill6_finish)
    skill6.onAttackFrame = override(skill6.onAttackFrame, BossFV.skill6_onAttackFrame)
  end
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, BossFV.reset)
  
  function hero.getHoldingWeaponPeriod(unit)
    return unit.BossFVRage and 3 or 1
  end
  
  function hero.getNoWeaponPeriod(unit)
    return unit.BossFVRage and 4 or 2
  end
  
  function hero.getShadowEffect(unit)
    return unit.BossFVRage and "eff_point_FV2_Shadow.cha" or "eff_point_FV_Shadow.cha"
  end
  
  return hero
end

return BossFV.init_hero
