local base = ed.ui.commonscene
local PeakArenaPvpScene = newclass(base.mt)
ed.ui.PeakArenaPvpScene = PeakArenaPvpScene

function PeakArenaPvpScene:initData()
  self.mgr = ed.PeakArenaManager
  self.uiList = {}
end

function PeakArenaPvpScene:initLabels()
  ed.setLabelStroke(self.ui.label_season, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_switch, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.Label_2118, ed.toccc3(15541271), 1)
  ed.setLabelStroke(self.ui.label_defend_gs, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_medal, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_icon_score1, ed.toccc3(12542248), 1)
  self.ui.label_icon_score1:setFontName(ed.fontBold)
  ed.setLabelFontName(self.ui.label_banner_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_banner_title, ed.toccc3(14054429), 1)
  ed.setLabelStroke(self.ui.label_frozen, ed.toccc3(3818921), 1)
  ed.setLabelFontName(self.ui.label_frozen, ed.fontBold)
  ed.setLabelStroke(self.ui.label_score_frozen, ed.toccc3(3818921), 1)
  ed.setLabelFontName(self.ui.label_score_frozen, ed.fontBold)
  for i = 1, 7 do
    ed.setLabelStroke(self.ui["label_btn" .. i], ed.toccc3(2565412), 1)
  end
  for i = 1, 3 do
    ed.setLabelShadow(self.ui["label_battle" .. i], ed.toccc3(2565412), ccp(1, 1))
    ed.setLabelStroke(self.ui["enemy_name" .. i], ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui["enemy_server_name" .. i], ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui["enemy_gs" .. i], ed.toccc3(2565412), 1)
  end
  ed.setLabelStroke(self.ui.Label_108, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.Label_108_Copy0, ed.toccc3(2565412), 1)
  ed.setLabelFontName(self.ui.label_self_des, ed.fontBold)
  ed.setLabelStroke(self.ui.label_self_des, ed.toccc3(14969387), 1)
end

function PeakArenaPvpScene:adaptUI()
  local winSize = ed.display.winSize
  self.ui.bg:setContentSize(CCSizeMake(winSize.width, winSize.height))
  self.ui.deco_mid:setContentSize(CCSizeMake(600, winSize.height))
  self.ui.deco_mid:setPosition(ccp(winSize.width / 2 + 5.5, winSize.height / 2))
  self.fixScale = math.min(1, 1 - (1170 - winSize.width) * 0.85 / 1170)
  self.ui.bg_banner:setScale(self.fixScale)
  local perWidth = (ed.display.winSize.width - 1170) / 210
  local height = ed.display.winSize.height - 540
  ed.UITool.setPositionBy(self.ui.bg_banner, ccp(35 * perWidth, height / 2 + 10))
  ed.UITool.setPositionBy(self.ui.bg_enemy1, ccp(90 * perWidth, 0))
  ed.UITool.setPositionBy(self.ui.bg_enemy2, ccp(130 * perWidth, 0))
  ed.UITool.setPositionBy(self.ui.bg_enemy3, ccp(170 * perWidth, 0))
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  ed.layout.layoutWithMagin(self.ui.bg_times, {top = 38, right = 320})
  ed.layout.layoutWithMagin(self.ui.bg_evolve_info, {top = 38})
  for i = 1, 7 do
    ed.layout.layoutWithMagin(self.ui["bg_btn" .. i], {
      left = ed.display.getNotchHeight()
    })
  end
  ed.UITool.setPositionBy(self.ui.offSeason_img, ccp((ed.display.winSize.width - 960) / 4, 0))
  ed.adaptLabel(self.ui.label_change, {maxWidth = 100, minScale = 0.8})
  self.ui.label_btn4:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.setLabelDimensions(self.ui.label_btn4, CCSizeMake(80, 0))
  self.ui.label_btn4:setPositionY(15 - self.ui.label_btn4:getContentSize().height * 0.5)
  self.ui.label_change:setHorizontalAlignment(kCCTextAlignmentCenter)
end

function PeakArenaPvpScene:layoutLeftBtn()
  local startY = 135
  local gapY = 60
  for index = 1, 7 do
    local btn = self.ui["bg_btn" .. index]
    if btn and btn:isVisible() then
      btn:setPositionY(startY)
      startY = startY - gapY
    end
  end
end

function PeakArenaPvpScene:refreshBannerBg()
  local isHighGrade = self.mgr:isSelfHighGrade()
  ed.setTexture(self.ui.bg_banner, isHighGrade and "UI/alpha/1080P/toparena/toparena_enemy_info_bg_high.png" or "UI/alpha/1080P/toparena/toparena_player_info_bg.png")
end

function PeakArenaPvpScene:refreshSeasonInfo()
  local cd = self.mgr:getEndTime() - ed.getServerTime()
  local timeStr = self:formatTime(cd)
  local str
  if self.mgr:isOnSeason() then
    str = string.format(T("%s\232\181\155\229\173\163 %s"), self.mgr:getSeasonName(self.mgr:getSeason()), timeStr)
  elseif self.mgr:isPreparing() then
    str = string.format(T("\229\135\134\229\164\135\228\184\173 %s"), timeStr)
  elseif self.mgr:isPlayoff() then
    str = string.format(T("\228\188\145\233\151\178\232\181\155 %s"), timeStr)
  else
    str = string.format(T("\228\188\145\232\181\155\228\184\173 %s"), timeStr)
  end
  ed.setString(self.ui.label_season, str)
  self.ui.offSeason_img:setVisible(ed.PeakArenaManager:isOffSeason())
  for i = 1, 3 do
    self.ui["bg_enemy" .. i]:setVisible(not ed.PeakArenaManager:isOffSeason())
  end
  self.ui.bg_btn2:setVisible(not ed.PeakArenaManager:isPlayoff())
  self.ui.label_btn2:setColor(ed.PeakArenaManager:isPlayoff() and ccc3(157, 157, 157) or ccc3(244, 231, 185))
  self:layoutLeftBtn()
end

function PeakArenaPvpScene:refreshGradeInfo()
  ed.setTexture(self.ui.icon_grade, self.mgr:getGradeIconRes())
  ed.setTexture(self.ui.name_grade, self.mgr:getGradeTextRes())
end

function PeakArenaPvpScene:refreshZone()
  if self.mgr:isSelfHighGrade() then
    ed.disableLabelStroke(self.ui.label_zone)
    ed.setLabelColor(self.ui.label_zone, ccc3(46, 36, 32))
    ed.setTexture(self.ui.bg_zone, "UI/alpha/1080P/toparena/toparena_player_info_high.png")
    ed.setLabelColor(self.ui.label_zone_title, ed.toccc3(7692904))
  else
    ed.setLabelStroke(self.ui.label_zone, ccc3(46, 36, 32), 1)
    ed.setLabelColor(self.ui.label_zone, ccc3(255, 255, 255))
    ed.setTexture(self.ui.bg_zone, "UI/alpha/1080P/toparena/toparena_player_info.png")
    ed.setLabelColor(self.ui.label_zone_title, ed.toccc3(13212287))
  end
  ed.setString(self.ui.label_zone, string.format(T("\231\172\172%d\232\181\155\229\140\186"), self.mgr:getZone()))
end

