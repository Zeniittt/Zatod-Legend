local base = ed.ui.popwindow
local heroCardWindow = newclass(base.mt)
ed.ui.popherocard = heroCardWindow
local lsr = ed.ui.popherocardlsr.create()
local bg_res = {
  R = "UI/alpha/1080P/summon/tavern_get_hero_bg_golden.jpg",
  G = "UI/alpha/1080P/summon/tavern_get_hero_bg_green.jpg",
  B = "UI/alpha/1080P/summon/tavern_get_hero_bg_blue.jpg",
  P = "UI/alpha/1080P/summon/tavern_get_hero_bg_purple.jpg"
}

function heroCardWindow.create(param)
  param = param or {}
  param.noShade = true
  local self = base.create("heroCardWindow", param)
  setmetatable(self, heroCardWindow.mt)
  self.baseScene = ed.getCurrentScene()
  self.hid = param.id
  self.star = param.star or ed.getDataTable("Unit")[self.hid]["Initial Stars"]
  self.amount = param.amount or 0
  self.handler = param.handler
  self.index = param.index
  self.priority = param.priority
  local mainLayer = self.mainLayer
  local ui = self.ui
  local colorMap = {
    R = "red",
    G = "green",
    B = "blue",
    P = "red"
  }
  local color = ed.getDataTable("Unit")[self.hid]["Bg Color"] or "R"
  local hero = ed.player:getHero(self.hid)
  local readnode = ed.readnode.create(mainLayer, ui)
  local card_ui = ed.readhero.getHeroCard(self.hid, {
    starType = "init",
    stars = self.star,
    disableswap = true
  })
  ui.card_fashion_effect = card_ui.card_fashion_effect
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = bg_res[color]
      },
      layout = {
        position = ed.display.center
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/1080P/common/shine.png"
      },
      layout = {
        position = ccp(ed.display.center.x, ed.display.winSize.height + 60)
      },
      config = {opacity = 0, scale = 6}
    },
    {
      t = "CCNode",
      base = {
        name = "cardui",
        node = card_ui.container,
        z = 1
      },
      layout = {
        position = ed.display.center
      },
      config = {opacity = 0}
    },
    {
      t = "Sprite",
      base = {
        name = "skip_btn",
        res = "UI/alpha/1080P/summon/skip_btn.png"
      },
      layout = {
        position = ccp(960, 540)
      },
      config = {opacity = 0}
    },
    {
      config = {
        rotation = 0,
        scalexy = {y = 1, x = 1},
        horizontalAlignment = 0,
        flip = "",
        color = ccc3(254, 222, 184),
        opacity = 255,
        verticalAlignment = 0,
        visible = true
      },
      t = "Label",
      base = {
        name = "label_skip",
        z = 0,
        parent = "skip_btn",
        text = T("\232\183\179\232\191\135"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(34, 21.5)
      }
    }
  }
  readnode:addNode(ui_info)
  ed.setLabelStroke(ui.label_skip, ed.toccc3(3483679), 1)
  local bg = ui.bg
  local fi = CCFadeIn:create(0.4)
  bg:runAction(fi)
  ed.layout.lazyAdaptBG(bg)
  local light = ui.light
  fi = CCFadeIn:create(0.4)
  local s = CCSequence:createWithTwoActions(fi, CCCallFunc:create(function()
    xpcall(function()
      local r = CCRotateBy:create(5, 360)
      r = CCRepeatForever:create(r)
      light:runAction(r)
    end, EDDebug)
  end))
  light:runAction(s)
  local cardui = ui.cardui
  if self.fashion_id then
    for fashion_id, effect_fca in pairs(ui.card_fashion_effect or {}) do
      effect_fca:setVisible(false)
    end
    if ui.card_fashion_spine then
      ui.card_fashion_spine:setVisible(false)
    end
  end
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      cardui:setVisible(true)
      cardui:runAction(fi)
      local fb = ed.createFcaNode("eff_UI_tavern_bubble")
      fb:setPosition(ed.display.center)
      mainLayer:addChild(fb)
      self.baseScene:addFca(fb)
      fb:setScale(1.5)
      if self.fashion_id then
        for fashion_id, effect_fca in pairs(ui.card_fashion_effect or {}) do
          effect_fca:setVisible(true)
          self.baseScene:addFca(effect_fca)
        end
        if ui.card_fashion_spine then
          ui.card_fashion_spine:setVisible(true)
        end
      end
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  cardui:runAction(s)
  lsr:report("showCardAnim")
  local fn = ed.createFcaNode("eff_UI_tavern_card_" .. colorMap[color])
  fn:setPosition(ed.display.center)
  mainLayer:addChild(fn, 10)
  self.baseScene:addFca(fn)
  fn:setScale(1.5)
  self:registerTouchHandler()
  self:show()
  return self
