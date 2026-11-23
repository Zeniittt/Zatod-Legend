local chatTipBtnView = {}
ed.ui.chatTipBtnView = chatTipBtnView
chatTipBtnView.__index = chatTipBtnView
local chatTipBtnViewSpace = {}
local instance
local chatEvent = ed.chatEvent.eventType
local noShow_secen_identity = {
  "debuglogin",
  "serverlogin",
  "logo"
}

function chatTipBtnView:getInstance()
  if not instance then
    instance = self
    self:init()
  end
  return instance
end

function chatTipBtnView:init()
  self.curNewMsgNum = 0
  self.mainLayer = CCLayer:create()
  self.mainLayer:retain()
  self:initBttoun()
  self:createListView()
  self:friendMailBut()
  self.mainLayer:setTouchEnabled(false)
  ed.ui.chatMain.getInstace()
  self:hideRedTip()
  self:registerNotify()
  self:setTouchEnabled(true)
end

function chatTipBtnView:friendMailBut()
  self.ui.butt_mail:setVisible(false)
end

function chatTipBtnView:setTouchEnabled(bool)
  self._touchEnabled = bool
  self.mainLayer:setVisible(bool)
end

function chatTipBtnView:registerNotify()
  ListenEvent(chatEvent.NoticeToPrivateChatTipView, function(data)
    self:showRedTip(data)
  end, chatTipBtnViewSpace)
  ListenEvent(chatEvent.NoticeToNewChatView, function(num)
    if not ed.isOpenChat then
      self.curNewMsgNum = self.curNewMsgNum + num
      self.ui.redPoint:setVisible(true)
      self.ui.msg_num:setString(tostring(self.curNewMsgNum))
      self:resfreshRedWidth()
    end
  end, chatTipBtnViewSpace)
  ListenEvent("NoticeUpdateMsg", function(num)
    if not ed.isOpenChat then
      self.curNewMsgNum = num
      self.ui.redPoint:setVisible(true)
      self.ui.msg_num:setString(tostring(self.curNewMsgNum))
      self:resfreshRedWidth()
    end
  end, chatTipBtnViewSpace)
  ListenEvent("SysTemMsgEvent", self:systemNewMsg(), chatTipBtnViewSpace)
  ListenEvent("channelMsgEvent", function(datas)
    self:serverNewMsg(datas or {})
  end, chatTipBtnViewSpace)
end

function chatTipBtnView:unRegisterNotify()
  CloseScope(chatTipBtnViewSpace)
end

function chatTipBtnView:initBttoun()
  self.ui = {}
  ed.editorui(ed.uieditor.chatTipBtnView, {
    container = self.mainLayer,
    ui = self.ui
  })
  self.redWidth = self.ui.redPoint:getContentSize().width
  self.redHight = self.ui.redPoint:getContentSize().height
  self.ui.chatTipLay:setPosition(-30, -10)
end

function chatTipBtnView:chatBtnTouch()
  local btntouchHandler = self:checkBtnTouch()
  local chatBoxBgTouchHandler = self:checkBoxBgTouch()
  
  local function handler(event, x, y)
    if not self._touchEnabled then
      return
    end
    if type(x) ~= "number" or type(y) ~= "number" then
      return false
    end
    local result = btntouchHandler(event, x, y)
    result = self:getChatMsgVisible() and ed.containsPoint(self.ui.chatMsg_bg, x, y) or result
    if not self.scene then
      return result
    end
    if self.mainLayer == nil or not self.mainLayer:isVisible() then
      return result
    end
    chatBoxBgTouchHandler(event, x, y)
    self.listView:touch(event, x, y)
    if event == "began" then
      return result
    elseif event == "moved" then
    elseif event == "ended" then
    end
  end
  
  return handler
end

