require("lua_socket")
require("config")
require("mycrypto")
module("ed", package.seeall)
mp_resend_inteval = 2
mp_timeout_time = 0.01
local sequence_index = 0
local reconnect_time = 5
MultiplayerUdp = {}
MultiplayerUdp.__index = MultiplayerUdp

function MultiplayerUdp.create(ip, port)
  local udp = {}
  setmetatable(udp, MultiplayerUdp)
  udp.what = "MultiplayerUdp"
  udp.peer_ip = ip
  udp.peer_port = port
  udp:init()
  udp:penetrate()
  return udp
end

function MultiplayerUdp:init()
  self.delta_resend = 0
  self.elapse_time = 0
  self.tick_queue_sending = {}
  local object_udp, error = socket.udp()
  if object_udp == nil then
    EDLog(string.format("ERROR | MultiplayerUdp init failed! | %s", tostring(error)))
    return false
  end
  object_udp:settimeout(mp_timeout_time)
  object_udp:setsockname("*", 0)
  local udp_ip_client, udp_port_client = object_udp:getsockname()
  EDLog("udp_ip_client:" .. tostring(udp_ip_client) .. " udp_port_client:" .. tostring(udp_port_client))
  self.object_udp = object_udp
end

function MultiplayerUdp:destroy()
  self.tick_queue_sending = {}
  self.object_udp:close()
end

function MultiplayerUdp:reset()
  self.tick_queue_sending = {}
end

function MultiplayerUdp:reconnect()
  self.object_udp:close()
  local object_udp, error = socket.udp()
  if object_udp == nil then
    EDLog(string.format("ERROR | multistageUdp reconnect failed! | %s", tostring(error)))
    return false
  end
  object_udp:settimeout(mp_timeout_time)
  object_udp:setsockname("*", 0)
  self.object_udp = object_udp
  self:penetrate()
end

function MultiplayerUdp:update(dt)
  self:receive()
  self.delta_resend = self.delta_resend + dt
  if self.delta_resend >= mp_resend_inteval then
    self.delta_resend = 0
    self:resend()
  end
  self.elapse_time = self.elapse_time + dt
  if self.elapse_time > reconnect_time then
    self:reconnect()
    self.elapse_time = 0
  end
end

function MultiplayerUdp:resend()
  local msg_new = ed.upmsg.multiplayer_battle()
  msg_new._synchronization = ed.upmsg.multiplayer_synchronization()
  msg_new._synchronization._deviceid = ed.multiplayer_network:getDeviceId()
  local operations = {}
  for tick, op in pairs(self.tick_queue_sending) do
    local op_new = ed.upmsg.multiplayer_operations()
    op_new._tick = tonumber(tick)
    op_new._ops = op
    table.insert(operations, op_new)
  end
  if 0 < #operations then
    msg_new._synchronization._operations = operations
    self:send(msg_new)
  end
end

function MultiplayerUdp:send(msg_object)
  if self.peer_ip == nil or self.peer_port == nil then
    EDLog("ERROR: Server ip and port is nil!")
    return
  end
  local datagram = self:package(msg_object)
  if datagram then
    local result, error = self.object_udp:sendto(datagram, self.peer_ip, self.peer_port)
    if result == nil then
      EDLog(string.format("ERROR | MultiplayerUdp send failed! | %s", tostring(error)))
      return false
    else
      if msg_object._synchronization then
        local synchronization = msg_object._synchronization
        for _, op_data in ipairs(synchronization._operations or {}) do
          local tick = tostring(op_data._tick)
          self.tick_queue_sending[tick] = op_data._ops
        end
      end
      return true
    end
  else
    return false
  end
end

function MultiplayerUdp:package(msg_object)
  local msg = upmsg.up_msg()
  msg._repeat = 0
  msg._sequence = sequence_index
  msg._multiplayer_battle = msg_object
  local datagram, error = msg:Serialize()
  if not datagram then
    EDLog(string.format("ERROR | MultiplayerUdp package failed! | %s", tostring(error)))
    return
  end
  sequence_index = sequence_index + 1
  return datagram
end

function MultiplayerUdp:receive()
  local datagram, error = self.object_udp:receive()
  if datagram == nil then
    if error ~= "timeout" then
      EDLog(string.format("ERROR | MultiplayerUdp receive failed! | %s", tostring(error)))
    end
    return
  else
    local msg = self:parse(datagram)
    if msg then
      self:dispatch(msg._multiplayer_reply)
    end
  end
end

function MultiplayerUdp:parse(datagram)
  if datagram ~= "" then
    local msg, error = downmsg.down_msg():Parse(datagram)
    if msg == nil then
      EDLog(string.format("ERROR | MultiplayerUdp parse failed! | %s", tostring(error)))
    else
      return msg
    end
  end
end

function MultiplayerUdp:penetrate()
  ed.multiplayer_network:sendPenetrate(self)
end

function MultiplayerUdp:dispatch(msg)
  if msg == nil then
    EDLog("ERROR | MultiplayerUdp dispach msg is nil!")
    return
  end
  self.elapse_time = 0
  if msg._sync_acks then
    self:makeSure(msg._sync_acks)
  elseif msg._synchronization then
    FireEvent("Mp_MultiplayerSendAck", msg._synchronization._cur_tick)
    FireEvent("Mp_MultiplayerOperations", msg._synchronization)
  else
    EDLog("ERROR | MultiplayerUdp dispach msg is nil!")
  end
end

function MultiplayerUdp:makeSure(data)
  for _, tick in ipairs(data._ticks) do
    self.tick_queue_sending[tostring(tick)] = nil
  end
end
