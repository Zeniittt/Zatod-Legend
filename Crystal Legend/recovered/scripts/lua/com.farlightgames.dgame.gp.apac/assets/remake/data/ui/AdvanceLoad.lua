local AdvanceLoad = {}
AdvanceLoad.__index = AdvanceLoad
ed.ui.AdvanceLoad = AdvanceLoad
local AdvanceLoadPackage = {
  "dtcq_iPhone_v3.2.1.40482-v3.2.2.40647.zip",
  "dtcq_iPhone_v3.2.2.40647-v3.2.3.40647.zip",
  "dtcq_iPhone_v3.2.3.40647-v3.2.4.40647.zip",
  "dtcq_iPhone_v3.2.4.40647-v3.2.5.43893.zip",
  "dtcq_iPhone_v3.2.5.43893-v3.2.6.44943.zip",
  "dtcq_iPhone_v3.2.6.43893-v3.2.7.44943.zip"
}
local AdvanceLoadScope = {}
AdvanceLoad.loadIndex = 1

local function createBar(self)
  self.barBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/progress_bar_2.png"
    },
    layout = {
      position = ccp(ed.display.center.x - ed.display.halfFixedWidth, 60)
    }
  }, self.mainLayer)
  self.bar = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/progress_bar_1.png"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  }, self.barBg)
  self.bar:setTextureRect(CCRectMake(0, 0, 0, 25))
  self.lightLayer = CCLayer:create()
  self.lightLayer:setClipRect(CCRectMake(-15, -240, 810, 480))
  self.barBg:addChild(self.lightLayer)
  self.barLight = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_bar_light.png"
    },
    layout = {
      anchor = ccp(0.9, 0)
    }
  }, self.lightLayer)
  self.barFca = ed.createFcaNode("eff_UI_loading_dragon")
  self.barFca:setPosition(69, 14)
  ed.getCurrentScene():addFca(self.barFca)
  self.barLight:addChild(self.barFca, 1)
  self.labelPercent = ed.createLabelTTF("0%", 19)
  ed.setLabelStroke(self.labelPercent, ed.toccc3(1966594), 1.5)
  self.labelPercent:setPosition(ccp(780, 10))
  self.bar:addChild(self.labelPercent)
end

AdvanceLoad.createBar = createBar

local function refreshBar(self, percent)
  percent = math.min(percent, 1)
  local width, height = 763 * percent, 17
  ed.setString(self.labelPercent, string.format("%d%%", percent * 100))
  self.bar:setTextureRect(CCRectMake(0, 0, width, height))
  self.barLight:setPosition(ccp(math.min(width, 749.266), 0))
end

AdvanceLoad.refreshBar = refreshBar
local gap = 0.1
local count = 0

local function rotateFlower(self)
  count = count + 0.03
  if count > gap then
    count = count - gap
    self.loadIcon:setRotation((self.loadIcon:getRotation() + 30) % 360)
  end
end

AdvanceLoad.rotateFlower = rotateFlower

local function createExplanation(self)
  self.descriContainer = ed.createNode({
    t = "Sprite",
    layout = {
      position = ccp(-ed.display.halfFixedWidth, -70)
    }
  }, self.mainLayer)
  self.labelBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_label_bg.png"
    },
    layout = {
      position = ccp(ed.display.center.x, 105)
    },
    config = {visible = false}
  }, self.descriContainer)
  self.descri = ed.createNode({
    t = "Label",
    base = {
      text = T("\230\155\180\230\150\176\228\184\173..."),
      size = 19
    },
    layout = {
      position = ccp(ed.display.center.x, 105)
    }
  }, self.descriContainer)
  self.loadIcon = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/load_flower.png"
    }
  }, self.descriContainer)
  ed.setLabelStroke(self.descri, ed.toccc3(1513239), 1)
  self:refreshDescri()
  self.update_Flower = ListenTimer(Timer:Always(0.02, "Explanation"), function()
    self:rotateFlower()
  end)
end

AdvanceLoad.createExplanation = createExplanation

local function refreshDescri(self)
  local x = ed.display.center.x - self.descri:getContentSize().width / 2 - 20
  self.loadIcon:setPosition(ccp(x, 105))
  local width = self.descri:getContentSize().width + self.loadIcon:getContentSize().width
  self.labelBg:setScaleY(0.5)
  self.labelBg:setScaleX(width * 1.5 / self.labelBg:getContentSize().width)
end

AdvanceLoad.refreshDescri = refreshDescri

local function refreshExplanation(self, text)
  ed.setString(self.descri, text)
  self:refreshDescri()
end

AdvanceLoad.refreshExplanation = refreshExplanation

