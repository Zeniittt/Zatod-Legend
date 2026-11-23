module("ed.battlehero", package.seeall)
local ed = ed
FV = {}
FV.name = "FV"
FV.ult_lock = 10007701
FV.ult_time = 10007702
FV.auraID = "FVult_timezone"
FV.zoneFg = "eff_tile_FV_timezone.cha"
FV.zoneBg = "eff_tile_FV_timezone_far.cha"
FV.skillultbRatioList = {
  0.5,
  0.5,
  0.5,
  0.5,
  0.5,
  0.5,
  0.5,
  0.5,
  0.8,
  0.8,
  0.8
}
FV.skillultbKnockUpList = {
  0.06,
  0.06,
  0.06,
  0.06,
  0.06,
  0.06,
  0.06,
  0.06,
  0.1,
  0.2,
  0.3
}
FV.skillultbKnockBackList = {
  0.6,
  0.6,
  0.6,
  0.6,
  0.6,
  0.6,
  0.6,
  0.6,
  8,
  15,
  30
}
FV.skillultbMoveForwardList = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  1,
  0
}
FV.skillultbCameraShakeHList = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  5,
  5,
  15
}
FV.skillultbAOEOriginList = {
  "self",
  "self",
  "self",
  "self",
  "self",
  "self",
  "self",
  "self",
  "self",
  "self",
  "self"
}
FV.skillultbAOEShapeList = {
  "circle",
  "circle",
  "circle",
  "circle",
  "circle",
  "circle",
  "circle",
  "circle",
  "rectangle",
  "rectangle",
  "rectangle"
}
FV.skillultbShapeArg1List = {
  150,
  150,
  150,
  150,
  150,
  150,
  150,
  150,
  150,
  200,
  300
}
FV.skillultbXShiftList = {
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  -100
}
FV.IEb = "eff_impact_FV_atkb.cha"
FV.IEc1 = "eff_impact_FV_atkc1.cha"
FV.IEc2 = "eff_impact_FV_atkc2.cha"
FV.IEc3 = "eff_impact_FV_atkc3.cha"
FV.ImpactEffectList = {
  FV.IEb,
  FV.IEb,
  FV.IEb,
  FV.IEb,
  FV.IEb,
  FV.IEb,
  FV.IEb,
  FV.IEb,
  FV.IEc1,
  FV.IEc2,
  FV.IEc3
}
FV.FashionId1IEb = "eff_impact_FV_fashion_1_atkb.cha"
FV.FashionId1IEc1 = "eff_impact_FV_fashion_1_atkc1.cha"
FV.FashionId1IEc2 = "eff_impact_FV_fashion_1_atkc2.cha"
FV.FashionId1IEc3 = "eff_impact_FV_fashion_1_atkc3.cha"
FV.FashionId1ImpactEffectList = {
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEb,
  FV.FashionId1IEc1,
  FV.FashionId1IEc2,
  FV.FashionId1IEc3
}
FV.skillultbBuffIDList = {
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil,
  nil
}
FV.blink_distance = 120
FV.skillFashionId1 = 771
FV.skillFashionId2 = 772
FV.evoSkillTicks = 24
FV.evonSkillHealEffect = "eff_point_FV_fashion.cha"

