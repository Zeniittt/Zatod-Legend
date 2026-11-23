local base = ed.ui.popwindow
local class = newclass(base.mt)
debugError = class
local content_x, content_y = 160, 60
local content_width, content_height = 578, 320
local lastCreateTime = 0
local interval = 100

local function showErrorMsg(self)
  self:initListLayer()
  for i, v in ipairs(self.errorMsg) do
    self:addItem(v)
  end
end

class.showErrorMsg = showErrorMsg

local function setPage(self, level)
  self:initListLayer()
  for key, value in pairs(self.stackValues[level] or {}) do
    if key == 1 then
      self:addItem(value)
    elseif key == "localValues" or key == "upValues" then
      self:addItem(key)
      for key2, value2 in pairs(value) do
        self:addItem(key2 .. " = " .. tostring(value2))
      end
    end
  end
end

class.setPage = setPage

local function getStackValues(self, level)
  self.stackValues = self.stackValues or {}
  local values = {}
  self.stackValues[level] = values
  values.upValues = {}
  values.localValues = {}
  values[1] = "------<" .. "level : " .. level - 2 .. ">------"
  level = level + 1
  local info = debug.getinfo(level)
  local i = 1
  local n, v
  repeat
    n, v = debug.getlocal(level, i)
    if n then
      values.localValues[n] = v
    end
    i = i + 1
  until n == nil
  local i = 1
  local n, v
  repeat
    n, v = debug.getupvalue(info.func or function()
    end, i)
    if n then
      values.upValues[n] = v
    end
    i = i + 1
  until n == nil
  level = level - 1
  self:addTabItem(level)
end

class.getStackValues = getStackValues

local function addItem(self, text, posX)
  if not text then
    return
  end
  local _, indent = string.gsub(text, "\t", "")
  local oy = 380
  local ox = posX and posX or content_x
  local indentDist = 20
  local dx = content_width
  local label = ed.createNode({
    t = "Label",
    base = {text = text, size = 16},
    layout = {
      anchor = ccp(0, 1)
    },
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(dx, 0)
    }
  })
  if tolua.isnull(self.lastItem) then
    label:setPosition(ccp(ox + indentDist * indent, oy))
  else
    label:setPosition(ccp(ox + indentDist * indent, ed.getBottomPos(self.lastItem, 5).y))
  end
  self.draglist:addItem(label)
  self.lastItem = label
  local height = self.draglist.listHeight + label:getContentSize().height + 5
  self.draglist:initListHeight(height)
end

class.addItem = addItem

local function initListLayer(self)
  if not tolua.isnull((self.draglist or {}).layer) then
    self.draglist.layer:removeFromParentAndCleanup(true)
  end
  local info = {
    cliprect = CCRectMake(content_x, content_y, content_width, content_height),
    noshade = true,
    container = self.container,
    priority = self.mainTouchPriority - 5,
    zorder = 10
  }
  local draglist = ed.draglist.create(info)
  self.draglist = draglist
  self.lastItem = nil
end

class.initListLayer = initListLayer

local function addTabItem(self, level, addition)
  addition = addition or {}
  local ox, oy = content_x - 100, 380
  local button = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/herodetail-upgrade.png"
    },
    layout = {
      anchor = ccp(0, 1)
    }
  })
  local press = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/herodetail-upgrade-mask.png"
    },
    layout = {
      position = ed.getCenterPos(button)
    },
    config = {visible = false}
  }, button)
  local label = ed.createNode({
    t = "Label",
    base = {
      text = addition.buttonText or "Level:" .. level - 2,
      size = 16
    },
    layout = {
      position = ed.getCenterPos(button)
    }
  }, button)
  if tolua.isnull(self.lastLevelButton) then
    button:setPosition(ccp(ox, oy))
  else
    button:setPosition(ed.getBottomPos(self.lastLevelButton))
  end
  self.lastLevelButton = button
  self.tabDraglist:addItem(button)
  self.tabDraglist:initListHeight(self.tabDraglist.listHeight + button:getContentSize().height)
  if addition.registerButtonClick then
    addition.registerButtonClick(button, press)
  else
    self:btRegisterButtonClick({
      button = button,
      press = press,
      key = "errorwindow_click_level_" .. level,
      clickHandler = function()
        self:setPage(level)
      end,
      force = true,
      mcpMode = true
    })
  end
end

class.addTabItem = addTabItem

local function initTabLayer(self)
  if not tolua.isnull((self.tabDraglist or {}).layer) then
    self.tabDraglist.layer:removeFromParentAndCleanup(true)
  end
  local info = {
    cliprect = CCRectMake(content_x - 100, content_y, 100, content_height),
    noshade = true,
    container = self.container,
    priority = self.mainTouchPriority - 5,
    zorder = 10,
    mcpMode = true
  }
  local draglist = ed.draglist.create(info)
  self.tabDraglist = draglist
  self.lastLevelButton = nil
  self:addTabItem(nil, {
    buttonText = "Error",
    registerButtonClick = function(button, press)
      self:btRegisterButtonClick({
        button = button,
        press = press,
        key = "errorwindow_back_2_errormsg",
        clickHandler = function()
          self:showErrorMsg()
        end,
        force = true
      })
    end
  })
end

class.initTabLayer = initTabLayer

local function initWindow(self)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "errorBg",
        res = "UI/alpha/1080P/common/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 250)
      },
      config = {
        scaleSize = CCSizeMake(700, 400)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/common_tips_button_close_1.png",
        parent = "errorBg"
      },
      layout = {
        anchor = ccp(1, 1),
        position = ccp(710, 410)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/1080P/common/common_tips_button_close_2.png",
        parent = "close"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = "Feral Bug",
        fontinfo = "title_yellow"
      },
      layout = {
        anchor = ccp(0.5, 1),
        position = ccp(400, 440)
      },
      listData = true
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
end

class.initWindow = initWindow

local function registerTouchHandler(self)
  self.isSkipTransAnim = true
  self:btRegisterButtonClick({
    button = self.ui.close,
    press = self.ui.close_press,
    key = "errorwindow_close_button",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

class.registerTouchHandler = registerTouchHandler

local function create(param)
  local self = base.create("debugerror")
  setmetatable(self, class.mt)
  param = param or {}
  self.stackValues = {}
  self.errorMsg = {}
  self:initWindow()
  self:registerTouchHandler()
  self:initListLayer()
  self:addItem(param.msg, param.posX)
  if not param.noShowTabl then
    self:initTabLayer()
  end
  return self
end

class.create = create

local function showError(msg)
  local window
  if tolua.isnull((errorWindow or {}).mainLayer) then
    if ed.getServerTime() - lastCreateTime > interval then
      lastCreateTime = ed.getServerTime()
      window = debugError.create({msg = msg})
      window:popWindow(5000)
      errorWindow = window
    end
  else
    errorWindow:addItem(msg)
    window = errorWindow
  end
  if msg and window then
    table.insert(window.errorMsg, msg)
  end
  return window
end

class.showError = showError

local function showLocalFileError(msg)
  local window
  window = debugError.create({
    msg = msg,
    posX = 6,
    noShowTabl = true
  })
  window:popWindow(5000)
  if msg and window then
    table.insert(window.errorMsg, msg)
  end
  return window
end

class.showLocalFileError = showLocalFileError
