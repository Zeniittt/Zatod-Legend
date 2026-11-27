module("ed.battlehero", package.seeall)
local ed = ed
TitanDH = {}
TitanDH.Guord_id = 283
TitanDH.heroID = 10096
TitanDH.TitanDH_ult_invisBuffID = 4248
TitanDH.TitanDH_ult_Gourd_selfBuffID = 4254
TitanDH.TitanDH_ult_GourdTimer_BuffID = 4255
TitanDH.TitanDH_ult_Gourd_building_BuffID = 4256
TitanDH.TitanDH_ult_Gourd_inv_BuffID = 4257
TitanDH.TitanDH_atk3b_invulnerable_BuffID = 4260
TitanDH.TitanDH_ult_self_BuffID = 4261
TitanDH.TitanDH_ult_normal_BuffID = 4262
TitanDH.TitanDH_ult_building_BuffID = 4263
TitanDH.TitanDH_atk4_HPRbase = -20
TitanDH.TitanDH_atk4_HPRratio = 0.05
TitanDH.Arcana4_mp = 150
TitanDH.atk4_max_dis = 250

function TitanDH.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = 0
    end
  end
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanDH.atk4_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local ratio2 = 1
  if caster.TitanDH_hasArcana and caster.TitanDH_hasArcana > 2 then
    ratio2 = 2
  end
  if buff.caster_currentActionStage ~= caster.currentActionStage then
    local HPR = buff.origin_hpr - caster.attribs.AD * TitanDH.TitanDH_atk4_HPRratio
    if caster.currentActionStage == 2 then
      buff:setAttribute("HPR", HPR * 1.5 * ratio2)
    else
      buff:setAttribute("HPR", HPR * ratio2)
    end
  end
end

function TitanDH.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local ratio2 = 1
  if caster.TitanDH_hasArcana and caster.TitanDH_hasArcana > 2 then
    ratio2 = 2
  end
  local caster_currentActionStage = caster.currentActionStage
  buff.caster_currentActionStage = caster_currentActionStage
  buff.origin_hpr = buff.info.HPR
  local HPR = buff.origin_hpr - caster.attribs.AD * TitanDH.TitanDH_atk4_HPRratio
  if caster.currentActionStage == 2 then
    buff:setAttribute("HPR", HPR * 1.5 * ratio2)
  else
    buff:setAttribute("HPR", HPR * ratio2)
  end
  buff.update = override(buff.update, TitanDH.atk4_buff_update)
  return buff
end

function TitanDH.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = 0
    end
  end
  local skillatk4 = caster.skills.TitanDH_atk4
  if skillatk4 then
    local binfo2 = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_Gourd_inv_BuffID)
    local atk4Buff = ed.BuffCreate(binfo2, caster, caster)
    atk4Buff:setAttribute("HIT", skillatk4.info["Script Arg2"])
    atk4Buff:setAttribute("LFSRatio", skillatk4.info["Script Arg3"])
    caster:addBuff(atk4Buff, caster)
    skillatk4.target = caster
    local region = skillatk4:createRegion()
    ed.engine:addRegion(region)
  end
  caster.isActionStageChangeByManual = true
  caster:enterActionStageFromOneStage(3, TitanDH.heroID)
end

function TitanDH.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_self_BuffID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("ARM", skill.info["Script Arg2"])
    caster:addBuff(binfo, caster)
    local gourd = caster.TitanDH_Gourd
    local Gourd_pos, Gourd_h = skill:launchPoint()
    gourd.TitanDH_position = {
      Gourd_pos[1],
      caster.position[2]
    }
    local gourdSkillult = gourd.skills.TitanDHGourd_ult
    if gourdSkillult then
      gourd:castSkill(gourdSkillult)
    end
    local enemyCounter = 0
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit:isAlive() and not unit.config.is_summoned then
        enemyCounter = enemyCounter + 1
      end
    end
    if 1 < enemyCounter and (caster.currentActionStage == 1 or caster.currentActionStage == 3) then
      caster.isActionStageChangeByManual = true
      caster:enterActionStageFromOneStage(2, TitanDH.heroID)
    end
  end
  basefunc(skill)
