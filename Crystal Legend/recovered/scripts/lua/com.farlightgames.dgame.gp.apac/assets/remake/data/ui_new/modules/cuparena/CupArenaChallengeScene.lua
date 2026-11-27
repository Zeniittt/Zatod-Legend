local CupArenaChallengeScene = newclass()
ed.ui.CupArenaChallengeScene = CupArenaChallengeScene

function CupArenaChallengeScene.create(viewDelegate)
  local self = {}
  setmetatable(self, CupArenaChallengeScene.mt)
  self.viewDelegate = viewDelegate
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  return self
end

function CupArenaChallengeScene:initData()
  self.oppoDataArr = nil
  self.challengeTargetIndex = 0
end

function CupArenaChallengeScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_times, {right = 250, top = 18})
  self.ui.bg_times:setScale(1 / self.viewDelegate.ui.panel_challenge:getScale())
end

function CupArenaChallengeScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.CupArenaChallengePlazaScene)
  self.viewDelegate.ui.panel_challenge:addChild(container)
  self.ui = ui
  self:adaptUI()
  ed.setLabelStroke(self.ui.label_my_rank, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_my_camp, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_my_score, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_my_medal, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_switch, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_task, ed.toccc3(3087902), 1)
end

function CupArenaChallengeScene:initChallengeUI()
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
    titleLabel:setPosition(ccp(183, 458))
  end
  ed.setLabelString(self.ui.label_my_rank, T("\233\152\181\232\144\165\229\134\133\230\142\146\229\144\141\239\188\154%d", ed.CupArenaManager:getRank()))
  local campTableItem = ed.getDataTable("CupArenaCamp")[ed.CupArenaManager:getCampId()]
  ed.setLabelString(self.ui.label_my_camp, T("\233\152\181\232\144\165\239\188\154%s", campTableItem["Camp Name"]))
  ed.setLabelString(self.ui.label_my_score, T("\231\167\175\229\136\134\239\188\154%d", ed.CupArenaManager:getScore()))
  ed.setLabelString(self.ui.label_my_medal, T("\229\139\139\231\171\160\239\188\154%d", ed.CupArenaManager:getMedal()))
  ed.right2(self.ui.img_my_medal, self.ui.label_my_medal, 10)
  local gradeTableInfo = ed.CupArenaManager:getGradeInfoByScore(ed.CupArenaManager:getScore())
  ed.setTexture(self.ui.img_my_grade, gradeTableInfo.iconRes)
  ed.setTexture(self.ui.img_my_grade_name, gradeTableInfo.nameIconRes)
  self:refreshChallengeTimes()
  self:refreshSwitchTimes()
  self:refreshTaskRedPoint()
end

function CupArenaChallengeScene:refreshChallengeTimes(...)
  local leftTimes = ed.CupArenaManager:getChallengeCount()
  local maxTimes = ed.CupArenaManager:getMaxChallengeCount()
  ed.setLabelString(self.ui.label_times, T("\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\154 %d/%d", leftTimes, maxTimes))
  self.ui.btn_addtimes:setVisible(0 == leftTimes)
end

function CupArenaChallengeScene:refreshSwitchTimes(...)
  if self:isHigherGrade() then
    self.ui.icon_switch:setVisible(false)
    self.ui.btn_refresh_tip:setVisible(false)
    ed.setString(self.ui.label_switch, T("\229\189\147\229\137\141\230\174\181\228\189\141\228\184\141\232\131\189\229\136\183\230\150\176"))
    self.ui.label_switch:limitWidthByScale(125)
  else
    self.ui.icon_switch:setVisible(true)
    self.ui.btn_refresh_tip:setVisible(true)
    local leftTimes = ed.CupArenaManager:getLeftRefreshTimes()
    local maxTimes = ed.CupArenaManager:getMaxRefreshTimes()
    ed.setString(self.ui.label_switch, T("\229\136\183\230\150\176 %d/%d", leftTimes, maxTimes))
    self.ui.label_switch:limitWidthByScale(80)
  end
  ed.layout.horizontalSortNode({
    self.ui.icon_switch,
    self.ui.label_switch
  }, {10, 0}, self.ui.btn_switch:getContentSize().width * 0.5)
