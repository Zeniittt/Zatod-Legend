local chatRoomMgr = {}
ed.ui.chatRoomMgr = chatRoomMgr
chatRoomMgr.__index = chatRoomMgr
local chatRoomMgrSpace = {}

function chatRoomMgr.create(params)
  local self = {}
  setmetatable(self, chatRoomMgr)
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.params = params
  self:init()
  self.version = -1
  return self
end

function chatRoomMgr:init()
  self:createListView()
  self.btnlist = {}
  self.selectRoomItem = nil
  self.roomTypeTbl = {
    [1] = {
      type = "multi_stage_talk",
      name = "\229\139\135\232\128\133\228\185\139\228\185\166(%d/%d)"
    },
    [2] = {
      type = "multi_arena",
      name = "\232\175\184\231\165\158\229\175\185\229\134\179(%d/%d)"
    },
    [3] = {
      type = "dreamland",
      name = "\230\176\184\231\148\159\230\162\166\229\162\131(%d/%d)"
    }
  }
  self:initChatRoomItem()
end

function chatRoomMgr:setHide(bool)
  self.ui.chatRoom_bg:setVisible(not bool)
end

function chatRoomMgr:createListView()
  local w, h = self.ui.chatRoom_list_layer:getContentSize().width, self.ui.chatRoom_list_layer:getContentSize().height
  local info = {
    container = self.ui.chatRoom_list_layer,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = false,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  self.draglist_info = info
  self.draglist = draglist
end

function chatRoomMgr:initChatRoomItem()
  for i, data in ipairs(self.roomTypeTbl) do
    local roomItem = ed.ui.chatRoomItem.create(data)
    table.insert(self.btnlist, roomItem)
    self.draglist:addItem(roomItem.node)
  end
  self:refreshListHegiht()
end

function chatRoomMgr:refreshRoomData()
  self.version = ed.chatNetDataMrg.chatroomVersion
  for i, roomItem in ipairs(self.btnlist) do
    local type = roomItem.chatRoomType
    local data = ed.chatNetDataMrg.chatroomData[type]
    roomItem:clear()
    if data then
      roomItem:setFriendflag(data.friendflag)
      roomItem:refreshMember(data.memberData)
      roomItem:setChatRoomID(data.group_id)
    end
  end
  self:refreshListHegiht()
  if self.selectRoomItem then
    ed.curChatRoomTarget = {
      type = self.selectRoomItem.chatRoomType,
      id = self.selectRoomItem:getChatRoomID(),
      state = self.selectRoomItem:getRoomState()
    }
    self.parentLogic:selectchatRoomObj()
  end
end

function chatRoomMgr:refreshListHegiht()
  local height = self.ui.chatRoom_list_layer:getContentSize().height
  local maxHeight = 0
  for i, roomItem in ipairs(self.btnlist) do
    local itemHeight = roomItem:getHeight()
    roomItem.node:setPosition(ccp(1, height - maxHeight))
    maxHeight = maxHeight + itemHeight
  end
  self.draglist:initListHeight(maxHeight)
end

local clickRoomItem, pos

function chatRoomMgr:touch(event, x, y)
  if event == "began" and ed.chatUtil:isHide(self.parentLogic.ui.chatRoom_bg) then
    return
  end
  self:touchObjs(event, x, y)
  self.draglist:doListLayerTouch(event, x, y)
  if event == "began" then
    for key, roomItem in pairs(self.btnlist) do
      if ed.containsPoint(roomItem.ui.chat_room_btn, x, y) then
        clickRoomItem = roomItem
        pos = ccp(x, y)
        return true
      end
    end
  elseif event == "ended" then
    if clickRoomItem and ed.containsPoint(clickRoomItem.ui.chat_room_btn, x, y) and math.abs(pos.y - y) < 5 then
      self:switchChatRoom(clickRoomItem)
    end
    clickRoomItem = nil
  end
end

function chatRoomMgr:switchChatRoom(roomItem)
  if roomItem == self.selectRoomItem then
    return
  end
  if self.selectRoomItem then
    self.selectRoomItem:setBtnState(false)
  end
  self.selectRoomItem = roomItem
  self.selectRoomItem:setBtnState(true)
  self:refreshListHegiht()
  ed.curChatRoomTarget = {
    type = self.selectRoomItem.chatRoomType,
    id = self.selectRoomItem:getChatRoomID(),
    state = self.selectRoomItem:getRoomState()
  }
  self.parentLogic:selectchatRoomObj()
end

function chatRoomMgr:selectRoomType(type)
  for k, roomItem in pairs(self.btnlist) do
    if roomItem.chatRoomType == type then
      self:switchChatRoom(roomItem)
      return
    end
  end
end

local exit_btn_press

function chatRoomMgr:touchExitRoom(event, x, y)
  if not self.selectRoomItem then
    return
  end
  local exit_btn = self.selectRoomItem:getExitBtn()
  if not exit_btn then
    return
  end
  if event == "began" then
    if ed.containsPoint(exit_btn, x, y) then
      exit_btn:setScale(0.95)
      exit_btn_press = true
    end
  elseif event == "ended" then
    if exit_btn_press then
      if ed.containsPoint(exit_btn, x, y) then
        self:sendExitRoomMsg()
      end
      exit_btn:setScale(1)
    end
    exit_btn_press = nil
  end
end

function chatRoomMgr:touchObjs(event, x, y)
  if not self.selectRoomItem then
    return
  end
  if event == "began" then
    self.touchPos = ccp(x, y)
  elseif event == "ended" and self.touchPos then
    local dis = math.abs(self.touchPos.y - y)
    local exit_btn = self.selectRoomItem:getExitBtn()
    if exit_btn then
      exit_btn:setScale(1)
    end
    if 10 < dis then
      return
    end
  end
  self:touchExitRoom(event, x, y)
  local objs = self.selectRoomItem:getAllData() or {}
  for _, itemData in ipairs(objs) do
    local headIcon = itemData.ui.head_bg
    if event == "began" then
      if ed.containsPoint(headIcon, x, y) then
        self.touchHeadIcon = {
          headIcon,
          itemData.extraData
        }
      end
    elseif event == "ended" and self.touchHeadIcon and ed.containsPoint(self.touchHeadIcon[1], x, y) then
      local data = self.touchHeadIcon[2]
      self.touchHeadIcon = nil
      if ed.getRoleId() ~= data.roleId then
        ed.PlayerInfoNetwork:requestHomePage(data.sid, data.uid)
      else
        ed.PlayerInfoNetwork:openPanel()
      end
    end
  end
end

function chatRoomMgr:sendExitRoomMsg()
  local type = self.selectRoomItem.chatRoomType
  local id = self.selectRoomItem:getChatRoomID()
  
  function ed.netreply.exitRoomHandler()
    self.selectRoomItem:refreshMember({})
    self.selectRoomItem:setChatRoomID(nil)
    self:refreshListHegiht()
    ed.curChatRoomTarget = {
      type = self.selectRoomItem.chatRoomType,
      id = self.selectRoomItem:getChatRoomID(),
      state = self.selectRoomItem:getRoomState()
    }
    self.parentLogic:selectchatRoomObj()
    ed.showToast("\233\128\128\229\135\186\232\129\138\229\164\169\229\174\164\230\136\144\229\138\159")
  end
  
  if type and id then
    ed.chatNetDataMrg:sendExitRoom(type, id)
  end
end

function chatRoomMgr:exitRoomMember(data)
  local type = data._chat_group_type
  local id = data._chat_group_id
  local memberdata = data._group_user
  local roomItem
  for i, room in ipairs(self.btnlist) do
    if room.chatRoomType == type and room:getChatRoomID() == id then
      roomItem = room
      break
    end
  end
  if roomItem then
    roomItem:removeMember(memberdata)
  end
  self:refreshListHegiht()
end

function chatRoomMgr:refreshRedTip()
  for _, roomItem in ipairs(self.btnlist) do
    roomItem:refreshRedTip()
  end
end
