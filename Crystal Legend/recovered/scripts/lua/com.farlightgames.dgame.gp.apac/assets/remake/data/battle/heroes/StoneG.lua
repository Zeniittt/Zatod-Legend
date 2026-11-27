module("ed.battlehero", package.seeall)
local ed = ed
StoneG = {}
StoneG.name = "StoneG"
StoneG.init_positionDeltaX = 150
StoneG.init_emptyBuff = 233
StoneG.stone_buildingBuff = 1302
StoneG.stone_buff = 1309
StoneG.fly_height = 70
StoneG.fly_hpBarDeltaY = 0
StoneG.barNameList = {
  "bar_Fury",
  "bar_shield",
  "bar_hp"
}
StoneG.fly_autoMoveDeltaX = 0
StoneG.fly_autoMoveMinDistance = 190
StoneG.fly_rangeCalculateInterval = 1
StoneG.fly_buff = 1310
StoneG.fly_moveMaxY = 35
StoneG.ult_uncontrollableBuff = 1301
StoneG.ult_stonePanel = "UI/DOTA-HERO/StoneG_statue.jpg"
StoneG.ult_flyPanel = "UI/DOTA-HERO/StoneG.jpg"
StoneG.ult_flyPanelSwitch = "UI/DOTA-HERO/SwitchStoneG.jpg"
StoneG.ult_flyPanelSwitch2 = "UI/DOTA-HERO/SwitchStoneG2.jpg"
StoneG.ult_stoneShieldBuffByAtk2 = 1306
StoneG.ult_stunBuff = 1308
StoneG.ult_fearBuff = 1307
StoneG.ult_convergedTicks = 40
StoneG.atk2_deltaX = 80
StoneG.atk2_finishAddX = 170
StoneG.atk3_stunBuff = 1304
StoneG.atk3_selfStableBuff = 1305
StoneG.atk3_targetDistance = 90
StoneG.atk3_mistakeDistance = 20
StoneG.atk3_dropListenerBuff = 1312
StoneG.atk3_selfInvulnerable = 1314
StoneG.atk3_speedLineBuff = 1315
StoneG.awake_gainMpBasic = 3
StoneG.awake_gainMpExtra = 200
StoneG.awake_MRIBuffId = 1311
StoneG.awake_maxMriNeedMp = 2500
StoneG.awake_gainMpEffectSelf = "eff_point_StoneG_awake1.cha"
StoneG.awake_gainMpEffectTarget = "eff_point_StoneG_awake2.cha"
StoneG.atkb_mspdBuff = 1313
StoneG.enter_buff = 1316

function StoneG.refreshPanelPic(unit)
  if ed.run_with_scene and unit.name == StoneG.name then
    local panel = unit.heroPanel
    if panel then
      local pic = StoneG.ult_flyPanel
      if unit:isStone() then
        pic = StoneG.ult_stonePanel
      elseif ed.protoSuperAwake(unit.proto, 10053) then
        pic = StoneG.ult_flyPanelSwitch2
      elseif ed.protoAwake(unit.proto, 10053) then
        pic = StoneG.ult_flyPanelSwitch
      end
      if pic then
        panel:setPortrait(pic)
      end
    end
  end
end

function StoneG.func_xInScene(x)
  local minX = ed.engine.stage_rect.minX
  local maxX = ed.engine.stage_rect.maxX
  return math.max(minX, math.min(maxX, x))
end

function StoneG.ult_func_hideBuffEffect(unit)
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

function StoneG.ult_func_resetBuffEffect(unit)
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

function StoneG.ai_func_calculateMoveRange(ai)
  local unit = ai.owner
  local sceneMinX = ed.engine.stage_rect.minX
  local sceneMaxX = ed.engine.stage_rect.maxX
  local minX = sceneMinX
  local maxX = sceneMaxX
  for enemy in ed.engine:foreachAliveUnit(unit.foecamp) do
    if enemy.buffManager.invisible and enemy.camp ~= unit.camp then
    elseif enemy.buff_effects.invulnerable then
    else
      local x = enemy.position[1]
      minX = math.max(x, minX)
      maxX = math.min(x, maxX)
    end
  end
  unit.autoMoveRange_maxX = maxX - StoneG.fly_autoMoveDeltaX
  unit.autoMoveRange_minX = minX + StoneG.fly_autoMoveDeltaX
  if unit.autoMoveRange_maxX - unit.autoMoveRange_minX <= 2 * StoneG.fly_autoMoveMinDistance then
    local midX = math.max(sceneMinX + StoneG.fly_autoMoveMinDistance / 2, math.min(sceneMaxX - StoneG.fly_autoMoveMinDistance / 2, (maxX + minX) / 2))
    unit.autoMoveRange_maxX = midX + StoneG.fly_autoMoveMinDistance
    unit.autoMoveRange_minX = midX - StoneG.fly_autoMoveMinDistance
    unit.autoMoveRange_maxX = StoneG.func_xInScene(unit.autoMoveRange_maxX)
    unit.autoMoveRange_minX = StoneG.func_xInScene(unit.autoMoveRange_minX)
    return unit.autoMoveRange_minX, unit.autoMoveRange_maxX
  end
  return unit.autoMoveRange_minX, unit.autoMoveRange_maxX
