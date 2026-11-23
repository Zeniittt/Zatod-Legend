local class = newclass("g")
ed.ui.autoDragList = class
class.debug = false
local TOP_TO_BOTTOM = 1
local BOTTOM_TO_TOP = 2
local LEFT_TO_RIGHT = 3
local RIGHT_TO_LEFT = 4
local bar_bg_res = "installer/scroll_bar_bg.png"
local bar_res = "installer/scroll_bar.png"

function class.create(container, param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(container, param)
  return self
end

function class:init(container, param)
  self.param = param
  self.dragMode = param.dragMode or TOP_TO_BOTTOM
  if self.dragMode == TOP_TO_BOTTOM or self.dragMode == LEFT_TO_RIGHT then
    self.isReverse = false
  else
    self.isReverse = true
  end
  self.container = container
  self.createCellFunc = param.createCellFunc
  self.updateCellFunc = param.updateCellFunc
  self.getCellSizeFunc = param.getCellSizeFunc
  self.getCellsNumFunc = param.getCellsNumFunc
  self:initList()
end

function class:initList()
  self.defaultRowHeight = self.param.defaultRowHeight or 100
  self.cellsHeight = {}
  self.rowsHeight = {}
  self.cellsObject = {}
  self.cellBuffer = {}
  self.cellBufferLength = self.param.cellBufferLength or 2
  self.lineSpace = self.param.lineSpace or 0
  self.barConfig = self.param.bar
  self.priority = self.param.priority or -300
  local containerSize = self.container:getContentSize()
  local w = containerSize.width
  local h = containerSize.height
  self.w, self.h = w, h
  self.mainLayer = CCLayer:create()
  self.mainLayer:setContentSize(CCSizeMake(w, h))
  self.container:addChild(self.mainLayer)
  self.clipRect = CCRectMake(0, 0, w, h)
  self.clipLayer = CCLayer:create()
  self.clipLayer:setContentSize(CCSizeMake(w, h))
  self.clipLayer:setClipRect(self.clipRect)
  self.mainLayer:addChild(self.clipLayer)
  self.listLayer = CCLayer:create()
  self.listLayer:setAnchorPoint(ccp(0, 0))
  self.listLayer:setPosition(ccp(0, 0))
  self.listLayer:setContentSize(CCSizeMake(w, h))
  self.clipLayer:addChild(self.listLayer)
  self.listLayer:setTouchEnabled(true)
  self.listLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, self.priority, false)
  self.listLayerScheduler = self.listLayer:getScheduler()
  self.listLayerScheduler:scheduleScriptFunc(function(dt)
    self:listLayerMove(dt)
  end, 0, false)
  self.listPosX, self.listPosY = self.listLayer:getPosition()
  self.totalHeight = 0
  self.cellsNum = 0
  self.bottom = 0
  self.top = self.bottom + h
  self.dragLimitUpY = 0
  self.dragLimitDownY = 0
  self.preTouchX = 0
  self.preTouchY = 0
  self.startTouchX = 0
  self.startTouchY = 0
  self.canDragX = false
  self.canDragY = false
  self.speedY = 0
  self.cellsPosition = {}
  self:initScrollBar()
end

function class:initScrollBar()
  if not self.barConfig then
    return
  end
  local barConfig = self.barConfig
  self.barShowMode = barConfig.showMode or 0
  if self.barShowMode == 0 then
    return
  end
  local barBgRes = barConfig.bgres or bar_bg_res
  local barRes = barConfig.barres or bar_res
  local barPos = barConfig.bgpos or ccp(-2, self.h / 2)
  local barBg = CCSprite:create(barBgRes)
  local barBgSize = barBg:getContentSize()
  barBg:setScaleY(self.h / barBgSize.height)
  barBg:setPosition(barPos)
  self.mainLayer:addChild(barBg)
  self.barBg = barBg
  self.barBgSize = barBgSize
  local bar = CCSprite:create(barRes)
  local barSize = bar:getContentSize()
  bar:setScaleY(self.h / barSize.height)
  bar:setPositionX(barPos.x)
  bar:setPositionY(self.h / 2)
  self.mainLayer:addChild(bar)
  self.barSize = barSize
  self.bar = bar
  self:setScrollBarVisible(false)
