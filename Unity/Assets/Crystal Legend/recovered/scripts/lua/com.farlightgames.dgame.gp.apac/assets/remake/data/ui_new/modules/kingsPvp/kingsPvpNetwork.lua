module("ed.realarena", package.seeall)
local ed = ed
lag_tolerance = 900
lag_status = {
  {ceiling = 300, status = "green"},
  {ceiling = 600, status = "yellow"},
  {ceiling = 900, status = "red"}
}
local default_time_timeout = 20
local reSendTimeout = 3
local error_string_list = {
  choose_hero_deny = T("\229\189\147\229\137\141\228\184\141\229\143\175\228\187\165\233\128\137\230\139\169\232\139\177\233\155\132"),
  deselect_hero_deny = T("\229\189\147\229\137\141\228\184\141\229\143\175\228\187\165\229\143\150\230\182\136\233\128\137\230\139\169\232\139\177\233\155\132"),
  choose_hero_num_limit = T("\233\128\137\230\139\169\232\139\177\233\155\132\228\184\170\230\149\176\232\182\133\229\135\186\228\184\138\233\153\144"),
  hero_already_used = T("\232\139\177\233\155\132\229\183\178\231\187\143\232\162\171\228\189\191\231\148\168\232\191\135"),
  pvp_room_undefined = T("\229\175\185\230\136\152\230\156\141\229\138\161\229\153\168\230\156\170\233\133\141\231\189\174"),
  match_process_confilict = T("\229\183\178\231\187\143\229\156\168\229\140\185\233\133\141\233\152\159\228\188\141\228\184\173\228\186\134\239\188\140\232\175\183\231\168\141\229\128\153"),
  heroes_not_enough = T("\232\135\179\229\176\145\230\139\165\230\156\13715\229\144\141\232\139\177\233\155\132\230\137\141\229\143\175\228\187\165\229\143\130\228\184\142\231\171\158\230\138\128\230\168\161\229\188\143"),
  season_not_found = T("\231\171\158\230\138\128\230\168\161\229\188\143\230\154\130\230\156\170\229\188\128\229\144\175\239\188\140\232\175\183\231\173\137\229\190\133\228\184\139\228\184\128\232\181\155\229\173\163\229\188\128\229\144\175"),
  athletics_not_open = T("\229\189\147\229\137\141\230\151\182\230\174\181\231\171\158\230\138\128\230\168\161\229\188\143\232\181\155\229\156\186\230\156\170\229\188\128\230\148\190"),
  level_not_reach = T("\230\136\152\233\152\159\231\173\137\231\186\167\228\184\141\232\182\17910\231\186\167"),
  user_not_in_guild = T("\228\189\160\230\178\161\230\156\137\229\138\160\229\133\165\229\133\172\228\188\154"),
  oppo_in_battle = T("\229\175\185\230\150\185\230\173\163\229\156\168\229\175\185\230\136\152\228\184\173"),
  oppo_heroes_not_enough = T("\229\175\185\230\150\185\230\178\161\230\156\137\232\182\179\229\164\159\231\154\132\232\139\177\233\155\132\232\191\155\232\161\140\229\175\185\230\136\152"),
  self_be_challenged = T("\228\189\160\230\173\163\229\156\168\229\175\185\230\136\152\228\184\173"),
  in_oppo_blacklist = T("\228\189\160\229\183\178\232\162\171\229\175\185\230\150\185\229\138\160\229\133\165\233\187\145\229\144\141\229\141\149"),
  oppo_offline = T("\229\175\185\230\150\185\229\164\132\228\186\142\231\166\187\231\186\191\231\138\182\230\128\129\239\188\140\230\151\160\230\179\149\229\186\148\230\136\152"),
  hero_invalid = T("\229\189\147\229\137\141\232\139\177\233\155\132\228\184\141\229\143\175\231\148\168"),
  match_process_already = T("\228\189\160\229\183\178\231\187\143\229\156\168\229\140\185\233\133\141\228\184\173"),
  matched_in_battle = T("\228\189\160\230\173\163\229\156\168\230\136\152\230\150\151\228\184\173\239\188\140\232\175\183\231\168\141\229\144\142\229\156\168\232\191\155\232\161\140\229\140\185\233\133\141"),
  act_as_brush = T("\232\191\158\231\187\173\228\184\137\230\172\161\230\150\173\231\186\191\230\136\150\233\128\128\229\135\186\230\184\184\230\136\143\239\188\140\232\175\183\231\168\141\229\144\142\233\135\141\232\175\149"),
  level_not_reached = T("\231\173\137\231\186\167\230\156\170\232\190\190\229\136\176"),
  not_apply_period = T("\233\157\158\230\138\165\229\144\141\230\151\182\233\151\180"),
  room_not_exsits = T("\230\136\191\233\151\180\228\184\141\229\173\152\229\156\168"),
  already_in_room = T("\229\183\178\231\187\143\229\156\168\230\136\191\233\151\180\233\135\140\233\157\162\228\186\134,\228\184\141\232\131\189\229\136\155\229\187\186\230\136\150\232\191\155\229\133\165\230\136\191\233\151\180"),
  expire_realaren_room = T("\230\136\191\233\151\180\229\183\178\232\191\135\230\156\159"),
  not_enough_room = T("\230\136\191\233\151\180\230\139\165\230\140\164, \232\175\183\231\168\141\229\144\142\229\134\141\232\175\149"),
  version_not_match = T("\228\189\160\229\146\140\230\136\191\228\184\187\231\137\136\230\156\172\229\143\183\228\184\141\229\175\185\229\186\148"),
  room_in_battle = T("\230\136\191\233\151\180\229\183\178\231\187\143\229\175\185\230\136\152\228\184\173"),
  reach_max_point_match_count = T("\231\167\175\229\136\134\232\181\155\229\140\185\233\133\141\232\190\190\229\136\17620\230\172\161"),
  not_illegal_playoffs_stage = T("\229\189\147\229\137\141\233\157\158\231\167\175\229\136\134\232\181\155\229\140\185\233\133\141\233\152\182\230\174\181"),
  grade_already_rewarded = T("\230\174\181\228\189\141\229\165\150\229\138\177\229\183\178\233\162\134\229\143\150"),
  grade_not_reach = T("\232\191\152\230\178\161\232\190\190\229\136\176\232\175\165\230\174\181\228\189\141")
}
errList = error_string_list
local reSendType = {
  enterRoom = "enterRoom",
  selectReady = "selectReady",
  roundReset = "roundReset"
}