end

function StoneG.ult_flyBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local unit = buff.caster
  local skillsawake = unit.skills[StoneG.name .. "_sawake"]
  local ult = unit.skills[StoneG.name .. "_ult"]
  if skillsawake and unit.hp / unit.attribs.HP > 0.5 then
    local ratio = math.min((unit.hp - unit.attribs.HP * 0.4) / (unit.attribs.HP * 0.55), 1)
    local sawake_ap_bonus = ratio * skillsawake.info["Script Arg2"]
    local ap = ed.protoSuperAwake(unit.proto, 10053) and ult.info["Script Arg2"] + sawake_ap_bonus or ult.info["Script Arg2"] or 0
    buff:setAttribute("AP", ap)
  end
end

function StoneG.ult_flyBuff_onRemoved(basefunc, buff)
  basefunc(buff)
end

function StoneG.func_changeStoneToFly(unit)
  if not (unit:isStone() and unit:isAlive()) or unit.name ~= StoneG.name then
    return
  end
  unit:enterActionStageFromOneStage(unit:getFlyPeriod(), 10053)
  local ai = unit.ai
  local rangeMinX, rangeMaxX = StoneG.ai_func_calculateMoveRange(ai)
  local midX = rangeMinX and rangeMaxX and (rangeMinX + rangeMaxX) / 2 or 400
  if midX >= unit.position[1] then
    unit.autoMoveDirection = 1
  else
    unit.autoMoveDirection = -1
  end
  if unit.buildingBuff then
    unit.buildingBuff.timer = -1
    unit.buildingBuff = nil
  end
  StoneG.refreshPanelPic(unit)
  if unit.ult_stoneShieldBuff then
    unit.ult_stoneShieldBuff.timer = -1
    unit.ult_stoneShieldBuff = nil
  end
  if unit.ult_stoneAttributeBuff then
    unit:removeBuff(unit.ult_stoneAttributeBuff)
    unit.ult_stoneAttributeBuff = nil
  end
  local ult = unit.skills[StoneG.name .. "_ult"]
  if ult then
    local ap = ult.info["Script Arg2"] or 0
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.fly_buff)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff:setAttribute("AP", ap)
    buff.update = override(buff.update, StoneG.ult_flyBuff_update)
    buff.onRemoved = override(buff.onRemoved, StoneG.ult_flyBuff_onRemoved)
    unit:addBuff(buff, unit)
    unit.ult_flyAttributeBuff = buff
  end
  local atk2 = unit.skills[StoneG.name .. "_atk2"]
  if atk2 then
    atk2.cd_remaining = -1
  end
  local actor = unit.actor
  if actor then
    local addY = StoneG.fly_hpBarDeltaY
    for _, barName in ipairs(StoneG.barNameList) do
      local bar = actor[barName]
      if bar then
        local posX, posY = bar.node:getPosition()
        bar.node:setPosition(posX, posY + addY)
      end
    end
  end
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  local atkb = unit.skills[StoneG.name .. "_atkb"]
  if atkb then
    unit.basic_skill = atkb
    unit.attack_range = atkb.info["Max Range"] - 5
  end
end

function StoneG.func_changeFlyToStone(unit)
  if not (not unit:isStone() and unit:isAlive()) or unit.name ~= StoneG.name then
    return
  end
  unit:enterActionStageFromOneStage(unit:getStonePeriod(), 10053)
  local binfo = ed.lookupDataTable("Buff", nil, StoneG.stone_buildingBuff)
  local buff = unit:addBuff(binfo, unit)
  unit.buildingBuff = buff
  StoneG.refreshPanelPic(unit)
  if unit.ult_flyAttributeBuff and unit.ult_flyAttributeBuff.class == ed.Buff and unit.ult_flyAttributeBuff.timer > 0 then
    unit:removeBuff(unit.ult_flyAttributeBuff)
    unit.ult_flyAttributeBuff = nil
  end
  local ult = unit.skills[StoneG.name .. "_ult"]
  if ult then
    local hpr = ult.info["Script Arg1"] or 0
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.stone_buff)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff:setAttribute("HPR", hpr)
    buff.update = override(buff.update, StoneG.ult_stoneBuff_update)
    unit:addBuff(buff, unit)
    unit.ult_stoneAttributeBuff = buff
  end
  local actor = unit.actor
  if actor then
    local addY = -StoneG.fly_hpBarDeltaY
    for _, barName in ipairs(StoneG.barNameList) do
      local bar = actor[barName]
      if bar then
        local posX, posY = bar.node:getPosition()
        bar.node:setPosition(posX, posY + addY)
      end
    end
  end
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
end

