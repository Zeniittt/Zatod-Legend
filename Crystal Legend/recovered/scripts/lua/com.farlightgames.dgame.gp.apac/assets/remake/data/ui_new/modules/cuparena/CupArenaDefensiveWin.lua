local base = ed.ui.popwindow
local CupArenaDefensiveWin = newclass(base.mt)
ed.ui.CupArenaDefensiveWin = CupArenaDefensiveWin
local OperateMode = {
  HideHero = 1,
  SwitchTeam = 2,
  AdjustTeam = 3
}
local TeamUIConfig = {
  [1] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [4] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [5] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_5.png",
    teamColor = ed.toccc3(13625343),
    teamStrokeColor = ed.toccc3(2379449)
  },
  [6] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_6.png",
    teamColor = ed.toccc3(16776423),
    teamStrokeColor = ed.toccc3(7221115)
  },
  [7] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_7.png",
    teamColor = ed.toccc3(16514997),
    teamStrokeColor = ed.toccc3(8621085)
  }
}

function CupArenaDefensiveWin.create(data)
  local self = base.create("CupArenaDefensiveWin")
  setmetatable(self, CupArenaDefensiveWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function CupArenaDefensiveWin:initData(data)
  self.isKnockout = data.isKnockout
  self.teamDatas = {}
  for _, v in ipairs(data.lineups) do
    local heroArr = {}
    local hidden = v._hidden or {}
    for heroIndex, id in ipairs(v._hero_ids) do
      local hero = ed.player:getHero(id)
      if hero then
        table.insert(heroArr, {
          id = id,
          isHidden = not self.isKnockout and 1 == hidden[heroIndex],
          gs = hero._gs
        })
      end
    end
    ed.readhero.sortIDByRange(heroArr, function(tab)
      return tab.id
    end)
    table.insert(self.teamDatas, heroArr)
  end
  self.curMode = nil
  self.isModifyFlag = false
  self.switchSourceIndex = nil
end

function CupArenaDefensiveWin:initUI()
  ed.editorui(ed.uieditor.CupArenaDefensiveWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelShadow(self.ui.label_hide_tips, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.label_adjust, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(1, 1))
  ed.left2(self.ui.img_title_left, self.ui.title, 8)
  ed.right2(self.ui.img_title_right, self.ui.title, 8)
  self:refreshTeamListUI()
  self:setNewMode(nil)
  self:startTimer()
end

function CupArenaDefensiveWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickCloseEvent()
  end, {pressScale = 0.68, normalScale = 0.72})
  ed.UITool.registerBtn(self, "btn_hide", function()
    self:onClickHideEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_adjust", function()
    self:onClickAdjustEvent()
  end, {pressScale = 0.9})
end

function CupArenaDefensiveWin:registerEvents()
  self:listenEvent("EventBattlePrepareSetDefensiveTeam", function(data)
    self.teamDatas = {}
    for _, idArr in ipairs(data.defensiveTeams) do
      local heroArr = {}
      table.insert(self.teamDatas, heroArr)
      for _, id in ipairs(idArr) do
        local hero = ed.player:getHero(id)
        if hero then
          table.insert(heroArr, {
            id = id,
            isHidden = false,
            gs = hero._gs
          })
        end
      end
    end
    self.isModifyFlag = true
    self:refreshTeamListUI()
  end)
  self:listenEvent("EventCupArenaSetDefensiveLineup", function(data)
    if data._result == "success" then
      ed.showToast(T("\228\191\157\229\173\152\233\152\159\229\189\162\230\136\144\229\138\159"))
      local lineups = {}
      for _, heroArr in ipairs(self.teamDatas) do
        local lineup = ed.downmsg.cup_arena_team()
        table.insert(lineups, lineup)
        lineup._heroes = {}
        lineup._hidden = {}
        local team = ed.commonmsg.arena_team()
        table.insert(lineup._heroes, team)
        team._heroes = {}
        for _, heroItem in ipairs(heroArr) do
          table.insert(team._heroes, ed.player:getHero(heroItem.id).data)
          table.insert(lineup._hidden, heroItem.isHidden and 1 or 0)
        end
      end
      FireEvent("EventCupArenaRefreshDefensiveLineup", lineups)
    else
      ed.showToast(T("\228\191\157\229\173\152\233\152\159\229\189\162\229\164\177\232\180\165"))
    end
    self:destroy()
  end)
end

function CupArenaDefensiveWin:getPos(i)
  local size = self.ui.panel_team:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 100
  local itemSpace = 0
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaDefensiveWin:getHeight(num)
  local itemHeight = 100
  local itemSpace = 0
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaDefensiveWin:createTeamItem(index, heroArr)
  local container, ui = ed.editorui(ed.uieditor.CupArenaDefensiveItem)
  container:setContentSize(ui.bg:getContentSize())
  local uiConfig = TeamUIConfig[index]
  ed.setScale9SpriteTexture(ui.bg_img, uiConfig.bgPath)
  ui.bg_img:setContentSize(CCSizeMake(575, 76))
  ui.bg_img:setScale(1.22)
  ed.setLabelColor(ui.label_team, uiConfig.teamColor)
  ed.setLabelStroke(ui.label_team, uiConfig.teamStrokeColor, 1)
  ed.setString(ui.label_team, T("%s\233\152\159", index))
  ui.label_team:setFontName(ed.fontBold)
  ed.adaptLabel(ui.label_team, {maxWidth = 48, minScale = 0.5})
  ui.gsLabel = ed.getNumberNode({
    text = 0,
    folder = "hero_gs",
    padding = -1
  })
  ui.bg_gs:addChild(ui.gsLabel.node)
  ui.gsLabel.node:setPositionY(ui.bg_gs:getContentSize().height * 0.5)
  self:refreshTeamItem(ui, index, heroArr)
  return container, ui
end

function CupArenaDefensiveWin:refreshTeamItem(ui, index, heroArr)
  ui.index = index
  ui.panel_hero:removeAllChildrenWithCleanup(true)
  ui.heroUIArr = {}
  local totalGs = 0
  local posY = ui.panel_hero:getContentSize().height * 0.5
  local num = #heroArr
  for i, v in ipairs(heroArr) do
    local headIcon = ed.readhero.createIconByID(v.id, {
      state = "idle",
      isShowLegendEquip = ed.openLegendEquip()
    })
    headIcon:showLegendEquip(not ed.openLegendEquip())
    headIcon.icon:setScale(0.9)
    headIcon.icon:setPosition(ccp((num - i + 0.5) * 78, posY))
    if v.isHidden then
      headIcon:addShade()
      local iconHidden = ed.createSprite("UI/alpha/1080P/toparena/toparena_team_invisible.png")
      local iconSize = headIcon.icon:getContentSize()
      iconHidden:setPosition(ccp(iconSize.width - 15, iconSize.height - 15))
      headIcon.icon:addChild(iconHidden, 10)
    end
    ui.panel_hero:addChild(headIcon.icon)
    table.insert(ui.heroUIArr, headIcon)
    totalGs = totalGs + v.gs
  end
  ed.refreshNumberNode(ui.gsLabel, totalGs)
  ui.gsLabel.node:setPositionX(27 + ui.gsLabel.node:getContentSize().width * 0.5)
  return container, ui
end

function CupArenaDefensiveWin:getPressHander(...)
  return function(x, y)
    for _, cellUI in ipairs(self.teamUIArr) do
      if ed.containsPoint(cellUI.btn_change, x, y) then
        return cellUI, {type = 1}
      end
      if self.curMode == OperateMode.HideHero then
        for heroIndex, heroIcon in ipairs(cellUI.heroUIArr) do
          if ed.containsPoint(heroIcon.icon, x, y) then
            return cellUI, {type = 2, heroIndex = heroIndex}
          end
        end
      end
    end
  end
end

function CupArenaDefensiveWin:getClickHander(...)
  return function(x, y, cellUI, param)
    if 1 == param.type then
      if cellUI.btn_change:isVisible() and ed.containsPoint(cellUI.btn_change, x, y) then
        if self:isInLimitCD() then
          return
        end
        if nil == self.curMode then
          self.switchSourceIndex = cellUI.index
          self:setNewMode(OperateMode.SwitchTeam)
        else
          if nil ~= self.switchSourceIndex then
            local tmp = self.teamDatas[self.switchSourceIndex]
            self.teamDatas[self.switchSourceIndex] = self.teamDatas[cellUI.index]
            self.teamDatas[cellUI.index] = tmp
            self.isModifyFlag = true
            self:refreshTeamItem(self.teamUIArr[self.switchSourceIndex], self.switchSourceIndex, self.teamDatas[self.switchSourceIndex])
            self:refreshTeamItem(self.teamUIArr[cellUI.index], cellUI.index, self.teamDatas[cellUI.index])
          end
          self.switchSourceIndex = nil
          self:setNewMode(nil)
        end
      end
    elseif 2 == param.type then
      local heroIcon = cellUI.heroUIArr[param.heroIndex]
      if nil ~= heroIcon and ed.containsPoint(heroIcon.icon, x, y) then
        local heroArr = self.teamDatas[cellUI.index]
        if heroArr then
          if heroArr[param.heroIndex].isHidden then
            heroArr[param.heroIndex].isHidden = false
          else
            if 2 <= self:getTeamHiddenCount(heroArr) then
              ed.showToast(T("\230\175\143\233\152\159\230\156\128\229\164\154\229\143\175\232\174\190\231\189\174%d\228\184\170\228\189\141\231\189\174\233\154\144\232\151\143", 2))
              return
            end
            heroArr[param.heroIndex].isHidden = true
          end
          self.isModifyFlag = true
          self:refreshTeamItem(self.teamUIArr[cellUI.index], cellUI.index, self.teamDatas[cellUI.index])
        end
      end
    end
  end
end

function CupArenaDefensiveWin:getTeamHiddenCount(heroArr)
  local num = 0
  for i, v in ipairs(heroArr) do
    if v.isHidden then
      num = num + 1
    end
  end
  return num
end

function CupArenaDefensiveWin:refreshSwitchBtnUI()
  for _, cellUI in ipairs(self.teamUIArr) do
    cellUI.btn_change:setVisible(self.switchSourceIndex ~= cellUI.index)
    ed.setTexture(cellUI.btn_change, nil == self.switchSourceIndex and "UI/alpha/1080P/toparena/toparena_team_exchange2.png" or "UI/alpha/1080P/toparena/toparena_team_exchange1.png")
  end
end

function CupArenaDefensiveWin:refreshTeamListUI(...)
  if nil == self.ui.teamDraglist then
    self.ui.teamDraglist = ed.UITool.createDraglist(self.ui.panel_team, {
      doPressIn = self:getPressHander(),
      doClickIn = self:getClickHander(),
      priority = -300
    })
    self.teamUIArr = {}
    self.refreshCliprectConfig = {
      draglist = self.ui.teamDraglist
    }
  end
  local teamNum = 0
  for i, v in ipairs(self.teamDatas) do
    if i > #self.teamUIArr then
      local container, ui = self:createTeamItem(i, v)
      self.ui.teamDraglist:addItem(container)
      container:setPosition(self:getPos(i))
      table.insert(self.teamUIArr, ui)
    else
      self:refreshTeamItem(self.teamUIArr[i], i, v)
    end
    teamNum = teamNum + 1
  end
  self.ui.teamDraglist:initListHeight(self:getHeight(teamNum))
  for i = #self.teamUIArr, teamNum + 1, -1 do
    table.remove(self.teamUIArr, i)
    self.ui.teamDraglist:removeItemWithIndex(i)
  end
end

function CupArenaDefensiveWin:setNewMode(mode)
  self.curMode = mode
  self:refreshSwitchBtnUI()
  self.ui.btn_hide:setVisible(not self.isKnockout and (nil == self.curMode or OperateMode.HideHero == self.curMode or OperateMode.AdjustTeam == self.curMode))
  self.ui.btn_hide_save:setVisible(not self.isKnockout and OperateMode.HideHero == self.curMode)
  self.ui.btn_adjust:setVisible(nil == self.curMode or OperateMode.AdjustTeam == self.curMode)
  self.ui.btn_adjust:setPositionX(self.isKnockout and 398.5 or 491)
  self:updateTipsStr()
  ed.setString(self.ui.label_hide_tips, OperateMode.HideHero == self.curMode and T("\228\191\157\229\173\152\233\154\144\232\151\143") or T("\232\174\190\231\189\174\233\154\144\232\151\143"))
end

function CupArenaDefensiveWin:onClickCloseEvent()
  if self.isModifyFlag then
    local info = {
      text = T("\230\152\175\229\144\166\228\191\157\229\173\152\229\189\147\229\137\141\229\175\185\228\186\142\233\152\178\229\174\136\233\152\181\229\174\185\231\154\132\232\176\131\230\149\180\239\188\159"),
      leftHandler = function()
        self:destroy()
      end,
      rightHandler = function()
        if self.isKnockout then
          local scheduleTableItem = ed.getDataTable("CupArenaSchedule")[ed.CupArenaManager:getScheduleId()]
          if scheduleTableItem["State Type"] ~= "Prepare" then
            ed.showToast(T("\228\187\133\229\143\175\229\156\168\229\184\131\233\152\181\233\152\182\230\174\181\232\176\131\230\149\180\233\152\159\228\188\141"))
            self:destroy()
            return
          end
          ed.CupArenaNetwork:sendKnockoutSetDefensiveLineup(self.teamDatas)
        else
          ed.CupArenaNetwork:sendSetDefensiveLineup(self.teamDatas)
        end
      end
    }
    ed.showConfirmDialog(info)
  else
    self:destroy()
  end
end

function CupArenaDefensiveWin:onClickHideEvent()
  if self:isInLimitCD() then
    return
  end
  if self.curMode == OperateMode.HideHero then
    self:setNewMode(nil)
  elseif self.curMode == nil then
    self:setNewMode(OperateMode.HideHero)
  else
    ed.showToast(T("\233\156\128\229\133\136\228\191\157\229\173\152\229\189\147\229\137\141\230\147\141\228\189\156"))
  end
end

function CupArenaDefensiveWin:onClickAdjustEvent()
  if self:isInLimitCD() then
    return
  end
  if nil == self.curMode then
    local teamIDs = {}
    for _, heroArr in ipairs(self.teamDatas) do
      local idArr = {}
      table.insert(teamIDs, idArr)
      for _, item in ipairs(heroArr) do
        table.insert(idArr, item.id)
      end
    end
    local scene = ed.ui.CupArenaBattlePrepareScene.create({
      mode = "defend",
      requireNumPerTeam = self.isKnockout and 5 or 1,
      teamCount = self.isKnockout and ed.CupArenaManager.TeamCount.Knockout or ed.CupArenaManager.TeamCount.Audition,
      selfTeamIDs = teamIDs,
      uiConfig = {
        defendTitleStr = self.isKnockout and T("\232\174\190\231\189\174\229\183\133\229\179\176\232\181\155\233\152\181\229\174\185") or T("\232\174\190\231\189\174\233\152\178\229\174\136\233\152\181\229\174\185"),
        defendDesStr = self.isKnockout and T("\232\175\183\232\174\190\231\189\174\230\130\168\231\154\132\229\183\133\229\179\176\232\181\155\233\152\181\229\174\185\239\188\140\229\183\133\229\179\176\232\181\155\228\184\173\230\175\143\233\152\159\229\191\133\233\161\187\228\184\138\230\187\1615\229\144\141\232\139\177\233\155\132") or T("\232\175\183\232\174\190\231\189\174\230\130\168\231\154\132\229\165\179\231\165\158\228\185\139\230\136\152\233\152\178\229\174\136\233\152\181\229\174\185")
      }
    })
    ed.pushScene(scene)
  else
    ed.showToast(T("\233\156\128\229\133\136\228\191\157\229\173\152\229\189\147\229\137\141\230\147\141\228\189\156"))
  end
end

function CupArenaDefensiveWin:startTimer(...)
  self:listenTimer(Timer:Always(0.5), function()
    self:updateCountDownUI()
  end)
end

function CupArenaDefensiveWin:updateCountDownUI()
  self:updateTipsStr()
end

function CupArenaDefensiveWin:updateTipsStr()
  local cd = ed.CupArenaManager:getChangeLineupCD()
  if cd > ed.getServerTime() then
    ed.setLabelColor(self.ui.label_tip, ccc3(179, 204, 97))
    ed.setString(self.ui.label_tip, T("%d\231\167\146\229\144\142\230\137\141\229\143\175\232\174\190\231\189\174\233\152\178\229\174\136\233\152\181\229\174\185", cd - ed.getServerTime()))
  elseif OperateMode.HideHero == self.curMode then
    ed.setLabelColor(self.ui.label_tip, ccc3(255, 178, 57))
    ed.setString(self.ui.label_tip, T("\231\130\185\229\135\187\232\139\177\233\155\132\229\164\180\229\131\143\232\174\190\231\189\174\233\154\144\232\151\143"))
  else
    ed.setString(self.ui.label_tip, "")
  end
end

function CupArenaDefensiveWin:isInLimitCD()
  if ed.CupArenaManager:getChangeLineupCD() > ed.getServerTime() then
    ed.showToast(T("\232\191\152\229\156\168CD\228\184\173..."))
    return true
  end
  return false
end
