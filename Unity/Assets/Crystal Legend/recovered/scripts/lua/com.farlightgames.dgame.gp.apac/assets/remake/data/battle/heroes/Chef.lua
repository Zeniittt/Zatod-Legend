module("ed.battlehero", package.seeall)
local ed = ed
Chef = {}
Chef.desk_eattime_count = 3
Chef.ult_perfecttime_min = 3.25
Chef.ult_perfecttime_max = 3.75
Chef.ult_ATK_base = 25
Chef.ult_MR_base = 4

function Chef.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Chef_desklist = {}
  hero.Cher_dirtydishes = 0
end

function Chef.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.Chef_desklist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Chef.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if (ed.engine:arenaMode() or ed.IsMultiArena() or not battle_tick.getRealTimePvp() and hero.camp == ed.emCampEnemy) and hero.current_skill == hero.skills.Chef_ult then
    local perfectrand = hero.stars * 0.2
    local rand = ed.rand()
    local skill = hero.skills.Chef_ult
    if skill and skill.current_phase_elapsed and skill.ultbegin then
      local ultcharge = skill.current_phase_elapsed - skill.ultbegin
      if perfectrand >= rand then
        if ultcharge <= Chef.ult_perfecttime_max and ultcharge >= Chef.ult_perfecttime_min then
          skill:trigger()
        end
      elseif rand >= perfectrand + (1 - perfectrand) / 2 then
        if ultcharge > Chef.ult_perfecttime_max then
          skill:trigger()
        end
      elseif rand < perfectrand + (1 - perfectrand) / 2 and ultcharge + 0.5 <= Chef.ult_perfecttime_max and ultcharge + 0.5 >= Chef.ult_perfecttime_min then
        skill:trigger()
      end
    end
  end
end

function Chef.skillenter_start(basefunc, skill, target)
  basefunc(skill)
  local owner = skill.caster
  local bid = 1020
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  owner.entered = true
end

function Chef.skillenter_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    local effect_moon = "eff_point_Chef_enter.cha"
    local casterorigin = skill.caster.position
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {1, 1}, nil, 0)
  end
end

function Chef.skillenter_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if caster.position[1] < ed.engine.stage_rect.minX + 100 or caster.position[1] > ed.engine.stage_rect.maxX - 100 then
    result = nil
  end
  return result
end

function Chef.skillult_canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1 and skill.current_phase_idx == 1
end

function Chef.skillult_onAttackFrame(basefunc, skill)
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 then
    if skill.attack_counter == 0 then
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
      end
      skill.caster.manually_casting = false
      skill.ultbegin = skill.current_phase_elapsed
      local caster = skill.caster
      local bid = 1045
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      skill.attack_counter = 1
    elseif skill.attack_counter == 1 then
      skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
      if skill.ultcharge > Chef.ult_perfecttime_max then
        skill.Chef_ult_fire = 3
      elseif skill.ultcharge <= Chef.ult_perfecttime_max and skill.ultcharge >= Chef.ult_perfecttime_min then
        skill.Chef_ult_fire = 2
      elseif skill.ultcharge < Chef.ult_perfecttime_min then
        skill.Chef_ult_fire = 1
      end
    end
  elseif skill.attack_counter == 1 then
    local dir = skill.caster:getInitDir()
    if skill.Chef_ult_fire == 2 then
      if ed.run_with_scene then
        local effect_moon = "eff_point_Chef_ult.cha"
        local casterorigin = {
          skill.caster.position[1] + (dir == -1 and 1 or 0) * 35,
          skill.caster.position[2]
        }
        ed.scene:playEffectOnScene(effect_moon, casterorigin, {1, 1}, nil, 0)
      end
      skill.attack_counter = 2
    elseif skill.Chef_ult_fire == 1 or skill.Chef_ult_fire == 3 then
      basefunc(skill)
    end
  elseif skill.attack_counter == 2 then
    basefunc(skill)
  end
