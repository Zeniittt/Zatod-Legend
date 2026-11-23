module("ed.battlehero", package.seeall)
local ed = ed
WorldSS = {}
WorldSS.mirror_time = 15
WorldSS.ragelosthp = 600000
WorldSS.stage2hp = 30000000
WorldSS.rage2losthp = 200000
WorldSS.stage2ragelosthp = 400000

function WorldSS.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.WorldSS_atk4
  if skillatk4 then
    local bid1 = 1625
    local binfo = ed.lookupDataTable("Buff", nil, bid1)
    hero:addBuff(binfo, hero)
  end
  local bid2 = 4572
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = hero:addBuff(binfo2, hero)
  buff2.update = override(buff2.update, WorldSS.rage_buff_update)
  hero.lastrageStack = 0
  local bid3 = 4766
  local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
  hero:addBuff(binfo3, hero)
end

function WorldSS.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
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

function WorldSS.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldSS.stage2hp and hero.hp - lost <= WorldSS.stage2hp then
    return hero.hp - WorldSS.stage2hp
  else
    return lost
  end
end

function WorldSS.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldSS.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldSS.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSS.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldSS.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSS.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldSS.WorldSSSnake_update(basefunc, unit, dt)
  unit.mDuration_WorldSS = unit.mDuration_WorldSS - dt
  if unit.mDuration_WorldSS <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function WorldSS.WorldSSSnake2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function WorldSS.createProjectile(basefunc, skill)
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

function WorldSS.skillatk4_onAttackFrame(basefunc, skill)
  local targetposition = skill.target.position
  basefunc(skill)
  if skill.target and skill.target:isAlive() and ed.run_with_scene then
    local effect_atk = "eff_point_SS_atk3.cha"
    local casterorigin = skill.target.position
    ed.scene:playEffectOnScene(effect_atk, casterorigin, {1, 1}, nil, 0)
  end
end

function WorldSS.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  if skill.target then
    for i, tbuff in ipairs(skill.target.buff_list) do
      if tbuff.info.ID == 6147 and tbuff.caster == skill.caster then
        local buff = tbuff
        buff.timer = 0.1
        break
      end
    end
  end
end

function WorldSS.atk4_buff_onRemoved(basefunc, buff)
  local skillatk4 = buff.caster.skills.WorldSS_atk4
  if buff.caster.current_skill and buff.caster.current_skill.info["Skill Name"] == "WorldSS_atk4" then
    buff.caster.current_skill:interrupt()
  end
  basefunc(buff)
end

function WorldSS.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldSS.atk4_buff_onRemoved)
  return buff
end

function WorldSS.skillatk4_takeEffectOn(basefunc, skill, target, source)
  local buff = false
  basefunc(skill, target, source)
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 6147 then
      buff = true
      break
    end
  end
  if not buff and skill.caster.current_skill and skill.caster.current_skill.info["Skill Name"] == "WorldSS_atk4" then
    skill.caster.current_skill:interrupt()
  end
end