function FV.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  skill.AttackPosition = FV.DOP_in_battlefield(caster, 220, caster.foecamp)
  if skill.AttackPosition[1] < 200 then
    skill.AttackPosition[1] = 200
  elseif skill.AttackPosition[1] > 600 then
    skill.AttackPosition[1] = 600
  else
    skill.AttackPosition[1] = skill.AttackPosition[1] - caster.direction * 20
  end
  caster.FVultOriPos = {
    caster.position[1],
    caster.position[2]
  }
  caster:setPosition(skill.AttackPosition)
  if caster.name == "FV" then
    caster.skills[FV.name .. "_return"].cd_remaining = 999
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    FV.evoSkillTakeEffect(caster)
  end
  local bid = 10007706
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function FV.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.FV_ult
  if skill.attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
  else
    local AttackPosition = skill.AttackPosition
    if AttackPosition then
      skill.attack_counter = skill.attack_counter + 1
      if caster.manually_casting then
        ed.engine:unfreeze()
        caster.manually_casting = false
      end
      skillult:takeEffectAt(AttackPosition, caster)
      local bid = FV.ult_time
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      local bufftimer = skillult.info["Script Arg2"]
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 10007706 then
          local buff = tbuff
          buff.timer = -1
        end
      end
      if skill.evo_rank and 1 <= skill.evo_rank then
        bufftimer = bufftimer + skill.evo_rank1["Script Arg1"]
      end
      if skill.evo_rank and skill.evo_rank >= 2 then
        bufftimer = bufftimer + skill.evo_rank2["Script Arg1"]
      end
      buff.timer = bufftimer
      if buff then
        buff.onRemoved = override(buff.onRemoved, FV.skillultbuff_onRemoved)
        buff.update = override(buff.update, FV.skillultbuff_update)
      end
      if ed.run_with_scene then
        local effect_name1 = "eff_tile_FV_timezone.cha"
        local fashionId = caster.fashion_id
        if fashionId and fashionId == FV.skillFashionId1 then
          effect_name1 = "eff_tile_FV_fashion_1_timezone.cha"
        end
        if fashionId and fashionId == FV.skillFashionId2 then
          effect_name1 = "eff_tile_FV_timezone_fashion_2.cha"
        end
        buff.effectult1 = ed.scene:playEffectOnScene(effect_name1, AttackPosition, {
          caster.direction * 1,
          1
        }, nil, 1)
        local effect_name2 = "eff_tile_FV_timezone_far.cha"
        if fashionId and fashionId == FV.skillFashionId1 then
          effect_name2 = "eff_tile_FV_fashion_1_timezone_far.cha"
        end
        if fashionId and fashionId == FV.skillFashionId2 then
          effect_name1 = "eff_tile_FV_timezone_far_fashion_2.cha"
        end
        buff.effectult2 = ed.scene:playEffectOnScene(effect_name2, AttackPosition, {
          caster.direction * 1,
          1
        }, nil, -1)
      end
      caster.walk_speed_multiplier = 2.5
      if ed.run_with_scene and ed.scene and ed.scene.enterFVTimeZone then
        ed.scene:enterFVTimeZone()
      end
      if caster.name == "FV" then
        caster.skills[FV.name .. "_ultb"].cd_remaining = 0
        caster.global_cd = 0
      end
    end
  end
end

function FV.skillultbuff_update(basefunc, buff, dt)
  local caster = buff.caster
  local skillult = caster.skills.FV_ult
  skillult:takeEffectAt(skillult.AttackPosition, caster)
  basefunc(buff, dt)
end

function FV.skillultbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  if buff.effectult1 then
    buff.effectult1:setVisible(false)
  end
  if buff.effectult2 then
    buff.effectult2:setVisible(false)
  end
  if ed.run_with_scene and ed.scene and ed.scene.exitFVTimeZone then
    ed.scene:exitFVTimeZone()
  end
  if ed.run_with_scene and ed.scene and ed.scene.ClearFVTimeZone then
    ed.scene:ClearFVTimeZone()
  end
  caster.walk_speed_multiplier = caster.Ori_walk_speed_multiplier_FV
  basefunc(buff)
end

function FV.skillult_takeEffectOn(basefunc, skill, target, source)
  if target.ImmuneTimeZone then
    return
  end
  basefunc(skill, target, source)
end

function FV.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return caster.position
  end
end

