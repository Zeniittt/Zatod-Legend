module("ed.battlehero", package.seeall)
local ed = ed
Alice = {}
Alice.ult_start_time = 3.5
Alice.hate_bid = 701
Alice.awake_highest_bid = 1230
Alice.awake_level2_bid = 1231
Alice.awake_level3_bid = 1232
Alice.awake_level4_bid = 1233
Alice.awake_hpr_bid = 1234

function Alice.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return false
  end
end

function Alice:hero_markornot()
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == Alice.hate_bid then
      return tbuff
    end
  end
  return false
end

function Alice:hero_addmark()
  local HPper = self.attribs.HP / 10
  local Damagetotal = 0
  for i, unit_list in ipairs(self.DamageList) do
    Damagetotal = unit_list.Damage + Damagetotal
  end
  if HPper <= Damagetotal then
    local maxdamage = 0
    local markunit
    for i, unit_list in ipairs(self.DamageList) do
      if maxdamage <= unit_list.Damage and unit_list.unit:isAlive() and unit_list.unit.camp == self.origin_foecamp then
        maxdamage = unit_list.Damage
        markunit = unit_list.unit
      end
    end
    local isbuff = false
    if markunit then
      local skillawake = self.skills.Alice_awake
      if skillawake then
        Alice.add_hate_buff_awake(markunit, self)
      else
        for i, tbuff in ipairs(markunit.buff_list) do
          if tbuff.info.ID == Alice.hate_bid then
            isbuff = true
          end
        end
        if not isbuff then
          local bid = Alice.hate_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          markunit:addBuff(binfo, self)
        end
      end
    end
    if self.Alice_buff_count and self.Alice_buff_count < 5 then
      self:addBuff(self.skills.Alice_atk4:createBuff(self))
      self.Alice_buff_count = self.Alice_buff_count + 1
    end
    for i, unit_list in ipairs(self.DamageList) do
      unit_list.Damage = 0
    end
  end
end

function Alice.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local finaldamage = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if finaldamage then
    for i, Damage_list in ipairs(self.DamageList) do
      if type(struct_table) == "table" then
        if struct_table.source == Damage_list.unit then
          Damage_list.Damage = Damage_list.Damage + finaldamage
        end
      elseif source and source == Damage_list.unit then
        Damage_list.Damage = Damage_list.Damage + finaldamage
      end
    end
  end
  return finaldamage
end

function Alice.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.DamageList = {}
  for i, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == -hero.camp then
      hero.DamageList[#hero.DamageList + 1] = {unit = unit, Damage = 0}
    end
  end
  hero.origin_foecamp = hero.foecamp
  hero.Alice_buff_count = 0
  local skillawake = hero.skills.Alice_awake
  if skillawake then
    hero.Alice_highest_hero = nil
    hero.Alice_highest_level = 0
    hero.Alice_awake_total_level = 0
    local bid = Alice.awake_hpr_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero.awake_hpr_buff = hero:addBuff(binfo, hero)
  end
end

function Alice.hero_update(basefunc, self, dt)
  if self.buff_list then
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.HPR < 0 then
        local hpr = tbuff.info.HPR * dt
        local HPRdamage = math.min(-hpr, self.hp)
        HPRdamage = HPRdamage * self.dPSStatisticsRatio
        for i, info_list in ipairs(self.DamageList) do
          local unitconfig = info_list.unit.config
          if tbuff.caster == info_list.unit or unitconfig.is_summoned and unitconfig.summoner == tbuff.caster then
            info_list.Damage = info_list.Damage + HPRdamage
          end
        end
      end
    end
  end
  Alice.hero_addmark(self)
  basefunc(self, dt)
end

function Alice.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.BoomDoll_list) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Alice.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local buff = Alice.hero_markornot(target)
  local skillawake = caster.skills.Alice_awake
  local skillsawake = caster.skills.Alice_sawake
  if skillsawake then
    Alice.sawake_hate_buff_effect(skill, target)
  end
  local result = basefunc(skill, target, source)
  if skillawake then
    Alice.awake_hate_buff_effect(skill, target)
  elseif buff and result then
    target:addBuff(caster.skills.Alice_ult_stun:createBuff(target))
    target:removeBuff(buff)
  end
end

function Alice.skillult_projectile_update(basefunc, projectile, dt)
  local caster = projectile.skill.caster
  if projectile.starttime then
    projectile.starttime = projectile.starttime - dt
    if projectile.starttime <= 0 then
      projectile.starttime = nil
      projectile.skill.info = ed.wraptable(projectile.skill.info, {
        ["Tile Gravity"] = -800
      })
    end
  end
  if projectile.height < 100 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Alice_ult.cha", {
        projectile.position[1],
        projectile.position[2] - 1
      }, {
        projectile.direction,
        1
      }, nil, 0)
    end
    projectile.skill.info = projectile.originfo
  end
  basefunc(projectile, dt)
end

