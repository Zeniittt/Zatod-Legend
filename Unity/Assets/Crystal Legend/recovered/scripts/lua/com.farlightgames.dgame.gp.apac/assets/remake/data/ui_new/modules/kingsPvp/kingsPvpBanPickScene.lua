local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.KingsPvpBanPickScene = class
ed.UITool.registViewOpenFunc("KingsPvpBanPickScene", function(param)
  local scene = ed.ui.KingsPvpBanPickScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("KingsPvpBanPickScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(info)
  info = info or {}
  self.pvpMode = info.pvpMode
  self.operate_time = info.select_time or 0
  self.select_count_limit = info.select_count_limit
  self.turn = info.turn
  self.isHost = info.isHost == 1
  self.operateType = info.operateType
  self.backupTime = info.backupTime or 0
  self.usedHeroes = info.usedHeroes or {}
  self.hostWinCnt = info.hostWinCnt or 0
  self.guestWinCnt = info.guestWinCnt or 0
  self.bpRound = 1
  self.isAudience = nil
  self.banHeroAmount, self.pickHeroAmount = self:getBanPickAmount()
  self.hostPickList = {}
  self.hostBanList = {}
  self.guestPickList = {}
  self.guestBanList = {}
  self.selectFilterType = "all"
  self.filterBtnTypeList = {
    "all",
    "front",
    "middle",
    "back",
    "str",
    "agi",
    "int"
  }
  self.selectHeroIdList = {}
  self.heroPool = {}
  self.showElement = false
  local actData = ed.activityHints.data:getRealArenaAthleticsActInfo()
  self.isOpenAthleticsAct = actData and true or false
  self.online_all, self.online_front, self.online_middle, self.online_back, self.online_str, self.online_agi, self.online_int = ed.realarena.hero_mgr:getOnlineHero()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsBanPickScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.uiContainer = container
  local curBlueEff = ed.createFcaNode("eff_UI_kingspvp_selecting_light")
  self.curBlueEff = curBlueEff
  self:addFca(curBlueEff)
  curBlueEff:update(0)
  self.ui.player_info_blue:addChild(curBlueEff)
  curBlueEff:setPositionX(self.ui.player_info_blue:getContentSize().width / 2 - 1)
  curBlueEff:setPositionY(self.ui.player_info_blue:getContentSize().height / 2 + 30)
  local curRedEff = ed.createFcaNode("eff_UI_kingspvp_selecting_light2")
  self.curRedEff = curRedEff
  self:addFca(curRedEff)
  curRedEff:update(0)
  self.ui.player_info_red:addChild(curRedEff)
  curRedEff:setPositionX(self.ui.player_info_red:getContentSize().width / 2 - 1)
  curRedEff:setPositionY(self.ui.player_info_red:getContentSize().height / 2 + 30)
  ed.stopMusic()
  self:initLabels()
  self:adaptUI()
  self:initPlayerInfo()
  self:refreshWinCount()
  self:initTableView()
  self:startCountDown()
  self:initEffect()
  if self.isAudience then
    self.ui.image_chat_selection_bg:setVisible(false)
  else
    self.ui.image_chat_selection_bg:setVisible(true)
    self.chatSelectionWrap = ed.ui.KingsPvpChatSelectionWrap.create({
      ui = self.ui,
      touchListener = self,
      sendFunc = function(content)
        ed.realarena.network_mgr:RequestPvpChat(content)
      end,
      focusFunc = function(isFocus)
        self.heroPoolTableView:getDragList():setTouchEnabled(not isFocus)
      end
    })
  end
  self:refreshFilterBtn()
  self:refreshHeroPool()
  self:resetRoundSelectHeroInfo()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(1196165), 1.5)
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(1196165), 2)
  ed.setLabelFontName(self.ui.label_time, ed.fontBold)
  ed.setLabelStroke(self.ui.label_backup_time, ed.toccc3(461585), 1)
  ed.setLabelStroke(self.ui.label_all, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_front, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_middle, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_back, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_str, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_agi, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_int, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_confirm, ed.toccc3(9131052), 1.5)
  ed.setLabelFontName(self.ui.label_confirm, ed.fontBold)
  ed.setLabelStroke(self.ui.label_win_count_blue, ed.toccc3(1049090), 1)
  ed.setLabelStroke(self.ui.label_win_count_red, ed.toccc3(1049090), 1)
  ed.setLabelStroke(self.ui.label_legend_equip_tips, ed.toccc3(0), 1)
  local obTips = ed.ui.gradientLabel.create({
    text = T("\230\173\163\229\156\168\232\167\130\230\136\152"),
    fontSize = 21,
    startColor = ed.toccc3(16776400),
    endColor = ed.toccc3(16700269),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(5516808)
  })
  self.ui.image_ob_tips:addChild(obTips.node)
  ed.layout.centerInParent(obTips.node)
end

function class:adaptUI()
  if not self.isOpenAthleticsAct then
    self.ui.label_legend_equip_tips:setVisible(false)
    local oldPoolSize = self.ui.panel_hero_pool:getContentSize()
    self.ui.panel_hero_pool:setContentSize(CCSizeMake(oldPoolSize.width, oldPoolSize.height + 20))
  end
end

function class:refreshWinCount()
  ed.setLabelString(self.ui.label_win_count_blue, string.format(T("\232\131\156\229\156\186\239\188\154%s"), self.hostWinCnt))
  ed.setLabelString(self.ui.label_win_count_red, string.format(T("\232\131\156\229\156\186\239\188\154%s"), self.guestWinCnt))
end

function class:initEffect()
end

