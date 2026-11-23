local ed = ed
require("lua_socket")
require("config")
require("mycrypto")
local up = ed.upmsg
local down = ed.downmsg
local global_chat_up = pb_loader("global_chat_up")()
local global_chat_down = pb_loader("global_chat_down")()
local global_chat_common = pb_loader("global_chat_common")()
local upmsg = global_chat_up.gc_up
local downmsg = global_chat_down.gc_down
local chatServerSpcae = {}
local current_million_time = 0
ed.globalChatUpMsg = global_chat_up
ed.globalChatDownMsg = global_chat_down
ed.globalChatCommonMsg = global_chat_common
ed.globalChatIsRegister = false
local up_code
local netSequence = 0
local cryptkey = "182173557"
local chat_game_server_ip, chat_game_server_port, connection
local connect_succ = false
local close, err
local bSendblock = false
local currentMsg, currentMsgType
local totalConnectTime = 0
local totalSendCount = 0
local serverPingTime = 0
local scope = {
  aliveScope = {},
  register = {},
  reconnectScope = {}
}
local timer = {aliveTimer = 0, aliveNum = 0}
local debugF = false

local function debugPrint(...)
  if debugF then
    local args = {}
    for _, v in ipairs({
      ...
    }) do
      table.insert(args, v)
    end
    EDLog(table.concat(args, " "))
  end
end

local function debugPT(tb)
  if debugF then
    ed.pt(tb, nil, nil, {func = EDLog})
  end
end

local useUDP = true
local socket_long_chat = {
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
  setDebug = function(flag)
    debugF = flag
  end,
  setDebugPrint = function(func)
    debugPrint = func
  end,
  setDebugPT = function(func)
    debugPT = func
  end,
  UDPAddress = {},
  DefaultUDPTimeOut = 0.01,
  UDPDTAcc = 0,
  UDPReceiveInterval = 0,
  UseUDPSelect = true
}
ed.socket_long_chat = socket_long_chat
socket_long_chat.heart_beat_interval = 5

local function getlongChatIp()
  return chat_game_server_ip
end

socket_long_chat.getlongChatIp = getlongChatIp

local function setIpAndPort(ip, port)
  chat_game_server_ip = ip
  chat_game_server_port = port
end

socket_long_chat.setIpAndPort = setIpAndPort

local function dispatch(msg)
  debugPT(msg)
  for k, v in pairs(msg[".data"]) do
  end
  if msg.connect_status then
    socket_long_chat.connectHandler(msg.connect_status)
  end
  if msg.open_panel_reply then
    CloseScope(chatServerSpcae)
    ed.globalChatIsRegister = true
    FireEvent("serverChatOpenPanelEvent", msg.open_panel_reply)
  end
  if msg.channel_sub_reply then
    FireEvent("channelSubEvent", msg.channel_sub_reply)
    if ed.chatChangeChannelNetHandler then
      ed.chatChangeChannelNetHandler()
      ed.chatChangeChannelNetHandler = nil
      ed.chatNetDataMrg.chatServerData[ed.curChatServerTarget.id] = ed.chatNetDataMrg.chatServerData[ed.curChatServerTarget.id] or {
        msg = {},
        msg_id = 0
      }
      if ed.isOpenChat and ed.ui.chatMain.getInstace():getCurChannel() == "chatServer" then
        ed.showToast(T("\230\172\162\232\191\142\229\138\160\229\133\165%s\229\133\168\230\156\141\232\129\138\229\164\169\233\162\145\233\129\147", ed.curChatServerTarget.name))
      end
    end
  end
  if msg.channel_chat_reply then
    ed.chatServerTimes = ed.getServerTime()
    FireEvent("channelChatEvent", msg.channel_chat_reply)
  end
  if msg.msg and msg.msg.seq_id then
    FireEvent("channelMsgEvent", msg.msg.channel_msg)
    ed.chatNetDataMrg:sendReceipt(msg.msg.seq_id)
  end
  if msg.error then
    ed.showToast(msg.error)
  end
end

socket_long_chat.dispatch = dispatch

local function connectHandler(state)
  socket_long_chat.registerSuccess()
  if state == "unregistered" or state == "unsubscribed" then
    ed.chatNetDataMrg:sendOpenAllServerChat()
  else
    ed.globalChatIsRegister = true
  end
end

socket_long_chat.connectHandler = connectHandler

local function reregister()
  socket_long_chat.close()
  ed.socket_long_chat.register()
end

socket_long_chat.reregister = reregister

local function keepalive()
  if not useUDP and timer.aliveNum >= 2 then
    socket_long_chat.reregister()
    return
  end
  timer.aliveNum = timer.aliveNum + 1
  local up_msg = ed.globalChatUpMsg.gc_connect_test()
  ed.socket_long_chat.send(up_msg, "connect_test")
  current_million_time = ed.getTime().million
end

socket_long_chat.keepalive = keepalive

