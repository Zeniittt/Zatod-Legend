local ed = ed
local class = {
  mt = {}
}
ed.Entity = class
class.mt.__index = class

local function EntityCreate()
  local self = {
    camp = 0,
    radius = 0,
    position = {0, 0},
    velocity = {0, 0},
    height = 0,
    direction = 1,
    frozen_model = false,
    frozen_actor = false,
    terminated = false
  }
  setmetatable(self, class.mt)
  return self
end

class.create = EntityCreate
ed.EntityCreate = EntityCreate

local function update(self, dt)
  local pos = self.position
  local v = self.velocity
  pos[1] = pos[1] + v[1] * dt
  pos[2] = pos[2] + v[2] * dt
  if v[1] * self.direction < 0 then
    self.direction = self.direction * -1
  end
end

class.update = update

local function isOutOfStage(self)
  local pos = self.position
  local x = pos[1]
  local y = pos[2]
  local rect = ed.engine.stage_rect
  return x < rect.minX or x > rect.maxX or y < rect.minY or y > rect.maxY
end

class.isOutOfStage = isOutOfStage

local function collideWith(self, another)
  local distanceX = math.abs(self.position[1] - another.position[1])
  if distanceX > self.radius + another.radius then
    return false
  end
  local distanceSQ = ed.edpDistanceSQ(self.position, another.position)
  return distanceSQ < (self.radius + another.radius) ^ 2
end

class.collideWith = collideWith

local function terminate(self)
  self.terminated = true
end

class.terminate = terminate

local function freeze(self)
  self.frozen_model = true
  if not self.frozen_actor and self.actor then
    self.frozen_actor = true
    self.actor:tint(0.4, 0.4, 0.4)
  end
end

class.freeze = freeze

local function unfreeze(self)
  self.frozen_model = false
  self:unfreezeActor()
end

class.unfreeze = unfreeze

local function lighten(self)
  if self.actor then
    self.actor:tint(2.5, 2.5, 2.5)
  end
end

class.lighten = lighten

local function unfreezeActor(self)
  if self.frozen_actor then
    self.frozen_actor = false
    if self.actor then
      self.actor:tint(2.5, 2.5, 2.5)
    end
  end
end

class.unfreezeActor = unfreezeActor
local min = math.min
local max = math.max

local function setPosition(self, pos)
  local rect = ed.engine.stage_rect
  self.position[1] = min(max(pos[1], rect.minX), rect.maxX)
  self.position[2] = min(max(pos[2], rect.minY), rect.maxY)
end

class.setPosition = setPosition
