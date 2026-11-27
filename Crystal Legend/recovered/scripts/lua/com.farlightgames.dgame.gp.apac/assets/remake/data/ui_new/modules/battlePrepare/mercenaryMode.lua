module("ed.battleprepare", package.seeall)
mercenaryMode = {}
mercenaryMode.__index = mercenaryMode

function mercenaryMode.create(param, data)
  local object = {}
  setmetatable(object, mercenaryMode)
  object:initData(param, data)
  return object
end

function mercenaryMode:initData(param, data)
  self.type = param.type
  self.heroes = {}
  for _, hero in ipairs(data) do
    local key = self:getHashKey(hero)
    self.heroes[key] = hero
  end
end

function mercenaryMode:getHero(key)
  return self.heroes[key]
end

function mercenaryMode:isDead(key)
  local hero = self.heroes[key]
  local hp_perc = hero:hp_perc(self.type)
  if nil ~= hp_perc and hp_perc <= 0 then
    return true
  end
  return false
end

function mercenaryMode:isHired(key)
  local hero = self.heroes[key]
  local mercenaryInfo = hero:getMercenaryData()
  if mercenaryInfo._sort and mercenaryInfo._sort == "bHired" then
    return true
  end
  return false
end

function mercenaryMode:isLevelLimit(key)
  local hero = self.heroes[key]
  local mercenaryInfo = hero:getMercenaryData()
  if mercenaryInfo._sort == "bLevel" then
    return true
  end
  return false
end

function mercenaryMode:getHashKey(hero)
  local mercenaryInfo = hero:getMercenaryData()
  local uid = mercenaryInfo._uid
  local heroid = hero._tid
  return uid .. "head" .. heroid
end
