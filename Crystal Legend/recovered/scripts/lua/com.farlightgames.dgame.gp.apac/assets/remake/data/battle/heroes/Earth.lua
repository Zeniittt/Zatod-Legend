module("ed.battlehero", package.seeall)
local ed = ed
Earth = {}

function Earth.createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableTrack(skill.target)
  return projectile
end

function Earth.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  caster.Earth_left = 0
  caster.Earth_right = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.position[1] > caster.position[1] and unit.position[1] - caster.position[1] < 340 and 0 < unit.position[1] and unit.position[1] < 800 then
      caster.Earth_right = caster.Earth_right + 1
    elseif unit.position[1] < caster.position[1] and caster.position[1] - unit.position[1] < 340 and 0 < unit.position[1] and unit.position[1] < 800 then
      caster.Earth_left = caster.Earth_left + 1
    end
  end
  if caster.Earth_left > caster.Earth_right then
    caster.direction = -1
  elseif caster.Earth_left < caster.Earth_right then
    caster.direction = 1
  else
    caster.direction = -caster:getInitDir()
  end
  caster.Earth_atk3_startdirection = caster.direction
  caster.position1 = {
    caster.position[1],
    caster.position[2]
  }
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 412
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Earth.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  caster.direction = caster.Earth_atk3_startdirection
  basefunc(skill, location, source)
end

function Earth.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 412 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  local caster = skill.caster
  caster.direction = caster.Earth_atk3_startdirection
  local position = caster.position[1] + caster.Earth_atk3_startdirection * 350
  if 780 < position then
    position = 780
  elseif position < 20 then
    position = 20
  end
  caster:setPosition({
    position,
    skill.caster.position[2]
  })
  local skillatk31 = skill.caster.skills.Earth_atk3_1
  if skillatk31 then
    skillatk31.cd_remaining = 0
  end
end

function Earth.skillatk3_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  caster.Earth_left = 0
  caster.Earth_right = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.position[1] > caster.position[1] and unit.position[1] - caster.position[1] < 340 and 0 < unit.position[1] and unit.position[1] < 800 then
      caster.Earth_right = caster.Earth_right + 1
    elseif unit.position[1] < caster.position[1] and caster.position[1] - unit.position[1] < 340 and 0 < unit.position[1] and unit.position[1] < 800 then
      caster.Earth_left = caster.Earth_left + 1
    end
  end
  if not basefunc(skill, target) or caster.Earth_left == 0 and caster.Earth_right == 0 then
    return false
  end
  return true
end

function Earth.skillatk3_1_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 411
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function Earth.skillatk3_1_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 411 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function Earth.skillatk3_1_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if caster and caster:isAlive() then
    local proto = {
      _tid = 193,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _skill_levels = {
        [2] = skill.level
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      summoner = caster
    }
    local stone = ed.UnitCreate(proto, caster.camp, config)
    local location = caster.position
    local location_stone = {
      location[1] + 105 * caster.direction,
      location[2] - 5
    }
    if location_stone[1] > 780 then
      location_stone[1] = 780
    elseif location_stone[1] < 20 then
      location_stone[1] = 20
    end
    ed.engine:summonUnit(stone, location_stone, caster, "Idle")
    stone.father = caster
    local bid = 409
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, stone, caster)
    stone:addBuff(buff, caster)
    table.insert(caster.Earth_stone_list, stone)
    caster.Earth_mob_num = caster.Earth_mob_num + 1
    if caster.ai.will_cast_manual_skill then
      if caster.Earth_mob_num >= 3 then
        local skillatk4_1 = caster.skills.Earth_atk4_1
        skillatk4_1.cd_remaining = 0
      end
    elseif caster.Earth_mob_num >= 4 then
      local skillatk4_1 = caster.skills.Earth_atk4_1
      skillatk4_1.cd_remaining = 0
    end
  end
  if skill.target then
    caster:setPosition({
      caster.position1[1],
      caster.position1[2]
    })
  end
end

function Earth.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local infernal_skill2_lv = caster.skills.Earth_ult and caster.skills.Earth_ult.level or 0
  if caster and caster:isAlive() then
    local proto = {
      _tid = 193,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _skill_levels = {
        [2] = skill.level
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      summoner = caster
    }
    local stone = ed.UnitCreate(proto, caster.camp, config)
    local target = skill.target
    target = target or skill:selectTarget(nil)
    if target then
      local location = target.position
      local location_stone = {
        location[1] + 60 * caster.direction,
        location[2] + 0
      }
      if location_stone[1] > 780 then
        location_stone[1] = 780
      elseif location_stone[1] < 20 then
        location_stone[1] = 20
      end
      ed.engine:summonUnit(stone, location_stone, caster)
    else
      local location = caster.position
      local location_stone = {
        location[1] + 60 * caster.direction,
        location[2] + 0
      }
      if location_stone[1] > 780 then
        location_stone[1] = 780
      elseif location_stone[1] < 20 then
        location_stone[1] = 20
      end
      ed.engine:summonUnit(stone, location_stone, caster)
    end
    stone.father = caster
    local bid = 409
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, stone, caster)
    stone:addBuff(buff, caster)
    table.insert(caster.Earth_stone_list, stone)
    caster.Earth_mob_num = caster.Earth_mob_num + 1
    if caster.ai.will_cast_manual_skill then
      if caster.Earth_mob_num >= 3 then
        local skillatk4_1 = caster.skills.Earth_atk4_1
        skillatk4_1.cd_remaining = 0
      end
    elseif caster.Earth_mob_num >= 4 then
      local skillatk4_1 = caster.skills.Earth_atk4_1
      skillatk4_1.cd_remaining = 0
    end
  end
