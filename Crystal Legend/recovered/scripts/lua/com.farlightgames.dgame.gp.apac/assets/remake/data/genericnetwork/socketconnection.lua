module("genericNetwork", package.seeall)
socketConnection = {}
socketConnection.timeoutTime = 5
socketConnection.__index = socketConnection

function socketConnection:pack_size(code, ttype)
  local mode = self.csproto:getCsprotoMode()
  if mode == NetMode.sdklogin or mode == NetMode.accsystem then
    local length = #code
    local second = string.char(length % 256)
    local first = string.char(math.floor(length / 256))
    return first .. second .. code
  elseif mode == NetMode.systemdev then
    local device = ed.getNetPackDeviceId()
    local len = string.len(device) + string.len(tostring(game_server_id)) + 1
    local third = string.char(len % 256)
    local fourth = string.char(math.floor(len / 256))
    local t_len = #code + len + 2 + 1
    local _first, _second, _third, _fourth = ed.stringutil.split2Bytes(t_len)
    local info = {
      _first,
      _second,
      _third,
      _fourth,
      string.char(0),
      third,
      fourth,
      tostring(game_server_id),
      "#",
      device,
      code
    }
    return table.concat(info)
  end
end

function socketConnection:reSend()
  if self.currentMsg then
    self:doSend(self.bSendblock, self.currentMsgType)
  end
end

function socketConnection:init(mode)
  self.csproto = csprotoData:new(mode)
  self.connection = nil
  self.connectSucc = false
  self.currentMsg = nil
  self.upCode = nil
  self.serverIp = csprotoConfig[mode].serverIp
  self.serverPort = csprotoConfig[mode].serverPort
  self.connectionTime = nil
  self.flower = ed.ui.LoadFlower
end

function socketConnection:new(mode)
  local socketConnection = {}
  setmetatable(socketConnection, self)
  socketConnection:init(mode)
  return socketConnection
end

function socketConnection:getCsproto()
  return self.csproto
end

function socketConnection:getUpCsproto()
  return self.csproto:getUpCsproto()
end

function socketConnection:dispatch(msg)
  for k, v in pairs(msg[".data"]) do
    EDLog(">>> down msg: " .. k)
    if k == "_error_info" then
      ed.preprocessNetError(msg)
    else
      FireEvent(k, msg[k])
    end
  end
end

function socketConnection:close()
  self.flower:loadEnd()
  if self.connection then
    self.connection:close()
  end
  self.connection = nil
  self.connectSucc = false
  self.upCode = nil
  self.connectionTime = nil
end

function socketConnection:connect(block)
  self.connection = socket.tcp()
  if not self.connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  self.connection:settimeout(block and 5 or 0)
  self.serverIp = self.serverIp or game_server_ip
  self.serverPort = self.serverPort or game_server_port
  local err
  self.connectSucc, err = self.connection:connect(self.serverIp, self.serverPort)
  self.connectionTime = 0
  if self.connectSucc then
    EDLog("    connect succ")
    self.connection:settimeout(0)
    local r1, r2 = self.connection:send(self.upCode)
    if r1 then
      EDLog("<<< Message Sent  @ " .. ed.getYMDTime())
    else
      EDLog(string.format("ERROR | connection:send failed | %s", err))
      self:close()
    end
  elseif block then
    EDLog(string.format("ERROR | Blocked Connect failed | %s", err))
    self:close()
    return false
  else
    EDLog("    connect start")
    self.flower:loadBegin(false)
    return true
  end
end

function socketConnection:connect_resume()
  if self.connectSucc or not self.connection then
    return
  end
  local r, w, e = socket.select({
    self.connection
  }, {
    self.connection
  }, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = self.connection:connect(self.serverIp, self.serverPort)
  if errstr ~= "already connected" then
    EDLog("errstr", errstr)
    return
  end
  self.connectSucc = true
  EDLog("    connect succ")
  local r1, r2 = self.connection:send(self.upCode)
  if not r1 then
    EDlog("send error check network setting")
    ed.showToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(101)")
    self:close()
    return
  end
  EDLog("<<< Message Sent  @ " .. ed.getYMDTime())
end

function socketConnection:recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = self.connection:receive(size_left)
  if err == "closed" then
    EDLog("    socket closed")
    return nil
  elseif err == "timeout" then
    buffer = buffer .. partial
    return self:recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return self:recv_buffer(size_left - #content, buffer)
  end
end

function socketConnection:recv()
  if not self.connection then
    return
  end
  local byteNum = self.csproto:getCsprotoByteNum()
  local buffer_size_str, err = self.connection:receive(byteNum)
  if not buffer_size_str then
    return
  end
  local buffer_size = self:getBufferSize(buffer_size_str)
  local buffer = self:recv_buffer(buffer_size, "")
  self:close()
  if buffer then
    EDLog(">>> Data Received @ " .. ed.getYMDTime())
    local plaincode = self:decryptWrapper(buffer)
    local msg, err = self.csproto:parseDownMsg(plaincode)
    if msg then
      self:dispatch(msg)
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end

function socketConnection:getBufferSize(bufferSizeStr)
  local byte = string.byte
  local mode = self.csproto:getCsprotoMode()
  if mode == NetMode.sdklogin or mode == NetMode.accsystem then
    return byte(bufferSizeStr, 1) * 256 + byte(bufferSizeStr, 2)
  elseif mode == NetMode.systemdev then
    return byte(bufferSizeStr, 1) * 256 * 256 * 256 + byte(bufferSizeStr, 2) * 256 * 256 + byte(bufferSizeStr, 3) * 256 + byte(bufferSizeStr, 4)
  end
end

function socketConnection:doSend(block, ttype)
  if nil == self.currentMsg then
    return false
  end
  local code, err = self.currentMsg:Serialize()
  local cipher_code
  if code then
    cipher_code = self:encryptWrapper(code)
  else
    EDDebug(err)
  end
  self.upCode = self:pack_size(cipher_code, ttype)
  local r = false
  if block then
    r = self:connect(block)
  else
    r = self:connect()
    if not r then
      return r
    end
  end
  return true
end

function socketConnection:encryptWrapper(plaincode)
  local cryptkey = ed.getCryptKey()
  local ciphercode = plaincode
  if self.csproto:isEncryption() then
    ciphercode = mycrypto.encrypt(plaincode, cryptkey)
  end
  return ciphercode
end

function socketConnection:decryptWrapper(ciphercode)
  local cryptkey = ed.getCryptKey()
  local plaincode = ciphercode
  if self.csproto:isEncryption() then
    plaincode = mycrypto.decrypt(ciphercode, cryptkey)
  end
  return plaincode
end

function socketConnection:send(obj, ttype, block)
  if self.connection then
    return false
  end
  EDLog("<<< Sending msg: " .. ttype)
  self.currentMsg = nil
  self.currentMsg = self.csproto:newUpCsproto()
  self.currentMsg[ttype] = obj
  self.bSendblock = block
  self.currentMsgType = ttype
  return self:doSend(block, ttype)
end

function socketConnection:timeoutLogic(dt)
  if not self.connectionTime then
    return
  end
  self.connectionTime = self.connectionTime + dt
  if self.connectionTime > self.timeoutTime then
    self:close()
    errorNet.showError(function()
      self:reSend()
    end)
  end
end

function socketConnection:update(dt)
  self:connect_resume()
  self:recv()
  self:timeoutLogic(dt)
end

function socketConnection:setServerIpAndPort(server)
  self.serverIp = server.ip
  self.serverPort = server.port
end
