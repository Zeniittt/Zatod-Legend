module("ed.battlehero", package.seeall)
local ed = ed
Witness = {}
Witness.uncontrol_bid = 1338
Witness.ult_invul_bid = 1428
Witness.ult_position_shift = 80
Witness.ult_min_time = 16
Witness.ult_later_trigger = 4
Witness.ultb_bid = 1429
Witness.colorball_countdown = 1
Witness.colorball_ori_height = 80
Witness.colorball_des_height = 140
Witness.colorball_z_time = {
  [200] = 0.625,
  [400] = 1,
  [600] = 1.25,
  [900] = 1.375
}
Witness.colorball_xy_acc = 40
Witness.atk2_MPRatio_buffID = 1355
Witness.atk2_CoverRatio = 0.6
Witness.atk3_bid = 1430
Witness.atk3_inherit_rate = 0.5
Witness.atk4_decrease_rate = 0.4
Witness.atk4_jump_decrease = 2
Witness.atk4_min_duration = 24
Witness.HAST_ratio_list = {
  0.25,
  0.5,
  0.75,
  1
}
Witness.MSPD_ratio_list = {
  0.25,
  0.5,
  0.75,
  1
}
Witness.awake_self_bid = 1432
Witness.awake_enemy_slow_bid = 1433
Witness.awake_enemy_slow_countdown = 6
Witness.awake_enemy_slowdown = 5
Witness.awake_enemy_frozen_bid = 1434
Witness.skillFashionId = 100621

function Witness.colorball_projectile_update(basefunc, self, dt)
  basefunc(self, dt)
  if not self.Witness_colorball_xy_acc_Normalized then
    self:terminate()
  else
    self.velocity = {
      self.velocity[1] + self.Witness_colorball_xy_acc_Normalized[1] * dt,
      self.velocity[2] + self.Witness_colorball_xy_acc_Normalized[2] * dt
    }
    if self.height + self.zSpeed * dt > Witness.colorball_des_height then
      self:terminate()
      local caster = self.caster
      caster.Witness_colorball_reached = caster.Witness_colorball_reached + 1
    end
  end
end

function Witness.colorball_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local info = skill.info
  local caster = skill.caster
  projectile.position = {
    skill.Witness_colorball_target.position[1],
    skill.Witness_colorball_target.position[2]
  }
  projectile.height = Witness.colorball_ori_height
  local v = {
    info["Tile XY Speed"],
    info["Tile Z Speed"]
  }
  local shifted_position = {
    caster.position[1] + caster.direction * Witness.ult_position_shift,
    caster.position[2]
  }
  local d = ed.edpSub(shifted_position, projectile.position)
  local distance = (d[1] * d[1] + d[2] * d[2]) ^ 0.5
  for length, time in pairs(Witness.colorball_z_time) do
    if length >= distance then
      local z_time = time
      projectile.zSpeed = (Witness.colorball_des_height - Witness.colorball_ori_height) / time
      local xy_acc = 2 * distance / time ^ 2
      projectile.Witness_colorball_xy_acc_Normalized = ed.edpMult(ed.edpNormalize(d), xy_acc)
      break
    end
  end
  projectile.update = override(projectile.update, Witness.colorball_projectile_update)
  return projectile
end

