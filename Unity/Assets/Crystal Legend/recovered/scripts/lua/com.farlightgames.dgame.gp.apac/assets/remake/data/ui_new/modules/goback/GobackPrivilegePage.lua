local PrivilegePage = newclass("g")
local GobackMainScene = ed.ui.GobackMainScene
GobackMainScene.privilege = PrivilegePage

function PrivilegePage:initData(param)
  self.scene = param.scene
  self.privilegeList = ed.GobackManager:getPrivilegeList()
end

function PrivilegePage:refreshData()
end

function PrivilegePage:createItem(v)
  local container, ui = ed.editorui(ed.uieditor.GobackPrivilegeItem)
  ed.setString(ui.tip1, T("\229\183\178\231\187\147\230\157\159"))
  local icon = ed.createItemIcon({type = "Diamond", amount = 1})
  icon:setScale(1)
  ed.UITool.replaceUI(ui, "bg", "icon", icon)
  ed.setString(ui.tip2, T("\232\191\156\229\190\129\230\142\137\232\144\189\231\191\187\229\128\141"))
  return container, ui
end

function PrivilegePage:refreshDraglist(v)
  self.uiList = {}
  self.draglist:clearList()
  for k, v in ipairs(self.privilegeList) do
    local container, ui = self:createItem(v)
    ui.data = v
    table.insert(self.uiList, ui)
    container:setPosition(ccp(170 * k - 85, 150))
    self.draglist:addItem(container)
  end
  self.draglist:initListWidth(170 * #self.privilegeList + 10)
end

function PrivilegePage:initUI()
  local container, ui = ed.editorui(ed.uieditor.GobackPrivilegePage)
  self.mainLayer = container
  self.ui = ui
  for i = 1, 3 do
    ed.setLabelStroke(self.ui["time" .. i], ed.toccc3(9380104), 1)
    ed.setLabelStroke(self.ui["btn_label" .. i], ed.toccc3(10641433), 1)
    ed.setTexture(self.ui["item" .. i], self.privilegeList[i].bgRes)
    local text = self.privilegeList[i].buffText
    text = string.gsub(text, "<br/>", "\n")
    local labelText = ed.createttf(text, 18)
    ed.setLabelColor(labelText, ed.toccc3(16776921))
    labelText:limitWidthByScale(200)
    self.ui["title" .. i]:addChild(labelText)
    ed.layout.centerInParent(labelText)
    local endTime = self.privilegeList[i].endTime or 0
    local timeStr = T("\229\183\178\231\187\147\230\157\159")
    if endTime > ed.getServerTime() then
      timeStr = string.format(T("\229\137\169\228\189\153%s"), ed.time2dhmsV2(endTime - ed.getServerTime()))
    end
    ed.setString(self.ui["time" .. i], timeStr)
  end
  self.scene:btRegisterButtonClick({
    button = self.ui.btn1,
    key = "privilege1",
    clickHandler = function(_, x, y)
      if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
        ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167"))
      else
        ed.ui.buyVitalityBox.create()
      end
    end,
    clickInterval = 0.3,
    pressScale = 0.55,
    normalScale = 0.6,
    priority = -1
  })
  self.scene:btRegisterButtonClick({
    button = self.ui.btn2,
    key = "privilege2",
    clickHandler = function(_, x, y)
      ed.pushScene(ed.ui.stageselect.create(nil, "elite"))
    end,
    clickInterval = 0.3,
    pressScale = 0.55,
    normalScale = 0.6,
    priority = -1
  })
  self.scene:btRegisterButtonClick({
    button = self.ui.btn3,
    key = "privilege3",
    clickHandler = function(_, x, y)
      ed.UITool.openView("crusade")
    end,
    clickInterval = 0.3,
    pressScale = 0.55,
    normalScale = 0.6,
    priority = -1
  })
end

function PrivilegePage:refreshUI()
  for i = 1, 3 do
    local endTime = self.privilegeList[i].endTime or 0
    local timeStr = T("\229\183\178\231\187\147\230\157\159")
    if endTime > ed.getServerTime() then
      timeStr = string.format(T("\229\137\169\228\189\153%s"), ed.time2dhmsV2(endTime - ed.getServerTime()))
    end
    ed.setString(self.ui["time" .. i], timeStr)
  end
end

function PrivilegePage:registerTouchHandlers()
end

function PrivilegePage:registerEvents()
end

function PrivilegePage.create(param)
  local self = {}
  setmetatable(self, {__index = PrivilegePage})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
