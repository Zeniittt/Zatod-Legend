module("ed.battlehero", package.seeall)
local ed = ed
WorldQOP = {}
WorldQOP.atk3buff = 10038201
WorldQOP.atk3_defense_buff = 10038204
WorldQOP.enchbuff = 10038206
WorldQOP.ragelosthp = 35000
WorldQOP.rage2losthp = 15000
WorldQOP.stage2hp = 1750000
WorldQOP.stage2ragelosthp = 7500

function WorldQOP.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.update = override(buff.update, WorldQOP.skillatk2_buffUpdate)
  end
  return buff
end

function WorldQOP.skillatk2_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk2 = caster.skills.WorldQOP_atk2
  local WorldQOP_hpr = (buff.info.HPR + buff.info["HPR.a"] * caster.attribs.AP) * dt
  if WorldQOP_hpr < 0 then
    local WorldQOP_damage = math.min(-WorldQOP_hpr, buff.owner.hp)
    WorldQOP_damage = WorldQOP_damage * buff.owner.dPSStatisticsRatio
    buff.caster.notPopupBattleInfo = true
    buff.caster:takeHeal(math.abs(skillatk2.evo_rank3["Script Arg1"] / 100 * WorldQOP_damage), "hp", caster)
    buff.caster.notPopupBattleInfo = false
  end
end

function WorldQOP.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local ishit, damage = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ishit and damage and 0 < damage and target.info.Gender == T("\231\148\183") then
    local bid = WorldQOP.enchbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    local rand = ed.rand()
    if rand <= 0.25 then
      target:addBuff(binfo, caster)
    end
  end
  return ishit, damage
end

function WorldQOP.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local bid = WorldQOP.atk3buff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  caster.oriposition = caster.position
end

function WorldQOP.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == WorldQOP.atk3buff then
      local buff = tbuff
      buff.timer = -1
    end
  end
  local bid = WorldQOP.atk3_defense_buff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
end

function WorldQOP.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    local DOPPosition = WorldQOP.DOP_in_battlefield(hero, 130, hero.foecamp)
    hero.position = DOPPosition
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    hero.position = hero.oriposition
    skill.attack_counter = skill.attack_counter + 1
  end
end

function WorldQOP.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if (unit.buffManager.invisible or unit.buff_effects.untargetable or unit.buff_effects.invulnerable) and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    position = {400, 0}
    return position
  end
end

function WorldQOP.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local ishit, damage = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ishit and damage and 0 < damage and target.info.Gender == T("\231\148\183") then
    local bid = WorldQOP.enchbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    local rand = ed.rand()
    if rand <= 0.25 then
      target:addBuff(binfo, caster)
    end
  end
  return ishit, damage
end

function WorldQOP.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local ishit, damage = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ishit and damage and 0 < damage and target.info.Gender == T("\231\148\183") then
    local bid = WorldQOP.enchbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    local rand = ed.rand()
    if rand <= 0.25 then
      target:addBuff(binfo, caster)
    end
  end
  return ishit, damage
end

function WorldQOP.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  if type(struct_table) == "table" then
    if struct_table.source and struct_table.source.info.Gender == T("\231\148\183") then
      self.Gender = T("\231\148\183")
    end
  elseif source and source.info.Gender == T("\231\148\183") then
    self.Gender = T("\231\148\183")
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function WorldQOP.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  if self.Gender == T("\231\148\183") then
    damage = damage * 0.5
  end
  return basefunc(self, damage, immunity)
end

function WorldQOP.hero_reset(basefunc, unit)
  basefunc(unit)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = unit:addBuff(binfo, unit)
  buff.update = override(buff.update, WorldQOP.rage_buff_update)
  unit.lastrageStack = 0
end

function WorldQOP.rage_buff_update(basefunc, buff, dt)
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

function WorldQOP.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldQOP.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldQOP.ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldQOP.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldQOP.stage2ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldQOP.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldQOP.init_hero(hero)
  local skillatk2 = hero.skills.WorldQOP_atk2
  local skillatk3 = hero.skills.WorldQOP_atk3
  local skillult = hero.skills.WorldQOP_ult
  hero.update = override(hero.update, WorldQOP.hero_update)
  hero.reset = override(hero.reset, WorldQOP.hero_reset)
  hero.takeDamage = override(hero.takeDamage, WorldQOP.hero_takeDamage)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldQOP.skill_getLostHPAfterImmunity)
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldQOP.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, WorldQOP.skillatk2_createBuff)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldQOP.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, WorldQOP.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, WorldQOP.skillatk3_finish)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldQOP.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldQOP.skillatk3_takeEffectOn)
  end
  return hero
end

return WorldQOP.init_hero
