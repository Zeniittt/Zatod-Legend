local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.realArena = class
ed.UITool.registViewOpenFunc("KingsPvpMainScene", function(param)
  local reason = ed.playerlimit.getAreaUnlockPrompt("RealArena")
  if reason then
    ed.showToast(reason)
    return
  end
  local heroAmount = 0
  for id, hero in pairs(ed.player.heroes or {}) do
    heroAmount = heroAmount + 1
  end
  local needHeroAmount = ed.getDataTable("KingsPVPConfig")["Need Heros"].Value[1]
  if heroAmount < needHeroAmount then
    ed.showToast(string.format(T("\232\139\177\233\155\132\230\149\176\233\135\143\228\184\141\232\182\179%s\228\184\170"), needHeroAmount))
    return
  end
  ed.realarena.network_mgr:RequestOpenPanel()
end)

function class.create(param)
  local self = base.create("KingsPvpMainScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self:initView()
  self:adaptUI()
  self:registerRedPoint()
  self:setBackButton()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsMainScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  ed.layout.lazyAdaptBG(ui.image_bg)
  local seasonId = ed.realarena.mgr:getSeasonId()
  local _, titleText = ed.UITool.createSceneTitle(T("\232\175\184\231\142\139\228\186\137\233\156\184"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  local testBg = ed.createSprite("UI/alpha/1080P/newkingspvp/main/test_bg.png")
  local text = T("\230\181\139\232\175\149\231\137\136")
  if 0 < seasonId then
    text = string.format(T("S%s\232\181\155\229\173\163"), seasonId)
  end
  local testLabel = ed.createLabelTTF(text, 16)
  ed.setLabelColor(testLabel, ed.toccc3(16775806))
  testBg:addChild(testLabel)
  ed.layout.centerInParent(testLabel)
  titleText:addChild(testBg)
  testBg:setPosition(ccp(titleText:getContentSize().width + testBg:getContentSize().width / 2 + 2, titleText:getContentSize().height / 2))
  self:initLabels()
  self:initFreeDragList()
  local eff = ed.createSpine("effect/eff_UI_kingspvp_matchbutton/eff_UI_kingspvp_matchbutton", 0.5)
  eff:setAnimation(0, "Idle", true)
  self.ui.rank_icon:addChild(eff)
  ed.layout.centerXInParent(eff)
  eff:setPositionY(4)
  self:refreshScore()
  self:refreshBlockTime()
  self:refreshBuffIcon()
end

function class:registerRedPoint()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("kings_pvp_grade_reward", self, {
    handle = function(value)
      self.ui.image_reward_red_dot:setVisible(0 < value)
    end
  })
  self.redPointMgr:setNodeValue("kings_pvp_legend_equip_open", 0)
end

function class:onPopScene()
  self.redPointMgr:unregisterAllValueChange(self)
  ed.realarena.network_mgr:CloseConnection()
  base.onPopScene(self)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_rank, {
    left = 20 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_battle_record, {
    left = 20 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_history, {
    left = 20 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_reward, {
    left = 20 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_grade, {
    left = 20 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.image_buff_icon, {
    left = 20 + ed.display.getNotchHeight()
  }, false, true)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_rank, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_battle_record, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_history, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_reward, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_grade, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_my_rank, ed.toccc3(7425299), 1)
  ed.setLabelStroke(self.ui.label_punish_tips, ed.toccc3(6358784), 1)
  ed.setLabelStroke(self.ui.label_rank_math_time_limit, ed.toccc3(2049063), 1)
  ed.setLabelFontName(self.ui.label_punish_left_time, ed.fontBold)
  local seasonId = ed.realarena.mgr:getSeasonId()
  local seasonNum = ed.getNumberNode({
    text = string.format("S%s", seasonId),
    folder = "season"
  }).node
  seasonNum:setScale(1)
  self.ui.btn_rank_match:addChild(seasonNum)
  seasonNum:setPosition(self.ui.panel_season_pos:getPosition())
  local tips = ed.ui.gradientLabel.create({
    text = T("\230\156\172\229\145\168\233\153\144\229\133\141"),
    fontSize = 21,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16775806),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(6174212)
  })
  self.ui.panel_free_tips:addChild(tips.node)
  ed.layout.centerInParent(tips.node)
  local roomModeName = ed.ui.gradientLabel.create({
    text = T("\230\136\191\233\151\180\230\168\161\229\188\143"),
    fontSize = 32,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776066),
    endColor = ed.toccc3(16776667)
  })
  self.ui.btn_room_mode:addChild(roomModeName.node)
  roomModeName.node:setPosition(self.ui.panel_room_mode_name:getPosition())
  local rankMatchName = ed.ui.gradientLabel.create({
    text = T("\229\164\169\230\162\175\229\140\185\233\133\141"),
    fontSize = 34,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776066),
    endColor = ed.toccc3(16776667)
  })
  self.ui.btn_rank_match:addChild(rankMatchName.node)
  rankMatchName.node:setPosition(self.ui.panel_rank_match_name:getPosition())
  local normalMatchName = ed.ui.gradientLabel.create({
    text = T("\230\153\174\233\128\154\229\140\185\233\133\141"),
    fontSize = 32,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776066),
    endColor = ed.toccc3(16776667)
  })
  self.ui.btn_normal_match:addChild(normalMatchName.node)
  normalMatchName.node:setPosition(self.ui.panel_narmal_match_name:getPosition())
end

function class:refreshScore()
  local rankInfo = ed.realarena.mgr:GetRankInfo()
  local score = rankInfo._score or 0
  local gradeId = ed.realarena.mgr:GetMyGrade()
  local gradeCfg = ed.getDataTable("KingsGrade")[gradeId]
  ed.setTexture(self.ui.image_my_rank_icon, gradeCfg["Icon Small"], true)
  ed.setLabelString(self.ui.label_my_rank, gradeCfg.Name)
  ed.setLabelString(self.ui.label_my_rank_score, string.format(T("\231\167\175\229\136\134\239\188\154%s"), score))
end

function class:refreshBlockTime()
  local blockTime = ed.realarena.mgr:GetBlockTime()
  local serverTime = ed.getServerTime()
  if blockTime > serverTime then
    self.ui.image_punish_tips_bg:setVisible(true)
    self:listenTimer(Timer:Always(1, "blockCountTime"), function()
      self:refreshBlockLeftTime()
    end)
    self:refreshBlockLeftTime()
  else
    self.ui.image_punish_tips_bg:setVisible(false)
    CloseTimer("blockCountTime")
  end
end

function class:refreshBuffIcon()
  local actData = ed.activityHints.data:getRealArenaAthleticsActInfo()
  if not actData then
    self.ui.image_buff_icon:setVisible(false)
    return
  end
  local startTime = actData._start_time
  local endTime = actData._end_time
  local serverTime = ed.getServerTime()
  if endTime < serverTime or startTime > serverTime then
    self.ui.image_buff_icon:setVisible(false)
    return
  end
  self.ui.image_buff_icon:setVisible(true)
  local leftTime = endTime - serverTime
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 then
    self.ui.label_buff_left_time:setString(T("\229\137\169\228\189\153%s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.label_buff_left_time:setString(T("\229\137\169\228\189\153%s\229\164\169%s\230\151\182", day, hour))
  end
end

function class:refreshBlockLeftTime()
  local blockTime = ed.realarena.mgr:GetBlockTime()
  local serverTime = ed.getServerTime()
  local leftTime = math.max(blockTime - serverTime, 0)
  if leftTime <= 0 then
    self.ui.image_punish_tips_bg:setVisible(false)
    CloseTimer("blockCountTime")
    return
  end
  local min = math.floor(leftTime / 60)
  local second = leftTime % 60
  ed.setLabelString(self.ui.label_punish_left_time, string.format("%.2d:%.2d", min, second))
end

function class:initFreeDragList()
  local publicHeroList = ed.realarena.hero_mgr:GetPublicHeroList()
  if not publicHeroList or #publicHeroList == 0 then
    self.ui.image_free_bg:setVisible(false)
    return
  end
  local actData = ed.activityHints.data:getRealArenaAthleticsActInfo()
  self.freeDragList = ed.UITool.createDraglist(self.ui.panel_free, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    priority = -300
  })
  local panelSize = self.ui.panel_free:getContentSize()
  local width = 5
  self.freeHeroIcon = {}
  for index, hero in ipairs(publicHeroList) do
    local heroIcon = ed.readhero.createIconByServer(hero)
    heroIcon:addTimelyFreeTag()
    table.insert(self.freeHeroIcon, {
      icon = heroIcon.icon,
      hero = hero
    })
    if actData then
      heroIcon:showLegendEquip(not ed.openLegendEquip())
    else
      heroIcon:showLegendEquip(true)
    end
    self.freeDragList:addItem(heroIcon.icon)
    local iconWidth = heroIcon.icon:getContentSize().width
    heroIcon.icon:setPosition(ccp(width + iconWidth / 2, panelSize.height / 2))
    width = width + iconWidth + 10
  end
  self.freeDragList:initListWidth(width)
  local startTime, endTime = ed.realarena.hero_mgr:getFreeTime()
  local _, startM, startD = ed.time2YMD(startTime or 0)
  local _, endM, endD = ed.time2YMD(endTime or 0)
  ed.setLabelString(self.ui.label_date, string.format("%d.%d-%d.%d", startM, startD, endM, endD))
end

function class:getPressInHandler()
  local function handler(x, y)
    for _, cfg in ipairs(self.freeHeroIcon or {}) do
      if ed.containsPoint(cfg.icon, x, y) then
        return cfg
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, cfg)
    self:onClickFreeHero(cfg.hero)
  end
  
  return handler
end

function class:onClickFreeHero(hero)
end

function class:matchingError()
  ed.realarena.mgr:CancelMatch()
  ed.ui.kingsMatchingWindow.close()
end

function class:matchCancelled()
  ed.realarena.mgr:CancelMatch()
  ed.ui.kingsMatchingWindow.close()
  ed.ui.KingsPvpFindOppoWin.close()
end

function class:oppoFound(roomPlayerInfo)
  ed.realarena.mgr:LeaveMatching()
  ed.ui.kingsMatchingWindow.close()
  self:showOppoInfo(roomPlayerInfo)
end

function class:showOppoInfo(roomPlayerInfo)
  ed.playEffect(ed.sound.real_arena.oppo_found)
  ed.realarena.roomPlayerInfo = roomPlayerInfo or ed.realarena.roomPlayerInfo or {}
  ed.ui.KingsPvpFindOppoWin.create({
    hostInfo = roomPlayerInfo.hostInfo,
    guestInfo = roomPlayerInfo.guestInfo
  })
end

function class:oppoNotFound()
  ed.realarena.mgr:LeaveMatching()
  ed.ui.kingsMatchingWindow.close()
end

function class:showRecord()
  local record_data = ed.realarena.mgr.record_info
  ed.ui.KingsPvpRecordWin.create({records = record_data})
end

function class:showBattleDetailBoard()
  local data = ed.realarena.mgr.replay_info
  ed.realarena.replay_detail_data = data
  local total_count = data.total_count
  if total_count == 1 then
    ed.ui.KingsRecordDetail1Win.create(data)
  else
    ed.ui.KingsRecordDetail3Win.create(data)
  end
end

function class:dealFinishBattle(rewardTask)
end

function class:dealBattleEnd(isWin)
  ed.ui.KingsPvpFindOppoWin.close({skipAnim = true})
end

function class:dealBattleHouseInfo(roomInfo)
  if roomInfo._create_room then
    self:dealBattleHouseCreate(roomInfo._create_room)
  elseif roomInfo._enter_room then
    self:dealBattleHouseEnter(roomInfo._enter_room)
  elseif roomInfo._ready then
    self:dealBattleHouseReady(roomInfo._ready)
  elseif roomInfo._cancel then
    self:dealBattleHouseExit(roomInfo._cancel)
  elseif roomInfo._reconnect then
    self:dealBattleHouseReconnect(roomInfo._reconnect)
  end
end

function class:dealBattleHouseCreate(roomInfo, skipAnim)
  ed.UITool.openView("KingsPvpCreateRoomWindow", {room = roomInfo})
end

function class:dealBattleHouseEnter(_enter_room)
  local roomInfo = _enter_room._room_info
  local host = roomInfo._host
  local guest = roomInfo._guest
  ed.ui.KingsPvpFindOppoWin.create({
    hostInfo = {
      _server_name = host._server_name,
      _summary = host._summary,
      _rank_info = {
        _score = host._score or 0
      }
    },
    guestInfo = {
      _server_name = guest._server_name,
      _summary = guest._summary,
      _rank_info = {
        _score = guest._score or 0
      }
    }
  })
  self:listenTimer(Timer:Once(3), function()
    ed.realarena.network_mgr:RequestReadyHouse()
  end)
end

function class:dealBattleHouseReady(roomInfo)
  local readyInfo = roomInfo
  if readyInfo._room_info then
    self.myReady = readyInfo._room_info._host_ready
    self.oppoReady = readyInfo._room_info._guest_ready
  end
  if self.myReady == 1 and self.oppoReady == 1 then
    ed.realarena.mgr:StartMatch(ed.realarena.match_type[4], readyInfo._room_info._pvp_rule)
    ed.realarena.network_mgr:DoEnterDirectRoom(readyInfo)
  end
end

function class:dealBattleHouseExit()
end

function class:dealBattleHouseReconnect()
end

function class:HideAllLayers()
  class.hideVSLayer()
  ed.ui.KingsPvpFindOppoWin.close({skipAnim = true})
  ed.ui.KingsPvpCreateRoomWindow.close({skipAnim = true})
  ed.ui.KingsLoadingWindow.close({skipAnim = true})
end

function class:hideOppoInfo()
  ed.ui.KingsPvpFindOppoWin.close({skipAnim = true})
end

function class:closeBattleWindow()
  ed.ui.KingsPvpCreateRoomWindow.close({skipAnim = true})
end

function class.hideVSLayer()
  ed.ui.KingsLoadingWindow.close({skipAnim = true})
end

function class:onJoinTeam(teamId)
  ed.UITool.openView("KingsRoomWindow", {teamId = teamId})
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\231\142\169\230\179\149\232\175\180\230\152\142"),
    txt = ed.KingsPvpDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickBtnRoomMode()
  ed.UITool.openView("KingsPvpRoomModeWin")
end

function class:onClickBtnRankMatch()
  local serverTime = ed.getServerTime()
  local athleticsStartMinute = ed.getDataTable("KingsPVPConfig")["Athletics Start Minute"].Value[1]
  local athleticsEndMinute = ed.getDataTable("KingsPVPConfig")["Athletics End Minute"].Value[1]
  local year, month, day, hour, min, sec = ed.time2YMDHMS(serverTime + ed.getTimeDiff2Server())
  local todayMin = hour * 60 + min
  if athleticsStartMinute > todayMin or athleticsEndMinute <= todayMin then
    ed.showToast(T("\228\184\141\229\156\168\229\140\185\233\133\141\230\151\182\233\151\180\230\174\181\229\134\133"))
    return
  end
  local blockTime = ed.realarena.mgr:GetBlockTime()
  if blockTime > ed.getServerTime() then
    ed.showToast(T("\231\166\129\232\181\155\228\184\173\239\188\140\230\151\160\230\179\149\232\191\155\232\161\140\229\140\185\233\133\141"))
    return
  end
  local heroAmount = 0
  for id, hero in pairs(ed.player.heroes or {}) do
    heroAmount = heroAmount + 1
  end
  local needHeroAmount = ed.getDataTable("KingsPVPConfig")["Bo3 Need Heroes"].Value[1]
  if heroAmount < needHeroAmount then
    ed.showToast(string.format(T("\232\139\177\233\155\132\230\149\176\233\135\143\228\184\141\232\182\179%s\228\184\170"), needHeroAmount))
    return
  end
  ed.realarena.network_mgr:RequestMatch("athletics", "bo3")
  ed.realarena.mgr:StartMatch("athletics", "bo3")
end

function class:onClickNormalMatch()
  ed.UITool.openView("KingsPvpSelectModeWindow", {
    roomModeSelect = false,
    selectModeCB = function(mode, roomMode)
      ed.realarena.network_mgr:RequestMatch("casual", mode)
      ed.realarena.mgr:StartMatch("casual", mode)
    end
  })
end

function class:onClickBtnBattleRecord()
  ed.realarena.network_mgr:RequestRecord()
end

function class:onClickBtnRank()
  ed.UITool.openView("ranklist", {index = 4, index2 = 3})
end

function class:onTeamJoin(teamId)
  ed.UITool.openView("KingsRoomWindow", {teamId = teamId})
end

function class:onEnterScene()
  ed.player:requestPoint({
    "tavern_point",
    "tavern_point_weekly"
  })
  if self.selfScoreBefore and self.selfScoreAfter then
    local beforeGrade = ed.realarena.mgr:GetGradeByScore(self.selfScoreBefore._score)
    local afterGrade = ed.realarena.mgr:GetGradeByScore(self.selfScoreAfter._score)
    self.selfScoreBefore = nil
    self.selfScoreAfter = nil
    if beforeGrade < afterGrade then
      ed.UITool.openView("kingsGradeUpWin", {beforeGrade = beforeGrade, afterGrade = afterGrade})
    elseif beforeGrade > afterGrade then
      ed.UITool.openView("kingsGradeDownWin", {beforeGrade = beforeGrade, afterGrade = afterGrade})
    end
  end
end

function class:onClickBuffIcon()
  local window = ed.ui.kingsBuffTipsWindow.create()
  window:popWindow()
  ed.layout.relateLayout(self.ui.image_buff_icon, window.ui.image_bg, {top = 25})
  ed.layout.layoutWithMagin(window.ui.image_bg, {
    left = 10 + ed.display.getNotchHeight()
  }, false, true)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_room_mode", function()
    self:onClickBtnRoomMode()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "btn_rank_match", function()
    self:onClickBtnRankMatch()
  end, {pressScale = 0.95, priority = -301})
  ed.UITool.registerBtn(self, "btn_normal_match", function()
    self:onClickNormalMatch()
  end, {pressScale = 0.95, priority = -300})
  ed.UITool.registerBtn(self, "btn_rank", function()
    self:onClickBtnRank()
  end, {pressScale = 0.95, priority = -302})
  ed.UITool.registerBtn(self, "btn_battle_record", function()
    self:onClickBtnBattleRecord()
  end, {pressScale = 0.95, priority = -302})
  ed.UITool.registerBtn(self, "btn_history", function()
    ed.showToast("\229\142\134\229\143\178\232\174\176\229\189\149")
  end, {pressScale = 0.95, priority = -302})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.UITool.openView("kingsRankRewardWin")
  end, {pressScale = 0.95, priority = -302})
  ed.UITool.registerBtn(self, "btn_grade", function()
    ed.UITool.openView("kingsRankMedalWin")
  end, {pressScale = 0.95, priority = -302})
  ed.UITool.registerBtn(self, "image_buff_icon", function()
    self:onClickBuffIcon()
  end, {pressScale = 0.95, priority = -302})
