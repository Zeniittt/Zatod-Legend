local base = ed.ui.popwindow
local currencyDetailWin = newclass(base.mt)
ed.ui.currencyDetailWin = currencyDetailWin

function currencyDetailWin.create()
  local self = base.create("currencyDetailWin")
  setmetatable(self, currencyDetailWin.mt)
  self.serviceSettingOption = serviceSettingOption
  self:init()
  self:show()
  return self
end

function currencyDetailWin:init()
  self:initView()
  self:addEventListener()
  self:registerTouchHandlers()
end

function currencyDetailWin:initView()
  local container, ui = ed.editorui(ed.uieditor.currencyDetailWin)
  self.ui = ui
  self.container:addChild(container)
  self.ui.label_pay_val:setPositionX(self.ui.pay_des:getPositionX() + self.ui.pay_des:getContentSize().width + 15)
  self.ui.label_free_val:setPositionX(self.ui.free_des:getPositionX() + self.ui.free_des:getContentSize().width + 15)
  ed.setLabelString(self.ui.label_pay_val, ed.player._rmb_pay or 0)
  ed.setLabelString(self.ui.label_free_val, ed.player._rmb_free or 0)
end

function currencyDetailWin:addEventListener()
end

function currencyDetailWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
