module("ed.battlehero", package.seeall)
local ed = ed
HeatBossMagnus = {}
HeatBossMagnus.uncontrollable_bid = 11005801
HeatBossMagnus.enemyfreeze_bid = 11005804
HeatBossMagnus.velocity = 280
HeatBossMagnus.speeddown_shift = 120
HeatBossMagnus.speeddown_velocity = 100
HeatBossMagnus.head_length = 90
HeatBossMagnus.HeatBossMagnus_minChargeDis = 280

function HeatBossMagnus.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, HeatBossMagnus.uncontrollable_bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
end

function HeatBossMagnus.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local bufftimeUP = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050261 then
      bufftimeUP = 0.5
    end
    if tbuff.info.ID == 20050262 then
      bufftimeUP = 1
    end
    if tbuff.info.ID == 20050263 then
      bufftimeUP = 1.5
    end
    if tbuff.info.ID == 20050264 then
      bufftimeUP = 2
    end
  end
  buff.timer = buff.timer + bufftimeUP * math.max(0.01, 1 - TEN_final / 100)
  return buff
end

function HeatBossMagnus.skillult_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 1 then
    local hero = skill.caster
    if hero.manually_casting then
      ed.engine:unfreeze()
      hero.manually_casting = false
    end
    local list = skill:collectAoeTarget(hero.position, hero.direction)
    local anchor_position = {
      hero.position[1] + hero.direction * 100,
      hero.position[2] - 20
    }
    if list then
      if #list == 1 then
        list[1].HeatBossMagnus_ult_position = {
          hero.position[1] + hero.direction * 110,
          hero.position[2]
        }
      else
        local length = math.min(#list - 1)
        local shift = 40 / length
        table.sort(list, function(a, b)
          return a.position[1] < b.position[1]
        end)
        for k, unit in ipairs(list) do
          unit.HeatBossMagnus_ult_position = {}
          unit.HeatBossMagnus_ult_position[1] = anchor_position[1] + shift * (k - 1) * hero.direction
        end
        table.sort(list, function(a, b)
          return a.position[2] < b.position[2]
        end)
        for k, unit in ipairs(list) do
          unit.HeatBossMagnus_ult_position[2] = anchor_position[2] + shift * (k - 1)
        end
      end
      for k, unit in ipairs(list) do
        if not unit.buff_effects.invulnerable then
          local knock_distance = {
            unit.HeatBossMagnus_ult_position[1] - unit.position[1],
            unit.HeatBossMagnus_ult_position[2] - unit.position[2]
          }
          unit:knockup(0.5, knock_distance, true)
        end
      end
    end
  elseif skill.attack_counter == 2 then
    local hero = skill.caster
    skill:takeEffectAt(hero.position)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(15, 0.2, 3)
    end
  end
end

function HeatBossMagnus.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == HeatBossMagnus.uncontrollable_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function HeatBossMagnus.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  return ret, dmg, Crit, lfs_amount
end

function HeatBossMagnus.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local powerratio = 1
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050271 then
      powerratio = 1.2
    end
    if tbuff.info.ID == 20050272 then
      powerratio = 1.4
    end
    if tbuff.info.ID == 20050273 then
      powerratio = 1.6
    end
    if tbuff.info.ID == 20050274 then
      powerratio = 1.8
    end
  end
  power = power * powerratio
  return power
end

function HeatBossMagnus.skillatk3_autoselect(skill)
  local caster = skill.caster
  local enemytotheright = {}
  local enemytotheleft = {}
  for enemy in ed.engine:foreachAliveUnit(caster.foecamp) do
    if enemy.buff_effects.untargetable then
    elseif enemy.position[1] >= caster.position[1] then
      table.insert(enemytotheright, enemy)
    else
      table.insert(enemytotheleft, enemy)
    end
  end
  if #enemytotheright == #enemytotheleft then
    caster.HeatBossMagnus_charge_direction = caster.direction
  elseif #enemytotheright > #enemytotheleft then
    caster.HeatBossMagnus_charge_direction = 1
  else
    caster.HeatBossMagnus_charge_direction = -1
  end
  local chosen_side
  if caster.HeatBossMagnus_charge_direction == 1 then
    chosen_side = enemytotheright
  elseif caster.HeatBossMagnus_charge_direction == -1 then
    chosen_side = enemytotheleft
  end
  local chosentarget
  if chosen_side then
    if 2 <= #chosen_side then
      table.sort(chosen_side, function(a, b)
        return a.position[1] * caster.HeatBossMagnus_charge_direction < b.position[1] * caster.HeatBossMagnus_charge_direction
      end)
      chosentarget = chosen_side[#chosen_side]
    else
      chosentarget = chosen_side[1]
    end
    if chosentarget then
      return {
        chosentarget.position[1] + 70 * caster.HeatBossMagnus_charge_direction,
        chosentarget.position[2]
      }
    else
      return nil
    end
  end
  return nil
end

function HeatBossMagnus.skillatk3_selectchargePosition(skill)
  local caster = skill.caster
  local position = HeatBossMagnus.skillatk3_autoselect(skill)
  if position then
    if math.abs(position[1] - caster.position[1]) > HeatBossMagnus.HeatBossMagnus_minChargeDis then
      return position
    end
    return {
      caster.position[1] + caster.HeatBossMagnus_charge_direction * HeatBossMagnus.HeatBossMagnus_minChargeDis,
      position[2]
    }
  end
  return nil
end

function HeatBossMagnus.skillatk3_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.HeatBossMagnus_ult
  if canUse then
    local targetPos = HeatBossMagnus.skillatk3_selectchargePosition(skill)
    if targetPos and caster.current_skill ~= skillult then
      if not skill.defaultTargetPos then
        skill.defaultTargetPos = targetPos
      end
    else
      return false, "no target Position"
    end
  end
  return canUse, reason
end

function HeatBossMagnus.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local chargeTargetPosition = HeatBossMagnus.skillatk3_selectchargePosition(skill)
  chargeTargetPosition = chargeTargetPosition or skill.defaultTargetPos
  skill.defaultTargetPos = chargeTargetPosition
  caster.charge_affected_units_HeatBossMagnus = {}
  caster.direction = caster.HeatBossMagnus_charge_direction
  caster.HeatBossMagnus_charge_origin = {
    caster.position[1],
    caster.position[2]
  }
  local binfo = ed.lookupDataTable("Buff", nil, HeatBossMagnus.uncontrollable_bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  caster.HeatBossMagnus_atk3_charging = true
end

function HeatBossMagnus.skillatk3_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  local hero = skill.caster
  if skill.attack_counter == 1 then
    hero:setMP(hero.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
    hero.HeatBossMagnus_charge_status = 1
    hero.walk_v = {
      hero.HeatBossMagnus_charge_direction * HeatBossMagnus.velocity,
      0
    }
  elseif skill.attack_counter == 2 then
    local skillatk3c = hero.skills.HeatBossMagnus_atk3c
    skillatk3c:takeEffectAt(hero.position)
  elseif skill.attack_counter == 3 then
    hero:setMP(hero.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
    hero.HeatBossMagnus_charge_status = -1
    hero.charge_affected_units_HeatBossMagnus = {}
    hero.walk_v = {
      -hero.HeatBossMagnus_charge_direction * HeatBossMagnus.velocity,
      0
    }
  end
end

function HeatBossMagnus.charge_effect(hero)
  local skillatk3 = hero.skills.HeatBossMagnus_atk3
  local skillatk3a = hero.skills.HeatBossMagnus_atk3a
  local skillatk3b = hero.skills.HeatBossMagnus_atk3b
  hero.direction = hero.HeatBossMagnus_charge_direction
  if hero.HeatBossMagnus_charge_status then
    HeatBossMagnus.skill_effect(hero)
    if hero.HeatBossMagnus_charge_status == 1 and (hero.position[1] > skillatk3.defaultTargetPos[1] - HeatBossMagnus.velocity and hero.HeatBossMagnus_charge_direction == 1 or hero.position[1] < skillatk3.defaultTargetPos[1] + HeatBossMagnus.velocity and hero.HeatBossMagnus_charge_direction == -1) and skillatk3.current_phase_idx == 1 then
      skillatk3:startPhase(2)
    end
    if hero.HeatBossMagnus_charge_status == -1 then
      for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
        if unit.HeatBossMagnus_pulling and (unit.position[1] > hero.HeatBossMagnus_charge_origin[1] - HeatBossMagnus.head_length and hero.HeatBossMagnus_charge_direction == 1 or unit.position[1] < hero.HeatBossMagnus_charge_origin[1] + HeatBossMagnus.head_length and hero.HeatBossMagnus_charge_direction == -1) then
          if skillatk3.current_phase_idx == 4 then
            unit.position[1] = unit.position[1] - HeatBossMagnus.speeddown_velocity / 8 * hero.HeatBossMagnus_charge_direction
          else
            unit.position[1] = unit.position[1] - HeatBossMagnus.velocity / 8 * hero.HeatBossMagnus_charge_direction
          end
        end
      end
      if (hero.position[1] < hero.HeatBossMagnus_charge_origin[1] + HeatBossMagnus.speeddown_shift and hero.HeatBossMagnus_charge_direction == 1 or hero.position[1] > hero.HeatBossMagnus_charge_origin[1] - HeatBossMagnus.speeddown_shift and hero.HeatBossMagnus_charge_direction == -1) and skillatk3.current_phase_idx ~= 4 then
        skillatk3:startPhase(4)
        hero.walk_v = {0, 0}
      end
    end
  end
end

function HeatBossMagnus.skill_effect(hero)
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    local skill = hero.skills.HeatBossMagnus_atk3a
    local skillatk3 = hero.skills.HeatBossMagnus_atk3
    local canpulling_number = 1
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20050281 then
        canpulling_number = 2
      end
      if tbuff.info.ID == 20050282 then
        canpulling_number = 3
      end
      if tbuff.info.ID == 20050283 then
        canpulling_number = 4
      end
      if tbuff.info.ID == 20050284 then
        canpulling_number = 5
      end
    end
    if canpulling_number > hero.HeatBossMagnus_pulling_number and hero.HeatBossMagnus_charge_status == -1 then
      skill = hero.skills.HeatBossMagnus_atk3b
    end
    local info = skill.info
    local direction = hero.direction
    local location = hero.position
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    local charge_affected_units_HeatBossMagnus = hero.charge_affected_units_HeatBossMagnus
    if not charge_affected_units_HeatBossMagnus[unit] and hero.HeatBossMagnus_charge_status and hero.HeatBossMagnus_charge_direction then
      local p2 = ed.edpSub(unit.position, location)
      p2[1] = p2[1] * direction * hero.HeatBossMagnus_charge_status
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        charge_affected_units_HeatBossMagnus[unit] = true
        skill:takeEffectOn(unit, hero)
      end
    end
  end
end

function HeatBossMagnus.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  skill.defaultTargetPos = nil
  caster.direction = caster.HeatBossMagnus_charge_direction * -1
  caster.position = caster.HeatBossMagnus_charge_origin
  caster.HeatBossMagnus_charge_direction = nil
  caster.clickTumblePosition = nil
  caster.HeatBossMagnus_charge_status = nil
  caster.HeatBossMagnus_pulling_number = 0
  caster.HeatBossMagnus_atk3_charging = nil
  caster.HeatBossMagnus_charge_origin = nil
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.HeatBossMagnus_pulling then
      unit.walk_v = {0, 0}
      unit.HeatBossMagnus_pulling = nil
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == HeatBossMagnus.enemyfreeze_bid then
          tbuff.timer = 0
        end
      end
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == HeatBossMagnus.uncontrollable_bid then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function HeatBossMagnus.skillatk3b_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if ret and not target.buff_effects.stable and caster.HeatBossMagnus_charge_direction then
    target.position = {
      caster.position[1] - HeatBossMagnus.head_length * caster.HeatBossMagnus_charge_direction,
      caster.position[2]
    }
    target.HeatBossMagnus_pulling = true
    target.direction = caster.HeatBossMagnus_charge_direction
    target:hurt()
    caster.HeatBossMagnus_pulling_number = caster.HeatBossMagnus_pulling_number + 1
    local binfo = ed.lookupDataTable("Buff", nil, HeatBossMagnus.enemyfreeze_bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function HeatBossMagnus.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.HeatBossMagnus_atk3_charging then
    HeatBossMagnus.charge_effect(hero)
  end
  local skillatk = hero.skills.HeatBossMagnus_atk
  hero.dt = hero.dt and hero.dt + dt or dt
  if hero.dt == 1 then
    local ratio = 1.2
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20050291 then
        ratio = 1.4
      end
      if tbuff.info.ID == 20050292 then
        ratio = 1.6
      end
      if tbuff.info.ID == 20050293 then
        ratio = 1.8
      end
      if tbuff.info.ID == 20050294 then
        ratio = 2
      end
    end
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Plus Ratio"] = ratio
    })
  end
end

function HeatBossMagnus.reset(basefunc, unit)
  basefunc(unit)
  unit.HeatBossMagnus_pulling_number = 0
  unit.HeatBossMagnus_atk3_charging = nil
  unit.HeatBossMagnus_region = nil
end

function HeatBossMagnus.init_hero(hero)
  local skillult = hero.skills.HeatBossMagnus_ult
  local skillatk2 = hero.skills.HeatBossMagnus_atk2
  local skillatk3 = hero.skills.HeatBossMagnus_atk3
  local skillatk3a = hero.skills.HeatBossMagnus_atk3a
  local skillatk3b = hero.skills.HeatBossMagnus_atk3b
  local skillatk3c = hero.skills.HeatBossMagnus_atk3c
  local skillatk4 = hero.skills.HeatBossMagnus_atk4
  if skillult then
    skillult.start = override(skillult.start, HeatBossMagnus.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, HeatBossMagnus.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, HeatBossMagnus.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, HeatBossMagnus.skillult_createBuff)
    skillult.info["No Dodge"] = true
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, HeatBossMagnus.skillatk2_takeEffectOn)
    skillatk2.power = override(skillatk2.power, HeatBossMagnus.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, HeatBossMagnus.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, HeatBossMagnus.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, HeatBossMagnus.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, HeatBossMagnus.skillatk3_finish)
    if skillatk3a and skillatk3b and skillatk3c then
      skillatk3a.info["No Dodge"] = true
      skillatk3b.info["No Dodge"] = true
      skillatk3c.info["No Dodge"] = true
      skillatk3b.takeEffectOn = override(skillatk3b.takeEffectOn, HeatBossMagnus.skillatk3b_takeEffectOn)
    end
  end
  if skillatk4 then
  end
  hero.update = override(hero.update, HeatBossMagnus.update)
  hero.reset = override(hero.reset, HeatBossMagnus.reset)
  return hero
end

return HeatBossMagnus.init_hero
