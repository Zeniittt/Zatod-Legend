local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.guildClashCourseWin = class
ed.UITool.registViewOpenFunc("guildClashCourseWin", function()
  ed.GuildClashNetwork:sendQueryHistory()
  ListenEventOnce("GuildClashHistory", function(data)
    class.create(data):popWindow()
  end)
end)

function class.create(data)
  local self = base.create("guildClashCourseWin")
  setmetatable(self, class.mt)
  self:init(data)
  return self
end

function class:init(data)
  self.data = data or {}
  self.battleHistory = self.data._battle_history or {}
  table.sort(self.battleHistory, ed.cmpSort({
    {key = "_round_id"}
  }))
  self.mgr = ed.GuildClashManager
  self.roundId = self.mgr:getRoundId()
  self.currentScheduleId = self.mgr:getScheduleId() or 1
  if self.roundId == 0 then
    self.roundId = self:getMaxRound()
  end
  self.oppoGuildSummary = self.mgr.oppoGuildSummary or {}
  self.uiList = {}
  self:initView()
  self:refreshView()
  self:addEventListener()
  self:addTouchEvent()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseWin)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(1878193), 1)
  self:initDragList()
  self:initTime()
  self:initParticle()
end

function class:initTime()
  local serverTime = ed.getFitServerTime()
  local y, mon, d, h, min, s = ed.time2YMDHMS(serverTime)
  self.ui.image_time_hour:setRotation(h * 30 + min / 60 * 30)
  self.ui.image_time_minute:setRotation(min * 6)
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    doScroll = function()
      self:refreshPastStageNodePos()
    end
  })
end

function class:initParticle()
  local particle = CCParticleSystemQuad:create("UI/particle/xingxing.plist")
  self.ui.image_tree:getParent():addChild(particle, 3)
  particle:setPosition(ccp(400, 470))
end

function class:getPressInHandler()
  local function handler(x, y)
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, uiCfg)
  end
  
  return handler
end

function class:refreshView()
  self:refreshTitle()
  self:refreshDragList()
end

function class:refreshTitle()
  local season = self.mgr:getSeasonId()
  ed.setString(self.ui.label_title, T("\231\172\172%s\232\181\155\229\173\163", ed.numberToChinese(season)) .. ed.getUTCLabel())
end

function class:refreshDragList()
  self.dragList:clearList()
  self.uiList = {}
  local posY = 45
  local centerTarget
  local bgSize = self.ui.panel_list:getContentSize()
  for index, historyData in ipairs(self.battleHistory) do
    if historyData._round_id < self.roundId then
      local container, ui = self:createLeftItem(historyData)
      table.insert(self.uiList, {ui = ui, container = container})
      self.dragList:addItem(container)
      local itemSize = container:getContentSize()
      container:setPosition(ccp(0, bgSize.height - posY - itemSize.height / 2))
      posY = posY + itemSize.height
    end
  end
  for roundId, roundCfg in ipairs(ed.getDataTable("GuildClashCourseShow") or {}) do
    if roundId == self.roundId then
      for groupId, groupCfg in ipairs(roundCfg) do
        local container, ui, showCfg, isCurrent
        for subId, courseShowCfg in ipairs(groupCfg) do
          if courseShowCfg["Schedule ID"] == self.currentScheduleId then
            showCfg = courseShowCfg
            break
          end
        end
        showCfg = showCfg or groupCfg[1]
        container, ui, isCurrent = self:createRightItem(groupId, showCfg)
        table.insert(self.uiList, {
          ui = ui,
          showCfg = showCfg,
          container = container
        })
        self.dragList:addItem(container)
        local itemSize = container:getContentSize()
        container:setPosition(ccp(bgSize.width / 2 + 5, bgSize.height - posY - itemSize.height / 2))
        if isCurrent then
          centerTarget = container
        end
        posY = posY + itemSize.height
      end
    elseif roundId > self.roundId then
      local groupId = 2
      local subId = 1
      local showCfg = roundCfg[groupId][subId]
      if showCfg then
        local container, ui = self:createNewRoundItem(showCfg)
        table.insert(self.uiList, {
          ui = ui,
          showCfg = showCfg,
          container = container
        })
        self.dragList:addItem(container)
        local itemSize = container:getContentSize()
        container:setPosition(ccp(bgSize.width / 2 + 5, bgSize.height - posY - itemSize.height / 2))
        posY = posY + itemSize.height
      end
    end
  end
  self.dragList:initListHeight(posY)
  if centerTarget then
    local targetPosX, targetPosY = centerTarget:getPosition()
    local listY = -targetPosY + self.ui.panel_list:getContentSize().height / 2
    listY = math.max(listY, 0)
    listY = math.min(listY, posY - self.ui.panel_list:getContentSize().height)
    self.dragList:setListPos(ccp(0, listY))
  end
  self:initPastStageNode()
