local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloShopWindow = class

function class:refreshData()
  self.shopCardList = ed.SoloModel.shopCardList or {}
  self.refreshCost = ed.SoloModel.refreshCost or 20
  self.randomCost = ed.SoloModel.randomCost or 100
end

function class:initLabels()
  ed.setLabelFontName(self.ui.label_refresh, ed.fontBold)
  ed.setLabelStroke(self.ui.label_refresh, ed.toccc3(9067289), 1.5)
  ed.setLabelFontName(self.ui.label_random, ed.fontBold)
  ed.setLabelStroke(self.ui.label_random, ed.toccc3(9067289), 1.5)
  ed.setLabelStroke(self.ui.label_cost_random, ed.toccc3(8211204), 1.5)
  ed.setLabelStroke(self.ui.label_cost_refresh, ed.toccc3(8211204), 1.5)
end

function class:createCardPanel(shopCard, index)
  local tag = ed.getDataTable("SoloCardSkill")[shopCard._cid].Tag1
  local faction = ed.SoloModel.factions[tag]
  local level = faction:getCardLevel(shopCard._cid) or 0
  local container, ui = ed.ui.SoloUITool.createCardItem(shopCard._cid, level, true, shopCard._price)
  self:btRemoveMainTouchHandler({
    key = "card_" .. index
  })
  self:btRegisterButtonClick({
    button = ui.bg,
    key = "card_" .. index,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.solo_buycard)
      self:handlerCardIconClick(index)
    end,
    force = true,
    pressScale = 0.99,
    clickInterval = 0.5
  })
  local rank = ed.getDataTable("SoloCardSkill")[shopCard._cid].Quality
  local fca = ed.createSpine("effect/eff_UI_solo_card_rank" .. rank .. "/eff_UI_solo_card_rank" .. rank, 0.5)
  local fca1 = ed.createSpine("effect/eff_UI_solo_card_rank" .. rank .. "/eff_UI_solo_card_rank" .. rank, 0.5)
  if rank == 3 then
    local goldStar = ed.createSpine("effect/eff_UI_solo_card_rank3_star/eff_UI_solo_card_rank3_star", 0.5)
    ui.bg:addChild(goldStar, 2)
    ed.layout.centerInParent(goldStar)
    goldStar:setAnimation(0, "Loop", true)
  end
  ui.bg:addChild(fca, 2)
  ed.layout.centerInParent(fca)
  ui.bg:addChild(fca1, -1)
  ed.layout.centerInParent(fca1)
  fca:setAnimation(0, "Start", false)
  fca1:setAnimation(0, "Loop", true)
  return container, ui
end

function class:updateShopPanel()
  local totalGold = ed.SoloModel:getTotalGold() or 0
  for k, v in ipairs(self.cardItemList or {}) do
    v.container:removeFromParentAndCleanup(true)
  end
  self.cardItemList = {}
  for k = 1, 3 do
    local v = self.shopCardList[k]
    if v then
      local container, ui = self:createCardPanel(v, k)
      container:setPosition(ccp(0 + (k - 2) * 205, 0))
      table.insert(self.cardItemList, {
        container = container,
        ui = ui,
        data = v
      })
      ui.bg:setScaleX(0.1)
      ui.name:setVisible(false)
      ui.label_desc:setVisible(false)
      local callFunc = CCCallFunc:create(function()
        ui.name:setVisible(true)
        ui.label_desc:setVisible(true)
      end)
      local action = CCSequence:createWithTwoActions(CCScaleTo:create(0.15, 1), callFunc)
      ui.bg:runAction(action)
      self.ui.bg:addChild(container)
    end
  end
  ed.setString(self.ui.label_cost_refresh, self.refreshCost)
  if totalGold < self.refreshCost then
    self.ui.label_cost_refresh:setColor(ccc3(255, 0, 0))
  else
    self.ui.label_cost_refresh:setColor(ed.toccc3(16776423))
  end
  ed.setString(self.ui.label_cost_random, self.randomCost)
  if totalGold < self.randomCost then
    self.ui.label_cost_random:setColor(ccc3(255, 0, 0))
  else
    self.ui.label_cost_random:setColor(ed.toccc3(16776423))
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloShopWindow, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
end

