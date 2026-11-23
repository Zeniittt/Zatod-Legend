function clone(object)
  local lookup_table = {}
  
  local function _copy(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for key, value in pairs(object) do
      new_table[_copy(key)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  
  return _copy(object)
end

local objectCount = 0

local function getObjectCount()
  objectCount = objectCount + 1
  return objectCount
end

function class(classname, super)
  local superType = type(super)
  local cls
  if superType ~= "function" and superType ~= "table" then
    superType = nil
    super = nil
  end
  if superType == "function" or super and super.__ctype == 1 then
    cls = {}
    if superType == "table" then
      for k, v in pairs(super) do
        cls[k] = v
      end
      cls.__create = super.__create
      cls.super = super
    else
      cls.__create = super
      
      function cls.ctor()
      end
    end
    cls.__cname = classname
    cls.__ctype = 1
    
    function cls:new(...)
      local instance = cls.__create(...)
      instance.id = getObjectCount()
      if cls ~= TFLabel then
        for k, v in pairs(cls) do
          instance[k] = v
        end
      end
      instance.class = cls
      instance:ctor(...)
      return instance
    end
  else
    if super then
      cls = clone(super)
      cls.super = super
    else
      cls = {
        ctor = function()
        end
      }
    end
    cls.__cname = classname
    cls.__ctype = 2
    cls.__index = cls
    
    function cls:new(...)
      local instance = {}
      instance.id = getObjectCount()
      instance.class = cls
      setmetatable(instance, cls)
      instance:ctor(...)
      return instance
    end
  end
  
  function cls:create(...)
    return cls:new(...)
  end
  
  return cls
end

function instanceOf(cls)
  if cls and type(cls) == "table" and cls.__cname then
    return cls.__cname
  end
  return NONE_CLASS
end

function iskindof(obj, className)
  local t = type(obj)
  if t == "table" then
    local mt = getmetatable(obj)
    while mt and mt.__index do
      if mt.__index.__cname == className then
        return true
      end
      mt = mt.super
    end
    return false
  elseif t == "userdata" then
  else
    return false
  end
end

function CLASS(classname, super)
  local superType = type(super)
  local cls, set_funcs, get_funcs
  if super then
    cls = setmetatable({}, {
      __index = super,
      __call = super.__call
    })
    cls.super = super
  else
    local function __GSCall(handle, name)
      return function(call)
        if call then
          local func = handle
          
          local function changeHandle(self, val)
            val = call(self, val) or val
            local ret = func(self, val)
            return ret
          end
          
          cls[name] = changeHandle
        end
      end
    end
    
    local __GSMT = {
      get = function(name)
        local handle, fname = Getter(cls, name)
        return __GSCall(handle, fname)
      end,
      set = function(name)
        local handle, fname = Setter(cls, name)
        return __GSCall(handle, fname)
      end
    }
    __GSMT.__index = __GSMT
    cls = setmetatable({
      ctor = function()
      end,
      _define = function()
      end
    }, __GSMT)
  end
  cls.__cname = classname
  local func
  set_funcs = setmetatable({}, {
    __index = function(t, k)
      func = cls["set__" .. k]
      if func then
        rawset(t, k, func)
      end
      return func
    end
  })
  get_funcs = setmetatable({}, {
    __index = function(t, k)
      func = cls["get__" .. k]
      if func then
        rawset(t, k, func)
      end
      return func
    end
  })
  
  function cls.__newindex(o, k, v)
    func = set_funcs[k]
    if func then
      func(o, v)
    else
      rawset(o, k, v)
    end
  end
  
  function cls.__index(o, k)
    func = get_funcs[k]
    if func then
      return func(o, k)
    end
    local ret = cls[k]
    if ret then
      rawset(o, k, ret)
      return ret
    end
    return rawget(o, k)
  end
  
  function cls:new(...)
    local instance = setmetatable({}, cls)
    instance.id = getObjectCount()
    instance.class = cls
    local funcs = {}
    local super = cls
    while super do
      if super.super == nil or super._define ~= super.super._define then
        super._define(instance, ...)
      end
      if super.super == nil or super.ctor ~= super.super.ctor then
        table.insert(funcs, 1, super.ctor)
      end
      super = super.super
    end
    for i = 1, #funcs do
      funcs[i](instance, ...)
    end
    return instance
  end
  
  function cls:create(...)
    return self:new(...)
  end
  
  function cls:isClass(classObj)
    local cls = self.class
    while cls do
      if cls == classObj then
        return true
      end
      cls = cls.super
    end
    return false
  end
  
  return cls
end

Component = CLASS

function Getter(cls, name)
  local function func(self, val)
    return self[name]
  end
  
  local fname = "get__" .. name:title()
  cls[fname] = func
  return func, fname
end

function Setter(cls, name)
  local function func(self, val)
    self[name] = val
  end
  
  local fname = "set__" .. name:title()
  cls[fname] = func
  return func, fname
end

function GSetter(cls, name)
  Setter(cls, name)
  Getter(cls, name)
end
