module("ed.battlehero", package.seeall)
local ed = ed
Superman = {}
Superman.ult_fix_target_bid = 4059
Superman.ult_fix_self_bid = 4060
Superman.atk2_bid_str = 4061
Superman.atk2_bid_agi = 4062
Superman.atk3_phase2_target_bid = 4063
Superman.atk3_self = 4071
Superman.atk3_self_phase2 = 4075
Superman.atk2_self = 4074
Superman.ult_atk3_stun = 4064
Superman.atk4_str_bid = 4066
Superman.atk4_agi_bid = 4067
Superman.atk_distanceCoef = 200
Superman.atk2range = 100
Superman.atk2interval = 50
Superman.ult_AOE_stun_range = 200
Superman.skillFashionId = 100651

function Superman.reset(basefunc, hero)
  basefunc(hero)
  hero.index = 0
  hero.lastDirection = 1
  hero.is_atk_phase2 = true
  hero.can_atk3_phase1 = true
  hero.buff_target_unctl = nil
  hero.battle_lineup_is_str = true
  hero.DC_str_num = 0
  hero.DC_agi_num = 0
  local nearestUnit_DC = hero
  local nearestUnit_normal = hero
  local nearestDistance = math.huge
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit.info["Unit Type"] == "Hero" and unit ~= hero then
      local is_DC = false
      if type(unit.info["Hero Tags"]) == "table" then
        for _, tag in pairs(unit.info["Hero Tags"]) do
          if tag == "DC" then
            is_DC = true
            break
          end
        end
      end
      if is_DC == true and unit.info["Main Attrib"] == "STR" then
        hero.DC_str_num = hero.DC_str_num + 1
      elseif is_DC == true and unit.info["Main Attrib"] == "AGI" then
        hero.DC_agi_num = hero.DC_agi_num + 1
      end
      local d = ed.edpDistanceSQ(unit.position, hero.position)
      if nearestDistance > d then
        nearestUnit_normal = unit
        if unit.info["Hero Tags"] == "DC" then
          nearestUnit_DC = unit
        end
        nearestDistance = d
      end
    end
  end
  local skillatk4 = hero.skills.Superman_atk4
  if skillatk4 then
    if hero.DC_str_num < hero.DC_agi_num then
      hero.battle_lineup_is_str = false
    elseif hero.DC_str_num == hero.DC_agi_num and hero.DC_agi_num == 0 and nearestUnit_normal.info["Main Attrib"] == "AGI" then
      hero.battle_lineup_is_str = false
    end
  end
  if hero.battle_lineup_is_str == true then
    local binfo = ed.lookupDataTable("Buff", nil, Superman.atk4_str_bid)
    local buff_self = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff_self, hero)
  elseif hero.battle_lineup_is_str == false then
    local binfo = ed.lookupDataTable("Buff", nil, Superman.atk4_agi_bid)
    local buff_self = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff_self, hero)
  end
  if ed.protoAwake(hero.proto, 10065) then
    local binfo = ed.lookupDataTable("Buff", nil, 4072)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.onDamaged = override(buff.onDamaged, Superman.awakebuff_onDamaged)
    hero:addBuff(buff, hero)
  end
  hero.ult_is_left_or_right = 0
  hero.ult_projectile_1_position = {0, 0}
  hero.Superman_ult_target = nil
  hero.ult_buff_Spuerman_ult_fix = nil
  hero.Superman_ult2_update_switch = 0
  hero.Superman_ult5_update_switch = 0
  hero.Superman_ult_lighteffect = false
  hero.Superman_ult_lighteffect_index = 0
  hero.Superman_ult_issummonFinalProjectile = false
  hero.Superman_ult_issummonFinalProjectile_index = 0
  hero.Superman_ult_light_effect = nil
  hero.x = false
end

function Superman.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
end

function Superman.skillenter_awake_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
  if caster:getInitDir() == -1 and ed.protoAwake(caster.proto, 10065) and caster.actor and caster.fashion_id ~= Superman.skillFashionId then
    caster.actor.puppet:setComponent("TorsoTop_s", "TorsoTop_f_s")
  end
end

function Superman.skillenter_awake_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(40, 0.25, 11)
  end
end

function Superman.getFixDir(basefunc, self)
  local dir = self.direction
  return dir
end

