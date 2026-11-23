PlayerSignPanel = {}
PlayerSignPanel.__index = PlayerSignPanel
local base = ed.ui.popwindow
setmetatable(PlayerSignPanel, base.mt)

function PlayerSignPanel.create(lastSign)
  local panel = base.create("playerSignPanel")
  setmetatable(panel, PlayerSignPanel)
  panel.lastSign = lastSign
  panel:initData()
  panel:initAppearance()
  panel:registerTouchHandler()
  return panel
end

function PlayerSignPanel:initData()
end

function PlayerSignPanel:initAppearance()
  local container, ui = ed.editorui(ed.uieditor.player_sign_panel)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  container:setPosition(newWid, newHei)
  local size = ui.node_edit:getContentSize()
  local posx, posy = ui.node_edit:getPosition()
  local clipLayer = CCLayer:create()
  ui.image_edit_bg:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(posx, posy, size.width, size.height + 2))
  local info = {
    config = {
      editSize = self.ui.node_edit:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(198, 175, 126),
      fontSize = 18
    }
  }
  local edit = editBox:new(info)
  edit:setPlaceHolder(self.lastSign)
  edit:setEnabled(true)
  edit.edit:setAnchorPoint(ccp(0, 0))
  edit.edit:setPosition(ccp(0, 2))
  clipLayer:addChild(edit.edit)
  self.edit = edit
end

function PlayerSignPanel:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_confirm,
    press = self.ui.btn_confirm_press,
    key = "btn_confirm",
    clickHandler = function()
      self:saveSign()
    end,
    clickInterval = 0.5,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_cancel,
    press = self.ui.btn_cancel_press,
    key = "btn_cancel",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5,
    pressScale = 0.95
  })
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit:touch(event, x, y)
    end,
    key = "edit"
  })
end

function PlayerSignPanel:saveSign()
  local sign = self.edit:getString()
  if #sign < 1 then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\231\173\190\229\144\141"))
    return
  end
  if ed.dirtyword_check(sign) then
    ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
    return
  end
  sign = string.gsub(sign, "[\r\n]", "")
  local _, count = string.gsub(sign, "[^\128-\193]", "")
  local max_length = 30
  if count > max_length then
    ed.showToast(T("\231\173\190\229\144\141\228\184\141\229\190\151\232\182\133\232\191\135%d\228\184\170\229\173\151", max_length))
    return
  end
  ed.PlayerInfoNetwork:saveSign(sign)
  self:destroy()
end
