module("ed.realarena", package.seeall)
local ed = ed
local equip_slot_count = 6
local max_hero_rank = 13
local max_hero_stars = 5
local max_hero_level = 80
local max_shard_level = 25
local realarna_max_hero_rank = max_hero_rank
local realarna_max_hero_level = max_hero_level
local realarna_max_shard_level = max_shard_level
HeroMgr = {}
HeroMgr.__index = HeroMgr

function HeroMgr.Create(public_hero_ids, level_rank, public_legend_equips)
  local hero_mgr = {}
  hero_mgr.what = "RealArenaHeroMgr"
  setmetatable(hero_mgr, HeroMgr)
  realarna_max_hero_rank = level_rank._rank
  realarna_max_hero_level = level_rank._level
  hero_mgr:Init(public_hero_ids, public_legend_equips)
  return hero_mgr
end

function HeroMgr:Destroy()
  self.hostHeroes = nil
  self.guestHeroes = nil
  self.public_hero_ids = nil
  self.public_legend_equips = nil
  self.heroes_public = nil
  self.shopheroes = nil
  self.employlist = nil
  self.awakelist = nil
  self.promotelist = nil
  self.allAwakeHeroes = nil
end

function HeroMgr:Init(public_hero_ids, public_legend_equips)
  self.public_hero_ids = public_hero_ids
  self.public_legend_equips = public_legend_equips
  self:initOnlineHeroes()
  self:InitPublicHeroes()
  self.hostHeroes = {}
  self.guestHeroes = {}
end

local function judgeCanUseEquip(hid, rk, level)
  for i = 1, equip_slot_count do
    local iid = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", hid, rk)
    if iid ~= 0 and iid ~= nil then
      local rl = ed.getDataTable("equip")[iid]["Level Requirement"]
      if level < rl then
        return false
      end
    end
  end
  return true
end

function ed.getHeroMaxRank(hid, level)
  if level ~= nil then
    for rk = 1, max_hero_rank do
      if not judgeCanUseEquip(hid, rk, level) then
        return rk
      end
    end
  end
  return max_hero_rank
end

function ed.getHeroMaxLevel()
  return max_hero_level
end

function ed.getHeroSkillLevels(id, level)
  local levels = {}
  local skills = ed.getDataTable("SkillGroup"):getAllSkills(id)
  for i, v in pairs(skills) do
    levels[v.Slot] = level
  end
  local baseSkillSlot = 5
  levels[baseSkillSlot] = 1
  return levels
end

function ed.getHeroItems(params)
  local id = params.id
  local rank = params.rank
  local level = params.level
  local awakeStatus = params.awake
  local superAwake = params.superawake
  local items = {}
  for i = 1, equip_slot_count do
    local item = ed.commonmsg.hero_equip()
    item._index = i
    item._item_id = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", id, rank)
    item._exp = 0
    if item._item_id ~= 0 then
      item._exp = 3210
      local rl = ed.getDataTable("equip")[item._item_id]["Level Requirement"]
      if level < rl then
        item._item_id = 0
      end
    elseif superAwake == 1 then
      item._item_id = ed.getDataTable("HeroTask"):getHeroSuperTaskCsvEquipid(id)
      item._exp = 3210
    elseif awakeStatus == 1 then
      item._item_id = ed.getDataTable("HeroTask"):getHeroTaskCsvEquipid(id)
      item._exp = 2000
    end
    items[i] = item
  end
  return items
end

function HeroMgr:createPublicHeroes(id, extraParam)
  local level = realarna_max_hero_level
  local rank = realarna_max_hero_rank
  extraParam = extraParam or {}
  local shard
  local shardCfg = ed.heroDetailManager.getHeroIsShard(id)
  if shardCfg then
    shard = {
      _id = shardCfg["Shard ID"],
      _level = realarna_max_shard_level
    }
  end
  local param = {
    _tid = id,
    _level = level,
    _rank = rank,
    _shard = shard,
    _stars = max_hero_stars
  }
  for k, v in pairs(extraParam) do
    param[k] = v
  end
  local hero = ed.HeroCreate()
  hero:setup(param)
  hero.free = true
  return hero
