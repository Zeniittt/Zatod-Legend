module("ed.battlehero", package.seeall)
local ed = ed
BR = {}
BR.nest_level_max = 4
BR.atk2_CD = 1
BR.smallspider_lifetime = 15
BR.atk3buff_damageCD = 1
BR.BR_smallspider_power_atk3ratio = 1.5
BR.BR_smallspider_power_regionratio = 1.2
BR.BR_smallspider_power_lvupratio = 0.15
BR.BR_atk4_in_powerratio = 1.5
BR.BR_ult_buffAD = 3
BR.BR_ult_buffAP = 4.5
BR.BR_ult_lostmp = 0.1
BR.BR_ult_reduceMp_ratio = 0.2
BR.summonspider_mp = 300
BR.awake_position = {
  {75, 0},
  {-75, 0},
  {10, 25},
  {-10, -25}
}
BR.smallspider_Rmax = 5
BR.smallspider_Rmin = 35
BR.smallspider_die_mpamount = 50

function BR.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if not unit.BRnestOriginAD then
      unit.BRnestOriginAD = unit.attribs.AD
    end
  end
  local skillatk2 = hero.skills.BR_atk2
  if hero.name == "BR" and hero:isAlive() and hero.skills.BR_ult and skillatk2 then
    local mpcost = skillatk2.info["Script Arg2"]
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      mpcost = mpcost - skillatk2.evo_rank3["Script Arg1"]
    end
    if hero.BR_haveNest and hero.BRnest and mpcost <= hero.mp then
      local skillatk3_nest = hero.BRnest.skills.BRnest_atk3
      if not skillatk3_nest.casting then
        hero.BRnest:castSkill(skillatk3_nest, nil)
      end
    end
  end
end

function BR.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.BRnest and hero.BRnest.nest_region then
    hero.BRnest.nest_region:finish()
  end
  if hero.BRnest and hero.BRnest:isAlive() then
    hero.BRnest:die()
    if ed.run_with_scene and hero.ult_region_effect then
      local z = -1
      ed.scene:removeEffect(hero.ult_region_effect, z)
    end
  end
  for i, unit in ipairs(hero.BR_smallspiderlist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
end

function BR.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if not caster.BR_haveNest then
    BR.BR_summon_nest(caster)
    caster.BR_haveNest = true
  end
end

function BR.skillult_finish(basefunc, skill)
  basefunc(skill)
  if skill.caster.BRnest then
    skill.caster.BRnest:setAction("atk3", false, false)
  end
end

function BR.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local result, reason = basefunc(skill, target)
  if not result or hero.BR_haveNest or hero.current_skill == hero.manual_skill then
    return false
  end
  return true
end

function BR.BR_summon_nest(hero)
  local skillult = hero.skills.BR_ult
  local skillevel = {
    skillult.level,
    skillult.level,
    skillult.level
  }
  local dir = hero:getInitDir()
  local proto = {
    _tid = 249,
    _level = skillult.level or 1,
    _skill_levels = skillevel,
    _stars = hero.stars,
    _rank = hero.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = hero.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or hero.config.hp_mod,
    dps_mod = hero.config.dps_mod or 1
  }
  local nest = ed.UnitCreate(proto, hero.camp, config)
  nest.die = override(nest.die, BR.nest_die)
  nest.direction = hero.direction
  local nest_position = {
    ed.engine.stage_rect.minX + 100,
    0
  }
  if dir == -1 then
    nest_position = {
      ed.engine.stage_rect.maxX - 100,
      0
    }
  end
  hero.nest_position = nest_position
  ed.engine:summonUnit(nest, nest_position, hero, "Idle")
  nest.update = override(nest.update, BR.nest_update)
  local bid = 11004901
  local binfo606 = ed.lookupDataTable("Buff", nil, bid)
  local buff = nest:addBuff(binfo606, nest)
  hero.BRnest = nest
  local nest_skillatk2 = nest.skills.BRnest_atk2
  local nest_skillatk3 = nest.skills.BRnest_atk3
  local skillatk2 = hero.skills.BR_atk2
  nest_skillatk3.onAttackFrame = override(nest_skillatk3.onAttackFrame, BR.BRnest_atk3_onAttackFrame)
  nest_skillatk2.createBuff = override(nest_skillatk2.createBuff, BR.BRnest_atk2_createBuff)
  nest_skillatk2.target = nest
  local region = nest_skillatk2:createRegion()
  region.update = override(region.update, BR.nest_region_update)
  region.terminate = override(region.terminate, BR.nest_region_terminate)
  nest.nest_region = region
  ed.engine:addRegion(region)
  if ed.run_with_scene then
    local effect_name = "eff_point_BR_ult_2.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, {
      hero.nest_radius[1.5 - 0.5 * dir][1],
      0
    }, {dir, 1}, nil, -1, nil, nil, nil)
    hero.ult_region_effect = effect
  end
