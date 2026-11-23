local base = ed.ui.popwindow
local PeakArenaBattleLogWin = newclass(base.mt)
ed.ui.PeakArenaBattleLogWin = PeakArenaBattleLogWin
local TAB_RECORD = "record"
local TAB_STATISTIC = "statistic"
ed.UITool.registViewOpenFunc("PeakArenaBattleLogWin", function(param)
  ListenEventOnce("PeakArenaGetRecords", function(records)
    if not records._records and not records._playoffs_records then
      ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\232\174\176\229\189\149"))
      return
    end
    if not ed.getPopWindow("PeakArenaBattleLogWin") then
      PeakArenaBattleLogWin.create(records, param):popWindow()
    end
  end)
  ed.PeakArenaNetwork:sendGetRecords()
end)

function PeakArenaBattleLogWin.create(records, param)
  local self = base.create("PeakArenaBattleLogWin")
  setmetatable(self, PeakArenaBattleLogWin.mt)
  self:init(records, param)
  return self
end

function PeakArenaBattleLogWin:init(records, param)
  self.recordsDataList = records._records or {}
  self.playOffDataList = records._playoffs_records or {}
  self.stat = records._stat or {}
  self.param = param or {}
  self.selectTab = TAB_RECORD
  self:initView()
  self:refreshView()
  self:registerEvents()
  self:registerTouchHandler()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function PeakArenaBattleLogWin:initView()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaBattleLogWin)
  self.container:addChild(container)
  self.ui = ui
  self:initTableView()
  ed.setLabelStroke(self.ui.label_record, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_record_selected, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_statistic, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_statistic_selected, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_statistic_title, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_total_times_tips, ed.toccc3(11223324), 1)
  self.ui.label_total_times_tips:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_total_times, ed.toccc3(11228444), 1)
  ed.setLabelStroke(self.ui.label_today_times_tips, ed.toccc3(11223324), 1)
  self.ui.label_today_times_tips:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_today_times, ed.toccc3(11228444), 1)
  if EDCurLanguage == "cn" then
    self.ui.label_record:setString("\229\175\185\230\136\152\n\232\174\176\229\189\149")
    self.ui.label_record_selected:setString("\229\175\185\230\136\152\n\232\174\176\229\189\149")
    self.ui.label_statistic:setString("\230\149\176\230\141\174\n\231\187\159\232\174\161")
    self.ui.label_statistic_selected:setString("\230\149\176\230\141\174\n\231\187\159\232\174\161")
  else
    ed.adaptLabel(self.ui.label_record, {maxWidth = 60, minScale = 0.8})
    ed.adaptLabel(self.ui.label_record_selected, {maxWidth = 60, minScale = 0.8})
    ed.adaptLabel(self.ui.label_statistic, {maxWidth = 60, minScale = 0.8})
    ed.adaptLabel(self.ui.label_statistic_selected, {maxWidth = 60, minScale = 0.8})
  end
  self.ui.Label_2:limitWidthByScale(260)
  self.ui.Label_4:limitWidthByScale(260)
  self.ui.Label_2_2:limitWidthByScale(260)
  self.ui.Label_4_2:limitWidthByScale(260)
end

function PeakArenaBattleLogWin:refreshView()
  self.tableView:reloadData()
  self:refreshStatistic()
  self:refreshTabBtn()
  self:refreshLayerShow()
end

function PeakArenaBattleLogWin:refreshLayerShow()
  if self.selectTab == TAB_RECORD then
    self.ui.list_layer:setVisible(true)
    self.ui.statistic_layer:setVisible(false)
    self.ui.label_title:setString(T("\229\175\185\230\136\152\232\174\176\229\189\149"))
    self.tableView.dragList:setVisible(true)
  elseif self.selectTab == TAB_STATISTIC then
    self.ui.list_layer:setVisible(false)
    self.ui.statistic_layer:setVisible(true)
    self.ui.label_title:setString(T("\230\149\176\230\141\174\231\187\159\232\174\161"))
    self.tableView.dragList:setVisible(false)
  end
  self.ui.ImageView_3624:setPositionX(-self.ui.ImageView_3624:getContentSize().width * 0.5 - 10)
  self.ui.ImageView_3625:setPositionX(self.ui.label_title:getContentSize().width + self.ui.ImageView_3625:getContentSize().width * 0.5 + 10)
end

