local ed = ed
require("md5")
require("bit")
local herodetail = ed.ui.herodetail

local function copyPbMessage(src, creater)
  if src == nil then
    return nil
  end
  local dest = creater()
  for k, v in pairs(src[".data"]) do
    dest[k] = v
  end
  return dest
end

local function copyPbArray(src, creater)
  if src == nil then
    return nil
  end
  local array = {}
  for i, v in ipairs(src) do
    array[i] = copyPbMessage(src[i], creater)
  end
  return array
end

local sub = string.sub

local function _setter(self, key, value)
  local delegate = rawget(self, "data")
  if delegate and sub(key, 1, 1) == "_" then
    delegate[key] = value
  else
    rawset(self, key, value)
  end
end

local function getGetter(class)
  local function _getter(self, key)
    local delegate = rawget(self, "data")
    
    if delegate and sub(key, 1, 1) == "_" then
      return delegate[key]
    else
      return class[key]
    end
  end
  
  return _getter
end

local class = {
  mt = {}
}
ed.Hero = class
class.mt.__index = getGetter(class)
class.mt.__newindex = _setter

function ed.getHeroMaxLevel()
  return 90
end

local function HeroCreate()
  local self = {
    data = nil,
    crusadeData = nil,
    mercenaryData = nil
  }
  setmetatable(self, class.mt)
  return self
end

ed.HeroCreate = HeroCreate
class.create = HeroCreate

local function setCrusade(self, data)
  if not data then
    self.crusadeData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.crusadeData = dyna
end

class.setCrusade = setCrusade

local function setThroneTower(self, data)
  if data == nil then
    self.throneTowerData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.throneTowerData = dyna
end

class.setThroneTower = setThroneTower

local function setGcw(self, data)
  if data == nil then
    self.gcwData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.gcwData = dyna
end

class.setGcw = setGcw

function class:setAssassinate(data)
  if not data then
    self.assassinateData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.assassinateData = dyna
end

function class:setMultistage(data)
  if not data then
    self.multistageData = nil
    return
  end
  local dyna = {}
  dyna._hp_perc = data._hp_perc
  dyna._mp_perc = data._mp_perc
  dyna._custom_data = data._custom_data
  self.multistageData = dyna
end

function class:setup(data)
  self.data = data
end

local function hp_perc(self, mode)
  if mode == "crusade" and self.crusadeData then
    return self.crusadeData._hp_perc
  end
  if mode == "throne_tower" and self.throneTowerData and self.throneTowerData._hp_perc ~= 10000 then
    return self.throneTowerData._hp_perc
  end
  if mode == "gcw" and self.gcwData then
    return self.gcwData._hp_perc
  end
  if mode == "assassinate" and self.assassinateData then
    return self.assassinateData._hp_perc
  end
  if mode == "multi_stage" and self.multistageData then
    return self.multistageData._hp_perc
  end
end

class.hp_perc = hp_perc

local function mp_perc(self, mode)
  if mode == "crusade" and self.crusadeData then
    return self.crusadeData._mp_perc
  end
  if mode == "throne_tower" and self.throneTowerData and self.throneTowerData._mp_perc ~= 0 then
    return self.throneTowerData._mp_perc
  end
  if mode == "gcw" and self.gcwData then
    return self.gcwData._mp_perc
  end
  if mode == "multi_stage" and self.multistageData then
    return self.multistageData._mp_perc
  end
end

class.mp_perc = mp_perc

local function custom_data(self, mode)
  mode = mode or "crusade"
  if mode == "crusade" and self.crusadeData then
    return self.crusadeData._custom_data
  end
  if mode == "throne_tower" and self.throneTowerData then
    return self.throneTowerData._custom_data
  end
  if mode == "gcw" and self.gcwData then
    return self.gcwData._custom_data
  end
end

class.custom_data = custom_data

local function setMercenaryData(self, data)
  self.mercenaryData = data
end

class.setMercenaryData = setMercenaryData

local function getMercenaryData(self)
  return self.mercenaryData
end

class.getMercenaryData = getMercenaryData

local function hasEquipment(self, slot)
  if self._items and self._items[slot] then
    local equipId = self._items[slot]._item_id or 0
    return 0 < equipId and equipId or nil
  else
    return nil
  end
