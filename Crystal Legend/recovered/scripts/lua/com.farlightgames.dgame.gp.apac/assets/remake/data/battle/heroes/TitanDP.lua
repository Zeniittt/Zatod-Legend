module("ed.battlehero", package.seeall)
local ed = ed
TitanDP = {}
TitanDP.interval = 0.25
TitanDP.ZoneXRange = 2
TitanDP.TitanDP_fashionID = 100791

function TitanDP.skillatk_start(basefunc, skill, target)
  local hero = skill.caster
  local originfo = skill.info
  if TitanDP.TitanDP_fashionID and TitanDP.TitanDP_fashionID == hero.fashion_id then
    skill.info = ed.wraptable(originfo, {
      ["Impact Effect"] = "eff_impact_TitanDP_beach_atk.cha",
      ["Tile Art"] = "eff_tile_TitanDP_beach_atk.cha"
    })
  end
  basefunc(skill, target)
end

function TitanDP.resurgenceUnit_Create(skill, unit)
  local skilllevel = {}
  local ID
  local caster = skill.caster
  local resurgenceUnit_Star = 1
  local resurgenceUnit_level = 1
  local resurgenceSkill_level = 1
  if unit.info.ID == 53 then
    ID = 191
  elseif unit.info.ID == 85 then
    ID = 192
  else
    ID = unit.info.ID
  end
  if skill.level > unit.level then
    resurgenceSkill_level = unit.level
  else
    resurgenceSkill_level = skill.level
  end
  for i = 1, 17 do
    skilllevel[i] = resurgenceSkill_level
  end
  if unit.stars > caster.stars then
    resurgenceUnit_Star = caster.stars
  else
    resurgenceUnit_Star = unit.stars
  end
  if unit.level > caster.level then
    resurgenceUnit_level = caster.level
  else
    resurgenceUnit_level = unit.level
  end
  local arousal = unit.proto._arousal
  local rune_info = unit.proto._hero_rune
  local proto = {
    _tid = ID,
    _level = resurgenceUnit_level,
    _stars = resurgenceUnit_Star,
    _skill_levels = skilllevel,
    _arousal = arousal,
    _rank = unit.rank,
    _fashion = {
      _current_fashion = unit.fashion_id
    },
    _hero_rune = rune_info
  }
  local config = {
    is_monster = false,
    is_summoned = true,
    hp_mod = unit.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = unit.config.dps_mod,
    size_mod = unit.config.size_mod
  }
  return ed.UnitCreate(proto, caster.camp, config)
end

function TitanDP.skillatk2_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  hero.atk2Power = power
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

function TitanDP.skillatk2_Start(basefunc, skill, target)
  local hero = skill.caster
  local bid = 1544
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local originfo = skill.info
  basefunc(skill, target)
  local buff = hero:addBuff(binfo, hero)
  hero.CastAtk2 = true
end

function TitanDP.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  local skillatk2_heal = skill.info["Script Arg2"]
  if TitanDP.TitanDP_fashionID and TitanDP.TitanDP_fashionID == hero.fashion_id then
    local fashion_heal = hero.attribs.HP * 0.08
    hero:takeHeal(fashion_heal, "hp", hero)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_TitanDP_beach_atk2.cha", hero.position, {
        hero.direction * 0.9,
        0.85
      }, hero.height, 0)
    end
  elseif ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanDP_atk2.cha", hero.position, {
      hero.direction * 0.9,
      0.85
    }, hero.height, 0)
  end
end

function TitanDP.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 1544 then
      tbuff.owner:removeBuff(tbuff)
    end
  end
  hero.CastAtk2 = false
end

function TitanDP.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk2 = self.skills.TitanDP_atk2
  local skillatk4 = self.skills.TitanDP_atk4
  if skillatk2 and self:isAlive() and skillatk2.casting then
    local skillatk2_heal = skillatk2.info["Script Arg2"]
    if unit.camp ~= self.camp and not unit.config.is_summoned and killer_unit == self and not self.TitanDP_fashionID then
      local heal = self.atk2Power * skillatk2_heal
      self:takeHeal(heal, "hp", self)
    end
  end
  if skillatk4 and self:isAlive() and not self.config.is_summoned and self.name == "TitanDP" and unit.camp == self.camp and not unit.config.is_summoned and unit.config.summoner ~= self and not unit.config.summoner then
    self.canCastAtk4 = true
  end
