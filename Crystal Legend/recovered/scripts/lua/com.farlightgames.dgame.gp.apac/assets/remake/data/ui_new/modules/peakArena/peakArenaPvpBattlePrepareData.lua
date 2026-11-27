local PeakArenaPvpBattlePrepareData = {}
ed.PeakArenaPvpBattlePrepareData = PeakArenaPvpBattlePrepareData

function PeakArenaPvpBattlePrepareData.getInstance()
  if not PeakArenaPvpBattlePrepareData.instance then
    PeakArenaPvpBattlePrepareData.instance = setmetatable({}, {__index = PeakArenaPvpBattlePrepareData}):init()
  end
  return PeakArenaPvpBattlePrepareData.instance
end

function PeakArenaPvpBattlePrepareData:init()
  return self
end

function PeakArenaPvpBattlePrepareData:InitHeroListData(param)
  local banedHeroIdList = param.banedHeroIdList or {}
  local serverTime = ed.getServerTime()
  local heroes = {}
  for _, hero in pairs(ed.player:getAllHero() or {}) do
    local data = hero.data
    if data and data._tid and ed.readhero.isHeroOpen(data._tid, serverTime) then
      local heroInfo = ed.copyProto(data)
      heroInfo._gs = heroInfo._gs or 5
      table.insert(heroes, heroInfo)
    end
  end
  local UnitTable = ed.getDataTable("Unit")
  table.sort(heroes, function(a, b)
    local aTid = a._tid
    local bTid = b._tid
    local aInitStar = UnitTable[aTid]["Initial Stars"]
    local bInitStar = UnitTable[bTid]["Initial Stars"]
    local aIsBaned = ed.isElementInTable(aTid, banedHeroIdList) and 0 or 1
    local bIsBaned = ed.isElementInTable(bTid, banedHeroIdList) and 0 or 1
    if aIsBaned == bIsBaned then
      if a._level == b._level then
        if a._rank == b._rank then
          if a._stars == b._stars then
            if aInitStar == bInitStar then
              if a._gs == b._gs then
                return aTid < bTid
              else
                return a._gs > b._gs
              end
            else
              return aInitStar > bInitStar
            end
          else
            return a._stars > b._stars
          end
        else
          return a._rank > b._rank
        end
      else
        return a._level > b._level
      end
    else
      return aIsBaned > bIsBaned
    end
  end)
  return self.classifyByPos(heroes)
end

function PeakArenaPvpBattlePrepareData.classifyByPos(heroes)
  local idToIndex = {}
  local unit = ed.getDataTable("Unit")
  for i, v in ipairs(heroes) do
    local pos = unit[v._tid]["Position Type"]
    local isTitan = unit[v._tid].IsTitan
    if pos == T("\229\137\141\230\142\146") then
      v.category = "front"
    elseif pos == T("\228\184\173\230\142\146") then
      v.category = "middle"
    elseif pos == T("\229\144\142\230\142\146") then
      v.category = "back"
    end
    if isTitan then
      v.isTitan = true
    end
    idToIndex[v._tid] = i
  end
  return heroes, idToIndex
end

function PeakArenaPvpBattlePrepareData.sortHeroesByAttackRange(heroList, reverse)
  local function attackRange(heroId)
    if not heroId or heroId == 0 then
      return 0
    end
    local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", heroId)
    return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0) or 0
  end
  
  table.sort(heroList, function(a, b)
    if reverse then
      return attackRange(a._tid) > attackRange(b._tid)
    else
      return attackRange(a._tid) < attackRange(b._tid)
    end
  end)
  return heroList
end

function PeakArenaPvpBattlePrepareData.createEmptyHero(tid)
  local function getInitSkillLevels(this, tid)
    local levels = {}
    
    for slot, group in pairs(this[tid]) do
      local level = group["Init Level"]
      levels[slot] = level
    end
    return levels
  end
  
  local hero = ed.commonmsg.hero()
  hero._tid = tid
  hero._level = 1
  hero._rank = ed.lookupDataTable("Unit", "Initial Rank", tid)
  hero._exp = 0
  hero._gs = 5
  hero._stars = ed.getDataTable("Unit")[tid]["Initial Stars"]
  hero._skill_levels = {}
  hero._items = {}
  hero._state = "idle"
  for i = 1, 6 do
    local item = ed.commonmsg.hero_equip()
    item._index = i
    item._item_id = 0
    item._exp = 0
    table.insert(hero._items, item)
  end
  hero._skill_levels = getInitSkillLevels(ed.getDataTable("SkillGroup"), tid)
  local emptyHero = ed.HeroCreate()
  emptyHero:setup(hero)
  return emptyHero
end