function Witness.invulbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.Witness_colorball_countdown then
    buff.Witness_colorball_countdown = Witness.colorball_countdown
  end
  local caster = buff.caster
  buff.min_time = buff.min_time - 1
  if buff.Witness_colorball_list then
    if buff.Witness_colorball_sent < #buff.Witness_colorball_list * 2 then
      buff.Witness_colorball_countdown = buff.Witness_colorball_countdown - 1
      if buff.Witness_colorball_countdown <= 0 then
        local ballcolor = buff.Witness_colorball_sent % 7 + 1
        buff.Witness_colorball_sent = buff.Witness_colorball_sent + 1
        local skill = caster.skills["Witness_ultball" .. ballcolor]
        local target_number = (buff.Witness_colorball_sent - 1) % #buff.Witness_colorball_list + 1
        skill.Witness_colorball_target = buff.Witness_colorball_list[target_number]
        local target = skill.Witness_colorball_target
        if target:isAlive() then
          local projectile = skill:createProjectile()
          if ed.run_with_scene then
            if 0 < projectile.velocity[1] then
              ed.scene:playEffectOnScene("eff_impact_Witness_ult.cha", target.position, {1, 1}, nil, 0)
            else
              ed.scene:playEffectOnScene("eff_impact_Witness_ult.cha", target.position, {-1, 1}, nil, 0)
            end
          end
          ed.engine:addProjectile(projectile)
          for i, tbuff in ipairs(target.buff_list) do
            if tbuff.info.ID == Witness.ultb_bid then
              local actor = target.actor
              if actor then
                if tbuff.shader_id then
                  actor:removeShader(tbuff.shader_id)
                end
                tbuff.shader_id = actor:pushShader("StoneShader")
              end
            end
          end
          buff.Witness_colorball_countdown = Witness.colorball_countdown
          if Witness.colorball_countdown * #buff.Witness_colorball_list <= 2 then
            buff.Witness_colorball_countdown = 4
          end
        else
          caster.Witness_colorball_reached = caster.Witness_colorball_reached + 1
        end
      end
    elseif caster.Witness_colorball_reached == #buff.Witness_colorball_list * 2 then
      buff.ult_later_trigger_time = buff.ult_later_trigger_time - 1
      if buff.min_time <= 0 and 0 >= buff.ult_later_trigger_time then
        local skillult = caster.skills.Witness_ult
        if caster.current_skill == skillult then
          skillult:startPhase(2)
        end
        buff.timer = 0
      end
    end
  end
end

function Witness.castManualSkill(basefunc, self)
  basefunc(self)
  if ed.run_with_scene then
    ed.scene.background:setColor(ccc3(26, 26, 26))
  end
end

function Witness.skillult_start(basefunc, self, target)
  basefunc(self, target)
  local caster = self.caster
  local bid = Witness.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  local buff = self:createBuff(caster)
  caster:addBuff(buff)
  caster:rebuild()
  if caster.Witness_atk3_buff then
    local buff = caster.Witness_atk3_buff
    if caster.attribs.PIMU > 0 then
      buff:setAttribute("PIMU", caster.attribs.PIMU * Witness.atk3_inherit_rate)
    end
    if 0 < caster.attribs.MIMU then
      buff:setAttribute("MIMU", caster.attribs.MIMU * Witness.atk3_inherit_rate)
    end
    buff.owner:rebuild()
  end
end