function PeakArenaPvpScene:refreshZoneRank()
  if self.mgr:isSelfHighGrade() then
    ed.disableLabelStroke(self.ui.label_zonerank)
    ed.setLabelColor(self.ui.label_zonerank, ccc3(46, 36, 32))
    ed.setTexture(self.ui.bg_zone_rank, "UI/alpha/1080P/toparena/toparena_player_info_high.png")
    ed.setLabelColor(self.ui.label_zonerank_title, ed.toccc3(7692904))
  else
    ed.setLabelStroke(self.ui.label_zonerank, ccc3(46, 36, 32), 1)
    ed.setLabelColor(self.ui.label_zonerank, ccc3(255, 255, 255))
    ed.setTexture(self.ui.bg_zone_rank, "UI/alpha/1080P/toparena/toparena_player_info.png")
    ed.setLabelColor(self.ui.label_zonerank_title, ed.toccc3(13212287))
  end
  if self.mgr.zoneRank > 0 then
    ed.setString(self.ui.label_zonerank, self.mgr.zoneRank)
  else
    ed.setString(self.ui.label_zonerank, T("\230\156\170\228\184\138\230\166\156"))
  end
  ed.right2(self.ui.label_zonerank, self.ui.label_zonerank_title, 0)
end

function PeakArenaPvpScene:refreshMedal(showAction)
end

function PeakArenaPvpScene:refreshDefendGs()
  if self.mgr:isSelfHighGrade() then
    ed.disableLabelStroke(self.ui.label_defend_gs)
    ed.setLabelColor(self.ui.label_defend_gs, ccc3(46, 36, 32))
    ed.setTexture(self.ui.bg_defendgs, "UI/alpha/1080P/toparena/toparena_player_info_high.png")
    ed.setLabelColor(self.ui.label_defend_gs_title, ed.toccc3(7692904))
  else
    ed.setLabelStroke(self.ui.label_defend_gs, ccc3(46, 36, 32), 1)
    ed.setLabelColor(self.ui.label_defend_gs, ccc3(255, 255, 255))
    ed.setTexture(self.ui.bg_defendgs, "UI/alpha/1080P/toparena/toparena_player_info.png")
    ed.setLabelColor(self.ui.label_defend_gs_title, ed.toccc3(13212287))
  end
  ed.setString(self.ui.label_defend_gs, self.mgr.lineupGs)
  ed.right2(self.ui.label_defend_gs, self.ui.label_defend_gs_title, 0)
end

function PeakArenaPvpScene:refreshScore(showAction)
  if self.mgr:isSelfHighGrade() then
    ed.setTexture(self.ui.bg_score, "UI/alpha/1080P/toparena/toparena_score_bg_high.png")
    ed.setTexture(self.ui.icon_score1, "UI/alpha/1080P/toparena/icon_score_high.png")
    ed.setLabelColor(self.ui.label_icon_score1, ed.toccc3(16773542))
    ed.setLabelStroke(self.ui.label_icon_score1, ed.toccc3(12542248), 1)
  else
    ed.setTexture(self.ui.bg_score, "UI/alpha/1080P/toparena/toparena_score_bg.png")
    ed.setTexture(self.ui.icon_score1, "UI/alpha/1080P/toparena/toparena_score_icon.png")
    ed.setLabelColor(self.ui.label_icon_score1, ed.toccc3(16776168))
    ed.setLabelStroke(self.ui.label_icon_score1, ed.toccc3(12210834), 1)
  end
  local scoreNode = ed.getNumberNode({
    text = self.mgr.score,
    folder = "peak_score"
  }).node
  scoreNode:setZOrder(1)
  ed.UITool.replaceUI(self.ui, "bg_banner", "score", scoreNode)
  if self.mgr.scoreAction then
    scoreNode:runAction(ed.UITool.getRefreshAction())
    self.mgr.scoreAction = nil
  end
end

function PeakArenaPvpScene:refreshSelfRank()
  self.ui.bg_selfrank:setVisible(self.mgr:getScoreRank() > 0)
  self.ui.banner_title:setVisible(self.mgr:getScoreRank() == 0)
  if self.mgr:getScoreRank() > 0 then
    if self.rankUI then
      self.rankUI:removeFromParentAndCleanup(true)
    end
    local topRank = self.mgr:getScoreRank() <= 3
    ed.setTexture(self.ui.bg_selfrank, topRank and "UI/alpha/1080P/toparena/toparena_total_rank_bg2.png" or "UI/alpha/1080P/toparena/toparena_total_rank_bg1.png", true)
    self.ui.label_self_des:setPositionY(topRank and 36.5 or 28.5)
    self.ui.noself:setPositionY(topRank and 36.5 or 28.5)
    local rankNum = ed.getNumberNode({
      text = self.mgr:getScoreRank(),
      folder = "peak_rank",
      scale = topRank and 1 or 0.8
    }).node
    self.ui.bg_selfrank:addChild(rankNum)
    local y = self.ui.noself:getPositionY()
    rankNum:setPositionY(topRank and y + 2 or y + 1)
    self.rankUI = rankNum
    ed.layout.horizontalSortNode({
      self.ui.label_self_des,
      self.ui.noself,
      self.rankUI
    }, {
      3,
      0,
      0
    }, self.ui.bg_selfrank:getContentSize().width * 0.5)
  end
end

function PeakArenaPvpScene:refreshPunishInfo()
  if self.mgr:isSelfHighGrade() and self.mgr.scorePunish > 0 then
    self.ui.bg_punishi:setVisible(true)
    ed.setString(self.ui.Label_2118, ed.getDataTable("PeakArenaGrade")[self.mgr.grade]["Punish Score"])
  else
    self.ui.bg_punishi:setVisible(false)
  end
end

function PeakArenaPvpScene:refreshEvolveInfo()
  if self.mgr:isEvolving() then
    local time = self.mgr.evolveTime - ed.getServerTime()
    if 0 < time then
      local timeStr = ed.gethmsNString(self.mgr.evolveTime - ed.getServerTime())
      self.ui.label_limit_time:setString(string.format(T("\230\153\139\231\186\167\232\181\155\229\137\169\228\189\153\230\151\182\233\151\180\239\188\154%s"), timeStr))
    else
      self.mgr.evolveState = "finish"
      ed.showAlertDialog({
        text = T("\230\153\139\231\186\167\232\181\155\229\183\178\231\187\147\230\157\159"),
        buttonText = T("\231\161\174\229\174\154"),
        handler = function()
          ed.PeakArenaNetwork:sendOpenPanel()
          ed.PeakArenaNetwork:sendRefreshOppo(false)
        end
      })
    end
  end
end

function PeakArenaPvpScene:refreshChallengeTimes()
  if self.mgr:isOffSeason() then
    return
  end
  if self.mgr:isEvolving() then
    return
  end
  local maxTimes = self.mgr:getMaxTimes()
  local leftTimes = self.mgr:getLeftTimes()
  ed.setString(self.ui.label_times, string.format(T("\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\154 %d/%d"), leftTimes, maxTimes))
  local bLeft = 0 < leftTimes
  self.ui.btn_addtimes:setVisible(not bLeft)
end

function PeakArenaPvpScene:refreshChangeOppoBtn()
  if self.mgr:isOffSeason() then
    return
  end
  if self.mgr:isEvolving() then
    return
  end
  local halfWid = self.ui.btn_switch:getContentSize().width * 0.5
  if self.mgr:isSelfHighGrade() then
    self.ui.icon_switch:setVisible(false)
    self.ui.refresh_tip:setVisible(false)
    ed.setString(self.ui.label_switch, T("\229\189\147\229\137\141\230\174\181\228\189\141\228\184\141\232\131\189\229\136\183\230\150\176"))
    ed.adaptLabel(self.ui.label_switch, {maxWidth = 145, minScale = 0.7})
    self.ui.label_switch:setPositionX(halfWid)
  else
    self.ui.icon_switch:setVisible(true)
    ed.setString(self.ui.label_switch, string.format(T("\229\136\183\230\150\176 %d/%d"), self.mgr.leftRefreshTimes, self.mgr.maxRefreshTimes))
    self.ui.label_switch:limitWidthByScale(110)
    self.ui.label_switch:setPositionX(halfWid + 18)
  end
