local base = ed.ui.popwindow
local chatEntrance = newclass(base.mt)
ed.ui.chatEntrance = chatEntrance

function chatEntrance.getInstance()
  if not chatEntrance.instance then
    chatEntrance.instance = chatEntrance.create()
  end
  return chatEntrance.instance
end

function chatEntrance.create(container)
  local self = {}
  setmetatable(self, chatEntrance.mt)
  chatEntrance.eventScope = {}
  self:initView()
  self:addEventListener()
  return self
end

function chatEntrance:addEventListener()
  self.ui.enter_touch:setTouchEnabled(true)
  self.ui.enter_touch:registerScriptTouchHandler(self:onClickEntrance(), false, 0, true)
  ListenEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_ENTRANCE, function(data)
    self:addItemData(data)
  end, chatEntrance.eventScope)
  ListenEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_REDPOINT, function(data)
    self:showRedPoint()
  end, chatEntrance.eventScope)
  ListenEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_TOPNOTIFY, function(data)
    self:handleChatTopNotify(data)
  end, chatEntrance.eventScope)
end

function chatEntrance:initView()
  self.container = CCLayer:create()
  self.container:retain()
  self.ui = {}
  ed.editorui(ed.uieditor.chatEntrance, {
    container = self.container,
    ui = self.ui
  })
  self:createListView()
end

function chatEntrance:createItem(params)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = params.content,
    color = params.color,
    maxWidth = self.listsize.width,
    fontSize = params.fontSize,
    lineSpacing = 0
  })
  autoText:setVerticalCenter()
  return autoText
end

function chatEntrance:createRichTextItem(params)
  local richText = richText:new()
  local content = params.content
  richText:setMaxWidth(self.listsize.width)
  richText:setString(content)
  richText:setVerticalCenter()
  return richText
end

function chatEntrance:createListView()
  self.spaceY = 5
  self.listsize = self.ui.msg_list:getContentSize()
  local w, h = self.listsize.width, self.listsize.height
  local info = {
    cliprect = CCRectMake(0, 0, w, h),
    container = self.ui.msg_list,
    priority = -300,
    noshade = true
  }
  self.msgList = ed.draglist.create(info)
  local autoText = self:createItem({
    content = T("\230\172\162\232\191\142\230\157\165\229\136\176\229\176\143\229\134\176\229\134\176\228\184\150\231\149\140"),
    color = ccc3(255, 165, 49),
    fontSize = 14
  })
  local width, height = autoText:getCurContentSize()
  self.msgList:addItem(autoText.node, ccp(0, self.listsize.height - self.msgList.listHeight - height / 2 - self.spaceY))
  self.msgList:initListHeight(self.msgList.listHeight + height + self.spaceY * 2)
end

function chatEntrance:addItemData(data)
  if not data then
    return
  end
  if ed.blacklist.isInBlacklist(data._contents._speaker_role_id) then
    return
  end
  if not self.dataList then
    self.dataList = {}
  end
  if #self.dataList >= 10 then
    table.remove(self.dataList, 1)
  end
  table.insert(self.dataList, data)
  self.msgList:clearList()
  local totalHeight = 0
  for index, data in ipairs(self.dataList) do
    local channel = data._channel
    local contents = data._contents
    local content_type = contents._content_type
    local isSystem = content_type == 0
    local msg = ""
    if channel == "world_channel" then
      msg = string.format("<extra|chat_tag|UI/alpha/1080P/chat/chat_blue_tag.png|chat_tag_world|%s>", T("\230\156\172\230\156\141"))
    elseif channel == "guild_channel" then
      msg = string.format("<extra|chat_tag|UI/alpha/1080P/chat/chat_green_tag.png|chat_tag_guild|%s>", T("\229\133\172\228\188\154"))
    end
    if msg ~= "" then
      local content = contents._content or ""
      if string.find(content, "<link|real_arena") then
        local ruleType, roomId = string.match(content, "<link|real_arena|(%w+)|(%d*)>")
        content = string.gsub(content, "<link|real_arena|([^>]+)>", string.format(T("<text|chat_content|\232\175\184\231\142\139\228\186\137\233\156\184\239\188\154\233\130\128\232\175\183\229\138\160\229\133\165\230\136\191\233\151\180\239\188\154%s>"), roomId))
      end
      local content_t = {}
      for str in string.gmatch(content, "<.->") do
        local temp = string.sub(str, 2, string.len(str) - 1)
        local str_arr = Split(temp, "|")
        if str_arr[1] == "text" then
          local text_temp = ""
          for i, c, b in utf8.chars(str_arr[3]) do
            text_temp = text_temp .. T("<text|chat_content|%s>", c)
          end
          table.insert(content_t, text_temp)
        elseif str_arr[1] == "sticker" then
          local row = ed.getDataTable("Sticker")[tonumber(str_arr[2])]
          if row then
            local str = T("\227\128\144\232\161\168\230\131\133\229\140\133\239\188\154%s\227\128\145", row.Tag)
            local text_temp = ""
            for i, c, b in utf8.chars(str) do
              text_temp = text_temp .. T("<text|chat_content|%s>", c)
            end
            table.insert(content_t, text_temp)
          end
        else
          table.insert(content_t, str)
        end
      end
      content = table.concat(content_t)
      if isSystem then
        local noticeImage = "<sprite|UI/alpha/1080P/headline/notice.png|0.4>"
        local content = string.format(T("<text|chat_pvp_link|%s>"), T("\231\179\187\231\187\159\229\185\191\230\146\173"))
        msg = T("%s%s%s", msg, noticeImage, content)
      else
        local medalStr = ""
        if contents._speaker_summary and contents._speaker_summary._medal and contents._speaker_summary._medal._medal_id then
          local src = ed.getMedalRes(contents._speaker_summary._medal)
          medalStr = T("<sprite|%s|0.17>", src)
        end
        local speakerName = contents._speaker_summary and contents._speaker_summary._name or ""
        msg = T("%s%s<text|chatEntranceMsgName|%s:>%s", msg, medalStr, speakerName, content)
      end
      local richText = self:createRichTextItem({
        content = msg,
        color = ccc3(255, 252, 231),
        fontSize = 14
      })
      local width, height = richText:getSize()
      self.msgList:addItem(richText.rootNode, ccp(0, self.listsize.height - totalHeight - height / 2))
      totalHeight = totalHeight + height + self.spaceY
    end
  end
  self.msgList:initListHeight(totalHeight)
  self.msgList:move2Bottom()
