local chatMsgList = newclass()

function chatMsgList.create(delegate)
  local self = {}
  setmetatable(self, chatMsgList.mt)
  self:init(delegate)
  return self
end

function chatMsgList:init(delegate)
  self.eventScope = {}
  self:initData(delegate)
  self:initView()
  self:addEventListener()
end

function chatMsgList:initData(delegate)
  self.delegate = delegate
  self.ui = self.delegate.ui
  self.msgListHeight = 0
  self.chatMessagesIndex = {
    world_channel = 1,
    guild_channel = 1,
    personal_channel = 1,
    chatroom_channel = 1
  }
  self.msgCellIndex = nil
  self.translateIndex = nil
  self.msgListCell = {}
  self.linkbutton = nil
  self.linkButtons = {}
  self.showMsgAmount = 200
end

function chatMsgList:initView()
  self:createMsgList()
end

function chatMsgList:addEventListener()
  self.delegate:listenEvent(ed.chatNetWork.EVENT_NAMES.CHAT_TRANSLATE_SUCCESS, function(channel, key, chatId)
    if nil == channel or nil == chatId then
      return
    end
    self:updateMsgList(true)
  end)
end

local function onTouchMoved(draglist)
  local dlSelf = draglist
  local lox = dlSelf.oriPosX
  local loy = dlSelf.oriPosY
  local rw = dlSelf.width
  local rh = dlSelf.height
  local lw = dlSelf.listWidth
  local lh = dlSelf.listHeight
  local px, py = dlSelf.listLayer:getPosition()
  if dlSelf.dragMode and py < loy - 10 and ed.chatManager:getCanSendChatHistoryFresh() and not ed.chatManager.OnChatHistoryFresh and not dlSelf.getHistoryOnce then
    dlSelf.getHistoryOnce = true
    ed.chatNetWork:getHistoryChat()
  end
end

local function onTouchEnd(draglist)
  local dlSelf = draglist
  if dlSelf.getHistoryOnce then
    dlSelf.getHistoryOnce = false
  end
end

function chatMsgList:createMsgList()
  local w, h = self.ui.msg_list:getContentSize().width, self.ui.msg_list:getContentSize().height
  local info = {
    cliprect = CCRectMake(0, 0, w, h),
    container = self.ui.msg_list,
    priority = -300,
    noshade = true
  }
  self.msgList = ed.draglist.create(info)
  self.msgList.onTouchMoved = onTouchMoved
  self.msgList.onTouchEnd = onTouchEnd
end

