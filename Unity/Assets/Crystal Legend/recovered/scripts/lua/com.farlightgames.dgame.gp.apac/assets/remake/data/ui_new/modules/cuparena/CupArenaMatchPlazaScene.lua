local base = ed.ui.CupArenaMatchBaseScene
local CupArenaMatchPlazaScene = newclass(base.mt)
ed.ui.CupArenaMatchPlazaScene = CupArenaMatchPlazaScene
local ViewType = {Camp = 1, Challenge = 2}

function CupArenaMatchPlazaScene.create(data)
  local self = base.create("CupArenaMatchPlazaScene")
  setmetatable(self, CupArenaMatchPlazaScene.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  return self
end

function CupArenaMatchPlazaScene:onEnter(...)
  base.onEnter(self)
  if self.isWaitCloseScene then
    self:closeCurrentScene()
    return
  end
  if ed.CupArenaManager.isFirstOpen then
    self:playEnterAction()
    self:playDialogShow("enter")
    ed.CupArenaManager.isFirstOpen = false
    FireEvent("EventCupArenaAuditionOpenPanel")
  end
  if self.isWaitOpenKnockoutScene then
    self.isWaitOpenKnockoutScene = nil
    ed.CupArenaNetwork:sendOpenPanel(false)
  end
  ed.CupArenaManager:checkGradeChangeEffect()
end

function CupArenaMatchPlazaScene:onExit(...)
  base.onExit(self)
end

function CupArenaMatchPlazaScene:initData(data)
  self.campTable = ed.getDataTable("CupArenaCamp")[ed.CupArenaManager:getCampId()]
  self.scheduleTableItem = ed.getDataTable("CupArenaSchedule")[ed.CupArenaManager:getScheduleId()]
end

function CupArenaMatchPlazaScene:initUI()
  base.initUI(self)
  local container, ui = ed.editorui(ed.uieditor.CupArenaMatchPlazaScene)
  self.container = container
  self.ui = ui
  self:addContentNode(container)
  self:adaptUI()
  self.ui.label_challenge_down:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_challenge_down, ed.toccc3(7031602), 2.5)
  ed.setLabelShadow(self.ui.label_challenge_down, ed.toccc3(8868157), ccp(1.5, 0))
  self.ui.label_challenge_up:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_challenge_up, ed.toccc3(14132040), 1.5)
  self.ui.label_challenge_down_dark:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_challenge_down_dark, ed.toccc3(7031602), 2.5)
  ed.setLabelShadow(self.ui.label_challenge_down_dark, ed.toccc3(8868157), ccp(1.5, 0))
  self.ui.label_challenge_up_dark:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_challenge_up_dark, ed.toccc3(14132040), 1.5)
  self.ui.label_camp_down:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_camp_down, ed.toccc3(7031602), 2.5)
  ed.setLabelShadow(self.ui.label_camp_down, ed.toccc3(8868157), ccp(1.5, 0))
  self.ui.label_camp_up:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_camp_up, ed.toccc3(14132040), 1.5)
  self.ui.label_camp_down_dark:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_camp_down_dark, ed.toccc3(7031602), 2.5)
  ed.setLabelShadow(self.ui.label_camp_down_dark, ed.toccc3(8868157), ccp(1.5, 0))
  self.ui.label_camp_up_dark:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_camp_up_dark, ed.toccc3(14132040), 1.5)
  ed.setLabelStroke(self.ui.label_defense, ed.toccc3(7886124), 1)
  ed.setLabelStroke(self.ui.label_my_score, ed.toccc3(5054069), 1)
  ed.setLabelStroke(self.ui.label_my_medal, ed.toccc3(5054069), 1)
  ed.setLabelStroke(self.ui.label_my_rank, ed.toccc3(5054069), 1)
  ed.setLabelStroke(self.ui.label_my_total_rank, ed.toccc3(5054069), 1)
  ed.setLabelStroke(self.ui.label_rank_for_camp, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_total_medal, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_task, ed.toccc3(3087902), 1)
  self.ui.bg_dialog:setVisible(false)
  self:initCampUI()
  self:initMatchInfoUI()
  self:refreshTaskRedPoint()
  self:refreshChallengeRedPoint()
  self.viewType = ViewType.Camp
  self:updateViewTypeTab()
  self:startTimer()
end

