local chatManager = {}
chatManager.__index = chatManager
chatManager.ChatEvent = {
  privateChat_l = "privateChat_l",
  NoticeToPrivate = "NoticeToPrivate"
}
chatManager.ChatText = {
  [1] = T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"),
  [2] = T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"),
  [3] = T("\228\187\138\230\151\165\228\184\150\231\149\140\232\129\138\229\164\169\229\133\141\232\180\185\230\172\161\230\149\176\229\137\169\228\189\1535\230\172\161"),
  [4] = T("\230\178\161\230\156\137\232\190\147\229\133\165\228\187\187\228\189\149\230\182\136\230\129\175"),
  [5] = T("\230\136\152\233\152\159\231\173\137\231\186\167\229\136\176\232\190\190%i\231\186\167\229\141\179\229\143\175\229\143\145\232\168\128"),
  [6] = T("\229\143\145\232\168\128\233\162\145\231\142\135\232\191\135\233\171\152\239\188\140\232\175\183\231\168\141\229\144\142\229\134\141\232\175\149"),
  [7] = T(""),
  [8] = T("\230\151\160\230\179\149\229\144\145\233\187\145\229\144\141\229\141\149\228\184\173\231\154\132\228\186\186\229\143\145\233\128\129\230\182\136\230\129\175"),
  [9] = T("\232\175\183\229\133\136\233\128\137\230\139\169\232\129\148\231\179\187\228\186\186"),
  [10] = T("\228\187\138\230\151\165\228\184\150\231\149\140\232\129\138\229\164\169\229\133\141\232\180\185\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140,\230\175\143\230\157\161\230\182\136\230\129\175\229\176\134\232\138\177\232\180\185%d\233\146\187\231\159\179\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
  [11] = T("\229\143\150\230\182\136"),
  [12] = T("\231\161\174\229\174\154")
}
chatManager.ChatWinEnum = {
  chatEntrance = "chatEntrance",
  chatMainWin = "chatMainWin",
  chatEmoji = "chatEmoji",
  chatSet = "chatSet"
}
chatManager.ChannelEnum = {
  world_channel = "world_channel",
  guild_channel = "guild_channel",
  personal_channel = "personal_channel"
}
chatManager.ChannelBtnEnum = {
  world_channel = {
    text = T("\230\156\172\230\156\141\232\129\138\229\164\169")
  },
  guild_channel = {
    text = T("\229\133\172\228\188\154\232\129\138\229\164\169")
  },
  personal_channel = {
    text = T("\231\167\129\232\129\138")
  }
}
chatManager.EmojiTab = {
  emoji = "emoji",
  hero = "hero",
  sticker = "sticker"
}
chatManager.WorldChannelSpeakCD = 10
chatManager.OnChatHistoryFresh = false
chatManager.CanSendChatHistoryFresh = {}

function chatManager.getInstance()
  if not chatManager.instance then
    chatManager.instance = chatManager.create()
  end
  return chatManager.instance
end

function chatManager.create()
  local self = {}
  setmetatable(self, chatManager)
  self:init()
  return self
end

function chatManager:init()
  self.eventScope = {}
  self:initData()
  self:addListenEvent()
end

function chatManager:initData()
  self.currentChannel = "world_channel"
  self.chatPopWin = {chatEntrance = nil, chatMainWin = nil}
  ed.defineProperty(self, "operateChatWin", nil)
  ed.defineProperty(self, "needSendMsg", {
    _content_type = 1,
    _channel = self.currentChannel,
    _content = "",
    _target = {_target_role_id = nil},
    _group_type = nil,
    _chat_group_id = nil,
    _accessory = nil
  }, nil, function(self, params)
    self.needSendMsg = {
      _content_type = params.type,
      _channel = params.channel or self.currentChannel,
      _content = params.content,
      _accessory = params.accessory
    }
    if (not params.channel or params.channel == self.ChannelEnum.personal_channel) and self.currentChannel == self.ChannelEnum.personal_channel then
      self.needSendMsg._target = {
        _role_id = self:getCurPrivateTarget().data.roleId
      }
    end
  end)
  ed.defineProperty(self, "curPrivateTarget", {
    key = nil,
    data = {}
  }, function(self)
    local key = self.curPrivateTarget.key
    local contactdata = ed.chatNetWork.contactData
    if not key or not contactdata[key] then
      self.curPrivateTarget = {
        key = nil,
        data = {}
      }
    end
    return self.curPrivateTarget
  end, function(self, target)
    self.curPrivateTarget = target
    FireEvent("SetCurPrivateTarget")
  end)
  ed.defineProperty(self, "targetUid", nil)
  ed.defineProperty(self, "targetSid", nil)
  ed.defineProperty(self, "targetRoleId", nil)
  self.canOtherChat = true
  self.canFrientInvite = true
end

local handlers = {
  chat_contact = function(self, msg)
    ed.player:setChatFreeTime(msg._chat_contact._world_chat_times)
    if ed.ui.friendMainWin.getSubPanelShow(ed.ui.friendMainWin.SUB_PANEL_ENUM.SUB_PANEL_REQUEST) and ed.ui.requestFriendPanel.isRequestFriend then
      ed.ui.requestFriendPanel.isRequestFriend = false
      return
    end
    if ed.chatManager.chatPopWin.chatMainWin == nil and (ed.chatManager.chatPopWin.chatEntrance or ed.getCurrentScene().identity == "GuildMainScene") then
      ed.ui.chatMainWin.create():popWindow()
    end
  end,
  chat_fresh = function(self, msg)
    local data = msg._fresh
    if not data then
      return
    end
    if self:getCanSendChatHistoryFresh() and self.OnChatHistoryFresh then
      if nil == data._contents then
        self.CanSendChatHistoryFresh[self.currentChannel] = false
      end
      local new_chat = ed.chatNetWork:addHistoryMessage(msg._fresh._channel, msg._fresh._contents)
      self.OnChatHistoryFresh = false
      FireEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MSG_LIST_HISTORY_REFRESH, new_chat)
      ed.chatNetWork:startChatFresh()
    else
      local new_chat = ed.chatNetWork:addMessage(msg._fresh._channel, msg._fresh._contents)
      if new_chat then
        FireEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MSG_LIST_REFRESH)
      end
    end
  end
}

