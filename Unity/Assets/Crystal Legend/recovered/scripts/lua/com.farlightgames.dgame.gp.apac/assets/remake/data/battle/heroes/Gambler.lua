module("ed.battlehero", package.seeall)
local ed = ed
Gambler = {}
Gambler.chipCountMax = 10
Gambler.chipCountMin = 0
Gambler.chipIni = 3
Gambler.chipBoxPic = "UI/alpha/1080P/shop_refresh_button_down.png"
Gambler.chipPic = "UI/alpha/1080P/battle_special/chip.png"
Gambler.chipUIPosition = {
  {-35, 14},
  {-27, 14},
  {-19, 14},
  {-11, 14},
  {-3, 14},
  {5, 14},
  {13, 14},
  {21, 14},
  {29, 14},
  {37, 14}
}
Gambler.getChipEffect = "eff_buff_Gambler_atk4_getChip.cha"
Gambler.loseChipEffect = "eff_impact_Gambler_ult.cha"
Gambler.diceUIPosition = {
  {-26, 56},
  {0, 56},
  {26, 56}
}
Gambler.diceRollingBuff = 883
Gambler.diceRollBuffId_1 = 867
Gambler.diceResultPicList = {
  [1] = "UI/alpha/1080P/battle_special/dice1.png",
  [2] = "UI/alpha/1080P/battle_special/dice2.png",
  [3] = "UI/alpha/1080P/battle_special/dice3.png",
  [4] = "UI/alpha/1080P/battle_special/dice4.png",
  [5] = "UI/alpha/1080P/battle_special/dice5.png",
  [6] = "UI/alpha/1080P/battle_special/dice6.png",
  [7] = "UI/alpha/1080P/battle_special/dice7.png"
}
Gambler.diceRollBuffScale = 1
Gambler.diceRollBuffDeltaY = 20
Gambler.dtCount = 1
Gambler.emptyBuffID = 233
Gambler.atk2_cheatCoef = 0.48
Gambler.atk2_cheatMax = 0.7
Gambler.atk2_enhancedBuffId = 878
Gambler.atk2_hurtSelfCoef = 0.65
Gambler.atk3_invulnerableBuffId = 874
Gambler.atk3_extraDamageCoef = 0.08
Gambler.atk3_lfsRatio = 0.4
Gambler.atk3_hitPercent = 0.5
Gambler.atk4_diceMaxCount = 3
Gambler.atk4_identicalCoef = 2
Gambler.ult_interval = 0.75
Gambler.ult_minAccuracy = 0.25
Gambler.ult_maxAccuracy = 1
Gambler.ult_minRatio = 0.3
Gambler.ult_maxRatio = 0.55
Gambler.ult_uncontrollableBuffId = 876
Gambler.ult_extraDamageCoef = 0.15
Gambler.ult_aimBuffId = 881
Gambler.ult_triggerPointEffect = "eff_point_Gambler_ult.cha"
Gambler.ult_stackBuffId = 882
Gambler.ult_impactEffect = "eff_impact_Gambler_ult.cha"
Gambler.ult_pointEffectCorrect = "eff_point_Gambler_ult_correct.cha"
Gambler.ult_pointEffectFail = "eff_point_Gambler_ult_error.cha"
Gambler.ult_bingoBoom = "eff_point_Gambler_ult2.cha"
Gambler.ult_lfsRatio = 0.4
Gambler.ult_cryBuffId = 875
Gambler.ult_highlightEffectBuffId = 879
Gambler.ult_chipCondition = 7
Gambler.awake_minHpRatio = 0.3
Gambler.awake_buffId = 877
Gambler.awake_addChipCondition = 6
Gambler.awake_addChipCd = 7
Gambler.awake_calculateCd = 1

function Gambler.removeUIPicture(unit, clearDice, clearChip)
  if ed.run_with_scene then
    if clearDice and (not ed.engine.multiplayerMode or not not ed.multiplayer_battle:isMyHero(unit.tid)) then
      local dicePicList = unit.Gambler_dicePicList
      local count = dicePicList and #dicePicList or 0
      if 0 < count then
        for i, pic in ipairs(dicePicList) do
          pic:removeFromParentAndCleanup(true)
          unit.Gambler_dicePicList[i] = nil
        end
      end
    end
    if clearChip then
      local chipPicList = unit.Gambler_chipList
      local count = chipPicList and #chipPicList or 0
      if 0 < count then
        for i, pic in ipairs(chipPicList) do
          pic:removeFromParentAndCleanup(true)
          unit.Gambler_chipList[i] = nil
        end
      end
    end
  end
end

function Gambler.chipPicFix(hero, logicCount)
  local picList = hero.Gambler_chipList
  Gambler.removeUIPicture(hero, false, true)
  hero.Gambler_chipList = {}
  for i = 1, logicCount do
    local icon = hero.heroPanel and hero.heroPanel.node
    if icon then
      local newChip = ed.createSprite(Gambler.chipPic, icon)
      local pos = Gambler.chipUIPosition[i] or {0, 0}
      pos = ccp(pos[1], pos[2])
      newChip:setPosition(pos)
      newChip:setScaleX(-1)
      icon:addChild(newChip, 5)
      hero.Gambler_chipList[i] = newChip
    end
  end
end

