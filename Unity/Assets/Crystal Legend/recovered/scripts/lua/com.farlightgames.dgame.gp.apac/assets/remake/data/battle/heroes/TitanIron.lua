module("ed.battlehero", package.seeall)
local ed = ed
TitanIron = {}
TitanIron.atk2_distance = 200
TitanIron.atk4_CD = 9
TitanIron.atk4BuffID = 1648
TitanIron.atk2_distance = 150
TitanIron.phantom_livetime = 6
TitanIron.phantom_livetimeextra = 3
TitanIron.phantom_livetimeArcana = 1
TitanIron.TitanIron_atk3 = 1648
TitanIron.skillatk2_phantom_buffID = 1649
TitanIron.TitanIron_phantom_taunt = 1650
TitanIron.TitanIron_atk4_hastbuff_bid = 1651
TitanIron.TitanIron_atk4_fearbuff_bid = 1652
TitanIron.atk4_CDdown = 2
TitanIron.TitanIron_atk4_HPratio = 20000
TitanIron.skillult_buffID = 1654
TitanIron.ArcanaHpRatio = 0.1
TitanIron.ArcanaHpMax = 100000
TitanIron.TitanIron_atk3_hit = 1656
TitanIron.nil_bid = 1657
TitanIron.skillFashionId = 100921

function TitanIron.reset(basefunc, hero)
  basefunc(hero)
  hero.TitanIron_PhantomList = {}
  hero.TitanIron_atk4_CD = TitanIron.atk4_CD
  local fashionId = hero.fashion_id
  if fashionId and fashionId == TitanIron.skillFashionId then
    hero:enterActionStageFromOneStage(3, 10092)
  end
  if hero.currentActionStage == 4 then
    hero:enterActionStageFromOneStage(3, 10092)
  elseif hero.currentActionStage == 2 then
    hero:enterActionStageFromOneStage(1, 10092)
  end
end

function TitanIron.update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.TitanIron_atk4_CD = hero.TitanIron_atk4_CD - dt
end

function TitanIron.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  skill.casterDirectionLocked = false
end

function TitanIron.phantom_die(basefunc, phantom, killer)
  basefunc(phantom, killer)
end

function TitanIron.phantom_update(basefunc, phantom, dt)
  basefunc(phantom, dt)
  if phantom.livetime > 0 then
    phantom.livetime = phantom.livetime - dt
  else
    phantom:die()
  end
end

function TitanIron.summonPhantom(hero, skill, pos, dir)
  local caster = hero
  local skilllevel = {
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level,
    skill.level
  }
  if caster and caster:isAlive() then
    local proto = {
      _tid = 290,
      _level = skill.level or 1,
      _skill_levels = skilllevel,
      _stars = caster.stars,
      _rank = caster.rank
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      dps_mod = caster.config.dps_mod or 1,
      summoner = caster
    }
    local phantom = ed.UnitCreate(proto, caster.camp, config)
    phantom.direction = dir
    phantom.father = caster
    phantom.die = override(phantom.die, TitanIron.phantom_die)
    phantom.livetime = TitanIron.phantom_livetime + ed.rand() * TitanIron.phantom_livetimeextra
    if caster.TitanIron_hasArcana and 1 < caster.TitanIron_hasArcana then
      phantom.livetime = phantom.livetime + TitanIron.phantom_livetimeArcana
    end
    phantom.update = override(phantom.update, TitanIron.phantom_update)
    phantom.isDeathWithEffect = true
    local bid = TitanIron.skillatk2_phantom_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, phantom, caster)
    phantom:addBuff(buff, caster)
    ed.engine:summonUnit(phantom, pos, caster, "Birth2")
    table.insert(caster.TitanIron_PhantomList, phantom)
    return phantom
  end
end

function TitanIron.skillatk23_startPhase(basefunc, skill, idx)
  local target = skill.target
  local caster = skill.caster
  if target then
    if target.position[1] - caster.direction >= 0 and skill.target.position[1] + 100 < ed.engine.stage_rect.maxX or target.position[1] - caster.direction < 0 and skill.target.position[1] - 100 > ed.engine.stage_rect.minX then
      skill.TitanIron_atk23_delta = 100
      basefunc(skill, 2)
    else
      skill.TitanIron_atk23_delta = -100
      basefunc(skill, 1)
    end
  end
end