end

function chatEntrance:showRedPoint()
  local num = ed.chatNetWork:getAllRedPointNum()
  self.ui.rednum:setString(num)
  self.ui.redpoint:setVisible(0 < num)
end

function chatEntrance:handleChatTopNotify(data)
  if not data then
    return
  end
  if data._channel == ed.chatManager.ChannelEnum.personal_channel and ed.chatManager.chatPopWin.chatMainWin == nil then
    ed.ui.chatTopWindow:noticePrivateHandler(data)
  end
end

function chatEntrance:addToScene(scene)
  self:removeFormScene()
  self.scene = scene
  if self.scene.identity == "mainScene" then
    if self.scene and self.scene.mainLayer then
      self.scene.mainLayer:addChild(self.container)
      ed.layout.setNodePosWithWorldPos(self.container, ccp(ed.display.getNotchHeight(), 0))
      ed.chatManager.chatPopWin.chatEntrance = self
      if ed.getPopWindow("chatMainWin") then
        ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatMainWin)
      else
        ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatEntrance)
      end
    end
    return
  end
  if self.scene and self.scene.mainLayer then
    ed.chatManager.chatPopWin.chatEntrance = self
    ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatEntrance)
  end
end

function chatEntrance:removeFormScene()
  ed.chatManager.chatPopWin.chatEntrance = nil
  ed.chatManager:setOperateChatWin(nil)
  self.scene = nil
  if self.container:getParent() then
    self.container:getParent():removeChild(self.container, true)
  end
end

function chatEntrance:addToPopWindow(window)
  window.mainLayer:addChild(self.container)
  ed.layout.setNodePosWithWorldPos(self.container, ccp(ed.display.getNotchHeight(), 0))
  ed.chatManager.chatPopWin.chatEntrance = self
  if ed.getPopWindow("chatMainWin") then
    ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatMainWin)
  else
    ed.chatManager:setOperateChatWin(ed.chatManager.ChatWinEnum.chatEntrance)
  end
  return self.container, self.ui
end

function chatEntrance:removeFormPopWindow()
  ed.chatManager.chatPopWin.chatEntrance = nil
  ed.chatManager:setOperateChatWin(nil)
  if self.container:getParent() then
    self.container:removeFromParentAndCleanup(true)
  end
end

function chatEntrance:onClickEntrance()
  local isPress, pos
  
  local function handler(event, x, y)
    if ed.chatManager.chatPopWin.chatMainWin == nil then
      if event == "began" then
        if ed.containsPoint(self.ui.enter_touch, x, y) then
          isPress = true
          pos = ccp(x, y)
          return true
        else
          return false
        end
      elseif event == "moved" then
        if pos and math.abs(pos.y - y) > 2 then
          isPress = false
          return true
        else
          return false
        end
      elseif event == "ended" then
        if isPress and ed.containsPoint(self.ui.enter_touch, x, y) then
          ed.chatManager:openChatMainWin(ed.chatManager.currentChannel)
          return true
        else
          return false
        end
      end
    end
  end
  
  return handler
end