function Gambler.changeChip(hero, amount, noEffect)
  local currentChipCount = hero.Gambler_chipCount
  if hero.name == "Gambler" and hero.Gambler_chipCount and amount ~= 0 then
    local newCount = hero.Gambler_chipCount + amount
    newCount = math.max(math.min(newCount, Gambler.chipCountMax), Gambler.chipCountMin)
    local deltaAmount = newCount - currentChipCount
    if ed.run_with_scene then
      if 0 < deltaAmount then
        if not noEffect then
          ed.scene:playEffectOnScene(Gambler.getChipEffect, hero.position, {
            hero.direction,
            1
          }, nil, 1)
        end
        for i = 1, deltaAmount do
          local icon = hero.heroPanel and hero.heroPanel.node
          if icon then
            local newChip = ed.createSprite(Gambler.chipPic, icon)
            local pos = Gambler.chipUIPosition[currentChipCount + i] or {0, 0}
            pos = ccp(pos[1], pos[2])
            newChip:setPosition(pos)
            newChip:setScaleX(-1)
            newChip:setOpacity(0)
            local fadeIn = CCFadeIn:create(0.8)
            newChip:runAction(fadeIn)
            icon:addChild(newChip, 5)
            hero.Gambler_chipList[currentChipCount + i] = newChip
          end
        end
      elseif deltaAmount < 0 then
        if not noEffect then
          ed.scene:playEffectOnScene(Gambler.loseChipEffect, hero.position, {
            hero.direction,
            1
          }, nil, 1)
        end
        for i = 1, -deltaAmount do
          local loseChip = hero.Gambler_chipList[currentChipCount + 1 - i]
          if loseChip then
            loseChip:stopAllActions()
            local fadeOut = CCFadeOut:create(0.3)
            local move = CCMoveBy:create(0.3, ccp(0, 40))
            local spawn = CCSpawn:create(ccArrayMake(fadeOut, move))
            local action = CCEaseSineInOut:create(spawn)
            local delay = CCDelayTime:create((i - 1) * 0.1)
            local seq = CCSequence:create(ccArrayMake(delay, action))
            seq = CCSequence:createWithTwoActions(seq, CCCallFunc:create(function()
              loseChip:removeFromParentAndCleanup(true)
            end))
            loseChip:runAction(seq)
            hero.Gambler_chipList[currentChipCount + 1 - i] = nil
          end
        end
      end
    end
    hero.Gambler_chipCount = newCount
  end
end

function Gambler.diceRoll(cheatPrecent)
  local cheatRand = ed.rand()
  local cheat = cheatPrecent >= cheatRand and true or false
  local result = 1
  if cheat then
    result = 7
  else
    result = math.ceil(ed.rand() * 6)
  end
  return result, cheat
end

function Gambler.diceDelete(hero, code)
  if ed.run_with_scene and (not ed.engine.multiplayerMode or not not ed.multiplayer_battle:isMyHero(hero.tid)) then
    local removeDice = hero.Gambler_dicePicList[code]
    if removeDice then
      local action = CCFadeOut:create(0.3)
      action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
        removeDice:removeFromParentAndCleanup(true)
      end))
      removeDice:runAction(action)
      hero.Gambler_dicePicList[code] = nil
    end
  end
end

function Gambler.diceMove(hero, currentCode, newCode)
  if ed.run_with_scene then
    local icon = hero.heroPanel and hero.heroPanel.btn
    if ed.engine.multiplayerMode and not ed.multiplayer_battle:isMyHero(hero.tid) then
      icon = nil
    end
    if icon then
      local moveDice = hero.Gambler_dicePicList[currentCode]
      if moveDice then
        local deltaP = Gambler.diceUIPosition[newCode]
        local targetPosition = ccpAdd(icon:getParent():convertToWorldSpace(ccp(icon:getPosition())), ccp(deltaP[1], deltaP[2]))
        local action = CCMoveTo:create(0.3, targetPosition)
        moveDice:runAction(action)
        hero.Gambler_dicePicList[newCode] = moveDice
        hero.Gambler_dicePicList[currentCode] = nil
      end
    end
  end
end

function Gambler.diceAdd(hero, result, newCode)
  if ed.run_with_scene then
    local icon = hero.heroPanel and hero.heroPanel.btn
    if ed.engine.multiplayerMode and not ed.multiplayer_battle:isMyHero(hero.tid) then
      icon = nil
    end
    local pic = Gambler.diceResultPicList[result]
    if icon and pic then
      local newDice = ed.createSprite(pic, icon)
      local deltaP = Gambler.diceUIPosition[newCode]
      local targetPosition = ccpAdd(icon:getParent():convertToWorldSpace(ccp(icon:getPosition())), ccp(deltaP[1], deltaP[2]))
      local iniPostion = ccpAdd(targetPosition, ccp(0, 60))
      newDice:setPosition(iniPostion)
      newDice:setScale(1)
      ed.sceneui.ui_layer:addChild(newDice)
      local move = CCMoveTo:create(0.6, targetPosition)
      local fade = CCFadeIn:create(0.6)
      local spawn = CCSpawn:create(ccArrayMake(move, fade))
      local action = CCEaseSineOut:create(spawn)
      newDice:runAction(action)
      hero.Gambler_dicePicList[newCode] = newDice
    end
  end
end

function Gambler.dicePatternCheck(hero)
  local currentDiceList = hero.Gambler_diceList
  local newDiceCode = #currentDiceList
  local newDice = currentDiceList[newDiceCode]
  if newDiceCode and newDice then
    local num = newDice
    local patternCodeList = {newDiceCode}
    for code = 1, newDiceCode - 1 do
      if currentDiceList[code] == newDice then
        table.insert(patternCodeList, code)
      end
    end
    local pattern = #patternCodeList
    hero.Gambler_dicePattern = pattern
    hero.Gambler_dicePatternCode = patternCodeList
    hero.Gambler_dicePatternNum = num
    return pattern, patternCodeList
  end
  return nil, nil
end

function Gambler.diceRollBuff_update(basefunc, buff, dt)
  if ed.engine.freeze_level > 0 then
    buff.timer = buff.timer + dt
  end
  basefunc(buff, dt)
end

function Gambler.diceRollBuff_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  local usedByAtk4 = buff.Gambler_usedByAtk4
  local skillatk4 = owner.skills.Gambler_atk4
  if usedByAtk4 and skillatk4 and owner:isAlive() and not ed.engine.beingEnd and caster == owner and owner.Gambler_diceList then
    local diceList = owner.Gambler_diceList
    local maxCode = Gambler.atk4_diceMaxCount
    local diceCount = 0
    if diceList[maxCode] then
      Gambler.diceDelete(owner, 1)
      for code = 1, maxCode - 1 do
        Gambler.diceMove(owner, code + 1, code)
        diceList[code] = diceList[code + 1]
      end
      local result = buff.Gambler_diceResult or nil
      Gambler.diceAdd(owner, result, maxCode)
      diceList[maxCode] = result
    elseif not diceList[maxCode] then
      for code = 1, maxCode do
        if not diceList[code] then
          local result = buff.Gambler_diceResult or nil
          Gambler.diceAdd(owner, result, code)
          diceList[code] = result
          break
        end
      end
    end
    local pattern, patternCodeList = Gambler.dicePatternCheck(owner)
  end
  owner.Gambler_diceRollBuff = nil
  basefunc(buff)