end

class.hasEquipment = hasEquipment

function class:checkEquipmentById(eid)
  if eid == 0 then
    return false
  end
  for _, item in ipairs(self._items) do
    if item._item_id == eid then
      return true
    end
  end
  return false
end

local function resetgs(self, gs)
  self._gs = gs
end

class.resetgs = resetgs

function class:updateHeroLegendEquip(heroLegendEquip)
  self._legend_equip = heroLegendEquip
end

function class:updateLegendEquip(legendEquip)
  if not self._legend_equip then
    self._legend_equip = {}
  end
  self._legend_equip._equip = legendEquip
end

function class:deleteLegendEquip()
  if not self._legend_equip then
    self._legend_equip = {}
  end
  self._legend_equip._equip = nil
end

function class:getCurrentEquip()
  if nil == self._legend_equip or #self._legend_equip == 0 then
    return nil
  end
  return self._legend_equip._equip
end

local function equip(self, slot)
  local eid = ed.getDataTable("hero_equip")[self._tid][self._rank][string.format("Equip%d ID", slot)]
  if eid == 0 then
    if ed.canAwake(self._tid) and ed.player:isHeroAwake(self._tid) then
      eid = ed.getHeroSuperTaskCsvEquipid(self._tid)
    else
      eid = ed.getHeroTaskCsvEquipid(self._tid)
    end
  end
  self._items[slot]._item_id = eid
end

class.equip = equip

local function getItem(self, slot)
  self._items = self._items or {}
  self._items[slot] = self._items[slot] or {_item_id = 0, _exp = 0}
  return self._items[slot]
end

class.getItem = getItem

local function getEquipid(self, slot)
  local item = self:getItem(slot)
  return item._item_id
end

class.getEquipid = getEquipid

local function getEquipExp(self, slot)
  local item = self:getItem(slot)
  return item[slot]._exp
end

class.getEquipExp = getEquipExp

local function addExp(self, exp)
  local oexp = self._exp
  local olevel = self._level
  self._exp = self._exp + exp
  local levelup_exp = ed.lookupDataTable("Levels", "Exp", self._level)
  ed.player.heroCache = ed.player.heroCache or {}
  ed.player.heroCache[self._tid] = ed.player.heroCache[self._tid] or {}
  local hc = ed.player.heroCache[self._tid]
  hc.preExp = oexp
  hc.preLevel = olevel
  hc.expIncrement = exp
  while true do
    levelup_exp = ed.lookupDataTable("Levels", "Exp", self._level)
    if levelup_exp == 0 then
      break
    end
    if levelup_exp <= self._exp then
      local levelLimit = ed.playerlimit.heroLevelLimit()
      if levelLimit > self._level then
        self:levelup()
      else
        if levelup_exp < self._exp then
          hc.expIncrement = (hc.expIncrement or 0) - (self._exp - levelup_exp)
          self._exp = levelup_exp
        end
        break
      end
    else
      break
    end
  end
  print(string.format("%s\t exp +%i (%i/%i). Lv%i%s.%s", self:getName(), exp, self._exp, levelup_exp, olevel, olevel == self._level and "" or " -> Lv" .. self._level, levelup_exp <= self._exp and "(rank limited)" or ""))
end

class.addExp = addExp

local function getLevelExp(self, addExp)
  local oe = self._exp
  local ol = self._level
  local ee = oe + addExp
  local el = ol
  local levelLimit = ed.playerlimit.heroLevelLimit()
  while true do
    local lue = ed.lookupDataTable("Levels", "Exp", el)
    if not lue then
      return ol, oe
    end
    if ee >= lue then
      if el < levelLimit then
        ee = ee - lue
        el = el + 1
      else
        ee = lue
        break
      end
    else
      break
    end
  end
  return el, ee
end

class.getLevelExp = getLevelExp

local function lackExpToLevel(self, targetLevel)
  local targetLevel = targetLevel or self._level + 1
  if targetLevel <= self._level then
    return 0
  end
  local levelup_exp = 0
  for k = self._level, targetLevel - 1 do
    levelup_exp = levelup_exp + ed.lookupDataTable("Levels", "Exp", k)
  end
  return levelup_exp - self._exp