end

function BR.nest_update(basefunc, nest, dt)
  basefunc(nest, dt)
  if not nest.config.summoner:isAlive() then
    nest:die()
    if nest.config.summoner.ult_region_effect then
      local z = -1
      ed.scene:removeEffect(nest.config.summoner.ult_region_effect, z)
    end
  end
end

function BR.BRnest_atk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local BRnest = skill.caster
  local BRlocal = BRnest.config.summoner
  local owner = buff.owner
  buff.update = override(buff.update, BR.nest_region_buffUpdate)
  buff.friend_number = 0
  buff.enemy_number = 0
  return buff
end

function BR.nest_die(basefunc, hero, killer)
  basefunc(hero, killer)
  hero.BRnest = nil
  hero.nest_position = nil
end

function BR.check_unit_in_region(unit, hero)
  local nest_level = hero.nest_level
  local dir = hero:getInitDir()
  local radius = hero.nest_radius[1.5 - 0.5 * dir][nest_level]
  if dir == 1 and radius >= unit.position[1] and unit.position[1] >= ed.engine.stage_rect.minX or dir == -1 and radius <= unit.position[1] and unit.position[1] <= ed.engine.stage_rect.maxX then
    return true
  else
    return false
  end
end

function BR.check_unit_number_in_region(camp, hero)
  local count = 0
  for unit in ed.engine:foreachAliveUnit(camp) do
    if not unit.config.is_summoned then
      count = count + 1
    elseif not unit.buff_effects.building then
      local skillult = hero.skills.BR_ult
      if skillult then
        if skillult.evo_rank and skillult.evo_rank >= 3 and camp == hero.camp then
          count = count + skillult.evo_rank3["Script Arg1"]
        else
          count = count + 0.1
        end
      else
        count = count + 0.1
      end
    end
  end
  return count
end

function BR.nest_region_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local BR_nest = buff.caster
  local BRlocal = BR_nest.config.summoner
  local owner = buff.owner
  local level = BRlocal.skills.BR_ult.level
  local skillult = BRlocal.skills.BR_ult
  if owner.camp == BRlocal.camp then
    local friend_number = BR.check_unit_number_in_region(BRlocal.camp, BRlocal)
    if buff.friend_number ~= friend_number and skillult then
      local AD = BRlocal.skills.BR_ult.info["Script Arg2"]
      local ADper = BRlocal.skills.BR_ult.info["Script Arg3"] / 100
      local BRnestOriginAD = owner.BRnestOriginAD or 0
      if owner.name == "BlackFish" or owner.name == "WhiteFish" then
        for unit in ed.engine:foreachAliveUnit(owner.camp) do
          if unit.name == "AW" then
            BRnestOriginAD = unit.BRnestOriginAD or 0
          end
        end
      end
      buff:setAttribute("AD", AD * friend_number + ADper * friend_number * BRnestOriginAD)
      buff.friend_number = friend_number
      owner:rebuild()
    end
  elseif owner.camp == BRlocal.foecamp then
    local enemy_number = BR.check_unit_number_in_region(BRlocal.foecamp, BRlocal)
    if buff.enemy_number ~= enemy_number and skillult then
      local AD = BRlocal.skills.BR_ult.info["Script Arg4"]
      local ADper = BRlocal.skills.BR_ult.info["Script Arg5"] / 100
      local BRnestOriginAD = owner.BRnestOriginAD or 0
      if owner.name == "BlackFish" or owner.name == "WhiteFish" then
        for unit in ed.engine:foreachAliveUnit(owner.camp) do
          if unit.name == "AW" then
            BRnestOriginAD = unit.BRnestOriginAD or 0
          end
        end
      end
      if 0 < enemy_number then
        buff:setAttribute("AD", -(AD / enemy_number + ADper * BRnestOriginAD / enemy_number))
      end
      buff.enemy_number = enemy_number
      owner:rebuild()
    end
  end
end

