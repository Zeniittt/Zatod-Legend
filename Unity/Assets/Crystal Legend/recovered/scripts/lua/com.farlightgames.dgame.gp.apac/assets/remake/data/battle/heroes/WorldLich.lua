module("ed.battlehero", package.seeall)
local ed = ed
WorldLich = {}
WorldLich.ragelosthp = 35000
WorldLich.rage2losthp = 15000
WorldLich.stage2hp = 1750000
WorldLich.stage2ragelosthp = 7500

function WorldLich.projectile_hit(basefunc, tile, target)
  local skillult = tile.skill
  if skillult then
    local origin_info = skillult.info
    local caster = tile.caster
    local jumpSum = 5 - tile.jumps
    local addNumtime = skillult.evo_rank3["Script Arg1"] + skillult.evo_rank3["Script Arg2"] * caster.attribs.AP
    local addNum = addNumtime * jumpSum
    local basicNum = skillult.info["Basic Num"]
    skillult.info = ed.wraptable(skillult.info, {
      ["Basic Num"] = basicNum + addNum
    })
    basefunc(tile, target)
    skillult.info = origin_info
  end
end

function WorldLich.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(5)
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  
  return projectile
end

function WorldLich.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local source = source or struct_table.source
  if dt and dt == "AD" and lost and 0 < lost and source and source:isAlive() then
    local bid = 10037503
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, source, self)
    buff.update = override(buff.update, WorldLich.EnemySlowBuff_update)
    source:addBuff(buff, self)
  end
  return lost
end

function WorldLich.EnemySlowBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner and owner.manually_casting then
    buff.timer = -1
  end
end

function WorldLich.hero_handleUnitDieEvent(basefunc, hero, unit, killer_unit)
  basefunc(hero, unit, killer_unit)
  if hero == killer_unit then
    local bid = 10037504
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("AP", hero.attribs.AP * 0.15)
    hero:addBuff(buff, hero)
  end
end

function WorldLich.hero_reset(basefunc, unit)
  basefunc(unit)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = unit:addBuff(binfo, unit)
  buff.update = override(buff.update, WorldLich.rage_buff_update)
  unit.lastrageStack = 0
end

function WorldLich.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.05)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.05)
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

function WorldLich.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldLich.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldLich.ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLich.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldLich.stage2ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLich.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldLich.init_hero(hero)
  local skillult = hero.skills.WorldLich_ult
  local skillatk2 = hero.skills.WorldLich_atk2
  local skillatk3 = hero.skills.WorldLich_atk3
  local skillemaura = hero.effect_enemy_aura_skill_list[1]
  hero.update = override(hero.update, WorldLich.hero_update)
  hero.reset = override(hero.reset, WorldLich.hero_reset)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, WorldLich.hero_handleUnitDieEvent)
  hero.takeDamage = override(hero.takeDamage, WorldLich.hero_takeDamage)
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, WorldLich.skillult_createProjectile)
  end
  return hero
end

return WorldLich.init_hero
