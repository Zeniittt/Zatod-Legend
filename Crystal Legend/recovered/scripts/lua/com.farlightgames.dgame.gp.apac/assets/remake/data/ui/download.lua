local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.download = class

local function createBar(self)
  local ui = self.ui
  ui.barBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_bar_bg.png"
    },
    layout = {
      position = ccp(400, 60)
    }
  }, self.mainLayer)
  ui.bar = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_bar.png"
    },
    layout = {
      anchor = ccp(0, 0)
    }
  }, ui.barBg)
  ui.bar:setTextureRect(CCRectMake(0, 0, 0, 25))
  ui.lightLayer = CCLayer:create()
  ui.lightLayer:setClipRect(CCRectMake(15, -240, 400, 480))
  ui.barBg:addChild(ui.lightLayer)
  ui.barLight = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_bar_light.png"
    },
    layout = {
      anchor = ccp(0.9, 0)
    }
  }, ui.lightLayer)
  ui.explaination = ed.createNode({
    t = "Label",
    base = {
      text = T(""),
      size = 18
    },
    layout = {
      position = ed.getCenterPos(ui.barBg)
    },
    config = {
      shadow = {
        color = ccc3(0, 0, 0),
        offset = ccp(0, 2)
      }
    }
  }, ui.barBg)
end

class.createBar = createBar

local function refreshBar(self, percent)
  local ui = self.ui
  percent = math.min(percent, 1)
  local width, height = 318 * percent, 25
  ui.bar:setTextureRect(CCRectMake(0, 0, width, height))
  ui.barLight:setPosition(ccp(math.min(width, 298.91999999999996), 0))
end

class.refreshBar = refreshBar

local function rotateFlower(self)
  local ui = self.ui
  local gap = 0.1
  local count = 0
  
  local function handler(dt)
    count = count + dt
    if count > gap then
      count = count - gap
      ui.loadIcon:setRotation((ui.loadIcon:getRotation() + 30) % 360)
    end
  end
  
  return handler
end

class.rotateFlower = rotateFlower

local function createExplanation(self)
  local ui = self.ui
  ui.descriContainer = ed.createNode({t = "Sprite"}, self.mainLayer)
  ui.labelBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_label_bg.png"
    },
    layout = {
      position = ccp(400, 105)
    }
  }, ui.descriContainer)
  ui.descri = ed.createNode({
    t = "Label",
    base = {text = "", size = 20},
    layout = {
      position = ccp(400, 105)
    },
    config = {
      shadow = {
        color = ccc3(0, 0, 0),
        offset = ccp(0, 2)
      }
    }
  }, ui.descriContainer)
  ui.loadIcon = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/load_flower.png"
    }
  }, ui.descriContainer)
  self:refreshDescription(self.param.description or T("\230\155\180\230\150\176\228\184\173\226\128\166\226\128\166"))
  self:registerUpdateHandler("flower_rotate", self:rotateFlower())
end

class.createExplanation = createExplanation

local function refreshDescription(self, text)
  local ui = self.ui
  ed.setString(ui.descri, text)
  local ui = self.ui
  local x = 400 - ui.descri:getContentSize().width / 2 - 20
  ui.loadIcon:setPosition(ccp(x, 105))
  local width = ui.descri:getContentSize().width + ui.loadIcon:getContentSize().width
  ui.labelBg:setScaleX(width / ui.labelBg:getContentSize().width)
end

class.refreshDescription = refreshDescription

local function refreshExplanation(self, text)
  local ui = self.ui
  ed.setString(ui.explaination, text)
end

class.refreshExplanation = refreshExplanation

local function checkVersion(self)
  local text_list = {
    cn = "\228\184\139\232\189\189\232\181\132\230\186\144\229\140\133\229\164\177\232\180\165\239\188\140\230\152\175\229\144\166\233\135\141\230\150\176\228\184\139\232\189\189\239\188\159",
    en = "Downloading failed , try again?",
    thai = "\224\184\129\224\184\178\224\184\163\224\184\148\224\184\178\224\184\167\224\184\153\224\185\140\224\185\130\224\184\171\224\184\165\224\184\148\224\184\130\224\185\137\224\184\173\224\184\161\224\184\185\224\184\165\224\184\156\224\184\180\224\184\148\224\184\158\224\184\165\224\184\178\224\184\148 \224\184\165\224\184\173\224\184\135\224\185\131\224\184\171\224\184\161\224\185\136\224\184\173\224\184\181\224\184\129\224\184\132\224\184\163\224\184\177\224\185\137\224\184\135\224\184\171\224\184\163\224\184\183\224\184\173\224\185\132\224\184\161\224\185\136?"
  }
  if ed.checkLanguageUpdate(self.param.language, self.param.definition) then
    ed.showConfirmDialog({
      text = text_list[self.param.language] or "\228\184\139\232\189\189\232\181\132\230\186\144\229\140\133\229\164\177\232\180\165\239\188\140\230\152\175\229\144\166\233\135\141\230\150\176\228\184\139\232\189\189\239\188\159",
      leftHandler = function()
        ed.popScene()
      end,
      rightHandler = function()
        ed.popScene()
        ed.selectlanguage.doDownload(self.param)
      end
    })
    return false
  end
  self:refreshDescription(T("\228\184\139\232\189\189\229\174\140\230\136\144"))
  self.param.callback()
  return true