function CupArenaMatchPlazaScene:adaptUI(...)
  base.adaptUI(self, ...)
  local localDesignScale = 2.1666666666666665
  local localFixedWidth = ed.display.designSize.height * localDesignScale - ed.display.designSize.width
  local adaptRatio = math.min(ed.display.halfFixedWidth * 2 / localFixedWidth, 1)
  ed.layout.layoutWithMagin(self.ui.bg_challenge, {
    right = 50 + 30 * adaptRatio
  })
  ed.layout.layoutWithMagin(self.ui.bg_camp, {
    right = 220 + 30 * adaptRatio
  })
  ed.layout.layoutWithMagin(self.ui.btn_defense, {
    right = 390 + 30 * adaptRatio
  })
  local leftPanelRightPosX = self.baseui.panel_left:getContentSize().width + self.baseui.panel_left:getPositionX()
  local safeWidth = self.baseui.panel_right:getPositionX() - leftPanelRightPosX
  local minDesignScale = 1.7777777777777777
  local curScale = ed.display.winSize.width / ed.display.winSize.height
  local changeRatio = ed.clamp((curScale - minDesignScale) / (localDesignScale - minDesignScale), 0, 1)
  local heroFrameSize = self.ui.img_hero_frame:getContentSize()
  local heroFrameScale = 0.95 + 0.05 * changeRatio
  local infoSpaceX = -20 + 8 * changeRatio
  local infoFrameSize = self.ui.bg_my_info:getContentSize()
  local infoFrameScale = 0.85 + 0.15 * changeRatio
  local matchPanelWidth = heroFrameSize.width * heroFrameScale + infoFrameSize.width * infoFrameScale + infoSpaceX
  local matchFrameScale = math.min(safeWidth / matchPanelWidth, 1)
  heroFrameScale = heroFrameScale * matchFrameScale
  infoFrameScale = infoFrameScale * matchFrameScale
  infoSpaceX = infoSpaceX * matchFrameScale
  local matchStartX = leftPanelRightPosX + (safeWidth - matchPanelWidth * matchFrameScale) * 0.5
  self.ui.img_hero_frame:setScale(heroFrameScale)
  self.ui.img_hero_frame:setPositionX(matchStartX)
  local campInfoFrameScale = 0.75 + 0.25 * changeRatio
  self.ui.bg_camp_info:setScale(campInfoFrameScale)
  self.ui.bg_camp_info:setPositionX(math.max(leftPanelRightPosX + self.ui.bg_camp_info:getContentSize().width * campInfoFrameScale * 0.5, matchStartX + heroFrameSize.width * heroFrameScale * 0.5))
  matchStartX = matchStartX + heroFrameSize.width * heroFrameScale
  matchStartX = matchStartX + infoSpaceX
  self.ui.bg_my_info:setScale(infoFrameScale)
  self.ui.bg_my_info:setPositionX(matchStartX + infoFrameSize.width * infoFrameScale * 0.5)
  self.ui.bg_dialog:setScale(matchFrameScale)
  local frameSize = self.ui.img_hero_frame:getContentSize()
  local worldPos = self.ui.img_hero_frame:convertToWorldSpace(ccp(frameSize.width * 0.7, frameSize.height * 0.67))
  local localPos = self.ui.panel_match:convertToNodeSpace(worldPos)
  self.ui.bg_dialog:setPosition(localPos.x, localPos.y)
  local challengePanelWidth = self.ui.panel_challenge:getContentSize().width + 50
  local challengePanelScale = math.min(safeWidth / challengePanelWidth, 1)
  if challengePanelScale < 1 then
    self.ui.panel_challenge:setScale(challengePanelScale)
  end
  local startChallengePanelX = leftPanelRightPosX + (safeWidth - challengePanelWidth * challengePanelScale) * 0.5
  self.ui.panel_challenge:setPosition(startChallengePanelX, self.ui.panel_challenge:getContentSize().height * 0.5 * (1 - challengePanelScale))
  local frameSize = self.ui.img_hero_frame:getContentSize()
  local worldPos = self.ui.img_hero_frame:convertToWorldSpace(ccp(frameSize.width * 0.5, 0))
  local localPos = self.ui.bg_1:getParent():convertToNodeSpace(worldPos)
  self.ui.bg_1:setPosition(localPos.x + 10, localPos.y + 58)
  local bg2TopY = self.ui.bg_challenge:getPositionY() + 125
  local bg2Size = self.ui.bg_2:getContentSize()
  bg2Size.width = 1170 + ed.display.halfFixedWidth
  bg2Size.height = math.max(bg2TopY + ed.display.halfFixedHeight, 68)
  self.ui.bg_2:setContentSize(bg2Size)
  self.ui.bg_2:setPositionY(bg2TopY - bg2Size.height * 0.5)
  local cloudSize = self.ui.img_cloud:getContentSize()
  cloudSize.height = math.max(bg2Size.height, 170)
  cloudSize.width = 1170 + ed.display.halfFixedWidth
  self.ui.img_cloud:setContentSize(cloudSize)
  self.ui.img_cloud:setPosition(self.ui.bg_2:getPositionX(), self.ui.bg_2:getPositionY() + bg2Size.height * 0.5 - 0.5 * cloudSize.height)