end

function TitanDH.skillult_finish(basefunc, skill, reason)
  local caster = skill.caster
  local enemyCounter = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit:isAlive() and not unit.config.is_summoned then
      enemyCounter = enemyCounter + 1
    end
  end
  if reason ~= "interrupt" and (caster.currentActionStage == 1 or caster.currentActionStage == 3) and 1 < enemyCounter then
    caster.isActionStageChangeByManual = true
    caster:enterActionStageFromOneStage(2, TitanDH.heroID)
  elseif caster.TitanDH_Gourd then
    caster.TitanDH_Gourd.position[1] = 400 - 600 * caster.camp
  end
  basefunc(skill, reason)
end

function TitanDH.gourdSkillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local summoner = caster.config.summoner
  local target = skill.target
  if not skill.target then
    skill:selectTarget()
    target = skill.target
  end
  if not target then
    skill:interrupt()
    summoner.current_skill:interrupt()
    summoner.mp = math.min(1000, summoner.mp + 500)
    caster.position[1] = 400 - 500 * caster.camp
    return
  end
  local positionS = {
    summoner.position[1],
    summoner.position[2]
  }
  local positionT = {
    target.position[1],
    target.position[2]
  }
  local positionC = caster.TitanDH_position
  local dirX = (positionT[1] - positionC[1]) / math.abs(positionT[1] - positionC[1])
  local destination = {
    positionT[1] - dirX * 100,
    positionT[2] + 5
  }
  local direction = {
    (destination[1] - positionC[1]) / math.abs(destination[1] - positionC[1]),
    (destination[2] - positionC[2]) / math.abs(destination[2] - positionC[2])
  }
  caster.manual_moving = true
  local walk_v = {
    (destination[1] - positionC[1]) / 0.6,
    (destination[2] - positionC[2]) / 0.6
  }
  caster.position = {
    caster.TitanDH_position[1] - (caster.direction and caster.direction or 1) * walk_v[1] * 0.125,
    caster.TitanDH_position[2]
  }
  caster.TitanDHGourd_direction = (positionT[1] - positionS[1]) / math.abs(positionT[1] - positionS[1])
  local binfo2 = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_Gourd_building_BuffID)
  caster:addBuff(binfo2, summoner)
  positionC = {
    caster.position[1],
    caster.position[2]
  }
  caster.walk_v = {
    (destination[1] - positionC[1]) / 0.6,
    (destination[2] - positionC[2]) / 0.6
  }
end

function TitanDH.gourdSkillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  if reason ~= "interrupt" then
    local casterFather = skill.caster.config.summoner
    local caster = skill.caster
    local enemyCounter = 0
    for unit in ed.engine:foreachAliveUnit(casterFather.foecamp) do
      if unit:isAlive() and not unit.config.is_summoned then
        enemyCounter = enemyCounter + 1
      end
    end
    local binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_GourdTimer_BuffID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    for i, bbuff in ipairs(caster.buff_list) do
      if bbuff.info.ID == TitanDH.TitanDH_ult_Gourd_building_BuffID then
        bbuff.timer = 0
      end
    end
    buff.update = override(buff.update, TitanDH.GourdTimerBuff_update)
    buff.onRemoved = override(buff.onRemoved, TitanDH.GourdTimerBuff_onRemoved)
    if 1 < enemyCounter then
      buff.timer = math.min(math.max(4, casterFather.attribs.STR * 0.0015), 18)
    else
      buff.timer = 0.125
    end
    caster:addBuff(buff, caster)
  end
end

function TitanDH.GourdTimerBuff_update(basefunc, buff, dt)
  local summoner = buff.owner.config.summoner
  if buff.timer - dt < 0 and summoner.current_skill and summoner.current_skill.info["Skill Name"] == "TitanDH_atk3b" and summoner.current_skill.casting then
    buff.timer = dt
  end
  if buff.owner.TitanDHGourd_target and not buff.owner.TitanDHGourd_target:isAlive() then
    buff.timer = 999
  end
  basefunc(buff, dt)
  local enemyCounter = 0
  for unit in ed.engine:foreachAliveUnit(buff.owner.foecamp) do
    if unit:isAlive() and not unit.config.is_summoned then
      enemyCounter = enemyCounter + 1
    end
  end
  if enemyCounter <= 1 then
    buff.timer = 0
  end
