local base = ed.ui.popwindow
local buyVitalityBox = newclass(base.mt)
ed.ui.buyVitalityBox = buyVitalityBox

function buyVitalityBox:initData()
  self.buyTimes = ed.player:getVitalityBuyTimes()
  self.maxTimes = ed.lookupDataTable("VIP", "Buy Vit Max", (ed.player:getvip()))
  self.needDiamonds = ed.player:getBuyVitalityCost()
  self.items = {}
  local package = ed.player.packageGoods.package
  for k, v in ipairs(package.all or {}) do
    local goodsInfo = ed.getDataTable("equip")[v.id]
    if goodsInfo.Vitality and goodsInfo.Vitality > 0 and 0 < v.amount then
      table.insert(self.items, v)
    end
  end
  self.useNum = {}
end

function buyVitalityBox:createBuyVitalityItem()
  local container, ui = ed.editorui(ed.uieditor.buyVitalityItem1)
  ed.setLabelStroke(ui.title, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.num, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.desc, ccc3(57, 36, 21), 1)
  ed.setLabelShadow(ui.label_buy, ccc3(0, 0, 0), ccp(1, 1))
  ui.label_buy:limitWidthByScale(40)
  ed.setString(ui.desc, T("\229\143\175\228\187\165\232\161\165\229\133\133120\231\130\185\228\189\147\229\138\155"))
  ed.setString(ui.num, self.needDiamonds)
  ed.setString(ui.label_times, string.format(T("\228\187\138\230\151\165\233\153\144\232\180\173 %d/%d\230\172\161"), self.buyTimes, self.maxTimes))
  self.buffIcon = ui.buff_icon
  local isVitDiscount, count = ed.GobackManager:isInBuyVitDiscount()
  if isVitDiscount and count > self.buyTimes then
    ui.buff_icon:setVisible(false)
    local param = {
      extraTypeList = {
        "buy_vitality_discount"
      },
      tipsDirection = 2
    }
    local buffTipsPanel = ed.buffTipsPanel.create(param)
    ui.bg:addChild(buffTipsPanel.container)
    local posX = ui.title:getPositionX() + ui.title:getContentSize().width + 40
    buffTipsPanel.container:setPosition(ccp(posX, 58))
    self.buffTipsPanel = buffTipsPanel
  end
  return container, ui
end

function buyVitalityBox:calcUseAmountLimit(v)
  local selectItem = ed.getDataTable("equip")[v.id]
  local possibleUseLimit = math.floor((ed.parameter.max_vitality_stock - ed.player:getVitality()) / selectItem.Vitality)
  return math.min(possibleUseLimit, v.amount)
end

function buyVitalityBox:createVitalityItem(v)
  local container, ui = ed.editorui(ed.uieditor.buyVitalityItem2)
  ed.setLabelStroke(ui.title, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.use_amount, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.desc, ccc3(57, 36, 21), 1)
  ed.setLabelShadow(ui.label_use, ccc3(0, 0, 0), ccp(1, 1))
  self.useNum[v.key] = 1
  ed.setString(ui.use_amount, 1)
  local itemData = ed.getDataTable("equip")[v.id]
  ed.setString(ui.title, itemData.Name)
  ed.setString(ui.desc, string.format(T("\229\143\175\228\187\165\232\161\165\229\133\133%d\231\130\185\228\189\147\229\138\155"), itemData.Vitality))
  local icon = ed.readequip.createIconWithAmount(v.id, 75, v.amount)
  ed.UITool.replaceUI(ui, "bg", "icon", icon)
  if v.insid then
    icon:addChild(ed.ui.package.createExpireTimeIcon({
      id = v.id,
      insid = v.insid
    }))
  end
  return container, ui
end

function buyVitalityBox:refreshDraglist()
  if self.buffTipsPanel then
    self.buffTipsPanel:CloseScope()
  end
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

function buyVitalityBox:refreshUI()
  self:refreshDraglist()
end

function buyVitalityBox:getCancelPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if item.btn_buy then
        item.btn_buy:setScale(1)
      end
      if item.minus_button then
        item.minus_button:setScale(1)
      end
      if item.add_button then
        item.add_button:setScale(1)
      end
      if item.btn_use then
        item.btn_use:setScale(1)
      end
    end
  end
  
  return handler
end

function buyVitalityBox:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.bg, x, y) then
        if item.btn_buy and ed.containsPoint(item.btn_buy, x, y) then
          item.btn_buy:setScale(0.9)
        end
        if item.minus_button and ed.containsPoint(item.minus_button, x, y) then
          item.minus_button:setScale(0.9)
        end
        if item.add_button and ed.containsPoint(item.add_button, x, y) then
          item.add_button:setScale(0.9)
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