function Witness.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    local skillultb = caster.skills.Witness_ultb
    local bid = Witness.ult_invul_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local invul_buff = ed.BuffCreate(binfo, caster, caster)
    invul_buff.Witness_colorball_sent = 0
    invul_buff.Witness_colorball_list = {}
    local list = skillultb:collectAoeTarget(caster.position, caster.direction)
    for k, unit in ipairs(list) do
      if unit.config.is_summoned then
      elseif caster.Witness_atk3_buff and unit.Witness_atk3_buff_on then
      elseif unit.name == "Witness" then
      elseif unit.buff_effects.invulnerable then
      else
        unit:addBuff(skillultb:createBuff(unit))
        table.insert(invul_buff.Witness_colorball_list, unit)
      end
    end
    local shifted_position = {
      caster.position[1] + caster.direction * Witness.ult_position_shift,
      caster.position[2]
    }
    if invul_buff.Witness_colorball_list and 0 < #invul_buff.Witness_colorball_list then
      table.sort(invul_buff.Witness_colorball_list, function(a, b)
        return ed.math.abs(a.position[1] - shifted_position[1]) > ed.math.abs(b.position[1] - shifted_position[1])
      end)
    end
    invul_buff.update = override(invul_buff.update, Witness.invulbuff_update)
    caster.Witness_colorball_reached = 0
    invul_buff.min_time = Witness.ult_min_time
    invul_buff.ult_later_trigger_time = Witness.ult_later_trigger
    caster:addBuff(invul_buff, caster)
    if ed.run_with_scene then
      caster:setAllBuffVisible(false)
      caster:setHpVisible(false)
      caster:setShieldVisible(false)
    end
    local skillatk4 = caster.skills.Witness_atk4
    if skillatk4 then
      if not caster.is_Witness_atk4buff then
        local target = skillatk4:selectTarget()
        if target then
          skillatk4:takeEffectOn(target)
        end
      else
        local buff = caster.is_Witness_atk4buff
        buff.timer = 15
        buff.Witness_atk4_min_duration = Witness.atk4_min_duration
      end
    end
    if caster.manually_casting then
      ed.engine:unfreeze()
      caster.manually_casting = false
    end
    if ed.run_with_scene then
      ed.scene.background:setColor(ccc3(26, 26, 26))
    end
  elseif skill.attack_counter == 1 then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Witness.ult_invul_bid then
        caster:removeBuff(tbuff)
      end
    end
    local skillultc = caster.skills.Witness_ultc
    skillultc:takeEffectAt(caster.position)
    if ed.run_with_scene then
      caster:setAllBuffVisible(true)
      caster:setHpVisible(true)
      caster:setShieldVisible(true)
    end
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Witness_ult2.cha", {400, 0}, {0.75, 0.75}, nil, 1)
    end
  end
  skill.attack_counter = skill.attack_counter + 1
end

function Witness.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.Witness_ultmode = false
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == Witness.ultb_bid and tbuff.caster == buff.caster then
        unit:removeBuff(tbuff)
      end
    end
  end
  if caster.Witness_atk3_buff then
    local buff = caster.Witness_atk3_buff
    if caster.attribs.PIMU > 0 then
      buff:setAttribute("PIMU", 0.01)
    end
    if 0 < caster.attribs.MIMU then
      buff:setAttribute("MIMU", 0.01)
    end
    buff.owner:rebuild()
  end
end

function Witness.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Witness.skillult_buff_onRemoved)
  local caster = skill.caster
  caster.Witness_ultmode = true
  return buff
end

function Witness.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  if ed.run_with_scene then
    ed.scene.background:setColor(ccc3(255, 255, 255))
  end
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Witness.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Witness.skillultb_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if caster.Witness_ultmode then
    local skillultb = caster.skills.Witness_ultb
    local buff = skillultb:createBuff(owner)
    owner:addBuff(buff)
    local actor = owner.actor
    if actor then
      if buff.shader_id then
        actor:removeShader(buff.shader_id)
      end
      buff.shader_id = actor:pushShader("StoneShader")
    end
  end
end

function Witness.skillultb_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Witness.skillultb_buff_onRemoved)
  return buff
end

function Witness.collectMPchange(basefunc, self, config)
  local unit = config.unit
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == Witness.ultb_bid then
      config.mp = unit.mp
    end
  end
end

function Witness.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, ret = basefunc(self, source, target, damage_type)
  local add_power = 0
  if target.mp then
    add_power = self.info["Script Arg2"] * (target.mp / 1000) ^ 2
  end
  power = power + add_power
  return power, ret
end

function Witness.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local bid = Witness.atk2_MPRatio_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, caster)
  local result, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if buff then
    target:removeBuff(buff)
  end
  if dmg and caster.Witness_ultmode then
    caster:takeHeal(dmg * Witness.atk2_CoverRatio, "hp")
  end
  return result, dmg, Crit, lfs_amount
end

function Witness.skillatk3_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  local max = -math.huge
  local chosen
  local caster = self.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit == caster then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
        local v = selector(unit)
        local shouldIgnore = Ignore(unit)
        if max < v and not shouldIgnore then
          max = v
          chosen = unit
        end
      end
    end
  end
  self.target = chosen
  if not chosen then
    self.target = caster
  end
  return self.target
end

