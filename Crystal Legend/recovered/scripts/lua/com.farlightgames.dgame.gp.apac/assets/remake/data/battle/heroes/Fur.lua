module("ed.battlehero", package.seeall)
local ed = ed
Fur = {}
Fur.UltPointEffect = "eff_point_Fur_ult.cha"
Fur.UltImpactEffect = "eff_impact_Fur_ult.cha"
Fur.HedgehogID = 174
Fur.jump_gap = 6400
Fur.jump_max_range_sq = 360000
Fur.percent = 0.35
Fur.animalbuff = 10008004
Fur.animalbuff_arm = 10008005

function Fur.reset(basefunc, hero)
  basefunc(hero)
  local atk4 = hero.skills.Fur_atk4
  if atk4 then
    hero.atk4_cast = true
  end
  hero.ori_camp = hero:getInitDir()
  hero.Battle_time = 0
end

function Fur.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Battle_time then
    hero.Battle_time = hero.Battle_time + dt
  else
    hero.Battle_time = 0
  end
end

function Fur.findNextTarget(basefunc, chain)
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
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - Fur.jump_gap)
        if distanceSQ > min[2] then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < Fur.jump_max_range_sq then
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  return ret
end

function Fur.ult_chain_terminate(basefunc, chain)
  basefunc(chain)
  local skill = chain.skill
  skill.FurUltChain = nil
  skill.FurUltSetted = false
end

function Fur.ult_createChain(basefunc, skill)
  local chain = basefunc(skill)
  skill.FurUltChain = chain
  skill.FurUltSetted = true
  chain.findNextTaeget = override(chain.findNextTaeget, Fur.findNextTarget)
  chain.terminate = override(chain.terminate, Fur.ult_chain_terminate)
  return chain
end

function Fur.castManualSkill(basefunc, unit)
  basefunc(unit)
  if unit.current_skill == unit.manual_skill and ed.run_with_scene then
    local effect_name = Fur.UltPointEffect
    local origin = {400, -50}
    ed.scene:playEffectOnScene(effect_name, origin, nil, nil, 1)
  end
end

function Fur.ult_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  if skill.FurUltSetted then
    local index = skill.info["Chain Jumps"] - skill.FurUltChain.jumps_remaining - 1
    ret = ret * (1 + Fur.percent * index)
  end
  return ret
end

function Fur.ult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  if ed.run_with_scene then
    local effect_name = Fur.UltImpactEffect
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

function Fur.atk2_onAttackFrame(basefunc, skill)
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
      _tid = Fur.HedgehogID,
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
    if skill.evo_rank and 1 <= skill.evo_rank then
      animalattribs = animalattribs + skill.evo_rank1["Script Arg1"] / 100
    end
    if skill.evo_rank and 2 <= skill.evo_rank then
      animalattribs = animalattribs + skill.evo_rank2["Script Arg1"] / 100
    end
    if skill.evo_rank and skill.evo_rank >= 3 then
      animalattribs = animalattribs + skill.evo_rank3["Script Arg1"] / 100
    end
    local AttriBinfo = ed.lookupDataTable("Buff", nil, Fur.animalbuff)
    Fur.changeBuffInfo(AttriBinfo, animalattribs, animal)
    local buffattribs = animal:addBuff(ed.copyTable(AttriBinfo), caster)
    local arm = skill.info["Script Arg4"] or 0
    local binfo = ed.lookupDataTable("Buff", nil, Fur.animalbuff_arm)
    local buff = ed.BuffCreate(binfo, animal, caster)
    buff:setAttribute("ARM", arm)
    animal:addBuff(buff, caster)
    animal:takeHeal(animal.attribs.HP, "hp")
  end
end

function Fur.changeBuffInfo(buffInfo, enhance, target)
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

function Fur.die(basefunc, unit, killer)
  if unit.animals then
    for _, animal in ipairs(unit.animals) do
      if animal then
        animal:die()
      end
    end
  end
  basefunc(unit, killer)
end

function Fur.atk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local timer = buff.timer
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = timer + skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Fur.atk4_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if basefunc(skill, target) and (hero.Battle_time and hero.Battle_time >= 30 or hero.hp < hero.attribs.HP * 0.4) and hero.atk4_cast then
    return true
  else
    return false
  end
end

