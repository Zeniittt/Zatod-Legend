local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.KingsJoinRoomWindow = class
ed.UITool.registViewOpenFunc("KingsJoinRoomWindow", function()
  local window = ed.ui.KingsJoinRoomWindow.create()
  window:popWindow()
end)

function class.create()
  local self = base.create("KingsJoinRoomWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsJoinRoomWindow)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initLabels()
  self:initEditBox()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(5849379), 1)
  ed.setLabelStroke(self.ui.label_mode_1, ed.toccc3(11821589), 1)
  ed.setLabelStroke(self.ui.label_mode_2, ed.toccc3(11821589), 1)
  ed.setLabelStroke(self.ui.label_match_select, ed.toccc3(10965763), 1)
  ed.setLabelStroke(self.ui.label_ob_select, ed.toccc3(10965763), 1)
end

function class:adaptUI()
end

function class:initEditBox()
  local info = {
    config = {
      editSize = self.ui.edit_box_bg:getContentSize(),
      maxLength = 10,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18,
      inputMode = kEditBoxInputModeNumeric
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setEnabled(true)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.ui.edit_box_bg:addChild(edit_box.edit)
  self.edit_box = edit_box
end

function class:onClickBtnEnterRoom()
  local roomId = tonumber(self.edit_box:getString())
  if roomId == nil or roomId == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\136\191\233\151\180\231\188\150\229\143\183"))
    return
  end
  roomId = tonumber(roomId)
  if roomId == nil then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\230\136\191\233\151\180\231\188\150\229\143\183"))
    return
  end
  if roomId < 10000 then
    ed.realarena.network_mgr:RequestEnterHouse(roomId)
  else
    ed.TeamNetwork.sendTeamApply("team_real_arena", roomId)
  end
  self:destroy({skipAnim = true})
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_enter", function()
    self:onClickBtnEnterRoom()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
end
