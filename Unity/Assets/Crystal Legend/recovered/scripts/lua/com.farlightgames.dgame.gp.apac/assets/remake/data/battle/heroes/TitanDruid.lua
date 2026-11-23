module("ed.battlehero", package.seeall)
local ed = ed
TitanDruid = {}
TitanDruid.TitanDruid_fashion_ID = 100761

function TitanDruid.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if TitanDruid.TitanDruid_fashion_ID and TitanDruid.TitanDruid_fashion_ID == caster.fashion_id then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_TitanDruid_fashion_1_atk.cha"
    })
  end
  basefunc(skill, target)
end

function TitanDruid.skillatk2enter_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skillatk2 = skill.caster.skills.TitanDruid_atk2
  local skillatk3 = skill.caster.skills.TitanDruid_atk3
  local binfo = ed.lookupDataTable("Buff", nil, 11007608)
  skill.caster:addBuff(binfo, skill.caster)
  local caster = skill.caster
  local atk2level
  if caster and caster.skills.TitanDruid_atk2 then
    atk2level = caster.skills.TitanDruid_atk2.level
  end
  if caster and not caster.TitanDruid_callBear then
    caster.TitanDruid_callBear = 0
  end
  if caster.TitanDruid_callBear == 0 then
    caster.TitanDruid_callBear = 1
    local skilllevel = {
      skill.level,
      skill.level,
      skill.level,
      skill.level,
      skill.level
    }
    if skillatk3 then
      skilllevel = {
        skillatk3.level,
        skillatk3.level,
        skillatk3.level,
        skillatk3.level,
        skillatk3.level
      }
    end
    local Bear_id = 266
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
      Bear.DruidBear_rank = 1
      Bear.DruidBear_extraAD = 0
      Bear.DruidBear_ADcount = 0
      Bear.collectHPchange = override(Bear.collectHPchange, TitanDruid.Bear_collectHPchange)
      Bear.DruidBear_Dying = false
      Bear.DruidBear_stageEnd = false
      ed.engine:summonUnit(Bear, pos, caster, "Idle")
      if TitanDruid.TitanDruid_fashion_ID and TitanDruid.TitanDruid_fashion_ID == caster.fashion_id then
        Bear:enterActionStageFromOneStage(Bear.DruidBear_rank + 5, 266)
      else
        Bear:enterActionStageFromOneStage(Bear.DruidBear_rank, 266)
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
      TitanDruid.changeBuffInfo(AttriBinfo, attribratio, Bear, 2)
      Bear:addBuff(AttriBinfo, caster)
      Bear:takeHeal(Bear.attribs.HP, "hp")
      Bear.DruidBear_baseAD = Bear.attribs.AD
      local bid = 11007617
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = Bear:addBuff(binfo, caster)
      buff.update_timer = 1
      buff.update = override(buff.update, TitanDruid.bearadbuff_update)
      local bearskillatk3 = Bear.skills.DruidBear_atk3
      caster.TitanDruid_Bear = Bear
      Bear.die = override(Bear.die, function(basefunc, unit, killer)
        if not ed.engine.beingEnd and unit.father and unit.father:isAlive() then
          return
        end
        local owner = unit.father
        owner.TitanDruid_Bear = nil
        owner.TitanDruid_callBear = nil
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

function TitanDruid.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.collideCheck = override(projectile.collideCheck, TitanDruid.atk2projectile_collideCheck)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    skill.caster.TitanDruid_Bear.position[1] + 10,
    skill.caster.TitanDruid_Bear.position[2]
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

function TitanDruid.atk2projectile_collideCheck(basefunc, tile, unit)
  local t = basefunc(tile, unit)
  if unit ~= tile.caster.TitanDruid_Bear then
    return false
  end
  return t
end

function TitanDruid.changeBuffInfo(buffInfo, enhance, target, mode)
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
      if x == "HP" and ed.engine.rogue_mode then
        enhance = enhance / target.config.hp_mod
      end
      if mode == 1 then
        buffInfo[name .. ".a"] = enhance
      elseif mode == 2 then
        buffInfo[name .. ".a"] = enhance
      end
    end
  end
end

function TitanDruid.skillatk2enter_finish(basefunc, skill, reason)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == 11007608 then
      buff.timer = 0
    end
  end
  basefunc(skill, reason)
end

function TitanDruid.Bear_collectHPchange(basefunc, unit, config)
  local skillatk2 = unit.father.skills.TitanDruid_atk2
  local skillatk3 = unit.father.skills.TitanDruid_atk3
  local percent = 0.5
  local hpchange = config.hp_change
  local hppresent = config.hp
  local Bear_skillatk2 = unit.skills.DruidBear_atk2
  if hpchange < 0 and unit.DruidBear_Dying == false and unit.DruidBear_rank >= 2 then
    if math.floor(config.unit.attribs.HPR * 0.125) ~= math.floor(hpchange) then
      local extraAD = math.min(5000, math.abs(hpchange))
      unit.DruidBear_extraAD = unit.DruidBear_extraAD + extraAD
    else
      local extraAD = math.min(625, math.abs(hpchange))
      unit.DruidBear_extraAD = unit.DruidBear_extraAD + extraAD
    end
    if skillatk3 and 5000 < unit.DruidBear_extraAD then
      local adratio = 0.03
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        adratio = 0.035
      end
      if skillatk3.evo_rank and 2 <= skillatk3.evo_rank then
        adratio = 0.04
      end
      if not unit.bonusad then
        unit.bonusad = 0
      end
      unit.bonusad = math.min(unit.DruidBear_baseAD * 1.2, unit.bonusad + adratio * unit.DruidBear_baseAD)
      unit.DruidBear_extraAD = unit.DruidBear_extraAD - 5000
    end
  end
end

function TitanDruid.bearadbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local bonusad = owner.bonusad
  local timer = buff.update_timer - dt
  while timer <= 0 do
    timer = 1
    buff:setAttribute("AD", bonusad)
    owner:rebuild()
  end
  buff.update_timer = timer
end

function TitanDruid.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local bear = caster.TitanDruid_Bear
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if bear and bear.DruidBear_Dying then
    return false, "DruidBear_Dying"
  end
  return true
end

function TitanDruid.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2enter = caster.skills.TitanDruid_atk2enter
  if not caster.TitanDruid_Bear or next(caster.TitanDruid_Bear) == nil or not caster.TitanDruid_Bear:isAlive() then
    skillatk2enter.onAttackFrame = override(skillatk2enter.onAttackFrame, TitanDruid.skillatk2enter_onAttackFrame)
    skillatk2enter.finish = override(skillatk2enter.finish, TitanDruid.skillatk2enter_finish)
    caster:castSkill(skillatk2enter, nil)
    skill.cd_remaining = skill.info.CD
    return
  else
    target = caster.TitanDruid_Bear
    local transBinfo = ed.lookupDataTable("Buff", nil, 11007610)
    if target and target.DruidBear_Dying == false then
      target:addBuff(transBinfo, skill.caster)
    end
    basefunc(skill, target)
  end
end

function TitanDruid.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local bear = caster.TitanDruid_Bear
  local percent = skill.info["Script Arg2"]
  local skillatk3 = caster.skills.TitanDruid_atk3
  if bear then
    if bear.DruidBear_Dying == false then
      local bear_transform = bear.skills.DruidBear_transform
      bear:castSkill(bear_transform, bear)
      local HP_percent = bear.hp / bear.attribs.HP
      if bear.DruidBear_rank >= 1 and bear.DruidBear_rank < 5 then
        bear.DruidBear_rank = bear.DruidBear_rank + 1
        local UpgradeBinfo = ed.lookupDataTable("Buff", nil, 11007603)
        local Upattrib = skill.info["Script Arg2"] / 100
        TitanDruid.changeBuffInfo(UpgradeBinfo, Upattrib, bear, 1)
        bear:addBuff(UpgradeBinfo, caster)
      end
      bear.hp = bear.attribs.HP * HP_percent
      if bear.DruidBear_rank >= 5 then
        skill.cd_remaining = 999
        if not skillatk3 then
          local bearskillatk3 = bear.skills.DruidBear_atk3
          bearskillatk3.info = ed.wraptable(bearskillatk3.info, {
            ["Init CD"] = 999,
            CD = 999
          })
        end
      end
    else
      return
    end
  end
  basefunc(skill)
end

function TitanDruid.skillatk4_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local HPR = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", HPR - skill.evo_rank3["Script Arg1"])
  end
  buff.update = override(buff.update, TitanDruid.skillatk4_buffUpdate)
  return buff
end

function TitanDruid.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanDruid_atk4
  local DruidBear_hpr = buff.info.HPR * dt
  if DruidBear_hpr < 0 then
    local DruidBear_damage = math.min(-DruidBear_hpr, buff.owner.hp)
    DruidBear_damage = DruidBear_damage * buff.owner.dPSStatisticsRatio
    if buff.caster.TitanDruid_Bear and next(buff.caster.TitanDruid_Bear) then
      buff.caster.TitanDruid_Bear.notPopupBattleInfo = true
      buff.caster.TitanDruid_Bear:takeHeal(math.abs(DruidBear_damage), "hp")
      buff.caster.TitanDruid_Bear.notPopupBattleInfo = false
    end
  end
end

function TitanDruid.skillult_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  skill.caster.TitanDruid_timer = 0
  skill.caster.TitamDruid_ultcount = true
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanDruid_ult.cha"
    if not effect_name then
      return
    end
    skill.TitanDruid_node = ed.scene:playEffectOnScene(effect_name, {400, -50}, nil, nil, 1)
  end
  if skill.evo_rank and skill.evo_rank >= 3 and skill.caster.TitanDruid_Bear and skill.caster.TitanDruid_Bear:isAlive() and skill.caster.TitanDruid_Bear.DruidBear_Dying == false then
    local binfo = ed.lookupDataTable("Buff", nil, 11007613)
    local buffatk = skill.caster.TitanDruid_Bear:addBuff(binfo, skill.caster.TitanDruid_Bear)
  end
end

function TitanDruid.ult_update(basefunc, unit, dt)
  local skillult = unit.skills.TitanDruid_ult
  if skillult and not unit:isAlive() then
    skillult:finish("interrupt")
  end
  if unit.TitamDruid_ultcount == true then
    unit.TitanDruid_timer = unit.TitanDruid_timer + 1
    if unit.TitanDruid_timer == 25 then
      local skill = unit.skills.TitanDruid_ult
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
      unit.TitamDruid_ultcount = false
      unit.TitanDruid_timer = nil
    end
  end
  basefunc(unit, dt)
end

function TitanDruid.skillult_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("ARM", math.min(0, target.attribs.ARM * -skill.evo_rank2["Script Arg1"] / 100))
    buff:setAttribute("MR", math.min(0, target.attribs.MR * -skill.evo_rank2["Script Arg1"] / 100))
  end
  return buff
end

function TitanDruid.Dying_takeBear_toDeath(basefunc, unit, skiller)
  basefunc(unit, skiller)
  if unit.TitanDruid_Bear and next(unit.TitanDruid_Bear) then
    unit.TitanDruid_Bear:die(skiller)
  end
end

function TitanDruid.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitamDruid_ultcount = false
  hero.TitanDruid_timer = 0
  hero.TitanDruid_Bear = nil
end

function TitanDruid.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity)
  local skillatk2 = hero.skills.TitanDruid_atk2
  local percent = 0.5
  if skillatk2 then
    local bear = hero.TitanDruid_Bear
    if bear and bear.DruidBear_Dying == false then
      local lost = basefunc(hero, damage, immunity)
      if lost and 0 < lost then
        bear:takeDamage(lost * percent, "Holy", "hp", hero, 1, 1, 0)
        lost = lost * (1 - percent)
        return lost
      end
    end
  end
  return basefunc(hero, damage, immunity)
