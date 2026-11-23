local base = ed.ui.popwindow
local CreviceDefendStatisticWin = newclass(base.mt)
ed.ui.CreviceDefendStatisticWin = CreviceDefendStatisticWin
local TeamUIConfig = {
  [1] = {
    bgPath = "UI/alpha/1080P/crevicedefend/recommendteam1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    bgPath = "UI/alpha/1080P/crevicedefend/recommendteam2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    bgPath = "UI/alpha/1080P/crevicedefend/recommendteam3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10234922)
  },
  [4] = {
    bgPath = "UI/alpha/1080P/crevicedefend/recommendteam4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10503958)
  },
  [5] = {
    bgPath = "UI/alpha/1080P/crevicedefend/recommendteam5.png",
    teamColor = ed.toccc3(13622015),
    teamStrokeColor = ed.toccc3(1260450)
  }
}

function CreviceDefendStatisticWin.create(data)
  local self = base.create("CreviceDefendStatisticWin")
  setmetatable(self, CreviceDefendStatisticWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function CreviceDefendStatisticWin:initData(data)
  self.teamArr = {}
  for i, v in ipairs(data._user_info or {}) do
    table.insert(self.teamArr, v)
  end
end

function CreviceDefendStatisticWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy({skipAnim = false})
  end, {
    pressScale = 0.76,
    normalScale = 0.8,
    clickInterval = 0.2
  })
  ed.UITool.registerBtn(self, "btn_board", function()
    local data = {}
    for i, v in ipairs(self.teamArr) do
      local ids = {}
      for _, hero in ipairs(v._heroes or {}) do
        table.insert(ids, hero._tid)
      end
      table.insert(data, ids)
    end
    FireEvent("CreviceDefendReCommendLineup", data)
    self:destroy({skipAnim = true})
  end, {pressScale = 0.95, clickInterval = 0.2})
end

function CreviceDefendStatisticWin:registerEvents()
end

function CreviceDefendStatisticWin:getPos(i)
  local size = self.ui.panel_team:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 66
  local itemSpace = 4
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CreviceDefendStatisticWin:getHeight(num)
  local itemHeight = 66
  local itemSpace = 4
  return (itemHeight + itemSpace) * num - itemSpace
end

function CreviceDefendStatisticWin:createTeamItem(index, teamData)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendStatisticItem)
  local uiConfig = TeamUIConfig[index]
  ed.setTexture(ui.bg_img, uiConfig.bgPath)
  ed.setLabelColor(ui.label_team, uiConfig.teamColor)
  ed.setLabelStroke(ui.label_team, uiConfig.teamStrokeColor, 1)
  ed.setLabelStroke(ui.label_damage_des, ed.toccc3(2564894), 1)
  ed.setString(ui.label_team, T("%s\233\152\159", index))
  ui.label_team:setFontName(ed.fontBold)
  local panelSize = ui.panel_hero:getContentSize()
  for i, v in ipairs(teamData._heroes or {}) do
    local heroInfo = ed.readhero.createIconByServer(v, {state = "idle"})
    local icon = heroInfo.icon
    heroInfo:showLegendEquip(false)
    icon:setScale(0.7)
    icon:setPosition(ccp((i - 0.5) * 62, panelSize.height * 0.5))
    ui.panel_hero:addChild(icon)
  end
  local damageLabel = ed.ui.gradientLabel.create({
    text = ed.formatDamage(teamData._damage),
    fontSize = 20,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(2564894)
  })
  ed.UITool.replaceUI(ui, "bg_img", "label_damage_num", damageLabel.node)
  return container, ui
end

function CreviceDefendStatisticWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendStatisticWin)
  self.ui = ui
  self.container:addChild(container)
  ed.left2(self.ui.img_title_left, self.ui.title, 20)
  ed.right2(self.ui.img_title_right, self.ui.title, 20)
  ed.setLabelShadow(self.ui.label_hide_tips, ccc3(0, 0, 0), ccp(0, 2))
  local contentSize = self.ui.panel_team:getContentSize()
  local draglist = ed.UITool.createDraglist(self.ui.panel_team, {priority = -300})
  for i, v in ipairs(self.teamArr) do
    local itemContainer, itemUI = self:createTeamItem(i, v)
    draglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i))
  end
  draglist:initListHeight(self:getHeight(#self.teamArr))
  self.refreshCliprectConfig = {draglist = draglist}
end
