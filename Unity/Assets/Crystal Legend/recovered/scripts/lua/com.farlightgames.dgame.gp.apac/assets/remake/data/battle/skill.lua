local ed = ed
local string = string
local math = math
local class = {
  mt = {}
}
ed.Skill = class
class.mt.__index = class
class.maxShowSkillCount = 6

local function getSkillInfo(group, level)
  local info = ed.lookupDataTable("Skill", nil, group["Skill Group ID"], 0)
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
    local field = group["Growth " .. index .. " Field"]
    if field then
      local growth = (level - 1) * group["Growth " .. index .. " Value"]
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
  index = 1
  while true do
    local field = group["Awake Growth " .. index .. " Field"]
    if field then
      local growth = (level - 1) * group["Awake Growth " .. index .. " Value"]
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

class.getSkillInfo = getSkillInfo

local function getChessSkillInfo(group, rank)
  local info = ed.lookupDataTable("ChessSkill", nil, group["Skill Group ID"], 0)
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

class.getChessSkillInfo = getChessSkillInfo

local function checAurakHeroTag(info, unit)
  if not unit or not info then
    return false
  end
  local affectHeroTag = info["Aura Affect Hero Tag"]
  if not affectHeroTag then
    return true
  end
  if ed.isElementInTable(affectHeroTag, ed.getHeroTags(unit.proto)) then
    return true
  end
  return false
end

class.checAurakHeroTag = checAurakHeroTag

local function checkAuraValid(info, owner, target)
  if not (owner and info) or not target then
    return false
  end
  if info["Ignore Target Type"] == "self" and owner == target then
    return false
  end
  return true
end

class.checkAuraValid = checkAuraValid

