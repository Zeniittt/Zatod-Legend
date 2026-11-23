local base = ed.ui.popwindow
local class = {}
class.__index = class
setmetatable(class, base.mt)
ed.ui.dragonBoatGiveRecordPop = class
ed.UITool.registViewOpenFunc("dragonBoatGiveRecordPop", function(param)
  ed.ui.dragonBoatGiveRecordPop.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("dragonBoatGiveRecordPop")
  setmetatable(self, class)
  self:init(param)
  self:show()
  return self
end

function class:init(param)
  self:initData(param)
  self:initUI()
  self:createList()
  self:registerTouchHandler()
end

function class:initData(param)
  self.records = param._records or {}
  self.rankList = {}
  self.dataList = self.records
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.dragonBoatGiveRecordPop)
  self.container:addChild(container)
  self.ui = ui
  self:initLabel()
  self.ui.image_empty:setVisible(#self.dataList == 0)
end

function class:initLabel()
  ed.setLabelStroke(self.ui.label_empty, ed.toccc3(2109482), 1.5)
  for i = 1, 7 do
    ed.setLabelShadow(self.ui["Label_title_" .. i], ed.toccc3(1774863), ccp(0, 1.5))
  end
  if not ed.isElementInTable(EDCurLanguage, {"cn", "tw"}) then
    self.ui.Label_page3:limitSizeByScale(80, 40)
    self.ui.Label_page4:limitSizeByScale(100, 40)
  end
end

function class:createRecordItem(idx, data)
  local ui = {}
  local container = ed.createCCLayer({
    pos = ccp(0, 0),
    sizeMake = CCSizeMake(642.5, 52)
  })
  local summary = data._user
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/dragonboat/db_record/db_record_gift_bottombox.png",
    pos = ccp(321.25, 26),
    parent = container
  })
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar
  })
  head:setPosition(62, 26)
  head:setScale(0.45)
  ui.bg:addChild(head)
  ui.headIcon = headIcon
  local is_give = data._is_give and data._is_give == 1
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(255,252,231)",
    fontSize = 14,
    disableOffset = true,
    medalScale = 0.15
  })
  name:setPosition(ccp(85, 34))
  ui.bg:addChild(name)
  ed.createLabelTools({
    txt = T(data._svr_name),
    size = 12,
    pos = ccp(86, 16),
    color = ccc3(ed.colorToStr("#fff088")),
    parent = ui.bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = is_give and T("\232\181\160\233\128\129") or T("\232\142\183\232\181\160"),
    size = 16,
    pos = ccp(260, 26),
    color = ccc3(ed.colorToStr(is_give and "#fffce7" or "#fff088")),
    parent = ui.bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr(is_give and "#221505" or "#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = data._num,
    size = 16,
    pos = ccp(370, 26),
    color = ccc3(ed.colorToStr(is_give and "#fffce7" or "#fff088")),
    parent = ui.bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr(is_give and "#221505" or "#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = T(ed.getYMDHMSTime(data._time)),
    size = 16,
    pos = ccp(540, 26),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    }
  })
  return container, {data = data, ui = ui}
end

function class:createRankItem(idx, data)
  local ui = {}
  local container = ed.createCCLayer({
    pos = ccp(0, 0),
    sizeMake = CCSizeMake(642.5, 52)
  })
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/dragonboat/db_record/db_record_receive_bottombox.png",
    pos = ccp(321.25, 26),
    parent = container
  })
  ed.createLabelTools({
    txt = idx,
    size = 16,
    pos = ccp(39, 26),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  local summary = data._user_summary
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar
  })
  head:setPosition(139, 26)
  head:setScale(0.45)
  ui.bg:addChild(head)
  ui.headIcon = headIcon
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(255,252,231)",
    fontSize = 14,
    disableOffset = true,
    medalScale = 0.15
  })
  name:setPosition(ccp(159, 34))
  ui.bg:addChild(name)
  ed.createLabelTools({
    txt = T(data._param4),
    size = 12,
    pos = ccp(160, 16),
    color = ccc3(ed.colorToStr("#fff088")),
    parent = ui.bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = data._param1,
    size = 16,
    pos = ccp(480, 26),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  return container, {
    data = {_user = summary},
    ui = ui
  }
end

function class:createList()
  self.delegate = {
    numberOfCells = function()
      return #self.dataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(642.5, 52)
    end,
    createCell = function(index)
      local data = self.dataList[index]
      if self.index == 2 then
        return self:createRankItem(index, data)
      else
        return self:createRecordItem(index, data)
      end
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        if ed.containsPoint(ui.headIcon, x, y) then
          ui.headIcon:setScale(0.95)
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
      ui.headIcon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if not ed.containsPoint(ui.headIcon, x, y) then
        return
      end
      local data = data.data
      local summary = data._user
      ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
    end
  }
  local size = self.ui.Panel_list:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.Panel_list,
    cliprect = CCRectMake(-2, 0, size.width + 4, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {2.3, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:registerTouchHandler()
  self:btRegisterOutClick({
    area = {
      self.ui.bj,
      self.ui.page_button_1,
      self.ui.page_button_2
    },
    key = "bj_close",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_close",
    clickInterval = 1,
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
  for index = 1, 2 do
    self:btRegisterButtonClick({
      button = self.ui["page_button_" .. index],
      selected = self.ui["page_button_selected_" .. index],
      key = "number" .. index,
      radioGroupName = "number",
      clickHandler = function()
        if not self.over then
          return
        end
        self.index = index
        self.ui.page_title_1:setVisible(index == 1)
        self.ui.page_title_2:setVisible(index == 2)
        self.dataList = index == 1 and self.records or self.rankList
        self.ui.image_empty:setVisible(#self.dataList == 0)
        self.tableView:reloadData()
      end
    })
  end
  self:listenEvent("req_home_page", function(data)
    ed.ui.PlayerInfoPanel.create(data, false):popWindow()
  end)
  self:listenEvent("DragonBoatQueryGiveRecordRankReply", function(data)
    self.over = true
    self.rankList = data
  end)
  ed.dragonBoatNet:sendQueryGiveRecordRank()
end
