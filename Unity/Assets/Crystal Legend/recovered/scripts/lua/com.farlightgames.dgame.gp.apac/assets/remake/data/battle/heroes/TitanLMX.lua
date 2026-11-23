module("ed.battlehero", package.seeall)
local ed = ed
TitanLMX = {}
TitanLMX.LMX_atk2b_BuffID = 4281
TitanLMX.LMX_atk2c_BuffID = 4282
TitanLMX.LMX_ulta_1_BuffID = 4283
TitanLMX.LMX_ulta_2_BuffID = 4284
TitanLMX.LMX_ultb_1_BuffID = 4285
TitanLMX.LMX_ultb_2_BuffID = 4286
TitanLMX.LMX_ultc_1_BuffID = 4287
TitanLMX.LMX_ultc_2_BuffID = 4288
TitanLMX.LMX_atk_1_BuffID = 4289
TitanLMX.LMX_atk_2_BuffID = 4290
TitanLMX.LMX_atk_3_BuffID = 4291
TitanLMX.LMX_arcana_atk2_BuffID = 4292
TitanLMX.LMX_atk2_BuffID = 4293
TitanLMX.TitanLMX_ult3_go_timer_BuffID = 4299
TitanLMX.TitanLMX_ult3_return_timer_BuffID = 4300
TitanLMX.TitanLMX_atk_stable_BuffID = 4301
TitanLMX.TitanLMX_cooking_unctr_BuffID = 4302
TitanLMX.TitanLMX_ultc_fix_BuffID = 4303
TitanLMX.TitanLMX_heroID = 10103
TitanLMX.TitanLMX_deskID = 296
TitanLMX.TitanLMX_desk_invu_BuffID = 4297
TitanLMX.TitanLMX_desk_stun_BuffID = 4298

function TitanLMX.hero_reset(basefunc, hero)
  basefunc(hero)
  local proto = {
    _tid = TitanLMX.TitanLMX_deskID,
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
    400 - 5000 * desk.direction,
    hero.position[2] - 40
  }
  local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_desk_invu_BuffID)
  local buff = ed.BuffCreate(binfo, desk, desk)
  desk:addBuff(buff, desk)
  local bbinfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_desk_stun_BuffID)
  local bbuff = ed.BuffCreate(bbinfo, desk, desk)
  desk:addBuff(bbuff, desk)
  local skillatk2_1 = desk.skills.TitanLMX_desk_atk2_1
  local skillatk2_2 = desk.skills.TitanLMX_desk_atk2_2
  local skillatk2_3 = desk.skills.TitanLMX_desk_atk2_3
  if skillatk2_1 then
    skillatk2_1.onAttackFrame = override(skillatk2_1.onAttackFrame, TitanLMX.deskskillatk2_1_onAttackFrame)
    skillatk2_1.finish = override(skillatk2_1.finish, TitanLMX.deskskillatks_finish)
  end
  if skillatk2_2 then
    skillatk2_2.onAttackFrame = override(skillatk2_2.onAttackFrame, TitanLMX.deskskillatk2_2_onAttackFrame)
    skillatk2_2.finish = override(skillatk2_2.finish, TitanLMX.deskskillatks_finish)
  end
  if skillatk2_3 then
    skillatk2_3.onAttackFrame = override(skillatk2_3.onAttackFrame, TitanLMX.deskskillatk2_3_onAttackFrame)
    skillatk2_3.finish = override(skillatk2_3.finish, TitanLMX.deskskillatks_finish)
  end
  desk.update = override(desk.update, TitanLMX.desk_update)
  desk.isActionStageChangeByManual = true
  desk.TitanLMX_desk_location = desk_location
  ed.engine:summonUnit(desk, desk_location, hero, "Idle")
  hero.TitanLMX_desk = desk
  hero.isActionStageChangeByManual = true
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit.camp == hero.camp and not unit.config.is_summoned then
      if unit.info.ID == 10106 or unit.info.ID == 10105 then
        hero.TitanLMX_ChefHeroes[1] = 1
      elseif unit.info.ID == (10108 or 10109) then
        hero.TitanXL_arrival = true
      elseif unit.info.ID == 999999 then
        hero.TitanLMX_ChefHeroes[3] = 1
      end
    elseif unit.info.ID == 999996 then
      hero.TitanLMX_ChefHeroes[4] = 1
    end
  end
  hero.TitanLMX_originPos = {
    400 - 326.5 * hero.initdirection,
    hero.position[2]
  }
  hero.lastDirection = 1
  hero.walk_v = hero.init_Walk_v
