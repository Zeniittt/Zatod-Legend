local base = ed.ui.popwindow
local chatMainWin = newclass(base.mt)
ed.ui.chatMainWin = chatMainWin
local gsub = string.gsub

function chatMainWin.create()
  local self = base.create("chatMainWin")
  setmetatable(self, chatMainWin.mt)
  self:initData()
  self:initView()
  self:addEventListener()
  self:initInputEditTouchHandle()
  return self
end

function chatMainWin:initData()
  self.eventScope = {}
  self.newMsgNum = 0
  self.memberListHeight = 0
  self.memberListCell = {}
  self.input_richtext = {}
  self.pxy = ccp(0, 0)
  self.setpxy = ccp(0, 0)
  self.oldInputString = nil
end

function chatMainWin:initView()
  local container, ui = ed.editorui(ed.uieditor.chatMainWin)
  self.ui = ui
  self.container:addChild(container)
  ed.adaptLabel(ui.blacklist_label, {maxWidth = 60, minScale = 0.8})
  ui.add_label:limitWidthByScale(90)
  self:adaptWinSize()
  self:initInput()
  self.chatMsgList = ed.ui.chatMsgList.create(self)
  self:createMemberList()
  self.chatEmoji = ed.ui.chatEmoji.create(self)
  self:initRichText()
  self:switchChatChannel(ed.chatManager.currentChannel)
end

function chatMainWin:addEventListener()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, -300, false)
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.edit_box:touch(event, x, y)
    end,
    key = "edit_box",
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.emoji_win_btn,
    key = "emoji_win_btn",
    clickHandler = function()
      self.chatEmoji:showChatEmoji()
    end,
    priority = -1,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.send_btn,
    key = "send_btn",
    clickHandler = function()
      self.chatEmoji:showChatEmoji(false)
      ed.chatManager:setNeedSendMsg({
        type = 1,
        content = self:getInputString()
      })
      self.oldInputString = self:getEditBoxString()
      print(self.oldInputString)
      ed.chatManager:sendChatMsg()
    end,
    priority = -1
  })
  self:btRegisterButtonClick({
    button = self.ui.world_channel,
    key = "world_channel",
    pressHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        self.ui.world_channel_press:setVisible(true)
      end
    end,
    cancelPressHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        self:updateChannelBtn()
      end
    end,
    clickHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.world_channel then
          return
        end
        self:switchChatChannel(ed.chatManager.ChannelEnum.world_channel)
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.guild_channel,
    key = "guild_channel",
    pressHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        self.ui.guild_channel_press:setVisible(true)
      end
    end,
    cancelPressHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        self:updateChannelBtn()
      end
    end,
    clickHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.guild_channel then
          return
        end
        self:switchChatChannel(ed.chatManager.ChannelEnum.guild_channel)
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.personal_channel,
    key = "personal_channel",
    pressHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        self.ui.personal_channel_press:setVisible(true)
      end
    end,
    cancelPressHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        self:updateChannelBtn()
      end
    end,
    clickHandler = function()
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel then
          return
        end
        self:switchChatChannel(ed.chatManager.ChannelEnum.personal_channel)
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.set_btn,
    key = "set_btn",
    clickHandler = function()
      self:showChatSet()
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.blacklist_btn,
    key = "blacklist_btn",
    clickHandler = function()
      local param = {
        selectTabKey = "friend",
        subParam = {selectType = "blacklist"}
      }
      ed.ui.friendMainWin.create(param):popWindow()
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.chatset_btn,
    key = "chatset_btn",
    clickHandler = function()
      ed.ui.chatSettingWin.create()
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.clear_btn,
    key = "clear_btn",
    clickHandler = function()
      if #self.memberListCell == 0 then
        ed.showToast(T("\230\178\161\230\156\137\229\143\175\229\136\160\233\153\164\231\154\132\229\175\185\232\175\157"))
        return
      end
      ed.ui.delChatMemberWin.create():popWindow()
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.add_btn,
    key = "add_btn",
    clickHandler = function()
      ed.ui.friendMainWin.create():popWindow()
    end,
    pressScale = 0.95
  })
  ListenEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MSG_LIST_REFRESH, function()
    self.chatMsgList:updateMsgList()
    self.chatMsgList:showMsgListTip()
  end, self.eventScope)
  ListenEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MSG_LIST_HISTORY_REFRESH, function(new_chat)
    if nil == new_chat then
      new_chat = false
    end
    if new_chat then
      local oriPosX, oriPosY = self.chatMsgList.msgList:getListPos()
      local oriHei = self.chatMsgList.msgList:getListHeight()
      self.chatMsgList:updateMsgList()
      local newHei = self.chatMsgList.msgList:getListHeight()
      self.chatMsgList.msgList:setListPos(ccp(0, newHei - oriHei + oriPosY))
      self.chatMsgList:showMsgListTip()
    end
    if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel and self.chatMsgList.msgListHeight <= self.chatMsgList.msgList.height and ed.chatManager:getCanSendChatHistoryFresh() and not ed.chatManager.OnChatHistoryFresh then
      ed.chatNetWork:getHistoryChat()
    end
  end, self.eventScope)
  self:registerUpdateHandler("setMessage", function()
    local str = self:getInputString()
    self.ui.input:setString(str)
    local textSize = self.ui.input:getContentSize()
    local frameSize = self.ui.chat_input_frame_real:getContentSize()
    local edgeSpace = 10
    if textSize.width > frameSize.width - edgeSpace then
      self.ui.input:setPosition(ccp(frameSize.width - textSize.width - edgeSpace, frameSize.height / 2))
    else
      self.ui.input:setPosition(ccp(edgeSpace, frameSize.height / 2))
    end
  end)
  ListenTimer(Timer:Always(0.3), function()
    self:checkCanShowSuspension()
  end, self.eventScope)
  ListenEvent("SetCurPrivateTarget", function()
    if ed.chatManager.currentChannel ~= ed.chatManager.ChannelEnum.personal_channel then
      self:switchChatChannel(ed.chatManager.ChannelEnum.personal_channel)
    else
      self:initMemberList()
      self:showMemberListTip()
      self.chatMsgList:clearMsgList()
      self.chatMsgList:updateMsgList()
      self.chatMsgList:showMsgListTip()
    end
  end, self.eventScope)
  ListenEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MEMBER_LIST_REFRESH, function(data)
    self:initMemberList()
    self:showMemberListTip()
  end, self.eventScope)
  ListenEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_REDPOINT, function(data)
    self:updateChannelBtnRedPoint()
  end, self.eventScope)
  ListenEvent("sendChatSuccess", function()
    if ed.chatManager.clearCacheFlag then
      self:setEditBoxString("")
    end
  end, self.eventScope)
