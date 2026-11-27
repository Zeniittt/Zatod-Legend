local base = ed.ui.popwindow
local CupArenaSeasonHistoryWin = newclass(base.mt)
ed.CupArenaSeasonHistoryWin = CupArenaSeasonHistoryWin

function CupArenaSeasonHistoryWin.create(data)
  local self = base.create("CupArenaSeasonHistoryWin")
  setmetatable(self, CupArenaSeasonHistoryWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function CupArenaSeasonHistoryWin:initData(data)
  self.records = data._records or {}
end

function CupArenaSeasonHistoryWin:initUI()
  ed.editorui(ed.uieditor.CupArenaSeasonHistoryWin, {
    container = self.container,
    ui = self.ui
  })
  ed.UITool.createSceneTitle(T("\230\136\152\231\187\169"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  self:adaptUI()
  self.ui.btn_left:setOpacity(0)
  ed.readaction.playBlinkAction({
    node = self.ui.btn_left,
    duration = 1
  })
  self.ui.btn_right:setOpacity(0)
  ed.readaction.playBlinkAction({
    node = self.ui.btn_right,
    duration = 1
  })
  self:initDraglist()
end

function CupArenaSeasonHistoryWin:adaptUI()
  local fixX = ed.display.halfFixedWidth * 2
  local fixY = ed.display.halfFixedHeight * 2
  local addWidth = fixX * 0.5
  local addHeight = fixY * 0.5
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 50, top = 18})
  ed.layout.layoutWithMagin(self.ui.btn_left, {left = 30})
  ed.layout.layoutWithMagin(self.ui.btn_right, {right = 30})
  local startX = self.ui.btn_left:getPositionX() + self.ui.btn_left:getContentSize().width * 0.5
  local endX = self.ui.btn_right:getPositionX() - self.ui.btn_right:getContentSize().width * 0.5
  self.ui.panel_history:setPositionX(startX)
  local historyPanelSize = self.ui.panel_history:getContentSize()
  historyPanelSize.width = endX - startX
  self.ui.panel_history:setContentSize(historyPanelSize)
end

function CupArenaSeasonHistoryWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy({skipAnim = true})
  end, {normalScale = 0.8, pressScale = 0.76})
end

function CupArenaSeasonHistoryWin:registerEvents()
end

function CupArenaSeasonHistoryWin:createHistoryItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.CupArenaSeasonHistoryItem)
  container:setContentSize(ui.bg:getContentSize())
  ed.setLabelStroke(ui.label_zone_des, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_zone_info, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_camp_des, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_camp_info, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_score_des, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_score_val, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_medal_des, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_medal_val, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_rank_des, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_season_title, ed.toccc3(13326625), 1.5)
  ed.setLabelFontName(ui.label_season_title, ed.fontBold)
  ed.setLabelString(ui.label_zone_info, T("\231\172\172%d\232\181\155\229\140\186", data._zone_id))
  local campTableItem = ed.getDataTable("CupArenaCamp")[data._camp_id]
  ed.setLabelString(ui.label_camp_info, campTableItem["Camp Name"])
  ed.setLabelString(ui.label_score_val, data._score)
  ed.setLabelString(ui.label_medal_val, data._medal)
  ed.layout.horizontalSortNode({
    ui.label_medal_val,
    ui.img_medal
  }, {2, 0}, ui.label_medal_val:getPositionX(), 0)
  if nil ~= data._final_rank and 0 < data._final_rank then
    local rankNameLabel = ed.ui.gradientLabel.create({
      text = ed.CupArenaUITool.getRankName(data._final_rank),
      fontSize = 15,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776152),
      endColor = ed.toccc3(16771982),
      strokeSize = 1,
      strokeColor = ed.toccc3(11548958)
    }).node
    ui.bg_rank:addChild(rankNameLabel)
    rankNameLabel:setPosition(ui.label_medal_val:getPositionX() + rankNameLabel:getContentSize().width * 0.5, ui.label_medal_val:getPositionY())
    ui.bg_rank:setVisible(true)
  else
    ui.bg_rank:setVisible(false)
  end
  local seasonName = ed.getDataTable("CupArenaSeason")[data._season or 1]["Season Name"]
  local seasonNode = ed.getNumberNode({text = seasonName, folder = "season"}).node
  ui.panel_season:addChild(seasonNode)
  ed.layout.centerInParent(seasonNode)
  local gradeInfo = ed.CupArenaManager:getGradeInfoByScore(data._score)
  ed.setTexture(ui.img_grade_icon, gradeInfo.iconRes)
  ed.setTexture(ui.img_grade_name, gradeInfo.nameIconRes)
  return container, ui
end

function CupArenaSeasonHistoryWin:getPos(i, totalNum)
  local size = self.ui.panel_history:getContentSize()
  local itemWidth = 330
  local itemSpace = 0
  local offsetX = 20
  local ox = 0
  local oy = size.height * 0.5
  if 1 == totalNum then
    ox = size.width * 0.5 - itemWidth * 0.5
  elseif 2 == totalNum then
    itemSpace = 40
    ox = size.width * 0.5 - itemWidth - itemSpace * 0.5
  else
    itemSpace = 7
    ox = 4
  end
  local dx = (i - 0.5) * itemWidth + (i - 1) * itemSpace + offsetX
  return ccp(ox + dx, oy)
end

function CupArenaSeasonHistoryWin:getWidth(totalNum)
  local itemWidth = 330
  local itemSpace = 0
  local addWidth = 0
  if 1 == totalNum then
    itemSpace = 0
  elseif 2 == totalNum then
    itemSpace = 40
  else
    itemSpace = 7
    addWidth = 4
  end
  local totalWidth = (itemWidth + itemSpace) * totalNum - itemSpace + addWidth
  local size = self.ui.panel_history:getContentSize()
  return math.max(totalWidth, size.width)
end

function CupArenaSeasonHistoryWin:initDraglist()
  self.historyDraglist = ed.UITool.createDraglist(self.ui.panel_history, {priority = -300})
  local recordNum = #self.records
  for i, v in ipairs(self.records) do
    local itemContainer, itemUI = self:createHistoryItem(i, v)
    self.historyDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i, recordNum))
  end
  self.historyDraglist:initListWidth(self:getWidth(recordNum))
  self:refreshArrowVisible()
end

function CupArenaSeasonHistoryWin:refreshArrowVisible()
  print(self.historyDraglist.listWidth, self.historyDraglist.width)
  if self.historyDraglist.listWidth <= self.historyDraglist.width then
    self.ui.btn_left:setVisible(false)
    self.ui.btn_right:setVisible(false)
  else
  end
end
