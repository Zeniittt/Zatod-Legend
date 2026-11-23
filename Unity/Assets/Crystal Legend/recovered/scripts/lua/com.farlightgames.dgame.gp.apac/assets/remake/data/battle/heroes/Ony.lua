module("ed.battlehero", package.seeall)
local ed = ed
Ony = {}
Ony.Ony_interrupt_damage_ratio = 0.1
Ony.Ony_atk4_CD = 12
Ony.Ony_atk2_dragon_buffID = 1355
Ony.Ony_atk2_human_buffID1 = 1356
Ony.Ony_atk2_human_buffID2 = 1357
Ony.Ony_atk3_human_buffID = 1358
Ony.Ony_ult_self_buffID = 1359
Ony.Ony_dragon_base_buffID = 1360
Ony.Ony_dragon_human_buffID = 1361
Ony.Ony_danger_hp_ratio = 0.1
Ony.Ony_ult_ratio = 1
Ony.nil_bid = 1366
Ony.Ony_atk4_hastbuff_bid = 1364
Ony.Ony_atk4_fearbuff_bid = 1365
Ony.Ony_ult_start = 1367
Ony.Ony_ult_curse = 1369
Ony.Ony_ult_healHP_ratio = 0.05
Ony.Ony_ult_healMP = 100
Ony.Ony_atk2_human_STR_hpratio = 0.05
Ony.fly_moveMaxY = 35
Ony.atk4_DODG = 0.3
Ony.atk4_LFS = 0.75
Ony.atk4_ARM = 2
Ony.atk4_AD = 7.5
Ony.sawake_CD = 3

function Ony.add_stage_buff(hero)
  local skillatk4 = hero.skills.Ony_atk4
  if skillatk4 then
    local level = skillatk4.level
    if hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6 then
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 1360 then
          tbuff.timer = 0
        end
      end
      local bid = 1361
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      buff:setAttribute("LFS", Ony.atk4_LFS * level)
      buff:setAttribute("DODG", Ony.atk4_DODG * level)
      buff:setAttribute("AD", Ony.atk4_AD * level)
      hero:addBuff(buff, hero)
    else
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 1361 then
          tbuff.timer = 0
        end
      end
      local bid = 1360
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      buff:setAttribute("ARM", Ony.atk4_ARM * level)
      hero:addBuff(buff, hero)
    end
    hero.global_cd = 0.5
    hero.skills.Ony_dragon_atk3.cd_remaining = 0.5
  end
end

function Ony.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6 then
    local ratio = caster.mp / 500 * Ony.Ony_ult_ratio + 1
    caster.Ony_ult_human_power_ratio = ratio
    caster:setMP(0)
  else
    caster.Ony_ult_human_power_ratio = nil
  end
  local bid = Ony.Ony_ult_start
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
    caster.Ony_flyposition = {
      caster.position[1],
      caster.position[2]
    }
    caster:setMP(caster.mp - 1)
  end
end

function Ony.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and skill and (caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6) and caster.hp / caster.attribs.HP > Ony.Ony_danger_hp_ratio and caster.mp < 1000 then
    result = nil
  end
  return result
end

function Ony.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local human_target = skill.target
  local skillult_human_1 = caster.skills.Ony_human_ult1
  local skillult_human_2 = caster.skills.Ony_human_ult2
  if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 then
    if attack_counter == 0 then
      basefunc(skill)
    end
    if attack_counter == 1 then
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif (caster.currentActionStage == 2 or caster.currentActionStage == 4 or caster.currentActionStage == 6) and human_target then
    if attack_counter == 0 then
      local dir = human_target.direction
      caster:setPosition({
        human_target.position[1] + dir * 30,
        human_target.position[2]
      })
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      if ed.run_with_scene then
        ed.scene.background:setColor(ccc3(255, 0, 0))
      end
      skillult_human_1.info["Ignore Shield"] = true
      skillult_human_1.info["No Dodge"] = true
      skillult_human_1:takeEffectOn(human_target, caster)
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 2 then
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
        skill.caster.manually_casting = false
      end
      skillult_human_2.info["No Dodge"] = true
      skillult_human_2:takeEffectAt(caster.position)
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 3 then
      caster:setPosition({
        caster.Ony_flyposition[1],
        caster.Ony_flyposition[2]
      })
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function Ony.skillult_human_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if caster.Ony_ult_human_power_ratio then
    power = power * caster.Ony_ult_human_power_ratio
  end
  return power
