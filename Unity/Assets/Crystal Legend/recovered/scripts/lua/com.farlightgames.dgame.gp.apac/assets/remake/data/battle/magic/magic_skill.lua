local MagicSkill = {}
MagicSkill.__index = MagicSkill
ed.MagicSkill = MagicSkill

function MagicSkill:display()
  return self.info.Description or self.info["Magic Name"]
end

function MagicSkill:launchPoint()
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

function MagicSkill.getSkillInfo(skill_id, level)
  local skill_info = ed.getDataTable("MultiArenaMagic")[skill_id]
  local buff_info = {}
  if skill_info["Buff ID"] > 0 then
    buff_info = ed.lookupDataTable("Buff", nil, skill_info["Buff ID"])
  end
  local skill_patch = {}
  local buff_patch = {}
  local index = 1
  while true do
    local field = skill_info["Growth " .. index .. " Field"]
    if field then
      local growth = (level - 1) * skill_info["Growth " .. index .. " Value"]
      if skill_info[field] then
        skill_patch[field] = skill_info[field] + growth
      elseif buff_info[field] then
        buff_patch[field] = buff_info[field] + growth
      end
      index = index + 1
    else
      break
    end
  end
  setmetatable(skill_patch, {__index = skill_info})
  skill_info = skill_patch
  if buff_info then
    setmetatable(buff_patch, {__index = buff_info})
    skill_info.buff_info = buff_patch
  end
  return skill_info
end

function MagicSkill.skillCreate(info, caster, pos)
  local self = {
    info = info,
    phase_list = {},
    max_range_sq = info["Max Range"] ^ 2,
    min_range_sq = (info["Min Range"] or 0) ^ 2,
    caster = caster,
    cd_remaining = info["Init CD"] or 0,
    result_gap = info["Result Gap"],
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
    what = "magicSkill",
    terminated = false,
    frozen_model = false
  }
  setmetatable(self, MagicSkill)
  if self.max_range_sq == 0 then
    self.max_range_sq = math.huge
  end
  local target_type = self.info["Target Type"]
  if target_type == "self" then
    self.info["Target Camp"] = 0
  elseif target_type == "target" then
    self.info["Target Camp"] = -1
  end
  ed.Skill.setSelectors(self)
  return self
end

ed.MagicSkillCreate = MagicSkill.skillCreate

function MagicSkill:start(target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  if self.info["Target Type"] == "self" then
    self:selectTarget(target)
  end
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  self.is_update = true
  self:OnAttackFrame()
end

function MagicSkill:update(dt)
  if self.isEffectAt then
    local result_gap = self.result_gap - dt
    if result_gap < 0 then
      if self.castHander then
        self.castHander()
        self.castHander = nil
      end
      self.isEffectAt = false
      self.terminated = true
    end
    self.result_gap = result_gap
  end
end

function MagicSkill:freeze()
  self.frozen_model = true
end

function MagicSkill:unfreeze()
  self.frozen_model = false
end

function MagicSkill:OnAttackFrame()
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  local info = self.info
  local ttype = info["Track Type"]
  self:createTrackType(ttype)
end

function MagicSkill:takeEffectAt(location)
  self.isEffectAt = true
  local info = self.info
  local aoe = self.info["AOE Origin"]
  local direction = self.caster.direction
  self.curSkillCount = 0
  if aoe == "self" then
    location = self.caster.position
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

function MagicSkill:takeEffectOn(target)
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
      if do_battle_log then
        btlog("%s: %s ++> %s (+%d)", self:display(), caster:display(), target:display(), power)
      end
      target:takeMagicHeal(power, affect_field)
    else
      if damage_type == "AD" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.DODG)
        local prob = dodg / (100 + dodg)
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          if do_battle_log then
            btlog("%s: %s --> %s (Miss!)", self:display(), caster:display(), target:display())
          end
          local color = target.camp == ed.emCampEnemy and "red" or "blue"
          if target.actor then
            ed.PopupCreate("dodge", color, target.actor, nil, "text")
          end
          return false
        end
      end
      if do_battle_log then
        btlog("%s: %s --> %s (-%d)", self:display(), caster:display(), target:display(), power)
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

function MagicSkill:createBuff(target)
  return ed.BuffCreate(self.info.buff_info, target, self.caster)
end

function MagicSkill:selectTarget(default)
  local target_type = self.info["Target Type"]
  local selector = ed.Skill.target_selector(self)
  local Ignore = ed.Skill.Ignore_Target_Type(self)
  if target_type == "target" then
    if default then
      self.target = default
    else
      local owner = self.caster
      local t, distanceSQ = ed.Ai:selectNearestTarget(owner)
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    for unit in ed.engine:foreachAliveUnit(self.caster.foecamp * self.info["Target Camp"] * -1) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
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

function MagicSkill:affectedCamp()
  if self.info["Affected Camp"] ~= -100 then
    return self.caster.foecamp * self.info["Affected Camp"] * -1
  end
  return ed.emCampBoth
end

function MagicSkill:getDamage(target, power, damage_type, field, crit_mod)
  local dmg, Crit = target:takeMagicDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg, Crit
end

function MagicSkill:power(target, damage_type)
  local info = self.info
  local multiplier = info["Plus Ratio"] or 0
  local power = multiplier + info["Basic Num"]
  local ratio1 = 0
  local ratio2 = 0
  if damage_type and damage_type ~= "Heal" then
    if target then
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.name == "ExtraDamageBuff_damaged" and tbuff.extraDamageValue then
          ratio1 = ratio1 + tbuff.extraDamageValue
        end
      end
    end
    if self.extraDamageRatio then
      ratio2 = ratio2 + self.extraDamageRatio
    end
    self.extraDamageRatio = ratio2
  end
  return power * (1 + ratio1 + ratio2), 1
end

function MagicSkill:createTrackType(ttype)
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

function MagicSkill:targetCamp()
  return self.caster.foecamp * self.info["Target Camp"] * -1
end

function MagicSkill.testPointInShape(p, shape, arg1, arg2)
  return ed.Skill.testPointInShape(p, shape, arg1, arg2)
end
