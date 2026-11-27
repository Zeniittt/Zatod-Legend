module("ed.battleprepare", package.seeall)
EventStack = {}
EventStack.list = {}
EventStack.index = 0

function EventStack:size()
  return self.index
end

function EventStack:getStackTop()
  return self.list[self.index]
end

function EventStack:push(event)
  self.index = self.index + 1
  self.list[self.index] = event
end

function EventStack:pop()
  local top = self.list[self.index]
  self.index = self.index - 1
  return top
end
