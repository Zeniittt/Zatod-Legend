local chatSendMsgLogic = {}
ed.ui.chatSendMsgLogic = chatSendMsgLogic
chatSendMsgLogic.__index = chatSendMsgLogic
chatSendMsgLogicSpace = {}
ed.chatServerTimes = 0
local resource_config = resource_config
local bFirtPay = true

function chatSendMsgLogic.create(params)
  local self = {}
  setmetatable(self, chatSendMsgLogic)
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.params = params
  self:init()
  return self
end

function chatSendMsgLogic:init()
  self:creatrEditBox()
end

function chatSendMsgLogic:removeEditBox()
  self.ui.input_bg:removeChild(self.edit_box.edit, true)
  self.edit_box = nil
end

function chatSendMsgLogic:creatrEditBox()
  if self.edit_box then
    self:removeEditBox()
  end
  local info = {
    config = {
      editSize = self.ui.input_bg:getContentSize(),
      maxLength = resource_config.chat_text_len or 55,
      fontColor = ccc3(0, 0, 0),
      fontSize = 20,
      position = ccp(10, 0)
    }
  }
  local edit_box = editBox:new(info)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.ui.input_bg:addChild(edit_box.edit)
  self.edit_box = edit_box
end

function chatSendMsgLogic:getEditBox()
  return self.edit_box
end

function chatSendMsgLogic:restEditBox()
  if self.edit_box then
    self.edit_box:setString(" ")
  end
end

function chatSendMsgLogic:touch(event, x, y)
  if ed.chatUtil:isHide(self.ui.send_layer) then
    return
  end
  xpcall(function()
    if self.edit_box then
      self.edit_box:touch(event, x, y)
    end
    self:sendTouch(event, x, y)
    self:emojiTouch(event, x, y)
  end, EDDebug)
end

function chatSendMsgLogic:Hide(bool)
  self.ui.send_layer:setVisible(bool)
  if bool then
    self:restEditBox()
  end
end

function chatSendMsgLogic:emojiTouch(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.ui.btn_emoji, x, y) then
      self.ui.btn_emoji_press:setVisible(true)
    end
  elseif event == "ended" then
    self.ui.btn_emoji_press:setVisible(false)
    if ed.containsPoint(self.ui.btn_emoji, x, y) then
      FireEvent("open_emoji_view")
    end
  end
end

function chatSendMsgLogic:sendTouch(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.ui.btn_send, x, y) then
      self.isSettingPress = true
      self.ui.btn_send_press:setVisible(true)
    end
  elseif event == "ended" then
    if self.isSettingPress and ed.containsPoint(self.ui.btn_send, x, y) then
      self:onClickSendHandler()
      self.isSettingPress = false
    end
    self.parentLogic.ui.btn_send_press:setVisible(false)
  end
end

function chatSendMsgLogic:changeSendData(channel)
  self.currentChannel = channel
end

function chatSendMsgLogic:setTargetSummary(data)
  self.targetData = data
  if self.targetData then
    self.targetUid = self.targetData.uid
    self.targetRoleId = self.targetData.roleId
    self.targetSummary = self.targetData.summary
  else
    self.targetUid = nil
    self.targetSummary = nil
    self.targetRoleId = nil
  end
end

function chatSendMsgLogic:setRoomTarget(data)
  self.curChatRoomTarget = data
end

function chatSendMsgLogic:setServerTarget(data)
  self.curServerChatChannelID = data.id
end

function chatSendMsgLogic:getTargetSummary()
  return self.targetData
end

function chatSendMsgLogic:CanSend(isEmoji, callback)
  if self.currentChannel == "personal_channel" and ed.blacklist.isInBlacklist(self.targetRoleId) then
    ed.showToast(T("\230\151\160\230\179\149\229\144\145\233\187\145\229\144\141\229\141\149\228\184\173\231\154\132\228\186\186\229\143\145\233\128\129\230\182\136\230\129\175"))
    return
  end
  local bCanSend = self:checkChatCondition(isEmoji)
  if not bCanSend then
    return
  end
  return true
end

function chatSendMsgLogic:onClickSendHandler()
  if self:CanSend() then
    if self.currentChannel == "chatServer_channel" then
      self:sendServerChannelMsg()
      return
    end
    self:sendCurrentContent()
  end
end

