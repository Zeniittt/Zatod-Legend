local base = ed.ui.basescene
local CupArenaGambleScene = newclass(base.mt)
ed.ui.CupArenaGambleScene = CupArenaGambleScene

function CupArenaGambleScene.create(data)
  local self = base.create("CupArenaGambleScene")
  setmetatable(self, CupArenaGambleScene.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerListenEvent()
  return self
end

function CupArenaGambleScene:initData(data)
  self.data = data
  if nil == self.data._options then
    self.data._options = {}
  end
  self.totalGambleVal = ed.player:getPoint("gold")
  self.isPlayEnterAction = true
end

function CupArenaGambleScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.CupArenaGambleScene, {
    container = self.mainLayer
  })
  self.container = container
  self.ui = ui
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:setBackground("UI/alpha/1080P/cuparena/knockout/gamble/gamble_bg.png")
  local _, titleTxt = ed.UITool.createSceneTitle(T("\231\171\158\231\140\156"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:adaptUI()
  ed.setLabelStroke(self.ui.label_time_des, ed.toccc3(8003357), 1)
  ed.setLabelStroke(self.ui.label_time_out, ed.toccc3(8003357), 1)
  ed.setLabelStroke(self.ui.label_record, ed.toccc3(10642201), 1)
  ed.setLabelFontName(self.ui.label_empty, ed.fontBold)
  ed.setLabelStroke(self.ui.label_empty, ed.toccc3(5128243), 1)
  self:startTimer()
  self:refreshGambleInfo()
end

function CupArenaGambleScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 50, top = 18})
  local localDesignScale = 2.1666666666666665
  local localFixedWidth = ed.display.designSize.height * localDesignScale - ed.display.designSize.width
  local adaptRatio = math.min(ed.display.halfFixedWidth * 2 / localFixedWidth, 1)
  ed.layout.layoutWithMagin(self.ui.bg_line_right_1, {
    right = adaptRatio * 50
  })
  ed.layout.layoutWithMagin(self.ui.bg_line_left_1, {
    left = adaptRatio * 50
  })
  ed.layout.layoutWithMagin(self.ui.bg_gamble_val, {
    right = adaptRatio * 20,
    top = 18
  })
  local mainPanelSize = self.ui.panel_main:getContentSize()
  mainPanelSize.height = mainPanelSize.height + ed.display.halfFixedHeight
  self.ui.panel_main:setContentSize(mainPanelSize)
  ed.layout.layoutWithMagin(self.ui.panel_main, {bottom = 22})
  local lineBgSize = self.ui.bg_line_right_1:getContentSize()
  local rightMainPanelPosX = self.ui.panel_main:getPositionX() + mainPanelSize.width
  local leftMainPanelPosX = self.ui.panel_main:getPositionX()
  local rightLine1PosX = self.ui.bg_line_right_1:getPositionX()
  local leftLine1PosX = self.ui.bg_line_left_1:getPositionX()
  local rightDiffX = rightLine1PosX - lineBgSize.width * 0.5 - rightMainPanelPosX
  local leftDiffX = leftMainPanelPosX - leftLine1PosX - lineBgSize.width * 0.5
  local mainPanelScale = (rightLine1PosX - leftLine1PosX - lineBgSize.width - 10) / mainPanelSize.width
  if mainPanelScale < 1 then
    self.ui.panel_main:setScale(mainPanelScale)
    self.ui.panel_main:setPositionX((self.ui.panel_main:getParent():getContentSize().width - mainPanelSize.width * mainPanelScale) * 0.5)
    self.ui.bg_line_left_2:setVisible(false)
    self.ui.bg_line_right_2:setVisible(false)
  else
    if leftDiffX < self.ui.bg_line_left_2:getContentSize().width then
      self.ui.bg_line_left_2:setVisible(false)
    else
      self.ui.bg_line_left_2:setVisible(true)
      self.ui.bg_line_left_2:setPositionX(leftMainPanelPosX - leftDiffX * 0.5)
    end
    if rightDiffX < self.ui.bg_line_right_2:getContentSize().width then
      self.ui.bg_line_right_2:setVisible(false)
    else
      self.ui.bg_line_right_2:setVisible(true)
      self.ui.bg_line_right_2:setPositionX(rightMainPanelPosX + rightDiffX * 0.5)
    end
  end
end

function CupArenaGambleScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onRuleEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_record", function()
    self:onRecordEvent()
  end, {normalScale = 0.9, pressScale = 0.855})
end

function CupArenaGambleScene:registerListenEvent()
  self:listenEvent("EventCupArenaGambleUpdate", function(data)
    self:handleGambleReply(data)
  end)
  self:listenEvent("PlayerMoneyChange", function(data)
    self.totalGambleVal = ed.player:getPoint("gold")
    self:refreshGambleVal()
  end)
end

function CupArenaGambleScene:handleGambleReply(data)
  for i, v in ipairs(self.data._options) do
    if v._match_id == data._match_id then
      v._pick_side = 1 == data._pick_host and 1 or 2
      v._counter = data._counter
      if nil ~= data._option then
        v._host_pick_rate = data._option._host_pick_rate
        v._guest_pick_rate = data._option._guest_pick_rate
      end
      local itemUI = self.gambleUIArr[i]
      self:refreshGambleItem(itemUI, i, v)
      local bgSize = itemUI.bg:getContentSize()
      local handBtn, selectedBg, goldPosX
      if 1 == v._pick_side then
        selectedBg = itemUI.bg_selected_red
        handBtn = itemUI.btn_add_red
        goldPosX = bgSize.width * 0.5 - 100
      else
        selectedBg = itemUI.bg_selected_blue
        handBtn = itemUI.btn_add_blue
        goldPosX = bgSize.width * 0.5 + 100
      end
      ed.setCascadeOpacityEnabled(selectedBg, true, true)
      local addBtnSize = handBtn:getContentSize()
      local worldPos = handBtn:convertToWorldSpace(ccp(addBtnSize.width * 0.5, addBtnSize.height * 0.5 + 3))
      local localPos = self.ui.panel_main:convertToNodeSpace(worldPos)
      local handFca = ed.createFcaNode("eff_UI_Main_Cuparena_bet")
      self:addFcaOnce(handFca)
      handFca:setPosition(localPos)
      self.ui.panel_main:addChild(handFca, 999)
      worldPos = itemUI.bg:convertToWorldSpace(ccp(goldPosX, bgSize.height * 0.5))
      localPos = self.ui.panel_main:convertToNodeSpace(worldPos)
      local goldFca = ed.createFcaNode("eff_UI_Main_Cuparena_bet1")
      self:addFcaOnce(goldFca)
      goldFca:setPosition(localPos)
      goldFca:setScaleX(goldPosX > bgSize.width * 0.5 and -1 or 1)
      self.ui.panel_main:addChild(goldFca, 999)
      handFca:setOpacity(0)
      goldFca:setOpacity(0)
      self:listenTimer(Timer:Once(0.1), function()
        handFca:setOpacity(255)
        goldFca:setOpacity(255)
      end)
      break
    end
  end
end

function CupArenaGambleScene:refreshGambleInfo()
  self.endTime = self.data._left_bet_time + ed.getServerTime()
  self:refreshGambleVal()
  self:refreshGambleList()
  self:updateCountDownUI(true)
end

function CupArenaGambleScene:refreshGambleVal()
  ed.setLabelString(self.ui.label_gamble_val, self.totalGambleVal)
  local valWidth = self.ui.label_gamble_val:getContentSize().width
  local iconWidth = self.ui.img_gamble_val:getContentSize().width
  local bgSize = self.ui.bg_gamble_val:getContentSize()
  bgSize.width = 7 + valWidth + 5 + iconWidth + 7
  self.ui.bg_gamble_val:setContentSize(bgSize)
  self.ui.label_gamble_val:setPositionX(bgSize.width - 7)
  self.ui.img_gamble_val:setPositionX(bgSize.width - 7 - valWidth - iconWidth * 0.5)
end