function BR.nest_region_update(basefunc, region, dt)
  local caster = region.caster.config.summoner
  local nest_level = caster.nest_level
  local dir = caster:getInitDir()
  local radius = caster.nest_radius[1.5 - 0.5 * dir][nest_level]
  if region.birthtick == ed.engine.ticks then
    return
  end
  ed.Entity.update(region, dt)
  region.timer = region.timer - dt
  if not region.terminated and region.timer >= 0 then
    for unit in ed.engine:foreachAliveUnit(region.affect_camp) do
      if not unit.buff_effects.invulnerable and not unit.config.is_summoned then
        if BR.check_unit_in_region(unit, caster) then
          if not unit.region_list[region.uniquenessID] then
            region:takeRegionEffectOn(unit)
          end
        elseif unit.region_list[region.uniquenessID] then
          region:abolishRegionEffectOn(unit)
        end
      end
    end
  else
    region:terminate()
  end
end

function BR.nest_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster.ult_region_effect then
    local z = -1
    ed.scene:removeEffect(caster.ult_region_effect, z)
  end
end

function BR.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.BR_smallspiderlist = {}
  hero.nestatk3up = nil
  hero.BR_haveNest = nil
  hero.BRnest = nil
  hero.nest_level = 1
  hero.atk2_AI_minHPratio = 0
  hero.atk2_AI_minHPratio_nest = 0
  hero.atk2_AI_nestlevel = 0
  hero.atk2_CD = BR.atk2_CD
  hero.ori_foecamp = hero.foecamp
  local scene_long = ed.engine.stage_rect.maxX - ed.engine.stage_rect.minX
  hero.nest_radius = {
    {scene_long},
    {0}
  }
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    unit.BRnestOriginAD = unit.attribs.AD
  end
end

function BR.BRnest_atk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local BRnest = skill.caster
  local BRlocal = BRnest.config.summoner
  local skillatk2 = BRlocal.skills.BR_atk2
  local skillevel = {
    skillatk2.level,
    skillatk2.level,
    skillatk2.level
  }
  local dir = BRnest:getInitDir()
  local r = ed.rand() * (BR.smallspider_Rmax - BR.smallspider_Rmin) + BR.smallspider_Rmin
  local angle = ed.rand() * 180 + 180
  local smallspider_position = {
    BRlocal.nest_position[1] + r * math.cos(math.rad(angle)),
    BRlocal.nest_position[2] + r * math.sin(math.rad(angle))
  }
  local skillatk2 = BRlocal.skills.BR_atk2
  if skillatk2 then
    local mpcost = skillatk2.info["Script Arg2"]
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      mpcost = mpcost - skillatk2.evo_rank3["Script Arg1"]
    end
    BRlocal:setMP(BRlocal.mp - mpcost)
  end
  for i = 1, 1 do
    local proto = {
      _tid = 250,
      _level = skillatk2.level or 1,
      _skill_levels = skillevel,
      _stars = BRlocal.stars,
      _rank = BRlocal.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = BRlocal.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or BRlocal.config.hp_mod,
      dps_mod = BRlocal.config.dps_mod or 1
    }
    local smallspider = ed.UnitCreate(proto, BRlocal.camp, config)
    local smallspider_atk2 = smallspider.skills.BRsmallspider_atk2
    smallspider.die = override(smallspider.die, BR.smallspider_die)
    smallspider.update = override(smallspider.update, BR.smallspider_update)
    smallspider.ai.searchTarget = override(smallspider.ai.searchTarget, BR.smallspider_ai_searchTarget)
    smallspider.direction = BRlocal.direction
    smallspider.smallspider_lifetime = BR.smallspider_lifetime
    smallspider_atk2.finish = override(smallspider_atk2.finish, BR.smallspider_atk2_finish)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      smallspider_atk2.takeEffectOn = override(smallspider_atk2.takeEffectOn, BR.smallspider_atk2_takeEffectOn)
    end
    smallspider_atk2.power = override(smallspider_atk2.power, BR.smallspider_atk2_power)
    smallspider_atk2.canCastWithTarget = override(smallspider_atk2.canCastWithTarget, BR.smallspider_atk2_canCastWithTarget)
    for unit in ed.engine:foreachAliveUnit(smallspider.foecamp) do
      if unit.BR_atk3_buff then
        smallspider.smallspider_ai_target = unit
        break
      end
    end
    ed.engine:summonUnit(smallspider, smallspider_position, BRlocal, "Birth")
    local actor = smallspider.actor
    local bid = 11004907
    local binfo606 = ed.lookupDataTable("Buff", nil, bid)
    local buff = smallspider:addBuff(binfo606, smallspider)
    table.insert(BRlocal.BR_smallspiderlist, smallspider)
  end
end

