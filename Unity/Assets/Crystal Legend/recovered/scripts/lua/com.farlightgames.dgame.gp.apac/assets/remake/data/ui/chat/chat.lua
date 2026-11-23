local class = {}
ed.ui.chat = class
local chatPanel
local maxShowLength = 400
local defaultLinePos = -32
local defaultLinePos2 = -28
local defaultLinePos3 = -15
local editBoxDistance = 200
local chatYPosition = 239
local excivateData = {}
local oneTwoOne = true
local listviewBegainY = 0
local layerScriptFuncid
local tipsHideScope = {
  worldChannel = {},
  unitChannel = {},
  privateChannel = {},
  excavateChannel = {}
}
local currentAccessory
local currentChannel = "world_channel"
local chatNotifyType = "world_channel"
local chatMessages = {
  world_channel = {},
  guild_channel = {},
  personal_channel = {},
  excavate_channel = {}
}
local chatTune = false
local defaultInternal = 3
local maxInternal = 15
local refreshInternal = defaultInternal
local refreshChatEvent
local moveDistance = 552
local chatScope = {}
local dragPressX, oriChatPos
local chatMinX = -558
local chatMaxX = -10
local lastWorldChatTime, moveState, targetSummary, targetUid, targetRoleId

local function getChatTimeDes(data)
  local time = ed.time2China(data)
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format("%02d:%02d" .. ed.getUTCLabel(), h, m)
end

local function getContentHeight(content, type)
  if type == 1 then
    local label = ed.createLabelWithFontInfo(content, "normal_button")
    label:setDimensions(CCSizeMake(maxShowLength, 0))
    return label:getContentSize().height
  else
    local text = richText:new()
    text:setString(content)
    local width, height = text:getSize()
    return height
  end
end

local function setChildVisible(boo)
  chatPanel.mainLayer.chatBg1:setVisible(boo)
end

local function showOnePrivateChat(channel, data)
  if nil == data then
    return
  end
  local listView = chatPanel.mainLayer.listviewPrivate
  local height = getContentHeight(data._content, data._content_type)
  local tome = data._target_uid == ed.getUserid()
  local lineInde, lineDefaultPos
  if tome == false then
    listView:changeItemConfig(2)
    lineInde = 5
    lineDefaultPos = defaultLinePos3
  else
    listView:changeItemConfig()
    lineInde = 8
    lineDefaultPos = defaultLinePos2
  end
  local itemConfig = listView:getItemConfig()
  itemConfig[lineInde].layout.position.y = lineDefaultPos - height
  local time = getChatTimeDes(data._speak_time)
  if data._summary and data._summary._type == "cook_asst" then
    itemConfig[lineInde].layout.position.y = lineDefaultPos - height - 50
  else
    itemConfig[lineInde].layout.position.y = lineDefaultPos - height
  end
  local item
  if tome == false then
    if data._content_type == 1 then
      item = listView:addItem({
        data._target_summary._name,
        time,
        data._content
      }, {
        summary = data._target_summary,
        uid = data._target_uid,
        acc = data._summary
      })
    else
      item = listView:addItem({
        data._target_summary._name,
        time,
        "",
        data._content
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = data._target_summary,
        uid = data._target_uid,
        acc = data._summary
      })
    end
    if data._summary and data._summary._type == "cook_asst" then
      ed.chatCook:initData(item, lineDefaultPos - height)
    end
  else
    if data._content_type == 1 then
      item = listView:addItem({
        "",
        data._speaker_summary._name,
        time,
        data._content,
        {
          scale = 0.6,
          id = data._speaker_summary._avatar,
          vip = data._speaker_summary._vip > 0,
          level = data._speaker_summary._level,
          config = {levelposition = 2},
          babelLevel = data._speaker_summary._babel_level
        }
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = data._speaker_summary,
        roleId = data._speaker_role_id,
        acc = data._summary
      })
    else
      item = listView:addItem({
        "",
        data._speaker_summary._name,
        time,
        "",
        {
          scale = 0.6,
          id = data._speaker_summary._avatar,
          vip = data._speaker_summary._vip > 0,
          babelLevel = data._speaker_summary._babel_level,
          level = data._speaker_summary._level,
          config = {levelposition = 2}
        },
        data._content
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = data._speaker_summary,
        roleId = data._speaker_role_id,
        acc = data._summary
      })
    end
    if data._summary and data._summary._type == "cook_asst" then
      ed.chatCook:initData(item, lineDefaultPos - height)
    end
    local name = item.controllers.name
    local length = name:getContentSize().width
    item.controllers.hint:setPosition(ccp(110 + length, -2))
  end
end

local function showOneChat(channel, data)
  if channel == "personal_channel" then
    showOnePrivateChat(channel, data)
    return
  end
  local listView
  if channel == "world_channel" then
    listView = chatPanel.mainLayer.listviewWorld
  elseif channel == "guild_channel" then
    listView = chatPanel.mainLayer.listviewUnin
  elseif channel == "excavate_channel" then
    listView = chatPanel.mainLayer.listviewExcavate
    channel = data.channel
    data = data.content
  end
  local height = getContentHeight(data._content, data._content_type)
  listView:changeItemConfig()
  local itemConfig = listView.configData.itemConfig
  if data._content_type == 2 then
    itemConfig[1].config.visible = true
  else
    itemConfig[1].config.visible = false
  end
  itemConfig[4].layout.position.y = defaultLinePos - height
  itemConfig[1].config.scalexy.y = math.abs(defaultLinePos - height) / 58
  local speakerSummary = data._speaker_summary
  local headId = speakerSummary._avatar
  local time = getChatTimeDes(data._speak_time)
  if data._content_type == 1 then
    listView:addItem({
      time,
      data._content,
      {
        scale = 0.6,
        id = headId,
        vip = speakerSummary._vip > 0,
        level = speakerSummary._level,
        name = speakerSummary._name,
        medal = speakerSummary._medal,
        babelLevel = speakerSummary._babel_level,
        config = {
          levelposition = 4,
          nameposition = 23,
          namefont = "chat_name"
        }
      },
      ""
    }, {
      summary = speakerSummary,
      roleId = data._speaker_role_id
    })
  elseif data._content_type == 2 and data._summary then
    itemConfig[1].config.visible = false
    if data._summary._type == "top_pvp_replay" or data._summary._type == "pvp_replay" or data._summary._type == "babel_replay" or data._summary._type == "tbc_replay" or data._summary._type == "binary_replay" and data._summary._query_summary and 0 < #data._summary._query_summary or data._summary._type == "real_arena_replay" and data._summary._real_arena_replay then
      local battleRoundData = data._summary or {}
      local round_num = ed.chatBattleShareMgr:getBattleRoundNum(battleRoundData._query_summary, data._summary._type)
      local offsetPos = {
        75,
        140,
        200
      }
      itemConfig[4].layout.position.y = defaultLinePos - height - (offsetPos[round_num] or 75)
      local str = string.match(data._content, "(<text.*>)")
      local itemData = listView:addItem({
        time,
        "",
        {
          scale = 0.6,
          id = headId,
          vip = speakerSummary._vip > 0,
          level = speakerSummary._level,
          name = speakerSummary._name,
          medal = speakerSummary._medal,
          babelLevel = speakerSummary._babel_level,
          config = {
            levelposition = 4,
            nameposition = 23,
            namefont = "chat_name"
          }
        },
        str
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = speakerSummary,
        roleId = data._speaker_role_id,
        acc = data._summary
      })
      ed.chatBattleShareMgr:initBattleShare(itemData, defaultLinePos - height)
    elseif data._summary._type == "cook_asst" then
      itemConfig[4].layout.position.y = defaultLinePos - height - 50
      local itemData = listView:addItem({
        time,
        "",
        {
          scale = 0.6,
          id = headId,
          vip = speakerSummary._vip > 0,
          level = speakerSummary._level,
          name = speakerSummary._name,
          medal = speakerSummary._medal,
          babelLevel = speakerSummary._babel_level,
          config = {
            levelposition = 4,
            nameposition = 23,
            namefont = "chat_name"
          }
        },
        str
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = speakerSummary,
        roleId = data._speaker_role_id,
        acc = data._summary
      })
      ed.chatCook:initData(itemData, defaultLinePos - height)
    else
      listView:addItem({
        time,
        "",
        {
          scale = 0.6,
          id = headId,
          vip = speakerSummary._vip > 0,
          level = speakerSummary._level,
          name = speakerSummary._name,
          medal = speakerSummary._medal,
          babelLevel = speakerSummary._babel_level,
          config = {
            levelposition = 4,
            nameposition = 23,
            namefont = "chat_name"
          }
        },
        data._content
      }, {
        chatId = data._chat_id,
        channel = channel,
        summary = speakerSummary,
        roleId = data._speaker_role_id
      })
    end
  elseif data._content_type == 3 and currentChannel == "excavate_channel" then
    listView:addItem({
      time,
      "",
      {
        scale = 0.6,
        id = headId,
        vip = speakerSummary._vip > 0,
        level = speakerSummary._level,
        name = speakerSummary._name,
        medal = speakerSummary._medal,
        babelLevel = speakerSummary._babel_level,
        config = {
          levelposition = 4,
          nameposition = 23,
          namefont = "chat_name"
        }
      },
      data._content
    }, {
      chatId = data._chat_id,
      channel = channel,
      summary = speakerSummary,
      roleId = data._speaker_role_id
    })
  end
