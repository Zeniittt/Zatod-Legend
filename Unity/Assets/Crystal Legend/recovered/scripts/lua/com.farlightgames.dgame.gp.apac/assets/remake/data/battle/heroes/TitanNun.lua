module("ed.battlehero", package.seeall)
local ed = ed
TitanNun = {}
TitanNun.atk2_distance = 100
TitanNun.skillult_startBuffID = 1689
TitanNun.skillult_mirrorBuffID = 1690
TitanNun.skillatk_attack_range = 0
TitanNun.skillatk2_buff1ID = 1691
TitanNun.skillatk2_buff2ID = 1692
TitanNun.skillatk3s_buffID = 1693
TitanNun.ult_position = {
  {-25, 0},
  {0, 0},
  {-25, 0}
}
TitanNun.skillatk4a_ratio_atk = 25
TitanNun.skillatk4a_ratio_atk2 = 100
TitanNun.skillatk4a_ratio_ult = 50
TitanNun.skillatk4b_ratio_atk = 0.1
TitanNun.skillatk4b_ratio_atk2 = 0.15
TitanNun.skillatk4b_ratio_ult = 0.3
TitanNun.skillArcana2_buffID = 1696
TitanNun.skillArcana3_ratio = 0.5
TitanNun.skillatk4_buffID = 1695
TitanNun.maxHp = 30000
TitanNun.TitanNun_fashionID = 101071

function TitanNun.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.TitanNun_atk4
  if skillatk4 then
    local bid = TitanNun.skillatk4_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("MSPD", skillatk4.info["Script Arg2"])
    buff:setAttribute("HAST", skillatk4.info["Script Arg2"])
    hero:addBuff(buff, hero)
  end
end

function TitanNun.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if TitanNun.TitanNun_fashionID and TitanNun.TitanNun_fashionID == hero.fashion_id and not hero.fashion_InfoChange then
    local skillult = hero.skills.TitanNun_ult
    local skillult4 = hero.skills.TitanNun_ult4
    local skillatk = hero.skills.TitanNun_atk
    local skillatks = hero.skills.TitanNun_atks
    local skillatk2 = hero.skills.TitanNun_atk2
    local skillatk3 = hero.skills.TitanNun_atk3
    local skillatk3s = hero.skills.TitanNun_atk3s
    local skillatk4 = hero.skills.TitanNun_atk4
    local skillatk4a = hero.skills.TitanNun_atk4a
    local skillatk4b = hero.skills.TitanNun_atk4b
    local originfo = skillatk.info
    skillatk.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_TitanNun_skin_atk.cha"
    })
    local originfo4 = skillult4.info
    skillult4.info = ed.wraptable(originfo4, {
      ["Impact Effect"] = "eff_impact_TitanNun_skin_ult.cha",
      ["Tile Art"] = "eff_tile_TitanNun_skin_ult.cha"
    })
    hero.fashion_InfoChange = true
  end
end

function TitanNun.hero_die(basefunc, hero, killer)
  if hero.TitanNunMirror then
    for n = 1, 3 do
      if hero.TitanNunMirror[n] and hero.TitanNunMirror[n]:isAlive() then
        hero.TitanNunMirror[n]:die()
      end
    end
  end
  basefunc(hero, killer)
end

function TitanNun.actionskill_finish(basefunc, skill)
  basefunc(skill)
  local bid = 211
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = skill.caster:addBuff(binfo, skill.caster)
  skill.caster:die()
end

function TitanNun.actionskill_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillult = caster.config.summoner.skills.TitanNun_ult
  local skillult1 = caster.config.summoner.skills.TitanNun_ult1
  local skillult2 = caster.config.summoner.skills.TitanNun_ult2
  local skillult3 = caster.config.summoner.skills.TitanNun_ult3
  if skillult1 and skillult.attack_counter == 1 then
    skillult1:takeEffectOn(target, caster)
  elseif skillult2 and skillult.attack_counter == 2 then
    skillult2:takeEffectOn(target, caster)
    if target and target:isAlive() then
      local skillatk4a = caster.config.summoner.skills.TitanNun_atk4a
      skillatk4a.atk4a_ratio = TitanNun.skillatk4a_ratio_ult
      skillatk4a:takeEffectOn(target, caster)
    end
  elseif skillult3 and skillult.attack_counter == 3 then
    skillult3:takeEffectAt(target.position, caster)
    if target and target:isAlive() then
      local skillatk4b = caster.config.summoner.skills.TitanNun_atk4b
      skillatk4b.atk4b_ratio = TitanNun.skillatk4b_ratio_ult
      skillatk4b.target = target
      skillatk4b:takeEffectOn(target, caster)
    end
  end
end

