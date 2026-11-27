local base = ed.ui.popwindow
local CupArenaOppoInfoWin = newclass(base.mt)
ed.ui.CupArenaOppoInfoWin = CupArenaOppoInfoWin
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

function CupArenaOppoInfoWin:initLabels()
  ed.setLabelStroke(self.ui.title, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_name, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_server_name, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_guild_name, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_score_val, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_camp, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_team_num, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_gs_tips, ed.toccc3(11821085), 1)
  self.ui.label_gs_tips:setFontName(ed.fontBold)
end

function CupArenaOppoInfoWin:createTeamItem(index, teamData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaOppoTeamItem)
  container:setContentSize(ui.bg_team:getContentSize())
  local uiConfig = TeamUIConfig[index]
  ed.setTexture(ui.bg_team, uiConfig.bgPath)
  ed.setLabelColor(ui.label_team, uiConfig.teamColor)
  ed.setLabelStroke(ui.label_team, uiConfig.teamStrokeColor, 1)
  ed.setString(ui.label_team, T("%s\233\152\159", index))
  ui.label_team:setFontName(ed.fontBold)
  local isNeedSort = true
  for _, heroData in ipairs(teamData._heroes or {}) do
    if nil == heroData._tid or 0 == heroData._tid then
      isNeedSort = false
    end
  end
  if isNeedSort then
    ed.readhero.sortIDByRange(teamData._heroes or {}, function(tab)
      return tab._tid
    end)
  end
  for i, v in ipairs(teamData._heroes or {}) do
    local icon
    if v._tid == 0 then
      icon = ed.ui.peakArenaUITool.createHideIcon()
      icon:setScale(0.72)
      icon:setPosition(ccp((i - 0.5) * 67, 30))
    else
      local heroInfo = ed.readhero.createIconByServer(v, {state = "idle"})
      icon = heroInfo.icon
      heroInfo:showLegendEquip(not ed.openLegendEquip())
      self:btRegisterButtonClick({
        button = icon,
        key = "icon" .. v._tid,
        clickHandler = function()
          ed.ui.checkOthersHeroWindow.create(v):popWindow()
        end,
        extraCheckHandler = function(x, y)
          if ed.containsPoint(self.ui.panel_team, x, y) then
            return true
          else
            return false
          end
        end,
        force = true
      })
      icon:setScale(0.8)
      icon:setPosition(ccp((i - 0.5) * 67, 30))
    end
    ui.panel_hero:addChild(icon)
  end
  return container, ui
end

function CupArenaOppoInfoWin:getPos(i)
  local size = self.ui.panel_team:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 76
  local itemSpace = 4
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaOppoInfoWin:getHeight(num)
  local itemHeight = 76
  local itemSpace = 4
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaOppoInfoWin:initUI(data)
  ed.editorui(ed.uieditor.CupArenaOppoInfoWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.label_server_name, data._server_name or "")
  local summary = data._summary
  local name = ed.getPlayerName(summary._name, summary._medal, {
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "bg_name", "label_name", name)
  ed.setString(self.ui.label_guild_name, summary._guild_name or "")
  ed.setString(self.ui.label_score_val, data._score)
  local campTableItem = ed.getDataTable("CupArenaCamp")[data._camp_id]
  ed.setLabelString(self.ui.label_camp, T("%s\233\152\181\232\144\165", campTableItem["Camp Name"]))
  ed.setTexture(self.ui.img_camp_icon, campTableItem["Camp Symbol Min"])
  local gradeTableInfo = ed.CupArenaManager:getGradeInfoByScore(data._score)
  ed.setTexture(self.ui.img_grade_name, gradeTableInfo.nameIconRes)
  local gsNode = ed.getNumberNode({
    text = data._gs or 0,
    folder = "hero_gs"
  }).node
  ed.UITool.replaceUI(self.ui, "bg_gs", "label_gs", gsNode)
  ed.right2(gsNode, self.ui.label_gs_tips, 20)
  local param = {
    id = summary._avatar,
    level = summary._level,
    lvoffset = {x = -47, y = -38}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(self.ui, "bg", "icon", head)
  local contentSize = self.ui.panel_team:getContentSize()
  local draglist = ed.UITool.createDraglist(self.ui.panel_team, {
    priority = -300,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(contentSize.width + 5, contentSize.height / 2),
      barres = "UI/alpha/1080P/hades/hades_main_slide.png",
      bgres = "UI/alpha/1080P/hades/hades_main_slide_bg.png",
      alwaysShow = true
    }
  })
  local teamNum = 0
  for i, v in ipairs(data._teams or {}) do
    local itemContainer, itemUI = self:createTeamItem(i, v)
    draglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i))
    teamNum = teamNum + 1
  end
  draglist:initListHeight(self:getHeight(teamNum))
  ed.setString(self.ui.label_team_num, T("\233\152\159\228\188\141\230\149\176\233\135\143\239\188\154%d", teamNum))
  self.ui.btn_battle:setVisible(nil ~= self.challengeRoleId)
  self.refreshCliprectConfig = {draglist = draglist}
end

function CupArenaOppoInfoWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:destroy()
    end,
    key = "clickout"
  })
  ed.UITool.registerBtn(self, "btn_battle", function()
    local roleId = self.challengeRoleId
    if nil == roleId then
      self:destroy({skipAnim = false})
    else
      self:destroy({skipAnim = true})
      FireEvent("EventCupArenaChallengeOppo", roleId)
    end
  end, {pressScale = 0.95})
end

function CupArenaOppoInfoWin.create(data, roleId)
  local self = base.create("CupArenaOppoInfoWin")
  setmetatable(self, CupArenaOppoInfoWin.mt)
  self.challengeRoleId = roleId
  self:initUI(data)
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end
