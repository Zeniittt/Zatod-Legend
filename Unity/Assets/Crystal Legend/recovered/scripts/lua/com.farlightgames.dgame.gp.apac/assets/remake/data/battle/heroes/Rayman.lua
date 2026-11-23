module("ed.battlehero", package.seeall)
local ed = ed
Rayman = {}
Rayman.debuff_decrease = 1
Rayman.projectile_duration = 1
Rayman.uncontrol_bid = 1338
Rayman.ult_HAST_bid = 1339
Rayman.heart_bid = 1334
Rayman.atk_temp_HAST_bid = 1341
Rayman.purify_effect = "eff_impact_purify"
Rayman.heartbreak_effect = "eff_buff_Rayman_heartbreak"
Rayman.atk3_down_time = {
  0.75,
  1,
  0.7,
  0.8
}
Rayman.atk3_search_range = {
  220,
  150,
  150,
  0
}
Rayman.atk3_final_range = 170
Rayman.atk3_final_knockup = 0.3
Rayman.atk3_final_knockback = 10
Rayman.heart_birth_height = 60
Rayman.heart_destination_height = 0
Rayman.heart_travel_time = 0.8
Rayman.heart_position_adjustment = 30
Rayman.invulnerable_bid = 1336
Rayman.blink_buff = 1345
Rayman.classicalFashionId = 100551

function Rayman.ActionStage_CDrecord(hero)
  local skillult = hero.skills.Rayman_ult
  local skillatk = hero.skills.Rayman_atk
  local skillatk2 = hero.skills.Rayman_atk2
  local skillatk3 = hero.skills.Rayman_atk3
  if skillult then
    skillult.temp_cd = skillult.cd_remaining
  end
  if skillatk then
    skillatk.temp_cd = skillatk.cd_remaining
  end
  if skillatk2 then
    skillatk2.temp_cd = skillatk2.cd_remaining
  end
  if skillatk3 then
    skillatk3.temp_cd = skillatk3.cd_remaining
  end
end

function Rayman.ActionStage_CDset(hero)
  local skillult = hero.skills.Rayman_ult
  local skillatk = hero.skills.Rayman_atk
  local skillatk2 = hero.skills.Rayman_atk2
  local skillatk3 = hero.skills.Rayman_atk3
  if skillult then
    skillult.cd_remaining = skillult.temp_cd
  end
  if skillatk then
    skillatk.cd_remaining = skillatk.temp_cd
  end
  if skillatk2 then
    skillatk2.cd_remaining = skillatk2.temp_cd
  end
  if skillatk3 then
    skillatk3.cd_remaining = skillatk3.temp_cd
  end
end

function Rayman.ult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid1 = Rayman.uncontrol_bid
  local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
  local buff1 = caster:addBuff(binfo1, caster)
  basefunc(skill, target)
  if caster.has_punch == 1 then
    skill:startPhase(2)
  elseif caster.has_punch == 2 then
    skill:startPhase(3)
  end
end

function Rayman.ult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  if skill.attack_counter ~= 0 then
    local caster = skill.caster
    local skillult1 = caster.skills.Rayman_ult1
    local skillult2 = caster.skills.Rayman_ult2
    local originfo = skill.info
    if not caster.has_punch then
      local projectile = skillult1:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      ed.engine:addProjectile(projectile)
    else
      local projectile = skillult2:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      ed.engine:addProjectile(projectile)
    end
    skill.info = originfo
  end
  skill.attack_counter = skill.attack_counter + 1
end

function Rayman.ult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Rayman.ult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  if not caster.has_punch or caster.has_punch < 2 then
    Rayman.ActionStage_CDrecord(caster)
    caster:enterActionStageFromOneStage(caster.currentActionStage + 2, 10055)
    Rayman.ActionStage_CDset(caster)
    if not caster.has_punch then
      caster.has_punch = 1
    else
      caster.has_punch = 2
    end
  end
end

function Rayman.ult_canCasterWithTarget(basefunc, self, target)
  local caster = self.caster
  if caster.Rayman_heart_projectile then
    return false
  end
  return basefunc(self, target)
end