end

function Ony.skillult_projectile_terminate(basefunc, projectile)
  basefunc(projectile)
  local caster = projectile.caster
  local skill = projectile.skill
  caster:setPosition({
    projectile.position[1],
    projectile.position[2]
  })
  if ed.run_with_scene then
    local effect_name = "eff_point_Ony_dragon_ult.cha"
    if not effect_name then
      return
    end
    local effect_z = 1
    ed.scene:playEffectOnScene(effect_name, projectile.position, {
      caster.direction,
      1
    }, nil, effect_z)
  end
  local bid = Ony.Ony_ult_self_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(50, 0.1, 2)
  end
  if not caster.buff_effects.polymorph then
    skill:onAttackFrame()
    if skill.current_phase then
      skill:gotoEventIdx(2)
    end
  end
end

function Ony.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.terminate = override(projectile.terminate, Ony.skillult_projectile_terminate)
  local v = 900
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.height = 300
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  local targetpos = {
    target.position[1] - 60 * caster.direction,
    target.position[2]
  }
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function Ony.skillult_human_buff_onRemoved(basefunc, buff)
  if buff.timer > 0 then
    local caster = buff.caster
    local skillult = caster.skills.Ony_ult
    local skillatk4 = caster.skills.Ony_atk4
    caster:takeHeal(skillult.info["Script Arg2"], "hp", caster)
    caster:takeHeal(skillult.info["Script Arg3"], "mp", caster)
    if skillatk4 and skillatk4.cd_remaining then
      skillatk4.cd_remaining = skillatk4.cd_remaining - 6
    end
  end
  basefunc(buff)
end

function Ony.skillult_finish(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene.background:setColor(ccc3(255, 255, 255))
  end
  local caster = skill.caster
  if caster.currentActionStage == 2 then
    caster:enterActionStageFromOneStage(1, 10056)
    Ony.add_stage_buff(caster)
  elseif caster.currentActionStage == 4 then
    caster:enterActionStageFromOneStage(3, 10056)
    Ony.add_stage_buff(caster)
  elseif caster.currentActionStage == 6 then
    caster:enterActionStageFromOneStage(5, 10056)
    Ony.add_stage_buff(caster)
  elseif caster.currentActionStage == 1 then
    caster:enterActionStageFromOneStage(2, 10056)
    Ony.add_stage_buff(caster)
  elseif caster.currentActionStage == 3 then
    caster:enterActionStageFromOneStage(4, 10056)
    Ony.add_stage_buff(caster)
  elseif caster.currentActionStage == 5 then
    caster:enterActionStageFromOneStage(6, 10056)
    Ony.add_stage_buff(caster)
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Ony.Ony_ult_start then
      tbuff.timer = 0
    end
  end
  local skillsawake = caster.skills.Ony_sawake
  if skillsawake then
    caster.Ony_sawake_hit_count = caster.Ony_sawake_hit_count + 1
  end
end

function Ony.skillult_humandragon_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target:isAlive() then
    local caster = skill.caster
    local bid = Ony.Ony_ult_curse
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff.onRemoved = override(buff.onRemoved, Ony.skillult_human_buff_onRemoved)
    local buffresult = target:addBuff(buff, caster)
  end
end

function Ony.skillatk2_dragon_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function Ony.skillatk2_dragon_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local bid = Ony.Ony_atk2_dragon_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, caster)
  basefunc(skill, target, source, shift)
  if buff then
    target:removeBuff(buff)
  end
end

function Ony.skillatk2_human_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local originfo = skill.info
  local skillatk2s = caster.skills.Ony_human_atk2s
  local target = skill.target
  if attack_counter <= 4 then
    basefunc(skill)
  elseif attack_counter == 5 and target and skillatk2s then
    skillatk2s:takeEffectAt(target.position)
  end
end

function Ony.skillatk2_human_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local result = basefunc(skill, target, source, shift)
  if result and skill.attack_counter == 4 then
    if target.info["Main Attrib"] == "INT" then
      local bid = Ony.Ony_atk2_human_buffID1
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, caster)
    elseif target.info["Main Attrib"] == "AGI" then
      local bid = Ony.Ony_atk2_human_buffID2
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, caster)
    elseif target.info["Main Attrib"] == "STR" then
      local Hpmax = 150000
      local ratio = Ony.Ony_atk2_human_STR_hpratio
      if Hpmax >= target.attribs.HP then
        target:takeDamage(target.attribs.HP * ratio / caster.attribs.PDM, "Holy", "hp", caster, 1, 0)
      else
        target:takeDamage(Hpmax * ratio / caster.attribs.PDM, "Holy", "hp", caster, 1, 0)
      end
    end
  end
