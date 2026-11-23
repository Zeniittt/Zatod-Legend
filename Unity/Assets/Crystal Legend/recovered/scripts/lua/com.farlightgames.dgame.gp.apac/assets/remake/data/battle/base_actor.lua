local baseActor = {}
ed.baseActor = baseActor
baseActor.__index = baseActor

function baseActor.Create(model)
  local self = {
    model = model,
    node = nil,
    puppet = nil,
    height = model.height,
    position = model.position,
    tick = -1,
    ownZOrder = -999
  }
  setmetatable(self, baseActor)
  if model.EffectZorder then
    self:setOwnZOrder(model.EffectZorder)
  end
  model.actor = self
  local info = model.skill.info
  local art = info["Tile Art"] or ""
  if string.match(art, "%.png$") then
    self.node = ed.createSprite(art)
  elseif string.match(art, "%.cha$") then
    art = string.gsub(art, "%.cha$", "")
    self.puppet = ed.createEDFcaEffect(art)
    self.puppet:setLoopAction("Loop")
    self.node = self.puppet
  elseif string.match(art, "%.sp$") then
    art = string.gsub(art, "%.sp$", "")
    self.puppet = ed.createEDFcaSpEffect(art)
    self.puppet:setLoopAction("Loop")
    self.node = self.puppet
  end
  return self
end

ed.baseActorCreate = baseActor.Create
local setPosition = CCNode.setPosition
local setZOrder = CCNode.setZOrder

function baseActor:update(dt)
  local node = self.node
  local pos = FlipXPosition(self.position)
  local vp = ed.toViewPosition(pos, self.height)
  setPosition(node, vp)
  if self.ownZOrder then
    setZOrder(node, self.ownZOrder)
  else
    setZOrder(node, -self.position[2])
  end
  if self.puppet then
    self.puppet:update(dt)
  end
  if not ed.engine.running then
    self.node:setVisible(false)
  end
end

function baseActor:setOwnZOrder(zOrder)
  if zOrder == nil then
    return
  end
  self.ownZOrder = zOrder
end

function baseActor:tint(r, g, b)
  if self.puppet then
    self.puppet:tint(r, g, b)
  elseif self.node then
    ed.tintSprite(self.node, r, g, b)
  end
end
