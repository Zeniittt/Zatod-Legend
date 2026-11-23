local class = newclass()
ed.dialog = class
local normalColor = ccc3(251, 206, 16)
local pressColor = ccc3(255, 255, 255)
local resFactor = ed.display.resFactor

local function destroy(self, bn)
  if not tolua.isnull(self.bg) then
    local function doDestroy()
      self.layer:removeFromParentAndCleanup(true)
      
      if bn == "left" and self.leftDestroyHandler then
        self.leftDestroyHandler()
      end
      if bn == "right" and self.rightDestroyHandler then
        self.rightDestroyHandler()
      end
      ed.playEffect(ed.sound.dialog.closeWindow)
      normalColor = ccc3(251, 206, 16)
    end
    
    if self.skipDestroyAnim then
      doDestroy()
    elseif self.bg:numberOfRunningActions() == 0 then
      local action = CCScaleTo:create(0.2, 0)
      action = CCEaseBackIn:create(action)
      local sequence = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
        xpcall(function()
          doDestroy()
        end, EDDebug)
      end))
      self.bg:runAction(sequence)
    end
  end
end

class.destroy = destroy

local function setFrameScale(self, scale_x, scale_y)
  scale_x = scale_x or 1
  scale_y = scale_y or 1
  local w, h = 447, 283
  self.bg:setContentSize(ed.DGSizeMake(w * scale_x, h * scale_y))
  self.line:setScaleX(scale_x)
  self.line:setScaleY(scale_y)
  self.line:setPosition(ccp(172 * scale_x, 75))
end

class.setFrameScale = setFrameScale

local function create()
  local self = {}
  setmetatable(self, class.mt)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.layer = layer
  self.layer:setTouchEnabled(true)
  local bg = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "installer/dialog_bg.png",
      capInsets = CCRectMake(35.16 / resFactor, 82.03 / resFactor, 281.25 / resFactor, 62.5 / resFactor)
    },
    layout = {
      position = ed.display.center
    },
    contentSize = ed.DGSizeMake(447, 283)
  }, self.layer)
  self.bg = bg
  bg:setScale(0)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseBackOut:create(action)
  bg:runAction(action)
  local line = ed.createSprite("installer/dialog_line.png")
  line:setPosition(ccp(172, 75))
  self.line = line
  bg:addChild(line)
  ed.playEffect(ed.sound.dialog.openWindow)
  return self
end

class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.dialog
ed.alertDialog = class
setmetatable(class, base.mt)

local function doMainLayerTouch(self)
  local buttonTouch = self:doButtonTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      buttonTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function doButtonTouch(self)
  local isPressIn
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.button, x, y) then
          isPressIn = true
          self.buttonPress:setVisible(true)
          ed.setLabelColor(self.buttonLabel, pressColor)
        end
      elseif event == "ended" then
        local bp = isPressIn
        isPressIn = nil
        if bp then
          self.buttonPress:setVisible(false)
          ed.setLabelColor(self.buttonLabel, normalColor)
          if ed.containsPoint(self.button, x, y) then
            ed.playEffect(ed.sound.dialog.clickAlertOK)
            if self.handler then
              self.handler()
            end
            self:destroy()
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

class.doButtonTouch = doButtonTouch

local function create(info)
  local self = base.create()
  setmetatable(self, class.mt)
  self.skipDestroyAnim = info.skipDestroyAnim
  if info.frameScale then
    self:setFrameScale(info.frameScale, info.frameScale)
  else
    self:setFrameScale(info.frameScaleX, info.frameScaleY)
  end
  local buttonOffSetY = 0
  if info.heroStyle then
    local res = "UI/alpha/HVGA/awake/hero_task_bg.png"
    local posY = 80
    buttonOffSetY = 8
    if info.heroStyle == "superherotask" then
      res = "UI/alpha/HVGA/artifact/artifact_task_quest_background.png"
      posY = 90
      buttonOffSetY = 12
    end
    self.bg:initWithFile(CCRectMake(50, 50, 454, 133), res)
    self.bg:setContentSize(CCSizeMake(536, 255))
    local line = ed.createSprite("UI/alpha/HVGA/awake/separate_line.png")
    line:setPosition(ccp(self.bg:getContentSize().width * 0.5, posY))
    self.line:setVisible(false)
    self.bg:addChild(line)
  end
  if info.fixedText then
    self.bg:setContentSize(CCSizeMake(536, 300))
  end
  self.handler = info.handler
  self.layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -7000, true)
  local button = ed.createScale9Sprite("installer/herodetail-upgrade.png", CCRectMake(10, 10, 50, 29))
  self.button = button
  button:setContentSize(CCSizeMake(250, 49))
  button:setPosition(ccp(self.bg:getContentSize().width * 0.5, 44 + buttonOffSetY))
  self.bg:addChild(button)
  local buttonPress = ed.createScale9Sprite("installer/herodetail-upgrade-mask.png", CCRectMake(10, 10, 50, 29))
  self.buttonPress = buttonPress
  buttonPress:setContentSize(CCSizeMake(250, 49))
  buttonPress:setVisible(false)
  buttonPress:setAnchorPoint(ccp(0, 0))
  buttonPress:setPosition(ccp(0, 0))
  button:addChild(buttonPress)
  local buttonText = info.buttonText or T("\229\165\189\231\154\132")
  local buttonLabel = ed.createttf(buttonText, 22)
  ed.setLabelColor(buttonLabel, normalColor)
  buttonLabel:setPosition(ccp(125, 25))
  self.buttonLabel = buttonLabel
  button:addChild(buttonLabel, 1)
  return self
