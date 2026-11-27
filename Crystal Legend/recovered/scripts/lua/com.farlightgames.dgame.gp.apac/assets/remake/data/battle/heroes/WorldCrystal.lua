module("ed.battlehero", package.seeall)
local ed = ed
WorldCrystal = {}
WorldCrystal.ragelosthp = 600000
WorldCrystal.rage2losthp = 200000
WorldCrystal.stage2hp = 30000000
WorldCrystal.stage2ragelosthp = 400000

function WorldCrystal.reset(basefunc, hero)
  basefunc(hero)
  hero.direction = -1
  hero.position[1] = 700
  hero.position[2] = 0
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldCrystal.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldCrystal.rage_buff_update(basefunc, buff, dt)
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

function WorldCrystal.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldCrystal.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldCrystal.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldCrystal.ragelosthp
      hero.rageStack = hero.rageStack + 1
      WorldCrystal.is_damage_for_three = 0
      WorldCrystal.is_damage_for_fifty = 0
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
    while hero.lastRageHp - hero.hp >= WorldCrystal.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldCrystal.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
  if hero.rageStack then
    if hero.rageStack > 0 and hero.rageStack % 3 == 0 and WorldCrystal.is_damage_for_three == 0 and hero.rageStack < 50 then
      for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
        unit:takeDamage((1000 - unit.mp) * 2 * hero.rageStack, "Holy", "hp", hero)
        WorldCrystal.is_damage_for_three = 1
      end
    elseif hero.rageStack >= 50 then
      for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
        if unit.mp > 300 then
          unit:takeDamage((1000 - unit.mp) * 20, "Holy", "hp", hero)
        end
      end
    end
  end
end

function WorldCrystal.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldCrystal.stage2hp and hero.hp - lost <= WorldCrystal.stage2hp then
    return hero.hp - WorldCrystal.stage2hp
  else
    return lost
  end
end

function WorldCrystal.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, 4098)
  caster.WorldCrystal_ult_buff_self = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(caster.WorldCrystal_ult_buff_self, caster)
end

function WorldCrystal.skillult_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Crystal_ult.cha", {400, -30}, {1, 1}, nil, 0)
    end
  else
    local caster = skill.caster
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      skill.target = unit
      basefunc(skill, location, source)
    end
  end
end

function WorldCrystal.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if target and target ~= caster then
    if target.info["Main Attrib"] == "INT" then
      if target.mp > 0 then
        target:takeDamage(500, "Holy", "mp", caster)
      end
    elseif target.info["Main Attrib"] == "AGI" then
      if target.mp > 0 then
        target:takeDamage(400, "Holy", "mp", caster)
      end
    elseif target.info["Main Attrib"] == "STR" and target.mp > 0 then
      target:takeDamage(300, "Holy", "mp", caster)
    end
  end
end

function WorldCrystal.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.WorldCrystal_ult_buff_self then
    caster.WorldCrystal_ult_buff_self.timer = 0
  end
end

function WorldCrystal.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local mp_most_Unit
  local most_mp = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.config.is_summoned then
      local mp = unit.mp
      if most_mp <= mp then
        mp_most_Unit = unit
        most_mp = mp
      end
    end
  end
  if mp_most_Unit then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Crystal_atk2_enemy.cha", mp_most_Unit.position, {1, 1}, nil, 1)
    end
    mp_most_Unit:takeDamage(400, "Holy", "mp", caster)
  end
end

function WorldCrystal.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local mp_most_Unit
  local most_mp = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.config.is_summoned then
      local mp = unit.mp
      if most_mp <= mp then
        mp_most_Unit = unit
        most_mp = mp
      end
    end
  end
  if mp_most_Unit then
    local binfo = ed.lookupDataTable("Buff", nil, 4142)
    local buff = ed.BuffCreate(binfo, mp_most_Unit, caster)
    mp_most_Unit:addBuff(buff, caster)
  end
end

function WorldCrystal.init_hero(hero)
  local skillult = hero.skills.WorldCrystal_ult
  local skillatk2 = hero.skills.WorldCrystal_atk2
  local skillatk3 = hero.skills.WorldCrystal_atk3
  if skillult then
    skillult.start = override(skillult.start, WorldCrystal.skillult_start)
    skillult.takeEffectAt = override(skillult.takeEffectAt, WorldCrystal.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldCrystal.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, WorldCrystal.skillult_finish)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldCrystal.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldCrystal.skillatk3_takeEffectOn)
  end
  hero.update = override(hero.update, WorldCrystal.update)
  hero.reset = override(hero.reset, WorldCrystal.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldCrystal.getLostHPAfterImmunity)
  return hero
end

return WorldCrystal.init_hero
