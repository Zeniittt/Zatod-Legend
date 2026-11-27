local ed = ed
module("ed.ui", package.seeall)
SuperAwakeLsr = {}
SuperAwakeLsr.__index = SuperAwakeLsr
ed.ui.superawakelsr = SuperAwakeLsr
local base = ed.ui.baselsr
setmetatable(SuperAwakeLsr, base.mt)

function SuperAwakeLsr.create()
  local self = base.create("superawakelsr")
  setmetatable(self, SuperAwakeLsr)
  return self
end

function SuperAwakeLsr:clickButton()
  ed.playEffect(ed.sound.superawake.clickButton)
end

function SuperAwakeLsr:openWindow()
  ed.playEffect(ed.sound.superawake.clickButton)
end

function SuperAwakeLsr:closeWindow()
  ed.playEffect(ed.sound.superawake.clickButton)
end

function SuperAwakeLsr:showSuperAwake()
  ed.playEffect(ed.sound.superawake.showSuperAwake)
end
