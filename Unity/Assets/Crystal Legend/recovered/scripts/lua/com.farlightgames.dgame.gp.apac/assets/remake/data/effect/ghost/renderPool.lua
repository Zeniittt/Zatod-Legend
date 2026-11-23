local ed = ed
local RenderPool = {}
RenderPool.__index = RenderPool

function RenderPool:new(num, width, height)
  local cls = {
    pool = {},
    index = 0,
    num = num or 5,
    width = width,
    height = height
  }
  setmetatable(cls, self)
  for i = 1, cls.num do
    table.insert(cls.pool, ed.RenderTextureCreate(cls.width, cls.height))
  end
  return cls
end

function RenderPool:getRender()
  self.index = self.index + 1
  if self.index > self.num then
    self.index = 1
  end
  return self.pool[self.index]
end

function RenderPool:clearPool()
  for _, rt in ipairs(self.pool) do
    rt.rt:release()
  end
end

function ed.RenderPoolCreate(num, width, height)
  return RenderPool:new(num, width, height)
end
