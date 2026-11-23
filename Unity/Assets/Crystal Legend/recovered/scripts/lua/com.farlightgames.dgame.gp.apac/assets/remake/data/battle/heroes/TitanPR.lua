module("ed.battlehero", package.seeall)
local ed = ed
TitanPR = {}
TitanPR.skillenter_buff_ally_ID = 4136
TitanPR.skillenter_buff_enemy_ID = 4137
TitanPR.skillenter_buff_featherSOL_ID = 4138
TitanPR.skillenter_buff_featherSOLenemy_ID = 4202
TitanPR.skillenter_buff_invulnerable_ID = 4144
TitanPR.skillult_buff_MPR_ID = 4134
TitanPR.skillatk3_buff_inv_ID = 4145
TitanPR.skillatk3_buff_begin_ID = 4135
TitanPR.skillult_posZ_plus = 100
TitanPR.skillult_posX_plus = 50
TitanPR.skillenter_buff_invis_ID = 651
TitanPR.skillenter_buff_show_ID = 665
TitanPR.skillatk3_buff_building_ID = 4146
TitanPR.skillult_buff_wait_ID = 1677
TitanPR.skillult_buff_inv_ID = 4152
TitanPR.skillult_buff_DCHast_ID = 4153
TitanPR.ULT_percent = 1
TitanPR.Fashion_ID = 100801
TitanPR.heroID = 10080

function TitanPR.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanPR.skillenter_buff_invis_ID then
      tbuff.timer = 0
    end
  end
  local bid = TitanPR.skillenter_buff_show_ID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanPR.skillenter_finish(basefunc, skill, reason)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanPR.skillenter_buff_show_ID then
      tbuff.timer = 0
    end
  end
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanPR_atk2
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit:isAlive() then
      local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillenter_buff_ally_ID)
      local buff = ed.BuffCreate(binfo, unit, caster)
      if skillatk2 then
        buff:setAttribute("ARM.a", skillatk2.info["Script Arg2"])
        if caster.TitanPR_hasArcana and caster.TitanPR_hasArcana > 2 then
          buff:setAttribute("MR.a", skillatk2.info["Script Arg2"])
        end
        buff:setAttribute("DODG.a", skillatk2.info["Script Arg2"])
      end
      unit:addBuff(buff, caster)
    end
  end
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit:isAlive() then
      local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillenter_buff_enemy_ID)
      local buff = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(buff, caster)
    end
  end
  caster.TitanPR_firstEnter = nil
end

function TitanPR.hero_enterActionStageFromOneStage(basefunc, unit, nStage, tid)
  basefunc(unit, nStage, tid)
  local stageTemp = 0
  if TitanPR.Fashion_ID and TitanPR.Fashion_ID == unit.fashion_id then
    stageTemp = 5
  end
  if unit.currentActionStage == 1 + stageTemp and not unit.TitanPR_firstEnter then
    local skillenter = unit.skills.TitanPR_enter
    local skillatk = unit.skills.TitanPR_atk
    skillatk.cd_remaining = 0.5
    skillenter.cd_remaining = 999
  end
end

