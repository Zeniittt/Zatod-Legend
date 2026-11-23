Stack = {}

function Stack:new()
  local obj = {
    list = {}
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Stack:stackTop()
  return self:size()
end

function Stack:size()
  return #self.list
end

function Stack:currentView()
  return self.list[self:stackTop()]
end

function Stack:push(node)
  self.list[self:stackTop() + 1] = node
  EDLog("stack top:: " .. self:stackTop())
end

function Stack:pop()
  local node = table.remove(self.list, self:stackTop())
  EDLog("stack top ::" .. self:stackTop())
  return node.view
end