local function SkillCreate(info, caster, level)
  local self = {
    info = info,
    caster = caster,
    level = level,
    evo_rank = 0,
    evo_rank1 = {},
    evo_rank2 = {},
    evo_rank3 = {},
    phase_list = {},
    max_range_sq = info["Max Range"] ^ 2,
    min_range_sq = info["Min Range"] ^ 2,
    cd_remaining = info["Init CD"] or 0,
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
  if self.max_range_sq == 0 then
    self.max_range_sq = math.huge
  end
  local puppet_name = caster.info.Puppet
  self:rebuildPhaseList(puppet_name)
  local target_type = self.info["Target Type"]
  if target_type == "self" then
    self.info["Target Camp"] = 0
  elseif target_type == "target" then
    self.info["Target Camp"] = -1
  end
  if ed.getDataTable("SkillEvo")[info["Skill Group ID"]] then
    for rank = 1, 3 do
      self["evo_rank" .. rank] = ed.getDataTable("SkillEvo")[info["Skill Group ID"]][rank] or {}
      if level >= (self["evo_rank" .. rank]["EvoSkill UnlockLevel"] or 999) then
        self.evo_rank = rank
      end
    end
  end
  self:setSelectors()
  return self
end

class.create = SkillCreate
ed.SkillCreate = SkillCreate

function class:setSelectors()
  self.target_selectors = {
    random = ed.rand,
    weakest = function(unit)
      return -unit.hp / unit.attribs.HP
    end,
    strongest = function(unit)
      return unit.hp / unit.attribs.HP
    end,
    nearest = function(unit)
      return -ed.edpDistanceSQ(unit.position, self.caster.position)
    end,
    nearestnotcaster = function(unit)
      if unit == self.caster then
        return -math.huge
      else
        return -ed.edpDistanceSQ(unit.position, self.caster.position)
      end
    end,
    farthest = function(unit)
      return ed.edpDistanceSQ(unit.position, self.caster.position)
    end,
    maxmp = function(unit)
      return unit.mp
    end,
    smaxmphero = function(unit)
      if unit.config.is_summoned then
        return -1
      elseif unit.info["Unit Type"] ~= "Hero" then
        return -2
      else
        return unit.mp
      end
    end,
    minmp = function(unit)
      return -unit.mp
    end,
    maxmpnotfull = function(unit)
      return math.max(unit.mp, 1) % 1000
    end,
    maxint = function(unit)
      return unit.attribs.INT
    end,
    maxagi = function(unit)
      return unit.attribs.AGI
    end,
    maxstr = function(unit)
      return unit.attribs.STR
    end,
    minhp = function(unit)
      return -unit.hp
    end,
    maxhp = function(unit)
      return unit.hp
    end,
    maxad = function(unit)
      return unit.attribs.AD
    end,
    maxap = function(unit)
      return unit.attribs.AP
    end,
    maxatk = function(unit)
      return math.max(unit.attribs.AP, unit.attribs.AD * 2)
    end,
    minad = function(unit)
      return -unit.attribs.AD
    end,
    minap = function(unit)
      return -unit.attribs.AP
    end,
    minint = function(unit)
      return -unit.attribs.INT
    end,
    minagi = function(unit)
      return -unit.attribs.AGI
    end,
    minstr = function(unit)
      return -unit.attribs.STR
    end,
    minarm = function(unit)
      return -unit.attribs.ARM
    end,
    maxarm = function(unit)
      return unit.attribs.ARM
    end,
    maxadinscreen = function(unit)
      if unit.position[1] < 0 or unit.position[1] > 800 then
        return -1
      else
        return unit.attribs.AD
      end
    end,
    maxatkinscreen = function(unit)
      if unit.position[1] < 0 or unit.position[1] > 800 then
        return -1
      else
        return math.max(unit.attribs.AP, unit.attribs.AD * 2)
      end
    end,
    maxhpinscreen = function(unit)
      if unit.position[1] < 0 or unit.position[1] > 800 then
        return -1
      else
        return unit.hp
      end
    end,
    maxintinscreen = function(unit)
      if unit.position[1] < 0 or unit.position[1] > 800 then
        return -1
      else
        return unit.attribs.INT
      end
    end,
    minstrinscreen = function(unit)
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
        return -math.huge
      else
        return -unit.attribs.STR
      end
    end,
    minagiinscreen = function(unit)
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX then
        return -math.huge
      else
        return -unit.attribs.AGI
      end
    end,
    minhpinscreen = function(unit)
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX or unit.position[2] < ed.engine.stage_rect.minY or unit.position[2] > ed.engine.stage_rect.maxY then
        return -math.huge
      else
        return -unit.hp
      end
    end,
    randominscreen = function(unit)
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX or unit.position[2] < ed.engine.stage_rect.minY or unit.position[2] > ed.engine.stage_rect.maxY then
        return -math.huge
      else
        return ed.rand()
      end
    end,
    smaxmpheroinscreen = function(unit)
      if unit.position[1] < 0 or unit.position[1] > 800 or unit.config.is_summoned then
        return -1
      elseif unit.info["Unit Type"] ~= "Hero" then
        return -2
      else
        return unit.mp
      end
    end,
    farthestinscreen = function(unit)
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX or unit.position[2] < ed.engine.stage_rect.minY or unit.position[2] > ed.engine.stage_rect.maxY then
        return -math.huge
      else
        return ed.edpDistanceSQ(unit.position, self.caster.position)
      end
    end,
    maxdmg = function(unit)
      return unit.battledata.damage
    end,
    nearestinscreen = function(unit)
      if unit.position[1] < ed.engine.stage_rect.minX or unit.position[1] > ed.engine.stage_rect.maxX or unit.position[2] < ed.engine.stage_rect.minY or unit.position[2] > ed.engine.stage_rect.maxY then
        return -math.huge
      else
        return -ed.edpDistanceSQ(unit.position, self.caster.position)
      end
    end,
    fishman = function(unit)
      if ed.isElementInTable(unit.tid, {14, 10012}) then
        return unit.tid
      else
        return -1
      end
    end
  }
  self.Ignore_Target_Types = {
    summon = function(unit)
      return unit.config.is_summoned
    end,
    noType = function(unit)
      return false
    end,
    uncontrollbale = function(unit)
      return unit.buff_effects.uncontrollable
    end,
    uncontrollbalesummon = function(unit)
      return unit.buff_effects.uncontrollable or unit.config.is_summoned
    end,
    self = function(unit)
      return unit == self.caster
    end,
    building = function(unit)
      return unit.buff_effects.building
    end
  }
  return self
end

class.create = SkillCreate
ed.SkillCreate = SkillCreate

local function display(self)
  return self.info["Display Name"] or self.info["Skill Name"]
end

class.display = display

local function rebuildPhaseList(self, puppet)
  self.phase_list = {}
  local anim_name_list = self.info["Action(s)"]
  for i = 1, #anim_name_list do
    local anim_name = anim_name_list[i]
    local resourceName = ed.lookupDataTable("Puppet", "Resource", puppet)
    if nil == resourceName then
      print("nil resourceName in table Puppet puppet -> " .. puppet)
    end
    local events, duration
    local isSpine = string.match(resourceName, "%.sp$")
    if isSpine then
      events = ed.lookupDataTable("AnimAtkFrameSp", nil, resourceName, anim_name)
    else
      resourceName = resourceName .. ".cha"
      events = ed.lookupDataTable("AnimAtkFrame", nil, resourceName, anim_name)
    end
    duration = ed.lookupDataTable("AnimDuration", "Duration", resourceName, anim_name)
    if events then
      local event_list = {}
      for k, v in pairs(events) do
        table.insert(event_list, v)
        v.Type = "Attack"
      end
      table.sort(event_list, function(a, b)
        return a.Time < b.Time
      end)
      local phase = {
        action_name = anim_name,
        duration = duration,
        event_list = event_list
      }
      table.insert(self.phase_list, phase)
    end
  end
end

class.rebuildPhaseList = rebuildPhaseList

local function getDurationFromAttackFrameToEnd(self, phase, event)
  local isRet = false
  local time
  if phase and event then
    local duration = phase.duration
    local eventTime = event.Time
    time = duration - eventTime
    isRet = true
  end
  return isRet, time
end

class.getDurationFromAttackFrameToEnd = getDurationFromAttackFrameToEnd

local function target_selector(self)
  return self.target_selectors[self.info["Target Type"]]
end

class.target_selector = target_selector

local function Ignore_Target_Type(self)
  if self.info["Ignore Target Type"] then
    return self.Ignore_Target_Types[self.info["Ignore Target Type"]]
  else
    return self.Ignore_Target_Types.noType
  end
end

class.Ignore_Target_Type = Ignore_Target_Type

local function affectedCamp(self)
  if self.info["Affected Camp"] == -100 or self.caster.buff_effects.fury or self.caster.config.summoner and self.caster.config.summoner.buff_effects.fury then
    return ed.emCampBoth
  else
    return self.caster.foecamp * self.info["Affected Camp"] * -1
  end
end

class.affectedCamp = affectedCamp

function class:selectDamageCamp()
  if self.caster.buff_effects.fury then
    return ed.emCampBoth
  end
  if self.caster.config.summoner and self.caster.config.summoner.buff_effects.fury then
    return ed.emCampBoth
  end
  return self:affectedCamp()
end

local function targetCamp(self)
  return self.caster.foecamp * self.info["Target Camp"] * -1
end

class.targetCamp = targetCamp

local function reset(self)
  self.cd_remaining = self.info["Init CD"] or 0
  self.casting = false
  self.target = nil
  self.current_phase_idx = 0
  self.current_phase = nil
  self.current_phase_elapsed = 0
  self.next_event_idx = 0
  self.next_event = nil
  self.attack_counter = 0
  self.extraDamageRatio = nil
end

class.reset = reset

local function pause(self)
  self.is_update = false
end

class.pause = pause

local function resume(self)
  self.is_update = true
end

class.resume = resume

local function update(self, dt_action, dt_cd)
  if self.casting and self == self.caster.current_skill then
    local time = self.current_phase_elapsed + dt_action
    self.current_phase_elapsed = time
    local next_event = self.next_event
    while next_event and time > next_event.Time do
      if next_event.Type == "Attack" then
        self:onAttackFrame()
        ed.engine:collectSkill(self.caster, self, self.attack_counter)
      end
      if self.casting then
        local idx = self.next_event_idx + 1
        next_event = self.current_phase.event_list[idx]
        self.next_event_idx = idx
        self.next_event = next_event
      else
        break
      end
    end
  else
    self.cd_remaining = self.cd_remaining - dt_cd
  end
end

class.update = update

local function gotoEventIdx(self, idx)
  local event = self.current_phase.event_list[idx]
  self.next_event_idx = idx + 1
  self.next_event = self.current_phase.event_list[idx + 1]
  self.current_phase_elapsed = event.Time
  local actor = self.caster.actor
  self.caster.action_elapsed = self.current_phase_elapsed
  if actor then
    actor.puppet:setActionElapsed(self.current_phase_elapsed)
  end
end

class.gotoEventIdx = gotoEventIdx

local function canCastWithTarget(self, target)
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
  if not self.is_update then
    return false, "is_update = false"
  end
  if self.cd_remaining > 0 then
    return false, "cd"
  end
  if caster.buff_effects.stun then
    return false, "stun"
  end
  if caster.buff_effects.stunbyself then
    return false, "stunbyself"
  end
  if self.info["Damage Type"] == "AD" and caster.buff_effects.disarm then
    return false, "disarm"
  end
  if self.info["Damage Type"] ~= "AD" and (caster.buff_effects.silence or caster.buff_effects.silencebyself) then
    return false, "silence"
  end
  if self ~= caster.basic_skill and caster.buff_effects.doom then
    return false, "doom"
  end
  if self == caster.manual_skill and caster.buff_effects.unmanual then
    return false, "unmanual"
  end
  if self == caster.manual_skill and caster.manually_casting then
    return false, "manually_casting"
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
  if target.buff_effects.untargetable then
    return false, "untargetable"
  end
  if target.buffManager.invisible and target.camp ~= caster.camp then
    return false, "invisible"
  end
  if 0 > target.camp * self:targetCamp() then
    return false, "target camp"
  end
  local distanceSQ = ed.edpDistanceSQ(target.position, self.caster.position)
  if distanceSQ > self.max_range_sq then
    return false, "too far"
  end
  if distanceSQ < self.min_range_sq then
    return false, "too near"
  end
  if not info["Outside Screen"] and caster:isOutOfStage() then
    return false, "outside stage"
  end
  local sid = self.info["Skill Group ID"]
  if caster.skillConditon and caster.skillConditon[sid] and (not caster.energy_ball_manager or not caster.energy_ball_manager:canCastSkill(self)) then
    return false, "ball not match"
  end
  if battle_tick.getRealTimePvp() and ed.engine.freeze_camp and caster.camp ~= ed.engine.freeze_camp then
    return false, "freeze camp"
  end
  self.can_cast = true
  return true
end

class.canCastWithTarget = canCastWithTarget

local function willCast(self)
  return true
end

class.willCast = willCast

local function canTrigger(self)
  return false
end

class.canTrigger = canTrigger

local function start(self, target)
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
  local caster = self.caster
  caster.global_cd = info["Global CD"]
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

class.start = start

local function selectTarget(self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default and default:isAlive() then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        if t and t.camp ~= self:targetCamp() then
          self.target = nil
        else
          self.target = t
        end
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
    local enchantedbyself = caster.buff_effects.enchantedbyself
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif enchantedbyself and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
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

class.selectTarget = selectTarget

local function selectTargetForCheck(self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  local target
  if target_type == "target" then
    if default and default:isAlive() then
      target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        target = t
      else
        target = nil
      end
    end
  elseif target_type == "self" then
    target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    local enchantedbyself = caster.buff_effects.enchantedbyself
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      elseif enchantedbyself and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
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
    target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return target
end

class.selectTargetForCheck = selectTargetForCheck

local function finish(self, reason)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.extraDamageRatio = nil
  self.casting = false
  self.caster.current_skill = nil
  self.caster:idle()
end

class.finish = finish

local function interrupt(self)
  if self.attack_counter == 0 then
    local info = self.info
    self.cd_remaining = info.CD * 0.5
    self.caster.global_cd = info["Global CD"] * 0.5
  end
  if self.caster.actor and self.caster.actor.puppet then
    self.caster.actor.puppet:interruptSound()
  end
  self.caster.interRuptSkill = self
  self:finish("interrupt")
end

class.interrupt = interrupt

local function startPhase(self, idx)
  local phase = self.phase_list[idx]
  self.current_phase_idx = idx
  self.current_phase = phase
  if phase == nil then
    p(self.caster.name)
  end
  self.current_phase_elapsed = 0
  self.next_event_idx = 1
  if phase then
    self.next_event = phase.event_list[1]
    self.caster:setAction(phase.action_name, false, true)
  end
end

class.startPhase = startPhase

local function onAttackFrame(self)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  local info = self.info
  local caster = self.caster
  local ttype = info["Track Type"]
  local MPGR = caster.attribs.MPGainRatio or 0
  self:createTrackType(ttype)
  if MPGR then
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    local stage_rect = ed.engine.stage_rect
    if caster.position[1] > stage_rect.maxX - 20 then
      caster.position[1] = stage_rect.maxX - 20
    elseif caster.position[1] < stage_rect.minX + 20 then
      caster.position[1] = stage_rect.minX + 20
    end
  end
end

class.onAttackFrame = onAttackFrame

function class:createTrackType(ttype)
  if ttype == "projectile" then
    local projectile = self:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = self:createChain()
    ed.engine:addChain(chain)
  elseif ttype == "region" then
    local region = self:createRegion()
    ed.engine:addRegion(region)
  elseif ttype == nil then
    self:takeEffectAt(self.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
end

local function createProjectile(self)
  return ed.ProjectileCreate(self)
end

class.createProjectile = createProjectile

local function createChain(self)
  return ed.ChainCreate(self)
end

class.createChain = createChain

local function createBuff(self, target)
  return ed.BuffCreate(self.info.buff_info, target, self.caster)
end

class.createBuff = createBuff

function class:createRegion()
  return ed.RegionCreate(self)
end

local function onPhaseFinished(self)
  local current_phase_idx = self.current_phase_idx
  if current_phase_idx == #self.phase_list then
    self:finish()
  else
    self:startPhase(current_phase_idx + 1)
  end
end

class.onPhaseFinished = onPhaseFinished

local function testPointInShape(p, shape, arg1, arg2)
  if shape == "rectangle" then
    return p[1] >= 0 and arg1 >= p[1] and p[2] >= -arg2 * 0.5 and p[2] <= arg2 * 0.5
  elseif shape == "circle" then
    return p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  elseif shape == "halfcircle" then
    return p[1] >= 0 and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  elseif shape == "quartercircle" then
    return p[1] >= 0 and p[2] <= p[1] and p[2] >= -p[1] and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  else
    EDDebug("Unkonwn AOE Type: '" .. shape .. "', spelling mistake?")
  end
end

class.testPointInShape = testPointInShape

function class:collectAoeTarget(origin, direction)
  local list = {}
  local info = self.info
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(self:affectedCamp()) do
    if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == self.caster then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if testPointInShape(p2, shape, arg1, arg2) then
        table.insert(list, unit)
      end
    end
  end
  return list
end

local function takeEffectAt(self, location, source, direction)
  local info = self.info
  local aoe = self.info["AOE Origin"]
  local direction = direction or self.caster.direction
  self.curSkillCount = 0
  self.isEffectAt = true
  if aoe == "self" then
    location = self.caster.position
  end
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  if aoe then
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    local list = self:collectAoeTarget(origin, direction)
    for k, unit in ipairs(list) do
      self:takeEffectOn(unit)
    end
    if ed.run_with_scene and ed["Show Gizmo"] then
      local pos = ed.toViewPosition(origin, 0)
      if shape == "circle" then
        local drawNode = CCDrawNode:create()
        drawNode:drawCircle(pos, arg1, ccc4f(0, 0.1, 0.6, 0.5), 0.5, false)
        ed.sceneui.ui_layer:addChild(drawNode, 20)
        ListenTimer(Timer:Once(5), function()
          drawNode:removeFromParentAndCleanup(true)
        end)
      elseif shape == "rectangle" then
        local drawNode1 = CCDrawNode:create()
        if direction == -1 then
          arg1 = -arg1
        end
        drawNode1:drawRect(pos, arg1, arg2, ccc4f(0, 0.1, 0.6, 0.5), 0.5, false)
        ed.sceneui.ui_layer:addChild(drawNode1, 20)
        ListenTimer(Timer:Once(5), function()
          drawNode1:removeFromParentAndCleanup(true)
        end)
      else
        local angle = 90
        if shape == "halfcircle" then
          angle = 180
        end
        local drawNode2 = CCDrawNode:create()
        drawNode2:drawSector(pos, arg1, angle, direction == 1, ccc4f(0, 0.1, 0.6, 0.5), 0.5, false)
        ed.sceneui.ui_layer:addChild(drawNode2, 20)
        ListenTimer(Timer:Once(5), function()
          drawNode2:removeFromParentAndCleanup(true)
        end)
      end
    end
  else
    self:takeEffectOn(self.target, source)
  end
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

class.takeEffectAt = takeEffectAt

local function power(self, source, target, damage_type)
  local caster = self.caster
  local info = self.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and self.caster.attribs[info["Plus Attr"]] or 0
  local power = multiplier * base_attrib + info["Basic Num"]
  local ratio1 = 0
  local ratio2 = 0
  if damage_type and damage_type ~= "Heal" then
    if target then
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.name == "ExtraDamageBuff_damaged" and tbuff:checkExtraDamageCondition(source, damage_type, power) and tbuff.extraDamageValue and ratio1 <= 1 then
          ratio1 = ratio1 + tbuff.extraDamageValue
        end
      end
    end
    if self.extraDamageRatio then
      ratio2 = ratio2 + self.extraDamageRatio
    end
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.name == "ExtraDamageBuff_attack" and tbuff.extraDamageValue and 0 < tbuff.timer and ratio2 <= 1 then
        ratio2 = ratio2 + tbuff.extraDamageValue
        tbuff.timer = 0
      end
    end
    self.extraDamageRatio = ratio2
  end
  return power * (1 + ratio1 + ratio2), 1
end

class.power = power

local function getDamage(self, target, power, damage_type, field, source, crit_mod)
  local dmg, Crit = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg, Crit
end

class.getDamage = getDamage

local function takeEffectOn(self, target, source, shift)
  local caster = self.caster
  local lfs_amount
  local info = self.info
  local damage_type = info["Damage Type"]
  source = source or caster
  if source and source.what == "petUnit" and source.camp == target.camp then
    if not target:isAlive() or target.buff_effects.invulnerable and source.owner ~= target and damage_type ~= "Heal" or target.manually_casting and source.camp ~= target.camp then
      return false
    end
  elseif not target:isAlive() or target.buff_effects.invulnerable and target ~= caster and damage_type ~= "Heal" or target.manually_casting and source.camp ~= target.camp then
    return false
  end
  local bless5315 = false
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(5315) and caster.camp == 1 and not caster.config.is_summoned and target.camp == -1 then
    bless5315 = true
    local buff_miss = false
    if target:isAlive() and (not target.unitonDying or target == caster) and info["Buff ID"] > 0 then
      target:addBuff(self:createBuff(target))
    end
    local KRES = target.attribs.KnockRES
    local time = info["Knock Up"]
    local distance = info["Knock Back"]
    if KRES < 1 and 0 <= KRES then
      time = time * math.sqrt(KRES)
      distance = distance * KRES
    end
    local petMaster
    if caster.what == "petUnit" and caster.owner then
      petMaster = caster.owner
    end
    if petMaster then
      if ed.isTitanById(target.tid) and not ed.isTitanById(petMaster.tid) then
        if target.stars and petMaster.stars and target.stars > petMaster.stars then
          time = time * math.sqrt(1 / (4 * (target.stars - petMaster.stars + 1)))
          distance = distance * 1 / (4 * (target.stars - petMaster.stars + 1))
        else
          time = time * math.sqrt(0.25)
          distance = distance * 1 / 4
        end
      end
    elseif ed.isTitanById(target.tid) and not ed.isTitanById(caster.tid) then
      if target.stars and caster.stars and target.stars > caster.stars then
        time = time * math.sqrt(1 / (4 * (target.stars - caster.stars + 1)))
        distance = distance * 1 / (4 * (target.stars - caster.stars + 1))
      else
        time = time * math.sqrt(0.25)
        distance = distance * 1 / 4
      end
    end
    if not buff_miss and (0 < time or 0 < distance) then
      local direction = {1, 0}
      if target.position[1] == caster.position[1] then
        direction = ed.edpNormalize({
          caster.direction,
          0
        })
      else
        direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(target.position, caster.position)))
      end
      target:knockup(time, ed.edpMult(direction, distance), shift)
    end
  end
  local affect_field = info["Affect MP"] and "mp" or "hp"
  local dmg = 0
  local Crit
  if damage_type then
    local power, coefficient = self:power(source, target, damage_type)
    if self.caster.buff_effects.fury and target.camp == self.caster.foecamp * self.info["Affected Camp"] then
      power = power * (self.caster.friendly_damage_discount or 1)
    end
    if damage_type == "Heal" then
      if do_battle_log then
        btlog("%s: %s ++> %s (+%d)", self:display(), caster:display(), target:display(), power)
      end
      target:takeHeal(power, affect_field, caster)
    else
      if damage_type == "AD" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.DODG - caster.attribs.HIT)
        local prob = dodg / (100 + dodg)
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          target:onHitMiss(self)
          if do_battle_log then
            btlog("%s: %s --> %s (Miss!)", self:display(), caster:display(), target:display())
          end
          local color = target.camp == ed.emCampEnemy and "red" or "blue"
          if target.actor then
            ed.PopupCreate("dodge", color, target.actor, nil, "text")
          end
          return false
        end
      elseif damage_type == "AP" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.MDODG)
        local prob = dodg / 100
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          target:onHitMiss(self)
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
      dmg, Crit = self:getDamage(target, power, damage_type, affect_field, caster, info["CRIT%"] / 100)
      if target.buffImpactEffect and target.actor then
        local name = target.buffImpactEffect.value.ImpactEffect
        local effect_z = target.buffImpactEffect.value.ImpactEffectZorder
        if self.isEffectAt then
          self.curSkillCount = self.curSkillCount + 1
          if self.curSkillCount <= class.maxShowSkillCount then
            target.actor:addEffect(name, effect_z)
          end
        else
          target.actor:addEffect(name, effect_z)
        end
      end
      if dmg == 0 then
        return false
      end
      if 0 < info["LFS%"] then
        local LFSRatio = caster.attribs.LFSRatio
        local lfs = caster.attribs.LFS
        local heal = dmg * lfs / (100 + lfs + target.level) * info["LFS%"] * 0.01
        if ed.engine.autoChessMode then
          heal = dmg * lfs * 0.01 * info["LFS%"] * 0.01
        end
        LFSRatio = math.max(-100, LFSRatio)
        local heal = heal * (1 + LFSRatio * 0.01)
        if 1 < heal or heal < 0 then
          local amount = caster:takeHeal(heal, affect_field, caster, "LFS")
          if amount then
            if do_battle_log then
              btlog("  %s leeches %d %s form %s", caster:display(), amount, affect_field, target:display())
            end
            lfs_amount = amount
          else
            if do_battle_log then
              btlog("  %s leeches %d %s form %s", caster:display(), heal, affect_field, target:display())
            end
            lfs_amount = heal
          end
        end
      end
    end
  end
  local buff_miss = false
  if target:isAlive() and (not target.unitonDying or target == caster) and not bless5315 and info["Buff ID"] > 0 then
    local bSucess, reason = ed.Buff.checkAddBuff(info.buff_info, self.level, target, caster)
    if bSucess then
      target:addBuff(self:createBuff(target))
    else
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local text = reason == "resist" and "resist" or "miss"
      if target.actor then
        ed.PopupCreate(text, color, target.actor, nil, "text")
      end
      buff_miss = true
    end
  end
  local KRES = target.attribs.KnockRES
  local time = info["Knock Up"]
  local distance = info["Knock Back"]
  if KRES < 1 and 0 <= KRES then
    time = time * math.sqrt(KRES)
    distance = distance * KRES
  end
  local petMaster
  if caster.what == "petUnit" and caster.owner then
    petMaster = caster.owner
  end
  if petMaster then
    if ed.isTitanById(target.tid) and not ed.isTitanById(petMaster.tid) then
      if target.stars and petMaster.stars and target.stars > petMaster.stars then
        time = time * math.sqrt(1 / (4 * (target.stars - petMaster.stars + 1)))
        distance = distance * 1 / (4 * (target.stars - petMaster.stars + 1))
      else
        time = time * math.sqrt(0.25)
        distance = distance * 1 / 4
      end
    end
  elseif ed.isTitanById(target.tid) and not ed.isTitanById(caster.tid) then
    if target.stars and caster.stars and target.stars > caster.stars then
      time = time * math.sqrt(1 / (4 * (target.stars - caster.stars + 1)))
      distance = distance * 1 / (4 * (target.stars - caster.stars + 1))
    else
      time = time * math.sqrt(0.25)
      distance = distance * 1 / 4
    end
  end
  if not buff_miss and (0 < time or 0 < distance) then
    local direction = {1, 0}
    if target.position[1] == caster.position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(target.position, caster.position)))
    end
    target:knockup(time, ed.edpMult(direction, distance), shift)
  end
  local name = info["Impact Effect"]
  if name and target.actor then
    local effect_z = info["Impact Zorder"]
    if self.isEffectAt then
      self.curSkillCount = self.curSkillCount + 1
      if self.curSkillCount <= class.maxShowSkillCount then
        target.actor:addEffect(name, effect_z)
      end
    else
      target.actor:addEffect(name, effect_z)
    end
  end
  ed.engine:collectSkillHit(self.caster, self, target)
  return true, dmg, Crit, lfs_amount
