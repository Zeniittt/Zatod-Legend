local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessMatchWin = class

function class:initData(expireTime)
  ed.AutoChessManager:setMatching(true)
  self.expireTime = expireTime or 60
  self.used_time = 0
  self.usedTimer = nil
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_require_time, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_need_time, ccc3(0, 0, 0), 2)
  ed.setLabelStroke(self.ui.label_time, ccc3(0, 0, 0), 2)
end

function class:initMatchPanel()
  ed.setString(self.ui.label_need_time, self.expireTime .. "s")
  ed.setString(self.ui.label_time, "00:00")
  ed.layout.layoutWithMagin(self.ui.bg, {top = 50}, true)
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessMatchWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:initMatchPanel()
end

function class:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_back", function()
    ed.AutoChessNetwork:sendChessMatchCancel()
    self:destroy()
  end)
end

function class:registerEvents()
  self:listenTimer(Timer:Always(1), function()
    self.used_time = self.used_time + 1
    local min, sec = self.used_time / 60, self.used_time % 60
    local timeStr = string.format("%02d:%02d", min, sec)
    ed.setString(self.ui.label_time, timeStr)
  end)
  self:listenEvent("EventMatchTimoutNotify", function()
    self:destroy()
    ed.showToast(T("\229\140\185\233\133\141\232\182\133\230\151\182"))
  end)
  self:listenEvent("EventJoinTimoutNotify", function()
    self:destroy()
    ed.showToast(T("\229\138\160\229\133\165\230\184\184\230\136\143\232\182\133\230\151\182"))
  end)
  self:listenEvent("EventChessMatchCancel", function()
    self:destroy()
  end)
  self:listenEvent("EventChessGameStart", function()
    self:destroy()
  end)
  self:listenEvent("AutoChessMatchWinClose", function()
    self:destroy()
  end)
end

function class:destroy()
  base.destroy(self, {skipAnim = true})
end

function class.create(expireTime)
  local self = base.create("AutoChessMatchWin", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData(expireTime)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnExitHandler("OnExit", function()
    ed.AutoChessManager:setMatching(false)
  end)
  return self
end
