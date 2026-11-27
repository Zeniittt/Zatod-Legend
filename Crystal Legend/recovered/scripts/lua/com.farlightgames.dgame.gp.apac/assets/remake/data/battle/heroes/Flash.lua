module("ed.battlehero", package.seeall)
local ed = ed
local math = math
Flash = {}
Flash.offBattleBuffID = 1418
Flash.ult_EnemyFixBuffID = 1423
Flash.ult_BlowAwayBuffID = 1424
Flash.atk2_ARM_Loss = 1421
Flash.atk3_BuffID = 1422
Flash.atk3_SlowAllBuffID = 1425
Flash.atk4_dragToWallBuffID = 1417
Flash.awake_speedFastBuffID = 1419
Flash.awake_speedSlowBuffID = 1420
Flash.enter_LateBuffID = 1426
Flash.atk4_knockupV = 1000
Flash.atk4_knockupV_min = 750

function Flash.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hitTime = 0
  local binfo = ed.lookupDataTable("Buff", nil, Flash.enter_LateBuffID)
  hero:addBuff(binfo, hero)
  if 0 < hero:getInitDir() then
    hero.position[1] = ed.engine.stage_rect.minX - 100
  else
    hero.position[1] = ed.engine.stage_rect.maxX + 100
  end
  hero.lastDirection = 1
  hero.Flash_actor_leaveScene = false
end

function Flash.hero_setAction(basefunc, self, action_name, loop, interrupt)
  if action_name == "Move" and self.push then
    action_name = "Idle"
  end
  basefunc(self, action_name, loop, interrupt)
end

function Flash.actor_gotoNextBattle(basefunc, actor)
  basefunc(actor)
  local puppet = actor.puppet
  local moveActionName = actor:getActionName("Birth2")
  puppet:setAction(moveActionName)
  puppet:setLoop(false)
  actor.velocity = {0, 0}
  actor.bar_hp:forceHide(true)
end

function Flash.actor_cheer(basefunc, actor)
  if actor.model.direction == 1 then
    actor.puppet:setComponent("TorsoTop", "TorsoTop")
    actor.puppet:setComponent("TorsoTop_CL", "TorsoTop_CL")
    actor.puppet:setComponent("TorsoTop_L", "TorsoTop_L")
  else
    actor.puppet:setComponent("TorsoTop", "TorsoTop_f")
    actor.puppet:setComponent("TorsoTop_CL", "TorsoTop_CL_f")
    actor.puppet:setComponent("TorsoTop_L", "TorsoTop_L_f")
  end
  basefunc(actor)
end

function Flash.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.actor and hero.direction ~= hero.lastDirection then
    if hero.direction == -1 then
      hero.actor.puppet:setComponent("TorsoTop", "TorsoTop_f")
      hero.actor.puppet:setComponent("TorsoTop_CL", "TorsoTop_CL_f")
      hero.actor.puppet:setComponent("TorsoTop_L", "TorsoTop_L_f")
    elseif hero.direction == 1 then
      hero.actor.puppet:setComponent("TorsoTop", "TorsoTop")
      hero.actor.puppet:setComponent("TorsoTop_CL", "TorsoTop_CL")
      hero.actor.puppet:setComponent("TorsoTop_L", "TorsoTop_L")
    end
    local actionName = hero.actor:getActionName(hero.action_name)
    hero.actor.puppet:setAction(actionName)
    hero.actor.puppet:setLoop(hero.action_loop)
    hero.actor.puppet:setActionElapsed(hero.action_elapsed)
  end
  hero.lastDirection = hero.direction
  if ed.run_with_scene and hero.actor and not hero.Flash_actor_leaveScene then
    hero.Flash_actor_leaveScene = true
    hero.actor.gotoNextBattle = override(hero.actor.gotoNextBattle, Flash.actor_gotoNextBattle)
    hero.actor.cheer = override(hero.actor.cheer, Flash.actor_cheer)
  end
end

