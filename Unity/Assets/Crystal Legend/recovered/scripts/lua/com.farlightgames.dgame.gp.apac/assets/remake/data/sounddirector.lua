sounddirector = {}

function sounddirector:instance()
  local o = _G.soundDirector
  if o then
    return o
  end
  o = {}
  _G.soundDirector = o
  setmetatable(o, self)
  self.__index = self
  return o
end
