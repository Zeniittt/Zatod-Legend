local base = ed.ui.popwindow
local CupArenaGambleRecordWin = newclass(base.mt)
ed.ui.CupArenaGambleRecordWin = CupArenaGambleRecordWin

function CupArenaGambleRecordWin.create(data)
  local self = base.create("CupArenaGambleRecordWin")
  setmetatable(self, CupArenaGambleRecordWin.mt)
  self:initData(data)
  self:initAppearence()
  self:registerTouchEvent()
  self:popWindow()
  return self
end

function CupArenaGambleRecordWin:initData(data)
  self.recordDatas = data._records or {}
end

function CupArenaGambleRecordWin:initAppearence(...)
  ed.editorui(ed.uieditor.CupArenaGambleRecordWin, {
    container = self.container,
    ui = self.ui
  })
  if nil == self.ui.titleLabel then
    local titleLabel = ed.ui.gradientLabel.create({
      text = T("\231\171\158\231\140\156\232\174\176\229\189\149"),
      fontSize = 24,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16777215),
      endColor = ed.toccc3(16770963),
      strokeSize = 1,
      strokeColor = ed.toccc3(9523712)
    }).node
    self.ui.bg:addChild(titleLabel)
    self.ui.titleLabel = titleLabel
    local bgSize = self.ui.bg:getContentSize()
    titleLabel:setPosition(ccp(bgSize.width * 0.5, bgSize.height - 30))
  end
  self:refreshRecordListUI()
end

function CupArenaGambleRecordWin:registerTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end)
end

