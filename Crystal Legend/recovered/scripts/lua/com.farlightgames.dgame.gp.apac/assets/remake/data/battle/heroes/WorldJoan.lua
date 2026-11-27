module("ed.battlehero", package.seeall)
local ed = ed
WorldJoan = {}
WorldJoan.ragelosthp = 600000
WorldJoan.rage2losthp = 200000
WorldJoan.velocity = 480
WorldJoan.startPosition = {-250, 1050}
WorldJoan.stage2hp = 30000000
WorldJoan.stage2ragelosthp = 400000

function WorldJoan.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.ultGoing then
    return false, "ultGoing"
  end
  return true
end

function WorldJoan.skillult_start(basefunc, self, target)
  local info = self.info
  local caster = self.caster
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  if caster.currentActionStage == 1 then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  caster.originposition = {
    caster.position[1],
    caster.position[2]
  }
  caster.skillult_affected_units = {}
  local hasBuff = false
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 243 and tbuff.timer < 5 then
      tbuff.timer = self.info["Script Arg2"] - 5
      hasBuff = true
      break
    end
  end
end

function WorldJoan.skillult_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 2 then
    caster.ultGoing = true
    caster.walk_v = {
      caster.direction * WorldJoan.velocity,
      0
    }
    skill:startPhase(3)
  elseif skill.current_phase_idx == 3 then
    caster.ultGoing = nil
    caster.walk_v = {0, 0}
    basefunc(skill)
  elseif skill.current_phase_idx == 4 then
    basefunc(skill)
  end
end

function WorldJoan.ultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.ultBuff = false
  local cd1, cd2, cd3
  if owner.currentActionStage == 2 then
    cd1 = owner.skills.WorldJoan_atk.cd_remaining
    if owner.skills.WorldJoan_atk2 then
      cd2 = owner.skills.WorldJoan_atk2.cd_remaining
    end
    if owner.skills.WorldJoan_atk3 then
      cd3 = owner.skills.WorldJoan_atk3.cd_remaining
    end
    owner:enterActionStageFromOneStage(1, 166)
    owner.skills.WorldJoan_atk.cd_remaining = cd1
    if cd2 then
      owner.skills.WorldJoan_atk2.cd_remaining = cd2
    end
    if cd3 then
      owner.skills.WorldJoan_atk2.cd_remaining = cd3
    end
  end
end

function WorldJoan.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local cd1, cd2, cd3
  if caster.currentActionStage == 1 then
    cd1 = caster.skills.WorldJoan_atk.cd_remaining
    if caster.skills.WorldJoan_atk2 then
      cd2 = caster.skills.WorldJoan_atk2.cd_remaining
    end
    if caster.skills.WorldJoan_atk3 then
      cd3 = caster.skills.WorldJoan_atk3.cd_remaining
    end
    caster:enterActionStageFromOneStage(2, 166)
    caster.skills.WorldJoan_atk.cd_remaining = cd1
    if cd2 then
      caster.skills.WorldJoan_atk2.cd_remaining = cd2
    end
    if cd3 then
      caster.skills.WorldJoan_atk2.cd_remaining = cd3
    end
  end
  local hasBuff = false
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 243 and tbuff.timer < 5 then
      tbuff.timer = skill.info["Script Arg2"] - 5
      hasBuff = true
      break
    end
  end
  if not hasBuff then
    local bid = 243
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    buff.onRemoved = override(buff.onRemoved, WorldJoan.ultbuff_onRemoved)
    buff.timer = skill.info["Script Arg2"]
    caster.ultBuff = true
  end
  skill.crossing = nil
  skill.crossing2 = nil
  caster.ultGoing = nil
  caster.walk_v = {0, 0}
  caster.skillult_affected_units = {}
end

function WorldJoan.skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
end

function WorldJoan.skillatk3_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  if skill.attack_counter ~= 0 then
    skill.info = ed.wraptable(originfo, {
      ["Impact Effect"] = false,
      ["Knock Up"] = 0,
      ["Knock Back"] = 0,
      ["Buff ID"] = 0
    })
  end
  basefunc(skill)
  skill.info = originfo
end

function WorldJoan.skillatk_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  if skill.caster.ultBuff then
    return power * 1.5, i
  else
    return power, i
  end
end

function WorldJoan.skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 243 and tbuff.timer < 5 then
      caster:removeBuff(tbuff)
    end
  end
  caster.ultBuff = nil
end

