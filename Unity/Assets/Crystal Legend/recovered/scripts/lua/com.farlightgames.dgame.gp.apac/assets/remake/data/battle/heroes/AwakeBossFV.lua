module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossFV = {}
AwakeBossFV.name = "AwakeBossFV"
AwakeBossFV.ult_lock = 10038701
AwakeBossFV.ult_time = 10038702
AwakeBossFV.auraID = "AwakeBossFVult_timezone"
AwakeBossFV.zoneFg = "eff_tile_FV_timezone.cha"
AwakeBossFV.zoneBg = "eff_tile_FV_timezone_far.cha"
AwakeBossFV.skillultbRatioList = {
  0.45,
  0.45,
  0.45,
  0.45,
  0.45,
  0.45,
  0.45,
  0.45,
  0.7,
  0.7,
  0.7
}
AwakeBossFV.skillultbKnockUpList = {
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
AwakeBossFV.skillultbKnockBackList = {
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
AwakeBossFV.skillultbMoveForwardList = {
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
AwakeBossFV.skillultbCameraShakeHList = {
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
AwakeBossFV.skillultbAOEOriginList = {
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
AwakeBossFV.skillultbAOEShapeList = {
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
AwakeBossFV.skillultbShapeArg1List = {
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
AwakeBossFV.skillultbXShiftList = {
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
AwakeBossFV.IEb = "eff_impact_FV_atkb.cha"
AwakeBossFV.IEc1 = "eff_impact_FV_atkc1.cha"
AwakeBossFV.IEc2 = "eff_impact_FV_atkc2.cha"
AwakeBossFV.IEc3 = "eff_impact_FV_atkc3.cha"
AwakeBossFV.ImpactEffectList = {
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEb,
  AwakeBossFV.IEc1,
  AwakeBossFV.IEc2,
  AwakeBossFV.IEc3
}
AwakeBossFV.skillultbBuffIDList = {
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
AwakeBossFV.blink_distance = 120
AwakeBossFV.skillFashionId = 771
AwakeBossFV.evoSkillTicks = 24
AwakeBossFV.evonSkillHealEffect = "eff_point_FV_fashion.cha"

function AwakeBossFV.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  skill.AttackPosition = AwakeBossFV.DOP_in_battlefield(caster, 220, caster.foecamp)
  if skill.AttackPosition[1] < 200 then
    skill.AttackPosition[1] = 200
  elseif skill.AttackPosition[1] > 600 then
    skill.AttackPosition[1] = 600
  else
    skill.AttackPosition[1] = skill.AttackPosition[1] - caster.direction * 20
  end
  caster.AwakeBossFVultOriPos = {
    caster.position[1],
    caster.position[2]
  }
  caster:setPosition(skill.AttackPosition)
  if caster.name == "AwakeBossFV" then
    caster.skills[AwakeBossFV.name .. "_return"].cd_remaining = 999
  end
end

function AwakeBossFV.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.AwakeBossFV_ult
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
      local bid = AwakeBossFV.ult_time
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      local bufftimer = skillult.info["Script Arg2"]
      buff.timer = bufftimer
      if buff then
        buff.onRemoved = override(buff.onRemoved, AwakeBossFV.skillultbuff_onRemoved)
        buff.update = override(buff.update, AwakeBossFV.skillultbuff_update)
      end
      if ed.run_with_scene then
        local effect_name1 = "eff_tile_FV_timezone.cha"
        buff.effectult1 = ed.scene:playEffectOnScene(effect_name1, AttackPosition, {
          caster.direction * 1,
          1
        }, nil, 1)
        local effect_name2 = "eff_tile_FV_timezone_far.cha"
        buff.effectult2 = ed.scene:playEffectOnScene(effect_name2, AttackPosition, {
          caster.direction * 1,
          1
        }, nil, -1)
      end
      caster.walk_speed_multiplier = 2.5
      if ed.run_with_scene and ed.scene and ed.scene.enterAwakeBossFVTimeZone then
        ed.scene:enterAwakeBossFVTimeZone()
      end
      if caster.name == "AwakeBossFV" then
        caster.skills[AwakeBossFV.name .. "_ultb"].cd_remaining = 0
        caster.global_cd = 0
      end
    end
  end
end

function AwakeBossFV.skillultbuff_update(basefunc, buff, dt)
  local caster = buff.caster
  local skillult = caster.skills.AwakeBossFV_ult
  skillult:takeEffectAt(skillult.AttackPosition, caster)
  basefunc(buff, dt)
end

function AwakeBossFV.skillultbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  if buff.effectult1 then
    buff.effectult1:setVisible(false)
  end
  if buff.effectult2 then
    buff.effectult2:setVisible(false)
  end
  if ed.run_with_scene and ed.scene and ed.scene.exitAwakeBossFVTimeZone then
    ed.scene:exitAwakeBossFVTimeZone()
  end
  if ed.run_with_scene and ed.scene and ed.scene.ClearAwakeBossFVTimeZone then
    ed.scene:ClearAwakeBossFVTimeZone()
  end
  caster.walk_speed_multiplier = caster.Ori_walk_speed_multiplier_AwakeBossFV
  basefunc(buff)
end

function AwakeBossFV.skillult_takeEffectOn(basefunc, skill, target, source)
  if target.ImmuneTimeZone then
    return
  end
  basefunc(skill, target, source)
end

function AwakeBossFV.DOP_in_battlefield(caster, radius, camp)
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

function AwakeBossFV.skillultb_onAttackFrame(basefunc, skill)
  local info = skill.info
  info["Plus Ratio"] = AwakeBossFV.skillultbRatioList[skill.attack_counter + 1]
  info["Knock Up"] = AwakeBossFV.skillultbKnockUpList[skill.attack_counter + 1]
  info["Knock Back"] = AwakeBossFV.skillultbKnockBackList[skill.attack_counter + 1]
  info["Move Forward"] = AwakeBossFV.skillultbMoveForwardList[skill.attack_counter + 1]
  info["AOE Origin"] = AwakeBossFV.skillultbAOEOriginList[skill.attack_counter + 1]
  info["AOE Shape"] = AwakeBossFV.skillultbAOEShapeList[skill.attack_counter + 1]
  info["Shape Arg1"] = AwakeBossFV.skillultbShapeArg1List[skill.attack_counter + 1]
  info["X Shift"] = AwakeBossFV.skillultbXShiftList[skill.attack_counter + 1]
  info["Impact Effect"] = AwakeBossFV.ImpactEffectList[skill.attack_counter + 1]
  local bid = AwakeBossFV.skillultbBuffIDList[skill.attack_counter + 1]
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
  if ed.run_with_scene and AwakeBossFV.skillultbCameraShakeHList[skill.attack_counter] ~= nil and 0 < AwakeBossFV.skillultbCameraShakeHList[skill.attack_counter] then
    ed.scene:startCameraShakeAnimationY(AwakeBossFV.skillultbCameraShakeHList[skill.attack_counter], 0.1, 3)
  end
end

function AwakeBossFV.skillultb_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  if unit:isAlive() then
    if unit.name == "AwakeBossFV" then
      unit.skills[AwakeBossFV.name .. "_return"].cd_remaining = 0
    else
      local caster = skill.caster
      if caster.name == "Rubick" and caster.AwakeBossFVultOriPos then
        caster:setPosition(caster.AwakeBossFVultOriPos)
        caster.AwakeBossFVultOriPos = nil
      end
    end
  end
end

function AwakeBossFV.return_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.AwakeBossFVultOriPos then
    local nextDirection = caster.AwakeBossFVultOriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.AwakeBossFVultOriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.AwakeBossFVultOriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    caster.direction = nextDirection
    caster.position = caster.AwakeBossFVultOriPos
    caster.AwakeBossFVultOriPos = nil
  elseif caster.AwakeBossFVatk2OriPos then
    local nextDirection = caster.AwakeBossFVatk2OriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.AwakeBossFVatk2OriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.AwakeBossFVatk2OriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    caster.direction = nextDirection
    caster.position = caster.AwakeBossFVatk2OriPos
    caster.AwakeBossFVatk2OriPos = nil
  end
end

function AwakeBossFV.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk4 = unit.skills[AwakeBossFV.name .. "_atk4"]
  if skillatk4 then
    local Rate = skillatk4.info["Script Arg2"] / 100
    if ret and skillatk4 and target == skill.target and Rate >= ed.rand() then
      skillatk4:takeEffectAt(target.position, source)
    end
  end
  return ret, dmg
end

function AwakeBossFV.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk4 = unit.skills[AwakeBossFV.name .. "_atk4"]
  if skillatk4 then
    local Rate = skillatk4.info["Script Arg2"] / 100
    if ret and skillatk4 and target == skill.target and Rate >= ed.rand() then
      skillatk4:takeEffectAt(target.position, source)
    end
  end
  return ret, dmg
end

function AwakeBossFV.skillatk2_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local ret = basefunc(skill, default)
  if ret then
    skill.AwakeBossFVTargetPos = {
      ret.position[1],
      ret.position[2]
    }
  end
  return ret
end

function AwakeBossFV.skillatk2_onAttackFrame(basefunc, self)
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

function AwakeBossFV.skillatk2_start(basefunc, skill, target)
  local info = skill.info
  skill:selectTarget()
  skill.starttarget = skill.target
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  skill.is_update = true
  local caster = skill.caster
  caster.AwakeBossFVatk2OriPos = nil
  local direction = caster.direction
  local distanceSQ
  if skill.target then
    distanceSQ = (skill.target.position[1] - caster.position[1]) ^ 2 + (skill.target.position[2] - skill.target.position[2]) ^ 2
  end
  if distanceSQ and 24025 < distanceSQ then
    caster.AwakeBossFVatk2OriPos = caster.position
    if skill.AwakeBossFVTargetPos then
      local postionX = skill.AwakeBossFVTargetPos[1] - direction * AwakeBossFV.blink_distance
      if postionX <= 0 then
        postionX = skill.AwakeBossFVTargetPos[1] + AwakeBossFV.blink_distance
      elseif 800 <= postionX then
        postionX = skill.AwakeBossFVTargetPos[1] - AwakeBossFV.blink_distance
      end
      caster.position = {
        postionX,
        skill.AwakeBossFVTargetPos[2]
      }
      if ed.run_with_scene then
        local effect_name = caster:getShadowEffect()
        if not effect_name then
          return
        end
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, caster.AwakeBossFVatk2OriPos, {
          caster.direction,
          1
        }, nil, effect_z)
      end
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

function AwakeBossFV.skillatk2_takeEffectAt(basefunc, skill, location, source)
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

function AwakeBossFV.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.name == "AwakeBossFV" and caster.AwakeBossFVatk2OriPos then
    caster.skills[AwakeBossFV.name .. "_return"].cd_remaining = 0
    caster.global_cd = 0
  end
end

function AwakeBossFV.getLostHPAfterImmunity(basefunc, unit, damage, immunity)
  local lostHP = basefunc(unit, damage, immunity)
  local skillatk3 = unit.skills[AwakeBossFV.name .. "_atk3"]
  local skillinfo = skillatk3.info
  local DodgeRate = skillinfo["Script Arg2"] / 100
  local Dodge = DodgeRate > ed.rand()
  if Dodge then
    local dodgeDamage = skillinfo["Script Arg3"]
    lostHP = math.max(0, lostHP - dodgeDamage)
    local name = skillinfo["Impact Effect"]
    local fashionId = unit.fashion_id
    if fashionId and fashionId == AwakeBossFV.skillFashionId then
      name = "eff_impact_FV4_atk3.cha"
    end
    if name and unit.actor then
      local effect_z = skillinfo["Impact Zorder"]
      unit.actor:addEffect(name, effect_z)
    end
  end
  return lostHP
end

function AwakeBossFV.reset(basefunc, unit)
  basefunc(unit)
  unit.Ori_walk_speed_multiplier_AwakeBossFV = unit.walk_speed_multiplier
  local skillult = unit.skills[AwakeBossFV.name .. "_ult"]
end

function AwakeBossFV.setHP(basefunc, unit, hp, reason)
  local perviousHp = unit.hp
  basefunc(unit, hp, reason)
  local newHp = unit.hp
  local skillult = unit.skills[AwakeBossFV.name .. "_ult"]
end

function AwakeBossFV.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local skillult = unit.skills[AwakeBossFV.name .. "_ult"]
end

function AwakeBossFV.init_hero(hero)
  if hero.name ~= "Rubick" then
    hero.ImmuneTimeZone = true
  end
  local skillult = hero.skills[AwakeBossFV.name .. "_ult"]
  local skillultb = hero.skills[AwakeBossFV.name .. "_ultb"]
  local skillatk = hero.skills[AwakeBossFV.name .. "_atk"]
  local skillatk2 = hero.skills[AwakeBossFV.name .. "_atk2"]
  local skillatk3 = hero.skills[AwakeBossFV.name .. "_atk3"]
  local skillatk4 = hero.skills[AwakeBossFV.name .. "_atk4"]
  local skillreturn = hero.skills[AwakeBossFV.name .. "_return"]
  if skillult then
    hero.DoneRadius = skillult.info["Shape Arg1"]
    skillult.start = override(skillult.start, AwakeBossFV.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, AwakeBossFV.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossFV.skillult_takeEffectOn)
  end
  if skillultb then
    skillultb.info["No Dodge"] = true
    skillultb.onAttackFrame = override(skillultb.onAttackFrame, AwakeBossFV.skillultb_onAttackFrame)
    skillultb.finish = override(skillultb.finish, AwakeBossFV.skillultb_finish)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, AwakeBossFV.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, AwakeBossFV.skillatk2_takeEffectOn)
    skillatk2.selectTarget = override(skillatk2.selectTarget, AwakeBossFV.skillatk2_selectTarget)
    skillatk2.start = override(skillatk2.start, AwakeBossFV.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, AwakeBossFV.skillatk2_onAttackFrame)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, AwakeBossFV.skillatk2_takeEffectAt)
    skillatk2.finish = override(skillatk2.finish, AwakeBossFV.skillatk2_finish)
  end
  if skillatk3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, AwakeBossFV.getLostHPAfterImmunity)
  end
  if skillatk4 then
  end
  if skillreturn then
    skillreturn.start = override(skillreturn.start, AwakeBossFV.return_start)
  end
  hero.reset = override(hero.reset, AwakeBossFV.reset)
  hero.update = override(hero.update, AwakeBossFV.update)
  hero.setHP = override(hero.setHP, AwakeBossFV.setHP)
  
  function hero.getShadowEffect(unit)
    local effect = "eff_point_FV_Shadow.cha"
    local fashionId = unit.fashion_id
    if fashionId and fashionId == AwakeBossFV.skillFashionId then
      effect = "eff_point_FV4_Shadow.cha"
    end
    return effect
  end
  
  return hero
end

return AwakeBossFV.init_hero
