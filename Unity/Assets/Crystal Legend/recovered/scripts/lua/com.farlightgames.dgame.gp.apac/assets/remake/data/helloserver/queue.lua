local class = {
  mt = {}
}
Queue = class
class.mt.__index = class

function Queue.create(capcity)
  local self = {
    capcity = capcity,
    head = 1,
    size = 0
  }
  setmetatable(self, class.mt)
  return self
end

function Queue:full()
  return self.size >= self.capcity
end

function Queue:push(obj)
  local size = self.size
  local capcity = self.capcity
  if size >= capcity then
    EDDebug("Push to full queue!")
    return false
  end
  self[(self.head + size) % capcity] = obj
  size = size + 1
  self.size = size
  return size
end

function Queue:get()
  if self.size == 0 then
    return false
  end
  return self[self.head]
end

function Queue:pull()
  if self.size == 0 then
    EDDebug("Pull from empty queue!")
    return false
  end
  local head = self.head
  local capcity = self.capcity
  local ret = self[head]
  self[head] = nil
  self.head = (head + 1) % capcity
  self.size = self.size - 1
  return ret
end
