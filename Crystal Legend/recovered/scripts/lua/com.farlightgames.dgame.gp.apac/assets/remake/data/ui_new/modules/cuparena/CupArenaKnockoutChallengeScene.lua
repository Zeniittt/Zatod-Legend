local base = ed.ui.CupArenaMatchBaseScene
local CupArenaKnockoutChallengeScene = newclass(base.mt)
ed.ui.CupArenaKnockoutChallengeScene = CupArenaKnockoutChallengeScene
local TeamUIConfig = {
  [1] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [4] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [5] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_5.png",
    teamColor = ed.toccc3(13625343),
    teamStrokeColor = ed.toccc3(2379449)
  },
  [6] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_6.png",
    teamColor = ed.toccc3(16776423),
    teamStrokeColor = ed.toccc3(7221115)
  },
  [7] = {
    bgPath = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_7.png",
    teamColor = ed.toccc3(16514997),
    teamStrokeColor = ed.toccc3(8621085)
  }
}

function CupArenaKnockoutChallengeScene.create(data)
  local self = base.create("CupArenaKnockoutChallengeScene")
  setmetatable(self, CupArenaKnockoutChallengeScene.mt)
  self:initData(data)
  self:initUI()
  self:registerEvents()
  self:registerTouchEvents()
  return self
end

function CupArenaKnockoutChallengeScene:initData(data)
  self.matchType = data.matchType
  self.data = data.data
end

function CupArenaKnockoutChallengeScene:initUI()
  base.initUI(self)
  local container, ui = ed.editorui(ed.uieditor.CupArenaKnockoutChallengeScene)
  self.container = container
  self.ui = ui
  self:addContentNode(container)
  self:adaptUI()
  ed.setLabelStroke(self.ui.label_race_des, ed.toccc3(8014891), 1)
  ed.setLabelStroke(self.ui.label_time_des, ed.toccc3(8014891), 1)
  ed.setLabelStroke(self.ui.label_race_info, ed.toccc3(4615232), 1)
  ed.setLabelStroke(self.ui.label_time_info, ed.toccc3(4615232), 1)
  ed.setLabelShadow(self.ui.label_oppo_des, ccc3(111, 58, 44), ccp(0, 1))
  ed.setLabelShadow(self.ui.label_adjust, ccc3(0, 0, 0), ccp(0, 1))
  ed.setLabelShadow(self.ui.label_schedule, ccc3(0, 0, 0), ccp(0, 1))
  ed.setLabelShadow(self.ui.label_gamble, ccc3(0, 0, 0), ccp(0, 1))
  ed.setLabelStroke(self.ui.label_self_camp, ed.toccc3(8014891), 1)
  ed.setLabelStroke(self.ui.label_self_rank, ed.toccc3(8014891), 1)
  ed.setLabelStroke(self.ui.label_summary, ed.toccc3(594187), 1)
  local myRaceTitleLabel = ed.ui.gradientLabel.create({
    text = T("\230\136\145\231\154\132\232\181\155\228\186\139"),
    fontSize = 28,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16773995),
    endColor = ed.toccc3(16776911),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(8803621)
  })
  self.ui.bg_detail:addChild(myRaceTitleLabel.node)
  myRaceTitleLabel.node:setPosition(ccp(self.ui.bg_detail:getContentSize().width * 0.5, 458))
  local myTeamTitleLabel = ed.ui.gradientLabel.create({
    text = T("\230\136\145\231\154\132\233\152\181\229\174\185"),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16768609),
    endColor = ed.toccc3(16776694),
    strokeSize = 1,
    strokeColor = ed.toccc3(6579300)
  })
  self.ui.bg_team:addChild(myTeamTitleLabel.node)
  myTeamTitleLabel.node:setPosition(ccp(170 + myTeamTitleLabel:getContentSize().width * 0.5, 432))
  local stageTitleLabel = ed.ui.gradientLabel.create({
    text = T("\229\134\179\230\136\152\232\141\163\232\128\128\233\152\182\230\174\181"),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16767577),
    endColor = ed.toccc3(16776871),
    strokeSize = 1,
    strokeColor = ed.toccc3(9849643)
  })
  self.ui.bg_team:addChild(stageTitleLabel.node)
  stageTitleLabel.node:setPosition(ccp(30 + self.ui.bg_team:getContentSize().width * 0.5, 502))
  local tipDesLabel = ed.ui.autoText.new()
  self.ui.bg_team_des:addChild(tipDesLabel.node)
  self.tipDesLabel = tipDesLabel
  self:initRaceInfoUI()
  self:updateTeamListUI()
  self:refreshTaskRedPoint()
  self:startTimer()
