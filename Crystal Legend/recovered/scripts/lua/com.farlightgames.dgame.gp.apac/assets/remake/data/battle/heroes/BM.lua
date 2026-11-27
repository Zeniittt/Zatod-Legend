module("ed.battlehero", package.seeall)
local ed = ed
BM = {}
BM.name = "BM"
BM.PigID = 169
BM.EagleID = 170
BM.EagleHeight = 110
BM.StealthBuffID = 10007406
BM.UncontrollableBuffID = 10007407
BM.UltEffectName = "eff_point_BM_ult.cha"
BM.EffectXInterval = 100
BM.skill3_h1 = 58
BM.skill3_h2 = 75

function BM.skillpush_takeEffectOn(basefunc, skill, target, source)
  if target == skill.IgnoreTarget then
    return
  end
  basefunc(skill, target, source)
end

function BM.ult_onAttackFrame(basefunc, skill)
  local self = skill
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  local caster = skill.caster
  if self.attack_counter == 1 then
    local bid = BM.UncontrollableBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    if buff then
      buff.timer = 0.35
    end
  elseif self.attack_counter == 2 then
    local info = skill.info
    info["No Dodge"] = skill.caster.MyEagle_BM ~= nil
    basefunc(skill)
    local target = skill.target
    if target then
      local skillpush = caster.skills[BM.name .. "_ult_push"]
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
        skillpush.info["No Dodge"] = skill.caster.MyEagle_BM ~= nil
        skillpush.IgnoreTarget = target
        skillpush.takeEffectOn = override(skillpush.takeEffectOn, BM.skillpush_takeEffectOn)
        skillpush:takeEffectAt(caster.position)
      end
      if ed.run_with_scene then
        local effect_name = BM.UltEffectName
        if effect_name then
          local ultEffect_z = info["Point Zorder"] or 0
          local startPos = caster.position[1]
          local displacement = target.position[1] - startPos
          if displacement == 0 then
            displacement = 1
          end
          local dir = displacement / math.abs(displacement)
          local currentPos = caster.position[1] + dir * BM.EffectXInterval * 0.8
          local ultEffectY = caster.position[2]
          local ultEffectEndPos = target.position[1]
          local i = 0
          repeat
            i = i + 1
            ed.scene:playEffectOnScene(effect_name, {currentPos, ultEffectY}, {dir, 1}, nil, ultEffect_z)
            currentPos = currentPos + dir * BM.EffectXInterval
          until 1 < i and 0 <= (currentPos - ultEffectEndPos) * dir
        end
      end
    end
  end
end

function BM.eagle_reset(basefunc, eagle)
  basefunc(eagle)
  local bid = BM.StealthBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, eagle, eagle)
  buff.timer = 999
  eagle:addBuff(buff, eagle)
  local skill = eagle.skill_list[1]
  skill.info.buff_info.DODG = eagle.DODG_reduce
end

function BM.reset(basefunc, self)
  basefunc(self)
  self.AnimalEnterCountdown = nil
end

function BM.eagle_ai_searchTarget(basefunc, ai)
  local eagle = ai.owner
  local target = eagle.basic_skill:selectTarget()
  local minDistanceSQ = math.huge
  if target then
    minDistanceSQ = ed.edpDistanceSQ(eagle.position, target.position)
  end
  eagle.FocusTarget = target
  return target, minDistanceSQ
end

function BM.FocusBuff_onRemoved(basefunc, focusBuff)
  focusBuff.caster.FocusBuff = nil
  basefunc(focusBuff)
end

function BM.eagle_update(basefunc, eagle, dt)
  if eagle.actor and eagle:isAlive() then
    eagle.actor.height = BM.EagleHeight
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
        eagle.FocusBuff.onRemoved = override(eagle.FocusBuff.onRemoved, BM.FocusBuff_onRemoved)
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

function BM.animal_discard(animal)
  animal:die()
end