end

function class:addEventListener()
  self:registerOnEnterHandler("onEnter", function()
    self:onEnterScene()
  end)
  self:listenEvent("RealArenaMatching", function()
    ed.UITool.openView("kingsMatchingWindow")
  end)
  self:listenEvent("RealArenaMatchingError", function()
    self:matchingError()
  end)
  self:listenEvent("RealArenaMatchingCancelled", function()
    self.matchCancelled()
  end)
  self:listenEvent("RealArenaMatchingCancelFailed", function()
    ed.showToast(T("\230\151\160\230\179\149\229\143\150\230\182\136"))
  end)
  self:listenEvent("RealArenaOppoFound", function(roomPlayerInfo)
    self:oppoFound(roomPlayerInfo)
  end)
  self:listenEvent("RealArenaOppoNotFound", function()
    self:oppoNotFound()
  end)
  self:listenEvent("RealArenaShowAchievement", function()
  end)
  self:listenEvent("RealArenaShowRecord", function()
    self:showRecord()
  end)
  self:listenEvent("RealArenaShowReplay", function()
    self:showBattleDetailBoard()
  end)
  self:listenEvent("RealArenaNetworkException", function()
    ed.showToast(T("\231\189\145\231\187\156\229\188\130\229\184\184\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\191\158\230\142\165"))
  end)
  self:listenEvent("RealArenaFinishBattle", function(rewardTask)
    self:dealFinishBattle(rewardTask)
  end)
  self:listenEvent("BattleHouseInfo", function(roomInfo)
    self:dealBattleHouseInfo(roomInfo)
  end)
  self:listenEvent("RealArenaBattleEnd", function(isWin)
    self:dealBattleEnd(isWin)
  end)
  self:listenEvent("RealArenaRefreshPanel", function(rankInfo)
    self.selfScoreBefore = rankInfo.selfScoreBefore
    self.selfScoreAfter = rankInfo.selfScoreAfter
    self:refreshScore()
  end)
  self:listenEvent("TeamJoin", function(teamId)
    self:onTeamJoin(teamId)
  end)
end