function class:doClickRefresh()
  local gold = ed.SoloModel:getTotalGold()
  if gold < self.refreshCost then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
  else
    self.actionDone = true
    ed.SoloNetwork:sendChessShopRefresh()
  end
end

function class:doClickRandom()
  local gold = ed.SoloModel:getTotalGold()
  if gold < self.randomCost then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
  else
    self.actionDone = true
    ed.SoloNetwork:sendChessRandomBuy()
  end
end

function class:handlerCardIconClick(index)
  local shopCard = self.shopCardList[index]
  if not shopCard then
    return
  end
  local price = shopCard._price
  local totalGold = ed.SoloModel:getTotalGold()
  if price <= totalGold then
    local quality = ed.getDataTable("SoloCardSkill")[shopCard._cid].Quality
    local blendFunc = ccBlendFunc()
    blendFunc.src = GL_ONE
    blendFunc.dst = GL_ONE
    local sprite3 = ed.createSprite(string.format("UI/alpha/1080P/chesscard/skill/to_jpg_x_alpha/bg_%d.png", quality))
    sprite3:setScale(1.2)
    local ui = self.cardItemList[index].ui
    ui.bg:addChild(sprite3)
    ed.layout.centerInParent(sprite3)
    sprite3:setBlendFunc(blendFunc)
    local sprite2 = ed.createSprite(string.format("UI/alpha/1080P/chesscard/skill/to_jpg_x_alpha/bg_%d.png", quality))
    ui.bg:addChild(sprite2)
    ed.layout.centerInParent(sprite2)
    sprite2:setBlendFunc(blendFunc)
    sprite3:setScale(1.2)
    self.actionDone = false
    local callFunc = CCCallFunc:create(function()
      ed.SoloNetwork:sendBuyCard(index)
      if self.waitToRefresh then
        self:updateShopPanel()
        self.waitToRefresh = false
      end
      self.actionDone = true
    end)
    sprite2:runAction(CCSequence:createWithTwoActions(CCEaseOut:create(CCFadeOut:create(0.4), 1), callFunc))
    local action1 = CCEaseOut:create(CCFadeOut:create(0.3), 2)
    local action2 = CCEaseOut:create(CCScaleTo:create(0.3, 1.3), 2)
    local seqAction = CCSpawn:create(ccArrayMake(action1, action2))
    sprite3:runAction(seqAction)
  else
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
  end
end

function class:registerBtnEvents()
  ed.UITool.registerBtn(self, "btn_refresh", function()
    self:doClickRefresh()
  end, {pressScale = 0.95, clickInterval = 0.5})
  self:btRegisterButtonClick({
    button = self.ui.btn_random,
    key = "btn_random",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.solo_buycard)
      self:doClickRandom()
    end,
    force = true,
    pressScale = 0.95,
    clickInterval = 0.5
  })
end

function class:refresh()
  self:refreshData()
  self:updateShopPanel()
end

function class:registerNetEvents()
  self:listenEvent("SkillShopDataRefresh", function()
    self:refreshData()
    self:updateShopPanel()
  end)
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:listenEvent("EffectGainCard", function(card)
    for k, v in ipairs(self.cardItemList) do
      if v.data._cid == card._cid then
        local container, ui = self:createCardPanel(self.shopCardList[k], k)
        container:setPosition(ccp(0 + (k - 2) * 205, 0))
        v.container:removeFromParentAndCleanup(true)
        v.container = container
        v.ui = ui
        v.data = card
        self.ui.bg:addChild(container)
      end
    end
  end)
end

function class:registerEvents()
  self:registerBtnEvents()
  self:registerNetEvents()
end

function class.create(params)
  local self = base.create("SoloShopWindow", {
    notBlurBg = true,
    noShade = true,
    swallow = false
  })
  setmetatable(self, class.mt)
  self.destroyCallback = params.destroyHandler
  self:initUI()
  self:refresh()
  self:registerEvents()
  return self
end
