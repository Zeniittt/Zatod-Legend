local base = ed.ui.basescene
local CupArenaKnockoutFinalScheduleScene = newclass(base.mt)
ed.ui.CupArenaKnockoutFinalScheduleScene = CupArenaKnockoutFinalScheduleScene
local CenterMatchID = 127

function CupArenaKnockoutFinalScheduleScene.create(data)
  local self = base.create("CupArenaKnockoutFinalScheduleScene")
  setmetatable(self, CupArenaKnockoutFinalScheduleScene.mt)
  self.matchPlayerTab = {}
  self.matchLineTab = {}
  self:initData(data)
  self:initUI()
  self:registerTouchEvent()
  self:registerEvents()
  return self
end

function CupArenaKnockoutFinalScheduleScene:initData(data)
  self.data = data
  self.matchDataTab = {}
  self.newMatchArr = {}
  local matches = data._matches or {}
  local matchTable = ed.getDataTable("CupArenaMatch")
  table.sort(matches, function(a, b)
    return a._match_id < b._match_id
  end)
  local needPlayActionScheduleId
  if 1 < #matches then
    local newScheduleId
    for i = #matches, 1, -1 do
      local matchData = matches[i]
      if matchData._status == "matched" then
        newScheduleId = matchTable[matchData._match_id]["Schedule ID"]
        break
      end
    end
    local lastScheduleId = ed.CupArenaManager:getLastAnimationScheduleID(0)
    if nil ~= newScheduleId and (nil == lastScheduleId or newScheduleId > lastScheduleId) then
      needPlayActionScheduleId = newScheduleId
      ed.CupArenaManager:saveLastAnimationScheduleID(0, newScheduleId)
    end
  end
  for i, v in ipairs(matches) do
    local matchId = v._match_id
    local matchTableItem = matchTable[matchId]
    local scheduleId = matchTableItem["Schedule ID"]
    if scheduleId == needPlayActionScheduleId then
      if v._status == "matched" then
        table.insert(self.newMatchArr, ed.copyProto(v))
        v._status = "matching"
        v._winner = 0
      end
      self.matchDataTab[matchTableItem["Match Location"]] = v
    elseif nil == needPlayActionScheduleId or needPlayActionScheduleId > scheduleId then
      self.matchDataTab[matchTableItem["Match Location"]] = v
    end
  end
end

function CupArenaKnockoutFinalScheduleScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.CupArenaKnockoutFinalScheduleScene, {
    container = self.mainLayer
  })
  self.container = container
  self.ui = ui
  self:adaptUI()
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:setBackground("UI/alpha/1080P/cuparena/knockout/course/course_bg_1.png")
  local titleBg, titleTxt = ed.UITool.createSceneTitle(T("\229\165\179\231\165\158\228\185\139\230\136\152"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  local posX = titleTxt:getPositionX() + titleBg:getContentSize().width * 0.5 + 20
  local ruleWidth = self.ui.btn_rule:getContentSize().width
  self.ui.btn_rule:setPositionX(posX + ruleWidth * 0.5)
  posX = posX + ruleWidth + 10
  local zoomLabel = ed.ui.gradientLabel.create({
    text = T("\232\181\155\229\140\186\239\188\154\231\172\172%s\232\181\155\229\140\186", ed.CupArenaManager:getZoneId()),
    fontSize = 15,
    fontName = ed.font,
    startColor = ed.toccc3(16773995),
    endColor = ed.toccc3(16776911),
    strokeSize = 1,
    strokeColor = ed.toccc3(8803621)
  }).node
  self.ui.bg_title:addChild(zoomLabel)
  zoomLabel:setAnchorPoint(ccp(0, 0.5))
  zoomLabel:setPosition(ccp(posX, 18))
  posX = posX + zoomLabel:getContentSize().width + 25
  self.ui.bg_title:setContentSize(CCSizeMake(posX, 35.5))
  ed.setLabelStroke(self.ui.label_honor, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_rank, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_record, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_grades, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_timeline, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_summary, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(8075022), 1)
  local championLabel = ed.ui.gradientLabel.create({
    text = T("\230\156\172\230\156\159\229\134\160\229\134\155"),
    fontSize = 16,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16773257),
    endColor = ed.toccc3(16776400),
    strokeSize = 1,
    strokeColor = ed.toccc3(9124608)
  })
  self.ui.bg_champion_des:addChild(championLabel.node)
  ed.layout.centerInParent(championLabel.node)
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\229\134\179\230\136\152\232\141\163\232\128\128\233\152\182\230\174\181"),
    fontSize = 23,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16774314),
    endColor = ed.toccc3(16776683),
    shadowOffset = ccp(0, -0.5),
    shadowColor = ed.toccc3(0)
  })
  self.ui.bg_head:addChild(titleLabel.node)
  ed.layout.centerInParent(titleLabel.node)
  titleLabel.node:setPositionY(titleLabel.node:getPositionY() + 5)
  local progressText = ed.ui.autoText.new()
  self.ui.bg_progress_des:addChild(progressText.node)
  self.progressDesLabel = progressText
  local groupTable = ed.getDataTable("CupArenaGroup")
  for i = 1, 8 do
    local desLabel = self.ui["label_group_" .. i]
    local groupTableItem = groupTable[i]
    if desLabel and groupTableItem then
      ed.setLabelString(desLabel, groupTableItem["Group Name"])
    end
  end
  self:startTimer()
  self:refreshRecordRedPoint()
  self:refreshRewardRedPoint()
  self:initMatchSchedule()
  self:refreshTaskRedPoint()
end

