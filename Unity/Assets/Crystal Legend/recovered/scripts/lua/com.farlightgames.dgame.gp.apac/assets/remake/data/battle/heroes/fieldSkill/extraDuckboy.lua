module("ed.battlehero", package.seeall)
local ed = ed
extraDuckboy = {}
extraDuckboy.DuckboyId = 10066
extraDuckboy.MonitorID = 10066
extraDuckboy.minX = ed.engine.stage_rect.minX
extraDuckboy.maxX = ed.engine.stage_rect.maxX
extraDuckboy.deltaX = 400
extraDuckboy.invulnerableBuffId = 4113
extraDuckboy.MonitorBuffID = 885
extraDuckboy.DuckboyDropHeight = 170
extraDuckboy.DuckboyDropTime = 6
extraDuckboy.DuckboyDropEffect = "eff_buff_Gambler_ult_highlight.cha"
extraDuckboy.ZoneXRange = 2

function extraDuckboy.extraDuckboy_actor_update(basefunc, actor, dt)
  local unit = actor.model
  if not unit.fieldNPC_alreadyDrop then
    unit.fieldNPC_dropActorTime = unit.fieldNPC_dropActorTime and unit.fieldNPC_dropActorTime + dt or dt
    local unitTime = unit.fieldNPC_dropUnitTime
    local actorTime = unit.fieldNPC_dropActorTime
    local heightPerDt = extraDuckboy.DuckboyDropHeight / extraDuckboy.DuckboyDropTime
    local deltaTime = 0 <= actorTime - unitTime and actorTime - unitTime or 0
    local deltaHeight = (actorTime - unitTime) * -heightPerDt
    actor.height = unit.height + deltaHeight
  end
  basefunc(actor, dt)
end

function extraDuckboy.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local TotalDamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local Player_Damage = 0
  local Field_Damage = 0
  if TotalDamage then
    for _, PDamage_list in ipairs(self.PDamageList) do
      if type(struct_table) == "table" then
        if struct_table.source == PDamage_list.unit then
          PDamage_list.Damage = PDamage_list.Damage + TotalDamage
        end
      elseif source and source == PDamage_list.unit then
        PDamage_list.Damage = PDamage_list.Damage + TotalDamage
      end
    end
    for _, FDamage_list in ipairs(self.FDamageList) do
      if type(struct_table) == "table" then
        if struct_table.source == FDamage_list.unit then
          FDamage_list.Damage = FDamage_list.Damage + TotalDamage
        end
      elseif source and source == FDamage_list.unit then
        FDamage_list.Damage = FDamage_list.Damage + TotalDamage
      end
    end
  end
  return TotalDamage, bc
end

function extraDuckboy:skillatk3_selectCamp()
  for _, unit_list in ipairs(self.PDamageList) do
    self.PlayerDamage = unit_list.Damage + self.PlayerDamage
  end
  for _, unit_list in ipairs(self.FDamageList) do
    self.FieldDamage = unit_list.Damage + self.FieldDamage
  end
  if self.Timeflag == false then
    self.FieldDamage = self.FieldDamage
    self.PlayerDamage = self.PlayerDamage
  else
    self.atk3flag = false
    for _, unit_list in ipairs(self.PDamageList) do
      unit_list.Damage = 0
    end
    for _, unit_list in ipairs(self.FDamageList) do
      unit_list.Damage = 0
    end
    self.Timeflag = false
    self.FieldDamage = 0
    self.PlayerDamage = 0
  end
  if self.FieldDamage == 0 and self.PlayerDamage == 0 then
    self.targetCamp = self.targetcampbefore
  elseif self.FieldDamage > self.PlayerDamage then
    self.targetCamp = 1
    self.targetcampbefore = self.targetCamp
  elseif self.FieldDamage < self.PlayerDamage then
    self.targetCamp = -1
    self.targetcampbefore = self.targetCamp
  elseif self.FieldDamage == self.PlayerDamage and self.PlayerDamage ~= 0 then
    self.targetCamp = -1
    self.targetcampbefore = self.targetCamp
  end
end