end

function Gambler.rollingBuff_update(basefunc, buff, dt)
  if buff.timer and buff.timer - Gambler.dtCount * dt < 0 and buff.Gambler_rollPhase ~= "end" then
    local result = buff.Gambler_diceResult
    local owner = buff.owner
    buff.Gambler_rollPhase = "end"
    owner.Gambler_diceRollBuff = nil
    if result then
      local buffId = Gambler.diceRollBuffId_1 - 1 + result
      local binfo = ed.lookupDataTable("Buff", nil, buffId)
      local newbuff = owner:addBuff(binfo, owner)
      if newbuff then
        newbuff.onRemoved = override(newbuff.onRemoved, Gambler.diceRollBuff_onRemoved)
        newbuff.update = override(newbuff.update, Gambler.diceRollBuff_update)
        newbuff.Gambler_diceResult = result
        newbuff.Gambler_usedByAtk4 = buff.Gambler_usedByAtk4
        newbuff.Gambler_rollPhase = "result"
        owner.Gambler_diceRollBuff = newbuff
        if newbuff.effect_id then
          local effect = newbuff.owner.actor:getEffectById(newbuff.effect_id)
          local scaleX = effect:getScaleX()
          local scaleY = effect:getScaleY()
          local px, py = effect:getPosition()
          effect:setScaleX(scaleX * Gambler.diceRollBuffScale)
          effect:setScaleY(scaleY * Gambler.diceRollBuffScale)
          effect:setPosition(px, py + Gambler.diceRollBuffDeltaY)
        end
      end
    end
  end
  basefunc(buff, dt)
end

function Gambler.heroDiceRoll(skill, hero, result, usedByAtk4)
  local caster = skill.caster
  local buffId = Gambler.diceRollingBuff
  local binfo = ed.lookupDataTable("Buff", nil, buffId)
  local buff = hero:addBuff(binfo, caster)
  if buff then
    buff.update = override(buff.update, Gambler.rollingBuff_update)
    buff.Gambler_diceResult = result
    buff.Gambler_usedByAtk4 = usedByAtk4
    buff.Gambler_rollPhase = "rolling"
    if buff.effect_id then
      local effect = buff.owner.actor:getEffectById(buff.effect_id)
      local scaleX = effect:getScaleX()
      local scaleY = effect:getScaleY()
      local px, py = effect:getPosition()
      effect:setScaleX(scaleX * Gambler.diceRollBuffScale)
      effect:setScaleY(scaleY * Gambler.diceRollBuffScale)
      effect:setPosition(px, py + Gambler.diceRollBuffDeltaY)
    end
  end
  hero.Gambler_diceRollBuff = buff
  return result
end

function Gambler.calculateBuff(buff)
  local owner = buff.owner
  local skillawake = owner.skills.Gambler_awake
  if skillawake then
    local maxAdditionAP = skillawake.info["Script Arg1"]
    local maxAdditionMRI = skillawake.info["Script Arg2"]
    local hpRatio = owner.attribs.HP ~= 0 and owner.hp / owner.attribs.HP
    local additionCoef = math.min(1, (1 - hpRatio) / (1 - Gambler.awake_minHpRatio))
    buff:setAttribute("AP", maxAdditionAP * additionCoef)
    buff:setAttribute("MRI", maxAdditionMRI * additionCoef)
    owner:resetBuffApply(buff)
  end
end

function Gambler.awake_buff_update(basefunc, buff, dt)
  local owner = buff.owner
  buff.Gambler_addChipCd = buff.Gambler_addChipCd - dt
  if owner.Gambler_chipCount and owner.Gambler_chipCount <= Gambler.awake_addChipCondition and buff.Gambler_addChipCd <= 0 then
    Gambler.changeChip(owner, 1)
    buff.Gambler_addChipCd = Gambler.awake_addChipCd
  end
  buff.Gambler_calculateCd = buff.Gambler_calculateCd - dt
  if 0 >= buff.Gambler_calculateCd then
    Gambler.calculateBuff(buff)
    buff.Gambler_calculateCd = Gambler.awake_calculateCd
  end
  basefunc(buff, dt)
end

function Gambler.reset(basefunc, unit)
  basefunc(unit)
  unit.index = 0
  local binfo = ed.lookupDataTable("Buff", nil, Gambler.emptyBuffID)
  local buff = unit:addBuff(binfo, unit)
  unit.Gambler_startWave = true
  if ed.engine.wave_id == 1 then
    if unit.name == "Gambler" then
      unit.Gambler_chipCount = Gambler.chipIni
    else
      unit.Gambler_chipCount = 0
    end
    unit.Gambler_chipList = {}
  else
    unit.Gambler_chipCount = unit.Gambler_chipCount and unit.Gambler_chipCount or Gambler.chipIni
    unit.Gambler_chipList = unit.Gambler_chipList and #unit.Gambler_chipList ~= 0 and unit.Gambler_chipList or {}
    unit.Gambler_addIniChip = unit.Gambler_addIniChip and unit.Gambler_addIniChip or false
  end
  local skillatk2 = unit.skills.Gambler_atk2
  if skillatk2 then
    unit.Gambler_diceRollBuff = nil
  end
  local skillatk3 = unit.skills.Gambler_atk3
  if skillatk3 then
    unit.Gambler_atk3AlreadyUse = false
    unit.Gambler_atk3Killself = false
  end
  local skillatk4 = unit.skills.Gambler_atk4
  if skillatk4 then
    unit.Gambler_diceList = {}
    unit.Gambler_dicePicList = {}
    unit.Gambler_dicePattern = nil
    unit.Gambler_dicePatternNum = nil
    unit.Gambler_dicePatternList = {}
    unit.Gambler_atk2Enhanced = false
  end
  local skillawake = unit.skills.Gambler_awake
  if skillawake then
    local binfo = ed.lookupDataTable("Buff", nil, Gambler.awake_buffId)
    local buff = unit:addBuff(binfo, unit)
    if buff then
      buff.Gambler_addChipCd = Gambler.awake_addChipCd
      buff.Gambler_calculateCd = Gambler.awake_calculateCd
      buff.update = override(buff.update, Gambler.awake_buff_update)
    end
    unit.Gambler_awakeBuff = buff
  end
  local skillult = unit.skills.Gambler_ult
  if skillult then
    skillult.Gambler_ultAimBuff = nil
  end
  if unit.config.is_summoned then
    local copyTarget
    for enemy in ed.engine:foreachAliveUnit(-unit.camp) do
      if enemy.name ~= "Gambler" then
      elseif enemy.config.is_summoned then
      else
        copyTarget = enemy
      end
    end
    if copyTarget and copyTarget.Gambler_chipCount then
      unit.Gambler_chipCount = copyTarget.Gambler_chipCount
    end
  end