end

function CupArenaMatchPlazaScene:initCampUI(...)
  local frameSize = self.ui.img_hero_frame:getContentSize()
  local fashionId
  local heroID = self.campTable["Camp Hero ID"]
  if fashionId and 0 < fashionId then
    local cardres = ed.lookupDataTable("Fashion", "Art Switch", fashionId)
    local card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_gate_shade.png", nil, CCSizeMake(-20, -8))
    local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashionId)
    local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashionId)
    if fashion_effect_res and fashionId == 13 and not ed.isAreaZhCn() then
      fashion_effect_res = fashion_effect_res .. "_globe"
    end
    if fashion_spine_res and ed.isSupportSpine() then
      local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, height / 928)
      spine:setAnimation(0, "Idle", true)
      local size = ci:getContentSize()
      spine:setPosition(-size.width / 2, -size.height / 2)
      card:addChild(spine)
      ui.card_fashion_spine = spine
    elseif fashion_effect_res then
      local effect_fca = ed.createFcaActor(fashion_effect_res)
      effect_fca:setLoop(true)
      effect_fca:setAction("Loop")
      card:addChild(effect_fca, 5)
      self:addFca(effect_fca)
    end
    local fashion_plist_res = ed.lookupDataTable("Fashion", "Plist", fashionId)
    if fashion_plist_res then
      local particle = CCParticleSystemQuad:create("UI/particle/" .. fashion_plist_res)
      card:addChild(particle, 6)
    end
    self.ui.img_hero_frame:addChild(card, -2)
    card:setPosition(ccp(frameSize.width * 0.5, frameSize.height * 0.5))
    card:setScale(0.8)
  else
    local cardres = ed.getUnitArt(heroID)
    local card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_gate_shade.png", nil, CCSizeMake(-20, -8))
    self.ui.img_hero_frame:addChild(card, -2)
    card:setPosition(ccp(frameSize.width * 0.5, frameSize.height * 0.5))
    card:setScale(0.8)
  end
  if nil == self.ui.heroLightFca then
    self.ui.heroLightFca = ed.createFcaNode("eff_UI_Main_Cuparena_flash")
    self.ui.img_hero_frame:addChild(self.ui.heroLightFca, -1)
    self:addFca(self.ui.heroLightFca)
    self.ui.heroLightFca:setPosition(ccp(frameSize.width * 0.5 + 10, frameSize.height * 0.5 - 55))
  end
  if nil == self.ui.campNameLabel then
    local nameLabel = ed.ui.gradientLabel.create({
      text = T("%s\233\152\181\232\144\165", self.campTable["Camp Name"]),
      fontSize = 25,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16772766),
      endColor = ed.toccc3(16711671),
      strokeSize = 1.5,
      strokeColor = ed.toccc3(15312648)
    })
    self.ui.bg_name:addChild(nameLabel.node)
    ed.layout.centerInParent(nameLabel.node)
    self.ui.campNameLabel = nameLabel
  else
    self.ui.campNameLabel:setString(T("%s\233\152\181\232\144\165", self.campTable["Camp Name"]))
    ed.layout.centerInParent(self.ui.campNameLabel.node)
  end
  ed.setLabelString(self.ui.label_rank_for_camp, T("\233\152\181\232\144\165\230\142\146\229\144\141\239\188\154%d", ed.CupArenaManager:getCampRank()))
  ed.setLabelString(self.ui.label_total_medal, T("\230\128\187\229\139\139\231\171\160\239\188\154%d", ed.CupArenaManager:getTotalMedal()))
  ed.setTexture(self.ui.img_camp, self.campTable["Camp Symbol Min"])
