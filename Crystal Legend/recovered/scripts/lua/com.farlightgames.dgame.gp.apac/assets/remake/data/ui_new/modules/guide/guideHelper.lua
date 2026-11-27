local guideHelper = {}
ed.guide.helper = guideHelper

local function getAreaWorldPos(area)
  return ed.ccpAdd(area.node and ed.getWorldPos(area.node) or ccp(0, 0), area.center)
end

ed.guide.helper.getAreaWorldPos = getAreaWorldPos

local function containInCircle(pos, circle)
  return ed.isPointInCircle(getAreaWorldPos(circle), circle.radius, pos.x, pos.y)
end

local function drawCircle(circle, parent)
  local drawNode = CCDrawNode:create()
  drawNode:drawCircle(getAreaWorldPos(circle), circle.radius, ccc4f(1, 0, 0, 0.5), 0.5, false)
  parent:addChild(drawNode)
end

local function containInRect(pos, rect)
  local halfWidth = rect.width / 2
  local halfHeight = rect.height / 2
  local rectPos = getAreaWorldPos(rect)
  local minX, minY = rectPos.x - halfWidth, rectPos.y - halfHeight
  local maxX, maxY = rectPos.x + halfWidth, rectPos.y + halfHeight
  return minX <= pos.x and maxX >= pos.x and minY <= pos.y and maxY >= pos.y
end

local function drawRect(rect, parent)
  local drawNode = CCDrawNode:create()
  local rectPos = getAreaWorldPos(rect)
  rectPos.x = rectPos.x - rect.width / 2
  drawNode:drawRect(rectPos, rect.width, rect.height, ccc4f(255, 0, 0, 255), 0.5, false)
  parent:addChild(drawNode)
end

function guideHelper.createCircleTouchArea(center, radius)
  return {
    type = "circle",
    radius = radius,
    center = center,
    containIn = containInCircle,
    debugDraw = drawCircle,
    active = true,
    node = nil
  }
end

function guideHelper.createRectTouchArea(center, width, height)
  return {
    type = "rect",
    width = width,
    height = height,
    center = center,
    containIn = containInRect,
    debugDraw = drawRect,
    active = true,
    node = nil
  }
end

function guideHelper.createNodeTouchArea(node)
  if not node then
    return nil
  end
  local size = ed.layout.getScaleSize(node, true)
  local area = ed.guide.helper.createRectTouchArea(ccp(0, 0), size.width - 1, size.height - 1)
  area.active = ed.checkVisible(node)
  area.node = node
  return area
end

function guideHelper.updateNodeTouchArea(area)
  local node = area.node
  if not tolua.isnull(node) then
    area.active = ed.checkVisible(node)
  else
    area.active = false
  end
end