end

function class:doMainLayerTouch()
  local function handler(event, x, y)
    self:doListLayerTouch(event, x, y)
    
    return true
  end
  
  return handler
end

function class:doListLayerTouch(event, x, y)
  if tolua.isnull(self.listLayer) then
    return
  end
  if not self.listLayer:isVisible() then
    return
  end
  if event == "began" then
    if not ed.containsPoint(self.container, x, y) then
      return false
    end
    self.isPressInRect = true
    self.preTouchX = x
    self.preTouchY = y
    self.startTouchX = x
    self.startTouchY = y
    self.listLayer:stopAllActions()
    self.isRunningInertialAction = false
    self:doPressIn(x, y)
  elseif event == "moved" then
    if not self.isPressInRect then
      return false
    end
    if not self.canDragY then
      return
    end
    local dy = y - self.preTouchY
    self.preTouchX = x
    self.preTouchY = y
    if math.abs(y - self.startTouchY) < 14 and math.abs(x - self.startTouchX) < 14 then
      return
    end
    local newListY = self.listPosY + dy
    if newListY < self.dragLimitUpY then
      local k = 1 + (newListY - self.dragLimitUpY) / (self.h / 2)
      newListY = self.listPosY + dy * k
    elseif newListY > self.dragLimitDownY - self.h then
      local k = 1 + (newListY - self.dragLimitDownY) / (self.h / 2)
      newListY = self.listPosY + dy * -k
    end
    newListY = math.max(newListY, self.dragLimitUpY - self.h / 2)
    newListY = math.min(newListY, self.dragLimitDownY - self.h / 2)
    self:getSpeed(newListY, self.listPosY)
    if self.listPosY ~= newListY then
      self.listPosY = newListY
      self.listLayer:setPositionY(newListY)
      self:updateList()
    end
  elseif event == "ended" then
    if not self.isPressInRect then
      return false
    end
    if not self.canDragY then
      return
    end
    self:cancelPressIn(x, y)
    self:doClickIn(x, y)
    self.isPressInRect = false
    local endX, endY = 0, 0
    local isBackOut, isMoveAction
    local minY = self.dragLimitUpY
    local maxY = self.dragLimitDownY - self.h
    if minY > self.listPosY then
      endY = minY
      isBackOut = true
    elseif maxY < self.listPosY then
      endY = maxY
      isBackOut = true
    elseif self.speedY == 0 then
      isMoveAction = false
    else
      isMoveAction = true
      endY = self.listPosY + self.speedY / 2
      endY = math.min(endY, maxY)
      endY = math.max(endY, minY)
    end
    local easeAction
    if isBackOut then
      local action = CCMoveTo:create(0.5, ccp(endX, endY))
      easeAction = CCEaseBackOut:create(action)
    elseif isMoveAction then
      local action = CCMoveTo:create(2, ccp(endX, endY))
      easeAction = CCEaseExponentialOut:create(action)
      self.isRunningInertialAction = true
    end
    if easeAction then
      local seq = CCSequence:createWithTwoActions(easeAction, CCCallFunc:create(function()
        self.isRunningInertialAction = false
      end))
      self.listLayer:runAction(seq)
    end
    self:stopGetSpeed()
  end
end

function class:getSpeed(newListY, oldListY, dt)
  dt = 0.016666666666666666
  local dy = newListY - oldListY
  local speedY = dy / dt
  local speedThresholds = 60
  if speedThresholds >= math.abs(speedY) then
    self.speedY = 0
  else
    self.speedY = speedY
  end
end

function class:stopGetSpeed()
  self.speedY = 0
end

function class:listLayerMove(dt)
  local oldListY = self.listLayer:getPositionY()
  if oldListY == self.listPosY then
    return
  end
  if self.isRunningInertialAction then
    oldListY = math.max(oldListY, self.dragLimitUpY)
    oldListY = math.min(oldListY, self.dragLimitDownY - self.h)
  end
  self.listPosY = oldListY
  self.listLayer:setPositionY(self.listPosY)
  self:updateList()
end

