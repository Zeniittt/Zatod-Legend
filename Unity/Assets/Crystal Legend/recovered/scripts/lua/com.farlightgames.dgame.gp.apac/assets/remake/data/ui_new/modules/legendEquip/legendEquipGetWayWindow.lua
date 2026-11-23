local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipGetWayWindow = class
ed.UITool.registViewOpenFunc("legendEquipGetWayWindow", function()
  local window = ed.ui.legendEquipGetWayWindow.create()
  window:popWindow()
  window:show()
end)

function class.create()
  local self = base.create("legendEquipGetWayWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_get_way_window)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tips_1, ed.toccc3(1380109), 1)
  ed.setLabelStroke(self.ui.label_tips_2, ed.toccc3(1380109), 1)
  ed.setLabelStroke(self.ui.label_get_way, ed.toccc3(1380109), 1)
  ed.setLabelShadow(self.ui.label_close, ccc3(0, 0, 0), ccp(0, 2))
end

function class:onClickGetWay()
  ed.UITool.openView("fireForgeMainScene")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_get_way", function()
    self:onClickGetWay()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