function PeakArenaBattleLogWin:refreshStatistic()
  local layerWidth = self.ui.statistic_layer:getContentSize().width
  local attackCnt = self.stat._attack_cnt or 0
  local attackWin = self.stat._attack_win or 0
  local defendCnt = self.stat._defend_cnt or 0
  local defendWin = self.stat._defend_win or 0
  ed.setString(self.ui.label_total_times, attackCnt + defendCnt)
  local labelWidth1 = self.ui.label_total_times_tips:getContentSize().width
  local labelWidth2 = self.ui.label_total_times:getContentSize().width
  self.ui.label_total_times_tips:setPositionX((layerWidth + labelWidth1 - labelWidth2) / 2)
  self.ui.label_total_times:setPositionX((layerWidth + labelWidth1 - labelWidth2) / 2)
  ed.setString(self.ui.label_total_attack_times, attackCnt)
  ed.setString(self.ui.label_total_attack_win_times, attackWin)
  ed.setString(self.ui.label_total_defend_times, defendCnt)
  ed.setString(self.ui.label_total_defend_win_times, defendWin)
  local dayAttackCnt = self.stat._day_attack_cnt or 0
  local dayAttackWin = self.stat._day_attack_win or 0
  local dayDefendCnt = self.stat._day_defend_cnt or 0
  local dayDefendWin = self.stat._day_defend_win or 0
  ed.setString(self.ui.label_today_times, dayAttackCnt + dayDefendCnt)
  local labelWidth3 = self.ui.label_today_times_tips:getContentSize().width
  local labelWidth4 = self.ui.label_today_times:getContentSize().width
  self.ui.label_today_times_tips:setPositionX((layerWidth + labelWidth3 - labelWidth4) / 2)
  self.ui.label_today_times:setPositionX((layerWidth + labelWidth3 - labelWidth4) / 2)
  ed.setString(self.ui.label_today_attack_times, dayAttackCnt)
  ed.setString(self.ui.label_today_attack_win_times, dayAttackWin)
  ed.setString(self.ui.label_today_defend_times, dayDefendCnt)
  ed.setString(self.ui.label_today_defend_win_times, dayDefendWin)
end

