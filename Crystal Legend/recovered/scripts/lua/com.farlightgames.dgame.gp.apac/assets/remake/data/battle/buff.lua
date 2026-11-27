local ed = ed
local class = {
  mt = {}
}
ed.Buff = class
class.mt.__index = class

local function getTenValue(buffInfo, owner, caster)
  if not (buffInfo and owner) or not caster then
    return 0
  end
  if owner.camp == caster.camp then
    return 0
  end
  local attribName = buffInfo.Tenacity
  if attribName and owner.attribs[attribName] then
    local CON = caster.attribs.CON
    local TEN_final = owner.attribs[attribName] - CON
    if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(8403) and caster.camp == 1 then
      local bless8403 = ed.engine.rogueSkillMgr.rogueBlessList[8403]
      local p = bless8403.info["Script Arg1"] / 100
      local timerratio = bless8403.info["Script Arg2"]
      if p >= ed.rand() then
        TEN_final = TEN_final - timerratio
      end
    end
    return TEN_final
  end
  return 0
end

ed.Buff.getTenValue = getTenValue

local function getBuffDur(info, owner, caster)
  local dur = info.Time
  if 0 < dur then
    local dur = dur * math.max(0.01, 1 - getTenValue(info, owner, caster) / 100)
    return dur
  end
  return nil
end

local function getBUffInfo(info)
  if info["Stack and Refresh"] then
    local stackInfo = {}
    for key, name in pairs(info) do
      stackInfo[key] = name
    end
    if getmetatable(info) then
      setmetatable(stackInfo, getmetatable(info))
    end
    return stackInfo
  else
    return info
  end
end

local function showIcon(self, owner, caster)
  local alreadyAddIcon = false
  local buffID = self.info.ID
  for _, v in ipairs(owner.buff_list) do
    if v.info.ID == buffID then
      alreadyAddIcon = true
      break
    end
  end
  if not alreadyAddIcon then
    ed.sceneui:addBuffStack(self)
  end
end

local function getDuration(self)
  return getBuffDur(self.info, self.owner, self.caster)
end

class.getDuration = getDuration

local function BuffCreate(info, owner, caster, params)
  params = params or {}
  local self = {
    name = info.Name,
    info = getBUffInfo(info),
    one_stack_info = info["Stack and Refresh"] and info or nil,
    timer = getBuffDur(info, owner, caster),
    owner = owner,
    rank = params.rank or 1,
    caster = caster,
    caster_attribs = caster and caster.attribs or nil,
    shield = info["Shield Value"] > 0 and info["Shield Value"] or nil,
    clearOnDeathFlag = info["Clear On Death "],
    impactEffect = info["Impact Effect"],
    impactEffectZorder = info["Impact Effect Zorder"],
    class = class,
    heal_affect = true,
    params = params
  }
  if ed.run_with_scene and self.info["Show Icon"] then
    showIcon(self, owner, caster)
  end
  self.attrib = {}
  for _, name in ipairs(ed.attrib_names) do
    local value = info[name] or 0
    local ele = info[name .. ".x"]
    if value ~= 0 or ele then
      self.attrib[name] = true
    end
  end
  if owner.config.hp_mod and self.shield then
    local shield_mod = caster.camp == ed.emCampEnemy and (ed.engine.guildInstance_mode or ed.engine.hadesMode) and 1 or owner.config.hp_mod
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if owner.attribs.ShieldIncrease then
      ShieldIncrease = owner.attribs.ShieldIncrease
    end
    if owner.attribs.ShieldWeak then
      ShieldWeak = owner.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    self.shield = self.shield * shield_mod * shieldratio
  end
  setmetatable(self, class.mt)
  self.info = ed.wrapBuffInfo(caster, owner, self.info)
  if self.info.MOD then
    local init_func = require("battle/buffs/" .. self.info.MOD)
    self = init_func(self)
  end
  if self.info.ReverseHealRatio ~= 0 then
    owner.Reverse_Heal = true
    owner.ReverseHealRatio = self.info.ReverseHealRatio
  end
  return self
end

ed.BuffCreate = BuffCreate
class.create = create
local min = math.min