function FV.skillultb_onAttackFrame(basefunc, skill)
  local info = skill.info
  info["Plus Ratio"] = FV.skillultbRatioList[skill.attack_counter + 1]
  info["Knock Up"] = FV.skillultbKnockUpList[skill.attack_counter + 1]
  info["Knock Back"] = FV.skillultbKnockBackList[skill.attack_counter + 1]
  info["Move Forward"] = FV.skillultbMoveForwardList[skill.attack_counter + 1]
  info["AOE Origin"] = FV.skillultbAOEOriginList[skill.attack_counter + 1]
  info["AOE Shape"] = FV.skillultbAOEShapeList[skill.attack_counter + 1]
  info["Shape Arg1"] = FV.skillultbShapeArg1List[skill.attack_counter + 1]
  info["X Shift"] = FV.skillultbXShiftList[skill.attack_counter + 1]
  info["Impact Effect"] = FV.ImpactEffectList[skill.attack_counter + 1]
  local caster = skill.caster
  local fashionId = caster.fashion_id
  if fashionId and fashionId == FV.skillFashionId1 then
    info["Impact Effect"] = FV.FashionId1ImpactEffectList[skill.attack_counter + 1]
  end
  local bid = FV.skillultbBuffIDList[skill.attack_counter + 1]
  if bid then
    info["Buff ID"] = bid
    info.buff_info = ed.lookupDataTable("Buff", nil, bid)
  else
    info["Buff ID"] = nil
  end
  local self = skill
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  local caster = self.caster
  local aoe = self.info["AOE Origin"]
  if self.target then
    self:takeEffectAt(self.target.position)
  elseif aoe then
    self:takeEffectAt(caster.position)
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
  if ed.run_with_scene and FV.skillultbCameraShakeHList[skill.attack_counter] ~= nil and 0 < FV.skillultbCameraShakeHList[skill.attack_counter] then
    ed.scene:startCameraShakeAnimationY(FV.skillultbCameraShakeHList[skill.attack_counter], 0.1, 3)
  end
end

function FV.skillultb_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  if unit:isAlive() then
    if unit.name == "FV" then
      unit.skills[FV.name .. "_return"].cd_remaining = 0
    else
      local caster = skill.caster
      if caster.name == "Rubick" and caster.FVultOriPos then
        caster:setPosition(caster.FVultOriPos)
        caster.FVultOriPos = nil
      end
    end
  end
end

function FV.return_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.FVultOriPos then
    local nextDirection = caster.FVultOriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.FVultOriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.FVultOriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    caster.direction = nextDirection
    caster.position = caster.FVultOriPos
    caster.FVultOriPos = nil
  elseif caster.FVatk2OriPos then
    local nextDirection = caster.FVatk2OriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.FVatk2OriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.FVatk2OriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    caster.direction = nextDirection
    caster.position = caster.FVatk2OriPos
    caster.FVatk2OriPos = nil
  end
end

function FV.return_finish(basefunc, skill)
  basefunc(skill)
end

function FV.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk4 = unit.skills[FV.name .. "_atk4"]
  if skillatk4 then
    local Rate = skillatk4.info["Script Arg2"] / 100
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      Rate = Rate + skillatk4.evo_rank1["Script Arg1"] / 100
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      Rate = Rate + skillatk4.evo_rank3["Script Arg1"] / 100
    end
    if ret and skillatk4 and target == skill.target and Rate >= ed.rand() then
      skillatk4:takeEffectAt(target.position, source)
    end
  end
  return ret, dmg
end

function FV.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk4 = unit.skills[FV.name .. "_atk4"]
  if skillatk4 then
    local Rate = skillatk4.info["Script Arg2"] / 100
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      Rate = Rate + skillatk4.evo_rank1["Script Arg1"] / 100
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      Rate = Rate + skillatk4.evo_rank3["Script Arg1"] / 100
    end
    if ret and skillatk4 and target == skill.target and Rate >= ed.rand() then
      skillatk4:takeEffectAt(target.position, source)
    end
  end
  return ret, dmg
end

function FV.skillatk2_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local ret = basefunc(skill, default)
  if ret then
    skill.FVTargetPos = {
      ret.position[1],
      ret.position[2]
    }
  end
  return ret
end

function FV.skillatk2_onAttackFrame(basefunc, self)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  self.target = self.starttarget
  if not self.target then
    return
  end
  local info = self.info
  local caster = self.caster
  local ttype = info["Track Type"]
  local MPGR = caster.attribs.MPGainRatio or 0
  self:createTrackType(ttype)
  if MPGR and self.current_phase_idx == 2 then
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function FV.skillatk2_start(basefunc, skill, target)
  local info = skill.info
  skill:selectTarget()
  skill.starttarget = skill.target
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  skill.is_update = true
  local caster = skill.caster
  caster.FVatk2OriPos = nil
  local direction = caster.direction
  local distanceSQ
  if skill.target then
    distanceSQ = (skill.target.position[1] - caster.position[1]) ^ 2 + (skill.target.position[2] - skill.target.position[2]) ^ 2
  end
  if distanceSQ and 24025 < distanceSQ then
    caster.FVatk2OriPos = caster.position
    if skill.FVTargetPos then
      local postionX = skill.FVTargetPos[1] - direction * FV.blink_distance
      if postionX <= 0 then
        postionX = skill.FVTargetPos[1] + FV.blink_distance
      elseif 800 <= postionX then
        postionX = skill.FVTargetPos[1] - FV.blink_distance
      end
      caster.position = {
        postionX,
        skill.FVTargetPos[2]
      }
      if ed.run_with_scene then
        local effect_name = caster:getShadowEffect()
        if not effect_name then
          return
        end
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, caster.FVatk2OriPos, {
          caster.direction,
          1
        }, nil, effect_z)
      end
      local bid = 10007706
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
    end
    skill:startPhase(1)
  else
    skill:startPhase(2)
  end
  caster.global_cd = info["Global CD"]
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function FV.skillatk2_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 then
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == 10007706 then
        local buff = tbuff
        buff.timer = -1
      end
    end
  end
  basefunc(skill)
