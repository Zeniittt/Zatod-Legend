local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessRaceWin = class

function class:initData()
  self.allHeros = {}
  local tempHero = {}
  local chessUnitTable = ed.getDataTable("ChessUnit")
  for k, v in pairs(chessUnitTable) do
    if type(k) == "number" and v["Unit Type"] == "Hero" and v.Name ~= "ChessNPC" and v["Is Available"] then
      local heroId = v["Hero ID"]
      if not tempHero["id_" .. heroId] then
        tempHero["id_" .. heroId] = {
          hid = heroId,
          chessIds = {}
        }
      end
      tempHero["id_" .. heroId].chessIds[v["Chess Stars"]] = v["Chess ID"]
    end
  end
  for k, v in pairs(tempHero) do
    table.insert(self.allHeros, v)
  end
  table.sort(self.allHeros, function(a, b)
    local priceA = ed.getDataTable("ChessUnit")[a.hid]["Sell Price"]
    local priceB = ed.getDataTable("ChessUnit")[b.hid]["Sell Price"]
    return priceA > priceB
  end)
end

function class:loadHero(index)
  if index < 1 then
    return
  end
  if index > #self.allHeros then
    return
  end
  local heroData = self.allHeros[index]
  local heroNode = ed.ui.AutoChessUITool.createRaceHeroNode(heroData)
  local data = {icon = heroNode, heroData = heroData}
  return heroNode, data
end

function class:setHeroTableDelegate()
  local delegate = {}
  
  function delegate.numberOfCells()
    return #self.allHeros
  end
  
  function delegate.cellSizeFromIndex(idx)
    return CCSizeMake(84, 97)
  end
  
  function delegate.createCell(idx)
    local node, data = self:loadHero(idx)
    return node, data
  end
  
  function delegate.syncCell(cell, idx)
    local node, data = self:loadHero(idx)
    return node, data
  end
  
  function delegate.doClickIn(cell, x, y)
    local idx = cell.idx
    local data = cell.data
    ed.ui.AutoChessRaceDetailWin.create(data.heroData):popWindow()
  end
  
  return delegate
end

function class:refreshDraglist()
  self.delegate = self:setHeroTableDelegate()
  local tagSize = self.ui.layer_item:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 0, tagSize.width, tagSize.height),
    dragMode = 1,
    colNum = 8,
    touchpriority = -300
  }
  self.heroListView = Tableview.create(param)
  if self.heroListView then
    self.heroListView:staticSync()
    self.heroListView:setContentOffset()
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessRaceWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(6373674), 1.5)
  self:refreshDraglist()
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.75, normalScale = 0.8})
end

function class.create()
  local self = base.create("AutoChessRaceWin")
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  return self
end
