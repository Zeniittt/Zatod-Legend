local base = ed.ui.popwindow
local GuildClashBattleRecordWin = newclass(base.mt)
ed.ui.GuildClashBattleRecordWin = GuildClashBattleRecordWin
local lineConfig = {
  {
    icon = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_toproad.png",
    title = T("\228\184\138\232\183\175")
  },
  {
    icon = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_midroad.png",
    title = T("\228\184\173\232\183\175")
  },
  {
    icon = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_botroad.png",
    title = T("\228\184\139\232\183\175")
  }
}
local selfFont = "guild_clash_name_self"
local oppoFont = "guild_clash_name_oppo"

function GuildClashBattleRecordWin:initData(params)
  self.mgr = ed.GuildClashManager
  self.data = params.data or {}
  self.lineId = params.lineId or 1
  self.tabIndex = 0
  self.destroyCallback = params.callback
  self.winCamp = self.data._win_camp
  self.campId = self.data._camp_id
  self.linesSummary = self.data._summarys
  self.historyLineBattle = {}
  self.selectHistoryLine = 1
end

function GuildClashBattleRecordWin:initLabels()
  ed.setLabelStroke(self.ui.label_tab0, ed.toccc3(4666403), 1)
  ed.setLabelStroke(self.ui.label_tab0_selected, ed.toccc3(6305310), 1)
  ed.setLabelStroke(self.ui.label_tab1, ed.toccc3(4666403), 1)
  ed.setLabelStroke(self.ui.label_tab1_selected, ed.toccc3(6305310), 1)
  ed.setLabelStroke(self.ui.label_tab2, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.label_tab2_selected, ed.toccc3(6305310), 1)
  ed.setLabelStroke(self.ui.label_tab3, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.label_tab3_selected, ed.toccc3(6305310), 1)
  ed.setLabelStroke(self.ui.label_tab4, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.label_tab4_selected, ed.toccc3(6305310), 1)
  ed.setLabelStroke(self.ui.label_tab5, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.label_tab5_selected, ed.toccc3(6305310), 1)
  self.ui.layer0_line1_name:setFontName(ed.fontBold)
  self.ui.layer0_line2_name:setFontName(ed.fontBold)
  self.ui.layer0_line3_name:setFontName(ed.fontBold)
  self.ui.layer0_line1_name:limitWidthByScale(90)
  self.ui.layer0_line2_name:limitWidthByScale(90)
  self.ui.layer0_line3_name:limitWidthByScale(90)
  for i = 0, 5 do
    ed.adaptLabel(self.ui["label_tab" .. i], {maxWidth = 90, minScale = 0.7})
    self.ui["label_tab" .. i]:setHorizontalAlignment(kCCTextAlignmentCenter)
    ed.adaptLabel(self.ui["label_tab" .. i .. "_selected"], {maxWidth = 90, minScale = 0.7})
    self.ui["label_tab" .. i .. "_selected"]:setHorizontalAlignment(kCCTextAlignmentCenter)
  end
  ed.right2(self.ui.kill, self.ui.ImageView_533, 1)
  ed.right2(self.ui.survive, self.ui.ImageView_534, 1)
  ed.setLabelStroke(self.ui.tip, ed.toccc3(3221280), 1.5)
  ed.setLabelStroke(self.ui.tip_title, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.Label_559, ed.toccc3(1578519), 1)
  self.ui.camp1:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.camp1, ed.toccc3(3370305), 1)
  self.ui.camp2:limitWidthByScale(70)
  self.ui.camp2:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.camp2, ed.toccc3(8141875), 1)
  self.ui.camp2:limitWidthByScale(70)
  self.ui.name_camp1:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.name_camp1, ed.toccc3(2382393), 1)
  self.ui.name_camp2:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.name_camp2, ed.toccc3(9123633), 1)
end

function GuildClashBattleRecordWin:getCancelPressInHandler()
  local function handler(x, y)
  end
  
  return handler