end

function PeakArenaPvpScene:createOppos(k)
  local data = self.mgr.oppos[k]
  local isEvolving = self.mgr:isEvolving()
  local isInRanklist = data._score_rank and data._score_rank > 0
  local isTopRank = isInRanklist and data._score_rank < 4
  local container, ui = ed.editorui(ed.uieditor.PeakArenaOppoItem)
  ed.setLabelShadow(ui.label_battle, ed.toccc3(2565412), ccp(1, 1))
  ed.setLabelStroke(ui.name, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.server, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.gs, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.label_title_score, ed.toccc3(12542248), 1)
  ui.label_title_score:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_result_win, ed.toccc3(16747300), 1)
  ed.setLabelFontName(ui.label_result_win, ed.fontBold)
  ed.setLabelShadow(ui.label_result_win, ed.toccc3(9715743), ccp(0, 2))
  ed.setLabelStroke(ui.label_result_lose, ed.toccc3(6776798), 1)
  ed.setLabelFontName(ui.label_result_lose, ed.fontBold)
  ed.setLabelShadow(ui.label_result_lose, ed.toccc3(2233656), ccp(0, 2))
  ed.setLabelStroke(ui.label_tag_evolve, ed.toccc3(12866841), 1.5)
  ed.setLabelFontName(ui.label_tag_evolve, ed.fontBold)
  ed.setLabelFontName(ui.label_rank_des, ed.fontBold)
  ed.setLabelStroke(ui.label_rank_des, ed.toccc3(14969387), 1)
  ed.setLabelFontName(ui.label_rank_des2, ed.fontBold)
  ed.setLabelStroke(ui.label_rank_des2, ed.toccc3(14969387), 1)
  ui.tag_evolve:setVisible(isEvolving)
  ui.bg_rank:setVisible(not isEvolving and isTopRank)
  ui.bg_rank_low:setVisible(not isEvolving and isInRanklist and not isTopRank)
  local summary = data._summary
  local score = data._score
  local roleGs = data._lineup_gs
  local scoreRank = data._score_rank
  if self.mgr.masked.isMasked(data._grade) then
    ui.bg_rank:setVisible(false)
    ui.bg_rank_low:setVisible(true)
    summary._name = self.mgr.masked.name
    summary._avatar = self.mgr.masked.avatar
    local length = ed.getIntNumLenght(score)
    score = ""
    for _ = 1, length do
      score = score .. "?"
    end
    length = ed.getIntNumLenght(roleGs)
    roleGs = ""
    for _ = 1, length do
      roleGs = roleGs .. "?"
    end
    if isInRanklist then
      local length = ed.getIntNumLenght(scoreRank)
      scoreRank = ""
      for _ = 1, length do
        scoreRank = scoreRank .. "?"
      end
      scoreRank = "???"
    end
  end
  if isInRanklist then
    local rankNum = ed.getNumberNode({
      text = scoreRank,
      folder = "peak_rank",
      scale = 1,
      anchor = ccp(0, 0.5)
    }).node
    if self.mgr.masked.isMasked(data._grade) then
      ui.bg_rank_low:addChild(rankNum)
      rankNum:setPosition(ccp(155, 32))
    elseif isTopRank then
      ui.bg_rank:addChild(rankNum)
      rankNum:setPosition(ccp(158, 40))
    else
      ui.bg_rank_low:addChild(rankNum)
      rankNum:setPosition(ccp(155, 32))
    end
    if self.mgr.masked.isMasked(data._grade) then
      rankNum:setScale(0.8)
      rankNum:setPosition(ccp(161, 31))
    elseif 4 < ed.getIntNumLenght(data._score_rank) then
      rankNum:setScale(0.6)
      rankNum:setPosition(ccp(isTopRank and 168 or 165, isTopRank and 38 or 30))
    elseif ed.getIntNumLenght(data._score_rank) > 3 then
      rankNum:setScale(0.7)
      rankNum:setPosition(ccp(isTopRank and 166 or 163, isTopRank and 38 or 30))
    elseif ed.getIntNumLenght(data._score_rank) == 3 then
      rankNum:setScale(0.8)
      rankNum:setPosition(ccp(isTopRank and 164 or 161, isTopRank and 39 or 31))
    end
    if ui.bg_rank_low:isVisible() then
      ed.layout.horizontalSortNode({
        ui.label_rank_des2,
        ui.rank_low,
        rankNum
      }, {
        2,
        0,
        0
      }, ui.bg_rank_low:getContentSize().width * 0.5)
    elseif ui.bg_rank:isVisible() then
      ed.layout.horizontalSortNode({
        ui.label_rank_des,
        ui.rank,
        rankNum
      }, {
        2,
        0,
        0
      }, ui.bg_rank:getContentSize().width * 0.5)
    end
  end
  local param = {
    id = summary._avatar,
    level = summary._level,
    lvoffset = {x = -47, y = -38}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "banner", "head", head)
  local name = ed.getPlayerName(ed.transBotName(summary._name), summary._medal, {
    anchorPoint = ui.name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "banner", "name", name)
  if self.mgr.masked.isMasked(data._grade) then
    ed.setString(ui.server, "???")
  else
    local str = T("\233\157\146\233\157\146\232\141\137\229\142\159")
    ed.setString(ui.server, data._server_name == "Unknow" and game_server_name or T(data._server_name))
  end
  ed.setString(ui.gs, roleGs)
  ed.UITool.replaceUI(ui, "banner", "score", ed.getNumberNode({
    text = score,
    folder = "peak_score",
    scale = 0.75
  }).node)
  local gradeName = ed.createSprite(self.mgr:getGradeTextRes(data._grade))
  ed.UITool.replaceUI(ui, "banner", "grade", gradeName)
  local adaptScale = math.min(90 / (gradeName:getContentSize().width * 0.5), 1) * 0.5
  gradeName:setScale(adaptScale)
  ed.adaptLabel(ui.title_grade, {maxWidth = 60, minScale = 0.6})
  ed.adaptLabel(ui.title_server, {maxWidth = 60, minScale = 0.6})
  ed.adaptLabel(ui.title_gs, {maxWidth = 60, minScale = 0.6})
  ed.adaptLabel(ui.label_battle, {maxWidth = 100, minScale = 0.6})
  ui.btn_battle:setVisible(data._result == nil)
  if data._result == "victory" then
    ui.bg_result_win:setVisible(true)
  elseif data._result == "defeat" then
    ui.bg_result_lose:setVisible(true)
  end
  self:btRemoveMainTouchHandler({
    key = "oppo" .. k
  })
  self:btRegisterButtonClick({
    button = headIcon,
    key = "oppo" .. k,
    pressScale = 0.95,
    clickHandler = function()
      self.selectOppo = data
      self.canChallenge = data._result == nil
      self:onClickOppoHead(k)
    end
  })
  self:btRemoveMainTouchHandler({
    key = "challenge" .. k
  })
  self:btRegisterButtonClick({
    button = ui.btn_battle,
    key = "challenge" .. k,
    pressScale = 0.95,
    clickHandler = function()
      self:onClickChallenge(k)
    end
  })
  ui.banner:setScale(self.fixScale)
  return container, ui
end

function PeakArenaPvpScene:refreshOppos(newOppo)
  if self.mgr:isOffSeason() then
    return
  end
  
  local function getPos(index)
    local x, y = self.ui["bg_enemy" .. index]:getPosition()
    local height = ed.display.winSize.height - 540
    return 70, height / 2 + 40
  end
  
  for k = 1, 3 do
    if self.uiList[k] then
      if newOppo[k] then
        local scale = CCScaleTo:create(0.1, 0, self.fixScale)
        local func = CCCallFunc:create(function()
          if not tolua.isnull(self.uiList[k].container) then
            self.uiList[k].container:removeFromParentAndCleanup(true)
          end
          self.uiList[k] = nil
          if self.mgr.oppos[k] then
            local container, ui = self:createOppos(k)
            ui.container = container
            self.uiList[k] = ui
            container:setPosition(ccp(getPos(k)))
            ui.banner:setScaleX(0)
            ui.banner:runAction(CCScaleTo:create(0.1, self.fixScale, self.fixScale))
            self.ui["bg_enemy" .. k]:addChild(container)
          end
        end)
        local actionArray = CCSequence:createWithTwoActions(scale, func)
        self.uiList[k].banner:runAction(actionArray)
      else
        if not tolua.isnull(self.uiList[k].container) then
          self.uiList[k].container:removeFromParentAndCleanup(true)
        end
        self.uiList[k] = nil
        if self.mgr.oppos[k] then
          local container, ui = self:createOppos(k)
          ui.container = container
          self.uiList[k] = ui
          container:setPosition(ccp(getPos(k)))
          self.ui["bg_enemy" .. k]:addChild(container)
        end
      end
    elseif self.mgr.oppos[k] then
      local container, ui = self:createOppos(k)
      ui.container = container
      self.uiList[k] = ui
      container:setPosition(ccp(getPos(k)))
      self.ui["bg_enemy" .. k]:addChild(container)
    end
  end
end

function PeakArenaPvpScene:refreshUI(showAction)
  local offSeason = self.mgr:isOffSeason()
  local isEvolving = self.mgr:isEvolving()
  local isHighGrade = self.mgr:isSelfHighGrade()
  self.ui.bg_evolve_info:setVisible(not offSeason and isEvolving)
  self.ui.bg_score_fronze:setVisible(not offSeason and isEvolving)
  self.ui.bg_times:setVisible(not offSeason and not isEvolving)
  self.ui.bg_enemy3:setVisible(not offSeason)
  self.ui.bg_enemy2:setVisible(not offSeason)
  self.ui.bg_enemy1:setVisible(not offSeason)
  self.ui.btn_switch:setVisible(not isEvolving)
  self:refreshBannerBg()
  self:refreshSeasonInfo()
  self:refreshGradeInfo()
  self:refreshZone()
  self:refreshZoneRank()
  self:refreshMedal()
  self:refreshDefendGs()
  self:refreshScore(showAction)
  self:refreshSelfRank()
  self:refreshChallengeTimes()
  self:refreshEvolveInfo()
  self:refreshChangeOppoBtn()
  self:refreshPunishInfo()
  self:refreshRedDot()
  self:handlerResult()
  ed.layout.horizontalSortNode({
    self.ui.ImageView_2104,
    self.ui.label_limit_time
  }, {8, 0}, self.ui.btn_evolve_rule:getPositionX() - 33, 1)
end

function PeakArenaPvpScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.TopArenaMainScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186"), self.ui.bg_title, {
    position = ccp(18, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:setBackButton()
  self:setBackground("UI/alpha/1080P/toparena/toparena_bg.jpg")
  self:adaptUI()
  self:initLabels()
  local prompt, alignment = self:getPromptText()
  self:createPromptCard(prompt, alignment)
  self:refreshUI()
  self.ui.bg_btn6:setVisible(self.mgr:getSummary() ~= nil)
  self.ui.bg_btn7:setVisible(#self.mgr.seasonBuffs > 0)
  self:layoutLeftBtn()
end

function PeakArenaPvpScene.create()
  local self = base.create("PeakArenaPvpScene", {noBottomButton = true})
  setmetatable(self, PeakArenaPvpScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popGradeUpDownWindow()
  ed.asyncload.preloadFcaByName("eff_UI_PeakArena_loading")
  ed.PeakArenaNetwork:sendRefreshOppo(false)
  return self
end

function PeakArenaPvpScene:initPunishiPanel()
  if self.punishUI then
    self.punishUI:removeFromParentAndCleanup(true)
  end
  local autoStr = T("\228\188\160\229\165\135\230\174\181\228\189\141\228\187\165\228\184\138\230\151\182\239\188\140\230\175\143\229\145\168\228\184\187\229\138\168\232\191\155\230\148\187\230\172\161\230\149\176\228\189\142\228\186\142<lable color=ccc3(255,131,83) strokeColor=ccc3(39,37,36) strokeSize=1>%d</lable>\230\172\161\229\176\134\233\129\173\229\136\176\230\182\136\230\158\129\230\131\169\231\189\154\227\128\130\230\182\136\230\158\129\230\131\169\231\189\154\228\184\186\239\188\154\230\175\143\229\145\168\231\187\147\231\174\151\230\151\182\229\136\134\230\149\176\228\184\139\233\153\141<lable color=ccc3(255,131,83) strokeColor=ccc3(39,37,36) strokeSize=1>%d</lable>\229\136\134", ed.getDataTable("PeakArenaConfig")["Escape Punish"].Value[1], ed.getDataTable("PeakArenaGrade")[self.mgr.grade]["Punish Score"])
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    fontSize = 16,
    context = autoStr,
    maxWidth = 348,
    fontColor = ccc3(255, 252, 231),
    strokeColor = ccc3(27, 25, 24),
    strokeSize = 1
  })
  self.ui.punishi_info:addChild(autoText.node, 2)
  local width, height = autoText:getCurContentSize()
  self.ui.punishi_info:setContentSize(CCSizeMake(width + 30, height + 20))
  autoText.node:setPosition(15, height + 5)
  self.punishUI = autoText.node
end

function PeakArenaPvpScene:getPromptText()
  local gap = 1800
  local preRecoverTime = self.mgr.refreshLastRecoverTime or ed.getServerTime()
  local lt = math.max(self.mgr.maxRefreshTimes - self.mgr.leftRefreshTimes, 0)
  local nextText = ed.gethmsNString(preRecoverTime + gap - ed.getServerTime())
  local totalText = ed.gethmsNString(gap * lt + preRecoverTime - ed.getServerTime())
  local gapText = T("30\229\136\134\233\146\159")
  local prompt = T("\229\189\147\229\137\141\230\151\182\233\151\180: ") .. ed.serverTime2HMS() .. ed.getUTCLabel() .. "\n"
  local alignment = "left"
  if self.mgr.maxRefreshTimes <= self.mgr.leftRefreshTimes then
    prompt = prompt .. T("\229\136\183\230\150\176\230\172\161\230\149\176\229\183\178\229\155\158\230\187\161")
  else
    prompt = prompt .. T("\228\184\139\230\172\161\229\136\183\230\150\176\230\172\161\230\149\176\230\129\162\229\164\141\239\188\154") .. nextText
    prompt = prompt .. "\n"
    prompt = prompt .. T("\230\129\162\229\164\141\229\133\168\233\131\168\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154") .. totalText
    prompt = prompt .. "\n"
    prompt = prompt .. T("\230\129\162\229\164\141\230\151\182\233\151\180\233\151\180\233\154\148\239\188\154") .. gapText
  end
  return prompt, alignment
end

function PeakArenaPvpScene:createPromptCard(text)
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 20, 160))
  bg:setAnchorPoint(ccp(0.5, 0.5))
  local label = ed.createttf(text, 16)
  ed.setLabelColor(label, ed.toccc3(16776423))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  bg:addChild(label)
  local size = label:getContentSize()
  bg:setContentSize(CCSizeMake(size.width + 30, size.height + 28))
  size = bg:getContentSize()
  label:setPosition(ccp(size.width / 2, size.height / 2 + 3))
  self.mainLayer:addChild(bg, 999)
  ed.layout.layoutWithMagin(bg, {right = 30, top = 60})
  self.tipContainer = bg
  self.promptLabel = label
  self.tipContainer:setVisible(false)
