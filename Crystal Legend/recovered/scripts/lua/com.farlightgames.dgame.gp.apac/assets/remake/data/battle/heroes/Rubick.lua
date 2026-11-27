module("ed.battlehero", package.seeall)
local ed = ed
Rubick = {}
Rubick.version = "CHN"
Rubick.heroName = "Rubick"
Rubick.heroPuppet = "Rubick.cha"
Rubick.heroPortrait = "UI/DOTA-HERO/Rubick.png"
Rubick.heroPuppetSwitch = "Rubick2.cha"
Rubick.heroPortraitSwitch = "UI/DOTA-HERO/SwitchRubick.png"
Rubick.switchPuppetPointEffect = "eff_point_Rubick_atk3.cha"
Rubick.switchPuppetPointEffect2 = "eff_point_RubickSwitch_atk3.cha"
Rubick.stolenTargetImpactEffect = "eff_impact_Rubick_atk3.cha"
Rubick.stolenTargetImpactEffect2 = "eff_impact_RubickSwitch_atk3.cha"
Rubick.initPeriodGroup = 1
Rubick.initPeriodGroup2 = 101
Rubick.unconBuffID = 823
Rubick.ulttagBuffID = 829
Rubick.ulttagBuffSelfID = 373
Rubick.ulttagBuffIDSwitch = 833
Rubick.newPuppetBuff = 371
Rubick.newPuppetBuff2 = 372
Rubick.gameEndTagBuff = 375
Rubick.ultTimeGap = 0.75
Rubick.ultMaxJumpTimes = 8
Rubick.arenaUltMaxCount = 1
Rubick.specifyPuppet = nil
Rubick.specifyStolenSkill = nil
Rubick.CASTINGATK3 = 1
Rubick.CASTINGULT = 2
Rubick.lighteningPercent = 0.1
Rubick.stolenPlusRatioPara = 1
Rubick.Skill_Can_Be_Stolen = 2
Rubick.Skill_Can_Be_Cast = 1

function Rubick.hero_shouldTrigger(basefunc, unit)
  if unit.autoBattleRandSeed_Rubick and unit.autoBattleRandSeed_Rubick > 8 then
    unit.autoBattleRandSeed_Rubick = unit.autoBattleRandSeed_Rubick / 10
  elseif unit.autoBattleRandSeed_Rubick and unit.autoBattleRandSeed_Rubick < 0 then
    unit.autoBattleRandSeed_Rubick = nil
    return true
  end
  return false
end

function Rubick.hero_canPanelTrigger(unit)
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
  local tt = unit.current_skill and unit.current_skill:canTrigger()
  return tt
end

function Rubick.stolenskill_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("AP", math.max(buff.info.AP, buff.info.AD))
  buff:setAttribute("AD", math.max(buff.info.AP, buff.info.AD))
  return buff
end

function Rubick.stolenskill_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local multiplier = skill.info["Plus Ratio"]
  local base_attrib = skill.originUnit_Rubick.attribs[skill.info["Plus Attr"]]
  local origAtt = caster.attribs[skill.info["Plus Attr"]]
  caster.attribs[skill.info["Plus Attr"]] = base_attrib
  local originPower, i = basefunc(skill, source, target, damage_type)
  caster.attribs[skill.info["Plus Attr"]] = origAtt
  local skillatk3 = caster.skills[Rubick.heroName .. "_atk3"]
  local skillult = caster.skills[Rubick.heroName .. "_ult"]
  if ed.protoAwake(caster.proto, 85) then
    skillatk3 = caster.skills[Rubick.heroName .. "_atk3b"]
    skillult = caster.skills[Rubick.heroName .. "_ultb"]
  end
  local APt = skill.originUnit_Rubick.attribs.AP
  local ADt = skill.originUnit_Rubick.attribs.AD
  local APs = caster.attribs.AP
  local tt = APt > ADt * 2 and APt or ADt + APt * 2
  local ratio = 3 - 2 * math.sqrt(APt / APs)
  return ratio * originPower, i
end

function Rubick.stolenskill_reset(basefunc, skill)
  basefunc(skill)
  skill.cd_remaining = 999
end

