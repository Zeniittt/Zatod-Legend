module("ed.battlehero", package.seeall)
local ed = ed
DS = {}
DS.base = ed.Entity
DS.interval = 1
DS.distance = 125
DS.projectileTime = 15
DS.unitSurvivalTime = 15

function DS.DS_atk2_buff_update(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + DS.interval
    local skill = buff.caster.skills.DS_atk5
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, buff.owner.position)
      if unit ~= buff.owner and ed.Skill.testPointInShape(p2, "circle", 160, 0) then
        skill:takeEffectOn(unit)
      end
    end
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function DS.DS_atk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, DS.DS_atk2_buff_update)
  buff.attack_timer = DS.interval
  return buff
end

function DS.skillatk2_takeEffectOn(basefunc, self, target, source)
  local bool, dmg
  local caster = self.caster
  for i, tbuff in ipairs(self.caster.buff_list) do
    if tbuff.info.ID == 355 then
      caster.shell = true
    end
  end
  if caster.shell then
    bool, dmg = basefunc(self, target, source)
  else
    bool, dmg = basefunc(self, caster, source)
  end
  caster.shell = false
  return bool, dmg
end

function DS.skillatk3_takeEffectOn(basefunc, self, target, source)
  local bool, dmg
  bool, dmg = basefunc(self, target, source)
  if not bool then
    return bool
  end
  local caster = self.caster
  local bid = 356
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local time = binfo.Time
  local bSucess, reason = ed.Buff.checkAddBuff(binfo, self.level, target, caster)
  if bSucess then
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
    local direction = {1, 0}
    if target.position[1] == caster.position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(target.position, caster.position)))
    end
    if target.info["Position Type"] == T("\229\137\141\230\142\146") then
      target:knockup(time, ed.edpMult(direction, DS.distance), true)
    else
      target:knockup(time, ed.edpMult(direction, -DS.distance), true)
    end
  else
    local color = target.camp == ed.emCampEnemy and "red" or "blue"
    local text = reason == "resist" and "resist" or "miss"
    if target.actor then
      ed.PopupCreate(text, color, target.actor, nil, "text")
    end
  end
  return bool, dmg
end

function DS.copyUnit_die(basefunc, self, killer)
  basefunc(self, killer)
  local summonlist_DS = self.config.summoner.summonlist_DS
  for i, unit in pairs(summonlist_DS) do
    if unit == self then
      table.remove(summonlist_DS, i)
    end
  end
  local hero = self.config.summoner
  local skillawake = hero.skills.DS_awake
  if skillawake then
    local ran = math.floor(ed.rand() * 3) + 1
    local skill_awakebuff = hero.skills["DS_awake_buff" .. ran]
    local target = killer and killer or skill_awakebuff:selectTarget(nil)
    if target then
      target:addBuff(skill_awakebuff:createBuff(target), hero)
    end
  end
end

function DS.newunit_update(basefunc, unit, dt)
  if not unit:isAlive() then
    return
  end
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
  if not unit.config.summoner:isAlive() then
    for i, unit in pairs(unit.config.summoner.summonlist_DS) do
      unit:die()
    end
  end
end

function DS.checkLevel(skillLevel, targetLevel)
  if skillLevel < 30 then
    skillLevel = 10 + skillLevel / 30 * 20
  end
  return targetLevel <= skillLevel + 20 * ed.rand()
end

function DS.CheckCopyUnit(summonlist_DS, unit)
  for i, copyUnit in pairs(summonlist_DS) do
    if copyUnit.FatherUnit_DS == unit then
      return false
    end
  end
  return true
end

function DS.createCopyUnit(skill, unit)
  local copyUnitLevel
  local skillLevel = {}
  local ID
  if skill.level > unit.level then
    copyUnitLevel = unit.level
  else
    copyUnitLevel = skill.level
  end
  for i = 1, 17 do
    skillLevel[i] = copyUnitLevel
  end
  if unit.info.ID == 53 then
    ID = 191
  elseif unit.info.ID == 85 then
    ID = 192
  else
    ID = unit.info.ID
  end
  local proto = {
    _tid = ID,
    _level = copyUnitLevel,
    _stars = unit.stars,
    _skill_levels = skillLevel,
    _rank = unit.rank,
    _fashion = {
      _current_fashion = skill.caster.fashion_id
    }
  }
  local config = {
    is_summoned_by_DS = true,
    is_summoned = true,
    hp_mod = skill.caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or skill.caster.config.hp_mod,
    dps_mod = skill.caster.config.dps_mod or 1,
    summoner = skill.caster
  }
  if ed.engine:isTowerWarsMode() then
    config.hp_mod = 2
  end
  return ed.UnitCreate(proto, skill.caster.camp, config)
end

