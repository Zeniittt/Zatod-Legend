module("ed.battlehero", package.seeall)
local ed = ed
ExTitanKong = {}

function ExTitanKong.hero_reset(basefunc, hero)
  basefunc(hero)
end

function ExTitanKong.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 152 then
      hero.uncontroll = true
    else
      hero.uncontroll = false
    end
  end
  if hero.uncontroll == false then
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = hero:addBuff(binfo, hero)
  end
end

function ExTitanKong.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4659
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function ExTitanKong.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4659 then
      tbuff.timer = 0
    end
  end
end

function ExTitanKong.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skilllevel = {
    skill.level,
    skill.level
  }
  local skillRemnant2 = caster.skills.ExTitanKong_Remnant2
  local ExTitanKong_summontCount = 1
  if skillRemnant2 then
    ExTitanKong_summontCount = ExTitanKong_summontCount + 1
  end
  if caster.ExTitanKong_hasArcana and caster.ExTitanKong_hasArcana > 3 then
    ExTitanKong_summontCount = ExTitanKong_summontCount + 1
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
  for n = 1, ExTitanKong_summontCount do
    local ExTitanKong_Mirror = ed.UnitCreate(proto, caster.camp, config)
    ExTitanKong_Mirror.direction = caster.direction
    local locationExTitanKong_Mirror = {
      caster.position[1] + caster.direction * 100 + ed.rand() * 50,
      caster.position[2] - 50 + ed.rand() * 100
    }
    ed.engine:summonUnit(ExTitanKong_Mirror, locationExTitanKong_Mirror, caster, "Birth")
    ExTitanKong_Mirror.father = caster
    ExTitanKong_Mirror.die = override(ExTitanKong_Mirror.die, function(basefunc, unit, killer)
      unit:setDeathWithEffectOrNot(true)
      basefunc(unit, killer)
    end)
    ExTitanKong_Mirror.alive_time = skill.info["Script Arg2"]
    ExTitanKong_Mirror.ExTitanKong_resdmg = true
    ExTitanKong_Mirror.update = override(ExTitanKong_Mirror.update, ExTitanKong.ExTitanKong_Mirror_update)
    local AttriBinfo = ed.lookupDataTable("Buff", nil, 4664)
    local Attri_x = caster.ExTitanKong_hasArcana and caster.ExTitanKong_hasArcana > 3 and skill.info["Script Arg4"] * 0.8 or skill.info["Script Arg4"]
    ExTitanKong.changeBuffInfo(AttriBinfo, Attri_x, ExTitanKong_Mirror, 1)
    local buff = ExTitanKong_Mirror:addBuff(AttriBinfo, caster)
    ExTitanKong_Mirror:takeHeal(math.min(ExTitanKong_Mirror.attribs.HP, 1000000))
    local ExTitanKong_Mirror_skillatk3 = ExTitanKong_Mirror.skills.ExTitanKong_Mirror_atk3
    if ExTitanKong_Mirror_skillatk3 and skillatk3_cd then
      skillatk3_cd = skillatk3_cd + 2
      ExTitanKong_Mirror_skillatk3.cd_remaining = skillatk3_cd
      ExTitanKong_Mirror_skillatk3.start = override(ExTitanKong_Mirror_skillatk3.start, ExTitanKong.skillatk3_start)
      ExTitanKong_Mirror_skillatk3.finish = override(ExTitanKong_Mirror_skillatk3.finish, ExTitanKong.skillatk3_finish)
    end
  end
end

function ExTitanKong.ExTitanKong_Mirror_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 then
      hero:setDeathWithEffectOrNot(true)
      hero:die()
    end
  end
  if hero.config.summoner and not hero.config.summoner:isAlive() then
    hero:setDeathWithEffectOrNot(true)
    hero:die()
  end
end

function ExTitanKong.changeBuffInfo(buffInfo, enhance, target, mode)
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

function ExTitanKong.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  if hero:isAlive() and 0 < lost and lost >= hero.hp then
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info.Name == "TitanKong_Mirror" and unit.father == hero and unit:isAlive() and unit.ExTitanKong_resdmg then
        unit:takeDamage(lost, "Holy", "hp", source or hero)
        lost = 0
        unit.ExTitanKong_resdmg = false
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

function ExTitanKong.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
end

