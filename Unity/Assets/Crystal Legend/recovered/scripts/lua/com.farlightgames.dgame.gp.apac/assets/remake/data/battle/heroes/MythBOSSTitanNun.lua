module("ed.battlehero", package.seeall)
local ed = ed
MythBOSSTitanNun = {}
MythBOSSTitanNun.atk2_distance = 100
MythBOSSTitanNun.skillult_startBuffID = 1689
MythBOSSTitanNun.skillult_mirrorBuffID = 1690
MythBOSSTitanNun.skillatk_attack_range = 0
MythBOSSTitanNun.skillatk2_buff1ID = 1691
MythBOSSTitanNun.skillatk2_buff2ID = 1692
MythBOSSTitanNun.skillatk3s_buffID = 1693
MythBOSSTitanNun.ult_position = {
  {-25, 0},
  {0, 0},
  {-25, 0}
}
MythBOSSTitanNun.skillatk4a_ratio_atk = 25
MythBOSSTitanNun.skillatk4a_ratio_atk2 = 100
MythBOSSTitanNun.skillatk4a_ratio_ult = 50
MythBOSSTitanNun.skillatk4b_ratio_atk = 0.1
MythBOSSTitanNun.skillatk4b_ratio_atk2 = 0.15
MythBOSSTitanNun.skillatk4b_ratio_ult = 0.3
MythBOSSTitanNun.skillArcana2_buffID = 1696
MythBOSSTitanNun.skillArcana3_ratio = 0.5
MythBOSSTitanNun.skillatk4_buffID = 1695
MythBOSSTitanNun.maxHp = 30000
MythBOSSTitanNun.bossID = 5

function MythBOSSTitanNun.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.MythBOSSTitanNun_atk4
  if skillatk4 then
    local bid = MythBOSSTitanNun.skillatk4_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("MSPD", skillatk4.info["Script Arg2"])
    buff:setAttribute("HAST", skillatk4.info["Script Arg2"])
    hero:addBuff(buff, hero)
  end
  local info = ed.getDataTable("MythBossReward")
  hero.BossStageList = {}
  hero.BossTotalHp = hero.attribs.HP
  hero.Boss_nstage = 0
  hero.Boss_stageBuff = nil
  for _, group in ipairs(info) do
    repeat
      if not group[5] then
      else
        if group[5]["Boss RewardLine ID"] == MythBOSSTitanNun.bossID then
          table.insert(hero.BossStageList, group)
        else
        end
        break -- pseudo-goto
      end
    until true
  end
  hero:setPosition({600, 0})
  hero.direction = -1
end

function MythBOSSTitanNun.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local lostHp = hero.BossTotalHp - hero.hp
  local stagechange
  for i, Hpstage in ipairs(hero.BossStageList) do
    if lostHp >= Hpstage[5]["Damage Value"] and i > hero.Boss_nstage then
      hero.Boss_nstage = i
      stagechange = true
    end
  end
  if stagechange then
    if hero.Boss_stageBuff then
      hero.Boss_stageBuff.timer = -1
    end
    local binfo = ed.lookupDataTable("Buff", nil, hero.BossStageList[hero.Boss_nstage][5]["Buff ID"])
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero.Boss_stageBuff = hero:addBuff(buff, hero)
  end
end

function MythBOSSTitanNun.hero_die(basefunc, hero, killer)
  if hero.MythBOSSTitanNunMirror then
    for n = 1, 3 do
      if hero.MythBOSSTitanNunMirror[n] and hero.MythBOSSTitanNunMirror[n]:isAlive() then
        hero.MythBOSSTitanNunMirror[n]:die()
      end
    end
  end
  basefunc(hero, killer)
end

function MythBOSSTitanNun.actionskill_finish(basefunc, skill)
  basefunc(skill)
  local bid = 211
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = skill.caster:addBuff(binfo, skill.caster)
  skill.caster:die()
end

function MythBOSSTitanNun.actionskill_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillult = caster.config.summoner.skills.MythBOSSTitanNun_ult
  local skillult1 = caster.config.summoner.skills.MythBOSSTitanNun_ult1
  local skillult2 = caster.config.summoner.skills.MythBOSSTitanNun_ult2
  local skillult3 = caster.config.summoner.skills.MythBOSSTitanNun_ult3
  if skillult1 and skillult.attack_counter == 1 then
    skillult1:takeEffectOn(target)
  elseif skillult2 and skillult.attack_counter == 2 then
    skillult2:takeEffectOn(target)
    if target and target:isAlive() then
      local skillatk4a = caster.config.summoner.skills.MythBOSSTitanNun_atk4a
      skillatk4a.atk4a_ratio = MythBOSSTitanNun.skillatk4a_ratio_ult
      skillatk4a:takeEffectOn(target)
    end
  elseif skillult3 and skillult.attack_counter == 3 then
    skillult3:takeEffectAt(target.position)
    if target and target:isAlive() then
      local skillatk4b = caster.config.summoner.skills.MythBOSSTitanNun_atk4b
      skillatk4b.atk4b_ratio = MythBOSSTitanNun.skillatk4b_ratio_ult
      skillatk4b.target = target
      skillatk4b:takeEffectOn(target)
    end
  end
