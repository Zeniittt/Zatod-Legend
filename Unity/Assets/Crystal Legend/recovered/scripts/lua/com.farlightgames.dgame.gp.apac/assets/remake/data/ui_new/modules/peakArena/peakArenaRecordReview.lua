local base = ed.ui.popwindow
local PeakArenaRecordReview = newclass(base.mt)
ed.ui.PeakArenaRecordReview = PeakArenaRecordReview
ed.UITool.registViewOpenFunc("PeakArenaRecordReview", function()
  ListenEventOnce("PeakArenaHistoryBoard", function(history)
    if not ed.getPopWindow() then
      PeakArenaRecordReview.create(history):popWindow()
    end
  end)
  ed.PeakArenaNetwork:sendHistoryboard()
end)

function PeakArenaRecordReview.create(history)
  local self = base.create("PeakArenaRecordReview", {notBlurBg = true})
  setmetatable(self, PeakArenaRecordReview.mt)
  self:init(history)
  return self
end

function PeakArenaRecordReview:init(history)
  self.historyList = history or {}
  self.mgr = ed.PeakArenaManager
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
end

function PeakArenaRecordReview:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRecordReview)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:createDraglist()
  self:refreshDragList()
  self.ui.title_light:setContentSize(CCSizeMake(self.ui.label_title:getContentSize().width + 33.5, self.ui.title_light:getContentSize().height))
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 75, top = 17})
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
end

function PeakArenaRecordReview:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(13794820), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
end

function PeakArenaRecordReview:createDraglist()
  local layerListSize = self.ui.layer_list:getContentSize()
  local info = {
    cliprect = CCRectMake(-ed.display.halfFixedWidth, 0, layerListSize.width + 2 * ed.display.halfFixedWidth, layerListSize.height),
    container = self.ui.layer_list,
    noshade = true,
    priority = -300
  }
  self.draglist = ed.draglist.create(info)
end

function PeakArenaRecordReview:refreshDragList()
  self.itemList = {}
  local totalWidth = 0
  local width = 0
  local gapX = -80
  for index, historyData in ipairs(self.historyList) do
    local item, ui = self:createRecordItem(historyData)
    width = item:getContentSize().width
    item:setPosition(ccp(totalWidth - ed.display.halfFixedWidth, 0))
    self.draglist:addItem(item)
    table.insert(self.itemList, ui)
    totalWidth = totalWidth + width + gapX
  end
  self.draglist:initListWidth(totalWidth)
  if totalWidth < self.draglist.width then
    self.ui.layer_list:setPositionX((self.draglist.width - totalWidth) / 2 - 40)
  end
end

function PeakArenaRecordReview:createRecordItem(historyData)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaReview)
  container = ui.image_bg
  container:ignoreAnchorPointForPosition(true)
  container:setAnchorPoint(ccp(0.5, 0.5))
  ed.setLabelStroke(ui.label_1, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_3, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_4, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_medal, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_zone_rank, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_server_rank, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_season_title, ed.toccc3(13326625), 1.5)
  ed.setLabelFontName(ui.label_season_title, ed.fontBold)
  local seasonID = historyData._season or 1
  local seasonName = ed.getDataTable("PeakArenaSeason")[seasonID]["Season Name"]
  local season = ed.getNumberNode({text = seasonName, folder = "season"}).node
  ui.panel_season:addChild(season)
  ed.layout.centerInParent(season)
  local fixGradeGroupId = ed.getDataTable("PeakArenaSeason")[seasonID]["Fix Grade Group"]
  local finalGrade = historyData._final_grade
  local gradeIconPath, gradeNamePath
  if 0 < fixGradeGroupId then
    local fixGradeInfo = ed.getDataTable("PeakArenaGradeinfo")[fixGradeGroupId]
    gradeIconPath = string.format("UI/alpha/1080P/toparena/rank/%s.png", fixGradeInfo[finalGrade]["Grade Symbol Icon"])
    gradeNamePath = string.format("UI/alpha/1080P/toparena/rank/%s.png", fixGradeInfo[finalGrade]["Grade Icon"])
  else
    gradeIconPath = self.mgr:getGradeIconRes(finalGrade)
    gradeNamePath = self.mgr:getGradeTextRes(finalGrade)
  end
  ed.setTexture(ui.image_grade_icon, gradeIconPath)
  ed.setTexture(ui.image_grade_name, gradeNamePath)
  local season = ed.getNumberNode({
    text = historyData._final_score or 0,
    folder = "peak_score"
  }).node
  ui.panel_score:addChild(season)
  season:setScale(0.65)
  ed.layout.centerYInParent(season)
  season:setPositionX(season:getContentSize().width * 0.65 / 2)
  ed.setLabelString(ui.label_medal, historyData._zone)
  if historyData._zone_rank and 0 < historyData._zone_rank then
    ui.image_zone_rank_no:setVisible(true)
    ui.label_zone_rank:setVisible(false)
    local rank = ed.getNumberNode({
      text = historyData._zone_rank,
      folder = "peak_rank"
    }).node
    ui.image_zone_rank_no:addChild(rank)
    rank:setPositionX(rank:getContentSize().width / 2 + ui.image_zone_rank_no:getContentSize().width)
    rank:setPositionY(rank:getContentSize().height / 2)
  else
    ui.image_zone_rank_no:setVisible(false)
    ui.label_zone_rank:setVisible(true)
  end
  if historyData._score_rank and 0 < historyData._score_rank then
    ui.image_bg_server_rank:setVisible(true)
    ui.image_server_rank_no:setVisible(true)
    ui.label_server_rank:setVisible(false)
    local rank = ed.getNumberNode({
      text = historyData._score_rank,
      folder = "peak_rank"
    }).node
    ui.image_server_rank_no:addChild(rank)
    rank:setPositionX(rank:getContentSize().width / 2 + ui.image_server_rank_no:getContentSize().width)
    rank:setPositionY(rank:getContentSize().height / 2)
  else
    ui.image_bg_server_rank:setVisible(false)
    ui.image_server_rank_no:setVisible(false)
    ui.label_server_rank:setVisible(true)
  end
  for i = 1, 4 do
    ui["label_" .. i]:limitWidthByScale(110)
  end
  ed.layout.horizontalSortNode({
    ui.label_1,
    ui.panel_score
  }, {9, 0}, ui.label_1:getPositionX(), 0)
  ed.layout.horizontalSortNode({
    ui.label_2,
    ui.label_medal
  }, {9, 0}, ui.label_2:getPositionX(), 0)
  ed.layout.horizontalSortNode({
    ui.label_3,
    ui.label_zone_rank,
    ui.image_zone_rank_no
  }, {
    9,
    9,
    0
  }, ui.label_3:getPositionX(), 0)
  ed.layout.horizontalSortNode({
    ui.label_4,
    ui.label_server_rank,
    ui.image_server_rank_no
  }, {
    9,
    9,
    0
  }, ui.label_4:getPositionX(), 0)
  return container, ui
end

function PeakArenaRecordReview:registerTouchHandlers()
  self:btRegisterButtonClick({
    button = self.ui.btn_back,
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end

function PeakArenaRecordReview:registerEvents()
end