function CupArenaKnockoutFinalScheduleScene:adaptUI()
  local localDesignScale = 2.1666666666666665
  local localFixedWidth = ed.display.designSize.height * localDesignScale - ed.display.designSize.width
  local adaptRatio = math.min(ed.display.halfFixedWidth * 2 / localFixedWidth, 1)
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 50, top = 18})
  ed.layout.layoutWithMagin(self.ui.panel_left, {
    left = adaptRatio * 39
  })
  ed.layout.layoutWithMagin(self.ui.btn_summary, {right = 6})
  local bgSize = self.bg:getContentSize()
  local worldPos = self.bg:convertToWorldSpace(ccp(bgSize.width * 0.5, bgSize.height * 0.88))
  local localPos = self.ui.bg_head:getParent():convertToNodeSpace(worldPos)
  if localPos.y < self.ui.bg_progress_des:getPositionY() + self.ui.bg_progress_des:getContentSize().height * 0.5 + self.ui.bg_head:getContentSize().height + 5 then
    ed.layout.layoutWithMagin(self.ui.bg_head, {top = -6}, false, true)
  else
    localPos.y = math.min(localPos.y, self.ui.bg_head:getParent():getContentSize().height)
    self.ui.bg_head:setPosition(localPos)
  end
  local leftPanelRightPosX = self.ui.panel_left:getContentSize().width + self.ui.panel_left:getPositionX()
  local safeWidth = self.ui.btn_summary:getPositionX() - self.ui.btn_summary:getContentSize().width * 0.5 - leftPanelRightPosX
  local matchSize = self.ui.panel_schedule:getContentSize()
  local contentWidth = matchSize.width
  local infoScale = math.min(safeWidth / contentWidth, 1)
  if infoScale < 1 then
    self.ui.panel_schedule:setScale(infoScale)
  end
  local startX = leftPanelRightPosX + (safeWidth - contentWidth * infoScale) * 0.5 - 5 * infoScale
  self.ui.panel_schedule:setPositionX(startX)
end

function CupArenaKnockoutFinalScheduleScene:onEnter(...)
  base.onEnter(self)
  if self.isWaitCloseScene then
    self:closeCurrentScene()
    return
  end
  if ed.CupArenaManager:getIsFirstOpenKnockout() then
    ed.CupArenaManager:setIsFirstOpenKnockout(false)
    ed.ui.CupArenaEffectPlayWin.create({
      type = "qualify",
      data = {isQualify = false}
    })
  end
end

function CupArenaKnockoutFinalScheduleScene:initMatchSchedule()
  self:initMatchInfo(self.data)
  self:refreshMatchLines()
  self:dealPromoteAnimation()
  self.endTime = ed.CupArenaManager:getEndTime()
  self:updateCountDownUI(true)
end

function CupArenaKnockoutFinalScheduleScene:refreshMatchLines()
  for _, arr in pairs(self.matchLineTab) do
    for _, line in ipairs(arr) do
      line:removeFromParentAndCleanup(true)
    end
  end
  self.matchLineTab = {}
  self.oldPlayerTab = {}
  for k, v in pairs(self.matchPlayerTab) do
    v:stopAllActions()
    self.oldPlayerTab[k] = v
  end
  self.matchPlayerTab = {}
  self:refreshMatchGroup(CenterMatchID, 1)
end

function CupArenaKnockoutFinalScheduleScene:initMatchInfo(data)
  local scheduleTableItem = ed.getDataTable("CupArenaSchedule")[data._schedule_id]
  local des = string.gsub(scheduleTableItem["Schedule Describe"] or "", "<lable yellow>", "<lable color=ccc3(255,236,104) strokeColor=0x7B370E strokeSize=1>")
  local progressBgSize = self.ui.bg_progress_des:getContentSize()
  self.progressDesLabel:initParam({
    context = des,
    fontSize = 19,
    color = ed.toccc3(16775899),
    strokeColor = ed.toccc3(3546719),
    lineSpacing = 1
  })
  local desWidth, desHeight = self.progressDesLabel:getCurContentSize()
  self.progressDesLabel.node:setPosition(ccp((progressBgSize.width - desWidth) * 0.5, progressBgSize.height - self.progressDesLabel:getFirstLineHeight() * 0.5 - 5))
end

function CupArenaKnockoutFinalScheduleScene:registerTouchEvent()
  for i = 1, 8 do
    ed.UITool.registerBtn(self, "btn_group_" .. i, function()
      self:onGroupEvent(i)
    end, {pressScale = 0.95})
  end
  ed.UITool.registerBtn(self, "btn_summary", function()
    self:onSummaryEvent()
  end, {normalScale = 0.9, pressScale = 0.855})
  ed.UITool.registerBtn(self, "btn_gamble", function()
    self:onGambleEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onRuleEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_honor", function()
    self:onHonorEvent()
  end, {normalScale = 0.9, pressScale = 0.81})
  ed.UITool.registerBtn(self, "btn_rank", function()
    self:onRankEvent()
  end, {normalScale = 0.9, pressScale = 0.81})
  ed.UITool.registerBtn(self, "btn_reward", function()
    self:onRewardEvent()
  end, {normalScale = 0.9, pressScale = 0.81})
  ed.UITool.registerBtn(self, "btn_record", function()
    self:onRecordEvent()
  end, {normalScale = 0.9, pressScale = 0.81})
  ed.UITool.registerBtn(self, "btn_grades", function()
    self:onHistoryEvent()
  end, {normalScale = 0.9, pressScale = 0.81})
  ed.UITool.registerBtn(self, "btn_timeline", function()
    self:onTimelineEvent()
  end, {normalScale = 0.9, pressScale = 0.81})
end

function CupArenaKnockoutFinalScheduleScene:onGroupEvent(groupId)
  ed.CupArenaNetwork:sendMatchGroupSchedule(groupId, true)
end

function CupArenaKnockoutFinalScheduleScene:registerEvents()
  self:listenEvent("EventCupArenaRefreshSchedule", function(data)
    self:initData(data)
    self:initMatchSchedule(data)
  end)
  self:listenEvent("EventCupArenaOver", function()
    self:closeCurrentScene()
  end)
  self:listenEvent("EventCupArenaGambleEntryRed", function()
    self:refreshTaskRedPoint()
  end)
  self:listenEvent("EventCupArenaMedalRewardRed", function()
    self:refreshRewardRedPoint()
  end)
  self:listenEvent("EventCupArenaChalleneRecordRed", function()
    self:refreshRecordRedPoint()
  end)
end