end

function MythBOSSTitanNun.skillult_playAction(baseskill, actionNum)
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
  local MythBOSSTitanNunMirror = ed.UnitCreate(proto, caster.camp, config)
  caster.MythBOSSTitanNunMirror = {}
  caster.MythBOSSTitanNunMirror[actionNum] = MythBOSSTitanNunMirror
  local bid = MythBOSSTitanNun.skillult_mirrorBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = MythBOSSTitanNunMirror:addBuff(binfo, caster)
  local actionskill = MythBOSSTitanNunMirror.skills["TitanNunMir_ult" .. actionNum]
  actionskill.target = baseskill.target
  local position = {
    actionskill.target.position[1] + MythBOSSTitanNun.ult_position[actionNum][1],
    actionskill.target.position[2] + MythBOSSTitanNun.ult_position[actionNum][2]
  }
  actionskill.finish = override(actionskill.finish, MythBOSSTitanNun.actionskill_finish)
  actionskill.takeEffectOn = override(actionskill.takeEffectOn, MythBOSSTitanNun.actionskill_takeEffectOn)
  ed.engine:summonUnit(MythBOSSTitanNunMirror, position, caster, "Death")
  MythBOSSTitanNunMirror:castSkill(actionskill, actionskill.target)
end

function MythBOSSTitanNun.findNextTarget(skill)
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

function MythBOSSTitanNun.skillult_start(basefunc, skill, target)
  skill.affect_times = {}
  local caster = skill.caster
  local bid = MythBOSSTitanNun.skillult_startBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  target = MythBOSSTitanNun.findNextTarget(skill)
  basefunc(skill, target)
end

function MythBOSSTitanNun.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target
  if attack_counter == 0 then
    target = MythBOSSTitanNun.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      MythBOSSTitanNun.skillult_playAction(skill, 1)
    else
      skill:finish()
    end
    basefunc(skill)
  elseif attack_counter == 1 then
    target = MythBOSSTitanNun.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      MythBOSSTitanNun.skillult_playAction(skill, 2)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    target = MythBOSSTitanNun.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      MythBOSSTitanNun.skillult_playAction(skill, 3)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    skill.attack_counter = skill.attack_counter + 1
  elseif 4 <= attack_counter then
    local skillult4 = caster.skills.MythBOSSTitanNun_ult4
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

function MythBOSSTitanNun.skillult4_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  if target and target:isAlive() then
    local skillatk4a = skill.caster.skills.MythBOSSTitanNun_atk4a
    skillatk4a.atk4a_ratio = MythBOSSTitanNun.skillatk4a_ratio_ult
    skillatk4a:takeEffectOn(target)
  end
end

function MythBOSSTitanNun.walkTo(basefunc, ai, dest)
  local owner = ai.owner
  local old_range = owner.attack_range
  if dest.what == "Unit" and (dest.info["Position Type"] ~= T("\229\137\141\230\142\146") or dest.attack_range and dest.attack_range > 173) then
    owner.attack_range = MythBOSSTitanNun.skillatk_attack_range
  end
  basefunc(ai, dest)
  owner.attack_range = old_range
end

function MythBOSSTitanNun.skillatk_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk4a = skill.caster.skills.MythBOSSTitanNun_atk4a
  if target and target:isAlive() and skillatk4a then
    skillatk4a.atk4a_ratio = MythBOSSTitanNun.skillatk4a_ratio_atk
    skillatk4a:takeEffectOn(target)
  end
end

function MythBOSSTitanNun.skillatks_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk4b = skill.caster.skills.MythBOSSTitanNun_atk4b
  if target and target:isAlive() and skillatk4b then
    skillatk4b.atk4b_ratio = MythBOSSTitanNun.skillatk4b_ratio_atk
    skillatk4b.target = target
    skillatk4b:takeEffectOn(target)
  end
end

function MythBOSSTitanNun.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    basefunc(skill)
    if target and target:isAlive() then
      target:hurt()
      local bid = MythBOSSTitanNun.skillatk2_buff1ID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("ARM", target.attribs.ARM * -0.5)
      target:addBuff(buff, caster)
      local skillatk4b = skill.caster.skills.MythBOSSTitanNun_atk4b
      if skillatk4b then
        skillatk4b.atk4b_ratio = MythBOSSTitanNun.skillatk4b_ratio_atk2
        skillatk4b.target = target
        skillatk4b:takeEffectOn(target)
      end
    end
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    basefunc(skill)
    if target and target:isAlive() then
      local bid = MythBOSSTitanNun.skillatk2_buff2ID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
      local skillatk4a = skill.caster.skills.MythBOSSTitanNun_atk4a
      skillatk4a.atk4a_ratio = MythBOSSTitanNun.skillatk4a_ratio_atk2
      skillatk4a:takeEffectOn(target)
    end
  end