end

function PeakArenaPvpScene:refreshPromptCard()
  if self.mgr.leftRefreshTimes < self.mgr.maxRefreshTimes then
    local nextR = self.mgr.refreshLastRecoverTime + 1800
    if nextR < ed.getServerTime() then
      self.mgr.refreshLastRecoverTime = nextR
      self.mgr.leftRefreshTimes = self.mgr.leftRefreshTimes + 1
      self:refreshChangeOppoBtn()
    end
  end
  local prompt, alignment = self:getPromptText()
  local label = self.promptLabel
  ed.setString(label, prompt)
  local size = label:getContentSize()
  self.tipContainer:setContentSize(CCSizeMake(size.width + 30, size.height + 28))
  size = self.tipContainer:getContentSize()
  label:setPosition(ccp(size.width / 2, size.height / 2 + 3))
  ed.layout.layoutWithMagin(self.tipContainer, {right = 30, top = 60})
end

function PeakArenaPvpScene:onClickEvolveRule()
  ed.ui.peakArenaEvolveRuleWin.create({})
end

function PeakArenaPvpScene:onClickPunish()
  if self.ui.punishi_info:isVisible() then
    self.ui.punishi_info:setVisible(false)
  else
    self:initPunishiPanel()
    self.ui.punishi_info:setVisible(true)
  end
