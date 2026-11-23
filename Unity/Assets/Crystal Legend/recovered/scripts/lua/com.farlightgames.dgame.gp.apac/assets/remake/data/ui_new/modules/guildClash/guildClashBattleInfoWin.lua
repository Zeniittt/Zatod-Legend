local base = ed.ui.popwindow
local GuildClashBattleInfoWin = newclass(base.mt)
ed.ui.GuildClashBattleInfoWin = GuildClashBattleInfoWin
local lineConfig = {
  {
    icon = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_toproad.png",
    title = T("\228\184\138\232\183\175\230\136\152\230\150\151\229\189\162\229\138\191")
  },
  {
    icon = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_midroad.png",
    title = T("\228\184\173\232\183\175\230\136\152\230\150\151\229\189\162\229\138\191")
  },
  {
    icon = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_botroad.png",
    title = T("\228\184\139\232\183\175\230\136\152\230\150\151\229\189\162\229\138\191")
  }
}
local selfFont = "guild_clash_name_self"
local oppoFont = "guild_clash_name_oppo"

function GuildClashBattleInfoWin:initData(params)
  self.mgr = ed.GuildClashManager
  self.lineId = params.lineId or 1
  self.teamsData = self.mgr.teamList[self.lineId]
  self.curBattle = params.curBattle
  self.team1Left = 0
  self.team2Left = 0
  self.team1Count = 0
  self.team2Count = 0
  self.tabIndex = 1
  if self.mgr.campId == 2 then
    selfFont = "guild_clash_name_oppo"
    oppoFont = "guild_clash_name_self"
  end
  ed.GuildClashNetwork:sendQueryLine(self.lineId)
end

function GuildClashBattleInfoWin:initLabels()
  self.ui.camp1:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.camp1, ed.toccc3(3370305), 1)
  self.ui.camp2:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.camp2, ed.toccc3(8141875), 1)
  self.ui.name_camp1:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.name_camp1, ed.toccc3(2382393), 1)
  self.ui.name_camp2:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.name_camp2, ed.toccc3(9123633), 1)
  ed.setLabelStroke(self.ui.title, ed.toccc3(4666403), 1)
  ed.setLabelStroke(self.ui.label_tab1, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.label_tab1_selected, ed.toccc3(6305310), 1)
  ed.setLabelStroke(self.ui.label_tab2, ed.toccc3(1578519), 1)
  ed.setLabelStroke(self.ui.label_tab2_selected, ed.toccc3(6305310), 1)
end

function GuildClashBattleInfoWin:getCancelPressInHandler()
  local function handler(x, y)
  end
  
  return handler
end

function GuildClashBattleInfoWin:getPressInHandler()
  local function handler(x, y)
    for k, item in ipairs(self.uiList or {}) do
      if item.type == "battle" or item.type == "curBattle" then
        local ui = item.ui
        
        if ed.containsPoint(ui.open, x, y) or ui.bg_bottom:isVisible() and ed.containsPoint(ui.btn_replay, x, y) then
          return item
        end
      end
    end
  end
  
  return handler
end

function GuildClashBattleInfoWin:onClickReplay(item)
  local replayData = self.mgr.replayList[item.data._replay_id]
  if replayData then
    if item.type == "curBattle" then
      self.mgr.enterReplay(replayData, true)
    else
      self.mgr.enterReplay(replayData, false)
    end
  end
end

function GuildClashBattleInfoWin:onCloseDetailPanel(item)
  item.ui.bg_bottom:setVisible(false)
  item.ui.open:setScaleY(1)
  self:doMoveUpAction(item, 57)
end

function GuildClashBattleInfoWin:onOpenDetailPanel(item)
  item.ui.bg_bottom:setVisible(true)
  item.ui.open:setScaleY(-1)
  self:doMoveDownAction(item, 57)
end

function GuildClashBattleInfoWin:onClickDetail(item)
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

function GuildClashBattleInfoWin:getClickInHandler()
  local function handler(x, y, item)
    if not item then
      return
    end
    local ui = item.ui
    if ed.containsPoint(ui.btn_replay, x, y) then
      self:onClickReplay(item)
      return
    end
    if ed.containsPoint2(ui.open, x, y, 1.3) then
      self:onClickDetail(item)
    end
  end
  
  return handler
