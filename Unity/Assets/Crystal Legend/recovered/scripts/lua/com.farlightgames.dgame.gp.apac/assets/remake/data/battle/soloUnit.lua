local base = ed.Unit
local SoloUnit = {
  mt = {}
}
SoloUnit.mt.__index = SoloUnit
setmetatable(SoloUnit, base.mt)
ed.SoloUnit = SoloUnit

function SoloUnit.mt:__tostring()
  return string.format("%s\tHP:%.30f/%d\tMP:%d\t%s\t@%s:%.1f [%s]\n", self:display(), self.hp or 0, self.attribs.HP or 0, self.mp or 0, ed.state_to_string[self.state] or "nil", self.action_name or "nil", self.action_elapsed or 0, 0)
end

function SoloUnit:getUnitScale()
  local ret = ed.lookupDataTable("Puppet", "Scale", self.puppet_stack[#self.puppet_stack])
  ret = ret * self.config.size_mod
  if self.config.is_summoned then
    ret = ret * 0.7
  end
  return ret * 1.2
end

function SoloUnit:baseAttribs()
  local attribs = self.fixed_attribs
  local orig = self.fixed_orig_attribs
  local info = self.info
  for _, name in ipairs(ed.attrib_names) do
    local value = info[name] or 0
    attribs[name] = value
    orig[name] = value
  end
  attribs.PDM = 1
  attribs.TDM = 1
  attribs.MPGainRatio = 0
  attribs.KnockRES = 1
  attribs.MSPD = 18
  orig.PDM = 1
  orig.TDM = 1
  orig.MPGainRatio = 0
  orig.KnockRES = 1
end

function SoloUnit:buffAttribs()
  for _, buff in ipairs(self.buff_list) do
    buff:apply()
  end
  for _, buff in ipairs(self.buff_list) do
    if buff.onStart then
      buff:onStart()
    end
  end
end

function SoloUnit:rebuild(mode)
  if mode == "rebuild" then
    self.fixed_attribs = {}
    self.fixed_orig_attribs = {}
    self:baseAttribs()
  end
  self.attribs = ed.copyTable(self.fixed_attribs or {})
  self:passiveAttribs()
  self:buffAttribs()
  self:convertAttribs()
end

local function SoloUnitCreate(proto, camp)
  local self = ed.Entity.create()
  self.what = "SoloUnit"
  setmetatable(self, SoloUnit.mt)
  local config = {
    estimate_rank = false,
    estimate_skill = true,
    estimate_max_rank = false,
    hp_mod = 1,
    dps_mod = 1,
    arm_mod = 1,
    mr_mod = 1,
    size_mod = 1
  }
  self.config = config
  self.proto = proto
  self.tid = proto._hid
  self.powers = proto._powers or {}
  self.stars = 1
  self.level = 1
  self.rank = 1
  self.atkTime = 1
  self.nPerSecond = 1
  self.cardTypeCount = 0
  self.drugRatioPlus = 1
  self.drugValue = 0
  self.drugTime = 1
  self.drugDamageRatio = 1
  self.drugDamageAdd = 0
  self.shieldRatioPlus = 1
  self.shieldValue = 0
  self.deShieldRatio = 0
  self.weakRatioPlus = 1
  self.deWeakRatio = 0
  self.frozenRatioPlus = 1
  self.frozenValue = 0
  self.frozenTime = 1
  self.deFrozenRatio = 0
  self.hasteRatioPlus = 1
  self.hasteValue = 0
  self.deHasteRatio = 0
  self.hasteTime = 1
  self.periodicSkillCount = 0
  self.apDamageAdd = 0
  self.mirrorBeDamageRatio = 2
  self.mirrorDamageRatio = 0.5
  self.info = ed.copyTable(ed.lookupDataTable("SoloUnit", nil, self.tid))
  self.name = self.info.Name
  self.camp = camp or ed.emCampPlayer
  self.foecamp = -self.camp
  self.walk_speed_multiplier = 1
  self.radius = self.info["Collide Radius"]
  local current_puppet = self.info.Puppet
  self.puppet_stack = {current_puppet}
  self.previous_position = {0, 0}
  self.battledata = battledata:new()
  self.walk_v = {0, 0}
  self.fearVelocity = {0, 0}
  self.state = ed.emUnitStateBase
  self.buff_effects = {}
  self.fury_stack = {}
  self.knockup_time = -1
  self.knockup_v = {0, 0}
  self.attribs = {}
  self.region_list = {}
  self.orig_attribs = {}
  self.hp = 0
  self.mp = 0
  self.ai = ed.createSoloAIForUnit(self)
  self.current_skill = nil
  self.manually_casting = false
  self.action_name = nil
  self.action_loop = false
  self.action_duration = 0
  self.action_elapsed = 0
  self.push_interval_tick = 4
  self.speeder = 1
  self.buff_list = {}
  self.hp_low = false
  self.mp_low = false
  self.actor = nil
  self.walk_time = 0
  self.actionStageId = self.info["Period Group"]
  self.dPSStatisticsRatio = self.info["DPS Statistics Ratio"] or 1
  self.killer = nil
  self.taunter = nil
  self.detaunter = nil
  self.controlTarget = nil
  self.controlCamp = nil
  self.controlledTarget = nil
  self.cards = {}
  self.mirrorList = {}
  self.buffManager = ed.BuffManagerCreate(self)
  self:initSkill()
  self:rebuild("rebuild")
  self.hp = self.attribs.HP
  self.mp = 0
  if not config.pre_select then
    local script = ed.getSoloUnitScript(self.tid)
    if script then
      local init_func = require(script)
      if overwrite_unit_script[self.tid] then
        local func = overwrite_unit_script[self.tid]
        func()
      end
      self = init_func(self)
    end
  end
  self:idle()
  return self
end

SoloUnit.create = SoloUnitCreate
ed.SoloUnitCreate = SoloUnitCreate

function SoloUnit:updateSoloAttrib()
  self:rebuild()
  self.hp = self.attribs.HP
end

function SoloUnit:getPowerTypeAttr(valueType)
  local powers = self.powers
  for k, power in ipairs(powers) do
    local effects = power._effects
    for kk, effect in ipairs(effects or {}) do
      local records = effect._records
      for _, record in ipairs(records or {}) do
        local type = record._type
        if type == valueType then
          local values = record._int_values
          return values
        end
      end
    end
  end
  return {}
end

function SoloUnit:convertAttribs()
  local attribs = self.attribs
  attribs.HP = attribs.HP * self.config.hp_mod
  attribs.PDM = self.config.dps_mod
  attribs.ARM = attribs.ARM * self.config.arm_mod
  attribs.MR = attribs.MR * self.config.mr_mod
  local imu_mod = self.config.imu_mod or 1
  if attribs.ALLIMU < 100 and attribs.ALLIMU >= 0 then
    attribs.ALLIMU = 100 - (100 - attribs.ALLIMU) / imu_mod
  end
  if self.hp > attribs.HP then
    self.hp = attribs.HP
  end
  if self.mp > attribs.MP then
    self.mp = attribs.MP
  end
end

function SoloUnit:onUnitExitBattle(withEffect)
  self.state = ed.emUnitState_Dying
  self.terminated = true
  if self.current_skill then
    self.current_skill:interrupt()
  end
  self.walk_v = {0, 0}
  self.hp = 0
  self.mp = 0
  self.action_name = nil
  self.action_loop = false
  self.action_duration = 0
  self.action_elapsed = 0
  ed.engine:onUnitExit(self)
  if self.actor then
    self.actor:onUnitExit()
  end
end

function SoloUnit:initSkill()
  self.manual_skill = nil
  self.skill_list = {}
  self.passive_skill_list = {}
  self.aura_skill_list = {}
  self.effect_enemy_aura_skill_list = {}
  self.skills = {}
  self.attack_range = 0
  local config = self.config
  local info = self.info
  local skill_list = self.skill_list
  local skills = self.skills
  local uid = self.info["Hero ID"]
  for slot, group in pairs(ed.getDataTable("SoloSkillGroup")[uid]) do
    local skill_level = 0
    if config.estimate_max_rank then
      skill_level = math.floor(self.level) + 0
    elseif config.estimate_skill then
      skill_level = math.floor(self.level)
    elseif self.proto._skill_levels then
      skill_level = (self.proto._skill_levels[slot] or 0) + 0
      local parentSkill = group["Subordinate To"]
      if parentSkill ~= 0 then
        local newSlot = ed.getSkillSlotId(uid, parentSkill)
        skill_level = (self.proto._skill_levels[newSlot] or 0) + 0
      end
    end
    if group["Skill Group ID"] == info["Basic Skill"] then
      skill_level = 1
    end
    if skill_level <= 0 then
      break
    end
    local skill_info = ed.SoloSkill.getSoloSkillInfo(group, self.rank)
    local active_type = skill_info["Active Type"]
    if active_type == "active" then
      local skill = ed.SoloSkillCreate(skill_info, self, skill_level)
      table.insert(skill_list, skill)
      skills[skill.info["Skill Group ID"]] = skill
      skills[skill.info["Skill Name"]] = skill
    elseif active_type == "passive" then
      table.insert(self.passive_skill_list, skill_info)
    elseif active_type == "aura" then
      table.insert(self.aura_skill_list, skill_info)
    elseif active_type == "negative_aura" then
      table.insert(self.effect_enemy_aura_skill_list, skill_info)
    end
  end
  local basic_skill = skills[info["Basic Skill"]]
  self.basic_skill = basic_skill
  self.attack_range = 999
  self:sortActiveSkill()
end

function SoloUnit:getSelfBuffByID(buffId)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == buffId then
      return tbuff
    end
  end
  return nil
end

function SoloUnit:checkBeCrit(source, damage_type)
  local crit = 0
  if damage_type == "AD" then
    crit = source.attribs.CRIT
  elseif damage_type == "AP" then
    crit = source.attribs.MCRIT
  elseif damage_type == "Holy" then
    return false
  elseif damage_type == "Drug" then
    return false
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  if 70 < crit then
    crit = 70
  end
  local crit_prob = crit / 100
  local r = ed.rand()
  local bCrit = crit_prob > r
  if bCrit then
    local Crit6buff = self:getSelfBuffByID(90000021)
    if Crit6buff then
      local CritBuff6_values = ed.getDataTable("SoloCardSkill")[21]["Level Arg 1"]
      local CritFailRatio = CritBuff6_values[Crit6buff.rank] / 100
      local rand = ed.rand()
      if CritFailRatio >= rand then
        bCrit = false
      end
    end
  end
  return bCrit
end

function SoloUnit:onHitBeCrit(source, soloParams)
  for k, v in ipairs(source.buff_list) do
    if v.onHitCrit then
      v.onHitCrit()
    end
  end
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == 1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(3, isPlayer)
    if battleData then
      battleData:addValue(1, soloParams.type, soloParams.id)
    end
  end
end

function SoloUnit:takeDamage(params)
  if not self:isAlive() then
    return 0
  end
  if type(params) ~= "table" then
    print(debug.traceback())
    error("takeDamage params must be a table")
  end
  local skillTags, skill
  local damage_type = params.damage_type
  local field = params.field or "hp"
  local source = params.source
  local crit_mod = params.crit_mod or 1
  local amount = params.amount
  local skill = params.skill
  local skillTags = skill and skill.info["Skill Tags"]
  local crit
  local level = self.level
  local soloParams = params.soloParams
  local transferred = params.transferred
  local damageinfo = params.damageinfo
  local hit = source:judgeAttackUnMiss(damage_type, self)
  if not hit then
    self:onHitMiss(skill, source, amount, soloParams)
    return 0, false
  end
  local bCrit = self:checkBeCrit(source, damage_type)
  local damage = amount
  if bCrit then
    self:onHitBeCrit(source, soloParams)
    local crit_multiplier = 2.5
    local crit_ratio = source.attribs.CSD * 0.01 + 1 or 1
    damage = amount * crit_multiplier * crit_ratio
  end
  local buff_templist = {}
  for i, buff in ipairs(self.buff_list) do
    table.insert(buff_templist, buff)
  end
  for _, buff in ipairs(buff_templist) do
    damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  end
  if damage <= 0 then
    return 0
  end
  local immunity = self.attribs.ALLIMU
  if damage_type == "AD" then
    immunity = immunity + self.attribs.PIMU - source.attribs.ADDP
  elseif damage_type == "AP" then
    immunity = immunity + self.attribs.MIMU - source.attribs.APDP
  end
  local lost = self:getLostHPAfterImmunity(damage, immunity, damage_type, source, skill, field)
  if source ~= self and field == "hp" then
    source.battledata:addDamage(damage, damage_type)
    self.battledata:addBearDamage(damage)
  end
  if do_battle_log then
    btlog("    %s lost %d %s %s", self:display(), lost, field, bCrit and "(Crit!)" or "")
  end
  if field == "hp" then
    if damage_type ~= "Holy" then
      if 0 < self.shieldValue then
        local shieldDef = math.min(self.shieldValue, math.abs(lost))
        lost = lost - shieldDef
        self:subShield(shieldDef)
      elseif 0 > self.shieldValue then
        local weakDamage = math.min(math.abs(self.shieldValue), math.abs(lost))
        lost = lost + weakDamage
        self.shieldValue = self.shieldValue + weakDamage
      end
    end
    self:setHP(self.hp - lost, damage_type, soloParams)
    if self.hp == 0 then
      self:onDying(source)
    end
  elseif field == "mp" then
    self:setMP(self.mp - lost)
  end
  if self.actor and field == "hp" then
    local popDamage = math.floor(lost + 0.5)
    if popDamage ~= 0 then
      local color = "solo_ad"
      if damage_type == "AD" then
        color = "solo_ad"
      elseif damage_type == "AP" then
        color = "solo_ap"
      elseif damage_type == "Holy" then
        color = "solo_holy"
      elseif damage_type == "Drug" then
        color = "solo_dot"
      end
      ed.PopupCreate(tostring(popDamage), color, self.actor, bCrit)
    end
  end
  return lost, bCrit
end

function SoloUnit:die(killer)
  if not self:isAlive() then
    return
  end
  self.unitonDying = false
  if do_battle_log then
    btlog("%s died.", self:display())
  end
  self.state = ed.emUnitState_Dying
  self.killer = killer
  if self.current_skill then
    self.current_skill:interrupt()
  end
  self:removeSignedBuffer()
  self:setAction("Death", false, true)
  ed.engine:onUnitDie(self, self.killer)
  if self.actor then
    if self.actor.puppet then
      self.actor.puppet:interruptSound()
    end
    self.actor:onUnitDeath()
  end
end

function SoloUnit:takeHeal(amount, _type, source, reason, soloParams)
  if not self:isAlive() then
    return
  end
  _type = _type or "hp"
  if source then
    amount = amount * source.attribs.PDM
  end
  local isAddPoint = true
  if _type == "mp" then
    amount = amount * (math.max((self.attribs.MPGainRatio or 0) / 100, -1) + 1)
    local change = self:setMP(self.mp + amount, soloParams)
    if change then
      amount = change or amount
    end
  else
    amount = amount * (math.max((self.attribs.HealRatio or 0) / 100, -1) + 1)
    if not self.buff_effects.unheal then
      for _, buff in ipairs(self.buff_list) do
        if buff.onHeal then
          buff.onHeal(amount, reason, soloParams)
        end
      end
      local change = self:setHP(self.hp + amount, reason or "heal", soloParams)
      amount = change and change or amount
      if source then
        source.battledata:addTakeHeal(amount)
      end
    else
      isAddPoint = false
    end
  end
  if do_battle_log then
    btlog("   %s gains %d %s", self:display(), amount, _type)
  end
  if isAddPoint and self.actor and _type == "hp" and 1 < amount then
    local str = "+" .. math.floor(amount + 0.5)
    ed.PopupCreate(str, "solo_heal", self.actor, false, "heal")
  end
  return amount
end

function SoloUnit:castSkill(skill, target)
  if not self:isAlive() then
    return
  end
  self.state = ed.emUnitState_Attack
  self.walk_v = {0, 0}
  self.current_skill = skill
  if skill.info.Slot ~= 5 then
    self.isCastUlt = true
  else
    self.isCastUlt = false
  end
  skill:start(target)
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == -1 then
      isPlayer = false
    end
    if skill.info.Slot == 5 then
      local battleData = ed.SoloModel:getFactionBattleData(1, isPlayer)
      if battleData then
        battleData:addValue(1, 2, 5)
      end
    elseif skill.info.Slot == 1 then
      local battleData = ed.SoloModel:getFactionBattleData(6, isPlayer)
      if battleData then
        battleData.totalValue = battleData.totalValue + 1
      end
    end
    local battleData = ed.SoloModel:getFactionBattleData(0, isPlayer)
    if battleData then
      battleData:addAmount(2, skill.info.Slot)
    end
  end
end

function SoloUnit:onHitMiss(skill, caster, power, soloParams)
  for k, v in ipairs(self.buff_list) do
    if v.onHitMiss then
      v.onHitMiss(skill, caster, power)
    end
  end
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == -1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(2, isPlayer)
    if battleData then
      battleData:addValue(1, soloParams.type, soloParams.id)
    end
    ed.PopupCreate("dodge", "blue", self.actor, nil, "text")
  end
end

function SoloUnit:setMP(mp, soloParams)
  local config = {
    unit = self,
    mp = mp,
    mp_change = mp - self.mp
  }
  if config.mp_change > 0 and self.buff_effects.noMPGet then
    return 0
  end
  ed.engine:collectMPchange(config)
  local mp = config.mp
  local mp_change = config.mp_change
  if mp > self.attribs.MP then
    mp = self.attribs.MP
  end
  if mp < 0 then
    mp = 0
  end
  self.mp = mp
  if ed.run_with_scene and soloParams and 0 < mp_change then
    local isPlayer = true
    if self.camp == -1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(6, isPlayer)
    if battleData then
      battleData:addValue(mp_change, soloParams.type, soloParams.id)
    end
  end
  return mp_change
end

function SoloUnit:setHP(hp, reason, params)
  if hp == self.hp or ed.engine.deadNum > 0 then
    return 0
  end
  if self.config.is_summoned then
    local hp_change = hp - self.hp
    self.hp = math.max(0, hp)
    return hp_change
  end
  local hp_change = hp - self.hp
  if hp_change < 0 then
    local target = self.basic_skill:selectTarget()
    if target then
      local soloCardBuff55 = target:getSelfBuffByID(90000064)
      if reason ~= "drug" and soloCardBuff55 then
        soloCardBuff55.trigger()
      end
      local soloCardBuff36 = target:getSelfBuffByID(90000039)
      if reason ~= "drug" and soloCardBuff36 then
        soloCardBuff36.trigger()
      end
    end
    local num = 1
    for k, v in ipairs(self.mirrorList) do
      if v:isAlive() then
        num = num + 1
      end
    end
    local perChange = math.floor(hp_change / num)
    for k, v in ipairs(self.mirrorList) do
      if v:isAlive() then
        v:setHP(v.hp + perChange * self.mirrorBeDamageRatio, reason, params)
        print("SoloUnit:setHP", v.name, perChange, perChange * self.mirrorBeDamageRatio)
      end
    end
    hp = self.hp + perChange
  end
  if hp > self.attribs.HP then
    hp = self.attribs.HP
  end
  if hp < 0 then
    for _, buff in ipairs(self.buff_list) do
      if buff.onWillDie then
        hp = buff.onWillDie(hp)
      end
    end
  end
  self.hp = math.max(0, hp)
  if ed.run_with_scene and params then
    if 0 < hp_change then
      local isPlayer = true
      if self.camp == -1 then
        isPlayer = false
      end
      local battleData = ed.SoloModel:getFactionBattleData(5, isPlayer)
      if battleData then
        battleData:addValue(hp_change, params.type or 1, params.id or 1)
      end
    elseif hp_change < 0 then
      local isPlayer = true
      if self.camp == 1 then
        isPlayer = false
      end
      local battleData = ed.SoloModel:getFactionBattleData(0, isPlayer)
      if battleData then
        local value = math.abs(hp_change)
        battleData:addValue(value, params.type or 1, params.id or 1)
      end
    end
  end
  return hp_change
end

function SoloUnit:addShield(value, soloParams)
  local targetUnit = ed.engine.camp1Unit
  if self.camp == 1 then
    targetUnit = ed.engine.camp2Unit
  end
  self.shieldValue = self.shieldValue + value * self.shieldRatioPlus * (1 - targetUnit.deShieldRatio)
  for i, buff in ipairs(self.buff_list) do
    if buff.onAddShield then
      buff.onAddShield(value, soloParams)
    end
  end
  if ed.run_with_scene and soloParams then
    local isPlayer = true
    if self.camp == -1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(9, isPlayer)
    if battleData then
      battleData:addValue(math.floor(value), soloParams.type, soloParams.id)
    end
  end
end

function SoloUnit:addWeak(value, soloParams, source)
  self.shieldValue = self.shieldValue - math.floor(value * source.weakRatioPlus * (1 - self.deWeakRatio))
  for i, buff in ipairs(source.buff_list) do
    if buff.onAddWeak then
      buff.onAddWeak(value, soloParams)
    end
  end
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == 1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(10, isPlayer)
    if battleData then
      battleData:addValue(math.floor(value), soloParams.type, soloParams.id)
    end
  end
end

function SoloUnit:subShield(value)
  self.shieldValue = math.max(0, self.shieldValue - value)
end

function SoloUnit:updateAction()
  local action_end = false
  if self.action_name and not self.action_loop then
    local elapsed = self.action_elapsed + self.dt_action
    local duration = self.action_duration
    if 0 < duration and elapsed > duration then
      action_end = true
      elapsed = elapsed - duration
      self:onActionFinished()
    end
    self.action_elapsed = elapsed
  end
  if action_end and self.state == ed.emUnitState_Attack then
    self.current_skill:onPhaseFinished()
  end
end

function SoloUnit:idle()
  if not self:isAlive() or self.state == ed.emUnitState_Idle then
    return
  end
  self.state = ed.emUnitState_Idle
  self.walk_v = {0, 0}
  self:setAction("Idle", true)
end

function SoloUnit:setAction(action_name, loop, interrupt)
  self.action_loop = loop or false
  if loop and action_name == self.action_name then
    return
  end
  self.action_name = action_name
  self.action_elapsed = interrupt and 0 or math.max(0, self.action_elapsed - self.action_duration)
  if not loop and action_name ~= nil then
    local puppetName = self.puppet_stack[#self.puppet_stack]
    local resourceName = ed.lookupDataTable("Puppet", "Resource", puppetName)
    if not string.match(resourceName, "%.sp$") then
      resourceName = resourceName .. ".cha"
    end
    self.action_duration = ed.lookupDataTable("AnimDuration", "Duration", resourceName, action_name)
    if not self.action_duration then
      self.action_name = "Idle"
      self.action_duration = 1.375
    end
  else
    self.action_duration = 0
  end
  if self.actor then
    self.actor:onStartNewAction()
  end
end

function SoloUnit:onActionFinished()
  if self.state == ed.emUnitState_Dead then
    self:setAction(nil)
  elseif self.state == ed.emUnitState_Dying then
    self.state = ed.emUnitState_Dead
    self:setAction(nil)
  elseif self.state ~= ed.emUnitState_Attack then
    self:idle()
  end
end

function SoloUnit:updateWalk(dt)
  local movable = not self.buff_effects.immoblilize
  local pos = self.position
  self.previous_position[1] = self.position[1]
  self.previous_position[2] = self.position[2]
  local v1 = movable and self.walk_v or ed.edpZero
  local v2 = self.knockup_v
  local v = self.velocity
  v[1] = v1[1] + v2[1]
  v[2] = v1[2] + v2[2]
  local direction = 0
  if movable and v1[1] ~= 0 then
    direction = v1[1]
  elseif self.current_skill and self.current_skill.target and not self.current_skill.casterDirectionLocked then
    direction = self.current_skill.target.position[1] - pos[1]
  end
  if 0 > direction * self.direction then
    self.direction = self.direction * -1
  end
  pos[1] = pos[1] + v[1] * self.dt_action
  pos[2] = pos[2] + v[2] * self.dt_action
end

function SoloUnit:updateSkill(dt)
  local skill_list = self.skill_list
  for i = 1, #skill_list do
    skill_list[i]:update(self.dt_action, self.dt_action)
  end
end

function SoloUnit:walkTowards(dest)
  if not self:isAlive() then
    return
  end
  if self.state ~= ed.emUnitState_Walk then
    self.state = ed.emUnitState_Walk
    self:setAction("Move", true)
  end
  local base_speed = self.info["Walk Speed"]
  local direction = ed.edpSub(dest, self.position)
  if direction[1] == 0 and direction[2] == 0 then
    self.walk_v = {0, 0}
  else
    direction = {
      direction[1] * math.abs(direction[1]),
      direction[2] * math.abs(direction[2])
    }
    self.walk_v = ed.edpMult(ed.edpNormalize(direction), base_speed * self.walk_speed_multiplier)
    self.walk_time = math.abs(direction[1] / self.walk_v[1])
  end
end

function SoloUnit:updateSpeed(dt)
  local attribs = self.attribs
  local MSPD = attribs.MSPD
  if not self.isCastUlt then
    MSPD = attribs.MSPD - self.frozenValue * 0.6
  end
  local speeder = 0 <= MSPD and (MSPD + 100) / 100 or 100 / (100 - MSPD)
  self.speeder = speeder
  self.dt_action = dt * speeder
  self.nPerSecond = string.format("%.1f", 1 / self.atkTime * speeder)
end

function SoloUnit:takeDrugDamage()
  local drugSub = math.max(1, math.floor(self.drugValue * 0.6))
  local damage = math.floor(self.drugValue * self.drugDamageRatio + self.drugDamageAdd)
  damage = damage * (self.attribs.APDP * 0.01 + 1)
  self.drugValue = math.max(0, self.drugValue - drugSub)
  self:takeDamage({
    amount = damage,
    damage_type = "Drug",
    field = "hp",
    source = self,
    soloParams = {type = 7, id = 1}
  })
  if self.hp == 0 then
    self:die()
  end
end

function SoloUnit:judgeAttackUnMiss(damageType, target)
  if damageType == "Holy" or damageType == "Drug" then
    return true
  end
  local hit = true
  if target.attribs.DODG > 70 then
    target.attribs.DODG = 70
  end
  if 70 < target.attribs.MDODG then
    target.attribs.MDODG = 70
  end
  if damageType == "AD" then
    hit = ed.rand() >= math.max(0, target.attribs.DODG - self.attribs.HIT) / 100
  elseif damageType == "AP" then
    hit = ed.rand() >= math.max(0, target.attribs.MDODG) / 100
  end
  if not hit then
    local Dodge6buff = self:getSelfBuffByID(90000014)
    if Dodge6buff then
      local DodgeBuff6_values = ed.getDataTable("SoloCardSkill")[14]["Level Arg 1"]
      local MissFailRatio = DodgeBuff6_values[Dodge6buff.rank] / 100
      local rand = ed.rand()
      if MissFailRatio >= rand then
        hit = true
      end
    end
  end
  return hit
end

function SoloUnit:addDrug(value, soloParams, source)
  self.drugValue = self.drugValue + math.floor(value * source.drugRatioPlus)
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == 1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(7, isPlayer)
    if battleData then
      battleData:addValue(math.floor(value), soloParams.type, soloParams.id)
    end
  end
end

function SoloUnit:updateDrug(dt)
  self.drugTime = self.drugTime - dt
  if self.drugTime <= 0 then
    self.drugTime = self.drugTime + 1
    if 0 < self.drugValue then
      self:takeDrugDamage()
    end
  end
end

function SoloUnit:addFrozen(value, soloParams, source)
  self.frozenValue = self.frozenValue + math.floor(value * source.frozenRatioPlus * (1 - self.deFrozenRatio))
  if self.frozenValue > 0 and 0 < self.hasteValue then
    local cancelAmount = math.min(self.frozenValue, self.hasteValue)
    self.frozenValue = self.frozenValue - cancelAmount
    self.hasteValue = self.hasteValue - cancelAmount
  end
  local soloCardBuff66 = source:getSelfBuffByID(90000075)
  if soloCardBuff66 then
    soloCardBuff66.trigger()
  end
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == 1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(8, isPlayer)
    if battleData then
      battleData:addValue(math.floor(value), soloParams.type, soloParams.id)
    end
  end
end

function SoloUnit:addHaste(value, soloParams, source)
  local finalValue = math.floor(value * (source.hasteRatioPlus - self.deHasteRatio))
  self.hasteValue = self.hasteValue + finalValue
  if self.frozenValue > 0 and self.hasteValue > 0 then
    local cancelAmount = math.min(self.frozenValue, self.hasteValue)
    self.frozenValue = self.frozenValue - cancelAmount
    self.hasteValue = self.hasteValue - cancelAmount
  end
  for _, buff in ipairs(source.buff_list) do
    if buff.onAddHaste then
      buff.onAddHaste(finalValue, soloParams)
    end
  end
  if ed.run_with_scene then
    local isPlayer = true
    if self.camp == -1 then
      isPlayer = false
    end
    local battleData = ed.SoloModel:getFactionBattleData(11, isPlayer)
    if battleData then
      battleData:addValue(finalValue, soloParams.type, soloParams.id)
    end
  end
end

function SoloUnit:getHasteSpeed()
  local bonus = math.min(self.hasteValue, 200) / 300 + math.max(self.hasteValue - 200, 0) / 800
  bonus = math.min(bonus, 2)
  return 1 + bonus
end

function SoloUnit:updateHaste(dt)
  self.hasteTime = self.hasteTime - dt
  if self.hasteTime <= 0 then
    self.hasteTime = self.hasteTime + 1
    if 0 < self.hasteValue then
      self:takeHasteEffect()
    end
  end
end

function SoloUnit:takeHasteEffect()
  local hasteSub = math.max(1, math.floor(self.hasteValue * 0.4))
  self.hasteValue = math.max(0, self.hasteValue - hasteSub)
end

function SoloUnit:takeFrozenEffect()
  local frozenSub = math.max(1, math.floor(self.frozenValue * 0.4))
  self.frozenValue = math.max(0, self.frozenValue - frozenSub)
end

function SoloUnit:updateFrozen(dt)
  self.frozenTime = self.frozenTime - dt
  if self.frozenTime <= 0 then
    self.frozenTime = self.frozenTime + 1
    if self.frozenTime > 0 then
      self:takeFrozenEffect()
    end
  end
end

function SoloUnit:resetBuffApply(buff)
  self.needRefreshBuff = true
  self.refreshBuffList = self.refreshBuffList or {}
  table.insert(self.refreshBuffList, buff)
  if buff:isImpactAttribs() then
    self.needRefreshBuffAttr = true
  end
end

function SoloUnit:update(dt)
  self:updateSpeed(dt)
  self:updateAction()
  if not self:isAlive() then
    return
  end
  if ed.engine.canTick then
    if self.needRefreshBuff then
      if self.needRefreshBuffAttr then
        self:rebuild()
        self.needRefreshBuffAttr = false
      end
      self:applyBuffEffects()
      for k, buff in ipairs(self.refreshBuffList) do
        self:judgeCurrentSkill(buff)
      end
      self.refreshBuffList = {}
    end
    self:updateDrug(dt)
    self:updateFrozen(dt)
    self:updateHaste(dt)
    self:updateSkill(dt)
    local enableAI = self.state == ed.emUnitState_Idle or self.state == ed.emUnitState_Walk
    if enableAI then
      self.ai:update(dt)
    end
    for _, buff in ipairs(self.buff_list) do
      buff:update(dt)
    end
    if not self:isAlive() then
      return
    end
    self:setMP(self.mp + self.attribs.MPR * (self.attribs.MPGainRatio * 0.01 + 1) * dt * ed.engine.mp_bonus, {type = 4, id = 1})
    if self.hp == 0 then
      self.hp = 1
    end
    if self.interRuptSkill then
      self:skillInterRupt(self.interRuptSkill)
      self.interRuptSkill = nil
    end
  end
end

function SoloUnit:removeBuff(buff)
  local list = self.buff_list
  for i = 1, #list do
    if list[i] == buff then
      list[i] = list[#list]
      list[#list] = nil
      break
    end
  end
  local effects = {}
  for _, buff in pairs(self.buff_list) do
    for _, name in ipairs(buff.info["Control Effects"]) do
      effects[name] = true
    end
  end
  self.buff_effects = effects
  buff:onRemoved()
  if self.buffImpactEffect and buff.name == self.buffImpactEffect.name then
    self.buffImpactEffect = nil
  end
  self:resetBuffApply(buff)
end

function SoloUnit:addBuff(buff_Or_Binfo, caster)
  if not self:isAlive() or not buff_Or_Binfo then
    return
  end
  local buff
  if buff_Or_Binfo.class == ed.Buff then
    buff = buff_Or_Binfo
  else
    buff = ed.BuffCreate(buff_Or_Binfo, self, caster)
  end
  ed.engine:collectBuff({buff = buff})
  local alreadyAdd = false
  local isMaxcLevel = false
  if buff.info["Stack and Refresh"] then
    local buffID = buff.info.ID
    for _, unit_buff in ipairs(self.buff_list) do
      if buffID == unit_buff.info.ID then
        local info = unit_buff.one_stack_info and unit_buff.one_stack_info or unit_buff.info
        info = ed.wrapBuffInfo(unit_buff.caster, self, info)
        local buff
        buff, isMaxcLevel = unit_buff:upgrade(self, unit_buff.caster, info)
        alreadyAdd = true
        break
      end
    end
    if not alreadyAdd then
      self.buff_list[#self.buff_list + 1] = buff
    end
  else
    self.buff_list[#self.buff_list + 1] = buff
  end
  if buff.impactEffect then
    self.buffImpactEffect = {
      name = buff.name,
      value = {
        ImpactEffect = buff.impactEffect,
        ImpactEffectZorder = buff.impactEffectZorder
      }
    }
  end
  self:resetBuffApply(buff)
  if not alreadyAdd and buff then
    buff:onAddedServer()
    if ed.run_with_scene then
      if self.buffNotPopupWords then
        buff.notPopupWords = true
      end
      if ed.engine.canTick then
        buff:onAddedClient()
      end
    end
  end
  if alreadyAdd and ed.run_with_scene and not isMaxcLevel then
    buff:playTextAnimation()
  end
  for i, effect in ipairs(buff.info["Control Effects"]) do
    if effect == "stun" or effect == "stunbyself" then
      self:hurt()
    end
  end
  return buff
end

function SoloUnit:removeAllBuffs()
  local function canBeRemoved(buff)
    return not buff:isUnRemoveable()
  end
  
  local newList = {}
  for i, buff in ipairs(self.buff_list) do
    if canBeRemoved(buff) then
      if self.buffImpactEffect and buff.name == self.buffImpactEffect.name then
        self.buffImpactEffect = nil
      end
      buff:onRemoved()
    else
      table.insert(newList, buff)
    end
  end
  self.buff_list = newList
  self:rebuild()
  self:applyBuffEffects()
  self:judgeCurrentSkill()
end

function SoloUnit:reset()
  if self:isAlive() then
    self.state = ed.emUnitState_Idle
  else
    self.state = ed.emUnitState_Dead
    self.hasCorpse = false
  end
  self.buff_effects = {}
  local oldai = self.ai
  self.ai.will_cast_manual_skill = oldai.will_cast_manual_skill
  self.current_skill = nil
  self.last_stolen_skill = nil
  self.last_stolen_skill_puppet = nil
  self.manually_casting = false
  self.action_name = nil
  self.action_duration = 0
  self.action_elapsed = 0
  self.unitonDying = false
  self.buff_list = {}
  for _, skill in ipairs(self.skill_list) do
    skill:reset()
  end
  self:rebuild("rebuild")
  self.hp = self.attribs.HP
  self.mp = 0
  local resourceName = ed.lookupDataTable("Puppet", "Resource", self.info.Puppet) .. ".cha"
  self.atkTime = ed.lookupDataTable("AnimDuration", "Duration", resourceName, "atk")
  local MSPD = self.attribs.MSPD
  local speeder = 0 <= MSPD and (MSPD + 100) / 100 or 100 / (100 - MSPD)
  self.nPerSecond = string.format("%.1f", 1 / self.atkTime)
end

function SoloUnit:clearActor()
  self.actor = nil
end

function SoloUnit:startWork()
end

function SoloUnit:applyAuraSkill()
end

function SoloUnit:removeSignedBuffer()
end
