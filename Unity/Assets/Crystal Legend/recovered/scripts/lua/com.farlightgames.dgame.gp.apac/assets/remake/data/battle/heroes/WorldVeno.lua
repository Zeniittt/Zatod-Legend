module("ed.battlehero", package.seeall)
local ed = ed
WorldVeno = {}
WorldVeno.swagposition = {
  {100, 0}
}
WorldVeno.swag_radius = 66.66666666666667
WorldVeno.swag_ivyrange = WorldVeno.swag_radius / math.sqrt(2)
WorldVeno.Ydeviation = -20
WorldVeno.centerposition = {
  {
    WorldVeno.swag_radius,
    -WorldVeno.Ydeviation
  },
  {
    3 * WorldVeno.swag_radius,
    -WorldVeno.Ydeviation
  },
  {
    5 * WorldVeno.swag_radius,
    -WorldVeno.Ydeviation
  },
  {
    7 * WorldVeno.swag_radius,
    WorldVeno.Ydeviation
  },
  {
    9 * WorldVeno.swag_radius,
    WorldVeno.Ydeviation
  },
  {
    11 * WorldVeno.swag_radius,
    WorldVeno.Ydeviation
  }
}
WorldVeno.swag_maxlevel = 5
WorldVeno.ragelosthp = 600000
WorldVeno.rage2losthp = 200000
WorldVeno.stage2hp = 30000000
WorldVeno.stage2ragelosthp = 400000

function WorldVeno.add_swag_effect(swag, level)
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

function WorldVeno.remove_swag_effect(swag)
  if ed.run_with_scene and swag.effectlist then
    local z = -1
    ed.scene:removeEffect(swag.effectlist, z)
  end
end

function WorldVeno.check_dieinswag(ivy, Veno)
  local result
  for i, swag in ipairs(Veno.Veno_swaglist) do
    if swag.swag_Num == ivy.ivy_inswagNum then
      result = swag
    end
  end
  return result
end

function WorldVeno.swag_levelup(swag)
  if swag.swag_level < WorldVeno.swag_maxlevel then
    local swag_skillatk3 = swag.skills.Swag_atk3
    swag_skillatk3.target = swag
    local region = swag_skillatk3:createRegion()
    ed.engine:addRegion(region)
    local Veno = swag.config.summoner
    WorldVeno.remove_swag_effect(swag)
    WorldVeno.add_swag_effect(swag, swag.swag_level + 1)
    swag.swag_level = swag.swag_level + 1
  end
end

function WorldVeno.Ivy_summonNum(skill)
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
          local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, WorldVeno.centerposition[Num]))
          if unit.buffManager.invisible and unit.camp ~= caster.camp then
          elseif math.sqrt(distanceSQ) <= WorldVeno.swag_radius then
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

function WorldVeno.ivy_skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster.config.summoner
  local skillawake = caster.skills.WorldVeno_awake
  local have_awakebuff, buff534
  local result = basefunc(skill, target, source)
  skill.info["No Dodge"] = true
  if skillawake then
    local ratio = skillawake.info["Script Arg1"]
    local max = 99999999999999
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 1101 then
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
      local ratio = math.pow(1.05, buff534.awakebuff_count)
      local HPR = max < math.abs(originfo.HPR * ratio) and -1 * max or originfo.HPR * ratio
      buff534:setAttribute("HPR", HPR)
    end
  end
end

function WorldVeno.skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillawake = caster.skills.WorldVeno_awake
  local have_awakebuff, buff534
  local ratio = skillawake.info["Script Arg1"]
  local max = 999999999999999
  local result = basefunc(skill, target, source)
  if skillawake then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 1101 then
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
      local ratio = math.pow(1.05, buff534.awakebuff_count)
      local HPR = max < math.abs(originfo.HPR * ratio) and -1 * max or originfo.HPR * ratio
      buff534:setAttribute("HPR", HPR)
    end
  end
end

function WorldVeno.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.awakebuff_count = 0
  return buff
end