end

function GuildClashBattleInfoWin:getResultRes(battle)
  local res = {
    "icon_lose",
    "icon_win",
    "icon_win1",
    "icon_win2",
    "icon_win3"
  }
  local idx = 1
  if battle._win_camp == self.mgr.campId then
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
  return ed.createSprite(string.format("UI/alpha/1080P/guild/guild_clash_fightshow/%s.png", res[idx]))
end

function GuildClashBattleInfoWin:createBattle(data, isCur)
  local container, ui = ed.editorui(ed.uieditor.GuildClashBattleItem)
  ui.camp1:setCascadeOpacityEnabled(true)
  ui.camp2:setCascadeOpacityEnabled(true)
  local userSummary1 = self.mgr:getUserSummary(data._team1._uid, 1)
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
  local userSummary2 = self.mgr:getUserSummary(data._team2._uid, 2)
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

function GuildClashBattleInfoWin:createDarkFightItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashDarkFightItem)
  ui.bg:setCascadeOpacityEnabled(true)
  local summary = self.mgr:getUserSummary(data._uid, 2)
  local head = ed.getWholeHeadIcon({
    id = summary._avatar,
    name = summary._name,
    medal = summary._medal,
    scale = 0.4,
    no_name_bg = true,
    config = {namefont = oppoFont, nameposition = -22}
  })
  ui.bg:addChild(head)
  head:setPosition(ccp(100, 21))
  return container, ui
end

function GuildClashBattleInfoWin:createNatureFightItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashNatureFightItem)
  ui.bg:setCascadeOpacityEnabled(true)
  local summary = self.mgr:getUserSummary(data._uid, 1)
  local head = ed.getWholeHeadIcon({
    id = summary._avatar,
    name = summary._name,
    medal = summary._medal,
    scale = 0.4,
    no_name_bg = true,
    config = {namefont = selfFont, nameposition = -22}
  })
  ui.bg:addChild(head)
  head:setPosition(ccp(100, 21))
  return container, ui
end