end

function GuildClashBattleRecordWin:getPressInHandler(line)
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
    end
  end
  
  return handler
end

function GuildClashBattleRecordWin:getClickInHandler()
  local function handler(x, y, item)
    if not item then
      return
    end
  end
  
  return handler
end

function GuildClashBattleRecordWin:getHistoryPressInHandler()
  local function handler(x, y)
    for k, item in ipairs(self.historyUiList or {}) do
      local ui = item.ui
      
      if ed.containsPoint(ui.open, x, y) or ui.bg_bottom:isVisible() and ed.containsPoint(ui.btn_replay, x, y) then
        return item
      end
    end
  end
  
  return handler
end

function GuildClashBattleRecordWin:getHistoryClickInHandler()
  local function handler(x, y, item)
    if not item then
      return
    end
    local ui = item.ui
    if ed.containsPoint(ui.btn_replay, x, y) then
      self:onClickReplay(item)
      return
    end
    if ed.containsPoint(ui.open, x, y) then
      self:onClickDetail(item)
    end
  end
  
  return handler
end

function GuildClashBattleRecordWin:onClickDetail(item)
  local ui = item.ui
  if ui.bg_bottom:isVisible() then
    self:onCloseDetailPanel(item)
  else
    self.selectedItem = item
    if self.mgr.replayList[item.data._replay_id] then
      FireEvent("GuildClashQueryReplay")
    else
      ed.GuildClashNetwork:sendQueryReplay(item.data._replay_id)
    end
  end
end

function GuildClashBattleRecordWin:onCloseDetailPanel(item)
  item.ui.bg_bottom:setVisible(false)
  item.ui.open:setScaleY(1)
  self:doMoveUpAction(item, 57)
end

function GuildClashBattleRecordWin:doMoveUpAction(item, dy)
  for k, v in ipairs(self.historyUiList or {}) do
    if v.container:getPositionY() < item.container:getPositionY() then
      v.container:runAction(CCMoveBy:create(0.2, ccp(0, dy)))
    end
  end
  for k, v in ipairs(self.darkTeamUI) do
    v.container:runAction(CCMoveBy:create(0.2, ccp(0, dy)))
  end
  for k, v in ipairs(self.natureTeamUI) do
    v.container:runAction(CCMoveBy:create(0.2, ccp(0, dy)))
  end
  self.historyDragList:initListHeight(self.historyDragList.listHeight - dy, false)
end

function GuildClashBattleRecordWin:doMoveDownAction(item, dy)
  for k, v in ipairs(self.historyUiList) do
    if v.container:getPositionY() < item.container:getPositionY() then
      v.container:runAction(CCMoveBy:create(0.2, ccp(0, -dy)))
    end
  end
  for k, v in ipairs(self.darkTeamUI) do
    v.container:runAction(CCMoveBy:create(0.2, ccp(0, -dy)))
  end
  for k, v in ipairs(self.natureTeamUI) do
    v.container:runAction(CCMoveBy:create(0.2, ccp(0, -dy)))
  end
  local x, y = self.historyDragList:getListPos()
  self.historyDragList:initListHeight(self.historyDragList.listHeight + dy)
  self.historyDragList:setListPos(ccp(x, y))
end

function GuildClashBattleRecordWin:handleReplay()
  local item = self.selectedItem
  if not item then
    return
  end
  if tolua.isnull(item.container) then
    return
  end
  local replayData = self.mgr.replayList[item.data._replay_id]
  if not replayData then
    return
  end
  self:initBattlePanelHero(item, replayData)
  self:onOpenDetailPanel(item)
end

function GuildClashBattleRecordWin:onOpenDetailPanel(item)
  item.ui.bg_bottom:setVisible(true)
  item.ui.open:setScaleY(-1)
  self:doMoveDownAction(item, 57)
end

