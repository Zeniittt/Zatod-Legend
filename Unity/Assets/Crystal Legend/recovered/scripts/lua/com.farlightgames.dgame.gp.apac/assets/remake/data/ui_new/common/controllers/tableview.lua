local tableview = newclass("g")
Tableview = tableview
local tbv = tableview
Tableview.Debug = false
local HORIZONTAL = "horizontal"
local VERTICAL = "vertical"
local TOP2BUTTOM = 1
local BUTTOM2TOP = 2
local LEFT2RIGHT = 3
local RIGHT2LEFT = 4
local InvalidNUm = -1

function tbv:resetNode(node)
  node:setAnchorPoint(ccp(0, 0))
  node:setPosition(ccp(0, 0))
end

function tbv.create(param)
  local self = {}
  setmetatable(self, tbv.mt)
  self:init(param)
  self:reloadData()
  return self
end

function tbv:init(param)
  local container = param.container
  local cliprect = param.cliprect
  local zorder = param.zorder or 0
  local dragMode = param.dragMode
  local delegate = param.delegate
  local colNum = param.colNum or 1
  local noshade = param.noshade
  local doMove = param.doMove
  self.delegate = delegate
  self.dragMode = dragMode
  self.colNum = colNum
  self.padding = param.padding or {width = 0, height = 0}
  self.offset = param.offset or {0, 0}
  self.doMove = doMove
  self.cellsPositions = {}
  if dragMode == TOP2BUTTOM or dragMode == BUTTOM2TOP then
    self.direction = VERTICAL
  else
    self.direction = HORIZONTAL
  end
  local info = {
    cliprect = cliprect,
    container = container,
    noshade = noshade,
    zorder = zorder,
    bar = param.bar,
    priority = param.touchpriority,
    doScroll = self:doScroll(),
    dragMode = dragMode,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
end

function tbv:setDelegate(dlgt)
  self.delegate = dlgt
end

function tbv:reloadData()
  self.dragList:reset()
  self.dragList:clearList()
  self.cellsPositions = {}
  self.cellsUsed = {}
  self.cellsFreed = {}
  self.isCanDoScroll = true
  self:updateCellsPosition()
  self:setContentOffset()
  local handler = self:doScroll()
  handler()
end

function tbv:updateCellsPosition()
  self.cellsPositions = {}
  local cnt = self:numberOfCells()
  if cnt <= 0 then
    return
  end
  local cps = self.cellsPositions
  local offsetX = self.offset[1] or 0
  local offsetY = self.offset[2] or 0
  local ct = self.colNum
  local padding = self.padding
  for i = 1, cnt do
    local cellSize = self:cellSizeFromIndex(i)
    local pos = ccp(offsetX, offsetY - cellSize.height)
    local line = math.ceil(i / ct)
    if i % ct == 0 then
      offsetX = self.offset[1] or 0
      offsetY = offsetY - cellSize.height - padding.height
    else
      offsetX = offsetX + cellSize.width + padding.width
    end
    cps[#cps + 1] = pos
  end
end

function tbv:numberOfCells()
  return self.delegate.numberOfCells()
end

function tbv:cellSizeFromIndex(idx)
  return self.delegate.cellSizeFromIndex(idx)
end

function tbv:addItem(node)
  self:resetNode(node)
end

function tbv:staticSync()
  local pos = self:getContentOffset()
  self:reloadData()
  local dglst = self.dragList
  local ct = dglst.listLayer
  ct:setPosition(pos)
  local handler = self:doScroll()
  handler()
end

function tbv:doScroll()
  local function handler()
    if not self.isCanDoScroll then
      return
    end
    local cnt = self:numberOfCells()
    if cnt <= 0 then
      return
    end
    if self.doMove then
      self.doMove()
    end
    local inside_list = self:getUsedList()
    local temp = {}
    for _, k in ipairs(inside_list) do
      temp[k] = true
    end
    inside_list = temp
    if 0 < #self.cellsUsed then
      local temp = {}
      local ct = #self.cellsUsed
      for k = 1, ct do
        local cell = self.cellsUsed[k]
        if not inside_list[cell.idx] then
          temp[#temp + 1] = k
        end
      end
      for i, k in ipairs(temp) do
        local cell = table.remove(self.cellsUsed, k - i + 1)
        if cell then
          cell.node:removeFromParentAndCleanup(true)
          table.insert(self.cellsFreed, cell)
        end
      end
    end
    for k, _ in pairs(inside_list) do
      if not self:usedCellFromIndex(k) then
        self:updateCellAtIndex(k)
      end
    end
  end
  
  return handler
end

function tbv:getUsedList()
  local list = {}
  local cnt = self:numberOfCells()
  if cnt <= 0 then
    return list
  end
  local offset = self:getContentOffset()
  local rect = CCRectMake(self.dragList.left - offset.x, self.dragList.bottom - offset.y, self.dragList.width, self.dragList.height)
  local str = ""
  for i = 1, cnt do
    local cellPos = self.cellsPositions[i]
    local size = self:cellSizeFromIndex(i)
    local cellRect = CCRectMake(cellPos.x - self.offset[1], cellPos.y - self.offset[2], size.width, size.height)
    if Tableview.Debug and (i == 1 or i == 4) then
      ed.drawTestRect(cellRect, self.dragList.listLayer)
    end
    if rect:intersectsRect(cellRect) then
      list[#list + 1] = i
      if Tableview.Debug then
        str = str .. "," .. tostring(i)
      end
    end
  end
  if Tableview.Debug then
    print("===========list idx:", str)
  end
  return list
end

function tbv:updateCellAtIndex(idx)
  local cell = self:usedCellFromIndex(idx)
  if cell then
    self:moveCellOutOfSight(cell)
  end
  local cell = self:updateCell(idx)
  self:setIndexForCell(idx, cell)
  self:addCellIfNecessary(cell)
end

function tbv:updateCell(idx)
  if #self.cellsFreed > 0 then
    local cell = self.cellsFreed[1]
    table.remove(self.cellsFreed, 1)
    self:syncCell(cell, idx)
    return cell
  else
    return self:createCell(idx)
  end
end

function tbv:createCell(idx)
  local node, data = self.delegate.createCell(idx)
  self:resetNode(node)
  local cell = {
    node = node,
    data = data,
    idx = idx,
    added = false
  }
  return cell
end

function tbv:syncCell(cell, idx)
  local node, data = self.delegate.createCell(idx)
  self:resetNode(node)
  cell.node = node
  cell.data = data
  cell.idx = idx
  cell.added = false
end

function tbv:addCellIfNecessary(cell)
  if not cell.added then
    self.dragList:addItem(cell.node)
    cell.added = true
  end
  table.insert(self.cellsUsed, cell)
end

function tbv:setIndexForCell(idx, cell)
  local node = cell.node
  self:resetNode(node)
  local offset = self:offsetFromIndex(idx)
  offset = offset or ccp(0, 0)
  node:setPosition(offset)
  cell.idx = idx
end

function tbv:offsetFromIndex(idx)
  return self.cellsPositions[idx]
end

function tbv:getListLayerY()
  return self.dragList.listLayer:getPositionY()
end

function tbv:setContentOffset()
  local cnt = self:numberOfCells()
  if cnt <= 0 then
    return
  end
  local dglst = self.dragList
  local ct = dglst.listLayer
  local pos = self.cellsPositions
  self:resetNode(ct)
  local x = dglst.left
  if self.direction == HORIZONTAL then
    cnt = math.min(cnt, self.colNum)
  end
  local size = self:cellSizeFromIndex(cnt)
  local padding = self.padding
  if self.direction == VERTICAL then
    local height = pos[cnt].y * -1 + padding.height + self.offset[2]
    dglst:initListHeight(height)
    local y = dglst.top
    dglst:initPosition(ccp(x, y))
  else
    local width = pos[cnt].x + size.width + padding.width + self.offset[1]
    dglst:initListWidth(width)
    local y = dglst.top
    dglst:initPosition(ccp(x, y))
  end
  if self.dragMode == TOP2BUTTOM then
  elseif self.dragMode == BUTTOM2TOP then
    local y = dglst.bottom + pos[cnt].y * -1
    ct:setPosition(ccp(x, y))
  elseif self.dragMode == LEFT2RIGHT then
  elseif self.dragMode == RIGHT2LEFT then
    local width = pos[cnt].x + size.width
    local y = dglst.top - size.height
    x = dglst.right - width
    ct:setPosition(ccp(x, y))
  else
    EDDebug(self.dragMode .. " is error !!! ")
  end
end

function tbv:getContentOffset()
  local ct = self.dragList.listLayer
  local x, y = ct:getPosition()
  return ccp(x, y)
end

function tbv:moveCellOutOfSight(cell)
  local idx = 0
  for k, cl in ipairs(self.cellsUsed) do
    if cl.idx == cell.idx then
      idx = k
      cl.node:removeFromParentAndCleanup(true)
      break
    end
  end
  table.remove(self.cellsUsed, idx)
  table.insert(self.cellsFreed, cell)
end

function tbv:usedCellFromIndex(idx)
  local lt = self.cellsUsed or {}
  for _, cell in ipairs(lt) do
    if cell.idx == idx then
      return cell
    end
  end
  return nil
end

function tbv:doPressIn(cell, x, y)
  if self.delegate.doPressIn then
    self.delegate.doPressIn(cell, x, y)
  end
end

function tbv:doPressInList()
  local function handler(x, y)
    for k, cell in ipairs(self.cellsUsed) do
      local node = cell.node
      
      local rect = ed.getNodeSize(node, true)
      if rect then
        rect.origin.x = rect.origin.x - self.offset[1]
        rect.origin.y = rect.origin.y - self.offset[2]
        if rect:containsPoint(ccp(x, y)) then
          self:doPressIn(cell, x, y)
          return k, cell.idx
        end
      end
      if node.bg then
        local rect = ed.getNodeSize(node.bg, true)
        if rect then
          rect.origin.x = rect.origin.x - self.offset[1]
          rect.origin.y = rect.origin.y - self.offset[2]
          if rect:containsPoint(ccp(x, y)) then
            self:doPressIn(cell, x, y)
            return k, cell.idx
          end
        end
      end
    end
    return false
  end
  
  return handler
end

function tbv:doClickIn(cell, x, y)
  if self.delegate.doClickIn then
    self.delegate.doClickIn(cell, x, y)
  end
end

function tbv:doClickInList()
  local function handler(x, y, k, i)
    if not i then
      return
    end
    local cell = self.cellsUsed[k]
    if cell then
      self:doClickIn(cell, x, y)
    end
  end
  
  return handler
end

function tbv:getUsedCell()
  return self.cellsUsed
end

function tbv:cancelClickIn(cell, x, y)
  if self.delegate.cancelClickIn then
    self.delegate.cancelClickIn(cell, x, y)
  end
end

function tbv:cancelClickInList()
  local function handler(x, y, i)
    if not i then
      return
    end
    local cell = self.cellsUsed[i]
    if cell then
      self:cancelClickIn(cell, x, y)
    end
  end
  
  return handler
end

function tbv:cancelPressIn(cell)
  if self.delegate.cancelPressIn then
    self.delegate.cancelPressIn(cell)
  end
end

function tbv:cancelPressInList()
  local function handler(x, y, i)
    if not i then
      return
    end
    local cell = self.cellsUsed[i]
    if cell then
      self:cancelPressIn(cell)
    end
  end
  
  return handler
end

function tbv:stopAllActions()
  self.dragList:stopAllActions()
end

function tbv:getDragList()
  return self.dragList
end

function tbv:makeItemHorizontalCenterByIndex(index)
  local cellPos = self:offsetFromIndex(index)
  if not cellPos then
    return
  end
  local cellSize = self:cellSizeFromIndex(index)
  local itemY = cellPos.y
  local itemHei = cellSize.height
  local draglist = self.dragList
  local draglistHei = draglist.height
  local draglistListHei = draglist.listHeight
  local draglistOriY = draglist.oriPosY
  if draglistHei < draglistListHei then
    local cy = (draglistHei - itemHei) / 2
    local newListY = draglistOriY
    if itemY < cy - draglistOriY then
      newListY = cy - itemY
    end
    newListY = math.min(newListY, draglistListHei - draglistHei + draglistOriY)
    draglist.listLayer:setPositionY(newListY)
    local handler = self:doScroll()
    handler()
  end
end

function tbv:getListPos()
  return self.dragList:getListPos()
end

function tbv:setListPos(pos)
  self.dragList:setListPos(pos)
  local handler = self:doScroll()
  handler()
end

function tbv:getListHeight()
  return self.dragList:getListHeight()
end
