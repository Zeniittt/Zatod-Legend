local ed = ed
require("lua_socket")
require("config")
require("mycrypto")
local userData = {}
local isFirst = true
local up = ed.upmsg
local down = ed.downmsg
local upmsg = up.up_msg
local downmsg = down.down_msg
local insert = table.insert
local ipairs = ipairs
local up_code
ed.connect_timeout = ed.connect_timeout or 5
local netSequence = 0
local cryptkey = "182173557"
local l_chat_game_server_ip = "101.251.105.8"
local l_chat_game_server_port = "10003"
local scope = {
  aliveScope = {},
  register = {},
  reconnectScope = {}
}
local timer = {aliveTimer = 0, aliveNum = 0}
local connect = socket.connect
local connection
local connect_succ = false
local isConnected = false
local close, err
local useUDP = false
local bSendblock = false
local currentMsg, currentMsgType
local totalConnectTime = 0
local totalSendCount = 0
local current_million_time = 0

local function debugPrint()
end

local socket_long_connection = {
  getNetSequence = function()
    return netSequence
  end,
  setNetSequence = function(sequence)
    netSequence = sequence
  end,
  getCryptkey = function()
    return cryptkey
  end,
  setCryptkey = function(newCryptKey)
    cryptkey = newCryptKey
  end,
  getScope = function()
    return scope
  end,
  getTimer = function()
    return timer
  end,
  getConnection = function()
    return connection
  end,
  setConnection = function(newConnection)
    connection = newConnection
  end,
  getConnectSuccFlag = function()
    return connect_succ
  end,
  setConnectSuccFlag = function(flag)
    connect_succ = flag
  end,
  getIsConnectedFlag = function()
    return isConnected
  end,
  setIsConnectedFlag = function(flag)
    isConnected = flag
  end,
  getCurrentMsg = function()
    return currentMsg
  end,
  setCurrentMsg = function(msg)
    currentMsg = msg
  end,
  getUpCode = function()
    return up_code
  end,
  setUpCode = function(newUpCode)
    up_code = newUpCode
  end,
  getErr = function()
    return err
  end,
  setErr = function(newErr)
    err = newErr
  end,
  getUseUDPFlag = function()
    return useUDP
  end,
  setUseUDPFlag = function(flag)
    useUDP = flag
  end,
  defaultUDPTimeOut = 0.01,
  UDPAddress = {}
}

local function reregister()
  socket_long_connection.close()
  ed.socket_long_connection.register()
end

socket_long_connection.reregister = reregister

local function registerSuccess()
  CloseScope(scope.reconnectScope)
  CloseScope(scope.aliveScope)
  timer.aliveNum = 0
  EnqueueDelayProcess(function()
    ListenTimer(Timer:Always(6), ed.socket_long_connection.keepalive, scope.aliveScope)
  end)
end

function socket_long_connection.udpRegisterSuccess()
  CloseScope(scope.aliveScope)
  timer.aliveNum = 0
  EnqueueDelayProcess(function()
    ListenTimer(Timer:Always(6), ed.socket_long_connection.keepalive, scope.aliveScope)
  end)
end

local function tyrReregister()
  if connection then
    local ret, err = connection:receive(2)
    if err == "closed" then
      socket_long_connection.reregister()
    end
  end
end

socket_long_connection.tyrReregister = tyrReregister

local function keepalive()
  if not useUDP and timer.aliveNum >= 3 then
    socket_long_connection.reregister()
    return
  end
  timer.aliveNum = timer.aliveNum + 1
  local up_msg = ed.upmsg.realtime_notify()
  up_msg._rtnotify_keepalive = ed.upmsg.rtnotify_keepalive()
  up_msg._rtnotify_keepalive._iuserid = ed.getUserid()
  up_msg._rtnotify_keepalive._sign = mycrypto.encrypt("whoami", ed.getCryptKey())
  up_msg._rtnotify_keepalive._time = ed.getServerTime()
  ed.socket_long_connection.send(up_msg, "realtime_notify")
  current_million_time = ed.getTime().million
end

socket_long_connection.keepalive = keepalive