end

local function refreshWorldState(channel)
end

local function initPlayer(player, name, level, result, heros, icon, vip)
  local sIcon = player .. "Icon"
  local sLevel = player .. "Level"
  local sName = player .. "Name"
  local sResult = player .. "Result"
  local head = ed.getHeroIconByID({
    id = icon,
    vip = 0 < vip
  })
  if head then
    chatPanel.pvpLayer[sIcon]:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    chatPanel.pvpLayer[sIcon]:addChild(head)
  end
  ed.setString(chatPanel.pvpLayer[sLevel], tostring(level))
  ed.setString(chatPanel.pvpLayer[sName], name)
  local effectName = result == "victory" and "UI/alpha/HVGA/pvp/pvp_win.png" or "UI/alpha/HVGA/pvp/pvp_lose.png"
  local frame = ed.getSpriteFrame(effectName)
  if frame then
    chatPanel.pvpLayer[sResult]:initWithSpriteFrame(frame)
  end
  for i = 1, 5 do
    local hero = string.format("%sHero%d", player, i)
    chatPanel.pvpLayer[hero]:removeAllChildrenWithCleanup(true)
  end
  if heros then
    for i, v in ipairs(heros) do
      local hero = string.format("%sHero%d", player, i)
      local heroIcon = ed.readhero.createIconByHero(v)
      heroIcon.icon:setScale(0.6)
      chatPanel.pvpLayer[hero]:addChild(heroIcon.icon)
    end
  end
end

local function showPvp(data)
  if nil == data then
    return
  end
  chatPanel.pvpLayer:setVisible(true)
  local leftResult = data._result
  local rightResult
  if leftResult == "victory" then
    rightResult = "defeat"
  elseif leftResult == "defeat" then
    rightResult = "victory"
  end
  local leftAvatar = data._avatar ~= 0 and data._avatar or 1
  local rightAvatar = data._oppo_avatar ~= 0 and data._oppo_avatar or 1
  initPlayer("left", data._username, data._level, leftResult, data._self_heroes, leftAvatar, data._vip)
  initPlayer("right", data._oppo_name, data._oppo_level, rightResult, data._oppo_heroes, rightAvatar, data._oppo_vip)
end

class.showPvp = showPvp

local function dealEidList(eidstr)
  local eid = 0
  local newList = {}
  local eidList = Split(eidstr, ",")
  for k, v in ipairs(eidList) do
    if v ~= "" then
      table.insert(newList, v)
    end
  end
  if ed.linkFlag ~= 0 then
    eid = newList[ed.linkFlag] or newList[1] or 0
  end
  return eid, newList
end

class.dealEidList = dealEidList

local function showExcavate(data)
  if not data then
    return
  end
  local uid, eidstr = string.match(data, "uid:([^,]*),eid:([^d+]*),")
  local eid, eidList = dealEidList(eidstr)
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("Excavate")
  if ds then
    ed.showToast(ds)
  elseif tonumber(uid) == tonumber(ed.getUserid()) then
    ed.ui.excavate.initialize({
      from = "chatLink",
      initId = tonumber(eid)
    })
  else
    local msg = ed.upmsg.excavate()
    local qed = ed.upmsg.query_excavate_def()
    qed._mine_id = tonumber(eid)
    qed._applier_uid = tonumber(uid)
    msg._query_excavate_def = qed
    ed.send(msg, "excavate")
    ed.setRichTextExtraInfo("query_excavate_def", {uid = uid, eidList = eidList})
  end
end

class.showExcavate = showExcavate

local function showAncients(data)
  if not data then
    return
  end
  local uid = string.match(data, "uid:([^,]*),")
  local ds = ed.playerlimit.getAreaUnlockPrompt("Ancients")
  if ds then
    ed.showToast(ds)
  else
    if ed.ancients.network_mgr == nil then
      ed.ancients.network_mgr = ed.ancients.NetworkMgr.Create()
    end
    local msg = ed.upmsg.ancients()
    msg._ancients_open_panel = ed.upmsg.ancients_open_panel()
    msg._ancients_open_panel._uid = tonumber(uid)
    ed.ancients.flag_from_superlink = true
    ed.send(msg, "ancients")
  end
end

class.showAncients = showAncients

local function showRealArenaChallengeNotify(data)
  if not data then
    return
  end
  local type_challenge = string.match(data, "type_challenge:([^,]*),")
  local pvp_rule = string.match(data, "rule:([^,]*),")
  local id = string.match(data, "uid:([^,]*),")
  local name = string.match(data, "name:([^,]*),")
  local server_id = string.match(data, "server_id:([^,]*),")
  local server_name = string.match(data, "server_name:([^,]*),")
  local ds = ed.playerlimit.getAreaUnlockPrompt("RealArena")
  if ds then
    ed.showToast(ds)
  else
    local scene = ed.getCurrentScene()
    local param = {
      type = type_challenge,
      pvp_rule = pvp_rule,
      id = id,
      name = name,
      server_id = server_id,
      server_name = server_name
    }
    if scene.challenge_notify_window then
      scene.challenge_notify_window:Destroy({skipAnim = true})
    end
    local challenge_notify_win = ed.realarena.ChallengeNotifyWindow.Create(scene, param)
    scene.scene:addChild(challenge_notify_win.mainLayer, 500)
  end
end

class.showRealArenaChallengeNotify = showRealArenaChallengeNotify

local function showLadderFight(data)
  EDDebug()
end

class.showLadderFight = showLadderFight