end

function CupArenaMatchPlazaScene:initMatchInfoUI()
  if nil == self.ui.myInfoTitleLabel then
    local titleLabel = ed.ui.gradientLabel.create({
      text = T("\230\136\145\231\154\132\228\191\161\230\129\175"),
      fontSize = 24,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16773995),
      endColor = ed.toccc3(16776911),
      strokeSize = 1.5,
      strokeColor = ed.toccc3(8803621)
    }).node
    self.ui.bg_my_info:addChild(titleLabel)
    self.ui.myInfoTitleLabel = titleLabel
    titleLabel:setPosition(ccp(380, 450))
    local myInfoBgSize = self.ui.bg_my_info:getContentSize()
    local leftLightFca = ed.createFcaNode("eff_UI_Main_Cuparena_light")
    self.ui.bg_my_info:addChild(leftLightFca, 0)
    leftLightFca:setPosition(ccp(99, myInfoBgSize.height * 0.5 - 21))
    self:addFca(leftLightFca)
    leftLightFca:setOpacity(0)
    local rightLightFca = ed.createFcaNode("eff_UI_Main_Cuparena_light")
    self.ui.bg_my_info:addChild(rightLightFca, 0)
    rightLightFca:setScaleX(-1)
    rightLightFca:setPosition(ccp(myInfoBgSize.width - 86.5, myInfoBgSize.height * 0.5 - 21))
    self:addFca(rightLightFca)
    rightLightFca:setOpacity(0)
    self:listenTimer(Timer:Once(0.1), function()
      leftLightFca:setOpacity(255)
      rightLightFca:setOpacity(255)
    end)
  end
  ed.setLabelString(self.ui.label_my_score, T("\231\167\175\229\136\134\239\188\154%d", ed.CupArenaManager:getScore()))
  ed.setLabelString(self.ui.label_my_medal, T("\229\139\139\231\171\160\239\188\154%d", ed.CupArenaManager:getMedal()))
  ed.setLabelString(self.ui.label_my_rank, T("\233\152\181\232\144\165\229\134\133\230\142\146\229\144\141\239\188\154%d", ed.CupArenaManager:getRank()))
  ed.setLabelString(self.ui.label_my_total_rank, T("\230\128\187\230\142\146\229\144\141\239\188\154%d", ed.CupArenaManager:getTotalRank()))
  ed.right2(self.ui.img_my_medal, self.ui.label_my_medal, 10)
  local gradeInfo = ed.CupArenaManager:getGradeInfoByScore(ed.CupArenaManager:getScore())
  ed.setTexture(self.ui.img_my_grade, gradeInfo.iconRes)
  ed.setTexture(self.ui.img_my_grade_name, gradeInfo.nameIconRes)
  self:updateTimeDesc()
end

function CupArenaMatchPlazaScene:updateViewTypeTab()
  local isChallenge = self.viewType == ViewType.Challenge
  self.ui.btn_challenge:setVisible(isChallenge)
  self.ui.btn_challenge_dark:setVisible(not isChallenge)
  local isCamp = self.viewType == ViewType.Camp
  self.ui.btn_camp:setVisible(isCamp)
  self.ui.btn_camp_dark:setVisible(not isCamp)
  self.ui.bg_challenge:setPositionY(isChallenge and -62.5 or -74)
  self.ui.bg_camp:setPositionY(isCamp and -62.5 or -74)
end

function CupArenaMatchPlazaScene:startTimer(...)
  self:listenTimer(Timer:Always(0.3), function()
    self:updateCountDownUI(false)
    if nil ~= self.ui.challengeui then
      self.ui.challengeui:updatePerHalfSecond()
    end
  end)
end

function CupArenaMatchPlazaScene:updateCountDownUI(isInit)
  if nil ~= self.endTime and self.endTime > 0 then
    local diffTime = self.endTime - ed.getServerTime()
    if nil ~= self.ui.countDownTimeLabel then
      self.ui.countDownTimeLabel:setString(ed.gethmsNString(math.max(diffTime, 0)))
    end
    if diffTime <= 0 then
      self.endTime = nil
      CloseTimer("match_plaza_refresh_panel")
      self:listenTimer(Timer:Once(isInit and 5 or 1, "match_plaza_refresh_panel"), function()
        ed.CupArenaNetwork:sendOpenPanel(false)
      end)
    end
  end
