local base = ed.ui.popwindow
local AutoChessMainPanel = newclass(base.mt)
ed.ui.AutoChessMainPanel = AutoChessMainPanel
local chess_battle_debug = true
local RankMap = {
  price_1 = 1,
  price_2 = 2,
  price_3 = 4,
  price_4 = 7,
  price_5 = 12
}

function AutoChessMainPanel:initAreaCheckFuntions()
  local y1, y2, y3, y4 = -88, -18, 30, 70
  local x1, x2, x3, x4, x5 = 50, 154, 210, 290, 342
  local x6, x7, x8, x9, x10 = 383, 315, 260, 200, 134
  
  local function topFunc()
    return y4
  end
  
  local function topFunc1()
    return y3
  end
  
  local function buttomFunc1()
    return y2
  end
  
  local function buttomFunc()
    return y1
  end
  
  local k1 = (y4 - y1) / (x10 - x1)
  local b1 = y1 - k1 * x1
  
  local function leftFunc(y)
    return (y - b1) / k1
  end
  
  local k2 = (y4 - y1) / (x9 - x2)
  local b2 = y1 - k2 * x2
  
  local function middleFunc1(y)
    return (y - b2) / k2
  end
  
  local k3 = (y4 - y1) / (x8 - x3)
  local b3 = y1 - k3 * x3
  
  local function middleFunc2(y)
    return (y - b3) / k3
  end
  
  local k4 = (y4 - y1) / (x7 - x4)
  local b4 = y1 - k4 * x4
  
  local function middleFunc3(y)
    return (y - b4) / k4
  end
  
  local k5 = (y4 - y1) / (x6 - x5)
  local b5 = y1 - k5 * x5
  
  local function rightFunc(y)
    return (y - b5) / k5
  end
  
  self.functions = {
    left = leftFunc,
    middle1 = middleFunc1,
    middle2 = middleFunc2,
    middle3 = middleFunc3,
    right = rightFunc,
    buttom = buttomFunc,
    buttom1 = buttomFunc1,
    top1 = topFunc1,
    top = topFunc
  }
  self.heroPos = {
    ["1_1"] = ccp(105, -43),
    ["1_2"] = ccp(140, 10),
    ["1_3"] = ccp(170, 45),
    ["2_1"] = ccp(175, -43),
    ["2_2"] = ccp(202, 10),
    ["2_3"] = ccp(225, 45),
    ["3_1"] = ccp(245, -43),
    ["3_2"] = ccp(265, 10),
    ["3_3"] = ccp(280, 45),
    ["4_1"] = ccp(320, -43),
    ["4_2"] = ccp(330, 10),
    ["4_3"] = ccp(340, 45)
  }
end

function AutoChessMainPanel:initData()
  self.selectSlot = 0
  self.selectBattleIndex = 0
  self.eventTick = 0
  self.heroSlots = {}
  self.heroPos = {}
  self.undoCache = {}
  self.selectTag = {}
  self.lockSlots = {}
  self.teamTags = {}
  self.allTags = {}
  self.lootNodes = {}
  self.damageStatistic = {
    myTeam = {},
    oppoTeam = {}
  }
  self.damageDragItems = {}
  self.isFirstStart = true
  self:initAreaCheckFuntions()
end

function AutoChessMainPanel:loadUI()
  ed.editorui(ed.uieditor.AutoChessMainPanel, {
    container = self.container,
    ui = self.ui
  })
end

function AutoChessMainPanel:initLabels()
  ed.setLabelStroke(self.ui.label_timer, ed.toccc3(1312776), 2)
  ed.setLabelStroke(self.ui.label_gold, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_hero_limit, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.Label_13623, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_hero_cur, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_pet_num, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_pet_equip, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.Label_15195, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_role_level, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_stage, ed.toccc3(1312776), 1.5)
  ed.setLabelStroke(self.ui.label_wait_title, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.label_oppo_title, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.label_oppe_type, ed.toccc3(5640979), 1)
  ed.setLabelStroke(self.ui.label_target, ed.toccc3(5640979), 1)
  ed.setLabelStroke(self.ui.label_battle_start_round, ed.toccc3(1315346), 1)
  self.ui.Label_5392:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5392, ed.toccc3(16776423), 2)
  self.ui.Label_5393:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5393, ed.toccc3(16776423), 2)
  self.ui.Label_5394:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5394, ed.toccc3(8347183), 2)
  self.ui.Label_5395:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5395, ed.toccc3(16776423), 2)
  ed.setLabelStroke(self.ui.label_round, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.label_gold_tip, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.label_gold_tip1, ed.toccc3(1315346), 1)
  self.ui.label_gold_tip1:setDimensions(CCSizeMake(250, 0))
  ed.setLabelStroke(self.ui.Label_10191, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.Label_10191_Copy0, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.Label_10191_Copy1, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.label_gold_base, ed.toccc3(1315346), 1.5)
  ed.setLabelStroke(self.ui.label_gold_add, ed.toccc3(1315346), 1.5)
  ed.setLabelStroke(self.ui.label_gold_extra, ed.toccc3(1315346), 1.5)
  ed.setLabelStroke(self.ui.Label_7028, ed.toccc3(1312776), 1)
end

function AutoChessMainPanel:getPlayerIconPressHandler()
  local function handler(x, y)
    local listItems = self.playerDragList.listItems or {}
    
    for idx, icon in pairs(listItems) do
      if ed.containsPoint(icon, x, y) then
        return icon, idx
      end
    end
    if not tolua.isnull(self.playerTeamPanel) then
      self.playerTeamPanel:removeFromParentAndCleanup(true)
      self.playerTeamPanel = nil
    end
  end
  
  return handler
end

function AutoChessMainPanel:createPlayerDragList()
  self.playerDragList = ed.UITool.createDraglist(self.ui.layer_oppo_item, {
    doPressIn = self:getPlayerIconPressHandler(),
    doClickIn = self:getPlayerIconClickHandler(),
    priority = -300
  })
end

function AutoChessMainPanel:showPlayerTeamPanel(isShow, playerInfo, pos)
  if not tolua.isnull(self.playerTeamPanel) then
    self.playerTeamPanel:removeFromParentAndCleanup(true)
    self.playerTeamPanel = nil
  end
  if isShow then
    local container, ui = ed.editorui(ed.uieditor.AutoChessOtherInfo)
    self.playerTeamPanel = container
    local teamData = playerInfo:getTeam()
    local heros = teamData._heroes
    if type(heros) == "table" then
      for i = 1, #heros do
        local hero = heros[i]
        local price = ed.getDataTable("ChessUnit")[hero._hid]["Buy Price"]
        local rank = ed.getChessUnitStar(hero._hid)
        local param = {
          id = hero._hid,
          stars = rank,
          level = false,
          rank = RankMap["price_" .. price]
        }
        local heroIcon = ed.readhero.createChessIcon(param)
        heroIcon.icon:setScale(0.6)
        ed.UITool.replaceUINew(ui, "hero" .. i, heroIcon.icon)
      end
      local powers = playerInfo:getPowers()
      if powers and powers[1] then
        local powerId = powers[1]._id
        local frame = ed.createChessPowerIcon(powerId)
        frame:setScale(0.57)
        ed.UITool.replaceUINew(ui, "frame", frame)
        local powerInfo = ed.getDataTable("ChessHeroPower")[powerId]
        ed.setLabelDimensions(ui.desc, CCSizeMake(235, 0))
        ed.setString(ui.desc, powerInfo.Description)
      end
      self.playerTeamPanel:setPosition(ccp(pos.x - 180, pos.y))
      self.mainLayer:addChild(self.playerTeamPanel, 500)
    else
      ed.showToast(T("\230\154\130\230\151\160\230\149\176\230\141\174"))
    end
  end
end

function AutoChessMainPanel:handlerPlayerClick(index, icon)
  if ed.AutoChessTeachManager:checkGuideStep({type = "player", index = index}) then
    return
  end
  if self.isShowDetail then
    return
  end
  if not tolua.isnull(icon) then
    local teamData = icon.player:getTeam()
    if type(teamData) == "table" then
      local iconPos = ed.getWorldPos(icon)
      self:showPlayerTeamPanel(true, icon.player, iconPos)
    else
      ed.showToast(T("\230\154\130\230\151\160\230\149\176\230\141\174"))
    end
  end
end

function AutoChessMainPanel:getPlayerIconClickHandler()
  local function handler(_, _, icon, index)
    if self.isShopOpen then
      return
    end
    self:handlerPlayerClick(index, icon)
  end
  
  return handler
end

function AutoChessMainPanel:showCampDamagePanel(isInit)
  if isInit then
    self.showCampDamage = ed.emCampPlayer
  else
    self.showCampDamage = self.showCampDamage == ed.emCampPlayer and ed.emCampEnemy or ed.emCampPlayer
  end
  if self.showCampDamage == ed.emCampPlayer then
    ed.setLabelColor(self.ui.label_damage_title, ed.toccc3(7864148))
    ed.setLabelStroke(self.ui.label_damage_title, ed.toccc3(1315346), 1)
    ed.setTexture(self.ui.img_damage, "UI/alpha/1080P/chess/battle/chess_data_bg_colour_1.png")
    ed.setTexture(self.ui.icon_switch, "UI/alpha/1080P/chess/battle/chess_data_name_1.png")
    ed.setString(self.ui.label_damage_title, T("\230\136\145\230\150\185\228\188\164\229\174\179"))
    self.ui.Panel_damage_list_1:setVisible(true)
    self.ui.Panel_damage_list_2:setVisible(false)
  elseif self.showCampDamage == ed.emCampEnemy then
    ed.setLabelColor(self.ui.label_damage_title, ed.toccc3(16711580))
    ed.setString(self.ui.label_damage_title, T("\230\149\140\230\150\185\228\188\164\229\174\179"))
    ed.setLabelStroke(self.ui.label_damage_title, ed.toccc3(4663559), 1)
    ed.setTexture(self.ui.img_damage, "UI/alpha/1080P/chess/battle/chess_data_bg_colour_2.png")
    ed.setTexture(self.ui.icon_switch, "UI/alpha/1080P/chess/battle/chess_data_name_2.png")
    self.ui.Panel_damage_list_1:setVisible(false)
    self.ui.Panel_damage_list_2:setVisible(true)
  end
  self.ui.label_damage_title:limitWidthByScale(100)
  ed.right2(self.ui.icon_switch, self.ui.label_damage_title, 4)
end

function AutoChessMainPanel:createDamageList()
  self.myDamageList = ed.UITool.createDraglist(self.ui.Panel_damage_list_1)
  self.oppoDamageList = ed.UITool.createDraglist(self.ui.Panel_damage_list_2)
  self:showCampDamagePanel(true)
end

function AutoChessMainPanel:updateBtnUndoState(show)
  if self.ui.btn_undo then
    self.ui.btn_undo:setVisible(show)
  end
  if self.ui.btn_reset then
    self.ui.btn_reset:setVisible(show)
  end
  if self.ui.btn_npc then
    self.ui.btn_npc:setVisible(show)
  end
end

function AutoChessMainPanel:showQuitBtn()
  local isVisible = ed.chess_debug_mode
  local gameType = ed.AutoChessManager:getGameType()
  if gameType == "robot" or gameType == "rookie" then
    isVisible = true
    if gameType == "robot" then
      isVisible = ed.AutoChessModel:getBattleRound() > 1
    end
  else
    isVisible = ed.AutoChessModel:isMySelfDead()
  end
  isVisible = isVisible or ed.AutoChessTeachManager:isGuideFlag()
  self.ui.btn_quit:setVisible(isVisible)
end

function AutoChessMainPanel:initUI()
  self:loadUI()
  self:initLabels()
  self:adaptUI()
  self:createPlayerDragList()
  self:createDamageList()
  self:updateBtnUndoState(ed.chess_debug_mode)
  self:showQuitBtn()
end

function AutoChessMainPanel:updateGold()
  ed.setString(self.ui.label_gold, ed.AutoChessModel:getTotalGold())
end

function AutoChessMainPanel:updateTeamPanel()
  local teamLv = ed.AutoChessModel:getTeamLevel()
  ed.setString(self.ui.label_role_level, ed.formatLevel("Lv") .. teamLv)
  local exp = ed.AutoChessModel:getTeamExp()
  local needExp = ed.AutoChessModel:getTeamNeedExp()
  ed.setLabelStroke(self.ui.label_exp_progress, ccc3(0, 0, 0), 2)
  ed.setLabelString(self.ui.label_exp_progress, exp .. "/" .. needExp)
  local isMax = not needExp or needExp == 0
  local percent = not isMax and exp / needExp or 1
  self.ui.img_exp_progress:setTextureRect(CCRectMake(0, 0, percent * 91, 23))
  if isMax then
    ed.setString(self.ui.label_exp_progress, "MAX")
  end
end

function AutoChessMainPanel:updateTeamLimit()
  local limit = ed.AutoChessModel:getTeamLimit()
  local heroNum = 0
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, battleHero in pairs(battleData) do
    if battleHero then
      heroNum = heroNum + 1
    end
  end
  ed.setString(self.ui.label_hero_limit, limit)
  ed.setString(self.ui.label_hero_cur, heroNum)
  if limit < heroNum then
    ed.setLabelColor(self.ui.label_hero_cur, ccc3(255, 0, 0))
  else
    ed.setLabelColor(self.ui.label_hero_cur, ccc3(254, 252, 214))
  end
end

