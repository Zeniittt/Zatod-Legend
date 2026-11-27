local class = {
  mt = {}
}
class.mt.__index = class

local function goldBeanCreate()
  local self = {
    beanNumber = ed.engine.energyBeanNumber,
    bg = CCSprite:create("UI/alpha/1080P/crusade/energbean_tips1.png"),
    tipsbg = ed.createScale9Sprite("UI/alpha/1080P/crusade/energbean_tips2.png", CCRectMake(60, 10, 10, 2)),
    label = ed.createttf(string.format("x%d", ed.engine.energyBeanNumber), 16),
    node = CCNode:create(),
    what = "goldBean"
  }
  setmetatable(self, class.mt)
  self.node:addChild(self.bg)
  self.label:setPosition(ccp(22, 10))
  self.label:setColor(ed.toccc3(16776423))
  self.tipsbg:setPosition(ccp(105, self.bg:getContentSize().height / 2 - 7))
  self.bg:addChild(self.tipsbg)
  local tip = ed.createttf(T("\231\130\185\229\135\187\232\139\177\233\155\132\229\164\180\229\131\143\230\129\162\229\164\141\232\131\189\233\135\143"), 12)
  tip:setDimensions(CCSizeMake(140, 0))
  local oriSize = self.tipsbg:getContentSize()
  self.tipsbg:setContentSize(CCSizeMake(oriSize.width, math.max(tip:getContentSize().height + 5, oriSize.height)))
  self.tipsbg:addChild(tip)
  ed.layout.centerInParent(tip)
  self.bg:addChild(self.label)
  ed.setLabelStroke(self.label, ed.toccc3(657159), 1)
  ed.setLabelColor(tip, ed.toccc3(16700269))
  ed.setLabelStroke(tip, ed.toccc3(3744789), 1)
  if ed.storage.getBool("BeanTutorialEnd") then
    self.tipsbg:setVisible(false)
  end
  self.locked = false
  return self
end

class.create = goldBeanCreate
ed.goldBeanCreate = goldBeanCreate

local function GoldBeanAction(self)
  local Bean = CCSprite:create("UI/alpha/1080P/crusade/energbean_tips1.png")
  self.node:addChild(Bean)
  local action = CCSpawn:create(ccArrayMake(CCScaleTo:create(0.5, 1.4), CCFadeOut:create(0.5)))
  Bean:runAction(CCSequence:create(ccArrayMake(action, CCCallFunc:create(function()
    Bean:removeFromParentAndCleanup(true)
  end))))
  self.label:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.1, 1.4), CCScaleTo:create(0.1, 1))))
end

local function update(self, dt)
  if self.locked then
    return
  end
  local beanNumber = ed.engine.energyBeanNumber
  if beanNumber == self.beanNumber then
    return
  else
    self.label:setString(beanNumber)
    self.beanNumber = beanNumber
    GoldBeanAction(self)
  end
end

class.update = update