end

function TitanLMX.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  local desk = hero.TitanLMX_desk
  if desk and desk:isAlive() then
    desk:die(hero)
  end
end

function TitanLMX.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk = hero.skills.TitanLMX_atk
  if hero.TitanLMX_ultMoving and math.abs(hero.position[1] - hero.TitanLMX_originPos[1]) <= 10 then
    hero.walk_v = {0, 0}
    hero.TitanLMX_ultc_s4:finish()
    hero.TitanLMX_ultMoving = nil
    hero.manual_moving = false
    hero.direction = hero.TitanLMX_originDir or hero.initdirection
    hero:castSkill(skillatk, hero)
  end
  if hero.actor and hero.actor.model.direction ~= hero.lastDirection then
    if hero.direction == -1 then
      hero.actor.puppet:setComponent("zuoshangbi", "zuoshangbi_s")
      hero.actor.puppet:setComponent("youshangbi", "youshangbi_s")
      hero.actor.puppet:setComponent("pengdai", "pengdai_s")
    else
      hero.actor.puppet:setComponent("zuoshangbi", "zuoshangbi")
      hero.actor.puppet:setComponent("youshangbi", "youshangbi")
      hero.actor.puppet:setComponent("pengdai", "pengdai")
    end
    local actionName = hero.actor:getActionName(hero.action_name)
    hero.actor.puppet:setAction(actionName)
    hero.actor.puppet:setLoop(hero.action_loop)
    hero.actor.puppet:setActionElapsed(hero.action_elapsed)
  end
  hero.lastDirection = hero.direction
end

function TitanLMX.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_atk_stable_BuffID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  caster.TitanLMX_originPos = {
    caster.position[1],
    caster.position[2]
  }
  caster.TitanLMX_originDir = caster.direction
end

function TitanLMX.deskskillatks_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local desk = skill.caster
  desk.position = desk.TitanLMX_desk_location
  local bbinfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_desk_stun_BuffID)
  local bbuff = ed.BuffCreate(bbinfo, desk, desk)
  desk:addBuff(bbuff, desk)
end

function TitanLMX.deskskillatk2_1_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local summoner = caster.config.summoner
  local skillatk2a = summoner.skills.TitanLMX_atk2a
  if skillatk2a then
    if skillatk2a.info["Target Type"] == "random" or skillatk2a.target == nil or not skillatk2a.target:isAlive() then
      skillatk2a:selectTarget(nil)
    end
    if not skillatk2a.target then
      return
    end
    local ttype = skillatk2a.info["Track Type"]
    skillatk2a.TitanLMX_inDesk = true
    skillatk2a:createTrackType(ttype)
  end
  basefunc(skill)
end

function TitanLMX.deskskillatk2_2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local summoner = caster.config.summoner
  local skillatk2b = summoner.skills.TitanLMX_atk2b
  if skillatk2b then
    if skillatk2b.info["Target Type"] == "random" or skillatk2b.target == nil or not skillatk2b.target:isAlive() then
      skillatk2b:selectTarget(nil)
    end
    if not skillatk2b.target then
      return
    end
    local ttype = skillatk2b.info["Track Type"]
    skillatk2b.TitanLMX_inDesk = true
    skillatk2b:createTrackType(ttype)
  end
  basefunc(skill)
end

function TitanLMX.deskskillatk2_3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local summoner = caster.config.summoner
  local skillatk2c = summoner.skills.TitanLMX_atk2c
  if skillatk2c then
    if skillatk2c.info["Target Type"] == "random" or skillatk2c.target == nil or not skillatk2c.target:isAlive() then
      skillatk2c:selectTarget(nil)
    end
    if not skillatk2c.target then
      return
    end
    local ttype = skillatk2c.info["Track Type"]
    skillatk2c.TitanLMX_inDesk = true
    skillatk2c:createTrackType(ttype)
  end
  basefunc(skill)
end