end

function TitanDP.skillatk4_Start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 1542
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
end

function TitanDP.skillatk4_onAttackFrame(basefunc, skill)
  local self = skill.caster
  local DeadMan = self.TitanDP_DeadMate
  local skillatk4 = self.skills.TitanDP_atk4
  local resurgencePosition
  local resurgence_time = skillatk4.info["Script Arg2"] + 1.5
  local DeadManList = {}
  local BaseRatio = 1
  local StarRatio = 1
  local LevelRatio = 1
  local TotalRatio = 1
  local skillRemnant = self.skills.TitanDP_Remnant1
  if skillRemnant then
    resurgence_time = resurgence_time * 1.5
  end
  for i, unit in ipairs(ed.engine.unit_list) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 1092 then
        unit.SpectatorBuff = true
      end
    end
    if (unit.info.ID < 101 or unit.info.ID > 10000) and unit.camp == self.camp and not unit:isAlive() and unit.info["Unit Type"] == "Hero" and not unit.config.is_summoned and not unit.TitanDPatk4_called and not unit.SpectatorBuff and skillatk4 and self:isAlive() and not self.config.is_summoned and self.name == "TitanDP" and unit and unit.camp == self.camp and not unit.config.is_summoned and unit.config.summoner ~= self then
      if self.stars then
        BaseRatio = 0.1 * self.stars
        if unit.stars and self.stars < unit.stars then
          StarRatio = 1 - 0.1 * (unit.stars - self.stars)
        end
      end
      if self.level and unit.level and self.level < unit.level then
        LevelRatio = 1 - 0.01 * (unit.level - self.stars)
      end
      if (StarRatio and LevelRatio and BaseRatio) ~= 1 then
        TotalRatio = (StarRatio + LevelRatio + BaseRatio) / 3
      end
      local resurgence_unit = TitanDP.resurgenceUnit_Create(skillatk4, unit)
      resurgence_unit:setDeathWithEffectOrNot(true)
      resurgencePosition = {
        self.position[1] - 50 * self.direction,
        self.position[2]
      }
      resurgence_unit.die = override(resurgence_unit.die, TitanDP.resurgence_unitDie)
      resurgence_unit.direction = self.direction
      resurgence_unit.alivetime = resurgence_time
      resurgence_unit.update = override(resurgence_unit.update, TitanDP.resurgence_unitUpdate)
      ed.engine:summonUnit(resurgence_unit, resurgencePosition, self, "Idle")
      self.resurgence_unitNum = self.resurgence_unitNum + 1
      resurgence_unit:reset()
      for i, attrib in pairs(unit.attribs) do
        resurgence_unit.attribs[i] = unit.attribs[i] * TotalRatio
      end
      if resurgence_unit.name == "Mor" then
        resurgence_unit.orginHP = resurgence_unit.attribs.HP / self.config.hp_mod * resurgence_unit.config.hp_mod
      else
        resurgence_unit.orginHP = self.attribs.HP / self.config.hp_mod * resurgence_unit.config.hp_mod
      end
      resurgence_unit.attribs.HP = resurgence_unit.orginHP
      resurgence_unit.hp = resurgence_unit.attribs.HP
      for i, skill in pairs(resurgence_unit.skill_list) do
        if skill.info["Init CD"] <= 60 then
          skill.cd_remaining = 0
        end
        if 60 < skill.info.CD then
          skill.cd_remaining = 999
        end
        if 0 < skill.info["Cost MP"] then
          skill.cd_remaining = 999
        end
        if skill.info[resurgence_unit.name .. "_awake"] then
          skill.cd_remaining = 999
        end
        if skill.info[resurgence_unit.name .. "_sawake"] then
          skill.cd_remaining = 999
        end
      end
      unit.TitanDPatk4_called = true
      resurgence_unit.TitanDPatk4_called = true
      table.insert(self.DeadMateList, resurgence_unit)
      local bid1 = 1540
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local bid = 1539
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local StartBuff = ed.BuffCreate(binfo, resurgence_unit, self)
      StartBuff.onRemoved = override(StartBuff.onRemoved, TitanDP.Resurgence_Startbuff)
      local buff601 = resurgence_unit:addBuff(binfo1, self)
      buff601.onRemoved = override(buff601.onRemoved, TitanDP.battleEnd_onRemoved)
      resurgence_unit:addBuff(StartBuff, self)
      if skillRemnant then
        local bid = 4787
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, self, self)
        buff:setAttribute("HPR", self.attribs.HP * 0.025)
        self:addBuff(buff, self)
      end
      if TitanDP.TitanDP_fashionID and TitanDP.TitanDP_fashionID == self.fashion_id then
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_impact_TitanDP_beach_atk4.cha", resurgence_unit.position, {
            resurgence_unit.direction,
            1
          }, resurgence_unit.height, 0)
        end
      elseif ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_impact_TitanDP_atk4.cha", resurgence_unit.position, {
          resurgence_unit.direction,
          1
        }, resurgence_unit.height, 0)
      end
      resurgence_unit.NotStolenByRubick = true
    end
  end
