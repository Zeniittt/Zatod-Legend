require("lua_socket")
require("config")
require("mycrypto")
module("ed", package.seeall)
local ma_resend_inteval = 2
local ma_timeout_time = 0.01
local heart_beat_interval = 1
local sequence_index = 0
local valid_heart_times = 5
local tick_ack = 1
MultiarenaUdp = {}
MultiarenaUdp.__index = MultiarenaUdp

function MultiarenaUdp.create(ip, port)
  local udp = {}
  setmetatable(udp, MultiarenaUdp)
  udp.what = "MultiarenaUdp"
  udp.peer_ip = ip
  udp.peer_port = port
  udp.tick_ack = tick_ack
  udp:init()
  udp:penetrate()
  return udp
end

function MultiarenaUdp:init()
  self.delta_resend = 0
  self.tick_queue_sending = {}
  self.heart_times = 0
  self.lastReceveTime = ed.getServerTime()
  local object_udp, error = socket.udp()
  if object_udp == nil then
    EDLog(string.format("ERROR | MultiarenaUdp init failed! | %s", tostring(error)))
    return false
  end
  object_udp:settimeout(ma_timeout_time)
  object_udp:setsockname("*", 0)
  local udp_ip_client, udp_port_client = object_udp:getsockname()
  EDLog("udp_ip_client:" .. tostring(udp_ip_client) .. " udp_port_client:" .. tostring(udp_port_client))
  self.object_udp = object_udp
end

function MultiarenaUdp:destroy()
  self.tick_queue_sending = {}
  self.object_udp:close()
end

function MultiarenaUdp:reset()
  self.tick_queue_sending = {}
end

function MultiarenaUdp:update(dt)
  self:receive()
  self.delta_resend = self.delta_resend + dt
  if self.delta_resend >= ma_resend_inteval then
    self.delta_resend = 0
    self:resend()
  end
  if ed.getServerTime() - self.lastReceveTime >= heart_beat_interval then
    self.lastReceveTime = ed.getServerTime()
    self:heartBeatManager()
    FireEvent("multi_arena_tick_ack")
  end
end

function MultiarenaUdp:heartBeatManager()
  if self.heart_times > valid_heart_times then
    local addr = ed.CrArenaMgr:getRoomAddr()
    ed.CrArenaNetwork:reOpenUDPConnection(addr)
  else
    self.heart_times = self.heart_times + heart_beat_interval
    ed.CrArenaNetwork:sendHeartBeat()
  end
end

function MultiarenaUdp:resend()
  local msg_new = ed.upmsg.multi_arena()
  msg_new._synchronization = ed.upmsg.multi_arena_synchronization()
  msg_new._synchronization._deviceid = ed.CrArenaMgr:getDeviceId()
  local operations = {}
  for tick, op in pairs(self.tick_queue_sending) do
    local op_new = ed.upmsg.multi_arena_operations()
    op_new._tick = tonumber(tick)
    op_new._ops = op
    table.insert(operations, op_new)
  end
  if 0 < #operations then
    msg_new._synchronization._operations = operations
    self:send(msg_new)
  end
end

function MultiarenaUdp:send(msg_object)
  if self.peer_ip == nil or self.peer_port == nil then
    EDLog("ERROR: Server ip and port is nil!")
    return
  end
  local datagram = self:package(msg_object)
  if datagram then
    local result, error = self.object_udp:sendto(datagram, self.peer_ip, self.peer_port)
    if result == nil then
      EDLog(string.format("ERROR | MultiarenaUdp send failed! | %s", tostring(error)))
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

function MultiarenaUdp:package(msg_object)
  local msg = upmsg.up_msg()
  msg._repeat = 0
  msg._sequence = sequence_index
  msg._multi_arena = msg_object
  local datagram, error = msg:Serialize()
  if not datagram then
    EDLog(string.format("ERROR | MultiarenaUdp package failed! | %s", tostring(error)))
    return
  end
  sequence_index = sequence_index + 1
  return datagram
end

function MultiarenaUdp:receive()
  local datagram, error = self.object_udp:receive()
  if datagram == nil then
    if error ~= "timeout" then
      EDLog(string.format("ERROR | MultiarenaUdp receive failed! | %s", tostring(error)))
    end
    return
  else
    local msg = self:parse(datagram)
    if msg then
      self:dispatch(msg)
    end
  end
end

function MultiarenaUdp:parse(datagram)
  if datagram ~= "" then
    local msg, error = downmsg.down_msg():Parse(datagram)
    if msg == nil then
      EDLog(string.format("ERROR | MultiarenaUdp parse failed! | %s", tostring(error)))
    else
      return msg
    end
  end
end

function MultiarenaUdp:dispatch(msg)
  if msg == nil then
    EDLog("ERROR | MultiarenaUdp dispach msg is nil!")
    return
  end
  if msg._multi_arena_reply then
    self.heart_times = 0
    FireEvent("multi_arena_reply", msg._multi_arena_reply)
    local msg = msg._multi_arena_reply
    if msg._sync_acks then
      self:makeSure(msg._sync_acks._ticks or {})
    end
  else
    EDLog("ERROR | MultiarenaUdp dispach msg is nil!")
  end
  self.lastReceveTime = ed.getServerTime()
end

function MultiarenaUdp:makeSure(ticks)
  for _, tick in ipairs(ticks) do
    self.tick_queue_sending[tostring(tick)] = nil
  end
end

function MultiarenaUdp:penetrate()
  ed.CrArenaNetwork:sendPenetrate(self)
end