function TitanLMX.desk_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.TitanLMX_desk_movetime and unit.TitanLMX_desk_movetime > 0 then
    unit.TitanLMX_desk_movetime = unit.TitanLMX_desk_movetime - dt
  elseif unit.TitanLMX_desk_movetime and unit.TitanLMX_desk_movetime <= 0 then
    unit.TitanLMX_desk_movetime = nil
  end
  if not unit.TitanLMX_desk_movetime then
    return
  end
  if unit.TitanLMX_desk_movetime <= 0 and unit.TitanLMX_deskInAtk2a then
    unit.walk_v = {0, 0}
    local deskskillatk2_1 = unit.skills.TitanLMX_desk_atk2_1
    if deskskillatk2_1 then
      unit:castSkill(deskskillatk2_1, unit)
    end
    unit.TitanLMX_deskInAtk2a = nil
  elseif unit.TitanLMX_desk_movetime <= 0 and unit.TitanLMX_deskInAtk2b then
    unit.walk_v = {0, 0}
    local deskskillatk2_2 = unit.skills.TitanLMX_desk_atk2_2
    if deskskillatk2_2 then
      unit:castSkill(deskskillatk2_2, unit)
    end
    unit.TitanLMX_deskInAtk2b = nil
  elseif unit.TitanLMX_desk_movetime <= 0 and unit.TitanLMX_deskInAtk2c then
    unit.walk_v = {0, 0}
    local deskskillatk2_3 = unit.skills.TitanLMX_desk_atk2_3
    if deskskillatk2_3 then
      unit:castSkill(deskskillatk2_3, unit)
    end
    unit.TitanLMX_deskInAtk2c = nil
  end
  if unit.config.summoner and not unit.config.summoner:isAlive() then
    unit:die()
  end
end

function TitanLMX.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  skill.TitanLMX_cooking = TitanLMX.skillatk2_cookingFood(caster)
  local atkStage = 0
  if skill.TitanLMX_cooking ~= 4 then
    atkStage = skill.TitanLMX_cooking + (caster.TitanLMX_inUlt and 3 or 0)
    local puppetName = {
      "TitanLMX_a1.cha",
      "TitanLMX_a2.cha",
      "TitanLMX_a3.cha",
      "TitanLMX_u1.cha",
      "TitanLMX_u2.cha",
      "TitanLMX_u3.cha"
    }
    caster:rewritePuppetStack(1, puppetName[atkStage])
  else
    caster:rewritePuppetStack(1, "TitanLMX.cha")
  end
end

function TitanLMX.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.TitanLMX_hasArcana > 2 then
    caster:takeHeal(200, "mp", caster)
  end
end

function TitanLMX.skillatk2_cookingFood(caster)
  local baseProb = {
    1,
    1,
    1,
    0
  }
  for key, i in ipairs(baseProb) do
    baseProb[key] = i + caster.TitanLMX_ChefHeroes[key]
  end
  local counter = 0
  local maximun = 0
  for key, i in ipairs(baseProb) do
    maximun = maximun + i
  end
  local rand = ed.rand() * maximun
  for key, j in ipairs(baseProb) do
    counter = counter + j
    if rand < counter then
      return key
    end
  end
  return 1
end

function TitanLMX.skillatk2_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  local skillatk2a = caster.skills.TitanLMX_atk2a
  local skillatk2b = caster.skills.TitanLMX_atk2b
  local skillatk2c = caster.skills.TitanLMX_atk2c
  local skillulta = caster.skills.TitanLMX_ulta
  local skillultb = caster.skills.TitanLMX_ultb
  local skillultc = caster.skills.TitanLMX_ultc
  if caster.TitanLMX_inUlt and caster.TitanLMX_Arcana_ultCount > 0 then
    caster.TitanLMX_Arcana_ultCount = caster.TitanLMX_Arcana_ultCount - 1
    if skill.TitanLMX_cooking == 1 and skillulta then
      skillulta.cd_remaining = 0
    elseif skill.TitanLMX_cooking == 2 and skillultb then
      skillultb.cd_remaining = 0
    elseif skill.TitanLMX_cooking == 3 and skillultc then
      skillultc.cd_remaining = 0
    end
  else
    caster.TitanLMX_inUlt = nil
    if skill.TitanLMX_cooking == 1 and skillatk2a then
      skillatk2a.cd_remaining = 0
    elseif skill.TitanLMX_cooking == 2 and skillatk2b then
      skillatk2b.cd_remaining = 0
    elseif skill.TitanLMX_cooking == 3 and skillatk2c then
      skillatk2c.cd_remaining = 0
    end
  end
end

