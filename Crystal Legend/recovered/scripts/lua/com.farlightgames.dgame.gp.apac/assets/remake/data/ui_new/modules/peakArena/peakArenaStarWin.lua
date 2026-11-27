local base = ed.ui.popwindow
local peakArenaStarWin = newclass(base.mt)
ed.ui.peakArenaStarWin = peakArenaStarWin

function peakArenaStarWin:initData()
  self.tabIndex = 1
  self.seasonBuffs = ed.PeakArenaManager.seasonBuffs
end

function peakArenaStarWin:initUI(param)
  ed.editorui(ed.uieditor.TopArenaStarWin, {
    container = self.container,
    ui = self.ui
  })
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\229\134\179\230\150\151\228\185\139\230\152\159"),
    fontSize = 19,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16770963),
    strokeSize = 1,
    strokeStartColor = ed.toccc3(9515008),
    strokeEndColor = ed.toccc3(9515008)
  })
  ed.UITool.replaceUINew(self.ui, "title", titleLabel.node)
  ed.setLabelStroke(self.ui.Label_4103, ed.toccc3(2565412), 1)
  self.draglist = ed.UITool.createDraglist(self.ui.Panel_4106, {})
  self:refreshSummaryPanel()
  if #self.seasonBuffs == 1 then
    self.ui.btn_next:setVisible(false)
    self.ui.label_next:setVisible(false)
  end
end

function peakArenaStarWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_cur", function()
    if self.tabIndex == 1 then
      return
    end
    self.tabIndex = 1
    ed.setLabelColor(self.ui.label_cur, ccc3(67, 57, 52))
    ed.setLabelStroke(self.ui.label_cur, ccc3(255, 252, 231), 1)
    ed.setLabelColor(self.ui.label_next, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.label_next, ccc3(56, 38, 34), 1)
    self.ui.btn_cur_selected:setVisible(true)
    self.ui.btn_next_selected:setVisible(false)
    self:refreshSummaryPanel()
  end)
  ed.UITool.registerBtn(self, "btn_next", function()
    if self.tabIndex == 2 then
      return
    end
    self.tabIndex = 2
    ed.setLabelColor(self.ui.label_next, ccc3(67, 57, 52))
    ed.setLabelStroke(self.ui.label_next, ccc3(255, 252, 231), 1)
    ed.setLabelColor(self.ui.label_cur, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.label_cur, ccc3(56, 38, 34), 1)
    self.ui.btn_next_selected:setVisible(true)
    self.ui.btn_cur_selected:setVisible(false)
    self:refreshSummaryPanel()
  end)
end

function peakArenaStarWin:registerEvents()
end

function peakArenaStarWin:refreshSummaryPanel()
  local skillInfo, endTime
  if self.tabIndex == 1 then
    skillInfo = ed.PeakArenaManager:getSeasonBuff((self.seasonBuffs[1] or {})._key)
    endTime = (self.seasonBuffs[1] or {})._end_time
  else
    skillInfo = ed.PeakArenaManager:getSeasonBuff((self.seasonBuffs[2] or {})._key)
    endTime = (self.seasonBuffs[2] or {})._end_time
  end
  if not skillInfo then
    return
  end
  local formatStr = string.format("<lable color=ccc3(255,209,130) strokeColor=ccc3(110,32,20) strokeSize=1>%s:</lable>%s", skillInfo["Buff Name"] or "", skillInfo["Buff Description"] or "")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = formatStr,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(7221268),
    strokeSize = 1,
    fontSize = 19,
    maxWidth = 630
  })
  ed.UITool.replaceUINew(self.ui, "label_skill", autoText.node)
  local size = self.ui.Panel_4106:getContentSize()
  local ox, oy = 50, size.height - 40
  local dx, dy = 90, 82
  local ncol = 7
  
  local function getPos(k)
    if #skillInfo["Unit ID"] <= ncol then
      local ox = size.width / 2 - #skillInfo["Unit ID"] / 2 * dx - 45
      return ccp(ox + k * dx, size.height / 2 + 5)
    else
      local row = math.floor((k - 1) / ncol)
      local col = (k - 1) % ncol
      return ccp(ox + col * dx, oy - dy * row)
    end
  end
  
  self.draglist:clearList()
  for k, v in ipairs(skillInfo["Unit ID"] or {}) do
    local icon = ed.readhero.createIconByID(v).icon
    icon:setPosition(getPos(k))
    self.draglist:addItem(icon)
  end
  local timeStr = string.format(T("\230\156\172\230\156\159\229\137\169\228\189\153\230\151\182\233\151\180:<lable color=ccc3(112,255,84) strokeColor=ccc3(39,37,36) strokeSize=1>%s</lable>"), ed.time2dhms(endTime - ed.getServerTime()))
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = timeStr,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    fontSize = 19
  })
  ed.UITool.replaceUINew(self.ui, "Label_4523", autoText.node)
  self.ui.Label_4523:setPositionX(270)
  self.draglist:initListHeight(math.floor((#skillInfo["Unit ID"] - 1) / ncol + 1) * dy)
end

function peakArenaStarWin.create(param)
  local self = base.create("peakArenaStarWin")
  setmetatable(self, peakArenaStarWin.mt)
  self:initData()
  self:initUI(param)
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end