end

function class:createLeftItem(historyData)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemLeft)
  ui.image_bg:ignoreAnchorPointForPosition(false)
  ui.image_bg:setAnchorPoint(ccp(0, 0.5))
  container:setContentSize(ui.image_bg:getContentSize())
  local isWin = historyData._is_win
  local roundId = historyData._round_id
  local result
  if isWin == 1 then
    result = T("\232\131\156\229\136\169")
    ed.setLabelColor(ui.label_title, ccc3(202, 178, 127))
    ed.setLabelStroke(ui.label_title, ed.toccc3(8475954), 1)
    ed.setLabelColor(ui.label_desc, ccc3(2202, 178, 127))
  else
    result = T("\229\164\177\232\180\165")
    ed.setLabelColor(ui.label_title, ed.toccc3(9938856))
    ed.setLabelStroke(ui.label_title, ed.toccc3(2115919), 1)
    ed.setLabelColor(ui.label_desc, ed.toccc3(10928322))
  end
  ed.setLabelString(ui.label_title, string.format(T("\231\172\172%s\232\189\174 %s"), ed.numberToChinese(roundId), result))
  local guildSummary = historyData._oppo_guild or {}
  ed.setLabelString(ui.label_desc, guildSummary._name and T("\229\175\185\230\137\139\239\188\154") .. guildSummary._name or T("\232\189\174\231\169\186"))
  local scheduleId = ed.getDataTable("GuildClashCourseShow")[roundId][1][1]["Schedule ID"]
  local guildClashScheduleCfg = ed.getDataTable("GuildClashSchedule")[scheduleId]
  local startTime = guildClashScheduleCfg["Start Time"]
  local y, m, d, h, min, s = string.match(startTime, "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")
  ed.setLabelString(ui.label_date, T("%s\230\156\136%s\230\151\165", m, d))
  ed.setLabelString(ui.label_time, T("%d:%.2d", h, min))
  return container, ui
end

function class:createRightItem(groupId, courseShowCfg)
  local container, ui
  if groupId == 1 then
    container, ui = self:createStartItem(courseShowCfg)
  elseif groupId == 2 then
    container, ui = self:createDetailItem(courseShowCfg)
  elseif groupId == 3 then
    container, ui = self:createDetailItem(courseShowCfg)
  elseif groupId == 4 then
    container, ui = self:createFightingItem(courseShowCfg)
  elseif groupId == 5 then
    container, ui = self:createMatchEndItem(courseShowCfg)
  elseif groupId == 6 then
    container, ui = self:createMatchEndItem(courseShowCfg)
  end
  local scheduleId = courseShowCfg["Schedule ID"]
  local isCurrent = scheduleId == self.currentScheduleId
  if isCurrent then
    ed.setLabelColor(ui.label_date, ed.toccc3(16510575))
    ed.setLabelStroke(ui.label_date, ed.toccc3(3040880), 1)
    ed.setLabelColor(ui.label_time, ccc3(244, 238, 210))
    ed.setLabelStroke(ui.label_time, ed.toccc3(2255462), 1)
    ed.setLabelColor(ui.label_state, ed.toccc3(16775911))
    ed.setLabelStroke(ui.label_state, ed.toccc3(2331545), 1)
  else
    ed.setLabelColor(ui.label_date, ccc3(154, 214, 205))
    ed.setLabelStroke(ui.label_date, ed.toccc3(1591119), 1)
    ed.setLabelColor(ui.label_time, ccc3(244, 238, 210))
    ed.setLabelStroke(ui.label_time, ed.toccc3(2255462), 1)
    ed.setLabelColor(ui.label_state, ccc3(182, 242, 241))
    ed.setLabelStroke(ui.label_state, ed.toccc3(4214860), 1)
  end
  local guildClashScheduleCfg = ed.getDataTable("GuildClashSchedule")[scheduleId]
  local startTime = guildClashScheduleCfg["Start Time"]
  local y, m, d, h, min, s = string.match(startTime, "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")
  ed.setLabelString(ui.label_date, T("%s\230\156\136%s\230\151\165", m, d))
  ed.setLabelString(ui.label_time, T("%d:%.2d", h, min))
  return container, ui, isCurrent
