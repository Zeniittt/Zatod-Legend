local awakeDungeonSpineModelItem = newclass()
ed.ui.awakeDungeonSpineModelItem = awakeDungeonSpineModelItem

function awakeDungeonSpineModelItem.create(res)
  local self = {}
  setmetatable(self, awakeDungeonSpineModelItem.mt)
  self:initModel(res)
  return self
end

function awakeDungeonSpineModelItem:initModel(res)
  self.model = ed.createSpine(string.format("effect/%s/%s", res, res), 0.5)
  self.model:setAnimation(0, "Idle", true)
  local lightPath = ed.awakeDungeonDefine.GRIDMAP_BUILDING_LIGHT[res]
  if nil ~= lightPath then
    self.lightModel = ed.createSpine(string.format("effect/%s/%s", lightPath, lightPath), 0.5)
    self.lightModel:setAnimation(0, "Idle", true)
  end
  local triggerPath = ed.awakeDungeonDefine.GRIDMAP_BUILDING_TRIGGER[res]
  if nil ~= triggerPath then
    self.triggerModel = ed.createSpine(string.format("effect/%s/%s", triggerPath, triggerPath), 0.5)
    self.triggerModel:setVisible(false)
  end
end

function awakeDungeonSpineModelItem:playAction(action)
  self.model:runAction(action)
  if nil ~= self.lightModel then
    self.lightModel:runAction(tolua.cast(action:copy():autorelease(), "CCAction"))
  end
end

function awakeDungeonSpineModelItem:playShowAction()
  self.model:setScale(0.85)
  self.model:setOpacity(0)
  self.model:runAction(CCSpawn:create(ccArrayMake(CCFadeIn:create(8 * ed.awakeDungeonDefine.ACTION_TIME_UNIT), CCScaleTo:create(8 * ed.awakeDungeonDefine.ACTION_TIME_UNIT, 1))))
end

function awakeDungeonSpineModelItem:playDeathAction()
  self.model:stopAllActions()
  self.model:setScale(1)
  self.model:unregisterScriptSpineHandler()
  self.model:setAnimation(0, "Death", false)
  self.model:registerScriptSpineHandler(function(event)
    if event == "end" then
      self.model:removeFromParentAndCleanup(true)
    end
  end)
  if nil ~= self.lightModel then
    self.lightModel:removeFromParentAndCleanup(true)
    self.lightModel = nil
  end
  if nil ~= self.triggerModel then
    self.triggerModel:removeFromParentAndCleanup(true)
    self.triggerModel = nil
  end
end

function awakeDungeonSpineModelItem:playTriggerAction()
  if nil ~= self.triggerModel then
    self.triggerModel:setVisible(true)
    self.triggerModel:unregisterScriptSpineHandler()
    self.triggerModel:setAnimation(0, "Idle", false)
    self.triggerModel:registerScriptSpineHandler(function(event)
      if event == "end" then
        self.triggerModel:setVisible(false)
      end
    end)
  end
end

function awakeDungeonSpineModelItem:addTo(parentNode, pos, zOrder)
  parentNode:addChild(self.model)
  self.model:setPosition(pos)
  self.model:setZOrder(zOrder)
  if nil ~= self.lightModel then
    parentNode:addChild(self.lightModel)
    self.lightModel:setPosition(pos)
    self.lightModel:setZOrder(ed.awakeDungeonDefine.GRIDMAP_ZORDER[ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_LIGHT])
  end
  if nil ~= self.triggerModel then
    parentNode:addChild(self.triggerModel)
    self.triggerModel:setPosition(pos)
    self.triggerModel:setZOrder(ed.awakeDungeonDefine.GRIDMAP_ZORDER[ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_TRIGGER])
  end
end
