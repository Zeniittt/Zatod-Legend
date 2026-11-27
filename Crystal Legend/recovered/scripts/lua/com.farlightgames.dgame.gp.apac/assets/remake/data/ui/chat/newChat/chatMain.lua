local chatMain = {}
chatMain.__index = chatMain
ed.ui.chatMain = chatMain
chatMainSpace = {}
local chatEvent = ed.chatEvent.eventType
local instace
ed.ui.chatMain.chatServerTime = 5
ed.isOpenChat = false
local lsr = ed.ui.awakelsr.create()
chatMain.chatMode = {
  world = "world_channel",
  guild = "guild_channel",
  private = "personal_channel",
  guildhero = "guildhero_channel",
  chatroom = "chatroom_channel",
  chatServer = "chatServer_channel"
}
local HomePageScope = {}

function chatMain.getInstace()
  if not instace then
    instace = chatMain.create()
  end
  return instace
end

function chatMain.create()
  local self = {}
  setmetatable(self, chatMain)
  self:init()
  return self
end

function chatMain:init()
  if not self.noShade then
    self.mainLayer = CCLayerColor:create(shadeColor or ccc4(0, 0, 0, 150))
  else
    self.mainLayer = CCLayer:create()
  end
  self.layer = CCLayer:create()
  self.curChannel = "world"
  self.curChatMode = self.chatMode[self.curChannel]
  self.mainLayer:retain()
  local mainLayer = self.mainLayer
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  self.ui = {}
  ed.editorui(ed.uieditor.chatMainView, {
    container = self.container,
    ui = self.ui
  })
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, -505, true)
  self.ui.chat_layer:setPositionY(0)
  self:changeCloseBtnPos()
  ed.ui.chatSuspension.getInstance().create()
  ed.ui.chatSuspension.getInstance():init(self.ui)
  local chatpanel = ed.getChatPanel()
  mainLayer:addChild(chatpanel:getRootLayer())
  self.worldChatContext = ed.ui.chatContext.new({parentLogic = self})
  self.worldChatContext:setChannel("world_channel")
  self.guildChatContext = ed.ui.chatContext.new({parentLogic = self})
  self.guildChatContext:setChannel("guild_channel")
  self.chatPrivateContextMrg = ed.ui.chatPrivateContextMrg.new({parentLogic = self})
  self.chatFriendMgr = ed.ui.chatFriendMgr.create({parentLogic = self})
  self.chatRoomMgr = ed.ui.chatRoomMgr.create({parentLogic = self})
  self.chatRoomContextMrg = ed.ui.chatRoomContextMrg.create({parentLogic = self})
  self.chatGuildMemberMgr = ed.ui.chatGuildMemberMgr.create({parentLogic = self})
  self.chatSendMsgLogic = ed.ui.chatSendMsgLogic.create({parentLogic = self})
  self.chatServerMgr = ed.ui.chatServerMgr.create({parentLogic = self})
  self.chatServerContextMrg = ed.ui.chatServerContextMrg.new({parentLogic = self})
  self.chatModeList = ed.ui.chatModeList.create({
    parentLogic = self,
    mode = self.curChannel
  })
  ed.Chatask.EnterChatask(self.ui.task_layer)
  self:StartListenChatNotify()
end

function chatMain:StartListenChatNotify()
  ListenEvent("NoticeToPrivate", self:noticeToPrivate(), chatMainSpace)
  ListenEvent("NoticeToChatRoom", self:onticeToChatRoom(), chatMainSpace)
  ListenEvent("chat_private_target", self:selectObjPrivateChat(), chatMainSpace)
  ListenEvent(chatEvent.ReqContactData, self:reqContactDataHandler(), chatMainSpace)
  ListenEvent(chatEvent.NoticeToNewChatView, self:noticeNewMsg(), chatMainSpace)
  ListenEvent("NoticeUpdateMsg", self:noticeNewMsg(), chatMainSpace)
  ListenEvent("SysTemMsgEvent", self:systemNewMsg(), chatMainSpace)
  ListenEvent("add_friend_success", self:addFriendMsg(), chatMainSpace)
  ListenEvent("del_contact_event", self:delContactHandler(), chatMainSpace)
  ListenEvent("update_contact_event", self:updateContactHandler(), chatMainSpace)
  ListenEvent("CloseChatView", function()
    self:closeChatView()
  end, chatMainSpace)
  ListenTimer(Timer:Always(0.3), function()
    ed.ui.chatSuspension.getInstance():checkRangeDistance()
  end, chatMainSpace)
  ListenTimer(Timer:Always(30), function()
    ed.chatMedal.getInstance():checkInvalidObj()
  end, chatMainSpace)
  ListenEvent("serverChatOpenPanelEvent", function(data)
    self:serverOpenPanelHandler(data)
  end, chatMainSpace)
  ListenEvent("channelSubEvent", function(version)
  end, chatMainSpace)