function TitanPR.hero_update(basefunc, unit, dt)
  basefunc(unit, dt)
  unit.TitanPR_feather_count = unit.TitanPR_feather_count + 1
  if unit.TitanPR_feather_count >= 16 then
    local skillatk2 = unit.skills.TitanPR_atk2
    local unit_count = 0
    local unit_timer = 0
    for Cunit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      if Cunit ~= unit then
        unit_count = unit_count + 1
      end
    end
    local buff_unit_count = math.floor(unit_count * ed.rand()) + 1
    unit.TitanPR_feather_count = 0
    for BuffUnit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      if BuffUnit ~= unit then
        unit_timer = unit_timer + 1
        if unit_timer == buff_unit_count then
          local buffunitjudge = false
          for i, solbuff in ipairs(BuffUnit.buff_list) do
            if solbuff.caster == unit and (solbuff.info.ID == TitanPR.skillenter_buff_featherSOLenemy_ID or solbuff.info.ID == TitanPR.skillenter_buff_featherSOL_ID) then
              buffunitjudge = true
            end
          end
          if buffunitjudge == true then
            if buff_unit_count == unit_count then
              buff_unit_count = 1
            else
              buff_unit_count = buff_unit_count + 1
            end
          else
            local buff
            if BuffUnit.camp == unit.camp then
              local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillenter_buff_featherSOL_ID)
              local changeZ = false
              for i, solbuff in ipairs(BuffUnit.buff_list) do
                if solbuff.info.ID == TitanPR.skillenter_buff_featherSOLenemy_ID then
                  changeZ = true
                end
              end
              if changeZ == true then
                binfo.info = ed.wraptable(binfo.info, {
                  ["Effect Zorder"] = 10
                })
              end
              buff = ed.BuffCreate(binfo, BuffUnit, unit)
              buff.update = override(buff.update, TitanPR.SOLbuff_update)
              buff:setAttribute("AD", math.max(buff.owner.attribs.AD * 0.8, buff.owner.attribs.AD * skillatk2.info["Script Arg3"] * 0.15 * unit.stars))
              if TitanPR.Fashion_ID and TitanPR.Fashion_ID == unit.fashion_id then
                buff:setAttribute("MPR", 30)
              end
            else
              local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillenter_buff_featherSOLenemy_ID)
              local changeZ = false
              for i, solbuff in ipairs(BuffUnit.buff_list) do
                if solbuff.info.ID == TitanPR.skillenter_buff_featherSOL_ID then
                  changeZ = true
                end
              end
              if changeZ == true then
                binfo.info = ed.wraptable(binfo.info, {
                  ["Effect Zorder"] = 10
                })
              end
              buff = ed.BuffCreate(binfo, BuffUnit, unit)
              buff.update = override(buff.update, TitanPR.SOLbuff_update)
              buff:setAttribute("AD", math.max(-buff.owner.attribs.AD * 0.8, buff.owner.attribs.AD * skillatk2.info["Script Arg4"] * 0.15 * unit.stars))
            end
            if buff and TitanPR.Fashion_ID and TitanPR.Fashion_ID == unit.fashion_id then
              buff.info = ed.wraptable(buff.info, {
                Effect = "eff_buff_TitanPR_atk2_skin.cha"
              })
            end
            BuffUnit:addBuff(buff, unit)
            unit.fall_damage_count = unit.fall_damage_count + 1
          end
        end
      end
    end
  end
end

function TitanPR.SOLbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  if not caster:isAlive() then
    buff.timer = 0
  end
end

function TitanPR.hero_reset(basefunc, hero)
  basefunc(hero)
  if TitanPR.Fashion_ID and TitanPR.Fashion_ID == hero.fashion_id then
    hero:enterActionStageFromOneStage(6, TitanPR.heroID)
  else
    hero:enterActionStageFromOneStage(1, TitanPR.heroID)
  end
  hero.fall_damage_count = 0
  hero.flying_statue = "ground_longD"
  hero.skillult_pos_count = 0
  hero.origin_posX = 0
  hero.origin_posZ = 0
  hero.origin_dir = 1
  hero.TitanPR_firstEnter = true
  hero.TitanPR_atk3_attacked = false
  hero.TitanPR_canCastult = nil
  hero.TitanPR_atk3_no_ult = nil
  hero.TitanPR_feather_count = 0
  hero:setActionStageChangeByManual(true)
  local skillenter = hero.skills.TitanPR_enter
  if skillenter then
    skillenter.cd_remaining = 1.5
    local bid = TitanPR.skillenter_buff_invis_ID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
  local skillult = hero.skills.TitanPR_ult
  if skillult then
    skillult.cd_remaining = 0
    skillult:resume()
  end
end

function TitanPR.skillatk3_onAttackFrame(basefunc, skill)
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
  if skill.attack_counter == 1 then
    if MPGR == nil or MPGR == 1 then
      caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    else
      caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
    end
  end
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function TitanPR.skillatk3_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  if idx == 1 then
    if caster.actionStageId == 1 then
      skill.phase_list[idx].action_name = "atk3"
    elseif caster.actionStageId == 4 or caster.actionStageId == 5 then
      skill.phase_list[idx].action_name = "atk3_dc1"
    end
  end
  if idx == 9 then
    caster.TitanPR_atk3_attacked = false
    if caster.actionStageId == 1 then
      skill.phase_list[idx].action_name = "atk3b"
    elseif caster.actionStageId == 4 or caster.actionStageId == 5 then
      skill.phase_list[idx].action_name = "atk3_dc3"
    end
  end
  basefunc(skill, idx)
