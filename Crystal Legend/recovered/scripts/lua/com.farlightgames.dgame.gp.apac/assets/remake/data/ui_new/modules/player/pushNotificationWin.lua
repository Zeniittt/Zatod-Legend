local base = ed.ui.popwindow
local pushNotificationWin = newclass(base.mt)
ed.ui.pushNotificationWin = pushNotificationWin
local CLIENT_NOTIFICATION = 1
local SERVER_NOTIFICATION = 2
local notificationOption = {
  {
    text = T("9:00\231\153\190\232\180\167\229\149\134\229\186\151\229\136\183\230\150\176"),
    visible = true,
    notifyId = 4,
    type = CLIENT_NOTIFICATION
  },
  {
    text = T("21:00\231\153\190\232\180\167\229\149\134\229\186\151\229\136\183\230\150\176"),
    visible = true,
    notifyId = 5,
    type = CLIENT_NOTIFICATION
  },
  {
    text = T("12:00\229\141\136\233\164\144\233\162\134\229\143\150"),
    visible = true,
    notifyId = 1,
    type = CLIENT_NOTIFICATION
  },
  {
    text = T("18:00\230\153\154\233\164\144\233\162\134\229\143\150"),
    visible = true,
    notifyId = 2,
    type = CLIENT_NOTIFICATION
  },
  {
    text = T("\228\189\147\229\138\155\229\155\158\229\164\141\230\187\161\233\128\154\231\159\165"),
    visible = false,
    notifyId = 3,
    type = CLIENT_NOTIFICATION
  },
  {
    text = T("\231\171\158\230\138\128\229\156\186\232\162\171\230\148\187\229\135\187"),
    visible = false,
    notifyId = 7,
    type = SERVER_NOTIFICATION
  },
  {
    text = T("\231\167\129\232\129\138\230\182\136\230\129\175\233\128\154\231\159\165"),
    visible = false,
    notifyId = 10,
    type = SERVER_NOTIFICATION
  }
}

local function setSwitch(index)
  local settingConfig = notificationOption[index]
  local notifyId = settingConfig.notifyId
  local notifyIdList = {}
  if type(notifyId) == "table" then
    notifyIdList = notifyId
  else
    notifyIdList = {notifyId}
  end
  for _, notifyId in ipairs(notifyIdList) do
    EDLog("doClickSwitch:" .. notifyId)
    if settingConfig.type == SERVER_NOTIFICATION then
      if not ed.localnotify.settingTable then
        ed.localnotify.settingTable = {}
      end
      local item = ed.localnotify.settingTable[notifyId]
      if nil == item then
        ed.localnotify.settingTable[notifyId] = true
      elseif ed.localnotify.settingTable[notifyId] then
        ed.localnotify.settingTable[notifyId] = false
      else
        ed.localnotify.settingTable[notifyId] = true
      end
      local msg = ed.upmsg.system_setting()
      msg._change = {}
      msg._change.key = tostring(notifyId)
      if ed.localnotify.settingTable[notifyId] then
        msg._change.value = "on"
      else
        msg._change.value = "off"
      end
      ed.send(msg, "system_setting")
    else
      ed.localnotify.setSwitch(notifyId)
    end
  end
end

local function getSwitchState(index)
  local settingConfig = notificationOption[index]
  local notifyId = settingConfig.notifyId
  if type(notifyId) == "table" then
    notifyId = notifyId[1]
  end
  if settingConfig.type == SERVER_NOTIFICATION then
    local isRet = true
    if not ed.localnotify.settingTable then
      ed.localnotify.settingTable = {}
    end
    local item = ed.localnotify.settingTable[notifyId]
    if nil == item then
      ed.localnotify.settingTable[notifyId] = true
    else
      isRet = ed.localnotify.settingTable[notifyId]
    end
    return isRet
  else
    return ed.localnotify.getSwitch(notifyId)
  end
end

function pushNotificationWin.create()
  local self = base.create("pushNotificationWin")
  setmetatable(self, pushNotificationWin.mt)
  self:init()
  return self
end

function pushNotificationWin:init()
  self:initView()
  self:addEventListener()
end

function pushNotificationWin:initView()
  local container, ui = ed.editorui(ed.uieditor.pushNotification)
  self.ui = ui
  self.container:addChild(container)
  self:initDragList()
  self:refreshDraglist()
end

function pushNotificationWin:initDragList()
  local posX, posY = self.ui.option_panel:getPosition()
  local optionPanelSize = self.ui.option_panel:getContentSize()
  local info = {
    cliprect = CCRectMake(posX, posY, optionPanelSize.width, optionPanelSize.height),
    noshade = true,
    container = self.container,
    priority = self.mainTouchPriority - 5,
    zorder = 1,
    mcpMode = true,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  local dragList = ed.draglist.create(info)
  self.dragList = dragList
end

function pushNotificationWin:doPressInList()
  local function handler(x, y)
    for index, container in pairs(self.itemData) do
      if ed.containsPoint(container.ui.switch_setting_bg, x, y) then
        setSwitch(index)
        
        local open = getSwitchState(index)
        container.ui.close_setting_bg:setVisible(not open)
        container.ui.btn_setting:setPositionX(open and 34.5 or 13)
      end
    end
    if self.doPress then
      return self:doPress(x, y)
    end
  end
  
  return handler
end

function pushNotificationWin:doClickInList()
  local function handler(x, y, k, i)
    if self.doClick then
      return self:doClick(x, y, k, i)
    end
  end
  
  return handler
end

function pushNotificationWin:cancelPressInList()
  local function handler(x, y, k, i)
    if self.cancelPress then
      return self:cancelPress(x, y, k, i)
    end
  end
  
  return handler
end

function pushNotificationWin:cancelClickInList()
  local function handler(x, y, k, i)
    if self.cancelClick then
      return self:cancelClick(x, y, k, i)
    end
  end
  
  return handler
end

function pushNotificationWin:refreshDraglist()
  local totalHeight = 0
  self.itemData = {}
  for index = 1, #notificationOption do
    local settingConfig = notificationOption[index]
    if settingConfig.visible then
      local open = getSwitchState(index)
      local container, ui = ed.editorui(ed.uieditor.pushNotificationItem)
      container.ui = ui
      local bgSize = ui.notification_setting:getContentSize()
      local gapY = 3
      container.width = bgSize.width
      container.height = bgSize.height
      ui.notification_text:setString(settingConfig.text)
      ui.close_setting_bg:setVisible(not open)
      ui.btn_setting:setPositionX(open and 34.5 or 13)
      container:setPositionY(-totalHeight)
      totalHeight = totalHeight + container.height + gapY
      self.itemData[index] = container
      self.dragList:addItem(container)
      self.dragList:initListHeight(totalHeight)
    end
  end
end

function pushNotificationWin:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    press = self.ui.btn_close_press,
    key = "btn_close",
    clickHandler = function()
      self:close()
    end
  })
end

function pushNotificationWin:close()
  self:destroy()
end