local function showLink(data)
  if nil == data then
    return
  end
  if ed.checkIsCanClickChatLink() then
    return
  end
  local accessory = data._accessory
  if nil == accessory then
    return
  end
  local acc_type = accessory._type
  if acc_type == "binary" then
    local str = accessory._binary
    local mt = string.match(str, "type:([^,]*),")
    if mt == "excavatedefend" then
      showExcavate(str)
    elseif mt == "ancients" then
      showAncients(str)
    elseif mt == "real_arena_challenge" then
      showRealArenaChallengeNotify(str)
    end
  elseif acc_type == "pvp_replay" then
    showPvp(accessory._replay)
    currentAccessory = accessory._replay
  elseif acc_type == "binary_replay" then
    local data = ed.downmsg.battle_record():Parse(accessory._binary)
    showPvp(data)
    currentAccessory = data
  elseif acc_type == "top_pvp_replay" then
    ed.showTopPvpReplay(accessory._top_pvp_replay)
  elseif acc_type == "real_pvp_replay" then
    ed.showRealPvpReplay(accessory._real_pvp_replay, acc_type)
  elseif acc_type == "real_arena_replay" then
    ed.showRealPvpReplay(accessory._real_arena_replay, acc_type)
  elseif acc_type == "ladder_fight" then
    ed.showPvpReplay(accessory._ladder_fight)
  elseif acc_type == "multiplayer_invite" then
    ed.ui.chatMain.getInstace():pushWindow()
    ed.showMultiPlayerInvite(accessory._multiplayer_invite)
  elseif acc_type == "multi_arena_invite" then
    ed.showMultiArenaInvite(accessory._multi_arena_invite)
  elseif acc_type == "multiarena_replay" then
  elseif acc_type == "multi_stage_invite" then
    ed.showBookOfTheBraveInvite(accessory._multi_stage_invite)
  elseif acc_type == "team_invite" then
    local teamTarget = accessory._team_invite._target
    local teamId = accessory._team_invite._team_id
    if teamTarget == "chess" then
      ed.showAutoChessInvite(accessory._team_invite)
    elseif teamTarget == "team_real_arena" then
      ed.showKingsPvpInvite(teamId)
    end
  end
end

ed.ui.chat.showLink = showLink

local function insertOneMessage(channel, content)
  if not ed.blacklist.isInBlacklist(content._speaker_role_id) then
    if content._content_type == 3 then
      local param = {content = content, channel = channel}
      table.insert(excivateData, param)
    else
      table.insert(chatMessages[channel], content)
    end
  end
end

local function sortExcivateDataByTime()
  table.sort(excivateData, function(a, b)
    return a.content._speak_time < b.content._speak_time
  end)
  for k, v in pairs(excivateData) do
    table.insert(chatMessages.excavate_channel, v)
  end
  excivateData = {}
end

local function addMessage(channel, datas)
  if nil == datas then
    return
  end
  for i, v in ipairs(datas) do
    insertOneMessage(channel, v)
  end
end

local function reqChatMessage()
  if ed.getCurrentScene().identity == "main" then
    if currentChannel == "excavate_channel" then
      local msg = ed.upmsg.chat()
      msg._multi_fresh = {}
      msg._multi_fresh._channel = {
        "personal_channel",
        "guild_channel"
      }
      ed.send(msg, "chat")
    elseif "guildhero_channel" == currentChannel then
      FireEvent("ChataskTaskRequest")
      CloseTimer(refreshChatEvent.Name)
    else
      local msg = ed.upmsg.chat()
      msg._fresh = {}
      msg._fresh._channel = currentChannel
      ed.send(msg, "chat")
    end
  end
end

local function resetRefreshInternal(isTrue)
  if isTrue then
    if refreshInternal ~= defaultInternal then
      CloseTimer(refreshChatEvent.Name)
      refreshInternal = defaultInternal
      refreshChatEvent = ListenTimer(Timer:Always(refreshInternal), reqChatMessage, chatScope)
    end
  elseif refreshInternal < maxInternal and refreshChatEvent then
    CloseTimer(refreshChatEvent.Name)
    refreshInternal = refreshInternal + defaultInternal
    refreshChatEvent = ListenTimer(Timer:Always(refreshInternal), reqChatMessage, chatScope)
  end
end