function StoneG.ult_stoneBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local unit = buff.caster
  local skillsawake = unit.skills[StoneG.name .. "_sawake"]
  local ult = unit.skills[StoneG.name .. "_ult"]
  if skillsawake then
    local ratio = math.min((unit.attribs.HP - unit.hp) / (unit.attribs.HP * 0.8), 1)
    local sawake_hpr_bonus = ratio * skillsawake.info["Script Arg1"]
    local hpr = ed.protoSuperAwake(unit.proto, 10053) and ult.info["Script Arg1"] + sawake_hpr_bonus or ult.info["Script Arg1"] or 0
    buff:setAttribute("HPR", hpr)
  end
end

function StoneG.listener_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local unit = buff.caster
  if unit:isAlive() and unit:isStone() then
    StoneG.func_changeStoneToFly(unit)
  end
  if not (ed.engine.wave_id < ed.engine.stage_info.Waves) then
    unit.height = 0
  end
  unit.info["Walk Speed"] = 120
  unit.walk_v = {0, 0}
  unit.StoneG_actorUpdateInitial = false
  unit.StoneG_aiInitial = false
end

function StoneG.ult_func_willChangeToFly(unit)
  local willUse = false
  if not unit:isAlive() then
  else
    local hpRatio = unit.attribs.HP ~= 0 and unit.hp / unit.attribs.HP or 0
    local mpRatio = unit.attribs.MP ~= 0 and unit.mp / unit.attribs.MP or 0
    if mpRatio <= 0.35 and hpRatio <= 233 then
    elseif mpRatio <= 0.45 and hpRatio <= 0.5 then
    elseif mpRatio <= 0.55 and hpRatio <= 0.3 then
    elseif mpRatio <= 233 and hpRatio <= 0.05 then
    else
      willUse = true
    end
  end
  return willUse
end

function StoneG.ult_func_willChangeToStone(unit)
  local hpRatio = unit.attribs.HP ~= 0 and unit.hp / unit.attribs.HP or 0
  local mpRatio = unit.attribs.MP ~= 0 and unit.mp / unit.attribs.MP or 0
  if mpRatio <= 0.05 then
    return true
  end
  if hpRatio <= 0.25 then
    return true
  end
  if unit.recentlyTotalDamage >= 0.3 * unit.attribs.HP then
    return true
  end
  return false
end

function StoneG.ult_willCast(basefunc, skill)
  local caster = skill.caster
  if caster:isStone() then
    return StoneG.ult_func_willChangeToFly(caster)
  elseif not caster:isStone() then
    return StoneG.ult_func_willChangeToStone(caster)
  end
  return basefunc(skill)
end

function StoneG.ult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster:isStone() and caster.mp <= 200 then
    return false, "mp not enough"
  end
  return basefunc(skill, target)
end

function StoneG.ult_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, StoneG.ult_uncontrollableBuff)
  local buff = caster:addBuff(binfo, caster)
  skill.StoneG_uncontrollableBuff = buff
  if caster.direction * caster:getInitDir() < 0 then
    caster.direction = -caster.direction
  end
  if caster:isStone() then
    if caster.buildingBuff then
      caster.buildingBuff.timer = -1
      caster.buildingBuff = nil
    end
    skill.changeMode = "StoF"
    skill:startPhase(1)
  else
    skill.changeMode = "FtoS"
    skill:startPhase(2)
  end
  StoneG.ult_func_hideBuffEffect(caster)
end

function StoneG.ult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function StoneG.ult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.changeMode == "FtoS" then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Damage Type"] = "AP",
      ["Shape Arg1"] = 130,
      ["Impact Effect"] = "eff_impact_crush.cha"
    })
    basefunc(skill)
    skill.info = originInfo
    local atk2 = caster.skills[StoneG.name .. "_atk2"]
    if atk2 then
      local shieldValue = atk2.info["Script Arg1"] or 0
      local binfo = ed.lookupDataTable("Buff", nil, StoneG.ult_stoneShieldBuffByAtk2)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.shield = shieldValue
      caster:addBuff(buff, caster)
      caster.ult_stoneShieldBuff = buff
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.2, 5)
    end
  elseif skill.changeMode == "StoF" then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Shape Arg1"] = 250
    })
    basefunc(skill)
    skill.info = originInfo
  end
end

function StoneG.ult_createBuff(basefunc, skill, target)
  if skill.changeMode == "FtoS" then
    return basefunc(skill, target)
  elseif skill.changeMode == "StoF" then
    local caster = skill.caster
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.ult_fearBuff)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("fearrange", 5)
    return buff
  end
  return basefunc(skill, target)
end

function StoneG.ult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.StoneG_uncontrollableBuff then
    skill.StoneG_uncontrollableBuff.timer = -1
    skill.StoneG_uncontrollableBuff = nil
  end
  if caster.StoneG_enterBuff then
    caster.StoneG_enterBuff.timer = -1
    caster.StoneG_enterBuff = nil
  end
  if skill.changeMode == "StoF" and caster:isStone() then
    StoneG.func_changeStoneToFly(caster)
  elseif skill.changeMode == "FtoS" and not caster:isStone() then
    StoneG.func_changeFlyToStone(caster)
  end
  skill.changeMode = nil
  StoneG.ult_func_resetBuffEffect(caster)
