local base = ed.ui.popwindow
local PackageComposeWin = {}
PackageComposeWin.__index = PackageComposeWin
setmetatable(PackageComposeWin, base.mt)
ed.ui.PackageComposeWin = PackageComposeWin
local PackageComposeWinScope = {}
local dx, dy = 85, 100
local colNum = 9

function PackageComposeWin.create(param)
  local self = base.create("PackageComposeWin")
  setmetatable(self, PackageComposeWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  return self
end

function PackageComposeWin:initData(param)
  self.ItemIDArray = param.canComposeList
  self.callback = param.callback
  self.isAllSelected = true
  self.allNumber = #self.ItemIDArray
  self.selectedNumber = #self.ItemIDArray
  self.price = 0
  for k, item in ipairs(self.ItemIDArray) do
    local moneyCost = item.cost * math.floor(item.amount / item.need)
    self.price = self.price + moneyCost
    item.isSelected = true
  end
end

function PackageComposeWin:doPressInList()
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

function PackageComposeWin:doClickInList()
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
        if v.id == item.id then
          item.isSelected = not isSelected
          local moneyCost = item.cost * math.floor(item.amount / item.need)
          if isSelected then
            self.price = self.price - moneyCost
          else
            self.price = self.price + moneyCost
          end
        end
      end
      self:refreshUI()
      v.selectIcon:setVisible(not isSelected)
    end
  end
  
  return handler
end

function PackageComposeWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function PackageComposeWin:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function PackageComposeWin:initLabels()
  ed.setLabelStroke(self.ui.label_money, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_number2, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_number1, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.label_title, ed.toccc3(2565412), ccp(0, 2))
  ed.setLabelShadow(self.ui.Label_1531, ed.toccc3(2565412), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_price, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_all_selected, ed.toccc3(2565412), 1)
end

function PackageComposeWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.package_quick_compose)
  self.ui.label_money:setPositionX(self.ui.label_price:getPositionX() + self.ui.label_price:getContentSize().width / 2 + 3)
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

function PackageComposeWin:refreshDraglist()
  self.uiList = {}
  for k, item in ipairs(self.ItemIDArray) do
    local container, ui = self:getItem(item)
    ui.id = item.id
    self.draglist:addItem(container)
    table.insert(self.uiList, ui)
    container:setPosition(getItemPos(k))
  end
  local rowNum = math.floor((#self.ItemIDArray + 8) / colNum)
  self.draglist:initListHeight(rowNum * dy)
end

function PackageComposeWin:getItem(item)
  local container, ui = ed.editorui(ed.uieditor.package_fragment)
  local icon = ed.readequip.createIcon(item.id)
  ui.icon = icon
  ed.setLabelStroke(ui.label_percent, ed.toccc3(2565412), 1)
  ed.setString(ui.label_percent, string.format("%d/%d", item.amount, item.need))
  local scale = item.amount / item.need
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

function PackageComposeWin:refreshUI()
  self.ui.ImageView_892:setVisible(self.isAllSelected)
  ed.setString(self.ui.label_money, self.price)
  if ed.player._money < self.price then
    self.ui.label_money:setColor(ccc3(255, 0, 0))
  else
    self.ui.label_money:setColor(ccc3(255, 248, 192))
  end
  ed.setString(self.ui.label_number2, "/" .. self.allNumber)
  ed.setString(self.ui.label_number1, string.format(T("\229\183\178\233\128\137\230\139\169:%d"), self.selectedNumber))
  ed.right2(self.ui.icon_money, self.ui.label_money, 2)
  self.ui.btn_compose:setVisible(self.selectedNumber ~= 0)
  self.ui.right_deco:setScaleX(-1)
end

function PackageComposeWin:doReply(msg)
  if msg._result == "success" then
    local list = self.ItemIDArray
    local items = {}
    for k, param in ipairs(list) do
      if param.isSelected then
        local moneyCost = param.cost * math.floor(param.amount / param.need)
        local cost = param.need * math.floor(param.amount / param.need)
        local id = param.id
        local makeId = param.makeId
        local count = math.floor(param.amount / param.need)
        ed.player:addMoney(-moneyCost)
        ed.player:consumeEquip(id, cost)
        ed.player:addEquip(makeId, count)
        table.insert(items, {
          type = "Item",
          id = makeId,
          amount = count
        })
      end
    end
    ed.announce({
      type = "getProp",
      param = {
        title = T("\228\189\160\232\142\183\229\190\151\228\186\134\230\150\176\231\137\169\229\147\129"),
        items = items
      }
    })
    self:destroy()
  else
    ed.showToast(T("\229\144\136\230\136\144\229\164\177\232\180\165"))
  end
end

function PackageComposeWin:destroy()
  FireEvent("PackageRefresh")
  base.destroy(self)
end

function PackageComposeWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {
    clickInterval = 0.5,
    pressScale = 0.75,
    normalScale = 0.8
  })
  ed.UITool.registerBtn(self, "btn_compose", function()
    if ed.player._money < self.price then
      ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
      return
    end
    for _, v in ipairs(self.ItemIDArray) do
      local count = math.floor(v.amount / v.need)
      if v.isSelected and ed.player:getEquipAmount(v.makeId) + count > ed.player:getItemMaxAmount(v.makeId) then
        ed.showToast(T("\229\144\136\230\136\144\229\144\142\231\137\169\229\147\129\229\176\134\232\182\133\232\191\135\230\140\129\230\156\137\228\184\138\233\153\144\239\188\140\229\144\136\230\136\144\229\164\177\232\180\165\239\188\129"))
        return
      end
    end
    local msg = ed.upmsg.fragment_compose_auto()
    local list = {}
    for _, v in ipairs(self.ItemIDArray) do
      if v.isSelected then
        local num = math.floor(v.amount / v.need)
        local total = num * v.need
        local param = {
          _fragment = v.makeId,
          _frag_amount = total,
          _compose_amount = num
        }
        table.insert(list, param)
      end
    end
    msg._fragments = list
    ed.send(msg, "fragment_compose_auto")
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_all_selected", function()
    for k, v in ipairs(self.ItemIDArray) do
      v.isSelected = not self.isAllSelected
    end
    if self.isAllSelected then
      self.selectedNumber = 0
      self.price = 0
    else
      self.selectedNumber = self.allNumber
      local price = 0
      for k, item in ipairs(self.ItemIDArray) do
        local moneyCost = item.cost * math.floor(item.amount / item.need)
        price = price + moneyCost
      end
      self.price = price
    end
    for k, v in pairs(self.uiList) do
      v.selectIcon:setVisible(not self.isAllSelected)
    end
    self.isAllSelected = not self.isAllSelected
    self:refreshUI()
  end, {pressScale = 0.9})
  self:listenEvent("fragment_compose_auto", function(msg)
    self:doReply(msg)
  end)
end
