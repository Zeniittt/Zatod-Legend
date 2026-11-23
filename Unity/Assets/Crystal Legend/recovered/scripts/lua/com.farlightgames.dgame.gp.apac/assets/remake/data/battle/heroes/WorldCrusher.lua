module("ed.battlehero", package.seeall)
local ed = ed
WorldCrusher = {}
WorldCrusher.ragelosthp = 600000
WorldCrusher.debuff_stun_stack = 1
WorldCrusher.debuff_id = 433
WorldCrusher.stunbuff_id = 434
WorldCrusher.debuff_power_percent = 0.2
WorldCrusher.stage2hp = 30000000
WorldCrusher.rage2losthp = 200000
WorldCrusher.stage2ragelosthp = 400000

function WorldCrusher.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldCrusher.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldCrusher.rage_buff_update(basefunc, buff, dt)
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

function WorldCrusher.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldCrusher.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldCrusher.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldCrusher.ragelosthp
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
    while boss.lastRageHp - boss.hp >= WorldCrusher.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldCrusher.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldCrusher.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local distance = ed.edpSub(target_position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function WorldCrusher.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  if ed.engine:getStageId() == 20105 and ed.engine:withBattleHero(10001) and not skill.caster.debuffremoved then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      for _, buff in ipairs(unit.buff_list) do
        if buff.name == "WorldCrusher_stop" then
          buff.timer = 0
        end
      end
    end
    skill.caster.debuffremoved = true
  end
  if isHit then
    local debuff_stack = 0
    local debuff
    for _, buff in ipairs(target.buff_list) do
      if buff.info.ID == WorldCrusher.debuff_id then
        debuff = buff
        debuff_stack = buff.rank
        break
      end
    end
    if debuff_stack > WorldCrusher.debuff_stun_stack then
      local stun_time = (debuff_stack - WorldCrusher.debuff_stun_stack) * 2
      local origin_buffinfo = ed.lookupDataTable("Buff", nil, WorldCrusher.stunbuff_id)
      local caster = skill.caster
      local target_buff = target:addBuff(origin_buffinfo, caster)
      if target_buff then
        target_buff.timer = stun_time
      end
    end
    if debuff then
      debuff.timer = 0
    end
    return isHit, dmg
  end
  return false
end

function WorldCrusher.skillult_power(basefunc, skill, source, target, damage_type)
  local debuff_stack = 0
  for _, buff in ipairs(target.buff_list) do
    if buff.info.ID == WorldCrusher.debuff_id then
      debuff_stack = buff.rank
      break
    end
  end
  local originPower = basefunc(skill, source, target, damage_type)
  local newPower = originPower * (1 + WorldCrusher.debuff_power_percent * debuff_stack)
  return newPower, 1
end

function WorldCrusher.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local info = skill.info
  local rowtable = {
    [1] = T("\229\137\141\230\142\146"),
    [2] = T("\228\184\173\230\142\146"),
    [3] = T("\229\144\142\230\142\146")
  }
  local rowavailable = {
    [1] = false,
    [2] = false,
    [3] = false
  }
  if not skill.rowcount then
    skill.rowcount = 1
  end
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.config.is_summoned then
    elseif unit.info["Position Type"] == T("\229\137\141\230\142\146") then
      rowavailable[1] = true
    elseif unit.info["Position Type"] == T("\228\184\173\230\142\146") then
      rowavailable[2] = true
    else
      if unit.info["Position Type"] == T("\229\144\142\230\142\146") then
        rowavailable[3] = true
      else
      end
    end
  end
  if not rowavailable[skill.rowcount + 1] then
    skill.rowcount = (skill.rowcount + 1) % 3
    if not rowavailable[skill.rowcount + 1] then
      skill.rowcount = (skill.rowcount + 1) % 3
    end
  end
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.config.is_summoned then
    elseif unit.info["Position Type"] == rowtable[skill.rowcount + 1] then
      skill:takeEffectOn(unit)
    end
  end
  skill.rowcount = (skill.rowcount + 1) % 3
  if ed.run_with_scene then
    local effect_name = info["Point Effect"]
    if not effect_name then
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, WorldCrusher.origin, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
end

function WorldCrusher.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldCrusher.stage2hp and hero.hp - lost <= WorldCrusher.stage2hp then
    return hero.hp - WorldCrusher.stage2hp
  else
    return lost
  end
end

function WorldCrusher.init_hero(hero)
  hero.update = override(hero.update, WorldCrusher.boss_update)
  hero.reset = override(hero.reset, WorldCrusher.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldCrusher.getLostHPAfterImmunity)
  local skillatk3 = hero.skills.WorldCrusher_atk3
  skillatk3.createProjectile = override(skillatk3.createProjectile, WorldCrusher.skillatk3_createProjectile)
  local skillult = hero.skills.WorldCrusher_ult
  if ed.engine:withBattleHero(10001) then
    skillult.info["Init CD"] = 4
  end
  skillult.takeEffectOn = override(skillult.takeEffectOn, WorldCrusher.skillult_takeEffectOn)
  skillult.power = override(skillult.power, WorldCrusher.skillult_power)
  hero.debuffremoved = false
  local skillatk2 = hero.skills.WorldCrusher_atk2
  skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, WorldCrusher.skillatk2_takeEffectAt)
  return hero
end

return WorldCrusher.init_hero
