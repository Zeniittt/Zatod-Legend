module("ed.battlehero", package.seeall)
local ed = ed
BossFur = {}
BossFur.name = "BossFur"
BossFur.DebuffResistance = 0.3
BossFur.UltPointEffect = "eff_point_Fur_ult.cha"
BossFur.UltImpactEffect = "eff_impact_Fur_ult.cha"
BossFur.Atk7PointEffect = "eff_buff_TK_awake.cha"
BossFur.Atk7EffectCD = 0
BossFur.UnControllableBuff = 862
BossFur.WaitingBuff = 865
BossFur.EnhanceBuff = 866
BossFur.emptyBuffID = 233
BossFur.HedgehogID = 232
BossFur.hp_mod = 4
BossFur.AutoEnterTime = 60
BossFur.RecoverEnergyRate = 35
BossFur.RecoverEnergyInterval = 2
BossFur.Atk3SummonNumber = 4
BossFur.Atk4SummonNumber = 2
BossFur.Atk7SummonNumber = 4
BossFur.SummonADCoef = 0.7
BossFur.SummonARMCoef = 6
BossFur.SummonMRCoef = 4
BossFur.SummonLevelAdjust = 0
BossFur.atk7_interrupt_cd = 0.5
BossFur.Waiting = 1
BossFur.Decided = 2
BossFur.Entered = 3
BossFur.skillSuffixes = {
  "_atk4",
  "_atk5",
  "_atk6",
  "_atk8",
  "_ult"
}
BossFur.StrDay = "Fur_daye"
BossFur.StrTuix = "Fur_tuixian"
BossFur.StrTout = "Fur_touta"
BossFur.StrDaygy = "Fur_dayuanguye"
BossFur.StrDantrs = "Fur_dantiaoroushan"
BossFur.StrGoumsj = "Fur_goumaishengjian"
BossFur.StrGoumhz = "Fur_goumaihongzhang"
BossFur.StrQianghcs = "Fur_qianghuachuansong"
BossFur.StrDazzj = "Fur_dazhaozhuanjing"
BossFur.WaitingEventList = {
  {
    1,
    BossFur.StrDay
  },
  {
    4,
    BossFur.StrTuix
  },
  {
    7,
    BossFur.StrTout
  },
  {
    10,
    BossFur.StrDay
  },
  {
    13,
    BossFur.StrGoumhz,
    1
  },
  {
    16,
    BossFur.StrDaygy
  },
  {
    20,
    BossFur.StrQianghcs,
    2
  },
  {
    23,
    BossFur.StrTout
  },
  {
    26,
    BossFur.StrDay
  },
  {
    29,
    BossFur.StrTuix
  },
  {
    32,
    BossFur.StrDazzj,
    3
  },
  {
    35,
    BossFur.StrDaygy
  },
  {
    38,
    BossFur.StrTuix
  },
  {
    41,
    BossFur.StrDantrs
  },
  {
    44,
    BossFur.StrTout
  },
  {
    47,
    BossFur.StrDaygy
  },
  {
    50,
    BossFur.StrDay
  },
  {
    53,
    BossFur.StrTout
  },
  {
    56,
    BossFur.StrDaygy
  },
  {
    59,
    BossFur.StrTuix
  },
  {
    62,
    BossFur.StrTout
  },
  {
    65,
    BossFur.StrDay
  },
  {
    70,
    BossFur.StrTuix
  },
  {
    75,
    BossFur.StrDaygy
  },
  {
    80,
    BossFur.StrTuix
  },
  {
    85,
    BossFur.StrDantrs
  }
}
BossFur.jump_gap = 10000
BossFur.jump_max_range_sq = 360000
BossFur.ult_percent = 1.35

function BossFur.listener_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local unit = buff.caster
  if unit.FurState < BossFur.Entered then
    unit.position = {400, -20}
  end
  if unit.FurHasLabel then
    unit.FurWaitingLabel:removeFromParentAndCleanup(true)
    unit.FurHasLabel = false
  end
end