function chatManager:getHandle(msgName)
  return handlers[msgName]
end

function chatManager:handleMsg(msg, msgName)
  local handle = self:getHandle(msgName)
  if not handle then
    warn(msgName .. "`s handler not defined!")
    return
  end
  handle(self, msg)
end

function chatManager:openChatMainWin(channel)
  if not ed.playerlimit:moduleIsOpened("Friend") then
    ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\188\128\230\148\190"))
    return
  end
  self.currentChannel = channel or self.ChannelEnum.world_channel
  ed.chatNetWork:sendChat("chat_contact", "_chat_contact", {
    _version = ed.chatNetWork.chatContactVersion,
    _group_version = ed.chatNetWork.chatroomVersion
  })
end

function chatManager:getRecentOnlineTime(time)
  local des = ""
  local serverTime = ed.getServerTime()
  local y, m, d, h, min, sec = ed.time2YMDHMS(time)
  local nowY, nowM, nowD = ed.time2YMDHMS(serverTime)
  local passSecond = serverTime - time
  if d == nowD and passSecond < 86400 and h and min or time == 0 then
    des = T("\228\187\138\230\151\165\229\134\133")
  else
    local days = math.ceil(passSecond / 86400)
    des = T("%d\229\164\169\229\137\141", days)
  end
  return des
end

