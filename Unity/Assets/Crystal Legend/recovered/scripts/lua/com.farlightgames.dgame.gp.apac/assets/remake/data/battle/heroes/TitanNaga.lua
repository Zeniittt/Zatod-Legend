module("ed.battlehero", package.seeall)
local ed = ed
TitanNaga = {}
TitanNaga.jump_gap = 90000
TitanNaga.TitanNaga_fashion_id = 101191
TitanNaga.ragelosthp = 35000
TitanNaga.rage2losthp = 15000
TitanNaga.stage2hp = 1750000
TitanNaga.stage2ragelosthp = 7500

function TitanNaga.TitanNaga_mirrorFunction(unit)
  unit.update = override(unit.update, TitanNaga.TitanNagaMirror_update)
  unit.die = override(unit.die, TitanNaga.TitanNagaMirror_die)
end

function TitanNaga.TitanNagaMirror_update(basefunc, unit, dt)
  basefunc(unit, dt)
  local caster = unit.config.summoner
  unit.mDuration_TitanNaga = unit.mDuration_TitanNaga - dt
  if unit.mDuration_TitanNaga < 0 and unit:isAlive() then
    unit:die()
  end
end

function TitanNaga.TitanNagaMirror_die(basefunc, hero, killer)
  basefunc(hero, killer)
  hero.mDuration_TitanNaga = 0
  local summoner = hero.config.summoner
  if hero and hero:isAlive() then
    hero:die()
    summoner.TitanNaga_mirror_count = summoner.TitanNaga_mirror_count - 1
  end
  if summoner and summoner.TitanNaga_ult_MirrorList then
    for i, unit in ipairs(summoner.TitanNaga_ult_MirrorList) do
      if unit == hero then
        table.remove(summoner.TitanNaga_ult_MirrorList, i)
      end
    end
  end
end

function TitanNaga.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanNaga_ult
  local TitanNaga_mirrorTime = skillult.info["Script Arg3"] + 1
  local attack_counter = skill.attack_counter
  local MirrorCount = 2
  if not caster.TitanNaga_ult_MirrorList then
    caster.TitanNaga_ult_MirrorList = {}
  end
  if attack_counter == 1 then
    local proto = {
      _tid = TitanNaga.TitanNaga_fashion_id and TitanNaga.TitanNaga_fashion_id == caster.fashion_id and 320 or 312,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_summoned = true,
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1,
      summoner = caster
    }
    for i = 1, MirrorCount do
      local TitanNagaMirror = ed.UnitCreate(proto, caster.camp, config)
      local TitanNagaMirror_atk = TitanNagaMirror.skills.TitanNaga_Mirror_atk
      local TitanNagaMirror_skin_atk = TitanNagaMirror.skills.TitanNaga_Mirror_skin_atk
      TitanNagaMirror.mDuration_TitanNaga = TitanNaga_mirrorTime
      TitanNaga.TitanNaga_mirrorFunction(TitanNagaMirror)
      TitanNagaMirror:setDeathWithEffectOrNot(true)
      TitanNagaMirror.direction = caster.direction
      local range_x = 75
      local range_y = 40
      local xs = 50
      local ys = 10
      local xxs = ed.rand() * 2 * range_x + xs - range_x
      local yys = ed.rand() * 2 * range_y + ys - range_y
      local locationtb = {
        caster.position[1] + xxs * TitanNagaMirror.direction,
        caster.position[2] + yys
      }
      ed.engine:summonUnit(TitanNagaMirror, locationtb, caster, "Idle")
      table.insert(caster.TitanNaga_ult_MirrorList, TitanNagaMirror)
      local AttriBinfo = ed.lookupDataTable("Buff", nil, 11011901)
      TitanNaga.changeBuffInfo(AttriBinfo, 0.5, TitanNagaMirror)
      local buff = TitanNagaMirror:addBuff(AttriBinfo, caster)
      TitanNagaMirror:takeHeal(TitanNagaMirror.attribs.HP, "hp")
      caster.TitanNaga_mirror_count = caster.TitanNaga_mirror_count + 1
    end
  end
end

function TitanNaga.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" then
        buffInfo[name .. ".a"] = 0.0015 / target.config.hp_mod
      end
    end
  end
end

function TitanNaga.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.findNextTaeget = override(projectile.findNextTaeget, TitanNaga.skill2_projectile_findNextTaeget)
  projectile.hit = override(projectile.hit, TitanNaga.projectile_hit)
  projectile:enableJump(4)
  projectile.affect_times = {}
  return projectile
end

function TitanNaga.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local hero = skill.caster
  local skillRemnant1 = hero.skills.TitanNaga_Remnant1
  projectile.affect_times[target] = (projectile.affect_times[target] and projectile.affect_times[target] or 0) + 1
  local hurtTime = 3
  if skillRemnant1 then
    hurtTime = hurtTime - 1
  end
  if hero:isAlive() and hurtTime <= projectile.jumps then
    target:hurt()
  end
  basefunc(projectile, target)
end