end

class.create = create

local function createWithText(info)
  if info == nil then
    info = {}
  end
  local text = info.text or ""
  local tColor = info.textColor or ccc3(112, 103, 94)
  local self = create(info)
  local alert
  if info.autoText then
    local alert = ed.ui.autoText.new()
    alert:initParam({
      color = tColor,
      context = info.autoText,
      fontSize = 20,
      maxWidth = self.bg:getContentSize().width * 0.8
    })
    local width, height = alert:getCurContentSize()
    alert.node:setPosition(ccp((self.bg:getContentSize().width - width) * 0.5, self.bg:getContentSize().height - (self.bg:getContentSize().height - height) * 0.5))
    self.bg:addChild(alert.node)
  else
    alert = ed.createttf(text, 20)
    alert:setDimensions(CCSizeMake(self.bg:getContentSize().width * 0.8, 125))
    alert:setHorizontalAlignment(kCCTextAlignmentLeft)
    alert:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    alert:setPosition(ccp(self.bg:getContentSize().width * 0.5, self.bg:getContentSize().height * 0.618))
    ed.setLabelColor(alert, tColor)
    self.bg:addChild(alert)
  end
  return self
end

class.createWithText = createWithText

local function createWithSprite(info)
  if info == nil then
    info = {}
  end
  local self = create(info)
  if info.sprite then
    info.sprite:setAnchorPoint(ccp(0, 0))
    info.sprite:setPosition(ccp(0, 0))
    self.bg:addChild(info.sprite)
  end
  if info.spriteLabel then
    local label = ed.createttf(info.spriteLabel, 20)
    label:setDimensions(CCSizeMake(300, 125))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    label:setPosition(ccp(172, 135))
    ed.setLabelColor(label, ccc3(112, 103, 94))
    self.bg:addChild(label)
  end
  if info.sprite_x then
    self.bg:setScaleX(sprite_x / self.bg:getContentSize().width)
    info.sprite:setScaleX(self.bg:getContentSize().width / sprite_x)
  end
  return self
end

class.createWithSprite = createWithSprite

local function showDialog(info, container)
  info = info or {}
  container = container or CCDirector:sharedDirector():getRunningScene()
  local self
  if info.sprite then
    self = createWithSprite(info)
  else
    self = createWithText(info)
  end
  container:addChild(self.layer, 1000)
  return self
end

class.showDialog = showDialog
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.dialog
ed.confirmDialog = class
setmetatable(class, base.mt)

local function doMainLayerTouch(self)
  local buttonTouch = self:doButtonTouch()
  local closeTouch = self:doCloseButtonTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      buttonTouch(event, x, y)
      if self.info.showCloseButton then
        closeTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function doCloseButtonTouch(self)
  local isPress
  
  local function handler(event, x, y)
    local button, press = self.close, self.closePress
    if tolua.isnull(button) then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(button, x, y) then
        press:setVisible(false)
        self:destroy()
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doCloseButtonTouch = doCloseButtonTouch

