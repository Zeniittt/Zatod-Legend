local friendItem = {}
ed.ui.friendItem = friendItem
friendItem.OPEN_CROSS_FRIEND = 50

function friendItem.create(controller, type, playerData)
  local self = {}
  setmetatable(self, {__index = friendItem})
  self:init(controller, type, playerData)
  return self
end

function friendItem:init(controller, type, playerData)
  self.controller = controller
  self.type = type
  self.playerData = playerData
  self.chatContactUser = playerData.chatContactUser or {}
  self.eventScope = {}
  self:initView()
  self:addEventListener()
end

function friendItem:initView()
  local container, ui = ed.editorui(ed.uieditor.friendItem)
  self.container = container
  self.ui = ui
  self.container:setContentSize(self.ui.bg:getContentSize())
  ed.setLabelStroke(self.ui.playerName, ed.toccc3(5586983), 1)
  self.ui.btnApplyFriend:setVisible(self.type == "applyFriend")
  self.ui.addFriend:setVisible(self.type == "addFriend")
  self.ui.blacklist:setVisible(self.type == "blacklist")
  self.ui.chat:setVisible(self.type == "friendChat")
  if self.type == "addFriend" then
    self.ui.line:setPositionX(self.ui.line:getPositionX() - 40)
  end
  local user_summary = self.chatContactUser._user_summary
  local playerName, nameWidth = ed.getPlayerName(user_summary._name, user_summary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "playerNameBg", "playerName", playerName)
  local param = {
    id = user_summary._avatar,
    level = user_summary._level,
    lvoffset = {x = -48, y = -37}
  }
  local head = ed.getWholeHeadIcon(param)
  head:setScale(0.75)
  self.ui.headFrame:addChild(head)
  ed.layout.centerInParent(head)
  self.ui.guildName:setString(user_summary._guild_name or "")
  local svrId = self.chatContactUser._svr_id
  if svrId and svrId ~= tonumber(game_server_id) then
    self.ui.label_svr_name:setVisible(true)
    ed.setLabelString(self.ui.label_svr_name, self.chatContactUser._server_name or "")
    ed.setLabelStroke(self.ui.label_svr_name, ed.toccc3(2565412), 1)
    self.ui.label_svr_name:setPositionX(self.ui.guildName:getPositionX() + self.ui.guildName:getContentSize().width)
  else
    self.ui.label_svr_name:setVisible(false)
  end
  if self.type == "friendChat" then
    if self.chatContactUser._is_online == 1 then
      ed.setLabelColor(self.ui.state, ed.toccc3(6546254))
      ed.setLabelStroke(self.ui.state, ed.toccc3(3170599), 1)
      self.ui.state:setString(T("\229\156\168\231\186\191"))
    else
      ed.setLabelColor(self.ui.state, ed.toccc3(5718320))
      local y, m, d, h, min, sec = ed.time2YMDHMS(self.chatContactUser._recent_online_time)
      local nowY, nowM, nowD = ed.time2YMDHMS(ed.getServerTime())
      local passSecond = ed.getServerTime() - self.chatContactUser._recent_online_time
      local des = T("\231\166\187\231\186\191")
      if d == nowD and passSecond < 86400 and h and min then
        des = T("\228\187\138\230\151\165\229\134\133")
      else
        local days = math.ceil(passSecond / 86400)
        des = T("%d\229\164\169\229\137\141", days)
      end
      self.ui.state:setString(des)
    end
  end
end