end

function Ony.skillatk3_dragon_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local interrupt_damage = owner.attribs.HP * Ony.Ony_interrupt_damage_ratio
  owner.Ony_atk3_totaldamage = owner.Ony_atk3_totaldamage + damage
  if interrupt_damage <= owner.Ony_atk3_totaldamage then
    buff.timer = 0
    owner.Ony_atk3_totaldamage = 0
  end
  return damage
end

function Ony.skillatk3_dragon_buff_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Ony.skillatk3_dragon_buff_onDamaged)
  return buff
end

function Ony.skillatk3_human_buff_onRemoved(basefunc, buff)
  if buff.Ony_human_atk3_effect then
    local z = -1
    ed.scene:removeEffect(buff.Ony_human_atk3_effect, z)
  end
  if buff.Ony_human_atk3_effect2 then
    local z = -1
    ed.scene:removeEffect(buff.Ony_human_atk3_effect2, z)
  end
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  if owner.actor then
    owner.actor:launch(0)
  end
end

function Ony.skillatk3_human_buff_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local HPR = skill.info["Script Arg2"]
  local owner = buff.owner
  buff:setAttribute("HPR", HPR)
  buff.onRemoved = override(buff.onRemoved, Ony.skillatk3_human_buff_onRemoved)
  if ed.run_with_scene then
    local effect_name = "eff_point_Ony_human_atk3_1.cha"
    if not effect_name then
      return
    end
    local effect_z = -1
    buff.Ony_human_atk3_effect = ed.scene:playEffectOnScene(effect_name, owner.position, {
      owner.direction,
      1
    }, nil, effect_z)
  end
  if ed.run_with_scene then
    local effect_name = "eff_point_Ony_human_atk3_2.cha"
    if not effect_name then
      return
    end
    local effect_z = -1
    buff.Ony_human_atk3_effect2 = ed.scene:playEffectOnScene(effect_name, owner.position, {
      owner.direction,
      1
    }, nil, effect_z)
  end
  return buff
end

function Ony.skillatk3_human_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buff_effects.uncontrollable then
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
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function Ony.skillatk3_human_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local direction = {1, 0}
  local distance, t
  skill.info["No Dodge"] = true
  if attack_counter == 0 then
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      t = 0.25
      local dir = caster:getInitDir()
      if caster.position[1] - target.position[1] ~= 0 then
        dir = (caster.position[1] - target.position[1]) / math.abs(caster.position[1] - target.position[1])
      end
      distance = {
        -5 * dir,
        0
      }
      target:knockup(t, distance, true)
      basefunc(skill)
    end
    target.height = 35
    if target.actor then
      target.actor.height = 35
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Ony.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = self.skills.Ony_atk4
  if skillatk4 and self.Ony_atk4_CD and self.Ony_atk4_CD <= 0 and owner == self and self:isAlive() and not buff.Ony_trigger and buff.caster and buff.caster.camp ~= owner.camp and buff.info.ID ~= 4248 and buff.info.ID ~= 4263 and buff:isCrlEftConflictWithUncontrollable() then
    self.Ony_atk4_CD = Ony.Ony_atk4_CD
    local bid = Ony.nil_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    config.buff = ed.BuffCreate(binfo, owner, buff.caster)
    config.buff.Ony_trigger = true
    local bid2 = Ony.Ony_atk4_hastbuff_bid
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, owner, self)
    buff2:setAttribute("AD", skillatk4.info["Script Arg2"])
    local buffresult2 = owner:addBuff(buff2, self)
    local bid3 = Ony.Ony_atk4_fearbuff_bid
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    local bSucess, reason = ed.Buff.checkAddBuff(binfo3, skillatk4.level, caster, owner)
    if bSucess then
      local buff3 = ed.BuffCreate(binfo3, caster, self)
      buff3:setAttribute("fearrange", 5)
      local buffresult3 = caster:addBuff(buff3, self)
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Ony_atk4.cha"
      if not effect_name then
        return
      end
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, self.position, {
        self.direction,
        1
      }, nil, effect_z)
    end
  end