end

function CupArenaMatchPlazaScene:updateTimeDesc()
  self.endTime = ed.CupArenaManager:getEndTime()
  local desStr = self.scheduleTableItem["Win Describe"]
  desStr = string.format(desStr, "<lable fontSize=f35 fontName=fontBold color=empty startColor=0xffee9e endColor=0xfffef5 strokeColor=0xf09c2f strokeSize=2 name=timeLabel whole=true>000:00:00</lable>")
  if nil == self.ui.timeDesLabel then
    self.ui.timeDesLabel = ed.ui.autoText.new()
    self.ui.bg_my_info:addChild(self.ui.timeDesLabel.node)
  end
  local bgSize = self.ui.bg_my_info:getContentSize()
  self.ui.timeDesLabel:initParam({
    context = desStr,
    fontSize = 26,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(3087902),
    strokeSize = 1,
    lineSpacing = 4,
    maxWidth = bgSize.width - 260,
    align = "CENTER",
    isTripLastSpacing = true
  })
  local desWidth, desHeight = self.ui.timeDesLabel:getCurContentSize()
  self.ui.timeDesLabel.node:setPosition(ccp(10 + (bgSize.width - desWidth) * 0.5, (280 + desHeight - self.ui.timeDesLabel:getFirstLineHeight()) * 0.5))
  self.ui.countDownTimeLabel = self.ui.timeDesLabel:getLabelByName("timeLabel")
  if nil == self.ui.countDownTimeLabel then
    self.ui.bg_start_time:setVisible(false)
  else
    local timeLabelNode = self.ui.countDownTimeLabel.node
    local worldPos = timeLabelNode:getParent():convertToWorldSpace(ccp(timeLabelNode:getPosition()))
    local localPos = self.ui.bg_start_time:getParent():convertToNodeSpace(worldPos)
    localPos.y = localPos.y - 3
    self.ui.bg_start_time:setPosition(localPos)
  end
  self:updateCountDownUI(true)
end

function CupArenaMatchPlazaScene:registerTouchEvents(...)
  base.registerTouchEvents(self, ...)
  self:registerBtn(self.ui.btn_task, function()
    self:onTaskEvent()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.btn_defense, function()
    self:onDefenseEvent()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.img_hero_frame, function()
    self:onHeroFrameEvent()
  end)
  self:registerBtn(self.ui.img_my_medal, function()
    self:onMyMedalEvent()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.img_camp, function()
    self:onMyCampEvent()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.img_my_grade, function()
    self:onMyGradeEvent()
  end, {normalScale = 0.6, pressScale = 0.57})
  self:btRegisterButtonClick({
    button = self.ui.btn_challenge_dark,
    key = "btn_challenge_dark",
    clickHandler = function()
      self:onChallengeEvent()
    end,
    cancelPressHandler = function()
      self.ui.bg_challenge:setScale(1)
    end,
    pressHandler = function()
      self.ui.bg_challenge:setScale(0.95)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_camp_dark,
    key = "btn_camp_dark",
    clickHandler = function()
      self:onCampEvent()
    end,
    cancelPressHandler = function()
      self.ui.bg_camp:setScale(1)
    end,
    pressHandler = function()
      self.ui.bg_camp:setScale(0.95)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  })
end

function CupArenaMatchPlazaScene:onTaskEvent()
  if "BeforeAudition" == self.scheduleTableItem["State Type"] or "Audition" == self.scheduleTableItem["State Type"] then
    ed.CupArenaNetwork:sendOpenTask(true)
  else
    ed.showToast(T("\233\152\181\232\144\165\228\187\187\229\138\161\228\187\133\229\143\175\229\156\168\230\181\183\233\128\137\230\156\159\233\151\180\229\174\140\230\136\144"))
  end
end

function CupArenaMatchPlazaScene:onDefenseEvent()
  ed.CupArenaNetwork:sendGetDefensiveLineup()
end

