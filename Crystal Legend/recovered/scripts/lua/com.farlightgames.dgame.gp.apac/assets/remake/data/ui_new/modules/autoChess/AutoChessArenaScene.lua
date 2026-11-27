local base = ed.ui.commonscene
local AutoChessArenaScene = newclass(base.mt)
ed.ui.AutoChessArenaScene = AutoChessArenaScene
ed.UITool.registViewOpenFunc("AutoChessArenaScene", function(param)
  ed.AutoChessNetwork:sendChessOpenPanel()
end)

function AutoChessArenaScene:initData()
  self.prepare_time = 60
  self.used_time = 0
end

function AutoChessArenaScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 50, top = 18})
  ed.layout.layoutWithMagin(self.ui.btn_book, {right = 40, top = 18})
  ed.layout.layoutWithMagin(self.ui.btn_rank, {right = 110, top = 18})
  self.adaptScale = math.min(1, ed.display.winSize.width / 1170)
  self.ui.bg_season:setScale(self.adaptScale)
end

function AutoChessArenaScene:initLabels()
  ed.setLabelShadow(self.ui.labelGradeName, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.labelSeasonTimespan, ed.toccc3(5804768), 1)
  self.ui.label_season:setFontName(ed.fontBold)
  ed.setLabelShadow(self.ui.label_season, ed.toccc3(5213923), ccp(0, 3))
  self.ui.label_season_id:setFontName(ed.fontBold)
  ed.setLabelShadow(self.ui.label_season_id, ed.toccc3(5213923), ccp(0, 3))
  self.ui.label_rest:setFontName(ed.fontBold)
  ed.setLabelShadow(self.ui.label_rest, ed.toccc3(6110100), ccp(0, 3))
  ed.setLabelStroke(self.ui.label_compendium, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_rank, ccc3(20, 18, 18), 1)
  self.ui.Label_12119:setFontName(ed.fontBold)
  self.ui.Label_12121:setFontName(ed.fontBold)
  self.ui.Label_12118:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_12121, ed.toccc3(8801307), 2)
  ed.setLabelStroke(self.ui.Label_12119, ed.toccc3(8801307), 2)
  ed.setLabelStroke(self.ui.Label_12118, ed.toccc3(9662522), 2.5)
end

function AutoChessArenaScene:initFcaNode()
  local pvpFca = ed.createFcaNode("eff_UI_Chess_Captain")
  pvpFca:setPosition(ccp(87, 90))
  self.ui.layer_pvp:addChild(pvpFca)
  self:addFca(pvpFca)
  local pveFca = ed.createFcaNode("eff_UI_Chess_mode")
  pveFca:setStartAction("Idle_single")
  pveFca:setLoopAction("Idle_single")
  pveFca:setPosition(ccp(50, 10))
  pveFca:setScale(0.3)
  self.ui.layer_pve:addChild(pveFca)
  self:addFca(pveFca)
  local leisureFca = ed.createFcaNode("eff_UI_Chess_mode")
  leisureFca:setStartAction("Idle_team")
  leisureFca:setLoopAction("Idle_team")
  leisureFca:setPosition(ccp(80, 60))
  leisureFca:setScale(0.3)
  self.ui.layer_leisure:addChild(leisureFca)
  self:addFca(leisureFca)
end

function AutoChessArenaScene:initScore()
  ed.setString(self.ui.label_score, string.format(T("\231\167\175\229\136\134:%d"), ed.AutoChessManager:getScore()))
end

function AutoChessArenaScene:showResting()
  self.ui.layer_inseason:setVisible(false)
  self.ui.label_rest:setVisible(true)
end

function AutoChessArenaScene:refreshMyGradeInfo()
  local myGradeInfo = ed.AutoChessRankManager:getMyRankGradeInfo()
  local iconLightVis = ed.AutoChessRankManager:hasGradeRewardsNotBeTaken()
  ed.setString(self.ui.label_score, string.format(T("\231\167\175\229\136\134:%d"), ed.AutoChessRankManager:getMyRankScore()))
  ed.setString(self.ui.labelGradeName, myGradeInfo.name)
  ed.setTexture(self.ui.iconGrade, myGradeInfo.smallIconRes)
end

function AutoChessArenaScene:destroyFlyPanelTouchLayer()
  if not tolua.isnull(self.flyPanelTouchLayer) then
    self.flyPanelTouchLayer:removeFromParentAndCleanup(true)
  end
  self.flyPanelTouchLayer = nil
