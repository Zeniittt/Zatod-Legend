module("ed.battlehero", package.seeall)
local ed = ed
WorldUS = {}
WorldUS.ragelosthp = 600000
WorldUS.rage2losthp = 200000
WorldUS.stage2hp = 30000000
WorldUS.stage2ragelosthp = 400000

function WorldUS.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldUS.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldUS.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    buff:setAttribute("Control Effects", {"unheal"})
    if owner.rageStack > 50 then
      buff:setAttribute("Control Effects", {"unheal"})
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

function WorldUS.takeEffectAt(basefunc, self, location, source)
  local info = self.info
  local aoe = self.info["AOE Origin"]
  local direction = self.caster.direction
  if aoe == "self" then
    location = self.caster.position
  end
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  if aoe then
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(self:affectedCamp()) do
      if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == self.caster then
      else
        local p2 = ed.edpSub(unit.position, origin)
        p2[1] = p2[1] * direction
        if self.testPointInShape(p2, shape, arg1, arg2) then
          self:takeEffectOn(unit)
        end
      end
    end
  else
    self:takeEffectOn(self.target, source)
  end
  if ed.run_with_scene then
    local effect_name = info["Point Effect"]
    if not effect_name then
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, origin, {
      self.caster.direction,
      self.ultcharge / 2 + 0.5
    }, nil, effect_z)
  end
end

function WorldUS.canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function WorldUS.onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
    end
    skill.caster.manually_casting = false
    skill.ultbegin = skill.current_phase_elapsed
    skill.attack_counter = 1
  else
    if skill.attack_counter == 1 then
      skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
      skill.ultcharge = math.min(5, skill.ultcharge) / 5
      basefunc(skill)
    else
    end
  end
end

function WorldUS.trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function WorldUS.interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function WorldUS.power(basefunc, skill, source, target, damage_type)
  return basefunc(skill, source, target, damage_type) * skill.ultcharge, 1
end

function WorldUS.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    basefunc(skill, location, source)
    local caster = skill.caster
    local target = skill.target
    local tid = target.info.ID
    local level = target.level
    local stars = target.stars
    local skillevel = target.proto._skill_levels
    local rank = target.rank
    local arousal = target.proto._arousal
    local proto = {
      _tid = tid,
      _level = level,
      _stars = stars,
      _skill_levels = skillevel,
      _arousal = arousal,
      _rank = rank
    }
    local config = {
      is_summoned = true,
      hp_mod = 0.1,
      dps_mod = 0.5,
      size_mod = 1
    }
    local newHero = ed.UnitCreate(proto, caster.camp, config)
    newHero:setDeathWithEffectOrNot(true)
    local location1 = {
      target.position[1] - 80,
      target.position[2]
    }
    newHero.mp = 900
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_tp.cha", {
        location1[1],
        location1[2]
      }, {
        caster.direction,
        1
      }, nil, 1)
    end
    newHero.direction = target.direction
    ed.engine:summonUnit(newHero, location1, caster, "Idle")
    newHero:reset()
    local bid2 = 111
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local bid3 = 259
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    newHero:addBuff(binfo2, caster)
    newHero:addBuff(binfo3, caster)
    caster.newHero = newHero
  end
end

function WorldUS.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  if skill.target then
    skill.caster.skill3originlocation_US = {
      skill.target.position[1],
      skill.target.position[2]
    }
  else
    skill.caster.skill3originlocation_US = {
      skill.caster.position[1],
      skill.caster.position[2]
    }
  end
end

function WorldUS.skillatk3_onAttackFrame(basefunc, self, target)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  local info = self.info
  local caster = self.caster
  if self.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_US_atk3.cha", {
        self.caster.skill3originlocation_US[1],
        self.caster.skill3originlocation_US[2] + 1
      }, {
        self.caster.direction,
        1
      }, nil, 0)
    end
  else
    self:takeEffectAt(self.caster.skill3originlocation_US)
    self.caster.skill3originlocation_US = nil
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  end
end

function WorldUS.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skill = caster.skills.WorldUS_atk3
  if skill.target then
    local skilltarget = skill.target
    if target.info["Main Attrib"] ~= skilltarget.info["Main Attrib"] then
      power = 99999
    end
    local dmg = target:takeDamage({
      amount = power,
      damage_type = damage_type,
      field = field,
      source = source,
      crit_mod = crit_mod,
      skill = self
    })
    return dmg
  else
    local dmg = target:takeDamage({
      amount = power,
      damage_type = damage_type,
      field = field,
      source = source,
      crit_mod = crit_mod
    })
    return dmg
  end
end

function WorldUS.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldUS.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldUS.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldUS.ragelosthp
      boss.rageStack = boss.rageStack + 1
    end
  else
    if not boss.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      boss.stage2ragebuff = boss:addBuff(binfo, boss)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      boss:addBuff(binfo2, boss)
    end
    while boss.lastRageHp - boss.hp >= WorldUS.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldUS.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldUS.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldUS.stage2hp and hero.hp - lost <= WorldUS.stage2hp then
    return hero.hp - WorldUS.stage2hp
  else
    return lost
  end
end

function WorldUS.init_hero(hero)
  hero.update = override(hero.update, WorldUS.boss_update)
  hero.reset = override(hero.reset, WorldUS.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldUS.getLostHPAfterImmunity)
  local skillult = hero.skills.WorldUS_ult
  skillult.info["No Speeder"] = true
  skillult.onAttackFrame = override(skillult.onAttackFrame, WorldUS.onAttackFrame)
  skillult.takeEffectAt = override(skillult.takeEffectAt, WorldUS.takeEffectAt)
  skillult.canTrigger = override(skillult.canTrigger, WorldUS.canTrigger)
  skillult.trigger = override(skillult.trigger, WorldUS.trigger)
  skillult.interrupt = override(skillult.interrupt, WorldUS.interrupt)
  skillult.power = override(skillult.power, WorldUS.power)
  local skillatk2 = hero.skills.WorldUS_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, WorldUS.skillatk2_takeEffectAt)
  end
  local skillatk3 = hero.skills.WorldUS_atk3
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldUS.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, WorldUS.skillatk3_start)
    skillatk3.getDamage = override(skillatk3.getDamage, WorldUS.skillatk3_getDamage)
  end
  return hero
end

return WorldUS.init_hero
