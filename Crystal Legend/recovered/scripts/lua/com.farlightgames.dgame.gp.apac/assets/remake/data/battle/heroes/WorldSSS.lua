module("ed.battlehero", package.seeall)
local ed = ed
WorldSSS = {}
WorldSSS.mirror_time = 60
WorldSSS.ragelosthp = 35000
WorldSSS.rage2losthp = 15000
WorldSSS.stage2hp = 1750000
WorldSSS.stage2ragelosthp = 7500

function WorldSSS.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.skillatk5_casted = false
  local bid2 = 4572
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = hero:addBuff(binfo2, hero)
  buff2.update = override(buff2.update, WorldSSS.rage_buff_update)
  hero.lastrageStack = 0
  local bid3 = 4766
  local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
  hero:addBuff(binfo3, hero)
end

function WorldSSS.skillatk5_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  caster.Snake_lastcount = 5
  caster.Snake_previouscount = 0
  buff.update = override(buff.update, WorldSSS.skillatk5_Buff_update)
  local dir = caster:getInitDir()
  local xs = {
    -60,
    -30,
    0,
    30,
    60
  }
  local ys = {
    -60,
    -30,
    0,
    30,
    60
  }
  for i = 1, 5 do
    local proto = {
      _tid = 332,
      _level = 2000,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local WorldSSSSnake = ed.UnitCreate(proto, caster.camp, config)
    WorldSSSSnake.mDuration_WorldSSS = WorldSSS.mirror_time
    WorldSSSSnake.die = override(WorldSSSSnake.die, function(basefunc, unit, killer)
      if not ed.engine.running then
        unit:setDeathWithEffectOrNot(true)
      end
      if caster.Snake_lastcount then
        caster.Snake_lastcount = caster.Snake_lastcount - 1
      end
      basefunc(unit, killer)
    end)
    WorldSSSSnake.update = override(WorldSSSSnake.update, WorldSSS.WorldSSSSnake_update)
    WorldSSSSnake.rebuild = override(WorldSSSSnake.rebuild, WorldSSS.WorldSSSSnake_rebuild)
    WorldSSSSnake.getLostHPAfterImmunity = override(WorldSSSSnake.getLostHPAfterImmunity, WorldSSS.hero_getLostHPAfterImmunity)
    WorldSSSSnake:setDeathWithEffectOrNot(true)
    WorldSSSSnake.direction = caster.direction
    WorldSSSSnake.attribs.HP = 5
    WorldSSSSnake:setHP(5)
    local bid = 10040304
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, WorldSSSSnake, caster)
    WorldSSSSnake:addBuff(buff, caster)
    local locationWorldSSS
    locationWorldSSS = {
      400 + xs[i] * dir,
      0 + ys[i]
    }
    ed.engine:summonUnit(WorldSSSSnake, locationWorldSSS, caster)
    if caster.WorldSSSlist == nil then
      caster.WorldSSSlist = {}
    end
    table.insert(caster.WorldSSSlist, WorldSSSSnake)
  end
  return buff
end

function WorldSSS.skillatk5_Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  if caster.Snake_previouscount ~= caster.Snake_lastcount then
    buff:setAttribute("PIMU", math.max(8 * caster.Snake_lastcount, 0))
    buff:setAttribute("MIMU", math.max(8 * caster.Snake_lastcount, 0))
    owner:resetBuffApply(buff)
  end
  caster.Snake_previouscount = caster.Snake_lastcount
end

function WorldSSS.rage_buff_update(basefunc, buff, dt)
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

function WorldSSS.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk5 = hero.skills.WorldSSS_atk5
  if skillatk5 and not hero.skillatk5_casted then
    hero:addBuff(skillatk5:createBuff(hero), hero)
    hero.skillatk5_casted = true
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldSSS.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldSSS.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSSS.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldSSS.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSSS.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldSSS.WorldSSSSnake_update(basefunc, unit, dt)
  unit.mDuration_WorldSSS = unit.mDuration_WorldSSS - dt
  if unit.mDuration_WorldSSS <= 0 and unit:isAlive() then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function WorldSSS.createProjectile(basefunc, skill)
  local counter = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if 5 <= counter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function WorldSSS.skillatk4_onAttackFrame(basefunc, skill)
  local targetposition = skill.target.position
  basefunc(skill)
  if skill.target and skill.target:isAlive() and ed.run_with_scene then
    local effect_atk = "eff_point_SS_atk3.cha"
    local casterorigin = skill.target.position
    ed.scene:playEffectOnScene(effect_atk, casterorigin, {1, 1}, nil, 0)
  end
end

function WorldSSS.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  if skill.target then
    for i, tbuff in ipairs(skill.target.buff_list) do
      if tbuff.info.ID == 10040302 and tbuff.caster == skill.caster then
        local buff = tbuff
        buff.timer = 0.1
        break
      end
    end
  end
end