local function register()
  if not ed.getUserid() then
    return
  end
  if ed.has_force_quit_notify then
    return
  end
  debugPrint("+++++++register$$$$$$$")
  if ed.socket_long_connection.doConnection() then
    debugPrint("+++++++register realtime_notify$$$$$$$")
    local up_msg = ed.upmsg.realtime_notify()
    up_msg._rtnotify_register = {}
    up_msg._rtnotify_register._iuserid = ed.getUserid()
    up_msg._rtnotify_register._sign = mycrypto.encrypt("whoami", ed.getCryptKey())
    ed.socket_long_connection.send(up_msg, "realtime_notify")
    if useUDP then
      socket_long_connection.udpRegisterSuccess()
    else
      ListenTimer(Timer:Once(5), reregister, scope.reconnectScope)
    end
  end
end

socket_long_connection.register = register

local function dispatch(msg)
  for k, v in pairs(msg[".data"]) do
  end
  if msg._chat_reply then
    FireEvent("ChatRsp", msg._chat_reply)
  end
  if msg._realtime_notify_reply then
    local data = msg._realtime_notify_reply
    FireEvent("connectReply", data)
  end
  if msg._notify_msg then
    local data = msg._notify_msg
    if data._chat_msg_notify then
      ed.chatNetWork:dispatch_notify(data)
    end
    if data._new_friend then
      ed.chatNetDataMrg:otherPartyAgressToFriend(data._new_friend)
    end
    if data._del_friend then
      ed.ui.chatMain.getInstace():delFriend({
        roleId = data._del_friend._role_id
      })
    end
    if data._exit_member_info then
      ed.ui.chatMain.getInstace():exitRoomMember(data._exit_member_info)
    end
    if data._new_apply then
      local chatContactUser = data._new_apply
      local roleId = chatContactUser._role_id
      if ed.applyFriend.IsinApplyFriendList(roleId) then
        return
      end
      table.insert(ed.chatNetDataMrg.applyFriendList, chatContactUser)
      ed.applyFriend.addApplyFriend(roleId)
    end
    if data._server_maintain_notify then
      ed.showAlertDialog({
        text = T("\230\184\184\230\136\143\230\156\141\229\138\161\229\153\168\230\173\163\229\156\168\231\187\180\230\138\164\228\184\173"),
        buttonText = T("\233\128\128\229\135\186"),
        handler = function()
          os.exit()
        end
      })
    end
    if data._force_quit_notify then
      ed.has_force_quit_notify = true
      ed.showAlertDialog({
        text = T("\232\180\166\229\143\183\229\183\178\229\156\168\229\133\182\228\187\150\232\174\190\229\164\135\231\153\187\229\189\149"),
        buttonText = T("\233\128\128\229\135\186"),
        handler = function()
          os.exit()
        end
      })
    end
  end
  if msg._lantern_reply then
    FireEvent("lantern_event", msg._lantern_reply)
  end
  if msg._svr_time then
    ed.Net.getInstance():svr_time(msg)
  end
  if msg._chess_reply then
    ed.AutoChessNetwork:dispatchChessReply(msg._chess_reply)
  end
  if msg._chess_game_notify then
    ed.AutoChessNetwork:dispatchChessNotify(msg._chess_game_notify)
  end
  if msg._solo_reply then
    ed.SoloNetwork:dispatchChessReply(msg._solo_reply)
  end
  if msg._solo_game_notify then
    ed.SoloNetwork:dispatchChessNotify(msg._solo_game_notify)
  end
  if msg._dap_report_notify then
    local data = msg._dap_report_notify
    local event = data._event
    local param1 = data._param1
    if ed.isElementInTable(event, ed.reportEventConfig) then
      print("EDReportEvent:", data)
      if EDReportEvent then
        EDReportEvent(event, param1 or "")
      end
    end
  end
  if msg._real_arena_reply then
    FireEvent("RealArenaRsp", msg._real_arena_reply)
  end
end

socket_long_connection.dispatch = dispatch

local function socketError(errcode)
  if errcode == "succeed" then
  else
  end
end

socket_long_connection.socketError = socketError

function close()
  if connection then
    connection:close()
  end
  connection = nil
  connect_succ = false
  up_code = nil
  totalSendCount = 0
end

socket_long_connection.close = close

local function isSocketConnected()
  return connect_succ
end

socket_long_connection.isSocketConnected = isSocketConnected