function chatTipBtnView:checkBtnTouch()
  local isPress, btn
  
  local function handler(event, x, y)
    if self.ui.chatTip_2:isVisible() then
      btn = self.ui.chatTip_2
    elseif self.ui.chatTip:isVisible() then
      btn = self.ui.chatTip
      if not ed.containsPoint(btn, x, y) then
        btn = self.ui.butt_mail
      end
      if not ed.containsPoint(btn, x, y) then
        btn = self.ui.butt_friend
      end
    elseif self.ui.chatTip_3:isVisible() then
      btn = self.ui.chatTip_3
    end
    local result
    if event == "began" then
      if ed.containsPoint(btn, x, y) then
        isPress = true
        btn:setScale(0.95)
        result = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(btn, x, y) then
        if btn == self.ui.butt_mail then
          local panel = ed.ui.mailbox.create()
          panel:popWindow(100)
          pp(" \230\181\139\232\175\149\230\137\147\229\141\176================= ")
        elseif btn == self.ui.butt_friend then
          ed.showToast(T("\229\138\159\232\131\189\229\188\128\229\143\145\228\184\173"), ccp(400, 430))
        else
          self:hideRedTip()
          ed.playEffect(ed.sound.sellProp.add)
          ed.chatNetDataMrg:reqChatContact(function()
            ed.ui.chatMain.getInstace():popWindow(self.identity)
          end)
        end
      end
      isPress = false
      btn:setScale(1)
    end
    return result
  end
  
  return handler
end

function chatTipBtnView:checkBoxBgTouch()
  local isPress, btn, pos
  
  local function handler(event, x, y)
    if not self.ui.chatMsg_bg:isVisible() then
      return
    end
    btn = self.ui.chatMsg_bg
    local result
    if event == "began" then
      if ed.containsPoint(btn, x, y) then
        isPress = true
        pos = ccp(x, y)
      end
    elseif event == "moved" then
      if pos and math.abs(pos.y - y) > 2 then
        isPress = false
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(btn, x, y) then
        self:hideRedTip()
        ed.playEffect(ed.sound.sellProp.add)
        ed.chatNetDataMrg:reqChatContact(function()
          ed.ui.chatMain.getInstace():popWindow(self.identity)
        end)
      end
      isPress = false
    end
    return result
  end
  
  return handler
end

function chatTipBtnView:showRedTip(data)
  if string.find(data._contents._content or "", "\233\130\128\232\175\183\228\189\160\229\141\143\229\138\169\229\133\172\228\188\154\232\139\177\233\155\132\229\135\186\229\135\187") then
    return
  end
  if data._channel == "personal_channel" and not ed.isOpenChat then
    self.curNewMsgNum = self.curNewMsgNum + 1
    self.ui.redPoint:setVisible(true)
    self.ui.msg_num:setString(tostring(self.curNewMsgNum))
    self:resfreshRedWidth()
    ed.playEffect(ed.sound.main.chatMsg)
  elseif data._channel == "chatroom_channel" and not ed.isOpenChat then
    if data._contents._speaker_role_id ~= ed.getRoleId() then
      self.curNewMsgNum = self.curNewMsgNum + 1
      self.ui.redPoint:setVisible(true)
      self.ui.msg_num:setString(tostring(self.curNewMsgNum))
      self:resfreshRedWidth()
      ed.playEffect(ed.sound.main.chatMsg)
    end
  elseif data._channel ~= "personal_channel" and data._channel ~= "chatroom_channel" then
    self:showChatBox()
    self:addItemData(data)
  end
end

function chatTipBtnView:serverNewMsg(datas)
  local newdatas = {}
  for _, data in ipairs(datas) do
    if math.abs(data.timestamp - ed.getServerTime()) < 2 then
      newdatas[#newdatas + 1] = data
    end
  end
  table.sort(newdatas, function(a, b)
    return a.timestamp < b.timestamp
  end)
  for i, data in ipairs(newdatas) do
    if not ed.blacklist.isInBlacklist(data.send_user.uid, data.send_user.svr_id or tonumber(real_game_server_id)) then
      local contents = data.content.channel_chat
      local speakerName = data.send_user.name
      local msg = ""
      msg = string.format("<sprite src=UI/alpha/HVGA/chat/Chat_GlobalChat.png><lable color=headlineGreen >[%s]:</lable>%s", speakerName, ed.ui.autoText:FormatContent(contents, 0.2))
      print(msg)
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = msg,
        color = ccc3(255, 234, 198),
        maxWidth = 230,
        fontSize = 12
      })
      local width, height = autoText:getCurContentSize()
      self.listView:addItem(autoText.node, nil, {
        width = width,
        height = height - 2
      })
      self.listView.dragList:setListPos(ccp(0, 0))
    end
  end
end

function chatTipBtnView:hideRedTip()
  self.curNewMsgNum = 0
  self.ui.redPoint:setVisible(false)
  self.ui.msg_num:setString(tostring(self.curNewMsgNum))
  self:resfreshRedWidth()
