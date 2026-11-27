module("Sequence", package.seeall)
local seq_keys
ClipMeta = {}
ClipMeta.__index = ClipMeta
setmetatable(ClipMeta, {__index = _G})

function ClipMeta:__Error(errorTitle, errorMsg)
  EDLog("Clip(" .. (self.Name or "") .. ")" .. errorTitle .. ":" .. errorMsg)
end

function ClipMeta.SequenceKey(key)
  return seq_keys[key]
end

local ClipMap = {}

function _G.SequenceClip(name, type)
  name = tostring(name)
  local clip = {}
  clip.name = name
  setmetatable(clip, ClipMeta)
  ClipMap[name] = clip
  setfenv(2, clip)
end

Clip = {}
Clip.__index = Clip

function Clip.Create(type, ...)
  local def = ClipMap[type]
  if def == nil then
    EDLog("SequenceClip type '" .. tostring(type) .. "'not defined")
    return nil
  end
  local clip = {}
  setmetatable(clip, Clip)
  clip.symbol = "Sequence.Clip"
  clip.type = type
  clip.data = {
    ...
  }
  clip.def = def
  clip.block = true
  if def.OnCreate ~= nil then
    seq_keys = clip.keys or seq_keys
    def.OnCreate(clip.data, ...)
  end
  return clip
end

function Clip:Remove()
  local def = self.def.OnRemove
  if def ~= nil then
    seq_keys = self.keys or seq_keys
    def(self.data)
  end
end

function Clip:Enter()
  local def = self.def.OnEnter
  if def ~= nil then
    seq_keys = self.keys or seq_keys
    def(self.data)
  end
  self.block = true
end

function Clip:Leave()
  local def = self.def.OnLeave
  if def ~= nil then
    seq_keys = self.keys or seq_keys
    def(self.data)
  end
  self.block = true
end

function Clip:Update(delta)
  seq_keys = self.keys or seq_keys
  local def
  if self.block then
    def = self.def.OnBlock
    if def ~= nil then
      if not def(self.data, delta) then
        self.block = false
        def = self.def.OnUnblock
        return false, def ~= nil and def(self.data, 0)
      else
        return true, false
      end
    else
      self.block = false
    end
  end
  def = self.def.OnUnblock
  return false, def ~= nil and def(self.data, delta)
end

function Clip:CallInterface(func, ...)
  local def = self.def
  if def[func] == nil then
    EDLog("SequenceClip '" .. tostring(self.type) .. "' has no function with name '" .. tostring(func) .. "'")
    return
  end
  seq_keys = self.keys or seq_keys
  return def[func](self.data, ...)
end
