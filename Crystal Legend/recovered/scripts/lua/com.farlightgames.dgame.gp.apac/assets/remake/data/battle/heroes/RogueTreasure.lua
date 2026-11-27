module("ed.battlehero", package.seeall)
local ed = ed
local math = math
RogueTreasure = {}
RogueTreasure.skillatk3_powerRatio = 2
RogueTreasure.devourOnDamageTimes = 7
RogueTreasure.devourMaxHP = 100000

function RogueTreasure.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.devourTarget = false
  hero.devourTargetFind = false
  hero.changePeriod_RogueTreasure = false
  hero.devourOnDamageTimes = 0
  hero.skillawake_timeCount = 0
  hero.initPortarit = false
  if ed.protoAwake(hero.proto, 503) then
    hero:enterActionStageFromOneStage(3, 503)
  else
    hero:enterActionStageFromOneStage(1, 503)
  end
end

function RogueTreasure.hero_update(basefunc, hero, dt)
  if hero.initPortarit == false then
    local panel = hero.heroPanel
    if panel and hero.name == "RogueTreasure" then
      if ed.protoAwake(hero.proto) then
        panel:setPortrait("UI/DOTA-HERO/SwitchTreasure1.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Treasure1.png")
      end
    end
    hero.initPortarit = true
  end
  basefunc(hero, dt)
end

function RogueTreasure.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.changePeriod_RogueTreasure or caster.devourTargetFind or caster.name ~= "RogueTreasure" then
    return false, "ult"
  end
  return basefunc(skill, target)
end

function RogueTreasure.skillult_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  if caster.changePeriod_RogueTreasure then
    if caster.current_skill then
      caster.current_skill:interrupt()
    end
    if caster:isAlive() then
      if ed.protoAwake(caster.proto, 503) then
        caster:enterActionStageFromOneStage(3, 503)
      else
        caster:enterActionStageFromOneStage(1, 503)
      end
    end
    local panel = caster.heroPanel
    if panel and caster.name == "RogueTreasure" then
      if ed.protoAwake(caster.proto) then
        panel:setPortrait("UI/DOTA-HERO/SwitchTreasure1.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Treasure1.png")
      end
    end
    caster.changePeriod_RogueTreasure = false
  end
  basefunc(buff)
end

function RogueTreasure.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, RogueTreasure.skillult_buffOnRemoved)
  return buff
end

function RogueTreasure.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local panel = caster.heroPanel
  if panel and caster.name == "RogueTreasure" then
    if ed.protoAwake(caster.proto) then
      panel:setPortrait("UI/DOTA-HERO/SwitchTreasure2.png")
    else
      panel:setPortrait("UI/DOTA-HERO/Treasure2.png")
    end
  end
  caster.changePeriod_RogueTreasure = true
end

function RogueTreasure.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_RogueTreasure then
    caster:enterActionStageFromOneStage(ed.protoAwake(caster.proto, 503) and 4 or 2, 503)
    skill.cd_remaining = 999
  end
end

function RogueTreasure.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  basefunc(projectile, target)
  if ed.run_with_scene then
    local effect_name = skill.info["Point Effect"]
    if effect_name then
      local effect_z = skill.info["Point Zorder"] or 0
      local pos = skill.target.position or caster.ai.target.position
      ed.scene:playEffectOnScene(effect_name, {
        pos[1],
        pos[2] - 1
      }, {
        projectile.direction,
        1
      }, nil, effect_z)
    end
  end
  if not projectile.terminated then
    projectile:terminate()
  end
end

function RogueTreasure.skillatk2_createProjectile(basefunc, skill)
  local origtarget = skill.target
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local tmpH = math.abs(skill.caster.position[1] - origtarget.position[1]) / 12 - 28
  local C = h + 20
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local tmpPos = {
    skill.caster.position[1] + 25 * skill.caster.direction,
    skill.caster.position[2]
  }
  local distance = ed.edpSub(origtarget.position, tmpPos)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  projectile.hit = override(projectile.hit, RogueTreasure.projectile_hit)
  return projectile
end

function RogueTreasure.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.skillatk2_Position = target.position
end

function RogueTreasure.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local res, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if res then
    if target.position then
      local direction = {1, 0}
      if target.position[1] == caster.skillatk2_Position[1] and target.position[2] == caster.skillatk2_Position[2] then
        direction = {0, 0}
      else
        direction = ed.edpCompMult({1, 0.1}, ed.edpNormalize(ed.edpSub(target.position, caster.skillatk2_Position)))
      end
      target:knockup(skill.info["Knock Up"], ed.edpMult(direction, skill.info["Knock Back"]), shift)
    end
    return res, dmg
  else
    return false
  end
end

function RogueTreasure.skillatk3_start(basefunc, skill, target)
  skill.info["Ignore Shield"] = true
  basefunc(skill, target)
  local caster = skill.caster
  local curDirection = caster.position[1] - target.position[1]
  if 0 < curDirection then
    caster.direction = -1
  else
    caster.direction = 1
  end
end

function RogueTreasure.skillatk3_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power = basefunc(skill, source, target, damage_type)
  if target then
    if caster.changePeriod_RogueTreasure then
      power = power * RogueTreasure.skillatk3_powerRatio
      return power
    end
    return power
  end
end

function RogueTreasure.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local hit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if hit then
    if target.info["Main Attrib"] == "STR" then
      local bid = 1375
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    elseif target.info["Main Attrib"] == "AGI" then
      local bid = 1376
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    elseif target.info["Main Attrib"] == "INT" then
      local bid = 1377
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
  end
end

function RogueTreasure.init_hero(hero)
  hero.reset = override(hero.reset, RogueTreasure.hero_reset)
  hero.update = override(hero.update, RogueTreasure.hero_update)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.RogueTreasure_ult
  local skillatk2 = hero.skills.RogueTreasure_atk2
  local skillatk3 = hero.skills.RogueTreasure_atk3
  local skillatk4 = hero.skills.RogueTreasure_atk4
  local skillatk2_2 = hero.skills.RogueTreasure2_atk2
  local skillatk3_2 = hero.skills.RogueTreasure2_atk3
  local skillatk4_2 = hero.skills.RogueTreasure2_atk4
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, RogueTreasure.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, RogueTreasure.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, RogueTreasure.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, RogueTreasure.skillult_createBuff)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, RogueTreasure.skillatk2_createProjectile)
    skillatk2.start = override(skillatk2.start, RogueTreasure.skillatk2_start)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, RogueTreasure.skillatk3_start)
    skillatk3.power = override(skillatk3.power, RogueTreasure.skillatk3_power)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, RogueTreasure.skillatk4_takeEffectOn)
  end
  if skillatk2_2 then
    skillatk2_2.createProjectile = override(skillatk2_2.createProjectile, RogueTreasure.skillatk2_createProjectile)
    skillatk2_2.start = override(skillatk2_2.start, RogueTreasure.skillatk2_start)
    skillatk2_2.takeEffectOn = override(skillatk2_2.takeEffectOn, RogueTreasure.skillatk2_takeEffectOn)
  end
  if skillatk3_2 then
    skillatk3_2.start = override(skillatk3_2.start, RogueTreasure.skillatk3_start)
    skillatk3_2.power = override(skillatk3_2.power, RogueTreasure.skillatk3_power)
  end
  if skillatk4_2 then
    skillatk4_2.takeEffectOn = override(skillatk4_2.takeEffectOn, RogueTreasure.skillatk4_takeEffectOn)
  end
  return hero
end

return RogueTreasure.init_hero
