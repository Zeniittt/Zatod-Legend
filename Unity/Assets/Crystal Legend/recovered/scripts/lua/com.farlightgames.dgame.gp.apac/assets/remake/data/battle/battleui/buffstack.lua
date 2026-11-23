local class = {
  mt = {}
}
class.mt.__index = class

local function addParticleAndAction(self)
  local particle = CCParticleSystemQuad:create("UI/particle/bigHpbar_head_fire.plist")
  ed.sceneui.ui_layer:addChild(particle)
  particle:setEmissionRate(500)
  particle:setPosition(525, 420)
  self.label:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.1, 1.4), CCScaleTo:create(0.1, 1))))
end

local function buffstackCreate(buff)
  local self = {
    node = ed.createSprite(buff.info["Show Icon"]),
    label = ed.createLabelWithFontInfo(string.format(buff.rank), "buff_stack"),
    buff = buff,
    rank = buff.rank,
    buffstack = true
  }
  setmetatable(self, class.mt)
  self.label:setPosition(ccp(30 + self.label:getContentSize().width, 3))
  self.label:setAnchorPoint(ccp(1, 0))
  self.node:addChild(self.label)
  addParticleAndAction(self)
  return self
end

class.create = buffstackCreate
ed.buffstackCreate = buffstackCreate

local function update(self, dt)
  local buff = self.buff
  if buff.rank == self.rank then
    return
  else
    self.label:setString(buff.rank)
    self.label:setPositionX(30 + self.label:getContentSize().width)
    self.rank = buff.rank
    addParticleAndAction(self)
  end
end

class.update = update
