module("ed.battlehero", package.seeall)
local ed = ed
TitanSR = {}
TitanSR.Charge_range = 50
TitanSR.charge_time = 1.5
TitanSR.charge_speed = 250
TitanSR.TitanSR_fashionID = 100971

function TitanSR.isNearDest(posStart, posDest, range)
  local disX = posStart[1] - posDest[1]
  local disY = posStart[2] - posDest[2]
  if disX * disX + disY * disY <= range * range then
    return true
  else
    return false
  end
end

function TitanSR.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.charge_direction = caster.direction
  if target then
    if target.position[1] >= caster.position[1] then
      caster.charge_direction = 1
    else
      caster.charge_direction = -1
    end
  end
  caster.orig_walkV = caster.walk_v
  caster.atk2_charge_target = target
  caster.charging = true
end

function TitanSR.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = caster.atk2_charge_target
  if attack_counter then
    if attack_counter == 0 then
      local MPGR = caster.attribs.MPGainRatio
      repeat
        if MPGR ~= nil then
        end
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
        do break end -- pseudo-goto
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      until true
      if not target or target and target.buff_effects.untargetable then
        skill:finish()
      end
      local bid = 1665
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster.charge_stable_buff = caster:addBuff(binfo, caster)
      local direction = ed.edpSub(target.position, caster.position)
      if direction[1] == 0 and direction[2] == 0 then
        caster.walk_v = {0, 0}
      else
        if not caster.controlledTarget then
          direction = {
            direction[1] * math.abs(direction[1]),
            direction[2] * math.abs(direction[2])
          }
        end
        caster.walk_v = ed.edpMult(ed.edpNormalize(direction), TitanSR.charge_speed * caster.walk_speed_multiplier)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      if target then
        if 2 <= caster.TitanSR_hasArcana then
          local bid = 1668
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = target:addBuff(binfo, caster)
        end
        skill:takeEffectOn(target, caster)
      end
      caster.charging = false
      caster.atk2_contact = false
      caster.charge_stable_buff.timer = -1
      caster.walk_v = caster.orig_walkV
    end
  end
end

function TitanSR.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.charge_stable_buff then
    caster.charge_stable_buff.timer = -1
  end
  caster.walk_v = caster.orig_walkV
  caster.charging = false
  caster.atk2_contact = false
end

function TitanSR.skillatk2_trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function TitanSR.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanSR_atk3
  local attack_counter = skill.attack_counter
  local atk3_target = skillatk3:selectTarget()
  if skillatk3 then
    if attack_counter == 0 then
      local MPGR = caster.attribs.MPGainRatio
      repeat
        if MPGR ~= nil then
        end
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
        do break end -- pseudo-goto
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      until true
      local caster_position = caster.position
      local originfo = skillatk3.info
      local attack_position = {
        caster.position[1],
        caster.position[2]
      }
      skill.info = ed.wraptable(originfo, {
        ["Knock Up"] = 0.1,
        ["Knock Back"] = 20
      })
      skillatk3:takeEffectAt({
        caster_position[1],
        caster_position[2]
      }, caster)
      skill.info = originfo
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      local caster_position = caster.position
      local attack_position = {
        caster.position[1] + caster.direction * 180,
        caster.position[2]
      }
      local originfo = skillatk3.info
      skill.info = ed.wraptable(originfo, {
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 80
      })
      skillatk3:takeEffectAt({
        attack_position[1],
        attack_position[2]
      }, caster)
      skill.info = originfo
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 2 then
      local caster_position = caster.position
      local attack_position = {
        caster.position[1],
        caster.position[2]
      }
      local originfo = skillatk3.info
      skill.info = ed.wraptable(originfo, {
        ["Knock Up"] = 0.1,
        ["Knock Back"] = -20
      })
      skillatk3:takeEffectAt({
        caster_position[1],
        caster_position[2]
      }, caster)
      skill.info = originfo
    end
  end
end

function TitanSR.skillatk4_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result then
    if caster.AlreadyDrunk then
      return false, "AlreadyDrunk"
    end
    if caster.AfterDrunk then
      return false, "AfterDrunk"
    end
    if caster.Already_Drunkstate then
      return false, "Already_Drunkstate"
    end
  end
  return result
