local chatRoomItem = {}
chatRoomItem.__index = chatRoomItem
ed.ui.chatRoomItem = chatRoomItem

function chatRoomItem.create(params)
  local self = {}
  setmetatable(self, chatRoomItem)
  self.params = params
  self.chatRoomType = self.params.type
  self.chatRoomID = nil
  self:init()
  return self
end

function chatRoomItem:init()
  self.ui = {}
  self.node = CCNode:create()
  ed.editorui(ed.uieditor.chatroomItem, {
    container = self.node,
    ui = self.ui
  })
  self.chatroomBtnDefaultSize = self.ui.chat_room_btn:getContentSize()
  self.chatroomBtnDefaultSize.height = self.chatroomBtnDefaultSize.height - 5
  self.chatitemBgDefaultSize = self.ui.item_bg:getContentSize()
  self.curHeight = 0
  self.isOpen = false
  self.memberData = {}
  self.roomName = self.params.name
  self.roomState = "close"
  self:setBtnState(false)
  self.ui.lable_des:setString(string.format(self.roomName, 0, 0))
  self.ui.exit_chatRoom_bg:setVisible(false)
end

function chatRoomItem:setChatRoomID(id)
  self.chatRoomID = id
end

function chatRoomItem:getChatRoomID(id)
  return self.chatRoomID
end

function chatRoomItem:setBtnState(bool)
  self.isOpen = bool
  if not self.isOpen then
    self.ui.item_bg:setVisible(false)
    self.ui.chat_room_btn_press:setVisible(false)
    self:setLableSelectState(false)
  else
    self.ui.item_bg:setVisible(true)
    self:setLableSelectState(true)
    self.ui.chat_room_btn_press:setVisible(true)
  end
  self:refreshRedTip()
end

function chatRoomItem:getHeight()
  if self.isOpen then
    return self.ui.item_bg:getContentSize().height + self.chatroomBtnDefaultSize.height - 5
  else
    return self.chatroomBtnDefaultSize.height
  end
end

function chatRoomItem:getRoomState()
  return self.roomState
end

function chatRoomItem:getExitBtn()
  if self.roomState == "open" then
    return self.ui.btn_exit_chatRoom
  else
    return nil
  end
end

function chatRoomItem:getAllData()
  return self.memberData
end

function chatRoomItem:clear()
  for _, v in ipairs(self.memberData) do
    local node = v.itemNode
    if node and node:getParent() then
      node:removeFromParentAndCleanup(true)
    end
  end
  self.memberData = {}
end

function chatRoomItem:refreshMember(data)
  local data = data or {}
  if 0 < #data then
    local dl_data = {}
    local use_data = {}
    for _, itemData in ipairs(self.memberData) do
      local is_dl = false
      for _, v in ipairs(data) do
        if itemData.extraData.roleId == v.roleId then
          is_dl = true
        end
      end
      if is_dl then
        table.insert(dl_data, itemData)
      else
        table.insert(use_data, itemData)
      end
    end
    for _, v in ipairs(dl_data) do
      local node = v.itemNode
      if node and node:getParent() then
        node:removeFromParentAndCleanup(true)
      end
    end
    self.memberData = use_data
    for k, info in pairs(data) do
      self:addContact(info)
    end
  else
    for _, v in ipairs(self.memberData) do
      local node = v.itemNode
      if node and node:getParent() then
        node:removeFromParentAndCleanup(true)
      end
    end
    self.memberData = {}
  end
  self:refreshUILayout()
  self:refreshLableNum()
end

function chatRoomItem:setFriendflag(friendFlag)
  self.friendFlag = friendFlag
end

function chatRoomItem:removeMember(del_data)
  for _, v in ipairs(del_data) do
    local index
    for i, item in ipairs(self.memberData) do
      if item.extraData.roleId == v._role_id then
        index = i
        local node = item.itemNode
        if node and node:getParent() then
          node:removeFromParentAndCleanup(true)
        end
        break
      end
    end
    if index then
      table.remove(self.memberData, index)
    end
  end
  self:refreshUILayout()
  self:refreshLableNum()
end