end

function TitanDH.GourdTimerBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster then
    local skillultb = caster.skills.TitanDHGourd_ultb
    if skillultb then
      if caster.current_skill and caster.current_skill.info["Skill Name"] == "TitanDHGourd_ult" then
        caster.current_skill:interrupt()
        caster.position[1] = 400 - 500 * caster.camp
        return
      end
      caster:castSkill(skillultb, caster.TitanDHGourd_target)
    end
  end
end

function TitanDH.SHBuffEffect(unit, value)
  for i, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor and buff.timer > 0 then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(value)
      end
    end
  end
end

function TitanDH.gourdSkillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    caster.manual_moving = nil
    caster.walk_v = {0, 0}
  end
  basefunc(skill)
  if skill.attack_counter == 2 then
    local target = skill.target
    local enemyCounter = 0
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit:isAlive() and not unit.config.is_summoned then
        enemyCounter = enemyCounter + 1
      end
    end
    if target and target:isAlive() then
      for i, bbuff in ipairs(target.buff_list) do
        if bbuff.info.ID == TitanDH.TitanDH_ult_building_BuffID then
          bbuff.timer = 0
        end
      end
      local binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_invisBuffID)
      local summoner = caster.config.summoner
      summoner.TitanDH_ultTarget = target
      caster.TitanDHGourd_target = target
      local buff = ed.BuffCreate(binfo, target, caster)
      if enemyCounter <= 1 then
        binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_normal_BuffID)
        buff = ed.BuffCreate(binfo, target, caster)
        local casterFather = caster.config.summoner
        local skillultc = casterFather.skills.TitanDH_ultc
        if skillultc then
          skillultc:takeEffectOn(target, summoner)
        end
        skill:interrupt()
        if casterFather.current_skill == casterFather.manual_skill then
          casterFather.current_skill:interrupt()
        end
      else
        summoner.TitanDH_hasTarget = true
        buff:setAttribute("HPR", math.min(math.abs(summoner.attribs.HP / 100 * 3), math.abs(target.attribs.HP / 100 * 3)) * -1)
        buff:setAttribute("MPR", -15)
        TitanDH.SHBuffEffect(target, false)
        target:setHpVisible(false)
        target:setFuryVisible(false)
      end
      buff.onRemoved = override(buff.onRemoved, TitanDH.gourdUltBuff_onRemoved)
      local buff_source = summoner or caster
      target:addBuff(buff, buff_source)
    end
  end
end

function TitanDH.gourdUltBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster.config.summoner
  local target = buff.caster.TitanDHGourd_target
  local skillultc = caster.skills.TitanDH_ultc
  target:setHpVisible(true)
  target:setFuryVisible(true)
  if skillultc then
    skillultc:takeEffectOn(target, caster)
  end
end

function TitanDH.gourdSkillultb_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local summoner = caster.config.summoner
  if skill.attack_counter == 1 then
    local target = caster.TitanDHGourd_target
    if target and target:isAlive() then
      for i, buff in ipairs(target.buff_list) do
        if buff.info.ID == TitanDH.TitanDH_ult_invisBuffID then
          buff.timer = 0
        end
      end
      TitanDH.SHBuffEffect(target, true)
      if ed.run_with_scene then
        local effect_name = "eff_impact_BruceWayne_ult.cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, target.position, nil, nil, 1)
      end
      summoner.TitanDH_hasTarget = nil
    end
  elseif skill.attack_counter == 2 then
    local summoner = caster.config.summoner
    local positionCX = caster.position[1]
    local positionSX = summoner.position[1]
    caster.TitanDHGourd_direction = (positionCX - positionSX) / math.abs(positionCX - positionSX)
    local binfo2 = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_Gourd_building_BuffID)
    caster:addBuff(binfo2, summoner or caster)
    local positionG = {
      caster.position[1],
      caster.position[2]
    }
    local positionC = {
      summoner.position[1],
      summoner.position[2]
    }
    if summoner.current_skill and summoner.current_skill.info["Skill Name"] == "TitanDH_atk3b" then
      positionC[1] = positionC[1] + 240 * summoner.direction
    end
    local dirX = (positionC[1] - positionG[1]) / math.abs(positionC[1] - positionG[1])
    caster.TitanDH_gourd_direction = -dirX
    local destination = {
      positionC[1] - dirX * 90,
      positionC[2]
    }
    local direction = {
      (destination[1] - positionG[1]) / math.abs(destination[1] - positionG[1]),
      (destination[2] - positionG[2]) / math.abs(destination[2] - positionG[2])
    }
    caster.manual_moving = true
    caster.walk_v = {
      (destination[1] - positionG[1]) / 0.375,
      (destination[2] - positionG[2]) / 0.375
    }
  end
