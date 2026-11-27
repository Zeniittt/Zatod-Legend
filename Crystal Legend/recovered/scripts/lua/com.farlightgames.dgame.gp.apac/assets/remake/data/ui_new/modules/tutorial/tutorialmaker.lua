local ed = ed
local res = ed.tutorialres
local class = {
  mt = {}
}
class.mt.__index = class
ed.tutorialmaker = class

local function registerTouchHandler(self, k, handler)
  self.touchHandler[k or #(self.touchHandler or {}) + 1] = handler
end

class.registerTouchHandler = registerTouchHandler

local function removeTouchHandler(self, k)
  self.touchHandler[k] = nil
end

class.removeTouchHandler = removeTouchHandler

local function clearTouchHandler(self)
  self.touchHandler = {}
end

class.clearTouchHandler = clearTouchHandler

local function destroy(self)
  if self and not tolua.isnull(self.mainLayer) then
    self.mainLayer:removeFromParentAndCleanup(true)
  end
end

class.destroy = destroy

local function fadeIn(self)
  if tolua.isnull(self.container) then
    return
  end
  self.container:setOpacity(0)
  local fade = CCFadeIn:create(0.2)
  self.container:runAction(fade)
end

class.fadeIn = fadeIn

local function fadeOut(self)
  if tolua.isnull(self.container) then
    return
  end
  local action = self:getFadeOutAction()
  self.container:runAction(action)
end

class.fadeOut = fadeOut

local function create()
  local self = {}
  self.mainLayer = nil
  self.animLayer = CCLayer:create()
  self.animLayer:setAnchorPoint(ccp(0.5, 0.5))
  self.container = CCSprite:create()
  self.container:setCascadeOpacityEnabled(true)
  self.dialogContainer = CCSprite:create()
  self.dialogContainer:setCascadeOpacityEnabled(true)
  self.touchHandler = {}
  return self
end

class.create = create

local function doLockedLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.touchHandler) do
        v(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doLockedLayerTouch = doLockedLayerTouch

local function createLockedLayer()
  local self = create()
  setmetatable(self, class.mt)
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self:doLockedLayerTouch(), false, -305, true)
  self.mainLayer:addChild(self.container)
  self.mainLayer:addChild(self.animLayer)
  return self
end

class.createLockedLayer = createLockedLayer

local function createExhibitionLayer(key, stageRes)
  local er = res[key]
  local panel = CCSprite:create()
  local bs = ed.getCurrentScene()
  local bg = ed.createSprite("UI/alpha/1080P/common/main_vit_tips.png")
  bg:setPosition(er.bg_pos)
  panel:addChild(bg)
  if res[key].icon_bg_res or stageRes and stageRes.stageBgRes then
    local node = ed.createSprite(res[key].icon_bg_res or stageRes.stageBgRes)
    node:setPosition(er.icon_bg_pos)
    panel:addChild(node, 1)
    if res[key].icon_bg_scale then
      node:setScale(res[key].icon_bg_scale)
    end
  end
  if res[key].icon_res or stageRes and stageRes.stageRes then
    local node = ed.createSprite(res[key].icon_res or stageRes.stageRes)
    node:setPosition(er.icon_pos)
    panel:addChild(node, 2)
    if res[key].icon_scale then
      node:setScale(res[key].icon_scale)
    end
  end
  if res[key].fca_res or stageRes and stageRes.fca then
    if res[key].fca_res then
      local node
      node = ed.createFcaNode(res[key].fca_res)
      if res[key].fca_scale then
        node:setScale(res[key].fca_scale)
      end
      local x = bs and bs:addFca(node)
      node:setPosition(er.fca_pos)
      panel:addChild(node, 1)
    elseif stageRes.fca then
      for i = 1, #stageRes.fca.fca do
        local node
        node = ed.createFcaActor(string.gsub(stageRes.fca.fca[i], "%.cha$", ""), er.fca_scale)
        node:setAction("Idle")
        node:setLoop(true)
        node:setPosition(stageRes.fca.pos[i])
        local x = bs and bs:addFca(node)
        panel:addChild(node, 1)
      end
    end
  end
  local light = ed.createSprite(er.light_bg or "UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(er.light_pos)
  light:setScale(er.light_scale)
  panel:addChild(light)
  local rotate = CCRotateBy:create(5, 360)
  rotate = CCRepeatForever:create(rotate)
  light:runAction(rotate)
  local label, label_second, texts, text
  
  local function needWrap()
    if string.find(text, "\n") then
      return true
    end
  end
  
  if res[key].text or stageRes then
    text = res[key].text or stageRes.text
    if needWrap() then
      texts = Split(text, "\n")
      label = ed.createttf(texts[1] or text, res.label_size)
      label_second = ed.createttf(texts[2] or "", res.label_size)
    else
      label = ed.createttf(text, res.label_size)
    end
  end
  
  local function addLable(label, pos)
    ed.setLabelColor(label, res[key].fontColor)
    label:setPosition(pos)
    panel:addChild(label, 1)
  end
  
  if needWrap() then
    addLable(label, er.label_posup)
    addLable(label_second, er.label_posdown)
  else
    addLable(label, er.label_pos)
  end
  return class.createCommonExhibitionLayer(key, panel)
end

class.createExhibitionLayer = createExhibitionLayer

local function doUnlockedLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.touchHandler) do
        v(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doUnlockedLayerTouch = doUnlockedLayerTouch

local function createUnlockedLayer()
  local self = create()
  setmetatable(self, class.mt)
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self:doUnlockedLayerTouch(), false, -305, false)
  self.mainLayer:addChild(self.container)
  self.mainLayer:addChild(self.animLayer)
  return self
