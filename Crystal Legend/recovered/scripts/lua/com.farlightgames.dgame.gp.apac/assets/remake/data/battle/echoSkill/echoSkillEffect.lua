local class = {}
ed.echoSkillEffect = class

function class.MagicCreate(info, caster)
  local self = {
    info = info,
    phase_list = {},
    max_range_sq = 640000,
    min_range_sq = 0,
    caster = caster,
    cd_remaining = 5,
    casting = false,
    target = nil,
    current_phase_idx = 0,
    current_phase = nil,
    current_phase_elapsed = 0,
    next_event_idx = 0,
    next_event = nil,
    attack_counter = 0,
    can_cast = false,
    can_cast_tick = -1,
    is_update = true,
    what = "magic",
    terminated = false,
    frozen_model = false,
    delay_execute = info["Effect Delay"]
  }
  setmetatable(self, {__index = class})
  ed.Skill.setSelectors(self)
  return self
end

function class.getEchoInfo(echoId)
  local skill_info = ed.getDataTable("EchoSkill")[echoId]
  local buff_info = {}
  if skill_info["Buff ID"] > 0 then
    buff_info = ed.lookupDataTable("Buff", nil, skill_info["Buff ID"])
  end
  local skill_patch = {}
  local buff_patch = {}
  setmetatable(skill_patch, {__index = skill_info})
  skill_info = skill_patch
  if buff_info then
    setmetatable(buff_patch, {__index = buff_info})
    skill_info.buff_info = buff_patch
  end
  return skill_info
end

function class:launchPoint()
  local event = {X = 0, Y = 75}
  local bone_position = {
    event.X * ed.cha_scale,
    event.Y * ed.cha_scale
  }
  local caster = self.caster
  local sx, sy = 0.75, 0.75
  local us = 0.8
  local pos = {
    caster.position[1] + bone_position[1] * sx * us,
    caster.position[2]
  }
  local h = bone_position[2] * sy * us
  return pos, h
end

function class:start()
  local info = self.info
  self.target = nil
  if self.info["Target Type"] == "self" then
    self:selectTarget()
  end
  self.cd_remaining = info.CD
  self.casting = true
  self.isExecute = false
  self.attack_counter = 0
  self.is_update = true
  self.terminated = false
  self.isEffectAt = false
  self.delay_execute = info["Effect Delay"]
end

function class:setEffectStartCallBack(callBack)
  self.effectStartCallBack = callBack
end

function class:setEffectEndCallBack(callBack)
  self.effectEndCallBack = callBack
end

function class:update(dt)
  if not self.isExecute then
    local delay_execute = self.delay_execute - dt
    if delay_execute <= 0 then
      self:OnAttackFrame()
      self.isExecute = true
      if self.effectStartCallBack then
        self.effectStartCallBack()
      end
    end
    self.delay_execute = delay_execute
  end
  if self.isEffectAt then
    if self.castHander then
      self.castHander()
      self.castHander = nil
      if self.effectEndCallBack then
        self.effectEndCallBack()
      end
    end
    self.isEffectAt = false
    self.terminated = true
  end
end

function class:freeze()
  self.frozen_model = true
end

function class:unfreeze()
  self.frozen_model = false
end

function class:OnAttackFrame()
  self.attack_counter = self.attack_counter + 1
  if self.target == nil or not self.target:isAlive() then
    self:selectTarget()
  end
  if not self.target then
    return
  end
  local ttype = self.info["Track Type"]
  self:createTrackType(ttype)
end

function class:takeEffectAt(location)
  self.isEffectAt = true
  local info = self.info
  local aoe = self.info["AOE Origin"]
  local affectedCamp = self.info["Affected Camp"]
  local effectPosition = self.info["Effect Position"]
  local direction = self.caster.direction
  self.curSkillCount = 0
  if effectPosition and 2 <= #effectPosition then
    location = effectPosition
  elseif aoe == "self" then
    location = {400, 0}
  end
  local origin = {
    location[1],
    location[2]
  }
  
  function self.castHander()
    if aoe then
      local list = ed.Skill.collectAoeTarget(self, origin, direction)
      for k, unit in ipairs(list) do
        self:takeEffectOn(unit)
      end
    else
      self:takeEffectOn(self.target)
    end
    self:takeParticleEffect()
  end
  
  local effect_name = info["Point Effect"]
  if not effect_name then
    return
  end
  local effect_z = info["Point Zorder"] or 0
  if ed.run_with_scene then
    local scale = {
      self.caster.direction,
      1
    }
    ed.scene:playEffectOnScene(effect_name, origin, FlipXVector(scale), nil, effect_z)
  end
end

