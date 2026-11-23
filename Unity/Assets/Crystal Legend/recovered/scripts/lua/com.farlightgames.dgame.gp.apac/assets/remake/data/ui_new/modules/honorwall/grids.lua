Grids = {}
Grids.__index = Grids

function Grids.create(params)
  local grids = {}
  setmetatable(grids, Grids)
  grids:initData(params)
  grids:draw()
  return grids
end

function Grids:initData(params)
  self.row = params.row
  self.column = params.column
  self.gap = params.gap
  self.gridWidth = params.gridWidth
  self.gridHeight = params.gridHeight
  self.gridRes = params.gridRes
  self.width = (self.gridWidth + self.gap) * self.column - self.gap
  self.height = (self.gridHeight + self.gap) * self.row - self.gap
  self.gridState = {}
  for i = 1, self.row do
    for j = 1, self.column do
      self.gridState[i] = self.gridState[i] or {}
      self.gridState[i][j] = false
    end
  end
end

function Grids:draw()
  local node = CCNode:create()
  for i = 1, self.row do
    for j = 1, self.column do
      local gridBg = ed.createSprite(self.gridRes)
      gridBg:setScale(self.gridWidth / gridBg:getContentSize().width)
      gridBg:setAnchorPoint(ccp(0, 0))
      gridBg:setPosition(ccp((j - 1) * (self.gridWidth + self.gap), (i - 1) * (self.gridHeight + self.gap)))
      node:addChild(gridBg)
    end
  end
  self.node = node
end

function Grids:getNode()
  return self.node
end

function Grids:getContentSize()
  return CCSizeMake(self.width, self.height)
end

function Grids:getContentRect()
  return CCRectMake(0, 0, self.column, self.row)
end

function Grids:getGridSize()
  return CCSizeMake(self.gridWidth, self.gridHeight)
end

function Grids:clickPos(pos, width, height)
end

function Grids:getGridIndex(pos)
  local idxRow, idxColumn
  for i = 1, self.row do
    if i * self.gridHeight > pos.y then
      idxRow = i
      break
    end
  end
  for j = 1, self.column do
    if j * self.gridWidth > pos.x then
      idxColumn = j
      break
    end
  end
  print("getGridIndex", idxRow, idxColumn)
  return idxRow, idxColumn
end

function Grids:getGridLines(i, j)
  return self.columnLine[(i - 1) * (self.column + 1) + j], self.columnLine[(i - 1) * (self.column + 1) + j + 1], self.rowLine[(i - 1) * self.column + j], self.rowLine[i * self.column + j]
end

function Grids:findPlace(width, height)
  for i = self.row - height, 0, -1 do
    for j = 0, self.column - width do
      local rect = CCRectMake(j, i, width, height)
      if not self:checkCollision(rect) then
        return rect
      end
    end
  end
  return nil
end

function Grids:placeRect(rect)
  local origin = rect.origin
  local size = rect.size
  for i = origin.y + 1, origin.y + size.height do
    for j = origin.x + 1, origin.x + size.width do
      self.gridState[i][j] = true
    end
  end
end

function Grids:clearRect(rect)
  local origin = rect.origin
  local size = rect.size
  for i = origin.y + 1, origin.y + size.height do
    for j = origin.x + 1, origin.x + size.width do
      self.gridState[i][j] = false
    end
  end
end

function Grids:checkCollision(rect, excludeRect)
  local contentRect = self:getContentRect()
  if rect:getMinX() < contentRect:getMinX() or rect:getMinY() < contentRect:getMinY() or rect:getMaxX() > contentRect:getMaxX() or rect:getMaxY() > contentRect:getMaxY() then
    return true
  end
  local origin = rect.origin
  local size = rect.size
  for i = origin.y + 1, origin.y + size.height do
    for j = origin.x + 1, origin.x + size.width do
      if self.gridState[i][j] then
        if excludeRect then
          local excludeOrigin = excludeRect.origin
          local excludeSize = excludeRect.size
          if j < excludeOrigin.x + 1 or j > excludeOrigin.x + excludeSize.width or i < excludeOrigin.y + 1 or i > excludeOrigin.y + excludeSize.height then
            return true
          end
        else
          return true
        end
      end
    end
  end
  return false
end

function Grids:printGridState()
  print("=========================grid state=========================")
  for i = self.row, 1, -1 do
    local str = ""
    for j = 1, self.column do
      if self.gridState[i][j] then
        str = str .. "1" .. "\t"
      else
        str = str .. "0" .. "\t"
      end
    end
    print(str)
  end
  print("========================= end =========================")
end
