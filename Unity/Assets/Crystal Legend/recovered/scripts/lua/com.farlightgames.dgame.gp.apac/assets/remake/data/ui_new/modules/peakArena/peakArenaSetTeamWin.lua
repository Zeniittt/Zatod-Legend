local base = ed.ui.popwindow
local PeakArenaSetTeamWin = newclass(base.mt)
ed.ui.PeakArenaSetTeamWin = PeakArenaSetTeamWin
local SetTeamMode = {
  HideHero = "HideHero",
  SwitchTeam = "SwitchTeam",
  AdjustTeam = "AdjustTeam"
}

function PeakArenaSetTeamWin.create(lineups)
  local self = base.create("PeakArenaSetTeamWin")
  setmetatable(self, PeakArenaSetTeamWin.mt)
  self:initData(lineups)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:registerOnEnterHandler("OnEnter", function()
    self:refreshUI()
  end)
  return self
end

function PeakArenaSetTeamWin:initData(lineups)
  self.mgr = ed.PeakArenaManager
  lineups = lineups or {}
  for i = 1, self.mgr.maxLineupAmount do
    local lineup = lineups[i] or ed.commonmsg.peak_arena_lineup()
    lineup._hero_ids = lineup._hero_ids or {}
    lineup._hidden = lineup._hidden or {}
    for j = 1, 5 do
      lineup._hidden[j] = lineup._hidden[j] or 0
    end
    lineups[i] = lineup
  end
  self.lineups = lineups
  self.curMode = nil
  self.modifyFlag = false
  self.heroIconUI = {}
  self.maxHideTotal = ed.getDataTable("PeakArenaConfig")["Max Hide Total"].Value[1]
  self.maxHideEveryTeam = ed.getDataTable("PeakArenaConfig")["Max Hide Every Team"].Value[1]
end

function PeakArenaSetTeamWin:initUI()
  ed.editorui(ed.uieditor.TopArenaSetTeamWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelShadow(self.ui.Label_913, ccc3(0, 0, 0), ccp(1, 1))
  self.ui.Label_913:limitWidthByScale(110)
  ed.setLabelShadow(self.ui.Label_914, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.Label_4170, ccc3(0, 0, 0), ccp(1, 1))
  if self:isInCD() then
    ed.setString(self.ui.label_tip, string.format(T("%d\231\167\146\229\144\142\230\137\141\229\143\175\232\174\190\231\189\174\233\152\178\229\174\136\233\152\181\229\174\185"), self.mgr.setLineupCD - ed.getServerTime()))
  end
  self.container:setScale(0.9)
  ed.left2(self.ui.ImageView_2121, self.ui.title, 8)
  ed.right2(self.ui.ImageView_2122, self.ui.title, 8)
  ed.setLabelStroke(self.ui.label_team1, ed.toccc3(11954462), 1)
  ed.setLabelStroke(self.ui.label_team2, ed.toccc3(3890862), 1)
  ed.setLabelStroke(self.ui.label_team3, ed.toccc3(12273222), 1)
  ed.setLabelStroke(self.ui.label_team4, ed.toccc3(6098306), 1)
  ed.setLabelStroke(self.ui.label_team5, ed.toccc3(1921631), 1)
  ed.setLabelFontName(self.ui.label_team1, ed.fontBold)
  ed.setLabelFontName(self.ui.label_team2, ed.fontBold)
  ed.setLabelFontName(self.ui.label_team3, ed.fontBold)
  ed.setLabelFontName(self.ui.label_team4, ed.fontBold)
  ed.setLabelFontName(self.ui.label_team5, ed.fontBold)
  ed.adaptLabel(self.ui.label_team1, {maxWidth = 48, minScale = 0.5})
  ed.adaptLabel(self.ui.label_team2, {maxWidth = 48, minScale = 0.5})
  ed.adaptLabel(self.ui.label_team3, {maxWidth = 48, minScale = 0.5})
  ed.adaptLabel(self.ui.label_team4, {maxWidth = 48, minScale = 0.5})
  ed.adaptLabel(self.ui.label_team5, {maxWidth = 48, minScale = 0.5})
  if self.mgr.maxLineupAmount > 3 then
    local size = self.ui.Panel_item:getContentSize()
    self.ui.Panel_item:setClipRect(CCRectMake(0, 0, size.width * 0.9, size.height * 0.9))
    local container = self.ui.Panel_item
    local posy, old = 0, 0
    container:registerScriptTouchHandler(function(event, x, y)
      if event == "began" then
        posy = y
        old = self.ui.item_layer:getPositionY()
        self.ui.item_layer:stopAllActions()
        return ed.containsPoint(self.ui.Panel_item, x, y)
      elseif event == "moved" then
        self.ui.item_layer:setPositionY(old - (posy - y))
      elseif event == "ended" then
        local new = self.ui.item_layer:getPositionY()
        if new < 0 then
          self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
        elseif 190 < new then
          self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 190))))
        elseif math.abs(old - new) > 5 then
          self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, 0 < posy - y and -30 or 30))))
        end
      end
    end, false, -300, false)
    container:setTouchEnabled(true)
  else
    self.ui.ImageView_16957:setVisible(false)
    self.ui.team4:setVisible(false)
    self.ui.team5:setVisible(false)
    ed.UITool.setPositionBy(self.ui.item_layer, ccp(0, -20))
  end