end

function chatTipBtnView:resfreshRedWidth()
  local width = self.ui.msg_num:getContentSize().width
  if width + 8 > self.redWidth then
    width = width + 8
    local pos = width / 2
    self.ui.msg_num:setPositionX(pos)
  else
    width = self.redWidth
  end
  self.ui.redPoint:setContentSize(CCSizeMake(width, self.redHight))
end

function chatTipBtnView:setVisible(bool)
  self.mainLayer:setTouchEnabled(bool)
  self.mainLayer:setVisible(bool)
end

function chatTipBtnView:addToSecen(scene)
  self.scene = scene
  self.identity = self.scene.identity
  self.mainLayer:unregisterScriptTouchHandler()
  self.mainLayer:setTouchEnabled(false)
  ed.chatNetDataMrg:closeReqChatMsg()
  if self.mainLayer:getParent() then
    self.mainLayer:getParent():removeChild(self.mainLayer, true)
  end
  local isCanAdd = false
  local btnType
  self.isShowBox = false
  local tbl = ed.getDataTable("ChatDisplay")
  for k, v in pairs(tbl) do
    if k ~= "name" then
      local str = v["Interface Name"]
      if str == self.identity then
        isCanAdd = true
        btnType = v.ChatIcon
        self.isShowBox = v["Display InfoBoard"] == 1
      end
    end
  end
  if not isCanAdd then
    return
  end
  if btnType == 1 then
    self.ui.chatTip:setVisible(true)
    self.ui.chatTip_2:setVisible(false)
    self.ui.chatTip_3:setVisible(false)
    self.ui.redPoint:setPosition(ccp(22, 50))
  elseif btnType == 2 then
    self.ui.chatTip:setVisible(false)
    self.ui.chatTip_2:setVisible(true)
    self.ui.chatTip_3:setVisible(false)
    self.ui.redPoint:setPosition(ccp(35.16, 245.31))
  else
    self.ui.chatTip_3:setVisible(true)
    self.ui.chatTip:setVisible(false)
    self.ui.chatTip_2:setVisible(false)
    self.ui.redPoint:setPosition(ccp(35.16, 245.31))
  end
  if self.isShowBox then
    self:showChatBox()
  else
    self:hideChatBox()
  end
  if self.identity == "mainScene" or self.identity == "realarena" or self.identity == "warterritorymain" or self.identity == "SeasonArenaCenter" then
    if self.scene and self.scene.mainLayer then
      self.scene.mainLayer:addChild(self.mainLayer, 10)
      self.mainLayer:setTouchEnabled(true)
      self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -80, true)
    end
  elseif self.identity == "offlinequestmainpanel" then
    if self.scene and self.scene.scene then
      self.scene.scene:addChild(self.mainLayer, 3)
      self.mainLayer:setTouchEnabled(true)
      self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -100, true)
    end
  elseif self.identity == "guild" then
    if self.scene and self.scene.scene then
      self.scene.scene:addChild(self.mainLayer, 3)
      self.mainLayer:setTouchEnabled(true)
      self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -10, true)
    end
  elseif self.identity == "legendMainScene" or self.identity == "cr_arena_main_scene" then
    if self.scene and self.scene.scene then
      self.scene.scene:addChild(self.mainLayer, 10)
      self.mainLayer:setTouchEnabled(true)
      self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -200, true)
    end
  elseif self.identity == "bookmainscene" then
    if self.scene and self.scene.scene then
      self.scene.scene:addChild(self.mainLayer, 200)
      self.mainLayer:setTouchEnabled(true)
      self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -301, true)
    end
  elseif self.identity == "bookmapscene" then
    if self.scene and self.scene.scene and not self.scene.isSinglePlayer then
      self.scene.scene:addChild(self.mainLayer, 200)
      self.mainLayer:setTouchEnabled(true)
      self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -301, true)
    end
  elseif self.scene and self.scene.scene then
    self.scene.scene:addChild(self.mainLayer, 200)
    self.mainLayer:setTouchEnabled(true)
    self.mainLayer:registerScriptTouchHandler(self:chatBtnTouch(), false, -301, true)
  end
  ed.layout.layoutWithMagin(self.mainLayer, {left = 5, bottom = 0}, true)
  self.isNoMsg = false
end