local function OnChatRsp(data)
  if data._say then
    local handler = ed.netreply.chatSay
    if handler then
      handler(data._say._result == "success")
      ed.netreply.chatSay = nil
    end
    if data._say._result == "success" then
      addMessage(data._say._channel, data._say._contents)
      refreshWorldState(data._say._channel)
    end
  elseif data._fresh then
    resetRefreshInternal(data._fresh._contents)
    addMessage(data._fresh._channel, data._fresh._contents)
  elseif data._multi_fresh then
    resetRefreshInternal(#data._multi_fresh > 0)
    for k, v in pairs(data._multi_fresh) do
      addMessage(v._channel, v._contents)
    end
    sortExcivateDataByTime()
  elseif data._fetch then
    showLink(data._fetch)
  elseif data._chat_broad_say then
    class.OnChatBroadSay(data)
  end
end

local function OnChatBroadSay(msg)
  local broadSay = msg._chat_broad_say or {}
  local handler = ed.netreply.chatSay
  if handler then
    handler(broadSay._result == "success")
    ed.netreply.chatSay = nil
  end
  if broadSay._result == "success" then
    addMessage(broadSay._channel, broadSay._contents)
    refreshWorldState(broadSay._channel)
  end
end

class.OnChatBroadSay = OnChatBroadSay

local function showReplay()
  chatPanel.pvpLayer:setVisible(false)
  if currentAccessory then
    local mode
    if currentAccessory._args == 1 then
      mode = "tbc"
    elseif currentAccessory._args == 2 then
      mode = "excavateReply"
    end
    ed.showReplay(currentAccessory, mode)
  end
end

class.showReplay = showReplay

local function hideChat()
  CloseScope(chatScope)
  chatScope = {}
  chatPanel.chatTurnBack:setVisible(false)
  chatPanel.chatTurn:setVisible(true)
  chatPanel.mainLayer.listviewWorld:setVisible(false)
  chatPanel.mainLayer.listviewUnin:setVisible(false)
  chatPanel.mainLayer.listviewPrivate:setVisible(false)
  chatPanel.mainLayer.listviewExcavate:setVisible(false)
end

class.hideChat = hideChat

local function refreshTargetInfo()
  if targetSummary == nil or targetUid == nil or targetRoleId == nil then
    chatPanel.privateHint:setString(T("\232\175\183\233\128\137\230\139\169\231\167\129\232\129\138\229\175\185\232\177\161"))
  else
    chatPanel.privateHint:setString(T(targetSummary._name))
  end
end

local function initChannel()
  local inGuild = ed.player:getGuildId() ~= 0
  if currentChannel == "guild_channel" and inGuild == false then
    currentChannel = "world_channel"
  end
  ed.ui.chatask:Clear()
  if currentChannel == "world_channel" then
    chatPanel.mainLayer.world:setVisible(true)
    chatPanel.mainLayer.unin:setVisible(false)
    chatPanel.mainLayer.listviewWorld:setVisible(true)
    chatPanel.mainLayer.listviewUnin:setVisible(false)
    chatPanel.mainLayer.leftTimeBg:setVisible(true)
    chatPanel.mainLayer.leftTimes:setVisible(true)
    chatPanel.mainLayer.worldInput:setVisible(true)
    chatPanel.mainLayer.uninInput:setVisible(false)
    chatPanel.mainLayer.privateInput:setVisible(false)
    chatPanel.mainLayer.guildEdit:setVisible(false)
    chatPanel.mainLayer.worldEdit:setVisible(true)
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_active")
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(false)
    chatPanel.mainLayer.private:setVisible(false)
    chatPanel.mainLayer.listviewPrivate:setVisible(false)
    chatPanel.mainLayer.privateEdit:setVisible(false)
    chatPanel.mainLayer.guildhero:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.privateText, "chat_channel_inactive")
    chatPanel.mainLayer.listviewExcavate:setVisible(false)
    chatPanel.mainLayer.inputBg:setVisible(true)
    chatPanel.mainLayer.inputBgExcavate:setVisible(false)
    chatPanel.mainLayer.sendChat:setVisible(true)
    chatPanel.mainLayer.guildhero:setVisible(false)
  elseif currentChannel == "guild_channel" then
    chatPanel.mainLayer.world:setVisible(false)
    chatPanel.mainLayer.unin:setVisible(true)
    chatPanel.mainLayer.listviewWorld:setVisible(false)
    chatPanel.mainLayer.listviewUnin:setVisible(true)
    chatPanel.mainLayer.leftTimeBg:setVisible(false)
    chatPanel.mainLayer.leftTimes:setVisible(false)
    chatPanel.mainLayer.worldInput:setVisible(false)
    chatPanel.mainLayer.uninInput:setVisible(true)
    chatPanel.mainLayer.privateInput:setVisible(false)
    chatPanel.mainLayer.guildEdit:setVisible(true)
    chatPanel.mainLayer.worldEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_active")
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(false)
    chatPanel.mainLayer.private:setVisible(false)
    chatPanel.mainLayer.listviewPrivate:setVisible(false)
    chatPanel.mainLayer.privateEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.privateText, "chat_channel_inactive")
    chatPanel.mainLayer.listviewExcavate:setVisible(false)
    chatPanel.mainLayer.inputBg:setVisible(true)
    chatPanel.mainLayer.inputBgExcavate:setVisible(false)
    chatPanel.mainLayer.sendChat:setVisible(true)
    chatPanel.mainLayer.guildhero:setVisible(false)
  elseif currentChannel == "personal_channel" then
    local ds = ed.playerlimit.getAreaUnlockPrompt("Private Message")
    if ds then
      ed.showToast(ds)
      return
    end
    chatPanel.mainLayer.world:setVisible(false)
    chatPanel.mainLayer.unin:setVisible(false)
    chatPanel.mainLayer.listviewWorld:setVisible(false)
    chatPanel.mainLayer.listviewUnin:setVisible(false)
    chatPanel.mainLayer.leftTimeBg:setVisible(false)
    chatPanel.mainLayer.leftTimes:setVisible(false)
    chatPanel.mainLayer.worldInput:setVisible(false)
    chatPanel.mainLayer.uninInput:setVisible(false)
    chatPanel.mainLayer.privateInput:setVisible(true)
    chatPanel.mainLayer.guildEdit:setVisible(false)
    chatPanel.mainLayer.worldEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_inactive")
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(true)
    chatPanel.mainLayer.private:setVisible(true)
    chatPanel.mainLayer.listviewPrivate:setVisible(true)
    chatPanel.mainLayer.privateEdit:setVisible(true)
    ed.setLabelFontInfo(chatPanel.mainLayer.privateText, "chat_channel_active")
    chatPanel.mainLayer.listviewExcavate:setVisible(false)
    chatPanel.mainLayer.inputBg:setVisible(true)
    chatPanel.mainLayer.inputBgExcavate:setVisible(false)
    chatPanel.mainLayer.sendChat:setVisible(true)
    chatPanel.mainLayer.guildhero:setVisible(false)
    refreshTargetInfo()
  elseif currentChannel == "excavate_channel" then
    chatPanel.mainLayer.listviewExcavate:setVisible(true)
    chatPanel.mainLayer.world:setVisible(false)
    chatPanel.mainLayer.unin:setVisible(false)
    chatPanel.mainLayer.listviewWorld:setVisible(false)
    chatPanel.mainLayer.listviewUnin:setVisible(false)
    chatPanel.mainLayer.leftTimeBg:setVisible(false)
    chatPanel.mainLayer.leftTimes:setVisible(false)
    chatPanel.mainLayer.worldInput:setVisible(false)
    chatPanel.mainLayer.uninInput:setVisible(false)
    chatPanel.mainLayer.privateInput:setVisible(false)
    chatPanel.mainLayer.guildEdit:setVisible(false)
    chatPanel.mainLayer.worldEdit:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_active")
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_inactive")
    chatPanel.privateHint:setVisible(false)
    chatPanel.mainLayer.private:setVisible(false)
    chatPanel.mainLayer.listviewPrivate:setVisible(false)
    chatPanel.mainLayer.privateEdit:setVisible(false)
    chatPanel.mainLayer.inputBg:setVisible(false)
    chatPanel.mainLayer.inputBgExcavate:setVisible(true)
    chatPanel.mainLayer.sendChat:setVisible(false)
    chatPanel.mainLayer.guildhero:setVisible(false)
  elseif currentChannel == "guildhero_channel" then
    chatPanel.mainLayer.guildhero:setVisible(true)
    chatPanel.mainLayer.inputBg:setVisible(true)
    chatPanel.mainLayer.world:setVisible(false)
    chatPanel.mainLayer.unin:setVisible(false)
    chatPanel.mainLayer.private:setVisible(false)
    chatPanel.mainLayer.listviewWorld:setVisible(false)
    chatPanel.mainLayer.listviewUnin:setVisible(false)
    chatPanel.mainLayer.listviewPrivate:setVisible(false)
    chatPanel.mainLayer.listviewExcavate:setVisible(false)
    chatPanel.mainLayer.worldInput:setVisible(false)
    chatPanel.mainLayer.worldEdit:setVisible(false)
    chatPanel.mainLayer.leftTimes:setVisible(false)
    chatPanel.mainLayer.leftTimeBg:setVisible(false)
    chatPanel.mainLayer.sendChat:setVisible(false)
    chatPanel.mainLayer.uninInput:setVisible(false)
    chatPanel.mainLayer.guildEdit:setVisible(false)
    chatPanel.mainLayer.privateInput:setVisible(false)
    chatPanel.mainLayer.privateEdit:setVisible(false)
    chatPanel.privateHint:setVisible(false)
    chatPanel.mainLayer.inputBgExcavate:setVisible(false)
    ed.setLabelFontInfo(chatPanel.mainLayer.guildText, "chat_channel_active")
    ed.setLabelFontInfo(chatPanel.mainLayer.worldText, "chat_channel_inactive")
  end
end

local function refreshMessage()
  xpcall(function()
    if "guildhero_channel" == currentChannel then
      return
    end
    for i = 1, 5 do
      if chatMessages[currentChannel][1] then
        showOneChat(currentChannel, chatMessages[currentChannel][1])
        table.remove(chatMessages[currentChannel], 1)
      end
    end
  end, EDDebug)
end

local function refreshContentPos()
  if chatPanel == nil then
    return
  end
  local input = chatPanel.mainLayer.input
  local exceedLength = input:getExceedLength()
  if exceedLength then
    input.edit:setPosition(ccp(-exceedLength, 0))
  else
    input.edit:setPosition(ccp(0, 0))
  end
end

local function openChat()
  refreshInternal = defaultInternal
  chatPanel.mainLayer:setVisible(true)
  if chatPanel.mainLayer.chatHint:isVisible() then
    currentChannel = chatNotifyType
  end
  initChannel()
  chatPanel.chatTurnBack:setVisible(true)
  chatPanel.chatTurn:setVisible(false)
  chatPanel.mainLayer.chatHint:setVisible(false)
  chatPanel.mainLayer.chatHintLight:setVisible(false)
end

class.openChat = openChat

local function openBlacklist()
  ed.blacklist.getBlacklist()
end

class.openBlacklist = openBlacklist

local function endChat()
  chatTune = false
  setChildVisible(false)
  hideChat()
end

local function startChat()
  hideChat()
  setChildVisible(true)
  chatTune = true
  openChat()
end

class.startChat = startChat

local function setChatOpenPosition()
  local chatbg = chatPanel.mainLayer.chatBg
  local posX = chatbg:getPosition()
  chatbg:setPosition(ccp(chatMaxX, chatYPosition))
end

class.setChatOpenPosition = setChatOpenPosition

local function closeTargetInfo()
  chatPanel.targetLayer:setVisible(false)
  targetSummary = nil
end

class.closeTargetInfo = closeTargetInfo

