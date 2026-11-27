module("ed.battlehero", package.seeall)
local ed = ed
VIS = {}
VIS.VIS_scaleHit = 4
VIS.VIS_scaleLimit = 4
VIS.VIS_scaleRecover = 14
VIS.VIS_scaleBuffID = 620
VIS.VIS_awakeBuffID = 621
VIS.VIS_awakeRatio = 0.25
VIS.VIS_atk3HPRatio = 0.25
VIS.VIS_atk3HPRatioMate = 0.35
VIS.VIS_atk3BuffID = 622
VIS.VIS_atk3BuffLimit = 3
VIS.VIS_ultBuffIDSelf = 624
VIS.VIS_ultMateBuffID = 623
VIS.VIS_ultDefPercent = 0.95
VIS.VIS_atk3hastBuffID = 628
VIS.VIS_atk3stunBuffID = 629
VIS.VIS_ultRevengeTimer = 0.1
VIS.VIS_sawakeStealBuff = 1526
VIS.VIS_sawakeStrengthenBuff = 1527
VIS.VIS_akt3headEffectList = {
  "eff_buff_VIS_atk3a.cha",
  "eff_buff_VIS_atk3b.cha",
  "eff_buff_VIS_atk3c.cha",
  "eff_buff_VIS_atk3d.cha"
}
VIS.VIS_atk4bodyEffectList = {
  "eff_impact_VIS_atk4a.cha",
  "eff_impact_VIS_atk4b.cha",
  "eff_impact_VIS_atk4c.cha",
  "eff_impact_VIS_atk4d.cha"
}
VIS.VIS_babyLifeTime = 14
VIS.VIS_babyUntargetBuffID = 630
VIS.VIS_babyHastBuffID = 634
VIS.VIS_babyKnockDelay = 1.3
VIS.VIS_babyKnockDragonTime = 4

function VIS.twoPointDistanceSQ(p0, p1)
  local x = p0[1] - p1[1]
  local y = p0[2] - p1[2]
  local distanceSQ = x * x + y * y
  return distanceSQ
end

function VIS.visBaby_ai_searchTarget(basefunc, ai)
  local target, minDistanSQ = basefunc(ai)
  local owner = ai.owner
  local aiTarget = owner.visBaby_aiTarget
  if aiTarget and aiTarget:isAlive() and not aiTarget.buff_effects.untargetable and not aiTarget.buffManager.invisible and aiTarget.position[1] >= ed.engine.stage_rect.minX and aiTarget.position[2] <= ed.engine.stage_rect.maxX then
    target = owner.visBaby_aiTarget
    minDistanSQ = VIS.twoPointDistanceSQ(owner.position, target.position)
  end
  return target, minDistanSQ
end

function VIS.visBaby_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local stunBuff = basefunc(skill, target)
  local tags = ed.getHeroTags(target.proto)
  if ed.isElementInTable("Dragon", tags) then
    stunBuff.timer = VIS.VIS_babyKnockDragonTime
  end
  return stunBuff
end

function VIS.overwatchProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  projectile.passTime = projectile.passTime + dt
  if projectile.passTime >= VIS.VIS_babyKnockDelay and not projectile.terminated then
    projectile.skill:takeEffectAt(projectile.knockPosition)
    projectile:terminate()
  end
end

function VIS.visBaby_die(basefunc, unit, killer)
  basefunc(unit, killer)
  if not ed.engine.beingEnd then
    local visBaby_skillatk2 = unit.skills.VISBaby_atk2
    local overwatchProjectile = visBaby_skillatk2:createProjectile()
    overwatchProjectile.update = override(overwatchProjectile.update, VIS.overwatchProjectile_update)
    overwatchProjectile.passTime = 0
    overwatchProjectile.height = 999
    overwatchProjectile.knockPosition = unit.position
    ed.engine:addProjectile(overwatchProjectile)
  end
end

function VIS.visBaby_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit:isAlive() then
    if not unit.visBaby_age then
      unit.visBaby_age = 0
      unit.visBaby_dead = false
    end
    unit.visBaby_age = unit.visBaby_age + dt
    if unit.visBaby_age >= VIS.VIS_babyLifeTime then
      unit:die()
    end
  end
