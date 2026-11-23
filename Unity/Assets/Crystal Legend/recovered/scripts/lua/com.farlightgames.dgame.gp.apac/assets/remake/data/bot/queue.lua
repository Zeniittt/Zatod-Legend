module("ed.bot", package.seeall)
Quene = {}
Quene.__index = Quene

function Quene.create(capcity)
  local queue = {
    capcity = capcity,
    head = 1,
    size = 0,
    array = {}
  }
  setmetatable(queue, Quene)
  return queue
end

function Quene:destory()
  local size = self.size
  local head = self.head
  local capcity = self.capcity
  local array = self.array
  for count = 1, size do
    array[(size + head) % capcity] = nil
    head = head + 1
  end
  self.size = 0
  self.head = 1
end

function Quene:full()
  return self.size >= self.capcity
end

function Quene:push(ele)
  if self:full() then
    print("push to full queue")
    return false
  end
  local size = self.size
  local array = self.array
  local head = self.head
  local capcity = self.capcity
  array[(head + size) % capcity] = ele
  self.size = size + 1
  return self.size
end

function Quene:pull()
  if self.size == 0 then
    print("get ele from empty queue")
    return false
  end
  local array = self.array
  local head = self.head
  local ele = array[head]
  array[head] = nil
  self.head = (head + 1) % self.capcity
  self.size = self.size - 1
  return ele
end
