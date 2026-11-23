module("genericNetwork", package.seeall)
csprotoData = {}
csprotoData.__index = csprotoData

function csprotoData:init(mode)
  self.upmsg = pb_loader(csprotoConfig[mode].pbUp)()
  self.downmsg = pb_loader(csprotoConfig[mode].pbDown)()
  self.encryption = csprotoConfig[mode].encryption
  self.packHeadByteNum = csprotoConfig[mode].packHeadByteNum
  self.upMsgName = csprotoConfig[mode].upMsgName
  self.downMsgName = csprotoConfig[mode].downMsgName
  self.mode = mode
  self.netSequence = 0
end

function csprotoData:new(mode)
  local proto = {}
  setmetatable(proto, self)
  proto:init(mode)
  return proto
end

function csprotoData:getUpCsproto()
  return self.upmsg
end

function csprotoData:getCsprotoMode()
  return self.mode
end

function csprotoData:getCsprotoByteNum()
  return self.packHeadByteNum
end

function csprotoData:isEncryption()
  return self.encryption
end

function csprotoData:newUpCsproto()
  local upmsg = self:getUpCsproto()
  local rawmsg = upmsg[self.upMsgName]()
  return self:csprotoUpWrapper(rawmsg)
end

function csprotoData:csprotoUpWrapper(msg)
  local mode = self.mode
  if mode == NetMode.systemdev then
    msg._repeat = 0
    msg._user_id = ed.getUserid()
    msg._sequence = self.netSequence
  end
  return msg
end

function csprotoData:getDownCsproto()
  return self.downmsg
end

function csprotoData:newDownCsproto()
  local downmsg = self:getDownCsproto()
  local rawmsg = downmsg[self.downMsgName]()
  return self:csprotoDownWrapper(rawmsg)
end

function csprotoData:csprotoDownWrapper(msg)
  return msg
end

function csprotoData:parseDownMsg(buffer)
  self.netSequence = self.netSequence + 1
  local downCsproto = self:newDownCsproto()
  if downCsproto then
    return downCsproto:Parse(buffer)
  end
end