function chatManager:getChatTimeDes(data)
  local time = ed.time2China(data)
  local curTime = ed.time2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  local y_cur, mon_cur, d_cur = ed.time2YMD(curTime)
  if y ~= y_cur or mon ~= mon_cur or d ~= d_cur then
    return T("%d\230\156\136%d\230\151\165 %02d:%02d", mon, d, h, m) .. ed.getUTCLabel()
  else
    return T("%02d:%02d" .. ed.getUTCLabel(), h, m)
  end
end

function chatManager:canSendChatMsg()
  if ed.player:getName() == "" then
    local bename = ed.ui.renameWindow.create()
    bename:popWindow()
    return false
  end
  local needSendMsg = self:getNeedSendMsg()
  local content = needSendMsg._content
  if content == "" or string.match(content, "^<text|chat_content|%s*>$") then
    ed.showToast(self.ChatText[4])
    return false
  end
  local levelLimit = ed.playerlimit.getAreaUnlockLevel("WorldChannel")
  if self.currentChannel == self.ChannelEnum.world_channel or self.currentChannel == self.ChannelEnum.personal_channel then
    ed.pt(ed.player:getLevel() .. " ? " .. levelLimit)
    if levelLimit > ed.player:getLevel() then
      ed.showToast(T(self.ChatText[5], levelLimit))
      return false
    end
  end
  if self.currentChannel == self.ChannelEnum.world_channel then
    local now = ed.getServerTime()
    if ed.chatNetWork.lastWorldChatTime ~= nil and now - ed.chatNetWork.lastWorldChatTime < self.WorldChannelSpeakCD then
      ed.showToast(self.ChatText[6])
      return false, "ChatText6"
    end
  elseif self.currentChannel == self.ChannelEnum.personal_channel then
    local ds = ed.playerlimit.getAreaUnlockPrompt("Private Message")
    if ds then
      ed.showToast(ds)
      return false
    end
    if self:getCurPrivateTarget().data.summary == nil or self:getCurPrivateTarget().data.roleId == nil then
      ed.showToast(self.ChatText[9])
      return false
    end
    if needSendMsg and needSendMsg._target and needSendMsg._target._role_id and ed.blacklist.isInBlacklist(needSendMsg._target._role_id) then
      ed.showToast(self.ChatText[8])
      return false
    end
  elseif self.currentChannel == self.ChannelEnum.guild_channel and ed.player:getGuildId() == 0 then
    ed.showToast(self.ChatText[2])
    return false
  end
  return true
end

function chatManager:sendChatMsg(isClearCache)
  if nil == isClearCache then
    isClearCache = true
  end
  self.clearCacheFlag = isClearCache
  local result, error = self:canSendChatMsg()
  if result then
    self:sendchat()
  end
  return result, error
end

function chatManager:getCanSendChatHistoryFresh()
  if nil == self.CanSendChatHistoryFresh[self.currentChannel] then
    self.CanSendChatHistoryFresh[self.currentChannel] = true
  end
  return self.CanSendChatHistoryFresh[self.currentChannel]
end

function chatManager:sendchat()
  LvDun.msgCheck(self:getNeedSendMsg()._content, function(result)
    if result then
      ed.chatNetWork:sendChat("chat_say", "_say", self:getNeedSendMsg())
    else
      ed.showToast(self.ChatText[1])
    end
  end)
end