function BR.smallspider_die(basefunc, smallspider, killer)
  local BRlocal = smallspider.config.summoner
  local skillatk2 = BRlocal.skills.BR_atk2
  if skillatk2 and skillatk2.evo_rank and skillatk2.evo_rank >= 3 and BR.check_unit_in_region(smallspider, BRlocal) and smallspider:isAlive() then
    BRlocal:takeHeal(skillatk2.evo_rank3["Script Arg1"], "mp", smallspider)
  end
  basefunc(smallspider, killer)
end

function BR.smallspider_update(basefunc, smallspider, dt)
  basefunc(smallspider, dt)
  smallspider.smallspider_lifetime = smallspider.smallspider_lifetime - dt
  if smallspider.smallspider_lifetime <= 0 then
    smallspider:die()
  end
end

function BR.smallspider_atk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die()
end

function BR.smallspider_atk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local BRlocal = skill.caster.config.summoner
  local skillult = BRlocal.skills.BR_ult
  local skillatk2 = BRlocal.skills.BR_atk2
  local skillatk3 = BRlocal.skills.BR_atk3
  local powerratio = 0.05
  if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
    powerratio = skillatk2.evo_rank1["Script Arg1"]
  end
  if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
    powerratio = skillatk2.evo_rank2["Script Arg1"]
  end
  power = (caster.config.summoner.attribs.AD + caster.config.summoner.attribs.AP) * powerratio + skillatk2.info["Script Arg3"]
  if target.BR_atk3_buff then
    power = power * skillatk3.info["Script Arg2"]
  end
  return power
end

function BR.smallspider_atk2_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local ai_target = skill.caster.ai.target
  if result and target ~= ai_target then
    result = nil
  end
  return result
end

function BR.smallspider_atk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local BRlocal = caster.config.summoner
  if result and target:isAlive() and skill.attack_counter == 4 and (not target.buff_effects.invulnerable or target.buff_effects.uncontrollable) then
    local bid = 11004906
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
end

function BR.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function BR.smallspider_ai_searchTarget(basefunc, ai)
  local smallspider = ai.owner
  local target, minDistanSQ = basefunc(ai)
  local skillatk2 = smallspider.skills.BRsmallspider_atk2
  local BRlocal = smallspider.config.summoner
  if smallspider.smallspider_ai_target and smallspider.smallspider_ai_target:isAlive() and not smallspider.smallspider_ai_target.buff_effects.untargetable and not smallspider.smallspider_ai_target.buffManager.invisible and not smallspider.smallspider_ai_target.config.is_summoned then
    local distanceSQ_havetarget = BR.twoPointDistanceSQ(smallspider.position, smallspider.smallspider_ai_target.position)
    return smallspider.smallspider_ai_target, distanceSQ_havetarget
  end
  local distanceSQ = 9999
  local minHp = 9999999
  for unit in ed.engine:foreachAliveUnit(smallspider.foecamp) do
    if unit ~= smallspider and not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.config.is_summoned and unit.position[1] <= ed.engine.stage_rect.maxX and unit.position[1] >= ed.engine.stage_rect.minX then
      local Hp = unit.hp
      if minHp > Hp then
        minHp = Hp
        target = unit
        distanceSQ = BR.twoPointDistanceSQ(smallspider.position, unit.position)
      end
    end
  end
  return target, distanceSQ
end

function BR.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target = skill.target
  if target then
    local target_position = {
      target.position[1],
      target.position[2]
    }
    local distance = ed.edpSub(target_position, skill.caster.position)
    projectile.velocity = ed.edpMult(distance, 1 / t)
    ed.engine:addProjectile(projectile)
  end
  return projectile
end

function BR.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local fashionId = caster.fashion_id
  owner.BR_atk3_buff = buff
  local buffInfo = buff.info
  local owner = buff.owner
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  buff.skill = skill
  buff.upgrade = override(buff.upgrade, BR.skillatk3_buff_upgrade)
  buff.onRemoved = override(buff.onRemoved, BR.skillatk3_buff_onRemoved)
  return buff
end

function BR.skillatk3_buff_upgrade(basefunc, buff, owner, caster, nextBuffInfo)
  basefunc(buff, owner, caster, nextBuffInfo)
  local skill = buff.skill
  local buffInfo = buff.info
  local owner = buff.owner
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
end

function BR.skillatk3_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if owner.BR_atk3_buff then
    owner.BR_atk3_buff = nil
  end
end