function CupArenaMatchPlazaScene:onChallengeEvent()
  if self.viewType == ViewType.Challenge then
    return
  end
  if self.scheduleTableItem["State Type"] == "BeforeAudition" then
    ed.showToast(T("\229\139\135\232\128\133\230\140\145\230\136\152\229\176\154\230\156\170\229\188\128\229\167\139"))
  elseif self.scheduleTableItem["State Type"] == "AfterAudition" then
    ed.showToast(T("\229\139\135\232\128\133\230\140\145\230\136\152\231\187\147\231\174\151\228\184\173"))
  elseif self.scheduleTableItem["State Type"] == "Grouping" then
    ed.showToast(T("\229\183\133\229\179\176\232\181\155\229\136\134\231\187\132\228\184\173"))
  elseif self.scheduleTableItem["State Type"] == "Audition" then
    self.viewType = ViewType.Challenge
    self:updateViewTypeTab()
    self.ui.panel_challenge:setVisible(true)
    self.ui.panel_match:setVisible(false)
    if nil == self.ui.challengeui then
      self.ui.challengeui = ed.ui.CupArenaChallengeScene.create(self)
    end
    self.ui.challengeui:openView()
  end
end

function CupArenaMatchPlazaScene:onCampEvent()
  if self.viewType == ViewType.Camp then
    return
  end
  self.viewType = ViewType.Camp
  self:updateViewTypeTab()
  self.ui.panel_challenge:setVisible(false)
  self.ui.panel_match:setVisible(true)
  self:initCampUI()
  self:initMatchInfoUI()
  self:playSwitchAction()
end

function CupArenaMatchPlazaScene:registerEvents()
  base.registerEvents(self)
  self:listenEvent("EventCupArenaRefreshPlaza", function(data)
    self:initData(data)
    self:initMatchInfoUI()
    self:updateTimeDesc()
    if self.viewType == ViewType.Camp then
    else
      if self.viewType == ViewType.Challenge and self.scheduleTableItem["State Type"] ~= "Audition" then
        self:onCampEvent()
      else
      end
    end
  end)
  self:listenEvent("EventCupArenaGetDefensiveLineup", function(data)
    ed.ui.CupArenaDefensiveWin.create({lineups = data, isKnockout = false})
  end)
  self:listenEvent("EventCupArenaClickChallenge", function()
    self:onChallengeEvent()
  end)
  self:listenEvent("EventCupArenaRefreshKnockoutChallenge", function(data)
    if ed.getCurrentScene().identity == "CupArenaMatchPlazaScene" then
      ed.popScene()
      ed.pushScene(ed.ui.CupArenaKnockoutChallengeScene.create(data))
    else
      self.isWaitOpenKnockoutScene = true
    end
  end)
  self:listenEvent("EventCupArenaRefreshSchedule", function(data)
    if ed.getCurrentScene().identity == "CupArenaMatchPlazaScene" then
      ed.popScene()
      ed.pushScene(ed.ui.CupArenaKnockoutFinalScheduleScene.create(data))
    else
      self.isWaitOpenKnockoutScene = true
    end
  end)
  self:listenEvent("EventCupArenaFreshTask", function()
    ed.setLabelString(self.ui.label_my_medal, T("\229\139\139\231\171\160\239\188\154%d", ed.CupArenaManager:getMedal()))
    ed.setLabelString(self.ui.label_total_medal, T("\230\128\187\229\139\139\231\171\160\239\188\154%d", ed.CupArenaManager:getTotalMedal()))
  end)
  self:listenEvent("EventCupArenaOver", function()
    self:closeCurrentScene()
  end)
  self:listenEvent("EventCupArenaTaskEntryRed", function()
    self:refreshTaskRedPoint()
  end)
  self:listenEvent("EventCupArenaFirstChallengeRed", function()
    self:refreshChallengeRedPoint()
  end)
end

function CupArenaMatchPlazaScene:openRanklistWindow(tabIndex)
  ed.UITool.openView("CupArenaRankRewardPop", {page = "rank"})
end

function CupArenaMatchPlazaScene:onHeroFrameEvent()
  self:playDialogShow()
  if ed.CupArenaManager:getPaintTriggerTimes() < ed.CupArenaManager:getPaintTriggerRewardTimes() then
    ed.CupArenaNetwork:sendClickPaint()
  end
end

