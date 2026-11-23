module("ed.battlehero", package.seeall)
local ed = ed
Roshan = {}
Roshan.Roshan_atk4_hpratio = 0.5
Roshan.Roshan_bg_time = 240
Roshan.BoomStone_livetime = 15
Roshan.BoomStone_power_min = 0.3
Roshan.BoomStone_power_ratio_hell = 1.5
Roshan.Roshan_atk2_ratio_hell = 1.5
Roshan.Roshan_atk3_ratio = 0.3
Roshan.Roshan_atk4_addADratio = 0.4
Roshan.Roshan_atk4_addARMratio = 0.2
Roshan.Roshan_atk4_addMRratio = 0.2
Roshan.Roshan_atk4_HPratio = 0.5

function Roshan.testPointInShape(p, shape, arg1, arg2)
  if shape == "rectangle" then
    return p[1] >= 0 and arg1 >= p[1] and p[2] >= -arg2 * 0.5 and p[2] <= arg2 * 0.5
  elseif shape == "circle" then
    return p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  elseif shape == "halfcircle" then
    return p[1] >= 0 and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  elseif shape == "quartercircle" then
    return p[1] >= 0 and p[2] <= p[1] and p[2] >= -p[1] and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  else
    EDDebug("Unkonwn AOE Type: '" .. shape .. "', spelling mistake?")
  end
end

function Roshan.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Roshan_BoomStonelist = {}
  hero.ori_foecamp = hero.foecamp
  hero.Roshan_atk2s_position = {
    {100, -5},
    {-100, -5}
  }
  hero.Roshan_atk3_shield = hero.attribs.HP * Roshan.Roshan_atk3_ratio
  hero.firstinbattle = nil
  hero.skillawake_casted = false
  if ed.protoSuperAwake(hero.proto, 10051) then
    hero:enterActionStageFromOneStage(5, 10051)
  elseif ed.protoAwake(hero.proto, 10051) then
    hero:enterActionStageFromOneStage(3, 10051)
  else
    hero:enterActionStageFromOneStage(1, 10051)
  end
  local skillenter = hero.skills.Roshan_enter
  if skillenter and hero.name == "Roshan" then
    local bid = 1263
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
    if ed.engine.stage_info["Stage ID"] ~= 70000 then
      hero:setPosition({
        400 - 100 * hero:getInitDir(),
        0
      })
    end
  end
end

function Roshan.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  local skillatk4 = hero.skills.Roshan_atk4
  if skillatk4 and hero.killer and hero.killer:isHero() and hero.killer.camp ~= hero.camp and hero.killer:isAlive() and hero.killer.name ~= "Roshan" and not hero.killer.config.is_boss and not ed.engine.guildInstance_mode and not hero.config.is_summoned and not hero.CHEN_ult1time and hero.name == "Roshan" then
    hero.killer:addBuff(skillatk4:createBuff(hero.killer))
  end
  for i, unit in ipairs(hero.Roshan_BoomStonelist) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  local sawake = hero.skills.Roshan_sawake
  if ed.protoSuperAwake(hero.proto, 10051) and sawake and killer and killer:isHero() and killer.camp ~= hero.camp and killer:isAlive() and killer.name ~= "Roshan" and not killer.config.is_boss and not ed.engine.guildInstance_mode and not hero.config.is_summoned and not hero.CHEN_ult1time and hero.name == "Roshan" and not hero.Roshan_castsawake then
    sawake:takeEffectOn(killer)
    sawake.power = override(sawake.power, Roshan.sawake_power)
    killer:takeHeal(sawake.info["Script Arg2"] * 0.5, "mp", killer)
    local sawake_effect_name = "eff_impact_Roshan_sawake.cha"
    hero.Roshan_castsawake = true
    if killer.actor then
      killer.actor:addEffect(sawake_effect_name, 1)
    end
  end
end

function Roshan.sawake_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  ret = ret * 0.5
  return ret
end

