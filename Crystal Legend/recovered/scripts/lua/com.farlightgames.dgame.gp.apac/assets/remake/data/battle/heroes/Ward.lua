module("ed.battlehero", package.seeall)
local ed = ed
Ward = {}
Ward.skillatk2_startBuff = 1269
Ward.hero_startBuff = 1266
Ward.skillult_startBuff = 1265
Ward.skillult_buff_fire1 = 1248
Ward.skillult_buff_fire1s = 1249
Ward.skillult_buff_fire2 = 1250
Ward.skillult_buff_fire2s = 1251
Ward.skillult_buff_fire3 = 1252
Ward.skillult_buff_fire3s = 1253
Ward.skillult_buff_fire4 = 1254
Ward.skillult_buff_fire4s = 1255
Ward.skillult_buff_fire5 = 1256
Ward.skillult_buff_fire5s = 1257
Ward.skillult_deltaTime = 1
Ward.skillult_monitorLimit = 8

function Ward.specialProjectile_freeze(basefunc, projectile)
  basefunc(projectile)
  projectile.frozen_model = false
end

function Ward.specialProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  local caster = projectile.caster
  projectile.refreshTime = projectile.refreshTime + dt
  if projectile.refreshTime >= 25 then
    projectile.refreshTime = 0
    local skill = projectile.skill
    local oldList = caster.Ward_enemyList
    local newList = {}
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if unit.config.is_summoned then
      else
        table.insert(newList, {unit, 0})
      end
      if #newList >= Ward.skillult_monitorLimit then
        break
      end
    end
    for i, v in ipairs(newList) do
      for j, u in ipairs(oldList) do
        if v[1] == u[1] then
          v[2] = u[2]
          break
        end
      end
    end
    caster.Ward_enemyList = newList
  end
  for _, v in ipairs(caster.Ward_enemyList) do
    local isOut = false
    if v[1].buff_effects.invulnerable then
      isOut = true
    elseif v[1].buff_effects.untargetable then
      isOut = true
    elseif v[1].buff_effects.stealth then
      isOut = true
    else
      if v[1]:isOutOfStage() then
        isOut = true
      else
      end
    end
    if isOut then
      v[2] = v[2] + 1
    end
  end
  if not caster:isAlive() then
    projectile:terminate()
  end
end

function Ward.skillult_chooseTarget(skill, oldTarget)
  local caster = skill.caster
  local old_target = oldTarget
  local max = -1
  local highUnit
  for i, v in ipairs(caster.Ward_enemyList) do
    if not v[1]:isAlive() then
    elseif v[1]:isOutOfStage() then
    elseif v[1].buff_effects.imprisonment then
    elseif v[1] == old_target then
    elseif max < v[2] then
      max = v[2]
      highUnit = v[1]
    end
  end
  if highUnit then
    skill.target = highUnit
  end
  return highUnit
end

function Ward.skillult_monitor(skill, skillultb)
  local caster = skill.caster
  local specialProjectile = skillultb:createProjectile()
  specialProjectile.height = 999
  specialProjectile.refreshTime = 0
  specialProjectile.freeze = override(specialProjectile.freeze, Ward.specialProjectile_freeze)
  specialProjectile.update = override(specialProjectile.update, Ward.specialProjectile_update)
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned then
    else
      table.insert(caster.Ward_enemyList, {unit, 0})
    end
    if #caster.Ward_enemyList >= Ward.skillult_monitorLimit then
      break
    end
  end
  ed.engine:addProjectile(specialProjectile)
  caster.Ward_hasCounter = true
end

function Ward.skillult_canHurt(skill, target)
  local canHurt = true
  if target.buff_effects.invulnerable then
    canHurt = false
  elseif target.buff_effects.untargetable then
    canHurt = false
  elseif target.buff_effects.stealth then
    canHurt = false
  else
    if target:isOutOfStage() then
      canHurt = false
    else
    end
  end
  return canHurt
end

function Ward.exBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.lifetime = buff.lifetime + dt
end