end

class.createUnlockedLayer = createUnlockedLayer

local function createTipsMode()
  local self = createUnlockedLayer()
  setmetatable(self, class.mt)
  return self
end

class.createTipsMode = createTipsMode

local function createExhibitionMode()
  local self = createLockedLayer()
  setmetatable(self, class.mt)
  return self
end

class.createExhibitionMode = createExhibitionMode

local function getFinger(key, layer, x, y)
  local circle = ed.createSprite(res[key].circle_res or "UI/alpha/1080P/guide/tutorial_circle.png")
  circle:setPosition(ccp(x, y))
  layer:addChild(circle)
  local s1 = CCScaleTo:create(0.65, 1.35)
  local s2 = CCScaleTo:create(0.65, 1)
  local action = CCSequence:createWithTwoActions(s1, s2)
  action = CCRepeatForever:create(action)
  circle:runAction(action)
  local isFlipX = res[key].finger_be_left
  local finger = ed.createSprite("UI/alpha/1080P/guide/tutorial_finger.png")
  finger:setPosition(ccp(x - 4, y + 4))
  if isFlipX then
    finger:setFlipX(true)
    finger:setAnchorPoint(ccp(1, 1))
    x1, y1 = x - 13.5, y - 13.5
    x2, y2 = x + 4, y + 4
  else
    x1, y1 = x + 13.5, y - 13.5
    x2, y2 = x - 4, y + 4
    finger:setAnchorPoint(ccp(0, 1))
  end
  layer:addChild(finger)
  local m1 = CCMoveTo:create(0.65, ccp(x1, y1))
  local m2 = CCMoveTo:create(0.65, ccp(x2, y2))
  local action = CCSequence:createWithTwoActions(m1, m2)
  action = CCRepeatForever:create(action)
  finger:runAction(action)
  return circle, finger
end

class.getFinger = getFinger

local function setDuration(self, key)
  if not (not res.use_bubble_duration or res[key].duration) or res[key].duration and res[key].duration == 0 then
  else
    self:setTipsDuration(res[key].duration or res.base_show_duration)
  end
end