function Roshan.skillawake_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local info = buff.info
  local owner = buff.owner
  local skillawake = buff.owner.skills.Roshan_awake
  if damage_type ~= "Holy" and (source.position[1] - owner.position[1]) * owner.direction >= 0 and not transferred and owner.skillawake_casted == false then
    if 0 < owner.Roshan_atk3_shield then
      local defence, dd, dc, immunity, crit
      local level = owner.level
      if damage_type == "AD" then
        defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
        crit = source.attribs.CRIT
        immunity = owner.attribs.PIMU or 0
        dd = defence * 8
        dc = defence * 8
      elseif damage_type == "AP" then
        defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
        crit = source.attribs.MCRIT
        immunity = owner.attribs.MIMU or 0
        dd = defence * 12
        dc = defence * 2.5
      elseif damage_type == "Holy" then
        defence = 0
        crit = 0
        immunity = 0
        dd = 0
        dc = 0
      else
        EDDebug("Unknown Damage Type '" .. damage_type .. "'")
      end
      immunity = immunity + owner.attribs.ALLIMU
      local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
      owner.Roshan_atk3_shield = owner.Roshan_atk3_shield - lastdamage
      local ratio = owner.skills.Roshan_atk3.info["Script Arg2"]
      if 0 >= owner.Roshan_atk3_shield then
        if ed.protoSuperAwake(owner.proto, 10051) then
          owner:enterActionStageFromOneStage(6, 10051)
        elseif ed.protoAwake(owner.proto, 10051) then
          owner:enterActionStageFromOneStage(4, 10051)
        else
          owner:enterActionStageFromOneStage(2, 10051)
        end
      end
    end
    if source and source.name ~= "Roshan" then
      owner.skillawake_casted = true
      skillawake:takeEffectOn(source)
    end
    return damage
  end
  return damage
end

function Roshan.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local buff_add
  if not hero.firstinbattle then
    local skillatk4 = hero.skills.Roshan_atk4
    if skillatk4 then
      local skilllevel = skillatk4.level
      local bid = 1238
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      buff_add = ed.BuffCreate(binfo, hero, hero)
      buff_add.notPopupWords = true
      local addAD = hero.attribs.AD * Roshan.Roshan_atk4_addADratio
      local addARM = hero.attribs.ARM * Roshan.Roshan_atk4_addARMratio
      local addMR = hero.attribs.MR * Roshan.Roshan_atk4_addMRratio
      buff_add:setAttribute("AD", addAD)
      buff_add:setAttribute("ARM", addARM)
      buff_add:setAttribute("MR", addMR)
      local buffresult = hero:addBuff(buff_add, hero)
      local bid2 = 1239
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero.Roshan_buff_uncon = ed.BuffCreate(binfo2, hero, hero)
      local buffresult2 = hero:addBuff(hero.Roshan_buff_uncon, hero)
    end
    local skillawake = hero.skills.Roshan_awake
    if skillawake then
      local bid = 1240
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      buff.onDamaged = override(buff.onDamaged, Roshan.skillawake_buffonDamaged)
      local buffresult = hero:addBuff(buff, hero)
    end
    hero.firstinbattle = true
  end
  if hero.hp / hero.attribs.HP <= Roshan.Roshan_atk4_HPratio then
    if hero.Roshan_buff_uncon then
      hero.Roshan_buff_uncon.timer = 0
    end
  elseif not hero.Roshan_buff_uncon then
    local bid2 = 1239
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    hero.Roshan_buff_uncon = ed.BuffCreate(binfo2, hero, hero)
    local buffresult2 = hero:addBuff(hero.Roshan_buff_uncon, hero)
  end
  if (not ed.engine.hero_background or ed.engine.hero_background[1] ~= "Roshan_hell") and ed.run_with_scene and hero.Roshan_ult_volcano_effect then
    local z = -1
    ed.scene:removeEffect(hero.Roshan_ult_volcano_effect, z)
  end
  if not hero:isAlive() then
    for i, unit in ipairs(hero.Roshan_BoomStonelist) do
      if unit and unit:isAlive() then
        unit:die()
      end
    end
  end
  local sawake = hero.skills.Roshan_sawake
  if ed.protoSuperAwake(hero.proto, 10051) and hero.hp / hero.attribs.HP < 0.3 and hero:isAlive() and hero.current_skill ~= hero.manual_skill and not hero.Roshan_castsawake then
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    sawake:takeEffectOn(hero)
    hero:takeHeal(sawake.info["Script Arg2"], "mp", hero)
    local sawake_effect_name = "eff_impact_Roshan_sawake.cha"
    hero.Roshan_castsawake = true
    if hero.actor then
      hero.actor:addEffect(sawake_effect_name, 1)
    end
  end