function Ward.bullet_addEffect(target, caster, isEx)
  local effect_name = "eff_impact_Ward_ult.cha"
  if isEx then
    effect_name = "eff_impact_Ward_ults.cha"
  end
  local dir = caster.direction
  dir = caster.position[1] - target.position[1] >= 0 and -1 or 1
  local scene_effect = ed.scene:playEffectOnScene(effect_name, {
    target.position[1],
    target.position[2] - 4
  }, {dir, 1}, nil, 0)
end

function Ward.bullet_outEffect(caster, buff, bullet_effect_list)
  local effect = bullet_effect_list[buff.info.ID]
  ed.scene:playEffectOnScene(effect, {
    caster.position[1],
    caster.position[2] - 1
  }, {
    caster.direction,
    1
  }, nil, 0)
end

function Ward.skillult_bulletLogic(caster, skill, bullet_effect_list, bullet_list)
  caster.Ward_bulletTime = caster.Ward_bulletTime - Ward.skillult_deltaTime
  if not caster.Ward_ultTarget or caster.Ward_ultTarget and not caster.Ward_ultTarget:isAlive() then
    caster.Ward_ultTarget = Ward.skillult_chooseTarget(skill)
  end
  local canHurt = false
  if caster.Ward_ultTarget then
    canHurt = Ward.skillult_canHurt(skill, caster.Ward_ultTarget)
  end
  if canHurt then
    skill:takeEffectOn(caster.Ward_ultTarget, caster)
    if ed.run_with_scene then
      Ward.bullet_outEffect(caster, caster.Ward_bulletlist[1], bullet_effect_list)
      Ward.bullet_addEffect(caster.Ward_ultTarget, caster, false)
    end
  else
    local buffid = bullet_list[caster.Ward_bulletlist[1].info.ID]
    local binfo = ed.lookupDataTable("Buff", nil, buffid)
    local exBuff = ed.BuffCreate(binfo, caster, caster)
    exBuff.lifetime = 0.125
    exBuff.update = override(exBuff.update, Ward.exBuff_update)
    caster:addBuff(exBuff, caster)
    table.insert(caster.Ward_exbulletlist, exBuff)
  end
  caster.Ward_bulletlist[1].timer = 0
  table.remove(caster.Ward_bulletlist, 1)
  if #caster.Ward_bulletlist == 0 then
    caster.Ward_bulletlist = nil
  end
end

function Ward.skillult_exbulletLogic(caster, skill, bullet_effect_list)
  if not caster.Ward_ultTarget or caster.Ward_ultTarget and not caster.Ward_ultTarget:isAlive() then
    caster.Ward_ultTarget = Ward.skillult_chooseTarget(skill)
  end
  if caster.Ward_bulletTime > 4 then
    if caster.Ward_ultTarget then
      caster.Ward_ultTarget = Ward.skillult_chooseTarget(skill, caster.Ward_ultTarget)
    else
      caster.Ward_ultTarget = Ward.skillult_chooseTarget(skill)
    end
  end
  local canHurt = false
  if caster.Ward_ultTarget then
    canHurt = Ward.skillult_canHurt(skill, caster.Ward_ultTarget)
  end
  if canHurt then
    local skillultc = caster.skills.Ward_ultc
    if skillultc then
      local exbuff_lifetime = caster.Ward_exbulletlist[1].lifetime
      local most_time = 4 * Ward.skillult_deltaTime + 4
      exbuff_lifetime = exbuff_lifetime >= most_time and most_time or exbuff_lifetime
      local dmgAdd = 1 + 0.6 * exbuff_lifetime / (exbuff_lifetime + most_time)
      local originInfo = skillultc.info
      local originRatio = skillultc.info["Plus Ratio"]
      skillultc.info = ed.wraptable(originInfo, {
        ["Plus Ratio"] = originRatio * dmgAdd
      })
      skillultc:takeEffectOn(caster.Ward_ultTarget, caster)
      skillultc.info = originInfo
      if ed.run_with_scene then
        Ward.bullet_outEffect(caster, caster.Ward_exbulletlist[1], bullet_effect_list)
        Ward.bullet_addEffect(caster.Ward_ultTarget, caster, true)
      end
    end
    caster.Ward_bulletTime = 0
    caster.Ward_exbulletlist[1].timer = 0
    table.remove(caster.Ward_exbulletlist, 1)
  end
  if #caster.Ward_exbulletlist == 0 then
    caster.Ward_exbulletlist = nil
  end
