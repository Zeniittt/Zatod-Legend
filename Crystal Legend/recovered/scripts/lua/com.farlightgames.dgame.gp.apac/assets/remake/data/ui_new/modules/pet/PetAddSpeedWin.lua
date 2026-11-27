local base = ed.ui.popwindow
local PetAddSpeedWin = newclass(base.mt)
ed.ui.PetAddSpeedWin = PetAddSpeedWin

function PetAddSpeedWin.create(param)
  local self = base.create("PetAddSpeedWin")
  setmetatable(self, PetAddSpeedWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self.refreshCliprectConfig = {
    draglist = self.accDraglist
  }
  self:popWindow()
  self:show()
  return self
end

function PetAddSpeedWin:getMayGainPetList()
  return ed.getDataTable("PetEgg")[self.eggId]["Loot Display"]
end

function PetAddSpeedWin:getAccItemList()
  local accItems = {}
  table.insert(accItems, {
    type = "diamond",
    useAmount = ed.PetModel:getAccelerateHatchCost(self.index)
  })
  local accItemsInfo = ed.getDataTable("PetHatchAccelerate")
  for id, v in pairs(accItemsInfo) do
    local accMinute = v["Accelerate Min"]
    local amount = ed.player:getEquipAmount(id)
    if 0 < amount then
      table.insert(accItems, {
        type = "Item",
        id = id,
        accMinute = accMinute,
        desc = T("\229\138\160\233\128\159") .. accMinute .. T("\229\136\134\233\146\159"),
        amount = amount,
        useAmount = 1
      })
    end
  end
  return accItems
end

function PetAddSpeedWin:initData(param)
  self.index = param.index or 1
  self.eggId = ed.PetModel:getEggId(self.index)
  self.itemInfo = {
    type = "item",
    id = self.eggId,
    amount = 1
  }
end

function PetAddSpeedWin:initLabels()
  local ui = self.ui
  ed.setLabelStroke(ui.name, ed.toccc3(2759177), 1)
  ed.setLabelStroke(self.ui.Label_4605, ed.toccc3(3415563), 1.5)
  local timer = ed.ui.gradientLabel.create({
    text = T(""),
    fontSize = 31,
    startColor = ed.toccc3(16774571),
    endColor = ed.toccc3(16767087),
    strokeSize = 1.5,
    strokeStartColor = ed.toccc3(3415563),
    strokeEndColor = ed.toccc3(3415563)
  })
  ed.UITool.replaceUINew(ui, "timer", timer.node)
  self.timer = timer
end

function PetAddSpeedWin:refreshPetDraglist()
  self.petDraglist:clearList()
  local petList = self:getMayGainPetList()
  local dx = 52
  
  local function getPos(k)
    return ccp(dx * (k - 0.5), dx * 0.5)
  end
  
  for k, v in ipairs(petList) do
    local item = ed.readpet.createIcon({type = v}).icon
    item:setScale(0.62)
    item:setPosition(getPos(#petList - k + 1))
    local tag = ed.createSprite(ed.Pet.getTagResByTypeId(v))
    tag:setScale(0.37)
    ed.setAnchor(tag, ed.ccp(0, 1))
    local size = item:getContentSize()
    ed.setPosition(tag, ed.ccp(0, size.height + 4))
    item:addChild(tag)
    self.petDraglist:addItem(item)
  end
  self.petDraglist:initListWidth(dx * #petList)
end

function PetAddSpeedWin:createAccItem(data)
  local container, ui
  if data.type == "diamond" then
    container, ui = ed.editorui(ed.uieditor.PetAddSpeedItem1)
    local icon = ed.createItemIcon({type = "diamond"})
    icon:setScale(0.6)
    ed.UITool.replaceUINew(ui, "icon", icon)
    ed.setString(ui.Label_4614, data.useAmount)
    ed.right2(ui.Label_4615, ui.Label_4614, 2)
    ed.setLabelShadow(ui.Label_4615, ccc3(0, 0, 0), ccp(1, 1))
    ed.setLabelShadow(ui.Label_4614, ccc3(0, 0, 0), ccp(1, 1))
  else
    container, ui = ed.editorui(ed.uieditor.PetAddSpeedItem2)
    local icon = ed.createItemIcon({
      type = data.type,
      id = data.id,
      amount = data.amount
    })
    icon:setScale(0.6)
    ed.UITool.replaceUINew(ui, "icon", icon)
    ed.setString(ui.desc, data.desc)
    ed.setLabelShadow(ui.Label_4615, ccc3(0, 0, 0), ccp(1, 1))
    ed.setString(ui.use_amount, tostring(data.useAmount))
    ed.setLabelStroke(ui.use_amount, ed.toccc3(2565412), 1)
  end
  ed.setString(ui.name, ed.getEquipNameWithId(data.id))
  ed.setLabelStroke(ui.name, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.desc, ed.toccc3(2565412), 1)
  return container, ui
end

function PetAddSpeedWin:refreshAccDraglist()
  self.accDraglist:clearList()
  local accItems = self:getAccItemList()
  
  local function getPos(k)
    return ccp(285, 230 - 60 * k)
  end
  
  self.accUIList = {}
  for k, v in ipairs(accItems) do
    local container, ui = self:createAccItem(v)
    container:setPosition(getPos(k))
    self.accDraglist:addItem(container)
    table.insert(self.accUIList, {
      data = v,
      ui = ui,
      container = container
    })
  end
  self.accDraglist:initListHeight(60 * #accItems)
end

function PetAddSpeedWin:doClickInList()
  local function handler(x, y, v)
    if v.data.type == "diamond" then
      if ed.containsPoint(v.ui.btn_ok, x, y) then
        if ed.player._rmb < v.data.useAmount then
          ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
          
          return
        end
        ed.PetNetwork:openPanel()
        ListenEventOnce("refreshPetEggTime", function()
          local useAmount = ed.PetModel:getAccelerateHatchCost(self.index)
          ed.showConfirmDialog({
            text = T("\232\138\177\232\180\185%d\233\146\187\231\159\179\229\138\160\233\128\159\229\173\181\229\140\150\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", useAmount),
            rightHandler = function()
              ed.PetNetwork:accelerateHatch(self.index, "diamond")
            end
          })
        end)
        v.ui.btn_ok:setScale(1)
      end
    else
      if ed.containsPoint(v.ui.btn_ok, x, y) then
        ed.PetNetwork:accelerateHatch(self.index, "item", {
          {
            _id = v.data.id,
            _amount = v.data.useAmount
          }
        })
        v.ui.btn_ok:setScale(1)
      end
      local maxUseItem = math.min(math.ceil(ed.PetModel:getTimeLeft(self.index) / (60 * v.data.accMinute)), v.data.amount)
      if ed.containsPoint(v.ui.btn_add, x, y) then
        v.data.useAmount = math.min(v.data.useAmount + 1, maxUseItem)
        ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        v.ui.btn_add:setScale(0.85)
      end
      if ed.containsPoint(v.ui.btn_minus, x, y) then
        v.data.useAmount = math.max(v.data.useAmount - 1, 1)
        ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        v.ui.btn_minus:setScale(0.85)
      end
      if ed.containsPoint(v.ui.btn_max, x, y) then
        v.data.useAmount = maxUseItem
        ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        v.ui.btn_max:setScale(0.85)
      end
    end
    return nil
  end
  
  return handler
end

function PetAddSpeedWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.accUIList or {}) do
      if ed.containsPoint(v.ui.bg, x, y) then
        if v.data.type == "diamond" then
          if ed.containsPoint(v.ui.btn_ok, x, y) then
            v.ui.btn_ok:setScale(0.95)
          end
        else
          if ed.containsPoint(v.ui.btn_ok, x, y) then
            v.ui.btn_ok:setScale(0.95)
          end
          if ed.containsPoint(v.ui.btn_add, x, y) then
            v.ui.btn_add:setScale(0.8)
            self:registerUpdateHandler("pet_accelerate_long_handle_click", self:keepPressHandler(v, "add"))
          end
          if ed.containsPoint(v.ui.btn_minus, x, y) then
            v.ui.btn_minus:setScale(0.8)
            self:registerUpdateHandler("pet_accelerate_long_handle_click", self:keepPressHandler(v, "minus"))
          end
          if ed.containsPoint(v.ui.btn_max, x, y) then
            v.ui.btn_max:setScale(0.8)
          end
        end
        return v
      end
    end
    return nil
  end
  
  return handler
end

function PetAddSpeedWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.data.type == "diamond" then
      v.ui.btn_ok:setScale(1)
    else
      self:removeUpdateHandler("pet_accelerate_long_handle_click")
      v.ui.btn_ok:setScale(1)
      v.ui.btn_add:setScale(0.85)
      v.ui.btn_minus:setScale(0.85)
      v.ui.btn_max:setScale(0.85)
    end
  end
  
  return handler
end

function PetAddSpeedWin:keepPressHandler(v, type)
  local count = 0
  local delay = 0.8
  local oriSpeed = 10
  local oriAccSpeed = 2
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  local maxUseItem = math.min(math.ceil(ed.PetModel:getTimeLeft(self.index) / (60 * v.data.accMinute)), v.data.amount)
  
  local function upHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        if type == "add" then
          v.data.useAmount = math.min(v.data.useAmount + 1, maxUseItem)
          ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        elseif type == "minus" then
          v.data.useAmount = math.max(v.data.useAmount - 1, 1)
          ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        end
        times = times - 1
      end
    end
  end
  
  return upHandler
end

function PetAddSpeedWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.PetAddSpeedWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local icon = ed.readequip.createIcon(self.eggId)
  icon:setScale(1.3)
  ed.UITool.replaceUINew(ui, "icon", icon)
  ed.setString(self.ui.name, ed.readequip.value(self.eggId, "Name"))
  self.petDraglist = ed.UITool.createDraglist(self.ui.layer_pet, {})
  self:refreshPetDraglist()
  self.accDraglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshAccDraglist()
end

function PetAddSpeedWin:handleAccSuccess()
  if ed.PetModel:getTimeLeft(self.index) <= 0 then
    ed.showToast(T("\229\173\181\229\140\150\230\136\144\229\138\159"))
    self:destroy()
    return
  end
  self:refreshAccDraglist()
end

function PetAddSpeedWin:setAccDiamondString()
  for i, k in ipairs(self.accUIList) do
    local data = k.data
    local ui = k.ui
    if data.type == "diamond" then
      data.useAmount = ed.PetModel:getAccelerateHatchCost(self.index)
      ed.setString(ui.Label_4614, data.useAmount)
      ed.right2(ui.Label_4615, ui.Label_4614, 2)
    elseif data.type == "item" then
      local maxAmount = math.ceil(self.leftTime / 60 / data.accMinute)
      if maxAmount < data.useAmount then
        data.useAmount = maxAmount
        ed.setString(ui.use_amount, tostring(data.useAmount))
      end
    end
  end
end

function PetAddSpeedWin:registerEvents()
  self.timer:setString(ed.gethmsNString(ed.PetModel:getTimeLeft(self.index)))
  self:listenTimer(Timer:Always(1), function()
    self.leftTime = ed.PetModel:getTimeLeft(self.index)
    if self.leftTime <= 0 then
      ed.showToast(T("\229\173\181\229\140\150\230\136\144\229\138\159"))
      self:destroy()
      return
    end
    self.timer:setString(ed.gethmsNString(self.leftTime))
    self:setAccDiamondString()
  end)
  self:listenEvent("successAccelarateEgg", function()
    self:handleAccSuccess()
  end)
end

function PetAddSpeedWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.7, pressScale = 0.65})
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end