local function update(self, dt)
  local info = self.info
  local attribs = self.owner.attribs
  local hpr = info.HPR
  if hpr < 0 then
    local x = info["HPR" .. ".x"]
    if x then
      local a = info["HPR" .. ".a"]
      hpr = hpr + (self.caster_attribs[x] or 0) * a
    end
    local hpr = hpr * dt
    local damage = min(-hpr, self.owner.hp)
    local dotres
    if self.owner.what == "Unit" and self.owner.attribs.DOTRES then
      dotres = self.owner.attribs.DOTRES
    else
      dotres = 0
    end
    local dotDamageRatio
    if self.caster.what == "Unit" and self.caster.attribs.DotDRatio then
      dotDamageRatio = self.caster.attribs.DotDRatio
    else
      dotDamageRatio = 0
    end
    damage = damage * (1 + dotDamageRatio / 100) * self.owner.dPSStatisticsRatio * (1 - math.min(dotres / 100, 0.99))
    if self.owner ~= self.caster then
      if self.caster.what == "Unit" then
        self.caster.battledata:addDamage(damage, "HPR")
      end
      self.owner.battledata:addBearDamage(damage)
    end
  end
  if 0 <= hpr then
    local HEAL, healratio
    if self.caster and self.caster.what == "Unit" then
      HEAL = math.max((self.caster_attribs.HEAL or 0) / 100, -1)
    else
      HEAL = math.max(0, -1)
    end
    if self.owner and self.owner.what == "Unit" then
      healratio = math.max((self.owner.attribs.HealRatio or 0) / 100, -1)
    else
      healratio = 0
    end
    local hprbonus = 0
    local x = info["HPR" .. ".x"]
    if x then
      local a = info["HPR" .. ".a"]
      hprbonus = (self.caster_attribs[x] or 0) * a * dt
    end
    local hpr = hpr * dt + hprbonus
    hpr = hpr * (healratio + 1)
    if not self.owner.buff_effects.unheal then
      if self.caster then
        self.caster.battledata:addTakeHeal(hpr)
      end
      if self.owner then
        self.owner.battledata:addHeal(hpr)
      end
    end
  end
  if self.timer then
    self.timer = self.timer - dt
    if 0 > self.timer then
      self.owner:removeBuff(self)
    end
  end
end

class.update = update
local effect_inclusions = {
  frozen = {"stun"},
  stun = {
    "immoblilize",
    "silence",
    "disarm",
    "disableAI"
  },
  immoblilize = {},
  silence = {},
  disarm = {},
  disableAI = {},
  imprisonment = {
    "stun",
    "untargetable",
    "invulnerable"
  },
  untargetable = {},
  invulnerable = {},
  uncontrollable = {},
  enchanted = {},
  building = {"stable", "fix"},
  building_notfix = {"stable"},
  stable = {},
  fix = {},
  unheal = {},
  stealth = {},
  antistealth = {},
  noHPR = {},
  noMPGet = {},
  doom = {},
  undoom = {},
  fear = {
    "silence",
    "disarm",
    "disableAI"
  },
  taunt = {},
  detaunt = {},
  fury = {},
  unmanual = {},
  derangedOwner = {},
  derangedTarget = {},
  polymorph = {},
  icefrozen = {"stun"},
  parasitism = {},
  stunbyself = {
    "immoblilize",
    "silence",
    "disarm",
    "disableAI"
  },
  enchantedbyself = {},
  imprisonmentbyself = {
    "stun",
    "untargetable",
    "invulnerable"
  },
  silencebyself = {"silence"},
  polymorphbyself = {},
  hide = {}
}
local negative_effects = {
  frozen = true,
  stun = true,
  immoblilize = true,
  silence = true,
  disarm = true,
  imprisonment = true,
  enchanted = true,
  fear = true,
  taunt = true,
  polymorph = true,
  icefrozen = true
}

function class:isImpactAttribs()
  for name, enhance in pairs(self.attrib) do
    if name then
      return true
    end
  end
  return false
end

local function apply(self)
  local info = self.info
  local attribs = self.owner.attribs
  local owner = self.owner
  local caster = self.caster
  for name, _ in pairs(self.attrib) do
    local enhance = info[name] or 0
    local x = info[name .. ".x"]
    if x then
      local a = info[name .. ".a"]
      enhance = enhance + (self.caster_attribs[x] or 0) * a
    end
    if name == "HPR" then
      local heal = 0
      if caster.what == "Unit" then
        heal = caster.attribs.HEAL or 0
      end
      local dotDamageRatio = caster.attribs.DotDRatio or 0
      local hpr = enhance
      if 0 < hpr and 0 < heal and self.heal_affect then
        hpr = hpr * (1 + heal / 100)
      end
      if hpr < 0 and dotDamageRatio ~= 0 then
        hpr = hpr * (1 + dotDamageRatio / 100)
      end
      enhance = hpr
    end
    if enhance ~= 0 then
      attribs[name] = attribs[name] + enhance
    end
  end