local function getMiddleX()
  if chatTune == false then
    return chatMinX / 1.2
  else
    return chatMinX / 4
  end
end

local function refreshChatPanelInputPos()
  local x, y = chatPanel.chatBg:getPosition()
  local worldEdit = chatPanel.worldEdit
  local guildEdit = chatPanel.guildEdit
  local privateEdit = chatPanel.privateEdit
  worldEdit.edit:setPosition(ccp(x + editBoxDistance, 380))
  guildEdit.edit:setPosition(ccp(x + editBoxDistance + 30, 380))
  privateEdit.edit:setPosition(ccp(x + editBoxDistance + 90, 380))
end

local function runChatAction()
  local chatbg = chatPanel.mainLayer.chatBg
  local posX = chatbg:getPosition()
  local action = CCSequence:create(ccArrayMake(CCMoveTo:create(0.2, ccp(chatMinX, chatYPosition)), CCCallFunc:create(function()
    refreshChatPanelInputPos()
  end)))
  local middleX = getMiddleX()
  if posX >= middleX then
    if chatTune == false then
      startChat()
    end
    chatbg:runAction(CCMoveTo:create(0.2, ccp(chatMaxX, chatYPosition)))
  else
    if chatTune == true then
      endChat()
    end
    chatbg:runAction(action)
  end
end

local function chatTurn()
  if moveState then
    runChatAction()
    return
  end
  local chatbg = chatPanel.mainLayer.chatBg
  local action = CCSequence:create(ccArrayMake(CCMoveTo:create(0.2, ccp(chatMinX, chatYPosition)), CCCallFunc:create(function()
    refreshChatPanelInputPos()
  end)))
  if chatTune == false then
    local ds = ed.playerlimit.getAreaUnlockPrompt("World Message")
    if ds then
      ed.showToast(ds)
      return
    end
    startChat()
    chatbg:runAction(CCMoveTo:create(0.2, ccp(chatMaxX, chatYPosition)))
  else
    endChat()
    chatbg:runAction(action)
  end
end

class.chatTurn = chatTurn

local function sendServerMsg(content)
  if not ed.can_server_chat then
    ed.showToast("\229\189\147\229\137\141\228\184\141\229\133\183\230\156\137\229\133\168\230\156\141\232\129\138\229\164\169\230\157\131\233\153\144")
    return
  end
  if ed.getServerTime() - ed.chatServerTimes < ed.ui.chatMain.chatServerTime then
    ed.showToast("\232\129\138\229\164\169\233\162\145\231\142\135\229\164\170\229\191\171 \232\175\183\228\188\145\230\129\175\228\184\128\228\184\139")
    return
  end
  ed.chatNetDataMrg:sendServerChatMsg({content = content})
end

class.sendServerMsg = sendServerMsg

local function sendMessage(content, chatType, accessory, channel, targets, data)
  if channel == "chatServer_channel" then
    ed.ui.chat.sendServerMsg(content)
    return
  end
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
    msg._say._channel = channel or currentChannel
    msg._say._content = content
    if msg._say._channel == "personal_channel" and data then
      local ds = ed.playerlimit.getAreaUnlockPrompt("Private Message")
      if ds then
        ed.showToast(ds)
        return
      end
      msg._say._target = {}
      msg._say._target._role_id = data.roleId
    end
    if msg._say._channel == "chatroom_channel" and data then
      msg._say._group_type = data.roomtype
      msg._say._chat_group_id = data.roomid
    end
    if accessory then
      msg._say._accessory = accessory
    end
  end
  ed.send(msg, "chat")
end

class.sendMessage = sendMessage

local function getCurrentContent()
  if currentChannel == "world_channel" then
    return chatPanel.worldEdit:getString()
  elseif currentChannel == "guild_channel" then
    return chatPanel.guildEdit:getString()
  else
    return chatPanel.privateEdit:getString()
  end
  return ""
end

local function checkPrivateCondition()
  if currentChannel == "personal_channel" and (targetSummary == nil or targetUid == nil or targetRoleId == nil) then
    ed.showToast(T("\233\156\128\232\166\129\229\133\136\230\140\135\229\174\154\231\167\129\232\129\138\229\175\185\232\177\161\229\144\142\230\137\141\232\131\189\229\156\168\231\167\129\232\129\138\233\162\145\233\129\147\229\143\145\232\168\128"))
    return false
  end
  return true
end

local function checkChatCondition()
  local content = getCurrentContent()
  if content == "" then
    return false
  end
  if ed.dirtyword_check(content) then
    ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
    return false
  end
  local levelLimit = ed.playerlimit.getAreaUnlockLevel("WorldChannel")
  local guildJob = ed.player:getGuildJob()
  if currentChannel == "world_channel" or currentChannel == "personal_channel" then
    if levelLimit > ed.player:getLevel() and guildJob ~= "chairman" then
      ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%i\231\186\167\230\137\141\232\131\189\229\143\145\232\168\128(\229\133\172\228\188\154\228\188\154\233\149\191\233\153\164\229\164\150)", levelLimit))
      return false
    end
    local now = ed.getServerTime()
    if lastWorldChatTime ~= nil and now - lastWorldChatTime < 11 then
      ed.showToast(T("\232\175\180\232\175\157\233\162\145\231\142\135\229\164\170\229\191\171"))
      return false
    end
  elseif currentChannel == "guild_channel" and ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return false
  end
  if ed.player:getName() == "" then
    local bename = ed.ui.renameWindow.create()
    bename:popWindow()
    return false
  end
  return checkPrivateCondition()
end

local function sendCurrentContent()
  local content = getCurrentContent()
  sendMessage(content, 1)
  if currentChannel == "world_channel" then
    chatPanel.worldEdit:setString("")
  elseif currentChannel == "guild_channel" then
    chatPanel.guildEdit:setString("")
  else
    chatPanel.privateEdit:setString("")
  end
end

local function sendChat()
  if ed.blacklist.isInBlacklist(targetRoleId) then
    ed.showToast(T("\230\151\160\230\179\149\229\144\145\233\187\145\229\144\141\229\141\149\228\184\173\231\154\132\228\186\186\229\143\145\233\128\129\230\182\136\230\129\175"))
    return
  end
  local bCanSend = checkChatCondition()
  if bCanSend == false then
    return
  end
  sendCurrentContent()
end

class.sendChat = sendChat

local function selectChannel(channel)
  if not channel then
    return
  end
  currentChannel = channel
  initChannel()
  reqChatMessage()
end

local function OnWorldTab()
  selectChannel("world_channel")
  targetUid = nil
  targetRoleId = nil
end

class.OnWorldTab = OnWorldTab

local function OnUninTab()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return
  end
  selectChannel("guild_channel")
  targetUid = nil
  targetRoleId = nil
end

class.OnUninTab = OnUninTab

local function OnExcavateTab()
  selectChannel("excavate_channel")
  targetUid = nil
  targetRoleId = nil
end

class.OnExcavateTab = OnExcavateTab

local function OnGuildHeroTab()
  selectChannel("guildhero_channel")
  targetUid = nil
  targetRoleId = nil
end

class.OnGuildHeroTab = OnGuildHeroTab

local function getTargetSummary(item)
  if not item then
    return
  end
  if not item.extraData then
    return false
  end
  if item.extraData.uid == ed.getUserid() then
    return false
  end
  targetSummary = item.extraData.summary
  targetUid = item.extraData.uid
  targetRoleId = item.extraData.roleId
  return true
end

