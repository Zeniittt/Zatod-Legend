module("ed.battlehero", package.seeall)
local ed = ed
TitanEnch = {}
TitanEnch.Flower_range = 75
TitanEnch.FlowerLast_time = 6
TitanEnch.FlowerStart_time = 1.5
TitanEnch.atk2_buffID = 1601
TitanEnch.TitanEnch_fashion_ID = 100931
TitanEnch.interval = {
  {40, 20},
  {20, 10},
  {30, 15},
  {10, 5},
  {-40, -20},
  {-20, -10},
  {-30, -15},
  {-10, -5}
}

function TitanEnch.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  local BasicNum = originfo["Basic Num"]
  if TitanEnch.TitanEnch_fashion_ID and TitanEnch.TitanEnch_fashion_ID == caster.fashion_id then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_TitanEnch_skin_atk.cha"
    })
  end
  basefunc(skill, target)
end

function TitanEnch.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.TitanEnchatk2_region then
    return false, "TitanEnch_atk2:CD or Alreay have one."
  else
    return basefunc(skill, target)
  end
end

function TitanEnch.skillatk2_createRegion(basefunc, skill)
  local TitanEnch_atk2Region = basefunc(skill)
  local caster = skill.caster
  local TitanEnch_atk2Region_position = {
    caster.position[1],
    caster.position[2]
  }
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    unit.get_region_buff = false
  end
  caster.TitanEnchatk2_region = TitanEnch_atk2Region
  TitanEnch_atk2Region.position = TitanEnch_atk2Region_position
  TitanEnch_atk2Region.update = override(TitanEnch_atk2Region.update, TitanEnch.skillatk2_Region_update)
  TitanEnch_atk2Region.terminate = override(TitanEnch_atk2Region.terminate, TitanEnch.skillatk2_Region_Terminated)
  TitanEnch_atk2Region.takeRegionEffectOn = override(TitanEnch_atk2Region.takeRegionEffectOn, TitanEnch.skillatk2_region_takeRegionEffectOn)
  return TitanEnch_atk2Region
end

function TitanEnch.skillatk2_Region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == TitanEnch.atk2_buffID then
        unit.get_region_buff = true
      end
    end
  end
end

function TitanEnch.skillatk2_Region_Terminated(basefunc, region)
  basefunc(region)
  local caster = region.caster
  caster.TitanEnchatk2_region = nil
end

function TitanEnch.skillatk2_region_takeRegionEffectOn(basefunc, self, unit)
  local caster = self.caster
  local skillatk2 = caster.skills.TitanEnch_atk2
  local con_temp = 0
  if caster.attribs.CON then
    con_temp = caster.attribs.CON
  end
  if self.skill.what == "magic" then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  local buff_origTime = buff.info.Time
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  local buff_origTime = buff.info.Time
  local buff_maxTime = skillatk2.info["Script Arg2"]
  if caster:isAlive() and unit.get_region_buff ~= true then
    local TitanEnchINT_Time = buff_origTime + math.floor(caster.attribs.INT / 3000)
    if unit.attribs.TEN then
      TitanEnchINT_Time = (buff_origTime + math.floor(caster.attribs.INT / 3000)) * (1 - (unit.attribs.TEN - con_temp) / 100)
    else
      TitanEnchINT_Time = buff_origTime + math.floor(caster.attribs.INT / 3000)
    end
    buff.timer = math.min(buff_maxTime, TitanEnchINT_Time)
    unit:addBuff(buff)
  end
end

function TitanEnch.skillatk3_power(basefunc, skill, source, target, damage_type)
  local origin_power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if TitanEnch.TitanEnch_fashion_ID and TitanEnch.TitanEnch_fashion_ID == caster.fashion_id then
    return 1.5 * origin_power, 1
  else
    return origin_power, 1
  end
end