function BossFur.reset(basefunc, unit)
  basefunc(unit)
  local binfo = ed.lookupDataTable("Buff", nil, BossFur.emptyBuffID)
  local buff = unit:addBuff(binfo, unit)
  if buff then
    buff.onRemoved = override(buff.onRemoved, BossFur.listener_buff_onRemoved)
  end
  unit.FurAddAD = 0
  unit.FurAddAP = 0
  unit.FurAddARM = 0
  unit.FurAddMR = 0
  unit.FurAddHAST = 0
  unit.FurWaitingTime = 0
  local atk2 = unit.skills[BossFur.name .. "_atk2"]
  if atk2 then
    local binfo = ed.lookupDataTable("Buff", nil, BossFur.WaitingBuff)
    local buff = unit:addBuff(binfo, unit)
    unit.FurState = BossFur.Waiting
    unit.FurWaitingBuff = buff
    unit.position = {
      400 - unit:getInitDir() * 2400,
      -20
    }
  else
    unit.FurState = BossFur.Entered
  end
  unit.FurRecoverEnergyTimer = BossFur.RecoverEnergyInterval
  unit.FurNextEventIndex = 1
end

function BossFur.CountAliveFriendUnits(engine, camp)
  local friendlist = engine.alive_units[camp]
  local ret = 0
  for _, unit in ipairs(friendlist) do
    ret = ret + 1
  end
  return ret
end

function BossFur.update_enchance(unitFur, dt)
  local atk2 = unitFur.skills[BossFur.name .. "_atk2"]
  if atk2 then
    local addAD = atk2.info["Script Arg1"] * dt
    local addAP = atk2.info["Script Arg2"] * dt
    local addHAST = atk2.info["Script Arg3"] * dt
    local addARM = atk2.info["Script Arg4"] * dt
    local addMR = atk2.info["Script Arg5"] * dt
    unitFur.FurAddAD = unitFur.FurAddAD + addAD
    unitFur.FurAddAP = unitFur.FurAddAP + addAP
    unitFur.FurAddHAST = unitFur.FurAddHAST + addHAST
    unitFur.FurAddARM = unitFur.FurAddARM + addARM
    unitFur.FurAddMR = unitFur.FurAddMR + addMR
  end
  if BossFur.WaitingEventList[unitFur.FurNextEventIndex] and unitFur.FurWaitingTime >= BossFur.WaitingEventList[unitFur.FurNextEventIndex][1] then
    unitFur.str = BossFur.WaitingEventList[unitFur.FurNextEventIndex][2]
    local str = unitFur.str
    if BossFur.WaitingEventList[unitFur.FurNextEventIndex][3] then
      if BossFur.WaitingEventList[unitFur.FurNextEventIndex][3] == 1 then
        local atk8 = unitFur.skills[BossFur.name .. "_atk8"]
        atk8.cd_remaining = atk8.info.CD
      elseif BossFur.WaitingEventList[unitFur.FurNextEventIndex][3] == 2 then
        unitFur.Atk7_Cd_Change = 12
      elseif BossFur.WaitingEventList[unitFur.FurNextEventIndex][3] == 3 then
        unitFur.Atk9_Acquire = 1
      end
    end
    unitFur.FurNextEventIndex = unitFur.FurNextEventIndex + 1
    if ed.run_with_scene then
      if unitFur.FurHasLabel then
        unitFur.FurWaitingLabel:removeFromParentAndCleanup(true)
        unitFur.FurHasLabel = false
      end
      local label = ed.createSprite("UI/alpha/1080P/battletext/" .. str .. ".png", icon)
      label:setPosition(ccp(522, 427))
      label:setScale(0.5)
      ed.sceneui.ui_layer:addChild(label)
      unitFur.FurWaitingLabel = label
      unitFur.FurHasLabel = true
    end
  end
end

function BossFur.canDecideEnter(atk2)
  local self = atk2
  local info = self.info
  local caster = self.caster
  if not self.is_update then
    return false, "is_update = false"
  end
  if caster.current_skill == caster.manual_skill then
    return false, "casting ult"
  end
  if caster.buff_effects.stun then
    return false, "stun"
  end
  if caster.buff_effects.silence then
    return false, "silence"
  end
  if caster.buff_effects.doom then
    return false, "doom"
  end
  return true
