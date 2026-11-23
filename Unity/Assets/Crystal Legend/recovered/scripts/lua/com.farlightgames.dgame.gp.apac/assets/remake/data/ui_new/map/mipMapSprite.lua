local class = newclass()
ed.mipSprite = class

function class.create(resources)
  local self = {}
  self.what = "mipSprite"
  self.scale = 1
  self.localScale = 1
  self.parent = nil
  self.childrens = {}
  setmetatable(self, class.mt)
  return self
end

function class:updateScale(changeFactor)
  self.scale = changeFactor
  for k, child in ipairs(self.childrens) do
    child:updateScale(changeFactor)
  end
end

function class:setScale(scale)
  local changeFactor = self.localScale / scale
  self.scale = self.scale * changeFactor
  self.localScale = scale
  for k, child in ipairs(self.childrens) do
    child:updateScale(changeFactor)
  end
end

function class:setParent(node)
  self.parent = node
end

function class:addChild(node)
  if not ed.ed.isElementInTable(node, self.childrens) then
    node:setParent(self)
    table.insert(self.childrens, node)
  end
end
