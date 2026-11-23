module("ed.battlehero", package.seeall)
local ed = ed
TitanDOC = {}

function TitanDOC.hero_reset(basefunc, hero)
  basefunc(hero)
end

function TitanDOC.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
end

function TitanDOC.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  local caster = skill.caster
  local bid = 4739
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanDOC.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4739 then
      tbuff.timer = 0
    end
  end
end

function TitanDOC.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.info["Ignore Shield"] = true
  local caster = skill.caster
  local bid = 4739
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanDOC.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4739 then
      tbuff.timer = 0
    end
  end
end

function TitanDOC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.update = override(buff.update, TitanDOC.skillatk2buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanDOC.skillatk2buff_onRemoved)
  return buff
end

function TitanDOC.skillatk2buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local current_skill_id = owner.current_skill and owner.current_skill.info["Skill Group ID"]
  if owner.current_skill and current_skill_id ~= owner.info["Basic Skill"] and not owner.manually_casting then
    local owner_need_interrupt = TitanDOC.need_interrupt(owner.current_skill)
    if owner_need_interrupt then
      owner:removeBuff(buff)
    end
  end
end

function TitanDOC.skillatk2buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2s = caster.skills.TitanDOC_atk2s
  if skillatk2s then
    skillatk2s:takeEffectAt(owner.position, caster)
    owner:hurt()
  end
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanDOC_atk2.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
    ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
  end
end

function TitanDOC.need_interrupt(skill)
  local current_phase_idx = skill and skill.current_phase_idx
  local max_phase_idx = skill and #skill.phase_list
  local max_event_idx = current_phase_idx and skill.current_phase and type(skill.current_phase.event_list) == "table" and #skill.current_phase.event_list
  local next_event_idx = current_phase_idx and skill.next_event_idx
  local need
  if skill and current_phase_idx and max_phase_idx and max_event_idx and next_event_idx then
    if current_phase_idx < max_phase_idx then
      need = true
    elseif current_phase_idx == max_phase_idx and max_event_idx >= next_event_idx then
      need = true
    end
  end
  return need
end

function TitanDOC.skillatk2s_takeEffectOn(basefunc, skill, target, source, shift)
  local hit, dmg, Crit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target and dmg and 0 < dmg then
    local binfo = ed.lookupDataTable("Buff", nil, 4745)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("fearrange", 5)
    target:addBuff(buff, caster)
  end
  return hit, dmg, Crit
end

function TitanDOC.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = buff.timer * 1.25
  return buff
end

function TitanDOC.skill_takeEffectOn(basefunc, skill, target, source)
  local is_hit = basefunc(skill, target, source)
  local skillatk4 = skill.caster.skills.TitanDOC_atk4
  if skillatk4 and is_hit then
    target:addBuff(skillatk4:createBuff(target))
  end
end

function TitanDOC.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.onRemoved = override(buff.onRemoved, TitanDOC.skillatk4buff_onRemoved)
  return buff
end

function TitanDOC.skillatk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4s = caster.skills.TitanDOC_atk4s
  if skillatk4s then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanDOC_atk2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, owner.position, {0.8, 0.8}, nil, 1)
    end
    skillatk4s:takeEffectOn(owner, caster)
  end
end

function TitanDOC.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4739
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanDOC.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4739 then
      tbuff.timer = 0
    end
  end
end

function TitanDOC.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local d = {0, 0}
  projectile.TitanDOC_targetPosition = TitanDOC.DOP_in_battlefield(caster, 200, caster.foecamp)
  projectile.position, projectile.height = skill:launchPoint()
  projectile.TitanDOC_targetPosition[1] = projectile.TitanDOC_targetPosition[1] - caster.direction * 50
  if projectile.TitanDOC_targetPosition then
    d = {
      projectile.TitanDOC_targetPosition[1] - projectile.position[1],
      projectile.TitanDOC_targetPosition[2] - projectile.position[2]
    }
    local s = ((projectile.TitanDOC_targetPosition[1] - projectile.position[1]) ^ 2 + (projectile.TitanDOC_targetPosition[2] - projectile.position[2]) ^ 2) ^ 0.5
    local t = s / skill.info["Tile XY Speed"]
    projectile.zSpeed = (projectile.TitanDOC_targetPosition[2] - projectile.height - 0.5 * skill.info["Tile Gravity"] * t ^ 2) / t
    projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
    projectile.max_distance = math.abs(projectile.position[1] - projectile.TitanDOC_targetPosition[1])
    projectile.camp = caster.camp
    projectile.can_be_influenced = false
    projectile.update = override(projectile.update, TitanDOC.ult_projectile_update)
    projectile.terminate = override(projectile.terminate, TitanDOC.ult_projectile_terminate)
    ed.engine:addProjectile(projectile)
  end
end

function TitanDOC.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unit.config.is_summoned then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    position = {400, 0}
    return position
  end
end

function TitanDOC.ult_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 15 and not projectile.terminated then
    projectile:terminate()
  end