end

function BossFur.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local list = unit.buff_list
  local camp = unit.camp
  local coef = 1 / BossFur.DebuffResistance - 1 or 0
  for i = 1, #list do
    local buff = list[i]
    if buff.caster and buff.caster.camp ~= camp and buff.info.Dispel == "YES" then
      buff.timer = buff.timer - dt * coef
    end
  end
  if unit.FurState and unit.FurState < BossFur.Entered then
    unit.FurWaitingTime = unit.FurWaitingTime + dt
    BossFur.update_enchance(unit, dt)
    unit.FurRecoverEnergyTimer = unit.FurRecoverEnergyTimer - dt
    if 0 >= unit.FurRecoverEnergyTimer then
      unit:setMP(unit.mp + BossFur.RecoverEnergyRate * BossFur.RecoverEnergyInterval * ed.engine.mp_bonus)
      unit.FurRecoverEnergyTimer = unit.FurRecoverEnergyTimer + BossFur.RecoverEnergyInterval
    end
  end
  if unit.FurState == BossFur.Waiting then
    if unit.ai.will_cast_manual_skill and unit.FurWaitingTime >= BossFur.AutoEnterTime then
      unit:FurDecideEnter()
    elseif 1 >= BossFur.CountAliveFriendUnits(ed.engine, unit.camp) and unit.FurWaitingTime and unit.FurWaitingTime >= 3 then
      unit:FurDecideEnter()
    end
  end
  if unit.current_skill and unit.current_skill.info["Skill Name"] == BossFur.name .. "_atk7" then
    if BossFur.Atk7EffectCD < 10 then
      local pos = unit.position
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(BossFur.Atk7PointEffect, pos, {1, 1}, nil, 0)
      end
      BossFur.Atk7EffectCD = BossFur.Atk7EffectCD + dt
    else
      BossFur.Atk7EffectCD = 0
    end
  end
  local atk7 = unit.skills[BossFur.name .. "_atk7"]
  if unit.FurWaitingTime >= BossFur.AutoEnterTime then
    atk7.cd_remaining = 999
  end
end

function BossFur.findNextTarget(basefunc, chain)
  local self = chain
  local min = {
    math.huge,
    math.huge
  }
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif self.skill.caster.buff_effects.derangedOwner and unit.buff_effects.derangedOwner then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    else
      local times = self.affect_times[unit] or 0
      if 0 < times then
      elseif times > min[1] then
      else
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - BossFur.jump_gap)
        if distanceSQ > min[2] then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < BossFur.jump_max_range_sq then
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  return ret
end

function BossFur.ult_chain_terminate(basefunc, chain)
  basefunc(chain)
  local skill = chain.skill
  skill.FurUltChain = nil
  skill.FurUltSetted = false
end

function BossFur.ult_createChain(basefunc, skill)
  local chain = basefunc(skill)
  skill.FurUltChain = chain
  skill.FurUltSetted = true
  chain.findNextTaeget = override(chain.findNextTaeget, BossFur.findNextTarget)
  chain.terminate = override(chain.terminate, BossFur.ult_chain_terminate)
  return chain
end

function BossFur.ult_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  if skill.FurUltSetted then
    local index = skill.info["Chain Jumps"] - skill.FurUltChain.jumps_remaining - 1
    ret = ret * BossFur.ult_percent ^ index
  end
  return ret
end

function BossFur.ult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  if ed.run_with_scene then
    local effect_name = BossFur.UltImpactEffect
    if not effect_name then
      return
    end
    local effect_z = 0
    local origin = {
      target.position[1],
      target.position[2] - 1
    }
    ed.scene:playEffectOnScene(effect_name, origin, {
      skill.caster.direction,
      1
    }, nil, effect_z)
  end
end