function PeakArenaBattleLogWin:initTableView()
  local size = self.ui.list_layer:getContentSize()
  local tableItem = {}
  for i = 1, #self.playOffDataList do
    table.insert(tableItem, {
      type = "Playoff",
      data = self.playOffDataList[i]
    })
  end
  if #self.playOffDataList > 0 then
    table.insert(tableItem, {type = "sepUi", show = true})
  end
  for i = 1, #self.recordsDataList do
    table.insert(tableItem, {
      type = "InSeason",
      data = self.recordsDataList[i]
    })
  end
  self.listData = tableItem
  local sepUi = {}
  self.delegate = {
    numberOfCells = function()
      return #tableItem
    end,
    cellSizeFromIndex = function(index)
      if tableItem[index].type == "sepUi" then
        return CCSizeMake(759, 33)
      else
        return CCSizeMake(759, 85)
      end
    end,
    createCell = function(index)
      if tableItem[index].type == "sepUi" then
        local node = CCNode:create()
        node:setVisible(tableItem[index].show)
        node:setContentSize(CCSizeMake(759, 33))
        local sepContainer = ed.createSprite("UI/alpha/1080P/toparena/toparena_record_line.png")
        node:addChild(sepContainer)
        sepContainer:setPosition(ccp(379.5, 12.5))
        local label = ed.createttf(T("\228\187\165\228\184\138\228\184\186\228\188\145\233\151\178\232\181\155\232\174\176\229\189\149"), 18)
        ed.setLabelColor(label, ed.toccc3(16776423))
        ed.setLabelStroke(label, ccc3(0, 0, 0), 1)
        sepContainer:addChild(label)
        label:setPosition(ccp(220, 21))
        return node
      else
        local item = tableItem[index]
        local itemContainer, ui = self:createRecordItem(index, item.data)
        return itemContainer, {
          recordData = item.data,
          ui = ui,
          index = index,
          type = tableItem[index].type
        }
      end
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if data then
        local ui = data.ui
        if ed.containsPoint(ui.btn_detail, x, y) then
          ui.btn_detail:setScale(0.95)
        end
        if ed.containsPoint(ui.image_lose_bg, x, y) or ed.containsPoint(ui.image_win_bg, x, y) then
          return cell
        end
      end
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if data then
        local recordData = data.recordData
        local index = data.index
        local ui = data.ui
        if ed.containsPoint(ui.btn_detail, x, y) then
          self:reqReplay(index, recordData._replay_id)
        elseif ed.containsPoint(ui.head, x, y) then
          ed.UITool.openView("playerInfoPanel", recordData._user_summary._role_id)
        end
      end
    end,
    cancelPressIn = function(cell, x, y)
      local data = cell.data
      if data then
        local ui = data.ui
        ui.btn_detail:setScale(1)
      end
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function PeakArenaBattleLogWin:createRecordItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaBattleLogItem)
  container:setContentSize(CCSizeMake(759, 85))
  ui.image_defend:setVisible(data._active and data._active ~= 1)
  ui.label_defend:setFontName(ed.fontBold)
  ui.label_score_text:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_defend, ed.toccc3(11558428), 1)
  ed.setLabelStroke(ui.label_evolve, ed.toccc3(15630098), 1)
  ed.setLabelStroke(ui.label_protect, ed.toccc3(3080450), 1)
  ui.label_evolve:limitWidthByScale(58)
  ui.label_protect:limitWidthByScale(70)
  local isVictory = data._bt_result == "victory"
  local isLoseProtect = data._is_lose_protect == 1
  local itemBgPath, imageResultPath, imageScorePath
  if isVictory then
    itemBgPath = "UI/alpha/1080P/toparena/toparena_record_win_bg.png"
    imageResultPath = "UI/alpha/1080P/toparena/toparena_record_win.png"
    imageScorePath = "UI/alpha/1080P/toparena/toparena_score_icon.png"
    ed.setLabelColor(ui.label_score_text, ed.toccc3(16773542))
    ed.setLabelStroke(ui.label_score_text, ed.toccc3(12542248), 1)
  else
    itemBgPath = "UI/alpha/1080P/toparena/toparena_record_lose_bg.png"
    imageResultPath = "UI/alpha/1080P/toparena/toparena_record_lose.png"
    imageScorePath = "UI/alpha/1080P/toparena/toparena_score_icon2.png"
    ed.setLabelColor(ui.label_score_text, ed.toccc3(3006463))
    ed.setLabelStroke(ui.label_score_text, ed.toccc3(5131389), 1)
  end
  ed.setLabelShadow(ui.Label_261, ccc3(0, 0, 0), ccp(1, 1))
  ed.setTexture(ui.image_bg, itemBgPath)
  ed.setTexture(ui.image_result, imageResultPath, true)
  ed.setTexture(ui.image_score_text, imageScorePath)
  ui.image_evolve:setVisible(data._is_evolve == 1)
  local peakArenaOppo = data._oppo
  local summary = peakArenaOppo._summary
  ui.image_protect:setVisible(isLoseProtect)
  ed.setLabelString(ui.label_server, peakArenaOppo._server_name)
  local timeDes = self:getTimeDes(data._bt_time)
  ui.label_date:setString(timeDes)
  local name = ed.getPlayerName(ed.transBotName(summary._name), summary._medal, {
    anchorPoint = ui.label_name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "image_name_bg", "label_name", name)
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.75,
    lvoffset = {x = -47, y = -25}
  }
  local head = ed.getWholeHeadIcon(param)
  ui.layer_head:addChild(head)
  ui.head = head
  ed.layout.centerInParent(head)
  local selfScore = data._self_score or 0
  local scoreChange = data._self_score_change or 0
  local scoreNode = ed.getNumberNode({
    text = selfScore + scoreChange,
    folder = "peak_score"
  }).node
  ui.panel_score:addChild(scoreNode)
  scoreNode:setScale(0.9)
  scoreNode:setPosition(ccp(scoreNode:getContentSize().width / 2 - 5, 20))
  if 0 < scoreChange then
    ed.setLabelColor(ui.label_score_change, ccc3(119, 255, 91))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(0), 1)
    ed.setLabelString(ui.label_score_change, scoreChange)
    ed.setTexture(ui.image_arrow, "UI/alpha/1080P/pvp/arrow_up.png")
  elseif scoreChange < 0 then
    ed.setLabelColor(ui.label_score_change, ccc3(255, 97, 66))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(0), 1)
    ed.setLabelString(ui.label_score_change, math.abs(scoreChange))
    ed.setTexture(ui.image_arrow, "UI/alpha/1080P/pvp/arrow_down.png")
  else
    if data._is_evolve == 1 then
      ed.setLabelColor(ui.label_score_change, ccc3(230, 237, 246))
      ed.setLabelStroke(ui.label_score_change, ed.toccc3(3166351), 1)
      ed.setLabelString(ui.label_score_change, T("\229\134\187\231\187\147\228\184\173"))
    else
      ed.setLabelColor(ui.label_score_change, ccc3(180, 254, 139))
      ed.setLabelStroke(ui.label_score_change, ed.toccc3(3080450), 1)
      ed.setLabelString(ui.label_score_change, T("\228\191\157\230\138\164\228\184\173"))
    end
    ui.label_score_change:setPositionX(ui.label_score_change:getPositionX() - 10)
    ui.image_arrow:setVisible(false)
  end
  return container, ui
