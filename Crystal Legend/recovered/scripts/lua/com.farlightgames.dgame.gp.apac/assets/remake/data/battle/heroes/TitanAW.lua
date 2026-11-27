module("ed.battlehero", package.seeall)
local ed = ed
TitanAW = {}

function TitanAW.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk3 = hero.skills.TitanAW_atk3
  local skillult = hero.skills.TitanAW_ult
  if skillatk3 then
    hero.TitanAW_atk3_damaged = true
    hero.TitanAW_atk3_timer = 0
  end
  local skillenter = hero.skills.TitanAW_enter
  if skillenter then
    local bid = 651
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.enter_buff = hero:addBuff(binfo, hero)
    local dir = hero:getInitDir()
    hero:setPosition({
      400 - 200 * dir,
      0
    })
  end
  hero.TitanAW_enter_casted = false
end

function TitanAW.skillenter_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = -1
    end
  end
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanAW.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = -1
    end
  end
  caster.TitanAW_enter_casted = true
end

function TitanAW.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.TitanAW_atk3
  if hero.TitanAW_atk3_timer then
    hero.TitanAW_atk3_timer = hero.TitanAW_atk3_timer + dt
  end
  if skillatk3 and (hero.TitanAW_atk3_timer >= 3 or hero.TitanAW_hasArcana and hero.TitanAW_hasArcana > 2 and hero.TitanAW_atk3_timer >= 2) and not hero.TitanAW_atk3_damaged then
    hero.TitanAW_atk3_damaged = true
  end
end

function TitanAW.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.TitanAW_atk3_damaged and (lost > 0.08 * hero.attribs.HP or 40000 < lost) then
    hero.TitanAW_atk3_damaged = false
    hero.TitanAW_atk3_timer = 0
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_TitanAW_atk3.cha", hero.position, {
        hero.direction * 1,
        1
      }, nil, 1)
    end
    local skillatk3 = hero.skills.TitanAW_atk3
    if skillatk3 then
      hero:takeHeal(skillatk3.info["Script Arg2"], "mp", hero)
    end
    return 0
  else
    return lost
  end
end

function TitanAW.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local region_position = TitanAW.DOP_in_battlefield(caster, 180, caster.foecamp)
  skill.target = caster
  local region = skill:createRegion()
  region.position = region_position
  region.update = override(region.update, TitanAW.skillatk2_region_update)
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanAW.skillatk2_takeRegionEffectOn)
  caster.skillatk2_region_position = region_position
  caster.skillatk2_region_timer = 1.5
  ed.engine:addRegion(region)
  local MPGR = caster.attribs.MPGainRatio or 0
  if MPGR then
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
end

function TitanAW.skillatk2_takeRegionEffectOn(basefunc, self, unit)
  local hero = self.skill.caster
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function TitanAW.skillatk2_region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  if caster.skillatk2_region_timer then
    caster.skillatk2_region_timer = caster.skillatk2_region_timer - dt
  end
  if caster.skillatk2_region_timer and caster.skillatk2_region_timer <= 0 and caster.skillatk2_region_position then
    local skillatk2s = caster.skills.TitanAW_atk2s or caster.skills.TitanAW2_atk2s
    skillatk2s:takeEffectAt(region.position, caster)
    caster.skillatk2_region_timer = 1.5
  end
end

function TitanAW.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.update = override(buff.update, TitanAW.skillatk2buff_update)
  buff.knock_count = 0
  return buff
end

function TitanAW.skillatk2buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.knock_count = buff.knock_count - 1
  local caster = buff.caster
  local owner = buff.owner
  local region_position = caster.skillatk2_region_position
  local time = 0.05
  local distance = -2
  local distanceplus = 0
  local distance_last = -2
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, region_position)
  local range = 30
  local atk2_range = 180
  if buff.knock_count < 0 then
    if owner.position[1] == region_position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    elseif DistanceSQ < range * range then
      local directionold = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      direction[1] = -directionold[2]
      direction[2] = directionold[1]
      distance_last = distance + distanceplus
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = distance + distanceplus * (atk2_range - math.sqrt(DistanceSQ)) / (atk2_range - range)
    end
    owner:knockup(time, ed.edpMult(direction, distance_last), true)
    buff.knock_count = 0
  end
