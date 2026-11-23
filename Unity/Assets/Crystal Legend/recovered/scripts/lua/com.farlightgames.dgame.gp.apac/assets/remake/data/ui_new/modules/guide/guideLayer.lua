local guideLayer = newclass("g")
ed.guide.layer = guideLayer

function guideLayer.create(params)
  local self = {}
  setmetatable(self, guideLayer.mt)
  self.params = params
  self:initData()
  self:initLayer()
  return self
end

local GuideTouchPriority = -1000

function guideLayer:initData()
  self.clickThrough = true
  self.clickedArea = nil
  self.touchAreas = {}
end

function guideLayer:initLayer()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
  layer:registerScriptTouchHandler(self:getTouchHandler(), false, GuideTouchPriority, true)
  layer:setTouchEnabled(true)
  ed.ui.basescene.getGuideRoot():addChild(layer)
  self.layer = layer
  layer = CCLayer:create()
  layer:registerScriptTouchHandler(self:getCheckTouchHandler(), false, GuideTouchPriority - 1, false)
  layer:setTouchEnabled(true)
  self.layer:addChild(layer)
  self.checkLayer = layer
  self.dialog = ed.guide.dialog.create(self.layer)
  self:createFingerAnimation()
  if ed.guide.manager.debug then
    local debugLayer = CCLayer:create()
    self.layer:addChild(debugLayer)
    self.debugLayer = debugLayer
  end
end

function guideLayer:createFingerAnimation()
  local node = CCNode:create()
  node:setVisible(false)
  self.layer:addChild(node, 9)
  self.fingerNode = node
  local circle = ed.createSprite("UI/alpha/1080P/guide/tutorial_circle_big.png")
  node:addChild(circle)
  local s1 = CCScaleTo:create(0.65, 1.35)
  local s2 = CCScaleTo:create(0.65, 1)
  local action = CCSequence:createWithTwoActions(s1, s2)
  action = CCRepeatForever:create(action)
  circle:runAction(action)
  circle:setScale(0.61)
  self.fingerCircle = circle
  local finger = ed.createSprite("UI/alpha/1080P/guide/tutorial_finger.png")
  node:addChild(finger)
  finger:setAnchorPoint(ccp(0, 1))
  local m1 = CCMoveBy:create(0.65, ccp(10, 0))
  local m2 = CCMoveBy:create(0.65, ccp(-10, 0))
  local action = CCSequence:createWithTwoActions(m1, m2)
  action = CCRepeatForever:create(action)
  finger:runAction(action)
end

function guideLayer:setFingerNodePos(pos)
  local flipX = pos.x < ed.display.winSize.width / 2
  self.fingerNode:setPosition(pos)
  self.fingerNode:setScaleX(flipX and -1 or 1)
  self.fingerNode:setVisible(true)
end

function guideLayer:active(data)
  self.data = data
  self.clickThrough = data.IsSoft
  self.layer:setVisible(true)
  self.layer:setTouchEnabled(true)
  self.fingerNode:setVisible(self.touchAreas[1] ~= nil)
  if data.DialogueID > 0 then
    self.dialog:show(data.DialogueID)
    local area = self.touchAreas[1]
    if area and not area.active then
      self.dialog:setContent(T("\232\183\159\230\136\145\230\157\165"))
    end
  else
    self.dialog:hide()
  end
  ed.registerGameUpdateHandler("guideUpdate", function(dt)
    self:update(dt)
  end)
end

function guideLayer:deactive()
  self.clickThrough = true
  self.layer:setVisible(false)
  self.layer:setTouchEnabled(false)
  self:clear()
  ed.removeGameUpdateHandler("guideUpdate")
end

function guideLayer:clear()
  self.dialog:hide()
  self.touchAreas[1], self.touchAreas[2] = nil, nil
  self.fingerNode:setVisible(false)
  self.data = nil
  self.clipRect = nil
  self:debugDrawArea()
end

function guideLayer:getTouchHandler()
  return function(event, x, y)
    if event == "began" then
      self.clickedArea = self:checkPosInArea(x, y)
      if self.clickThrough then
        return false
      end
      return not self.clickedArea
    end
  end
end

function guideLayer:getCheckTouchHandler()
  return function(event, x, y)
    if event == "began" then
      return true
    elseif event == "ended" then
      if self.clickedArea and self.clickedArea == self:checkPosInArea(x, y) then
        self.fingerNode:setVisible(false)
        self.clickThrough = true
        if self.clickedArea == self.touchAreas[1] then
          ed.guide.manager:completeGuide()
        else
          self.clickedArea.active = false
          self:debugDrawArea()
        end
      elseif #self.touchAreas == 0 then
        ed.guide.manager:completeGuide()
      end
    end
  end
end

function guideLayer:checkPosInArea(x, y)
  for i, area in ipairs(self.touchAreas) do
    if area.active and area.containIn(ccp(x, y), area) then
      return area
    end
  end
  return nil
end

function guideLayer:setClipRect(clipRect)
  self.clipRect = clipRect
  self.layer:setClipRect(clipRect or CCRectMake(0, 0, ed.display.winSize.width, ed.display.winSize.height))
end

function guideLayer:setTouchArea(area, relatedArea)
  self.touchAreas[1] = area
  if relatedArea then
    relatedArea.active = not area.active
  end
  self.touchAreas[2] = relatedArea
  area = area.active and area or relatedArea
  if area then
    self:setFingerNodePos(ed.guide.helper.getAreaWorldPos(area))
  end
  self:debugDrawArea()
end

function guideLayer:updateTouchAreas()
  if #self.touchAreas == 0 then
    return
  end
  local area, relatedArea = unpack(self.touchAreas)
  local areaNode, relatedNode = ed.guide.manager:getGuidingNodes()
  if not areaNode and not relatedNode then
    return
  end
  if area then
    if area.node and tolua.isnull(area.node) then
      area.node = areaNode
    end
    ed.guide.helper.updateNodeTouchArea(area)
  end
  if relatedArea then
    if relatedArea.node and tolua.isnull(relatedArea.node) then
      relatedArea.node = relatedNode
    end
    ed.guide.helper.updateNodeTouchArea(relatedArea)
    relatedArea.active = not area.active
  end
  if area.active then
    self:setFingerNodePos(ed.guide.helper.getAreaWorldPos(area))
    self.dialog:setContent()
    self.dialog:show()
  elseif relatedArea and relatedArea.active then
    self:setFingerNodePos(ed.guide.helper.getAreaWorldPos(relatedArea))
    self.dialog:setContent(T("\232\183\159\230\136\145\230\157\165"))
    self.dialog:show()
  else
    self.fingerNode:setVisible(false)
    self.dialog:hide()
  end
  self:debugDrawArea()
end

function guideLayer:getActiveTouchArea()
  for i, v in ipairs(self.touchAreas) do
    if v.active then
      return v
    end
  end
end

function guideLayer:getRelatedArea()
  return self.touchAreas[2]
end

function guideLayer:debugDrawArea()
  if not ed.guide.manager.debug then
    return
  end
  self.debugLayer:removeAllChildrenWithCleanup(true)
  for i, area in ipairs(self.touchAreas) do
    if area.active then
      area.debugDraw(area, self.debugLayer)
    end
  end
  if self.clipRect then
    local size = self.clipRect.size
    local pos = ccp(self.clipRect.origin.x + size.width / 2, self.clipRect.origin.y + size.height / 2)
    local area = ed.guide.helper.createRectTouchArea(pos, size.width, size.height)
    area.debugDraw(area, self.debugLayer)
  end
end

function guideLayer:update(dt)
  self:updateTouchAreas()
end
