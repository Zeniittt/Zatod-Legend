local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.KingsLoadingWindow = class
ed.UITool.registViewOpenFunc("KingsLoadingWindow", function(param)
  local window = ed.ui.KingsLoadingWindow.create(param)
  ed.pushScene(window)
end)

function class.create(param)
  local self = base.create("KingsLoadingWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class.close(param)
end

function class:init(param)
  param = param or {}
  self.hostServerName = param.hostServerName or ""
  self.guestServerName = param.guestServerName or ""
  self.hostUserSummary = param.hostUserSummary or {}
  self.guestUserSummary = param.guestUserSummary or {}
  self.hostHeroList = param.hostHeroList or {}
  self.guestHeroList = param.guestHeroList or {}
  self.loadHeroFinishCallBack = param.loadHeroFinishCallBack
  self.loadHeroMinTime = 5
  self.loadHeroTimeOut = 15
  self:initView()
  self:adaptUI()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingLoadingWindow)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initPlayerInfo()
  self:initHeroList()
  self:showOpenAction()
  self:initEffect()
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.kings_pvp_loading)
end

function class:adaptUI()
end

function class:initEffect()
  local particle = ed.createFcaActor("eff_UI_fancytower_particle_main")
  particle:setAction("Loop")
  particle:setLoop(true)
  self:addFca(particle)
  self.mainLayer:addChild(particle)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_guild_tips_blue, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_server_tips_blue, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.guild_name_blue, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.server_name_blue, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_guild_tips_red, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_server_tips_red, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.guild_name_red, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.server_name_red, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_guild_tips_blue_action, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_server_tips_blue_action, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_guild_tips_red_action, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_server_tips_red_action, ed.toccc3(0), 1)
end

function class:showOpenAction()
  self:showHeroCardAction()
end

function class:showHeroCardAction()
  self.ui.panel_hero_red:setVisible(true)
  self.ui.panel_hero_blue:setVisible(true)
  self.ui.player_info_bg_blue:setVisible(false)
  self.ui.player_info_bg_red:setVisible(false)
  self.ui.image_vs:setVisible(false)
  local centerIndex = (#self.hostHeroCard + 1) / 2
  for index, card in ipairs(self.hostHeroCard) do
    card:setOpacity(0)
    card:setPositionY(card:getPositionY() + 100)
    local delay = CCDelayTime:create(math.abs(index - centerIndex) * 0.1)
    local moveAction = CCEaseSineOut:create(CCMoveBy:create(0.5, ccp(0, -100)))
    local fadeAction = CCFadeTo:create(0.3, 255)
    local action = CCSequence:create(ccArrayMake(delay, CCSpawn:create(ccArrayMake(moveAction, fadeAction))))
    card:runAction(action)
  end
  local centerIndex = (#self.guestHeroCard + 1) / 2
  for index, card in ipairs(self.guestHeroCard) do
    card:setOpacity(0)
    card:setPositionY(card:getPositionY() - 100)
    local delay = CCDelayTime:create(math.abs(index - centerIndex) * 0.2)
    local moveAction = CCEaseSineOut:create(CCMoveBy:create(0.5, ccp(0, 100)))
    local fadeAction = CCFadeTo:create(0.3, 255)
    local action = CCSequence:create(ccArrayMake(delay, CCSpawn:create(ccArrayMake(moveAction, fadeAction))))
    card:runAction(action)
  end
  local totalDelayTime = 0.8
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCCallFunc:create(function()
    self:showPlayerInfoAction()
  end))))
end