end

function TitanAW.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unit.buff_effects.invulnerable then
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
    return caster.position
  end
end

function TitanAW.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4637
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanAW.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4637 then
      tbuff.timer = 0
    end
  end
end

function TitanAW.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4637
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanAW.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4637 then
      tbuff.timer = 0
    end
  end
end

function TitanAW.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local result, reason = basefunc(skill, target)
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit:isAlive() and unit.info.Name == "TitanAW2" and unit.father == caster then
      return false
    end
  end
  return result
end

function TitanAW.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skilllevel = {
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level
  }
  local proto = {
    _tid = 322,
    _level = skill.level or 1,
    _stars = caster.stars,
    _skill_levels = skilllevel,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local TitanAW2 = ed.UnitCreate(proto, caster.camp, config)
  TitanAW2.direction = caster.direction
  local locationTitanAW2 = {
    caster.position[1] + caster.direction * 85,
    caster.position[2] + 5
  }
  ed.engine:summonUnit(TitanAW2, locationTitanAW2, caster, "Idle")
  TitanAW2.father = caster
  caster:setPosition({
    caster.position[1] - caster.direction * 75,
    caster.position[2]
  })
  TitanAW2.die = override(TitanAW2.die, function(basefunc, unit, killer)
    if not ed.engine.running then
      unit:setDeathWithEffectOrNot(true)
    end
    basefunc(unit, killer)
  end)
  TitanAW2.alive_time = 25
  TitanAW2.reset = override(TitanAW2.reset, TitanAW.TitanAW2_reset)
  TitanAW2.update = override(TitanAW2.update, TitanAW.TitanAW2_update)
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 4641)
  TitanAW.changeBuffInfo(AttriBinfo, skill.info["Script Arg3"], TitanAW2, 1)
  local buff = TitanAW2:addBuff(AttriBinfo, caster)
  TitanAW2:takeHeal(math.min(TitanAW2.attribs.HP, 1000000), "hp", caster)
  local TitanAW2_skillatk2 = TitanAW2.skills.TitanAW2_atk2
  local TitanAW2_skillatk3 = TitanAW2.skills.TitanAW2_atk3
  local TitanAW2_skillatk4 = TitanAW2.skills.TitanAW2_atk4
  if TitanAW2_skillatk2 then
    TitanAW2_skillatk2.onAttackFrame = override(TitanAW2_skillatk2.onAttackFrame, TitanAW.skillatk2_onAttackFrame)
    TitanAW2_skillatk2.createBuff = override(TitanAW2_skillatk2.createBuff, TitanAW.skillatk2_createBuff)
  end
  if TitanAW2_skillatk3 then
    TitanAW2.getLostHPAfterImmunity = override(TitanAW2.getLostHPAfterImmunity, TitanAW.hero_getLostHPAfterImmunity)
  end
  if TitanAW2_skillatk4 then
    TitanAW2_skillatk4.createRegion = override(TitanAW2_skillatk4.createRegion, TitanAW.skillatk4_createRegion)
    TitanAW2_skillatk4.onAttackFrame = override(TitanAW2_skillatk4.onAttackFrame, TitanAW.TitanAW2_skillatk4_onAttackFrame)
  end
  if caster.TitanAW_hasArcana and caster.TitanAW_hasArcana > 3 then
    local hp_amount = caster.attribs.AP * 2.5
    caster:takeHeal(hp_amount, "hp", caster)
  end
end

function TitanAW.changeBuffInfo(buffInfo, enhance, target, mode)
  local attrib_temp = {}
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
    end
  end
  if buffInfo.ID == 4641 then
    buffInfo.TEN = 10
  end