end

function Ony.hero_walkTowards(basefunc, unit, dest)
  if unit.controlledTarget and dest[2] > Ony.fly_moveMaxY then
    local trueDest = {
      dest[1],
      dest[2]
    }
    trueDest[2] = Ony.fly_moveMaxY
    basefunc(unit, trueDest)
  else
    basefunc(unit, dest)
  end
end

function Ony.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  local skillawake = hero.skills.Ony_awake
  local skillult = hero.skills.Ony_ult
  if not hero.Ony_awake and lost >= hero.hp then
    lost = 0
    local healHp = skillawake.info["Script Arg2"]
    hero:takeHeal(healHp, "hp", hero)
    hero.Ony_awake = true
    local bid = 1371
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    if hero.mp < 500 then
      hero.mp = 500
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Ony_awake.cha"
      if not effect_name then
        return
      end
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, hero.position, {
        hero.direction,
        1
      }, nil, effect_z)
    end
    hero:castSkill(skillult, nil)
    return lost
  end
  local skillsawake = hero.skills.Ony_sawake
  if skillsawake and hero.Ony_sawake_damaged_count and (hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6) then
    hero.Ony_sawake_damaged_count = hero.Ony_sawake_damaged_count + 1
  end
  return lost
end

function Ony.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.Ony_atk4
  if skillatk4 then
    hero.Ony_atk4_CD = hero.Ony_atk4_CD - dt
  end
  local skillsawake = hero.skills.Ony_sawake
  if skillsawake and hero.Ony_sawake_CdRemaining then
    hero.Ony_sawake_CdRemaining = hero.Ony_sawake_CdRemaining - dt
  end
  if ed.protoSuperAwake(hero.proto, 10056) and not hero.current_skill and (hero.currentActionStage == 1 or hero.currentActionStage == 3 or hero.currentActionStage == 5) and 3 <= hero.Ony_sawake_hit_count and hero.Ony_sawake_CdRemaining <= 0 then
    skillsawake:takeEffectAt(hero.position)
    if ed.run_with_scene then
      local effect = "eff_point_Ony_sawake.cha"
      local origin = hero.position
      ed.scene:playEffectOnScene(effect, origin, nil, nil, 1)
    end
    hero.Ony_sawake_hit_count = 0
    hero.Ony_sawake_damaged_count = 0
    hero.Ony_sawake_CdRemaining = Ony.sawake_CD
  end
  if ed.protoSuperAwake(hero.proto, 10056) and not hero.current_skill and (hero.currentActionStage == 2 or hero.currentActionStage == 4 or hero.currentActionStage == 6) and hero.Ony_sawake_damaged_count >= 6 and hero.Ony_sawake_CdRemaining <= 0 then
    skillsawake:takeEffectAt(hero.position)
    if ed.run_with_scene then
      local effect = "eff_point_Ony_sawake.cha"
      local origin = hero.position
      ed.scene:playEffectOnScene(effect, origin, nil, nil, 1)
    end
    hero.Ony_sawake_hit_count = 0
    hero.Ony_sawake_damaged_count = 0
    hero.Ony_sawake_CdRemaining = Ony.sawake_CD
  end
end

function Ony.hero_reset(basefunc, hero)
  basefunc(hero)
  Ony.add_stage_buff(hero)
  hero.Ony_atk3_totaldamage = 0
  hero.Ony_atk4_CD = 0
  hero.Ony_awake = nil
  hero.Ony_firstUlt = nil
  hero.Ony_sawake_hit_count = 0
  hero.Ony_sawake_damaged_count = 0
  hero.Ony_sawake_CdRemaining = 0
  local dir = hero:getInitDir()
  hero.Ony_flyposition = {
    400 - dir * 300,
    0
  }
  if ed.protoSuperAwake(hero.proto, 10056) then
    hero:enterActionStageFromOneStage(5, 10056)
  elseif ed.protoAwake(hero.proto, 10056) then
    hero:enterActionStageFromOneStage(3, 10056)
  else
    hero:enterActionStageFromOneStage(1, 10056)
  end
end

function Ony.skillatk2_dragon_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillsawake = caster.skills.Ony_sawake
  if skillsawake and caster.Ony_sawake_hit_count and (caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5) then
    caster.Ony_sawake_hit_count = caster.Ony_sawake_hit_count + 1
  end
end