function GuildClashBattleRecordWin:onClickReplay(item)
  local replayData = self.mgr.replayList[item.data._replay_id]
  if replayData then
    if item.type == "curBattle" then
      self.mgr.enterReplay(replayData, true)
    else
      self.mgr.enterReplay(replayData, false)
    end
  end
end

function GuildClashBattleRecordWin:initBattlePanelHero(item, replayData)
  local ui = item.ui
  local camp1Hero = replayData._camp1_heroes
  local camp2Hero = replayData._camp2_heroes
  local camp1Dyna = replayData._camp1_hero_dynas
  local camp2Dyna = replayData._camp2_hero_dynas
  for k, v in ipairs(camp1Hero or {}) do
    local icon = ed.readhero.createIcon({
      id = v._tid,
      rank = v._rank,
      fashion_id = v._fashion,
      summary = v,
      level = v._level,
      stars = v._stars,
      hp = camp1Dyna[k]._hp_perc,
      mp = camp1Dyna[k]._mp_perc
    }).icon
    icon:setScale(0.6)
    ed.UITool.replaceUI(ui, "bg_bottom", "camp1_hero" .. k, icon)
  end
  for k, v in ipairs(camp2Hero or {}) do
    local icon = ed.readhero.createIcon({
      id = v._tid,
      rank = v._rank,
      fashion_id = v._fashion,
      summary = v,
      level = v._level,
      stars = v._stars,
      hp = camp2Dyna[k]._hp_perc,
      mp = camp2Dyna[k]._mp_perc
    }).icon
    icon:setScale(0.6)
    ed.UITool.replaceUI(ui, "bg_bottom", "camp2_hero" .. k, icon)
  end
end

function GuildClashBattleRecordWin:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashMemberRecordItem)
  local summary = data._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.6,
    lvoffset = {x = -47, y = -20},
    config = {
      namefont = "guild_clash_battle_name",
      nameposition = -10
    },
    levelScale = 0.8,
    name = summary._name,
    medal = summary._medal,
    no_name_bg = true
  }
  local avatar = ed.getWholeHeadIcon(param)
  ed.setLabelStroke(ui.kill, ed.toccc3(3351054), 1)
  ed.setString(ui.kill, data._param2)
  ed.setLabelStroke(ui.survival, ed.toccc3(2825483), 1)
  ed.setString(ui.survival, data._param3)
  ed.UITool.replaceUI(ui, "bg", "avatar", avatar)
  return container, ui
end

function GuildClashBattleRecordWin:refreshDraglist()
  self.draglist:clearList()
  local contentSize = self.ui.layer_item:getContentSize()
  local ox, oy = contentSize.width / 2, contentSize.height
  local data = self.linesSummary[self.lineId]._rank_list or {}
  self.uiList = {}
  local itemHeight = 60
  for k, v in ipairs(data) do
    local container, ui = self:createItem(v)
    local item = {
      ui = ui,
      container = container,
      data = v
    }
    table.insert(self.uiList, item)
    ui.container = container
    container:setPosition(ox, oy - (k - 0.5) * itemHeight)
    self.draglist:addItem(container)
  end
  self.draglist:initListHeight(#data * itemHeight)
end

function GuildClashBattleRecordWin:initTitle()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format(T("\228\184\142<lable color=ccc3(254,232,231)>%s</lable>\229\133\172\228\188\154,\228\186\137\229\164\186\230\136\152\230\150\151\231\187\147\230\158\156\229\166\130\228\184\139"), self.oppoSummary._name),
    color = ccc3(231, 192, 117),
    strokeColor = ed.toccc3(4797997),
    strokeSize = 1,
    fontSize = 18
  })
  local width = autoText:getCurContentSize()
  ed.UITool.replaceUI(self.ui, "layer2", "Label_560", autoText.node)
  self.ui.Label_560:setPositionX(self.ui.Label_560:getPositionX() - width / 2)
end

