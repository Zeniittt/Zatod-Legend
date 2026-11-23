local chatNetWork = {}
chatNetWork.__index = chatNetWork
chatNetWork.EVENT_NAMES = {
  CHAT_MSG_LIST_REFRESH = "CHAT_MSG_LIST_REFRESH",
  CHAT_INIT_BLACKLIST = "CHAT_INIT_BLACKLIST",
  CHAT_DEL_BLACKLIST = "CHAT_DEL_BLACKLIST",
  CHAT_ADD_BLACKLIST = "CHAT_ADD_BLACKLIST",
  CHAT_MEMBER_LIST_REFRESH = "CHAT_MEMBER_LIST_REFRESH",
  NOTICE_CHAT_ENTRANCE = "NOTICE_CHAT_ENTRANCE",
  NOTICE_CHAT_REDPOINT = "NOTICE_CHAT_REDPOINT",
  NOTICE_CHAT_TOPNOTIFY = "NOTICE_CHAT_TOPNOTIFY",
  NOTICE_CHAT_SPELL = "NOTICE_CHAT_SPELL",
  CHAT_TRANSLATE_SUCCESS = "CHAT_TRANSLATE_SUCCESS",
  CHAT_MSG_LIST_HISTORY_REFRESH = "CHAT_MSG_LIST_HISTORY_REFRESH"
}

function chatNetWork.getInstance()
  if not chatNetWork.instance then
    chatNetWork.instance = chatNetWork.create()
  end
  return chatNetWork.instance
end

function chatNetWork.create()
  local self = {}
  setmetatable(self, chatNetWork)
  self:init()
  return self
end

function chatNetWork:init()
  self:initData()
  self:addEventListener()
end

function chatNetWork:initData()
  self.eventScope = {}
  self.chatMessages = {
    world_channel = {},
    guild_channel = {},
    personal_channel = {},
    chatroom_channel = {}
  }
  self.chatTimeRecordTab = {}
  self.translateMessages = {}
  self.contactData = {}
  ed.defineProperty(self, "delMemberMsg", nil)
  self.chatContactVersion = 0
  self.chatroomVersion = 0
  self.chatFreshScope = {}
  self.defaultInternal = 2
  self.maxInternal = 15
  self.refreshInternal = self.defaultInternal
  self.refreshChatEvent = nil
  self.lastWorldChatTime = nil
  self.chatFirtPay = true
  self.blacklistuser = {}
end

function chatNetWork:addEventListener()
  ListenEvent("applicationWillEnterForeground", function()
    if not ed.getUserid() then
      return
    end
    ListenTimer(Timer:Once(0.5), function()
      self:sendChat("chat_get_unread_msg", "_get_unread_msg", {})
    end)
    ListenTimer(Timer:Once(0.8), function()
      self:sendGlobalChatUp("connect_test", {})
    end)
  end, chatNetWork.eventScope)
end

function chatNetWork:sendChat(msg, name, body)
  local chat = ed.upmsg.chat()
  local msg = ed.upmsg[msg]()
  chat[name] = msg
  if body then
    for k, v in pairs(body) do
      msg[k] = v
    end
  end
  ed.send(chat, "chat")
end

function chatNetWork:sendGlobalChatUp(msg_name, body)
  local msg = ed.globalChatUpMsg["gc_" .. msg_name]()
  if body then
    for k, v in pairs(body) do
      msg[k] = v
    end
  end
  ed.socket_long_chat.send(msg, msg_name)
end

function chatNetWork:sendGlobalChatCommon(msg_name, body)
  local msg = ed.globalChatCommonMsg.gc_channel_chat()
  msg.channel_chat = body.content
  ed.socket_long_chat.send(msg, msg_name)
end

function chatNetWork:sendChatFresh(getHistory)
  if nil == getHistory then
    getHistory = false
  end
  local isHistory = 0
  if getHistory then
    isHistory = 1
  end
  
  local function handler()
    if ed.chatManager.currentChannel == "guild_channel" and ed.player:getGuildId() == 0 then
      return
    end
    self:sendChat("chat_fresh", "_fresh", {
      _channel = ed.chatManager.currentChannel,
      _is_history = isHistory
    })
  end
  
  return handler
