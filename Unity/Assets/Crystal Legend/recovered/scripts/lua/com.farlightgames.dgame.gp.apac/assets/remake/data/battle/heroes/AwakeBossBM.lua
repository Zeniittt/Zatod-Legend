module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossBM = {}
AwakeBossBM.name = "AwakeBossBM"
AwakeBossBM.PigID = 200048
AwakeBossBM.EagleID = 200049
AwakeBossBM.EagleHeight = 110
AwakeBossBM.StealthBuffID = 12004606
AwakeBossBM.UncontrollableBuffID = 12004607
AwakeBossBM.UltEffectName = "eff_point_BM_ult.cha"
AwakeBossBM.EffectXInterval = 100
AwakeBossBM.skill3_h1 = 58
AwakeBossBM.skill3_h2 = 75

function AwakeBossBM.skillpush_takeEffectOn(basefunc, skill, target, source)
  if target == skill.IgnoreTarget then
    return
  end
  basefunc(skill, target, source)
end

function AwakeBossBM.ult_onAttackFrame(basefunc, skill)
  local self = skill
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  local caster = skill.caster
  if self.attack_counter == 1 then
    local bid = AwakeBossBM.UncontrollableBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    if buff then
      buff.timer = 0.35
    end
  elseif self.attack_counter == 2 then
    local info = skill.info
    info["No Dodge"] = skill.caster.MyEagle_AwakeBossBM ~= nil
    basefunc(skill)
    local target = skill.target
    if target then
      local skillpush = caster.skills[AwakeBossBM.name .. "_ult_push"]
      if skillpush then
        if skill.evo_rank and 1 <= skill.evo_rank then
          skillpush.info = ed.wraptable(skillpush.info, {
            ["Plus Ratio"] = skill.evo_rank1["Script Arg1"]
          })
        end
        if skill.evo_rank and 2 <= skill.evo_rank then
          skillpush.info = ed.wraptable(skillpush.info, {
            ["Plus Ratio"] = skill.evo_rank2["Script Arg1"]
          })
        end
        skillpush.info["Shape Arg1"] = math.abs(skill.target.position[1] - caster.position[1] + 30)
        skillpush.info["No Dodge"] = skill.caster.MyEagle_AwakeBossBM ~= nil
        skillpush.IgnoreTarget = target
        skillpush.takeEffectOn = override(skillpush.takeEffectOn, AwakeBossBM.skillpush_takeEffectOn)
        skillpush:takeEffectAt(caster.position)
      end
      if ed.run_with_scene then
        local effect_name = AwakeBossBM.UltEffectName
        if effect_name then
          local ultEffect_z = info["Point Zorder"] or 0
          local startPos = caster.position[1]
          local displacement = target.position[1] - startPos
          if displacement == 0 then
            displacement = 1
          end
          local dir = displacement / math.abs(displacement)
          local currentPos = caster.position[1] + dir * AwakeBossBM.EffectXInterval * 0.8
          local ultEffectY = caster.position[2]
          local ultEffectEndPos = target.position[1]
          local i = 0
          repeat
            i = i + 1
            ed.scene:playEffectOnScene(effect_name, {currentPos, ultEffectY}, {dir, 1}, nil, ultEffect_z)
            currentPos = currentPos + dir * AwakeBossBM.EffectXInterval
          until 1 < i and 0 <= (currentPos - ultEffectEndPos) * dir
        end
      end
    end
  end
end

function AwakeBossBM.eagle_reset(basefunc, eagle)
  basefunc(eagle)
  local bid = AwakeBossBM.StealthBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, eagle, eagle)
  buff.timer = 999
  eagle:addBuff(buff, eagle)
  local skill = eagle.skill_list[1]
  skill.info.buff_info.DODG = eagle.DODG_reduce
end

function AwakeBossBM.reset(basefunc, self)
  basefunc(self)
  self.AnimalEnterCountdown = nil
end

function AwakeBossBM.eagle_ai_searchTarget(basefunc, ai)
  local eagle = ai.owner
  local target = eagle.basic_skill:selectTarget()
  local minDistanceSQ = math.huge
  if target then
    minDistanceSQ = ed.edpDistanceSQ(eagle.position, target.position)
  end
  eagle.FocusTarget = target
  return target, minDistanceSQ
end

