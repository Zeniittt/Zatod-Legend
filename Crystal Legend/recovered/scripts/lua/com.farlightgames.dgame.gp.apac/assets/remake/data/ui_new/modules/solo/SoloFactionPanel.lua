local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloFactionPanel = class

function class:initLabels()
  ed.setLabelStroke(self.ui.label_exp, ed.toccc3(2236188), 1)
end

function class:getFactionAutoText(id, level)
  local cardTag = ed.getDataTable("SoloCardTag")[id]
  local str = cardTag.Description or ""
  local tmpStr = str
  local args = {}
  
  local function insertTrueValue(paramName)
    if cardTag[paramName][level] then
      table.insert(args, cardTag[paramName][level])
    else
      table.insert(args, "0")
    end
    if level < cardTag["Max Star"] then
      table.insert(args, cardTag[paramName][level + 1])
    end
  end
  
  while true do
    local pos1, pos2 = string.find(tmpStr, "%%CardTag&.-%%")
    if pos1 == nil then
      break
    else
      local paramName = string.sub(tmpStr, pos1 + 9, pos2 - 1)
      insertTrueValue(paramName)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    end
  end
  if level < cardTag["Max Star"] then
    str = string.gsub(str, "%%CardTag&.-%%", "%%s(<lable color=headlineYellow>%%s</lable>)")
  else
    str = string.gsub(str, "%%CardTag&.-%%", "%%s")
  end
  if 0 < #args then
    str = string.format(str, unpack(args))
  end
  str = string.gsub(str, "#p#", "%%")
  return str
end

local TextConfig = {
  {
    StartColor = ed.toccc3(11385583),
    EndColor = ed.toccc3(15989247)
  },
  {
    StartColor = ed.toccc3(8621055),
    EndColor = ed.toccc3(15463935)
  },
  {
    StartColor = ed.toccc3(16736609),
    EndColor = ed.toccc3(16773101)
  },
  {
    StartColor = ed.toccc3(16751208),
    EndColor = ed.toccc3(16776936)
  },
  {
    StartColor = ed.toccc3(16768336),
    EndColor = ed.toccc3(16776689)
  },
  {
    StartColor = ed.toccc3(14510079),
    EndColor = ed.toccc3(16770551)
  },
  {
    StartColor = ed.toccc3(1572651),
    EndColor = ed.toccc3(14483425)
  },
  {
    StartColor = ed.toccc3(5169919),
    EndColor = ed.toccc3(14548990)
  },
  {
    StartColor = ed.toccc3(5169919),
    EndColor = ed.toccc3(14548990)
  },
  {
    StartColor = ed.toccc3(5169919),
    EndColor = ed.toccc3(14548990)
  },
  {
    StartColor = ed.toccc3(5169919),
    EndColor = ed.toccc3(14548990)
  }
}

function class:refreshPanel(data)
  self.draglist:clearList()
  ed.setTexture(self.ui.icon, data.tbData["Tag Icon"])
  local gradientLabel = ed.ui.gradientLabel.create({
    text = data.tbData.Name,
    fontSize = 28,
    fontName = ed.fontBold,
    startColor = TextConfig[data.tbData.ID].StartColor,
    endColor = TextConfig[data.tbData.ID].EndColor,
    strokeSize = 2,
    strokeColor = ed.toccc3(2504206)
  })
  local lable_node = gradientLabel.node
  lable_node:setPosition(self.ui.Label_1554:getPosition())
  self.ui.bg:addChild(lable_node)
  self.ui.Label_1554:removeFromParentAndCleanup(true)
  self.ui.Label_1554 = lable_node
  local expBar = CCProgressTimer:create(self.ui.bar)
  expBar:setType(kCCProgressTimerTypeBar)
  expBar:setMidpoint(ccp(0, 0.5))
  expBar:setBarChangeRate(ccp(1, 0))
  self.ui.bg_bar:addChild(expBar)
  self.ui.bar:setVisible(false)
  ed.layout.centerInParent(expBar)
  self.expBar = expBar
  if data.level < #data.tbData["Star Count"] then
    ed.setString(self.ui.label_exp, string.format("%d/%d", data.exp, data.tbData["Star Count"][data.level + 1]))
    self.expBar:setPercentage(data.exp / data.tbData["Star Count"][data.level + 1] * 100)
  else
    ed.setString(self.ui.label_exp, string.format("%d/%d", data.exp, 40))
    self.expBar:setPercentage(100)
    for i = 1, 4 do
      ed.setTexture(self.ui["star" .. i], "UI/alpha/1080P/chesscard/big_star3.png")
    end
  end
  for i = 1, 4 do
    self.ui["star" .. i]:setVisible(i <= data.level)
  end
  local autoStr = self:getFactionAutoText(data.id, data.level)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 15,
    maxWidth = 380,
    strokeColor = ed.toccc3(1315346),
    strokeSize = 1,
    color = ccc3(255, 234, 197)
  })
  ed.UITool.replaceUINew(self.ui, "Label_1555", autoText.node)
  local dx, dy = 170, 232
  
  local function getPos(i)
    local row = math.ceil(i / 4)
    local col = (i - 1) % 4
    return ccp(80 + col * dx, 475 - dy * row)
  end
  
  for k, v in ipairs(data.cardList) do
    local container, ui = ed.ui.SoloUITool.createCardItem(v.id, v.level, false)
    ui.bg:setScale(0.8)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglist:initListHeight(math.ceil(#data.cardList / 4) * dy)
end

function class:initPanel()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {})
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloFactionPanel, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:initPanel()
end

function class.create(data)
  local self = base.create("SoloFactionPanel", {
    notBlurBg = true,
    swallow = true,
    layer_opacity = 90
  })
  setmetatable(self, class.mt)
  self:initUI()
  self:refreshPanel(data)
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end,
    force = true
  })
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end
