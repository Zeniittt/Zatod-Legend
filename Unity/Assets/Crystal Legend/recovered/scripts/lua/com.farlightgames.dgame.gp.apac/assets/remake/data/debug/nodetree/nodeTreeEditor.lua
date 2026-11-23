local NodeTreeEditor = newclass()

function NodeTreeEditor.getInstance()
  local self = {}
  setmetatable(self, NodeTreeEditor.mt)
  self:init()
  self:start()
  return self
end

function NodeTreeEditor:init()
  self.panelSize = CCSizeMake(200, ed.display.fixDesignSize.height * 0.6)
  self.panelPos = ccp(ed.display.fixDesignSize.width - self.panelSize.width, (ed.display.fixDesignSize.height - self.panelSize.height) * 0.5)
  self.scrollSize = CCSizeMake(self.panelSize.width, self.panelSize.height - 95)
  self.nodeSize = CCSizeMake(77, 28)
  self.indentSpace = 10
  self.contentHeight = 0
  self.curScene = nil
  self.nodeArr = {}
  self.curNodeInfoTab = {}
  self.lastNodeInfoTab = {}
  self.isTouchRoot = false
  self.curItemIndex = -1
  self.lastTouchX = -1
  self.lastTouchY = -1
  self.isVisibleTouchBegan = false
  self.isCloseTouchBegan = false
  self.touchChangeValIndex = 0
  self.isDragMove = false
  self.isScaleMove = false
  self.forceCleanup = false
  self.eventScope = {}
end

function NodeTreeEditor:start()
  ListenTimer(Timer:Always(0.01), function()
    self:update()
    self:updateChangeValTimer()
  end, self.eventScope)
end

function NodeTreeEditor:onSceneCleanup(...)
  if not tolua.isnull(self.curScene) and not tolua.isnull(self.rootPanel) then
    self.rootPanel:removeFromParentAndCleanup(true)
  end
  self.selectionDrawNode = nil
  self.rootPanel = nil
  self.isTouchRoot = false
  self.isVisibleTouchBegan = false
  self.isCloseTouchBegan = false
  self.touchChangeValIndex = 0
  self.isDragMove = false
  self.isScaleMove = false
  self.draglist = nil
  self.forceCleanup = false
  self.curItemIndex = -1
  self.nodeArr = {}
  self.changeValInfoArr = {}
end

function NodeTreeEditor:getExitHandler()
  local obj = self
  
  local function handler(event)
    xpcall(function()
      if event == "cleanup" then
        self.forceCleanup = true
      end
    end, EDDebug)
  end
  
  return handler
end