end

function TitanPR.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  caster.TitanPR_atk3_no_ult = true
  caster.TitanPR_skillatk3_oriposX = math.min(math.max(caster.position[1], 40), 760)
  caster.TitanPR_skillatk3_oriDIR = caster.direction
  local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillatk3_buff_begin_ID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onRemoved = override(buff.onRemoved, TitanPR.skillatk3buff_onRemoved)
  buff.onDamaged = override(buff.onDamaged, TitanPR.skillatk3buff_onDamaged)
  caster:addBuff(buff, caster)
  basefunc(skill, target)
end

function TitanPR.skillatk3_finish(basefunc, skill, reason)
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 9 then
    skill.caster.TitanPR_atk3_no_ult = nil
    for i, buff in ipairs(skill.caster.buff_list) do
      if buff.info.ID == TitanPR.skillatk3_buff_inv_ID then
        buff.timer = 0
      end
    end
  end
  basefunc(skill, reason)
end

function TitanPR.skillatk3buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  local skillatk3 = hero.skills.TitanPR_atk3
  local skillatk3sub = hero.skills.TitanPR_atk3a
  hero.manual_moving = true
  hero.walk_v = {
    500 * hero.direction,
    0
  }
  if skillatk3 then
    skillatk3:startPhase(2)
  end
  hero.TitanPR_skillatk3_oriDIR = hero.direction
  local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillatk3_buff_inv_ID)
  local invbuff = ed.BuffCreate(binfo, hero, hero)
  invbuff.update = override(invbuff.update, TitanPR.skillatk3_buff_update)
  hero:addBuff(invbuff, hero)
  local target = skillatk3sub:selectTarget()
  if target then
    skillatk3sub:createTrackType("projectile")
  else
    skillatk3:interrupt()
  end
end

function TitanPR.skillatk3_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 and caster.TitanPR_atk3_attacked == false then
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == TitanPR.skillatk3_buff_begin_ID then
        buff.timer = 0
      end
    end
    caster.TitanPR_atk3_no_ult = nil
    skill:finish()
    return
  end
  basefunc(skill)
end

function TitanPR.skillatk3sub_power(basefunc, skill, source, target, damage_type)
  local power, crit = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if caster.TitanPR_atk3_attacked == false and (not caster.TitanPR_hasArcana or not (caster.TitanPR_hasArcana > 1)) then
    power = power * 0.5
  else
  end
  return power, crit
end

function TitanPR.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local MPGR = caster.attribs.MPGainRatio
  if MPGR == nil or MPGR == 1 then
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
  else
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
end

function TitanPR.skillatk3buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if skill and 0 < damage then
    local caster = buff.owner
    if not caster.TitanPR_skillatk3_oriposX then
      caster.TitanPR_skillatk3_oriposX = math.min(math.max(caster.position[1], 40), 760)
    end
    local skillatk3sub = caster.skills.TitanPR_atk3a
    damage = 0
    if ed.run_with_scene then
      local color = caster.camp == ed.emCampEnemy and "red" or "blue"
      ed.PopupCreate("immune", color, caster.actor, nil, "text")
    end
    buff.timer = 0
    caster.TitanPR_atk3_attacked = true
  end
  return damage
end

