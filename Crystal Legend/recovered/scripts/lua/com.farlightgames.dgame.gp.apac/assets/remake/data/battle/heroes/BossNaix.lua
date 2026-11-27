module("ed.battlehero", package.seeall)
local ed = ed
BossNaix = {}
BossNaix.atk3_closeCD = 15
BossNaix.atk3_firstCD = 5
BossNaix.atk3_AD_base = 10
BossNaix.atk3_LFS_base = 1
BossNaix.atk3_HPR_base = -10
BossNaix.atk3_healHp_ratio = 0.15
BossNaix.BossbuffID = 4175

function BossNaix.hero_reset(basefunc, hero)
  basefunc(hero)
  if ed.protoAwake(hero.proto, 10045) then
    hero:enterActionStageFromOneStage(3, 10045)
  else
    hero:enterActionStageFromOneStage(1, 10045)
  end
  hero.armlet_level = 0
  hero.atk3_closeCD = BossNaix.atk3_firstCD
  hero.atk3_healHp = hero.attribs.HP * BossNaix.atk3_healHp_ratio
  hero.mp = 1000
  hero.Boss_ult_index = 0
end

function BossNaix.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.Boss_ult_index < 2 then
    hero.mp = 1000
  end
  if hero:isAlive() then
    hero.atk3_closeCD = hero.atk3_closeCD - dt
    local skillatk3 = hero.skills.BossNaix_atk3
    local skillatk2 = hero.skills.BossNaix_atk2
    local skillatk4 = hero.skills.BossNaix_atk4
    local skillult = hero.skills.BossNaix_ult
    local skillultswitch = hero.skills.BossNaix_ultswitch
    local BeControlled
    if hero.buff_effects.stun or hero.buff_effects.silence or hero.buff_effects.doom or hero.buff_effects.enchanted or hero.buff_effects.frozen or hero.buff_effects.icefrozen or hero.BossNaix_inUltfreeze then
      BeControlled = true
    end
    if skillatk3 then
      hero.can_cast_manual = hero.can_cast_manual or skillatk3 and hero.mp < 1000 and hero:isAlive() and hero.current_skill ~= skillult and hero.current_skill ~= skillatk3 and not BeControlled and (hero.currentActionStage == 2 or hero.currentActionStage == 4 or (hero.currentActionStage == 1 or hero.currentActionStage == 3) and hero.atk3_closeCD <= 0)
    end
    if skillatk3 and hero.ai.will_cast_manual_skill then
      if hero.hp >= hero.attribs.HP * 0.12 and hero.hp <= hero.attribs.HP * 0.85 then
        hero.AIatk3toSuper = true
        hero.AIatk3toNormal = nil
      elseif hero.hp > hero.attribs.HP * 0.85 then
        hero.AIatk3toNormal = nil
        hero.AIatk3toSuper = nil
      elseif hero.hp < hero.attribs.HP * 0.12 and hero.atk3_closeCD <= 0 then
        hero.AIatk3toNormal = true
        hero.AIatk3toSuper = true
      end
    end
    if (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and hero.AIatk3toSuper and hero.current_skill ~= skillatk3 and hero.current_skill ~= skillatk2 and (not skillatk4 or hero.current_skill ~= skillatk4) and hero.current_skill ~= skillult and (hero.currentActionStage == 1 or hero.currentActionStage == 3) and hero.atk3_closeCD <= 0 and not BeControlled and not hero.BossNaix_inUltfreeze then
      if skillatk3 then
        hero:castSkill(skillatk3, nil)
        hero.atk3_closeCD = BossNaix.atk3_closeCD
      end
    elseif (ed.engine:arenaMode() or ed.engine:isTowerWarsMode()) and hero.AIatk3toNormal and hero.current_skill ~= skillult and (hero.currentActionStage == 2 or hero.currentActionStage == 4) and not BeControlled and not hero.BossNaix_inUltfreeze and skillatk3 then
      if ed.run_with_scene then
        local panel = hero.heroPanel
        if panel and hero.name == "BossNaix" then
          if hero.currentActionStage == 2 then
            panel:setPortrait("UI/DOTA-HERO/Naix.png")
          elseif hero.currentActionStage == 4 then
            panel:setPortrait("UI/DOTA-HERO/SwitchNaix.png")
          end
        end
      end
      hero.BossNaix_atkcd = hero.skills.BossNaix_atk.cd_remaining
      if skillatk2 then
        hero.BossNaix_atk2cd = hero.skills.BossNaix_atk2.cd_remaining
      end
      if skillatk4 then
        hero.BossNaix_atk4cd = hero.skills.BossNaix_atk4.cd_remaining
      end
      if hero.currentActionStage == 2 or hero.currentActionStage == 4 then
        if ed.protoAwake(hero.proto, 10045) then
          hero:enterActionStageFromOneStage(3, 10045)
        else
          hero:enterActionStageFromOneStage(1, 10045)
        end
      end
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 1156 or tbuff.info.ID == 1173 or tbuff.info.ID == 1174 or tbuff.info.ID == 1175 or tbuff.info.ID == 1176 then
          tbuff.timer = 0
        end
      end
      local healHp = hero.atk3_healHp
      if healHp >= hero.hp then
        hero:setHP(1)
      else
        hero:setHP(hero.hp - healHp)
      end
      hero.skills.BossNaix_atk.cd_remaining = hero.BossNaix_atkcd
      if skillatk2 then
        hero.skills.BossNaix_atk2.cd_remaining = hero.BossNaix_atk2cd
      end
      if skillatk4 then
        hero.skills.BossNaix_atk4.cd_remaining = hero.BossNaix_atk4cd
      end
      hero.global_cd = 0.5
    end
  end
end

function BossNaix.hero_unfreeze(basefunc, hero)
  if hero.BossNaix_inUltfreeze then
  else
    basefunc(hero)
    hero.BossNaix_inUltfreeze = nil
  end
end

function BossNaix.skillult_start(basefunc, skill, target)
  basefunc(skill)
  local caster = skill.caster
  local bid = 1158
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(binfo, caster)
end

function BossNaix.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if caster.BossNaix_inUltfreeze then
    result = nil
  end
  return result
end

function BossNaix.skillult_selectTarget(basefunc, skill, default)
  local target_type = skill.info["Target Type"]
  local selector = skill:target_selector()
  local Ignore = skill:Ignore_Target_Type()
  local max = -math.huge
  local chosen
  local caster = skill.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.tid == "Rubick" or unit.name == "Rubick" then
    elseif unit.tid == "Kael" or unit.name == "Kael" then
    elseif unit.tid == "BossNaix" or unit.name == "BossNaix" then
    elseif unit.buff_effects.uncontrollable or unit.controlledTarget then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
        local v = selector(unit)
        local shouldIgnore = Ignore(unit)
        if max < v and not shouldIgnore then
          max = v
          chosen = unit
        end
      end
    end
  end
  skill.target = chosen
  return skill.target
end

function BossNaix.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local camp = buff.owner.camp * -1
  local count = 1
  for unit in ed.engine:foreachAliveUnit(camp) do
    if not unit.config.is_summoned and unit ~= buff.owner then
      count = count + 1
    end
  end
  if count <= 1 and buff.timer > 3 then
    buff.timer = 3
  end
end

function BossNaix.skillult_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local bid = 1160
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, caster)
  owner:addBuff(binfo, owner)
  caster.BossNaix_inUltfreeze = nil
  caster:unfreeze()
  local skillultswitch = caster.skills.BossNaix_ultswitch
  caster:castSkill(skillultswitch, caster)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1158 then
      tbuff.timer = 0
    end
  end
  local skillults = caster.skills.BossNaix_ults
  skillults:takeEffectAt(caster.BossNaixUltposition)
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "BossNaix" and (caster.currentActionStage == 1 or caster.currentActionStage == 3) then
      if ed.protoAwake(caster.proto, 10045) then
        panel:setPortrait("UI/DOTA-HERO/SwitchNaix.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Naix.png")
      end
    elseif panel and caster.name == "BossNaix" and (caster.currentActionStage == 2 or caster.currentActionStage == 4) then
      if ed.protoAwake(caster.proto, 10045) then
        panel:setPortrait("UI/DOTA-HERO/SwitchNaix2.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Naix2.png")
      end
    end
  end