function WorldSSS.atk4_buff_onRemoved(basefunc, buff)
  local skillatk4 = buff.caster.skills.WorldSSS_atk4
  if buff.caster.current_skill and buff.caster.current_skill.info["Skill Name"] == "WorldSSS_atk4" then
    buff.caster.current_skill:interrupt()
  end
  basefunc(buff)
end

function WorldSSS.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldSSS.atk4_buff_onRemoved)
  return buff
end

function WorldSSS.skillatk4_takeEffectOn(basefunc, skill, target, source)
  local buff = false
  basefunc(skill, target, source)
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 10040302 then
      buff = true
      break
    end
  end
  if not buff and skill.caster.current_skill and skill.caster.current_skill.info["Skill Name"] == "WorldSSS_atk4" then
    skill.caster.current_skill:interrupt()
  end
end

function WorldSSS.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local dir = caster:getInitDir()
  local target = skill.target
  local skillult = caster.skills.WorldSSS_ult
  local xs = {
    -60,
    -30,
    0,
    30,
    60
  }
  local ys = {
    -60,
    -30,
    0,
    30,
    60
  }
  for i = 1, 5 do
    local proto = {
      _tid = 332,
      _level = 2000,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local WorldSSSSnake = ed.UnitCreate(proto, caster.camp, config)
    WorldSSSSnake.mDuration_WorldSSS = WorldSSS.mirror_time
    WorldSSSSnake.die = override(WorldSSSSnake.die, function(basefunc, unit, killer)
      if not ed.engine.running then
        unit:setDeathWithEffectOrNot(true)
      end
      if caster.Snake_lastcount then
        caster.Snake_lastcount = caster.Snake_lastcount - 1
      end
      basefunc(unit, killer)
    end)
    WorldSSSSnake.update = override(WorldSSSSnake.update, WorldSSS.WorldSSSSnake_update)
    WorldSSSSnake.rageStack = caster.rageStack
    WorldSSSSnake.rebuild = override(WorldSSSSnake.rebuild, WorldSSS.WorldSSSSnake_rebuild)
    WorldSSSSnake.getLostHPAfterImmunity = override(WorldSSSSnake.getLostHPAfterImmunity, WorldSSS.hero_getLostHPAfterImmunity)
    WorldSSSSnake:setDeathWithEffectOrNot(true)
    WorldSSSSnake.direction = caster.direction
    WorldSSSSnake.attribs.HP = 5
    WorldSSSSnake:setHP(5)
    local bid = 10040304
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, WorldSSSSnake, caster)
    WorldSSSSnake:addBuff(buff, caster)
    local locationWorldSSS
    locationWorldSSS = {
      target.position[1] + xs[i] * dir,
      target.position[2] + ys[i]
    }
    ed.engine:summonUnit(WorldSSSSnake, locationWorldSSS, caster)
    if caster.Snake_lastcount then
      caster.Snake_lastcount = caster.Snake_lastcount + 1
    end
    if caster.WorldSSSlist == nil then
      caster.WorldSSSlist = {}
    end
    table.insert(caster.WorldSSSlist, WorldSSSSnake)
  end
end

function WorldSSS.hero_die(basefunc, hero, killer)
  if hero.WorldSSSlist then
    for i, WorldSSSsnake in ipairs(hero.WorldSSSlist) do
      if WorldSSSsnake and WorldSSSsnake:isAlive() then
        WorldSSSsnake:die()
      end
    end
  end
  basefunc(hero, killer)
end

function WorldSSS.WorldSSSSnake_rebuild(basefunc, hero, mode, mealParam)
  basefunc(hero, mode, mealParam)
  hero.attribs.HP = 5
  if hero.rageStack then
    hero.attribs.AP = 500 + hero.rageStack ^ 0.9 * 300
  else
    hero.attribs.AP = 500
  end
end

function WorldSSS.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type)
  if damage_type == "AD" or damage_type == "Holy" then
    return 1
  else
    return 0
  end
end

function WorldSSS.init_hero(hero)
  hero.die = override(hero.die, WorldSSS.hero_die)
  local skillatk2 = hero.skills.WorldSSS_atk2
  local skillatk3 = hero.skills.WorldSSS_atk3
  local skillatk4 = hero.skills.WorldSSS_atk4
  local skillatk5 = hero.skills.WorldSSS_atk5
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldSSS.createProjectile)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, WorldSSS.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, WorldSSS.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, WorldSSS.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldSSS.skillatk4_takeEffectOn)
  end
  local skillult = hero.skills.WorldSSS_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, WorldSSS.skillult_takeEffectAt)
  end
  if skillatk5 then
    skillatk5.createBuff = override(skillatk5.createBuff, WorldSSS.skillatk5_createBuff)
  end
  hero.update = override(hero.update, WorldSSS.hero_update)
  hero.reset = override(hero.reset, WorldSSS.hero_reset)
  return hero
end

return WorldSSS.init_hero