function class:takeEffectOn(target)
  local caster = self.caster
  if not target:isAlive() or target.buff_effects.invulnerable or target.manually_casting and caster.camp ~= target.camp then
    return false
  end
  local info = self.info
  local damage_type = info["Damage Type"]
  local affect_field = info["Affect MP"] and "mp" or "hp"
  local dmg = 0
  local Crit
  if damage_type then
    local power, coefficient = self:power(target, damage_type)
    if damage_type == "Heal" then
      target:takeMagicHeal(power, affect_field)
    else
      if damage_type == "AD" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.DODG)
        local prob = dodg / (100 + dodg)
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          local color = target.camp == ed.emCampEnemy and "red" or "blue"
          if target.actor then
            ed.PopupCreate("dodge", color, target.actor, nil, "text")
          end
          return false
        end
      end
      dmg, Crit = self:getDamage(target, power, damage_type, affect_field, 1)
      if target.buffImpactEffect and target.actor then
        local name = target.buffImpactEffect.value.ImpactEffect
        local effect_z = target.buffImpactEffect.value.ImpactEffectZorder
        if self.isEffectAt then
          self.curSkillCount = self.curSkillCount + 1
          if self.curSkillCount <= ed.Skill.maxShowSkillCount then
            target.actor:addEffect(name, effect_z)
          end
        else
          target.actor:addEffect(name, effect_z)
        end
      end
    end
  end
  local buff_miss = false
  if target:isAlive() and 0 < info["Buff ID"] then
    local bSucess, reason = ed.Buff.checkAddBuff(info.buff_info, self.level, target, caster)
    if bSucess then
      local buff = self:createBuff(target)
      target:addBuff(buff)
    else
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local text = reason == "resist" and "resist" or "miss"
      if target.actor then
        ed.PopupCreate(text, color, target.actor, nil, "text")
      end
      buff_miss = true
    end
  end
  local name = info["Impact Effect"]
  if name and target.actor then
    local effect_z = info["Impact Zorder"]
    if self.isEffectAt then
      self.curSkillCount = self.curSkillCount + 1
      if self.curSkillCount <= ed.Skill.maxShowSkillCount then
        target.actor:addEffect(name, effect_z)
      end
    else
      target.actor:addEffect(name, effect_z)
    end
  end
  return true, dmg, Crit
end

function class:takeParticleEffect()
  if ed.run_with_scene then
    local particlePath = self.info.Plist
    if not particlePath then
      return
    end
    particlePath = "UI/particle/" .. particlePath
    local plistPos = self.info["Plist Position"]
    local particle = CCParticleSystemQuad:create(particlePath)
    ed.scene:addParticle(particle, 1)
    local pos = ed.toViewPosition(plistPos, 0)
    particle:setPosition(pos)
  end
end

function class:createBuff(target)
  return ed.BuffCreate(self.info.buff_info, target, self.caster)
end

function class:selectTarget()
  local target_type = self.info["Target Type"]
  local targetCamp = self.info["Target Camp"]
  local selector = ed.Skill.target_selector(self)
  if target_type == "BOSS" then
    for unit in ed.engine:foreachAliveUnit(targetCamp) do
      if unit.config.is_boss then
        self.target = unit
        break
      end
    end
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    for unit in ed.engine:foreachAliveUnit(targetCamp) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          local ignore
          for index, ignoreType in ipairs(self.info["Ignore Target Type"] or {}) do
            ignore = self.Ignore_Target_Types[ignoreType]
          end
          local shouldIgnore = ignore and ignore(unit)
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

function class:affectedCamp()
  if self.info["Affected Camp"] ~= -100 then
    return self.caster.foecamp * self.info["Affected Camp"] * -1
  end
  return ed.emCampBoth
end

function class:getDamage(target, power, damage_type, field, crit_mod)
  local dmg, Crit = target:takeMagicDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg, Crit
end

function class:power(target, damage_type)
  local info = self.info
  local multiplier = info["Plus Ratio"] or 0
  local power = multiplier + info["Basic Num"]
  local ratio1 = 0
  local ratio2 = 0
  return power * (1 + ratio1 + ratio2), 1
end

function class:createProjectile()
  return ed.ProjectileCreate(self)
end

function class:createTrackType(ttype)
  if ttype == "projectile" then
    local projectile = ed.ProjectileCreate(self)
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = ed.ChainCreate(self)
    ed.engine:addChain(chain)
  elseif ttype == "region" then
    local region = ed.RegionCreate(self)
    ed.engine:addRegion(region)
  elseif ttype == nil then
    self:takeEffectAt(self.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
end

function class:selectDamageCamp()
  if self.caster.buff_effects.fury then
    return ed.emCampBoth
  end
  if self.caster.config.summoner and self.caster.config.summoner.buff_effects.fury then
    return ed.emCampBoth
  end
  return self:affectedCamp()
end

function class:targetCamp()
  return self.caster.foecamp * self.info["Target Camp"] * -1
end

function class.testPointInShape(p, shape, arg1, arg2)
  return ed.Skill.testPointInShape(p, shape, arg1, arg2)
end
