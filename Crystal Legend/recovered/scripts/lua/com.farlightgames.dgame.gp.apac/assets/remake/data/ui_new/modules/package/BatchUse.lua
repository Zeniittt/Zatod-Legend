local base = ed.ui.popwindow
local batchUse = newclass(base.mt)
ed.ui.batchUse = batchUse

function batchUse:initUI(id)
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.package_use_win)
  ed.layout.centerInScreen(self.ui.bg_detail, true)
  local icon, iconBg = ed.readequip.createIcon(self.id)
  local posX, posY = self.ui.icon:getPosition()
  self.ui.icon:setVisible(false)
  icon:setPosition(ccp(posX, posY))
  self.ui.top_layer:addChild(icon)
  if self.insid then
    local expireTimeBg = ed.ui.package.createExpireTimeIcon({
      id = self.id,
      insid = self.insid
    })
    icon:addChild(expireTimeBg)
  end
  self.ui.name:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.name, ccc3(39, 37, 36), 2)
  ed.setString(self.ui.name, ed.getDataTable("equip")[self.id].Name)
  self.ui.name:limitWidthByScale(250)
  ed.setString(self.ui.label_amount, ed.player.equip_qunty[self.id])
  ed.setString(self.ui.use_amount, self.currentAmount)
  ed.setString(self.ui.use_amount_limit, "/" .. self.useAmountLimit)
  ed.setLabelStroke(self.ui.Label_1014, ccc3(144, 85, 15), 1)
  ed.setLabelStroke(self.ui.Label_1016, ccc3(144, 85, 15), 1)
  ed.setLabelStroke(self.ui.Label_1015, ccc3(144, 85, 15), 1)
  ed.setLabelStroke(self.ui.use_amount, ccc3(0, 0, 0), 2)
end

function batchUse.create(param)
  local self = base.create("batchuse")
  setmetatable(self, batchUse.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandler()
  self:show()
  return self
end

function batchUse:initData(param)
  self.id = param.id
  self.callback = param.callback
  self.insid = param.insid
  self.currentAmount = 1
  self.useAmountLimit = self:calcUseAmountLimit()
end

function batchUse:calcUseAmountLimit()
  local selectEquip = ed.getDataTable("equip")[self.id]
  local currentAmount = ed.player:getNewEquipAmount(self.id, self.insid) or 0
  if 0 < selectEquip.Vitality then
    local possibleUseLimit = math.floor((ed.parameter.max_vitality_stock - ed.player:getVitality()) / selectEquip.Vitality)
    return math.min(possibleUseLimit, currentAmount)
  else
    if selectEquip["Use Type"] == "Open Tarot Tavern ID" then
      currentAmount = math.min(currentAmount, 10)
    end
    return currentAmount
  end
end

function batchUse:setUseAmount(amount)
  if amount then
    self.currentAmount = math.max(1, math.min(self.useAmountLimit, amount))
  end
  self.currentAmount = math.floor(self.currentAmount)
  ed.setString(self.ui.use_amount, self.currentAmount)
end

function batchUse:registerTouchHandler()
  ed.UITool.registerBtn(self, "close_button", function()
    self:destroy()
  end, {normalScale = 0.75, pressScale = 0.75})
  self:btRegisterButtonClick({
    button = self.ui.minus_button,
    key = "batchuse_minus_button",
    clickHandler = function()
      self:setUseAmount(self.currentAmount - 1)
    end,
    pressHandler = function()
      local count = 0
      local acceleration = 10
      local speed = 5
      local maxSpeed = 100
      local threshold = 0.5
      self:registerUpdateHandler("batchuse_minus_amount", function(dt)
        count = count + dt
        if count > threshold then
          speed = speed + acceleration * (count - threshold)
          speed = math.max(speed, maxSpeed)
          self.currentAmount = self.currentAmount - speed * dt
          self:setUseAmount(self.currentAmount)
        end
      end)
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("batchuse_minus_amount")
    end,
    force = true,
    pressScale = 0.9
  })
  self:btRegisterButtonClick({
    button = self.ui.add_button,
    key = "batchuse_add_button",
    clickHandler = function()
      self:setUseAmount(self.currentAmount + 1)
    end,
    pressHandler = function()
      local count = 0
      local acceleration = 10
      local speed = 5
      local maxSpeed = 100
      local threshold = 0.5
      self:registerUpdateHandler("batchuse_add_amount", function(dt)
        count = count + dt
        if count > threshold then
          speed = speed + acceleration * (count - threshold)
          speed = math.max(speed, maxSpeed)
          self.currentAmount = self.currentAmount + speed * dt
          self:setUseAmount(self.currentAmount)
        end
      end)
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("batchuse_add_amount")
    end,
    force = true,
    pressScale = 0.9
  })
  ed.UITool.registerBtn(self, "add_ten_button", function()
    self:setUseAmount(self.useAmountLimit)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "use_button", function()
    if self.callback then
      self.callback(self.currentAmount)
      self:destroy()
    end
  end, {pressScale = 0.9})
end