end

function Ward.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  local skillultb = caster.skills.Ward_ultb
  if skillultb and not caster.Ward_hasCounter then
    Ward.skillult_monitor(skill, skillultb)
  end
  local bullet_list = {
    [Ward.skillult_buff_fire1] = Ward.skillult_buff_fire1s,
    [Ward.skillult_buff_fire2] = Ward.skillult_buff_fire2s,
    [Ward.skillult_buff_fire3] = Ward.skillult_buff_fire3s,
    [Ward.skillult_buff_fire4] = Ward.skillult_buff_fire4s,
    [Ward.skillult_buff_fire5] = Ward.skillult_buff_fire5s
  }
  local bullet_effect_list = {
    [Ward.skillult_buff_fire1] = "eff_buff_Ward_ult1a_lost.cha",
    [Ward.skillult_buff_fire2] = "eff_buff_Ward_ult2a_lost.cha",
    [Ward.skillult_buff_fire3] = "eff_buff_Ward_ult3a_lost.cha",
    [Ward.skillult_buff_fire4] = "eff_buff_Ward_ult4a_lost.cha",
    [Ward.skillult_buff_fire5] = "eff_buff_Ward_ult5a_lost.cha",
    [Ward.skillult_buff_fire1s] = "eff_buff_Ward_ult1b_lost.cha",
    [Ward.skillult_buff_fire2s] = "eff_buff_Ward_ult2b_lost.cha",
    [Ward.skillult_buff_fire3s] = "eff_buff_Ward_ult3b_lost.cha",
    [Ward.skillult_buff_fire4s] = "eff_buff_Ward_ult4b_lost.cha",
    [Ward.skillult_buff_fire5s] = "eff_buff_Ward_ult5b_lost.cha"
  }
  if caster.Ward_bulletTime then
    caster.Ward_bulletTime = caster.Ward_bulletTime + dt_action
  end
  if caster.Ward_bulletTime and caster.Ward_bulletTime >= Ward.skillult_deltaTime then
    if caster.Ward_bulletlist and #caster.Ward_bulletlist >= 1 then
      Ward.skillult_bulletLogic(caster, skill, bullet_effect_list, bullet_list)
    elseif caster.Ward_exbulletlist and 1 <= #caster.Ward_exbulletlist then
      Ward.skillult_exbulletLogic(caster, skill, bullet_effect_list)
    else
      caster.Ward_bulletTime = nil
    end
  end
end

function Ward.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Ward.skillult_startBuff)
  local unconBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(unconBuff, caster)
  basefunc(skill, target)
end

function Ward.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Ward.skillult_startBuff then
      tbuff.timer = 0
    end
  end
end

function Ward.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local newbufflist = {
    Ward.skillult_buff_fire1,
    Ward.skillult_buff_fire2,
    Ward.skillult_buff_fire3,
    Ward.skillult_buff_fire4,
    Ward.skillult_buff_fire5
  }
  if skill.attack_counter == 0 then
    if caster.manually_casting then
      ed.engine:unfreeze()
      caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Ward.skillult_startBuff then
        tbuff.timer = 0
      end
    end
    skill.attack_counter = skill.attack_counter + 1
    caster.Ward_ultTarget = Ward.skillult_chooseTarget(skill)
    caster.Ward_bulletlist = {}
    caster.Ward_exbulletlist = {}
    for i, v in ipairs(newbufflist) do
      local buffid = v
      local binfo = ed.lookupDataTable("Buff", nil, buffid)
      local fireBuff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(fireBuff, caster)
      table.insert(caster.Ward_bulletlist, fireBuff)
    end
    caster.Ward_bulletTime = 0
  end
end

function Ward.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.Ward_bulletTime then
    return false
  else
    return basefunc(skill, target)
  end
end

function Ward.oriBuff_upgrade(basefunc, buff, owner, caster, nextBuffInfo)
  local old_timer = buff.timer
  basefunc(buff, owner, caster, nextBuffInfo)
  buff.timer = buff.timer + old_timer
  return buff
end

function Ward.skillultc_createBuff(basefunc, skill, target)
  local oriBuff = basefunc(skill, target)
  oriBuff.upgrade = override(oriBuff.upgrade, Ward.oriBuff_upgrade)
  return oriBuff
