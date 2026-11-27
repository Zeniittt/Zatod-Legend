local base = ed.ui.popwindow
local sdkRightsDisplayWindow = newclass(base.mt)
ed.ui.sdkRightsDisplayWindow = sdkRightsDisplayWindow

function sdkRightsDisplayWindow.willOpen(param)
  if ed.isAreaOverSea() then
    return false
  end
  local firstOpen = ed.storage.getInt("sdkRightsDisplayWindow") ~= 1
  if firstOpen then
    ed.storage.setValue("sdkRightsDisplayWindow", 1)
    sdkRightsDisplayWindow.open(param)
    return true
  end
  return false
end

function sdkRightsDisplayWindow.open(param)
  sdkRightsDisplayWindow.create(param):popWindow(500)
end

function sdkRightsDisplayWindow.create(param)
  local self = base.create("sdkRightsDisplayWindow")
  setmetatable(self, sdkRightsDisplayWindow.mt)
  self.sureCallback = param and param.sureCallback or nil
  self:initView()
  return self
end

function sdkRightsDisplayWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.sdkRightsDisplayWindow)
  self.ui = ui
  self.container:addChild(container)
  self.ui.rithts_tips:setDimensions(ed.DGSizeMake(1203, 136))
  self:btRegisterButtonClick({
    button = self.ui.sureBtn,
    press = self.ui.sureBtn_press,
    key = "sureBtn",
    clickHandler = function()
      self:destroy()
      if self.sureCallback then
        self.sureCallback()
      end
    end,
    pressScale = 0.9,
    clickInterval = 0.5,
    force = true,
    priority = -1
  })
  self:initDragList()
end

function sdkRightsDisplayWindow:initDragList()
  local function doPressIn(listdata)
    local function handler(x, y)
      return false
    end
    
    return handler
  end
  
  local function doClickInList(listdata)
    local function handler(x, y, k)
    end
    
    return handler
  end
  
  local size = self.ui.content_rights:getContentSize()
  local itemSize = ed.DGSizeMake(609, 200)
  local param = {
    listData = ed.ui.sdkRightsSettingWindow.rightsList,
    createIconHandler = function(data)
      local container, ui = ed.editorui(ed.uieditor.rightsItem)
      ui.right_name:setString(data.name)
      ui.right_name:limitWidthByScale(225)
      local dlDesc = ed.UITool.createDraglist(ui.panel_desc, {priority = -300})
      local label_desc = ed.createLabelTTF(data.desc, 14)
      ed.setLabelColor(label_desc, ed.toccc3(16776423))
      local panel_size = ui.panel_desc:getContentSize()
      label_desc:setDimensions(CCSizeMake(panel_size.width, 0))
      label_desc:setHorizontalAlignment(kCCTextAlignmentLeft)
      label_desc:setAnchorPoint(ccp(0, 1))
      label_desc:setPosition(ccp(0, panel_size.height))
      dlDesc:addItem(label_desc)
      dlDesc:initListHeight(label_desc:getContentSize().height)
      ed.initSpriteWithFrame(ui.icon, data.icon)
      return container
    end,
    container = self.ui.content_rights,
    cliprect = CCRect(0, 0, size.width, size.height),
    doPressIn = doPressIn,
    doClickInList = doClickInList,
    icon_gap_x = itemSize.width,
    icon_gap_y = itemSize.height,
    icon_ori_x = 7,
    icon_ori_y = size.height - itemSize.height,
    colunNum = 2,
    touchpriority = -301,
    noshade = true
  }
  self.draglist = ed.fastCreateDragList(self, param)
end