function class:getBanPickAmount()
  local banAmount = 0
  local pickAmount = 0
  for index, cfg in ipairs(ed.getDataTable("KingsBP")) do
    if cfg["Present Player"] == "Host" then
      if cfg.Condition == "Ban" then
        banAmount = banAmount + cfg["Hero Num"]
      elseif cfg.Condition == "Pick" then
        pickAmount = pickAmount + cfg["Hero Num"]
      end
    end
  end
  return banAmount, pickAmount
end

function class:checkHeroIsBaned(heroId)
  for index, heroInfo in ipairs(self.guestBanList) do
    if heroId == heroInfo._id then
      return true
    end
  end
  for index, heroInfo in ipairs(self.hostBanList) do
    if heroId == heroInfo._id then
      return true
    end
  end
  return false
end

function class:checkHeroIsPicked(heroId)
  for index, heroInfo in ipairs(self.guestPickList) do
    if heroId == heroInfo._id then
      return true
    end
  end
  for index, heroInfo in ipairs(self.hostPickList) do
    if heroId == heroInfo._id then
      return true
    end
  end
  return false
end

function class:startCountDown()
  self.ui.image_time_bg:setVisible(true)
  self.ui.image_backup_time_bg:stopAllActions()
  self.ui.image_backup_time_bg:setScale(1)
  self.ui.image_backup_time_bg:setPosition(ccp(480, 453.5))
  self:closeCountDownEffect()
  self:refreshLeftTime()
  CloseTimer("countDown")
  CloseTimer("backupCountDown")
  self:listenTimer(Timer:Always(1, "countDown"), function()
    self:refreshLeftTime()
  end)
end

function class:showCountDownEffect()
  if self.eff_countDown then
    self.eff_countDown:removeFromParentAndCleanup(true)
  end
  local eff_countDown = ed.createFcaNode("eff_UI_chess_countdown")
  self:addFca(eff_countDown)
  self.mainLayer:addChild(eff_countDown)
  eff_countDown:setPosition(self.ui.image_time_bg:getPosition())
  self.eff_countDown = eff_countDown
end

function class:closeCountDownEffect()
  if self.eff_countDown then
    self.eff_countDown:removeFromParentAndCleanup(true)
    self.eff_countDown = nil
  end
end

function class:refreshLeftTime()
  self.operate_time = math.max(self.operate_time, 0)
  ed.setLabelString(self.ui.label_time, self.operate_time)
  if self.operate_time <= 5 then
    ed.setLabelColor(self.ui.label_time, ed.toccc3(16734296))
    ed.setLabelStroke(self.ui.label_time, ed.toccc3(10620672), 2)
    self.ui.label_time:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.3, 1.5), CCScaleTo:create(0.2, 1))))
    self:showCountDownEffect()
  end
  if self.operate_time <= 0 then
    CloseTimer("countDown")
    CloseTimer("backupCountDown")
    self:closeCountDownEffect()
    if self.backupTime and 0 < self.backupTime then
      self:startBackTimeCountDown()
    end
  end
  self.operate_time = self.operate_time - 1
end

function class:startBackTimeCountDown()
  self.ui.image_time_bg:setVisible(false)
  local scaleAction = CCScaleTo:create(0.5, 1.5)
  local moveAction = CCMoveTo:create(0.5, ccp(480, 480))
  self.ui.image_backup_time_bg:runAction(CCSpawn:createWithTwoActions(scaleAction, moveAction))
  ed.playEffect(ed.sound.deo.kings_pvp_extra_time)
  ed.setLabelString(self.ui.label_backup_time, string.format(T("\229\164\135\231\148\168\230\151\182\233\151\180\239\188\154%s\231\167\146"), self.backupTime or 0))
  self:listenTimer(Timer:Always(1, "backupCountDown"), function()
    self.backupTime = self.backupTime - 1
    self.backupTime = math.max(self.backupTime, 0)
    ed.setLabelString(self.ui.label_backup_time, string.format(T("\229\164\135\231\148\168\230\151\182\233\151\180\239\188\154%s\231\167\146"), self.backupTime or 0))
    if self.backupTime <= 0 then
      self:closeCountDownEffect()
      CloseTimer("backupCountDown")
    end
  end)
end

function class:getHeroIconSize()
  return CCSizeMake(90, 90)
end

function class:initTableView()
  local panelSize = self.ui.panel_hero_pool:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.heroPool
    end,
    cellSizeFromIndex = function(index)
      return self:getHeroIconSize()
    end,
    createCell = function(index)
      local heroId = self.heroPool[index]
      local heroData
      if self.operateType == "ban" then
        if self.turn == "host" then
          heroData = ed.realarena.hero_mgr:getGuestHeroByID(heroId)
        else
          heroData = ed.realarena.hero_mgr:getHostHeroByID(heroId)
        end
      elseif self.operateType == "pick" then
        if self.turn == "host" then
          heroData = ed.realarena.hero_mgr:getHostHeroByID(heroId)
        else
          heroData = ed.realarena.hero_mgr:getGuestHeroByID(heroId)
        end
      end
      local isShowLegendEquip = true
      if self:isMyTurn() then
        if self.operateType == "ban" then
          isShowLegendEquip = false
        end
      elseif self.operateType == "pick" then
        isShowLegendEquip = false
      end
      local node = self:createHeroItem(heroId, heroData, isShowLegendEquip)
      return node, {hero = heroData}
    end,
    doPressIn = function(cell, x, y)
      local node = cell.node
      local data = cell.data
      local heroIcon = node.heroIcon
      heroIcon:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local node = cell.node
      local data = cell.data
      local heroIcon = node.heroIcon
      heroIcon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local heroIcon = data.heroIcon
      local hero = data.hero
      self:onClickHero(hero)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_hero_pool,
    cliprect = CCRectMake(0, 0, panelSize.width, panelSize.height),
    colNum = 7,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true,
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(0, panelSize.height / 2)
    }
  }
  self.heroPoolTableView = Tableview.create(param)
end

local karl_hero_tid = 53