function AutoChessMainPanel:initPlayerItems()
  local index, interval = 0, 70
  local posX, startY = 186, 243
  local draglist = self.playerDragList
  draglist:clearList()
  self.playerItemList = {}
  local playerList = ed.AutoChessModel:getPlayerList()
  for i, player in ipairs(playerList) do
    local userkey = player:getUserKey()
    local playerItem = ed.ui.AutoChessPlayerItem.create(player)
    local iconNode = playerItem:getRootNode()
    iconNode:setPosition(posX, startY - interval * index)
    iconNode.player = player
    draglist:addItem(iconNode)
    index = index + 1
    self.playerItemList[userkey._user_id .. "_" .. userkey._server_id] = playerItem
  end
  draglist:initListHeight(index * interval)
end

function AutoChessMainPanel:addChessTagNode(icon, hid)
  local tagNode = CCNode:create()
  local raceTags = ed.getChessUnitRaceTags(hid)
  local offsetX = 0
  local scale = 0.6
  for _, tag in pairs(raceTags) do
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, 0))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
  end
  local abilityTags = ed.getChessUnitAbilityTags(hid)
  for _, tag in pairs(abilityTags) do
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, 0))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
  end
  tagNode:setPosition(ccp(35 - offsetX / 2, 60))
  icon:addChild(tagNode, 20)
end

function AutoChessMainPanel:createHeroSlotIcon(hero)
  local hid = hero:getChessId()
  local price = hero:getHeroInitPrice()
  local param = {
    id = hid,
    stars = hero:getHeroStar(),
    level = false,
    rank = RankMap["price_" .. price]
  }
  local heroIcon = ed.readhero.createChessIcon(param)
  self:addChessTagNode(heroIcon.icon, hid)
  local equipPet = hero:getEquipChessPet()
  if equipPet then
    local petId = equipPet:getChessPetId()
    local petObject = ed.readpet.createChessIcon({type = petId})
    petObject.icon:setScale(0.25)
    petObject.icon:setAnchorPoint(ccp(0, 0))
    petObject.icon:setPosition(ccp(0, 0))
    heroIcon.icon:addChild(petObject.icon)
  end
  return heroIcon
end

function AutoChessMainPanel:updateSingleSlot(type, index, insid, isCompose, isExchange)
  if type == "on" then
    local slotBg = self.ui["img_slot_" .. index]
    slotBg:removeAllChildrenWithCleanup(true)
    if not isCompose and ed.AutoChessModel:isSlotExistSameChess(insid) and not isExchange then
      return
    end
    local chessHero = ed.AutoChessModel:getChessHeroBySid(insid)
    local heroIcon = self:createHeroSlotIcon(chessHero)
    slotBg:addChild(heroIcon.icon, 10)
    local bgSize = slotBg:getContentSize()
    heroIcon.icon:setPosition(ccp(42.5, 43))
    self.heroSlots["slot_" .. index] = heroIcon
    ed.AutoChessModel:updateSlotHero("update", index, insid)
    ed.playEffect(ed.sound.prepare.common_add_queue)
    if isCompose then
      local effect = ed.createFcaNode("eff_UI_Chess_headframe_evolution")
      slotBg:addChild(effect, 12)
      effect:setPosition(ccp(bgSize.width / 2 - 2, 34))
      self:addFca(effect)
    end
  elseif type == "off" then
    local selectSlot = self.heroSlots["slot_" .. index]
    if selectSlot and not tolua.isnull(selectSlot.icon) then
      selectSlot.icon:removeFromParentAndCleanup(true)
      self.heroSlots["slot_" .. index] = nil
    end
    local heroId = ed.AutoChessModel:getChessHeroByIndex(index)
    if selectSlot and heroId then
      ed.AutoChessModel:updateSlotHero("delete", index)
    end
  end
end

function AutoChessMainPanel:initHeroSlots()
  self.ui.img_slot_select:setVisible(false)
  local totalHeroList = ed.AutoChessModel:getTotalHeroList()
  local heroList = {}
  for _, hero in pairs(totalHeroList) do
    if hero:getState() == 1 then
      table.insert(heroList, hero)
    end
  end
  for index = 1, 8 do
    local chessHero = heroList[index]
    if chessHero and chessHero:getState() == 1 then
      self:updateSingleSlot("on", index, chessHero:getHeroInsid())
    else
      self:updateSingleSlot("off", index)
    end
  end
end

function AutoChessMainPanel:initTagPanel()
  local tagNode = ed.ui.AutoChessTagNode.create()
  tagNode:popWindow()
  ed.layout.relateLayout(self.ui.bg_btn_tag, tagNode.ui.Panel_6006, {right = -70, top = -32.5})
end

function AutoChessMainPanel:initStickerPanel()
  local tagNode = ed.ui.AutoChessStickerNode.create()
  tagNode:popWindow()
  ed.layout.relateLayout(self.ui.bg_btn_tag, tagNode.ui.Panel_6006, {
    right = -70,
    bottom = self.ui.bg_btn_tag:getContentSize().height * 0.5
  })
end

function AutoChessMainPanel:initLevelFca()
  self.levelFca = ed.createFcaNode("eff_UI_Chess_lvup")
  self:addFca(self.levelFca)
  self.ui.bg_role:addChild(self.levelFca, 999)
  self.levelFca:setVisible(false)
  self.levelFca:setPosition(ccp(60, 30))
end

function AutoChessMainPanel:resetStageTip(param)
  if not param or not param.showStart then
    self.ui.img_round_start_bg:setVisible(false)
  end
  self.ui.img_oppo_info_bg:setVisible(false)
  self.ui.img_battle_start_bg:setVisible(false)
  self.ui.img_battle_victory_bg:setVisible(false)
  self.ui.img_battle_lose_bg:setVisible(false)
  self.ui.img_wait_info_bg:setVisible(false)
end

function AutoChessMainPanel:initStageInfo()
  if ed.run_chess_check then
    return
  end
  self:resetStageTip()
  local round = ed.AutoChessModel:getBattleRound()
  ed.setString(self.ui.label_round, T("\231\172\172%d\229\155\158\229\144\136", round))
  ed.setString(self.ui.label_stage, "")
  ed.setLabelStroke(self.ui.label_stage, ed.toccc3(1312776), 1.5)
  self.ui.label_timer:setVisible(false)
  self.ui.img_oppo_bg:setVisible(false)
  ed.engine:clearAllChessUnits()
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, heroData in pairs(battleData) do
    if type(heroData) == "table" then
      local chessHero = ed.AutoChessModel:getChessHeroBySid(heroData.heroSid)
      local heroPos = self:getHeroPosByIndex(heroData.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        show_tag = true,
        show_pet = true
      })
    end
  end
end

function AutoChessMainPanel:initPetInfo()
  local equipNum = ed.AutoChessModel:getEquipPetNum()
  local totalNum = #ed.AutoChessModel:getDropPetData()
  ed.setString(self.ui.label_pet_equip, equipNum)
  ed.setString(self.ui.label_pet_num, totalNum)
end

function AutoChessMainPanel:showDamagePanel(isShow)
  self.isShowDamage = isShow
  self.ui.img_damage_bg:setVisible(isShow)
  self.ui.ImageView_7022:setVisible(isShow)
  self.ui.ImageView_7023:setVisible(not isShow)
end

function AutoChessMainPanel:clearLootNodes()
  for _, lootNode in ipairs(self.lootNodes) do
    lootNode:removeFromParentAndCleanup(true)
  end
  self.lootNodes = {}
end

function AutoChessMainPanel:updateStagePanel()
  local round = ed.AutoChessModel:getBattleRound()
  ed.setString(self.ui.label_round, T("\231\172\172%d\229\155\158\229\144\136", round))
  local stage = ed.AutoChessManager:getChessStage()
  local stageDesc = T("\229\188\128\229\167\139\229\135\134\229\164\135")
  if stage == ed.AutoChessManager.GAMESTAGE.START then
    stageDesc = T("\229\155\158\229\144\136\229\188\128\229\167\139")
  elseif stage == ed.AutoChessManager.GAMESTAGE.PREPARE then
    stageDesc = T("\229\135\134\229\164\135\233\152\182\230\174\181")
    ed.setLabelColor(self.ui.label_stage, ed.toccc3(7864155))
    ed.setTexture(self.ui.img_prepare_bg, "UI/alpha/1080P/chess/battle/phase_preparation_bg.png")
  elseif stage == ed.AutoChessManager.GAMESTAGE.LOCK then
    stageDesc = T("\233\148\129\229\174\154\233\152\182\230\174\181")
    ed.setLabelColor(self.ui.label_stage, ed.toccc3(11447982))
    ed.setTexture(self.ui.img_prepare_bg, "UI/alpha/1080P/chess/battle/phase_lock_bg.png")
  elseif stage == ed.AutoChessManager.GAMESTAGE.BATTLE then
    stageDesc = T("\230\136\152\230\150\151\233\152\182\230\174\181")
    ed.setLabelColor(self.ui.label_stage, ed.toccc3(16737355))
    ed.setTexture(self.ui.img_prepare_bg, "UI/alpha/1080P/chess/battle/phase_battle_bg.png")
  elseif stage == ed.AutoChessManager.GAMESTAGE.WAITTING then
    stageDesc = T("\230\136\152\230\150\151\233\152\182\230\174\181")
    ed.setLabelColor(self.ui.label_stage, ed.toccc3(16737355))
    ed.setTexture(self.ui.img_prepare_bg, "UI/alpha/1080P/chess/battle/phase_battle_bg.png")
  elseif stage == ed.AutoChessManager.GAMESTAGE.OVER then
    stageDesc = T("\229\155\158\229\144\136\231\187\147\230\157\159")
    ed.setLabelColor(self.ui.label_stage, ccc3(207, 207, 207))
    ed.setTexture(self.ui.img_prepare_bg, "UI/alpha/1080P/chess/battle/phase_lock_bg.png")
  end
  ed.setString(self.ui.label_stage, stageDesc)
end

function AutoChessMainPanel:showChessShop()
  if not self.isShopOpen then
    if ed.AutoChessManager.selectPowerWin then
      function ed.AutoChessManager.selectPowerWin.destroyCallback()
        ed.ui.AutoChessShopWindow.create():popWindow()
      end
      
      return
    end
    ed.ui.AutoChessShopWindow.create():popWindow()
    self.isShopOpen = true
  end
end

function AutoChessMainPanel:onRoundStageTip(stage)
  self.ui.img_battle_bg:setVisible(false)
  local action = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
  local delay = CCDelayTime:create(2)
  local action2 = CCEaseBackOut:create(CCScaleTo:create(0.2, 0))
  if stage == "start" then
    self:resetStageTip()
    self.ui.img_prepare_bg:setVisible(true)
    if ed.AutoChessModel:isMySelfDead() then
      return
    end
    self.ui.img_round_start_bg:setVisible(true)
    local gainGold = ed.AutoChessModel:getGainGold()
    ed.setString(self.ui.label_total_gold, gainGold.gainBase)
    ed.setString(self.ui.label_gain_gold, gainGold.gainInst)
    local dvGold = math.max(gainGold.comboV, gainGold.comboD)
    ed.setString(self.ui.label_failed_gold, dvGold)
    if gainGold.comboV > gainGold.comboD then
      ed.setLabelString(self.ui.label_failed, T("\232\191\158\232\131\156\239\188\154"))
    else
      ed.setLabelString(self.ui.label_failed, T("\232\191\158\232\180\165\239\188\154"))
    end
    self.ui.label_failed_gold:setVisible(0 < dvGold)
    self.ui.label_failed:setVisible(0 < dvGold)
    self.ui.ImageView_12175:setVisible(0 < dvGold)
    local final = CCCallFunc:create(function()
      self.ui.img_round_start_bg:setVisible(false)
      self.ui.img_oppo_info_bg:setVisible(true)
      self:showChessShop()
    end)
    local sequence = CCSequence:create(ccArrayMake(action, delay, action2, final))
    self.ui.img_round_start_bg:setScale(0)
    self.ui.img_round_start_bg:runAction(sequence)
    ed.layout.horizontalSortNode({
      self.ui.label_gain_title,
      self.ui.ImageView_12173,
      self.ui.label_total_gold,
      self.ui.label_award_title,
      self.ui.ImageView_12174,
      self.ui.label_gain_gold,
      self.ui.label_failed,
      self.ui.ImageView_12175,
      self.ui.label_failed_gold
    }, {
      -6,
      1,
      15,
      -6,
      1,
      15,
      -6,
      1,
      0
    }, self.ui.img_round_start_bg:getContentSize().width * 0.5)
  elseif stage == "prepare" then
    self.ui.img_prepare_bg:setVisible(true)
    self:resetStageTip({showStart = true})
  elseif stage == "lock" then
    self.ui.img_battle_bg:setVisible(false)
  elseif stage == "battle" then
    self.ui.img_battle_bg:setVisible(false)
    self:resetStageTip()
    if ed.AutoChessModel:isMySelfDead() then
      return
    end
    self.ui.img_battle_start_bg:setVisible(true)
    local round = ed.AutoChessModel:getBattleRound()
    ed.setString(self.ui.label_battle_start_round, T("\231\172\172%d\229\155\158\229\144\136", round))
    local final = CCCallFunc:create(function()
      self.ui.img_battle_start_bg:setVisible(false)
    end)
    action = CCSequence:create(ccArrayMake(action, delay, final))
    self.ui.img_battle_start_bg:setScale(0)
    self.ui.img_battle_start_bg:runAction(action)
  elseif stage == "waitting" then
    self.ui.img_battle_bg:setVisible(false)
    self:resetStageTip()
    if ed.AutoChessModel:isMySelfDead() then
      return
    end
    self.ui.img_wait_info_bg:setVisible(true)
    local final = CCCallFunc:create(function()
      self.ui.img_wait_info_bg:setVisible(false)
    end)
    action = CCSequence:create(ccArrayMake(action, delay, final))
    self.ui.img_wait_info_bg:setScale(0)
    self.ui.img_wait_info_bg:runAction(action)
  elseif stage == "result" then
    self.ui.img_battle_bg:setVisible(false)
    self:resetStageTip()
    if ed.AutoChessModel:isMySelfDead() then
      return
    end
    local result = ed.AutoChessModel:getBattleResult()
    if result ~= "defeat" and result ~= "victory" then
      return
    end
    ed.playEffect(ed.sound.autochess.winlose)
    local panel = self.ui.img_battle_victory_bg
    if result == "defeat" then
      panel = self.ui.img_battle_lose_bg
    elseif result == "victory" then
      panel = self.ui.img_battle_victory_bg
      local winGold = ed.AutoChessModel:getWinGold()
      ed.setLabelString(self.ui.label_victory_gain_gold, winGold)
      self:updateGold()
      FireEvent("EffectAddTotalGold", winGold)
    end
    panel:setVisible(true)
    local final = CCCallFunc:create(function()
      panel:setVisible(false)
      self:onRoundStageTip("waitting")
    end)
    action = CCSequence:create(ccArrayMake(action, delay, final))
    panel:setScale(0)
    panel:runAction(action)
  elseif stage == "over" then
    self.ui.img_battle_bg:setVisible(false)
    self.ui.img_wait_info_bg:setVisible(false)
    self:resetStageTip()
  end