end

function heroCardWindow:showStonePrompt()
  lsr:report("createStonePrompt")
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  self.mainLayer:addChild(container)
  local label = ed.createttf(T("\229\183\178\230\139\165\230\156\137\230\173\164\232\139\177\233\155\132,%d\230\152\159\229\141\161\231\137\140\232\189\172\229\140\150\228\184\186\231\129\181\233\173\130\231\159\179%d\228\184\170", self.star, self.amount), 20)
  if self.star >= 6 then
    label = ed.createttf(T("\229\183\178\230\139\165\230\156\137\230\173\164\232\139\177\233\155\132,\231\178\137%d\230\152\159\229\141\161\231\137\140\232\189\172\229\140\150\228\184\186\231\129\181\233\173\130\231\159\179%d\228\184\170", self.star - 5, self.amount), 20)
  end
  label:setPosition(ccp(ed.display.center.x, 64))
  self.mainLayer:addChild(label)
  ed.setLabelColor(label, ccc3(255, 255, 255))
  ed.setLabelStroke(label, ccc3(0, 0, 0), 2)
  label = ed.createttf(T("\231\129\181\233\173\130\231\159\179\229\143\175\231\148\168\228\186\142\232\139\177\233\155\132\232\191\155\229\140\150"), 20)
  label:setPosition(ccp(ed.display.center.x, 40))
  self.mainLayer:addChild(label)
  ed.setLabelColor(label, ccc3(255, 255, 255))
  ed.setLabelStroke(label, ccc3(0, 0, 0), 2)
  container:setOpacity(0)
  local f = CCFadeIn:create(0.4)
  container:runAction(f)
end

function heroCardWindow:doClickLayer()
  if self.hasShowStone then
    if self.handler then
      self.handler()
    end
    self:destroy()
    return
  end
  if self.amount > 1 then
    lsr:report("createStonePrompt")
    self.hasShowStone = true
    local container = self.ui.cardui
    local s = CCScaleTo:create(0.2, 0.8)
    s = CCEaseSineOut:create(s)
    local m = CCMoveTo:create(0.2, ed.display.center)
    m = CCEaseSineOut:create(m)
    s = CCSpawn:createWithTwoActions(s, m)
    container:runAction(s)
    self:showStonePrompt()
  else
    lsr:report("createGetNewHero")
    if not tolua.isnull(self.ui.cardui) then
      self.ui.cardui:removeFromParentAndCleanup(true)
    end
    local light = self.ui.light
    if not tolua.isnull(light) then
      light:removeFromParentAndCleanup(true)
    end
    ed.announce({
      type = "getNewHero",
      notshade = true,
      priority = self.priority and self.priority - 5 or nil,
      param = {
        id = self.hid,
        handler = function()
          if self.handler then
            self.handler()
          end
          self:destroy()
        end
      }
    })
  end
end

function heroCardWindow:registerTouchHandler()
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterClick({
    key = "click_layer",
    clickHandler = function(param)
      lsr:report("clickCardLayer")
      self:doClickLayer()
    end
  })
end

function heroCardWindow:show()
  lsr:report("createCardLayer")
end

function heroCardWindow:destroy()
  lsr:report("closeCardLayer")
  self.mainLayer:removeFromParentAndCleanup(true)
end
