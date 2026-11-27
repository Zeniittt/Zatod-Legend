module("ed.battlehero", package.seeall)
local ed = ed
WorldLancer = {}
WorldLancer.TB_range_interval = 150
WorldLancer.mirror_time = 12
WorldLancer.ragelosthp = 35000
WorldLancer.rage2losthp = 15000
WorldLancer.skillminSQ = 18225
WorldLancer.stage2hp = 1750000
WorldLancer.stage2ragelosthp = 7500

function WorldLancer.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldLancer.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldLancer.rage_buff_update(basefunc, buff, dt)
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

function WorldLancer.babelMirror_setHP(basefunc, mirror, hp, reason)
  local hp1 = mirror.hp
  basefunc(mirror, hp, reason)
  local summoner = mirror.config.is_summoned and mirror.config.summoner
  if summoner then
    local deltaHp = mirror.hp - hp1
    summoner:setHP(summoner.hp + deltaHp)
    if summoner.hp == 0 then
      summoner:onDying(summoner)
    end
  end
end

function WorldLancer.babelBossLoseHp(mirror)
  if ed.engine.babelMode then
    mirror.setHP = override(mirror.setHP, WorldLancer.babelMirror_setHP)
  end
end

function WorldLancer.LancerMirror2_update(basefunc, unit, dt)
  unit.mDuration_PL = unit.mDuration_PL - dt
  if unit.mDuration_PL <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function WorldLancer.LancerMirror_update(basefunc, unit, dt)
  unit.mDuration_PL = unit.mDuration_PL - dt
  if unit.mDuration_PL <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function WorldLancer.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local locationtb
  local awake = ed.protoAwake(caster.proto, 54)
  if attack_counter == 2 then
    local proto = {
      _tid = 203,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1
    }
    local LancerMirror = ed.UnitCreate(proto, caster.camp, config)
    local bid = 89
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = LancerMirror:addBuff(binfo, caster)
    LancerMirror.mDuration_PL = WorldLancer.mirror_time
    LancerMirror.update = override(LancerMirror.update, WorldLancer.LancerMirror_update)
    LancerMirror:setDeathWithEffectOrNot(true)
    LancerMirror.direction = caster.direction
    locationtb = {
      caster.position[1],
      caster.position[2]
    }
    ed.engine:summonUnit(LancerMirror, locationtb, caster)
    table.insert(caster.WorldLancer_mob, LancerMirror)
    WorldLancer.babelBossLoseHp(LancerMirror)
  end
end

function WorldLancer.atk3_buff_onRemoved(basefunc, buff)
  local skillatk3 = buff.caster.skills.WorldLancer_atk3
  local bid = 488
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  buff.owner:addBuff(binfo, buff.caster)
  basefunc(buff)
end

function WorldLancer.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldLancer.atk3_buff_onRemoved)
  return buff
end

function WorldLancer.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableJump(4)
  projectile:enableTrack(target)
  
  function projectile:findNextTaeget()
    skill.target.ishurt = true
    local jump_gap = 6400
    local abs = math.abs
    local min = {
      0,
      math.huge
    }
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
      else
        local times = self.affect_times[unit] or 0
        if times > min[1] then
        else
          local distanceSQ = abs(ed.edpDistanceSQ(unit.position, self.source.position) - jump_gap)
          if distanceSQ > min[2] then
          elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
            ret = unit
            min = {times, distanceSQ}
          end
        end
      end
    end
    if ret then
      projectile:enableTrack(ret)
    end
    return ret
  end
  
  skill.caster.atk3_projectile = projectile
  return projectile
end