end

class.apply = apply

function class:applyEffects()
  local info = self.info
  for i, effect in ipairs(info["Control Effects"]) do
    self:applyEffect(effect)
  end
  if info["AffectSkill Tag"] then
    self.owner:affectField(info)
  end
end

local function isCrlEftConflictWithUncontrollable(self)
  local isRet = false
  local info = self.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

class.isCrlEftConflictWithUncontrollable = isCrlEftConflictWithUncontrollable

local function isHasUnControllableEffect(self)
  local isRet = false
  local info = self.info
  for i, effect in ipairs(info["Control Effects"]) do
    if effect == "uncontrollable" then
      isRet = true
      break
    end
  end
  return isRet
end

class.isHasUnControllableEffect = isHasUnControllableEffect

local function applyEffect(self, effect)
  local buff_effects = self.owner.buff_effects
  if buff_effects.uncontrollable and negative_effects[effect] then
    return
  end
  if buff_effects[effect] then
    return
  end
  buff_effects[effect] = true
  for i, name in ipairs(effect_inclusions[effect]) do
    self:applyEffect(name)
  end
  if effect == "uncontrollable" then
    for k, v in pairs(negative_effects) do
      if k ~= "polymorph" or k ~= "polymorphbyself" then
        buff_effects[k] = nil
      end
    end
  end
end

class.applyEffect = applyEffect

local function onAddedServer(self)
  local info = self.info
  local owner = self.owner
  if info.Puppet then
    self.puppet_id = owner:pushPuppet(info.Puppet)
  end
  if do_battle_log then
    btlog("    %s got buff:%s (%.1fs)", self.owner.info.Name, self.info.Name, self.info.Time or "nil")
  end
end

class.onAddedServer = onAddedServer

local function isMorBuffLock(name, buff)
  local isLock = true
  if name ~= "Mor" then
    isLock = false
  end
  local tb = {
    "MorSwitchShader_R",
    "MorSwitchShader_G",
    "MorShader_E",
    "MorShader_G",
    "MorShader_R",
    "InvisibleShader",
    "MorNewSwitchShader_R",
    "MorNewSwitchShader_G",
    "MorFashionShader_R"
  }
  for _, value in ipairs(tb) do
    if value == buff then
      isLock = false
    end
  end
  return isLock
end

class.isMorBuffLock = isMorBuffLock

local function hasInvisibleShader(hero)
  local has = false
  local shaderList = hero.actor.shader_stack
  if shaderList then
    for _, value in ipairs(shaderList) do
      if value == "InvisibleShader" then
        has = true
      end
    end
  end
  return has
end

class.hasInvisibleShader = hasInvisibleShader

function class:playTextAnimation()
  local actor = self.owner.actor
  if actor then
    local info = self.info
    local str, color
    if info.AD > 0 or 0 < info["AD.a"] or 0 < info.POAD then
      str = "inc_attack"
      color = self.owner.camp == ed.emCampPlayer and "blue" or "red"
    elseif info.AD < 0 or 0 > info["AD.a"] or 0 > info.POAD then
      str = "dec_attack"
      color = self.owner.camp == ed.emCampPlayer and "red" or "blue"
    end
    if 0 < info.ARM or 0 < info["ARM.a"] then
      str = "inc_armor"
      color = self.owner.camp == ed.emCampPlayer and "blue" or "red"
    elseif 0 > info.ARM or 0 > info["ARM.a"] then
      str = "dec_armor"
      color = self.owner.camp == ed.emCampPlayer and "red" or "blue"
    end
    if 0 < info.HAST or 0 < info["HAST.a"] then
      str = "haste"
      color = self.owner.camp == ed.emCampPlayer and "blue" or "red"
    elseif 0 > info.HAST or 0 > info["HAST.a"] then
      str = "slow"
      color = self.owner.camp == ed.emCampPlayer and "red" or "blue"
    end
    if info["Popup Text"] then
      str = info["Popup Text"]
      color = self.caster.camp == ed.emCampPlayer and "blue" or "red"
    end
    if str and color and not self.notPopupWords then
      ed.PopupCreate(str, color, self.owner.actor, nil, "text")
    end
  end
end

