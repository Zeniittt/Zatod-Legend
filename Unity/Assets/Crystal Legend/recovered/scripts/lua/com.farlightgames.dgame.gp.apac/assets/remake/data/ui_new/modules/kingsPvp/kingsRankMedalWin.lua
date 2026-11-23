local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsRankMedalWin = class
ed.UITool.registViewOpenFunc("kingsRankMedalWin", function(param)
  ed.ui.kingsRankMedalWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("kingsRankMedalWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self:initUI()
  self:addTouchEvent()
  self:addEventListen()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.kingsRankMedalWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDragList()
  self:refreshDragList()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4666403), 1)
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list)
end

function class:refreshDragList()
  self.dragList:clearList()
  local panelSize = self.ui.panel_list:getContentSize()
  local totalWidth = 0
  for id, gradeCfg in ipairs(ed.getDataTable("KingsGrade")) do
    local medalItem, ui = self:createMedalItem(gradeCfg)
    local itemSize = medalItem:getContentSize()
    self.dragList:addItem(medalItem)
    totalWidth = totalWidth - 15
    medalItem:setPosition(ccp(totalWidth + itemSize.width / 2, panelSize.height / 2))
    totalWidth = totalWidth + itemSize.width
  end
  self.dragList:initListWidth(totalWidth)
end

function class:createMedalItem(gradeCfg)
  local container, ui = ed.editorui(ed.uieditor.kingsRankMedalItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelString(ui.label_name, gradeCfg.Name)
  local gradeId = gradeCfg.ID
  local nextGradeCfg = ed.getDataTable("KingsGrade")[gradeId + 1]
  local score
  if nextGradeCfg then
    score = string.format("%s-%s", gradeCfg.Score, nextGradeCfg.Score - 1)
  else
    score = string.format(T("%s\229\143\138\228\187\165\228\184\138"), gradeCfg.Score)
  end
  ed.setLabelString(ui.label_score, score)
  ed.setTexture(ui.image_bg, string.format("UI/alpha/1080P/newkingspvp/main/rank_%s_bg.png", gradeCfg["Bg Color"]))
  ed.setTexture(ui.image_rank_icon, gradeCfg.Icon, true)
  return container, ui
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
end

function class:addEventListen()
end
