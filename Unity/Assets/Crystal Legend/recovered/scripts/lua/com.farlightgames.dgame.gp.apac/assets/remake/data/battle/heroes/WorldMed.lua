module("ed.battlehero", package.seeall)
local ed = ed
WorldMed = {}
WorldMed.awakeR = 210
WorldMed.WorldMed_sawake_shield = 1185
WorldMed.WorldMed_sawake_AD = 1186
WorldMed.ragelosthp = 35000
WorldMed.rage2losthp = 15000
WorldMed.stage2hp = 1750000
WorldMed.stage2ragelosthp = 7500

function WorldMed.createProjectile(basefunc, skill)
  local counter = 0
  local caster = skill.caster
  caster.dmgModifier = 1
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if 5 <= counter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    else
      counter = counter + 1
      skill.target = unit
      for _, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 4120 and tbuff.caster == caster then
          caster.dmgModifier = 1.35
        else
          caster.dmgModifier = 1
        end
      end
      local projectile = basefunc(skill, unit)
      projectile.dmgModifier = caster.dmgModifier
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function WorldMed.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ishit, dmg, Crit, lfs_amount = basefunc(skill, target, source)
  local caster = skill.caster
  if ishit and target and target:isAlive() and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable then
    local p = 11
    for _, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 4117 and tbuff.caster == caster then
        p = 31
      end
    end
    if p > ed.rand() * 100 then
      local bid = 4120
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local atk2_buff = target:addBuff(binfo, caster)
      p = 11
    end
  end
  return ishit, dmg, Crit, lfs_amount
end

function WorldMed.power(basefunc, self, source, target, damage_type)
  if source.dmgModifier then
    return basefunc(self, source, target, damage_type) * source.dmgModifier, source.dmgModifier
  else
    return basefunc(self, source, target, damage_type), 1
  end
end

function WorldMed.skillatk3_takeEffectAt(basefunc, skill, location)
  local caster = skill.caster
  local bid = 34
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, location)
  caster:removeBuff(buff)
end

function WorldMed.skillatk3_takeEffectOn(basefunc, skill, target, source)
  if target and target.config.is_summoned then
    return
  end
  basefunc(skill, target, source)
end

function WorldMed.update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk5 = hero.skills.WorldMed_atk5
  if hero:isAlive() and skillatk5 then
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      local unitdistance = unit.position[1] - hero.position[1]
      local unitdistanceabs = math.abs(unitdistance)
      local dir = unit.direction
      if (unit.proto._tid == 49 or unit.proto._tid == "BB") and unit.ultBuff_BB then
        dir = -dir
      end
      if unitdistanceabs <= WorldMed.awakeR then
        if hero.direction * unitdistance > 0 and dir ~= hero.direction and not unit.buff_effects.untargetable and not unit.buffManager.invisible and unit.camp ~= hero.camp then
          if hero.WorldMed_awake_list[unit] then
            hero.WorldMed_awake_list[unit] = hero.WorldMed_awake_list[unit] + 1
            if hero.WorldMed_awake_list[unit] == 24 then
              local skillawake_slow = hero.skills.WorldMed_atk5_buff1
              skillawake_slow:takeEffectOn(unit)
            elseif hero.WorldMed_awake_list[unit] == 48 then
              local skillawake_stone = hero.skills.WorldMed_atk5_buff2
              skillawake_stone:takeEffectOn(unit)
              hero.WorldMed_awake_list[unit] = 0
              for _, tbuff in ipairs(unit.buff_list) do
                if tbuff.info.ID == 4118 then
                  tbuff.timer = 0
                end
              end
            end
          else
            hero.WorldMed_awake_list[unit] = 1
          end
        elseif hero.WorldMed_awake_list[unit] then
          hero.WorldMed_awake_list[unit] = 0
          for i, tbuff in ipairs(unit.buff_list) do
            if tbuff.info.ID == 4118 then
              tbuff.timer = 0
            end
          end
        end
      end
    end
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldMed.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldMed.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldMed.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldMed.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldMed.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldMed.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldMed.stage2hp and hero.hp - lost <= WorldMed.stage2hp then
    return hero.hp - WorldMed.stage2hp
  else
    return lost
  end
end

function WorldMed.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldMed.rage_buff_update)
  hero.lastrageStack = 0
  hero.WorldMed_awake_list = {}
end

function WorldMed.rage_buff_update(basefunc, buff, dt)
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

function WorldMed.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillult = self.skills.WorldMed_ult
  local skillatk3 = self.skills.WorldMed_atk3
  if skillult and killer_unit == self and self.current_skill == skillult then
    for _, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 4120 then
        skillatk3.cd_remaining = 0
      end
    end
  end
end

function WorldMed.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local ult_power = power
  local Stone_num = 0
  for _, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 4120 then
      ult_power = ult_power * 2
    end
  end
  for _, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 4120 then
      Stone_num = Stone_num + 1
    end
  end
  self.cd_remaining = self.cd_remaining * (1 - Stone_num * 0.1)
  local dmg = target:takeDamage({
    amount = ult_power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function WorldMed.init_hero(hero)
  local skillult = hero.skills.WorldMed_ult
  local skillatk2 = hero.skills.WorldMed_atk2
  local skillatk3 = hero.skills.WorldMed_atk3
  local skillatk4 = hero.skills.WorldMed_atk4
  local skillatk5 = hero.skills.WorldMed_atk5
  if skillult then
    skillult.getDamage = override(skillult.getDamage, WorldMed.skillult_getDamage)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldMed.createProjectile)
    skillatk2.power = override(skillatk2.power, WorldMed.power)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldMed.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, WorldMed.skillatk3_takeEffectAt)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldMed.skillatk3_takeEffectOn)
  end
  hero.update = override(hero.update, WorldMed.update)
  hero.reset = override(hero.reset, WorldMed.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldMed.getLostHPAfterImmunity)
  return hero
end

return WorldMed.init_hero
