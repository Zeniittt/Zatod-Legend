require("lua_socket")
require("config")
require("mycrypto")
module("ed", package.seeall)
local math = math
local string = string
local sequence_index = 0
udp_ip_client = ""
udp_port_client = 0
udp_timeout_time = 0.005
udp_resend_inteval = 2
udp_receive_init_size = 2
valid_wait_time = 2
SocketUdp = {}
SocketUdp.__index = SocketUdp
local mode_type = {
  "unconnected",
  "connected"
}

function SocketUdp.Create(ip, port, mode)
  local udp = {}
  setmetatable(udp, SocketUdp)
  udp.what = "SocketUdp"
  udp.mode = mode_type[mode or 2]
  udp.peer_ip = ip
  udp.peer_port = port
  udp.delta_resend = 0
  udp.server_ping_time = getServerMillionTime()
  udp.lastReceveTime = ed.getServerTime()
  udp.svridData = ed.svridData or "svrid"
  if not udp:Init() then
    return
  end
  return udp
end

function SocketUdp:Destroy()
  self.tick_queue_sending = nil
  self.object_udp:close()
end

function SocketUdp:Init()
  local object_udp, error = socket.udp()
  if object_udp == nil then
    EDLog(string.format("ERROR | SocketUdp Init failed! | %s", tostring(error)))
    return false
  end
  object_udp:setsockname("*", 0)
  udp_ip_client, udp_port_client = object_udp:getsockname()
  EDLog("init udp_ip_client:" .. tostring(udp_ip_client) .. " udp_port_client:" .. tostring(udp_port_client))
  object_udp:settimeout(udp_timeout_time)
  self.object_udp = object_udp
  self.tick_queue_sending = {}
  return true
end

function SocketUdp:SetPort(port)
  self.peer_port = port
  EDLog("set_port udp_ip_sever:" .. tostring(self.peer_ip) .. " udp_port_server:" .. tostring(self.peer_port))
  if not isIPAddress(self.peer_ip) then
    self.peer_ip = socket.dns.toip(self.peer_ip)
    EDLog("set_port udp_ip_sever:" .. tostring(self.peer_ip) .. " udp_port_server:" .. tostring(self.peer_port))
  end
end

function SocketUdp:setSvrid(svrid)
  print("network_udp->genSvridData", svrid)
  self.peer_svrid = svrid
  if svrid then
    local gs_first, gs_second, gs_third, gs_fourth = ed.stringutil.split2Bytes(svrid)
    self.svridData = "svrid" .. gs_first .. gs_second .. gs_third .. gs_fourth
  else
    self.svridData = ed.svridData
  end
end

function SocketUdp:Reset()
  self.tick_queue_sending = {}
end

function SocketUdp:sendHeartBeat()
  local scene = ed.getCurrentScene()
  if scene.identity == "battle" then
    print("============= >>> send heart beat ")
    local msg = ed.upmsg.real_pvp()
    msg._udp_penetrate = ed.upmsg.udp_penetrate()
    msg._udp_penetrate._device_id = ed.my_device_id or ""
    self:SendMsg("real_pvp", msg)
  end
end

function SocketUdp:SendMsg(msg_type, msg_object)
  if self.peer_ip == nil or self.peer_port == nil then
    EDLog("ERROR: Server ip and port is nil!")
    return
  end
  local datagram = self:PackageMsg(msg_type, msg_object)
  if datagram then
    if ed.use_gate then
      datagram = self.svridData .. datagram
    end
    local result, error = self.object_udp:sendto(datagram, self.peer_ip, self.peer_port)
    if result == nil then
      EDLog(string.format("ERROR | SocketUdp SendMsg send failed! | %s", tostring(error)))
      return false
    else
      if msg_object._sync_operations then
        for i, op_data in ipairs(msg_object._sync_operations._ops) do
          local tick = tostring(op_data._tick)
          self.tick_queue_sending[tick] = op_data._operation
          if EDFLAGWIN32 then
            local ops = {}
            for _, v in ipairs(op_data._operation or {}) do
              table.insert(ops, v)
            end
            ed.scene:recordOpsSync(tick, "send", table.concat(ops, ","))
          end
        end
      end
      self.server_ping_time = getServerMillionTime()
      return true
    end
  else
    return false
  end
