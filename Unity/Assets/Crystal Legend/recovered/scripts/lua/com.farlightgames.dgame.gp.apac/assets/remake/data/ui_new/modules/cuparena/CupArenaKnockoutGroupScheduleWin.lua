local base = ed.ui.popwindow
local CupArenaKnockoutGroupScheduleWin = newclass(base.mt)
ed.ui.CupArenaKnockoutGroupScheduleWin = CupArenaKnockoutGroupScheduleWin
local CenterMatchID = 15

function CupArenaKnockoutGroupScheduleWin.create(data)
  local self = base.create("CupArenaKnockoutGroupScheduleWin")
  setmetatable(self, CupArenaKnockoutGroupScheduleWin.mt)
  self.matchLineTab = {}
  self.matchPlayerTab = {}
  self:initData(data)
  self:initUI()
  self:registerTouchEvent()
  self:registerListenEvent()
  self:popWindow()
  return self
end

function CupArenaKnockoutGroupScheduleWin:initData(data)
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
    local lastScheduleId = ed.CupArenaManager:getLastAnimationScheduleID(data._group_id)
    if nil ~= newScheduleId and (nil == lastScheduleId or newScheduleId > lastScheduleId) then
      needPlayActionScheduleId = newScheduleId
      ed.CupArenaManager:saveLastAnimationScheduleID(data._group_id, newScheduleId)
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

function CupArenaKnockoutGroupScheduleWin:initUI()
  ed.editorui(ed.uieditor.CupArenaKnockoutGroupScheduleWin, {
    container = self.container,
    ui = self.ui
  })
  local progressText = ed.ui.autoText.new()
  self.ui.bg_group_des:addChild(progressText.node)
  self.progressDesLabel = progressText
  self.ui.btn_left:setOpacity(0)
  ed.readaction.playBlinkAction({
    node = self.ui.btn_left,
    duration = 1
  })
  self.ui.btn_right:setOpacity(0)
  ed.readaction.playBlinkAction({
    node = self.ui.btn_right,
    duration = 1
  })
  self:startTimer()
  self:refreshGroupUI()
end

function CupArenaKnockoutGroupScheduleWin:refreshGroupUI()
  self:initMatchInfo(self.data)
  self:refreshMatchLines()
  self:dealPromoteAnimation()
  self:refreshArrowBtns()
  self.endTime = ed.CupArenaManager:getEndTime()
  self:updateCountDownUI(true)
end

function CupArenaKnockoutGroupScheduleWin:refreshMatchLines()
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

function CupArenaKnockoutGroupScheduleWin:refreshMatchGroup(matchId, stageLevel, parentId, posType)
  local matchTable = ed.getDataTable("CupArenaMatch")[matchId]
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
      hostIcon = ed.ui.CupArenaMatchHeadIcon.create(stageLevel, ed.ui.CupArenaMatchHeadIcon.calcuHeadDir(self.ui[hostKey], self.ui.panel_player_final), false)
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
      guestIcon = ed.ui.CupArenaMatchHeadIcon.create(stageLevel, ed.ui.CupArenaMatchHeadIcon.calcuHeadDir(self.ui[guestKey], self.ui.panel_player_final), false)
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
      parentIcon = ed.ui.CupArenaMatchHeadIcon.create(stageLevel - 1, ed.ui.CupArenaMatchHeadIcon.calcuHeadDir(self.ui[parentUIKey], self.ui.panel_player_final), false)
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
  if pos == 1013 or pos == 1014 then
    self:refreshMatchLineBy2(hostKey, isWinnerHost, guestKey, isWinnerGuest, parentUIKey)
  else
    self:refreshMatchLine(hostKey, parentUIKey, isWinnerHost)
    self:refreshMatchLine(guestKey, parentUIKey, isWinnerGuest)
  end
end

