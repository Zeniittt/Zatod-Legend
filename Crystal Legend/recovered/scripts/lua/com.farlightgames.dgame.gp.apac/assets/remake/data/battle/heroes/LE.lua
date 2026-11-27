module("ed.battlehero", package.seeall)
local ed = ed
LE = {}
LE.LE_atk3DeskID = 299
LE.LE_desk_invu_BuffID = 4327
LE.LE_desk_stun_BuffID = 4328

function LE.skillatk124u_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.LE_fixdir = caster.direction
  local bid = 1454
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function LE.skillatk124u_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1454 then
      caster:removeBuff(tbuff)
    end
  end
end

function LE.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk2 = caster.skills.LE_atk2
  local skillatk2a = caster.skills.LE_atk2a
  if attack_counter ~= 3 then
    basefunc(skill)
  elseif attack_counter == 3 and skillatk2a then
    skillatk2a:takeEffectAt(caster.position, caster)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function LE.skillatk2a_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local MSPD = buff.info.MSPD
  local HAST = buff.info.HAST
  if caster.info.Name == "LE" and caster.stars > 7 then
    buff:setAttribute("MSPD", MSPD + 5 * (caster.stars - 7))
    buff:setAttribute("HAST", HAST + 5 * (caster.stars - 7))
  end
  if caster.LE_hasArcana and caster.LE_hasArcana >= 4 then
    buff:setAttribute("CON", 20)
  end
  return buff
end

function LE.skillatk2a_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
end

function LE.skillatk3_start(basefunc, skill)
  local hero = skill.caster
  local proto = {
    _tid = LE.LE_atk3DeskID,
    _level = hero.level or 1,
    _stars = hero.stars,
    _rank = hero.rank,
    _skill_levels = {
      hero.level or 1,
      hero.level or 1,
      hero.level or 1,
      hero.level or 1
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = hero.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or hero.config.hp_mod,
    dps_mod = hero.config.dps_mod or 1
  }
  local desk = ed.UnitCreate(proto, hero.camp, config)
  desk.direction = hero.direction
  local desk_location = {
    hero.position[1] + 200 * hero.direction,
    hero.position[2]
  }
  local binfo = ed.lookupDataTable("Buff", nil, LE.LE_desk_invu_BuffID)
  local buff = ed.BuffCreate(binfo, desk, desk)
  desk:addBuff(buff, desk)
  local bbinfo = ed.lookupDataTable("Buff", nil, LE.LE_desk_stun_BuffID)
  local bbuff = ed.BuffCreate(bbinfo, desk, desk)
  desk:addBuff(bbuff, desk)
  local skillatk = desk.skills.TitanLE_desk_atk
  local skillatk2 = desk.skills.TitanLE_desk_atk2
  if skillatk then
    skillatk.finish = override(skillatk.finish, LE.desk_atk_finish)
  end
  if skillatk2 then
    skillatk2.finish = override(skillatk2.finish, LE.desk_atk2_finish)
  end
  desk.update = override(desk.update, LE.desk_update)
  desk.isActionStageChangeByManual = true
  desk.cast_atk = false
  desk.cast_atk2 = false
  desk.atk3_desk_trigger = false
  desk.LE_desk_location = desk_location
  desk.liveTime = 0
  hero.desk_position = desk_location
  ed.engine:summonUnit(desk, desk_location, hero, "Idle")
  hero.LE_desk = desk
  skill.target = hero.LE_desk
  basefunc(skill)
end

function LE.skillatk3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  projectile.position = skill:launchPoint()
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    caster.desk_position[1],
    caster.desk_position[2] + 10
  }
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  projectile.track_target = caster.LE_desk
  projectile.collideCheck = override(projectile.collideCheck, LE.skillatk3_projectilecollideCheck)
  projectile.terminate = override(projectile.terminate, LE.skillatk3_projectileTerminate)
  caster.projectile_hit_table = false
  ed.engine:addProjectile(projectile)
  return nil
end

function LE.skillatk3_projectilecollideCheck(basefunc, projectile, unit)
  local t = basefunc(projectile, unit)
  local caster = projectile.caster
  local u_pos = caster.desk_position
  local t_pos = projectile.position
  local caster = projectile.caster
  if u_pos and t_pos then
    if (u_pos[1] - t_pos[1]) ^ 2 <= 1225 and (u_pos[2] - t_pos[2]) ^ 2 <= 1225 then
      caster.projectile_hit_table = true
      return true
    else
      return false
    end
  else
    return false
  end
  return t