end

function class:createStartItem(cfg)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemRight1)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.label_desc:setFontName(ed.fontBold)
  ui.image_current:setVisible(cfg["Schedule ID"] == self.currentScheduleId)
  local guildClashScheduleCfg = ed.getDataTable("GuildClashSchedule")[self.currentScheduleId]
  local curStateType = guildClashScheduleCfg["State Type"]
  ed.setLabelString(ui.label_title, T("\231\172\172%s\232\189\174", ed.numberToChinese(cfg["Round ID"])))
  ed.setLabelStroke(ui.label_title, ed.toccc3(7039556), 1)
  ui.label_title:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_desc, ed.toccc3(4214860), 1)
  if curStateType and curStateType == "MatchGuilds" and cfg["Round ID"] - 1 > 0 then
    local preRoundId = cfg["Round ID"] - 1
    local battleResult = self:getBattleResult(preRoundId)
    local oppoGuild = battleResult._oppo_guild or {}
    ed.setLabelString(ui.label_title, T("\231\172\172%s\232\189\174", ed.numberToChinese(preRoundId)))
    ed.setLabelString(ui.label_desc, battleResult._is_win == 1 and T("\230\136\152\230\150\151\232\131\156\229\136\169") or T("\230\136\152\230\150\151\229\164\177\232\180\165"))
    ed.setLabelString(ui.label_oppo_name, oppoGuild._name or T("\232\189\174\231\169\186"))
  else
    ed.setLabelString(ui.label_desc, T("\229\183\178\229\140\185\233\133\141\229\175\185\230\137\139"))
    local guild_summary = self.oppoGuildSummary._guild_summary or {}
    ed.setLabelString(ui.label_oppo_name, guild_summary._name or T("\232\189\174\231\169\186"))
  end
  ed.setLabelStroke(ui.label_oppo_name, ed.toccc3(4214860), 1)
  return container, ui
end

function class:createDetailItem(cfg)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemRight2)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.btn_go:setVisible(false)
  local isCurrent = cfg["Schedule ID"] == self.currentScheduleId
  ui.label_state:setFontName(ed.fontBold)
  ed.setString(ui.label_state, cfg["Stage title dec"] or "")
  ed.setString(ui.label_desc, cfg["Stage content dec"] or "")
  ui.image_current:setVisible(isCurrent)
  ed.setLabelStroke(ui.label_state, ed.toccc3(2331545), 1)
  ed.setLabelStroke(ui.label_left_time, ed.toccc3(2254647), 1)
  ed.setLabelStroke(ui.label_desc, ed.toccc3(2255462), 1)
  ed.setLabelStroke(ui.label_go, ed.toccc3(1071702), 1)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(150, 0))
  local leftTime = self:calcLeftTime(cfg)
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  ed.setLabelString(ui.label_left_time, T("\229\137\169\228\189\153%s\229\164\169%s\229\176\143\230\151\182", day, hour))
  ui.label_left_time:setVisible(isCurrent)
  if not isCurrent then
    ed.UITool.setPositionBy(ui.label_desc, ccp(0, 15))
  end
  return container, ui