local function ResetScene()
  local scene = ed.getCurrentScene()
  if scene.identity == "KingsPvpBanPickScene" then
    ed.popScene()
  elseif scene.identity == "stageFailed" or scene.identity == "stagedone" then
    ed.popScene()
  elseif scene.identity == "battle" then
    ed.popScene()
  elseif scene.identity == "realarena" then
  end
end

local error_handler_list = {
  rival_conn_closed = function()
    FireEvent("RealPVPOpponentLost")
    network_mgr:CloseConnection()
  end,
  expire_challenge = function()
    local scene = ed.getCurrentScene()
    if scene.challenge_notify_window then
      scene.challenge_notify_window:Destroy()
    end
    ed.showToast(T("\229\175\185\230\136\152\233\130\128\232\175\183\229\183\178\231\187\143\232\191\135\230\156\159"))
  end,
  result_unknow = function()
    network_mgr:ReplyProtection()
  end,
  battle_past = function()
    ResetScene()
    FireEvent("RealArenaNetworkException")
    network_mgr:CloseConnection()
    ListenTimer(Timer:Once(0.03), function()
      ed.showToast(T("\231\148\177\228\186\142\228\189\160\231\154\132\231\189\145\231\187\156\228\184\141\231\168\179\229\174\154\239\188\140\229\189\147\229\137\141\230\175\148\232\181\155\229\183\178\231\187\147\230\157\159"))
    end, RealArenaMgrScope)
  end,
  self_poor_network = function()
    ResetScene()
    FireEvent("RealArenaNetworkException")
    network_mgr:CloseConnection()
    ListenTimer(Timer:Once(0.03), function()
      FireEvent("RealArenaMatchingCancelled")
      ed.showToast(T("\228\189\160\231\154\132\231\189\145\231\187\156\228\184\141\231\168\179\229\174\154\239\188\140\229\189\147\229\137\141\230\175\148\232\181\155\229\143\150\230\182\136"))
    end, RealArenaMgrScope)
  end,
  oppo_poor_network = function()
    ResetScene()
    FireEvent("RealArenaNetworkException")
    network_mgr:CloseConnection()
    ListenTimer(Timer:Once(0.03), function()
      FireEvent("RealArenaMatchingCancelled")
      ed.showToast(T("\229\175\185\230\150\185\231\154\132\231\189\145\231\187\156\228\184\141\231\168\179\229\174\154\239\188\140\229\189\147\229\137\141\230\175\148\232\181\155\229\143\150\230\182\136"))
    end, RealArenaMgrScope)
  end
}
errorHandlerList = error_handler_list

local function getIPPortFromString(str)
  if not str or str == "" then
    return
  end
  local svrid, ip, port = string.match(str, "(.-)#(.+):(.+)")
  if svrid and ip and port then
    return ip, port, svrid
  end
  local ip, port = string.match(str, "(.+):(.+)")
  return ip, port
end

reSendList = {}
reSendScope = {}
RealArenaScope = {}
RealArenaGlobeScope = {}
RealArenaReplyProtectionScope = {}
NetworkMgr = {}
NetworkMgr.__index = NetworkMgr

function NetworkMgr.Create()
  local network_mgr = {}
  network_mgr.what = "RealArenaNetworkMgr"
  setmetatable(network_mgr, NetworkMgr)
  network_mgr.lag = 0
  network_mgr.lag_oppo = 0
  network_mgr.isDebug = false
  network_mgr:RegisterGlobleEvents()
  network_mgr:RegisterEvents()
  return network_mgr
end

function NetworkMgr:Destroy()
  self:UnregisterEvents()
  self:UnregisterGlobeEvents()
  self:CloseConnection()
end

function NetworkMgr:RegisterGlobleEvents()
  ListenEvent("RealArenaRsp", function(msg)
    self:Dispatch(msg)
  end, RealArenaGlobeScope)
end

function NetworkMgr:UnregisterGlobeEvents()
  CloseScope(RealArenaGlobeScope)
end

