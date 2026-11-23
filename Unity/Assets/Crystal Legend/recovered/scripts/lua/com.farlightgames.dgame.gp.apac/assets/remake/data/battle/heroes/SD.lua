module("ed.battlehero", package.seeall)
local ed = ed
SD = {}
SD.emptyBuffID = 233
SD.ult_interval = 0.75
SD.ult_uncontrollableBuffId = 1204
SD.ult_extraDamageCoef = 0.15
SD.ult_aimBuffId = 1208
SD.ult_triggerPointEffect = "eff_point_Gambler_ult.cha"
SD.ult_stackBuffId = 1187
SD.ult_impactEffect = "eff_impact_Gambler_ult.cha"
SD.ult_pointEffectCorrect = "eff_point_Gambler_ult_correct.cha"
SD.ult_pointEffectFail = "eff_point_Gambler_ult_error.cha"
SD.ult_bingoBoom = "eff_point_Gambler_ult2.cha"
SD.ult_highlightEffectBuffId = 879
SD.atk3_bandage_start_pos = {
  {55, 10},
  {55, 40},
  {55, 70}
}
SD.atk3_bandage_end_pos = {
  {0, 30},
  {0, 30},
  {0, 30}
}
SD.atk4_deliver_start_pos = {0, 0}
SD.atk4_deliver_end_pos = {0, 0}
SD.atk3_buff_time = 6
SD.atk3_buff_end_time = 1
SD.unitSurvivalTime = 15
SD.ult_Scarab_position = {
  {100, -100},
  {700, -100}
}
SD.pyramid_x = 75
SD.atk2_infect_radius = 125
SD.atk2_infect_CD = 5
SD.atk2_variation_ratio = 0.5
SD.atk4_knockback_times = 5
SD.pyramid_y_up = 240
SD.pyramid_y_down = -240

function SD.maxMpUnit(hero)
  local maxMp = -1
  local chosen
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    if hero.foecamp == unit.camp and unit.controlledTarget then
    elseif unit.config.is_summoned then
    elseif maxMp < unit.mp then
      chosen = unit
      maxMp = unit.mp
    end
  end
  return chosen
end

function SD.skillatk2virus_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  if owner.SD_atk2_infectbuff then
    for i = 1, 3 do
      if owner.SD_atk2_infectbuff[i][2] == buff.info.ID then
        owner.SD_atk2_infectbuff[i][1] = nil
      end
    end
  end
  basefunc(buff)
end