function Superman.update(basefunc, self, dt)
  basefunc(self, dt)
  if self.actor and self.direction ~= self.lastDirection then
    if self.direction == -1 then
      if ed.protoAwake(self.proto, 10065) and self.fashion_id ~= Superman.skillFashionId then
        self.actor.puppet:setComponent("TorsoTop", "TorsoTop_f_s")
        self.actor.puppet:setComponent("TorsoTop_f", "TorsoTop_s")
        self.actor.puppet:setComponent("B-Manteau1", "B-Manteau1_f_s")
      else
        self.actor.puppet:setComponent("TorsoTop", "TorsoTop_f")
        self.actor.puppet:setComponent("TorsoTop_f", "TorsoTop")
        self.actor.puppet:setComponent("B-Manteau1", "B-Manteau1_f")
      end
    elseif ed.protoAwake(self.proto, 10065) and self.fashion_id ~= Superman.skillFashionId then
      self.actor.puppet:setComponent("TorsoTop", "TorsoTop_s")
      self.actor.puppet:setComponent("TorsoTop_f", "TorsoTop_f_s")
      self.actor.puppet:setComponent("B-Manteau1", "B-Manteau1_s")
    else
      self.actor.puppet:setComponent("TorsoTop", "TorsoTop")
      self.actor.puppet:setComponent("TorsoTop_f", "TorsoTop_f")
      self.actor.puppet:setComponent("B-Manteau1", "B-Manteau1")
    end
    local actionName = self.actor:getActionName(self.action_name)
    self.actor.puppet:setAction(actionName)
    self.actor.puppet:setLoop(self.action_loop)
    self.actor.puppet:setActionElapsed(self.action_elapsed)
  end
  self.lastDirection = self.direction
  if self.x == true then
    self.Superman_ult_lighteffect_index = self.Superman_ult_lighteffect_index + dt
  end
  local effect = "eff_point_Superman_light.cha"
  if self.Superman_ult_lighteffect == true then
    if not self.Superman_ult_light_effect then
      if ed.run_with_scene then
        ed.scene:playEffectOnScene(effect, {510, -50}, {1, 1}, nil, 1)
      end
      self.Superman_ult_light_effect = true
      self.Superman_ult_lighteffect = false
      self.x = true
    end
  elseif self.Superman_ult_lighteffect == false and self.Superman_ult_lighteffect_index > 2 and self.Superman_ult_light_effect then
    self.Superman_ult_issummonFinalProjectile = true
    self.x = false
    self.Superman_ult_light_effect = nil
    self.Superman_ult_lighteffect_index = 0
  end
  if self.Superman_ult_issummonFinalProjectile == true then
    self.Superman_ult_issummonFinalProjectile_index = self.Superman_ult_issummonFinalProjectile_index + dt
    if self.Superman_ult_issummonFinalProjectile_index > 0.5 then
      local skillult5 = self.skills.Superman_ult5
      if skillult5 then
        skillult5.createProjectile = override(skillult5.createProjectile, Superman.skillult5_createProjectile)
        skillult5:createTrackType("projectile")
      end
      self.Superman_ult_issummonFinalProjectile = false
      self.Superman_ult_issummonFinalProjectile_index = 0
    end
  end
  if ed.run_with_scene and self.actor then
    self.actor.cheer = override(self.actor.cheer, Superman.actor_cheer)
  end
end

function Superman.actor_cheer(basefunc, actor)
  local caster = actor.model
  if caster.direction == -1 then
    caster.direction = 1
    if ed.protoAwake(caster.proto, 10065) and caster.fashion_id ~= Superman.skillFashionId then
      actor.puppet:setComponent("TorsoTop", "TorsoTop_s")
    else
      actor.puppet:setComponent("TorsoTop", "TorsoTop")
    end
  end
  basefunc(actor)
end

function Superman.onDying(basefunc, self, killer)
  basefunc(self, killer)
  if self.actor then
    if self.direction == -1 then
      if ed.protoAwake(self.proto, 10065) and self.fashion_id ~= Superman.skillFashionId then
        self.actor.puppet:setComponent("TorsoTop", "TorsoTop_f_s")
      else
        self.actor.puppet:setComponent("TorsoTop", "TorsoTop_f")
      end
    elseif ed.protoAwake(self.proto, 10065) and self.fashion_id ~= Superman.skillFashionId then
      self.actor.puppet:setComponent("TorsoTop", "TorsoTop_s")
    else
      self.actor.puppet:setComponent("TorsoTop", "TorsoTop")
    end
  end
end