end

function AutoChessMainPanel:sortPlayerItems(isUpdate)
  local index, interval = 0, 70
  local posX, startY = 186, 243
  local playerList = ed.AutoChessModel:getPlayerList()
  for _, player in ipairs(playerList) do
    local userkey = player:getUserKey()
    local playerItem = self.playerItemList[userkey._user_id .. "_" .. userkey._server_id]
    if playerItem then
      local iconNode = playerItem:getRootNode()
      local lastPosX, lastPosY = iconNode:getPosition()
      local newPosY = startY - interval * index
      if lastPosY ~= newPosY then
        local moveAction = CCEaseIn:create(CCMoveTo:create(0.2, ccp(posX, newPosY)), 0.2)
        iconNode:stopAllActions()
        local startSyncFunc = CCCallFunc:create(function()
          self.isSyncChatNodePos = true
        end)
        local stopSyncFunc = CCCallFunc:create(function()
          self.isSyncChatNodePos = false
        end)
        iconNode:runAction(CCSequence:create(ccArrayMake(startSyncFunc, moveAction, stopSyncFunc)))
      end
      if isUpdate then
        playerItem:updateIcon()
      end
    end
    index = index + 1
  end
end

function AutoChessMainPanel:updatePlayerItems()
  self:sortPlayerItems(true)
end

function AutoChessMainPanel:checkTeamChessData()
  ed.engine:clearAllChessUnits()
  local battleData = ed.AutoChessModel:getBattleHeroData()
  local teamIds = {}
  for _, heroData in pairs(battleData) do
    if type(heroData) == "table" then
      local chessHero = ed.AutoChessModel:getChessHeroBySid(heroData.heroSid)
      local heroPos = self:getHeroPosByIndex(heroData.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        show_tag = true,
        show_pet = true
      })
      table.insert(teamIds, chessHero:getHeroInsid())
    end
  end
  if ed.AutoChessModel:isMySelfDead() then
    for slot = 1, 8 do
      self:updateSingleSlot("off", slot)
    end
  else
    local totalHeroList = ed.AutoChessModel:getTotalHeroList()
    local uniqueIds = {}
    for slot = 1, 8 do
      local heroSid = ed.AutoChessModel:getChessHeroByIndex(slot)
      local isInValid = heroSid and ed.AutoChessModel:getChessHeroBySid(heroSid) == nil or ed.isElementInTable(heroSid, uniqueIds) or ed.isElementInTable(heroSid, teamIds)
      if isInValid then
        self:updateSingleSlot("off", slot)
      else
        table.insert(uniqueIds, heroSid)
      end
    end
    for _, hero in pairs(totalHeroList) do
      local insid = hero:getHeroInsid()
      local isInSlot = false
      for slot = 1, 8 do
        local slotSid = ed.AutoChessModel:getChessHeroByIndex(slot)
        if slotSid and insid == slotSid then
          self:updateSingleSlot("on", slot, slotSid, false, true)
          isInSlot = true
        end
      end
      if not ed.isElementInTable(insid, teamIds) and not isInSlot then
        local slot = ed.AutoChessModel:getFreeSlot()
        self:updateSingleSlot("on", slot, insid)
      end
    end
    FireEvent("EventChessUpdatePet", "equip")
  end
end

function AutoChessMainPanel:clearTimer()
  if self.prepareTimer then
    CloseTimer(self.prepareTimer.Name)
    self.prepareTimer = nil
  end
  self.ui.label_timer:stopAllActions()
  self.eventTick = 0
end

function AutoChessMainPanel:startTimer()
  self:clearTimer()
  local stage = ed.AutoChessManager:getChessStage()
  if stage == ed.AutoChessManager.GAMESTAGE.START then
    self.ui.label_timer:setScale(1)
    self.ui.label_timer:setVisible(false)
  elseif stage == ed.AutoChessManager.GAMESTAGE.PREPARE then
    self.ui.label_timer:setScale(1)
    self.ui.label_timer:setVisible(true)
    ed.setLabelColor(self.ui.label_timer, ccc3(253, 253, 253))
    local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
    local endTime = not isGuideFlag and ed.AutoChessModel:getPrepareEndTime() or ed.getServerTime() + 10
    local leftTime = endTime - ed.getServerTime()
    self.prepareTimer = nil
    if not self.prepareTimer then
      self.prepareTimer = self:listenTimer(Timer:Always(1), function()
        local leftSec = math.max(endTime - ed.getServerTime(), 0)
        ed.setString(self.ui.label_timer, leftSec)
        if leftSec <= 5 then
          ed.playEffect(ed.sound.autochess.countdown)
          self.ui.label_timer:stopAllActions()
          ed.setLabelColor(self.ui.label_timer, ccc3(254, 0, 93))
          local scaleTo1 = CCEaseBackOut:create(CCScaleTo:create(0.5, 1.5))
          local scaleTo2 = CCEaseBackOut:create(CCScaleTo:create(0.3, 1))
          local seq = CCSequence:create(ccArrayMake(scaleTo1, scaleTo2))
          self.ui.label_timer:runAction(seq)
          if self.countEffect then
            self.countEffect:removeFromParentAndCleanup(true)
          end
          self.countEffect = ed.createFcaNode("eff_UI_chess_countdown")
          self.ui.label_timer:addChild(self.countEffect)
          ed.layout.centerInParent(self.countEffect)
          self:addFca(self.countEffect)
        end
        if leftSec <= 0 then
          self:listenTimer(Timer:Once(0.1), function()
            FireEvent("EventGuideUpdateStep")
          end)
        end
      end)
    end
  elseif stage == ed.AutoChessManager.GAMESTAGE.LOCK then
    self.ui.label_timer:setScale(1)
    self.ui.label_timer:setVisible(true)
    ed.setLabelColor(self.ui.label_timer, ccc3(253, 253, 253))
    self.usedTime = 0
    ed.setString(self.ui.label_timer, self.usedTime)
    if not self.prepareTimer then
      self.prepareTimer = self:listenTimer(Timer:Always(1), function()
        self.usedTime = self.usedTime + 1
        ed.setString(self.ui.label_timer, self.usedTime)
        if self.usedTime >= 2 then
          self:listenTimer(Timer:Once(0.1), function()
            FireEvent("EventGuideUpdateStep")
          end)
        end
      end)
    end
  elseif stage == ed.AutoChessManager.GAMESTAGE.BATTLE then
    self.ui.label_timer:setScale(1)
    self.ui.label_timer:setVisible(true)
    ed.setLabelColor(self.ui.label_timer, ccc3(253, 253, 253))
    self.usedTime = 60
    self.eventTick = 0
    ed.setString(self.ui.label_timer, self.usedTime)
    if not self.prepareTimer then
      self.prepareTimer = self:listenTimer(Timer:Always(1), function()
        self.usedTime = math.max(self.usedTime - 1, 0)
        self.eventTick = self.eventTick + 1
        ed.setString(self.ui.label_timer, self.usedTime)
      end)
    end
  elseif stage == ed.AutoChessManager.GAMESTAGE.OVER then
    self.ui.label_timer:setScale(1)
    self.ui.label_timer:setVisible(true)
    ed.setLabelColor(self.ui.label_timer, ccc3(253, 253, 253))
    local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
    local endTime = not isGuideFlag and ed.AutoChessModel:getOverEndTime() or ed.getServerTime() + 5
    local leftTime = endTime - ed.getServerTime()
    ed.setString(self.ui.label_timer, leftTime)
    if not self.prepareTimer then
      self.prepareTimer = self:listenTimer(Timer:Always(1), function()
        local leftSec = math.max(endTime - ed.getServerTime(), 0)
        ed.setString(self.ui.label_timer, leftSec)
        if leftSec <= 0 then
          self:listenTimer(Timer:Once(0.1), function()
            FireEvent("EventGuideUpdateStep")
            ed.AutoChessTeachManager:updateStep(true)
          end)
        end
      end)
    end
  end
end

function AutoChessMainPanel:onEventChessRoundStart()
  self:showQuitBtn()
  ed.AutoChessManager:stopBattleEndCheck()
  self:clearLootNodes()
  if self.isFirstStart and ed.AutoChessManager:isReconnectMode() then
    self.isFirstStart = false
  else
    self:updateGold()
    self:updateTeamPanel()
    self:updateTeamLimit()
    self:updateStagePanel()
    self:onRoundStageTip("start")
    self:updatePlayerItems()
    self:refreshPowerBtn()
    local combo = ed.AutoChessModel:getCombo()
    if 0 < combo then
      ed.setTexture(self.ui.btn_win_tip, "UI/alpha/1080P/chess/battle/shop_tips_winningstreak.png")
    elseif combo == 0 then
      ed.setTexture(self.ui.btn_win_tip, "UI/alpha/1080P/chess/battle/shop_tips_normal.png")
    else
      ed.setTexture(self.ui.btn_win_tip, "UI/alpha/1080P/chess/battle/shop_tips_losingstreak.png")
    end
    ed.setString(self.ui.Label_7028, math.abs(combo))
  end
  self.ui.img_oppo_bg:setVisible(false)
  self.battleScene:setSpeedRate(1)
  self:startTimer()
  self.undoCache = {}
  self:checkTeamChessData()
  FireEvent("EventGuideUpdateStep")
end

function AutoChessMainPanel:onEventChessRoundPrepare()
  self:onRoundStageTip("prepare")
  self.battleScene:setSpeedRate(1)
  self:updateGold()
  self:updateTeamLimit()
  self:updateStagePanel()
  local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
  if not isGuideFlag then
    self:startTimer()
  else
    self:clearTimer()
    local endTime = ed.AutoChessModel:getPrepareEndTime()
    local leftTime = endTime - ed.getServerTime()
    self.ui.label_timer:setVisible(true)
    ed.setString(self.ui.label_timer, leftTime)
  end
  self.undoCache = {}
  local oppoType = ed.AutoChessModel:getOppoType()
  local oppoDesc = T("\230\151\160\230\140\145\230\136\152\231\155\174\230\160\135")
  if oppoType == "monster" then
    oppoDesc = T("\230\128\170\231\137\169")
  elseif oppoType == "player" then
    oppoDesc = T("\233\154\143\230\156\186\231\142\169\229\174\182")
  end
  ed.setString(self.ui.label_oppe_type, oppoDesc)
  ed.right2(self.ui.label_oppe_type, self.ui.label_oppo_title, 0)
end

function AutoChessMainPanel:onEventChessRoundLock()
  self:updateStagePanel()
  self:startTimer()
  self:onRoundStageTip("lock")
  if ed.AutoChessModel:isMySelfDead() then
    return
  end
  local myTeamData = ed.AutoChessModel:getSelfTeamData()
  if type(myTeamData.heroes) == "table" then
    local insids = {}
    for i, teamHero in ipairs(myTeamData.heroes) do
      insids[i] = teamHero._insid
      if not ed.AutoChessModel:getBattleHeroByPos(myTeamData.positions[i]) then
        local hero = ed.AutoChessModel:getChessHeroBySid(teamHero._insid)
        if hero then
          ed.AutoChessModel:updateBattleHeroData("on", {
            pos = myTeamData.positions[i],
            heroSid = teamHero._insid
          })
          local info = {
            hero = hero,
            pos = self:getHeroPosByIndex(myTeamData.positions[i]),
            show_tag = true,
            show_pet = true,
            addPet = ed.chess_debug_mode
          }
          ed.engine:onPrepareJoinBattle(info, true)
        end
      end
    end
    local battleHeroes = ed.AutoChessModel:getBattleHeroData()
    for k, battleHero in pairs(battleHeroes) do
      local insid = battleHero.heroSid
      if not ed.isElementInTable(insid, insids) then
        local slot = ed.AutoChessModel:getFreeSlot()
        local heroData = {
          heroSid = insid,
          posIndex = battleHero.posIndex
        }
        self:undoBattleHero(heroData, slot)
      end
    end
  end
  for slot = 1, 8 do
    local slotSid = ed.AutoChessModel:getChessHeroByIndex(slot)
    if slotSid then
      for i, teamHero in ipairs(myTeamData.heroes or {}) do
        if slotSid == teamHero._insid then
          self:updateSingleSlot("off", slot)
        end
      end
    else
      self:updateSingleSlot("off", slot)
    end
  end
  self:checkTeamChessData()
  self:updateTeamLimit()
  FireEvent("EventCloseOtherWin")
  FireEvent("EventCloseChessShop")