function SD.virus_get(hero, caster)
  if hero.atk2_base_buff and hero.SD_atk2_infectbuff then
    local templist = {}
    for i = 1, 3 do
      if hero.SD_atk2_infectbuff[i][1] then
      else
        table.insert(templist, hero.SD_atk2_infectbuff[i])
      end
    end
    if 0 < #templist then
      local rand = math.floor(ed.rand() * #templist) + 1
      local bid = templist[rand][2]
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local skillatk2 = caster.skills.SD_atk2
      local skilllevel = skillatk2.level
      local buff = ed.BuffCreate(binfo, hero, caster)
      if bid == 1196 then
        buff:setAttribute("ARM", skillatk2.info["Script Arg3"])
      elseif bid == 1197 then
        buff:setAttribute("MR", skillatk2.info["Script Arg4"])
      elseif bid == 1198 then
        buff:setAttribute("MPRatio", skillatk2.info["Script Arg5"])
      end
      buff.onRemoved = override(buff.onRemoved, SD.skillatk2virus_buffOnRemoved)
      hero:addBuff(buff, caster)
      for i = 1, 3 do
        if hero.SD_atk2_infectbuff and hero.SD_atk2_infectbuff[i][2] == templist[rand][2] then
          hero.SD_atk2_infectbuff[i][1] = buff
        end
      end
    end
  end
end

function SD.Scarab_atk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2s = caster.skills.SDScarab_atk2s
  if skill.attack_counter == 0 then
    caster:setPosition({
      caster.ultbuff_target.position[1],
      caster.ultbuff_target.position[2]
    })
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 1 then
    basefunc(skill)
  elseif skill.attack_counter == 2 then
    skillatk2s:takeEffectAt(caster.position)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function SD.Scarab_atk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die()
  local skillult = caster.config.summoner.skills.SD_ult
  if skillult.SD_ultStackBuff then
    skillult.SD_ultStackBuff.timer = 0
  end
end

function SD.Scarab_atk2s_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target:isAlive() then
    SD.virus_get(target, skill.caster.config.summoner)
  end
end

function SD.Scarab_freeze(basefunc, hero)
end

function SD.Scarab_die(basefunc, hero, killer)
  basefunc(hero, killer)
end

function SD.Scarab_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() then
    if not hero.current_skill then
      hero.Scarab_turn_time = hero.Scarab_turn_time - dt
      hero:walkTowards(hero.ult_Scarab_position[hero.Scarab_walk_count % 2 + 1])
      if (ed.edpDistanceSQ(hero.position, hero.ult_Scarab_position[1]) <= 100 or ed.edpDistanceSQ(hero.position, hero.ult_Scarab_position[2]) <= 100) and hero.Scarab_turn_time <= 0 then
        hero.Scarab_turn_time = 1
        hero.Scarab_walk_count = hero.Scarab_walk_count + 1
      end
    end
    local ultbuff_target = hero.ultbuff_target
    local skillatk2 = hero.skills.SDScarab_atk2
    local target_manual_skill
    if ultbuff_target then
      target_manual_skill = ultbuff_target.manual_skill
    end
    if ultbuff_target then
      if ultbuff_target.current_skill == nil then
        hero.skill_mark = nil
      end
      if hero.skill_mark == nil and ultbuff_target.readyToUlt and not hero.current_skill then
        ultbuff_target:hurt()
        if target_manual_skill then
          ultbuff_target:setMP(ultbuff_target.mp - target_manual_skill.info["Cost MP"] * (1 - ultbuff_target.attribs.CDR / 100))
        end
        hero:castSkill(skillatk2, ultbuff_target)
        hero.skill_mark = true
        ultbuff_target.readyToUlt = nil
      end
    end
  end
end

function SD.setPortraitLocal(hero, panel)
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

function SD.findNextStackTarget(caster)
  local nextTarget
  local maxPriority = -1
  local nextTargetList = {}
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.config.is_summoned then
    else
      unit.SD_ultPriority = unit.SD_ultPriority and unit.SD_ultPriority + 1
      local priority = unit.SD_ultPriority or 0
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
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
    nextTarget.SD_ultPriority = 1
  end
  return nextTarget
end

function SD.hero_shouldTrigger(basefunc, unit)
  local skillult = unit.skills.SD_ult
  if skillult and skillult.casting then
    local trueTarget = SD.maxMpUnit(unit)
    if trueTarget and trueTarget == skillult.SD_ultAimTarget then
      return true
    end
    if skillult.SD_aimTotalTime >= skillult.SD_shouldTriggerTime then
      return true
    end
  end
  return false
end

function SD.skillult_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster.Scarab then
    caster.Scarab:die()
  end
  if caster.Scarab.ultbuff_target and caster.Scarab.ultbuff_target.SD_ultStackBuff then
    caster.Scarab.ultbuff_target.readyToUlt = nil
  end
end

function SD.skillult_canCastWithTarget(basefunc, skill, target)
  local can, reason = basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.SD_atk3
  if can and skill.casting then
    return false, "ulting"
  end
  return can, reason
end

function SD.skillult_canTrigger(basefunc, skill)
  local caster = skill.caster
  local canT = skill == skill.caster.current_skill and skill.attack_counter == 1 and skill.current_phase_idx == 1 and skill.SD_ultAimTarget
  return canT
end

function SD.skillult_trigger(basefunc, skill)
  skill.SD_ultTarget = skill.SD_ultAimTarget
  if skill.SD_ultAimBuff then
    local owner = skill.SD_ultAimBuff.owner
    owner:removeBuff(skill.SD_ultAimBuff)
    skill.SD_ultAimBuff = nil
  end
  skill:startPhase(2)
end

function SD.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  skill.SD_ultTarget = nil
  skill.SD_ultAimTarget = nil
  skill.SD_aimInterval = 0
  skill.SD_aimTotalTime = 0
  skill.SD_ultStackBuff = nil
  skill.SD_currentPanel = skill.caster
  skill.SD_highlightBuff = nil
  skill.SD_highlightTimes = 0
  skill.SD_highlightInterval = 0
  skill.highLightEnd = false
  skill.SD_shouldTriggerTime = 3
  if not caster.SD_uncontrollable then
    local binfo = ed.lookupDataTable("Buff", nil, SD.ult_uncontrollableBuffId)
    local buff = caster:addBuff(binfo, caster)
    caster.SD_uncontrollable = buff
  end
end

function SD.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.casting and skill == skill.caster.current_skill and caster.ai.will_cast_manual_skill and caster:canPanelTrigger() and caster:shouldTrigger() then
    skill:trigger()
  end
  if not skill.casting or skill ~= skill.caster.current_skill or skill.current_phase_idx ~= 2 or skill.attack_counter == 2 then
  end
end

local function update_skillult(hero, dt)
  local skillult = hero.skills.SD_ult
  if skillult and hero.current_skill == skillult and hero.current_skill.attack_counter == 1 and not skillult.SD_ultTarget then
    skillult.SD_aimInterval = skillult.SD_aimInterval + dt
    skillult.SD_aimTotalTime = skillult.SD_aimTotalTime + dt
    if skillult.SD_aimInterval >= SD.ult_interval then
      skillult.SD_aimInterval = skillult.SD_aimInterval - SD.ult_interval
      local nextAimTarget = SD.findNextStackTarget(hero)
      local nextPanel = nextAimTarget or hero
      if nextPanel ~= skillult.SD_currentPanel then
        if ed.run_with_scene then
          local panel = hero.heroPanel
          if nextAimTarget and panel then
            SD.setPortraitLocal(nextAimTarget, panel)
          end
        end
        skillult.SD_currentPanel = nextPanel
        if skillult.SD_ultAimBuff then
          local owner = skillult.SD_ultAimBuff.owner
          owner:removeBuff(skillult.SD_ultAimBuff)
          skillult.SD_ultAimBuff = nil
        end
        if nextAimTarget then
          local binfo = ed.lookupDataTable("Buff", nil, SD.ult_aimBuffId)
          local aimBuff = nextAimTarget:addBuff(binfo, hero)
          skillult.SD_ultAimBuff = aimBuff
        end
      end
      if nextAimTarget then
        skillult.SD_ultAimTarget = nextAimTarget
      else
        skillult.SD_ultAimTarget = nil
        skillult:finish()
      end
    end
  end
end

function SD.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local stakeTarget = skill.SD_ultTarget
  if skill.attack_counter == 1 then
    local skillult = caster.skills.SD_ult
    local dir = caster:getInitDir()
    local skillevel = {
      skillult.level,
      skillult.level,
      skillult.level
    }
    local proto = {
      _tid = 247,
      _level = skillult.level or 1,
      _skill_levels = skillevel,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1
    }
    local Scarab = ed.UnitCreate(proto, caster.camp, config)
    Scarab.Scarab_walk_count = 1
    Scarab.Scarab_turn_time = 0
    Scarab.Scarab_stop_time = 0.5
    Scarab.ult_Scarab_position = SD.ult_Scarab_position
    Scarab.die = override(Scarab.die, SD.Scarab_die)
    Scarab.update = override(Scarab.update, SD.Scarab_update)
    Scarab.freeze = override(Scarab.freeze, SD.Scarab_freeze)
    local Scarab_skillatk2 = Scarab.skills.SDScarab_atk2
    local Scarab_skillatk2s = Scarab.skills.SDScarab_atk2s
    Scarab_skillatk2.onAttackFrame = override(Scarab_skillatk2.onAttackFrame, SD.Scarab_atk2_onAttackFrame)
    Scarab_skillatk2.finish = override(Scarab_skillatk2.finish, SD.Scarab_atk2_finish)
    Scarab_skillatk2s.takeEffectOn = override(Scarab_skillatk2s.takeEffectOn, SD.Scarab_atk2s_takeEffectOn)
    Scarab.direction = caster.direction
    local Scarab_position = {120, -100}
    ed.engine:summonUnit(Scarab, Scarab_position, caster)
    caster.Scarab = Scarab
    local bid = 1190
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = Scarab:addBuff(binfo, Scarab)
  end
  if skill.attack_counter == 2 and stakeTarget then
    local binfo = ed.lookupDataTable("Buff", nil, SD.ult_stackBuffId)
    local buff = ed.BuffCreate(binfo, stakeTarget, caster)
    skill.SD_ultStackBuff = buff
    buff.onRemoved = override(buff.onRemoved, SD.skillult_buffonRemoved)
    stakeTarget:addBuff(buff, skill.caster)
    stakeTarget.SD_ultStackBuff = buff
    if caster.Scarab then
      caster.Scarab.ultbuff_target = stakeTarget
    end
    local caster = skill.caster
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if caster and panel then
        SD.setPortraitLocal(caster, panel)
      end
    end
  end
end

function SD.skillult_onPhaseFinished(basefunc, skill)
  local currentPhase = skill.current_phase_idx
  if not skill.SD_ultTarget and currentPhase ~= 1 then
    skill:finish()
  elseif currentPhase == 1 then
    if not skill.SD_ultTarget then
      if skill.SD_ultAimTarget then
        skill.SD_ultTarget = skill.SD_ultAimTarget
      else
        skill:finish()
      end
    end
    skill:startPhase(2)
  else
    skill:finish()
  end
end

function SD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if caster and panel then
      SD.setPortraitLocal(caster, panel)
    end
  end
  if caster.SD_uncontrollable then
    caster:removeBuff(caster.SD_uncontrollable)
    caster.SD_uncontrollable = nil
  end
  if skill.SD_ultAimBuff then
    local owner = skill.SD_ultAimBuff.owner
    owner:removeBuff(skill.SD_ultAimBuff)
    skill.SD_ultAimBuff = nil
  end
end

function SD.hero_canPanelTrigger(basefunc, unit)
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

function SD.virus_deliver(hero1, hero2, caster)
  if hero1.SD_atk2_infectbuff and hero2.SD_atk2_infectbuff and hero2.atk2_base_buff.atk2_infect_CD <= 0 then
    for i = 1, 3 do
      if hero1.SD_atk2_infectbuff[i][1] and not hero2.SD_atk2_infectbuff[i][1] then
        for n, tbuff in ipairs(hero1.buff_list) do
          if tbuff.info.ID == hero1.SD_atk2_infectbuff[i][2] then
            tbuff.timer = 0
          end
        end
        hero1.SD_atk2_infectbuff[i][1] = nil
        local skillatk2 = caster.skills.SD_atk2
        local skilllevel = skillatk2.level
        local bid = hero2.SD_atk2_infectbuff[i][2]
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, hero2, caster)
        if bid == 1196 then
          buff:setAttribute("ARM", skillatk2.info["Script Arg3"])
        elseif bid == 1197 then
          buff:setAttribute("MR", skillatk2.info["Script Arg4"])
        elseif bid == 1198 then
          buff:setAttribute("MPRatio", skillatk2.info["Script Arg5"])
        end
        buff.onRemoved = override(buff.onRemoved, SD.skillatk2virus_buffOnRemoved)
        hero2:addBuff(buff, caster)
        if hero2.SD_atk2_infectbuff then
          hero2.SD_atk2_infectbuff[i][1] = buff
        end
        if hero2.atk2_base_buff then
          hero2.atk2_base_buff.atk2_infect_CD = SD.atk2_infect_CD
        end
        if ed.run_with_scene then
          local effect_name = "eff_point_SD_atk2_2.cha"
          local Xdistance = hero1.position[1] - hero1.position[1]
          if Xdistance < 0 then
            Xdistance = -Xdistance
          end
          local Xscale = Xdistance / 550
          local endPos = {
            hero2.position[1] + SD.atk4_deliver_end_pos[1],
            hero2.position[2] + SD.atk4_deliver_end_pos[2]
          }
          local startPos = {
            hero1.position[1] + SD.atk4_deliver_start_pos[1],
            hero1.position[2] + SD.atk4_deliver_start_pos[2]
          }
          local deg = -math.deg(math.atan2(endPos[2] - startPos[2], endPos[1] - startPos[1]))
          local effect = ed.scene:playEffectOnScene(effect_name, startPos, {1, 1}, nil, 1, nil, nil, deg)
        end
        break
      end
    end
  end