end

function PeakArenaBattleLogWin:getTimeDes(battleTime)
  local nowTime = ed.getServerTime()
  local passTime = nowTime - battleTime
  local h, m, s = ed.second2hms(passTime)
  local timeDes
  if 24 <= h then
    local day = math.floor(h / 24)
    timeDes = T("%d\229\164\169\229\137\141", day)
    if 30 <= day then
      timeDes = T("30\229\164\169\229\137\141")
    end
  elseif 1 <= h then
    timeDes = T("%d\229\176\143\230\151\182\229\137\141", h)
  elseif 1 <= m then
    timeDes = T("%d\229\136\134\233\146\159\229\137\141", m)
  else
    timeDes = T("%d\231\167\146\229\137\141", s)
  end
  return timeDes
end

function PeakArenaBattleLogWin:reqReplay(index, replayId)
  self.reqReplayIndex = index
  ed.PeakArenaNetwork:sendGetReply(replayId)
end

function PeakArenaBattleLogWin:refreshTabBtn()
  self.ui.btn_record_selected:setVisible(self.selectTab == TAB_RECORD)
  self.ui.btn_statistic_selected:setVisible(self.selectTab == TAB_STATISTIC)
end

function PeakArenaBattleLogWin:onClickBtnRecord()
  if self.selectTab == TAB_RECORD then
    return
  end
  self.selectTab = TAB_RECORD
  self:refreshTabBtn()
  self:refreshLayerShow()
end

function PeakArenaBattleLogWin:onClickBtnStatistic()
  if self.selectTab == TAB_STATISTIC then
    return
  end
  self.selectTab = TAB_STATISTIC
  self:refreshTabBtn()
  self:refreshLayerShow()
end

function PeakArenaBattleLogWin:registerEvents()
  self:listenEvent("PeakArenaGetReplay", function(data)
    local replay = data._replay
    if not replay then
      ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\229\189\149\229\131\143"))
      return
    end
    if self.reqReplayIndex and self.listData[self.reqReplayIndex] then
      local challengeRecordData = self.listData[self.reqReplayIndex].data and self.listData[self.reqReplayIndex].data or self.listData[self.reqReplayIndex]
      local isAttacker = replay._records[1]._self_role_id == ed.getRoleId()
      local selfScoreChange, selfNewScore, oppoScoreChange, oppoNewScore
      if isAttacker then
        selfScoreChange = challengeRecordData._self_score_change or 0
        selfNewScore = selfScoreChange + (challengeRecordData._self_score or 0)
        oppoScoreChange = challengeRecordData._oppo_score_change or 0
        oppoNewScore = oppoScoreChange + (challengeRecordData._oppo_score or 0)
      else
        oppoScoreChange = challengeRecordData._self_score_change or 0
        oppoNewScore = oppoScoreChange + (challengeRecordData._self_score or 0)
        selfScoreChange = challengeRecordData._oppo_score_change or 0
        selfNewScore = selfScoreChange + (challengeRecordData._oppo_score or 0)
      end
      ed.UITool.openView("PeakArenaChallengeResultWin", {
        data = {
          _battle_replay = {
            _records = replay._records
          },
          _self_score_change = selfScoreChange,
          _self_new_score = selfNewScore,
          _oppo_score_change = oppoScoreChange,
          _oppo_new_score = oppoNewScore
        },
        isEvolving = challengeRecordData._is_evolve == 1,
        isReplay = true,
        isLoseProtect = data._is_lose_protect == 1
      })
      ed.PeakArenaManager:peakArenaAchFcaGroup()
    end
  end)
end

function PeakArenaBattleLogWin:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.playEffect(ed.sound.deo.common_click_feedback)
    self:destroy()
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_record", function()
    self:onClickBtnRecord()
  end)
  ed.UITool.registerBtn(self, "btn_statistic", function()
    self:onClickBtnStatistic()
  end)
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and self.clickOutSide then
        self:destroy()
      end
      return false
    end,
    key = "close"
  })
end