local function doUpdating(self)
  if self.update_timer then
    CloseTimer(self.update_timer.Name)
  end
  local testNewpackage = AdvanceLoadPackage
  if self.loadIndex > #testNewpackage then
    CloseTimer(self.update_Flower.Name)
    FireEvent("advanceLoad_complete", self.parentNode)
    self.parentNode = nil
    return
  end
  self.barBg:setVisible(true)
  local strPackage = testNewpackage[self.loadIndex]
  LoadResources:setAdvanceStr(strPackage)
  local key
  if multi_definition then
    key = ed.loadDefinition()
  end
  if (key or "") ~= "" then
    LoadResources:initAutoUpdateParam(key)
  else
    LoadResources:initAutoUpdateParam()
  end
  LoadResources:updateAdvanceZipFile()
  self.hasShowFailed = nil
  self.eof = nil
  self:refreshExplanation(T("\230\155\180\230\150\176\228\184\173..."))
  self:refreshBar(0)
  self.update_timer = ListenTimer(Timer:Always(0.016, "updateAdvanceZipFile"), self:updateAdvanceLoad())
end

AdvanceLoad.doUpdating = doUpdating

local function create(loadIndex, parent)
  local advance_load = {}
  setmetatable(advance_load, AdvanceLoad)
  advance_load.loadIndex = loadIndex
  advance_load.parentNode = parent
  advance_load.mainLayer = CCLayer:create()
  local mainLayer = advance_load.mainLayer
  local bg = ed.createNode({
    t = "Sprite",
    base = {
      res = ed.getSplash()
    },
    layout = {
      position = ccp(400, 240)
    }
  }, mainLayer)
  advance_load:createBar()
  advance_load:createExplanation()
  advance_load.barBg:setVisible(false)
  ListenTimer(Timer:Once(2), function()
    advance_load:doUpdating()
  end)
  return advance_load
end

AdvanceLoad.create = create

local function updateAdvanceLoad(self)
  local hasShowFailed, eof
  
  local function handler(dt)
    local progress = LoadResources:getProgress()
    if not eof then
      if LoadResources:getCode() == 13 and not hasShowFailed then
        self:refreshExplanation(T("\230\155\180\230\150\176\229\164\177\232\180\165\226\128\166\226\128\166"))
        ed.showAlertDialog({
          text = T("\230\155\180\230\150\176\231\154\132\230\150\135\228\187\182\229\144\141\228\184\186\231\169\186\229\173\151\231\172\166"),
          handler = function()
            xpcall(function()
              hasShowFailed = nil
              CloseTimer(self.update_Flower.Name)
              CloseTimer(self.update_timer.Name)
              FireEvent("advanceLoad_complete", self.parentNode)
              self.parentNode = nil
            end, EDDebug)
          end,
          buttonText = T("\231\161\174\229\174\154")
        })
        hasShowFailed = true
      elseif LoadResources:getCode() == 12 and not hasShowFailed then
        ed.showAlertDialog({
          text = T("\232\191\158\230\142\165\230\155\180\230\150\176\230\156\141\229\138\161\229\153\168\229\164\177\232\180\165"),
          handler = function()
            xpcall(function()
              hasShowFailed = nil
              CloseTimer(self.update_Flower.Name)
              CloseTimer(self.update_timer.Name)
              FireEvent("advanceLoad_complete", self.parentNode)
              self.parentNode = nil
            end, EDDebug)
          end,
          buttonText = T("\231\161\174\229\174\154")
        })
        hasShowFailed = true
      elseif LoadResources:getCode() == 1 then
        local step = LoadResources:getStep()
        local des = LoadResources:getDes()
        des = self:formatDes(des)
        self:refreshExplanation(des or T("\230\155\180\230\150\176\228\184\173..."))
        self:refreshBar(progress)
        if LoadResources:isEnd() then
          self:refreshExplanation(T("\230\155\180\230\150\176\230\136\144\229\138\159"))
          self:refreshBar(1)
          local key = ""
          if multi_definition then
            key = ed.loadDefinition()
          end
          local keyStr = "dt_advance_packge_" .. key
          ed.storage.setValue(keyStr, AdvanceLoadPackage[self.loadIndex])
          self.loadIndex = self.loadIndex + 1
          self:doUpdating()
          eof = true
        end
      end
    end
  end
  
  return handler
end

AdvanceLoad.updateAdvanceLoad = updateAdvanceLoad

local function formatDes(self, des)
  if ed.loadLanguage() == "thai" then
    des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "\224\184\129\224\184\179\224\184\165\224\184\177\224\184\135\224\184\173\224\184\177\224\184\158\224\185\128\224\184\148\224\184\151")
  elseif ed.loadLanguage() == "en" then
    des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "Downloading")
  end
  if EDLanguageArea == "korea" then
    des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "\236\151\133\235\141\176\236\157\180\237\138\184 \236\164\145")
    des = string.gsub(des, "\230\173\163\229\156\168\229\174\137\232\163\133\230\155\180\230\150\176", "\236\150\180\237\148\140\235\166\172\236\188\128\236\157\180\236\133\152 \236\132\164\236\185\152 \236\164\145")
  end
  if EDLanguageArea == "vietnam" then
    des = string.gsub(des, "\230\173\163\229\156\168\230\155\180\230\150\176", "\196\144ang c\225\186\173p nh\225\186\173t")
    des = string.gsub(des, "\230\173\163\229\156\168\229\174\137\232\163\133\230\155\180\230\150\176", "\196\144ang c\195\160i \196\145\225\186\183t c\225\186\173p nh\225\186\173t")
  end
  return des
end

AdvanceLoad.formatDes = formatDes
