local ed = ed
ed.GhostEnable = true
local EffectGhost = {}
EffectGhost.__index = EffectGhost

function EffectGhost:new(params)
  assert(type(params) == "table", "the params ghost'type must ba a table @effectGhost.lua")
  params.num = params.num or 3
  if params.num > 5 then
    params.num = 5
  elseif params.num <= 0 then
    EDDebug("the num must not < 0")
  end
  if params.samp_time and params.fade_time and params.samp_time * params.num <= params.fade_time then
    params.fade_time = params.samp_time * params.num - 0.05
  end
  local cls = {
    node = params.node,
    num = params.num,
    width = params.width or 100,
    height = params.height or 100,
    fade_time = params.fade_time or 0.5,
    samp_time = params.samp_time or 0.2,
    fade_opacity = params.opacity or 0,
    isStart = false,
    renderPool = nil,
    uptime = 0,
    actions = {}
  }
  setmetatable(cls, self)
  if ed.GhostEnable then
    cls.renderPool = ed.RenderPoolCreate(cls.num, cls.width, cls.height)
    ed.GhostManager:getInstance():addGhost(cls)
  end
  return cls
end

function EffectGhost:update(dt)
  if not self.isStart then
    return
  end
  self.uptime = self.uptime + dt
  if self.uptime > self.samp_time then
    self.uptime = 0
    self:sample()
  end
end

function EffectGhost:sample()
  local node = self.node
  local px, py = node:getPosition()
  local rt = self.renderPool:getRender()
  node:setPosition(self.width * 0.5, self.height * 0.5)
  rt:begin()
  node:visit()
  rt:endToLua()
  node:setPosition(px, py)
  local sprite = CCSprite:createWithTexture(rt.rt:getSprite():getTexture())
  sprite:setAnchorPoint(ccp(0.5, 0.5))
  sprite:setPosition(px, py)
  sprite:setFlipY(true)
  local fade_action = CCSequence:create(ccArrayMake(CCFadeTo:create(self.fade_time, self.fade_opacity), CCCallFunc:create(function()
    self:removeGhostAction(fade_action)
    sprite:removeFromParentAndCleanup(true)
  end)))
  self:addGhostAction(sprite)
  node:getParent():addChild(sprite)
  sprite:runAction(fade_action)
end

function EffectGhost:start()
  self.isStart = true
end

function EffectGhost:stop()
  self.isStart = false
  self:removeAllGhostActions()
  ed.GhostManager:getInstance():removeGhost(self)
end

function EffectGhost:addGhostAction(item)
  assert(item, "sprite item must not be nil")
  table.insert(self.actions, item)
end

function EffectGhost:removeGhostAction(item)
  for key, value in pairs(self.actions) do
    if value == item then
      self.actions[key] = nil
    end
  end
end

function EffectGhost:removeAllGhostActions()
  for key, _ in pairs(self.actions) do
    self.actions[key] = nil
  end
end

function EffectGhost:playGhostAction()
  self.isStart = true
  local actionManager = CCDirector:sharedDirector():getActionManager()
  for _, target in pairs(self.actions) do
    if not tolua.isnull(target) then
      actionManager:resumeTarget(target)
    end
  end
end

function EffectGhost:pauseGhostAction()
  self.isStart = false
  local actionManager = CCDirector:sharedDirector():getActionManager()
  for _, target in pairs(self.actions) do
    if not tolua.isnull(target) then
      actionManager:pauseTarget(target)
    end
  end
end

function ed.EffectGhost(ghost)
  return EffectGhost:new(ghost)
end