end

function VIS.ultbProjectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  local caster = projectile.caster
  projectile.passTime = projectile.passTime + dt
  if projectile.passTime >= VIS.VIS_ultRevengeTimer and not projectile.terminated then
    local revengeTarget
    local skillultb = caster.skills.VIS_ultb
    local enchanted = caster.buff_effects.enchanted
    local maxDamage = 0
    for unit in ed.engine:foreachAliveUnit(skillultb:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif maxDamage <= unit.battledata.damage then
        maxDamage = unit.battledata.damage
        revengeTarget = unit
      end
    end
    if revengeTarget then
      local originInfo = skillultb.info
      local basicNum = originInfo["Basic Num"]
      skillultb.info = ed.wraptable(originInfo, {
        ["Basic Num"] = basicNum + projectile.plusNum
      })
      skillultb:takeEffectOn(revengeTarget, caster)
      if ed.run_with_scene then
        local effect_name = "eff_impact_VIS_ult"
        ed.scene:playEffectOnScene(effect_name, revengeTarget.position, {1, 1}, nil, 1)
      end
      skillultb.info = originInfo
    end
    projectile:terminate()
  end
end

function VIS.castRevengeSkill(caster)
  local skillultb = caster.skills.VIS_ultb
  if skillultb then
    local plusNum = caster.VIS_mateDamageSum and caster.VIS_mateDamageSum or 0
    local ultbProjectile = skillultb:createProjectile()
    ultbProjectile.update = override(ultbProjectile.update, VIS.ultbProjectile_update)
    ultbProjectile.passTime = 0
    ultbProjectile.height = 999
    ultbProjectile.plusNum = plusNum
    ed.engine:addProjectile(ultbProjectile)
  end
end

function VIS.afterRevengeSkill(caster)
  if caster.VIS_isCastingUlt then
    for _, buff in ipairs(caster.buff_list) do
      if buff.info.ID == VIS.VIS_ultBuffIDSelf then
        caster:removeBuff(buff)
      end
    end
    caster.VIS_isCastingUlt = nil
    caster.VIS_mateDamageSum = 0
    if caster.VIS_mateBuffMateList then
      for _, mate in ipairs(caster.VIS_mateBuffMateList) do
        if mate:isAlive() then
          for _, buff in ipairs(mate.buff_list) do
            if buff.info.ID == VIS.VIS_ultMateBuffID then
              mate:removeBuff(buff)
            end
          end
        end
      end
      caster.VIS_mateBuffMateList = nil
    end
  end
end

function VIS.selfBuff_onDamaged(basefunc, buff, damage, damage_type, source)
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  if damage <= maxdmg then
    return damage
  else
    damage = maxdmg
    owner:removeBuff(buff)
    VIS.castRevengeSkill(owner)
    if owner.current_skill then
      owner.current_skill:interrupt()
    end
    return damage
  end
end

function VIS.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, VIS.VIS_ultBuffIDSelf)
  local selfBuff = ed.BuffCreate(binfo, caster, caster)
  selfBuff.onDamaged = override(selfBuff.onDamaged, VIS.selfBuff_onDamaged)
  caster:addBuff(selfBuff, caster)
  caster.VIS_isCastingUlt = true
end

function VIS.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    basefunc(skill)
  else
    local caster = skill.caster
    local target = skill.target
    skill.attack_counter = skill.attack_counter + 1
    VIS.castRevengeSkill(caster)
    VIS.afterRevengeSkill(caster)
  end
end

function VIS.mateBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local originShield = buff.shield
  local originDamage = damage
  local caster = buff.caster
  if damage <= 10 then
    return 1
  end
  local passDamage = math.min(originDamage * VIS.VIS_ultDefPercent, originShield)
  if source and not transferred then
    caster:takeDamage(passDamage, damage_type, "hp", source, 1, 0, true)
    if caster.VIS_isCastingUlt then
      caster.VIS_mateDamageSum = caster.VIS_mateDamageSum + passDamage
    end
  end
  if caster.VIS_isCastingUlt then
    local finalDmg = basefunc(buff, originDamage * VIS.VIS_ultDefPercent, damage_type, source)
    return finalDmg + originDamage * (1 - VIS.VIS_ultDefPercent)
  else
    return originDamage - passDamage
  end
