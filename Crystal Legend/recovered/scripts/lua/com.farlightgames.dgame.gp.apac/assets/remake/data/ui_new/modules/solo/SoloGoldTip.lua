local base = ed.ui.popwindow
local SoloGoldTip = newclass(base.mt)
ed.ui.SoloGoldTip = SoloGoldTip

function SoloGoldTip:initUI()
  ed.editorui(ed.uieditor.SoloGoldTip, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelDimensions(self.ui.Label_626_Copy1, CCSizeMake(155, 0))
  ed.setLabelDimensions(self.ui.Label_626_Copy6, CCSizeMake(155, 0))
  ed.setLabelDimensions(self.ui.Label_626_Copy7, CCSizeMake(155, 0))
  ed.setLabelDimensions(self.ui.Label_626_Copy8, CCSizeMake(155, 0))
  ed.setLabelDimensions(self.ui.Label_626_Copy9, CCSizeMake(155, 0))
end

function SoloGoldTip.create()
  local self = base.create("SoloGoldTip", {
    notBlurBg = true,
    noShade = true,
    priority = -999,
    swallow = true
  })
  setmetatable(self, SoloGoldTip.mt)
  self:initUI()
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "gold_tip_destroy",
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end
  })
  self:popWindow()
  return self
end