function TitanIron.skillatk23_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function TitanIron.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    skill.casterDirectionLocked = true
    local TitanIron_atk2_target = skill.target
    local caster = skill.caster
    local dir = caster.direction
    if TitanIron_atk2_target and caster.position[1] ~= TitanIron_atk2_target.position[1] then
      dir = (TitanIron_atk2_target.position[1] - caster.position[1]) / math.abs(caster.position[1] - TitanIron_atk2_target.position[1])
    end
    local phantom = TitanIron.summonPhantom(caster, skill, {
      caster.position[1],
      caster.position[2]
    }, dir)
    if TitanIron_atk2_target and TitanIron_atk2_target:isAlive() then
      local bid2 = TitanIron.TitanIron_phantom_taunt
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      TitanIron_atk2_target:addBuff(binfo2, phantom)
    end
    caster:setPosition({
      target.position[1] + caster.direction * skill.TitanIron_atk23_delta,
      target.position[2]
    })
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    basefunc(skill)
  elseif attack_counter == 3 then
    basefunc(skill)
  end
end

function TitanIron.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 or attack_counter == 2 then
    power = power * 0.35
  end
  return power
end

function TitanIron.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = TitanIron.TitanIron_atk3_hit
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function TitanIron.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    skill.casterDirectionLocked = true
    basefunc(skill)
  elseif attack_counter == 1 and skill.target then
    caster:setPosition({
      skill.target.position[1] + caster.direction * skill.TitanIron_atk23_delta,
      skill.target.position[2]
    })
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 and skill.target and skill.target:isAlive() then
    skill:takeEffectOn(skill.target)
  end
end

