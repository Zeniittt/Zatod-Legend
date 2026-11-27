local base = ed.ui.popwindow
local GuildSetSloganWin = newclass(base.mt)
ed.ui.GuildSetSloganWin = GuildSetSloganWin

function GuildSetSloganWin.create()
  local self = base.create("GuildSetSloganWin")
  setmetatable(self, GuildSetSloganWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildSetSloganWin:initData()
  self.slogan = ed.GuildManager.slogan
end

function GuildSetSloganWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.GuildRenameWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.editBox = ed.UITool.createEditBox(self.ui.bg_input, {maxLength = 60})
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.editBox:touch(event, x, y)
    end,
    key = "editBox"
  })
  ed.setLabelShadow(ui.label_cancle, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(ui.label_ok, ccc3(0, 0, 0), ccp(1, 0))
  ed.setString(self.ui.title, T("\232\174\190\231\189\174\229\133\172\229\145\138"))
  self.ui.Label_124434:setVisible(false)
  ed.setString(self.ui.Label_13301, T("\228\184\186\228\189\160\231\154\132\229\133\172\228\188\154\232\174\190\231\189\174\229\133\172\229\145\138\239\188\154"))
  ed.left2(self.ui.line1, self.ui.title, 5)
  ed.right2(self.ui.line2, self.ui.title, 5)
end

function GuildSetSloganWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self.slogan = ""
    self:destroy()
  end)
  ed.UITool.registerBtn(self, "btn_ok", function()
    self.slogan = self.ui.editBox:getString()
    if ed.UITool.checkStrVaildity(self.slogan, 20, T("\229\133\172\229\145\138\232\191\135\233\149\191!!")) then
      ed.GuildManager.settingData = {
        slogan = self.slogan
      }
      local msg = ed.upmsg.guild()
      msg._set = {}
      msg._set._slogan = self.slogan
      ed.send(msg, "guild")
      self:destroy()
      return
    end
  end)
end

function GuildSetSloganWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
