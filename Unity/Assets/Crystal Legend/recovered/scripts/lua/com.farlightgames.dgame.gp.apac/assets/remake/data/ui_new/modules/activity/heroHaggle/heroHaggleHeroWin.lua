local base = ed.ui.popwindow
local heroHaggleHeroWin = newclass(base.mt)
ed.ui.heroHaggleHeroWin = heroHaggleHeroWin
ed.UITool.registViewOpenFunc("OpenHeroHaggleHeroWin", function(data)
  ed.ui.heroHaggleHeroWin.create(data)
end)

function heroHaggleHeroWin.create(data)
  local self = base.create("heroHaggleHeroWin")
  setmetatable(self, heroHaggleHeroWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function heroHaggleHeroWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.heroHaggleHeroSelectWin)
  self.ui = ui
  self.container:addChild(container)
  self:initLabel()
  self:createHeroList()
end

function heroHaggleHeroWin:initData(data)
  local seasonId = ed.heroHaggleMgr.getInstance():getCurrentSeasonId()
  local haggleConfig = ed.getDataTable("HeroHaggle")[seasonId]
  local heroConfig = haggleConfig["Hero List"]
  local tempList = {}
  for i, v in pairs(heroConfig) do
    table.insert(tempList, v)
  end
  table.sort(tempList, function(a, b)
    local timeConfig_a = ed.getDataTable("Unit")[a]
    local timeConfig_b = ed.getDataTable("Unit")[b]
    local onlineTime_a = ed.getTimeByYMDHMS(timeConfig_a["Online Time"])
    local onlineTime_b = ed.getTimeByYMDHMS(timeConfig_b["Online Time"])
    if onlineTime_a ~= onlineTime_b then
      return onlineTime_a > onlineTime_b
    end
    return a < b
  end)
  self.heroList = tempList
  self.selectHero = ed.heroHaggleMgr.getInstance():getSelectHero()
  self.oldIndex = 0
end

function heroHaggleHeroWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_select_hero", function()
    if self.selectHero ~= 0 and ed.heroHaggleMgr.getInstance():getSelectHero() ~= self.selectHero then
      ed.heroHaggleNet:sendSelectHero(self.selectHero)
    end
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function heroHaggleHeroWin:registerEvents()
end

function heroHaggleHeroWin:initLabel()
  ed.setLabelColor(self.ui.label_title, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(10898761), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  ed.setLabelColor(self.ui.label_hero, ed.toccc3(16770939))
  ed.setLabelString(self.ui.label_hero, T("\229\143\175\228\187\142\228\187\165\228\184\139\232\139\177\233\155\132\228\184\173\233\128\137\230\139\169\229\133\182\228\184\128\239\188\140\232\167\163\233\148\129\229\137\141\229\143\175\233\154\143\230\151\182\230\155\180\230\141\162\227\128\130"))
  self.ui.label_hero:limitWidthBySize(500)
  ed.setLabelColor(self.ui.Label_36476, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.Label_36476, ed.toccc3(9057072), 1)
end

function heroHaggleHeroWin:createHeroList()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.heroList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(95, 100)
    end,
    createCell = function(index)
      return self:createHeroItem(index, self.heroList[index])
    end,
    syncCell = function(cell, index)
      local container, ui = self:createHeroItem(index, self.heroList[index])
      return container
    end,
    doPressIn = function(cell, x, y)
      local ui = cell.data
      if ui and ed.containsPoint(ui.heroIcon, x, y) then
        ui.heroIcon:setScale(0.95)
        return cell
      end
    end,
    doClickIn = function(cell, x, y)
      local ui = cell.data
      if ui and ed.containsPoint(ui.heroIcon, x, y) then
        self.selectHero = self.heroList[cell.idx]
        if self.oldIndex ~= 0 then
          self.heroTableview:updateCellAtIndex(self.oldIndex)
        end
        self.heroTableview:updateCellAtIndex(cell.idx)
      end
    end,
    cancelPressIn = function(cell)
      local ui = cell.data
      if ui then
        ui.bg:setScale(1)
      end
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    dragMode = 1,
    colNum = 5,
    zorder = 999,
    touchpriority = -301,
    noshade = true,
    offset = {0, 15}
  }
  self.heroTableview = Tableview.create(param)
  self.heroTableview:reloadData()
end

local heroState = {
  normal = 1,
  max = 2,
  no_owner = 3
}

function heroHaggleHeroWin:getHeroState(id)
  local hero = ed.player:getHero(id)
  if hero then
    if hero._stars >= 5 then
      return heroState.max
    else
      return heroState.normal
    end
  else
    return heroState.no_owner
  end
end

function heroHaggleHeroWin:createHeroItem(index, tid)
  local container, ui = ed.editorui(ed.uieditor.heroHaggleHeroItem)
  container:setContentSize(ui.bg:getContentSize())
  ui.idx = index
  local heroIcon = ed.readhero.createIcon({id = tid}).icon
  ui.heroIcon = heroIcon
  ui.panel_hero:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  local heroName = ed.getDataTable("Unit")[tid]["Display Name"]
  ed.setString(ui.label_hero_name, "")
  local fontSize = 15
  if ed.isElementInTable(EDCurLanguage, {"es"}) then
    fontSize = 10
  end
  local hero_state = self:getHeroState(tid)
  local stateLabel
  if hero_state == heroState.no_owner then
    stateLabel = ed.ui.gradientLabel.create({
      text = T("\230\156\170\232\142\183\229\190\151"),
      fontSize = fontSize,
      fontName = ed.fontBold,
      startColor = ed.toccc3(9684717),
      endColor = ed.toccc3(16777208),
      strokeSize = 1,
      strokeColor = ed.toccc3(3489902)
    })
    ed.UITool.replaceUI(ui, "name_bg", "label_hero_name", stateLabel.node)
    ui.name_bg:setVisible(true)
    ui.layer_max:setVisible(false)
  elseif hero_state == heroState.max then
    stateLabel = ed.ui.gradientLabel.create({
      text = T("\229\183\178\230\187\161\230\152\159"),
      fontSize = fontSize,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16775796),
      endColor = ed.toccc3(16775796),
      strokeSize = 1,
      strokeColor = ed.toccc3(9978880)
    })
    ed.UITool.replaceUI(ui, "layer_max", "label_hero_name_max", stateLabel.node)
    ui.name_bg:setVisible(false)
    ui.layer_max:setVisible(true)
  else
    ui.name_bg:setVisible(false)
    ui.layer_max:setVisible(false)
  end
  ui.image_ban_Tag:setVisible(tid == self.selectHero)
  if tid == self.selectHero then
    self.oldIndex = index
  end
  return container, ui
end
