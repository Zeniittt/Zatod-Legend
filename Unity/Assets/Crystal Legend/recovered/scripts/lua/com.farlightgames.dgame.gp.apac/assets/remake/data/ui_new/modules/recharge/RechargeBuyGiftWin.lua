local base = ed.ui.popwindow
local RechargeBuyGiftWin = newclass(base.mt)
ed.ui.RechargeBuyGiftWin = RechargeBuyGiftWin

function RechargeBuyGiftWin.create(params)
  local self = base.create("RechargeBuyGiftWin")
  setmetatable(self, RechargeBuyGiftWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function RechargeBuyGiftWin:initData(params)
  params = params or {}
  self.callback = params.callback
  self.rechargeItem = params.data
end

function RechargeBuyGiftWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function RechargeBuyGiftWin:doClickInList()
  local function handler(x, y, v)
    ed.ui.packageDetailWin.create(v.data):popWindow()
  end
  
  return handler
end

function RechargeBuyGiftWin:cancelPressInList()
  local function handler(x, y, v)
  end
  
  return handler
end

function RechargeBuyGiftWin:initLabels()
  ed.setLabelStroke(self.ui.label_contain, ed.toccc3(5066061), 1)
  ed.setLabelStroke(self.ui.name, ed.toccc3(2826261), 1)
  ed.setLabelStroke(self.ui.times, ed.toccc3(2826261), 1)
  ed.setLabelShadow(self.ui.title, ed.toccc3(2826261), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_buy, ed.toccc3(0), ccp(1, 1))
end

function RechargeBuyGiftWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.BuyGiftBox, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local icon = ed.createSprite(self.rechargeItem.iconRes)
  ed.UITool.replaceUI(ui, "bg_icon", "icon", icon)
  local costDisplay = ed.RechargeManager:getCostDisplayByCNYCost(self.rechargeItem.CNYCost)
  ed.setString(ui.label_buy, costDisplay)
  ed.setString(ui.name, self.rechargeItem.title)
  ed.adaptLabel(ui.name, {maxWidth = 150, minScale = 0.9})
  ui.name:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.setString(ui.times, string.format(T("\233\153\144\232\180\173\230\149\176\233\135\143\239\188\154%d/%d"), self.rechargeItem.buyCount, self.rechargeItem.buyLimit))
  local bottomY = ui.name:getPositionY() - ui.name:getContentSize().height * 0.5 - 2
  ui.times:setPositionY(bottomY - ui.times:getContentSize().height * 0.5)
  if self.rechargeItem.resType then
    ed.setTexture(ui.bg_icon, string.format("UI/alpha/1080P/newshop/gift%s.png", self.rechargeItem.resType))
    ed.setTexture(ui.bg_contain, string.format("UI/alpha/1080P/newshop/gift%s_bg_title.png", self.rechargeItem.resType))
  end
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function RechargeBuyGiftWin:createRewardItem(data)
  local container, ui = ed.editorui(ed.uieditor.GiftRewardItem)
  ed.setLabelStroke(ui.label_name, ed.toccc3(2826261), 1)
  local icon = ed.createItemIcon({
    type = data.type,
    id = data.id,
    amount = 1
  })
  ed.UITool.replaceUI(ui, "bg", "icon", icon)
  if data.type == "Item" then
    ed.setString(ui.label_name, ed.getDataTable("equip")[data.id].Name .. " x" .. data.amount)
  elseif data.type == "Diamond" then
    ed.setString(ui.label_name, T("\233\146\187\231\159\179 x") .. data.amount)
  elseif data.type == "Gold" then
    ed.setString(ui.label_name, T("\233\135\145\229\184\129 x") .. data.amount)
  end
  ui.label_name:setDimensions(CCSizeMake(200, 0))
  return container, ui
end

function RechargeBuyGiftWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  local oy = self.ui.layer_item:getContentSize().height
  local centerX = self.ui.layer_item:getContentSize().width / 2
  
  local function getPos(i)
    return ccp(2, oy - 59 * i)
  end
  
  self.listData = self.rechargeItem.rewards or {}
  for k, v in ipairs(self.listData) do
    local container, ui = self:createRewardItem(v)
    ui.data = v
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    local pos = getPos(k)
    container:setPosition(pos)
    if k ~= #self.listData then
      local line = ed.createSprite("UI/alpha/1080P/newshop/gift_bg1.png")
      line:setPosition(ccp(centerX, pos.y - 4))
      self.draglist:addItem(line)
    end
  end
  self.uiList = uiList
  self.draglist:initListHeight(#self.listData * 59)
end

function RechargeBuyGiftWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_buy", function()
    if self.callback then
      self.callback()
    end
    self:destroy()
  end, {pressScale = 0.95})
end
