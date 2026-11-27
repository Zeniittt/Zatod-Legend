local base = ed.ui.popwindow
local class = newclass(base.mt)
class.__index = class
ed.ui.shareGuildOrFriend = class
ed.UITool.registViewOpenFunc("shareGuildOrFriend", function(param)
  if ed.pvpManager.leftShareCount <= 0 then
    ed.showToast(T("\228\187\138\230\151\165\229\136\134\228\186\171\230\172\161\230\149\176\229\183\178\232\128\151\229\176\189"))
    return
  end
  local panel = class.create(param)
  panel:popWindow(300)
end)

function class.create(param)
  local self = base.create("shareGuildOrFriend", {notBlurBg = true})
  setmetatable(self, class.mt)
  param = param or {}
  self.param = param
  self.destroyCallback = param.destroyCallback
  self:initUI()
  self:addEventListener()
  self:show({skipAnim = false})
  return self
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.shareGuildOrFriend)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelColor(self.ui.label_guild, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_guild, ed.toccc3(6827804), 1)
  ed.setLabelColor(self.ui.label_friend, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_friend, ed.toccc3(6827804), 1)
  self.ui.label_guild:limitWidthByScale(150)
  self.ui.label_friend:limitWidthByScale(150)
  self.ui.image_title_left:setPositionX(-self.ui.image_title_left:getContentSize().width * 0.5 - 10)
  self.ui.image_title_right:setPositionX(self.ui.label_title:getContentSize().width + self.ui.image_title_right:getContentSize().width * 0.5 + 10)
end

function class:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_guild,
    press = self.ui.btn_guild_press,
    key = "btn_guild",
    clickHandler = function()
      self:shareGuild()
      self:destroy()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_friend,
    press = self.ui.btn_friend_press,
    key = "btn_friend",
    clickHandler = function()
      self:shareFriend()
      self:destroy()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    press = self.ui.btn_close_press,
    key = "btn_close",
    pressScale = 0.75,
    normalScale = 0.8,
    clickHandler = function()
      self:destroy()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and self.clickOutSide then
        self:destroy()
      end
      return false
    end,
    key = "close"
  })
end

function class:shareGuild()
  ed.UITool.openView("pvpShareWin", {type = "guild"})
end

function class:shareFriend()
  ed.UITool.openView("pvpShareWin", {type = "friend"})
end

function class:destroy()
  if self.destroyCallback then
    self.destroyCallback()
  end
  base.destroy(self)
end