end

function BossNaix.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, BossNaix.skillult_buffOnRemoved)
  buff.update = override(buff.update, BossNaix.skillult_buffUpdate)
  return buff
end

function BossNaix.skillults_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if target.hp ~= 0 then
    return basefunc(skill, target, source, shift)
  end
end

function BossNaix.onAttackFrame_basefunc1(basefunc, skill)
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

function BossNaix.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = caster:getInitDir()
  local target = skill.target
  local originfo = skill.info
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
        target.position[1] - dir * 100,
        target.position[2]
      })
      caster.BossNaixUlttarget = skill.target
      caster.BossNaixUltposition = skill.target.position
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
  elseif attack_counter == 1 and caster.BossNaixUlttarget == skill.target then
    if target and not target:isHasUncontrolBufEffect() then
      local bid = 1159
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(binfo, target)
      target:hurt()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    basefunc(skill)
    if ed.run_with_scene and caster.controlTarget then
      local panel = caster.heroPanel
      if panel and caster.name == "BossNaix" and target then
        if ed.protoAwake(target.proto, target.info.ID) then
          panel:setPortrait(ed.recoverColum(target.info["Portrait Switch"]))
        else
          panel:setPortrait(ed.recoverColum(target.info.Portrait))
        end
      end
    end
  end
