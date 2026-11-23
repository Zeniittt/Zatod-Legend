local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.popHeroFashion = class

local function create(param)
  local self = base.create("popHeroFashion")
  setmetatable(self, base.mt)
  local id = param.id
  local fashion_id = param.fashion_id
  local priority = param.priority
  local callback = param.callback
  local preHero = param.hero_before_fashion
  
  local function getHandler()
    local function handler()
      if callback then
        callback(id, preHero, fashion_id)
      end
      self:destroy()
    end
    
    return handler
  end
  
  local cardWindow = ed.ui.popherofashion.create({
    id = id,
    fashion_id = fashion_id,
    handler = getHandler(),
    priority = priority
  })
  self.mainLayer:addChild(cardWindow.mainLayer)
  self:cancelTouchLayer()
  return self
end

class.create = create
local class1 = {
  mt = {}
}
class1.mt.__index = class1
local base = ed.ui.popwindow
setmetatable(class1, base.mt)
ed.ui.popherofashion = class1
local lsr = ed.ui.popherocardlsr.create()

local function showCardUI(self)
  local ui = self.ui
  local fi = CCFadeIn:create(0.4)
  local s = CCSequence:createWithTwoActions(fi, CCCallFunc:create(function()
    xpcall(function()
      local r = CCRotateBy:create(5, 360)
      r = CCRepeatForever:create(r)
      self.light:runAction(r)
    end, EDDebug)
  end))
  self.light:runAction(s)
  local card_container = ui.card_container
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      card_container:setVisible(true)
      card_container:runAction(fi)
      local fb = ed.createFcaNode("eff_UI_tavern_bubble")
      fb:setPosition(ccp(400, 240))
      self.mainLayer:addChild(fb)
      self.baseScene:addFca(fb)
      fb:setScale(1.5)
      for fashion_id, effect_fca in pairs(ui.card_fashion_effect or {}) do
        self.baseScene:addFca(effect_fca)
      end
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  card_container:runAction(s)
  lsr:report("showCardAnim")
  local colorMap = {
    R = "red",
    G = "green",
    B = "blue"
  }
  local fn = ed.createFcaNode("eff_UI_tavern_card_" .. colorMap[self.color])
  fn:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  self.mainLayer:addChild(fn, 10)
  self.baseScene:addFca(fn)
  fn:setScale(1.5)
  self:registerTouchHandler()
  self:show()
end

class1.showCardUI = showCardUI

local function doClickLayer(self)
  if self.hasShowStone then
    if self.handler then
      self.handler()
    end
    self:destroy()
    return
  end
  if self.amount > 1 then
  else
    lsr:report("createGetNewHero")
    if not tolua.isnull(self.ui.card_container) then
      self.ui.card_container:removeFromParentAndCleanup(true)
    end
    local light = self.ui.light
    if not tolua.isnull(light) then
      light:removeFromParentAndCleanup(true)
    end
    if self.handler then
      self.handler()
    end
    self:destroy()
  end
end

class1.doClickLayer = doClickLayer

local function registerTouchHandler(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterClick({
    key = "click_layer",
    clickHandler = function(param)
      lsr:report("clickCardLayer")
      self:doClickLayer()
    end
  })
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, self.priority or self.mainTouchPriority, true)
end

class1.registerTouchHandler = registerTouchHandler

local function create(param)
  param = param or {}
  param.noShade = true
  local self = base.create("popherofashion", param)
  setmetatable(self, class1.mt)
  self.baseScene = ed.getCurrentScene()
  self.hid = param.id
  self.fashion_id = param.fashion_id
  self.star = ed.getDataTable("Unit")[self.hid]["Initial Stars"]
  self.amount = param.amount or 0
  self.handler = param.handler
  self.index = param.index
  self.priority = param.priority
  local mainLayer = self.mainLayer
  local ui = self.ui
  self.color = ed.getDataTable("Fashion")[self.fashion_id]["Bg Color"] or "R"
  local bg_res = {
    R = "UI/alpha/1080P/skin/skin_get_bg.jpg",
    G = "UI/alpha/1080P/skin/skin_get_bg.jpg",
    B = "UI/alpha/1080P/skin/skin_get_bg.jpg",
    P = "UI/alpha/1080P/skin/skin_get_bg.jpg"
  }
  local readnode = ed.readnode.create(mainLayer, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = bg_res[self.color]
      },
      layout = {
        position = ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2)
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/1080P/skin/skin_get_light.png"
      },
      layout = {
        position = ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 1.5)
      },
      config = {opacity = 0, scale = 6}
    }
  }
  readnode:addNode(ui_info)
  local bg = ui.bg
  ed.layout.lazyAdaptBG(bg)
  local fi = CCFadeIn:create(0.4)
  bg:runAction(fi)
  self.light = ui.light
  self.ui = ui
  ed.announce({
    type = "HeroFashion",
    notshade = true,
    param = {
      id = self.hid,
      fashion_id = self.fashion_id,
      handler = function()
        self:destroy()
        if self.handler then
          self.handler()
        end
      end
    }
  })
  return self
end

class1.create = create

local function show(self)
  lsr:report("createCardLayer")
end

class1.show = show

local function destroy(self)
  lsr:report("closeCardLayer")
  self.mainLayer:removeFromParentAndCleanup(true)
end

class1.destroy = destroy