function BossFur.CountEnemyPositionX(engine, unit)
  local sum_x = 0
  local count = 0
  local e_camp = -unit.camp
  local enemylist = engine.alive_units[e_camp]
  for _, e_unit in ipairs(enemylist) do
    sum_x = sum_x + e_unit.position[1]
    count = count + 1
  end
  count = count or 1
  local average = sum_x / count
  return average
end

function BossFur.DecideEnterPosition(engine, unit)
  local average = BossFur.CountEnemyPositionX(engine, unit)
  local DestPos
  if average <= 400 then
    DestPos = {
      400 - unit:getInitDir() * 270,
      60 * (ed.rand() - 0.5)
    }
  else
    DestPos = {
      400 + unit:getInitDir() * 270,
      60 * (ed.rand() - 0.5)
    }
  end
  return DestPos
end

function BossFur.FurDecideEnter(unit)
  if unit.FurState ~= BossFur.Waiting then
    return
  end
  unit.FurState = BossFur.Decided
  unit.FurDestPos = BossFur.DecideEnterPosition(ed.engine, unit)
  local atk2 = unit.skills[BossFur.name .. "_atk2"]
  if atk2 then
    atk2.cd_remaining = 0
  end
  if ed.run_with_scene then
    local effect_name = "eff_point_Fur_atk2.cha"
    if not effect_name then
      return
    end
    local effect_z = 0
    ed.scene:playEffectOnScene(effect_name, {
      unit.FurDestPos[1],
      unit.FurDestPos[2] - 1
    }, {
      unit.direction,
      1
    }, nil, effect_z)
  end
end

function BossFur.RandomSummonHedgehog(basefunc, caster, skill, info, dir, summonnumber, xs, ys, range_x, range_y)
  for i = 1, summonnumber do
    local proto = {
      _tid = BossFur.HedgehogID,
      _level = 1 <= skill.level + BossFur.SummonLevelAdjust and skill.level + BossFur.SummonLevelAdjust or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      dps_mod = caster.config.dps_mod or 1,
      hp_mod = BossFur.hp_mod
    }
    local animal = ed.UnitCreate(proto, caster.camp, config)
    animal.direction = caster.direction
    local xxs = ed.rand() * 2 * range_x + xs - range_x
    local yys = ed.rand() * 2 * range_y + ys - range_y
    local animal_location = {
      caster.position[1] + xxs * dir,
      caster.position[2] + yys
    }
    animal:reset()
    animal.HedgehogLeftLife = 999
    animal.die = override(animal.die, function(basefunc, unit, killer)
      if not ed.engine.running then
        unit:setDeathWithEffectOrNot(true)
      end
      basefunc(unit, killer)
    end)
    ed.engine:summonUnit(animal, animal_location, caster, "Birth")
    if not caster.animals then
      caster.animals = {}
    end
    table.insert(caster.animals, animal)
    animal.Owner = caster
    if not caster.FurAddAD then
      caster.FurAddAD = 0
    end
    if not caster.FurAddARM then
      caster.FurAddARM = 0
    end
    if not caster.FurAddMR then
      caster.FurAddMR = 0
    end
    animal.attribs.AD = animal.attribs.AD + caster.FurAddAD * BossFur.SummonADCoef
    animal.attribs.ARM = animal.attribs.ARM + caster.FurAddARM * BossFur.SummonARMCoef
    animal.attribs.MR = animal.attribs.MR + caster.FurAddMR * BossFur.SummonMRCoef
  end
end