local function doButtonTouch(self)
  local isPressLeft, isPressRight
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.left, x, y) then
          isPressLeft = true
          self.leftPress:setVisible(true)
          ed.setLabelColor(self.leftLabel, pressColor)
        end
        if ed.containsPoint(self.right, x, y) then
          isPressRight = true
          self.rightPress:setVisible(true)
          ed.setLabelColor(self.rightLabel, pressColor)
        end
      elseif event == "ended" then
        local bp = isPressLeft
        isPressLeft = nil
        if bp then
          self.leftPress:setVisible(false)
          ed.setLabelColor(self.leftLabel, normalColor)
          if ed.containsPoint(self.left, x, y) then
            self.clickLeftPoint = self.clickLeftPoint or ed.getMillionTime() - 1
            local dp = ed.getMillionTime() - self.clickLeftPoint
            if 0.5 < dp then
              ed.playEffect(ed.sound.dialog.clickConfirmLeft)
              if self.leftHandler then
                self.leftHandler()
              end
              self:destroy("left")
              self.clickLeftPoint = ed.getMillionTime()
            end
          end
        end
        bp = isPressRight
        isPressRight = nil
        if bp then
          self.rightPress:setVisible(false)
          ed.setLabelColor(self.rightLabel, normalColor)
          if ed.containsPoint(self.right, x, y) then
            self.clickRightPoint = self.clickRightPoint or ed.getMillionTime() - 1
            local dp = ed.getMillionTime() - self.clickRightPoint
            if 0.5 < dp then
              ed.playEffect(ed.sound.dialog.clickConfirmRight)
              if self.rightHandler then
                self.rightHandler()
              end
              self:destroy("right")
              self.clickRightPoint = ed.getMillionTime()
            end
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

class.doButtonTouch = doButtonTouch

local function create(info)
  local self = base.create()
  setmetatable(self, class.mt)
  info = info or {}
  self.info = info
  if info.frameScale then
    self:setFrameScale(info.frameScale, info.frameScale)
  else
    self:setFrameScale(info.frameScaleX, info.frameScaleY)
  end
  local buttonOffSetY = 0
  local swapButton = 1
  if info.heroStyle then
    local res = "UI/alpha/HVGA/awake/hero_task_bg.png"
    local posY = 80
    buttonOffSetY = 8
    if info.heroStyle == "superherotask" then
      res = "UI/alpha/HVGA/artifact/artifact_task_quest_background.png"
      posY = 90
      buttonOffSetY = 12
    end
    self.bg:initWithFile(CCRectMake(50 / resFactor, 50 / resFactor, 454 / resFactor, 133 / resFactor), res)
    self.bg:setContentSize(CCSizeMake(536, 255))
    local line = ed.createSprite("UI/alpha/HVGA/awake/separate_line.png")
    line:setPosition(ccp(self.bg:getContentSize().width * 0.5, posY))
    self.line:setVisible(false)
    self.bg:addChild(line)
    swapButton = -1
  end
  if info.starshopStyle then
    self.bg:initWithFile(CCRectMake(0, 0, 466 / resFactor, 289 / resFactor), "UI/alpha/HVGA/shop_star_tips_frame.png")
    self.bg:setPosition(ccp(400, 200))
    local line = CCSprite:create("UI/alpha/HVGA/shop_star_tips_delimeter.png")
    line:setPosition(ccp(230, 102))
    self.bg:addChild(line)
  end
  self.leftHandler = info.leftHandler
  self.rightHandler = info.rightHandler
  self.leftDestroyHandler = info.leftDestroyHandler
  self.rightDestroyHandler = info.rightDestroyHandler
  local touch = self:doMainLayerTouch()
  self.layer:registerScriptTouchHandler(touch, false, -6001, true)
  local leftRes = info.leftRes or "installer/herodetail-upgrade.png"
  local left = ed.createScale9Sprite(leftRes, CCRectMake(10 / resFactor, 10 / resFactor, 50 / resFactor, 29 / resFactor))
  self.left = left
  left:setContentSize(CCSizeMake(120, 49))
  left:setPosition(ccp(self.bg:getContentSize().width * 0.5 - 70 * swapButton, 44 + buttonOffSetY))
  self.bg:addChild(left)
  local leftPressRes = info.leftPressRes or "installer/herodetail-upgrade-mask.png"
  local leftPress = ed.createScale9Sprite(leftPressRes, CCRectMake(10 / resFactor, 10 / resFactor, 50 / resFactor, 29 / resFactor))
  self.leftPress = leftPress
  leftPress:setContentSize(CCSizeMake(120, 49))
  leftPress:setVisible(false)
  leftPress:setAnchorPoint(ccp(0, 0))
  leftPress:setPosition(ccp(0, 0))
  left:addChild(leftPress)
  local leftText = info.leftText or T("\229\143\150\230\182\136")
  local leftLabel = ed.createttf(leftText, 22)
  ed.setLabelColor(leftLabel, normalColor)
  leftLabel:setPosition(ccp(60, 25))
  self.leftLabel = leftLabel
  left:addChild(leftLabel, 1)
  ed.setNodeMaxWidth(leftLabel, 100)
  local rightRes = info.rightRes or "installer/herodetail-upgrade.png"
  local right = ed.createScale9Sprite(rightRes, CCRectMake(10 / resFactor, 10 / resFactor, 50 / resFactor, 29 / resFactor))
  self.right = right
  right:setContentSize(CCSizeMake(120, 49))
  right:setPosition(ccp(self.bg:getContentSize().width * 0.5 + 70 * swapButton, 44 + buttonOffSetY))
  self.bg:addChild(right)
  local rightPressRes = info.rightPressRes or "installer/herodetail-upgrade-mask.png"
  local rightPress = ed.createScale9Sprite(rightPressRes, CCRectMake(10 / resFactor, 10 / resFactor, 50 / resFactor, 29 / resFactor))
  self.rightPress = rightPress
  rightPress:setContentSize(CCSizeMake(120, 49))
  rightPress:setVisible(false)
  rightPress:setAnchorPoint(ccp(0, 0))
  rightPress:setPosition(ccp(0, 0))
  right:addChild(rightPress)
  local rightText = info.rightText or T("\229\165\189\231\154\132")
  local rightLabel = ed.createttf(rightText, 22)
  ed.setLabelColor(rightLabel, normalColor)
  rightLabel:setPosition(ccp(60, 25))
  self.rightLabel = rightLabel
  right:addChild(rightLabel, 1)
  ed.setNodeMaxWidth(rightLabel, 100)
  if info.showCloseButton then
    local close = ed.createSprite("installer/herodetail-detail-close.png")
    close:setPosition(ed.DGccp(430, 265))
    self.bg:addChild(close, 10)
    self.close = close
    local closePress = ed.createSprite("installer/herodetail-detail-close-p.png")
    closePress:setAnchorPoint(ccp(0, 0))
    close:addChild(closePress)
    closePress:setVisible(false)
    self.closePress = closePress
  end
  if info.starshopStyle then
    local w, h = 120, 53
    left:setContentSize(CCSizeMake(w, h))
    leftPress:setContentSize(CCSizeMake(w, h))
    left:setPosition(ccp(141.02, 66.8))
    right:setContentSize(CCSizeMake(w, h))
    rightPress:setContentSize(CCSizeMake(w, h))
    right:setPosition(ccp(308.98, 64.45))
    normalColor = ccc3(255, 255, 255)
    ed.setLabelColor(leftLabel, ccc3(255, 255, 255))
    ed.setLabelColor(rightLabel, ccc3(255, 255, 255))
  end
  return self
