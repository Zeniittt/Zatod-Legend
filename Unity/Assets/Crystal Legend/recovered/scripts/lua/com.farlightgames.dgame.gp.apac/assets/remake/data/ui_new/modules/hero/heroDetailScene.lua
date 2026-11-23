local base = ed.ui.commonscene
local heroDetailScene = newclass(base.mt)
ed.ui.heroDetailScene = heroDetailScene
local config = {
  {name = "layer_base", class = "newbase"},
  {
    name = "layer_skill",
    class = "newskill"
  },
  {name = "layer_skin", class = "newskin"},
  {
    name = "layer_shard",
    class = "newShard"
  },
  {
    name = "layer_astrolabe",
    class = "newAstrolabe"
  }
}

function heroDetailScene.showHeroDetailSceneByHeroId(heroId)
  local heroList = {}
  local heroIndex = 1
  local hero = ed.player:getHero(heroId)
  if not hero then
    return
  end
  local allHero = ed.player:getAllHero()
  for _, heroData in pairs(allHero or {}) do
    table.insert(heroList, heroData)
  end
  table.sort(heroList, function(a, b)
    return a.data._tid < b.data._tid
  end)
  for index, heroData in ipairs(heroList) do
    if heroId == heroData.data._tid then
      heroIndex = index
      break
    end
  end
  local scene = ed.ui.heroDetailScene.create({
    hero = ed.player:getHero(heroId),
    index = heroIndex,
    list = heroList,
    openMode = "card",
    isShowUpgradeButton = true
  })
  ed.pushScene(scene)
  return scene
end