end

function CupArenaChallengeScene:createOpposItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.CupArenaAuditionOppoItem)
  ed.setLabelStroke(ui.label_player_name, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_camp, ed.toccc3(3087902), 1)
  ed.setLabelStroke(ui.label_score_value, ed.toccc3(4466704), 1)
  ed.setLabelStroke(ui.label_power_value, ed.toccc3(4466704), 1)
  ed.setLabelShadow(ui.label_battle, ed.toccc3(2565412), ccp(1, 1))
  ed.setLabelStroke(ui.label_result_win, ed.toccc3(16747300), 1)
  ed.setLabelFontName(ui.label_result_win, ed.fontBold)
  ed.setLabelShadow(ui.label_result_win, ed.toccc3(9715743), ccp(0, 2))
  ed.setLabelStroke(ui.label_result_lose, ed.toccc3(6776798), 1)
  ed.setLabelFontName(ui.label_result_lose, ed.fontBold)
  ed.setLabelShadow(ui.label_result_lose, ed.toccc3(2233656), ccp(0, 2))
  container:setContentSize(CCSizeMake(233, 420))
  ed.setCascadeOpacityEnabled(ui.img_bg, true, true)
  local touchKey = "oppo_battle_" .. index
  self.viewDelegate:btRemoveMainTouchHandler({key = touchKey})
  self.viewDelegate:btRegisterButtonClick({
    button = ui.btn_battle,
    key = touchKey,
    pressScale = 0.95,
    clickHandler = function()
      self:onOppoBattleEvent(index)
    end
  })
  self:refreshOpposItem(ui, index, data)
  return container, ui
end

function CupArenaChallengeScene:refreshOpposScore(ui, index, data)
  ed.setLabelString(ui.label_score_value, data._score)
  local gradeTableInfo = ed.CupArenaManager:getGradeInfoByScore(data._score)
  ed.setTexture(ui.img_grade_name, gradeTableInfo.nameIconRes)
end

function CupArenaChallengeScene:refreshOpposItem(ui, index, data)
  ed.setLabelString(ui.label_score_value, data._score)
  ed.setLabelString(ui.label_power_value, data._gs)
  local campTableItem = ed.getDataTable("CupArenaCamp")[data._camp_id]
  ed.setLabelString(ui.label_camp, T("%s\233\152\181\232\144\165", campTableItem["Camp Name"]))
  ed.setTexture(ui.img_camp_icon, campTableItem["Camp Symbol Min"])
  local gradeTableInfo = ed.CupArenaManager:getGradeInfoByScore(data._score)
  ed.setTexture(ui.img_grade_name, gradeTableInfo.nameIconRes)
  local summary = data._summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    lvoffset = {x = -47, y = -38}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "img_bg", "head", head)
  ui.headIcon = headIcon
  ed.setCascadeOpacityEnabled(head, true, true)
  local touchKey = "oppo_head_" .. index
  self.viewDelegate:btRemoveMainTouchHandler({key = touchKey})
  self.viewDelegate:btRegisterButtonClick({
    button = headIcon,
    key = touchKey,
    pressScale = 0.95,
    clickHandler = function()
      self:onOppoHeadEvent(index)
    end
  })
  local name = ed.getPlayerName(summary._name, summary._medal, {
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0.5, 0.5),
    root = CCSprite:create()
  })
  ed.UITool.replaceUI(ui, "bg_name", "label_player_name", name)
  ed.setCascadeOpacityEnabled(name, true, true)
  ui.btn_battle:setVisible(nil == data._result)
  ui.bg_result_win:setVisible("victory" == data._result)
  ui.bg_result_lose:setVisible("defeat" == data._result)