function class:showPlayerInfoAction()
  self.ui.player_info_bg_blue:setVisible(true)
  self.ui.player_info_bg_red:setVisible(true)
  self.ui.player_info_bg_blue:setCascadeOpacityEnabled(true)
  self.ui.player_info_bg_red:setCascadeOpacityEnabled(true)
  self.ui.player_info_bg_blue:setOpacity(0)
  self.ui.player_info_bg_blue:setPositionX(self.ui.player_info_bg_blue:getPositionX() - 300)
  local moveActionBlue = CCEaseIn:create(CCMoveBy:create(0.3, ccp(300, 0)), 5)
  local fadeActionBlue = CCFadeTo:create(0.3, 255)
  self.ui.player_info_bg_blue:runAction(CCSpawn:create(ccArrayMake(moveActionBlue, fadeActionBlue)))
  self.blueHeadNode:setOpacity(0)
  self.blueHeadNode:runAction(CCFadeTo:create(0.3, 255))
  self.blueNameAutoText.node:setOpacity(0)
  self.blueNameAutoText.node:runAction(CCFadeTo:create(0.3, 255))
  self.ui.player_info_bg_red:setOpacity(0)
  self.ui.player_info_bg_red:setPositionX(self.ui.player_info_bg_red:getPositionX() + 300)
  local moveActionRed = CCEaseIn:create(CCMoveBy:create(0.3, ccp(-300, 0)), 5)
  local fadeActionRed = CCFadeTo:create(0.3, 255)
  self.ui.player_info_bg_red:runAction(CCSpawn:create(ccArrayMake(moveActionRed, fadeActionRed)))
  self.redHeadNode:setOpacity(0)
  self.redHeadNode:runAction(CCFadeTo:create(0.3, 255))
  self.redNameAutoText.node:setOpacity(0)
  self.redNameAutoText.node:runAction(CCFadeTo:create(0.3, 255))
  self.ui.image_vs:setScale(1)
  local delayTime = CCDelayTime:create(0.3)
  local callFunc = CCCallFunc:create(function()
    self.ui.image_vs:setVisible(true)
  end)
  local scaleAction = CCEaseBackOut:create(CCScaleTo:create(0.15, 0.4))
  self.ui.image_vs:runAction(CCSequence:create(ccArrayMake(delayTime, callFunc, scaleAction)))
end

