module("ed.battlehero", package.seeall)
local ed = ed
WorldCK = {}
WorldCK.CK_ult_boomBuffID = 1056
WorldCK.CK_ult_selfBuffID = 1067
WorldCK.CK_ult_boomTime = 1.5
WorldCK.CK_atk4_multRate = 5
WorldCK.CK_akt4_stunMultRate = 10
WorldCK.CK_awake_orbsRate = 0.4
WorldCK.CK_awake_buffID = 1055
WorldCK.CK_atk3_armRate = 0.8
WorldCK.CK_atk3_csdBuffID = 1052
WorldCK.CK_atk3_csdBase = 100
WorldCK.CK_atk3_csdRange = 100
WorldCK.CK_atk2_babyTime = 18
WorldCK.CK_atk2_shaderBuffID = 1632
WorldCK.CK_atk2_bufferBuffID = 1057
WorldCK.CK_borderRangeX = 30
WorldCK.CK_borderRangeY = 5
WorldCK.WorldCK_babydie = 1633
WorldCK.WorldCK_atk2_start = 1634
WorldCK.ragelosthp = 600000
WorldCK.stage2hp = 30000000
WorldCK.rage2losthp = 200000
WorldCK.stage2ragelosthp = 400000
WorldCK.CK_atk2_babyPosDelta = {
  [1] = {
    -60,
    10,
    1
  },
  [2] = {
    45,
    -15,
    -1
  },
  [3] = {
    45,
    15,
    -1
  }
}
WorldCK.CK_atk2_babyPosDeltaSelf = {
  [1] = {
    -40,
    10,
    1
  },
  [2] = {
    40,
    -15,
    1
  },
  [3] = {
    40,
    15,
    1
  }
}

function WorldCK.willCritProb(caster, target, skill)
  local defence, dc, crit, crit_mod
  defence = math.max(0, target.attribs.ARM - caster.attribs.ARMP)
  crit = caster.attribs.CRIT
  dc = defence * 8
  crit_mod = skill.info["CRIT%"] / 100
  local crit_prob = crit / (100 + dc) * crit_mod
  return crit_prob
end

function WorldCK.doCritSkill_startPhase(basefunc, skill, idx)
  skill.CK_doCrit = false
  local target = skill.target
  local caster = skill.caster
  local rate = ed.rand()
  local bCrit = rate < WorldCK.willCritProb(caster, target, skill)
  if bCrit then
    skill.CK_doCrit = true
    basefunc(skill, 2)
  else
    basefunc(skill, 1)
  end
end

function WorldCK.doCritSkill_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function WorldCK.doCritSkill_takeEffectOn(basefunc, skill, target, source, shift)
  local originInfo = skill.info
  local isHit = false
  local dmg = 0
  if skill.CK_doCrit and target == skill.target then
    skill.info = ed.wraptable(originInfo, {
      ["Do Crit"] = "YES"
    })
    isHit, dmg = basefunc(skill, target, source, shift)
  else
    skill.info = ed.wraptable(originInfo, {
      ["Do Crit"] = "NO"
    })
    isHit, dmg = basefunc(skill, target, source, shift)
  end
  skill.info = originInfo
  skill.CK_doCrit = nil
  return isHit, dmg
end

function WorldCK.doCritSkill_finish(basefunc, skill)
  basefunc(skill)
  skill.CK_doCrit = nil
end

function WorldCK.boomBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.timer >= 0 then
    if not buff.ticktock then
      buff.ticktock = WorldCK.CK_ult_boomTime
    end
    buff.ticktock = buff.ticktock - dt
    if 0 >= buff.ticktock then
      buff.timer = -1
      local caster = buff.caster
      local skillultb = caster.skills.CK_ultb
      if skillultb then
        local originInfo = skillultb.info
        skillultb.info = ed.wraptable(originInfo, {
          ["No Dodge"] = true
        })
        skillultb:takeEffectOn(buff.owner, caster)
        skillultb.info = originInfo
      end
    end
  end
end

