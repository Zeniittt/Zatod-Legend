module("ed.battlehero", package.seeall)
local ed = ed
RuneCrusher = {}
RuneCrusher.RuneCrusher_atk3_buffid3 = 425
RuneCrusher.RuneCrusher_atk3_buffid = 421
RuneCrusher.RuneCrusher_skillatk4_deadtime = 1.5

function RuneCrusher.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.RuneCrusher_origin_pos = {}
  caster.RuneCrusher_origin_pos[1] = caster.position[1]
  caster.RuneCrusher_origin_pos[2] = caster.position[2]
end

function RuneCrusher.skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  local attack_counter = skill.attack_counter
  if attack_counter == 1 and (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 1 then
    caster.position = {
      target.position[1] - caster.direction * 70,
      target.position[2]
    }
  elseif 1 < attack_counter and attack_counter <= 3 then
    skill:takeEffectAt(target.position)
  elseif 3 < attack_counter and attack_counter <= 7 then
    skill:takeEffectAt(target.position)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  elseif attack_counter == 8 then
    local origin_info = skill.info
    skill.info = ed.wraptable(origin_info, {
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 60
    })
    skill:takeEffectAt(target.position)
    skill.info = origin_info
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(7, 0.1, 5)
    end
  elseif 8 < attack_counter then
    caster.position = {
      caster.RuneCrusher_origin_pos[1],
      caster.RuneCrusher_origin_pos[2]
    }
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function RuneCrusher.skillult_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local isHit = basefunc(skill, target, source)
  skill.info = originfo
  if isHit then
    local caster = skill.caster
    local dps_mod = caster.config.dps_mod
    local amount = skill.info["Script Arg6"]
    target:takeDamage(amount / dps_mod, "Holy", "mp", caster)
  end
end

function RuneCrusher.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local isHit = basefunc(skill, target, source)
  if isHit then
    local caster = skill.caster
    local dps_mod = caster.config.dps_mod
    local amount = skill.info["Script Arg6"]
    target:takeDamage(amount / dps_mod, "Holy", "mp", caster)
  end
end

function RuneCrusher.skillatk2_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local target
  local num = math.huge
  local camp = caster.camp
  for foes in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if foes.buff_effects.untargetable then
    elseif num >= foes.position[1] * camp then
      num = foes.position[1] * camp
      target = foes
    end
  end
  return target
end

function RuneCrusher.hero_takeDamage(basefunc, hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
  for _, mybuff in ipairs(hero.buff_list) do
    if mybuff.name == "RuneCrusher_atk3" then
      local damageSource = type(amount) == "table" and amount.source or source
      local damageField = type(amount) == "table" and amount.field or field
      local dps_mod = hero.config.dps_mod
      local skillatk3 = hero.skills.RuneCrusher_atk3
      local mpAmount = skillatk3.info["Script Arg6"]
      if damageSource and damageField == "hp" then
        damageSource:takeDamage(mpAmount / dps_mod, "Holy", "mp", hero)
        local binfo = ed.lookupDataTable("Buff", nil, RuneCrusher.RuneCrusher_atk3_buffid3)
        damageSource:addBuff(binfo, hero)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_impact_RuneCrusher_atk3.cha", {
            damageSource.position[1],
            damageSource.position[2] - 1
          }, {
            damageSource.direction,
            1
          }, nil, 1)
        end
      end
    end
  end
  return basefunc(hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
end

function RuneCrusher.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  for _, buff in ipairs(caster.buff_list) do
    if buff.info.ID == RuneCrusher.RuneCrusher_atk3_buffid then
      caster:removeBuff(buff)
    end
  end
  basefunc(skill)
end

function RuneCrusher.buffatk4_onDamaged(basefunc, buff, damage, damage_type)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = caster.skills.RuneCrusher_atk4
  local amount = skillatk4.info["Script Arg6"]
  owner:takeHeal(amount, "mp")
  return basefunc(buff, damage, damage_type)
end

function RuneCrusher.skillatk4_createBuff(basefunc, skill, target)
  local buffatk4 = basefunc(skill, target)
  buffatk4.onDamaged = override(buffatk4.onDamaged, RuneCrusher.buffatk4_onDamaged)
  return buffatk4
end

function RuneCrusher.hero_update(basefunc, hero, dt)
  if hero.state == ed.emUnitState_Dying then
    local skillatk4 = hero.skills.RuneCrusher_atk4
    if skillatk4 then
      if not hero.RuneCrusher_remainingTime then
        hero.RuneCrusher_remainingTime = RuneCrusher.RuneCrusher_skillatk4_deadtime
      end
      hero.RuneCrusher_remainingTime = hero.RuneCrusher_remainingTime - dt
      if hero.RuneCrusher_remainingTime <= 0 then
        hero.RuneCrusher_remainingTime = 999
        local target = skillatk4:selectTarget()
        if target then
          skillatk4:takeEffectOn(target)
        end
      end
    end
  end
  basefunc(hero, dt)
end

function RuneCrusher.init_hero(hero)
  local skillult = hero.skills.RuneCrusher_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, RuneCrusher.skillult_onAttackFrame)
    skillult.start = override(skillult.start, RuneCrusher.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, RuneCrusher.skillult_takeEffectOn)
  end
  local skillatk2 = hero.skills.RuneCrusher_atk2
  if skillatk2 then
    skillatk2.selectTarget = override(skillatk2.selectTarget, RuneCrusher.skillatk2_selectTarget)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, RuneCrusher.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.RuneCrusher_atk3
  if skillatk3 then
    hero.takeDamage = override(hero.takeDamage, RuneCrusher.hero_takeDamage)
    skillatk3.finish = override(skillatk3.finish, RuneCrusher.skillatk3_finish)
  end
  local skillatk4 = hero.skills.RuneCrusher_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, RuneCrusher.skillatk4_createBuff)
    if hero.name == "RuneCrusher" then
      hero.update = override(hero.update, RuneCrusher.hero_update)
    end
  end
  return hero
end

return RuneCrusher.init_hero
