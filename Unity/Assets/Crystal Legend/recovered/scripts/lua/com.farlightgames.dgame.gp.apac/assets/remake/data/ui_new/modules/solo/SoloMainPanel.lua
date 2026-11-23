local base = ed.ui.popwindow
local SoloMainPanel = newclass(base.mt)
ed.ui.SoloMainPanel = SoloMainPanel

function SoloMainPanel:initLabels()
  ed.setLabelFontName(self.ui.label_heroname, ed.fontBold)
  ed.setLabelStroke(self.ui.label_heroname, ed.toccc3(1312776), 1)
  ed.setLabelDimensions(self.ui.label_common_tip, CCSizeMake(185, 0))
  ed.setLabelFontName(self.ui.label_tip_name, ed.fontBold)
  ed.setLabelFontName(self.ui.label_tip_type, ed.fontBold)
  ed.setLabelStroke(self.ui.label_tip_type, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.label_tip_name, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.Label_8431, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.Label_8431_Copy0, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.Label_12498, ed.toccc3(4402717), 1.5)
  ed.setLabelStroke(self.ui.Label_12498_Copy0, ed.toccc3(4402717), 1.5)
  for i = 1, 3 do
    ed.setLabelFontName(self.ui["label_tip_treasure" .. i], ed.fontBold)
    ed.setLabelFontName(self.ui["label_tip_treasure1" .. i], ed.fontBold)
    ed.setLabelFontName(self.ui["label_use_treasure" .. i], ed.fontBold)
    ed.setLabelStroke(self.ui["label_use_treasure" .. i], ed.toccc3(2056037), 1)
  end
  ed.setLabelShadow(self.ui.Label_001, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.Label_002, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.Label_003, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelFontName(self.ui.label_gold, ed.fontBold)
  ed.setLabelStroke(self.ui.label_gold, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.label_player_hp, ed.toccc3(1842204), 1.5)
  ed.setLabelStroke(self.ui.label_oppo_hp, ed.toccc3(1842204), 1.5)
  ed.setLabelFontName(self.ui.label_player_level, ed.fontBold)
  ed.setLabelStroke(self.ui.label_player_level, ccc3(0, 0, 0), 1)
  ed.setLabelFontName(self.ui.label_oppo_lv, ed.fontBold)
  ed.setLabelStroke(self.ui.label_oppo_lv, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_name_oppo, ed.toccc3(1842204), 1.5)
  ed.setLabelStroke(self.ui.label_name_player, ed.toccc3(1842204), 1.5)
  ed.setLabelFontName(self.ui.label_player_victory, ed.fontBold)
  ed.setLabelStroke(self.ui.label_player_victory, ed.toccc3(8591384), 1.5)
  ed.setLabelFontName(self.ui.label_oppo_victory, ed.fontBold)
  ed.setLabelStroke(self.ui.label_oppo_victory, ed.toccc3(8591384), 1.5)
  ed.setLabelFontName(self.ui.Label_313, ed.fontBold)
end

function SoloMainPanel:onClickPlayerItem(userkey)
  local stage = ed.SoloManager:getStage()
  if stage == ed.SoloManager.GAMESTAGE.BATTLE then
    if self.canChangeBattle then
      self:playBattle(userkey)
    else
      ed.showToast(T("\229\136\135\230\136\152\230\150\151\232\191\135\228\186\142\233\162\145\231\185\129"))
    end
  elseif stage == ed.SoloManager.GAMESTAGE.PREPARE then
    ed.SoloNetwork:sendMonitorPlayer(userkey._user_id, userkey._server_id)
  end
end

function SoloMainPanel:createPlayers()
  self.playerItemList = {}
  local playerList = ed.SoloModel:getPlayerList()
  for i, player in ipairs(playerList) do
    local userkey = player:getUserKey()
    local playerItem = ed.ui.SoloPlayerItem.create(player)
    local iconNode = playerItem:getRootNode()
    iconNode:setPosition(ccp(-13 + 58 * i, 39))
    self.ui.bg_top:addChild(iconNode, 2)
    self.playerItemList[userkey._user_id .. "_" .. userkey._server_id] = playerItem
    self:btRegisterButtonClick({
      button = iconNode,
      clickHandler = function()
        if player:getCurHp() <= 0 then
          ed.showToast(T("\232\175\165\231\142\169\229\174\182\229\183\178\232\162\171\230\183\152\230\177\176"))
          return
        end
        self:onClickPlayerItem(userkey)
      end,
      priority = -305,
      clickInterval = 0.5
    })
  end
end

function SoloMainPanel:updateBattlePlayerUI(groupId)
  self.ui.bg_watch2:setVisible(true)
  self.ui.bg_watch1:setVisible(false)
  for k, v in pairs(self.playerItemList) do
    local iconNode = v:getRootNode()
    iconNode:setPositionY(39)
  end
  local pos = 0
  local n = 0
  for i, playerItem in pairs(self.playerItemList) do
    if playerItem.soloPlayer:getBattleGroup() == groupId then
      local iconNode = playerItem:getRootNode()
      local posX = iconNode:getPositionX()
      iconNode:runAction(CCMoveTo:create(0.1, ccp(posX, 21)))
      pos = pos + posX
      n = n + 1
    end
  end
  if n == 2 then
    self.ui.bg_watch2:setPositionX(pos / 2)
  else
    self.ui.bg_watch2:setVisible(false)
    self.ui.bg_watch1:setVisible(true)
    self.ui.bg_watch1:setPositionX(pos)
  end
  self.ui.bg_bottom:runAction(CCMoveTo:create(0.15, ccp(484, self.bottomSrcY - 122)))
end

function SoloMainPanel:updatePowersUI(powers)
  local data = powers or ed.SoloModel:getPlayerPowers(ed.SkillPlayer.getMyUserKey()) or {}
  for i, power in ipairs(data) do
    self:updatePowerUI(power)
  end
end

function SoloMainPanel:updateHero(hero, factions, cards)
  local cardFactions = {}
  for k, v in pairs(factions or ed.SoloModel.factions) do
    if v.level > 0 then
      table.insert(cardFactions, {
        _faction = v.id,
        _level = v.level
      })
    end
  end
  ed.engine:clearAllSoloUnits()
  local curHero = hero or {
    _hid = ed.SoloModel:getHeroId(),
    _powers = ed.SoloModel:getPowers()
  }
  self.curHero = curHero
  ed.engine:onPrepareJoinBattle({
    camp = 1,
    hero = curHero,
    params = {
      _cards = cards or ed.SoloModel.allCardList,
      _card_factions = cardFactions
    }
  })
  self:refreshPlayerAttr()
end

function SoloMainPanel:getFactionsFromTeam(data)
  local factions = {}
  for k, v in pairs(ed.SoloModel.factions) do
    factions[k] = ed.SoloFaction.create(k)
  end
  for k, card in ipairs(data._cards or {}) do
    local cid = card._cid
    local tbData = ed.getDataTable("SoloCardSkill")[cid]
    if tbData.Tag1 ~= 0 then
      factions[tbData.Tag1]:addCard(card)
    end
    if tbData.Tag2 ~= 0 then
      factions[tbData.Tag2]:addCard(card)
    end
  end
  for k, v in ipairs(data._factions or {}) do
    factions[v._faction].exp = v._exp
    factions[v._faction].level = v._level
  end
  return factions
end

function SoloMainPanel:refreshPanel()
end

function SoloMainPanel:watchPlayer(userKey, data)
  self.ui.bg_watch1:setVisible(true)
  self.ui.bg_watch2:setVisible(false)
  if self.watchUserKey then
    if self.watchUserKey == userKey then
      return
    else
      local playerItem = self.playerItemList[self.watchUserKey._user_id .. "_" .. self.watchUserKey._server_id]
      playerItem:getRootNode():runAction(CCMoveTo:create(0.1, ccp(playerItem:getRootNode():getPositionX(), 39)))
    end
  end
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    local iconNode = playerItem:getRootNode()
    local posX, posY = iconNode:getPosition()
    self.watchUserKey = userKey
    iconNode:runAction(CCMoveTo:create(0.1, ccp(posX, 21)))
    self.ui.bg_watch1:setPositionX(posX)
  end
  self.changeBattleFca:setAction("Start")
  if not data then
    self:updatePowersUI()
    self:createFactions()
    self.ui.bg_gold:setVisible(true)
    ed.setString(self.ui.label_player_level, ed.SoloModel:getMySelfLevel())
    self.isSelfPanel = true
    ed.setTexture(self.ui.player_hp_bar, "UI/alpha/1080P/chesscard/green_2.png")
    ed.setLabelColor(self.ui.label_name_player, ed.toccc3(16764532))
    ed.setString(self.ui.label_name_player, " ")
    if ed.SoloModel:getHeroId() then
      self:updateHero()
    end
    return
  else
    FireEvent("EventCloseOtherWin")
    self:updatePowersUI(data._powers)
    local factions = self:getFactionsFromTeam(data._team)
    local myUserKey = ed.SkillPlayer:getMyUserKey()
    ed.setString(self.ui.label_player_level, data._user_summary._level)
    ed.setString(self.ui.label_name_player, data._user_summary._user_summary._name or "NickName")
    self:updateHero(data._team._hero, factions, data._team._cards)
    if myUserKey._user_id == userKey._user_id and myUserKey._server_id == userKey._server_id then
      self:createFactions(factions)
      self.ui.bg_gold:setVisible(true)
      if ed.SoloManager:getStage() == ed.SoloManager.GAMESTAGE.PREPARE then
        self:showChessShop()
      end
      self.isSelfPanel = true
      ed.setTexture(self.ui.player_hp_bar, "UI/alpha/1080P/chesscard/green_2.png")
      ed.setLabelColor(self.ui.label_name_player, ed.toccc3(16764532))
    else
      ed.setTexture(self.ui.player_hp_bar, "UI/alpha/1080P/chesscard/red_2.png")
      ed.setLabelColor(self.ui.label_name_player, ed.toccc3(16776423))
      self:createFactions(factions)
      self.ui.bg_gold:setVisible(false)
      self.isSelfPanel = false
    end
  end
end

function SoloMainPanel:popLantern(str)
  local bg = ed.createSprite("UI/alpha/1080P/common/notice_bg.png")
  bg:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height - 60 - math.min(4, self.playingLanterns) * 22))
  bg:setCascadeOpacityEnabled(true)
  ed.getCurrentScene().getTopNode():addChild(bg, 999)
  local autoText = ed.ui.autoText.new()
  local detailText = str
  autoText:initParam({
    context = detailText,
    fontSize = 16,
    fontColor = ccc3(255, 255, 255),
    strokeColor = ed.toccc3(2057010),
    strokeSize = 1,
    maxWidth = 500
  })
  bg:addChild(autoText.node, 1)
  ed.layout.centerInParent(autoText.node)
  local width, height = autoText:getCurContentSize()
  local posX, posY = autoText.node:getPosition()
  autoText.node:setPosition(ccp(posX - width / 2, posY + 2))
  bg:setOpacity(0)
  bg:setScale(0.65)
  local action1 = CCSpawn:create(ccArrayMake({
    CCEaseSineIn:create(CCFadeIn:create(0.2)),
    CCEaseSineIn:create(CCScaleTo:create(0.2, 1.06))
  }))
  local action2 = CCEaseSineOut:create(CCScaleTo:create(0.3, 1))
  local action3 = CCDelayTime:create(0.25)
  local action4 = CCSpawn:create(ccArrayMake({
    CCFadeOut:create(1.1),
    CCMoveBy:create(1.1, ccp(0, 60))
  }))
  local action5 = CCCallFunc:create(function()
    bg:removeFromParentAndCleanup(true)
    self.playingLanterns = self.playingLanterns - 1
  end)
  local sequence = CCSequence:create(ccArrayMake(action1, action2, action3, action4, action5))
  bg:runAction(sequence)
  self.playingLanterns = self.playingLanterns + 1