function chatMsgList:showChatTime(data)
  local lastdata = self.msgListCell[#self.msgListCell]
  if lastdata then
    local lasttime = ed.time2China(lastdata.extraData.speak_time)
    local time = ed.time2China(data._speak_time)
    if 180 < time - lasttime then
      self:createTime(data)
    end
  else
    self:createTime(data)
  end
end

function chatMsgList:createTime(data)
  local spaceY = 10
  local timestr = T("<text|chat_time|%s>", ed.chatManager:getChatTimeDes(data._speak_time))
  local time = richText:new()
  time:setString(timestr)
  time:setVerticalCenter()
  local width, height = time:getSize()
  local x = (self.ui.msg_list:getContentSize().width - width) / 2
  local y = self.ui.msg_list:getContentSize().height - self.msgListHeight - height / 2 - spaceY
  self.msgList:addItem(time.rootNode, ccp(x, y))
  self.msgListHeight = self.msgListHeight + height + spaceY * 2
end

function chatMsgList:msgListAddChatCell(data, translateContent)
  local isSelf = data._speaker_role_id == ed.getRoleId()
  local extraData = {
    chatId = data._chat_id,
    channel = ed.chatManager.currentChannel,
    summary = data._speaker_summary,
    roleId = data._speaker_role_id,
    acc = data._summary,
    server_name = data._speaker_server_name,
    speak_time = data._speak_time,
    translate_content = translateContent
  }
  local container = CCNode:create()
  local ui = {}
  local isSystem = data._content_type == 0
  if isSystem then
    ed.editorui(ed.uieditor.chat_msg_system, {container = container, ui = ui})
  elseif isSelf then
    ed.editorui(ed.uieditor.chat_msg_right, {container = container, ui = ui})
  else
    ed.editorui(ed.uieditor.chat_msg_left, {container = container, ui = ui})
    self.delegate:addNewMsg()
  end
  if not isSystem then
    local head = ed.getTeamHead({
      id = extraData.summary._avatar,
      length = 56,
      isFaceLeft = isSelf
    })
    head:setScale(0.5)
    head:setPosition(ui.head:getPosition())
    ui.head:removeFromParentAndCleanup(true)
    ui.head_bg:removeFromParentAndCleanup(true)
    ui.head_bg = nil
    ui.head = head
    container:addChild(head)
    self:initRichText(data, ui)
  end
  local spaceX = 10
  local spaceY = 12
  local item = self:createContent(data, extraData)
  local isSticker = self:isChatSticker(data)
  ui.chat_msg_bg:setContentSize(CCSizeMake(item.totalWidth + spaceX * 2, item.totalHeight + spaceY * 2))
  if data._summary then
    if data._summary._type == "pvp_replay" or data._summary._type == "tbc_replay" or data._summary._type == "dreamland_replay" then
      item.node:setPosition(spaceX, ui.chat_msg_bg:getContentSize().height - spaceY)
    elseif ed.isElementInTable(data._summary._type, {
      "heroes_link",
      "lantern_msg",
      "team_invite",
      "real_arena_invite"
    }) then
      item.node:setPosition(spaceX, ui.chat_msg_bg:getContentSize().height / 2)
    else
      ed.pt("++++++data._summary._type = " .. data._summary._type)
    end
    if ui.translate_btn then
      ui.translate_btn:setVisible(false)
    end
  else
    item.node:setPosition(spaceX, (ui.chat_msg_bg:getContentSize().height + item.totalHeight - item.height) * 0.5)
    if nil ~= item.translateNode then
      item.translateNode:setPosition(spaceX, (ui.chat_msg_bg:getContentSize().height - item.totalHeight + item.translateHeight) * 0.5)
      ui.chat_msg_bg:addChild(item.translateNode)
    end
    if ui.translate_btn then
      if ed.isMultiLanguage() and not isSticker then
        ui.translate_btn:setVisible(true)
        local msgBgPosX = ui.chat_msg_bg:getPositionX()
        local offsetX = item.totalWidth + spaceX * 2 + ui.translate_btn:getContentSize().width * 0.5 + 2
        ui.translate_btn:setPositionX(msgBgPosX + (isSelf and -offsetX or offsetX))
        ed.setTexture(ui.translate_btn, nil == item.translateNode and "UI/alpha/1080P/common/global/translate_button.png" or "UI/alpha/1080P/common/global/translate_button1.png")
      else
        ui.translate_btn:setVisible(false)
      end
    end
  end
  if isSticker then
    ui.chat_msg_bg:setOpacity(0)
    local rootNode = CCSprite:create()
    ui.chat_msg_bg:getParent():addChild(rootNode)
    local bgSize = ui.chat_msg_bg:getContentSize()
    local bgAnchor = ui.chat_msg_bg:getAnchorPoint()
    local targetAnchor = ccp(isSelf and 1 or 0, 0.5)
    rootNode:setContentSize(bgSize)
    local bgPosX, bgPosY = ui.chat_msg_bg:getPosition()
    bgPosX = bgPosX + (targetAnchor.x - bgAnchor.x) * bgSize.width
    bgPosY = bgPosY + (targetAnchor.y - bgAnchor.y) * bgSize.height
    rootNode:setAnchorPoint(targetAnchor)
    rootNode:setPosition(bgPosX, bgPosY)
    if ed.chatNetWork:checkAndUpdateChatTime(ed.chatManager.currentChannel, data._speaker_role_id, data._speak_time) then
      rootNode:stopAllActions()
      rootNode:setScale(0.44)
      local scaleAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.125, 1.21), CCEaseOut:create(CCScaleTo:create(0.29, 1), 2))
      rootNode:runAction(scaleAction)
    end
    rootNode:addChild(item.node)
  else
    ui.chat_msg_bg:setOpacity(255)
    ui.chat_msg_bg:addChild(item.node)
  end
  table.insert(self.msgListCell, {
    container = container,
    ui = ui,
    extraData = extraData,
    data = data,
    msgNode = item.node
  })
  local height = ui.chat_msg_bg:getContentSize().height + math.abs(ui.chat_msg_bg:getPositionY())
  self.msgList:addItem(container, ccp(0, self.ui.msg_list:getContentSize().height - self.msgListHeight))
  self.msgListHeight = self.msgListHeight + height