function buyVitalityBox:getClickInHandler()
  local function handler(x, y, item)
    if item.btn_buy and ed.containsPoint(item.btn_buy, x, y) then
      self.dialogPop = ed.showHandyDialog("buyVitalityWithDiamond", {
        active = true,
        
        reply = function()
          self.dialogPop = nil
          self.needDiamonds = ed.player:getBuyVitalityCost()
          self.buyTimes = ed.player:getVitalityBuyTimes()
          ed.setString(self.uiList[1].num, self.needDiamonds)
          ed.setString(self.uiList[1].label_times, string.format(T("\228\187\138\230\151\165\233\153\144\232\180\173 %d/%d\230\172\161"), self.buyTimes, self.maxTimes))
          ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
          local isVitDiscount, count = ed.GobackManager:isInBuyVitDiscount()
          if isVitDiscount and count <= self.buyTimes then
            ed.activityBuffMgr.getInstance():deleteBuff({
              extraBuffType = "buy_vitality_discount"
            })
          end
        end
      })
    end
    if item.minus_button and ed.containsPoint(item.minus_button, x, y) then
      if self.useNum[item.data.key] <= 1 then
        return
      end
      self.useNum[item.data.key] = self.useNum[item.data.key] - 1
      ed.setString(item.use_amount, self.useNum[item.data.key])
    end
    if item.add_button and ed.containsPoint(item.add_button, x, y) then
      if item.data.amount <= self.useNum[item.data.key] then
        return
      end
      if self:calcUseAmountLimit(item.data) <= self.useNum[item.data.key] then
        ed.showToast(T("\230\130\168\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\228\186\134\239\188\140\229\133\136\229\142\187\230\182\136\232\128\151\228\184\128\228\186\155"))
        return
      end
      self.useNum[item.data.key] = self.useNum[item.data.key] + 1
      ed.setString(item.use_amount, self.useNum[item.data.key])
    end
    if item.btn_use and ed.containsPoint(item.btn_use, x, y) then
      if self.useNum[item.data.key] < 1 then
        return
      end
      local itemInfo = ed.packItem(item.data.key, self.useNum[item.data.key])
      if item.data.insid then
        local msg = ed.upmsg.consume_timely_item()
        msg._insid = item.data.insid
        msg._amount = self.useNum[item.data.id]
        ed.send(msg, "consume_timely_item")
      else
        local msg = ed.upmsg.consume_item()
        msg._item = itemInfo
        ed.send(msg, "consume_item")
      end
      self.selectItem = item
    end
  end
  
  return handler
end

function buyVitalityBox:initLabels()
  ed.setLabelStroke(self.ui.label_title, ccc3(39, 37, 36), 1)
end

function buyVitalityBox:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
end

function buyVitalityBox:initUI()
  local container, ui = ed.editorui(ed.uieditor.buyVitalityWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:createDraglist()
  self:refreshUI()
end

function buyVitalityBox:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
    if self.buffTipsPanel then
      self.buffTipsPanel:CloseScope()
    end
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function buyVitalityBox:registerEvents()
  self:listenEvent("EatVitalitySuccess", function()
    if self.selectItem then
      ed.record:useItemCount(self.selectItem.data.id, self.useNum[self.selectItem.data.key])
      ed.player:consumeEquip(self.selectItem.data.id, self.useNum[self.selectItem.data.key], self.selectItem.data.insid)
      self:initData()
      self:refreshUI()
      ed.showToast(T("\228\189\191\231\148\168\230\136\144\229\138\159"))
      self.selectItem = nil
    end
  end)
  self:listenEvent("activityCrossDays", function()
    if self.dialogPop then
      self.dialogPop:destroy({
        skipAnim = self.dialogPop.param.skipDestroyAnim,
        callback = self.dialogPop.param.leftHandler
      })
    end
    self.needDiamonds = ed.player:getBuyVitalityCost()
    self.buyTimes = ed.player:getVitalityBuyTimes()
    ed.setString(self.uiList[1].num, self.needDiamonds)
    ed.setString(self.uiList[1].label_times, string.format(T("\228\187\138\230\151\165\233\153\144\232\180\173 %d/%d\230\172\161"), self.buyTimes, self.maxTimes))
    local isVitDiscount, count = ed.GobackManager:isInBuyVitDiscount()
    if isVitDiscount and count <= self.buyTimes then
      ed.activityBuffMgr.getInstance():deleteBuff({
        extraBuffType = "buy_vitality_discount"
      })
    end
  end)
end

function buyVitalityBox.create()
  local self = base.create("buyVitalityBox")
  setmetatable(self, buyVitalityBox.mt)
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
