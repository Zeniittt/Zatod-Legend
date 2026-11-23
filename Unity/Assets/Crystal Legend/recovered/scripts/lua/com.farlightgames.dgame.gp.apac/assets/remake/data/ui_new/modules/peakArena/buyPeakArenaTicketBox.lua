local base = ed.ui.popwindow
local BuyPeakArenaTicketBox = newclass(base.mt)
ed.ui.BuyPeakArenaTicketBox = BuyPeakArenaTicketBox

function BuyPeakArenaTicketBox:initData()
  self.mgr = ed.PeakArenaManager
  self.useTimes = self.mgr:getTicketUseCount()
  self.maxTimes = self.mgr:getTicketMaxUseCount()
  self.items = {}
  if self.mgr:isOnSeason() then
    local amount = self.mgr:getTimesTicketAmount() or 0
    if 0 < amount then
      local itemId = self.mgr:getTimesTicketEquipId()
      table.insert(self.items, {id = itemId, amount = amount})
    end
  end
end

function BuyPeakArenaTicketBox:getBuyKeyPrice()
  return ed.getDataTable("PeakArenaConfig")["Challenge Buy Price"].Value[1 + self.mgr.keyUseCount] or 100
end

function BuyPeakArenaTicketBox:createBuyVitalityItem()
  local container, ui = ed.editorui(ed.uieditor.buyVitalityItem1)
  ed.setTexture(ui.ImageView_13691, "UI/alpha/1080P/toparena/toparena_key_icon.jpg")
  self.needDiamonds = self:getBuyKeyPrice()
  ed.setLabelStroke(ui.title, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.num, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.desc, ccc3(57, 36, 21), 1)
  ed.setLabelShadow(ui.label_buy, ccc3(0, 0, 0), ccp(1, 1))
  ed.setString(ui.desc, T("\229\143\175\228\187\165\232\161\165\229\133\1335\230\172\161\230\140\145\230\136\152\230\172\161\230\149\176"))
  ed.setString(ui.num, self.needDiamonds)
  ed.setString(ui.label_times, string.format(T("\228\187\138\230\151\165\233\153\144\232\180\173 %d/%d\230\172\161"), self.mgr.keyUseCount, self.mgr.keyMaxUseCount))
  ed.setString(ui.title, T("\229\133\165\229\156\186\233\146\165\229\140\153"))
  return container, ui
end

function BuyPeakArenaTicketBox:createVitalityItem(v)
  local container, ui = ed.editorui(ed.uieditor.buyVitalityItem2)
  ed.setLabelStroke(ui.title, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.use_amount, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.desc, ccc3(57, 36, 21), 1)
  ed.setLabelShadow(ui.label_use, ccc3(0, 0, 0), ccp(1, 1))
  ed.setString(ui.use_amount, 1)
  local itemData = ed.getDataTable("equip")[v.id]
  ed.setString(ui.title, itemData.Name)
  ed.setString(ui.desc, T("\229\143\175\228\187\165\232\161\165\229\133\1335\230\172\161\230\140\145\230\136\152\230\172\161\230\149\176"))
  local amount = ed.player.equip_qunty[v.id] or 0
  local icon = ed.readequip.createIconWithAmount(v.id, 75, amount)
  ed.UITool.replaceUI(ui, "bg", "icon", icon)
  ui.minus_button:setVisible(false)
  ui.add_button:setVisible(false)
  ui.bg_number:setVisible(false)
  local labelTimes = ed.createttf(string.format(T("\228\187\138\230\151\165\228\189\191\231\148\168\230\172\161\230\149\176 %d/%d\230\172\161"), self.useTimes, self.maxTimes), 12)
  labelTimes:setPosition(ccp(447.25, 62))
  labelTimes:setColor(ccc3(67, 59, 56))
  ui.bg:addChild(labelTimes)
  ui.btn_use:setPositionY(32)
  return container, ui
end

