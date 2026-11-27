local base = ed.ui.popwindow
local CreviceDefendRecordDetailWin = newclass(base.mt)
ed.ui.CreviceDefendRecordDetailWin = CreviceDefendRecordDetailWin
local TeamUIConfig = {
  [1] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [4] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [5] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team5.png",
    teamColor = ed.toccc3(13625343),
    teamStrokeColor = ed.toccc3(2379449)
  }
}
ed.UITool.registViewOpenFunc("OpenCreviceDefendRecordDetailWin", function(data)
  ed.ui.CreviceDefendRecordDetailWin.create(data)
end)

function CreviceDefendRecordDetailWin.create(data)
  local self = base.create("CreviceDefendRecordDetailWin")
  setmetatable(self, CreviceDefendRecordDetailWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function CreviceDefendRecordDetailWin:initData(data)
  self.recordData = data._records
end

function CreviceDefendRecordDetailWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function CreviceDefendRecordDetailWin:registerEvents()
end

function CreviceDefendRecordDetailWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRecordDetailWin)
  self.ui = ui
  self.container:addChild(container)
  self:createReordList()
end

function CreviceDefendRecordDetailWin:createReordList()
  local size = self.ui.panel_team:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.recordData
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(670, 50)
    end,
    createCell = function(index)
      return self:createTeamItem(index, self.recordData[index])
    end,
    doPressIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        if ed.containsPoint(ui.btn_click, x, y) then
          ui.btn_statics:setScale(0.95)
        elseif ed.containsPoint(ui.headIcon, x, y) then
          ui.headRoot:setScale(0.95)
        end
      end
    end,
    doClickIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        if ed.containsPoint(ui.btn_statics, x, y) then
          self:onStaticsEvent(cell.idx)
        elseif ed.containsPoint(ui.btn_replay, x, y) then
          self:onReplayEvent(cell.idx)
        end
      end
    end,
    cancelPressIn = function(cell, x, y)
      local ui = cell.data
      if ui then
      end
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_team,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true,
    offset = {380, 25},
    padding = {width = 0, height = 5}
  }
  self.recordTableview = Tableview.create(param)
  self.recordTableview:reloadData()
  self.refreshCliprectConfig = {
    draglist = self.recordTableview:getDragList()
  }
end

function CreviceDefendRecordDetailWin:onStaticsEvent(index)
  local record = self.recordData[index]
  ed.CreviceDefendNetWork:sendOpenBattleReport(record._checkid, index)
end

function CreviceDefendRecordDetailWin:onReplayEvent(index)
  local recordData = self.recordData[index]
  if not recordData then
    ed.showToast(T("\230\154\130\230\151\160\229\189\149\229\131\143"))
    return
  end
  ed.CreviceDefendBattleManager:enterReplay(recordData, recordData._round)
end

function CreviceDefendRecordDetailWin:createTeamItem(index, teamData)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRecordDetailItem)
  container:setContentSize(ui.bg:getContentSize())
  ui.index = index
  local uiConfig = TeamUIConfig[index]
  ed.setScale9SpriteTexture(ui.bg_img, uiConfig.bgPath)
  ui.bg_img:setContentSize(CCSizeMake(650, 48))
  ed.setLabelColor(ui.label_team, uiConfig.teamColor)
  ed.setLabelStroke(ui.label_team, uiConfig.teamStrokeColor, 1)
  ed.setLabelStroke(ui.label_damage_des, ed.toccc3(2564894), 1)
  ed.setString(ui.label_team, T("%s\233\152\159", index))
  ui.label_team:setFontName(ed.fontBold)
  ed.setLabelColor(ui.label_teamDamage, ccc3(232, 177, 82))
  ed.setLabelStroke(ui.label_teamDamage, ed.toccc3(2564894), 1)
  local damageLabel = ed.ui.gradientLabel.create({
    text = ed.formatDamage(teamData._damage),
    fontSize = 18,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(2564894)
  })
  ed.UITool.replaceUI(ui, "bg", "label_num", damageLabel.node)
  self:createHeroList(ui.panel_hero, teamData._self_heroes)
  return container, ui
end

function CreviceDefendRecordDetailWin:createHeroList(container, heroData)
  ed.readhero.sortIDByRange(heroData._heroes or {}, function(tab)
    return tab._tid
  end)
  container:removeAllChildrenWithCleanup(true)
  local containerSize = container:getContentSize()
  for i, v in ipairs(heroData._heroes or {}) do
    local heroInfo = ed.readhero.createIconByServer(v, {state = "idle"})
    local icon = heroInfo.icon
    heroInfo:showLegendEquip(false)
    container:addChild(icon)
    icon:setScale(0.5)
    icon:setPosition(ccp((i - 0.5) * 50, containerSize.height * 0.5))
  end
end