function CupArenaGambleRecordWin:createRecordItem(index, recordData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaGambleRecordItem)
  local bgSize = ui.bg:getContentSize()
  container:setContentSize(bgSize)
  ui.winFlagLabel = ed.ui.gradientLabel.create({
    text = T("\232\131\156"),
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16759384),
    endColor = ed.toccc3(16711572),
    strokeColor = ed.toccc3(14179909),
    strokeSize = 1,
    shadowOffset = ccp(0, -1),
    shadowColor = ccc3(0, 0, 0)
  })
  ui.bg:addChild(ui.winFlagLabel.node)
  ui.winFlagLabel.node:setPositionY(bgSize.height * 0.5 - 20)
  ui.failFlagLabel = ed.ui.gradientLabel.create({
    text = T("\232\180\159"),
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(9873091),
    endColor = ed.toccc3(15726847),
    strokeColor = ed.toccc3(5661568),
    strokeSize = 1,
    shadowOffset = ccp(0, -1),
    shadowColor = ccc3(0, 0, 0)
  })
  ui.bg:addChild(ui.failFlagLabel.node)
  ui.failFlagLabel.node:setPositionY(bgSize.height * 0.5 - 20)
  local matchTableItem = ed.getDataTable("CupArenaMatch")[recordData._match_id]
  local titleStr = ed.CupArenaUITool.getMatchName(matchTableItem["Match Location"])
  if 0 ~= matchTableItem["Group ID"] then
    local groupTableItem = ed.getDataTable("CupArenaGroup")[matchTableItem["Group ID"]]
    titleStr = string.format("%s (%s)", titleStr, groupTableItem["Group Name"])
  end
  ed.setLabelString(ui.label_title, titleStr)
  local campTable = ed.getDataTable("CupArenaCamp")
  local isWinnerHost = 1 == recordData._winner
  local isWinnerGuest = 2 == recordData._winner
  local isSuccess = 1 == recordData._bet_result
  if isWinnerHost then
    if isSuccess then
      ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_bt_record_win.png")
    else
      ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_bt_record_lose.png")
    end
  elseif isSuccess then
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_bt_record_win_1.png")
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/gamble/gamble_bt_record_lose_1.png")
  end
  local redSummary = recordData._host._summary
  local redParam = {
    id = redSummary._avatar,
    level = redSummary._level,
    lvoffset = {x = -47, y = -38}
  }
  local redHeadNode, redHeadIcon = ed.getWholeHeadIcon(redParam)
  redHeadNode:setScale(0.75)
  ed.setAllSpriteColor(redHeadNode, isWinnerGuest and ccc3(150, 150, 150) or ccc3(255, 255, 255))
  ed.UITool.replaceUI(ui, "bg", "img_head_red", redHeadNode)
  local redName = ed.getPlayerName(redSummary._name, redSummary._medal, {
    disableOffset = true,
    anchorPoint = ccp(0, 0.5),
    labelColor = isWinnerGuest and "ccc3(255,255,255)" or "ccc3(255,252,231)",
    labelStroke = isWinnerGuest and "0x3e3e3e" or "0x2f1e1e"
  })
  ed.UITool.replaceUI(ui, "bg", "label_name_red", redName)
  local redCampTableItem = campTable[recordData._host._camp_id]
  ed.setTexture(ui.img_camp_red, redCampTableItem["Camp Symbol Min"])
  ed.updateSpriteStone(ui.img_camp_red, isWinnerGuest)
  ed.setLabelString(ui.label_camp_red, T("%s\233\152\181\232\144\165", redCampTableItem["Camp Name"]))
  ed.setLabelColor(ui.label_camp_red, isWinnerGuest and ccc3(239, 238, 228) or ccc3(255, 243, 162))
  ed.setLabelStroke(ui.label_camp_red, isWinnerGuest and ed.toccc3(3485744) or ed.toccc3(8600122), 1)
  local blueSummary = recordData._guest._summary
  local blueParam = {
    id = blueSummary._avatar,
    level = blueSummary._level,
    lvoffset = {x = -47, y = -38}
  }
  local blueHeadNode, blueHeadIcon = ed.getWholeHeadIcon(blueParam)
  blueHeadNode:setScale(0.75)
  ed.setAllSpriteColor(blueHeadNode, isWinnerHost and ccc3(150, 150, 150) or ccc3(255, 255, 255))
  ed.UITool.replaceUI(ui, "bg", "img_head_blue", blueHeadNode)
  local blueName = ed.getPlayerName(blueSummary._name, blueSummary._medal, {
    disableOffset = true,
    anchorPoint = ccp(1, 0.5),
    labelColor = isWinnerHost and "ccc3(255,255,255)" or "ccc3(255,252,231)",
    labelStroke = isWinnerHost and "0x3e3e3e" or "0x2f1e1e"
  })
  ed.UITool.replaceUI(ui, "bg", "label_name_blue", blueName)
  local blueCampTableItem = campTable[recordData._guest._camp_id]
  ed.setTexture(ui.img_camp_blue, blueCampTableItem["Camp Symbol Min"])
  ed.updateSpriteStone(ui.img_camp_blue, isWinnerHost)
  ed.setLabelString(ui.label_camp_blue, T("%s\233\152\181\232\144\165", blueCampTableItem["Camp Name"]))
  ed.setLabelColor(ui.label_camp_blue, isWinnerHost and ccc3(239, 238, 228) or ccc3(255, 243, 162))
  ed.setLabelStroke(ui.label_camp_blue, isWinnerHost and ed.toccc3(3485744) or ed.toccc3(8600122), 1)
  ed.layout.horizontalSortNode({
    ui.img_camp_blue,
    ui.label_camp_blue
  }, {1, 0}, ui.label_camp_blue:getPositionX(), 1)
  ui.winFlagLabel.node:setPositionX(isWinnerHost and 267 - ui.winFlagLabel.node:getContentSize().width * 0.5 or 277 + ui.winFlagLabel.node:getContentSize().width * 0.5)
  ui.failFlagLabel.node:setPositionX(isWinnerHost and 277 + ui.failFlagLabel.node:getContentSize().width * 0.5 or 267 - ui.failFlagLabel.node:getContentSize().width * 0.5)
  ui.resultFlagLabel = ed.ui.gradientLabel.create({
    text = isSuccess and T("\231\171\158\231\140\156\230\136\144\229\138\159") or T("\231\171\158\231\140\156\229\164\177\232\180\165"),
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(isSuccess and 16770652 or 16776154),
    endColor = ed.toccc3(isSuccess and 13421820 or 15856381),
    strokeColor = ed.toccc3(isSuccess and 11423246 or 3030398),
    strokeSize = 1
  })
  ui.bg:addChild(ui.resultFlagLabel.node)
  ui.resultFlagLabel.node:setPosition(ccp(bgSize.width - 106, bgSize.height * 0.5 + 8))
  ed.setLabelString(ui.label_gamble, string.format(0 < recordData._counter and "+%d" or "-%d", math.abs(recordData._counter)))
  return container, ui
end

function CupArenaGambleRecordWin:getPos(i)
  local size = self.ui.panel_record:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 131.5
  local itemSpace = 0
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaGambleRecordWin:getHeight(num)
  local itemHeight = 131.5
  local itemSpace = 0
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaGambleRecordWin:refreshRecordListUI(...)
  if nil == self.ui.recordDraglist then
    self.ui.recordDraglist = ed.UITool.createDraglist(self.ui.panel_record, {priority = -300})
  else
    self.ui.recordDraglist:clearList()
  end
  local recordNum = 0
  for i, v in ipairs(self.recordDatas) do
    local itemContainer, itemUI = self:createRecordItem(i, v)
    self.ui.recordDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i))
    recordNum = recordNum + 1
  end
  self.ui.recordDraglist:initListHeight(self:getHeight(recordNum))
  self.ui.img_empty:setVisible(0 == recordNum)
end
