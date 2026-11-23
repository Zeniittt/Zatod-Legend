module("ed.battlehero", package.seeall)
local ed = ed
Veno = {}
Veno.swagposition = {
  {100, 0}
}
Veno.swag_radius = 66.66666666666667
Veno.swag_ivyrange = Veno.swag_radius / math.sqrt(2)
Veno.Ydeviation = -20
Veno.centerposition = {
  {
    Veno.swag_radius,
    -Veno.Ydeviation
  },
  {
    3 * Veno.swag_radius,
    -Veno.Ydeviation
  },
  {
    5 * Veno.swag_radius,
    -Veno.Ydeviation
  },
  {
    7 * Veno.swag_radius,
    Veno.Ydeviation
  },
  {
    9 * Veno.swag_radius,
    Veno.Ydeviation
  },
  {
    11 * Veno.swag_radius,
    Veno.Ydeviation
  }
}
Veno.swag_maxlevel = 5

function Veno.add_swag_effect(swag, level)
  if ed.run_with_scene then
    local direction = swag:getInitDir()
    local origin = swag.position
    local effect_name = "eff_point_Veno_swag" .. level .. ".cha"
    if not effect_name then
      return
    end
    local effect_z = -1
    local swag_effect = ed.scene:playEffectOnScene(effect_name, origin, {direction, 1}, nil, effect_z)
    swag.effectlist = swag_effect
  end
end

function Veno.remove_swag_effect(swag)
  if ed.run_with_scene and swag.effectlist then
    local z = -1
    ed.scene:removeEffect(swag.effectlist, z)
  end
end

function Veno.check_dieinswag(ivy, Veno)
  local result
  for i, swag in ipairs(Veno.Veno_swaglist) do
    if swag.swag_Num == ivy.ivy_inswagNum then
      result = swag
    end
  end
  return result
end

function Veno.swag_levelup(swag)
  if swag.swag_level < Veno.swag_maxlevel then
    local swag_skillatk3 = swag.skills.Swag_atk3
    swag_skillatk3.target = swag
    local region = swag_skillatk3:createRegion()
    ed.engine:addRegion(region)
    Veno.remove_swag_effect(swag)
    Veno.add_swag_effect(swag, swag.swag_level + 1)
    swag.swag_level = swag.swag_level + 1
  end
end

function Veno.Ivy_summonNum(skill)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local dir = caster:getInitDir()
  local swagNum_temp = {}
  for Num = 3.5 - 2.5 * dir, 3.5 + 2.5 * dir, 1 * dir do
    if caster.Veno_filed_ivyamount[Num] < 2 then
      for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
        if unit.config.is_summoned then
        else
          local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, Veno.centerposition[Num]))
          if unit.buffManager.invisible and unit.camp ~= caster.camp then
          elseif math.sqrt(distanceSQ) <= Veno.swag_radius then
            count = count + 1
          end
        end
      end
      if dir == 1 and 1 <= count then
        if Num <= 3 then
          count = count + 9999
        end
      elseif dir == -1 and 1 <= count and 4 <= Num then
        count = count + 9999
      end
      if maxcount < count then
        maxcount = count
        x = Num
      end
      count = 0
    end
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return math.floor(ed.rand() * 6) + 1
  end
end

function Veno.ivy_skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster.config.summoner
  local skillawake = caster.skills.Veno_awake
  local have_awakebuff, buff534
  local result = basefunc(skill, target, source)
  if skillawake then
    local ratio = skillawake.info["Script Arg1"]
    local max = skillawake.info["Script Arg2"]
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 534 then
        have_awakebuff = true
        buff534 = tbuff
      end
    end
    if result and have_awakebuff then
      buff534.awakebuff_count = buff534.awakebuff_count + 1
    end
    if not have_awakebuff then
      target:addBuff(skillawake:createBuff(target), caster)
    elseif have_awakebuff and max > math.abs(buff534.info.HPR) then
      local originfo = buff534.info
      local ratio = math.pow(2, buff534.awakebuff_count)
      local HPR = max < math.abs(originfo.HPR * ratio) and -1 * max or originfo.HPR * ratio
      buff534:setAttribute("HPR", HPR)
      target:resetBuffApply(buff534)
    end
  end
end

function Veno.skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillawake = caster.skills.Veno_awake
  local have_awakebuff, buff534
  local ratio = skillawake.info["Script Arg1"]
  local max = skillawake.info["Script Arg2"]
  local result = basefunc(skill, target, source)
  if skillawake then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 534 then
        have_awakebuff = true
        buff534 = tbuff
      end
    end
    if result and have_awakebuff then
      buff534.awakebuff_count = buff534.awakebuff_count + 1
    end
    if not have_awakebuff then
      target:addBuff(skillawake:createBuff(target), caster)
    elseif have_awakebuff and max > math.abs(buff534.info.HPR) then
      local originfo = buff534.info
      local ratio = math.pow(2, buff534.awakebuff_count)
      local HPR = max < math.abs(originfo.HPR * ratio) and -1 * max or originfo.HPR * ratio
      buff534:setAttribute("HPR", HPR)
      target:resetBuffApply(buff534)
    end
  end