end

function CupArenaKnockoutChallengeScene:adaptUI(...)
  base.adaptUI(self, ...)
  local localDesignScale = 2.1666666666666665
  local localFixedWidth = ed.display.designSize.height * localDesignScale - ed.display.designSize.width
  local adaptRatio = math.min(ed.display.halfFixedWidth * 2 / localFixedWidth, 1)
  local teamSize = self.ui.bg_team:getContentSize()
  local detailSize = self.ui.bg_detail:getContentSize()
  local diffX = self.ui.bg_team:getPositionX() - teamSize.width * 0.5 - self.ui.bg_detail:getPositionX() - detailSize.width * 0.5
  local leftPanelRightPosX = self.baseui.panel_left:getContentSize().width + self.baseui.panel_left:getPositionX()
  local safeWidth = self.baseui.panel_right:getPositionX() - leftPanelRightPosX
  local contentWidth = detailSize.width + teamSize.width + diffX - 60
  local infoScale = math.min(safeWidth / contentWidth, 1)
  if infoScale < 1 then
    self.ui.bg_detail:setScale(infoScale)
    self.ui.bg_team:setScale(infoScale)
  end
  local startX = leftPanelRightPosX + (safeWidth - contentWidth * infoScale) * 0.5 - 0
  self.ui.bg_detail:setPositionX(startX + detailSize.width * infoScale * 0.5)
  self.ui.bg_team:setPositionX(startX + detailSize.width * infoScale + diffX * infoScale + teamSize.width * infoScale * 0.5)
  self.ui.bg_team:setPositionY(self.ui.bg_detail:getPositionY() + (0.9 - self.ui.bg_detail:getAnchorPoint().y) * detailSize.height * infoScale + (self.ui.bg_team:getAnchorPoint().y - 0.75) * teamSize.height * infoScale)
  self.ui.bg_1:setPosition(140, 100)
  local bg2TopY = 50 + (self.ui.bg_team:getPositionY() + (0 - self.ui.bg_team:getAnchorPoint().y) * teamSize.height * infoScale)
  local bg2Size = self.ui.bg_2:getContentSize()
  bg2Size.height = math.max(bg2TopY + ed.display.halfFixedHeight, 68)
  self.ui.bg_2:setContentSize(bg2Size)
  self.ui.bg_2:setPositionY(bg2TopY - bg2Size.height * 0.5)
  local cloudSize = self.ui.img_cloud:getContentSize()
  cloudSize.height = math.max(bg2Size.height, 170)
  self.ui.img_cloud:setContentSize(cloudSize)
  self.ui.img_cloud:setPositionY(bg2Size.height - 0.5 * cloudSize.height)
end

function CupArenaKnockoutChallengeScene:onEnter(...)
  base.onEnter(self)
  if self.isWaitCloseScene then
    self:closeCurrentScene()
    return
  end
  if ed.CupArenaManager:getIsFirstOpenKnockout() then
    ed.CupArenaManager:setIsFirstOpenKnockout(false)
    ed.ui.CupArenaEffectPlayWin.create({
      type = "qualify",
      data = {isQualify = true}
    })
  end
end

function CupArenaKnockoutChallengeScene:initMatchPlaza(...)
end

function CupArenaKnockoutChallengeScene:startTimer(...)
  self:listenTimer(Timer:Always(0.5), function()
    self:updateCountDownUI(false)
  end)
end

function CupArenaKnockoutChallengeScene:updateCountDownUI(isInit)
  if nil ~= self.endTime and self.endTime > 0 then
    local diffTime = self.endTime - ed.getServerTime()
    if nil ~= self.countDownTimeLabel then
      self.countDownTimeLabel:setString(ed.gethmsNString(math.max(diffTime, 0)))
    end
    if diffTime <= 0 then
      self.endTime = nil
      CloseTimer("knockout_challenge_refresh_panel")
      local scheduleTable = ed.getDataTable("CupArenaSchedule")[self.data._schedule_id]
      if scheduleTable["State Type"] == "ShowTime" then
        self:closeCurrentScene()
      else
        self:listenTimer(Timer:Once(isInit and 5 or 1, "knockout_challenge_refresh_panel"), function()
          ed.CupArenaNetwork:sendOpenPanel(false)
        end)
      end
    end
  end
end