function friendItem:addEventListener()
  self.controller:btRegisterButtonClick({
    button = self.ui.btnChat,
    press = self.ui.btnChat_press,
    pressScale = 0.95,
    force = true,
    key = "Chat" .. self.type .. tostring(self.chatContactUser._user_summary._role_id),
    clickHandler = function()
      local roleId = self.chatContactUser._user_summary._role_id
      local params = {
        roleId = roleId,
        summary = self.chatContactUser._user_summary
      }
      if ed.chatManager.chatPopWin.chatMainWin then
        FireEvent("chat_private_target", params)
      else
        FireEvent("chat_private_target", params)
        ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.personal_channel)
      end
      self.controller:close()
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnRemove,
    press = self.ui.btnRemove_press,
    pressScale = 0.95,
    force = true,
    key = "removeBlacklist" .. self.type .. tostring(self.chatContactUser._role_id),
    clickHandler = function()
      ed.chatManager:setTargetUid(self.chatContactUser._user_summary._uid)
      ed.chatManager:setTargetRoleId(self.chatContactUser._role_id)
      ed.chatNetDataMrg:sendDelBlackList(self.chatContactUser._role_id)
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnAddFriend,
    press = self.ui.btnAddFriend_press,
    pressScale = 0.95,
    force = true,
    key = "addFriend" .. self.type .. tostring(self.chatContactUser._role_id),
    clickHandler = function()
      local roleId = self.chatContactUser._role_id
      if ed.friendlist.isInFriendlist(roleId) then
        ed.showToast(T("\229\175\185\230\150\185\229\183\178\231\187\143\230\152\175\228\189\160\231\154\132\229\165\189\229\143\139"))
        return
      end
      if roleId == ed.getRoleId() then
        ed.showToast(T("\228\184\141\232\131\189\230\183\187\229\138\160\232\135\170\229\183\177\228\184\186\229\165\189\229\143\139"))
        return
      end
      if ed.friendlist.getFriendAmount() >= ed.friendlist.MAX_FRIEND_AMOUNT then
        ed.showToast(T("\229\183\178\232\190\190\229\136\176\229\165\189\229\143\139\230\149\176\233\135\143\228\184\138\233\153\144\239\188\140\230\151\160\230\179\149\230\183\187\229\138\160\229\165\189\229\143\139"))
        return
      end
      ed.chatNetDataMrg:sendAddFriend(roleId)
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnApplyFriend,
    press = self.ui.btnApplyFriend_press,
    pressScale = 0.95,
    force = true,
    key = "applyFriend" .. self.type .. tostring(self.chatContactUser._role_id),
    clickHandler = function()
      local roleId = self.chatContactUser._role_id
      if ed.friendlist.isInFriendlist(roleId) then
        ed.showToast(T("\229\175\185\230\150\185\229\183\178\231\187\143\230\152\175\228\189\160\231\154\132\229\165\189\229\143\139"))
        return
      end
      if roleId == ed.getRoleId() then
        ed.showToast(T("\228\184\141\232\131\189\230\183\187\229\138\160\232\135\170\229\183\177\228\184\186\229\165\189\229\143\139"))
        return
      end
      if ed.friendlist.getFriendAmount() >= ed.friendlist.MAX_FRIEND_AMOUNT then
        ed.showToast(T("\229\183\178\232\190\190\229\136\176\229\165\189\229\143\139\230\149\176\233\135\143\228\184\138\233\153\144\239\188\140\230\151\160\230\179\149\230\183\187\229\138\160\229\165\189\229\143\139"))
        return
      end
      local svrId = self.chatContactUser._svr_id
      if svrId and svrId ~= tonumber(game_server_id) then
        if ed.player:getLevel() < self.OPEN_CROSS_FRIEND then
          ed.showToast(T("50\231\186\167\229\144\142\239\188\140\229\143\175\230\183\187\229\138\160\232\183\168\230\156\141\229\165\189\229\143\139"))
          return
        end
        local user_summary = self.chatContactUser._user_summary
        if user_summary and user_summary._level < self.OPEN_CROSS_FRIEND then
          ed.showToast(T("\228\184\141\229\143\175\230\183\187\229\138\16050\231\186\167\228\187\165\228\184\139\231\142\169\229\174\182\228\184\186\232\183\168\230\156\141\229\165\189\229\143\139"))
          return
        end
      end
      ed.chatNetDataMrg:sendApplyFriend(roleId)
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnDelFriend,
    press = self.ui.btnDelFriend_press,
    pressScale = 0.95,
    force = true,
    key = "delFriend" .. self.type .. tostring(self.chatContactUser._role_id),
    clickHandler = function()
      ed.chatNetDataMrg:sendRejectFriend(self.chatContactUser._role_id)
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.headFrame,
    key = "headFrame" .. self.type .. self.chatContactUser._role_id,
    force = true,
    clickHandler = function()
      ListenEventOnce("req_home_page", function(data)
        local isSelf = self.chatContactUser._role_id == ed.getRoleId()
        local panel = ed.ui.PlayerInfoPanel.create(data, isSelf)
        panel:popWindow()
      end, self.eventScope)
      ed.PlayerInfoNetwork:requestHomePage(self.chatContactUser._role_id)
    end
  })
end