function NodeTreeEditor:onSceneEnter()
  self.rootPanel = CCLayerColor:create(ccc4(122, 122, 122, 122))
  self.rootPanel:setContentSize(self.panelSize)
  self.rootPanel:setPosition(self.panelPos)
  self.rootPanel:setTouchEnabled(true)
  self.rootPanel:registerScriptTouchHandler(self:doMainLayerTouch(), false, -9998, true)
  self.rootPanel:registerScriptHandler(self:getExitHandler())
  self.curScene:addChild(self.rootPanel, 9999)
  self.expandBtn = ed.createSprite("UI/alpha/1080P/common/main_head_mask.png")
  self.expandBtn:setScale(20 / self.expandBtn:getContentSize().width)
  self.rootPanel:addChild(self.expandBtn)
  self.expandBtn:setPosition(self.panelSize.width - 10, self.panelSize.height - 10)
  self.closeBtn = ed.createSprite("UI/alpha/1080P/common/butt_off.png")
  self.recordCloseBtnScale = 20 / self.closeBtn:getContentSize().width
  self.closeBtn:setScale(self.recordCloseBtnScale)
  self.rootPanel:addChild(self.closeBtn)
  self.draglist = ed.UITool.createDraglist(self.rootPanel, {
    priority = -9999,
    width = self.scrollSize.width,
    height = self.scrollSize.height,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self.visibleDesLabel = ed.createLabelTTF("Visible", 8)
  self.rootPanel:addChild(self.visibleDesLabel)
  self.visibleDesLabel:setAnchorPoint(ccp(0, 0.5))
  self.visibleDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self.visibleBg = ed.createSprite("UI/alpha/1080P/sharefight/checkbox.png")
  self.visibleBg:setScale(0.7)
  self.rootPanel:addChild(self.visibleBg)
  self.visibleImg = ed.createSprite("UI/alpha/1080P/common/account_sifting_mark.png")
  self.visibleBg:addChild(self.visibleImg)
  self.posDesLabel = ed.createLabelTTF("Position", 8)
  self.rootPanel:addChild(self.posDesLabel)
  self.posDesLabel:setAnchorPoint(ccp(0, 0.5))
  self.posDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self.posXLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.posXLabel)
  self.posXLabel:setAnchorPoint(ccp(0, 0.5))
  self.posXLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.posXLabel, "posX")
  self.posYLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.posYLabel)
  self.posYLabel:setAnchorPoint(ccp(0, 0.5))
  self.posYLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.posYLabel, "posY")
  self.anchorDesLabel = ed.createLabelTTF("Anchor", 8)
  self.rootPanel:addChild(self.anchorDesLabel)
  self.anchorDesLabel:setAnchorPoint(ccp(0, 0.5))
  self.anchorDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self.anchorXLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.anchorXLabel)
  self.anchorXLabel:setAnchorPoint(ccp(0, 0.5))
  self.anchorXLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.anchorXLabel, "anchorX")
  self.anchorYLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.anchorYLabel)
  self.anchorYLabel:setAnchorPoint(ccp(0, 0.5))
  self.anchorYLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.anchorYLabel, "anchorY")
  self.sizeDesLabel = ed.createLabelTTF("Size", 8)
  self.rootPanel:addChild(self.sizeDesLabel)
  self.sizeDesLabel:setAnchorPoint(ccp(0, 0.5))
  self.sizeDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self.sizeXLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.sizeXLabel)
  self.sizeXLabel:setAnchorPoint(ccp(0, 0.5))
  self.sizeXLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.sizeXLabel, "width")
  self.sizeYLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.sizeYLabel)
  self.sizeYLabel:setAnchorPoint(ccp(0, 0.5))
  self.sizeYLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.sizeYLabel, "height")
  self.scaleDesLabel = ed.createLabelTTF("Scale", 8)
  self.rootPanel:addChild(self.scaleDesLabel)
  self.scaleDesLabel:setAnchorPoint(ccp(0, 0.5))
  self.scaleDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self.scaleXLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.scaleXLabel)
  self.scaleXLabel:setAnchorPoint(ccp(0, 0.5))
  self.scaleXLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.scaleXLabel, "scaleX")
  self.scaleYLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.scaleYLabel)
  self.scaleYLabel:setAnchorPoint(ccp(0, 0.5))
  self.scaleYLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.scaleYLabel, "scaleY")
  self.rotDesLabel = ed.createLabelTTF("Rotation", 8)
  self.rootPanel:addChild(self.rotDesLabel)
  self.rotDesLabel:setAnchorPoint(ccp(0, 0.5))
  self.rotDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self.rotLabel = ed.createLabelTTF("nil", 10)
  self.rootPanel:addChild(self.rotLabel)
  self.rotLabel:setAnchorPoint(ccp(0, 0.5))
  self.rotLabel:setStroke(ccc3(0, 0, 0), 0.5)
  self:addChangeAvaliable(self.rotLabel, "rot")
  self:refreshOperateUIPos()
end

function NodeTreeEditor:addChangeAvaliable(valLabel, type)
  local upBtn = ed.createSprite("UI/alpha/1080P/common/herodetail_arrow_left.png")
  self.rootPanel:addChild(upBtn)
  upBtn:setRotation(90)
  upBtn:setScale(0.15)
  local downBtn = ed.createSprite("UI/alpha/1080P/common/herodetail_arrow_left.png")
  self.rootPanel:addChild(downBtn)
  downBtn:setScale(0.15)
  downBtn:setRotation(-90)
  table.insert(self.changeValInfoArr, {
    up = upBtn,
    down = downBtn,
    val = valLabel,
    type = type
  })
end