function Witness.skillatk3_buff_onRemoved(basefunc, buff)
  buff.caster.Witness_atk3_buff = nil
  buff.owner.Witness_atk3_buff_on = false
  basefunc(buff)
end

function Witness.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Witness.skillatk3_buff_onRemoved)
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == Witness.ultb_bid then
      target:removeBuff(tbuff)
    end
  end
  local caster = buff.caster
  local owner = buff.owner
  if caster.name == "Witness" then
    caster.Witness_atk3_buff = buff
    owner.Witness_atk3_buff_on = true
  end
  if caster.Witness_ultmode then
    if caster.attribs.PIMU > 0 then
      buff:setAttribute("PIMU", caster.attribs.PIMU * Witness.atk3_inherit_rate)
    end
    if 0 < caster.attribs.MIMU then
      buff:setAttribute("MIMU", caster.attribs.MIMU * Witness.atk3_inherit_rate)
    end
  end
  local skillsawake = caster.skills.Witness_sawake
  if skillsawake then
    buff.timer = skillsawake.info["Script Arg2"]
  end
  return buff
end

function Witness.collectSkill(basefunc, self, unit, skill, idx)
  if self.name == "Witness" and self.Witness_atk3_buff and unit.Witness_atk3_buff_on and self.camp == unit.camp and not self.config.is_summoned then
    local skillatk3 = self.skills.Witness_atk3
    if skillatk3 and skill.info["Gain MP"] ~= 0 then
      unit:setMP(unit.mp + skillatk3.info["Script Arg2"])
    end
  end
end

function Witness.skillatk4_selectTarget(basefunc, self, default)
  local target = basefunc(self, default)
  if target and target.config and target.config.is_boss then
    self.target = nil
  end
  return self.target
end

function Witness.skillatk4_buff_update(basefunc, buff, dt)
  local time_remain = buff.timer
  local skillatk4 = buff.caster.skills.Witness_atk4
  local target = skillatk4:selectTarget()
  local owner = buff.owner
  if buff.Witness_atk4_min_duration <= 0 and target and target ~= buff.owner then
    owner:removeBuff(buff)
    local nextBuff = skillatk4:createBuff(target)
    nextBuff.timer = time_remain - Witness.atk4_jump_decrease
    target:addBuff(nextBuff, buff.caster)
  elseif buff.Witness_atk4_min_duration > 0 then
    buff.Witness_atk4_min_duration = buff.Witness_atk4_min_duration - 1
  end
  basefunc(buff, dt)
end

function Witness.skillatk4_buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.Witness_modified == true then
        local info = tbuff.info
        local attribs = tbuff.owner.attribs
        for name, _ in pairs(tbuff.attrib) do
          tbuff:setAttribute(name, info[name] / Witness.atk4_decrease_rate)
        end
        tbuff.Witness_modified = false
      end
    end
    unit:rebuild()
  end
  buff.caster.Witness_atk4buff = nil
  owner.attribute_ratio = 1
  basefunc(buff)
end

function Witness.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  owner.Witness_skillatk4_buff = true
  owner.attribute_ratio = Witness.atk4_decrease_rate
  buff.Witness_atk4_min_duration = Witness.atk4_min_duration
  buff.update = override(buff.update, Witness.skillatk4_buff_update)
  buff.onRemoved = override(buff.onRemoved, Witness.skillatk4_buff_onRemoved)
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.caster == buff.owner then
        local info = tbuff.info
        local attribs = tbuff.owner.attribs
        for name, _ in pairs(tbuff.attrib) do
          tbuff:setAttribute(name, info[name])
        end
      end
    end
    unit:rebuild()
  end
  if caster.Witness_atk4buff then
    caster.Witness_atk4buff.timer = 0
  end
  caster.Witness_atk4buff = buff
  return buff
end

function Witness.skillatk4_willCast(basefunc, skill)
  local caster = skill.caster
  if caster.Witness_atk4buff then
    return false
  else
    return true
  end
end

