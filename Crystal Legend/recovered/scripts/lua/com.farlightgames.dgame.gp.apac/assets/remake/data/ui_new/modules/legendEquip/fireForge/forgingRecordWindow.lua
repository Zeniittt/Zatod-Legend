local base = ed.ui.popwindow
local forgingRecordWindow = newclass(base.mt)
ed.ui.forgingRecordWindow = forgingRecordWindow
forgingRecordWindow.scope = {}
ed.UITool.registViewOpenFunc("forgingRecordWindow", function()
  CloseScope(forgingRecordWindow.scope)
  ListenEventOnce("openForgingRecordWindow", function()
    local window = forgingRecordWindow.create()
    window:popWindow()
    window:show()
  end, forgingRecordWindow.scope)
  ed.legendEquipNet.sendQueryRecord()
end)

function forgingRecordWindow.create()
  local self = base.create("summonRecordWin")
  setmetatable(self, forgingRecordWindow.mt)
  self:init()
  return self
end

function forgingRecordWindow:init()
  self.mgr = ed.legendEquipMgr.getInstance()
  self.recordData = self.mgr.records
  if nil == self.recordData then
    self.recordData = {}
  end
  self:sortDataByDate()
  self:calclulateCostNum()
  self:initUI()
  self:addEventListener()
end

function forgingRecordWindow:reverseTableInPlace(t)
  local i, j = 1, #t
  while i < j do
    t[i], t[j] = t[j], t[i]
    i = i + 1
    j = j - 1
  end
end

function forgingRecordWindow:sortDataByDate()
  self:reverseTableInPlace(self.recordData)
end

function forgingRecordWindow:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg_click,
    key = "click_out",
    clickHandler = function()
      self:destroy()
    end,
    force = true,
    priority = -301
  })
end

function forgingRecordWindow:reloadTableView()
  self.tb_dlgt = self:setDelegate()
  self.tableview:setDelegate(self.tb_dlgt)
  self.tableview:reloadData()
end

function forgingRecordWindow:setDelegate()
  local dlgt = {}
  local records = self.recordData or {}
  
  function dlgt.numberOfCells()
    return #records
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(604.5, 37)
  end
  
  function dlgt.createCell(idx)
    local container, ui = self:createRecordItem(records[idx], idx)
    return container
  end
  
  function dlgt.syncCell(cell, idx)
    local container, ui = self:createRecordItem(records[idx], idx)
    return container
  end
  
  function dlgt.doClickIn(cell)
  end
  
  return dlgt
end

function forgingRecordWindow:createTableView()
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
      bgpos = ed.DGccp(list:getContentSize().width * 2 + 30, 303)
    }
  }
  self.tableview = Tableview.create(param)
end

function forgingRecordWindow:initUI()
  local layer, ui = ed.editorui(ed.uieditor.forgingRecordWin)
  self.ui = ui
  self.container:addChild(layer)
  self:initLabels()
  if not ed.isAreaZhCn() then
    ed.setLabelString(self.ui.time, T("\230\151\182\233\151\180") .. " (UTC)")
  end
  self:createTableView()
end

function forgingRecordWindow:calclulateCostNum()
  local _hasOnlyEquip = false
  local _lastOnlyEquipIndex = 1
  for i = 1, #self.recordData do
    local data = self.recordData[i]
    if data._reward._type == "legend_equip" then
      local legendEquipCfg = ed.getDataTable("LegendEquip")[data._reward._id]
      local isOnly = legendEquipCfg["Is Only"]
      if isOnly then
        _hasOnlyEquip = true
        _lastOnlyEquipIndex = i
        break
      end
    else
      local isOnlyEquip, newEquipId = self:revertLegendEquip(data._reward._id, data._reward._amount)
      if isOnlyEquip then
        _hasOnlyEquip = true
        _lastOnlyEquipIndex = i
        break
      end
    end
  end
  self.hasOnlyEquip = _hasOnlyEquip
  if not self.hasOnlyEquip then
    self.costCount = #self.recordData
  else
    self.costCount = _lastOnlyEquipIndex - 1
  end
end