function WorldCK.skillult_takeEffectAt(basefunc, skill, location, source)
  local info = skill.info
  local caster = skill.caster
  local direction = caster.direction
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  skill.curSkillCount = 0
  skill.isEffectAt = true
  skill.CK_enermyList = {}
  local manCount = 0
  local randAdd = 0
  local maxMan
  local maxNum = -1
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    elseif unit.buff_effects.invulnerable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
    else
      local randNum = math.max(ed.rand(), 0.2)
      if maxNum <= randNum then
        maxNum = randNum
        maxMan = unit
      end
      randAdd = randAdd + randNum
      manCount = manCount + 1
      table.insert(skill.CK_enermyList, {unit, randNum})
    end
    if 6 <= manCount then
      break
    end
  end
  local theLastOfUs
  local theLastNum = -1
  if 1 <= manCount then
    for _, union in ipairs(skill.CK_enermyList) do
      local originInfo = skill.info
      local plusNum = originInfo["Plus Ratio"]
      if union[1] == maxMan then
        skill.info = ed.wraptable(originInfo, {
          ["Plus Ratio"] = plusNum * (manCount * union[2] / randAdd),
          ["No Dodge"] = true
        })
      else
        skill.info = ed.wraptable(originInfo, {
          ["Plus Ratio"] = plusNum * (manCount * union[2] / randAdd),
          ["No Dodge"] = true
        })
      end
      skill:takeEffectOn(union[1], caster)
      skill.info = originInfo
      if union[1]:isAlive() then
        local newRand = ed.rand()
        if theLastNum <= newRand then
          theLastNum = newRand
          theLastOfUs = union[1]
        end
      end
    end
  end
  if theLastOfUs then
    local binfo = ed.lookupDataTable("Buff", nil, WorldCK.CK_ult_boomBuffID)
    local boomBuff = ed.BuffCreate(binfo, theLastOfUs, caster)
    boomBuff.update = override(boomBuff.update, WorldCK.boomBuff_update)
    theLastOfUs:addBuff(boomBuff, caster)
  end
  if ed.run_with_scene then
    local effect_name = info["Point Effect"]
    if not effect_name then
      skill.isEffectAt = false
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, origin, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
  skill.isEffectAt = false
end

function WorldCK.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, WorldCK.CK_ult_selfBuffID)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(selfBuff, caster)
  skill.selfInvalueBuff = selfBuff
  if ed.run_with_scene then
    caster:setAllBuffVisible(false)
    caster:setHpVisible(false)
    caster:setShieldVisible(false)
  end
end

function WorldCK.skillult_finish(basefunc, skill)
  basefunc(skill)
  if skill.CK_enermyList then
    skill.CK_enermyList = nil
  end
  if skill.selfInvalueBuff then
    skill.caster:removeBuff(skill.selfInvalueBuff)
    skill.selfInvalueBuff = nil
  end
  if ed.run_with_scene then
    skill.caster:setAllBuffVisible(true)
    skill.caster:setHpVisible(true)
    skill.caster:setShieldVisible(true)
  end
end