function WorldJoan.hero_update(basefunc, hero, dt)
  local skillult = hero.skills.WorldJoan_ult
  if hero.ultGoing then
    local info = skillult.info
    local direction = hero.direction
    local location = hero.position
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skillult:affectedCamp()) do
      local skillult_affected_units = hero.skillult_affected_units
      if not skillult_affected_units[unit] then
        local p2 = ed.edpSub(unit.position, origin)
        p2[1] = p2[1] * direction
        if skillult.testPointInShape(p2, shape, arg1, arg2) then
          skillult_affected_units[unit] = true
          skillult:takeEffectOn(unit, hero)
        end
      end
    end
    if not skillult.crossing and not skillult.crossing2 then
      if hero.position[1] > 799 - WorldJoan.velocity / 8 and hero.direction == 1 then
        hero.position[1] = WorldJoan.startPosition[1]
        skillult.crossing = true
        hero.skillult_affected_units = {}
      elseif hero.position[1] < 1 + WorldJoan.velocity / 8 and hero.direction == -1 then
        hero.position[1] = WorldJoan.startPosition[2]
        skillult.crossing2 = true
        hero.skillult_affected_units = {}
      end
    end
    if skillult.crossing and hero.position[1] > hero.originposition[1] - 80 then
      local distance = hero.originposition[1] - hero.position[1]
      skillult.crossing = nil
      hero.walk_v = {
        distance / 0.25,
        0
      }
    end
    if hero.skills.WorldJoan_ult.crossing2 and hero.position[1] < hero.originposition[1] + 80 then
      local distance = hero.originposition[1] - hero.position[1]
      skillult.crossing2 = nil
      hero.walk_v = {
        distance / 0.25,
        0
      }
    end
  end
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldJoan.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldJoan.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldJoan.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
    if hero.rageStack == 2 then
      local binfo
      local bid = 250
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero:addBuff(binfo, hero)
      hero.rageStack = hero.rageStack + 1
    end
    if hero.rageStack == 5 then
      local binfo
      local bid = 251
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero:addBuff(binfo, hero)
      hero.rageStack = hero.rageStack + 1
    end
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 256 then
        for i, pbuff in ipairs(hero.buff_list) do
          if pbuff.info.ID == 250 then
            local buff = pbuff
            buff.timer = 0
            break
          end
        end
      end
    end
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 257 then
        for i, pbuff in ipairs(hero.buff_list) do
          if pbuff.info.ID == 251 then
            local buff = pbuff
            buff.timer = 0
            break
          end
        end
      end
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldJoan.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldJoan.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldJoan.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldJoan.stage2hp and hero.hp - lost <= WorldJoan.stage2hp then
    return hero.hp - WorldJoan.stage2hp
  else
    return lost
  end
end

function WorldJoan.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldJoan.rage_buff_update)
  hero.lastrageStack = 0
  hero.skills.WorldJoan_ult.crossing = nil
  hero.skills.WorldJoan_ult.crossing2 = nil
  hero.originposition = nil
  hero.ultGoing = nil
  hero.walk_v = {0, 0}
  hero.skillult_affected_units = {}
  hero.direction = -1
  local caster = hero
  local proto = {_tid = 165, _level = 90}
  local config = {
    is_summoned = true,
    estimate_rank = true,
    estimate_skill = true
  }
  local NPCUS = ed.UnitCreate(proto, -caster.camp, config)
  local location = {640, 0}
  NPCUS.direction = -caster.direction
  ed.engine:summonUnit(NPCUS, location, caster, "Idle")
end

function WorldJoan.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldJoan.skillatk3_takeEffectOn(basefunc, skill, target)
  local target = skill.target
  local originfo = skill.info
  if skill.attack_counter == 1 then
    if target.info["Main Attrib"] ~= T("STR") then
      skill.info = ed.wraptable(originfo, {
        ["No Dodge"] = true,
        ["Knock Up"] = 0.8,
        ["Knock Back"] = 300
      })
      local binfo
      local bid = 254
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, target)
    end
    if target.info["Main Attrib"] == T("STR") then
      skill.info = ed.wraptable(originfo, {
        ["No Dodge"] = true,
        ["Knock Up"] = 0.4,
        ["Knock Back"] = 30
      })
      local binfo
      local bid = 245
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      target:addBuff(binfo, target)
    end
  end
  basefunc(skill, target)
  skill.info = originfo
end

function WorldJoan.skillatk2_takeEffectOn(basefunc, skill, target)
  local originfo = skill.info
  if target.info["Main Attrib"] == T("AGI") then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.5
    })
    local binfo
    local bid = 252
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, target)
  end
  if target.info["Main Attrib"] == T("INT") then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.9
    })
    local binfo
    local bid = 253
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, target)
  end
  basefunc(skill, target)
  skill.info = originfo
end

function WorldJoan.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.skillult_affected_units = {}
  hero.update = override(hero.update, WorldJoan.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldJoan.getLostHPAfterImmunity)
  hero.reset = override(hero.reset, WorldJoan.hero_reset)
  local skillult = hero.skills.WorldJoan_ult
  skillult.info["No Speeder"] = true
  skillult.onAttackFrame = override(skillult.onAttackFrame, WorldJoan.skillult_onAttackFrame)
  skillult.finish = override(skillult.finish, WorldJoan.skillult_finish)
  skillult.onPhaseFinished = override(skillult.onPhaseFinished, WorldJoan.skillult_onPhaseFinished)
  skillult.start = override(skillult.start, WorldJoan.skillult_start)
  skillult.canCastWithTarget = override(skillult.canCastWithTarget, WorldJoan.skillult_canCastWithTarget)
  local skillatk = hero.skills.WorldJoan_atk
  skillatk.power = override(skillatk.power, WorldJoan.skillatk_power)
  skillatk.finish = override(skillatk.finish, WorldJoan.skillatk_finish)
  local skillatk2 = hero.skills.WorldJoan_atk2
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, WorldJoan.skillatk_power)
    skillatk2.finish = override(skillatk2.finish, WorldJoan.skillatk_finish)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldJoan.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.WorldJoan_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, WorldJoan.skillatk3_takeEffectOn)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, WorldJoan.skillatk3_onAttackFrame)
    skillatk3.power = override(skillatk3.power, WorldJoan.skillatk_power)
    skillatk3.finish = override(skillatk3.finish, WorldJoan.skillatk_finish)
  end
  return hero
end

return WorldJoan.init_hero