function chatRoomItem:refreshUILayout()
  self.ui.lable_tip:setVisible(false)
  if #self.memberData <= 0 then
    self.ui.lable_tip:setVisible(true)
    self.ui.exit_chatRoom_bg:setVisible(false)
    self.ui.item_bg:setContentSize(self.chatitemBgDefaultSize)
    self.ui.item_bg_height = self.chatitemBgDefaultSize.height
    self.roomState = "close"
  else
    self.ui.exit_chatRoom_bg:setVisible(true)
    local height = (self.memberData[1].params.height + 5) * #self.memberData + 30 + self.ui.exit_chatRoom_bg:getContentSize().height
    self.ui.item_bg_height = height
    self.ui.item_bg:setContentSize(CCSizeMake(self.chatitemBgDefaultSize.width, height))
    self.curItemHeight = 10
    for i, itemData in ipairs(self.memberData) do
      local params = itemData.params
      local itemNode = itemData.itemNode
      itemNode:setPosition(ccp(5, height - self.curItemHeight))
      self.curItemHeight = self.curItemHeight + params.height + 5
    end
    self.ui.exit_chatRoom_bg:setPosition(ccp(5, height - self.curItemHeight))
    self.roomState = "open"
  end
end

function chatRoomItem:addContact(data)
  local objs = self.memberData or {}
  local item, info
  for _, itemData in ipairs(objs) do
    if itemData.extraData.roleId == data.roleId then
      item = itemData
      info = data
      break
    end
  end
  if item then
    local ui = item.ui
    ui.lable_name:setString(info.summary._name)
    if item.extraData.isOnline ~= info.isOnline then
      item.extraData.isOnline = info.isOnline
      self:setHeadOnlineState(ui, item.extraData.isOnline)
    end
  else
    self:createItemUI(data)
  end
end

function chatRoomItem:setHeadOnlineState(ui, onlineState)
  local headIcon = ui.headIcon
  if onlineState == 1 then
    ed.chatUtil:resetAllNodeStone(headIcon)
  else
    ed.chatUtil:setAllNodeStone(headIcon)
  end
end

function chatRoomItem:createItemUI(data)
  local sp = CCSprite:create()
  local ui = {}
  ed.editorui(ed.uieditor.chatPlayerHeadItem, {container = sp, ui = ui})
  local extraData = data
  local width, height = ui.head_bg:getContentSize().width, ui.head_bg:getContentSize().height
  local params = {width = width, height = height}
  self:createHeadIcon(ui, data)
  ui.redPoint:setVisible(false)
  local data = {
    ui = ui,
    itemNode = sp,
    extraData = extraData,
    params = params
  }
  table.insert(self.memberData, data)
  self.ui.item_bg:addChild(sp)
end

function chatRoomItem:refreshLableNum()
  self.memberData = self.memberData or {}
  local online = 0
  for i, data in ipairs(self.memberData) do
    if data.extraData.isOnline == 1 then
      online = online + 1
    end
  end
  self.ui.lable_des:setString(string.format(self.roomName, online, #self.memberData))
end

function chatRoomItem:createHeadIcon(ui, data)
  local speakerSummary = data.summary
  local param = {
    id = speakerSummary._avatar
  }
  local headIcon = ed.getWholeHeadIcon(param)
  headIcon:setScale(0.5)
  headIcon:setPosition(ccp(22, 23.5))
  ui.head_bg:addChild(headIcon, 10)
  ui.lable_name:setString(speakerSummary._name)
  ui.headIcon = headIcon
  self:setHeadOnlineState(ui, data.isOnline)
end

function chatRoomItem:setLableSelectState(isSelect)
  if isSelect then
    self.ui.lable_des:setColor(ccc3(212, 211, 116))
  else
    self.ui.lable_des:setColor(ccc3(223, 224, 221))
  end
end

function chatRoomItem:refreshRedTip()
  if self.isOpen then
    ed.chatNetDataMrg.chatRoomlNotify[self.chatRoomType] = 0
    self.ui.redPoint:setVisible(false)
  else
    local num = ed.chatNetDataMrg.chatRoomlNotify[self.chatRoomType] or 0
    if 0 < num then
      self.ui.redPoint:setVisible(true)
      self.ui.msg_num:setString(tostring(num))
    end
  end
end