function Flash.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local current_phase_idx = skill.current_phase_idx
  caster.ultTarget = skill.target or caster.ai.target
  local target = caster.ultTarget
  local binfo2 = ed.lookupDataTable("Buff", nil, Flash.offBattleBuffID)
  caster:addBuff(binfo2, caster)
  local binfo = ed.lookupDataTable("Buff", nil, Flash.ult_EnemyFixBuffID)
  target:addBuff(binfo, caster)
  caster.position = {
    target.position[1],
    target.position[2] - 1
  }
end

function Flash.skillult_buffUpdate(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local target = caster.ultTarget
  local distanceX = owner.position[1] - caster.position[1]
  local distanceY = owner.position[2] - caster.position[2]
  if not (not (math.abs(distanceX) < 200) and target.config.what ~= "lordUnit" and target:isAlive()) or target.buffManager.invisible or ed.engine.stage_info["Chapter ID"] == 103 or ed.engine.stage_type == "dreamland" or ed.engine.guildInstance_mode then
    owner.knockup_v = {
      -1.5 * distanceX,
      -distanceY
    }
    local skillult2 = caster.skills.Flash_ult2
    skillult2:takeEffectOn(owner, caster)
  end
  basefunc(buff, dt)
end

function Flash.skillult_buffonRemoved(basefunc, buff)
  local owner = buff.owner
  basefunc(buff)
  owner.knockup_v = {0, 0}
end

function Flash.skillult_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = caster.ultTarget or skill.target
  basefunc(skill, idx)
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 2 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit == target then
      else
        local binfo = ed.lookupDataTable("Buff", nil, Flash.ult_BlowAwayBuffID)
        local buff = unit:addBuff(binfo, caster)
        if buff then
          buff.target = target
          buff.update = override(buff.update, Flash.skillult_buffUpdate)
          buff.onRemoved = override(buff.onRemoved, Flash.skillult_buffonRemoved)
        end
      end
    end
  elseif current_phase_idx == 3 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == Flash.ult_BlowAwayBuffID then
          tbuff.timer = 0
        end
      end
    end
  end
end

function Flash.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  local attack_counter = skill.attack_counter
  local target = caster.ultTarget or skill.target
  if current_phase_idx == 2 and attack_counter == 3 then
    target:knockup(0.8, ed.edpMult({
      target.direction,
      0
    }, 10))
    local bid = 6
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
end

function Flash.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.position[1] - target.position[1] < 0 then
    caster.position[1] = target.position[1] - 60
    caster.position[2] = target.position[2]
  else
    caster.position[1] = target.position[1] + 60
    caster.position[2] = target.position[2]
  end
  basefunc(skill, target)
end

function Flash.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit = basefunc(skill, target, source, shift)
  if isHit then
    local binfo = ed.lookupDataTable("Buff", nil, Flash.atk2_ARM_Loss)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("ARM", skill.info["Script Arg2"])
    target:addBuff(buff, caster)
    target:knockup(0.1, ed.edpMult({
      caster.direction,
      0
    }, 10))
  end
end

function Flash.skillatk3_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if target.position[1] > ed.engine.stage_rect.maxX - 150 or target.position[1] < ed.engine.stage_rect.minX + 150 then
    return false
  else
    return basefunc(skill, target)
  end
end

function Flash.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.position[1] < ed.engine.stage_rect.minX then
    caster.position[1] = ed.engine.stage_rect.minX + 80
  elseif caster.position[1] > ed.engine.stage_rect.maxX then
    caster.position[1] = ed.engine.stage_rect.maxX - 80
  elseif caster.position[1] - target.position[1] < 0 then
    caster.position[1] = target.position[1] + 80
    caster.position[2] = target.position[2]
  else
    caster.position[1] = target.position[1] - 80
    caster.position[2] = target.position[2]
  end
  local binfo = ed.lookupDataTable("Buff", nil, Flash.atk3_BuffID)
  local buff = ed.BuffCreate(binfo, target, caster)
  buff:setAttribute("AD", skill.info["Script Arg2"])
  buff:setAttribute("HIT", skill.info["Script Arg3"])
  target:addBuff(buff, caster)
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit == caster then
    elseif math.abs(unit.position[1] - target.position[1]) > 200 then
    else
      local binfo = ed.lookupDataTable("Buff", nil, Flash.atk3_SlowAllBuffID)
      if ed.protoAwake(caster.proto, 10061) then
        buff:setAttribute("Effect", "eff_buff_Flash_charged_s.cha")
      end
      unit:addBuff(binfo, caster)
    end
  end
  basefunc(skill, target)
end

function Flash.skillatk4_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local canCast = basefunc(skill, target)
  local skillult = caster.skills.BruceWayne_ult
  if not (target.config.what ~= "lordUnit" and target:isAlive()) or target.buffManager.invisible or ed.engine.stage_info["Chapter ID"] == 103 or ed.engine.stage_type == "dreamland" or ed.engine.guildInstance_mode then
    return false
  else
    return basefunc(skill, target)
  end
end

function Flash.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  caster.atk4Target = skill.target
  caster.atk4_knockup_dir = caster.position[1] - caster.atk4Target.position[1]
  if caster.atk4_knockup_dir == 0 then
    caster.atk4_knockup_dir = -1 * caster.direction
  end
  if math.abs(caster.atk4_knockup_dir) < 100 then
    skill:startPhase(3)
  end
end

function Flash.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  local originfo = skill.info
  if current_phase_idx == 5 then
    skill.max_range_sq = 10000
  end
  if ed.protoAwake(caster.proto, 10061) then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Impact Effect"] = "eff_impact_Flash_atk4_s.cha"
    })
    basefunc(skill)
    skill.info = originfo
  else
    basefunc(skill)
  end
  skill.max_range_sq = skill.info["Max Range"] ^ 2
