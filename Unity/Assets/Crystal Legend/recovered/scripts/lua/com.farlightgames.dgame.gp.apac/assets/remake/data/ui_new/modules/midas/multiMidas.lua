local base = ed.ui.popwindow
local multiMidas = newclass(base.mt)
ed.ui.multiMidas = multiMidas

function multiMidas.create(params)
  local self = base.create("multiMidas")
  setmetatable(self, multiMidas.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function multiMidas:initData(params)
  self.params = params
end

function multiMidas:initLabels()
  ed.setLabelStroke(self.ui.label_title, ccc3(245, 221, 183), 1)
  ed.setLabelShadow(self.ui.Label_4438, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_diamond, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_money, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_cancle, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_use, ccc3(0, 0, 0), ccp(0, 2))
end

function multiMidas:initUI()
  local container, ui = ed.editorui(ed.uieditor.MidasTip, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.Label_4438, string.format(T("\232\191\158\231\187\173\228\189\191\231\148\168%d\230\172\161\231\130\185\233\135\145\230\137\139"), self.params.count))
  ed.setString(self.ui.label_diamond, string.format("x%d", self.params.cost))
  ed.setString(self.ui.label_money, string.format("x%d", self.params.acquire))
end

function multiMidas:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_use", function()
    self.params.parent:doUse(self.params.count)
    self:destroy()
  end, {pressScale = 0.9})
end
