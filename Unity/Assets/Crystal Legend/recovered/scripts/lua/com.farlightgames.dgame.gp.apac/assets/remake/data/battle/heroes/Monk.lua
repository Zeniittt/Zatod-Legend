module("ed.battlehero", package.seeall)
local ed = ed
Monk = {}
Monk.atk4_time = 4
Monk.qigong_potecttime = 2
Monk.qigonglevel_max = 5
Monk.qigonglevel_super = 3
Monk.atk_useqigong = 3
Monk.ult_useqigong = 5
Monk.atk3_knock_v1 = 1000
Monk.atk3_knock_v2 = 200
Monk.atk3_knock_v3 = 200
Monk.atk3_knock_lastdistance = 0
Monk.atk3_knock_backdistance = 50
Monk.atk4_PIMU_MIMU_base = 3
Monk.border = 120
Monk.atk4_ATK_base = 3

function Monk.qigong_levelchange(hero, beforelv, nowlv)
  if nowlv < beforelv then
    for k = beforelv, nowlv + 1, -1 do
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 11002800 + k then
          tbuff.timer = 0
        end
      end
    end
    hero.qigong_level = nowlv
  end
end

function Monk.remove_qigong(hero, afterlevel, nowlevel)
  if afterlevel < nowlevel then
    for k = nowlevel, afterlevel, -1 do
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 11002800 + k then
          tbuff.timer = 0
        end
      end
    end
  end
end