end

function chatNetWork:getHistoryChat()
  self:closeChatFresh()
  self:sendChatFresh(true)()
  ed.chatManager.OnChatHistoryFresh = true
end

local PlaceholderStr = string.char(240, 159, 152, 138)
local ReplaceArr = {"<emoji|.->", PlaceholderStr}

function chatNetWork:parseToTranslateMode(str)
  str = string.gsub(str, "<.->", function(matchStr)
    local splitIndex, splitEndIndex = string.find(matchStr, "|", 2)
    if nil == splitIndex then
      return matchStr
    end
    local typeStr = string.sub(matchStr, 2, splitIndex - 1)
    if typeStr ~= "text" then
      return matchStr
    end
    splitIndex, splitEndIndex = string.find(matchStr, "|", splitIndex + 1)
    if nil == splitIndex then
      return matchStr
    end
    return string.sub(matchStr, splitIndex + 1, string.len(matchStr) - 1)
  end)
  local searchIndex = 1
  local stringArr = {}
  local paramArr = {}
  local strLen = string.len(str)
  repeat
    local minPos1, minPos2
    for i, v in ipairs(ReplaceArr) do
      local pos1, pos2 = string.find(str, v, searchIndex)
      if nil ~= pos1 and (nil == minPos1 or minPos1 > pos1) then
        minPos1 = pos1
        minPos2 = pos2
      end
    end
    if nil == minPos1 then
      table.insert(stringArr, string.sub(str, searchIndex))
      break
    end
    if searchIndex < minPos1 then
      table.insert(stringArr, string.sub(str, searchIndex, minPos1 - 1))
    end
    table.insert(paramArr, string.sub(str, minPos1, minPos2))
    table.insert(stringArr, PlaceholderStr)
    searchIndex = minPos2 + 1
    if strLen < searchIndex then
      break
    end
  until false
  str = table.concat(stringArr)
  return str, paramArr
end

function chatNetWork:parseToChatMode(str, paramArr)
  local tmpArr = Split(str, PlaceholderStr)
  local isWrapChatContent = false
  local stringArr = {}
  for i, v in ipairs(tmpArr) do
    if v ~= "" then
      if not isWrapChatContent then
        isWrapChatContent = true
        table.insert(stringArr, "<text|chat_content|")
      end
      table.insert(stringArr, v)
    end
    if nil ~= paramArr[i] then
      if paramArr[i] ~= PlaceholderStr then
        if isWrapChatContent then
          table.insert(stringArr, ">")
          isWrapChatContent = false
        end
      elseif not isWrapChatContent then
        isWrapChatContent = true
        table.insert(stringArr, "<text|chat_content|")
      end
      table.insert(stringArr, paramArr[i])
    end
  end
  if isWrapChatContent then
    table.insert(stringArr, ">")
  end
  str = table.concat(stringArr)
  return str
end

function chatNetWork:sendTranslateChat(channel, key, chatId, content)
  self.translateChannel = channel
  self.translateKey = key
  self.translateChatId = chatId
  local parseContent, paramArr = self:parseToTranslateMode(content)
  self.translateParamArr = paramArr
  local msg = ed.upmsg.chat()
  msg._chat_translate = ed.upmsg.chat_translate()
  msg._chat_translate._target_lang = ed.lilith_language_code[EDCurLanguage]
  msg._chat_translate._content = parseContent
  ed.send(msg, "chat")
end

function chatNetWork:startChatFresh(time)
  self:closeChatFresh()
  self.refreshInternal = self.defaultInternal
  ListenTimer(Timer:Once(time or 0.5), self:sendChatFresh(), self.chatFreshScope)
  self.refreshChatEvent = ListenTimer(Timer:Always(self.refreshInternal), self:sendChatFresh(), self.chatFreshScope)
end