function Superman.skillult_evacuate_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.ult_eve_binfo = ed.lookupDataTable("Buff", nil, Superman.atk3_self_phase2)
  caster.ult_eve_self = ed.BuffCreate(caster.ult_eve_binfo, caster, caster)
  caster:addBuff(caster.ult_eve_self, caster)
  local caster = skill.caster
  if caster.ult_is_left_or_right == 1 then
    caster.position[1] = 280
    caster.direction = 1
    caster.ult_is_left_or_right = 0
  else
    caster.position[1] = 520
    caster.direction = -1
    caster.ult_is_left_or_right = 0
  end
end

function Superman.skillult_evacuate_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.ult_eve_self then
    caster:removeBuff(caster.ult_eve_self)
  end
end

function Superman.skillult_canCastWithTarget(basefunc, skill, target)
  if target and not ed.engine.arena_mode and not ed.engine.toppvp_mode and not ed.engine.wca_mode and not ed.engine.gmMode and not ed.engine.multiarena_mode and not ed.engine.battle_manager and not ed.engine.starGate_mode and not ed.engine.legendArena_mode and target.buff_effects.uncontrollable then
    return false
  end
  return basefunc(skill, target)
end

function Superman.skillult_takeEffectAt(basefunc, skill, location, source)
end

function Superman.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if caster.position[1] < target.position[1] then
    caster.ult_is_left_or_right = 1
  else
    caster.ult_is_left_or_right = -1
  end
  if ed.run_with_scene then
    if caster.actor then
      caster:setAllBuffVisible(false)
      caster:setHpVisible(false)
      caster:setShieldVisible(false)
    end
    if target.actor then
      target:setAllBuffVisible(false)
      target:setHpVisible(false)
      target:setShieldVisible(false)
    end
  end
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, Superman.skillult_projectile_update)
  return projectile
end

function Superman.skillult_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  local target = projectile.skill.target
  caster.Superman_ult_target = target
  if projectile.height < 107 then
    target:hurt()
    local binfo = ed.lookupDataTable("Buff", nil, Superman.ult_fix_target_bid)
    local buff_target = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff_target, caster)
    caster.ult_buff_Spuerman_ult_fix_target = buff_target
    local binfo = ed.lookupDataTable("Buff", nil, Superman.ult_fix_self_bid)
    local buff_self = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff_self, caster)
    caster.ult_buff_Spuerman_ult_fix_self = buff_self
    caster.ult_projectile_1_position = {
      projectile.position[1],
      projectile.position[2]
    }
    projectile:terminate()
    local skillult2 = caster.skills.Superman_ult2
    if skillult2 then
      skillult2:createTrackType("projectile")
    end
    return
  end
end

function Superman.skillult2_createProjectile(basefunc, skill)
  local Superman_ult_projectile_2 = basefunc(skill)
  local caster = skill.caster
  caster.Superman_ult2_update_switch = 0
  Superman_ult_projectile_2.position = {
    caster.ult_projectile_1_position[1],
    caster.ult_projectile_1_position[2]
  }
  Superman_ult_projectile_2.height = 100
  Superman_ult_projectile_2.velocity = {1600, 600}
  Superman_ult_projectile_2.update = override(Superman_ult_projectile_2.update, Superman.skillult2_projectile_update)
  return Superman_ult_projectile_2
end

function Superman.skillult2_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if projectile.terminated and caster.Superman_ult2_update_switch == 0 then
    caster.Superman_ult2_update_switch = 1
    caster.Superman_ult_lighteffect = true
  end
end

function Superman.skillult5_createProjectile(basefunc, skill)
  local Superman_ult_projectile_5 = basefunc(skill)
  local caster = skill.caster
  caster.Superman_ult5_update_switch = 0
  if caster.ult_is_left_or_right == 1 then
    Superman_ult_projectile_5.position[1] = 0
    Superman_ult_projectile_5.velocity[1] = 800
  else
    Superman_ult_projectile_5.position[1] = 800
    Superman_ult_projectile_5.velocity[1] = -800
  end
  Superman_ult_projectile_5.height = 200
  Superman_ult_projectile_5.velocity[2] = 0
  Superman_ult_projectile_5.zSpeed = -300
  Superman_ult_projectile_5.update = override(Superman_ult_projectile_5.update, Superman.skillult5_projectile_update)
  return Superman_ult_projectile_5
end

