module("ed.battlehero", package.seeall)
local ed = ed
Magnus = {}
Magnus.ID = 10058
Magnus.uncontrollable_bid = 11005801
Magnus.enemyfreeze_bid = 11005804
Magnus.velocity = 280
Magnus.speeddown_shift = 120
Magnus.speeddown_velocity = 100
Magnus.head_length = 90
Magnus.Magnus_minChargeDis = 280

function Magnus.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Magnus.uncontrollable_bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
end

function Magnus.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Magnus.skillult_onAttackFrame(basefunc, skill)
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
        list[1].Magnus_ult_position = {
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
          unit.Magnus_ult_position = {}
          unit.Magnus_ult_position[1] = anchor_position[1] + shift * (k - 1) * hero.direction
        end
        table.sort(list, function(a, b)
          return a.position[2] < b.position[2]
        end)
        for k, unit in ipairs(list) do
          unit.Magnus_ult_position[2] = anchor_position[2] + shift * (k - 1)
        end
      end
      for k, unit in ipairs(list) do
        if not unit.buff_effects.invulnerable then
          local knock_distance = {
            unit.Magnus_ult_position[1] - unit.position[1],
            unit.Magnus_ult_position[2] - unit.position[2]
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

function Magnus.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Magnus.uncontrollable_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Magnus.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  return ret, dmg, Crit, lfs_amount
end

function Magnus.skillatk3_autoselect(skill)
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
    caster.Magnus_charge_direction = caster.direction
  elseif #enemytotheright > #enemytotheleft then
    caster.Magnus_charge_direction = 1
  else
    caster.Magnus_charge_direction = -1
  end
  local chosen_side
  if caster.Magnus_charge_direction == 1 then
    chosen_side = enemytotheright
  elseif caster.Magnus_charge_direction == -1 then
    chosen_side = enemytotheleft
  end
  local chosentarget
  if chosen_side then
    if 2 <= #chosen_side then
      table.sort(chosen_side, function(a, b)
        return a.position[1] * caster.Magnus_charge_direction < b.position[1] * caster.Magnus_charge_direction
      end)
      chosentarget = chosen_side[#chosen_side]
    else
      chosentarget = chosen_side[1]
    end
    if chosentarget then
      return {
        chosentarget.position[1] + 70 * caster.Magnus_charge_direction,
        chosentarget.position[2]
      }
    else
      return nil
    end
  end
  return nil
end

function Magnus.skillatk3_selectchargePosition(skill)
  local caster = skill.caster
  local position = Magnus.skillatk3_autoselect(skill)
  if position then
    if math.abs(position[1] - caster.position[1]) > Magnus.Magnus_minChargeDis then
      return position
    end
    return {
      caster.position[1] + caster.Magnus_charge_direction * Magnus.Magnus_minChargeDis,
      position[2]
    }
  end
  return nil
end

function Magnus.skillatk3_canCastWithTarget(basefunc, skill, target)
  local canUse, reason = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.Magnus_ult
  if canUse then
    local targetPos = Magnus.skillatk3_selectchargePosition(skill)
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

function Magnus.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local chargeTargetPosition = Magnus.skillatk3_selectchargePosition(skill)
  chargeTargetPosition = chargeTargetPosition or skill.defaultTargetPos
  skill.defaultTargetPos = chargeTargetPosition
  caster.charge_affected_units_Magnus = {}
  caster.direction = caster.Magnus_charge_direction
  caster.Magnus_charge_origin = {
    caster.position[1],
    caster.position[2]
  }
  local binfo = ed.lookupDataTable("Buff", nil, Magnus.uncontrollable_bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  caster.Magnus_atk3_charging = true
end

function Magnus.skillatk3_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  local hero = skill.caster
  if skill.attack_counter == 1 then
    hero:setMP(hero.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
    hero.Magnus_charge_status = 1
    hero.walk_v = {
      hero.Magnus_charge_direction * Magnus.velocity,
      0
    }
  elseif skill.attack_counter == 2 then
    local skillatk3c = hero.skills.Magnus_atk3c
    skillatk3c:takeEffectAt(hero.position)
  elseif skill.attack_counter == 3 then
    hero:setMP(hero.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
    hero.Magnus_charge_status = -1
    hero.charge_affected_units_Magnus = {}
    hero.walk_v = {
      -hero.Magnus_charge_direction * Magnus.velocity,
      0
    }
  end
end

function Magnus.charge_effect(hero)
  local skillatk3 = hero.skills.Magnus_atk3
  local skillatk3a = hero.skills.Magnus_atk3a
  local skillatk3b = hero.skills.Magnus_atk3b
  hero.direction = hero.Magnus_charge_direction
  if hero.Magnus_charge_status then
    Magnus.skill_effect(hero)
    if hero.Magnus_charge_status == 1 and (hero.position[1] > skillatk3.defaultTargetPos[1] - Magnus.velocity and hero.Magnus_charge_direction == 1 or hero.position[1] < skillatk3.defaultTargetPos[1] + Magnus.velocity and hero.Magnus_charge_direction == -1) and skillatk3.current_phase_idx == 1 then
      skillatk3:startPhase(2)
    end
    if hero.Magnus_charge_status == -1 then
      for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
        if unit.Magnus_pulling and (unit.position[1] > hero.Magnus_charge_origin[1] - Magnus.head_length and hero.Magnus_charge_direction == 1 or unit.position[1] < hero.Magnus_charge_origin[1] + Magnus.head_length and hero.Magnus_charge_direction == -1) then
          if skillatk3.current_phase_idx == 4 then
            unit.position[1] = unit.position[1] - Magnus.speeddown_velocity / 8 * hero.Magnus_charge_direction
          else
            unit.position[1] = unit.position[1] - Magnus.velocity / 8 * hero.Magnus_charge_direction
          end
        end
      end
      if (hero.position[1] < hero.Magnus_charge_origin[1] + Magnus.speeddown_shift and hero.Magnus_charge_direction == 1 or hero.position[1] > hero.Magnus_charge_origin[1] - Magnus.speeddown_shift and hero.Magnus_charge_direction == -1) and skillatk3.current_phase_idx ~= 4 then
        skillatk3:startPhase(4)
        hero.walk_v = {0, 0}
      end
    end
  end
end

function Magnus.skill_effect(hero)
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    local skill = hero.skills.Magnus_atk3a
    local skillatk3 = hero.skills.Magnus_atk3
    if hero.Magnus_pulling_number < 2 and hero.Magnus_charge_status == -1 then
      skill = hero.skills.Magnus_atk3b
    end
    local info = skill.info
    local direction = hero.direction
    local location = hero.position
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    local charge_affected_units_Magnus = hero.charge_affected_units_Magnus
    if not charge_affected_units_Magnus[unit] and hero.Magnus_charge_status and hero.Magnus_charge_direction then
      local p2 = ed.edpSub(unit.position, location)
      p2[1] = p2[1] * direction * hero.Magnus_charge_status
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        charge_affected_units_Magnus[unit] = true
        skill:takeEffectOn(unit, hero)
      end
    end
  end
end

function Magnus.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  skill.defaultTargetPos = nil
  caster.direction = caster.Magnus_charge_direction * -1
  caster.position = caster.Magnus_charge_origin
  caster.Magnus_charge_direction = nil
  caster.clickTumblePosition = nil
  caster.Magnus_charge_status = nil
  caster.Magnus_pulling_number = 0
  caster.Magnus_atk3_charging = nil
  caster.Magnus_charge_origin = nil
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.Magnus_pulling then
      unit.walk_v = {0, 0}
      unit.Magnus_pulling = nil
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == Magnus.enemyfreeze_bid then
          tbuff.timer = 0
        end
      end
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Magnus.uncontrollable_bid then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function Magnus.skillatk3b_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if ret and not target.buff_effects.stable and caster.Magnus_charge_direction then
    target.position = {
      caster.position[1] - Magnus.head_length * caster.Magnus_charge_direction,
      caster.position[2]
    }
    target.Magnus_pulling = true
    target.direction = caster.Magnus_charge_direction
    target:hurt()
    caster.Magnus_pulling_number = caster.Magnus_pulling_number + 1
    local binfo = ed.lookupDataTable("Buff", nil, Magnus.enemyfreeze_bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function Magnus.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skilbuffinfo = skill.info.buff_info
  local str = skilbuffinfo.STR
  if skill.evo_rank and skill.evo_rank >= 3 then
    str = str + skill.evo_rank3["Script Arg1"] / 100 * target.attribs.STR
  end
  target:takeHeal(str * 18 * target.config.hp_mod, "hp", caster)
  if caster ~= target then
    skill:takeEffectOn(caster, caster)
  end
end

function Magnus.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local str = buff.info.STR
  local ad = buff.info.AD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AD", ad + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("AD", ad + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    str = str + skill.evo_rank3["Script Arg1"] / 100 * owner.attribs.STR
    buff:setAttribute("STR", str)
  end
  if owner == caster then
    buff:setAttribute("Effect", "eff_buff_Magnus_atk4_self.cha")
  end
  return buff
end

function Magnus.skillatk4_finish(basefunc, skill)
  basefunc(skill)
end

function Magnus.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Magnus_atk3_charging then
    Magnus.charge_effect(hero)
  end
end

function Magnus.reset(basefunc, unit)
  basefunc(unit)
  unit.Magnus_pulling_number = 0
  unit.Magnus_atk3_charging = nil
  unit.Magnus_region = nil
end

function Magnus.init_hero(hero)
  local skillult = hero.skills.Magnus_ult
  local skillatk2 = hero.skills.Magnus_atk2
  local skillatk3 = hero.skills.Magnus_atk3
  local skillatk3a = hero.skills.Magnus_atk3a
  local skillatk3b = hero.skills.Magnus_atk3b
  local skillatk3c = hero.skills.Magnus_atk3c
  local skillatk4 = hero.skills.Magnus_atk4
  if skillult then
    skillult.start = override(skillult.start, Magnus.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Magnus.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, Magnus.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, Magnus.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info["No Dodge"] = true
    end
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Magnus.skillatk2_takeEffectOn)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Magnus.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, Magnus.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Magnus.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, Magnus.skillatk3_finish)
    if skillatk3a and skillatk3b and skillatk3c then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        skillatk3a.info = ed.wraptable(skillatk3a.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
        skillatk3c.info = ed.wraptable(skillatk3c.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        skillatk3a.info = ed.wraptable(skillatk3a.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
        skillatk3b.info = ed.wraptable(skillatk3b.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
        skillatk3c.info = ed.wraptable(skillatk3c.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        skillatk3a.info["No Dodge"] = true
        skillatk3b.info["No Dodge"] = true
        skillatk3c.info["No Dodge"] = true
      end
      skillatk3b.takeEffectOn = override(skillatk3b.takeEffectOn, Magnus.skillatk3b_takeEffectOn)
    end
  end
  if skillatk4 then
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Magnus.skillatk4_takeEffectOn)
    skillatk4.createBuff = override(skillatk4.createBuff, Magnus.skillatk4_createBuff)
    skillatk4.finish = override(skillatk4.finish, Magnus.skillatk4_finish)
  end
  hero.update = override(hero.update, Magnus.update)
  hero.reset = override(hero.reset, Magnus.reset)
  return hero
end

return Magnus.init_hero