function class:initPlayerInfo()
  local blueName, blueNameWidth, blueNameAutoText = ed.getPlayerName(self.hostUserSummary._name or "", self.hostUserSummary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  self.blueNameAutoText = blueNameAutoText
  self.ui.player_name_bg_blue:addChild(blueName)
  blueName:setPosition(ccp(60, self.ui.player_name_bg_blue:getContentSize().height / 2))
  local blueHead, blueHeadNode = ed.getWholeHeadIcon({
    id = self.hostUserSummary._avatar or 1
  })
  blueHead:setScale(0.8)
  blueHeadNode:setCascadeOpacityEnabled(true)
  self.blueHeadNode = blueHeadNode
  self.ui.panel_head_blue:addChild(blueHead)
  ed.layout.centerInParent(blueHead)
  local hostGuildName = self.hostUserSummary._guild_name
  if not hostGuildName or hostGuildName == "" then
    hostGuildName = T("\230\151\160")
  end
  ed.setLabelString(self.ui.guild_name_blue, hostGuildName)
  ed.setLabelString(self.ui.server_name_blue, self.hostServerName)
  local redName, redNameWidth, redNameAutoText = ed.getPlayerName(self.guestUserSummary._name or "", self.guestUserSummary._medal, {
    anchorPoint = ccp(1, 0.5),
    medalRight = true
  })
  self.redNameAutoText = redNameAutoText
  self.ui.panel_name_bg_red:addChild(redName)
  redName:setPosition(ccp(self.ui.panel_name_bg_red:getContentSize().width - 60, self.ui.panel_name_bg_red:getContentSize().height / 2))
  local redHead, redHeadNode = ed.getWholeHeadIcon({
    id = self.guestUserSummary._avatar or 1
  })
  redHead:setScale(0.8)
  redHeadNode:setCascadeOpacityEnabled(true)
  self.redHeadNode = redHeadNode
  self.ui.panel_head_red:addChild(redHead)
  ed.layout.centerInParent(redHead)
  local guestGuildName = self.guestUserSummary._guild_name
  if not guestGuildName or guestGuildName == "" then
    guestGuildName = T("\230\151\160")
  end
  ed.setLabelString(self.ui.guild_name_red, guestGuildName)
  ed.setLabelString(self.ui.server_name_red, self.guestServerName)
  ed.left2(self.ui.label_guild_tips_red, self.ui.guild_name_red, 10)
  ed.left2(self.ui.label_server_tips_red, self.ui.server_name_red, 10)
end

function class:initHeroList()
  local hostHeroList = self.hostHeroList
  local cardSize = CCSizeMake(242, 480)
  local posX = 0
  local gapX = 30
  local scale = 0.46
  local panelSize = self.ui.panel_hero_blue:getContentSize()
  posX = panelSize.width - #hostHeroList * cardSize.width * scale - (#hostHeroList - 1) * gapX
  posX = posX / 2
  self.hostHeroCard = {}
  for index, hero in ipairs(hostHeroList) do
    local card = ed.readhero.getHeroCardByHero(hero, {hide_star = true, starType = "init"})
    card.container:setScale(0.46)
    self.ui.panel_hero_blue:addChild(card.container)
    table.insert(self.hostHeroCard, card.container)
    card.container:setPosition(ccp(posX + cardSize.width / 2 * scale, panelSize.height / 2 - 5))
    posX = posX + cardSize.width * scale + gapX
    for fashion_id, effect_fca in pairs(card.card_fashion_effect or {}) do
      self:addFca(effect_fca)
    end
    for fashion_id, plist in pairs(card.fashion_plist_res or {}) do
      self:addFca(plist)
    end
  end
  local guestHeroList = self.guestHeroList
  local panelSize = self.ui.panel_hero_red:getContentSize()
  posX = panelSize.width - #guestHeroList * cardSize.width * scale - (#guestHeroList - 1) * gapX
  posX = posX / 2
  self.guestHeroCard = {}
  for index, hero in ipairs(guestHeroList) do
    local card = ed.readhero.getHeroCardByHero(hero, {hide_star = true, starType = "init"})
    card.container:setScale(0.46)
    self.ui.panel_hero_red:addChild(card.container)
    table.insert(self.guestHeroCard, card.container)
    card.container:setPosition(ccp(posX + cardSize.width / 2 * scale, panelSize.height / 2 - 5))
    posX = posX + cardSize.width * scale + gapX
    for fashion_id, effect_fca in pairs(card.card_fashion_effect or {}) do
      self:addFca(effect_fca)
    end
    for fashion_id, plist in pairs(card.fashion_plist_res or {}) do
      self:addFca(plist)
    end
  end
  for index, hero in ipairs(hostHeroList) do
    ed.asyncload.preloadFcaByUnitID(hero._tid)
  end
  for index, hero in ipairs(guestHeroList) do
    ed.asyncload.preloadFcaByUnitID(hero._tid)
  end
  ed.asyncload.registLoadingListener(function()
    self.loadHeroFinish = true
  end)
  self:listenTimer(Timer:Always(1, "loadHero"), function()
    self:checkLoadHero()
  end)
end

function class:checkLoadHero()
  self.loadHeroMinTime = self.loadHeroMinTime - 1
  self.loadHeroTimeOut = self.loadHeroTimeOut - 1
  if self.loadHeroMinTime <= 0 and self.loadHeroFinish then
    self:loadHeroEnd()
  end
  if self.loadHeroTimeOut <= 0 then
    self:loadHeroEnd()
  end
end

function class:loadHeroEnd()
  CloseTimer("loadHero")
  if self.loadHeroFinishCallBack then
    self.loadHeroFinishCallBack()
  end
end

function class:addTouchEvent()
end

function class:addEventListener()
  self:listenEvent("RealPVPOpponentLost", function()
    ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\230\150\173\229\188\128\232\191\158\230\142\165\239\188\140\228\189\160\232\142\183\229\190\151\228\186\134\232\131\156\229\136\169\239\188\129"))
    self:listenTimer(Timer:Once(2), function()
      ed.popScene()
    end)
  end)
end