end

class.takeEffectOn = takeEffectOn

local function trigger(self)
end

class.trigger = trigger

local function launchPoint(self)
  local event = self.next_event
  if event == nil or event.Type ~= "Attack" then
    event = {X = 0, Y = 75}
  end
  local repairScale = 0.09 / ed.cha_scale
  local bone_position = {
    event.X * ed.cha_scale,
    event.Y * ed.cha_scale
  }
  local caster = self.caster
  local sx, sy = caster:getRuntimeScale()
  local us = caster:getUnitScale()
  local pos = {
    caster.position[1] + bone_position[1] * sx * us * repairScale,
    caster.position[2]
  }
  local h = bone_position[2] * sy * us * repairScale
  return pos, h
end

class.launchPoint = launchPoint

local function checkAffectSkillTag(self, buffInfo)
  if not buffInfo["AffectSkill Tag"] then
    return false
  end
  for _, v in ipairs(self.info["Skill Tags"]) do
    if buffInfo["AffectSkill Tag"] == v then
      return true
    end
  end
  return false
end

local function lockCasterDirection(self, lock)
  self.casterDirectionLocked = lock
end

class.lockCasterDirection = lockCasterDirection

local function affectField(self, buffInfo)
  if not checkAffectSkillTag(self, buffInfo) then
    return
  end
  local info = self.info
  for i = 1, 2 do
    local field = buffInfo["Affect Field " .. i]
    if not field then
      break
    end
    if info[field] then
      info[field] = info[field] + buffInfo["Add Value " .. i]
    else
      info[field] = buffInfo["Add Value " .. i]
    end
  end
end

class.affectField = affectField

local function unAffectField(self, buffInfo)
  if not checkAffectSkillTag(self, buffInfo) then
    return
  end
  local info = self.info
  for i = 1, 2 do
    local field = buffInfo["Affect Field " .. i]
    if not field then
      break
    end
    if info[field] then
      info[field] = info[field] - buffInfo["Add Value " .. i]
    end
  end
end

class.unAffectField = unAffectField

function class:getSkillCDRemaining()
  return self.cd_remaining or 0
end