function GuildClashBattleRecordWin:refreshLayer0()
  self.ui.layer0_win:setVisible(self.winCamp == self.campId)
  self.ui.layer0_lose:setVisible(self.winCamp ~= self.campId)
  for i = 1, 3 do
    local lineData = self.linesSummary[i]
    local num1 = lineData._camp1_team or 0
    local num2 = lineData._camp2_team or 0
    if self.campId == 2 then
      num1 = lineData._camp2_team or 0
      num2 = lineData._camp1_team or 0
    end
    ed.setLabelStroke(self.ui["layer0_line" .. i .. "_self"], ed.toccc3(4461329), 1)
    ed.setLabelStroke(self.ui["layer0_line" .. i .. "_oppo"], ed.toccc3(1644312), 1)
    ed.setString(self.ui["layer0_line" .. i .. "_self"], T("\230\136\145\230\150\185\239\188\154%d\233\152\159", num1))
    ed.setString(self.ui["layer0_line" .. i .. "_oppo"], T("\230\149\140\230\150\185\239\188\154%d\233\152\159", num2))
    ed.adaptLabel(self.ui["layer0_line" .. i .. "_self"], {maxWidth = 120, minScale = 0.7})
    ed.adaptLabel(self.ui["layer0_line" .. i .. "_oppo"], {maxWidth = 120, minScale = 0.7})
    if lineData._win_camp == self.campId then
      ed.setLabelColor(self.ui["layer0_line" .. i .. "_name"], ccc3(231, 192, 117))
      ed.setLabelStroke(self.ui["layer0_line" .. i .. "_name"], ed.toccc3(4797997), 1)
      local result = ed.createSprite("UI/alpha/1080P/guild/guild_clash_report/art_win.png")
      ed.UITool.replaceUI(self.ui, "layer0_line" .. i, "layer0_line" .. i .. "_result", result)
      ed.setTexture(self.ui["layer0_line" .. i], "UI/alpha/1080P/guild/guild_clash_report/battleinfo_win.png")
    else
      ed.setLabelColor(self.ui["layer0_line" .. i .. "_name"], ccc3(189, 182, 233))
      ed.setLabelStroke(self.ui["layer0_line" .. i .. "_name"], ed.toccc3(3221843), 1)
      local result = ed.createSprite("UI/alpha/1080P/guild/guild_clash_report/art_lose.png")
      ed.UITool.replaceUI(self.ui, "layer0_line" .. i, "layer0_line" .. i .. "_result", result)
      ed.setTexture(self.ui["layer0_line" .. i], "UI/alpha/1080P/guild/guild_clash_report/battleinfo_lose.png")
    end
    if lineData._camp1_random then
      ed.right2(self.ui["btn_why" .. i], self.ui["layer0_line" .. i .. "_result"], 2)
      self.ui["btn_why" .. i]:setVisible(true)
    end
  end
end