end

function Roshan.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster:getInitDir()
  local target = skill.target
  local originfo = skill.info
  skill.info["No Dodge"] = true
  if attack_counter == 0 then
    if ed.run_with_scene and (not ed.engine.hero_background or ed.engine.hero_background[1] ~= "Roshan_hell") then
      local effect_night = "eff_point_Roshan_ult.cha"
      local origin = {400, 0}
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    end
    if ed.run_with_scene and not caster.Roshan_ult_volcano_effect then
      local effect_night = "eff_point_Roshan_bg_volcano.cha"
      local origin = {330, 130}
      caster.Roshan_ult_volcano_effect = ed.scene:playEffectOnScene(effect_night, origin, {1.42, 1}, nil, -1)
    end
    if ed.engine.hero_background and ed.engine.hero_background[3] ~= true then
      if ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" then
        ed.engine.hero_background = ed.engine.genHeroBackground("Roshan_hell", 20, nil)
      else
        ed.engine.hero_background = ed.engine.genHeroBackground("Roshan_hell", 20, nil)
        if ed.run_with_scene and not ed.IsMultiArena() then
          ed.scene:onBackgroundAppear(1, "battle_bg/bbg_Roshan_hell.jpg")
        end
      end
    end
    skill.attack_counter = skill.attack_counter + 1
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(75, 0.1, 2)
    end
  elseif attack_counter == 1 then
    basefunc(skill)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(25, 0.1, 2)
    end
  end
end

function Roshan.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result then
    local info = skill.info
    local direction = caster.direction
    local middle_position1 = caster.position[1] + direction * info["Shape Arg1"] / 2
    local new_position = {
      middle_position1 + (middle_position1 - target.position[1]),
      target.position[2]
    }
    target:knockup(1, ed.edpSub(new_position, target.position), shift)
  end
end

function Roshan.skillatk2_collectAoeTarget(basefunc, skill, origin, direction)
  local list = basefunc(skill, origin, direction)
  local info = skill.info
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  local caster = skill.caster
  for i, unit in ipairs(caster.Roshan_BoomStonelist) do
    if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == caster then
    elseif not unit:isAlive() then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if Roshan.testPointInShape(p2, shape, arg1, arg2) then
        table.insert(list, unit)
      end
    end
  end
  return list
end

function Roshan.Roshan_atk2s_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local skill = projectile.skill
  local caster = skill.caster
  local direction = caster.direction
  projectile.timer = projectile.timer - dt
  projectile.fireCD = projectile.fireCD - dt
  for unit in ed.engine:foreachAliveUnit(caster.ori_foecamp) do
    local p2 = ed.edpSub(unit.position, caster.atk2_AOEorigin)
    local p_temp = ed.edpSub(unit.position, caster.atk2_AOEorigin)
    p2[1] = p2[1] * direction
    if Roshan.testPointInShape(p2, "circle", 150, 0) then
      if p_temp[1] >= 0 then
        projectile.position_count[1] = projectile.position_count[1] + dt
      elseif p_temp[1] < 0 then
        projectile.position_count[2] = projectile.position_count[2] + dt
      end
    end
  end
  for i = 1, 2 do
    if projectile.position_count[i] >= 4 and projectile.fireCD <= 0 then
      if ed.run_with_scene then
        local effect_night = "eff_point_Roshan_atk2_fire.cha"
        if ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" then
          effect_night = "eff_point_Roshan_atk2_fire_hell.cha"
        end
        local origin = {
          caster.position[1] + caster.Roshan_atk2s_position[i][1],
          caster.position[2] + caster.Roshan_atk2s_position[i][2]
        }
        ed.scene:playEffectOnScene(effect_night, origin, {1, 1}, nil, 0)
      end
      if projectile.position_counttime[i] then
        projectile.position_counttime[i] = projectile.position_counttime[i] + dt
      end
      if 1 <= projectile.position_counttime[i] then
        local skillatk2s2 = caster.skills.Roshan_atk2s2
        skillatk2s2:takeEffectAt({
          caster.position[1] + caster.Roshan_atk2s_position[i][1],
          caster.position[2] + caster.Roshan_atk2s_position[i][2]
        })
        projectile.position_count[i] = 0
        projectile.position_counttime[i] = 0
        projectile.fireCD = 1.5
      end
    end
  end
  if projectile.timer <= 0 then
    projectile:terminate()
  end
