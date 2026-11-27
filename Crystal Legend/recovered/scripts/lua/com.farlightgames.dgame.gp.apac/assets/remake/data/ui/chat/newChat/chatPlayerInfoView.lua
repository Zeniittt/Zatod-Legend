local base = ed.ui.popwindow
local chatPlayerInfoView = newclass(base.mt)
chatPlayerInfoView.__index = chatPlayerInfoView
ed.ui.chatPlayerInfoView = chatPlayerInfoView

function chatPlayerInfoView:onDestory()
  if self.callback then
    self.callback()
  end
  self:destroy({skipAnim = true})
end

function chatPlayerInfoView.create(param)
  local self = base.create("chatPlayerInfoView")
  setmetatable(self, chatPlayerInfoView.mt)
  self.param = param
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show({skipAnim = true})
  return self
end

function chatPlayerInfoView:initUI()
  local layer, ui = ed.editorui(ed.uieditor.PlayerAvatarClick)
  self.winUi = ui
  self.container:addChild(layer)
  local targetSummary = self.param.summary
  local param = {
    id = targetSummary._avatar,
    level = targetSummary._level,
    name = targetSummary._name,
    vip = targetSummary._vip > 0,
    scale = 0.8,
    babelLevel = targetSummary._babel_level
  }
  if targetSummary._medal then
    param.medal = targetSummary._medal
  end
  local head = ed.getWholeHeadIcon(param)
  local text = ""
  if targetSummary._guild_name and targetSummary._guild_name ~= "" then
    text = T("<lable color=chatName fontSize=f15>\229\133\172\228\188\154:</lable><lable color=chatContent fontSize=f15>%s</lable>", targetSummary._guild_name)
  else
    text = T("<lable color=chatName fontSize=f15>\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154</lable>")
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    color = ccc3(255, 255, 255),
    maxWidth = 99999,
    fontSize = 18
  })
  self.winUi.label_guild:setVisible(false)
  local x, y = self.winUi.label_guild:getPosition()
  autoText.node:setPosition(ccp(x, y))
  self.winUi.img_playeravatarclick_bg:addChild(autoText.node, 10)
  text = T("<lable color=chatName fontSize=f15>\230\156\141\229\138\161\229\153\168:</lable><lable color=chatContent fontSize=f15>%s</lable>", self.param.server_name or "\230\178\161\230\156\137\230\156\141\229\138\161\229\153\168\229\144\141\229\173\151")
  autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    color = ccc3(255, 255, 255),
    maxWidth = 99999,
    fontSize = 15
  })
  self.winUi.label_server:setVisible(false)
  x, y = self.winUi.label_server:getPosition()
  autoText.node:setPosition(ccp(x, y))
  self.winUi.img_playeravatarclick_bg:addChild(autoText.node, 10)
  self:checkIsFriend()
  self.winUi.label_friend_point:setVisible(false)
  self.winUi.label_latest_online:setVisible(false)
  head:setPosition(ccp(45, 200))
  self.winUi.img_playeravatarclick_bg:addChild(head)
  if ed.player:getLevel() < 85 or self.param.sid ~= tonumber(real_game_server_id) then
    self.winUi.btn_trade:setVisible(false)
  else
    self.winUi.btn_trade:setVisible(true)
  end
end

function chatPlayerInfoView:checkIsFriend()
  local roleId = self.param.roleId
  local bool = ed.friendlist.isInFriendlist(roleId)
  if not bool then
    self.winUi.btn_delete:setVisible(false)
    return
  end
  self.winUi.btn_add:setVisible(false)
  local key = ed.chatUtil:getUserKey(roleId)
  local friendData = ed.chatNetDataMrg.contactData.friend.data[key]
  if not friendData then
    return
  end
  local timeStr = self:getTimes(friendData.recent_online_time)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = timeStr,
    color = ccc3(255, 255, 255),
    maxWidth = 99999,
    fontSize = 18
  })
  local x, y = self.winUi.label_latest_online:getPosition()
  autoText.node:setPosition(ccp(x, y))
  self.winUi.img_playeravatarclick_bg:addChild(autoText.node, 10)
  text = T("<lable color=chatName fontSize=f15>\229\143\139\230\131\133\231\130\185:</lable><lable color=chatContent fontSize=f15>%s</lable>", tostring(friendData.friendPoint) or "0")
  text = ""
  autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    color = ccc3(255, 255, 255),
    maxWidth = 99999,
    fontSize = 18
  })
  x, y = self.winUi.label_friend_point:getPosition()
  autoText.node:setPosition(ccp(x, y))
  self.winUi.img_playeravatarclick_bg:addChild(autoText.node, 10)
end

function chatPlayerInfoView:getTimes(time)
  local des = ""
  local y, m, d, h, min, sec = ed.time2YMDHMS(time)
  local nowY, nowM, nowD = ed.time2YMDHMS(ed.getServerTime())
  local passSecond = ed.getServerTime() - time
  if d == nowD and passSecond < 86400 and h and min or time == 0 then
    des = T("<lable color=chatName fontSize=f15>\230\156\128\232\191\145\229\156\168\231\186\191:</lable><lable color=chatContent fontSize=f15>\228\187\138\230\151\165%02d:%02d</lable>", h, min)
  else
    local days = math.ceil(passSecond / 86400)
    des = T("<lable color=chatName fontSize=f15>\230\156\128\232\191\145\229\156\168\231\186\191:</lable><lable color=chatContent fontSize=f15>%d\229\164\169\229\137\141</lable>", days)
  end
  return des
end

function chatPlayerInfoView:registerBtnHandler()
  local ui = self.winUi
  self:btRegisterButtonClick({
    button = ui.close_btn,
    press = ui.close_btn_press,
    key = "close_button",
    clickHandler = function()
      self:onDestory()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterButtonClick({
    button = ui.btn_blacklist,
    press = ui.btn_blacklist_press,
    key = "btn_blacklist",
    clickHandler = function()
      self:addBlacklist()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterButtonClick({
    button = ui.btn_chat,
    press = ui.btn_chat_press,
    key = "btn_chat",
    clickHandler = function()
      FireEvent("chat_private_target", self.param)
      self:onDestory()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterButtonClick({
    button = ui.btn_delete,
    press = ui.btn_delete_press,
    key = "btn_delete",
    clickHandler = function()
      self:delFriendHandler()
      self:onDestory()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterButtonClick({
    button = ui.btn_add,
    press = ui.btn_add_press,
    key = "btn_add",
    clickHandler = function()
      self:addFriendHandler()
      self:onDestory()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterClick({
    key = "click_layer",
    clickHandler = function(param, x, y)
      if not ed.containsPoint(self.winUi.img_playeravatarclick_bg, x, y) then
        self:onDestory()
      end
    end
  })
end

function chatPlayerInfoView:addFriendHandler()
  local roleId = self.param.roleId
  ed.ui.chat.sendAddFriendLink(roleId)
end

function chatPlayerInfoView:delFriendHandler()
  local roleId = self.param.roleId
  
  function ed.netreply.delFriend()
    ed.ui.chatMain.getInstace():delFriend({roleId = roleId})
  end
  
  ed.chatNetDataMrg:sendDelFriend(roleId)
end

function chatPlayerInfoView:addBlacklist()
  local targetRoleId = self.param.roleId
  ed.blacklist.setTargetRoleId(targetRoleId)
  local msg = ed.upmsg.chat()
  msg._chat_add_bl = {}
  msg._chat_add_bl._role_id = targetRoleId
  ed.send(msg, "chat")
  self:onDestory()
end
