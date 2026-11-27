module("ed.battlehero", package.seeall)
local ed = ed
WorldSD = {}
WorldSD.ultvirus_bid = 1444
WorldSD.virusMP = 700
WorldSD.antibody_bid = 1445
WorldSD.skillatk3_mp = 100
WorldSD.ragelosthp = 600000
WorldSD.rage2losthp = 200000
WorldSD.stage2hp = 30000000
WorldSD.stage2ragelosthp = 200000

function WorldSD.haveantibuff(unit)
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == WorldSD.antibody_bid then
      return true
    end
  end
  return false
end

function WorldSD.skillult_selectTarget(basefunc, self, defult)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      elseif WorldSD.haveantibuff(unit) then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function WorldSD.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    basefunc(skill)
    local caster = skill.caster
    local skillatk2 = caster.skills.WorldSD_atk2
    skillatk2:takeEffectAt(caster.position)
  end
end

function WorldSD.skillult_buffonRemoved(basefunc, buff)
  local caster = buff.caster
  if caster.virusKillProjectile then
    caster.virusKillProjectile:terminate()
    WorldSD.virusInfect(caster, buff.owner)
  end
  basefunc(buff)
end

function WorldSD.skillult_buffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
end

function WorldSD.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local ultb = caster.skills.WorldSD_ultb
  if ultb then
    local virusKillProjectile = ultb:createProjectile()
    caster.virusKillProjectile = virusKillProjectile
    virusKillProjectile.infectbuff = buff
    virusKillProjectile.WorldSD_watchTarget = target
    virusKillProjectile.WorldSD_alreadyvirusKill = false
    ed.engine:addProjectile(virusKillProjectile)
  end
  buff.onRemoved = override(buff.onRemoved, WorldSD.skillult_buffonRemoved)
  return buff
end

function WorldSD.skillultb_projectile_freeze(basefunc, projectile)
end

function WorldSD.skillultb_projectile_update(basefunc, projectile, dt)
  local watchTarget = projectile.WorldSD_watchTarget
  local caster = projectile.caster
  if not projectile.terminated then
    projectile.count_time = projectile.count_time - dt
    if projectile.count_time <= 0 and watchTarget:isAlive() and caster then
      if ed.run_with_scene then
        local effect_name = "eff_buff_VIS_awakeb"
        ed.scene:playEffectOnScene(effect_name, watchTarget.position, {1, 1}, nil, 0)
      end
      watchTarget:die(caster)
      local remainHp = watchTarget.hp
      caster.battledata:addDamage(remainHp, "Holy")
      if ed.run_with_scene and watchTarget.actor then
        local str = "-" .. math.floor(remainHp + 0.5)
        if str ~= "-0" then
          local color
          if watchTarget.camp == ed.emCampPlayer then
            color = "red"
          else
            color = "orange"
          end
          if not watchTarget.notPopupBattleInfo then
            ed.PopupCreate(str, color, watchTarget.actor, false)
          end
        end
      end
    end
  end
  if watchTarget.state == ed.emUnitState_Dying then
    watchTarget.state = ed.emUnitState_Dead
    watchTarget:setAction(nil)
    watchTarget.hasCorpse = false
    if watchTarget.actor and watchTarget.actor.node then
      watchTarget.actor.node:setVisible(false)
    end
  elseif watchTarget.state == ed.emUnitState_Dead then
  end
  if projectile.count_time <= 0 and projectile.infectbuff then
    projectile.count_time = 10
    projectile.infectbuff.timer = 0
  end
end

function WorldSD.skillultb_createProjectile(basefunc, skill)
  local virusKillProjectile = basefunc(skill)
  virusKillProjectile.update = override(virusKillProjectile.update, WorldSD.skillultb_projectile_update)
  virusKillProjectile.freeze = override(virusKillProjectile.freeze, WorldSD.skillultb_projectile_freeze)
  virusKillProjectile.height = 999
  virusKillProjectile.count_time = 10
  return virusKillProjectile
end

function WorldSD.antibody_projectile_update(basefunc, projectile, dt)
  local caster = projectile.caster
  if not projectile.terminated then
    projectile.antibody_count_time = projectile.antibody_count_time - dt
  end
  if projectile.antibody_count_time <= 0 and projectile.antibodybuff then
    projectile.antibody_count_time = 32
    projectile.antibodybuff.timer = 0
    projectile:terminate()
  end
end

function WorldSD.antibody_createProjectile(basefunc, skill)
  local antibodyProjectile = basefunc(skill)
  antibodyProjectile.update = override(antibodyProjectile.update, WorldSD.antibody_projectile_update)
  antibodyProjectile.freeze = override(antibodyProjectile.freeze, WorldSD.skillultb_projectile_freeze)
  antibodyProjectile.height = 998
  antibodyProjectile.antibody_count_time = 32
  return antibodyProjectile
end

function WorldSD:allhaveantibodywithoutself(hero)
  local allhaveantibody = true
  for unit in ed.engine:foreachAliveUnit(self.foecamp) do
    local haveantibody
    if unit == hero then
    elseif not unit:isHero() then
    elseif unit.proto and (unit.proto._tid == 220 or unit.proto._tid == 221) then
    else
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == WorldSD.antibody_bid then
          haveantibody = true
        end
      end
      if not haveantibody then
        allhaveantibody = nil
      end
    end
  end
  return allhaveantibody
end