function NetworkMgr:RegisterEvents()
  ListenEvent("RealPVPRsp", function(msg)
    self:DispatchBattleMsg(msg)
  end, RealArenaScope)
  ListenEvent("PVPSelectReady", function()
    self:SendPVPSelectReady()
  end, RealArenaScope)
  ListenEvent("PVPReady", function(heroes)
    self:SendPVPReady(heroes)
  end, RealArenaScope)
  ListenEvent("PVPSelectBegin", function()
    self:RequestHeroSelectBegin()
  end, RealArenaScope)
  ListenEvent("PVPRoundInitOver", function()
    self:SendRoundInitOver()
  end, RealArenaScope)
  ListenEvent("PVPSendRoundEnd", function(round, result, my_hero_dynas, oppo_hero_dynas)
    self:SendRoundEnd(round, result, my_hero_dynas, oppo_hero_dynas)
  end, RealArenaScope)
  ListenEvent("ReportRoundReset", function()
    self:SendRoundReset()
  end, RealArenaScope)
  ListenEvent("RealArenaCloseConnection", function()
    EDLog("RealArenaCloseConnection")
    self:CloseConnection()
  end, RealArenaScope)
end

function NetworkMgr:UnregisterEvents()
  CloseScope(RealArenaScope)
end

function NetworkMgr:OpenConnection(ip, port, block, svrid)
  if ip and port then
    self.is_connected = true
    self.ip = ip
    self.port = port
    self.svrid = svrid
    ed.socket_long_realarena.doConnection(ip, port, block, svrid)
  end
end

function NetworkMgr:CloseConnection()
  if self.is_connected then
    self.is_connected = false
    ed.socket_long_realarena.doCloseConnection()
  end
  if ed.socket_udp then
    ed.socket_udp:Destroy()
    ed.socket_udp = nil
  end
  if self.timer_heart_beat then
    CloseTimer(self.timer_heart_beat.Name)
    self.timer_heart_beat = nil
  end
  CloseScope(reSendScope)
  self.battle_room_ip, self.battle_room_port, self.battle_room_svrid = nil, nil, nil
end

function NetworkMgr:RequestOpenPanel()
  local msg = ed.upmsg.real_arena()
  msg._open_panel = ed.upmsg.real_arena_open_panel()
  self:sendRequest(msg)
end

function NetworkMgr:RequestMatch(type, rule)
  type = type or match_type[1]
  local msg = ed.upmsg.real_arena()
  msg._match = ed.upmsg.real_arena_match()
  msg._match._target_type = type
  msg._match._server_id = game_server_id or ""
  msg._match._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  if multi_definition then
    msg._match._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version-" .. ed.loadDefinition())
  end
  msg._match._pvp_rule = rule
  self:sendRequest(msg)
end

function NetworkMgr:RequestCancelMatch()
  local msg = ed.upmsg.real_arena()
  msg._cancel_match = ed.upmsg.real_arena_cancel_match()
  self:sendRequest(msg)
end

function NetworkMgr:RequestAchievement()
  local msg = ed.upmsg.real_arena()
  msg._request_achievement = ed.upmsg.real_arena_request_achievement()
  self:sendRequest(msg)
end

function NetworkMgr:RequestHero(hero_list)
  local msg = ed.upmsg.real_arena()
  msg._request_hero = ed.upmsg.real_arena_request_hero()
  msg._request_hero._heroes = hero_list
  self:sendRequest(msg)
end

function NetworkMgr:RequestRecord()
  local msg = ed.upmsg.real_arena()
  msg._request_record = ed.upmsg.real_arena_request_record()
  self:sendRequest(msg)
end

function NetworkMgr:RequestReplay(record_index, type, request_index)
  local msg = ed.upmsg.real_arena()
  msg._request_replay = ed.upmsg.real_arena_request_replay()
  msg._request_replay._record_index = record_index
  msg._request_replay._target_type = type
  msg._request_replay._replay_index = request_index or 0
  self:sendRequest(msg)
end

function NetworkMgr:RequestGuildInfo()
  local msg = ed.upmsg.real_arena()
  msg._request_guild = ed.upmsg.real_arena_request_guild()
  self:sendRequest(msg)
end

function NetworkMgr:RequestChallenge(request_data)
  local msg = ed.upmsg.real_arena()
  msg._request_challenge = ed.upmsg.real_arena_request_challenge()
  msg._request_challenge._type = request_data.type
  msg._request_challenge._user_id = request_data.target_id
  msg._request_challenge._server_id = request_data.target_server_id or game_server_id or ""
  msg._request_challenge._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  msg._request_challenge._pvp_rule = request_data.pvp_rule
  msg._request_challenge._say = request_data.say
  self:sendRequest(msg)
end

function NetworkMgr:CancelChallenge(type)
  local msg = ed.upmsg.real_arena()
  msg._cancel_challenge = ed.upmsg.real_arena_cancel_challenge()
  msg._cancel_challenge._type = type
  self:sendRequest(msg)
end

function NetworkMgr:ReplyChallenge(is_accepted, challenge_type, uid, server_id, pvp_rule)
  local msg = ed.upmsg.real_arena()
  msg._challenge_reply = ed.upmsg.real_arena_challenge_reply()
  msg._challenge_reply._result = is_accepted and 1 or 0
  msg._challenge_reply._type = challenge_type
  msg._challenge_reply._oppo_id = tonumber(uid)
  msg._challenge_reply._server_id = server_id
  msg._challenge_reply._pvp_rule = pvp_rule
  self:sendRequest(msg)
end

function NetworkMgr:RequestBattleResult(room_id)
  local msg = ed.upmsg.real_arena()
  msg._request_battle_result = ed.upmsg.real_arena_request_battle_result()
  msg._request_battle_result._room_id = room_id
  self:sendRequest(msg)