end

function Gambler.skillatk2_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  local caster = skill.caster
  if target.Gambler_diceRollBuff or caster.Gambler_diceRollBuff then
    return false, "rolling"
  end
  return canUse, reason
end

function Gambler.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local cheatPrecent = 0
  local casterInt = caster.attribs.INT or 0
  local targetInt = target.attribs.INT or 0
  if casterInt > targetInt then
    local intRatio = targetInt == 0 and 100 or casterInt / targetInt - 1
    cheatPrecent = math.min(intRatio * Gambler.atk2_cheatCoef, Gambler.atk2_cheatMax)
  end
  local selfResult = Gambler.heroDiceRoll(skill, caster, Gambler.diceRoll(cheatPrecent), true)
  local targetResult = Gambler.heroDiceRoll(skill, target, Gambler.diceRoll(0), false)
  local loser
  local deltaChip = 0
  if selfResult > targetResult then
    loser = target
    deltaChip = 1
  elseif selfResult < targetResult then
    loser = caster
    deltaChip = -1
  end
  skill.Gambler_atk2Loser = loser
  skill.Gambler_atk2DeltaChip = deltaChip
end

function Gambler.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local target = skill.target
  local caster = skill.caster
  if caster and caster.Gambler_diceRollBuff and caster.Gambler_diceRollBuff.Gambler_rollPhase == "rolling" then
    caster.Gambler_diceRollBuff.timer = Gambler.dtCount * 0.125
  end
  if target and target.Gambler_diceRollBuff and target.Gambler_diceRollBuff.Gambler_rollPhase == "rolling" then
    target.Gambler_diceRollBuff.timer = Gambler.dtCount * 0.125
  end
end

