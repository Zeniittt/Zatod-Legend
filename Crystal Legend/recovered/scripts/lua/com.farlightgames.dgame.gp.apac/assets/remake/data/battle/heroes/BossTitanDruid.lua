module("ed.battlehero", package.seeall)
local ed = ed
BossTitanDruid = {}
BossTitanDruid.TitanDruid_fashion_ID = 100761
BossTitanDruid.bear_stun = 4345
BossTitanDruid.bear_slow = 4346
BossTitanDruid.rageBuffID = 4359
BossTitanDruid.ragelosthp = 100000

function BossTitanDruid.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if BossTitanDruid.TitanDruid_fashion_ID and BossTitanDruid.TitanDruid_fashion_ID == caster.fashion_id then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_TitanDruid_atk_Bamboo.cha"
    })
  end
  basefunc(skill, target)
end

function BossTitanDruid.skillatk2enter_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skillatk2 = skill.caster.skills.BossTitanDruid_atk2
  local binfo = ed.lookupDataTable("Buff", nil, 958)
  skill.caster:addBuff(binfo, skill.caster)
  local caster = skill.caster
  local atk2level
  if caster and caster.skills.BossTitanDruid_atk2 then
    atk2level = caster.skills.BossTitanDruid_atk2.level
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
    if caster and caster:isAlive() then
      local proto = {
        _tid = 266,
        _level = atk2level or 1,
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
      Bear.collectHPchange = override(Bear.collectHPchange, BossTitanDruid.Bear_collectHPchange)
      Bear.DruidBear_Dying = false
      Bear.DruidBear_stageEnd = false
      ed.engine:summonUnit(Bear, pos, caster, "Idle")
      Bear.DruidBear_baseAD = Bear.attribs.AD
      if BossTitanDruid.TitanDruid_fashion_ID and BossTitanDruid.TitanDruid_fashion_ID == caster.fashion_id then
        Bear:enterActionStageFromOneStage(Bear.DruidBear_rank + 5, 266)
      else
        Bear:enterActionStageFromOneStage(Bear.DruidBear_rank, 266)
      end
      local AttriBinfo = ed.lookupDataTable("Buff", nil, 4384)
      BossTitanDruid.changeBuffInfo(AttriBinfo, skillatk2.info["Script Arg3"] * 2, Bear, 2)
      local buff = Bear:addBuff(AttriBinfo, skill.caster)
      caster.TitanDruid_Bear = Bear
      local binfoboss = ed.lookupDataTable("Buff", nil, 4365)
      Bear:addBuff(binfoboss, skill.caster)
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

function BossTitanDruid.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.collideCheck = override(projectile.collideCheck, BossTitanDruid.atk2projectile_collideCheck)
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

function BossTitanDruid.atk2projectile_collideCheck(basefunc, tile, unit)
  local t = basefunc(tile, unit)
  if unit ~= tile.caster.TitanDruid_Bear then
    return false
  end
  return t
end

function BossTitanDruid.changeBuffInfo(buffInfo, enhance, target, mode)
  local attrib_temp = {}
  for _, name in ipairs(ed.attrib_names) do
    if name ~= "HP" and name ~= "MP" then
      local value = buffInfo[name] or 0
      local ele = buffInfo[name .. ".x"]
      if value ~= 0 or ele then
        attrib_temp[name] = true
      end
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      if mode == 1 then
        buffInfo[name .. ".a"] = enhance * (target.DruidBear_rank - 1)
      elseif mode == 2 then
        buffInfo[name .. ".a"] = enhance
      end
    end
  end
  if buffInfo.ID == 4385 then
    buffInfo.TEN = 10 * target.DruidBear_rank
  end
end

function BossTitanDruid.skillatk2enter_finish(basefunc, skill, reason)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == 958 then
      buff.timer = 0
    end
  end
  basefunc(skill, reason)
end

function BossTitanDruid.Bear_collectHPchange(basefunc, unit, config)
  local skillatk2 = unit.father.skills.BossTitanDruid_atk2
  local percent = math.min(1, skillatk2.info["Script Arg3"])
  local hpchange = config.hp_change
  local Bear_skillatk2 = unit.skills.DruidBear_atk2
  basefunc(unit, config)
  if config.hp_change < 0 and unit.DruidBear_Dying == false and unit.DruidBear_rank > 2 then
    if math.floor(config.unit.attribs.HPR * 0.125) ~= math.floor(config.hp_change) then
      local extraAD = math.min(10000, math.abs(config.hp_change))
      unit.DruidBear_extraAD = unit.DruidBear_extraAD + extraAD
    else
      local extraAD = math.min(1250, math.abs(config.hp_change)) * 0.125
      unit.DruidBear_extraAD = unit.DruidBear_extraAD + extraAD
    end
    if 10000 < unit.DruidBear_extraAD then
      unit.attribs.AD = math.min(unit.DruidBear_baseAD * 4, unit.attribs.AD * 1.04)
      unit.DruidBear_extraAD = unit.DruidBear_extraAD - 10000
    end
  end
end

function BossTitanDruid.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2enter = caster.skills.BossTitanDruid_atk2enter
  if not caster.TitanDruid_Bear or next(caster.TitanDruid_Bear) == nil or not caster.TitanDruid_Bear:isAlive() then
    skillatk2enter.onAttackFrame = override(skillatk2enter.onAttackFrame, BossTitanDruid.skillatk2enter_onAttackFrame)
    skillatk2enter.finish = override(skillatk2enter.finish, BossTitanDruid.skillatk2enter_finish)
    caster:castSkill(skillatk2enter, nil)
    skill.cd_remaining = skill.info.CD
    return
  else
    target = caster.TitanDruid_Bear
    local originfo = skill.info
    if BossTitanDruid.TitanDruid_fashion_ID and BossTitanDruid.TitanDruid_fashion_ID == caster.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_TitanDruid_atk2sub_Bamboo.cha"
      })
    end
    basefunc(skill, target)
  end