function NodeTreeEditor:refreshOperateUIPos()
  if nil == self.visibleDesLabel then
    return
  end
  self.visibleDesLabel:setPosition(0, self.panelSize.height - 10)
  self.visibleBg:setPosition(self.visibleDesLabel:getPositionX() + self.visibleDesLabel:getContentSize().width + self.visibleBg:getContentSize().width * 0.5, self.visibleDesLabel:getPositionY())
  self.visibleImg:setPosition(self.visibleBg:getContentSize().width * 0.5, self.visibleBg:getContentSize().height * 0.5)
  self.posDesLabel:setPosition(0, self.panelSize.height - 30)
  self.posXLabel:setPosition(40, self.posDesLabel:getPositionY())
  self.posYLabel:setPosition(80, self.posXLabel:getPositionY())
  self.anchorDesLabel:setPosition(0, self.panelSize.height - 45)
  self.anchorXLabel:setPosition(40, self.anchorDesLabel:getPositionY())
  self.anchorYLabel:setPosition(80, self.anchorXLabel:getPositionY())
  self.sizeDesLabel:setPosition(0, self.panelSize.height - 60)
  self.sizeXLabel:setPosition(40, self.sizeDesLabel:getPositionY())
  self.sizeYLabel:setPosition(80, self.sizeXLabel:getPositionY())
  self.scaleDesLabel:setPosition(0, self.panelSize.height - 75)
  self.scaleXLabel:setPosition(40, self.scaleDesLabel:getPositionY())
  self.scaleYLabel:setPosition(80, self.scaleXLabel:getPositionY())
  self.rotDesLabel:setPosition(0, self.panelSize.height - 90)
  self.rotLabel:setPosition(40, self.rotDesLabel:getPositionY())
  for i, v in ipairs(self.changeValInfoArr) do
    local posX, posY = v.val:getPosition()
    local btnSize = v.up:getContentSize()
    btnSize.width = btnSize.width * v.up:getScaleX()
    btnSize.height = btnSize.height * v.up:getScaleY()
    v.up:setPosition(posX - btnSize.width * 0.5 - 0.5, posY + btnSize.height * 0.5)
    v.down:setPosition(posX - btnSize.width * 0.5, posY - btnSize.height * 0.5)
  end
  self.scrollSize = CCSizeMake(self.panelSize.width, self.panelSize.height - 95)
  local rect = self.draglist.cliprect
  local x = rect.origin.x
  local y = rect.origin.y
  local w = self.scrollSize.width
  local h = self.scrollSize.height
  self.draglist:initClipRect(CCRectMake(x, y, w, h))
  self.closeBtn:setPosition(self.panelSize.width - 30, self.panelSize.height - 10)
  self.expandBtn:setPosition(self.panelSize.width - 10, self.panelSize.height - 10)
end

function NodeTreeEditor:getTouchArea()
  local pos = self.rootPanel:convertToWorldSpace(ccp(0, 0))
  local wRect = CCRectMake(pos.x, pos.y, self.panelSize.width, self.panelSize.height)
  return wRect
end

function NodeTreeEditor:doMainLayerTouch()
  local function handler(event, x, y)
    local result, param = xpcall(function()
      if nil ~= self.rootPanel and self.rootPanel:isVisible() then
        if event == "began" then
          local touchArea = self:getTouchArea()
          
          if touchArea:containsPoint(ccp(x, y)) then
            self.isTouchRoot = true
            self.lastTouchX = x
            self.lastTouchY = y
            if ed.containsPoint(self.visibleBg, x, y) then
              self.isVisibleTouchBegan = true
              self.visibleBg:setScale(0.6649999999999999)
            elseif ed.containsPoint(self.closeBtn, x, y) then
              self.isCloseTouchBegan = true
              self.closeBtn:setScale(0.95 * self.recordCloseBtnScale)
            elseif y > touchArea:getMaxY() - 20 then
              if x > touchArea:getMaxX() - 20 then
                self.isScaleMove = true
              else
                self.isDragMove = true
              end
            else
              for i, v in ipairs(self.changeValInfoArr) do
                if ed.containsPoint(v.up, x, y) then
                  v.up:setScale(0.13)
                  self.touchChangeValIndex = i
                  break
                end
                if ed.containsPoint(v.down, x, y) then
                  v.down:setScale(0.13)
                  self.touchChangeValIndex = -i
                  break
                end
              end
            end
            return true
          end
        elseif event == "moved" then
          if self.isTouchRoot then
            if self.isDragMove then
              self.panelPos.x = self.panelPos.x + (x - self.lastTouchX)
              self.panelPos.y = self.panelPos.y + (y - self.lastTouchY)
              self.rootPanel:setPosition(self.panelPos)
              self:removeDrawNode()
            elseif self.isScaleMove then
              self.panelSize.width = math.max(self.panelSize.width + (x - self.lastTouchX), 150)
              self.panelSize.height = math.max(self.panelSize.height + (y - self.lastTouchY), 200)
              self.rootPanel:setContentSize(self.panelSize)
              self:refreshOperateUIPos()
            end
            self.lastTouchX = x
            self.lastTouchY = y
            return true
          end
        elseif event == "ended" and self.isTouchRoot then
          self.isDragMove = false
          self.isScaleMove = false
          if self.isVisibleTouchBegan and ed.containsPoint(self.visibleBg, x, y) then
            self:setNodeVisible(not self.visibleImg:isVisible())
            self.isVisibleTouchBegan = false
          end
          self.visibleBg:setScale(0.7)
          if self.isCloseTouchBegan and ed.containsPoint(self.closeBtn, x, y) then
            self:destroyEditor()
            return
          end
          self.closeBtn:setScale(self.recordCloseBtnScale)
          if self.touchChangeValIndex ~= 0 then
            local v = self.changeValInfoArr[math.abs(self.touchChangeValIndex)]
            if self.touchChangeValIndex > 0 then
              self:onChangeValOnce(v.type, 0.01)
            elseif self.touchChangeValIndex < 0 then
              self:onChangeValOnce(v.type, -0.01)
            end
            v.up:setScale(0.15)
            v.down:setScale(0.15)
            v.loopFunc = nil
            self.touchChangeValIndex = 0
          end
          return true
        end
      end
      return false
    end, EDDebug)
    return param
  end
  
  return handler
