local base = ed.ui.popwindow
local AutoChessPlayerInviteWin = newclass(base.mt)
ed.ui.AutoChessPlayerInviteWin = AutoChessPlayerInviteWin

function AutoChessPlayerInviteWin:initData(params)
  self.params = params
  self.room_id = params.room_id or 0
  self.stageId = params.stageId or 0
  self.topGs = params.topGs or 0
  self.destroyCallback = params.closeCallback
  self.link_type = params.link_type or "multiplayer"
end

function AutoChessPlayerInviteWin:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.ui.btn_invite, x, y) then
        return item
      end
    end
  end
  
  return handler
end

function AutoChessPlayerInviteWin:sendAutoChessInvite(channel, data)
  local content = T("<text|dark_white|\232\135\170\232\181\176\230\163\139\239\188\154><link|multiplayer|\228\188\145\233\151\178\230\168\161\229\188\143>")
  local msg = ed.upmsg.chat_acc()
  msg._type = "team_invite"
  msg._team_invite = ed.upmsg.team_invite()
  msg._team_invite._target = "chess"
  msg._team_invite._team_id = tonumber(self.room_id)
  ed.ui.chat.sendMessage(content, 2, msg, channel, nil, data)
end

function AutoChessPlayerInviteWin:getClickInHandler()
  local function handler(x, y, item)
    item.ui.btn_invite:setVisible(false)
    
    item.ui.btn_invite_already:setVisible(true)
    ed.showToast(T("\229\183\178\230\136\144\229\138\159\229\136\134\228\186\171\231\187\153\229\165\189\229\143\139"))
    self:sendAutoChessInvite("personal_channel", {
      roleId = item.data._role_id
    })
  end
  
  return handler
end

function AutoChessPlayerInviteWin:initUI(params)
  ed.editorui(ed.uieditor.AutoChessInviteFriendWin, {
    container = self.container,
    ui = self.ui
  })
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler()
  })
  self.ui.label_guild:limitWidthByScale(140)
end

function AutoChessPlayerInviteWin:onClickGuild()
  local gid = ed.player:getGuildId() or 0
  if gid == 0 then
    ed.showToast(T("\228\189\160\233\156\128\232\166\129\229\133\136\229\138\160\229\133\165\228\184\128\228\184\170\229\133\172\228\188\154\230\137\141\229\143\175\228\187\165\229\136\134\228\186\171"))
    return
  end
  ed.showToast(T("\229\183\178\230\136\144\229\138\159\229\136\134\228\186\171\229\136\176\229\133\172\228\188\154\233\162\145\233\129\147"))
  self:sendAutoChessInvite("guild_channel")
  self:destroy()
end

function AutoChessPlayerInviteWin:onClickWorld()
  ed.showToast(T("\229\183\178\230\136\144\229\138\159\229\136\134\228\186\171\229\136\176\228\184\150\231\149\140\233\162\145\233\129\147"))
  self:sendAutoChessInvite("world_channel")
  self:destroy()
end

function AutoChessPlayerInviteWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_guild", function()
    self:onClickGuild()
  end, {pressScale = 0.95})
  self:listenEvent("ChatGetFriendSuccess", function(data)
    local info = {}
    for k, v in pairs(data or {}) do
      table.insert(info, v)
    end
    table.sort(info, function(a, b)
      if a._is_online > b._is_online then
        return true
      end
      return false
    end)
    self:refreshDraglist(info)
  end)
end

function AutoChessPlayerInviteWin:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.AutoChessInviteItem)
  local targetSummary = data._user_summary
  local param = {
    id = targetSummary._avatar,
    level = targetSummary._level,
    name = targetSummary._name,
    scale = 0.6
  }
  if targetSummary._medal then
    param.medal = targetSummary._medal
  end
  ed.UITool.replaceUINew(ui, "avatar", ed.getWholeHeadIcon(param))
  ed.setLabelStroke(ui.online, ed.toccc3(4798501), 1)
  if data._is_online then
    ed.setString(ui.online, T("\229\156\168\231\186\191"))
    ed.setLabelColor(ui.online, ed.toccc3(8972620))
  else
    ed.setString(ui.online, T("\231\166\187\231\186\191"))
    ed.setLabelColor(ui.online, ed.toccc3(11180940))
  end
  return container, ui
end

function AutoChessPlayerInviteWin:refreshDraglist(datas)
  datas = datas or {}
  if 0 < #datas then
    self.ui.label_none_friend_tip:setVisible(false)
  else
    self.ui.label_none_friend_tip:setVisible(true)
    return
  end
  self.uiList = {}
  local contentSize = self.ui.layer_item:getContentSize()
  local ox, oy = contentSize.width / 2, contentSize.height
  local dy = 70
  for i, data in ipairs(datas) do
    local container, ui = self:createItem(data)
    container:setPosition(ccp(ox, oy - dy * i))
    self.draglist:addItem(container)
    local item = {
      container = container,
      ui = ui,
      data = data
    }
    table.insert(self.uiList, item)
  end
  self.draglist:initListHeight(#datas * dy)
end

function AutoChessPlayerInviteWin.create(params)
  local self = base.create("AutoChessPlayerInviteWin")
  setmetatable(self, AutoChessPlayerInviteWin.mt)
  self:initData(params)
  self:initUI(params)
  self:registerTouchHandlers()
  ed.chatNetDataMrg:sendGetAllFriends()
  self:popWindow()
  self:show({skipAnim = true})
  return self
end