function Monk.hero_update(basefunc, hero, dt)
  hero.previous_position = hero.position
  hero.qigong_potecttime = hero.qigong_potecttime - dt
  basefunc(hero, dt)
  local skillatk4 = hero.skills.Monk_atk4
  local shift = ed.edpDistanceSQ(hero.position, hero.previous_position)
  local atk4time = Monk.atk4_time
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      atk4time = skillatk4.evo_rank2["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      atk4time = skillatk4.evo_rank3["Script Arg1"]
    end
    hero.Monk_nomove_count = hero.Monk_nomove_count + dt
    if atk4time <= hero.Monk_nomove_count and hero.qigong_level < Monk.qigonglevel_max then
      local skilllevel = hero.skills.Monk_atk4.level
      local bid = 11002800 + hero.qigong_level + 1
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      local adbase = skillatk4.info["Script Arg2"]
      if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
        adbase = adbase + skillatk4.evo_rank1["Script Arg1"]
      end
      buff:setAttribute("AD", adbase)
      local buffresult = hero:addBuff(buff, hero)
      if buffresult then
        hero.qigong_level = hero.qigong_level + 1
        hero.Monk_nomove_count = 0
      end
    end
    hero.previous_position = hero.position
  end
end

function Monk.castManualSkill(basefunc, hero)
  if hero.SD_ultStackBuff and hero.SD_ultStackBuff.timer > 0 then
    hero.readyToUlt = true
    return
  end
  if not hero:isAlive() then
    return
  end
  if not hero.manual_skill then
    return
  end
  if ed.engine:arenaMode() and hero.skills.Monk_atk4 and hero.qigong_level < Monk.qigonglevel_super then
    hero.manual_skill.cd_remaining = 1
    return
  end
  if hero.manual_skill:canTrigger() then
    hero.manual_skill:trigger()
    return
  end
  if not hero.manual_skill:canCastWithTarget(hero.ai.target) then
    return
  end
  if hero.current_skill then
    hero.current_skill:interrupt()
  end
  hero:castSkill(hero.manual_skill, hero.ai.target)
  hero.manually_casting = true
  ed.engine:freeze(hero.camp)
  hero:unfreeze()
  hero.can_cast_tick = -1
  local target = hero.skills.Monk_ult.target
  if hero.qigong_level >= 3 and ed.run_with_scene then
    ed.scene.background:setColor(ccc3(5, 5, 5))
  end
  if target then
    target:unfreezeActor()
  end
  if not target then
    return
  end
end

function Monk.skillult_selectTarget(basefunc, self, default)
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
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit.position[1] > 800 or unit.position[1] < 0 then
      elseif enchanted and unit == caster then
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

function Monk.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  skill.ult_originfo = skill.info
  basefunc(skill, target)
  local qigonglevel = caster.qigong_level
  caster.origin_position = {
    caster.position[1],
    caster.position[2]
  }
  if skill.evo_rank and 2 <= skill.evo_rank then
    local bid = 11002811
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
  local basicnum = skill.ult_originfo["Basic Num"]
  if qigonglevel < Monk.qigonglevel_super then
    skill.Monk_ult_super = nil
    skill.info = ed.wraptable(skill.ult_originfo, {
      ["Plus Ratio"] = 0.3 + qigonglevel * 0.1
    })
    if skill.evo_rank and 1 <= skill.evo_rank then
      skill.info = ed.wraptable(skill.ult_originfo, {
        ["Plus Ratio"] = 0.3 + qigonglevel * 0.1,
        ["Basic Num"] = basicnum + skill.evo_rank1["Script Arg1"]
      })
    end
    skill:startPhase(1)
  else
    skill.Monk_ult_super = true
    skill.info = ed.wraptable(skill.ult_originfo, {
      ["Plus Ratio"] = 2 + qigonglevel * 0.4,
      ["No Dodge"] = true,
      ["Basic Num"] = skill.ult_originfo["Script Arg2"]
    })
    skill:startPhase(2)
  end
end

function Monk.onAttackFrame_basefunc1(basefunc, skill)
  if skill.caster.manually_casting and skill.attack_counter == 2 then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 0 then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  skill:takeEffectAt(skill.target.position)
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Monk.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster:getInitDir()
  local skillults = caster.skills.Monk_ults
  local target = skill.target
  local originfo = skill.info
  if skill.Monk_ult_super then
    if attack_counter == 0 then
      if target then
        if target.position[1] >= caster.position[1] then
          dir = 1
          caster.direction = 1
        else
          dir = -1
          caster.direction = -1
        end
        caster:setPosition({
          target.position[1] - dir * 75,
          target.position[2]
        })
        if skill.evo_rank and skill.evo_rank >= 3 then
          local bid = 11002815
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = target:addBuff(binfo, caster)
        end
      else
        skill:finish()
      end
      caster.MonkUlttarget = skill.target
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 and caster.MonkUlttarget == skill.target then
      basefunc(skill)
      if skill.target then
        skillults:takeEffectAt(skill.target.position)
        if ed.run_with_scene then
          ed.scene:startCameraShakeAnimationX(45, 0.2, 3)
        end
      end
    elseif attack_counter == 2 then
      caster:setPosition({
        caster.origin_position[1],
        caster.origin_position[2]
      })
    end
  elseif attack_counter == 0 then
    if target then
      if target.position[1] >= caster.position[1] then
        dir = 1
        caster.direction = 1
      else
        dir = -1
        caster.direction = -1
      end
      caster:setPosition({
        target.position[1] - dir * 50,
        target.position[2]
      })
    else
      skill:finish()
    end
    caster.MonkUlttarget = skill.target
    skill.attack_counter = skill.attack_counter + 1
  elseif 0 < attack_counter and attack_counter < 11 and caster.MonkUlttarget == skill.target then
    Monk.onAttackFrame_basefunc1(basefunc, skill)
  elseif attack_counter == 11 and caster.MonkUlttarget == skill.target then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.8,
      ["Knock Back"] = 5,
      ["No Dodge"] = true
    })
    Monk.onAttackFrame_basefunc1(basefunc, skill)
    skill.info = originfo
  elseif attack_counter == 12 then
    caster:setPosition({
      caster.origin_position[1],
      caster.origin_position[2]
    })
  end
end

function Monk.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 11002811 then
      tbuff.timer = 0
    end
  end
  if skill.Monk_ult_super then
    Monk.qigong_levelchange(unit, unit.qigong_level, 0)
  end
  skill.info = skill.ult_originfo
end

function Monk.skillult_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Monk.skillults_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if caster.MonkUlttarget ~= target then
    basefunc(skill, target, source)
  end
end

function Monk.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local qigonglevel = caster.qigong_level
  caster.origin_position = {
    caster.position[1],
    caster.position[2]
  }
  if qigonglevel < Monk.qigonglevel_super then
    skill.Monk_atk2_super = nil
    skill:startPhase(1)
  else
    skill.Monk_atk2_super = true
    skill:startPhase(2)
  end