function chatNetWork:resetChatFresh(isTrue)
  if isTrue then
    if self.refreshInternal ~= self.defaultInternal then
      if self.refreshChatEvent then
        CloseTimer(self.refreshChatEvent.Name)
      end
      self.refreshInternal = self.defaultInternal
      self.refreshChatEvent = ListenTimer(Timer:Always(self.refreshInternal), self:sendChatFresh(), self.chatFreshScope)
    end
  elseif self.refreshInternal < self.maxInternal and self.refreshChatEvent then
    CloseTimer(self.refreshChatEvent.Name)
    self.refreshInternal = self.refreshInternal + self.defaultInternal
    self.refreshChatEvent = ListenTimer(Timer:Always(self.refreshInternal), self:sendChatFresh(), self.chatFreshScope)
  end
end

function chatNetWork:closeChatFresh()
  if self.refreshChatEvent then
    CloseTimer(self.refreshChatEvent.Name)
    self.refreshChatEvent = nil
  end
  if self.chatFreshScope then
    CloseScope(self.chatFreshScope)
    self.chatFreshScope = {}
  end
end

function chatNetWork:dispatch(msg)
  local new_chat = false
  if msg._get_unread_msg then
    if msg._get_unread_msg._personal_chat then
      self:getUnreadMsgHandler(msg._get_unread_msg._personal_chat)
    end
  elseif msg._chat_contact then
    self:refreshContactData(msg._chat_contact)
    ed.chatManager:handleMsg(msg, "chat_contact")
  elseif msg._fresh then
    self:resetChatFresh(msg._fresh._contents)
    ed.chatManager:handleMsg(msg, "chat_fresh")
  elseif msg._multi_fresh then
    self:resetChatFresh(#msg._multi_fresh > 0)
    for k, v in pairs(msg._multi_fresh) do
      if new_chat == false then
        new_chat = self:addMessage(v._channel, v._contents)
      else
        self:addMessage(v._channel, v._contents)
      end
    end
  elseif msg._say then
    if msg._say._result == "success" then
      self:refreshWorldState(msg._say._channel)
      new_chat = self:addMessage(msg._say._channel, msg._say._contents)
      FireEvent("sendChatSuccess")
    elseif msg._say._result == "fail" then
      ed.showAlertDialog({
        text = msg._say._error_code
      })
    end
  elseif msg._chat_query_hero then
    local hero = ed.HeroCreate()
    hero:setup(msg._chat_query_hero)
    ed.ui.checkOthersHeroWindow.create(hero):popWindow()
  elseif msg._chat_add_bl then
    if msg._chat_add_bl._ret == "success" then
      ed.blacklist.addBlacklist(ed.chatManager:getTargetRoleId())
      FireEvent(self.EVENT_NAMES.CHAT_ADD_BLACKLIST)
    end
  elseif msg._chat_del_bl then
    if msg._chat_del_bl._ret == "success" then
      local index = self:deleteBlacklist(ed.chatManager:getTargetRoleId())
      ed.blacklist.deleteBlacklist(ed.chatManager:getTargetRoleId())
      FireEvent(self.EVENT_NAMES.CHAT_DEL_BLACKLIST, index)
    end
  elseif msg._chat_blacklist then
    self.blacklistuser = msg._chat_blacklist._chat_blacklist_user or {}
    FireEvent(self.EVENT_NAMES.CHAT_INIT_BLACKLIST)
  elseif msg._chat_delete_recent then
    self:delRecentMember()
  elseif msg._chat_apply_friend then
    if msg._chat_apply_friend._ret == "success" then
      ed.showToast(T("\229\165\189\229\143\139\231\148\179\232\175\183\229\143\145\233\128\129\230\136\144\229\138\159"))
    end
  elseif msg._chat_reject_friend then
    if msg._chat_reject_friend._ret == "success" then
      ed.showToast(T("\229\136\160\233\153\164\230\136\144\229\138\159"))
    end
  elseif ed.isMultiLanguage() and msg._chat_translate then
    local channel, key, chatId
    if nil ~= self.translateChannel then
      channel = self.translateChannel
      chatId = self.translateChatId
      key = self.translateKey
      self.translateChannel = nil
      self.translateChatId = nil
      self.translateKey = nil
      local tab = self.translateMessages[channel]
      if nil == tab then
        tab = {}
        self.translateMessages[channel] = tab
      end
      if nil ~= key then
        tab[key] = tab[key] or {}
        tab = tab[key]
      end
      local content = self:parseToChatMode(msg._chat_translate._content, self.translateParamArr)
      tab[chatId] = content
    end
    FireEvent(self.EVENT_NAMES.CHAT_TRANSLATE_SUCCESS, channel, key, chatId)
  end
  if new_chat then
    FireEvent(self.EVENT_NAMES.CHAT_MSG_LIST_REFRESH)
  end
end

function chatNetWork:dispatch_notify(msg)
  if msg._chat_msg_notify then
    local data = msg._chat_msg_notify
    if self:isInBlacklist(data._contents._speaker_role_id) then
      return
    end
    local key, roleId
    if data._channel == "personal_channel" then
      roleId = data._contents._speaker_role_id
      key = ed.chatUtil:getUserKey(roleId)
      local info = {
        roleId = roleId,
        summary = data._contents._speaker_summary,
        server_name = data._contents._speaker_server_name,
        isOnline = 1
      }
      if not self.contactData[key] then
        self.contactData[key] = {data = info, notify = 1}
      else
        self.contactData[key].data = info
        self.contactData[key].notify = self.contactData[key].notify + 1
      end
      if ed.chatManager.chatPopWin.chatMainWin and ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel and key == ed.chatManager:getCurPrivateTarget().key then
        self.contactData[key].notify = 0
      end
      FireEvent(self.EVENT_NAMES.NOTICE_CHAT_TOPNOTIFY, data)
      FireEvent(self.EVENT_NAMES.CHAT_MEMBER_LIST_REFRESH, info)
    elseif data._channel == "chatroom_channel" then
    end
    FireEvent(self.EVENT_NAMES.NOTICE_CHAT_ENTRANCE, data)
    FireEvent(self.EVENT_NAMES.NOTICE_CHAT_REDPOINT)
  end
end

function chatNetWork:addMessage(channel, datas)
  if datas == nil then
    return false
  end
  local newChat = false
  for i, v in ipairs(datas) do
    local isNewChat = self:insertOneMessage(channel, v)
    newChat = newChat or isNewChat
  end
  return newChat
end

function chatNetWork:addHistoryMessage(channel, datas)
  if datas == nil then
    return false
  end
  local newChat = false
  for i = #datas, 1, -1 do
    local v = datas[i]
    local isNewChat = self:insertOneMessage(channel, v, true)
    newChat = newChat or isNewChat
  end
  return newChat
end

function chatNetWork:insertOneMessage(channel, content, isHistory)
  if not ed.blacklist.isInBlacklist(content._speaker_role_id) and content._content_type ~= 3 then
    local msg = self.chatMessages[channel]
    local msg_table
    if channel == "personal_channel" then
      local roleId = content._speaker_role_id
      if content._speaker_role_id == ed.getRoleId() then
        roleId = content._target_role_id
      end
      local key = ed.chatUtil:getUserKey(roleId)
      msg[key] = msg[key] or {}
      msg_table = msg[key]
    elseif channel == "chatroom_channel" then
      local type = content._chat_group_type
      msg[type] = msg[type] or {}
      msg_table = msg[type]
    else
      msg_table = msg
    end
    if not self:checkContentInList(content, msg_table) then
      if isHistory then
        table.insert(msg_table, 1, content)
      else
        table.insert(msg_table, content)
      end
      return true
    end
  end
  return false
end

function chatNetWork:checkContentInList(checkContent, contentList)
  local checkChatId = checkContent._chat_id
  for index, content in ipairs(contentList) do
    if checkChatId == content._chat_id then
      return true
    end
  end
  return false
end

function chatNetWork:refreshWorldState(channel)
  if channel == "world_channel" then
    self.lastWorldChatTime = ed.getServerTime()
  end
end

function chatNetWork:refreshContactData(data)
  if data._chat_contact_user and #data._chat_contact_user > 0 then
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
      if self.contactData[key] then
        self.contactData[key].data = tb
      else
        self.contactData[key] = {data = tb, notify = 0}
      end
    end
  end
end

function chatNetWork:addBlacklist(uid, sid)
end

function chatNetWork:deleteBlacklist(roleId)
  local k = self:isInBlacklist(roleId)
  if k then
    table.remove(self.blacklistuser, k)
  end
  return k
end

function chatNetWork:getUnreadMsgHandler(notifyData)
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
      self.contactData[key] = {
        data = {roleId = roleId},
        notify = chat_count
      }
    end
  end
  if 0 < num then
    FireEvent(self.EVENT_NAMES.NOTICE_CHAT_REDPOINT)
  end
end

function chatNetWork:isInBlacklist(roleId)
  for index, chatBlackUser in ipairs(self.blacklistuser) do
    if chatBlackUser._role_id == roleId then
      return index
    end
  end
  return nil
end

function chatNetWork:getPersonalChannelRedPointNum()
  local rednum = 0
  for k, v in pairs(self.contactData) do
    rednum = rednum + v.notify
  end
  return rednum
end

function chatNetWork:getAllRedPointNum()
  return self:getPersonalChannelRedPointNum()
end

function chatNetWork:delRecentMember()
  local del_msg = self:getDelMemberMsg()
  for _, roleId in ipairs(del_msg) do
    local key = ed.chatUtil:getUserKey(roleId)
    ed.chatNetWork.chatMessages.personal_channel[key] = nil
    ed.chatNetWork.contactData[key] = nil
  end
  FireEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MEMBER_LIST_REFRESH)
  FireEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MSG_LIST_REFRESH)
  FireEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_REDPOINT)