function Witness.collectBuff(basefunc, self, config)
  if config then
    local buff = config.buff
    local caster = buff.caster
    if caster and caster.Witness_skillatk4_buff and not buff.Witness_modified then
      local info = buff.info
      local attribs = buff.owner.attribs
      for name, _ in pairs(buff.attrib) do
        buff:setAttribute(name, info[name])
      end
    end
  end
end

function Witness.skillawake_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if buff.Witness_awake_enemy_slow_countdown then
    buff.Witness_awake_enemy_slow_countdown = buff.Witness_awake_enemy_slow_countdown - 1
    if buff.Witness_awake_enemy_slow_countdown <= 0 then
      buff:setAttribute("MSPD", buff.info.MSPD - Witness.awake_enemy_slowdown)
      buff.Witness_awake_enemy_slow_countdown = Witness.awake_enemy_slow_countdown
      owner:rebuild()
    end
  end
  if owner.attribs.MSPD <= -100 or not buff.Witness_awake_enemy_slow_countdown then
    buff.timer = 0
  end
end

function Witness.skillawake_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  if owner:isAlive() then
    local bid = Witness.awake_enemy_frozen_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    owner:addBuff(binfo, caster)
  end
  basefunc(buff)
end

function Witness.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.Witness_awake_enemy_slow_countdown = Witness.awake_enemy_slow_countdown
  buff.update = override(buff.update, Witness.skillawake_buff_update)
  buff.onRemoved = override(buff.onRemoved, Witness.skillawake_buff_onRemoved)
  return buff
end

function Witness.onDying(basefunc, self, killer)
  basefunc(self, killer)
  local skillawake = self.skills.Witness_awake
  if skillawake and killer then
    skillawake:takeEffectOn(killer)
  end
end

function Witness.update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillawake = hero.skills.Witness_awake
  if skillawake then
    local level_change
    if hero.hp <= hero.attribs.HP * 0.2 then
      if hero.Witness_awake_level ~= 4 then
        hero.Witness_awake_level = 4
        level_change = true
      end
    elseif hero.hp <= hero.attribs.HP * 0.4 then
      if hero.Witness_awake_level ~= 3 then
        hero.Witness_awake_level = 3
        level_change = true
      end
    elseif hero.hp <= hero.attribs.HP * 0.6 then
      if hero.Witness_awake_level ~= 2 then
        hero.Witness_awake_level = 2
        level_change = true
      end
    elseif hero.hp <= hero.attribs.HP * 0.8 and hero.Witness_awake_level ~= 1 then
      hero.Witness_awake_level = 1
      level_change = true
    end
    if level_change and hero.Witness_awake_level then
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == Witness.awake_self_bid then
          local skillawake = hero.skills.Witness_awake
          tbuff:setAttribute("HAST", skillawake.info["Script Arg2"] * Witness.HAST_ratio_list[hero.Witness_awake_level])
          tbuff:setAttribute("MSPD", skillawake.info["Script Arg2"] * Witness.MSPD_ratio_list[hero.Witness_awake_level])
        end
      end
    end
    hero:rebuild()
  end
  local fashionId = hero.fashion_id
  if fashionId and fashionId == Witness.skillFashionId and not hero:isAlive() then
    for _, buff in ipairs(hero.buff_list) do
      if buff.info.ID == 4460 then
        buff:update(dt)
      end
    end
  end
end

function Witness.reset(basefunc, hero)
  basefunc(hero)
  local skillawake = hero.skills.Witness_awake
  if hero.fashion_id == Witness.skillFashionId then
    hero.fashion_skill_casted = false
  end
  if skillawake then
    hero.Witness_awake_level = nil
    local bid = Witness.awake_self_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.notPopupWords = true
    hero:addBuff(buff, hero)
  end
  local skillsawake = hero.skills.Witness_sawake
  if skillsawake then
    local skill = hero.skills.Witness_atk3
    local originfo = skill.info
    local origtarget = skill.target
    skill.info = ed.wraptable(originfo, {
      ["AOE Origin"] = "target",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = 800
    })
  end
end