end

function PeakArenaPvpScene:onClickShopBtn()
  local season = ed.PeakArenaManager:getRealitySeason()
  ed.PeakArenaNetwork:sendQueryGoods()
end

function PeakArenaPvpScene:onClickSummaryInfo()
  ed.ui.PeakArenaSummaryWin.create()
end

function PeakArenaPvpScene:onClickStarHero()
  ed.ui.peakArenaStarWin.create()
end

function PeakArenaPvpScene:onClickBanHero()
  local banSelected = self.mgr:getBanSelected()
  local banedHeroes = self.mgr:getBanedHeroes()
  local isPlayoff = ed.PeakArenaManager:isPlayoff()
  if banedHeroes then
    ed.UITool.openView("peakArenaBanHeroWin")
  elseif banSelected then
    ed.UITool.openView("peakArenaVoteResultWin")
  else
    if not isPlayoff then
      ed.showToast(T("\228\188\145\233\151\178\232\181\155\230\156\159\233\151\180\229\143\175\232\191\155\232\161\140\230\138\149\231\165\168"))
      return
    end
    ed.UITool.openView("peakArenaVoteWin", {
      closeCallBack = function()
        ed.UITool.openView("peakArenaVoteResultWin")
      end
    })
  end
end

function PeakArenaPvpScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_evolve_rule", function()
    self:onClickEvolveRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_score_fronze", function()
    self:onClickEvolveRule()
  end)
  ed.UITool.registerBtn(self, "btn_change", function()
    self:onClickSetTeam()
  end, {pressScale = 0.95, priority = -303})
  ed.UITool.registerBtn(self, "btn_switch", function()
    self:onClickRefresh()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "refresh_tip", function()
    self.tipContainer:setVisible(not self.tipContainer:isVisible())
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_addtimes", function()
    self:onClickAddTimes()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "icon_grade", function()
    self:onClickMyGradeIcon()
  end)
  ed.UITool.registerBtn(self, "bg_btn1", function()
    self:onClickRanklist()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn2", function()
    self:onClickReward()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn3", function()
    self:onClickBattleLog()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn4", function()
    self:onClickRecordReview()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn5", function()
    self:onClickShopBtn()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn6", function()
    self:onClickSummaryInfo()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn7", function()
    self:onClickStarHero()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_punishi", function()
    self:onClickPunish()
  end, {pressScale = 0.9, priority = -303})
  ed.UITool.registerBtn(self, "ImageView_3560", function()
    if ed.PeakArenaManager:isPlayoff() then
      ed.showToast(T("\229\189\147\229\137\141\229\164\132\228\186\142\228\188\145\233\151\178\232\181\155\239\188\140\230\154\130\230\151\160\229\165\150\229\138\177\231\187\147\231\174\151"))
    else
      ed.UITool.openView("PeakArenaRewardWin", {tabIndex = 3})
    end
  end, {priority = -303})
  self:btRegisterOutClick({
    area = self.ui.punishi_info,
    key = "clickOut",
    clickHandler = function()
      self.ui.punishi_info:setVisible(false)
    end,
    force = true
  })
  self:btRegisterOutClick({
    area = self.tipContainer,
    key = "clickOut",
    clickHandler = function()
      self.tipContainer:setVisible(false)
    end,
    force = true
  })
end

function PeakArenaPvpScene:registerEvents()
  self:listenEvent("PeakArenaPlayNextBattle", function(data)
    if data then
      self.curRecordIdx = data
    end
    if self.curRecordIdx and self.curRecords then
      self.curRecordIdx = self.curRecordIdx + 1
      if self.curRecords[self.curRecordIdx] then
        ed.PeakArenaManager.enterReplay(self.curRecords[self.curRecordIdx], true, self.curRecordIdx)
      else
        self.curRecords = nil
        self.curRecordIdx = nil
        ed.UITool.openView("PeakArenaChallengeResultWin", {
          data = self.challengeResult,
          isEvolving = self.isEvolveBattle,
          isLoseProtect = ed.copyProto(self.challengeResult)._is_lose_protect == 1,
          closeCallback = function()
            self:onBattleEnd()
          end
        })
        ed.PeakArenaManager:peakArenaAchFcaGroup()
      end
    end
  end)
  self:listenEvent("PeakArenaRefreshOppo", function(data)
    self:OnRefreshOppoEvent(data)
  end)
  self:listenEvent("PeakArenaGetLineup", function(lineups)
    self:OnGetLineupEvent(lineups)
  end)
  self:listenEvent("PeakArenaQueryOppo", function(oppoData)
    self:OnQueryOppoResult(oppoData)
  end)
  self:listenEvent("PeakArenaSetAttackTeam", function(data)
    self:OnSetAttackTeamResult(data)
  end)
  self:listenEvent("PeakArenaChallengeResult", function(data)
    self:OnChallengeResult(data)
  end)
  self:listenEvent("PeakArenaEvolveChallengeResult", function(data)
    self:OnChallengeResult(data)
  end)
  self:listenEvent("PeakArenaQueryPlayer", function(data)
    ed.ui.peakArenaOppoInfoWin.create(data, self.canChallenge, function()
      self:onClickChallenge(self.curOppoIndex)
    end)
    self.canChallenge = nil
  end)
  self:listenEvent("PeakArenaChallengeTimesChanged", function()
    self:refreshChallengeTimes()
  end)
  self:listenEvent("PeakArenaRedDotChanged", function()
    self:refreshRedDot()
  end)
  self:listenEvent("PeakArenaSetLineUpSuccess", function()
    self:refreshDefendGs()
  end)
  self:listenTimer(Timer:Always(1), function()
    self:refreshPromptCard()
    self:refreshEvolveInfo()
    self:refreshSeasonInfo()
  end)
  self:registerOnPopSceneHandler("onPop", function()
    self.mgr:setPvpSceneInstance(nil)
  end)