end

function Veno.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.awakebuff_count = 0
  return buff
end

function Veno.ivy_die(basefunc, ivy, killer)
  basefunc(ivy, killer)
  if not ed.engine.beingEnd then
    local hero = ivy.config.summoner
    local Veno_skillatk2 = hero.skills.Veno_atk2
    local ivy_skillatk2 = ivy.skills.Ivy_atk2
    local dir = hero:getInitDir()
    hero.Veno_filed_ivyamount[ivy.ivy_inswagNum] = hero.Veno_filed_ivyamount[ivy.ivy_inswagNum] - 1
    local result = Veno.check_dieinswag(ivy, hero)
    if result then
      Veno.swag_levelup(result)
    else
      local skillevel = {
        Veno_skillatk2.level,
        Veno_skillatk2.level,
        Veno_skillatk2.level,
        Veno_skillatk2.level,
        Veno_skillatk2.level
      }
      local proto = {
        _tid = 206,
        _level = Veno_skillatk2.level or 1,
        _skill_levels = skillevel,
        _stars = hero.stars,
        _rank = hero.rank
      }
      local config = {
        is_monster = true,
        estimate_rank = true,
        hp_mod = hero.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or hero.config.hp_mod,
        dps_mod = hero.config.dps_mod or 1
      }
      local swag = ed.UnitCreate(proto, hero.camp, config)
      swag.swag_level = 1
      swag:setDeathWithEffectOrNot(true)
      swag.direction = ivy.direction
      swag.swag_Num = ivy.ivy_inswagNum
      local swag_position = {
        Veno.centerposition[ivy.ivy_inswagNum][1],
        Veno.centerposition[ivy.ivy_inswagNum][2] * dir
      }
      swag:enterActionStageFromOneStage(1, 206)
      ed.engine:summonUnit(swag, swag_position, hero)
      local bid = 531
      local binfo531 = ed.lookupDataTable("Buff", nil, bid)
      local buff = swag:addBuff(binfo531, swag)
      Veno.add_swag_effect(swag, swag.swag_level, hero)
      table.insert(hero.Veno_swaglist, swag)
      local swag_skillatk2 = swag.skills.Swag_atk2
      swag_skillatk2.target = swag
      local region = swag_skillatk2:createRegion()
      ed.engine:addRegion(region)
    end
  end
end

function Veno.flower_die(basefunc, flower, killer)
  local Veno = flower.config.summoner
  basefunc(flower, killer)
  Veno.Veno_Alive_flower = Veno.Veno_Alive_flower - 1
  flower.flower_inswag.swag_haveflower = nil
end

