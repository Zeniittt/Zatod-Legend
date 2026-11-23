local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.peakArenaVoteWin = class
ed.UITool.registViewOpenFunc("peakArenaVoteWin", function(param)
  ListenEventOnce("peakArenaBanList", function()
    class.create(param):popWindow()
  end)
  ed.PeakArenaNetwork:sendQueryBanList()
end)

function class.create(param)
  local self = base.create("peakArenaVoteWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.mgr = ed.PeakArenaManager
  self.voteHeroList = ed.copyProto(self.mgr:getAllVotedHero())
  self.banHeroAmount = self.mgr:getBanAmount()
  self.selectedHeroId = {}
  self.closeCallBack = param.closeCallBack
  table.sort(self.voteHeroList, ed.cmpSort({
    {
      getValue = function(data)
        local heroId = data._hero_id
        local initStars = ed.getDataTable("Unit")[heroId]["Initial Stars"]
        return initStars
      end,
      reverse = true
    },
    {
      getValue = function(data)
        return data._hero_id
      end,
      reverse = false
    }
  }))
  self:initUI()
  self:addTouchEvent()
  self:addListenEvent()
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaVoteWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initTableView()
  self:refreshUI()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_select, ed.toccc3(0), 1)
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.voteHeroList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(77, 77)
    end,
    createCell = function(index)
      local data = self.voteHeroList[index]
      local heroId = data._hero_id
      local itemContainer, mask = self:createHeroItem(index, heroId)
      return itemContainer, {heroId = heroId, mask = mask}
    end,
    doClickIn = function(cell, x, y)
      self:onClickHeroIcon(cell, x, y)
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 7,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    padding = {width = 18, height = 18},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:createHeroItem(index, heroId)
  local initStar = ed.getDataTable("Unit")[heroId]["Initial Stars"]
  local heroIcon = ed.readhero.createIcon({id = heroId, stars = initStar}).icon
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(77, 77))
  local mask = CCLayerColor:create(ccc4(0, 0, 0, 127))
  mask:setContentSize(CCSizeMake(77, 77))
  mask:setPosition(ccp(-3, -4))
  heroIcon:addChild(mask)
  local banTag = ed.createSprite("UI/alpha/1080P/toparena/toparena_ban_symbol_1.png")
  mask:addChild(banTag)
  ed.layout.centerInParent(banTag)
  mask:setVisible(false)
  container:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  return container, mask
end

function class:refreshUI()
  self.tableView:reloadData()
  self:refreshBanAmount()
end

function class:onClickHeroIcon(cell)
  local data = cell.data
  local mask = data.mask
  local heroId = data.heroId
  if ed.isElementInTable(heroId, self.selectedHeroId) then
    mask:setVisible(false)
    local deleteIndex
    for index, oldHeroId in ipairs(self.selectedHeroId) do
      if heroId == oldHeroId then
        deleteIndex = index
        break
      end
    end
    if deleteIndex then
      table.remove(self.selectedHeroId, deleteIndex)
    end
  else
    if #self.selectedHeroId >= self.banHeroAmount then
      ed.showToast(T("\229\183\178\229\136\176\232\190\190\231\166\129\231\148\168\228\184\138\233\153\144"))
      return
    end
    mask:setVisible(true)
    table.insert(self.selectedHeroId, heroId)
  end
  self:refreshBanAmount()
end

function class:refreshBanAmount()
  ed.setLabelString(self.ui.label_select, string.format("%s/%s", #self.selectedHeroId, self.banHeroAmount))
end

function class:onClickBtnVote()
  if #self.selectedHeroId <= 0 or #self.selectedHeroId < self.banHeroAmount then
    ed.showToast(string.format(T("\232\175\183\233\128\137\230\139\169%s\229\144\141\232\139\177\233\155\132\232\191\155\232\161\140\230\138\149\231\165\168"), self.banHeroAmount))
    return
  end
  ed.PeakArenaNetwork:sendVoteHero(self.selectedHeroId)
  self:destroy({
    callback = function()
      if self.closeCallBack then
        self.closeCallBack()
      end
    end
  })
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_vote", function()
    self:onClickBtnVote()
  end, {pressScale = 0.95})
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

function class:addListenEvent()
end
