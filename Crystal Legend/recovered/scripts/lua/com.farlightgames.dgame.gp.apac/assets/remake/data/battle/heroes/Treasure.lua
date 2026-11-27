module("ed.battlehero", package.seeall)
local ed = ed
local math = math
Treasure = {}
Treasure.skillatk3_powerRatio = 2
Treasure.devourOnDamageTimes = 7
Treasure.devourMaxHP = 100000

function Treasure.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.devourTarget = false
  hero.devourTargetFind = false
  hero.changePeriod_Treasure = false
  hero.devourOnDamageTimes = 0
  hero.skillawake_timeCount = 0
  hero.initPortarit = false
  if ed.protoAwake(hero.proto, 10057) then
    hero:enterActionStageFromOneStage(3, 10057)
  else
    hero:enterActionStageFromOneStage(1, 10057)
  end
end

function Treasure.hero_update(basefunc, hero, dt)
  if hero.initPortarit == false then
    local panel = hero.heroPanel
    if panel and hero.name == "Treasure" then
      if ed.protoAwake(hero.proto) then
        panel:setPortrait("UI/DOTA-HERO/SwitchTreasure1.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Treasure1.png")
      end
    end
    hero.initPortarit = true
  end
  local skillawake = hero.skills.Treasure_awake
  if skillawake and skillawake.cd_remaining <= 0 and not hero.changePeriod_Treasure and not hero.config.is_summoned then
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      if not unit:isHero() or unit.config.is_summoned or unit.buffManager.invisible then
      else
        local maxRange = skillawake.info["Max Range"]
        if maxRange > math.abs(unit.position[1] - hero.position[1]) then
          local bid = 1379
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = hero:addBuff(binfo, hero)
        end
      end
    end
  end
  basefunc(hero, dt)
end

function Treasure.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.changePeriod_Treasure or caster.devourTargetFind or caster.name ~= "Treasure" then
    return false, "ult"
  end
  return basefunc(skill, target)
end

function Treasure.skillult_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  if caster.changePeriod_Treasure then
    if caster.current_skill then
      caster.current_skill:interrupt()
    end
    if caster:isAlive() then
      if ed.protoAwake(caster.proto, 10057) then
        caster:enterActionStageFromOneStage(3, 10057)
      else
        caster:enterActionStageFromOneStage(1, 10057)
      end
    end
    local panel = caster.heroPanel
    if panel and caster.name == "Treasure" then
      if ed.protoAwake(caster.proto) then
        panel:setPortrait("UI/DOTA-HERO/SwitchTreasure1.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Treasure1.png")
      end
    end
    caster.changePeriod_Treasure = false
  end
  basefunc(buff)
end

function Treasure.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Treasure.skillult_buffOnRemoved)
  return buff
end

function Treasure.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local panel = caster.heroPanel
  if panel and caster.name == "Treasure" then
    if ed.protoAwake(caster.proto) then
      panel:setPortrait("UI/DOTA-HERO/SwitchTreasure2.png")
    else
      panel:setPortrait("UI/DOTA-HERO/Treasure2.png")
    end
  end
  caster.changePeriod_Treasure = true
end

function Treasure.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_Treasure then
    caster:enterActionStageFromOneStage(ed.protoAwake(caster.proto, 10057) and 4 or 2, 10057)
    skill.cd_remaining = 999
  end
end

function Treasure.projectile_hit(basefunc, projectile, target)
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

function Treasure.skillatk2_createProjectile(basefunc, skill)
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
  projectile.hit = override(projectile.hit, Treasure.projectile_hit)
  return projectile
end

function Treasure.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.skillatk2_Position = target.position
end

function Treasure.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
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

function Treasure.skillatk3_start(basefunc, skill, target)
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

function Treasure.skillatk3_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power = basefunc(skill, source, target, damage_type)
  if target then
    if caster.changePeriod_Treasure then
      power = power * Treasure.skillatk3_powerRatio
      return power
    end
    return power
  end
end

function Treasure.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
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

function Treasure.skillawake_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local canCast = basefunc(skill, target)
  if not target:isHero() or target.config.is_summoned or target.buffManager.invisible or target.config.what == "lordUnit" or caster.changePeriod_Treasure or caster.config.is_summoned then
    return false
  elseif canCast then
    if caster.current_skill then
      caster.current_skill:interrupt()
    end
    return true
  else
    return false
  end