function BossFur.atk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  unit.FurState = BossFur.Entered
  local atk6 = unit.skills[BossFur.name .. "_atk6"]
  if unit.FurState > BossFur.Waiting then
    atk6.cd_remaining = 999
  end
  if unit.Atk9_Acquire == 1 then
    local atk9 = unit.skills[BossFur.name .. "_atk9"]
    atk9.cd_remaining = 0
  end
  unit:removeBuff(unit.FurWaitingBuff)
  unit.FurWaitingBuff = nil
  unit.direction = unit:getInitDir()
  if BossFur.CountEnemyPositionX(ed.engine, unit) >= 400 then
    unit.direction = -unit.direction
  end
  unit:setPosition(unit.FurDestPos)
  local binfo = ed.lookupDataTable("Buff", nil, BossFur.EnhanceBuff)
  binfo = ed.wraptable(binfo, {
    AD = unit.FurAddAD
  })
  binfo = ed.wraptable(binfo, {
    AP = unit.FurAddAP
  })
  binfo = ed.wraptable(binfo, {
    ARM = unit.FurAddARM
  })
  binfo = ed.wraptable(binfo, {
    MR = unit.FurAddMR
  })
  binfo.HAST = unit.FurAddHAST
  binfo.MSPD = unit.FurAddHAST * 0.02
  local buff = unit:addBuff(binfo, unit)
  local ratio = (100 + binfo.HAST) / 100
  local atk7 = unit.skills[BossFur.name .. "_atk7"]
  local atk7_cd = unit.Atk7_Cd_Change or atk7.info.CD
  atk7.info.CD = atk7_cd * ratio
  atk7.cd_remaining = atk7_cd * ratio
  for _, suffix in ipairs(BossFur.skillSuffixes) do
    local skill = unit.skills[BossFur.name .. suffix]
    if skill then
      skill.info.CD = skill.info.CD * ratio
    end
  end
  local atk4 = unit.skills[BossFur.name .. "_atk4"]
  if atk4 then
    atk4.info["Gain MP"] = 80
  end
  if unit.FurHasLabel then
    unit.FurWaitingLabel:removeFromParentAndCleanup(true)
    unit.FurHasLabel = false
  end
end

