module("ed.battlehero", package.seeall)
local ed = ed
WorldJUGG = {}
WorldJUGG.ult = 10037401
WorldJUGG.atk2 = 10037402
WorldJUGG.ragelosthp = 35000
WorldJUGG.rage2losthp = 15000
WorldJUGG.stage2hp = 1750000
WorldJUGG.stage2ragelosthp = 7500

function WorldJUGG.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = WorldJUGG.ult
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.WorldJUGGUltPosition = {
    caster.position[1],
    caster.position[2],
    0
  }
  basefunc(skill, target)
end

function WorldJUGG.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 6 and caster.WorldJUGGUltPosition then
    caster.position = {
      caster.WorldJUGGUltPosition[1],
      caster.WorldJUGGUltPosition[2],
      0
    }
  end
end

function WorldJUGG.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  caster.position = {
    target.position[1],
    target.position[2] - 1
  }
  local isHit, dmg = basefunc(skill, target)
  local skillults = caster.skills.WorldJUGG_ults
  if isHit and skillults then
    local rand = 0.3
    if rand >= ed.rand() then
      skillults:takeEffectOn(target)
    end
  end
  return isHit, dmg
end

function WorldJUGG.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == WorldJUGG.ult then
      local buff = tbuff
      buff.timer = -1
    end
  end
end

function WorldJUGG.skillatk_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  local isHit, dmg = basefunc(skill, target)
  local skillatks = caster.skills.WorldJUGG_atks
  if isHit and skillatks then
    local rand = 0.3
    if rand >= ed.rand() then
      skillatks:takeEffectOn(target)
    end
  end
  return isHit, dmg
end

function WorldJUGG.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local v = 180
  local bid = WorldJUGG.atk2
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if target.position[1] - caster.position[1] <= 0 then
    caster.direction = -1
  else
    caster.direction = 1
  end
  caster.walk_v = {
    caster.direction * v,
    0
  }
end

function WorldJUGG.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skill = skill
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 4 then
    local v = -caster.walk_v[1]
    caster.walk_v = {v, 0}
  elseif skill.attack_counter and skill.attack_counter == 8 then
    caster.walk_v = {0, 0}
  end
end

function WorldJUGG.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  local isHit, dmg = basefunc(skill, target)
  local skillatk2s = caster.skills.WorldJUGG_atk2s
  if isHit and skillatk2s then
    local rand = 0.3
    if rand >= ed.rand() then
      skillatk2s:takeEffectOn(target)
    end
  end
  return isHit, dmg
end

function WorldJUGG.skillatk2_finish(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  skill.caster.direction = skill.caster.direction * -1
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == WorldJUGG.atk2 then
      local buff = tbuff
      buff.timer = -1
    end
  end
end

function WorldJUGG.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local list = caster.buff_list
  local debuff_list = {}
  local my_camp = caster.camp
  for i = 1, #list do
    local buff = list[i]
    if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    caster:removeBuff(debuff_list[i])
  end
  return buff
end

function WorldJUGG.hero_handleUnitDieEvent(basefunc, hero, unit, killer_unit)
  basefunc(hero, unit, killer_unit)
  if hero == killer_unit then
    local bid = 10037405
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("AD", hero.attribs.AD * 0.15)
    hero:addBuff(buff, hero)
  end
end

function WorldJUGG.hero_reset(basefunc, unit)
  basefunc(unit)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = unit:addBuff(binfo, unit)
  buff.update = override(buff.update, WorldJUGG.rage_buff_update)
  unit.lastrageStack = 0
end

function WorldJUGG.rage_buff_update(basefunc, buff, dt)
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

function WorldJUGG.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldJUGG.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldJUGG.ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldJUGG.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldJUGG.stage2ragelosthp do
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldJUGG.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldJUGG.init_hero(hero)
  local skillult = hero.skills.WorldJUGG_ult
  local skillatk = hero.skills.WorldJUGG_atk
  local skillatk2 = hero.skills.WorldJUGG_atk2
  local skillatk3 = hero.skills.WorldJUGG_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero.update = override(hero.update, WorldJUGG.hero_update)
  hero.reset = override(hero.reset, WorldJUGG.hero_reset)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, WorldJUGG.hero_handleUnitDieEvent)
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldJUGG.skillult_onAttackFrame)
    skillult.start = override(skillult.start, WorldJUGG.skillult_start)
    skillult.finish = override(skillult.finish, WorldJUGG.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, WorldJUGG.skillult_takeEffectOn)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, WorldJUGG.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, WorldJUGG.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldJUGG.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldJUGG.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillatk2.finish, WorldJUGG.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, WorldJUGG.skillatk3_createBuff)
    skillatk3.info = ed.wraptable(skillatk3.info, {
      ["Point Effect"] = "eff_point_JUGG_atk3_fashion_1.cha"
    })
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return WorldJUGG.init_hero