function class:refreshKarlElementByTeam()
  local showState = false
  for index = 1, self.pickHeroAmount do
    if self.hostPickList[index] then
      local heroId = self.hostPickList[index]._id
      if heroId == karl_hero_tid then
        showState = true
      end
    end
  end
  for index = 1, self.pickHeroAmount do
    local heroData
    if self.guestPickList[index] then
      local heroId = self.guestPickList[index]._id
      if heroId == karl_hero_tid then
        showState = true
      end
    end
  end
  self.showElement = showState
  self:refreshTableViewKarlElement()
end

function class:refreshTableViewKarlElement()
  local usedCells = self.heroPoolTableView:getUsedCell()
  if 0 < #usedCells then
    for i, v in ipairs(usedCells) do
      if nil ~= v and nil ~= v.data.heroIcon then
        v.data.heroIcon:showKarlElement(self.showElement)
      end
    end
  end
end

function class:createHeroItem(heroId, heroData, isShowLegendEquip)
  local container = ed.createSprite()
  container:setContentSize(self:getHeroIconSize())
  local heroIcon
  if heroData then
    heroIcon = ed.readhero.createIcon({
      id = heroData._tid,
      rank = heroData._rank,
      level = heroData._level,
      stars = heroData._stars,
      shard = heroData._shard,
      legendEquip = heroData._legend_equip and heroData._legend_equip._equip,
      karlElement = ed.readhero.getHeroElement(heroData._tid),
      isShowLegendEquip = ed.openLegendEquip()
    })
  else
    heroIcon = ed.readhero.createIcon({
      id = heroId,
      karlElement = ed.readhero.getHeroElement(heroId),
      isShowLegendEquip = ed.openLegendEquip()
    })
  end
  if self.isOpenAthleticsAct then
    heroIcon:showLegendEquip(not isShowLegendEquip)
  else
    heroIcon:showLegendEquip(true)
  end
  if heroIcon.levelLabel then
    heroIcon.levelLabel:setVisible(false)
  end
  if heroIcon.levelBg then
    heroIcon.levelBg:setVisible(false)
  end
  container:addChild(heroIcon.icon)
  ed.layout.centerInParent(heroIcon.icon)
  container.heroIcon = heroIcon.icon
  heroIcon:showKarlElement(self.showElement)
  if ed.isElementInTable(heroId, self.usedHeroes) then
    heroIcon:addShade()
  elseif not heroData then
    heroIcon:addShade()
  elseif self:checkHeroIsBaned(heroId) then
    local banTag = ed.createSprite("UI/alpha/1080P/toparena/toparena_ban_symbol_1.png")
    banTag:setScale(0.5)
    container:addChild(banTag, 3)
    banTag:setPosition(ccp(68, 20))
    heroIcon:addShade()
  elseif self:checkHeroIsPicked(heroId) then
    local finish = ed.createSprite("UI/alpha/1080P/package/selected.png")
    finish:setScale(0.5)
    container:addChild(finish, 3)
    finish:setPosition(ccp(68, 18))
    heroIcon:addShade()
  elseif ed.realarena.hero_mgr:heroIsRestricted(heroId) then
    heroIcon:addShade()
  end
  if ed.isElementInTable(heroId, self.selectHeroIdList) then
    local lightFrame = ed.createSprite("UI/alpha/1080P/newkingspvp/pickhero/selected.png")
    container:addChild(lightFrame, 2)
    ed.layout.centerInParent(lightFrame)
  end
  if heroData then
    local isFree = ed.realarena.hero_mgr:checkIsFreeHero(heroData._tid)
    if isFree then
      heroIcon:addTimelyFreeTag()
    end
  end
  return container
end

function class:refreshHeroPool()
  self.heroPoolTableView:reloadData()
end

function class:refreshHostBanHero()
  self.ui.panel_ban_hero_blue:removeAllChildrenWithCleanup(true)
  local isHostBan = self.turn == "host" and self.operateType == "ban"
  local posX = 0
  for index = 1, self.banHeroAmount do
    local heroData
    if self.hostBanList[index] then
      local heroId = self.hostBanList[index]._id
      heroData = ed.realarena.hero_mgr:getGuestHeroByID(heroId)
    end
    local isCurrentSelect = false
    if isHostBan and index > self.beginHostBanAmount and index <= self.beginHostBanAmount + self.select_count_limit then
      isCurrentSelect = true
    end
    local banNode = self:createBanNode(heroData, isCurrentSelect)
    local size = banNode:getContentSize()
    self.ui.panel_ban_hero_blue:addChild(banNode)
    banNode:setPositionX(posX + size.width / 2)
    banNode:setPositionY(self.ui.panel_ban_hero_blue:getContentSize().height / 2)
    posX = posX + size.width
    self:btRegisterButtonClick({
      button = banNode,
      key = "click_host_ban_node" .. index,
      clickHandler = function()
        if self.isAudience then
          return
        end
        if heroData and heroData._tid then
          self:deleteTeamMember(heroData._tid)
          self:hostReloadHeroPool()
        end
      end,
      force = true
    })
  end
end