function chatManager:chatContent2chatStr(content)
  if string.find(content, "<link|wakuang|") then
    local str2 = string.match(content, "<link|wakuang|(%d+),>")
    str2 = ed.getDataTable("ExcavateTreasure")[tonumber(str2)]["Display Name"]
    return T("\233\130\128\232\175\183\233\152\178\229\174\136\239\188\154\227\128\144%s\227\128\145", str2)
  elseif string.find(content, "<link|ancients|") then
    local count = string.match(content, "<link|ancients|(%d+)>")
    return T("\233\130\128\232\175\183\230\142\162\231\180\162\239\188\154\227\128\144\231\165\158\231\167\152\233\129\151\232\191\185\227\128\145(\229\143\139\230\131\133\231\130\185\239\188\154%d)", count)
  elseif string.find(content, "<link|real_arena_challenge|") then
    local pvp_rule = string.match(content, "<link|real_arena_challenge|([^>]+)>")
    local text = string.match(content, "<text|dark_white|([^|]+)|400>") or ""
    return T("\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154\227\128\144%s\230\168\161\229\188\143\227\128\145 %s", ed.realarena.pvp_rule_string[pvp_rule], text)
  elseif string.find(content, "<link|ladder_fight|>") then
    return "\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154\227\128\144\231\171\158\230\138\128\229\156\186\227\128\145"
  elseif string.find(content, "<link|multiplayer|") then
    local str2 = string.match(content, "<link|multiplayer|([^>]+)>")
    local str1 = string.match(content, "<text|dark_white|([^>]+)>")
    return T("%s\227\128\144%s\227\128\145", str1, str2)
  elseif string.find(content, "<link|pvp|") then
    local str2 = string.match(content, "<link|pvp|([^>]+)>")
    return T("\227\128\144%s\227\128\145", str2)
  elseif string.find(content, "<link|real_arena") then
    local str2 = string.match(content, "<link|real_arena|([^>]+)>")
    return T("%s", str2)
  elseif string.find(content, "<link|herolink") then
    local str2 = string.match(content, "<link|herolink|([^>]+)|%d+>")
    str2 = ed.FormatHeroLinkName(str2)
    return str2
  else
    local str2 = ""
    for str1 in string.gmatch(content, "<.->") do
      local temp = string.sub(str1, 2, string.len(str1) - 1)
      local str_arr = Split(temp, "|")
      if str_arr[1] == "text" then
        str2 = str2 .. T("<lable color=chatEntranceMsgContent>%s</lable>", str_arr[3])
      elseif str_arr[1] == "emoji" then
        local emojiId = tonumber(str_arr[2])
        local row = ed.getDataTable("ChatEmoji")[emojiId]
        if row then
          local res = row["Emoji Cha"]
          str2 = str2 .. string.format("<sprite src=%s name=\"emoji\" scale=0.32 >", res)
        end
      end
    end
    return str2
  end
end

function chatManager:getChatEntranceAutoText(content)
  local str = self:chatContent2chatStr(content)
  if string.find(content, "<link|pvp|") then
    return T("<lable color=chatEntranceMsgGreen>%s</lable>", str)
  elseif string.find(content, "<link|herolink") then
    return T("<lable color=chatEntranceMsgContent>\229\136\134\228\186\171\228\186\134</lable><lable color=chatEntranceMsgGreen>\227\128\144%s\227\128\145</lable>", str)
  else
    return str
  end
end