function CupArenaKnockoutFinalScheduleScene:refreshMatchGroup(matchId, stageLevel, parentId, posType)
  local matchTable = ed.getDataTable("CupArenaMatch")[matchId]
  if 0 ~= matchTable["Group ID"] then
    return
  end
  local pos = matchTable["Match Location"]
  local preMatchId1 = matchTable["PreMatch ID 1"]
  local preMatchId2 = matchTable["PreMatch ID 2"]
  if preMatchId1 and 0 < preMatchId1 then
    self:refreshMatchGroup(preMatchId1, stageLevel + 1, matchId, "host")
  end
  if preMatchId2 and 0 < preMatchId2 then
    self:refreshMatchGroup(preMatchId2, stageLevel + 1, matchId, "guest")
  end
  local matchData = self.matchDataTab[pos]
  local isWinnerHost = nil ~= matchData and nil ~= matchData._winner and 1 == matchData._winner
  local isWinnerGuest = nil ~= matchData and nil ~= matchData._winner and 2 == matchData._winner
  local hostKey = string.format("panel_player_host_%d", pos)
  local hostIcon = self.matchPlayerTab[hostKey]
  if nil == hostIcon then
    hostIcon = self.oldPlayerTab[hostKey]
    self.oldPlayerTab[hostKey] = nil
    if nil == hostIcon then
      hostIcon = ed.ui.CupArenaMatchHeadIcon.create(stageLevel, ed.ui.CupArenaMatchHeadIcon.calcuHeadDir(self.ui[hostKey], self.ui.panel_player_final), true)
      hostIcon:setParent(self.ui[hostKey])
      hostIcon:registerClickFunc(self, hostKey, function(...)
        self:onOppoHeadEvent(...)
      end)
    end
    self.matchPlayerTab[hostKey] = hostIcon
    hostIcon:updateHeadData(nil ~= matchData and matchData._host or nil)
  end
  local guestKey = string.format("panel_player_guest_%d", pos)
  local guestIcon = self.matchPlayerTab[guestKey]
  if nil == guestIcon then
    guestIcon = self.oldPlayerTab[guestKey]
    self.oldPlayerTab[guestKey] = nil
    if nil == guestIcon then
      guestIcon = ed.ui.CupArenaMatchHeadIcon.create(stageLevel, ed.ui.CupArenaMatchHeadIcon.calcuHeadDir(self.ui[guestKey], self.ui.panel_player_final), true)
      guestIcon:setParent(self.ui[guestKey])
      guestIcon:registerClickFunc(self, guestKey, function(...)
        self:onOppoHeadEvent(...)
      end)
    end
    self.matchPlayerTab[guestKey] = guestIcon
    guestIcon:updateHeadData(nil ~= matchData and matchData._guest or nil)
  end
  if isWinnerHost or isWinnerGuest then
    hostIcon:setWinner(isWinnerHost)
    guestIcon:setWinner(isWinnerGuest)
  else
    hostIcon:setWinner(true)
    guestIcon:setWinner(true)
  end
  local parentUIKey
  if parentId and 0 < parentId then
    local parentTable = ed.getDataTable("CupArenaMatch")[parentId]
    parentUIKey = string.format("panel_player_%s_%d", posType, parentTable["Match Location"])
  else
    parentUIKey = "panel_player_final"
  end
  local parentIcon = self.matchPlayerTab[parentUIKey]
  if nil == parentIcon then
    parentIcon = self.oldPlayerTab[parentUIKey]
    self.oldPlayerTab[parentUIKey] = nil
    if nil == parentIcon then
      parentIcon = ed.ui.CupArenaMatchHeadIcon.create(stageLevel - 1, ed.ui.CupArenaMatchHeadIcon.calcuHeadDir(self.ui[parentUIKey], self.ui.panel_player_final), true)
      parentIcon:setParent(self.ui[parentUIKey])
      parentIcon:registerClickFunc(self, parentUIKey, function(...)
        self:onOppoHeadEvent(...)
      end)
    end
    self.matchPlayerTab[parentUIKey] = parentIcon
    if isWinnerHost then
      parentIcon:updateHeadData(matchData._host)
    elseif isWinnerGuest then
      parentIcon:updateHeadData(matchData._guest)
    else
      parentIcon:updateHeadData(nil)
    end
    parentIcon:setWinner(true)
    parentIcon:updateMatchData(matchData)
  end
  self:refreshMatchLine(hostKey, parentUIKey, isWinnerHost)
  self:refreshMatchLine(guestKey, parentUIKey, isWinnerGuest)
end

function CupArenaKnockoutFinalScheduleScene:refreshMatchLine(startKey, targetKey, isWin)
  local startPanel = self.ui[startKey]
  local targetPanel = self.ui[targetKey]
  if nil == startPanel or nil == targetPanel then
    return
  end
  local lineUIArr = self.matchLineTab[startKey]
  if nil == lineUIArr then
    lineUIArr = {}
    self.matchLineTab[startKey] = lineUIArr
    local startSize = startPanel:getContentSize()
    local startPos = ccp(startPanel:getPositionX() + startSize.width * 0.5, startPanel:getPositionY() + startSize.height * 0.5)
    local targetSize = targetPanel:getContentSize()
    local targetPos = ccp(targetPanel:getPositionX() + targetSize.width * 0.5, targetPanel:getPositionY() + targetSize.height * 0.5)
    if 0.5 > math.abs(startPos.y - targetPos.y) then
      ed.CupArenaUITool.createXLine(startPos.x, 0, targetPos.x, startPos.y, isWin, self.ui.panel_schedule, lineUIArr)
    elseif 0.5 > math.abs(startPos.x - targetPos.x) then
      ed.CupArenaUITool.createYLine(startPos.y, 0, targetPos.y, startPos.x, isWin, self.ui.panel_schedule, lineUIArr)
    else
      local turnSprite = ed.createSprite(isWin and "UI/alpha/1080P/cuparena/knockout/course/course_line_2.png" or "UI/alpha/1080P/cuparena/knockout/course/course_line_4.png")
      self.ui.panel_schedule:addChild(turnSprite, isWin and -1 or -2)
      table.insert(lineUIArr, turnSprite)
      local turnPos = ccp(targetPos.x, startPos.y)
      turnSprite:setPosition(turnPos)
      turnSprite:setRotation(ed.CupArenaUITool.calcuRotation(targetPos, startPos))
      local turnSize = turnSprite:getContentSize()
      ed.CupArenaUITool.createXLine(turnPos.x, turnSize.width, startPos.x, turnPos.y, isWin, self.ui.panel_schedule, lineUIArr)
      ed.CupArenaUITool.createYLine(turnPos.y, turnSize.width, targetPos.y, turnPos.x, isWin, self.ui.panel_schedule, lineUIArr)
    end
  end