end

class.create = create

local function createWithText(info)
  if info == nil then
    info = {}
  end
  local text = info.text or ""
  local offsetY = info.offsetY or 0
  local self = create(info)
  local equipSpace = 100
  local color = ccc3(112, 103, 94)
  local heightScale = 0.55
  if info.heroStyle == "superherotask" then
    color = ccc3(255, 255, 255)
    equipSpace = 120
    heightScale = 0.6
  end
  if info.equiplist and 0 < #info.equiplist then
    offsetY = 50
    local startX = self.bg:getContentSize().width * 0.3 - equipSpace * (#info.equiplist - 1) * 0.5
    for i = 1, #info.equiplist do
      local equipbg = ed.readequip.createIconWithAmount(info.equiplist[i], nil, ed.player.equip_qunty[info.equiplist[i]] or 0)
      local name = ed.createttf(ed.getDataTable("equip")[info.equiplist[i]].Name, 20)
      name:setAnchorPoint(ccp(0.5, 0.5))
      name:setPosition(ccp(equipbg:getContentSize().width * 0.5, equipbg:getContentSize().height * 0.5 - 55))
      ed.setLabelColor(name, ccc3(255, 255, 255))
      ed.setLabelShadow(name, ccc3(0, 0, 0), ccp(0, 2))
      equipbg:addChild(name)
      equipbg:setPosition(ccp(startX + equipSpace * i, self.bg:getContentSize().height * heightScale))
      equipbg:setScale(60 / equipbg:getContentSize().width)
      self.bg:addChild(equipbg, 1)
    end
  end
  local confirm
  local fontSize = info.fontSize or 20
  if info.autoText then
    local confirm = ed.ui.autoText.new()
    confirm:initParam({
      color = color,
      context = info.autoText,
      fontSize = fontSize,
      maxWidth = self.bg:getContentSize().width * 0.8
    })
    local width, height = confirm:getCurContentSize()
    confirm.node:setPosition(ccp((self.bg:getContentSize().width - width) * 0.5, self.bg:getContentSize().height - (self.bg:getContentSize().height - height) * 0.46 + offsetY))
    self.bg:addChild(confirm.node)
  else
    confirm = ed.createttf(text, fontSize, nil, info.anchor)
    confirm:setDimensions(CCSizeMake(self.bg:getContentSize().width * 0.8, 125))
    confirm:setHorizontalAlignment(kCCTextAlignmentLeft)
    confirm:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    confirm:setPosition(ccp(self.bg:getContentSize().width * 0.5, self.bg:getContentSize().height * 0.618 + offsetY))
    ed.setLabelColor(confirm, color)
    self.bg:addChild(confirm)
  end
  self.confirmLabel = confirm
  return self
end

class.createWithText = createWithText

local function createWithSprite(info)
  if info == nil then
    info = {}
  end
  local self = create(info)
  if info.sprite then
    info.sprite:setAnchorPoint(ccp(0, 0))
    info.sprite:setPosition(ccp(0, 0))
    self.bg:addChild(info.sprite)
  end
  if info.spriteLabel then
    local label = ed.createttf(info.spriteLabel, 20)
    label:setDimensions(CCSizeMake(300, 125))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    label:setPosition(ccp(172, 135))
    ed.setLabelColor(label, ccc3(112, 103, 94))
    self.bg:addChild(label)
    if info.starshopStyle then
      label:setPosition(ccp(250, 180))
      ed.setLabelColor(label, ccc3(129, 204, 255))
    end
  end
  if info.sprite_x then
    self.bg:setScaleX(info.sprite_x / self.bg:getContentSize().width)
    info.sprite:setScaleX(self.bg:getContentSize().width / info.sprite_x)
  end
  return self
end

class.createWithSprite = createWithSprite

local function showDialog(info, container)
  info = info or {}
  container = container or CCDirector:sharedDirector():getRunningScene()
  local self
  if info.sprite then
    self = createWithSprite(info)
  else
    self = createWithText(info)
  end
  self.skipDestroyAnim = info.skipDestroyAnim
  if container:getChildByTag(1000) then
    container:removeChildByTag(1000, true)
  end
  container:addChild(self.layer, 1000, 1000)
  return self
end

class.showDialog = showDialog
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.confirmDialog
ed.checkconfirmDialog = class
setmetatable(class, base.mt)

local function doMainLayerTouch(self)
  local buttonTouch = self:doButtonTouch()
  local closeTouch = self:doCloseButtonTouch()
  local checkTouch = self:doCheckButtonTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      buttonTouch(event, x, y)
      if self.info.showCloseButton then
        closeTouch(event, x, y)
      end
      checkTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doCheckMainLayerTouch = doMainLayerTouch

local function doButtonTouch(self)
  local isPressLeft, isPressRight
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.left, x, y) then
          isPressLeft = true
          self.leftPress:setVisible(true)
          ed.setLabelColor(self.leftLabel, pressColor)
        end
        if ed.containsPoint(self.right, x, y) then
          isPressRight = true
          self.rightPress:setVisible(true)
          ed.setLabelColor(self.rightLabel, pressColor)
        end
      elseif event == "ended" then
        local bp = isPressLeft
        isPressLeft = nil
        if bp then
          self.leftPress:setVisible(false)
          ed.setLabelColor(self.leftLabel, normalColor)
          if ed.containsPoint(self.left, x, y) then
            self.clickLeftPoint = self.clickLeftPoint or ed.getMillionTime() - 1
            local dp = ed.getMillionTime() - self.clickLeftPoint
            if 0.5 < dp then
              ed.playEffect(ed.sound.dialog.clickConfirmLeft)
              if self.leftHandler then
                self.leftHandler()
              end
              self:destroy("left")
              self.clickLeftPoint = ed.getMillionTime()
            end
          end
        end
        bp = isPressRight
        isPressRight = nil
        if bp then
          self.rightPress:setVisible(false)
          ed.setLabelColor(self.rightLabel, normalColor)
          if ed.containsPoint(self.right, x, y) then
            self.clickRightPoint = self.clickRightPoint or ed.getMillionTime() - 1
            local dp = ed.getMillionTime() - self.clickRightPoint
            if 0.5 < dp then
              ed.playEffect(ed.sound.dialog.clickConfirmRight)
              if self.rightHandler then
                self.rightHandler(self.selectCheck)
              end
              self:destroy("right")
              self.clickRightPoint = ed.getMillionTime()
            end
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