function TitanPR.skillatk3_buff_update(basefunc, buff, dt)
  local hero = buff.owner
  local skillatk3 = hero.skills.TitanPR_atk3
  local dir = 0
  if hero.TitanPR_skillatk3_oriDIR then
    dir = hero.TitanPR_skillatk3_oriDIR
  else
    dir = hero.direction
  end
  if math.abs(hero.position[1] - 400) > 420 then
    hero.position[1] = 400 - 398 * dir
    hero.TitanPR_wait = 0.25
    hero.manual_moving = true
    hero.walk_v = {0, 0}
    local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillatk3_buff_building_ID)
    local Bbuff = hero:addBuff(binfo, hero)
  end
  if hero.TitanPR_wait and 0 < hero.TitanPR_wait then
    hero.TitanPR_wait = hero.TitanPR_wait - dt
  elseif hero.TitanPR_wait and 0 >= hero.TitanPR_wait then
    hero.TitanPR_wait = nil
    if skillatk3 then
      hero.position[1] = 400 - 420 * dir
      hero.manual_moving = true
      hero.walk_v = {
        400 * dir,
        0
      }
      skillatk3:startPhase(2)
    end
    hero.TitanPR_return = true
  end
  if not hero.TitanPR_skillatk3_oriposX then
    hero.TitanPR_skillatk3_oriposX = 400 - 360 * hero.direction
  end
  if hero.TitanPR_return == true and 0 <= (hero.position[1] - hero.TitanPR_skillatk3_oriposX) * dir then
    hero.position[1] = hero.TitanPR_skillatk3_oriposX
    hero.TitanPR_skillatk3_oriposX = nil
    hero.TitanPR_skillatk3_oriDIR = nil
    hero.walk_v = {0, 0}
    skillatk3:startPhase(9)
    buff.timer = 0
    hero.manual_moving = nil
    hero.TitanPR_return = nil
  end
  basefunc(buff, dt)
end

function TitanPR.skillatk3sub_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.can_be_influenced = false
  return projectile
end

function TitanPR.skillult_willCast(basefunc, skill)
  local out = basefunc(skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  if caster.flying_statue == "ground_longD" and caster.mp < 800 then
    out = false
  elseif caster.flying_statue == "upper" then
    out = false
  elseif caster.flying_statue == "ground_melee" and caster.hp > caster.attribs.HP * 0.5 then
    out = false
  end
  return out
end

function TitanPR.skillult_canCastWithTarget(basefunc, skill, target)
  local out, reason = basefunc(skill, target)
  if skill.caster.flying_statue == "ground_longD" and skill.caster.mp < 500 then
    return false, "mp"
  end
  if skill.caster.TitanPR_canCastult == true then
    return false, "mp"
  end
  if skill.caster.TitanPR_atk3_no_ult and skill.caster.TitanPR_atk3_no_ult == true then
    return false, "mp"
  end
  return out, reason
end

function TitanPR.skillult_start(basefunc, skill, target)
  local info = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  if skill.caster.taunter and skill.info["Target Type"] ~= "self" then
    if target then
      if target.camp ~= skill:targetCamp() then
        skill:selectTarget(target)
      else
      end
    else
      skill:selectTarget(target)
    end
  else
    skill:selectTarget(target)
  end
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local caster = skill.caster
  local skillultd = caster.skills.TitanPR_ultd
  local skillultb = caster.skills.TitanPR_ultb
  local mp_lost = info["Cost MP"]
  if caster.flying_statue == "ground_longD" then
    caster.origin_posX = caster.position[1]
    caster.origin_posZ = caster.position[2]
    caster.origin_dir = caster.direction
    mp_lost = 500
    skill:startPhase(1)
  elseif caster.flying_statue == "upper" then
    caster.TitanPR_not_cast_twice = true
    skill:startPhase(2)
  elseif caster.flying_statue == "ground_melee" then
    skill:startPhase(3)
  end
  local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillenter_buff_invulnerable_ID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  skill.is_update = true
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - mp_lost * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function TitanPR.skillult_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  if idx == 2 then
    caster.TitanPR_canCastult = true
  elseif idx == 3 then
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == TitanPR.skillult_buff_DCHast_ID then
        buff.timer = 0
      end
    end
    caster.TitanPR_canCastult = true
  end
  basefunc(skill, idx)
end

function TitanPR.skillult_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  local skillatk4 = caster.skills.TitanPR_atk4
  local skillatk3 = caster.skills.TitanPR_atk3
  local skillultb = caster.skills.TitanPR_ultb
  if skillatk3 then
    skillatk3:pause()
  end
  if caster.flying_statue == "ground_longD" then
    if current_phase_idx == 1 then
      if skillatk4 then
        if TitanPR.Fashion_ID and TitanPR.Fashion_ID == caster.fashion_id then
          caster:enterActionStageFromOneStage(8, TitanPR.heroID)
        else
          caster:enterActionStageFromOneStage(3, TitanPR.heroID)
        end
      elseif TitanPR.Fashion_ID and TitanPR.Fashion_ID == caster.fashion_id then
        caster:enterActionStageFromOneStage(7, TitanPR.heroID)
      else
        caster:enterActionStageFromOneStage(2, TitanPR.heroID)
      end
      caster.flying_statue = "upper"
      for i, buff in ipairs(caster.buff_list) do
        if buff.info.ID == TitanPR.skillenter_buff_invulnerable_ID then
          buff.timer = 0
        end
      end
      local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillult_buff_MPR_ID)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.update = override(buff.update, TitanPR.skillultd_buff_update)
      buff.onDamaged = override(buff.onDamaged, TitanPR.skillultd_buff_onDamaged)
      buff.onRemoved = override(buff.onRemoved, TitanPR.skillultd_buff_onRemoved)
      caster:addBuff(buff, caster)
      skill:finish()
      return
    else
      skill:finish()
      return
    end
  else
    skill:finish()
    return
  end
  basefunc(skill)