function DS.skillult_projectileUpdate(basefunc, self, dt)
  local projectile = self
  local summonlist_DS = self.skill.caster.summonlist_DS
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  if not projectile.terminated then
    projectile.timer = projectile.timer - dt
    local skill = projectile.skill
    if projectile.timer < 0 then
      projectile:terminate()
      projectile.skill.caster.copywar = false
    elseif ed.engine:isTowerWarsMode() and 5 <= #summonlist_DS then
    else
      local direction = skill.caster.direction
      local info = skill.info
      local location = projectile.position
      local origin = {
        location[1] + info["X Shift"] * direction,
        location[2]
      }
      local shape = info["AOE Shape"]
      local arg1 = info["Shape Arg1"]
      local arg2 = info["Shape Arg2"]
      local ID
      for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
        if not unit.config.is_summoned and DS.CheckCopyUnit(summonlist_DS, unit) and not unit.buff_effects.untargetable and unit ~= skill.caster and unit.info["Can Copy"] and DS.checkLevel(self.skill.level, unit.level) and ed.Skill.testPointInShape(ed.edpSub(unit.position, origin), shape, arg1, arg2) then
          local arousal = unit.proto._arousal
          local copyUnit = DS.createCopyUnit(skill, unit)
          local puppet = copyUnit.info["Puppet Switch"]
          if puppet and arousal and arousal._status == 1 then
            copyUnit.puppet_stack = {puppet}
          end
          copyUnit.die = override(copyUnit.die, DS.copyUnit_die)
          copyUnit:setDeathWithEffectOrNot(true)
          copyUnit.mDuration = DS.unitSurvivalTime
          copyUnit.update = override(copyUnit.update, DS.newunit_update)
          local direction2
          if projectile.position[1] > unit.position[1] then
            direction2 = -1
          else
            direction2 = 1
          end
          local locationss1 = {
            unit.position[1] - 75 * direction2,
            unit.position[2]
          }
          copyUnit.direction = direction2
          table.insert(summonlist_DS, copyUnit)
          if ed.run_with_scene then
            ed.scene:playEffectOnScene("eff_point_DS_copy.cha", {
              locationss1[1],
              locationss1[2]
            }, {
              copyUnit.direction,
              1
            }, nil, 1)
          end
          ed.engine:summonUnit(copyUnit, locationss1, skill.caster, "Idle")
          copyUnit:reset()
          copyUnit.position = {
            unit.position[1] - 45 * direction2,
            unit.position[2]
          }
          local percent = unit.hp / unit.attribs.HP
          copyUnit.hp = copyUnit.hp * percent
          local bid2 = 89
          local bid = 357
          local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          copyUnit:addBuff(binfo2, skill.caster)
          copyUnit:addBuff(binfo, skill.caster)
          copyUnit.FatherUnit_DS = unit
        end
        if ed.engine:isTowerWarsMode() and 5 <= #summonlist_DS then
          break
        end
      end
    end
    self.previous_position[1] = self.position[1]
    self.previous_position[2] = self.position[2]
    DS.base.update(self, dt)
    if not projectile.skill.caster:isAlive() or ed.engine.beingEnd then
      projectile.skill.caster.copywar = false
      projectile:terminate()
    end
  end
end

function DS.buff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.owner.copywar = false
end

function DS.skillult_onAttackFrame(basefunc, self)
  local bid = 359
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, self.caster, self.caster)
  buff.onRemoved = override(buff.onRemoved, DS.buff_onRemoved)
  self.caster:addBuff(buff, self.caster)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  local info = self.info
  local caster = self.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = self:createProjectile()
    projectile.position = caster.position
    projectile.height = 0
    projectile.update = override(projectile.update, DS.skillult_projectileUpdate)
    projectile.timer = DS.projectileTime
    ed.engine:addProjectile(projectile)
    if caster then
      caster.copywar = true
    end
    if projectile.actor then
      projectile.actor.ownZOrder = -99
      projectile.actor.ownRotation = 180
    end
  elseif ttype == "chain" then
    local chain = self:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    self:takeEffectAt(self.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function DS.hero_die(basefunc, hero, killer)
  if hero.summonlist_DS then
    for _, copyUnit in ipairs(hero.summonlist_DS) do
      if copyUnit and copyUnit:isAlive() then
        copyUnit:die()
      end
    end
  end
  basefunc(hero, killer)
end

function DS.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.copywar then
    return false, "ultIng"
  end
  return true
end

function DS.init_hero(hero)
  hero.die = override(hero.die, DS.hero_die)
  hero.summonlist_DS = {}
  local skillult = hero.skills.DS_ult
  local skillatk2 = hero.skills.DS_atk2
  local skillatk3 = hero.skills.DS_atk3
  local skillatk4 = hero.skills.DS_atk4
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, DS.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, DS.DS_atk2_createBuff)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, DS.skillatk3_takeEffectOn)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, DS.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, DS.skillult_canCastWithTarget)
  end
  return hero
end

return DS.init_hero