end

function HeroMgr:createLegendEquip(typeId)
  if not typeId then
    return
  end
  local legendEquip = {
    _equip = {
      _type_id = typeId,
      _star = 5,
      _rank = 0
    }
  }
  return legendEquip
end

function HeroMgr:initOnlineHeroes()
  local unitTB = ed.getDataTable("Unit")
  self.onlineHeroAll = {}
  self.onlineHeroFront = {}
  self.onlineHeroMiddle = {}
  self.onlineHeroBack = {}
  self.onlineHeroSTR = {}
  self.onlineHeroINT = {}
  self.onlineHeroAGI = {}
  for unitId, UnitCfg in pairs(unitTB) do
    if UnitCfg["Unit Type"] == "Hero" and ed.readhero.isHeroOpen(unitId) then
      table.insert(self.onlineHeroAll, unitId)
      local pos = UnitCfg["Position Type"]
      if pos == T("\229\137\141\230\142\146") then
        table.insert(self.onlineHeroFront, unitId)
      elseif pos == T("\228\184\173\230\142\146") then
        table.insert(self.onlineHeroMiddle, unitId)
      elseif pos == T("\229\144\142\230\142\146") then
        table.insert(self.onlineHeroBack, unitId)
      end
      local mainAttr = UnitCfg["Main Attrib"]
      if mainAttr == "STR" then
        table.insert(self.onlineHeroSTR, unitId)
      elseif mainAttr == "INT" then
        table.insert(self.onlineHeroINT, unitId)
      elseif mainAttr == "AGI" then
        table.insert(self.onlineHeroAGI, unitId)
      end
    end
  end
  self:sortOnlineHero(self.onlineHeroAll)
  self:sortOnlineHero(self.onlineHeroFront)
  self:sortOnlineHero(self.onlineHeroMiddle)
  self:sortOnlineHero(self.onlineHeroBack)
  self:sortOnlineHero(self.onlineHeroSTR)
  self:sortOnlineHero(self.onlineHeroINT)
  self:sortOnlineHero(self.onlineHeroAGI)
end

function HeroMgr:sortOnlineHero(list)
  table.sort(list, ed.cmpSort({
    {
      getValue = function(unitId)
        local timeStr = ed.getDataTable("Unit")[unitId]["Online Time"]
        if timeStr then
          local onlineTime = ed.getTimeByYMDHMS(timeStr)
          return onlineTime
        else
          return 0
        end
      end,
      reverse = true
    },
    {
      getValue = function(unitId)
        return unitId
      end,
      reverse = true
    }
  }))
end

function HeroMgr:getOnlineHero()
  return self.onlineHeroAll, self.onlineHeroFront, self.onlineHeroMiddle, self.onlineHeroBack, self.onlineHeroSTR, self.onlineHeroINT, self.onlineHeroAGI
end

function HeroMgr:InitPublicHeroes()
  self.heroes_public = {}
  self.public_hero_to_legend_equip_type = {}
  for i, id in ipairs(self.public_hero_ids) do
    local legendEquip
    local myHero = ed.player:getHero(id)
    if myHero and myHero._legend_equip then
      legendEquip = myHero._legend_equip
    else
      local legendEquipTypeId = self.public_legend_equips and self.public_legend_equips[i]
      legendEquip = self:createLegendEquip(legendEquipTypeId)
      self.public_hero_to_legend_equip_type[id] = legendEquipTypeId
    end
    local hero = self:createPublicHeroes(id, {_legend_equip = legendEquip})
    table.insert(self.heroes_public, hero)
  end
end

function HeroMgr:GetPublicHero(index)
  return self.heroes_public[index]
end

function HeroMgr:GetPublicHeroByID(id)
  for i, hero in ipairs(self.heroes_public) do
    if id == hero._tid then
      return hero
    end
  end
end

function HeroMgr:GetPublicHeroList()
  return self.heroes_public
end

function HeroMgr:checkIsFreeHero(heroId)
  return ed.isElementInTable(heroId, self.public_hero_ids)
