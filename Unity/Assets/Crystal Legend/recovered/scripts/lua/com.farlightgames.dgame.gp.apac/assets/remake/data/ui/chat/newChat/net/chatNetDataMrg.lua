local chatNetDataMrg = {}
ed.chatNetDataMrg = chatNetDataMrg
chatNetDataMrg.__index = chatNetDataMrg
local chatNetSpace = {}
local chatEvent = ed.chatEvent.eventType
ed.chatNetDataMrg.notifyPrivateCount = 0
ed.chatNetDataMrg.notifyChatRoomCount = 0
ed.chatNetDataMrg.notifyGuildHeroTaskCount = 0
chatNetDataMrg.chatContactVersion = 0
chatNetDataMrg.chatroomVersion = 0
chatNetDataMrg.chatMessages = {
  world_channel = {},
  guild_channel = {},
  personal_channel = {},
  chatroom_channel = {}
}
chatNetDataMrg.contactData = {
  contact = {
    data = {},
    num = 0
  },
  friend = {
    data = {},
    num = 0
  },
  guild = {
    data = {},
    num = 0
  }
}
chatNetDataMrg.chatroomData = {}
chatNetDataMrg.bFirtPay = true
chatNetDataMrg.lastWorldChatTime = nil
chatNetDataMrg.defaultInternal = 2
chatNetDataMrg.maxInternal = 15
chatNetDataMrg.refreshInternal = chatNetDataMrg.defaultInternal
chatNetDataMrg.refreshChatEvent = nil
chatNetDataMrg.isCanRefreshNetChatMsg = true
ed.chatServerMsgID = 0
ed.chatNetDataMrg.chatServerData = {}
chatNetDataMrg.applyFriendList = {}
chatNetDataMrg.recommendFriendList = {}

function chatNetDataMrg:starChatNet()
  self:openNetListen()
end

function chatNetDataMrg:registerEvent()
  ListenEvent(chatEvent.ChatRsp, self:OnChatRsp(), chatNetSpace)
  ListenEvent(chatEvent.ChatNotifyData, self:OnChatNotifyRsp(), chatNetSpace)
  ListenEvent(chatEvent.PrivateChat_l, self:chatLong(), chatNetSpace)
  ListenEvent("channelMsgEvent", self:allServerChatHandler(), chatNetSpace)
end

