require("ui_new/common/parameter/parameter")
overwrite_unit_script = {}
local ed = ed
local string = string
local math = math
local Unit = {
  mt = {}
}
ed.Unit = Unit
Unit.mt.__index = Unit
local base = ed.Entity
setmetatable(Unit, base.mt)
local gravity = -1800
Unit.gravity = gravity
local state_to_string = {
  [ed.emUnitState_Idle] = "Idle",
  [ed.emUnitState_Walk] = "Walk",
  [ed.emUnitState_Attack] = "Attack",
  [ed.emUnitState_Hurt] = "Hurt",
  [ed.emUnitState_Dead] = "Dead",
  [ed.emUnitState_Birth] = "Birth",
  [ed.emUnitState_Dying] = "Dying"
}
ed.state_to_string = state_to_string

local function getUnitInfo(IDorName, level, rank)
  local uinfo = ed.getDataTable("Unit")[IDorName]
  local info = {}
  for k, v in pairs(uinfo) do
    info[k] = v
  end
  local id = info.ID
  local equipInfo = ed.lookupDataTable("hero_equip", nil, id, rank)
  info.equipInfo = equipInfo
  local rankInfo = ed.lookupDataTable("UnitRank", nil, id, rank)
  info.rankInfo = rankInfo
  local nextRankInfo = ed.lookupDataTable("UnitRank", nil, id, rank + 1)
  info.nextRankInfo = nextRankInfo
  return info
end

function Unit:unitWithSkill(unit_id, skill_group_id, hero)
  if not unit_id or not skill_group_id then
    return false
  end
  local hero = hero or ed.player.heroes[unit_id]
  local skills = ed.getSkillExpBase(unit_id)
  local skill
  for i = 1, #skills do
    if skills[i]["Skill Group ID"] == skill_group_id then
      skill = {
        name = skills[i]["Display Name"],
        skillName = skills[i]["Skill Name"],
        rank = skills[i].Unlock
      }
      break
    end
  end
  if not skill then
    return false
  end
  if hero._rank < skill.rank then
    return false
  end
  return true
end

function ed.getPortraitSwitchRowName(hero)
  return ed.getUnitPortrait(hero._tid)
end

function ed.getArtSwitchRowName(hero)
  return ed.getUnitArt(hero._tid)
end

function ed.getHeroTags(hero)
  local heroId = hero._tid
  local unitrow = ed.getDataTable("Unit")[heroId]
  return unitrow["Hero Tags"]
end

function ed.protoAwake(hero, tid)
  return false
end

function ed.protoSuperAwake(hero)
  return false
end

function ed.protoHasArcana(hero)
  return false
end

function ed.getProtoArcanaLevel(hero)
  return 0
end

function ed.getHeroFashion(hero)
  return hero._fashion
end

function ed.protoFashion(hero, fashion_id)
  local result = false
  if fashion_id then
    local itemId = ed.getDataTable("Fashion")[fashion_id]["Item ID"]
    if itemId and 0 < itemId then
      return 0 < ed.player.equip_qunty[itemId]
    end
  end
  return result
end

local function isMercenary(self)
  return self.mercenaryData ~= nil
end

Unit.isMercenary = isMercenary

local function setMercenaryData(self, data)
  self.mercenaryData = data
end

Unit.setMercenaryData = setMercenaryData

local function getMercenaryData(self)
  return self.mercenaryData
end

Unit.getMercenaryData = getMercenaryData

local function initHpMpInfo(self, bFinalInit)
  if self.what == "petUnit" then
    return
  end
  if self.hpmpInited then
    return
  end
  local hpPecent = 1
  local mpPecent = 0
  local dynaData = self.dynaData
  if dynaData then
    hpPecent = dynaData._hp_perc and dynaData._hp_perc / 10000 or 1
    mpPecent = dynaData._mp_perc and dynaData._mp_perc / 10000 or 0
    self.custom_data = dynaData._custom_data
  end
  self.hp = self.attribs.HP * hpPecent
  if not self.monster_idx then
    self.mp = self.attribs.MP * mpPecent
  end
  if bFinalInit then
    self.hpmpInited = true
  end
end

Unit.initHpMpInfo = initHpMpInfo

function Unit:initBattleBonus(battleBonus)
end

function Unit:initFancyAbyssBonus(buffId)
  self.fancyAbyssBuffId = buffId
end

function Unit:getAwakeStageBonus(awakeStageBonus)
  local attrs = {}
  local awakeStageBonus = awakeStageBonus or self.awakeStageBonus or {}
  local level = awakeStageBonus.level
  local maxLevel = awakeStageBonus.maxLevel
  local groupId = awakeStageBonus.groupId
  if groupId and level and maxLevel then
    local tb = ed.getDataTable("LevelAttributes")[groupId][self.info.ID]
    local paragonLevelCfg = ed.getDataTable("ParagonLevel")[groupId]
    local haveWeight = 0
    local totalWeight = 0
    for paragonLevel, levelCfg in ipairs(paragonLevelCfg or {}) do
      if paragonLevel <= level then
        haveWeight = haveWeight + levelCfg.Weight
      end
      totalWeight = totalWeight + levelCfg.Weight
    end
    for attrName, attrNum in pairs(tb or {}) do
      if totalWeight ~= 0 and 0 < attrNum then
        attrs[attrName] = attrNum * haveWeight / totalWeight
      end
    end
    for paragonLevel, paragonLevelCfg in ipairs(paragonLevelCfg or {}) do
      if paragonLevel > level then
        break
      end
      local extraAttrIDList = paragonLevelCfg.ExtraAttributes
      for index, extAttrID in ipairs(extraAttrIDList or {}) do
        local extAttrCfg = ed.getDataTable("ExtraAttributes")[extAttrID]
        if self.info.ID == extAttrCfg.UnitID then
          for attrName, attrNum in pairs(extAttrCfg) do
            if attrName ~= "UnitID" and attrName ~= "ID" and 0 < attrNum then
              attrs[attrName] = (attrs[attrName] or 0) + attrNum
            end
          end
        end
      end
    end
  end
  return attrs
end

function Unit:initAwakeStageBonus(awakeStageBonus)
  local attrInfo = self:getAwakeStageBonus(awakeStageBonus)
  local attribs = self.fixed_attribs
  for attrName, attrNum in pairs(attrInfo or {}) do
    attribs[attrName] = (attribs[attrName] or 0) + attrNum
  end
end

function Unit:initRogueWaveBonus()
  local attribs = self.fixed_attribs
  local rogueWaveBonus = self.rogueWaveBonus or {}
  attribs.LevelPIMU = (attribs.LevelPIMU or 0) + (rogueWaveBonus.LevelPIMU or 0)
  attribs.LevelMIMU = (attribs.LevelMIMU or 0) + (rogueWaveBonus.LevelMIMU or 0)
  attribs.MP = (attribs.MP or 0) + (rogueWaveBonus.MP or 0)
  attribs.TEN = (attribs.TEN or 0) + (rogueWaveBonus.TEN or 0)
  attribs.DOTRES = (attribs.DOTRES or 0) + (rogueWaveBonus.DOTRES or 0)
  attribs.EMISS = (attribs.EMISS or 0) + (rogueWaveBonus.EMISS or 0)
end

function Unit:initRogueTreeBonus()
  local attribs = self.fixed_attribs
  local rogueTechBonusList = self.rogueTechBonus or {}
  for _, rogueTechBonus in ipairs(rogueTechBonusList) do
    local attribsList = rogueTechBonus.Attribs or {}
    local valueList = rogueTechBonus.Value or {}
    for index = 1, #attribsList do
      local attr = attribsList[index]
      local value = valueList[index]
      attribs[attr] = (attribs[attr] or 0) + value
    end
  end
end

function Unit:resetFancyAbyssBuffs()
  if self.fancyAbyssBuffId then
    local buffTb = ed.getDataTable("Buff")
    local buffRow = buffTb[self.fancyAbyssBuffId]
    if not buffRow then
      error("fancyabyss tower buff does not exist, id = " .. tostring(self.fancyAbyssBuffId))
    end
    self:addBuff(buffRow, self)
  end
end

local function UnitCreate(proto, camp, config, extraData, warschool, bookReadingLevel, battleBonus, specialBonus)
  local self = base.create()
  config = config or {}
  self.what = config.what or "Unit"
  setmetatable(self, Unit.mt)
  config.hp_mod = config.hp_mod or 1
  config.dps_mod = config.dps_mod or 1
  config.imu_mod = config.imu_mod or 1
  config.arm_mod = config.arm_mod or 1
  config.mr_mod = config.mr_mod or 1
  local scale = ed.engine.unitScale or 1
  config.size_mod = config.size_mod or scale
  config.money = config.money or 0
  self.mealParam = config.meal
  self.config = config
  self.dynaData = extraData
  self.proto = proto
  self.tid = proto._tid
  self.stars = proto._stars or 1
  self.level = proto._level
  self.unique_id = config.unique_id or tostring(self.tid + ed.rand())
  if specialBonus then
    self.awakeStageBonus = specialBonus.awakeStageBonus
    self.rogueWaveBonus = specialBonus.rogueWaveBonus
    self.rogueTechBonus = specialBonus.rogueTechBonus
  end
  if config.estimate_rank then
    if proto._rank and 0 < proto._rank then
      self.rank = math.floor(proto._rank)
      self.rank_ratio = 0
    else
      self.rank = math.floor((self.level + 9) / 10)
      self.rank_ratio = (self.level - 1) % 10 / 10
      if self.rank > ed.parameter.unit_max_rank and config.is_monster == false then
        self.rank = ed.parameter.unit_max_rank
        self.rank_ratio = 0
      end
    end
  elseif config.estimate_max_rank then
    self.rank = self:getMaxRankLevel()
    self.rank_ratio = 0
  elseif config.rank_limit and 0 < config.rank_limit then
    self.rank = math.min(config.rank_limit, proto._rank)
    self.rank_ratio = 0
  else
    self.rank = math.floor(proto._rank)
    self.rank_ratio = 0
  end
  self.info = getUnitInfo(proto._tid, proto._level, self.rank)
  self.name = self.info.Name
  self.camp = camp or ed.emCampPlayer
  self.foecamp = -self.camp
  self.radius = self.info["Collide Radius"] * config.size_mod
  self.money = config.money
  self.equips = {}
  if proto._fashion and proto._fashion ~= 0 then
    self.fashion_id = proto._fashion
  end
  
  local function addEquip(item)
    if not item then
      return
    end
    local id = item._item_id
    if 0 < id then
      local info = ed.lookupDataTable("equip", nil, id)
      local level = ed.equipLvFromExp(id, item._exp)
      local titanEquipLevel = 0
      table.insert(self.equips, ed.wraptable(info, {level = level}))
    end
  end
  
  if config.estimate_max_rank then
    local items = ed.lookupDataTable("hero_equip", nil, self.info.ID, self.rank)
    if items then
      for index = 1, 6 do
        local eid = items["Equip" .. index .. " ID"]
        if eid and 0 < eid then
          local rl = ed.getDataTable("equip")[eid]["Level Requirement"]
          if rl <= self.level then
            local info = ed.lookupDataTable("equip", nil, eid)
            local level = ed.equipLvFromExp(eid, 20000)
            table.insert(self.equips, ed.wraptable(info, {level = level}))
          end
        end
      end
    end
  elseif not config.estimate_rank and not config.ignore_equip then
    for i = 1, #(proto._items or {}) do
      local item = proto._items[i]
      addEquip(item)
    end
  end
  local current_puppet = self.info.Puppet
  current_puppet = self.fashion_id and ed.lookupDataTable("Fashion", "Puppet", self.fashion_id) or current_puppet
  self.puppet_stack = {current_puppet}
  self.previous_position = {0, 0}
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
  self.san_point = 1000
  self.walk_speed_multiplier = 1
  self.ai = ed.createAiForUnit(self)
  self.global_cd = 0
  self.current_skill = nil
  self.last_stolen_skill = nil
  self.last_stolen_skill_puppet = nil
  self.idleName = "Idle"
  self.manually_casting = false
  self.action_name = nil
  self.action_loop = false
  self.action_duration = 0
  self.action_elapsed = 0
  self.push_interval_tick = 4
  self.speeder = 1
  self.buff_list = {}
  self.buffManager = ed.BuffManagerCreate(self)
  self.rogueBlessList = {}
  self.hp_low = false
  self.mp_low = false
  self.actor = nil
  self.can_cast_manual = false
  self.walk_time = 0
  self.pet = nil
  self.legendEquip = nil
  self.hpLayer = self.info["HP Layers"]
  self.bossIconName = self.info["Boss Portrait"]
  self.actionStageId = self.info["Period Group"]
  self.dPSStatisticsRatio = self.info["DPS Statistics Ratio"] or 1
  self.battledata = battledata:new()
  self.killer = nil
  self.taunter = nil
  self.detaunter = nil
  self.firstManualCast = true
  self.controlTarget = nil
  self.controlCamp = nil
  self.controlledTarget = nil
  self.unitonDying = false
  self.daytype = "day"
  self:initPetAttr()
  self:initPet()
  self:initSkill()
  self:initLegendEquip()
  if battleBonus then
    self:initBattleBonus(battleBonus)
  end
  self:rebuild("rebuild", self.mealParam)
  self:applyBuffEffects()
  initHpMpInfo(self)
  if not config.pre_select then
    local script = ed.getUnitScript(self.tid)
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
  if self.actionStageId ~= nil then
    self:getActionStageInfo()
  end
  return self