local function showTargetInfo()
  chatPanel.targetLayer:setVisible(true)
  local param = {
    id = targetSummary._avatar,
    level = targetSummary._level,
    name = targetSummary._name,
    vip = targetSummary._vip > 0,
    scale = 0.8,
    babelLevel = targetSummary._babel_level
  }
  if targetSummary._medal then
    param.medal = targetSummary._medal
  end
  local head = ed.getWholeHeadIcon(param)
  local guildInfo = chatPanel.targetLayer.guildInfo
  if targetSummary._guild_name and targetSummary._guild_name ~= "" then
    guildInfo:setString(T("<text|chat_name|\230\157\165\232\135\170\229\133\172\228\188\154: ><text|chat_content|%s>", targetSummary._guild_name))
  else
    guildInfo:setString(T("<text|chat_name|\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154>"))
  end
  chatPanel.targetLayer.target:removeAllChildrenWithCleanup(true)
  chatPanel.targetLayer.target:addChild(head)
  if ed.player:getLevel() < 85 then
    chatPanel.targetLayer.trade:setVisible(false)
    chatPanel.targetLayer.addblack:setPosition(ccp(200, 40))
  else
    chatPanel.targetLayer.trade:setVisible(true)
    chatPanel.targetLayer.addblack:setPosition(ccp(130, 40))
  end
end

local function OnPrivateTab()
end

class.OnPrivateTab = OnPrivateTab

local function hitWorldHead(index)
  local item = chatPanel.listviewWorld:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end

class.hitWorldHead = hitWorldHead

local function hitUninHead(index)
  local item = chatPanel.listviewUnin:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end

class.hitUninHead = hitUninHead

local function hitExcavateHead(index)
  local item = chatPanel.listviewExcavate:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end

class.hitExcavateHead = hitExcavateHead

local function hitPrivateHead(index)
  local item = chatPanel.listviewPrivate:getListData(index)
  if getTargetSummary(item) then
    showTargetInfo()
  end
end

class.hitPrivateHead = hitPrivateHead

local function hitPrivateIndex(index, x, y)
  local item = chatPanel.listviewPrivate:getListData(index)
  if getTargetSummary(item) then
    refreshTargetInfo()
    local oldName = chatPanel.privateHint:getString()
    if targetUid and oldName ~= targetSummary._name then
      chatPanel.privateHint:setString(T(targetSummary._name))
      chatPanel.privateHint:stopAllActions()
      chatPanel.privateHint:setScale(1.1)
      local s = CCScaleTo:create(0.2, 1)
      s = CCEaseBackIn:create(s)
      chatPanel.privateHint:runAction(s)
    end
  end
end

class.hitPrivateIndex = hitPrivateIndex

local function onTargetChat()
  chatPanel.targetLayer:setVisible(false)
  OnPrivateTab()
end

class.onTargetChat = onTargetChat

local function addBlacklist()
  chatPanel.targetLayer:setVisible(false)
  ed.blacklist.setTargetRoleId(targetRoleId)
  local msg = ed.upmsg.chat()
  msg._chat_add_bl = {}
  msg._chat_add_bl._role_id = targetRoleId
  print("up targetRoleId " .. targetRoleId)
  ed.send(msg, "chat")
  targetRoleId = nil
end

class.addBlacklist = addBlacklist

function askTradeHandler()
  ed.ui.trade_network:sendAskTrade(targetUid)
end

class.askTradeHandler = askTradeHandler

local function setTargetSummary(summary, uid, roleId)
  targetRoleId = roleId
  targetSummary = summary
  targetUid = uid
end

class.setTargetSummary = setTargetSummary

local function sendPvpLink(content, recordId, channel, binary, accessory_type, extra_data, battle_data)
  if nil == recordId then
    return
  end
  local accessory = ed.upmsg.chat_acc()
  accessory._type = accessory_type or "pvp_replay"
  accessory._record_id = recordId
  accessory._binary = binary
  accessory._query_summary = battle_data
  if accessory_type == "real_arena_replay" and extra_data then
    accessory._role_id = extra_data[1]
    accessory._target_type = extra_data[2]
  end
  sendMessage(content, 2, accessory, channel)
end

class.sendPvpLink = sendPvpLink

local function closePvp()
  chatPanel.pvpLayer:setVisible(false)
end

class.closePvp = closePvp

local function sendBabelBattleShareLink(param)
  local channel = param.channel
  local type = param.type
  local content = param.content
  local recordid = param.recordid
  local accessory = ed.upmsg.chat_acc()
  accessory._type = "babel_replay"
  accessory._record_id = recordid
  sendMessage(content, type, accessory, channel)
end

class.sendBabelBattleShareLink = sendBabelBattleShareLink

local function sendBattleShareLink(param, type)
  local channel = param.channel
  local contentType = param.type
  local content = param.content
  local recordid = param.recordid
  local accessory = ed.upmsg.chat_acc()
  accessory._type = type
  accessory._record_id = recordid
  accessory._role_id = ed.getRoleId()
  sendMessage(content, contentType, accessory, channel)
end

class.sendBattleShareLink = sendBattleShareLink

local function sendExcavateDefendLink(param)
  local param = param or {}
  local content = param.content
  local eid = param.excavateId
  local callback = param.callback
  local targets = param.targets
  local channel = param.channel or "guild_channel"
  local accessory = {}
  accessory._type = "binary"
  accessory._binary = T("type:excavatedefend,uid:%s,eid:%s,", ed.getUserid(), eid)
  ed.netreply.chatSay = callback
  sendMessage(content, 3, accessory, channel, targets)
end

class.sendExcavateDefendLink = sendExcavateDefendLink

local function sendAncientsInvitationLink(param)
  local param = param or {}
  local content = param.content
  local eid = param.excavateId
  local callback = param.callback
  local targets = param.targets
  local channel = param.channel or "guild_channel"
  local accessory = {}
  accessory._type = "binary"
  accessory._binary = T("type:excavatedefend,uid:%s,eid:%s,", ed.getUserid(), eid)
  ed.netreply.chatSay = callback
  sendMessage(content, 3, accessory, channel, targets)
end

class.sendAncientsInvitationLink = sendAncientsInvitationLink

local function chatTurnTouch(event, x, y)
  if chatPanel == nil then
    return
  end
  ed.chatBattleShareMgr:touch(event, x, y)
  ed.chatCook:touch(event, x, y)
  local result = chatPanel.mainLayer:touch(event, x, y)
  local turn = chatPanel.mainLayer.chatTurn
  local turnBack = chatPanel.mainLayer.chatTurnBack
  if event == "began" then
    if turn.pressed == true or turnBack.pressed == true then
      dragPressX = x
      local x, y = chatPanel.mainLayer.chatBg:getPosition()
      oriChatPos = ccp(x, y)
    end
  elseif event == "moved" then
    if nil == dragPressX then
      return
    end
    if math.abs(x - dragPressX) < 1 and moveState == nil then
      return
    end
    local pos = oriChatPos.x + x - dragPressX
    pos = math.max(pos, chatMinX)
    pos = math.min(pos, chatMaxX)
    local chatbg = chatPanel.mainLayer.chatBg
    chatbg:setPosition(ccp(pos, oriChatPos.y))
    setChildVisible(true)
    moveState = true
  elseif event == "ended" then
    if dragPressX then
      chatTurn()
    end
    dragPressX = nil
    moveState = nil
  end
  return result
end

local function OnChatNotifyRsp(notifyData)
  if nil == notifyData then
    return
  end
  if chatPanel == nil then
    return
  end
  if 0 < notifyData and chatTune == false then
    chatPanel.mainLayer.chatHint:setVisible(true)
    chatPanel.mainLayer.chatHintLight:setVisible(true)
  end
  if notifyData == 1 then
    chatNotifyType = "personal_channel"
  elseif notifyData == 2 then
    chatNotifyType = "guildhero_channel"
  end
end

local function refreshInputPos()
  if not chatTune then
    return
  end
  refreshChatPanelInputPos()
end