function Alice.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.originfo = projectile.skill.info
  projectile.starttime = Alice.ult_start_time
  local positionX = Alice.selectPosition(skill, 300) or 400
  local caster = skill.caster
  local skillawake = caster.skills.Alice_awake
  if skillawake and caster.Alice_highest_hero then
    positionX = caster.Alice_highest_hero.position[1]
  end
  projectile.update = override(projectile.update, Alice.skillult_projectile_update)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_Alice_ult.cha", {
      positionX - 10,
      0
    }, {
      projectile.direction,
      1
    }, 200, 1)
  end
  projectile.height = 190
  projectile.position = {positionX, 0}
  return projectile
end

function Alice.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local buff = Alice.hero_markornot(target)
  local skillawake = caster.skills.Alice_awake
  local skillsawake = caster.skills.Alice_sawake
  if skillsawake then
    Alice.sawake_hate_buff_effect(skill, target)
  end
  local result = basefunc(skill, target, source)
  if skillawake then
    Alice.awake_hate_buff_effect(skill, target)
  elseif buff and result then
    target:removeBuff(buff)
    target:addBuff(caster.skills.Alice_atk2_burn:createBuff(target))
  end
end

function Alice.BoomDoll_atk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster.owner
  local skillsawake = caster.skills.Alice_sawake
  if skillsawake and target then
    Alice.sawake_hate_buff_effect(skill, target)
  end
  basefunc(skill, target, source)
end

function Alice.BoomDoll_atk2_power(basefunc, skill, source, target)
  local power, i = basefunc(skill, source, target)
  local buff = Alice.hero_markornot(target)
  local caster = skill.caster.owner
  local skillawake = caster.skills.Alice_awake
  if skillawake then
    local ratio = Alice.awake_hate_buff_effect(skill, target)
    if 0 < power then
      power = power * ratio
    end
  elseif buff and 0 < power then
    power = power * 2
    target:removeBuff(buff)
  end
  return power, i
end

function Alice.BoomDoll_update(basefunc, self, dt)
  if self.state == ed.emUnitState_Dying then
    if not self.dyingTimer then
      self.dyingTimer = 0.3
    end
    self.dyingTimer = self.dyingTimer - dt
    if self.dyingTimer <= 0 then
      self.dyingTimer = 99999
      local skillatk2 = self.skills.BoomDoll_atk2
      skillatk2.power = override(skillatk2.power, Alice.BoomDoll_atk2_power)
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Alice.BoomDoll_atk2_takeEffectOn)
      skillatk2:takeEffectAt(self.position)
    end
  else
    self.dyingTimer = nil
  end
  basefunc(self, dt)
end

function Alice.skillatk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 20 then
    local BoomDollposition = projectile.position
    projectile:terminate()
    local skillatk3 = caster.skills.Alice_atk3
    local proto = {
      _tid = 202,
      _level = skillatk3.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      },
      _skill_levels = {
        [1] = skillatk3.level or 1,
        [2] = skillatk3.level or 1
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.config.hp_mod or 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local BoomDoll = ed.UnitCreate(proto, caster.camp, config)
    BoomDoll.direction = caster.direction
    local location = {
      BoomDollposition[1],
      BoomDollposition[2]
    }
    ed.engine:summonUnit(BoomDoll, location, caster, "Birth")
    table.insert(caster.BoomDoll_list, BoomDoll)
    BoomDoll.owner = caster
    BoomDoll.update = override(BoomDoll.update, Alice.BoomDoll_update)
  end
end

function Alice.skillatk3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, Alice.skillatk3_projectile_update)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    Alice.selectPosition(skill, 100) or 400,
    0
  }
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function Alice.add_hate_buff_awake(markunit, hero)
  local isbuff, heroinlist
  local level = 0
  local skillawake = hero.skills.Alice_awake
  for i, tbuff in ipairs(markunit.buff_list) do
    if tbuff.info.ID == Alice.hate_bid then
      level = tbuff.Ten_level
      markunit:removeBuff(tbuff)
    end
  end
  if level < 4 then
    local bid = Alice.hate_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = markunit:addBuff(binfo, hero)
    level = level + 1
    buff.Ten_level = level
    Alice.awake_buff_levelup(markunit, hero, level)
    hero.Alice_awake_total_level = hero.Alice_awake_total_level + 1
    hero.awake_hpr_buff:setAttribute("HPR", skillawake.info["Script Arg1"] * hero.Alice_awake_total_level)
    hero:rebuild()
    if level > hero.Alice_highest_level then
      hero.Alice_highest_level = level
      if not hero.Alice_highest_hero then
        hero.Alice_highest_hero = markunit
      end
      local old_hero = hero.Alice_highest_hero
      for i, tbuff in ipairs(old_hero.buff_list) do
        if tbuff.info.ID == Alice.awake_highest_bid then
          old_hero:removeBuff(tbuff)
        end
      end
      local bid = Alice.awake_highest_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = markunit:addBuff(binfo, hero)
      hero.Alice_highest_hero = markunit
    end
  end
end