end

function BossTitanDruid.skillatk2_onAttackFrame(basefunc, skill)
  local transBinfo = ed.lookupDataTable("Buff", nil, 962)
  local caster = skill.caster
  local bear = caster.TitanDruid_Bear
  local percent = skill.info["Script Arg2"]
  if bear then
    bear:addBuff(transBinfo, skill.caster)
    local bear_transform = bear.skills.DruidBear_transform
    bear:castSkill(bear_transform, bear)
    if bear.DruidBear_Dying == false then
      local HP_percent = bear.hp / bear.attribs.HP
      if bear.DruidBear_rank >= 1 and bear.DruidBear_rank < 5 then
        if BossTitanDruid.TitanDruid_fashion_ID and BossTitanDruid.TitanDruid_fashion_ID == caster.fashion_id then
          bear.DruidBear_rank = bear.DruidBear_rank + 2
          local UpgradeBinfo = ed.lookupDataTable("Buff", nil, 4385)
          BossTitanDruid.changeBuffInfo(UpgradeBinfo, skill.info["Script Arg2"] * 4, bear, 1)
          bear:addBuff(UpgradeBinfo, bear)
          BossTitanDruid.changeBuffInfo(UpgradeBinfo, skill.info["Script Arg2"] * 4, bear, 1)
          bear:addBuff(UpgradeBinfo, bear)
        else
          bear.DruidBear_rank = bear.DruidBear_rank + 1
          local UpgradeBinfo = ed.lookupDataTable("Buff", nil, 4385)
          BossTitanDruid.changeBuffInfo(UpgradeBinfo, skill.info["Script Arg2"] * 4, bear, 1)
          bear:addBuff(UpgradeBinfo, bear)
        end
      end
      bear.DruidBear_baseAD = bear.attribs.AD
      bear.hp = bear.attribs.HP * HP_percent
      if bear.DruidBear_rank >= 5 then
        skill.cd_remaining = 999
      end
    else
      return
    end
  end
  basefunc(skill)
end

function BossTitanDruid.skillatk4_start(basefunc, skill, target)
  for unit in ed.engine:foreachAliveUnit(skill.caster.foecamp) do
    if not unit.buff_effects.invulnerable and unit:isAlive() then
      local binfo = ed.lookupDataTable("Buff", nil, 949)
      local buff = unit:addBuff(binfo, skill.caster)
    end
  end
  basefunc(skill, target)
end

function BossTitanDruid.skillult_onAttackFrame(basefunc, skill)
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
  if skill.caster.TitanDruid_Bear and skill.caster.TitanDruid_Bear:isAlive() and skill.caster.TitanDruid_Bear.DruidBear_Dying == false then
    local binfo = ed.lookupDataTable("Buff", nil, 953)
    local hast_buff = skill.caster.TitanDruid_Bear:addBuff(binfo, skill.caster)
  end
end