local function initPanel()
  local size = chatPanel.mainLayer.chatBg:getContentSize()
  local l, r, t, b = ed.getDisplayVertex()
  chatMinX = l - 0.94 * size.width
  chatMaxX = l - 7
  chatPanel.mainLayer.chatBg:setPosition(ccp(chatMinX, chatYPosition))
  refreshChatPanelInputPos()
  chatPanel.mainLayer.guildEdit:setVisible(false)
  ListenTimer(Timer:Always(0.01), refreshInputPos)
  setChildVisible(false)
  chatPanel.mainLayer.privateEdit:setConditionFunc(checkPrivateCondition)
end

local function createChatPanel()
  chatPanel = panelMeta:new2(class, EDTables.chatConfig.UIRes)
  return chatPanel
end

function ed.getChatPanel()
  if chatPanel == nil then
    chatPanel = createChatPanel()
  end
  chatPanel = createChatPanel()
  return chatPanel
end

local chatTargetLogic = {}
local chatTargetLayer, chatTargetInfo, attackCutDown
local chatTargetScope = {}

function chatTargetLogic.closeTargetInfo()
  CloseScope(chatTargetScope)
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and chatTargetLayer then
    if attackCutDown then
      chatTargetLayer:getRootLayer():stopAction(attackCutDown)
      attackCutDown = nil
    end
    currentScene:removeChild(chatTargetLayer:getRootLayer(), true)
    chatTargetLayer = nil
  end
end

function chatTargetLogic.onTargetChat()
  chatTargetLogic.closeTargetInfo()
  ed.chatNetDataMrg:reqChatContact(function()
    ed.ui.chatMain.getInstace():OnPrivateTab(chatTargetInfo)
  end)
end

function chatTargetLogic.onTargetHomePage()
  chatTargetLogic.closeTargetInfo()
  ed.registerNetReply("req_home_page", function(data)
    local panel = ed.ui.PlayerInfoPanel.create(data, false)
    panel:popWindow()
  end)
  ed.PlayerInfoNetwork:requestHomePage(chatTargetInfo.roleId)
end

function chatTargetLogic.onTargetAttack()
  local data = chatTargetInfo.data
  local config = chatTargetInfo.config
  local type = config.type
  if config.curRank < data._rank then
    ed.showToast(T("\228\189\160\231\154\132\230\142\146\229\144\141\229\183\178\231\187\143\229\156\168\229\175\185\230\150\185\229\137\141\233\157\162\228\186\134\239\188\140\233\165\182\228\187\150\228\184\128\230\172\161\229\144\167\239\188\129"))
    return
  end
  local uRank = math.floor(config.curRank * 0.3)
  if uRank > data._rank then
    ed.showToast(T("\228\189\160\231\154\132\230\142\146\229\144\141\232\144\189\229\144\142\229\175\185\230\150\185\229\164\170\229\164\154\239\188\140\229\134\141\229\138\160\230\138\138\229\138\178\229\144\167\239\188\129"))
    return
  end
  if "pvp" == type then
    if chatTargetInfo.times < 1 then
      chatTargetInfo.buyType = "times"
      ed.ui.pvpMainScene.buyPvpTime()
      return
    elseif chatTargetInfo.cdTime > 0 then
      chatTargetInfo.buyType = "CD"
      ed.ui.pvpMainScene:resetCD()
      return
    end
  elseif "toppvp" == type then
    if chatTargetInfo.times < 1 then
      chatTargetInfo.buyType = "times"
      ed.ui.toppvp:buyPvpTime()
      return
    elseif chatTargetInfo.cdTime > 0 then
      chatTargetInfo.buyType = "CD"
      ed.ui.toppvp:resetCD()
      return
    end
  end
  chatTargetLogic.closeTargetInfo()
  if "pvp" == type then
    ed.pushScene(ed.ui.battleprepare.create({
      pvpMode = "attack",
      enemyId = data._user_id,
      stage_id = -1,
      enemyHeros = data._heros,
      banHero = data._ban_hero
    }))
  end
end

function chatTargetLogic.refreshAttackCDAndTimes()
  if chatTargetInfo.buyType == "times" then
    chatTargetInfo.times = 5
  end
  chatTargetInfo.cdTime = 0
  if attackCutDown then
    chatTargetLayer:getRootLayer():stopAction(attackCutDown)
    attackCutDown = nil
  end
  local heroInfoLayer = chatTargetInfo.heroInfoLayer
  ed.setLabelString(heroInfoLayer.attackLabel, T("\229\164\141\228\187\135"))
end