function CupArenaGambleScene:createGambleItem(index, gambleData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaGambleItem)
  container:setContentSize(ui.bg:getContentSize())
  ed.setLabelStroke(ui.label_title, ed.toccc3(5851186), 1)
  ed.setLabelStroke(ui.label_report, ed.toccc3(8670257), 1)
  ui.winFlagLabel = ed.ui.gradientLabel.create({
    text = T("\232\131\156"),
    fontSize = 50,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16711572),
    endColor = ed.toccc3(16759384),
    strokeColor = ed.toccc3(12799286),
    strokeSize = 1.5,
    shadowOffset = ccp(0, -2),
    shadowColor = ccc3(76, 76, 76)
  })
  ui.bg:addChild(ui.winFlagLabel.node)
  ui.winFlagLabel.node:setPositionY(115)
  ui.failFlagLabel = ed.ui.gradientLabel.create({
    text = T("\232\180\159"),
    fontSize = 50,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15726847),
    endColor = ed.toccc3(9873091),
    strokeColor = ed.toccc3(4739950),
    strokeSize = 1.5,
    shadowOffset = ccp(0, -2),
    shadowColor = ccc3(76, 76, 76)
  })
  ui.bg:addChild(ui.failFlagLabel.node)
  ui.failFlagLabel.node:setPositionY(115)
  self:refreshGambleItem(ui, index, gambleData)
  return container, ui
end

