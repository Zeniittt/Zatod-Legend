local class = newclass("g")
ed.rogueCharmBase = class

function class.charmCreate(charmId, exp)
  local self = {charmId = charmId, exp = exp}
  setmetatable(self, {__index = class})
  local charmTableItem = ed.getDataTable("RogueCharm")[charmId]
  self.level = self:getCharmStarNum(exp, charmTableItem)
  self.info = self:getCharmEffectInfo(charmId)
  return self
end

function class:init()
  self:addBuff()
end

function class:reset()
end

function class:clear()
end

function class:getCharmStarNum(exp, tableItem)
  local levelArr = tableItem["Level Up Require"] or {}
  local index = 0
  for i = #levelArr, 1, -1 do
    if exp >= levelArr[i] then
      index = i
      break
    end
  end
  local starNum = index + 1
  local lastRquire = 0 == index and 0 or levelArr[index + 1]
  local nextRequire = #levelArr == index and 0 or levelArr[index + 1]
  return starNum, lastRquire, nextRequire
end

function class:getCharmEffectInfo(charmId)
  local charmTableItem = ed.getDataTable("RogueCharm")[charmId]
  local effectId = charmTableItem["Effect ID"][1] or 1
  local info = ed.getDataTable("RogueCharmEffect")[effectId]
  info = setmetatable({}, {__index = info})
  return info
end

function class:addBuff()
  local buffId = self.info["Buff ID"]
  local buffTarget = self.info["Buff Target"]
  if not buffId or buffId == 0 or not buffTarget then
    return
  end
  local targetCamp
  if buffTarget == "SELF" then
    targetCamp = ed.emCampPlayer
  elseif buffTarget == "ENEMY" then
    targetCamp = ed.emCampEnemy
  end
  for unit in ed.engine:foreachAliveUnit(targetCamp) do
    if not unit.config.is_summoned then
      local buffInfo = ed.getDataTable("Buff")[buffId]
      local buff = ed.BuffCreate(buffInfo, unit, unit)
      unit:addBuff(buff, unit)
    end
  end
end

function class:apply(unit)
end