end

function chatMain:btGetMainTouchHandler()
  local self = self
  
  local function handler(event, x, y)
    xpcall(function()
      self:closeTouch(event, x, y)
      ed.ui.chatSuspension.getInstance():touchEvent(event, x, y)
      self.worldChatContext:touch(event, x, y)
      self.guildChatContext:touch(event, x, y)
      self.chatFriendMgr:touch(event, x, y)
      self.chatPrivateContextMrg:touch(event, x, y)
      self.chatGuildMemberMgr:touch(event, x, y)
      self.chatRoomMgr:touch(event, x, y)
      self.chatServerMgr:touch(event, x, y)
      self.chatServerContextMrg:touch(event, x, y)
      self.chatRoomContextMrg:touch(event, x, y)
      ed.chatBattleShareMgr:touch(event, x, y)
      ed.chatCook:touch(event, x, y)
      ed.chatAddFriend:touch(event, x, y)
      ed.chatMedal.getInstance():touch(event, x, y)
      if self.chatModeList then
        self.chatModeList:touch(event, x, y)
      end
      if self.chatSendMsgLogic then
        self.chatSendMsgLogic:touch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

function chatMain:popWindow(identity)
  self.identity = identity
  if self.mainLayer:getParent() then
    self.mainLayer:removeFromParentAndCleanup(true)
    ed.chatNetDataMrg:closeReqChatMsg()
  end
  self:ccScene():addChild(self.mainLayer, 200)
  self:openChatView()
  ed.chatNetDataMrg:startReqChatMsg()
  ed.isOpenChat = true
  if self.identity == "bookmapscene" then
    if self.chatModeList then
      self.chatModeList:switchChannleMode("chatroom")
    end
    if self.chatRoomMgr then
      self.chatRoomMgr:selectRoomType("multi_stage_talk")
    end
  elseif self.identity == "cr_arena_battle_data_statistics" then
    if self.chatModeList then
      self.chatModeList:switchChannleMode("chatroom")
    end
    if self.chatRoomMgr then
      self.chatRoomMgr:selectRoomType("multi_arena")
    end
  elseif self.identity == "multiplayerStagedone" then
    if self.chatModeList then
      self.chatModeList:switchChannleMode("chatroom")
    end
    if self.chatRoomMgr then
      self.chatRoomMgr:selectRoomType("dreamland")
    end
  elseif ed.chatNetDataMrg.notifyPrivateCount > 0 then
    if self.chatModeList then
      self.chatModeList:switchChannleMode("private")
    end
  elseif 0 < ed.chatNetDataMrg.notifyGuildHeroTaskCount and self.chatModeList then
    self.chatModeList:switchChannleMode("guildhero")
  end
  if self.curChannel == "guild" and ed.player:getGuildId() == 0 and self.chatModeList then
    self.chatModeList:switchChannleMode("world")
  end
  ListenEvent("req_home_page", function(data)
    local panel = ed.ui.PlayerInfoPanel.create(data, false)
    panel:popWindow()
  end, HomePageScope)
  ListenEvent("personal_home_page", function(data)
    local panel = ed.ui.PlayerInfoPanel.create(data, true)
    panel:popWindow()
  end, HomePageScope)
  ListenEvent("userid_not_found", function(data)
    ed.showConfirmDialog({
      text = T("\229\165\189\229\143\139\229\183\178\231\187\143\232\189\172\230\156\141\239\188\140\230\152\175\229\144\166\229\136\160\233\153\164\229\165\189\229\143\139\239\188\159"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        function ed.netreply.delFriend()
          ed.ui.chatMain.getInstace():delFriend({
            roleId = data.roleId
          })
        end
        
        ed.chatNetDataMrg:sendDelFriend(data.roleId)
      end
    })
  end, HomePageScope)
  if not EDCreateCustomizePhoto then
    local enable = ed.player:getCustomPhotoSwitch()
    local count = ed.chatNewVersionUpdateNum or 0
    if enable and count < 2 then
      local param = {
        type = "Server",
        text = T("\233\152\159\233\149\191\229\164\167\229\164\167\239\188\140\232\175\183\229\137\141\229\190\128\229\186\148\231\148\168\229\149\134\229\186\151\228\184\139\232\189\189\230\156\128\230\150\176\231\137\136\230\156\172\229\143\175\228\187\165\228\189\191\231\148\168\232\135\170\229\174\154\228\185\137\229\164\180\229\131\143\239\188\129")
      }
      FireEvent("SysTemMsgEvent", param)
      ed.chatNewVersionUpdateNum = ed.chatNewVersionUpdateNum or 0
      ed.chatNewVersionUpdateNum = ed.chatNewVersionUpdateNum + 1
    end
  end
end

function chatMain:pushWindow()
  CloseScope(HomePageScope)
  if self.mainLayer:getParent() then
    self.mainLayer:removeFromParentAndCleanup(true)
    self:reset()
  end
  ed.chatNetDataMrg:closeReqChatMsg()
  ed.isOpenChat = false
end

function chatMain:ccScene()
  if not (ed.getCurrentScene() or {}).ccScene then
    return
  end
  return ed.getCurrentScene():ccScene()
end

function chatMain:closeTouch(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.ui.close_btn, x, y) and not ed.chatUtil:isHide(self.ui.close_btn) then
      self.isClosePress = true
      self.ui.close_btn_press:setVisible(true)
    end
  elseif event == "ended" then
    if self.isClosePress and ed.containsPoint(self.ui.close_btn, x, y) and not ed.chatUtil:isHide(self.ui.close_btn) then
      self:closeChatView()
    end
    self.isClosePress = false
    self.ui.close_btn_press:setVisible(false)
  end
end

function chatMain:closeChatView()
  if not self.mainLayer:getParent() then
    return
  end
  ed.playEffect(ed.sound.handbook.clickBack)
  local width = self.ui.chat_layer:getContentSize().width + 10
  local _, y = self.ui.chat_layer:getPosition()
  local action = CCSequence:create(ccArrayMake(CCMoveTo:create(0.2, ccp(-width, y)), CCCallFunc:create(function()
    self:pushWindow()
  end)))
  self.ui.chat_layer:runAction(action)
  FireEvent("close_chat_main_view")
end

function chatMain:openChatView()
  local width = self.ui.chat_layer:getContentSize().width + 10
  local _, y = self.ui.chat_layer:getPosition()
  self.ui.chat_layer:setPositionX(-width)
  local action = CCSequence:create(ccArrayMake(CCMoveTo:create(0.2, ccp(-2, y)), CCCallFunc:create(function()
    self.chatSendMsgLogic:creatrEditBox()
    return
  end)))
  self.ui.chat_layer:runAction(action)
end

function chatMain:changeCloseBtnPos()
  if self.curChatMode ~= self.chatMode.private and self.curChatMode ~= self.chatMode.guild and self.curChatMode ~= self.chatMode.chatroom and self.curChatMode ~= self.chatMode.chatServer then
    local x = self.ui.chat_bg:getPosition()
    local width = self.ui.chat_bg:getContentSize().width
    self.ui.close_btn:setPositionX(x + width - 8)
  else
    local x = self.ui.friend_bg:getPosition()
    local width = self.ui.friend_bg:getContentSize().width
    self.ui.close_btn:setPositionX(x + width - 8.5)
  end
end

function chatMain:getCurChannel()
  return self.curChannel
end

function chatMain:switchChannel(mode)
  ed.chatNetDataMrg:closeReqChatMsg()
  self.worldChatContext:setHide(true)
  self.guildChatContext:setHide(true)
  self.chatFriendMgr:setHide(true)
  self.chatGuildMemberMgr:setHide(true)
  self.chatPrivateContextMrg:setHide(true)
  self.chatRoomMgr:setHide(true)
  self.chatServerMgr:setHide(true)
  self.chatServerContextMrg:setHide(true)
  self.chatRoomContextMrg:setHide(true)
  self.ui.task_layer:setVisible(false)
  ed.ui.chatSuspension.getInstance():setEnabled(false)
  if ed.ui.chatask then
    ed.ui.chatask:Clear()
  end
  self.curChannel = mode
  self.curChatMode = self.chatMode[self.curChannel]
  if mode == "world" then
    self.chatSendMsgLogic:Hide(true)
    self.chatSendMsgLogic:changeSendData(self.chatMode.world)
    ed.chatNetDataMrg:setChannel(self.chatMode.world)
    self.worldChatContext:setHide(false)
  elseif mode == "guild" then
    self.chatSendMsgLogic:Hide(true)
    self.chatSendMsgLogic:changeSendData(self.chatMode.guild)
    ed.chatNetDataMrg:setChannel(self.chatMode.guild)
    self.guildChatContext:setHide(false)
    self.chatGuildMemberMgr:setHide(false)
  elseif mode == "private" then
    self.chatSendMsgLogic:changeSendData(self.chatMode.private)
    self.chatFriendMgr:setHide(false)
    ed.chatNetDataMrg:setChannel(self.chatMode.private)
    self.chatPrivateContextMrg:setHide(false)
    self:selectParivteObj()
  elseif mode == "guildhero" then
    ed.chatNetDataMrg:setChannel(self.chatMode.guildhero)
    self.chatSendMsgLogic:Hide(false)
    self.ui.task_layer:setVisible(true)
  elseif mode == "chatroom" then
    self.chatSendMsgLogic:changeSendData(self.chatMode.chatroom)
    ed.chatNetDataMrg:setChannel(self.chatMode.chatroom)
    self.chatRoomMgr:setHide(false)
    self.chatRoomContextMrg:setHide(false)
    self:selectchatRoomObj()
  elseif mode == "chatServer" then
    self.chatSendMsgLogic:changeSendData(self.chatMode.chatServer)
    self.chatServerMgr:setHide(false)
    self.chatServerContextMrg:setHide(false)
    self:selectServerChannelObj()
  elseif mode == "mentor" then
    self.chatSendMsgLogic:Hide(false)
  end
  if ed.isOpenChat and mode ~= "chatServer" then
    ed.chatNetDataMrg:startReqChatMsg()
  end
  self:changeCloseBtnPos()
end

function chatMain:selectParivteObj()
  if ed.curPrivateTarget then
    self.chatSendMsgLogic:Hide(true)
    self.chatSendMsgLogic:setTargetSummary(ed.curPrivateTarget)
  else
    self.chatSendMsgLogic:Hide(false)
  end
  self.chatPrivateContextMrg:setCurSelectTarget()
end

function chatMain:selectServerChannelObj()
  if self.curChannel == "chatServer" then
    if ed.curChatServerTarget then
      self.chatSendMsgLogic:Hide(true)
      self.chatSendMsgLogic:setServerTarget(ed.curChatServerTarget)
    else
      self.chatSendMsgLogic:Hide(false)
      ed.chatNetDataMrg:sendOpenAllServerChat()
    end
    self.chatServerContextMrg:setCurSelectTarget()
  end
end

function chatMain:selectchatRoomObj()
  if self.curChannel == "chatroom" then
    if ed.curChatRoomTarget and ed.curChatRoomTarget.state == "open" then
      self.chatSendMsgLogic:Hide(true)
      self.chatSendMsgLogic:setRoomTarget(ed.curChatRoomTarget)
    else
      self.chatSendMsgLogic:Hide(false)
    end
    self.chatRoomContextMrg:switchChatRoom(ed.curChatRoomTarget)
  end
end

function chatMain:noticeToPrivate()
  local function handler(data)
    if self.chatFriendMgr then
      self.chatFriendMgr:addContact(data)
    end
    if self.chatModeList then
      self.chatModeList:refreshRedTip()
    end
  end
  
  return handler
end

function chatMain:onticeToChatRoom()
  local function handler()
    self.chatRoomMgr:refreshRedTip()
    
    self.chatModeList:refreshRedTip()
  end
  
  return handler
end

function chatMain:noticeNewMsg()
  local function handler(data)
    if self.chatModeList then
      self.chatModeList:refreshRedTip()
      
      self.chatFriendMgr:refreshContactState()
    end
  end
  
  return handler
end

function chatMain:selectChatRoom()
  local function handler(data)
  end
  
  return handler
end

function chatMain:delContactHandler()
  local function handler(data)
    self.chatFriendMgr:delContact(data)
    
    self.chatPrivateContextMrg:delContact(data)
    if not ed.curPrivateTarget and self.chatSendMsgLogic.currentChannel == "personal_channel" then
      self.chatSendMsgLogic:Hide(false)
    end
    ed.showToast(T("<sprite src=UI/alpha/HVGA/playerinfo_res_select.png scale=0.5>\229\136\160\233\153\164\230\136\144\229\138\159"), nil, {isAutoText = true})
  end
  
  return handler
end

function chatMain:updateContactHandler()
  local function handler(data)
    self.chatFriendMgr:delContact(data)
    
    self.chatPrivateContextMrg:delContact(data)
    if not ed.curPrivateTarget and self.chatSendMsgLogic.currentChannel == "personal_channel" then
      self.chatSendMsgLogic:Hide(false)
    end
  end
  
  return handler
end

function chatMain:systemNewMsg()
  local function handler(data)
    if data then
      local type = data.type
      
      local text = data.text
      if type == "Server" then
        if self.worldChatContext then
          self.worldChatContext:addSystemMsgItem(text)
        end
      elseif type == "Guild" and self.guildChatContext then
        self.guildChatContext:addSystemMsgItem(text)
      end
    end
  end
  
  return handler
end

function chatMain:selectObjPrivateChat()
  local function handler(data)
    local tb = {}
    
    tb.roleId = data.roleId
    tb.summary = data.summary
    tb.recent_online_time = data.recent_online_time
    tb.server_name = data.server_name
    tb.svrId = data.svrId
    tb.isOnline = data.isOnline or 1
    if self.chatModeList then
      self.chatModeList:switchChannleMode("private")
    end
    if self.chatFriendMgr then
      self.chatFriendMgr:addContact(tb)
      self.chatFriendMgr:chooseObjFromContact(tb.roleId)
      if data.friendFlag ~= 1 then
        self.chatFriendMgr:switchChannleMode("recent")
      end
    end
  end
  
  return handler
end

function chatMain:reqContactDataHandler()
  local function handler()
    if self.chatFriendMgr then
      self.chatFriendMgr:refreshFriendData()
    end
    if self.chatGuildMemberMgr then
      self.chatGuildMemberMgr:refreshGuildData()
    end
    self.chatRoomMgr:refreshRoomData()
    self.chatRoomContextMrg:updateData()
  end
  
  return handler
end

function chatMain:reset()
  self.chatSendMsgLogic:removeEditBox()
end

function chatMain:OnPrivateTab(obj)
  if obj.roleId == ed.getRoleId() then
    return
  end
  self:popWindow()
  FireEvent("chat_private_target", obj)
end

function chatMain.sendAddFriendLink(roleId, btn)
  if not roleId or roleId == "" then
    return
  end
  if ed.friendlist.isInFriendlist(roleId) then
    ed.showToast(T("\229\175\185\230\150\185\229\183\178\231\187\143\230\152\175\228\189\160\231\154\132\229\165\189\229\143\139"))
    return
  end
  local ds = ed.playerlimit.getAreaUnlockPrompt("Private Message")
  if ds then
    ed.showToast(ds)
    return
  end
  local btn = btn
  
  function ed.netreply.chatSay()
    if btn and btn.setVisible and (type(btn) == "table" or not tolua.isnull(btn)) then
      btn:setVisible(false)
    end
    ed.showToast(T("\229\143\145\233\128\129\230\136\144\229\138\159"))
  end
  
  ed.chatNetDataMrg:sendApplyFriend(roleId)
end

ed.ui.chat.sendAddFriendLink = ed.ui.chatMain.sendAddFriendLink

function chatMain:delFriend(parma)
  self.chatFriendMgr:delFriend(parma)
end

function chatMain:exitRoomMember(data)
  self.chatRoomContextMrg:tipExitRoomMemberInfo(data)
  self.chatRoomMgr:exitRoomMember(data)
end

function chatMain:addFriendMsg()
  local function handler(data)
    if data then
      self.chatFriendMgr:addNewFriend(data)
    end
  end
  
  return handler
end

function chatMain:serverOpenPanelHandler(data)
  local chat_channel = data.chat_channel
  local can_chat = data.can_chat
  ed.can_server_chat = can_chat
  self.chatServerMgr:setChatChannels(chat_channel)
  local channel_id = ed.storage.getString("current_server_chat_channel")
  print("channel_id----->>>>>", channel_id)
  if channel_id then
    ListenTimer(Timer:Once(0.5), function()
      self.chatServerMgr:selectChannel(tonumber(channel_id))
    end)
  end
end