function chatTipBtnView:removeFormSecen()
  if self.mainLayer:getParent() then
    self.mainLayer:getParent():removeChild(self.mainLayer, true)
  end
  self.mainLayer:unregisterScriptTouchHandler()
  self.mainLayer:setTouchEnabled(false)
  self.scene = nil
end

function chatTipBtnView:hideChatBox()
  self.ui.chatMsg_bg:setVisible(false)
  self.ui.butt_mail:setVisible(false)
  self.ui.butt_friend:setVisible(false)
end

function chatTipBtnView:showChatBox()
  if self.isShowBox then
    self.ui.chatMsg_bg:setVisible(true)
    self.ui.butt_mail:setVisible(true)
    self.ui.butt_friend:setVisible(true)
  end
end

function chatTipBtnView:getChatMsgVisible()
  return self.ui.chatMsg_bg:isVisible()
end

function chatTipBtnView:createListView()
  local w, h = self.ui.msg_list:getContentSize().width, self.ui.msg_list:getContentSize().height
  self.listView = ed.ui.chatListView.new()
  self.listView:setPanelLayer(self.ui.msg_list)
  self.listView:initParem({
    base = {
      colNum = 1,
      itemWidthInner = 5,
      layoutMode = "up",
      maxItem = 10,
      heightInner = 0,
      initHeight = 0,
      initWidth = 0,
      container = self.ui.msg_list,
      cliprect = CCRectMake(1, 1, w, h),
      noshade = true,
      zorder = 1,
      selfDealMessage = true
    }
  })
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = "\230\172\162\232\191\142\230\157\165\229\136\176\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135",
    color = ccc3(255, 234, 198),
    maxWidth = 250,
    fontSize = 13
  })
  local width, height = autoText:getCurContentSize()
  self.listView:addItem(autoText.node, nil, {width = width, height = height})
  self.listView.dragList:setListPos(ccp(0, 0))
end

function chatTipBtnView:addItemData(data)
  if not data then
    return
  end
  local channel = data._channel
  local contents = data._contents
  local str = ed.chatUtil:formatContent(contents._content or "")
  local speakerName = contents._speaker_summary._name
  local msg = ""
  if channel == "world_channel" then
    msg = "<sprite src=UI/alpha/HVGA/chat/Chat_LocalChat.png>"
    msg = string.format("%s<lable color=headlineGreen >[%s]:</lable>%s", msg, speakerName, str)
  elseif channel == "guild_channel" then
    msg = "<sprite src=UI/alpha/HVGA/chat/Chat_GuildChannel.png>"
    msg = string.format("%s<lable color=headlineGreen >[%s]:</lable>%s", msg, speakerName, str)
  end
  msg = string.gsub(msg, "<emoji|.+>", "\227\128\144\232\129\138\229\164\169\232\161\168\230\131\133\227\128\145")
  msg = string.gsub(msg, "<link|redBag.+>", "\227\128\144\231\186\162\229\140\133\227\128\145")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = msg,
    color = ccc3(255, 234, 198),
    maxWidth = 230,
    fontSize = 12
  })
  local width, height = autoText:getCurContentSize()
  self.listView:addItem(autoText.node, nil, {
    width = width,
    height = height - 2
  })
  self.listView.dragList:setListPos(ccp(0, 0))
end

function chatTipBtnView:systemNewMsg()
  local function handler(data)
    do return end
    
    if data then
      local type = data.type
      local text = data.text
      local msg = ""
      if type == "Server" then
        msg = "<sprite src=UI/alpha/HVGA/chat/Chat_LocalChat.png>"
      elseif type == "Guild" then
        msg = "<sprite src=UI/alpha/HVGA/chat/Chat_GuildChannel.png>"
      end
      msg = string.format("%s%s", msg, speakerName, text)
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = msg,
        color = ccc3(255, 234, 198),
        maxWidth = 230,
        fontSize = 12
      })
      local width, height = autoText:getCurContentSize()
      self.listView:addItem(autoText.node, nil, {
        width = width,
        height = height - 2
      })
      self.listView.dragList:setListPos(ccp(0, 0))
    end
  end
  
  return handler
end

local shieldSecen = {
  "bookmapscene",
  "cr_arena_main_scene",
  "bookmainscene",
  "cr_arena_battle_data_statistics",
  "multiplayerStagedone"
}

local function checkIsCanClickChatLink()
  return false
end

ed.checkIsCanClickChatLink = checkIsCanClickChatLink
