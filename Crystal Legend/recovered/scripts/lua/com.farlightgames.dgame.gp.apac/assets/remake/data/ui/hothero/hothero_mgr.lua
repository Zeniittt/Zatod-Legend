module("ed.hothero", package.seeall)
manager = {}
manager.__index = manager

function manager.create()
  local object = {}
  setmetatable(object, manager)
  object:initData()
  return object
end

function manager:initData()
  self.hotHeroList = {}
end

function manager:initHotHero(hotHeroList)
  self.hotHeroList = hotHeroList or {}
  self.newHeroList = self:getNewHeroList(self.hotHeroList)
  self:initRecommendRed()
end

function manager:getHotHeroList(...)
  return self.hotHeroList
end

function manager:getNewHeroList(hotHeroList)
  local newHeroList = {}
  for _, hotHero in ipairs(hotHeroList) do
    if hotHero._flag and hotHero._flag == 1 then
      newHeroList[#newHeroList + 1] = hotHero
    end
  end
  return newHeroList
end

function manager:getHeroHot(heroid)
  for _, hotHero in ipairs(self.hotHeroList) do
    if hotHero._heroid == heroid then
      return hotHero._hot
    end
  end
  return 500
end

function manager:initRecommendRed()
  for _, newHero in ipairs(self.newHeroList) do
    if newHero._heroid and not self:getNewHeroOpenRecord(newHero._heroid) then
      self.recommendRed = true
    end
  end
end

function manager:hasHotHeroRecommendRed()
  return self.recommendRed
end

function manager:saveNewHeroOpenRecord(heroid)
  local alreadopen = "herorecommend_newhero_alreadopen" .. game_server_id .. ed.getUserid() .. heroid
  ed.storage.setValue(alreadopen, "true")
end

function manager:getNewHeroOpenRecord(heroid)
  local alreadopen = "herorecommend_newhero_alreadopen" .. game_server_id .. ed.getUserid() .. heroid
  local open = ed.storage.getString(alreadopen)
  if open == "true" then
    return true
  end
end

function manager:doClearNewHeroRecord()
  for _, newHero in ipairs(self.newHeroList) do
    if newHero._heroid then
      self:saveNewHeroOpenRecord(newHero._heroid)
    end
  end
  self.recommendRed = false
end

manager = manager.create()
