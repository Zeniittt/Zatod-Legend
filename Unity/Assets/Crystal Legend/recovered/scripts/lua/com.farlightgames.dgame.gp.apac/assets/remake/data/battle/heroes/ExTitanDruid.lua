module("ed.battlehero", package.seeall)
local ed = ed
ExTitanDruid = {}
ExTitanDruid.ExTitanDruid_fashion_ID = 100761

function ExTitanDruid.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if ExTitanDruid.ExTitanDruid_fashion_ID and ExTitanDruid.ExTitanDruid_fashion_ID == caster.fashion_id then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_ExTitanDruid_atk_Bamboo.cha"
    })
  end
  basefunc(skill, target)
end

function ExTitanDruid.skillatk2enter_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skillatk2 = skill.caster.skills.ExTitanDruid_atk2
  local binfo = ed.lookupDataTable("Buff", nil, 11007608)
  skill.caster:addBuff(binfo, skill.caster)
  local caster = skill.caster
  local atk2level
  if caster and caster.skills.ExTitanDruid_atk2 then
    atk2level = caster.skills.ExTitanDruid_atk2.level
  end
  if caster and not caster.ExTitanDruid_callBear then
    caster.ExTitanDruid_callBear = 0
  end
  if caster.ExTitanDruid_callBear == 0 then
    caster.ExTitanDruid_callBear = 1
    local skilllevel = {
      skill.level,
      skill.level,
      skill.level,
      skill.level,
      skill.level
    }
    local Bear_id = 337
    local Bear_rank = caster.rank
    if caster and caster:isAlive() then
      local proto = {
        _tid = Bear_id,
        _level = atk2level or 1,
        _skill_levels = skilllevel,
        _stars = caster.stars,
        _rank = Bear_rank
      }
      local config = {
        is_monster = true,
        estimate_rank = true,
        hp_mod = caster.config.hp_mod or 1,
        dps_mod = caster.config.dps_mod or 1,
        summoner = caster
      }
      local Bear = ed.UnitCreate(proto, caster.camp, config)
      local pos = {
        400 * (caster.position[1] - 400) / math.abs(caster.position[1] - 400) + 400,
        math.min(caster.position[2] - 40)
      }
      Bear.direction = caster.direction
      Bear.father = caster
      Bear.ExDruidBear_rank = 1
      Bear.ExDruidBear_extraAD = 0
      Bear.ExDruidBear_ADcount = 0
      Bear.collectHPchange = override(Bear.collectHPchange, ExTitanDruid.Bear_collectHPchange)
      Bear.ExDruidBear_Dying = false
      Bear.ExDruidBear_stageEnd = false
      ed.engine:summonUnit(Bear, pos, caster, "Idle")
      Bear.ExDruidBear_baseAD = Bear.attribs.AD
      if ExTitanDruid.ExTitanDruid_fashion_ID and ExTitanDruid.ExTitanDruid_fashion_ID == caster.fashion_id then
        Bear:enterActionStageFromOneStage(Bear.ExDruidBear_rank + 5, 337)
      else
        Bear:enterActionStageFromOneStage(Bear.ExDruidBear_rank, 337)
      end
      local AttriBinfo = ed.lookupDataTable("Buff", nil, 11007601)
      local attribratio = skillatk2.info["Script Arg3"] / 100
      if skillatk2 then
        if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
          attribratio = attribratio + skillatk2.evo_rank1["Script Arg1"] / 100
        end
        if skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
          attribratio = attribratio + skillatk2.evo_rank2["Script Arg1"] / 100
        end
      end
      ExTitanDruid.changeBuffInfo(AttriBinfo, attribratio, Bear, 2)
      local buff = Bear:addBuff(AttriBinfo, caster)
      Bear:takeHeal(Bear.attribs.HP, "hp", caster)
      caster.ExTitanDruid_Bear = Bear
      Bear.die = override(Bear.die, function(basefunc, unit, killer)
        if not ed.engine.beingEnd and unit.father and unit.father:isAlive() then
          return
        end
        local owner = unit.father
        owner.ExTitanDruid_Bear = nil
        owner.ExTitanDruid_callBear = nil
        if not ed.engine.running then
          unit:setDeathWithEffectOrNot(true)
        end
        basefunc(unit, killer)
      end)
    end
  end
  skillatk2.cd_remaining = 3
  skill.cd_remaining = 999
