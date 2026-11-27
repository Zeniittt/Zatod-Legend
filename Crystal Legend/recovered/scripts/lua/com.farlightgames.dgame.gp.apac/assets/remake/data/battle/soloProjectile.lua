local class = {
  mt = {}
}
ed.SoloProjectile = class
class.mt.__index = class

function class:display()
  return "SoloProjectile"
end

function class.mt:__tostring()
  return string.format("%s pos: (%d,%d)", self:display(), self.position[1], self.position[2])
end

local base = ed.Entity
setmetatable(class, base.mt)

local function SoloProjectileCreate(skill)
  local self = base.create()
  setmetatable(self, class.mt)
  local info = skill.info
  local caster = skill.caster
  self.caster = skill.caster
  self.skill = skill
  self.art = skill.art
  self.camp = caster.camp
  self.affect_camp = skill:selectDamageCamp()
  self.affect_times = {}
  self.distance = 0
  self.max_distance = 999
  self.birthtick = ed.engine.ticks
  self.track = false
  self.jumps = 0
  self.hit_list = {}
  self.radius = skill.soloRadius or 0
  self.scale = skill.soloScale or self.caster:getUnitScale()
  self.position, self.height = skill:launchPoint()
  local v = {
    info["Tile XY Speed"] * 0.78,
    info["Tile Z Speed"]
  }
  if skill.target then
    local targetPos = {
      skill.target.position[1],
      skill.target.position[2] + ed.rand() * 20 - 10
    }
    local d = ed.edpSub(targetPos, self.position)
    if d[1] == 0 and d[2] == 0 then
      self.velocity = {
        caster.direction,
        0
      }
    else
      self.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
    end
  end
  self.zSpeed = v[2]
  local caster = skill.caster
  self.previous_position = {
    self.position[1],
    self.position[2]
  }
  return self
end

class.create = SoloProjectileCreate
ed.SoloProjectileCreate = SoloProjectileCreate

function class:update(dt)
  if self.birthtick == ed.engine.ticks then
    return
  end
  dt = dt * 100 / (100 + self.caster.frozenValue)
  self.previous_position = {
    self.position[1],
    self.position[2]
  }
  base.update(self, dt)
  local info = self.skill.info
  self.height = self.height + self.zSpeed * dt
  self.zSpeed = self.zSpeed + (self["No Gravity"] and 0 or info["Tile Gravity"] * 0.5) * dt
  self.distance = self.distance + info["Tile XY Speed"] * 0.5 * dt
  local h = self.height
  local ott = info["Tile OTT Height"]
  if ott == 0 or h < ott then
    local collide = self:collideCheck(self.skill.target)
    if collide then
      self:hit(self.skill.target)
      self:terminate()
    end
  end
  if not self.terminated and (self:isOutOfStage() or h < 0 or self.distance > self.max_distance) then
    self:terminate()
  end
end

function class:hit(target)
  self.skill:takeEffectOn(target, self)
  self.affect_times[target] = (self.affect_times[target] or 0) + 1
end

function class:collideCheck(unit)
  if not unit then
    return false
  end
  local radius = unit.info["Collide Radius"] + self.radius
  local ux = unit.position[1]
  local ux0 = unit.previous_position[1]
  local d = self.position[1] - ux
  local d0 = self.previous_position[1] - ux0
  if 0 < d and 0 < d0 then
    d = d - radius
    d0 = d0 - radius
  elseif d < 0 and d0 < 0 then
    d = d + radius
    d0 = d0 + radius
  end
  local t = -d0 / (d - d0)
  if t < 0 or 1 < t then
    return false
  end
  return t
end

local class = {
  mt = {}
}
ed.SoloProjectileActor = class
class.mt.__index = class

local function SoloProjectileActorCreate(model)
  local self = {
    model = model,
    node = nil,
    puppet = nil,
    position = {0, 0},
    height = 0,
    velocity = {0, 0},
    zSpeed = 0,
    rotation = 0,
    tick = -1,
    ownZOrder = nil,
    ownRotation = nil,
    ownScaleX = nil,
    ownScaleY = nil
  }
  setmetatable(self, class.mt)
  model.actor = self
  local info = model.skill.info
  local art = model.art or info["Tile Art"]
  if string.match(art, "%.png$") then
    self.node = ed.createSprite(art)
  elseif string.match(art, "%.cha$") then
    art = string.gsub(art, "%.cha$", "")
    self.puppet = ed.createEDFcaEffect(art)
    print(art)
    self.puppet:setLoopAction("Loop")
    self.node = self.puppet
  elseif string.match(art, "%.sp$") then
    art = string.gsub(art, "%.sp$", "")
    self.puppet = ed.createEDFcaSpEffect(art)
    self.puppet:setLoopAction("Loop")
    self.node = self.puppet
  end
  self.node:setScale(self.model.scale)
  return self
end

class.create = SoloProjectileActorCreate
ed.SoloProjectileActorCreate = SoloProjectileActorCreate
local setPosition = CCNode.setPosition
local setRotation = CCNode.setRotation
local setScaleX = CCNode.setScaleX
local setScaleY = CCNode.setScaleY
local setZOrder = CCNode.setZOrder

local function update(self, dt)
  local m = self.model
  dt = dt * 100 / (100 + self.model.caster.frozenValue)
  if self.tick ~= ed.engine.ticks then
    self.tick = ed.engine.ticks
    self.height = m.height
    self.zSpeed = m.zSpeed
    local p1 = self.position
    local p2 = m.position
    p1[1] = p2[1]
    p1[2] = p2[2]
    local v1 = self.velocity
    local v2 = m.velocity
    v1[1] = v2[1]
    v1[2] = v2[2]
  else
    local pos = self.position
    local v = self.velocity
    pos[1] = pos[1] + v[1] * dt
    pos[2] = pos[2] + v[2] * dt
    self.height = self.height + self.zSpeed * dt
    self.zSpeed = self.zSpeed - 150 * dt
  end
  local node = self.node
  local pos = self.position
  local vp = ed.toViewPosition(pos, self.height)
  setPosition(node, vp)
  local vz = self.zSpeed
  local v = FlipXVector(self.velocity)
  local rotation, scaleY
  if self.ownRotation then
    rotation = self.ownRotation
  else
    rotation = -math.atan2(vz + v[2] * ed.deepProjectionY, v[1] + v[2] * ed.deepProjectionX) * (180 / math.pi)
  end
  setRotation(node, rotation)
  if self.puppet then
    self.puppet:update(dt)
  end
  if not ed.engine.running then
    self.node:setVisible(false)
  end
end

class.update = update

local function tint(self, r, g, b)
  if self.puppet then
    if not tolua.isnull(self.puppet) then
      self.puppet:tint(r, g, b)
    end
  elseif self.node then
    ed.tintSprite(self.node, r, g, b)
  end
end

local function setOwnZOrder(self, zOrder)
  if zOrder == nil then
    return
  end
  self.ownZOrder = zOrder
end

class.tint = tint