class.doButtonTouch = doButtonTouch

function class:doCheckButtonTouch()
  local isPressCheck
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.checkBtn, x, y) then
          isPressCheck = true
        end
      elseif event == "ended" then
        if isPressCheck then
          self.selectCheck = not self.selectCheck
          self.checkFlag:setVisible(self.selectCheck)
        end
        isPressCheck = nil
      end
    end, EDDebug)
  end
  
  return handler
end

local function showDialog(info, container)
  info = info or {}
  container = container or CCDirector:sharedDirector():getRunningScene()
  local self
  if info.sprite then
    self = createWithSprite(info)
  else
    self = createWithText(info)
  end
  setmetatable(self, class.mt)
  self.selectCheck = info.selectCheck or false
  self.layer:registerScriptTouchHandler(self:doCheckMainLayerTouch(), false, -7000, true)
  local contentSize = self.bg:getContentSize()
  contentSize.height = contentSize.height + 20
  self.bg:setContentSize(contentSize)
  if self.confirmLabel then
    local labelY = self.confirmLabel:getPositionY()
    self.confirmLabel:setPositionY(labelY + 20)
  end
  local lineY = self.line:getPositionY()
  self.checkBtn = ed.createScale9Sprite("UI/alpha/HVGA/guild/guildraid_select_frame.png")
  self.checkBtn:setPosition(ccp(50, lineY + 20))
  self.bg:addChild(self.checkBtn)
  local btnSize = self.checkBtn:getContentSize()
  self.checkFlag = ed.createSprite("UI/alpha/1080P/common/fragment_tick.png")
  self.checkFlag:setPosition(ccp(btnSize.width / 2, btnSize.height / 2))
  self.checkBtn:addChild(self.checkFlag)
  self.checkFlag:setVisible(self.selectCheck)
  self.checkLabel = ed.createttf("\228\187\138\230\151\165\228\184\141\229\134\141\230\143\144\231\164\186", 16)
  self.checkLabel:setAnchorPoint(ccp(0, 0.5))
  self.checkLabel:setPosition(ccp(80, lineY + 20))
  ed.setLabelColor(self.checkLabel, ccc3(112, 103, 94))
  self.bg:addChild(self.checkLabel)
  self.skipDestroyAnim = info.skipDestroyAnim
  if container:getChildByTag(1000) then
    container:removeChildByTag(1000, true)
  end
  container:addChild(self.layer, 1000, 1000)
  return self