end

function AutoChessMainPanel:onEventChessBattleCheckEnd()
  self:onRoundStageTip("result")
  self:updatePlayerItems()
  self:updateStagePanel()
  FireEvent("EventGuideUpdateStep")
  local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
  local isGuideEnd = ed.AutoChessTeachManager:isGuideEnd()
  if isGuideFlag and isGuideEnd then
    local battleHeroData = ed.AutoChessModel:getBattleHeroData()
    local hids = {}
    local positions = {}
    for k, battleHero in pairs(battleHeroData) do
      local chessHero = ed.AutoChessModel:getChessHeroBySid(battleHero.heroSid)
      local hid = chessHero:getChessId()
      local pos = battleHero.posIndex
      table.insert(hids, hid)
      table.insert(positions, pos)
    end
    ed.AutoChessNetwork:sendChessFinishGuide(hids, positions)
  end
end

function AutoChessMainPanel:stopAllChessPlayerBattle()
  for _, playerItem in pairs(self.playerItemList) do
    playerItem:stopBattleEffect()
  end
end

function AutoChessMainPanel:onEventChessRoundOver()
  self:stopAllChessPlayerBattle()
  ed.AutoChessManager:stopBattleEndCheck()
  self.battleScene:setSpeedRate(1)
  self:updatePlayerItems()
  self:onRoundStageTip("over")
  self:startTimer()
  ed.engine:clearChessNpc()
  self:updateStagePanel()
  ed.engine:clearAllChessUnits()
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, heroData in pairs(battleData) do
    if type(heroData) == "table" then
      local chessHero = ed.AutoChessModel:getChessHeroBySid(heroData.heroSid)
      local heroPos = self:getHeroPosByIndex(heroData.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        show_tag = true,
        show_pet = true
      })
    end
  end
end

function AutoChessMainPanel:enterStage()
  local stage = ed.AutoChessManager:getChessStage()
  if stage == ed.AutoChessManager.GAMESTAGE.START then
    self:onEventChessRoundStart()
  elseif stage == ed.AutoChessManager.GAMESTAGE.PREPARE then
    self:onEventChessRoundPrepare()
  elseif stage == ed.AutoChessManager.GAMESTAGE.LOCK then
    self:onEventChessRoundLock()
  elseif stage == ed.AutoChessManager.GAMESTAGE.BATTLE then
    ed.AutoChessManager:enterStage(ed.AutoChessManager.GAMESTAGE.WAITTING)
    self:onEventChessBattleCheckEnd()
    self:startTimer()
  elseif stage == ed.AutoChessManager.GAMESTAGE.OVER then
    self:onEventChessRoundOver()
  end
end

function AutoChessMainPanel:handlerGoldTipClick()
  self.ui.bg_gold_tip:setVisible(not self.ui.bg_gold_tip:isVisible())
  local gainGold = ed.AutoChessModel:getGainGold()
  if gainGold.comboV > gainGold.comboD then
    ed.setString(self.ui.Label_10191_Copy1, T("\232\191\158\232\131\156\239\188\154"))
  else
    ed.setString(self.ui.Label_10191_Copy1, T("\232\191\158\232\180\165\239\188\154"))
  end
  ed.setString(self.ui.label_gold_base, "+" .. gainGold.gainBase)
  ed.setString(self.ui.label_gold_add, "+" .. gainGold.gainInst)
  ed.setString(self.ui.label_gold_extra, "+" .. gainGold.comboD)
end

function AutoChessMainPanel:onHeadTouchBegan(x, y)
  self.isMoving = false
  self.startX, self.startY = nil, nil
  for index = 1, 8 do
    self.chessHeadTouched["img_slot_" .. index] = false
    local heroId = ed.AutoChessModel:getChessHeroByIndex(index)
    local isValid = not self.selectChess and self.selectSlot == 0
    if ed.containsPoint(self.ui["img_slot_" .. index], x, y) and isValid then
      self.startX, self.startY = x, y
      self.selectSlot = index
      self.lockSlots[index] = true
      self.chessHeadTouched["img_slot_" .. index] = true
      if heroId then
        self:playSelectIconAnimate()
      end
    end
  end
end

function AutoChessMainPanel:onHeadTouchMove(x, y)
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "slot", slot = 1})
  local isGuideFlag2, nextFlag2 = ed.AutoChessTeachManager:checkGuideStep({type = "hero"})
  nextFlag = nextFlag or nextFlag2
  if isGuideFlag and not nextFlag then
    return
  end
  for slot = 1, 8 do
    local heroId = ed.AutoChessModel:getChessHeroByIndex(slot)
    if self.chessHeadTouched["img_slot_" .. slot] and heroId then
      if not self.fakeActor or tolua.isnull(self.fakeActor) then
        local heroSid = ed.AutoChessModel:getChessHeroByIndex(slot)
        local chessHero = ed.AutoChessModel:getChessHeroBySid(heroSid)
        local chessId = chessHero:getChessId()
        self.fakeActor = ed.readhero.getChessActor(chessId, "Idle")
        self.fakeActor:setScale(0.6)
        self.fakeActor:setOpacity(60)
        self.mainLayer:addChild(self.fakeActor, 999)
        self:addFca(self.fakeActor)
        self.fakeActor:useShader("NanaShader")
      end
      self.fakeActor:setPosition(ccp(x, y))
      local pos = ed.toLogicPosition({x, y})
      local battlePos, newIndex = self:getPlaceAndIndex(pos)
      local newPosIndex = ed.AutoChessModel.posTransform.posToIndex[newIndex]
      newPosIndex = newPosIndex or 0
      self:resetSelectTag(newPosIndex)
      self.ui.img_slot_select:setVisible(false)
      for slot = 1, 8 do
        if ed.containsPoint(self.ui["img_slot_" .. slot], x, y) and self.selectSlot ~= slot then
          self.ui.img_slot_select:setVisible(true)
          local slotPos = ccp(self.ui["img_slot_" .. slot]:getPosition())
          self.ui.img_slot_select:setPosition(slotPos)
        end
      end
      if ed.containsPoint(self.ui.btn_shop, x, y) then
      end
      self.isMoving = true
      break
    end
  end
end

function AutoChessMainPanel:onHeadTouchEnd(x, y)
  self:removeSelectedIconAnimate(self.selectSlot)
  self:clearFakeActor()
  self.ui.img_slot_select:setVisible(false)
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({
    type = "slot",
    slot = self.selectSlot
  })
  if isGuideFlag then
    local curPos = ccp(x - 50 - ed.display.halfFixedWidth * 0.7, y - 265)
    if not self:isValidJoinBattlePos(curPos) then
      return
    end
  end
  if ed.containsPoint(self.ui.btn_shop, x, y) then
    local chessHeroSid = ed.AutoChessModel:getChessHeroByIndex(self.selectSlot)
    ed.AutoChessNetwork:sendChessSellHero(chessHeroSid)
    return
  end
  for slot = 1, 8 do
    if ed.containsPoint(self.ui["img_slot_" .. slot], x, y) then
      if self.selectSlot == slot then
        local isMoveTap = self.startX and x - self.startX < 10 and self.startY and 10 > y - self.startY
        if not self.isMoving or isMoveTap then
          ed.playEffect(ed.sound.deo.common_click_feedback)
          local chessHeroSid = ed.AutoChessModel:getChessHeroByIndex(slot)
          self:showChessDetail(chessHeroSid)
        end
      else
        self:onEventSwitchSlot(slot)
        self.chessHeadTouched["img_slot_" .. self.selectSlot] = false
      end
      self.lockSlots[self.selectSlot] = false
      self.selectSlot = 0
      self.isMoving = false
      return
    end
  end
  self:onEventJoinBattle(ed.toLogicPosition({x, y}), x, y)
  self.chessHeadTouched["img_slot_" .. self.selectSlot] = false
  self.lockSlots[self.selectSlot] = false
  self.selectSlot = 0
  self.isMoving = false
end

function AutoChessMainPanel:onEventChessHeadTouch(event, x, y)
  if event == "began" then
    self:onHeadTouchBegan(x, y)
  elseif event == "moved" then
    self:onHeadTouchMove(x, y)
  elseif event == "ended" then
    self.endX, self.endY = x, y
    self:onHeadTouchEnd(x, y)
    self.selectSlot = 0
  end
end

function AutoChessMainPanel:registerChessTouchEvents()
  self.chessHeadTouched = {}
  
  local function heroTouchHandler(event, x, y)
    self:onEventChessHeadTouch(event, x, y)
    self:onEventChessHeroTouch(ed.toLogicPosition({x, y}), x, y, event)
  end
  
  table.insert(self.handlerList, heroTouchHandler)
end

function AutoChessMainPanel:checkNextPower()
  local powerCDs = ed.AutoChessManager.heroPowerCD or {}
  for k, v in ipairs(powerCDs) do
    if 0 < v then
      return v
    end
  end
  return 0
end

function AutoChessMainPanel:registerTouchEvents()
  self.handlerList = {}
  ed.UITool.registerBtn(self, "btn_shop", function()
    self:handlerShopClick()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_role", function()
    self:handlerLevelUpClick()
  end)
  ed.UITool.registerBtn(self, "btn_undo", function()
    self:handlerStageTestClick()
  end)
  ed.UITool.registerBtn(self, "btn_reset", function()
    self:handlerResetTestClick()
  end)
  ed.UITool.registerBtn(self, "btn_npc", function()
    self:handlerStageNpcClick()
  end)
  ed.UITool.registerBtn(self, "btn_quit", function()
    self:handlerQuitClick()
  end)
  ed.UITool.registerBtn(self, "btn_damage", function()
    self:showCampDamagePanel()
  end)
  ed.UITool.registerBtn(self, "btn_open_damage", function()
    FireEvent("AutoChessClickDamage")
    self:showDamagePanel(not self.isShowDamage)
  end)
  ed.UITool.registerBtn(self, "img_pet_bg", function()
    ed.ui.AutoChessPetBagWin.create():popWindow()
    self.ui.img_pet_bag_selected:setVisible(true)
  end)
  ed.UITool.registerBtn(self, "btn_power", function()
    local powers = ed.AutoChessModel:getPlayerPowers(ed.ChessPlayer.getMyUserKey())
    local isTipVis = self.ui.bg_power_detail:isVisible()
    if powers and powers[1] then
      self.ui.bg_power_detail:setVisible(not isTipVis)
    elseif self:checkNextPower() > 0 then
      self.ui.bg_power_detail:setVisible(not isTipVis)
    elseif ed.AutoChessModel.selectPowerIds then
      ed.ui.AutoChessSelectPowerWin.create()
    end
  end, {pressScale = 0.95})
  self:registerChessTouchEvents()
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.bg_gold_tip:setVisible(false)
      self:onEventChessHeadTouch(event, x, y)
      self:onEventChessHeroTouch(ed.toLogicPosition({x, y}), x, y, event)
      self.ui.bg_power_detail:setVisible(false)
    end,
    priority = -1,
    key = "autoChessMainPanelTouch"
  })
  self:btRegisterOutClick({
    area = self.ui.layer_oppo_item,
    key = "clickOutPlayerList",
    clickHandler = function()
      self:showPlayerTeamPanel(false)
    end,
    force = true
  })
end

function AutoChessMainPanel:onEventBuyChessHeroSuccess(chessHero, index)
  if index and 0 < index then
    ed.playEffect(ed.sound.deo.common_coin_change)
    local insid = chessHero:getHeroInsid()
    local heroSlot = self.heroSlots["slot_" .. index]
    if not heroSlot then
      self:updateSingleSlot("on", index, insid)
    end
  end
  self:updateGold()
end

function AutoChessMainPanel:onPowerGetChessHero(chessHero, index)
  if index and 0 < index then
    ed.playEffect(ed.sound.deo.common_coin_change)
    local insid = chessHero:getHeroInsid()
    local heroSlot = self.heroSlots["slot_" .. index]
    if not heroSlot then
      self:updateSingleSlot("on", index, insid)
    end
  end
end

function AutoChessMainPanel:handlerSendTeamData(limit)
  if ed.AutoChessModel:isMySelfDead() then
    return
  end
  if ed.AutoChessTeachManager:isGuideFlag() then
    return
  end
  if ed.AutoChessManager:isPrepareStage() then
    local endTime = ed.AutoChessModel:getPrepareEndTime()
    local leftSec = endTime - ed.getServerTime()
    if not limit or limit >= leftSec then
      if not ed.chess_debug_mode then
        local battleCache = self:getSendTeamData()
        local sendData = battleCache.send
        ed.AutoChessNetwork:sendChessSetLineup(sendData.sids, sendData.positions)
      end
      return true
    end
  end
end