end

function TitanSR.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Already_Drunkstate = false
  local bid = 1666
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster.skillatk4_allDamage = 0
  caster.skillatk4_downDamage = 0
  caster.Start_drunk_buff = caster:addBuff(binfo, caster)
end

function TitanSR.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanSR_atk4
  local buff_time = skillatk4.info["Script Arg3"] + math.ceil(caster.attribs.STR / 4000)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local MPGR = caster.attribs.MPGainRatio
    repeat
      if MPGR ~= nil then
      end
      caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
      do break end -- pseudo-goto
      caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
    until true
    local bid = 1661
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff.update = override(buff.update, TitanSR.skillatk4_buffupdate)
    buff.onDamaged = override(buff.onDamaged, TitanSR.skillatk4_buffonDamaged)
    buff.onRemoved = override(buff.onRemoved, TitanSR.skillatk4_buffonRemoved)
    buff.timer = buff_time
    caster:addBuff(buff, caster)
    caster.AlreadyDrunk = true
  end
end

function TitanSR.skillatk4_buffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanSR_atk4
  local AD_ratio = skillatk4.info["Script Arg4"] * 0.01
  if caster:isAlive() and caster.skillatk4_allDamage > 0 then
    local AD_raise = caster.skillatk4_allDamage * AD_ratio
    AD_raise = math.min(AD_raise, caster.attribs.AD * 2)
    buff:setAttribute("AD", AD_raise)
  end
end

function TitanSR.skillatk4_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanSR_atk4
  local damage_down = skillatk4.info["Script Arg2"] * 0.01
  if caster:isAlive() and source ~= caster and damage_type ~= "Heal" and damage then
    local TitanSR_lost = damage * (1 - damage_down)
    caster.skillatk4_allDamage = damage + caster.skillatk4_allDamage
    damage = damage * damage_down
    caster.skillatk4_downDamage = caster.skillatk4_downDamage + damage
    local mp_gain = TitanSR_lost * caster.info["MP Gain Rate"] / caster.attribs.HP * (caster.attribs.MPRatio * 0.01 + 1)
    caster:setMP(caster.mp + mp_gain * ed.engine.mp_bonus)
  end
  return damage
end

function TitanSR.skillatk4_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk4 = caster.skills.TitanSR_atk4
  local skillatk4s = caster.skills.TitanSR_atk4s
  local buff_time = skillatk4.info["Script Arg3"]
  caster.AlreadyDrunk = false
  caster.Already_Drunkstate = false
  caster.AfterDrunk = true
  caster.AfterDrunk_state = true
end

function TitanSR.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.Start_drunk_buff.timer > 0 then
    caster.Start_drunk_buff.timer = -1
  end
end

function TitanSR.skillatk4s_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1666
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster.Start_Afterdrunk_buff = caster:addBuff(binfo, caster)
  local skillatk4 = caster.skills.TitanSR_atk4
  local buff_time = skillatk4.info["Script Arg3"] + math.ceil(caster.attribs.STR / 4000)
  local bid = 1662
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local all_damage = caster.skillatk4_allDamage
  local down_damage = caster.skillatk4_downDamage
  local after_damage = all_damage - down_damage
  local newHPR = -after_damage / buff_time
  if caster.TitanSR_hasArcana >= 4 then
    buff_time = buff_time * 0.5
  end
  buff:setAttribute("HPR", newHPR)
  buff.update = override(buff.update, TitanSR.AfterDrunk_Buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanSR.AfterDrunk_Buff_onRemoved)
  buff.timer = buff_time
  if not caster.config.is_boss then
    caster:addBuff(buff, caster)
  end
end

function TitanSR.skillatk4s_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
end

function TitanSR.AfterDrunk_Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.hp <= 1 then
    if caster and caster ~= owner then
      owner:die(caster)
    else
      owner:die()
    end
    return
  end
  basefunc(buff, dt)
end

function TitanSR.AfterDrunk_Buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.AfterDrunk = false
end

function TitanSR.skillatk4s_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.Start_Afterdrunk_buff.timer > 0 then
    caster.Start_Afterdrunk_buff.timer = -1
  end
