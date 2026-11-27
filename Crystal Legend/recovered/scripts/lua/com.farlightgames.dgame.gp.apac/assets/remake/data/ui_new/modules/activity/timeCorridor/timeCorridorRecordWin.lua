local base = ed.ui.popwindow
local timeCorridorRecordWin = newclass(base.mt)
ed.ui.timeCorridorRecordWin = timeCorridorRecordWin
local displayTypeDict = {
  Skin = T("\231\154\174\232\130\164"),
  AvatarFrame = T("\229\164\180\229\131\143\230\161\134"),
  Avatar = T("\229\164\180\229\131\143"),
  Sticker = T("\232\161\168\230\131\133\229\140\133")
}

function timeCorridorRecordWin.create()
  local self = base.create("timeCorridorRecordWin")
  setmetatable(self, timeCorridorRecordWin.mt)
  ed.timeCorridorNet:sendQueryRecords()
  self:initUI()
  self:initTBView()
  self:registerTouchHandlers()
  self.refreshCliprectConfig = {
    draglist = self.tableview.dragList
  }
  self:listenEvent("TimeCorridorRecordsReply", function(records)
    self.records = records
    self:refreshTBView()
  end)
  self:popWindow()
  self:show()
  return self
end

function timeCorridorRecordWin:initLabels()
  local gl_title = ed.ui.gradientLabel.create({
    text = T("\232\191\189\229\175\187\232\174\176\229\189\149"),
    fontName = ed.fontBold,
    fontSize = 24,
    startColor = ed.toccc3(16043519),
    endColor = ed.toccc3(15661823),
    shadowColor = ed.toccc3(3804609),
    shadowOffset = ccp(0, -1),
    strokeColor = ed.toccc3(7418623),
    strokeSize = 1
  })
  ed.UITool.replaceUINew(self.ui, "label_title", gl_title.node)
  local at_tip = ed.ui.autoText.new()
  at_tip:initParam({
    context = T("\230\156\128\229\164\154\229\143\175\228\187\165\230\159\165\231\156\139%s\230\157\161\232\174\176\229\189\149", "<lable color=ccc3(240,149,19)>200</lable>"),
    color = ccc3(108, 105, 124),
    fontSize = 14,
    maxWidth = 800
  })
  ed.UITool.replaceUINew(self.ui, "label_tip", at_tip.node)
  local atWid, _ = at_tip:getCurContentSize()
  at_tip.node:setPositionX(at_tip.node:getPositionX() - 0.5 * atWid)
  ed.setLabelFontName(self.ui.label_no_record, ed.fontBold)
  self.ui.label_time:setString(T("\230\151\182\233\151\180") .. ed.getUTCLabel())
end

function timeCorridorRecordWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.timeCorridorRecordWin)
  self.ui = ui
  self.container:addChild(layer)
  ed.layout.centerInScreen(self.ui.bg)
  self:initLabels()
end

function timeCorridorRecordWin:initTBView()
  self.records = {}
  local delegate = {
    numberOfCells = function()
      return #self.records
    end,
    cellSizeFromIndex = function(idx)
      return CCSizeMake(610, 36.5)
    end,
    createCell = function(index)
      local container, ui = self:createRecordItem(self.records[index])
      return container
    end,
    syncCell = function(cell, index)
      local container, ui = self:createRecordItem(self.records[index])
      return container
    end,
    doClickIn = function(cell)
    end
  }
  local panel = self.ui.panel_record
  local size = panel:getContentSize()
  local param = {
    delegate = delegate,
    container = panel,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    dragMode = 1,
    colNum = 1,
    touchpriority = -300,
    noshade = true,
    offset = {304.3, 21},
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width + 10, size.height * 0.5),
      barres = "UI/alpha/1080P/timecorridor/timecorridor_progress_2.png",
      bgres = "UI/alpha/1080P/timecorridor/timecorridor_progress_1.png"
    }
  }
  self.tableview = Tableview.create(param)
end

function timeCorridorRecordWin:refreshTBView()
  if #self.records == 0 then
    self.ui.label_no_record:setVisible(true)
    self.tableview.dragList:setVisible(false)
  else
    self.tableview:reloadData()
    self.ui.label_no_record:setVisible(false)
    self.tableview.dragList:setVisible(true)
  end
end

function timeCorridorRecordWin:createRecordItem(data)
  local container, ui = ed.editorui(ed.uieditor.timeCorridorRecordItem)
  local reward = data._reward
  local displayType = "Item"
  local groupId, indexId = ed.timeCorridorMgr:getRewardGroupIndexById(reward._id)
  if groupId then
    displayType = ed.lookupDataTable("TimeCorridorGroup", "Display Type", groupId, indexId)
  end
  ui.label_type:setString(displayTypeDict[displayType] or T("\233\129\147\229\133\183"))
  local name = ed.lookupDataTable("equip", "Name", reward._id)
  if reward._amount > 1 then
    name = name .. "*" .. reward._amount
  elseif data._is_smash == 1 then
    local tokenName = ed.lookupDataTable("equip", "Name", ed.timeCorridorMgr.tokenId)
    name = name .. string.format("(%sx%s)", tokenName, ed.timeCorridorMgr:getRewardSmashNumById(reward._id))
  end
  ui.label_name:setString(name)
  ui.label_name:limitSizeByScale(265, 40)
  ui.label_name:setHorizontalAlignment(kCCTextAlignmentCenter)
  local quality = ed.readequip.quality(reward._id)
  if 8 <= quality then
    ed.setLabelColor(ui.label_name, ccc3(240, 149, 19))
  end
  ui.label_time:setString(ed.getYMDHMSTime(ed.time2Server(data._time)))
  return container, ui
end

function timeCorridorRecordWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