function CupArenaKnockoutGroupScheduleWin:refreshMatchLineBy2(startKey1, isWin1, startKey2, isWin2, targetKey)
  local startPanel1 = self.ui[startKey1]
  local startPanel2 = self.ui[startKey2]
  local targetPanel = self.ui[targetKey]
  if nil == startPanel1 or nil == startPanel2 or nil == targetPanel then
    return
  end
  local lineKey = startKey1 .. startKey2
  local lineUIArr = self.matchLineTab[lineKey]
  if nil == lineUIArr then
    local lineUIArr = {}
    self.matchLineTab[lineKey] = lineUIArr
    local startSize1 = startPanel1:getContentSize()
    local startPos1 = ccp(startPanel1:getPositionX() + startSize1.width * 0.5, startPanel1:getPositionY() + startSize1.height * 0.5)
    local startSize2 = startPanel2:getContentSize()
    local startPos2 = ccp(startPanel2:getPositionX() + startSize2.width * 0.5, startPanel2:getPositionY() + startSize2.height * 0.5)
    local targetSize = targetPanel:getContentSize()
    local targetPos = ccp(targetPanel:getPositionX() + targetSize.width * 0.5, targetPanel:getPositionY() + targetSize.height * 0.5)
    if 0.5 > math.abs(startPos1.x - startPos2.x) then
      local turnPos = ccp(startPos1.x, targetPos.y)
      local turnSize
      local isAnyWin = isWin1 or isWin2
      if not isAnyWin then
        local turnSprite = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_line_6.png")
        self.ui.panel_schedule:addChild(turnSprite, -2)
        turnSprite:setPosition(turnPos)
        table.insert(lineUIArr, turnSprite)
        turnSize = turnSprite:getContentSize()
        if startPos1.x < targetPos.x then
          turnSprite:setRotation(180)
        else
          turnSprite:setRotation(0)
        end
      else
        local winPos, failPos
        if isWin1 then
          winPos = startPos1
          failPos = startPos2
        elseif isWin2 then
          winPos = startPos2
          failPos = startPos1
        end
        local turnSprite = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_line_5.png")
        self.ui.panel_schedule:addChild(turnSprite, -1)
        turnSprite:setPosition(turnPos)
        table.insert(lineUIArr, turnSprite)
        turnSprite:setRotation(ed.CupArenaUITool.calcuRotation(winPos, targetPos))
        turnSize = turnSprite:getContentSize()
        ed.CupArenaUITool.createYLine(turnPos.y, turnSize.height, winPos.y, turnPos.x, true, self.ui.panel_schedule, lineUIArr)
        ed.CupArenaUITool.createYLine(turnPos.y, 0, failPos.y, turnPos.x, false, self.ui.panel_schedule, lineUIArr)
      end
      ed.CupArenaUITool.createXLine(turnPos.x, turnSize.width, targetPos.x, turnPos.y, isAnyWin, self.ui.panel_schedule, lineUIArr)
    elseif 0.5 > math.abs(startPos1.y - startPos2.y) then
      local turnPos = ccp(targetPos.x, startPos1.y)
    end
  end
end

function CupArenaKnockoutGroupScheduleWin:refreshMatchLine(startKey, targetKey, isWin)
  local startPanel = self.ui[startKey]
  local targetPanel = self.ui[targetKey]
  if nil == startPanel or nil == targetPanel then
    return
  end
  local lineUIArr = self.matchLineTab[startKey]
  if nil == lineUIArr then
    local lineUIArr = {}
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
      local turnPos = ccp(startPos.x, targetPos.y)
      local concatDirX, concatDirY
      local turnSprite = ed.createSprite(isWin and "UI/alpha/1080P/cuparena/knockout/course/course_line_2.png" or "UI/alpha/1080P/cuparena/knockout/course/course_line_4.png")
      self.ui.panel_schedule:addChild(turnSprite, isWin and -1 or -2)
      table.insert(lineUIArr, turnSprite)
      turnSprite:setPosition(turnPos)
      turnSprite:setRotation(ed.CupArenaUITool.calcuRotation(startPos, targetPos))
      local turnSize = turnSprite:getContentSize()
      ed.CupArenaUITool.createXLine(turnPos.x, turnSize.width, targetPos.x, turnPos.y, isWin, self.ui.panel_schedule, lineUIArr)
      ed.CupArenaUITool.createYLine(turnPos.y, turnSize.width, startPos.y, turnPos.x, isWin, self.ui.panel_schedule, lineUIArr)
    end
  end
end

function CupArenaKnockoutGroupScheduleWin:initMatchInfo(data)
  local groupTableItem = ed.getDataTable("CupArenaGroup")[data._group_id]
  if nil == self.scheduleLabel then
    self.scheduleLabel = ed.ui.gradientLabel.create({
      text = T("%s\232\181\155\231\168\139", groupTableItem["Group Name"]),
      fontSize = 20,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16774314),
      endColor = ed.toccc3(16776683),
      shadowOffset = ccp(0, -0.5),
      shadowColor = ed.toccc3(0)
    })
    self.ui.bg:addChild(self.scheduleLabel.node)
    local bgSize = self.ui.bg:getContentSize()
    self.scheduleLabel.node:setPosition(ccp(bgSize.width * 0.5, bgSize.height - 50))
  else
    self.scheduleLabel:setString(T("%s\232\181\155\231\168\139", groupTableItem["Group Name"]))
  end
  local scheduleTableItem = ed.getDataTable("CupArenaSchedule")[data._schedule_id]
  local des = string.gsub(scheduleTableItem["Schedule Describe"] or "", "<lable yellow>", "<lable color=ccc3(255,236,104) strokeColor=0x7B370E strokeSize=1>")
  local progressBgSize = self.ui.bg_group_des:getContentSize()
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

function CupArenaKnockoutGroupScheduleWin:registerTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_left", function()
    self:onLeftEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_right", function()
    self:onRightEvent()
  end, {pressScale = 0.95})
end

function CupArenaKnockoutGroupScheduleWin:registerListenEvent()
  self:listenEvent("EventCupArenaRefreshGroupSchedule", function(data)
    self:initData(data)
    self:refreshGroupUI()
  end)
end