end

function chatMainWin:chatSpellNotify(data, delayTime)
  self.ui.chat_content_bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime), CCCallFunc:create(function()
    self.ui.chat_content_bg:stopAllActions()
    self.chatMsgList:playMsgEffectBySpellId(data.spell_id)
  end))))
end

function chatMainWin:initInputEditTouchHandle()
  if not EDFLAGIOS then
    return
  end
  if not self.ui.edit_box.edit.registerScriptEditBoxHandler then
    return
  end
  local chatInputBgSize = self.ui.chat_input_bg:getContentSize()
  self.oriPosY = self.ui.chat_input_bg:getPositionY()
  self.oriPosX = self.ui.chat_input_bg:getPositionX()
  self.ui.chat_input_bg:setZOrder(10)
  self.ui.edit_box.edit:registerScriptEditBoxHandler(function(type, edit)
    if type == "began" then
      self.ui.chat_input_bg:setPositionY(self.origin_chat_bg_size.height - chatInputBgSize.height)
    elseif type == "return" or type == "ended" then
      self.ui.chat_input_bg:setPositionY(self.oriPosY)
    end
  end)
end

function chatMainWin:popWindow()
  self:ccScene():addChild(self.mainLayer, 300)
  ed.chatManager.chatPopWin.chatMainWin = self
  ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatMainWin)
  ed.chatNetWork:startChatFresh()
  local width = self.origin_chat_bg_posx + self.ui.chat_bg:getContentSize().width + self.ui.close_btn:getContentSize().width
  self.ui.chat_bg:setPositionX(self.ui.chat_bg:getPositionX() - width)
  local action = CCMoveBy:create(0.2, ccp(width, 0))
  self.ui.chat_bg:runAction(action)
end

function chatMainWin:pushWindow()
  self:removeUpdateHandler("setMessage")
  ed.chatManager.chatPopWin.chatMainWin = nil
  ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatEntrance)
  CloseScope(self.eventScope)
  self.eventScope = {}
  if self.mainLayer:getParent() then
    self.mainLayer:removeFromParentAndCleanup(true)
  end
  ed.chatNetWork:closeChatFresh()
  if self.ui.edit_box.edit and self.ui.edit_box.edit.unregisterScriptEditBoxHandler then
    self.ui.edit_box.edit:unregisterScriptEditBoxHandler()
  end
  ed.chatBattleReplay.clear()
  ed.chatLadderFight.clear()
  FireEvent("CloseChatMainWin")