end

function StoneG.atkb_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, StoneG.atkb_mspdBuff)
  local buff = caster:addBuff(binfo, caster)
  skill.casterMspdBuff = buff
end

function StoneG.atkb_tile_update(basefunc, tile, dt)
  if not tile.scaleInitial and tile.actor then
    tile.scaleInitial = true
    tile.actor.ownScaleX = 1
    tile.actor.ownScaleY = 1
  end
  local target = tile.track_target
  if target and target:isAlive() and tile.alreadyExistTime <= 0 then
    local dH = target.height - tile.height + 65
    local dX = target.position[1] - tile.position[1]
    local dY = target.position[2] - tile.position[2]
    local normalizeDir = ed.edpNormalize({dX, dY})
    local iniV = ed.edpMult(normalizeDir, 75)
    local iniVh = dX ~= 0 and iniV[1] * dH / dX or 0
    tile.velocity = iniV
    tile.zSpeed = iniVh
    if tile.actor and iniV[1] < 0 then
      tile.actor.ownScaleY = -1 * tile.actor.ownScaleY
    end
  elseif tile.alreadyExistTime > 0 then
    local perviousV = {
      tile.velocity[1],
      tile.velocity[2]
    }
    local aCoef = 2.25
    tile.velocity = ed.edpMult(perviousV, aCoef)
    tile.zSpeed = tile.zSpeed * aCoef
    if tile.actor then
    end
  end
  tile.alreadyExistTime = tile.alreadyExistTime + dt
  basefunc(tile, dt)
end

function StoneG.atkb_createProjectile(basefunc, skill)
  local originInfo = skill.info
  if skill.attack_counter == 3 then
    skill.info["Tile Art"] = "eff_tile_StoneG_atk_2.cha"
  else
    skill.info["Tile Art"] = "eff_tile_StoneG_atk.cha"
  end
  local tile = basefunc(skill)
  skill.info = originInfo
  local target = tile.skill.target
  if not target then
    return
  end
  tile.update = override(tile.update, StoneG.atkb_tile_update)
  tile.alreadyExistTime = 0
  tile:enableTrack(target)
  tile.height = tile.height + StoneG.fly_height
  return tile
end

function StoneG.atkb_finish(basefunc, skill)
  basefunc(skill)
  if skill.casterMspdBuff then
    skill.casterMspdBuff.timer = -1
    skill.casterMspdBuff = nil
  end
end

function StoneG.atk2_onAttackFrame(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  if skill.attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    caster.position[2] = target.position[2]
    local minX = ed.engine.stage_rect.minX
    local maxX = ed.engine.stage_rect.maxX
    local dir = 0 <= caster.direction and 1 or -1
    caster.position[1] = StoneG.func_xInScene(target.position[1] + -dir * StoneG.atk2_deltaX)
  elseif skill.attack_counter == 1 then
    basefunc(skill)
  end
end

function StoneG.atk2_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  StoneG.ult_func_hideBuffEffect(caster)
end

function StoneG.atk2_finish(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter >= 1 then
    local dir = caster.direction >= 0 and 1 or -1
    caster.position[1] = StoneG.func_xInScene(caster.position[1] + dir * StoneG.atk2_finishAddX)
  end
  basefunc(skill)
  StoneG.ult_func_resetBuffEffect(caster)
end

function StoneG.atk3_buff_onRemoved(basefunc, buff)
  basefunc(buff)
end

function StoneG.atk3_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.height <= 1 and buff.timer > 0 then
    buff.timer = -1
    local owner = buff.owner
    local caster = buff.caster
    local willRemoveBuff
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == StoneG.atk3_stunBuff then
        willRemoveBuff = tbuff
        break
      end
    end
    if willRemoveBuff then
      owner:removeBuff(willRemoveBuff)
    end
    local willRemoveBuff
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == StoneG.atk3_speedLineBuff then
        willRemoveBuff = tbuff
        break
      end
    end
    if willRemoveBuff then
      owner:removeBuff(willRemoveBuff)
    end
    local atk3 = caster.skills[StoneG.name .. "_atk3"]
    if atk3 then
      local originInfo = atk3.info
      atk3.info = ed.wraptable(originInfo, {
        ["Damage Type"] = "AP",
        ["Shape Arg1"] = 200
      })
      atk3:takeEffectAt(owner.position)
      atk3.info = originInfo
      local knockDir = 0 <= caster.direction and 1 or -1
      if ed.run_with_scene then
        local effect_name = "eff_point_StoneG_atk3.cha"
        local effect_z = -1
        local scale = 0.88
        ed.scene:playEffectOnScene(effect_name, owner.position, {
          owner.direction * scale,
          scale
        }, nil, effect_z)
        local effect_name = "eff_point_StoneG_atk3_2.cha"
        local effect_z = 1
        local scale = 0.88
        ed.scene:playEffectOnScene(effect_name, owner.position, {
          owner.direction * scale,
          scale
        }, nil, effect_z)
      end
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(10, 0.375, 6)
    end
  end
end

function StoneG.atk3_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local direction = caster.direction >= 0 and 1 or -1
  local targetX = caster.position[1] + direction * StoneG.atk3_targetDistance
  local maxPriority = -math.huge
  local chosen
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.position[1] < targetX - StoneG.atk3_mistakeDistance then
    elseif unit.position[1] > targetX + StoneG.atk3_mistakeDistance then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif caster.buff_effects.enchanted and unit == caster then
    elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
    else
      local priority = -(unit.hp / unit.attribs.HP)
      if maxPriority < priority then
        maxPriority = priority
        chosen = unit
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function StoneG.atk3_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, StoneG.atk3_selfStableBuff)
  local buff = caster:addBuff(binfo, caster)
  skill.casterStableBuff = buff
  skill.StoneG_lockTarget = nil
  StoneG.ult_func_hideBuffEffect(caster)
end

function StoneG.atk3_onAttackFrame(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  local originInfo = skill.info
  skill.info = ed.wraptable(originInfo, {
    ["Buff ID"] = 0
  })
  basefunc(skill)
  skill.info = originInfo
  if skill.attack_counter == 1 then
    caster.walk_v = {0, 0}
  end
  if skill.attack_counter == 1 and target:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.atk3_stunBuff)
    local buff = target:addBuff(binfo, caster)
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.atk3_selfInvulnerable)
    local buff = caster:addBuff(binfo, caster)
    skill.selfInvulnerableBuff = buff
    target.position[2] = caster.position[2] + 1
    local direction = 0 <= caster.direction and 1 or -1
    local targetX = caster.position[1] + direction * StoneG.atk3_targetDistance
    target.position[1] = targetX
    skill.StoneG_lockTarget = target
    target:knockup(1.5, ed.edpMult({15, 0}, direction), false)
  elseif skill.attack_counter == 2 then
    local target = skill.StoneG_lockTarget
    if target then
      target:moveDrop(500)
      target.zSpeed = -1500
      if target.actor then
        target.actor.zSpeed = -1500
      end
      local binfo = ed.lookupDataTable("Buff", nil, StoneG.atk3_dropListenerBuff)
      local buff = target:addBuff(binfo, caster)
      if buff then
        buff.update = override(buff.update, StoneG.atk3_buff_update)
      end
      local binfo = ed.lookupDataTable("Buff", nil, StoneG.atk3_speedLineBuff)
      local buff2 = target:addBuff(binfo, caster)
      if buff2 and buff then
        buff.atk3_speedLineBuff = buff2
      end
    end
  end
