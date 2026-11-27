local base = ed.Skill
local class = newclass(base.mt)
ed.SoloSkill = class

function class.create(info, caster, level)
  local self = {
    info = info,
    caster = caster,
    level = level,
    phase_list = {},
    what = "soloSkill",
    cd_remaining = 0,
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
    is_update = true
  }
  setmetatable(self, class.mt)
  local puppet_name = caster.info.Puppet
  self:rebuildPhaseList(puppet_name)
  local target_type = self.info["Target Type"]
  if target_type == "self" then
    self.info["Target Camp"] = 0
  elseif target_type == "target" then
    self.info["Target Camp"] = -1
  end
  self:setSelectors()
  return self
end

ed.SoloSkillCreate = class.create

function class:interrupt()
  if self.attack_counter == 0 then
    local info = self.info
    self.cd_remaining = info.CD * 0.5
  end
  if self.caster.actor and self.caster.actor.puppet then
    self.caster.actor.puppet:interruptSound()
  end
  self.caster.interRuptSkill = self
  self:finish("interrupt")
end

function class:selectTarget(default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default and default:isAlive() then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      self.target = t
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      local v = selector(unit)
      local shouldIgnore = Ignore(unit)
      if max < v and not shouldIgnore then
        max = v
        chosen = unit
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function class:canCastWithTarget(target)
  if self.can_cast_tick == ed.engine.ticks then
    return self.can_cast, "same tick"
  end
  self.can_cast_tick = ed.engine.ticks
  local info = self.info
  local caster = self.caster
  self.can_cast = false
  if info["Cost MP"] > caster.mp then
    return false, "mp"
  end
  if caster.buff_effects.stun then
    return false, "stun"
  end
  if #self.phase_list == 0 then
    return false, "pasvSkill"
  end
  if self ~= caster.basic_skill and (caster.buff_effects.silence or caster.buff_effects.silencebyself) then
    return false, "silence"
  end
  if self:target_selector() then
    target = self:selectTarget(target)
  end
  if not target then
    return false, "no target"
  end
  if not target:isAlive() then
    return false, "target is not alive"
  end
  if 0 > target.camp * self:targetCamp() then
    return false, "target camp"
  end
  self.can_cast = true
  return true
end

function class:start(target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  if self.caster.taunter and self.info["Target Type"] ~= "self" then
    if target then
      if target.camp ~= self:targetCamp() then
        self:selectTarget(target)
      else
      end
    else
      self:selectTarget(target)
    end
  else
    self:selectTarget(target)
  end
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  self:startPhase(1)
  self.is_update = true
  self.onAttackSlot1_triggered = false
  self.onAttackSlot5_triggered = false
  local caster = self.caster
  local CDR = math.min(caster.attribs.CDR, 50)
  caster:setMP(caster.mp - info["Cost MP"] * (1 - CDR / 100))
  ed.engine:collectSkillStart(self.caster, self, self.target)
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

local function getSoloSkillInfo(group, rank)
  local info = ed.lookupDataTable("SoloSkill", nil, group["Skill Group ID"], 0)
  local skill_info = {}
  skill_info.groupId = group["Skill Group ID"]
  for k, v in pairs(info) do
    skill_info[k] = v
  end
  setmetatable(skill_info, {__index = group})
  local buff_info
  if 0 < skill_info["Buff ID"] then
    buff_info = ed.lookupDataTable("Buff", nil, skill_info["Buff ID"])
  end
  local skill_patch = {}
  local buff_patch = {}
  local index = 1
  while true do
    local field = group["Chess Growth " .. index .. " Field"]
    if field then
      local growthValues = group["Chess Growth " .. index .. " Value"]
      local growth = growthValues[rank] or 0
      if skill_info[field] then
        skill_patch[field] = growth
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

class.getSoloSkillInfo = getSoloSkillInfo

function class:takeEffectAt(location, source)
  local info = self.info
  local direction = self.caster.direction
  self.curSkillCount = 0
  self.isEffectAt = true
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  self:takeEffectOn(self.target, source)
  if ed.run_with_scene then
    local effect_name = info["Point Effect"]
    if not effect_name then
      self.isEffectAt = false
      return
    end
    local effect_z = info["Point Zorder"] or 0
    ed.scene:playEffectOnScene(effect_name, origin, {
      self.caster.direction,
      1
    }, nil, effect_z)
  end
  self.isEffectAt = false
end

function class:onAttackFrame()
  self.attack_counter = self.attack_counter + 1
  if self.target == nil or not self.target:isAlive() then
    return
  end
  self:createTrackType(self.info["Track Type"])
  if self.info.Slot == 5 and not self.onAttackSlot5_triggered then
    for k, v in ipairs(self.caster.buff_list) do
      if v.onAttackSlot5 then
        v.onAttackSlot5(self)
      end
    end
    self.onAttackSlot5_triggered = true
  elseif self.info.Slot == 1 and not self.onAttackSlot1_triggered then
    for k, v in ipairs(self.caster.buff_list) do
      if v.onAttackSlot1 then
        v.onAttackSlot1(self)
      end
    end
    self.onAttackSlot1_triggered = true
  end
end

function class:createProjectile()
  return ed.SoloProjectileCreate(self)
end

function class:getDamage(target, power, damage_type, field, source, crit_mod)
  local dmg, Crit = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self,
    soloParams = {
      type = 2,
      id = self.info.Slot
    }
  })
  return dmg, Crit
