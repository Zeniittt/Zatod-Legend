local layout = {}
local layoutType = {Percent = 1, Grid = 2}
local extraLeftMagin = 0
local extraRightMagin = 0
local extraTopMagin = 0
local extraBottomMagin = 0
local init = false
local safeMagin = {
  left = (60 + extraLeftMagin) / ed.display.scaleFactor,
  right = (60 + extraRightMagin) / ed.display.scaleFactor,
  top = (20 + extraTopMagin) / ed.display.scaleFactor,
  bottom = (20 + extraBottomMagin) / ed.display.scaleFactor
}
layout.safeMagin = safeMagin

function layout.fixMagin(magin)
  if not init then
    local notchHeight = ed.display.getNotchHeight()
    safeMagin.left = math.max(notchHeight / ed.display.scaleFactor, safeMagin.left)
    safeMagin.right = math.max(notchHeight / ed.display.scaleFactor, safeMagin.right)
    init = true
  end
  if magin.left then
    magin.left = math.max(magin.left, safeMagin.left)
  end
  if magin.right then
    magin.right = math.max(magin.right, safeMagin.right)
  end
  if magin.top then
    magin.top = math.max(magin.top, safeMagin.top)
  end
  if magin.bottom then
    magin.bottom = math.max(magin.bottom, safeMagin.bottom)
  end
end

function layout.setNodePosWithWorldPos(node, worldPos)
  local pos = worldPos
  local parent = node:getParent()
  if parent then
    pos = parent:convertToNodeSpace(worldPos)
  end
  node:setPosition(pos)
end

function layout.getScale(node, recursive)
  local scale = node:getScaleX()
  if not recursive then
    return scale, scale
  end
  local recursiveScale = scale
  local parent = node:getParent()
  while parent do
    recursiveScale = recursiveScale * parent:getScale()
    parent = parent:getParent()
  end
  return recursiveScale, scale
end

function layout.getScaleSize(node, recursive)
  local recursiveScale = layout.getScale(node, recursive)
  local size = node:getContentSize()
  size.width = recursiveScale * size.width
  size.height = recursiveScale * size.height
  return size
end

function layout.centerInParent(node, recursive)
  local parent = node:getParent()
  assert(parent ~= nil, "The parent of the node is not allowed to be nil!")
  local ps = layout.getScaleSize(parent, recursive)
  local ms = layout.getScaleSize(node, recursive)
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  node:setPosition(ps.width * 0.5 - ms.width * (0.5 - ap.x), ps.height * 0.5 - ms.height * (0.5 - ap.y))
end

function layout.centerYInParent(node, recursive)
  local parent = node:getParent()
  assert(parent ~= nil, "The parent of the node is not allowed to be nil!")
  local ps = layout.getScaleSize(parent, recursive)
  local ms = layout.getScaleSize(node, recursive)
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  node:setPositionY(ps.height * 0.5 - ms.height * (0.5 - ap.y))
end

function layout.centerXInParent(node, recursive)
  local parent = node:getParent()
  assert(parent ~= nil, "The parent of the node is not allowed to be nil!")
  local ps = layout.getScaleSize(parent, recursive)
  local ms = layout.getScaleSize(node, recursive)
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  node:setPositionX(ps.width * 0.5 - ms.width * (0.5 - ap.x))
end

function layout.centerInScreen(node, recursive)
  local ws = ed.display.winSize
  local ms = layout.getScaleSize(node, recursive)
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  local worldPos = ccp(ws.width * 0.5 - ms.width * (0.5 - ap.x), ws.height * 0.5 - ms.height * (0.5 - ap.y))
  layout.setNodePosWithWorldPos(node, worldPos)
end

function layout.fullScreen(bg, recursive)
  local ms = layout.getScaleSize(bg, recursive)
  local ws = ed.display.winSize
  local scale = math.max(ws.width / ms.width, ws.height / ms.height)
  bg:setScale(scale * bg:getScale())
end

function layout.fullInRect(bg, recursive, size)
  local ms = layout.getScaleSize(bg, recursive)
  local ws = size
  local scale = math.max(ws.width / ms.width, ws.height / ms.height)
  bg:setScale(scale * bg:getScale())
end

function layout.lazyAdaptBG(bg, recursive)
  layout.fullScreen(bg, recursive)
  layout.centerInScreen(bg, recursive)
end

function layout.adaptBG(bg, direction, recursive)
  local ms = layout.getScaleSize(bg, recursive)
  local ws = ed.display.winSize
  local scale = direction == "X" and ws.width / ms.width or ws.height / ms.height
  bg:setScale(scale * bg:getScale())
  layout.centerInScreen(bg, recursive)
end

function layout.setPercentPositionInParent(node, px, py)
  local parent = node:getParent()
  local x, y = 0, 0
  if parent then
    local ps = parent:getContentSize()
    x, y = ps.width * px, ps.height * py
  end
  self:setPosition(x, y)
end

function layout.layoutHalfFixedMagin(node, magin)
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  if magin.left then
    node:setPositionX(node:getPositionX() - newWid)
  elseif magin.right then
    node:setPositionX(node:getPositionX() + newWid)
  end
  if magin.top then
    node:setPositionY(node:getPositionY() + newHei)
  elseif magin.bottom then
    node:setPositionY(node:getPositionY() - newHei)
  end
end

