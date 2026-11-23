module("ed.battlehero", package.seeall)
local ed = ed
PL = {}
PL.mirrorbuff = 10005401
PL.mirrorAttribs = 10005403
PL.shardbuff = 10005404
PL.shardbuff_interval = 1
PL.mirror_time = 12
PL.skillminSQ = 18225
PL.FashionID_2 = 542

function PL.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
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
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function PL.LancerMirror_update(basefunc, unit, dt)
  unit.mDuration_PL = unit.mDuration_PL - dt
  if unit.mDuration_PL <= 0 and unit:isAlive() then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function PL.Lancer_mirrorFunction(unit)
  unit.update = override(unit.update, PL.LancerMirror_update)
  unit.die = override(unit.die, PL.LancerMirror_die)
end

function PL.LancerMirror_die(basefunc, unit, killer)
  basefunc(unit, killer)
  local caster = unit.config.summoner
  if caster and caster.Lancer_mirror_count > 0 then
    caster.Lancer_mirror_count = caster.Lancer_mirror_count - 1
  end
end

function PL.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local locationtb
  if attack_counter == 2 then
    local proto = {
      _tid = 147,
      _level = skill.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = caster.fashion_id
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1,
      summoner = caster
    }
    local LancerMirror = ed.UnitCreate(proto, caster.camp, config)
    local bid = PL.mirrorbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = LancerMirror:addBuff(ed.copyTable(binfo), caster)
    LancerMirror.mDuration_PL = PL.mirror_time
    local skillatk = LancerMirror.skills.PLmirror_atk
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, PL.mirrorskillshard_takeEffectOn)
    PL.Lancer_mirrorFunction(LancerMirror)
    LancerMirror:setDeathWithEffectOrNot(true)
    LancerMirror.direction = caster.direction
    locationtb = {
      caster.position[1],
      caster.position[2]
    }
    local fashionId = caster.fashion_id
    if fashionId and fashionId == PL.FashionID_2 then
      LancerMirror:pushPuppet("Lancer_fashion_2.cha")
    end
    ed.engine:summonUnit(LancerMirror, locationtb, caster)
    local PLmirrorattribs = skill.info["Script Arg5"] / 100
    if skill.evo_rank and skill.evo_rank >= 3 then
      PLmirrorattribs = PLmirrorattribs + skill.evo_rank3["Script Arg1"] / 100
    end
    local AttriBinfo = ed.lookupDataTable("Buff", nil, PL.mirrorAttribs)
    PL.changeBuffInfo(AttriBinfo, PLmirrorattribs, LancerMirror)
    local buffattribs = LancerMirror:addBuff(ed.copyTable(AttriBinfo), caster)
    LancerMirror:takeHeal(LancerMirror.attribs.HP, "hp")
    table.insert(caster.LancerMirrorult, LancerMirror)
    caster.Lancer_mirror_count = caster.Lancer_mirror_count + 1
  end
end