local function register()
  if not ed.getUserid() then
    return
  end
  CloseScope(scope.reconnectScope)
  if ed.socket_long_chat.doConnection() then
    local up_msg = ed.globalChatUpMsg.gc_connect_test()
    ed.socket_long_chat.send(up_msg, "connect_test")
    if useUDP then
      socket_long_chat.registerSuccess()
    else
      ListenTimer(Timer:Once(5), socket_long_chat.reregister, scope.reconnectScope)
    end
  end
end

socket_long_chat.register = register

local function registerSuccess()
  CloseScope(scope.reconnectScope)
  CloseScope(scope.aliveScope)
  timer.aliveNum = 0
  EnqueueDelayProcess(function()
    ListenTimer(Timer:Always(30), ed.socket_long_chat.keepalive, scope.aliveScope)
  end)
end

socket_long_chat.registerSuccess = registerSuccess

local function socketError(errcode)
  if errcode == "succeed" then
    EDLog("succeed connect the chat server")
  elseif errcode == "closed" then
    FireEvent("SocketL_Chat_Error", -1)
  elseif errcode == "timeout" then
    FireEvent("SocketL_Chat_Error", -2)
  else
    if errcode == "unknownError" then
      FireEvent("SocketL_Chat_Error", -3)
    else
    end
  end
end

socket_long_chat.socketError = socketError

function close()
  if connection then
    EDLog("socket_l do close")
    connection:close()
  end
  connection = nil
  connect_succ = false
  up_code = nil
  totalSendCount = 0
end

socket_long_chat.close = close

local function isSocketConnected()
  return connect_succ
end

socket_long_chat.isSocketConnected = isSocketConnected

local function setConnectionOption()
  socket_long_chat.socketError("succeed")
  connection:setoption("keepalive", true)
  local ret = connection:setoption("tcp-nodelay", true)
  if ret == 1 then
    print("tcp-nodelay", ret)
  end
end

socket_long_chat.setConnectionOption = setConnectionOption

local function connect(ip, port, block)
  isConnected = true
  connection, err = socket.tcp()
  if not connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  local timeout = 3
  if EDFLAGWIN32 then
    timeout = 0
  end
  connection:settimeout(timeout)
  EDLog("socket_l do connect")
  if not chat_game_server_ip or not chat_game_server_port then
    return false
  end
  connect_succ, err = connection:connect(chat_game_server_ip, chat_game_server_port)
  debugPrint(chat_game_server_ip, chat_game_server_port, err)
  if connect_succ then
    connection:settimeout(0)
    socket_long_chat.setConnectionOption()
    return true
  end
  return false
end