end

function CupArenaChallengeScene:checkChallengeable(...)
  if ed.CupArenaManager:getChallengeCount() <= 0 then
    self:doBuyChallengeTimes()
    return false
  end
  return true
end

function CupArenaChallengeScene:onOppoBattleEvent(index)
  if not self.isTouchEnable then
    return
  end
  if not self:checkChallengeable() then
    return
  end
  local data = self.oppoDataArr[index]
  if nil == data then
    return
  end
  self.challengeTargetIndex = index
  ed.CupArenaNetwork:sendGetOppoTeams(data._role_id)
end

function CupArenaChallengeScene:onOppoHeadEvent(index)
  if not self.isTouchEnable then
    return
  end
  local data = self.oppoDataArr[index]
  if nil == data then
    return
  end
  ed.CupArenaNetwork:sendViewUser(data._role_id, nil == data._result)
end

function CupArenaChallengeScene:refreshOpposUI(data, isTween)
  self.oppoDataArr = data._oppos or {}
  if nil == self.ui.opposUIArr then
    self.ui.opposUIArr = {}
  end
  local spaceX = 5
  local isAllChallenge = #self.oppoDataArr > 0
  for i, v in ipairs(self.oppoDataArr) do
    if nil == v._result then
      isAllChallenge = false
    end
    local oppoUIItem = self.ui.opposUIArr[i]
    local isNew = false
    if nil == oppoUIItem then
      local container, ui = self:createOpposItem(i, v)
      ui.rootContainer = container
      table.insert(self.ui.opposUIArr, ui)
      self.ui.panel_oppos:addChild(container)
      local containerSize = container:getContentSize()
      container:setPosition(ccp(containerSize.width * (i - 1) + spaceX * (i - 1), 0))
      oppoUIItem = ui
      isNew = true
    elseif not oppoUIItem.rootContainer:isVisible() then
      oppoUIItem.rootContainer:setVisible(true)
      self:refreshOpposItem(oppoUIItem, i, v)
      isNew = true
    end
    if isTween then
      if isNew then
        oppoUIItem.rootContainer:setScaleX(0)
        local sequence = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCScaleTo:create(0.1, 1, 1))
        oppoUIItem.rootContainer:runAction(sequence)
      else
        oppoUIItem.rootContainer:stopAllActions()
        local array = ccArrayMake(CCScaleTo:create(0.1, 0, 1), CCCallFunc:create(function()
          self:refreshOpposItem(oppoUIItem, i, v)
        end), CCScaleTo:create(0.1, 1, 1))
        local sequence = CCSequence:create(array)
        oppoUIItem.rootContainer:runAction(sequence)
      end
    elseif not isNew then
      self:refreshOpposItem(oppoUIItem, i, v)
    end
  end
  for i = #self.oppoDataArr + 1, #self.ui.opposUIArr do
    self.ui.opposUIArr[i].rootContainer:setVisible(false)
  end
  if isAllChallenge then
    self.viewDelegate:listenTimer(Timer:Once(0.2), function()
      ed.CupArenaNetwork:sendRefreshOppo(true)
    end)
  end
end