local function setConnectionOption()
  socketError("succeed")
  connection:setoption("keepalive", true)
  local ret = connection:setoption("tcp-nodelay", true)
  if ret == 1 then
  end
end

socket_long_connection.setConnectionOption = setConnectionOption

local function doTcpConnect(ip, port, block)
  if not ip or not port then
    return
  end
  isConnected = true
  connection, err = socket.tcp()
  if not connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  connection:settimeout(block and ed.connect_timeout or 0)
  local err
  connect_succ, err = connection:connect(ip, port)
  if connect_succ then
    connection:settimeout(0)
    setConnectionOption()
    return true
  end
  if not block then
    return true
  end
  return false
end

socket_long_connection.doTcpConnect = doTcpConnect

function socket_long_connection.doUdpConnect(ip, port)
  debugPrint("+++++++doUdpConnect$$$$$$$", ip, port)
  if not ip or not port then
    return
  end
  socket_long_connection.UDPAddress.ip = ip
  socket_long_connection.UDPAddress.port = port
  isConnected = true
  connection, err = socket.udp()
  if not connection then
    EDLog(string.format("ERROR | socket_long_connection.doUdpConnect failed! | %s", tostring(err)))
    return false
  end
  connection:settimeout(socket_long_connection.defaultUDPTimeOut)
  connection:setsockname("*", 0)
  local udp_ip_client, udp_port_client = connection:getsockname()
  EDLog("udp_ip_client:" .. tostring(udp_ip_client) .. " udp_port_client:" .. tostring(udp_port_client))
  return true
end