function extraDuckboy.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    ed.setMusicVolume(0.25)
  end
end

function extraDuckboy.skillatk3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  if ed.run_with_scene then
    ed.resetMusicVolume()
  end
end

function extraDuckboy.clamp(n, min, max)
  if n < min then
    return min
  end
  if max < n then
    return max
  end
  return n
end

function extraDuckboy.locate_pool_position(skill)
  local n = 10
  local step = 800 / (n + 1)
  local values = {}
  for i = 1, n do
    values[i] = 0
  end
  local DoneRadius = skill.info["Shape Arg1"]
  for unit in ed.engine:foreachAliveUnit(skill.caster.targetCamp) do
    if unit.config.is_summoned then
    else
      local modifiedRadius = (DoneRadius ^ 2 - math.abs(unit.position[2] - -20) ^ 2) ^ 0.5
      local min = math.max(1, math.ceil((unit.position[1] - modifiedRadius) / step))
      local max = math.min(n, math.floor((unit.position[1] + modifiedRadius) / step))
      for i = min, max do
        values[i] = values[i] + 1
      end
    end
  end
  local max = 0
  local maxi = math.floor(n / 2)
  local start = 1
  local finish = n
  local searchDir = 1
  if 0 < skill.caster:getInitDir() then
    maxi = n - math.floor(n / 2)
    start = n
    finish = 1
    searchDir = -searchDir
  end
  for i = start, finish, searchDir do
    if max < values[i] then
      maxi = i
      max = values[i]
    end
  end
  local range = extraDuckboy.ZoneXRange
  maxi = extraDuckboy.clamp(maxi, range, n + 1 - range)
  local position = {
    maxi * step,
    -20
  }
  return position
end

function extraDuckboy.skillatk3_takeRegionEffectOn(basefunc, self, unit)
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

function extraDuckboy.skillatk3_createRegion(basefunc, self)
  local region = basefunc(self)
  local position = extraDuckboy.locate_pool_position(self)
  region.position = position
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, extraDuckboy.skillatk3_takeRegionEffectOn)
  return region
end

