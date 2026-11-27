module("ed.battlehero", package.seeall)
local ed = ed
WorldFlood = {}
WorldFlood.acceleration = 1000
WorldFlood.totalTime = 1.4
WorldFlood.ragelosthp = 600000
WorldFlood.stage2hp = 30000000
WorldFlood.rage2losthp = 200000
WorldFlood.stage2ragelosthp = 400000

function WorldFlood.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldFlood.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldFlood.rage_buff_update(basefunc, buff, dt)
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

function WorldFlood.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 450 * caster:getInitDir()
  local distance = 300
  local time = skill.phase_list[1].event_list[1].Time
  local v = caster:getInitDir() * distance / time
  caster.walk_v = {v, 0}
end

function WorldFlood.skillatk4_onAttackFrame(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  basefunc(skill)
end

function WorldFlood.projectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  local target = projectile.track_target
  if target then
    if not target:isAlive() then
      projectile.track_target = nil
    end
    if target.buff_effects.untargetable then
      projectile.track_target = nil
    end
    if target.buffManager.invisible and target.camp ~= projectile.skill.caster.camp then
      projectile.track_target = nil
    end
  end
  projectile.previous_position = {
    projectile.position[1],
    projectile.position[2]
  }
  ed.Entity.update(projectile, dt)
  local info = projectile.skill.info
  local h = projectile.height
  local ott = info["Tile OTT Height"]
  local aoe = projectile.skill.info["AOE Origin"]
  if ott == 0 or h < ott then
    local firstTime = 1
    local firstUnit
    local piercing = info["Tile Piercing"]
    for unit in ed.engine:foreachAliveUnit(projectile.affect_camp) do
      if piercing and projectile.affect_times[unit] then
      else
        local collide = projectile:collideCheck(unit)
        if not collide then
        elseif piercing then
          projectile:hit(unit)
        elseif firstTime > collide then
          firstTime = collide
          firstUnit = unit
        end
      end
    end
    if firstUnit then
      projectile:hit(firstUnit)
      projectile:terminate()
    end
  end
  if not projectile.pTarget then
    projectile:terminate()
    return
  end
  local target = projectile.pTarget
  local x = target.position[1] - projectile.position[1]
  local y = target.position[2] - projectile.position[2]
  local u = (x ^ 2 + y ^ 2) ^ (-0.5)
  local ax = WorldFlood.acceleration * x * u
  local ay = WorldFlood.acceleration * y * u
  projectile.velocity[1] = projectile.velocity[1] + ax * dt
  projectile.velocity[2] = projectile.velocity[2] + ay * dt
  if 0 > projectile.flyingTime then
    if target and target:isAlive() then
      projectile:hit(target)
    end
    projectile:terminate()
  end
  projectile.flyingTime = projectile.flyingTime - dt
end

function WorldFlood.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local shape = "circle"
  local arg1 = 800
  local arg2 = 0
  if attack_counter == 0 then
    skill.info = ed.wraptable(originfo, {
      ["Target Type"] = "target",
      ["Target Camp"] = -1,
      ["Affected Camp"] = -1,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = shape,
      ["Shape Arg1"] = arg1,
      ["Shape Arg2"] = arg2,
      ["Impact Effect"] = "eff_impact_Flood_ult.cha"
    })
    basefunc(skill)
    skill.info = originfo
  else
    skill.info = ed.wraptable(originfo, {
      ["Target Type"] = "target",
      ["Target Camp"] = -1,
      ["Affected Camp"] = -1,
      ["AOE Origin"] = "self",
      ["AOE Shape"] = shape,
      ["Shape Arg1"] = arg1,
      ["Shape Arg2"] = arg2
    })
    basefunc(skill)
    skill.info = originfo
    for unit in ed.engine:foreachAliveUnit(1) do
      if unit.FloodDmg and unit.camp ~= caster.camp then
        local projectile = skill:createProjectile()
        projectile.healNumber = unit.FloodDmg
        projectile:enableTrack(caster)
        projectile.position = {
          unit.position[1],
          unit.position[2] - 2
        }
        projectile.height = 30
        projectile.velocity[1] = math.floor(ed.rand() * 200) + 101 * caster.direction
        projectile.velocity[2] = math.floor(ed.rand() * 200) + 1
        projectile.zSpeed = 0
        projectile.pTarget = caster
        projectile.flyingTime = WorldFlood.totalTime
        projectile.update = override(projectile.update, WorldFlood.projectile_update)
        ed.engine:addProjectile(projectile)
        unit.FloodDmg = nil
      end
    end
  end
end

function WorldFlood.skillult_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local attack_counter = skill.attack_counter
  local dmg = 0
  if attack_counter == 1 then
    dmg = basefunc(skill, target, 0.1 * power, damage_type, field, source, crit_mod)
  else
    dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  end
  if target.FloodDmg then
    target.FloodDmg = target.FloodDmg + dmg
  else
    target.FloodDmg = dmg
  end
  return dmg
end

function WorldFlood.skillult_takeEffectOn(basefunc, skill, target, source)
  if source then
  elseif skill.attack_counter == 2 then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {})
    basefunc(skill, target, source)
    skill.info = originfo
  else
    basefunc(skill, target, source)
  end