function class:refreshHostPickHero()
  self.ui.panel_pick_hero_blue:removeAllChildrenWithCleanup(true)
  self.hostPickHeroList = {}
  local isHostPick = self.turn == "host" and self.operateType == "pick"
  local isShowLegendEquip = self.isHost
  local posY = 0
  for index = 1, self.pickHeroAmount do
    local heroData
    if self.hostPickList[index] then
      local heroId = self.hostPickList[index]._id
      heroData = ed.realarena.hero_mgr:getHostHeroByID(heroId)
    end
    local isCurrentSelect = false
    if isHostPick and index > self.beginHostPickAmount and index <= self.beginHostPickAmount + self.select_count_limit then
      isCurrentSelect = true
    end
    local pickNode = self:createPickNode(heroData, isCurrentSelect, isShowLegendEquip)
    if heroData then
      table.insert(self.hostPickHeroList, pickNode)
    end
    local size = pickNode:getContentSize()
    self.ui.panel_pick_hero_blue:addChild(pickNode)
    pickNode:setPositionX(self.ui.panel_pick_hero_blue:getContentSize().width / 2)
    pickNode:setPositionY(self.ui.panel_pick_hero_blue:getContentSize().height - posY - 45)
    posY = posY + size.height + 19
    self:btRegisterButtonClick({
      button = pickNode,
      key = "click_host_pick_node" .. index,
      clickHandler = function()
        if self.isAudience then
          return
        end
        if heroData and heroData._tid then
          self:deleteTeamMember(heroData._tid)
          self:hostReloadHeroPool()
        end
      end,
      force = true
    })
  end
end

function class:refreshGuestBanHero()
  self.ui.panel_ban_hero_red:removeAllChildrenWithCleanup(true)
  local isGuestBan = self.turn == "guest" and self.operateType == "ban"
  local posX = self.ui.panel_ban_hero_red:getContentSize().width
  for index = 1, self.banHeroAmount do
    local heroData
    if self.guestBanList[index] then
      local heroId = self.guestBanList[index]._id
      heroData = ed.realarena.hero_mgr:getHostHeroByID(heroId)
    end
    local isCurrentSelect = false
    if isGuestBan and index > self.beginGuestBanAmount and index <= self.beginGuestBanAmount + self.select_count_limit then
      isCurrentSelect = true
    end
    local banNode = self:createBanNode(heroData, isCurrentSelect)
    local size = banNode:getContentSize()
    self.ui.panel_ban_hero_red:addChild(banNode)
    banNode:setPositionX(posX - size.width / 2)
    banNode:setPositionY(self.ui.panel_ban_hero_red:getContentSize().height / 2)
    posX = posX - size.width
    self:btRegisterButtonClick({
      button = banNode,
      key = "click_guest_ban_node" .. index,
      clickHandler = function()
        if self.isAudience then
          return
        end
        if heroData and heroData._tid then
          self:deleteTeamMember(heroData._tid)
          self:hostReloadHeroPool()
        end
      end,
      force = true
    })
  end
end

function class:refreshGuestPickHero()
  self.ui.panel_pick_hero_red:removeAllChildrenWithCleanup(true)
  self.guestPickHeroList = {}
  local isGuestPick = self.turn == "guest" and self.operateType == "pick"
  local isShowLegendEquip = not self.isHost
  local posY = 0
  for index = 1, self.pickHeroAmount do
    local heroData
    if self.guestPickList[index] then
      local heroId = self.guestPickList[index]._id
      heroData = ed.realarena.hero_mgr:getGuestHeroByID(heroId)
    end
    local isCurrentSelect = false
    if isGuestPick and index > self.beginGuestPickAmount and index <= self.beginGuestPickAmount + self.select_count_limit then
      isCurrentSelect = true
    end
    local pickNode = self:createPickNode(heroData, isCurrentSelect, isShowLegendEquip)
    if heroData then
      table.insert(self.guestPickHeroList, pickNode)
    end
    local size = pickNode:getContentSize()
    self.ui.panel_pick_hero_red:addChild(pickNode)
    pickNode:setPositionX(self.ui.panel_pick_hero_red:getContentSize().width / 2)
    pickNode:setPositionY(self.ui.panel_pick_hero_red:getContentSize().height - posY - 45)
    posY = posY + size.height + 19
    self:btRegisterButtonClick({
      button = pickNode,
      key = "click_guest_pick_node" .. index,
      clickHandler = function()
        if self.isAudience then
          return
        end
        if heroData and heroData._tid then
          self:deleteTeamMember(heroData._tid)
          self:hostReloadHeroPool()
        end
      end,
      force = true
    })
  end
end

function class:createPickNode(heroData, isCurrentSelect, isShowLegendEquip)
  local container = ed.createSprite()
  container:setCascadeOpacityEnabled(true)
  container:setContentSize(CCSizeMake(50, 50))
  local heroHeadBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head.png")
  container:addChild(heroHeadBg, 0)
  heroHeadBg:setScale(1.1)
  ed.layout.centerInParent(heroHeadBg)
  if heroData then
    local fashionId = self.bpEnd and heroData._fashion or 0
    local heroItem = ed.readhero.createIcon({
      id = heroData._tid,
      rank = heroData._rank,
      level = heroData._level,
      stars = heroData._stars,
      fashion_id = fashionId,
      shard = heroData._shard,
      legendEquip = heroData._legend_equip and heroData._legend_equip._equip,
      karlElement = ed.readhero.getHeroElement(heroData._tid),
      isShowLegendEquip = ed.openLegendEquip()
    })
    if self.isOpenAthleticsAct then
      heroItem:showLegendEquip(not isShowLegendEquip)
    else
      heroItem:showLegendEquip(true)
    end
    local heroIcon = heroItem.icon
    heroIcon:setScale(0.8)
    container:addChild(heroIcon, 1)
    heroItem:showKarlElement(self.showElement)
    ed.layout.centerInParent(heroIcon)
    container.heroIcon = heroIcon
  end
  local finish = ed.createSprite("UI/alpha/1080P/package/selected.png")
  finish:setScale(0.5)
  container:addChild(finish, 3)
  finish:setPosition(ccp(42, 4))
  finish:setVisible(false)
  if heroData and not ed.isElementInTable(heroData._tid, self.selectHeroIdList) and self:checkHeroIsPicked(heroData._tid) then
    finish:setVisible(true)
  end
  local lightFrame = ed.createFcaNode("eff_UI_kingspvp_pick")
  self:addFca(lightFrame)
  container:addChild(lightFrame, 2)
  ed.layout.centerInParent(lightFrame)
  if isCurrentSelect then
    lightFrame:setVisible(true)
  else
    lightFrame:setVisible(false)
  end
  container.heroHeadBg = heroHeadBg
  container.lightFrame = lightFrame
  container.finish = finish
  container.heroData = heroData
  return container