end

function Ward.actor_gotoNextBattle(basefunc, actor)
  basefunc(actor)
  local puppet = actor.puppet
  local moveActionName = actor:getActionName("Movea")
  puppet:setAction(moveActionName)
  puppet:setLoop(false)
  actor.velocity = {0, 0}
  actor.bar_hp:forceHide(true)
end

function Ward.hero_update(basefunc, hero, dt)
  if hero:isAlive() and not hero.config.is_summoned_by_DS and hero.name ~= "Rubick" and not hero.Ward_inTheShow then
    hero.Ward_inTheShow = true
    local dir = hero:getInitDir()
    hero:setPosition({
      ed.engine.stage_rect.maxX / 2 - dir * 200 - 5 * dir * ed.rand(),
      -20 - 5 * ed.rand()
    })
    hero.direction = dir
    hero.state = ed.emUnitState_Birth
    hero:setAction("birth")
    local binfo = ed.lookupDataTable("Buff", nil, Ward.hero_startBuff)
    local unconBuff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(unconBuff, hero)
  end
  if ed.run_with_scene and hero.actor and not hero.Ward_actor_leaveScene then
    hero.Ward_actor_leaveScene = true
    hero.actor.gotoNextBattle = override(hero.actor.gotoNextBattle, Ward.actor_gotoNextBattle)
  end
  if hero.state == ed.emUnitState_Dying then
    if not hero.dyingTimer_Ward then
      hero.dyingTimer_Ward = 0.6
    end
    hero.dyingTimer_Ward = hero.dyingTimer_Ward - dt
    if hero.dyingTimer_Ward <= 0 and not hero.CHEN_ult1time then
      hero.dyingTimer_Ward = 99999
      local skillult = hero.skills.Ward_ult
      local skillultc = hero.skills.Ward_ultc
      if skillult and skillultc then
        local bullet_effect_list = {
          [Ward.skillult_buff_fire1] = "eff_buff_Ward_ult1a_lost.cha",
          [Ward.skillult_buff_fire2] = "eff_buff_Ward_ult2a_lost.cha",
          [Ward.skillult_buff_fire3] = "eff_buff_Ward_ult3a_lost.cha",
          [Ward.skillult_buff_fire4] = "eff_buff_Ward_ult4a_lost.cha",
          [Ward.skillult_buff_fire5] = "eff_buff_Ward_ult5a_lost.cha",
          [Ward.skillult_buff_fire1s] = "eff_buff_Ward_ult1b_lost.cha",
          [Ward.skillult_buff_fire2s] = "eff_buff_Ward_ult2b_lost.cha",
          [Ward.skillult_buff_fire3s] = "eff_buff_Ward_ult3b_lost.cha",
          [Ward.skillult_buff_fire4s] = "eff_buff_Ward_ult4b_lost.cha",
          [Ward.skillult_buff_fire5s] = "eff_buff_Ward_ult5b_lost.cha"
        }
        if hero.Ward_bulletlist and #hero.Ward_bulletlist >= 1 then
          repeat
            local randTarget = skillult:selectTarget(nil)
            if randTarget then
              skillult:takeEffectOn(randTarget, hero)
              if ed.run_with_scene then
                Ward.bullet_addEffect(randTarget, hero, false)
              end
            end
            if ed.run_with_scene then
              Ward.bullet_outEffect(hero, hero.Ward_bulletlist[1], bullet_effect_list)
            end
            hero:removeBuff(hero.Ward_bulletlist[1])
            table.remove(hero.Ward_bulletlist, 1)
          until #hero.Ward_bulletlist == 0
        end
        if hero.Ward_exbulletlist and 1 <= #hero.Ward_exbulletlist then
          repeat
            local exrandTarget = skillult:selectTarget(nil)
            if exrandTarget then
              local exbuff_lifetime = hero.Ward_exbulletlist[1].lifetime
              local most_time = 4 * Ward.skillult_deltaTime + 4
              exbuff_lifetime = exbuff_lifetime >= most_time and most_time or exbuff_lifetime
              local dmgAdd = 1 + 0.6 * exbuff_lifetime / (exbuff_lifetime + most_time)
              local originInfo = skillultc.info
              local originRatio = skillultc.info["Plus Ratio"]
              skillultc.info = ed.wraptable(originInfo, {
                ["Plus Ratio"] = originRatio * dmgAdd
              })
              skillultc:takeEffectOn(exrandTarget, hero)
              skillultc.info = originInfo
              if ed.run_with_scene then
                Ward.bullet_addEffect(exrandTarget, hero, true)
              end
            end
            if ed.run_with_scene then
              Ward.bullet_outEffect(hero, hero.Ward_exbulletlist[1], bullet_effect_list)
            end
            hero:removeBuff(hero.Ward_exbulletlist[1])
            table.remove(hero.Ward_exbulletlist, 1)
          until #hero.Ward_exbulletlist == 0
        end
      end
    end
  else
    hero.dyingTimer_Ward = nil
  end
  basefunc(hero, dt)