end

function SoloMainPanel:initTreasureRound()
  local roundIndex = {}
  for k, v in ipairs(ed.getDataTable("ChessRound")) do
    if v.HeroPowerAction == "choose" then
      table.insert(roundIndex, k)
    end
  end
  for i = 1, 3 do
    ed.setString(self.ui["label_tip_treasure" .. i], roundIndex[i])
  end
end

function SoloMainPanel:initHpAndMpBar()
  local progressHpPlayer = CCProgressTimer:create(self.ui.player_hp_bar)
  progressHpPlayer:setType(kCCProgressTimerTypeBar)
  progressHpPlayer:setMidpoint(ccp(0, 0.5))
  progressHpPlayer:setBarChangeRate(ccp(1, 0))
  self.ui.bg_player_hp_bar:addChild(progressHpPlayer)
  self.ui.player_hp_bar:setVisible(false)
  ed.layout.centerInParent(progressHpPlayer)
  self.progressHpPlayer = progressHpPlayer
  self.progressHpPlayer:setPercentage(99.99)
  local progressMpPlayer = CCProgressTimer:create(self.ui.player_mp_bar)
  progressMpPlayer:setType(kCCProgressTimerTypeBar)
  progressMpPlayer:setMidpoint(ccp(0, 0.5))
  progressMpPlayer:setBarChangeRate(ccp(1, 0))
  self.ui.bg_player_mp_bar:addChild(progressMpPlayer)
  self.ui.player_mp_bar:setVisible(false)
  ed.layout.centerInParent(progressMpPlayer)
  self.progressMpPlayer = progressMpPlayer
  self.progressMpPlayer:setPercentage(0)
  local progressHpOppo = CCProgressTimer:create(self.ui.oppo_hp_bar)
  progressHpOppo:setType(kCCProgressTimerTypeBar)
  progressHpOppo:setMidpoint(ccp(1, 0.5))
  progressHpOppo:setBarChangeRate(ccp(1, 0))
  self.ui.bg_oppo_hp_bar:addChild(progressHpOppo)
  self.ui.oppo_hp_bar:setVisible(false)
  ed.layout.centerInParent(progressHpOppo)
  self.progressHpOppo = progressHpOppo
  self.progressHpOppo:setPercentage(99.99)
  local progressMpOppo = CCProgressTimer:create(self.ui.oppo_mp_bar)
  progressMpOppo:setType(kCCProgressTimerTypeBar)
  progressMpOppo:setMidpoint(ccp(1, 0.5))
  progressMpOppo:setBarChangeRate(ccp(1, 0))
  self.ui.bg_oppo_mp_bar:addChild(progressMpOppo)
  self.ui.oppo_mp_bar:setVisible(false)
  ed.layout.centerInParent(progressMpOppo)
  self.progressMpOppo = progressMpOppo
  self.progressMpOppo:setPercentage(0)
end