function Superman.skillult5_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  local skillult = caster.skills.Superman_ult
  local target = skillult.target
  if projectile.terminated and caster.Superman_ult5_update_switch == 0 then
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(90, 0.5, 10)
      ed.scene:playEffectOnScene("eff_point_Superman_ult.cha", projectile.position, {1, 1}, nil, 1)
    end
    if caster.ult_buff_Spuerman_ult_fix_self then
      caster:removeBuff(caster.ult_buff_Spuerman_ult_fix_self)
    end
    if caster.ult_buff_Spuerman_ult_fix_target and target then
      target:removeBuff(caster.ult_buff_Spuerman_ult_fix_target)
    end
    if target then
      target.position[1] = projectile.position[1]
    end
    if target and target.actor then
      target.actor.position[1] = projectile.position[1]
    end
    local skillult_b = caster.skills.Superman_ultb
    if skillult_b and target then
      skillult_b:takeEffectOn(target)
    end
    local skillult_evacuate = caster.skills.Superman_ult_evacuate
    if skillult_evacuate then
      skillult_evacuate.info = ed.wraptable(skillult_evacuate.info, {
        ["Init CD"] = 0
      })
      caster:castSkill(skillult_evacuate, caster)
      skillult_evacuate.info = ed.wraptable(skillult_evacuate.info, {
        ["Init CD"] = 9999
      })
    end
    local binfo = ed.lookupDataTable("Buff", nil, Superman.ult_atk3_stun)
    local buff_target_stun = ed.BuffCreate(binfo, caster.Superman_ult_target, caster)
    caster.Superman_ult_target:addBuff(buff_target_stun, caster)
    for unit in ed.engine:foreachAliveUnit(caster.Superman_ult_target.camp) do
      local XdistanceSQ = math.abs(unit.position[1] - caster.Superman_ult_target.position[1])
      if XdistanceSQ < 100 and unit ~= target then
        local binfo = ed.lookupDataTable("Buff", nil, Superman.ult_atk3_stun)
        local buff_target_stun = ed.BuffCreate(binfo, unit, caster)
        unit:addBuff(buff_target_stun, caster)
        unit:takeDamage(caster.attribs.AD * skillult.level * 0.008, "AD", "hp", caster)
      end
    end
    if ed.run_with_scene then
      if caster.actor then
        caster:setAllBuffVisible(true)
        caster:setHpVisible(true)
        caster:setShieldVisible(true)
      end
      if target.actor then
        target:setAllBuffVisible(true)
        target:setHpVisible(true)
        target:setShieldVisible(true)
      end
    end
    caster.Superman_ult5_update_switch = 1
  end
end

function Superman.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local num = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    local XdistanceSQ = (unit.position[1] - caster.position[1]) ^ 2
    if XdistanceSQ < Superman.atk_distanceCoef ^ 2 then
      num = num + 1
    end
  end
  if 2 < num then
    if ed.protoAwake(caster.proto, 10065) and caster.is_atk_phase2 == true then
      caster.is_atk_phase2 = false
      local originfo = skill.info
      skill.info = ed.wraptable(originfo, {
        ["AOE Origin"] = "self",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 800
      })
      skill:startPhase(2)
      skill.info = originfo
    end
  else
    caster.is_atk_phase2 = true
    skill:startPhase(1)
  end
end

function Superman.skillatk_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    basefunc(skill, location, source)
  elseif skill.current_phase_idx == 2 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if math.abs(unit.position[1] - caster.position[1]) < 200 then
        unit:knockup(0.3, ed.edpMult({
          -unit.direction,
          0
        }, 100), false)
        local Superman_atk_2b = caster.skills.Superman_atk_2b
        if Superman_atk_2b then
          Superman_atk_2b:takeEffectOn(unit)
        end
      end
    end
  end
end

function Superman.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Superman.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  caster.atk2_binfo = ed.lookupDataTable("Buff", nil, Superman.atk2_self)
  caster.atk2_buff_self = ed.BuffCreate(caster.atk2_binfo, caster, caster)
  caster:addBuff(caster.atk2_buff_self, caster)
end

function Superman.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  skill.info = ed.wraptable(originfo, {
    ["X Shift"] = (attack_counter - 1) * Superman.atk2range + Superman.atk2interval
  })
  basefunc(skill, location, source)
  if skill then
    skill.info = originfo
  end
end