end

class.showDialog = showDialog
ed.showCheckConfirmDialog = showDialog
local class = {
  mt = {}
}
class.mt.__index = class
local handyDialog = class

local function getScene()
  local scene = CCDirector:sharedDirector():getRunningScene()
  return scene
end

local function openMidas(config)
  local function handler()
    local callback = config.callback
    
    local refreshHandler = config.refreshHandler
    local priority = config.priority
    local ds = ed.playerlimit.getAreaUnlockPrompt("Midas")
    if ds then
      ed.showToast(ds)
      return
    end
    local scene = getScene()
    local midas = ed.ui.midasWin.create({
      callback = callback,
      refreshHandler = refreshHandler,
      priority = priority
    })
  end
  
  return handler
end

class.openMidas = openMidas

local function openRecharge(config)
  local function handler()
    local scene = getScene()
    
    local rechargeMgr = ed.RechargeNewMgr.getInstance()
    if true == rechargeMgr:isUseNewRechargeMedule() then
      ed.pushScene(ed.ui.recharge.create({
        page = config.page or "Diamonds",
        callback = config.callback
      }))
      if config.type then
        FireEvent("RechargeGotoDiamondsLayer", config.type)
      end
    else
      local rechargeLayer = ed.ui.recharge.create(config)
      scene:addChild(rechargeLayer.mainLayer, 200)
    end
  end
  
  return handler
end

class.openRecharge = openRecharge

local function openvipPower(vip)
  local function handler()
    local scene = getScene()
    
    local rechargeMgr = ed.RechargeNewMgr.getInstance()
    if true == rechargeMgr:isUseNewRechargeMedule() then
      ed.pushScene(ed.ui.recharge.create({
        page = "Diamonds",
        showDetail = true,
        showVip = vip
      }))
    else
      local rechargeLayer = ed.ui.recharge.create({type = "detail", showVip = vip})
      scene:addChild(rechargeLayer.mainLayer, 200)
    end
  end
  
  return handler
end

class.openvipPower = openvipPower