end

function PeakArenaPvpScene:canShowRedDot(key)
  key = "PeakArenaPvpSceneRedDot_" .. key
  local value = ed.storage.getString(key)
  return key ~= value
end

function PeakArenaPvpScene:markRedDotRead(key)
  key = "PeakArenaPvpSceneRedDot_" .. key
  ed.storage.setValue(key, key)
end

function PeakArenaPvpScene:refreshRedDot()
  self:refreshRewardRedDot()
  self:refreshRecordsRedDot()
  self:refreshBanHeroRedDot()
end

function PeakArenaPvpScene:refreshRewardRedDot()
  local key = ed.PeakArenaRedDotTreeKeys.Reward
  local flag = ed.PeakArenaRedDotTree:getFlag(key)
  self.ui.img_reward_red_tag:setVisible(flag)
end

function PeakArenaPvpScene:refreshBanHeroRedDot()
  local key = ed.PeakArenaRedDotTreeKeys.BanHero
  local flag = ed.PeakArenaRedDotTree:getFlag(key)
  self.ui.img_ban_hero_red_tag:setVisible(flag)
end

function PeakArenaPvpScene:formatTime(time)
  local timeStr = ""
  local oneDaySeconds = 86400
  time = math.max(time, 0)
  if oneDaySeconds < time then
    local days = math.floor(time / oneDaySeconds)
    timeStr = string.format(T("%d\229\164\169"), days)
    local hours = math.floor(time % oneDaySeconds / 3600)
    if 0 < hours then
      timeStr = timeStr .. string.format(T("%d\229\176\143\230\151\182"), hours)
    end
  else
    local hours = math.floor(time / 3600)
    timeStr = string.format(T("%d\229\176\143\230\151\182"), hours)
    local minutes = math.floor(time % 3600 / 60)
    timeStr = timeStr .. string.format(T("%d\229\136\134\233\146\159"), minutes)
  end
  return timeStr
end

function PeakArenaPvpScene:refreshRecordsRedDot()
  local key = ed.PeakArenaRedDotTreeKeys.Attack
  local flag = ed.PeakArenaRedDotTree:getFlag(key)
  self.ui.recordTag:setVisible(flag)
end

function PeakArenaPvpScene:split(str, pat)
  local t = {}
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t, cap)
    end
    last_end = e + 1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

function PeakArenaPvpScene:toConfigTable(ss)
  local function getVal(index)
    return ss[index]
  end
  
  local typ = getVal(1)
  if typ == "text" then
    return {
      type = "text",
      style = getVal(2),
      value = getVal(3),
      offset = getVal(4) or 0
    }
  elseif typ == "hero" then
    return {
      type = "hero",
      heroId = tonumber(getVal(2)),
      length = tonumber(getVal(3))
    }
  elseif typ == "sprite" then
    return {
      type = "sprite",
      res = getVal(2),
      scale = tonumber(getVal(3)) or 1,
      offset = getVal(4) or 0
    }
  else
    error("unknown type: " .. typ)
  end
end

function PeakArenaPvpScene:createSummaryNode(config)
  local typ = config.type
  if typ == "text" then
    local style = config.style
    local color
    if style == "green" then
      color = ccc3(119, 255, 91)
    elseif style == "blue" then
      color = ccc3(91, 255, 249)
    elseif style == "orange" then
      color = ccc3(255, 191, 91)
    else
      color = ccc3(255, 234, 198)
    end
    local label = ed.createLabelTTF(config.value, 15)
    label:setAnchorPoint(ccp(0, 0.5))
    ed.setLabelColor(label, color)
    ed.setLabelStroke(label, ccc3(99, 13, 16), 1.6)
    return label, config.offset
  elseif typ == "hero" then
    local iconItem = ed.readhero.createIconByID(config.heroId, {
      length = config.length,
      isShowLegendEquip = ed.openLegendEquip()
    })
    iconItem:showLegendEquip(ed.off_legendEquipOp)
    return iconItem.icon
  elseif typ == "sprite" then
    local sprite = ed.createSprite(config.res)
    sprite:setScale(config.scale)
    return sprite, config.offset
  else
    error("unknown type: " .. typ)
  end
end

function PeakArenaPvpScene:createSummaryLine(text)
  local arr = {}
  local len = string.len(text)
  local index = 1
  while true do
    local leftIndex = string.find(text, "<", index)
    if not leftIndex then
      break
    end
    if index < leftIndex then
      local subS = string.sub(text, index, leftIndex - 1)
      table.insert(arr, {
        type = "text",
        style = "normal",
        value = subS
      })
    end
    local rightIndex = string.find(text, ">", leftIndex + 1)
    local subS = string.sub(text, leftIndex + 1, rightIndex - 1)
    local ss = self:split(subS, "|")
    local config = self:toConfigTable(ss)
    table.insert(arr, config)
    index = rightIndex + 1
  end
  if len > index then
    local subS = string.sub(text, index, len)
    table.insert(arr, {
      type = "text",
      style = "normal",
      value = subS
    })
  end
  local container = CCSprite:create()
  local lastNode
  for _, config in ipairs(arr) do
    local node, offset = self:createSummaryNode(config)
    offset = offset or 0
    if lastNode then
      ed.right2(node, lastNode, offset)
    end
    container:addChild(node)
    lastNode = node
  end
  return container
end