end

function TitanPR.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 665 then
      tbuff.timer = -1
    end
  end
  local current_phase_idx = skill.current_phase_idx
  local caster = skill.caster
  local skillultb = caster.skills.TitanPR_ultb
  if current_phase_idx == 2 and caster.flying_statue == "upper" then
    local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillult_buff_wait_ID)
    local Wbuff = ed.BuffCreate(binfo, caster, caster)
    Wbuff.temp = 1
    Wbuff.onRemoved = override(Wbuff.onRemoved, TitanPR.skillult_buff_wait_onRemoved)
    caster:addBuff(Wbuff, caster)
  elseif current_phase_idx == 3 and caster.flying_statue == "ground_melee" then
    local target = skillultb:selectTarget()
    caster:castSkill(skillultb, target)
  end
  if caster.TitanPR_hasArcana and 3 < caster.TitanPR_hasArcana then
    local bid = 1708
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
end

function TitanPR.skillult_buff_wait_onRemoved(basefunc, buff)
  local caster = buff.owner
  local skillulta = caster.skills.TitanPR_ulta
  local target = skillulta:selectTarget()
  if not target then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit:isAlive() then
        target = unit
        break
      end
    end
  end
  if not target then
    caster.position[1] = math.min(math.max(caster.origin_posX - caster.origin_dir * 80, 0), 800)
    skillulta:finish()
  else
    local pos_temp = target.position[1]
    caster.position[1] = math.min(math.max(pos_temp - caster.direction * 80, 0), 800)
  end
  caster:castSkill(skillulta, target)
  basefunc(buff)
end

function TitanPR.skillatk_fly_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local skillatk4 = skill.caster.skills.TitanPR_atk4
  if skillatk4 then
    power = power * (1 + skillatk4.info["Script Arg4"])
  end
  return power
end

function TitanPR.skillultd_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if skill and skill.info["Max Range"] < 200 then
    damage = 0
  end
  return damage
end

function TitanPR.skillultd_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.flying_statue == "upper" and buff.owner.mp <= 1 then
    buff.timer = 0
  end
end

function TitanPR.skillultd_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.owner
  local skillult = caster.skills.TitanPR_ult
  if buff.TitanPR_ultRM and buff.TitanPR_ultRM == true then
    return
  end
  if caster.TitanPR_not_cast_twice and caster.TitanPR_not_cast_twice == true then
    caster.TitanPR_not_cast_twice = nil
    return
  else
    caster.TitanPR_not_cast_twice = nil
    caster:castSkill(skillult, caster)
  end
end

function TitanPR.skillulta_start(basefunc, skill, target)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanPR.skillult_buff_MPR_ID then
      buff.timer = 0
      buff.TitanPR_ultRM = true
    end
  end
  caster.flying_statue = "ground_melee"
  if target then
    local pos_temp = target.position[1]
    caster.position[1] = math.min(math.max(pos_temp - caster.direction * 80, 0), 800)
  end
  basefunc(skill, target)
end

function TitanPR.skillulta_takeEffectAt(basefunc, skill, location, source)
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    for i, buff in ipairs(unit.buff_list) do
      if buff.caster == skill.caster and (buff.info.ID == TitanPR.skillenter_buff_featherSOL_ID or buff.info.ID == TitanPR.skillenter_buff_featherSOLenemy_ID) then
        buff.timer = 0
      end
    end
  end
  basefunc(skill, location, source)