function TitanIron.TitanIron_atk3_projectile_hit(basefunc, projectile, target)
  basefunc(projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  if target == skill.target then
    projectile:terminate()
  end
end

function TitanIron.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.TitanIron_atk3_projectile = projectile
  projectile.height = 50
  projectile.hit = override(projectile.hit, TitanIron.TitanIron_atk3_projectile_hit)
  return projectile
end

function TitanIron.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if target == skill.target then
    power = power * 1.5
  end
  return power
end

function TitanIron.skillatk3_buffUpgrade(basefunc, buff, owner, caster, nextBuffInfo)
  basefunc(buff, owner, caster, nextBuffInfo)
  if buff.rank >= 2 then
    local hero = buff.caster
    local skill = hero.skills.TitanIron_atk3
    local dir = owner.direction
    local phantom = TitanIron.summonPhantom(hero, skill, {
      owner.position[1] + owner.direction * 50,
      owner.position[2]
    }, dir)
    local target = buff.owner
    if target and target:isAlive() and target and target:isAlive() then
      local damage = target.attribs.HP * TitanIron.ArcanaHpRatio
      if caster.TitanIron_hasArcana and caster.TitanIron_hasArcana > 3 then
        local crit_val = caster.attribs.CSD
        damage = damage * (crit_val and crit_val * 0.01 + 2 or 2)
      end
      damage = math.min(damage, TitanIron.ArcanaHpMax)
      target:takeDamage(damage, "Holy", "hp", skill.caster, 1, 1)
    end
    buff.timer = -1
  end
end

function TitanIron.skillatk_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local phantom_alive = 0
  for i, unit in ipairs(caster.TitanIron_PhantomList) do
    if unit:isAlive() then
      phantom_alive = phantom_alive + 1
    end
    if 2 <= phantom_alive then
      local bid = 1648
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local tag_adding = ed.BuffCreate(binfo, target, caster)
      tag_adding.upgrade = override(tag_adding.upgrade, TitanIron.skillatk_buffUpgrade)
      target:addBuff(tag_adding, caster)
      break
    end
  end
end

function TitanIron.skillatk_buffUpgrade(basefunc, buff, owner, caster, nextBuffInfo)
  local target = buff.owner
  basefunc(buff, owner, caster, nextBuffInfo)
  if buff.rank >= 2 then
    if target and target:isAlive() then
      local damage = target.attribs.HP * TitanIron.ArcanaHpRatio
      if caster.TitanIron_hasArcana and caster.TitanIron_hasArcana > 3 then
        local crit_val = caster.attribs.CSD
        damage = damage * (crit_val and crit_val * 0.01 + 2 or 2)
      end
      damage = math.min(damage, TitanIron.ArcanaHpMax)
      target:takeDamage(damage, "Holy", "hp", caster, 1, 1)
    end
    buff.timer = -1
  end
end

function TitanIron.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.upgrade = override(buff.upgrade, TitanIron.skillatk3_buffUpgrade)
  return buff
end

function TitanIron.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanIron.TitanIron_atk2_fix then
      tbuff.timer = 0
    end
  end
  skill.casterDirectionLocked = false
end

function TitanIron.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true,
    icefrozen = true,
    stunbyself = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function TitanIron.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  local skillatk3 = self.skills.TitanIron_atk3
  local skillatk4 = self.skills.TitanIron_atk4
  if buff.info.ID ~= 4248 and buff.info.ID ~= 4263 and buff.info.ID ~= 4432 then
    if skillatk4 and owner == self and self.TitanIron_PhantomList then
      local phantomNum = 0
      for i, unit in ipairs(self.TitanIron_PhantomList) do
        if unit and unit:isAlive() then
          phantomNum = phantomNum + 1
          break
        end
      end
      if TitanIron.isCrlEftConflictWithUncontrollableSP(buff) or caster.camp ~= owner.camp and buff.info.Tenacity then
        buff.timer = math.max(buff.timer - phantomNum, 1)
      end
    end
    if skillatk4 and self.TitanIron_atk4_CD and 0 >= self.TitanIron_atk4_CD and owner == self and self:isAlive() and buff.caster and buff.caster.camp ~= owner.camp and TitanIron.isCrlEftConflictWithUncontrollableSP(buff) then
      local bid = TitanIron.nil_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      config.buff = ed.BuffCreate(binfo, owner, buff.caster)
      config.buff.TitanIron_trigger = true
      local phantom
      for i, unit in ipairs(self.TitanIron_PhantomList) do
        if unit and unit:isAlive() then
          phantom = unit
          break
        end
      end
      if phantom and phantom:isAlive() then
        TitanIron.PhantomEscape(self, phantom, caster)
      end
    end
  end
end

function TitanIron.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  local skillatk4 = hero.skills.TitanIron_atk4
  local phantom
  if skill and skill.info["Skill Group ID"] ~= 19611 and skillatk4 and lost > TitanIron.TitanIron_atk4_HPratio and skill and not skill.info["Ignore Shield"] then
    for i, unit in ipairs(hero.TitanIron_PhantomList) do
      if unit and unit:isAlive() then
        phantom = unit
        break
      end
    end
    if phantom and phantom:isAlive() and hero.TitanIron_atk4_CD and hero.TitanIron_atk4_CD <= 0 then
      lost = 0
      TitanIron.PhantomEscape(hero, phantom, source)
    end
  end
  return lost
end

function TitanIron.PhantomEscape(hero, phantom, source)
  local fashionId = hero.fashion_id
  hero.TitanIron_atk4_CD = TitanIron.atk4_CD
  local position_hero = {
    hero.position[1],
    hero.position[2]
  }
  local position_phantom = {
    phantom.position[1],
    phantom.position[2]
  }
  hero:setPosition({
    position_phantom[1],
    position_phantom[2]
  })
  phantom:die()
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanIron_atk4.cha"
    if fashionId and fashionId == TitanIron.skillFashionId then
      local effect_name = "eff_point_TitanIron_Skin_atk4.cha"
    end
    local effect1 = ed.scene:playEffectOnScene(effect_name, position_hero, {
      hero.direction * 0.85,
      0.85
    }, nil, 1, nil, nil, nil)
    local effect2 = ed.scene:playEffectOnScene(effect_name, position_phantom, {
      hero.direction * 0.85,
      0.85
    }, nil, 1, nil, nil, nil)
  end
  local skillatk4 = hero.skills.TitanIron_atk4
  local skillatk3 = hero.skills.TitanIron_atk3
  local bid2 = TitanIron.TitanIron_atk4_hastbuff_bid
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = ed.BuffCreate(binfo2, hero, hero)
  buff2:setAttribute("AD", skillatk4.info["Script Arg2"])
  local buffresult2 = hero:addBuff(buff2, hero)
  if source and source.what == "petUnit" then
    source = source.owner
  end
  source:hurt()
  local bid3 = TitanIron.TitanIron_atk4_fearbuff_bid
  local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
  local bid4 = TitanIron.TitanIron_atk3
  local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
  local bSucess, reason = ed.Buff.checkAddBuff(binfo3, skillatk4.level, source, caster)
  if bSucess then
    local buff3 = ed.BuffCreate(binfo3, source, hero)
    buff3:setAttribute("fearrange", 5)
    local buffresult3 = source:addBuff(buff3, hero)
  end
  local buff4 = ed.BuffCreate(binfo4, source, hero)
  local buffresult4 = source:addBuff(buff4, hero)
  skillatk3.cd_remaining = skillatk3.cd_remaining - TitanIron.atk4_CDdown
end

function TitanIron.skillult_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster.currentActionStage == 2 then
    caster:enterActionStageFromOneStage(1, 10092)
  elseif caster.currentActionStage == 4 then
    caster:enterActionStageFromOneStage(3, 10092)
  end
end

function TitanIron.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanIron_atk2
  local skillatk3 = caster.skills.TitanIron_atk3
  local bid = TitanIron.skillult_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.timer = skill.info["Script Arg1"]
  if caster.stars > 6 then
  end
  buff.onRemoved = override(buff.onRemoved, TitanIron.skillult_buffOnRemoved)
  caster:addBuff(buff, caster)
  if caster.TitanIron_hasArcana and caster.TitanIron_hasArcana > 2 then
    TitanIron.summonPhantom(caster, skill, {
      caster.position[1] + 150,
      caster.position[2]
    }, caster.direction)
    TitanIron.summonPhantom(caster, skill, {
      caster.position[1] - 150,
      caster.position[2]
    }, -caster.direction)
  end
end

function TitanIron.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local HealRatio = -1 * (10 + 5 * (caster.stars - 7))
  if caster.stars > 6 then
    buff:setAttribute("HealRatio", HealRatio)
  end
  if target.config.is_boss then
    buff:setAttribute("HAST", 0)
    buff:setAttribute("MSPD", 0)
  end
  return buff
end

function TitanIron.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  local haveUltBuff
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanIron.skillult_buffID then
      haveUltBuff = true
    end
  end
  if result and haveUltBuff then
    result = false
  end
  return result
end

function TitanIron.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local fashionId = caster.fashion_id
  local skillatk2 = caster.skills.TitanIron_atk2
  local skillatk3 = caster.skills.TitanIron_atk3
  if caster.currentActionStage == 1 or caster.currentActionStage == 3 then
    if skillatk2 then
      caster.TitanIron_atk2_CDremaining = skillatk2.cd_remaining or 9
    end
    if skillatk3 then
      caster.TitanIron_atk3_CDremaining = skillatk3.cd_remaining or 16
    end
    if fashionId and fashionId == TitanIron.skillFashionId then
      caster:enterActionStageFromOneStage(4, 10092)
    else
      caster:enterActionStageFromOneStage(2, 10092)
    end
    if skillatk2 then
      skillatk2.cd_remaining = caster.TitanIron_atk2_CDremaining or 9
    end
    if skillatk3 then
      skillatk3.cd_remaining = caster.TitanIron_atk3_CDremaining or 16
    end
  end
end

function TitanIron.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  for i, unit in ipairs(hero.TitanIron_PhantomList) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
end

function TitanIron.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillatk = hero.skills.TitanIron_atk
  local skillult = hero.skills.TitanIron_ult
  local skillatk2 = hero.skills.TitanIron_atk2
  local skillatk3 = hero.skills.TitanIron_atk3
  local skillatk4 = hero.skills.TitanIron_atk4
  local fashionId = hero.fashion_id
  hero.TitanIron_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero:setActionStageChangeByManual(true)
  if skillatk and fashionId and fashionId == TitanIron.skillFashionId then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanIron.skillatk_takeEffectOn)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanIron.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanIron.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, TitanIron.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, TitanIron.skillult_createBuff)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanIron.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, TitanIron.skillatk2_finish)
    skillatk2.startPhase = override(skillatk2.startPhase, TitanIron.skillatk23_startPhase)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, TitanIron.skillatk23_onPhaseFinished)
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, TitanIron.skillatk3_power)
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanIron.skillatk3_createProjectile)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanIron.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanIron.skillatk3_createBuff)
    skillatk3.start = override(skillatk3.start, TitanIron.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, TitanIron.skillatk3_finish)
    skillatk3.startPhase = override(skillatk3.startPhase, TitanIron.skillatk23_startPhase)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, TitanIron.skillatk23_onPhaseFinished)
  end
  if skillatk4 then
  end
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanIron.hero_getLostHPAfterImmunity)
  hero.reset = override(hero.reset, TitanIron.reset)
  hero.die = override(hero.die, TitanIron.hero_die)
  hero.update = override(hero.update, TitanIron.update)
  hero.collectBuff = override(hero.collectBuff, TitanIron.collectBuff)
  return hero
end

return TitanIron.init_hero