function Gambler.skillatk2_finish(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  basefunc(skill)
  if skill.attack_counter >= 1 then
    local loser = skill.Gambler_atk2Loser
    local deltaChip = skill.Gambler_atk2DeltaChip
    local skillatk2b = caster.skills.Gambler_atk2b
    if skillatk2b and loser then
      skillatk2b:takeEffectOn(loser, caster)
    end
    Gambler.changeChip(caster, deltaChip)
  end
  if caster.Gambler_diceRollBuff and caster.Gambler_diceRollBuff.Gambler_rollPhase == "rolling" then
    caster.Gambler_diceRollBuff.Gambler_diceResult = nil
    caster.Gambler_diceRollBuff.timer = Gambler.dtCount * 0.125
    caster.Gambler_diceRollBuff = nil
  end
  if target and target.Gambler_diceRollBuff and target.Gambler_diceRollBuff.Gambler_rollPhase == "rolling" then
    target.Gambler_diceRollBuff.Gambler_diceResult = nil
    target.Gambler_diceRollBuff.timer = Gambler.dtCount * 0.125
    target.Gambler_diceRollBuff = nil
  end
end

function Gambler.skillatk2b_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local originInfo = skill.info
  if caster == target then
    skill.info = ed.wraptable(originInfo, {
      ["Basic Num"] = originInfo["Basic Num"] * Gambler.atk2_hurtSelfCoef,
      ["Plus Ratio"] = originInfo["Plus Ratio"] * Gambler.atk2_hurtSelfCoef
    })
  end
  basefunc(skill, target, source, shift)
  skill.info = originInfo
  if caster.Gambler_atk2Enhanced and caster ~= target then
    local binfo = ed.lookupDataTable("Buff", nil, Gambler.atk2_enhancedBuffId)
    local buff = target:addBuff(binfo, caster)
    caster.Gambler_atk2Enhanced = false
  end
end

function Gambler.onDying(basefunc, self, killer)
  local skillatk3 = self.skills.Gambler_atk3
  local enemyKill = killer and killer.camp ~= self.camp
  if skillatk3 and enemyKill and not self.Gambler_atk3AlreadyUse then
    self.Gambler_atk3AlreadyUse = true
    self.state = ed.emUnitState_Birth
    for _, buff in ipairs(self.buff_list) do
      local willBeRemove = buff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("derangedOwner", buff.info["Control Effects"])
      if willBeRemove then
        buff.timer = 0
      end
    end
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    local binfo = ed.lookupDataTable("Buff", nil, Gambler.atk3_invulnerableBuffId)
    local buff = self:addBuff(binfo, self)
    self.Gambler_invulnerableBuff = buff
    if self.current_skill then
      self.current_skill:interrupt()
    end
    if self.Gambler_awakeBuff then
      Gambler.calculateBuff(self.Gambler_awakeBuff)
    end
    self:castSkill(skillatk3, killer)
    self.global_cd = 5
  else
    basefunc(self, killer)
  end
end

function Gambler.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local trueTarget = skill.target
  local caster = skill.caster
  local currentChip = caster.Gambler_chipCount or 0
  Gambler.changeChip(caster, -currentChip, true)
  skill.Gambler_atk3UsedChip = currentChip
  local hit = ed.rand() < Gambler.atk3_hitPercent and true or false
  skill.Gambler_result = hit
  if hit then
    skill:startPhase(1)
  else
    skill.target = caster
    skill:startPhase(2)
  end
end

function Gambler.skillatk3_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Gambler.skillatk3_selectTarget(basefunc, skill, default)
  local target1 = basefunc(skill, default)
  skill.target = default
  return skill.target
end

function Gambler.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local power = skill:power(caster, target, skill.info["Damage Type"])
  if caster and target and caster == target then
    caster.Gambler_atk3Killself = true
    if target.actor then
      local str = "-" .. math.floor(power + 0.5)
      if str ~= "-0" then
        local color
        if target.camp == ed.emCampPlayer then
          color = "red"
        else
          color = "orange"
        end
        if not target.notPopupBattleInfo then
          ed.PopupCreate(str, color, target.actor, false)
        end
      end
    end
  end
  basefunc(skill)
end

function Gambler.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local hit, dmg, cri = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if hit and 0 < dmg and target ~= caster then
    caster:takeHeal(dmg * Gambler.atk3_lfsRatio, "hp", caster)
  end
end

function Gambler.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, _ = basefunc(skill, source, target, damage_type)
  local chipCount = skill.Gambler_atk3UsedChip or 0
  power = power * (1 + chipCount * Gambler.atk3_extraDamageCoef)
  return power, _
end

function Gambler.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  if caster.Gambler_invulnerableBuff then
    caster.Gambler_invulnerableBuff.timer = 0
    caster.Gambler_invulnerableBuff = nil
  end
  basefunc(skill)
  if caster.Gambler_atk3Killself then
    caster:onDying(caster)
  end
  skill.Gambler_result = nil
  caster.can_cast_manual = true
  caster.global_cd = 3
end

function Gambler.skillatk4_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  if canUse then
    local caster = skill.caster
    if caster.Gambler_dicePattern ~= 2 and caster.Gambler_dicePattern ~= 3 then
      return false, "no pattern"
    end
  end
  return canUse, reason
end

function Gambler.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local patternCode = caster.Gambler_dicePatternCode
  if ed.run_with_scene and (not ed.engine.multiplayerMode or not not ed.multiplayer_battle:isMyHero(caster.tid)) then
    local dicePicList = caster.Gambler_dicePicList
    local diceList = caster.Gambler_diceList
    local i = -1
    for _, code in ipairs(patternCode) do
      i = i + 1
      local panel = caster.heroPanel and caster.heroPanel.btn
      local num = diceList[code]
      local pic = dicePicList[code]
      local newPicName = Gambler.diceResultPicList[num]
      if pic and newPicName then
        local newDice = ed.createSprite(newPicName, panel)
        local pos = ccp(pic:getPosition())
        newDice:setPosition(pos)
        newDice:setScale(1)
        ed.sceneui.ui_layer:addChild(newDice)
        local targetPos = ccpAdd(ed.toViewPosition(caster.position, caster.height), ccp(0, 32))
        local delay = CCDelayTime:create(i * 0.02)
        local move = CCMoveTo:create(1, targetPos)
        local newMove = CCEaseSineOut:create(move)
        local scale = CCScaleTo:create(1, 0.5)
        local fadeOut = CCFadeOut:create(1)
        local spawn = CCSpawn:create(ccArrayMake(newMove, scale, fadeOut))
        local seq = CCSequence:create(ccArrayMake(delay, spawn))
        seq = CCSequence:createWithTwoActions(seq, CCCallFunc:create(function()
          newDice:removeFromParentAndCleanup(true)
        end))
        newDice:runAction(seq)
      end
    end
  end
end

function Gambler.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.Gambler_dicePattern = nil
  caster.Gambler_dicePatternNum = nil
  caster.Gambler_dicePatternCode = nil
end

function Gambler.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local pattern = caster.Gambler_dicePattern
  local patternNum = caster.Gambler_dicePatternNum
  local patternCode = caster.Gambler_dicePatternCode
  local originInfo = skill.info
  if pattern == 2 then
    Gambler.changeChip(caster, 2)
  elseif pattern == 3 then
    Gambler.changeChip(caster, 3)
    local newBasicNum = skill.info["Basic Num"] * Gambler.atk4_identicalCoef
    local newPlusRatio = skill.info["Plus Ratio"] * Gambler.atk4_identicalCoef
    skill.info = ed.wraptable(originInfo, {
      ["Basic Num"] = newBasicNum,
      ["Plus Ratio"] = newPlusRatio
    })
  end
  basefunc(skill, target, source, shift)
  if pattern == 3 and patternNum == 7 then
    caster.Gambler_atk2Enhanced = true
  end
  if ed.run_with_scene and (not ed.engine.multiplayerMode or not not ed.multiplayer_battle:isMyHero(caster.tid)) then
    local dicePicList = caster.Gambler_dicePicList
    for _, code in ipairs(patternCode) do
      local pic = dicePicList[code]
      if pic then
        pic:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.2, 1.4), CCScaleTo:create(0.2, 1))))
      end
    end
  end
  skill.info = originInfo
end

function Gambler.hero_canPanelTrigger(basefunc, unit)
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
  local canTrigger = unit.current_skill and unit.current_skill:canTrigger()
  return canTrigger
end

function Gambler.maxDamageHero(camp)
  local maxDamage = -1
  local targetEnemy
  local totalDamage = 0
  for enemy in ed.engine:foreachAliveUnit(camp) do
    if enemy.config.is_summoned then
    else
      totalDamage = totalDamage + enemy.battledata.damage
      if maxDamage <= enemy.battledata.damage then
        maxDamage = enemy.battledata.damage
        targetEnemy = enemy
      end
    end
  end
  local ratio = totalDamage == 0 and 1 or maxDamage / totalDamage
  return targetEnemy, ratio
end