function WorldCK.skillatk3_chaosHit(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local upperCaster = caster
  if caster.CK_myBoss then
    upperCaster = caster.CK_myBoss
  end
  local skillatk3 = upperCaster.skills.CK_atk3
  local csdBuffInfo = ed.lookupDataTable("Buff", nil, WorldCK.CK_atk3_csdBuffID)
  local csdBuff = ed.BuffCreate(csdBuffInfo, caster, caster)
  local randomCsd = WorldCK.CK_atk3_csdBase + WorldCK.CK_atk3_csdRange * ed.rand()
  csdBuff:setAttribute("CSD", randomCsd)
  caster:addBuff(csdBuff, caster)
  local isHit, dmg = basefunc(skill, target, source, shift)
  for _, buff in pairs(caster.buff_list) do
    if buff == csdBuff then
      caster:removeBuff(csdBuff)
      break
    end
  end
  local randRate = ed.rand()
  if isHit and skillatk3 and randRate < WorldCK.CK_atk3_armRate then
    local armBuffInfo = skillatk3.info.buff_info
    local armBuff = ed.BuffCreate(armBuffInfo, skill.target, caster)
    skill.target:addBuff(armBuff, caster)
  end
  return isHit, dmg
end

function WorldCK.atk4Projectile_hit(basefunc, projectile, target)
  if target ~= projectile.skill.target then
    return
  else
    local skill = projectile.skill
    local originInfo = skill.info
    if projectile.CK_doCrit then
      skill.info = ed.wraptable(originInfo, {
        ["Do Crit"] = "YES"
      })
      basefunc(projectile, target)
    else
      skill.info = ed.wraptable(originInfo, {
        ["Do Crit"] = "NO"
      })
      basefunc(projectile, target)
    end
    skill.info = originInfo
    if not projectile.terminated then
      projectile:terminate()
    end
  end
end

function WorldCK.skillatk4_createProjectile(basefunc, skill)
  local target = skill.target
  local caster = skill.caster
  local rate = ed.rand()
  local bCrit = rate < WorldCK.willCritProb(caster, target, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, WorldCK.atk4Projectile_hit)
  if bCrit then
    local origin_info = skill.info
    skill.info = ed.wraptable(origin_info, {
      ["Tile Art"] = "eff_tile_CK_atk3b.cha"
    })
    ed.engine:addProjectile(projectile)
    skill.info = origin_info
    projectile.CK_doCrit = true
  else
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function WorldCK.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local origin_info = skill.info
  local dmgRate = 1 + ed.rand() * WorldCK.CK_atk4_multRate
  local dmgPlusRatio = skill.info["Plus Ratio"]
  skill.info = ed.wraptable(origin_info, {
    ["Plus Ratio"] = dmgPlusRatio * dmgRate,
    ["No Dodge"] = true
  })
  local isHit, dmg = basefunc(skill, target, source, shift)
  skill.info = origin_info
  return isHit, dmg
end

function WorldCK.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = buff.timer * (1 + ed.rand() * WorldCK.CK_akt4_stunMultRate)
  return buff
end

function WorldCK.mrProjectile_update(basefunc, projectile, dt)
  if projectile.boss:isAlive() and not projectile.boss.buff_effects.untargetable then
    projectile.durTime = projectile.durTime + dt
    local originSpeed = projectile.skill.info["Tile XY Speed"]
    local speed = 1
    if projectile.durTime <= 0.6 then
      speed = projectile.creater.direction
    else
      speed = math.max(originSpeed, 300 * projectile.durTime)
    end
    local d = ed.edpNormalize(ed.edpSub(projectile.boss.position, projectile.position))
    projectile.velocity = ed.edpMult(d, speed)
  else
    projectile:terminate()
  end
  basefunc(projectile, dt)
end

function WorldCK.mrProjectile_hit(basefunc, projectile, target)
  if target and target:isAlive() then
    local doHaveBuff = false
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == WorldCK.CK_awake_buffID then
        doHaveBuff = true
        buff.timer = buff.info.Time
        local shield_mod = projectile.boss.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or projectile.boss.config.hp_mod
        buff.shield = buff.shield + buff.info["Shield Value"] * shield_mod
        buff.shield = math.min(buff.shield, buff.info["Shield Value"] * shield_mod * 4)
        break
      end
    end
    if not doHaveBuff then
      local skillawake = projectile.boss.skills.CK_awake
      if skillawake then
        local binfo = skillawake.info.buff_info
        local shieldBuff = ed.BuffCreate(binfo, target, projectile.caster)
        target:addBuff(shieldBuff, projectile.caster)
      end
    end
  end
end

function WorldCK.skillawake_randomOrbs(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  if isHit and ed.rand() < CK.CK_awake_orbsRate then
    local caster = skill.caster
    local upperCaster = caster
    if caster.CK_myBoss then
      upperCaster = caster.CK_myBoss
    end
    local skillawake = upperCaster.skills.CK_awake
    local hitTarget = skill.target
    skillawake.target = upperCaster
    local mrProjectile = skillawake:createProjectile()
    mrProjectile.boss = upperCaster
    mrProjectile.track_target = upperCaster
    mrProjectile.creater = caster
    mrProjectile.durTime = 0
    mrProjectile.position = {
      hitTarget.position[1] + 5 * ed.rand(),
      hitTarget.position[2] - 5 * ed.rand()
    }
    mrProjectile.update = override(mrProjectile.update, CK.mrProjectile_update)
    mrProjectile.hit = override(mrProjectile.hit, CK.mrProjectile_hit)
    ed.engine:addProjectile(mrProjectile)
  end
  return isHit, dmg
end

function WorldCK.borderProtection(unit)
  local originPos = {
    unit.position[1],
    unit.position[2]
  }
  if originPos[1] <= ed.engine.stage_rect.minX then
    originPos[1] = ed.engine.stage_rect.minX + WorldCK.CK_borderRangeX
  end
  if originPos[1] >= ed.engine.stage_rect.maxX then
    originPos[1] = ed.engine.stage_rect.maxX - WorldCK.CK_borderRangeX
  end
  if originPos[2] <= ed.engine.stage_rect.minY then
    originPos[2] = ed.engine.stage_rect.minY + WorldCK.CK_borderRangeY
  end
  if originPos[2] >= ed.engine.stage_rect.maxY then
    originPos[2] = ed.engine.stage_rect.maxY - WorldCK.CK_borderRangeY
  end
  unit.position[1] = originPos[1]
  unit.position[2] = originPos[2]
end

function WorldCK.ckBaby_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit:isAlive() then
    unit.ckBaby_age = unit.ckBaby_age + dt
    if unit.ckBaby_age >= WorldCK.CK_atk2_babyTime then
      unit:die()
    end
  end
end

function WorldCK.babydie_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if buff.rank >= 3 then
    owner:die()
  end
end

function WorldCK.ckBaby_die(basefunc, unit, killer)
  basefunc(unit, killer)
  if killer and killer:isAlive() then
    local bid = WorldCK.WorldCK_babydie
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, killer, unit)
    buff.update = override(buff.update, WorldCK.babydie_update)
    killer:addBuff(buff, unit)
  end
end

function WorldCK.baby_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type)
  if damage_type then
    return 1
  else
    return basefunc(hero, damage, immunity, damage_type)
  end