end

function chatMsgList:initRichText(data, ui)
  local isSelf = data._speaker_role_id == ed.getRoleId()
  local name = richText:new()
  name:setString(T("<text|chat_name|%s>", data._speaker_summary._name))
  name:setVerticalCenter()
  local width, height = name:getSize()
  name:setPosition(ccp(isSelf and 810 / ed.display.scaleFactor - width or 235 / ed.display.scaleFactor, -30 / ed.display.scaleFactor))
  ui.chat_msg_bg:getParent():addChild(name.rootNode)
  ui.name = name
  if data._speaker_summary._medal and data._speaker_summary._medal._medal_id then
    local sprite = ed.createSprite(ed.getMedalRes(data._speaker_summary._medal))
    sprite:setPosition(ccpAdd(ccp(name:getPosition()), ccp(isSelf and -5 or 5, 0)))
    sprite:setScale(0.15)
    ui.chat_msg_bg:getParent():addChild(sprite)
    ui.medalSprite = sprite
    name:setPosition(ccpAdd(ccp(name:getPosition()), ccp(isSelf and 8 or 20, 0)))
  end
  local level = richText:new()
  level:setAnchor(ccp(0.5, 0.5))
  local levelsize = ui.level_bg:getContentSize()
  level:setPosition(ccp(levelsize.width / 2, levelsize.height / 2))
  level:setVerticalCenter()
  level:setString(T("<text|chat_level|%s>", data._speaker_summary._level))
  ui.level_bg:addChild(level.rootNode)
  ui.level = level
end

function chatMsgList:reSortMsgPos()
  local height = 0
  for i = #self.msgListCell, 1, -1 do
    local cell = self.msgListCell[i]
    cell.container:setPosition(ccp(0, self.ui.msg_list:getContentSize().height - height))
    height = height + cell.ui.chat_msg_bg:getContentSize().height + math.abs(cell.ui.chat_msg_bg:getPositionY()) + 20
  end
end

