local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueMapScene = class
class.room_unchoose_bg = "UI/alpha/1080P/rogue/instance/instance_room_type_unchoose.png"
class.room_type_bg = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png"
class.name_bg_unchoose = "UI/alpha/1080P/rogue/instance/instance_room_name_unchoose.png"
class.name_bg_choose = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png"
ed.UITool.registViewOpenFunc("rogueMapScene", function(param)
  local scene = ed.ui.rogueMapScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueMapScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.isEnterChapter = param.isEnterChapter or false
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.routeId = self.rogueLikeMgr:getCurRouteId()
  self.rogueChapterRouteTB = ed.getDataTable("RogueChapterRoute")
  self.rogueChapterWaveTB = ed.getDataTable("RogueChapterWave")
  self.firstEnterScene = true
  self:initUI()
  self:registerTouchEvent()
  self:registerEventListener()
end

function class:checkRoomHandle()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local curRoomId = curChapter._cur_room_id
  local curSlotId = self.rogueLikeMgr:getSlotIdByRoomId(curRoomId)
  if curSlotId == 0 then
    self.rogueLikeMgr:handleRoom(curRoomId)
  end
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.rogueMapScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.roomList = {}
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local chapterId = curChapter._chapter_id
  local diff = curChapter._difficulty
  local chapterName = ed.getDataTable("RogueChapter")[chapterId][diff].Name
  local titleBg, title = ed.UITool.createSceneTitle(chapterName, self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  if 1 < chapterId then
    local romanDiffNum = ed.rogueLikeTool.createRomanNum(diff, {
      I = "UI/alpha/1080P/rogue/instance/diff_i.png",
      V = "UI/alpha/1080P/rogue/instance/diff_v.png"
    }, {spacing = -7})
    title:addChild(romanDiffNum)
    local titleSize = title:getContentSize()
    romanDiffNum:setPosition(ccp(titleSize.width + romanDiffNum:getContentSize().width / 2, titleSize.height / 2))
  end
  ed.layout.relateLayout(title, self.ui.btn_rule, {
    right = title:getContentSize().width * 0.5 + 20
  })
  local bookTableItem = ed.getDataTable("RogueBook")[chapterId]
  self.ui.btn_charm:setVisible(nil ~= next(bookTableItem["Charm List"] or {}))
  self.ui.image_reborn_bg:setVisible(nil ~= ed.getDataTable("RogueBook")[4])
  self:initLabels()
  self:adaptUI()
  self:initEffect()
  self:createMap()
  self:initChessTag()
  self:refreshMap()
  self:refreshBtn()
  self:refreshProgress()
  self:refreshPearlAmount()
  self:refreshRetryTimesAmount()
  self:refreshRebornAmount()
  self:startCountDown()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
  ed.layout.layoutWithMagin(self.ui.image_pearl_bg, {right = 10, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_retry_bg, {right = 120, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_reborn_bg, {right = 230, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_global, {
    left = 0 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithMagin(self.ui.btn_team, {
    left = 0 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithMagin(self.ui.btn_bag, {
    left = 0 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithMagin(self.ui.btn_charm, {
    left = 0 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithMagin(self.ui.left_time_bg, {
    right = 10 + ed.display.getNotchHeight()
  }, false, true)
  self.ui.label_left_time_tips:limitWidthByScale(95)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_global, ed.toccc3(3745055), 1)
  ed.setLabelStroke(self.ui.label_team, ed.toccc3(3745055), 1)
  ed.setLabelStroke(self.ui.label_bag, ed.toccc3(3745055), 1)
  ed.setLabelStroke(self.ui.label_charm, ed.toccc3(3745055), 1)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(7813139), 1)
  ed.setLabelStroke(self.ui.label_left_time_tips, ed.toccc3(4336414), 1)
end

function class:initEffect()
end

function class:initChessTag()
  local chess = ed.createSprite()
  local chessFca = ed.createFcaNode("eff_UI_rogue_chess")
  chess.chessFca = chessFca
  chessFca:setAction("Loop")
  chess:addChild(chessFca)
  chess:setScale(0.9)
  self:addFca(chessFca)
  self.mainLayer:addChild(chess, 1)
  self.chess = chess
  self:moveChessTag()
end

function class:moveChessTag(showAction, actionEndCB)
  local curRoomId = self.rogueLikeMgr:getCurRoomId()
  local curSlotId = self.rogueLikeMgr:getSlotIdByRoomId(curRoomId)
  local room
  if curSlotId == 0 then
    room = self.birthRoom
  else
    room = self.roomList[curSlotId]
  end
  local x, y = room:getPosition()
  if showAction then
    local delay = CCDelayTime:create(0.16666666666666666)
    local moveAction = CCMoveTo:create(0.4583333333333333, ccp(x, y + 11))
    local callFunc = CCCallFunc:create(function()
      if actionEndCB then
        actionEndCB()
      end
    end)
    self.chess:runAction(CCSequence:create(ccArrayMake(delay, moveAction, callFunc)))
    self.chess.chessFca:setAction("Start")
  else
    self.chess:setPosition(ccp(x, y + 11))
  end
end

function class:createMap()
  self.roomList = {}
  if self.mapContainer then
    self.mapContainer:removeFromParentAndCleanup(true)
  end
  local mapCfg = ed.uieditor["rogueMap_" .. self.routeId]
  local container, ui = ed.editorui(mapCfg)
  container:setContentSize(CCSizeMake(960, 540))
  self.mapContainer = container
  self.mapUi = ui
  local chapterId = self.rogueLikeMgr:getCurChapterId()
  local mapPath = ed.getDataTable("RogueBackground")[chapterId][self.routeId]["Background Pic"]
  ed.setTexture(self.ui.image_map_bg, mapPath)
  self.ui.image_map_bg:addChild(container)
  self.ui.image_map_bg:setCascadeOpacityEnabled(true)
  ed.layout.centerInParent(container)
  self:initBirthRoom()
  for slotId, _ in ipairs(self.rogueChapterRouteTB[self.routeId] or {}) do
    local room = self:initRoomIcon(slotId)
    room:setZOrder(100 - slotId)
    self.roomList[slotId] = room
  end
  self:registerRoomTouchEvent()
end

function class:showMapShowAction()
  for slotId, room in ipairs(self.roomList) do
    room:setScale(0)
    local delayTime = CCDelayTime:create(0.1 * slotId)
    room:runAction(CCSequence:create(ccArrayMake(delayTime, CCEaseBackOut:create(CCScaleTo:create(0.5, 1)))))
    local slotCfg = self.rogueChapterRouteTB[self.routeId][slotId]
    local postSlotList = slotCfg["Post Slot"] or {}
    postSlotList = ed.copyTable(postSlotList)
    table.insert(postSlotList, 99)
    for _, postSlotId in ipairs(postSlotList) do
      local routeName = string.format("route_%.2d_%.2d", slotId, postSlotId)
      local route = self.mapUi[routeName]
      if route then
        local opacity = route:getOpacity()
        route:setOpacity(0)
        route:runAction(CCFadeTo:create(0.5, opacity))
      end
    end
  end
end

function class:initBirthRoom()
  local birthRoom = self.mapUi.room_00
  local finish = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_room_finish.png")
  birthRoom:addChild(finish)
  finish:setVisible(false)
  finish:setPosition(ccp(62, 37))
  birthRoom.finish = finish
  self.birthRoom = birthRoom
end

function class:initRoomIcon(slotId)
  local slotBg = self.mapUi[string.format("room_%.2d", slotId)]
  local iconMask = self.mapUi[string.format("room_%.2d_mask", slotId)]
  local nameBg = self.mapUi[string.format("room_%.2d_name_bg", slotId)]
  local name = self.mapUi[string.format("room_%.2d_name", slotId)]
  local nameMask = self.mapUi[string.format("room_%.2d_name_mask", slotId)]
  local roomId = self.rogueLikeMgr:getRoomIdBySlotId(slotId)
  local roomData = self.rogueLikeMgr:getRoomData(roomId)
  local roomType = roomData.type or "normal_battle"
  local roomIconPathCfg = ed.rogueDefine.room_type_to_icon[roomType]
  slotBg:setCascadeOpacityEnabled(true)
  nameBg:setCascadeOpacityEnabled(true)
  local roomIcon = ed.createSprite(roomIconPathCfg.choose)
  slotBg:addChild(roomIcon)
  ed.layout.centerInParent(roomIcon)
  slotBg.roomIcon = roomIcon
  ed.setLabelString(name, roomIconPathCfg.name)
  ed.setLabelStroke(name, ed.toccc3(9262883), 1)
  local arrow = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_locate_arrow.png")
  slotBg:addChild(arrow, 3)
  arrow:setVisible(false)
  arrow:setPosition(ccp(40, 92))
  arrow:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(0, 5)), CCMoveBy:create(1, ccp(0, -5))))))
  local chosenLight = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_locate_light.png")
  slotBg:addChild(chosenLight, 0)
  chosenLight:setVisible(false)
  chosenLight:setPosition(ccp(40.25, 43))
  local finish = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_room_finish.png")
  slotBg:addChild(finish, 1)
  finish:setVisible(false)
  finish:setPosition(ccp(47, 42))
  nameMask:setVisible(false)
  iconMask:setVisible(false)
  slotBg.roomId = roomId
  slotBg.iconMask = iconMask
  slotBg.nameBg = nameBg
  slotBg.name = name
  slotBg.nameMask = nameMask
  slotBg.arrow = arrow
  slotBg.chosenLight = chosenLight
  slotBg.finish = finish
  return slotBg
end

function class:refreshBirthRoom()
  local birthRoom = self.mapUi.room_00
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local curSlotId = self.rogueLikeMgr:getSlotIdByRoomId(curChapter._cur_room_id)
  if curSlotId == 0 then
    birthRoom.finish:setVisible(false)
  else
    birthRoom.finish:setVisible(true)
  end
end

function class:refreshRoomIcon(slotId)
  local room = self.roomList[slotId]
  local roomId = room.roomId
  local roomData = self.rogueLikeMgr:getRoomData(roomId)
  local roomType = roomData.type or "normal_battle"
  local roomWaveId = roomData.waveId
  local chapterId = self.rogueLikeMgr:getCurChapterId()
  local curRoomId = self.rogueLikeMgr:getCurRoomId()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local diff = curChapter._difficulty
  local isReachable = self:checkSlotReachable(slotId)
  local roomState = self.rogueLikeMgr:getRoomState(roomId)
  local isChoose = self.rogueLikeMgr:getRoomIsChoose(roomId)
  self:refreshRoute(slotId, isReachable)
  if isReachable then
    ed.setTexture(room, self.room_type_bg)
    ed.setTexture(room.nameBg, self.name_bg_choose)
    ed.setTexture(room.roomIcon, ed.rogueDefine.room_type_to_icon[roomType].choose)
  else
    ed.setTexture(room, self.room_unchoose_bg)
    ed.setTexture(room.nameBg, self.name_bg_unchoose)
    ed.setTexture(room.roomIcon, ed.rogueDefine.room_type_to_icon[roomType].unchoose)
  end
  ed.setLabelString(room.name, ed.rogueDefine.room_type_to_icon[roomType].name)
  if roomState == ed.rogueDefine.ROOM_STATE_UNLOCK then
    room.arrow:setVisible(true)
    room.chosenLight:setVisible(true)
  else
    room.arrow:setVisible(false)
    room.chosenLight:setVisible(false)
  end
  if curRoomId == roomId then
    room.iconMask:setVisible(true)
    room.nameMask:setVisible(true)
    room.finish:setVisible(false)
  elseif isChoose then
    room.iconMask:setVisible(true)
    room.nameMask:setVisible(true)
    room.finish:setVisible(true)
  else
    room.iconMask:setVisible(false)
    room.nameMask:setVisible(false)
    room.finish:setVisible(false)
  end
end

function class:refreshRoute(slotId, isReachable)
  local slotCfg = self.rogueChapterRouteTB[self.routeId][slotId]
  local preSlotList = slotCfg["Pre Slot"] or {}
  local postSlotList = slotCfg["Post Slot"] or {}
  for _, preSlotId in ipairs(preSlotList) do
    local routeName = string.format("route_%.2d_%.2d", preSlotId, slotId)
    local route = self.mapUi[routeName]
    if route and not isReachable then
      route:setOpacity(102)
    end
  end
  for _, postSlotId in ipairs(postSlotList) do
    local routeName = string.format("route_%.2d_%.2d", slotId, postSlotId)
    local route = self.mapUi[routeName]
    if route and not isReachable then
      route:setOpacity(102)
    end
  end
  local endRouteName = string.format("route_%.2d_%.2d", slotId, 99)
  local route = self.mapUi[endRouteName]
  if route and not isReachable then
    route:setOpacity(102)
  end
end

function class:refreshMap()
  local rogueChapterRouteCfg = self.rogueChapterRouteTB[self.routeId]
  self:refreshBirthRoom()
  for slotId, slotCfg in ipairs(rogueChapterRouteCfg) do
    self:refreshRoomIcon(slotId, slotCfg)
  end
end

function class:startCountDown()
  self:refreshLeftTime()
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local endTime = curChapter._end_time
  local leftTime = endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local sec = leftTime % 60
  self.ui.label_left_time:setString((string.format(T("%.2d:%.2d:%.2d"), hour, min, sec)))
  if leftTime <= 0 then
    self:refreshView()
    if ed.getCurrentScene().identity == "rogueMapScene" then
      ed.rogueLikeNet.sendExitChapter()
    end
  end
end

function class:checkSlotReachable(slotId)
  local rogueChapterRouteCfg = self.rogueChapterRouteTB[self.routeId]
  local preSlotList = rogueChapterRouteCfg[slotId]["Pre Slot"] or {}
  if #preSlotList == 0 then
    return true
  end
  local isReachable = false
  for _, preSlotId in ipairs(preSlotList) do
    if slotId == preSlotId then
      print(string.format("\233\133\141\232\161\168\233\148\153\232\175\175\239\188\140\232\175\183\230\163\128\230\159\165RogueChapterRoute----slotId = %s", slotId))
      break
    end
    local preRoomIsChoose = self.rogueLikeMgr:getRoomIsChoose(self.rogueLikeMgr:getRoomIdBySlotId(preSlotId))
    local curRoomIsChoose = self.rogueLikeMgr:getRoomIsChoose(self.rogueLikeMgr:getRoomIdBySlotId(slotId))
    if preRoomIsChoose then
      local curChapter = self.rogueLikeMgr:getCurChapter() or {}
      if self.rogueLikeMgr:getRoomIdBySlotId(preSlotId) == curChapter._cur_room_id or curRoomIsChoose then
        isReachable = true
        break
      end
    elseif self:checkSlotReachable(preSlotId) then
      isReachable = true
      break
    end
  end
  return isReachable
end

function class:refreshBtn()
  local curMapIsEnd = self.rogueLikeMgr:getCurMapIsEnd()
  local curChapterIsEnd = self.rogueLikeMgr:getChapterIsEnd()
  if curChapterIsEnd then
    self.birthRoom:setVisible(false)
    self.ui.btn_end:setVisible(true)
    self.ui.btn_go:setVisible(false)
  elseif curMapIsEnd then
    self.birthRoom:setVisible(false)
    self.ui.btn_end:setVisible(false)
    self.ui.btn_go:setVisible(true)
  else
    self.birthRoom:setVisible(true)
    self.ui.btn_end:setVisible(false)
    self.ui.btn_go:setVisible(false)
  end
end

function class:refreshProgress()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local curWave = curChapter._cur_wave or 0
  local waves = curChapter._waves or {}
  local totalWave = waves[#waves]._wave_id or 0
  ed.setLabelString(self.ui.label_tips, string.format("%s/%s", curWave, totalWave))
end

function class:refreshView()
  self:refreshMap()
  self:moveChessTag()
  self:refreshBtn()
  self:refreshProgress()
  self:refreshPearlAmount()
  self:refreshRetryTimesAmount()
  self:refreshRebornAmount()
end

function class:showEnterRoomAction()
  self:moveChessTag(true, function()
    self:refreshView()
  end)
end

function class:refreshPearlAmount()
  local pearl = self.rogueLikeMgr:getPearl()
  ed.setLabelString(self.ui.pearl_amount, pearl)
end

function class:refreshRetryTimesAmount()
  local retryTimes = self.rogueLikeMgr:getRetryTimes()
  ed.setLabelString(self.ui.retry_amount, string.format("%s", retryTimes))
end

function class:refreshRebornAmount()
  local rebornTimes = self.rogueLikeMgr:getRebornTimes()
  ed.setLabelString(self.ui.reborn_amount, rebornTimes)
end

function class:onClickBtnGlobal()
  ed.UITool.openView("rogueGlobalBuffWindow")
end

function class:onClickBtnTeam()
  local rogueTeamWindow = ed.ui.rogueTeamWindow.create({skipAnim = true, noShade = true})
  rogueTeamWindow:popWindow()
  ed.layout.relateLayout(self.ui.btn_team, rogueTeamWindow.ui.image_bg, {
    right = self.ui.btn_team:getContentSize().width / 2 - rogueTeamWindow.ui.image_bg:getContentSize().width
  })
  rogueTeamWindow:showOpenAction()
end

function class:onClickBtnBag()
  ed.UITool.openView("rogueBlessScene")
end

function class:onClickBtnCharm()
  ed.UITool.openView("rogueCharmShowWindow")
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.rogueDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickRoom(roomId)
  local battleState = self.rogueLikeMgr:getBattleStatus()
  if battleState == "finish" then
    ed.showToast(T("\230\130\168\229\183\178\230\136\152\232\180\165\239\188\140\229\143\175\231\130\185\229\135\187\231\187\147\230\157\159\230\184\184\231\142\169"))
    return
  end
  local roomState = self.rogueLikeMgr:getRoomState(roomId)
  if roomState == ed.rogueDefine.ROOM_STATE_UNLOCK then
    local handleResult = self.rogueLikeMgr:handleRoom(roomId)
    if not handleResult then
      ed.UITool.openView("rogueRoomDetailWindow", {roomId = roomId})
    end
  else
    local slotId = self.rogueLikeMgr:getSlotIdByRoomId(roomId)
    local isReachable = self:checkSlotReachable(slotId)
    local isPass = self.rogueLikeMgr:getRoomIsPass(roomId)
    if isPass then
      ed.showToast(T("\230\130\168\229\183\178\233\128\154\232\191\135\232\175\165\230\136\191\233\151\180"))
    elseif not isReachable then
      ed.showToast(T("\229\183\178\230\151\160\230\179\149\230\138\181\232\190\190\230\173\164\229\164\132"))
    else
      ed.showToast(T("\233\156\128\229\133\136\233\128\154\232\191\135\229\137\141\231\189\174\230\136\191\233\151\180"))
    end
  end
  ed.rogueGuide.getInstance():endGuide("rogueMapScene")
end

function class:onClickBtnGo()
  if self.rogueLikeMgr:getCurMapIsEnd() then
    ed.rogueLikeNet.sendEnterNextRound()
  else
    ed.showToast(T("\229\189\147\229\137\141\229\156\176\229\155\190\232\191\152\230\178\161\231\187\147\230\157\159"))
  end
end

function class:onClickBtnEnd()
  ed.rogueLikeNet.sendExitChapter()
end

function class:onClickBtnBack()
  ed.UITool.openView("rogueExitChapterWindow")
end

function class:registerTouchEvent()
  ed.UITool.registerBtn(self, "btn_global", function()
    self:onClickBtnGlobal()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_team", function()
    self:onClickBtnTeam()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_bag", function()
    self:onClickBtnBag()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_charm", function()
    self:onClickBtnCharm()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_go", function()
    self:onClickBtnGo()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_end", function()
    self:onClickBtnEnd()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "image_retry_bg", function()
    ed.ui.packageDetailWin.create({
      type = "rogueretrytime"
    }):popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_pearl_bg", function()
    ed.ui.packageDetailWin.create({type = "pearl"}):popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_reborn_bg", function()
    ed.ui.packageDetailWin.create({
      type = "RogueReborn"
    }):popWindow()
  end, {pressScale = 0.95})
end

function class:registerRoomTouchEvent()
  for slotId, room in pairs(self.roomList) do
    self:btRegisterButtonClick({
      button = room,
      key = "room" .. slotId,
      clickHandler = function()
        self:onClickRoom(room.roomId)
      end,
      pressScale = 0.95,
      force = true
    })
  end
end

function class:registerEventListener()
  self:listenEvent("rogueEnterRoom", function()
    self:showEnterRoomAction()
  end)
  self:listenEvent("rogueEndBattle", function()
    self:refreshView()
  end)
  self:listenEvent("rogueChooseChoice", function()
    self:refreshView()
  end)
  self:listenEvent("rogueChooseReward", function()
    self:refreshView()
  end)
  self:listenEvent("rogueEnterNextRound", function()
    self.routeId = self.rogueLikeMgr:getCurRouteId()
    ed.rogueLikeTool.showTransformEffect()
    self:createMap()
    self:refreshView()
    self:checkRoomHandle()
    self:showMapShowAction()
  end)
  self:listenEvent("rogueUpdatePearlAmount", function()
    self:refreshPearlAmount()
  end)
  self:listenEvent("rogueUpdateRetryTimes", function()
    self:refreshRetryTimesAmount()
  end)
  self:listenEvent("rogueUpdateRebornTimes", function()
    self:refreshRebornAmount()
  end)
  self:listenEvent("rogueExitChapter", function()
    ed.popScene()
  end)
  self:listenEvent("rogueEndChapter", function()
    self:refreshView()
  end)
  self:listenEvent("rogueRefreshRoom", function(roomId)
    for slotId, _ in ipairs(self.rogueChapterRouteTB[self.routeId] or {}) do
      if roomId == self.rogueLikeMgr:getRoomIdBySlotId(slotId) then
        self:refreshRoomIcon(slotId)
        break
      end
    end
  end)
end

function class:onEnterTransitionFinish()
  if self.firstEnterScene then
    self:checkRoomHandle()
    self.firstEnterScene = false
  end
  ed.rogueGuide.getInstance():startGuide("rogueMapScene", self.mapUi.room_01)
end
