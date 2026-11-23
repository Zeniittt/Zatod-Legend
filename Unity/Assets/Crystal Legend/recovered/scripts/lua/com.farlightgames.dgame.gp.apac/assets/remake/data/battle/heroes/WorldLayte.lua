module("ed.battlehero", package.seeall)
local ed = ed
WorldLayte = {}
WorldLayte.ragelosthp = 35000
WorldLayte.stage2hp = 1750000
WorldLayte.rage2losthp = 15000
WorldLayte.stage2ragelosthp = 7500

function WorldLayte.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldLayte.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldLayte.rage_buff_update(basefunc, buff, dt)
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

function WorldLayte.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local yposition = 20
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_Layte_ult.cha", {
      skill.caster.position[1],
      yposition
    }, {
      skill.caster.direction,
      1
    }, nil, 0)
    ed.scene:playEffectOnScene("eff_point_Layte_ult2.cha", {
      skill.caster.position[1],
      yposition - 1
    }, {
      skill.caster.direction,
      1
    }, nil, 0)
  end
end

function WorldLayte.skillult_takeEffectOn(basefunc, skill, target, source)
  if target.config and target.config.is_summoned then
    if target.buff_effects.building or target.buff_effects.invulnerable then
      return false
    else
      target:die()
      return false
    end
  else
    basefunc(skill, target, source)
  end
end

function WorldLayte.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldLayte.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldLayte.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldLayte.ragelosthp
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
    while boss.lastRageHp - boss.hp >= WorldLayte.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldLayte.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldLayte.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldLayte.stage2hp and hero.hp - lost <= WorldLayte.stage2hp then
    return hero.hp - WorldLayte.stage2hp
  else
    return lost
  end
end

function WorldLayte.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  local hpratio = target.attribs.HP and target.hp / target.attribs.HP
  local ratio = 1
  if hpratio and 0.5 < hpratio then
    ratio = 1
  else
    ratio = hpratio
  end
  return power * ratio, coefficient
end

function WorldLayte.init_hero(hero)
  hero.reset = override(hero.reset, WorldLayte.reset)
  hero.update = override(hero.update, WorldLayte.boss_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldLayte.getLostHPAfterImmunity)
  local skillult = hero.skills.WorldLayte_ult
  skillult.takeEffectAt = override(skillult.takeEffectAt, WorldLayte.skillult_takeEffectAt)
  skillult.takeEffectOn = override(skillult.takeEffectOn, WorldLayte.skillult_takeEffectOn)
  local skillatk2 = hero.skills.WorldLayte_atk2
  skillatk2.power = override(skillatk2.power, WorldLayte.skillatk2_power)
  return hero
end

return WorldLayte.init_hero