end

function TitanSR.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk = hero.skills.TitanSR_atk
  local skillatk2 = hero.skills.TitanSR_atk2
  local skillatk3 = hero.skills.TitanSR_atk3
  local skillatk4 = hero.skills.TitanSR_atk4
  local skillatk4s = hero.skills.TitanSR_atk4s
  local skillult = hero.skills.TitanSR_ult
  if not hero.startTime then
    hero.startTime = 0
  end
  hero.startTime = hero.startTime + dt
  if hero.startTime == 0.125 and hero.TitanSR_hasArcana >= 3 and skillult then
    local originfo = skillult.info
    skillult.info = ed.wraptable(originfo, {
      ["Cost MP"] = 800
    })
  end
  if skillatk4 then
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 1661 then
        hero.Already_Drunkstate = true
        break
      end
      if hero.Already_Drunkstate == false and hero.AlreadyDrunk == true then
        hero.AlreadyDrunk = false
      end
    end
  end
  if skillatk4s then
    if skillatk2 and skillatk2.casting or skillatk3 and skillatk3.casting or skillatk4 and skillatk4.casting or skillult and skillult.casting then
      hero.skillOncasting = true
    else
      hero.skillOncasting = false
    end
    if hero.AfterDrunk_state == true and hero.skillOncasting == false then
      hero.AfterDrunk_state = false
      hero:castSkill(skillatk4s, hero)
    end
  end
  if skillatk2 and hero.current_skill == skillatk2 and skillatk2.current_phase_elapsed then
    if not hero.atk2_charge_target then
      skillatk2:finish()
      hero:hurt()
    end
    if hero.charging == true and hero.atk2_charge_target then
      if hero.atk2_charge_target.buff_effects.untargetable then
        skillatk2:finish()
        hero:hurt()
      end
      local atk2_chargeRange = TitanSR.Charge_range + 25
      if hero.config.is_boss then
        atk2_chargeRange = 100
      end
      if hero.speeder and hero.speeder > 1 then
        atk2_chargeRange = atk2_chargeRange * math.min(hero.speeder, 2)
      else
        atk2_chargeRange = TitanSR.Charge_range
      end
      if hero.atk2_contact ~= true then
        local minunit
        local mindis = 9999
        for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
          if not unit.buff_effects.untargetable and not unit.config.is_summoned and 0 < hero.direction * (unit.position[1] - hero.position[1]) then
            local unitDistance = ed.edpDistanceSQ(unit.position, hero.position) ^ 0.5
            if mindis > unitDistance then
              mindis = unitDistance
              minunit = unit
            end
          end
        end
        if minunit then
          hero.atk2_charge_target = minunit
        end
        if hero.atk2_charge_target and TitanSR.isNearDest(hero.position, hero.atk2_charge_target.position, atk2_chargeRange) and hero.atk2_contact ~= true and hero.charging ~= false then
          hero.atk2_contact = true
          hero.charging = false
          skillatk2:trigger()
          hero.walk_v = hero.orig_walkV
        end
      end
    end
    if hero.position[1] >= ed.engine.stage_rect.maxX - 30 or hero.position[1] <= ed.engine.stage_rect.minX + 30 then
      if not hero.X_0_800_Time then
        hero.X_0_800_Time = 0
      end
      hero.X_0_800_Time = hero.X_0_800_Time + dt
      if 3 <= hero.X_0_800_Time then
        hero:hurt()
        skillatk2:finish()
        hero.X_0_800_Time = 0
      end
    end
  end
  if hero.charging == true and not skillatk2.casting and hero.charge_stable_buff then
    hero.charge_stable_buff.timer = -1
    hero.walk_v = hero.orig_walkV
    hero.charging = false
  end
end

function TitanSR.ult_launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local caster = skill.caster
  local direction = skill.caster.direction
  local caster_initDir = caster:getInitDir()
  if caster_initDir == 1 then
    position = {1, 1}
  elseif caster_initDir == -1 then
    position = {799, 1}
  end
  height = 10
  return position, height
end