end

function class:power(source, target, damage_type)
  local caster = self.caster
  local info = self.info
  local multiplier1 = info["Plus1 Ratio"]
  local base_attrib1 = info["Plus1 Attr"] and self.caster.attribs[info["Plus1 Attr"]] or 0
  local multiplier2 = info["Plus2 Ratio"]
  local base_attrib2 = info["Plus2 Attr"] and self.caster.attribs[info["Plus2 Attr"]] or 0
  local power = multiplier1 * base_attrib1 + multiplier2 * base_attrib2 + info["Basic Num"]
  if damage_type and info.Slot == 1 and caster.attribs.UltRatio and 0 < caster.attribs.UltRatio then
    power = power * (1 + caster.attribs.UltRatio / 100)
  end
  return power, 1
end

function class:onEffectAddBuff(target)
  local buff_miss = false
  if target:isAlive() and (not target.unitonDying or target == self.caster) and self.info["Buff ID"] > 0 then
    local bSucess, reason = ed.Buff.checkAddBuff(self.info.buff_info, self.level, target, self.caster)
    if bSucess then
      target:addBuff(self:createBuff(target))
    else
      local text = reason == "resist" and "resist" or "miss"
      if target.actor then
        ed.PopupCreate(text, "blue", target.actor, nil, "text")
      end
    end
  end
end

function class:takeEffectOn(target, source)
  if not target:isAlive() then
    return false
  end
  local damageType = self.info["Damage Type"]
  local dmg = 0
  local Crit
  if damageType then
    source = source or self.caster
    local affectfield = self.info["Affect MP"] and "mp" or "hp"
    local power = self:power(source, target, damageType)
    if damageType == "Heal" then
      target:takeHeal(power, affectfield, self.caster, nil, {
        type = 2,
        id = self.info.Slot
      })
    else
      dmg, Crit = self:getDamage(target, power, damageType, affectfield, self.caster, self.info["CRIT%"] / 100)
      if dmg == 0 then
        return false
      end
    end
  end
  local name = self.info["Impact Effect"]
  if name and target.actor then
    local effect_z = self.info["Impact Zorder"]
    if self.isEffectAt then
      self.curSkillCount = self.curSkillCount + 1
      if self.curSkillCount <= 4 then
        target.actor:addEffect(name, effect_z)
      end
    else
      target.actor:addEffect(name, effect_z)
    end
  end
  self:onEffectAddBuff(target)
  return true, dmg, Crit
end