end

function WorldCK.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  caster.if_sawake_addbuff = false
  local bid = WorldCK.WorldCK_atk2_start
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function WorldCK.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == WorldCK.WorldCK_atk2_start then
      tbuff.timer = 0
    end
  end
end

function WorldCK.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local awake = skill.originUnit_Rubick and ed.protoAwake(skill.originUnit_Rubick.proto) or ed.protoAwake(caster.proto, 69)
  local proto = {
    _tid = 289,
    _level = skill.level or 1,
    _skill_levels = {
      [1] = skill.level
    },
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = caster.config.dps_mod or 1
  }
  for i = 1, 3 do
    local ckBaby = ed.UnitCreate(proto, caster.camp, config)
    local bid = WorldCK.CK_atk2_shaderBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    ckBaby:addBuff(binfo, caster)
    local bufferBid = WorldCK.CK_atk2_bufferBuffID
    local bufferBinfo = ed.lookupDataTable("Buff", nil, bufferBid)
    local bufferBuff = ed.BuffCreate(bufferBinfo, ckBaby, caster)
    bufferBuff:setAttribute("AD", caster.attribs.AD * 0.5)
    bufferBuff:setAttribute("CRIT", caster.attribs.CRIT * 0.5)
    bufferBuff:setAttribute("HIT", caster.attribs.HIT * 0.8)
    bufferBuff:setAttribute("ARMP", caster.attribs.ARMP * 0.5)
    bufferBuff:setAttribute("ARM", caster.attribs.ARM * 0.5)
    bufferBuff:setAttribute("MR", caster.attribs.MR * 0.5)
    ckBaby:addBuff(bufferBuff, caster)
    ckBaby:setHP(3)
    ckBaby.ckBaby_age = 0
    ckBaby.CK_myBoss = caster
    ckBaby.update = override(ckBaby.update, WorldCK.ckBaby_update)
    ckBaby.die = override(ckBaby.die, WorldCK.ckBaby_die)
    ckBaby.getLostHPAfterImmunity = override(ckBaby.getLostHPAfterImmunity, WorldCK.baby_getLostHPAfterImmunity)
    ckBaby:setDeathWithEffectOrNot(true)
    local skillatk_baby = ckBaby.skills.WorldCKBaby_atk
    skillatk_baby.cd_remaining = skillatk_baby.cd_remaining + 0.8 * ed.rand()
    local skillatk3 = caster.skills.WorldCK_atk3
    local skillawake = caster.skills.WorldCK_awake
    local skillatk = caster.skills.WorldCK_atk
    if skillatk then
      skillatk_baby.startPhase = override(skillatk_baby.startPhase, WorldCK.doCritSkill_startPhase)
      skillatk_baby.onPhaseFinished = override(skillatk_baby.onPhaseFinished, WorldCK.doCritSkill_onPhaseFinished)
      skillatk_baby.takeEffectOn = override(skillatk_baby.takeEffectOn, WorldCK.doCritSkill_takeEffectOn)
      skillatk_baby.finish = override(skillatk_baby.finish, WorldCK.doCritSkill_finish)
    end
    if skillatk3 then
      skillatk_baby.takeEffectOn = override(skillatk_baby.takeEffectOn, WorldCK.skillatk3_chaosHit)
    end
    if skillawake then
      skillatk_baby.takeEffectOn = override(skillatk_baby.takeEffectOn, WorldCK.skillawake_randomOrbs)
    end
    table.insert(caster.CK_babyList, ckBaby)
    if target then
      local posDelta = WorldCK.CK_atk2_babyPosDelta[i]
      local reDiection = target.position[1] >= caster.position[1] and 1 or -1
      ckBaby.position = {
        target.position[1] + posDelta[1] * reDiection,
        target.position[2] + posDelta[2]
      }
      ckBaby.direction = posDelta[3] * reDiection
    else
      local posDelta = WorldCK.CK_atk2_babyPosDeltaSelf[i]
      ckBaby.position = {
        caster.position[1] + posDelta[1] * caster.direction,
        caster.position[2] + posDelta[2]
      }
      ckBaby.direction = posDelta[3] * caster.direction
    end
    WorldCK.borderProtection(ckBaby)
    ed.engine:summonUnit(ckBaby, ckBaby.position, caster)
  end