function WorldSS.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.WorldSS_ult
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
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local WorldSSSnake1 = ed.UnitCreate(proto, caster.camp, config)
  WorldSSSnake1.mDuration_WorldSS = WorldSS.mirror_time
  WorldSSSnake1.update = override(WorldSSSnake1.update, WorldSS.WorldSSSnake_update)
  WorldSSSnake1:setDeathWithEffectOrNot(true)
  WorldSSSnake1.direction = caster.direction
  local WorldSSSnake2 = ed.UnitCreate(proto, caster.camp, config)
  WorldSSSnake2.mDuration_WorldSS = WorldSS.mirror_time
  WorldSSSnake2.update = override(WorldSSSnake2.update, WorldSS.WorldSSSnake_update)
  WorldSSSnake2:setDeathWithEffectOrNot(true)
  WorldSSSnake2.direction = caster.direction
  local WorldSSSnake3 = ed.UnitCreate(proto, caster.camp, config)
  WorldSSSnake3.mDuration_WorldSS = WorldSS.mirror_time
  WorldSSSnake3.update = override(WorldSSSnake3.update, WorldSS.WorldSSSnake_update)
  WorldSSSnake3:setDeathWithEffectOrNot(true)
  WorldSSSnake3.direction = caster.direction
  local WorldSSSnake4 = ed.UnitCreate(proto, caster.camp, config)
  WorldSSSnake4.mDuration_WorldSS = WorldSS.mirror_time
  WorldSSSnake4.update = override(WorldSSSnake4.update, WorldSS.WorldSSSnake_update)
  WorldSSSnake4:setDeathWithEffectOrNot(true)
  WorldSSSnake4.direction = caster.direction
  local bid = 299
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, WorldSSSnake1, caster)
  WorldSSSnake1:addBuff(buff, caster)
  local buff = ed.BuffCreate(binfo, WorldSSSnake2, caster)
  WorldSSSnake2:addBuff(buff, caster)
  local buff = ed.BuffCreate(binfo, WorldSSSnake3, caster)
  WorldSSSnake3:addBuff(buff, caster)
  local buff = ed.BuffCreate(binfo, WorldSSSnake4, caster)
  WorldSSSnake4:addBuff(buff, caster)
  local locationWorldSS1, locationWorldSS2, locationWorldSS3, locationWorldSS4
  locationWorldSS1 = {
    target.position[1] - WorldSSSnake3.direction * 30,
    target.position[2] + WorldSSSnake1.direction * 30
  }
  locationWorldSS2 = {
    target.position[1] + WorldSSSnake3.direction * 30,
    target.position[2] - WorldSSSnake2.direction * 30
  }
  locationWorldSS3 = {
    target.position[1] - WorldSSSnake3.direction * 60,
    target.position[2] - WorldSSSnake2.direction * 10
  }
  locationWorldSS4 = {
    target.position[1] + WorldSSSnake4.direction * 60,
    target.position[2] + WorldSSSnake1.direction * 10
  }
  ed.engine:summonUnit(WorldSSSnake1, locationWorldSS1, caster)
  if caster.WorldSSlist == nil then
    caster.WorldSSlist = {}
  end
  table.insert(caster.WorldSSlist, WorldSSSnake1)
  ed.engine:summonUnit(WorldSSSnake2, locationWorldSS2, caster)
  if caster.WorldSSlist == nil then
    caster.WorldSSlist = {}
  end
  table.insert(caster.WorldSSlist, WorldSSSnake2)
  ed.engine:summonUnit(WorldSSSnake3, locationWorldSS3, caster)
  if caster.WorldSSlist == nil then
    caster.WorldSSlist = {}
  end
  table.insert(caster.WorldSSlist, WorldSSSnake3)
  ed.engine:summonUnit(WorldSSSnake4, locationWorldSS4, caster)
  if caster.WorldSSlist == nil then
    caster.WorldSSlist = {}
  end
  table.insert(caster.WorldSSlist, WorldSSSnake4)
end

function WorldSS.hero_die(basefunc, hero, killer)
  if hero.WorldSSlist then
    for i, WorldSSsnake in ipairs(hero.WorldSSlist) do
      if WorldSSsnake and WorldSSsnake:isAlive() then
        WorldSSsnake:die()
      end
    end
  end
  basefunc(hero, killer)
end

function WorldSS.init_hero(hero)
  hero.die = override(hero.die, WorldSS.hero_die)
  local skillatk2 = hero.skills.WorldSS_atk2
  local skillatk3 = hero.skills.WorldSS_atk3
  local skillatk4 = hero.skills.WorldSS_atk4
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldSS.createProjectile)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, WorldSS.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, WorldSS.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, WorldSS.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldSS.skillatk4_takeEffectOn)
  end
  local skillult = hero.skills.WorldSS_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, WorldSS.skillult_takeEffectAt)
  end
  hero.update = override(hero.update, WorldSS.hero_update)
  hero.reset = override(hero.reset, WorldSS.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldSS.getLostHPAfterImmunity)
  return hero
end

return WorldSS.init_hero
