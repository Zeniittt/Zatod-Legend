local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForgeSpeedUpWindow = class
ed.UITool.registViewOpenFunc("fireForgeSpeedUpWindow", function(param)
  local window = ed.ui.fireForgeSpeedUpWindow.create(param)
  window:popWindow()
  window:show()
end)

function class.create(param)
  local self = base.create("fireForgeSpeedUpWindow")
  setmetatable(self, class.mt)
  self.queueId = param.queueId
  self.type = param.type
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initData()
  self:initUI()
  self:refreshUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:startCountDown()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  return self
end

function class:getAccItemList()
  local legendEquipForgeParamTb = ed.getDataTable("LegendEquipForgeParam")
  local price = legendEquipForgeParamTb["Quick Forge Diamond"]["Param Content 1"]
  local time = legendEquipForgeParamTb["Quick Forge Diamond"]["Param Content 2"]
  local accItems = {}
  table.insert(accItems, {
    type = "diamond",
    amount = ed.player:getDiamondAmount(),
    useAmount = math.ceil(self.totalTime / time) * price,
    time = time
  })
  for index = 1, 20 do
    local quickForgeCfg = legendEquipForgeParamTb["Quick Forge " .. index]
    if not quickForgeCfg then
      break
    end
    local itemId = quickForgeCfg["Param Content 1"]
    local accTime = quickForgeCfg["Param Content 2"]
    local useAmount = math.ceil(self.totalTime / accTime)
    local ownAmount = ed.player:getEquipAmount(itemId)
    table.insert(accItems, {
      id = itemId,
      type = "item",
      amount = ed.player:getEquipAmount(itemId),
      useAmount = math.min(useAmount, ownAmount),
      useLimit = math.min(useAmount, ownAmount),
      time = accTime
    })
  end
  return accItems
end

function class:initData()
  self.queue = self.mgr:getForgeQueueByQueueId(self.queueId)
  self.totalTime, self.forgeAmount = self:getTotalTime()
  self:checkTime()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_speed_up_window)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  ed.setLabelString(self.ui.label_amount, "x" .. self.forgeAmount)
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -300
  })
end

function class:checkTime()
  if self.totalTime <= 0 then
    self:listenTimer(Timer:Once(0.3), function()
      self:destroy()
    end)
  end
end

function class:refreshUI()
  self:refreshDragList()
end

function class:getTotalTime()
  local totalTime = 0
  local forgeAmount = 0
  if self.type == "one" then
    forgeAmount = 1
    local serverTime = ed.getServerTime()
    for index, forgeItem in ipairs(self.queue._forge_list) do
      local startTime = forgeItem._start_time
      local endTime = forgeItem._end_time
      if serverTime >= startTime and serverTime < endTime then
        totalTime = totalTime + endTime - serverTime
        break
      end
    end
  elseif self.type == "all" then
    local serverTime = ed.getServerTime()
    for index, forgeItem in ipairs(self.queue._forge_list) do
      local startTime = forgeItem._start_time
      local endTime = forgeItem._end_time
      if serverTime >= startTime and serverTime < endTime then
        totalTime = totalTime + endTime - serverTime
        forgeAmount = forgeAmount + 1
      elseif serverTime < startTime then
        totalTime = totalTime + endTime - startTime
        forgeAmount = forgeAmount + 1
      end
    end
  end
  return totalTime, forgeAmount
end

function class:initLabels()
  local ui = self.ui
  ed.setLabelStroke(ui.name, ed.toccc3(2759177), 1)
  ed.setLabelStroke(self.ui.label_left_time_tips, ed.toccc3(3939613), 1.5)
  ed.setLabelStroke(self.ui.label_amount, ed.toccc3(5838103), 2)
  local label_timer = ed.ui.gradientLabel.create({
    fontSize = 31,
    startColor = ed.toccc3(16774571),
    endColor = ed.toccc3(16767087),
    strokeSize = 1.5,
    strokeStartColor = ed.toccc3(3415563),
    strokeEndColor = ed.toccc3(3415563)
  })
  self.ui.icon_timer:addChild(label_timer.node)
  self.label_timer = label_timer
end