function BR.selectposition_atk4(skill)
  local caster = skill.caster
  local templist = {}
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and not unit.config.is_summoned and not unit:isOutOfStage() then
      table.insert(templist, {unit, 0})
    end
  end
  for i, unit in ipairs(templist) do
    if BR.check_unit_in_region(unit[1], caster) then
      unit[2] = unit[2] + 100
    end
    if unit[1].buff_effects.stun or unit[1].buff_effects.frozen or unit[1].buff_effects.icefrozen or unit[1].buff_effects.immoblilize or unit[1].buff_effects.building then
      unit[2] = unit[2] + 75
    end
  end
  table.sort(templist, function(a, b)
    return a[2] > b[2]
  end)
  if templist and templist[1] then
    return templist[1][1]
  else
    return nil
  end
end

function BR.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.BR_atk4_oriposition = {
    caster.position[1],
    caster.position[2]
  }
  local bid = 11004904
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.atk4target = BR.selectposition_atk4(skill)
  if not caster.atk4target then
    skill:finish()
  end
end

function BR.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target = caster.atk4target
  skill.target = caster.atk4target
  local atk4_position
  if attack_counter == 0 then
    if target then
      atk4_position = target.position
      caster.atk4_target_positon = {}
      caster.atk4_target_positon[1] = target.position[1]
      caster.atk4_target_positon[2] = target.position[2]
      caster:setPosition({
        atk4_position[1],
        ed.engine.stage_rect.maxY
      })
      skill.BR_atk4_ontop = true
      local skillatk4s = caster.skills.BR_atk4
      skill.BR_atk4_firstlist = skillatk4s:collectAoeTarget(atk4_position, caster.direction)
      if ed.run_with_scene then
        local effect_name = "eff_point_BR_atk4.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, atk4_position, {1, 1}, nil, -1, nil, nil, nil)
      end
      skill.attack_counter = skill.attack_counter + 1
    else
      skill:finish()
    end
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 and caster.BR_atk4_oriposition then
    caster:setPosition({
      caster.BR_atk4_oriposition[1],
      caster.BR_atk4_oriposition[2]
    })
    skill.BR_atk4_ontop = nil
  end
end

function BR.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill)
  local caster = skill.caster
  if reason == "interrupt" and skill.BR_atk4_ontop and caster.BR_atk4_oriposition then
    caster:setPosition({
      caster.BR_atk4_oriposition[1],
      caster.BR_atk4_oriposition[2]
    })
    skill.BR_atk4_ontop = nil
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11004904 then
      tbuff.timer = 0
    end
  end
end

function BR.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.height = 150
  projectile.position[1] = caster.atk4_target_positon[1]
  projectile.position[2] = caster.atk4_target_positon[2]
  return projectile
end

function BR.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if skill.evo_rank and skill.evo_rank >= 3 then
    for i, unit in ipairs(skill.BR_atk4_firstlist) do
      if target == unit then
        power = power * skill.evo_rank3["Script Arg1"]
        break
      end
    end
  end
  return power
end

function BR.skillatk4_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  if isHit and skill.evo_rank and skill.evo_rank >= 3 then
    for i, unit in ipairs(skill.BR_atk4_firstlist) do
      if target == unit and not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
        local bid = 11004908
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, skill.caster)
        break
      end
    end
  end
  return isHit, dmg
end

function BR.skillatk4_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if skill.BR_atk4_ontop and ed.engine.beingEnd and caster.BR_atk4_oriposition then
    caster:setPosition({
      caster.BR_atk4_oriposition[1],
      caster.BR_atk4_oriposition[2]
    })
    skill.BR_atk4_ontop = nil
  end
end

function BR.init_hero(hero)
  local skillult = hero.skills.BR_ult
  local skillatk = hero.skills.BR_atk
  local skillatk2 = hero.skills.BR_atk2
  local skillatk3 = hero.skills.BR_atk3
  local skillatk4 = hero.skills.BR_atk4
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BR.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, BR.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BR.skillult_canCastWithTarget)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    skillatk3.createProjectile = override(skillatk3.createProjectile, BR.skillatk3_createProjectile)
    skillatk3.createBuff = override(skillatk3.createBuff, BR.skillatk3_createBuff)
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    skillatk4.start = override(skillatk4.start, BR.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, BR.skillatk4_onAttackFrame)
    skillatk4.createProjectile = override(skillatk4.createProjectile, BR.skillatk4_createProjectile)
    skillatk4.finish = override(skillatk4.finish, BR.skillatk4_finish)
    skillatk4.power = override(skillatk4.power, BR.skillatk4_power)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, BR.skillatk4_takeEffectOn)
  end
  hero.reset = override(hero.reset, BR.hero_reset)
  hero.update = override(hero.update, BR.hero_update)
  hero.die = override(hero.die, BR.hero_die)
  return hero
end

return BR.init_hero