function WorldSD.collectMPchange(basefunc, self, config)
  local unit = config.unit
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == WorldSD.ultvirus_bid and config.mp < unit.mp then
      local inlist
      for i, hero in ipairs(self.WorldSD_herolist) do
        if unit == hero[1] then
          inlist = true
          local addmp = unit.mp - config.mp
          self.WorldSD_herolist[i][2] = addmp + self.WorldSD_herolist[i][2]
          if self.WorldSD_herolist[i][2] >= WorldSD.virusMP and not WorldSD.allhaveantibodywithoutself(self, unit) then
            self.WorldSD_herolist[i][2] = 0
            for i, tbuff in ipairs(unit.buff_list) do
              if tbuff.info.ID == WorldSD.ultvirus_bid then
                unit:removeBuff(tbuff)
              end
            end
          end
        end
      end
      if not inlist then
        if unit.mp - config.mp < WorldSD.virusMP then
          table.insert(self.WorldSD_herolist, {
            unit,
            unit.mp - config.mp
          })
        elseif not WorldSD.allhaveantibodywithoutself(self, unit) then
          table.insert(self.WorldSD_herolist, {unit, 0})
          for i, tbuff in ipairs(unit.buff_list) do
            if tbuff.info.ID == WorldSD.ultvirus_bid then
              unit:removeBuff(tbuff)
            end
          end
        end
      end
    end
  end
end

function WorldSD:virusInfect(basehero)
  local skillult = self.skills.WorldSD_ult
  local infectover
  for unit in ed.engine:foreachAliveUnit(basehero.camp) do
    if unit:isHero() and unit ~= basehero and not infectover and (not unit.proto or unit.proto._tid ~= 220 and unit.proto._tid ~= 221) then
      local haveAntibody
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == WorldSD.antibody_bid then
          haveAntibody = true
        end
      end
      if not haveAntibody then
        unit:addBuff(skillult:createBuff(unit), self)
        if basehero:isAlive() then
          local bid = WorldSD.antibody_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local antibody_buff = basehero:addBuff(binfo, self)
          local caster = self
          local skillantibody = caster.skills.WorldSD_antibody
          local antibodyProjectile = skillantibody:createProjectile()
          antibody_buff.antibodyProjectile = antibodyProjectile
          antibodyProjectile.antibodybuff = antibody_buff
          ed.engine:addProjectile(antibodyProjectile)
        end
        infectover = true
      end
    end
  end
end

function WorldSD.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if target.mp + WorldSD.skillatk3_mp >= 1000 then
    power = power * 2
  end
  return power
end

function WorldSD.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result and target then
    target:takeHeal(WorldSD.skillatk3_mp, "mp", caster)
  end
end

function WorldSD.hero_getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type, source)
  local lost = basefunc(unit, damage, immunity, damage_type, source) / 2
  if source then
    for i, tbuff in ipairs(source.buff_list) do
      if tbuff.info.ID == WorldSD.antibody_bid then
        lost = lost * 2
        break
      end
    end
  end
  return lost
end

function WorldSD.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldSD.rage_buff_update)
  hero.lastrageStack = 0
  hero.WorldSD_herolist = {}
  hero.mp = 1000
end

function WorldSD.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
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

function WorldSD.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.WorldSD_ult
  hero.WorldSD_novirus = true
  hero.WorldSD_onenoantibody = nil
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    if not unit:isHero() then
    elseif unit.proto and (unit.proto._tid == 220 or unit.proto._tid == 221) then
    else
      local haveantibody
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == WorldSD.antibody_bid then
          haveantibody = true
        end
        if tbuff.info.ID == WorldSD.ultvirus_bid then
          hero.WorldSD_novirus = nil
        end
      end
      if not haveantibody then
        hero.WorldSD_onenoantibody = true
      end
    end
  end
  if hero.mp < 1000 and hero.WorldSD_onenoantibody and hero.WorldSD_novirus and hero.current_skill ~= skillult then
    hero:takeHeal(9999, "mp", hero)
  end
  if not hero.lastRageHp then
    hero.rageStack = 0
    hero.lastRageHp = hero.hp
  end
  if hero.attribs.HP - hero.hp < WorldSD.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldSD.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSD.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldSD.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSD.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldSD.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldSD.stage2hp and hero.hp - lost <= WorldSD.stage2hp then
    return hero.hp - WorldSD.stage2hp
  else
    return lost
  end
end

function WorldSD.init_hero(hero)
  local skillult = hero.skills.WorldSD_ult
  local skillultb = hero.skills.WorldSD_ultb
  local skillatk3 = hero.skills.WorldSD_atk3
  local skillantibody = hero.skills.WorldSD_antibody
  if skillult then
    skillult.createBuff = override(skillult.createBuff, WorldSD.skillult_createBuff)
    skillult.selectTarget = override(skillult.selectTarget, WorldSD.skillult_selectTarget)
    skillultb.createProjectile = override(skillultb.createProjectile, WorldSD.skillultb_createProjectile)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldSD.skillult_onAttackFrame)
    skillantibody.createProjectile = override(skillantibody.createProjectile, WorldSD.antibody_createProjectile)
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, WorldSD.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldSD.skillatk3_takeEffectOn)
  end
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldSD.hero_getLostHPAfterImmunity)
  hero.reset = override(hero.reset, WorldSD.hero_reset)
  hero.update = override(hero.update, WorldSD.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldSD.getLostHPAfterImmunity)
  hero.collectMPchange = override(hero.collectMPchange, WorldSD.collectMPchange)
  return hero
end

return WorldSD.init_hero