function AutoChessMainPanel:onEventChessSellHero(heroSid, diffGold)
  self:updateGold()
  FireEvent("EffectAddTotalGold", diffGold)
  if self.selectChess and self.selectChess.heroSid == heroSid then
    self:resetSelectTag()
    self.selectChess = nil
  end
  for slot = 1, 8 do
    local slotSid = ed.AutoChessModel:getChessHeroByIndex(slot)
    if slotSid and slotSid == heroSid then
      self:updateSingleSlot("off", slot)
      self:removeSelectedIconAnimate(slot)
      self.selectSlot = 0
      ed.setString(self.ui.label_pet_equip, ed.AutoChessModel:getEquipPetNum())
      return
    end
  end
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, heroData in pairs(battleData) do
    if type(heroData) == "table" and heroData.heroSid == heroSid then
      ed.engine:delChessUnitFromBattle(heroSid, true)
      ed.AutoChessModel:updateBattleHeroData("off", {
        pos = heroData.posIndex
      })
      self:handlerSendTeamData()
      self:updateTeamLimit()
      ed.setString(self.ui.label_pet_equip, ed.AutoChessModel:getEquipPetNum())
      return
    end
  end
end

function AutoChessMainPanel:onEventChessComposeHero(insid, hero_insids)
  ed.playEffect(ed.sound.autochess.lvup)
  local isComposeAdd = false
  for index = 1, 8 do
    local chessHeroId = ed.AutoChessModel:getChessHeroByIndex(index)
    if chessHeroId then
      if ed.isElementInTable(chessHeroId, hero_insids) and chessHeroId ~= insid then
        self:updateSingleSlot("off", index)
      elseif chessHeroId == insid then
        isComposeAdd = true
        self:updateSingleSlot("on", index, chessHeroId, true)
      end
    end
  end
  local isTeamChanged = false
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, battleHero in pairs(battleData) do
    local battleSid = battleHero.heroSid
    local posIndex = battleHero.posIndex
    if ed.isElementInTable(battleSid, hero_insids) and battleSid ~= insid then
      ed.engine:delChessUnitFromBattle(battleSid)
      ed.AutoChessModel:updateBattleHeroData("off", {pos = posIndex})
      isTeamChanged = true
    elseif battleSid == insid then
      isComposeAdd = true
      ed.engine:delChessUnitFromBattle(insid)
      local chessHero = ed.AutoChessModel:getChessHeroBySid(battleSid)
      local heroPos = self:getHeroPosByIndex(battleHero.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        withEffect = true,
        hero = chessHero,
        show_tag = true,
        show_pet = true
      })
      isTeamChanged = true
    end
  end
  if isTeamChanged then
    self:handlerSendTeamData()
    self:updateTeamLimit()
  end
  if not isComposeAdd then
    local slot = ed.AutoChessModel:getFreeSlot()
    self:updateSingleSlot("on", slot, insid, true)
  end
end

function AutoChessMainPanel:autoShowDamagePanel()
end

function AutoChessMainPanel:resetSelectTag(fromIndex, toIndex)
  for k, tagSprite in pairs(self.selectTag) do
    if tagSprite then
      tagSprite:setVisible(false)
      tagSprite:setOpacity(255)
    end
    local fromKey = fromIndex and ed.AutoChessModel.posTransform.indexToPos["id_" .. fromIndex] or nil
    local toKey = toIndex and ed.AutoChessModel.posTransform.indexToPos["id_" .. toIndex] or nil
    if fromKey and k == fromKey then
      tagSprite:setVisible(true)
    end
    if toKey and k == toKey and fromKey ~= toKey then
      tagSprite:setVisible(true)
      tagSprite:setOpacity(100)
    end
  end
end

function AutoChessMainPanel:onEventChessRoundBattle(record)
  FireEvent("EventCloseOtherWin")
  ed.playEffect(ed.sound.deo.battle_begin)
  self:onRoundStageTip("battle")
  self:autoShowDamagePanel()
  self:resetSelectTag()
  self:updateStagePanel()
  self.battleScene:setSpeedRate(2)
  ed.engine:clearAllChessUnits()
  ed.engine:clearChessNpc()
  ed.engine.ticks = 0
  ed.engine.time_limit = 120
  if ed.AutoChessModel:isMySelfDead() then
    return
  end
  self.ui.img_oppo_bg:setVisible(true)
  local checkId = record._checkid or 0
  local gameId = record._gameid or 0
  local round = record._round or 0
  local showTime = record._time or 0
  local battleData = record._battle or {}
  local rseed = battleData._rseed
  local selfPowers = battleData._self_powers
  local oppoPowers = battleData._oppo_powers
  local oppoType = ed.AutoChessModel:getOppoType()
  if oppoType == "monster" then
    ed.setLabelString(self.ui.label_target, T("\230\128\170\231\137\169"))
  elseif oppoType == "player" then
    local user = battleData._oppo_user
    local oppoName = user._user_summary._name or "NickName"
    ed.setLabelString(self.ui.label_target, oppoName)
  end
  self:startTimer(showTime)
  ed.srand(rseed)
  self:initDamageData(battleData._self_team._heroes, battleData._oppo_team._heroes)
  local num = 0
  if type(battleData._oppo_team._heroes) == "table" then
    local battleHeroes = battleData._oppo_team._heroes
    local battlePositions = battleData._oppo_team._positions
    for i, heroData in ipairs(battleHeroes) do
      local chessHero = ed.ChessHero.create(heroData, false)
      local heroPos = self:getHeroPosByIndex(battlePositions[i])
      ed.engine:onPrepareJoinBattle({
        pos = ccp(ed.engine.stage_rect.maxX - heroPos.x, heroPos.y),
        hero = chessHero,
        camp = ed.emCampEnemy,
        still_show = true,
        addPet = true
      })
    end
  end
  if type(battleData._self_team._heroes) == "table" then
    local battleHeroes = battleData._self_team._heroes
    local battlePositions = battleData._self_team._positions
    for i, heroData in ipairs(battleHeroes) do
      local chessHero = ed.ChessHero.create(heroData, false)
      local heroPos = self:getHeroPosByIndex(battlePositions[i])
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        still_show = true,
        addPet = true
      })
      num = num + 1
    end
  end
  local myTeamData = ed.AutoChessModel:getSelfTeamData()
  for slot = 1, 8 do
    local slotSid = ed.AutoChessModel:getChessHeroByIndex(slot)
    if slotSid then
      for i, teamHero in ipairs(myTeamData.heroes or {}) do
        if slotSid == teamHero._insid then
          self:updateSingleSlot("off", slot)
        end
      end
    else
      self:updateSingleSlot("off", slot)
    end
  end
  ed.setString(self.ui.label_hero_cur, num)
  ed.engine:createChessNpcUnit(selfPowers, oppoPowers)
  ed.AutoChessManager:startBattleEndCheck()
  ed.AutoChessManager:setBtStartTime()
end

function AutoChessMainPanel:onEventChessBuyExp(diffLv)
  self:updateTeamPanel()
  self:updateTeamLimit()
  self:updateGold()
  self:handlerSendTeamData()
  for _, playerItem in pairs(self.playerItemList) do
    if playerItem:isMySelf() then
      playerItem:updateLevel()
      break
    end
  end
  self.levelFca:setVisible(true)
  if 0 < diffLv then
    self.levelFca:setAction("Start2")
    FireEvent("EffectUpdateLimit", "total")
  else
    self.levelFca:setAction("Start")
  end
end

function AutoChessMainPanel:startChessPlayerBattle(userKey)
  if type(userKey) ~= "table" then
    return
  end
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    playerItem:showBattleEffect()
  end
end

function AutoChessMainPanel:stopChessPlayerBattle(userKey, isHurt, diffHp)
  if type(userKey) ~= "table" then
    return
  end
  local playerItem = self.playerItemList[userKey._user_id .. "_" .. userKey._server_id]
  if playerItem then
    playerItem:stopBattleEffect()
    playerItem:showHurtEffect(isHurt, diffHp)
  end
end

function AutoChessMainPanel:clearHeroSlots()
  for index = 1, 8 do
    self:updateSingleSlot("off", index)
  end
end

function AutoChessMainPanel:onEventChessPlayerDead()
  ed.engine:clearAllChessUnits()
  self:clearHeroSlots()
  self.ui.img_oppo_bg:setVisible(false)
  self:showQuitBtn()
end

function AutoChessMainPanel:autoCollectLoots()
  if #self.lootNodes > 0 then
    ed.playEffect(ed.sound.autoCollectLoot)
  end
  for _, lootNode in ipairs(self.lootNodes) do
    if lootNode and not tolua.isnull(lootNode) then
      lootNode.boxfca:setAction("Opening")
      self:listenTimer(Timer:Once(1.3), function()
        lootNode.boxfca:setAction("Opened")
        local lootData = lootNode.lootData
        local petIcon = ed.readpet.createChessIcon({
          type = lootData.loot._pid
        })
        petIcon.icon:setScale(0.6)
        local lootPos = ed.getWorldPos(lootNode)
        petIcon.icon:setPosition(lootPos)
        self.mainLayer:addChild(petIcon.icon, 99)
        lootNode:removeFromParentAndCleanup(true)
        local targetPos = ed.getWorldPos(self.ui.img_pet_bg)
        local flyAction = Actions.flyNodeToMakerAndCleanup(petIcon.icon, targetPos, function()
          FireEvent("EventChessUpdatePet", "total")
        end)
        local finalAction = CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), flyAction))
        petIcon.icon:runAction(finalAction)
      end)
    end
  end
  self.lootNodes = {}
end

function AutoChessMainPanel:showBattleMosterLoot(unit)
  if type(unit) == "table" then
    local isMonster = unit.info and unit.info["Unit Type"] == "Monster"
    if not isMonster then
      return
    end
    local lootData = ed.AutoChessModel:getBattleLootPet(unit.insid)
    if lootData then
      local pos = FlipXPosition({
        unit.position[1],
        unit.position[2]
      })
      local realPos = ed.toViewPosition(pos, 0)
      local lootNode = ed.ui.AutoChessUITool.createLootNode(realPos, lootData)
      self.mainLayer:addChild(lootNode, 99)
      table.insert(self.lootNodes, lootNode)
    end
  end
end

function AutoChessMainPanel:onEventChessUpdatePet(type, withAction)
  if type == "total" then
    local totalPet = #ed.AutoChessModel:getDropPetData()
    ed.setString(self.ui.label_pet_num, totalPet)
    ed.ui.AutoChessUITool.playScaleTipAction(self.ui.label_pet_num)
  elseif type == "equip" then
    local equipNum = 0
    local dropPetData = ed.AutoChessModel:getDropPetData()
    for _, pet in ipairs(dropPetData) do
      if pet:isEquiped() then
        equipNum = equipNum + 1
      end
    end
    ed.setString(self.ui.label_pet_equip, equipNum)
    if withAction then
      ed.ui.AutoChessUITool.playScaleTipAction(self.ui.label_pet_equip)
    end
  end
end

function AutoChessMainPanel:onEventEnterBackground()
end

function AutoChessMainPanel:onEventEnterForeground()
  if not ed.getUserid() then
    return
  end
  ed.socket_long_chess.recv()
  print("<<<<<<<<<<<<<<<<<< AutoChessMainPanel EnterForeground >>>>>>>>>>>>>>>>>>")
  ed.AutoChessNetwork:checkReconnect()
  ed.AutoChessNetwork:createHeartBeat()
end

function AutoChessMainPanel:playSelectIconAnimate(preIndex)
  if preIndex ~= 0 then
    self:removeSelectedIconAnimate(preIndex)
  end
  self:removeSelectedIconAnimate(self.selectSlot)
  local index = self.selectSlot
  if 0 < index then
    local effect = ed.createFcaNode("eff_UI_battle_skill_can_switch")
    local imgSlot = self.ui["img_slot_" .. index]
    imgSlot:addChild(effect)
    local size = imgSlot:getContentSize()
    effect:setPosition(ccp(size.width / 2 - 2, 34))
    effect:setScale(1)
    imgSlot.selectedEffect = effect
    self:addFca(effect)
  end
end

function AutoChessMainPanel:onEventChessUpdateTag(isTagEffect, tags)
  if not isTagEffect or #tags == 0 then
    return
  end
  for _, tag in ipairs(tags) do
    for _, unit in ipairs(ed.engine.unit_list) do
      if unit.camp == ed.emCampPlayer then
        local tagNodes = unit.actor.tagNodes
        if type(tagNodes) == "table" and tagNodes[tag] then
          ed.ui.AutoChessUITool.playBlinkTipAction(tagNodes[tag])
        end
      end
    end
  end
end

function AutoChessMainPanel:onEventChessJoinGame()
  self:initPlayerItems()
end

function AutoChessMainPanel:sortDamageList(camp)
  local panelHeight = self.ui.Panel_damage_list_1:getContentSize().height
  local offsetY = panelHeight
  local dataStatistic = camp == ed.emCampPlayer and self.damageStatistic.myTeam or self.damageStatistic.oppoTeam
  local maxDamage = 0
  for _, data in ipairs(dataStatistic) do
    if maxDamage < data.damage then
      maxDamage = data.damage
    end
  end
  for i, data in ipairs(dataStatistic) do
    local unit = data.unit
    local damageItem = self.damageDragItems["sid_" .. unit.insid]
    damageItem:updateDamage(data.damage, maxDamage)
    local damageNode = damageItem:getRootNode()
    local _, lastPosY = damageNode:getPosition()
    local newPosY = offsetY - 38 * i
    if lastPosY ~= newPosY then
      local moveAction = CCMoveTo:create(0.3, ccp(0, newPosY))
      damageNode:stopAllActions()
      damageNode:runAction(CCEaseIn:create(moveAction, 0.3))
    end
  end
end

function AutoChessMainPanel:updateDamageData(unit, damage)
  local statisticData = unit.camp == ed.emCampPlayer and self.damageStatistic.myTeam or self.damageStatistic.oppoTeam
  for _, data in ipairs(statisticData) do
    if data.unit.insid == unit.insid then
      data.damage = data.damage + math.floor(damage)
    end
  end
  table.sort(statisticData, function(a, b)
    return a.damage > b.damage
  end)
  self:sortDamageList(unit.camp)
