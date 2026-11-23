local class = newclass("g")
ed.speedHelperFloating = class
class.floatingWindow = nil

function class.showFloating(isShow)
  if isShow then
    if not class.floatingWindow then
      class.floatingWindow = class.create()
    end
    class.floatingWindow:show()
  elseif class.floatingWindow then
    class.floatingWindow:close()
  end
end

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
  self.edge = 30
  self.autoAdapt = ed.display.winSize.width / 2
  self:initUI()
end

function class:initUI()
  local container = ed.getCurrentScene():getTopNode()
  local touchLayer = CCLayerColor:create(ccc4(0, 0, 0, 0))
  touchLayer:setContentSize(CCSizeMake(0, 0))
  self.touchLayer = touchLayer
  self.touchLayer:setTouchEnabled(true)
  self.touchLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -1000, true)
  container:addChild(touchLayer)
  local floatingIcon = ed.createSprite("UI/alpha/1080P/helper/helper_floating_window_release.png")
  touchLayer:addChild(floatingIcon)
  self.floatingIcon = floatingIcon
  local x = ed.storage.getInt("HelperPosX")
  local y = ed.storage.getInt("HelperPosY")
  if 0 < x or 0 < y then
    floatingIcon:setPosition(ccp(x, y))
    self:adaptIcon()
  else
    floatingIcon:setPosition(ccp(self.edge, ed.display.winSize.height - 120))
  end
end

function class:adaptIcon()
  local x, y = self.floatingIcon:getPosition()
  local winSize = ed.display.winSize
  if x > winSize.width / 2 then
    self.floatingIcon:setScaleX(-1)
  else
    self.floatingIcon:setScaleX(1)
  end
  if x < self.autoAdapt then
    self.floatingIcon:setPositionX(self.edge)
  end
  if x > winSize.width - self.autoAdapt then
    self.floatingIcon:setPositionX(winSize.width - self.edge)
  end
  if y > winSize.height - 50 then
    self.floatingIcon:setPositionY(winSize.height - 50)
  end
  if y < 50 then
    self.floatingIcon:setPositionY(50)
  end
end

function class:doMainLayerTouch()
  local function handler(event, x, y)
    return self:iconTouch(event, x, y)
  end
  
  return handler
end

function class:doCancelPress(x, y)
  ed.setTexture(self.floatingIcon, "UI/alpha/1080P/helper/helper_floating_window_release.png", true)
  ed.storage.setValue("HelperPosX", math.floor(x))
  ed.storage.setValue("HelperPosY", math.floor(y))
  self:adaptIcon()
end

function class:doClickIn()
  if ed.getPopWindow("speedHelperWindow") then
    return
  end
  ed.UITool.openView("speedHelperWindow")
end

function class:iconTouch(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.floatingIcon, x, y) then
      self.startX, self.startY = x, y
      return true
    end
  elseif event == "moved" then
    if self.startX and self.startY then
      ed.setTexture(self.floatingIcon, "UI/alpha/1080P/helper/helper_floating_window_press.png", true)
      self.floatingIcon:setPosition(ccp(x, y - 86))
      return true
    end
  elseif event == "ended" and self.startX and self.startY then
    self.floatingIcon:setPosition(ccp(x, y))
    self:doCancelPress(x, y)
    if math.abs(x - self.startX) < 20 and math.abs(y - self.startY) < 20 then
      self:doClickIn()
    end
    self.startX, self.startY = nil, nil
    return true
  end
  return false
end

function class:show()
  self.floatingIcon:setVisible(true)
  self.touchLayer:setTouchEnabled(true)
end

function class:close()
  self.floatingIcon:setVisible(false)
  self.touchLayer:setTouchEnabled(false)
end
