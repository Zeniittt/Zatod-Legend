local peakArenaUITool = {}
ed.ui.peakArenaUITool = peakArenaUITool

function peakArenaUITool.makeNodesCenterAtX(nodes, params)
  params = params or {}
  local node1 = nodes[1]
  local parent = node1:getParent()
  local pWid = parent:getContentSize().width
  local x = params.x or pWid / 2
  local gap = params.gap or 0
  local widAcc = 0
  for _, node in ipairs(nodes) do
    widAcc = widAcc + node:getContentSize().width * node:getScaleX()
  end
  widAcc = widAcc + math.max(#nodes - 1, 0) * gap
  local ox = x - widAcc / 2
  for _, node in ipairs(nodes) do
    local wid = node:getContentSize().width * node:getScaleX()
    node:setPositionX(ox + wid / 2)
    ox = ox + wid + gap
  end
end

function peakArenaUITool.limitNodeWidth(node, width)
  local wid = node:getContentSize().width
  if width < wid then
    node:setScale(width / wid)
  end
end

function peakArenaUITool.createHeadIconBySummary(summary)
  local param = {
    id = summary._avatar,
    level = summary._level,
    name = summary._name,
    vip = summary._vip > 0,
    scale = 0.8,
    lvoffset = {
      x = 0,
      y = 0,
      scale = 0.7
    }
  }
  return ed.getWholeHeadIcon(param)
end

function peakArenaUITool.createHideIcon()
  local icon = ed.createSprite("UI/alpha/1080P/toparena/toparena_invisible.png")
  return icon
end