function class:reload()
  self:clearList()
  self.cellsNum = self:getCellsNums()
  self:initDefaultHeight()
  self.totalHeight = self.cellsNum * self.defaultRowHeight
  self.dragLimitUpY = 0
  self.dragLimitDownY = self.totalHeight
  self:reloadList()
end

function class:clearList()
  self.cellsPosition = {}
  self.cellBuffer = {}
  self.cellsObject = {}
  self.listPosY = 0
  self.speedY = 0
  self.cellsHeight = {}
  self.listLayer:setPositionY(0)
  self.listLayer:removeAllChildrenWithCleanup(true)
end

function class:initDefaultHeight()
  if self.param.defaultRowHeight then
    return
  end
  local index = 1
  local cell = self:createCell(index)
  local defaultRowHeight = self:getCellHeight(cell, index)
  if defaultRowHeight then
    self.defaultRowHeight = defaultRowHeight
  end
end

function class:reloadList()
  local startY = self.h
  local newTotalHeight = self.totalHeight
  for index = 1, self.cellsNum do
    local cellHeight = self.cellsHeight[index] or self.defaultRowHeight
    if self:checkInSight(startY, cellHeight) then
      local newCellHeight = self:createRow(index)
      local changeHeight = newCellHeight - cellHeight
      self.dragLimitDownY = self.dragLimitDownY + changeHeight
      newTotalHeight = newTotalHeight + changeHeight
      cellHeight = newCellHeight
    end
    self.cellsPosition[index] = ccp(0, startY)
    startY = startY - cellHeight
  end
  self:refreshTotalHeight(newTotalHeight)
  self:refreshItemPos()
  self:refreshScrollBar()
end

function class:insertCell(insertIndex, isResetPos)
  if isResetPos then
    self.listPosY = 0
    self.listLayer:setPositionY(self.listPosY)
  end
  local newCell = self:createCell(insertIndex)
  local height = self:getCellHeight(newCell, insertIndex)
  local newCellObject = {}
  for index = self.cellsNum, 1, -1 do
    local cell = self.cellsObject[index]
    if cell then
      if insertIndex <= index then
        newCellObject[index + 1] = cell
      else
        newCellObject[index] = cell
      end
    end
    if insertIndex <= index then
      local oldItemPos = self.cellsPosition[index]
      if oldItemPos then
        local newItemPos = ccp(0, oldItemPos.y - height)
        self.cellsPosition[index + 1] = newItemPos
      end
    end
  end
  self.cellsObject = newCellObject
  self.cellsNum = self:getCellsNums()
  self:refreshTotalHeight(self.totalHeight + height)
  self:updateList()
end

function class:deleteCell(deleteIndex, isResetPos)
  if isResetPos then
    self.listPosY = 0
    self.listLayer:setPositionY(self.listPosY)
  end
  if deleteIndex > self.cellsNum or deleteIndex < 1 then
    return
  end
  local oldCell = self.cellsObject[deleteIndex]
  local height = oldCell and self:getCellHeight(oldCell, deleteIndex) or self.defaultRowHeight
  local newCellObject = {}
  for index = 1, self.cellsNum do
    local cell = self.cellsObject[index]
    if cell then
      if deleteIndex < index then
        newCellObject[index - 1] = cell
      elseif index == deleteIndex then
        self:recycleItem(deleteIndex)
      else
        newCellObject[index] = cell
      end
    end
    if deleteIndex < index then
      local oldItemPos = self.cellsPosition[index]
      if oldItemPos then
        local newItemPos = ccp(0, oldItemPos.y + height)
        self.cellsPosition[index - 1] = newItemPos
      end
    end
  end
  self.cellsObject = newCellObject
  self.cellsNum = self:getCellsNums()
  self:refreshTotalHeight(self.totalHeight - height)
  self:updateList()
end

function class:rollToIndex(index)
  local pos = self.cellsPosition[index]
  if not pos then
    return
  end
  self.listPosY = self.h - pos.y
  self.listLayer:setPositionY(self.listPosY)
  self:updateList()
end