end

function class:createBanNode(heroData, isCurrentSelect)
  local container = ed.createSprite("UI/alpha/1080P/newkingspvp/pickhero/ban_bg.png")
  if heroData then
    local heroIcon = ed.readhero.createIcon({
      id = heroData._tid,
      karlElement = ed.readhero.getHeroElement(heroData._tid),
      isShowLegendEquip = ed.openLegendEquip()
    })
    heroIcon.icon:setScale(0.55)
    container:addChild(heroIcon.icon, 0)
    ed.layout.centerInParent(heroIcon.icon)
    container.heroIcon = heroIcon.icon
    heroIcon:addShade()
    local banTag = ed.createSprite("UI/alpha/1080P/toparena/toparena_ban_symbol_1.png")
    banTag:setScale(0.32)
    container:addChild(banTag, 1)
    banTag:setPosition(ccp(35, 8))
  end
  local lightFrame = ed.createFcaNode("eff_UI_kingspvp_ban")
  self:addFca(lightFrame)
  container:addChild(lightFrame, 2)
  ed.layout.centerInParent(lightFrame)
  if isCurrentSelect then
    lightFrame:setVisible(true)
  else
    lightFrame:setVisible(false)
  end
  return container
end

function class:initPlayerInfo()
  local hostSummary = ed.realarena.mgr.hostUserSummary
  local guestSummary = ed.realarena.mgr.guestUserSummary
  self.isAudience = hostSummary._role_id ~= ed.getRoleId() and guestSummary._role_id ~= ed.getRoleId()
  local headBlue = ed.getWholeHeadIcon({
    id = hostSummary._avatar
  })
  headBlue:setScale(0.75)
  self.ui.player_info_blue:addChild(headBlue)
  headBlue:setPosition(self.ui.panel_head_icon_blue:getPosition())
  local nameBlue = ed.getPlayerName(hostSummary._name, hostSummary._medal)
  self.ui.player_name_bg_blue:addChild(nameBlue)
  ed.layout.centerInParent(nameBlue)
  local headRed = ed.getWholeHeadIcon({
    id = guestSummary._avatar
  })
  headRed:setScale(0.75)
  self.ui.player_info_red:addChild(headRed)
  headRed:setPosition(self.ui.panel_head_icon_red:getPosition())
  local nameRed = ed.getPlayerName(guestSummary._name, guestSummary._medal)
  self.ui.player_name_bg_red:addChild(nameRed)
  ed.layout.centerInParent(nameRed)
end

function class:isMyTurn()
  if self.turn == "host" and self.isHost then
    return true
  elseif self.turn == "guest" and not self.isHost then
    return true
  end
  return false
end

function class:resetRoundSelectHeroInfo()
  local param = {
    _turn = self.turn,
    _is_host = self.isHost and 1 or 0,
    _operate_type = self.operateType,
    _operate_time = self.operate_time,
    _select_count = self.select_count_limit,
    _bp_round = self.bpRound,
    _backup_time = self.backupTime,
    _used_heroes = self.usedHeroes,
    _host_win_cnt = self.hostWinCnt,
    _guest_win_cnt = self.guestWinCnt
  }
  self:refreshTurn(param)
end

function class:refreshTurn(msg)
  self.turn = msg._turn
  self.isHost = msg._is_host == 1
  self.operateType = msg._operate_type
  self.operate_time = msg._operate_time or 0
  self.select_count_limit = msg._select_count
  self.bpRound = msg._bp_round
  self.backupTime = msg._backup_time or 0
  self.hostPickList = msg._host_picked or {}
  self.guestPickList = msg._guest_picked or {}
  self.hostBanList = msg._host_banned or {}
  self.guestBanList = msg._guest_banned or {}
  self.usedHeroes = msg._used_heroes or {}
  self.hostWinCnt = msg._host_win_cnt or 0
  self.guestWinCnt = msg._guest_win_cnt or 0
  self.beginHostPickAmount = #self.hostPickList
  self.beginGuestPickAmount = #self.guestPickList
  self.beginHostBanAmount = #self.hostBanList
  self.beginGuestBanAmount = #self.guestBanList
  self.selectHeroIdList = {}
  self.selectFilterType = "all"
  if self.operateType == "ban" then
    self.heroPool = self.online_all
    self.ui.image_ban_bg:setVisible(true)
  elseif self.operateType == "pick" then
    self.heroPool = self.online_all
    self.ui.image_ban_bg:setVisible(false)
  end
  if self.isAudience then
    self:refreshAudienceUI()
  elseif self:isMyTurn() then
    self:Unlock()
  else
    self:Lock()
  end
  self:refreshHeroPool()
  self:refreshFilterBtn()
  self:startCountDown()
  self:refreshHostPickHero()
  self:refreshHostBanHero()
  self:refreshGuestBanHero()
  self:refreshGuestPickHero()
  self:refreshWinCount()
  self:refreshView()
  self:playSound()
  self:refreshKarlElementByTeam()
end