function WorldVeno.ivy_die(basefunc, ivy, killer)
  basefunc(ivy, killer)
  if not ed.engine.beingEnd then
    local Veno = ivy.config.summoner
    local Veno_skillatk2 = Veno.skills.WorldVeno_atk2
    local dir = Veno:getInitDir()
    Veno.Veno_filed_ivyamount[ivy.ivy_inswagNum] = Veno.Veno_filed_ivyamount[ivy.ivy_inswagNum] - 1
    local result = WorldVeno.check_dieinswag(ivy, Veno)
    if result then
      WorldVeno.swag_levelup(result)
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
        _stars = Veno.stars,
        _rank = Veno.rank
      }
      local config = {
        is_monster = true,
        estimate_rank = true,
        hp_mod = Veno.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or Veno.config.hp_mod,
        dps_mod = Veno.config.dps_mod or 1
      }
      local swag = ed.UnitCreate(proto, Veno.camp, config)
      swag.swag_level = 1
      swag:setDeathWithEffectOrNot(true)
      swag.direction = ivy.direction
      swag.swag_Num = ivy.ivy_inswagNum
      local swag_position = {
        WorldVeno.centerposition[ivy.ivy_inswagNum][1],
        WorldVeno.centerposition[ivy.ivy_inswagNum][2] * dir
      }
      swag:enterActionStageFromOneStage(1, 206)
      ed.engine:summonUnit(swag, swag_position, Veno)
      local bid = 531
      local binfo531 = ed.lookupDataTable("Buff", nil, bid)
      local buff = swag:addBuff(binfo531, swag)
      WorldVeno.add_swag_effect(swag, swag.swag_level, Veno)
      table.insert(Veno.Veno_swaglist, swag)
      local swag_skillatk2 = swag.skills.Swag_atk2
      swag_skillatk2.target = swag
      local region = swag_skillatk2:createRegion()
      ed.engine:addRegion(region)
    end
  end
end

function WorldVeno.flower_die(basefunc, flower, killer)
  local Veno = flower.config.summoner
  basefunc(flower, killer)
  Veno.Veno_Alive_flower = Veno.Veno_Alive_flower - 1
  flower.flower_inswag.swag_haveflower = nil
end