end

function chatMainWin:adaptWinSize()
  self.adaptWidth = 0
  self.adaptHeight = ed.display.halfFixedHeight * 2
  local chat_bg_size = self.ui.chat_bg:getContentSize()
  self.ui.chat_bg:setContentSize(CCSizeMake(chat_bg_size.width, chat_bg_size.height + self.adaptHeight))
  local chat_content_bg_size = self.ui.chat_content_bg:getContentSize()
  self.ui.chat_content_bg:setContentSize(CCSizeMake(chat_content_bg_size.width, chat_content_bg_size.height + self.adaptHeight))
  local member_list_size = self.ui.member_list:getContentSize()
  self.ui.member_list:setContentSize(CCSizeMake(member_list_size.width, member_list_size.height + self.adaptHeight))
  local msg_list_size = self.ui.msg_list:getContentSize()
  self.ui.msg_list:setContentSize(CCSizeMake(msg_list_size.width, msg_list_size.height + self.adaptHeight))
  self.ui.channel_list:setPositionY(self.ui.channel_list:getPositionY() + self.adaptHeight)
  self.ui.title_bg:setPositionY(self.ui.title_bg:getPositionY() + self.adaptHeight)
  self.ui.close_btn:setScale(0 < self.adaptHeight and 1 or 0.55)
  self.close_btn_x = self.ui.close_btn:getPositionX()
  self.origin_chat_bg_size = self.ui.chat_bg:getContentSize()
  self.bgwidthdraw = 405 / ed.display.scaleFactor
  self.origin_chat_bg_posx = 0
  ed.layout.setNodePosWithWorldPos(self.ui.chat_bg, ccp(self.origin_chat_bg_posx + ed.display.getNotchHeight(), ed.display.center.y))
end

function chatMainWin:initInput()
  local info = {
    config = {
      editSize = self.ui.chat_input_frame:getContentSize(),
      maxLength = 50,
      fontColor = ccc3(0, 0, 0),
      fontSize = 20,
      forceTouch = true,
      inputMode = kEditBoxInputModeSingleLine
    }
  }
  local edit_box = editBox:new(info)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  self.ui.chat_input_frame:addChild(edit_box.edit)
  self.ui.edit_box = edit_box
  self.ui.chat_input_frame:setVisible(false)
  local input = richText:new()
  input:setPosition(ccp(5, self.ui.chat_input_frame_real:getContentSize().height / 2))
  input:setVerticalCenter()
  local clipLayer = CCLayer:create()
  local inputFrameSize = self.ui.chat_input_frame:getContentSize()
  clipLayer:setClipRect(CCRectMake(0, 0, inputFrameSize.width, inputFrameSize.height))
  self.ui.chat_input_frame_real:addChild(clipLayer)
  clipLayer:addChild(input.rootNode)
  self.ui.input = input
end

function chatMainWin:getEditBoxString()
  local str = self.ui.edit_box:getString()
  if str == " " then
    str = ""
  end
  return str
end

function chatMainWin:setEditBoxString(str)
  self.ui.edit_box:setString(str)
end

function chatMainWin:getInputString()
  local editstr = self:getEditBoxString()
  editstr = gsub(editstr, ">", "\227\128\139")
  editstr = gsub(editstr, "<", "\227\128\138")
  local str = ""
  local index = 1
  local startIndex = 1
  local endIndex = 1
  local text = ""
  local emoji = ""
  local idmax = self:getChatEmojiLength()
  while true do
    startIndex, endIndex = string.find(editstr, "#[1-9][0-9]?#", index)
    if startIndex == nil then
      text = string.sub(editstr, index)
      if text ~= "" then
        str = str .. string.format("<text|chat_content|%s>", text)
      end
      break
    end
    text = string.sub(editstr, index, startIndex - 1)
    emoji = string.sub(editstr, startIndex + 1, endIndex - 1)
    if idmax >= tonumber(emoji) then
      if text ~= "" then
        str = str .. string.format("<text|chat_content|%s>", text)
      end
      local scale = 0.32
      str = str .. string.format("<emoji|%s|%s>", emoji, scale)
      index = endIndex + 1
    else
      text = string.sub(editstr, index, endIndex - 1)
      if text ~= "" then
        str = str .. string.format("<text|chat_content|%s>", text)
      end
      index = endIndex
    end
  end
  return str