function extraDuckboy.extraDuckboy_update(basefunc, unit, dt)
  unit.fieldNPC_dropUnitTime = unit.fieldNPC_dropUnitTime and unit.fieldNPC_dropUnitTime + dt or dt
  if unit.camp == 2 then
    unit.foecamp = 0
  end
  for punits in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local skillult = punits.skills[punits.name .. "_ult"]
    if skillult == nil then
      if punits.name == "Kael" then
        skillult = punits.skills.Kael_book
      else
        break
      end
    elseif skillult.casting then
      unit:unfreeze(true)
      unit.castingflag = true
    else
      unit.castingflag = false
    end
  end
  for eunits in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
    local skillults = eunits.skills[eunits.name .. "_ult"]
    if skillults == nil then
      if eunits.name == "Kael" then
        skillults = eunits.skills.Kael_book
      else
        break
      end
    elseif skillults.casting then
      unit:unfreeze(true)
      unit.castingflag = true
    else
      unit.castingflag = false
    end
  end
  if unit.castingflag == false then
    unit.atk3checkTime = unit.atk3checkTime and unit.atk3checkTime + dt or dt
  else
    unit.atk3checkTime = unit.atk3checkTime
  end
  if unit.atk3checkTime >= 10 and unit.castingflag == false then
    unit.Timeflag = true
    unit.atk3checkTime = 0
  elseif unit.castingflag == true then
    unit.Timeflag = false
    unit.atk3checkTime = unit.atk3checkTime
  end
  local actor = unit.actor
  if actor and not unit.field_actorOverride then
    unit.field_actorOverride = true
    actor.update = override(actor.update, extraDuckboy.extraDuckboy_actor_update)
  end
  local ult = unit.skills.Duckboy_ult
  local atk = unit.skills.Duckboy_atk
  local atk2 = unit.skills.Duckboy_atk2
  local atk4 = unit.skills.Duckboy_atk4
  if ult then
    ult.cd_remaining = 9999
  end
  if atk then
    atk.cd_remaining = 9999
  end
  if atk2 then
    atk2.cd_remaining = 9999
  end
  if atk4 then
    atk4.cd_remaining = 9999
  end
  local atk3 = unit.skills.Duckboy_atk3
  if unit.atk3flag == true then
    if atk3 then
      atk3.cd_remaining = 9999
    end
  elseif unit.atk3flag == false then
    atk3.cd_remaining = 0
    unit.atk3flag = true
  end
  local time = unit.fieldNPC_dropUnitTime
  if unit:isAlive() and not unit.fieldNPC_alreadyDrop then
    local height = time >= extraDuckboy.DuckboyDropTime and 0 or (extraDuckboy.DuckboyDropTime - time) * extraDuckboy.DuckboyDropHeight / extraDuckboy.DuckboyDropTime
    unit.height = height
    if time >= extraDuckboy.DuckboyDropTime then
      unit.fieldNPC_alreadyDrop = true
      if unit.actor then
        unit.actor.height = unit.height
      end
      if unit.fieldNPC_dropEffect and ed.run_with_scene then
        local new_effect_list = {}
        local effect_list = ed.scene.effect_list
        for i, effect in ipairs(effect_list) do
          if unit.fieldNPC_dropEffect and unit.fieldNPC_dropEffect == effect then
            effect:removeFromParentAndCleanup(true)
          else
            table.insert(new_effect_list, effect)
          end
        end
        unit.fieldNPC_dropEffect = nil
        ed.scene.effect_list = new_effect_list
      end
    end
  end
  if unit.buff_list then
    for i, tbuff in ipairs(unit.buff_list) do
      if 0 > tbuff.info.HPR then
        local hpr = tbuff.info.HPR * dt
        local HPRdamage = math.min(-hpr, unit.hp)
        HPRdamage = HPRdamage * unit.dPSStatisticsRatio
        for _, info_list in ipairs(unit.PDamageList) do
          local unitconfig = info_list.unit.config
          if tbuff.caster == info_list.unit or unitconfig.is_summoned and unitconfig.summoner == tbuff.caster then
            info_list.Damage = info_list.Damage + HPRdamage
          end
        end
      end
    end
  end
  local PheroCount = 0
  local Pcamp = 1
  for u in ed.engine:foreachAliveUnit(Pcamp) do
    if not u.config.is_summoned then
      PheroCount = PheroCount + 1
    end
  end
  if PheroCount <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
  local FheroCount = 0
  local Fcamp = -1
  for u in ed.engine:foreachAliveUnit(Fcamp) do
    if not u.config.is_summoned then
      FheroCount = FheroCount + 1
    end
  end
  if FheroCount <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
  extraDuckboy.skillatk3_selectCamp(unit)
  basefunc(unit, dt)
end