end

function TitanDP.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 1542 then
      tbuff.owner:removeBuff(tbuff)
    end
  end
  hero.canCastAtk4 = false
end

function TitanDP.Resurgence_Startbuff(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  local resurgence_unit = buff.owner
  resurgence_unit:setPosition({
    hero.position[1] - 50 * hero.direction,
    hero.position[2]
  })
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_Lion_atk3.cha", resurgence_unit.position, {
      hero.direction,
      1
    }, hero.height, 0)
  end
end

function TitanDP.battleEnd_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  hero.config.is_monster = true
  hero.config.is_summoned = true
  hero.manually_casting = false
  if hero:isAlive() and ed.engine.beingEnd then
    if do_battle_log then
      btlog("%s died.", hero:display())
    end
    hero.state = ed.emUnitState_Dying
    if hero.manually_casting then
      hero.manually_casting = false
      ed.engine:unfreeze()
    end
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    hero.can_cast_manual = false
    hero.walk_v = {0, 0}
    hero.hp = 0
    hero.mp = 0
    if not hero.isDeathWithEffect then
      hero:setAction("Death", false, true)
    else
      hero.action_name = nil
      hero.action_loop = false
      hero.action_duration = 0
      hero.action_elapsed = 0
      local origin = {
        hero.position[1],
        hero.position[2]
      }
      if ed.run_with_scene then
        local effect_name = "eff_point_mirror_die.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, origin, {
            hero.direction * 0.85,
            0.85
          }, nil, 1)
        end
      end
    end
    ed.engine:onUnitDie(hero, nil)
    if hero.actor then
      hero.actor:onUnitDeath()
    end
  end
end

function TitanDP.resurgence_unitDie(basefunc, self, killer)
  basefunc(self, killer)
  local hero = self.config.summoner
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_Lion_atk3.cha", self.position, {
      self.direction,
      1
    }, self.height, 0)
  end
  hero.resurgence_unitNum = hero.resurgence_unitNum - 1
end

function TitanDP.resurgence_unitUpdate(basefunc, unit, dt)
  local hero = unit.config.summoner
  if not unit:isAlive() then
    return
  end
  unit.alivetime = unit.alivetime - dt
  if unit.alivetime <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
  if not unit.config.summoner:isAlive() then
    for i, unit in pairs(hero.DeadMateList) do
      unit:die()
    end
  end
  if unit.state == ed.emUnitState_Dying then
    unit.state = ed.emUnitState_Dead
    unit:setAction(nil)
    unit.hasCorpse = false
    if unit.actor and unit.actor.node then
      unit.actor.node:setVisible(false)
    end
  end
end

function TitanDP.hero_die(basefunc, hero, killer)
  if hero.DeadMateList then
    for _, resurgence_unit in ipairs(hero.DeadMateList) do
      if resurgence_unit and resurgence_unit:isAlive() then
        resurgence_unit:die()
      end
    end
  end
  basefunc(hero, killer)
end