function forgingRecordWindow:initLabels()
  local autoText = ed.ui.autoText.new()
  local desc
  if self.hasOnlyEquip then
    desc = string.format(T("<lable color=ccc3(255,239,195) strokeColor=forgingRecordStrokeColor strokeSize=1>\232\135\170\228\184\138\230\172\161\233\148\187\233\128\160\229\135\186\229\148\175\228\184\128\232\163\133\229\164\135\228\187\165\230\157\165\239\188\140\229\183\178\231\180\175\232\174\161\233\148\187\233\128\160 </lable>") .. T("<lable color=ccc3(255,250,109)  strokeColor=forgingRecordHighStrokeColor strokeSize=1 fontSize=f16>%s</lable><lable color=ccc3(255,239,195) strokeColor=forgingRecordStrokeColor strokeSize=1 > \230\172\161</lable>"), self.costCount)
  else
    desc = string.format(T("<lable color=ccc3(255,239,195) strokeColor=forgingRecordStrokeColor strokeSize=1>\229\183\178\231\180\175\232\174\161\233\148\187\233\128\160 </lable>") .. T("<lable color=ccc3(255,250,109)  strokeColor=forgingRecordHighStrokeColor strokeSize=1 fontSize=f16>%s</lable><lable color=ccc3(255,239,195) strokeColor=forgingRecordStrokeColor strokeSize=1 > \230\172\161</lable>"), self.costCount)
  end
  autoText:initParam({context = desc, fontSize = 14})
  local curWidth = autoText:getCurContentSize()
  ed.UITool.replaceUI(self.ui, "bg", "desc", autoText.node)
  autoText.node:setPositionX(autoText.node:getPositionX() - curWidth / 2)
  autoText.node:setPositionY(autoText.node:getPositionY() - 2)
  ed.adaptLabel(self.ui.title, {maxWidth = 120, minScale = 0.7})
  ed.adaptLabel(self.ui.type, {maxWidth = 65, minScale = 0.5})
  self.ui.root_none:setVisible(#self.recordData == 0)
  ed.setLabelColor(self.ui.bottom_des, ccc3(174, 130, 131))
  ed.setLabelFontName(self.ui.label_none, ed.fontBold)
  ed.setLabelColor(self.ui.label_none, ccc3(158, 110, 109))
end

function forgingRecordWindow:createRecordItem(data, idx)
  local container, ui = ed.editorui(ed.uieditor.forgingRecordItem)
  local reward = data._reward
  local id = reward._id
  local amount = reward._amount
  local type = 1
  local convert = 1
  local itemName
  if reward._type == "legend_equip" then
    local legendEquipCfg = ed.getDataTable("LegendEquip")[id]
    local isOnly = legendEquipCfg["Is Only"]
    itemName = legendEquipCfg["Equip Name"]
    if isOnly then
      type = 2
    else
      type = 1
    end
  else
    local isOnlyEquip, newEquipId = self:revertLegendEquip(id, amount)
    if isOnlyEquip then
      local legendEquipCfg = ed.getDataTable("LegendEquip")[newEquipId]
      itemName = legendEquipCfg["Equip Name"]
      type = 2
      convert = 2
    else
      local name = ed.lookupDataTable("equip", "Name", reward._id)
      itemName = name
      type = 3
    end
  end
  if convert == 2 then
    ed.setLabelString(ui.name, T(itemName .. "x" .. reward._amount .. "(\229\183\178\232\189\172\231\162\142\231\137\135)"))
  else
    ed.setLabelString(ui.name, itemName .. "x" .. reward._amount)
  end
  if type == 1 then
    ed.setLabelString(ui.item_type, T("\230\153\174\233\128\154\230\149\180\232\163\133"))
    ed.setLabelColor(ui.name, ccc3(206, 156, 73))
    ed.setLabelColor(ui.item_type, ccc3(206, 156, 73))
    ed.setLabelColor(ui.type, ccc3(206, 156, 73))
    ed.setLabelColor(ui.time, ccc3(206, 156, 73))
    ed.setLabelShadow(ui.name, ed.toccc3(0), ccp(1, 1))
    ed.setLabelShadow(ui.item_type, ed.toccc3(0), ccp(1, 1))
    ed.setLabelShadow(ui.type, ed.toccc3(0), ccp(1, 1))
    ed.setLabelShadow(ui.time, ed.toccc3(0), ccp(1, 1))
  elseif type == 2 then
    ed.setLabelString(ui.item_type, T("\229\148\175\228\184\128\230\149\180\232\163\133"))
    ed.setLabelColor(ui.name, ccc3(255, 250, 109))
    ed.setLabelColor(ui.item_type, ccc3(255, 250, 109))
    ed.setLabelColor(ui.type, ccc3(255, 250, 109))
    ed.setLabelColor(ui.time, ccc3(255, 250, 109))
    ed.setLabelShadow(ui.name, ed.toccc3(0), ccp(1, 1))
    ed.setLabelShadow(ui.item_type, ed.toccc3(0), ccp(1, 1))
    ed.setLabelShadow(ui.type, ed.toccc3(0), ccp(1, 1))
    ed.setLabelShadow(ui.time, ed.toccc3(0), ccp(1, 1))
  elseif type == 3 then
    ed.setLabelString(ui.item_type, T("\231\162\142\231\137\135"))
  end
  ui.name:limitSizeByScale(200, 30)
  ui.name:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.adaptLabel(ui.item_type, {maxWidth = 90, minScale = 0.7})
  ed.setLabelString(ui.time, ed.getYMDHMSTime(ed.time2Server(data._time) or 0))
  return container, ui
end

function forgingRecordWindow:revertLegendEquip(equipFragment_id, amount)
  local config = ed.getDataTable("LegendEquip")
  for i, v in pairs(config) do
    if v["Fragment Item"] == equipFragment_id and v["Fragment Amount"] == amount then
      return true, v["Equip ID"]
    end
  end
  return false, equipFragment_id
end

function forgingRecordWindow:refreshDraglist()
  self.draglist:clearList()
  local tabData = self.recordData
  local size = self.ui.layer_item:getContentSize()
  local perHeight = 37
  for k, v in ipairs(tabData) do
    local container, ui = self:createRecordItem(v)
    self.draglist:addItem(container)
    container:setPosition(ccp(size.width / 2 - 0.2, size.height + perHeight / 2 - perHeight * k))
  end
  self.draglist:initListHeight(perHeight * #tabData)
  self.ui.label_none:setVisible(#tabData == 0)
end