function class:refreshBPEnd(msg)
  self.bpEnd = true
  self.hostPickList = msg._host_picked or {}
  self.guestPickList = msg._guest_picked or {}
  self.hostBanList = msg._host_banned or {}
  self.guestBanList = msg._guest_banned or {}
  self.countDownTime = msg._count_down_time or 1
  self.select_count_limit = 0
  self.selectHeroIdList = {}
  if self.isAudience then
    self:refreshAudienceUI()
  else
    self:Lock()
  end
  self:refreshHeroPool()
  self:refreshHostPickHero()
  self:refreshHostBanHero()
  self:refreshGuestBanHero()
  self:refreshGuestPickHero()
  ed.setLabelString(self.ui.label_lock, T("\229\141\179\229\176\134\232\191\155\229\133\165\230\136\152\230\150\151"))
  ed.setLabelString(self.ui.label_title, T("\229\141\179\229\176\134\232\191\155\229\133\165\230\136\152\230\150\151"))
  ed.setLabelString(self.ui.label_time, self.countDownTime)
  self.ui.image_time_bg:setVisible(true)
  self.ui.image_backup_time_bg:setVisible(false)
  self.ui.image_backup_time_bg:stopAllActions()
  self.ui.image_backup_time_bg:setScale(1)
  self.ui.image_backup_time_bg:setPosition(ccp(480, 453.5))
  self.ui.btn_confirm:setVisible(false)
  self.curBlueEff:setVisible(false)
  self.curRedEff:setVisible(false)
  self:showPickHeroIconEff()
  CloseTimer("countDown")
  CloseTimer("backupCountDown")
  self:listenTimer(Timer:Times(1, self.countDownTime), function()
    self.countDownTime = self.countDownTime - 1
    self.countDownTime = math.max(self.countDownTime, 0)
    ed.setLabelString(self.ui.label_time, self.countDownTime)
  end)
end

function class:showPickHeroIconEff()
  for index, pickNode in ipairs(self.hostPickHeroList) do
    local heroData = pickNode.heroData
    if heroData._fashion and heroData._fashion > 0 then
      local heroIcon = pickNode.heroIcon
      heroIcon:setOpacity(0)
      local callFunc = CCCallFunc:create(function()
        local eff_portrait = ed.createFcaNode("eff_UI_kingspvp_fashion_portrait")
        self:addFca(eff_portrait)
        eff_portrait:setScale(0.45)
        heroIcon:addChild(eff_portrait)
        eff_portrait:setPosition(ccp(35, 35))
      end)
      local delayTime = CCDelayTime:create(0.2)
      local fadeTo = CCFadeTo:create(0.3, 255)
      heroIcon:runAction(CCSequence:create(ccArrayMake(callFunc, delayTime, fadeTo)))
    end
  end
  for index, pickNode in ipairs(self.guestPickHeroList) do
    local heroData = pickNode.heroData
    if heroData._fashion and heroData._fashion > 0 then
      local heroIcon = pickNode.heroIcon
      heroIcon:setOpacity(0)
      local callFunc = CCCallFunc:create(function()
        local eff_portrait = ed.createFcaNode("eff_UI_kingspvp_fashion_portrait")
        self:addFca(eff_portrait)
        eff_portrait:setScale(0.45)
        heroIcon:addChild(eff_portrait)
        eff_portrait:setPosition(ccp(35, 35))
      end)
      local delayTime = CCDelayTime:create(0.2)
      local fadeTo = CCFadeTo:create(0.3, 255)
      heroIcon:runAction(CCSequence:create(ccArrayMake(callFunc, delayTime, fadeTo)))
    end
  end
end

function class:playSound()
  if self.operateType == "ban" then
    if self.turn == "host" then
      ed.playEffect(ed.sound.deo.kings_pvp_blue_ban)
    elseif self.turn == "guest" then
      ed.playEffect(ed.sound.deo.kings_pvp_red_ban)
    end
  elseif self.operateType == "pick" then
    if self.turn == "host" then
      ed.playEffect(ed.sound.deo.kings_pvp_blue_pick)
    elseif self.turn == "guest" then
      ed.playEffect(ed.sound.deo.kings_pvp_red_pick)
    end
  end
end

function class:refreshView()
  local dir = self.turn == "host" and T("\232\147\157") or T("\231\186\162")
  local operate = self.operateType == "ban" and T("\231\166\129\231\148\168") or T("\230\140\145\233\128\137")
  local title = string.format(T("\232\175\183%s\230\150\185%s%s\228\184\170\232\139\177\233\155\132"), dir, operate, self.select_count_limit or 0)
  ed.setLabelString(self.ui.label_title, title)
  ed.setLabelString(self.ui.label_backup_time, string.format(T("\229\164\135\231\148\168\230\151\182\233\151\180\239\188\154%s\231\167\146"), self.backupTime or 0))
  if self.operateType == "ban" then
    ed.setLabelStroke(self.ui.label_title, ed.toccc3(8523281), 1.5)
    ed.setLabelColor(self.ui.label_time, ed.toccc3(16776680))
    ed.setLabelStroke(self.ui.label_time, ed.toccc3(8523281), 2)
    self.ui.image_time_bg:setOpacity(0)
  else
    ed.setLabelStroke(self.ui.label_title, ed.toccc3(1196165), 1.5)
    ed.setLabelColor(self.ui.label_time, ed.toccc3(16776680))
    ed.setLabelStroke(self.ui.label_time, ed.toccc3(1196165), 2)
    self.ui.image_time_bg:setOpacity(255)
  end
  local poolBgPath
  if self.turn == "host" then
    self.curBlueEff:setVisible(true)
    self.curRedEff:setVisible(false)
    poolBgPath = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_1.png"
    ed.setTexture(self.ui.image_backup_time_bg, "UI/alpha/1080P/newkingspvp/pickhero/select_bg_5.png")
  else
    self.curBlueEff:setVisible(false)
    self.curRedEff:setVisible(true)
    poolBgPath = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_2.png"
    ed.setTexture(self.ui.image_backup_time_bg, "UI/alpha/1080P/newkingspvp/pickhero/select_bg_8.png")
  end
  local poolSize = self.ui.hero_pool_bg:getContentSize()
  self.ui.hero_pool_bg:setSpriteFrame(ed.getSpriteFrame(poolBgPath))
  self.ui.hero_pool_bg:setContentSize(poolSize)