function CupArenaKnockoutGroupScheduleWin:refreshArrowBtns(...)
  self.ui.btn_right:setVisible(self.data._group_id < 8)
  self.ui.btn_left:setVisible(self.data._group_id > 1)
end

function CupArenaKnockoutGroupScheduleWin:onLeftEvent(...)
  if self.data._group_id <= 1 then
    return
  end
  ed.CupArenaNetwork:sendMatchGroupSchedule(self.data._group_id - 1, false)
end

function CupArenaKnockoutGroupScheduleWin:onRightEvent(...)
  if self.data._group_id >= 8 then
    return
  end
  ed.CupArenaNetwork:sendMatchGroupSchedule(self.data._group_id + 1, false)
end

function CupArenaKnockoutGroupScheduleWin:startTimer(...)
  self:listenTimer(Timer:Always(0.5), function()
    self:updateCountDownUI(false)
  end)
end

function CupArenaKnockoutGroupScheduleWin:updateCountDownUI(isInit)
  if nil ~= self.endTime and self.endTime > 0 then
    local diffTime = self.endTime - ed.getServerTime()
    if nil ~= self.ui.label_time then
      self.ui.label_time:setString(ed.gethmsNString(math.max(diffTime, 0)))
    end
    if diffTime <= 0 then
      self.endTime = nil
      CloseTimer("group_schedule_refresh_panel")
      self:listenTimer(Timer:Once(isInit and 5 or 1, "group_schedule_refresh_panel"), function()
        ed.CupArenaNetwork:sendMatchGroupSchedule(self.data._group_id, false)
      end)
    end
  end
end

function CupArenaKnockoutGroupScheduleWin:onOppoHeadEvent(headIcon, x, y)
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
    self.ui.operateMenu = ed.ui.CupArenaOperateMenu.create(self.container, CCRectMake(posX, posY, contentSize.width, contentSize.height))
    self.ui.operateMenu:registerEvents(self)
    self.ui.operateMenu:registerTouchEvent(self)
  end
  self.ui.operateMenu:show(headIcon:getHeadPos(), headIcon:getHeadSize(), operateData)
  if nil == operateData.matchId then
    self.ui.operateMenu:onDetailEvent()
    self.ui.operateMenu:hide()
  end
end

function CupArenaKnockoutGroupScheduleWin:dealPromoteAnimation()
  self:checkNextPromoteAnimation()
  self:checkChampionFca()
end

function CupArenaKnockoutGroupScheduleWin:isNodeReady(matchId)
  if nil == matchId or 0 == matchId then
    return true
  end
  local matchTable = ed.getDataTable("CupArenaMatch")
  local pos = matchTable[matchId]["Match Location"]
  if nil ~= self.matchDataTab[pos] and "matched" == self.matchDataTab[pos]._status then
    return true
  end
  return false
end

function CupArenaKnockoutGroupScheduleWin:checkNextPromoteAnimation()
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

function CupArenaKnockoutGroupScheduleWin:findParentKey(matchId)
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

function CupArenaKnockoutGroupScheduleWin:playPromoteAnimation(matchData)
  local matchTableItem = ed.getDataTable("CupArenaMatch")[matchData._match_id]
  local pos = matchTableItem["Match Location"]
  local hostKey = string.format("panel_player_host_%d", pos)
  local guestKey = string.format("panel_player_guest_%d", pos)
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
  if pos == 1013 or pos == 1014 then
    local lineKey = hostKey .. guestKey
    local lastLineUIArr = self.matchLineTab[lineKey] or {}
    self.matchLineTab[lineKey] = nil
    for i, v in ipairs(lastLineUIArr) do
      v:stopAllActions()
      v:runAction(CCEaseIn:create(CCFadeTo:create(1, 0), 2))
    end
    self:refreshMatchLineBy2(hostKey, isWinnerHost, guestKey, isWinnerGuest, parentKey)
    local newLineUIArr = self.matchLineTab[lineKey]
    for i, v in ipairs(newLineUIArr) do
      v:stopAllActions()
      v:setOpacity(0)
      v:runAction(CCEaseIn:create(CCFadeTo:create(1, 255), 2))
    end
  else
    local lastLineUIArr = self.matchLineTab[winnerKey] or {}
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

function CupArenaKnockoutGroupScheduleWin:checkChampionFca()
  local matchTable = ed.getDataTable("CupArenaMatch")[CenterMatchID]
  local matchData = self.matchDataTab[matchTable["Match Location"]]
  if nil == matchData or matchData._status ~= "matched" then
    if nil ~= self.championBgFca then
      self.championBgFca:setVisible(false)
    end
  elseif nil == self.championBgFca then
    local finalPanelSize = self.ui.panel_player_final:getContentSize()
    self.championBgFca = ed.createFcaNode("eff_UI_Main_Cuparena_champion1")
    self:addFca(self.championBgFca)
    self.ui.panel_player_final:addChild(self.championBgFca, -1)
    self.championBgFca:setPosition(finalPanelSize.width * 0.5, finalPanelSize.height * 0.5)
    self.championBgFca:setScale(0.8)
  else
    self.championBgFca:setVisible(true)
  end
end