end

Unit.create = UnitCreate
ed.UnitCreate = UnitCreate

function Unit:startWork()
  self:applyAuraSkill()
end

function Unit:getPetAddtion(type, typeid, evolve)
  local row = ed.getDataTable("Pet")[typeid]
  local STRAddtion = 0
  for i = 1, evolve do
    STRAddtion = STRAddtion + row["UP " .. type .. i .. " Ratio"]
  end
  return STRAddtion
end

function Unit:initPet()
  local pet = self.proto._pet
  if not pet then
    return
  end
  self.pet = ed.petUnitCreate(pet, self.camp, {owner = self}, nil)
end

function Unit:initPetAttr()
  local pet = self.proto._pet
  if not pet then
    return
  end
  self.petExtraAttRatio = {}
  local dt = ed.getDataTable("Pet")[pet._type_id]
  local ratio = self.petExtraAttRatio
  local prt = 100
  local talents = pet._talents or {}
  local add = 0
  for k, v in ipairs(talents) do
    if v == 2 then
      add = 2
    end
  end
  ratio.STR = (dt["STR Base Ratio"] + pet._level * dt["STR Enhance Ratio"] + add) / prt
  ratio.INT = (dt["INT Base Ratio"] + pet._level * dt["INT Enhance Ratio"] + add) / prt
  ratio.AGI = (dt["AGI Base Ratio"] + pet._level * dt["AGI Enhance Ratio"] + add) / prt
end

local campDesc = {
  [1] = "+",
  [0] = "0",
  [-1] = "-",
  [2] = "N"
}

local function display(self)
  local camp = self.camp
  if ed.engine.isRealTimeMode and ed.engine:isRealTimeMode() and not battle_tick:getHost() then
    camp = -camp
  end
  return string.format("%s[%s%s]%s", self.what, campDesc[camp], self:isAlive() and "" or "D", self.name)
end

Unit.display = display

function Unit.mt:__tostring()
  local cdesc = string.format("%.1f", self.global_cd or 0)
  for i, skill in ipairs(self.skill_list or {}) do
    cdesc = string.format("%s|%.1f", cdesc, skill.cd_remaining)
  end
  local ballInfo = ""
  if self.deliveredBalls then
    for k, v in pairs(self.deliveredBalls) do
      ballInfo = ballInfo .. " " .. v.balltype
    end
  end
  local myballinfo = ""
  if self.energy_ball_manager then
    for k, v in ipairs(self.energy_ball_manager.slots) do
      myballinfo = myballinfo .. " " .. v.ballType
    end
  end
  return string.format("%s*%dL%d\tHP:%.30f/%.18f\tMP:%d\t(%d, %d)\t%s\t@%s:%.1f [%s] %s%s%s%s%s%s  Ball:%s MyBalls:%s GlobalCD:%s\n", self:display(), self.stars or 0, self.level or 0, self.hp or 0, self.attribs.HP or 0, self.mp or 0, self.position[1], self.position[2], state_to_string[self.state] or "nil", self.action_name or "nil", self.action_elapsed or 0, "", self.buff_effects.silence and "S" or "", self.buff_effects.disarm and "D" or "", self.buff_effects.immoblilize and "I" or "", (self.buff_effects.building or self.buff_effects.building_notfix) and "B" or "", self.buff_effects.stable and "ST" or "", self.buff_effects.fix and "F" or "", ballInfo, myballinfo, cdesc)
end

function Unit:useFury(fury_count)
  table.insert(self.fury_stack, fury_count)
  self.friendly_damage_discount = fury_count
  return #self.fury_stack
end