end

function TitanDOC.ult_projectile_terminate(basefunc, self)
  local caster = self.caster
  local skillult = caster.skills.TitanDOC_ult
  local skilllevel = {
    skillult.level
  }
  local proto = {
    _tid = 330,
    _level = skillult.level or 1,
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
  local TitanDOCbaby = ed.UnitCreate(proto, caster.camp, config)
  TitanDOCbaby.direction = caster.direction
  local locationTitanDOCbaby = {
    self.position[1],
    self.position[2]
  }
  ed.engine:summonUnit(TitanDOCbaby, locationTitanDOCbaby, caster, "Birth")
  TitanDOCbaby.father = caster
  TitanDOCbaby.alive_time = 12
  TitanDOCbaby.atk_buff_time = skillult.info["Script Arg4"]
  TitanDOCbaby.update = override(TitanDOCbaby.update, TitanDOC.TitanDOCbaby_update)
  if caster.TitanDOC_hasArcana and caster.TitanDOC_hasArcana > 3 then
    TitanDOCbaby.getLostHPAfterImmunity = override(TitanDOCbaby.getLostHPAfterImmunity, TitanDOC.TitanDOCbaby_getLostHPAfterImmunity)
  end
  local AttriBinfo = ed.lookupDataTable("Buff", nil, 4747)
  local Attri_x = skillult.info["Script Arg3"]
  TitanDOC.changeBuffInfo(AttriBinfo, Attri_x, TitanDOCbaby, 1)
  local buff = TitanDOCbaby:addBuff(AttriBinfo, caster)
  TitanDOCbaby:takeHeal(math.min(TitanDOCbaby.attribs.HP, 1000000))
  local uncontrol_buff = ed.lookupDataTable("Buff", nil, 4744)
  local buff2 = TitanDOCbaby:addBuff(uncontrol_buff, caster)
  local TitanDOCbaby_skillatk = TitanDOCbaby.skills.TitanDOCbaby_atk
  if TitanDOCbaby_skillatk then
    TitanDOCbaby_skillatk.createBuff = override(TitanDOCbaby_skillatk.createBuff, TitanDOC.TitanDOCbaby_skillatk_createBuff)
    TitanDOCbaby_skillatk:takeEffectAt(locationTitanDOCbaby, TitanDOCbaby)
  end
  basefunc(self)
end

function TitanDOC.TitanDOCbaby_skillatk_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.atk_buff_time then
    if target.attribs.TEN then
      buff.timer = caster.atk_buff_time * (1 - target.attribs.TEN / 100)
    else
      buff.timer = caster.atk_buff_time
    end
  end
  return buff
end

function TitanDOC.changeBuffInfo(buffInfo, enhance, target, mode)
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
  if buffInfo.ID == 4747 then
    buffInfo.TEN = 10
  end
end

function TitanDOC.TitanDOCbaby_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.alive_time then
    hero.alive_time = hero.alive_time - dt
    if hero.alive_time <= 0 then
      hero:die()
    end
  end
end

function TitanDOC.TitanDOCbaby_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill)
  local caster = hero.father
  if caster and caster:isAlive() and 0 < lost then
    caster:takeHeal(30, "mp", caster)
  end
  return lost
end

function TitanDOC.skillatk2s_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.2
  return power
end

function TitanDOC.init_hero(hero)
  local skillult = hero.skills.TitanDOC_ult
  local skillatk = hero.skills.TitanDOC_atk
  local skillatk2 = hero.skills.TitanDOC_atk2
  local skillatk3 = hero.skills.TitanDOC_atk3
  local skillatk4 = hero.skills.TitanDOC_atk4
  local skillatk2s = hero.skills.TitanDOC_atk2s
  hero.TitanDOC_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanDOC.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, TitanDOC.skillatk2_finish)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanDOC.skillatk2_createBuff)
  end
  if hero.TitanDOC_hasArcana and hero.TitanDOC_hasArcana > 2 then
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, TitanDOC.skillatk2s_takeEffectOn)
    skillatk2s.power = override(skillatk2s.power, TitanDOC.skillatk2s_power)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanDOC.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, TitanDOC.skillatk3_finish)
    if hero.TitanDOC_hasArcana and hero.TitanDOC_hasArcana > 1 then
      skillatk3.createBuff = override(skillatk3.createBuff, TitanDOC.skillatk3_createBuff)
    end
  end
  if skillatk and skillatk4 then
    skillatk.start = override(skillatk.start, TitanDOC.skillatk_start)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanDOC.skill_takeEffectOn)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanDOC.skillatk4_createBuff)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanDOC.skillult_start)
    skillult.finish = override(skillult.finish, TitanDOC.skillult_finish)
    skillult.createProjectile = override(skillult.createProjectile, TitanDOC.skillult_createProjectile)
  end
  hero.reset = override(hero.reset, TitanDOC.hero_reset)
  return hero
end

return TitanDOC.init_hero