class.setDuration = setDuration
ed.registerOverloadFunc(class, "createCommonFingerLayer", {
  types = {
    "string",
    "userdata",
    "boolean"
  },
  func = function(key, button, skipFade)
    local self = createTipsMode()
    local key = key
    local layer = self.container
    local x, y = button:getPosition()
    local circle, finger = getFinger(key, layer, x, y)
    self:registerTouchHandler(key, self:createClickDisappearHandler(key, layer, button))
    self:setDuration(key)
    if not skipFade then
      self:fadeIn()
    end
    return self
  end
})
ed.registerOverloadFunc(class, "createCommonFingerLayer", {
  types = {
    "string",
    "userdata",
    "number",
    "number",
    "boolean"
  },
  func = function(key, button, x, y, skipFade)
    local self = createTipsMode()
    local key = key
    local layer = self.container
    local circle, finger = getFinger(key, layer, x, y)
    self:registerTouchHandler(key, self:createClickDisappearHandler(key, layer, button))
    self:setDuration(key)
    if not skipFade then
      self:fadeIn()
    end
    return self
  end
})
ed.registerOverloadFunc(class, "createCommonFingerLayer", {
  types = {
    "string",
    "userdata",
    "number",
    "userdata",
    "boolean"
  },
  func = function(key, pos, radius, parent, skipFade)
    local self = createTipsMode()
    local key = key
    local layer = self.container
    local x, y = pos.x, pos.y
    if res[key].circle_center then
      pos = res[key].circle_center
      x, y = pos.x, pos.y
    end
    if res[key].circle_radius then
      radius = res[key].circle_radius
    end
    local circle, figer = getFinger(key, layer, x, y)
    self:registerTouchHandler(key, self:createClickDisappearHandler(key, layer, pos, radius, parent))
    self:setDuration(key)
    if not skipFade then
      self:fadeIn()
    end
    return self
  end
})
ed.setOverloadFunc(class, "createCommonFingerLayer")

function class.getChessFinger(key, layer, x, y, targetPos)
  local endPos = targetPos or ccp(x, y)
  local isFlipX = res[key].finger_be_left
  local finger = ed.createSprite("UI/alpha/1080P/guide/tutorial_finger.png")
  finger:setPosition(ccp(x - 4, y + 4))
  if isFlipX then
    finger:setFlipX(true)
    finger:setAnchorPoint(ccp(1, 1))
    x1, y1 = x, y
    x2, y2 = endPos.x, endPos.y
  else
    x1, y1 = x, y
    x2, y2 = endPos.x, endPos.y
    finger:setAnchorPoint(ccp(0, 1))
  end
  layer:addChild(finger)
  local m1 = CCMoveTo:create(1.5, ccp(x1, y1))
  local m2 = CCMoveTo:create(1.5, ccp(x2, y2))
  local action = CCSequence:createWithTwoActions(m1, m2)
  action = CCRepeatForever:create(action)
  finger:runAction(action)
  return circle, finger
end

function class.createChessFingerLayer(key, pos, radius, parent, skipFade, targetPos)
  local self = createTipsMode()
  local key = key
  local layer = self.container
  local x, y = pos.x, pos.y
  if res[key].circle_center then
    pos = res[key].circle_center
    x, y = pos.x, pos.y
  end
  if res[key].circle_radius then
    radius = res[key].circle_radius
  end
  local circle, figer = getFinger(key, layer, x, y)
  self:registerTouchHandler(key, self:createClickDisappearHandler(key, layer, pos, radius, parent))
  self:setDuration(key)
  if not skipFade then
    self:fadeIn()
  end
  return self
end

function class.createMoveFingerLayer(key, pos, radius, parent, skipFade, targetPos)
  local self = createTipsMode()
  local key = key
  local layer = self.container
  local x, y = pos.x, pos.y
  if res[key].circle_center then
    pos = res[key].circle_center
    x, y = pos.x, pos.y
  end
  if res[key].circle_radius then
    radius = res[key].circle_radius
  end
  local circle, figer = class.getChessFinger(key, layer, x, y, targetPos)
  self:setDuration(key)
  if not skipFade then
    self:fadeIn()
  end
  return self
end

function class.createChessTipsLayer(key, pos, radius, parent, targetPos, isMove)
  local object
  if isMove then
    object = class.createMoveFingerLayer(key, pos, radius, parent, true, targetPos)
  else
    object = class.createChessFingerLayer(key, pos, radius, parent, true, targetPos)
  end
  object:getArrowBubbleNew(key, pos.x, pos.y)
  return object
end

function class.createTipsLayerNoFinger(key, pos)
  local object = createTipsMode()
  object:setDuration(key)
  object:getArrowBubbleNew(key, pos.x, pos.y)
  return object
end