end

function Roshan.Roshan_atk2s_projectile_terminate(basefunc, projectile)
  basefunc(projectile)
  local caster = projectile.caster
  if ed.run_with_scene and caster.Roshan_atk2_region_effect then
    local z = -1
    ed.scene:removeEffect(caster.Roshan_atk2_region_effect, z)
  end
end

function Roshan.skillatk2s_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.height = 999
  projectile.timer = 9
  projectile.fireCD = 0
  projectile.update = override(projectile.update, Roshan.Roshan_atk2s_projectile_update)
  projectile.terminate = override(projectile.terminate, Roshan.Roshan_atk2s_projectile_terminate)
  projectile.position_count = {0, 0}
  projectile.position_counttime = {0, 0}
  caster.atk2_AOEorigin = {
    caster.position[1],
    caster.position[2]
  }
  if projectile.actor then
    projectile.actor.ownZOrder = -999
  end
  return projectile
end

function Roshan.skillatk2s2_power(basefunc, skill, source, target)
  local power = basefunc(skill, source, target)
  if ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" then
    power = power * Roshan.Roshan_atk2_ratio_hell
  end
  return power
end

function Roshan.BoomStone_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  if source and source.name == "Roshan" and source.camp == hero.camp or source and source.name == "BoomStone" and source.camp == hero.camp then
    damage = hero.hp + 1
    return basefunc(hero, damage, immunity, damage_type, source)
  else
    return 1
  end
end

function Roshan.BoomStone_onDying(basefunc, hero, killer)
  local skillatk2 = hero.skills.BoomStone_atk2
  if hero.custom_data ~= 1 and hero.config.summoner:isAlive() then
    hero.custom_data = 1
    hero.state = ed.emUnitState_Idle
    local bid = 1243
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    local buffresult = hero:addBuff(buff, hero)
    hero:setHP(1)
    hero:castSkill(skillatk2, nil)
  else
    basefunc(hero, killer)
  end
end

function Roshan.BoomStone_atk2_collectAoeTarget(basefunc, skill, origin, direction)
  local list = basefunc(skill, origin, direction)
  local info = skill.info
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  local caster = skill.caster
  local Roshanlocal = caster.config.summoner
  for i, unit in ipairs(Roshanlocal.Roshan_BoomStonelist) do
    if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == caster then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if Roshan.testPointInShape(p2, shape, arg1, arg2) then
        table.insert(list, unit)
      end
    end
  end
  return list
end

function Roshan.BoomStone_atk2_power(basefunc, skill, source, target)
  local power, i = basefunc(skill, source, target)
  local caster = skill.caster
  local ratio = caster.live_time / Roshan.BoomStone_livetime
  power = power * (ratio > Roshan.BoomStone_power_min and ratio or Roshan.BoomStone_power_min)
  if ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" then
    power = power * Roshan.BoomStone_power_ratio_hell
  end
  return power, i
end

function Roshan.BoomStone_atk2_finish(basefunc, skill)
  basefunc(skill)
  skill.info = skill.originfo
  local caster = skill.caster
  caster:die()
end