end

function NetworkMgr:Ping()
  local msg = ed.upmsg.real_arena()
  msg._check_network = ed.upmsg.real_arena_check_network()
  msg._check_network._time_ping = ed.getServerMillionTime() * 1000
  self:sendRequest(msg)
end

function NetworkMgr:CheckLag(ping_time)
  local ping_delta = math.floor(ed.getServerMillionTime() * 1000) - ping_time
  if ping_delta > lag_tolerance then
    FireEvent("RealArenaLag", ping_delta)
  end
end

function NetworkMgr:SetLag(lag)
  self.lag = lag or self.lag
end

function NetworkMgr:GetLag()
  return self.lag
end

function NetworkMgr.LagStatus(lag)
  for i, status_data in ipairs(lag_status) do
    if lag <= status_data.ceiling then
      return status_data.status
    end
  end
end

function NetworkMgr:GetLagStatus()
  return NetworkMgr.LagStatus(self.lag)
end

function NetworkMgr:SetOppoLag(lag)
  self.lag_oppo = lag or self.lag_oppo
end

function NetworkMgr:GetOppoLag()
  return self.lag_oppo
end

function NetworkMgr:GetOppoLagStatus()
  return NetworkMgr.LagStatus(self.lag_oppo)
end

function NetworkMgr:CheckConnectionStatus()
  if self.lag > lag_tolerance then
    return false
  end
  return true
end

function NetworkMgr:SetNeedReply()
  self.flag_need_reply = true
end

function NetworkMgr:ClearNeedReply()
  CloseScope(RealArenaReplyProtectionScope)
  self.flag_need_reply = false
  if self.timer_replyProtection then
    CloseTimer(self.timer_replyProtection.Name)
    self.timer_replyProtection = nil
  end
end

function NetworkMgr:IsNeedReply()
  return self.flag_need_reply
end

function NetworkMgr:ExceptionHandler(msg)
  EDLog("ExceptionHandler: " .. msg.exceptionType)
  local request_result_delay_time = 2
  if msg.exceptionType == "default" and self.battle_room_id then
    self:RequestBattleResult(self.battle_room_id)
  elseif msg.exceptionType == "beforeHeroSelect" and self.battle_room_id then
    FireEvent("RealArenaMatchingCancelled")
    ed.showToast(T("\232\191\155\229\133\165\232\175\184\231\142\139\228\186\137\233\156\184\229\175\185\230\136\152\230\136\191\233\151\180\229\164\177\232\180\165\239\188\140\232\175\183\231\168\141\229\144\142\233\135\141\230\150\176\229\140\185\233\133\141"))
    ListenTimer(Timer:Once(request_result_delay_time), function()
      self:RequestBattleResult(self.battle_room_id)
    end)
  elseif msg.exceptionType == "noRoundEndReply" then
    if ed.realarena.battle_rule == rule_map[1] or ed.realarena.battle_rule == rule_map[3] then
      self:RequestBattleResult(self.battle_room_id)
    else
      self:CloseConnection()
      ed.showToast(T("\231\189\145\231\187\156\228\184\141\231\168\179\229\174\154\239\188\140\232\175\183\231\168\141\229\144\142\229\156\168\230\136\152\230\150\151\232\174\176\229\189\149\228\184\173\230\159\165\231\156\139\231\187\147\230\158\156"))
      ListenTimer(Timer:Once(request_result_delay_time), function()
        ed.popScene()
      end)
    end
  else
    FireEvent("RealArenaNetworkException")
    self:CloseConnection()
  end
end

function NetworkMgr:ReplyProtection(msg)
  self:ClearNeedReply()
  self:SetNeedReply()
  msg = msg or {}
  msg.time_timeout = msg.time_timeout or default_time_timeout
  msg.exceptionType = msg.exceptionType or "default"
  self.timer_replyProtection = Timer:Once(msg.time_timeout)
  ListenTimer(self.timer_replyProtection, function()
    if self:IsNeedReply() then
      self:ExceptionHandler(msg)
    end
  end, RealArenaReplyProtectionScope)
end

function NetworkMgr:RequestEnterRoom()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_enter_room = ed.upmsg.pvp_enter_room()
  msg._pvp_enter_room._device_id = self.battle_device_id
  msg._pvp_enter_room._server_id = game_server_id or ""
  msg._pvp_enter_room._udp_port = ed.udp_port_client
  msg._pvp_enter_room._data_md5 = ""
  ed.socket_long_realarena.send(msg, "real_pvp")
  self:ReplyProtection()
end

function NetworkMgr:DoEnterRoom(ip, port, svrid)
  if self.is_connected then
    self.is_connected = false
    ed.socket_long_realarena.doCloseConnection()
  end
  if ed.socket_udp then
    ed.socket_udp:Destroy()
    ed.socket_udp = nil
  end
  if self.timer_heart_beat then
    CloseTimer(self.timer_heart_beat.Name)
    self.timer_heart_beat = nil
  end
  CloseScope(reSendScope)
  self.battle_room_ip, self.battle_room_port = ip or self.battle_room_ip, port or self.battle_room_port
  self.battle_room_svrid = svrid or self.battle_room_svrid
  self:OpenConnection(self.battle_room_ip, self.battle_room_port, true, self.battle_room_svrid)
  ed.socket_udp = ed.SocketUdp.Create(self.ip)
  ed.socket_udp:setSvrid(self.svrid)
  self:RequestEnterRoom()
  self:reSend(reSendType.enterRoom, reSendTimeout)
  self:SendHeartbeat()
  self.timer_heart_beat = ListenTimer(Timer:Always(ed.socket_long_realarena.heart_beat_interval), function()
    self:SendHeartbeat()
  end)