end

class.checkVersion = checkVersion

local function getUpdateHandler(self)
  local count = 0
  local hasShowFailed, eof
  
  local function handler(dt)
    count = count + dt
    local progress = LoadResources:getProgress()
    if not eof then
      if LoadResources:getCode() == 4 and not hasShowFailed then
        self:refreshExplanation(T("\232\191\158\230\142\165\230\156\141\229\138\161\229\153\168\229\164\177\232\180\165\226\128\166\226\128\166"))
        ed.showAlertDialog({
          text = T("\232\191\158\230\142\165\230\156\141\229\138\161\229\153\168\229\164\177\232\180\165\227\128\130\n\230\152\175\229\144\166\233\135\141\232\175\149\239\188\159"),
          handler = function()
            xpcall(function()
              hasShowFailed = nil
              self:doUpdating()
            end, EDDebug)
          end,
          buttonText = T("\231\161\174\229\174\154")
        })
        hasShowFailed = true
      elseif LoadResources:getCode() == 3 then
        self:refreshExplanation("")
        self:refreshBar(1)
        if LoadResources:isEnd() then
          self.param.callback()
          eof = true
        end
      elseif LoadResources:getCode() == 1 then
        local step = LoadResources:getStep()
        local des = LoadResources:getDes()
        if EDLanguageArea == "korea" then
          des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "\236\151\133\235\141\176\236\157\180\237\138\184 \236\164\145")
          des = string.gsub(des, "\230\173\163\229\156\168\229\174\137\232\163\133\230\155\180\230\150\176", "\236\150\180\237\148\140\235\166\172\236\188\128\236\157\180\236\133\152 \236\132\164\236\185\152 \236\164\145")
        end
        if EDLanguageArea == "vietnam" then
          des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "\196\144ang c\225\186\173p nh\225\186\173t")
          des = string.gsub(des, "\230\173\163\229\156\168\229\174\137\232\163\133\230\155\180\230\150\176", "\196\144ang c\195\160i \196\145\225\186\183t c\225\186\173p nh\225\186\173t")
        end
        if self.param.language == "thai" then
          des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "\224\184\129\224\184\179\224\184\165\224\184\177\224\184\135\224\184\173\224\184\177\224\184\158\224\185\128\224\184\148\224\184\151")
          des = string.gsub(des, "\230\173\163\229\156\168\229\174\137\232\163\133\230\155\180\230\150\176", "\224\184\129\224\184\179\224\184\165\224\184\177\224\184\135\224\184\149\224\184\180\224\184\148\224\184\149\224\184\177\224\185\137\224\184\135\224\184\129\224\184\178\224\184\163\224\184\173\224\184\177\224\184\158\224\185\128\224\184\148\224\184\151")
        elseif self.param.language == "en" then
          des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "Downloading")
        end
        self:refreshExplanation(des or "")
        self:refreshBar(progress)
        if LoadResources:isEnd() then
          self:checkVersion()
          self:refreshExplanation("")
          self:refreshBar(1)
          eof = true
        end
      end
    end
  end
  
  return handler
end

class.getUpdateHandler = getUpdateHandler

local function doUpdating(self)
  if self.param.versionKey ~= "" then
    LoadResources:initAutoUpdateParam(self.param.versionKey)
  else
    LoadResources:initAutoUpdateParam()
  end
  LoadResources:cancelResetAfterUpdate()
  LoadResources:update()
  self:registerUpdateHandler("downloading", self:getUpdateHandler())
end

class.doUpdating = doUpdating

local function create(param)
  local self = base.create("download")
  setmetatable(self, class.mt)
  param = param or {}
  self.param = param
  param.language = param.language or ed.loadLanguage()
  param.definition = param.definition or ed.loadDefinition()
  local versionKey = ""
  if param.language ~= "" then
    versionKey = param.language
  end
  if param.definition ~= "" then
    versionKey = versionKey ~= "" and versionKey .. "_" .. param.definition or param.definition
  end
  param.versionKey = versionKey
  param.callback = param.callback or function()
    ed.popScene()
  end
  local des_list = {
    cn = "\228\184\173\230\150\135\232\175\173\232\168\128\229\140\133\228\184\139\232\189\189\228\184\173\226\128\166\226\128\166",
    en = "Downloading",
    thai = "\224\184\148\224\184\178\224\184\167\224\184\153\224\185\140\224\185\130\224\184\171\224\184\165\224\184\148"
  }
  param.description = des_list[param.language]
  local mainLayer = self.mainLayer
  local container = self.container
  local bg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/splash.jpg"
    },
    layout = {
      position = ccp(400, 240)
    }
  }, mainLayer)
  self:createBar()
  self:createExplanation()
  self:doUpdating()
  return self
end

class.create = create