end

function Monk.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster:getInitDir()
  local originfo = skill.info
  local skillatk2s = caster.skills.Monk_atk2s
  if skill.Monk_atk2_super then
    if attack_counter <= 1 then
      basefunc(skill)
    elseif attack_counter == 2 then
      skillatk2s:takeEffectAt(caster.position)
    end
  else
    basefunc(skill)
  end
end

function Monk.skillatk2_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Monk.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.Monk_atk2_super then
    Monk.qigong_levelchange(caster, caster.qigong_level, caster.qigong_level - 1)
  end
end

function Monk.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local qigonglevel = caster.qigong_level
  skill.atk3_originfo = skill.info
  if qigonglevel < Monk.qigonglevel_super then
    skill.Monk_atk3_super = nil
    skill:startPhase(1)
  else
    skill.Monk_atk3_super = true
    skill:startPhase(2)
  end
end

function Monk.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster:getInitDir()
  local originfo = skill.info
  if skill.Monk_atk3_super then
    if attack_counter == 0 then
      skill.info = ed.wraptable(skill.atk3_originfo, {
        ["Buff ID"] = 0
      })
      basefunc(skill)
      skill.info = originfo
    elseif attack_counter == 1 then
      if skill.evo_rank and 1 <= skill.evo_rank then
        skill.info = ed.wraptable(skill.atk3_originfo, {
          ["Plus Ratio"] = skill.evo_rank1["Script Arg2"]
        })
      end
      if skill.evo_rank and skill.evo_rank >= 2 then
        skill.info = ed.wraptable(skill.atk3_originfo, {
          ["Plus Ratio"] = skill.evo_rank2["Script Arg2"]
        })
      end
      if skill.evo_rank and skill.evo_rank >= 3 then
        skill.info = ed.wraptable(skill.atk3_originfo, {
          ["No Dodge"] = true,
          ["Plus Ratio"] = skill.evo_rank3["Script Arg2"]
        })
      end
      basefunc(skill)
      skill.info = originfo
    end
  else
    skill.info = ed.wraptable(skill.atk3_originfo, {
      ["Buff ID"] = 0,
      ["Knock Up"] = 0.1,
      ["Knock Back"] = 20
    })
    basefunc(skill)
    skill.info = originfo
  end
end

function Monk.skillatk3_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk3s = caster.skills.Monk_atk3s
  if buff.knock_dir == 1 then
    if owner.position[1] < buff.target_border then
      owner.knockup_v = {
        Monk.atk3_knock_v1 * buff.knock_dir,
        0
      }
    else
      if ed.run_with_scene and not buff.shakemark then
        ed.scene:startCameraShakeAnimationX(15, 0.1, 1)
      end
      owner.knockup_v = {0, 0}
      if not buff.shakemark then
        skillatk3s:takeEffectAt(owner.position)
      end
      buff.shakemark = true
    end
  elseif owner.position[1] > buff.target_border then
    owner.knockup_v = {
      Monk.atk3_knock_v1 * buff.knock_dir,
      0
    }
  else
    if ed.run_with_scene and not buff.shakemark then
      ed.scene:startCameraShakeAnimationX(15, 0.1, 1)
    end
    owner.knockup_v = {0, 0}
    if not buff.shakemark then
      skillatk3s:takeEffectAt(owner.position)
    end
    buff.shakemark = true
  end
end

function Monk.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.shakemark = nil
  buff.knock_dir = 1
  buff.target_border = ed.engine.stage_rect.maxX - Monk.border
  if caster.position[1] > target.position[1] then
    buff.knock_dir = -1
    buff.target_border = ed.engine.stage_rect.minX + Monk.border
  end
  buff.update = override(buff.update, Monk.skillatk3_buffUpdate)
  return buff
end

function Monk.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  skill.info = skill.atk3_originfo
  local caster = skill.caster
  if skill.Monk_atk3_super then
    Monk.qigong_levelchange(caster, caster.qigong_level, caster.qigong_level - 1)
  end