function TitanLMX.skillatk2a_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local desk = caster.TitanLMX_desk
  desk:enterActionStageFromOneStage(1, TitanLMX.TitanLMX_deskID)
  for i, buff in ipairs(desk.buff_list) do
    if buff.info.ID == TitanLMX.TitanLMX_desk_stun_BuffID then
      buff.timer = 0
    end
  end
  local launch_point = skill:launchPoint()
  desk.position = {
    launch_point[1],
    launch_point[2] - 25
  }
  desk.TitanLMX_deskInAtk2a = true
  desk.manual_moving = true
  desk.TitanLMX_desk_movetime = 0.5
  desk.walk_v = {
    400 * caster.direction,
    0
  }
end

function TitanLMX.skillatk2s_takeEffectAt(basefunc, skill, location, source)
  if skill.TitanLMX_inDesk then
    skill.TitanLMX_inDesk = nil
    basefunc(skill, location, source)
  else
    return
  end
end

function TitanLMX.skillatk2a_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk2a_s = caster.skills.TitanLMX_atk2a_s
  if skillatk2a_s and target then
    local max_mp = 0
    local s_target
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.mp < 700 and unit.mp < target.mp and unit.mp > 200 and max_mp < unit.mp and unit ~= caster and unit ~= target and not unit.config.is_summoned then
        max_mp = unit.mp
        s_target = unit
      end
    end
    if s_target then
      skillatk2a_s:takeEffectOn(s_target, caster)
    end
  end
  return basefunc(skill, target, source, shift)
end

function TitanLMX.skillatk2b_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local desk = caster.TitanLMX_desk
  desk:enterActionStageFromOneStage(2, TitanLMX.TitanLMX_deskID)
  for i, buff in ipairs(desk.buff_list) do
    if buff.info.ID == TitanLMX.TitanLMX_desk_stun_BuffID then
      buff.timer = 0
    end
  end
  if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  local launch_point = skill:launchPoint()
  desk.position = {
    launch_point[1],
    launch_point[2] - 25
  }
  desk.TitanLMX_deskInAtk2b = true
  desk.TitanLMX_deskSpeed = 400
  desk.manual_moving = true
  desk.TitanLMX_desk_movetime = 0.5
  desk.walk_v = {
    400 * caster.direction,
    0
  }
end

function TitanLMX.skillatk2c_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local desk = caster.TitanLMX_desk
  desk:enterActionStageFromOneStage(3, TitanLMX.TitanLMX_deskID)
  for i, buff in ipairs(desk.buff_list) do
    if buff.info.ID == TitanLMX.TitanLMX_desk_stun_BuffID then
      buff.timer = 0
    end
  end
  local launch_point = skill:launchPoint()
  desk.position = {
    launch_point[1],
    launch_point[2] - 25
  }
  desk.TitanLMX_deskInAtk2c = true
  desk.TitanLMX_deskSpeed = 400
  desk.manual_moving = true
  desk.TitanLMX_desk_movetime = 0.5
  desk.walk_v = {
    400 * caster.direction,
    0
  }
end

function TitanLMX.skillatk2c_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk2c_s = caster.skills.TitanLMX_atk2c_s
  local counter = 0
  if target and target:isAlive() and skillatk2c_s then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit ~= target and not unit.config.is_summoned and unit ~= caster then
        counter = counter + 1
        skillatk2c_s:takeEffectOn(unit, caster)
      end
    end
    if counter < 3 then
      return basefunc(skill, target, source, shift)
    end
    if caster.TitanXL_arrival == true then
      skillatk2c_s:takeEffectOn(caster, caster)
    end
  end
end

function TitanLMX.skillatk2c_s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target and target:isAlive() then
    local hp_perc = (target.attribs.HP - target.hp) / target.attribs.HP
    buff.info["Shield Value"] = (target.attribs.HP - target.hp) * 0.5 / (0.5 + hp_perc) + target.attribs.HP * skill.info["Script Arg2"]
    buff.shield = (target.attribs.HP - target.hp) * 0.5 / (0.5 + hp_perc) + target.attribs.HP * skill.info["Script Arg2"]
    buff.TitanLMX_oriShield = buff.shield
    buff.onDamaged = override(buff.onDamaged, TitanLMX.skillatk2c_s_buffOnDamaged)
  end
  return buff
end

function TitanLMX.skillatk2c_s_buffOnDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2c_s2
  if caster and caster:isAlive() then
    skillatk2c_s2 = caster.skills.TitanLMX_atk2c_s2
  end
  if skillatk2c_s2 and owner and owner:isAlive() and buff.TitanLMX_oriShield > 0 and buff.shield and 0 > buff.shield - damage then
    buff.TitanLMX_oriShield = -1
    skillatk2c_s2.TitanLMX_atk2c_s2_origin = owner.position
    skillatk2c_s2:takeEffectAt(owner.position, caster)
  end
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  return damage
end