end

function Ward.skillatk2_shieldCount(unit)
  local shieldCount = 0
  for _, v in ipairs(unit.buff_list) do
    if v.shield and 0 < v.shield then
      shieldCount = shieldCount + v.shield
    end
  end
  return shieldCount
end

function Ward.skillatk2_selectTarget(basefunc, skill, default)
  if skill.attack_counter == 1 then
    local defTarget = basefunc(skill, default)
    local caster = skill.caster
    local Ignore = skill:Ignore_Target_Type()
    local max = 0
    local chosen
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if unit.config.is_summoned then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
      elseif unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = Ward.skillatk2_shieldCount(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    if chosen then
      skill.target = chosen
    end
    return skill.target
  elseif skill.attack_counter >= 2 then
    if skill.target == nil or not skill.target:isAlive() then
      return basefunc(skill, default)
    else
      return skill.target
    end
  else
    return basefunc(skill, default)
  end
end

function Ward.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local target = skill.target
  if skill.attack_counter == 1 then
    local myDir = target.position[1] > caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = "eff_point_Ward_atk2s.cha"
      if ed.protoAwake(caster.proto, 10050) then
        effect_name = "eff_point_Ward_atk2sa.cha"
      end
      local scene_effect = ed.scene:playEffectOnScene(effect_name, {
        target.position[1] - myDir * 85,
        target.position[2] - 4
      }, {
        0.9 * myDir,
        0.9
      }, nil, 0)
      skill.Ward_skillatk2Effect = scene_effect
    end
  elseif skill.attack_counter == 2 then
    basefunc(skill, location, source)
  elseif skill.attack_counter >= 3 and skill.attack_counter <= 6 then
    if target:isAlive() then
      local shieldDmg = skill.info["Basic Num"]
      for _, v in ipairs(target.buff_list) do
        if v.shield and 0 < v.shield then
          if shieldDmg < v.shield then
            v.shield = v.shield - shieldDmg
            shieldDmg = 0
          else
            shieldDmg = shieldDmg - v.shield
            v.shield = 0
          end
        end
        if shieldDmg == 0 then
          break
        end
      end
      local skillatk2s = caster.skills.Ward_atk2s
      if skillatk2s then
        skillatk2s:takeEffectOn(target, source)
      end
    end
  elseif skill.attack_counter == 7 and ed.run_with_scene and skill.Ward_skillatk2Effect then
    ed.scene:removeEffect(skill.Ward_skillatk2Effect, 0)
  end
end

function Ward.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Ward_skillatk2_originPos = {
    caster.position[1],
    caster.position[2]
  }
  local binfo = ed.lookupDataTable("Buff", nil, Ward.skillatk2_startBuff)
  local unconBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(unconBuff, caster)
end

function Ward.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Ward.skillatk2_startBuff then
      tbuff.timer = 0
    end
  end
  if ed.run_with_scene and skill.Ward_skillatk2Effect then
    ed.scene:removeEffect(skill.Ward_skillatk2Effect, 0)
  end
end

function Ward.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.Ward_bulletTime then
    return false
  else
    return basefunc(skill, target)
  end
end

function Ward.skillatk3_selectTarget(basefunc, skill, default)
  if skill.attack_counter == 1 then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Target Type"] = "maxdmg"
    })
    basefunc(skill, default)
    skill.info = originInfo
    return skill.target
  elseif skill.attack_counter > 1 then
    if skill.target == nil or not skill.target:isAlive() then
      return basefunc(skill, default)
    else
      return skill.target
    end
  else
    return basefunc(skill, default)
  end
