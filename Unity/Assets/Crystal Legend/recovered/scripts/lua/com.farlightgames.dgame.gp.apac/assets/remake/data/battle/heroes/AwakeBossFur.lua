module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossFur = {}
AwakeBossFur.UltPointEffect = "eff_point_Fur_ult.cha"
AwakeBossFur.UltImpactEffect = "eff_impact_Fur_ult.cha"
AwakeBossFur.HedgehogID = 200028
AwakeBossFur.jump_gap = 6400
AwakeBossFur.jump_max_range_sq = 360000
AwakeBossFur.percent = 0.35
AwakeBossFur.animalbuff = 12002404
AwakeBossFur.animalbuff_arm = 12002405

function AwakeBossFur.reset(basefunc, hero)
  basefunc(hero)
  local atk4 = hero.skills.AwakeBossFur_atk4
  if atk4 then
    hero.atk4_cast = true
  end
  hero.ori_camp = hero.camp
  hero.Battle_time = 0
  hero.AwakeBossFur_start = false
end

function AwakeBossFur.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Battle_time then
    hero.Battle_time = hero.Battle_time + dt
  else
    hero.Battle_time = 0
  end
  if not hero.AwakeBossFur_start then
    hero.AwakeBossFur_start = true
  end
  if hero.AwakeBossFur_start == true then
    hero.initAD = hero.attribs.AD
    hero.initAP = hero.attribs.AP
    hero.initARM = hero.attribs.ARM
    hero.initMR = hero.attribs.MR
  end
end

function AwakeBossFur.findNextTarget(basefunc, chain)
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
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - AwakeBossFur.jump_gap)
        if distanceSQ > min[2] then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < AwakeBossFur.jump_max_range_sq then
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  return ret
end

function AwakeBossFur.ult_chain_terminate(basefunc, chain)
  basefunc(chain)
  local skill = chain.skill
  skill.AwakeBossFurUltChain = nil
  skill.AwakeBossFurUltSetted = false
end

function AwakeBossFur.ult_createChain(basefunc, skill)
  local chain = basefunc(skill)
  skill.AwakeBossFurUltChain = chain
  skill.AwakeBossFurUltSetted = true
  chain.findNextTaeget = override(chain.findNextTaeget, AwakeBossFur.findNextTarget)
  chain.terminate = override(chain.terminate, AwakeBossFur.ult_chain_terminate)
  return chain
end

function AwakeBossFur.castManualSkill(basefunc, unit)
  basefunc(unit)
end

function AwakeBossFur.skillult_start(basefunc, skill, target)
  if ed.run_with_scene then
    local effect_name = AwakeBossFur.UltPointEffect
    local origin = {400, -50}
    ed.scene:playEffectOnScene(effect_name, origin, nil, nil, 1)
  end
  basefunc(skill, target)
end

function AwakeBossFur.ult_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  if skill.AwakeBossFurUltSetted then
    local index = skill.info["Chain Jumps"] - skill.AwakeBossFurUltChain.jumps_remaining - 1
    ret = ret * (1 + AwakeBossFur.percent * index)
  end
  return ret
end

function AwakeBossFur.ult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  if ed.run_with_scene then
    local effect_name = AwakeBossFur.UltImpactEffect
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

function AwakeBossFur.atk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  local xs = {60, 90}
  local ys = {-25, 5}
  if caster.position[1] <= -1000 or caster.position[1] >= 1400 then
    xs = {1920, 1950}
  end
  for i = 1, 2 do
    local proto = {
      _tid = AwakeBossFur.HedgehogID,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = 1
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
      basefunc(unit, killer)
    end)
    ed.engine:summonUnit(animal, animal_location, caster, "Birth")
    if not caster.animals then
      caster.animals = {}
    end
    table.insert(caster.animals, animal)
    local animalattribs = skill.info["Script Arg3"] / 100
    local AttriBinfo = ed.lookupDataTable("Buff", nil, AwakeBossFur.animalbuff)
    AwakeBossFur.changeBuffInfo(AttriBinfo, animalattribs, animal)
    local buffattribs = animal:addBuff(ed.copyTable(AttriBinfo), caster)
    local arm = skill.info["Script Arg4"] or 0
    local binfo = ed.lookupDataTable("Buff", nil, AwakeBossFur.animalbuff_arm)
    local buff = ed.BuffCreate(binfo, animal, caster)
    buff:setAttribute("ARM", arm)
    animal:addBuff(buff, caster)
    animal:takeHeal(animal.attribs.HP, "hp")
  end
end

function AwakeBossFur.changeBuffInfo(buffInfo, enhance, target)
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
      if name == "HP" and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function AwakeBossFur.die(basefunc, unit, killer)
  if unit.animals then
    for _, animal in ipairs(unit.animals) do
      if animal then
        animal:die()
      end
    end
  end
  basefunc(unit, killer)