end

function CupArenaKnockoutFinalScheduleScene:startTimer(...)
  self:listenTimer(Timer:Always(0.5), function()
    self:updateCountDownUI(false)
  end)
end

function CupArenaKnockoutFinalScheduleScene:updateCountDownUI(isInit)
  if nil ~= self.endTime and self.endTime > 0 then
    local diffTime = self.endTime - ed.getServerTime()
    if nil ~= self.ui.label_time then
      self.ui.label_time:setString(ed.gethmsNString(math.max(diffTime, 0)))
    end
    if diffTime <= 0 then
      self.endTime = nil
      CloseTimer("final_schedule_refresh_panel")
      local scheduleTable = ed.getDataTable("CupArenaSchedule")[self.data._schedule_id]
      if scheduleTable["State Type"] == "ShowTime" then
        self:closeCurrentScene()
      else
        self:listenTimer(Timer:Once(isInit and 5 or 1, "final_schedule_refresh_panel"), function()
          ed.CupArenaNetwork:sendOpenPanel(false)
        end)
      end
    end
  end
end

function CupArenaKnockoutFinalScheduleScene:onGambleEvent()
  ed.CupArenaNetwork:sendOpenGamble()
end

function CupArenaKnockoutFinalScheduleScene:onHonorEvent(...)
  local season = ed.CupArenaManager:getCurrentSeason() or 1
  local scheduleTable = ed.getDataTable("CupArenaSchedule")[ed.CupArenaManager:getScheduleId()]
  if scheduleTable["State Type"] ~= "ShowTime" then
    season = math.max(season - 1, 1)
  end
  ed.CupArenaNetwork:sendTopRankboard(season, 0)
end

function CupArenaKnockoutFinalScheduleScene:onRankEvent(...)
  ed.UITool.openView("CupArenaRankRewardPop", {page = "rank"})
end

function CupArenaKnockoutFinalScheduleScene:onRewardEvent(...)
  ed.UITool.openView("CupArenaRankRewardPop", {page = "reward"})
end

function CupArenaKnockoutFinalScheduleScene:onRecordEvent(...)
  ed.CupArenaNetwork:sendGetBattleRecord(self.identity == "CupArenaKnockoutChallengeScene", true)
end

function CupArenaKnockoutFinalScheduleScene:onHistoryEvent(...)
  ed.CupArenaNetwork:sendHistory()
end

function CupArenaKnockoutFinalScheduleScene:onTimelineEvent()
  ed.CupArenaNetwork:sendTimeline()
end

function CupArenaKnockoutFinalScheduleScene:onSummaryEvent()
  ed.CupArenaNetwork:sendOpenAuditionSummary()
end

function CupArenaKnockoutFinalScheduleScene:onOppoHeadEvent(headIcon, x, y)
  if nil ~= self.ui.operateMenu and self.ui.operateMenu:containsPoint(x, y) then
    return
  end
  local operateData = headIcon:getOperateData()
  if nil == operateData then
    return
  end
  if nil == self.ui.operateMenu then
    local posX, posY = self.ui.panel_schedule:getPosition()
    local contentSize = self.ui.panel_schedule:getContentSize()
    self.ui.operateMenu = ed.ui.CupArenaOperateMenu.create(self.mainLayer, CCRectMake(posX, posY, contentSize.width, contentSize.height))
    self.ui.operateMenu:registerEvents(self)
    self.ui.operateMenu:registerTouchEvent(self)
  end
  self.ui.operateMenu:show(headIcon:getHeadPos(), headIcon:getHeadSize(), operateData)
  if nil == operateData.matchId then
    self.ui.operateMenu:onDetailEvent()
    self.ui.operateMenu:hide()
  end
end

function CupArenaKnockoutFinalScheduleScene:dealPromoteAnimation()
  self:checkNextPromoteAnimation()
  self:checkChampionFca()
end

function CupArenaKnockoutFinalScheduleScene:isNodeReady(matchId)
  if nil == matchId or 0 == matchId then
    return true
  end
  local matchTable = ed.getDataTable("CupArenaMatch")
  local matchTableItem = matchTable[matchId]
  if 0 ~= matchTableItem["Group ID"] then
    return true
  end
  local pos = matchTableItem["Match Location"]
  if nil ~= self.matchDataTab[pos] and "matched" == self.matchDataTab[pos]._status then
    return true
  end
  return false
end

function CupArenaKnockoutFinalScheduleScene:checkNextPromoteAnimation()
  local matchTable = ed.getDataTable("CupArenaMatch")
  for i = #self.newMatchArr, 1, -1 do
    local matchData = self.newMatchArr[i]
    local matchTableItem = matchTable[matchData._match_id]
    matchTableItem._winner = 1
    if self:isNodeReady(matchTableItem["PreMatch ID 1"]) and self:isNodeReady(matchTableItem["PreMatch ID 2"]) then
      self:playPromoteAnimation(matchData)
      table.remove(self.newMatchArr, i)
    end
  end
end

function CupArenaKnockoutFinalScheduleScene:findParentKey(matchId)
  local matchTable = ed.getDataTable("CupArenaMatch")
  local matchTableItem = matchTable[matchId]
  local matchPos = matchTableItem["Match Location"]
  local matchGroup = matchTableItem["Group ID"]
  local recursiveFunc
  
  function recursiveFunc(childId, parentId, posType)
    local childTableItem = matchTable[childId]
    if childTableItem["Match Location"] == matchPos then
      if nil == parentId then
        return "panel_player_final"
      else
        local parentTableItem = matchTable[parentId]
        return string.format("panel_player_%s_%d", posType, parentTableItem["Match Location"])
      end
    end
    local preMatchId1 = childTableItem["PreMatch ID 1"]
    if preMatchId1 and 0 < preMatchId1 then
      local result = recursiveFunc(preMatchId1, childId, "host")
      if nil ~= result then
        return result
      end
    end
    local preMatchId2 = childTableItem["PreMatch ID 2"]
    if preMatchId2 and 0 < preMatchId2 then
      local result = recursiveFunc(preMatchId2, childId, "guest")
      if nil ~= result then
        return result
      end
    end
    return nil
  end
  
  return recursiveFunc(CenterMatchID)