end

function chatMainWin:getChatEmojiLength()
  local length = 0
  for id, chatEmojiData in pairs(ed.getDataTable("ChatEmoji") or {}) do
    length = length + 1
  end
  return length
end

function chatMainWin:createMemberList()
  local w, h = self.ui.member_list:getContentSize().width, self.ui.member_list:getContentSize().height
  local info = {
    cliprect = CCRectMake(0, 0, w, h),
    container = self.ui.member_list,
    priority = -300,
    noshade = true,
    doPressIn = function(x, y)
      for i, cell in ipairs(self.memberListCell) do
        local member_btn = cell.ui.member_btn
        if ed.containsPoint(member_btn, x, y) and self.ui.extra_layer:isVisible() then
          return i
        end
      end
      return nil
    end,
    doClickIn = function(x, y, i)
      for index, cell in ipairs(self.memberListCell) do
        if index == i then
          ed.chatManager:setCurPrivateTarget({
            key = cell.key,
            data = cell.data
          })
          local contactdata = ed.chatNetWork.contactData[cell.key]
          if contactdata then
            contactdata.notify = 0
          end
          FireEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_REDPOINT)
        end
      end
    end
  }
  self.memberList = ed.draglist.create(info)
end

function chatMainWin:clearMemberList()
  self.memberListHeight = 0
  self.memberListCell = {}
  self.memberList:clearList()
end

