module("ed.battlehero", package.seeall)
local ed = ed
Med = {}
Med.skillatk3 = 10001602
Med.Evoatkstone = 10001603
Med.shard = 10001604

function Med.skillatk2_createProjectile(basefunc, skill)
  local origTarget = skill.target
  local mod = skill.info["Script Arg2"] / 100
  local counter = 0
  local maxcounter = 3
  if skill.evo_rank and skill.evo_rank >= 1 then
    mod = mod + skill.evo_rank1["Script Arg1"] / 100
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    mod = mod + skill.evo_rank2["Script Arg1"] / 100
  end
  if skill.evo_rank and 3 <= skill.evo_rank then
    maxcounter = skill.evo_rank3["Script Arg1"]
  end
  local projectile = basefunc(skill, origTarget)
  projectile.dmgModifier = 1
  projectile:enableTrack(origTarget)
  ed.engine:addProjectile(projectile)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if counter >= maxcounter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    elseif unit == origTarget then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile.dmgModifier = mod
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function Med.skillatk2_power(basefunc, self, source, target, damage_type)
  if source.dmgModifier then
    local dmg, coe = basefunc(self, source, target, damage_type)
    dmg = dmg * source.dmgModifier
    return dmg, coe
  else
    return basefunc(self, source, target, damage_type)
  end
end

function Med.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if isHit and shard and shard._id == 1000161 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local mppower = caster.shardSkill[2]["Script Arg1"]
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
    caster:takeHeal(mppower, "mp", caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function Med.skillatk3_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.Med_ult
  local mppower = skill.info["Script Arg2"]
  if skill.evo_rank and skill.evo_rank >= 1 then
    mppower = mppower + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    mppower = mppower + skill.evo_rank2["Script Arg1"]
  end
  local shard = caster.proto._shard
  if target and not target.config.is_summoned and not target.buff_effects.invulnerable then
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
    caster:takeHeal(mppower, "mp", caster)
    if shard and shard._id == 1000161 and caster.shardSkillRank and 1 <= caster.shardSkillRank then
      target:takeDamage(mppower * caster.shardSkill[1]["Script Arg1"], "AD", "hp", skill.caster)
    end
  end
  if skill.evo_rank and skill.evo_rank >= 3 and target and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable then
    local bid = Med.Evoatkstone
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    if skillult and skillult.evo_rank and skillult.evo_rank >= 3 then
      buff:setAttribute("PIMU", -skillult.evo_rank3["Script Arg1"])
    end
    target:addBuff(buff, caster)
  end
end

function Med.skillstone_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.Med_ult
  if skillult and skillult.evo_rank and skillult.evo_rank >= 3 then
    buff:setAttribute("PIMU", -skillult.evo_rank3["Script Arg1"])
  end
  return buff
end

function Med.hero_reset(basefunc, hero)
  hero.mpup = nil
  hero.shieldup = false
  basefunc(hero)
end

function Med.hero_collectMPchange(basefunc, self, config)
  local unit = config.unit
  if not unit.mpup then
    unit.mpup = 0
  end
  if 0 < config.mp_change and unit.mpup then
    unit.mpup = unit.mpup + config.mp_change
  end
end

function Med.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() then
    local shard = hero.proto._shard
    if shard and shard._id == 1000161 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      local shard3mplimit = hero.shardSkill[3]["Script Arg1"]
      if shard3mplimit <= hero.mpup then
        hero.mpup = hero.mpup - shard3mplimit
        hero.shieldup = true
      end
      if hero.shieldup then
        hero.shieldup = false
        local ShieldIncrease = 0
        local ShieldWeak = 0
        local shard3buff
        if hero.attribs.ShieldIncrease then
          ShieldIncrease = hero.attribs.ShieldIncrease
        end
        if hero.attribs.ShieldWeak then
          ShieldWeak = hero.attribs.ShieldWeak
        end
        local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
        for i, tbuff in ipairs(hero.buff_list) do
          if tbuff.info.ID == Med.shard then
            shard3buff = tbuff
            break
          end
        end
        local shard3shield = hero.shardSkill[3]["Script Arg2"] * hero.attribs.AP * (hero.config.hp_mod or 1) * shieldratio
        if not shard3buff then
          local bid = Med.shard
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, hero, hero)
          buff.shield = shard3shield
          hero:addBuff(buff, hero)
        else
          shard3buff.shield = shard3buff.shield + shard3shield
        end
      end
    end
  end
end

function Med.init_hero(hero)
  local skillult = hero.skills.Med_ult
  local skillatk2 = hero.skills.Med_atk2
  local skillatk3 = hero.skills.Med_atk3
  local skillpasv = hero.passive_skill_list[1]
  local shard = hero.proto._shard
  if shard and shard._id == 1000161 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
    hero.update = override(hero.update, Med.hero_update)
    hero.collectMPchange = override(hero.collectMPchange, Med.hero_collectMPchange)
    hero.reset = override(hero.reset, Med.hero_reset)
  end
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
    skillult.createBuff = override(skillult.createBuff, Med.skillstone_createBuff)
  end
  if skillatk2 then
    hero.basic_skill = skillatk2
    skillatk2.createProjectile = override(skillatk2.createProjectile, Med.skillatk2_createProjectile)
    skillatk2.power = override(skillatk2.power, Med.skillatk2_power)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Med.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Med.skillatk3_takeEffectOn)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and 3 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return Med.init_hero
