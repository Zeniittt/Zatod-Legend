local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.KingsPvpCreateRoomWindow = class
ed.UITool.registViewOpenFunc("KingsPvpCreateRoomWindow", function(param)
  local window = ed.ui.KingsPvpCreateRoomWindow.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("KingsPvpCreateRoomWindow", {noShade = true, notBlurBg = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class.close(param)
  local window = ed.getPopWindow("KingsPvpCreateRoomWindow")
  if window then
    window:destroy(param)
  end
end

function class:init(param)
  param = param or {}
  self.room = param.room or {}
  self.pvpRule = self.room._pvp_rule or ed.KingsPvpDefine.MODE_BO1
  self.isShowSharePanel = false
  self.shareTimeLimit = 5
  self.canShare = true
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:onWinDestroy()
  ed.ui.chatEntrance.getInstance():removeFormPopWindow()
  base.onWinDestroy(self)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsCreateRoomWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self.ui.share_bg:setVisible(self.isShowSharePanel)
  local modeName = ed.KingsPvpDefine.MODE_TO_NAME[self.pvpRule]
  ed.setLabelString(self.ui.label_title, modeName)
  ed.setLabelString(self.ui.label_room_num, self.room._room_id)
  self.chatEntrance, self.chatEntranceUI = ed.ui.chatEntrance.getInstance():addToPopWindow(self)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_room_num_tips, ed.toccc3(5454621), 1)
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4666403), 1)
  ed.setLabelStroke(self.ui.label_share_server, ed.toccc3(5321499), 0.5)
  ed.setLabelStroke(self.ui.label_share_guild, ed.toccc3(5321499), 0.5)
  ed.setLabelStroke(self.ui.label_share_friend, ed.toccc3(5321499), 0.5)
end

function class:startShareCountDown()
  self.canShare = false
  self:listenTimer(Timer:Once(self.shareTimeLimit), function()
    self.canShare = true
  end)
end

function class:onClickBtnCopy()
  ed.copyString(tostring(self.room._room_id))
end

function class:onClickBtnClose()
  self:destroy()
end

function class:onClickBtnShare()
  self.isShowSharePanel = not self.isShowSharePanel
  self.ui.share_bg:setVisible(self.isShowSharePanel)
end

function class:onClickShareServer()
  if not self.canShare then
    ed.showToast(T("\228\189\160\229\183\178\229\143\145\233\128\129\229\136\134\228\186\171\239\188\140\232\175\183\231\168\141\229\144\142\229\134\141\232\175\149"))
    return
  end
  ed.chatManager.currentChannel = "world_channel"
  local content = string.format("<link|real_arena|%s|%s>", self.pvpRule, self.room._room_id)
  local param = {
    channel = "world_channel",
    type = 2,
    content = content,
    accessory = {
      _type = "real_arena_invite",
      _role_id = ed.getRoleId()
    }
  }
  ed.chatManager:setNeedSendMsg(param)
  ed.chatManager:sendChatMsg()
  ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
  self:startShareCountDown()
end

function class:onClickShareGuild()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return
  end
  if not self.canShare then
    ed.showToast(T("\228\189\160\229\183\178\229\143\145\233\128\129\229\136\134\228\186\171\239\188\140\232\175\183\231\168\141\229\144\142\229\134\141\232\175\149"))
    return
  end
  ed.chatManager.currentChannel = "guild_channel"
  local content = string.format("<link|real_arena|%s|%s>", self.pvpRule, self.room._room_id)
  local param = {
    channel = "guild_channel",
    type = 2,
    content = content,
    accessory = {
      _type = "real_arena_invite",
      _role_id = ed.getRoleId()
    }
  }
  ed.chatManager:setNeedSendMsg(param)
  ed.chatManager:sendChatMsg()
  ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
  self:startShareCountDown()
end

function class:onClickShareFriend()
  ed.UITool.openView("kingsPvpShareWindow", {
    realArenaType = "casual",
    room = self.room
  })
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_copy", function()
    self:onClickBtnCopy()
  end, {pressScale = 0.85, normalScale = 0.9})
  ed.UITool.registerBtn(self, "btn_close", function()
    self:onClickBtnClose()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_share", function()
    self:onClickBtnShare()
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_share_guild", function()
    self:onClickShareGuild()
  end)
  ed.UITool.registerBtn(self, "btn_share_friend", function()
    self:onClickShareFriend()
  end)
  self:btRegisterButtonClick({
    button = self.chatEntranceUI.enter_touch,
    key = "chatEntrance",
    clickHandler = function()
      ed.chatManager:openChatMainWin(ed.chatManager.currentChannel)
    end,
    force = true
  })
  self:btRegisterOutClick({
    area = self.ui.share_bg,
    key = "clickOutShareBg",
    clickHandler = function()
      self.isShowSharePanel = false
      self.ui.share_bg:setVisible(false)
    end,
    force = true
  })
end

function class:addEventListener()
end

function class:destroy()
  ed.realarena.network_mgr:RequestExitHouse()
  base.destroy(self)
end