function Fur.atk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  caster.position = {
    400 - caster:getInitDir() * 2400,
    -20
  }
  caster.atk4_cast = false
  basefunc(skill)
  local atk4 = caster.skills.Fur_atk4
  local atk = caster.skills.Fur_atk
  atk.oriinfo = atk.info
  local bid = 10008002
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local atk4enhance = ed.BuffCreate(binfo, caster, caster)
  if atk4.evo_rank and atk4.evo_rank >= 1 then
    atk.info = ed.wraptable(atk.info, {
      ["Damage Type"] = "AP",
      ["Plus Attr"] = "AP",
      ["Plus Ratio"] = atk4.evo_rank1["Script Arg1"]
    })
  end
  if atk4.evo_rank and atk4.evo_rank >= 2 then
    atk.info = ed.wraptable(atk.info, {
      CD = 1,
      ["Global CD"] = 0
    })
  end
  if atk4.evo_rank and atk4.evo_rank >= 3 then
    atk4enhance:setAttribute("AP", atk4.evo_rank3["Script Arg1"] * 0.01 * caster.attribs.AP)
  end
  atk4enhance.onRemoved = override(atk4enhance.onRemoved, Fur.atk4enhance_buffOnRemoved)
  caster:addBuff(atk4enhance, caster)
end

function Fur.atk4enhance_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local atk = caster.skills.Fur_atk
  atk.info = atk.oriinfo
end

function Fur.atk4_createBuff(basefunc, skill, target)
  local atk4buff = basefunc(skill, target)
  atk4buff.onRemoved = override(atk4buff.onRemoved, Fur.atk4_buffOnRemoved)
  local hpr = atk4buff.info.HPR
  local caster = skill.caster
  caster.info["Walk Speed"] = 0
  return atk4buff
end

function Fur.atk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk4b = caster.skills.Fur_atk4b
  local position = caster.position
  if caster:isAlive() and skillatk4b then
    skillatk4b.cd_remaining = 0
    caster.global_cd = 0
    local bid = 10008006
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

function Fur.atk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 10008006
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function Fur.atk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10008006 then
      tbuff.timer = 0
    end
  end
end

function Fur.atk4b_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster:setPosition({
    400 - caster:getInitDir() * 300,
    -10
  })
end

function Fur.atk4b_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10008006 then
      tbuff.timer = 0
    end
  end
end

function Fur.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.Fur_atk4
  local skillatk4b = caster.skills.Fur_atk4b
  if skillatk4 and skillatk4.casting or skillatk4b and skillatk4b.casting then
    return false
  end
  return basefunc(skill, target)
end

function Fur.init_hero(hero)
  if hero.name == "Fur" then
    hero.reset = override(hero.reset, Fur.reset)
    hero.update = override(hero.update, Fur.update)
  end
  hero.die = override(hero.die, Fur.die)
  local skillult = hero.skills.Fur_ult
  if skillult then
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
      skillult.info = ed.wraptable(skillult.info, {
        ["Chain Jumps"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Fur.skillult_canCastWithTarget)
    skillult.createChain = override(skillult.createChain, Fur.ult_createChain)
    skillult.power = override(skillult.power, Fur.ult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Fur.ult_takeEffectOn)
    hero.castManualSkill = override(hero.castManualSkill, Fur.castManualSkill)
  end
  local atk2 = hero.skills.Fur_atk2
  if atk2 then
    atk2.onAttackFrame = override(atk2.onAttackFrame, Fur.atk2_onAttackFrame)
  end
  local atk3 = hero.skills.Fur_atk3
  if atk3 then
    if atk3.evo_rank and atk3.evo_rank >= 1 then
      atk3.info = ed.wraptable(atk3.info, {
        ["Plus Ratio"] = atk3.evo_rank1["Script Arg1"]
      })
    end
    if atk3.evo_rank and atk3.evo_rank >= 2 then
      atk3.info = ed.wraptable(atk3.info, {
        ["Plus Ratio"] = atk3.evo_rank2["Script Arg1"]
      })
    end
    atk3.createBuff = override(atk3.createBuff, Fur.atk3_createBuff)
  end
  local atk4 = hero.skills.Fur_atk4
  if atk4 then
    atk4.start = override(atk4.start, Fur.atk4_start)
    atk4.finish = override(atk4.finish, Fur.atk4_finish)
    atk4.canCastWithTarget = override(atk4.canCastWithTarget, Fur.atk4_canCastWithTarget)
    atk4.onAttackFrame = override(atk4.onAttackFrame, Fur.atk4_onAttackFrame)
    atk4.createBuff = override(atk4.createBuff, Fur.atk4_createBuff)
  end
  local atk4b = hero.skills.Fur_atk4b
  if atk4b then
    atk4b.start = override(atk4b.start, Fur.atk4b_start)
    atk4b.finish = override(atk4b.finish, Fur.atk4b_finish)
  end
  return hero
end

return Fur.init_hero