function Unit:removeFury(fury_id)
  local stack = self.fury_stack
  if fury_id > #stack then
    return
  end
  stack[fury_id] = ""
  while stack[#stack] == "" do
    stack[#stack] = nil
  end
  if #stack == 0 then
    self.friendly_damage_discount = nil
  else
    self.friendly_damage_discount = stack[#stack]
  end
end

local function calculateSKLAttri(self)
  local SKL = 0
  local name = "SKL"
  local info = self.info
  local rankInfo = info.rankInfo
  local field = name
  if self.config.estimate_rank then
    field = "E." .. name
  end
  SKL = rankInfo and rankInfo[field] or 0
  local equips = self.equips
  for i = 1, #equips do
    local info = equips[i]
    local lv = info.level
    local value = (info[name] or 0) + (info["+" .. name] or 0) * lv
    SKL = SKL + value
  end
  return SKL
end

local function sortActiveSkill(self)
  table.sort(self.skill_list, function(a, b)
    if a.info.Priority == b.info.Priority and a ~= b then
      print(T("%s:%d %d has the same priority", self.info.Name, a.info.Slot, b.info.Slot))
      EDDebug()
    end
    return a.info.Priority > b.info.Priority
  end)
end

Unit.sortActiveSkill = sortActiveSkill

local function initSkill(self)
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
  local uid = self.info.ID
  local SKL = calculateSKLAttri(self)
  for slot, group in pairs(ed.getDataTable("SkillGroup")[uid]) do
    local unlock = group.Unlock
    if config.is_monster then
      unlock = group["Unlock For Monster"]
    end
    if config.is_summoned_by_DS then
      unlock = group["Unlock For summoned_by_DS"]
    end
    if unlock > self.rank then
    else
      local skill_level = 0
      if config.estimate_max_rank then
        skill_level = math.floor(self.level) + SKL
      elseif config.estimate_skill then
        skill_level = math.floor(self.level)
      elseif self.proto._skill_levels then
        skill_level = (self.proto._skill_levels[slot] or 0) + SKL
        local parentSkill = group["Subordinate To"]
        if parentSkill ~= 0 then
          local newSlot = ed.getSkillSlotId(uid, parentSkill)
          skill_level = (self.proto._skill_levels[newSlot] or 0) + SKL
        end
      end
      if group["Skill Group ID"] == info["Basic Skill"] then
        skill_level = 1
      end
      if skill_level <= 0 then
      else
        local skill_info = ed.Skill.getSkillInfo(group, skill_level)
        local active_type = skill_info["Active Type"]
        if active_type == "active" then
          local skill = ed.SkillCreate(skill_info, self, skill_level)
          table.insert(skill_list, skill)
          skills[skill.info["Skill Group ID"]] = skill
          skills[skill.info["Skill Name"]] = skill
          if skill_info.Manual then
            self.manual_skill = skill
          end
        else
          skill_info.level = skill_level
          skill_info.evo_rank = 0
          skill_info.evo_rank1 = {}
          skill_info.evo_rank2 = {}
          skill_info.evo_rank3 = {}
          if ed.getDataTable("SkillEvo")[skill_info["Skill Group ID"]] then
            for rank = 1, 3 do
              skill_info["evo_rank" .. rank] = ed.getDataTable("SkillEvo")[skill_info["Skill Group ID"]][rank] or {}
              if skill_level >= (skill_info["evo_rank" .. rank]["EvoSkill UnlockLevel"] or 999) then
                skill_info.evo_rank = rank
              end
            end
          end
          if active_type == "passive" then
            table.insert(self.passive_skill_list, skill_info)
          elseif active_type == "aura" then
            table.insert(self.aura_skill_list, skill_info)
          elseif active_type == "negative_aura" then
            table.insert(self.effect_enemy_aura_skill_list, skill_info)
          end
        end
      end
    end
  end
  if self.what == "petUnit" then
  else
    local basic_skill = skills[info["Basic Skill"]]
    self.basic_skill = basic_skill
    self.attack_range = basic_skill.info["Max Range"] - 5
  end
  self:sortActiveSkill()
end

Unit.initSkill = initSkill

function Unit:initLegendEquip()
  if self.config.ignore_legend_equip then
    return
  end
  self.legendEquip = nil
  local heroLegendEquip = self.proto._legend_equip
  if not heroLegendEquip then
    return
  end
  local legendEquip = heroLegendEquip._equip
  if not legendEquip then
    return
  end
  self.legendEquip = ed.legendEquipCreate(legendEquip, self.camp, self)
end

function Unit:applyAuraSkill()
  if #self.aura_skill_list > 0 then
    for unit in ed.engine:foreachAliveUnit(self.camp) do
      unit:rebuild()
    end
  end
  if 0 < #self.effect_enemy_aura_skill_list then
    for unit in ed.engine:foreachAliveUnit(-self.camp) do
      unit:rebuild()
    end
  end
end

local function getMaxRankLevel(self)
  local tmpRank = 1
  local maxRank = ed.parameter.unit_max_rank
  for rankLevel = 1, maxRank do
    local id = ed.getDataTable("Unit")[self.tid].ID
    local lvReq = ed.lookupDataTable("hero_equip", "LvReq", id, rankLevel)
    if lvReq <= self.level then
      if rankLevel < maxRank then
        tmpRank = rankLevel + 1
      else
        tmpRank = maxRank
      end
    end
  end
  return tmpRank
end

Unit.getMaxRankLevel = getMaxRankLevel

function Unit:getUnitUnion()
  local union = self.info.Union
  return union or nil
end

Unit.UnionNo = {
  Nature = 1,
  Legend = 2,
  Galaxy = 3,
  Holy = 4,
  Dark = 5
}

function Unit:getInitDir()
  if battle_tick.getRealTimePvp and battle_tick.getRealTimePvp() then
    local bHost = battle_tick.getHost()
    return bHost and self.camp or -1 * self.camp
  else
    return self.camp
  end
end

function Unit:getFixDir()
  local dir = self:getInitDir()
  return dir
end

local function getActionStageInfo(self)
  if self.actionStageId then
    local nStage = 1
    self.actionStageInfos = {}
    while true do
      local stageData = ed.lookupDataTable("Period", nil, self.actionStageId, nStage)
      if stageData then
        table.insert(self.actionStageInfos, stageData)
        nStage = nStage + 1
      else
        break
      end
    end
  end
end

Unit.getActionStageInfo = getActionStageInfo

local function checkActionStageValid(self, condtion)
  local bRet = false
  if condtion then
    local TriggerType = condtion["Trigger Type"]
    if TriggerType == "HP" then
      local conditionValue = condtion["HP Ratio"] / 100
      local hpValue = self.hp / self.attribs.HP
      if conditionValue >= hpValue then
        bRet = true
      end
    end
  end
  return bRet
end

Unit.checkActionStageValid = checkActionStageValid

local function enterActionStageFromOneStage(self, nStage, tid)
  if tid and tid == 85 then
    EDDebug("Rubick change Action Stage error\239\188\129Please change the id to the direct number\239\188\129")
  end
  if not self.isActionStageChangeByManual then
    local actionStage = nStage
    if self.currentActionStage and actionStage <= self.currentActionStage then
      return
    end
    if actionStage then
      self.currentActionStage = actionStage
      self:enterActionStage(self.currentActionStage)
    end
  else
    self.currentActionStage = nStage
    self:enterActionStage(nStage)
  end
end

Unit.enterActionStageFromOneStage = enterActionStageFromOneStage

local function setActionStageChangeByManual(self, isByManual)
  self.isActionStageChangeByManual = isByManual
end

Unit.setActionStageChangeByManual = setActionStageChangeByManual

local function updateActionStage(self)
  if self.actionStageInfos and #self.actionStageInfos > 0 then
    if self.currentActionStage == nil then
      self:enterActionStageFromOneStage(1)
    elseif not self.isActionStageChangeByManual then
      local stageNum = #self.actionStageInfos
      if stageNum > self.currentActionStage then
        local condtion = self.actionStageInfos[self.currentActionStage]
        if self:checkActionStageValid(condtion) then
          self:enterActionStageFromOneStage(self.currentActionStage + 1)
        end
      end
    end
  end
end

Unit.updateActionStage = updateActionStage

local function enterActionStage(self, nStage)
  if self.actionStageId then
    local stageData = ed.lookupDataTable("Period", nil, self.actionStageId, nStage)
    if stageData then
      local puppetName = stageData["Puppet ID"]
      self:rewritePuppetStack(1, puppetName)
      self:resetSkillList(stageData)
      local translationActionName = stageData["Enter Action"]
      if translationActionName and translationActionName ~= "" then
        self:setAction(translationActionName)
      end
    end
  end
end

Unit.enterActionStage = enterActionStage

local function getActionName(self, actionName)
  local newActionName = actionName
  if self.actor and self.actor.puppet then
    newActionName = self.actor:getActionName(actionName)
  end
  return newActionName
end

Unit.getActionName = getActionName

function Unit:clearActor()
  self.actor = nil
  local bl = self.pet and self.pet:clearActor()
end

local function reset(self)
  if self:isAlive() then
    self.state = ed.emUnitState_Idle
  else
    self.state = ed.emUnitState_Dead
    self.hasCorpse = false
  end
  self.buff_effects = {}
  local oldai = self.ai
  self.ai.will_cast_manual_skill = oldai.will_cast_manual_skill
  self.global_cd = 0
  local rt = self.pet and self.pet:reset()
  self.current_skill = nil
  self.last_stolen_skill = nil
  self.last_stolen_skill_puppet = nil
  self.manually_casting = false
  self.action_name = nil
  self.action_duration = 0
  self.action_elapsed = 0
  self.unitonDying = false
  self.rogueBlessList = {}
  local oldBuffList = self.buff_list
  self.buff_list = {}
  for _, buff in ipairs(oldBuffList) do
    if buff:isUnRemoveable() then
      table.insert(self.buff_list, buff)
    end
  end
  self:resetFancyAbyssBuffs()
  for _, skill in ipairs(self.skill_list) do
    skill:reset()
  end
  if self.legendEquip then
    self.legendEquip:reset()
  end
  self:rebuild("rebuild", self.mealParam)
  self:applyBuffEffects()
  initHpMpInfo(self, true)
end

Unit.reset = reset

local function resetSkillList(self, stageData)
  self.current_skill = nil
  self.action_name = nil
  self.action_duration = 0
  self.action_elapsed = 0
  for _, skill in ipairs(self.skill_list) do
    skill:reset()
    skill:pause()
  end
  local _normalSkillId = stageData["Basic Skill"]
  local _skillList = stageData["Skill List"]
  for _, id in ipairs(_skillList) do
    id = tonumber(id)
    for _, skill in ipairs(self.skill_list) do
      if id == skill.info.groupId then
        skill:resume()
      end
    end
  end
  if self.what == "petUnit" then
  else
    local basic_skill = self.skills[_normalSkillId]
    self.basic_skill = basic_skill
    self.attack_range = basic_skill.info["Max Range"] - 5
  end
  self:rebuild()
  self:idle()
end

Unit.resetSkillList = resetSkillList

local function isHero(self)
  return self.info["Unit Type"] == "Hero" and not self.config.is_monster and not self.config.is_summoned_by_DS
end

Unit.isHero = isHero

local function battleSupply(self, coefficient)
  if not ed.engine.enableHPSAndMPS then
    return
  end
  if self.attribs.HPS > 0 then
    self:takeHeal(self.attribs.HPS)
  end
  if 0 < self.attribs.MPS then
    local mps = self.attribs.MPS * coefficient
    self:takeHeal(mps, "mp")
  end
end

Unit.battleSupply = battleSupply

local function isHasUncontrolBufEffect(self)
  local isRet = false
  if self.buff_effects.uncontrollable then
    isRet = true
  end
  return isRet
end

Unit.isHasUncontrolBufEffect = isHasUncontrolBufEffect

local function removeBuffsConlictWithUncontrol(self)
  local tempList = self.buff_list
  self.buff_list = {}
  
  local function canBeRemoved(buff)
    return buff:isCrlEftConflictWithUncontrollable() and buff.caster ~= buff.owner
  end
  
  for _, buff in pairs(tempList) do
    if canBeRemoved(buff) then
      buff:onRemoved()
      self:resetBuffApply(buff)
    else
      table.insert(self.buff_list, buff)
    end
  end
end

Unit.removeBuffsConlictWithUncontrol = removeBuffsConlictWithUncontrol

local function addBuff(self, buff_Or_Binfo, caster)
  if not self:isAlive() or not buff_Or_Binfo then
    return
  end
  local buff
  if buff_Or_Binfo.class == ed.Buff then
    buff = buff_Or_Binfo
  else
    buff = ed.BuffCreate(buff_Or_Binfo, self, caster)
  end
  local config = {buff = buff}
  ed.engine:collectBuff(config)
  buff = config.buff
  buff:pretreatment()
  if self:isHasUncontrolBufEffect() then
    self:removeBuffsConlictWithUncontrol()
    if buff:isCrlEftConflictWithUncontrollable() and buff.caster ~= buff.owner then
      return
    end
  elseif buff:isHasUnControllableEffect() then
    self:removeBuffsConlictWithUncontrol()
    local list = self.buff_list
    local debuff_list = {}
    local my_camp = self.camp
    for i = 1, #list do
      local debuff = list[i]
      if debuff and (not debuff.caster or debuff.caster.camp ~= my_camp) and debuff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = debuff
      end
    end
    for i = 1, #debuff_list do
      self:removeBuff(debuff_list[i])
    end
  end
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
    if ed.run_with_scene and buff:isVisible() then
      if self.buffNotPopupWords then
        buff.notPopupWords = true
      end
      buff:onAddedClient()
    end
  end
  if alreadyAdd and ed.run_with_scene and not isMaxcLevel then
    buff:playTextAnimation()
  end
  self.buffManager:checkStealth()
  for i, effect in ipairs(buff.info["Control Effects"]) do
    if effect == "stun" or effect == "stunbyself" then
      self:hurt()
    end
  end
  return buff
end

Unit.addBuff = addBuff

function Unit:resetBuffApply(buff)
  if buff:isImpactAttribs() then
    self:rebuild()
  end
  self:applyBuffEffects()
  self:judgeCurrentSkill(buff)
end

function Unit:applyBuffEffects()
  self.buff_effects = {}
  for _, _buff in ipairs(self.buff_list) do
    _buff:applyEffects()
  end
  if self.buff_effects.immoblilize and self.action_name == "Move" then
    self:idle()
  end
end

function Unit:getFuryValue()
  return self.san_point
end

function Unit:addRogueBless(rogueBless)
  table.insert(self.rogueBlessList, rogueBless)
end

function Unit:addSkill(casterId, slot, level)
  local group = ed.getDataTable("SkillGroup")[casterId][slot]
  local skill_info = ed.Skill.getSkillInfo(group, level)
  local addPassive, addAura, addNegativeAura
  local active_type = skill_info["Active Type"]
  if active_type == "active" then
    local skill = ed.SkillCreate(skill_info, self, level)
    table.insert(self.skill_list, skill)
    self:sortActiveSkill()
  else
    skill_info.level = level
    skill_info.evo_rank = 0
    skill_info.evo_rank1 = {}
    skill_info.evo_rank2 = {}
    skill_info.evo_rank3 = {}
    if ed.getDataTable("SkillEvo")[skill_info["Skill Group ID"]] then
      for rank = 1, 3 do
        skill_info["evo_rank" .. rank] = ed.getDataTable("SkillEvo")[skill_info["Skill Group ID"]][rank] or {}
        if level >= (skill_info["evo_rank" .. rank]["EvoSkill UnlockLevel"] or 999) then
          skill_info.evo_rank = rank
        end
      end
    end
    if active_type == "passive" then
      table.insert(self.passive_skill_list, skill_info)
      addPassive = true
    elseif active_type == "aura" then
      table.insert(self.aura_skill_list, skill_info)
      addAura = true
    elseif active_type == "negative_aura" then
      table.insert(self.effect_enemy_aura_skill_list, skill_info)
      addNegativeAura = true
    end
  end
  if addPassive then
    self:rebuild()
  elseif addAura then
    for unit in ed.engine:foreachAliveUnit(self.camp) do
      unit:rebuild()
    end
  elseif addNegativeAura then
    local camp = self.camp == ed.emCampPlayer and ed.emCampEnemy or ed.emCampPlayer
    for unit in ed.engine:foreachAliveUnit(camp) do
      unit:rebuild()
    end
  end
end

function Unit:removeSkill(casterId, slot, level)
  local group = ed.getDataTable("SkillGroup")[casterId][slot]
  local skill_info = ed.Skill.getSkillInfo(group, level)
  local active_type = skill_info["Active Type"]
  local old_metatable = getmetatable(skill_info).__index
  if active_type == "active" then
    local skillIndex
    for i = 1, #self.skill_list do
      local skill = self.skill_list[i]
      if old_metatable == getmetatable(skill.info).__index then
        skillIndex = i
        break
      end
    end
    if skillIndex then
      table.remove(self.skill_list, skillIndex)
    end
  end
end

local function removeBuff(self, buff)
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
  self.buffManager:checkStealth()
end

Unit.removeBuff = removeBuff

local function removeAllBuffs(self)
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
  self.buffManager:checkStealth()
end

Unit.removeAllBuffs = removeAllBuffs

local function removeSignedBuffer(self)
  local function canBeRemoved(buff)
    return buff.clearOnDeathFlag
  end
  
  local tmpList = self.buff_list
  self.buff_list = {}
  for i, buff in ipairs(tmpList) do
    if canBeRemoved(buff) then
      buff:onRemoved()
      self:resetBuffApply(buff)
    else
      table.insert(self.buff_list, buff)
    end
  end
  self:rebuild()
  self:applyBuffEffects()
  self:judgeCurrentSkill()
  self.buffManager:checkStealth()
end

Unit.removeSignedBuffer = removeSignedBuffer

local function setAction(self, action_name, loop, interrupt)
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

Unit.setAction = setAction

local function setHP(self, hp, reason)
  local config = {
    unit = self,
    hp = hp,
    hp_change = hp - self.hp,
    reason = reason or "nil"
  }
  ed.engine:collectHPchange(config)
  local hp = config.hp
  local hp_change = config.hp_change
  if hp > self.attribs.HP then
    hp = self.attribs.HP
  end
  if hp < 0 then
    hp = 0
  end
  self.hp = hp
  return hp_change
end

Unit.setHP = setHP

local function setMP(self, mp)
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
  local extra = mp - self.mp
  local IsMultiArena = ed.IsMultiArena()
  if 0 < extra and IsMultiArena then
    mp = self.mp + extra / 2
  end
  if mp > self.attribs.MP then
    mp = self.attribs.MP
  end
  if mp < 0 then
    mp = 0
  end
  self.mp = mp
  return mp_change
end

Unit.setMP = setMP
local emUnitState_Dead = ed.emUnitState_Dead
local emUnitState_Dying = ed.emUnitState_Dying

local function isAlive(self)
  return self.state ~= emUnitState_Dead and self.state ~= emUnitState_Dying
end

Unit.isAlive = isAlive

function Unit:canFly()
  return self.info["Can Fly"]
end

local updateSkillAi = ed.Ai.updateSkillAi

local function checkPush(self)
  if self:canFly() then
    return
  end
  local list = ed.engine.rect_cut
  if list.isEmpty() then
    return
  end
  for _, rect in ipairs(list.getList()) do
    local pos = self.position
    local rds = self.radius + rect[3] / 2
    local lx = pos[1] - rect[1]
    local ly = pos[2] - rect[2]
    if rds > math.abs(lx) then
      pos[1] = 0 < lx and pos[1] + rds - lx or pos[1] - (rds + lx)
    end
    if rds > math.abs(ly) then
      pos[2] = 0 < ly and pos[2] + rds - ly or pos[2] - (rds + ly)
    end
  end
end

Unit.checkPush = checkPush

local function update(self, dt)
  local attribs = self.attribs
  local MSPD = attribs.MSPD
  if self.manually_casting or self.current_skill and self.current_skill.info["No Speeder"] then
    MSPD = 0
  end
  if self.config.is_boss and MSPD < -75 then
    attribs.MSPD = -75
  end
  MSPD = attribs.MSPD
  local speeder = 0 <= MSPD and (MSPD + 100) / 100 or 100 / (100 - MSPD)
  self.speeder = speeder
  local dt_action = dt * speeder
  self.dt_action = dt_action
  local action_end = false
  if self.action_name and not self.action_loop then
    local elapsed = self.action_elapsed + dt_action
    local duration = self.action_duration
    if 0 < duration and elapsed > duration then
      action_end = true
      elapsed = elapsed - duration
      self:onActionFinished()
    end
    self.action_elapsed = elapsed
  end
  if not isAlive(self) then
    return
  end
  if self.state == ed.emUnitState_Walk and self.controlledTarget then
    self.walk_time = self.walk_time - dt_action
    if 0 > self.walk_time then
      self:onActionFinished()
    end
  end
  local movable = not self.buff_effects.immoblilize
  if self.buff_effects.fear and movable and not self.buff_effects.stable then
    self:fearWalk()
  end
  local pos = self.position
  self.previous_position[1] = self.position[1]
  self.previous_position[2] = self.position[2]
  local v1 = movable and self.walk_v or ed.edpZero
  local v2 = self.knockup_v
  local v = self.velocity
  v[1] = v1[1] + v2[1]
  v[2] = v1[2] + v2[2]
  if self.buff_effects.fix then
    self.direction = self:getFixDir()
  else
    local direction = 0
    if movable and v1[1] ~= 0 then
      direction = v1[1]
    elseif self.current_skill and self.current_skill.target and not self.current_skill.casterDirectionLocked then
      direction = self.current_skill.target.position[1] - pos[1]
    end
    if 0 > direction * self.direction then
      self.direction = self.direction * -1
    end
  end
  if 0 < self.knockup_time then
    self.knockup_time = self.knockup_time - dt
    if 0 >= self.knockup_time then
      self.knockup_v = {0, 0}
    end
  end
  local h = self.height
  if self.zSpeed then
    h = self.height + self.zSpeed * dt
    self.zSpeed = self.zSpeed + gravity * dt
    if h < 0 then
      self.zSpeed = nil
      h = 0
    end
    self.height = h
  end
  local stage_rect = ed.engine.stage_rect
  if not self.manual_moving then
    if 0 < v2[1] and 0 < v[1] then
      local targetPosX = pos[1] + v[1] * dt_action
      if targetPosX > stage_rect.maxX then
        local distance = math.max(stage_rect.maxX - pos[1] - 20, 0)
        if dt_action ~= 0 then
          v[1] = distance / dt_action
        end
      end
    elseif 0 > v2[1] and 0 > v[1] then
      local targetPosX = pos[1] + v[1] * dt_action
      if targetPosX < stage_rect.minX then
        local distance = math.min(stage_rect.minX - pos[1] + 20, 0)
        if dt_action ~= 0 then
          v[1] = distance / dt_action
        end
      end
    end
    if pos[1] > stage_rect.maxX - 50 and 0 < v[1] then
      v[1] = 0
    end
    if pos[1] < stage_rect.minX + 50 and 0 > v[1] then
      v[1] = 0
    end
  end
  pos[1] = pos[1] + v[1] * dt_action
  pos[2] = pos[2] + v[2] * dt_action
  checkPush(self)
  do
    local HAST = attribs.HAST
    if self.config.is_boss and HAST < -50 then
      attribs.HAST = -50
    end
    HAST = attribs.HAST
    local dt_cd = dt * (0 < HAST and (100 + HAST) / 100 or 100 / (100 - HAST))
    self.global_cd = self.global_cd - dt_cd
    local skill_list = self.skill_list
    for i = 1, #skill_list do
      skill_list[i]:update(dt_action, dt_cd)
    end
  end
  if action_end and self.state == ed.emUnitState_Attack then
    self.current_skill:onPhaseFinished()
  end
  self:updateActionStage()
  local buff_effects = self.buff_effects
  local enable_ai = self.state == ed.emUnitState_Idle or self.state == ed.emUnitState_Walk
  local enable_skill_ai
  if self.SpecialCheckEnableAi and self:SpecialCheckEnableAi() then
    enable_skill_ai = true
  end
  enable_ai = enable_ai and not buff_effects.disableAI
  enable_ai = enable_ai and ed.engine.freeze_level == 0
  enable_skill_ai = enable_skill_ai and not buff_effects.disableAI
  enable_skill_ai = enable_skill_ai and ed.engine.freeze_level == 0
  if enable_ai then
    self.ai:update(dt)
  elseif enable_skill_ai then
    updateSkillAi(self.ai, dt)
  end
  for _, buff in ipairs(self.buff_list) do
    if buff.info.ID ~= 60007315 then
      buff:update(dt)
    end
  end
  if not isAlive(self) then
    return
  end
  local mp_regen = attribs.MPR
  ed.engine.mp_bonus = ed.engine.mp_bonus
  setMP(self, self.mp + mp_regen * dt * ed.engine.mp_bonus)
  if not self.buff_effects.noHPR then
    local hp_regen = attribs.HPR
    if self.what == "lordUnit" then
      hp_regen = hp_regen * self.heal_ratio
    end
    if self.Reverse_Heal == true and 0 < hp_regen then
      hp_regen = hp_regen * -1 * self.ReverseHealRatio
    end
    if hp_regen < 0 then
      local dotres
      if self.attribs.DOTRES then
        dotres = self.attribs.DOTRES
      else
        dotres = 0
      end
      if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(8404) and self.camp == -1 then
        local bless8404 = ed.engine.rogueSkillMgr.rogueBlessList[8404]
        local p = bless8404.info["Script Arg1"] / 100
        local bless8404ratio = bless8404.info["Script Arg2"]
        if p >= ed.rand() then
          hp_regen = hp_regen * bless8404ratio
        end
      end
      self:setHP(self.hp + hp_regen * (1 - math.min(dotres / 100, 0.99)) * dt, "hprdamage")
    end
    if 0 < hp_regen and not self.buff_effects.unheal then
      hp_regen = hp_regen * (math.max((self.attribs.HealRatio or 0) / 100, -1) + 1)
      self:setHP(self.hp + hp_regen * dt, "hprheal")
    end
  end
  if ed.engine.rogue_mode then
    if ed.engine.rogueSkillMgr:getBless(6103) then
      if self.hp == 0 then
        if self.camp == -1 then
          local source
          for i, tbuff in ipairs(self.buff_list) do
            if 0 > tbuff.info.HPR then
              if tbuff.caster and tbuff.caster.camp == 1 and not tbuff.caster.config.is_summoned then
                source = tbuff.caster
              end
              break
            end
          end
          if source then
            self:onDying(source)
          else
            self.hp = 1
          end
        else
          self.hp = 1
        end
      end
    elseif self.hp == 0 then
      self.hp = 1
    end
  elseif self.hp == 0 then
    self.hp = 1
  end
  if ed.engine.rogue_mode then
    for _, buff in ipairs(self.buff_list) do
      if ed.engine.rogueSkillMgr:getBless(7315) and buff.info.ID == 60007315 then
        buff:update(dt)
        break
      end
    end
  end
  self.hp_low = self.hp / attribs.HP < 0.2
  if self.manual_skill then
    local target = self.manual_skill:selectTargetForCheck()
    local why
    self.can_cast_manual, why = self.manual_skill:canCastWithTarget(target)
  end
  if self.summon_oldcamp and self.config.summoner and not self.config.summoner.controlledTarget then
    self.camp = self.summon_oldcamp
  end
  if self.interRuptSkill then
    self:skillInterRupt(self.interRuptSkill)
    self.interRuptSkill = nil
  end
  if self.pet then
    self.pet:update(dt)
  end
  if self.legendEquip then
    self.legendEquip:update(dt)
  end
  self:updateRuntimeScale()
end

Unit.update = update

function Unit:skillInterRupt(interRuptSkill)
end

local function onActionFinished(self)
  if self.state == ed.emUnitState_Dead then
    self:setAction(nil)
    if not self.config.is_summoned then
      self.hasCorpse = true
    end
  elseif self.state == ed.emUnitState_Dying then
    self.state = ed.emUnitState_Dead
    self:setAction(nil)
    if not self.config.is_summoned then
      self.hasCorpse = true
    end
  elseif self.state ~= ed.emUnitState_Attack then
    self:idle()
  end
end

Unit.onActionFinished = onActionFinished

local function setIdleAction(self, actionName)
  if self.idleName == actionName then
    return
  else
    self.idleName = actionName
  end
end

Unit.setIdleAction = setIdleAction

local function idle(self)
  if not self:isAlive() then
    return
  end
  if self.state == ed.emUnitState_Idle then
    return
  end
  self.state = ed.emUnitState_Idle
  self.walk_v = {0, 0}
  local name = self.push and "Move" or self.idleName
  self:setAction(name, true)
end

Unit.idle = idle
local abs = math.abs

local function walkTowards(self, dest)
  if not self:isAlive() then
    return
  end
  if (self.buff_effects.stun or self.buff_effects.stunbyself) and self.controlledTarget then
    return
  end
  if self.state == ed.emUnitState_Attack and self.controlledTarget then
    self.current_skill:onPhaseFinished()
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
    if not self.controlledTarget then
      direction = {
        direction[1] * abs(direction[1]),
        direction[2] * abs(direction[2])
      }
    end
    self.walk_v = ed.edpMult(ed.edpNormalize(direction), base_speed * self.walk_speed_multiplier)
    self.walk_time = abs(direction[1] / self.walk_v[1])
  end
end

Unit.walkTowards = walkTowards

local function calculateFearVelocity(self, range)
  if range == 999 then
    self.fearVelocity = self.walk_v
  else
    local radianMeasure = math.pi / 180
    local coefficientDiectionY = (ed.rand() * 2 - 1) * range
    local ySpeed = math.sin(coefficientDiectionY * radianMeasure)
    local xSpeed = abs(math.cos(coefficientDiectionY * radianMeasure))
    local base_speed = self.info["Walk Speed"]
    local direction = {
      -self.direction * xSpeed,
      self.direction * ySpeed
    }
    direction = {
      direction[1] * abs(direction[1]),
      direction[2] * abs(direction[2])
    }
    self.fearVelocity = ed.edpMult(ed.edpNormalize(direction), base_speed * self.walk_speed_multiplier)
  end
end

Unit.calculateFearVelocity = calculateFearVelocity

local function fearWalk(self)
  if self.state ~= ed.emUnitState_Walk then
    self.state = ed.emUnitState_Walk
    self:setAction("Move", true)
  end
  if self.walk_v ~= self.fearVelocity then
    self.walk_v = self.fearVelocity
  end
end

Unit.fearWalk = fearWalk

local function removeFearWalk(self)
  self:idle()
  self.fearVelocity = {0, 0}
end

Unit.removeFearWalk = removeFearWalk

local function summon(self, bornActionName)
  self.state = ed.emUnitState_Birth
  self.walk_v = {0, 0}
  if nil == bornActionName then
    bornActionName = ed.state_to_string[ed.emUnitState_Birth]
  end
  self:setAction(bornActionName)
end

Unit.summon = summon

local function summonSelf(self, side)
  if not self:isAlive() then
    return
  end
  if self.camp ~= ed.emCampEnemy then
    return
  end
  local config = ed.copyTable(self.config)
  local monster = ed.UnitCreate(self.proto, self.camp, config)
  local postion
  if side == ed.emCampEnemy then
    postion = ed.engine.getMonsterPosition(self.monster_idx or 1)
  else
    local initPosition = ed.engine.getPlayerInitialPosition()
    local index = self.monster_index or 1
    postion = {
      initPosition[index][1],
      initPosition[index][2]
    }
  end
  ed.engine:summonUnit(monster, postion, self, "Move")
  monster.config.is_summoned = nil
  monster:reset()
end

Unit.summonSelf = summonSelf

local function castSkill(self, skill, target)
  if not self:isAlive() then
    return
  end
  if self.SD_ultStackBuff and self.SD_ultStackBuff.timer > 0 and skill.info.Manual then
    self.readyToUlt = true
    return
  end
  self.state = ed.emUnitState_Attack
  self.walk_v = {0, 0}
  self.current_skill = skill
  skill:start(target)
  if skill.info["Stolen Tag"] == 2 and not skill.info.Manual and self.info["Fit For Rubick"] then
    self.last_stolen_skill = skill
    self.last_stolen_skill_puppet = self.puppet_stack[#self.puppet_stack]
  end
  if skill.info.Manual and ed.engine:isTowerWarsMode() and self.firstManualCast and self.camp == ed.emCampPlayer then
    self.manually_casting = true
    ed.engine:freeze(self.camp)
    self:unfreeze()
    self.firstManualCast = false
  end
end

Unit.castSkill = castSkill

local function castManualSkill(self)
  if self.SD_ultStackBuff and self.SD_ultStackBuff.timer > 0 then
    self.readyToUlt = true
    return
  end
  if not self:isAlive() then
    return
  end
  if not self.manual_skill then
    return
  end
  if self.manual_skill:canTrigger() then
    self.manual_skill:trigger()
    return
  end
  local target = self.manual_skill:selectTargetForCheck()
  local canCast, reason = self.manual_skill:canCastWithTarget(target)
  if not canCast then
    return
  end
  if self.current_skill then
    self.current_skill:interrupt()
  end
  self:castSkill(self.manual_skill, target)
  self.manually_casting = true
  ed.engine:freeze(self.camp)
  self:unfreeze()
  self.can_cast_tick = -1
end

Unit.castManualSkill = castManualSkill

local function castSkillBySolt(self, slot, not_freen)
  if not self:isAlive() then
    return
  end
  slot = slot or 1
  if slot == 1 then
    self:castManualSkill()
    return
  end
  local skill = self:getSkillBySlot(slot)
  if skill == nil then
    return
  end
  if skill:canTrigger() then
    skill:trigger()
    FireEvent("SkillTriggerNotify", self.tid, self.camp, skill.info.Slot)
    return
  end
  local target = self.ai.target
  local flag, reason = skill:canCastWithTarget(target)
  if not flag then
    return
  end
  if self.current_skill then
    self.current_skill:interrupt()
  end
  local canCast, reason = skill:canCastWithTarget(target)
  if not canCast then
    return
  end
  if do_battle_log then
    btlog("[%s]: CastSkill slot %d ", self:display(), slot)
  end
  self:castSkill(skill, target)
  if not not_freen then
    self.manually_casting = true
    ed.engine:freeze(self.camp)
    self:unfreeze()
  end
  self.can_cast_tick = -1
end

Unit.castSkillBySolt = castSkillBySolt

local function energyBeanGainMp(self)
  if not self:unitCanGainMp() then
    return
  end
  self:setMP(self.mp + self.attribs.MP * 0.1)
  ed.engine.energyBeanNumber = ed.engine.energyBeanNumber - 1
  ed.engine.useEnergyBeanNumber = ed.engine.useEnergyBeanNumber + 1
  if ed.run_with_scene then
    if self.actor then
      self.actor:addEffect("eff_energy_restore.cha", -1)
    end
    if ed.engine.energyBeanNumber <= 0 then
      ed.sceneui:closeEnergyBeanGainMp()
    end
    if not ed.storage.getBool("BeanTutorialEnd") then
      ed.storage.setValue("BeanTutorialEnd", true)
    end
  end
end

Unit.energyBeanGainMp = energyBeanGainMp

local function unitCanGainMp(self)
  if not self:isAlive() then
    return false, "unit is not Alive"
  end
  if not ed.engine.energyBean_mode then
    return false, "don't open energyBean_mode"
  end
  if ed.engine.energyBeanNumber <= 0 then
    return false, "energyBeanNumber less than 1"
  end
  if self.mp >= self.attribs.MP then
    return false, "unit mp is full"
  end
  return true
end

Unit.unitCanGainMp = unitCanGainMp

local function dayAndNightSwitchImpact(self, type)
  if type == "nighttoday" then
    self.daytype = "day"
  elseif type == "daytonight" then
    self.daytype = "night"
  end
end

Unit.dayAndNightSwitchImpact = dayAndNightSwitchImpact

local function shouldTrigger(self)
  return false
end

Unit.shouldTrigger = shouldTrigger

local function showBall(self, deliverer, skill, eventIdx)
end

Unit.showBall = showBall

function Unit:collectSkill(deliverer, skill, eventIdx)
end

function Unit:collectSkillStart(deliverer, skill, receiver)
end

function Unit:collectSkillHit(deliverer, skill, receiver)
  if self.legendEquip then
    self.legendEquip:collectSkillHit(deliverer, skill, receiver)
  end
end

function Unit:collectBuff(buff)
end

function Unit:collectHPchange(config)
end

function Unit:collectMPchange(config)
end

function Unit:listerRemoveBuff(buff)
end

local function checkConsumeBall(self, skill)
end

Unit.checkConsumeBall = checkConsumeBall

local function addEnergyBall(self, skill, eventIdx)
end

Unit.addEnergyBall = addEnergyBall

local function consumeEnergyBall(self)
  self.energy_ball_manager:consumeEnergyBall()
end

Unit.consumeEnergyBall = consumeEnergyBall

local function onHitMiss(self, skill)
end

Unit.onHitMiss = onHitMiss

local function hurt(self)
  if not self:isAlive() then
    return
  end
  if self.attribs.RESHURT and ed.rand() <= self.attribs.RESHURT * 0.001 then
    return
  end
  if self.buff_effects.uncontrollable and not self.buff_effects.stunbyself then
    return
  end
  if self.current_skill then
    self.current_skill:interrupt()
  end
  if not self:isAlive() then
    return
  end
  if self.actor and self.actor.puppet then
    self.actor.puppet:interruptSound()
  end
  self:setAction("Damaged", false, true)
  self.state = ed.emUnitState_Hurt
  self.walk_v = {0, 0}
end

Unit.hurt = hurt

local function setDeathWithEffectOrNot(self, isDeathWithEffect)
  self.isDeathWithEffect = isDeathWithEffect
end

Unit.setDeathWithEffectOrNot = setDeathWithEffectOrNot

local function setDisapearWhenDie(self, isDisapearWhenDie)
  self.isDisapearWhenDie = isDisapearWhenDie
end

Unit.setDisapearWhenDie = setDisapearWhenDie

local function onDying(self, skiller)
  self.unitonDying = true
  self:die(skiller)
end

Unit.onDying = onDying

local function die(self, killer)
  if not self:isAlive() then
    return
  end
  if ed.engine.rogue_mode then
    if ed.engine.rogueSkillMgr:getBless(3202) then
      local bless3202 = ed.engine.rogueSkillMgr.rogueBlessList[3202]
      if not self.config.is_summoned and self.camp == 1 and bless3202.rogueBless3202count and bless3202.rogueBless3202count == 0 then
        local p = (bless3202.isReinforced and bless3202.info["Script Arg5"] or bless3202.info["Script Arg1"]) / 100 * self.rogueBless3201count
        if p >= ed.rand() then
          self.hp = 0
          self.mp = 0
          self:setHP((bless3202.isReinforced and bless3202.info["Script Arg6"] or bless3202.info["Script Arg2"]) / 100 * self.attribs.HP)
          local bless3202bid = 60003202
          local bless3202binfo = ed.lookupDataTable("Buff", nil, bless3202bid)
          local bless3202buff = ed.BuffCreate(bless3202binfo, self, self)
          bless3202buff.timer = bless3202.isReinforced and bless3202.info["Script Arg7"] or bless3202.info["Script Arg3"]
          if ed.run_with_scene then
            local effect_name = "eff_point_TitanSDH_atk4.cha"
            ed.scene:playEffectOnScene(effect_name, self.position, {
              self.direction,
              1
            }, nil, 1)
          end
          self:addBuff(bless3202buff, self)
          bless3202.rogueBless3202count = bless3202.rogueBless3202count + 1
          self.unitonDying = false
          return
        end
      end
    end
    local revelation8buff = false
    for i, buff in ipairs(self.buff_list) do
      if buff.info.ID == 60008000 then
        revelation8buff = true
        break
      end
    end
    local rogueNPC = ed.engine.rogueSkillMgr:getSkillCaster()
    if revelation8buff and ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(24) then
      local charmEffect = ed.engine.rogueSkillMgr:getCharm(24)
      if self.camp == -1 then
        for unit in ed.engine:foreachAliveUnit(-1) do
          if unit ~= self and not unit.buff_effects.invulnerable and not unit.unitonDying then
            unit:takeDamage(self.attribs.HP * charmEffect.info["Script Arg" .. charmEffect.level] / 100, "Holy", "hp", rogueNPC, 1, 1, true)
            if ed.run_with_scene then
              local effect_name = "eff_point_TitanLoong_atk2.cha"
              if effect_name then
                ed.scene:playEffectOnScene(effect_name, unit.position, nil, nil, 1)
              end
            end
          end
        end
      end
    end
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
  if self.manually_casting then
    self.manually_casting = false
    ed.engine:unfreeze()
  end
  self:removeSignedBuffer()
  self.can_cast_manual = false
  self.walk_v = {0, 0}
  self.hp = 0
  self.mp = 0
  if not self.isDeathWithEffect then
    self:setAction("Death", false, true)
  else
    self.action_name = nil
    self.action_loop = false
    self.action_duration = 0
    self.action_elapsed = 0
    local origin = {
      self.position[1],
      self.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          self.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  end
  local sureKMPR = ed.rand() < self.attribs.KMPR / 100
  ed.engine:onUnitDie(self, self.killer, sureKMPR)
  self:applyAuraSkill()
  if self.actor and self.actor.puppet then
    self.actor.puppet:interruptSound()
  end
  if self.actor then
    self.actor:onUnitDeath()
  end
  if self.pet then
    local actor = self.pet.actor
    local is = actor and actor.node:setVisible(false)
  end
end

Unit.die = die

local function handleUnitDieEventToAll(self, unit, killer_unit)
  ed.engine:onUnitBeKilled(unit, killer_unit)
end

Unit.handleUnitDieEventToAll = handleUnitDieEventToAll

local function takeHeal(self, amount, _type, source, reason)
  if not self:isAlive() then
    return
  end
  _type = _type or "hp"
  if source then
    amount = amount * source.attribs.PDM
  end
  local isAddPoint = true
  if _type == "mp" then
    local change = self:setMP(self.mp + amount)
    if change then
      amount = change or amount
    end
  else
    amount = amount * (math.max((source and source.attribs.HEAL or 0) / 100, -1) + 1) * (math.max((self.attribs.HealRatio or 0) / 100, -1) + 1)
    if self.Reverse_Heal == true and 0 < amount then
      amount = amount * -1 * self.ReverseHealRatio
    end
    if self.what == "lordUnit" then
      amount = amount * self.heal_ratio
    end
    if not self.buff_effects.unheal then
      local change = self:setHP(self.hp + amount, reason or "heal")
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
  self:unfreezeActor()
  if not self.notPopupBattleInfo and isAddPoint then
    if self.actor and 1 < amount then
      local str = "+" .. math.floor(amount + 0.5)
      local color = _type == "mp" and "yellow" or "green"
      ed.PopupCreate(str, color, self.actor, false, "heal")
    elseif self.actor and amount < 0 then
      local str = tostring(math.floor(amount + 0.5))
      local color = _type == "mp" and "yellow" or "red"
      ed.PopupCreate(str, color, self.actor, false, "heal")
    end
  end
  return amount
end

Unit.takeHeal = takeHeal

function Unit:takeMagicHeal(amount, _type)
  if not self:isAlive() then
    return
  end
  _type = _type or "hp"
  local isAddPoint = true
  if _type == "mp" then
    self:setMP(self.mp + amount)
  else
    amount = amount * (math.max((self.attribs.HealRatio or 0) / 100, -1) + 1)
    if not self.buff_effects.unheal then
      self:setHP(self.hp + amount, "heal")
    else
      isAddPoint = false
    end
  end
  if do_battle_log then
    btlog("    %s gains %d %s", self:display(), amount, _type)
  end
  self:unfreezeActor()
  if isAddPoint then
    if self.actor and 1 < amount then
      local str = "+" .. math.floor(amount + 0.5)
      local color = _type == "mp" and "yellow" or "green"
      ed.PopupCreate(str, color, self.actor, false, "heal")
    elseif self.actor and amount < 0 then
      local str = tostring(math.floor(amount + 0.5))
      local color = _type == "mp" and "yellow" or "red"
      ed.PopupCreate(str, color, self.actor, false, "heal")
    end
  end
end

local max = math.max
local min = math.min

local function getLostHPAfterImmunity(self, damage, immunity, damage_type, source, skill, field)
  return max(0, damage * (100 - immunity) / 100)
end

Unit.getLostHPAfterImmunity = getLostHPAfterImmunity

local function inverseLerp(from, to, value)
  return (value - from) / (to - from)
end

local function takeDamage(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred, damageinfo)
  if not self:isAlive() or self.buff_effects.invulnerable then
    return 0
  end
  local amount = struct_table
  local skillTags, skill
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
    skill = struct_table.skill
    skillTags = skill and skill.info["Skill Tags"]
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  local defence, dd, dc, immunity, Levelimmunity, crit, crit_resist
  local level = self.level
  if damage_type == "AD" then
    defence = max(0, self.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    crit_resist = self.attribs.CRITRES
    immunity = (self.attribs.PIMU or 0) - source.attribs.ADDP
    Levelimmunity = self.attribs.LevelPIMU or 0
    if ed.engine.autoChessMode then
      dd = defence * 8
      dc = 0
    else
      dd = max(0, defence * 8)
      dc = max(0, defence * 8)
    end
  elseif damage_type == "AP" then
    defence = max(0, self.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    crit_resist = self.attribs.MCRITRES
    immunity = (self.attribs.MIMU or 0) - source.attribs.APDP
    Levelimmunity = self.attribs.LevelMIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    crit_resist = 0
    immunity = 0
    Levelimmunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + self.attribs.ALLIMU
  amount = max(0, amount or 0)
  if ed.engine.rogue_mode then
    if ed.engine.rogueSkillMgr:getBless(1314) and damage_type == "AD" and not transferred and source and not source.config.is_summoned and source.camp == 1 then
      local bless1314 = ed.engine.rogueSkillMgr.rogueBlessList[1314]
      local bless1314p = bless1314.isReinforced and bless1314.info["Script Arg5"] or bless1314.info["Script Arg1"]
      amount = amount + bless1314p
    end
    if ed.engine.rogueSkillMgr:getBless(7204) and not transferred and source and not source.config.is_summoned and source.camp == 1 then
      local bless7204 = ed.engine.rogueSkillMgr.rogueBlessList[7204]
      local bless7204ratio = (bless7204.isReinforced and bless7204.info["Script Arg5"] or bless7204.info["Script Arg1"]) / 100
      local bless7204haveshield = false
      for i, tbuff in ipairs(source.buff_list) do
        if tbuff.shield and 0 < tbuff.shield then
          bless7204haveshield = true
          break
        end
      end
      if source.revelation7buff then
        bless7204haveshield = true
      end
      if bless7204haveshield then
        amount = amount * (1 + bless7204ratio)
      end
    end
  end
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(8205) and not transferred and source and not source.config.is_summoned and source.camp == 1 then
    local bless8205 = ed.engine.rogueSkillMgr.rogueBlessList[8205]
    local p = (bless8205.isReinforced and bless8205.info["Script Arg5"] or bless8205.info["Script Arg1"]) / 100
    amount = amount * p
    local lost1, bCrit1 = self:takeDamageAfterDamageCalc(damage_type, field, source, coefficient, crit_mod, transferred, damageinfo, immunity, skill, amount, crit, crit_resist, dc, dd, Levelimmunity)
    local lost2, bCrit2 = self:takeDamageAfterDamageCalc(damage_type, field, source, coefficient, crit_mod, transferred, damageinfo, immunity, skill, amount, crit, crit_resist, dc, dd, Levelimmunity)
    local lost = lost1 + lost2
    local bCrit
    if bCrit1 == true or bCrit2 == true then
      bCrit = true
    else
      bCrit = false
    end
    return lost, bCrit
  else
    local crit_prob = math.max(crit - crit_resist, 0) / (100 + dc) * crit_mod
    local bCrit = crit_prob > ed.rand()
    if ed.engine.rogue_mode and source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) then
      local charmEffect = ed.engine.rogueSkillMgr:getCharm(28)
      bCrit = ed.rand() < charmEffect.info["Script Arg" .. charmEffect.level + 3] / 100
    end
    if skill and skill ~= nil then
      if skill.info["Do Crit"] == "YES" then
        bCrit = true
      elseif skill.info["Do Crit"] == "NO" then
        bCrit = false
      end
    end
    if damageinfo and damageinfo.MUSTCRIT == true then
      bCrit = true
    end
    if ed.engine.rogue_mode then
      local canCrit = true
      if damage_type == "Holy" then
        canCrit = false
        if source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) then
          canCrit = true
        end
      end
      local revelation8buff = false
      for i, buff in ipairs(source.buff_list) do
        if buff.info.ID == 60008000 then
          revelation8buff = true
          break
        end
      end
      if revelation8buff and canCrit then
        if source and source.camp == 1 then
          bCrit = true
        elseif source and source.camp == -1 then
          if ed.engine.rogueSkillMgr:getBless(8103) then
            bCrit = false
          else
            bCrit = true
          end
        end
      end
    end
    local crit_val
    if damage_type == "AD" then
      crit_val = source.attribs.CSD
    elseif damage_type == "AP" then
      crit_val = source.attribs.MCSD
    end
    if ed.engine.rogue_mode and source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) and damage_type == "Holy" then
      crit_val = source.attribs.CSD
    end
    local crit_multiplier = 1
    if bCrit then
      crit_multiplier = crit_val and crit_val * 0.01 + 2 or 2
      if damage_type == "AD" then
        crit_multiplier = math.max(1, crit_multiplier - self.attribs.CSDR * 0.01)
      elseif damage_type == "AP" then
        crit_multiplier = math.max(1, crit_multiplier - self.attribs.MCSDR * 0.01)
      end
      if ed.engine.rogue_mode and source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) and damage_type == "Holy" then
        crit_multiplier = math.max(1, crit_multiplier - self.attribs.CSDR * 0.01)
      end
      if ed.engine.rogue_mode then
        local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
        if revelation.destinyId == 8 and source and not source.config.is_summoned and source.camp == 1 then
          revelation:addEnergy(revelation.info.EnergyAdd)
        end
      end
    end
    local dp = max(1, amount + dd * coefficient)
    local damage = amount * amount / dp
    if dd < 0 then
      dp = amount + math.abs(dd * coefficient) / 2
      damage = amount * (1 + math.abs(dd / dp * 0.5))
    end
    damage = damage * crit_multiplier * source.attribs.PDM
    if ed.debug_mode and self.camp ~= ed.emCampPlayer then
      damage = damage * ((ed.gmconfig or {}).attack_ratio or 1)
    end
    if 100 <= immunity then
      if ed.run_with_scene then
        local color = self.camp == ed.emCampEnemy and "red" or "blue"
        local adimm = self.attribs.PIMU >= 100
        local apimm = self.attribs.MIMU >= 100
        local str
        if adimm and apimm or self.attribs.ALLIMU >= 100 then
          str = "immune"
        elseif adimm then
          str = "physical_immune"
        else
          str = "magic_immune"
        end
        if not self.notPopupBattleInfo then
          ed.PopupCreate(str, color, self.actor, nil, "text")
        end
      end
      return 0
    end
    local buff_templist = {}
    local buff_roguetemplistearly = {}
    local buff_roguetemplistlater = {}
    table.sort(self.buff_list, ed.cmpSort({
      {
        getValue = function(buff)
          return buff.shield and buff.shield or 0
        end,
        reverse = true
      }
    }))
    for i, buff in ipairs(self.buff_list) do
      if ed.engine.rogue_mode then
        if buff.info.ID == 62990001 then
          table.insert(buff_roguetemplistearly, buff)
        elseif buff.info.ID == 62990002 then
          table.insert(buff_roguetemplistearly, buff)
        elseif buff.info.ID == 62990003 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(5201) and buff.info.ID == 60005201 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(5202) and buff.info.ID == 60005202 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6202) and buff.info.ID == 60006202 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6203) and buff.info.ID == 60006203 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6401) and buff.info.ID == 60006401 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6402) and buff.info.ID == 60006402 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(7201) and buff.info.ID == 60007201 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(7205) and buff.info.ID == 60007205 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8201) and buff.info.ID == 60028201 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(7311) and buff.info.ID == 60007311 then
          table.insert(buff_roguetemplistearly, buff)
        elseif ed.engine.rogueSkillMgr:getBless(1201) and buff.info.ID == 60001201 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(1311) and buff.info.ID == 60001311 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(2202) and buff.info.ID == 60002202 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(3201) and buff.info.ID == 60003201 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(3301) and buff.info.ID == 60003301 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(4301) and buff.info.ID == 60004301 then
          table.insert(buff_roguetemplistlater, buff)
        elseif buff.info.ID == 60005000 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(5204) and buff.info.ID == 60005204 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(5205) and buff.info.ID == 60005205 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(5315) and buff.info.ID == 60015315 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6301) and buff.info.ID == 60006301 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6310) and buff.info.ID == 60006310 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(6404) and buff.info.ID == 60006404 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(7203) and buff.info.ID == 60007203 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8201) and buff.info.ID == 60008201 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8201) and buff.info.ID == 60018201 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8312) and buff.info.ID == 60008312 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8313) and buff.info.ID == 60008313 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8314) and buff.info.ID == 60008314 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getBless(8315) and buff.info.ID == 60008315 then
          table.insert(buff_roguetemplistlater, buff)
        elseif ed.engine.rogueSkillMgr:getCharm(27) and buff.info.ID == 64000027 then
          table.insert(buff_roguetemplistlater, buff)
        elseif buff.info.ID == 65000001 or buff.info.ID == 65000002 or buff.info.ID == 65000003 or buff.info.ID == 65000004 then
          table.insert(buff_roguetemplistlater, buff)
        else
          table.insert(buff_templist, buff)
        end
      else
        table.insert(buff_templist, buff)
      end
    end
    for _, buff in ipairs(buff_roguetemplistearly) do
      damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    end
    for _, buff in ipairs(buff_templist) do
      damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    end
    for _, buff in ipairs(buff_roguetemplistlater) do
      damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    end
    if damage <= 0 then
      return 0
    end
    if damage_type == "AD" then
      immunity = (self.attribs.PIMU or 0) - source.attribs.ADDP
    elseif damage_type == "AP" then
      immunity = (self.attribs.MIMU or 0) - source.attribs.APDP
    elseif damage_type == "Holy" then
      immunity = 0
    else
      EDDebug("Unknown Damage Type '" .. damage_type .. "'")
    end
    immunity = immunity + self.attribs.ALLIMU
    if 100 <= immunity then
      if ed.run_with_scene then
        local color = self.camp == ed.emCampEnemy and "red" or "blue"
        local adimm = self.attribs.PIMU >= 100
        local apimm = self.attribs.MIMU >= 100
        local str
        if adimm and apimm or self.attribs.ALLIMU >= 100 then
          str = "immune"
        elseif adimm then
          str = "physical_immune"
        else
          str = "magic_immune"
        end
        if not self.notPopupBattleInfo then
          ed.PopupCreate(str, color, self.actor, nil, "text")
        end
      end
      return 0
    end
    damage = damage * (1 - Levelimmunity / 100)
    local lost = self:getLostHPAfterImmunity(damage, immunity, damage_type, source, skill, field)
    local damage = min(self.hp, lost)
    damage = damage * self.dPSStatisticsRatio
    if source ~= self and field == "hp" then
      source.battledata:addDamage(damage, damage_type)
      self.battledata:addBearDamage(damage)
    end
    if do_battle_log then
      btlog("    %s lost %d %s %s", self:display(), lost, field, bCrit and "(Crit!)" or "")
    end
    local oldLostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
    if field == "hp" then
      self:setHP(self.hp - lost, damage_type)
      if self.hp == 0 then
        self:onDying(source)
      else
        if self.state == ed.emUnitState_Birth then
        elseif self.current_skill and not self.current_skill.info.Interruptable then
        elseif self.buff_effects.uncontrollable then
        else
          local interruptHpRatio = self.attribs["Interrupt HP Ratio"] / 100
          local intr = self.attribs.INTR or 0
          local interruptProbability
          if intr == 0 then
            interruptProbability = lost <= self.attribs.HP * interruptHpRatio and 0 or 1
          else
            interruptProbability = inverseLerp(self.attribs.HP * interruptHpRatio, self.attribs.HP * (interruptHpRatio + intr * 0.001), lost)
          end
          local interrupt = false
          if interruptProbability <= 0 then
          elseif 1 <= interruptProbability then
            interrupt = true
          else
            interrupt = interruptProbability >= ed.rand()
          end
          if not interrupt then
          else
            self:hurt()
            if do_battle_log then
              btlog("    %s was interrupted.", self:display())
            end
          end
        end
        local mp_gain = lost * self.info["MP Gain Rate"] / self.attribs.HP * (self.attribs.MPRatio * 0.01 + 1)
        self:setMP(self.mp + mp_gain * ed.engine.mp_bonus)
      end
    elseif field == "mp" then
      self:setMP(self.mp - lost)
    end
    self:unfreezeActor()
    if self.actor then
      local str = "-" .. math.floor(damage + 0.5)
      if str ~= "-0" then
        local color
        if ed.isNewDamageNum then
          if field == "hp" then
            if damage_type == "AD" then
              color = "red"
            elseif damage_type == "AP" then
              color = "blue"
            elseif damage_type == "Holy" then
              color = "newWhite"
            end
          elseif field == "mp" then
            color = "yellow"
          end
        elseif field == "mp" then
          color = "yellow"
        elseif self.camp == ed.emCampPlayer then
          color = "red"
        else
          color = "orange"
        end
        if bCrit then
          str = "&" .. str
        end
        if not self.notPopupBattleInfo then
          ed.PopupCreate(str, color, self.actor, bCrit)
        end
        if self.monster_idx then
          local lostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
          ed.scene:showMonsterLoots(ed.engine.wave_id, self, lostHpPer, oldLostHpPer)
        end
      end
    end
    if ed.IsAutoChessMode() and ed.run_with_scene and field == "hp" then
      FireEvent("EventUnitTakeDamage", source, lost)
    end
    return lost, bCrit
  end