function Rayman.Bluepunch_hit(basefunc, self, target)
  local caster = self.skill.caster
  local skillawake = caster.skills.Rayman_awake
  if target.camp ~= caster.camp then
    basefunc(self, target)
  elseif skillawake then
    Rayman.awake_decrease(caster, target)
  end
end

function Rayman.Bluepunch_createProjectile(basefunc, self)
  self:selectTarget(nil)
  local projectile = basefunc(self)
  projectile.hit = override(projectile.hit, Rayman.Bluepunch_hit)
  projectile.velocity = {
    self.info["Tile XY Speed"] * self.caster.direction,
    0
  }
  return projectile
end

function Rayman.Redpunch_hit(basefunc, self, target)
  local caster = self.skill.caster
  local skillawake = caster.skills.Rayman_awake
  if target.camp ~= caster.camp then
    basefunc(self, target)
  elseif skillawake then
    Rayman.awake_decrease(caster, target)
  end
end

function Rayman.Redpunch_createProjectile(basefunc, self)
  self:selectTarget(nil)
  local projectile = basefunc(self)
  projectile.hit = override(projectile.hit, Rayman.Redpunch_hit)
  projectile.velocity = {
    self.info["Tile XY Speed"] * self.caster.direction,
    0
  }
  return projectile
end

function Rayman.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.has_punch then
    local bid = Rayman.atk_temp_HAST_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
end

function Rayman.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillawake = caster.skills.Rayman_awake
  local result, dmg, Crit, lfs_amount
  if caster.camp == target.camp then
    result = true
    dmg = 0
    Crit = false
    lfs_amount = 0
    if skillawake then
      Rayman.awake_decrease(caster, target)
    end
  else
    result, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  end
  skill.target_hit = true
  return result, dmg, Crit, lfs_amount
end

function Rayman.skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult1 = caster.skills.Rayman_ult1
  local skillult2 = caster.skills.Rayman_ult2
  local originfo = skill.info
  if caster.has_punch then
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = 0.7,
      ["Gain MP"] = 50
    })
    if caster.has_punch == 1 then
      local projectile = skillult1:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      ed.engine:addProjectile(projectile)
    else
      local projectile = skillult2:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      ed.engine:addProjectile(projectile)
    end
  end
  basefunc(skill)
  skill.info = originfo
end

function Rayman.skillatk_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if caster.has_punch then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Rayman.atk_temp_HAST_bid then
        caster:removeBuff(tbuff)
      end
    end
    basefunc(skill)
  else
    skill:finish()
  end
end