end

function TitanDH.gourdSkillultb_finish(basefunc, skill, reason)
  local caster = skill.caster
  local summoner = caster.config.summoner
  caster.manual_moving = nil
  caster.walk_v = {0, 0}
  basefunc(skill, reason)
  for i, bbuff in ipairs(caster.buff_list) do
    if bbuff.info.ID == TitanDH.TitanDH_ult_Gourd_building_BuffID then
      bbuff.timer = 0
    end
  end
  if summoner then
    local skillultb = summoner.skills.TitanDH_ultb
    if skillultb then
      if summoner.current_skill then
        summoner.current_skill:interrupt()
      end
      summoner:castSkill(skillultb, summoner)
    end
  end
  caster.position[1] = 400 - 500 * caster.camp
end

function TitanDH.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.currentActionStage then
    hero.isActionStageChangeByManual = true
    hero:enterActionStageFromOneStage(3, TitanDH.heroID)
    local skillatk4 = hero.skills.TitanDH_atk4
    if skillatk4 then
      local binfo2 = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_Gourd_inv_BuffID)
      local atk4Buff = ed.BuffCreate(binfo2, hero, hero)
      atk4Buff:setAttribute("HIT", skillatk4.info["Script Arg2"])
      atk4Buff:setAttribute("LFSRatio", skillatk4.info["Script Arg3"])
      hero:addBuff(atk4Buff, hero)
    end
  else
    local skillenter = hero.skills.TitanDH_enter
    if skillenter then
      local bid = 651
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
    end
  end
  local proto = {
    _tid = TitanDH.Guord_id,
    _level = hero.level or 1,
    _skill_levels = {
      hero.level or 1,
      hero.level or 1
    },
    _stars = hero.stars,
    _rank = hero.rank,
    _fashion = {
      _current_fashion = hero.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = hero.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or hero.config.hp_mod,
    dps_mod = hero.config.dps_mod or 1,
    zOrder = 999
  }
  local Gourd = ed.UnitCreate(proto, hero.camp, config)
  local dir = hero.direction
  Gourd.direction = dir or Gourd.direction
  local side = hero:getSide()
  local summonside = 1
  if side == "left_side" then
    summonside = 1
  elseif side == "right_side" then
    summonside = -1
  end
  local Gourd_location = {
    400 - 600 * summonside,
    0
  }
  if hero:isAlive() then
    Gourd.update = override(Gourd.update, TitanDH.Gourd_update)
    Gourd.getFixDir = override(Gourd.getFixDir, TitanDH.Gourd_getFixDir)
    local gourdSkillult = Gourd.skills.TitanDHGourd_ult
    local gourdSkillultb = Gourd.skills.TitanDHGourd_ultb
    if gourdSkillult then
      gourdSkillult.selectTarget = override(gourdSkillult.selectTarget, TitanDH.skillult_selectTarget)
      gourdSkillult.start = override(gourdSkillult.start, TitanDH.gourdSkillult_start)
      gourdSkillult.onAttackFrame = override(gourdSkillult.onAttackFrame, TitanDH.gourdSkillult_onAttackFrame)
      gourdSkillult.finish = override(gourdSkillult.finish, TitanDH.gourdSkillult_finish)
    end
    if gourdSkillultb then
      gourdSkillultb.onAttackFrame = override(gourdSkillultb.onAttackFrame, TitanDH.gourdSkillultb_onAttackFrame)
      gourdSkillultb.finish = override(gourdSkillultb.finish, TitanDH.gourdSkillultb_finish)
    end
    ed.engine:summonUnit(Gourd, Gourd_location, hero, "Move")
    hero.TitanDH_Gourd = Gourd
  end
end

function TitanDH.Gourd_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.TitanDHGourd_invuBuff then
    local binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_Gourd_selfBuffID)
    hero:addBuff(binfo, hero)
    hero.TitanDHGourd_invuBuff = true
  end
  local summoner = hero.config.summoner
  if not hero.direction then
    local dir = summoner.direction
    hero.direction = dir or hero.direction
    hero.getFixDir = override(hero.getFixDir, TitanDH.Gourd_getFixDir)
  end
  if not summoner or summoner and not summoner:isAlive() then
    local gourdtarget = hero.TitanDHGourd_target
    if gourdtarget and gourdtarget:isAlive() then
      for i, bbuff in ipairs(gourdtarget.buff_list) do
        if bbuff.info.ID == TitanDH.TitanDH_ult_invisBuffID then
          bbuff.timer = 0
          TitanDH.SHBuffEffect(gourdtarget, true)
          gourdtarget:setHpVisible(true)
          gourdtarget:setFuryVisible(true)
        end
      end
    end
    hero:onDying()
  end
