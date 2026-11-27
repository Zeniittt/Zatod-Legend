local base = ed.ui.popwindow
local GuildMemberInfoWin = newclass(base.mt)
ed.ui.GuildMemberInfoWin = GuildMemberInfoWin

function GuildMemberInfoWin.create(param)
  local self = base.create("GuildMemberInfoWin")
  setmetatable(self, GuildMemberInfoWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function GuildMemberInfoWin:initData(param)
  self.data = param.info
  self.des = T("\229\156\168\231\186\191")
  if self.data._is_online == 0 then
    local y, m, d, h, min, sec = ed.time2YMDHMS(ed.time2Server(self.data._last_login))
    local nowY, nowM, nowD = ed.time2YMDHMS()
    local passSecond = ed.getServerTime() - self.data._last_login
    if d == nowD and passSecond < 86400 or self.data._last_login == 0 then
      self.des = string.format(T("\228\187\138\230\151\165%02d:%02d") .. ed.getUTCLabel(), h, min)
    else
      local days = math.floor(passSecond / 86400)
      self.des = string.format(T("%d\229\164\169\229\137\141"), days)
    end
  end
end

function GuildMemberInfoWin:initLabels()
  ed.setLabelShadow(self.ui.label_hof, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_social, ccc3(0, 0, 0), ccp(2, 0))
  self.ui.label_social:limitWidthByScale(90)
end

function GuildMemberInfoWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMemberInfoWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local data = self.data
  local liveness = ed.ui.autoText.new()
  local str = string.format(T("<lable color=ccc3(231,177,82)>\230\156\128\232\191\1457\230\151\165\232\180\161\231\140\174\239\188\154</lable><lable color=ccc3(147,255,126)>%d</lable><lable color=ccc3(255,252,231)>\230\180\187\232\183\131</lable>"), data._active)
  liveness:initParam({
    context = str,
    fontSize = 16,
    maxWidth = 400,
    strokeColor = ccc3(85, 64, 39),
    strokeSize = 1
  })
  ed.UITool.replaceUI(self.ui, "bg", "label1", liveness.node)
  local onlineTimes = ed.ui.autoText.new()
  str = string.format(T("<lable color=ccc3(231,177,82)>\230\156\128\229\144\142\228\184\138\231\186\191\230\151\182\233\151\180\239\188\154</lable><lable color=ccc3(255,252,231)>%s</lable>"), self.des)
  onlineTimes:initParam({
    context = str,
    fontSize = 16,
    maxWidth = 400,
    strokeColor = ccc3(32, 31, 28),
    strokeSize = 1
  })
  ed.UITool.replaceUI(self.ui, "bg", "label2", onlineTimes.node)
  local param = {
    id = data._summary._avatar,
    level = data._summary._level,
    lvoffset = {x = -70, y = -30},
    name = data._summary._name,
    medal = data._summary._medal
  }
  local head = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(self.ui, "bg", "avatar", head)
  if ed.friendlist.isInFriendlist(data._summary._role_id) or ed.getRoleId() == data._summary._role_id then
    self.ui.btn_add:setVisible(false)
  end
end

function GuildMemberInfoWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_add", function()
    ed.ui.chat.sendAddFriendLink(self.data._summary._role_id)
  end, {pressScale = 0.9, clickInterval = 0.5})
  ed.UITool.registerBtn(self, "btn_hof", function()
    ed.registerNetReply("req_home_page", function(data)
      ed.ui.PlayerInfoPanel.create(data, ed.getRoleId() == self.data._summary._role_id):popWindow()
    end)
    ed.PlayerInfoNetwork:requestHomePage(self.data._summary._role_id)
  end, {pressScale = 0.9, clickInterval = 0.5})
  ed.UITool.registerBtn(self, "btn_social", function()
    if ed.getRoleId() == self.data._summary._role_id then
      ed.showToast(T("\228\184\141\232\131\189\229\146\140\232\135\170\229\183\177\232\129\138\229\164\169"))
      return
    end
    local params = {
      roleId = self.data._summary._role_id,
      summary = self.data._summary
    }
    if ed.chatManager.chatPopWin.chatMainWin then
      FireEvent("chat_private_target", params)
    else
      FireEvent("chat_private_target", params)
      ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.personal_channel)
      self:destroy()
    end
  end, {pressScale = 0.9, clickInterval = 0.5})
end