function CupArenaGambleScene:refreshGambleItem(ui, index, gambleData)
  ui.index = index
  local isWinnerHost = 1 == gambleData._winner
  local isWinnerGuest = 2 == gambleData._winner
  if isWinnerHost then
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_race_list_2.png")
  elseif isWinnerGuest then
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_race_list_3.png")
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_race_list_1.png")
  end
  local campTable = ed.getDataTable("CupArenaCamp")
  local matchTableItem = ed.getDataTable("CupArenaMatch")[gambleData._match_id]
  ed.setLabelString(ui.label_title, matchTableItem["Match Name"])
  local redSummary = gambleData._host._summary
  local redParam = {
    id = redSummary._avatar,
    level = redSummary._level,
    lvoffset = {x = -47, y = -38}
  }
  local redHeadNode, redHeadIcon = ed.getWholeHeadIcon(redParam)
  ed.UITool.replaceUI(ui, "bg", "img_head_red", redHeadNode)
  ui.redHeadIcon = redHeadIcon
  ed.setAllSpriteColor(redHeadNode, isWinnerGuest and ccc3(150, 150, 150) or ccc3(255, 255, 255))
  local redName = ed.getPlayerName(redSummary._name, redSummary._medal, {
    root = CCSprite:create(),
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0, 0.5),
    labelColor = isWinnerGuest and "ccc3(255,255,255)" or "ccc3(255,252,231)",
    labelStroke = isWinnerGuest and "0x3e3e3e" or "0x0f1e1e"
  })
  ed.UITool.replaceUI(ui, "bg", "label_name_red", redName)
  local redCampTableItem = campTable[gambleData._host._camp_id]
  ed.setLabelString(ui.label_camp_red, T("%s\233\152\181\232\144\165", redCampTableItem["Camp Name"]))
  ed.setTexture(ui.img_camp_red, redCampTableItem["Camp Symbol Min"])
  ed.updateSpriteStone(ui.img_camp_red, isWinnerGuest)
  ed.setLabelColor(ui.label_camp_red, isWinnerGuest and ccc3(239, 238, 228) or ccc3(255, 243, 162))
  ed.setLabelStroke(ui.label_camp_red, isWinnerGuest and ed.toccc3(3485744) or ed.toccc3(8600122), 1)
  ed.setLabelString(ui.label_support_red, T("\230\148\175\230\140\129\231\142\135\239\188\154%.1f%%", gambleData._host_pick_rate / 10))
  ed.setLabelColor(ui.label_support_red, isWinnerGuest and ccc3(222, 228, 238) or ccc3(255, 252, 231))
  local blueSummary = gambleData._guest._summary
  local blueParam = {
    id = blueSummary._avatar,
    level = blueSummary._level,
    lvoffset = {x = -47, y = -38}
  }
  local blueHeadNode, blueHeadIcon = ed.getWholeHeadIcon(blueParam)
  ed.UITool.replaceUI(ui, "bg", "img_head_blue", blueHeadNode)
  ui.blueHeadIcon = blueHeadIcon
  ed.setAllSpriteColor(blueHeadNode, isWinnerHost and ccc3(150, 150, 150) or ccc3(255, 255, 255))
  local blueName = ed.getPlayerName(blueSummary._name, blueSummary._medal, {
    root = CCSprite:create(),
    medalRight = true,
    disableOffset = true,
    anchorPoint = ccp(1, 0.5),
    labelColor = isWinnerHost and "ccc3(255,255,255)" or "ccc3(255,252,231)",
    labelStroke = isWinnerHost and "0x3e3e3e" or "0x0f1e1e"
  })
  ed.UITool.replaceUI(ui, "bg", "label_name_blue", blueName)
  local blueCampTableItem = campTable[gambleData._guest._camp_id]
  ed.setLabelString(ui.label_camp_blue, T("%s\233\152\181\232\144\165", blueCampTableItem["Camp Name"]))
  ed.setTexture(ui.img_camp_blue, blueCampTableItem["Camp Symbol Min"])
  ed.updateSpriteStone(ui.img_camp_blue, isWinnerHost)
  ed.setLabelColor(ui.label_camp_blue, isWinnerHost and ccc3(239, 238, 228) or ccc3(255, 243, 162))
  ed.setLabelStroke(ui.label_camp_blue, isWinnerHost and ed.toccc3(3485744) or ed.toccc3(8600122), 1)
  ed.layout.horizontalSortNode({
    ui.img_camp_blue,
    ui.label_camp_blue
  }, {5, 0}, ui.label_camp_blue:getPositionX(), 1)
  ed.setLabelString(ui.label_support_blue, T("\230\148\175\230\140\129\231\142\135\239\188\154%.1f%%", gambleData._guest_pick_rate / 10))
  ed.setLabelColor(ui.label_support_blue, isWinnerHost and ccc3(222, 228, 238) or ccc3(255, 252, 231))
  local isEnd = isWinnerHost or isWinnerGuest
  ui.btn_report:setVisible(isEnd)
  ui.winFlagLabel.node:setVisible(isEnd)
  ui.failFlagLabel.node:setVisible(isEnd)
  if isEnd then
    ui.winFlagLabel.node:setPositionX(isWinnerHost and 395 - ui.winFlagLabel.node:getContentSize().width * 0.5 or 415 + ui.winFlagLabel.node:getContentSize().width * 0.5)
    ui.failFlagLabel.node:setPositionX(isWinnerHost and 415 + ui.failFlagLabel.node:getContentSize().width * 0.5 or 395 - ui.failFlagLabel.node:getContentSize().width * 0.5)
  end
  ui.bg_pick_red:setVisible(not isEnd and 0 == gambleData._pick_side and nil ~= self.endTime)
  ui.bg_pick_blue:setVisible(not isEnd and 0 == gambleData._pick_side and nil ~= self.endTime)
  if ed.CupArenaManager:getIsReadGambleAmount() then
    if nil ~= ui.redTipFca then
      ui.redTipFca:removeFromParentAndCleanup(true)
      self:removeFca(ui.redTipFca)
      ui.redTipFca = nil
      ui.blueTipFca:removeFromParentAndCleanup(true)
      self:removeFca(ui.blueTipFca)
      ui.blueTipFca = nil
    end
  elseif ui.bg_pick_red:isVisible() and nil == ui.redTipFca then
    ui.redTipFca = ed.createFcaNode("eff_UI_Main_Cuparena_prompt")
    self:addFca(ui.redTipFca)
    ui.bg_pick_red:addChild(ui.redTipFca)
    local fcaPosX, fcaPosY = ui.btn_pick_red:getPosition()
    ui.redTipFca:setPosition(fcaPosX, fcaPosY + 2.5)
    ui.blueTipFca = ed.createFcaNode("eff_UI_Main_Cuparena_prompt")
    self:addFca(ui.blueTipFca)
    ui.bg_pick_blue:addChild(ui.blueTipFca)
    fcaPosX, fcaPosY = ui.btn_pick_blue:getPosition()
    ui.blueTipFca:setPosition(fcaPosX, fcaPosY + 2.5)
  end
  if 1 == gambleData._pick_side then
    ed.setLabelString(ui.label_value_red, T("\229\183\178\230\148\175\230\140\129%s", ed.formatNumber(gambleData._counter)))
    ui.bg_selected_red:setVisible(true)
  else
    ui.bg_selected_red:setVisible(false)
  end
  if 2 == gambleData._pick_side then
    ed.setLabelString(ui.label_value_blue, T("\229\183\178\230\148\175\230\140\129%s", ed.formatNumber(gambleData._counter)))
    ui.bg_selected_blue:setVisible(true)
  else
    ui.bg_selected_blue:setVisible(false)
  end
  return container, ui
end