function Rubick.stolenskill_finish(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  if not ed.engine.beingEnd then
    for i, tbuff in pairs(caster.buff_list) do
      if tbuff.info.ID == Rubick.unconBuffID then
        tbuff.timer = 0
      end
    end
    local puppetBuffList = {}
    for i, tbuff in pairs(caster.buff_list) do
      if tbuff.info.ID == Rubick.newPuppetBuff then
        puppetBuffList[#puppetBuffList + 1] = tbuff
      end
    end
    for i, tbuff in pairs(puppetBuffList) do
      caster:removeBuff(tbuff)
    end
    if caster.currentActionStage == Rubick.initPeriodGroup then
      skill.cd_remaining = 999
      local puppetBuffList = {}
      for i, tbuff in pairs(caster.buff_list) do
        if tbuff.info.ID == Rubick.newPuppetBuff2 then
          puppetBuffList[#puppetBuffList + 1] = tbuff
        end
      end
      for i, tbuff in pairs(puppetBuffList) do
        caster:removeBuff(tbuff)
      end
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(Rubick.switchPuppetPointEffect, {
          caster.position[1],
          caster.position[2] - 2
        }, {
          caster.direction,
          1
        }, nil, 0)
      end
    end
  end
  caster.castingStolenSkill_Rubick = nil
  caster.stolenPuppetId_Rubick = nil
  caster.rubickUltRandTarget = nil
  if skill.originfo_rubick then
    skill.info = skill.originfo_rubick
    skill.originfo_rubick = nil
  end
end

function Rubick.stolenskill_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Rubick.newPuppetBuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local bid2 = Rubick.newPuppetBuff2
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local stolenPuppetId
  if Rubick.specifyPuppet then
    binfo.Puppet = Rubick.specifyPuppet
  elseif caster.castingStolenSkill_Rubick == Rubick.CASTINGULT or not skill.targetPuppet then
    binfo.Puppet = skill.originPuppet_Rubick
    if skill and skill.info["Skill Name"] == "Mor_ult" then
      binfo.Puppet = "MorBattle.cha"
    end
    if skill and skill.info["Skill Name"] == "BossTB_atk3" then
      binfo.Puppet = "TBult.cha"
    end
    if skill and skill.info["Skill Name"] == "Artemis_ultF" then
      if ed.protoAwake(skill.originUnit_Rubick.proto) then
        binfo.Puppet = "Artemis3.cha"
      else
        binfo.Puppet = "Artemis.cha"
      end
    end
  else
    binfo.Puppet = skill.targetPuppet
  end
  if caster.currentActionStage == Rubick.initPeriodGroup then
    local buff = caster:addBuff(binfo, skill.caster)
    local buff2 = caster:addBuff(binfo2, skill.caster)
  end
  caster.state = ed.emUnitState_Attack
  local bid = Rubick.unconBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
  if skill.info["Skill Name"] == "Tusk_ult" then
    caster.global_cd = 5
  end
end

function Rubick.initRubickPeriodGroup(hero)
  hero.rubickPeriodGroup = {}
  for i, info in pairs(ed.getDataTable("Period")) do
    if info[1] then
      for i, period in pairs(info) do
        if period["Support Rubick"] then
          hero.rubickPeriodGroup[period["Period Group"]] = true
        end
      end
    end
  end
end

function Rubick.initRubickSkillList(hero)
  if not hero.stolenSkills then
    hero.stolenSkills = {}
  else
    for i = 1, #hero.stolenSkills do
      hero.skills[hero.stolenSkills[i]].cd_remaining = 999
    end
    hero.stolenSkills = {}
  end
  local notAwakeSkillList = {
    "Rubick_ult",
    "Rubick_atk",
    "Rubick_atk2",
    "Rubick_atk3"
  }
  local notAwakeSkillList2 = {
    850,
    851,
    852,
    853
  }
  local notNormalSkillList = {
    "Rubick_ultb",
    "Rubick_atkb",
    "Rubick_atk2b",
    "Rubick_atk3b"
  }
  local notNormalSkillList2 = {
    856,
    857,
    858,
    859
  }
  if ed.protoAwake(hero.proto, 85) then
    for i = 1, #notAwakeSkillList do
      for j = 1, #hero.skill_list do
        if hero.skill_list[j].info["Skill Name"] == notAwakeSkillList[i] then
          table.remove(hero.skill_list, j)
          break
        end
      end
      hero.skills[notAwakeSkillList[i]] = nil
      hero.skills[notAwakeSkillList2[i]] = nil
    end
    hero.manual_skill = hero.skills.Rubick_ultb
    hero.basic_skill = hero.skills.Rubick_atkb
  else
    for i = 1, #notNormalSkillList do
      for j = 1, #hero.skill_list do
        if hero.skill_list[j].info["Skill Name"] == notNormalSkillList[i] then
          table.remove(hero.skill_list, j)
          break
        end
      end
      hero.skills[notNormalSkillList[i]] = nil
      hero.skills[notNormalSkillList2[i]] = nil
    end
    hero.manual_skill = hero.skills.Rubick_ult
    hero.basic_skill = hero.skills.Rubick_atk
  end
  for unit in ed.engine:foreachAliveUnit(-hero.camp) do
    if unit.name == Rubick.heroName or not hero.skills[Rubick.heroName .. "_atk3"] and not hero.skills[Rubick.heroName .. "_atk3b"] then
    elseif unit.info["Fit For Rubick"] then
      local unitSkillList = {}
      for slot, group in pairs(ed.getDataTable("SkillGroup")[unit.info.ID]) do
        local skill_level = ed.protoAwake(hero.proto, 85) and hero.skills[Rubick.heroName .. "_atk3b"].level or hero.skills[Rubick.heroName .. "_atk3"].level
        local skill_info = ed.Skill.getSkillInfo(group, skill_level)
        local active_type = skill_info["Active Type"]
        if active_type == "active" and skill_info["Stolen Tag"] >= Rubick.Skill_Can_Be_Cast then
          local isManual = false
          if skill_info.Manual then
            skill_info.Manual = false
            isManual = true
          end
          local costMP = skill_info["Cost MP"]
          skill_info["Cost MP"] = 0
          if skill_info["Rubick's Max Range"] and 0 < skill_info["Rubick's Max Range"] then
            skill_info["Max Range"] = skill_info["Rubick's Max Range"]
          end
          if skill_info["Rubick's Plus Ratio"] and 0 < skill_info["Rubick's Plus Ratio"] then
            skill_info["Plus Ratio"] = skill_info["Rubick's Plus Ratio"]
          end
          if skill_info["Plus Attr"] == "AD" then
            skill_info["Plus Attr"] = "AP"
            skill_info["Plus Ratio"] = skill_info["Plus Ratio"] * Rubick.stolenPlusRatioPara
          end
          if skill_info["Damage Type"] == "AD" then
          end
          if skill_info["Skill Name"] == "Axe_atk2" or skill_info["Skill Name"] == "DK_atk3" or skill_info["Skill Name"] == "DK_atk3b" then
            skill_info["AOE Origin"] = false
          end
          if skill_info["Skill Name"] == "TP_ult4" then
            skill_info["Cost MP"] = costMP
          end
          if skill_info["Skill Name"] == "Naga_ult" then
            skill_info["Shape Arg1"] = 800
          end
          skill_info.Interruptable = false
          local skill = ed.SkillCreate(skill_info, unit, skill_level)
          skill.caster = hero
          skill.cd_remaining = 999
          skill.originPuppet_Rubick = unit.info.Puppet
          if ed.protoAwake(unit.proto) and unit.info["Puppet Switch"] then
            skill.originPuppet_Rubick = unit.info["Puppet Switch"]
          end
          skill.originUnit_Rubick = unit
          skill.isManual_Rubick = isManual
          unitSkillList[#unitSkillList + 1] = skill
        end
      end
      table.sort(unitSkillList, function(a, b)
        if a.info.Priority == b.info.Priority and a ~= b then
          EDDebug()
        end
        return a.info.Priority > b.info.Priority
      end)
      for i = 1, #unitSkillList do
        local skill = unitSkillList[i]
        table.insert(hero.skill_list, skill)
        hero.skills[skill.info["Skill Group ID"]] = skill
        hero.skills[skill.info["Skill Name"]] = skill
        hero.stolenSkills[#hero.stolenSkills + 1] = skill.info["Skill Group ID"]
        hero.stolenSkills[#hero.stolenSkills + 1] = skill.info["Skill Name"]
      end
      if unit.info.Script and unit.info["Fit For Rubick"] then
        if Rubick.version == "Global" then
          local init_func = require(unit.info.Script)
          hero = init_func(hero)
        elseif Rubick.version == "CHN" then
          local script = ed.getUnitScript(unit.tid)
          local init_func = require(script)
          hero = init_func(hero)
        end
      end
      for i = 1, #unitSkillList do
        local skill = unitSkillList[i]
        skill.start = override(skill.start, Rubick.stolenskill_start)
        skill.finish = override(skill.finish, Rubick.stolenskill_finish)
        skill.power = override(skill.power, Rubick.stolenskill_power)
        skill.reset = override(skill.reset, Rubick.stolenskill_reset)
        
        function skill.canTrigger()
          return false
        end
        
        skill.createBuff = override(skill.createBuff, Rubick.stolenskill_createBuff)
      end
    end
    hero.canPanelTrigger = Rubick.hero_canPanelTrigger
    hero.shouldTrigger = override(hero.shouldTrigger, Rubick.hero_shouldTrigger)
  end
end

function Rubick.castStolenSkill(hero, stolenSkill, skill_level)
  local stolenSuccess = false
  if hero.current_skill then
    hero.current_skill:finish()
  end
  if stolenSkill then
    local rubickSkill = hero.skills[stolenSkill.info["Skill Name"]]
    if rubickSkill then
      rubickSkill.originfo_rubick = rubickSkill.info
      if skill_level and skill_level ~= rubickSkill.level then
        rubickSkill.info = ed.Skill.getSkillInfo(ed.getDataTable("SkillGroup")[stolenSkill.caster.info.ID][stolenSkill.info.Slot], skill_level)
      end
      rubickSkill.targetPuppet = stolenSkill.caster.last_stolen_skill_puppet
      if Rubick.specifyStolenSkill then
        hero:castSkill(hero.skills[Rubick.specifyStolenSkill], hero.skills[Rubick.specifyStolenSkill].target)
      else
        hero:castSkill(rubickSkill, rubickSkill.target)
      end
      stolenSuccess = true
    end
  end
  return stolenSuccess
end

function Rubick.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
  local stolenSuccess = false
  local stolenUltList = {}
  local stolenSkillList = {}
  local juniorStolenSkillList = {}
  local unitList = {}
  if #stolenSkillList == 0 then
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      if not (unit.name ~= Rubick.heroName and not unit.config.is_summoned and unit.last_stolen_skill) or unit.last_stolen_skill.info["Stolen Tag"] ~= Rubick.Skill_Can_Be_Stolen or unit.last_stolen_skill.info["Damage Type"] == "AD" and caster.buff_effects.disarm then
      else
        local rubickSkill = caster.skills[unit.last_stolen_skill.info["Skill Name"]]
        if rubickSkill and rubickSkill:selectTarget(nil) then
          rubickSkill.cd_remaining = 0
          if rubickSkill:canCastWithTarget(rubickSkill.target) then
            if unit.last_stolen_skill.info.Manual then
              stolenSkillList[#stolenUltList + 1] = unit.last_stolen_skill
            else
              stolenSkillList[#stolenSkillList + 1] = unit.last_stolen_skill
            end
          end
          rubickSkill.cd_remaining = 999
        else
          juniorStolenSkillList[#juniorStolenSkillList + 1] = unit.last_stolen_skill
        end
        unitList[#unitList + 1] = unit
      end
    end
  end
  if #stolenSkillList == 0 and #stolenUltList == 0 then
  elseif 0 < #stolenUltList then
    local index = math.floor(ed.rand() * #stolenUltList) + 1
    caster.castingStolenSkill_Rubick = Rubick.CASTINGATK3
    stolenSuccess = Rubick.castStolenSkill(caster, stolenUltList[index], nil)
  else
    local index = math.floor(ed.rand() * #stolenSkillList * (1 + Rubick.lighteningPercent)) + 1
    if index < #stolenSkillList + 1 then
      caster.castingStolenSkill_Rubick = Rubick.CASTINGATK3
      stolenSuccess = Rubick.castStolenSkill(caster, stolenSkillList[index], nil)
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(Rubick.stolenTargetImpactEffect, {
          unitList[index].position[1],
          unitList[index].position[2] - 1
        }, {
          unitList[index].direction,
          1
        }, nil, 0)
      end
    else
      stolenSuccess = false
    end
  end
  if not stolenSuccess then
    caster.castingStolenSkill_Rubick = nil
    skill:finish()
    if ed.protoAwake(caster.proto, 85) then
      caster:castSkill(caster.skills[Rubick.heroName .. "_atk2b"], nil)
    else
      caster:castSkill(caster.skills[Rubick.heroName .. "_atk2"], nil)
    end
  end
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(Rubick.switchPuppetPointEffect, {
      caster.position[1],
      caster.position[2] - 2
    }, {
      caster.direction,
      1
    }, nil, 0)
  end
end

function Rubick.ulttagbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  if ed.run_with_scene then
    local panel = buff.owner.heroPanel
    if panel then
      panel:setPortrait(ed.recoverColum(Rubick.heroPortrait))
      panel:setNextPortrait(nil)
    end
  end
end

function Rubick.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.castingUlt_Rubick = nil
  caster.autoBattleRandSeed_Rubick = nil
  for i, tbuff in pairs(caster.buff_list) do
    if tbuff.info.ID == Rubick.unconBuffID then
      tbuff.timer = 0
    end
  end
end

function Rubick.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, reason = basefunc(skill, target)
  if ret and (caster.castingUlt_Rubick or caster.castingStolenSkill_Rubick == Rubick.CASTINGULT) then
    return false, "stoling"
  end
  return ret, reason
end

function Rubick.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.castingUlt_Rubick = true
  local bid = Rubick.ulttagBuffSelfID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  buff.onRemoved = override(buff.onRemoved, Rubick.ulttagbuff_onRemoved)
  caster.autoBattleRandSeed_Rubick = (1 + math.floor(ed.rand() * Rubick.arenaUltMaxCount)) * 10
end

function Rubick.skillult_getSkill(hero)
  local stolenSkill = hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex].manual_skill
  local isUlt = false
  local isRubickSkill = false
  local reason
  if not stolenSkill or Rubick.Skill_Can_Be_Stolen ~= stolenSkill.info["Stolen Tag"] then
    isUlt = false
  else
    local rubickSkill = hero.skills[stolenSkill.info["Skill Name"]]
    if rubickSkill then
      local target = rubickSkill:selectTarget(nil)
      target = target or hero.ai.target
      rubickSkill.cd_remaining = 0
      isUlt, reason = rubickSkill:canCastWithTarget(target)
    end
  end
  if not isUlt then
    stolenSkill = hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex].last_stolen_skill
    if stolenSkill then
      local rubickSkill = hero.skills[stolenSkill.info["Skill Name"]]
      if rubickSkill == nil then
        p(hero.rubickUltTargetQueue)
      end
      if rubickSkill and rubickSkill:selectTarget(nil) then
        rubickSkill.cd_remaining = 0
        if rubickSkill:canCastWithTarget(rubickSkill.target) then
        else
          isRubickSkill = true
        end
        rubickSkill.cd_remaining = 999
      else
        isRubickSkill = true
      end
    else
      isRubickSkill = true
    end
  end
  return stolenSkill, isUlt, isRubickSkill
end

function Rubick.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if caster.manually_casting then
    ed.engine:unfreeze()
    caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 1 then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if not unit.config.is_summoned and unit.name ~= caster.name and not unit.NotStolenByRubick and not unit.controlledTarget then
        caster.rubickUltTargetQueue[#caster.rubickUltTargetQueue + 1] = unit
      end
    end
    for i = 1, #caster.rubickUltTargetQueue do
      local swapIndex = math.floor(ed.rand() * (#caster.rubickUltTargetQueue - i + 1)) + i
      local temp = caster.rubickUltTargetQueue[i]
      caster.rubickUltTargetQueue[i] = caster.rubickUltTargetQueue[swapIndex]
      caster.rubickUltTargetQueue[swapIndex] = temp
    end
    if #caster.rubickUltTargetQueue == 0 then
      skill:finish()
      if ed.protoAwake(caster.proto, 85) then
        caster:castSkill(caster.skills[Rubick.heroName .. "_atk2b"], nil)
      else
        caster:castSkill(caster.skills[Rubick.heroName .. "_atk2"], nil)
      end
    else
      caster.rubickUltTargetQueueIndex = 0
      caster.rubickUltTimeTag = Rubick.ultTimeGap
      caster.rubickUltTimesTag = 0
      if caster.ai.will_cast_manual_skill then
        caster.rubickUltRandSeed = 1 + math.floor(ed.rand() * Rubick.arenaUltMaxCount)
      end
    end
  else
    local stolenTarget = caster.rubickUltTargetQueue[caster.rubickUltTargetQueueIndex]
    local success = false
    local isRubickSkill = false
    if stolenTarget then
      local stolenSkill, isUlt, isRubickSkill = Rubick.skillult_getSkill(caster)
      caster.castingStolenSkill_Rubick = Rubick.CASTINGULT
      if not isRubickSkill then
        success = Rubick.castStolenSkill(caster, stolenSkill, skill.info["Script Arg2"])
      end
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(Rubick.stolenTargetImpactEffect, {
          stolenTarget.position[1],
          stolenTarget.position[2] - 1
        }, {
          stolenTarget.direction,
          1
        }, nil, 0)
      end
    end
    if 0 < caster.rubickUltTargetQueueIndex then
      local lastTarget = caster.rubickUltTargetQueue[caster.rubickUltTargetQueueIndex]
      if caster.rubickUltTargetQueue[caster.rubickUltTargetQueueIndex]:isAlive() then
        for i, tbuff in pairs(lastTarget.buff_list) do
          if tbuff.info.ID == Rubick.ulttagBuffID then
            lastTarget:removeBuff(tbuff)
            break
          end
        end
      end
    end
    for i, tbuff in pairs(caster.buff_list) do
      if tbuff.info.ID == Rubick.ulttagBuffSelfID then
        caster:removeBuff(tbuff)
        break
      end
    end
    caster.rubickUltTargetQueue = {}
    caster.rubickUltTargetQueueIndex = nil
    caster.rubickUltTimeTag = nil
    caster.rubickUltTimesTag = nil
    caster.rubickUltRandSeed = nil
    if not (stolenTarget and success) or isRubickSkill then
      skill:finish()
      if ed.protoAwake(caster.proto, 85) then
        caster:castSkill(caster.skills[Rubick.heroName .. "_atk2b"], nil)
      else
        caster:castSkill(caster.skills[Rubick.heroName .. "_atk2"], nil)
      end
      caster.castingStolenSkill_Rubick = nil
    end
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(Rubick.switchPuppetPointEffect, {
        caster.position[1],
        caster.position[2] - 2
      }, {
        caster.direction,
        1
      }, nil, 0)
    end
  end
end

function Rubick.skillult_canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function Rubick.skillult_trigger(basefunc, skill)
  skill:onAttackFrame()
end

function Rubick.skillult_interrupt(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    for i, tbuff in pairs(caster.buff_list) do
      if tbuff.info.ID == Rubick.ulttagBuffSelfID then
        caster:removeBuff(tbuff)
        break
      end
    end
    caster.rubickUltTargetQueue = {}
    caster.rubickUltTargetQueueIndex = nil
    caster.rubickUltTimeTag = nil
    caster.rubickUltTimesTag = nil
    caster.rubickUltRandSeed = nil
  end
end

function Rubick.hero_addBuff(basefunc, hero, buff_Or_Binfo, caster)
  local skillult = Rubick.heroName .. "_ult"
  if ed.protoAwake(hero.proto, 85) then
    skillult = Rubick.heroName .. "_ultb"
  end
  if hero.current_skill and hero.current_skill.info["Skill Name"] == skillult and hero.current_skill.attack_counter == 1 then
    if hero.state == ed.emUnitState_Dead then
      return
    end
    local buff
    if buff_Or_Binfo.class == ed.Buff then
      buff = buff_Or_Binfo
    else
      buff = ed.BuffCreate(buff_Or_Binfo, hero, caster)
    end
    for i, effect in ipairs(buff.info["Control Effects"]) do
      if effect == "stun" or effect == "frozen" or effect == "silence" or effect == "imprisonment" or effect == "fear" or effect == "enchanted" or effect == "icefrozen" then
        hero.current_skill:onAttackFrame()
        return nil
      end
    end
    return basefunc(hero, buff_Or_Binfo, caster)
  else
    return basefunc(hero, buff_Or_Binfo, caster)
  end
end

function Rubick.GameEndTagBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.owner
  caster:rewritePuppetStack(1, Rubick.heroPuppet)
  if caster.current_skill then
    caster.manually_casting = false
    caster.current_skill:finish()
  end
end

function Rubick.hero_reset(basefunc, hero)
  hero.Lancer_mirror_count = 0
  if hero.reset_counter_Rubick == 2 then
    Rubick.initRubickSkillList(hero)
    Rubick.initRubickPeriodGroup(hero)
    hero.reset_counter_Rubick = 1
    hero:reset()
  else
    basefunc(hero)
    hero:enterActionStageFromOneStage(Rubick.initPeriodGroup, 85)
    if hero:isAlive() then
      local bid = Rubick.gameEndTagBuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
      buff.onRemoved = override(buff.onRemoved, Rubick.GameEndTagBuff_onRemoved)
    end
    hero.reset_counter_Rubick = 2
    if hero.stolenPuppetId_Rubick then
      hero:removePuppet(hero.stolenPuppetId_Rubick)
    end
    hero.castingUlt_Rubick = nil
    hero.castingStolenSkill_Rubick = nil
    hero.stolenPuppetId_Rubick = nil
    hero.currentActionStage = Rubick.initPeriodGroup
    hero.rubickUltTargetQueue = {}
    hero.rubickUltTargetQueueIndex = nil
    hero.rubickUltTimeTag = nil
    hero.rubickUltTimesTag = nil
    hero.rubickUltRandSeed = nil
    hero.autoBattleRandSeed_Rubick = nil
    if ed.run_with_scene then
      local panel = hero.heroPanel
      if panel then
        panel:setPortrait(ed.recoverColum(Rubick.heroPortrait))
        panel:setNextPortrait(nil)
      end
    end
  end
end

function Rubick.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.rubickUltTimeTag and hero:isAlive() then
    hero.rubickUltTimeTag = hero.rubickUltTimeTag + dt
    if hero.rubickUltTimeTag >= Rubick.ultTimeGap then
      hero.rubickUltTimeTag = hero.rubickUltTimeTag - Rubick.ultTimeGap
      hero.rubickUltTimesTag = hero.rubickUltTimesTag + 1
      if hero.rubickUltRandSeed then
        hero.rubickUltRandSeed = hero.rubickUltRandSeed - 1
        if hero.rubickUltRandSeed < 0 then
          local stolenSkill, isUlt, isRubickSkill = Rubick.skillult_getSkill(hero)
          if isUlt then
            local skillult = hero.skills[Rubick.heroName .. "_ult"]
            if ed.protoAwake(hero.proto, 85) then
              skillult = hero.skills[Rubick.heroName .. "_ultb"]
            end
            skillult:onAttackFrame()
            return
          end
        end
      end
      if hero.autoBattleRandSeed_Rubick and 0 < hero.autoBattleRandSeed_Rubick then
        hero.autoBattleRandSeed_Rubick = hero.autoBattleRandSeed_Rubick - 1
      end
      if hero.rubickUltTimesTag > Rubick.ultMaxJumpTimes then
        local skillult = hero.skills[Rubick.heroName .. "_ult"]
        if ed.protoAwake(hero.proto, 85) then
          skillult = hero.skills[Rubick.heroName .. "_ultb"]
        end
        skillult:onAttackFrame()
        return
      end
      if hero.rubickUltTargetQueueIndex and 0 <= hero.rubickUltTargetQueueIndex and hero.rubickUltTargetQueueIndex <= #hero.rubickUltTargetQueue then
        if 0 < hero.rubickUltTargetQueueIndex then
          local lastTarget = hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex]
          if hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex]:isAlive() then
            for i, tbuff in pairs(lastTarget.buff_list) do
              if tbuff.info.ID == Rubick.ulttagBuffID then
                lastTarget:removeBuff(tbuff)
                break
              end
            end
          end
        end
        hero.rubickUltTargetQueueIndex = (hero.rubickUltTargetQueueIndex + 1) % #hero.rubickUltTargetQueue
        if hero.rubickUltTargetQueueIndex == 0 then
          hero.rubickUltTargetQueueIndex = hero.rubickUltTargetQueueIndex + #hero.rubickUltTargetQueue
        end
        if hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex].controlledTarget then
          hero.rubickUltTargetQueueIndex = (hero.rubickUltTargetQueueIndex + 1) % #hero.rubickUltTargetQueue
          if hero.rubickUltTargetQueueIndex == 0 then
            hero.rubickUltTargetQueueIndex = hero.rubickUltTargetQueueIndex + #hero.rubickUltTargetQueue
          end
        end
        local counter = 1
        while not hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex]:isAlive() do
          counter = counter + 1
          if counter > #hero.rubickUltTargetQueue then
            local skillult = hero.skills[Rubick.heroName .. "_ult"]
            if ed.protoAwake(hero.proto, 85) then
              skillult = hero.skills[Rubick.heroName .. "_ultb"]
            end
            skillult:onAttackFrame()
            return
          end
          hero.rubickUltTargetQueueIndex = (hero.rubickUltTargetQueueIndex + 1) % #hero.rubickUltTargetQueue
          if hero.rubickUltTargetQueueIndex == 0 then
            hero.rubickUltTargetQueueIndex = hero.rubickUltTargetQueueIndex + #hero.rubickUltTargetQueue
          end
        end
        local thisUnit = hero.rubickUltTargetQueue[hero.rubickUltTargetQueueIndex]
        local nextUnitIndex = hero.rubickUltTargetQueueIndex + 1
        if nextUnitIndex > #hero.rubickUltTargetQueue then
          nextUnitIndex = nextUnitIndex - #hero.rubickUltTargetQueue
        end
        local nextUnit = hero.rubickUltTargetQueue[nextUnitIndex]
        local binfo = ed.lookupDataTable("Buff", nil, Rubick.ulttagBuffID)
        local buff = thisUnit:addBuff(binfo, hero)
        if ed.run_with_scene then
          local panel = hero.heroPanel
          if panel then
            if Rubick.version == "Global" then
              local thisUnitPortrait = thisUnit.info.Portrait
              local nextUnitPortrait = nextUnit.info.Portrait
              if ed.protoAwake(thisUnit.proto) then
                thisUnitPortrait = thisUnit.info["Portrait Switch"]
              end
              if ed.protoAwake(nextUnit.proto) then
                nextUnitPortrait = thisUnit.info["Portrait Switch"]
              end
              panel:setPortrait(ed.recoverColum(thisUnitPortrait))
              panel:setNextPortrait(ed.recoverColum(nextUnitPortrait))
            elseif Rubick.version == "CHN" then
              local thisUnitPortrait = ed.getUnitPortrait(thisUnit.tid)
              local nextUnitPortrait = ed.getUnitPortrait(nextUnit.tid)
              if ed.protoAwake(thisUnit.proto) then
                thisUnitPortrait = ed.getUnitPortraitSwitch(thisUnit.tid)
              end
              if ed.protoAwake(nextUnit.proto) then
                nextUnitPortrait = ed.getUnitPortraitSwitch(nextUnit.tid)
              end
              panel:setPortrait(thisUnitPortrait)
              panel:setNextPortrait(nextUnitPortrait)
            end
          end
        end
      end
    end
  end
end

function Rubick.hero_enterActionStageFromOneStage(basefunc, hero, nStage, id)
  local periodGroup = ed.lookupDataTable("Unit", "Period Group", id)
  if hero.rubickPeriodGroup[periodGroup] then
    if nStage == Rubick.initPeriodGroup or nStage == 1 then
      for _, skill in pairs(hero.skill_list) do
        skill:resume()
        if skill.originPuppet_Rubick then
          skill.cd_remaining = 999
          if skill.isManual_Rubick then
            skill.info["Cost MP"] = 0
          end
        end
      end
      hero.currentActionStage = Rubick.initPeriodGroup
      hero:rewritePuppetStack(1, Rubick.heroPuppet)
      hero.attack_range = hero.basic_skill.info["Max Range"] - 5
      local puppetBuffList = {}
      for i, tbuff in pairs(hero.buff_list) do
        if tbuff.info.ID == Rubick.newPuppetBuff2 then
          puppetBuffList[#puppetBuffList + 1] = tbuff
        end
      end
      for i, tbuff in pairs(puppetBuffList) do
        hero:removeBuff(tbuff)
      end
    else
      local stageData = ed.lookupDataTable("Period", nil, periodGroup, nStage)
      if stageData then
        local puppetName = stageData["Puppet ID"]
        hero:rewritePuppetStack(1, puppetName)
        hero:resetSkillList(stageData)
        local translationActionName = stageData["Enter Action"]
        if translationActionName and translationActionName ~= "" then
          hero:setAction(translationActionName)
        end
      end
      hero.currentActionStage = nStage
    end
  end
end

function Rubick.hero_resetSkillList(basefunc, self, stageData)
  self.current_skill = nil
  self.last_stolen_skill = nil
  self.last_stolen_skill_puppet = nil
  self.action_duration = 0
  self.action_elapsed = 0
  for _, skill in ipairs(self.skill_list) do
    skill:pause()
  end
  local _normalSkillId = stageData["Basic Skill"]
  local _skillList = stageData["Skill List"]
  for _, id in ipairs(_skillList) do
    id = tonumber(id)
    for _, skill in ipairs(self.skill_list) do
      if id == skill.info.groupId then
        skill:reset()
        skill:resume()
        skill.cd_remaining = skill.info["Init CD"]
        if skill.isManual_Rubick then
          skill.info["Cost MP"] = 1000
        end
      end
    end
  end
  local basic_skill = self.skills[_normalSkillId]
  self.attack_range = basic_skill.info["Max Range"] - 5
end

function Rubick.hero_die(basefunc, hero, killer)
  if hero.currentActionStage ~= Rubick.initPeriodGroup then
    hero:rewritePuppetStack(1, Rubick.heroPuppet)
  end
  basefunc(hero, killer)
end

function Rubick.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.die = override(hero.die, Rubick.hero_die)
  hero.reset = override(hero.reset, Rubick.hero_reset)
  hero.update = override(hero.update, Rubick.hero_update)
  hero.enterActionStageFromOneStage = override(hero.enterActionStageFromOneStage, Rubick.hero_enterActionStageFromOneStage)
  hero.resetSkillList = override(hero.resetSkillList, Rubick.hero_resetSkillList)
  hero.addBuff = override(hero.addBuff, Rubick.hero_addBuff)
  hero.reset_counter_Rubick = 2
  if ed.protoAwake(hero.proto, 85) then
    Rubick.heroPuppet = Rubick.heroPuppetSwitch
    Rubick.heroPortrait = Rubick.heroPortraitSwitch
    Rubick.ulttagBuffID = Rubick.ulttagBuffIDSwitch
    Rubick.switchPuppetPointEffect = Rubick.switchPuppetPointEffect2
    Rubick.stolenTargetImpactEffect = Rubick.stolenTargetImpactEffect2
    Rubick.initPeriodGroup = Rubick.initPeriodGroup2
  end
  local skillult = hero.skills[Rubick.heroName .. "_ult"]
  if skillult then
    skillult.info["No Speeder"] = true
    skillult.start = override(skillult.start, Rubick.skillult_start)
    skillult.finish = override(skillult.finish, Rubick.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Rubick.skillult_canCastWithTarget)
    skillult.canTrigger = override(skillult.canTrigger, Rubick.skillult_canTrigger)
    skillult.trigger = override(skillult.trigger, Rubick.skillult_trigger)
    skillult.interrupt = override(skillult.interrupt, Rubick.skillult_interrupt)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Rubick.skillult_onAttackFrame)
  end
  local skillultb = hero.skills[Rubick.heroName .. "_ultb"]
  if skillultb then
    skillultb.info["No Speeder"] = true
    skillultb.start = override(skillultb.start, Rubick.skillult_start)
    skillultb.finish = override(skillultb.finish, Rubick.skillult_finish)
    skillultb.canCastWithTarget = override(skillultb.canCastWithTarget, Rubick.skillult_canCastWithTarget)
    skillultb.canTrigger = override(skillultb.canTrigger, Rubick.skillult_canTrigger)
    skillultb.trigger = override(skillultb.trigger, Rubick.skillult_trigger)
    skillultb.interrupt = override(skillultb.interrupt, Rubick.skillult_interrupt)
    skillultb.onAttackFrame = override(skillultb.onAttackFrame, Rubick.skillult_onAttackFrame)
  end
  local skillatk3 = hero.skills[Rubick.heroName .. "_atk3"]
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Rubick.skillatk3_onAttackFrame)
  end
  local skillatk3b = hero.skills[Rubick.heroName .. "_atk3b"]
  if skillatk3b then
    skillatk3b.onAttackFrame = override(skillatk3b.onAttackFrame, Rubick.skillatk3_onAttackFrame)
  end
  return hero
end

return Rubick.init_hero
