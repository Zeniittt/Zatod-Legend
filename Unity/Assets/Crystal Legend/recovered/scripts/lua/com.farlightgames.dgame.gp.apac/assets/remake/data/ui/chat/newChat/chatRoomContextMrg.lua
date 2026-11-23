local chatRoomContextMrg = {}
ed.ui.chatRoomContextMrg = chatRoomContextMrg
chatRoomContextMrg.__index = chatRoomContextMrg
ed.curRoomTarget = nil

function chatRoomContextMrg.create(params)
  local self = {}
  setmetatable(self, chatRoomContextMrg)
  self.params = params
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.eventSpace = {}
  self.selectContextView = nil
  self.isnoSelect = false
  self.chatContextViewList = {
    multi_stage_talk = {},
    dreamland = {},
    multi_arena = {}
  }
  self.curChannel = "chatroom_channel"
  return self
end

function chatRoomContextMrg:setHide(bool)
  if self.selectContextView then
    self.selectContextView:setHide(bool)
  else
  end
  if self.autoText then
    self.autoText.node:setVisible(not bool)
  end
  if bool then
    self:stopRefreshMessage()
    self.parentLogic.ui.lable_msg_room:setVisible(false)
  else
    self:startRefreshMessage()
  end
end

function chatRoomContextMrg:startRefreshMessage()
  ListenTimer(Timer:Always(0.02), self:refreshMessage(), self.eventSpace)
end

function chatRoomContextMrg:stopRefreshMessage()
  if self.eventSpace then
    CloseScope(self.eventSpace)
  end
end

function chatRoomContextMrg:touch(event, x, y)
  if not self.selectContextView then
    return
  end
  xpcall(function()
    self.selectContextView:touch(event, x, y)
  end, EDDebug)
end

function chatRoomContextMrg:refreshMessage()
  local function handler()
    xpcall(function()
      if not ed.curChatRoomTarget then
        return
      end
      local type = ed.curChatRoomTarget.type
      local chatMessages = ed.chatNetDataMrg.chatMessages.chatroom_channel[type] or {}
      for i = 1, 5 do
        if chatMessages[1] then
          self:addChatItem(chatMessages[1], type)
          table.remove(chatMessages, 1)
        end
      end
    end, EDDebug)
  end
  
  return handler
end

function chatRoomContextMrg:addChatItem(data, type)
  local viewList = self.chatContextViewList[type]
  local group_id = data._chat_group_id
  if not viewList[tostring(group_id)] then
    viewList[tostring(group_id)] = ed.ui.chatContext.new({
      parentLogic = self.parentLogic
    })
    viewList[tostring(group_id)]:setChannel("chatroom_channel")
    viewList[tostring(group_id)]:setHide(true, true)
  end
  viewList[tostring(group_id)]:addChatItem(data)
end

function chatRoomContextMrg:setCurSelectTarget(target)
  if not target then
    return
  end
  local type = target.type
  local group_id = target.id
  local viewList = self.chatContextViewList[type]
  if not viewList[tostring(group_id)] then
    viewList[tostring(group_id)] = ed.ui.chatContext.new({
      parentLogic = self.parentLogic
    })
    viewList[tostring(group_id)]:setChannel("chatroom_channel")
    viewList[tostring(group_id)]:setHide(true, true)
  end
  if self.selectContextView then
    self.selectContextView:setHide(true, true)
    self.selectContextView = nil
  end
  self.selectContextView = viewList[tostring(group_id)]
  self.selectContextView:setHide(false, true)
  ed.chatNetDataMrg:anonRefresh()
end

function chatRoomContextMrg:switchChatRoom(roomData)
  self.isnoSelect = true
  if self.selectContextView then
    self.selectContextView:setHide(true, true)
    self.selectContextView = nil
  end
  if self.autoText then
    self.autoText.node:removeFromParentAndCleanup(true)
    self.autoText = nil
  end
  self.parentLogic.ui.lable_msg_room:setVisible(false)
  if not roomData then
    self.parentLogic.ui.lable_msg_room:setVisible(true)
  elseif roomData.state == "close" then
    self:createTipText(roomData.type)
  else
    self:setCurSelectTarget(roomData)
  end
end

local des_tip = {
  multi_stage_talk = "\229\139\135\232\128\133\228\185\139\228\185\166",
  dreamland = "\230\176\184\231\148\159\230\162\166\229\162\131\229\144\136\228\189\156\230\168\161\229\188\143",
  multi_arena = "\232\175\184\231\165\158\229\175\185\229\134\179"
}

function chatRoomContextMrg:createTipText(type)
  local text = "\230\154\130\230\156\170\229\143\130\229\138\160<lable color=headlineGreen>\"%s\"</lable>,\232\191\155\232\161\140\228\184\128\232\189\174\230\184\184\230\136\143\229\141\179\229\143\175\229\146\140\229\176\143\233\152\159\231\154\132\228\188\153\228\188\180\228\187\172\231\149\133\232\129\138\228\186\134"
  text = string.format(text, des_tip[type])
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    color = ccc3(215, 172, 34),
    fontSize = 16,
    maxWidth = 400
  })
  local _, height = autoText:getContentSize()
  autoText.node:setPosition(ccp(55, 200 + height * 0.5))
  self.parentLogic.ui.msg_layer:addChild(autoText.node)
  self.autoText = autoText
end

function chatRoomContextMrg:updateData()
  local removeTbl = {}
  for type, list in pairs(self.chatContextViewList) do
    removeTbl[type] = {}
    local isAll = true
    if ed.chatNetDataMrg.chatroomData[type] then
      isAll = false
    end
    for id, v in pairs(list) do
      if not isAll then
        if tonumber(id) ~= ed.chatNetDataMrg.chatroomData[type].group_id then
          table.insert(removeTbl[type], id)
        end
      else
        table.insert(removeTbl[type], id)
      end
    end
  end
  for type, data in pairs(removeTbl) do
    local list = self.chatContextViewList[type]
    for i, id in ipairs(data) do
      if self.selectContextView == list[id] then
        self.selectContextView = nil
      end
      list[id]:onDestory()
      list[id] = nil
    end
    self.chatContextViewList[type] = list
  end
end

function chatRoomContextMrg:tipExitRoomMemberInfo(data)
  local type = data._chat_group_type
  local group_id = data._chat_group_id
  local memberdata = data._group_user
  local viewList = self.chatContextViewList[type]
  if not viewList[tostring(group_id)] then
    viewList[tostring(group_id)] = ed.ui.chatContext.new({
      parentLogic = self.parentLogic
    })
    viewList[tostring(group_id)]:setChannel("chatroom_channel")
    viewList[tostring(group_id)]:setHide(true, true)
  end
  local chatroomData = ed.chatNetDataMrg.chatroomData[type] or {}
  chatroomData = chatroomData.memberData
  if chatroomData then
    for i, v in ipairs(memberdata) do
      local itemData
      for _, info in ipairs(chatroomData) do
        if v._target_role_id == info.roleId then
          itemData = info
          break
        end
      end
      if itemData then
        local name_str = itemData.summary._name or ""
        viewList[tostring(group_id)]:addTipMsg(string.format("%s \231\166\187\229\188\128\228\186\134\232\129\138\229\164\169\229\174\164", name_str))
      end
    end
  end
end