function CupArenaChallengeScene:onRefreshChallengeOpposEvent()
  if self:isHigherGrade() then
    ed.showToast(T("\230\130\168\229\183\178\232\190\190\233\171\152\233\152\182\229\139\135\232\128\133\239\188\140\228\184\141\229\143\175\229\136\183\230\150\176\230\140\145\230\136\152\229\175\185\230\137\139"))
    return
  end
  if not self.isTouchEnable then
    return
  end
  local leftTimes = ed.CupArenaManager:getLeftRefreshTimes()
  if leftTimes <= 0 then
    ed.showToast(T("\229\136\183\230\150\176\230\172\161\230\149\176\228\184\141\232\182\179"))
    return
  end
  local info = {
    text = T("\231\161\174\232\174\164\229\136\183\230\150\176\229\175\185\230\137\139\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      ed.CupArenaNetwork:sendRefreshOppo()
    end
  }
  ed.showConfirmDialog(info)
end

function CupArenaChallengeScene:onAddChallengeTimesEvent()
  if not self.isTouchEnable then
    return
  end
  local leftTimes = ed.CupArenaManager:getChallengeCount()
  if 0 < leftTimes then
    ed.showToast(T("\232\191\152\230\156\137\230\140\145\230\136\152\230\172\161\230\149\176\230\156\170\228\189\191\231\148\168"))
    return
  end
  self:doBuyChallengeTimes()
end

function CupArenaChallengeScene:refreshRefreshTipInfo()
  local leftTimes = ed.CupArenaManager:getLeftRefreshTimes()
  local maxTimes = ed.CupArenaManager:getMaxRefreshTimes()
  local lastRecoverTime = ed.CupArenaManager:getLastRefreshRecoverTime()
  local gapRecoverTime = ed.CupArenaManager:getPerRefreshRecoverTime()
  local curTime = ed.getServerTime()
  repeat
    if leftTimes < maxTimes then
      local nextRecoverTime = lastRecoverTime + gapRecoverTime
      if curTime > nextRecoverTime then
        leftTimes = leftTimes + 1
        lastRecoverTime = nextRecoverTime
        ed.CupArenaManager:setLeftRefreshTimes(leftTimes)
        ed.CupArenaManager:setLastRefreshRecoverTime(lastRecoverTime)
        self:refreshSwitchTimes()
      else
        break
      end
    else
      break
    end
  until false
  local tipStr = T("\229\189\147\229\137\141\230\151\182\233\151\180: %s", ed.serverTime2HMS())
  if leftTimes == maxTimes then
    tipStr = string.format([[
%s
%s]], tipStr, T("\229\136\183\230\150\176\230\172\161\230\149\176\229\183\178\229\155\158\230\187\161"))
  else
    local nextStr = T("\228\184\139\230\172\161\229\136\183\230\150\176\230\172\161\230\149\176\230\129\162\229\164\141\239\188\154%s", ed.gethmsNString(lastRecoverTime + gapRecoverTime - curTime))
    local recoverStr = T("\230\129\162\229\164\141\229\133\168\233\131\168\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154%s", ed.gethmsNString(lastRecoverTime + gapRecoverTime * math.max(0, maxTimes - leftTimes) - curTime))
    local gapStr = T("\230\129\162\229\164\141\230\151\182\233\151\180\233\151\180\233\154\148\239\188\154%s", ed.getdhmsCString(gapRecoverTime))
    tipStr = string.format([[
%s
%s
%s
%s]], tipStr, nextStr, recoverStr, gapStr)
  end
  ed.setString(self.ui.refreshTipLabel, tipStr)
  local newSize = self.ui.refreshTipLabel:getContentSize()
  newSize.width = newSize.width + 30
  newSize.height = newSize.height + 28
  self.ui.refreshTipBg:setContentSize(newSize)
  self.ui.refreshTipLabel:setPosition(ccp(newSize.width / 2, newSize.height / 2 + 3))
  ed.layout.layoutWithMagin(self.ui.refreshTipBg, {right = 30, top = 60})
end

function CupArenaChallengeScene:onRefreshTipEvent()
  if not self.isTouchEnable then
    return
  end
  if nil == self.ui.refreshTipBg then
    local bg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 20, 160))
    self.ui.bg_times:getParent():addChild(bg, 999)
    bg:setAnchorPoint(ccp(0.5, 0.5))
    local label = ed.createttf("", 16)
    ed.setLabelColor(label, ed.toccc3(16776423))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    bg:addChild(label)
    self.ui.refreshTipBg = bg
    self.ui.refreshTipLabel = label
  end
  self.ui.refreshTipBg:setVisible(true)
  self.viewDelegate:btRegisterOutClick({
    area = self.ui.refreshTipBg,
    key = "out_refresh_tip",
    clickHandler = function()
      if self.ui.refreshTipBg:isVisible() then
        self.viewDelegate:btRemoveMainTouchHandler({
          key = "out_refresh_tip"
        })
        self.ui.refreshTipBg:setVisible(false)
      end
    end,
    priority = -1,
    force = true
  })
  self:refreshRefreshTipInfo()