end

function Earth.skillatk4_1_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillult = caster.skills.Earth_ult
  if not basefunc(skill, target) or caster.current_skill == skillult or caster.current_skill == skill then
    return false
  end
  return true
end

function Earth.skillatk4_1_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local Earth_bomb_delay = 0
  for _, unit in pairs(caster.Earth_stone_list) do
    if unit and unit:isAlive() then
      local skillatk41 = unit.skills.Stone_atk
      if skillatk41 then
        skillatk41.cd_remaining = Earth_bomb_delay
      end
      Earth_bomb_delay = Earth_bomb_delay + 0.4
    end
  end
  caster.Earth_mob_num = 0
end

function Earth.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 412
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.Earth_ult_direction = caster.direction
end

function Earth.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 100,
      ["X Shift"] = 100,
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 1,
      ["Plus Ratio"] = 1.4,
      ["Point Effect"] = "eff_tile_TS_atk2.cha"
    })
    basefunc(skill)
    skill.info = originfo
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(3, 0.2, 2)
    end
  elseif attack_counter == 2 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 100,
      ["X Shift"] = 200,
      ["Knock Up"] = 0.8,
      ["Knock Back"] = 1,
      ["Plus Ratio"] = 1.7,
      ["Point Effect"] = "eff_tile_TS_atk2.cha"
    })
    basefunc(skill)
    skill.info = originfo
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(4, 0.2, 2)
    end
  elseif attack_counter == 3 then
    local skillult2 = skill.caster.skills.Earth_ult2
    skill.attack_counter = skill.attack_counter + 1
    skillult2:takeEffectAt(skill.caster.position)
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 412 then
        local buff = tbuff
        buff.owner:removeBuff(buff)
      end
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.5, 5)
    end
  else
    basefunc(skill)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(2, 0.2, 2)
    end
  end
end

function Earth.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  caster.direction = caster.Earth_ult_direction
  basefunc(skill, location, source)
end

function Earth.hero_castManualSkill(basefunc, hero)
  local skillatk4_1 = hero.skills.Earth_atk4_1
  if skillatk4_1 and hero.mp < 1000 and hero.Earth_mob_num >= 1 and (not hero.current_skill or hero.current_skill.info["Skill Name"] ~= "Earth_ult") then
    skillatk4_1.cd_remaining = 0
    hero:castSkill(hero.skills.Earth_atk4_1, nil)
  else
    basefunc(hero)
  end
end

function Earth.reset(basefunc, hero)
  basefunc(hero)
  hero.Earth_mob_num = 0
  hero.Earth_stone_list = {}
end

function Earth.hero_die(basefunc, hero, killer)
  for _, unit in pairs(hero.Earth_stone_list) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Earth.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skill41 = hero.skills.Earth_atk4_1
  local skillult = hero.skills.Earth_ult
  local BeControlled = false
  if hero.buff_effects.stun or hero.buff_effects.silence or hero.buff_effects.doom or hero.buff_effects.enchanted then
    BeControlled = true
  end
  hero.can_cast_manual = hero.can_cast_manual or skill41 and hero.Earth_mob_num >= 1 and hero:isAlive() and hero.current_skill ~= skillult and hero.current_skill ~= skill41 and not BeControlled
  if hero.current_skill and hero.current_skill.info["Skill Name"] == "Earth_ult" then
    hero.direction = hero.Earth_ult_direction
  end
end

function Earth.init_hero(hero)
  hero.Earth_stone_list = {}
  hero.Earth_mob_num = 0
  hero.reset = override(hero.reset, Earth.reset)
  hero.die = override(hero.die, Earth.hero_die)
  hero.castManualSkill = override(hero.castManualSkill, Earth.hero_castManualSkill)
  hero.update = override(hero.update, Earth.hero_update)
  local skillatk3 = hero.skills.Earth_atk3
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Earth.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Earth.skillatk3_finish)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Earth.skillatk3_takeEffectAt)
  end
  local skillatk3_1 = hero.skills.Earth_atk3_1
  if skillatk3_1 then
    skillatk3_1.start = override(skillatk3_1.start, Earth.skillatk3_1_start)
    skillatk3_1.takeEffectAt = override(skillatk3_1.takeEffectAt, Earth.skillatk3_1_takeEffectAt)
    skillatk3_1.onAttackFrame = override(skillatk3_1.onAttackFrame, Earth.skillatk3_1_onAttackFrame)
  end
  local skillatk4 = hero.skills.Earth_atk4
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Earth.skillatk4_onAttackFrame)
  end
  local skillatk4_1 = hero.skills.Earth_atk4_1
  if skillatk4_1 then
    skillatk4_1.onAttackFrame = override(skillatk4_1.onAttackFrame, Earth.skillatk4_1_onAttackFrame)
    skillatk4_1.canCastWithTarget = override(skillatk4_1.canCastWithTarget, Earth.skillatk4_1_canCastWithTarget)
  end
  local skillult = hero.skills.Earth_ult
  if skillult then
    skillult.start = override(skillult.start, Earth.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Earth.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Earth.skillult_takeEffectAt)
  end
  local skillatk2 = hero.skills.Earth_atk2
  if skillatk2 then
    if ed.engine.stage_info and ed.engine.stage_info["Stage ID"] == 20105 then
      skillatk2.info["Init CD"] = 3
    end
    skillatk2.createProjectile = override(skillatk2.createProjectile, Earth.createProjectile)
  end
  return hero
end

return Earth.init_hero
