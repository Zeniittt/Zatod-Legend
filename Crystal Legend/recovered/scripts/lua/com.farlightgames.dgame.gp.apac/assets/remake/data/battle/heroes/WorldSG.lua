module("ed.battlehero", package.seeall)
local ed = ed
WorldSG = {}
WorldSG.ragelosthp = 35000
WorldSG.rage2losthp = 15000
WorldSG.stage2hp = 1750000
WorldSG.stage2ragelosthp = 7500

function WorldSG.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  if owner and owner:isAlive() then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 12000702 then
        tbuff:setAttribute("Control Effects", {"unheal"})
      end
    end
  end
  return buff
end

function WorldSG.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local ARM = owner.attribs.ARM * 0.5
  local owner_AD = owner.attribs.AD
  local caster_AD = caster.attribs.AD
  if 0 < caster_AD - owner_AD then
    local AD_value = caster_AD - owner_AD
    local plusTime = AD_value / 3000
    buff.timer = buff.timer + plusTime
  end
  buff:setAttribute("ARM", -ARM)
  if not owner.buff_effects.building then
    return buff
  end
end

function WorldSG.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldSG.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldSG.rage_buff_update(basefunc, buff, dt)
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

function WorldSG.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldSG.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldSG.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldSG.ragelosthp
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
    while boss.lastRageHp - boss.hp >= WorldSG.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldSG.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldSG.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if lost and 0 < lost then
    if hero.hp > WorldSG.stage2hp and hero.hp - lost <= WorldSG.stage2hp then
      return hero.hp - WorldSG.stage2hp
    end
    local atk4_StrBid = 12000703
    local binfo = ed.lookupDataTable("Buff", nil, atk4_StrBid)
    local atk4_STRBuff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(atk4_STRBuff, hero)
  end
  return lost
end

function WorldSG.init_hero(hero)
  local skillatk2 = hero.skills.WorldSG_atk2
  local skillult = hero.skills.WorldSG_ult
  local skillatk = hero.skills.WorldSG_atk
  local skillatk3 = hero.skills.WorldSG_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero.reset = override(hero.reset, WorldSG.reset)
  hero.update = override(hero.update, WorldSG.boss_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldSG.getLostHPAfterImmunity)
  if skillult then
    skillult.createBuff = override(skillult.createBuff, WorldSG.skillult_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, WorldSG.skillatk3_createBuff)
  end
  return hero
end

return WorldSG.init_hero
