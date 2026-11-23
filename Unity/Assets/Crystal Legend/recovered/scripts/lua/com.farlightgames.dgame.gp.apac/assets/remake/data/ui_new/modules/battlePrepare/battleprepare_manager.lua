module("ed.battleprepare", package.seeall)
manager = {}
manager.__index = manager

function manager.create()
  local object = {}
  setmetatable(object, manager)
  return manager
end

function manager:sendRequestMercenary(type)
  if not type then
    return
  end
  local msg = ed.upmsg.guild()
  msg._query_hires = {}
  msg._query_hires._from = type
  ed.send(msg, "guild")
end

function manager:sendHireHero(hero, type)
  local info = hero:getMercenaryData()
  local msg = ed.upmsg.guild()
  msg._hire_hero = {}
  msg._hire_hero._uid = info._uid
  msg._hire_hero._heroid = hero._tid
  msg._hire_hero._from = type
  ed.send(msg, "guild")
end

function manager:createLabel(text)
  local listTitle = ed.createLabelWithFontInfo(text, "title_yellow")
  listTitle:setAnchorPoint(ccp(0.5, 1))
  listTitle:setDimensions(CCSizeMake(490, 0))
  listTitle:setHorizontalAlignment(kCCTextAlignmentCenter)
  local height = listTitle:getContentSize().height
  return listTitle, height
end

function manager:sortHeroByLevel(mercenaryHeros)
  local function levelMercenary(hero)
    return hero._level
  end
  
  table.sort(mercenaryHeros, function(a, b)
    return levelMercenary(a) > levelMercenary(b)
  end)
end

function manager:sortMercenaryHeros(data)
  local list, blist, mlist = {}, {}, {}
  for i, v in ipairs(data) do
    if v.mercenaryData._sort == "cHired" then
      table.insert(blist, v)
    else
      table.insert(mlist, v)
    end
  end
  self:sortHeroByLevel(blist)
  self:sortHeroByLevel(mlist)
  for i, v in ipairs(blist) do
    table.insert(list, v)
  end
  for i, v in ipairs(mlist) do
    table.insert(list, v)
  end
  return list
end

function manager:adjustGuildheroPos(heros)
  for idx, hero in ipairs(heros) do
    local uid = hero.mercenaryData._uid
    if ed.readhero.isGuildheroMercenary({uid = uid}) then
      table.remove(heros, idx)
      table.insert(heros, 1, hero)
      break
    end
  end
end

function manager:classfiyMercenHeroes(heroes)
  local filterData = {}
  for _, hero in ipairs(heroes) do
    local myhero = ed.player:getHero(hero._tid)
    if myhero == nil or not (myhero._level > hero._level + 10) then
      table.insert(filterData, hero)
    end
  end
  local heroes = ed.readhero.getAllListWithLimit(self.heroLimit or {}, filterData)
  local heroes = self:sortMercenaryHeros(heroes)
  self:adjustGuildheroPos(heroes)
  local listData = self:classfiyHeroes(heroes)
  return listData
end

function manager:classfiyHeroes(heroes)
  local all, front, middle, back = ed.readhero.classify("prepare", "position", nil, heroes)
  local collect = ed.HeroRecommendManager:filtrCollectHero(all)
  local heroesList = {
    all = all,
    collect = collect,
    front = front,
    middle = middle,
    back = back
  }
  return heroesList
end

function manager:createHeroesByIdlist(idlist)
  local heroes = {}
  for _, heroid in ipairs(idlist) do
    local hero = ed.player.heroes[heroid]
    if hero then
      heroes[#heroes + 1] = hero
    else
      heroes[#heroes + 1] = manager:createEmptyHero(heroid)
    end
  end
  return heroes
end

function manager:createEmptyHero(tid)
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
  hero._skill_levels = ed.getInitSkillLevels(tid)
  local emptyHero = ed.HeroCreate()
  emptyHero:setup(hero)
  return emptyHero
end

manager = manager.create()