end

function WorldCK.hero_die(basefunc, hero, killer)
  for _, unit in ipairs(hero.CK_babyList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function WorldCK.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.CK_babyList = {}
  hero.if_sawake_addbuff = false
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldCK.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldCK.rage_buff_update(basefunc, buff, dt)
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

function WorldCK.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.Boss_entercount then
    local bid = 1637
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
    hero.Boss_entercount = true
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldCK.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldCK.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldCK.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldCK.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldCK.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldCK.init_hero(hero)
  local skillult = hero.skills.WorldCK_ult
  local skillatk = hero.skills.WorldCK_atk
  local skillatk2 = hero.skills.WorldCK_atk2
  local skillatk3 = hero.skills.WorldCK_atk3
  local skillatk4 = hero.skills.WorldCK_atk4
  local skillawake = hero.skills.WorldCK_awake
  local nothing = ed.rand()
  if skillatk then
    skillatk.startPhase = override(skillatk.startPhase, WorldCK.doCritSkill_startPhase)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, WorldCK.doCritSkill_onPhaseFinished)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, WorldCK.doCritSkill_takeEffectOn)
    skillatk.finish = override(skillatk.finish, WorldCK.doCritSkill_finish)
  end
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, WorldCK.skillult_takeEffectAt)
    skillult.start = override(skillult.start, WorldCK.skillult_start)
    skillult.finish = override(skillult.finish, WorldCK.skillult_finish)
  end
  if skillatk3 then
    if skillatk then
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, WorldCK.skillatk3_chaosHit)
    end
    if skillult then
      skillult.takeEffectOn = override(skillult.takeEffectOn, WorldCK.skillatk3_chaosHit)
    end
    if skillatk4 then
      skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldCK.skillatk3_chaosHit)
    end
  end
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, WorldCK.skillatk4_createProjectile)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, WorldCK.skillatk4_takeEffectOn)
    skillatk4.createBuff = override(skillatk4.createBuff, WorldCK.skillatk4_createBuff)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, WorldCK.skillatk2_onAttackFrame)
    hero.CK_babyList = {}
    hero.die = override(hero.die, WorldCK.hero_die)
    skillatk2.start = override(skillatk2.start, WorldCK.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, WorldCK.skillatk2_finish)
  end
  hero.reset = override(hero.reset, WorldCK.hero_reset)
  hero.update = override(hero.update, WorldCK.hero_update)
  return hero
end

return WorldCK.init_hero