end

function VIS.skillult_takeEffectAt(basefunc, skill, location, source)
  local info = skill.info
  local aoe = skill.info["AOE Origin"]
  local direction = skill.caster.direction
  skill.curSkillCount = 0
  skill.isEffectAt = true
  if aoe == "self" then
    location = skill.caster.position
  end
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  local caster = skill.caster
  caster.VIS_mateBuffMateList = {}
  caster.VIS_mateDamageSum = 0
  local mateBuffInfo = skill.info.buff_info
  for _, mate in ipairs(caster.VIS_ultTeammate) do
    if mate:isAlive() then
      local mateBuff = ed.BuffCreate(mateBuffInfo, mate, caster)
      mateBuff.onDamaged = override(mateBuff.onDamaged, VIS.mateBuff_onDamaged)
      local finalmateBuff = mate:addBuff(mateBuff, caster)
      table.insert(caster.VIS_mateBuffMateList, mate)
    end
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

function VIS.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if target then
    local enchanted = caster.buff_effects.enchanted
    local caster_position = caster.position
    local dragonTarget
    local min = 0
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local tags = ed.getHeroTags(unit.proto)
      if not ed.isElementInTable("Dragon", tags) then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq and min <= distanceSQ then
          min = distanceSQ
          dragonTarget = unit
        end
      end
    end
    if dragonTarget then
      target = dragonTarget
    end
  end
  if target then
    local proto = {
      _tid = 225,
      _level = skill.level or 1,
      _skill_levels = {
        [1] = skill.level,
        [2] = skill.level
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
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1
    }
    local visBaby = ed.UnitCreate(proto, caster.camp, config)
    local location = {
      target.position[1] + 65 * target.direction,
      target.position[2]
    }
    visBaby.direction = -target.direction
    local visBaby_skillatk2 = visBaby.skills.VISBaby_atk2
    visBaby_skillatk2.createBuff = override(visBaby_skillatk2.createBuff, VIS.visBaby_createBuff)
    visBaby.die = override(visBaby.die, VIS.visBaby_die)
    visBaby.update = override(visBaby.update, VIS.visBaby_update)
    visBaby.visBaby_aiTarget = target
    visBaby.ai.searchTarget = override(visBaby.ai.searchTarget, VIS.visBaby_ai_searchTarget)
    local untargetBuffInfo = ed.lookupDataTable("Buff", nil, VIS.VIS_babyUntargetBuffID)
    visBaby:addBuff(untargetBuffInfo, caster)
    local tags = ed.getHeroTags(target.proto)
    if ed.isElementInTable("Dragon", tags) then
      local hastBuffInfo = ed.lookupDataTable("Buff", nil, VIS.VIS_babyHastBuffID)
      visBaby:addBuff(hastBuffInfo, caster)
    end
    ed.engine:summonUnit(visBaby, location, caster)
    table.insert(caster.VIS_babyList, visBaby)
  end
end

function VIS.hero_die(basefunc, hero, killer)
  for _, unit in ipairs(hero.VIS_babyList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  if hero.VIS_sawakeregion then
    hero.VIS_sawakeregion:terminate()
  end
  basefunc(hero, killer)
end

function VIS.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  VIS.afterRevengeSkill(caster)
end

function VIS.atkProjectile_hit(basefunc, projectile, target)
  local originInfo = projectile.skill.info
  if projectile.orbEffectsRecord then
    projectile.skill.info = ed.wraptable(originInfo, projectile.orbEffectsRecord)
  end
  basefunc(projectile, target)
  projectile.skill.info = originInfo
end

function VIS.skillatk_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.VIS_atk3
  local basicNum = skill.info["Basic Num"]
  local atkProjectile = basefunc(skill)
  if caster.VIS_orbBuffLevel and skillatk3 then
    local orbEffects = {}
    local addNum = skillatk3.info["Basic Num"]
    local plusRatio = skillatk3.info["Script Arg5"]
    if caster.VIS_orbBuffLevel == 1 then
      orbEffects = {
        ["Plus Ratio"] = plusRatio,
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Impact Effect"] = "eff_impact_VIS_atkb.cha"
      }
    elseif caster.VIS_orbBuffLevel == 2 then
      orbEffects = {
        ["Plus Ratio"] = plusRatio,
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Basic Num"] = basicNum + addNum,
        ["Impact Effect"] = "eff_impact_VIS_atkc.cha"
      }
      local hastBuffInfo = ed.lookupDataTable("Buff", nil, VIS.VIS_atk3hastBuffID)
      caster:addBuff(hastBuffInfo, caster)
    elseif caster.VIS_orbBuffLevel == 3 then
      orbEffects = {
        ["Plus Ratio"] = plusRatio,
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Basic Num"] = basicNum + addNum,
        ["Impact Effect"] = "eff_impact_VIS_atkd.cha"
      }
      atkProjectile:enableJump(2)
      local hastBuffInfo = ed.lookupDataTable("Buff", nil, VIS.VIS_atk3hastBuffID)
      caster:addBuff(hastBuffInfo, caster)
    end
    atkProjectile.orbEffectsRecord = orbEffects
    atkProjectile.hit = override(atkProjectile.hit, VIS.atkProjectile_hit)
  end
  return atkProjectile
end

function VIS.skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.VIS_atk3
  local originInfo = skill.info
  if caster.VIS_orbBuffLevel and caster.VIS_orbBuffLevel >= 1 and skillatk3 then
    local projectileStyle = {}
    if caster.VIS_orbBuffLevel == 1 then
      projectileStyle = {
        ["Tile Art"] = "eff_tile_VIS_atkb.cha"
      }
    elseif caster.VIS_orbBuffLevel == 2 then
      projectileStyle = {
        ["Tile Art"] = "eff_tile_VIS_atkc.cha"
      }
    elseif caster.VIS_orbBuffLevel == 3 then
      projectileStyle = {
        ["Tile Art"] = "eff_tile_VIS_atkd.cha"
      }
    end
    skill.info = ed.wraptable(originInfo, projectileStyle)
  end
  basefunc(skill)
  skill.info = originInfo
end

function VIS.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if lost and 0 < lost then
    if not hero.VIS_scaleNum then
      hero.VIS_scaleNum = 0
    end
    hero.VIS_scaleNum = math.max(hero.VIS_scaleNum - 1, 0)
    hero.VIS_recentHurt = true
    if ed.run_with_scene and hero.actor and hero.VIS_scaleLevel then
      local effect_name = VIS.VIS_atk4bodyEffectList[hero.VIS_scaleLevel]
      hero.actor:addEffect(effect_name, 1)
    end
  end
  return lost
end

function VIS.hero_update_skillatk3(hero, dt, skill)
  if not hero.VIS_orbBuffLevel then
    hero.VIS_orbBuffLevel = 0
  end
  if not hero.VIS_unitList then
    hero.VIS_unitList = {}
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      table.insert(hero.VIS_unitList, {
        unit,
        unit.battledata.beardmg
      })
    end
  end
  local sumLevel = 0
  for _, union in ipairs(hero.VIS_unitList) do
    local hpRatio = 0
    if union[1].camp ~= hero.camp then
      hpRatio = VIS.VIS_atk3HPRatio
    else
      hpRatio = VIS.VIS_atk3HPRatioMate
    end
    local extraLevel = math.floor((union[1].battledata.beardmg - union[2]) / (union[1].attribs.HP * hpRatio))
    if 0 < extraLevel then
      sumLevel = sumLevel + extraLevel
      union[2] = union[2] + extraLevel * (union[1].attribs.HP * hpRatio)
    end
  end
  if 0 < sumLevel then
    local buffNum = 0
    local oldBuffList = {}
    for _, buff in ipairs(hero.buff_list) do
      if buff.info.ID == VIS.VIS_atk3BuffID then
        buffNum = buffNum + 1
        table.insert(oldBuffList, {
          buff,
          buff.timer
        })
      end
    end
    local VISatk3BuffInfo = skill.info.buff_info
    if sumLevel + buffNum <= VIS.VIS_atk3BuffLimit then
      for i = 1, sumLevel do
        hero:addBuff(VISatk3BuffInfo, hero)
      end
    else
      if 0 < buffNum then
        table.sort(oldBuffList, function(a, b)
          return a[2] < b[2]
        end)
      end
      local refreshBuffNum = 0
      if sumLevel >= VIS.VIS_atk3BuffLimit then
        refreshBuffNum = buffNum
        if 0 < refreshBuffNum then
          for i = 1, refreshBuffNum do
            oldBuffList[i][1].timer = 0
          end
        end
        for i = 1, VIS.VIS_atk3BuffLimit do
          hero:addBuff(VISatk3BuffInfo, hero)
        end
      else
        refreshBuffNum = sumLevel + buffNum - VIS.VIS_atk3BuffLimit
        if 0 < buffNum then
          for i = 1, refreshBuffNum do
            oldBuffList[i][1].timer = 0
          end
        end
        for i = 1, sumLevel do
          hero:addBuff(VISatk3BuffInfo, hero)
        end
      end
    end
  end
  local BuffNumNow = 0
  for _, buff in ipairs(hero.buff_list) do
    if buff.info.ID == VIS.VIS_atk3BuffID and buff.timer ~= 0 then
      BuffNumNow = BuffNumNow + 1
    end
  end
  hero.VIS_orbBuffLevel = math.min(BuffNumNow, VIS.VIS_atk3BuffLimit)
  if ed.run_with_scene and hero.actor then
    if not hero.VIS_effectBuffNumPre then
      hero.VIS_effectBuffNumPre = 0
      hero.VIS_effectFirstTime = true
    end
    if hero.VIS_effectFirstTime or hero.VIS_orbBuffLevel ~= hero.VIS_effectBuffNumPre then
      local effect_name = VIS.VIS_akt3headEffectList[hero.VIS_orbBuffLevel + 1]
      local effect_id = hero.actor:addEffect(effect_name, 1)
      if hero.VIS_preEffectID then
        hero.actor.puppet:removeEffectWithID(hero.VIS_preEffectID)
      end
      hero.VIS_preEffectID = effect_id
      hero.VIS_effectFirstTime = false
      hero.VIS_effectBuffNumPre = BuffNumNow
    end
  end
end

function VIS.hero_update_skillatk4(hero, dt, skill)
  if not hero.VIS_scaleNum then
    hero.VIS_scaleNum = 0
  end
  if not hero.VIS_scaleLevel then
    hero.VIS_scaleLevel = 1
  end
  if not hero.VIS_preTick then
    hero.VIS_preTick = ed.engine.ticks
  end
  if ed.engine.ticks - hero.VIS_preTick >= VIS.VIS_scaleRecover or hero.VIS_recentHurt or hero.VIS_isCastingUlt then
    hero.VIS_recentHurt = false
    if ed.engine.ticks - hero.VIS_preTick >= VIS.VIS_scaleRecover then
      local addScaleTick = ed.engine.ticks - hero.VIS_preTick
      local extraTick = addScaleTick % VIS.VIS_scaleRecover
      hero.VIS_preTick = ed.engine.ticks - extraTick
      local addScaleNum = math.floor(addScaleTick / VIS.VIS_scaleRecover)
      hero.VIS_scaleNum = math.min(hero.VIS_scaleNum + addScaleNum, (VIS.VIS_scaleLimit - 1) * VIS.VIS_scaleHit)
    end
    if hero.VIS_isCastingUlt then
      hero.VIS_scaleNum = (VIS.VIS_scaleLimit - 1) * VIS.VIS_scaleHit
    end
    local scaleBuffStack = math.floor((hero.VIS_scaleNum - 1) / VIS.VIS_scaleHit) + 1
    hero.VIS_scaleLevel = scaleBuffStack + 1
    local currentBuffNum = 0
    for _, buff in ipairs(hero.buff_list) do
      if buff.info.ID == VIS.VIS_scaleBuffID then
        currentBuffNum = currentBuffNum + 1
        if currentBuffNum > hero.VIS_scaleLevel then
          buff.timer = 0
        end
      end
    end
    if currentBuffNum < hero.VIS_scaleLevel then
      local addBuffNum = hero.VIS_scaleLevel - currentBuffNum
      local scaleBuffInfo = skill.info.buff_info
      for i = 1, addBuffNum do
        hero:addBuff(scaleBuffInfo, hero)
      end
    end
  end
end

function VIS.hero_update_skillawake(hero, dt, skill)
  if not hero.VIS_enterEnemyList then
    hero.VIS_enterEnemyList = {}
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      table.insert(hero.VIS_enterEnemyList, {unit, true})
    end
  end
  local weakEnemy = {}
  for _, enemy in ipairs(hero.VIS_enterEnemyList) do
    if not enemy[2] then
    elseif not enemy[1]:isAlive() then
      enemy[2] = false
    elseif not (enemy[1].hp / enemy[1].attribs.HP <= VIS.VIS_awakeRatio) then
    elseif enemy[1].buff_effects.untargetable then
    elseif enemy[1].buff_effects.invulnerable then
    elseif enemy[1].buffManager.invisible and enemy[1].camp ~= hero.camp then
    elseif enemy[1].position[1] < ed.engine.stage_rect.minX or enemy[1].position[2] > ed.engine.stage_rect.maxX then
    else
      enemy[2] = false
      table.insert(weakEnemy, enemy[1])
    end
  end
  if 1 <= #weakEnemy then
    for _, weakman in ipairs(weakEnemy) do
      local binfo = skill.info.buff_info
      local weakBuff = ed.BuffCreate(binfo, weakman, hero)
      weakman:addBuff(weakBuff, hero)
      local awakeProjectile = skill:createProjectile()
      awakeProjectile.watchTarget = weakman
      ed.engine:addProjectile(awakeProjectile)
    end
  end
end

function VIS.hero_update(basefunc, hero, dt)
  if hero:isAlive() and hero.config and hero.config.is_summoned then
    local skillult = hero.skills.VIS_ult
    if skillult then
      hero:setMP(0)
    end
    local skillatk2 = hero.skills.VIS_atk2
    if skillatk2 then
      skillatk2.cd_remaining = 9999
    end
  end
  basefunc(hero, dt)
  if hero:isAlive() then
    local skillult = hero.skills.VIS_ult
    if skillult and not hero.VIS_ultTeammate then
      hero.VIS_ultTeammate = {}
      for unit in ed.engine:foreachAliveUnit(hero.camp) do
        if unit ~= hero then
          table.insert(hero.VIS_ultTeammate, unit)
        end
      end
    end
    local skillatk4 = hero.skills.VIS_atk4
    if skillatk4 then
      VIS.hero_update_skillatk4(hero, dt, skillatk4)
    end
    local skillatk3 = hero.skills.VIS_atk3
    if skillatk3 then
      VIS.hero_update_skillatk3(hero, dt, skillatk3)
    end
    local skillawake = hero.skills.VIS_awake
    if skillawake then
      VIS.hero_update_skillawake(hero, dt, skillawake)
    end
    local skillsawake = hero.skills.VIS_sawake
    if skillsawake and hero.name == "VIS" then
      VIS.hero_update_skillsawake(hero, dt, skillsawake)
    end
  end
end

function VIS.awakeProject_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  local watchTarget = projectile.watchTarget
  if watchTarget then
    local hasBuff = false
    for _, buff in ipairs(watchTarget.buff_list) do
      if buff.info.ID == VIS.VIS_awakeBuffID then
        hasBuff = true
        break
      end
    end
    if hasBuff then
      if watchTarget.state == ed.emUnitState_Dying then
        watchTarget.state = ed.emUnitState_Dead
        watchTarget:setAction(nil)
        watchTarget.hasCorpse = false
        if watchTarget.actor and watchTarget.actor.node then
          watchTarget.actor.node:setVisible(false)
        end
        if ed.run_with_scene then
          local effect_name = "eff_buff_VIS_awakeb"
          ed.scene:playEffectOnScene(effect_name, watchTarget.position, {1, 1}, nil, 0)
        end
        if not projectile.terminated then
          projectile:terminate()
        end
      elseif watchTarget.state == ed.emUnitState_Dead then
        if not projectile.terminated then
          projectile:terminate()
        end
      else
        return
      end
    elseif not projectile.terminated then
      projectile:terminate()
    end
  end
end

function VIS.skillawake_createProjectile(basefunc, skill)
  local awakeProject = basefunc(skill)
  awakeProject.update = override(awakeProject.update, VIS.awakeProject_update)
  awakeProject.height = 999
  return awakeProject
end

function VIS.skillatk_startPhase(basefunc, skill, idx)
  local phaseNum = idx
  local caster = skill.caster
  if not caster.VIS_atkRandom then
    caster.VIS_atkRandom = {
      [1] = 2,
      [2] = 2
    }
  end
  local randNum = ed.rand()
  if 0.5 < randNum then
    phaseNum = phaseNum + 1
  end
  if phaseNum ~= 1 and phaseNum ~= 2 then
    phaseNum = 2
  end
  if caster.VIS_atkRandom[1] == caster.VIS_atkRandom[2] then
    phaseNum = caster.VIS_atkRandom[1] % 2 + 1
  end
  caster.VIS_atkRandom[1] = caster.VIS_atkRandom[2]
  caster.VIS_atkRandom[2] = phaseNum
  basefunc(skill, phaseNum)
end

function VIS.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function VIS.hero_update_skillsawake(hero, dt, skill)
  local skillsawake = hero.skills.VIS_sawake
  local sawake_region = hero.skills.VIS_sawake_region
  local Steal_Ratio = skillsawake.info["Script Arg4"]
  local Steal_Max = skillsawake.info["Script Arg5"]
  local VIS_stealMax = skillsawake.info["Script Arg6"]
  local Enemy_sawake_binfo = ed.lookupDataTable("Buff", nil, VIS.VIS_sawakeStealBuff)
  local VIS_sawake_binfo = ed.lookupDataTable("Buff", nil, VIS.VIS_sawakeStrengthenBuff)
  hero.VIS_startTime = hero.VIS_startTime and hero.VIS_startTime + dt or dt
  if hero.VIS_startTime >= 0.5 and skillsawake and hero.name == "VIS" and not hero.config.is_summoned then
    sawake_region.target = hero
    hero.VIS_sawakeregion = sawake_region:createRegion()
    ed.engine:addRegion(hero.VIS_sawakeregion)
    hero.VIS_startTime = -9999
  end
  if not hero.VIS_sawakeEnemyList then
    hero.VIS_sawakeEnemyList = {}
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      table.insert(hero.VIS_sawakeEnemyList, {
        unit,
        false,
        false,
        0,
        0,
        0
      })
      unit.PutinList = true
    end
  end
  for unit in ed.engine:foreachAliveUnit(-hero.camp) do
    if true then
      if not unit.config.is_summoned or unit.PutinList ~= nil or unit.buff_effects.untargetable then
        break
      end
      if unit.buff_effects.invulnerable then
        break
      end
      if unit.buffManager.invisible and unit.camp ~= hero.camp then
        break
      end
      table.insert(hero.VIS_sawakeEnemyList, {
        unit,
        false,
        false,
        0,
        0,
        0
      })
      unit.PutinList = true
    else
      break
    end
  end
  for _, enemy in ipairs(hero.VIS_sawakeEnemyList) do
    if enemy then
      for _, tbuff in ipairs(enemy[1].buff_list) do
        if tbuff.info.ID == 1525 then
          enemy[2] = true
        elseif tbuff.info.ID == 1526 then
          enemy[3] = true
        end
      end
    end
    if hero.VIS_startTime >= 0.5 then
      enemy[5] = enemy[1].attribs.ARM
      enemy[6] = enemy[1].attribs.MR
    end
    if enemy[2] == true then
      if enemy[4] <= 7 then
        enemy[4] = enemy[4] and enemy[4] + dt or dt
      else
        enemy[4] = 0
      end
    else
      enemy[4] = 0
    end
    if enemy[4] == 7 and enemy[3] == false then
      local Enemy_stolen = ed.BuffCreate(Enemy_sawake_binfo, enemy[1], hero)
      local VIS_strengthen = ed.BuffCreate(VIS_sawake_binfo, hero, hero)
      local Enemy_arm = enemy[5] * Steal_Ratio
      local Enemy_mr = enemy[6] * Steal_Ratio
      if enemy[1] then
        if Steal_Max <= Enemy_arm then
          Enemy_arm = Steal_Max
        end
        if Steal_Max <= Enemy_mr then
          Enemy_mr = Steal_Max
        end
        Enemy_stolen:setAttribute("ARM", -Enemy_arm)
        Enemy_stolen:setAttribute("MR", -Enemy_mr)
        enemy[1]:addBuff(Enemy_stolen, hero)
        hero.VIS_sawake_ARM = Enemy_arm + hero.VIS_sawake_ARM
        hero.VIS_sawake_MR = Enemy_arm + hero.VIS_sawake_MR
        if VIS_stealMax <= hero.VIS_sawake_ARM then
          hero.VIS_sawake_ARM = VIS_stealMax
        end
        if VIS_stealMax <= hero.VIS_sawake_MR then
          hero.VIS_sawake_MR = VIS_stealMax
        end
        VIS_strengthen:setAttribute("ARM", hero.VIS_sawake_ARM)
        VIS_strengthen:setAttribute("MR", hero.VIS_sawake_MR)
        if hero.VIS_hasStrengthen == false then
          hero.VIS_strengthenBuff = hero:addBuff(VIS_strengthen, hero)
          hero.VIS_hasStrengthen = true
        elseif hero.VIS_hasStrengthen == true and hero.VIS_strengthenBuff then
          hero.VIS_strengthenBuff.owner:removeBuff(hero.VIS_strengthenBuff)
          hero.VIS_strengthenBuff = hero:addBuff(VIS_strengthen, hero)
        end
      end
    end
  end
end

function VIS.hero_reset(basefunc, hero)
  hero.VIS_babyList = {}
  hero.VIS_mateDamageSum = nil
  hero.VIS_atkRandom = nil
  hero.VIS_enterEnemyList = nil
  hero.VIS_preEffectID = nil
  hero.VIS_effectFirstTime = nil
  hero.VIS_effectBuffNumPre = nil
  hero.VIS_orbBuffLevel = nil
  hero.VIS_unitList = nil
  hero.VIS_scaleNum = nil
  hero.VIS_scaleLevel = nil
  hero.VIS_preTick = nil
  hero.VIS_ultTeammate = nil
  hero.VIS_recentHurt = nil
  hero.VIS_mateBuffMateList = nil
  hero.VIS_isCastingUlt = nil
  hero.VIS_position = nil
  hero.VIS_hasRegion = false
  hero.VIS_sawakeEnemyList = nil
  hero.VIS_hasStrengthen = false
  hero.VIS_strengthenBuff = nil
  hero.VIS_startTime = 0
  hero.VIS_sawake_ARM = 0
  hero.VIS_sawake_MR = 0
  hero.VIS_sawake_Max = 0
  basefunc(hero)
end

function VIS.init_hero(hero)
  local skillult = hero.skills.VIS_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, VIS.skillult_takeEffectAt)
    skillult.start = override(skillult.start, VIS.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, VIS.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, VIS.skillult_finish)
  end
  local skillatk2 = hero.skills.VIS_atk2
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, VIS.skillatk2_onAttackFrame)
    hero.VIS_babyList = {}
    hero.die = override(hero.die, VIS.hero_die)
  end
  local skillatk3 = hero.skills.VIS_atk3
  local skillatk = hero.skills.VIS_atk
  if skillatk3 and skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, VIS.skillatk_createProjectile)
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, VIS.skillatk_onAttackFrame)
  end
  local skillatk4 = hero.skills.VIS_atk4
  if skillatk4 then
    hero.takeDamage = override(hero.takeDamage, VIS.hero_takeDamage)
  end
  local skillawake = hero.skills.VIS_awake
  if skillawake then
    skillawake.createProjectile = override(skillawake.createProjectile, VIS.skillawake_createProjectile)
  end
  if skillatk3 or skillatk4 or skillult or skillawake then
    hero.update = override(hero.update, VIS.hero_update)
  end
  local skillatk = hero.skills.VIS_atk
  if skillatk then
    skillatk.startPhase = override(skillatk.startPhase, VIS.skillatk_startPhase)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, VIS.skillatk_onPhaseFinished)
  end
  local skillsawake = hero.skills.VIS_sawake
  if skillsawake then
  end
  hero.reset = override(hero.reset, VIS.hero_reset)
  return hero
end

return VIS.init_hero
