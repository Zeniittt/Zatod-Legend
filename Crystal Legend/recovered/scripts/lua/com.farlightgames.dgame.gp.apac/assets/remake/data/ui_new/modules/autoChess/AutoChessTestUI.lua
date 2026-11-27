local base = ed.ui.commonscene
local AutoChessTestUI = newclass(base.mt)
ed.ui.AutoChessTestUI = AutoChessTestUI

function AutoChessTestUI.create()
  local self = base.create("AutoChessTestUI", {noBottomButton = true})
  setmetatable(self, AutoChessTestUI.mt)
  self:initUI()
  return self
end

function AutoChessTestUI:initUI()
  local container, ui = ed.editorui({})
  self.mainLayer:addChild(container)
  self.ui = ui
  ed.ui.logo.loadShaders()
  self:registerOnEnterHandler("onEnter", function()
    ReloadModule("ui_new/modules/kingsPvp/kingsRecordDetail3Win")
    ed.ui.KingsRecordDetail3Win.create()
  end)
end
