module("ed.battlehero", package.seeall)
local ed = ed
WorldFur = {}
WorldFur.UltPointEffect = "eff_point_Fur_ult.cha"
WorldFur.UltImpactEffect = "eff_impact_Fur_ult.cha"
WorldFur.HedgehogID = 174
WorldFur.jump_gap = 6400
WorldFur.jump_max_range_sq = 360000
WorldFur.percent = 0.35
WorldFur.animalbuff_attr = 10040202
WorldFur.ragelosthp = 35000
WorldFur.rage2losthp = 15000
WorldFur.stage2hp = 1750000
WorldFur.stage2ragelosthp = 7500

function WorldFur.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldFur.rage_buff_update)
  hero.lastrageStack = 0
  local atk4 = hero.skills.WorldFur_atk4
  if atk4 then
    hero:addBuff(atk4:createBuff(hero), hero)
  end
end

function WorldFur.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldFur.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldFur.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldFur.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldFur.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldFur.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldFur.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldFur.findNextTarget(basefunc, chain)
  local self = chain
  local min = {
    math.huge,
    math.huge
  }
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif self.skill.caster.buff_effects.derangedOwner and unit.buff_effects.derangedOwner then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    else
      local times = self.affect_times[unit] or 0
      if 0 < times then
      elseif times > min[1] then
      else
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - WorldFur.jump_gap)
        if distanceSQ > min[2] then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < WorldFur.jump_max_range_sq then
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  return ret
end

function WorldFur.ult_chain_terminate(basefunc, chain)
  basefunc(chain)
  local skill = chain.skill
  skill.FurUltChain = nil
  skill.FurUltSetted = false
end

function WorldFur.ult_createChain(basefunc, skill)
  local chain = basefunc(skill)
  skill.FurUltChain = chain
  skill.FurUltSetted = true
  chain.findNextTaeget = override(chain.findNextTaeget, WorldFur.findNextTarget)
  chain.terminate = override(chain.terminate, WorldFur.ult_chain_terminate)
  return chain
end

function WorldFur.castManualSkill(basefunc, unit)
  basefunc(unit)
  if unit.current_skill == unit.manual_skill and ed.run_with_scene then
    local effect_name = WorldFur.UltPointEffect
    local origin = {400, -50}
    ed.scene:playEffectOnScene(effect_name, origin, nil, nil, 1)
  end
end

function WorldFur.ult_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  if skill.FurUltSetted then
    local index = skill.info["Chain Jumps"] - skill.FurUltChain.jumps_remaining - 1
    ret = ret * (1 + WorldFur.percent * index)
  end
  return ret
end

function WorldFur.ult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  if ed.run_with_scene then
    local effect_name = WorldFur.UltImpactEffect
    if not effect_name then
      return
    end
    local effect_z = 0
    local origin = {
      target.position[1],
      target.position[2] - 1
    }
    ed.scene:playEffectOnScene(effect_name, origin, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
end

function WorldFur.atk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  local xs = {
    30,
    45,
    60,
    75
  }
  local ys = {
    -25,
    -5,
    10,
    25
  }
  for i = 1, 4 do
    local proto = {
      _tid = WorldFur.HedgehogID,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.config.hp_mod or 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local animal = ed.UnitCreate(proto, caster.camp, config)
    animal.direction = caster.direction
    local animal_location = {
      caster.position[1] + xs[i] * dir,
      caster.position[2] + ys[i]
    }
    if caster.position[1] < 0 or caster.position[1] > 800 and caster.ori_camp then
      animal_location = {
        400 - caster.ori_camp * 400 - caster.ori_camp * 75,
        ys[i]
      }
    end
    animal:reset()
    animal.die = override(animal.die, function(basefunc, unit, killer)
      if not ed.engine.running then
        unit:setDeathWithEffectOrNot(true)
      end
      if caster.animal_lastcount then
        caster.animal_lastcount = caster.animal_lastcount - 1
      end
      basefunc(unit, killer)
    end)
    ed.engine:summonUnit(animal, animal_location, caster, "Birth")
    if caster.animal_lastcount then
      caster.animal_lastcount = caster.animal_lastcount + 1
    end
    if not caster.animals then
      caster.animals = {}
    end
    table.insert(caster.animals, animal)
    local enhance_index = caster.rageStack
    local binfo = ed.lookupDataTable("Buff", nil, WorldFur.animalbuff_attr)
    local buff = ed.BuffCreate(binfo, animal, caster)
    buff:setAttribute("HP", 4000 * (enhance_index + 1) ^ 0.8)
    buff:setAttribute("AD", 500 * (enhance_index + 1) ^ 0.8)
    buff:setAttribute("AP", 300 * (enhance_index + 1) ^ 0.8)
    buff:setAttribute("ARM", 50 * (enhance_index + 1) ^ 1.05)
    buff:setAttribute("MR", 10 * (enhance_index + 1) ^ 1.05)
    animal:addBuff(buff, caster)
    animal:takeHeal(animal.attribs.HP, "hp")
  end
end

function WorldFur.die(basefunc, unit, killer)
  if unit.animals then
    for _, animal in ipairs(unit.animals) do
      if animal then
        animal:die()
      end
    end
  end
  basefunc(unit, killer)
end

function WorldFur.atk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  return buff
end

function WorldFur.atk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.update = override(buff.update, WorldFur.skillatk4_buff_update)
  caster.animal_lastcount = 0
  caster.animal_previouscount = 0
  return buff
end

function WorldFur.skillatk4_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  if caster.animal_previouscount ~= caster.animal_lastcount then
    buff:setAttribute("PIMU", math.max(10 * caster.animal_lastcount, 0))
    buff:setAttribute("MIMU", math.max(10 * caster.animal_lastcount, 0))
    owner:resetBuffApply(buff)
  end
  caster.animal_previouscount = caster.animal_lastcount
end

function WorldFur.init_hero(hero)
  hero.reset = override(hero.reset, WorldFur.reset)
  hero.update = override(hero.update, WorldFur.update)
  hero.die = override(hero.die, WorldFur.die)
  local skillult = hero.skills.WorldFur_ult
  if skillult then
    skillult.createChain = override(skillult.createChain, WorldFur.ult_createChain)
    skillult.power = override(skillult.power, WorldFur.ult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldFur.ult_takeEffectOn)
    hero.castManualSkill = override(hero.castManualSkill, WorldFur.castManualSkill)
  end
  local atk2 = hero.skills.WorldFur_atk2
  if atk2 then
    atk2.onAttackFrame = override(atk2.onAttackFrame, WorldFur.atk2_onAttackFrame)
  end
  local atk3 = hero.skills.WorldFur_atk3
  if atk3 then
    atk3.createBuff = override(atk3.createBuff, WorldFur.atk3_createBuff)
  end
  local atk4 = hero.skills.WorldFur_atk4
  if atk4 then
    atk4.createBuff = override(atk4.createBuff, WorldFur.atk4_createBuff)
  end
  return hero
end

return WorldFur.init_hero