local function getArrowBubble(self, key, x, y)
  if not res[key].text then
    return
  end
  local layer = self.container
  local arrowDirection = res[key].arrowDirection or "right"
  local bubbleType = res[key].bubbleType or "big"
  local bubbleScaleMode = res[key].bubbleScaleMode or "vertical"
  local xMode
  if arrowDirection == "down" or arrowDirection == "up" then
    xMode = false
  else
    xMode = true
  end
  local ax = x + (res[key].arrowOffsetx or res[key].offsetx or 0)
  local ay = y + (res[key].arrowOffsety or res[key].offsety or 0)
  self:createArrow(layer, ccp(ax, ay), arrowDirection)
  local bx = x + (res[key].bubbleOffsetx or res[key].offsetx or 0)
  local by = y + (res[key].bubbleOffsety or res[key].offsety or 0)
  if xMode then
    bx = bx + res.bubble_arrow_gap[bubbleType or "big"][arrowDirection]
  else
    by = by + res.bubble_arrow_gap[bubbleType or "big"][arrowDirection]
  end
  self:createBubble(layer, res[key].text, ccp(bx, by), bubbleType, bubbleScaleMode)
  self:fadeIn()
end

class.getArrowBubble = getArrowBubble

local function getArrowBubbleNew(self, key, x, y)
  if not res[key].text then
    return
  end
  local layer = self.container
  local arrowDirection = res[key].arrowDirection or "right"
  local bubbleType = res[key].bubbleType or "big"
  local bubbleScaleMode = res[key].bubbleScaleMode or "vertical"
  local xMode
  if arrowDirection == "down" or arrowDirection == "up" then
    xMode = false
  else
    xMode = true
  end
  local ax = x + (res[key].arrowOffsetx or res[key].offsetx or 0)
  local ay = y + (res[key].arrowOffsety or res[key].offsety or 0)
  self:createArrow(layer, ccp(ax, ay), arrowDirection)
  local bx = x + (res[key].bubbleOffsetx or res[key].offsetx or 0)
  local by = y + (res[key].bubbleOffsety or res[key].offsety or 0)
  if xMode then
    bx = bx + res.bubble_arrow_gap[bubbleType or "big"][arrowDirection]
  else
    by = by + res.bubble_arrow_gap[bubbleType or "big"][arrowDirection]
  end
  self:createBubbleNew(layer, res[key], ccp(bx, by), bubbleType, res[key])
  self:fadeIn()
end

class.getArrowBubbleNew = getArrowBubbleNew
ed.registerOverloadFunc(class, "createCommonTipsLayer", {
  types = {
    "string",
    "userdata",
    "string",
    "string",
    "string"
  },
  func = function(key, button)
    local self = class.createCommonFingerLayer(key, button, true)
    local x, y = button:getPosition()
    self:getArrowBubble(key, x, y)
    return self
  end
})
ed.registerOverloadFunc(class, "createCommonTipsLayer", {
  types = {
    "string",
    "userdata",
    "number",
    "userdata",
    "string",
    "string",
    "string"
  },
  func = function(key, pos, radius, parent)
    local self = class.createCommonFingerLayer(key, pos, radius, parent, true)
    self:getArrowBubble(key, pos.x, pos.y)
    return self
  end
})
ed.setOverloadFunc(class, "createCommonTipsLayer")

local function createCommonExhibitionLayer(key, panel, handlers)
  local self = createExhibitionMode()
  ed.playEffect(ed.sound.tutorial.exhibition)
  self.animLayer:addChild(panel)
  self:setScaleInAction()
  self:registerTouchHandler(key, self:createClickScaleOutHandler(key, self.animLayer))
  for k, v in pairs(handlers or {}) do
    self:registerTouchHandler(k, v)
  end
  return self
end

class.createCommonExhibitionLayer = createCommonExhibitionLayer

local function createArrow(self, layer, pos, direction)
  direction = direction or "right"
  local x, y = pos.x, pos.y
  local dx, dy = res.arrow_amplitude_xy[direction].x, res.arrow_amplitude_xy[direction].y
  local arrow = ed.createSprite(res.arrow_res[direction])
  if direction == "up" then
    arrow:setFlipY(true)
  end
  arrow:setPosition(pos)
  layer:addChild(arrow)
  self.arrow = arrow
end

class.createArrow = createArrow