function Rayman.skillatk_finish(basefunc, skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Rayman.atk_temp_HAST_bid then
      caster:removeBuff(tbuff)
    end
  end
  local info = skill.info
  if skill.attack_counter == 0 then
    skill.cd_remaining = info.CD * 0.5
    skill.caster.global_cd = info["Global CD"] * 0.5
  else
    skill.cd_remaining = info.CD
  end
  basefunc(skill, reason)
end

function Rayman.skillatk2_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  caster.Rayman_left = 0
  caster.Rayman_right = 0
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.position[1] > caster.position[1] and unit.position[1] - caster.position[1] < 340 and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      caster.Rayman_right = caster.Rayman_right + 1
    elseif unit.position[1] < caster.position[1] and caster.position[1] - unit.position[1] < 340 and unit.position[1] > ed.engine.stage_rect.minX and unit.position[1] < ed.engine.stage_rect.maxX then
      caster.Rayman_left = caster.Rayman_left + 1
    end
  end
  if not basefunc(skill, target) or caster.Rayman_left == 0 and caster.Rayman_right == 0 then
    return false
  end
  return true
end

function Rayman.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Rayman.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if caster.Rayman_left > caster.Rayman_right then
    caster.direction = -1
  elseif caster.Rayman_left < caster.Rayman_right then
    caster.direction = 1
  else
    caster.direction = -caster:getInitDir()
  end
  basefunc(skill, target)
end

function Rayman.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillawake = caster.skills.Rayman_awake
  local result, dmg, Crit, lfs_amount
  if caster.camp == target.camp then
    result = true
    dmg = 0
    Crit = false
    lfs_amount = 0
    if skillawake then
      Rayman.awake_decrease(caster, target)
    end
  else
    result, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  end
  skill.target_hit = true
  return result, dmg, Crit, lfs_amount
end

function Rayman.projectile_update(basefunc, self, dt)
  basefunc(self, dt)
  self.Rayman_duration = self.Rayman_duration - dt
  if self.Rayman_duration - dt <= 0 then
    self:terminate()
  end
end

function Rayman.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult1 = caster.skills.Rayman_ult1
  local skillult2 = caster.skills.Rayman_ult2
  if caster.has_punch then
    if caster.has_punch == 1 then
      local projectile = skillult1:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      ed.engine:addProjectile(projectile)
    else
      local projectile = skillult2:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      ed.engine:addProjectile(projectile)
    end
  end
  basefunc(skill)
end

function Rayman.skillatk2_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Rayman.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Rayman.skillatk3_func_hideBuffEffect(unit)
  for i, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
end

function Rayman.skillatk3_func_resetBuffEffect(unit)
  for i, buff in ipairs(unit.buff_list) do
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(true)
      end
    end
  end
end

function Rayman.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Rayman.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  skill.nexttarget = nil
  skill.Rayman_bounce_time = 0
  Rayman.skillatk3_func_hideBuffEffect(caster)
  caster.Rayman_atk3_chosen_list = {}
  skill.attack_counter = 0
  basefunc(skill, target)
  skill.Rayman_current_direction = caster.direction
end

function Rayman.skillatk3_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local times = math.ceil(skill.attack_counter / 2)
  if times == 0 then
    return nil
  end
  local distance = Rayman.atk3_search_range[times]
  local nexttarget
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    local unitdistance = math.abs(unit.position[1] - caster.position[1])
    if unit.Rayman_atk3_chosen then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif distance >= unitdistance then
      nexttarget = unit
      distance = unitdistance
    end
  end
  skill.target = nexttarget
  return skill.target
end

function Rayman.skillatk3_finalposition(skill)
  local hero = skill.caster
  local maxcount = 0
  local finalposition
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Shape Arg1"] = Rayman.atk3_final_range,
    ["Knock Up"] = Rayman.atk3_final_knockup,
    ["Knock Back"] = Rayman.atk3_final_knockback,
    ["Buff ID"] = 0
  })
  for temptarget in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if temptarget.buff_effects.untargetable then
    else
      local position = {
        temptarget.position[1] - 70 * hero.direction,
        temptarget.position[2]
      }
      if math.abs(position[1] - hero.position[1]) > 200 then
      else
        local list = skill:collectAoeTarget(position, hero.direction)
        if maxcount < #list then
          maxcount = #list
          finalposition = position
        end
        if #list == maxcount and #list ~= 0 then
          local originfo = skill.info
          skill.info = ed.wraptable(originfo, {
            ["Shape Arg1"] = originfo["Shape Arg1"] / 2
          })
          local retest_list1 = skill:collectAoeTarget(finalposition, hero.direction)
          local retest_list2 = skill:collectAoeTarget(position, hero.direction)
          if #retest_list1 < #retest_list2 then
            finalposition = position
          end
        end
      end
    end
  end
  skill.info = originfo
  if finalposition then
    return finalposition
  else
    return hero.position
  end
end

