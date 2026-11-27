local SystemEvent = Event:new()
SystemEvent.Name = ""
SystemEvent.Timer = nil

function SystemEvent:SetTimer(timer)
  self.Timer = timer
end

function SystemEvent:Update(deltTime)
  local timer = self.Timer
  if timer == nil then
    return false
  end
  if timer.AlwaysRepeat == true then
    timer:UpdateAlways(self, deltTime)
  elseif timer.RepeatCount > 0 then
    timer:UpdateTimes(self, deltTime)
  elseif timer.RepeatCount <= 0 then
    return true
  end
  return false
end

function SystemEvent:Print()
  print("event name:" .. self.Name)
  print("      scopes:" .. self:ResponserCount())
  print("      triggers:" .. self:TriggerCount())
  if self.Timer ~= nil then
    print("event Timer:")
    print("      Interval:" .. self.Timer.Interval)
    print("      RepeatCount:" .. self.Timer.RepeatCount)
    print("      AlwaysRepeat:" .. tostring(self.Timer.AlwaysRepeat))
    print("      CurTime:" .. self.Timer.CurTime)
  end
end

Timer = {}
Timer.Interval = 0
Timer.RepeatCount = 0
Timer.AlwaysRepeat = false
Timer.CurTime = 0
Timer.TotalTime = 0
Timer.Name = nil

function Timer:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Timer:getName()
  return self.Name
end

function Timer:setName(name)
  self.Name = name
end

function Timer:Clone()
  local newTimer = Timer:new()
  newTimer.Interval = self.Interval
  newTimer.AlwaysRepeat = self.AlwaysRepeat
  if not self.AlwaysRepeat then
    newTimer.RepeatCount = self.RepeatCount
  end
  return newTimer
end

function Timer:Always(interval, name)
  if interval == nil then
    interval = 0
  end
  local timer = Timer:new()
  timer.Interval = interval
  timer.AlwaysRepeat = true
  timer.Name = name
  return timer
end

function Timer:Times(interval, count)
  local timer = Timer:new()
  timer.Interval = interval
  timer.AlwaysRepeat = false
  timer.RepeatCount = count
  return timer
end

function Timer:Once(interval, name)
  local timer = Timer:Times(interval, 1)
  timer.Name = name
  return timer
end

function Timer:UpdateTimes(event, deltTime)
  self:Update(deltTime)
  if self.CurTime >= self.Interval then
    if event ~= nil and event:Fire(self.CurTime, self.TotalTime, self.Interval) then
      self.RepeatCount = self.RepeatCount - 1
    end
    self.CurTime = 0
  end
end

function Timer:UpdateAlways(event, deltTime)
  self:Update(deltTime)
  if self.CurTime >= self.Interval then
    if event ~= nil then
      event:Fire(self.CurTime, self.TotalTime, self.Interval)
    end
    self.CurTime = 0
  end
end

function Timer:Update(deltTime)
  self.CurTime = self.CurTime + deltTime
  self.TotalTime = self.TotalTime + deltTime
end

function Timer:CanTigger()
  if self.CurTime >= self.Interval then
    self.CurTime = 0
    if self.AlwaysRepeat then
      return true
    end
    if 0 < self.RepeatCount then
      self.RepeatCount = self.RepeatCount - 1
      return true
    end
  end
  return false
end

local EventSystem = {}
local NeedUpdateEvents = {}
local NoNeedUpdateEvents = {}
local NewCreatedEvents = {}
local UpdateInternal = 0.01
local UpdatePassTime = 0

local function ChangeEventToTable(event, newTab)
  local name = event.Name
  local oldTab
  if NeedUpdateEvents[name] == event then
    oldTab = NeedUpdateEvents
  elseif NoNeedUpdateEvents[name] == event then
    oldTab = NoNeedUpdateEvents
  elseif NewCreatedEvents[name] == event then
    oldTab = NewCreatedEvents
  end
  if oldTab == newTab then
    return
  end
  if oldTab ~= nil then
    oldTab[name] = nil
  end
  if newTab ~= nil then
    newTab[name] = event
  end
end

local function SystemEventDispatcher(event)
  if event == nil then
    return
  end
  if event.Timer ~= nil and event:ResponserCount() > 0 then
    ChangeEventToTable(event, NeedUpdateEvents)
  elseif event:ResponserCount() > 0 then
    ChangeEventToTable(event, NoNeedUpdateEvents)
  elseif event.Timer ~= nil or 0 < event:TriggerCount() then
    ChangeEventToTable(event, NewCreatedEvents)
  else
    ChangeEventToTable(event, nil)
  end
end

function EventSystem.CreateEvent(name)
  local event = EventSystem.Find(name)
  if nil == event then
    event = SystemEvent:new()
    event.Name = name
    ChangeEventToTable(event, NewCreatedEvents)
  end
  return event
end

function EventSystem.CloseEvent(name)
  local event = EventSystem.Find(name)
  if nil == event then
    return
  end
  ChangeEventToTable(event, nil)
end

function EventSystem.CloseScope(scope)
  if nil == scope then
    return
  end
  for name, time in pairs(scope) do
    local event = EventSystem.Find(name)
    if nil ~= event and 0 ~= time then
      event:CloseScope(scope)
      SystemEventDispatcher(event)
    end
  end
end

