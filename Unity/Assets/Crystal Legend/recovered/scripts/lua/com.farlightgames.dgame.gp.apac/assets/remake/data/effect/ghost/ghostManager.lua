local ed = ed
local GhostManager = {}
ed.GhostManager = GhostManager

function GhostManager:new(cls)
  cls = cls or {}
  setmetatable(cls, self)
  self.__index = self
  self.ghost = {}
  return cls
end

function GhostManager:getInstance()
  if self.instance == nil then
    self.instance = self:new()
  end
  return self.instance
end

function GhostManager:update(dt)
  if not ed.GhostEnable then
    return
  end
  for _, ghost in pairs(self.ghost) do
    if ghost then
      ghost:update(dt)
    end
  end
end

function GhostManager:addGhost(item)
  assert(item, "ghost item must not be nil @effectGhost.lua")
  table.insert(self.ghost, item)
end

function GhostManager:removeGhost(item)
  for key, value in pairs(self.ghost) do
    if value == item then
      item.renderPool:clearPool()
      self.ghost[key] = nil
    end
  end
end

function GhostManager:removeAll()
  for key, item in pairs(self.ghost) do
    item.renderPool:clearPool()
    self.ghost[key] = nil
  end
end