function CupArenaGambleScene:getPos(i)
  local size = self.ui.panel_main:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 195
  local itemSpace = -25
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaGambleScene:getHeight(num)
  local itemHeight = 195
  local itemSpace = -25
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaGambleScene:getPressHander(...)
  return function(x, y)
    for _, cellUI in ipairs(self.gambleUIArr) do
      if ed.containsPoint(cellUI.redHeadIcon, x, y) then
        cellUI.img_head_red:setScale(0.95)
        return cellUI, {type = 1}
      elseif ed.containsPoint(cellUI.blueHeadIcon, x, y) then
        cellUI.img_head_blue:setScale(0.95)
        return cellUI, {type = 2}
      elseif ed.checkVisible(cellUI.btn_pick_red) and ed.containsPoint(cellUI.btn_pick_red, x, y) then
        cellUI.btn_pick_red:setScale(0.95)
        return cellUI, {type = 3}
      elseif ed.checkVisible(cellUI.btn_pick_blue) and ed.containsPoint(cellUI.btn_pick_blue, x, y) then
        cellUI.btn_pick_blue:setScale(0.95)
        return cellUI, {type = 4}
      elseif ed.checkVisible(cellUI.btn_report) and ed.containsPoint(cellUI.btn_report, x, y) then
        cellUI.btn_report:setScale(0.95)
        return cellUI, {type = 5}
      end
    end
  end
end

function CupArenaGambleScene:getClickHander(...)
  return function(x, y, cellUI, param)
    if 1 == param.type then
      if ed.containsPoint(cellUI.redHeadIcon, x, y) then
        self:onHeadEvent(cellUI.index, true)
      end
    elseif 2 == param.type then
      if ed.containsPoint(cellUI.blueHeadIcon, x, y) then
        self:onHeadEvent(cellUI.index, false)
      end
    elseif 3 == param.type then
      if ed.containsPoint(cellUI.btn_pick_red, x, y) then
        self:onPickEvent(cellUI.index, true)
      end
    elseif 4 == param.type then
      if ed.containsPoint(cellUI.btn_pick_blue, x, y) then
        self:onPickEvent(cellUI.index, false)
      end
    elseif 5 == param.type and ed.containsPoint(cellUI.btn_report, x, y) then
      self:onReportEvent(cellUI.index)
    end
  end
end

function CupArenaGambleScene:getCancelPressIn(...)
  return function(x, y, cellUI, param)
    if 1 == param.type then
      cellUI.img_head_red:setScale(1)
    elseif 2 == param.type then
      cellUI.img_head_blue:setScale(1)
    elseif 3 == param.type then
      cellUI.btn_pick_red:setScale(1)
    elseif 4 == param.type then
      cellUI.btn_pick_blue:setScale(1)
    elseif 5 == param.type then
      cellUI.btn_report:setScale(1)
    end
  end
end

function CupArenaGambleScene:refreshGambleList()
  if nil == self.ui.gambleDraglist then
    local contentSize = self.ui.panel_main:getContentSize()
    self.ui.gambleDraglist = ed.UITool.createDraglist(self.ui.panel_main, {
      priority = -300,
      doPressIn = self:getPressHander(),
      doClickIn = self:getClickHander(),
      cancelPressIn = self:getCancelPressIn(),
      bar = {
        bglen = contentSize.height - 20,
        bgpos = ccp(contentSize.width + 3, contentSize.height / 2 - 20),
        barres = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_slide_1.png",
        bgres = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_slide_2.png",
        alwaysShow = true
      }
    })
    self.gambleUIArr = {}
  end
  local optionNum = 0
  for i, v in ipairs(self.data._options) do
    if i > #self.gambleUIArr then
      local itemContainer, itemUI = self:createGambleItem(i, v)
      self.ui.gambleDraglist:addItem(itemContainer)
      itemContainer:setPosition(self:getPos(i))
      table.insert(self.gambleUIArr, itemUI)
    else
      self:refreshGambleItem(self.gambleUIArr[i], i, v)
    end
    optionNum = optionNum + 1
  end
  self.ui.gambleDraglist:initListHeight(self:getHeight(optionNum))
  self.ui.gambleDraglist:refreshClipRect(self.ui.panel_main:getScale())
  for i = #self.gambleUIArr, optionNum + 1, -1 do
    table.remove(self.gambleUIArr, i)
    self.ui.gambleDraglist:removeItemWithIndex(i)
  end
  self.ui.img_empty:setVisible(0 == optionNum)
end