end

function AutoChessArenaScene:createFlyPanelTouchLayer(areaNode, clickoutCallback)
  self:destroyFlyPanelTouchLayer()
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local touchNode = ed.ui.basetouchnode.btCreate()
  layer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -999, true)
  self.flyPanelTouchLayer = layer
  self.mainLayer:addChild(layer)
  touchNode:btRegisterOutClick({
    area = areaNode,
    key = "flyPanelDestroy",
    clickHandler = function()
      self:destroyFlyPanelTouchLayer()
      clickoutCallback()
    end,
    priority = 1,
    force = true
  })
end

function AutoChessArenaScene:onClickSeasonReward()
end

function AutoChessArenaScene:refreshSeasonInfo()
  local seasonInfo = ed.AutoChessRankManager:getCurrentSeasonInfo()
  local rewards = seasonInfo.rewards
  if rewards and rewards[1] then
    local reward = rewards[1]
    local icon = ed.readequip.createIcon(reward.id, 0.9)
    ed.UITool.replaceUI(self.ui, "layer_inseason", "iconSeasonReward", icon)
  end
  ed.setString(self.ui.label_season_id, "S" .. seasonInfo.id)
  local time = ed.AutoChessRankManager:getRemainingTimeToCurrentSeasonEnd()
  ed.setString(self.ui.labelSeasonTimespan, string.format(T("\232\183\157\231\166\187\232\181\155\229\173\163\231\187\147\230\157\159\232\191\152\230\156\137%s"), time))
end

function AutoChessArenaScene:refreshRankLabels()
  local gradeName = ed.AutoChessRankManager:getSeasonRewardTargetGradeName()
  if gradeName then
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = string.format(T("\232\190\190\229\136\176<lable color=ccc3(255,187,71)>%s</lable>"), gradeName),
      color = ccc3(255, 234, 198),
      fontSize = 21
    })
    local width, height = autoText:getCurContentSize()
    local container = CCSprite:create()
    autoText.node:setPositionX(-width)
    container:addChild(autoText.node)
    ed.UITool.replaceUINew(self.ui, "labelSeasonRewardGradeTarget", container)
  end
end

function AutoChessArenaScene:showGradeChangePanel()
end

function AutoChessArenaScene:refreshRankInfo()
  if ed.AutoChessRankManager:isAtResting() then
    self:showResting()
    return
  else
    self.ui.label_rest:setVisible(false)
    self.ui.layer_inseason:setVisible(true)
  end
  self:refreshMyGradeInfo()
  self:refreshSeasonInfo()
  self:refreshRankLabels()
  self:listenTimer(Timer:Once(0.5), function()
    if ed.AutoChessRankManager:needShowGradePanelAtSeasonStart() then
      self:showGradeChangePanel()
    elseif ed.AutoChessRankManager:hasScoreDiff() then
      self:showGradeChangePanel()
    end
  end)
end

function AutoChessArenaScene:initRankInfo()
  if ed.AutoChessRankManager:isRankDataReady() then
    self:refreshRankInfo()
  end
end

function AutoChessArenaScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.AutoChessArenaScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackButton()
  self:setBackground("UI/alpha/1080P/battle_bg/bbg_chess.jpg")
  self.ui.title:setVisible(false)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\230\154\180\232\181\176\230\163\139"), self.ui.bg_title, {
    position = ccp(40, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:adaptUI()
  self:initLabels()
  self:initFcaNode()
  self:initScore()
  self:initRankInfo()
end

function AutoChessArenaScene:onPopScene()
  if ed.AutoChessManager.isMatching then
    ed.AutoChessManager:setMatching(false)
    ed.AutoChessNetwork:sendChessMatchCancel()
  end
  base.onPopScene(self)
end

function AutoChessArenaScene:onTeamJoin(reply, teamId)
  ed.AutoChessManager:setChessTeamId(teamId)
  ed.ui.AutoChessRoomPrepare.create({teamId = teamId}):popWindow()
  ed.AutoChessNetwork:createTeamHeartBeat()
end

function AutoChessArenaScene:registerEvents()
  self:listenEvent("EventChessLoadNotify", function()
    FireEvent("EventChessCloseTeamPrepare")
    ed.replaceScene(ed.ui.AutoChessLoadScene.create())
  end)
  self:listenEvent("applicationDidEnterBackground", function()
    FireEvent("AutoChessMatchWinClose")
  end)
  self:listenEvent("EventChessNotOpen", function()
    ed.showToast(T("\230\154\130\230\156\170\229\188\128\229\144\175"))
  end)
  self:listenEvent("RankDataReady", function()
    self:refreshRankInfo()
  end)
  self:listenEvent("AutoChessTookGradeRewards", function(gradeId, rewards)
    self:listenTimer(Timer:Once(0.1), function()
      self:refreshMyGradeInfo()
    end)
  end)
  self:listenEvent("MyRankScoreChanged", function(delay)
    self:refreshMyGradeInfo()
  end)
  self:listenEvent("EventChessTeamJoin", function(join, teamId)
    self:onTeamJoin(join, teamId)
  end)
  self:listenEvent("EventChessMatchStart", function(data)
    ed.ui.AutoChessMatchWin.create(data._expect_wait_time):popWindow()
  end)
end

function AutoChessArenaScene:onEnter()
  base.onEnter(self)
  local isGuide = ed.AutoChessManager.guideFlag == 1
  if isGuide then
    ed.showConfirmDialog({
      text = T("\230\152\175\229\144\166\232\191\155\229\133\165\230\150\176\230\137\139\229\188\149\229\175\188\239\188\159"),
      leftHandler = function()
        ed.AutoChessNetwork:sendChessSkipGuide()
      end,
      rightHandler = function()
        ed.AutoChessNetwork:sendChessStartGuide()
      end
    })
  end
  if ed.AutoChessManager:getTeamLeader() and #ed.AutoChessManager:getTeamMembers() > 0 then
    ed.ui.AutoChessRoomPrepare.create({
      teamId = ed.AutoChessManager:getChessTeamId()
    }):popWindow()
  end
  ed.player:requestPoint({
    "tavern_point",
    "tavern_point_weekly"
  })
end

function AutoChessArenaScene:onClickedOneBtn()
  local isOpen = ed.AutoChessManager:isChessModeOpen("robot")
  if not isOpen then
    ed.showToast(T("\230\154\130\230\156\170\229\188\128\229\144\175"))
    return
  end
  if ed.AutoChessManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  if ed.chess_debug_mode then
    ed.replaceScene(ed.ui.AutoChessLoadScene.create())
  else
    local version = ed.storage.getString("current-version")
    ed.AutoChessNetwork:sendChessMatchStart(version, "robot")
  end
end

function AutoChessArenaScene:onClickedTeamBtn()
  if ed.AutoChessRankManager:isAtResting() then
    ed.showToast(T("\230\150\176\232\181\155\229\173\163\229\135\134\229\164\135\228\184\173\239\188\140\229\143\175\232\191\155\232\161\140\228\188\145\233\151\178\230\168\161\229\188\143"))
    return
  end
  local isOpen = ed.AutoChessManager:isChessModeOpen("normal")
  if not isOpen then
    ed.showToast(T("\230\154\130\230\156\170\229\188\128\229\144\175"))
    return
  end
  if ed.AutoChessManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  if ed.chess_debug_mode then
    ed.ui.AutoChessMatchWin.create(1):popWindow()
  else
    local version = ed.storage.getString("current-version")
    ed.AutoChessNetwork:sendChessMatchStart(version, "normal")
  end
end

function AutoChessArenaScene:onClickLeisureBtn()
  if ed.AutoChessManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  ed.ui.AutoChessRoomSwitch.create():popWindow()
end

function AutoChessArenaScene:onClickBookBtn()
  ed.ui.AutoChessRaceWin.create():popWindow()
end

function AutoChessArenaScene:onClickRanklistBtn()
  if ed.AutoChessManager:getMatching() then
    ed.showToast(T("\229\140\185\233\133\141\228\184\173\230\151\160\230\179\149\230\159\165\231\156\139"))
    return
  end
  ed.UITool.openView("ranklist", {index = 4, index2 = 2})
end

function AutoChessArenaScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.AutoChessArenaRule.create():popWindow()
  end)
  ed.UITool.registerBtn(self, "layer_pve", function()
    self:onClickedOneBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "layer_pvp", function()
    self:onClickedTeamBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "layer_leisure", function()
    self:onClickLeisureBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_book", function()
    self:onClickBookBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rank", function()
    self:onClickRanklistBtn()
  end, {pressScale = 0.95})
end

function AutoChessArenaScene.create()
  local self = base.create("AutoChessArenaScene", {noBottomButton = true})
  setmetatable(self, AutoChessArenaScene.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:registerTouchEvents()
  return self
end