function EventSystem.Find(name)
  if nil == name then
    return nil
  end
  if NeedUpdateEvents[name] ~= nil then
    return NeedUpdateEvents[name]
  end
  if NoNeedUpdateEvents[name] ~= nil then
    return NoNeedUpdateEvents[name]
  end
  if NewCreatedEvents[name] ~= nil then
    return NewCreatedEvents[name]
  end
  return nil
end

function EventSystem.Bind(name, func, scope)
  local event = EventSystem.Find(name)
  if nil == event then
    return false
  end
  event:Bind(func, scope)
  SystemEventDispatcher(event)
  return true
end

function EventSystem.UnBind(name, func, scope)
  local event = EventSystem.Find(name)
  if nil == event then
    return false
  end
  event:UnBind(func, scope)
  SystemEventDispatcher(event)
  return true
end

function EventSystem.Fire(name, ...)
  local event = EventSystem.Find(name)
  if nil == event then
    return false
  end
  event:Fire(...)
  return true
end

function EventSystem.BindTrigger(name, func)
  local event = EventSystem.Find(name)
  if nil == event then
    return false
  end
  event:BindTrigger(func)
  SystemEventDispatcher(event)
  return true
end

function EventSystem.UnbindTrigger(name, func)
  local event = EventSystem.Find(name)
  if nil == event then
    return false
  end
  event:UnbindTrigger(func)
  SystemEventDispatcher(event)
  return true
end

function EventSystem.SetTimer(name, timer)
  local event = EventSystem.Find(name)
  if nil == event then
    return false
  end
  event:SetTimer(timer)
  SystemEventDispatcher(event)
  return true
end

local CopyNeedUpdateEvents = {}

function EventSystem.Update(deltTime)
  UpdatePassTime = deltTime + UpdatePassTime
  if UpdatePassTime < UpdateInternal then
    return
  end
  CopyNeedUpdateEvents = {}
  for name, event in pairs(NeedUpdateEvents) do
    CopyNeedUpdateEvents[name] = event
  end
  for name, event in pairs(CopyNeedUpdateEvents) do
    local delete = event:Update(UpdatePassTime)
    if delete then
      EventSystem.CloseEvent(name)
    end
  end
  CopyNeedUpdateEvents = {}
  UpdatePassTime = 0
end

local GlobleScope = {}

function PrintEventAll()
  EDLog("+++++++++ NeedUpdateEvents: ")
  for _, event in pairs(NeedUpdateEvents) do
    event:Print()
    EDLog(" ")
  end
  EDLog("+++++++++ NoNeedUpdateEvents: ")
  for _, event in pairs(NoNeedUpdateEvents) do
    event:Print()
    EDLog(" ")
  end
  EDLog("+++++++++ NewCreatedEvents: ")
  for _, event in pairs(NewCreatedEvents) do
    event:Print()
    EDLog(" ")
  end
end

function UpdateEventSystem(deltTime)
  EventSystem.Update(deltTime)
  ExcuteDelayProcessQueue()
end

function FireEvent(name, ...)
  return EventSystem.Fire(name, ...)
end

function PrintEvent(name)
  local event = EventSystem.Find(name)
  if event ~= nil then
    return event:Print()
  end
end

function ListenEvent(eventType, func, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("listen event no scope")
    return nil
  end
  if nil == eventType then
    print("listen event no event")
    return nil
  end
  if nil == func then
    print("listen event no func")
    return nil
  end
  local event = EventSystem.CreateEvent(eventType)
  if event ~= nil then
    EventSystem.Bind(eventType, func, scope)
  end
  return event
end

function ListenEventOnce(eventType, func, scope)
  scope = scope or GlobleScope
  local wrap_func
  
  function wrap_func(...)
    func(...)
    StopListenEvent(eventType, wrap_func, scope)
  end
  
  return ListenEvent(eventType, wrap_func, scope)
end

function StopListenEvent(eventType, func, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("listen event no scope")
    return nil
  end
  if nil == eventType then
    print("listen event no event")
    return nil
  end
  if nil == func then
    print("listen event no func")
    return nil
  end
  return EventSystem.UnBind(eventType, func, scope)
end

function AddTriggerEvent(eventType, timer, trigger, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("add Trigger no scope")
    return nil
  end
  if nil == eventType then
    print("add Trigger no eventname")
    return nil
  end
  if nil == timer then
    print("add Trigger no timer")
    return nil
  end
  local event = EventSystem.CreateEvent(eventType)
  if nil == event then
    return nil
  end
  EventSystem.SetTimer(eventType, timer)
  EventSystem.BindTrigger(eventType, trigger)
  return event
end

function CloseEvent(name)
  EventSystem.CloseEvent(name)
end

function ListenTimer(timer, func, scope)
  scope = scope or GlobleScope
  if nil == scope then
    print("listen timer no scope")
    return nil
  end
  if nil == timer then
    print("listen timer no timer")
    return nil
  end
  if nil == func then
    print("listen timer no func")
    return nil
  end
  local name = timer:getName() and timer:getName() or "Timer_" .. tostring(timer)
  local event = EventSystem.CreateEvent(name)
  if event ~= nil then
    EventSystem.Bind(name, func, scope)
  end
  EventSystem.SetTimer(name, timer)
  return event
end

function CloseTimer(name)
  EventSystem.CloseEvent(name)
end

function CloseScope(scope)
  EventSystem.CloseScope(scope)
end