local function upBuyVitality(cost, reply)
  local function handler()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    elseif ed.player._rmb < cost then
      ed.showHandyDialog("toRecharge")
    else
      ed.netreply.buyVitalityReply = reply
      ed.netdata.buyVitality = {
        isBuy = true,
        cost = ed.player:getBuyVitalityCost()
      }
      local msg = ed.upmsg.buy_vitality()
      msg._type = "vitality"
      ed.send(msg, "buy_vitality")
    end
  end
  
  return handler
end

class.upBuyVitality = upBuyVitality

local function upBuyShadowRunes(cost, reply)
  local function handler()
    if not ed.player:canBuyShadowRunes() then
      ed.showToast(T("\228\189\160\231\154\132\232\131\189\233\135\143\233\157\162\229\140\133\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    elseif ed.player._rmb < cost then
      ed.showHandyDialog("toRecharge")
    else
      ed.netreply.buyVitalityReply = reply
      ed.netdata.buyVitality = {isBuy = true, cost = cost}
      local msg = ed.upmsg.buy_vitality()
      msg._type = "shadow_rune"
      ed.send(msg, "buy_vitality")
    end
  end
  
  return handler
end

class.upBuyShadowRunes = upBuyShadowRunes

local function upBuyVitalityWithEquip(id, number, reply)
  local function handler()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    else
      local item_info = ed.packItem(id, 1)
      ed.registerNetReply("eat_vitality", reply, {id = id, amount = number})
      ed.record:useItemCount(id, number)
      local msg = ed.upmsg.consume_item()
      msg._item = item_info
      ed.send(msg, "consume_item")
    end
  end
  
  return handler
end

class.upBuyVitalityWithEquip = upBuyVitalityWithEquip

local function createDialogIcon(text, icon)
  local sprite = CCSprite:create()
  local label = ed.createttf(text, 18)
  local num = ed.createttf("x1", 18)
  icon:setPosition(ccp(170, 120))
  label:setPosition(ccp(180, 180))
  num:setPosition(ccp(220, 120))
  ed.setLabelColor(label, ccc3(255, 255, 255))
  ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelColor(num, ccc3(255, 255, 255))
  ed.setLabelShadow(num, ccc3(0, 0, 0), ccp(0, 2))
  sprite:addChild(label)
  sprite:addChild(icon)
  sprite:addChild(num)
  return sprite
end

local function showHandyDialog(type, param)
  param = param or {}
  local active = param.active
  local vip = param.vip
  local number = param.number
  local name = param.name
  local reply = param.reply
  local callback = param.callback
  local refreshHandler = param.refreshHandler
  local explaination = param.explaination
  local wholeText = param.wholeText
  local priority = param.priority
  local tp = param.type or nil
  local text
  local rightText = T("\231\161\174\229\174\154")
  local handler, rightHandler, sprite
  if type == "useMidas" then
    text = T("\233\135\145\229\184\129\228\184\141\232\182\179\239\188\140\230\152\175\229\144\166\228\189\191\231\148\168\231\130\185\233\135\145\230\137\139\239\188\159")
    handler = openMidas({
      callback = callback,
      refreshHandler = refreshHandler,
      priority = priority
    })
  elseif type == "toRecharge" then
    text = explaination or T("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\230\152\175\229\144\166\229\133\133\229\128\188\239\188\159")
    local goodInfo = param.goodInfo
    handler = openRecharge({
      callback = callback,
      goodInfo = goodInfo,
      page = param.page or "Diamonds",
      type = tp
    })
  elseif type == "vipLocked" then
    if vip then
      text = T("vip\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167\232\167\163\233\148\129\232\175\165\229\138\159\232\131\189\227\128\130", vip)
    else
      text = name and T("\232\167\163\233\148\129%s\233\156\128\232\166\129\230\155\180\233\171\152\231\186\167\231\154\132vip\231\173\137\231\186\167", name) or T("\232\167\163\233\148\129\232\175\165\229\138\159\232\131\189\233\156\128\232\166\129\230\155\180\233\171\152\231\186\167\231\154\132vip\231\173\137\231\186\167")
    end
    rightText = T("\230\159\165\231\156\139\231\137\185\230\157\131")
    handler = openvipPower(vip)
  elseif type == "needHighervip" then
    text = ""
    if number and name then
      text = text .. T("\228\187\138\230\151\165\229\183\178%s%d\230\172\161.\n", name, number)
    end
    text = text .. T("%s\230\172\161\230\149\176\228\184\141\232\182\179\239\188\140\230\143\144\229\141\135vip\231\173\137\231\186\167\229\143\175\232\142\183\229\190\151\230\155\180\229\164\154\230\172\161\230\149\176\227\128\130", name or "")
    text = wholeText or text
    rightText = T("\230\159\165\231\156\139\231\137\185\230\157\131")
    handler = openvipPower(ed.player:getvip() + 1)
  elseif type == "buyVitalityWithDiamond" then
    if not ed.player:canBuyVitality() then
      showHandyDialog("needHighervip", {
        number = ed.player:getVitalityBuyTimes(),
        name = T("\232\180\173\228\185\176\228\189\147\229\138\155")
      })
      return
    end
    local cost = ed.player:getBuyVitalityCost()
    text = ""
    if active then
    else
      text = T("\228\189\147\229\138\155\228\184\141\232\182\179")
    end
    text = T("\232\138\177\232\180\185%d\233\146\187\231\159\179\232\180\173\228\185\176120\231\130\185\228\189\147\229\138\155\239\188\140\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159(\228\187\138\230\151\165\229\183\178\232\180\173\228\185\176%d\230\172\161)", cost, ed.player:getVitalityBuyTimes())
    handler = upBuyVitality(cost, reply)
  elseif type == "buyVitality" then
    if not ed.player:canBuyVitality() then
      showHandyDialog("needHighervip", {
        number = ed.player:getVitalityBuyTimes(),
        name = T("\232\180\173\228\185\176\228\189\147\229\138\155")
      })
      return
    end
    text = ""
    if active then
    else
      text = T("\228\189\147\229\138\155\228\184\141\232\182\179")
    end
    showHandyDialog("buyVitalityWithDiamond", {active = true, reply = reply})
    return
  end
  local info = {
    text = text,
    sprite = sprite,
    rightText = rightText,
    rightHandler = rightHandler,
    rightDestroyHandler = handler
  }
  ed.showConfirmDialog(info)
end

function ed.popSuperLinkAlertDialog(text, addr)
  local buttonText = T("\229\137\141\229\190\128")
  if addr == "" or addr == "DO NOT EXIT" then
    buttonText = T("\231\161\174\229\174\154")
  end
  ed.showAlertDialog({
    text = text,
    buttonText = buttonText,
    handler = function()
      if addr == "" then
        EDExit()
      elseif addr == "DO NOT EXIT" then
      else
        ed.openURL(addr)
      end
    end
  })
end

local CoerceUpdata = {}
CoerceUpdata.__index = CoerceUpdata
ed.coerceUpdata = CoerceUpdata

function CoerceUpdata.create(info)
  local self = {}
  setmetatable(self, CoerceUpdata)
  ed.printTable(info)
  self.SDKTypeList = info.SDKTypeList
  self.version = info.version
  self.configText = info.configText or "\230\163\128\230\181\139\229\136\176\230\156\128\230\150\176\231\137\136\230\156\172\239\188\140\232\175\183\229\137\141\229\190\128\228\184\139\232\189\189"
  self.buttonText = info.buttonText or "\231\161\174\232\174\164"
  self:show()
end

local function newDoButtonTouched(self)
  local isPressIn
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.containsPoint(self.button, x, y) then
          isPressIn = true
          self.buttonPress:setVisible(true)
          ed.setLabelColor(self.buttonLabel, pressColor)
        end
      elseif event == "ended" then
        local bp = isPressIn
        isPressIn = nil
        if bp then
          self.buttonPress:setVisible(false)
          ed.setLabelColor(self.buttonLabel, normalColor)
          if ed.containsPoint(self.button, x, y) then
            ed.playEffect(ed.sound.dialog.clickAlertOK)
            if self.handler then
              self.handler()
            end
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

function CoerceUpdata:changeAlertDialogButtonTouch()
  ed.alertDialog.doButtonTouch = newDoButtonTouched
end

function CoerceUpdata:show()
  local SDKTypeList = self.SDKTypeList
  if SDKTypeList[EDSDKType] then
    local function download()
      local config = SDKTypeList[EDSDKType]
      
      ed.showAlertDialog({
        text = self.configText,
        buttonText = self.buttonText,
        handler = function()
          if config.addr then
            ed.openURL(config.addr)
          end
        end
      })
    end
    
    if original_version then
      local versionNumberStr = string.sub(original_version, -5, -1)
      local versionNumber = tonumber(versionNumberStr)
      if versionNumber < self.version then
        self:changeAlertDialogButtonTouch()
        download()
      end
    end
  end
end