function TitanDP.hero_update(basefunc, self, dt)
  local skillatk = self.skills.TitanDP_atk
  local skillatk2 = self.skills.TitanDP_atk2
  local skillatk3 = self.skills.TitanDP_atk3
  local skillatk4 = self.skills.TitanDP_atk4
  local skillult = self.skills.TitanDP_ult
  if self.name == "TitanDP" and not self.config.is_summoned and self:isAlive() and skillatk4 and not skillatk.casting and not skillatk2.casting and not skillatk3.casting and not skillult.casting and not skillatk4.casting and self.canCastAtk4 == true then
    self:castSkill(skillatk4, self)
  end
  if self.Reverse_Heal and self:isAlive() and self.current_skill == skillult then
    self.Reverse_Heal = false
  end
  basefunc(self, dt)
end

function TitanDP.ult_buff_update(basefunc, self, dt)
  local buff = self
  local self = buff.owner
  local ult_resuregenUnitNum = self.resurgence_unitNum
  local ult_Ratio = 1
  local Star_Ratio = 1
  local Num_Ratio = 0.1
  if 5 < self.stars and self.stars < 8 then
    Star_Ratio = 1 + 0.075 * (self.stars - 5)
    Num_Ratio = 0.1
  elseif self.stars > 7 and self.stars < 10 then
    Star_Ratio = 1 + 0.25 * (self.stars - 7)
    Num_Ratio = 0.125
  else
    Star_Ratio = 2
    Num_Ratio = 0.15
  end
  if ult_resuregenUnitNum then
    ult_Ratio = (1 + Num_Ratio * ult_resuregenUnitNum) * Star_Ratio
  else
    ult_Ratio = 1 * Star_Ratio
  end
  buff.second_timer = buff.second_timer - dt
  if buff.second_timer > 0 and buff then
    local timer = buff.attack_timer - dt
    while timer <= 0 do
      timer = timer + TitanDP.interval
      local skill = buff.caster.skills.TitanDP_ult
      local originfo = skill.info
      local origtarget = skill.target
      local origPlusRatio = originfo["Plus Ratio"]
      skill.info = ed.wraptable(originfo, {
        ["Buff ID"] = 0,
        ["Damage Type"] = "AP",
        ["Target Camp"] = -1,
        ["Affected Camp"] = -1,
        ["Target Type"] = "random",
        ["Plus Ratio"] = origPlusRatio * ult_Ratio
      })
      local target = skill:selectTarget()
      if target then
        local succ, dmg = skill:takeEffectOn(target, skill.caster)
        buff.total_times = buff.total_times + 1
        if dmg then
          buff.total_dmg = buff.total_dmg + dmg
          self.buff_total_dmg = buff.total_dmg
          if math.ceil(buff.second_timer) == buff.second_timer then
            if TitanDP.TitanDP_fashionID and TitanDP.TitanDP_fashionID == self.fashion_id then
              local fashion_heal = self:takeHeal(buff.total_dmg * 0.15, "hp", self)
            else
              local heal = self:takeHeal(buff.total_dmg * 0.125, "hp", self)
            end
          end
        end
      end
      skill.info = originfo
      skill.target = origtarget
    end
    buff.attack_timer = timer
  end
  basefunc(buff, dt)
end

function TitanDP.ult_onRemoved(basefunc, buff)
  local caster = buff.owner
  buff.second_timer = 5
  buff.owner.buff_total_dmg = 0
  basefunc(buff)
end

function TitanDP.ult_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  if target == caster then
    if not caster.TitanDP_ult_buff then
      local buff = self.caster:addBuff(self:createBuff(self.caster))
      if buff then
        caster.TitanDP_ult_buff = buff
      end
    else
      for _, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 1538 then
          tbuff.timer = -1
        end
      end
      local buff = self.caster:addBuff(self:createBuff(self.caster))
      if buff then
        caster.TitanDP_ult_buff = buff
      end
    end
  else
    return basefunc(self, target, source, shift)
  end
end

function TitanDP.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local skillult = hero.skills.TitanDP_ult
  local dmg = 0
  if not hero:isAlive() then
    dmg = 0
  else
    dmg = target:takeDamage({
      amount = power,
      damage_type = damage_type,
      field = field,
      source = source,
      crit_mod = crit_mod,
      skill = self
    })
  end
  return dmg