local function connect_resume()
  if connect_succ or not connection then
    return
  end
  local r, w, e = socket.select({connection}, {connection}, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = connection:connect(l_chat_game_server_ip, l_chat_game_server_port)
  if errstr ~= "already connected" then
    return
  end
  connect_succ = true
  setConnectionOption()
  if up_code == nil then
    return
  else
    local r1, r2 = connection:send(up_code)
    if not r1 then
      socket_long_connection.close()
      return
    else
    end
  end
end

socket_long_connection.connect_resume = connect_resume

local function recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = connection:receive(size_left)
  if err == "closed" then
    socketError("closed")
    return nil
  elseif err == "timeout" then
    socketError("timeout")
    buffer = buffer .. partial
    return recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return recv_buffer(size_left - #content, buffer)
  end
end

function socket_long_connection.tcpRecv(dt)
  if not connection then
    return
  end
  local buffer_size_str, err = connection:receive(2)
  if connect_succ and err == "closed" then
    socketError("closed")
    socket_long_connection.close()
    return
  end
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
  local buffer = recv_buffer(buffer_size, "")
  if buffer then
    local plaincode = mycrypto.decrypt(buffer, cryptkey)
    netSequence = netSequence + 1
    local msg, err = downmsg():Parse(plaincode)
    if msg then
      dispatch(msg)
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end

function socket_long_connection.udpRecv(dt)
  if not connection then
    return
  end
  local datagram, error = connection:receive()
  if datagram then
    debugPrint("+++++++socket_long_connection.udpRecv")
  end
  if datagram == nil then
    if error ~= "timeout" then
      EDLog(string.format("ERROR | udpRecv receive failed! | %s", tostring(error)))
    end
    return
  else
    EDLog(">>>socket_long_connection udp Data Received @ " .. ed.getYMDTime())
    local msg = downmsg():Parse(datagram)
    if msg then
      socket_long_connection.dispatch(msg)
    end
  end
end

local sendCache = {}
local deleteCache = {}

local function delaySend(obj, ttype, deleteOnSent)
  sendCache[ttype] = obj
  if deleteOnSent then
    deleteCache[ttype] = obj
  end
end

socket_long_connection.delaySend = delaySend

local function pack_size(code, ttype)
  local uin
  if not EDFLAGWIN32 then
    uin = string.format("%d-%s", EDSDKType, ed.getDeviceId())
  else
    uin = ed.getDeviceId()
  end
  local session = userData.session
  if ed.use_gate then
    local length = #code + 9
    local _second = string.char(length % 256)
    local _first = string.char(math.floor(length / 256))
    return _first .. _second .. ed.svridData .. code
  else
    local length = #code
    local _second = string.char(length % 256)
    local _first = string.char(math.floor(length / 256))
    return _first .. _second .. code
  end
end

local function doConnection()
  if useUDP then
    return socket_long_connection.doUdpConnect(l_chat_game_server_ip, l_chat_game_server_port)
  else
    return socket_long_connection.doTcpConnect(l_chat_game_server_ip, l_chat_game_server_port, false)
  end
end

socket_long_connection.doConnection = doConnection

local function doCloseConnection(block)
  socket_long_connection.close()
end

socket_long_connection.doCloseConnection = doCloseConnection

function socket_long_connection.doSend(block, ttype)
  if nil == currentMsg then
    return false
  end
  if useUDP then
    socket_long_connection.doUdpSend(block, ttype)
  else
    socket_long_connection.doTcpSend(block, ttype)
  end
end

function socket_long_connection.doUdpSend(block, ttype)
  debugPrint("+++++++doUdpSend$$$$$$$")
  if not connection then
    EDLog("ERROR: doUdpSend no connection")
    return
  end
  local address = socket_long_connection.UDPAddress
  if not address.ip or not address.port then
    EDLog("ERROR: doUdpSend ip and port is nil")
    return
  end
  local datagram, error = currentMsg:Serialize()
  if not datagram then
    EDLog(string.format("ERROR | doUdpSend Serialize failed! | %s", tostring(error)))
    return
  end
  netSequence = netSequence + 1
  local result, err = connection:sendto(datagram, address.ip, address.port)
  debugPrint(address.ip, address.port, result, err)
  if result == nil then
    EDLog(string.format("ERROR | doUdpSend send failed! | %s", tostring(error)))
    return false
  else
    return true
  end
end

function socket_long_connection.doTcpSend(block, ttype)
  if not connection then
    return
  end
  local code, err = currentMsg:Serialize()
  local cipher_code
  if code then
    cipher_code = mycrypto.encrypt(code, cryptkey)
  else
    EDDebug(err)
  end
  up_code = pack_size(cipher_code, ttype)
  local r1, r2 = connection:send(up_code)
  if r2 == "closed" or r1 == nil then
    socketError("closed")
  else
    if r1 then
    else
    end
  end
  return true
end

local function send(obj, ttype, block)
  if connection then
  end
  currentMsg = nil
  currentMsg = upmsg()
  currentMsg._repeat = 0
  currentMsg._sequence = netSequence
  currentMsg["_" .. ttype] = obj
  bSendblock = block or false
  currentMsgType = ttype
  totalSendCount = totalSendCount + 1
  for k, v in pairs(sendCache or {}) do
    currentMsg["_" .. k] = v
    if deleteCache[k] then
      sendCache[k] = nil
      deleteCache[k] = nil
    end
  end
  return socket_long_connection.doSend(block, ttype)
end

socket_long_connection.send = send

local function setUserData(uin, session)
  userData.uin = uin
  userData.session = session
end

socket_long_connection.setUserData = setUserData

local function proc_net(dt)
  if ed.has_force_quit_notify then
    return
  end
  if isConnected then
    if useUDP then
      socket_long_connection.udpRecv(dt)
    else
      socket_long_connection.connect_resume()
      socket_long_connection.tcpRecv(dt)
    end
  end
end

socket_long_connection.proc_net = proc_net
ed.socket_long_connection = socket_long_connection

local function onConnectReply(result)
  if result._rtnotify_register_result == "success" then
    registerSuccess()
  end
  if result._rtnotify_keepalive_reply then
    timer.aliveNum = 0
    local lag = ed.getServerTime() - result._rtnotify_keepalive_reply._time
    lag = math.floor((ed.getTime().million - current_million_time) * 1000)
    if ed.realarena.network_mgr then
      ed.realarena.network_mgr:SetLag(lag)
    end
    if ed.ui.server_ping then
      ed.ui.server_ping:SetLag(lag)
    end
  end
end

local function initChatIPL(data)
  if data then
    local ipPort = Split(data, ":")
    l_chat_game_server_ip = ipPort[1]
    if "" == l_chat_game_server_ip then
      l_chat_game_server_ip = game_server_ip
    end
    l_chat_game_server_port = ipPort[2]
  end
end

ListenEvent("connectReply", onConnectReply)
ListenEvent("LoginReply", initChatIPL)