end

function Treasure.devourBuff_OnRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  local skillawake = caster.skills.Treasure_awake
  caster.global_cd = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1373 then
      tbuff.timer = 0
    end
  end
  caster.devourTargetFind = false
  basefunc(buff)
  caster:setAction("awake2")
  owner:setHpVisible(true)
  owner:setAllBuffVisible(true)
  owner:setShieldVisible(true)
  owner:setFuryVisible(true)
end

function Treasure.devourBuff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.hp < 5 then
    owner:die()
  end
  if not caster:isAlive() then
    buff.timer = 0
  end
  basefunc(buff, dt)
end

function Treasure.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hpr = math.min(Treasure.devourMaxHP, -target.attribs.HP * skill.info["Script Arg5"] / 100)
  buff:setAttribute("HPR", hpr)
  buff.update = override(buff.update, Treasure.devourBuff_update)
  buff.onRemoved = override(buff.onRemoved, Treasure.devourBuff_OnRemoved)
  local bid = 1373
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buffSelf = caster:addBuff(binfo, caster)
  buffSelf:setAttribute("HPR", caster.attribs.HP * skill.info["Script Arg5"] / 100)
  return buff
end

function Treasure.skillawake_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local result = basefunc(skill, target, source)
  local caster = skill.caster
  local curDirection = caster.position[1] - target.position[1]
  if 0 < curDirection then
    caster.direction = -1
  else
    caster.direction = 1
  end
  if result and target:isAlive() then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 1372 then
        caster.global_cd = 10
        target:setHpVisible(false)
        target:setAllBuffVisible(false)
        target:setShieldVisible(false)
        target:setFuryVisible(false)
        caster.devourTargetFind = true
      end
    end
  end
end

function Treasure.skillawake_interrupt(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 0 then
    skill.cd_remaining = 1
  end
end

local function init_hero(hero)
  hero.reset = override(hero.reset, Treasure.hero_reset)
  hero.update = override(hero.update, Treasure.hero_update)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.Treasure_ult
  local skillatk2 = hero.skills.Treasure_atk2
  local skillatk3 = hero.skills.Treasure_atk3
  local skillatk4 = hero.skills.Treasure_atk4
  local skillawake = hero.skills.Treasure_awake
  local skillatk2_2 = hero.skills.Treasure2_atk2
  local skillatk3_2 = hero.skills.Treasure2_atk3
  local skillatk4_2 = hero.skills.Treasure2_atk4
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Treasure.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Treasure.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, Treasure.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, Treasure.skillult_createBuff)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, Treasure.skillatk2_createProjectile)
    skillatk2.start = override(skillatk2.start, Treasure.skillatk2_start)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Treasure.skillatk3_start)
    skillatk3.power = override(skillatk3.power, Treasure.skillatk3_power)
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Treasure.skillatk4_takeEffectOn)
  end
  if skillawake then
    skillawake.canCastWithTarget = override(skillawake.canCastWithTarget, Treasure.skillawake_canCastWithTarget)
    skillawake.createBuff = override(skillawake.createBuff, Treasure.skillawake_createBuff)
    skillawake.takeEffectOn = override(skillawake.takeEffectOn, Treasure.skillawake_takeEffectOn)
    skillawake.interrupt = override(skillawake.interrupt, Treasure.skillawake_interrupt)
  end
  if skillatk2_2 then
    skillatk2_2.createProjectile = override(skillatk2_2.createProjectile, Treasure.skillatk2_createProjectile)
    skillatk2_2.start = override(skillatk2_2.start, Treasure.skillatk2_start)
    skillatk2_2.takeEffectOn = override(skillatk2_2.takeEffectOn, Treasure.skillatk2_takeEffectOn)
  end
  if skillatk3_2 then
    skillatk3_2.start = override(skillatk3_2.start, Treasure.skillatk3_start)
    skillatk3_2.power = override(skillatk3_2.power, Treasure.skillatk3_power)
  end
  if skillatk4_2 then
    skillatk4_2.takeEffectOn = override(skillatk4_2.takeEffectOn, Treasure.skillatk4_takeEffectOn)
  end
  return hero
end

return init_hero