function WorldVeno.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.WorldVeno_atk2
  local dir = caster:getInitDir()
  local skillevel = {
    skillatk2.level,
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 244,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local ivy = ed.UnitCreate(proto, caster.camp, config)
  local bid = 1102
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ivy:addBuff(binfo, caster)
  ivy.die = override(ivy.die, WorldVeno.ivy_die)
  local ivy_skillatk = ivy.skills.WorldIvy_atk
  ivy_skillatk.takeEffectOn = override(ivy_skillatk.takeEffectOn, WorldVeno.ivy_skillatk_takeEffectOn)
  ivy.direction = caster.direction
  ivy.ivy_inswagNum = WorldVeno.Ivy_summonNum(skill)
  local ivy_randX = (ed.rand() * 2 - 1) * WorldVeno.swag_ivyrange
  local ivy_randY = (ed.rand() * 2 - 1) * 25
  local ivy_position = {
    WorldVeno.centerposition[ivy.ivy_inswagNum][1] + ivy_randX,
    WorldVeno.centerposition[ivy.ivy_inswagNum][2] + ivy_randY
  }
  ed.engine:summonUnit(ivy, ivy_position, caster)
  caster.Veno_filed_ivyamount[ivy.ivy_inswagNum] = caster.Veno_filed_ivyamount[ivy.ivy_inswagNum] + 1
  table.insert(caster.Veno_ivylist, ivy)
end

function WorldVeno.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if #caster.Veno_swaglist == 0 or #caster.Veno_swaglist <= caster.Veno_Alive_flower then
    result = nil
  end
  return result
end

function WorldVeno.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local swaglist_temp = {}
  local caster = skill.caster
  local skillatk3 = caster.skills.WorldVeno_atk3
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
  flower.die = override(flower.die, WorldVeno.flower_die)
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

function WorldVeno.Ultflower_skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    basefunc(skill)
  end
  if attack_counter == 1 then
    for i, swag in ipairs(caster.config.summoner.Veno_swaglist) do
      WorldVeno.swag_levelup(swag)
    end
  end
end

function WorldVeno.Ultflower_skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillult2 = caster.config.summoner.skills.WorldVeno_ult2
  if skillult2 then
    skillult2:takeEffectOn(target)
  end
end

function WorldVeno.Ultflower_skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die()
end

function WorldVeno.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.WorldVeno_ult
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
  Ultflower_skillult.finish = override(Ultflower_skillult.finish, WorldVeno.Ultflower_skillult_finish)
  Ultflower_skillult.onAttackFrame = override(Ultflower_skillult.onAttackFrame, WorldVeno.Ultflower_skillult_onAttackFrame)
  Ultflower_skillult.takeEffectOn = override(Ultflower_skillult.takeEffectOn, WorldVeno.Ultflower_skillult_takeEffectOn)
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

function WorldVeno.castManualSkill(basefunc, self)
  basefunc(self)
  if self.Ultflower then
    self.Ultflower:unfreeze()
  end
end

function WorldVeno.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if type(struct_table) == "table" then
    local caster = hero
    local skillawake = caster.skills.WorldVeno_awake
    local have_awakebuff, buff534
    local max = 10000000000000000
    local target
    local damagesource = struct_table.source
    if (damagesource and damagesource:isHero() or damagesource and damagesource.config.is_summoned) and lost and 0 <= lost and damagesource and skillawake then
      for i, tbuff in ipairs(damagesource.buff_list) do
        if tbuff.info.ID == 1101 then
          have_awakebuff = true
          buff534 = tbuff
        end
      end
      if have_awakebuff then
        buff534.awakebuff_count = buff534.awakebuff_count + 1
      end
      if not have_awakebuff then
        damagesource:addBuff(skillawake:createBuff(damagesource), caster)
      elseif have_awakebuff and max > math.abs(buff534.info.HPR) then
        local originfo = buff534.info
        local ratio = math.pow(1.05, buff534.awakebuff_count)
        local HPR = max < math.abs(originfo.HPR * ratio) and -1 * max or originfo.HPR * ratio
        buff534:setAttribute("HPR", HPR)
      end
    end
  end
  return lost
end

function WorldVeno.hero_die(basefunc, hero, killer)
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
      WorldVeno.remove_swag_effect(unit)
      unit:die()
    end
  end
  if hero.Ultflower and hero.Ultflower:isAlive() then
    hero.Ultflower:die()
  end
  basefunc(hero, killer)
end

function WorldVeno.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldVeno.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldVeno.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldVeno.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldVeno.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldVeno.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldVeno.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldVeno.stage2hp and hero.hp - lost <= WorldVeno.stage2hp then
    return hero.hp - WorldVeno.stage2hp
  else
    return lost
  end
end

function WorldVeno.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldVeno.rage_buff_update)
  hero.lastrageStack = 0
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

function WorldVeno.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.3)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.3)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.3)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.3)
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

function WorldVeno.init_hero(hero)
  local skillult = hero.skills.WorldVeno_ult
  local skillatk = hero.skills.WorldVeno_atk
  local skillatk2 = hero.skills.WorldVeno_atk2
  local skillatk3 = hero.skills.WorldVeno_atk3
  local skillawake = hero.skills.WorldVeno_awake
  hero.die = override(hero.die, WorldVeno.hero_die)
  hero.reset = override(hero.reset, WorldVeno.hero_reset)
  hero.takeDamage = override(hero.takeDamage, WorldVeno.hero_takeDamage)
  hero.update = override(hero.update, WorldVeno.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldVeno.getLostHPAfterImmunity)
  if skillult then
    skillult.start = override(skillult.start, WorldVeno.skillult_start)
    hero.castManualSkill = override(hero.castManualSkill, WorldVeno.castManualSkill)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldVeno.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldVeno.skillatk3_onAttackFrame)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, WorldVeno.skillatk3_canCastWithTarget)
  end
  if skillawake then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, WorldVeno.skillatk_takeEffectOn)
    skillawake.createBuff = override(skillawake.createBuff, WorldVeno.skillawake_createBuff)
  end
  return hero
end

return WorldVeno.init_hero
