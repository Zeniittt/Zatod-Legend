local base = ed.ui.popwindow
local KingsPvpRecordWin = newclass(base.mt)
ed.ui.KingsPvpRecordWin = KingsPvpRecordWin

function KingsPvpRecordWin.create(param)
  local self = base.create("KingsPvpRecordWin")
  setmetatable(self, KingsPvpRecordWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function KingsPvpRecordWin:initData(param)
  param = param or {}
  self.records = param.records or {}
end

function KingsPvpRecordWin:initLabels()
  ed.setLabelStroke(self.ui.Label_860, ed.toccc3(4666403), 1)
end

function KingsPvpRecordWin:createRecordItem(index, recordData)
  local container, ui = ed.editorui(ed.uieditor.KingsRecordItem)
  container:setContentSize(ui.bg:getContentSize())
  ui.label_lose:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_lose, ed.toccc3(6574746), 1)
  ui.label_win:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_win, ed.toccc3(13458726), 1)
  local isWin = recordData._bt_result == "victory"
  ui.icon_win:setVisible(isWin)
  ui.icon_lose:setVisible(not isWin)
  local oppoSummary = recordData._summary
  local serverName = recordData._svr_name or ""
  local name = ed.getPlayerName(" " .. oppoSummary._name, oppoSummary._medal, {medalScale = 0.15, fontSize = 14})
  ed.UITool.replaceUINew(ui, "name", name)
  local param = {
    id = oppoSummary._avatar,
    scale = 0.5
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUINew(ui, "head", head)
  ed.setLabelStroke(ui.Label_877, ed.toccc3(4271123), 1)
  ed.setLabelStroke(ui.Label_877_Copy1, ed.toccc3(4271123), 1)
  ed.setLabelStroke(ui.Label_877_Copy0, ed.toccc3(4271123), 1)
  ed.setLabelStroke(ui.Label_877_Copy2, ed.toccc3(4271123), 1)
  ed.setLabelStroke(ui.label_score_tips, ed.toccc3(12542248), 1)
  ed.setString(ui.Label_877_Copy2, serverName)
  ed.setString(ui.Label_877_Copy1, oppoSummary._guild_name or T("\230\151\160"))
  local timestr = ed.time2dhms(ed.getServerTime() - (recordData._bt_time or 0)) .. T("\229\137\141")
  ed.setString(ui.Label_877_Copy3, timestr)
  ed.setLabelStroke(ui.Label_877_Copy3, ed.toccc3(3351054), 1)
  ed.setLabelShadow(ui.Label_884, ccc3(0, 0, 0), ccp(1, 1))
  ui.image_ob_tag:setVisible(recordData._is_audience == 1)
  local newScore = recordData._new_score
  local oldScore = recordData._score
  if isWin then
    ed.setLabelColor(ui.label_score_tips, ed.toccc3(16773542))
    ed.setLabelStroke(ui.label_score_tips, ed.toccc3(12542248), 1)
  else
    ed.setLabelColor(ui.label_score_tips, ed.toccc3(13819903))
    ed.setLabelStroke(ui.label_score_tips, ed.toccc3(6512336), 1)
  end
  local scoreNode = ed.getNumberNode({text = newScore, folder = "peak_score"}).node
  scoreNode:setScale(0.6)
  scoreNode:setAnchorPoint(ccp(0, 0.5))
  ui.bg:addChild(scoreNode)
  scoreNode:setPosition(ui.panel_socre_pos:getPosition())
  local scoreChange = newScore - oldScore
  if 0 < scoreChange then
    ed.setLabelString(ui.label_score_change, scoreChange)
    ed.setLabelColor(ui.label_score_change, ed.toccc3(7864155))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(4271123), 1)
    ed.setTexture(ui.image_score_arrow, "UI/alpha/1080P/pvp/arrow_up.png")
    ed.right2(ui.image_score_arrow, scoreNode)
    ed.right2(ui.label_score_change, ui.image_score_arrow)
  elseif scoreChange < 0 then
    ed.setLabelString(ui.label_score_change, -scoreChange)
    ed.setLabelColor(ui.label_score_change, ed.toccc3(16736578))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(4271123), 1)
    ed.setTexture(ui.image_score_arrow, "UI/alpha/1080P/pvp/arrow_down.png")
    ed.right2(ui.image_score_arrow, scoreNode)
    ed.right2(ui.label_score_change, ui.image_score_arrow)
  else
    scoreNode:setVisible(false)
    ui.label_score_tips:setVisible(false)
    ui.image_score_arrow:setVisible(false)
    ui.label_score_change:setVisible(false)
  end
  return container, ui
end

function KingsPvpRecordWin:initTableView()
  local size = self.ui.layer_item:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.records
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(669.5, 71.5)
    end,
    createCell = function(index)
      local recordData = self.records[index]
      local itemContainer, ui = self:createRecordItem(index, recordData)
      return itemContainer, {recordData = recordData, ui = ui}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        if ed.containsPoint(ui.ImageView_876, x, y) then
          ui.ImageView_876:setScale(0.95)
        end
        return cell
      end
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      ui.ImageView_876:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if not ed.containsPoint(ui.ImageView_876, x, y) then
        return
      end
      self:onClickOpenDetail(data.recordData)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {3, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function KingsPvpRecordWin:initUI()
  ed.editorui(ed.uieditor.KingsRecordWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:initTableView()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function KingsPvpRecordWin:onClickOpenDetail(recordData)
  ed.realarena.network_mgr:RequestReplay(recordData._record_index, "casual")
end

function KingsPvpRecordWin:registerEvents()
end

function KingsPvpRecordWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.7, pressScale = 0.65})
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
end