end

function class:HeroSelectTimeOut()
  ed.playEffect(ed.sound.deo.map_stage_detail)
  ed.showToast(T("\233\128\137\230\139\169\230\151\182\233\151\180\229\136\176"))
  self:roundEnd()
end

function class:Lock()
  self.ui.image_lock:setVisible(true)
  self.ui.btn_confirm_lock:setVisible(true)
  self.ui.image_ob_tips:setVisible(false)
  self.ui.btn_confirm:setVisible(true)
  ed.updateSpriteGray(self.ui.btn_confirm, true)
end

function class:Unlock()
  self.ui.image_lock:setVisible(false)
  self.ui.btn_confirm_lock:setVisible(false)
  self.ui.image_ob_tips:setVisible(false)
  self.ui.btn_confirm:setVisible(true)
  ed.updateSpriteGray(self.ui.btn_confirm, false)
end

function class:refreshAudienceUI()
  self.ui.image_lock:setVisible(false)
  self.ui.btn_confirm_lock:setVisible(false)
  self.ui.image_ob_tips:setVisible(true)
  self.ui.btn_confirm:setVisible(false)
end

function class:showShakeTips()
  local action1 = CCMoveBy:create(0.1, ccp(0, 10))
  local action2 = CCMoveBy:create(0.1, ccp(0, -20))
  local action3 = CCMoveBy:create(0.1, ccp(0, 15))
  local action4 = CCMoveBy:create(0.1, ccp(0, -10))
  local action5 = CCMoveBy:create(0.1, ccp(0, 5))
  self.ui.image_lock_tips:runAction(CCSequence:create(ccArrayMake(action1, action2, action3, action4, action5)))
end

function class:hostReloadHeroPool()
  local listX, listY = self.heroPoolTableView:getListPos()
  self.heroPoolTableView:reloadData()
  self.heroPoolTableView:setListPos(ccp(listX, listY))
end

function class:onClickHero(hero)
  if self.isAudience then
    return
  end
  if not self:isMyTurn() or self.bpEnd then
    self:showShakeTips()
    return
  end
  if not hero then
    ed.showToast(T("\232\175\165\231\142\169\229\174\182\232\191\152\230\156\170\229\143\172\229\148\164\230\173\164\232\139\177\233\155\132"))
    return
  end
  if ed.isElementInTable(hero._tid, self.usedHeroes) then
    ed.showToast(T("\230\173\164\232\139\177\233\155\132\229\183\178\229\135\186\229\156\186\232\191\135\239\188\140\230\151\160\230\179\149\229\134\141\230\172\161\233\128\137\230\139\169"))
    return
  end
  if ed.realarena.hero_mgr:heroIsRestricted(hero._tid) then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\230\154\130\230\156\170\229\138\160\229\133\165\232\175\184\231\142\139\228\186\137\233\156\184"))
    return
  end
  if ed.isElementInTable(hero._tid, self.selectHeroIdList) then
    self:deleteTeamMember(hero._tid)
  else
    if self:checkHeroIsPicked(hero._tid) then
      ed.showToast(T("\232\139\177\233\155\132\229\183\178\232\162\171\233\128\137\230\139\169"))
      return
    end
    if self:checkHeroIsBaned(hero._tid) then
      ed.showToast(T("\232\139\177\233\155\132\229\183\178\232\162\171\231\166\129\231\148\168"))
      return
    end
    if self.select_count_limit == 1 then
      if #self.selectHeroIdList >= 1 then
        self:deleteTeamMember(self.selectHeroIdList[1])
      end
    elseif #self.selectHeroIdList >= self.select_count_limit then
      ed.showToast(string.format(T("\230\156\172\232\189\174\229\143\170\232\131\189\233\128\137\230\139\169%d\228\184\170\232\139\177\233\155\132"), self.select_count_limit))
      return
    end
    self:addTeamMember(hero._tid)
  end
  self:hostReloadHeroPool()
end