function heroDetailScene.create(param)
  local self = base.create("heroDetailScene", {noBottomButton = true})
  setmetatable(self, heroDetailScene.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerOnEnterHandler("HeroDetailOnEnter", function()
    self:refreshUI()
  end)
  self:registerOnExitHandler("exit", function()
    if self.tabIndex == 2 and self.layer_skill then
      self.layer_skill:doLevelUp()
    end
  end)
  return self
end

function heroDetailScene:initData(param)
  self.tabIndex = param.tabIndex or 1
  self.hero = param.hero
  self.herolist = param.list
  self.index = param.index
  self.isOpenLegendEquip = param.isOpenLegendEquip
  self.destroyHandler = param.destroyHandler
  self.hid = self.hero._tid
  self.currentLayer = nil
  self.heroOpenShard = {}
  self.cardLayer = {
    false,
    false,
    false
  }
end

function heroDetailScene:toNextHero()
  if self.index + 1 > #self.herolist then
    self.index = 1
  else
    self.index = self.index + 1
  end
  local heroData = self.herolist[self.index].data
  if config[self.tabIndex].name == "layer_shard" then
    local isShardOpen, _, isShardLock = ed.heroDetailManager.getHeroShardIsOpen(heroData)
    if not isShardOpen and not isShardLock then
      self:toNextHero()
      return
    end
  end
  if config[self.tabIndex].name == "layer_astrolabe" and not ed.heroDetailManager:isShowPageAstrolabe(heroData._tid, true) then
    self:toNextHero()
    return
  end
  self:initHeroData()
  self:refreshUI()
end

function heroDetailScene:initHeroData()
  self.hero = self.herolist[self.index]
  self.hid = self.hero._tid
end

function heroDetailScene:toPreHero()
  if self.index - 1 == 0 then
    self.index = #self.herolist
  else
    self.index = self.index - 1
  end
  local heroData = self.herolist[self.index].data
  if config[self.tabIndex].name == "layer_shard" then
    local isShardOpen, _, isShardLock = ed.heroDetailManager.getHeroShardIsOpen(heroData)
    if not isShardOpen and not isShardLock then
      self:toPreHero()
      return
    end
  end
  if config[self.tabIndex].name == "layer_astrolabe" and not ed.heroDetailManager:isShowPageAstrolabe(heroData._tid, true) then
    self:toPreHero()
    return
  end
  self:initHeroData()
  self:refreshUI()
end

function heroDetailScene:refreshLayer()
  local layerConfig = config[self.tabIndex]
  if not layerConfig then
    return
  end
  if self.cardLayer then
    for i, v in ipairs(self.cardLayer) do
      if v then
        v:setVisible(i == self.tabIndex)
      end
    end
  end
  if self[layerConfig.name] then
    ed.asyncload.unregistLoadingListener()
    self[layerConfig.name].mainLayer:setVisible(true)
    self[layerConfig.name]:refreshData(self.hero)
    self[layerConfig.name]:refreshUI(true)
  else
    self[layerConfig.name] = ed.ui.heroDetailScene[layerConfig.class].create({
      controller = self,
      hero = self.hero,
      pos = ccp(433.75, 239.75)
    })
    self.ui.bg:addChild(self[layerConfig.name].mainLayer)
  end
  self.currentLayer = self[layerConfig.name].mainLayer
  local isOpen, _, isShard = ed.heroDetailManager.getHeroShardIsOpen(self.hero.data)
  self.ui.btn4:setVisible(isOpen or isShard)
end

function heroDetailScene:refreshBtnStone()
  local curHero = self.herolist[self.index]
  if not ed.heroDetailManager:isShowPageAstrolabe(curHero._tid) then
    self.ui.label_btn5:setColor(ccc3(160, 160, 160))
    self.ui.btn5:setVisible(false)
    self.ui.btn3:setPositionX(-78)
    if self.ui.btn4:isVisible() then
      self.ui.btn4:setPositionX(57)
      self.ui.btn5:setPositionX(192)
    else
      self.ui.btn5:setPositionX(57)
    end
  else
    self.ui.btn5:setVisible(true)
    self.ui.label_btn5:setColor(ed.toccc3(16776423))
    ed.resetSpriteShader(self.ui.icon_pet_unseclected)
    ed.resetSpriteShader(self.ui.btn5)
    self.ui.btn5:setPositionX(-78)
    if self.ui.btn4:isVisible() then
      self.ui.btn3:setPositionX(57)
      self.ui.btn4:setPositionX(192)
    else
      self.ui.btn3:setPositionX(57)
    end
    if not self.ui.btn5Red then
      self.ui.btn5Red = ed.createSpriteTools({
        res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
        pos = ccp(120, 28),
        parent = self.ui.btn5,
        notShow = not ed.heroDetailManager:canAstrolabeUnlock(self.hid)
      })
      self:listenEvent("RefreshHeroRed", function()
        self.ui.btn5Red:setVisible(ed.heroDetailManager:canAstrolabeUnlock(self.hid))
      end)
    else
      self.ui.btn5Red:setVisible(ed.heroDetailManager:canAstrolabeUnlock(self.hid))
    end
  end
end

function heroDetailScene:refreshUI()
  self:refreshLayer()
  self:refreshBtnStone()
end

function heroDetailScene:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.bg:setContentSize(CCSizeMake(self.ui.bg:getContentSize().width + fixWidth, self.ui.bg:getContentSize().height))
  self.ui.btn_back:setPositionX(self.ui.btn_back:getPositionX() + fixWidth)
  self.ui.arrow_left:setPositionX(self.ui.arrow_left:getPositionX() - fixWidth / 2 - 10)
  self.ui.arrow_right:setPositionX(self.ui.arrow_right:getPositionX() + fixWidth / 2 + 10)
end

function heroDetailScene:initLabels()
  ed.setLabelStroke(self.ui.label_btn_select1, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select2, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select3, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select4, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select5, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn1, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn2, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn3, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn4, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn5, ccc3(56, 38, 34), 1)
  ed.layout.horizontalSortNode({
    self.ui.icon_hero_unseclected,
    self.ui.label_btn1
  }, {0.5, 0}, self.ui.btn1:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_hero_seclected,
    self.ui.label_btn_select1
  }, {0.5, 0}, self.ui.btn_select1:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_skill_unseclected,
    self.ui.label_btn2
  }, {0.5, 0}, self.ui.btn2:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_skill_seclected,
    self.ui.label_btn_select2
  }, {0.5, 0}, self.ui.btn_select2:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_skin_unseclected,
    self.ui.label_btn3
  }, {0.5, 0}, self.ui.btn3:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_skin_seclected,
    self.ui.label_btn_select3
  }, {0.5, 0}, self.ui.btn_select3:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_shard_unseclected,
    self.ui.label_btn4
  }, {0.5, 0}, self.ui.btn4:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_shard_seclected,
    self.ui.label_btn_select4
  }, {0.5, 0}, self.ui.btn_select4:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_pet_unseclected,
    self.ui.label_btn5
  }, {0.5, 0}, self.ui.btn5:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.icon_pet_seclected,
    self.ui.label_btn_select5
  }, {0.5, 0}, self.ui.btn_select5:getContentSize().width * 0.5)