function chatSendMsgLogic:checkChatCondition(isEmoji)
  local content = self:getCurrentContent()
  if not isEmoji then
    if content == "" or string.match(content, "^<text|chat_content|%s*>$") then
      ed.showToast(T("\230\178\161\230\156\137\232\190\147\229\133\165\228\187\187\228\189\149\230\182\136\230\129\175"))
      return false
    end
    if ed.dirtyword_check(content) then
      ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
      return false
    end
  end
  local levelLimit = ed.playerlimit.getAreaUnlockLevel("WorldChannel")
  if self.currentChannel == "world_channel" or self.currentChannel == "personal_channel" then
    if levelLimit > ed.player:getLevel() then
      ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\229\136\176\232\190\190%i\231\186\167\229\141\179\229\143\175\229\143\145\232\168\128", levelLimit))
      return false
    end
    local now = ed.getServerTime()
    if self.currentChannel == "world_channel" and ed.chatNetDataMrg.lastWorldChatTime ~= nil and now - ed.chatNetDataMrg.lastWorldChatTime < 1 then
      ed.showToast(T("\232\175\180\232\175\157\233\162\145\231\142\135\229\164\170\229\191\171"))
      return false
    end
  elseif self.currentChannel == "guild_channel" and ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return false
  end
  if ed.player:getName() == "" then
    local bename = ed.ui.renameWindow.create()
    bename:popWindow()
    return false
  end
  return self:checkPrivateCondition()
end

function chatSendMsgLogic:getCurrentContent()
  local str = self.edit_box:getString()
  if str == " " then
    str = ""
  end
  return str
end

function chatSendMsgLogic:checkPrivateCondition()
  if self.currentChannel == "personal_channel" and (self.targetSummary == nil or self.targetUid == nil) then
    ed.showToast(T("\230\178\161\230\156\137\233\128\137\228\184\173\228\184\128\228\184\170\229\143\175\228\187\165\231\167\129\232\129\138\231\154\132\229\175\185\232\177\161"))
    return false
  end
  return true
end

function chatSendMsgLogic:sendServerChannelMsg()
  if not ed.can_server_chat then
    ed.showToast("\229\189\147\229\137\141\228\184\141\229\133\183\230\156\137\229\133\168\230\156\141\232\129\138\229\164\169\230\157\131\233\153\144")
    return
  end
  if ed.getServerTime() - ed.chatServerTimes < ed.ui.chatMain.chatServerTime then
    ed.showToast("\232\129\138\229\164\169\233\162\145\231\142\135\229\164\170\229\191\171 \232\175\183\228\188\145\230\129\175\228\184\128\228\184\139")
    return
  end
  local content = self:getCurrentContent()
  LvDun.msgCheck(content, function(result)
    if result then
      ed.chatNetDataMrg:sendServerChatMsg({content = content})
    else
      ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
    end
  end)
  self:restEditBox()
end

function chatSendMsgLogic:sendCurrentContent()
  local content = self:getCurrentContent()
  ed.edit_clocked = true
  if has_hero_link then
    if not link_param.allow then
      ed.showToast("\228\184\128\230\172\161\229\143\170\232\131\189\229\143\1455\228\184\170\232\139\177\233\155\132")
      return
    end
    local accessory = {
      _type = "heroes_link",
      _chat_hero_link = {
        _role_id = link_param.roleId,
        _heroesid = link_param.heroesid
      }
    }
    self:sendMessage(r_content, 2, accessory)
  else
    LvDun.msgCheck(content, function(result)
      if result then
        self:sendMessage(content, 1)
      else
        ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
      end
    end)
  end
  self:restEditBox()
  FireEvent("destroy_emoji_view")
end

function chatSendMsgLogic:sendMessage(content, chatType, accessory, channel, targets)
  local msg = ed.upmsg.chat()
  if targets then
    msg._chat_broad_say = {}
    msg._chat_broad_say._content_type = chatType
    msg._chat_broad_say._targets = targets
    msg._chat_broad_say._channel = channel
    msg._chat_broad_say._content = content
    if accessory then
      msg._chat_broad_say._accessory = accessory
    end
  else
    msg._say = {}
    msg._say._content_type = chatType
    msg._say._channel = channel or self.currentChannel
    msg._say._content = content
    if msg._say._channel == "personal_channel" then
      local ds = ed.playerlimit.getAreaUnlockPrompt("Private Message")
      if ds then
        ed.showToast(ds)
        return
      end
      msg._say._target = {}
      msg._say._target._target_role_id = self.targetRoleId
    end
    if msg._say._channel == "chatroom_channel" then
      msg._say._group_type = self.curChatRoomTarget.type
      msg._say._chat_group_id = self.curChatRoomTarget.id
    end
    if accessory then
      msg._say._accessory = accessory
    end
  end
  ed.send(msg, "chat")
end
