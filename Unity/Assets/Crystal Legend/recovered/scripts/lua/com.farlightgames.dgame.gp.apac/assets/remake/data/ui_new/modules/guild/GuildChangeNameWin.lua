local base = ed.ui.popwindow
local GuildChangeNameWin = newclass(base.mt)
ed.ui.GuildChangeNameWin = GuildChangeNameWin

function GuildChangeNameWin.create(param)
  local self = base.create("GuildChangeNameWin")
  setmetatable(self, GuildChangeNameWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildChangeNameWin:initData(param)
  self.name = ed.GuildManager.name
  self.callback = param.callback
end

function GuildChangeNameWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildRenameWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.Label_124434:setVisible(false)
  self.ui.edit_box = ed.UITool.createEditBox(self.ui.bg_input, {maxLength = 30})
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
end

function GuildChangeNameWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self.name = ""
    self:destroy()
  end)
  ed.UITool.registerBtn(self, "btn_ok", function()
    self.name = self.ui.edit_box:getString()
    if ed.UITool.checkStrVaildity(self.name, 7, T("\229\133\172\228\188\154\229\144\141\229\173\151\228\184\141\232\131\189\232\182\133\232\191\1357\228\184\170\229\173\151!!!")) then
      self:destroy()
    end
  end)
end

function GuildChangeNameWin:destroy()
  if self.callback and self.name ~= "" then
    self.callback(self.name)
  end
  base.destroy(self)
end
