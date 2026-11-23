local chatListView = {}
ed.ui.chatListView = chatListView
chatListView.__index = chatListView

function chatListView.new()
  local self = {}
  setmetatable(self, chatListView)
  self:init()
  return self
end

function chatListView:init()
  self.visible = true
  self.currentWidth = 0
  self.currentHeight = 0
  self.currentMaxHeight = 0
  self.itemWidthInner = 0
  self.initHeight = 0
  self.initWidth = 0
  self.anchor = ccp(0, 1)
  self.maxItem = nil
  self.layoutMode = "down"
  self:initSelfData()
end

function chatListView:setPanelLayer(layer)
  if nil == layer then
    return
  end
  self.panelLayer = layer
end

function chatListView:setPanelLogic(logic)
  self.panelLogic = logic
end

function chatListView:initSelfData()
  self.listData = {}
  self.currentRow = 0
  self.currentCol = 0
  self.currentWidth = 0
  self.currentHeight = 0
  self.currentMaxHeight = 0
  self.currentMaxWidth = 0
  self.endWidth = 0
  self.itemWidthInner = 0
  self.initHeight = 0
  self.initWidth = 0
end

function chatListView:initParem(info)
  if info == nil then
    return
  end
  if info.base == nil then
    print("error:listview need base info")
  end
  if info.base.cliprect == nil then
    print("error:listview need cliprect")
  end
  if info.base.colNum then
    self.colNum = info.base.colNum or 1
  end
  if info.base.widthInner then
    self.itemWidthInner = info.base.widthInner or 10
  end
  if info.base.anchor then
    self.anchor = info.base.anchor
  end
  if info.base.layoutMode then
    self.layoutMode = info.base.layoutMode
  end
  if info.base.maxItem then
    self.maxItem = info.base.maxItem
  end
  if info.base.heightInner then
    self.itemHeightInner = info.base.heightInner or 10
  end
  if info.base.selfDealMessage then
    self.selfDealMessage = info.base.selfDealMessage
  end
  if info.base.initHeight then
    self.initHeight = info.base.initHeight or 0
  end
  if info.base.initWidth then
    self.initWidth = info.base.initWidth or 0
  end
  local noshade = info.base.noShade
  if noshade == nil then
    noshade = true
  end
  local info = {
    cliprect = info.base.cliprect,
    rect = info.base.rect,
    priority = info.base.priority or -5,
    container = self.panelLayer or info.base.container,
    noshade = noshade,
    message = not self.selfDealMessage,
    upShade = info.base.upShade,
    downShade = info.base.downShade,
    bar = info.base.bar
  }
  local listLayer = ed.draglist.create(info)
  self.dragList = listLayer
  self.dragList.listLayer:registerScriptHandler(self:onEnterHandler())
end

function chatListView:onEnterHandler()
  local function handler(event)
    xpcall(function()
      if event == "exit" then
        self.dragList.listLayer:stopAllActions()
      end
    end, EDDebug)
  end
  
  return handler
end

function chatListView:setCliprect(cliprect)
  self.dragList:setClipRect(cliprect)
end

function chatListView:isEmpty()
  if #self.listData == 0 then
    return true
  end
  return false
end

function chatListView:clear()
  if self.dragList then
    self.dragList:clearList()
  end
  self:initSelfData()
end

function chatListView:setVisible(visible)
  self.visible = visible
  if self.dragList then
    self.dragList.listLayer:setVisible(visible)
  end
end

function chatListView:getListData(index)
  return self.listData[index]
end

function chatListView:getListDataNum()
  return #self.listData
end

function chatListView:getALLListData()
  return self.listData
end

function chatListView:setHeightInner(heightInner)
  self.itemHeightInner = heightInner
end

function chatListView:addItem(item, extraData, params, controllers)
  if nil == item then
    return
  end
  self.dragList.listLayer:addChild(item)
  local itemData = {
    itemNode = item,
    extraData = extraData,
    params = params,
    controllers = controllers
  }
  table.insert(self.listData, itemData)
  self:refreshList(item, itemData)
  if self.autoClipItemEnabled then
    self.dragList:setFrameRect(item, CCRectMake(0, 0, params.width, params.height))
    self.dragList:setParentClipNode(item, self.dragList.listLayer)
    self.dragList:setClipItemAnchorPt(item, ccp(0, 1))
  end
  return itemData
end

function chatListView:showItemInVertical(item, offset)
  self.dragList:showItemInVertical(item, offset)
end