function chatMainWin:memberListAddCell(key, member)
  local container = CCNode:create()
  local ui = {}
  ed.editorui(ed.uieditor.chat_member, {container = container, ui = ui})
  ui.name:setStroke(ccc3(85, 64, 39), 2)
  local name = member.data.summary and member.data.summary._name or ""
  local medal
  if member.data.summary and member.data.summary._medal then
    medal = member.data.summary._medal
  end
  local nameLay = ed.getPlayerName(name or "", medal, {
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(ui, "member_btn", "name", nameLay)
  nameLay:setScale(0.9)
  local param = {
    id = member.data.summary and member.data.summary._avatar or 1,
    scale = 0.47
  }
  local head = ed.getWholeHeadIcon(param)
  ui.head:setVisible(false)
  ui.head_bg:setVisible(false)
  ui.member_btn:addChild(head)
  head:setPosition(ui.head:getPosition())
  local online = richText:new()
  online:setPosition(ccp(98 / ed.display.scaleFactor, 30 / ed.display.scaleFactor))
  online:setVerticalCenter()
  local style = member.data.isOnline == 1 and "chat_online_green" or "chat_online_grey"
  local time = member.data.isOnline == 1 and T("\229\156\168\231\186\191") or ed.chatManager:getRecentOnlineTime(member.data.recent_online_time or ed.getServerTime())
  online:setString(T("<text|%s|%s>", style, time))
  ui.member_btn:addChild(online.rootNode)
  ui.online = online
  local svrId = member.data.svrId
  if svrId and svrId ~= tonumber(game_server_id) then
    ed.setString(ui.label_svr_name, member.data.server_name or "")
    ed.setLabelStroke(ui.label_svr_name, ed.toccc3(2565412), 1)
    ui.label_svr_name:setVisible(true)
  else
    ui.label_svr_name:setVisible(false)
  end
  local y = math.abs(ui.member_btn_press:getContentSize().height - ui.member_btn:getContentSize().height)
  ui.member_btn_press:setPositionY(-y)
  local target = ed.chatManager:getCurPrivateTarget()
  local isSelect = target.key == key
  ui.member_btn_press:setVisible(isSelect)
  if target.key == key then
    member.notify = 0
  end
  ui.rednum:setString(member.notify)
  ui.redpoint:setVisible(0 < member.notify)
  table.insert(self.memberListCell, {
    ui = ui,
    key = key,
    data = member.data
  })
  local height = ui.member_btn:getContentSize().height
  local position = ccp(0, self.ui.member_list:getContentSize().height - self.memberListHeight)
  self.memberList:addItem(container, position)
  return height, isSelect, position
end

function chatMainWin:initMemberList()
  self:clearMemberList()
  local members = ed.chatNetWork.contactData
  local membersList = {}
  for k, v in pairs(members) do
    table.insert(membersList, v)
  end
  table.sort(membersList, ed.cmpSort({
    {
      getValue = function(member)
        return member.notify or 0
      end,
      reverse = true
    },
    {
      getValue = function(member)
        local data = member.data or {}
        return data.isOnline or 0
      end,
      reverse = true
    },
    {
      getValue = function(member)
        local data = member.data or {}
        return data.recent_online_time or 0
      end,
      reverse = true
    }
  }))
  local targetPosition
  for _, v in ipairs(membersList) do
    local k = v.data.roleId
    local cellHeight, isSelect, position = self:memberListAddCell(k, v)
    self.memberListHeight = self.memberListHeight + cellHeight
    if isSelect then
      targetPosition = position
    end
  end
  self.memberList:initListHeight(self.memberListHeight)
  if targetPosition then
    local listY = -targetPosition.y + self.ui.member_list:getContentSize().height
    listY = math.min(listY, self.memberListHeight - self.ui.member_list:getContentSize().height)
    listY = math.max(listY, 0)
    self.memberList:setListPos(ccp(0, listY))
  end
end

function chatMainWin:updateMemberList()
  for index, cell in ipairs(self.memberListCell) do
    local ui = cell.ui
    local key = cell.key
    local data = cell.data
    if key == ed.chatManager:getCurPrivateTarget().key then
      ui.redpoint:setVisible(false)
      ui.member_btn_press:setVisible(true)
    else
      ui.member_btn_press:setVisible(false)
    end
  end
end

function chatMainWin:showMemberListTip()
  self.ui.member_list_tip:setVisible(#self.memberListCell == 0)
end

function chatMainWin:addNewMsg()
  self.newMsgNum = self.newMsgNum + 1
end

function chatMainWin:showSuspension(visible)
  if visible and self:checkCanShowSuspension() then
    self.ui.suspension:setString(T("<text|chat_suspension_white|\230\159\165\231\156\139\229\186\149\233\131\168\230\150\176\230\182\136\230\129\175>"))
    self.ui.suspension_bg:setVisible(true)
  else
    self.ui.suspension_bg:setVisible(false)
    self.newMsgNum = 0
  end
end

function chatMainWin:checkCanShowSuspension()
  if self.newMsgNum == 0 then
    return false
  end
  local draglist = self.chatMsgList.msgList
  local _, y = draglist:getListPos()
  if y + 50 < draglist.listHeight - draglist.height then
    return true
  else
    self:showSuspension(false)
  end
  return false
end

function chatMainWin:suspensionTouch(event, x, y)
  if self.ui.suspension_bg:isVisible() then
    if event == "began" then
      if ed.containsPoint(self.ui.suspension_bg, x, y) then
        self.suspensionPress = true
        return true
      end
    elseif event == "move" then
      return true
    elseif event == "ended" and self.suspensionPress and ed.containsPoint(self.ui.suspension_bg, x, y) then
      self.suspensionPress = false
      self:showSuspension(false)
      self.chatMsgList.msgList:move2Bottom()
      return true
    end
  end
  return false
end

function chatMainWin:showChatSet()
  local visible = self.ui.config_bg:isVisible()
  self.ui.config_bg:setVisible(not visible)
  ed.chatManager:setOperateChatWin(visible and ed.chatManager.ChatWinEnum.chatMainWin or ed.chatManager.ChatWinEnum.chatSet)
  self.chatMsgList:setTouchEnabled(visible)
end

function chatMainWin:chatSetTouch(event, x, y)
  if event == "began" then
    self.isSetPress = false
    if not ed.containsPoint(self.ui.set_btn, x, y) and not ed.containsPoint(self.ui.config_bg, x, y) then
      self.isSetPress = true
    end
    if self.isSetPress then
      self.setpxy = ccp(x, y)
      return true
    end
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), self.setpxy)
    if 10 < dis then
      self.isSetPress = false
    end
  elseif event == "ended" and self.isSetPress and not ed.containsPoint(self.ui.set_btn, x, y) and not ed.containsPoint(self.ui.config_bg, x, y) then
    self:showChatSet()
    return true
  end
  return false
end

function chatMainWin:touch(event, x, y)
  if event == "began" then
    self.isPress = false
    if not ed.containsPoint(self.ui.chat_bg, x, y) then
      self.isPress = true
    end
    if self.isPress then
      self.pxy = ccp(x, y)
      return true
    end
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), self.pxy)
    if 10 < dis then
      self.isPress = false
    end
  elseif event == "ended" and self.isPress and not ed.containsPoint(self.ui.chat_bg, x, y) then
    if not self.mainLayer:getParent() then
      return
    end
    ed.playEffect(ed.sound.handbook.clickBack)
    local width = self.origin_chat_bg_posx + self.ui.chat_bg:getContentSize().width + self.ui.close_btn:getContentSize().width
    local action = CCSequence:create(ccArrayMake(CCMoveBy:create(0.2, ccp(-width, 0)), CCCallFunc:create(function()
      self:pushWindow()
    end)))
    self.ui.chat_bg:runAction(action)
    return true
  end
  return false