function PeakArenaPvpScene:refreshSummaryContents()
  local summary = self.mgr:getSummary()
  local ox, oy = 25, 225
  local text1 = T("\230\130\168\229\156\168\230\156\172\232\181\155\229\173\163\228\184\173\239\188\140\230\128\187\229\133\177\230\140\145\230\136\152\228\186\134<text|green|%d>\230\172\161\239\188\140\232\131\156\229\156\186\228\184\186<text|green|%d>\239\188\140\232\182\133\232\191\135\228\186\134<text|green|%d%%>\231\154\132\231\142\169\229\174\182\239\188\129", summary._total_challenge_count or 0, summary._challenge_victory_count or 0, summary._challenge_victory_over or 0)
  local line1 = self:createSummaryLine(text1)
  line1:setPosition(ccp(ox, oy))
  self.ui.panel_summary_contents:addChild(line1)
  oy = oy - 30
  local text2 = T("\229\143\151\229\136\176<text|blue|%d>\230\172\161\230\148\187\229\135\187\239\188\140\233\152\178\229\174\136\232\131\156\229\156\186\228\184\186<text|green|%d>\239\188\140\229\143\170\230\156\137<text|green|%d%%>\231\154\132\231\142\169\229\174\182\232\131\189\228\184\142\230\130\168\229\140\185\230\149\140\239\188\129", summary._total_defend_count or 0, summary._defend_victory_count or 0, summary._defend_victory_over or 0)
  local line2 = self:createSummaryLine(text2)
  line2:setPosition(ccp(ox, oy))
  self.ui.panel_summary_contents:addChild(line2)
  oy = oy - 30
  local challenges = summary._challenges or {}
  if summary._challenges then
    local challenge = challenges[1] or {}
    local time = challenge._bt_time or 0
    local name = (challenge._oppo or {})._summary or {}._name or "NickName"
    local text3 = T("<text|green|%s> \230\130\168\233\129\135\229\136\176\228\186\134\230\156\172\232\181\155\229\173\163\230\156\128\233\154\190\231\188\160\231\154\132\229\175\185\230\137\139<text|orange|%s>", os.date("%Y/%m/%d", time), name)
    local line3 = self:createSummaryLine(text3)
    line3:setPosition(ccp(ox, oy))
    self.ui.panel_summary_contents:addChild(line3)
    oy = oy - 18
    local line4 = self:createSummaryLine(T("\233\130\163\228\184\128\229\174\154\230\152\175\228\184\128\229\156\186\230\131\138\229\191\131\229\138\168\233\173\132\231\154\132\229\175\185\229\134\179\229\144\167\239\188\129"))
    line4:setPosition(ccp(ox, oy))
    self.ui.panel_summary_contents:addChild(line4)
    oy = oy - 30
  end
  if summary._hero_used then
    local heroUseData = summary._hero_used or {}
    local text5 = T("\232\181\155\229\173\163\228\184\173\239\188\140\230\130\168\228\189\191\231\148\168\230\172\161\230\149\176\230\156\128\229\164\154\231\154\132\232\139\177\233\155\132\230\152\175 <hero|%d|40> \239\188\140\230\128\187\229\133\177\228\184\138\233\152\181<text|green|%d>\230\172\161\239\188\140", heroUseData[1] or 0, heroUseData[2] or 0)
    local line5 = self:createSummaryLine(text5)
    line5:setPosition(ccp(ox, oy))
    self.ui.panel_summary_contents:addChild(line5)
    oy = oy - 18
    local line6 = self:createSummaryLine(T("\228\184\141\232\166\129\229\191\152\232\174\176\231\187\153\229\138\179\230\168\161\233\162\129\229\143\145\228\184\128\230\156\181\229\176\143\231\186\162\232\138\177\227\128\130"))
    line6:setPosition(ccp(ox, oy))
    self.ui.panel_summary_contents:addChild(line6)
    oy = oy - 30
  end
  local topGrade = summary._top_grade or 1
  local text7 = T("\230\156\128\233\171\152\232\190\190\229\136\176\230\174\181\228\189\141<sprite|%s|0.48><sprite|%s|0.7><text|normal|\239\188\140\232\142\183\229\190\151|-20><sprite|UI/alpha/HVGA/topArena/icon_season_medal.png|1|1><text|green|%d>\239\188\140\230\142\146\229\144\141<text|green|%d>\239\188\140", self.mgr:getGradeIconRes(topGrade), self.mgr:getGradeTextRes(topGrade), summary._top_medal or 0, summary._medal_rank or 0)
  local line7 = self:createSummaryLine(text7)
  line7:setPosition(ccp(ox, oy))
  self.ui.panel_summary_contents:addChild(line7)
  oy = oy - 36
  local line8 = self:createSummaryLine(T("\231\156\159\230\152\175\228\186\134\228\184\141\232\181\183\239\188\129\230\156\155\230\130\168\229\156\168\228\184\139\232\181\155\229\173\163\228\184\173\228\185\159\229\134\141\230\142\165\229\134\141\229\142\137\239\188\129"))
  line8:setPosition(ccp(ox, oy))
  self.ui.panel_summary_contents:addChild(line8)
end

function PeakArenaPvpScene:doBuyTimes()
  ed.ui.BuyPeakArenaTicketBox.create()
end

function PeakArenaPvpScene:OnRefreshOppoEvent(data)
  self:refreshOppos(data)
  self:refreshChangeOppoBtn()
end

function PeakArenaPvpScene:OnGetLineupEvent(lineups)
  ed.ui.PeakArenaSetTeamWin.create(lineups):popWindow()
end

function PeakArenaPvpScene:onClickSetTeam()
  if self.mgr:isOnSeason() or self.mgr:isPlayoff() then
    ed.PeakArenaNetwork:sendGetLineup()
  else
    ed.showToast(T("\229\189\147\229\137\141\231\138\182\230\128\129\228\184\141\229\143\175\232\174\190\231\189\174\233\152\178\229\174\136\233\152\181\229\174\185"))
  end
end

function PeakArenaPvpScene:onClickRecords()
  ed.PeakArenaNetwork:sendGetRecords()
end

function PeakArenaPvpScene:onClickRefresh()
  if self.mgr:isSelfHighGrade() then
    ed.showToast(T("\230\130\168\229\183\178\232\191\155\229\133\165\228\188\160\229\165\135\230\174\181\228\189\141\239\188\140\228\184\141\232\131\189\229\136\183\230\150\176\230\140\145\230\136\152\229\175\185\230\137\139"))
    return
  end
  if self.mgr:isEvolving() then
    ed.showToast(T("\230\130\168\229\183\178\229\188\128\229\144\175\230\153\139\231\186\167\232\181\155\239\188\140\228\184\141\232\131\189\229\136\183\230\150\176\230\140\145\230\136\152\229\175\185\230\137\139"))
    return
  end
  if self.mgr:isCoungting() then
    ed.showToast(T("\231\187\147\231\174\151\230\156\159\233\151\180\230\151\160\230\179\149\229\136\183\230\150\176\229\175\185\230\137\139\239\188\140\232\175\183\232\128\144\229\191\131\231\173\137\229\190\133"))
    return
  end
  if 0 == self.mgr.leftRefreshTimes then
    ed.showToast(T("\229\136\183\230\150\176\230\172\161\230\149\176\228\184\141\232\182\179\239\188\129\239\188\129\239\188\129"))
    return
  end
  ed.showConfirmDialog({
    text = T("\231\161\174\232\174\164\229\136\183\230\150\176\229\175\185\230\137\139\239\188\159"),
    rightHandler = function()
      ed.PeakArenaNetwork:sendRefreshOppo(true)
    end
  })
end

function PeakArenaPvpScene:onClickAddTimes()
  self:doBuyTimes()
end

function PeakArenaPvpScene:onClickOppoHead(index)
  if not self.mgr:isOnSeason() and not self.mgr:isPlayoff() then
    return
  end
  if self.mgr:getOppo(index) == nil then
    return
  end
  local oppo = self.mgr:getOppo(index)
  self.curOppoIndex = index
  ed.PeakArenaNetwork:sendQueryPlayer(oppo._role_id)
end

function PeakArenaPvpScene:toCNStyleHour(hour)
  local pre
  local showHour = hour
  if hour < 12 then
    pre = T("\228\184\138\229\141\136")
  elseif hour == 12 then
    pre = T("\228\184\173\229\141\136")
  elseif hour < 18 then
    pre = T("\228\184\139\229\141\136")
    showHour = showHour - 12
  else
    pre = T("\230\153\154\228\184\138")
    showHour = showHour - 12
  end
  return pre .. showHour .. T("\231\130\185")
end

function PeakArenaPvpScene:isValidChallengeTime()
  local weekIndex = ed.getWeekdayIndex()
  local beginHour, endHour
  if weekIndex == 6 then
    beginHour = 10
    endHour = 22
  else
    beginHour = 10
    endHour = 24
  end
  local h, m, s = ed.time2HMS()
  local seconds = h * 3600 + m * 60 + s
  local b = self.mgr.canChallenge == 1
  local prompt = T("\229\189\147\229\137\141\228\184\141\229\143\175\230\140\145\230\136\152")
  return b, prompt
end

function PeakArenaPvpScene:canChallengeFun(index)
  if self.mgr:getOppo(index) == nil then
    return false, T("\228\189\141\231\189\174%d\228\184\138\230\178\161\230\156\137\229\175\185\230\137\139", index)
  end
  if self.mgr:isEvolving() then
    return true
  end
  if self.mgr:isCoungting() then
    return false, T("\231\187\147\231\174\151\230\156\159\233\151\180\230\151\160\230\179\149\230\140\145\230\136\152\229\175\185\230\137\139\239\188\140\232\175\183\232\128\144\229\191\131\231\173\137\229\190\133")
  end
  if self.mgr:getLeftTimes() <= 0 and self.mgr:getLeftTimes() <= 0 then
    self:doBuyTimes()
    return false, T("\232\191\155\230\148\187\230\172\161\230\149\176\228\184\141\232\182\179")
  end
  local isValidTime, prompt = self:isValidChallengeTime()
  if not isValidTime then
    return false, prompt
  end
  return true