end

function WorldFlood.skillatk2_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 209 then
        local bid = 210
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
        break
      end
    end
  end
end

function WorldFlood.hero_die(basefunc, hero, killer)
  if hero.batList then
    for i, tBat in ipairs(hero.batList) do
      if tBat:isAlive() then
        tBat:die()
      end
    end
  end
  hero.batList = {}
  basefunc(hero, killer)
end

function WorldFlood.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  if killer_unit and killer_unit.name == "WorldFlood" then
    local proto = {
      _tid = 163,
      _level = unit.level,
      _stars = killer_unit.stars,
      _rank = killer_unit.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = 1
    }
    local Bat = ed.UnitCreate(proto, killer_unit.camp, config)
    Bat.father = killer_unit
    Bat.direction = killer_unit.direction
    local locationBat = {
      unit.position[1],
      unit.position[2] - 1
    }
    ed.engine:summonUnit(Bat, locationBat, killer_unit)
    table.insert(killer_unit.batList, Bat)
    local bid = 221
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = Bat:addBuff(binfo, Bat)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Flood_atk2.cha", {
        unit.position[1],
        unit.position[2] - 2
      }, {
        unit.direction,
        1
      }, nil, 0)
    end
    local bid = 220
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = unit:addBuff(binfo, killer_unit)
  end
end

function WorldFlood.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldFlood.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldFlood.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldFlood.ragelosthp
      boss.rageStack = boss.rageStack + 1
    end
  else
    if not boss.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      boss.stage2ragebuff = boss:addBuff(binfo, boss)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      boss:addBuff(binfo2, boss)
    end
    while boss.lastRageHp - boss.hp >= WorldFlood.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldFlood.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldFlood.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldFlood.stage2hp and hero.hp - lost <= WorldFlood.stage2hp then
    return hero.hp - WorldFlood.stage2hp
  else
    return lost
  end
end

function WorldFlood.init_hero(hero)
  hero.batList = {}
  hero.die = override(hero.die, WorldFlood.hero_die)
  hero.reset = override(hero.reset, WorldFlood.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldFlood.getLostHPAfterImmunity)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, WorldFlood.hero_handleUnitDieEvent)
  hero.update = override(hero.update, WorldFlood.boss_update)
  local skillult = hero.skills.WorldFlood_ult
  skillult.getDamage = override(skillult.getDamage, WorldFlood.skillult_getDamage)
  skillult.onAttackFrame = override(skillult.onAttackFrame, WorldFlood.skillult_onAttackFrame)
  skillult.takeEffectOn = override(skillult.takeEffectOn, WorldFlood.skillult_takeEffectOn)
  local skillatk2 = hero.skills.WorldFlood_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldFlood.skillatk2_takeEffectOn)
  end
  local skillatk4 = hero.skills.WorldFlood_atk4
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, WorldFlood.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, WorldFlood.skillatk4_onAttackFrame)
  end
  return hero
end

return WorldFlood.init_hero