function GuildClashBattleInfoWin:refreshDraglistHistory(oldPos)
  local oldY = 0
  if oldPos then
    oldY = self.draglist.listLayer:getPositionY()
  end
  self.draglist:clearList()
  local contentSize = self.ui.layer_item:getContentSize()
  local ox, oy = 0, contentSize.height
  local data = (self.lineBattle or {})._battle or {}
  local itemHeight = 42
  self.uiList = {}
  self.darkTeamUI = {}
  self.natureTeamUI = {}
  for k, v in ipairs(data) do
    local container, ui = self:createBattle(v)
    local y = oy - k * itemHeight
    container:setPosition(ccp(0, y))
    self.draglist:addItem(container)
    local item = {
      ui = ui,
      container = container,
      data = v,
      type = "battle"
    }
    table.insert(self.uiList, item)
  end
  self.draglist:initListHeight(#data * itemHeight + 2)
  if oldPos then
    self.draglist.listLayer:setPositionY(oldY)
  end
end

function GuildClashBattleInfoWin:createCurBattle(oy)
  if self.curBattle then
    local container, ui = self:createBattle(self.curBattle, true)
    local item = {
      ui = ui,
      container = container,
      data = self.curBattle,
      type = "curBattle"
    }
    container:setPosition(0, oy - 42)
    self.draglist:addItem(container)
    table.insert(self.uiList, item)
    oy = oy - 42
  end
  return oy
end

function GuildClashBattleInfoWin:createTipLabel(oy)
  local labelTip = ed.createttf(T("\229\190\133\230\136\152\233\152\159\228\188\141:"), 16)
  labelTip:setPosition(350, oy - 15)
  local item = {container = labelTip, type = "labelTip"}
  table.insert(self.uiList, item)
  self.draglist:addItem(labelTip)
  oy = oy - 30
  return oy
end

function GuildClashBattleInfoWin:createCamp2Teams(oy)
  local itemHeight = 42
  local team2 = self.teamsData._team2 or {}
  local totalTeam = #team2
  for i = 1, self.team2Left do
    local data = team2[totalTeam - self.team2Left + i]
    if data then
      local container, ui = self:createDarkFightItem(data)
      container:setPosition(920, oy - itemHeight / 2)
      local sequence = CCSequence:create(ccArrayMake({
        CCDelayTime:create(i * 0.03),
        CCEaseSineIn:create(CCMoveBy:create(0.3, ccp(-400, 0)))
      }))
      container:runAction(sequence)
      self.draglist:addItem(container)
      local item = {
        ui = ui,
        container = container,
        data = data,
        type = "camp2Team"
      }
      table.insert(self.darkTeamUI, item)
      oy = oy - itemHeight
    end
  end
end

function GuildClashBattleInfoWin:createCamp1Teams(oy)
  local itemHeight = 42
  local team1 = self.teamsData._team1 or {}
  local totalTeam = #team1
  for i = 1, self.team1Left do
    local data = team1[totalTeam - self.team1Left + i]
    if data then
      local container, ui = self:createNatureFightItem(data)
      container:setPosition(-228, oy - itemHeight / 2)
      local sequence = CCSequence:create(ccArrayMake({
        CCDelayTime:create(i * 0.03),
        CCEaseSineIn:create(CCMoveBy:create(0.3, ccp(400, 0)))
      }))
      container:runAction(sequence)
      self.draglist:addItem(container)
      local item = {
        ui = ui,
        container = container,
        data = data,
        type = "camp1Team"
      }
      table.insert(self.natureTeamUI, item)
      oy = oy - itemHeight
    end
  end
end

function GuildClashBattleInfoWin:refreshDraglist()
  self.draglist:clearList()
  local contentSize = self.ui.layer_item:getContentSize()
  local oy = contentSize.height
  self.uiList = {}
  self.darkTeamUI = {}
  self.natureTeamUI = {}
  oy = self:createCurBattle(oy)
  oy = self:createTipLabel(oy)
  self:createCamp2Teams(oy)
  self:createCamp1Teams(oy)
  self.draglist:initListHeight(contentSize.height - oy + math.max(self.team1Left, self.team2Left) * 42)
end

function GuildClashBattleInfoWin:refreshGuildSummary()
  local selfSummary = self.mgr.selfGuildSummary._guild_summary
  local oppoSummary = self.mgr.oppoGuildSummary._guild_summary
  local selfAvatarData = ed.analyzeAvatar(selfSummary._avatar)
  local selfGuildIcon = ed.createGuildAvatar(selfAvatarData.avatar, selfAvatarData.avatarFrame)
  local oppoAvatarData = ed.analyzeAvatar(oppoSummary._avatar)
  local oppoGuildIcon = ed.createGuildAvatar(oppoAvatarData.avatar, oppoAvatarData.avatarFrame)
  if self.mgr.campId == 1 then
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

function GuildClashBattleInfoWin:playEnterAction()
  self.ui.Panel_2189:setClipRect(CCRectMake(0, 0, 700, 95))
  local lx = self.ui.left:getPositionX()
  local ly = self.ui.right:getPositionX()
  self.ui.left:setPositionX(lx - 400)
  self.ui.right:setPositionX(ly + 400)
  self.ui.icon_vs:setVisible(false)
  self.ui.left:runAction(CCEaseSineIn:create(CCMoveBy:create(0.2, ccp(400, 0))))
  self.ui.right:runAction(CCEaseSineIn:create(CCMoveBy:create(0.2, ccp(-400, 0))))
  self.ui.icon_vs:runAction(CCSequence:create(ccArrayMake({
    CCDelayTime:create(0.2),
    CCCallFunc:create(function()
      self.ui.icon_vs:setScale(2)
      self.ui.icon_vs:setVisible(true)
    end),
    CCEaseSineIn:create(CCScaleTo:create(0.2, 0.9)),
    CCEaseSineOut:create(CCScaleTo:create(0.1, 1))
  })))
end

function GuildClashBattleInfoWin:initUI()
  ed.editorui(ed.uieditor.GuildClashBattleInfoWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
  ed.setTexture(self.ui.icon, lineConfig[self.lineId].icon)
  ed.setString(self.ui.title, lineConfig[self.lineId].title)
  self.ui.title:limitWidthByScale(130)
  self.ui.label_tab1:limitWidthByScale(80)
  self.ui.label_tab1_selected:limitWidthByScale(80)
  self.ui.label_tab2:limitWidthByScale(80)
  self.ui.label_tab2_selected:limitWidthByScale(80)
  self:refreshGuildSummary()
  self:playEnterAction()
end

function GuildClashBattleInfoWin:refreshUI()
  ed.setString(self.ui.camp1_teams, string.format(T("\229\137\169\228\189\153\233\152\159\228\188\141:%d/%d"), self.team1Left, self.team1Count))
  ed.setString(self.ui.camp2_teams, string.format(T("\229\137\169\228\189\153\233\152\159\228\188\141:%d/%d"), self.team2Left, self.team2Count))
  if self.tabIndex == 1 then
    self:refreshDraglist()
  elseif self.tabIndex == 2 then
    self:refreshDraglistHistory()
  end
end

function GuildClashBattleInfoWin:playTeamAction(campId)
  local campTeams = campId == 1 and self.natureTeamUI or self.darkTeamUI
  local firstTeam = campTeams[1]
  if firstTeam then
    firstTeam.ui.bg:runAction(CCSequence:createWithTwoActions(CCSpawn:create(ccArrayMake(CCFadeOut:create(0.3), CCMoveBy:create(0.3, ccp(0, 70)))), CCCallFunc:create(function()
      firstTeam.container:removeAllChildrenWithCleanup(true)
    end)))
    table.remove(campTeams, 1)
    for k, v in ipairs(campTeams) do
      v.container:runAction(CCMoveBy:create(0.3, ccp(0, 42)))
    end
  end
end

function GuildClashBattleInfoWin:refreshTeamAction(camp1, camp2)
  if camp1 then
    self.team1Left = self.team1Left - 1
    ed.setString(self.ui.camp1_teams, string.format(T("\229\137\169\228\189\153\233\152\159\228\188\141:%d/%d"), self.team1Left, self.team1Count))
    self:playTeamAction(1)
  end
  if camp2 then
    self.team2Left = self.team2Left - 1
    ed.setString(self.ui.camp2_teams, string.format(T("\229\137\169\228\189\153\233\152\159\228\188\141:%d/%d"), self.team2Left, self.team2Count))
    self:playTeamAction(2)
  end
end

function GuildClashBattleInfoWin:playCamp1WinAction(item, battle)
  local ui = item.ui
  local ox, oy = ui.camp2:getPosition()
  ui.icon_result:setVisible(false)
  ui.camp1:runAction(CCSequence:create(ccArrayMake({
    CCMoveBy:create(0.1, ccp(-30, 0)),
    CCEaseSineIn:create(CCMoveBy:create(0.2, ccp(50, 0))),
    CCMoveBy:create(0.1, ccp(-20, 0))
  })))
  ui.camp2:runAction(CCSequence:create(ccArrayMake({
    CCDelayTime:create(0.2),
    CCSpawn:create(ccArrayMake({
      CCEaseSineOut:create(CCMoveBy:create(0.3, ccp(200, 0))),
      CCFadeOut:create(0.3)
    })),
    CCCallFunc:create(function()
      ui.camp2:setPosition(ccp(ox, oy - 70))
      local userSummary2 = self.mgr:getUserSummary(battle._team2._uid, 2)
      local user2Head = ed.getWholeHeadIcon({
        id = userSummary2._avatar,
        name = userSummary2._name,
        medal = userSummary2._medal,
        scale = 0.4,
        no_name_bg = true,
        config = {namefont = oppoFont, nameposition = -28}
      })
      ed.UITool.replaceUI(ui, "camp2", "name_camp2", user2Head)
      self:refreshTeamAction(false, true)
    end),
    CCSpawn:create(ccArrayMake({
      CCMoveTo:create(0.3, ccp(ox, oy)),
      CCFadeIn:create(0.3)
    })),
    CCCallFunc:create(function()
      ui.icon_result:setVisible(true)
    end)
  })))
end

function GuildClashBattleInfoWin:playCamp2WinAction(item, battle)
  local ui = item.ui
  local sx, sy = ui.camp1:getPosition()
  ui.icon_result:setVisible(false)
  ui.camp2:runAction(CCSequence:create(ccArrayMake({
    CCMoveBy:create(0.1, ccp(30, 0)),
    CCEaseSineIn:create(CCMoveBy:create(0.2, ccp(-50, 0))),
    CCMoveBy:create(0.1, ccp(20, 0))
  })))
  ui.camp1:runAction(CCSequence:create(ccArrayMake({
    CCDelayTime:create(0.2),
    CCSpawn:create(ccArrayMake({
      CCEaseSineOut:create(CCMoveBy:create(0.3, ccp(-200, 0))),
      CCFadeOut:create(0.3)
    })),
    CCCallFunc:create(function()
      ui.camp1:setPosition(ccp(sx, sy - 70))
      local userSummary1 = self.mgr:getUserSummary(battle._team1._uid, 1)
      local user1Head = ed.getWholeHeadIcon({
        id = userSummary1._avatar,
        name = userSummary1._name,
        medal = userSummary1._medal,
        scale = 0.4,
        no_name_bg = true,
        config = {namefont = selfFont, nameposition = -28}
      })
      ed.UITool.replaceUI(ui, "camp1", "name_camp1", user1Head)
      self:refreshTeamAction(true, false)
    end),
    CCSpawn:create(ccArrayMake({
      CCMoveTo:create(0.3, ccp(sx, sy)),
      CCFadeIn:create(0.3)
    })),
    CCCallFunc:create(function()
      ui.icon_result:setVisible(true)
    end)
  })))
end

function GuildClashBattleInfoWin:battleRefreshAction(item, battle)
  local winCamp = item.data._win_camp
  local ui = item.ui
  local actions = {}
  if winCamp == 1 then
    self:playCamp1WinAction(item, battle)
  else
    self:playCamp2WinAction(item, battle)
  end
end

function GuildClashBattleInfoWin:insertBattleTeamsAction(item)
  self:doMoveDownAction(item, 42)
end

function GuildClashBattleInfoWin:removeBattleTeamsAction(item)
  local dy = 42
  if item.ui.bg_bottom:isVisible() then
    dy = 99
  end
  self:doMoveUpAction(item, dy)
end

function GuildClashBattleInfoWin:handleBattle(battle)
  if not self.lineBattle then
    return
  end
  if self.curBattle then
    table.insert(self.lineBattle._battle, 1, self.curBattle)
  end
  if self.tabIndex == 2 then
    self.curBattle = battle
    for k, v in ipairs(self.uiList or {}) do
      v.container:runAction(CCMoveBy:create(0.3, ccp(0, -42)))
    end
    local container, ui = self:createBattle(battle)
    local y = self.ui.layer_item:getContentSize().height - 42
    container:setPosition(ccp(0, y))
    self.draglist:addItem(container)
    self.draglist:initListHeight(self.draglist.listHeight + 42)
    local item = {
      ui = ui,
      container = container,
      data = battle,
      type = "battle"
    }
    table.insert(self.uiList, 1, item)
  else
    local contentSize = self.ui.layer_item:getContentSize()
    local oy = contentSize.height
    if not self.curBattle then
      self.curBattle = battle
      ed.GuildClashNetwork:sendQueryLine(self.lineId)
    else
      self.curBattle = battle
      for k, v in ipairs(self.uiList) do
        if v.type == "curBattle" then
          v.data = battle
          if v.ui.bg_bottom:isVisible() then
            self:onCloseDetailPanel(v)
            v.container:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCCallFunc:create(function()
              self:battleRefreshAction(v, battle)
            end))))
          else
            self:battleRefreshAction(v, battle)
          end
        end
      end
    end
  end