end

function BossNaix.skillult_finish(basefunc, skill)
  local caster = skill.caster
  caster.Boss_ult_index = caster.Boss_ult_index + 1
  local bid = BossNaix.BossbuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill)
  if caster.controlTarget then
    caster.BossNaix_inUltfreeze = true
    caster:freeze()
  end
end

function BossNaix.getRuntimeScale(basefunc, self)
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
    return self.direction * (m and 1.25 or 1), m and 1.25 or 1
  end
end

function BossNaix.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local skillatk2s = caster.skills.BossNaix_atk2s
  if attack_counter == 0 then
    skillatk2s:takeEffectAt(caster.position)
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    local location = caster.position
    local info = skill.info
    local direction = caster.direction
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    caster.BossNaix_atk2_nextpos = {
      location[1] + info["X Shift"] / 2 * direction,
      location[2]
    }
  end
end

function BossNaix.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:setPosition(caster.BossNaix_atk2_nextpos)
end

function BossNaix.hero_castManualSkill(basefunc, hero)
  local skillatk3 = hero.skills.BossNaix_atk3
  local skillatk2 = hero.skills.BossNaix_atk2
  local skillatk4 = hero.skills.BossNaix_atk4
  local skillult = hero.skills.BossNaix_ult
  if skillatk3 then
    if hero.atk3_closeCD <= 0 and hero.mp < 1000 and (hero.currentActionStage == 1 or hero.currentActionStage == 3) and hero.current_skill ~= skillatk3 and hero.current_skill ~= skillult and not hero.BossNaix_inUltfreeze then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      hero:castSkill(skillatk3, nil)
      hero.atk3_closeCD = BossNaix.atk3_closeCD
    elseif hero.mp < 1000 and (hero.currentActionStage == 2 or hero.currentActionStage == 4) and hero.current_skill ~= skillatk3 and hero.current_skill ~= skillult and not hero.BossNaix_inUltfreeze and hero.current_skill ~= skillatk2 and (not skillatk4 or hero.current_skill ~= skillatk4) then
      if ed.run_with_scene then
        local panel = hero.heroPanel
        if panel and hero.name == "BossNaix" then
          if hero.currentActionStage == 2 then
            panel:setPortrait("UI/DOTA-HERO/Naix.png")
          elseif hero.currentActionStage == 4 then
            panel:setPortrait("UI/DOTA-HERO/SwitchNaix.png")
          end
        end
      end
      hero.BossNaix_atkcd = hero.skills.BossNaix_atk.cd_remaining
      if skillatk2 then
        hero.BossNaix_atk2cd = hero.skills.BossNaix_atk2.cd_remaining
      end
      if skillatk4 then
        hero.BossNaix_atk4cd = hero.skills.BossNaix_atk4.cd_remaining
      end
      if hero.currentActionStage == 2 or hero.currentActionStage == 4 then
        if ed.protoAwake(hero.proto, 10045) then
          hero:enterActionStageFromOneStage(3, 10045)
        else
          hero:enterActionStageFromOneStage(1, 10045)
        end
      end
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 1156 or tbuff.info.ID == 1173 or tbuff.info.ID == 1174 or tbuff.info.ID == 1175 or tbuff.info.ID == 1176 then
          tbuff.timer = 0
        end
      end
      local healHp = hero.atk3_healHp
      if healHp >= hero.hp then
        hero:setHP(1)
      else
        hero:setHP(hero.hp - healHp)
      end
      hero.skills.BossNaix_atk.cd_remaining = hero.BossNaix_atkcd
      if skillatk2 then
        hero.skills.BossNaix_atk2.cd_remaining = hero.BossNaix_atk2cd
      end
      if skillatk4 then
        hero.skills.BossNaix_atk4.cd_remaining = hero.BossNaix_atk4cd
      end
      hero.global_cd = 0.5
    else
      basefunc(hero)
    end
  else
    basefunc(hero)
  end
