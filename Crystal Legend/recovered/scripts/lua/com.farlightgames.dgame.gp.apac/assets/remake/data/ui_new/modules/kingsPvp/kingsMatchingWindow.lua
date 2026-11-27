local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsMatchingWindow = class
class.NUM_TO_STRING = {
  [0] = "...",
  [1] = ".",
  [2] = ".."
}
ed.UITool.registViewOpenFunc("kingsMatchingWindow", function(param)
  local window = ed.ui.kingsMatchingWindow.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("kingsMatchingWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class.close()
  local window = ed.getPopWindow("kingsMatchingWindow")
  if window then
    window:destroy()
  end
end

function class:init(param)
  param = param or {}
  self.selectModeCB = param.selectModeCB
  self.matchTime = 0
  self:initView()
  self:addTouchEvent()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsMatchingWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:startCountDown()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(5188880), 1)
end

function class:startCountDown()
  self:listenTimer(Timer:Always(1), function()
    self:refreshTime()
  end)
end

function class:refreshTime()
  self.matchTime = self.matchTime + 1
  local min = math.floor(self.matchTime / 60)
  local sec = self.matchTime % 60
  ed.setLabelString(self.ui.label_time, string.format("%.2d:%.2d", min, sec))
  local dot = class.NUM_TO_STRING[self.matchTime % 3] or ""
  ed.setLabelString(self.ui.label_tips, T("\230\173\163\229\156\168\229\140\185\233\133\141\229\175\185\230\137\139") .. dot)
end

function class:onClickBtnCancel()
  ed.realarena.network_mgr:RequestCancelMatch()
  self:destroy()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:onClickBtnCancel()
  end, {pressScale = 0.95})
end