end

function Ward.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    basefunc(skill)
    if ed.run_with_scene then
      local effect_name = "eff_point_Ward_atk3.cha"
      local scene_effect = ed.scene:playEffectOnScene(effect_name, {
        caster.position[1],
        caster.position[2] - 1
      }, {
        0.9 * caster.direction,
        0.9
      }, nil, 0)
      skill.Ward_skillatk3Effect = scene_effect
    end
  elseif skill.attack_counter == 1 or skill.attack_counter == 2 then
    skill.attack_counter = skill.attack_counter + 1
    if not skill.target or skill.target and not skill.target:isAlive() then
      return
    end
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Knock Up"] = 0,
      ["Knock Back"] = 0
    })
    skill:takeEffectOn(skill.target, caster)
    skill.info = originInfo
  elseif skill.attack_counter == 3 and ed.run_with_scene and skill.Ward_skillatk3Effect then
    ed.scene:removeEffect(skill.Ward_skillatk3Effect, 0)
  end
end

function Ward.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  caster.direction = caster.position[1] - target.position[1] > 0 and -1 or 1
  basefunc(skill, target, source, shift)
end

function Ward.skillatk3_finish(basefunc, skill)
  if ed.run_with_scene and skill.Ward_skillatk3Effect then
    ed.scene:removeEffect(skill.Ward_skillatk3Effect, 0)
  end
  basefunc(skill)
end

function Ward.skillatk4_finish(basefunc, skill)
  local caster = skill.caster
  if caster.Ward_current_region then
    caster.Ward_current_region.timer = 0.5
  end
  basefunc(skill)
end

function Ward.skillatk4_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  basefunc(skill, location, source)
  local skillatk4b = caster.skills.Ward_atk4b
  if skillatk4b then
    skillatk4b.target = caster
    local region = skillatk4b:createRegion()
    region.position = caster.position
    caster.Ward_current_region = region
    ed.engine:addRegion(region)
  end
end

function Ward.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster == target then
    return false
  else
    basefunc(skill, target, source, shift)
  end
end

function Ward.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Ward_hasCounter = nil
  hero.Ward_enemyList = {}
  hero.Ward_bulletlist = {}
  hero.Ward_exbulletlist = {}
  hero.Ward_bulletTime = nil
  hero.Ward_inTheShow = nil
  hero.Ward_actor_leaveScene = nil
  hero.Ward_current_region = nil
end

function Ward.init_hero(hero)
  hero.update = override(hero.update, Ward.hero_update)
  local skillult = hero.skills.Ward_ult
  if skillult then
    skillult.update = override(skillult.update, Ward.skillult_update)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Ward.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Ward.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, Ward.skillult_start)
    skillult.finish = override(skillult.finish, Ward.skillult_finish)
  end
  local skillultc = hero.skills.Ward_ultc
  if skillultc then
    skillultc.createBuff = override(skillultc.createBuff, Ward.skillultc_createBuff)
  end
  local skillatk2 = hero.skills.Ward_atk2
  if skillatk2 then
    skillatk2.selectTarget = override(skillatk2.selectTarget, Ward.skillatk2_selectTarget)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, Ward.skillatk2_takeEffectAt)
    skillatk2.start = override(skillatk2.start, Ward.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Ward.skillatk2_finish)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, Ward.skillatk2_canCastWithTarget)
  end
  local skillatk3 = hero.skills.Ward_atk3
  if skillatk3 then
    skillatk3.selectTarget = override(skillatk3.selectTarget, Ward.skillatk3_selectTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Ward.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Ward.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, Ward.skillatk3_finish)
  end
  local skillatk4 = hero.skills.Ward_atk4
  if skillatk4 then
    skillatk4.finish = override(skillatk4.finish, Ward.skillatk4_finish)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Ward.skillatk4_takeEffectAt)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Ward.skillatk4_takeEffectOn)
  end
  local skillawake = hero.skills.Ward_awake
  hero.reset = override(hero.reset, Ward.hero_reset)
  return hero
end

return Ward.init_hero