end

function SocketUdp:ResendNoReplyMsg()
  local msg_new = ed.upmsg.real_pvp()
  msg_new._sync_operations = ed.upmsg.sync_operations()
  msg_new._sync_operations._device_id = ed.my_device_id or ""
  msg_new._sync_operations._ops = {}
  local count = 0
  for tick, operation in pairs(self.tick_queue_sending) do
    local op_new = ed.upmsg.sync_operation()
    op_new._tick = tonumber(tick)
    op_new._operation = operation
    table.insert(msg_new._sync_operations._ops, op_new)
    count = count + 1
  end
  if 0 < count then
    self:SendMsg("real_pvp", msg_new)
  end
end

function SocketUdp:ResetResendQueue()
  self.tick_queue_sending = {}
end

function SocketUdp:PackageMsg(msg_type, msg_object)
  local msg = upmsg.up_msg()
  msg._repeat = 0
  msg._sequence = sequence_index
  msg["_" .. msg_type] = msg_object
  local datagram, error = msg:Serialize()
  if not datagram then
    EDLog(string.format("ERROR | SocketUdp PackageMsg Serialize failed! | %s", tostring(error)))
    return
  end
  sequence_index = sequence_index + 1
  return datagram
end

function SocketUdp:ReceiveMsg()
  local datagram, error = self.object_udp:receive()
  if datagram == nil then
    return
  else
    self.buffer_received = datagram
    self.server_ping_time = getServerMillionTime() - self.server_ping_time
    local msg = self:ParseMsg()
    if msg then
      self:DispachMsg(msg)
    end
  end
end

function SocketUdp:ParseMsg()
  if self.buffer_received ~= "" then
    local msg, error = downmsg.down_msg():Parse(self.buffer_received)
    if msg == nil then
      EDLog(string.format("ERROR | SocketUdp ParseMsg Parse failed! | %s", tostring(error)))
    else
      return msg
    end
  end
end

function SocketUdp:DispachMsg(msg)
  if msg == nil then
    EDLog("ERROR | SocketUdp DispachMsg msg is nil!")
    return
  end
  for k, v in pairs(msg[".data"]) do
  end
  if msg._real_pvp then
    if msg._real_pvp._sync_operations then
      FireEvent("RealPVPSync", msg._real_pvp._sync_operations, self)
      if EDFLAGWIN32 then
        local data = msg._real_pvp._sync_operations
        if data then
          ed.scene:recordOpsSync(tostring(data._cur_tick), "latestTick", "0")
          for i, operation in ipairs(data._ops or {}) do
            local ops = {}
            for _, v in ipairs(operation._self_ops or {}) do
              table.insert(ops, v)
            end
            for _, v in ipairs(operation._oppo_ops or {}) do
              table.insert(ops, v)
            end
            ed.scene:recordOpsSync(tostring(operation._tick), "receive", table.concat(ops, ","))
          end
        end
      end
    elseif msg._real_pvp._sync_acks then
      for i, tick in ipairs(msg._real_pvp._sync_acks._ticks or {}) do
        self.tick_queue_sending[tostring(tick)] = nil
      end
    end
    self.lastReceveTime = ed.getServerTime()
  end
end

function SocketUdp:Update(dt)
  self.delta_resend = self.delta_resend + dt
  self:ReceiveMsg()
  if self.delta_resend >= udp_resend_inteval then
    self.delta_resend = 0
    self:ResendNoReplyMsg()
  end
  if ed.getServerTime() - self.lastReceveTime >= valid_wait_time then
    self.lastReceveTime = ed.getServerTime()
    self:sendHeartBeat()
  end
end

function isIPAddress(str)
  local ipPattern = "^%d+%.%d+%.%d+%.%d+$"
  if string.match(str, ipPattern) then
    return true
  else
    return false
  end
end