end

function ExTitanDruid.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.collideCheck = override(projectile.collideCheck, ExTitanDruid.atk2projectile_collideCheck)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    skill.caster.ExTitanDruid_Bear.position[1] + 10,
    skill.caster.ExTitanDruid_Bear.position[2]
  }
  local launchposition, h = skill:launchPoint()
  local distance = ed.edpSub(target_position, {
    launchposition[1],
    launchposition[2]
  })
  projectile.velocity = ed.edpMult(distance, 1 / t)
  ed.engine:addProjectile(projectile)
  return nil
end

function ExTitanDruid.atk2projectile_collideCheck(basefunc, tile, unit)
  local t = basefunc(tile, unit)
  if unit ~= tile.caster.ExTitanDruid_Bear then
    return false
  end
  return t
end

function ExTitanDruid.changeBuffInfo(buffInfo, enhance, target, mode)
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
      if mode == 1 then
        buffInfo[name .. ".a"] = enhance * (target.ExDruidBear_rank - 1)
      elseif mode == 2 then
        buffInfo[name .. ".a"] = enhance
      end
    end
  end
end

function ExTitanDruid.skillatk2enter_finish(basefunc, skill, reason)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == 11007608 then
      buff.timer = 0
    end
  end
  basefunc(skill, reason)
end

function ExTitanDruid.Bear_collectHPchange(basefunc, unit, config)
  local hero = unit.father
  local skillatk2 = hero.skills.ExTitanDruid_atk2
  local skillatk3 = hero.skills.ExTitanDruid_atk3
  local percent = 0.6
  if hero.level <= 35 then
    percent = 0.65
  elseif hero.level <= 45 then
    percent = 0.7
  elseif hero.level <= 55 then
    percent = 0.75
  elseif hero.level <= 65 then
    percent = 0.8
  elseif hero.level <= 75 then
    percent = 0.85
  elseif hero.level <= 85 then
    percent = 0.9
  elseif hero.level > 90 then
    percent = 0.95
  end
  local hpchange = config.hp_change
  local Bear_skillatk2 = unit.skills.ExDruidBear_atk2
  basefunc(unit, config)
  if config.hp_change < 0 and unit.ExDruidBear_Dying == false then
    if config.unit == unit.father and config.hp_change < 0 then
      if math.floor(unit.father.attribs.HPR * 0.125) == math.floor(config.hp_change) then
        unit.notPopupBattleInfo = true
        unit.father.notPopupBattleInfo = true
      end
      unit:takeDamage(math.abs(hpchange * percent), "Holy", "hp", unit.father, 1, 1, 0)
      config.hp_change = hpchange * (1 - percent)
      unit.notPopupBattleInfo = false
      unit.father.notPopupBattleInfo = false
    end
    if unit.ExDruidBear_rank > 2 then
      if math.floor(config.unit.attribs.HPR * 0.125) ~= math.floor(config.hp_change) then
        local extraAD = math.min(5000, math.abs(config.hp_change))
        unit.ExDruidBear_extraAD = unit.ExDruidBear_extraAD + extraAD
      else
        local extraAD = math.min(625, math.abs(config.hp_change))
        unit.ExDruidBear_extraAD = unit.ExDruidBear_extraAD + extraAD
      end
      if skillatk3 and 5000 < unit.ExDruidBear_extraAD then
        local adratio = 0.03
        if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
          adratio = 0.035
        end
        if skillatk3.evo_rank and 2 <= skillatk3.evo_rank then
          adratio = 0.04
        end
        unit.attribs.AD = math.min(unit.ExDruidBear_baseAD * 2.6, unit.attribs.AD + adratio * unit.ExDruidBear_baseAD)
        unit.ExDruidBear_extraAD = unit.ExDruidBear_extraAD - 5000
      end
    end
  end
end