end

function BossNaix.skillatk3_start(basefunc, skill, target)
  basefunc(skill)
  local caster = skill.caster
  local bid = 1183
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(binfo, caster)
end

function BossNaix.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.currentActionStage == 1 or caster.currentActionStage == 3 then
    caster.changePeriodtoSuper_BossNaix = true
  end
  local healHp = caster.atk3_healHp
  caster:takeHeal(healHp, "hp", caster)
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "BossNaix" then
      if caster.currentActionStage == 1 then
        panel:setPortrait("UI/DOTA-HERO/Naix2.png")
      elseif caster.currentActionStage == 3 then
        panel:setPortrait("UI/DOTA-HERO/SwitchNaix2.png")
      end
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1183 then
      tbuff.timer = 0
    end
  end
end

function BossNaix.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriodtoSuper_BossNaix then
    if caster.currentActionStage == 1 or caster.currentActionStage == 3 then
      if ed.protoAwake(caster.proto, 10045) then
        caster:enterActionStageFromOneStage(4, 10045)
      else
        caster:enterActionStageFromOneStage(2, 10045)
      end
      caster.changePeriodtoSuper_BossNaix = false
    end
    local bid = 1156
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("AD", skill.info["Script Arg2"])
    buff:setAttribute("LFS", skill.info["Script Arg3"])
    buff:setAttribute("HPR", skill.info["Script Arg4"])
    caster:addBuff(buff, caster)
    if 1 <= caster.armlet_level then
      local bid = 1173
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    end
    if 2 <= caster.armlet_level then
      local bid = 1174
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    end
    if 2 <= caster.armlet_level then
      local bid = 1175
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    end
    if 3 <= caster.armlet_level then
      local bid = 1176
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    end
  end
end

function BossNaix.skillatk4_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  if target.buff_effects.stable or target.buff_effects.building or target.buff_effects.uncontrollable then
    result = nil
  end
  return result
end

function BossNaix.skillatk4_start(basefunc, skill, target)
  local info = skill.info
  local caster = skill.caster
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local distance = math.abs(caster.position[1] - target.position[1])
  if 150 < distance then
    skill:startPhase(1)
  elseif skill.phase_list and skill.phase_list[2] then
    skill:startPhase(2)
  end
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  local oritarget = skill.target
  caster.BossNaix_atk2_oritarget = oritarget
end

function BossNaix.atk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner.actor then
    owner.actor:launch(0)
  end
end

function BossNaix.skillatk4_onAttackFrame(basefunc, skill)
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
      local bid = 1155
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.onRemoved = override(buff.onRemoved, BossNaix.atk4buff_onRemoved)
      target:addBuff(buff, caster)
      t = 0.25
      local dir = caster:getInitDir()
      if caster.position[1] - target.position[1] ~= 0 then
        dir = (caster.position[1] - target.position[1]) / math.abs(caster.position[1] - target.position[1])
      end
      distance = {
        caster.position[1] - target.position[1] - 50 * dir,
        caster.position[2] - target.position[2]
      }
      target:knockup(t, distance, true)
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif attack_counter == 1 then
    if target then
      target.height = 50
      if target.actor then
        target.actor.height = 50
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  elseif 2 <= attack_counter and attack_counter <= 4 and caster.BossNaix_atk2_oritarget == target and caster.BossNaix_atk2_oritarget:isAlive() then
    basefunc(skill)
    if attack_counter == 4 then
      skill.BossNaix_atk4_scuess = true
    end
  elseif attack_counter == 5 and caster.BossNaix_atk2_oritarget == target and caster.BossNaix_atk2_oritarget:isAlive() then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = 0.6
    })
    basefunc(skill)
    skill.info = originfo
    if target then
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == 1155 then
          tbuff.timer = 0
        end
      end
      target:knockup(0.1, {
        50 * caster.direction,
        0
      }, true)
      if target and target.actor then
        target.actor:launch(0)
      end
    end
  end