end

function NodeTreeEditor:updateChangeValTimer()
  if self.touchChangeValIndex ~= 0 then
    local v = self.changeValInfoArr[math.abs(self.touchChangeValIndex)]
    if nil == v.loopFunc then
      v.loopFunc = self:createLoopFunc(function()
        if self.touchChangeValIndex > 0 then
          self:onChangeValOnce(v.type, 0.1)
        elseif self.touchChangeValIndex < 0 then
          self:onChangeValOnce(v.type, -0.1)
        end
      end)
    end
    v.loopFunc()
  end
end

function NodeTreeEditor:update()
  local scene = CCDirector:sharedDirector():getRunningScene()
  if tolua.isnull(scene) then
    return
  end
  if self.curScene ~= scene or self.forceCleanup then
    self:onSceneCleanup()
    self.curScene = scene
    self:onSceneEnter()
  end
  self.lastNodeInfoTab = self.curNodeInfoTab
  self.curNodeInfoTab = {}
  self.nodeNum = 0
  self.contentHeight = 0
  local childNum = self.curScene:getChildrenCount()
  if 0 < childNum then
    local children = self.curScene:getChildren()
    for i = 1, childNum do
      local child = children:objectAtIndex(i - 1)
      if self.rootPanel ~= child then
        self:searchChild(child, i - 1, nil, 0)
      end
    end
  end
  for i = self.nodeNum + 1, #self.nodeArr do
    self.nodeArr[i].bg:setVisible(false)
  end
  self:updateSelectedItem()
  local oldHeight = self.draglist:getListHeight()
  self.draglist:initListHeight(self.contentHeight, false)
  if oldHeight > self.contentHeight then
    local _, scrollPosY = self.draglist:getListPos()
    self.draglist:setListPos(ccp(0, scrollPosY), true)
  end
end

function NodeTreeEditor:searchChild(node, nodeIndex, parentItemIndex, indent)
  if nil == node.getChildrenCount then
    node = tolua.cast(node, "CCNode")
  end
  self.nodeNum = self.nodeNum + 1
  local nodeItem = self.nodeArr[self.nodeNum]
  if nil == nodeItem then
    local nodeSprite = ed.createSprite("UI/alpha/1080P/common/tab_1.png")
    nodeSprite:setContentSize(self.nodeSize)
    local nodeDesLabel = ed.createLabelTTF("" .. indent, 10)
    nodeDesLabel:setStroke(ccc3(0, 0, 0), 0.5)
    nodeSprite:addChild(nodeDesLabel)
    nodeDesLabel:setPosition(self.nodeSize.width * 0.5, self.nodeSize.height * 0.5)
    local arrowSprite = ed.createSprite("UI/alpha/1080P/common/dialogue_arrow.png")
    nodeSprite:addChild(arrowSprite)
    arrowSprite:setPosition(arrowSprite:getContentSize().width * 0.5, nodeSprite:getContentSize().height * 0.5)
    self.draglist:addItem(nodeSprite)
    nodeItem = {
      bg = nodeSprite,
      des = nodeDesLabel,
      arrow = arrowSprite,
      index = #self.nodeArr + 1
    }
    table.insert(self.nodeArr, nodeItem)
  else
    nodeItem.bg:setVisible(true)
  end
  if self.nodeNum == self.curItemIndex then
    nodeItem.bg:setColor(ccc3(0, 255, 0))
  else
    nodeItem.bg:setColor(ccc3(255, 255, 255))
  end
  nodeItem.extraParam = {nodeIndex = nodeIndex, parentItemIndex = parentItemIndex}
  nodeItem.des:setString(self:getNodeDes(node))
  nodeItem.bg:setPosition(indent * self.indentSpace + self.nodeSize.width * 0.5, self.scrollSize.height - self.contentHeight - self.nodeSize.height * 0.5)
  self.contentHeight = self.contentHeight + self.nodeSize.height
  local key = self:getNodeKey(node)
  local info = self.lastNodeInfoTab[key]
  if nil == info then
    info = {key = key, isFold = false}
  end
  self.curNodeInfoTab[key] = info
  local childNum = node:getChildrenCount()
  if 0 < childNum then
    nodeItem.arrow:setVisible(true)
    nodeItem.arrow:setRotation(info.isFold and 0 or -90)
    if info.isFold then
      local children = node:getChildren()
      for i = 1, childNum do
        local child = children:objectAtIndex(i - 1)
        self:searchChild(child, i - 1, nodeItem.index, indent + 1)
      end
    end
  else
    nodeItem.arrow:setVisible(false)
  end