function ExTitanDruid.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2enter = caster.skills.ExTitanDruid_atk2enter
  if not caster.ExTitanDruid_Bear or next(caster.ExTitanDruid_Bear) == nil or not caster.ExTitanDruid_Bear:isAlive() then
    skillatk2enter.onAttackFrame = override(skillatk2enter.onAttackFrame, ExTitanDruid.skillatk2enter_onAttackFrame)
    skillatk2enter.finish = override(skillatk2enter.finish, ExTitanDruid.skillatk2enter_finish)
    caster:castSkill(skillatk2enter, nil)
    skill.cd_remaining = skill.info.CD
    return
  else
    target = caster.ExTitanDruid_Bear
    local originfo = skill.info
    local transBinfo = ed.lookupDataTable("Buff", nil, 11007610)
    if target and target.ExDruidBear_Dying == false then
      target:addBuff(transBinfo, skill.caster)
    end
    if ExTitanDruid.ExTitanDruid_fashion_ID and ExTitanDruid.ExTitanDruid_fashion_ID == caster.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_ExTitanDruid_atk2sub_Bamboo.cha"
      })
    end
    basefunc(skill, target)
    skill.info = originfo
  end
end

function ExTitanDruid.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local bear = caster.ExTitanDruid_Bear
  local percent = skill.info["Script Arg2"]
  if bear then
    if bear.ExDruidBear_Dying == false then
      local bear_transform = bear.skills.ExDruidBear_transform
      bear:castSkill(bear_transform, bear)
      local HP_percent = bear.hp / bear.attribs.HP
      if bear.ExDruidBear_rank >= 1 and bear.ExDruidBear_rank < 5 then
        bear.ExDruidBear_rank = bear.ExDruidBear_rank + 1
        local UpgradeBinfo = ed.lookupDataTable("Buff", nil, 11007603)
        local Upattrib = skill.info["Script Arg2"] / 100
        ExTitanDruid.changeBuffInfo(UpgradeBinfo, Upattrib, bear, 1)
        bear:addBuff(UpgradeBinfo, caster)
      end
      bear.ExDruidBear_baseAD = bear.attribs.AD
      bear.hp = bear.attribs.HP * HP_percent
      bear:takeHeal(bear.attribs.HP * 0.03, "hp", caster)
      if bear.ExDruidBear_rank >= 5 then
        skill.cd_remaining = 999
      end
    else
      return
    end
  end
  basefunc(skill)
end

function ExTitanDruid.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local HPR = buff.info.HPR
  local caster = skill.caster
  local bear = caster.ExTitanDruid_Bear
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", HPR - skill.evo_rank3["Script Arg1"])
  end
  if bear and bear.ExDruidBear_Dying == false then
    bear:takeHeal(bear.attribs.HP * 0.03, "hp", caster)
  end
  buff.update = override(buff.update, ExTitanDruid.skillatk4_buffUpdate)
  return buff
end

function ExTitanDruid.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4 = caster.skills.ExTitanDruid_atk4
  local ExDruidBear_hpr = buff.info.HPR * dt
  if ExDruidBear_hpr < 0 then
    local ExDruidBear_damage = math.min(-ExDruidBear_hpr, buff.owner.hp)
    ExDruidBear_damage = ExDruidBear_damage * buff.owner.dPSStatisticsRatio
    if buff.caster.ExTitanDruid_Bear and next(buff.caster.ExTitanDruid_Bear) then
      buff.caster.ExTitanDruid_Bear.notPopupBattleInfo = true
      buff.caster.ExTitanDruid_Bear:takeHeal(math.abs(ExDruidBear_damage), "hp")
      buff.caster.ExTitanDruid_Bear.notPopupBattleInfo = false
    end
  end
end

function ExTitanDruid.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  skill.caster.ExTitanDruid_timer = 0
  skill.caster.ExTitanDruid_ultcount = true
  local bear = caster.ExTitanDruid_Bear
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanDruid_ult.cha"
    if not effect_name then
      return
    end
    skill.ExTitanDruid_node = ed.scene:playEffectOnScene(effect_name, {400, -50}, nil, nil, 1)
  end
  if skill.evo_rank and skill.evo_rank >= 3 and skill.caster.ExTitanDruid_Bear and skill.caster.ExTitanDruid_Bear:isAlive() and skill.caster.ExTitanDruid_Bear.ExDruidBear_Dying == false then
    local binfo = ed.lookupDataTable("Buff", nil, 11007613)
    local buffatk = skill.caster.ExTitanDruid_Bear:addBuff(binfo, skill.caster.ExTitanDruid_Bear)
  end
  if bear and bear.ExDruidBear_Dying == false then
    bear:takeHeal(bear.attribs.HP * 0.03, "hp", skill.caster)
  end