function class:startCountDown()
  self:refreshTime()
  local startTotalTime = self.totalTime
  local checkInterval = math.floor(self.totalTime % 60)
  self:listenTimer(Timer:Always(1, "countDown"), function()
    self:refreshTime()
    if startTotalTime - self.totalTime >= checkInterval then
      self:refreshDragList()
      startTotalTime = self.totalTime
      checkInterval = 60
    end
  end)
end

function class:refreshTime()
  local totalTime = self:getTotalTime()
  self.totalTime = totalTime
  local hour = math.floor(totalTime / 3600)
  local min = math.floor(totalTime % 3600 / 60)
  local second = math.floor(totalTime % 60)
  self.label_timer:setString(string.format("%.2d:%.2d:%.2d", hour, min, second))
  ed.right2(self.label_timer.node, self.ui.label_left_time_tips)
end

function class:createAccItem(data)
  local container, ui
  if data.type == "diamond" then
    container, ui = ed.editorui(ed.uieditor.fire_forge_speed_up_item_1)
    local icon = ed.createItemIcon({type = "diamond"})
    icon:setScale(0.6)
    ui.bg:addChild(icon)
    icon:setPosition(ui.panel_item:getPosition())
    ui.icon = icon
    ed.setLabelString(ui.label_amount, data.useAmount)
    ed.setLabelStroke(ui.label_amount, ed.toccc3(10572575), 1.5)
    ed.layout.horizontalSortNode({
      ui.icon_diamond,
      ui.label_amount
    }, nil, ui.btn_ok:getContentSize().width / 2 - 5)
  else
    container, ui = ed.editorui(ed.uieditor.fire_forge_speed_up_item_2)
    local icon = ed.createItemIcon({
      type = data.type,
      id = data.id,
      amount = data.amount
    })
    icon:setScale(0.6)
    ui.bg:addChild(icon)
    ui.icon = icon
    icon:setPosition(ui.panel_item:getPosition())
    ed.setString(ui.desc, data.desc)
    ed.setString(ui.use_amount, tostring(data.useAmount))
    ed.setLabelStroke(ui.use_amount, ed.toccc3(2565412), 1)
    ed.setLabelStroke(ui.label_minus, ed.toccc3(10572575), 1)
    ed.setLabelStroke(ui.label_add, ed.toccc3(10572575), 1)
    ed.setLabelString(ui.desc, string.format(T("\229\143\175\229\138\160\233\128\159%s\229\136\134\233\146\159"), data.time / 60))
    local label_ok = ed.ui.gradientLabel.create({
      text = T("\228\189\191\231\148\168"),
      fontSize = 16,
      startColor = ed.toccc3(16775087),
      endColor = ed.toccc3(16776946),
      strokeSize = 1.5,
      strokeColor = ed.toccc3(10572575)
    })
    ui.btn_ok:addChild(label_ok.node)
    ed.layout.centerInParent(label_ok.node)
  end
  ed.setString(ui.name, ed.getEquipNameWithId(data.id))
  ed.setLabelStroke(ui.name, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.desc, ed.toccc3(3744789), 1)
  return container, ui
end