function SoloMainPanel:initUI()
  ed.editorui(ed.uieditor.SoloMainPanel, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:adaptUI()
  self:initHpAndMpBar()
  self:initTreasureRound()
  self:createFactions()
  self:createPlayers()
  local marquee = ed.SoloMarqueeManager
  marquee:init({
    container = self.mainLayer
  })
  marquee:start()
  self.changeBattleFca = ed.createFcaNode("eff_UI_transition_smoke")
  self.mainLayer:addChild(self.changeBattleFca, 999)
  ed.layout.centerInScreen(self.changeBattleFca)
  self:addFca(self.changeBattleFca)
end

function SoloMainPanel:updateGold()
  local curGold = ed.SoloModel:getTotalGold()
  ed.setString(self.ui.label_gold, ed.SoloModel:getTotalGold())
  if curGold > self.preGold then
    if not self.getGoldFca then
      self.getGoldFca = ed.createFcaNode("eff_UI_solo_gold_gain")
      self.getGoldFca:setPosition(ccp(50, 4))
      self.ui.Panel_9728:addChild(self.getGoldFca, 1)
      self:addFca(self.getGoldFca)
    else
      self.getGoldFca:setAction("Start")
    end
  end
  self.preGold = curGold
end

function SoloMainPanel:initStageInfo()
  local round = ed.SoloModel:getBattleRound()
  ed.engine:clearAllSoloUnits()
  if ed.SoloModel:getHeroId() then
    ed.engine:onPrepareJoinBattle({
      camp = 1,
      hero = {
        _hid = ed.SoloModel:getHeroId(),
        _powers = ed.SoloModel:getPowers()
      },
      params = {
        _cards = ed.SoloModel.allCardList,
        _card_factions = ed.SoloModel:getAllFactions()
      }
    })
    self:refreshPlayerAttr()
  end
end

function SoloMainPanel:showChessShop()
  FireEvent("EventCloseOtherWin")
  if self.selfUnit then
    self.selfUnit.position = {100, -30}
  end
  local pos = ed.toViewPosition({100, -30}, 0)
  pos = ccpAdd(pos, ccp(-ed.display.halfFixedWidth, -ed.display.halfFixedHeight))
  self.ui.bg_player_panel:setPosition(ccpAdd(ccp(-80, -85), pos))
  ed.ui.SoloShopWindow.create({
    destroyHandler = function()
      if self.selfUnit then
        self.selfUnit.position = {235, -30}
      end
      local pos = ed.toViewPosition({235, -30}, 0)
      pos = ccpAdd(pos, ccp(-ed.display.halfFixedWidth, -ed.display.halfFixedHeight))
      self.ui.bg_player_panel:setPosition(ccpAdd(ccp(-80, -85), pos))
    end
  }):popWindow()
end

function SoloMainPanel:updatePlayerItems()
  local playerList = ed.SoloModel:getPlayerList()
  for k, player in ipairs(playerList) do
    local userkey = player:getUserKey()
    local playerItem = self.playerItemList[userkey._user_id .. "_" .. userkey._server_id]
    if playerItem then
      local iconNode = playerItem:getRootNode()
      playerItem:updateHp()
      playerItem:updateDamage()
      playerItem:updateSpriteStone()
      iconNode:setPosition(ccp(-17 + 58 * k, iconNode:getPositionY()))
    end
  end
end

function SoloMainPanel:onEventChessWaitChoose()
  self.stageTip:onRoundStageTip("choose")
  self.stageTip:startTimer()
end

function SoloMainPanel:closeBattleUI()
  self.ui.bg_oppo_panel:setVisible(false)
  self.dataPanel:closePanel()
  self.watchGroupId = nil
  for k, v in pairs(self.playerItemList) do
    local iconNode = v:getRootNode()
    iconNode:setPositionY(39)
  end
  if self.winRoundFca then
    self.winRoundFca:setVisible(false)
  end
  if self.winResultSpin then
    self.winResultSpin:setVisible(false)
  end
  if self.loseResultSpin then
    self.loseResultSpin:setVisible(false)
  end
  for k, v in pairs(self.playerItemList) do
    v:stopResultShow()
  end
end

function SoloMainPanel:getDefaultWatchKey()
  if ed.SoloModel:isMySelfDead() then
    if self.watchUserKey and not ed.SkillPlayer.isUserKeyEqual(self.watchUserKey, ed.SkillPlayer.getMyUserKey()) and self.playerItemList[self.watchUserKey._user_id .. "_" .. self.watchUserKey._server_id]:isAlive() then
      return self.watchUserKey
    end
    return ed.SoloModel:getPlayerList()[1]:getUserKey()
  else
    return ed.SkillPlayer:getMyUserKey()
  end
end

function SoloMainPanel:onEventChessRoundStart()
  self.canClickData = false
  self.stageTip:onRoundStageTip("start")
  self.stageTip:startTimer()
  self:closeBattleUI()
  self:updateGold()
  if ed.SoloModel:getCombo() >= 0 then
    ed.setTexture(self.ui.ImageView_312, "UI/alpha/1080P/chesscard/victory.png")
    ed.setLabelColor(self.ui.Label_313, ccc3(255, 225, 67))
    ed.setLabelStroke(self.ui.Label_313, ed.toccc3(8591384), 1.5)
    ed.setString(self.ui.Label_313, math.abs(ed.SoloModel:getCombo()) .. T("\232\191\158\232\131\156"))
  else
    ed.setTexture(self.ui.ImageView_312, "UI/alpha/1080P/chesscard/lose.png")
    ed.setLabelColor(self.ui.Label_313, ed.toccc3(13226205))
    ed.setLabelStroke(self.ui.Label_313, ed.toccc3(5065586), 1.5)
    ed.setString(self.ui.Label_313, math.abs(ed.SoloModel:getCombo()) .. T("\232\191\158\232\180\165"))
  end
  self.watchGroupId = nil
  local key = self:getDefaultWatchKey()
  if ed.SkillPlayer.isUserKeyEqual(key, ed.SkillPlayer.getMyUserKey()) then
    self:watchPlayer(key)
  else
    ed.SoloNetwork:sendMonitorPlayer(key._user_id, key._server_id)
  end
  self.ui.bg_bottom:runAction(CCMoveTo:create(0.15, ccp(484, self.bottomSrcY)))
end

function SoloMainPanel:onEventChessRoundPrepare()
  self.stageTip:onRoundStageTip("prepare")
  self.stageTip:startTimer()
  if not ed.SoloModel:isMySelfDead() then
    self:showChessShop()
  end
  self.ui.icon_player_attr5:setVisible(false)
  self.ui.icon_player_attr6:setVisible(false)
  self.ui.icon_player_attr7:setVisible(false)
end

function SoloMainPanel:onEventChessRoundWait()
  self.stageTip:onRoundStageTip("wait")
  self.stageTip:startTimer()
end

function SoloMainPanel:onEventChessRoundLock()
  self.stageTip:onRoundStageTip("lock")
  self.stageTip:startTimer()
  FireEvent("EventCloseOtherWin")
end

function SoloMainPanel:onEventSoloBattleCheckEnd(winCamp)
  self:refreshOppoAttr()
  self:refreshPlayerAttr()
  self.dataPanel:update()
  if not self.winRoundFca then
    self.winRoundFca = ed.createFcaNode("eff_UI_solo_victory_ribbon")
    self.mainLayer:addChild(self.winRoundFca, 10)
    self:addFca(self.winRoundFca)
  end
  self.winRoundFca:setVisible(true)
  self.winRoundFca:setAction("Start")
  if self.selfInBattleCamp then
    if self.selfInBattleCamp == winCamp then
      if not self.winResultSpin then
        self.winResultSpin = ed.createSpine("effect/eff_UI_solo_win_light/eff_UI_solo_win_light", 0.5)
        self.mainLayer:addChild(self.winResultSpin, 10)
        ed.layout.centerInScreen(self.winResultSpin)
        self.winResultSpin:setAnimation(0, "Start", false)
        self.winResultSpin:addAnimation(0, "Loop", true)
      end
    elseif not self.loseResultSpin then
      self.loseResultSpin = ed.createSpine("effect/eff_UI_solo_fail_light/eff_UI_solo_fail_light", 0.5)
      self.mainLayer:addChild(self.loseResultSpin, 10)
      ed.layout.centerInScreen(self.loseResultSpin)
      self.loseResultSpin:setAnimation(0, "Start", false)
      self.loseResultSpin:addAnimation(0, "Loop", true)
    end
  end
  if winCamp == 1 then
    ed.layout.relateLayout(self.selfUnit.actor.node, self.winRoundFca, {top = 1})
  else
    ed.layout.relateLayout(self.oppoUnit.actor.node, self.winRoundFca, {top = 1})
  end
end

function SoloMainPanel:stopAllsoloPlayerBattle()
  for _, playerItem in pairs(self.playerItemList) do
    playerItem:stopBattleEffect()
  end
end

function SoloMainPanel:onEventChessRoundOver()
  self.stageTip:onRoundStageTip("over")
  self.stageTip:startTimer()
  self:stopAllsoloPlayerBattle()
  self.battleScene:setSpeedRate(1)
  self:updateGold()
end

function SoloMainPanel:doLogClick()
  ed.ui.SoloRecordWin.create()
  ed.SoloNetwork:sendViewJournal(#ed.SoloModel.logs)
end

function SoloMainPanel:play1stAnim()
  local spine1 = ed.createSpine("effect/eff_UI_solo_no1_ribbon1/eff_UI_solo_no1_ribbon1", 0.5)
  spine1:setAnimation(0, "Start", false)
  spine1:addAnimation(0, "Loop", true)
  self.mainLayer:addChild(spine1, 10)
  ed.layout.centerInScreen(spine1)
  local spine2 = ed.createSpine("effect/eff_UI_solo_no1_ribbon2/eff_UI_solo_no1_ribbon2", 0.5)
  spine2:setAnimation(0, "Start", true)
  self.mainLayer:addChild(spine2, 10)
  ed.layout.centerInScreen(spine2)
  local spine3 = ed.createSpine("effect/eff_UI_solo_no1_ribbon3/eff_UI_solo_no1_ribbon3", 0.5)
  spine3:setAnimation(0, "Start", false)
  spine3:addAnimation(0, "Loop", true)
  self.mainLayer:addChild(spine3, 10)
  ed.layout.centerInScreen(spine3)
end

function SoloMainPanel:doAllInfoClick()
  ed.ui.SoloTabWin.create()
end

function SoloMainPanel:showBattleLeft(powers)
  if ed.SoloManager:getStage() == ed.SoloManager.GAMESTAGE.BATTLE then
    if not self.record or not self.record._battle then
      return
    end
    self.ui.bg_bottom:runAction(CCMoveTo:create(0.15, ccp(484, self.bottomSrcY)))
    self:updatePowersUI(powers)
    self.curHero = self.record._battle._self_team._hero
    self:initSkillIcons(self.battleLeftHeroId)
    self:initIconAndName(self.battleLeftHeroId)
    local factions = self:getFactionsFromTeam(self.record._battle._self_team)
    self:createFactions(factions)
  end
end

function SoloMainPanel:onClickLeftHero()
  if ed.SoloManager:getStage() == ed.SoloManager.GAMESTAGE.BATTLE then
    if not self.record or not self.record._battle then
      return
    end
    self.isClickRightHero = false
    local leftUserKey = self.record._battle._self_user._user_key
    ed.SoloNetwork:sendMonitorPlayer(leftUserKey._user_id, leftUserKey._server_id)
  end
end

function SoloMainPanel:showBattleRight(powers)
  if ed.SoloManager:getStage() == ed.SoloManager.GAMESTAGE.BATTLE then
    if not self.record or not self.record._battle then
      return
    end
    self.ui.bg_bottom:runAction(CCMoveTo:create(0.15, ccp(484, self.bottomSrcY)))
    self:updatePowersUI(powers)
    self.curHero = self.record._battle._oppo_team._hero
    self:initSkillIcons(self.battleRightHeroId)
    self:initIconAndName(self.battleRightHeroId)
    local factions = self:getFactionsFromTeam(self.record._battle._oppo_team)
    self:createFactions(factions)
  end
end

function SoloMainPanel:onClickRightHero()
  if ed.SoloManager:getStage() == ed.SoloManager.GAMESTAGE.BATTLE then
    if not self.record or not self.record._battle then
      return
    end
    self.isClickRightHero = true
    local rightUserKey = self.record._battle._oppo_user._user_key
    ed.SoloNetwork:sendMonitorPlayer(rightUserKey._user_id, rightUserKey._server_id)
  end
end

function SoloMainPanel:registerTouchEvents()
  ed.UITool.registerBtn(self, "bg_gold", function()
    local goldPanel = ed.ui.SoloGoldTip.create()
    ed.layout.relateLayout(self.ui.bg_gold, goldPanel.ui.bg, {bottom = 150, left = 20}, true)
  end, {pressScale = 0.99})
  ed.UITool.registerBtn(self, "Panel_905", function()
    local panel = ed.ui.SoloAttrTip.create()
    ed.layout.relateLayout(self.ui.Panel_905, panel.ui.bg, {right = 83, top = 150}, true)
  end, {pressScale = 0.99})
  ed.UITool.registerBtn(self, "Panel_906", function()
    local panel = ed.ui.SoloAttrTip.create()
    ed.layout.relateLayout(self.ui.Panel_906, panel.ui.bg, {right = 83, top = 150}, true)
  end, {pressScale = 0.99})
  ed.UITool.registerBtn(self, "Panel_9728", function()
    self:onClickLeftHero()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "Panel_9729", function()
    self:onClickRightHero()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_log", function()
    self:doLogClick()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_all_info", function()
    self:doAllInfoClick()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_quit", function()
    self:doClickQuit()
  end)
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.SoloArenaRule.create():popWindow()
  end)
end

function SoloMainPanel:onEventChessRoundBattle()
  self.canClickData = true
  self.stageTip:onRoundStageTip("battle")
  self.stageTip:startTimer()
  FireEvent("EventCloseOtherWin")
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.SoloManager:setBtStartTime()
  self.eventTick = 0
  self.realTime = 0
  self.ticks = 0
  self.ui.bg_oppo_panel:setVisible(true)
  self.ui.bg_bottom:runAction(CCMoveTo:create(0.15, ccp(484, self.bottomSrcY - 122)))
  self.watchGroupId = nil
  self:playBattle(self:getDefaultWatchKey(), true)
  self.ui.icon_player_attr5:setVisible(true)
  self.ui.icon_player_attr6:setVisible(true)
  self.ui.icon_player_attr7:setVisible(true)
end

function SoloMainPanel:updatePlayerAndOppo(battleData)
  ed.setString(self.ui.label_oppo_lv, battleData._oppo_user._level)
  ed.setString(self.ui.label_name_oppo, battleData._oppo_user._user_summary._name or "NickName")
  ed.setString(self.ui.label_player_level, battleData._self_user._level)
  ed.setString(self.ui.label_name_player, battleData._self_user._user_summary._name or "NickName")
  if ed.SoloManager:isMemberEqual(ed.SkillPlayer.getMyUserKey(), battleData._self_user._user_key) then
    ed.setTexture(self.ui.player_hp_bar, "UI/alpha/1080P/chesscard/green_2.png")
    ed.setLabelColor(self.ui.label_name_player, ed.toccc3(16764532))
    self.selfInBattleCamp = 1
  else
    ed.setTexture(self.ui.player_hp_bar, "UI/alpha/1080P/chesscard/red_2.png")
    ed.setLabelColor(self.ui.label_name_player, ed.toccc3(16776423))
  end
  if ed.SoloManager:isMemberEqual(ed.SkillPlayer.getMyUserKey(), battleData._oppo_user._user_key) then
    ed.setTexture(self.ui.oppo_hp_bar, "UI/alpha/1080P/chesscard/green_2.png")
    ed.setLabelColor(self.ui.label_name_oppo, ed.toccc3(16764532))
    self.selfInBattleCamp = -1
  else
    ed.setTexture(self.ui.oppo_hp_bar, "UI/alpha/1080P/chesscard/red_2.png")
    ed.setLabelColor(self.ui.label_name_oppo, ed.toccc3(16776423))
  end
end

function SoloMainPanel:preBattleCheck(battleData)
  ed.run_with_scene = false
  ed.pre_check_battle = true
  ed.srand(battleData._rseed)
  ed.engine:enterSoloCheck(battleData)
  local tick = ed.engine:getEndTick()
  local battleResult = ed.engine:checkBattleResult()
  local battleTime = tick * ed.tick_interval
  local waitTime = battleTime
  if 20 < battleTime then
    waitTime = 20 + (battleTime - 20) * 0.5
  end
  self.confirmTimer = self:listenTimer(Timer:Once(waitTime), function()
    ed.SoloNetwork:sendChessBattleConfirm(battleResult, math.ceil(waitTime * 1000), ed.SoloModel:getBattleRound())
  end)
  ed.run_with_scene = true
  ed.pre_check_battle = false
end

function SoloMainPanel:playBattle(userKey, battleCheck)
  local playerUI = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  local groupId = playerUI.soloPlayer:getBattleGroup()
  if self.watchGroupId == groupId then
    return
  end
  local record = ed.SoloManager.recordDatas[groupId]
  if record == nil then
    ed.showToast(T("\230\136\152\230\150\151\230\149\176\230\141\174\228\184\162\229\164\177"))
    return
  else
    self.canChangeBattle = false
    self.changeBattleFca:setAction("Start")
    self:listenTimer(Timer:Once(2), function()
      self.canChangeBattle = true
    end)
    self.record = record
  end
  self:updateBattlePlayerUI(groupId)
  if self.winRoundFca then
    self.winRoundFca:setVisible(false)
  end
  if self.winResultSpin then
    self.winResultSpin:setVisible(false)
  end
  if self.loseResultSpin then
    self.loseResultSpin:setVisible(false)
  end
  self.watchGroupId = groupId
  local battleData = record._battle
  self.selfInBattleCamp = nil
  self:updatePlayerAndOppo(battleData)
  if battleCheck then
    self:preBattleCheck(battleData)
  end
  ed.scene:setSpeedRate(1)
  ed.srand(battleData._rseed)
  ed.engine:enterSoloCheck(battleData)
  self.battleLeftHeroId = battleData._self_team._hero._hid
  self.battleRightHeroId = battleData._oppo_team._hero._hid
  ed.SoloModel:resetBattleDataList(self.battleLeftHeroId, self.battleRightHeroId)
  ed.run_with_scene = false
  ed.engine:jumpToTick(self.ticks)
  ed.run_with_scene = true
  self.dataPanel:onBattleStart()
  self:refreshOppoAttr()
  self:refreshPlayerAttr()
  self.dataPanel:update()
end

function SoloMainPanel:startSoloPlayerBattle(userKey)
  if type(userKey) ~= "table" then
    return
  end
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    playerItem:showBattleEffect()
    local groupId = playerItem.soloPlayer:getBattleGroup()
    local record = ed.SoloManager.recordDatas[groupId]
    if record then
      local battleData = record._battle
      if battleData._oppo_type == "player_mirror" then
        playerItem:showMirror()
      end
    end
  end
end

function SoloMainPanel:updatePlayerIcon(userKey)
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    playerItem:updateIcon()
  end
end

function SoloMainPanel:updatePlayerHp(userKey)
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    playerItem:updateHp()
  end
end

function SoloMainPanel:stopSoloPlayerBattle(userKey, isHurt, diffHp, result)
  if type(userKey) ~= "table" then
    return
  end
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    playerItem:stopBattleEffect()
    playerItem:showHurtEffect(isHurt, diffHp, result)
  end
end

function SoloMainPanel:onEventSoloPlayerDead()
  ed.engine:clearAllSoloUnits()
end

function SoloMainPanel:onEventEnterBackground()
  if self.confirmTimer then
    CloseTimer(self.confirmTimer.name)
    self.confirmTimer = nil
  end
end

function SoloMainPanel:onEventEnterForeground()
  if not ed.getUserid() then
    return
  end
  ed.socket_long_solo.recv()
  ed.SoloNetwork:checkReconnect()
  ed.SoloNetwork:createHeartBeat()
end

function SoloMainPanel:onEventChessJoinGame()
  self:createPlayers()
end

function SoloMainPanel:refreshPlayerAttr()
  if self.selfUnit then
    local attribs = self.selfUnit.attribs
    self.ui.label_player_attr1:setString(attribs.AD or 0)
    self.ui.label_player_attr2:setString(self.selfUnit.nPerSecond or 1)
    self.ui.label_player_attr3:setString(math.min(70, attribs.CRIT or 0))
    self.ui.label_player_attr4:setString(math.min(70, attribs.DODG or 0))
    self.ui.label_player_attr5:setString(self.selfUnit.drugValue or 0)
    if 0 < self.selfUnit.frozenValue then
      self.ui.label_player_attr6:setString(self.selfUnit.frozenValue or 0)
      ed.setTexture(self.ui.icon_player_attr6, "UI/alpha/1080P/chesscard/4.png")
    elseif 0 < self.selfUnit.hasteValue then
      self.ui.label_player_attr6:setString(self.selfUnit.hasteValue or 0)
      ed.setTexture(self.ui.icon_player_attr6, "UI/alpha/1080P/chesscard/11.png")
    else
      self.ui.label_player_attr6:setString(0)
    end
    if 0 < self.selfUnit.shieldValue then
      ed.setTexture(self.ui.icon_player_attr7, "UI/alpha/1080P/chesscard/9.png")
    elseif 0 > self.selfUnit.shieldValue then
      ed.setTexture(self.ui.icon_player_attr7, "UI/alpha/1080P/chesscard/12.png")
    end
    local shieldValue = math.abs(math.floor(self.selfUnit.shieldValue)) or 0
    self.ui.label_player_attr7:setString(shieldValue)
    ed.setString(self.ui.label_player_hp, string.format("%d/%d", self.selfUnit.hp, attribs.HP))
    local percentHp = self.selfUnit.hp / attribs.HP * 100
    local percentMp = self.selfUnit.mp / attribs.MP * 100
    if self.preHpPercent ~= percentHp then
      self.progressHpPlayer:stopAllActions()
      self.progressHpPlayer:runAction(CCProgressFromTo:create(0.3, self.preHpPercent or 100, percentHp))
      self.preHpPercent = percentHp
    end
    if self.preMpPercent ~= percentMp then
      self.progressMpPlayer:stopAllActions()
      self.progressMpPlayer:runAction(CCProgressFromTo:create(0.3, self.preMpPercent or 100, percentMp))
      self.preMpPercent = percentMp
    end
  end
end

function SoloMainPanel:onEffectUpdateHP(userKey, hp, power)
  self:updatePlayerHp(userKey)
  if power and ed.SoloManager:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
    local name = ed.getDataTable("SoloPower")[power._id]["HeroPower Name"]
    local t1 = hp._mod_hp > 0 and T("\230\129\162\229\164\141") or T("\229\164\177\229\142\187")
    local content = string.format(T("<lable color=headlineYellow>%s</lable>\232\167\166\229\143\145:%s%d\231\130\185\231\148\159\229\145\189\229\128\188"), name, t1, math.abs(hp._mod_hp))
    FireEvent("SoloPopLantern", content)
  end
end

function SoloMainPanel:onEffectUpdateGold(gold, power)
  self:updateGold()
  if power then
    local name = ed.getDataTable("SoloPower")[power._id]["HeroPower Name"]
    local t1 = 0 < gold and T("\229\162\158\229\138\160") or T("\229\164\177\229\142\187")
    local content = string.format(T("<lable color=headlineYellow>%s</lable>\232\167\166\229\143\145:%s%d\230\158\154\233\135\145\229\184\129"), name, t1, math.abs(gold))
    FireEvent("SoloPopLantern", content)
  end
end

function SoloMainPanel:onPopEffectCard(power, card)
  local name = ed.getDataTable("SoloPower")[power._id]["HeroPower Name"]
  local cardTb = ed.getDataTable("SoloCardSkill")[card._cid]
  local cardName = cardTb.Name
  local content
  if cardTb.Tag2 and cardTb.Tag2 ~= 0 then
    local tag1Name = ed.getDataTable("SoloCardTag")[cardTb.Tag1].Name
    local tag2Name = ed.getDataTable("SoloCardTag")[cardTb.Tag2].Name
    content = string.format(T("<lable color=headlineYellow>%s</lable>\232\167\166\229\143\145:\232\142\183\229\190\151\227\128\144%s\227\128\145%s %s"), name, cardName, tag1Name, tag2Name)
  else
    local tag1Name = ed.getDataTable("SoloCardTag")[cardTb.Tag1].Name
    content = string.format(T("<lable color=headlineYellow>%s</lable>\232\167\166\229\143\145:\232\142\183\229\190\151\227\128\144%s\227\128\145%s"), name, cardName, tag1Name)
  end
  FireEvent("SoloPopLantern", content)
end

function SoloMainPanel:onLevelUp(id)
  if self.selfUnit then
    local unit = self.selfUnit
    unit:reset()
    ed.engine:initSoloModeAttribs(unit, {
      _cards = ed.SoloModel.allCardList,
      _card_factions = ed.SoloModel:getAllFactions()
    })
    unit.state = ed.emUnitStateBase
    unit:setAction("Cheer", false)
    self:listenTimer(Timer:Once(1.5), function()
      unit:setAction("Idle", true)
    end)
    if not self.levelUpFca then
      local sprFront = ed.createFcaNode("eff_UI_hero_upgrade_2")
      self.mainLayer:addChild(sprFront)
      ed.layout.relateLayout(unit.actor.node, sprFront, {top = 1})
      self.levelUpFca = sprFront
      self:addFca(sprFront)
    else
      self.levelUpFca:setAction("Start")
    end
    self:refreshPlayerAttr()
  end
  ed.setString(self.ui.label_player_level, ed.SoloModel:getMySelfLevel())
end

function SoloMainPanel:showChatContent(data)
  local userKey = data._user_key
  local key = userKey._user_id .. "_" .. userKey._server_id
  local playerItem = self.playerItemList[key]
  if nil == playerItem then
    return
  end
  if nil == self.playerChatNodeTab then
    self.playerChatNodeTab = {}
  end
  local playerChatNode = self.playerChatNodeTab[key]
  if playerChatNode then
    playerChatNode:removeFromParentAndCleanup(true)
  end
  playerChatNode = CCNode:create()
  self.playerChatNodeTab[key] = playerChatNode
  local playerNode = playerItem:getRootNode()
  local posX, posY = playerNode:getPosition()
  self.ui.bg_top:addChild(playerChatNode, 99)
  playerChatNode:setPosition(ccp(posX, posY - 5))
  ed.ui.KingsPvpChatSelectionWrap.createChatContent(playerChatNode, playerChatNode:convertToWorldSpace(ccp(0, 0)), data._content, true)
end

function SoloMainPanel:registerEvents()
  self:listenEvent("SoloChatContentNotify", function(data)
    self:showChatContent(data)
  end)
  self:listenEvent("SoloPlay1stAnim", function()
    self:play1stAnim()
  end)
  self:listenEvent("SoloMonitorPlayer", function(msg)
    local stage = ed.SoloManager:getStage()
    if stage == ed.SoloManager.GAMESTAGE.BATTLE then
      if self.isClickRightHero then
        self:showBattleRight(msg._powers)
      else
        self:showBattleLeft(msg._powers)
      end
    elseif stage == ed.SoloManager.GAMESTAGE.PREPARE then
      local userKey = msg._user_summary._user_key
      self:watchPlayer(userKey, msg)
    end
  end)
  self:listenEvent("EffectUpdatePlayerHP", function(userKey, hp, power)
    self:onEffectUpdateHP(userKey, hp, power)
  end)
  self:listenEvent("EffectUpdatePlayerGold", function(gold, power)
    self:onEffectUpdateGold(gold, power)
  end)
  self:listenEvent("EffectGainCard", function(card, power)
    if power then
      self:onGetCard(card)
      self:onPopEffectCard(power, card)
    end
  end)
  self:listenEvent("EffectUpdateFactionExp", function(factionId, exp, power)
    if power then
      local name = ed.getDataTable("SoloPower")[power._id]["HeroPower Name"]
      local t1 = ed.getDataTable("SoloCardTag")[factionId].Name
      local content = string.format(T("<lable color=headlineYellow>%s</lable>\232\167\166\229\143\145:\229\162\158\229\138\160%s%d\231\130\185\231\187\143\233\170\140"), name, t1, exp)
      FireEvent("SoloPopLantern", content)
    end
  end)
  self:listenEvent("SoloUpdatePlayerIcon", function(userKey)
    self:updatePlayerIcon(userKey)
  end)
  self:listenEvent("SoloPopLantern", function(data)
    self:popLantern(data)
  end)
  self:listenEvent("SkillUpdateSelfPower", function(data)
    self:updatePowerUI(data)
  end)
  self:listenEvent("SoloWaitChoose", function()
    self:onEventChessWaitChoose()
  end)
  self:listenEvent("SoloPopChooseHero", function(data)
    ed.SoloManager.actionData = nil
    self:updatePlayerIcon(ed.SkillPlayer:getMyUserKey())
    FireEvent("EventCloseOtherWin")
    ed.ui.SoloSelectHeroWin.create(data)
  end)
  self:listenEvent("SoloBattleHeroJoin", function(unit, camp)
    if camp == -1 then
      self.oppoUnit = unit
    else
      self.selfUnit = unit
      self.ui.bg_player_panel:setVisible(true)
      self:initSkillIcons(unit.tid)
      self:initIconAndName(unit.tid)
      self:refreshPlayerAttr()
    end
  end)
  self:listenEvent("SoloRoundStart", function()
    self:onEventChessRoundStart()
  end)
  self:listenEvent("SoloRoundPrepare", function()
    self:onEventChessRoundPrepare()
  end)
  self:listenEvent("SoloRoundWait", function()
    self:onEventChessRoundWait()
  end)
  self:listenEvent("SoloRoundLock", function()
    self:onEventChessRoundLock()
  end)
  self:listenEvent("SoloRoundBattle", function()
    self:onEventChessRoundBattle()
  end)
  self:listenEvent("SoloRoundOver", function()
    self:onEventChessRoundOver()
  end)
  self:listenEvent("SoloPopChoosePower", function(data)
    ed.SoloManager.actionData = nil
    FireEvent("EventCloseOtherWin")
    self:listenTimer(Timer:Once(0), function()
      ed.ui.SoloSelectPowerWin.create(data)
    end)
  end)
  self:listenEvent("SoloChoosePower", function(power)
    self:updatePowerUI(power)
  end)
  self:listenEvent("SoloBuyCard", function(card)
    if self.selfUnit then
      self:popBuyCard(card)
      self:onGetCard(card)
    end
    self:updateGold()
  end)
  self:listenEvent("SoloUpdateGold", function()
    self:updateGold()
  end)
  self:listenEvent("SoloUpdateFaction", function(id)
    self:createFactions()
  end)
  self:listenEvent("SoloFactionLevelUp", function(id)
    self:onLevelUp(id)
  end)
  self:listenEvent("EventSoloBattleCheckEnd", function(winCamp)
    self:onEventSoloBattleCheckEnd(winCamp)
  end)
  self:listenEvent("ChessSkillBattleStart", function(userKey)
    self:startSoloPlayerBattle(userKey)
  end)
  self:listenEvent("SoloBattleOver", function(userKey, isHurt, diffHp, result)
    self:stopSoloPlayerBattle(userKey, isHurt, diffHp, result)
  end)
  self:listenEvent("SoloOverNotify", function()
    self.battleScene:exit()
  end)
  self:listenEvent("SoloPlayerDead", function()
    self:onEventSoloPlayerDead()
    ed.showConfirmDialog({
      text = T("\228\189\160\229\183\178\232\162\171\230\183\152\230\177\176\239\188\140\230\152\175\229\144\166\232\191\148\229\155\158\228\184\187\231\149\140\233\157\162\239\188\159"),
      rightHandler = function()
        ed.SoloNetwork:sendChessQuit()
      end
    })
  end)
  self:listenEvent("SoloPlayerUpdate", function()
    self:updatePlayerItems()
  end)
  self:listenEvent("SoloRoundResult", function()
    self.stageTip:onRoundStageTip("result")
  end)
  self:listenEvent("applicationDidEnterBackground", function()
    self:onEventEnterBackground()
  end)
  self:listenEvent("applicationWillEnterForeground", function()
    self:onEventEnterForeground()
  end)
end

function SoloMainPanel:popBuyCard(card)
  local cardTb = ed.getDataTable("SoloCardSkill")[card._cid]
  local cardName = cardTb.Name
  local content
  if cardTb.Tag2 and cardTb.Tag2 ~= 0 then
    local f1Data = ed.getDataTable("SoloCardTag")[cardTb.Tag1]
    local f2Data = ed.getDataTable("SoloCardTag")[cardTb.Tag2]
    local tag1Name = f1Data.Name
    local tag2Name = f2Data.Name
    local tag1Res = string.format("<sprite src=%s scale=0.4>", f1Data["Tag Icon"])
    local tag2Res = string.format("<sprite src=%s scale=0.4>", f2Data["Tag Icon"])
    content = string.format(T("\232\142\183\229\190\151\227\128\144<lable color=solocard%d>%s</lable>\227\128\145%s%s %s%s"), cardTb.Quality, cardName, tag1Res, tag1Name, tag2Res, tag2Name)
  else
    local res = ed.getDataTable("SoloCardTag")[cardTb.Tag1]["Tag Icon"]
    local tag1Res = string.format("<sprite src=%s scale=0.4>", res)
    local tag1Name = ed.getDataTable("SoloCardTag")[cardTb.Tag1].Name
    content = string.format(T("\232\142\183\229\190\151\227\128\144<lable color=solocard%d>%s</lable>\227\128\145%s%s"), cardTb.Quality, cardName, tag1Res, tag1Name)
  end
  FireEvent("SoloPopLantern", content)
end

function SoloMainPanel:playAddCardEffect()
  if not self.getCardFca then
    local sprFront = ed.createFcaNode("eff_UI_solo_hero_getcard")
    self.mainLayer:addChild(sprFront)
    ed.layout.relateLayout(self.selfUnit.actor.node, sprFront, {top = 1})
    self.getCardFca = sprFront
    self:addFca(sprFront)
  else
    self.getCardFca:setAction("Start")
  end
end

function SoloMainPanel:onGetCard(card)
  local cardTb = ed.getDataTable("SoloCardSkill")[card._cid]
  for k, v in ipairs(self.factionUIList) do
    if v.data.id == cardTb.Tag1 or v.data.id == cardTb.Tag2 then
      if v.ui.fca then
        v.ui.fca:setAction("Start")
      else
        local fca = ed.createFcaNode("eff_UI_middle_up")
        v.ui.fca = fca
        v.ui.bg:addChild(fca, 5)
        fca:setPosition(ccp(25, 22))
        self:addFca(fca)
      end
    end
  end
  local unit = self.selfUnit
  if not unit then
    return
  end
  unit:reset()
  ed.engine:initSoloModeAttribs(unit, {
    _cards = ed.SoloModel.allCardList,
    _card_factions = ed.SoloModel:getAllFactions()
  })
  self:refreshPlayerAttr()
  self:playAddCardEffect()
end

function SoloMainPanel:updatePowerUI(power)
  if power._pos < 0 then
    return
  end
  if self.powerUIList[power._pos] then
    self.powerUIList[power._pos]:removeFromParentAndCleanup(true)
    self.powerUIList[power._pos] = nil
  end
  local clipNode = self:createPowerIcon(power, power._pos)
  self.ui["treasure" .. power._pos]:addChild(clipNode)
  ed.layout.centerInParent(clipNode)
  self.powerUIList[power._pos] = clipNode
end

function SoloMainPanel:getPowerTipNum(power)
  for k, v in ipairs(power._effects or {}) do
    if v._cur_effect_times and v._cur_effect_times < v._max_effect_times then
      for k1, v1 in ipairs(v._conditions or {}) do
        return v._max_effect_times - v._cur_effect_times, v1._type
      end
    end
  end
  return 0, nil
end

function SoloMainPanel:createPowerIcon(power, i)
  self.powers[i] = power
  local powerId = power._id
  local effect1 = power._effects[1]
  local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/treasure_2.png")
  local powerIcon = ed.createSprite(ed.getDataTable("SoloPower")[powerId].Icon)
  clipNode:addChild(powerIcon)
  local time, type = self:getPowerTipNum(power)
  self.ui["redpoint_treasure" .. i]:setVisible(0 < time)
  self.ui["label_use_treasure" .. i]:setString(time)
  self:btRemoveMainTouchHandler({
    key = "treasure" .. i
  })
  self:btRegisterButtonClick({
    button = self.ui["treasure" .. i],
    key = "treasure" .. i,
    clickHandler = function()
      if not self.powers[i] then
        return
      end
      self.ui["power_selected" .. i]:setVisible(true)
      local win = ed.ui.SoloPowerInfoPop.create({
        power = self.powers[i],
        canOp = self.isSelfPanel,
        destroyHandler = function()
          self.ui["power_selected" .. i]:setVisible(false)
        end
      })
      win:popWindow()
      ed.layout.relateLayout(self.ui["treasure" .. i], win.ui.bg, {left = -5, top = 20}, true)
    end,
    priority = -300
  })
  return clipNode
end

function SoloMainPanel:initStageTipPanel()
  self.stageTip = ed.ui.SoloStageTip.create()
  self.stageTip:popWindow(999)
  self.dataPanel = ed.ui.SoloDataPanel.create()
  self.dataPanel:popWindow()
  if ed.SoloTestMode then
    ed.ui.SoloTestWin.create(self):popWindow()
  end
end

function SoloMainPanel:onEnter()
  ed.playMusic(ed.music.autochess)
  self:updateGold()
  self:initStageInfo()
  self:initStickerPanel()
  self:updatePowersUI()
  if ed.SoloManager:getStage() == ed.SoloManager.GAMESTAGE.CHOOSE then
    self:onEventChessWaitChoose()
    if ed.SoloManager.actionData then
      ed.SoloManager:handlerAction(ed.SoloManager.actionData)
    end
  end
end

function SoloMainPanel:createFactions(factions)
  self.ui.layer_faction:removeAllChildrenWithCleanup(true)
  self.factionUIList = {}
  
  local function getPos(i)
    local ox, oy = 32, 56
    local dx, dy = 65, 46
    return ccp(ox + (i - 1) % 4 * dx, oy - math.floor((i - 1) / 4) * dy)
  end
  
  local index = 1
  for k, v in pairs(factions or ed.SoloModel.factions or {}) do
    local container, ui = self:createFaction(v)
    table.insert(self.factionUIList, {
      container = container,
      ui = ui,
      data = v
    })
    container:setPosition(getPos(index))
    self.ui.layer_faction:addChild(container)
    index = index + 1
  end
  table.sort(self.factionUIList, function(a, b)
    local faction1 = a.data
    local faction2 = b.data
    return faction1.exp > faction2.exp
  end)
  for k, v in ipairs(self.factionUIList) do
    v.container:setPosition(getPos(k))
  end
end

function SoloMainPanel:createFaction(data)
  local container, ui = ed.editorui(ed.uieditor.SoloFactionItem)
  ed.setLabelStroke(ui.label_score, ed.toccc3(2236188), 1)
  ed.setTexture(ui.icon, data.tbData["Tag2 Icon"])
  local stepData = data.tbData["Star Count"]
  local maxExp = stepData[data.level + 1] or 40
  local progress = CCProgressTimer:create(ui.bar)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  ui.bg:addChild(progress)
  ui.bar:setVisible(false)
  ed.layout.centerInParent(progress)
  ui.progress = progress
  ed.setString(ui.label_score, string.format("%d/%d", data.exp, maxExp))
  if data.level == #data.tbData["Star Count"] then
    progress:setPercentage(100)
    local effect = ed.createSpine("effect/eff_UI_solo_fashion_light/eff_UI_solo_fashion_light", 0.5)
    ui.icon:addChild(effect, 5)
    ed.layout.centerInParent(effect)
    effect:setAnimation(0, "Loop", true)
    for i = 1, 4 do
      ed.setTexture(ui["star" .. i], "UI/alpha/1080P/chesscard/star_3.png")
    end
  else
    progress:setPercentage(math.min(100, data.exp / maxExp * 100))
  end
  for i = 1, data.level do
    ui["star" .. i]:setVisible(true)
  end
  self:btRemoveMainTouchHandler({
    key = "faction" .. data.id
  })
  self:btRegisterButtonClick({
    button = ui.icon,
    key = "faction" .. data.id,
    pressScale = 0.95,
    clickInterval = 0.25,
    clickHandler = function()
      self:createFactionPanel(data)
    end,
    priority = -300
  })
  return container, ui
end

function SoloMainPanel:createFactionPanel(data)
  ed.ui.SoloFactionPanel.create(data)
end

function SoloMainPanel:initIconAndName(heroId)
  if self.heroIcon then
    self.heroIcon:removeFromParentAndCleanup(true)
    self.heroIcon = nil
  end
  local hid = heroId or ed.SoloModel:getHeroId()
  local tbData = ed.lookupDataTable("SoloUnit", nil, hid)
  local iconRes = ed.getSoloUnitPortrait(hid)
  local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/hero_mask.png")
  local sprite = ed.createSprite(iconRes)
  sprite:setScale(1.2)
  clipNode:addChild(sprite)
  clipNode:setPosition(ccp(116, 60))
  self.ui.bg_bottom:addChild(clipNode, -1)
  ed.setString(self.ui.label_heroname, tbData["Display Name"])
  self.heroIcon = clipNode
end

function SoloMainPanel:pressUIIcon(icon, params)
  local skillPanel = ed.ui.SoloSkillPop.create(params)
  ed.layout.relateLayout(icon, skillPanel.ui.bg, {top = 30, left = 93.75}, true)
end

function SoloMainPanel:initSkillIcons(heroId)
  local heroId = heroId or ed.SoloModel:getHeroId()
  local tbData = ed.lookupDataTable("SoloUnit", nil, heroId)
  local slot = {1, 2}
  for i = 1, 2 do
    self.ui["bg_skill" .. i]:removeAllChildrenWithCleanup(true)
    local skillIcon = ed.readhero.createSoloUnitSkillIcon(heroId, slot[i])
    skillIcon:setScale(0.7)
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill_2.png")
    clipNode:addChild(skillIcon)
    self.ui["bg_skill" .. i]:addChild(clipNode, -1)
    ed.layout.centerInParent(clipNode)
    self:btRemoveMainTouchHandler({
      key = "skill" .. i
    })
    self:btRegisterButtonClick({
      button = skillIcon,
      key = "skill" .. i,
      clickHandler = function()
        self:pressUIIcon(skillIcon, {
          heroId = heroId,
          slot = slot[i],
          hero = self.curHero
        })
      end,
      priority = -300
    })
  end
end

function SoloMainPanel:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_quit, {left = 20})
  local pos = ed.toViewPosition({235, -30}, 0)
  pos = ccpAdd(pos, ccp(-ed.display.halfFixedWidth, -ed.display.halfFixedHeight))
  self.ui.bg_player_panel:setPosition(ccpAdd(ccp(-80, -85), pos))
  local pos = ed.toViewPosition({565, -30}, 0)
  pos = ccpAdd(pos, ccp(-ed.display.halfFixedWidth, -ed.display.halfFixedHeight))
  self.ui.bg_oppo_panel:setPosition(ccpAdd(ccp(85, -90), pos))
  ed.layout.layoutWithMagin(self.ui.bg_bottom, {bottom = 0}, false, true)
  self.bottomSrcY = self.ui.bg_bottom:getPositionY()
  ed.layout.layoutWithMagin(self.ui.bg_top, {top = 0}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_all_info, {bottom = 10, left = 10})
  ed.layout.layoutWithMagin(self.ui.btn_rule, {top = 10})
  ed.layout.layoutWithMagin(self.ui.btn_log, {bottom = 60, left = 10})