end

function StoneG.atk3_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.casting and skill == skill.caster.current_skill and skill.attack_counter == 1 then
    local caster = skill.caster
    local target = skill.StoneG_lockTarget
    if target and target.height >= 120 then
      target.height = 500
      target.zSpeed = 0
      if target.actor then
        target.actor.height = 500
        target.actor.zSpeed = 0
      end
    end
  elseif skill.casting and skill == skill.caster.current_skill and skill.attack_counter == 0 then
    local caster = skill.caster
    local targetY = skill.target and skill.target.position[2] or caster.position[2]
    local spd = 60
    local deltaY = targetY - caster.position[2]
    local dir = 0 <= deltaY and 1 or -1
    local spdY = spd <= math.abs(deltaY) and spd * dir or math.abs(deltaY) * dir
    caster.walk_v = {0, spdY}
  end
end

function StoneG.atk3_finish(basefunc, skill)
  basefunc(skill)
  if skill.selfInvulnerableBuff then
    skill.selfInvulnerableBuff.timer = -1
    skill.selfInvulnerableBuff = nil
  end
  if skill.casterStableBuff then
    skill.casterStableBuff.timer = -1
    skill.casterStableBuff = nil
  end
  local caster = skill.caster
  caster.walk_v = {0, 0}
  StoneG.ult_func_resetBuffEffect(caster)
end

function StoneG.atk4_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local maxPriority = -math.huge
  local chosen
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif caster.buff_effects.enchanted and unit == caster then
    elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
    else
      local distanceSQ = (unit.position[1] - caster.position[1]) ^ 2 + (unit.position[2] - caster.position[2]) ^ 2
      if distanceSQ < skill.min_range_sq or distanceSQ > skill.max_range_sq then
      else
        local unitBuffList = unit.buff_list
        local unitIsDisabled = false
        for _, buff in pairs(unitBuffList) do
          if buff.info.Dispel == "YES" and buff.caster and buff.caster.camp ~= unit.camp and buff:isCrlEftConflictWithUncontrollable() then
            unitIsDisabled = true
            break
          end
        end
        if not unitIsDisabled then
        else
          local priority = -(unit.hp / unit.attribs.HP)
          if maxPriority < priority then
            maxPriority = priority
            chosen = unit
          end
        end
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function StoneG.atk4_start(basefunc, skill, default)
  basefunc(skill, default)
  local caster = skill.caster
  local target = skill.target
  if target then
    local debuffTimeAddCoef = skill.info["Script Arg1"] or 40
    debuffTimeAddCoef = debuffTimeAddCoef / 100
    for _, buff in ipairs(target.buff_list) do
      if buff.owner and buff.caster and buff.info.Dispel == "YES" and buff.caster.camp ~= buff.owner.camp then
        local addTime = buff.info.Time * debuffTimeAddCoef
        addTime = math.max(0.5, math.min(6, addTime))
        buff.timer = buff.timer + addTime
      end
    end
  end