local function onAddedClient(self, withTextAnim)
  local owner = self.owner
  local actor = owner.actor
  withTextAnim = withTextAnim == nil and true or withTextAnim
  if actor then
    if self.effect_id then
      actor.puppet:removeEffectWithID(self.effect_id)
    end
    if self.shader_id then
      actor:removeShader(self.shader_id)
    end
    if self.scale_id then
      actor:removeScale(self.scale_id)
    end
    local info = self.info
    if info.Effect then
      self.effect_id = actor:addEffect(info.Effect, info["Effect Zorder"])
    end
    self:LockRotate()
    if not self.hasInvisibleShader(self.owner) and not self.isMorBuffLock(owner.name, info.Shader) and (owner.name ~= "Witness" or self.caster and owner == self.caster) and info.Shader then
      self.shader_id = actor:pushShader(info.Shader)
    end
    if #info["Actor Scale"] ~= 0 then
      self.scale_id = actor:useScale(info["Actor Scale"])
    end
    if withTextAnim then
      self:playTextAnimation()
    end
  end
end

class.onAddedClient = onAddedClient

function class:LockRotate()
  local info = self.info
  local owner = self.owner
  local actor = owner.actor
  if info["Not Rotate"] == "YES" and self.effect_id then
    local effect = actor:getEffectById(self.effect_id)
    local scaleX = effect:getScaleX()
    effect:setScaleX(scaleX * actor.model.direction)
  end
end

local function onRemoved(self)
  if do_battle_log then
    btlog("%s lost buff:%s", self.owner.info.Name, self.info.Name)
  end
  if self.puppet_id then
    self.owner:removePuppet(self.puppet_id)
    self.puppet_id = nil
  end
  local actor = self.owner.actor
  if actor then
    local info = self.info
    if self.effect_id and actor.puppet then
      local a = actor.puppet:removeEffectWithID(self.effect_id)
    end
    if self.shader_id then
      actor:removeShader(self.shader_id)
    end
    if self.scale_id then
      actor:removeScale(self.scale_id)
    end
  end
  if self.info and self.info["AffectSkill Tag"] then
    self.owner:unAffectField(self.info)
  end
  if self.info.ReverseHealRatio ~= 0 then
    local owner = self.owner
    owner.Reverse_Heal = false
  end
  local config = {buff = self}
  ed.engine:listerRemoveBuff(config)
end

class.onRemoved = onRemoved

local function removeEffectAndShader(self)
  local actor = self.owner.actor
  if actor then
    local info = self.info
    if self.effect_id then
      actor.puppet:removeEffectWithID(self.effect_id)
      self.effect_id = nil
    end
    if self.shader_id then
      actor:removeShader(self.shader_id)
      self.shader_id = nil
    end
  end
end

class.removeEffectAndShader = removeEffectAndShader