end

function AwakeBossFur.atk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  return buff
end

function AwakeBossFur.atk4_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if basefunc(skill, target) and (hero.Battle_time and hero.Battle_time >= 30 or hero.hp < hero.attribs.HP * 0.4) and hero.atk4_cast then
    return true
  else
    return false
  end
end

function AwakeBossFur.atk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  caster.position = {
    400 - caster:getInitDir() * 2400,
    -20
  }
  caster.atk4_cast = false
  local bid = 10008002
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local atk4enhance = ed.BuffCreate(binfo, caster, caster)
  atk4enhance:setAttribute("AD", 0.1 * caster.initAD)
  atk4enhance:setAttribute("AP", 0.1 * caster.initAP)
  atk4enhance:setAttribute("ARM", 0.1 * caster.initARM)
  atk4enhance:setAttribute("MR", 0.1 * caster.initMR)
  caster:addBuff(atk4enhance, caster)
  basefunc(skill)
end

function AwakeBossFur.atk4_createBuff(basefunc, skill, target)
  local atk4buff = basefunc(skill, target)
  atk4buff.onRemoved = override(atk4buff.onRemoved, AwakeBossFur.atk4_buffOnRemoved)
  local caster = skill.caster
  caster.info["Walk Speed"] = 0
  return atk4buff
end

function AwakeBossFur.atk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk4b = caster.skills.AwakeBossFur_atk4b
  local position = caster.position
  if caster:isAlive() and skillatk4b then
    skillatk4b.cd_remaining = 0
    caster.global_cd = 0
    local bid = 12002403
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  caster.info["Walk Speed"] = 120
  caster.height = 0
  caster.position = {
    400 + caster:getInitDir() * 500,
    -10
  }
end

function AwakeBossFur.atk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12002406
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function AwakeBossFur.atk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12002406 then
      tbuff.timer = 0
    end
  end
end

function AwakeBossFur.atk4b_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12002403
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  caster:setPosition({
    400 - caster:getInitDir() * 300,
    -10
  })
end

function AwakeBossFur.atk4b_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12002403 then
      tbuff.timer = 0
    end
  end
end

function AwakeBossFur.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.AwakeBossFur_atk4
  local skillatk4b = caster.skills.AwakeBossFur_atk4b
  if skillatk4 and skillatk4.casting or skillatk4b and skillatk4b.casting then
    return false
  end
  return basefunc(skill, target)
end

function AwakeBossFur.init_hero(hero)
  if hero.name == "AwakeBossFur" then
    hero.reset = override(hero.reset, AwakeBossFur.reset)
    hero.update = override(hero.update, AwakeBossFur.update)
  end
  hero.die = override(hero.die, AwakeBossFur.die)
  local skillult = hero.skills.AwakeBossFur_ult
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, AwakeBossFur.skillult_canCastWithTarget)
    skillult.createChain = override(skillult.createChain, AwakeBossFur.ult_createChain)
    skillult.power = override(skillult.power, AwakeBossFur.ult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossFur.ult_takeEffectOn)
    skillult.start = override(skillult.start, AwakeBossFur.skillult_start)
    hero.castManualSkill = override(hero.castManualSkill, AwakeBossFur.castManualSkill)
  end
  local atk2 = hero.skills.AwakeBossFur_atk2
  if atk2 then
    atk2.onAttackFrame = override(atk2.onAttackFrame, AwakeBossFur.atk2_onAttackFrame)
  end
  local atk3 = hero.skills.AwakeBossFur_atk3
  if atk3 then
    atk3.createBuff = override(atk3.createBuff, AwakeBossFur.atk3_createBuff)
  end
  local atk4 = hero.skills.AwakeBossFur_atk4
  if atk4 then
    atk4.start = override(atk4.start, AwakeBossFur.atk4_start)
    atk4.finish = override(atk4.finish, AwakeBossFur.atk4_finish)
    atk4.canCastWithTarget = override(atk4.canCastWithTarget, AwakeBossFur.atk4_canCastWithTarget)
    atk4.onAttackFrame = override(atk4.onAttackFrame, AwakeBossFur.atk4_onAttackFrame)
    atk4.createBuff = override(atk4.createBuff, AwakeBossFur.atk4_createBuff)
  end
  local atk4b = hero.skills.AwakeBossFur_atk4b
  if atk4b then
    atk4b.start = override(atk4b.start, AwakeBossFur.atk4b_start)
    atk4b.finish = override(atk4b.finish, AwakeBossFur.atk4b_finish)
  end
  return hero
end

return AwakeBossFur.init_hero