end

function MythBOSSTitanNun.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:setPosition({
    caster.position[1] - caster.direction * MythBOSSTitanNun.atk2_distance,
    caster.position[2]
  })
end

function MythBOSSTitanNun.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.MythBOSSTitanNun_atk3s
  skillatk3s:takeEffectAt(caster.position)
  local bid = MythBOSSTitanNun.skillatk3s_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
end

function MythBOSSTitanNun.skillatk3s_takeEffectOn(basefunc, skill, target)
  local newtarget
  if target and target.config.summoner and not target.buff_effects.invulnerable then
    newtarget = target.config.summoner
  else
    newtarget = target
  end
  basefunc(skill, newtarget)
end

function MythBOSSTitanNun.skillatk4a_power(basefunc, skill)
  local power = skill.atk4a_ratio
  local caster = skill.caster
  if caster.MythBOSSTitanNun_hasArcana > 3 and ed.rand() > MythBOSSTitanNun.skillArcana3_ratio then
    power = power * 2
  end
  return power
end

function MythBOSSTitanNun.skillatk4b_power(basefunc, skill)
  local power = 0
  local ratio = skill.atk4b_ratio
  local target = skill.target
  if target then
    power = (target.attribs.HP - target.hp) * ratio
  end
  if power >= MythBOSSTitanNun.maxHp then
    power = MythBOSSTitanNun.maxHp
  end
  return power
end

function MythBOSSTitanNun.skillatk4a_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.atk4a_ratio then
    caster:takeHeal(skill.atk4a_ratio * 0.25, "mp", caster)
  end
end

function MythBOSSTitanNun.onHitMiss(basefunc, hero, skill)
  if skill.info["Damage Type"] == "AP" then
    local bid = MythBOSSTitanNun.skillArcana2_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function MythBOSSTitanNun.init_hero(hero)
  local skillult = hero.skills.MythBOSSTitanNun_ult
  local skillult4 = hero.skills.MythBOSSTitanNun_ult4
  local skillatk = hero.skills.MythBOSSTitanNun_atk
  local skillatks = hero.skills.MythBOSSTitanNun_atks
  local skillatk2 = hero.skills.MythBOSSTitanNun_atk2
  local skillatk3 = hero.skills.MythBOSSTitanNun_atk3
  local skillatk3s = hero.skills.MythBOSSTitanNun_atk3s
  local skillatk4 = hero.skills.MythBOSSTitanNun_atk4
  local skillatk4a = hero.skills.MythBOSSTitanNun_atk4a
  local skillatk4b = hero.skills.MythBOSSTitanNun_atk4b
  hero.MythBOSSTitanNun_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.start = override(skillult.start, MythBOSSTitanNun.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, MythBOSSTitanNun.skillult_onAttackFrame)
    skillult4.takeEffectOn = override(skillult4.takeEffectOn, MythBOSSTitanNun.skillult4_takeEffectOn)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, MythBOSSTitanNun.skillatk_takeEffectOn)
  end
  if skillatks then
    skillatks.takeEffectOn = override(skillatks.takeEffectOn, MythBOSSTitanNun.skillatks_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, MythBOSSTitanNun.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, MythBOSSTitanNun.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, MythBOSSTitanNun.skillatk3_onAttackFrame)
  end
  if skillatk3s then
    skillatk3s.takeEffectOn = override(skillatk3s.takeEffectOn, MythBOSSTitanNun.skillatk3s_takeEffectOn)
  end
  if skillatk4 and hero.name == "MythBOSSTitanNun" then
    MythBOSSTitanNun.skillatk_attack_range = skillatks.info["Max Range"]
    hero.ai.walkTo = override(hero.ai.walkTo, MythBOSSTitanNun.walkTo)
  end
  if skillatk4a and skillatk4b then
    skillatk4a.power = override(skillatk4a.power, MythBOSSTitanNun.skillatk4a_power)
    skillatk4b.power = override(skillatk4b.power, MythBOSSTitanNun.skillatk4b_power)
    if hero.MythBOSSTitanNun_hasArcana > 1 then
      skillatk4a.takeEffectOn = override(skillatk4a.takeEffectOn, MythBOSSTitanNun.skillatk4a_takeEffectOn)
    end
  end
  if hero.MythBOSSTitanNun_hasArcana > 2 then
    hero.onHitMiss = override(hero.onHitMiss, MythBOSSTitanNun.onHitMiss)
  end
  hero.reset = override(hero.reset, MythBOSSTitanNun.hero_reset)
  hero.die = override(hero.die, MythBOSSTitanNun.hero_die)
  hero.update = override(hero.update, MythBOSSTitanNun.hero_update)
  return hero
end

return MythBOSSTitanNun.init_hero