function chatListView:refreshList(item, itemData)
  if self.maxItem and #self.listData > self.maxItem then
    self:removeItem(1, false)
  end
  local width, height = itemData.params.width, itemData.params.height
  if height > self.currentMaxHeight then
    self.currentMaxHeight = height
  end
  if width > self.currentMaxWidth then
    self.currentMaxWidth = width
  end
  itemData.width = width
  itemData.height = height
  local itemNum = #self.listData
  local rows = math.floor((itemNum - 1) / self.colNum) + 1
  local colIndex = itemNum % self.colNum == 0 and self.colNum or itemNum % self.colNum
  if colIndex == 1 then
    self.currentWidth = 0
  end
  self.dragList:initListHeight(self.currentHeight + self.currentMaxHeight + self.itemHeightInner + self.initHeight, false)
  local touchArea = self.dragList.cliprect
  local itemY = touchArea.size.height + touchArea.origin.y - 10 - self.currentHeight
  if self.layoutMode == "up" then
    itemY = touchArea.size.height + touchArea.origin.y - 10
    self:refreshItemUpLayout()
  end
  local itemX = touchArea.origin.x + self.currentWidth + self.initWidth
  item:setPosition(ccp(itemX, itemY - self.initHeight))
  self.currentWidth = self.currentWidth + width + self.itemWidthInner + self.initWidth
  self.endWidth = self.endWidth
  if colIndex == self.colNum then
    self.currentHeight = self.currentHeight + self.currentMaxHeight + self.itemHeightInner
    self.currentMaxHeight = 0
    self.currentWidth = self.currentWidth + self.currentMaxHeight + self.itemWidthInner
    self.currentMaxWidth = 0
  end
  if self.currentWidth > self.endWidth then
    self.endWidth = self.currentWidth
  end
end

function chatListView:refreshItemUpLayout()
  local offset = self.currentMaxHeight + self.itemHeightInner
  for i, v in ipairs(self.listData) do
    if v.itemNode and i ~= #self.listData then
      local x, y = v.itemNode:getPosition()
      v.itemNode:setPosition(x, y - offset)
    end
  end
end

function chatListView:refreshItemDownLayout()
end

function chatListView:removeItem(index, isrest)
  if nil == index then
    return
  end
  if nil == self.listData[index] then
    return
  end
  local height = self.listData[index].params.height
  local startIndex, endIndex, operand
  if self.layoutMode == "up" then
    startIndex = index - 1
    endIndex = 1
    operand = -1
  else
    startIndex = index + 1
    endIndex = #self.listData
    operand = 1
  end
  for i = startIndex, endIndex, operand do
    local item = self.listData[i]
    if item and item.itemNode then
      local x, y = item.itemNode:getPosition()
      item.itemNode:setPosition(x, y + height + self.itemHeightInner)
    end
  end
  self.dragList.listLayer:removeChild(self.listData[index].itemNode, true)
  table.remove(self.listData, index)
  self.currentHeight = self.currentHeight - height - self.itemHeightInner
  self.dragList:initListHeight(self.currentHeight, isrest)
end

function chatListView:stickTopItem(itemData)
  local index
  for i, data in ipairs(self.listData) do
    if itemData.extraData.roleId == data.extraData.roleId then
      index = i
    end
  end
  if index == #self.listData then
    return
  end
  if not index then
    return
  end
  itemData.itemNode:retain()
  self:removeItem(index)
  self.dragList.listLayer:addChild(itemData.itemNode)
  itemData.itemNode:release()
  table.insert(self.listData, itemData)
  self:refreshList(itemData.itemNode, itemData)
end

function chatListView:sortFormFun(fun)
  if type(fun) ~= "function" then
    return
  end
  local listData = self.listData
  table.sort(listData, fun)
  self.listData = listData
  local touchArea = self.dragList.cliprect
  local itemY = touchArea.size.height + touchArea.origin.y - 10 - self.currentHeight
  if self.layoutMode == "up" then
    itemY = touchArea.size.height + touchArea.origin.y - 10
  end
  local itemX = touchArea.origin.x + self.currentWidth + self.initWidth
  local index = 0
  for i = #self.listData, 1, -1 do
    local item = self.listData[i].itemNode
    local x = item:getPosition()
    local offset = (self.listData[i].height + self.itemHeightInner) * index
    item:setPosition(ccp(x, itemY - offset))
    index = index + 1
  end
end

function chatListView:checkTouchCondition(event, x, y)
  if self.visible == false then
    return false
  end
  if ed.checkVisible(self.panelLayer) == false then
    return false
  end
  if self:isEmpty() then
    return false
  end
  local wRect = self.dragList:getTouchArea()
  if not wRect:containsPoint(ccp(x, y)) and event == "began" then
    return false
  end
  return true
end

function chatListView:touch(event, x, y)
  if self:checkTouchCondition(event, x, y) == false then
    return false
  end
  if self.selfDealMessage == true then
    self.dragList:doListLayerTouch(event, x, y)
  end
  if event == "began" then
  else
    if event == "ended" then
    else
    end
  end
  return true
end

function chatListView:getListPos()
  return self.dragList:getListPos()
end