function Superman.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  basefunc(skill, target, source, shift)
  local skillatk4 = caster.skills.Superman_atk4
  if caster.battle_lineup_is_str == true then
    local binfo = ed.lookupDataTable("Buff", nil, Superman.atk2_bid_str)
    local buff = ed.BuffCreate(binfo, target, caster)
    if skillatk4 then
      buff:setAttribute("ARM", buff.info.ARM * skillatk4.info["Script Arg2"])
      buff:setAttribute("Max Stack Times", caster.DC_str_num + caster.DC_agi_num + 1)
      target:addBuff(buff, caster)
    end
  else
    local binfo = ed.lookupDataTable("Buff", nil, Superman.atk2_bid_agi)
    local buff = ed.BuffCreate(binfo, target, caster)
    if skillatk4 then
      buff:setAttribute("HIT", buff.info.HIT * skillatk4.info["Script Arg3"])
      buff:setAttribute("Max Stack Times", caster.DC_str_num + caster.DC_agi_num + 1)
      target:addBuff(buff, caster)
    end
  end
end

function Superman.atk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.atk2_buff_self then
    caster:removeBuff(caster.atk2_buff_self)
  end
end

function Superman.skillatk3_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster.battle_lineup_is_str == false and (target.buff_effects.untargetable or target.buff_effects.uncontrollable or target.buffManager.invisible or target.config.is_boss) then
    caster.can_atk3_phase1 = false
  end
  return basefunc(skill, target)
end

function Superman.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  if caster.battle_lineup_is_str == false and caster.can_atk3_phase1 == true then
    if target then
      target.Superman_atk3_binfo = ed.lookupDataTable("Buff", nil, Superman.atk3_phase2_target_bid)
      target.Superman_atk3_buff_target_unctl = ed.BuffCreate(target.Superman_atk3_binfo, target, caster)
      target:addBuff(target.Superman_atk3_buff_target_unctl, caster)
      target:hurt()
    end
    caster.atk3_binfo = ed.lookupDataTable("Buff", nil, Superman.atk3_self)
    caster.atk3_buff_self = ed.BuffCreate(caster.atk3_binfo, caster, caster)
    caster:addBuff(caster.atk3_buff_self, caster)
    skill:startPhase(1)
  else
    caster.atk3_binfo = ed.lookupDataTable("Buff", nil, Superman.atk3_self_phase2)
    caster.atk3_buff_self = ed.BuffCreate(caster.atk3_binfo, caster, caster)
    caster:addBuff(caster.atk3_buff_self, caster)
    skill:startPhase(2)
  end
end

function Superman.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if skill.current_phase_idx == 1 then
    basefunc(skill)
    if skill.attack_counter == 2 then
      if target then
        target:hurt()
        target.direction = -target.direction
      end
    elseif skill.attack_counter == 3 then
      if target then
        target:hurt()
        target.direction = -target.direction
      end
    elseif skill.attack_counter == 5 then
      if target and target:isAlive() then
        target:hurt()
      end
      if target and target.Superman_atk3_buff_target_unctl then
        target:removeBuff(target.Superman_atk3_buff_target_unctl)
      end
      if target and caster.direction == 1 then
        target:knockup(0.25, {
          -0.9 * target.position[1],
          0
        }, true)
        if ed.run_with_scene then
          ed.scene:startCameraShakeAnimationY(40, 0.38, 8)
        end
      elseif target and caster.direction == -1 then
        target:knockup(0.25, {
          0.9 * (800 - target.position[1]),
          0
        }, true)
        if ed.run_with_scene then
          ed.scene:startCameraShakeAnimationY(40, 0.38, 8)
        end
      end
      if target then
        local Superman_atk3b = caster.skills.Superman_atk3b
        if Superman_atk3b then
          Superman_atk3b:takeEffectOn(target)
        end
      end
      if target then
        local binfo = ed.lookupDataTable("Buff", nil, Superman.ult_atk3_stun)
        local buff = ed.BuffCreate(binfo, target, caster)
        target:addBuff(buff, caster)
      end
      if ed.run_with_scene then
        ed.scene:startCameraShakeAnimationY(40, 0.4, 8)
      end
    end
  elseif skill.current_phase_idx == 2 then
    basefunc(skill)
    if skill.attack_counter == 2 and ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(50, 0.6, 12)
    end
  end
end