function Rayman.skillatk3_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  local caster = skill.caster
  local originfo = skill.info
  if originfo["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + originfo["Move Forward"] * caster.direction
  end
  if skill.attack_counter == 6 then
    local skillatk4 = caster.skills.Rayman_atk4
    local skillatk4s = caster.skills.Rayman_atk4s
    if skillatk4 and not caster.Rayman_hasHeart and caster.Rayman_heart_times then
      caster:addBuff(skillatk4:createBuff(caster))
      if skill.nexttarget then
        skill.nexttarget:addBuff(skillatk4s:createBuff(skill.nexttarget))
      end
      caster.Rayman_heart_times = caster.Rayman_heart_times - 1
      if 0 >= caster.Rayman_heart_times then
        caster.Rayman_heart_times = nil
      end
      caster.Rayman_hasHeart = true
    end
  elseif skill.attack_counter == 8 then
    local plus_ratio = originfo["Plus Ratio"] + 0.1 * skill.Rayman_bounce_time
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = Rayman.atk3_final_range,
      ["Knock Up"] = Rayman.atk3_final_knockup,
      ["Knock Back"] = Rayman.atk3_final_knockback,
      ["Plus Ratio"] = plus_ratio,
      ["Buff ID"] = 0
    })
  end
  if skill.attack_counter % 2 == 0 then
    if skill.nexttarget then
      skill:takeEffectAt(skill.nexttarget.position)
    elseif skill.finalposition then
      skill:takeEffectAt(skill.finalposition)
    end
    caster:setMP(caster.mp + originfo["Gain MP"] * ed.engine.mp_bonus)
    caster.walk_v = {0, 0}
    skill.Rayman_landing_timer = nil
  end
  if skill.attack_counter % 2 == 1 then
    skill.Rayman_current_direction = caster.direction
    skill.nexttarget = skill:selectTarget(nil)
    if skill.nexttarget then
      skill.nexttarget.Rayman_atk3_chosen = true
      table.insert(caster.Rayman_atk3_chosen_list, skill.nexttarget)
    else
      skill.finalposition = Rayman.skillatk3_finalposition(skill)
    end
    local temp_v = Rayman.skillatk3_speed_modify(skill.caster, skill)
    if temp_v[1] >= 0 then
      skill.Rayman_current_direction = 1
    else
      skill.Rayman_current_direction = -1
    end
  end
  skill.info = originfo
end

function Rayman.skillatk3_onPhaseFinished(basefunc, skill)
  skill.Rayman_bounce_time = skill.Rayman_bounce_time + 1
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == #skill.phase_list then
    skill:finish()
  else
    if skill.target_hit and skill.nexttarget then
      skill:startPhase(current_phase_idx + 1)
    else
      skill.attack_counter = 7
      skill:startPhase(4)
    end
    skill.target_hit = nil
  end
end

function Rayman.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillawake = caster.skills.Rayman_awake
  if skill.finalposition or target == skill.nexttarget then
    local result, dmg, Crit, lfs_amount
    if caster.camp == target.camp then
      if skillawake then
        Rayman.awake_decrease(caster, target)
      end
      skill.target_hit = true
      result = true
      dmg = 0
      Crit = false
      lfs_amount = 0
    else
      result, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
    end
    skill.target_hit = true
    return result, dmg, Crit, lfs_amount
  end
end

function Rayman.skillatk3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Rayman.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
  if caster.Rayman_hasHeart == true and caster.currentActionStage % 2 == 1 then
    Rayman.ActionStage_CDrecord(caster)
    caster:enterActionStageFromOneStage(caster.currentActionStage + 1, 10055)
    Rayman.ActionStage_CDset(caster)
  end
  Rayman.skillatk3_func_resetBuffEffect(caster)
  skill.finalposition = nil
  skill.nexttarget = nil
  if caster.Rayman_heart_projectile then
    caster.Rayman_heart_projectile:terminate()
  end
  caster.Rayman_heart_projectile = nil
  if caster.Rayman_atk3_chosen_list then
    for i, unit in ipairs(caster.Rayman_atk3_chosen_list) do
      if unit:isAlive() then
        unit.Rayman_atk3_chosen = nil
      end
    end
  end
end

function Rayman.skillatk3_speed_modify(hero, skill)
  local position
  if skill.finalposition then
    position = skill.finalposition
  elseif skill.nexttarget then
    position = skill.nexttarget.position
  else
    position = hero.position
  end
  local distance1 = position[1] - hero.position[1]
  local distance2 = position[2] - hero.position[2]
  if not skill.Rayman_landing_timer then
    local times = math.ceil(skill.attack_counter / 2)
    skill.Rayman_landing_timer = Rayman.atk3_down_time[times]
    skill.normal_walk_v = {
      distance1 / skill.Rayman_landing_timer,
      distance2 / skill.Rayman_landing_timer
    }
  end
  local v = {
    distance1 / skill.Rayman_landing_timer,
    distance2 / skill.Rayman_landing_timer
  }
  return v
end