end

function CupArenaChallengeScene:onMyGradeEvent()
  ed.UITool.openView("CupArenaRankRewardPop", {page = "reward", index = 1})
end

function CupArenaChallengeScene:onMyMedalEvent()
  ed.UITool.openView("CupArenaRankRewardPop", {page = "reward", index = 3})
end

function CupArenaChallengeScene:onTaskEvent()
  ed.CupArenaNetwork:sendOpenTask(true)
end

function CupArenaChallengeScene:registerTouchEvents(...)
  self.viewDelegate:registerBtn(self.ui.btn_switch, function()
    self:onRefreshChallengeOpposEvent()
  end, {pressScale = 0.95})
  self.viewDelegate:registerBtn(self.ui.btn_addtimes, function()
    self:onAddChallengeTimesEvent()
  end, {pressScale = 0.95})
  self.viewDelegate:registerBtn(self.ui.btn_refresh_tip, function()
    self:onRefreshTipEvent()
  end, {pressScale = 0.95})
  self.viewDelegate:registerBtn(self.ui.img_my_grade, function()
    self:onMyGradeEvent()
  end, {normalScale = 0.5, pressScale = 0.475})
  self.viewDelegate:registerBtn(self.ui.img_my_medal, function()
    self:onMyMedalEvent()
  end, {normalScale = 0.8, pressScale = 0.76})
  self.viewDelegate:registerBtn(self.ui.btn_task, function()
    self:onTaskEvent()
  end, {pressScale = 0.95})
end

