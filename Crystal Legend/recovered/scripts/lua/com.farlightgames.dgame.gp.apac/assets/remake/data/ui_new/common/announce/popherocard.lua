local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.popHeroCard = class

local function create(param)
  local self = base.create("popHeroCard")
  setmetatable(self, base.mt)
  local id = param.id
  local amount = param.amount
  local priority = param.priority
  local callback = param.callback
  local star = param.star
  
  local function getHandler()
    local function handler()
      if callback then
        callback(id)
      end
      self:destroy()
    end
    
    return handler
  end
  
  local cardWindow = ed.ui.popherocard.create({
    id = id,
    amount = amount,
    star = star,
    handler = getHandler(),
    priority = priority
  })
  self.mainLayer:addChild(cardWindow.mainLayer)
  self:cancelTouchLayer()
  return self
end

class.create = create
