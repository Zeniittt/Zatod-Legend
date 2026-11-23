local class = newclass("g")
ed.ui.basetouchnode = class

local function btCreate()
  local self = {}
  setmetatable(self, class.mt)
  self.clickFcaCreateTime = 0
  self.radioGroups = {}
  return self
end

class.btCreate = btCreate

local function btClearRadioGroup(self, key)
  if not key then
    self.radioGroups = {}
  else
    self.radioGroups[key] = nil
  end
end

class.btClearRadioGroup = btClearRadioGroup

local function btRegisterRadioGroup(self, groupName, button)
  if not groupName then
    return
  end
  if not self.radioGroups[groupName] then
    self.radioGroups[groupName] = RadioButton.create()
  end
  self.radioGroups[groupName]:register(button)
end

class.btRegisterRadioGroup = btRegisterRadioGroup

local function btClickRadioButton(self, groupName, key)
  if not groupName then
    return
  end
  if not self.radioGroups[groupName] then
    return
  end
  self.radioGroups[groupName]:click(key)
end

class.btClickRadioButton = btClickRadioButton

local function btGetBaseClickHandler(self, param)
  param = param or {}
  local pressHandler = param.pressHandler
  local cancelPressHandler = param.cancelPressHandler
  local liftHandler = param.liftHandler
  local moveHandler = param.moveHandler
  local transParam = param.transParam
  local clickInterval = param.clickInterval
  local clickTimePoint, isMCP, isMove
  local mcpMode = param.mcpMode
  local mcp_dis = param.mcp_dis or 7
  local pressX, pressY
  local needClickFca = false
  if param.cancelClickInterval then
    clickInterval = nil
  end
  
  local function handler(event, x, y, isPressButton)
    local rs
    xpcall(function()
      if event == "began" then
        pressX = x
        pressY = y
        if pressHandler then
          rs = pressHandler(x, y)
        end
      elseif event == "moved" then
        if pressX and pressY then
          local dx = x - pressX
          local dy = y - pressY
          local n = dx * dx + dy * dy
          if mcpMode and n > mcp_dis * 2 then
            isMCP = true
            if cancelPressHandler then
              if transParam then
                cancelPressHandler(transParam, x, y)
              else
                cancelPressHandler(x, y)
              end
            end
          end
          if needClickFca and 9 < n then
            isMove = true
          end
        end
        if moveHandler and isPressButton then
          moveHandler(x, y)
        end
      elseif event == "ended" then
        if needClickFca and not isMove then
          local curScene = ed.getCurrentScene()
          if curScene.addFcaOnce and ed.getMillionTime() - self.clickFcaCreateTime > 0.1 and curScene.getTopNode then
            local clickFca = ed.createFcaNode(self.clickFcaName or "eff_UI_Main_Click")
            clickFca:setPosition(ccp(x, y))
            local container = curScene:getTopNode()
            container:addChild(clickFca)
            curScene:addFcaOnce(clickFca, true)
            self.clickFcaCreateTime = ed.getMillionTime()
          end
        end
        if not isMCP and isPressButton and liftHandler then
          if clickInterval then
            if clickTimePoint then
              if ed.getMillionTime() - clickTimePoint > clickInterval then
                liftHandler(x, y)
                clickTimePoint = ed.getMillionTime()
              else
                liftHandler(x, y, true)
              end
            else
              liftHandler(x, y)
              clickTimePoint = ed.getMillionTime()
            end
          else
            liftHandler(x, y)
          end
        end
        isMove = nil
        isMCP = nil
      end
    end, EDDebug)
    return rs
  end
  
  return handler
end

class.btGetBaseClickHandler = btGetBaseClickHandler

local function btRegisterHandler(self, param)
  if not param then
    EDLog("U must set the param of the handler! --handler")
  end
  self:btRegisterMainTouchHandler(param)
end

class.btRegisterHandler = btRegisterHandler