function BM.callAnimals(skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  if caster.MyPig_BM then
    caster.MyPig_BM:animal_discard()
  end
  if caster.MyEagle_BM then
    caster.MyEagle_BM:animal_discard()
  end
  local animals = {
    BM.PigID,
    BM.EagleID
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
  caster.MyPig_BM = pig
  pig.Owner = caster
  pig.animal_discard = BM.animal_discard
  pig:reset()
  pig.skills.BMPig_atk.info.buff_info.HPR = info["Script Arg3"] - info["Script Arg4"] * caster.attribs.AD
  local pigattribs = skill.info["Script Arg1"] / 100
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 10007409)
  BM.changeBuffInfo(AttriBinfo, pigattribs, pig)
  local buff = pig:addBuff(AttriBinfo, caster)
  pig:takeHeal(pig.attribs.HP, "hp")
  pig.update = override(pig.update, BM.pig_update)
  pig.die = override(pig.die, function(basefunc, unit, killer)
    local owner = unit.Owner
    if owner.MyPig_BM == unit then
      owner.MyPig_BM = nil
    end
    if not ed.engine.running then
      unit:setDeathWithEffectOrNot(true)
    end
    basefunc(unit, killer)
  end)
  local eagle = animals[2]
  caster.MyEagle_BM = eagle
  eagle.flying = true
  eagle.basic_skill.max_range_sq = 640000
  eagle.reset = override(eagle.reset, BM.eagle_reset)
  eagle.update = override(eagle.update, BM.eagle_update)
  eagle.ai.searchTarget = override(eagle.ai.searchTarget, BM.eagle_ai_searchTarget)
  eagle.DODG_reduce = skill.info["Script Arg2"]
  caster.MyEagle_BM.Owner = caster
  eagle:reset()
  eagle.animal_discard = BM.animal_discard
  caster.MyEagle_BM.die = override(caster.MyEagle_BM.die, function(basefunc, unit, killer)
    local owner = unit.Owner
    if owner.MyEagle_BM == unit then
      owner.MyEagle_BM = nil
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

function BM.changeBuffInfo(buffInfo, enhance, target)
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

function BM.pig_update(basefunc, pig, dt)
  basefunc(pig, dt)
  pig.live_time = pig.live_time - dt
  if pig.live_time <= 0 then
    pig:die()
  end
end

function BM.skill2_canCastWithTarget(basefunc, skill, target)
  local unit = skill.caster
  if unit.MyPig_BM and unit.MyEagle_BM then
    return false, "animals both alive"
  end
  return basefunc(skill, target)
end

function BM.skill2_takeEffectAt(basefunc, skill, location, source)
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

function BM.skill3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  skill.info["No Dodge"] = skill.caster.MyEagle_BM ~= nil
  if attack_counter == 0 then
    basefunc(skill)
  else
    attack_counter = attack_counter + 1
    skill.attack_counter = attack_counter
  end
end

function BM.skill3_projectile_terminate(basefunc, projectile)
  local projectile2 = projectile.skill:createProjectile(projectile)
  projectile2.position = projectile.position
  local v = projectile2.velocity
  projectile2.velocity = {
    -v[1],
    0
  }
  projectile2.zSpeed = (BM.skill3_h2 - projectile.height) / projectile.t0
  projectile2.max_distance = math.abs(projectile2.position[1] - projectile.skill.caster.position[1]) - 55
  ed.engine:addProjectile(projectile2)
  basefunc(projectile)
end

function BM.skill3_projectile2_terminate(basefunc, projectile)
  local skill = projectile.skill
  local caster = skill.caster
  if caster.current_skill == skill and skill.attack_counter < 2 then
    skill:onAttackFrame()
    skill:gotoEventIdx(2)
  end
  basefunc(projectile)
end

function BM.skill3_createProjectile(basefunc, skill, tile1)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local target = skill.target
  if tile1 == nil then
    projectile.max_distance = math.max(10, math.abs(target.position[1] - skill.caster.position[1]))
    local t0 = projectile.max_distance / projectile.velocity[1]
    projectile.zSpeed = (BM.skill3_h1 - projectile.height) / t0
    projectile.t0 = t0
    projectile.terminate = override(projectile.terminate, BM.skill3_projectile_terminate)
  else
    projectile.height = BM.skill3_h2
    if skill.evo_rank and skill.evo_rank >= 3 then
      projectile.hit = override(projectile.hit, BM.skill3evohit)
    end
    projectile.terminate = override(projectile.terminate, BM.skill3_projectile2_terminate)
  end
  return projectile
end

function BM.skill3evohit(basefunc, tile, target)
  basefunc(tile, target)
  local caster = tile.caster
  local skill = tile.skill
  if skill.evo_rank and skill.evo_rank >= 3 then
    local bid = 10007408
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("ARM", -caster.attribs.STR * skill.evo_rank3["Script Arg1"] / 100)
    target:addBuff(buff, caster)
  end
end

function BM.update(basefunc, unit, dt)
  local animalEnterCountdown = unit.AnimalEnterCountdown
  if animalEnterCountdown then
    animalEnterCountdown = animalEnterCountdown - dt
    if animalEnterCountdown <= 0 then
      BM.callAnimals(unit.skillCallAnimals)
      animalEnterCountdown = nil
    end
    unit.AnimalEnterCountdown = animalEnterCountdown
  end
  basefunc(unit, dt)
end

function BM.die(basefunc, unit, killer)
  if unit.MyPig_BM and unit.MyPig_BM:isAlive() then
    BM.animal_discard(unit.MyPig_BM)
  end
  if unit.MyEagle_BM and unit.MyEagle_BM:isAlive() then
    BM.animal_discard(unit.MyEagle_BM)
  end
  basefunc(unit, killer)
end

function BM.skill4_createBuff(basefunc, skill, target)
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

function BM.init_hero(hero)
  hero.reset = override(hero.reset, BM.reset)
  local skillult = hero.skills[BM.name .. "_ult"]
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BM.ult_onAttackFrame)
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
  local skill2 = hero.skills[BM.name .. "_atk2"]
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
    skill2.canCastWithTarget = override(skill2.canCastWithTarget, BM.skill2_canCastWithTarget)
    skill2.takeEffectAt = override(skill2.takeEffectAt, BM.skill2_takeEffectAt)
  end
  local skill3 = hero.skills[BM.name .. "_atk3"]
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, BM.skill3_onAttackFrame)
    skill3.createProjectile = override(skill3.createProjectile, BM.skill3_createProjectile)
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
  local skill4 = hero.skills[BM.name .. "_atk4"]
  if skill4 then
    skill4.createBuff = override(skill4.createBuff, BM.skill4_createBuff)
  end
  hero.update = override(hero.update, BM.update)
  hero.die = override(hero.die, BM.die)
  return hero
end

return BM.init_hero