function ExTitanKong.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local buffID = 4661
  local binfo = ed.lookupDataTable("Buff", nil, buffID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  if caster.ExTitanKong_hasArcana and caster.ExTitanKong_hasArcana > 1 then
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

function ExTitanKong.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
end

function ExTitanKong.skillatk3_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  local skillRemnant1 = caster.skills.ExTitanKong_Remnant1
  if skillRemnant1 then
    crit_mod = 99999
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  else
    crit_mod = 0
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function ExTitanKong.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4659 then
      tbuff.timer = 0
    end
  end
end

function ExTitanKong.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  local caster = skill.caster
  caster.ExTitanKong_atk4_Buff = true
end

function ExTitanKong.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.ExTitanKong_skillatk4_casted = true
end

function ExTitanKong.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4659 then
      tbuff.timer = 0
    end
  end
  if caster.ExTitanKong_skillatk4_casted then
    local bid = 4663
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    if buff and caster.ExTitanKong_hasArcana and caster.ExTitanKong_hasArcana > 2 then
      buff:setAttribute("HPR", math.min(caster.attribs.HP * 0.08, 30000))
    end
    local bid2 = 4665
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = caster:addBuff(binfo2, caster)
    caster:setHpVisible(false)
    caster:setFuryVisible(false)
    caster.ExTitanKong_skillatk4_casted = false
    for _, ttbuff in ipairs(caster.buff_list) do
      if ttbuff.caster and ttbuff.caster.camp ~= caster.camp then
        ttbuff.timer = -1
      end
    end
    local percent = 0.1
    if caster.level <= 35 then
      percent = 0.2
    elseif caster.level <= 45 then
      percent = 0.25
    elseif caster.level <= 55 then
      percent = 0.3
    elseif caster.level <= 65 then
      percent = 0.35
    elseif caster.level <= 75 then
      percent = 0.4
    elseif caster.level <= 85 then
      percent = 0.45
    elseif caster.level > 90 then
      percent = 0.5
    end
    caster:takeHeal(caster.attribs.HP * percent, "hp", caster)
  end
end

function ExTitanKong.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  caster.skillatk4_createProjectile = true
  projectile.hit = override(projectile.hit, ExTitanKong.skillatk4_projectile_hit)
  projectile.terminate = override(projectile.terminate, ExTitanKong.skillatk4_projectile_terminate)
  projectile.update = override(projectile.update, ExTitanKong.skillatk4_projectile_update)
  projectile.collideCheck = override(projectile.collideCheck, ExTitanKong.skillatk4_projectile_collideCheck)
  return projectile
end

function ExTitanKong.skillatk4_projectile_update(basefunc, projectile, dt)
  if (projectile.position[1] > 800 or projectile.position[1] < 0) and not projectile.terminated then
    projectile:terminate()
  end
  basefunc(projectile, dt)
end

function ExTitanKong.skillatk4_projectile_terminate(basefunc, projectile)
  local caster = projectile.skill.caster
  basefunc(projectile)
  local has_skillatk4_buff
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.ExTitanKong_skillatk4_buff then
      has_skillatk4_buff = true
    end
  end
  if not has_skillatk4_buff then
    local skillatk4b = caster.skills.ExTitanKong_atk4b
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

function ExTitanKong.skillatk4_projectile_collideCheck(basefunc, self, unit)
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

function ExTitanKong.skillatk4_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  basefunc(projectile, target)
  caster.skillatk4_createProjectile = false
  projectile:terminate()
  if caster.ExTitanKong_hasArcana and caster.ExTitanKong_hasArcana > 2 then
    local bid = 4666
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
end

function ExTitanKong.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  owner.ExTitanKong_skillatk4_dmg = true
  owner.ExTitanKong_skillatk4_buff = true
  buff.update = override(buff.update, ExTitanKong.skillatk4_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, ExTitanKong.skillatk4_buffOnRemoved)
  return buff
end

function ExTitanKong.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4a = caster.skills.ExTitanKong_atk4a
  if buff.timer <= 0.5 and skillatk4a and owner.ExTitanKong_skillatk4_dmg then
    skillatk4a:takeEffectOn(owner, caster)
    owner.ExTitanKong_skillatk4_dmg = false
  end
end

function ExTitanKong.skillatk4_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4b = caster.skills.ExTitanKong_atk4b
  local owner_position = owner.position
  owner.ExTitanKong_skillatk4_buff = false
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

function ExTitanKong.skillatk4b_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4663 then
      tbuff.timer = 0
    end
  end
end

function ExTitanKong.skillatk4b_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.ExTitanKong_atk4_Buff = false
end

function ExTitanKong.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.ExTitanKong_atk4_Buff then
    return false
  else
    return basefunc(skill, target)
  end
end

function ExTitanKong.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target and target:isAlive() then
    target:hurt()
  end
end

function ExTitanKong.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
end

function ExTitanKong.init_hero(hero)
  local skillult = hero.skills.ExTitanKong_ult
  local skillatk2 = hero.skills.ExTitanKong_atk2
  local skillatk3 = hero.skills.ExTitanKong_atk3
  local skillatk4 = hero.skills.ExTitanKong_atk4
  local skillatk4b = hero.skills.ExTitanKong_atk4b
  hero.ExTitanKong_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, ExTitanKong.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, ExTitanKong.skillatk2_onAttackFrame)
    if hero.ExTitanKong_hasArcana and hero.ExTitanKong_hasArcana > 1 then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, ExTitanKong.skillatk2_takeEffectOn)
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, ExTitanKong.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, ExTitanKong.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, ExTitanKong.skillatk3_finish)
    skillatk3.getDamage = override(skillatk3.getDamage, ExTitanKong.skillatk3_getDamage)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, ExTitanKong.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, ExTitanKong.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, ExTitanKong.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, ExTitanKong.skillatk4_createBuff)
    skillatk4.createProjectile = override(skillatk4.createProjectile, ExTitanKong.skillatk4_createProjectile)
  end
  if skillatk4b then
    skillatk4b.onAttackFrame = override(skillatk4b.onAttackFrame, ExTitanKong.skillatk4b_onAttackFrame)
    skillatk4b.finish = override(skillatk4b.finish, ExTitanKong.skillatk4b_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, ExTitanKong.skillult_start)
    skillult.finish = override(skillult.finish, ExTitanKong.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ExTitanKong.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ExTitanKong.skillult_canCastWithTarget)
  end
  hero.reset = override(hero.reset, ExTitanKong.hero_reset)
  hero.update = override(hero.update, ExTitanKong.hero_update)
  return hero
end

return ExTitanKong.init_hero