function TitanSR.ult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  local caster_initDir = caster:getInitDir()
  if target then
    projectile.position, projectile.height = skill:launchPoint()
  end
  caster.ult_projectile = projectile
  projectile.update = override(projectile.update, TitanSR.ult_projectile_update)
  projectile.terminate = override(projectile.terminate, TitanSR.ult_projectile_terminate)
  projectile.isOutOfStage = override(projectile.isOutOfStage, TitanSR.ult_projectile_isOutOfStage)
  projectile.collideCheck = override(projectile.collideCheck, TitanSR.ult_projectile_collideCheck)
  return projectile
end

function TitanSR.ult_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.caster
  local caster_initDir = caster:getInitDir()
  if projectile then
    if projectile.birthtick == ed.engine.ticks then
      return
    end
    if not caster:isAlive() and projectile then
      projectile:terminate()
    end
    if caster_initDir == 1 then
      projectile.theDest = {850, 0}
      if projectile.position[1] > projectile.theDest[1] then
        projectile:terminate()
      end
    elseif caster_initDir == -1 then
      projectile.theDest = {-50, 0}
      if projectile.position[1] < projectile.theDest[1] then
        projectile:terminate()
      end
    end
  end
end

function TitanSR.ult_projectile_collideCheck(basefunc, self, unit)
  local t = basefunc(self, unit)
  local u_pos = unit.position
  local t_pos = self.position
  local caster = self.skill.caster
  if u_pos and t_pos then
    if (u_pos[1] - t_pos[1]) ^ 2 <= 10000 and (u_pos[2] - t_pos[2]) ^ 2 <= 250000 then
      if TitanSR.TitanSR_fashionID and TitanSR.TitanSR_fashionID == caster.fashion_id then
        local skillult = caster.skills.TitanSR_ult
        if skillult then
          skillult:takeEffectOn(unit, caster)
        end
      end
      return true
    else
      return false
    end
  else
    return false
  end
  return t
end

function TitanSR.ult_projectile_hit(basefunc, self, target)
  local caster = self.skill.caster
  if target == self.target and target:isAlive() and not self.terminated then
    self:terminate()
  end
end

function TitanSR.ult_projectile_isOutOfStage(basefunc, projectile)
  local isOut = basefunc(projectile)
  if projectile.position[1] > 850 or projectile.position[1] < -50 then
    return isOut
  end
end

function TitanSR.ult_projectile_terminate(basefunc, projectile)
  basefunc(projectile)
end

function TitanSR.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
end

function TitanSR.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanSR_initAD = hero.attribs.AD
  hero.AlreadyDrunk = false
  hero.AfterDrunk = false
  hero.atk2_contact = false
  hero.AfterDrunk_state = false
  hero.startTime = 0
end

function TitanSR.init_hero(hero)
  local skillatk = hero.skills.TitanSR_atk
  local skillatk2 = hero.skills.TitanSR_atk2
  local skillatk3 = hero.skills.TitanSR_atk3
  local skillatk4 = hero.skills.TitanSR_atk4
  local skillatk4s = hero.skills.TitanSR_atk4s
  local skillult = hero.skills.TitanSR_ult
  hero.TitanSR_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, TitanSR.ult_createProjectile)
    skillult.launchPoint = override(skillult.launchPoint, TitanSR.ult_launchPoint)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanSR.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanSR.skillatk2_onAttackFrame)
    skillatk2.trigger = override(skillatk2.trigger, TitanSR.skillatk2_trigger)
    skillatk2.finish = override(skillatk2.finish, TitanSR.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanSR.skillatk3_onAttackFrame)
  end
  if skillatk4 then
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, TitanSR.skillatk4_canCastWithTarget)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanSR.skillatk4_onAttackFrame)
    skillatk4.start = override(skillatk4.start, TitanSR.skillatk4_start)
  end
  if skillatk4s then
    skillatk4s.start = override(skillatk4s.start, TitanSR.skillatk4s_start)
    skillatk4s.onAttackFrame = override(skillatk4s.onAttackFrame, TitanSR.skillatk4s_onAttackFrame)
  end
  hero.reset = override(hero.reset, TitanSR.hero_reset)
  hero.update = override(hero.update, TitanSR.hero_update)
  hero.die = override(hero.die, TitanSR.hero_die)
  return hero
end

return TitanSR.init_hero