end

function heroDetailScene:initUI()
  local container = self.mainLayer
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.herodetail)
  self:setBackground("UI/alpha/1080P/bg/herolist_bg.png")
  self:adaptUI()
  self:initLabels()
end

function heroDetailScene:refreshBtnState(index)
  self.ui["btn_select" .. self.tabIndex]:setVisible(false)
  self.tabIndex = index
  self.ui["btn_select" .. self.tabIndex]:setVisible(true)
end

function heroDetailScene:doClickBtn(index)
  if self.tabIndex == index then
    return
  end
  local layerConfig = config[self.tabIndex]
  if layerConfig and self[layerConfig.name] and self[layerConfig.name].hideCallBack then
    self[layerConfig.name]:hideCallBack()
  end
  self:refreshBtnState(index)
  self.currentLayer:setVisible(false)
  self:refreshUI()
end

function heroDetailScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn1", function()
    self:doClickBtn(1)
  end, {})
  ed.UITool.registerBtn(self, "btn2", function()
    self:doClickBtn(2)
  end, {})
  ed.UITool.registerBtn(self, "btn3", function()
    self:doClickBtn(3)
  end, {})
  ed.UITool.registerBtn(self, "btn4", function()
    self:doClickBtn(4)
  end, {})
  ed.UITool.registerBtn(self, "btn5", function()
    local curHero = self.herolist[self.index]
    if not ed.heroDetailManager:isShowPageAstrolabe(curHero._tid) then
      return
    end
    self:doClickBtn(5)
  end, {})
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  ed.UITool.registerBtn(self, "arrow_left", function()
    self:toPreHero()
  end)
  ed.UITool.registerBtn(self, "arrow_right", function()
    self:toNextHero()
  end)
end

function heroDetailScene:destroy()
  ed.asyncload.unregistLoadingListener()
  if self.destroyHandler then
    self.destroyHandler(self.hero._tid)
  end
  if self.layer_skill then
    self.layer_skill:refreshData(self.hero)
  end
  if self.layer_pet then
    self.layer_pet:refreshData(self.hero)
  end
  if self.layer_base then
    self.layer_base:destroy()
  end
  ed.popScene()
end

function heroDetailScene:getCallableHeroIcon()
  for i, v in ipairs(self.uiList) do
    if v.heroCallable then
      return v.bg
    end
  end
end

function heroDetailScene:getGuideNode(nodeKey)
  local layerConfig = config[self.tabIndex]
  local layer = self[layerConfig.name]
  if layer then
    if nodeKey == "wearable_slot" and layer.canWearSlot and layer.canWearSlot[1] then
      return layer.ui["equip" .. layer.canWearSlot[1]]
    end
    return base.getGuideNode(self, nodeKey) or layer.ui[nodeKey] or layer[nodeKey]
  end
  return base.getGuideNode(self, nodeKey)
end
