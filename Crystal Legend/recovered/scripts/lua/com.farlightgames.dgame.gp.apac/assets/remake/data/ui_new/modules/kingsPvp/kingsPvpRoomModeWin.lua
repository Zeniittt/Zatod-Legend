local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.KingsPvpRoomModeWin = class
ed.UITool.registViewOpenFunc("KingsPvpRoomModeWin", function(param)
  local window = ed.ui.KingsPvpRoomModeWin.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("KingsPvpRoomModeWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self:initView()
  self:addTouchEvent()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsSelectRoomModeWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4666403), 1)
  ed.setLabelStroke(self.ui.label_create_room, ed.toccc3(11821589), 1)
  ed.setLabelStroke(self.ui.label_join_room, ed.toccc3(11821589), 1)
  ed.setLabelStroke(self.ui.label_match_select, ed.toccc3(10965763), 1)
  ed.setLabelStroke(self.ui.label_ob_select, ed.toccc3(10965763), 1)
end

function class:onClickBtnClose()
  self:destroy()
end

function class:onClickCreateRoom()
  ed.UITool.openView("KingsPvpSelectModeWindow", {
    roomModeSelect = true,
    selectModeCB = function(mode, roomMode)
      if roomMode == "match" then
        ed.realarena.network_mgr:RequestCreateHouse(mode)
      elseif roomMode == "ob" then
        ed.TeamNetwork.sendTeamCreate("team_real_arena", mode)
        ed.realarena.mgr.match_rule = mode
      end
    end
  })
end

function class:onClickJoinRoom()
  ed.UITool.openView("KingsJoinRoomWindow")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:onClickBtnClose()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "mode_create_room", function()
    self:onClickCreateRoom()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "mode_join_room", function()
    self:onClickJoinRoom()
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
