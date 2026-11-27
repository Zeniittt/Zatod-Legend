local base = ed.ui.popwindow
local GuildClashSetNoticeWin = newclass(base.mt)
ed.ui.GuildClashSetNoticeWin = GuildClashSetNoticeWin

function GuildClashSetNoticeWin.create(params)
  local self = base.create("GuildClashSetNoticeWin")
  setmetatable(self, GuildClashSetNoticeWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildClashSetNoticeWin:initData(params)
  self.mgr = ed.GuildClashManager
  self.callback = params.callback
  self.notice = self.mgr.notice
end

function GuildClashSetNoticeWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.GuildRenameWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.editBox = ed.UITool.createEditBox(self.ui.bg_input, {maxLength = 120})
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.editBox:touch(event, x, y)
    end,
    key = "editBox"
  })
  ed.setLabelShadow(ui.label_cancle, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(ui.label_ok, ccc3(0, 0, 0), ccp(1, 0))
  ed.setString(self.ui.title, T("\232\174\190\231\189\174\228\188\154\233\149\191\229\133\172\229\145\138"))
  self.ui.Label_124434:setVisible(false)
  ed.setString(self.ui.Label_13301, T("\228\188\154\233\149\191\229\133\172\229\145\138:"))
end

function GuildClashSetNoticeWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self.notice = ""
    self:destroy()
  end)
  ed.UITool.registerBtn(self, "btn_ok", function()
    self.notice = self.ui.editBox:getString()
    print(self.notice)
    if ed.UITool.checkStrVaildity(self.notice, 40, T("\229\133\172\229\145\138\232\191\135\233\149\191\239\188\140\232\175\183\231\188\169\229\135\143\228\184\18640\229\173\151\229\134\133")) then
      ed.GuildClashNetwork:sendSetDeclare(self.notice)
    end
  end)
  self:listenEvent("GuildClashSetDeclareSuccess", function()
    self.mgr.notice = self.notice
    ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"))
    self:destroy()
  end)
end

function GuildClashSetNoticeWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