function CupArenaChallengeScene:registerEvents()
  self.viewDelegate:listenEvent("EventCupArenaOpenChallenge", function(data)
    self.resetTime = ed.getTodayOriginTimeWithServer() + 18000
    if ed.getFitServerTime() >= self.resetTime then
      self.resetTime = self.resetTime + 86400
    end
    self:refreshSwitchTimes()
    self:refreshChallengeTimes()
    self:refreshOpposUI(data, false)
    if self.isOpenPanel then
      self:playSwitchAction()
    end
  end)
  self.viewDelegate:listenEvent("EventCupArenaRefreshOppo", function(data)
    self:refreshSwitchTimes()
    self:refreshOpposUI(data, true)
  end)
  self.viewDelegate:listenEvent("EventCupArenaBuyCount", function()
    self:refreshChallengeTimes()
  end)
  self.viewDelegate:listenEvent("EventCupArenaChallengeOppo", function(roleId)
    for i, v in ipairs(self.oppoDataArr) do
      if v._role_id == roleId then
        self:onOppoBattleEvent(i)
        break
      end
    end
  end)
  self.viewDelegate:listenEvent("EventCupArenaGetOppoTeams", function(data)
    local oppoData = self.oppoDataArr[self.challengeTargetIndex]
    if nil == oppoData or nil == data._teams or 0 == #data._teams then
      ed.showToast("\231\155\174\230\160\135\228\184\141\229\173\152\229\156\168")
      return
    end
    local isKnockout = false
    local scene = ed.ui.CupArenaBattlePrepareScene.create({
      mode = "attack",
      requireNumPerTeam = 1,
      teamCount = isKnockout and ed.CupArenaManager.TeamCount.Knockout or ed.CupArenaManager.TeamCount.Audition,
      oppoTeams = data._teams,
      oppoInfo = oppoData,
      selfTeamIDs = ed.CupArenaManager:getLastTeamArr(isKnockout)
    })
    ed.pushScene(scene)
  end)
  self.viewDelegate:listenEvent("EventBattlePrepareSetAttackTeam", function(data)
    self:doChallengeOppo(data)
  end)
  self.viewDelegate:listenEvent("CupArenaPlayNextBattle", function(challengeData, recordIndex)
    if nil ~= challengeData then
      self.curChallengeData = challengeData
      self.curChallengeIndex = 1
    elseif nil ~= self.curChallengeData then
      if nil ~= recordIndex then
        self.curChallengeIndex = recordIndex
      else
        self.curChallengeIndex = self.curChallengeIndex + 1
      end
    else
      return
    end
    local recordList = self.curChallengeData._battle_replay._records
    if self.curChallengeIndex > #recordList then
      local params = {
        isReplay = false,
        battleReplay = self.curChallengeData._battle_replay,
        medalChange = self.curChallengeData._medal_change,
        medalExtra = self.curChallengeData._self_extra_medal,
        selfOldScore = self.curChallengeData._self_old_score,
        selfNewScore = self.curChallengeData._self_new_score,
        oppoOldScore = self.curChallengeData._oppo_old_score,
        oppoNewScore = self.curChallengeData._oppo_new_score,
        isAudition = true
      }
      self.curChallengeData = nil
      self.curChallengeIndex = nil
      ed.ui.CupArenaChallengeResultWin.create(params)
    else
      ed.CupArenaManager:enterReplay(recordList[self.curChallengeIndex], self.curChallengeIndex, true, true)
    end
  end)
  self.viewDelegate:listenEvent("EventCupArenaChallengeComplete", function(data)
    ed.openMemeryGC = true
    ed.CupArenaManager:checkGradeChangeEffect(function()
      self:initChallengeUI()
      for i, v in ipairs(self.oppoDataArr) do
        if v._role_id == data.targetRoleId then
          v._score = data.targetScore or 0
          local itemUI = self.ui.opposUIArr[i]
          if nil ~= itemUI then
            self:refreshOpposScore(itemUI, i, v)
          end
          self:playChallengeResult(i, data.isWin)
          break
        end
      end
    end)
  end)
  self.viewDelegate:listenEvent("EventCupChallengeFail", function()
    ed.openMemeryGC = true
    self.resetTime = nil
    self.isOpenPanel = false
    ed.CupArenaNetwork:sendOpenChallenge()
  end)
  self.viewDelegate:listenEvent("EventCupArenaTaskEntryRed", function()
    self:refreshTaskRedPoint()
  end)
end

function CupArenaChallengeScene:doChallengeOppo(data)
  local oppoData = self.oppoDataArr[self.challengeTargetIndex]
  if nil == oppoData then
    ed.showToast("\231\155\174\230\160\135\228\184\141\229\173\152\229\156\168")
    return
  end
  ed.ui.CupArenaBattleWin.create({
    selfCamp = ed.CupArenaManager:getCampId(),
    selfSummary = ed.player:getUserSummary(),
    oppoCamp = oppoData._camp_id,
    oppoSummary = oppoData._summary
  })
  ed.CupArenaNetwork:sendChallengeOppo(oppoData._role_id, data.attackTeams)
  ed.loadEnd()
  ed.openMemeryGC = false
end

function CupArenaChallengeScene:openView(...)
  self:initChallengeUI()
  self.resetTime = nil
  self.isOpenPanel = true
  ed.CupArenaNetwork:sendOpenChallenge()
  self.ui.bg_my_info:setVisible(false)
  self.ui.bg_times:setVisible(false)
  self.ui.panel_oppos:setVisible(false)
  self.isTouchEnable = false
end

