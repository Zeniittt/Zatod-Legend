local base = ed.ui.popwindow
local summonRecordWin = newclass(base.mt)
ed.ui.summonRecordWin = summonRecordWin
local summonTypeConfig = {
  {
    type = "normal",
    name = T("\232\139\177\233\155\132\229\143\172\229\148\164")
  },
  {
    type = "destiny",
    name = T("\229\145\189\229\174\154\229\143\172\229\148\164")
  },
  {
    type = "timely",
    name = T("\233\153\144\230\151\182\229\143\172\229\148\164")
  },
  {
    type = "beginner",
    name = T("\230\150\176\230\137\139\229\143\172\229\148\164")
  },
  {
    type = "rise_star",
    name = T("\230\152\159\232\190\137\229\143\172\229\148\164")
  }
}

function summonRecordWin:initData(params)
  local params = params or {}
  self.tabIndex = params.tabIndex or 1
  self.parent = params.parent
  self.isNewbieSummonOpen = self.parent.isNewbieSummonOpen
  self.isRiseStarSummonOpen = self.parent.isRiseStarSummonOpen
  self.isOpenSelectPanel = false
  ed.summonNet:send("query_records", {
    _type = summonTypeConfig[self.tabIndex].type or "normal"
  })
end

function summonRecordWin:refreshTips(preSpecial)
  local tip = {
    T("3\230\152\159"),
    T("\229\145\189\229\174\154"),
    T("3\230\152\159"),
    T("3\230\152\159")
  }
  local autoText = ed.ui.autoText.new()
  local desc = string.format(T("\232\183\157\231\166\187\228\184\138\230\172\161\229\135\186%s\229\183\178\231\187\143<lable color=ccc3(254,211,109)>%d</lable>\230\138\189"), tip[self.tabIndex], preSpecial or 999)
  autoText:initParam({
    context = desc,
    fontSize = 14,
    fontColor = ccc3(0, 0, 0),
    strokeColor = ccc3(0, 0, 0),
    strokeSize = 1
  })
  local curWidth = autoText:getCurContentSize()
  ed.UITool.replaceUI(self.ui, "bg", "desc", autoText.node)
  autoText.node:setPositionX(autoText.node:getPositionX() - curWidth / 2)
end

function summonRecordWin:initLabels()
  local autoText = ed.ui.autoText.new()
  local desc = string.format(T("<lable color=ccc3(186,186,186)>\230\175\143\228\184\170\229\141\161\230\177\160\230\156\128\229\164\154\229\143\175\228\187\165\230\159\165\231\156\139</lable>") .. T("<lable color=ccc3(254,211,109)>200</lable><lable color=ccc3(186,186,186)>\230\157\161\232\174\176\229\189\149</lable>"))
  autoText:initParam({context = desc, fontSize = 14})
  local curWidth = autoText:getCurContentSize()
  ed.UITool.replaceUI(self.ui, "bg", "desc", autoText.node)
  autoText.node:setPositionX(autoText.node:getPositionX() - curWidth / 2)
  self.ui.type:setString(summonTypeConfig[self.tabIndex].name)
  ed.adaptLabel(self.ui.title, {maxWidth = 120, minScale = 0.7})
  ed.adaptLabel(self.ui.type, {maxWidth = 65, minScale = 0.5})
end