end

function chatMainWin:btGetMainTouchHandler()
  local self = self
  
  local function handler(event, x, y)
    xpcall(function()
      if self:touch(event, x, y) then
        return
      end
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatMainWin then
        if not self:suspensionTouch(event, x, y) then
          self.chatMsgList:touch(event, x, y)
        end
      elseif ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatEmoji then
        self.chatEmoji:touch(event, x, y)
      elseif ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatSet then
        self:chatSetTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

function chatMainWin:switchChatChannel(channel)
  if channel == ed.chatManager.ChannelEnum.guild_channel and ed.player:getGuildId() == 0 then
    ed.showToast(ed.chatManager.ChatText[2])
    return
  end
  ed.chatManager.currentChannel = channel
  ed.chatNetWork:startChatFresh()
  if channel == ed.chatManager.ChannelEnum.personal_channel then
    self.ui.chat_bg:setContentSize(CCSizeMake(self.origin_chat_bg_size.width + self.bgwidthdraw, self.origin_chat_bg_size.height))
    self.ui.extra_layer:setVisible(true)
    self.ui.close_btn:setPositionX(self.close_btn_x + self.bgwidthdraw)
    self:initMemberList()
    self:showMemberListTip()
  else
    self.ui.chat_bg:setContentSize(CCSizeMake(self.origin_chat_bg_size.width, self.origin_chat_bg_size.height))
    self.ui.extra_layer:setVisible(false)
    self.ui.close_btn:setPositionX(self.close_btn_x)
  end
  self.chatMsgList:clearMsgList()
  self.chatMsgList:updateMsgList()
  self.chatMsgList:showMsgListTip()
  self:updateChannelBtn()
end

function chatMainWin:initRichText()
  for k, v in pairs(ed.chatManager.ChannelBtnEnum) do
    local channelbtn = self.ui[k]
    local richtext = richText:new()
    richtext:setAnchor(ccp(0.5, 0.5))
    local size = channelbtn:getContentSize()
    richtext:setPosition(ccp(size.width / 2, size.height / 2))
    local text = T("<text|chat_channel_inactive|%s>", v.text)
    richtext:setString(text)
    channelbtn:addChild(richtext.rootNode)
    self.ui[k .. "_richtext"] = richtext
  end
  self.ui.title:limitWidthByScale(110)
  self.ui.title:setStroke(ccc3(169, 104, 27), 2)
  local suspension = richText:new()
  suspension:setVerticalCenter()
  suspension:setString(T("<text|chat_suspension_white|\230\159\165\231\156\139\229\186\149\233\131\168\230\150\176\230\182\136\230\129\175>"))
  local suspension_w = suspension:getSize()
  local suspension_x = self.ui.skip:getPositionX() - self.ui.skip:getContentSize().width - suspension_w
  local suspension_y = self.ui.suspension_bg:getContentSize().height / 2
  suspension:setPosition(ccp(suspension_x, suspension_y))
  self.ui.suspension_bg:addChild(suspension.rootNode)
  self.ui.suspension = suspension
  for k, v in pairs(ed.chatManager.EmojiTab) do
    self.ui[v .. "_label"]:setStroke(ccc3(56, 38, 34), 2)
  end
end

function chatMainWin:updateChannelBtn()
  for k, v in pairs(ed.chatManager.ChannelBtnEnum) do
    local channelbtn = self.ui[k]
    local channelbtn_press = self.ui[k .. "_press"]
    local richtext = self.ui[k .. "_richtext"]
    channelbtn_press:setVisible(k == ed.chatManager.currentChannel)
    local style = k == ed.chatManager.currentChannel and "chat_channel_active" or "chat_channel_inactive"
    local text = T("<text|%s|%s>", style, v.text)
    richtext:setString(text)
  end
  self:updateChannelBtnRedPoint()
end

function chatMainWin:updateChannelBtnRedPoint()
  local num = ed.chatNetWork:getPersonalChannelRedPointNum()
  self.ui.personal_rednum:setString(num)
  self.ui.personal_redpoint:setVisible(0 < num)
end