function extraDuckboy.summonDuckboy(camp, field)
  local hpMod = 100
  local dpsMod = 1
  local skillLevel = {
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  }
  local proto = {
    _tid = extraDuckboy.DuckboyId,
    _level = 100,
    _stars = 5,
    _skill_levels = skillLevel,
    _rank = 16,
    _arousal = {
      _status = 1,
      _str = 200,
      _int = 200,
      _agi = 200
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = hpMod,
    dps_mod = dpsMod,
    size_mod = 1.6,
    PlayerDamage = 0,
    FieldDamage = 0,
    atk3checkTime = 0
  }
  local camp = 2
  local fieldDuckboy = ed.UnitCreate(proto, camp, config)
  fieldDuckboy:reset()
  local summonPosition = {400, 10}
  summonPosition[1] = camp == ed.emCampEnemy and extraDuckboy.maxX - extraDuckboy.deltaX or extraDuckboy.minX + extraDuckboy.deltaX
  fieldDuckboy.direction = camp == ed.emCampEnemy and -fieldDuckboy.direction or fieldDuckboy.direction
  ed.engine:summonUnit(fieldDuckboy, summonPosition, field)
  local binfo = ed.lookupDataTable("Buff", nil, extraDuckboy.invulnerableBuffId)
  local buff = fieldDuckboy:addBuff(binfo, field)
  fieldDuckboy:takeDamage(30, "Holy", "hp", fieldDuckboy)
  fieldDuckboy.fieldNPC_invulenerableBuff = buff
  fieldDuckboy.fieldNPC_dropUnitTime = 0
  fieldDuckboy.fieldNPC_dropActorTime = 0
  fieldDuckboy.fieldNPC_alreadyDrop = false
  fieldDuckboy.global_cd = 6
  fieldDuckboy.field_actorOverride = false
  fieldDuckboy.aiMode = false
  fieldDuckboy.PlayerDamage = 0
  fieldDuckboy.FieldDamage = 0
  fieldDuckboy.atk3flag = true
  fieldDuckboy.Timeflag = false
  fieldDuckboy.targetCamp = 0
  fieldDuckboy.targetcampbefore = 0
  fieldDuckboy.castingflag = false
  fieldDuckboy.PDamageList = {}
  fieldDuckboy.FDamageList = {}
  for _, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == 1 then
      fieldDuckboy.PDamageList[#fieldDuckboy.PDamageList + 1] = {unit = unit, Damage = 0}
    elseif unit.camp == -1 then
      fieldDuckboy.FDamageList[#fieldDuckboy.FDamageList + 1] = {unit = unit, Damage = 0}
    end
  end
  local atk = fieldDuckboy.skills.Duckboy_atk
  if atk then
    local oinfo = atk.info
    atk.info = ed.wraptable(oinfo, {
      ["Max Range"] = 999
    })
    atk.max_range_sq = atk.info["Max Range"] ^ 2
  end
  fieldDuckboy.attack_range = 999
  local atk3 = fieldDuckboy.skills.Duckboy_atk3
  if atk3 then
    local origninfo = atk3.info
    atk3.info = ed.wraptable(origninfo, {})
  end
  fieldDuckboy.update = override(fieldDuckboy.update, extraDuckboy.extraDuckboy_update)
  fieldDuckboy.takeDamage = override(fieldDuckboy.takeDamage, extraDuckboy.hero_takeDamage)
  if atk3 then
    atk3.start = override(atk3.start, extraDuckboy.skillatk3_start)
    atk3.finish = override(atk3.finish, extraDuckboy.skillatk3_finish)
    atk3.createRegion = override(atk3.createRegion, extraDuckboy.skillatk3_createRegion)
  end
  if ed.run_with_scene then
    local effect = ed.scene:playEffectOnScene(extraDuckboy.DuckboyDropEffect, summonPosition, {1, 1}, nil, 1)
    fieldDuckboy.fieldNPC_dropEffect = effect
  end
  return fieldDuckboy
end

function extraDuckboy.summonMonitor(camp, field)
  local hpMod = 100
  local dpsMod = 1
  local skillLevel = {
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  }
  local proto = {
    _tid = extraDuckboy.MonitorID,
    _level = 100,
    _stars = 5,
    _skill_levels = skillLevel,
    _rank = 16,
    _arousal = {
      _status = 1,
      _str = 200,
      _int = 200,
      _agi = 200
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = hpMod,
    dps_mod = dpsMod,
    size_mod = 1.6,
    PlayerDamage = 0,
    FieldDamage = 0,
    atk3checkTime = 0
  }
  local camp = 0
  local MonitorDuckboy = ed.UnitCreate(proto, camp, config)
  local summonPosition = {600, 100}
  summonPosition[1] = camp == ed.emCampEnemy and extraDuckboy.maxX - extraDuckboy.deltaX or extraDuckboy.minX + extraDuckboy.deltaX
  MonitorDuckboy.direction = camp == ed.emCampEnemy and -MonitorDuckboy.direction or MonitorDuckboy.direction
  ed.engine:summonUnit(MonitorDuckboy, summonPosition, field)
  local binfo = ed.lookupDataTable("Buff", nil, extraDuckboy.MonitorBuffID)
  local buff = MonitorDuckboy:addBuff(binfo, field)
  MonitorDuckboy:takeDamage(30, "Holy", "hp", MonitorDuckboy)
  MonitorDuckboy.fieldNPC_invulenerableBuff = buff
  MonitorDuckboy.fieldNPC_dropUnitTime = 0
  MonitorDuckboy.fieldNPC_dropActorTime = 0
  MonitorDuckboy.fieldNPC_alreadyDrop = false
  MonitorDuckboy.global_cd = 6
  MonitorDuckboy.field_actorOverride = false
  MonitorDuckboy.aiMode = false
  MonitorDuckboy.update = override(MonitorDuckboy.update, extraDuckboy.Monitor_update)
  if ed.run_with_scene then
    local effect = ed.scene:playEffectOnScene(extraDuckboy.DuckboyDropEffect, summonPosition, {1, 1}, nil, 1)
    MonitorDuckboy.fieldNPC_dropEffect = effect
  end
  return MonitorDuckboy
end

function extraDuckboy.Monitor_update(basefunc, unit, dt)
  unit.fieldNPC_dropUnitTime = unit.fieldNPC_dropUnitTime and unit.fieldNPC_dropUnitTime + dt or dt
  if unit.camp == 2 then
    unit.foecamp = 0
  end
  local actor = unit.actor
  if actor and not unit.field_actorOverride then
    unit.field_actorOverride = true
    actor.update = override(actor.update, extraDuckboy.extraDuckboy_actor_update)
  end
  local ult = unit.skills.Duckboy_ult
  local atk = unit.skills.Duckboy_atk
  local atk2 = unit.skills.Duckboy_atk2
  local atk3 = unit.skills.Duckboy_atk3
  local atk4 = unit.skills.Duckboy_atk4
  if ult then
    ult.cd_remaining = 9999
  end
  if atk then
    atk.cd_remaining = 9999
  end
  if atk2 then
    atk2.cd_remaining = 9999
  end
  if atk4 then
    atk4.cd_remaining = 9999
  end
  if atk3 then
    atk3.cd_remaining = 9999
  end
  local time = unit.fieldNPC_dropUnitTime
  if unit:isAlive() and not unit.fieldNPC_alreadyDrop then
    local height = time >= extraDuckboy.DuckboyDropTime and 0 or (extraDuckboy.DuckboyDropTime - time) * extraDuckboy.DuckboyDropHeight / extraDuckboy.DuckboyDropTime
    unit.height = height
    if time >= extraDuckboy.DuckboyDropTime then
      unit.fieldNPC_alreadyDrop = true
      if unit.actor then
        unit.actor.height = unit.height
      end
      if unit.fieldNPC_dropEffect and ed.run_with_scene then
        local new_effect_list = {}
        local effect_list = ed.scene.effect_list
        for i, effect in ipairs(effect_list) do
          if unit.fieldNPC_dropEffect and unit.fieldNPC_dropEffect == effect then
            effect:removeFromParentAndCleanup(true)
          else
            table.insert(new_effect_list, effect)
          end
        end
        unit.fieldNPC_dropEffect = nil
        ed.scene.effect_list = new_effect_list
      end
    end
  end
  local PheroCount = 0
  local Pcamp = 1
  for u in ed.engine:foreachAliveUnit(Pcamp) do
    if not u.config.is_summoned then
      PheroCount = PheroCount + 1
    end
  end
  if PheroCount <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
  local FheroCount = 0
  local Fcamp = -1
  for u in ed.engine:foreachAliveUnit(Fcamp) do
    if not u.config.is_summoned then
      FheroCount = FheroCount + 1
    end
  end
  if FheroCount <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
  basefunc(unit, dt)
end

function extraDuckboy.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  if skill and skill.cd_remaining <= 0 and not skill.Field_alreadySummonDuckboy then
    skill.Field_alreadySummonDuckboy = true
    local Duckboy = extraDuckboy.summonDuckboy(-field.camp, field)
    ed.engine.playerDuckboyHero = Duckboy
  end
end

function extraDuckboy.init_fieldSkill(skill)
  skill.update = override(skill.update, extraDuckboy.skill_update)
  return skill
end

return extraDuckboy.init_fieldSkill