function TitanEnch.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  if caster:isAlive() and not caster.config.is_summoned then
    buff.onDamaged = override(buff.onDamaged, TitanEnch.skillatk3_buffonDamaged)
  end
  if TitanEnch.TitanEnch_fashion_ID and TitanEnch.TitanEnch_fashion_ID == caster.fashion_id then
    local HPR = buff.info.HPR
    local TEN = owner.attribs.TEN
    buff:setAttribute("HPR", HPR * 1.5)
    buff:setAttribute("TEN", 20)
    buff:setAttribute("Effect", "eff_buff_TitanEnch_skin_atk3.cha")
  end
  return buff
end

function TitanEnch.skillatk3_buffonDamaged(basefunc, buff, damage, damage_type, source, skill)
  local dmg = basefunc(buff, damage, damage_type, source)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = buff.skill or caster.skills.TitanEnch_atk3
  local damage_down = (1 - skillatk3.info["Script Arg2"] / 100) * dmg
  local mp_gain = (dmg - damage_down) * owner.info["MP Gain Rate"] / owner.attribs.HP * (owner.attribs.MPRatio * 0.01 + 1)
  if skillatk3 and source and source:isAlive() then
    dmg = damage_down
  end
  owner:setMP(owner.mp + mp_gain * ed.engine.mp_bonus)
  return dmg
end

function TitanEnch.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local ran = math.floor(ed.rand() * 8) + 1
  local DOP_position = TitanEnch.DOP_in_battlefield(caster, 50, caster.foecamp)
  local target_position = {
    TitanEnch.interval[ran][1] * caster.direction + DOP_position[1],
    TitanEnch.interval[ran][2] + DOP_position[2]
  }
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  if target_position[1] > ed.engine.stage_rect.maxX then
    target_position[1] = 750
  elseif target_position[1] < ed.engine.stage_rect.minX then
    target_position[1] = 50
  end
  projectile.position = target_position
  projectile.update = override(projectile.update, TitanEnch.skillatk4_projectile_update)
  return projectile
end

function TitanEnch.skillatk4_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 20 then
    projectile:terminate()
    local skill = caster.skills.TitanEnch_atk4s
    if skill then
      skill:selectTarget()
      local projectile2 = ed.ProjectileCreate(skill)
      projectile2.height = 1
      projectile2.position = {
        projectile.position[1],
        projectile.position[2]
      }
      projectile2.update = override(projectile2.update, TitanEnch.atk4s_tile_update)
      ed.engine:addProjectile(projectile2)
    end
  end
end

function TitanEnch.atk4s_tile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local skill = projectile.skill
  local caster = projectile.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.totalTime > TitanEnch.FlowerLast_time then
    skill:takeEffectAt(projectile.position, projectile)
    projectile:terminate()
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_TitanEnch_atk4.cha", {
        projectile.position[1],
        projectile.position[2] - 1
      }, {
        projectile.direction * 0.75,
        0.75
      }, nil, 1)
    end
  elseif projectile.totalTime > TitanEnch.FlowerStart_time then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.buff_effects.invulnerable then
        local unitDistance = ed.edpDistanceSQ(unit.position, projectile.position) ^ 0.5
        if unitDistance <= TitanEnch.Flower_range then
          skill:takeEffectAt(projectile.position, projectile)
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_impact_TitanEnch_atk4.cha", {
              projectile.position[1],
              projectile.position[2] - 1
            }, {
              projectile.direction * 0.75,
              0.75
            }, nil, 1)
          end
          projectile:terminate()
          break
        end
      end
    end
  end
end

function TitanEnch.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4s = caster.skills.TitanEnch_atk4s
  local buff_origTime = buff.info.Time
  local skillatk4s_hitRatio = skillatk4s.info["Script Arg3"] / 100
  local con_temp = 0
  local INT_CvsT = caster.attribs.INT - target.attribs.INT
  local ran = ed.rand()
  if caster.attribs.CON then
    con_temp = caster.attribs.CON
  end
  if caster:isAlive() and skillatk4s then
    local TitanEnchINT_Time = buff_origTime + math.floor(caster.attribs.INT / 3000)
    if target.attribs.TEN then
      TitanEnchINT_Time = (buff_origTime + math.floor(caster.attribs.INT / 3000)) * (1 - (target.attribs.TEN - con_temp) / 100)
    else
      TitanEnchINT_Time = buff_origTime + math.floor(caster.attribs.INT / 3000)
    end
    buff.timer = TitanEnchINT_Time
  end
  if INT_CvsT <= 0 then
    if skillatk4s_hitRatio > ran then
      return buff
    else
    end
  else
    skillatk4s_hitRatio = skillatk4s_hitRatio + INT_CvsT / 100000
    if ran < skillatk4s_hitRatio then
      return buff
    else
    end
  end
  return buff