function BuyPeakArenaTicketBox:refreshDraglist()
  self.draglist:clearList()
  local dy, py = 84, 2
  local ox = self.ui.layer_item:getContentSize().width / 2
  local oy = self.ui.layer_item:getContentSize().height + dy / 2 + py
  
  local function getPos(i)
    return ccp(ox, oy - (dy + py) * i)
  end
  
  self.uiList = {}
  local container, ui = self:createBuyVitalityItem()
  container:setPosition(getPos(1))
  self.draglist:addItem(container)
  table.insert(self.uiList, ui)
  for k, v in ipairs(self.items or {}) do
    local container, ui = self:createVitalityItem(v)
    container:setPosition(getPos(k + 1))
    self.draglist:addItem(container)
    ui.data = v
    table.insert(self.uiList, ui)
  end
  self.draglist:initListHeight((dy + py) * (#self.items + 1))
end

function BuyPeakArenaTicketBox:refreshUI()
  self:refreshDraglist()
end

function BuyPeakArenaTicketBox:getCancelPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if item.btn_buy then
        item.btn_buy:setScale(1)
      end
      if item.btn_use then
        item.btn_use:setScale(1)
      end
    end
  end
  
  return handler
end

function BuyPeakArenaTicketBox:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.bg, x, y) then
        if item.btn_buy and ed.containsPoint(item.btn_buy, x, y) then
          item.btn_buy:setScale(0.9)
        end
        if item.btn_use and ed.containsPoint(item.btn_use, x, y) then
          item.btn_use:setScale(0.9)
        end
        return item
      end
    end
  end
  
  return handler
end

function BuyPeakArenaTicketBox:getClickInHandler()
  local function handler(x, y, item)
    if item.btn_buy and ed.containsPoint(item.btn_buy, x, y) then
      if not self.mgr.canChallenge then
        ed.showToast(T("\229\189\147\229\137\141\228\184\141\229\143\175\230\140\145\230\136\152\239\188\140\228\184\141\232\131\189\232\180\173\228\185\176"))
        
        return
      end
      if self.mgr.keyUseCount >= self.mgr.keyMaxUseCount then
        ed.showToast(T("\228\187\138\230\151\165\232\180\173\228\185\176\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140!"))
        return
      end
      ed.showConfirmDialog({
        text = T("\230\152\175\229\144\166\231\161\174\229\174\154\232\180\173\228\185\1765\230\172\161\230\140\145\230\136\152\230\172\161\230\149\176\239\188\159"),
        rightHandler = function()
          self.useType = "key"
          ed.PeakArenaNetwork:sendAddCount("key")
        end
      })
    end
    if item.btn_use and ed.containsPoint(item.btn_use, x, y) then
      if not self.mgr.canChallenge then
        ed.showToast(T("\229\189\147\229\137\141\228\184\141\229\143\175\230\140\145\230\136\152\239\188\140\228\184\141\232\131\189\228\189\191\231\148\168"))
        return
      end
      if self.useTimes >= self.maxTimes then
        ed.showToast(T("\228\187\138\230\151\165\228\189\191\231\148\168\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140!"))
        return
      end
      ed.showConfirmDialog({
        text = T("\230\152\175\229\144\166\231\161\174\229\174\154\228\189\191\231\148\168\233\129\147\229\133\183\229\162\158\229\138\1605\230\172\161\230\140\145\230\136\152\230\172\161\230\149\176\239\188\159"),
        rightHandler = function()
          self.itemId = item.data.id
          self.useType = "ticket"
          ed.PeakArenaNetwork:sendAddCount("ticket")
        end
      })
    end
  end
  
  return handler
end

function BuyPeakArenaTicketBox:initLabels()
  ed.setLabelStroke(self.ui.label_title, ccc3(39, 37, 36), 1)
end

function BuyPeakArenaTicketBox:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
end

function BuyPeakArenaTicketBox:initUI()
  local container, ui = ed.editorui(ed.uieditor.buyVitalityWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.label_title, T("\232\161\165\229\133\133\230\140\145\230\136\152\230\172\161\230\149\176"))
  self:createDraglist()
  self:refreshUI()
end

function BuyPeakArenaTicketBox:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function BuyPeakArenaTicketBox:registerEvents()
  self:listenEvent("PeakArenaChallengeTimesChanged", function()
    if self.useType == "key" then
      ed.player:subrmb(self.needDiamonds)
      ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
    else
      ed.player:consumeEquip(self.itemId, 1)
      ed.showToast(T("\228\189\191\231\148\168\230\136\144\229\138\159"))
    end
    self:destroy()
  end)
end

function BuyPeakArenaTicketBox.create()
  local self = base.create("BuyPeakArenaTicketBox")
  setmetatable(self, BuyPeakArenaTicketBox.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:show()
  return self
end