end

function TitanAW.TitanAW2_reset(basefunc, hero)
  basefunc(hero)
  local TitanAW2_skillatk3 = hero.skills.TitanAW2_atk3
  if TitanAW2_skillatk3 then
    hero.TitanAW_atk3_damaged = true
    hero.TitanAW_atk3_timer = 0
  end
end

function TitanAW.TitanAW2_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 then
      hero:die()
    end
  end
  local TitanAW2_skillatk3 = hero.skills.TitanAW2_atk3
  if hero.TitanAW_atk3_timer then
    hero.TitanAW_atk3_timer = hero.TitanAW_atk3_timer + dt
  else
    hero.TitanAW_atk3_timer = 0
  end
  if TitanAW2_skillatk3 and hero.TitanAW_atk3_timer >= 4 and not hero.TitanAW_atk3_damaged then
    hero.TitanAW_atk3_damaged = true
  end
end

function TitanAW.skillatk4_createRegion(basefunc, skill)
  local TitanAW_atk4Region = basefunc(skill)
  local caster = skill.caster
  local TitanAW_atk4Region_position = {
    caster.position[1],
    caster.position[2]
  }
  TitanAW_atk4Region.position = TitanAW_atk4Region_position
  return TitanAW_atk4Region
end

function TitanAW.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4s = caster.skills.TitanAW_atk4s
  local region_position = {
    caster.position[1],
    caster.position[2]
  }
  skillatk4s.target = caster
  local region = skillatk4s:createRegion()
  region.position = region_position
  ed.engine:addRegion(region)
end

function TitanAW.TitanAW2_skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4s = caster.skills.TitanAW2_atk4s
  local region_position = {
    caster.position[1],
    caster.position[2]
  }
  skillatk4s.target = caster
  local region = skillatk4s:createRegion()
  region.position = region_position
  ed.engine:addRegion(region)
end

function TitanAW.skillatk2s_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.2
  return power
end

function TitanAW.skillult_takeEffectOn(basefunc, skill, target, source)
  local bid = 4627
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, target)
  basefunc(skill, target, source)
end

function TitanAW.init_hero(hero)
  local skillult = hero.skills.TitanAW_ult
  local skillatk2 = hero.skills.TitanAW_atk2
  local skillatk3 = hero.skills.TitanAW_atk3
  local skillatk4 = hero.skills.TitanAW_atk4
  local skillatk2s = hero.skills.TitanAW_atk2s
  local skillatk4s = hero.skills.TitanAW_atk4s
  local skillenter = hero.skills.TitanAW_enter
  hero.TitanAW_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanAW.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanAW.skillatk2_createBuff)
  end
  if skillatk2s and hero.TitanAW_hasArcana and hero.TitanAW_hasArcana > 1 then
    skillatk2s.power = override(skillatk2s.power, TitanAW.skillatk2s_power)
  end
  if skillatk3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanAW.hero_getLostHPAfterImmunity)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanAW.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanAW.skillatk4_finish)
    skillatk4.createRegion = override(skillatk4.createRegion, TitanAW.skillatk4_createRegion)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanAW.skillatk4_onAttackFrame)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanAW.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanAW.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, TitanAW.skillult_start)
    skillult.finish = override(skillult.finish, TitanAW.skillult_finish)
    if hero.TitanAW_hasArcana and hero.TitanAW_hasArcana > 3 then
      skillult.takeEffectOn = override(skillult.takeEffectOn, TitanAW.skillult_takeEffectOn)
    end
  end
  if skillenter then
    skillenter.start = override(skillenter.start, TitanAW.skillenter_start)
    skillenter.finish = override(skillenter.finish, TitanAW.skillenter_finish)
  end
  hero.update = override(hero.update, TitanAW.hero_update)
  hero.reset = override(hero.reset, TitanAW.hero_reset)
  return hero
end

return TitanAW.init_hero