end

function NetworkMgr:reSend(type, timeout)
  if reSendList[type] then
    self:closeResend(type)
  end
  local timeEvent = ListenTimer(Timer:Once(timeout), function()
    self:doReSend(type)
  end, reSendScope)
  reSendList[type] = timeEvent
end

function NetworkMgr:doReSend(type)
  if type == reSendType.enterRoom then
    self:RequestEnterRoom("resend")
    reSendList[type] = nil
  elseif type == reSendType.selectReady then
    self:doSendPvpSelectReady()
    reSendList[type] = nil
  elseif type == reSendType.roundReset then
    self:doSendRoundReset()
    reSendList[type] = nil
  end
end

function NetworkMgr:closeResend(type)
  local timeEvent = reSendList[type]
  if timeEvent then
    CloseTimer(timeEvent.Name)
    reSendList[type] = nil
  end
end

function NetworkMgr:DoEnterDirectRoom(msg)
  self.battle_room_ip, self.battle_room_port, self.battle_room_svrid = getIPPortFromString(msg._room_addr)
  self.battle_room_id = msg._room_id
  self.battle_device_id = msg._device_id
  ed.my_device_id = self.battle_device_id
  self:DoEnterRoom()
end

function NetworkMgr:NotifyOppoFound(pvpEnterRoomReply)
  local roomPlayerInfo
  if pvpEnterRoomReply then
    roomPlayerInfo = {
      hostInfo = pvpEnterRoomReply._host_info,
      guestInfo = pvpEnterRoomReply._guest_info
    }
  end
  self.roomPlayerInfo = roomPlayerInfo or self.roomPlayerInfo
  if self.roomPlayerInfo then
    FireEvent("RealArenaOppoFound", self.roomPlayerInfo)
  end
  self.roomPlayerInfo = nil
end

function NetworkMgr:SendPVPSelectReady()
  self:doSendPvpSelectReady()
  self:reSend(reSendType.selectReady, reSendTimeout)
end

function NetworkMgr:doSendPvpSelectReady()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_select_ready = {}
  msg._pvp_select_ready._device_id = ed.my_device_id
  ed.socket_long_realarena.send(msg, "real_pvp")
  self:ReplyProtection({
    time_timeout = default_time_timeout,
    exceptionType = "beforeHeroSelect"
  })
end

function NetworkMgr:RequestHeroSelectBegin()
  local msg = ed.upmsg.real_pvp()
  msg._hero_select_begin = {}
  ed.socket_long_realarena.send(msg, "real_pvp")
  self:ReplyProtection({
    time_timeout = default_time_timeout,
    exceptionType = "beforeHeroSelect"
  })
end

function NetworkMgr:SendHeroSelect(hero_id)
  local msg = ed.upmsg.real_pvp()
  msg._hero_select = ed.upmsg.hero_select()
  msg._hero_select._device_id = ed.my_device_id
  msg._hero_select._hero_selected = hero_id
  ed.socket_long_realarena.send(msg, "real_pvp")
end

function NetworkMgr:SendHeroDeselect(hero_id)
  local msg = ed.upmsg.real_pvp()
  msg._hero_deselect = ed.upmsg.hero_deselect()
  msg._hero_deselect._device_id = ed.my_device_id
  msg._hero_deselect._hero_deselected = hero_id
  ed.socket_long_realarena.send(msg, "real_pvp")
end

function NetworkMgr:SendPVPReady(heroIdList)
  local msg = ed.upmsg.real_pvp()
  msg._pvp_ready = ed.upmsg.pvp_ready()
  print("ed.my_device_id ", ed.my_device_id)
  msg._pvp_ready._device_id = ed.my_device_id
  msg._pvp_ready._self_heroes = heroIdList
  ed.socket_long_realarena.send(msg, "real_pvp")
  self:ReplyProtection()
end

function NetworkMgr:SendRoundEnd(round, result, my_hero_dynas, oppo_hero_dynas)
  local msg = ed.upmsg.real_pvp()
  msg._round_end = ed.upmsg.pvp_round_end()
  msg._round_end._device_id = ed.my_device_id
  msg._round_end._cur_round = round
  msg._round_end._result = result
  ed.socket_long_realarena.send(msg, "real_pvp")
  local replyProtectionPara = {}
  replyProtectionPara.time_timeout = 20
  replyProtectionPara.exceptionType = "noRoundEndReply"
  replyProtectionPara.round = round
  replyProtectionPara.result = result
  replyProtectionPara.my_hero_dynas = my_hero_dynas
  replyProtectionPara.oppo_hero_dynas = oppo_hero_dynas
  self:ReplyProtection(replyProtectionPara)
end

function NetworkMgr:SendHeartbeat()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_heart = ed.upmsg.pvp_heart()
  msg._pvp_heart._device_id = ed.my_device_id
  msg._pvp_heart._my_lag = self.lag
  ed.socket_long_realarena.send(msg, "real_pvp")
  self:addHeartCount()
end