end

function NodeTreeEditor:getNodeDes(node)
  local str = tolua.type(node) .. (node.getLuaName and node:getLuaName())
  return str
end

function NodeTreeEditor:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.nodeArr) do
      if v.bg:isVisible() and ed.containsPoint(v.bg, x, y) then
        v.bg:setScale(0.95)
        
        return v, k
      end
    end
    return nil
  end
  
  return handler
end

function NodeTreeEditor:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.bg:setScale(1)
  end
  
  return handler
end

function NodeTreeEditor:doClickInList()
  local function handler(x, y, v, k)
    if not v then
      return
    end
    self:onNodeEvent(x, y, k)
  end
  
  return handler
end

function NodeTreeEditor:getNodeObj(index)
  if index <= 0 then
    return nil
  end
  local nodeItem = self.nodeArr[index]
  local arr = {}
  repeat
    if nil == nodeItem or not nodeItem.bg:isVisible() then
      return nil
    end
    table.insert(arr, 1, nodeItem.extraParam.nodeIndex)
    if nil == nodeItem.extraParam.parentItemIndex then
      break
    end
    nodeItem = self.nodeArr[nodeItem.extraParam.parentItemIndex]
  until false
  local node = self.curScene
  for i, v in ipairs(arr) do
    node = tolua.cast(node:getChildren():objectAtIndex(v), "CCNode")
  end
  return node
end

function NodeTreeEditor:onNodeEvent(x, y, index)
  if nil == self.curScene or tolua.isnull(self.curScene) then
    return
  end
  local node = self:getNodeObj(index)
  if nil == node then
    return
  end
  local nodeInfo = self.curNodeInfoTab[self:getNodeKey(node)]
  local nodeItem = self.nodeArr[index]
  if nil == nodeInfo or nil == nodeItem then
    return
  end
  self.curItemIndex = index
  self:removeDrawNode()
  self:updateNodeInfoUI(node)
  if ed.containsPoint(nodeItem.arrow, x, y) and node:getChildrenCount() > 0 then
    nodeInfo.isFold = not nodeInfo.isFold
  end
end

function NodeTreeEditor:setNodeVisible(isVisible)
  local node = self:getNodeObj(self.curItemIndex)
  if nil == node then
    return
  end
  node:setVisible(isVisible)
  self.visibleImg:setVisible(isVisible)
end

function NodeTreeEditor:updateSelectedItem()
  if nil == self.curScene or tolua.isnull(self.curScene) then
    return
  end
  local node = self:getNodeObj(self.curItemIndex)
  if nil == node then
    self.posXLabel:setString("nil")
    self.posYLabel:setString("nil")
    self.anchorXLabel:setString("nil")
    self.anchorYLabel:setString("nil")
    self.sizeXLabel:setString("nil")
    self.sizeYLabel:setString("nil")
    self.scaleXLabel:setString("nil")
    self.scaleYLabel:setString("nil")
    self.rotLabel:setString("nil")
    self:removeDrawNode()
    return
  end
  self:updateNodeInfoUI(node)
end