local function createBubble(self, layer, text, pos, type, direction)
  type = type or "big"
  direction = direction or "vertical"
  local dimensions = res.label_dimensions[type .. "_" .. direction]
  local bubble = ed.createScale9Sprite(res.bubble_res[type], res.spriteRect[type])
  bubble:setContentSize(res.bubble_size[type])
  layer:addChild(bubble)
  bubble:setPosition(pos)
  bubble:setCascadeOpacityEnabled(true)
  self.bubble = bubble
  local label = ed.createttf(text, res.label_size)
  if direction == "vertical" then
    label:setDimensions(dimensions)
  end
  ed.setLabelColor(label, res.label_color)
  ed.setLabelStroke(label, res.stroke_color, 1)
  self.bubble:addChild(label)
  self.label = label
  local lSize = label:getContentSize()
  local bSize = bubble:getContentSize()
  local scalex, scaley = 1, 1
  if lSize.width > bSize.width then
    local w = lSize.width
    scalex = w / bSize.width
    bSize = CCSizeMake(w, bSize.height)
  elseif lSize.height > bSize.height then
    local h = lSize.height
    scaley = h / bSize.height
    bSize = CCSizeMake(bSize.width, h)
  end
  bubble:setContentSize(bSize)
  label:setScaleX(1 / scalex)
  label:setScaleY(1 / scaley)
  label:setPosition(bSize.width / 2, bSize.height / 2 + lSize.height / 2)
end

class.createBubble = createBubble

local function createBubbleNew(self, layer, config, pos, type)
  type = type or "big"
  local bubble = ed.createScale9Sprite(res.bubble_res[type], res.spriteRect[type])
  bubble:setContentSize(config.contentSize or res.bubble_size[type])
  layer:addChild(bubble)
  bubble:setPosition(pos)
  bubble:setCascadeOpacityEnabled(true)
  self.bubble = bubble
  local bSize = bubble:getContentSize()
  local label = ed.createttf(config.text, config.label_size or 16)
  label:limitSizeByScale(bSize.width - 20, bSize.height - 20)
  ed.setLabelColor(label, res.label_color)
  ed.setLabelStroke(label, res.stroke_color, 1)
  self.bubble:addChild(label)
  self.label = label
  label:setPosition(bSize.width / 2, bSize.height / 2)
end

class.createBubbleNew = createBubbleNew
ed.registerOverloadFunc(class, "createClickDisappearHandler", {
  types = {
    "table",
    "string",
    "userdata",
    "userdata"
  },
  func = function(self, key, layer, element)
    local function handler(event, x, y)
      if event == "began" then
        if ed.containsPoint(element, x, y) then
          self.isPress = true
          
          self.pressx, self.pressy = x, y
        end
      elseif event == "moved" then
        if res[key].need_check_drag and self.pressx and self.pressy then
          local ox, oy = self.pressx, self.pressy
          local dis = (ox - x) * (ox - x) + (oy - y) * (oy - y)
          dis = math.sqrt(dis)
          if dis <= (res[key].drag_range or res.default_drag_range) then
            self.dragMode = true
          end
        end
      elseif event == "ended" then
        local k = self.isPress
        self.isPress = nil
        if k and ed.containsPoint(element, x, y) then
          local action = self:getFadeOutAction()
          layer:stopAllActions()
          layer:runAction(action)
          self:removeTouchHandler(key)
        end
      end
    end
    
    return handler
  end
})
ed.registerOverloadFunc(class, "createClickDisappearHandler", {
  types = {
    "table",
    "string",
    "userdata",
    "userdata",
    "number",
    "userdata"
  },
  func = function(self, key, layer, pos, radius, parent)
    local function handler(event, x, y)
      if event == "began" then
        if ed.isPointInCircle(pos, radius, x, y, parent) then
          self.isPress = true
          
          self.pressx, self.pressy = x, y
        end
      elseif event == "moved" then
        if res[key].need_check_drag and self.pressx and self.pressy then
          local ox, oy = self.pressx, self.pressy
          local dis = (ox - x) * (ox - x) + (oy - y) * (oy - y)
          dis = math.sqrt(dis)
          if dis <= (res[key].drag_range or res.default_drag_range) then
            self.dragMode = true
          end
        end
      elseif event == "ended" then
        if self.dragMode then
          self.dragMode = nil
          return
        end
        local k = self.isPress
        self.isPress = nil
        if k and ed.isPointInCircle(pos, radius, x, y, parent) then
          local action = self:getFadeOutAction()
          layer:stopAllActions()
          layer:runAction(action)
          self:removeTouchHandler(key)
          FireEvent("TutorialFinished", key)
        end
      end
    end
    
    return handler
  end
})
ed.setOverloadFunc(class, "createClickDisappearHandler")