end

function TitanDH.Gourd_getFixDir(basefunc, unit)
  local dir = unit.TitanDHGourd_direction
  return dir
end

function TitanDH.skillultb_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  caster.isActionStageChangeByManual = true
  caster:enterActionStageFromOneStage(3, TitanDH.heroID)
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanDH.TitanDH_ult_self_BuffID then
      buff.timer = 0
    end
  end
end

function TitanDH.skillatk3b_start(basefunc, skill, target)
  skill:lockCasterDirection(true)
  local caster = skill.caster
  local dir = caster.direction
  caster.TitanDH_atk3b_direction = dir
  local binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_atk3b_invulnerable_BuffID)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanDH.skillatk3b_interrupt(basefunc, skill)
  local caster = skill.caster
  local direction = caster.TitanDH_atk3b_direction
  local pos = caster.position[1]
  if skill.attack_counter == 1 then
    caster.position[1] = pos + 240 * direction
  end
  basefunc(skill)
end

function TitanDH.skillatk3b_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  local direction = caster.TitanDH_atk3b_direction
  local pos = caster.position[1]
  if skill.attack_counter == 1 and reason ~= "interrupt" then
    caster.position[1] = pos + 240 * direction
  end
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanDH.TitanDH_atk3b_invulnerable_BuffID then
      buff.timer = 0
    end
  end
  skill:lockCasterDirection(false)
end

function TitanDH.hero_onDying(basefunc, unit, skiller)
  local gourd = unit.TitanDH_Gourd
  if gourd and gourd:isAlive() then
    local gourdtarget = gourd.TitanDHGourd_target
    if gourdtarget and gourdtarget:isAlive() then
      for i, bbuff in ipairs(gourdtarget.buff_list) do
        if bbuff.info.ID == TitanDH.TitanDH_ult_invisBuffID then
          bbuff.timer = 0
          TitanDH.SHBuffEffect(gourdtarget, true)
          gourdtarget:setHpVisible(true)
          gourdtarget:setFuryVisible(true)
        end
      end
    end
    gourd:onDying(skiller)
  end
  basefunc(unit, skiller)
end

function TitanDH.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function TitanDH.skillultb_start(basefunc, skill, target)
  local caster = skill.caster
  local gourd = caster.TitanDH_Gourd
  caster.direction = gourd.TitanDH_gourd_direction or caster.direction
  gourd.direction = gourd.TitanDH_gourd_direction or gourd.direction
  basefunc(skill, target)
end