function WorldLancer.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local affectTarget = target
  if affectTarget and not affectTarget.buff_effects.invulnerable and not affectTarget.buff_effects.uncontrollable then
    if skill.caster.atk3_projectile.jumps == 4 then
      local bid = 483
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      if target then
        local buff = target:addBuff(binfo, skill.caster)
      end
    elseif skill.caster.atk3_projectile.jumps == 3 then
      local bid = 484
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      if target then
        local buff = target:addBuff(binfo, skill.caster)
      end
    elseif skill.caster.atk3_projectile.jumps == 2 then
      local bid = 485
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      if target then
        local buff = target:addBuff(binfo, skill.caster)
      end
    elseif skill.caster.atk3_projectile.jumps == 1 then
      local bid = 486
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      if target then
        local buff = target:addBuff(binfo, skill.caster)
      end
    end
  end
  local caster = skill.caster
  local skillatk3 = caster.skills.WorldLancer_atk3
  local awake = ed.protoAwake(caster.proto, 54)
  local proto = {
    _tid = 203,
    _level = skillatk3.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local LancerMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror:addBuff(binfo, caster)
  LancerMirror.mDuration_PL = WorldLancer.mirror_time
  LancerMirror.update = override(LancerMirror.update, WorldLancer.LancerMirror_update)
  LancerMirror:setDeathWithEffectOrNot(true)
  LancerMirror.direction = caster.direction
  local locationtb = {
    target.position[1] + 70 * LancerMirror.direction,
    target.position[2]
  }
  if skill.target.buff_effects.stable or locationtb[1] > 799 or locationtb[1] < 1 then
    locationtb[1] = target.position[1] - 70 * LancerMirror.direction
  end
  local owner = skill.caster
  local skillatk3 = owner.skills.WorldLancer_atk3
  local mobrate = skillatk3.info["Script Arg2"]
  if skill.caster:isAlive() then
    ed.engine:summonUnit(LancerMirror, locationtb, caster)
    table.insert(caster.WorldLancer_mob, LancerMirror)
    WorldLancer.babelBossLoseHp(LancerMirror)
  end
end

function WorldLancer.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local awake = ed.protoAwake(caster.proto, 54)
  local proto = {
    _tid = 203,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local LancerMirror1 = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror1:addBuff(binfo, caster)
  LancerMirror1.mDuration_PL = WorldLancer.mirror_time
  LancerMirror1.update = override(LancerMirror1.update, WorldLancer.LancerMirror_update)
  LancerMirror1:setDeathWithEffectOrNot(true)
  local LancerMirror2 = ed.UnitCreate(proto, caster.camp, config)
  local bid = 89
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror2:addBuff(binfo, caster)
  LancerMirror2.mDuration_PL = WorldLancer.mirror_time
  LancerMirror2.update = override(LancerMirror2.update, WorldLancer.LancerMirror_update)
  LancerMirror2:setDeathWithEffectOrNot(true)
  LancerMirror1.direction = caster.direction
  local locationtb21 = {
    location[1] + LancerMirror1.direction * 40,
    location[2] + LancerMirror1.direction * 30
  }
  local locationtb22 = {
    location[1] + LancerMirror2.direction * 40,
    location[2] - LancerMirror2.direction * 30
  }
  caster.position[1] = caster.position[1] - LancerMirror1.direction * 40
  ed.engine:summonUnit(LancerMirror1, locationtb21, caster, "Birth")
  table.insert(caster.WorldLancer_mob, LancerMirror1)
  WorldLancer.babelBossLoseHp(LancerMirror1)
  ed.engine:summonUnit(LancerMirror2, locationtb22, caster, "Birth")
  table.insert(caster.WorldLancer_mob, LancerMirror2)
  WorldLancer.babelBossLoseHp(LancerMirror2)
end

function WorldLancer.skillult_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  local attack_counter = self.attack_counter
  if attack_counter == 2 then
    return 0, i
  end
  return power, i
end

function WorldLancer.hero_die(basefunc, hero, killer)
  for _, unit in pairs(hero.WorldLancer_mob) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function WorldLancer.skillatk_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local caster = self.caster
  local distanceSQ = (self.target.position[1] - caster.position[1]) ^ 2
  self.originfo = self.info
  if distanceSQ > WorldLancer.skillminSQ then
    self.info = ed.wraptable(self.originfo, {
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 231,
      ["Shape Arg2"] = 150
    })
  else
    self.info = ed.wraptable(self.originfo, {
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 140,
      ["Shape Arg2"] = false
    })
  end
  if distanceSQ > WorldLancer.skillminSQ then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function WorldLancer.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function WorldLancer.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if 2 <= attack_counter and attack_counter <= 6 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 241
    })
    basefunc(skill)
    skill.info = originfo
  else
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 300
    })
    basefunc(skill)
    skill.info = originfo
  end
end

function WorldLancer.skillult_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local summon_num = 0
  for unit in ed.engine:foreachAliveUnit(-skill:affectedCamp()) do
    if unit.name == "WorldLancerMir" and unit.config.summoner and unit.config.summoner.name == "WorldLancer" then
      summon_num = summon_num + 1
    end
    power = power * (1 + summon_num * 0.1)
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = skill
  })
  return dmg
end

function WorldLancer.skillatk_finish(basefunc, skill)
  skill.originfo = skill.info
  basefunc(skill)
end

function WorldLancer.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldLancer.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldLancer.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldLancer.ragelosthp
      boss.rageStack = boss.rageStack + 1
    end
  elseif not ed.engine.babelMode then
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
    while boss.lastRageHp - boss.hp >= WorldLancer.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldLancer.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldLancer.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldLancer.stage2hp and hero.hp - lost <= WorldLancer.stage2hp then
    return hero.hp - WorldLancer.stage2hp
  else
    return lost
  end
end

function WorldLancer.init_hero(hero)
  hero.WorldLancer_mob = {}
  hero.die = override(hero.die, WorldLancer.hero_die)
  hero.reset = override(hero.reset, WorldLancer.reset)
  hero.update = override(hero.update, WorldLancer.boss_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldLancer.getLostHPAfterImmunity)
  local skillult = hero.skills.WorldLancer_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, WorldLancer.skillult_takeEffectAt)
    skillult.power = override(skillult.power, WorldLancer.skillult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldLancer.skillult_onAttackFrame)
    skillult.getDamage = override(skillult.getDamage, WorldLancer.skillult_getDamage)
  end
  local skillatk2 = hero.skills.WorldLancer_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, WorldLancer.skillatk2_takeEffectAt)
  end
  hero.info.mDuration = WorldLancer.mirror_time
  local skillatk = hero.skills.WorldLancer_atk
  if skillatk then
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, WorldLancer.skillatk_onPhaseFinished)
    skillatk.start = override(skillatk.start, WorldLancer.skillatk_start)
    skillatk.finish = override(skillatk.finish, WorldLancer.skillatk_finish)
  end
  local skillatk3 = hero.skills.WorldLancer_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldLancer.skillatk3_takeEffectOn)
    skillatk3.createProjectile = override(skillatk3.createProjectile, WorldLancer.skillatk3_createProjectile)
    skillatk3.createBuff = override(skillatk3.createBuff, WorldLancer.skillatk3_createBuff)
  end
  return hero
end

return WorldLancer.init_hero