local function btGetClickHandler(self, param)
  if not param then
    EDLog("U must set the param of the button handler! --click")
    return
  end
  local clickHandler = param.clickHandler
  local pressHandler = param.pressHandler
  local cancelPressHandler = param.cancelPressHandler
  local moveHandler = param.moveHandler
  local transParam = param.param or {}
  local checkClickHandler = param.checkClickHandler or function(x, y)
    return true
  end
  
  local function btPressHandler(x, y)
    if checkClickHandler(x, y) then
      if pressHandler then
        local moveParam = {pressX = x, pressY = y}
        transParam.clickParam = pressHandler(transParam, x, y)
        transParam.moveParam = moveParam
      end
      return true
    end
  end
  
  local function btMoveHandler(x, y)
    if moveHandler then
      moveHandler(transParam, x, y)
    end
  end
  
  local function btLiftHandler(x, y, cancelClick)
    if cancelPressHandler then
      cancelPressHandler(transParam, x, y)
    end
    if not cancelClick and checkClickHandler(x, y) and clickHandler then
      clickHandler(transParam, x, y)
    end
  end
  
  return self:btGetBaseClickHandler({
    cancelPressHandler = cancelPressHandler,
    pressHandler = btPressHandler,
    liftHandler = btLiftHandler,
    moveHandler = btMoveHandler,
    transParam = transParam,
    mcpMode = param.mcpMode,
    mcp_dis = param.mcp_dis,
    clickInterval = param.clickInterval
  })
end

class.btGetClickHandler = btGetClickHandler

local function btRegisterClick(self, param)
  local handler = self:btGetClickHandler(param)
  param.handler = handler
  self:btRegisterMainTouchHandler(param)
end

class.btRegisterClick = btRegisterClick

local function btGetOutClickHandler(self, param)
  if not param then
    EDLog("U must set the param of the button handler! --out click")
    return
  end
  local area = param.area
  local rectArea = param.rectArea
  local parent = param.parent
  local extraCheckHandler = param.extraCheckHandler
  local clickHandler = param.clickHandler
  local pressHandler = param.pressHandler
  local transParam = param.param
  
  local function isClick(x, y)
    if extraCheckHandler and not extraCheckHandler(x, y) then
      return false
    end
    if area then
      if type(area) == "table" then
        for i, v in ipairs(area) do
          if ed.containsPoint(v, x, y) then
            return false
          end
        end
        return true
      else
        return not ed.containsPoint(area, x, y)
      end
    end
    if rectArea then
      return not ed.isPointInRect(rectArea, x, y, parent)
    end
  end
  
  local function btPressHandler(x, y)
    if isClick(x, y) then
      if pressHandler then
        pressHandler(transParam)
      end
      return true
    end
  end
  
  local function btLiftHandler(x, y, cancelClick)
    if not cancelClick and isClick(x, y) and clickHandler then
      clickHandler(transParam)
    end
  end
  
  return self:btGetBaseClickHandler({
    cancelPressHandler = cancelPressHandler,
    pressHandler = btPressHandler,
    liftHandler = btLiftHandler,
    mcpMode = param.mcpMode,
    clickInterval = param.clickInterval
  })
end

class.btGetOutClickHandler = btGetOutClickHandler

local function btRegisterOutClick(self, param)
  local handler = self:btGetOutClickHandler(param)
  param.handler = handler
  self:btRegisterMainTouchHandler(param)
end

class.btRegisterOutClick = btRegisterOutClick