end

function TitanPR.skillulta_finish(basefunc, skill, reason)
  local caster = skill.caster
  caster.TitanPR_canCastult = nil
  caster.flying_statue = "ground_melee"
  caster.fall_damage_count = 0
  local skillatk4 = caster.skills.TitanPR_atk4
  local skillult = caster.skills.TitanPR_ult
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanPR.skillenter_buff_invulnerable_ID then
      buff.timer = 0
    end
  end
  if skillatk4 then
    if TitanPR.Fashion_ID and TitanPR.Fashion_ID == caster.fashion_id then
      caster:enterActionStageFromOneStage(10, TitanPR.heroID)
    else
      caster:enterActionStageFromOneStage(5, TitanPR.heroID)
    end
    local binfo = ed.lookupDataTable("Buff", nil, TitanPR.skillult_buff_DCHast_ID)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  elseif TitanPR.Fashion_ID and TitanPR.Fashion_ID == caster.fashion_id then
    caster:enterActionStageFromOneStage(9, TitanPR.heroID)
  else
    caster:enterActionStageFromOneStage(4, TitanPR.heroID)
  end
  local skillatk3 = caster.skills.TitanPR_atk3
  if skillatk3 then
    skillatk3:resume()
  end
  basefunc(skill, reason)
end

function TitanPR.skillulta_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  power = power * TitanPR.ULT_percent
  return power * (1 + skill.caster.fall_damage_count)
end

function TitanPR.skillultb_finish(basefunc, skill, reason)
  local caster = skill.caster
  for i, buff in ipairs(caster.buff_list) do
    if buff.info.ID == TitanPR.skillenter_buff_invulnerable_ID then
      buff.timer = 0
    end
  end
  caster.flying_statue = "ground_longD"
  caster.TitanPR_canCastult = nil
  if TitanPR.Fashion_ID and TitanPR.Fashion_ID == caster.fashion_id then
    caster:enterActionStageFromOneStage(6, TitanPR.heroID)
  else
    caster:enterActionStageFromOneStage(1, TitanPR.heroID)
  end
  local skillatk3 = caster.skills.TitanPR_atk3
  if skillatk3 then
    skillatk3:resume()
  end
  basefunc(skill, reason)
end

function TitanPR.skillultb_startPhase(basefunc, skill, idx)
  local caster = skill.caster
  if idx == 2 then
    caster.position[1] = math.max(math.min(caster.origin_posX - caster.origin_dir * 120, 800), 0)
    caster.position[2] = caster.origin_posZ
    caster.direction = caster.origin_dir
  end
  basefunc(skill, idx)
end

function TitanPR.skillatk_close_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local skillatk4 = skill.caster.skills.TitanPR_atk4
  if skillatk4 then
    power = power * (1 + skillatk4.info["Script Arg4"])
  end
  power = power * TitanPR.ULT_percent
  return power
end

function TitanPR.skillatk_close_start(basefunc, skill, target)
  basefunc(skill, target)
  local skillatk4 = skill.caster.skills.TitanPR_atk4
  skill.cd_remaining = math.max(skill.cd_remaining * (1 - skillatk4.info["Script Arg3"]), 1.5)
end

