local class = newclass("g")
ed.rogueTechBase = class

function class.techCreate(techTreeId, techId)
  local self = {techTreeId = techTreeId, techId = techId}
  setmetatable(self, {__index = class})
  self.info = self:getTechInfo(self.techTreeId, self.techId)
  return self
end

function class:init()
  self:addBuff()
  self:addAttr()
end

function class:reset()
end

function class:clear()
end

function class:getTechInfo(techTreeId, techId)
  local info = ed.getDataTable("RogueTech")[techTreeId][techId]
  info = setmetatable({}, {__index = info})
  return info
end

function class:addBuff()
  local buffId = self.info["Buff ID"]
  local buffTarget = self.info.Target
  if not buffId or buffId == 0 or not buffTarget then
    return
  end
  local targetCamp
  if buffTarget == "SELF" then
    targetCamp = ed.emCampPlayer
  elseif buffTarget == "ENEMY" then
    targetCamp = ed.emCampEnemy
  end
  if not targetCamp then
    return
  end
  for unit in ed.engine:foreachAliveUnit(targetCamp) do
    if not unit.config.is_summoned then
      local buffInfo = ed.getDataTable("Buff")[buffId]
      local buff = ed.BuffCreate(buffInfo, unit, unit)
      unit:addBuff(buff, unit)
    end
  end
end

function class:addAttr()
end

function class:apply(unit)
end