end

function SD.skillatk2b_projectile_update(basefunc, projectile, dt)
  local watchTarget = projectile.SD_watchTarget
  local caster = projectile.caster
  local skillawake = caster.skills.SD_awake
  if skillawake and watchTarget.level <= skillawake.info["Script Arg1"] and watchTarget.SD_atk2_infectbuff and watchTarget.atk2_base_buff and not watchTarget.config.is_boss and not ed.engine.guildInstance_mode and watchTarget.SD_atk2_infectbuff[1][1] and watchTarget.SD_atk2_infectbuff[2][1] and watchTarget.SD_atk2_infectbuff[3][1] then
    if watchTarget.die_time > 1000 then
      if ed.run_with_scene then
        local effect_name = "eff_point_SD_awake"
        ed.scene:playEffectOnScene(effect_name, watchTarget.position, {1, 1}, nil, 1)
      end
      watchTarget.die_time = 2
    end
    watchTarget.die_time = watchTarget.die_time - dt
    if not watchTarget.SD_alreadyawakekill and watchTarget and watchTarget.die_time < 0 then
      watchTarget.SD_alreadyawakekill = true
      if watchTarget:isAlive() and caster then
        watchTarget:onDying(caster)
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
    if watchTarget.state == ed.emUnitState_Dying then
      watchTarget.state = ed.emUnitState_Dead
      watchTarget:setAction(nil)
      watchTarget.hasCorpse = false
      if watchTarget.actor and watchTarget.actor.node then
        watchTarget.actor.node:setVisible(false)
      end
    elseif watchTarget.state == ed.emUnitState_Dead then
    end
  end
