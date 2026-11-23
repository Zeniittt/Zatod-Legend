local base = ed.ui.popwindow
local CreviceDefendReCommendWin = newclass(base.mt)
ed.ui.CreviceDefendReCommendWin = CreviceDefendReCommendWin

function CreviceDefendReCommendWin.create(data)
  local self = base.create("CreviceDefendReCommendWin")
  setmetatable(self, CreviceDefendReCommendWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function CreviceDefendReCommendWin:initData(data)
  self.recordArr = {}
  for i, v in ipairs(data._user_info or {}) do
    table.insert(self.recordArr, v)
  end
end

function CreviceDefendReCommendWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({skipAnim = false})
  end, {pressScale = 0.95, clickInterval = 0.2})
end

function CreviceDefendReCommendWin:registerEvents()
  self:listenEvent("CreviceDefendReCommendLineup", function(...)
    self:destroy({skipAnim = true})
  end)
end

function CreviceDefendReCommendWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendReCommendWin)
  self.ui = ui
  self.container:addChild(container)
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\230\142\168\232\141\144\233\152\181\229\174\185"),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776165),
    endColor = ed.toccc3(16770431),
    strokeSize = 1,
    strokeColor = ed.toccc3(5838378)
  })
  self.ui.label_title:addChild(titleLabel.node)
  self.ui.label_empty:setFontName(ed.fontBold)
  self.ui.label_empty:setString(T("\230\154\130\230\151\160\230\142\168\232\141\144\233\152\181\229\174\185\229\147\166~"))
  ed.setLabelColor(self.ui.label_empty, ccc3(85, 64, 63))
  ed.setLabelStroke(self.ui.label_empty, ed.toccc3(2692886), 1)
  self.ui.img_empty:setVisible(0 == #self.recordArr)
  self:createReordList()
end

function CreviceDefendReCommendWin:createReordList()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.recordArr
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(719, 85)
    end,
    createCell = function(index)
      return self:createRecordItem(index, self.recordArr[index])
    end,
    doPressIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        if ed.containsPoint(ui.btn_click, x, y) then
          ui.btn_click:setScale(0.95)
        elseif ed.containsPoint(ui.headIcon, x, y) then
          ui.headRoot:setScale(0.95)
        end
      end
    end,
    doClickIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        local recordData = self.recordArr[cell.idx]
        if ed.containsPoint(ui.btn_click, x, y) then
          ed.CreviceDefendNetWork:sendOpenRecommendLineUp(recordData._user_summary._role_id)
        elseif ed.containsPoint(ui.headIcon, x, y) then
          ed.UITool.openView("playerInfoPanel", recordData._user_summary._role_id)
        end
      end
    end,
    cancelPressIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        ui.btn_click:setScale(1)
        ui.headRoot:setScale(1)
      end
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true,
    padding = {width = 0, height = 7}
  }
  self.recordTableview = Tableview.create(param)
  self.recordTableview:reloadData()
  self.refreshCliprectConfig = {
    draglist = self.recordTableview:getDragList()
  }
end

function CreviceDefendReCommendWin:createRecordItem(index, recordData)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendReCommendItem)
  container:setContentSize(ui.bg:getContentSize())
  ed.setLabelStroke(ui.label_guild, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_damage, ed.toccc3(3613986), 1)
  ed.setLabelShadow(ui.label_gamble, ccc3(0, 0, 0), ccp(1, 1))
  local summary = recordData._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.83,
    lvoffset = {x = -47.5, y = -30}
  }
  local headRoot, headIcon = ed.getWholeHeadIcon(param)
  ui.root_icon:addChild(headRoot)
  ed.layout.centerInParent(headRoot)
  ui.headRoot = headRoot
  ui.headIcon = headIcon
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ui.label_name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "bg", "label_name", name)
  ed.setString(ui.label_guild, summary._guild_name or "")
  local damageLabel = ed.ui.gradientLabel.create({
    text = ed.formatDamage(recordData._damage),
    fontSize = 24,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(7087884)
  })
  ed.UITool.replaceUI(ui, "bg", "label_damage_value", damageLabel.node)
  return container, ui
end