end

function SoloMainPanel:destroy()
  ed.SoloNetwork:doGameDisConnect()
  ed.SoloMarqueeManager:stopAndClear()
  ed.isBlurBg = self.oldBlurBg
  FireEvent("SoloDestroyStickerPanel")
end

function SoloMainPanel:initData()
  self.oldBlurBg = ed.isBlurBg
  ed.isBlurBg = false
  self.powers = {}
  self.eventTick = 0
  self.realTime = 0
  self.playingLanterns = 0
  self.powerUIList = {}
  self.isSelfPanel = true
  self.preGold = 0
end

function SoloMainPanel.create()
  local self = base.create("SoloMainPanel", {notBlurBg = true, noShade = true})
  setmetatable(self, SoloMainPanel.mt)
  self:initData()
  self:initUI()
  self:initStageTipPanel()
  self:registerTouchEvents()
  self:registerEvents()
  ed.SoloNetwork:createHeartBeat()
  self.mainLayer:registerScriptHandler(function(eventType)
    if "enter" == eventType then
      self:onEnter()
    elseif "exit" == eventType then
      self:destroy()
    end
  end)
  return self
end

function SoloMainPanel:setBattleScene(scene)
  self.battleScene = scene
  self.battleScene:setSpeedRate(1)
end

function SoloMainPanel:doClickQuit()
  ed.showConfirmDialog({
    text = T("\230\152\175\229\144\166\233\128\128\229\135\186\230\156\172\229\177\128\230\184\184\230\136\143\239\188\159"),
    rightHandler = function()
      ed.SoloNetwork:sendChessQuit()
    end
  })