function TitanLMX.skillatk2c_s2_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power, coeff = basefunc(skill, source, target, damage_type)
  if caster and caster.info.Name == "TitanLMX" and caster.TitanXL_arrival == true then
    power = power * 2
  end
  return power, coeff
end

function TitanLMX.skillatk2c_s2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if target and target:isAlive() and target.camp ~= caster.camp and target.get_knockedupbyLMX ~= true then
    local origin = skill.TitanLMX_atk2c_s2_origin
    local KRES = target.attribs.KnockRES
    local time = 0.5
    local distance = 150
    local bid = 4383
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.onRemoved = override(buff.onRemoved, TitanLMX.skillatk2c_s2_knockedupbyLMXBuff_onRemoved)
    target:addBuff(binfo, caster)
    target.get_knockedupbyLMX = true
    if target.position[1] >= 700 then
      distance = math.abs(790 - target.position[1])
    elseif target.position[1] <= 100 then
      distance = math.abs(target.position[1] - 10)
    end
    if KRES < 1 and 0 <= KRES then
      time = time * math.sqrt(KRES)
      distance = distance * KRES
    end
    if 0 < time or 0 < distance then
      local direction = {
        math.abs(target.position[1] - origin[1] or 1) / (target.position[1] - origin[1] or 1),
        0
      }
      target:knockup(time, ed.edpMult(direction, distance), shift)
    end
  end
  return basefunc(skill, target, source, shift)
end

function TitanLMX.skillatk2c_s2_knockedupbyLMXBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner then
    owner.get_knockedupbyLMX = false
  end
end

function TitanLMX.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster:isAlive() and ed.run_with_scene then
    local effect_name = "eff_buff_TitanLMX_ult.cha"
    local effect_z = 1
    ed.scene:playEffectOnScene(effect_name, caster.position, {1, 1}, nil, effect_z)
  end
end

function TitanLMX.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  if reason ~= "interrupt" then
    skill.caster.TitanLMX_inUlt = true
    if caster.TitanLMX_hasArcana > 3 then
      caster.TitanLMX_Arcana_ultCount = 2
    else
      caster.TitanLMX_Arcana_ultCount = 1
    end
  end
end

function TitanLMX.skillulta_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillulta_s = caster.skills.TitanLMX_ulta_s
  if skillulta_s then
    local max_damage1 = 0
    local max_damage2 = 0
    local max_unit1, max_unit2
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if not unit.buff_effects.uncontrollbale and max_damage1 < unit.battledata.damage and not unit.config.is_summoned then
        if max_damage2 < unit.battledata.damage then
          max_unit2 = unit
          max_damage2 = unit.battledata.damage
        else
          max_unit1 = unit
          max_damage1 = unit.battledata.damage
        end
      end
    end
    if max_unit1 then
      skillulta_s:takeEffectOn(max_unit1, caster)
    end
    if max_unit2 then
      skillulta_s:takeEffectOn(max_unit2, caster)
    end
  end
  return basefunc(skill, target, source, shift)
end

function TitanLMX.skillulta_s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.TitanLMX_ulta_s_dfDown = skill.info["Script Arg2"]
  buff.onRemoved = override(buff.onRemoved, TitanLMX.skillulta_s_buffOnRemoved)
  return buff
end

function TitanLMX.skillulta_s_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  if owner and owner:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.LMX_ulta_2_BuffID)
    local bbuff = ed.BuffCreate(binfo, owner, buff.caster or owner)
    bbuff:setAttribute("ARM", buff.TitanLMX_ulta_s_dfDown)
    bbuff:setAttribute("MR", buff.TitanLMX_ulta_s_dfDown)
    owner:addBuff(bbuff, buff.caster or owner)
  end
  basefunc(buff)
end

function TitanLMX.skillultb_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.TitanLMX_ultb_s_originDMG = target.battledata.damage
  buff.TitanLMX_ultb_s_shieldPerc = skill.info["Script Arg2"]
  buff.onRemoved = override(buff.onRemoved, TitanLMX.skillultb_buffOnRemoved)
  return buff
end