function Alice.awake_buff_levelup(markunit, hero, level)
  if level == 1 then
  elseif level == 2 then
    local bid = Alice.awake_level2_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = markunit:addBuff(binfo, hero)
  elseif level == 3 then
    for i, tbuff in ipairs(markunit.buff_list) do
      if tbuff.info.ID == Alice.awake_level2_bid then
        markunit:removeBuff(tbuff)
      end
    end
    local bid = Alice.awake_level3_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = markunit:addBuff(binfo, hero)
  elseif level == 4 then
    for i, tbuff in ipairs(markunit.buff_list) do
      if tbuff.info.ID == Alice.awake_level3_bid then
        markunit:removeBuff(tbuff)
      end
    end
    local bid = Alice.awake_level4_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = markunit:addBuff(binfo, hero)
  end
end

function Alice.sawake_hate_buff_effect(skill, target)
  local level
  local caster = skill.caster
  if caster.name ~= "Alice" and caster.owner.name == "Alice" then
    caster = caster.owner
  end
  local skillsawake = caster.skills.Alice_sawake
  if target and target:isAlive() then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == Alice.hate_bid then
        level = tbuff.Ten_level
      end
    end
    if level then
    end
    if level and 0 < level then
      local healHP = caster.attribs.HP * skillsawake.info["Script Arg2"] / 100 * level
      caster:takeHeal(healHP, "hp", caster)
      local ratio = 0.5
      local buff = skillsawake:createBuff(caster)
      buff:setAttribute("AP", caster.attribs.AP * ratio)
      buff:setAttribute("MRI", caster.attribs.MRI * ratio)
      caster:addBuff(buff, caster)
      caster:rebuild()
    end
  end
end

function Alice.awake_hate_buff_effect(skill, target)
  local level
  local caster = skill.caster
  local skillult = caster.skills.Alice_ult
  local skillatk4 = caster.skills.Alice_atk4
  local skillatk2 = caster.skills.Alice_atk2
  local ratio = 1
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == Alice.hate_bid then
      level = tbuff.Ten_level
    end
  end
  if level then
    if skill == skillult then
      local timer = 0
      local buff = caster.skills.Alice_ult_stun:createBuff(target)
      if target == caster.Alice_highest_hero then
        timer = level * 0.5 + 6
      else
        timer = level * 0.3 + 6
      end
      if buff then
        buff.timer = timer
      end
      target:addBuff(buff, caster)
    elseif skill == skillatk2 then
      local burn_ratio = 1
      local buff = caster.skills.Alice_atk2_burn:createBuff(target)
      buff:setAttribute("HPR", buff.info.HPR * burn_ratio)
      if target == caster.Alice_highest_hero then
        burn_ratio = burn_ratio + level * 0.5
      else
        burn_ratio = burn_ratio + level * 0.3
      end
      target:addBuff(buff, caster)
    elseif target == caster.Alice_highest_hero then
      ratio = level * 0.5 + 2
    else
      ratio = level * 0.3 + 2
    end
  end
  return ratio
end

function Alice.hero_handleUnitDieEvent(basefunc, hero, unit, killer_unit)
  basefunc(hero, unit, killer_unit)
  if not hero:isAlive() then
    return
  end
  local buff_level = 0
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == Alice.hate_bid and tbuff.Ten_level then
      buff_level = tbuff.Ten_level
    end
  end
  local skillawake = hero.skills.Alice_awake
  hero.Alice_awake_total_level = hero.Alice_awake_total_level - buff_level
  hero.awake_hpr_buff:setAttribute("HPR", skillawake.info["Script Arg1"] * hero.Alice_awake_total_level)
  hero:rebuild()
  if unit == hero.Alice_highest_hero then
    local maxlevel = 0
    for unit in ed.engine:foreachAliveUnit(hero.origin_foecamp) do
      if unit == hero.Alice_highest_hero then
      else
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == Alice.hate_bid and tbuff.level and maxlevel < tbuff.level then
            maxlevel = tbuff.level
            hero.Alice_highest_level = maxlevel
            hero.Alice_highest_hero = unit
          end
        end
      end
    end
    local bid = Alice.awake_highest_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero.Alice_highest_hero:addBuff(binfo, hero)
    if hero.Alice_highest_hero == unit then
      hero.Alice_highest_hero = nil
    end
  end
end

function Alice.init_hero(hero)
  hero.die = override(hero.die, Alice.hero_die)
  hero.BoomDoll_list = {}
  local skillult = hero.skills.Alice_ult
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, Alice.skillult_createProjectile)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Alice.skillult_takeEffectOn)
  end
  local skillatk4 = hero.skills.Alice_atk4
  if skillatk4 then
    hero.update = override(hero.update, Alice.hero_update)
    hero.takeDamage = override(hero.takeDamage, Alice.hero_takeDamage)
    hero.reset = override(hero.reset, Alice.hero_reset)
  end
  local skillatk3 = hero.skills.Alice_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, Alice.skillatk3_createProjectile)
  end
  local skillatk2 = hero.skills.Alice_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Alice.skillatk2_takeEffectOn)
  end
  local skillawake = hero.skills.Alice_awake
  if skillawake then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Alice.hero_handleUnitDieEvent)
  end
  return hero
end

return Alice.init_hero
