local Trigger = {}
Trigger.Func = nil

function Trigger:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Trigger:Check(event, ...)
  return self.Func(event, self, ...)
end

Responser = {}
Responser.Func = nil
Responser.Filter = nil

function Responser:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Responser:Fire(fireData, ...)
  if fireData == nil then
    self.Func(...)
  else
    self.Func(fireData, ...)
  end
end

Event = {}

function Event:Error(title, msg)
  print("Error:" .. title .. msg)
end

function Event:new()
  local object = {}
  setmetatable(object, self)
  self.__index = self
  object.ResponserSize = 0
  object.Scopes = {}
  object.Triggers = list:new()
  object.ExtraData = nil
  return object
end

function Event:Bind(exe, scope)
  if nil == exe or nil == scope then
    return
  end
  local newExe = exe
  if type(exe) == "function" then
    newExe = Responser:new()
    newExe.Func = exe
  end
  scope[self.Name] = (scope[self.Name] or 0) + 1
  self.ResponserSize = self.ResponserSize + 1
  self.Scopes[scope] = self.Scopes[scope] or {}
  table.insert(self.Scopes[scope], newExe)
end

function Event:UnBind(exe, scope)
  if nil == exe or nil == scope then
    return
  end
  local isFunc = type(exe) == "function"
  for k, responser in ipairs(self.Scopes[scope] or {}) do
    if isFunc == true and responser.Func == exe or isFunc == false and responser == exe then
      scope[self.Name] = scope[self.Name] - 1
      self.ResponserSize = self.ResponserSize - 1
      table.remove(self.Scopes[scope], k)
      return
    end
  end
end

function Event:CloseScope(scope)
  if self.Scopes[scope] ~= nil then
    scope[self.Name] = 0
    self.ResponserSize = self.ResponserSize - #self.Scopes[scope]
    self.Scopes[scope] = nil
  end
end

function Event:Fire(...)
  if not self:Check(...) then
    return false
  end
  for _, funcs in pairs(self.Scopes) do
    for _, responser in ipairs(funcs) do
      if responser ~= nil then
        responser:Fire(self.ExtraData, ...)
      end
    end
  end
  return true
end

function Event:BindTrigger(func)
  if func == nil then
    return
  end
  local newTrigger = func
  if type(func) == "function" then
    newTrigger = Trigger:new()
    newTrigger.Func = func
  end
  self.Triggers:push_back(newTrigger)
end

function Event:UnbindTrigger(func)
  if func == nil then
    return
  end
  local isFunc = type(func) == "function"
  for _trigger, itr in rilist(self.Triggers) do
    if _trigger ~= nil and (isFunc == true and _trigger.Func == func or isFunc == false and _trigger == func) then
      self.Triggers:erase(itr)
      return
    end
  end
end

function Event:Check(...)
  for trigger in ilist(self.Triggers) do
    if trigger ~= nil then
      local bOk, bResult = pcall(trigger.Check, trigger, self, ...)
      if not bOk then
        self:Error("Trigger", bResult)
        return false
      end
      if not bResult then
        return false
      end
    end
  end
  return true
end

function Event:ResponserCount()
  return self.ResponserSize
end

function Event:TriggerCount()
  return self.Triggers:size()
end