function Roshan.BoomStone_atk2_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Roshan.BoomStone_atk2_start(basefunc, skill, target)
  local info = skill.info
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  if not ed.engine.hero_background or ed.engine.hero_background[1] ~= "Roshan_hell" then
    skill:startPhase(1)
  else
    skill.info = ed.wraptable(skill.originfo, {
      ["Plus Ratio"] = 2,
      ["Shape Arg1"] = 150
    })
    skill:startPhase(2)
  end
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function Roshan.BoomStone_update(basefunc, self, dt)
  self.live_time = self.live_time - dt
  if self.live_time <= 0 then
    self:onDying(self)
  end
  if self.firstin == nil then
    self:setAllBuffVisible(false)
    self:setHpVisible(false)
    self.firstin = true
  end
  basefunc(self, dt)
end

function Roshan.skillatk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 150 and projectile.zSpeed < 0 then
    local BoomStone_position = projectile.position
    projectile:terminate()
    local skillatk3 = caster.skills.Roshan_atk3
    local proto = {
      _tid = 251,
      _level = skillatk3.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      },
      _skill_levels = {
        [1] = skillatk3.level or 1,
        [2] = skillatk3.level or 1
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local BoomStone = ed.UnitCreate(proto, caster.camp, config)
    BoomStone.notPopupBattleInfo = true
    local bid = 1244
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, BoomStone, BoomStone)
    local buffresult = BoomStone:addBuff(buff, BoomStone)
    BoomStone.direction = caster.direction
    BoomStone.live_time = Roshan.BoomStone_livetime
    BoomStone.owner = caster
    BoomStone.update = override(BoomStone.update, Roshan.BoomStone_update)
    BoomStone.getLostHPAfterImmunity = override(BoomStone.getLostHPAfterImmunity, Roshan.BoomStone_getLostHPAfterImmunity)
    BoomStone.onDying = override(BoomStone.onDying, Roshan.BoomStone_onDying)
    local skillatk2 = BoomStone.skills.BoomStone_atk2
    skillatk2.collectAoeTarget = override(skillatk2.collectAoeTarget, Roshan.BoomStone_atk2_collectAoeTarget)
    skillatk2.power = override(skillatk2.power, Roshan.BoomStone_atk2_power)
    skillatk2.finish = override(skillatk2.finish, Roshan.BoomStone_atk2_finish)
    skillatk2.start = override(skillatk2.start, Roshan.BoomStone_atk2_start)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, Roshan.BoomStone_atk2_onPhaseFinished)
    local location = {
      BoomStone_position[1],
      BoomStone_position[2]
    }
    ed.engine:summonUnit(BoomStone, location, caster, "Birth")
    table.insert(caster.Roshan_BoomStonelist, BoomStone)
  end
end

function Roshan.skillatk3_selectPostition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if i == caster.BoomStone_lastpositionX then
      elseif unit.buff_effects.untargetable then
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
    caster.BoomStone_lastpositionX = x
    return x
  end
  if maxcount <= 0 then
    return false
  end
end