function class:updateList()
  local findIndex = self:binarySearch(1, self.cellsNum)
  if not findIndex then
    return
  end
  local startY = self.cellsPosition[findIndex].y
  local upY = startY
  local downY = startY
  local newTotalHeight = self.totalHeight
  local inSightList = {}
  local change = false
  for index = findIndex - 1, 1, -1 do
    local cellHeight = self.cellsHeight[index] or self.defaultRowHeight
    if self:checkInSight(upY, cellHeight) then
      local newCellHeight = self:createRow(index)
      local changeHeight = newCellHeight - cellHeight
      newTotalHeight = newTotalHeight + changeHeight
      self.dragLimitUpY = self.dragLimitUpY - changeHeight
      cellHeight = newCellHeight
      table.insert(inSightList, index)
      if changeHeight ~= 0 then
        change = true
      end
    elseif not change then
      break
    end
    upY = upY + cellHeight
    self.cellsPosition[index] = ccp(0, upY)
  end
  change = false
  for index = findIndex, self.cellsNum do
    local cellHeight = self.cellsHeight[index] or self.defaultRowHeight
    if self:checkInSight(downY, cellHeight) then
      local newCellHeight = self:createRow(index)
      local changeHeight = newCellHeight - cellHeight
      self.dragLimitDownY = self.dragLimitDownY + changeHeight
      newTotalHeight = newTotalHeight + changeHeight
      cellHeight = newCellHeight
      table.insert(inSightList, index)
      if changeHeight ~= 0 then
        change = true
      end
    elseif not change then
      break
    end
    self.cellsPosition[index] = ccp(0, downY)
    downY = downY - cellHeight
  end
  local recycleList = {}
  for index, cell in pairs(self.cellsObject) do
    if not ed.isElementInTable(index, inSightList) then
      table.insert(recycleList, index)
    end
  end
  for _, index in ipairs(recycleList) do
    self:recycleItem(index)
  end
  self:refreshTotalHeight(newTotalHeight)
  self:refreshItemPos()
  self:refreshScrollBar()
end

function class:refreshItemPos()
  for index, cell in pairs(self.cellsObject) do
    local cellPos = self.cellsPosition[index]
    if cellPos then
      if cell.dragListIndex == index then
        cell.container:stopAllActions()
        cell.container:setPosition(cellPos)
      else
        cell.dragListIndex = index
        cell.container:runAction(CCMoveTo:create(0.2, cellPos))
      end
    end
  end
end

function class:refreshTotalHeight(newTotalHeight)
  if newTotalHeight ~= self.totalHeight then
    self.totalHeight = newTotalHeight
    if self.totalHeight > self.h then
      self.canDragY = true
    else
      self.canDragY = false
    end
  end
end

function class:createRow(index)
  local colWidth = self.w
  local anchorPoint
  if not self.isReverse then
    anchorPoint = ccp(0, 1)
  else
    anchorPoint = ccp(0, 0)
  end
  local cell = self.cellsObject[index]
  if cell then
    if cell.dragListIndex ~= index then
      self:updateCell(cell, index, colWidth)
    end
  elseif 0 < #self.cellBuffer then
    cell = table.remove(self.cellBuffer, 1)
    self:updateCell(cell, index, colWidth)
    cell.dragListIndex = index
    self:log("updateCell", index)
  else
    cell = self:createCell(index, colWidth)
    cell.dragListIndex = index
    self:log("createCell", index)
    cell.container:ignoreAnchorPointForPosition(false)
    cell.container:setAnchorPoint(anchorPoint)
    self.listLayer:addChild(cell.container)
  end
  cell.container:setVisible(true)
  local cellHeight = self:getCellHeight(cell, index)
  self.cellsHeight[index] = cellHeight
  self.cellsObject[index] = cell
  return cellHeight
end

function class:binarySearch(startIndex, endIndex)
  if endIndex <= startIndex then
    return
  end
  local midIndex = math.floor((startIndex + endIndex) / 2)
  local pos = self.cellsPosition[midIndex]
  local posX, posY = pos.x, pos.y
  local cell = self.cellsObject[midIndex]
  local cellHeight = self.cellsHeight[midIndex] or self.defaultRowHeight
  if cell then
    cellHeight = self:getCellHeight(cell)
  end
  local isInSight = self:checkInSight(posY, cellHeight)
  if isInSight then
    return midIndex
  else
    local left = self:binarySearch(startIndex, midIndex)
    if left then
      return left
    end
    local right = self:binarySearch(midIndex + 1, endIndex)
    if right then
      return right
    end
  end