end

function ExTitanDruid.ult_update(basefunc, unit, dt)
  local skillult = unit.skills.ExTitanDruid_ult
  if skillult and not unit:isAlive() then
    if skillult.ExTitanDruid_node then
      ed.scene:removeEffect(skillult.ExTitanDruid_node, 1)
    end
    skillult:finish("interrupt")
  end
  if unit.ExTitanDruid_ultcount == true then
    unit.ExTitanDruid_timer = unit.ExTitanDruid_timer + 1
    if unit.ExTitanDruid_timer == 25 then
      local skill = unit.skills.ExTitanDruid_ult
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
        skill.caster.manually_casting = false
      end
      skill.attack_counter = skill.attack_counter + 1
      if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
        skill:selectTarget(nil)
      end
      if not skill.target then
        return
      end
      local info = skill.info
      local caster = skill.caster
      local ttype = info["Track Type"]
      local MPGR = caster.attribs.MPGainRatio
      skill:createTrackType(ttype)
      if MPGR == nil or MPGR == 1 then
        caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
      else
        caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      end
      if info["Move Forward"] ~= 0 then
        caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
      end
      unit.ExTitanDruid_ultcount = false
      unit.ExTitanDruid_timer = nil
    end
  end
  if unit.ExTitanDruid_Bear then
    if unit.ExTitanDruid_Bear.ExDruidBear_Dying then
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 152 then
          tbuff.timer = -1
          unit.hasUncontrollableBuff = false
        end
      end
    elseif not unit.hasUncontrollableBuff then
      local bid = 152
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff2 = unit:addBuff(binfo, unit)
      unit.hasUncontrollableBuff = true
    end
  end
  basefunc(unit, dt)
end

function ExTitanDruid.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local info = skill.info
  for i, ubuff in ipairs(target.buff_list) do
    if ubuff.info.ID == 11007604 then
      local binfo = ed.lookupDataTable("Buff", nil, 11007606)
      local sbuff = target:addBuff(binfo, caster)
      if skill.evo_rank and skill.evo_rank >= 2 then
        sbuff:setAttribute("ARM", -skill.evo_rank2["Script Arg1"])
        sbuff:setAttribute("MR", -skill.evo_rank2["Script Arg1"])
      end
    end
  end
  return power, coeff
end

function ExTitanDruid.Dying_takeBear_toDeath(basefunc, unit, skiller)
  basefunc(unit, skiller)
  if unit.ExTitanDruid_Bear and next(unit.ExTitanDruid_Bear) then
    unit.ExTitanDruid_Bear:die(skiller)
  end
end

function ExTitanDruid.init_hero(hero)
  local skillult = hero.skills.ExTitanDruid_ult
  local skillatk = hero.skills.ExTitanDruid_atk
  local skillatk2 = hero.skills.ExTitanDruid_atk2
  local skillatk3 = hero.skills.ExTitanDruid_atk3
  local skillatk4 = hero.skills.ExTitanDruid_atk4
  local skillatk2enter = hero.skills.ExTitanDruid_atk2enter
  hero.ExTitanDruid_ultcount = false
  hero.ExTitanDruid_timer = 0
  if skillatk and ExTitanDruid.ExTitanDruid_fashion_ID and ExTitanDruid.ExTitanDruid_fashion_ID == hero.fashion_id then
    skillatk.start = override(skillatk.start, ExTitanDruid.skillatk_start)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, ExTitanDruid.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, ExTitanDruid.skillatk2_start)
    skillatk2.createProjectile = override(skillatk2.createProjectile, ExTitanDruid.skillatk2_createProjectile)
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    skillatk4.createBuff = override(skillatk4.createBuff, ExTitanDruid.skillatk4_CreateBuff)
  end
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    skillult.onAttackFrame = override(skillult.onAttackFrame, ExTitanDruid.skillult_onAttackFrame)
    skillult.power = override(skillult.power, ExTitanDruid.skillult_power)
  end
  hero.onDying = override(hero.onDying, ExTitanDruid.Dying_takeBear_toDeath)
  hero.die = override(hero.die, ExTitanDruid.Dying_takeBear_toDeath)
  hero.update = override(hero.update, ExTitanDruid.ult_update)
  return hero
end

return ExTitanDruid.init_hero