function TitanNaga.skill2_projectile_findNextTaeget(basefunc, projectile)
  local skill = projectile.skill
  local min = {
    math.huge,
    math.huge
  }
  local ret
  for unit in ed.engine:foreachAliveUnit(projectile.skill:targetCamp()) do
    if unit == projectile.source then
    elseif unit.buff_effects.untargetable then
    else
      local times = projectile.affect_times[unit] or 0
      if 0 < times then
      else
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, projectile.source.position) - TitanNaga.jump_gap)
        if distanceSQ > min[2] then
        elseif distanceSQ > projectile.skill.min_range_sq and distanceSQ < projectile.skill.max_range_sq then
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  return ret
end

function TitanNaga.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
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
  end
  if maxcount <= 0 then
    return caster.position
  end
end

function TitanNaga.skillatk3_start(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanNaga_atk3
  local originfo = skillatk3.info
  local skillatk3_selfID = 11011904
  local binfo = ed.lookupDataTable("Buff", nil, skillatk3_selfID)
  caster:addBuff(binfo, caster)
  basefunc(skill)
end

function TitanNaga.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanNaga_atk3
  local skillatk3s = caster.skills.TitanNaga_atk3s
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    caster.TitanNaga_atk3Position = TitanNaga.DOP_in_battlefield(caster, 175, caster.foecamp)
  end
  if skillatk3 and caster:isAlive() and not caster.config.is_summoned then
    if attack_counter and attack_counter == 0 then
      caster:setMP(caster.mp + 150)
      if ed.run_with_scene then
        local effect_atk3 = "eff_point_TitanNaga_atk3.cha"
        local effect_atk32 = "eff_point_TitanNaga_atk32.cha"
        caster.TitanNaga_effectatk31 = ed.scene:playEffectOnScene(effect_atk3, {
          caster.TitanNaga_atk3Position[1],
          60
        }, {
          caster.direction,
          1
        }, nil, -1)
        caster.TitanNaga_effectatk32 = ed.scene:playEffectOnScene(effect_atk32, {
          caster.TitanNaga_atk3Position[1],
          60
        }, {
          caster.direction,
          1
        }, nil, 1)
      end
      skillatk3:takeEffectAt(caster.TitanNaga_atk3Position, caster)
    end
    if attack_counter and attack_counter == 1 then
      skillatk3:takeEffectAt(caster.TitanNaga_atk3Position, caster)
      caster.TitanNaga_atk3Position = nil
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 11011904 then
          caster:removeBuff(tbuff)
        end
      end
    end
  end
  skill.attack_counter = skill.attack_counter + 1
end

function TitanNaga.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanNaga_atk4_list = {}
  hero.TitanNaga_ult_MirrorList = {}
  hero.TitanNaga_mirror_count = 0
  local skillatk4 = hero.skills.TitanNaga_atk4
  if skillatk4 then
    local bid = 11011905
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("DODG", skillatk4.info["Script Arg2"])
    buff.update = override(buff.update, TitanNaga.TitanNaga_atk4buff_update)
    hero:addBuff(buff, hero)
    buff.attack_timer = 1
    buff.lastNum = 0
  end
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanNaga.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanNaga.rage_buff_update(basefunc, buff, dt)
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

function TitanNaga.TitanNaga_atk4buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.TitanNaga_atk4
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    local unit = buff.owner
    local skillatk4 = unit.skills.TitanNaga_atk4
    local num = #unit.TitanNaga_ult_MirrorList
    if num ~= buff.lastNum then
      buff.lastNum = num
      local dodg = skillatk4.info["Script Arg3"] * num
      buff:setAttribute("DODG", skillatk4.info["Script Arg2"] + dodg)
      unit:rebuild()
    end
  end
  buff.attack_timer = timer
end

function TitanNaga.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanNaga_atk4
  local skillatk3 = hero.skills.TitanNaga_atk3
  local skillatk2 = hero.skills.TitanNaga_atk2
  local skillatk = hero.skills.TitanNaga_atk
  if skillatk3 and ed.run_with_scene and hero.current_skill ~= skillatk3 then
    if hero.TitanNaga_effectatk31 then
      ed.scene:removeEffect(hero.TitanNaga_effectatk31, -1)
    end
    if hero.TitanNaga_effectatk32 then
      ed.scene:removeEffect(hero.TitanNaga_effectatk32, 1)
    end
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanNaga.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanNaga.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanNaga.ragelosthp
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
    while hero.lastRageHp - hero.hp >= TitanNaga.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanNaga.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanNaga.init_hero(hero)
  hero.reset = override(hero.reset, TitanNaga.hero_reset)
  hero.update = override(hero.update, TitanNaga.hero_update)
  local skillatk = hero.skills.TitanNaga_atk
  local skillatk2 = hero.skills.TitanNaga_atk2
  local skillatk3 = hero.skills.TitanNaga_atk3
  local skillatk4 = hero.skills.TitanNaga_atk4
  local skillult = hero.skills.TitanNaga_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanNaga.skillult_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanNaga.skillatk2_createProjectile)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanNaga.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanNaga.skillatk3_onAttackFrame)
  end
  return hero
end

return TitanNaga.init_hero