end

function TitanDruid.init_hero(hero)
  local skillult = hero.skills.TitanDruid_ult
  local skillatk = hero.skills.TitanDruid_atk
  local skillatk2 = hero.skills.TitanDruid_atk2
  local skillatk3 = hero.skills.TitanDruid_atk3
  local skillatk4 = hero.skills.TitanDruid_atk4
  local skillatk2enter = hero.skills.TitanDruid_atk2enter
  hero.TitamDruid_ultcount = false
  hero.TitanDruid_timer = 0
  hero.reset = override(hero.reset, TitanDruid.hero_reset)
  if skillatk and TitanDruid.TitanDruid_fashion_ID and TitanDruid.TitanDruid_fashion_ID == hero.fashion_id then
    skillatk.start = override(skillatk.start, TitanDruid.skillatk_start)
  end
  if skillatk2 then
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, TitanDruid.skillatk2_canCastWithTarget)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanDruid.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, TitanDruid.skillatk2_start)
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanDruid.skillatk2_createProjectile)
    if TitanDruid.TitanDruid_fashion_ID and TitanDruid.TitanDruid_fashion_ID == hero.fashion_id then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Tile Art"] = "eff_tile_TitanDruid_fashion_1_atk2sub.cha"
      })
    end
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
    skillatk4.createBuff = override(skillatk4.createBuff, TitanDruid.skillatk4_CreateBuff)
  end
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanDruid.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, TitanDruid.skillult_CreateBuff)
  end
  hero.onDying = override(hero.onDying, TitanDruid.Dying_takeBear_toDeath)
  hero.die = override(hero.die, TitanDruid.Dying_takeBear_toDeath)
  hero.update = override(hero.update, TitanDruid.ult_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanDruid.hero_getLostHPAfterImmunity)
  return hero
end

return TitanDruid.init_hero