function TitanLMX.skillultb_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  if owner and owner:isAlive() then
    local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.LMX_ultb_2_BuffID)
    local bbuff = ed.BuffCreate(binfo, owner, buff.caster or owner)
    bbuff.info["Shield Value"] = (owner.battledata.damage - buff.TitanLMX_ultb_s_originDMG) * buff.TitanLMX_ultb_s_shieldPerc
    bbuff.shield = (owner.battledata.damage - buff.TitanLMX_ultb_s_originDMG) * buff.TitanLMX_ultb_s_shieldPerc
    owner:addBuff(bbuff, buff.caster or owner)
  end
  basefunc(buff)
end

function TitanLMX.skillultc_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanLMX_atk2
  local skillult = caster.skills.TitanLMX_ult
  local rand = ed.rand()
  local bbinfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_cooking_unctr_BuffID)
  caster:addBuff(bbinfo, caster)
  if caster.TitanLMX_hasArcana > 1 and rand < 0.35 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.LMX_arcana_atk2_BuffID)
    caster:addBuff(binfo, caster)
  end
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanLMX.TitanLMX_atk_stable_BuffID then
      buff.timer = 0
    end
  end
end

function TitanLMX.skillultc_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    caster.manual_moving = true
    caster.walk_v = {
      caster.direction * 300,
      0
    }
    local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_ult3_go_timer_BuffID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.TitanLMX_ultc = skill
    buff.update = override(buff.update, TitanLMX.skillultc_gobuffupdate)
    caster:addBuff(buff, caster)
  end
  basefunc(skill)
end

function TitanLMX.skillultc_gobuffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.position[1] > ed.engine.stage_rect.maxX or owner.position[1] < ed.engine.stage_rect.minX then
    buff.timer = 0
    buff.TitanLMX_ultc:finish()
  end
end

function TitanLMX.skillultc_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  local skillultc_s2 = caster.skills.TitanLMX_ultc_s2
  local skillultc_s3 = caster.skills.TitanLMX_ultc_s3
  if skillultc_s2 then
    local projectile = skillultc_s2:createProjectile()
    projectile.direction = -caster.direction
    projectile.velocity[1] = 300 * projectile.direction
    projectile.max_distance = math.abs(projectile.position[1] - 400)
    projectile.height = 1
    projectile.collideCheck = override(projectile.collideCheck, TitanLMX.ultc_s2_projectile_collideCheck)
    caster.TitanLMX_skillultc_projectile = projectile
    ed.engine:addProjectile(projectile)
  end
  if skillultc_s3 then
    caster:castSkill(skillultc_s3, caster)
    local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_ult3_return_timer_BuffID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.TitanLMX_ultc = skillultc_s3
    buff.update = override(buff.update, TitanLMX.skillultc_returnbuffupdate)
    caster:addBuff(buff, caster)
    caster.walk_v = {
      caster.direction * -300,
      0
    }
  end
end

function TitanLMX.skillultc_s2_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power, coeff = basefunc(skill, source, target, damage_type)
  if caster and caster.info.Name == "TitanLMX" and caster.TitanXL_arrival == true then
    power = power * 2
  end
  return power, coeff
end

function TitanLMX.ultc_s2_projectile_collideCheck(basefunc, self, unit)
  local t = basefunc(self, unit)
  local u_pos = unit.position
  local t_pos = self.position
  if u_pos and t_pos then
    if (u_pos[1] - t_pos[1]) ^ 2 <= 40000 and (u_pos[2] - t_pos[2]) ^ 2 <= 40000 then
      return true
    else
      return false
    end
  else
    return false
  end
  return t
end

function TitanLMX.skillultc_returnbuffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.direction > 0 and owner.position[1] <= 500 or owner.direction < 0 and owner.position[1] >= 300 then
    owner.TitanLMX_skillultc_projectile:terminate()
    owner.walk_v = {0, 0}
    buff.timer = -1
    buff.TitanLMX_ultc:startPhase(10)
  end
end

function TitanLMX.skillultc_s3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.current_phase_idx == 10 then
    local caster = skill.caster
    local skillultc_s = caster.skills.TitanLMX_ultc_s
    if skillultc_s then
      skillultc_s:selectTarget()
      if skillultc_s.target then
        local region = skillultc_s:createRegion()
        region.position = {
          400,
          caster.position[2]
        }
        ed.engine:addRegion(region)
      end
    end
  end
end

