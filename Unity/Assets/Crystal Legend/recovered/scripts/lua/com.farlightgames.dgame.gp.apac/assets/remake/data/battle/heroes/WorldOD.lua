module("ed.battlehero", package.seeall)
local ed = ed
WorldOD = {}
WorldOD.ragelosthp = 600000
WorldOD.ragelosthp = 200000
WorldOD.stage2hp = 30000000
WorldOD.stage2ragelosthp = 400000

function WorldOD.reset(basefunc, hero)
  basefunc(hero)
  hero.direction = -1
  hero.position[1] = 700
  hero.position[2] = 0
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldOD.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldOD.rage_buff_update(basefunc, buff, dt)
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

function WorldOD.takeEffectOn(basefunc, skill, target)
  if target.info["Main Attrib"] == "INT" then
    local caster = skill.caster
    local dmg, num = basefunc(caster.skills.WorldOD_atk5, target)
  else
    return basefunc(skill, target)
  end
end

function WorldOD.skill3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local trans_int = skill.info["Script Arg1"]
  local caster = skill.caster
  local bid = 241
  local orin_info = ed.lookupDataTable("Buff", nil, bid)
  local binfo = ed.wraptable(orin_info, {INT = trans_int})
  caster:addBuff(binfo, caster)
  local binfo = ed.wraptable(orin_info, {
    INT = -trans_int
  })
  target:addBuff(binfo, caster)
  return buff
end

function WorldOD.update(basefunc, self, dt)
  if self.state == ed.emUnitState_Dying then
    if not self.dyingTimer_OD then
      self.dyingTimer_OD = 1.7
    end
    self.dyingTimer_OD = self.dyingTimer_OD - dt
    if self.dyingTimer_OD <= 0 then
      self.dyingTimer_OD = 99999
      local skill = self.skills.WorldOD_awake
      skill:takeEffectAt(self.position)
    end
  else
    self.dyingTimer_OD = nil
  end
  basefunc(self, dt)
end

function WorldOD.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldOD.stage2hp then
    while boss.lastRageHp - boss.hp >= 600000 do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - 600000
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
    while boss.lastRageHp - boss.hp >= WorldOD.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - 200000
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldOD.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldOD.stage2hp and hero.hp - lost <= WorldOD.stage2hp then
    return hero.hp - WorldOD.stage2hp
  else
    return lost
  end
end

function WorldOD.init_hero(hero)
  hero.update = override(hero.update, WorldOD.boss_update)
  hero.reset = override(hero.reset, WorldOD.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldOD.getLostHPAfterImmunity)
  if ed.protoAwake(hero.proto, 187) and hero.skills.WorldOD_awake then
    hero.update = override(hero.update, WorldOD.update)
  end
  local skillult = hero.skills.WorldOD_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldOD.takeEffectOn)
  end
  local skill3 = hero.skills.WorldOD_atk3
  if skill3 then
    skill3.createBuff = override(skill3.createBuff, WorldOD.skill3_createBuff)
  end
  return hero
end

return WorldOD.init_hero