function class:refreshDragList()
  self.dragList:clearList()
  local accItems = self:getAccItemList()
  
  local function getPos(k)
    return ccp(285, 230 - 60 * k)
  end
  
  self.accUIList = {}
  for index, accItemsCfg in ipairs(accItems) do
    local container, ui = self:createAccItem(accItemsCfg)
    container:setPosition(getPos(index))
    self.dragList:addItem(container)
    table.insert(self.accUIList, {
      data = accItemsCfg,
      ui = ui,
      container = container
    })
  end
  self.dragList:initListHeight(60 * #accItems)
end

function class:doClickInList()
  local function handler(x, y, v)
    if v.data.type == "diamond" then
      if ed.containsPoint(v.ui.icon, x, y) then
        ed.UITool.openView("packageDetail", {type = "diamond"})
      elseif ed.containsPoint(v.ui.btn_ok, x, y) then
        if ed.player:getDiamondAmount() < v.data.useAmount then
          ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
          return
        end
        ed.UITool.openView("fireForeConfirmWindow", {
          title = T("\229\138\160\233\128\159\233\148\187\233\128\160"),
          desc = string.format(T("\232\138\177\232\180\185%d\233\146\187\231\159\179\229\138\160\233\128\159\233\148\187\233\128\160\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173"), v.data.useAmount),
          costType = "diamond",
          costAmount = v.data.useAmount,
          rightHandler = function()
            self:confirmAccelerate()
          end
        })
      end
    else
      if ed.containsPoint(v.ui.icon, x, y) then
        local itemId = v.data.id
        ed.UITool.openView("packageDetail", {id = itemId})
      elseif ed.containsPoint(v.ui.btn_ok, x, y) then
        local itemId = v.data.id
        local name = ed.getDataTable("equip")[itemId].Name
        if v.data.amount <= 0 then
          ed.showToast(T("\233\129\147\229\133\183\228\184\141\232\182\179"))
          ed.UITool.openView("packageDetail", {id = itemId})
          return
        end
        if v.data.useAmount <= 0 then
          ed.showToast(T("\228\189\191\231\148\168\230\149\176\233\135\143\228\184\141\232\131\189\229\176\143\228\186\1421"))
          return
        end
        ed.UITool.openView("fireForeConfirmWindow", {
          title = T("\229\138\160\233\128\159\233\148\187\233\128\160"),
          desc = string.format(T("\232\138\177\232\180\185%s\228\184\170%s\229\138\160\233\128\159\233\148\187\233\128\160\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173"), v.data.useAmount, name),
          rightHandler = function()
            self:confirmAccelerate(itemId, v.data.useAmount)
          end
        })
        v.ui.btn_ok:setScale(1)
      end
      local maxUseItem = v.data.useLimit
      if ed.containsPoint(v.ui.btn_add, x, y) then
        v.data.useAmount = math.min(v.data.useAmount + 1, maxUseItem)
        ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        v.ui.btn_add:setScale(1)
      end
      if ed.containsPoint(v.ui.btn_minus, x, y) then
        v.data.useAmount = math.max(v.data.useAmount - 1, 1)
        v.data.useAmount = math.min(v.data.useAmount, maxUseItem)
        ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        v.ui.btn_minus:setScale(1)
      end
      if ed.containsPoint(v.ui.btn_max, x, y) then
        v.data.useAmount = maxUseItem
        ed.setString(v.ui.use_amount, tostring(v.data.useAmount))
        v.ui.btn_max:setScale(1)
      end
    end
    return nil
  end
  
  return handler
end

function class:doPressInList()
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
            v.ui.btn_add:setScale(0.95)
            self:registerUpdateHandler("pet_accelerate_long_handle_click", self:keepPressHandler(v, "add"))
          end
          if ed.containsPoint(v.ui.btn_minus, x, y) then
            v.ui.btn_minus:setScale(0.95)
            self:registerUpdateHandler("pet_accelerate_long_handle_click", self:keepPressHandler(v, "minus"))
          end
          if ed.containsPoint(v.ui.btn_max, x, y) then
            v.ui.btn_max:setScale(0.95)
          end
        end
        return v
      end
    end
    return nil
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.data.type == "diamond" then
      v.ui.btn_ok:setScale(1)
    else
      self:removeUpdateHandler("pet_accelerate_long_handle_click")
      v.ui.btn_ok:setScale(1)
      v.ui.btn_add:setScale(1)
      v.ui.btn_minus:setScale(1)
      v.ui.btn_max:setScale(1)
    end
  end
  
  return handler
end

function class:keepPressHandler(v, type)
  local count = 0
  local delay = 0.8
  local oriSpeed = 10
  local oriAccSpeed = 2
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  local maxUseItem = v.data.useLimit
  
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

function class:setAccDiamondString()
end

function class:confirmAccelerate(itemId, amount)
  local consumeItems
  if itemId and amount then
    consumeItems = {_id = itemId, _amount = amount}
  end
  if self.type == "one" then
    ed.legendEquipNet.sendAccelerate(self.queueId, consumeItems)
  elseif self.type == "all" then
    ed.legendEquipNet.sendOneKeyAccelerate(self.queueId, consumeItems)
  end
  ed.showToast(T("\229\138\160\233\128\159\230\136\144\229\138\159"))
  self:destroy()
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end

function class:registerEvents()
  self:listenEvent("FireForgeAccelerate", function()
    self:initData()
    self:refreshUI()
  end)
  self:listenEvent("ResourceNumChange", function(resType, id)
    self:refreshUI()
  end)
end

function class:getGuideNode(nodeKey)
  if nodeKey == "btn_use" then
    return self.accUIList[2].ui.btn_ok
  end
  return base.getGuideNode(self, nodeKey)
end
