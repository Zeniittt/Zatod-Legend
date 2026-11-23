module("ed.herorecommend", package.seeall)
mainpanel = {}
mainpanel.__index = mainpanel
local base = ed.ui.basescene
setmetatable(mainpanel, base.mt)

function mainpanel.create(data)
  local object = base.create("heropackage_recommend")
  setmetatable(object, mainpanel)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function mainpanel:destroy()
  ed.popScene()
end

function mainpanel:initData(data)
  self.mgr = mainpanelMgr.create(data)
  self.hotHeroHeadList = {}
end

function mainpanel:initAppearence()
  self.window = ed.createui("herorecommend_mainpanel", {
    mainLayer = self.mainLayer,
    touch_node = self
  })
  ed.setLabelShadow(self.window.ui.lab_title, ccc3(0, 0, 0), ccp(0, 2))
  self:initHotPanel()
  self:initClassifyPanel()
  self.currentTab = "hot"
  self:refreshTabUI()
  self:refreshContainerUI()
end

function mainpanel:initHotPanel()
  self:createDraglist()
  self:createHotTop3List()
  self:createBoundary()
  self:createHotHeroList()
  local listHeight = 270 + 95 * math.ceil(#self.mgr.hotHeroes / 6)
  self.hotDraglist:initListHeight(listHeight)
end

function mainpanel:createHotTop3List()
  local hotHeroTop3 = self.mgr.hotHeroTop3
  for i, hotHero in ipairs(hotHeroTop3) do
    local container = self:createHotHeroTop3(hotHero)
    container:setPosition(ccp(180 + (i - 1) * 170, 250))
    self.hotDraglist.listLayer:addChild(container)
  end
end

local herobgRes = {
  "UI/alpha/HVGA/hero_recommend/hero_recommend_pattern1.png",
  "UI/alpha/HVGA/hero_recommend/hero_recommend_pattern2.png",
  "UI/alpha/HVGA/hero_recommend/hero_recommend_pattern3.png"
}
local rankRes = {
  "UI/alpha/1080P/common/pvp_rank_1st.png",
  "UI/alpha/1080P/common/pvp_rank_2nd.png",
  "UI/alpha/1080P/common/pvp_rank_3rd.png"
}

function mainpanel:createHotHeroTop3(hotHero)
  local container, ui = ed.editorui(ed.uieditor.herorecommend_tophero)
  local herobgRes = herobgRes[hotHero.rank]
  local rankRes = rankRes[hotHero.rank]
  local attres = ed.ui.herodetail.getHeroTypeRes(hotHero.heroid)
  ed.setTexture(ui.img_bg, herobgRes)
  ed.setTexture(ui.img_rank, rankRes)
  ed.setTexture(ui.img_att, attres)
  local hot = hotHero.hot
  ed.setString(ui.img_hot_number, hot)
  ed.setLabelShadow(ui.img_hot_number, ccc3(0, 0, 0), ccp(0, 2))
  local heroname = ed.lookupDataTable("Unit", "Display Name", hotHero.heroid or 1)
  ed.setString(ui.lab_name, heroname)
  local fca = manager:createFcaActor(hotHero.heroid)
  ui.panel_fcabg:addChild(fca)
  self:addFca(fca)
  if hotHero.newhero then
    ui.img_hot_bg:setVisible(false)
    ui.img_hot:setVisible(false)
    ui.img_hot_number:setVisible(false)
    ui.img_hot_label:setVisible(false)
    ui.img_newhero:setVisible(true)
  end
  self:btRegisterButtonClick({
    button = ui.img_bg,
    key = "click_hot_hero" .. hotHero.rank,
    clickHandler = function()
      self:openHotHero(hotHero.heroid)
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  return container
end

function mainpanel:createBoundary()
  local boundarySprite = ed.createSprite("UI/alpha/HVGA/herodetail_delimiter.png")
  boundarySprite:setPosition(ccp(350, 125))
  boundarySprite:setScaleX(1.5)
  self.hotDraglist.listLayer:addChild(boundarySprite)
end

function mainpanel:createHotHeroList()
  local hotHeroes = self.mgr.hotHeroes
  for i, hotHero in ipairs(hotHeroes) do
    local head = self:createHotHeroHead(hotHero)
    local headNode = head.node
    self.hotDraglist.listLayer:addChild(headNode)
    local posx = 105 + (i - 1) % 6 * 85
    local posy = 45 - math.floor((i - 1) / 6) * 95
    headNode:setPosition(ccp(posx, posy))
    self.hotHeroHeadList[i] = head
  end
end

function mainpanel:createHotHeroHead(hotHero)
  local node = CCNode:create()
  local fireSprite = ed.createSprite("UI/alpha/HVGA/hero_recommend/hero_recommend_icon_fire2.png")
  local hotLabel = ed.createLabelWithFontInfo(tostring(hotHero.hot), "herorecommend_orange")
  hotLabel:setPosition(ccp(30, 0))
  local head = manager:createRankHead(hotHero.heroid, hotHero.rank)
  head.node:setPosition(ccp(19, 42))
  node:addChild(fireSprite)
  node:addChild(hotLabel)
  node:addChild(head.node)
  return {
    node = node,
    headicon = head.headicon
  }
end

function mainpanel:initClassifyPanel()
  self.classifyPanel = classify.create({
    window = self.window,
    mgr = self.mgr
  })
  self.window.ui.panel_classify = self.classifyPanel.mainLayer
  self.classifyDraglist = self.classifyPanel.draglist
end

function mainpanel:createDraglist()
  local info = {
    cliprect = CCRectMake(85, 30, 503, 360),
    container = self.window.ui.panel_hot,
    upShade = "UI/alpha/HVGA/hero_recommend/hero_recommend_cover.png",
    downShade = "UI/alpha/HVGA/hero_recommend/hero_recommend_cover.png",
    zorder = 10,
    doClickIn = self:getClickInHandler(),
    doPressIn = self:getPressInHandler()
  }
  self.hotDraglist = ed.draglist.create(info)
end

function mainpanel:getClickInHandler()
  local function handler(x, y, index)
    local head = self.hotHeroHeadList[index]
    
    if ed.containsPoint(head.headicon, x, y) then
      local hotHero = self.mgr.hotHeroes[index]
      self:openHotHero(hotHero.heroid)
    end
  end
  
  return handler
end

function mainpanel:getPressInHandler()
  local function handler(x, y)
    for index, head in ipairs(self.hotHeroHeadList) do
      if ed.containsPoint(head.headicon, x, y) then
        return index
      end
    end
  end
  
  return handler
end

function mainpanel:registerTouchHandler()
  self.window:registerBtn("btn_close", function()
    self:destroy()
  end)
  self.window:registerBtn("btn_hot_rule", function()
    self:openHotRulePanel()
  end)
  self.window:registerScaleBtn("btn_hot", 1, function()
    self:shiftTab("hot")
  end)
  self.window:registerScaleBtn("btn_hot_press", 1, function()
    self:shiftTab("hot")
  end)
  self.window:registerScaleBtn("btn_classify", 1, function()
    self:shiftTab("classify")
  end)
  self.window:registerScaleBtn("btn_classify_press", 1, function()
    self:shiftTab("classify")
  end)
end

function mainpanel:openHotRulePanel()
  local rulewindow = hotRuleWindow.create()
  rulewindow:popWindow()
end

function mainpanel:shiftTab(tab)
  self.currentTab = tab
  self:refreshTabUI()
  self:refreshContainerUI()
end

local tabkey = {"hot", "classify"}

function mainpanel:refreshTabUI()
  for _, key in pairs(tabkey) do
    if key == self.currentTab then
      self.window.ui["btn_" .. key]:setVisible(true)
      self.window.ui["btn_" .. key .. "_press"]:setVisible(false)
    else
      self.window.ui["btn_" .. key]:setVisible(false)
      self.window.ui["btn_" .. key .. "_press"]:setVisible(true)
    end
  end
end

function mainpanel:refreshContainerUI()
  for _, key in pairs(tabkey) do
    if key == self.currentTab then
      self.window.ui["panel_" .. key]:setVisible(true)
      self[key .. "Draglist"].listLayer:setVisible(true)
    else
      self.window.ui["panel_" .. key]:setVisible(false)
      self[key .. "Draglist"].listLayer:setVisible(false)
    end
  end
end

function mainpanel:openHotHero(heroid)
  network:sendViewHotHero(heroid)
end