function Veno.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.Veno_atk2
  local dir = caster:getInitDir()
  local skillevel = {
    skillatk2.level,
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 207,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local ivy = ed.UnitCreate(proto, caster.camp, config)
  ivy.die = override(ivy.die, Veno.ivy_die)
  local ivy_skillatk = ivy.skills.Ivy_atk
  ivy_skillatk.takeEffectOn = override(ivy_skillatk.takeEffectOn, Veno.ivy_skillatk_takeEffectOn)
  ivy.direction = caster.direction
  ivy.ivy_inswagNum = Veno.Ivy_summonNum(skill)
  local ivy_randX = (ed.rand() * 2 - 1) * Veno.swag_ivyrange
  local ivy_randY = (ed.rand() * 2 - 1) * 25
  local ivy_position = {
    Veno.centerposition[ivy.ivy_inswagNum][1] + ivy_randX,
    Veno.centerposition[ivy.ivy_inswagNum][2] + ivy_randY
  }
  ed.engine:summonUnit(ivy, ivy_position, caster)
  caster.Veno_filed_ivyamount[ivy.ivy_inswagNum] = caster.Veno_filed_ivyamount[ivy.ivy_inswagNum] + 1
  table.insert(caster.Veno_ivylist, ivy)
end

function Veno.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if #caster.Veno_swaglist == 0 or #caster.Veno_swaglist <= caster.Veno_Alive_flower then
    result = nil
  end
  return result
end

function Veno.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local swaglist_temp = {}
  local caster = skill.caster
  local skillatk3 = caster.skills.Veno_atk3
  local dir = caster:getInitDir()
  local skillevel = {
    skillatk3.level,
    skillatk3.level,
    skillatk3.level
  }
  local proto = {
    _tid = 211,
    _level = skillatk3.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local flower = ed.UnitCreate(proto, caster.camp, config)
  flower.die = override(flower.die, Veno.flower_die)
  flower.direction = caster.direction
  for i, swag in ipairs(caster.Veno_swaglist) do
    if swag.swag_haveflower == nil then
      table.insert(swaglist_temp, swag)
    end
  end
  local swag_amount = #swaglist_temp
  local inwhichswag_temp = math.floor(ed.rand() * swag_amount) + 1
  flower.flower_inswag = swaglist_temp[inwhichswag_temp]
  swaglist_temp[inwhichswag_temp].swag_haveflower = flower
  local flower_position = {
    flower.flower_inswag.position[1],
    flower.flower_inswag.position[2]
  }
  local bid = 532
  local binfo532 = ed.lookupDataTable("Buff", nil, bid)
  local buff = flower:addBuff(binfo532, flower)
  ed.engine:summonUnit(flower, flower_position, caster)
  table.insert(caster.Veno_flowerlist, flower)
  caster.Veno_Alive_flower = caster.Veno_Alive_flower + 1
  local flower_skillatk2 = flower.skills.Flower_atk2
  flower_skillatk2.target = flower
  local region = flower_skillatk2:createRegion()
  ed.engine:addRegion(region)
end

function Veno.Ultflower_skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    basefunc(skill)
  end
  if attack_counter == 1 then
    for i, swag in ipairs(caster.config.summoner.Veno_swaglist) do
      Veno.swag_levelup(swag)
    end
  end
end

function Veno.Ultflower_skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillult2 = caster.config.summoner.skills.Veno_ult2
  if skillult2 then
    skillult2:takeEffectOn(target)
  end
end

function Veno.Ultflower_skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die()
end

function Veno.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.Veno_ult
  local dir = caster:getInitDir()
  local skillevel = {
    skillult.level,
    skillult.level,
    skillult.level
  }
  local proto = {
    _tid = 212,
    _level = skillult.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local Ultflower = ed.UnitCreate(proto, caster.camp, config)
  local Ultflower_skillult = Ultflower.skills.Ultflower_atk
  Ultflower_skillult.finish = override(Ultflower_skillult.finish, Veno.Ultflower_skillult_finish)
  Ultflower_skillult.onAttackFrame = override(Ultflower_skillult.onAttackFrame, Veno.Ultflower_skillult_onAttackFrame)
  Ultflower_skillult.takeEffectOn = override(Ultflower_skillult.takeEffectOn, Veno.Ultflower_skillult_takeEffectOn)
  Ultflower.direction = caster.direction
  ed.engine:summonUnit(Ultflower, {400, 0}, caster)
  caster.Ultflower = Ultflower
  local bid = 533
  local binfo533 = ed.lookupDataTable("Buff", nil, bid)
  local buff = Ultflower:addBuff(binfo533, Ultflower)
  if 400 >= caster.position[1] then
    caster.direction = 1
  else
    caster.direction = -1
  end
  Ultflower:castSkill(Ultflower_skillult, nil)
end

function Veno.castManualSkill(basefunc, self)
  basefunc(self)
  if self.Ultflower then
    self.Ultflower:unfreeze()
  end
end

function Veno.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.Veno_ivylist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  for i, unit in ipairs(hero.Veno_flowerlist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  for i, unit in ipairs(hero.Veno_swaglist) do
    if unit and unit:isAlive() then
      Veno.remove_swag_effect(unit)
      unit:die()
    end
  end
  if hero.Ultflower and hero.Ultflower:isAlive() then
    hero.Ultflower:die()
  end
  basefunc(hero, killer)
end

function Veno.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Veno_swaglist = {}
  hero.Veno_flowerlist = {}
  hero.Veno_ivylist = {}
  hero.Veno_filed_ivyamount = {
    0,
    0,
    0,
    0,
    0,
    0
  }
  hero.Veno_effectlist = {}
  hero.Veno_Alive_flower = 0
end

function Veno.init_hero(hero)
  local skillult = hero.skills.Veno_ult
  local skillatk = hero.skills.Veno_atk
  local skillatk2 = hero.skills.Veno_atk2
  local skillatk3 = hero.skills.Veno_atk3
  local skillawake = hero.skills.Veno_awake
  hero.die = override(hero.die, Veno.hero_die)
  hero.reset = override(hero.reset, Veno.hero_reset)
  if skillult then
    skillult.start = override(skillult.start, Veno.skillult_start)
    hero.castManualSkill = override(hero.castManualSkill, Veno.castManualSkill)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Veno.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Veno.skillatk3_onAttackFrame)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Veno.skillatk3_canCastWithTarget)
  end
  if skillawake then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Veno.skillatk_takeEffectOn)
    skillawake.createBuff = override(skillawake.createBuff, Veno.skillawake_createBuff)
  end
  return hero
end

return Veno.init_hero
