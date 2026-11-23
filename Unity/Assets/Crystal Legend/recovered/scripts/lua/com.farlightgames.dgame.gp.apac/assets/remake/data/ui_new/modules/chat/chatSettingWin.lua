local base = ed.ui.popwindow
local chatSettingWin = newclass(base.mt)
ed.ui.chatSettingWin = chatSettingWin

function chatSettingWin:initData()
end

function chatSettingWin:initView()
  local container, ui = ed.editorui(ed.uieditor.chatSettingWin)
  self.ui = ui
  self.container:addChild(container)
  ui.icon_friend:setPositionX(ed.chatManager.canFrientInvite and 34.5 or 13)
  ui.icon_other:setPositionX(ed.chatManager.canOtherChat and 34.5 or 13)
end

function chatSettingWin:addEventListener()
  ed.UITool.registerBtn(self, "btn_friend", function()
    ed.chatNetWork:sendChangeChatSetting("friend_apply")
  end)
  ed.UITool.registerBtn(self, "btn_other", function()
    ed.chatNetWork:sendChangeChatSetting("personal_chat")
  end)
  self:listenEvent("ChatSettingChange", function()
    self.ui.icon_friend:setPositionX(ed.chatManager.canFrientInvite and 34.5 or 13)
    self.ui.icon_other:setPositionX(ed.chatManager.canOtherChat and 34.5 or 13)
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function chatSettingWin.create()
  local self = base.create("chatSettingWin")
  setmetatable(self, chatSettingWin.mt)
  self:initData()
  self:initView()
  self:addEventListener()
  self:popWindow()
  return self
end