local function btGetButtonClickHandler(self, param)
  local buttons = param.buttons
  local presses = param.presses or {}
  local keys = param.keys
  if buttons then
    for i, v in pairs(buttons) do
      local paramCopy = ed.copyTable(param)
      paramCopy.button = v
      paramCopy.press = presses[i]
      paramCopy.key = (param.keys or {})[i] or param.key .. "_" .. i
      paramCopy.buttons, param.presses = nil, nil
      self:btRegisterButtonClick(paramCopy)
    end
    return
  end
  
  local function doCheckUponVisible(node)
    if tolua.isnull(node) then
      return true
    end
    if node:isVisible() then
      return doCheckUponVisible(node:getParent())
    else
      return false
    end
  end
  
  if not param then
    EDLog("U must set the param of the button handler! --button click")
    return
  end
  local disabled = param.disabled
  if not tolua.isnull(disabled) then
    local paramCopy = ed.copyTable(param)
    paramCopy.button = disabled
    paramCopy.press = nil
    paramCopy.disabled = nil
    paramCopy.key = paramCopy.key and paramCopy.key .. "_disabled"
    paramCopy.extraCheckHandler = param.disabledExtraCheckHandler
    paramCopy.clickHandler = param.disabledClickHandler
    paramCopy.disabledClickHandler = nil
    self:btRegisterButtonClick(paramCopy)
  end
  local button = param.button
  local press = param.press
  local centerOffset = param.centerOffset or ccp(0, 0)
  local radius = param.radius
  local pressScale = param.pressScale
  local normalScale = param.normalScale or 1
  local extraCheckHandler = param.extraCheckHandler
  local pressHandler = param.pressHandler
  local cancelPressHandler = param.cancelPressHandler
  local clickHandler = param.clickHandler
  local liftHandler = param.liftHandler
  local transParam = param.param
  local uponCheck = param.uponCheck
  local cliprect = param.cliprect
  local cliprectParent = param.cliprectParent
  local key = param.key
  local selected = param.selected
  local radioGroupName = param.radioGroupName
  if radioGroupName then
    self:btRegisterRadioGroup(radioGroupName, {key = key, selected = selected})
  end
  if type(button) == "table" then
    for i, v in ipairs(button) do
      if tolua.isnull(v) then
        return
      end
    end
  elseif tolua.isnull(button) then
    return
  end
  local isButtonLock
  
  local function doDelayFree(param)
    param = param or {}
    local freeDelay = param.freeDelay
    local lockHandler = param.lockHandler
    local freeHandler = param.freeHandler
    if freeDelay then
      local countFree = 0
      isButtonLock = true
      if lockHandler then
        lockHandler()
      end
      ed.getCurrentScene():registerUpdateHandler("delayfree_" .. param.key, function(dt)
        countFree = countFree + dt
        if countFree > freeDelay then
          if freeHandler then
            freeHandler()
          end
          if ed.getCurrentScene().removeUpdateHandler then
            ed.getCurrentScene():removeUpdateHandler("delayfree_" .. param.key)
          end
          isButtonLock = nil
        end
      end)
    end
  end
  
  local function isClick(x, y)
    local function doCheck(button)
      if tolua.isnull(button) then
        return false
      end
      if not doCheckUponVisible(button) then
        return false
      end
      if button.getOpacity and button:getOpacity() == 0 then
        return false
      end
      if extraCheckHandler and not extraCheckHandler(x, y) then
        return false
      end
      if cliprect and not ed.isPointInRect(cliprect, x, y, cliprectParent) then
        return false
      end
      if isButtonLock then
        return false
      end
      if radius then
        local center = ed.getCenterPos(button)
        center = ccpAdd(center, centerOffset)
        return ed.isPointInCircle(center, radius, x, y, button:getParent())
      else
        return ed.containsPoint(button, x, y)
      end
    end
    
    if type(button) == "table" then
      for i, v in ipairs(button) do
        if doCheck(v) then
          return true
        end
      end
      return false
    else
      return doCheck(button)
    end
  end
  
  local btCancelPressHandler = cancelPressHandler or function()
    if type(press) == "table" then
      for i, v in ipairs(press) do
        if not tolua.isnull(v) then
          v:setVisible(false)
        end
      end
    elseif not tolua.isnull(press) then
      press:setVisible(false)
    end
    if pressScale and not tolua.isnull(button) then
      button:setScale(normalScale)
    end
  end
  
  local function btPressHandler(x, y)
    if isClick(x, y) then
      if pressHandler then
        pressHandler(transParam, x, y)
      end
      if type(press) == "table" then
        for i, v in ipairs(press) do
          if not tolua.isnull(v) then
            v:setVisible(true)
          end
        end
      elseif not tolua.isnull(press) then
        press:setVisible(true)
      end
      if pressScale then
        button:setScale(pressScale)
      end
      return true
    end
  end
  
  local function btLiftHandler(x, y, cancelClick)
    if type(press) == "table" then
      for i, v in ipairs(press) do
        if not tolua.isnull(v) then
          v:setVisible(false)
        end
      end
    elseif not tolua.isnull(press) then
      press:setVisible(false)
    end
    if cancelPressHandler then
      cancelPressHandler(transParam, x, y)
    end
    if pressScale and not tolua.isnull(button) then
      button:setScale(normalScale)
    end
    if not cancelClick and isClick(x, y) then
      if radioGroupName then
        self:btClickRadioButton(radioGroupName, key)
      end
      if clickHandler then
        clickHandler(transParam, x, y)
        doDelayFree(param)
      end
    end
  end
  
  return self:btGetBaseClickHandler({
    pressHandler = btPressHandler,
    cancelPressHandler = btCancelPressHandler,
    liftHandler = liftHandler or btLiftHandler,
    mcpMode = param.mcpMode,
    clickInterval = param.clickInterval
  })
end