function CupArenaMatchPlazaScene:playDialogShow(type)
  local talkMsg = {}
  local talkTableItem = ed.getDataTable("CupArenaTalk")[ed.CupArenaManager:getCampId()][type == "enter" and "Welcome" or "Touch"]
  for i = 1, 4 do
    if talkTableItem["Talk " .. i] then
      table.insert(talkMsg, talkTableItem["Talk " .. i])
    end
  end
  if #talkMsg <= 0 then
    return
  end
  local dialogStr = talkMsg[math.random(1, #talkMsg)]
  dialogStr = string.gsub(dialogStr or "", "<lable purple>", "<lable color=ccc3(248,128,255) strokeColor=0x3c1d45 strokeSize=1>")
  if nil == self.ui.dialogLabel then
    self.ui.dialogLabel = ed.ui.autoText.new()
  end
  local dialogBgSize = self.ui.bg_dialog:getContentSize()
  self.ui.dialogLabel:initParam({
    context = dialogStr,
    fontSize = 16,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(3087902),
    strokeSize = 1,
    lineSpacing = 4,
    maxWidth = dialogBgSize.width - 60
  })
  local desWidth, desHeight = self.ui.dialogLabel:getCurContentSize()
  self.ui.bg_dialog:addChild(self.ui.dialogLabel.node)
  dialogBgSize.height = math.max(desHeight + 40, 69)
  self.ui.bg_dialog:setContentSize(dialogBgSize)
  self.ui.dialogLabel.node:setPosition(ccp((dialogBgSize.width - desWidth) * 0.5, (dialogBgSize.height + desHeight - self.ui.dialogLabel:getFirstLineHeight()) * 0.5 - 3))
  self.ui.bg_dialog:stopAllActions()
  self.ui.dialogLabel.node:stopAllActions()
  if not self.ui.bg_dialog:isVisible() then
    self.ui.bg_dialog:setVisible(true)
    self.ui.bg_dialog:setOpacity(0)
    self.ui.dialogLabel.node:setOpacity(0)
  end
  local showAction = CCFadeTo:create(0.01, 255)
  local delayAction = CCDelayTime:create(3)
  local hideAction = CCFadeTo:create(0.3, 0)
  local callFunc = CCCallFunc:create(function()
    self.ui.bg_dialog:setVisible(false)
  end)
  self.ui.bg_dialog:runAction(CCSequence:create(ccArrayMake(showAction, delayAction, hideAction, callFunc)))
  self.ui.dialogLabel.node:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.01, 255), CCDelayTime:create(3), CCFadeTo:create(0.3, 0))))
end

function CupArenaMatchPlazaScene:playSwitchAction()
  ed.setCascadeOpacityEnabled(self.ui.img_hero_frame, true, true)
  ed.setCascadeOpacityEnabled(self.ui.bg_camp_info, true, true)
  ed.setCascadeOpacityEnabled(self.ui.bg_my_info, true, true)
  self.ui.img_hero_frame:stopAllActions()
  self.ui.img_hero_frame:setOpacity(0)
  self.ui.img_hero_frame:runAction(CCFadeIn:create(0.3))
  self.ui.bg_camp_info:stopAllActions()
  self.ui.bg_camp_info:setOpacity(0)
  self.ui.bg_camp_info:runAction(CCFadeIn:create(0.3))
  self.ui.bg_my_info:stopAllActions()
  self.ui.bg_my_info:setOpacity(0)
  self.ui.bg_my_info:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.07), CCFadeIn:create(0.3)))
end

function CupArenaMatchPlazaScene:onMyMedalEvent()
  ed.UITool.openView("CupArenaRankRewardPop", {page = "reward", index = 3})
end

function CupArenaMatchPlazaScene:onMyCampEvent()
  ed.UITool.openView("CupArenaRankRewardPop", {page = "rank", index = 2})
end

function CupArenaMatchPlazaScene:onMyGradeEvent()
  ed.UITool.openView("CupArenaRankRewardPop", {page = "reward", index = 1})
end

function CupArenaMatchPlazaScene:closeCurrentScene()
  if ed.getCurrentScene().identity == "CupArenaMatchPlazaScene" then
    ed.popScene()
    ed.showToast(T("\229\165\179\231\165\158\228\185\139\230\136\152\229\183\178\231\187\147\230\157\159"))
  else
    self.isWaitCloseScene = true
  end
end

function CupArenaMatchPlazaScene:refreshTaskRedPoint()
  self.ui.img_task_red:setVisible(ed.CupArenaManager:getTaskRedFlag())
end

function CupArenaMatchPlazaScene:refreshChallengeRedPoint()
  self.ui.img_challenge_red:setVisible(ed.CupArenaManager:getFirstChallengeRedFlag())
end
