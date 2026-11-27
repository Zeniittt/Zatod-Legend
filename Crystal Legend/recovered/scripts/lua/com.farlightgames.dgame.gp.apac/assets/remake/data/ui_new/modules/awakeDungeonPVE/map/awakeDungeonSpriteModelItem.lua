local awakeDungeonSpriteModelItem = newclass()
ed.ui.awakeDungeonSpriteModelItem = awakeDungeonSpriteModelItem

function awakeDungeonSpriteModelItem.create(res)
  local self = {}
  setmetatable(self, awakeDungeonSpriteModelItem.mt)
  self:initModel(res)
  return self
end

function awakeDungeonSpriteModelItem:initModel(res)
  self.model = ed.createSprite(string.format("UI/alpha/1080P/dungeon/stage/tilemap/%s.png", res))
end

function awakeDungeonSpriteModelItem:playAction(action)
  self.model:runAction(action)
end

function awakeDungeonSpriteModelItem:playShowAction()
  self.model:setScale(0.85)
  self.model:runAction(CCScaleTo:create(8 * ed.awakeDungeonDefine.ACTION_TIME_UNIT, 1))
end

function awakeDungeonSpriteModelItem:playDeathAction()
  self.model:stopAllActions()
  self.model:setScale(1)
  local seq = CCSequence:create(ccArrayMake(CCDelayTime:create(0.01), CCScaleTo:create(0.4, 0.5), CCCallFunc:create(function()
    self.model:removeFromParentAndCleanup(true)
  end)))
  self.model:runAction(seq)
end

function awakeDungeonSpriteModelItem:addTo(parentNode, pos, zOrder)
  parentNode:addChild(self.model)
  self.model:setPosition(pos)
  self.model:setZOrder(zOrder)
end