end

function FV.skillatk2_takeEffectAt(basefunc, skill, location, source)
  if skill.current_phase_idx == 2 then
    basefunc(skill, location, source)
    if ed.run_with_scene then
      local caster = skill.caster
      local effect_name = "eff_point_FV_atk2"
      local effect_z = -1
      ed.scene:playEffectOnScene(effect_name, caster.position, {
        caster.direction,
        1
      }, nil, effect_z)
    end
  end
end

function FV.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.name == "FV" and caster.FVatk2OriPos then
    caster.skills[FV.name .. "_return"].cd_remaining = 0
    caster.global_cd = 0
  end
end

function FV.getLostHPAfterImmunity(basefunc, unit, damage, immunity)
  local lostHP = basefunc(unit, damage, immunity)
  local skillatk3 = unit.skills[FV.name .. "_atk3"]
  local skillinfo = skillatk3.info
  local DodgeRate = skillinfo["Script Arg2"] / 100
  if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
    DodgeRate = DodgeRate + skillatk3.evo_rank1["Script Arg1"] / 100
  end
  if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
    DodgeRate = DodgeRate + skillatk3.evo_rank2["Script Arg1"] / 100
  end
  if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    DodgeRate = DodgeRate + skillatk3.evo_rank3["Script Arg1"] / 100
  end
  local Dodge = DodgeRate > ed.rand()
  if Dodge then
    lostHP = 0
    local name = skillinfo["Impact Effect"]
    local fashionId = unit.fashion_id
    if fashionId and fashionId == FV.skillFashionId1 then
      name = "eff_impact_FV_fashion_1_atk3.cha"
    end
    if fashionId and fashionId == FV.skillFashionId1 then
      name = "eff_impact_FV_atk3_fashion_2.cha"
    end
    if name and unit.actor then
      local effect_z = skillinfo["Impact Zorder"]
      unit.actor:addEffect(name, effect_z)
    end
  end
  return lostHP
end

function FV.evoSkillTakeEffect(unit)
  local total = 0
  if type(unit.evoSKill_damageList) == "table" then
    for _, ret in pairs(unit.evoSKill_damageList) do
      if type(ret) == "table" and ret[2] then
        total = total + ret[2]
      end
    end
  end
  local skillult = unit.skills.FV_ult
  local evoSkillHealCoef = skillult.evo_rank3["Script Arg1"] / 100
  if 0 < total then
    local heal = math.min(total * evoSkillHealCoef, unit.attribs.HP * evoSkillHealCoef)
    unit:takeHeal(heal, "hp", unit)
    if ed.run_with_scene and unit.actor then
      unit.actor:addEffect(FV.evonSkillHealEffect, 0)
    end
  end
  return total
end

function FV.reset(basefunc, unit)
  basefunc(unit)
  unit.Ori_walk_speed_multiplier_FV = unit.walk_speed_multiplier
  local skillult = unit.skills[FV.name .. "_ult"]
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    unit.evoSKill_damageList = {}
    for i = 1, FV.evoSkillTicks do
      unit.evoSKill_damageList[i - 1] = {
        i - 1,
        0
      }
    end
  end
end

