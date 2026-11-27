local base = ed.ui.popwindow
local FireForgeComposeWin = {}
FireForgeComposeWin.__index = FireForgeComposeWin
setmetatable(FireForgeComposeWin, base.mt)
ed.ui.FireForgeComposeWin = FireForgeComposeWin
local dx, dy = 85, 100
local colNum = 9

function FireForgeComposeWin.create(param)
  local self = base.create("FireForgeComposeWin")
  setmetatable(self, FireForgeComposeWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  return self
end

function FireForgeComposeWin:initData(param)
  self.ItemIDArray = param.canComposeList
  self.callback = param.callback
  self.isAllSelected = true
  self.allNumber = #self.ItemIDArray
  self.selectedNumber = #self.ItemIDArray
  for k, item in ipairs(self.ItemIDArray) do
    item.composeAmount = math.floor(item.fragmentAmount / item.needAmount)
    if item.isOnly then
      item.composeAmount = 1
    end
    item.isSelected = true
  end
end

function FireForgeComposeWin:doPressInList()
  local function handler(x, y)
    for k, v in pairs(self.uiList) do
      if ed.containsPoint(v.icon, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function FireForgeComposeWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.icon, x, y) then
      local isSelected = v.selectIcon:isVisible()
      if isSelected then
        self.selectedNumber = self.selectedNumber - 1
        if self.selectedNumber ~= #self.ItemIDArray then
          self.isAllSelected = false
        end
      else
        self.selectedNumber = self.selectedNumber + 1
        if self.selectedNumber == #self.ItemIDArray then
          self.isAllSelected = true
        end
      end
      for k, item in ipairs(self.ItemIDArray) do
        if v.equipId == item.equipId then
          item.isSelected = not isSelected
        end
      end
      self:refreshUI()
      v.selectIcon:setVisible(not isSelected)
    end
  end
  
  return handler
end

function FireForgeComposeWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function FireForgeComposeWin:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function FireForgeComposeWin:initLabels()
  ed.setLabelStroke(self.ui.label_money, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_number2, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_number1, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.label_title, ed.toccc3(2565412), ccp(0, 2))
  ed.setLabelShadow(self.ui.Label_1531, ed.toccc3(2565412), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_price, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_all_selected, ed.toccc3(2565412), 1)
end

function FireForgeComposeWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.package_quick_compose)
  self.ui.label_money:setVisible(false)
  self.ui.label_price:setVisible(false)
  self.ui.icon_money:setVisible(false)
  self:initLabels()
  self:createDraglist()
  self:refreshDraglist()
  self:refreshUI()
end

local function getItemPos(i)
  local ox, oy = 50, 260
  local x, y = 0, 0
  local row = math.floor((i - 1) / colNum)
  local col = i - row * colNum - 1
  x = ox + dx * col
  y = oy - dy * row
  return ccp(x, y)
end

function FireForgeComposeWin:refreshDraglist()
  self.uiList = {}
  for k, item in ipairs(self.ItemIDArray) do
    local container, ui = self:getItem(item)
    ui.equipId = item.equipId
    self.draglist:addItem(container)
    table.insert(self.uiList, ui)
    container:setPosition(getItemPos(k))
  end
  local rowNum = math.floor((#self.ItemIDArray + 8) / colNum)
  self.draglist:initListHeight(rowNum * dy)
end

function FireForgeComposeWin:getItem(item)
  local container, ui = ed.editorui(ed.uieditor.package_fragment)
  local icon = ed.readequip.createIcon(item.fragmentId)
  ui.icon = icon
  ed.setLabelStroke(ui.label_percent, ed.toccc3(2565412), 1)
  ed.setString(ui.label_percent, string.format("%d/%d", item.fragmentAmount, item.needAmount))
  local scale = item.fragmentAmount / item.needAmount
  if 1 < scale then
    scale = 1
  end
  ui.percent:setScaleX(scale)
  ed.below2(ui.bg_precent, icon, -3)
  ui.bg_precent:setPositionX(-33)
  local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
  selectIcon:setPosition(ed.getCenterPos(icon))
  selectIcon:setScale(0.9)
  local shadeLayer = ed.createSprite("UI/alpha/1080P/common/frame/fragment_stencil.png")
  shadeLayer:setPosition(ed.getCenterPos(icon))
  shadeLayer:addChild(selectIcon)
  icon:addChild(shadeLayer)
  ui.selectIcon = selectIcon
  container:addChild(icon)
  return container, ui
end

function FireForgeComposeWin:refreshUI()
  self.ui.ImageView_892:setVisible(self.isAllSelected)
  ed.setString(self.ui.label_number2, "/" .. self.allNumber)
  ed.setString(self.ui.label_number1, string.format(T("\229\183\178\233\128\137\230\139\169:%d"), self.selectedNumber))
  self.ui.btn_compose:setVisible(self.selectedNumber ~= 0)
  self.ui.right_deco:setScaleX(-1)
end

function FireForgeComposeWin:destroy()
  FireEvent("PackageRefresh")
  base.destroy(self)
end

function FireForgeComposeWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {
    clickInterval = 0.5,
    pressScale = 0.75,
    normalScale = 0.8
  })
  ed.UITool.registerBtn(self, "btn_compose", function()
    local list = {}
    for _, v in ipairs(self.ItemIDArray) do
      if v.isSelected then
        local param = {
          _id = v.equipId,
          _amount = v.composeAmount
        }
        table.insert(list, param)
      end
    end
    ed.legendEquipNet.sendFragmentCompose(list)
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_all_selected", function()
    for k, v in ipairs(self.ItemIDArray) do
      v.isSelected = not self.isAllSelected
    end
    if self.isAllSelected then
      self.selectedNumber = 0
    else
      self.selectedNumber = self.allNumber
    end
    for k, v in pairs(self.uiList) do
      v.selectIcon:setVisible(not self.isAllSelected)
    end
    self.isAllSelected = not self.isAllSelected
    self:refreshUI()
  end, {pressScale = 0.9})
end