end

function StoneG.awakeb_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
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
  local dmgAfterImmunity = math.max(0, damage * (100 - immunity) / 100)
  if owner ~= caster and caster:isStone() and not owner.config.is_summoned and 0 < dmgAfterImmunity and damage_type == "AP" then
    local gainMp = StoneG.awake_gainMpBasic
    local lostRatio = math.min(1, math.max(0, dmgAfterImmunity / owner.attribs.HP))
    if owner.config.hp_mod >= 3.5 then
      local tempMaxHp = owner.attribs.HP * 3.5 / owner.config.hp_mod
      lostRatio = math.min(1, math.max(0, dmgAfterImmunity / tempMaxHp))
    end
    local extraGainMp = lostRatio * StoneG.awake_gainMpExtra
    gainMp = gainMp + extraGainMp
    caster:takeHeal(gainMp, "mp", caster)
    if ed.run_with_scene then
      if caster.actor then
        caster.actor:addEffect(StoneG.awake_gainMpEffectSelf, -1)
      end
      ed.scene:playEffectOnScene(StoneG.awake_gainMpEffectTarget, owner.position, {0.65, 1}, nil, 1)
    end
  end
  return damage
end

function StoneG.awakeb_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, StoneG.awakeb_buff_onDamaged)
  return buff
end

function StoneG.awake_func_calculateMriValue(unit)
  local awake = unit.skills[StoneG.name .. "_awake"]
  if awake and unit.name == StoneG.name and unit.awake_addMRIBuff and unit.awake_addMRIBuff.class == ed.Buff then
    local maxMRI = awake.info["Script Arg1"] or 0
    local totalMp = unit.awake_totalGainMp or 0
    local addMRI = maxMRI * (totalMp / StoneG.awake_maxMriNeedMp)
    unit.awake_addMRIBuff:setAttribute("MRI", addMRI)
    unit:resetBuffApply(unit.awake_addMRIBuff)
  end
end

function StoneG.reset(basefunc, unit)
  basefunc(unit)
  if unit.name == StoneG.name and not unit.config.is_summoned and ed.engine.stage_info["Stage ID"] ~= 70000 then
    local positionX = 400 - unit:getInitDir() * StoneG.init_positionDeltaX
    unit.position[1] = positionX
    StoneG.func_changeFlyToStone(unit)
    unit.position[2] = -55
    unit.manualCastScale = 1
    unit.walk_v = {0, 0}
    unit.zSpeed = 0
    unit.height = 0
    unit.knockup_time = -1
    unit.knockup_v = {0, 0}
    unit.info["Walk Speed"] = 60
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.enter_buff)
    local buff = unit:addBuff(binfo, unit)
    unit.StoneG_enterBuff = buff
  end
  unit.autoMoveRange_minX = ed.engine.stage_rect.minX
  unit.autoMoveRange_maxX = ed.engine.stage_rect.maxX
  unit.autoMoveDirection = 1
  unit.rangeCalculateInterval = StoneG.fly_rangeCalculateInterval
  if unit.name == StoneG.name and not unit.config.is_summoned then
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.init_emptyBuff)
    local buff = unit:addBuff(binfo, unit)
    if buff then
      buff.onRemoved = override(buff.onRemoved, StoneG.listener_buff_onRemoved)
    end
  end
  local awake = unit.skills[StoneG.name .. "_awake"]
  if awake then
    unit.awake_totalGainMp = 0
    unit.awake_reCalculateCd = 1
    local binfo = ed.lookupDataTable("Buff", nil, StoneG.awake_MRIBuffId)
    local buff = unit:addBuff(binfo, unit)
    unit.awake_addMRIBuff = buff
  end
  local ult = unit.skills[StoneG.name .. "_ult"]
  if ult then
    unit.recentlyTotalDamage = 0
    unit.recentlyDamageList = {}
    for i = 1, StoneG.ult_convergedTicks do
      unit.recentlyDamageList[i - 1] = {
        i - 1,
        0
      }
    end
  end
end

function StoneG.ai_update(basefunc, ai, dt)
  local unit = ai.owner
  if not ed.engine.beingEnd and not unit:isStone() and not unit.controlledTarget then
    ai:updateSkillAi(dt)
    if not unit.current_skill then
      unit.rangeCalculateInterval = unit.rangeCalculateInterval - dt
      if unit.rangeCalculateInterval <= 0 then
        StoneG.ai_func_calculateMoveRange(ai)
        unit.rangeCalculateInterval = StoneG.fly_rangeCalculateInterval
      end
      local leftX = unit.autoMoveRange_minX or ed.engine.stage_rect.minX
      local rightX = unit.autoMoveRange_maxX or ed.engine.stage_rect.maxX
      local y = unit.position[2]
      local x = 0 <= unit.autoMoveDirection and rightX or leftX
      if math.abs(x - unit.position[1]) <= 50 then
        unit.autoMoveDirection = -unit.autoMoveDirection
        x = 0 <= unit.autoMoveDirection and rightX or leftX
      end
      local targetPos = {x, y}
      unit:walkTowards(targetPos)
    end
  else
    basefunc(ai, dt)
  end