end

function SD.skillatk2b_createProjectile(basefunc, skill)
  local virusKillProjectile = basefunc(skill)
  virusKillProjectile.update = override(virusKillProjectile.update, SD.skillatk2b_projectile_update)
  virusKillProjectile.height = 999
  return virusKillProjectile
end

function SD.skillatk2_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.atk2_infect_CD = buff.atk2_infect_CD - dt
end

function SD.skillatk2_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.atk2_base_buff = nil
  owner.SD_atk2_infectbuff = nil
end

function SD.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.onRemoved = override(buff.onRemoved, SD.skillatk2_buffOnRemoved)
  buff.update = override(buff.update, SD.skillatk2_buffUpdate)
  if not buff.atk2_infect_CD then
    buff.atk2_infect_CD = SD.atk2_infect_CD
  end
  if not buff.die_time then
    target.die_time = 99999
  end
  if not target.atk2_base_buff then
    target.atk2_base_buff = buff
  end
  if not target.SD_atk2_infectbuff then
    target.SD_atk2_infectbuff = {
      {nil, 1196},
      {nil, 1197},
      {nil, 1198}
    }
    local atk2b = caster.skills.SD_atk2b
    if atk2b then
      local virusKillProjectile = atk2b:createProjectile()
      virusKillProjectile.SD_watchTarget = target
      virusKillProjectile.SD_alreadyvirusKill = false
      ed.engine:addProjectile(virusKillProjectile)
    end
  end
  return buff