function TitanLMX.skillatk2s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local rand = ed.rand()
  local bbinfo = ed.lookupDataTable("Buff", nil, TitanLMX.TitanLMX_cooking_unctr_BuffID)
  caster:addBuff(bbinfo, caster)
  if caster.TitanLMX_hasArcana > 1 and rand < 0.35 then
    local binfo = ed.lookupDataTable("Buff", nil, TitanLMX.LMX_arcana_atk2_BuffID)
    caster:addBuff(binfo, caster)
  end
end

function TitanLMX.skillatk2s_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanLMX.LMX_arcana_atk2_BuffID or buff.info.ID == TitanLMX.LMX_atk2_BuffID or buff.info.ID == TitanLMX.TitanLMX_cooking_unctr_BuffID then
      buff.timer = 0
    end
  end
end

function TitanLMX.skillultc_s3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanLMX.LMX_arcana_atk2_BuffID or buff.info.ID == TitanLMX.LMX_atk2_BuffID or buff.info.ID == TitanLMX.TitanLMX_cooking_unctr_BuffID then
      buff.timer = 0
    end
  end
  local skillatk2 = caster.skills.TitanLMX_atk2
  local skillult = caster.skills.TitanLMX_ult
  local skillultc_s4 = caster.skills.TitanLMX_ultc_s4
  if skillatk2 then
    skillatk2.cd_remaining = skillatk2.info.CD
  end
  if skillult then
    skillult.cd_remaining = skillult.info.CD
  end
  if skillultc_s4 then
    caster:castSkill(skillultc_s4, caster)
    caster.TitanLMX_ultc_s4 = skillultc_s4
  end
  if caster.TitanXL_arrival == true then
    local skillatk2c_s = caster.skills.TitanLMX_atk2c_s
    skillatk2c_s:takeEffectOn(caster, caster)
  end
  caster.TitanLMX_ultMoving = true
  caster.walk_v = {
    caster.direction * -300,
    0
  }
end

function TitanLMX.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillultc = caster.skills.TitanLMX_ultc
  local skillultc_s = caster.skills.TitanLMX_ultc_s
  local skillultc_s2 = caster.skills.TitanLMX_ultc_s2
  local skillultc_s3 = caster.skills.TitanLMX_ultc_s3
  if skill.cd_remaining > 0 then
    return false, "CD>0"
  end
  if (not skillultc or not skillultc.casting) and (not skillultc_s3 or not skillultc_s3.casting) and not skill.casting then
    return true
  else
    return false, "TitanLMX_skillultc_isCasting"
  end
end

function TitanLMX.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local skillultc = caster.skills.TitanLMX_ultc
  local skillultc_s = caster.skills.TitanLMX_ultc_s
  local skillultc_s2 = caster.skills.TitanLMX_ultc_s2
  local skillultc_s3 = caster.skills.TitanLMX_ultc_s3
  if caster.mp < 1000 or skill.cd_remaining > 0 then
    return false, "TitanLMX_not_enough_energy"
  end
  if (not skillultc or not skillultc.casting) and (not skillultc_s3 or not skillultc_s3.casting) and not skill.casting then
    return true
  else
    return false, "TitanLMX_skillultc_isCasting"
  end
end

