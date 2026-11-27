local base = ed.ui.popwindow
local GuildMailWin = newclass(base.mt)
ed.ui.GuildMailWin = GuildMailWin

function GuildMailWin.create(param)
  local self = base.create("GuildMailWin")
  setmetatable(self, GuildMailWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function GuildMailWin:initData(param)
  self.title = ""
  self.message = ""
end

function GuildMailWin:createEditBox(param)
  local edit_box = editBox:new(param)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  return edit_box
end

function GuildMailWin:initTitleEditBox()
  local info = {
    config = {
      editSize = self.ui.bg_input_title:getContentSize(),
      maxLength = 20,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    }
  }
  local editBox = self:createEditBox(info)
  self.ui.bg_input_title:addChild(editBox.edit)
  self.ui.titleEditBox = editBox
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.titleEditBox:touch(event, x, y)
    end,
    key = "guildMailTitle"
  })
end

function GuildMailWin:initContentEditBox()
  local info = {
    config = {
      editSize = self.ui.bg_input_content:getContentSize(),
      maxLength = 360,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    }
  }
  local editBox = self:createEditBox(info)
  self.ui.bg_input_content:addChild(editBox.edit)
  self.ui.contentEditBox = editBox
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.contentEditBox:touch(event, x, y)
    end,
    key = "guildMailContent"
  })
end

function GuildMailWin:initLabels()
  ed.setLabelDimensions(self.ui.label_content, CCSizeMake(300, 0))
  self.ui.label_content:setAnchorPoint(ccp(0, 1))
  ed.setLabelShadow(self.ui.label_cancle, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_ok, ed.toccc3(0), ccp(1, 0))
  ed.right2(self.ui.Label_13301, self.ui.Label_13301_Copy0, 5)
end

function GuildMailWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMailWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.ui.label_content:setVisible(false)
  self.ui.label_title:setVisible(false)
  self:initTitleEditBox()
  self:initContentEditBox()
end

function GuildMailWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.title == "" then
      ed.showToast(T("\232\175\183\232\190\147\229\133\165\233\130\174\228\187\182\230\160\135\233\162\152"))
      return
    end
    if ed.dirtyword_check(self.title) then
      ed.showToast(T("\230\160\135\233\162\152\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
      return
    end
    if self.message == "" then
      ed.showToast(T("\232\175\183\232\190\147\229\133\165\233\130\174\228\187\182\229\134\133\229\174\185"))
      return
    end
    if ed.dirtyword_check(self.title) then
      ed.showToast(T("\229\134\133\229\174\185\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
      return
    end
    ed.GuildNetwork:sendGuildEmail(self.title, self.message)
    self:destroy()
  end, {pressScale = 0.95, clickInterval = 0.5})
  self:registerUpdateHandler("getEditString", function()
    local title = self.ui.titleEditBox:getString()
    if self.title ~= title then
      self.title = title
    end
    local message = self.ui.contentEditBox:getString()
    if self.message ~= message then
      self.message = message
    end
  end)
end

function GuildMailWin:destroy()
  self:removeUpdateHandler("getEditString")
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