function NetworkMgr:SendRoundReset()
  self:doSendRoundReset()
  self:reSend(reSendType.roundReset, reSendTimeout)
end

function NetworkMgr:doSendRoundReset()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_round_reset = ed.upmsg.pvp_round_reset()
  msg._pvp_round_reset._device_id = ed.my_device_id
  ed.socket_long_realarena.send(msg, "real_pvp")
end

function NetworkMgr:SendRoundInitOver()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_round_init_over = ed.upmsg.pvp_round_init_over()
  msg._pvp_round_init_over._device_id = ed.my_device_id
  ed.socket_long_realarena.send(msg, "real_pvp")
  self:ReplyProtection({time_timeout = 10})
end

function NetworkMgr:ErrorCodeHandler(err_code)
  local error_handler = error_handler_list[err_code]
  if error_handler then
    error_handler()
  else
    local error_string = error_string_list[err_code]
    ed.showToast(error_string or err_code)
  end
end

function NetworkMgr:Dispatch(msg)
  if self.isDebug then
    print("=============kingsPvp dispatch================")
    ed.pt(msg)
  end
  if msg._err_code then
    self:ClearNeedReply()
    self:ErrorCodeHandler(msg._err_code)
    local battleWindow = ed.ui.realArena.battleWindow
    if msg._err_code == "room_not_exsits" and battleWindow and (battleWindow.what == "myHouse" or battleWindow.what == "battleinfo") then
      ed.ui.realArena:closeBattleWindow()
    end
  end
  if msg._open_panel then
    local public_hero_ids = {}
    local public_hero = msg._open_panel._public_hero
    for i, hero_id in ipairs(public_hero and public_hero._heroes or {}) do
      if hero_id and 0 < hero_id then
        table.insert(public_hero_ids, hero_id)
      end
    end
    hero_mgr = HeroMgr.Create(public_hero_ids, msg._open_panel._level_rank, public_hero._legend_equips)
    hero_mgr:setFreeTime(public_hero._start_time, public_hero._end_time)
    mgr:Init(msg._open_panel)
    ed.pushScene(ed.ui.realArena.create())
    self:RequestHero(hero_mgr:GetHeroIDList())
    if self.roomPlayerInfo then
      mgr.match_type = match_type[2]
      ListenTimer(Timer:Once(0.05), function()
        self:DoEnterRoom()
        self:NotifyOppoFound()
      end, RealArenaGlobeScope)
    end
  elseif msg._check_network then
    self:CheckLag(msg._check_network._time_ping)
  elseif msg._match_reply then
    if msg._match_reply._result == "success" then
      FireEvent("RealArenaMatching")
    else
      FireEvent("RealArenaMatchingError")
      self:ErrorCodeHandler(msg._match_reply._err_code)
    end
  elseif msg._match_result then
    if msg._match_result._result == "success" then
      local ip, port, svrid = getIPPortFromString(msg._match_result._room_addr)
      self.battle_room_id = msg._match_result._room_id
      self.battle_device_id = msg._match_result._device_id
      ed.my_device_id = self.battle_device_id
      self:DoEnterRoom(ip, port, svrid)
    else
      FireEvent("RealArenaOppoNotFound")
    end
  elseif msg._cancel_match_result then
    if msg._cancel_match_result._result == "success" then
      FireEvent("RealArenaMatchingCancelled")
    else
      FireEvent("RealArenaMatchingCancelFailed")
    end
  elseif msg._achievement then
    FireEvent("RealArenaAchievementUpdate", msg._achievement)
  elseif msg._battle_result then
    self:ClearNeedReply()
    FireEvent("RealArenaBattleResult", msg._battle_result)
  elseif msg._record_info then
    FireEvent("RealArenaRecordInfo", msg._record_info._records)
  elseif msg._replay_info then
    FireEvent("RealArenaReplayInfo", msg._replay_info)
  elseif msg._hero_info_list then
    FireEvent("RealArenaHeroInfo", msg._hero_info_list._hero_infos)
  elseif msg._guild_info then
    FireEvent("RealArenaGuildInfo", msg._guild_info._guild_members)
  elseif msg._challenge_reply then
    if msg._challenge_reply._result == "success" then
      FireEvent("RealArenaChallenging", msg._challenge_reply._valid_time)
    else
      self:ErrorCodeHandler(msg._challenge_reply._err_code)
    end
  elseif msg._cancel_result then
    if msg._cancel_result._result == "success" then
      FireEvent("RealArenaChallengeCancelled")
    else
      FireEvent("RealArenaChallengeCancelled")
    end
  elseif msg._challenge_notify then
    FireEvent("RealArenaChallengeNotify", msg._challenge_notify)
  elseif msg._challenge_result then
    if msg._challenge_result._result == "success" then
      self.battle_room_ip, self.battle_room_port, self.battle_room_svrid = getIPPortFromString(msg._challenge_result._room_addr)
      self.battle_room_id = msg._challenge_result._room_id
      self.battle_device_id = msg._challenge_result._device_id
      ed.my_device_id = self.battle_device_id
      FireEvent("RealArenaChallengeAccepted")
    else
      FireEvent("RealArenaChallengeRefused")
    end
  elseif msg._open_task_panel then
    if ed.ui.realArena:isFinishBattleTaskInfo() then
      FireEvent("RealArenaFinishBattle", msg._open_task_panel._tasks)
    else
      FireEvent("RealArenaOpenTaskPanel", msg._open_task_panel._tasks)
    end
  elseif msg._open_shop_panel then
    FireEvent("RealArenaOpenGoodsPanel", msg._open_shop_panel._points, msg._open_shop_panel._goods)
  elseif msg._buy_goods then
    if msg._buy_goods._result == "success" then
      FireEvent("RealArenaBuyGoods", msg._buy_goods._next_price)
    elseif msg._buy_goods._err_code == "point_not_enough" then
      ed.showToast(T("\230\178\161\230\156\137\232\182\179\229\164\159\231\154\132\231\142\139\232\128\133\229\190\189\232\174\176"))
    else
      self:ErrorCodeHandler(msg._buy_goods._err_code)
    end
  elseif msg._job_rewards then
    if msg._job_rewards._result == "success" then
      FireEvent("RealArenaJobReward")
    end
  elseif msg._room then
    FireEvent("BattleHouseInfo", msg._room)
  elseif msg._team_reply then
    local result = msg._team_reply._result
  elseif msg._query_local_rank then
    FireEvent("LocalRankEvent", msg._query_local_rank)
  elseif msg._grade_rewards then
    FireEvent("RealArenaGradeReward", msg._grade_rewards)
  elseif msg._team_notify then
    local deviceId = msg._team_notify._device_id
    local ip, port, svrid = getIPPortFromString(msg._team_notify._room_addr)
    self.battle_room_id = msg._team_notify._room_id
    self.battle_device_id = deviceId
    ed.my_device_id = deviceId
    ed.realarena.mgr.match_rule = msg._team_notify._pvp_rule
    ed.realarena.mgr.match_type = "casual"
    self:DoEnterRoom(ip, port, svrid)
  end