end

function chatNetWork:initChatTimeInfo()
  self.chatTimeRecordTab = {
    [ed.chatManager.ChannelEnum.world_channel] = ed.getServerTime(),
    [ed.chatManager.ChannelEnum.guild_channel] = ed.getServerTime(),
    [ed.chatManager.ChannelEnum.personal_channel] = {
      [ed.chatManager.ChannelEnum.personal_channel] = ed.getServerTime()
    }
  }
end

function chatNetWork:checkAndUpdateChatTime(channel, speakerId, speakTime)
  if channel == ed.chatManager.ChannelEnum.personal_channel then
    local timeTab = self.chatTimeRecordTab[channel]
    local lastTime = timeTab[speakerId]
    if nil == lastTime then
      lastTime = timeTab[channel] or 0
    end
    if speakTime > lastTime then
      timeTab[speakerId] = speakTime
      return true
    end
  else
    local lastTime = self.chatTimeRecordTab[channel] or 0
    if speakTime > lastTime then
      self.chatTimeRecordTab[channel] = speakTime
      return true
    end
  end
  return false
end

function chatNetWork:sendChangeChatSetting(type)
  local msg = ed.upmsg.chat()
  msg._set_blocking = {
    _type = {}
  }
  local personal_chat = ed.chatManager.canOtherChat
  local friend_apply = ed.chatManager.canFrientInvite
  if type == "personal_chat" then
    personal_chat = not personal_chat
  else
    friend_apply = not friend_apply
  end
  if not personal_chat then
    table.insert(msg._set_blocking._type, "personal_chat")
  end
  if not friend_apply then
    table.insert(msg._set_blocking._type, "friend_apply")
  end
  ed.send(msg, "chat")
end

function chatNetWork:handleBlockingNotify(notify)
  ed.chatManager.canOtherChat = true
  ed.chatManager.canFrientInvite = true
  for k, v in ipairs(notify._type or {}) do
    if v == "personal_chat" then
      ed.chatManager.canOtherChat = false
    end
    if v == "friend_apply" then
      ed.chatManager.canFrientInvite = false
    end
  end
  FireEvent("ChatSettingChange")
end

ed.chatNetWork = chatNetWork.getInstance()