function chatManager:chatSpellNotify(msgList, index)
  if index > #msgList then
    return
  end
  local data = msgList[index]
  if ed.chatManager.chatPopWin.chatMainWin then
    ed.chatManager.chatPopWin.chatMainWin:chatSpellNotify(data, 0.1)
  end
  local eff_Fireworks_list = {}
  local container = ed.getCurrentScene():getTopNode()
  
  local function addFirework(scale, pos, color4f, bShader, h, s, v)
    local eff_Fireworks = ed.createFcaActor("eff_UI_Fireworks")
    eff_Fireworks:setAction("Start")
    ed.getCurrentScene():addFca(eff_Fireworks)
    eff_Fireworks:setScale(scale)
    eff_Fireworks:setLoop(false)
    eff_Fireworks:setPosition(pos)
    eff_Fireworks:update(0)
    container:addChild(eff_Fireworks)
    local particle = CCParticleSystemQuad:create("UI/particle/yanhua3.plist")
    eff_Fireworks:addNodeToComponent(particle, "lizi", 10, CCAffineTransformMake(1, 0, 0, 1, 0, 0 * scale), false, true)
    particle:setStartColor(color4f)
    particle:setEndColor(color4f)
    local particle1 = CCParticleSystemQuad:create("UI/particle/yanhua4.plist")
    particle1:setStartColor(color4f)
    particle1:setEndColor(color4f)
    eff_Fireworks:addNodeToComponent(particle1, "yanhua", 10, CCAffineTransformMake(1, 0, 0, 1, 0, 385 * scale), false, true)
    if bShader then
      ed.useShader(eff_Fireworks, "HSVtoRGBShader")
      local shader = CCShaderCache:sharedShaderCache():programForKey("HSVtoRGBShader")
      local location = shader:getUniformLocationForName("HSV")
      shader:setUniformsForBuiltins()
      shader:setUniformLocationWith4f(location, h, s, v, 1)
    end
    table.insert(eff_Fireworks_list, eff_Fireworks)
  end
  
  ListenTimer(Timer:Once(0.6), function()
    addFirework(1, ccp(ed.display.winSize.width / 2, 0), ccc4f(0.5, 1, 1, 1), false, 0, 0, 0)
  end)
  ListenTimer(Timer:Once(0.7), function()
    addFirework(0.55, ccp(ed.display.winSize.width * 1 / 3, ed.display.winSize.height * 2 / 10), ccc4f(0.5, 1, 1, 1), false, 20, 0, 0)
  end)
  ListenTimer(Timer:Once(0.75), function()
    addFirework(0.65, ccp(ed.display.winSize.width * 2 / 3, ed.display.winSize.height * 1.5 / 10), ccc4f(0.5, 1, 1, 1), false, 20, 0, 0)
  end)
  ListenTimer(Timer:Once(3), function()
    for i, v in ipairs(eff_Fireworks_list) do
      v:removeFromParentAndCleanup(true)
    end
    local allrewards = {}
    for i, v in ipairs(data.rewards) do
      table.insert(allrewards, {
        id = v._id,
        type = v._type,
        amount = v._amount
      })
    end
    local geftItem, exceedItem, giveItemAll = ed.itemExceeds(allrewards)
    if data.rewards and #data.rewards > 0 then
      ed.player:addRewards(data.rewards)
    end
    local chatSpellTable = ed.getDataTable("ChatSpell")[data.spell_id]
    local uiClassName = chatSpellTable and chatSpellTable["UI File"]
    ed.ui.maillocalbox.create({
      type = "chatAddItem",
      item = giveItemAll,
      uiClassName = uiClassName,
      destroyBack = function()
        self:chatSpellNotify(msgList, index + 1)
      end
    }):popWindow()
  end)
end

function chatManager:getStickerInfoList()
  local allStickers = {}
  local tableData = ed.getDataTable("Sticker")
  for _, row in ipairs(tableData) do
    local isInsert = false
    local requirement = row["Requirement Type"]
    if requirement == "HaveItem" then
      if ed.player:getEquipAmount(row["Requirement ID"]) >= row["Requirement Target"] then
        isInsert = true
      end
    else
      isInsert = true
    end
    if isInsert then
      table.insert(allStickers, {
        id = row["Sticker ID"],
        res = row.Picture
      })
    end
  end
  return allStickers
end

function chatManager:addListenEvent()
  ListenEvent("chat_private_target", function(data)
    local tb = {
      roleId = data.roleId,
      summary = data.summary,
      recent_online_time = data.recent_online_time,
      svrId = data.svrId,
      server_name = data.server_name,
      isOnline = data.isOnline or 1
    }
    local key = ed.chatUtil:getUserKey(tb.roleId)
    local contactData = ed.chatNetWork.contactData
    if not contactData[key] then
      contactData[key] = {data = tb, notify = 0}
    end
    self:setCurPrivateTarget({key = key, data = tb})
  end, self.eventScope)
  ListenEvent("NOTICE_CHAT_SPELL", function(msgList)
    self:chatSpellNotify(msgList, 1)
  end, self.eventScope)
end

ed.chatManager = chatManager.getInstance()