function AwakeBossBM.FocusBuff_onRemoved(basefunc, focusBuff)
  focusBuff.caster.FocusBuff = nil
  basefunc(focusBuff)
end

function AwakeBossBM.eagle_update(basefunc, eagle, dt)
  if eagle.actor and eagle:isAlive() then
    eagle.actor.height = AwakeBossBM.EagleHeight
    eagle.actor.zSpeed = nil
  end
  basefunc(eagle, dt)
  local focusTarget = eagle.FocusTarget
  if focusTarget and ed.edpDistanceSQ(eagle.position, focusTarget.position) < 225 then
    eagle.walk_speed_multiplier = 0.2
  elseif focusTarget and ed.edpDistanceSQ(eagle.position, focusTarget.position) < 1600 then
    eagle.walk_speed_multiplier = 0.5
  elseif focusTarget and ed.edpDistanceSQ(eagle.position, focusTarget.position) > 25600 then
    eagle.walk_speed_multiplier = 1.2
  else
    eagle.walk_speed_multiplier = 1
  end
  if focusTarget and focusTarget:isAlive() and ed.edpDistanceSQ(eagle.position, focusTarget.position) < 100 then
    if not eagle.FocusBuff then
      local focusBuff = focusTarget:addBuff(eagle.skill_list[1]:createBuff(focusTarget))
      if focusTarget then
        eagle.FocusBuff = focusBuff
        eagle.FocusBuff.onRemoved = override(eagle.FocusBuff.onRemoved, AwakeBossBM.FocusBuff_onRemoved)
      end
    end
    if eagle.FocusBuff then
      eagle.FocusBuff.timer = eagle.FocusBuff.info.Time
    end
  else
    eagle.FocusBuff = nil
  end
  eagle.live_time = eagle.live_time - dt
  if eagle.live_time <= 0 then
    if eagle.FocusBuff and eagle.FocusBuff.owner then
      eagle.FocusBuff.owner:removeBuff(eagle.FocusBuff)
    end
    eagle:animal_discard()
  end
end

function AwakeBossBM.animal_discard(animal)
  animal:die()
end

function AwakeBossBM.callAnimals(skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  if caster.MyPig_AwakeBossBM then
    caster.MyPig_AwakeBossBM:animal_discard()
  end
  if caster.MyEagle_AwakeBossBM then
    caster.MyEagle_AwakeBossBM:animal_discard()
  end
  local animals = {
    AwakeBossBM.PigID,
    AwakeBossBM.EagleID
  }
  for i = 1, 2 do
    local proto = {
      _tid = animals[i],
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1
    }
    local animal = ed.UnitCreate(proto, caster.camp, config)
    animal.direction = caster.direction
    animal.live_time = caster.summonlivetime
    local animal_location = {
      400 - 430 * dir,
      caster.position[2] - 40
    }
    if skill.caster:isAlive() then
      ed.engine:summonUnit(animal, animal_location, caster, "Idle")
    end
    animals[i] = animal
  end
  local pig = animals[1]
  caster.MyPig_AwakeBossBM = pig
  pig.Owner = caster
  pig.animal_discard = AwakeBossBM.animal_discard
  pig:reset()
  pig.skills.AwakeBMPig_atk.info.buff_info.HPR = info["Script Arg3"] - info["Script Arg4"] * caster.attribs.AD
  local pigattribs = skill.info["Script Arg1"] / 100
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 12004609)
  AwakeBossBM.changeBuffInfo(AttriBinfo, pigattribs, pig)
  local buff = pig:addBuff(AttriBinfo, caster)
  pig:takeHeal(pig.attribs.HP, "hp")
  pig.update = override(pig.update, AwakeBossBM.pig_update)
  pig.die = override(pig.die, function(basefunc, unit, killer)
    local owner = unit.Owner
    if owner.MyPig_AwakeBossBM == unit then
      owner.MyPig_AwakeBossBM = nil
    end
    if not ed.engine.running then
      unit:setDeathWithEffectOrNot(true)
    end
    basefunc(unit, killer)
  end)
  local eagle = animals[2]
  caster.MyEagle_AwakeBossBM = eagle
  eagle.flying = true
  eagle.basic_skill.max_range_sq = 640000
  eagle.reset = override(eagle.reset, AwakeBossBM.eagle_reset)
  eagle.update = override(eagle.update, AwakeBossBM.eagle_update)
  eagle.ai.searchTarget = override(eagle.ai.searchTarget, AwakeBossBM.eagle_ai_searchTarget)
  eagle.DODG_reduce = skill.info["Script Arg2"]
  caster.MyEagle_AwakeBossBM.Owner = caster
  eagle:reset()
  eagle.animal_discard = AwakeBossBM.animal_discard
  caster.MyEagle_AwakeBossBM.die = override(caster.MyEagle_AwakeBossBM.die, function(basefunc, unit, killer)
    local owner = unit.Owner
    if owner.MyEagle_AwakeBossBM == unit then
      owner.MyEagle_AwakeBossBM = nil
    end
    if not ed.engine.running then
      unit:setDeathWithEffectOrNot(true)
    end
    basefunc(unit, killer)
    if eagle.actor then
      eagle.actor.zSpeed = -0
    end
  end)