function Roshan.skillatk3_createProjectile(basefunc, skill)
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
  local target_position
  local x = Roshan.skillatk3_selectPostition(skill, 150)
  if x then
    local r = ed.rand() * 75
    local angle = ed.rand() * 360
    target_position = {
      x + r * math.cos(math.rad(angle)),
      r * math.sin(math.rad(angle))
    }
  else
    target_position = {
      400 + dir * 200,
      0
    }
  end
  if target_position then
    local launchposition, h = skill:launchPoint()
    local distance = ed.edpSub(target_position, {
      launchposition[1],
      launchposition[2]
    })
    projectile.velocity = ed.edpMult(distance, 1 / t)
    projectile.update = override(projectile.update, Roshan.skillatk3_projectile_update)
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function Roshan.background_summon_BoomStone(hero)
  local dir = hero:getInitDir()
  local BoomStone_position
  local skillatk3s = hero.skills.Roshan_atk3s
  local x = Roshan.skillatk3_selectPostition(skillatk3s, 150)
  if x then
    local r = ed.rand() * 50
    local angle = ed.rand() * 360
    BoomStone_position = {
      x + r * math.cos(math.rad(angle)),
      r * math.sin(math.rad(angle))
    }
  else
    BoomStone_position = {
      400 + dir * 200,
      0
    }
  end
  local proto = {
    _tid = 251,
    _level = skillatk3s.level or 1,
    _stars = hero.stars,
    _rank = hero.rank,
    _fashion = {
      _current_fashion = hero.fashion_id
    },
    _skill_levels = {
      [1] = skillatk3s.level or 1,
      [2] = skillatk3s.level or 1
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = hero.config.dps_mod or 1
  }
  local BoomStone = ed.UnitCreate(proto, hero.camp, config)
  BoomStone.notPopupBattleInfo = true
  local bid = 1244
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, BoomStone, BoomStone)
  local buffresult = BoomStone:addBuff(buff, BoomStone)
  BoomStone.direction = hero.direction
  BoomStone.live_time = Roshan.BoomStone_livetime
  BoomStone.owner = hero
  BoomStone.update = override(BoomStone.update, Roshan.BoomStone_update)
  BoomStone.getLostHPAfterImmunity = override(BoomStone.getLostHPAfterImmunity, Roshan.BoomStone_getLostHPAfterImmunity)
  BoomStone.onDying = override(BoomStone.onDying, Roshan.BoomStone_onDying)
  local skillatk2 = BoomStone.skills.BoomStone_atk2
  skillatk2.collectAoeTarget = override(skillatk2.collectAoeTarget, Roshan.BoomStone_atk2_collectAoeTarget)
  skillatk2.power = override(skillatk2.power, Roshan.BoomStone_atk2_power)
  skillatk2.finish = override(skillatk2.finish, Roshan.BoomStone_atk2_finish)
  skillatk2.start = override(skillatk2.start, Roshan.BoomStone_atk2_start)
  skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, Roshan.BoomStone_atk2_onPhaseFinished)
  local location = {
    BoomStone_position[1],
    BoomStone_position[2]
  }
  ed.engine:summonUnit(BoomStone, location, hero, "Birth")
  table.insert(hero.Roshan_BoomStonelist, BoomStone)
  if ed.run_with_scene then
    if hero.Roshan_ult_volcano_effect then
      local z = -1
      ed.scene:removeEffect(hero.Roshan_ult_volcano_effect, z)
    end
    local effect_night = "eff_point_Roshan_bg_volcano.cha"
    local origin = {330, 130}
    hero.Roshan_ult_volcano_effect = ed.scene:playEffectOnScene(effect_night, origin, {1.42, 1}, nil, -1)
  end
end

function Roshan.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster:getInitDir()
  local target = skill.target
  local originfo = skill.info
  local skillatk3 = caster.skills.Roshan_atk3
  if attack_counter <= 2 then
    if attack_counter == 0 then
      if ed.run_with_scene then
        if caster.Roshan_atk2_region_effect then
          local z = -1
          ed.scene:removeEffect(caster.Roshan_atk2_region_effect, z)
        end
        local effect_night = "eff_point_Roshan_atk2_ground.cha"
        local origin = caster.position
        caster.Roshan_atk2_region_effect = ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
      end
      if ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" and skillatk3 then
        Roshan.background_summon_BoomStone(caster)
      end
    end
    basefunc(skill)
  end
  if attack_counter == 2 then
    local Roshan_skillatk2s = caster.skills.Roshan_atk2s
    local projectile = Roshan_skillatk2s:createProjectile()
    ed.engine:addProjectile(projectile)
  end
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(15, 0.1, 2)
  end
end

function Roshan.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" then
    Roshan.background_summon_BoomStone(skill.caster)
  end
end

function Roshan.skillatk4_buffonDamaged(basefunc, buff, damage, damage_type, source, skill)
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if maxdmg >= lastdamage then
    return damage
  else
    damage = 0
    local hp = buff.owner.attribs.HP * Roshan.Roshan_atk4_hpratio
    if 100000 <= hp then
      hp = 100000
    end
    buff.owner:takeHeal(hp, "hp", buff.owner, owner.name)
    buff.owner:removeBuff(buff)
    if ed.run_with_scene then
      local effect_night = "eff_point_IO_death.cha"
      local origin = buff.owner.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
    end
    return damage
  end