end

class.lackExpToLevel = lackExpToLevel

local function getName(self)
  return ed.lookupDataTable("Unit", "Name", self._tid)
end

class.getName = getName

local function getDisplayName(self)
  return ed.lookupDataTable("Unit", "Display Name", self._tid)
end

class.getDisplayName = getDisplayName

local function levelup(self)
  local levelup_exp = math.floor(ed.lookupDataTable("Levels", "Exp", self._level))
  self._exp = self._exp - levelup_exp
  self._level = self._level + 1
  local lsr = ed.ui.baselsr.create("base")
  lsr:report("heroLevelup", {
    hid = self._tid
  })
end

class.levelup = levelup

local function evolve(self)
  self._stars = self._stars + 1
end

class.evolve = evolve

local function canUpgrade(self)
  return ed.readhero.canUpgradeHeroWithId(self._tid)
end

class.canUpgrade = canUpgrade

local function upgrade(self)
  if not canUpgrade(self) then
    EDDebug("YOU SHALL NOT UPGRADE.")
  end
  self._items = {}
  for i = 1, 6 do
    table.insert(self._items, {_item_id = 0, _exp = 0})
  end
  self._rank = self._rank + 1
  for i = 1, 6 do
    local init = ed.lookupDataTable("hero_equip", "Init" .. i .. " ID", self._tid, self._rank)
    self:equip(i, init)
  end
  self:addExp(0)
end

class.upgrade = upgrade

local function getAutoAttackRange(self)
  local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", self._tid)
  return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
end

class.getAutoAttackRange = getAutoAttackRange
local frames = {
  "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_2.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_4.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_5.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_7.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_8.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_9.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_10.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_11.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_12.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_14.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_15.png",
  "UI/alpha/1080P/common/frame/hero_icon_frame_16.png"
}
local titanFrames = {
  "UI/alpha/HVGA/Resource_for_titan/hero_icon_frame_titan.png",
  "UI/alpha/HVGA/Resource_for_titan/entity_icon_frame.png"
}

local function getIconFrame(self)
  if self:isTitan() then
    if self:isPurchaseTitan() then
      return titanFrames[2]
    else
      return titanFrames[1]
    end
  else
    return frames[self._rank]
  end
end

class.getIconFrame = getIconFrame

local function getIconFrameByRank(rank)
  return frames[rank]
end

class.getIconFrameByRank = getIconFrameByRank
local hero_star = {
  0,
  0,
  1,
  0,
  1,
  2,
  0,
  1,
  2,
  3,
  4,
  0,
  1,
  2,
  0,
  1,
  2
}
local hero_max_star = {
  0,
  1,
  1,
  2,
  2,
  2,
  4,
  4,
  4,
  4,
  4,
  2,
  2,
  2,
  2,
  2,
  2
}

local function getHeroStarByRank(rank)
  return hero_star[rank], hero_max_star[rank]
end

class.getHeroStarByRank = getHeroStarByRank

local function getHeroStar(self)
  return hero_star[self._rank], hero_max_star[self._rank]
end

class.getHeroStar = getHeroStar
local name_color = {
  ccc3(254, 251, 241),
  ccc3(248, 255, 62),
  ccc3(58, 255, 255),
  ccc3(255, 128, 255),
  ccc3(255, 152, 72),
  ccc3(255, 34, 34)
}

local function getHeroNameColorByRank(rank)
  if rank == 1 then
    return name_color[1]
  elseif 2 <= rank and rank <= 3 then
    return name_color[2]
  elseif 4 <= rank and rank <= 6 then
    return name_color[3]
  elseif 7 <= rank and rank <= 11 then
    return name_color[4]
  elseif 12 <= rank and rank <= 14 then
    return name_color[5]
  elseif 15 <= rank then
    return name_color[6]
  else
    return ccc3(255, 255, 255)
  end
end

class.getHeroNameColorByRank = getHeroNameColorByRank

local function getHeroNameColor(self)
  getHeroNameColor(self._rank)
end

class.getHeroNameColor = getHeroNameColor