end

function TitanDP.ult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = TitanDP.interval
  buff.total_dmg = 0
  buff.total_times = 0
  buff.second_timer = 5
  buff.update = override(buff.update, TitanDP.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanDP.ult_onRemoved)
  return buff
end

function TitanDP.skillult_Start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 1543
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  if TitanDP.TitanDP_fashionID and TitanDP.TitanDP_fashionID == hero.fashion_id then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_TitanDP_beach_ult.cha", hero.position, {
        hero.direction * 1,
        1
      }, hero.height, 0)
    end
  elseif ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanDP_ult.cha", hero.position, {
      hero.direction * 1,
      1
    }, hero.height, 0)
  end
end

function TitanDP.Clamp(n, min, max)
  if n < min then
    return min
  end
  if max < n then
    return max
  end
  return n
end

function TitanDP.locate_pool_position(skill)
  local n = 10
  local step = 800 / (n + 1)
  local values = {}
  for i = 1, n do
    values[i] = 0
  end
  local DoneRadius = 100
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
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
  local range = TitanDP.ZoneXRange
  maxi = TitanDP.Clamp(maxi, range, n + 1 - range)
  local position = {
    maxi * step,
    -100
  }
  return position
end

function TitanDP.skillatk3_takeRegionEffectOn(basefunc, self, unit)
  local hero = self.skill.caster
  local skillatk3 = self.skill
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() and unit.name ~= "BossTitanDruid" then
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

function TitanDP.skillatk3_createRegion(basefunc, self)
  local region = basefunc(self)
  local position = TitanDP.locate_pool_position(self)
  region.position = position
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, TitanDP.skillatk3_takeRegionEffectOn)
  return region
end

function TitanDP.skillatk3_start(basefunc, skill, target)
  local hero = skill.caster
  local originfo = skill.info
  if TitanDP.TitanDP_fashionID and TitanDP.TitanDP_fashionID == hero.fashion_id then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_TitanDP_beach_atk3.cha"
    })
  end
  if hero.stars then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Script Arg1"] = hero.attribs.INT * 5.0E-4 + 3
    })
  end
  basefunc(skill, target)
end

function TitanDP.reset(basefunc, hero)
  basefunc(hero)
  hero.Start_time = 0
  hero.buff_total_dmg = 0
  hero.resurgence_unitNum = 0
  hero.DeadMateList = {}
  hero.canCastAtk4 = false
  hero.atk2Power = 0
  hero.CastAtk2 = false
end

function TitanDP.init_hero(hero)
  local skillult = hero.skills.TitanDP_ult
  local skillatk = hero.skills.TitanDP_atk
  local skillatk2 = hero.skills.TitanDP_atk2
  local skillatk3 = hero.skills.TitanDP_atk3
  local skillatk4 = hero.skills.TitanDP_atk4
  hero.update = override(hero.update, TitanDP.hero_update)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, TitanDP.hero_handleUnitDieEvent)
  hero.reset = override(hero.reset, TitanDP.reset)
  hero.die = override(hero.die, TitanDP.hero_die)
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanDP.ult_createBuff)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanDP.ult_takeEffectOn)
    skillult.start = override(skillult.start, TitanDP.skillult_Start)
    skillult.getDamage = override(skillult.getDamage, TitanDP.skillult_getDamage)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, TitanDP.skillatk_start)
  end
  if skillatk2 then
    skillatk2.getDamage = override(skillatk2.getDamage, TitanDP.skillatk2_getDamage)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanDP.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, TitanDP.skillatk2_Start)
    skillatk2.finish = override(skillatk2.finish, TitanDP.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.createRegion = override(skillatk3.createRegion, TitanDP.skillatk3_createRegion)
    skillatk3.start = override(skillatk3.start, TitanDP.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanDP.skillatk4_onAttackFrame)
    skillatk4.start = override(skillatk4.start, TitanDP.skillatk4_Start)
    skillatk4.finish = override(skillatk4.finish, TitanDP.skillatk4_finish)
  end
  return hero
end

return TitanDP.init_hero