end

function SD.skillatk2_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
  end
end

function SD.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local haveBaseBuff
  local originfo = skill.info
  if target.config.is_summoned then
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0
    })
  end
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 1195 then
      haveBaseBuff = true
    end
  end
  if haveBaseBuff and ed.rand() < SD.atk2_variation_ratio then
    SD.virus_get(target, skill.caster)
  end
  local result = basefunc(skill, target, source, shift)
  skill.info = originfo
  local haveheromark
  if target and target.atk2_base_buff then
    if 0 < #caster.SD_viruslist then
      for i = 1, #caster.SD_viruslist do
        if target == caster.SD_viruslist[i] then
          haveheromark = true
        end
      end
      if not haveheromark then
        table.insert(caster.SD_viruslist, target)
      end
    else
      table.insert(caster.SD_viruslist, target)
    end
  else
    return result
  end
end

function SD.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    if skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    if skill.target then
      local target = skill.target
      if ed.run_with_scene then
        for i = 1, 3 do
          local effect_name = "eff_chain_SD_atk3.cha"
          local Xdistance = target.position[1] - caster.position[1]
          if Xdistance < 0 then
            Xdistance = -Xdistance
          end
          local Xscale = Xdistance / 900
          local endPos = {
            target.position[1] + SD.atk3_bandage_end_pos[i][1],
            target.position[2] + SD.atk3_bandage_end_pos[i][2]
          }
          local startPos = {
            caster.position[1] + SD.atk3_bandage_start_pos[i][1],
            caster.position[2] + SD.atk3_bandage_start_pos[i][2]
          }
          local deg = -math.deg(math.atan2(endPos[2] - startPos[2], endPos[1] - startPos[1]))
          local effect = ed.scene:playEffectOnScene(effect_name, startPos, {Xscale, 1}, nil, -1, nil, nil, deg)
          table.insert(caster.SD_atk3_effectlist, effect)
        end
        local effect_name = "eff_point_SD_atk3.cha"
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, {
          target.position[1],
          target.position[2] + 1
        }, {
          caster.direction,
          1
        }, nil, effect_z)
      end
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if skill.attack_counter == 1 then
    basefunc(skill)
  end
end

function SD.skillatk3_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.atk3_buff_time = buff.atk3_buff_time - dt
end

function SD.createCopyUnit(skill, unit)
  local copyUnitLevel
  local skillLevel = {}
  local ID
  if skill.level > unit.level then
    copyUnitLevel = unit.level
  else
    copyUnitLevel = skill.level
  end
  for i = 1, 17 do
    skillLevel[i] = copyUnitLevel
  end
  if unit.info.ID == 53 then
    ID = 191
  elseif unit.info.ID == 85 then
    ID = 192
  else
    ID = unit.info.ID
  end
  local proto = {
    _tid = ID,
    _level = copyUnitLevel,
    _stars = unit.stars,
    _skill_levels = skillLevel,
    _rank = unit.rank,
    _fashion = {
      _current_fashion = skill.caster.fashion_id
    }
  }
  local config = {
    is_summoned_by_DS = true,
    is_summoned = true,
    hp_mod = 0.7,
    dps_mod = skill.caster.config.dps_mod or 1,
    summoner = skill.caster
  }
  if ed.engine:isTowerWarsMode() then
    config.hp_mod = 2
  end
  return ed.UnitCreate(proto, skill.caster.camp, config)
