local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueTeamWindow = class
ed.UITool.registViewOpenFunc("rogueTeamWindow", function(param)
  ed.ui.rogueTeamWindow.create(param):popWindow()
end)

function class.create(param)
  param = param or {}
  local noShade = param.noShade or false
  local self = base.create("rogueTeamWindow", {noShade = noShade})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.skipAnim = param.skipAnim or false
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.heroList = {}
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
  if not self.skipAnim then
    self:show()
  end
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueTeamWindow)
  self.container:addChild(container)
  self.ui = ui
  ed.left2(self.ui.ImageView_50966, self.ui.label_title, 10)
  ed.right2(self.ui.ImageView_50965, self.ui.label_title, 10)
  self:initTableView()
  self:refreshTableView()
end

function class:showOpenAction()
  self.ui.image_bg:setScale(0)
  self:beginRefreshCliprect(self.tableView.dragList, self.ui.image_bg)
  local callFunc = CCCallFunc:create(function()
    self:endRefreshCliprect()
    self:refreshCliprect(self.tableView.dragList, self.ui.image_bg)
  end)
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(CCEaseBackOut:create(CCScaleTo:create(0.15, 1)), callFunc)))
end

function class:showCloseAction(callBack)
  local closeAction = CCEaseBackIn:create(CCScaleTo:create(0.2, 0))
  local callFunc = CCCallFunc:create(function()
    self:endRefreshCliprect()
    self:refreshCliprect(self.tableView.dragList, self.ui.image_bg)
    if callBack then
      callBack()
    end
  end)
  self:beginRefreshCliprect(self.tableView.dragList, self.ui.image_bg)
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(closeAction, callFunc)))
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.heroList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(70, 70)
    end,
    createCell = function(index)
      local rogueHeroInfo = self.heroList[index]
      local heroIcon = self:createHeroIcon(rogueHeroInfo)
      return heroIcon
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 5,
    dragMode = 1,
    touchpriority = -300,
    offset = {10, -8},
    padding = {width = 33, height = 20},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:refreshTableView()
  self.heroList = self.rogueLikeMgr:getAllHeroInfo()
  self.tableView:reloadData()
end

function class:createHeroIcon(rogueHeroInfo)
  local heroId = rogueHeroInfo._heroid
  local hero = ed.player:getHero(heroId)
  local heroIcon = ed.readhero.createIcon({
    id = hero._tid,
    rank = hero._rank,
    hp = rogueHeroInfo._hp_perc,
    mp = rogueHeroInfo._mp_perc,
    level = hero._level,
    stars = hero._stars,
    fashion_id = hero._fashion,
    summary = hero
  })
  return heroIcon.icon
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:close()
    end,
    force = true
  })
end

function class:close()
  self:showCloseAction(function()
    self:destroy({
      skipAnim = self.skipAnim
    })
  end)
end

function class:addEventListener()
end