function NodeTreeEditor:updateNodeInfoUI(node)
  if nil == node then
    return
  end
  self.visibleImg:setVisible(node:isVisible())
  local posX, posY = node:getPosition()
  self.posXLabel:setString(math.floor(posX * 100) / 100)
  self.posYLabel:setString(math.floor(posY * 100) / 100)
  local anchor = node:getAnchorPoint()
  self.anchorXLabel:setString(math.floor(anchor.x * 100) / 100)
  self.anchorYLabel:setString(math.floor(anchor.y * 100) / 100)
  local size = node:getContentSize()
  self.sizeXLabel:setString(math.floor(size.width * 100) / 100)
  self.sizeYLabel:setString(math.floor(size.height * 100) / 100)
  self.scaleXLabel:setString(math.floor(node:getScaleX() * 100) / 100)
  self.scaleYLabel:setString(math.floor(node:getScaleY() * 100) / 100)
  self.rotLabel:setString(math.floor(node:getRotation() * 100) / 100)
  if nil == self.selectionDrawNode then
    self.selectionDrawNode = CCDrawNode:create()
    self.rootPanel:addChild(self.selectionDrawNode)
    local minPos = node:convertToWorldSpace(ccp(0, 0))
    minPos = self.rootPanel:convertToNodeSpace(minPos)
    local maxPos = node:convertToWorldSpace(ccp(size.width, size.height))
    maxPos = self.rootPanel:convertToNodeSpace(maxPos)
    local minX, minY = math.min(minPos.x, maxPos.x), math.min(minPos.y, maxPos.y)
    local maxX, maxY = math.max(minPos.x, maxPos.x), math.max(minPos.y, maxPos.y)
    local drawWidth = math.max(1, maxX - minX)
    local drawHeight = math.max(1, maxY - minY)
    self.selectionDrawNode:drawRect(ccp(minX, minY + drawHeight * 0.5), drawWidth, drawHeight)
  end
end

function NodeTreeEditor:getNodeKey(node)
  local metatable = getmetatable(node)
  local uboxtable = rawget(metatable, "tolua_ubox")
  for k, v in pairs(uboxtable) do
    if v == node then
      return tostring(k)
    end
  end
  return nil
end

function NodeTreeEditor:createLoopFunc(func)
  local count = 0
  local delay = 0.5
  local accAcc = 2
  local speed = 10
  local accSpeed = 2
  local times = 0
  local func = func
  
  local function longPressHandler()
    local dt = 0.01666
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        func()
        times = times - 1
      end
    end
  end
  
  return longPressHandler
end

function NodeTreeEditor:onChangeValOnce(type, changeVal)
  if nil == self.curScene or tolua.isnull(self.curScene) then
    return
  end
  local node = self:getNodeObj(self.curItemIndex)
  if nil == node then
    return
  end
  if "posX" == type then
    node:setPositionX(node:getPositionX() + changeVal)
  elseif "posY" == type then
    node:setPositionY(node:getPositionY() + changeVal)
  elseif "scaleX" == type then
    node:setScaleX(node:getScaleX() + changeVal)
  elseif "scaleY" == type then
    node:setScaleY(node:getScaleY() + changeVal)
  elseif "rot" == type then
    node:setRotation(node:getRotation() + changeVal)
  elseif "anchorX" == type then
    local anchor = node:getAnchorPoint()
    anchor.x = anchor.x + changeVal
    node:setAnchorPoint(anchor)
  elseif "anchorY" == type then
    local anchor = node:getAnchorPoint()
    anchor.y = anchor.y + changeVal
    node:setAnchorPoint(anchor)
  elseif "width" == type then
    local size = node:getContentSize()
    size.width = size.width + changeVal
    node:setContentSize(size)
  elseif "height" == type then
    local size = node:getContentSize()
    size.height = size.height + changeVal
    node:setContentSize(size)
  end
  self:removeDrawNode()
end

function NodeTreeEditor:removeDrawNode()
  if nil ~= self.selectionDrawNode then
    self.selectionDrawNode:removeFromParentAndCleanup(true)
    self.selectionDrawNode = nil
  end
end

function NodeTreeEditor:destroyEditor()
  self.rootPanel:removeFromParentAndCleanup(true)
  ed.nodeTreeEditorInstance = nil
  CloseScope(self.eventScope)
  package.loaded["debug/nodetree/init"] = nil
  package.loaded["debug/nodetree/nodeTreeEditor"] = nil
end

ed.nodeTreeEditorInstance = NodeTreeEditor.getInstance()