function chatNetDataMrg:allServerChatHandler()
  local function handler(datas)
    local datas = datas or {}
    
    if 1 < #datas then
      table.sort(datas, function(a, b)
        return a.timestamp < b.timestamp
      end)
    end
    local isChord = false
    for i, data in ipairs(datas) do
      ed.chatNetDataMrg.chatServerData[data.channel_id] = ed.chatNetDataMrg.chatServerData[data.channel_id] or {
        msg = {},
        msg_id = 0
      }
      local channelData = ed.chatNetDataMrg.chatServerData[data.channel_id]
      channelData.msg[#channelData.msg + 1] = data
      channelData.msg_id = data.msg_id
      if not ed.curChatServerTarget or ed.curChatServerTarget.id ~= data.channel_id then
        isChord = true
      end
      if #channelData.msg > 50 then
        table.remove(channelData.msg, 1)
      end
    end
    if ed.debug_mode and isChord then
      ed.showToast(T("\229\189\147\229\137\141\230\182\136\230\129\175\228\184\141\229\177\158\228\186\142\229\189\147\229\137\141\233\162\145\233\129\147"))
    end
  end
  
  return handler
end

function chatNetDataMrg:openNetListen()
  self:registerEvent()
end

function chatNetDataMrg:closeNetListen()
  CloseScope(chatNetSpace)
end

function chatNetDataMrg:closeReqChatMsg()
  if self.chatReqNetSpace then
    CloseScope(self.chatReqNetSpace)
    self.chatReqNetSpace = nil
  end
end

function chatNetDataMrg:startReqChatMsg(time)
  self:closeReqChatMsg()
  self.chatReqNetSpace = {}
  self.refreshInternal = self.defaultInternal
  ListenTimer(Timer:Once(time or 0.5), self:reqChatMessage(), self.chatReqNetSpace)
  self.refreshChatEvent = ListenTimer(Timer:Always(self.refreshInternal), self:reqChatMessage(), self.chatReqNetSpace)
end

function chatNetDataMrg:anonRefresh()
  self:startReqChatMsg(0.1)
end

ed.chatNetDataMrg.personalNotify = {}
ed.chatNetDataMrg.chatRoomlNotify = {}
local isFrist = true

function chatNetDataMrg:chatLong()
  local function handler(data)
    local data = data
    
    local isCanNotice = true
    local uid, sid, key, roleId
    if ed.blacklist.isInBlacklist(data._contents._speaker_role_id) then
      return
    end
    if data._channel == "personal_channel" then
      roleId = data._contents._speaker_role_id
      key = ed.chatUtil:getUserKey(roleId)
      local num = ed.chatNetDataMrg.personalNotify[key] or 0
      if not string.find(data._contents._content or "", T("\233\130\128\232\175\183\228\189\160\229\141\143\229\138\169\229\133\172\228\188\154\232\139\177\233\155\132\229\135\186\229\135\187")) then
        ed.chatNetDataMrg.personalNotify[key] = num + 1
        ed.chatNetDataMrg.notifyPrivateCount = ed.chatNetDataMrg.notifyPrivateCount + 1
      else
        isCanNotice = false
      end
      isFrist = false
      local info = {
        roleId = data._contents._speaker_role_id,
        summary = data._contents._speaker_summary,
        server_name = data._contents._speaker_server_name,
        isOnline = 1
      }
      roleId = data._contents._speaker_role_id
      key = ed.chatUtil:getUserKey(roleId)
      if not chatNetDataMrg.contactData.contact.data[key] and isCanNotice then
        chatNetDataMrg.contactData.contact.num = chatNetDataMrg.contactData.contact.num + 1
        chatNetDataMrg.contactData.contact.data[key] = info
      end
      if isCanNotice then
        FireEvent("NoticeToPrivate", info)
      end
    elseif data._channel == "chatroom_channel" and data._contents._speaker_role_id ~= ed.getRoleId() then
      ed.chatNetDataMrg.notifyChatRoomCount = ed.chatNetDataMrg.notifyChatRoomCount + 1
      ed.chatNetDataMrg.chatRoomlNotify[data._contents._chat_group_type] = ed.chatNetDataMrg.chatRoomlNotify[data._contents._chat_group_type] or 0
      ed.chatNetDataMrg.chatRoomlNotify[data._contents._chat_group_type] = ed.chatNetDataMrg.chatRoomlNotify[data._contents._chat_group_type] + 1
      FireEvent("NoticeToChatRoom", info)
    end
    FireEvent(chatEvent.NoticeToPrivateChatTipView, data)
  end
  
  return handler
end

function chatNetDataMrg:OnChatNotifyRsp()
  local function handler(notifyData)
    if nil == notifyData then
      return
    end
    if isFrist then
      isFrist = false
      local num = 0
      if notifyData._person_chat_info and 0 < #notifyData._person_chat_info then
        for i, v in ipairs(notifyData._person_chat_info) do
          local roleId = v._role_id
          local chat_count = v._chat_count
          num = num + chat_count
          local key = ed.chatUtil:getUserKey(roleId)
          if not ed.chatNetDataMrg.personalNotify[key] then
            ed.chatNetDataMrg.personalNotify[key] = 0
          end
          ed.chatNetDataMrg.personalNotify[key] = ed.chatNetDataMrg.personalNotify[key] + chat_count
        end
        ed.chatNetDataMrg.notifyPrivateCount = self:getAllPrivateCount()
      end
      if 0 < num then
        FireEvent(chatEvent.NoticeToNewChatView, num)
      end
    else
    end
  end
  
  return handler
end

function chatNetDataMrg:getUnreadMsgHandler(notifyData)
  if nil == notifyData then
    return
  end
  local num = 0
  if notifyData._person_chat_info and 0 < #notifyData._person_chat_info then
    for i, v in ipairs(notifyData._person_chat_info) do
      local roleId = v._role_id
      local chat_count = v._chat_count
      num = num + chat_count
      local key = ed.chatUtil:getUserKey(roleId)
      if not ed.chatNetDataMrg.personalNotify[key] then
        ed.chatNetDataMrg.personalNotify[key] = 0
      end
      ed.chatNetDataMrg.personalNotify[key] = chat_count
    end
    ed.chatNetDataMrg.notifyPrivateCount = self:getAllPrivateCount()
  end
  if 0 < num then
    FireEvent("NoticeUpdateMsg", num)
  end
end

function chatNetDataMrg:getAllPrivateCount()
  local amount = 0
  ed.chatNetDataMrg.personalNotify = ed.chatNetDataMrg.personalNotify or {}
  for k, v in pairs(ed.chatNetDataMrg.personalNotify) do
    amount = amount + v
  end
  return amount
end

function chatNetDataMrg:notifyUpdateDialogueOrder(data)
  local info = data._contents or {}
  for i, v in ipairs(info) do
    local roleId = v._target_role_id
    local key = ed.chatUtil:getUserKey(roleId)
    local info = chatNetDataMrg.contactData.contact.data[key]
    if info then
      FireEvent("NoticeToPrivate", info)
    end
  end
end

function chatNetDataMrg:OnChatRsp()
  local function handler(data)
    if nil == data then
      return
    end
    if data._say then
      local handler = ed.netreply.chatSay
      if handler then
        handler(data._say._result == "success")
        ed.netreply.chatSay = nil
      end
      if data._say._result == "success" then
        if data._say._channel == "personal_channel" then
          self:notifyUpdateDialogueOrder(data._say)
        end
        self:addMessage(data._say._channel, data._say._contents)
        self:refreshWorldState(data._say._channel)
      end
    elseif data._fresh then
      self:resetRefreshInternal(data._fresh._contents)
      self:addMessage(data._fresh._channel, data._fresh._contents)
    elseif data._multi_fresh then
      self:resetRefreshInternal(#data._multi_fresh > 0)
      for k, v in pairs(data._multi_fresh) do
        self:addMessage(v._channel, v._contents)
      end
    elseif data._fetch then
      ed.ui.chat.showLink(data._fetch)
    elseif data._chat_broad_say then
      self:OnChatBroadSay(data)
    elseif data._chat_contact then
      ed.player:setChatFreeTime(data._chat_contact._world_chat_times)
      self:refreshContactData(data._chat_contact)
    elseif data._chat_add_friend then
      if data._chat_add_friend._ret == "success" then
        ed.showToast(T("\230\183\187\229\138\160\230\156\139\229\143\139\230\136\144\229\138\159"))
        if data._chat_add_friend._add_friend then
          local info = data._chat_add_friend._add_friend
          ed.friendlist.addFriendlist(info._role_id)
          ed.applyFriend.delApplyFriend(info._role_id)
          local tb = {}
          tb.role_id = info._role_id
          tb.summary = info._user_summary
          tb.isOnline = info._is_online
          tb.recent_online_time = info._recent_online_time or ed.getServerTime()
          tb.server_name = info._server_name
          tb.svrId = info._svr_id
          local key = ed.chatUtil:getUserKey(info._role_id)
          self.contactData.friend.data[key] = tb
          FireEvent("add_friend_success", tb)
          ed.ui.chat.sendMessage(T("<text|chat_content|\230\136\145\228\187\172\229\183\178\231\187\143\230\136\144\228\184\186\229\165\189\229\143\139\228\186\134,\229\191\171\230\137\147\228\184\170\230\139\155\229\145\188\229\144\167\239\188\129>"), 1, nil, "personal_channel", nil, {
            roleId = info._role_id
          })
        end
      end
    elseif data._chat_del_friend then
      if data._chat_del_friend._ret == "success" then
        ed.showToast(T("\229\136\160\233\153\164\230\136\144\229\138\159"))
        if ed.netreply.delFriend then
          ed.netreply.delFriend()
          ed.netreply.delFriend = nil
        end
      end
    elseif data._chat_group_leave then
      ed.printTable(data._chat_group_leave)
      if data._chat_group_leave._result == "success" and ed.netreply.exitRoomHandler then
        ed.netreply.exitRoomHandler()
        ed.netreply.exitRoomHandler = nil
      end
    elseif data._chat_get_friends then
      if data._chat_get_friends._ret == "success" then
        FireEvent("ChatGetFriendSuccess", data._chat_get_friends._friends)
        if ed.netreply.getAllFriendsHandler then
          ed.netreply.getAllFriendsHandler(data._chat_get_friends._friends)
          ed.netreply.getAllFriendsHandler = nil
        end
      end
    elseif data._chat_search_user then
      FireEvent("SearchFriendsEvent", data._chat_search_user._chat_contact_user)
    elseif data._chat_delete_recent then
      if ed.netreply.delContactHandler then
        ed.netreply.delContactHandler(data._chat_delete_recent._chat_contact_user)
        ed.netreply.delContactHandler = nil
      end
    elseif data._get_unread_msg then
      if data._get_unread_msg._personal_chat then
        ed.printTable(data._get_unread_msg._personal_chat)
        self:getUnreadMsgHandler(data._get_unread_msg._personal_chat)
      end
    elseif data._chat_query_hero then
      FireEvent("chat_query_hero", data._chat_query_hero)
    elseif data._set_gender then
      if data._set_gender == "success" and ed.chatNetDataMrg.callFun then
        ed.chatNetDataMrg.callFun()
        ed.chatNetDataMrg.callFun = nil
      end
    elseif data._chat_recommend_friends then
      self.recommendFriendList = data._chat_recommend_friends._recommend_friend
      FireEvent("refreshRecommendFriend")
    end
  end
  
  return handler
end

function chatNetDataMrg:otherPartyAgressToFriend(data)
  local info = data
  ed.friendlist.addFriendlist(info._role_id)
  ed.applyFriend.delApplyFriend(info._role_id)
  local tb = {}
  tb.roleId = info._role_id
  tb.summary = info._user_summary
  tb.isOnline = info._is_online
  tb.recent_online_time = info._recent_online_time or ed.getServerTime()
  tb.server_name = info._server_name
  tb.svrId = info._svr_id
  local key = ed.chatUtil:getUserKey(tb.roleId)
  self.contactData.friend.data[key] = tb
  FireEvent("add_friend_success", tb)
end

function chatNetDataMrg:OnChatBroadSay(msg)
  local broadSay = msg._chat_broad_say or {}
  local handler = ed.netreply.chatSay
  if handler then
    handler(broadSay._result == "success")
    ed.netreply.chatSay = nil
  end
  if broadSay._result == "success" then
    self:addMessage(broadSay._channel, broadSay._contents)
    self:refreshWorldState(broadSay._channel)
  end
end

function chatNetDataMrg:refreshContactData(data)
  if data._chat_contact_user and #data._chat_contact_user > 0 then
    self.contactData.contact = {
      data = {},
      num = #data._chat_contact_user
    }
    for i, info in ipairs(data._chat_contact_user) do
      local tb = {}
      tb.roleId = info._role_id
      tb.summary = info._user_summary
      tb.isOnline = info._is_online
      tb.recent_online_time = info._recent_online_time or ed.getServerTime()
      tb.server_name = info._server_name
      tb.svrId = info._svr_id
      tb.last_time = #data._chat_contact_user - i
      local key = ed.chatUtil:getUserKey(tb.roleId)
      self.contactData.contact.data[key] = tb
    end
    self.isContactHasUpdate = true
  end
  if data._chat_friend and 0 < #data._chat_friend then
    self.contactData.friend = {
      data = {},
      num = #data._chat_friend
    }
    for i, info in ipairs(data._chat_friend) do
      local tb = {}
      tb.roleId = info._role_id
      tb.summary = info._user_summary
      tb.isOnline = info._is_online
      tb.recent_online_time = info._recent_online_time or ed.getServerTime()
      tb.server_name = info._server_name
      tb.svrId = info._svr_id
      local key = ed.chatUtil:getUserKey(tb.roleId)
      self.contactData.friend.data[key] = tb
    end
  end
  self.chatroomVersion = data._group_version
  chatNetDataMrg.chatroomData = {}
  if data._chat_group_info then
    local info1 = data._chat_group_info
    for _, v in ipairs(info1) do
      local group_type = v._chat_group_type
      local group_id = v._chat_group_id
      local users = v._group_user
      chatNetDataMrg.chatroomData[group_type] = {}
      chatNetDataMrg.chatroomData[group_type].group_id = group_id
      chatNetDataMrg.chatroomData[group_type].memberData = {}
      local friendflag
      for _, info in ipairs(users) do
        local tb = {}
        tb.roleId = info._role_id
        tb.summary = info._user_summary
        tb.isOnline = info._is_online
        tb.recent_online_time = info._recent_online_time or ed.getServerTime()
        tb.server_name = info._server_name
        tb.svrId = info._svr_id
        tb.camp = info._camp
        if tb.roleId == ed.getRoleId() then
          friendflag = tb.camp
        end
        table.insert(chatNetDataMrg.chatroomData[group_type].memberData, tb)
        chatNetDataMrg.chatroomData[group_type].friendflag = friendflag
      end
    end
  end
  if data._friend_apply then
    local applyFriendList = {}
    for index, chatContactUser in ipairs(data._friend_apply) do
      table.insert(applyFriendList, chatContactUser)
    end
    self.applyFriendList = applyFriendList
    FireEvent("refreshApplyFriend")
  end
  FireEvent(chatEvent.ReqContactData)
  if ed.netreply.reqChatContactHandler then
    ed.netreply.reqChatContactHandler()
    ed.netreply.reqChatContactHandler = nil
  end
end

function chatNetDataMrg:isInGuildData(roleId)
  local key = ed.chatUtil:getUserKey(roleId)
  if self.contactData.guild.data[key] then
    return true
  end
  return false
end

function chatNetDataMrg:addMessage(channel, datas)
  if nil == datas then
    return
  end
  for i, v in ipairs(datas) do
    self:insertOneMessage(channel, v)
  end
end

function chatNetDataMrg:insertOneMessage(channel, content)
  if not ed.blacklist.isInBlacklist(content._speaker_role_id) and content._content_type ~= 3 then
    if not self:checkMessageIsNew(channel, content) then
      return
    end
    if channel == "personal_channel" then
      local role_id = content._speaker_role_id
      if role_id == ed.getRoleId() then
        role_id = content._target_role_id
      end
      local key = ed.chatUtil:getUserKey(role_id)
      self.chatMessages[channel][key] = self.chatMessages[channel][key] or {}
      local personal = self.chatMessages[channel][key]
      table.insert(personal, content)
    elseif channel == "chatroom_channel" then
      local type = content._chat_group_type
      self.chatMessages[channel][type] = self.chatMessages[channel][type] or {}
      local personal = self.chatMessages[channel][type]
      table.insert(personal, content)
    else
      table.insert(self.chatMessages[channel], content)
    end
  end
end

function chatNetDataMrg:checkMessageIsNew(channel, content)
  local chatId = content._chat_id
  if channel == "personal_channel" then
    local role_id = content._speaker_role_id
    if role_id == ed.getRoleId() then
      role_id = content._target_role_id
    end
    local key = ed.chatUtil:getUserKey(role_id)
    local personal = self.chatMessages[channel][key]
    if self:checkChatIdInList(chatId, personal) then
      return false
    end
  elseif channel == "chatroom_channel" then
    local type = content._chat_group_type
    self.chatMessages[channel][type] = self.chatMessages[channel][type] or {}
    local personal = self.chatMessages[channel][type]
    if self:checkChatIdInList(chatId, personal) then
      return false
    end
  else
    local contentList = self.chatMessages[channel] or {}
    if self:checkChatIdInList(chatId, contentList) then
      return false
    end
  end
  return true
end

function chatNetDataMrg:checkChatIdInList(checkChatId, contentList)
  for index, content in ipairs(contentList or {}) do
    if checkChatId == content._chat_id then
      return true
    end
  end
  return false
end

function chatNetDataMrg:refreshWorldState(channel)
  if channel == "world_channel" then
    self.lastWorldChatTime = ed.getServerTime()
    ed.player:subChatFreeTime()
    FireEvent(chatEvent.NoticeRefreFreeTime)
  end
end

function chatNetDataMrg:resetRefreshInternal(isTrue)
  if self.chatReqNetSpace == nil then
    return
  end
  if isTrue then
    if self.refreshInternal ~= self.defaultInternal then
      CloseTimer(self.refreshChatEvent.Name)
      self.refreshInternal = self.defaultInternal
      self.refreshChatEvent = ListenTimer(Timer:Always(self.refreshInternal), self:reqChatMessage(), self.chatReqNetSpace)
    end
  elseif self.refreshInternal < self.maxInternal and self.refreshChatEvent then
    CloseTimer(self.refreshChatEvent.Name)
    self.refreshInternal = self.refreshInternal + self.defaultInternal
    self.refreshChatEvent = ListenTimer(Timer:Always(self.refreshInternal), self:reqChatMessage(), self.chatReqNetSpace)
  end
end

function chatNetDataMrg:reqChatMessage()
  local function handler()
    if chatNetDataMrg.isCanRefreshNetChatMsg then
      if "guildhero_channel" == self.currentChannel then
        FireEvent("ChataskTaskRequest")
        
        CloseTimer(self.refreshChatEvent.Name)
      else
        local msg = ed.upmsg.chat()
        msg._fresh = {}
        msg._fresh._channel = self.currentChannel
        ed.send(msg, "chat")
      end
    end
  end
  
  return handler
end

function chatNetDataMrg:reqChatContact(callFun)
  if type(callFun) == "function" then
    ed.netreply.reqChatContactHandler = callFun
  end
  local msg = ed.upmsg.chat()
  msg._chat_contact = {}
  msg._chat_contact._version = self.chatContactVersion or 0
  msg._chat_contact._group_version = self.chatroomVersion or 0
  ed.send(msg, "chat")
end

function chatNetDataMrg:setChannel(channel)
  self.currentChannel = channel
end

function chatNetDataMrg:sendApplyFriend(role_id)
  local msg = ed.upmsg.chat()
  msg._chat_apply_friend = {}
  msg._chat_apply_friend._role_id = role_id
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendRejectFriend(role_id)
  ed.applyFriend.delApplyFriend(role_id)
  local msg = ed.upmsg.chat()
  msg._chat_reject_friend = {}
  msg._chat_reject_friend._role_id = role_id
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendAddFriend(role_id)
  local msg = ed.upmsg.chat()
  msg._chat_add_friend = {}
  msg._chat_add_friend._role_id = role_id
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendDelFriend(role_id)
  local msg = ed.upmsg.chat()
  msg._chat_del_friend = {}
  msg._chat_del_friend._role_id = role_id
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendAddBlackList(roleId)
  if ed.friendlist.isInFriendlist(roleId) then
    self:sendDelFriend(roleId)
    ed.friendlist.deleteFriendlist(roleId)
  end
  ed.chatManager:setTargetRoleId(roleId)
  local msg = ed.upmsg.chat()
  msg._chat_add_bl = {}
  msg._chat_add_bl._role_id = roleId
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendDelBlackList(roleId)
  local msg = ed.upmsg.chat()
  ed.chatManager:setTargetRoleId(roleId)
  msg._chat_del_bl = {}
  msg._chat_del_bl._role_id = roleId
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendExitRoom(type, room_id)
  local msg = ed.upmsg.chat()
  msg._chat_group_leave = {}
  msg._chat_group_leave._group_type = type
  msg._chat_group_leave._chat_group_id = room_id
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendGetAllFriends()
  local msg = ed.upmsg.chat()
  msg._chat_get_friends = {}
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendSearchFriends(roleId)
  local msg = ed.upmsg.chat()
  msg._chat_search_user = {}
  msg._chat_search_user._role_id = roleId
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendDelRecent(data)
  local msg = ed.upmsg.chat()
  msg._chat_delete_recent = {}
  msg._chat_delete_recent._keys = data
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendGetUnreadMsg()
  local msg = ed.upmsg.chat()
  msg._get_unread_msg = {}
  ed.send(msg, "chat")
end

function chatNetDataMrg:sendOpenAllServerChat()
  local msg = ed.globalChatUpMsg.gc_open_panel()
  msg.svr_id = real_game_server_id
  msg.uid = ed.getUserid()
  msg.key = ed.getCryptKey()
  msg.uuid = ed.player:getUUID() or ""
  ed.socket_long_chat.send(msg, "open_panel")
end

function chatNetDataMrg:sendSubServerChatChannel(channel_id)
  if not ed.globalChatIsRegister then
    return
  end
  ed.chatNetDataMrg.chatServerData[channel_id] = ed.chatNetDataMrg.chatServerData[channel_id] or {
    msg = {},
    msg_id = 0
  }
  local msg = ed.globalChatUpMsg.gc_channel_sub()
  msg.channel_id = channel_id
  msg.cur_msg_id = ed.chatNetDataMrg.chatServerData[channel_id].msg_id
  ed.socket_long_chat.send(msg, "channel_sub")
end

function chatNetDataMrg:sendServerChatMsg(param)
  if not ed.globalChatIsRegister then
    return
  end
  local msg = ed.globalChatCommonMsg.gc_channel_chat()
  msg.channel_chat = param.content
  ed.socket_long_chat.send(msg, "channel_chat")
end

function chatNetDataMrg:sendReceipt(id)
  if not ed.globalChatIsRegister then
    return
  end
  local msg = id
  ed.socket_long_chat.send(msg, "msg_ask")
end

function chatNetDataMrg:sendSetSex(value)
  local msg = ed.upmsg.chat()
  msg._set_gender = {}
  msg._set_gender._gender = value
  ed.send(msg, "chat")
end

ed.chatNetDataMrg:starChatNet()

local function OngetUnreadMsg()
  if #ed.scene_stack == 0 or ed.scene_stack[1].identity ~= "main" then
    return
  end
  ListenTimer(Timer:Once(0.5), function()
    ed.chatNetDataMrg:sendGetUnreadMsg()
  end)
  ListenTimer(Timer:Once(0.8), function()
    local up_msg = ed.globalChatUpMsg.gc_connect_test()
    ed.socket_long_chat.send(up_msg, "connect_test")
  end)
end