function class.enhanceHero(hero)
  local hr = ed.copyProto(hero)
  setmetatable(hr, class.mt)
  local tid = hero._tid
  local level = ed.parameter.team_level_max
  local rank = ed.parameter.unit_max_rank
  local awake = 0
  local sawake = 0
  hr._rank = rank
  hr._level = level
  hr._skill_levels = ed.getHeroSkillLevels(tid, level)
  hr._items = ed.getHeroItems({
    id = tid,
    level = level,
    rank = rank,
    awake = awake,
    superawake = sawake
  })
  hr._arousal = hr._arousal or {}
  hr._arousal._status = awake
  hr._hero_rune = hr._hero_rune or {}
  hr._hero_rune._status = sawake
  return hr
end

function class.createDefaultHeroData()
  local dafaultHeroParam = {
    _tid = 0,
    _stars = 5,
    _level = 0,
    _rank = 0,
    _exp = 0,
    _gs = 8000,
    _state = "idle",
    _str = 0,
    _agi = 0,
    _int = 0,
    _str_var = 1000,
    _agi_var = 1000,
    _int_var = 1000,
    _aro_exp = 0,
    _status = 0,
    _cost_gold = 0,
    _cost_diamond = 0,
    _current_fashion = 0,
    _fashion_list = nil,
    _items = nil,
    _skill_levels = nil
  }
  return dafaultHeroParam
end

function class.getMaxHeroData(id)
  local param = class.createDefaultHeroData()
  param._tid = id
  param._level = ed.getHeroMaxLevel()
  param._rank = ed.getHeroMaxRank(id, param._level)
  param._status = 0
  param._items = ed.getHeroItems({
    id = id,
    level = param._level,
    rank = param._rank,
    awake = param._status,
    superawake = param._hero_rune._status
  })
  param._skill_levels = ed.getHeroSkillLevels(id, param._level)
  return param
end

function class:getHeroData()
  return self.data
end

function ed.Hero:getPet()
  if self._pet then
    local pet = ed.copyProto(self._pet)
    return pet
  end
end

function class:getPetId()
  if self._pet then
    return self._pet._id
  end
end

function class:getPetItem(slot)
  self._pet_bag = self._pet_bag or {}
  self._pet_bag[slot] = self._pet_bag[slot] or {_item_id = 0, _exp = 0}
  return self._pet_bag[slot]
end

function class:hasPetEquipment(slot)
  if self._pet_bag and self._pet_bag[slot] then
    local equipId = self._pet_bag[slot]._item_id or 0
    return 0 < equipId and equipId or nil
  else
    return nil
  end
end

function class:getPetEquipId(slot)
  local item = self:getPetItem(slot)
  return item._item_id
end

function class:equipPet(petData)
  self._pet = petData
end

function class:equipPetItem(slot, equipId)
  self._pet_bag[slot]._item_id = equipId
end

function class:unequipPet()
  self._pet = nil
end

function class:rsyncPetData(petData)
  self._pet = petData
end

function class:isTitan()
  return ed.lookupDataTable("Unit", "IsTitan", self._tid)
end

function class.isTitanById(id)
  return ed.lookupDataTable("Unit", "IsTitan", id)
end

function class:isPurchaseTitan()
  return class.isPurchaseTitanById(self._tid)
end

function class.isPurchaseTitanById(id)
  local isTitan = class.isTitanById(id)
  if isTitan then
    local info = ed.lookupDataTable("TitanToHeros", nil, id)
    if info then
      return 0 == info.MatrixHeroID1 or 0 == info.MatrixHeroID5
    end
    return false
  end
  return false
end

function class.getComposeTitanId(heroId)
  local jumpArr = ed.lookupDataTable("Unit", "Belong to Titan", heroId) or {}
  if 0 < #jumpArr then
    local titanTbl = ed.getDataTable("TitanToHeros")
    local serverTime = ed.getServerTime()
    for i = #jumpArr, 1, -1 do
      local titanId = jumpArr[i]
      local titanInfo = titanTbl[titanId]
      if titanInfo then
        local onlineTime = 0
        local onlineTimeStr = titanInfo.OnlineTime
        if nil ~= onlineTimeStr and "" ~= onlineTimeStr then
          onlineTime = ed.getTimeByYMDHMS(onlineTimeStr)
        end
        if serverTime >= onlineTime then
          return titanId
        end
      end
    end
  end
  return 0
