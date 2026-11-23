local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.heroRecycleSelectWindow = class
ed.UITool.registViewOpenFunc("heroRecycleSelectWindow", function(param)
  ed.heroRecycleSelectWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("heroRecycleSelectWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.selectHeroId = param.selectHeroId
  self.heroList = param.heroList or {}
  self.selectHeroCallBack = param.selectHeroCallBack
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.hero_recycle_select_hero_window)
  self.ui = ui
  self.container:addChild(container)
  self:initTableView()
  self:refreshTableView()
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.heroList
    end,
    cellSizeFromIndex = function(index)
      return self:getIconSize()
    end,
    createCell = function(index)
      local hero = self.heroList[index]
      local icon = self:createHeroIcon(hero)
      return icon, {hero = hero}
    end,
    doPressIn = function(cell, x, y)
      local node = cell.node
      node.heroIcon:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local node = cell.node
      node.heroIcon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local node = cell.node
      self:onClickHeroIcon(data.hero)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 5,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:getIconSize()
  return CCSizeMake(90, 90)
end

function class:refreshTableView()
  self.tableView:reloadData()
end

function class:createHeroIcon(hero)
  local container = ed.createSprite()
  container:setContentSize(self:getIconSize())
  local isSelect = hero._tid == self.selectHeroId
  local heroIcon = ed.readhero.createIconByHero(hero).icon
  container:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  local selectMask = CCLayerColor:create(ccc4(0, 0, 0, 150))
  selectMask:setContentSize(CCSizeMake(77, 77))
  heroIcon:addChild(selectMask)
  ed.layout.centerInParent(selectMask)
  local image_select = ed.createSprite("UI/alpha/1080P/package/selected.png")
  selectMask:addChild(image_select)
  ed.layout.centerInParent(image_select)
  selectMask:setVisible(isSelect)
  container.heroIcon = heroIcon
  container.selectMask = selectMask
  return container
end

function class:onClickHeroIcon(hero)
  local heroId = hero._tid
  if heroId == self.selectHeroId then
    return
  end
  self.selectHeroId = heroId
  local listX, listY = self.tableView:getListPos()
  self.tableView:reloadData()
  self.tableView:setListPos(ccp(listX, listY))
end

function class:onClickBtnConfirm()
  if not self.selectHeroId then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132"))
    return
  end
  if self.selectHeroCallBack then
    self.selectHeroCallBack(self.selectHeroId)
  end
  self:destroy()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end)
end

function class:addEventListener()
end