end

function Chef.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skilllevel = skill.level
  if result and target and target:isAlive() then
    if skill.Chef_ult_fire == 1 then
      local bid = 1021
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("AD", Chef.ult_ATK_base * skilllevel)
      local buffresult = target:addBuff(buff, caster)
    elseif skill.Chef_ult_fire == 2 then
      local bid = 1022
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("AD", Chef.ult_ATK_base * skilllevel * 1.5)
      buff:setAttribute("MR", Chef.ult_MR_base * skilllevel * 1.5)
      local buffresult = target:addBuff(buff, caster)
      local bid2 = 1044
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = target:addBuff(binfo2, caster)
    elseif skill.Chef_ult_fire == 3 then
      local bid = 1023
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("MR", Chef.ult_MR_base * skilllevel)
      local buffresult = target:addBuff(buff, caster)
    end
  end
end

function Chef.skillult_trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function Chef.skillult_interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function Chef.skillult_onPhaseFinished(basefunc, skill)
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 then
    skill:startPhase(skill.Chef_ult_fire + 1)
  else
    skill:finish()
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 1045 then
        tbuff.timer = 0
      end
    end
  end
end

function Chef.eat_food(desk, owner)
  for i, tbuff in ipairs(desk.buff_list) do
    if tbuff.info.ID == 1006 + desk.desk_food_level then
      tbuff.timer = 0
      desk.desk_food_level = desk.desk_food_level - 1
    end
  end
  local bid = 1006 + desk.desk_food_level
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, desk, desk)
  buff:setAttribute("Effect", "eff_buff_Chef_deskfood_" .. desk.desk_food_type .. "_lv" .. desk.desk_food_level .. ".cha")
  local buffresult = desk:addBuff(buff, desk)
  local skillfood = desk.skills["Chefdesk_food" .. desk.desk_food_type]
  skillfood:takeEffectOn(owner, desk)
end

function Chef.selectPosition(hero, r)
  local caster = hero
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 25 do
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
      elseif unit.config.is_summoned then
      elseif unit.name == "Chef" then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  else
    return false
  end
end

function Chef.desk_update(basefunc, desk, dt)
  basefunc(desk, dt)
  local hero = desk.config.summoner
  desk.desk_dietime = desk.desk_dietime - dt
  if desk.desk_dietime <= 0 then
    desk:die()
  end
  if not desk.desk_notmove then
    if 0 >= desk.startmove_time then
      if 0 <= desk.desk_move_time then
        desk.walk_v = {
          desk.desk_velocity[1],
          desk.desk_velocity[2]
        }
        desk.desk_move_time = desk.desk_move_time - dt
      else
        desk.walk_v = {0, 0}
        desk.desk_notmove = true
        desk:enterActionStageFromOneStage(2, 233)
        local desk_skillatk2 = desk.skills.Chefdesk_atk2
        desk_skillatk2.target = desk
        desk:castSkill(desk_skillatk2, desk)
      end
    else
      desk.startmove_time = desk.startmove_time - dt
    end
  end
  if desk:isAlive() and 1 >= desk.desk_food_level then
    if 0 >= desk.desk_dietimebefore then
      desk:die()
      local n = 2
      for i = 1, n do
        if hero.Cher_dirtydishes <= 7 then
          local bid = 1026 + hero.Cher_dirtydishes
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, hero, desk)
          local buffresult = hero:addBuff(buff, desk)
          hero.Cher_dirtydishes = hero.Cher_dirtydishes + 1
        end
      end
    else
      desk.desk_dietimebefore = desk.desk_dietimebefore - dt
    end
  end
end

function Chef.desk_die(basefunc, unit)
  basefunc(unit)
  if unit.region then
    unit.region:terminate()
  end
end

