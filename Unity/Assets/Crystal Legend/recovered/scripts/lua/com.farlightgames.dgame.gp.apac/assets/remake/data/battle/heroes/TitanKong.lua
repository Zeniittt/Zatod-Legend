module("ed.battlehero", package.seeall)
local ed = ed
TitanKong = {}

function TitanKong.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanKong.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4659
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanKong.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4659 then
      tbuff.timer = 0
    end
  end
end

function TitanKong.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skilllevel = {
    skill.level,
    skill.level
  }
  local skillRemnant2 = caster.skills.TitanKong_Remnant2
  local TitanKong_summontCount = 1
  if skillRemnant2 then
    TitanKong_summontCount = TitanKong_summontCount + 1
  end
  if caster.TitanKong_hasArcana and caster.TitanKong_hasArcana > 3 then
    TitanKong_summontCount = TitanKong_summontCount + 1
  end
  local proto = {
    _tid = 324,
    _level = skill.level or 1,
    _stars = caster.stars,
    _skill_levels = skilllevel,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 1 or caster.config.hp_mod * 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local skillatk3_cd = 0
  for n = 1, TitanKong_summontCount do
    local TitanKong_Mirror = ed.UnitCreate(proto, caster.camp, config)
    TitanKong_Mirror.direction = caster.direction
    local locationTitanKong_Mirror = {
      caster.position[1] + caster.direction * 100 + ed.rand() * 50,
      caster.position[2] - 50 + ed.rand() * 100
    }
    ed.engine:summonUnit(TitanKong_Mirror, locationTitanKong_Mirror, caster, "Birth")
    TitanKong_Mirror.father = caster
    TitanKong_Mirror.die = override(TitanKong_Mirror.die, function(basefunc, unit, killer)
      unit:setDeathWithEffectOrNot(true)
      basefunc(unit, killer)
    end)
    TitanKong_Mirror.alive_time = skill.info["Script Arg2"]
    TitanKong_Mirror.TitanKong_resdmg = true
    TitanKong_Mirror.update = override(TitanKong_Mirror.update, TitanKong.TitanKong_Mirror_update)
    local AttriBinfo = ed.lookupDataTable("Buff", nil, 4664)
    local Attri_x = caster.TitanKong_hasArcana and caster.TitanKong_hasArcana > 3 and skill.info["Script Arg4"] * 0.8 or skill.info["Script Arg4"]
    TitanKong.changeBuffInfo(AttriBinfo, Attri_x, TitanKong_Mirror, 1)
    local buff = TitanKong_Mirror:addBuff(AttriBinfo, caster)
    TitanKong_Mirror:takeHeal(math.min(TitanKong_Mirror.attribs.HP, 1000000))
    local TitanKong_Mirror_skillatk3 = TitanKong_Mirror.skills.TitanKong_Mirror_atk3
    if TitanKong_Mirror_skillatk3 and skillatk3_cd then
      skillatk3_cd = skillatk3_cd + 2
      TitanKong_Mirror_skillatk3.cd_remaining = skillatk3_cd
      TitanKong_Mirror_skillatk3.start = override(TitanKong_Mirror_skillatk3.start, TitanKong.skillatk3_start)
      TitanKong_Mirror_skillatk3.finish = override(TitanKong_Mirror_skillatk3.finish, TitanKong.skillatk3_finish)
    end
  end
end

function TitanKong.TitanKong_Mirror_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 then
      hero:setDeathWithEffectOrNot(true)
      hero:die()
    end
  end
end

function TitanKong.changeBuffInfo(buffInfo, enhance, target, mode)
  local attrib_temp = {}
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
    end
  end
  if buffInfo.ID == 4664 then
    buffInfo.TEN = 10
  end
end

function TitanKong.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if hero:isAlive() and 0 < lost and lost >= hero.hp then
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info.Name == "TitanKong_Mirror" and unit.father == hero and unit:isAlive() and unit.TitanKong_resdmg then
        unit:takeDamage(lost, "Holy", "hp", source or hero)
        lost = 0
        unit.TitanKong_resdmg = false
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_impact_Sorceress_atk2.cha", hero.position, {1, 1}, nil, 1)
        end
        local bid = 4668
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = hero:addBuff(binfo, hero)
        break
      end
    end
  end
  return lost
end

function TitanKong.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
end

function TitanKong.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local buffID = 4661
  local binfo = ed.lookupDataTable("Buff", nil, buffID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  if caster.TitanKong_hasArcana and caster.TitanKong_hasArcana > 1 then
    local bid = 4667
    local binfo2 = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = caster:addBuff(binfo2, caster)
  end
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if caster.direction == 1 and (unit.position[1] > caster.position[1] + caster.direction * 375 or unit.position[1] < caster.position[1]) then
    elseif caster.direction == -1 and (unit.position[1] < caster.position[1] + caster.direction * 375 or unit.position[1] > caster.position[1]) then
    elseif unit:isAlive() then
      local buffID = 4661
      local binfo = ed.lookupDataTable("Buff", nil, buffID)
      local buff = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(buff, caster)
    end
  end
end

function TitanKong.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  local caster = skill.caster
  local bid = 4659
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanKong.skillatk3_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  local skillRemnant1 = caster.skills.TitanKong_Remnant1
  if skillRemnant1 then
    crit_mod = 999999
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  else
    crit_mod = 0
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function TitanKong.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4659 then
      tbuff.timer = 0
    end
  end
end

function TitanKong.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  local caster = skill.caster
  local bid = 4659
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.TitanKong_atk4_Buff = true
end

function TitanKong.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.TitanKong_skillatk4_casted = true
end

function TitanKong.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4659 then
      tbuff.timer = 0
    end
  end
  if caster.TitanKong_skillatk4_casted then
    local bid = 4663
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    if buff and caster.TitanKong_hasArcana and caster.TitanKong_hasArcana > 2 then
      buff:setAttribute("HPR", math.min(caster.attribs.HP * 0.08, 30000))
    end
    local bid2 = 4665
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = caster:addBuff(binfo2, caster)
    caster:setHpVisible(false)
    caster:setFuryVisible(false)
    caster.TitanKong_skillatk4_casted = false
    for _, ttbuff in ipairs(caster.buff_list) do
      if ttbuff.caster and ttbuff.caster.camp ~= caster.camp then
        ttbuff.timer = -1
      end
    end
  end
end

function TitanKong.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  caster.skillatk4_createProjectile = true
  projectile.hit = override(projectile.hit, TitanKong.skillatk4_projectile_hit)
  projectile.terminate = override(projectile.terminate, TitanKong.skillatk4_projectile_terminate)
  projectile.update = override(projectile.update, TitanKong.skillatk4_projectile_update)
  projectile.collideCheck = override(projectile.collideCheck, TitanKong.skillatk4_projectile_collideCheck)
  return projectile
end

function TitanKong.skillatk4_projectile_update(basefunc, projectile, dt)
  if (projectile.position[1] > 800 or projectile.position[1] < 0) and not projectile.terminated then
    projectile:terminate()
  end
  basefunc(projectile, dt)
end

function TitanKong.skillatk4_projectile_terminate(basefunc, projectile)
  local caster = projectile.skill.caster
  basefunc(projectile)
  local has_skillatk4_buff
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.TitanKong_skillatk4_buff then
      has_skillatk4_buff = true
    end
  end
  if not has_skillatk4_buff then
    local skillatk4b = caster.skills.TitanKong_atk4b
    local t_pos = projectile.position
    if caster:isAlive() and skillatk4b then
      caster:setPosition({
        t_pos[1] + 60 * caster.direction,
        t_pos[2]
      })
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 4665 then
          tbuff.timer = 0
        end
      end
      caster:setHpVisible(true)
      caster:setFuryVisible(true)
      if caster.current_skill then
        caster.current_skill:interrupt()
      end
      caster:castSkill(skillatk4b, nil)
    end
  end
end

function TitanKong.skillatk4_projectile_collideCheck(basefunc, self, unit)
  local t = basefunc(self, unit)
  local u_pos = unit.position
  local t_pos = self.position
  local skill = self.skill
  if u_pos and t_pos then
    if (u_pos[1] - t_pos[1]) ^ 2 <= 3600 and (u_pos[2] - t_pos[2]) ^ 2 <= 3600 then
      t = 0.5
    else
      return false
    end
  else
    return false
  end
  return t
end

function TitanKong.skillatk4_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  basefunc(projectile, target)
  caster.skillatk4_createProjectile = false
  projectile:terminate()
  if caster.TitanKong_hasArcana and caster.TitanKong_hasArcana > 2 then
    local bid = 4666
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
end

function TitanKong.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  owner.TitanKong_skillatk4_dmg = true
  owner.TitanKong_skillatk4_buff = true
  buff.update = override(buff.update, TitanKong.skillatk4_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, TitanKong.skillatk4_buffOnRemoved)
  return buff
end

function TitanKong.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4a = caster.skills.TitanKong_atk4a
  if buff.timer <= 0.5 and skillatk4a and owner.TitanKong_skillatk4_dmg then
    skillatk4a:takeEffectOn(owner, caster)
    owner.TitanKong_skillatk4_dmg = false
  end
end

function TitanKong.skillatk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4b = caster.skills.TitanKong_atk4b
  local owner_position = owner.position
  owner.TitanKong_skillatk4_buff = false
  if caster:isAlive() and skillatk4b then
    caster:setPosition({
      owner_position[1] + 60 * caster.direction,
      owner_position[2]
    })
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 4665 then
        tbuff.timer = 0
      end
    end
    caster:setHpVisible(true)
    caster:setFuryVisible(true)
    if caster.current_skill then
      caster.current_skill:interrupt()
    end
    caster:castSkill(skillatk4b, nil)
  end
end

function TitanKong.skillatk4b_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4663 then
      tbuff.timer = 0
    end
  end
end

function TitanKong.skillatk4b_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.TitanKong_atk4_Buff = false
end

function TitanKong.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.TitanKong_atk4_Buff then
    return false
  else
    return basefunc(skill, target)
  end
end

function TitanKong.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target and target:isAlive() then
    target:hurt()
  end
end

function TitanKong.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
end

function TitanKong.init_hero(hero)
  local skillult = hero.skills.TitanKong_ult
  local skillatk2 = hero.skills.TitanKong_atk2
  local skillatk3 = hero.skills.TitanKong_atk3
  local skillatk4 = hero.skills.TitanKong_atk4
  local skillatk4b = hero.skills.TitanKong_atk4b
  hero.TitanKong_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanKong.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanKong.skillatk2_onAttackFrame)
    if hero.TitanKong_hasArcana and hero.TitanKong_hasArcana > 1 then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanKong.skillatk2_takeEffectOn)
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanKong.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanKong.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, TitanKong.skillatk3_finish)
    skillatk3.getDamage = override(skillatk3.getDamage, TitanKong.skillatk3_getDamage)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanKong.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanKong.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanKong.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanKong.skillatk4_createBuff)
    skillatk4.createProjectile = override(skillatk4.createProjectile, TitanKong.skillatk4_createProjectile)
  end
  if skillatk4b then
    skillatk4b.onAttackFrame = override(skillatk4b.onAttackFrame, TitanKong.skillatk4b_onAttackFrame)
    skillatk4b.finish = override(skillatk4b.finish, TitanKong.skillatk4b_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanKong.skillult_start)
    skillult.finish = override(skillult.finish, TitanKong.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanKong.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanKong.skillult_canCastWithTarget)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanKong.hero_getLostHPAfterImmunity)
  end
  hero.reset = override(hero.reset, TitanKong.hero_reset)
  return hero
end

return TitanKong.init_hero