function CupArenaGambleScene:onRuleEvent()
  local ruleTxt = T("1.\230\175\143\232\189\174\230\175\148\232\181\155\228\184\173\239\188\140\229\143\130\232\181\155\233\128\137\230\137\139\229\184\131\233\152\181\229\174\140\230\136\144\229\144\142\239\188\140\230\137\128\230\156\137\231\142\169\229\174\182\229\143\175\233\128\154\232\191\135\231\171\158\231\140\156\230\140\137\233\146\174\232\191\155\229\133\165\231\171\158\231\140\156\231\149\140\233\157\162\239\188\140\230\138\149\229\133\165\233\135\145\229\184\129\230\148\175\230\140\129\232\135\170\229\183\177\229\150\156\230\172\162\231\154\132\233\128\137\230\137\139\227\128\130<br/>") .. T("2.\231\142\169\229\174\182\230\175\143\229\156\186\230\175\148\232\181\155\229\143\175\230\148\175\230\140\129\233\162\157\229\186\166\230\156\128\229\164\154\228\184\186\232\135\170\232\186\171\233\135\145\229\184\129\230\140\129\230\156\137\230\149\176\231\154\13220%\239\188\140\228\184\148\228\184\141\232\182\133\232\191\1352000\228\184\135\239\188\140\231\161\174\232\174\164\230\148\175\230\140\129\233\162\157\229\186\166\229\144\142\228\184\141\229\143\175\229\134\141\230\172\161\232\191\189\229\138\160\227\128\130<br/>") .. T("3.\231\142\169\229\174\182\230\175\143\232\189\174\230\156\128\229\164\154\232\131\189\229\164\159\229\143\130\229\138\1608\229\156\186\231\171\158\231\140\156\227\128\130<br/>") .. T("4.\232\139\165\230\148\175\230\140\129\231\154\132\233\128\137\230\137\139\232\131\156\229\135\186\239\188\140 \231\142\169\229\174\182\229\176\134\230\140\137\230\148\175\230\140\129\230\150\185\230\148\182\231\155\138\231\142\135\232\142\183\229\190\151\233\135\145\229\184\129\229\165\150\229\138\177\239\188\140\230\156\128\229\164\154\228\184\141\232\182\133\232\191\135\230\156\172\233\135\145\231\154\13210\229\128\141\227\128\130\232\139\165\230\148\175\230\140\129\231\154\132\233\128\137\230\137\139\228\184\141\229\185\184\230\136\152\232\180\165\239\188\140\231\142\169\229\174\182\229\176\134\229\164\177\229\142\187\229\183\178\230\138\149\229\133\165\231\154\132\230\148\175\230\140\129\233\135\145\227\128\130<br/>") .. T("5.\230\175\143\231\171\158\231\140\156\230\136\144\229\138\159\228\184\128\229\156\186\239\188\140\231\142\169\229\174\182\229\176\134\232\142\183\229\190\151\233\162\157\229\164\150\231\154\132\229\165\189\232\191\144\229\174\157\231\174\177\239\188\155\230\175\143\231\171\158\231\140\156\229\164\177\232\180\165\228\184\128\229\156\186\239\188\140\231\142\169\229\174\182\229\176\134\232\142\183\229\190\151\233\162\157\229\164\150\231\154\132\233\188\147\229\138\177\229\174\157\231\174\177\227\128\130<br/>") .. T("6.\233\135\145\229\184\129\229\165\150\229\138\177\229\146\140\229\174\157\231\174\177\233\131\189\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\233\128\129\227\128\130<br/>")
  ed.ui.commonRulePop.create({
    title = T("\231\171\158\231\140\156\232\167\132\229\136\153"),
    txt = ruleTxt
  }):popWindow()
end

function CupArenaGambleScene:onRecordEvent()
  ed.CupArenaNetwork:sendGambleRecord()
end

function CupArenaGambleScene:onReportEvent(index)
  local gambleData = self.data._options[index]
  if nil == gambleData then
    return
  end
  ed.CupArenaNetwork:sendGetReply(nil, gambleData._match_id)
end

function CupArenaGambleScene:onHeadEvent(index, isHost)
  local gambleData = self.data._options[index]
  if nil == gambleData then
    return
  end
  local summary = isHost and gambleData._host._summary or gambleData._guest._summary
  ed.CupArenaNetwork:sendViewUser(summary._role_id)
end