end

function GuildClashBattleInfoWin:handleSummary(summary)
  table.insert(self.lineBattle._battle, 1, self.curBattle)
  self.curBattle = nil
  if self.tabIndex == 2 then
    self:refreshDraglistHistory(true)
  else
    for k, v in ipairs(self.uiList or {}) do
      if v.type == "curBattle" then
        self:removeBattleTeamsAction(v)
        v.container:runAction(CCSequence:create(ccArrayMake(CCSpawn:create(ccArrayMake(CCFadeOut:create(0.3), CCMoveBy:create(0.3, ccp(300, 0)))), CCCallFunc:create(function()
          v.container:removeFromParentAndCleanup(true)
        end))))
        table.remove(self.uiList, k)
      end
    end
  end
  ed.showToast(T("\232\175\165\229\136\134\232\183\175\230\136\152\230\150\151\229\183\178\231\187\147\230\157\159"))
end

function GuildClashBattleInfoWin:handleEvent(event)
  if event._type == "battle" then
    local data = event._battle_data
    if data._line_id == self.lineId then
      self:handleBattle(data)
    end
  elseif event._type == "summary" then
    local data = event._summary_data
    if data._battle_summarys and data._battle_summarys._line_id == self.lineId then
      self:handleSummary(data)
    end
  end