end

function class:getTarotCards()
  local tarotCards = {}
  if rawget(self.data, "_tarot") then
    tarotCards = self.data._tarot._tarot_rares
  elseif rawget(self.data, "_tarot_cards") then
    tarotCards = self.data._tarot_cards
  else
    local childData = rawget(self.data, ".data")
    if childData and "table" == type(childData) then
      if rawget(childData, "_tarot") then
        tarotCards = self.data._tarot._tarot_rares
      elseif rawget(childData, "_tarot_cards") then
        tarotCards = self.data._tarot_cards
      end
    end
  end
  return tarotCards
end

function class:hasArcana()
  if not self:isTitan() then
    return false
  end
  if self._stars < 7 then
    return false
  end
  if not self._arcana or self._arcana._level == 0 then
    return false
  end
  return true
end

function class:getArcana()
  if not self:hasArcana() then
    return nil
  end
  self.arcana = ed.Arcana.create()
  self.arcana:setup(self._arcana)
  self.arcana.heroId = self._tid
  return self.arcana
end

function class:getActivedBondIdsList()
  if not self.data or not self.data._bond then
    return {}
  else
    return self.data._bond[".data"]._bond_ids
  end
end

function class:bondIsActived(bondId)
  for _, id in ipairs(self:getActivedBondIdsList()) do
    if bondId == id then
      return true
    end
  end
  return false
end

function class.getCampEngNameByCampId(campId)
  local tb = ed.getDataTable("CampCrystalCounter")
  local row = tb[campId]
  return row.Union
end

function class.getCampIdByCampEngName(campEngName)
  local tb = ed.getDataTable("CampCrystalCounter")
  for campId, row in ipairs(tb) do
    if row.Union == campEngName then
      return campId
    end
  end
  return nil
end

function class.getCampIdByUnitId(unitId)
  local row = ed.getDataTable("Unit")[unitId]
  local unionName = row and row.Union or ""
  return class.getCampIdByCampEngName(unionName)
end

function class.getCampCounterType(selfCampId, enemyCampId)
  local tb = ed.getDataTable("CampCrystalCounter")
  local row = tb[selfCampId]
  if not row then
    return "none"
  end
  local counterCampId = row["Counter Camp"]
  local counteredCampId = row["Countered Camp"]
  if counterCampId == enemyCampId then
    return "counter"
  end
  if counteredCampId == enemyCampId then
    return "countered"
  end
  return "none"
end

function class.getCampCounterTypeByUnitId(selfUnitId, enemyUnitId)
  local selfCampId = class.getCampIdByUnitId(selfUnitId)
  local enemyCampId = class.getCampIdByUnitId(enemyUnitId)
  return class.getCampCounterType(selfCampId, enemyCampId)
end

local campId2ResNameMap = {
  [1] = "camp_icon02",
  [2] = "camp_icon01",
  [3] = "camp_icon05",
  [4] = "camp_icon04",
  [5] = "camp_icon03"
}

function class.getCampIconResByCampId(campId)
  local resName = campId2ResNameMap[campId]
  local res = string.format("UI/alpha/HVGA/camp/%s.png", resName)
  return res
end

local campId2CampNameMap = {
  [1] = T("\232\135\170\231\132\182\228\185\139\230\128\146"),
  [2] = T("\228\188\160\229\165\135\232\174\174\228\188\154"),
  [3] = T("\233\147\182\230\178\179\229\134\155\229\155\162"),
  [4] = T("\230\176\184\230\129\146\229\156\163\229\159\159"),
  [5] = T("\230\188\134\233\187\145\230\132\143\229\191\151")
}

function class.getCampNameByCampId(campId)
  return campId2CampNameMap[campId]
end

function class.getMagicStonePlan(hero)
  local r = pcall(function()
    local ms = hero._magicstone
  end)
  if not r then
    return
  end
  local stoneInfo = hero._magicstone
  if not stoneInfo then
    return
  end
  if stoneInfo._plan then
    return stoneInfo._plan
  end
  local plans = ed.player:getMagicStonePlans()
  local planId = stoneInfo._plan_id
  for k, v in ipairs(plans) do
    local pid = v._id
    if pid == planId then
      return v
    end
  end
end
