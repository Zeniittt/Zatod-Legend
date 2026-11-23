local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class:initData()
end

function class:filtrCollectHero(heroList)
  local newList = {}
  local collectList = ed.player:getCollectList()
  local collectHash = {}
  for _, heroid in ipairs(collectList) do
    collectHash[heroid] = true
  end
  for _, hero in ipairs(heroList) do
    local heroid = hero._tid
    if collectHash[heroid] then
      newList[#newList + 1] = hero
    end
  end
  return newList
end

ed.HeroRecommendManager = class.getInstance()
return class