function BossTitanDruid.ult_update(basefunc, unit, dt)
  if not unit.BossTitanDruid_timecount then
    unit.BossTitanDruid_timecount = 0
  else
    unit.BossTitanDruid_timecount = unit.BossTitanDruid_timecount - dt
  end
  local skillult = unit.skills.BossTitanDruid_ult
  if skillult and not unit:isAlive() then
    if skillult.TitanDruid_node then
      ed.scene:removeEffect(skillult.TitanDruid_node, 1)
    end
    skillult:finish("interrupt")
  end
  if unit.TitamDruid_ultcount == true then
    unit.TitanDruid_timer = unit.TitanDruid_timer + 1
    if unit.TitanDruid_timer == 25 then
      local skill = unit.skills.BossTitanDruid_ult
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
  if not unit.lastRageHp then
    unit.lastRageHp = unit.hp
    unit.rageStack = 0
  end
  while unit.lastRageHp - unit.hp >= BossTitanDruid.ragelosthp do
    local binfo
    local bid = BossTitanDruid.rageBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buffrage = unit:addBuff(binfo, unit)
    unit.lastRageHp = unit.lastRageHp - BossTitanDruid.ragelosthp
    unit.rageStack = unit.rageStack + 1
  end
end

function BossTitanDruid.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local info = skill.info
  local multiplier = info["Script Arg2"]
  local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
  for i, ubuff in ipairs(target.buff_list) do
    if ubuff.info.ID == 949 then
      local binfo = ed.lookupDataTable("Buff", nil, 951)
      local sbuff = target:addBuff(binfo, caster)
      local con_temp = 0
      if caster.attribs.CON then
        con_temp = caster.attribs.CON
      end
      if sbuff then
        if target.attribs.TEN then
          sbuff.timer = math.floor(caster.attribs.INT * 0.001) * (1 - (target.attribs.TEN - con_temp) / 100)
        else
          sbuff.timer = math.floor(caster.attribs.INT * 0.001)
        end
      end
      power = power + multiplier * base_attrib
      return power, coeff
    end
  end
  return power, coeff
end

function BossTitanDruid.Dying_takeBear_toDeath(basefunc, unit, skiller)
  basefunc(unit, skiller)
  if unit.TitanDruid_Bear and next(unit.TitanDruid_Bear) then
    unit.TitanDruid_Bear:die(skiller)
  end
end

function BossTitanDruid.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  local info = buff.info
  local isRet
  if owner.name == "BossTitanDruid" and self.BossTitanDruid_timecount and self.BossTitanDruid_timecount <= 0 then
    for i, effect in ipairs(info["Control Effects"]) do
      if effect == "silence" then
        isRet = true
        break
      end
    end
    if isRet then
      local bear = owner.TitanDruid_Bear
      if bear and bear:isAlive() then
        local bid = BossTitanDruid.bear_stun
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, bear, owner)
        bear:addBuff(buff, owner)
        local bid2 = BossTitanDruid.bear_slow
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        local buff2 = ed.BuffCreate(binfo2, bear, owner)
        bear:addBuff(buff2, owner)
        self.BossTitanDruid_timecount = 6
      end
    end
  end
end

function BossTitanDruid.init_hero(hero)
  local skillult = hero.skills.BossTitanDruid_ult
  local skillatk = hero.skills.BossTitanDruid_atk
  local skillatk2 = hero.skills.BossTitanDruid_atk2
  local skillatk3 = hero.skills.BossTitanDruid_atk3
  local skillatk4 = hero.skills.BossTitanDruid_atk4
  local skillatk2enter = hero.skills.BossTitanDruid_atk2enter
  hero.TitamDruid_ultcount = false
  hero.TitanDruid_timer = 0
  if skillatk and BossTitanDruid.TitanDruid_fashion_ID and BossTitanDruid.TitanDruid_fashion_ID == hero.fashion_id then
    skillatk.start = override(skillatk.start, BossTitanDruid.skillatk_start)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BossTitanDruid.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, BossTitanDruid.skillatk2_start)
    skillatk2.createProjectile = override(skillatk2.createProjectile, BossTitanDruid.skillatk2_createProjectile)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, BossTitanDruid.skillatk4_start)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossTitanDruid.skillult_onAttackFrame)
    skillult.power = override(skillult.power, BossTitanDruid.skillult_power)
  end
  hero.onDying = override(hero.onDying, BossTitanDruid.Dying_takeBear_toDeath)
  hero.die = override(hero.die, BossTitanDruid.Dying_takeBear_toDeath)
  hero.update = override(hero.update, BossTitanDruid.ult_update)
  hero.collectBuff = override(hero.collectBuff, BossTitanDruid.collectBuff)
  return hero
end

return BossTitanDruid.init_hero