end

function NetworkMgr:DispatchBattleMsg(msg)
  if self.isDebug then
    print("==========DispatchBattleMsg==============")
    ed.pt(msg)
  end
  if msg._err_code then
    self:ClearNeedReply()
    self:ErrorCodeHandler(msg._err_code)
  end
  if msg._pvp_new_round_start then
    self:ClearNeedReply()
    FireEvent("RealPVPStart", msg._pvp_new_round_start)
  end
  if msg._hero_select_opponent then
    FireEvent("RealPVPOpponentHeroSelect", msg._hero_select_opponent)
  end
  if msg._hero_deselect_opponent then
    FireEvent("RealPVPOpponentHeroDeselect", msg._hero_deselect_opponent)
  end
  if msg._hero_select_round_end_reply then
    self:ClearNeedReply()
    FireEvent("RealPVPHeroSelectRoundEndReply", msg._hero_select_round_end_reply)
  end
  if msg._battle_start_countdown then
    self:ClearNeedReply()
    FireEvent("RealPVPBattleStartCountdown", msg._battle_start_countdown)
  end
  if msg._round_end_reply then
    self:ClearNeedReply()
    FireEvent("RealPVPBattleRoundEndReply", msg._round_end_reply)
  end
  if msg._pvp_round_reset then
    self:closeResend(reSendType.roundReset)
    self:ClearNeedReply()
    FireEvent("RealPVPRoundReset")
  end
  if msg._pvp_enter_room_reply then
    self:closeResend(reSendType.enterRoom)
    self:ClearNeedReply()
    if mgr.match_type == match_type[3] or mgr.match_type == match_type[4] then
      ed.realarena.roomPlayerInfo = {
        hostInfo = msg._pvp_enter_room_reply._host_info,
        guestInfo = msg._pvp_enter_room_reply._guest_info
      }
    else
      self:NotifyOppoFound(msg._pvp_enter_room_reply)
    end
    FireEvent("RealPVPEnterRoomReply", msg._pvp_enter_room_reply)
  end
  if msg._pvp_select_ready_reply then
    self:ClearNeedReply()
    self:closeResend(reSendType.selectReady)
    FireEvent("RealPVPHeroSelectBegin", msg._pvp_select_ready_reply)
  end
  if msg._pvp_chat_msg_reply then
    FireEvent("RealPVPChatReply", msg._pvp_chat_msg_reply)
  end
  if msg._pvp_heart_resp then
    self:resetHeartCount()
  end
  if msg._reconnect_msg_reply then
    self:doReconnectReplay(msg._reconnect_msg_reply)
  end
  if msg._pvp_ban_notify then
    FireEvent("RealPvpBan", msg._pvp_ban_notify)
  end
  if msg._pvp_pick_notify then
    FireEvent("RealPvpPick", msg._pvp_pick_notify)
  end
  if msg._pvp_bp_begin_notify then
    self:ClearNeedReply()
    FireEvent("RealPvpBPBegin", msg._pvp_bp_begin_notify)
  end
  if msg._pvp_bp_end_notify then
    self:ClearNeedReply()
    FireEvent("RealPvpBPEnd", msg._pvp_bp_end_notify)
  end
end

function NetworkMgr:resetHeartCount()
  self.notReceveCount = 0
end

function NetworkMgr:doReconnectReplay(msg)
  if msg._bp_info then
    FireEvent("RealPvpReconnectReply", msg._bp_info)
  end
end

function NetworkMgr:addHeartCount()
  self.notReceveCount = self.notReceveCount or 0
  self.notReceveCount = self.notReceveCount + 1
  if self.notReceveCount >= 3 then
    self:OpenConnection(self.battle_room_ip, self.battle_room_port, true, self.battle_room_svrid)
    self.notReceveCount = 1
    self:requestReconnect()
  end