function Rayman.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.action_name ~= "Move2" then
    hero.Rayman_entered = true
  end
  if ed.run_with_scene and not hero.cheer_action_reset and hero.actor then
    hero.cheer_action_reset = true
    hero.actor.cheer = override(hero.actor.cheer, Rayman.battle_cheer)
  end
  local current_skill = hero.current_skill
  local skillatk3 = hero.skills.Rayman_atk3
  if skillatk3 and current_skill == skillatk3 then
    if skillatk3.Rayman_current_direction and hero.direction ~= skillatk3.Rayman_current_direction then
      hero.direction = skillatk3.Rayman_current_direction
    end
    if skillatk3.Rayman_landing_timer then
      skillatk3.Rayman_landing_timer = skillatk3.Rayman_landing_timer - dt
      if skillatk3.Rayman_landing_timer <= 0 then
        skillatk3.Rayman_landing_timer = nil
        hero.walk_v = {0, 0}
      else
        hero.walk_v = Rayman.skillatk3_speed_modify(hero, skillatk3)
      end
    end
  end
end

function Rayman.battle_cheer(basefunc, self)
  local puppet = self.puppet
  local cheerActionName = self:getActionName("Cheer2")
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  self.velocity = {0, 0}
  local direction = FlipDirection(self.model.direction)
  self.node:setScaleX(direction)
  self.node:setScaleY(1)
  self.offline = true
end

function Rayman.actor_update(basefunc, self, dt)
  basefunc(self, dt)
  local unit = self.model
  local actor_walk_v = {0, 0}
  local skillatk3 = unit.skills.Rayman_atk3
  if skillatk3 and unit.current_skill == skillatk3 then
    if skillatk3.Rayman_landing_timer then
      skillatk3.Rayman_landing_timer = skillatk3.Rayman_landing_timer - dt
      if 0 >= skillatk3.Rayman_landing_timer then
        skillatk3.Rayman_landing_timer = nil
        actor_walk_v = {0, 0}
      else
        actor_walk_v = Rayman.skillatk3_speed_modify(unit, skillatk3)
      end
      if math.abs(actor_walk_v[1]) > 4 * math.abs(skillatk3.normal_walk_v[1]) then
        actor_walk_v[1] = 0
      end
      if math.abs(actor_walk_v[2]) > 4 * math.abs(skillatk3.normal_walk_v[2]) then
        actor_walk_v[2] = 0
      end
    end
    self.position[1] = self.position[1] + actor_walk_v[1] * dt
    self.position[2] = self.position[2] + actor_walk_v[2] * dt
    unit.position = self.position
  end
end

function Rayman.skillatk3_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local actor = owner.actor
  if actor then
    if buff.targetsmall[1] <= 1 then
      buff.scale_id = actor:useScale(buff.targetsmall)
      buff.targetsmall[1] = buff.targetsmall[1] + 0.05
      buff.targetsmall[2] = buff.targetsmall[2] + 0.05
    else
      buff.scale_id = actor:useScale({1, 1})
    end
  end
end

function Rayman.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.targetsmall = {0.8, 0.8}
  buff.update = override(buff.update, Rayman.skillatk3_buff_update)
  return buff
end

function Rayman.Vbuff_update(basefunc, buff, dt)
  buff.countdown = buff.countdown - 1
  if buff.countdown <= 0 then
    local owner = buff.owner
    local bid = Rayman.blink_buff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local blink_buff = owner:addBuff(binfo, owner)
    buff.countdown = 6
  end
  basefunc(buff, dt)
end

function Rayman.skillatk4_buff_onDamaged(basefunc, buff, damage, damage_type, source)
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if maxdmg >= lastdamage or not buff.caster:isAlive() then
    return damage
  else
    damage = 0
    local effect_name = Rayman.heartbreak_effect
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
    end
    owner:setAction("Damaged")
    local bid = Rayman.invulnerable_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local Vbuff = ed.BuffCreate(binfo, owner, owner)
    Vbuff.update = override(Vbuff.update, Rayman.Vbuff_update)
    Vbuff.countdown = 2
    owner:addBuff(Vbuff)
    local skillatk4 = owner.skills.Rayman_atk4
    owner:takeHeal(skillatk4.info["Script Arg2"], "hp", owner)
    owner:removeBuff(buff)
    return damage
  end
end