function TitanNun.skillult_playAction(baseskill, actionNum)
  local caster = baseskill.caster
  local skillevel = {
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level
  }
  local proto = {
    _tid = 300,
    _level = baseskill.level or 1,
    _stars = caster.stars,
    _skill_levels = skillevel,
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
  local TitanNunMirror = ed.UnitCreate(proto, caster.camp, config)
  caster.TitanNunMirror = {}
  caster.TitanNunMirror[actionNum] = TitanNunMirror
  local bid = TitanNun.skillult_mirrorBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = TitanNunMirror:addBuff(binfo, caster)
  local actionskill = TitanNunMirror.skills["TitanNunMir_ult" .. actionNum]
  actionskill.target = baseskill.target
  local position = {
    actionskill.target.position[1] + TitanNun.ult_position[actionNum][1],
    actionskill.target.position[2] + TitanNun.ult_position[actionNum][2]
  }
  actionskill.finish = override(actionskill.finish, TitanNun.actionskill_finish)
  actionskill.takeEffectOn = override(actionskill.takeEffectOn, TitanNun.actionskill_takeEffectOn)
  ed.engine:summonUnit(TitanNunMirror, position, caster, "Death")
  TitanNunMirror:castSkill(actionskill, actionskill.target)
end

function TitanNun.findNextTarget(skill)
  local caster = skill.caster
  local min = math.huge
  local ret
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned then
    elseif unit == caster then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit:isOutOfStage() then
    else
      local times = skill.affect_times[unit] or 0
      if min < times then
      else
        ret = unit
        min = times
      end
    end
  end
  return ret
end

function TitanNun.skillult_start(basefunc, skill, target)
  skill.affect_times = {}
  local caster = skill.caster
  local bid = TitanNun.skillult_startBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  target = TitanNun.findNextTarget(skill)
  basefunc(skill, target)
end

function TitanNun.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target
  if attack_counter == 0 then
    target = TitanNun.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      TitanNun.skillult_playAction(skill, 1)
    else
      skill:finish()
    end
    basefunc(skill)
  elseif attack_counter == 1 then
    target = TitanNun.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      TitanNun.skillult_playAction(skill, 2)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    target = TitanNun.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      TitanNun.skillult_playAction(skill, 3)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    skill.attack_counter = skill.attack_counter + 1
  elseif 4 <= attack_counter then
    local skillult4 = caster.skills.TitanNun_ult4
    local projectile = skillult4:createProjectile()
    projectile.position, projectile.height = skill:launchPoint()
    local v = 900
    local caster = skill.caster
    local target = skillult4:selectTarget(nil)
    if not target then
      return
    end
    projectile:enableTrack(target)
    local targetpos = {
      target.position[1] - 0 * caster.direction,
      target.position[2]
    }
    local targetxyV = ed.edpSub(targetpos, projectile.position)
    local targetzV = -projectile.height
    local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
    local targetV = {
      u * targetxyV[1],
      u * targetxyV[2],
      u * targetzV
    }
    projectile.velocity[1] = targetV[1] * v
    projectile.velocity[2] = targetV[2] * v
    projectile.zSpeed = targetV[3] * v
    ed.engine:addProjectile(projectile)
  end
end

function TitanNun.skillult4_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  if target and target:isAlive() then
    local skillatk4a = skill.caster.skills.TitanNun_atk4a
    skillatk4a.atk4a_ratio = TitanNun.skillatk4a_ratio_ult
    skillatk4a:takeEffectOn(target, skill.caster)
  end
end

function TitanNun.walkTo(basefunc, ai, dest)
  local owner = ai.owner
  local old_range = owner.attack_range
  if dest.what == "Unit" and (dest.info["Position Type"] ~= T("\229\137\141\230\142\146") or dest.attack_range and dest.attack_range > 173) then
    owner.attack_range = TitanNun.skillatk_attack_range
  end
  basefunc(ai, dest)
  owner.attack_range = old_range
end

function TitanNun.skillatk_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk4a = skill.caster.skills.TitanNun_atk4a
  if target and target:isAlive() and skillatk4a then
    skillatk4a.atk4a_ratio = TitanNun.skillatk4a_ratio_atk
    skillatk4a:takeEffectOn(target, skill.caster)
  end
end

function TitanNun.skillatks_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk4b = skill.caster.skills.TitanNun_atk4b
  if target and target:isAlive() and skillatk4b then
    skillatk4b.atk4b_ratio = TitanNun.skillatk4b_ratio_atk
    skillatk4b.target = target
    skillatk4b:takeEffectOn(target, skill.caster)
  end
end

function TitanNun.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    basefunc(skill)
    if target and target:isAlive() then
      target:hurt()
      local bid = TitanNun.skillatk2_buff1ID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("ARM", target.attribs.ARM * -0.5)
      target:addBuff(buff, caster)
      local skillatk4b = skill.caster.skills.TitanNun_atk4b
      if skillatk4b then
        skillatk4b.atk4b_ratio = TitanNun.skillatk4b_ratio_atk2
        skillatk4b.target = target
        skillatk4b:takeEffectOn(target, caster)
      end
    end
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    basefunc(skill)
    if target and target:isAlive() then
      local bid = TitanNun.skillatk2_buff2ID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      if TitanNun.TitanNun_fashionID and TitanNun.TitanNun_fashionID == caster.fashion_id then
        local originfo = binfo
        binfo = ed.wraptable(originfo, {
          Effect = "eff_buff_TitanNun_skin_atk2.cha"
        })
      end
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
      local skillatk4a = skill.caster.skills.TitanNun_atk4a
      skillatk4a.atk4a_ratio = TitanNun.skillatk4a_ratio_atk2
      skillatk4a:takeEffectOn(target, caster)
    end
  end
end

function TitanNun.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:setPosition({
    caster.position[1] - caster.direction * TitanNun.atk2_distance,
    caster.position[2]
  })
end

function TitanNun.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.TitanNun_atk3s
  skillatk3s:takeEffectAt(caster.position, caster)
  local bid = TitanNun.skillatk3s_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  if TitanNun.TitanNun_fashionID and TitanNun.TitanNun_fashionID == caster.fashion_id then
    local originfo = binfo
    binfo = ed.wraptable(originfo, {
      Effect = "eff_buff_TitanNun_skin_atk3.cha"
    })
  end
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster.atk3BuffTimer = buff.timer
  caster:addBuff(buff, caster)
  if TitanNun.TitanNun_fashionID and TitanNun.TitanNun_fashionID == caster.fashion_id then
    local fashion_id = 4525
    local binfo = ed.lookupDataTable("Buff", nil, fashion_id)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.timer = caster.atk3BuffTimer
    caster:addBuff(buff, caster)
  end
end

function TitanNun.skillatk3s_takeEffectOn(basefunc, skill, target)
  local newtarget
  if target and target.config.summoner and not target.buff_effects.invulnerable then
    newtarget = target.config.summoner
  else
    newtarget = target
  end
  basefunc(skill, newtarget)
end

function TitanNun.skillatk4a_power(basefunc, skill)
  local power = skill.atk4a_ratio
  local caster = skill.caster
  if caster.TitanNun_hasArcana > 3 and ed.rand() > TitanNun.skillArcana3_ratio then
    power = power * 2
  end
  return power
end

function TitanNun.skillatk4b_power(basefunc, skill)
  local power = 0
  local ratio = skill.atk4b_ratio
  local target = skill.target
  if target then
    power = (target.attribs.HP - target.hp) * ratio
  end
  if power >= TitanNun.maxHp then
    power = TitanNun.maxHp
  end
  return power
end

function TitanNun.skillatk4a_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.atk4a_ratio then
    caster:takeHeal(skill.atk4a_ratio * 0.25, "mp", caster)
  end
end

function TitanNun.onHitMiss(basefunc, hero, skill)
  if skill.info["Damage Type"] == "AP" then
    local bid = TitanNun.skillArcana2_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function TitanNun.init_hero(hero)
  local skillult = hero.skills.TitanNun_ult
  local skillult4 = hero.skills.TitanNun_ult4
  local skillatk = hero.skills.TitanNun_atk
  local skillatks = hero.skills.TitanNun_atks
  local skillatk2 = hero.skills.TitanNun_atk2
  local skillatk3 = hero.skills.TitanNun_atk3
  local skillatk3s = hero.skills.TitanNun_atk3s
  local skillatk4 = hero.skills.TitanNun_atk4
  local skillatk4a = hero.skills.TitanNun_atk4a
  local skillatk4b = hero.skills.TitanNun_atk4b
  hero.TitanNun_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.start = override(skillult.start, TitanNun.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanNun.skillult_onAttackFrame)
    skillult4.takeEffectOn = override(skillult4.takeEffectOn, TitanNun.skillult4_takeEffectOn)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanNun.skillatk_takeEffectOn)
  end
  if skillatks then
    skillatks.takeEffectOn = override(skillatks.takeEffectOn, TitanNun.skillatks_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanNun.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, TitanNun.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanNun.skillatk3_onAttackFrame)
  end
  if skillatk3s then
    skillatk3s.takeEffectOn = override(skillatk3s.takeEffectOn, TitanNun.skillatk3s_takeEffectOn)
  end
  if skillatk4 and hero.name == "TitanNun" then
    TitanNun.skillatk_attack_range = skillatks.info["Max Range"]
    hero.ai.walkTo = override(hero.ai.walkTo, TitanNun.walkTo)
  end
  if skillatk4a and skillatk4b then
    skillatk4a.power = override(skillatk4a.power, TitanNun.skillatk4a_power)
    skillatk4b.power = override(skillatk4b.power, TitanNun.skillatk4b_power)
    if hero.TitanNun_hasArcana > 1 then
      skillatk4a.takeEffectOn = override(skillatk4a.takeEffectOn, TitanNun.skillatk4a_takeEffectOn)
    end
  end
  if hero.TitanNun_hasArcana > 2 then
    hero.onHitMiss = override(hero.onHitMiss, TitanNun.onHitMiss)
  end
  hero.reset = override(hero.reset, TitanNun.hero_reset)
  hero.die = override(hero.die, TitanNun.hero_die)
  hero.update = override(hero.update, TitanNun.hero_update)
  return hero
end

return TitanNun.init_hero
