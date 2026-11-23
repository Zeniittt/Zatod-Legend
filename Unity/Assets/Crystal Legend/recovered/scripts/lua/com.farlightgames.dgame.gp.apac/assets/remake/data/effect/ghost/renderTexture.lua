local ed = ed
local RenderTexture = {}
RenderTexture.__index = RenderTexture

function RenderTexture:new(width, height)
  local cls = {
    rt = nil,
    width = width or 100,
    height = height or 100
  }
  setmetatable(cls, self)
  cls.rt = CCRenderTexture:create(cls.width, cls.height)
  cls.rt:retain()
  return cls
end

function RenderTexture:begin()
  self.rt:beginWithClear(0, 0, 0, 0)
end

function RenderTexture:endToLua()
  self.rt:endToLua()
end

function RenderTexture:getRetainCount()
  return self.rt:retainCount()
end

function ed.RenderTextureCreate(width, height)
  return RenderTexture:new(width, height)
end