end

function AwakeBossBM.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function AwakeBossBM.pig_update(basefunc, pig, dt)
  basefunc(pig, dt)
  pig.live_time = pig.live_time - dt
  if pig.live_time <= 0 then
    pig:die()
  end
end

function AwakeBossBM.skill2_canCastWithTarget(basefunc, skill, target)
  local unit = skill.caster
  if unit.MyPig_AwakeBossBM and unit.MyEagle_AwakeBossBM then
    return false, "animals both alive"
  end
  return basefunc(skill, target)
end

function AwakeBossBM.skill2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  if skill.attack_counter == 1 then
    caster.AnimalEnterCountdown = 1.583333 - skill.current_phase_elapsed
    if ed.run_with_scene then
      local effect_name = info["Point Effect"]
      if effect_name then
        local effect_z = info["Point Zorder"] or 0
        ed.scene:playEffectOnScene(effect_name, {
          400 - 400 * dir,
          caster.position[2] - 25
        }, {dir, 1}, nil, effect_z)
      end
    end
  elseif skill.attack_counter == 2 then
  end
end

function AwakeBossBM.skill3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  skill.info["No Dodge"] = skill.caster.MyEagle_AwakeBossBM ~= nil
  if attack_counter == 0 then
    basefunc(skill)
  else
    attack_counter = attack_counter + 1
    skill.attack_counter = attack_counter
  end
end

function AwakeBossBM.skill3_projectile_terminate(basefunc, projectile)
  local projectile2 = projectile.skill:createProjectile(projectile)
  projectile2.position = projectile.position
  local v = projectile2.velocity
  projectile2.velocity = {
    -v[1],
    0
  }
  projectile2.zSpeed = (AwakeBossBM.skill3_h2 - projectile.height) / projectile.t0
  projectile2.max_distance = math.abs(projectile2.position[1] - projectile.skill.caster.position[1]) - 55
  ed.engine:addProjectile(projectile2)
  basefunc(projectile)
end

function AwakeBossBM.skill3_projectile2_terminate(basefunc, projectile)
  local skill = projectile.skill
  local caster = skill.caster
  if caster.current_skill == skill and skill.attack_counter < 2 then
    skill:onAttackFrame()
    skill:gotoEventIdx(2)
  end
  basefunc(projectile)
end

function AwakeBossBM.skill3_createProjectile(basefunc, skill, tile1)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local target = skill.target
  if tile1 == nil then
    projectile.max_distance = math.max(10, math.abs(target.position[1] - skill.caster.position[1]))
    local t0 = projectile.max_distance / projectile.velocity[1]
    projectile.zSpeed = (AwakeBossBM.skill3_h1 - projectile.height) / t0
    projectile.t0 = t0
    projectile.terminate = override(projectile.terminate, AwakeBossBM.skill3_projectile_terminate)
  else
    projectile.height = AwakeBossBM.skill3_h2
    if skill.evo_rank and skill.evo_rank >= 3 then
      projectile.hit = override(projectile.hit, AwakeBossBM.skill3evohit)
    end
    projectile.terminate = override(projectile.terminate, AwakeBossBM.skill3_projectile2_terminate)
  end
  return projectile
end

function AwakeBossBM.skill3evohit(basefunc, tile, target)
  basefunc(tile, target)
  local caster = tile.caster
  local skill = tile.skill
  if skill.evo_rank and skill.evo_rank >= 3 then
    local bid = 12004608
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("ARM", -caster.attribs.STR * skill.evo_rank3["Script Arg1"] / 100)
    target:addBuff(buff, caster)
  end