function chatMsgList:updateMsgList(isFresh)
  if nil == isFresh then
    isFresh = false
  end
  local curChannelMsg = ed.chatNetWork.chatMessages[ed.chatManager.currentChannel]
  local curTranslateMsg = ed.chatNetWork.translateMessages[ed.chatManager.currentChannel] or {}
  local curChannelIndex = self.chatMessagesIndex[ed.chatManager.currentChannel]
  local chatMessages = {}
  local translateTab = {}
  local index = 1
  if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel then
    if ed.chatManager:getCurPrivateTarget().key then
      chatMessages = curChannelMsg[ed.chatManager:getCurPrivateTarget().key] or {}
      translateTab = curTranslateMsg[ed.chatManager:getCurPrivateTarget().key] or {}
    end
    index = curChannelIndex
  else
    chatMessages = curChannelMsg
    translateTab = curTranslateMsg
    index = curChannelIndex
  end
  print("chatMessages", #chatMessages)
  if nil == self.oldChatFlagTab then
    self.oldChatFlagTab = {}
    for i, v in ipairs(chatMessages) do
      self.oldChatFlagTab[v._chat_id] = true
    end
  else
    self.oldChatFlagTab = {}
    for i, v in ipairs(self.msgListCell) do
      if v.data then
        self.oldChatFlagTab[v.data._chat_id] = true
      end
    end
  end
  self.msgListHeight = 0
  self.msgList:clearList()
  self.msgListCell = {}
  self.linkButtons = {}
  if #chatMessages == 0 then
    self:clearMsgList()
    self.oldChatFlagTab = {}
    return
  end
  for i = math.max(#chatMessages - self.showMsgAmount - 1, 1), #chatMessages do
    self:showChatTime(chatMessages[i])
    self:msgListAddChatCell(chatMessages[i], translateTab[chatMessages[i]._chat_id])
  end
  self.chatMessagesIndex[ed.chatManager.currentChannel] = #chatMessages + 1
  self.msgList:initListHeight(self.msgListHeight, false)
  if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel and self.msgListHeight <= self.msgList.height and ed.chatManager:getCanSendChatHistoryFresh() and not ed.chatManager.OnChatHistoryFresh then
    ed.chatNetWork:getHistoryChat()
  end
  if not isFresh then
    local bottom = true
    local lastmsg = chatMessages[#chatMessages]
    if lastmsg and 1 < index then
      local isSelf = lastmsg._speaker_role_id == ed.getRoleId()
      if not isSelf then
        bottom = false
      end
    end
    if bottom then
      self.msgList:move2Bottom()
    end
    self.delegate:showSuspension(not bottom)
  end
end

function chatMsgList:clearMsgList()
  self.msgListHeight = 0
  self.chatMessagesIndex = {
    world_channel = 1,
    guild_channel = 1,
    personal_channel = 1,
    chatroom_channel = 1
  }
  self.msgCellIndex = nil
  self.translateIndex = nil
  self.msgListCell = {}
  self.oldChatFlagTab = nil
  self.linkbutton = nil
  self.linkButtons = {}
  self.msgList:clearList()
end

function chatMsgList:parseChatContent(content)
  local content_t = {}
  for str in string.gmatch(content, "<.->") do
    local temp = string.sub(str, 2, string.len(str) - 1)
    local str_arr = Split(temp, "|")
    if str_arr[1] == "text" then
      local str = string.format("<text|chat_content|%s>", str_arr[3])
      table.insert(content_t, str)
    else
      table.insert(content_t, str)
    end
  end
  content = table.concat(content_t)
  return content
end

function chatMsgList:isChatSticker(data)
  if nil == data._content then
    return false
  end
  if string.find(data._content, "<sticker|.->") then
    return true
  end
  return false
end

function chatMsgList:createContent(data, extraData, isSpell)
  local item
  local content = data._content
  local translateContent
  if data._content_type == 0 then
    local lanternMsg = data._summary and data._summary._lantern_msg
    if lanternMsg then
      local lanternMsgId = lanternMsg._msg_id
      local lanternConfig = ed.ui.headlineConfig.msglist[lanternMsgId]
      if lanternConfig.chatContextHandler then
        local param = {
          speakerRoleId = data._speaker_role_id,
          targetRoleId = data._target_role_id
        }
        content = lanternConfig.chatContextHandler(lanternMsg, param)
      end
    end
  elseif data._content_type == 1 then
    content = self:parseChatContent(content)
    if nil ~= extraData.translate_content then
      translateContent = self:parseChatContent(extraData.translate_content)
    end
  elseif data._content_type == 2 and data._summary then
    local type = data._summary._type
    if type == "pvp_replay" or type == "tbc_replay" or type == "dreamland_replay" then
      local replay = ed.chatBattleReplay.create(ed.copyProto(data))
      item = {
        node = replay.container,
        type = type,
        width = replay.width,
        height = replay.height,
        totalWidth = replay.width,
        totalHeight = replay.height
      }
      return item
    elseif type == "ladder_fight" then
      local panel = ed.chatLadderFight.create(data)
      item = {
        node = panel.container,
        type = type,
        width = panel.width,
        height = panel.height,
        totalWidth = panel.width,
        totalHeight = panel.height
      }
    end
  end
  if not item then
    local text = newRichText:new()
    text:setMaxWidth(800 / ed.display.scaleFactor)
    if isSpell then
      content = string.gsub(content, "chat_content", "chat_spell_content")
    end
    text:setString(content, extraData)
    text:setVerticalCenter()
    local width, height = text:getSize()
    item = {
      node = text:getRootNode(),
      type = "richText",
      height = height,
      width = width,
      totalWidth = width,
      totalHeight = height
    }
    local linkAll = text:getLinkAll()
    for idx = 1, #linkAll do
      local link = text:getLink(idx)
      link:setFlag(idx)
      table.insert(self.linkButtons, link)
    end
    if nil ~= translateContent then
      local translateText = newRichText:new()
      translateText:setMaxWidth(800 / ed.display.scaleFactor)
      if isSpell then
        translateContent = string.gsub(translateContent, "chat_content", "chat_spell_content")
      end
      translateText:setString(translateContent, extraData)
      translateText:setVerticalCenter()
      local translateWidth, translateHeight = translateText:getSize()
      item.translateNode = translateText:getRootNode()
      item.translateWidth = translateWidth
      item.translateHeight = translateHeight
      item.totalHeight = item.totalHeight + translateHeight + 5
      item.totalWidth = math.max(item.translateWidth, item.totalWidth)
    end
  end
  return item
end

function chatMsgList:showMsgListTip()
  local show = ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel and #self.msgListCell == 0
  self.ui.msg_list_tip:setVisible(show)
end

function chatMsgList:setTouchEnabled(enabled)
  self.msgList:setTouchEnabled(enabled)
end

function chatMsgList:touch(event, x, y)
  if ed.containsPoint(self.ui.msg_list, x, y) then
    ed.chatAddFriend:touch(event, x, y)
    ed.chatBattleReplay.touch(event, x, y)
    ed.chatLadderFight.touch(event, x, y)
    self:linktouch(event, x, y)
    self:headtouch(event, x, y)
    if ed.isMultiLanguage() then
      self:translatetouch(event, x, y)
    end
  end
end

function chatMsgList:getMsgCellByContent(content)
  if not string.find(content, "<text|chat_content|") then
    content = string.format("<text|chat_content|%s>", content)
  end
  for index = #self.msgListCell, 1, -1 do
    local v = self.msgListCell[index]
    if v.data and v.data._speaker_role_id == ed.getRoleId() and v.data._content == content then
      return v
    end
  end
  return nil
end

function chatMsgList:playMsgEffectBySpellId(spellId)
  local chatSpellTable = ed.getDataTable("ChatSpell")[spellId]
  local v = self:getMsgCellByContent(chatSpellTable.Spell)
  if v then
    local item = self:createContent(v.data, v.extraData, true)
    v.ui.chat_msg_bg:addChild(item.node)
    if self:isChatSticker(v.data) then
      v.ui.chat_msg_bg:setOpacity(0)
    else
      v.ui.chat_msg_bg:setOpacity(255)
    end
    v.msgNode:setVisible(false)
    item.node:setPosition(v.msgNode:getPosition())
    local height = v.ui.chat_msg_bg:getContentSize().height
    local msgListHeight = self.msgListHeight
    self.delegate:registerUpdateHandler("chatMsgList_playMsgEffect", function(dt)
      if msgListHeight >= self.msgList.height and msgListHeight >= self.msgListHeight then
        local listHeight = msgListHeight - height + v.ui.chat_msg_bg:getScale() * height
        self.msgList:initListHeight(listHeight, false)
        self.msgList:setListPos(ccp(0, listHeight - self.msgList.height))
      end
    end)
    v.ui.chat_msg_bg:runAction(CCSequence:create(ccArrayMake(CCSpawn:create(ccArrayMake(CCScaleTo:create(0.25, 1.3), CCCallFunc:create(function()
    end))), CCDelayTime:create(0.18), CCSpawn:create(ccArrayMake(CCScaleTo:create(0.18, 1), CCCallFunc:create(function()
    end))), CCDelayTime:create(0.3), CCCallFunc:create(function()
      if msgListHeight >= self.msgList.height and msgListHeight >= self.msgListHeight then
        self.msgList:initListHeight(msgListHeight, false)
        self.msgList:setListPos(ccp(0, msgListHeight - self.msgList.height))
      end
      v.ui.chat_msg_bg:setScale(1)
      v.msgNode:setVisible(true)
      item.node:removeFromParentAndCleanup(true)
      self.delegate:removeUpdateHandler("chatMsgList_playMsgEffect")
    end))))
  end
end

function chatMsgList:headtouch(event, x, y)
  if event == "began" then
    for k, v in ipairs(self.msgListCell) do
      local head_bg = v.ui.head
      if ed.containsPoint(head_bg, x, y) then
        self.msgCellIndex = k
        return true
      end
      if v.ui.medalSprite and ed.containsPoint(v.ui.medalSprite, x, y) then
        self.medalCellIndex = k
        local extraData = self.msgListCell[self.medalCellIndex].extraData
        local medalId = extraData.summary._medal and extraData.summary._medal._medal_id or 0
        local data
        if medalId and 0 < medalId then
          for _, v in pairs(ed.getDataTable("Medal")) do
            if medalId == v.MedalID then
              data = v
              break
            end
          end
        end
        if not data then
          return
        end
        ed.UITool.openView("showMedalPop", {
          data = data,
          x = x,
          y = y
        })
        return true
      end
    end
  elseif event == "ended" then
    if self.msgCellIndex ~= nil then
      local data = self.msgListCell[self.msgCellIndex].extraData
      if ed.getRoleId() ~= data.roleId then
        ListenEventOnce("req_home_page", function(data)
          local panel = ed.ui.PlayerInfoPanel.create(data, false)
          panel:popWindow()
        end, self.eventScope)
        ed.PlayerInfoNetwork:requestHomePage(data.roleId)
      else
        ed.PlayerInfoNetwork:openPanel()
      end
      self.msgCellIndex = nil
      return true
    elseif self.medalCellIndex ~= nil then
      if ed.newShowMedalPop then
        ed.newShowMedalPop:destroy({skipAnim = false})
      end
      self.medalCellIndex = nil
      return true
    end
  end
end

function chatMsgList:translatetouch(event, x, y)
  if event == "began" then
    for k, v in ipairs(self.msgListCell) do
      local translateBtn = v.ui.translate_btn
      if translateBtn and ed.containsPoint(translateBtn, x, y) then
        self.translateIndex = k
        return true
      end
    end
  elseif event == "ended" and self.translateIndex ~= nil then
    local item = self.msgListCell[self.translateIndex]
    if item and 1 == item.data._content_type then
      local channel = ed.chatManager.currentChannel
      local key
      if ed.chatManager.currentChannel == ed.chatManager.ChannelEnum.personal_channel then
        key = ed.chatManager:getCurPrivateTarget().key
      end
      local chatId = item.data._chat_id
      local chatContent = item.data._content
      local translateTab = ed.chatNetWork.translateMessages[channel]
      if nil ~= translateTab and nil ~= key then
        translateTab = translateTab[key]
      end
      if nil ~= translateTab and nil ~= translateTab[chatId] then
        print("also translate")
        return
      end
      ed.chatNetWork:sendTranslateChat(channel, key, chatId, chatContent)
    else
      print("can't translate", item)
    end
    self.translateIndex = nil
    return true
  end
end

function chatMsgList:linktouch(event, x, y)
  if event == "began" then
    for k, v in ipairs(self.linkButtons) do
      local done = v:touch(event, x, y)
      if done then
        self.linkbutton = v
        return done
      end
    end
  elseif event == "ended" and self.linkbutton ~= nil then
    self.linkbutton:touch(event, x, y)
    self.linkbutton = nil
    return true
  end
end

ed.ui.chatMsgList = chatMsgList