end

function SD.copyUnit_update(basefunc, copyUnit, dt)
  basefunc(copyUnit, dt)
  copyUnit.mDuration = copyUnit.mDuration - dt
  local summoner = copyUnit.config.summoner
  if copyUnit:isAlive() and (copyUnit.mDuration <= 0 or not summoner:isAlive()) then
    copyUnit:die()
  end
end

function SD.copyUnit_die(basefunc, copyUnit, killer)
  basefunc(copyUnit, killer)
  local unit = copyUnit.copytarget
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 1561 then
      tbuff.timer = 0
    end
  end
end

function SD.skillatk3_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  if not ed.engine.beingEnd then
    local caster = buff.caster
    local owner = buff.owner
    local skill = buff.atk3_skill
    local direction = caster.direction
    local info = skill.info
    owner:setPosition({
      owner.position[1] - 35 * owner.direction,
      owner.position[2]
    })
    local ID
    if not owner.config.is_summoned and not owner.config.is_boss then
      local arousal = owner.proto._arousal
      local copyUnit = SD.createCopyUnit(skill, owner)
      local puppet = copyUnit.info["Puppet Switch"]
      if puppet and arousal and arousal._status == 1 then
        copyUnit.puppet_stack = {puppet}
      end
      copyUnit:setDeathWithEffectOrNot(true)
      copyUnit.mDuration = SD.unitSurvivalTime
      copyUnit.update = override(copyUnit.update, SD.copyUnit_update)
      copyUnit.die = override(copyUnit.die, SD.copyUnit_die)
      copyUnit.copytarget = owner
      local direction2 = -1 * owner.direction
      local locationss1 = {
        owner.position[1] - 35 * direction2,
        owner.position[2]
      }
      copyUnit.direction = direction2
      caster.atk3summonlist_SD = copyUnit
      ed.engine:summonUnit(copyUnit, locationss1, skill.caster, "Idle")
      copyUnit:reset()
      copyUnit.position = {
        owner.position[1] - 75 * direction2,
        owner.position[2]
      }
      local bid2 = 89
      local bid = 357
      local bid3 = 1203
      local bid4 = 1207
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
      local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
      local skillsawake = caster.skills.SD_sawake
      if skillsawake then
        local max = skill.caster.skills.SD_sawake.info["Script Arg2"]
        local bidsawake = 1561
        local binfosawake = ed.lookupDataTable("Buff", nil, bidsawake)
        local buffsawake = ed.BuffCreate(binfosawake, owner, caster)
        local sawakeHPR = math.min(max, owner.attribs.HP * 0.01)
        buffsawake:setAttribute("HPR", sawakeHPR * -1)
        local result = owner:addBuff(buffsawake, caster)
      end
      copyUnit:addBuff(binfo2, skill.caster)
      copyUnit:addBuff(binfo, skill.caster)
      copyUnit:addBuff(binfo3, owner)
      owner:addBuff(binfo4, copyUnit)
      copyUnit.FatherUnit_SD = caster
    end
  end
end

function SD.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.atk3_buff_time = SD.atk3_buff_time
  buff.atk3_skill = skill
  buff.onRemoved = override(buff.onRemoved, SD.skillatk3_buffOnRemoved)
  buff.update = override(buff.update, SD.skillatk3_buffUpdate)
  return buff
end

function SD.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  if result and skill.caster.atk3summonlist_SD and skill.caster.atk3summonlist_SD:isAlive() then
    result = nil
  end
  return result
end

