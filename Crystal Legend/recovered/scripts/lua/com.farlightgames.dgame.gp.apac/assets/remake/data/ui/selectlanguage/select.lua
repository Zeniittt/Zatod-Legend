local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.selectlanguage.select = class
local isSetupSelect

function class:exit()
  self:destroy()
  isSetupSelect = nil
end

local function getConfigList(self)
  if isSetupSelect then
    return {
      {
        text = "Play Now",
        res = "installer/language/language_flag_english.png",
        clickHandler = function()
          ed.setLanguage("en")
          self:exit()
        end
      },
      {
        text = "\229\174\137\232\163\133\228\184\173\230\150\135\232\175\173\232\168\128\229\140\133",
        res = "installer/language/language_flag_chinese.png",
        clickHandler = function()
          self:exit()
        end
      },
      {
        text = "\224\184\149\224\184\180\224\184\148\224\184\149\224\184\177\224\185\137\224\184\135\224\184\129\224\184\165\224\185\136\224\184\173\224\184\135\224\184\160\224\184\178\224\184\169\224\184\178\224\185\132\224\184\151\224\184\162",
        res = "installer/language/language_flag_thai.png",
        clickHandler = function()
          self:exit()
        end
      }
    }
  else
    return {
      {
        text = "English",
        res = "installer/language/language_flag_english.png",
        clickHandler = function()
          if ed.selectlanguage.doSelectLanguage("en") == "done" then
            ed.showToast("Language successfully changed.")
            self:exit()
          end
        end
      },
      {
        text = "\228\184\173\230\150\135",
        res = "installer/language/language_flag_chinese.png",
        clickHandler = function()
          if ed.selectlanguage.doSelectLanguage("cn") == "done" then
            ed.showToast("\232\174\190\231\189\174\232\175\173\232\168\128\230\136\144\229\138\159")
            self:exit()
          end
        end
      },
      {
        text = "\224\184\160\224\184\178\224\184\169\224\184\178\224\185\132\224\184\151\224\184\162",
        res = "installer/language/language_flag_thai.png",
        clickHandler = function()
          if ed.selectlanguage.doSelectLanguage("thai") == "done" then
            ed.showToast("\224\184\149\224\184\177\224\185\137\224\184\135\224\184\132\224\185\136\224\184\178\224\184\160\224\184\178\224\184\169\224\184\178\224\184\170\224\184\179\224\185\128\224\184\163\224\185\135\224\184\136")
            self:exit()
          end
        end
      }
    }
  end
end

class.getConfigList = getConfigList

local function registerTouchHandler(self)
  local ui = self.ui
  local param = self.param
  if not param.isSetupSelect then
    self:btRegisterOutClick({
      area = ui.frame,
      key = "out_click",
      clickHandler = function()
        self:destroy()
      end,
      clickInterval = 0.5
    })
  end
end

class.registerTouchHandler = registerTouchHandler

local function initWindow(self)
  local ui = self.ui
  local list = self:getConfigList()
  local info = {
    cliprect = CCRectMake(120, 60, 560, 318),
    rect = CCRectMake(120, 125, 560, 129),
    container = self.container,
    position = ccp(100, 30),
    priority = -800,
    noshade = true,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(info)
  local num = #self:getConfigList()
  self.draglist:initListSize({
    width = num * 172 + 8 * (num - 1),
    height = 300
  }, false)
  self.draglist:addItem(self:addLanguageList())
end

class.initWindow = initWindow

function class:doPressInList()
  local function getButton(id)
    return self.uilist[id].language_bg, self.uilist[id].language_bg_press
  end
  
  local function handler(x, y)
    for i = 1, #self.uilist do
      local button, press = getButton(i)
      if ed.containsPoint(button, x, y) then
        press:setVisible(true)
        return i
      end
    end
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, i)
    self:getConfigList()[i].clickHandler()
    
    self.uilist[i].language_bg_press:setVisible(false)
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, i)
    self.uilist[i].language_bg_press:setVisible(false)
  end
  
  return handler
end

function class:cancelClickInList()
  local function handler(x, y, i)
    self.uilist[i].language_bg_press:setVisible(false)
  end
  
  return handler
end

local function create(param)
  local self = base.create("selectlanguage")
  setmetatable(self, class.mt)
  param = param or {}
  self.param = param
  isSetupSelect = param.isSetupSelect
  local mainLayer = self.mainLayer
  local container = self.container
  local container
  container, self.ui = ed.editorui(ed.uieditor.selectlanguagewindow)
  self:setContainer(container)
  self:registerTouchHandler()
  if param.isSetupSelect then
    self.isSkipTransAnim = true
  end
  self:initWindow()
  self:show()
  return self
end

class.create = create

local function pop(self, param, z)
  local window = create(param)
  window:popWindow(z)
end

class.pop = pop

function class:addLanguageList()
  local languagelist = getConfigList()
  local uilist = {}
  local layer = CCLayer:create()
  local x = 3 < #languagelist and 100 or 120
  local space = 180
  for k, v in pairs(languagelist) do
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "language_bg",
          res = "installer/language/language_bg_1.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(x + (k - 1) * space, 200)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "language_bg_press",
          parent = "language_bg",
          res = "installer/language/language_bg_2.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(86, 94)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "language_flag_bg",
          parent = "language_bg",
          res = "installer/language/language_flag_frame.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(86, 94)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "language_flag",
          parent = "language_bg",
          res = v.res
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(86, 94)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "language_text_bg",
          parent = "language_bg",
          res = "installer/tip_detail_bg.png",
          capInsets = CCRectMake(20, 15, 90, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(86, -20)
        },
        config = {
          scaleSize = CCSizeMake(150, 30)
        }
      },
      {
        t = "Label",
        base = {
          name = "language_text",
          text = v.text,
          parent = "language_text_bg",
          size = 18
        },
        layout = {
          position = ccp(64, 18),
          anchor = ccp(0.5, 0.5)
        },
        config = {}
      }
    }
    uilist[k] = uilist[k] or {}
    local readNode = ed.readnode.create(layer, uilist[k])
    readNode:addNode(ui_info)
  end
  self.uilist = uilist
  return layer
end
