local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.peakArenaVoteResultWin = class
ed.UITool.registViewOpenFunc("peakArenaVoteResultWin", function()
  ListenEventOnce("peakArenaBanList", function()
    class.create():popWindow()
  end)
  ed.PeakArenaNetwork:sendQueryBanList()
end)

function class.create()
  local self = base.create("peakArenaVoteResultWin")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.mgr = ed.PeakArenaManager
  self.banHeros = ed.copyProto(self.mgr:getAllVotedHero())
  self.banHeroAmount = self.mgr:getBanAmount()
  self:initVoteHeroList()
  self:initUI()
  self:addEventListener()
  self:addTouchEvent()
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaVoteResultWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initTableView()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initVoteHeroList()
  table.sort(self.banHeros, ed.cmpSort({
    {key = "_voted_num", reverse = true},
    {
      getValue = function(t)
        local heroId = t._hero_id
        return ed.getDataTable("Unit")[heroId]["Initial Stars"]
      end,
      reverse = true
    },
    {key = "heroId"}
  }))
end

function class:getVotedAmount(heroId)
  for index, heroData in pairs(self.banHeros or {}) do
    if heroData._hero_id == heroId then
      return heroData._voted_num
    end
  end
  return 0
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(0), 1)
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.banHeros
    end,
    cellSizeFromIndex = function(index)
      return self:getHeroItemSize()
    end,
    createCell = function(index)
      local heroData = self.banHeros[index]
      local itemContainer, ui = self:createHeroItem(index, heroData)
      return itemContainer, {heroData = heroData, ui = ui}
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 7,
    dragMode = 1,
    touchpriority = -300,
    offset = {12, 0},
    padding = {width = 5, height = 5},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:createHeroItem(index, heroData)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaVoteResultItem)
  container:setContentSize(ui.bg:getContentSize())
  local heroId = heroData._hero_id
  local votedNum = heroData._voted_num
  local initStar = ed.getDataTable("Unit")[heroId]["Initial Stars"]
  local heroIcon = ed.readhero.createIcon({id = heroId, stars = initStar}).icon
  ui.panel_hero:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  ed.setString(ui.label_vote, string.format(T("%s\231\165\168"), votedNum))
  local labelSize = ui.label_vote:getContentSize()
  local labelPosX, _ = ui.label_vote:getPosition()
  if index <= self.banHeroAmount then
    ed.setLabelColor(ui.label_vote, ed.toccc3(16685133))
    ui.image_ban_tag:setVisible(true)
    ui.image_ban_tag:setPositionX(labelPosX - labelSize.width / 2 - 9)
  else
    ed.setLabelColor(ui.label_vote, ed.toccc3(16776423))
    ui.image_ban_tag:setVisible(false)
  end
  return container, ui
end

function class:getHeroItemSize()
  return CCSizeMake(100, 112.5)
end

function class:refreshUI()
  self.tableView:reloadData()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.65, normalScale = 0.7})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function class:addEventListener()
end