function Rayman.skillatk4_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner.currentActionStage % 2 == 0 then
    Rayman.ActionStage_CDrecord(owner)
    owner:enterActionStageFromOneStage(owner.currentActionStage - 1, 10055)
    Rayman.ActionStage_CDset(owner)
  end
  owner.Rayman_hasHeart = nil
end

function Rayman.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Rayman.skillatk4_buff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, Rayman.skillatk4_buff_onRemoved)
  return buff
end

function Rayman.skillatk4s_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4s2 = caster.skills.Rayman_atk4s2
  local projectile = skillatk4s2:createProjectile()
  local skillatk3 = caster.skills.Rayman_atk3
  local targetposition = skillatk3.finalposition
  targetposition = targetposition or caster.position
  projectile.position = {
    owner.position[1],
    owner.position[2]
  }
  projectile.height = Rayman.heart_birth_height
  projectile.Rayman_heart_position = targetposition
  projectile.Rayman_heart_travel_time = Rayman.heart_travel_time
  projectile.Rayman_heart_normalV = {
    (projectile.position[1] - targetposition[1]) / Rayman.heart_travel_time,
    (projectile.position[2] - targetposition[2]) / Rayman.heart_travel_time
  }
  projectile.velocity = {
    0.1 * caster.direction,
    0
  }
  projectile.zSpeed = 0
  ed.engine:addProjectile(projectile)
  if projectile.actor then
    projectile.actor.update = override(projectile.actor.update, Rayman.skillatk4s2_projectile_actor_update)
  else
    projectile:terminate()
  end
  caster.Rayman_heart_projectile = projectile
end

function Rayman.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Rayman.skillatk4s_buff_onRemoved)
  return buff
end

function Rayman.skillatk4s2_projectile_actor_update(basefunc, self, dt)
  basefunc(self, dt)
  local m = self.model
  m.Rayman_heart_travel_time = m.Rayman_heart_travel_time - dt
  local zSpeed = (Rayman.heart_birth_height - Rayman.heart_destination_height) / Rayman.heart_travel_time
  self.height = self.height - zSpeed * dt
  m.height = self.height
  local targetpositon = m.Rayman_heart_position
  local v1 = -(targetpositon[1] - self.position[1]) / m.Rayman_heart_travel_time * 2
  local v2 = -(targetpositon[2] - self.position[2]) / m.Rayman_heart_travel_time * 2
  if math.abs(v1) > 4 * math.abs(m.Rayman_heart_normalV[1]) then
    v1 = 0
  end
  if math.abs(v2) > 4 * math.abs(m.Rayman_heart_normalV[2]) then
    v1 = 0
  end
  self.position[1] = self.position[1] - v1 * dt
  self.position[2] = self.position[2] - v2 * dt
  m.position = self.position
  local caster = m.skill.caster
  local skillatk3 = caster.skills.Rayman_atk3
  if caster.current_skill ~= skillatk3 then
    m:terminate()
  end
end

function Rayman.awake_decrease(hero, target)
  local negative_effects = {
    stun = true,
    silence = true,
    disarm = true,
    enchanted = true,
    fear = true
  }
  local skillawake = hero.skills.Rayman_awake
  local isBuff
  for i, buff in ipairs(target.buff_list) do
    if buff.info["Control Effects"] and buff.info.Dispel == "YES" then
      for i, effect in ipairs(buff.info["Control Effects"]) do
        if negative_effects[effect] then
          buff.timer = buff.timer - skillawake.info["Script Arg2"]
          isBuff = true
          break
        end
      end
    end
  end
  if isBuff and ed.run_with_scene then
    local effect_name = Rayman.purify_effect
    ed.scene:playEffectOnScene(effect_name, target.position, {1, 1}, nil, 1)
  end
end