function Superman.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.current_phase_idx == 1 then
    if skill.attack_counter == 3 or skill.attack_counter == 5 then
      local originfo = skill.info
      skill.info = ed.wraptable(originfo, {
        ["Gain MP"] = 35,
        ["Ignore Target Type"] = "summon",
        ["Shape Arg1"] = 0
      })
      basefunc(skill, location, source)
      skill.info = originfo
    end
  elseif skill.current_phase_idx == 2 and skill.attack_counter == 2 then
    local caster = skill.caster
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      local binfo = ed.lookupDataTable("Buff", nil, Superman.ult_atk3_stun)
      local buff_target_stun = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(buff_target_stun, caster)
    end
    basefunc(skill, location, source)
  end
end

function Superman.skillatk3_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    local initial_direction = caster.direction
    caster.direction = -caster.direction
    if initial_direction == 1 then
      caster.position[1] = caster.position[1] + 150
    else
      caster.position[1] = caster.position[1] - 150
    end
  end
  skill:finish()
end

function Superman.atk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if caster.atk3_buff_self then
    caster:removeBuff(caster.atk3_buff_self)
  end
  if caster.atk3_buff_self_phase2 then
    caster:removeBuff(caster.atk3_buff_self_phase2)
  end
  if target and target.Superman_atk3_buff_target_unctl then
    target:removeBuff(target.Superman_atk3_buff_target_unctl)
  end
  caster.can_atk3_phase1 = true
end

function Superman.awakebuff_onDamaged(basefunc, buff, damage, damage_type, source)
  local dmg = basefunc(buff, damage, damage_type, source)
  local caster = buff.owner
  local skillawake = caster.skills.Superman_awake
  if skillawake then
    local immune_num = skillawake.info["Script Arg2"]
    if damage_type == "AD" then
      if dmg > immune_num then
        dmg = dmg - immune_num
      else
        dmg = 0
      end
    end
  end
  return dmg
end

function Superman.init_hero(hero)
  hero.reset = override(hero.reset, Superman.reset)
  hero.update = override(hero.update, Superman.update)
  hero.onDying = override(hero.onDying, Superman.onDying)
  hero.getFixDir = override(hero.getFixDir, Superman.getFixDir)
  local skillatk = hero.skills.Superman_atk
  if skillatk then
    skillatk.start = override(skillatk.start, Superman.skillatk_start)
    skillatk.takeEffectAt = override(skillatk.takeEffectAt, Superman.skillatk_takeEffectAt)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Superman.skillatk_onPhaseFinished)
  end
  local skillatk2 = hero.skills.Superman_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Superman.skillatk2_start)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, Superman.skillatk2_takeEffectAt)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Superman.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillatk2.finish, Superman.atk2_finish)
  end
  local skillatk3 = hero.skills.Superman_atk3
  if skillatk3 then
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Superman.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, Superman.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Superman.skillatk3_onAttackFrame)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Superman.skillatk3_takeEffectAt)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Superman.skillatk3_onPhaseFinished)
    skillatk3.finish = override(skillatk3.finish, Superman.atk3_finish)
  end
  local skillult = hero.skills.Superman_ult
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Superman.skillult_canCastWithTarget)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Superman.skillult_takeEffectAt)
    skillult.createProjectile = override(skillult.createProjectile, Superman.skillult_createProjectile)
  end
  local skillult2 = hero.skills.Superman_ult2
  if skillult2 then
    skillult2.createProjectile = override(skillult2.createProjectile, Superman.skillult2_createProjectile)
  end
  local skillult_evacuate = hero.skills.Superman_ult_evacuate
  if skillult_evacuate then
    skillult_evacuate.start = override(skillult_evacuate.start, Superman.skillult_evacuate_start)
    skillult_evacuate.finish = override(skillult_evacuate.finish, Superman.skillult_evacuate_finish)
  end
  local skillenter = hero.skills.Superman_enter
  local skillenter_awake = hero.skills.Superman_awake_enter
  if ed.protoAwake(hero.proto, 10065) then
    if skillenter_awake then
      skillenter_awake.info = ed.wraptable(skillenter_awake.info, {
        ["Init CD"] = 0
      })
      skillenter_awake.start = override(skillenter_awake.start, Superman.skillenter_awake_start)
      skillenter_awake.onAttackFrame = override(skillenter_awake.onAttackFrame, Superman.skillenter_awake_onAttackFrame)
    end
  elseif skillenter then
    skillenter.info = ed.wraptable(skillenter.info, {
      ["Init CD"] = 0
    })
    skillenter.start = override(skillenter.start, Superman.skillenter_start)
  end
  return hero
end

return Superman.init_hero