end

function AwakeBossBM.update(basefunc, unit, dt)
  local animalEnterCountdown = unit.AnimalEnterCountdown
  if animalEnterCountdown then
    animalEnterCountdown = animalEnterCountdown - dt
    if animalEnterCountdown <= 0 then
      AwakeBossBM.callAnimals(unit.skillCallAnimals)
      animalEnterCountdown = nil
    end
    unit.AnimalEnterCountdown = animalEnterCountdown
  end
  basefunc(unit, dt)
end

function AwakeBossBM.die(basefunc, unit, killer)
  if unit.MyPig_AwakeBossBM and unit.MyPig_AwakeBossBM:isAlive() then
    AwakeBossBM.animal_discard(unit.MyPig_AwakeBossBM)
  end
  if unit.MyEagle_AwakeBossBM and unit.MyEagle_AwakeBossBM:isAlive() then
    AwakeBossBM.animal_discard(unit.MyEagle_AwakeBossBM)
  end
  basefunc(unit, killer)
end

function AwakeBossBM.skill4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = buff.timer + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HIT", skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HAST", skill.info.buff_info.HAST + skill.evo_rank3["Script Arg1"])
    buff:setAttribute("MSPD", skill.info.buff_info.MSPD + skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function AwakeBossBM.skill3_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  target:takeDamage(200 / caster.config.dps_mod, "Holy", "mp", caster)
end

function AwakeBossBM.init_hero(hero)
  hero.reset = override(hero.reset, AwakeBossBM.reset)
  local skillult = hero.skills[AwakeBossBM.name .. "_ult"]
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, AwakeBossBM.ult_onAttackFrame)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      local buff_info = skillult.info.buff_info
      skillult.info = ed.wraptable(skillult.info, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillult.evo_rank3["Script Arg1"]
        })
      })
    end
  end
  local skill2 = hero.skills[AwakeBossBM.name .. "_atk2"]
  if skill2 then
    hero.skillCallAnimals = skill2
    hero.summonlivetime = 10
    if skill2.evo_rank and skill2.evo_rank >= 1 then
      skill2.info = ed.wraptable(skill2.info, {
        ["Script Arg4"] = skill2.evo_rank1["Script Arg1"]
      })
    end
    if skill2.evo_rank and skill2.evo_rank >= 2 then
      skill2.info = ed.wraptable(skill2.info, {
        ["Script Arg2"] = skill2.info["Script Arg2"] - skill2.evo_rank2["Script Arg1"]
      })
    end
    if skill2.evo_rank and skill2.evo_rank >= 3 then
      hero.summonlivetime = hero.summonlivetime + skill2.evo_rank3["Script Arg1"]
    end
    skill2.canCastWithTarget = override(skill2.canCastWithTarget, AwakeBossBM.skill2_canCastWithTarget)
    skill2.takeEffectAt = override(skill2.takeEffectAt, AwakeBossBM.skill2_takeEffectAt)
  end
  local skill3 = hero.skills[AwakeBossBM.name .. "_atk3"]
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, AwakeBossBM.skill3_onAttackFrame)
    skill3.createProjectile = override(skill3.createProjectile, AwakeBossBM.skill3_createProjectile)
    skill3.takeEffectOn = override(skill3.takeEffectOn, AwakeBossBM.skill3_takeEffectOn)
    if skill3.evo_rank and skill3.evo_rank >= 1 then
      skill3.info = ed.wraptable(skill3.info, {
        ["Plus Ratio"] = skill3.evo_rank1["Script Arg1"]
      })
    end
    if skill3.evo_rank and skill3.evo_rank >= 2 then
      skill3.info = ed.wraptable(skill3.info, {
        ["Plus Ratio"] = skill3.evo_rank2["Script Arg1"]
      })
    end
  end
  local skill4 = hero.skills[AwakeBossBM.name .. "_atk4"]
  if skill4 then
    skill4.createBuff = override(skill4.createBuff, AwakeBossBM.skill4_createBuff)
  end
  hero.update = override(hero.update, AwakeBossBM.update)
  hero.die = override(hero.die, AwakeBossBM.die)
  return hero
end

return AwakeBossBM.init_hero
