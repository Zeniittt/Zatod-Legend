local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.guildClashGameGuideWin = class
ed.UITool.registViewOpenFunc("guildClashGameGuideWin", function()
  ed.ui.guildClashGameGuideWin.create():popWindow()
end)

function class.create()
  local self = base.create("guildClashGameGuideWin")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.pages = {}
  self.currentPage = 1
  self.pageAmount = 4
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashGameGuideWin)
  self.container:addChild(container)
  self.ui = ui
  self:initDragList()
  self:initPage()
  self:refreshArrow()
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCFadeTo:create(1, 0), CCFadeTo:create(1, 255)))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCFadeTo:create(1, 0), CCFadeTo:create(1, 255)))))
  self.ui.label_title:setFontName(ed.fontBold)
end

function class:initDragList()
  local container = self.ui.panel_rule
  local containerSize = container:getContentSize()
  container:setClipRect(CCRectMake(0, 0, containerSize.width, containerSize.height))
  local pageLayer = CCLayer:create()
  pageLayer:setContentSize(containerSize)
  container:addChild(pageLayer)
  self.pageLayer = pageLayer
end

function class:initPage()
  local posX = 0
  for index = 1, self.pageAmount do
    local page = self["createPage" .. index](self.ui.panel_rule)
    self.pages[index] = page
    self.pageLayer:addChild(page)
    page:setPosition(ccp(posX, 0))
    posX = self.ui.panel_rule:getContentSize().width + posX
  end
  self.maxWidth = posX
  self:createPagePoint()
end

function class:createPagePoint()
  local container = CCSprite:create()
  local gapX = 40
  local width = 0
  self.pointsPos = {}
  for chapter = 1, self.pageAmount do
    local point = ed.createSprite("UI/alpha/1080P/guild/guild_gamedec/switch_uncurrent.png")
    container:addChild(point)
    local pos = ccp(width, 0)
    width = width + gapX
    point:setPosition(pos)
    self.pointsPos[chapter] = pos
  end
  local pointSelect = ed.createSprite("UI/alpha/1080P/guild/guild_gamedec/switch_current.png")
  container:addChild(pointSelect)
  pointSelect:setPosition(self.pointsPos[self.chapterId] or ccp(0, 0))
  self.pointSelect = pointSelect
  container:setContentSize(CCSizeMake(width - gapX, pointSelect:getContentSize().height))
  self.ui.image_bg:addChild(container)
  ed.layout.layoutWithParentMagin(container, {bottom = -15})
  ed.layout.centerXInParent(container)
end

function class:onListMove(event, x, y)
  if event == "began" then
    if not ed.containsPoint(self.ui.panel_rule, x, y) then
      return
    end
    self.isPressInRect = true
    self.beganPosX = x
    self.startPosX = self.pageLayer:getPositionX()
  elseif event == "moved" then
    if not self.isPressInRect then
      return false
    end
    local changePosX = x - self.beganPosX
    local startMove = 14
    if startMove < math.abs(changePosX) then
      if changePosX < 0 then
        local targetPosX = self.startPosX + changePosX + startMove
        targetPosX = math.max(-(self.maxWidth - self.ui.panel_rule:getContentSize().width), targetPosX)
        self.pageLayer:setPositionX(targetPosX)
      else
        local targetPosX = self.startPosX + changePosX - startMove
        targetPosX = math.min(0, targetPosX)
        self.pageLayer:setPositionX(targetPosX)
      end
    end
  elseif event == "ended" then
    if not self.isPressInRect then
      return false
    end
    self.isPressInRect = false
    local direction
    local moveDistance = x - self.beganPosX
    if 0 < moveDistance then
      direction = -1
    else
      direction = 1
    end
    if math.abs(moveDistance) > 160 then
      self:changePage(direction)
    else
      local targetPosX = self.pages[self.currentPage]:getPositionX()
      self.pageLayer:stopAllActions()
      self.pageLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(-targetPosX, 0))))
    end
  end
  return false
end