end

Unit.takeDamage = takeDamage

function Unit:takeDamageAfterDamageCalc(damage_type, field, source, coefficient, crit_mod, transferred, damageinfo, immunity, skill, amount, crit, crit_resist, dc, dd, Levelimmunity)
  local crit_prob = math.max(crit - crit_resist, 0) / (100 + dc) * crit_mod
  local bCrit = crit_prob > ed.rand()
  if ed.engine.rogue_mode and source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(28)
    bCrit = ed.rand() < charmEffect.info["Script Arg" .. charmEffect.level + 3] / 100
  end
  if skill and skill ~= nil then
    if skill.info["Do Crit"] == "YES" then
      bCrit = true
    elseif skill.info["Do Crit"] == "NO" then
      bCrit = false
    end
  end
  if damageinfo and damageinfo.MUSTCRIT == true then
    bCrit = true
  end
  if ed.engine.rogue_mode then
    local canCrit = true
    if damage_type == "Holy" then
      canCrit = false
      if source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) then
        canCrit = true
      end
    end
    local revelation8buff = false
    for i, buff in ipairs(source.buff_list) do
      if buff.info.ID == 60008000 then
        revelation8buff = true
        break
      end
    end
    if revelation8buff and canCrit then
      if source and source.camp == 1 then
        bCrit = true
      elseif source and source.camp == -1 then
        if ed.engine.rogueSkillMgr:getBless(8103) then
          bCrit = false
        else
          bCrit = true
        end
      end
    end
  end
  local crit_val
  if damage_type == "AD" then
    crit_val = source.attribs.CSD
  elseif damage_type == "AP" then
    crit_val = source.attribs.MCSD
  end
  if ed.engine.rogue_mode and source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) and damage_type == "Holy" then
    crit_val = source.attribs.CSD
  end
  local crit_multiplier = 1
  if bCrit then
    crit_multiplier = crit_val and crit_val * 0.01 + 2 or 2
    if damage_type == "AD" then
      crit_multiplier = math.max(1, crit_multiplier - self.attribs.CSDR * 0.01)
    elseif damage_type == "AP" then
      crit_multiplier = math.max(1, crit_multiplier - self.attribs.MCSDR * 0.01)
    end
    if ed.engine.rogue_mode and source and source.name == "BS" and ed.engine.rogueSkillMgr:getCharm(28) and damage_type == "Holy" then
      crit_multiplier = math.max(1, crit_multiplier - self.attribs.CSDR * 0.01)
    end
    if ed.engine.rogue_mode then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 8 and source and not source.config.is_summoned and source.camp == 1 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
  end
  local dp = max(1, amount + dd * coefficient)
  local damage = amount * amount / dp
  if dd < 0 then
    dp = amount + math.abs(dd * coefficient) / 2
    damage = amount * (1 + math.abs(dd / dp * 0.5))
  end
  damage = damage * crit_multiplier * source.attribs.PDM
  if ed.debug_mode and self.camp ~= ed.emCampPlayer then
    damage = damage * ((ed.gmconfig or {}).attack_ratio or 1)
  end
  if 100 <= immunity then
    if ed.run_with_scene then
      local color = self.camp == ed.emCampEnemy and "red" or "blue"
      local adimm = 100 <= self.attribs.PIMU
      local apimm = 100 <= self.attribs.MIMU
      local str
      if adimm and apimm or 100 <= self.attribs.ALLIMU then
        str = "immune"
      elseif adimm then
        str = "physical_immune"
      else
        str = "magic_immune"
      end
      if not self.notPopupBattleInfo then
        ed.PopupCreate(str, color, self.actor, nil, "text")
      end
    end
    return 0
  end
  local buff_templist = {}
  local buff_roguetemplistearly = {}
  local buff_roguetemplistlater = {}
  table.sort(self.buff_list, ed.cmpSort({
    {
      getValue = function(buff)
        return buff.shield and buff.shield or 0
      end,
      reverse = true
    }
  }))
  for i, buff in ipairs(self.buff_list) do
    if ed.engine.rogue_mode then
      if buff.info.ID == 62990001 then
        table.insert(buff_roguetemplistearly, buff)
      elseif buff.info.ID == 62990002 then
        table.insert(buff_roguetemplistearly, buff)
      elseif buff.info.ID == 62990003 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(5201) and buff.info.ID == 60005201 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(5202) and buff.info.ID == 60005202 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6202) and buff.info.ID == 60006202 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6203) and buff.info.ID == 60006203 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6401) and buff.info.ID == 60006401 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6402) and buff.info.ID == 60006402 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(7201) and buff.info.ID == 60007201 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(7205) and buff.info.ID == 60007205 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8201) and buff.info.ID == 60028201 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(7311) and buff.info.ID == 60007311 then
        table.insert(buff_roguetemplistearly, buff)
      elseif ed.engine.rogueSkillMgr:getBless(1201) and buff.info.ID == 60001201 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(1311) and buff.info.ID == 60001311 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(2202) and buff.info.ID == 60002202 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(3201) and buff.info.ID == 60003201 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(3301) and buff.info.ID == 60003301 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(4301) and buff.info.ID == 60004301 then
        table.insert(buff_roguetemplistlater, buff)
      elseif buff.info.ID == 60005000 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(5204) and buff.info.ID == 60005204 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(5205) and buff.info.ID == 60005205 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(5315) and buff.info.ID == 60015315 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6301) and buff.info.ID == 60006301 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6310) and buff.info.ID == 60006310 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(6404) and buff.info.ID == 60006404 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(7203) and buff.info.ID == 60007203 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8201) and buff.info.ID == 60008201 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8201) and buff.info.ID == 60018201 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8312) and buff.info.ID == 60008312 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8313) and buff.info.ID == 60008313 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8314) and buff.info.ID == 60008314 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getBless(8315) and buff.info.ID == 60008315 then
        table.insert(buff_roguetemplistlater, buff)
      elseif ed.engine.rogueSkillMgr:getCharm(27) and buff.info.ID == 64000027 then
        table.insert(buff_roguetemplistlater, buff)
      elseif buff.info.ID == 65000001 or buff.info.ID == 65000002 or buff.info.ID == 65000003 or buff.info.ID == 65000004 then
        table.insert(buff_roguetemplistlater, buff)
      else
        table.insert(buff_templist, buff)
      end
    else
      table.insert(buff_templist, buff)
    end
  end
  for _, buff in ipairs(buff_roguetemplistearly) do
    damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  end
  for _, buff in ipairs(buff_templist) do
    damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  end
  for _, buff in ipairs(buff_roguetemplistlater) do
    damage = buff:onDamaged(damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  end
  if damage <= 0 then
    return 0
  end
  if damage_type == "AD" then
    immunity = (self.attribs.PIMU or 0) - source.attribs.ADDP
  elseif damage_type == "AP" then
    immunity = (self.attribs.MIMU or 0) - source.attribs.APDP
  elseif damage_type == "Holy" then
    immunity = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + self.attribs.ALLIMU
  if 100 <= immunity then
    if ed.run_with_scene then
      local color = self.camp == ed.emCampEnemy and "red" or "blue"
      local adimm = 100 <= self.attribs.PIMU
      local apimm = 100 <= self.attribs.MIMU
      local str
      if adimm and apimm or 100 <= self.attribs.ALLIMU then
        str = "immune"
      elseif adimm then
        str = "physical_immune"
      else
        str = "magic_immune"
      end
      if not self.notPopupBattleInfo then
        ed.PopupCreate(str, color, self.actor, nil, "text")
      end
    end
    return 0
  end
  damage = damage * (1 - Levelimmunity / 100)
  local lost = self:getLostHPAfterImmunity(damage, immunity, damage_type, source, skill, field)
  local damage = min(self.hp, lost)
  damage = damage * self.dPSStatisticsRatio
  if source ~= self and field == "hp" then
    source.battledata:addDamage(damage, damage_type)
    self.battledata:addBearDamage(damage)
  end
  if do_battle_log then
    btlog("    %s lost %d %s %s", self:display(), lost, field, bCrit and "(Crit!)" or "")
  end
  local oldLostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
  if field == "hp" then
    self:setHP(self.hp - lost, damage_type)
    if self.hp == 0 then
      self:onDying(source)
    else
      if self.state == ed.emUnitState_Birth then
      elseif self.current_skill and not self.current_skill.info.Interruptable then
      elseif self.buff_effects.uncontrollable then
      else
        local interruptHpRatio = self.attribs["Interrupt HP Ratio"] / 100
        local intr = self.attribs.INTR or 0
        local interruptProbability
        if intr == 0 then
          interruptProbability = lost <= self.attribs.HP * interruptHpRatio and 0 or 1
        else
          interruptProbability = inverseLerp(self.attribs.HP * interruptHpRatio, self.attribs.HP * (interruptHpRatio + intr * 0.001), lost)
        end
        local interrupt = false
        if interruptProbability <= 0 then
        elseif 1 <= interruptProbability then
          interrupt = true
        else
          interrupt = interruptProbability >= ed.rand()
        end
        if not interrupt then
        else
          self:hurt()
          if do_battle_log then
            btlog("    %s was interrupted.", self:display())
          end
        end
      end
      local mp_gain = lost * self.info["MP Gain Rate"] / self.attribs.HP * (self.attribs.MPRatio * 0.01 + 1)
      self:setMP(self.mp + mp_gain * ed.engine.mp_bonus)
    end
  elseif field == "mp" then
    self:setMP(self.mp - lost)
  end
  self:unfreezeActor()
  if self.actor then
    local str = "-" .. math.floor(damage + 0.5)
    if str ~= "-0" then
      local color
      if ed.isNewDamageNum then
        if field == "hp" then
          if damage_type == "AD" then
            color = "red"
          elseif damage_type == "AP" then
            color = "blue"
          elseif damage_type == "Holy" then
            color = "newWhite"
          end
        elseif field == "mp" then
          color = "yellow"
        end
      elseif field == "mp" then
        color = "yellow"
      elseif self.camp == ed.emCampPlayer then
        color = "orange"
      else
        color = "red"
      end
      if bCrit then
        str = "&" .. str
      end
      if not self.notPopupBattleInfo then
        ed.PopupCreate(str, color, self.actor, bCrit)
      end
      if self.monster_idx then
        local lostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
        ed.scene:showMonsterLoots(ed.engine.wave_id, self, lostHpPer, oldLostHpPer)
      end
    end
  end
  if ed.IsAutoChessMode() and ed.run_with_scene and field == "hp" then
    FireEvent("EventUnitTakeDamage", source, lost)
  end
  return lost, bCrit
end

function Unit:takeMagicDamage(struct_table)
  if not self:isAlive() then
    return
  end
  local skill = struct_table.skill
  local skillTags = skill and skill.info["Skill Tags"]
  local damage_type = struct_table.damage_type
  local field = struct_table.field
  local coefficient = struct_table.coefficient or 1
  local crit_mod = struct_table.crit_mod
  local amount = struct_table.amount
  local defence, dd, dc, immunity, Levelimmunity
  local crit = 0
  local level = self.level
  if damage_type == "AD" then
    defence = max(0, self.attribs.ARM)
    immunity = self.attribs.PIMU or 0
    Levelimmunity = self.attribs.LevelPIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = max(0, self.attribs.MR)
    immunity = self.attribs.MIMU or 0
    Levelimmunity = self.attribs.LevelMIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    immunity = 0
    Levelimmunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + self.attribs.ALLIMU
  local crit_prob = crit / (100 + dc) * crit_mod
  local bCrit = crit_prob > ed.rand()
  amount = max(0, amount)
  local damage = amount * amount / (amount + dd * coefficient)
  if ed.debug_mode and self.camp ~= ed.emCampPlayer then
    damage = damage * ((ed.gmconfig or {}).attack_ratio or 1)
  end
  if 100 <= immunity then
    if ed.run_with_scene then
      local color = self.camp == ed.emCampEnemy and "red" or "blue"
      local adimm = self.attribs.PIMU >= 100
      local apimm = self.attribs.MIMU >= 100
      local str
      if adimm and apimm or self.attribs.ALLIMU >= 100 then
        str = "immune"
      elseif adimm then
        str = "physical_immune"
      else
        str = "magic_immune"
      end
      if not self.notPopupBattleInfo then
        ed.PopupCreate(str, color, self.actor, nil, "text")
      end
    end
    return 0
  end
  for _, buff in ipairs(self.buff_list) do
    damage = buff:onDamaged(damage, damage_type, nil, skill, field)
  end
  if damage <= 0 then
    return 0
  end
  damage = damage * (1 - Levelimmunity / 100)
  local lost = self:getLostHPAfterImmunity(damage, immunity, damage_type)
  local damage = min(self.hp, lost)
  damage = damage * self.dPSStatisticsRatio
  if do_battle_log then
    btlog("    %s lost %d %s %s", self:display(), lost, field, bCrit and "(Crit!)" or "")
  end
  local oldLostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
  if field == "hp" then
    self:setHP(self.hp - lost, damage_type)
    if self.hp == 0 then
      self:onDying()
    else
      if self.state == ed.emUnitState_Birth then
      elseif self.current_skill and not self.current_skill.info.Interruptable then
      elseif self.buff_effects.uncontrollable then
      else
        local interruptHpRatio = self.attribs["Interrupt HP Ratio"] / 100
        local intr = self.attribs.INTR or 0
        local interruptProbability
        if intr == 0 then
          interruptProbability = lost <= self.attribs.HP * interruptHpRatio and 0 or 1
        else
          interruptProbability = inverseLerp(self.attribs.HP * interruptHpRatio, self.attribs.HP * (interruptHpRatio + intr * 0.001), lost)
        end
        local interrupt = false
        if interruptProbability <= 0 then
        elseif 1 <= interruptProbability then
          interrupt = true
        else
          interrupt = interruptProbability >= ed.rand()
        end
        if not interrupt then
        else
          self:hurt()
          if do_battle_log then
            btlog("    %s was interrupted.", self:display())
          end
        end
      end
      local mp_gain = lost * self.info["MP Gain Rate"] / self.attribs.HP * (self.attribs.MPRatio * 0.01 + 1)
      print(self.mp)
      self:setMP(self.mp + mp_gain * ed.engine.mp_bonus)
    end
  elseif field == "mp" then
    self:setMP(self.mp - lost)
  end
  self:unfreezeActor()
  if self.actor then
    local str = "-" .. math.floor(damage + 0.5)
    if str ~= "-0" then
      local color
      if field == "mp" then
        color = "yellow"
      elseif self.camp == ed.emCampPlayer then
        color = "orange"
      else
        color = "red"
      end
      if not self.notPopupBattleInfo then
        ed.PopupCreate(str, color, self.actor, bCrit)
      end
      if self.monster_idx then
        local lostHpPer = (self.attribs.HP - self.hp) / self.attribs.HP
        ed.scene:showMonsterLoots(ed.engine.wave_id, self, lostHpPer, oldLostHpPer)
      end
    end
  end
  return lost, bCrit
end

local function affectField(self, buffInfo)
  for i, skill in ipairs(self.skill_list) do
    skill:affectField(buffInfo)
  end
end

Unit.affectField = affectField

local function unAffectField(self, buffInfo)
  for i, skill in ipairs(self.skill_list) do
    skill:unAffectField(buffInfo)
  end
end

Unit.unAffectField = unAffectField

local function knockup(self, time, distance, shift)
  if not self.buff_effects.stable then
    if time == 0 then
      EDDebug("Knock Up can not be zero.")
    end
    self.knockup_time = time
    self.knockup_v = {
      distance[1] / time,
      distance[2] / time
    }
    if not shift then
      self.zSpeed = time * -gravity * 0.5
    end
    if self.actor and not shift then
      self.actor:launch(time)
    end
  end
end

Unit.knockup = knockup

function Unit:moveDrop(height)
  self.zSpeed = 0
  self.height = height
  if self.actor then
    self.actor.height = height
    self.actor:launch(0)
  end
end

local function rewritePuppetStack(self, index, name)
  local isRet = true
  if index > #self.puppet_stack then
    isRet = false
  else
    self.puppet_stack[index] = name
    for i, buff in ipairs(self.buff_list) do
      buff:removeEffectAndShader()
    end
    self:usePuppet()
  end
  return isRet
end

Unit.rewritePuppetStack = rewritePuppetStack

local function pushPuppet(self, name)
  table.insert(self.puppet_stack, name)
  self:usePuppet()
  return #self.puppet_stack
end

Unit.pushPuppet = pushPuppet

local function removePuppet(self, puppet_id)
  if not puppet_id then
    return
  end
  local stack = self.puppet_stack
  if puppet_id > #stack then
    EDDebug()
    p("name|" .. self.name)
    p("pupper_id|" .. puppet_id)
  end
  stack[puppet_id] = ""
  while stack[#stack] == "" do
    stack[#stack] = nil
  end
  self:usePuppet()
end

Unit.removePuppet = removePuppet

local function usePuppet(self)
  if self.buff_effects and (self.buff_effects.polymorph or self.buff_effects.polymorphbyself) then
  else
    local puppet = self.puppet_stack[#self.puppet_stack]
    for i, skill in ipairs(self.skill_list) do
      skill:rebuildPhaseList(puppet)
    end
  end
  if self.actor then
    self.actor:usePuppet()
  end
end

Unit.usePuppet = usePuppet

local function getUnitScale(self)
  local ret = ed.lookupDataTable("Puppet", "Scale", self.puppet_stack[#self.puppet_stack])
  ret = ret * self.config.size_mod
  if ed.IsMultiArena() then
    return ret * ed.multiArena.UnitScale
  elseif ed.IsAutoChessMode() then
    return ret * 1.2
  else
    return ret
  end
end

Unit.getUnitScale = getUnitScale

function Unit:updateRuntimeScale()
  if not self.isScaleActionRunning then
    return
  end
  self.scaleActionRunningTime = math.min(self.scaleActionRunningTime + self.dt_action, self.scaleActionDuration)
end

local function getRuntimeScale(self)
  if self.isScaleActionRunning then
    local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
    return self.direction * scale, scale
  end
  local scale = self.manually_casting and (self.manualCastScale or 1.35) or 1
  return self.direction * scale, scale
end

Unit.getRuntimeScale = getRuntimeScale

local function startScalingAction(self, scaleX, duration)
  local actor = self.actor
  if actor then
    local node = actor.node
    if node then
      self.actor_node = true
      self.isScaleActionRunning = true
      self.scaleActionDuration = duration
      self.scaleActionRunningTime = 0
      self.scaleActionScaleValue = scaleX
    end
  else
    self.actor_node = false
    self.isScaleActionRunning = true
    self.scaleActionDuration = duration
    self.scaleActionRunningTime = 0
    self.scaleActionScaleValue = scaleX
  end
end

Unit.startScalingAction = startScalingAction

local function endScalingAction(self)
  self.isScaleActionRunning = false
  self.scaleActionDuration = 0
  self.scaleActionRunningTime = 0
  self.scaleActionScaleValue = 0
end

Unit.endScalingAction = endScalingAction

local function getUnitFlipX(self)
  local ret = ed.lookupDataTable("Puppet", "ScaleX Inverse", self.puppet_stack[#self.puppet_stack])
  return ret
end

Unit.getUnitFlipX = getUnitFlipX

local function getHpMod(self)
  if ed.engine.guildInstance_mode and self.camp == ed.emCampEnemy then
    return 1
  else
    return self.config.hp_mod
  end
end

Unit.getHpMod = getHpMod

local function canPanelTrigger(self)
  return self.current_skill and self.current_skill:canTrigger()
end

Unit.canPanelTrigger = canPanelTrigger

local function setHpVisible(self, val)
  local unitActor = self.actor
  if unitActor and unitActor.bar_hp and not tolua.isnull(unitActor.bar_hp.node) then
    unitActor.bar_hp:forceHide(not val)
  end
end

Unit.setHpVisible = setHpVisible

function Unit:setShieldVisible(val)
  local unitActor = self.actor
  if unitActor and unitActor.bar_shield then
    unitActor.bar_shield:forceHide(not val)
  end
end

function Unit:setFuryVisible(val)
  local unitActor = self.actor
  if unitActor then
    unitActor.bar_Fury:forceHide(not val)
  end
end

function Unit:checkActorPuppet()
  if self.actor and not self.actor.puppet then
    EDLog("Not puppet!")
    return false
  end
  return true
end

function Unit:getBuffEffect(buffID)
  if not self:checkActorPuppet() then
    return nil
  end
  local actor = self.actor
  for _, buff in ipairs(self.buff_list) do
    if buffID == buff.info.ID then
      local effectId = buff.effect_id
      if effectId then
        return actor.puppet:getChildByTag(effectId)
      end
      break
    end
  end
  EDLog(T("This BuffID: %d Not Effect!", buffID))
end

function Unit:setBuffVisible(buffID, visible)
  local effect = self:getBuffEffect(buffID)
  if effect then
    effect:setVisible(visible)
  end
end

function Unit:isBuffVisible(buffID)
  local effect = self:getBuffEffect(buffID)
  if effect then
    return effect:isVisible()
  end
end

function Unit:setAllBuffVisible(visible)
  if not self:checkActorPuppet() then
    return
  end
  local actor = self.actor
  for _, buff in ipairs(self.buff_list) do
    local effectId = buff.effect_id
    if effectId then
      local effect = actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(visible)
      end
    end
  end
end

function Unit:getValidTagNames()
  local validTags = {
    nil,
    nil,
    nil,
    nil,
    nil
  }
  local allTags = ed.getHeroTags(self.proto) or {}
  for _, tag in ipairs(allTags) do
    for _, unit in ipairs(ed.engine.alive_units[self.camp]) do
      local activeAuraTag = unit:getActiveAuraSkill()
      if activeAuraTag == tag then
        validTags[#validTags + 1] = tag
        break
      end
    end
  end
  return validTags
end

function Unit:getActiveAuraSkill()
  local rank = self.rank
  local uid = self.info.ID
  for _, row in pairs(ed.getDataTable("SkillGroup")[uid]) do
    if rank < row.Unlock then
    elseif row.Awake and not ed.protoAwake(self.proto) then
    else
      local groupId = row["Skill Group ID"]
      local skill = ed.lookupDataTable("Skill", nil, groupId, 0)
      if skill["Aura Affect Hero Tag"] then
        return skill["Aura Affect Hero Tag"]
      end
    end
  end
end

function Unit:getBuffById(id)
  for _, buff in ipairs(self.buff_list) do
    if buff.info.ID == id then
      return buff
    end
  end
end

function Unit:getSkillBySlot(slot)
  for i, skill in ipairs(self.skill_list) do
    if skill.info.Slot == slot then
      return skill
    end
  end
end

function Unit:getSide()
  local bet = self.camp == ed.emCampPlayer
  return bet and "left_side" or "right_side"
end

local function canTouchRespond(self)
  return false
end

Unit.canTouchRespond = canTouchRespond

local function touchPositionHandler(self, pos)
end

Unit.touchPositionHandler = touchPositionHandler

local function unitPanelIsSwitch(self)
  local maxMP = self.attribs.MP or 1000
  if maxMP > self.mp then
    return true
  end
  return false
end

Unit.unitPanelIsSwitch = unitPanelIsSwitch
require("battle.actor")
require("battle.soloMode.soloActor")
require("battle.preload")