function CupArenaKnockoutChallengeScene:initRaceInfoUI()
  local scheduleTable = ed.getDataTable("CupArenaSchedule")[self.data._schedule_id]
  local finalRank, matchTime, matchId, oppoSummary
  if self.matchType == ed.CupArenaManager.KnockState.Prepare then
    matchId = self.data._match_id or 1
    if 127 == matchId and ("TallyUp" == scheduleTable["State Type"] or "ShowTime" == scheduleTable["State Type"]) then
      finalRank = 1
    else
      matchTime = self.data._match_time or 0
      oppoSummary = self.data._oppo._summary
    end
  elseif self.matchType == ed.CupArenaManager.KnockState.Out then
    finalRank = self.data._final_rank
  end
  if nil == finalRank and nil ~= matchTime and nil ~= matchId and nil ~= oppoSummary then
    local matchConfig = ed.getDataTable("CupArenaMatch")[matchId]
    ed.setString(self.ui.label_race_info, matchConfig["Match Name"])
    local timeStr = ed.getYMDHMSTime(matchTime, "standard")
    ed.setString(self.ui.label_time_info, timeStr)
    local param = {
      id = oppoSummary._avatar,
      level = oppoSummary._level,
      lvoffset = {x = -47, y = -38}
    }
    local head, headIcon = ed.getWholeHeadIcon(param)
    head:setScale(self.ui.img_oppo_head:getScaleX())
    ed.UITool.replaceUI(self.ui, "bg_oppo", "img_oppo_head", head)
    local touchKey = "oppo_head"
    self:btRemoveMainTouchHandler({key = touchKey})
    self:btRegisterButtonClick({
      button = headIcon,
      key = touchKey,
      pressScale = 0.95,
      clickHandler = function()
        if ed.checkVisible(self.ui.img_oppo_head) then
          self:onOppoHeadEvent()
        end
      end
    })
    local name = ed.getPlayerName(oppoSummary._name, oppoSummary._medal, {
      medalRight = false,
      disableOffset = true,
      anchorPoint = ccp(0.5, 0.5),
      labelStroke = "0x3b260b"
    })
    ed.UITool.replaceUI(self.ui, "bg_oppo", "label_oppo_name", name)
    self.ui.bg_race_des:setVisible(true)
    self.ui.bg_race_info:setVisible(true)
    self.ui.bg_time_des:setVisible(true)
    self.ui.bg_time_info:setVisible(true)
    self.ui.bg_oppo:setVisible(true)
    self.ui.bg_lose_info:setVisible(false)
  elseif nil ~= finalRank then
    local param = {
      id = ed.player:getAvatarId(),
      frameId = ed.player:getAvatarFrame(),
      level = ed.player:getLevel(),
      lvoffset = {x = -47, y = -38}
    }
    local head, headIcon = ed.getWholeHeadIcon(param)
    head:setScale(self.ui.img_self_head:getScaleX())
    ed.UITool.replaceUI(self.ui, "bg_lose_info", "img_self_head", head)
    local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
      medalRight = false,
      disableOffset = true,
      anchorPoint = ccp(0.5, 0.5),
      labelStroke = "0x3b260b"
    })
    ed.UITool.replaceUI(self.ui, "bg_lose_info", "label_self_name", name)
    local campTableItem = ed.getDataTable("CupArenaCamp")[ed.CupArenaManager:getCampId()]
    ed.setLabelString(self.ui.label_self_camp, T("\233\152\181\232\144\165\239\188\154%s", campTableItem["Camp Name"]))
    ed.setLabelString(self.ui.label_self_rank, T("\230\156\128\231\187\136\229\144\141\230\172\161\239\188\154%s", ed.CupArenaUITool.getRankName(finalRank)))
    if 2 < finalRank and nil == self.ui.outTipsLabel then
      self.ui.outTipsLabel = ed.ui.gradientLabel.create({
        text = T("\230\130\168\229\183\178\230\173\162\230\173\165"),
        fontSize = 40,
        fontName = ed.fontBold,
        startColor = ed.toccc3(16085572),
        endColor = ed.toccc3(16762464),
        strokeSize = 2,
        strokeColor = ed.toccc3(16776423)
      })
      self.ui.bg_lose_info:addChild(self.ui.outTipsLabel.node)
      self.ui.outTipsLabel.node:setPosition(self.ui.bg_lose_info:getContentSize().width * 0.5, 2)
    end
    self.ui.bg_race_des:setVisible(false)
    self.ui.bg_race_info:setVisible(false)
    self.ui.bg_time_des:setVisible(false)
    self.ui.bg_time_info:setVisible(false)
    self.ui.bg_oppo:setVisible(false)
    self.ui.bg_lose_info:setVisible(true)
  end
  local desStr = scheduleTable[self.matchType == ed.CupArenaManager.KnockState.Prepare and "Win Describe" or "Lose Describe"]
  if nil == desStr then
    self.tipDesLabel.node:setVisible(false)
  else
    self.tipDesLabel.node:setVisible(true)
    desStr = string.format(desStr, "<lable color=ccc3(255,121,121) strokeColor=0x6d1a15 strokeSize=1 name=timeLabel whole=true>00:00:00</lable>")
    local desBgSize = self.ui.bg_team_des:getContentSize()
    self.tipDesLabel:initParam({
      context = desStr,
      fontSize = 17,
      color = ccc3(255, 255, 244),
      strokeColor = ed.toccc3(4079944),
      strokeSize = 1,
      lineSpacing = 4,
      maxWidth = desBgSize.width - 20
    })
    local desWidth, desHeight = self.tipDesLabel:getCurContentSize()
    self.tipDesLabel.node:setPosition(ccp((desBgSize.width - desWidth) * 0.5, (desBgSize.height + desHeight - self.tipDesLabel:getFirstLineHeight()) * 0.5))
    self.countDownTimeLabel = self.tipDesLabel:getLabelByName("timeLabel")
  end
  self.endTime = ed.CupArenaManager:getEndTime()
  self:updateCountDownUI(true)