end

function Monk.skillatk3_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Monk.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11002813 then
      tbuff.timer = 0
    end
  end
  local bid = 11002812
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Monk.skillenter_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11002812 then
      tbuff.timer = 0
    end
  end
end

function Monk.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  if caster.atk_count % 2 == 0 then
    skill:startPhase(1)
    caster.atk_count = caster.atk_count + 1
  else
    skill:startPhase(2)
    caster.atk_count = caster.atk_count + 1
  end
end

function Monk.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Monk.getRuntimeScale(basefunc, self)
  if self.isScaleActionRunning then
    local dt = self.dt_action
    self.scaleActionRunningTime = self.scaleActionRunningTime + dt
    if self.scaleActionRunningTime > self.scaleActionDuration then
      local scale = self.scaleActionScaleValue
      return self.direction * scale, scale
    else
      local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
      return self.direction * scale, scale
    end
  end
  if not self.isScaleActionRunning then
    local m = self.manually_casting
    return self.direction * (m and 1.1 or 1), m and 1.1 or 1
  end
end

function Monk.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.qigong_potecttime = Monk.qigong_potecttime
  hero.qigong_movenotatk = nil
  hero.Monk_nomove_count = 0
  hero.previous_position = hero.position
  hero.qigong_level = 0
  hero.nextatk_bufflevel = 0
  hero.atk_count = 0
  local skillenter = hero.skills.Monk_enter
  if skillenter then
    local bid = 11002813
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
end

function Monk.init_hero(hero)
  local skillult = hero.skills.Monk_ult
  local skillults = hero.skills.Monk_ults
  local skillatk = hero.skills.Monk_atk
  local skillatk2 = hero.skills.Monk_atk2
  local skillatk2s = hero.skills.Monk_atk2s
  local skillatk3 = hero.skills.Monk_atk3
  local skillatk3s = hero.skills.Monk_atk3s
  local skillatk4 = hero.skills.Monk_atk4
  local skillenter = hero.skills.Monk_enter
  hero.qigong_potecttime = Monk.qigong_potecttime
  hero.Monk_nomove_count = 0
  hero.previous_position = hero.position
  hero.qigong_level = 0
  hero.nextatk_bufflevel = 0
  hero.atk_count = 0
  if skillult then
    skillult.start = override(skillult.start, Monk.skillult_start)
    skillult.finish = override(skillult.finish, Monk.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Monk.skillult_onAttackFrame)
    skillult.onPhaseFinished = override(skillult.onPhaseFinished, Monk.skillult_onPhaseFinished)
    hero.getRuntimeScale = override(hero.getRuntimeScale, Monk.getRuntimeScale)
    skillult.selectTarget = override(skillult.selectTarget, Monk.skillult_selectTarget)
  end
  if skillults then
    skillults.takeEffectOn = override(skillults.takeEffectOn, Monk.skillults_takeEffectOn)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, Monk.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Monk.skillatk_onPhaseFinished)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Monk.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Monk.skillatk2_finish)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Monk.skillatk2_onAttackFrame)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, Monk.skillatk2_onPhaseFinished)
    if skillatk2s then
      if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
        skillatk2s.info = ed.wraptable(skillatk2s.info, {
          ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
        skillatk2s.info = ed.wraptable(skillatk2s.info, {
          ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
        })
      end
      if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
        skillatk2s.info = ed.wraptable(skillatk2s.info, {
          ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
        })
      end
    end
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Monk.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, Monk.skillatk3_createBuff)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Monk.skillatk3_onPhaseFinished)
    skillatk3.finish = override(skillatk3.finish, Monk.skillatk3_finish)
    skillatk3.start = override(skillatk3.start, Monk.skillatk3_start)
  end
  if skillenter then
    skillenter.start = override(skillenter.start, Monk.skillenter_start)
    skillenter.finish = override(skillenter.finish, Monk.skillenter_finish)
  end
  hero.reset = override(hero.reset, Monk.hero_reset)
  hero.update = override(hero.update, Monk.hero_update)
  hero.castManualSkill = override(hero.castManualSkill, Monk.castManualSkill)
  return hero
end

return Monk.init_hero