function FV.setHP(basefunc, unit, hp, reason)
  local perviousHp = unit.hp
  basefunc(unit, hp, reason)
  local newHp = unit.hp
  local skillult = unit.skills[FV.name .. "_ult"]
  if skillult and skillult.evo_rank and skillult.evo_rank >= 3 and perviousHp > newHp then
    local currentTick = ed.engine.ticks
    local mod = currentTick % FV.evoSkillTicks
    if type(unit.evoSKill_damageList) == "table" and unit.evoSKill_damageList[mod][1] == currentTick then
      unit.evoSKill_damageList[mod][2] = unit.evoSKill_damageList[mod][2] + (perviousHp - newHp)
    elseif type(unit.evoSKill_damageList) == "table" then
      unit.evoSKill_damageList[mod][1] = currentTick
      unit.evoSKill_damageList[mod][2] = perviousHp - newHp
    end
  end
end

function FV.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local skillult = unit.skills[FV.name .. "_ult"]
  if skillult and skillult.evo_rank and skillult.evo_rank >= 3 then
    local tick = ed.engine.ticks
    local currentTick = ed.engine.ticks
    local mod = currentTick % FV.evoSkillTicks
    if type(unit.evoSKill_damageList) == "table" and unit.evoSKill_damageList[mod][1] ~= currentTick then
      unit.evoSKill_damageList[mod][1] = currentTick
      unit.evoSKill_damageList[mod][2] = 0
    end
  end
end

function FV.init_hero(hero)
  if hero.name ~= "Rubick" then
    hero.ImmuneTimeZone = true
  end
  local skillult = hero.skills[FV.name .. "_ult"]
  local skillultb = hero.skills[FV.name .. "_ultb"]
  local skillatk = hero.skills[FV.name .. "_atk"]
  local skillatk2 = hero.skills[FV.name .. "_atk2"]
  local skillatk3 = hero.skills[FV.name .. "_atk3"]
  local skillatk4 = hero.skills[FV.name .. "_atk4"]
  local skillreturn = hero.skills[FV.name .. "_return"]
  if skillult then
    hero.DoneRadius = skillult.info["Shape Arg1"]
    skillult.start = override(skillult.start, FV.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, FV.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, FV.skillult_takeEffectOn)
  end
  if skillultb then
    skillultb.info["No Dodge"] = true
    skillultb.onAttackFrame = override(skillultb.onAttackFrame, FV.skillultb_onAttackFrame)
    skillultb.finish = override(skillultb.finish, FV.skillultb_finish)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, FV.skillatk_takeEffectOn)
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    if FV.skillFashionId1 and FV.skillFashionId1 == hero.fashion_id then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Impact Effect"] = "eff_impact_FV_fashion_1_atk2.cha"
      })
    end
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, FV.skillatk2_takeEffectOn)
    skillatk2.selectTarget = override(skillatk2.selectTarget, FV.skillatk2_selectTarget)
    skillatk2.start = override(skillatk2.start, FV.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, FV.skillatk2_onAttackFrame)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, FV.skillatk2_takeEffectAt)
    skillatk2.finish = override(skillatk2.finish, FV.skillatk2_finish)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, FV.skillatk2_onPhaseFinished)
  end
  if skillatk3 then
    if FV.skillFashionId1 and FV.skillFashionId1 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Impact Effect"] = "eff_impact_FV_fashion_1_atk3.cha"
      })
    end
    if FV.skillFashionId1 and FV.skillFashionId2 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Impact Effect"] = "eff_impact_FV_atk3_fashion_2.cha"
      })
    end
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, FV.getLostHPAfterImmunity)
  end
  if skillatk4 and skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
    skillatk4.info = ed.wraptable(skillatk4.info, {
      ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
    })
  end
  if skillreturn then
    skillreturn.start = override(skillreturn.start, FV.return_start)
    skillreturn.finish = override(skillreturn.finish, FV.return_finish)
  end
  hero.reset = override(hero.reset, FV.reset)
  hero.update = override(hero.update, FV.update)
  hero.setHP = override(hero.setHP, FV.setHP)
  
  function hero.getShadowEffect(unit)
    local effect = "eff_point_FV_Shadow.cha"
    local fashionId = unit.fashion_id
    if fashionId and fashionId == FV.skillFashionId1 then
      effect = "eff_point_FV_fashion_1_Shadow.cha"
    end
    if fashionId and fashionId == FV.skillFashionId2 then
      effect = "eff_point_FV_Shadow_fashion_2.cha"
    end
    return effect
  end
  
  return hero
end

return FV.init_hero