end

function CupArenaKnockoutChallengeScene:registerEvents()
  base.registerEvents(self)
  self:listenEvent("EventCupArenaGetDefensiveLineup", function(data)
    ed.ui.CupArenaDefensiveWin.create({lineups = data, isKnockout = true})
  end)
  self:listenEvent("EventCupArenaRefreshDefensiveLineup", function(data)
    self.data._lineups = data
    self:updateTeamListUI()
  end)
  self:listenEvent("EventCupArenaRefreshKnockoutChallenge", function(data)
    self:initData(data)
    self:initRaceInfoUI()
    self:updateTeamListUI()
  end)
  self:listenEvent("EventCupArenaOver", function()
    self:closeCurrentScene()
  end)
  self:listenEvent("EventCupArenaGambleEntryRed", function()
    self:refreshTaskRedPoint()
  end)
end

function CupArenaKnockoutChallengeScene:registerTouchEvents()
  base.registerTouchEvents(self)
  self:registerBtn(self.ui.btn_adjust, function()
    self:onAdjustEvent()
  end, {normalScale = 0.6, pressScale = 0.57})
  self:registerBtn(self.ui.btn_schedule, function()
    self:onScheduleEvent()
  end, {normalScale = 0.8, pressScale = 0.76})
  self:registerBtn(self.ui.btn_gamble, function()
    self:onGambleEvent()
  end, {normalScale = 0.8, pressScale = 0.76})
  self:registerBtn(self.ui.btn_summary, function()
    self:onAuditionSummaryEvent()
  end, {normalScale = 0.9, pressScale = 0.855})
end

function CupArenaKnockoutChallengeScene:canSetTeam()
  if self.matchType == "out" then
    return false
  end
  local scheduleParam = ed.getDataTable("CupArenaSchedule")[self.data._schedule_id]
  return scheduleParam["State Type"] == "Prepare"
end

function CupArenaKnockoutChallengeScene:createTeamItem(index, heroArr)
  local container, ui = ed.editorui(ed.uieditor.CupArenaKnockoutTeamItem)
  container:setContentSize(ui.bg:getContentSize())
  local uiConfig = TeamUIConfig[index]
  ed.setTexture(ui.bg, uiConfig.bgPath)
  ed.setLabelColor(ui.label_team, uiConfig.teamColor)
  ed.setLabelStroke(ui.label_team, uiConfig.teamStrokeColor, 1)
  ed.setLabelStroke(ui.label_gs, ed.toccc3(3877665), 1)
  ed.setString(ui.label_team, T("%s\233\152\159", index))
  ui.label_team:setFontName(ed.fontBold)
  self:refreshTeamItem(ui, index, heroArr)
  return container, ui
end

