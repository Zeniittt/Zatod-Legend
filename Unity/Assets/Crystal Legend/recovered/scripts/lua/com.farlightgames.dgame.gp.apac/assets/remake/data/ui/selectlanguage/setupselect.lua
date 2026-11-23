local base = ed.ui.basescene
local class = newclass(base.mt)
ed.selectlanguage.setupselect = class

local function create()
  local self = base.create("setupSelectLanguage")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  local bg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/splash.jpg"
    },
    layout = {
      position = ccp(400, 240)
    }
  }, mainLayer)
  return self
end

class.create = create
