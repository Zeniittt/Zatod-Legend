local base = ed.ui.basetouchnode
local class = newclass(base.mt)
ed.ui.basenode = class

local function create(nodeIdentity, param)
  local self = base.btCreate("basenode")
  setmetatable(self, class.mt)
  self.nodeIdentity = nodeIdentity
  return self
end

class.create = create