function class:changePage(delta)
  local targetPage = self.currentPage + delta
  targetPage = math.min(self.pageAmount, targetPage)
  targetPage = math.max(1, targetPage)
  if self.currentPage == targetPage then
    return
  end
  self.currentPage = targetPage
  local targetPosition = self.pointsPos[targetPage] or ccp(0, 0)
  self.pointSelect:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.4, targetPosition)))
  local targetPosX = self.pages[targetPage]:getPositionX()
  self.pageLayer:stopAllActions()
  self.pageLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(-targetPosX, 0))))
  self:refreshArrow()
end

function class:refreshArrow()
  self.ui.arrow_left:setVisible(self.currentPage > 1)
  self.ui.arrow_right:setVisible(self.currentPage < self.pageAmount)
end

function class:createPage1(parent)
  local container, ui = ed.editorui(ed.uieditor.GuildClashRulePage1, {container = parent})
  ui.label_little_title:limitWidthByScale(80)
  ed.adaptLabel(ui.label_tips, {maxWidth = 700, minScale = 0.7})
  ed.setLabelDimensions(ui.label_desc_1, CCSizeMake(150, 0))
  ed.setLabelDimensions(ui.label_desc_2, CCSizeMake(260, 0))
  ui.label_num_1:setFontName(ed.fontBold)
  ui.label_num_2:setFontName(ed.fontBold)
  ui.label_num_3:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_num_1, ed.toccc3(16245965), 3)
  ed.setLabelStroke(ui.label_num_2, ed.toccc3(16245965), 3)
  ed.setLabelStroke(ui.label_num_3, ed.toccc3(16245965), 3)
  local context = T("\232\191\155\229\133\165\230\175\148\232\181\155\233\152\182\230\174\181\239\188\140<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\231\155\184\229\144\140\230\136\152\229\140\186</lable>\231\154\132\229\133\172\228\188\154\239\188\140\228\188\154\229\156\168\228\184\128\232\181\183\231\171\158\228\186\137\229\147\166")
  local autoText = ed.ui.autoText.new()
  local descPanelSize = ui.panel_desc_3:getContentSize()
  autoText:initParam({
    context = context,
    color = ccc3(135, 74, 44),
    maxWidth = descPanelSize.width,
    maxHeight = descPanelSize.height,
    fontSize = 15
  })
  ui.panel_desc_3:addChild(autoText.node)
  local contextWidth, contextHeight = autoText:getContentSize()
  autoText.node:setPosition(ccp(4, (descPanelSize.height + contextHeight - autoText:getFirstLineHeight()) * 0.5))
  return container
end

function class:createPage2(parent)
  local container, ui = ed.editorui(ed.uieditor.GuildClashRulePage2, {container = parent})
  ui.label_little_title:limitWidthByScale(80)
  ui.label_num_1:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_num_1, ed.toccc3(16245965), 3)
  local context = T("<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\229\145\168\228\184\128\232\135\179\229\145\168\229\133\173\230\153\154\228\184\13812\231\130\185\229\137\141</lable>\239\188\140\229\143\140\230\150\185\229\133\172\228\188\154\233\156\128\232\166\129\229\156\168<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\228\184\137\228\184\170</lable>\229\136\134\232\183\175\228\184\138\230\148\190\231\189\174\229\165\189\233\169\187\229\174\136\233\152\159\228\188\141\229\147\166")
  local autoText = ed.ui.autoText.new()
  local descPanelSize = ui.panel_desc_1:getContentSize()
  autoText:initParam({
    context = context,
    color = ccc3(135, 74, 44),
    maxWidth = descPanelSize.width,
    maxHeight = descPanelSize.height,
    fontSize = 15
  })
  ui.panel_desc_1:addChild(autoText.node)
  local contextWidth, contextHeight = autoText:getContentSize()
  autoText.node:setPosition(ccp(4, (descPanelSize.height + contextHeight - autoText:getFirstLineHeight()) * 0.5))
  return container
end