function TitanDH.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local skilltarget = skill.target
  if skilltarget and skilltarget:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, TitanDH.TitanDH_ult_building_BuffID)
    skilltarget:addBuff(binfo, skill.caster)
  end
end

function TitanDH.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if lost then
    local target = hero.TitanDH_ultTarget
    local target_damage
    local lost2 = lost
    if hero.TitanDH_hasTarget and target and target:isAlive() then
      if hero.TitanDH_hasArcana and hero.TitanDH_hasArcana > 1 then
        lost = 0.05 * lost2
        target_damage = 0.95 * lost2
      else
        lost = 0.5 * lost2
        target_damage = 0.5 * lost2
      end
      target:takeDamage(target_damage, "Holy", "hp", hero)
    end
  end
  return lost
end

function TitanDH.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.timer = buff.timer + caster.attribs.STR * 5.0E-4
  return buff
end

function TitanDH.skillult_selectTarget(basefunc, skill, default)
  local target_type = skill.info["Target Type"]
  local selector = skill:target_selector()
  local Ignore = skill:Ignore_Target_Type()
  if target_type == "target" then
    if default then
      skill.target = default
    else
      local t, distanceSQ = skill.caster.ai:searchTarget()
      if distanceSQ <= skill.max_range_sq then
        skill.target = t
      else
        skill.target = nil
      end
    end
  elseif target_type == "self" then
    skill.target = skill.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = skill.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    local enchantedbyself = caster.buff_effects.enchantedbyself
    local enemyCounter = 0
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit:isAlive() and not unit.config.is_summoned then
        enemyCounter = enemyCounter + 1
      end
    end
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if unit.info.Name == "TitanDH" and 1 < enemyCounter then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif enchantedbyself and unit == caster then
      elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    skill.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return skill.target
end

function TitanDH.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  if caster.TitanDH_hasArcana and caster.TitanDH_hasArcana > 3 and caster == self and (buff.info.ID == 4249 or buff.info.ID == 4250) then
    caster:takeHeal(TitanDH.Arcana4_mp, "mp", caster)
  end
end

function TitanDH.init_hero(hero)
  local skillenter = hero.skills.TitanDH_enter
  local skillult = hero.skills.TitanDH_ult
  local skillultb = hero.skills.TitanDH_ultb
  local skillatk3b = hero.skills.TitanDH_atk3b
  local skillatk4 = hero.skills.TitanDH_atk4
  local skillatk2 = hero.skills.TitanDH_atk2
  local skillatk2b = hero.skills.TitanDH_atk2b
  hero.TitanDH_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.TitanDH_startTime = 0
  hero.reset = override(hero.reset, TitanDH.hero_reset)
  hero.onDying = override(hero.onDying, TitanDH.hero_onDying)
  hero.collectBuff = override(hero.collectBuff, TitanDH.collectBuff)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanDH.hero_getLostHPAfterImmunity)
  if skillenter then
    skillenter.start = override(skillenter.start, TitanDH.skillenter_start)
    skillenter.finish = override(skillenter.finish, TitanDH.skillenter_finish)
  end
  if skillult then
    skillult.selectTarget = override(skillult.selectTarget, TitanDH.skillult_selectTarget)
    skillult.start = override(skillult.start, TitanDH.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanDH.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, TitanDH.skillult_finish)
    skillultb.start = override(skillultb.start, TitanDH.skillultb_start)
    skillultb.finish = override(skillultb.finish, TitanDH.skillultb_finish)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TitanDH.skillatk2_createBuff)
    skillatk2b.createBuff = override(skillatk2b.createBuff, TitanDH.skillatk2_createBuff)
  end
  if skillatk3b then
    skillatk3b.start = override(skillatk3b.start, TitanDH.skillatk3b_start)
    skillatk3b.interrupt = override(skillatk3b.interrupt, TitanDH.skillatk3b_interrupt)
    skillatk3b.finish = override(skillatk3b.finish, TitanDH.skillatk3b_finish)
  end
  if skillatk4 then
    hero.update = override(hero.update, TitanDH.hero_update)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanDH.skillatk4_createBuff)
  end
  return hero
end

return TitanDH.init_hero