end

function AutoChessMainPanel:onEventEquipChessPet(insid)
  for index = 1, 8 do
    local chessHeroId = ed.AutoChessModel:getChessHeroByIndex(index)
    if chessHeroId and chessHeroId == insid then
      self:updateSingleSlot("on", index, chessHeroId, false, true)
      FireEvent("EventChessUpdatePet", "equip", true)
      return
    end
  end
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, battleHero in pairs(battleData) do
    local battleSid = battleHero.heroSid
    if battleSid == insid then
      FireEvent("EventChessUpdatePet", "equip", true)
      if ed.AutoChessManager:getChessStage() == ed.AutoChessManager.GAMESTAGE.LOCK or ed.AutoChessManager:getChessStage() == ed.AutoChessManager.GAMESTAGE.BATTLE or ed.AutoChessManager:getChessStage() == ed.AutoChessManager.GAMESTAGE.WAITTING then
        return
      end
      ed.engine:delChessUnitFromBattle(insid)
      local chessHero = ed.AutoChessModel:getChessHeroBySid(battleSid)
      local heroPos = self:getHeroPosByIndex(battleHero.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        show_tag = true,
        show_pet = true
      })
      return
    end
  end
end

function AutoChessMainPanel:onEventExchangeChessPet(fromSid, toSid)
  for index = 1, 8 do
    local chessHeroId = ed.AutoChessModel:getChessHeroByIndex(index)
    if chessHeroId and (chessHeroId == toSid or chessHeroId == fromSid) then
      self:updateSingleSlot("on", index, chessHeroId, false, true)
    end
  end
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, battleHero in pairs(battleData) do
    local battleSid = battleHero.heroSid
    if battleSid == fromSid or battleSid == toSid then
      if ed.AutoChessManager:getChessStage() == ed.AutoChessManager.GAMESTAGE.LOCK or ed.AutoChessManager:getChessStage() == ed.AutoChessManager.GAMESTAGE.BATTLE or ed.AutoChessManager:getChessStage() == ed.AutoChessManager.GAMESTAGE.WAITTING then
        return
      end
      ed.engine:delChessUnitFromBattle(battleSid)
      local chessHero = ed.AutoChessModel:getChessHeroBySid(battleSid)
      local heroPos = self:getHeroPosByIndex(battleHero.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        show_tag = true,
        show_pet = true
      })
    end
  end
end

function AutoChessMainPanel:registerEvents()
  self:listenEvent("AutoChessSelectPowerSuccess", function()
    self:refreshPowerBtn()
  end)
  self:listenEvent("EventBuyChessHeroSuccess", function(chessHero, index)
    self:onEventBuyChessHeroSuccess(chessHero, index)
  end)
  self:listenEvent("AutoChessSelectPowerWinPop", function()
    ed.ui.AutoChessSelectPowerWin.create()
  end)
  self:listenEvent("ChessPowerGetHero", function(chessHero, index)
    self:onPowerGetChessHero(chessHero, index)
  end)
  self:listenEvent("ChessPowerGetGold", function()
    self:updateGold()
  end)
  self:listenEvent("AutoChessClickTagPanel", function()
    self:showDamagePanel(false)
  end)
  self:listenEvent("AutoChessClickStickerPanel", function()
    self:showDamagePanel(false)
  end)
  self:listenEvent("EventChessSellHero", function(chessHero, price)
    self:onEventChessSellHero(chessHero, price)
  end)
  self:listenEvent("EventChessComposeHero", function(insid, hero_insids)
    self:onEventChessComposeHero(insid, hero_insids)
  end)
  self:listenEvent("EventChessRoundStart", function()
    self:onEventChessRoundStart()
  end)
  self:listenEvent("EventChessRoundPrepare", function()
    self:onEventChessRoundPrepare()
  end)
  self:listenEvent("EventChessRoundLock", function()
    self:onEventChessRoundLock()
  end)
  self:listenEvent("EventChessRoundBattle", function(record)
    self.selectChess = nil
    self:onEventChessRoundBattle(record)
  end)
  self:listenEvent("EventChessRoundOver", function()
    self:onEventChessRoundOver()
  end)
  self:listenEvent("EventChessBuyExp", function(diffLv)
    self:onEventChessBuyExp(diffLv)
  end)
  self:listenEvent("EventShopDataRefresh", function()
    self:updateGold()
  end)
  self:listenEvent("EventChessBattleCheckEnd", function()
    self:onEventChessBattleCheckEnd()
  end)
  self:listenEvent("ChessEventBattleStart", function(userKey)
    self:startChessPlayerBattle(userKey)
  end)
  self:listenEvent("ChessEventBattleOver", function(userKey, isHurt, diffHp)
    self:stopChessPlayerBattle(userKey, isHurt, diffHp)
  end)
  self:listenEvent("EventChessShopClosed", function()
    self.isShopOpen = false
  end)
  self:listenEvent("EventChessOverNotify", function()
    self.battleScene:exit()
  end)
  self:listenEvent("EventChessPlayerDead", function()
    self:onEventChessPlayerDead()
  end)
  self:listenEvent("EventChessEventNotify", function()
    self:updatePlayerItems()
  end)
  self:listenEvent("EventChessBattleConfirm", function()
    self:onRoundStageTip("result")
    self:updatePlayerItems()
    self:autoCollectLoots()
  end)
  self:listenEvent("UnitDie", function(unit, killer)
    self:showBattleMosterLoot(unit)
  end)
  self:listenEvent("EventChessUpdatePet", function(type, withAction)
    self:onEventChessUpdatePet(type)
  end)
  self:listenEvent("applicationDidEnterBackground", function()
    self:onEventEnterBackground()
  end)
  self:listenEvent("applicationWillEnterForeground", function()
    self:onEventEnterForeground()
  end)
  self:listenEvent("EventGuideNextStep", function()
    if ed.AutoChessTeachManager:isMainGuideType() and ed.AutoChessTeachManager:isGuideFlag() then
      ed.AutoChessTeachManager:createTeach(self.mainLayer)
      local guideType = ed.AutoChessTeachManager.guideType
      if guideType == "slot" then
        self.selectSlot = ed.AutoChessTeachManager.guideParam
        self:playSelectIconAnimate()
      end
    end
  end)
  self:listenEvent("EventGuideStartTimer", function()
    if ed.AutoChessTeachManager:isGuideFlag() then
      self:startTimer()
    end
  end)
  self:listenEvent("EventGuideUpdateStep", function()
    if ed.AutoChessTeachManager:isGuideFlag() then
      ed.AutoChessTeachManager:runNextRoundState()
    end
  end)
  self:listenEvent("EventCloseChessDetail", function()
    self.isShowDetail = false
  end)
  self:listenEvent("EventChessUpdateTag", function(isTagEffect, tags)
    self:onEventChessUpdateTag(isTagEffect, tags)
  end)
  self:listenEvent("EventChessJoinReply", function()
    self:onEventChessJoinGame()
  end)
  self:listenEvent("EventResolveRookie", function()
    ed.replaceScene(ed.ui.AutoChessArenaScene.create())
  end)
  self:listenEvent("EventUnitTakeDamage", function(unit, damage)
    self:updateDamageData(unit, damage)
  end)
  self:listenEvent("EventEquipChessPet", function(insid)
    self:onEventEquipChessPet(insid)
  end)
  self:listenEvent("EventReplaceChessPet", function(insid)
    self:onEventEquipChessPet(insid)
  end)
  self:listenEvent("EventExchangeChessPet", function(fromSid, toSid)
    self:onEventExchangeChessPet(fromSid, toSid)
  end)
  self:listenEvent("EventCloseOtherWin", function()
    self:showDamagePanel(false)
  end)
  self:listenEvent("AutoChessUpdatePlayerLevel", function()
    for _, playerItem in pairs(self.playerItemList) do
      playerItem:updateLevel()
    end
  end)
  self:listenEvent("EventChessChatContentNotify", function(data)
    self:showChatContent(data)
  end)
end

function AutoChessMainPanel:registerEffectEvents()
  self:listenEvent("EffectAddTotalGold", function(num)
    ed.playEffect(ed.sound.deo.common_coin_change)
    ed.ui.AutoChessUITool.addFloatActionTip(self.ui.label_gold, {
      text = "+" .. num,
      size = 44,
      offsetX = 23,
      offsetY = 23
    })
    ed.ui.AutoChessUITool.playScaleTipAction(self.ui.label_gold)
  end)
  self:listenEvent("EffectUpdateLimit", function(type)
    if type == "current" then
      ed.ui.AutoChessUITool.playScaleTipAction(self.ui.label_hero_cur)
    elseif type == "total" then
      ed.ui.AutoChessUITool.playScaleTipAction(self.ui.label_hero_limit)
    end
  end)
  self:listenEvent("AutoChessPetBagWinClose", function(type)
    self.ui.img_pet_bag_selected:setVisible(false)
  end)
  self:listenEvent("EffectUpdatePlayerHp", function(index, num)
    local playerItem = self.playerItemList[index]
    if playerItem and not tolua.isnull(playerItem:getRootNode()) then
      playerItem:showHurtEffect()
      ed.ui.AutoChessUITool.addFloatActionTip(playerItem:getRootNode(), {
        text = "-" .. num,
        color = ccc3(255, 0, 0),
        size = 20,
        offsetX = 16,
        offsetY = 13
      })
    end
  end)
  self:listenEvent("EventSortPlayerIcon", function()
    self:sortPlayerItems()
  end)
end

function AutoChessMainPanel:refreshPowerBtn()
  local powers = ed.AutoChessModel:getPlayerPowers(ed.ChessPlayer.getMyUserKey())
  if powers and powers[1] then
    self.ui.btn_power:setVisible(true)
    local powerId = powers[1]._id
    local frame = ed.createChessPowerIcon(powerId)
    ed.UITool.replaceUINew(self.ui, "icon_power", frame)
    self.ui.Label_823:setVisible(false)
    self.ui.btn_select_power:setVisible(false)
    local powerInfo = ed.getDataTable("ChessHeroPower")[powerId]
    ed.setLabelDimensions(self.ui.power_detail, CCSizeMake(200, 0))
    ed.setString(self.ui.power_detail, powerInfo.Description)
  elseif ed.AutoChessModel.heroPowerCD then
    self.ui.btn_power:setVisible(true)
    local nextPowerCD = self:checkNextPower()
    if 0 < nextPowerCD then
      ed.setString(self.ui.power_detail, T("%d\229\155\158\229\144\136\229\144\142\232\167\163\233\148\129\232\139\177\233\155\132\232\131\189\229\138\155", nextPowerCD))
      local contentSize = self.ui.power_detail:getContentSize()
      ed.setString(self.ui.Label_823, nextPowerCD .. T("\229\155\158\229\144\136"))
      self.ui.Label_823:setVisible(true)
      self.ui.btn_select_power:setVisible(false)
    else
      self.ui.Label_823:setVisible(false)
      self.ui.btn_select_power:setVisible(true)
    end
  else
    self.ui.btn_power:setVisible(false)
  end
  local contentSize = self.ui.power_detail:getContentSize()
  self.ui.bg_power_detail:setContentSize(CCSizeMake(contentSize.width + 20, contentSize.height + 20))
  ed.layout.centerInParent(self.ui.power_detail)
  ed.UITool.setPositionBy(self.ui.power_detail, ccp(0, 2.5))
end

function AutoChessMainPanel:onEnter()
  ed.AutoChessNetwork:createHeartBeat()
  ed.playMusic(ed.music.autochess)
  self:updateGold()
  self:updateTeamPanel()
  self:updateTeamLimit()
  self:initPlayerItems()
  self:initHeroSlots()
  self:initTagPanel()
  self:initStickerPanel()
  self:initLevelFca()
  self:initStageInfo()
  self:initPetInfo()
  self:showDamagePanel(false)
  self:enterStage()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerEffectEvents()
  local fca = ed.createFcaNode("eff_UI_Stargate_Battle")
  self:addFca(fca)
  ed.UITool.replaceUINew(self.ui, "img_target_tip", fca)
  self:refreshPowerBtn()
  local marquee = ed.AutoChessMarqueeManager
  marquee:init({
    container = self.mainLayer
  })
  marquee:start()
  FireEvent("EventGuideUpdateStep")
end

function AutoChessMainPanel:adaptUI()
  self.adaptScale = math.min(1, ed.display.winSize.width / 1170)
  ed.layout.layoutWithMagin(self.ui.layer_oppo_item, {right = 10})
  ed.layout.layoutWithMagin(self.ui.bg_btn_tag, {left = 30})
  ed.layout.layoutWithMagin(self.ui.btn_quit, {left = 0, top = 0})
  ed.layout.layoutWithMagin(self.ui.img_prepare_bg, {top = 39}, true)
  ed.layout.layoutWithMagin(self.ui.img_oppo_bg, {right = 0})
  ed.layout.layoutWithMagin(self.ui.label_round, {right = 0})
  ed.layout.layoutWithMagin(self.ui.layer_oppo_item, {right = 0})
  ed.layout.layoutWithMagin(self.ui.btn_power, {left = 50})
  self.ui.layer_bottom:setScale(self.adaptScale)
  self.ui.label_exp_add:limitWidthByScale(60)
  ed.layout.horizontalSortNode({
    self.ui.label_victory_gold_title,
    self.ui.ImageView_12173_Copy0,
    self.ui.label_victory_gain_gold
  }, {
    -6,
    1,
    0
  }, self.ui.img_battle_victory_bg:getContentSize().width * 0.5)