local function createClickScaleOutHandler(self, key, layer)
  local function handler(event, x, y)
    if event == "began" then
    elseif event == "ended" then
      local action = self:getScaleOutAction()
      layer:stopAllActions()
      layer:runAction(action)
      self:removeTouchHandler(key)
    end
  end
  
  return handler
end

class.createClickScaleOutHandler = createClickScaleOutHandler

local function setScaleInAction(self)
  local layer = self.animLayer
  layer:setScale(0)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseBackOut:create(action)
  layer:runAction(action)
end

class.setScaleInAction = setScaleInAction

local function getFadeOutAction(self)
  local action = CCFadeOut:create(0.5)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:destroy()
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(action, func)
  return sequence
end

class.getFadeOutAction = getFadeOutAction

local function getScaleOutAction(self)
  local action = CCScaleTo:create(0.2, 0)
  action = CCEaseBackIn:create(action)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:destroy()
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(action, func)
  return sequence
end

class.getScaleOutAction = getScaleOutAction

local function setTipsDuration(self, duration)
  self.durationID = self.mainLayer:getScheduler():scheduleScriptFunc(self:getDurationHandler(duration), 0, false)
end

class.setTipsDuration = setTipsDuration

local function getDurationHandler(self, duration)
  local count = 0
  local id
  local scheduler = self.mainLayer:getScheduler()
  local done
  
  local function handler(dt)
    xpcall(function()
      count = count + dt
      if not id then
        id = self.durationID
      end
      if not self then
        self:removeDurationHandler(scheduler, id)
        return
      end
      if tolua.isnull(self.mainLayer) then
        self:removeDurationHandler(scheduler, id)
        return
      end
      if count > duration and not done then
        local action = self:getFadeOutAction()
        self.container:runAction(action)
        self:removeDurationHandler(scheduler, id)
        done = true
      end
    end, EDDebug)
  end
  
  return handler
end

class.getDurationHandler = getDurationHandler

local function removeDurationHandler(self, scheduler, id)
  if not tolua.isnull(scheduler) then
    scheduler:unscheduleScriptEntry(id)
  end
end

class.removeDurationHandler = removeDurationHandler
local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.tutorialDialog = class
local winLeft, winRight, winTop, winBottom = ed.getDisplayVertex()

local function getPercentPos(pos)
  local x, y = pos.x, pos.y
  x = winLeft + (winRight - winLeft) * x
  y = winBottom + (winTop - winBottom) * y
  return x, y
end

class.getPercentPos = getPercentPos

local function destroy(self)
  if not tolua.isnull(self.mainLayer) then
    self.mainLayer:removeFromParentAndCleanup(true)
  end
end

class.destroy = destroy

local function fadeOut(self)
  if not tolua.isnull(self.container) then
    local fade = CCFadeOut:create(0.2)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self:destroy()
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(fade, func)
    self.container:runAction(sequence)
  end
end

class.fadeOut = fadeOut

local function doButtonTouch(self)
  local button = self.addition.button
  
  local function handler(event, x, y)
    if event == "began" then
      if tolua.isnull(button) then
        return
      end
      if ed.containsPoint(button, x, y) then
        self.isPressTargetButton = true
      end
    elseif event == "ended" then
      if tolua.isnull(button) then
        return
      end
      local k = self.isPressTargetButton
      self.isPressTargetButton = nil
      if k and ed.containsPoint(button, x, y) and not self.dragMode then
        self:destroy()
      end
    end
  end
  
  return handler
end

class.doButtonTouch = doButtonTouch

local function doPosTouch(self)
  local pos = self.addition.pos
  local radius = self.addition.radius
  local parent = self.addition.parent
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.isPointInCircle(pos, radius, x, y, parent) then
        self.isPressInCircle = true
      end
    elseif event == "ended" then
      local k = self.isPressInCircle
      self.isPressInCircle = nil
      if k and ed.isPointInCircle(pos, radius, x, y, parent) and not self.dragMode then
        self:destroy()
      end
    end
  end
  
  return handler
end

class.doPosTouch = doPosTouch

local function doCloseTouch(self)
  local function handler(event, x, y)
    if event == "began" then
    elseif event == "ended" and not self.dragMode then
      self:destroy()
    end
  end
  
  return handler
end

class.doCloseTouch = doCloseTouch