end

function SoloMainPanel:initStickerPanel()
  local tagNode = ed.ui.SoloStickerNode.create()
  tagNode:popWindow()
  ed.layout.relateLayout(self.ui.btn_all_info, tagNode.ui.Panel_6006, {top = 0, left = 40})
end

function SoloMainPanel:refreshOppoAttr()
  if self.oppoUnit and self.ui.bg_oppo_panel:isVisible() then
    local attribs = self.oppoUnit.attribs
    self.ui.label_oppo_attr1:setString(attribs.AD or 0)
    self.ui.label_oppo_attr2:setString(self.oppoUnit.nPerSecond or 1)
    self.ui.label_oppo_attr3:setString(math.min(70, attribs.CRIT or 0))
    self.ui.label_oppo_attr4:setString(math.min(70, attribs.DODG or 0))
    self.ui.label_oppo_attr5:setString(self.oppoUnit.drugValue)
    if 0 < self.oppoUnit.frozenValue then
      self.ui.label_oppo_attr6:setString(self.oppoUnit.frozenValue or 0)
      ed.setTexture(self.ui.icon_oppo_attr6, "UI/alpha/1080P/chesscard/4.png")
    elseif 0 < self.oppoUnit.hasteValue then
      self.ui.label_oppo_attr6:setString(self.oppoUnit.hasteValue or 0)
      ed.setTexture(self.ui.icon_oppo_attr6, "UI/alpha/1080P/chesscard/11.png")
    else
      self.ui.label_oppo_attr6:setString(0)
    end
    if 0 < self.oppoUnit.shieldValue then
      ed.setTexture(self.ui.icon_oppo_attr7, "UI/alpha/1080P/chesscard/9.png")
    elseif 0 > self.oppoUnit.shieldValue then
      ed.setTexture(self.ui.icon_oppo_attr7, "UI/alpha/1080P/chesscard/12.png")
    end
    local shieldValue = math.abs(math.floor(self.oppoUnit.shieldValue)) or 0
    self.ui.label_oppo_attr7:setString(shieldValue)
    ed.setString(self.ui.label_oppo_hp, string.format("%d/%d", self.oppoUnit.hp, attribs.HP))
    local percentHp = self.oppoUnit.hp / attribs.HP * 100
    local percentMp = self.oppoUnit.mp / attribs.MP * 100
    if self.preOppoHpPer ~= percentHp then
      self.progressHpOppo:stopAllActions()
      self.progressHpOppo:runAction(CCProgressFromTo:create(0.3, self.preOppoHpPer or 100, percentHp))
      self.preOppoHpPer = percentHp
    end
    if self.preOppoMpPer ~= percentMp then
      self.progressMpOppo:stopAllActions()
      self.progressMpOppo:runAction(CCProgressFromTo:create(0.3, self.preOppoMpPer or 100, percentMp))
      self.preOppoMpPer = percentMp
    end
  end
end

function SoloMainPanel:update(dt, realDT)
  local state = ed.SoloManager:getStage()
  local needCheck = state == ed.SoloManager.GAMESTAGE.BATTLE or state == ed.SoloManager.GAMESTAGE.WAITTING
  if needCheck then
    self.eventTick = self.eventTick + dt
    self.ticks = math.floor(self.eventTick / ed.tick_interval)
    self.realTime = self.realTime + realDT
    local realTime = math.floor(self.realTime)
    local eventData = ed.SoloModel:getBattleEventByTick(realTime)
    if eventData and not eventData.isCasted then
      ed.SoloManager:handlerBattleEvent(eventData.events)
      eventData.isCasted = true
    end
    if ed.engine.canTick and ed.engine.ticks % 3 == 1 then
      self.curTicks = ed.engine.ticks
      self:refreshOppoAttr()
      self:refreshPlayerAttr()
      self.dataPanel:update()
    end
  end
end