function Gambler.findNextStackTarget(caster)
  local nextTarget
  local maxPriority = -1
  local nextTargetList = {}
  for unit in ed.engine:foreachAliveUnit(-caster.camp) do
    if unit.config.is_summoned then
    else
      unit.Gambler_ultPriority = unit.Gambler_ultPriority and unit.Gambler_ultPriority + 1
      local priority = unit.Gambler_ultPriority or 0
      if unit.buff_effects.untargetable then
      elseif unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif maxPriority < priority and maxPriority ~= 0 or priority == 0 and 0 < maxPriority then
        maxPriority = priority
        nextTargetList = {}
        table.insert(nextTargetList, unit)
      elseif priority == maxPriority then
        table.insert(nextTargetList, unit)
      end
    end
  end
  if nextTargetList then
    nextTarget = nextTargetList[math.ceil(ed.rand() * #nextTargetList)]
  end
  if nextTarget then
    nextTarget.Gambler_ultPriority = 1
  end
  return nextTarget
end

function Gambler.setPortraitLocal(hero, panel)
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
  if panel then
    panel:setPortrait(portrait_res)
  end
end

function Gambler.hero_shouldTrigger(basefunc, unit)
  local skillult = unit.skills.Gambler_ult
  if skillult and skillult.casting then
    if skillult.Gambler_ultCertainlyRight then
      local trueTarget = Gambler.maxDamageHero(-unit.camp)
      if trueTarget and trueTarget == skillult.Gambler_ultAimTarget then
        return true
      end
    elseif skillult.Gambler_aimTotalTime >= skillult.Gambler_shouldTriggerTime then
      return true
    end
  end
  return false
end

function Gambler.skillult_canCastWithTarget(basefunc, skill, target)
  local can, reason = basefunc(skill, target)
  local caster = skill.caster
  local chipCount = caster.Gambler_chipCount
  if can and chipCount < Gambler.ult_chipCondition then
    return false, "chip not enough"
  end
  local skillatk3 = caster.skills.Gambler_atk3
  if caster.current_skill == skillatk3 or skill.casting then
    return false, "ulting"
  end
  return can, reason
end

function Gambler.skillult_canTrigger(basefunc, skill)
  local caster = skill.caster
  local canT = skill == skill.caster.current_skill and skill.attack_counter == 1 and skill.current_phase_idx == 1 and skill.Gambler_ultAimTarget
  return canT
end

function Gambler.skillult_trigger(basefunc, skill)
  skill.Gambler_ultTarget = skill.Gambler_ultAimTarget
  if skill.Gambler_ultAimBuff then
    local owner = skill.Gambler_ultAimBuff.owner
    owner:removeBuff(skill.Gambler_ultAimBuff)
    skill.Gambler_ultAimBuff = nil
  end
  skill:startPhase(2)
end

function Gambler.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.Gambler_ultTarget = nil
  skill.Gambler_ultAimTarget = nil
  skill.Gambler_aimInterval = 0
  skill.Gambler_aimTotalTime = 0
  skill.Gambler_ultStackBuff = nil
  skill.Gambler_currentPanel = skill.caster
  skill.Gambler_ultResult = nil
  skill.Gambler_highlightBuff = nil
  skill.Gambler_highlightTimes = 0
  skill.Gambler_highlightInterval = 0
  skill.highLightEnd = false
  skill.Gambler_trueAnswer = nil
  local caster = skill.caster
  local maxDamageHero, damageRatio = Gambler.maxDamageHero(-caster.camp)
  local k = (Gambler.ult_maxAccuracy - Gambler.ult_minAccuracy) / (Gambler.ult_maxRatio - Gambler.ult_minRatio)
  local x = math.max(math.min(damageRatio, Gambler.ult_maxRatio), Gambler.ult_minRatio)
  local accuracy = Gambler.ult_minAccuracy + (x - Gambler.ult_minRatio) * k
  skill.Gambler_ultCertainlyRight = accuracy >= ed.rand() and true or false
  if not skill.Gambler_ultCertainlyRight then
    skill.Gambler_shouldTriggerTime = 3
  end
  if not caster.Gambler_uncontrollable then
    local binfo = ed.lookupDataTable("Buff", nil, Gambler.ult_uncontrollableBuffId)
    local buff = caster:addBuff(binfo, caster)
    caster.Gambler_uncontrollable = buff
  end
end

function Gambler.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.casting and skill == skill.caster.current_skill and caster.ai.will_cast_manual_skill and caster:canPanelTrigger() and caster:shouldTrigger() then
    skill:trigger()
  end
  if skill.casting and skill == skill.caster.current_skill and skill.current_phase_idx == 2 and skill.attack_counter == 2 then
    if ed.run_with_scene and not caster.ult_nighteffect then
      local effect_night = "eff_point_Gambler_ult_night.cha"
      local origin = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      caster.ult_nighteffect = ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
    end
    skill.Gambler_highlightInterval = skill.Gambler_highlightInterval - dt_action
    if 0 >= skill.Gambler_highlightInterval then
      if 0 >= skill.Gambler_highlightTimes then
        skill.Gambler_highlightInterval = 0.37
      elseif skill.Gambler_highlightTimes <= 1 then
        skill.Gambler_highlightInterval = 0.27
      elseif 2 >= skill.Gambler_highlightTimes then
        skill.Gambler_highlightInterval = 0.19
      elseif skill.Gambler_highlightTimes <= 3 then
        skill.Gambler_highlightInterval = 0.13
      elseif skill.Gambler_highlightTimes <= 5 then
        skill.Gambler_highlightInterval = 0.08
      elseif skill.Gambler_highlightTimes <= 30 then
        skill.Gambler_highlightInterval = 0.03
      end
      if skill.Gambler_highlightBuff then
        local owner = skill.Gambler_highlightBuff.owner
        owner:removeBuff(skill.Gambler_highlightBuff)
        skill.Gambler_highlightBuff = nil
      end
      local highlightEnemy = Gambler.findNextStackTarget(skill.caster)
      if skill.Gambler_highlightTimes and skill.Gambler_highlightTimes >= 10 then
        highlightEnemy = skill.Gambler_trueAnswer
        skill.highLightEnd = true
        skill:onPhaseFinished()
      end
      if highlightEnemy then
        local binfo = ed.lookupDataTable("Buff", nil, Gambler.ult_highlightEffectBuffId)
        local buff = highlightEnemy:addBuff(binfo, skill.caster)
        skill.Gambler_highlightBuff = buff
        skill.Gambler_highlightTimes = skill.Gambler_highlightTimes + 1
      end
    end
  end
end

function Gambler.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local stakeTarget = skill.Gambler_ultTarget
  if skill.attack_counter == 2 and stakeTarget then
    local binfo = ed.lookupDataTable("Buff", nil, Gambler.ult_stackBuffId)
    local buff = ed.BuffCreate(binfo, stakeTarget, caster)
    skill.Gambler_ultStackBuff = buff
    stakeTarget:addBuff(buff, skill.caster)
    if buff.effect_id then
      local effect = buff.owner.actor:getEffectById(buff.effect_id)
      local scaleX = effect:getScaleX()
      local scaleY = effect:getScaleY()
      effect:setScaleX(scaleX * 0.8)
      effect:setScaleY(scaleY * 0.8)
    end
    local maxDamageEnemy = Gambler.maxDamageHero(-caster.camp)
    skill.Gambler_trueAnswer = maxDamageEnemy
    if maxDamageEnemy and maxDamageEnemy == stakeTarget then
      skill.Gambler_ultResult = "correct"
    else
      skill.Gambler_ultResult = "error"
    end
    local caster = skill.caster
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if caster and panel then
        Gambler.setPortraitLocal(caster, panel)
      end
    end
  elseif skill.current_phase_idx == 3 and stakeTarget and skill.Gambler_ultResult == "correct" then
    local originInfo = skill.info
    local loseChip = caster.Gambler_chipCount or 0
    Gambler.changeChip(caster, -loseChip, true)
    local newBasicNum = skill.info["Basic Num"] * (1 + loseChip * Gambler.ult_extraDamageCoef)
    local newPlusRatio = skill.info["Plus Ratio"] * (1 + loseChip * Gambler.ult_extraDamageCoef)
    skill.info = ed.wraptable(originInfo, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = newBasicNum,
      ["Plus Ratio"] = newPlusRatio,
      ["Impact Effect"] = Gambler.ult_impactEffect,
      ["Knock Up"] = 0.6,
      ["Knock Back"] = 8
    })
    local hit, dmg, crit = skill:takeEffectOn(stakeTarget, caster)
    skill.info = originInfo
    local binfo = ed.lookupDataTable("Buff", nil, Gambler.ult_cryBuffId)
    local newbuff = stakeTarget:addBuff(binfo, caster)
    if hit and 0 < dmg and stakeTarget ~= caster then
      caster:takeHeal(dmg * Gambler.ult_lfsRatio, "hp", caster)
    end
    local trueAnswer = skill.Gambler_trueAnswer
    if skill.Gambler_ultStackBuff then
      local owner = skill.Gambler_ultStackBuff.owner
      owner:removeBuff(skill.Gambler_ultStackBuff)
      skill.Gambler_ultStackBuff = nil
    end
    if ed.run_with_scene then
      local pos = trueAnswer.position
      local height = trueAnswer.height
      local direction = trueAnswer.direction and 0 < trueAnswer.direction and 1 or -1
      ed.scene:playEffectOnScene(Gambler.ult_pointEffectCorrect, pos, {1, 1}, nil, 1)
      ed.scene:playEffectOnScene(Gambler.ult_bingoBoom, pos, {direction, 1}, nil, 1)
    end
  elseif skill.current_phase_idx == 4 and stakeTarget and skill.Gambler_ultResult == "error" then
    local loseChip = caster.Gambler_chipCount and math.ceil(caster.Gambler_chipCount / 2)
    Gambler.changeChip(caster, -loseChip)
    local trueAnswer = skill.Gambler_trueAnswer
    if ed.run_with_scene and trueAnswer then
      local pos = trueAnswer.position
      local height = trueAnswer.height
      ed.scene:playEffectOnScene(Gambler.ult_pointEffectFail, pos, {1, 1}, nil, 1)
    end
  end
end

function Gambler.skillult_onPhaseFinished(basefunc, skill)
  local currentPhase = skill.current_phase_idx
  if not skill.Gambler_ultTarget and currentPhase ~= 1 then
    skill:finish()
  elseif currentPhase == 1 then
    if not skill.Gambler_ultTarget then
      if skill.Gambler_ultAimTarget then
        skill.Gambler_ultTarget = skill.Gambler_ultAimTarget
      else
        skill:finish()
      end
    end
    skill:startPhase(2)
  elseif currentPhase == 2 and skill.Gambler_ultResult and skill.Gambler_ultResult == "correct" then
    skill:startPhase(3)
  elseif currentPhase == 2 and skill.Gambler_ultResult and skill.Gambler_ultResult == "error" then
    skill:startPhase(4)
  else
    skill:finish()
  end
end

function Gambler.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if caster and panel then
      Gambler.setPortraitLocal(caster, panel)
    end
  end
  if skill.attack_counter < 3 then
    local loseChip = caster.Gambler_chipCount and math.ceil(caster.Gambler_chipCount / 2)
    Gambler.changeChip(caster, -loseChip)
  end
  if caster.Gambler_uncontrollable then
    caster:removeBuff(caster.Gambler_uncontrollable)
    caster.Gambler_uncontrollable = nil
  end
  if skill.Gambler_ultAimBuff then
    local owner = skill.Gambler_ultAimBuff.owner
    owner:removeBuff(skill.Gambler_ultAimBuff)
    skill.Gambler_ultAimBuff = nil
  end
  if skill.Gambler_highlightBuff then
    local owner = skill.Gambler_highlightBuff.owner
    owner:removeBuff(skill.Gambler_highlightBuff)
    skill.Gambler_highlightBuff = nil
  end
  if skill.Gambler_ultStackBuff then
    local owner = skill.Gambler_ultStackBuff.owner
    owner:removeBuff(skill.Gambler_ultStackBuff)
    skill.Gambler_ultStackBuff = nil
  end
  if ed.run_with_scene then
    local new_effect_list = {}
    local effect_list = ed.scene.effect_list
    for i, effect in ipairs(effect_list) do
      if caster.ult_nighteffect and caster.ult_nighteffect == effect then
        effect:removeFromParentAndCleanup(true)
      else
        table.insert(new_effect_list, effect)
      end
    end
    caster.ult_nighteffect = nil
    ed.scene.effect_list = new_effect_list
  end
end

function Gambler.update_skillult(unit, dt)
  local skillult = unit.skills.Gambler_ult
  if skillult and unit.current_skill == skillult and unit.current_skill.attack_counter == 1 and not skillult.Gambler_ultTarget then
    skillult.Gambler_aimInterval = skillult.Gambler_aimInterval + dt
    skillult.Gambler_aimTotalTime = skillult.Gambler_aimTotalTime + dt
    if skillult.Gambler_aimInterval >= Gambler.ult_interval then
      skillult.Gambler_aimInterval = skillult.Gambler_aimInterval - Gambler.ult_interval
      local nextAimTarget = Gambler.findNextStackTarget(unit)
      local nextPanel = nextAimTarget or unit
      if nextPanel ~= skillult.Gambler_currentPanel then
        if ed.run_with_scene then
          local panel = unit.heroPanel
          if nextAimTarget and panel then
            Gambler.setPortraitLocal(nextAimTarget, panel)
          end
        end
        skillult.Gambler_currentPanel = nextPanel
        if skillult.Gambler_ultAimBuff then
          local owner = skillult.Gambler_ultAimBuff.owner
          owner:removeBuff(skillult.Gambler_ultAimBuff)
          skillult.Gambler_ultAimBuff = nil
        end
        if nextAimTarget then
          local binfo = ed.lookupDataTable("Buff", nil, Gambler.ult_aimBuffId)
          local aimBuff = nextAimTarget:addBuff(binfo, unit)
          skillult.Gambler_ultAimBuff = aimBuff
        end
      end
      if nextAimTarget then
        skillult.Gambler_ultAimTarget = nextAimTarget
      else
        skillult.Gambler_ultAimTarget = nil
        skillult:finish()
      end
    end
  end
end

function Gambler.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if ed.protoSuperAwake(unit.proto, 10038) then
    unit.index = unit.index + dt
    if unit.index % 4 == 0 then
      if unit.hp < 0.7 * unit.attribs.HP or unit.Gambler_chipCount == 10 then
        local skillsawake = unit.skills.Gambler_sawake
        if skillsawake then
          unit:takeHeal(skillsawake.info["Script Arg2"] + 210, "hp", unit)
        end
      elseif unit.Gambler_chipCount <= 8 then
        Gambler.changeChip(unit, 2)
      else
        Gambler.changeChip(unit, 1)
      end
    end
  end
  local chipLogicCount = unit.Gambler_chipCount or 0
  if unit.Gambler_startWave then
    Gambler.chipPicFix(unit, chipLogicCount)
    unit.Gambler_startWave = false
  end
  Gambler.update_skillult(unit, dt)
end

function Gambler.setMP(basefunc, unit, mp)
  basefunc(unit, mp)
  if unit.name == "Gambler" then
    unit.mp = 0
  end
end

function Gambler.die(basefunc, unit, killer)
  Gambler.removeUIPicture(unit, true, true)
  basefunc(unit, killer)
end

function Gambler.unitPanelIsSwitch(basefunc, unit)
  return false
end

function Gambler.init_hero(hero)
  hero.reset = override(hero.reset, Gambler.reset)
  hero.update = override(hero.update, Gambler.update)
  hero.onDying = override(hero.onDying, Gambler.onDying)
  hero.setMP = override(hero.setMP, Gambler.setMP)
  hero.die = override(hero.die, Gambler.die)
  hero.shouldTrigger = override(hero.shouldTrigger, Gambler.hero_shouldTrigger)
  hero.canPanelTrigger = override(hero.canPanelTrigger, Gambler.hero_canPanelTrigger)
  hero.unitPanelIsSwitch = override(hero.unitPanelIsSwitch, Gambler.unitPanelIsSwitch)
  local skillatk2 = hero.skills.Gambler_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Gambler.skillatk2_start)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, Gambler.skillatk2_canCastWithTarget)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Gambler.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, Gambler.skillatk2_finish)
  end
  local skillatk2b = hero.skills.Gambler_atk2b
  if skillatk2b then
    skillatk2b.takeEffectOn = override(skillatk2b.takeEffectOn, Gambler.skillatk2b_takeEffectOn)
  end
  local skillatk3 = hero.skills.Gambler_atk3
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Gambler.skillatk3_start)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Gambler.skillatk3_onPhaseFinished)
    skillatk3.selectTarget = override(skillatk3.selectTarget, Gambler.skillatk3_selectTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Gambler.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Gambler.skillatk3_takeEffectOn)
    skillatk3.power = override(skillatk3.power, Gambler.skillatk3_power)
    skillatk3.finish = override(skillatk3.finish, Gambler.skillatk3_finish)
  end
  local skillatk4 = hero.skills.Gambler_atk4
  if skillatk4 then
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, Gambler.skillatk4_canCastWithTarget)
    skillatk4.start = override(skillatk4.start, Gambler.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Gambler.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Gambler.skillatk4_takeEffectOn)
  end
  local skillult = hero.skills.Gambler_ult
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Gambler.skillult_canCastWithTarget)
    skillult.canTrigger = override(skillult.canTrigger, Gambler.skillult_canTrigger)
    skillult.trigger = override(skillult.trigger, Gambler.skillult_trigger)
    skillult.start = override(skillult.start, Gambler.skillult_start)
    skillult.update = override(skillult.update, Gambler.skillult_update)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Gambler.skillult_onAttackFrame)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, Gambler.skillult_onPhaseFinished)
    skillult.finish = override(skillult.finish, Gambler.skillult_finish)
  end
  return hero
end

return Gambler.init_hero