function Rayman.walkTowards(basefunc, self, dest)
  if self.Rayman_entered or self.name ~= "Rayman" then
    basefunc(self, dest)
  else
    if not self:isAlive() then
      return
    end
    if (self.buff_effects.stun or self.buff_effects.stunbyself) and self.controlledTarget then
      return
    end
    if self.state == ed.emUnitState_Attack and self.controlledTarget then
      self.current_skill:onPhaseFinished()
    end
    if self.state ~= ed.emUnitState_Walk then
      self.state = ed.emUnitState_Walk
      self:setAction("Move2", true)
    end
    local base_speed = self.info["Walk Speed"]
    local direction = ed.edpSub(dest, self.position)
    if direction[1] == 0 and direction[2] == 0 then
      self.walk_v = {0, 0}
    else
      if not self.controlledTarget then
        direction = {
          direction[1] * math.abs(direction[1]),
          direction[2] * math.abs(direction[2])
        }
      end
      self.walk_v = ed.edpMult(ed.edpNormalize(direction), base_speed * self.walk_speed_multiplier)
      self.walk_time = math.abs(direction[1] / self.walk_v[1])
    end
  end
end

function Rayman.reset(basefunc, self)
  basefunc(self)
  self.has_punch = nil
  self.Rayman_entered = nil
  self.cheer_action_reset = nil
  self.Rayman_hasHeart = nil
  self.Rayman_heart_times = 2
  if ed.protoAwake(self.proto, 10055) then
    if Rayman.classicalFashionId and Rayman.classicalFashionId == self.fashion_id then
      self:enterActionStageFromOneStage(1, 10055)
    else
      self:enterActionStageFromOneStage(7, 10055)
    end
  else
    self:enterActionStageFromOneStage(1, 10055)
  end
end

function Rayman.init_hero(hero)
  local ult = hero.skills.Rayman_ult
  local ult1 = hero.skills.Rayman_ult1
  local ult2 = hero.skills.Rayman_ult2
  local skillatk = hero.skills.Rayman_atk
  local skillatk2 = hero.skills.Rayman_atk2
  local skillatk3 = hero.skills.Rayman_atk3
  local skillatk4 = hero.skills.Rayman_atk4
  local skillatk4s = hero.skills.Rayman_atk4s
  local skillatk4s2 = hero.skills.Rayman_atk4s2
  hero:setActionStageChangeByManual(true)
  if ult then
    ult.start = override(ult.start, Rayman.ult_start)
    ult.onAttackFrame = override(ult.onAttackFrame, Rayman.ult_onAttackFrame)
    ult.onPhaseFinished = override(ult.onPhaseFinished, Rayman.ult_onPhaseFinished)
    ult.finish = override(ult.finish, Rayman.ult_finish)
    ult.canCastWithTarget = override(ult.canCastWithTarget, Rayman.ult_canCasterWithTarget)
    if ult1 then
      ult1.createProjectile = override(ult1.createProjectile, Rayman.Bluepunch_createProjectile)
    end
    if ult2 then
      ult2.createProjectile = override(ult2.createProjectile, Rayman.Redpunch_createProjectile)
    end
  end
  if skillatk then
    skillatk.start = override(skillatk.start, Rayman.skillatk_start)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Rayman.skillatk_takeEffectOn)
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Rayman.skillatk_onAttackFrame)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Rayman.skillatk_onPhaseFinished)
    skillatk.finish = override(skillatk.finish, Rayman.skillatk_finish)
  end
  if skillatk2 then
    skillatk2.canCastWithTarget = override(skillatk2.canCastWithTarget, Rayman.skillatk2_canCastWithTarget)
    skillatk2.start = override(skillatk2.start, Rayman.skillatk2_start)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Rayman.skillatk2_takeEffectOn)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Rayman.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, Rayman.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Rayman.skillatk3_start)
    skillatk3.createBuff = override(skillatk3.createBuff, Rayman.skillatk3_createBuff)
    skillatk3.selectTarget = override(skillatk3.selectTarget, Rayman.skillatk3_selectTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Rayman.skillatk3_onAttackFrame)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Rayman.skillatk3_onPhaseFinished)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Rayman.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, Rayman.skillatk3_finish)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Rayman.skillatk4_createBuff)
    if skillatk4s then
      skillatk4s.createBuff = override(skillatk4s.createBuff, Rayman.skillatk4s_createBuff)
    end
  end
  hero.walkTowards = override(hero.walkTowards, Rayman.walkTowards)
  hero.update = override(hero.update, Rayman.update)
  hero.reset = override(hero.reset, Rayman.reset)
  return hero
end

return Rayman.init_hero
