module("ed.herorecommend", package.seeall)
mainpanelMgr = {}
mainpanelMgr.__index = mainpanelMgr

function mainpanelMgr.create(data)
  local object = {}
  setmetatable(object, mainpanelMgr)
  object:initData(data)
  return object
end

function mainpanelMgr:initData(data)
  self.modeTable = ed.getDataTable("RecommendMode")
  self:splitHotHeros(data)
  self.classifyInfoList = self:createClassifyInfoList(data)
end

function mainpanelMgr:splitHotHeros(data)
  local hotHeroes = data._heros or {}
  self.hotHeroTop3 = {}
  self.hotHeroes = {}
  for rank, hero in ipairs(hotHeroes) do
    local hero = {
      rank = rank,
      heroid = hero._heroid,
      hot = hero._hot,
      newhero = hero._flag == 1
    }
    if rank <= 3 then
      self.hotHeroTop3[#self.hotHeroTop3 + 1] = hero
    else
      self.hotHeroes[#self.hotHeroes + 1] = hero
    end
  end
end

function mainpanelMgr:createClassifyInfoList(data)
  local classifyData = data._recommends or {}
  local list = {}
  for _, data in ipairs(classifyData) do
    local modeid = data._gameplay
    local classifyInfo = {
      modeid = modeid,
      heroes = self:createHeroes(data._heroids or {})
    }
    table.insert(list, classifyInfo)
  end
  return list
end

function mainpanelMgr:createHeroes(heroids)
  local heroes = {}
  for rank, heroid in ipairs(heroids) do
    local hero = {rank = rank, heroid = heroid}
    heroes[#heroes + 1] = hero
  end
  return heroes
end

function mainpanelMgr:filtrHaveHero(heroes)
  local list = {}
  for _, hero in ipairs(heroes) do
    if ed.player.heroes[hero.heroid] then
      table.insert(list, hero)
    end
  end
  return list
end

function mainpanelMgr:filtrDonthaveHero(heroes)
  local list = {}
  for _, hero in ipairs(heroes) do
    if not ed.player.heroes[hero.heroid] then
      table.insert(list, hero)
    end
  end
  return list
end