function summonRecordWin:createRecordItem(data)
  local container, ui = ed.editorui(ed.uieditor.summonRecordItem)
  ed.setLabelShadow(ui.name, ed.toccc3(0), ccp(1, 1))
  ed.setLabelShadow(ui.item_type, ed.toccc3(0), ccp(1, 1))
  ed.setLabelShadow(ui.type, ed.toccc3(0), ccp(1, 1))
  ed.setLabelShadow(ui.time, ed.toccc3(0), ccp(1, 1))
  ed.setLabelString(ui.type, summonTypeConfig[self.tabIndex].name)
  local isSpecialItem = false
  local reward = data._reward
  local itemName = ""
  if reward._type == "hero" then
    ed.setLabelString(ui.item_type, T("\232\139\177\233\155\132"))
    itemName = ed.getDisplyName(reward._id)
    if ed.readhero.getHeroInitStars(reward._id) >= 3 or self.tabIndex == 2 then
      isSpecialItem = true
    end
  else
    if ed.readequip.value(reward._id, "Category") == T("\231\129\181\233\173\130\231\159\179") then
      ed.setLabelString(ui.item_type, T("\231\129\181\233\173\130\231\159\179"))
    else
      ed.setLabelString(ui.item_type, T("\233\129\147\229\133\183"))
    end
    itemName = ed.getDataTable("equip")[reward._id].Name
    if ed.readequip.value(reward._id, "Category") == T("\231\129\181\233\173\130\231\159\179") and ed.isElementInTable(EDCurLanguage, {"ja", "en"}) then
      itemName = string.gsub(itemName, "%(", [[

(]])
      itemName = string.gsub(itemName, "%\239\188\136", "\n\239\188\136")
    end
  end
  if 1 < reward._amount then
    ed.setLabelString(ui.name, itemName .. "x" .. reward._amount)
  else
    ed.setLabelString(ui.name, itemName)
  end
  ui.name:limitSizeByScale(140, 30)
  ui.name:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.adaptLabel(ui.item_type, {maxWidth = 90, minScale = 0.7})
  ed.setLabelString(ui.time, ed.getYMDHMSTime(ed.time2Server(data._time) or 0))
  if isSpecialItem then
    if self.tabIndex == 2 then
      ed.setLabelColor(ui.name, ed.toccc3(15094504))
      ed.setLabelColor(ui.item_type, ed.toccc3(15094504))
      ed.setLabelColor(ui.type, ed.toccc3(15094504))
      ed.setLabelColor(ui.time, ed.toccc3(15094504))
    else
      ed.setLabelColor(ui.name, ed.toccc3(15249746))
      ed.setLabelColor(ui.item_type, ed.toccc3(15249746))
      ed.setLabelColor(ui.type, ed.toccc3(15249746))
      ed.setLabelColor(ui.time, ed.toccc3(15249746))
    end
  end
  return container, ui
end

function summonRecordWin:refreshDraglist()
  self.draglist:clearList()
  local tabData = self.data
  local size = self.ui.layer_item:getContentSize()
  local perHeight = 37
  for k, v in ipairs(tabData) do
    local container, ui = self:createRecordItem(v)
    self.draglist:addItem(container)
    container:setPosition(ccp(size.width / 2 - 0.2, size.height + perHeight / 2 - perHeight * k))
  end
  self.draglist:initListHeight(perHeight * #tabData)
  self.ui.label_none:setVisible(#tabData == 0)
  self:setTabPanelState(false)
end

function summonRecordWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.summonRecordWin)
  self.ui = ui
  self.container:addChild(layer)
  self:initLabels()
  print("self.isNewbieSummonOpen")
  local offsetY = 0
  if not self.isNewbieSummonOpen then
    offsetY = offsetY - 48.5
  end
  if not self.isRiseStarSummonOpen then
    offsetY = offsetY - 48.5
  end
  if not self.isNewbieSummonOpen and not self.isRiseStarSummonOpen then
    self.ui.bg_tab:setContentSize(CCSizeMake(162, 145.5))
    ed.UITool.setPositionBy(self.ui.bg_tab, ccp(0, 97))
  else
    if not self.isNewbieSummonOpen or not self.isRiseStarSummonOpen then
      self.ui.bg_tab:setContentSize(CCSizeMake(162, 195))
      ed.UITool.setPositionBy(self.ui.bg_tab, ccp(0, 72.75))
    else
    end
  end
  self.ui.label_beginner:setVisible(self.isNewbieSummonOpen)
  self.ui.label_rise_star:setVisible(self.isRiseStarSummonOpen)
  if offsetY ~= 0 then
    ed.UITool.setPositionBy(self.ui.label_destiny, ccp(0, offsetY))
    ed.UITool.setPositionBy(self.ui.label_timely, ccp(0, offsetY))
    ed.UITool.setPositionBy(self.ui.label_normal, ccp(0, offsetY))
    if self.isNewbieSummonOpen then
      ed.UITool.setPositionBy(self.ui.label_beginner, ccp(0, offsetY))
    end
  end
  if not ed.isAreaZhCn() then
    ed.setLabelString(self.ui.time, T("\230\151\182\233\151\180") .. " (UTC)")
  end
  self:createTableView()
end

function summonRecordWin:setDelegate()
  local dlgt = {}
  local records = self.data or {}
  
  function dlgt.numberOfCells()
    return #records
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(604.5, 37)
  end
  
  function dlgt.createCell(idx)
    local container, ui = self:createRecordItem(records[idx])
    return container
  end
  
  function dlgt.syncCell(cell, idx)
    local container, ui = self:createRecordItem(records[idx])
    return container
  end
  
  function dlgt.doClickIn(cell)
  end
  
  return dlgt
end

function summonRecordWin:createTableView()
  self.tb_dlgt = self:setDelegate()
  local list = self.ui.layer_item
  local param = {
    delegate = self.tb_dlgt,
    container = list,
    cliprect = CCRectMake(0, 0, list:getContentSize().width, list:getContentSize().height),
    dragMode = 1,
    colNum = 1,
    touchpriority = -300,
    noshade = true,
    offset = {303, 17},
    bar = {
      bglen = ed.DGLen(606),
      bgpos = ed.DGccp(-10, 303)
    }
  }
  self.tableview = Tableview.create(param)
end

function summonRecordWin:setTabPanelState(flag)
  self.isOpenSelectPanel = flag
  local res = flag and "UI/alpha/1080P/summon/record/summon_record_arrow_up.png" or "UI/alpha/1080P/summon/record/summon_record_arrow_down.png"
  if flag then
    self.ui.icon_selected:setPositionY(16)
    ed.setTexture(self.ui.btn_selected, "UI/alpha/1080P/summon/record/summon_record_select_button1.png")
  else
    self.ui.icon_selected:setPositionY(14.25)
    ed.setTexture(self.ui.btn_selected, "UI/alpha/1080P/summon/record/summon_record_select_button2.png")
  end
  ed.setTexture(self.ui.icon_selected, res)
  local posY = self.ui["label_" .. summonTypeConfig[self.tabIndex].type]:getPositionY()
  self.ui.tab_selected:setPositionY(posY)
  self.ui.bg_tab:setVisible(self.isOpenSelectPanel)
end

function summonRecordWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "click_out",
    clickHandler = function()
      self:destroy()
    end,
    force = true,
    priority = -301
  })
  ed.UITool.registerBtn(self, "btn_selected", function()
    self.isOpenSelectPanel = not self.isOpenSelectPanel
    self:setTabPanelState(self.isOpenSelectPanel)
  end, {priority = -301})
  if self.isRiseStarSummonOpen then
    self:btRegisterRectClick({
      rect = CCRectMake(0, -97, 162, 48.5),
      parent = self.ui.Panel_122,
      key = "tab5",
      clickHandler = function()
        if self.isOpenSelectPanel and self.tabIndex ~= 5 then
          self.ui.tab_selected:setPositionY(self.ui.label_rise_star:getPositionY())
          ed.summonNet:send("query_records", {_type = "rise_star"})
        end
      end,
      force = true,
      priority = -301
    })
  end
  if self.isNewbieSummonOpen then
    self:btRegisterRectClick({
      rect = CCRectMake(0, -48.5, 162, 48.5),
      parent = self.ui.Panel_122,
      key = "tab4",
      clickHandler = function()
        if self.isOpenSelectPanel and self.tabIndex ~= 4 then
          self.ui.tab_selected:setPositionY(self.ui.label_beginner:getPositionY())
          ed.summonNet:send("query_records", {_type = "beginner"})
        end
      end,
      force = true,
      priority = -301
    })
  end
  local offsetY = 0
  if not self.isNewbieSummonOpen then
    offsetY = offsetY - 48.5
  end
  if not self.isRiseStarSummonOpen then
    offsetY = offsetY - 48.5
  end
  self:btRegisterRectClick({
    rect = CCRectMake(0, 0 + offsetY, 162, 48.5),
    parent = self.ui.Panel_122,
    key = "tab3",
    clickHandler = function()
      if self.isOpenSelectPanel and self.tabIndex ~= 3 then
        self.ui.tab_selected:setPositionY(self.ui.label_timely:getPositionY())
        ed.summonNet:send("query_records", {_type = "timely"})
      end
    end,
    force = true,
    priority = -301
  })
  self:btRegisterRectClick({
    rect = CCRectMake(0, 48.5 + offsetY, 162, 48.5),
    parent = self.ui.Panel_122,
    key = "tab2",
    clickHandler = function()
      if self.isOpenSelectPanel and self.tabIndex ~= 2 then
        self.ui.tab_selected:setPositionY(self.ui.label_destiny:getPositionY())
        ed.summonNet:send("query_records", {_type = "destiny"})
      end
    end,
    force = true,
    priority = -301
  })
  self:btRegisterRectClick({
    rect = CCRectMake(0, 97 + offsetY, 162, 48.5),
    parent = self.ui.Panel_122,
    key = "tab1",
    clickHandler = function()
      if self.isOpenSelectPanel and self.tabIndex ~= 1 then
        self.ui.tab_selected:setPositionY(self.ui.label_normal:getPositionY())
        ed.summonNet:send("query_records", {_type = "normal"})
      end
    end,
    force = true,
    priority = -301
  })
end

function summonRecordWin:reloadTableView()
  self.tb_dlgt = self:setDelegate()
  self.tableview:setDelegate(self.tb_dlgt)
  self.tableview:reloadData()
end

function summonRecordWin.create(params)
  local self = base.create("summonRecordWin")
  setmetatable(self, summonRecordWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:listenEvent("SummonRecordRefresh", function(data)
    for k, v in ipairs(summonTypeConfig) do
      if v.type == data._type then
        self.tabIndex = k
        break
      end
    end
    self.data = data._records or {}
    self:reloadTableView()
    self:setTabPanelState(false)
    self.ui.type:setString(summonTypeConfig[self.tabIndex].name)
    self.ui.label_none:setVisible(#self.data == 0)
  end)
  self:popWindow()
  self:show()
  return self
end