function PL.skillshard_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000541 and caster.shardSkillRank and caster.shardSkillRank >= 3 and isHit then
    target:takeDamage(caster.shardSkill[3]["Script Arg1"], "Holy", "mp", skill.caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function PL.mirrorskillshard_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local summoner = skill.caster.config.summoner
  local caster = skill.caster
  local shard = summoner.proto._shard
  if shard and shard._id == 1000541 and summoner.shardSkillRank and summoner.shardSkillRank >= 3 and isHit then
    target:takeDamage(summoner.shardSkill[3]["Script Arg1"], "Holy", "mp", caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function PL.skillatk3_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.Lancer_atk3
  local proto = {
    _tid = 147,
    _level = skillatk3.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = caster.fashion_id
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local LancerMirror = ed.UnitCreate(proto, caster.camp, config)
  local bid = PL.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror:addBuff(ed.copyTable(binfo), caster)
  LancerMirror.mDuration_PL = PL.mirror_time
  PL.Lancer_mirrorFunction(LancerMirror)
  LancerMirror:setDeathWithEffectOrNot(true)
  local skillatk = LancerMirror.skills.PLmirror_atk
  skillatk.takeEffectOn = override(skillatk.takeEffectOn, PL.mirrorskillshard_takeEffectOn)
  LancerMirror.direction = caster.direction
  local locationtb = {
    target.position[1] + 70 * LancerMirror.direction,
    target.position[2]
  }
  if skill.target.buff_effects.stable or locationtb[1] > 799 or locationtb[1] < 1 then
    locationtb[1] = target.position[1] - 70 * LancerMirror.direction
  end
  local owner = skill.caster
  if skill.caster:isAlive() then
    local fashionId = caster.fashion_id
    if fashionId and fashionId == PL.FashionID_2 then
      LancerMirror:pushPuppet("Lancer_fashion_2.cha")
    end
    ed.engine:summonUnit(LancerMirror, locationtb, caster)
    caster.Lancer_mirror_count = caster.Lancer_mirror_count + 1
  end
  local PLmirrorattribs = skill.info["Script Arg5"] / 100
  if skill.evo_rank and skill.evo_rank >= 3 then
    PLmirrorattribs = PLmirrorattribs + skill.evo_rank3["Script Arg1"] / 100
  end
  local AttriBinfo = ed.lookupDataTable("Buff", nil, PL.mirrorAttribs)
  PL.changeBuffInfo(AttriBinfo, PLmirrorattribs, LancerMirror)
  local buffattribs = LancerMirror:addBuff(ed.copyTable(AttriBinfo), caster)
  LancerMirror:takeHeal(LancerMirror.attribs.HP, "hp")
  table.insert(caster.LancerMirrorult, LancerMirror)
  return isHit, dmg, Crit, lfs_amount
end

function PL.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local proto = {
    _tid = 147,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = caster.fashion_id
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local LancerMirror1 = ed.UnitCreate(proto, caster.camp, config)
  local bid = PL.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror1:addBuff(ed.copyTable(binfo), caster)
  LancerMirror1.mDuration_PL = PL.mirror_time
  PL.Lancer_mirrorFunction(LancerMirror1)
  LancerMirror1:setDeathWithEffectOrNot(true)
  local LancerMirror2 = ed.UnitCreate(proto, caster.camp, config)
  local bid = PL.mirrorbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = LancerMirror2:addBuff(ed.copyTable(binfo), caster)
  LancerMirror2.mDuration_PL = PL.mirror_time
  PL.Lancer_mirrorFunction(LancerMirror2)
  LancerMirror2:setDeathWithEffectOrNot(true)
  LancerMirror1.direction = caster.direction
  local LancerMirrorlocation = location[1] + LancerMirror1.direction * 40
  if 750 < LancerMirrorlocation then
    LancerMirrorlocation = 750
  elseif LancerMirrorlocation < 50 then
    LancerMirrorlocation = 50
  end
  local locationtb21 = {
    LancerMirrorlocation,
    location[2] + LancerMirror1.direction * 30
  }
  local locationtb22 = {
    LancerMirrorlocation,
    location[2] - LancerMirror2.direction * 30
  }
  local casterlocation = caster.position[1] - LancerMirror1.direction * 40
  if 750 < casterlocation then
    casterlocation = 750
  elseif casterlocation < 50 then
    casterlocation = 50
  end
  caster.position[1] = casterlocation
  local fashionId = caster.fashion_id
  if fashionId and fashionId == PL.FashionID_2 then
    LancerMirror1:pushPuppet("Lancer_fashion_2.cha")
  end
  ed.engine:summonUnit(LancerMirror1, locationtb21, caster, "Birth")
  table.insert(caster.LancerMirrorult, LancerMirror1)
  local fashionId = caster.fashion_id
  if fashionId and fashionId == PL.FashionID_2 then
    LancerMirror2:pushPuppet("Lancer_fashion_2.cha")
  end
  ed.engine:summonUnit(LancerMirror2, locationtb22, caster, "Birth")
  table.insert(caster.LancerMirrorult, LancerMirror2)
  local skillatk = LancerMirror1.skills.PLmirror_atk
  local skillatks = LancerMirror2.skills.PLmirror_atk
  skillatk.takeEffectOn = override(skillatk.takeEffectOn, PL.mirrorskillshard_takeEffectOn)
  skillatks.takeEffectOn = override(skillatks.takeEffectOn, PL.mirrorskillshard_takeEffectOn)
  local PLmirrorattribs = skill.info["Script Arg5"] / 100
  if skill.evo_rank and 1 <= skill.evo_rank then
    PLmirrorattribs = PLmirrorattribs + skill.evo_rank1["Script Arg1"] / 100
  end
  if skill.evo_rank and 2 <= skill.evo_rank then
    PLmirrorattribs = PLmirrorattribs + skill.evo_rank2["Script Arg1"] / 100
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    LancerMirror1.mDuration_PL = skill.evo_rank3["Script Arg1"]
    LancerMirror2.mDuration_PL = skill.evo_rank3["Script Arg1"]
  end
  local AttriBinfo = ed.lookupDataTable("Buff", nil, PL.mirrorAttribs)
  PL.changeBuffInfo(AttriBinfo, PLmirrorattribs, LancerMirror1)
  local buffattribs1 = LancerMirror1:addBuff(ed.copyTable(AttriBinfo), caster)
  LancerMirror1:takeHeal(LancerMirror1.attribs.HP, "hp")
  local buffattribs2 = LancerMirror2:addBuff(ed.copyTable(AttriBinfo), caster)
  LancerMirror2:takeHeal(LancerMirror2.attribs.HP, "hp")
  caster.Lancer_mirror_count = caster.Lancer_mirror_count + 2
end

function PL.skillult_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  local attack_counter = self.attack_counter
  if attack_counter == 2 then
    return 0, i
  end
  return power, i
end

function PL.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Lancer_mirror_count = 0
  hero.LancerMirrorult = {}
  local shard = hero.proto._shard
  if shard and shard._id == 1000541 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
    local bid = PL.shardbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.lastadcount = 0
    buff.attack_timer = PL.shardbuff_interval
    buff.update = override(buff.update, PL.shardbuff_update)
    hero:addBuff(buff, hero)
  end
end

function PL.shardbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + PL.shardbuff_interval
    local unit = buff.owner
    local adcount = unit.Lancer_mirror_count
    if adcount ~= buff.lastadcount then
      buff.lastadcount = adcount
      local adratio = unit.shardSkill[2]["Script Arg1"] / 100
      buff:setAttribute("AD", unit.oriad * adratio * adcount)
      unit:rebuild()
    end
  end
  buff.attack_timer = timer
end

function PL.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function PL.hero_die(basefunc, hero, killer)
  for _, mirror in pairs(hero.LancerMirrorult) do
    if mirror and mirror:isAlive() then
      mirror:die()
    end
  end
  basefunc(hero, killer)
end

function PL.skillatk_start(basefunc, self, target)
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
  if distanceSQ > PL.skillminSQ then
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
  if distanceSQ > PL.skillminSQ then
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

function PL.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function PL.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = projectile.skill.target
  if not target then
    return
  end
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000541 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    projectile:enableJump(caster.shardSkill[1]["Script Arg1"] + 1)
  end
  projectile:enableTrack(target)
  return projectile
end

function PL.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if 2 <= attack_counter and attack_counter <= 6 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 320
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

function PL.skillatk_finish(basefunc, skill)
  skill.originfo = skill.info
  basefunc(skill)
end

function PL.init_hero(hero)
  hero.Lancer_mirror_count = 0
  hero.die = override(hero.die, PL.hero_die)
  if hero.name == "Lancer" then
    hero.reset = override(hero.reset, PL.hero_reset)
    hero.update = override(hero.update, PL.hero_update)
  end
  hero.oriad = hero.attribs.AD
  hero.LancerMirrorult = {}
  local skillult = hero.skills.Lancer_ult
  local skillatk = hero.skills.Lancer_atk
  local skillatk2 = hero.skills.Lancer_atk2
  local skillatk3 = hero.skills.Lancer_atk3
  local skillaura = hero.aura_skill_list[1]
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    skillult.takeEffectAt = override(skillult.takeEffectAt, PL.skillult_takeEffectAt)
    skillult.power = override(skillult.power, PL.skillult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, PL.skillult_onAttackFrame)
  end
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, PL.skillatk2_takeEffectAt)
  end
  hero.info.mDuration = PL.mirror_time
  if skillatk then
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, PL.skillatk_onPhaseFinished)
    skillatk.start = override(skillatk.start, PL.skillatk_start)
    skillatk.finish = override(skillatk.finish, PL.skillatk_finish)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, PL.skillshard_takeEffectOn)
  end
  if skillatk3 then
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, PL.skillatk3_takeEffectOn)
    skillatk3.createProjectile = override(skillatk3.createProjectile, PL.skillatk3_createProjectile)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 2 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return PL.init_hero