end

function class:recycleItem(index)
  local cell = self.cellsObject[index]
  if cell then
    cell.container:setVisible(false)
    if #self.cellBuffer < self.cellBufferLength then
      self:log("recycle", index)
      table.insert(self.cellBuffer, cell)
    else
      self:log("deleteCell", index)
      cell.container:removeFromParentAndCleanup(true)
    end
    self.cellsObject[index] = nil
  end
end

function class:checkInSight(posY, cellHeight)
  local isInSight = false
  if self.isReverse then
    if posY + self.listPosY <= self.top and posY + cellHeight + self.listPosY >= self.bottom then
      isInSight = true
    end
  elseif posY - cellHeight + self.listPosY <= self.top and posY + self.listPosY >= self.bottom then
    isInSight = true
  end
  return isInSight
end

function class:refreshScrollBar()
  if not self.bar then
    return
  end
  if self.canDragY then
    self:setScrollBarVisible(true)
  else
    if self.barShowMode == 1 then
      self:setScrollBarVisible(false)
    elseif self.barShowMode == 2 then
      self:setScrollBarVisible(true)
    end
    return
  end
  local bh = self.barBgSize.height * (self.h / self.totalHeight)
  local barScaleY = bh / self.bar:getContentSize().height
  if self.listPosY < self.dragLimitUpY then
    self.bar:setAnchorPoint(ccp(0.5, 0))
    local k = 1 + (self.listPosY - self.dragLimitUpY) / (self.h / 2)
    barScaleY = barScaleY * k
    self.bar:setScaleY(barScaleY)
    self.bar:setPositionY(self.h - self.barSize.height * barScaleY)
  elseif self.listPosY > self.dragLimitDownY - self.h then
    self.bar:setAnchorPoint(ccp(0.5, 1))
    local k = 1 + (self.listPosY - self.dragLimitDownY) / (self.h / 2)
    barScaleY = barScaleY * -k
    self.bar:setScaleY(barScaleY)
    self.bar:setPositionY(self.barSize.height * barScaleY)
  else
    self.bar:setScaleY(barScaleY)
    local percent = 1 - self.listPosY / (self.totalHeight - self.h)
    local posY = percent * (self.h - self.barSize.height * barScaleY) + self.barSize.height / 2 * barScaleY
    self.bar:setAnchorPoint(ccp(0.5, 0.5))
    self.bar:setPositionY(posY)
  end
end

function class:getListPos()
  return self.listLayer:getPosition()
end

function class:setListPos(position)
  self.listLayer:setPosition(position)
end

function class:setScrollBarVisible(isVisible)
  if self.bar then
    self.bar:setVisible(isVisible)
  end
  if self.barBg then
    self.barBg:setVisible(isVisible)
  end
end

function class:createCell(index, width)
  width = width or self.w
  return self.createCellFunc(index, width)
end

function class:getCellSize(cell, index)
  if self.getCellSizeFunc then
    return self.getCellSizeFunc(cell, index)
  else
    return cell.container:getContentSize()
  end
end

function class:getCellHeight(cell, index)
  return self:getCellSize(cell, index).height
end

function class:updateCell(cell, index, width)
  return self.updateCellFunc(cell, index, width)
end

function class:getCellsNums()
  if self.getCellsNumFunc then
    return self.getCellsNumFunc()
  end
  return 0
end

function class:doPressIn(x, y)
  self.pressCell = nil
  for index, cell in pairs(self.cellsObject) do
    if ed.containsPoint(cell.container, x, y) then
      self.pressCell = cell
      break
    end
  end
  if self.pressCell and self.pressCell.onPressIn then
    self.pressCell.onPressIn(x, y)
  end
end

function class:cancelPressIn(x, y)
  if self.pressCell and self.pressCell.cancelPressIn then
    self.pressCell.cancelPressIn(x, y)
  end
end

function class:doClickIn(x, y)
  if self.pressCell and self.pressCell.doClickIn then
    self.pressCell.doClickIn.doClickIn(x, y)
  end
end

function class:log(...)
  if self.debug then
    print(...)
  end
end