class.btGetButtonClickHandler = btGetButtonClickHandler

local function btRegisterButtonClick(self, param)
  local handler = self:btGetButtonClickHandler(param)
  param.handler = handler
  self:btRegisterMainTouchHandler(param)
end

class.btRegisterButtonClick = btRegisterButtonClick

local function keepeatHandler(func)
  local count = 0
  local delay = 0.5
  local accAcc = 2
  local speed = 10
  local accSpeed = 2
  local times = 0
  local func = func
  
  local function longPressHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        func()
        times = times - 1
      end
    end
  end
  
  return longPressHandler
end

local function btRegisterChangeNumButtonClick(self, btn, key, changeNumFunc)
  local function callFunc()
    changeNumFunc(self, key)
  end
  
  local config = {
    button = btn,
    key = key,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_back)
      callFunc()
    end,
    priority = -1,
    clickInterval = 0.1,
    pressScale = 0.9,
    pressHandler = function()
      self:registerUpdateHandler("long_click_button_down", keepeatHandler(callFunc))
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("long_click_button_down")
    end
  }
  self:btRegisterButtonClick(config)
end

class.btRegisterChangeNumButtonClick = btRegisterChangeNumButtonClick

local function btGetRectClickHandler(self, param)
  if not param then
    EDLog("U must set the param of the button handler! --button click")
    return
  end
  local rect = param.rect
  local parent = param.parent
  local press = param.press
  local pressHandler = param.pressHandler
  local cancelPressHandler = param.cancelPressHandler
  local clickHandler = param.clickHandler
  local liftHandler = param.liftHandler
  local transParam = param.param
  local cliprect = param.cliprect
  
  local function isClick(x, y)
    if cliprect and not ed.isPointInRect(cliprect, x, y) then
      return false
    end
    if ed.isPointInRect(rect, x, y, parent) then
      return true
    end
    return false
  end
  
  local btCancelPressHandler = cancelPressHandler or function()
  end
  
  local function btPressHandler(x, y)
    if isClick(x, y) then
      if not tolua.isnull(press) then
        press:setVisible(true)
      end
      if pressHandler then
        pressHandler(transParam, x, y)
      end
      return true
    end
  end
  
  local function btLiftHandler(x, y, cancelClick)
    if cancelPressHandler then
      cancelPressHandler(transParam, x, y)
    end
    if not tolua.isnull(press) then
      press:setVisible(false)
    end
    if not cancelClick and isClick(x, y) and clickHandler then
      clickHandler(x, y)
    end
  end
  
  return self:btGetBaseClickHandler({
    pressHandler = btPressHandler,
    cancelPressHandler = btCancelPressHandler,
    liftHandler = liftHandler or btLiftHandler,
    mcpMode = param.mcpMode,
    clickInterval = param.clickInterval
  })
end

class.btGetRectClickHandler = btGetRectClickHandler

local function btRegisterRectClick(self, param)
  local handler = self:btGetRectClickHandler(param)
  param.handler = handler
  self:btRegisterMainTouchHandler(param)
end

class.btRegisterRectClick = btRegisterRectClick

local function btGetCircleClickHandler(self, param)
  if not param then
    EDLog("U must set the param of the button handler! --circle click")
    return
  end
  local center = param.center
  local radius = param.radius
  local parent = param.parent
  local pressHandler = param.pressHandler
  local cancelPressHandler = param.cancelPressHandler
  local clickHandler = param.clickHandler
  local liftHandler = param.liftHandler
  local transParam = param.param
  local cliprect = param.cliprect
  
  local function isClick(x, y)
    if cliprect and not ed.isPointInRect(cliprect, x, y) then
      return false
    end
    if ed.isPointInCircle(center, radius, x, y, parent) then
      return true
    end
    return false
  end
  
  local btCancelPressHandler = cancelPressHandler or function()
  end
  
  local function btPressHandler(x, y)
    if isClick(x, y) then
      if pressHandler then
        pressHandler(transParam)
      end
      return true
    end
  end
  
  local function btLiftHandler(x, y, cancelClick)
    if cancelPressHandler then
      cancelPressHandler(transParam)
    end
    if not cancelClick and isClick(x, y) and clickHandler then
      clickHandler(x, y)
    end
  end
  
  return self:btGetBaseClickHandler({
    pressHandler = btPressHandler,
    cancelPressHandler = btCancelPressHandler,
    liftHandler = liftHandler or btLiftHandler,
    mcpMode = param.mcpMode,
    clickInterval = param.clickInterval
  })
