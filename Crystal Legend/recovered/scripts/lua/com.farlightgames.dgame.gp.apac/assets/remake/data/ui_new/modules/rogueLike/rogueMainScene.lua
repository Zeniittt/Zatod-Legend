local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueMainScene = class
ed.UITool.registViewOpenFunc("rogueMainScene", function()
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Rogue")
  if cpl then
    ed.showToast(cpl)
    return
  end
  ed.rogueLikeNet.sendOpenPanel()
  ListenEventOnce("rogueOpenPanel", function()
    local scene = ed.ui.rogueMainScene.create()
    ed.pushScene(scene)
  end)
end)

function class.create()
  local self = base.create("rogueMainScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.rogueGuide = ed.rogueGuide.getInstance()
  self.curChapter = self.rogueLikeMgr:getCurChapter()
  self.rogueBookTB = ed.getDataTable("RogueBook")
  self.curBookIndex = 1
  self.bookList = {}
  self.lastBookId = ed.rogueLikeTool.getLastBookId()
  self:initUI()
  self:initEffect()
  self:registerTouchEvent()
  self:registerEventListener()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.rogueMainScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.roomList = {}
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\185\187\228\185\166\229\165\135\232\176\173"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:setBackground("UI/alpha/1080P/rogue/main/main_bg.jpg")
  self.ui.image_bg:setOpacity(0)
  self:registerRedDot()
  self:setBackButton()
  self:initLabels()
  self:adaptUI()
  self:initDragList()
  self:refreshDragList()
  self:refreshArrow()
end

function class:registerRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("rogue_golden_entry", self, {
    handle = function(value)
      self.ui.image_golden_entry_red:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange("rogue_collection_entry", self, {
    handle = function(value)
      self.ui.image_collection_entry_red:setVisible(0 < value)
    end
  })
end

function class:initEffect()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_golden, {
    left = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_collection, {
    left = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.image_left_arrow, {
    left = 30 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithMagin(self.ui.image_right_arrow, {
    right = 30 + ed.display.getNotchHeight()
  })
  local leftPosX, leftPosY = self.ui.image_left_arrow:getPosition()
  local lmove = CCMoveTo:create(1, ccp(leftPosX - 10, leftPosY))
  local lreverse = CCMoveTo:create(1, ccp(leftPosX, leftPosY))
  local lsequence = CCSequence:createWithTwoActions(lmove, lreverse)
  self.ui.image_left_arrow:runAction(CCRepeatForever:create(lsequence))
  local rightPosX, rightPosY = self.ui.image_right_arrow:getPosition()
  local rmove = CCMoveTo:create(1, ccp(rightPosX + 10, rightPosY))
  local rreverse = CCMoveTo:create(1, ccp(rightPosX, rightPosY))
  local rsequence = CCSequence:createWithTwoActions(rmove, rreverse)
  self.ui.image_right_arrow:runAction(CCRepeatForever:create(rsequence))
  local diffWidth = ed.display.winSize.width - 960
  local oldPanelListSize = self.ui.panel_list:getContentSize()
  self.ui.panel_list:setContentSize(CCSizeMake(oldPanelListSize.width + diffWidth, oldPanelListSize.height))
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() - diffWidth / 2)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_golden, ed.toccc3(3745055), 1)
  ed.setLabelStroke(self.ui.label_collection, ed.toccc3(3745055), 1)
end

function class:initDragList()
  self.ui.panel_list:setTouchEnabled(true)
  self.ui.panel_list:registerScriptTouchHandler(self:doMainLayerTouch(), false, -300, false)
end

function class:showOpenBookAction(bookCfg)
  if self.runOpenAction then
    return
  end
  local action1 = CCScaleTo:create(0.08333333333333333, 1.067, 0.98)
  local action2 = CCMoveBy:create(0.08333333333333333, ccp(0, -5))
  local action3 = CCSpawn:create(ccArrayMake(action1, action2))
  local container = bookCfg.item
  local bg = bookCfg.ui.image_bg
  local targetPos = ccp(self.ui.image_bg:getContentSize().width / 2, 500)
  local parent = bg:getParent()
  if parent then
    targetPos = parent:convertToNodeSpace(targetPos)
  end
  local action4 = CCScaleTo:create(0.125, 0.919, 0.919)
  local action5 = CCMoveTo:create(0.125, targetPos)
  local action6 = CCRotateTo:create(0.125, -23.1)
  local action7 = CCSpawn:create(ccArrayMake(action4, action5, action6))
  local endCall = CCCallFunc:create(function()
    xpcall(function()
      bg:setVisible(false)
      local rogueBookCfg = bookCfg.rogueBookCfg
      self.selectBookCfg = bookCfg
      self:onSelectBook(rogueBookCfg.ID, rogueBookCfg["Chapter Group"])
      self.runOpenAction = false
    end, EDDebug)
  end)
  local finaAction = CCSequence:create(ccArrayMake(action3, action7, endCall))
  local node = bookCfg.ui.image_bg
  container:setZOrder(999)
  node:runAction(finaAction)
  self.runOpenAction = true
  ed.playEffect(ed.sound.deo.rogue_book_open)
end

function class:showCloseBookAction(bookCfg)
  local action1 = CCScaleTo:create(0.125, 1.067, 0.98)
  local action2 = CCMoveTo:create(0.125, ccp(0, -5))
  local action3 = CCRotateTo:create(0.125, 0)
  local action4 = CCSpawn:create(ccArrayMake(action1, action2, action3))
  local action5 = CCScaleTo:create(0.08333333333333333, 1, 1)
  local action6 = CCMoveBy:create(0.08333333333333333, ccp(0, 5))
  local action7 = CCSpawn:create(ccArrayMake(action5, action6))
  local endCall = CCCallFunc:create(function()
    local container = bookCfg.item
    container:setZOrder(bookCfg.initZ or 1)
  end)
  local finaAction = CCSequence:create(ccArrayMake(action4, action7, endCall))
  local node = bookCfg.ui.image_bg
  if tolua.isnull(node) then
    return
  end
  node:setVisible(true)
  node:runAction(finaAction)
end

function class:refreshDragList()
  self.ui.panel_list:removeAllChildrenWithCleanup(true)
  self.bookList = {}
  local panelSize = self.ui.panel_list:getContentSize()
  local bookSize = CCSizeMake(365, 400)
  self.bookSize = bookSize
  local edge = 10
  local showBookAmount = math.floor((panelSize.width - edge * 2) / bookSize.width)
  self.showBookAmount = showBookAmount
  local edgeWidth = (panelSize.width - showBookAmount * bookSize.width) / 2
  self.edgeWidth = edgeWidth
  local curBookIndex, lastBookIndex
  for index, rogueBookCfg in ipairs(self.rogueBookTB) do
    local container, ui, isCurrentChapter, isTimeLock = self:createBookItem(rogueBookCfg)
    table.insert(self.bookList, {
      item = container,
      ui = ui,
      rogueBookCfg = rogueBookCfg,
      index = index,
      initZ = index,
      isTimeLock = isTimeLock
    })
    container:setZOrder(index)
    self.ui.panel_list:addChild(container)
    if isCurrentChapter then
      curBookIndex = index
    end
    if rogueBookCfg.ID == self.lastBookId then
      lastBookIndex = index
    end
    if rogueBookCfg.ID == 1 then
      self.rogueGuide:registerGuide("rogueMainScene", ui.image_bg)
    end
  end
  if curBookIndex then
    self.curBookIndex = curBookIndex
  elseif lastBookIndex then
    self.curBookIndex = lastBookIndex
  end
  self.maxIndex = #self.bookList - self.showBookAmount + 1
  self:refreshBookPosition()
  self:registerBookTouch()
end

function class:createBookItem(rogueBookCfg)
  local container, ui = ed.editorui(ed.uieditor.rogueBookItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelStroke(ui.label_reward_tips, ed.toccc3(6570784), 1)
  ed.setLabelStroke(ui.label_cur_tips, ed.toccc3(8400304), 1)
  ed.setLabelStroke(ui.label_unlock_time, ed.toccc3(5976188), 1)
  local unlockTime = ed.dateStringToTime(rogueBookCfg["Open Time"])
  local isTimeLock = unlockTime > ed.getFitServerTime()
  if isTimeLock then
    ui.image_lock:setVisible(true)
    local year, month, day, hour, minutes, second = string.match(rogueBookCfg["Open Time"], "(%d+)/(%d+)/(%d+)%s+(%d+):(%d+):(%d+)")
    ed.setLabelString(ui.label_unlock_time, string.format(T("%d\230\156\136%d\230\151\165%d\230\151\182\229\188\128\230\148\190"), month, day, hour))
  else
    ui.image_lock:setVisible(false)
  end
  local titleDetail = rogueBookCfg["Title Detail"]
  local startColor = tonumber("0x" .. (isTimeLock and titleDetail[7] or titleDetail[1] or "ffffff"))
  local endColor = tonumber("0x" .. (isTimeLock and titleDetail[8] or titleDetail[2] or "ffffff"))
  local strokeColor = tonumber("0x" .. (isTimeLock and titleDetail[9] or titleDetail[3] or "ffffff"))
  local shadowColor = tonumber("0x" .. titleDetail[4]) or 16777215
  local offsetX = tonumber(titleDetail[5]) or 0
  local offsetY = tonumber(titleDetail[6]) or 0
  local name = ed.ui.gradientLabel.create({
    text = rogueBookCfg.Name,
    fontSize = 28,
    fontName = ed.fontBold,
    startColor = ed.toccc3(startColor),
    endColor = ed.toccc3(endColor),
    strokeColor = ed.toccc3(strokeColor),
    strokeSize = 2,
    shadowColor = ed.toccc3(shadowColor),
    shadowOffset = ccp(0, -2)
  })
  ui.panel_name:addChild(name.node)
  local nameBgSize = ui.panel_name:getContentSize()
  name.node:setPosition(ccp(nameBgSize.width / 2 + offsetX, nameBgSize.height / 2 + offsetY))
  local spineName = rogueBookCfg["Book Effect"]
  if spineName then
    local spine = ed.createSpine(string.format("effect/%s/%s", spineName, spineName), 0.5)
    spine:setAnimation(0, "Idle", true)
    ui.image_bg:setOpacity(0)
    ui.image_bg:addChild(spine)
    spine:setPosition(ui.spine_pos:getPosition())
    if isTimeLock then
      spine:setColor(ccc3(127, 127, 127))
    end
  else
    ed.setTexture(ui.image_bg, rogueBookCfg["Book Cover"])
    if isTimeLock then
      ui.image_bg:setColor(ccc3(127, 127, 127))
    end
  end
  local nameSize = name.node:getContentSize()
  ui.image_book_red:setPosition(ccp(name.node:getPositionX() - nameSize.width / 2 - 5, name.node:getPositionY() + nameSize.height / 2))
  local isCurrentChapter
  local chapterId = rogueBookCfg["Chapter Group"]
  if self.rogueLikeMgr:getCurChapterId() == chapterId then
    ui.image_cur_tips:setVisible(true)
    local action = CCSequence:createWithTwoActions(CCMoveBy:create(1, ccp(0, -10)), CCMoveBy:create(1, ccp(0, 10)))
    ui.image_cur_tips:runAction(CCRepeatForever:create(action))
    isCurrentChapter = true
  else
    ui.image_cur_tips:setVisible(false)
    isCurrentChapter = false
  end
  self.redPointMgr:registerValueChange("rogue_book_" .. rogueBookCfg.ID, self, {
    handle = function(value)
      ui.image_book_red:setVisible(0 < value)
    end,
    force = true
  })
  return container, ui, isCurrentChapter, isTimeLock
end

function class:refreshArrow()
  if #self.bookList > self.showBookAmount then
    self.ui.image_left_arrow:setVisible(self.curBookIndex > 1)
    self.ui.image_right_arrow:setVisible(self.curBookIndex < self.maxIndex)
  else
    self.ui.image_left_arrow:setVisible(false)
    self.ui.image_right_arrow:setVisible(false)
  end
end

function class:refreshBookPosition(isShowAction)
  local posX = self.edgeWidth
  local bookSize = self.bookSize
  local panelSize = self.ui.panel_list:getContentSize()
  local outLeftPosX = -bookSize.width
  local rightOutPosX = ed.display.winSize.width + bookSize.width
  local firstBookIndex = self.curBookIndex or 1
  firstBookIndex = math.min(firstBookIndex, self.maxIndex)
  if #self.bookList > self.showBookAmount then
    for index, bookCfg in ipairs(self.bookList) do
      local container = bookCfg.item
      local targetPos
      if index < firstBookIndex then
        targetPos = ccp(outLeftPosX, 170)
      elseif index <= firstBookIndex + self.showBookAmount - 1 then
        targetPos = ccp(posX + bookSize.width / 2, 170)
        posX = posX + bookSize.width
      elseif index > firstBookIndex + self.showBookAmount - 1 then
        targetPos = ccp(rightOutPosX, 170)
      end
      if targetPos then
        if isShowAction then
          local moveAction = CCMoveTo:create(0.3, targetPos)
          container:stopAllActions()
          container:runAction(moveAction)
        else
          container:setPosition(targetPos)
        end
      end
    end
  else
    local startX = (panelSize.width - #self.bookList * bookSize.width) / 2
    for index, bookCfg in ipairs(self.bookList) do
      local container = bookCfg.item
      local targetPos
      targetPos = ccp(startX + bookSize.width / 2, 170)
      startX = startX + bookSize.width
      container:setPosition(targetPos)
    end
  end
end

function class:onClickBookItem(bookCfg)
  if bookCfg.isTimeLock then
    ed.showToast(T("\231\171\160\232\138\130\229\176\154\230\156\170\232\167\163\233\148\129"))
    return
  end
  local curChapterId = self.rogueLikeMgr:getCurChapterId()
  local rogueBookCfg = bookCfg.rogueBookCfg
  local bookId = rogueBookCfg.ID
  local chapterId = rogueBookCfg["Chapter Group"]
  if 0 < curChapterId and curChapterId ~= chapterId then
    ed.showToast(T("\229\133\182\228\187\150\231\171\160\232\138\130\230\173\163\229\156\168\232\191\155\232\161\140\228\184\173"))
    return
  end
  local isUnlock, tips = self.rogueLikeMgr:getChapterIsUnlock(chapterId)
  if isUnlock then
    self:showOpenBookAction(bookCfg)
  elseif tips then
    ed.showToast(tips)
  end
  self.rogueGuide:endGuide("rogueMainScene")
end

function class:onSelectBook(bookId, chapterId)
  ed.UITool.openView("rogueBookWindow", {
    bookId = bookId,
    closeCallBack = function()
      if self.selectBookCfg then
        self:showCloseBookAction(self.selectBookCfg)
      end
    end
  })
end

function class:onClickBtnGolden()
  ed.UITool.openView("rogueGoldenScene")
end

function class:onClickBtnCollection()
  ed.UITool.openView("rogueCollectScene")
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.rogueDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickFish()
  local itemId = ed.getDataTable("RogueConfig")["Use Vitality Item"]["Script Arg"]
  ed.ui.packageDetailWin.create({id = itemId, type = "item"}):popWindow()
end

function class:onClickVitality()
  ed.ui.packageDetailWin.create({
    type = "roguevitality"
  }):popWindow()
end

function class:onClickArrowLeft()
  if self.curBookIndex == 1 then
    return
  end
  self.curBookIndex = self.curBookIndex - 1
  self:refreshBookPosition(true)
  self:refreshArrow()
end

function class:onClickArrowRight()
  if self.curBookIndex == self.maxIndex then
    return
  end
  self.curBookIndex = self.curBookIndex + 1
  self:refreshBookPosition(true)
  self:refreshArrow()
end

function class:onPopScene()
  self.redPointMgr:unregisterAllValueChange(self)
  base.onPopScene(self)
end

function class:registerTouchEvent()
  ed.UITool.registerBtn(self, "btn_golden", function()
    self:onClickBtnGolden()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "btn_collection", function()
    self:onClickBtnCollection()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "image_left_arrow", function()
    self:onClickArrowLeft()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "image_right_arrow", function()
    self:onClickArrowRight()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "image_fish_bg", function()
    self:onClickFish()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "image_vitality_bg", function()
    self:onClickVitality()
  end, {pressScale = 0.95, priority = -300})
end

function class:doMainLayerTouch()
  local function handler(event, x, y)
    if event == "began" then
      self.touchX = x
    elseif event == "ended" then
      if self.touchX then
        if x > self.touchX and x - self.touchX > 200 then
          self:onClickArrowLeft()
        elseif x < self.touchX and 200 < math.abs(x - self.touchX) then
          self:onClickArrowRight()
        end
      end
      self.touchX = nil
    end
    return true
  end
  
  return handler
end

function class:registerBookTouch()
  for index, bookCfg in ipairs(self.bookList) do
    local item = bookCfg.item
    self:btRegisterButtonClick({
      button = item,
      key = "clickBook" .. index,
      clickHandler = function(_, x, y)
        if tolua.isnull(bookCfg.ui.image_bg) then
          return
        end
        self:onClickBookItem(bookCfg)
      end,
      clickInterval = 1.5,
      force = true
    })
  end
end

function class:registerEventListener()
  self:listenEvent("rogueEndBattle", function()
  end)
  self:listenEvent("rogueEnterChapter", function()
    self:refreshDragList()
  end)
  self:listenEvent("rogueExitChapter", function()
    ed.rogueLikeNet.sendOpenPanel()
  end)
  self:listenEvent("rogueOpenPanel", function()
    self.curChapter = self.rogueLikeMgr:getCurChapter()
    self:refreshDragList()
  end)
  self:registerOnEnterHandler("onEnter", function()
    self.rogueGuide:startGuide("rogueMainScene")
  end)
end