function chatTargetLogic.createTargetInfoNode()
  local config = chatTargetInfo.config
  local summary = chatTargetInfo.summary
  local data = chatTargetInfo.data
  local type = config.type
  if chatTargetLayer == nil then
    chatTargetLayer = panelMeta:new2(chatTargetLogic, EDTables.chatConfig.ChatTargetRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(chatTargetLayer:getRootLayer(), 500)
    end
  end
  local heroInfoLayer
  local lineNum = 1
  if type == "pvp" then
    heroInfoLayer = chatTargetLayer.targetpvpLayer
  elseif type == "toppvp" then
    heroInfoLayer = chatTargetLayer.targettoppvpLayer
    lineNum = 3
  end
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.8,
    name = summary._name,
    vip = summary._vip > 0,
    babelLevel = summary._babel_level
  }
  if summary._medal then
    param.medal = summary._medal
  end
  if summary._babel_level then
    param.babelLevel = summary._babel_level
  end
  local opponent_head = ed.getWholeHeadIcon(param)
  if opponent_head then
    heroInfoLayer.headIcon:removeAllChildrenWithCleanup(true)
    heroInfoLayer.headIcon:addChild(opponent_head)
  end
  if data._rank == 0 then
    local rankSpr = ed.createSprite("UI/alpha/HVGA/pvp/phantom_unknow.png")
    rankSpr:setScale(0.8)
    ed.replaceNode(heroInfoLayer.rankNum, rankSpr)
  else
    local width = ed.createNumbers(heroInfoLayer.rankNum, tostring(data._rank), -2, nil, "small_pvp")
    heroInfoLayer.rankNum:setContentSize(CCSizeMake(width, 20))
    heroInfoLayer.rankNum:setCascadeOpacityEnabled(true)
  end
  heroInfoLayer.heroes:removeAllChildrenWithCleanup(true)
  heroInfoLayer.heroes:setScale(0.6)
  local oppo_heroes = {}
  local ban_hero = 0
  if type == "pvp" then
    oppo_heroes = data._heros
    ban_hero = data._ban_hero
  elseif type == "toppvp" then
    oppo_heroes = data._oppo_heroes
  end
  for i = 1, lineNum do
    local team_heroes = oppo_heroes[i]
    if team_heroes then
      if type == "pvp" then
        team_heroes = ed.SortHeroesByMaxRange(data._heros)
      elseif type == "toppvp" then
        team_heroes = ed.SortHeroesByMaxRange(team_heroes._heroes)
      end
    else
      team_heroes = {
        {},
        {},
        {},
        {},
        {}
      }
    end
    local posX = 93
    local offPox = 0
    if ban_hero ~= 0 then
      offPox = 25
    end
    local pos_l = 0
    for j, hero in ipairs(team_heroes) do
      local heroIcon = ed.readhero.createIconByHero(hero)
      heroIcon.icon:setPosition(ccp((j - 1) * posX + 20 - offPox, -(i - 1) * 90))
      heroInfoLayer.heroes:addChild(heroIcon.icon)
      pos_l = j
    end
    if ban_hero ~= 0 then
      local heroIcon = ed.readhero.createIcon({id = ban_hero})
      heroIcon.icon:setPosition(ccp(pos_l * posX + 20 - offPox, -(i - 1) * 90))
      heroInfoLayer.heroes:addChild(heroIcon.icon)
      heroIcon:showBanTag()
    end
  end
  if summary._guild_name and summary._guild_name ~= "" then
    heroInfoLayer.guildName:setVisible(true)
    local guildNameStr = summary._guild_name
    if data._guild_id then
      guildNameStr = summary._guild_name .. "(" .. data._guild_id .. ")"
    end
    ed.setString(heroInfoLayer.guildHint, T("\230\157\165\232\135\170\229\133\172\228\188\154:"))
    ed.setString(heroInfoLayer.guildName, guildNameStr)
  else
    heroInfoLayer.guildName:setVisible(false)
    ed.setString(heroInfoLayer.guildHint, T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"))
  end
  heroInfoLayer.attack:setVisible(config.battleType == "revenge")
  heroInfoLayer.attackLabel:setVisible(config.battleType == "revenge")
  if config.battleType ~= "revenge" then
    heroInfoLayer.chat:setPosition(ccp(190, 36))
  else
    heroInfoLayer.chat:setPosition(ccp(133, 36))
    if 0 < tonumber(chatTargetInfo.cdTime) then
      local attackLabel = heroInfoLayer.attackLabel
      ed.setLabelString(attackLabel, ed.getmsNString(chatTargetInfo.cdTime))
      
      local function callback()
        xpcall(function()
          if chatTargetInfo.cdTime > 0 then
            chatTargetInfo.cdTime = chatTargetInfo.cdTime - 1
            ed.setLabelString(attackLabel, ed.getmsNString(chatTargetInfo.cdTime))
          else
            ed.setLabelString(attackLabel, T("\229\164\141\228\187\135"))
            if attackCutDown then
              chatTargetLayer:getRootLayer():stopAction(attackCutDown)
              attackCutDown = nil
            end
          end
        end, EDDebug)
      end
      
      if attackCutDown == nil then
        attackCutDown = ed.timeSchedule(chatTargetLayer:getRootLayer(), callback, 1)
      end
    end
  end
  heroInfoLayer:setVisible(true)
  chatTargetInfo.heroInfoLayer = heroInfoLayer
end

function ed.showTargetRecordLayer(targetSummary, config)
  local function handler(data)
    chatTargetInfo = {}
    
    chatTargetInfo.summary = targetSummary
    chatTargetInfo.data = data
    chatTargetInfo.config = config
    chatTargetInfo.userId = data._user_id
    chatTargetInfo.cdTime = config.cdTime
    chatTargetInfo.times = config.times
    chatTargetInfo.uid = data._user_id
    chatTargetLogic:createTargetInfoNode()
    ListenEvent("resetPvpCDAndTimesSuccessed", function()
      chatTargetLogic:refreshAttackCDAndTimes()
    end, chatTargetScope)
  end
  
  return handler
end

local upTopLayerScriptFunid
local topLayerScope = {
  up = {},
  down = {}
}
local updt = 0.01

local function getCurrentScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function topLayerMoveUp(height, layer, y)
  local count = 0
  
  local function handler()
    count = count + updt
    if not tolua.isnull(layer) then
      if height > height * count then
        layer:setPosition(ccp(layer:getPositionX(), height * count))
      else
        layer:setPosition(ccp(layer:getPositionX(), y))
        CloseScope(topLayerScope.up)
      end
    end
  end
  
  return handler
end

local function closeTopWindow(topLayerScriptFunid, topWindowLayer, self_ui, y)
  local function handler()
    if not tolua.isnull(self_ui.tpBg) then
      ListenTimer(Timer:Always(updt), topLayerMoveUp(self_ui.tpBg:getContentSize().height, topWindowLayer, y), topLayerScope.up)
    end
  end
  
  return handler
end

local function topLayerMoveDown(height, layer, y)
  local count = 0
  
  local function handler()
    count = count + updt
    if not tolua.isnull(layer) then
      if y - height < y - height * count then
        layer:setPosition(ccp(layer:getPositionX(), y - height * count))
      else
        layer:setPosition(ccp(layer:getPositionX(), y - height))
        CloseScope(topLayerScope.down)
      end
    end
  end
  
  return handler
end

local function formatContent(str)
  local data = str
  if string.find(data, "<link|wakuang|") then
    local str2 = string.match(data, "<link|wakuang|(%d+),>")
    str2 = ed.getDataTable("ExcavateTreasure")[tonumber(str2)]["Display Name"]
    return string.format("\233\130\128\232\175\183\233\152\178\229\174\136\239\188\154\227\128\144%s\227\128\145", str2)
  elseif string.find(data, "<link|ancients|") then
    local count = string.match(data, "<link|ancients|(%d+)>")
    return string.format("\233\130\128\232\175\183\230\142\162\231\180\162\239\188\154\227\128\144\231\165\158\231\167\152\233\129\151\232\191\185\227\128\145(\229\143\139\230\131\133\231\130\185\239\188\154%d)", count)
  elseif string.find(data, "<link|real_arena_challenge|") then
    local pvp_rule = string.match(data, "<link|real_arena_challenge|([^>]+)>")
    local text = string.match(data, "<text|dark_white|([^|]+)|400>") or ""
    return string.format("\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154\227\128\144%s\230\168\161\229\188\143\227\128\145 %s", ed.realarena.pvp_rule_string[pvp_rule], text)
  elseif string.find(data, "<link|ladder_fight|") then
    return string.format("\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154\227\128\144\231\171\158\230\138\128\229\156\186\227\128\145")
  elseif string.find(data, "<link|multiplayer|") then
    local str2 = string.match(data, "<link|multiplayer|(%d+),>")
    return string.format("\232\129\148\230\156\186\229\144\136\228\189\156\239\188\154\227\128\144%s\227\128\145", str2)
  end
  return str
end

local function openTopWindow(channel, content)
  local currentScene = getCurrentScene()
  local topWindowLayer = CCLayer:create()
  topWindowLayer:setClipRect(CCRectMake(115, 0, 600, 480))
  local x, y = currentScene:getContentSize().width / 2, currentScene:getContentSize().height
  print("zx---->>>", x, y)
  local topLayerScriptFunid
  local self_ui = {}
  local UIRes = {
    {
      t = "Scale9Sprite",
      base = {
        name = "tpBg",
        res = "UI/alpha/HVGA/chat/chat_notification_bar_bg.png",
        capInsets = CCRectMake(12, 12, 10, 10)
      },
      layout = {
        anchor = ccp(0.5, 0),
        position = ccp(x, y)
      },
      config = {
        scaleSize = CCSizeMake(625, 40)
      }
    },
    {
      t = "RichText",
      base = {
        name = "content",
        text = "",
        parent = "tpBg"
      },
      layout = {
        position = ccp(50, 12)
      },
      config = {}
    }
  }
  if channel == "personal_channel" then
    if tolua.isnull(self_ui.tpBg) then
      local readNode = ed.readnode.create(topWindowLayer, self_ui)
      readNode:addNode(UIRes)
      currentScene:addChild(topWindowLayer, 2000)
    end
    local str = formatContent(content._content or "")
    str = T("<text|chat_quality_blue|\228\189\160\230\156\1371\230\157\161\231\167\129\232\129\138 ><text|title_yellow|%s ><text|normal_button|\229\175\185\228\189\160\232\175\180:%s >", content._speaker_summary._name or "", str)
    self_ui.content:setString(str)
    local height = self_ui.tpBg:getContentSize().height
    ListenTimer(Timer:Always(updt), topLayerMoveDown(height, self_ui.tpBg, y), topLayerScope.down)
  end
  return topLayerScriptFunid, topWindowLayer, self_ui, y
end

local function chatLong(data)
  local data = data
  local topLayerScriptFunid, topWindowLayer, self_ui, y = openTopWindow(data._channel, data._contents)
  ListenTimer(Timer:Once(3), closeTopWindow(topLayerScriptFunid, topWindowLayer, self_ui, y))
end
