local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.peakArenaBanHeroWin = class
ed.UITool.registViewOpenFunc("peakArenaBanHeroWin", function()
  class.create():popWindow()
end)

function class.create()
  local self = base.create("peakArenaBanHeroWin")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.mgr = ed.PeakArenaManager
  self.banedHeroes = self.mgr:getBanedHeroes() or {}
  table.sort(self.banedHeroes, ed.cmpSort({
    {
      getValue = function(heroId)
        local initStars = ed.getDataTable("Unit")[heroId]["Initial Stars"]
        return initStars
      end,
      reverse = true
    },
    {reverse = false}
  }))
  self:initUI()
  self:addListenEvent()
  self:addTouchEvent()
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaBanHeroWin)
  self.container:addChild(container)
  self.ui = ui
  self:initTableView()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.banedHeroes
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(117.5, 135)
    end,
    createCell = function(index)
      local heroId = self.banedHeroes[index]
      local itemContainer = self:createHeroItem(index, heroId)
      return itemContainer, {heroId = heroId}
    end,
    doClickIn = function(cell, x, y)
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 5,
    dragMode = 1,
    touchpriority = -300,
    offset = {18, 0},
    padding = {width = 18, height = 10},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:createHeroItem(index, heroId)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaBanHeroItem)
  container:setContentSize(ui.bg:getContentSize())
  local initStar = ed.getDataTable("Unit")[heroId]["Initial Stars"]
  local heroIcon = ed.readhero.createIcon({id = heroId, stars = initStar}).icon
  heroIcon:setScale(1.4)
  ui.panel_hero:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  local heroName = ed.getDataTable("Unit")[heroId]["Display Name"]
  ed.setString(ui.label_hero_name, heroName)
  return container, ui
end

function class:refreshUI()
  self.tableView:reloadData()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.65, normalScane = 0.7})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function class:addListenEvent()
end
