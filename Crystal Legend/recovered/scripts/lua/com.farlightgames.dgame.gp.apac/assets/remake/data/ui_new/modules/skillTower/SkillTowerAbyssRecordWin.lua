local base = ed.ui.popwindow
local SkillTowerAbyssRecordWin = newclass(base.mt)
ed.ui.SkillTowerAbyssRecordWin = SkillTowerAbyssRecordWin

function SkillTowerAbyssRecordWin.create(params)
  local self = base.create("SkillTowerAbyssRecordWin")
  setmetatable(self, SkillTowerAbyssRecordWin.mt)
  self:initData(params)
  self:initUI()
  self:listenEvent("SkillTowerExPassRecords", function(data)
    self:parseData(data)
    self:refreshDraglist()
  end)
  self:registerTouchHandlers()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
  self:popWindow()
  self:show()
  self:onTypeEvent(1)
  return self
end

function SkillTowerAbyssRecordWin:parseData(data)
  for i, v in ipairs(ed.SkillTowerNetwork.PassRecordType) do
    if v == data._type then
      local tab = {}
      self.recordTab[i] = tab
      for _, vv in ipairs(data._records or {}) do
        table.insert(tab, vv)
      end
    end
  end
end

function SkillTowerAbyssRecordWin:initData(params)
  self.tabIndex = 0
  self.curFloor = params.floor
  self.recordTab = {}
end

function SkillTowerAbyssRecordWin:initTableView()
  self.delegate = {
    numberOfCells = function()
      local dataList = self.recordTab[self.tabIndex]
      if nil == dataList then
        return 0
      else
        return #dataList
      end
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(728, 90)
    end,
    createCell = function(index)
      local dataList = self.recordTab[self.tabIndex]
      local dataItem = dataList[index]
      local container, ui
      if self.tabIndex == 1 then
        container, ui = self:createSelfItem(index, dataItem)
      elseif self.tabIndex == 2 then
        container, ui = self:createOtherItem(index, dataItem)
      end
      return container, {
        data = dataItem,
        ui = ui,
        container = container
      }
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        return ui
      end
    end,
    cancelPressIn = function(cell)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      local uiData = data.data
      if self.tabIndex == 2 and ed.containsPoint(ui.head, x, y) then
        ed.registerNetReply("req_home_page", function(data)
          local panel = ed.ui.PlayerInfoPanel.create(data, false)
          panel:popWindow()
        end)
        ed.PlayerInfoNetwork:requestHomePage(uiData._user_summary._role_id)
        return
      end
    end
  }
  local size = self.ui.layer_item:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {3, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function SkillTowerAbyssRecordWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.SkillTowerAbyssRecordWin)
  local title = ed.ui.gradientLabel.create({
    text = T("\233\128\154\229\133\179\232\174\176\229\189\149 | \231\172\172%s\229\177\130", ed.numberToChinese(self.curFloor)),
    fontSize = 22,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16711611)
  })
  self.ui.bg:addChild(title.node)
  title.node:setPosition(ccp(self.ui.bg:getContentSize().width * 0.5, 404))
  self:initTableView()
  self.ui.label_self_selected:limitWidthByScale(55)
  self.ui.label_self:limitWidthByScale(55)
  self.ui.label_guild_selected:limitSizeByScale(55, 30)
  self.ui.label_guild:limitSizeByScale(55, 30)
end

function SkillTowerAbyssRecordWin:createSelfItem(rank, data)
  local container, ui = ed.editorui(ed.uieditor.SkillTowerAbyssRecordSelfItem)
  ed.setLabelStroke(ui.label_des, ed.toccc3(1642242), 1)
  ed.setLabelStroke(ui.label_time, ed.toccc3(1642242), 1)
  local iconSize = 78
  local iconSpace = 4
  local iconScale = 0.7
  ui.heroIconArr = {}
  for i, v in ipairs(data._heroes or {}) do
    local headIcon = ed.readhero.createIconByServer(v)
    headIcon.icon:setScale(iconScale)
    headIcon.icon:setPosition(ccp((iconSize * iconScale + iconSpace) * (i - 1) + iconSize * iconScale * 0.5, ui.panel_heroes:getContentSize().height * 0.5))
    ui.panel_heroes:addChild(headIcon.icon)
    table.insert(ui.heroIconArr, headIcon.icon)
  end
  ed.setString(ui.label_time, ed.gethmsNString(data._time))
  return container, ui
end

function SkillTowerAbyssRecordWin:createOtherItem(rank, data)
  local container, ui = ed.editorui(ed.uieditor.SkillTowerAbyssRecordOtherItem)
  ed.setLabelStroke(ui.label_des, ed.toccc3(1642242), 1)
  ed.setLabelStroke(ui.label_time, ed.toccc3(1642242), 1)
  ed.setLabelStroke(ui.name, ed.toccc3(1642242), 1)
  ed.setLabelStroke(ui.guildname, ed.toccc3(1642242), 1)
  local iconSize = 78
  local iconSpace = 4
  local iconScale = 0.7
  ui.heroIconArr = {}
  for i, v in ipairs(data._heroes or {}) do
    local headIcon = ed.readhero.createIconByServer(v)
    headIcon.icon:setScale(iconScale)
    headIcon.icon:setPosition(ccp((iconSize * iconScale + iconSpace) * (i - 1) + iconSize * iconScale * 0.5, ui.panel_heroes:getContentSize().height * 0.5))
    ui.panel_heroes:addChild(headIcon.icon)
    table.insert(ui.heroIconArr, headIcon.icon)
  end
  local summary = data._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.83,
    lvoffset = {x = -47.5, y = -30}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "head", head)
  ui.head = headIcon
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ui.name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "bg", "name", name)
  if summary._guild_name then
    ed.setString(ui.guildname, summary._guild_name)
  end
  ed.setString(ui.label_time, ed.gethmsNString(data._time))
  return container, ui
end

function SkillTowerAbyssRecordWin:refreshDraglist()
  local rankList = self.recordTab[self.tabIndex]
  if nil == rankList or 0 == #rankList then
    self.ui.label_empty:setVisible(true)
    self.ui.layer_item:setVisible(false)
  else
    self.ui.label_empty:setVisible(false)
    self.ui.layer_item:setVisible(true)
    self.tableView:reloadData()
  end
end

function SkillTowerAbyssRecordWin:refreshSomeUI()
  self.ui.btn_self_selected:setVisible(self.tabIndex == 1)
  self.ui.btn_guild_selected:setVisible(self.tabIndex == 2)
  self.ui.btn_self:setVisible(self.tabIndex ~= 1)
  self.ui.btn_guild:setVisible(self.tabIndex ~= 2)
end

function SkillTowerAbyssRecordWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "close",
    clickHandler = function()
      self:destroy()
    end,
    extraCheckHandler = function(x, y)
      if ed.containsPoint(self.ui.btn_self_selected, x, y) or ed.containsPoint(self.ui.btn_guild_selected, x, y) then
        return false
      else
        return true
      end
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_self", function()
    if self.tabIndex == 1 then
      return
    end
    self:onTypeEvent(1)
  end)
  ed.UITool.registerBtn(self, "btn_guild", function()
    if self.tabIndex == 2 then
      return
    end
    self:onTypeEvent(2)
  end)
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end)
end

function SkillTowerAbyssRecordWin:onTypeEvent(index)
  self.tabIndex = index
  self:refreshSomeUI()
  local dataList = self.recordTab[self.tabIndex]
  if nil == dataList then
    ed.SkillTowerNetwork:sendExTowerPassRecords(self.tabIndex, self.curFloor)
  else
    self:refreshDraglist()
  end
end