function Ony.skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillsawake = caster.skills.Ony_sawake
  if skillsawake and caster.Ony_sawake_hit_count and (caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5) then
    caster.Ony_sawake_hit_count = caster.Ony_sawake_hit_count + 1
  end
end

function Ony.skillsawake_takeEffectOn(basefunc, skill, target, source)
  local mppower = skill.info["Script Arg1"]
  basefunc(skill, target, source)
  target:takeDamage(mppower, "Holy", "mp", skill.caster)
end

function Ony.init_hero(hero)
  local skillult = hero.skills.Ony_ult
  local skillult_human_1 = hero.skills.Ony_human_ult1
  local skillult_human_2 = hero.skills.Ony_human_ult2
  local skill_atk_dragon = hero.skills.Ony_dragon_atk
  local skill_atk2_dragon = hero.skills.Ony_dragon_atk2
  local skill_atk3_dragon = hero.skills.Ony_dragon_atk3
  local skill_atk_human = hero.skills.Ony_human_atk
  local skill_atk2_human = hero.skills.Ony_human_atk2
  local skill_atk3_human = hero.skills.Ony_human_atk3
  local skillatk4 = hero.skills.Ony_atk4
  local skillawake = hero.skills.Ony_awake
  local skillsawake = hero.skills.Ony_sawake
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Ony.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Ony.skillult_onAttackFrame)
    skillult_human_1.power = override(skillult_human_1.power, Ony.skillult_human_power)
    skillult_human_2.power = override(skillult_human_2.power, Ony.skillult_human_power)
    skillult.createProjectile = override(skillult.createProjectile, Ony.skillult_createProjectile)
    skillult.finish = override(skillult.finish, Ony.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Ony.skillult_humandragon_takeEffectOn)
    skillult_human_1.takeEffectOn = override(skillult_human_1.takeEffectOn, Ony.skillult_humandragon_takeEffectOn)
    skillult.start = override(skillult.start, Ony.skillult_start)
  end
  if skill_atk_dragon and skillsawake then
    skill_atk_dragon.finish = override(skill_atk_dragon.finish, Ony.skillatk_finish)
  end
  if skill_atk2_dragon then
    skill_atk2_dragon.onAttackFrame = override(skill_atk2_dragon.onAttackFrame, Ony.skillatk2_dragon_onAttackFrame)
    skill_atk2_dragon.takeEffectOn = override(skill_atk2_dragon.takeEffectOn, Ony.skillatk2_dragon_takeEffectOn)
    if skillsawake then
      skill_atk2_dragon.finish = override(skill_atk2_dragon.finish, Ony.skillatk2_dragon_finish)
    end
  end
  if skill_atk3_dragon then
    skill_atk3_dragon.createBuff = override(skill_atk3_dragon.createBuff, Ony.skillatk3_dragon_buff_createBuff)
  end
  if skill_atk_human and skillsawake then
    skill_atk_human.finish = override(skill_atk_human.finish, Ony.skillatk_finish)
  end
  if skill_atk2_human then
    skill_atk2_human.onAttackFrame = override(skill_atk2_human.onAttackFrame, Ony.skillatk2_human_onAttackFrame)
    skill_atk2_human.takeEffectOn = override(skill_atk2_human.takeEffectOn, Ony.skillatk2_human_takeEffectOn)
  end
  if skill_atk3_human then
    skill_atk3_human.onAttackFrame = override(skill_atk3_human.onAttackFrame, Ony.skillatk3_human_onAttackFrame)
    skill_atk3_human.createBuff = override(skill_atk3_human.createBuff, Ony.skillatk3_human_buff_createBuff)
    skill_atk3_human.selectTarget = override(skill_atk3_human.selectTarget, Ony.skillatk3_human_selectTarget)
  end
  if skillatk4 then
    hero.collectBuff = override(hero.collectBuff, Ony.collectBuff)
  end
  if skillawake then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, Ony.hero_getLostHPAfterImmunity)
  end
  if skillsawake then
    skillsawake.takeEffectOn = override(skillsawake.takeEffectOn, Ony.skillsawake_takeEffectOn)
  end
  hero.update = override(hero.update, Ony.hero_update)
  hero.reset = override(hero.reset, Ony.hero_reset)
  hero.walkTowards = override(hero.walkTowards, Ony.hero_walkTowards)
  hero:setActionStageChangeByManual(true)
  return hero
end

return Ony.init_hero