function BossFur.atk3_takeEffectAt(basefunc, skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  local xs = 75
  if caster.FurState == BossFur.Waiting then
    xs = 2160
  end
  local ys = 10
  local range_x = 130
  local range_y = 60
  BossFur.RandomSummonHedgehog(basefunc, caster, skill, info, dir, BossFur.Atk3SummonNumber, xs, ys, range_x, range_y)
end

function BossFur.atk4_takeEffectAt(basefunc, skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  local xs = -75
  local ESide = BossFur.CountEnemyPositionX(ed.engine, caster)
  if caster.FurState == BossFur.Waiting then
    if 400 <= ESide then
      xs = 2845
    else
      xs = 1955
    end
  elseif ESide < 400 then
    xs = -xs
  end
  local ys = 10
  local range_x = 25
  local range_y = 60
  BossFur.RandomSummonHedgehog(basefunc, caster, skill, info, dir, BossFur.Atk4SummonNumber, xs, ys, range_x, range_y)
end

function BossFur.atk7_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  local list = unit.buff_list
  for _, buff in pairs(list) do
    if buff.info.ID == BossFur.UnControllableBuff then
      unit:removeBuff(buff)
      break
    end
  end
end

function BossFur.atk7_takeEffectAt(basefunc, skill)
  local caster = skill.caster
  local info = skill.info
  local dir = caster:getInitDir()
  local xs = 1
  if caster.FurState == BossFur.Waiting then
    xs = 2500
  end
  local ys = -1
  local range_x = 80
  local range_y = 80
  BossFur.RandomSummonHedgehog(basefunc, caster, skill, info, dir, BossFur.Atk7SummonNumber, xs, ys, range_x, range_y)
  local binfo = ed.lookupDataTable("Buff", nil, BossFur.WaitingBuff)
  local buff = caster:addBuff(binfo, caster)
  caster.FurWaitingBuff = buff
  caster.FurState = BossFur.Waiting
  caster.position = {
    400 - caster:getInitDir() * 2400,
    -20
  }
  caster.FurRecoverEnergyTimer = BossFur.RecoverEnergyInterval
  local atk6 = caster.skills[BossFur.name .. "_atk6"]
  if atk6 then
    atk6.cd_remaining = 999
  end
  local binfo = ed.lookupDataTable("Buff", nil, BossFur.EnhanceBuff)
  local ratio = (100 + binfo.HAST) / 100
  for _, suffix in ipairs(BossFur.skillSuffixes) do
    local skill = caster.skills[BossFur.name .. suffix]
    if skill then
      skill.info.CD = skill.info.CD / ratio
    end
  end
  local binfo
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == BossFur.EnhanceBuff then
      binfo = tbuff
      break
    end
  end
  caster:removeBuff(binfo)
  if ed.run_with_scene then
    if caster.FurHasLabel then
      caster.FurWaitingLabel:removeFromParentAndCleanup(true)
      caster.FurHasLabel = false
    end
    local str = caster.str
    local label = ed.createSprite("UI/alpha/1080P/battletext/" .. str .. ".png", icon)
    label:setPosition(ccp(522, 427))
    label:setScale(0.5)
    ed.sceneui.ui_layer:addChild(label)
    caster.FurWaitingLabel = label
    caster.FurHasLabel = true
  end
  local atk4 = caster.skills[BossFur.name .. "_atk4"]
  if atk4 then
    atk4.info["Gain MP"] = 0
  end
  local atk7 = caster.skills[BossFur.name .. "_atk7"]
  if atk7 then
    atk7.cd_remaining = 999
    atk7.info.CD = 999
  end
end

function BossFur.atk7_interrupt(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  local coef = 0.5
  if BossFur.atk7_interrupt_cd and BossFur.atk7_interrupt_cd > 0 then
    coef = BossFur.atk7_interrupt_cd / 0.5
  end
  unit.global_cd = unit.global_cd * coef
  skill.cd_remaining = skill.cd_remaining * coef
end

function BossFur.die(basefunc, unit, killer)
  if unit.animals then
    for _, animal in ipairs(unit.animals) do
      if animal then
        animal:die()
      end
    end
  end
  basefunc(unit, killer)
  if unit.FurHasLabel then
    unit.FurWaitingLabel:removeFromParentAndCleanup(true)
    unit.FurHasLabel = false
  end
end

function BossFur.atk6_start(basefunc, self, target)
  basefunc(self, target)
  local info = self.info
  local ratio = info["Script Arg2"] / 100
  self.cd_remaining = info.CD / ratio
end

function BossFur.init_hero(hero)
  if hero.name == "BossFur" then
    hero.reset = override(hero.reset, BossFur.reset)
    hero.update = override(hero.update, BossFur.update)
    hero.FurDecideEnter = BossFur.FurDecideEnter
  end
  hero.die = override(hero.die, BossFur.die)
  local skillult = hero.skills[BossFur.name .. "_ult"]
  if skillult then
    skillult.createChain = override(skillult.createChain, BossFur.ult_createChain)
    skillult.power = override(skillult.power, BossFur.ult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, BossFur.ult_takeEffectOn)
  end
  local atk2 = hero.skills[BossFur.name .. "_atk2"]
  if atk2 then
    atk2.start = override(atk2.start, BossFur.atk2_start)
  end
  local atk3 = hero.skills[BossFur.name .. "_atk3"]
  if atk3 then
    atk3.takeEffectAt = override(atk3.takeEffectAt, BossFur.atk3_takeEffectAt)
  end
  local atk4 = hero.skills[BossFur.name .. "_atk4"]
  if atk4 then
    atk4.takeEffectAt = override(atk4.takeEffectAt, BossFur.atk4_takeEffectAt)
  end
  local atk6 = hero.skills[BossFur.name .. "_atk6"]
  if atk6 then
    atk6.start = override(atk6.start, BossFur.atk6_start)
  end
  local atk7 = hero.skills[BossFur.name .. "_atk7"]
  if atk7 then
    atk7.start = override(atk7.start, BossFur.atk7_start)
    atk7.takeEffectAt = override(atk7.takeEffectAt, BossFur.atk7_takeEffectAt)
    atk7.interrupt = override(atk7.interrupt, BossFur.atk7_interrupt)
  end
  local atk9 = hero.skills[BossFur.name .. "_atk9"]
  if atk9 then
    atk9.createChain = override(atk9.createChain, BossFur.ult_createChain)
    atk9.power = override(atk9.power, BossFur.ult_power)
    atk9.takeEffectOn = override(atk9.takeEffectOn, BossFur.ult_takeEffectOn)
  end
  return hero
end

return BossFur.init_hero