end

function LE.skillatk3_projectileTerminate(basefunc, projectile)
  local caster = projectile.caster
  local desk = caster.LE_desk
  if not projectile.terminated and caster.projectile_hit_table == true and desk.atk3_desk_trigger == true then
    basefunc(projectile)
  end
  basefunc(projectile)
end

function LE.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local table = caster.LE_desk
  local attack_counter = skill.attack_counter
  local skillatk3a = caster.skills.LE_atk3a
  if table and caster.info.Name == "LE" and attack_counter == 1 and skillatk3a then
    table.atk3_desk_trigger = true
    skillatk3a.target = table
    skillatk3a:takeEffectAt(caster.desk_position, table)
  end
end

function LE.desk_update(basefunc, unit, dt)
  basefunc(unit, dt)
  local caster = unit.config.summoner
  local desk = unit
  local desk_atk = unit.skills.TitanLE_desk_atk
  local desk_position = unit.position
  caster.atk3_desk_position = desk_position
  desk.liveTime = desk.liveTime + dt
  if caster:isAlive() and desk.atk3_desk_trigger == true and desk.cast_atk == false then
    desk:castSkill(desk_atk, desk)
    desk.cast_atk = true
  end
  if desk.liveTime > 6 then
    desk:die()
    desk.liveTime = 0
  end
end

function LE.desk_atk_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local desk = skill.caster
  local desk_atk = desk.skills.TitanLE_desk_atk
  local desk_atk2 = desk.skills.TitanLE_desk_atk2
  local bbinfo = ed.lookupDataTable("Buff", nil, LE.LE_desk_stun_BuffID)
  local bbuff = ed.BuffCreate(bbinfo, desk, desk)
  if desk.cast_atk2 == false then
    desk:castSkill(desk_atk2, desk)
    desk.cast_atk2 = true
  end
end

function LE.desk_atk2_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local desk = skill.caster
  local hero = desk.config.summoner
  desk.position = {
    400 - 5000 * desk.direction,
    hero.position[2] - 40
  }
  local bbinfo = ed.lookupDataTable("Buff", nil, LE.LE_desk_stun_BuffID)
  local bbuff = ed.BuffCreate(bbinfo, desk, desk)
  desk:addBuff(bbuff, desk)
  desk:die()
end

function LE.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillatk4 = caster.skills.LE_atk4
  local skillatk4a = caster.skills.LE_atk4a
  if attack_counter == 1 then
    if skillatk4 then
    end
  elseif attack_counter == 2 and skillatk4a then
    local min_unit
    local minHp = math.huge
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if not unit.config.is_summoned and not unit.buffManager.invisible and not unit.config.is_monster and minHp >= unit.hp then
        min_unit = unit
        minHp = unit.hp
      end
    end
    if min_unit then
      skillatk4a:takeEffectOn(min_unit, caster)
    end
  end
end

function LE.skillatk4a_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  if caster.info.Name == "LE" and caster.stars > 7 and buff.shield then
    buff.shield = buff.shield + 3000 * (caster.stars - 7)
  end
  if caster.LE_hasArcana and caster.LE_hasArcana >= 2 and buff.shield then
    buff.shield = buff.shield * 1.2
  end
  return buff
end

function LE.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.LE_ult
  local skillulta = caster.skills.LE_ulta
  if attack_counter ~= 3 then
    basefunc(skill)
  elseif attack_counter == 3 and skillulta then
    local target = skillulta:selectTarget()
    if target then
      local bid = 4324
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.onDamaged = override(buff.onDamaged, LE.skillulta_buffonDamaged)
      target:addBuff(buff, caster)
      if skillulta and 3 <= caster.LE_hasArcana then
        local min_unit
        local minHp = math.huge
        for unit in ed.engine:foreachAliveUnit(caster.camp) do
          if minHp >= unit.hp and unit ~= target then
            min_unit = unit
            minHp = unit.hp
          end
        end
        if min_unit then
          skillulta:takeEffectOn(min_unit, caster)
        end
      end
    end
  end
end

