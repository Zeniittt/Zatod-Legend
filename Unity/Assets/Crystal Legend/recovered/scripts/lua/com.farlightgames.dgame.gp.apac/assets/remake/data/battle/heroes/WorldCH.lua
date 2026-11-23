module("ed.battlehero", package.seeall)
local ed = ed
WorldCH = {}
WorldCH.shape = "circle"
WorldCH.arg1 = 220
WorldCH.arg2 = 0
WorldCH.ragelosthp = 600000
WorldCH.stage2hp = 30000000
WorldCH.rage2losthp = 200000
WorldCH.stage2ragelosthp = 400000

function WorldCH.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldCH.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldCH.rage_buff_update(basefunc, buff, dt)
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

function WorldCH.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local originfo = skill.info
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_CH_atk2.cha"
    })
  end
  basefunc(skill)
  skill.info = originfo
end

function WorldCH.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  return power * skill.info["Script Arg2"] * 0.01, i
end

function WorldCH.pasv2_power(basefunc, self, source, target, damage_type)
  local skill = self
  local caster = skill.target2
  local num = 0
  if target and target == skill.target2 then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, caster.position)
      if unit ~= caster and ed.Skill.testPointInShape(p2, WorldCH.shape, WorldCH.arg1, WorldCH.arg2) then
        num = num + 1
      end
    end
    local power = basefunc(self, source, target, damage_type) * num * 1.5
    return power, 1
  else
    return basefunc(self, source, target, damage_type), 1
  end
end

function WorldCH.buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  basefunc(buff)
  if buff.burst and buff.info.ID == 820 then
    local skill = caster.skills.WorldCH_pasv2
    skill.target2 = owner
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, owner.position)
      if unit ~= owner and ed.Skill.testPointInShape(p2, WorldCH.shape, WorldCH.arg1, WorldCH.arg2) then
        local projectile = skill:createProjectile()
        projectile.position = {
          owner.position[1],
          owner.position[2]
        }
        projectile.height = 40
        projectile:enableTrack(unit)
        ed.engine:addProjectile(projectile)
      end
    end
    skill:takeEffectOn(owner)
  end
end

function WorldCH.buff_update(basefunc, self, dt)
  local hpr = self.info.HPR * dt
  if hpr < 0 then
    local damage = min(-hpr, self.owner.hp)
    damage = damage * self.owner.dPSStatisticsRatio
    if self.owner ~= self.caster then
      self.caster.battledata:addDamage(damage, "HPR")
      self.owner.battledata:addBearDamage(damage)
    end
  end
  if 0 < hpr then
    self.owner.battledata:addHeal(hpr)
  end
  if self.timer then
    self.timer = self.timer - dt
    if 0 > self.timer then
      self.burst = true
      self.owner:removeBuff(self)
    end
  end
end

function WorldCH.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldCH.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldCH.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldCH.ragelosthp
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
    while boss.lastRageHp - boss.hp >= WorldCH.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldCH.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldCH.skillult_takeEffectOn(basefunc, skill, target, source)
  local bid = 820
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, target, skill.caster)
  buff.onRemoved = override(buff.onRemoved, WorldCH.buff_onRemoved)
  buff.update = override(buff.update, WorldCH.buff_update)
  target:addBuff(buff, skill.caster)
  local Tr, dmg = basefunc(skill, target, source)
  if ed.run_with_scene then
    local info = skill.info
    local direction = target.direction
    local location = target.position
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local effect_name = "eff_buff_burst.cha"
    local effect_name1 = "eff_impact_CH_ult2.cha"
    if target.actor and target:isAlive() then
      if effect_name then
        target.actor:addEffect(effect_name, 1)
      end
    elseif effect_name1 then
      target.actor:addEffect(effect_name1, 1)
    end
  end
  return Tr, dmg
end

function WorldCH.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldCH.stage2hp and hero.hp - lost <= WorldCH.stage2hp then
    return hero.hp - WorldCH.stage2hp
  else
    return lost
  end
end

function WorldCH.init_hero(hero)
  hero.update = override(hero.update, WorldCH.boss_update)
  hero.reset = override(hero.reset, WorldCH.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldCH.getLostHPAfterImmunity)
  local skillpasv2 = hero.skills.WorldCH_pasv2
  local skillult = hero.skills.WorldCH_ult
  local skillatk2 = hero.skills.WorldCH_atk2
  if skillpasv2 then
    skillpasv2.power = override(skillpasv2.power, WorldCH.pasv2_power)
    skillpasv2.info = ed.wraptable(skillpasv2.info, {
      ["No Dodge"] = true
    })
  end
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldCH.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, WorldCH.skillatk2_power)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldCH.skillatk2_onAttackFrame)
  end
  return hero
end

return WorldCH.init_hero
