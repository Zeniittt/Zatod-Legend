local ed = ed
require("lua_socket")
require("config")
require("mycrypto")
local up = ed.upmsg
local down = ed.downmsg
local upmsg = up.up_msg
local downmsg = down.down_msg
local insert = table.insert
local ipairs = ipairs
local up_code
local netSequence = 0
local cryptkey = "182173559"
local vs_game_server_ip = "101.251.105.8"
local vs_game_server_port = "10001"
local socket_long_realarena = {}
ed.socket_long_realarena = socket_long_realarena
socket_long_realarena.heart_beat_interval = 5
local connect = socket.connect
local connection
local connect_succ = false
local close, err
local bSendblock = false
local currentMsg, currentMsgType
local totalConnectTime = 0
local totalSendCount = 0
local serverPingTime = 0

local function dispatch(msg)
  if msg._btc_ctrl_notify then
    ed.btc_ctrl_notify = msg._btc_ctrl_notify
    do_battle_log = ed.btc_ctrl_notify._open_btlog == 1
  end
  if msg._real_pvp then
    FireEvent("RealPVPRsp", msg._real_pvp)
    if msg._real_pvp._pvp_heart_resp and ed.realarena.network_mgr then
      ed.realarena.network_mgr:SetOppoLag(msg._real_pvp._pvp_heart_resp._oppo_lag)
    end
  end
end

socket_long_realarena.dispatch = dispatch

local function keepalive()
  local msg = ed.upmsg.real_pvp()
  msg._pvp_heart = ed.upmsg.pvp_heart()
  if ed.realarena.network_mgr then
    msg._pvp_heart._device_id = ed.my_device_id
    msg._pvp_heart._my_lag = ed.realarena.network_mgr:GetLag()
  end
  ed.socket_long_realarena.send(msg, "real_pvp")
end

socket_long_realarena.keepalive = keepalive

local function socketError(errcode)
  if errcode == "succeed" then
    FireEvent("SocketL_Succeed", vs_game_server_ip, vs_game_server_port)
    EDLog("succeed connect the battle server")
  elseif errcode == "closed" then
    FireEvent("SocketL_Error", -1)
  elseif errcode == "timeout" then
    FireEvent("SocketL_Error", -2)
  else
    if errcode == "unknownError" then
      FireEvent("SocketL_Error", -3)
    else
    end
  end
end

socket_long_realarena.socketError = socketError

function close()
  if connection then
    EDLog("socket_l_realarena do close")
    connection:close()
  end
  connection = nil
  connect_succ = false
  up_code = nil
  totalSendCount = 0
end

socket_long_realarena.close = close

local function isSocketConnected()
  return connect_succ
end

socket_long_realarena.isSocketConnected = isSocketConnected

local function setConnectionOption()
  socketError("succeed")
  connection:setoption("keepalive", true)
  local ret = connection:setoption("tcp-nodelay", true)
  if ret == 1 then
    print("tcp-nodelay", ret)
  end
end

socket_long_realarena.setConnectionOption = setConnectionOption

local function connect(ip, port, block)
  if ed.has_force_quit_notify then
    return
  end
  connection, err = socket.tcp()
  if not connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  connection:settimeout(block and 5 or 0)
  EDLog("socket_l_realarena do connect", ip, port)
  connect_succ, err = connection:connect(ip, port)
  vs_game_server_ip = ip
  vs_game_server_port = port
  if connect_succ then
    connection:settimeout(0)
    setConnectionOption()
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
  local ret, errstr = connection:connect(vs_game_server_ip, vs_game_server_port)
  if errstr ~= "already connected" then
    print("already connected")
    return
  end
  connect_succ = true
  setConnectionOption()
  if up_code == nil then
    return
  else
    local r1, r2 = connection:send(up_code)
    if not r1 then
      ed.showNetToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(61)")
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

local function recv()
  if not connection then
    return
  end
  local buffer_size_str, err = connection:receive(2)
  if connect_succ and err == "closed" then
    socketError("closed")
    return
  end
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
  local buffer = recv_buffer(buffer_size, "")
  serverPingTime = ed.getMillionTime() - serverPingTime
  if buffer then
    EDLog(">>> long_tcp Data Received @ " .. ed.getYMDHMSTime())
    netSequence = netSequence + 1
    local msg, err = downmsg():Parse(buffer)
    if msg then
      dispatch(msg)
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end

socket_long_realarena.recv = recv
local sendCache = {}
local deleteCache = {}

local function delaySend(obj, ttype, deleteOnSent)
  sendCache[ttype] = obj
  if deleteOnSent then
    deleteCache[ttype] = obj
  end
end

socket_long_realarena.delaySend = delaySend
local svridData = "svrid"

local function genSvridData(svrid)
  print("network_l_realarena->genSvridData", svrid)
  if svrid then
    local gs_first, gs_second, gs_third, gs_fourth = ed.stringutil.split2Bytes(svrid)
    svridData = "svrid" .. gs_first .. gs_second .. gs_third .. gs_fourth
  else
    svridData = ed.svridData
  end
end

local function pack_size(code, ttype)
  if ed.use_gate then
    local length = #code + 9
    local second = string.char(length % 256)
    local first = string.char(math.floor(length / 256))
    return first .. second .. svridData .. code
  else
    local length = #code
    local second = string.char(length % 256)
    local first = string.char(math.floor(length / 256))
    return first .. second .. code
  end
end

local function doConnection(ip, port, block, svrid)
  genSvridData(svrid)
  return connect(ip, port, block)
end

socket_long_realarena.doConnection = doConnection

local function doCloseConnection(block)
  close()
end

socket_long_realarena.doCloseConnection = doCloseConnection

local function doSend(block, ttype)
  if nil == currentMsg then
    return false
  end
  if not connection then
    EDLog("ERROR:Socket_l_realarena do send fail! Connection is closed!")
    return
  end
  local code, err = currentMsg:Serialize()
  up_code = pack_size(code, ttype)
  local r1, r2 = connection:send(up_code)
  if r2 == "closed" or r1 == nil then
    socketError("closed")
    EDLog("socket closed!")
  elseif r1 then
    EDLog("<<< long_tcp Message Sent  " .. ttype .. "    @ " .. ed.getYMDHMSTime())
    serverPingTime = ed.getMillionTime()
  else
    EDLog(string.format("ERROR | connection:send failed | %s", err))
  end
  return true
end

local function reSend()
  if nil == currentMsg then
    return
  end
  doSend(bSendblock, currentMsgType)
end

local function send(obj, ttype, block)
  if connection then
  end
  if ed.has_force_quit_notify then
    return
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
  return doSend(block, ttype)
end

socket_long_realarena.send = send

local function proc_net()
  if ed.has_force_quit_notify then
    return
  end
  connect_resume()
  recv()
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

socket_long_realarena.proc_net = proc_net
