local network_queue = {}
network_queue.__index = network_queue
ed.network_queue = network_queue

function network_queue.create()
  local self = {}
  setmetatable(self, network_queue)
  self:init()
  return self
end

function network_queue:init()
  self.headObj = {next = nil}
  self.length = 0
end

function network_queue:enterQueue(newData)
  if not newData then
    EDLog("enter queue data is nil")
    return
  end
  local obj = self.headObj
  while true do
    if obj.next then
      obj = obj.next
    else
      obj.next = {next = nil, data = newData}
      break
    end
  end
  self.length = self.length + 1
end

function network_queue:outQueue()
  if self.length < 1 then
    return nil
  end
  if self.headObj.next == nil then
    self.length = 0
    return nil
  end
  local obj = self.headObj.next
  self.headObj.next = obj.next
  self.length = self.length - 1
  return obj.data
end

function network_queue:findObj(index)
  if type(index) ~= "number" then
    return nil
  end
  if index < 1 then
    return nil
  end
  if index > self.length then
    return nil
  end
  local obj = self.headObj
  for i = 2, index do
    obj = obj.next
  end
  return obj.next.data
end

function network_queue:isEmpty()
  if self.length < 1 then
    return true
  end
  return false
end

function network_queue:getlength()
  return self.length
end

function network_queue:printAllObj()
  for i = 1, self.length do
    print(i, self:findObj(i))
  end
end

function network_queue:checkDataIsSame(checkData, targetData)
  if not (checkData and targetData) or checkData[".data"] then
    return false
  end
  local isSame = true
  checkData = checkData[".data"]
  if not checkData then
    return false
  end
  for k, _ in pairs(checkData) do
    local value
    local ok = pcall(function()
      value = targetData[k]
    end)
    if not ok then
      isSame = false
      break
    end
    if not value then
      isSame = false
      break
    end
  end
  return isSame
end