function SD.atk4_select_position(skill)
  local caster = skill.caster
  local dir = caster:getInitDir()
  local templist = {}
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.config.is_summoned and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      table.insert(templist, {
        unit,
        unit.position[1]
      })
    end
  end
  local finalposition1 = 400
  if 0 < #templist then
    table.sort(templist, function(a, b)
      return a[2] > b[2]
    end)
    local target
    if #templist % 2 == 0 then
      target = templist[#templist / 2 + (dir == 1 and 0 or 1)][1]
    else
      target = templist[#templist / 2 + 0.5][1]
    end
    local enemycount_left = 0
    local enemycount_right = 0
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.position[1] < target.position[1] then
        enemycount_left = enemycount_left + 1
      else
        enemycount_right = enemycount_right + 1
      end
    end
    if enemycount_left >= enemycount_right then
      finalposition1 = target.position[1] - SD.pyramid_x / 2
    else
      finalposition1 = target.position[1] + SD.pyramid_x / 2
    end
  end
  return finalposition1
end

function SD.pyramid_check(skill, unit)
  local pyramid_x_left = skill.atk4_pyramid_position[1] - SD.pyramid_x
  local pyramid_x_right = skill.atk4_pyramid_position[1] + SD.pyramid_x
  local edpSub
  if pyramid_x_left < unit.position[1] and unit.position[1] < skill.atk4_pyramid_position[1] and unit.position[2] > SD.pyramid_y_down and unit.position[2] < SD.pyramid_y_up and unit.no_knockup_time <= 0 then
    for i, oldunit in ipairs(skill.atk4_outpyramid_old) do
      if unit == oldunit then
        edpSub = ed.edpSub(unit.position, oldunit.atk4_oldposition)
        oldunit = nil
        if edpSub[1] == 0 and edpSub[2] == 0 then
          edpSub[1] = -10
          edpSub[2] = 0
        end
        return edpSub
      end
    end
    edpSub = ed.edpSub(unit.position, {
      pyramid_x_left,
      unit.position[2]
    })
    if edpSub[1] == 0 and edpSub[2] == 0 then
      edpSub[1] = -10
      edpSub[2] = 0
    end
    return edpSub
  elseif pyramid_x_right > unit.position[1] and unit.position[1] > skill.atk4_pyramid_position[1] and unit.position[2] > SD.pyramid_y_down and unit.position[2] < SD.pyramid_y_up and unit.no_knockup_time <= 0 then
    for i, oldunit in ipairs(skill.atk4_outpyramid_old) do
      if unit == oldunit then
        edpSub = ed.edpSub(unit.position, oldunit.atk4_oldposition)
        oldunit = nil
        if edpSub[1] == 0 and edpSub[2] == 0 then
          edpSub[1] = 10
          edpSub[2] = 0
        end
        return edpSub
      end
    end
    edpSub = ed.edpSub(unit.position, {
      pyramid_x_right,
      unit.position[2]
    })
    if edpSub[1] == 0 and edpSub[2] == 0 then
      edpSub[1] = 10
      edpSub[2] = 0
    end
    return edpSub
  elseif pyramid_x_right < unit.position[1] or pyramid_x_left > unit.position[1] then
    table.insert(skill.atk4_outpyramid_old, unit)
    unit.atk4_oldposition = {}
    unit.atk4_oldposition[1] = unit.position[1]
    unit.atk4_oldposition[2] = unit.position[2]
    return nil
  end
end

function SD.skillatk4_projectileUpdate(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local skill = projectile.skill
  local caster = skill.caster
  local skillatk4s = caster.skills.SD_atk4s
  local edpSub
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.no_knockup_time then
      unit.no_knockup_time = 0
    end
    if unit.buff_effects.invulnerable then
      break
    end
    edpSub = SD.pyramid_check(skill, unit)
    if edpSub then
      skillatk4s:takeEffectOn(unit, caster)
      if ed.run_with_scene then
        local effect_name = "eff_point_SD_atk4_3.cha"
        local effect_z = 1
        caster.atk4_effect_3 = ed.scene:playEffectOnScene(effect_name, skill.atk4_pyramid_position, {1, 1}, nil, effect_z)
        local effect_name4 = "eff_point_SD_atk4_4.cha"
        local effect_z4 = -1
        caster.atk4_effect_4 = ed.scene:playEffectOnScene(effect_name4, skill.atk4_pyramid_position, {1, 1}, nil, effect_z4)
      end
      local distance = ed.edpLengthSQ(edpSub) ^ 0.5 * 1.5
      if distance == 0 then
        distance = 25
      elseif 100 <= distance then
        distance = 100
      end
      local time = distance * 0.002
      local edpNormalize = ed.edpNormalize({
        -edpSub[1],
        -edpSub[2]
      })
      unit:knockup(time, {
        edpNormalize[1] * distance,
        edpNormalize[2] * distance
      }, true)
      unit.no_knockup_time = 1
      projectile.knockback_times = projectile.knockback_times - 1
    end
    unit.no_knockup_time = unit.no_knockup_time - dt
  end
end

function SD.skillatk4_projectileTerminate(basefunc, projectile)
  if projectile.knockback_times <= 0 then
    local caster = projectile.caster
    if caster.atk4_effect and ed.run_with_scene and caster.atk4_effect then
      local z = -1
      ed.scene:removeEffect(caster.atk4_effect, z)
    end
    if caster.atk4_effect_2 and ed.run_with_scene and caster.atk4_effect_2 then
      local z = -1
      ed.scene:removeEffect(caster.atk4_effect_2, z)
    end
    basefunc(projectile)
  end
end

function SD.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.atk4_outpyramid_old = {}
  skill.atk4_inpyramid_now = {}
  projectile.position = {400, 1000}
  projectile.knockback_times = SD.atk4_knockback_times
  skill.atk4_pyramid_position = {
    SD.atk4_select_position(skill),
    0
  }
  projectile.update = override(projectile.update, SD.skillatk4_projectileUpdate)
  projectile.terminate = override(projectile.terminate, SD.skillatk4_projectileTerminate)
  return projectile
end

function SD.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    if caster.atk4_projectile then
      caster.atk4_projectile.knockback_times = -1
      caster.atk4_projectile:terminate()
    end
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
    caster.atk4_projectile = projectile
    if ed.run_with_scene then
      local effect_name = "eff_point_SD_atk4_1.cha"
      local effect_z = -1
      caster.atk4_effect = ed.scene:playEffectOnScene(effect_name, skill.atk4_pyramid_position, {1, 1}, nil, effect_z)
      local effect_name2 = "eff_point_SD_atk4_2.cha"
      local effect_z2 = -1
      caster.atk4_effect_2 = ed.scene:playEffectOnScene(effect_name2, skill.atk4_pyramid_position, {1, 1}, nil, effect_z2)
    end
  end
end

function SD.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk3summonlist_SD = nil
  hero.SD_atk3_effectlist = {}
  hero.SD_viruslist = {}
end

function SD.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  update_skillult(hero, dt)
  local caster = hero
  local number = #hero.SD_viruslist
  for i = 1, number do
    if hero.SD_viruslist[i]:isAlive() then
      for k = i + 1, number do
        if hero.SD_viruslist[k]:isAlive() and ed.edpDistanceSQ(hero.SD_viruslist[i].position, hero.SD_viruslist[k].position) <= SD.atk2_infect_radius * SD.atk2_infect_radius then
          local unit1 = hero.SD_viruslist[i]
          local unit2 = hero.SD_viruslist[k]
          if unit1.attribs.MR > unit2.attribs.MR then
            SD.virus_deliver(unit1, unit2, caster)
          else
            SD.virus_deliver(unit2, unit1, caster)
          end
        end
      end
    end
  end
end

function SD.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.Scarab and hero.Scarab:isAlive() then
    hero.Scarab:die()
  end
  if hero.atk3summonlist_SD and hero.atk3summonlist_SD:isAlive() then
    hero.atk3summonlist_SD:die()
  end
  if hero.atk4_projectile then
    hero.atk4_projectile:terminate()
  end
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 1187 and tbuff.caster == hero then
        tbuff.timer = 0
      end
    end
    if unit.config and unit.config.summoner == hero and unit:isAlive() then
      unit:die()
    end
  end
end

function SD.init_hero(hero)
  local skillult = hero.skills.SD_ult
  local skillatk2 = hero.skills.SD_atk2
  local skillatk2b = hero.skills.SD_atk2b
  local skillatk3 = hero.skills.SD_atk3
  local skillatk4 = hero.skills.SD_atk4
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, SD.skillult_canCastWithTarget)
    skillult.canTrigger = override(skillult.canTrigger, SD.skillult_canTrigger)
    skillult.trigger = override(skillult.trigger, SD.skillult_trigger)
    skillult.start = override(skillult.start, SD.skillult_start)
    skillult.update = override(skillult.update, SD.skillult_update)
    skillult.onAttackFrame = override(skillult.onAttackFrame, SD.skillult_onAttackFrame)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, SD.skillult_onPhaseFinished)
    skillult.finish = override(skillult.finish, SD.skillult_finish)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, SD.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, SD.skillatk2_createBuff)
    skillatk2b.createProjectile = override(skillatk2b.createProjectile, SD.skillatk2b_createProjectile)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, SD.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, SD.skillatk3_createBuff)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, SD.skillatk3_canCastWithTarget)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, SD.skillatk4_onAttackFrame)
    skillatk4.createProjectile = override(skillatk4.createProjectile, SD.skillatk4_createProjectile)
  end
  hero.shouldTrigger = override(hero.shouldTrigger, SD.hero_shouldTrigger)
  hero.reset = override(hero.reset, SD.hero_reset)
  hero.update = override(hero.update, SD.hero_update)
  hero.die = override(hero.die, SD.hero_die)
  return hero
end

return SD.init_hero