end

class.btGetCircleClickHandler = btGetCircleClickHandler

local function btRegisterCircleClick(self, param)
  local handler = self:btGetCircleClickHandler(param)
  param.handler = handler
  self:btRegisterMainTouchHandler(param)
end

class.btRegisterCircleClick = btRegisterCircleClick

local function btGetMainTouchHandler(self)
  self.btMainTouchHandlerList = self.btMainTouchHandlerList or {}
  self.btTouchPriority = self.btTouchPriority or {}
  self.btFlagBeganEvent = self.btFlagBeganEvent or {}
  local swallowPriority
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        swallowPriority = nil
      end
      local flagBeganEvent = self.btFlagBeganEvent
      for i, priority in ipairs(self.btTouchPriority) do
        flagBeganEvent[priority] = flagBeganEvent[priority] or {}
        if priority <= (swallowPriority or priority) then
          for handler_key, handler in pairs(self.btMainTouchHandlerList[priority] or {}) do
            if type(handler) == "function" then
              if event == "began" then
                flagBeganEvent[priority][handler_key] = handler(event, x, y)
              elseif event == "moved" then
                handler(event, x, y, flagBeganEvent[priority][handler_key])
              elseif event == "ended" then
                handler(event, x, y, flagBeganEvent[priority][handler_key])
                flagBeganEvent[priority][handler_key] = nil
              end
              if flagBeganEvent[priority][handler_key] then
                swallowPriority = priority
              end
            end
          end
        end
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.btGetMainTouchHandler = btGetMainTouchHandler

local function btSetTouchPriority(self, key, priority)
  local handler
  for _, priorityList in pairs(self.btMainTouchHandlerList) do
    for touchKey, touchHandler in pairs(priorityList) do
      if touchKey == key and type(touchHandler) == "function" then
        handler = touchHandler
        priorityList[touchKey] = "placeholder"
      end
    end
  end
  self.btMainTouchHandlerList = self.btMainTouchHandlerList or {}
  self.btMainTouchHandlerList[priority] = self.btMainTouchHandlerList[priority] or {}
  self:addTouchPriority(priority)
  self.btMainTouchHandlerList[priority][key] = handler
end

class.btSetTouchPriority = btSetTouchPriority

local function addTouchPriority(self, priority)
  self.btTouchPriority = self.btTouchPriority or {}
  local ptDump, ptAdded
  for k, v in ipairs(self.btTouchPriority) do
    if self.btTouchPriority[k + 1] and v < priority and priority < self.btTouchPriority[k + 1] then
      table.insert(self.btTouchPriority, k + 1, priority)
      ptAdded = true
    end
    if v == priority then
      ptDump = true
    end
  end
  if not ptDump and not ptAdded then
    if #self.btTouchPriority > 0 and priority < self.btTouchPriority[1] then
      table.insert(self.btTouchPriority, 1, priority)
    else
      table.insert(self.btTouchPriority, priority)
    end
  end
end

class.addTouchPriority = addTouchPriority

local function btRegisterMainTouchHandler(self, param)
  if not param then
    return
  end
  local key = param.key
  local handler = param.handler
  local priority = param.priority or 0
  local force = param.force
  self.btMainTouchHandlerList = self.btMainTouchHandlerList or {}
  self.btMainTouchHandlerList[priority] = self.btMainTouchHandlerList[priority] or {}
  self:addTouchPriority(priority)
  local list = self.btMainTouchHandlerList[priority]
  if key then
    if force then
      list[key] = handler
    elseif list[key] then
      EDLog(string.format("Error : click handler dumplicated.(%s)", key))
      return
    end
    list[key] = handler
  else
    table.insert(list, handler)
  end
end

class.btRegisterMainTouchHandler = btRegisterMainTouchHandler

local function btRemoveMainTouchHandler(self, param)
  param = param or {}
  local key = param.key
  if not key then
    return
  end
  self.btMainTouchHandlerList = self.btMainTouchHandlerList or {}
  local list = self.btMainTouchHandlerList
  for k, v in pairs(list) do
    (v or {})[key] = nil
  end
end

class.btRemoveMainTouchHandler = btRemoveMainTouchHandler

local function btClearMainTouchHandler(self)
  self.btMainTouchHandlerList = {}
end

class.btClearMainTouchHandler = btClearMainTouchHandler