end

function BossNaix.hero_skillInterRupt(basefunc, hero, skill)
  basefunc(hero, skill)
  if skill == hero.skills.BossNaix_atk4 then
    local caster = skill.caster
    if caster.armlet_level == 1 then
      local bid = 1173
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    elseif caster.armlet_level == 2 then
      local bid = 1174
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    elseif caster.armlet_level == 2 then
      local bid = 1175
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    elseif caster.armlet_level == 3 then
      local bid = 1176
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    end
    if caster.BossNaix_atk2_oritarget then
      for i, tbuff in ipairs(caster.BossNaix_atk2_oritarget.buff_list) do
        if tbuff.info.ID == 1155 then
          tbuff.timer = 0
        end
      end
    end
  end
end

function BossNaix.skillatk4_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function BossNaix.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill)
  local caster = skill.caster
  if skill.BossNaix_atk4_scuess then
    caster.armlet_level = caster.armlet_level + 1
  end
  if reason ~= "interrupt" then
    if caster.armlet_level == 1 then
      local bid = 1173
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    elseif caster.armlet_level == 2 then
      local bid = 1174
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    elseif caster.armlet_level == 2 then
      local bid = 1175
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    elseif caster.armlet_level == 3 then
      local bid = 1176
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(binfo, caster)
    end
    if caster.BossNaix_atk2_oritarget then
      for i, tbuff in ipairs(caster.BossNaix_atk2_oritarget.buff_list) do
        if tbuff.info.ID == 1155 then
          tbuff.timer = 0
        end
      end
    end
  end
end

function BossNaix.skillawake_affect_takeEffectOn(basefunc, skill, target, source, shift)
  local result, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillawake = caster.skills.BossNaix_awake
  if lfs_amount and 0 < lfs_amount and skillawake then
    caster:addBuff(skillawake:createBuff(caster))
  end
end

function BossNaix.init_hero(hero)
  local skillult = hero.skills.BossNaix_ult
  local skillults = hero.skills.BossNaix_ults
  local skillatk2 = hero.skills.BossNaix_atk2
  local skillatk3 = hero.skills.BossNaix_atk3
  local skillatk4 = hero.skills.BossNaix_atk4
  local skillultswitch = hero.skills.BossNaix_ultswitch
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossNaix.skillult_onAttackFrame)
    skillult.start = override(skillult.start, BossNaix.skillult_start)
    skillult.finish = override(skillult.finish, BossNaix.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, BossNaix.skillult_createBuff)
    hero.getRuntimeScale = override(hero.getRuntimeScale, BossNaix.getRuntimeScale)
    skillult.selectTarget = override(skillult.selectTarget, BossNaix.skillult_selectTarget)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BossNaix.skillult_canCastWithTarget)
    skillults.takeEffectOn = override(skillults.takeEffectOn, BossNaix.skillults_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BossNaix.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossNaix.skillawake_affect_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, BossNaix.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, BossNaix.skillatk3_finish)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BossNaix.skillawake_affect_takeEffectOn)
    skillatk3.start = override(skillatk3.start, BossNaix.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, BossNaix.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, BossNaix.skillatk4_onAttackFrame)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, BossNaix.skillatk4_canCastWithTarget)
    skillatk4.onPhaseFinished = override(skillatk4.onPhaseFinished, BossNaix.skillatk4_onPhaseFinished)
    skillatk4.finish = override(skillatk4.finish, BossNaix.skillatk4_finish)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, BossNaix.skillawake_affect_takeEffectOn)
    hero.skillInterRupt = override(hero.skillInterRupt, BossNaix.hero_skillInterRupt)
  end
  hero.reset = override(hero.reset, BossNaix.hero_reset)
  hero.unfreeze = override(hero.unfreeze, BossNaix.hero_unfreeze)
  hero:setActionStageChangeByManual(true)
  if hero.name == "BossNaix" then
    hero.update = override(hero.update, BossNaix.hero_update)
    hero.castManualSkill = override(hero.castManualSkill, BossNaix.hero_castManualSkill)
  end
  return hero
end

return BossNaix.init_hero