function TitanPR.skills_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = skill.target
  projectile.zSpeed = (target.position[2] - 50 - projectile.position[2]) / (math.abs(target.position[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
  return projectile
end

function TitanPR.init_hero(hero)
  local skillult = hero.skills.TitanPR_ult
  local skillatk = hero.skills.TitanPR_atk
  local skillatk2 = hero.skills.TitanPR_atk2
  local skillatk3 = hero.skills.TitanPR_atk3
  local skillatk4 = hero.skills.TitanPR_atk4
  local skillatk3sub = hero.skills.TitanPR_atk3a
  local skillulta = hero.skills.TitanPR_ulta
  local skillultb = hero.skills.TitanPR_ultb
  local skillatk_fly = hero.skills.TitanPR_atk4b
  local skillatk_close = hero.skills.TitanPR_atk4a
  local skillatk_fly_normal = hero.skills.TitanPR_atk_u
  hero.fall_damage_count = 0
  hero.flying_statue = "ground_longD"
  hero.skillult_pos_count = 0
  hero.origin_posX = 0
  hero.origin_posZ = 0
  hero.origin_dir = 1
  hero.reset = override(hero.reset, TitanPR.hero_reset)
  hero.enterActionStageFromOneStage = override(hero.enterActionStageFromOneStage, TitanPR.hero_enterActionStageFromOneStage)
  hero.TitanPR_firstEnter = true
  hero.TitanPR_atk3_attacked = false
  hero.TitanPR_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, TitanPR.skills_createProjectile)
  end
  if skillatk_fly_normal then
    skillatk_fly_normal.createProjectile = override(skillatk_fly_normal.createProjectile, TitanPR.skills_createProjectile)
  end
  local skillenter = hero.skills.TitanPR_enter
  if skillenter then
    skillenter.start = override(skillenter.start, TitanPR.skillenter_start)
    skillenter.finish = override(skillenter.finish, TitanPR.skillenter_finish)
  end
  if skillatk2 then
    hero.TitanPR_feather_count = 0
    hero.update = override(hero.update, TitanPR.hero_update)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanPR.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanPR.skillatk3_onAttackFrame)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, TitanPR.skillatk3_onPhaseFinished)
    skillatk3.start = override(skillatk3.start, TitanPR.skillatk3_start)
    skillatk3.startPhase = override(skillatk3.startPhase, TitanPR.skillatk3_startPhase)
    skillatk3sub.createProjectile = override(skillatk3sub.createProjectile, TitanPR.skillatk3sub_createProjectile)
    skillatk3sub.power = override(skillatk3sub.power, TitanPR.skillatk3sub_power)
    skillatk3.finish = override(skillatk3.finish, TitanPR.skillatk3_finish)
  end
  if skillult then
    skillult.willCast = override(skillult.willCast, TitanPR.skillult_willCast)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanPR.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, TitanPR.skillult_start)
    skillult.startPhase = override(skillult.startPhase, TitanPR.skillult_startPhase)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, TitanPR.skillult_onPhaseFinished)
    skillult.finish = override(skillult.finish, TitanPR.skillult_finish)
  end
  if skillatk_fly then
    skillatk_fly.createProjectile = override(skillatk_fly.createProjectile, TitanPR.skills_createProjectile)
    skillatk_fly.power = override(skillatk_fly.power, TitanPR.skillatk_fly_power)
  end
  if skillulta then
    skillulta.start = override(skillulta.start, TitanPR.skillulta_start)
    skillulta.finish = override(skillulta.finish, TitanPR.skillulta_finish)
    skillulta.power = override(skillulta.power, TitanPR.skillulta_power)
    skillulta.takeEffectAt = override(skillulta.takeEffectAt, TitanPR.skillulta_takeEffectAt)
  end
  if skillultb then
    skillultb.finish = override(skillultb.finish, TitanPR.skillultb_finish)
    skillultb.startPhase = override(skillultb.startPhase, TitanPR.skillultb_startPhase)
  end
  if skillatk_close then
    skillatk_close.start = override(skillatk_close.start, TitanPR.skillatk_close_start)
    skillatk_close.power = override(skillatk_close.power, TitanPR.skillatk_close_power)
  end
  if TitanPR.Fashion_ID and TitanPR.Fashion_ID == hero.fashion_id then
    if skillatk then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Impact Effect"] = "eff_impact_TitanPR_atk_skin.cha",
        ["Tile Art"] = "eff_tile_TitanPR_atk_skin.cha"
      })
    end
    if skillatk_fly_normal then
      skillatk_fly_normal.info = ed.wraptable(skillatk_fly_normal.info, {
        ["Tile Art"] = "eff_tile_TitanPR_atk_u_skin.cha"
      })
    end
    if skillatk_fly then
      skillatk_fly.info = ed.wraptable(skillatk_fly.info, {
        ["Impact Effect"] = "eff_impact_TitanPR_atk4_u_skin.cha",
        ["Tile Art"] = "eff_tile_TitanPR_atk4_u_skin.cha"
      })
    end
  end
  hero:setActionStageChangeByManual(true)
  return hero
end

return TitanPR.init_hero