local function onDamaged(self, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = self.info
  local owner = self.owner
  local skill = skill
  field = field and field or "hp"
  if not self.shield then
    return damage
  elseif not self.info["No Pass"] == true and (skill and skill.info["Ignore Shield"] == true or damageinfo and damageinfo["Ignore Shield"]) then
    return damage
  else
    local block = false
    local stype = info["Shield Type"]
    if field == "mp" then
      if stype == "mp" then
        self.shield = self.shield - damage
        if self.shield < 0 then
          self.owner:removeBuff(self)
          return -self.shield
        end
        if owner.actor then
          local color = owner.camp == ed.emCampPlayer and "blue" or "red"
          ed.PopupCreate("immune", color, owner.actor, nil, "text")
        end
        return 0
      else
        return damage
      end
    elseif stype == damage_type or stype == "all" then
      self.shield = self.shield - damage
      if self.shield < 0 then
        self.owner:removeBuff(self)
        return -self.shield
      end
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        local str = {
          AD = "physical_immune",
          AP = "magic_immune",
          all = "immune"
        }
        ed.PopupCreate(str[stype] or "immune", color, owner.actor, nil, "text")
      end
      return 0
    end
  end
  return damage
end

class.onDamaged = onDamaged

local function upgrade(self, owner, caster, nextBuffInfo)
  local isMaxLevel
  if self.rank < self.info["Max Stack Times"] then
    self.rank = self.rank + 1
    local one_stack = nextBuffInfo
    local info = self.info
    for name, _ in pairs(self.attrib) do
      if info[name] then
        info[name] = info[name] + one_stack[name]
      end
      if info[name .. ".a"] then
        info[name .. ".a"] = info[name .. ".a"] + one_stack[name .. ".a"]
      end
    end
  else
    isMaxLevel = true
  end
  self.timer = getBuffDur(self.info, owner, caster)
  return self, isMaxLevel
end

class.upgrade = upgrade

local function checkResistAttribute(buffInfo, attribs)
  if not attribs then
    return true
  end
  local attribName = buffInfo["Resist Attribute"]
  if attribName and attribs[attribName] then
    local randValue = ed.rand()
    if randValue < attribs[attribName] / 100 then
      return false
    end
  end
  return true
end

local function checkLevel(buffInfo, skillLevel, targetLevel, target_attribs, caster_attribs)
  local dice = buffInfo["Level Check Dice"]
  if dice == 0 then
    return true
  end
  local checklevel, checkprecent
  local effecthitlevel = skillLevel + (caster_attribs.EHIT and caster_attribs.EHIT or 0)
  local effectmisslevel = targetLevel + (target_attribs.EMISS and target_attribs.EMISS or 0)
  if effecthitlevel >= effectmisslevel then
    return true
  end
  if effecthitlevel < effectmisslevel then
    checklevel = effectmisslevel - effecthitlevel
    checkprecent = math.max(0.3, 1 - checklevel * 0.05)
  end
  if checkprecent > ed.rand() then
    return true
  end
  return false
end

local function checkHeroTag(buffInfo, heroTag)
  local buffTag = buffInfo["TargetHero Tag"]
  if not buffTag then
    return true
  end
  return ed.isElementInTable(buffTag, heroTag)
end

local function checkAddBuff(buffInfo, skillLevel, target, caster)
  if not target or not buffInfo then
    return false
  end
  local levelPass = checkLevel(buffInfo, skillLevel, target.level, target.attribs, caster.attribs)
  if not levelPass then
    return false, "level"
  end
  local resistPass = checkResistAttribute(buffInfo, target.attribs)
  if not resistPass then
    return false, "resist"
  end
  if target.what ~= "ChessUnit" and target.what ~= "SoloUnit" then
    local tagPass = checkHeroTag(buffInfo, ed.getHeroTags(target.proto))
    if not tagPass then
      return false, "tag"
    end
  end
  return true
end

class.checkAddBuff = checkAddBuff

local function pretreatment(self)
end

class.pretreatment = pretreatment

function ed.wrapBuffInfo(caster, owner, info)
  if not caster then
    return info
  end
  return info
end

local function setAttribute(self, name, value)
  if not self.attrib[name] then
    for i, attribName in ipairs(ed.attrib_names) do
      if attribName == name or attribName .. ".a" == name then
        self.attrib[attribName] = true
        break
      end
    end
  end
  if not self.info.warpTable then
    local newinfo = {warpTable = true}
    setmetatable(newinfo, {
      __index = self.info
    })
    self.info = newinfo
  end
  if self.caster and self.caster.attribute_ratio and type(value) == "number" then
    if name ~= "PIMU" and name ~= "MIMU" or not (100 <= value) then
      self.info[name] = value * self.caster.attribute_ratio
      self.Witness_modified = true
    else
      self.info[name] = value
    end
  else
    self.info[name] = value
  end
end

class.setAttribute = setAttribute

function class:setHealAffect(heal_affect)
  self.heal_affect = heal_affect
end

function class:isVisible()
  local campHide = self.info["Camp Unvisible"]
  if not campHide then
    return true
  end
  if campHide == 0 then
    return true
  end
  return self.caster.camp ~= ed.emCampEnemy or campHide ~= ed.emCampEnemy
end

local function checkExtraDamageCondition(self, source, damage_type, power)
  return true, nil
end

class.checkExtraDamageCondition = checkExtraDamageCondition

function class:setUnRemoveable(flag)
  self.unremoveable = flag
end

function class:isUnRemoveable()
  return self.unremoveable
end

local class = {
  mt = {}
}
ed.BuffManager = class
class.mt.__index = class

local function BuffManagerCreate(ower)
  local self = {ower = ower, invisible = false}
  setmetatable(self, class.mt)
  return self
end

ed.BuffManagerCreate = BuffManagerCreate
class.BuffManagerCreate = BuffManagerCreate

local function checkStealth(self)
  local ower = self.ower
  if ower.buff_effects.stealth and not ower.buff_effects.antistealth and not self.invisible then
    self.invisible = true
    if ed.run_with_scene and ower.actor and ower.name ~= "SA" then
      ower.actor:usePuppet()
    end
  end
  if (not ower.buff_effects.stealth or ower.buff_effects.stealth and ower.buff_effects.antistealth) and self.invisible then
    self.invisible = false
    if ed.run_with_scene and ower.actor and ower.name ~= "SA" then
      ower.actor:usePuppet()
    end
  end
end

class.checkStealth = checkStealth