end

function class:createFightingItem(cfg)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemRight2)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.btn_go:setVisible(false)
  local roundId = cfg["Round ID"]
  local isCurrent = cfg["Schedule ID"] == self.currentScheduleId
  ui.image_current:setVisible(isCurrent)
  local battleResult = self:getBattleResult(roundId)
  if battleResult then
    local isWin = battleResult._is_win
    local oppoGuild = battleResult._oppo_guild or {}
    ed.setString(ui.label_state, isWin == 1 and T("\230\136\152\230\150\151\232\131\156\229\136\169") or T("\230\136\152\230\150\151\229\164\177\232\180\165"))
    ed.setString(ui.label_desc, oppoGuild._name and T("\229\175\185\230\137\139\239\188\154%s", oppoGuild._name) or T("\232\189\174\231\169\186"))
  else
    ed.setString(ui.label_state, cfg["Stage title dec"] or "")
    ed.setString(ui.label_desc, cfg["Stage content dec"] or "")
  end
  ed.setLabelStroke(ui.label_state, ed.toccc3(2331545), 1)
  ed.setLabelStroke(ui.label_left_time, ed.toccc3(2254647), 1)
  ed.setLabelStroke(ui.label_desc, ed.toccc3(2255462), 1)
  ed.setLabelStroke(ui.label_go, ed.toccc3(1071702), 1)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(150, 0))
  ui.label_state:setFontName(ed.fontBold)
  local leftTime = self:calcLeftTime(cfg)
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  ed.setLabelString(ui.label_left_time, T("\229\137\169\228\189\153%s\229\164\169%s\229\176\143\230\151\182", day, hour))
  ui.label_left_time:setVisible(isCurrent)
  if not isCurrent then
    ed.UITool.setPositionBy(ui.label_desc, ccp(0, 15))
  end
  return container, ui
end

function class:createMatchEndItem(cfg)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemRight3)
  container:setContentSize(ui.image_bg:getContentSize())
  local scheduleId = cfg["Schedule ID"]
  ui.image_current:setVisible(scheduleId == self.currentScheduleId)
  ed.setString(ui.label_title, cfg["Stage title dec"] or "")
  ed.setString(ui.label_desc, cfg["Stage content dec"] or "")
  ed.setLabelStroke(ui.label_desc, ed.toccc3(2255462), 1)
  ed.setLabelStroke(ui.label_title, ed.toccc3(7039556), 1)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(150, 0))
  return container, ui
end

function class:createSeasonEndItem(cfg)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemRight3)
  container:setContentSize(ui.image_bg:getContentSize())
  local scheduleId = cfg["Schedule ID"]
  ui.image_current:setVisible(scheduleId == self.currentScheduleId)
  ed.setString(ui.label_title, cfg["Stage title dec"] or "")
  ed.setString(ui.label_desc, cfg["Stage content dec"] or "")
  ed.setLabelStroke(ui.label_desc, ed.toccc3(2255462), 1)
  ed.setLabelStroke(ui.label_title, ed.toccc3(7039556), 1)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(150, 0))
  return container, ui
end

