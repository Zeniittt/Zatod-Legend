local base = ed.ui.popwindow
local CreviceDefendRecordWin = newclass(base.mt)
ed.ui.CreviceDefendRecordWin = CreviceDefendRecordWin
ed.UITool.registViewOpenFunc("OpenCreviceDefendRecordWin", function(data)
  ed.ui.CreviceDefendRecordWin.create(data)
end)

function CreviceDefendRecordWin.create(data)
  local self = base.create("CreviceDefendRecordWin")
  setmetatable(self, CreviceDefendRecordWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:adaptView()
  self:popWindow()
  return self
end

function CreviceDefendRecordWin:adaptView()
  self.ui.bg:setScale(0.9)
end

function CreviceDefendRecordWin:initData(data)
  self.recordData = data._record
  self.recordData = self.recordData or {}
end

function CreviceDefendRecordWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function CreviceDefendRecordWin:registerEvents()
end

function CreviceDefendRecordWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRecordWin)
  self.ui = ui
  self.container:addChild(container)
  local title_node = ed.ui.gradientLabel.create({
    text = T("\230\136\152\230\150\151\232\174\176\229\189\149"),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776165),
    endColor = ed.toccc3(16770431),
    strokeSize = 1,
    strokeColor = ed.toccc3(5838378)
  })
  self.ui.label_empty:setFontName(ed.fontBold)
  self.ui.label_empty:setString(T("\230\154\130\230\151\160\230\136\152\230\150\151\232\174\176\229\189\149\229\147\166~"))
  ed.setLabelColor(self.ui.label_empty, ccc3(85, 64, 63))
  ed.setLabelStroke(self.ui.label_empty, ed.toccc3(2692886), 1)
  self.ui.label_title:addChild(title_node.node)
  self.ui.img_empty:setVisible(#self.recordData == 0)
  self:sortRecordData()
  self:createRecordList()
end

function CreviceDefendRecordWin:createRecordList()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.recordData
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(656, 78)
    end,
    createCell = function(index)
      local itemContainer, ui = self:createRecordItem(index, self.recordData[index])
      return itemContainer, {
        rewardData = self.recordData[index],
        ui = ui
      }
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.btn_detail, x, y) then
        ui.btn_detail:setScale(0.95)
        return cell
      end
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if not ed.containsPoint(ui.btn_detail, x, y) then
        return
      end
      ed.CreviceDefendNetWork:sendOpenBattleRecord(data.rewardData._replay_id)
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      ui.btn_detail:setScale(1)
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    offset = {328, 39},
    touchpriority = -300,
    noshade = true
  }
  self.recordTableview = Tableview.create(param)
  self.recordTableview:reloadData()
end

function CreviceDefendRecordWin:sortRecordData()
  local maxDamage = -math.huge
  local maxIndex
  for i, v in ipairs(self.recordData) do
    if maxDamage < v._damage then
      maxDamage = v._damage
      maxIndex = i
    end
  end
  local maxElement = self.recordData[maxIndex]
  table.remove(self.recordData, maxIndex)
  table.sort(self.recordData, function(a, b)
    return a._bt_time > b._bt_time
  end)
  table.insert(self.recordData, 1, maxElement)
  return t
end

local RECORD_RANGE_TO_RES = {
  Top = {
    bg = "UI/alpha/1080P/crevicedefend/record_top1.png"
  },
  Normal = {
    bg = "UI/alpha/1080P/crevicedefend/battle_list.png"
  }
}

function CreviceDefendRecordWin:createRecordItem(index, recordData)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRecordItem)
  container:setContentSize(CCSizeMake(656, 78))
  ui.idx = index
  ui.bg:setScaleY(0.9)
  ui.bg:setScaleX(0.95)
  local timeStamp = recordData._bt_time
  local damage = recordData._damage
  if index == 1 then
    ed.setTexture(ui.bg, RECORD_RANGE_TO_RES.Top.bg)
    local damage_height_Label = ed.ui.gradientLabel.create({
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152"),
      fontSize = 20,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16775587),
      endColor = ed.toccc3(16762197),
      strokeSize = 1,
      strokeColor = ed.toccc3(12391440)
    })
    ed.UITool.replaceUI(ui, "bg", "label_name", damage_height_Label.node)
    local width = damage_height_Label:getContentSize().width
    ui.label_guild:addChild(damage_height_Label.node)
    damage_height_Label.node:setPosition(ccp(width / 2 + 20, 37))
    local damageLabel2 = ed.ui.gradientLabel.create({
      text = ed.formatDamage(damage),
      fontSize = 24,
      startColor = ed.toccc3(16776167),
      endColor = ed.toccc3(16748363),
      strokeSize = 1,
      strokeColor = ed.toccc3(9242880),
      hAlignment = kCCTextAlignmentLeft
    })
    ed.UITool.replaceUI(ui, "bg", "label_guild", damageLabel2.node)
    local width2 = damageLabel2:getContentSize().width
    damageLabel2.node:setPosition(ccp(width2 / 2 + 120, 37))
    ui.image_dps:setVisible(false)
  else
    ed.setTexture(ui.bg, RECORD_RANGE_TO_RES.Normal.bg)
    local title_node = ed.ui.gradientLabel.create({
      text = ed.formatDamage(damage),
      fontSize = 24,
      startColor = ed.toccc3(16775386),
      endColor = ed.toccc3(16764526),
      strokeSize = 1,
      strokeColor = ed.toccc3(7087884),
      hAlignment = kCCTextAlignmentLeft
    })
    local width = title_node:getContentSize().width
    ui.layer_guild:addChild(title_node.node, 2)
    title_node.node:setPositionX(width / 2)
    ui.label_name:setPositionX(20)
    ed.setLabelColor(ui.label_name, ccc3(255, 194, 66))
    ed.setLabelStroke(ui.label_name, ed.toccc3(3613986), 1)
  end
  ed.setString(ui.label_day, T("%s\229\137\141", ed.time2dhm(ed.getServerTime() - timeStamp)))
  ui.label_day:setFontName(ed.fontBold)
  ed.setLabelColor(ui.label_day, ed.toccc3(16776423))
  ed.setLabelStroke(ui.label_day, ed.toccc3(3613986), 1)
  ed.setLabelColor(ui.label_damage_value, ccc3(254, 241, 169))
  ed.setLabelStroke(ui.label_damage_value, ccc3(0, 0, 0), 1)
  return container, ui
end