end

function Roshan.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Roshan.skillatk4_buffonDamaged)
  return buff
end

function Roshan.skillawake_power(basefunc, skill, source, target)
  local power = basefunc(skill, source, target)
  local caster = skill.caster
  if caster.currentActionStage == 2 or caster.currentActionStage == 4 then
    power = power * 3
  end
  return power
end

function Roshan.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result and ed.engine.hero_background and ed.engine.hero_background[1] == "Roshan_hell" then
    local skillatks = caster.skills.Roshan_atks
    if target:isAlive() and skillatks then
      skillatks:takeEffectAt(target.position)
    end
  end
end

function Roshan.skillenter_start(basefunc, skill)
  basefunc(skill)
end

function Roshan.skillenter_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 1263 then
      tbuff.timer = 0
    end
  end
end

function Roshan.init_hero(hero)
  if ed.run_with_scene and not ed.IsMultiArena() then
    ed.getSpriteFrame("UI/alpha/1080P/battle_bg/bbg_puck_dream1.jpg")
  end
  local skillult = hero.skills.Roshan_ult
  local skillatk = hero.skills.Roshan_atk
  local skillatk2 = hero.skills.Roshan_atk2
  local skillatk2s = hero.skills.Roshan_atk2s
  local skillatk2s2 = hero.skills.Roshan_atk2s2
  local skillatk3 = hero.skills.Roshan_atk3
  local skillatk4 = hero.skills.Roshan_atk4
  local skillawake = hero.skills.Roshan_awake
  local skillenter = hero.skills.Roshan_enter
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, Roshan.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Roshan.skillult_onAttackFrame)
    skillult.collectAoeTarget = override(skillult.collectAoeTarget, Roshan.skillatk2_collectAoeTarget)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Roshan.skillatk_takeEffectOn)
    skillatk.collectAoeTarget = override(skillatk.collectAoeTarget, Roshan.skillatk2_collectAoeTarget)
  end
  if skillatk2 then
    skillatk2.collectAoeTarget = override(skillatk2.collectAoeTarget, Roshan.skillatk2_collectAoeTarget)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Roshan.skillatk2_onAttackFrame)
    skillatk2s.createProjectile = override(skillatk2s.createProjectile, Roshan.skillatk2s_createProjectile)
    skillatk2s2.power = override(skillatk2s2.power, Roshan.skillatk2s2_power)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, Roshan.skillatk3_createProjectile)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Roshan.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Roshan.skillatk4_createBuff)
  end
  if skillawake then
    skillawake.power = override(skillawake.power, Roshan.skillawake_power)
  end
  if skillenter then
    skillenter.start = override(skillenter.start, Roshan.skillenter_start)
    skillenter.finish = override(skillenter.finish, Roshan.skillenter_finish)
  end
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, Roshan.hero_reset)
  hero.die = override(hero.die, Roshan.hero_die)
  hero.update = override(hero.update, Roshan.hero_update)
  if not ed.protoSuperAwake(hero.proto, 10051) then
    function hero.RoshanGetNormalPeriod(unit)
      return ed.protoAwake(unit.proto, 10051) and 3 or 1
    end
    
    function hero.RoshanGetbrokePeriod(unit)
      return ed.protoAwake(unit.proto, 10051) and 4 or 2
    end
    
    if ed.protoAwake(hero.proto, 10051) then
      hero:enterActionStageFromOneStage(hero:RoshanGetNormalPeriod(), 10051)
    end
  else
    function hero.RoshanGetNormalPeriod(unit)
      return 5
    end
    
    function hero.RoshanGetbrokePeriod(unit)
      return 6
    end
    
    hero:enterActionStageFromOneStage(hero:RoshanGetNormalPeriod(), 10051)
  end
  return hero
end

return Roshan.init_hero