function class:createPage3(parent)
  local container, ui = ed.editorui(ed.uieditor.GuildClashRulePage3, {container = parent})
  ui.label_num_1:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_num_1, ed.toccc3(16245965), 3)
  local context = T("<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\229\145\168\230\151\165\230\153\154\228\184\13821\231\130\18530</lable>\239\188\140\229\143\140\230\150\185<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\230\175\143\230\157\161\229\136\134\232\183\175</lable>\228\184\138\233\169\187\229\174\136\231\154\132\233\152\159\228\188\141\229\143\145\231\148\159\230\136\152\230\150\151\229\185\182\229\134\179\229\135\186\232\175\165\229\136\134\232\183\175\231\154\132\232\131\156\232\180\159")
  local autoText = ed.ui.autoText.new()
  local descPanelSize = ui.panel_desc_1:getContentSize()
  autoText:initParam({
    context = context,
    color = ccc3(135, 74, 44),
    maxWidth = descPanelSize.width,
    maxHeight = descPanelSize.height,
    fontSize = 15
  })
  ui.panel_desc_1:addChild(autoText.node)
  local contextWidth, contextHeight = autoText:getContentSize()
  autoText.node:setPosition(ccp(4, (descPanelSize.height + contextHeight - autoText:getFirstLineHeight()) * 0.5))
  return container
end

function class:createPage4(parent)
  local container, ui = ed.editorui(ed.uieditor.GuildClashRulePage4, {container = parent})
  ui.label_num_1:setFontName(ed.fontBold)
  ui.label_num_2:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_num_1, ed.toccc3(16245965), 3)
  ed.setLabelStroke(ui.label_num_2, ed.toccc3(16245965), 3)
  local context1 = T("\228\184\137\230\157\161\229\136\134\232\183\175\231\154\132\230\136\152\230\150\151\233\131\189\231\187\147\230\157\159\229\144\142\239\188\140<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\232\142\183\232\131\156\229\136\134\232\183\175\230\155\180\229\164\154</lable>\231\154\132\229\133\172\228\188\154\239\188\140\228\188\154\232\142\183\229\190\151<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\230\156\172\232\189\174\230\175\148\232\181\155\232\131\156\229\136\169</lable>")
  local autoText1 = ed.ui.autoText.new()
  local descPanelSize = ui.panel_desc_1:getContentSize()
  autoText1:initParam({
    context = context1,
    color = ccc3(135, 74, 44),
    maxWidth = descPanelSize.width,
    maxHeight = descPanelSize.height,
    fontSize = 15
  })
  ui.panel_desc_1:addChild(autoText1.node)
  local contextWidth, contextHeight = autoText1:getContentSize()
  autoText1.node:setPosition(ccp(4, (descPanelSize.height + contextHeight - autoText1:getFirstLineHeight()) * 0.5))
  local context2 = T("\230\175\143\232\189\174\230\175\148\232\181\155\231\187\147\230\157\159\227\128\129\229\143\138\230\156\128\229\144\142\231\187\147\231\174\151\230\151\182\229\157\135\228\188\154\228\184\186\229\133\172\228\188\154\233\128\154\232\191\135<lable color=ccc3(248,240,114) fontName=fontBold strokeColor=guildClashGuide strokeSize=1>\233\130\174\228\187\182</lable>\229\143\145\230\148\190\229\165\150\229\138\177\229\147\166\239\188\129")
  local autoText2 = ed.ui.autoText.new()
  local descPanelSize = ui.panel_desc_2:getContentSize()
  autoText2:initParam({
    context = context2,
    color = ccc3(135, 74, 44),
    maxWidth = descPanelSize.width,
    maxHeight = descPanelSize.height,
    fontSize = 15
  })
  ui.panel_desc_2:addChild(autoText2.node)
  local contextWidth, contextHeight = autoText2:getContentSize()
  autoText2.node:setPosition(ccp(4, (descPanelSize.height + contextHeight - autoText2:getFirstLineHeight()) * 0.5))
  return container
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.panel_touch_area,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.arrow_left,
    key = "arrow_left",
    clickHandler = function()
      self:changePage(-1)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.arrow_right,
    key = "arrow_right",
    clickHandler = function()
      self:changePage(1)
    end
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:onListMove(event, x, y)
    end,
    key = "listMove"
  })
end