local function doCheckDrag(self)
  local function handler(event, x, y)
    if event == "began" then
      self.pressx, self.pressy = x, y
    elseif event == "moved" then
      if self.info.need_check_drag and self.pressx and self.pressy and not self.dragMode then
        local ox, oy = self.pressx, self.pressy
        local dis = (ox - x) * (ox - x) + (oy - y) * (oy - y)
        dis = math.sqrt(dis)
        if dis <= (self.info.drag_range or res.default_drag_range) then
          self.dragMode = true
        end
      end
    elseif event == "ended" then
    end
  end
  
  return handler
end

class.doCheckDrag = doCheckDrag

local function doMainLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      self:doCheckDrag()(event, x, y)
      
      if not self.addition then
        self:doCloseTouch()(event, x, y)
      elseif self.addition.button then
        self:doButtonTouch()(event, x, y)
      elseif self.addition.pos then
        self:doPosTouch()(event, x, y)
      end
      if event == "ended" then
        self.dragMode = nil
        if self.info.dialog_click_destroy then
          self:destroy()
        end
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function showPopAnim(self)
  local dir = res[self.key].dialog_pop_from
  if not dir then
    return
  end
  if dir == "top" then
    self.container:setPosition(ccp(0, res.popTop))
  elseif dir == "bottom" then
    self.container:setPosition(ccp(0, res.popBottom))
  elseif dir == "left" then
    self.container:setPosition(ccp(res.popLeft, 0))
  elseif dir == "right" then
    self.container:setPosition(ccp(res.popRight, 0))
  end
  local m = CCMoveTo:create(res.popGap, ccp(0, 0))
  m = CCEaseBackOut:create(m)
  if res[self.key].dialog_pop_delay then
    local delay = CCDelayTime:create(res[self.key].dialog_pop_delay)
    m = CCSequence:createWithTwoActions(delay, m)
  end
  self.container:runAction(m)
end

class.showPopAnim = showPopAnim

local function create(key, addition)
  local self = {}
  setmetatable(self, class.mt)
  self.key = key
  local info = res[key]
  self.info = info
  local lock = info.dialog_lock
  self.addition = addition
  if not info.dialog_text then
    return self
  end
  local mainLayer = CCLayerColor:create(info.dialog_layer_color and ccc4(0, 0, 0, 150) or ccc4(0, 0, 0, 0))
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -305, lock)
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  mainLayer:addChild(container)
  self.container = container
  local head = ed.createSprite(info.dialog_head_res or "UI/alpha/HVGA/tutorial_head_cm.png")
  local pos = info.dialog_head_pos or ccp(0, 0)
  local x, y = getPercentPos(pos)
  head:setAnchorPoint(ccp(0, 0))
  head:setPosition(ccp(x, y))
  container:addChild(head, 1)
  local bht = info.dialog_head_width or 60
  local bwt = info.dialog_talk_width or 320
  head:setScale(bht * 2 / head:getContentSize().width)
  if info.dialog_head_flip then
    head:setFlipX(true)
  end
  local talkBg = ed.createSprite("UI/alpha/1080P/guide/dialogmask.png")
  local ts = talkBg:getContentSize()
  talkBg:setScaleX(bwt / ts.width)
  talkBg:setScaleY(bht / ts.height)
  if info.dialog_head_flip then
    talkBg:setFlipX(true)
  end
  talkBg:setAnchorPoint(ccp(0, 0))
  container:addChild(talkBg)
  local text = ed.createttf(info.dialog_text, 18)
  text:setHorizontalAlignment(kCCTextAlignmentLeft)
  ed.setLabelDimensions(text, CCSizeMake(bwt - 1.3 * bht, 0))
  ed.setLabelShadow(text, ccc3(0, 0, 0), ccp(0, 2))
  text:setAnchorPoint(ccp(0, 0.5))
  container:addChild(text)
  local dir = info.dialog_head_side or "left"
  if dir == "left" then
    talkBg:setPosition(ccp(x + bht * 1.4, y + bht * 0.2))
    text:setPosition(ccp(x + bht * 2.1, y + bht * 0.7))
  elseif dir == "right" then
    talkBg:setPosition(ccp(x - bwt + 0.6 * bht, y + bht * 0.2))
    text:setPosition(ccp(x - bwt + 1.2 * bht, y + bht * 0.7))
  end
  self:showPopAnim()
  return self
end

class.create = create