function class:addTeamMember(heroId)
  table.insert(self.selectHeroIdList, heroId)
  if self.operateType == "ban" then
    if self.isHost then
      table.insert(self.hostBanList, {_id = heroId})
      self:refreshKarlElementByTeam()
      self:refreshHostBanHero()
    else
      table.insert(self.guestBanList, {_id = heroId})
      self:refreshKarlElementByTeam()
      self:refreshGuestBanHero()
    end
  elseif self.operateType == "pick" then
    if self.isHost then
      table.insert(self.hostPickList, {_id = heroId})
      self:refreshKarlElementByTeam()
      self:refreshHostPickHero()
      self:runHeroIconFlyAction(self.hostPickHeroList[#self.hostPickHeroList].heroIcon, "moveIn", "left")
    else
      table.insert(self.guestPickList, {_id = heroId})
      self:refreshKarlElementByTeam()
      self:refreshGuestPickHero()
      self:runHeroIconFlyAction(self.guestPickHeroList[#self.guestPickHeroList].heroIcon, "moveIn", "right")
    end
  end
end

function class:deleteTeamMember(delHeroId)
  local findIndex
  for index, heroId in ipairs(self.selectHeroIdList) do
    if heroId == delHeroId then
      findIndex = index
      break
    end
  end
  if not findIndex then
    return
  end
  table.remove(self.selectHeroIdList, findIndex)
  if self.operateType == "ban" then
    if self.isHost then
      self:removeElementByHeroId(self.hostBanList, delHeroId)
      self:refreshKarlElementByTeam()
      self:refreshHostBanHero()
    else
      self:removeElementByHeroId(self.guestBanList, delHeroId)
      self:refreshKarlElementByTeam()
      self:refreshGuestBanHero()
    end
  elseif self.operateType == "pick" then
    if self.isHost then
      self:removeElementByHeroId(self.hostPickList, delHeroId)
      self:refreshKarlElementByTeam()
      self:refreshHostPickHero()
    else
      self:removeElementByHeroId(self.guestPickList, delHeroId)
      self:refreshKarlElementByTeam()
      self:refreshGuestPickHero()
    end
  end
end

function class:removeElementByHeroId(list, heroId)
  local findIndex
  for index, heroInfo in ipairs(list) do
    if heroInfo._id == heroId then
      findIndex = index
      break
    end
  end
  if findIndex then
    table.remove(list, findIndex)
  end
end

function class:runHeroIconFlyAction(node, inOut, direction)
  if not node or tolua.isnull(node) then
    return
  end
  local offsetX = 0
  if direction == "left" then
    offsetX = -80
  elseif direction == "right" then
    offsetX = 80
  end
  node:setCascadeOpacityEnabled(true)
  if inOut == "moveIn" then
    node:setOpacity(0)
    node:setPositionX(node:getPositionX() - offsetX)
    local fadeAction = CCFadeTo:create(0.2, 255)
    local moveAction = CCEaseIn:create(CCMoveBy:create(0.2, ccp(offsetX, 0)), 5)
    node:runAction(CCSpawn:createWithTwoActions(fadeAction, moveAction))
  elseif inOut == "moveOut" then
    node:setPositionX(node:getPositionX() - offsetX)
    local fadeAction = CCFadeTo:create(0.2, 0)
    local moveAction = CCEaseIn:create(CCMoveBy:create(0.2, ccp(offsetX, 0)), 5)
    node:runAction(CCSpawn:createWithTwoActions(fadeAction, moveAction))
  end
end

function class:refreshFilterBtn()
  for _, btnType in ipairs(self.filterBtnTypeList) do
    local btnSelect = self.ui[string.format("btn_%s_select", btnType)]
    if btnSelect then
      btnSelect:setVisible(btnType == self.selectFilterType)
    end
  end
end

function class:onClickBtnFilter(type)
  if not self:isMyTurn() and not self.isAudience then
    self:showShakeTips()
    return
  end
  if self.selectFilterType == type then
    return
  end
  self.selectFilterType = type
  self:refreshFilterBtn()
  self.heroPool = self["online_" .. type] or {}
  self:refreshHeroPool()
end

function class:onClickBtnConfirm()
  if self.isAudience then
    return
  end
  if not self:isMyTurn() or self.bpEnd then
    self:showShakeTips()
    return
  end
  self:roundEnd()
end

function class:addTouchEvent()
  for _, btnType in ipairs(self.filterBtnTypeList) do
    local btn = self.ui["btn_" .. btnType]
    local btnSelect = self.ui[string.format("btn_%s_select", btnType)]
    self:btRegisterButtonClick({
      button = btn,
      pressScale = 0.95,
      key = "btn_filter_" .. btnType,
      force = true,
      clickHandler = function()
        self:onClickBtnFilter(btnType)
      end,
      pressHandler = function()
        btnSelect:setVisible(true)
      end,
      cancelPressHandler = function()
        btnSelect:setVisible(self.selectFilterType == btnType)
      end
    })
  end
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("RealPvpBPBegin", function(msg)
    self:refreshTurn(msg)
  end)
  self:listenEvent("RealPvpBPEnd", function(msg)
    self:refreshBPEnd(msg)
  end)
  self:listenEvent("RealPvpReconnectReply", function(msg)
    self:refreshTurn(msg)
  end)
  self:listenEvent("RealPVPOpponentLost", function()
    ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\230\150\173\229\188\128\232\191\158\230\142\165\239\188\140\228\189\160\232\142\183\229\190\151\228\186\134\232\131\156\229\136\169\239\188\129"))
    self:listenTimer(Timer:Once(2), function()
      ed.popScene()
    end)
  end)
  self:listenEvent("RealPVPChatShow", function(data)
    self:showChatContent(data)
  end)
end

function class:roundEnd()
  if #self.selectHeroIdList ~= self.select_count_limit then
    ed.showToast(string.format(T("\232\175\183\233\128\137\230\139\169%s\228\184\170\232\139\177\233\155\132"), self.select_count_limit))
    return
  end
  if self.operateType == "ban" then
    self:reportHeroBan()
  elseif self.operateType == "pick" then
    self:reportHeroPick()
  end
end

function class:reportHeroBan()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_ban = ed.upmsg.pvp_ban()
  msg._pvp_ban._device_id = ed.my_device_id
  msg._pvp_ban._hero_ids = self.selectHeroIdList
  ed.socket_long_realarena.send(msg, "real_pvp")
  ed.realarena.network_mgr:ReplyProtection()
end

function class:reportHeroPick()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_pick = ed.upmsg.pvp_pick()
  msg._pvp_pick._device_id = ed.my_device_id
  msg._pvp_pick._hero_ids = self.selectHeroIdList
  ed.socket_long_realarena.send(msg, "real_pvp")
  ed.realarena.network_mgr:ReplyProtection()
end

function class:showChatContent(data)
  if nil == ed.realarena.mgr.hostUserSummary or nil == ed.realarena.mgr.guestUserSummary then
    return
  end
  local isBlue
  if data._role_id == ed.realarena.mgr.hostUserSummary._role_id then
    isBlue = true
  elseif data._role_id == ed.realarena.mgr.guestUserSummary._role_id then
    isBlue = false
  else
    return
  end
  local parent = isBlue and self.ui.player_info_blue or self.ui.player_info_red
  local worldPos = isBlue and self.ui.panel_head_icon_blue:convertToWorldSpace(ccp(35, 10)) or self.ui.panel_head_icon_red:convertToWorldSpace(ccp(-35, 10))
  ed.ui.KingsPvpChatSelectionWrap.createChatContent(parent, worldPos, data._chat_data, not isBlue)
end