end

function HeroMgr:SortHeroes(list)
  table.sort(list, function(a, b)
    local freeA = ed.isElementInTable(a._tid, self.public_hero_ids or {}) and 1 or 0
    local freeB = ed.isElementInTable(b._tid, self.public_hero_ids or {}) and 1 or 0
    if freeA ~= freeB then
      return freeA > freeB
    elseif a._level ~= b._level then
      return b._level < a._level
    elseif a._stars ~= b._stars then
      return b._stars < a._stars
    elseif a._rank ~= b._rank then
      return b._rank < a._rank
    elseif a._tid ~= b._tid then
      return a._tid < b._tid
    else
      return false
    end
  end)
  local openList = {}
  local serverTime = ed.getServerTime()
  for i, v in ipairs(list) do
    if ed.readhero.isHeroOpen(v._tid, serverTime) then
      table.insert(openList, v)
    end
  end
  return openList
end

function HeroMgr:initHostHeroes(hostHeroes)
  self.hostHeroes = {}
  for i, public_hero_id in ipairs(self.public_hero_ids) do
    local hostHero
    for _, heroInfo in ipairs(hostHeroes or {}) do
      if heroInfo._id == public_hero_id then
        hostHero = heroInfo
        break
      end
    end
    local publicLegendEquip = self:createLegendEquip(self.public_hero_to_legend_equip_type[hostHero._id])
    local public_hero = self:createPublicHeroes(public_hero_id, {
      _fashion = hostHero and hostHero._fashion,
      _star = hostHero and math.min(hostHero._star, max_hero_stars) or max_hero_stars,
      _legend_equip = hostHero and hostHero._legend_equip or publicLegendEquip
    })
    table.insert(self.hostHeroes, public_hero)
  end
  for i, hostHero in ipairs(hostHeroes) do
    if not ed.isElementInTable(hostHero._id, self.public_hero_ids) or hostHero._star >= max_hero_stars then
      local id = hostHero._id
      local level = realarna_max_hero_level
      local rank = realarna_max_hero_rank
      local shard
      local shardCfg = ed.heroDetailManager.getHeroIsShard(id)
      if shardCfg then
        shard = {
          _id = shardCfg["Shard ID"],
          _level = realarna_max_shard_level
        }
      end
      local param = {
        _tid = id,
        _level = level,
        _rank = rank,
        _shard = shard,
        _stars = hostHero._star,
        _fashion = hostHero._fashion,
        _legend_equip = hostHero._legend_equip
      }
      local hero = ed.HeroCreate()
      hero:setup(param)
      table.insert(self.hostHeroes, hero)
    end
  end
end

function HeroMgr:initGuestHeroes(guestHeroes)
  self.guestHeroes = {}
  for i, public_hero_id in ipairs(self.public_hero_ids) do
    local guestHero
    for _, heroInfo in ipairs(guestHeroes or {}) do
      if heroInfo._id == public_hero_id then
        guestHero = heroInfo
        break
      end
    end
    local publicLegendEquip = self:createLegendEquip(self.public_hero_to_legend_equip_type[guestHero._id])
    local public_hero = self:createPublicHeroes(public_hero_id, {
      _fashion = guestHero and guestHero._fashion,
      _star = guestHero and math.min(guestHero._star, max_hero_stars) or max_hero_stars,
      _legend_equip = guestHero and guestHero._legend_equip or publicLegendEquip
    })
    table.insert(self.guestHeroes, public_hero)
  end
  for i, heroInfo in ipairs(guestHeroes or {}) do
    if not ed.isElementInTable(heroInfo._id, self.public_hero_ids) or heroInfo._star >= max_hero_stars then
      local id = heroInfo._id
      local level = realarna_max_hero_level
      local rank = realarna_max_hero_rank
      local shard
      local shardCfg = ed.heroDetailManager.getHeroIsShard(id)
      if shardCfg then
        shard = {
          _id = shardCfg["Shard ID"],
          _level = realarna_max_shard_level
        }
      end
      local param = {
        _tid = id,
        _level = level,
        _rank = rank,
        _shard = shard,
        _stars = heroInfo._star,
        _fashion = heroInfo._fashion,
        _legend_equip = heroInfo._legend_equip
      }
      local hero = ed.HeroCreate()
      hero:setup(param)
      table.insert(self.guestHeroes, hero)
    end
  end
  self.guestHeroes = self:SortHeroes(self.guestHeroes)