end

function AutoChessMainPanel:destroy()
  print("<<<<<<<<<<< AutoChessMainPanel:destroy  >>>>>>>>>>>>>>>>>>")
  ed.AutoChessNetwork:doGameDisConnect()
  ed.AutoChessMarqueeManager:stopAndClear()
  ed.isBlurBg = self.oldBlurBg
  FireEvent("EventDestroyTagPanel")
  FireEvent("EventDestroyStickerPanel")
end

function AutoChessMainPanel.create()
  local self = base.create("AutoChessMainPanel", {notBlurBg = true, noShade = true})
  setmetatable(self, AutoChessMainPanel.mt)
  self.oldBlurBg = ed.isBlurBg
  ed.isBlurBg = false
  self:initData()
  self:initUI()
  self.mainLayer:registerScriptHandler(function(eventType)
    if "enter" == eventType then
      ed.AutoChessNetwork:sendChessLoading(100, 1)
      self:onEnter()
    elseif "exit" == eventType then
      self:destroy()
    end
  end)
  return self
end

function AutoChessMainPanel:initSelectTag()
  for index = 1, 12 do
    local posKey = ed.AutoChessModel.posTransform.indexToPos["id_" .. index]
    self.selectTag[posKey] = self.battleScene.ui[posKey]
  end
end

function AutoChessMainPanel:setBattleScene(scene)
  self.battleScene = scene
  self.battleScene:setSpeedRate(1)
  self:initSelectTag()
end

function AutoChessMainPanel:onEventSwitchSlot(newSlot)
  local heroSid = ed.AutoChessModel:getChessHeroByIndex(newSlot)
  if not heroSid then
    local preIndex = self.selectSlot
    local preSid = ed.AutoChessModel:getChessHeroByIndex(preIndex)
    if preSid and 0 < preSid then
      self:updateSingleSlot("off", preIndex)
      self:updateSingleSlot("on", newSlot, preSid)
    end
  elseif heroSid and 0 < heroSid then
    self:handlerChessExchange(3, {
      preIndex = self.selectSlot,
      newSlot = newSlot,
      heroSid = heroSid
    })
    self.lockSlots[self.selectSlot] = false
    self.selectSlot = 0
  end
end

function AutoChessMainPanel:onEventJoinBattle(pos, x, y)
  if not ed.chess_debug_mode and ed.AutoChessManager:getChessStage() ~= ed.AutoChessManager.GAMESTAGE.PREPARE then
    self:resetSelectTag()
    return
  end
  local funcs = self.functions
  local top = funcs.top()
  local buttom = funcs.buttom()
  local right = funcs.right(y)
  local left = funcs.left(y)
  if not self:isValidJoinBattlePos(pos) then
    self.selectChess = nil
    if ed.chess_debug_mode and chess_battle_debug and (right < pos.x or left > pos.x) and top > pos.y and buttom < pos.y then
      ed.engine.ticks = 0
      local posParam = {pos = pos}
      self:handlerJoinEnermyBattle(posParam)
    end
    self:resetSelectTag()
    return
  end
  local battlePos, index = self:getPlaceAndIndex(pos)
  local posParam = {pos = battlePos, index = index}
  self:handlerChessOperation(posParam)
end

function AutoChessMainPanel:clearFakeActor()
  if self.fakeActor and not tolua.isnull(self.fakeActor) then
    self.fakeActor:removeFromParentAndCleanup(true)
    self.fakeActor = nil
  end
end

function AutoChessMainPanel:handlerChessJoinBattle(heroSid, pos, posIndex)
  if ed.AutoChessTeachManager:isGuideFlag() then
    local curStep = ed.AutoChessTeachManager.curStep
    if curStep == 3 or curStep == 7 or curStep == 17 then
      ed.AutoChessTeachManager:updateStep(true, ccp(pos.x, pos.y + 265))
    end
  end
  local chessHero = ed.AutoChessModel:getChessHeroBySid(heroSid)
  ed.AutoChessModel:updateBattleHeroData("on", {pos = posIndex, heroSid = heroSid})
  local info = {
    hero = chessHero,
    pos = pos,
    show_tag = true,
    show_pet = true,
    addPet = ed.chess_debug_mode
  }
  ed.engine:onPrepareJoinBattle(info, true)
  self:updateSingleSlot("off", self.selectSlot)
  self:removeSelectedIconAnimate(self.selectSlot)
  self:handlerSendTeamData()
  self:updateTeamLimit()
  FireEvent("EffectUpdateLimit", "current")
  self.lockSlots[self.selectSlot] = false
  self.selectSlot = 0
  self.selectChess = nil
end

function AutoChessMainPanel:showSelectTag(posIndex)
  local posKey = ed.AutoChessModel.posTransform.indexToPos["id_" .. posIndex]
  self:resetSelectTag()
  if self.selectTag[posKey] then
    self.selectTag[posKey]:setVisible(true)
  end
end

function AutoChessMainPanel:handlerChessExchange(type, param)
  if type == 1 then
    if ed.AutoChessTeachManager:isGuideFlag() then
      return
    end
    local slot = param.slot
    local pos = param.pos
    local posIndex = param.posIndex
    local battleHero = param.battleHero
    local battleHeroSid = battleHero.heroSid
    ed.engine:delChessUnitFromBattle(battleHeroSid, true)
    local heroSid = ed.AutoChessModel:getChessHeroByIndex(slot)
    if heroSid and 0 < heroSid then
      self:handlerChessJoinBattle(heroSid, pos, posIndex)
    end
    self:updateSingleSlot("on", slot, battleHeroSid)
  elseif type == 2 then
    local preIndex = param.preIndex
    local preHero = param.preHero
    local curHero = param.curHero
    local curIndex = param.curIndex
    if preIndex == curIndex then
      local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "hero"})
      if isGuideFlag then
        if nextFlag then
          ed.AutoChessTeachManager:updateStep(nextFlag)
          FireEvent("EventGuideStartTimer")
        else
          return
        end
      end
      local isMoveTap = self.startX and self.endX - self.startX < 10 and self.startY and 10 > self.endY - self.startY
      if not self.isMoving or isMoveTap then
        ed.playEffect(ed.sound.deo.common_click_feedback)
        local chessHeroSid = preHero.heroSid
        self:showChessDetail(chessHeroSid)
      end
      return
    end
    ed.AutoChessModel:updateBattleHeroData("on", {
      pos = preIndex,
      heroSid = curHero.heroSid
    })
    ed.AutoChessModel:updateBattleHeroData("on", {
      pos = curIndex,
      heroSid = preHero.heroSid
    })
    local heroSid = preHero.heroSid
    local pos = self:getHeroPosByIndex(curIndex)
    ed.engine:moveChessUnitFromBattle(heroSid, pos)
    heroSid = curHero.heroSid
    pos = self:getHeroPosByIndex(preIndex)
    ed.engine:moveChessUnitFromBattle(heroSid, pos)
    self:handlerSendTeamData()
    self:showSelectTag(curIndex)
  elseif type == 3 then
    local preIndex = param.preIndex
    local heroSid = param.heroSid
    local newSlot = param.newSlot
    local preSid = ed.AutoChessModel:getChessHeroByIndex(preIndex)
    if preSid and 0 < preSid then
      self:updateSingleSlot("on", preIndex, heroSid, false, true)
      self:updateSingleSlot("on", newSlot, preSid, false, true)
    end
  end
end

function AutoChessMainPanel:handlerChessOperation(param)
  local pos, index = param.pos, param.index
  local posIndex = ed.AutoChessModel.posTransform.posToIndex[index]
  local battleHero = ed.AutoChessModel:getBattleHeroByPos(posIndex)
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "slot", slot = 1})
  local isGuideFlag2, nextFlag2 = ed.AutoChessTeachManager:checkGuideStep({type = "hero"})
  nextFlag = nextFlag or nextFlag2
  if isGuideFlag and not nextFlag then
    return
  end
  if not battleHero then
    local heroSid = self.selectSlot > 0 and ed.AutoChessModel:getChessHeroByIndex(self.selectSlot) or 0
    if 0 < heroSid then
      self:handlerChessJoinBattle(heroSid, pos, posIndex)
      return
    end
    if self.selectChess then
      local preIndex = self.selectChess.posIndex
      ed.AutoChessModel:updateBattleHeroData("off", {pos = preIndex})
      ed.AutoChessModel:updateBattleHeroData("on", {
        pos = posIndex,
        heroSid = self.selectChess.heroSid
      })
      local heroSid = self.selectChess.heroSid
      ed.engine:moveChessUnitFromBattle(heroSid, pos)
      self:handlerSendTeamData()
      self:showSelectTag(posIndex)
      self.selectChess = nil
      self.selectBattleIndex = 0
    end
  elseif battleHero then
    if self.selectSlot <= 0 and self.selectChess == nil then
      return
    end
    if self.selectSlot > 0 then
      self:handlerChessExchange(1, {
        slot = self.selectSlot,
        pos = pos,
        posIndex = posIndex,
        battleHero = battleHero
      })
      self.selectSlot = 0
      return
    end
    if self.selectChess ~= nil then
      self:handlerChessExchange(2, {
        curHero = battleHero,
        curIndex = posIndex,
        preIndex = self.selectBattleIndex,
        preHero = self.selectChess
      })
      self.selectChess = nil
      self.selectBattleIndex = 0
      return
    end
  end
end

function AutoChessMainPanel:showChessDetail(chessHeroSid)
  if chessHeroSid then
    self.isShowDetail = true
    local heroDetailWin = ed.ui.AutoChessHeroDetailWin.create(chessHeroSid)
    heroDetailWin:popWindow()
  end
end

function AutoChessMainPanel:onHeroTouchBegan(pos, x, y)
  if not ed.chess_debug_mode and ed.AutoChessManager:getChessStage() ~= ed.AutoChessManager.GAMESTAGE.PREPARE then
    return false
  end
  local isValid = not self.selectChess and self.selectSlot == 0
  if not isValid then
    return
  end
  if not self:isValidJoinBattlePos(pos) then
    return
  end
  local battlePos, index = self:getPlaceAndIndex(pos)
  self.startX, self.startY = x, y
  local posIndex = ed.AutoChessModel.posTransform.posToIndex[index]
  local battleHero = ed.AutoChessModel:getBattleHeroByPos(posIndex)
  if battleHero then
    self.selectChess = battleHero
    self.selectBattleIndex = posIndex
    self:showSelectTag(posIndex)
  end
end

function AutoChessMainPanel:onHeroTouchMove(pos, x, y)
  if not ed.chess_debug_mode and ed.AutoChessManager:getChessStage() ~= ed.AutoChessManager.GAMESTAGE.PREPARE then
    return
  end
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "prepare"})
  if isGuideFlag and not nextFlag then
    return
  end
  local battlePos, newIndex = self:getPlaceAndIndex(pos)
  local newPosIndex = ed.AutoChessModel.posTransform.posToIndex[newIndex]
  newPosIndex = newPosIndex or 0
  local showActor = 0 < self.selectBattleIndex
  if showActor then
    if 0 < newPosIndex then
      self:resetSelectTag(self.selectBattleIndex, newPosIndex)
    else
      self:resetSelectTag(self.selectBattleIndex)
    end
    if not self.fakeActor or tolua.isnull(self.fakeActor) then
      local battleHero = ed.AutoChessModel:getBattleHeroByPos(self.selectBattleIndex)
      local chessHero = ed.AutoChessModel:getChessHeroBySid(battleHero.heroSid)
      local chessId = chessHero:getChessId()
      self.fakeActor = ed.readhero.getChessActor(chessId, "Idle")
      self.fakeActor:setScale(0.6)
      self.fakeActor:setOpacity(60)
      self.mainLayer:addChild(self.fakeActor, 999)
      self:addFca(self.fakeActor)
      self.fakeActor:useShader("NanaShader")
    end
    self.fakeActor:setPosition(ccp(x, y))
    self.isMoving = true
    self.ui.img_slot_select:setVisible(false)
    for slot = 1, 8 do
      if ed.containsPoint(self.ui["img_slot_" .. slot], x, y) then
        self.ui.img_slot_select:setVisible(true)
        local slotPos = ccp(self.ui["img_slot_" .. slot]:getPosition())
        self.ui.img_slot_select:setPosition(slotPos)
        break
      end
    end
  end
end

function AutoChessMainPanel:onHeroTouchEnd(pos, x, y)
  if not ed.chess_debug_mode and ed.AutoChessManager:getChessStage() ~= ed.AutoChessManager.GAMESTAGE.PREPARE then
    return
  end
  if self.selectBattleIndex <= 0 or not self.selectChess then
    return
  end
  for slot = 1, 8 do
    if ed.containsPoint(self.ui["img_slot_" .. slot], x, y) then
      local heroSid = ed.AutoChessModel:getChessHeroByIndex(slot)
      if not heroSid then
        if not ed.AutoChessTeachManager:isGuideFlag() then
          self:handlerUndoClick(slot)
        end
      else
        if ed.AutoChessTeachManager:isGuideFlag() then
          self:resetSelectTag()
          self.selectChess = nil
          self.selectBattleIndex = 0
          return
        end
        local posIndex = self.selectBattleIndex
        local pos = self:getHeroPosByIndex(posIndex)
        self:handlerChessExchange(1, {
          slot = slot,
          pos = pos,
          posIndex = posIndex,
          battleHero = self.selectChess
        })
      end
      self:resetSelectTag()
      self.selectChess = nil
      self.selectBattleIndex = 0
      self.isMoving = false
      break
    end
  end
  self:clearFakeActor()