function CupArenaKnockoutChallengeScene:refreshTeamItem(ui, index, heroArr)
  ui.panel_hero:removeAllChildrenWithCleanup(true)
  ui.heroUIArr = {}
  local totalGs = 0
  local posY = ui.panel_hero:getContentSize().height * 0.5
  local num = #heroArr
  for i, v in ipairs(heroArr) do
    local headIcon = ed.readhero.createIconByServer(v.heroData)
    headIcon:showLegendEquip(not ed.openLegendEquip())
    headIcon.icon:setScale(0.9)
    headIcon.icon:setPosition(ccp((num - i + 0.5) * 78, posY))
    if v.isHidden then
      headIcon:addShade()
      local iconHidden = ed.createSprite("UI/alpha/1080P/toparena/toparena_team_invisible.png")
      local iconSize = headIcon.icon:getContentSize()
      iconHidden:setPosition(ccp(iconSize.width - 15, iconSize.height - 15))
      headIcon.icon:addChild(iconHidden, 10)
    end
    ui.panel_hero:addChild(headIcon.icon)
    table.insert(ui.heroUIArr, headIcon)
    totalGs = totalGs + v.gs
  end
  ed.setLabelString(ui.label_gs, T("\230\136\152\229\138\155\239\188\154%d", totalGs))
  return container, ui
end

function CupArenaKnockoutChallengeScene:getPos(i)
  local size = self.ui.panel_team:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 100
  local itemSpace = 4
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaKnockoutChallengeScene:getHeight(num)
  local itemHeight = 100
  local itemSpace = 4
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaKnockoutChallengeScene:updateTeamListUI(...)
  if nil == self.ui.teamDraglist then
    local size = self.ui.panel_team:getContentSize()
    self.ui.teamDraglist = ed.UITool.createDraglist(self.ui.panel_team, {priority = -300})
    self.teamUIArr = {}
  end
  self.teamDatas = {}
  for _, v in ipairs(self.data._lineups) do
    local heroArr = {}
    local hidden = v._hidden or {}
    for teamIndex, team in ipairs(v._heroes) do
      if team then
        for heroIndex, hero in ipairs(team._heroes) do
          if hero then
            table.insert(heroArr, {
              id = hero._tid,
              isHidden = false,
              gs = hero._gs,
              heroData = hero
            })
          end
        end
      end
    end
    ed.readhero.sortIDByRange(heroArr, function(tab)
      return tab.id
    end)
    table.insert(self.teamDatas, heroArr)
  end
  local teamNum = 0
  for i, v in ipairs(self.teamDatas) do
    if i > #self.teamUIArr then
      local container, ui = self:createTeamItem(i, v)
      self.ui.teamDraglist:addItem(container)
      container:setPosition(self:getPos(i))
      table.insert(self.teamUIArr, ui)
    else
      self:refreshTeamItem(self.teamUIArr[i], i, v)
    end
    teamNum = teamNum + 1
  end
  self.ui.teamDraglist:initListHeight(self:getHeight(teamNum))
  self.ui.teamDraglist:refreshClipRect(self.ui.bg_team:getScale())
  for i = #self.teamUIArr, teamNum + 1, -1 do
    table.remove(self.teamUIArr, i)
    self.ui.teamDraglist:removeItemWithIndex(i)
  end
end

function CupArenaKnockoutChallengeScene:onAdjustEvent()
  local scheduleTableItem = ed.getDataTable("CupArenaSchedule")[self.data._schedule_id]
  if scheduleTableItem["State Type"] ~= "Prepare" then
    ed.showToast(T("\228\187\133\229\143\175\229\156\168\229\184\131\233\152\181\233\152\182\230\174\181\232\176\131\230\149\180\233\152\159\228\188\141"))
    return
  end
  ed.CupArenaNetwork:sendGetDefensiveLineup()
end

function CupArenaKnockoutChallengeScene:onScheduleEvent()
  ed.CupArenaNetwork:sendMatchFinalSchedule(true)
end

function CupArenaKnockoutChallengeScene:onGambleEvent()
  ed.CupArenaNetwork:sendOpenGamble()
end

function CupArenaKnockoutChallengeScene:onAuditionSummaryEvent()
  ed.CupArenaNetwork:sendOpenAuditionSummary()
end

function CupArenaKnockoutChallengeScene:onOppoHeadEvent()
  if nil == self.data or nil == self.data._oppo then
    return
  end
  ed.CupArenaNetwork:sendViewUser(self.data._oppo._role_id)
end

function CupArenaKnockoutChallengeScene:closeCurrentScene()
  if ed.getCurrentScene().identity == "CupArenaKnockoutChallengeScene" then
    ed.popScene()
    ed.showToast(T("\229\165\179\231\165\158\228\185\139\230\136\152\229\183\178\231\187\147\230\157\159"))
  else
    self.isWaitCloseScene = true
  end
end

function CupArenaKnockoutChallengeScene:refreshTaskRedPoint()
  self.ui.img_gamble_red:setVisible(ed.CupArenaManager:getGambleRedFlag())
end