function TitanLMX.init_hero(hero)
  local skillatk = hero.skills.TitanLMX_atk
  local skillatk2 = hero.skills.TitanLMX_atk2
  local skillatk2a = hero.skills.TitanLMX_atk2a
  local skillatk2b = hero.skills.TitanLMX_atk2b
  local skillatk2c = hero.skills.TitanLMX_atk2c
  local skillulta = hero.skills.TitanLMX_ulta
  local skillultb = hero.skills.TitanLMX_ultb
  local skillultc = hero.skills.TitanLMX_ultc
  local skillult = hero.skills.TitanLMX_ult
  local skillatk2c_s = hero.skills.TitanLMX_atk2c_s
  local skillatk2c_s2 = hero.skills.TitanLMX_atk2c_s2
  local skillulta_s = hero.skills.TitanLMX_ulta_s
  local skillultc_s = hero.skills.TitanLMX_ultc_s
  local skillultc_s2 = hero.skills.TitanLMX_ultc_s2
  local skillultc_s3 = hero.skills.TitanLMX_ultc_s3
  hero.TitanLMX_ChefHeroes = {
    0,
    0,
    0,
    0
  }
  hero.init_Walk_v = hero.walk_v
  hero.initdirection = hero:getInitDir()
  hero.TitanXL_arrival = false
  hero.reset = override(hero.reset, TitanLMX.hero_reset)
  hero.die = override(hero.die, TitanLMX.hero_die)
  hero.update = override(hero.update, TitanLMX.hero_update)
  hero.TitanLMX_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.start = override(skillatk.start, TitanLMX.skillatk_start)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanLMX.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanLMX.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, TitanLMX.skillatk2_finish)
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, TitanLMX.skillatk2_canCastWithTarget)
  end
  if skillatk2a then
    skillatk2a.start = override(skillatk2a.start, TitanLMX.skillatk2s_start)
    skillatk2a.onAttackFrame = override(skillatk2a.onAttackFrame, TitanLMX.skillatk2a_onAttackFrame)
    skillatk2a.takeEffectAt = override(skillatk2a.takeEffectAt, TitanLMX.skillatk2s_takeEffectAt)
    skillatk2a.takeEffectOn = override(skillatk2a.takeEffectOn, TitanLMX.skillatk2a_takeEffectOn)
    skillatk2a.finish = override(skillatk2a.finish, TitanLMX.skillatk2s_finish)
  end
  if skillatk2b then
    skillatk2b.start = override(skillatk2b.start, TitanLMX.skillatk2s_start)
    skillatk2b.takeEffectAt = override(skillatk2b.takeEffectAt, TitanLMX.skillatk2s_takeEffectAt)
    skillatk2b.onAttackFrame = override(skillatk2b.onAttackFrame, TitanLMX.skillatk2b_onAttackFrame)
    skillatk2b.finish = override(skillatk2b.finish, TitanLMX.skillatk2s_finish)
  end
  if skillatk2c then
    skillatk2c.start = override(skillatk2c.start, TitanLMX.skillatk2s_start)
    skillatk2c.takeEffectAt = override(skillatk2c.takeEffectAt, TitanLMX.skillatk2s_takeEffectAt)
    skillatk2c.onAttackFrame = override(skillatk2c.onAttackFrame, TitanLMX.skillatk2c_onAttackFrame)
    skillatk2c.takeEffectOn = override(skillatk2c.takeEffectOn, TitanLMX.skillatk2c_takeEffectOn)
    skillatk2c.createBuff = override(skillatk2c.createBuff, TitanLMX.skillatk2c_s_createBuff)
    skillatk2c_s.createBuff = override(skillatk2c_s.createBuff, TitanLMX.skillatk2c_s_createBuff)
    skillatk2c_s2.takeEffectOn = override(skillatk2c_s2.takeEffectOn, TitanLMX.skillatk2c_s2_takeEffectOn)
    skillatk2c_s2.power = override(skillatk2c_s2.power, TitanLMX.skillatk2c_s2_power)
    skillatk2c.finish = override(skillatk2c.finish, TitanLMX.skillatk2s_finish)
  end
  if skillult then
    skillult.finish = override(skillult.finish, TitanLMX.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanLMX.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanLMX.skillult_canCastWithTarget)
  end
  if skillulta then
    skillulta.start = override(skillulta.start, TitanLMX.skillatk2s_start)
    skillulta.takeEffectOn = override(skillulta.takeEffectOn, TitanLMX.skillulta_takeEffectOn)
    skillulta_s.createBuff = override(skillulta_s.createBuff, TitanLMX.skillulta_s_createBuff)
    skillulta.finish = override(skillulta.finish, TitanLMX.skillatk2s_finish)
  end
  if skillultb then
    skillultb.start = override(skillultb.start, TitanLMX.skillatk2s_start)
    skillultb.createBuff = override(skillultb.createBuff, TitanLMX.skillultb_createBuff)
    skillultb.finish = override(skillultb.finish, TitanLMX.skillatk2s_finish)
  end
  if skillultc then
    skillultc.start = override(skillultc.start, TitanLMX.skillultc_start)
    skillultc.onPhaseFinished = override(skillultc.onPhaseFinished, TitanLMX.skillultc_onPhaseFinished)
    skillultc.finish = override(skillultc.finish, TitanLMX.skillultc_finish)
    skillultc_s2.power = override(skillultc_s2.power, TitanLMX.skillultc_s2_power)
    skillultc_s3.onAttackFrame = override(skillultc_s3.onAttackFrame, TitanLMX.skillultc_s3_onAttackFrame)
    skillultc_s3.finish = override(skillultc_s3.finish, TitanLMX.skillultc_s3_finish)
  end
  return hero
end

return TitanLMX.init_hero