function Witness.timer_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == Witness.ultb_bid then
        local actor = unit.actor
        if actor and tbuff.shader_id then
          actor:removeShader(tbuff.shader_id)
        end
        unit:removeBuff(tbuff)
      end
    end
  end
end

function Witness.die(basefunc, unit, killer)
  basefunc(unit, killer)
  local caster = unit
  local skillultb = caster.skills.Witness_ultb
  local skillultc = caster.skills.Witness_ultc
  if not caster.fashion_skill_casted and not caster.config.is_summoned and not unit.config.is_boss then
    caster.fashion_skill_casted = true
    unit.state = ed.emUnitState_Idle
    local bid = 4460
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local timer_buff = ed.BuffCreate(binfo, caster, caster)
    timer_buff.onRemoved = override(timer_buff.onRemoved, Witness.timer_buff_onRemoved)
    unit:addBuff(timer_buff, caster)
    unit.state = ed.emUnitState_Dying
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Witness_ult2.cha", {400, 0}, {0.75, 0.75}, nil, 1)
    end
    local list = skillultb:collectAoeTarget(caster.position, caster.direction)
    for k, unit in ipairs(list) do
      if unit.config.is_summoned then
      elseif unit.camp == caster.camp then
      elseif unit.name == "Witness" then
      elseif unit.buff_effects.invulnerable then
      else
        unit:addBuff(skillultb:createBuff(unit))
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == Witness.ultb_bid then
            local actor = unit.actor
            if actor then
              if tbuff.shader_id then
                actor:removeShader(tbuff.shader_id)
              end
              tbuff.shader_id = actor:pushShader("StoneShader")
            end
          end
        end
      end
    end
    skillultc:takeEffectAt(caster.position)
  end
end

function Witness.init_hero(hero)
  local skillult = hero.skills.Witness_ult
  local skillultb = hero.skills.Witness_ultb
  local fashionId = hero.fashion_id
  if skillult then
    for i = 1, 7 do
      local skill = hero.skills["Witness_ultball" .. i]
      skill.createProjectile = override(skill.createProjectile, Witness.colorball_createProjectile)
    end
    skillult.start = override(skillult.start, Witness.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Witness.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, Witness.skillult_createBuff)
    skillult.finish = override(skillult.finish, Witness.skillult_finish)
    skillultb.createBuff = override(skillultb.createBuff, Witness.skillultb_createBuff)
    hero.collectMPchange = override(hero.collectMPchange, Witness.collectMPchange)
  end
  local skillatk2 = hero.skills.Witness_atk2
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, Witness.skillatk2_power)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Witness.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.Witness_atk3
  if skillatk3 then
    skillatk3.selectTarget = override(skillatk3.selectTarget, Witness.skillatk3_selectTarget)
    skillatk3.createBuff = override(skillatk3.createBuff, Witness.skillatk3_createBuff)
    hero.collectSkill = override(hero.collectSkill, Witness.collectSkill)
  end
  local skillatk4 = hero.skills.Witness_atk4
  if skillatk4 then
    skillatk4.selectTarget = override(skillatk4.selectTarget, Witness.skillatk4_selectTarget)
    skillatk4.createBuff = override(skillatk4.createBuff, Witness.skillatk4_createBuff)
    skillatk4.willCast = override(skillatk4.willCast, Witness.skillatk4_willCast)
    hero.collectBuff = override(hero.collectBuff, Witness.collectBuff)
  end
  local skillawake = hero.skills.Witness_awake
  if skillawake then
    skillawake.createBuff = override(skillawake.createBuff, Witness.skillawake_createBuff)
    hero.onDying = override(hero.onDying, Witness.onDying)
  end
  if fashionId and fashionId == Witness.skillFashionId then
    hero.die = override(hero.die, Witness.die)
  end
  hero.castManualSkill = override(hero.castManualSkill, Witness.castManualSkill)
  hero.reset = override(hero.reset, Witness.reset)
  hero.update = override(hero.update, Witness.update)
  return hero
end

return Witness.init_hero