end

function CupArenaKnockoutFinalScheduleScene:playPromoteAnimation(matchData)
  local matchTableItem = ed.getDataTable("CupArenaMatch")[matchData._match_id]
  local hostKey = string.format("panel_player_host_%d", matchTableItem["Match Location"])
  local guestKey = string.format("panel_player_guest_%d", matchTableItem["Match Location"])
  local parentKey = self:findParentKey(matchData._match_id)
  local parentIcon = self.matchPlayerTab[parentKey]
  if nil == parentIcon then
    print(matchData._match_id, "can not find parent: ", parentKey)
    return
  end
  local isWinnerHost = 1 == matchData._winner
  local isWinnerGuest = 2 == matchData._winner
  local hostIcon = self.matchPlayerTab[hostKey]
  local guestIcon = self.matchPlayerTab[guestKey]
  if nil ~= hostIcon and nil ~= guestIcon then
    hostIcon:setWinner(isWinnerHost)
    guestIcon:setWinner(isWinnerGuest)
  end
  local winnerData = isWinnerHost and matchData._host or matchData._guest
  local winnerKey = isWinnerHost and hostKey or guestKey
  local lastLineUIArr = self.matchLineTab[winnerKey]
  self.matchLineTab[winnerKey] = nil
  for i, v in ipairs(lastLineUIArr) do
    v:stopAllActions()
    v:runAction(CCEaseIn:create(CCFadeTo:create(1, 0), 2))
  end
  self:refreshMatchLine(winnerKey, parentKey, true)
  local newLineUIArr = self.matchLineTab[winnerKey]
  for i, v in ipairs(newLineUIArr) do
    v:stopAllActions()
    v:setOpacity(0)
    v:runAction(CCEaseIn:create(CCFadeTo:create(1, 255), 2))
  end
  parentIcon:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.8), CCCallFunc:create(function()
    xpcall(function()
      parentIcon:updateHeadData(winnerData)
      parentIcon:updateMatchData(matchData)
      local headPos = parentIcon:getHeadPos()
      headPos = self.ui.panel_schedule:convertToNodeSpace(headPos)
      local lightFca = ed.createFcaNode("eff_UI_Main_Cuparena_charts_appear")
      self:addFcaOnce(lightFca)
      lightFca:setPosition(headPos)
      lightFca:setScale(parentIcon:getHeadScale() / 0.9 * 0.85)
      self.ui.panel_schedule:addChild(lightFca, 999)
    end, EDDebug)
  end), CCDelayTime:create(0.1), CCCallFunc:create(function()
    xpcall(function()
      self.matchDataTab[matchTableItem["Match Location"]] = matchData
      self:checkNextPromoteAnimation()
      self:checkChampionFca()
    end, EDDebug)
  end))))
end

function CupArenaKnockoutFinalScheduleScene:checkChampionFca()
  local matchTable = ed.getDataTable("CupArenaMatch")[CenterMatchID]
  local matchData = self.matchDataTab[matchTable["Match Location"]]
  if nil == matchData or matchData._status ~= "matched" then
    if nil ~= self.championBgFca then
      self.championBgFca:setVisible(false)
      self.championLightFca:setVisible(false)
    end
  elseif nil == self.championBgFca then
    local finalPanelSize = self.ui.panel_player_final:getContentSize()
    self.championBgFca = ed.createFcaNode("eff_UI_Main_Cuparena_champion1")
    self:addFca(self.championBgFca)
    self.ui.panel_player_final:addChild(self.championBgFca, -1)
    self.championBgFca:setPosition(finalPanelSize.width * 0.5, finalPanelSize.height * 0.5)
    self.championLightFca = ed.createFcaNode("eff_UI_Main_Cuparena_champion")
    self:addFca(self.championLightFca)
    self.ui.panel_player_final:addChild(self.championLightFca, 999)
    self.championLightFca:setPosition(finalPanelSize.width * 0.5, finalPanelSize.height * 0.5)
  else
    self.championBgFca:setVisible(true)
    self.championLightFca:setVisible(true)
  end
end

function CupArenaKnockoutFinalScheduleScene:closeCurrentScene()
  if ed.getCurrentScene().identity == "CupArenaKnockoutFinalScheduleScene" then
    ed.popScene()
    ListenTimer(Timer:Once(0.1), function(...)
      ed.showToast(T("\229\165\179\231\165\158\228\185\139\230\136\152\229\183\178\231\187\147\230\157\159"))
    end)
  else
    self.isWaitCloseScene = true
  end
end

function CupArenaKnockoutFinalScheduleScene:refreshTaskRedPoint()
  self.ui.img_gamble_red:setVisible(ed.CupArenaManager:getGambleRedFlag())
end

function CupArenaKnockoutFinalScheduleScene:refreshRecordRedPoint()
  self.ui.img_record_red:setVisible(ed.CupArenaManager:getChallengeRecordRedFlag())
end

function CupArenaKnockoutFinalScheduleScene:refreshRewardRedPoint()
  self.ui.img_reward_red:setVisible(ed.CupArenaManager:getMedalRewardRedFlag())
end