function class:createNewRoundItem(cfg)
  local container, ui = ed.editorui(ed.uieditor.GuildClashCourseItemRight1)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.label_desc:setFontName(ed.fontBold)
  ui.image_current:setVisible(cfg["Schedule ID"] == self.currentScheduleId)
  ed.setLabelString(ui.label_title, T("\231\172\172%s\232\189\174", ed.numberToChinese(cfg["Round ID"])))
  ed.setLabelStroke(ui.label_title, ed.toccc3(7039556), 1)
  ed.setLabelStroke(ui.label_desc, ed.toccc3(4214860), 1)
  ed.setLabelString(ui.label_oppo_name, " ")
  ed.setLabelStroke(ui.label_oppo_name, ed.toccc3(4214860), 1)
  ed.setLabelString(ui.label_desc, T("\230\175\148\232\181\155\232\191\152\230\156\170\229\188\128\229\167\139"))
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(150, 0))
  local scheduleId = cfg["Schedule ID"]
  local guildClashScheduleCfg = ed.getDataTable("GuildClashSchedule")[scheduleId]
  local startTime = guildClashScheduleCfg["Start Time"]
  local y, m, d, h, min, s = string.match(startTime, "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")
  ed.setLabelString(ui.label_date, T("%s\230\156\136%s\230\151\165", m, d))
  ed.setLabelString(ui.label_time, T("%d:%.2d", h, min))
  ed.setLabelColor(ui.label_date, ccc3(154, 214, 205))
  ed.setLabelStroke(ui.label_date, ed.toccc3(1591119), 1)
  ed.setLabelColor(ui.label_time, ccc3(244, 238, 210))
  ed.setLabelStroke(ui.label_time, ed.toccc3(2255462), 1)
  ed.setLabelColor(ui.label_state, ccc3(182, 242, 241))
  ed.setLabelStroke(ui.label_state, ed.toccc3(4214860), 1)
  return container, ui
end

function class:calcLeftTime(cfg)
  local roundId = cfg["Round ID"]
  local groupId = cfg["Group ID"]
  local nextScheduleId
  local guildClashCourseShowTB = ed.getDataTable("GuildClashCourseShow")
  if guildClashCourseShowTB[roundId][groupId + 1] then
    nextScheduleId = guildClashCourseShowTB[roundId][groupId + 1][1]["Schedule ID"]
  elseif guildClashCourseShowTB[roundId + 1] and guildClashCourseShowTB[roundId + 1][2] then
    nextScheduleId = guildClashCourseShowTB[roundId + 1][2][1]["Schedule ID"]
  end
  if nextScheduleId then
    local guildClashScheduleCfg = ed.getDataTable("GuildClashSchedule")[nextScheduleId]
    local startTime = ed.dateStringToTime(guildClashScheduleCfg["Start Time"])
    local leftTime = startTime - ed.getFitServerTime()
    return leftTime
  else
    return 0
  end
end

function class:getMaxRound()
  local maxRoundId
  for roundId, _ in ipairs(ed.getDataTable("GuildClashCourseShow") or {}) do
    maxRoundId = roundId
  end
  return maxRoundId or 0
end

function class:getBattleResult(roundId)
  for index, historyData in ipairs(self.battleHistory) do
    if historyData._round_id == roundId then
      return historyData
    end
  end
end

function class:initPastStageNode()
  self.ui.panel_node:removeAllChildrenWithCleanup(true)
  if #self.uiList == 0 then
    return
  end
  for index = 1, #self.uiList do
    local uiCfg = self.uiList[index]
    local node = self:createPastStageNode(index, uiCfg)
    self.ui.panel_node:addChild(node)
    uiCfg.paststageNode = node
  end
  self:refreshPastStageNodePos()
end

function class:createPastStageNode(index, uiCfg)
  local showCfg = uiCfg.showCfg
  local isCurrent = showCfg and showCfg["Schedule ID"] == self.currentScheduleId or false
  local node
  if isCurrent then
    node = ed.createSprite("UI/alpha/1080P/guild/guild_clash_course/currentstage_node.png")
  else
    node = ed.createSprite("UI/alpha/1080P/guild/guild_clash_course/paststage_node.png")
  end
  return node
end

function class:refreshPastStageNodePos()
  if #self.uiList == 0 then
    return
  end
  for index = 1, #self.uiList do
    local uiCfg = self.uiList[index]
    local container = uiCfg.container
    local paststageNode = uiCfg.paststageNode
    if paststageNode then
      local worldPos = container:getParent():convertToWorldSpace(ccp(container:getPosition()))
      local parent = paststageNode:getParent()
      if parent then
        local pos = parent:convertToNodeSpace(worldPos)
        local posY = math.max(pos.y, 10)
        posY = math.min(posY, 305)
        paststageNode:setPosition(ccp(10, posY))
      end
    end
  end
end

function class:addEventListener()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.98})
end
