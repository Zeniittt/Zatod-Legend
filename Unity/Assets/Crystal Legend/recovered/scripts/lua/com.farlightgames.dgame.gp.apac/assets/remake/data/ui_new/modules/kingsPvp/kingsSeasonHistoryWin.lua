local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsSeasonHistoryWin = class
ed.UITool.registViewOpenFunc("kingsSeasonHistoryWin", function(param)
  ed.ui.kingsSeasonHistoryWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("kingsSeasonHistoryWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self:initUI()
  self:addTouchEvent()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.kingsSeasonHistoryWindow)
  self.container:addChild(container)
  self.ui = ui
  ed.UITool.createSceneTitle(T("\230\136\152\231\187\169"), self.ui.image_title_bg, {
    position = ccp(20, 20)
  })
  self:adaptUI()
  self:initDragList()
  self:refreshUI()
  local breathAction = CCSequence:create(ccArrayMake(CCFadeTo:create(1, 0), CCFadeTo:create(1, 255)))
  self.ui.image_arrow_left:runAction(CCRepeatForever:create(breathAction))
  local breathAction = CCSequence:create(ccArrayMake(CCFadeTo:create(1, 0), CCFadeTo:create(1, 255)))
  self.ui.image_arrow_right:runAction(CCRepeatForever:create(breathAction))
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_arrow_left, {left = 0}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_arrow_right, {right = 0}, false, true)
end

function class:refreshUI()
  self:refreshDragList()
  self:refreshArrow()
end

function class:initDragList()
  local layerListSize = self.ui.panel_list:getContentSize()
  local info = {
    cliprect = CCRectMake(-ed.display.halfFixedWidth, 0, layerListSize.width + 2 * ed.display.halfFixedWidth, layerListSize.height),
    container = self.ui.panel_list,
    noshade = true,
    priority = -300,
    doScroll = function()
      self:refreshArrow()
    end
  }
  self.dragList = ed.draglist.create(info)
end

function class:refreshArrow()
  local listX, listY = self.dragList:getListPos()
  local listWidth = self.dragList.listWidth
  if -20 < listX then
    self.ui.image_arrow_left:setVisible(false)
  else
    self.ui.image_arrow_left:setVisible(true)
  end
  if listX < self.ui.panel_list:getContentSize().width - listWidth + 20 then
    self.ui.image_arrow_right:setVisible(false)
  else
    self.ui.image_arrow_right:setVisible(true)
  end
end

function class:refreshDragList()
  local layerListSize = self.ui.panel_list:getContentSize()
  local totalWidth = 0
  local width = 0
  local gapX = 0
  self.historyList = {
    1,
    2,
    1,
    1,
    1
  }
  for index, historyData in ipairs(self.historyList) do
    local item, ui = self:createHistoryItem(historyData)
    width = item:getContentSize().width
    item:setPosition(ccp(totalWidth + width / 2 - ed.display.halfFixedWidth, layerListSize.height / 2 - 20))
    self.dragList:addItem(item)
    totalWidth = totalWidth + width + gapX
  end
  self.dragList:initListWidth(totalWidth)
  if totalWidth < self.dragList.width then
    self.ui.panel_list:setPositionX((self.dragList.width - totalWidth) / 2)
  end
end

function class:createHistoryItem()
  local container, ui = ed.editorui(ed.uieditor.kingsSeasonHistoryItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelFontName(ui.label_rank_name, ed.fontBold)
  ed.setLabelStroke(ui.label_season_title, ed.toccc3(13326625), 1.5)
  ed.setLabelFontName(ui.label_season_title, ed.fontBold)
  ed.setLabelStroke(ui.final_score_tips, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.match_count_tips, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.match_win_rate_tips, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.final_ranking_tips, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.match_count, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.match_win_rate, ed.toccc3(3087902), 1)
  local gradeName = "herald"
  local gradeCfg = ed.realarena.mgr:getGradeCfgByGradeName(gradeName)
  ed.setTexture(ui.image_rank_icon, gradeCfg.Icon, true)
  ed.setLabelString(ui.label_rank_name, gradeCfg.Name)
  local finalScore = ed.getNumberNode({text = 82345, folder = "peak_score"}).node
  ui.final_score_bg:addChild(finalScore)
  finalScore:setScale(0.65)
  ed.right2(finalScore, ui.final_score_tips, 10)
  ed.setLabelString(ui.match_count, 62345)
  ed.right2(ui.match_count, ui.match_count_tips, 10)
  ed.setLabelString(ui.match_win_rate, "66.6%")
  ed.right2(ui.match_win_rate, ui.match_win_rate_tips, 10)
  local No = ed.createSprite("UI/alpha/1080P/toparena/text_no.png")
  ui.final_ranking_bg:addChild(No)
  ed.right2(No, ui.final_ranking_tips, 10)
  local rank = ed.getNumberNode({text = 12345, folder = "peak_rank"}).node
  rank:setAnchorPoint(ccp(0, 0.5))
  No:addChild(rank)
  rank:setPosition(ccp(No:getContentSize().width, ui.final_ranking_tips:getContentSize().height / 2))
  return container, ui
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy({skipAnim = true})
  end)
end