function CupArenaGambleScene:onPickEvent(index, isHost)
  if nil == self.endTime then
    ed.showToast(T("\231\171\158\231\140\156\229\183\178\231\187\147\230\157\159"))
    return
  end
  local gambleData = self.data._options[index]
  if nil == gambleData then
    return
  end
  if not ed.CupArenaManager:getIsReadGambleAmount() then
    for i, v in ipairs(self.gambleUIArr) do
      if nil ~= v.redTipFca then
        v.redTipFca:removeFromParentAndCleanup(true)
        self:removeFca(v.redTipFca)
        v.redTipFca = nil
        v.blueTipFca:removeFromParentAndCleanup(true)
        self:removeFca(v.blueTipFca)
        v.blueTipFca = nil
      end
    end
    ed.CupArenaManager:setIsReadGambleAmount()
  end
  ed.ui.CupArenaGambleAmountWin.create({
    matchId = gambleData._match_id,
    isHost = isHost,
    maxAmount = math.min(math.floor(self.totalGambleVal * 0.2), 20000000),
    perAmount = 1000,
    callback = function(...)
      self:onSupportCompleteEvent(...)
    end
  })
end

function CupArenaGambleScene:onSupportCompleteEvent(matchId, isHost, amount)
  if nil == self.endTime then
    ed.showToast(T("\231\171\158\231\140\156\229\183\178\231\187\147\230\157\159"))
    return
  end
  if amount > ed.player._money then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
    return
  end
  ed.CupArenaNetwork:sendMatchGamble(matchId, isHost, amount)
end

function CupArenaGambleScene:startTimer(...)
  self:listenTimer(Timer:Always(0.5), function()
    self:updateCountDownUI(false)
  end)
end

function CupArenaGambleScene:updateCountDownUI(isInit)
  if nil ~= self.endTime and self.endTime > 0 then
    local diffTime = self.endTime - ed.getServerTime()
    if diffTime <= 0 then
      self.endTime = nil
      self.ui.img_time_icon:setVisible(false)
      self.ui.label_time_des:setVisible(false)
      self.ui.label_time_out:setVisible(true)
      self:onTimeoutEvent()
    else
      ed.setLabelString(self.ui.label_time_des, T("\229\137\169\228\189\153%s", ed.gethmsNString(diffTime)))
      if isInit then
        self.ui.img_time_icon:setVisible(true)
        self.ui.label_time_des:setVisible(true)
        self.ui.label_time_out:setVisible(false)
        ed.layout.horizontalSortNode({
          self.ui.img_time_icon,
          self.ui.label_time_des
        }, {6, 0}, self.ui.bg_progress:getContentSize().width * 0.5)
      end
    end
  elseif isInit then
    self.ui.img_time_icon:setVisible(false)
    self.ui.label_time_des:setVisible(false)
    self.ui.label_time_out:setVisible(true)
  end
end

function CupArenaGambleScene:onEnter(...)
  base.onEnter(self)
  self:playEnterAction()
end

function CupArenaGambleScene:playEnterAction()
  if not self.isPlayEnterAction then
    return
  end
  self.isPlayEnterAction = true
  local curtainFca = ed.createFcaNode("eff_UI_transition_curtain")
  self:addFcaOnce(curtainFca)
  curtainFca:setPosition(ccpAdd(ed.display.center, ccp(-ed.display.halfFixedWidth, 0)))
  self.mainLayer:addChild(curtainFca, 999)
  for i, v in ipairs(self.gambleUIArr) do
    v.bg:stopAllActions()
    ed.setCascadeOpacityEnabled(v.bg, true, true)
    v.bg:setOpacity(0)
    if nil ~= v.redTipFca then
      v.redTipFca:setVisible(false)
    end
    if nil ~= v.blueTipFca then
      v.blueTipFca:setVisible(false)
    end
    v.bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.05 + i * 0.07), CCFadeIn:create(0.15), CCCallFunc:create(function()
      if nil ~= v.redTipFca then
        v.redTipFca:setVisible(true)
      end
      if nil ~= v.blueTipFca then
        v.blueTipFca:setVisible(true)
      end
    end))))
  end
end

function CupArenaGambleScene:onTimeoutEvent()
  for i, ui in ipairs(self.gambleUIArr) do
    ui.bg_pick_red:setVisible(false)
    ui.bg_pick_blue:setVisible(false)
  end
end
