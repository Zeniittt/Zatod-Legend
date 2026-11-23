local ed = ed
local class = {
  mt = {}
}
ed.Popup = class
class.mt.__index = class
local record = {}
local lastTick = 0
local count = 0
local maxCount = 0

local function restPopup()
  lastTick = 0
  count = 0
  maxCount = 0
end

class.restPopup = restPopup
ed.restPopup = restPopup

local function PopupCreate(str, color, actor, crit, style)
  if not actor then
    return
  end
  if ed.trackMgr.isShieldFullText then
    return
  end
  local tick = ed.engine.ticks
  if ed.trackMgr.isShieldPartText then
    if tick <= lastTick + 5 then
      if 6 < count then
        return
      end
    else
      count = 0
      lastTick = tick
    end
    count = count + 1
  end
  style = style or "damage"
  local speedRete = ed.engine:getSpeedRate() or 1
  local self = {
    position = nil,
    life = 0.8 / speedRete,
    tick = -1
  }
  setmetatable(self, class.mt)
  if style == "text" then
    self.node = ed.createBathNumOrTextNode(str, nil, nil, color, true)
  else
    self.node = ed.createBathNumOrTextNode(str, -2, nil, color)
  end
  local action
  if style == "damage" then
    local pos = FlipXPosition(actor.position)
    pos = ed.toViewPosition(pos, 75)
    self.node:setPosition(pos)
    self.node:setScale(crit and 1 or 0.75)
    self.node:setScale(0.75)
    local duration = self.life * 0.2
    local camp = actor.model.camp
    action = CCMoveBy:create(duration, ccp(0, crit and 70 or 45))
    action = CCEaseExponentialOut:create(action)
    action = CCSpawn:create(ccArrayMake(action, CCScaleBy:create(duration, 2)))
    local duration = self.life * 0.8
    local action2 = CCMoveBy:create(duration, ccp(0, 60))
    action2 = CCEaseIn:create(action2, 3)
    action2 = CCSpawn:create(ccArrayMake(action2, CCFadeOut:create(duration)))
    action = CCSequence:createWithTwoActions(action, action2)
  elseif style == "heal" then
    local pos = FlipXPosition(actor.position)
    pos = ed.toViewPosition(pos, 100)
    self.node:setPosition(pos)
    self.node:setScale(1.5)
    local duration = self.life
    action = CCMoveBy:create(duration, ccp(0, 100))
    action = CCSpawn:createWithTwoActions(action, CCFadeOut:create(duration))
  elseif style == "gold" then
    local pos = FlipXPosition(actor.position)
    local pos = ed.toViewPosition(pos, 30)
    self.node:setPosition(pos)
    self.node:setOpacity(0)
    self.node:setScale(1.1)
    local duration = 0.625
    action = CCSpawn:create(ccArrayMake({
      CCMoveBy:create(duration, ccp(0, 80)),
      CCFadeTo:create(duration, 255)
    }))
    action = CCEaseOut:create(action, 4)
    action = CCSequence:create(ccArrayMake({
      CCDelayTime:create(0.3),
      action,
      CCDelayTime:create(0.15),
      CCFadeOut:create(0.1)
    }))
  elseif style == "text" then
    local pos = FlipXPosition(actor.position)
    pos = ed.toViewPosition(pos, actor.height + 100)
    self.node:setPosition(pos)
    self.node:setScale(1.05)
    local duration = self.life * 0.2
    action = CCMoveBy:create(duration, ccp(0, 50))
    action = CCEaseExponentialOut:create(action)
    action = CCSpawn:createWithTwoActions(action, CCScaleBy:create(duration, 2))
    duration = self.life * 0.8
    action = CCSequence:create(ccArrayMake(action, CCDelayTime:create(duration * 0.5), CCFadeOut:create(duration * 0.5)))
  end
  action = CCSequence:create(ccArrayMake(action, CCCallFunc:create(function()
    self.node:removeFromParentAndCleanup(true)
    if record[actor] == self.tick then
      record[actor] = nil
    end
  end)))
  self.node:runAction(action)
  local delay = 0
  local old = record[actor] or -1
  if tick <= old then
    delay = old + 2 - tick
    tick = tick + delay
  end
  record[actor] = tick
  self.tick = tick
  if ed.engine:isTowerWarsMode() then
    local node = self.node
    local scale = node:getScale() * ed.engine.unitScale
    node:setScale(scale)
  end
  if delay == 0 then
    ed.sceneui.damageBath_layer:addChild(self.node)
  else
    self.node:retain()
    local action = CCDelayTime:create(delay * ed.engine.tick_interval)
    action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
      ed.sceneui.damageBath_layer:addChild(self.node)
      self.node:release()
    end))
    ed.sceneui.ui_layer:runAction(action)
  end
  return self
end

class.create = PopupCreate
ed.PopupCreate = PopupCreate