end

function GuildClashBattleInfoWin:doMoveUpAction(item, dy)
  for k, v in ipairs(self.uiList or {}) do
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
  self.draglist:initListHeight(self.draglist.listHeight - dy)
end

function GuildClashBattleInfoWin:doMoveDownAction(item, dy)
  for k, v in ipairs(self.uiList) do
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
  local x, y = self.draglist:getListPos()
  self.draglist:initListHeight(self.draglist.listHeight + dy)
  self.draglist:setListPos(ccp(x, y))
end

function GuildClashBattleInfoWin:initBattlePanelHero(item, replayData)
  local ui = item.ui
  local camp1Hero = replayData._camp1_heroes
  local camp2Hero = replayData._camp2_heroes
  local camp1Dyna = replayData._camp1_hero_dynas
  local camp2Dyna = replayData._camp2_hero_dynas
  for k = 1, 5 do
    local v = camp1Hero[k]
    if v then
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
    else
      ui["camp1_hero" .. k]:setVisible(false)
    end
  end
  for k = 1, 5 do
    local v = camp2Hero[k]
    if v then
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
    else
      ui["camp2_hero" .. k]:setVisible(false)
    end
  end
end

function GuildClashBattleInfoWin:handleReplay()
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

function GuildClashBattleInfoWin:registerEvents()
  self:listenEvent("GuildClashQueryLineBattle", function(data)
    self.lineBattle = data._line_battle or {}
    self.team1Left = self.lineBattle._team1_left
    self.team1Count = self.lineBattle._team1_count
    self.team2Left = self.lineBattle._team2_left
    self.team2Count = self.lineBattle._team2_count
    self.lineBattle._battle = self.lineBattle._battle or {}
    self:refreshUI()
  end)
  self:listenEvent("GuildClashBattleEventPop", function(event)
    self:handleEvent(event)
  end)
  self:listenEvent("GuildClashQueryReplay", function()
    self:handleReplay()
  end)
end

function GuildClashBattleInfoWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "tab1", function()
    if self.tabIndex == 1 then
      return
    end
    self.tabIndex = 1
    self.ui.tab1_selected:setVisible(true)
    self.ui.tab2_selected:setVisible(false)
    self:refreshDraglist()
  end)
  ed.UITool.registerBtn(self, "tab2", function()
    if self.tabIndex == 2 then
      return
    end
    self.tabIndex = 2
    self.ui.tab1_selected:setVisible(false)
    self.ui.tab2_selected:setVisible(true)
    self:refreshDraglistHistory()
  end)
  ed.UITool.registerBtn(self, "btn_back", function()
    FireEvent("GuildClashCloseBattleInfo")
    self:destroy()
  end, {pressScale = 0.66, normalScale = 0.7})
end

function GuildClashBattleInfoWin.create(data)
  local self = base.create("GuildClashBattleInfoWin")
  setmetatable(self, GuildClashBattleInfoWin.mt)
  self:initData(data)
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