end

function Flash.skillatk4_buffUpdate(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.knockup_v[1] > 0 then
    owner.knockup_v[1] = math.max(Flash.atk4_knockupV_min, owner.knockup_v[1] - 50)
  else
    owner.knockup_v[1] = math.min(-Flash.atk4_knockupV_min, owner.knockup_v[1] + 50)
  end
  if owner.position[1] < ed.engine.stage_rect.minX + 200 and 0 < caster.atk4_knockup_dir or owner.position[1] > ed.engine.stage_rect.maxX - 200 and 0 > caster.atk4_knockup_dir then
    if 0 > caster.atk4_knockup_dir then
      owner.position[1] = ed.engine.stage_rect.maxX - 100
    else
      owner.position[1] = ed.engine.stage_rect.minX + 100
    end
    local bid = 6
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    owner:addBuff(binfo, caster)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationX(15, 0.1, 1)
    end
    owner.knockup_v = {0, 0}
    buff.timer = 0
  end
  basefunc(buff, dt)
end

function Flash.skillatk4_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  if owner.position[1] > ed.engine.stage_rect.maxX - 50 then
    owner.position[1] = ed.engine.stage_rect.maxX - 100
  elseif owner.position[1] < ed.engine.stage_rect.minX + 50 then
    owner.position[1] = ed.engine.stage_rect.minX + 100
  end
  owner.knockup_v = {0, 0}
  basefunc(buff)
end

function Flash.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit = basefunc(skill, target, source, shift)
  local current_phase_idx = skill.current_phase_idx
  local target = caster.atk4Target or skill.target
  skill.info["Ignore Shield"] = true
  if isHit and current_phase_idx == 3 then
    local bid = Flash.atk4_dragToWallBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
    if buff then
      buff.update = override(buff.update, Flash.skillatk4_buffUpdate)
      buff.onRemoved = override(buff.onRemoved, Flash.skillatk4_buffOnRemoved)
      if caster.atk4_knockup_dir < 0 then
        target.knockup_v = {
          Flash.atk4_knockupV,
          0
        }
      else
        target.knockup_v = {
          -Flash.atk4_knockupV,
          0
        }
      end
    end
  end
end

function Flash.skillatk4_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  local target = caster.atk4Target or skill.target
  basefunc(skill, idx)
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 4 then
    if caster.position[1] - target.position[1] < 0 then
      caster.position[1] = ed.engine.stage_rect.maxX - 150
      caster.position[2] = target.position[2]
      caster.direction = 1
    else
      caster.position[1] = ed.engine.stage_rect.minX + 150
      caster.position[2] = target.position[2]
      caster.direction = -1
    end
  end
end

function Flash.skillatk4_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local target = caster.atk4Target or skill.target
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 then
    if caster.position[1] - target.position[1] < 0 then
      caster.position[1] = target.position[1] - 60
      caster.position[2] = target.position[2]
    else
      caster.position[1] = target.position[1] + 60
      caster.position[2] = target.position[2]
    end
    skill:startPhase(current_phase_idx + 1)
  elseif current_phase_idx == 3 then
    if math.abs(caster.position[1] - target.position[1]) < 100 then
      skill:startPhase(current_phase_idx + 2)
    else
      skill:startPhase(current_phase_idx + 1)
    end
  elseif current_phase_idx == 5 then
    skill:finish()
  else
    skill:startPhase(current_phase_idx + 1)
  end
end

function Flash.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  skill.max_range_sq = skill.info["Max Range"] ^ 2
end

function Flash.skillawake_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local isHit = basefunc(skill, target, source, shift)
  local skillawake = caster.skills.Flash_awake
  if isHit then
    local binfo = ed.lookupDataTable("Buff", nil, Flash.awake_speedSlowBuffID)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("MSPD", skillawake.info["Script Arg2"])
    if ed.protoAwake(caster.proto, 10061) then
      buff:setAttribute("Effect", "eff_buff_Flash_charged_s.cha")
    end
    target:addBuff(buff, caster)
    local binfo2 = ed.lookupDataTable("Buff", nil, Flash.awake_speedFastBuffID)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    buff2:setAttribute("MSPD", skillawake.info["Script Arg3"])
    caster:addBuff(buff2, caster)
  end
end

function Flash.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if math.abs(caster.position[1] - target.position[1]) < 130 then
    skill:startPhase(2)
  elseif caster.position[1] - target.position[1] < 0 then
    caster.position[1] = target.position[1] - 60
    caster.position[2] = target.position[2]
  else
    caster.position[1] = target.position[1] + 60
    caster.position[2] = target.position[2]
  end
end

function Flash.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = 0
    end
  end
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 150 * caster:getInitDir()
  caster.direction = caster:getInitDir()
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Flash.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = 0
    end
  end
end

function Flash.init_hero(hero)
  local skillenter = hero.skills.Flash_enter
  local skillult = hero.skills.Flash_ult
  local skillatk = hero.skills.Flash_atk
  local skillatk2 = hero.skills.Flash_atk2
  local skillatk3 = hero.skills.Flash_atk3
  local skillatk4 = hero.skills.Flash_atk4
  local skillawake = hero.skills.Flash_awake
  hero.reset = override(hero.reset, Flash.hero_reset)
  hero.update = override(hero.update, Flash.hero_update)
  hero.setAction = override(hero.setAction, Flash.hero_setAction)
  if skillenter then
    skillenter.start = override(skillenter.start, Flash.skillenter_start)
    skillenter.finish = override(skillenter.finish, Flash.skillenter_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, Flash.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Flash.skillult_onAttackFrame)
    skillult.startPhase = override(skillult.startPhase, Flash.skillult_startPhase)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, Flash.skillatk_start)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Flash.skillatk2_start)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Flash.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Flash.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, Flash.skillatk4_canCastWithTarget)
    skillatk4.start = override(skillatk4.start, Flash.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Flash.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Flash.skillatk4_takeEffectOn)
    skillatk4.startPhase = override(skillatk4.startPhase, Flash.skillatk4_startPhase)
    skillatk4.onPhaseFinished = override(skillatk4.onPhaseFinished, Flash.skillatk4_onPhaseFinished)
    skillatk4.finish = override(skillatk4.finish, Flash.skillatk4_finish)
  end
  if skillawake then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Flash.skillawake_takeEffectOn)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Flash.skillawake_takeEffectOn)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Flash.skillawake_takeEffectOn)
  end
  return hero
end

return Flash.init_hero
