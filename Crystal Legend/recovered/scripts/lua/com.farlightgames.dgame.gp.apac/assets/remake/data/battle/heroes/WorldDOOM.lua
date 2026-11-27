module("ed.battlehero", package.seeall)
local ed = ed
WorldDOOM = {}
WorldDOOM.ragelosthp = 35000
WorldDOOM.stage2hp = 1750000
WorldDOOM.rage2losthp = 15000
WorldDOOM.stage2ragelosthp = 7500

function WorldDOOM.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldDOOM.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldDOOM.rage_buff_update(basefunc, buff, dt)
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

function WorldDOOM.skillatk2_takeEffectOn(basefunc, skill, target, source)
  if target.config and target.config.is_summoned then
    if target.buff_effects.building or target.buff_effects.invulnerable then
      return false
    else
      target:die()
      return false
    end
  end
  if target.mp and target.mp == target.attribs.MP then
    local binfo
    local bid = 218
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, skill.caster)
    return false
  end
  basefunc(skill, target, source)
end

function WorldDOOM.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  if skill.caster and skill.caster.rageStack and skill.caster.rageStack % 2 == 1 then
    power = target.hp / 1.8 - 1
  end
  return power, 1
end

function WorldDOOM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_DOOM_ult.cha"
    local origin = {400, 0}
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
  end
end

function WorldDOOM.ultbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner and buff.owner.hp <= 1 then
    buff.owner:die(buff.caster)
  end
end

function WorldDOOM.skillult_takeEffectOn(basefunc, skill, target, source)
  if target.config and target.config.is_summoned then
    if target.buff_effects.building or target.buff_effects.invulnerable then
      return false
    else
      target:die()
      return false
    end
  end
  if target.mp and target.mp == target.attribs.MP then
    return false
  end
  basefunc(skill, target, source)
end

function WorldDOOM.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, WorldDOOM.ultbuff_update)
  return buff
end

function WorldDOOM.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldDOOM.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldDOOM.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldDOOM.ragelosthp
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
    while boss.lastRageHp - boss.hp >= WorldDOOM.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldDOOM.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldDOOM.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldDOOM.stage2hp and hero.hp - lost <= WorldDOOM.stage2hp then
    return hero.hp - WorldDOOM.stage2hp
  else
    return lost
  end
end

function WorldDOOM.init_hero(hero)
  hero.update = override(hero.update, WorldDOOM.boss_update)
  hero.reset = override(hero.reset, WorldDOOM.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldDOOM.getLostHPAfterImmunity)
  local skillatk2 = hero.skills.WorldDOOM_atk2
  skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldDOOM.skillatk2_takeEffectOn)
  local skillatk3 = hero.skills.WorldDOOM_atk3
  skillatk3.power = override(skillatk3.power, WorldDOOM.skillatk3_power)
  local skillult = hero.skills.WorldDOOM_ult
  skillult.start = override(skillult.start, WorldDOOM.skillult_start)
  skillult.takeEffectOn = override(skillult.takeEffectOn, WorldDOOM.skillult_takeEffectOn)
  skillult.createBuff = override(skillult.createBuff, WorldDOOM.skillult_createBuff)
  return hero
end

return WorldDOOM.init_hero