function LE.skillulta_buffonDamaged(basefunc, buff, damage, damage_type, source, skill)
  local owner = buff.owner
  local caster = buff.caster
  if owner.camp == caster.camp and damage and 0 < damage and damage_type ~= "Heal" and source and source:isHero() then
    local bid = 4325
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, source, caster)
    local HAST = buff.info.HAST
    local MSPD = buff.info.MSPD
    if caster.stars > 7 and caster.info.Name == "LE" then
      buff:setAttribute("MSPD", MSPD - 10 * (caster.stars - 7))
      buff:setAttribute("HAST", HAST - 10 * (caster.stars - 7))
    end
    source:addBuff(buff, caster)
  end
  return basefunc(buff, damage, damage_type, source, skill)
end

function LE.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = actor.model.direction == 1 and "Cheer" or "Cheer_r"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function LE.getFixDir(basefunc, unit)
  return unit.LE_fixdir and unit.LE_fixdir or unit.direction
end

function LE.setAction(basefunc, hero, action_name, loop, interrupt)
  local movable = not hero.buff_effects.immoblilize
  local pos = hero.position
  local v1 = movable and hero.walk_v or ed.edpZero
  if hero.buff_effects.fix then
    hero.direction = hero:getFixDir()
  else
    local direction = 0
    if movable and v1[1] ~= 0 then
      direction = v1[1]
    elseif hero.current_skill and hero.current_skill.target and not hero.current_skill.casterDirectionLocked then
      direction = hero.current_skill.target.position[1] - pos[1]
    end
    if direction * hero.direction < 0 then
      hero.direction = hero.direction * -1
    end
  end
  if action_name then
    local puppetName = hero.puppet_stack[#hero.puppet_stack]
    puppetName = ed.lookupDataTable("Puppet", "Resource", puppetName) .. ".cha"
    if hero.direction == -1 or hero:getInitDir() == -1 and action_name == "Move2" then
      local action_r = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name .. "_r")
      if action_r then
        action_name = action_name .. "_r"
      end
    end
    hero.action_loop = loop or false
    if loop and action_name == hero.action_name then
      return
    end
    hero.action_name = action_name
    hero.action_elapsed = interrupt and 0 or math.max(0, hero.action_elapsed - hero.action_duration)
    if not loop and action_name ~= nil then
      hero.action_duration = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name)
      if not hero.action_duration then
        print("nil action duration in table AnimDuration puppetName -> " .. puppetName)
        print("nil action duration in table AnimDuration action_name -> " .. action_name)
        hero.action_name = "Idle"
        hero.action_duration = 1.375
      end
    else
      hero.action_duration = 0
    end
    if hero.actor then
      hero.actor:onStartNewAction()
    end
  end
end

function LE.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.projectile_hit_table = false
  hero.cheer_action_reset = nil
end

function LE.hero_onDying(basefunc, hero)
  basefunc(hero)
  if hero.LE_desk and hero.LE_desk:isAlive() then
    hero.LE_desk:die()
  end
end

function LE.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if ed.run_with_scene and not hero.cheer_action_reset and hero.actor then
    hero.cheer_action_reset = true
    hero.actor.cheer = override(hero.actor.cheer, LE.cheer)
  end
end

function LE.init_hero(hero)
  local skillatk = hero.skills.LE_atk
  local skillatk2 = hero.skills.LE_atk2
  local skillatk2a = hero.skills.LE_atk2a
  local skillatk3 = hero.skills.LE_atk3
  local skillatk4 = hero.skills.LE_atk4
  local skillatk4a = hero.skills.LE_atk4a
  local skillult = hero.skills.LE_ult
  hero.isActionStageChangeByManual = true
  hero.LE_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.update = override(hero.update, LE.hero_update)
  hero.onDying = override(hero.onDying, LE.hero_onDying)
  hero.reset = override(hero.reset, LE.hero_reset)
  hero.setAction = override(hero.setAction, LE.setAction)
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, LE.skillatk2_onAttackFrame)
  end
  if skillatk2a then
    skillatk2a.takeEffectAt = override(skillatk2a.takeEffectAt, LE.skillatk2a_takeEffectAt)
    skillatk2a.createBuff = override(skillatk2a.createBuff, LE.skillatk2a_createBuff)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, LE.skillatk3_start)
    skillatk3.createProjectile = override(skillatk3.createProjectile, LE.skillatk3_createProjectile)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, LE.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, LE.skillatk4_onAttackFrame)
  end
  if skillatk4a then
    skillatk4a.createBuff = override(skillatk4a.createBuff, LE.skillatk4a_createBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, LE.skillult_onAttackFrame)
  end
  return hero
end

return LE.init_hero
