module("ed.battlehero", package.seeall)
local ed = ed
GuildMountFV = {}
GuildMountFV.name = "GuildMountFV"
GuildMountFV.ult_lock = 12005001
GuildMountFV.ult_time = 12005002
GuildMountFV.auraID = "GuildMountFVult_timezone"
GuildMountFV.zoneFg = "eff_tile_FV_timezone.cha"
GuildMountFV.zoneBg = "eff_tile_FV_timezone_far.cha"
GuildMountFV.skillultbRatioList = {
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
GuildMountFV.skillultbKnockUpList = {
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
GuildMountFV.skillultbKnockBackList = {
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
GuildMountFV.skillultbMoveForwardList = {
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
GuildMountFV.skillultbCameraShakeHList = {
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
GuildMountFV.skillultbAOEOriginList = {
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
GuildMountFV.skillultbAOEShapeList = {
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
GuildMountFV.skillultbShapeArg1List = {
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
GuildMountFV.skillultbXShiftList = {
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
GuildMountFV.IEb = "eff_impact_FV_atkb.cha"
GuildMountFV.IEc1 = "eff_impact_FV_atkc1.cha"
GuildMountFV.IEc2 = "eff_impact_FV_atkc2.cha"
GuildMountFV.IEc3 = "eff_impact_FV_atkc3.cha"
GuildMountFV.ImpactEffectList = {
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEb,
  GuildMountFV.IEc1,
  GuildMountFV.IEc2,
  GuildMountFV.IEc3
}
GuildMountFV.skillultbBuffIDList = {
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
GuildMountFV.blink_distance = 120
GuildMountFV.skillFashionId = 771
GuildMountFV.evoSkillTicks = 24
GuildMountFV.evonSkillHealEffect = "eff_point_FV_fashion.cha"

function GuildMountFV.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  skill.AttackPosition = GuildMountFV.DOP_in_battlefield(caster, 220, caster.foecamp)
  if skill.AttackPosition[1] < 200 then
    skill.AttackPosition[1] = 200
  elseif skill.AttackPosition[1] > 600 then
    skill.AttackPosition[1] = 600
  else
    skill.AttackPosition[1] = skill.AttackPosition[1] - caster.direction * 20
  end
  caster.GuildMountFVultOriPos = {
    caster.position[1],
    caster.position[2]
  }
  caster:setPosition(skill.AttackPosition)
  if caster.name == "GuildMountFV" then
    caster.skills[GuildMountFV.name .. "_return"].cd_remaining = 999
  end
end

function GuildMountFV.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.GuildMountFV_ult
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
      local bid = GuildMountFV.ult_time
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      local bufftimer = skillult.info["Script Arg2"]
      buff.timer = bufftimer
      if buff then
        buff.onRemoved = override(buff.onRemoved, GuildMountFV.skillultbuff_onRemoved)
        buff.update = override(buff.update, GuildMountFV.skillultbuff_update)
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
      if ed.run_with_scene and ed.scene and ed.scene.enterGuildMountFVTimeZone then
        ed.scene:enterGuildMountFVTimeZone()
      end
      if caster.name == "GuildMountFV" then
        caster.skills[GuildMountFV.name .. "_ultb"].cd_remaining = 0
        caster.global_cd = 0
      end
    end
  end
end

function GuildMountFV.skillultbuff_update(basefunc, buff, dt)
  local caster = buff.caster
  local skillult = caster.skills.GuildMountFV_ult
  skillult:takeEffectAt(skillult.AttackPosition, caster)
  basefunc(buff, dt)
end

function GuildMountFV.skillultbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  if buff.effectult1 then
    buff.effectult1:setVisible(false)
  end
  if buff.effectult2 then
    buff.effectult2:setVisible(false)
  end
  if ed.run_with_scene and ed.scene and ed.scene.exitGuildMountFVTimeZone then
    ed.scene:exitGuildMountFVTimeZone()
  end
  if ed.run_with_scene and ed.scene and ed.scene.ClearGuildMountFVTimeZone then
    ed.scene:ClearGuildMountFVTimeZone()
  end
  caster.walk_speed_multiplier = caster.Ori_walk_speed_multiplier_GuildMountFV
  basefunc(buff)
end

function GuildMountFV.skillult_takeEffectOn(basefunc, skill, target, source)
  if target.ImmuneTimeZone then
    return
  end
  basefunc(skill, target, source)
end

function GuildMountFV.DOP_in_battlefield(caster, radius, camp)
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

function GuildMountFV.skillultb_onAttackFrame(basefunc, skill)
  local info = skill.info
  info["Plus Ratio"] = GuildMountFV.skillultbRatioList[skill.attack_counter + 1]
  info["Knock Up"] = GuildMountFV.skillultbKnockUpList[skill.attack_counter + 1]
  info["Knock Back"] = GuildMountFV.skillultbKnockBackList[skill.attack_counter + 1]
  info["Move Forward"] = GuildMountFV.skillultbMoveForwardList[skill.attack_counter + 1]
  info["AOE Origin"] = GuildMountFV.skillultbAOEOriginList[skill.attack_counter + 1]
  info["AOE Shape"] = GuildMountFV.skillultbAOEShapeList[skill.attack_counter + 1]
  info["Shape Arg1"] = GuildMountFV.skillultbShapeArg1List[skill.attack_counter + 1]
  info["X Shift"] = GuildMountFV.skillultbXShiftList[skill.attack_counter + 1]
  info["Impact Effect"] = GuildMountFV.ImpactEffectList[skill.attack_counter + 1]
  local bid = GuildMountFV.skillultbBuffIDList[skill.attack_counter + 1]
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
  if ed.run_with_scene and GuildMountFV.skillultbCameraShakeHList[skill.attack_counter] ~= nil and 0 < GuildMountFV.skillultbCameraShakeHList[skill.attack_counter] then
    ed.scene:startCameraShakeAnimationY(GuildMountFV.skillultbCameraShakeHList[skill.attack_counter], 0.1, 3)
  end
end

function GuildMountFV.skillultb_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  if unit:isAlive() then
    if unit.name == "GuildMountFV" then
      unit.skills[GuildMountFV.name .. "_return"].cd_remaining = 0
    else
      local caster = skill.caster
      if caster.name == "Rubick" and caster.GuildMountFVultOriPos then
        caster:setPosition(caster.GuildMountFVultOriPos)
        caster.GuildMountFVultOriPos = nil
      end
    end
  end
end

function GuildMountFV.return_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.GuildMountFVultOriPos then
    local nextDirection = caster.GuildMountFVultOriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.GuildMountFVultOriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.GuildMountFVultOriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    caster.direction = nextDirection
    caster.position = caster.GuildMountFVultOriPos
    caster.GuildMountFVultOriPos = nil
  elseif caster.GuildMountFVatk2OriPos then
    local nextDirection = caster.GuildMountFVatk2OriPos[1] < caster.position[1] and 1 or -1
    if ed.run_with_scene then
      local effect_name = caster:getShadowEffect()
      if not effect_name then
        return
      end
      local effect_z = 0
      ed.scene:playEffectOnScene(effect_name, caster.position, {nextDirection, 1}, nil, effect_z)
      local n = 3
      for i = 1, n do
        local x = caster.GuildMountFVatk2OriPos[1] * i / (n + 1) + caster.position[1] * (n + 1 - i) / (n + 1)
        local y = caster.GuildMountFVatk2OriPos[2] * i / (n + 1) + caster.position[2] * (n + 1 - i) / (n + 1)
        ed.scene:playEffectOnScene(effect_name, {x, y}, {nextDirection, 1}, nil, effect_z)
      end
    end
    caster.direction = nextDirection
    caster.position = caster.GuildMountFVatk2OriPos
    caster.GuildMountFVatk2OriPos = nil
  end
end

function GuildMountFV.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk4 = unit.skills[GuildMountFV.name .. "_atk4"]
  if skillatk4 then
    local Rate = skillatk4.info["Script Arg2"] / 100
    if ret and skillatk4 and target == skill.target and Rate >= ed.rand() then
      skillatk4:takeEffectAt(target.position, source)
    end
  end
  return ret, dmg
end

function GuildMountFV.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk4 = unit.skills[GuildMountFV.name .. "_atk4"]
  if skillatk4 then
    local Rate = skillatk4.info["Script Arg2"] / 100
    if ret and skillatk4 and target == skill.target and Rate >= ed.rand() then
      skillatk4:takeEffectAt(target.position, source)
    end
  end
  return ret, dmg
end

function GuildMountFV.skillatk2_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local ret = basefunc(skill, default)
  if ret then
    skill.GuildMountFVTargetPos = {
      ret.position[1],
      ret.position[2]
    }
  end
  return ret
end

function GuildMountFV.skillatk2_onAttackFrame(basefunc, self)
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

function GuildMountFV.skillatk2_start(basefunc, skill, target)
  local info = skill.info
  skill:selectTarget()
  skill.starttarget = skill.target
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  skill.is_update = true
  local caster = skill.caster
  caster.GuildMountFVatk2OriPos = nil
  local direction = caster.direction
  local distanceSQ
  if skill.target then
    distanceSQ = (skill.target.position[1] - caster.position[1]) ^ 2 + (skill.target.position[2] - skill.target.position[2]) ^ 2
  end
  if distanceSQ and 24025 < distanceSQ then
    caster.GuildMountFVatk2OriPos = caster.position
    if skill.GuildMountFVTargetPos then
      local postionX = skill.GuildMountFVTargetPos[1] - direction * GuildMountFV.blink_distance
      if postionX <= 0 then
        postionX = skill.GuildMountFVTargetPos[1] + GuildMountFV.blink_distance
      elseif 800 <= postionX then
        postionX = skill.GuildMountFVTargetPos[1] - GuildMountFV.blink_distance
      end
      caster.position = {
        postionX,
        skill.GuildMountFVTargetPos[2]
      }
      if ed.run_with_scene then
        local effect_name = caster:getShadowEffect()
        if not effect_name then
          return
        end
        local effect_z = 0
        ed.scene:playEffectOnScene(effect_name, caster.GuildMountFVatk2OriPos, {
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

function GuildMountFV.skillatk2_takeEffectAt(basefunc, skill, location, source)
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

function GuildMountFV.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.name == "GuildMountFV" and caster.GuildMountFVatk2OriPos then
    caster.skills[GuildMountFV.name .. "_return"].cd_remaining = 0
    caster.global_cd = 0
  end
end

function GuildMountFV.getLostHPAfterImmunity(basefunc, unit, damage, immunity)
  local lostHP = basefunc(unit, damage, immunity)
  local skillatk3 = unit.skills[GuildMountFV.name .. "_atk3"]
  local skillinfo = skillatk3.info
  local DodgeRate = skillinfo["Script Arg2"] / 100
  local Dodge = DodgeRate > ed.rand()
  if Dodge then
    local dodgeDamage = skillinfo["Script Arg3"]
    lostHP = math.max(0, lostHP - dodgeDamage)
    local name = skillinfo["Impact Effect"]
    local fashionId = unit.fashion_id
    if fashionId and fashionId == GuildMountFV.skillFashionId then
      name = "eff_impact_FV4_atk3.cha"
    end
    if name and unit.actor then
      local effect_z = skillinfo["Impact Zorder"]
      unit.actor:addEffect(name, effect_z)
    end
  end
  return lostHP
end

function GuildMountFV.reset(basefunc, unit)
  basefunc(unit)
  unit.Ori_walk_speed_multiplier_GuildMountFV = unit.walk_speed_multiplier
  local skillult = unit.skills[GuildMountFV.name .. "_ult"]
end

function GuildMountFV.setHP(basefunc, unit, hp, reason)
  local perviousHp = unit.hp
  basefunc(unit, hp, reason)
  local newHp = unit.hp
  local skillult = unit.skills[GuildMountFV.name .. "_ult"]
end

function GuildMountFV.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local skillult = unit.skills[GuildMountFV.name .. "_ult"]
end

function GuildMountFV.init_hero(hero)
  if hero.name ~= "Rubick" then
    hero.ImmuneTimeZone = true
  end
  local skillult = hero.skills[GuildMountFV.name .. "_ult"]
  local skillultb = hero.skills[GuildMountFV.name .. "_ultb"]
  local skillatk = hero.skills[GuildMountFV.name .. "_atk"]
  local skillatk2 = hero.skills[GuildMountFV.name .. "_atk2"]
  local skillatk3 = hero.skills[GuildMountFV.name .. "_atk3"]
  local skillatk4 = hero.skills[GuildMountFV.name .. "_atk4"]
  local skillreturn = hero.skills[GuildMountFV.name .. "_return"]
  if skillult then
    hero.DoneRadius = skillult.info["Shape Arg1"]
    skillult.start = override(skillult.start, GuildMountFV.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GuildMountFV.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, GuildMountFV.skillult_takeEffectOn)
  end
  if skillultb then
    skillultb.info["No Dodge"] = true
    skillultb.onAttackFrame = override(skillultb.onAttackFrame, GuildMountFV.skillultb_onAttackFrame)
    skillultb.finish = override(skillultb.finish, GuildMountFV.skillultb_finish)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, GuildMountFV.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GuildMountFV.skillatk2_takeEffectOn)
    skillatk2.selectTarget = override(skillatk2.selectTarget, GuildMountFV.skillatk2_selectTarget)
    skillatk2.start = override(skillatk2.start, GuildMountFV.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, GuildMountFV.skillatk2_onAttackFrame)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, GuildMountFV.skillatk2_takeEffectAt)
    skillatk2.finish = override(skillatk2.finish, GuildMountFV.skillatk2_finish)
  end
  if skillatk3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GuildMountFV.getLostHPAfterImmunity)
  end
  if skillatk4 then
  end
  if skillreturn then
    skillreturn.start = override(skillreturn.start, GuildMountFV.return_start)
  end
  hero.reset = override(hero.reset, GuildMountFV.reset)
  hero.update = override(hero.update, GuildMountFV.update)
  hero.setHP = override(hero.setHP, GuildMountFV.setHP)
  
  function hero.getShadowEffect(unit)
    local effect = "eff_point_FV_Shadow.cha"
    local fashionId = unit.fashion_id
    if fashionId and fashionId == GuildMountFV.skillFashionId then
      effect = "eff_point_FV4_Shadow.cha"
    end
    return effect
  end
  
  return hero
end

return GuildMountFV.init_hero