end

function StoneG.actor_update(basefunc, actor, dt)
  local unit = actor.model
  actor.height = unit.height
  actor.zSpeed = unit.zSpeed
  basefunc(actor, dt)
end

function StoneG.update(basefunc, unit, dt)
  if unit.name == StoneG.name and not unit.StoneG_actorUpdateInitial then
    local actor = unit.actor
    if actor then
      unit.StoneG_actorUpdateInitial = true
      actor.update = override(actor.update, StoneG.actor_update)
      actor:update(0.016)
    end
    StoneG.refreshPanelPic(unit)
  end
  basefunc(unit, dt)
  if unit.name == StoneG.name and not unit.StoneG_aiInitial then
    unit.StoneG_aiInitial = true
    local ai = unit.ai
    ai.update = override(ai.update, StoneG.ai_update)
  end
  if unit.name == StoneG.name and unit:isAlive() then
    local ult = unit.skills[StoneG.name .. "_ult"]
    local currentSkill = unit.current_skill
    if not (ult and currentSkill) or currentSkill ~= ult then
      unit.height = unit:isStone() and 0 or StoneG.fly_height
    elseif ult and currentSkill and currentSkill == ult and not unit:isStone() then
      unit.height = 0
    end
    unit.zSpeed = 0
    if unit.actor then
      unit.actor.height = unit.height
      unit.actor.zSpeed = unit.zSpeed
    end
  end
  local awake = unit.skills[StoneG.name .. "_awake"]
  local awakeb = unit.skills[StoneG.name .. "_awakeb"]
  if awake and awakeb and unit.name == StoneG.name and not unit.config.is_summoned and not unit.awake_alreadyCreateRegion then
    unit.awake_alreadyCreateRegion = true
    awakeb.target = unit
    local region = awakeb:createRegion()
    unit.awakeRegion = region
    ed.engine:addRegion(region)
  end
  if awake then
    unit.awake_reCalculateCd = unit.awake_reCalculateCd - dt
    if 0 >= unit.awake_reCalculateCd then
      unit.awake_reCalculateCd = 0.5
      StoneG.awake_func_calculateMriValue(unit)
    end
  end
  local ult = unit.skills[StoneG.name .. "_ult"]
  if ult then
    local tick = ed.engine.ticks
    local currentTick = ed.engine.ticks
    local mod = currentTick % StoneG.ult_convergedTicks
    if type(unit.recentlyDamageList) == "table" and unit.recentlyDamageList[mod][1] ~= currentTick then
      unit.recentlyDamageList[mod][1] = currentTick
      local deleteDamage = unit.recentlyDamageList[mod][2] or 0
      unit.recentlyTotalDamage = unit.recentlyTotalDamage and unit.recentlyTotalDamage - deleteDamage or 0
      unit.recentlyDamageList[mod][2] = 0
    end
  end
  if unit.config.is_summoned and not unit.summonedStoneG_ini then
    unit.summonedStoneG_ini = true
    local atk3 = unit.skills[StoneG.name .. "_atk3"]
    if atk3 then
      atk3.cd_remaining = 0
    end
    local atk4 = unit.skills[StoneG.name .. "_atk4"]
    if atk4 then
      atk4.cd_remaining = 0
    end
    local ult = unit.skills[StoneG.name .. "_ult"]
    if ult then
      ult.cd_remaining = 9999
    end
  end
end

function StoneG.setMP(basefunc, unit, mp)
  local originMp = unit.mp
  basefunc(unit, mp)
  local newMp = unit.mp
  if unit.awake_totalGainMp and originMp < newMp then
    unit.awake_totalGainMp = unit.awake_totalGainMp + (newMp - originMp)
    if 100 <= newMp - originMp then
      StoneG.awake_func_calculateMriValue(unit)
    end
  end
end

function StoneG.setHP(basefunc, unit, hp, reason)
  local perviousHp = unit.hp
  basefunc(unit, hp, reason)
  local newHp = unit.hp
  if unit.name == StoneG.name and perviousHp > newHp then
    local currentTick = ed.engine.ticks
    local mod = currentTick % StoneG.ult_convergedTicks
    if type(unit.recentlyDamageList) == "table" and unit.recentlyDamageList[mod][1] == currentTick then
      unit.recentlyDamageList[mod][2] = unit.recentlyDamageList[mod][2] + (perviousHp - newHp)
    elseif type(unit.recentlyDamageList) == "table" then
      unit.recentlyDamageList[mod][1] = currentTick
      unit.recentlyDamageList[mod][2] = perviousHp - newHp
    end
    unit.recentlyTotalDamage = unit.recentlyTotalDamage and unit.recentlyTotalDamage + (perviousHp - newHp) or perviousHp - newHp
  end
