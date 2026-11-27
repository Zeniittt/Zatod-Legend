local chatServerMgr = {}
ed.ui.chatServerMgr = chatServerMgr
chatServerMgr.__index = chatServerMgr
local chatServerMgrSpace = {}

function chatServerMgr.create(params)
  local self = {}
  setmetatable(self, chatServerMgr)
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.params = params
  self:init()
  self.version = -1
  return self
end

function chatServerMgr:setVersion(version)
  self.version = version
end

function chatServerMgr:getVersion(version)
  return self.version
end

function chatServerMgr:init()
  self:createListView()
  self.btnlist = {}
  self.selectRoomItem = nil
end

function chatServerMgr:setHide(bool)
  self.ui.chatAllServer_bg:setVisible(not bool)
end

function chatServerMgr:createListView()
  local w, h = self.ui.chatAllServer_list_layer:getContentSize().width, self.ui.chatRoom_list_layer:getContentSize().height
  local info = {
    container = self.ui.chatAllServer_list_layer,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = false,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  self.draglist_info = info
  self.draglist = draglist
end

local clickRoomItem, pos

function chatServerMgr:touch(event, x, y)
  if event == "began" and ed.chatUtil:isHide(self.parentLogic.ui.chatAllServer_bg) then
    return
  end
  self.draglist:doListLayerTouch(event, x, y)
  if event == "began" then
    for key, roomItem in pairs(self.btnlist) do
      if ed.containsPoint(roomItem.ui.chat_server_btn, x, y) then
        clickRoomItem = roomItem
        clickRoomItem.ui.chat_server_btn:setScale(0.96)
        pos = ccp(x, y)
        return true
      end
    end
  elseif event == "ended" then
    if clickRoomItem then
      clickRoomItem.ui.chat_server_btn:setScale(1)
      if ed.containsPoint(clickRoomItem.ui.chat_server_btn, x, y) and math.abs(pos.y - y) < 5 then
        self:switchChatRoom(clickRoomItem)
      end
    end
    clickRoomItem = nil
  end
end

function chatServerMgr:switchChatRoom(roomItem)
  if not roomItem then
    return
  end
  if roomItem == self.selectRoomItem then
    return
  end
  if self.selectRoomItem then
    self.selectRoomItem.ui.chat_server_btn_press:setVisible(false)
  end
  self.selectRoomItem = roomItem
  self.selectRoomItem.ui.chat_server_btn_press:setVisible(true)
  local tmpRoomItem = self.selectRoomItem
  
  function ed.chatChangeChannelNetHandler()
    if not tmpRoomItem or not tmpRoomItem.data then
      return
    end
    ed.curChatServerTarget = {
      id = tmpRoomItem.data.id,
      name = tmpRoomItem.data.name
    }
    ed.storage.setValue("current_server_chat_channel", tostring(ed.curChatServerTarget.id))
    self.parentLogic:selectServerChannelObj()
  end
  
  ed.chatNetDataMrg:sendSubServerChatChannel(self.selectRoomItem.data.id)
end

function chatServerMgr:selectChannel(id)
  for k, roomItem in pairs(self.btnlist) do
    if roomItem.data.id == id then
      self:switchChatRoom(roomItem)
      return
    end
  end
end

function chatServerMgr:refreshRedTip()
  for _, roomItem in ipairs(self.btnlist) do
  end
end

function chatServerMgr:setChatChannels(channels)
  self.draglist:clearList()
  self.selectRoomItem = nil
  self.btnlist = {}
  local listheight = 0
  local posX = 2
  local posY = 420
  local itemHeight = 40
  for i, v in ipairs(channels) do
    local info = {}
    info.data = v
    local node, ui = ed.editorui(ed.uieditor.chatServerItem)
    info.ui = ui
    ui.lable_des:setString(v.name)
    ui["img_" .. (v.channel_color or "green")]:setVisible(true)
    node:setPosition(ccp(posX, posY - itemHeight * (i - 1)))
    listheight = listheight + itemHeight + 2
    self.draglist:addItem(node)
    self.btnlist[#self.btnlist + 1] = info
  end
  self.draglist:initListHeight(listheight)
end
