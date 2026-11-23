local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.KingsPvpSelectModeWindow = class
ed.UITool.registViewOpenFunc("KingsPvpSelectModeWindow", function(param)
  local window = ed.ui.KingsPvpSelectModeWindow.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("KingsPvpSelectModeWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.roomModeSelect = param.roomModeSelect or false
  self.selectModeCB = param.selectModeCB
  self:initData()
  self:initView()
  self:addTouchEvent()
  self:show()
end

function class:initData()
  local localMode = ed.storage.getString("KingsPvpSelectMode")
  if localMode == "ob" or localMode == "match" then
    self.roomMode = localMode
  else
    self.roomMode = "match"
  end
end

function class:saveLocalMode(mode)
  ed.storage.setValue("KingsPvpSelectMode", mode)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsSelectModeWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  self:refreshRoomModeBtn()
  self.ui.btn_mode_bg:setVisible(self.roomModeSelect)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4666403), 1)
  ed.setLabelStroke(self.ui.label_bo1, ed.toccc3(11821589), 1)
  ed.setLabelStroke(self.ui.label_bo3, ed.toccc3(11821589), 1)
  ed.setLabelStroke(self.ui.label_match_select, ed.toccc3(10965763), 1)
  ed.setLabelStroke(self.ui.label_ob_select, ed.toccc3(10965763), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_mode_bg, {right = 20})
end

function class:refreshRoomModeBtn()
  self.ui.btn_match_select:setVisible(self.roomMode == "match")
  self.ui.btn_ob_select:setVisible(self.roomMode == "ob")
end

function class:onClickBtnClose()
  self:destroy()
end

function class:onClickMode(mode)
  if mode == ed.KingsPvpDefine.MODE_BO3 then
    local heroAmount = 0
    for id, hero in pairs(ed.player.heroes or {}) do
      heroAmount = heroAmount + 1
    end
    local needHeroAmount = ed.getDataTable("KingsPVPConfig")["Bo3 Need Heroes"].Value[1]
    if heroAmount < needHeroAmount then
      ed.showToast(string.format(T("\232\139\177\233\155\132\230\149\176\233\135\143\228\184\141\232\182\179%s\228\184\170"), needHeroAmount))
      return
    end
  end
  self:destroy({skipAnim = true})
  if self.selectModeCB then
    self.selectModeCB(mode, self.roomMode)
  end
end

function class:onClickRoomMode(roomMode)
  if self.roomMode == roomMode then
    return
  end
  self.roomMode = roomMode
  self:refreshRoomModeBtn()
  self:saveLocalMode(roomMode)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:onClickBtnClose()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "mode_bo1", function()
    self:onClickMode(ed.KingsPvpDefine.MODE_BO1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "mode_bo3", function()
    self:onClickMode(ed.KingsPvpDefine.MODE_BO3)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_match", function()
    self:onClickRoomMode("match")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_ob", function()
    self:onClickRoomMode("ob")
  end, {pressScale = 0.95})
end
