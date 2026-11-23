module("ed.battlehero", package.seeall)
local ed = ed
WorldLYC = {}
WorldLYC.blink_distance = 70
WorldLYC.ragelosthp = 35000
WorldLYC.rage2losthp = 15000
WorldLYC.stage2hp = 1750000
WorldLYC.stage2ragelosthp = 7500

function WorldLYC.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_Luna_night.cha"
    local origin = {400, 0}
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end

function WorldLYC.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  local xs = {60, 90}
  local ys = {-25, 5}
  for i = 1, 2 do
    local proto = {
      _tid = 369,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = caster.original_mod or 1
    }
    local animal = ed.UnitCreate(proto, caster.camp, config)
    animal.direction = caster.direction
    local animal_location = {
      caster.position[1] + xs[i] * dir,
      caster.position[2] + ys[i]
    }
    animal:reset()
    animal.die = override(animal.die, function(basefunc, unit, killer)
      if not ed.engine.running then
        unit:setDeathWithEffectOrNot(true)
      end
      local summoner = unit.config.summoner
      if summoner.wolfcount and summoner.wolfcount >= 1 then
        summoner.wolfcount = summoner.wolfcount - 1
      else
        caster.wolfcount = 0
      end
      basefunc(unit, killer)
    end)
    ed.engine:summonUnit(animal, animal_location, caster, "Birth")
    if caster.wolfcount and caster.wolfcount >= 0 then
      caster.wolfcount = caster.wolfcount + 1
    else
      caster.wolfcount = 0
    end
    if not caster.animals then
      caster.animals = {}
    end
    table.insert(caster.animals, animal)
    local animalattribs = 0.35
    local AttriBinfo = ed.lookupDataTable("Buff", nil, 10036801)
    WorldLYC.changeBuffInfo(AttriBinfo, animalattribs, animal, caster.rageStack or 1)
    local buffattribs = animal:addBuff(ed.copyTable(AttriBinfo), caster)
    animal:takeHeal(animal.attribs.HP, "hp")
  end
end

function WorldLYC.changeBuffInfo(buffInfo, enhance, target, rage)
  local attrib_temp = {}
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
    end
  end
  buffInfo.HP = 2500 + (rage - 1) * 2000
end

function WorldLYC.skillatk4_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 3 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 400,
      ["Shape Arg2"] = 200,
      ["AOE Shape"] = "rectangle",
      ["Plus Ratio"] = 0.7,
      ["Max Range"] = 400
    })
    skill.max_range_sq = 160000
    basefunc(skill)
    skill.info = originfo
    skill.max_range_sq = 19600
  else
    basefunc(skill)
  end
end

function WorldLYC.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 339 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function WorldLYC.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local owner = skill.caster
    local bid = 339
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, owner)
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    local target = skill.target
    target = target or skill:selectTarget(nil)
    skill.attack_counter = skill.attack_counter + 1
    local caster = skill.caster
    if target then
      local direction = 0 < target.position[1] - caster.position[1] and 1 or -1
      local position1 = target.position[1] - direction * WorldLYC.blink_distance
      if target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 - 2 * direction * WorldLYC.blink_distance
      end
      caster.position = {
        position1,
        target.position[2]
      }
    end
  else
    basefunc(skill)
  end
end

function WorldLYC.reset(basefunc, unit)
  basefunc(unit)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = unit:addBuff(binfo, unit)
  buff.update = override(buff.update, WorldLYC.rage_buff_update)
  unit.lastrageStack = 0
  unit.wolfcount = 0
  unit.original_mod = unit.config.dps_mod
  unit.total_dmg = 0
end

function WorldLYC.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.05)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.05)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
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

function WorldLYC.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldLYC.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldLYC.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLYC.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldLYC.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLYC.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
  if not hero.lastwolfcount then
    hero.lastwolfcount = hero.wolfcount
  end
  if hero.lastwolfcount ~= hero.wolfcount then
    hero.config.dps_mod = hero.original_mod * (1 + hero.wolfcount * 0.15)
    hero.lastwolfcount = hero.wolfcount
  end
  if hero.total_dmg and hero.total_dmg >= 10000 * (hero.rageStack * 0.2 + 0.5) then
    hero.total_dmg = 0
    local binfo
    local bid = 10036803
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function WorldLYC.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if dmg and caster.total_dmg then
    caster.total_dmg = caster.total_dmg + dmg
  end
  return ret, dmg
end

function WorldLYC.init_hero(hero)
  hero.update = override(hero.update, WorldLYC.hero_update)
  hero.reset = override(hero.reset, WorldLYC.reset)
  local skillatk = hero.skills.WorldLYC_atk
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, WorldLYC.skillatk_takeEffectOn)
  end
  local skillatk2 = hero.skills.WorldLYC_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, WorldLYC.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldLYC.skillatk2_onAttackFrame)
  end
  local skillatk3 = hero.skills.WorldLYC_atk3
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldLYC.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, WorldLYC.skillatk3_finish)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldLYC.skillatk_takeEffectOn)
  end
  local skillatk4 = hero.skills.WorldLYC_atk4
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, WorldLYC.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldLYC.skillatk_takeEffectOn)
  end
  return hero
end

return WorldLYC.init_hero