function GuildClashBattleRecordWin:initUI()
  ed.editorui(ed.uieditor.GuildClashBattleRecordWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
  self.historyDragList = ed.UITool.createDraglist(self.ui.layer3_item, {
    doPressIn = self:getHistoryPressInHandler(),
    doClickIn = self:getHistoryClickInHandler()
  })
  if self.linesSummary then
    self:changeTab(0, true)
    self.ui.bg_tip:setVisible(false)
  else
    for i = 0, 5 do
      self.ui["tab" .. i]:setVisible(false)
      self.ui["tab" .. i .. "_selected"]:setVisible(false)
    end
    self.ui.bg_tip:setVisible(true)
    self.ui.layer0:setVisible(false)
    self.ui.layer1:setVisible(false)
    self.ui.layer2:setVisible(false)
    self.ui.layer3:setVisible(false)
  end
end

function GuildClashBattleRecordWin:registerEvents()
  self:listenEvent("GuildClashQueryLineBattle", function(data)
    local lineBattle = data._line_battle or {}
    self.historyLineBattle[lineBattle._line_id] = lineBattle
    self:refreshLayer3()
  end)
  self:listenEvent("GuildClashQueryReplay", function()
    self:handleReplay()
  end)
  self:listenEvent("GuildClashQueryLastSummary", function(data)
    self.lastSelfCampId = data._camp_id
    self.lastGuildSummary = data._guild_summary
    self.camp1_summarys = data._camp1_summarys
    self.camp2_summarys = data._camp2_summarys
    self:refreshGuildSummary()
    self:onClickHistoryBtnLine(1)
  end)
end

function GuildClashBattleRecordWin:refreshLayer1()
  self.ui.layer1_win:setVisible(self.winCamp == self.campId)
  self.ui.layer1_lose:setVisible(self.winCamp ~= self.campId)
  self:changeLine(self.lineId, true)
end

local names = {
  T("\229\138\155\233\135\143\231\165\158\231\172\166"),
  T("\230\153\186\229\138\155\231\165\158\231\172\166"),
  T("\230\149\143\230\141\183\231\165\158\231\172\166"),
  T("\233\128\159\229\186\166\231\165\158\231\172\166"),
  T("\229\188\186\230\148\187\231\165\158\231\172\166")
}

function GuildClashBattleRecordWin:refreshLayer2()
  local results = {
    true,
    false,
    false,
    true,
    true
  }
  local param = {
    0,
    0,
    1,
    1,
    0
  }
  for k, v in ipairs(results) do
    if v then
      ed.UITool.replaceUI(self.ui, "power" .. k, "result_power" .. k, ed.createSprite("UI/alpha/1080P/toparena/battleshow/battleshow_result_win2.png"))
      ed.setTexture(self.ui["power" .. k], "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_win.png")
      ed.setLabelColor(self.ui["info_power" .. k], ccc3(231, 192, 117))
      ed.setLabelStroke(self.ui["info_power" .. k], ed.toccc3(4797997), 1)
    else
      ed.UITool.replaceUI(self.ui, "power" .. k, "result_power" .. k, ed.createSprite("UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png"))
      ed.setTexture(self.ui["power" .. k], "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_lose.png")
      ed.setLabelColor(self.ui["info_power" .. k], ccc3(206, 207, 228))
      ed.setLabelStroke(self.ui["info_power" .. k], ed.toccc3(5393506), 1)
    end
    if param[k] == 1 then
      ed.setString(self.ui["info_power" .. k], T("\231\136\134\229\143\145\230\136\152\230\150\151\239\188\140\230\136\145\230\150\185\230\138\162\231\172\166") .. (v and T("\230\136\144\229\138\159") or T("\229\164\177\232\180\165")))
    else
      ed.setString(self.ui["info_power" .. k], (v and T("\230\136\145\230\150\185") or T("\230\149\140\230\150\185")) .. T("\229\129\183\231\172\166\230\136\144\229\138\159"))
    end
    ed.setString(self.ui["name_power" .. k], names[k])
  end
end

function GuildClashBattleRecordWin:refreshGuildSummary()
  local selfSummary = self.mgr.selfGuildSummary._guild_summary
  local oppoSummary = self.lastGuildSummary._guild_summary
  local selfAvatarData = ed.analyzeAvatar(selfSummary._avatar)
  local selfGuildIcon = ed.createGuildAvatar(selfAvatarData.avatar, selfAvatarData.avatarFrame)
  local oppoAvatarData = ed.analyzeAvatar(oppoSummary._avatar)
  local oppoGuildIcon = ed.createGuildAvatar(oppoAvatarData.avatar, oppoAvatarData.avatarFrame)
  if self.lastSelfCampId == 1 then
    ed.setString(self.ui.camp1, T("\230\136\145\230\150\185"))
    ed.setString(self.ui.camp2, T("\230\149\140\230\150\185"))
    ed.UITool.replaceUI(self.ui, "left", "avatar_camp1", selfGuildIcon)
    ed.setString(self.ui.name_camp1, selfSummary._name)
    ed.UITool.replaceUI(self.ui, "right", "avatar_camp2", oppoGuildIcon)
    ed.setString(self.ui.name_camp2, oppoSummary._name)
  else
    ed.setString(self.ui.camp1, T("\230\149\140\230\150\185"))
    ed.setString(self.ui.camp2, T("\230\136\145\230\150\185"))
    ed.UITool.replaceUI(self.ui, "left", "avatar_camp1", oppoGuildIcon)
    ed.setString(self.ui.name_camp1, oppoSummary._name)
    ed.UITool.replaceUI(self.ui, "right", "avatar_camp2", selfGuildIcon)
    ed.setString(self.ui.name_camp2, selfSummary._name)
  end
end

function GuildClashBattleRecordWin:refreshLayer3(oldPos)
  local history = self.historyLineBattle[self.selectHistoryLine] or {}
  local data = history._battle or {}
  ed.setString(self.ui.camp1_teams, string.format(T("\229\137\169\228\189\153\233\152\159\228\188\141:%d/%d"), history._team1_left, history._team1_count))
  ed.setString(self.ui.camp2_teams, string.format(T("\229\137\169\228\189\153\233\152\159\228\188\141:%d/%d"), history._team2_left, history._team2_count))
  local oldY = 0
  if oldPos then
    oldY = self.historyDragList.listLayer:getPositionY()
  end
  self.historyDragList:clearList()
  local contentSize = self.ui.layer3_item:getContentSize()
  local ox, oy = 0, contentSize.height
  local itemHeight = 42
  self.historyUiList = {}
  self.darkTeamUI = {}
  self.natureTeamUI = {}
  for k, v in ipairs(data) do
    local container, ui = self:createBattle(v)
    local y = oy - k * itemHeight
    container:setPosition(ccp(-28, y))
    ed.UITool.setPositionBy(ui.open, ccp(-15, 0))
    self.historyDragList:addItem(container)
    local item = {
      ui = ui,
      container = container,
      data = v,
      type = "battle"
    }
    table.insert(self.historyUiList, item)
  end
  self.historyDragList:initListHeight(#data * itemHeight + 2)
  if oldPos then
    self.historyDragList.listLayer:setPositionY(oldY)
  end
end

function GuildClashBattleRecordWin:createBattle(data, isCur)
  local container, ui = ed.editorui(ed.uieditor.GuildClashBattleItem)
  ui.camp1:setCascadeOpacityEnabled(true)
  ui.camp2:setCascadeOpacityEnabled(true)
  local userSummary1 = self:getLastPlayerSummary(data._team1._camp_id, data._team1._uid)
  local user1Head = ed.getWholeHeadIcon({
    id = userSummary1._avatar,
    name = userSummary1._name,
    medal = userSummary1._medal,
    scale = 0.4,
    no_name_bg = true,
    config = {namefont = selfFont, nameposition = -22}
  })
  ed.UITool.replaceUI(ui, "camp1", "name_camp1", user1Head)
  ui.name_camp1:setPositionX(ui.name_camp1:getPositionX() - 82)
  local userSummary2 = self:getLastPlayerSummary(data._team2._camp_id, data._team2._uid)
  local user2Head = ed.getWholeHeadIcon({
    id = userSummary2._avatar,
    name = userSummary2._name,
    medal = userSummary2._medal,
    scale = 0.4,
    no_name_bg = true,
    config = {namefont = oppoFont, nameposition = -22}
  })
  ed.UITool.replaceUI(ui, "camp2", "name_camp2", user2Head)
  ui.name_camp2:setPositionX(ui.name_camp2:getPositionX() - 75)
  if isCur then
    local fca = ed.createFcaNode("eff_UI_Stargate_Battle")
    self:addFca(fca)
    ed.UITool.replaceUI(ui, "bg", "icon_result", fca)
  else
    local iconResult = self:getResultRes(data)
    ed.UITool.replaceUI(ui, "bg", "icon_result", iconResult)
    if data._win_camp == 1 then
      ui.camp2_mask:setVisible(true)
    else
      ui.camp1_mask:setVisible(true)
    end
  end
  return container, ui
end

function GuildClashBattleRecordWin:getLastPlayerSummary(campId, id)
  local summaryList
  if campId == 1 then
    summaryList = self.camp1_summarys
  else
    summaryList = self.camp2_summarys
  end
  for index, guildClashUserSummary in ipairs(summaryList or {}) do
    if guildClashUserSummary._id == id then
      return guildClashUserSummary._user_summary
    end
  end
  return {}
end

function GuildClashBattleRecordWin:getResultRes(battle)
  local res = {
    [1] = {
      text = T("\229\164\177\232\180\165"),
      startColor = ed.toccc3(12960976),
      endColor = ed.toccc3(10921143),
      strokeColor = ed.toccc3(6578811),
      strokeSize = 1,
      shadowSize = -0.5
    },
    [2] = {
      text = T("\232\131\156\229\136\169"),
      startColor = ed.toccc3(15857053),
      endColor = ed.toccc3(15776871),
      strokeColor = ed.toccc3(11034640),
      strokeSize = 1,
      shadowSize = -0.5
    },
    [3] = {
      text = T("\231\167\146\230\157\128"),
      startColor = ed.toccc3(15775901),
      endColor = ed.toccc3(14038016),
      strokeColor = ed.toccc3(7020063),
      strokeSize = 1,
      shadowSize = -0.5
    },
    [4] = {
      text = T("\233\153\169\232\131\156"),
      startColor = ed.toccc3(15775901),
      endColor = ed.toccc3(14038016),
      strokeColor = ed.toccc3(7020063),
      strokeSize = 1,
      shadowSize = -0.5
    },
    [5] = {
      text = T("\230\154\180\232\181\176"),
      startColor = ed.toccc3(16777215),
      endColor = ed.toccc3(14018815),
      strokeColor = ed.toccc3(12009468),
      strokeSize = 1,
      shadowSize = -0.5
    }
  }
  local idx = 1
  local fontName = ed.fontBold
  local fontSize = 21
  if battle._win_camp == self.lastSelfCampId then
    if battle._type == "victory" then
      idx = 2
    elseif battle._type == "narrow_victory" then
      idx = 4
    elseif battle._type == "rampage" then
      idx = 5
    else
      idx = 3
    end
  end
  local config = res[idx]
  local label = ed.ui.gradientLabel.create({
    text = config.text,
    fontSize = fontSize,
    fontName = fontName,
    startColor = config.startColor,
    endColor = config.endColor,
    strokeSize = config.strokeSize,
    strokeColor = config.strokeColor,
    shadowColor = ed.toccc3(0),
    shadowOffset = ccp(0, config.shadowSize)
  })
  label.node:setScale(math.min(1, 150 / label.node:getContentSize().width))
  return label.node
end

function GuildClashBattleRecordWin:changeTab(tabIndex, force)
  if self.tabIndex == tabIndex and not force then
    return
  end
  if self.tabIndex then
    self.ui["tab" .. self.tabIndex .. "_selected"]:setVisible(false)
    self.ui["tab" .. self.tabIndex]:setVisible(true)
  end
  self.tabIndex = tabIndex
  self.ui["tab" .. self.tabIndex .. "_selected"]:setVisible(true)
  self.ui["tab" .. self.tabIndex]:setVisible(false)
  self.ui.layer0:setVisible(self.tabIndex == 0)
  self.ui.layer1:setVisible(self.tabIndex == 1)
  self.ui.layer2:setVisible(self.tabIndex == 2)
  self.ui.layer3:setVisible(self.tabIndex == 5)
  if self.tabIndex == 0 then
    self:refreshLayer0()
  elseif self.tabIndex == 1 then
    self:refreshLayer1()
  elseif self.tabIndex == 2 then
    self:refreshLayer2()
  elseif self.tabIndex == 5 then
    if self.lastGuildSummary then
      self:onClickHistoryBtnLine(1)
    else
      ed.GuildClashNetwork:setQueryLastSummarys()
    end
  end
end

function GuildClashBattleRecordWin:changeLine(lineId, force)
  if self.lineId == lineId and not force then
    return
  end
  self.ui["btn_line" .. self.lineId .. "_selected"]:setVisible(false)
  self.lineId = lineId
  self.ui["btn_line" .. self.lineId .. "_selected"]:setVisible(true)
  self:refreshDraglist()
end

function GuildClashBattleRecordWin:showDogfallTip(lineId)
  local data = self.linesSummary[lineId]
  if data and data._camp1_random then
    local selfWin = data._camp1_random
    local oppoWin = data._camp2_random
    if self.campId == 2 then
      selfWin = data._camp2_random
      oppoWin = data._camp1_random
    end
    ed.showToast(string.format(T("\229\143\140\230\150\185\229\133\172\228\188\154\229\157\135\230\156\170\229\156\168\230\173\164\229\136\134\232\183\175\228\184\138\233\152\159\228\188\141\239\188\140\229\155\160\230\173\164\230\142\183\233\170\176\229\173\144\229\134\179\229\174\154\232\131\156\232\180\159\239\188\140\228\189\160\230\150\185\231\130\185\230\149\176\239\188\154%d\239\188\140\230\149\140\230\150\185\231\130\185\230\149\176\239\188\154%d"), selfWin, oppoWin), {maxWidth = 800})
  end
end

function GuildClashBattleRecordWin:onClickHistoryBtnLine(lineId)
  self.selectHistoryLine = lineId
  for index = 1, 3 do
    self.ui[string.format("layer3_btn_line%s_selected", index)]:setVisible(index == lineId)
  end
  if self.historyLineBattle[lineId] then
    self:refreshLayer3()
  else
    ed.GuildClashNetwork:sendQueryLine(lineId)
  end
end

function GuildClashBattleRecordWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.72, normalScale = 0.8})
  ed.UITool.registerBtn(self, "tab0", function()
    self:changeTab(0)
  end)
  ed.UITool.registerBtn(self, "tab1", function()
    self:changeTab(1)
  end)
  ed.UITool.registerBtn(self, "tab2", function()
    self:changeTab(2)
  end)
  ed.UITool.registerBtn(self, "tab3", function()
    self:changeTab(3)
  end)
  ed.UITool.registerBtn(self, "tab4", function()
    self:changeTab(4)
  end)
  ed.UITool.registerBtn(self, "tab5", function()
    self:changeTab(5)
  end)
  ed.UITool.registerBtn(self, "btn_line1", function()
    self:changeLine(1)
  end)
  ed.UITool.registerBtn(self, "btn_line2", function()
    self:changeLine(2)
  end)
  ed.UITool.registerBtn(self, "btn_line3", function()
    self:changeLine(3)
  end)
  ed.UITool.registerBtn(self, "btn_why1", function()
    self:showDogfallTip(1)
  end)
  ed.UITool.registerBtn(self, "btn_why2", function()
    self:showDogfallTip(2)
  end)
  ed.UITool.registerBtn(self, "btn_why3", function()
    self:showDogfallTip(3)
  end)
  ed.UITool.registerBtn(self, "layer3_btn_line1", function()
    self:onClickHistoryBtnLine(1)
  end)
  ed.UITool.registerBtn(self, "layer3_btn_line2", function()
    self:onClickHistoryBtnLine(2)
  end)
  ed.UITool.registerBtn(self, "layer3_btn_line3", function()
    self:onClickHistoryBtnLine(3)
  end)
end

function GuildClashBattleRecordWin.create(params)
  local self = base.create("GuildClashBattleRecordWin")
  setmetatable(self, GuildClashBattleRecordWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end