end

function HeroMgr:GetHero(index)
  return self.hostHeroes[index]
end

function HeroMgr:getHostHeroByID(id)
  for i, hero in ipairs(self.hostHeroes) do
    if id == hero._tid then
      return hero
    end
  end
end

function HeroMgr:getAllHeroList()
  return self.hostHeroes
end

function HeroMgr:getGuestHeroList()
  return self.guestHeroes or {}
end

function HeroMgr:getGuestHeroByID(id)
  for _, v in pairs(self:getGuestHeroList()) do
    if id == v._tid then
      return v
    end
  end
end

function HeroMgr:getHeroByIDFromAllList(id)
  for _, v in pairs(self:getAllHeroList()) do
    if id == v._tid then
      return v
    end
  end
end

function HeroMgr:getHeroByIDWithEmploy(id)
  return self:getHeroByIDFromAllList(id)
end

function HeroMgr:GetHeroList()
  return self.hostHeroes
end

function HeroMgr:getHeroListWithEmploy()
  return {}
end

function HeroMgr:GetHeroIDList()
  local id_list = {}
  for i, hero in ipairs(self.hostHeroes) do
    table.insert(id_list, hero._tid)
  end
  return id_list
end

function HeroMgr:UpdateData(hero_infos)
  for i, hero_info in ipairs(hero_infos or {}) do
    local hero = self:getHostHeroByID(hero_info._id)
    if hero then
      hero._gs = hero_info._gs
    end
  end
end

function HeroMgr:addAwakeHero(tid)
  self.awakelist[tid] = true
  self.allAwakeHeroes[tid] = true
end

function HeroMgr:addPromoteHero(tid, star)
  if not self.promotelist[tid] then
    self.promotelist[tid] = 0
  end
  self.promotelist[tid] = self.promotelist[tid] + star
end

function HeroMgr:getEmployList()
  return self.employlist
end

function HeroMgr:getAwakeList()
  return self.awakelist
end

function HeroMgr:getPromoteList()
  return self.promotelist
end

function HeroMgr:getAllAwakeHeroes()
  return self.allAwakeHeroes
end

function HeroMgr:getAllSAwakeHeroes()
  return self.allSAwakeHeroes
end

function HeroMgr:getShopHeroes()
  return self.shopheroes
end

function HeroMgr:getPromoteHeroStarSize(tid)
  if not self.promotelist[tid] then
    return 0
  end
  return self.promotelist[tid]
end

function HeroMgr:isAwakeHero(tid)
  return self.allAwakeHeroes[tid] ~= nil
end

function HeroMgr:isSAwakeHero(tid)
  return self.allSAwakeHeroes[tid] ~= nil
end

function HeroMgr:isEmployHero(tid)
  return self.employlist[tid] ~= nil
end

function HeroMgr:getRealarenaMaxHeroLevel()
  return realarna_max_hero_level
end

function HeroMgr:getRealarenaMaxHeroRank()
  return realarna_max_hero_rank
end

function HeroMgr:setHostHeroes(heroes)
  self:initHostHeroes(heroes)
end

function HeroMgr:setGuestHeroes(heroes)
  self:initGuestHeroes(heroes)
end

function HeroMgr:heroIsRestricted(tid)
  local KingsPvpHeroLimitList = ed.getDataTable("KingsPVPConfig")["Hero Restricted"].Value or {}
  return ed.isElementInTable(tid, KingsPvpHeroLimitList)
end

function HeroMgr:setFreeTime(startTime, endTime)
  self.startTime, self.endTime = startTime, endTime
end

function HeroMgr:getFreeTime()
  return self.startTime, self.endTime
end