end

function PeakArenaPvpScene:onClickChallenge(index)
  local canChallenge, prompt = self:canChallengeFun(index)
  if not canChallenge then
    ed.showToast(prompt)
    return
  end
  self.selectIndex = index
  local oppo = self.mgr:getOppo(index)
  self.selectOppo = oppo
  ed.PeakArenaNetwork:sendQueryOppo(oppo._role_id)
end

function PeakArenaPvpScene:OnQueryOppoResult(oppoData)
  local teams = oppoData._teams or {}
  local oppoTeams = {}
  local teamCount = self.selectOppo._grade >= 6 and self.mgr.maxLineupAmount or self.mgr.TEAM_COUNT
  for i = 1, teamCount do
    local heroes = teams[i] and teams[i]._heroes
    if heroes then
      local arr = {}
      for j = 1, 5 do
        if heroes[j] and heroes[j]._tid == self.mgr.UNKNOWN_HERO_ID then
          table.insert(arr, {})
        elseif heroes[j] then
          table.insert(arr, heroes[j])
        end
      end
      oppoTeams[i] = arr
    else
      oppoTeams[i] = {}
    end
  end
  ed.UITool.openView("PeakArenaPvpBattlePrepareScene", {
    mode = "attack",
    team_count = self.selectOppo._grade >= self.mgr.reserve.grade and self.mgr.maxLineupAmount or self.mgr.TEAM_COUNT,
    oppo_teams = oppoTeams,
    oppo_summary = self.selectOppo,
    baned_hero_id_list = self.mgr:getBanedHeroes()
  })
  self.oppoTeams = teams
end

function PeakArenaPvpScene:OnSetAttackTeamResult(data)
  local oppo = self.selectOppo
  if self.mgr:isEvolving() then
    ed.PeakArenaNetwork:sendChallengeEvolveOppo(oppo._role_id, data.attackTeam)
  else
    ed.PeakArenaNetwork:sendChallengeOppo(oppo._role_id, data.attackTeam)
  end
  ed.loadEnd()
  ed.openMemeryGC = false
  self:showBattlePanel(data.attackTeam)
end

function PeakArenaPvpScene:showBattlePanel(selfTeams)
  local oppo = self.selectOppo
  local oppoTeams = self.oppoTeams
  local oppoFirstTeam = oppoTeams[1]
  local heroes = oppoFirstTeam._heroes
  if heroes then
  else
    heroes = {
      {},
      {},
      {},
      {},
      {}
    }
  end
  local data1 = {
    selfSummary = ed.player:getUserSummary(),
    oppoSummary = oppo._summary,
    grade = oppo._grade
  }
  local panel = ed.ui.PeakArenaBattlePanel.create(data1)
  panel:popWindow()
end

function PeakArenaPvpScene:OnChallengeResult(data)
  self.challengeResult = data
  local records = data._battle_replay._records
  self.curRecords = records
  self.curRecordIdx = 0
end

function PeakArenaPvpScene:handlerResult()
  if self.challengeResult then
    local battleResult = self.challengeResult._result
    local ui = self.uiList[self.selectIndex]
    ui.btn_battle:setVisible(false)
    if battleResult == "victory" then
      ui.bg_result_win:setVisible(true)
      ui.bg_result_win:setScale(3)
      ui.bg_result_win:runAction(CCScaleTo:create(0.1, 1))
    elseif battleResult == "defeat" then
      ui.bg_result_lose:setVisible(true)
      ui.bg_result_lose:setScale(3)
      ui.bg_result_lose:runAction(CCScaleTo:create(0.1, 1))
    end
    self.challengeResult = nil
    self:listenTimer(Timer:Once(0.3), function()
      ed.PeakArenaNetwork:sendRefreshOppo(false)
    end)
  end
end

function PeakArenaPvpScene:onBattleEnd()
  ed.openMemeryGC = true
  self:popGradeUpDownWindow(true)
end

function PeakArenaPvpScene:popGradeUpDownWindow(showAction)
  self:listenTimer(Timer:Once(0), function()
    if self.mgr.tallyResult then
      ed.ui.peakArenaWeeklyWin.create({
        callback = function()
          self:popGradeUpDownWindow(showAction)
        end
      })
    elseif self.mgr.evolveState == "prepare" then
      ed.ui.peakArenaEvolveRuleWin.create({
        time = 3,
        callback = function()
          self.mgr.evolveState = "running"
          self:popGradeUpDownWindow(showAction)
        end
      })
    elseif self.mgr.evolveState == "success" then
      ed.ui.peakArenaGradeChangeWin.create({
        mode = "success",
        callback = function()
          self.mgr.evolveState = nil
          self:popGradeUpDownWindow(showAction)
        end
      })
    elseif self.mgr.evolveState == "fail" then
      ed.ui.peakArenaGradeChangeWin.create({
        mode = "fail",
        callback = function()
          self.mgr.evolveState = nil
          self:popGradeUpDownWindow(showAction)
        end
      })
    elseif self.mgr.gradeState == "fall" then
      ed.ui.peakArenaGradeChangeWin.create({
        mode = "down",
        callback = function()
          self.mgr.gradeState = nil
          self:popGradeUpDownWindow(showAction)
        end
      })
    elseif self.mgr.gradeState == "raise" then
      ed.ui.peakArenaGradeChangeWin.create({
        mode = "up",
        callback = function()
          self.mgr.gradeState = nil
          self:popGradeUpDownWindow(showAction)
        end
      })
    elseif self.mgr:shouldPopSeasonSummary() then
      ed.ui.PeakArenaSummaryWin.create({closeTime = 6})
    else
      self:refreshUI(showAction)
    end
  end)
end

function PeakArenaPvpScene:onClickRule()
  self:markRedDotRead("Rule")
  ed.ui.PeakArenaRuleWin.create():popWindow()
end

function PeakArenaPvpScene:onClickRecordReview()
  ed.UITool.openView("PeakArenaRecordReview")
end

function PeakArenaPvpScene:onClickReward()
  if ed.PeakArenaManager:isPlayoff() then
    ed.showToast(T("\229\189\147\229\137\141\229\164\132\228\186\142\228\188\145\233\151\178\232\181\155\239\188\140\230\154\130\230\151\160\229\165\150\229\138\177\231\187\147\231\174\151"))
  else
    ed.UITool.openView("PeakArenaRewardWin")
  end
end

function PeakArenaPvpScene:onClickRanklist()
  ed.UITool.openView("PeakArenaRankListWin")
end

function PeakArenaPvpScene:onClickMyGradeIcon()
  if ed.PeakArenaManager:isPlayoff() then
    ed.showToast(T("\229\189\147\229\137\141\229\164\132\228\186\142\228\188\145\233\151\178\232\181\155\239\188\140\230\154\130\230\151\160\229\165\150\229\138\177\231\187\147\231\174\151"))
  else
    ed.UITool.openView("PeakArenaRewardWin", {tabIndex = 5})
  end
end

function PeakArenaPvpScene:onClickBattleLog()
  ed.PeakArenaRedDotTree:update(ed.PeakArenaRedDotTreeKeys.Attack, false)
  ed.UITool.openView("PeakArenaBattleLogWin")
end