end

function NetworkMgr:requestReconnect()
  local msg = ed.upmsg.real_pvp()
  msg._reconnect_msg = ed.upmsg.reconnect_msg()
  msg._reconnect_msg._device_id = ed.my_device_id
  ed.socket_long_realarena.send(msg, "real_pvp")
end

function NetworkMgr:RequestOpenTaskPanel(isFBTaskInfo)
  ed.ui.realArena:setFinishBattleTaskInfo(isFBTaskInfo)
  local msg = ed.upmsg.real_arena()
  msg._open_task_panel = ed.upmsg.real_arena_open_task_panel()
  self:sendRequest(msg)
end

function NetworkMgr:RequestOpenShopPanel()
  local msg = ed.upmsg.real_arena()
  msg._open_shop_panel = ed.upmsg.real_arena_open_shop_panel()
  self:sendRequest(msg)
end

function NetworkMgr:RequestBuyGoods(type, id)
  local msg = ed.upmsg.real_arena()
  msg._buy_goods = ed.upmsg.real_arena_buy_goods()
  msg._buy_goods._hero_id = id
  msg._buy_goods._type = type
  self:sendRequest(msg)
end

function NetworkMgr:RequestJobRewards(id)
  local msg = ed.upmsg.real_arena()
  msg._job_rewards = ed.upmsg.real_arena_job_rewards()
  msg._job_rewards._job_id = id
  self:sendRequest(msg)
end

function NetworkMgr:RequestCreateHouse(match_rule)
  local msg = ed.upmsg.real_arena()
  msg._room = ed.upmsg.real_arena_room()
  msg._room._create_room = ed.upmsg.real_arena_room_create()
  msg._room._create_room._pvp_rule = match_rule
  msg._room._create_room._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  if multi_definition then
    msg._room._create_room._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version-" .. ed.loadDefinition())
  end
  self:sendRequest(msg)
end

function NetworkMgr:RequestEnterHouse(houseNumber)
  local msg = ed.upmsg.real_arena()
  msg._room = ed.upmsg.real_arena_room()
  msg._room._enter_room = ed.upmsg.real_arena_room_enter()
  msg._room._enter_room._room_id = tonumber(houseNumber)
  msg._room._enter_room._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  if multi_definition then
    msg._room._enter_room._version = CCUserDefault:sharedUserDefault():getStringForKey("current-version-" .. ed.loadDefinition())
  end
  self:sendRequest(msg)
end

function NetworkMgr:RequestExitHouse()
  local msg = ed.upmsg.real_arena()
  msg._room = ed.upmsg.real_arena_room()
  msg._room._cancel = ed.upmsg.real_arena_room_cancel()
  self:sendRequest(msg)
end

function NetworkMgr:RequestReadyHouse()
  local msg = ed.upmsg.real_arena()
  msg._room = ed.upmsg.real_arena_room()
  msg._room._ready = ed.upmsg.real_arena_room_ready()
  self:sendRequest(msg)
end

function NetworkMgr:RequestReconnectHouse()
  local msg = ed.upmsg.real_arena()
  msg._room = ed.upmsg.real_arena_room()
  msg._room._reconnect = ed.upmsg.real_arena_room_reconnect()
  self:sendRequest(msg)
end

function NetworkMgr:RequestPvpChat(text)
  local msg = ed.upmsg.real_pvp()
  msg._pvp_chat_msg = ed.upmsg.pvp_chat_msg()
  msg._pvp_chat_msg._device_id = ed.my_device_id
  msg._pvp_chat_msg._chat_data = text
  ed.socket_long_realarena.send(msg, "real_pvp")
  FireEvent("RealPVPChatReply", {
    _result = "success",
    _device_id = ed.my_device_id,
    _role_id = ed.getRoleId(),
    _chat_data = text
  })
end

function NetworkMgr:RequestLocalRank()
  local msg = ed.upmsg.real_arena()
  msg._query_local_rank = ed.upmsg.real_arena_query_local_rank()
  self:sendRequest(msg)
end

function NetworkMgr:RequestPvpBan(hero_ids)
  local msg = ed.upmsg.real_arena()
  msg._pvp_ban = ed.upmsg.pvp_ban()
  msg._pvp_ban._device_id = ed.my_device_id
  msg._pvp_ban._hero_ids = hero_ids
  self:sendRequest(msg)
end

function NetworkMgr:RequestPvpPick(hero_ids)
  local msg = ed.upmsg.real_arena()
  msg._pvp_pick = ed.upmsg.pvp_pick()
  msg._pvp_pick._device_id = ed.my_device_id
  msg._pvp_pick._hero_ids = hero_ids
  self:sendRequest(msg)
end

function NetworkMgr:RequestTeamStart()
  local msg = ed.upmsg.real_arena()
  msg._team = {}
  self:sendRequest(msg)
end

function NetworkMgr:RequestGradeReward(gradeId)
  local msg = ed.upmsg.real_arena()
  msg._grade_rewards = {}
  msg._grade_rewards._grade_id = gradeId
  self:sendRequest(msg)
end

function NetworkMgr:sendRequest(msg)
  if self.isDebug then
    print("=========kingsPvp sendRequest============")
    ed.pt(msg)
  end
  ed.send(msg, "real_arena")
end

ed.realarena.network_mgr = ed.realarena.NetworkMgr.Create()