end

function TitanEnch.DOP_in_battlefield(caster, radius, camp)
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

function TitanEnch.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanEnch_ult
  local TitanEnch_ratio = skillult.info["Script Arg2"] / 100
  local ultRatio = math.floor(caster.attribs.AP) / 2500
  local buff_origTime = buff.info.Time
  local buff_maxTime = 7
  local TitanEnch_RemnantSkill = caster.skills.TitanEnch_Remnant
  if caster and TitanEnch_RemnantSkill then
    buff_origTime = buff_origTime + 1
    buff_maxTime = 8
  end
  ultRatio = ultRatio / 100 * (1 + TitanEnch_ratio)
  if caster:isAlive() and skillult then
    buff:setAttribute("AD", caster.attribs.AP * ultRatio)
    buff:setAttribute("AP", caster.attribs.AP * ultRatio)
    buff:setAttribute("HAST", (ultRatio + TitanEnch_ratio) * 100)
    buff:setAttribute("MSPD", (ultRatio + TitanEnch_ratio) * 100)
    local TitanEnchINT_Time = buff_origTime + math.floor(caster.attribs.INT / 3000)
    buff:setAttribute("Time", math.min(buff_maxTime, TitanEnchINT_Time))
    buff.info.Time = math.min(buff_maxTime, TitanEnchINT_Time)
    buff.timer = math.min(buff_maxTime, TitanEnchINT_Time)
  end
  return buff
end

function TitanEnch.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if caster:isAlive() and attack_counter == 0 and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanEnch_ult.cha", {400, 0}, {0.8, 0.8}, nil, 0)
  end
  basefunc(skill)
end

function TitanEnch.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanEnchatk2_region = nil
end

function TitanEnch.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function TitanEnch.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanEnchatk2_region then
    hero.TitanEnchatk2_region:terminate()
    hero.TitanEnchatk2_region = nil
  end
end

function TitanEnch.TitanEnch_skillallgetDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local power_Ratio = 0.1
  local power = power * power_Ratio
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function TitanEnch.init_hero(hero)
  local skillult = hero.skills.TitanEnch_ult
  local skillatk = hero.skills.TitanEnch_atk
  local skillatk2 = hero.skills.TitanEnch_atk2
  local skillatk3 = hero.skills.TitanEnch_atk3
  local skillatk4 = hero.skills.TitanEnch_atk4
  local skillatk4s = hero.skills.TitanEnch_atk4s
  hero.reset = override(hero.reset, TitanEnch.hero_reset)
  hero.update = override(hero.update, TitanEnch.hero_update)
  hero.die = override(hero.die, TitanEnch.hero_die)
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanEnch.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, TitanEnch.skillult_createBuff)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, TitanEnch.skillatk_start)
  end
  if skillatk2 then
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, TitanEnch.skillatk2_canCastWithTarget)
    skillatk2.createRegion = override(skillatk2.createRegion, TitanEnch.skillatk2_createRegion)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanEnch.skillatk3_createBuff)
    skillatk3.power = override(skillatk3.power, TitanEnch.skillatk3_power)
  end
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, TitanEnch.skillatk4_createProjectile)
  end
  if skillatk4s then
    skillatk4s.createBuff = override(skillatk4s.createBuff, TitanEnch.skillatk4s_createBuff)
  end
  local skillnames = {
    "_ult",
    "_atk2",
    "_atk3",
    "_atk4",
    "_atk4s"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["TitanEnch" .. skillnames[i]]
    if hero.name ~= "TitanEnch" or not hero.config.is_summoned then
    end
  end
  return hero
end

return TitanEnch.init_hero