local function connect_resume()
  if connect_succ or not connection then
    return
  end
  local r, w, e = socket.select({connection}, {connection}, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = connection:connect(chat_game_server_ip, chat_game_server_port)
  print("[==============]-------->>>>>>", errstr)
  if errstr ~= "already connected" then
    print("already connected")
    return
  end
  connect_succ = true
  socket_long_chat.setConnectionOption()
  if up_code == nil then
    return
  else
    local r1, r2 = connection:send(up_code)
    if not r1 then
      ed.showNetToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(41)")
      return
    end
  end
  EDLog("<<< long_tcp Message Sent  @ " .. ed.getYMDHMSTime())
end

local function recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = connection:receive(size_left)
  if err == "closed" then
    socket_long_chat.socketError("closed")
    return nil
  elseif err == "timeout" then
    socket_long_chat.socketError("timeout")
    buffer = buffer .. partial
    return recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return recv_buffer(size_left - #content, buffer)
  end
end

local function recv()
  if not connection then
    return
  end
  local buffer_size_str, err = connection:receive(4)
  if connect_succ and err == "closed" then
    socket_long_chat.socketError("closed")
    return
  end
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 * 256 * 256 + string.byte(buffer_size_str, 2) * 256 * 256 + string.byte(buffer_size_str, 3) * 256 + string.byte(buffer_size_str, 4)
  EDLog("buffersize " .. tostring(buffer_size))
  local buffer = recv_buffer(buffer_size, "")
  serverPingTime = ed.getMillionTime() - serverPingTime
  if buffer then
    EDLog(">>> long_tcp Data Received @ " .. ed.getYMDHMSTime())
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

socket_long_chat.recv = recv
local sendCache = {}
local deleteCache = {}

local function delaySend(obj, ttype, deleteOnSent)
  sendCache[ttype] = obj
  if deleteOnSent then
    deleteCache[ttype] = obj
  end
end

socket_long_chat.delaySend = delaySend

local function pack_size(code, ttype)
  if ed.use_gate then
    local length = #code + 9
    local _first, _second, _third, _fourth = ed.stringutil.split2Bytes(length)
    return _first .. _second .. _third .. _fourth .. ed.svridData .. code
  else
    local length = #code
    local _first, _second, _third, _fourth = ed.stringutil.split2Bytes(length)
    return _first .. _second .. _third .. _fourth .. code
  end
end

function socket_long_chat.doUdpConnect(ip, port)
  debugPrint("+++++++doUdpConnect$$$$$$$", ip, port)
  if not ip or not port then
    return
  end
  socket_long_chat.UDPAddress.ip = ip
  socket_long_chat.UDPAddress.port = port
  connection, err = socket.udp()
  if not connection then
    EDLog(string.format("ERROR | socket_long_chat.doUdpConnect failed! | %s", tostring(err)))
    return false
  end
  connect_succ = true
  connection:settimeout(socket_long_chat.DefaultUDPTimeOut)
  connection:setsockname("*", 0)
  local udp_ip_client, udp_port_client = connection:getsockname()
  EDLog("udp_ip_client:" .. tostring(udp_ip_client) .. " udp_port_client:" .. tostring(udp_port_client))
  return true
end

function socket_long_chat.doUdpSend(block, ttype)
  debugPrint("+++++++doUdpSend$$$$$$$")
  debugPT(currentMsg)
  if not connection then
    EDLog("ERROR: doUdpSend no connection")
    return
  end
  local address = socket_long_chat.UDPAddress
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

function socket_long_chat.setUDPReceiveInterval(interval)
  socket_long_chat.UDPReceiveInterval = interval
  socket_long_chat.UDPDTAcc = 0
end

function socket_long_chat.udpRecv(dt)
  local interval = socket_long_chat.UDPReceiveInterval
  if 0 < interval then
    socket_long_chat.UDPDTAcc = socket_long_chat.UDPDTAcc + dt
    if interval <= socket_long_chat.UDPDTAcc then
      socket_long_chat.__udpRecv()
      while interval <= socket_long_chat.UDPDTAcc do
        socket_long_chat.UDPDTAcc = socket_long_chat.UDPDTAcc - interval
      end
    end
  else
    socket_long_chat.__udpRecv()
  end
end

function socket_long_chat.__udpRecv()
  if not connection then
    return
  end
  if socket_long_chat.UseUDPSelect then
    local r, w, e = socket.select({connection}, nil, 0)
    if not (r and r[1]) or e then
      return
    end
  end
  local datagram, error = connection:receive()
  if datagram == nil then
    if error ~= "timeout" then
      EDLog(string.format("ERROR | udpRecv receive failed! | %s", tostring(error)))
    end
    return
  else
    EDLog(">>>socket_long_chat udp Data Received @ " .. ed.getYMDTime())
    local msg = downmsg():Parse(datagram)
    if msg then
      socket_long_chat.dispatch(msg)
    end
  end
end

local function doConnection(ip, port, block)
  if useUDP then
    return socket_long_chat.doUdpConnect(ip or chat_game_server_ip, port or chat_game_server_port)
  else
    return connect(ip, port, block)
  end
end

socket_long_chat.doConnection = doConnection

local function doCloseConnection(block)
  socket_long_chat.close()
end

socket_long_chat.doCloseConnection = doCloseConnection

function socket_long_chat.doSend(block, ttype)
  if nil == currentMsg then
    return false
  end
  if not connection then
    EDLog("ERROR:Socket_l do send fail! Connection is closed!")
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
    if ed.globalChatIsRegister then
      ed.globalChatIsRegister = false
      socket_long_chat.reregister()
    end
  elseif r1 then
    EDLog("<<< long_tcp Message Sent  @ " .. ed.getYMDHMSTime())
    serverPingTime = ed.getMillionTime()
  else
    EDLog(string.format("ERROR | connection:send failed | %s", err))
  end
  return true
end

local function send(obj, ttype, block)
  if connection then
  end
  currentMsg = nil
  currentMsg = upmsg()
  currentMsg[ttype] = obj
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
  currentMsg.uuid = ed.player:getUUID() or ""
  if useUDP then
    return socket_long_chat.doUdpSend(block, ttype)
  else
    return socket_long_chat.doSend(block, ttype)
  end
end

socket_long_chat.send = send

local function proc_net(dt)
  if useUDP then
    socket_long_chat.udpRecv(dt)
  else
    connect_resume()
    recv()
  end
  if ed.config.vsmodedebug == 1 and ed.vsdebug and ed.vsdebug[3] then
    if connect_succ then
      local r1, r2, r3 = connection:getstats()
      totalConnectTime = r3
      ed.setString(ed.vsdebug[3], string.format("connectTime:%d", totalConnectTime))
    else
      ed.setString(ed.vsdebug[3], string.format("connect lost"))
    end
    if serverPingTime ~= 0 and serverPingTime < 5 then
      ed.setString(ed.vsdebug[1], string.format("ping:%s ms", serverPingTime * 1000))
    end
    ed.setString(ed.vsdebug[2], string.format("sendMsgCnt:%d", totalSendCount))
  end
end

socket_long_chat.proc_net = proc_net