end

function AutoChessMainPanel:onEventChessHeroTouch(pos, x, y, event)
  if event == "began" then
    self:onHeroTouchBegan(pos, x, y, event)
  elseif event == "moved" then
    self:onHeroTouchMove(pos, x, y, event)
  elseif event == "ended" then
    self:onHeroTouchEnd(pos, x, y, event)
    self.selectBattleIndex = 0
    self.selectChess = nil
  end
end

function AutoChessMainPanel:getHeroPosByIndex(posIndex)
  local posKey = ed.AutoChessModel.posTransform.indexToPos["id_" .. posIndex]
  return self.heroPos[posKey]
end

function AutoChessMainPanel:isValidJoinBattlePos(pos)
  local funcs = self.functions
  local y = pos.y
  if y >= funcs.top() or y <= funcs.buttom() then
    return false
  end
  local x = pos.x
  local minX = funcs.left(y)
  local maxX = funcs.right(y)
  if x <= minX or x >= maxX then
    return false
  end
  return true
end

function AutoChessMainPanel:getPlaceAndIndex(pos)
  local funcs = self.functions
  local posy = pos.y
  local posx = pos.x
  local edge = {}
  edge.x1 = funcs.left(posy)
  edge.x2 = funcs.middle1(posy)
  edge.x3 = funcs.middle2(posy)
  edge.x4 = funcs.middle3(posy)
  edge.x5 = funcs.right(posy)
  edge.y1 = funcs.buttom()
  edge.y2 = funcs.buttom1()
  edge.y3 = funcs.top1()
  edge.y4 = funcs.top()
  for x = 1, 4 do
    if posx >= edge["x" .. x] and posx < edge["x" .. x + 1] then
      for y = 1, 3 do
        if posy >= edge["y" .. y] and posy < edge["y" .. y + 1] then
          if ed.chess_debug_mode then
            print("AutoChess__x = " .. x .. "_y = " .. y)
          end
          local index = x .. "_" .. y
          return self.heroPos[index], index
        end
      end
    end
  end
  return nil, "0_0"
end

function AutoChessMainPanel:removeSelectedIconAnimate(index)
  if not index or index <= 0 then
    return
  end
  local imgSlot = self.ui["img_slot_" .. index]
  if imgSlot.selectedEffect and not tolua.isnull(imgSlot.selectedEffect) then
    imgSlot.selectedEffect:removeFromParentAndCleanup(true)
    imgSlot.selectedEffect = nil
  end
end

function AutoChessMainPanel:getSendTeamData()
  local insids = {}
  local positions = {}
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, battleHero in pairs(battleData) do
    table.insert(insids, battleHero.heroSid)
    table.insert(positions, battleHero.posIndex)
  end
  local limit = ed.AutoChessModel:getTeamLimit()
  local sendSids = {}
  local sendPos = {}
  local undoSids = {}
  local undoPos = {}
  local retData = {
    send = {sids = insids, positions = positions},
    undo = {sids = undoSids, positions = undoPos}
  }
  self.undoCache = retData.undo
  return retData
end

function AutoChessMainPanel:handlerJoinEnermyBattle(param)
  local pos = param.pos
  local heroSlot = self.heroSlots["slot_" .. self.selectSlot]
  if heroSlot then
    local heroSid = ed.AutoChessModel:getChessHeroByIndex(self.selectSlot)
    local chessHero = ed.AutoChessModel:getChessHeroBySid(heroSid)
    local info = {
      hero = chessHero,
      pos = pos,
      camp = ed.emCampEnemy,
      show_tag = true,
      show_pet = true,
      addPet = ed.chess_debug_mode
    }
    ed.engine:onPrepareJoinBattle(info)
    self:removeSelectedIconAnimate(self.selectSlot)
    self.selectSlot = 0
  end
end

function AutoChessMainPanel:undoBattleHero(heroData, slot)
  local insid = heroData.heroSid
  ed.AutoChessModel:updateBattleHeroData("off", {
    pos = heroData.posIndex
  })
  ed.engine:delChessUnitFromBattle(insid, true)
  local heroSlot = self.heroSlots["slot_" .. slot]
  if not heroSlot then
    self:updateSingleSlot("on", slot, insid)
  end
  self:updateTeamLimit()
end

function AutoChessMainPanel:handlerUndoClick(slot)
  if not ed.chess_debug_mode and not ed.AutoChessManager:isPrepareStage() then
    return
  end
  local selectChess = self.selectChess
  if selectChess then
    local heroData = {
      heroSid = self.selectChess.heroSid,
      posIndex = self.selectChess.posIndex
    }
    self:undoBattleHero(heroData, slot)
    self:handlerSendTeamData()
    self.selectChess = nil
  end
end

function AutoChessMainPanel:handlerLevelUpClick()
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "exp"})
  if isGuideFlag then
    if not nextFlag then
    else
      ed.AutoChessTeachManager:dispatchGuideReply("buyexp")
      ed.AutoChessTeachManager:updateStep(true)
    end
    return
  end
  if ed.AutoChessModel:isMySelfDead() then
    ed.showToast(T("\228\189\160\229\183\178\232\162\171\230\183\152\230\177\176"))
    return
  end
  local gold = ed.AutoChessModel:getTotalGold()
  if gold < ed.AutoChessModel.LEVELGOLD then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
    return
  end
  local needExp = ed.AutoChessModel:getTeamNeedExp()
  if needExp == 0 then
    ed.showToast(T("\229\183\178\232\190\190\229\136\176\231\173\137\231\186\167\228\184\138\233\153\144"))
    return
  end
  if not ed.chess_debug_mode then
    ed.AutoChessNetwork:sendChessBuyExp()
  end
end

function AutoChessMainPanel:handlerShopClick()
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "openshop"})
  if isGuideFlag and not nextFlag then
    return
  end
  ed.playEffect(ed.sound.deo.common_click_feedback)
  if ed.AutoChessModel:isMySelfDead() then
    ed.showToast(T("\228\189\160\229\183\178\232\162\171\230\183\152\230\177\176"))
    return
  end
  self:showChessShop()
end

function AutoChessMainPanel:handlerStageTestClick(...)
  if self.stage == nil then
    self.stage = "start"
  end
  local round = ed.AutoChessModel:getBattleRound()
  if self.stage == "start" then
    ed.AutoChessManager:dispatchDebugNotify("round", self.stage, round)
    self.stage = "prepare"
  elseif self.stage == "prepare" then
    ed.AutoChessManager:dispatchDebugNotify("round", self.stage, 1)
    self.stage = "lock"
  elseif self.stage == "lock" then
    ed.AutoChessManager:dispatchDebugNotify("round", self.stage, round)
    self.stage = "battle"
  elseif self.stage == "battle" then
    ed.AutoChessManager:dispatchDebugNotify("round", self.stage, round)
    self.stage = "over"
  elseif self.stage == "over" then
    ed.AutoChessManager:dispatchDebugNotify("round", self.stage, round)
    ed.AutoChessModel:setBattleRound(round + 1)
    self.stage = "start"
  end
end

function AutoChessMainPanel:handlerResetTestClick(...)
  ed.engine:clearAllChessUnits()
  local battleData = ed.AutoChessModel:getBattleHeroData()
  for _, heroData in pairs(battleData) do
    if type(heroData) == "table" then
      local chessHero = ed.AutoChessModel:getChessHeroBySid(heroData.heroSid)
      local heroPos = self:getHeroPosByIndex(heroData.posIndex)
      ed.engine:onPrepareJoinBattle({
        pos = heroPos,
        hero = chessHero,
        show_tag = true,
        show_pet = true,
        addPet = ed.chess_debug_mode
      })
    end
  end
end

function AutoChessMainPanel:handlerStageNpcClick(...)
  ed.engine:clearChessNpc()
  ed.engine:createChessNpcUnit()
end

function AutoChessMainPanel:handlerQuitClick()
  if ed.chess_debug_mode then
    ed.scene:exit()
    return
  end
  local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
  ed.showConfirmDialog({
    text = isGuideFlag and T("\230\152\175\229\144\166\233\128\128\229\135\186\230\150\176\230\137\139\229\188\149\229\175\188\239\188\159") or T("\230\152\175\229\144\166\233\128\128\229\135\186\230\156\172\229\177\128\230\184\184\230\136\143\239\188\159"),
    leftHandler = function()
    end,
    rightHandler = function()
      local gameType = ed.AutoChessManager:getGameType()
      if gameType == "robot" or gameType == "rookie" or gameType == "normal" then
        ed.AutoChessNetwork:sendChessQuit()
        return
      end
      if isGuideFlag then
        ed.AutoChessNetwork:sendChessSkipGuide()
      end
    end
  })
end

function AutoChessMainPanel:initDamageList()
  self.myDamageList:clearList()
  local dy = 38
  local panelHeight = self.ui.Panel_damage_list_1:getContentSize().height
  local offsetY = panelHeight - dy
  for _, data in ipairs(self.damageStatistic.myTeam) do
    local unit = data.unit
    local damageItem = ed.ui.AutoChessDamageItem.create(data)
    local damageNode = damageItem:getRootNode()
    damageNode:setPosition(ccp(3, offsetY))
    self.myDamageList:addItem(damageNode)
    self.damageDragItems["sid_" .. unit.insid] = damageItem
    offsetY = offsetY - dy
  end
  self.myDamageList:initListHeight(dy * #self.damageStatistic.myTeam)
  self.oppoDamageList:clearList()
  panelHeight = self.ui.Panel_damage_list_2:getContentSize().height
  offsetY = panelHeight - dy
  for _, data in ipairs(self.damageStatistic.oppoTeam) do
    local unit = data.unit
    local damageItem = ed.ui.AutoChessDamageItem.create(data)
    local damageNode = damageItem:getRootNode()
    damageNode:setPosition(ccp(0, offsetY))
    self.oppoDamageList:addItem(damageNode)
    self.damageDragItems["sid_" .. unit.insid] = damageItem
    offsetY = offsetY - dy
  end
  self.oppoDamageList:initListHeight(dy * #self.damageStatistic.oppoTeam)
end

function AutoChessMainPanel:initDamageData(myTeamData, oppoTeamData)
  self.damageStatistic = {
    myTeam = {},
    oppoTeam = {}
  }
  if type(myTeamData) ~= "table" or type(oppoTeamData) ~= "table" then
    return
  end
  for _, heroData in ipairs(myTeamData) do
    table.insert(self.damageStatistic.myTeam, {
      unit = {
        insid = heroData._insid,
        tid = heroData._hid,
        rank = ed.getChessUnitStar(heroData._hid)
      },
      damage = 0
    })
  end
  for _, heroData in ipairs(oppoTeamData) do
    table.insert(self.damageStatistic.oppoTeam, {
      unit = {
        insid = heroData._insid,
        tid = heroData._hid,
        rank = ed.getChessUnitStar(heroData._hid)
      },
      damage = 0
    })
  end
  self:initDamageList()
end

function AutoChessMainPanel:updateShadowArea()
  local isVisible = self.selectSlot > 0 or self.selectChess ~= nil
  if self.selectSlot > 0 then
    local heroSid = ed.AutoChessModel:getChessHeroByIndex(self.selectSlot)
    isVisible = isVisible and heroSid and 0 < heroSid
  end
  if not ed.chess_debug_mode and isVisible then
    isVisible = ed.AutoChessManager:isPrepareStage()
  end
  self.battleScene:showChessHitArea(isVisible)
end

function AutoChessMainPanel:updateSlotEffect(dt)
end

function AutoChessMainPanel:update(dt)
  self:updateShadowArea()
  self:updateSlotEffect(dt)
  self:syncChatNodePos()
  local state = ed.AutoChessManager:getChessStage()
  local needCheck = state == ed.AutoChessManager.GAMESTAGE.BATTLE or state == ed.AutoChessManager.GAMESTAGE.WAITTING
  if needCheck then
    local eventTick = math.floor(self.eventTick)
    local eventData = ed.AutoChessModel:getBattleEventByTick(eventTick)
    if eventData and not eventData.isCasted then
      ed.AutoChessManager:handlerBattleEvent(eventData.events)
      eventData.isCasted = true
    end
  end
end

function AutoChessMainPanel:syncChatNodePos()
  if nil == self.playerChatNodeTab or not self.isSyncChatNodePos then
    return
  end
  for k, v in pairs(self.playerItemList) do
    local playerNode = v:getRootNode()
    local chatNode = self.playerChatNodeTab[k]
    if chatNode and playerNode then
      local chatPos = ccp(0, playerNode:getContentSize().height * 0.5)
      chatPos = playerNode:convertToWorldSpace(chatPos)
      chatPos = self.ui.layer_oppo_item:convertToNodeSpace(chatPos)
      chatNode:setPosition(chatPos)
    end
  end
end

function AutoChessMainPanel:showChatContent(data)
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
  if nil == playerChatNode then
    playerChatNode = CCNode:create()
    self.ui.layer_oppo_item:addChild(playerChatNode, 99)
    self.playerChatNodeTab[key] = playerChatNode
    local playerNode = playerItem:getRootNode()
    local chatPos = ccp(0, playerNode:getContentSize().height * 0.5)
    chatPos = playerNode:convertToWorldSpace(chatPos)
    chatPos = self.ui.layer_oppo_item:convertToNodeSpace(chatPos)
    playerChatNode:setPosition(chatPos)
  end
  ed.ui.KingsPvpChatSelectionWrap.createChatContent(playerChatNode, playerChatNode:convertToWorldSpace(ccp(0, 0)), data._content, true)
end