function CupArenaKnockoutFinalScheduleScene:onRuleEvent()
  local ruleTxt = {
    T("\233\135\145\232\139\185\230\158\156\228\187\142\229\164\169\232\128\140\233\153\141\239\188\140\232\175\184\228\189\141\229\165\179\231\165\158\228\184\186\228\186\137\229\164\186\229\174\131\231\186\183\228\186\137\228\184\141\228\188\145\239\188\140\229\165\179\231\165\158\228\185\139\230\136\152\229\188\128\229\144\175\229\144\142\239\188\140\231\142\169\229\174\182\229\143\175\231\130\185\229\135\187\228\184\187\231\149\140\233\157\162\229\187\186\231\173\145\239\188\140\230\181\139\232\175\149\232\135\170\229\183\177\231\154\132\229\145\189\232\191\144\229\165\179\231\165\158\239\188\140\229\138\160\229\133\165\229\133\182\233\152\181\232\144\165\228\184\186\229\133\182\228\189\156\230\136\152\227\128\130\229\165\179\231\165\158\228\185\139\230\136\152\229\188\128\229\167\139\229\144\142\239\188\140\229\176\134\230\160\185\230\141\174\228\186\186\230\149\176\229\136\146\229\136\134\232\181\155\229\140\186\227\128\130\229\165\179\231\165\158\228\185\139\230\136\152\233\135\135\231\148\168\231\137\185\230\174\138\231\154\132\232\181\155\229\173\163\229\136\182\229\186\166\239\188\140\230\175\143\228\184\170\232\181\155\229\173\163\229\176\134\229\140\133\229\144\171\233\128\137\230\139\148\229\139\135\229\163\171\231\154\132\230\181\183\233\128\137\232\181\155\229\146\140\229\139\135\229\163\171\229\175\185\229\134\179\231\154\132\229\183\133\229\179\176\232\181\155\228\184\164\228\184\170\233\152\182\230\174\181\227\128\130<br/>") .. T("<lable color=summonYellow>\230\181\183\233\128\137\232\181\155\232\167\132\229\136\153</lable><br/><br/>") .. T("\230\181\183\233\128\137\232\181\155\229\188\128\229\167\139\229\144\142\239\188\140\233\152\159\233\149\191\229\143\175\231\130\185\229\135\187\230\180\187\229\138\168\229\133\165\229\143\163\239\188\140\230\181\139\232\175\149\232\135\170\229\183\177\231\154\132\229\145\189\232\191\144\229\165\179\231\165\158\239\188\140\229\185\182\229\138\160\229\133\165\229\133\182\233\152\181\232\144\165\228\184\186\229\133\182\228\189\156\230\136\152\227\128\130<br/><br/>") .. T("<lable color=summonYellow>\230\140\145\230\136\152</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\230\181\183\233\128\137\232\181\155\231\154\132\230\136\152\230\150\151\228\184\173\239\188\140\230\137\128\230\156\137\232\139\177\233\155\132\231\154\132\232\161\128\233\135\143\229\146\140\230\138\164\231\155\190\233\135\143\229\143\151\229\136\176\231\155\184\229\144\140\229\185\133\229\186\166\231\154\132\228\184\138\232\176\131\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\230\156\159\233\151\180\239\188\140\233\152\159\233\149\191\229\174\140\230\136\144\233\152\181\232\144\165\233\155\134\231\187\147\229\144\142\239\188\140\229\143\175\229\143\130\228\184\142\230\181\183\233\128\137\229\175\185\230\136\152\239\188\140<lable color=summonYellow>\230\181\183\233\128\137\229\175\185\230\136\152\228\184\173\233\156\128\232\166\129\228\189\191\231\148\1685\230\148\175\233\152\159\228\188\141\232\191\155\232\161\140\230\140\145\230\136\152\239\188\140\229\141\149\230\172\161\230\140\145\230\136\152\228\184\173\233\135\135\231\148\1685\229\177\1283\232\131\156\231\154\132\232\167\132\229\136\153\227\128\130</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\230\156\159\233\151\180\239\188\140\233\152\159\233\149\191\229\143\175\229\133\168\229\164\169\228\189\156\230\136\152\239\188\140\230\175\143\229\164\169\230\139\165\230\156\137<lable color=summonYellow>10\230\172\161\229\133\141\232\180\185\230\140\145\230\136\152\230\156\186\228\188\154</lable>\239\188\136UTC+8  05:00\229\136\183\230\150\176\239\188\137\239\188\140\229\144\142\231\187\173\229\143\175\228\189\191\231\148\168\233\146\187\231\159\179\233\162\157\229\164\150\232\180\173\228\185\176\230\172\161\230\149\176\227\128\130<br/>"),
    T("<lable color=summonYellow>\230\140\145\230\136\152</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\230\156\159\233\151\180\239\188\140\233\152\159\233\149\191<lable color=summonRed>\228\184\141\228\188\154\229\140\185\233\133\141\229\136\176\230\156\172\233\152\181\232\144\165\231\154\132\229\175\185\230\137\139</lable>\239\188\140\228\185\159\228\184\141\228\188\154\232\191\158\231\187\173\229\140\185\233\133\141\229\136\176\229\144\140\228\184\128\229\175\185\230\137\139\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\230\140\145\230\136\152\232\191\135\231\168\139\228\184\173\239\188\140\233\152\159\233\149\191\230\156\137\230\166\130\231\142\135\233\129\135\229\136\176\229\165\179\231\165\158\229\174\136\229\141\171\239\188\140\229\135\187\230\186\131\228\187\150\228\187\172\239\188\129<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\230\175\143\230\172\161\229\176\134\228\188\154\228\184\186\233\152\159\233\149\191\229\140\185\233\133\1413\229\144\141\229\175\185\230\137\139\239\188\140\229\174\140\230\136\144\230\137\128\230\156\137\230\140\145\230\136\152\229\144\142\232\135\170\229\138\168\229\136\183\230\150\176\239\188\140\233\152\159\233\149\191\228\185\159\229\143\175\228\187\165\230\137\139\229\138\168\229\136\183\230\150\176\229\175\185\230\137\139\239\188\140<lable color=summonYellow>\229\136\183\230\150\176\230\172\161\230\149\176\230\175\14330\229\136\134\233\146\159\229\155\158\229\164\1411\230\172\161\239\188\140\230\156\128\229\164\154\229\143\175\229\130\168\229\173\15210\230\172\161</lable>\227\128\130<lable color=summonRed>\232\190\190\229\136\176\233\171\152\233\152\182\229\139\135\232\128\133\230\174\181\228\189\141\229\144\142\239\188\140\233\152\159\233\149\191\229\176\134\230\151\160\230\179\149\229\136\183\230\150\176\229\175\185\230\137\139</lable>\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\152\159\233\149\191\229\143\175\233\128\154\232\191\135\230\151\182\233\151\180\232\161\168\230\159\165\231\156\139\230\175\148\232\181\155\232\191\155\231\168\139\227\128\130<br/>"),
    T("<lable color=summonYellow>\230\174\181\228\189\141\227\128\129\231\167\175\229\136\134\228\184\142\229\139\139\231\171\160</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\228\184\186\231\167\175\229\136\134\229\136\182\239\188\140\229\185\182\229\176\134\230\160\185\230\141\174\231\167\175\229\136\134\232\140\131\229\155\180\229\136\146\229\136\134\228\184\186<lable color=summonYellow>\232\167\129\228\185\160\229\139\135\232\128\133\239\188\140\229\136\157\233\152\182\229\139\135\232\128\133\239\188\140\228\184\173\233\152\182\229\139\135\232\128\133\239\188\140\233\171\152\233\152\182\229\139\135\232\128\133\239\188\140\229\143\178\232\175\151\229\139\135\232\128\133\239\188\140\228\188\160\229\165\135\229\139\135\232\128\133\229\143\138\231\165\158\228\189\145\229\139\135\232\128\133</lable>7\228\184\170\230\174\181\228\189\141\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\191\155\230\148\187\230\136\144\229\138\159\229\190\151\229\136\134\239\188\140\232\191\155\230\148\187\229\164\177\232\180\165\230\137\163\229\136\134\239\188\155\233\152\178\229\174\136\230\136\144\229\138\159\229\190\151\229\136\134\239\188\140\233\152\178\229\174\136\229\164\177\232\180\165\230\137\163\229\136\134\227\128\130\231\137\185\229\136\171\231\154\132\239\188\140\229\189\147\233\152\159\233\149\191<lable color=summonYellow>\229\164\132\228\186\142\232\167\129\228\185\160\229\139\135\232\128\133\229\146\140\229\136\157\233\152\182\229\139\135\232\128\133\228\184\164\228\184\170\230\174\181\228\189\141</lable>\230\151\182\239\188\140\232\191\155\230\148\187\229\146\140\233\152\178\229\174\136\231\154\132\229\164\177\232\180\165\233\131\189\229\176\134\229\143\151\229\136\176\228\191\157\230\138\164\239\188\140<lable color=summonYellow>\228\184\141\228\188\154\230\137\163\233\153\164\229\136\134\230\149\176</lable>\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\232\191\155\230\148\187\228\184\173\232\142\183\232\131\156\239\188\140\229\143\175\232\142\183\229\190\15110\229\139\139\231\171\160\239\188\155\229\156\168\232\191\155\230\148\187\228\184\173\229\164\177\232\180\165\239\188\140\229\143\175\232\142\183\229\190\1515\229\139\139\231\171\160\227\128\130<lable color=summonYellow>\230\175\143\229\164\169\229\137\14110\230\172\161\230\140\145\230\136\152\232\142\183\229\190\151\231\154\132\229\139\139\231\171\160\230\149\176\233\135\143\231\191\187\229\128\141\227\128\130</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\152\159\233\149\191\229\143\175\233\128\154\232\191\135<lable color=summonYellow>\229\174\140\230\136\144\233\152\181\232\144\165\228\187\187\229\138\161\232\142\183\229\143\150\233\162\157\229\164\150\229\139\139\231\171\160</lable>\239\188\140\233\152\181\232\144\165\228\187\187\229\138\161\229\176\134\229\156\168\230\175\143\230\151\16505:00\239\188\136UTC+8\239\188\137\229\136\183\230\150\176\227\128\130<br/>") .. T("<lable color=summonYellow>\229\165\150\229\138\177</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\229\176\134\230\160\185\230\141\174\231\142\169\229\174\182\229\156\168\230\181\183\233\128\137\232\181\155\228\184\173\232\190\190\229\136\176\231\154\132<lable color=summonYellow>\229\142\134\229\143\178\230\156\128\233\171\152\230\174\181\228\189\141</lable>\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\228\184\170\233\152\181\232\144\165\229\133\168\228\189\147\233\152\159\233\149\191\232\142\183\229\190\151\231\154\132\229\139\139\231\171\160\229\176\134\232\191\155\232\161\140<lable color=summonYellow>\229\138\160\230\128\187\229\144\142\230\142\146\229\144\141</lable>\239\188\140\230\181\183\233\128\137\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\233\152\181\232\144\165\230\156\128\231\187\136\230\142\146\229\144\141\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\152\159\233\149\191\233\156\128\229\156\168\230\181\183\233\128\137\232\181\155\228\184\173\228\184\186\230\156\172\233\152\181\232\144\165<lable color=summonYellow>\232\180\161\231\140\174\232\135\179\229\176\1451000\229\139\139\231\171\160</lable>\239\188\140\230\137\141\229\143\175\228\187\165\232\142\183\229\190\151\233\152\181\232\144\165\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\230\156\128\231\187\136<lable color=summonYellow>\231\167\175\229\136\134\230\142\146\229\144\141\229\156\168\230\156\172\233\152\181\232\144\165\229\137\14116\229\144\141\231\154\132\231\142\169\229\174\182\229\176\134\232\142\183\229\190\151\229\135\186\231\186\191\232\181\132\230\160\188</lable>\239\188\140\228\187\163\232\161\168\230\156\172\233\152\181\232\144\165\229\135\186\229\190\129\239\188\140\229\134\179\230\136\152\229\183\133\229\179\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\228\184\164\228\189\141\231\142\169\229\174\182\231\167\175\229\136\134\231\155\184\229\144\140\239\188\140\229\136\153\233\129\181\229\190\170\229\133\136\230\157\165\229\144\142\229\136\176\230\172\161\229\186\143\232\191\155\232\161\140\230\142\146\229\144\141\227\128\130<br/>"),
    T("<lable color=summonYellow>\229\183\133\229\179\176\232\181\155\232\167\132\229\136\153</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\233\128\137\232\181\155\231\187\147\230\157\159\230\151\182\239\188\140<lable color=summonYellow>\230\156\128\231\187\136\230\142\146\229\144\141\229\156\168\233\152\181\232\144\165\229\137\14116\229\144\141</lable>\231\154\132\233\152\159\233\149\191\229\176\134\229\135\186\231\186\191\232\191\155\229\133\165\229\183\133\229\179\176\232\181\155\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\183\133\229\179\176\232\181\155\228\184\186<lable color=summonYellow>\229\141\149\232\180\165\230\183\152\230\177\176\229\136\182</lable>\239\188\140\229\135\186\231\186\191\233\128\137\230\137\139\233\156\128\228\184\128\232\183\175\232\191\135\229\133\179\230\150\169\229\176\134\239\188\140\231\187\143\229\142\134128\232\191\15564\239\188\14064\232\191\15532\231\173\137\229\164\154\232\189\174\230\183\152\230\177\176\239\188\140\230\156\128\231\187\136\229\134\179\229\135\186\229\134\160\229\134\155\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\232\189\174\229\175\185\230\136\152\229\176\134\229\136\134\228\184\186<lable color=summonYellow>\229\184\131\233\152\181\227\128\129\231\171\158\231\140\156\227\128\129\229\175\185\229\134\179\227\128\129\230\180\190\229\165\150</lable>4\228\184\170\233\152\182\230\174\181\239\188\140\233\152\159\233\149\191\229\143\175\229\156\168\230\151\182\233\151\180\232\161\168\228\184\173\230\159\165\231\156\139\230\175\148\232\181\155\232\191\155\231\168\139\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\229\184\131\233\152\181\233\152\182\230\174\181\239\188\140\233\128\137\230\137\139\233\156\128\232\166\129\232\174\190\231\189\174\232\135\170\229\183\177\231\154\132<lable color=summonYellow>7\230\148\175</lable>\230\175\148\232\181\155\233\152\159\228\188\141\239\188\140\229\175\185\230\136\152\230\151\182\233\135\135\231\148\1687\229\177\1284\232\131\156\229\136\182\239\188\140<lable color=summonRed>\230\175\143\230\148\175\230\175\148\232\181\155\233\152\159\228\188\141\229\191\133\233\161\187\228\184\138\230\187\1615\228\186\186</lable>\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\229\184\131\233\152\181\233\152\182\230\174\181\239\188\140\230\137\128\230\156\137\233\128\137\230\137\139\231\154\132\233\152\159\228\188\141\233\152\181\229\174\185\229\176\134<lable color=summonRed>\229\175\185\229\133\168\228\189\147\233\152\159\233\149\191\228\184\141\229\143\175\232\167\129</lable>\227\128\130<br/>"),
    T("<lable color=summonYellow>\229\183\133\229\179\176\232\181\155\232\167\132\229\136\153</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\128\137\230\137\139\229\174\140\230\136\144\229\184\131\233\152\181\229\144\142\239\188\140\229\176\134\232\191\155\229\133\165\231\171\158\231\140\156\233\152\182\230\174\181\239\188\140\230\173\164\230\151\182\230\137\128\230\156\137\229\143\130\228\184\142\232\191\135\230\181\183\233\128\137\232\181\155\231\154\132\233\152\159\233\149\191\239\188\136\229\140\133\230\139\172\233\128\137\230\137\139\230\156\172\228\186\186\239\188\137\229\143\175\229\143\130\228\184\142\231\171\158\231\140\156\239\188\140\230\138\149\229\133\165\233\135\145\229\184\129\230\148\175\230\140\129\232\135\170\229\183\177\229\150\156\230\172\162\231\154\132\233\128\137\230\137\139\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\231\171\158\231\140\156\233\152\182\230\174\181\239\188\140\230\137\128\230\156\137\233\128\137\230\137\139\231\154\132\233\152\159\228\188\141\233\152\181\229\174\185\229\176\134<lable color=summonYellow>\229\175\185\229\133\168\228\189\147\233\152\159\233\149\191\229\143\175\232\167\129</lable>\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\171\158\231\140\156\231\187\147\230\157\159\229\144\142\239\188\140\229\176\134\232\191\155\232\161\140\229\175\185\230\136\152\239\188\140\230\136\144\229\138\159\230\153\139\231\186\167\231\154\132\233\152\159\233\149\191\232\191\155\229\133\165\228\184\139\228\184\128\232\189\174\230\183\152\230\177\176\232\181\155\239\188\140\229\164\177\232\180\165\232\128\133\229\176\177\230\173\164\230\173\162\230\173\165\239\188\140\229\143\175\229\143\130\228\184\142\229\144\142\231\187\173\231\154\132\231\171\158\231\140\156\231\142\169\230\179\149\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\171\158\231\140\156\231\187\147\230\157\159\229\144\142\239\188\140\229\176\134\230\160\185\230\141\174\233\152\159\233\149\191\231\154\132\231\171\158\231\140\156\231\187\147\230\158\156\229\143\145\230\148\190\231\171\158\231\140\156\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\183\133\229\179\176\232\181\155\229\134\179\229\135\186\229\134\160\229\134\155\229\144\142\239\188\140\229\176\134\230\160\185\230\141\174\233\128\137\230\137\139\231\154\132\230\156\128\231\187\136\229\144\141\230\172\161\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\228\184\186\233\128\137\230\137\139\229\143\145\230\148\190\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonYellow>\229\134\160\229\134\155\230\137\128\229\156\168\233\152\181\232\144\165</lable>\230\137\128\230\156\137<lable color=summonRed>\232\180\161\231\140\174\229\139\139\231\171\160\232\190\1901000</lable>\231\154\132\233\152\159\233\149\191\239\188\140\229\143\175\232\142\183\229\190\151\233\162\157\229\164\150\229\133\177\232\141\163\229\165\150\229\138\177\239\188\140\229\165\150\229\138\177\229\176\134\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190\227\128\130<br/>")
  }
  ed.ui.commonRulePop.create({
    title = T("\229\165\179\231\165\158\228\185\139\230\136\152"),
    txt = ruleTxt
  }):popWindow()
end
