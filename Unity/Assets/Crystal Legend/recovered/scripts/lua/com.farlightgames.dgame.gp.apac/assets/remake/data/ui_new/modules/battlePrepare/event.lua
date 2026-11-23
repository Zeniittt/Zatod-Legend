module("ed.battleprepare", package.seeall)
EventList = {}
EventList.__index = EventList

function EventList:new()
  local obj = {}
  setmetatable(obj, self)
  return obj
end

function EventList:bindEvent(eventType, func)
  if not self[eventType] then
    self[eventType] = {}
  end
  table.insert(self[eventType], func)
end

function EventList:sendEvent(eventType, ...)
  local list = self[eventType]
  if not eventType then
    print("eventType can not be nil")
    return
  end
  if not list then
    print("can not find event with the type " .. eventType)
    return
  end
  for k, func in pairs(list) do
    func(...)
  end
end

function WaitEvent(eventType, func)
  if not eventType then
    print("eventType can not be nil ")
    return
  end
  if not func then
    print("function can not be nil")
  end
  local eventList = EventStack:getStackTop()
  eventList:bindEvent(eventType, func)
end

function SendEvent(eventType, ...)
  local eventList = EventStack:getStackTop()
  eventList:sendEvent(eventType, ...)
end