end

function PeakArenaSetTeamWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickClose()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "button_hide", function()
    self:onClickHide()
  end, {pressScale = 0.9})
  for i = 1, self.mgr.maxLineupAmount do
    ed.UITool.registerBtn(self, "button_switch" .. i, function()
      self:onClickSwitch(i)
    end, {pressScale = 0.9})
    ed.UITool.registerBtn(self, "button_switch_save" .. i, function()
      self:onClickSwitchSave(i)
    end, {pressScale = 0.9})
  end
  ed.UITool.registerBtn(self, "button_adjust", function()
    self:onClickAdjust()
  end, {pressScale = 0.9})
  self.ui.btn_star:setVisible(#ed.PeakArenaManager.seasonBuffs > 0)
  ed.UITool.registerBtn(self, "btn_star", function()
    ed.ui.peakArenaStarWin.create()
  end, {pressScale = 0.9})
end

function PeakArenaSetTeamWin:registerEvents()
  self:listenEvent("PeakArenaSetDefendTeam", function(data)
    self:setDefendTeam(data)
  end)
  self:listenTimer(Timer:Always(1), function()
    if self.curMode then
      return
    end
    if self:isInCD() then
      local time = self.mgr.setLineupCD - ed.getServerTime()
      ed.setString(self.ui.label_tip, string.format(T("%d\231\167\146\229\144\142\230\137\141\229\143\175\232\174\190\231\189\174\233\152\178\229\174\136\233\152\181\229\174\185"), time))
    else
      ed.setString(self.ui.label_tip, "")
      self.ui.button_hide:setVisible(true)
      self.ui.button_adjust:setVisible(true)
    end
  end)
end

function PeakArenaSetTeamWin:isInCD()
  return self.mgr.setLineupCD > ed.getServerTime()
end

function PeakArenaSetTeamWin:getTeamHiddenCount(teamIndex)
  local count = 0
  for i = 1, 5 do
    if self:isHidden(teamIndex, i) then
      count = count + 1
    end
  end
  return count
end

function PeakArenaSetTeamWin:doHide(data)
  local teamIndex = data.teamIndex
  local heroIndex = data.heroIndex
  print(teamIndex, heroIndex)
  local isHidden = self:isHidden(teamIndex, heroIndex)
  if isHidden then
    self:setHidden(teamIndex, heroIndex, false)
    self.curHideHeroNum = self.curHideHeroNum - 1
  elseif self.curHideHeroNum >= self.maxHideTotal then
    ed.showToast(T("\230\137\128\230\156\137\233\152\159\228\188\141\229\133\177\228\186\171%s\228\184\170\233\154\144\232\151\143\228\189\141\231\189\174", self.maxHideTotal))
    return
  else
    if self:getTeamHiddenCount(teamIndex) >= self.maxHideEveryTeam then
      ed.showToast(T("\230\175\143\230\148\175\233\152\159\228\188\141\230\156\128\229\164\154\229\143\175\233\154\144\232\151\143%s\229\144\141\232\139\177\233\155\132", self.maxHideEveryTeam))
      return
    end
    self:setHidden(teamIndex, heroIndex, true)
    self.curHideHeroNum = self.curHideHeroNum + 1
  end
  self.modifyFlag = true
  self:refreshUI()
end

function PeakArenaSetTeamWin:getHeroId(teamIndex, heroIndex)
  return self.lineups[teamIndex]._hero_ids[heroIndex]
end

function PeakArenaSetTeamWin:setHeroId(teamIndex, heroIndex, heroId)
  self.lineups[teamIndex]._hero_ids[heroIndex] = heroId
end

function PeakArenaSetTeamWin:isHidden(teamIndex, heroIndex)
  return self.lineups[teamIndex]._hidden[heroIndex] == 1
end

function PeakArenaSetTeamWin:setHidden(teamIndex, heroIndex, isHidden)
  self.lineups[teamIndex]._hidden[heroIndex] = isHidden and 1 or 0
end

function PeakArenaSetTeamWin:setDefendTeam(data)
  local defendTeam = data.defendTeam
  for i = 1, self.mgr.maxLineupAmount do
    for j = 1, 5 do
      local heroId = defendTeam[i][j]
      self:setHeroId(i, j, heroId)
      self:setHidden(i, j, false)
    end
  end
  self.modifyFlag = true
  self:refreshUI()
end

function PeakArenaSetTeamWin:refreshUI()
  for k, v in ipairs(self.heroIconUI) do
    v:removeFromParentAndCleanup(true)
  end
  self.heroIconUI = {}
  self:initTeamUI()
end

function PeakArenaSetTeamWin:initTeamUI()
  for i = 1, self.mgr.maxLineupAmount do
    self:createTeam(i)
  end
  for k, v in ipairs(self.heroIconUI) do
    self:btRemoveMainTouchHandler({
      key = "icon" .. k
    })
    self:btRegisterButtonClick({
      button = v,
      key = "icon" .. k,
      force = true,
      clickHandler = function()
        if self.curMode == SetTeamMode.HideHero then
          self:doHide(v.data)
        end
      end
    })
  end
end

local PeakArenaSetTeamWin = ed.ui.PeakArenaSetTeamWin

function PeakArenaSetTeamWin:createHeroIcon(heroId, isHidden)
  local heroIconItem = ed.readhero.createIconByID(heroId, {
    state = "idle",
    isShowLegendEquip = ed.openLegendEquip()
  })
  heroIconItem:showLegendEquip(not ed.openLegendEquip())
  if isHidden then
    heroIconItem:addShade()
    local icon = heroIconItem.icon
    local iconHidden = ed.createSprite("UI/alpha/1080P/toparena/toparena_team_invisible.png")
    local size = icon:getContentSize()
    iconHidden:setPosition(ccp(size.width - 15, size.height - 15))
    icon:addChild(iconHidden, 10)
  end
  return heroIconItem.icon
end

function PeakArenaSetTeamWin:createTeam(teamIndex)
  local gs = 0
  table.sort(self.lineups[teamIndex]._hero_ids, function(a, b)
    return ed.readhero.getHeroMaxRange(a) < ed.readhero.getHeroMaxRange(b)
  end)
  local n = #self.lineups[teamIndex]._hero_ids + 1
  for i = 1, 5 do
    local heroId = self:getHeroId(teamIndex, i)
    if heroId then
      local heroIcon = self:createHeroIcon(heroId, self:isHidden(teamIndex, i))
      heroIcon:setPosition(ccp(145 + 83 * (n - i), 47))
      heroIcon.data = {teamIndex = teamIndex, heroIndex = i}
      self.ui["team" .. teamIndex]:addChild(heroIcon)
      table.insert(self.heroIconUI, heroIcon)
      gs = gs + ed.readhero.getHero(heroId)._gs
    end
  end
  self.ui["bg_gs" .. teamIndex]:removeAllChildrenWithCleanup(true)
  local number = ed.getNumberNode({
    text = gs,
    folder = "hero_gs",
    padding = -1
  }).node
  self.ui["bg_gs" .. teamIndex]:addChild(number)
  number:setPosition(ccp(52, 10))
end

function PeakArenaSetTeamWin:canChangeMode(targetMode)
  if self:isInCD() then
    return false, T("\232\191\152\229\156\168CD\228\184\173...")
  end
  if self.curMode and targetMode ~= self.curMode then
    if self.curMode == SetTeamMode.HideHero then
      return false, T("\233\156\128\229\133\136\228\191\157\229\173\152\229\189\147\229\137\141\233\154\144\232\151\143")
    elseif self.curMode == SetTeamMode.SwitchTeam then
      return false, T("\233\156\128\229\133\136\228\191\157\229\173\152\229\189\147\229\137\141\229\136\135\230\141\162")
    end
  end
  return true
end

function PeakArenaSetTeamWin:setHideHeroMode(flag)
  local canChangeMode, reason = self:canChangeMode(SetTeamMode.HideHero)
  if not canChangeMode then
    ed.showToast(reason)
    return
  end
  for i = 1, self.mgr.maxLineupAmount do
    self.ui["button_switch" .. i]:setVisible(not flag)
  end
  self.ui.button_adjust:setVisible(not flag)
  self.curMode = flag and SetTeamMode.HideHero or nil
  self.ui.button_hide_save:setVisible(flag)
  ed.setLabelColor(self.ui.label_tip, ccc3(255, 178, 57))
  ed.setString(self.ui.label_tip, flag and T("\231\130\185\229\135\187\232\139\177\233\155\132\229\164\180\229\131\143\232\174\190\231\189\174\233\154\144\232\151\143") or T(""))
  ed.setString(self.ui.Label_913, flag and T("\228\191\157\229\173\152\233\154\144\232\151\143") or T("\232\174\190\231\189\174\233\154\144\232\151\143"))
end

function PeakArenaSetTeamWin:onClickClose()
  if self.modifyFlag then
    local info = {
      text = T("\230\152\175\229\144\166\228\191\157\229\173\152\229\189\147\229\137\141\229\175\185\228\186\142\233\152\178\229\174\136\233\152\181\229\174\185\231\154\132\232\176\131\230\149\180\239\188\159"),
      leftHandler = function()
        self:destroy()
      end,
      rightHandler = function()
        if ed.PeakArenaManager:isSetLineup() then
          ed.PeakArenaNetwork:sendSetLineup(self.lineups)
          ed.PeakArenaManager:setDaychangeLineupTimes(ed.PeakArenaManager.daychangeLineupTimes + 1)
        else
          ed.showToast(T("\228\187\138\230\151\165\233\152\181\229\174\185\232\176\131\230\149\180\229\183\178\232\190\190\228\184\138\233\153\144"))
        end
        self:destroy()
      end
    }
    ed.showConfirmDialog(info)
  else
    self:destroy()
  end
end

function PeakArenaSetTeamWin:onClickHide()
  if self.curMode == SetTeamMode.HideHero then
    self:onClickHideSave()
    return
  end
  local canChangeMode, reason = self:canChangeMode(SetTeamMode.HideHero)
  if not canChangeMode then
    ed.showToast(reason)
    return
  end
  self:setHideHeroMode(true)
  local hideNum = 0
  for i = 1, self.mgr.maxLineupAmount do
    hideNum = hideNum + self:getTeamHiddenCount(i)
  end
  self.curHideHeroNum = hideNum
  self:refreshUI()
end

function PeakArenaSetTeamWin:onClickHideSave()
  self:setHideHeroMode(false)
  self:refreshUI()
end

function PeakArenaSetTeamWin:setSwitchTeamMode(flag)
  local canChangeMode, reason = self:canChangeMode(SetTeamMode.SwitchTeam)
  if not canChangeMode then
    ed.showToast(reason)
    return
  end
  self.curMode = flag and SetTeamMode.SwitchTeam or nil
  self.ui.button_adjust:setVisible(not flag)
  self.ui.button_hide:setVisible(not flag)
  if flag then
    for i = 1, self.mgr.maxLineupAmount do
      self.ui["button_switch" .. i]:setVisible(false)
      if i == self.switchSourceIndex then
        self.ui["team_choose" .. i]:setVisible(true)
      else
        self.ui["button_switch_save" .. i]:setVisible(true)
      end
    end
  else
    for i = 1, self.mgr.maxLineupAmount do
      self.ui["button_switch" .. i]:setVisible(true)
      self.ui["team_choose" .. i]:setVisible(false)
      self.ui["button_switch_save" .. i]:setVisible(false)
    end
  end
end

function PeakArenaSetTeamWin:onClickSwitch(index)
  self.switchSourceIndex = index
  self:setSwitchTeamMode(true)
end

function PeakArenaSetTeamWin:onClickSwitchSave(index)
  self:setSwitchTeamMode(false)
  local team = self.lineups[self.switchSourceIndex]
  self.lineups[self.switchSourceIndex] = self.lineups[index]
  self.lineups[index] = team
  if self.switchSourceIndex > 3 and 3 < index or self.switchSourceIndex <= 3 and index <= 3 then
  else
    for i = 1, 5 do
      self.lineups[self.switchSourceIndex]._hidden[i] = 0
      self.lineups[index]._hidden[i] = 0
    end
  end
  self.modifyFlag = true
  self.switchSourceIndex = nil
  self.curMode = nil
  self:refreshUI()
end

function PeakArenaSetTeamWin:onClickAdjust()
  local canChangeMode, reason = self:canChangeMode(SetTeamMode.AdjustTeam)
  if not canChangeMode then
    ed.showToast(reason)
    return
  end
  local heroes_defend = {}
  for i = 1, self.mgr.maxLineupAmount do
    table.insert(heroes_defend, ed.copyTable(self.lineups[i]._hero_ids))
  end
  ed.UITool.openView("PeakArenaPvpBattlePrepareScene", {
    mode = "defend",
    team_count = self.mgr.maxLineupAmount,
    heroes_defend = heroes_defend,
    baned_hero_id_list = self.mgr:getBanedHeroes()
  })
end
