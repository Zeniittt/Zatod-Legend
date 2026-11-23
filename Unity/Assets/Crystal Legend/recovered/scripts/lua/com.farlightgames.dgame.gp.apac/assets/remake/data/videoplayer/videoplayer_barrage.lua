VideoPlayerBarrage = {}
VideoPlayerBarrage.__index = VideoPlayerBarrage
local base = ed.ui.popwindow
setmetatable(VideoPlayerBarrage, base.mt)

function VideoPlayerBarrage.create(data)
  local panel = base.create("VideoPlayerBarrage")
  setmetatable(panel, VideoPlayerBarrage)
  panel:initData(data)
  panel:initAppearance()
  panel:registerTouchHandler()
  return panel
end

function VideoPlayerBarrage:destroy()
  ed.playEffect(ed.sound.deo.common_close_popup_window)
  if self.mainLayer then
    self.mainLayer:setTouchEnabled(false)
    self.mainLayer:removeFromParentAndCleanup(true)
    self.mainLayer = nil
  end
end

function VideoPlayerBarrage:initData(data)
  local barrages = {}
  for k, v in pairs(data) do
    for _, barrage in pairs(v) do
      local userKey = barrage._user_key
      if userKey then
        local key = userKey._svr_id .. "-" .. userKey._uid
        barrages[key] = barrages[key] or {}
        table.insert(barrages[key], barrage)
      end
    end
  end
  local data = {}
  for _, v in pairs(barrages) do
    for i, b in pairs(v) do
      table.insert(data, b)
    end
  end
  self.data = data
end

function VideoPlayerBarrage:initAppearance()
  local mainLayer = self.mainLayer
  local container, ui = ed.editorui(ed.uieditor.videoplayer_list)
  self.container = container
  self.ui = ui
  mainLayer:addChild(container)
  self:createTableView()
end

function VideoPlayerBarrage:createTableView()
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.data
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(300, 50)
  end
  
  function dlgt.createCell(idx)
    local container, ui = ed.editorui(ed.uieditor.videoplayer_item)
    local info = self.data[idx]
    ui.image_bg_mask:setVisible(info._is_mute == 1)
    ui.label_content:setDimensions(CCSizeMake(289, 0))
    ui.label_content:setString(info._content)
    ui.node_item:setAnchorPoint(ccp(0.5, 0.5))
    return container, {ui = ui, info = info}
  end
  
  function dlgt.doPressIn(cell)
    local data = cell.data
    local ui = data.ui
    ui.node_item:setScale(0.95)
  end
  
  function dlgt.doClickIn(cell)
    ed.playEffect(ed.sound.deo.common_click_feedback)
    local data = cell.data
    local node = cell.node
    local info = data.info
    if info._user_key and info._is_mute ~= 1 then
      local userKey = info._user_key
      local panel = VideoPlayerReport.create({
        sid = userKey._svr_id,
        ui = userKey._uid,
        info = info
      })
      panel:popWindow()
    elseif info._is_mute == 1 then
      ed.showToast(T("\232\175\165\228\191\161\230\129\175\229\183\178\232\162\171\229\177\143\232\148\189"))
    end
  end
  
  function dlgt.cancelClickIn(cell)
    local data = cell.data
    local ui = data.ui
    ui.node_item:setScale(1)
  end
  
  function dlgt.cancelPressIn(cell)
    local data = cell.data
    local ui = data.ui
    ui.node_item:setScale(1)
  end
  
  local contentSize = self.ui.node_list:getContentSize()
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(0, 0, contentSize.width, contentSize.height),
    container = self.ui.node_list,
    touchpriority = -130,
    zorder = 10,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(-5, contentSize.height / 2)
    },
    dragMode = 1,
    colNum = 1
  }
  local tb_view = Tableview.create(param)
  self.curTableView = tb_view
end

function VideoPlayerBarrage:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    press = self.ui.btn_close_press,
    key = "btn_close",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end