function layout.layoutWithParentMagin(node, magin, ignoreContentSize)
  local parent = node:getParent()
  assert(parent ~= nil, "The parent of the node is not allowed to be nil!")
  local parentContentSize = parent:getContentSize()
  local fs = parentContentSize
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  local ms = ignoreContentSize and {width = 0, height = 0} or node:getContentSize()
  local x, y = node:getPosition()
  local pos = ccp(x, y)
  if magin.left then
    x = magin.left + ms.width * ap.x
  elseif magin.right then
    x = fs.width - magin.right - ms.width * (1 - ap.x)
  end
  if magin.top then
    y = fs.height - magin.top - ms.height * (1 - ap.y)
  elseif magin.bottom then
    y = magin.bottom + ms.height * ap.y
  end
  node:setPosition(ccp(x, y))
end

function layout.layoutWithMagin(node, magin, ignoreContentSize, notFix)
  local parent = node:getParent()
  assert(parent ~= nil, "The parent of the node is not allowed to be nil!")
  if not notFix then
    layout.fixMagin(magin)
  end
  local fs = ed.display.winSize
  local ds = ed.display.designSize
  local ms = ignoreContentSize and {width = 0, height = 0} or node:getContentSize()
  local pos = parent:convertToWorldSpace(ccp(node:getPosition()))
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  local x, y = pos.x, pos.y
  if magin.left and magin.right then
    x = pos.x / ds.width * fs.width
  elseif magin.left then
    x = magin.left + ms.width * ap.x
  elseif magin.right then
    x = fs.width - magin.right - ms.width * (1 - ap.x)
  end
  if magin.top and magin.bottom then
    y = pos.y / ds.height * fs.height
  elseif magin.top then
    y = fs.height - magin.top - ms.height * (1 - ap.y)
  elseif magin.bottom then
    y = magin.bottom + ms.height * ap.y
  end
  layout.setNodePosWithWorldPos(node, ccp(x, y))
end

local function layoutWithPercent(parentNode, size, originSize)
  local children = parentNode:getChildren()
  if not children then
    return
  end
  for i = 0, children:count() - 1 do
    local child = children:objectAtIndex(i)
    local x, y = child:getPosition()
    x = x / originSize.width * size.width
    y = y / originSize.height * size.height
    child:setPosition(x, y)
  end
end

local function layoutWithGrid(parentNode, size, gridSize)
  local children = parentNode:getChildren()
  if not children then
    return
  end
  local len = children:count()
  local col = math.min(len, math.floor(size.width / gridSize.width))
  local row = math.ceil(len / col)
  local offSetSize
  for i = 0, row - 1 do
    for j = 0, col - 1 do
      local idx = i * col + j
      if len <= idx then
        break
      end
      local child = children:objectAtIndex(idx)
      local x, y = gridSize.width * (j + 0.5), size.height - gridSize.height * (i + 0.5)
      child:setPosition(x, y)
    end
  end
end

function layout.layoutChildrenWithSize(parentNode, size, layoutType, layoutParameters)
  local originSize = parentNode:getContentSize()
  if size.width ~= originSize.width or size.height ~= originSize.height then
    parentNode:setContentSize(size)
  end
  if layoutType == ed.layoutType.Percent then
    layoutWithPercent(parentNode, size, originSize)
  elseif layoutType == ed.layoutType.Grid then
    layoutWithGrid(parentNode, size, layoutParameters.gridSize)
  end
end

function layout.relateLayout(referenceNode, node, magin, ignoreContentSize)
  if tolua.isnull(referenceNode) or tolua.isnull(node) then
    return
  end
  local pos = referenceNode:getParent():convertToWorldSpace(ccp(referenceNode:getPosition()))
  local ms = ignoreContentSize and {width = 0, height = 0} or layout.getScaleSize(node)
  local ap = node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or node:getAnchorPoint()
  if magin.left then
    pos.x = pos.x - magin.left - ms.width * ap.x
  elseif magin.right then
    pos.x = pos.x + magin.right + ms.width * (1 - ap.x)
  end
  if magin.top then
    pos.y = pos.y + magin.top + ms.height * (1 - ap.y)
  elseif magin.bottom then
    pos.y = pos.y - magin.bottom
  end
  local parent = node:getParent()
  if parent then
    pos = parent:convertToNodeSpace(pos)
  end
  node:setPosition(pos)
end

function layout.horizontalSortNode(nodeArr, spaceArr, offsetX, anchorX)
  if nil == anchorX then
    anchorX = 0.5
  end
  local totalWidth = 0
  local sortArr = {}
  local lastSpace = 0
  for i, v in ipairs(nodeArr) do
    if v:isVisible() then
      local config = {
        node = v,
        width = v:getContentSize().width,
        scale = math.abs(v:getScaleX()),
        space = spaceArr and spaceArr[i] or 0
      }
      table.insert(sortArr, config)
      totalWidth = totalWidth + lastSpace + config.width * config.scale
      lastSpace = config.space
    end
  end
  local posX = offsetX - totalWidth * anchorX
  for i, v in ipairs(sortArr) do
    local ap = v.node:isIgnoreAnchorPointForPosition() and {x = 0, y = 0} or v.node:getAnchorPoint()
    v.node:setPositionX(posX + v.width * v.scale * ap.x)
    posX = posX + v.width * v.scale + v.space
  end
  return totalWidth
end

ed.layout = layout
ed.layoutType = layoutType