function CupArenaChallengeScene:playSwitchAction()
  self.ui.bg_my_info:setVisible(true)
  self.ui.bg_times:setVisible(true)
  self.ui.panel_oppos:setVisible(true)
  ed.setCascadeOpacityEnabled(self.ui.bg_my_info, true, true)
  self.ui.bg_my_info:stopAllActions()
  self.ui.bg_my_info:setOpacity(0)
  self.ui.bg_my_info:runAction(CCFadeIn:create(0.25))
  local delayTime = 0.1
  for i, opposUI in ipairs(self.ui.opposUIArr) do
    opposUI.img_bg:stopAllActions()
    opposUI.img_bg:setOpacity(0)
    delayTime = 0.1 + (i - 1) * 0
    opposUI.img_bg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCFadeIn:create(0.25)))
  end
  self.ui.bg_times:setVisible(true)
  ed.setCascadeOpacityEnabled(self.ui.bg_times, true, true)
  self.ui.bg_times:stopAllActions()
  self.ui.bg_times:setOpacity(0)
  self.ui.bg_times:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime + 0.07), CCFadeIn:create(0.25), CCCallFunc:create(function()
    self.isTouchEnable = true
  end))))
end

function CupArenaChallengeScene:doBuyChallengeTimes()
  local buyTimes = ed.CupArenaManager:getChallengeCountBuyCount()
  local cost = ed.CupArenaManager:getChallengeCountBuyCost(buyTimes)
  local maxCount = ed.CupArenaManager:getMaxChallengeCount()
  if buyTimes >= maxCount then
    ed.showToast(T("\232\182\133\229\135\186\232\180\173\228\185\176\230\172\161\230\149\176\228\184\138\233\153\144"))
    return
  end
  if cost <= ed.player._rmb then
    local prompt = T("\230\152\175\229\144\166\230\148\175\228\187\152%d\233\146\187\231\159\179\232\180\173\228\185\176%d\230\172\161\230\140\145\230\136\152\230\172\161\230\149\176,\228\187\138\230\151\165\229\183\178\232\180\173\228\185\176%d\230\172\161", cost, ed.CupArenaManager:getAddChallengeCountByBuy(), buyTimes)
    local info = {
      text = prompt,
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.CupArenaNetwork:sendBuyChallengeCount()
      end
    }
    ed.showConfirmDialog(info)
  else
    ed.showHandyDialog("toRecharge")
  end
end

function CupArenaChallengeScene:updatePerHalfSecond()
  if self.ui.refreshTipBg and self.ui.refreshTipBg:isVisible() then
    self:refreshRefreshTipInfo()
  end
  if self.resetTime and ed.getFitServerTime() > self.resetTime then
    self.resetTime = nil
    self.isOpenPanel = false
    ed.CupArenaNetwork:sendOpenChallenge()
  end
end

function CupArenaChallengeScene:playChallengeResult(index, isWin)
  local oppoUIItem = self.ui.opposUIArr[index]
  if nil == oppoUIItem then
    return
  end
  local showBg = isWin and oppoUIItem.bg_result_win or oppoUIItem.bg_result_lose
  local hiddenBg = isWin and oppoUIItem.bg_result_lose or oppoUIItem.bg_result_win
  hiddenBg:setVisible(false)
  oppoUIItem.btn_battle:setVisible(false)
  showBg:setVisible(true)
  showBg:setScale(2.1)
  showBg:runAction(CCScaleTo:create(0.1, 0.7))
  local isAllChallenge = true
  for i, v in ipairs(self.oppoDataArr) do
    if i == index then
      v._result = isWin and "victory" or "defeat"
    elseif nil == v._result then
      isAllChallenge = false
    end
  end
  if isAllChallenge then
    self.viewDelegate:listenTimer(Timer:Once(0.2), function()
      ed.CupArenaNetwork:sendRefreshOppo(true)
    end)
  end
end

function CupArenaChallengeScene:isHigherGrade()
  local gradeInfo = ed.CupArenaManager:getGradeInfoByGradeId(4)
  if ed.CupArenaManager:getScore() >= gradeInfo.startScore then
    return true
  end
  return false
end

function CupArenaChallengeScene:refreshTaskRedPoint()
  self.ui.img_task_red:setVisible(ed.CupArenaManager:getTaskRedFlag())
end