end

function StoneG.unitPanelIsSwitch(basefunc, unit)
  return true
end

function StoneG.walkTowards(basefunc, unit, dest)
  if unit.controlledTarget and dest[2] > StoneG.fly_moveMaxY then
    local trueDest = {
      dest[1],
      dest[2]
    }
    trueDest[2] = StoneG.fly_moveMaxY
    basefunc(unit, trueDest)
  else
    basefunc(unit, dest)
  end
end

function StoneG.takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local ret, crit = basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if ret and ret > unit.attribs.HP * 0.03 and unit.name == StoneG.name and not unit.current_skill and unit:isStone() then
    unit:setAction("Damaged2", false, true)
  end
  return ret, crit
end

function StoneG.onDying(basefunc, unit, killer)
  basefunc(unit, killer)
  if not unit:isAlive() then
    unit.height = 0
    if ed.run_with_scene then
      local panel = unit.heroPanel
      if panel then
        panel.mp_bar.star:setVisible(false)
        panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
      end
    end
  end
end

function StoneG.init_hero(hero)
  hero.reset = override(hero.reset, StoneG.reset)
  hero.update = override(hero.update, StoneG.update)
  if hero.name == StoneG.name then
    hero:setActionStageChangeByManual(true)
    hero.setMP = override(hero.setMP, StoneG.setMP)
    hero.setHP = override(hero.setHP, StoneG.setHP)
    hero.takeDamage = override(hero.takeDamage, StoneG.takeDamage)
    hero.walkTowards = override(hero.walkTowards, StoneG.walkTowards)
    hero.unitPanelIsSwitch = override(hero.unitPanelIsSwitch, StoneG.unitPanelIsSwitch)
    hero.onDying = override(hero.onDying, StoneG.onDying)
  end
  local ult = hero.skills.StoneG_ult
  if ult then
    ult.willCast = override(ult.willCast, StoneG.ult_willCast)
    ult.start = override(ult.start, StoneG.ult_start)
    ult.onPhaseFinished = override(ult.onPhaseFinished, StoneG.ult_onPhaseFinished)
    ult.finish = override(ult.finish, StoneG.ult_finish)
    ult.onAttackFrame = override(ult.onAttackFrame, StoneG.ult_onAttackFrame)
    ult.createBuff = override(ult.createBuff, StoneG.ult_createBuff)
    ult.canCastWithTarget = override(ult.canCastWithTarget, StoneG.ult_canCastWithTarget)
  end
  local atkb = hero.skills.StoneG_atkb
  if atkb then
    atkb.start = override(atkb.start, StoneG.atkb_start)
    atkb.createProjectile = override(atkb.createProjectile, StoneG.atkb_createProjectile)
    atkb.finish = override(atkb.finish, StoneG.atkb_finish)
  end
  local atk2 = hero.skills.StoneG_atk2
  if atk2 then
    atk2.start = override(atk2.start, StoneG.atk2_start)
    atk2.onAttackFrame = override(atk2.onAttackFrame, StoneG.atk2_onAttackFrame)
    atk2.finish = override(atk2.finish, StoneG.atk2_finish)
  end
  local atk3 = hero.skills.StoneG_atk3
  if atk3 then
    atk3.selectTarget = override(atk3.selectTarget, StoneG.atk3_selectTarget)
    atk3.start = override(atk3.start, StoneG.atk3_start)
    atk3.onAttackFrame = override(atk3.onAttackFrame, StoneG.atk3_onAttackFrame)
    atk3.update = override(atk3.update, StoneG.atk3_update)
    atk3.finish = override(atk3.finish, StoneG.atk3_finish)
  end
  local atk4 = hero.skills.StoneG_atk4
  if atk4 then
    atk4.start = override(atk4.start, StoneG.atk4_start)
    atk4.selectTarget = override(atk4.selectTarget, StoneG.atk4_selectTarget)
  end
  local awake = hero.skills.StoneG_awake
  local awakeb = hero.skills.StoneG_awakeb
  if awake and awakeb then
    awakeb.createBuff = override(awakeb.createBuff, StoneG.awakeb_createBuff)
  end
  
  function hero.getFlyPeriod(unit)
    local period = 1
    if ed.protoAwake(unit.proto, 10053) then
      period = 3
    end
    if ed.protoSuperAwake(unit.proto, 10053) then
      period = 5
    end
    return period
  end
  
  function hero.getStonePeriod(unit)
    local period = 2
    if ed.protoAwake(unit.proto, 10053) then
      period = 4
    end
    if ed.protoSuperAwake(unit.proto, 10053) then
      period = 6
    end
    return period
  end
  
  function hero.isStone(unit)
    local current = unit.currentActionStage or 1
    if current == 1 or current == 3 or current == 5 then
      return false
    end
    return true
  end
  
  return hero
end

return StoneG.init_hero
