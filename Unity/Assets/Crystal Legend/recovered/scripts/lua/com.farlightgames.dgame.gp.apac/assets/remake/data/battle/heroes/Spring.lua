module("ed.battlehero", package.seeall)
local ed = ed
local math = math
Spring = {}
Spring.atk2_ADReduceBuffID = 1473
Spring.ult_InvulnerableBuffID = 1474

function Spring.hero_reset(basefunc, hero)
  basefunc(hero)
end

function Spring.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function Spring.skillult_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = skill.target
  skill.info["No Dodge"] = true
  basefunc(skill, idx)
  if idx == 2 then
    local binfo = ed.lookupDataTable("Buff", nil, Spring.ult_InvulnerableBuffID)
    local buff = caster:addBuff(binfo, caster)
    caster.oriPos = caster.position[1]
    caster.position[1] = ed.engine.stage_rect.maxX / 2
    caster:setHpVisible(false)
    caster:setAllBuffVisible(false)
    caster:setShieldVisible(false)
    caster:setFuryVisible(false)
  elseif idx == 3 then
    caster.position[1] = caster.oriPos
    local location = {
      caster.position[1] + 120 * caster.direction,
      caster.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_Spring_ult2.cha"
      ed.scene:playEffectOnScene(effect_name, location, {1, 1}, nil, 1, nil, nil, nil)
    end
    caster:setHpVisible(true)
    caster:setAllBuffVisible(true)
    caster:setShieldVisible(true)
    caster:setFuryVisible(true)
  end
end

function Spring.skillult_power(basefunc, skill, source, target, damage_type)
  local current_phase_idx = skill.current_phase_idx
  local power = basefunc(skill, source, target, damage_type)
  if current_phase_idx < 3 then
    power = 0
  end
  return power
end

function Spring.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit = basefunc(skill, target, source, shift)
  if isHit then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if caster.direction == 1 and unit.position[1] - caster.position[1] < skill.info["Shape Arg1"] or caster.direction == -1 and caster.position[1] - unit.position[1] < skill.info["Shape Arg1"] then
        local binfo = ed.lookupDataTable("Buff", nil, Spring.atk2_ADReduceBuffID)
        local buff = ed.BuffCreate(binfo, target, caster)
        local ad = target.attribs.AD
        buff:setAttribute("AD", -0.1 * ad)
        unit:addBuff(buff, caster)
      end
    end
  end
end

function Spring.skillatk3_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  basefunc(skill, idx)
  local target = skill.target or caster.ai.target
  if idx == 3 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if math.abs(unit.position[1] - target.position[1]) > 100 then
      else
        local bid = 6
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        unit:addBuff(binfo, caster)
      end
    end
  end
end

function Spring.skillatk3_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  local target = skill.target or caster.ai.target
  if current_phase_idx == 1 then
    if caster.direction > 0 then
      caster.position[1] = ed.engine.stage_rect.minX + 80
      caster.direction = 1
    else
      caster.position[1] = ed.engine.stage_rect.maxX - 80
      caster.direction = -1
    end
    skill:startPhase(current_phase_idx + 1)
  elseif current_phase_idx == 2 then
    caster.position[1] = target.position[1] - 100 * caster.direction
    skill:startPhase(current_phase_idx + 1)
  else
    skill:finish()
  end
end

function Spring.skillatk3_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  local power = basefunc(skill, source, target, damage_type)
  if current_phase_idx < 3 then
    power = 0
  end
  return power
end

function Spring.skillatk4_Shield_Ondamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local skillatk4a = caster.skills.Spring_atk4a
  skillatk4a.cd_remaining = 0.1
  return basefunc(buff, damage, damage_type, source, skill, transferred)
end

function Spring.skillatk4_Shield_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4a = caster.skills.Spring_atk4a
  basefunc(buff)
  skillatk4a.cd_remaining = 9999
end

function Spring.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Spring.skillatk4_Shield_Ondamaged)
  buff.onRemoved = override(buff.onRemoved, Spring.skillatk4_Shield_onRemoved)
  return buff
end

function Spring.skillawake_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local target = skill.target or target
  local maxmp = target.mp
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit == target then
    elseif maxmp < unit.mp then
      maxmp = unit.mp
    end
  end
  if ed.run_with_scene then
    local effect_name = "eff_point_Spring_awake.cha"
    ed.scene:playEffectOnScene(effect_name, caster.position, {1, 1}, nil, 1, nil, nil, nil)
  end
  if target:isAlive() and maxmp - target.mp > skill.info["Basic Num"] then
    local addmp = maxmp - target.mp - skill.info["Basic Num"]
    target:takeHeal(addmp, "mp", caster)
  end
end

function Spring.init_hero(hero)
  local skillult = hero.skills.Spring_ult
  local skillatk2 = hero.skills.Spring_atk2
  local skillatk3 = hero.skills.Spring_atk3
  local skillatk4 = hero.skills.Spring_atk4
  local skillawake = hero.skills.Spring_awake
  if skillult then
    skillult.startPhase = override(skillult.startPhase, Spring.skillult_startPhase)
    skillult.power = override(skillult.power, Spring.skillult_power)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Spring.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.startPhase = override(skillatk3.startPhase, Spring.skillatk3_startPhase)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Spring.skillatk3_onPhaseFinished)
    skillatk3.power = override(skillatk3.power, Spring.skillatk3_power)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Spring.skillatk4_createBuff)
  end
  if skillawake then
    skillawake.start = override(skillawake.start, Spring.skillawake_start)
  end
  return hero
end

return Spring.init_hero