function Chef.desk_skillatk2_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local desk = buff.caster
  if buff.desk_eattime_count then
    buff.desk_eattime_count = buff.desk_eattime_count - dt
  else
    buff.desk_eattime_count = Chef.desk_eattime_count
  end
  if buff.desk_eattime_count <= 0 and desk.desk_food_level > 1 then
    local owner = buff.owner
    Chef.eat_food(desk, owner)
    buff.desk_eattime_count = 3
  end
end

function Chef.desk_skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Chef.desk_skillatk2_buff_update)
  return buff
end

function Chef.desk_skillatk2_start(basefunc, skill, target)
  basefunc(skill)
  local desk = skill.caster
  local bid = 1010
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, desk, desk)
  buff:setAttribute("Effect", "eff_buff_Chef_deskfood_" .. desk.desk_food_type .. "_lv4.cha")
  local buffresult = desk:addBuff(buff, desk)
end

function Chef.desk_skillatk2_onAttackFrame(basefunc, self)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  local info = self.info
  local caster = self.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = self:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = self:createChain()
    ed.engine:addChain(chain)
  elseif ttype == "region" then
    local region = self:createRegion()
    ed.engine:addRegion(region)
    caster.region = region
  elseif ttype == nil then
    self:takeEffectAt(self.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Chef.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.Chef_atk2
  local dir = caster:getInitDir()
  local skillevel = {
    skillatk2.level,
    skillatk2.level,
    skillatk2.level,
    skillatk2.level,
    skillatk2.level
  }
  local proto = {
    _tid = 233,
    _level = skillatk2.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local desk = ed.UnitCreate(proto, caster.camp, config)
  local food_type = math.floor(ed.rand() * 2) + 1
  desk.die = override(desk.die, Chef.desk_die)
  desk.update = override(desk.update, Chef.desk_update)
  desk.direction = caster.direction
  desk.desk_dietimebefore = 0.5
  desk.startmove_time = -5
  desk.desk_dietime = 18
  desk.desk_food_level = 4
  desk.desk_food_type = food_type
  local x = Chef.selectPosition(desk, 50)
  x = x or 400 - 100 * dir
  desk.desk_dest = {
    x,
    caster.position[2] + ed.rand() * 20 - 10
  }
  local bid = 1024
  local binfo1024 = ed.lookupDataTable("Buff", nil, bid)
  local buff = desk:addBuff(binfo1024, desk)
  local pos_rand = ed.rand() * 2 - 1
  local desk_position = {
    caster.position[1] + 25,
    caster.position[2] - 25
  }
  ed.engine:summonUnit(desk, desk_position, caster)
  local desk_skillatk2 = desk.skills.Chefdesk_atk2
  desk_skillatk2.createBuff = override(desk_skillatk2.createBuff, Chef.desk_skillatk2_createBuff)
  desk_skillatk2.start = override(desk_skillatk2.start, Chef.desk_skillatk2_start)
  desk_skillatk2.onAttackFrame = override(desk_skillatk2.onAttackFrame, Chef.desk_skillatk2_onAttackFrame)
  desk_skillatk2.target = desk
  local distance = ed.edpSub(desk.desk_dest, desk_position)
  local desk_v = 400
  desk.desk_move_time = math.sqrt(distance[1] * distance[1] + distance[2] * distance[2]) / desk_v
  desk.desk_velocity = ed.edpMult(distance, 1 / desk.desk_move_time)
  table.insert(caster.Chef_desklist, desk)
end

function Chef.skillatk3_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local dir = caster:getInitDir()
  local target_type = skill.info["Target Type"]
  local selector = skill:target_selector()
  local Ignore = skill:Ignore_Target_Type()
  if default then
    skill.target = default
  else
    local t, distanceSQ = skill.caster.ai:searchTarget()
    if distanceSQ <= skill.max_range_sq and (dir == 1 and t.position[1] > caster.position[1] or dir == -1 and t.position[1] < caster.position[1]) then
      skill.target = t
    else
      skill.target = nil
    end
  end
  return skill.target
end

function Chef.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if result and caster.Cher_dirtydishes > 0 then
    result = nil
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit.position[1] > caster.position[1] then
        result = true
      end
    end
  end
  return result
end

function Chef.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1026 or tbuff.info.ID == 1027 or tbuff.info.ID == 1028 or tbuff.info.ID == 1029 or tbuff.info.ID == 1030 or tbuff.info.ID == 1031 or tbuff.info.ID == 1032 or tbuff.info.ID == 1033 then
      tbuff.timer = 0
    end
  end
end

function Chef.skillatk3_Projectile_hit(basefunc, projectile, target)
  if projectile.randhit > 0 then
    basefunc(projectile, target)
    projectile.randhit = projectile.randhit - 1
  else
    projectile:terminate()
  end
end

function Chef.skillatk3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local count0 = 1 + math.floor((caster.Cher_dirtydishes - 1) / 3)
  local count1 = 1 + math.floor((caster.Cher_dirtydishes - 2) / 3)
  local count2 = 1 + math.floor((caster.Cher_dirtydishes - 3) / 3)
  local origtarget = skill.target
  local attack_counter = skill.attack_counter
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, Chef.skillatk3_Projectile_hit)
  if attack_counter == 1 then
    for i = 1, count0 do
      local rand_angle = ed.rand() * 12 - 6
      local v = 1000
      projectile.velocity[1] = math.cos(math.rad(rand_angle)) * v
      projectile.velocity[2] = math.sin(math.rad(rand_angle)) * v
      projectile.zSpeed = 0
      local randhit = math.floor(ed.rand() * 5) + 1
      projectile.randhit = randhit
      ed.engine:addProjectile(projectile)
    end
  end
  if attack_counter == 2 then
    for i = 1, count1 do
      local rand_angle = ed.rand() * 12 - 6
      local v = 1000
      projectile.velocity[1] = math.cos(math.rad(rand_angle)) * v
      projectile.velocity[2] = math.sin(math.rad(rand_angle)) * v
      projectile.zSpeed = 0
      local randhit = math.floor(ed.rand() * 5) + 1
      projectile.randhit = randhit
      ed.engine:addProjectile(projectile)
    end
  end
  if attack_counter == 3 then
    for i = 1, count2 do
      local rand_angle = ed.rand() * 12 - 6
      local v = 1000
      projectile.velocity[1] = math.cos(math.rad(rand_angle)) * v
      projectile.velocity[2] = math.sin(math.rad(rand_angle)) * v
      projectile.zSpeed = 0
      local randhit = math.floor(ed.rand() * 5) + 1
      projectile.randhit = randhit
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end

function Chef.skillatk4_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if not caster.entered then
    result = nil
  end
  return result
end

function Chef.skillatk4_onAttackFrame(basefunc, skill)
  local rand = math.floor(ed.rand()) * 3 + 1
  local originfo = skill.info
  local skillatk4s = skill.caster.skills.Chef_atk4s
  local caster = skill.caster
  local info = skill.info
  caster.Chef_atk4_target = skill:selectTarget()
  if caster.Chef_atk4_target and caster.Chef_atk4_target.camp ~= caster.camp then
    skillatk4s:createProjectile()
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  else
    basefunc(skill)
  end
end

function Chef.skillatk4_projectile_collideCheck(basefunc, projectile, unit)
  local result = basefunc(projectile, unit)
  if unit == projectile.caster then
    result = 0.1
  end
  return result
end

function Chef.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.collideCheck = override(projectile.collideCheck, Chef.skillatk4_projectile_collideCheck)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target = skill.caster.Chef_atk4_target
  if target then
    local target_position = {
      target.position[1],
      target.position[2]
    }
    local distance = ed.edpSub(target_position, skill.caster.position)
    projectile.velocity = ed.edpMult(distance, 1 / t)
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function Chef.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local dir = skill.caster:getInitDir()
  local caster = skill.caster
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target = skill:selectTarget()
  if target then
    local target_position = {
      target.position[1],
      target.position[2]
    }
    local launchposition, h = skill:launchPoint()
    local distance = ed.edpSub(target_position, {
      launchposition[1],
      launchposition[2]
    })
    projectile.velocity = ed.edpMult(distance, 1 / t)
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function Chef.skillawake_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local result2
  local caster = skill.caster
  local dir = caster:getInitDir()
  if result then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local distanceSQ = ed.edpDistanceSQ(unit.position, caster.position)
      if not unit.config.is_summoned and distanceSQ <= 30625 then
        caster.Chef_awake_dir = dir
        result2 = true
      end
    end
  end
  return result2
end

function Chef.skillawake_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  if caster.Chef_awake_dir == 1 then
    skill:startPhase(1)
  else
    skill:startPhase(2)
  end
  skill.is_update = true
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function Chef.skillawake_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Chef.skillatk_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  if caster.position[1] <= target.position[1] then
    skill:startPhase(1)
  else
    skill:startPhase(2)
  end
  skill.is_update = true
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function Chef.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Chef.init_hero(hero)
  local skillult = hero.skills.Chef_ult
  local skillatks = hero.skills.Chef_atks
  local skillatk2 = hero.skills.Chef_atk2
  local skillatk3 = hero.skills.Chef_atk3
  local skillatk4 = hero.skills.Chef_atk4
  local skillatk4s = hero.skills.Chef_atk4s
  local skillawake = hero.skills.Chef_awake
  local skillenter = hero.skills.Chef_enter
  if skillatks then
    skillatks.start = override(skillatks.start, Chef.skillatk_start)
    skillatks.onPhaseFinished = override(skillatks.onPhaseFinished, Chef.skillatk_onPhaseFinished)
    skillatks.canCastWithTarget = override(skillatks.canCastWithTarget, Chef.skillatk4_canCastWithTarget)
    skillatks.createProjectile = override(skillatks.createProjectile, Chef.skillatk_createProjectile)
  end
  if skillult then
    skillult.info["No Speeder"] = true
    skillult.canTrigger = override(skillult.canTrigger, Chef.skillult_canTrigger)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Chef.skillult_onAttackFrame)
    skillult.trigger = override(skillult.trigger, Chef.skillult_trigger)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, Chef.skillult_onPhaseFinished)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Chef.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Chef.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Chef.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, Chef.skillatk3_start)
    skillatk3.createProjectile = override(skillatk3.createProjectile, Chef.skillatk3_createProjectile)
    skillatk3.selectTarget = override(skillatk3.selectTarget, Chef.skillatk3_selectTarget)
    skillatk3.info["No Dodge"] = true
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Chef.skillatk4_onAttackFrame)
    skillatk4.createProjectile = override(skillatk4.createProjectile, Chef.skillatk4_createProjectile)
    skillatk4s.createProjectile = override(skillatk4s.createProjectile, Chef.skillatk4_createProjectile)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, Chef.skillatk4_canCastWithTarget)
  end
  if skillenter then
    skillenter.start = override(skillenter.start, Chef.skillenter_start)
    skillenter.canCastWithTarget = override(skillenter.canCastWithTarget, Chef.skillenter_canCastWithTarget)
    skillenter.onAttackFrame = override(skillenter.onAttackFrame, Chef.skillenter_onAttackFrame)
  end
  if skillawake then
    skillawake.start = override(skillawake.start, Chef.skillawake_start)
    skillawake.canCastWithTarget = override(skillawake.canCastWithTarget, Chef.skillawake_canCastWithTarget)
    skillawake.onPhaseFinished = override(skillawake.onPhaseFinished, Chef.skillawake_onPhaseFinished)
  end
  hero.reset = override(hero.reset, Chef.hero_reset)
  hero.die = override(hero.die, Chef.hero_die)
  hero.update = override(hero.update, Chef.hero_update)
  return hero
end

return Chef.init_hero
