local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessRoomPrepare = class

function class:initData(data)
  self.teamId = data.teamId
  self.isMatching = false
  ed.isCanClickChatLink = true
end

function class:initLabels()
  ed.setLabelShadow(self.ui.lab_start, ccc3(0, 0, 0), ccp(1, 0))
  self.ui.lab_room_tag_wtr:limitWidthByScale(170)
  local oriX = self.ui.lab_room_tag_wtr:getPositionX()
  local rightPos = math.max(oriX + 120, oriX + self.ui.lab_room_tag_wtr:getContentSize().width * self.ui.lab_room_tag_wtr:getScale() + 4)
  self.ui.lab_room_id_wtr:setPositionX(rightPos)
end

function class:isSelfLeader()
  local leader = ed.AutoChessManager:getTeamLeader()
  return leader._user_id == ed.getUserid() and leader._server_id == tonumber(game_server_id)
end

function class:initBaseInfo()
  ed.setString(self.ui.lab_room_id_wtr, self.teamId)
  self.ui.btn_start:setVisible(self:isSelfLeader())
end

function class:resetPlayerUI(...)
  for idx = 1, 4 do
    self.ui["btn_add_" .. idx]:setVisible(false)
    self.ui["lab_wait_" .. idx]:setVisible(false)
    self.ui["img_host_" .. idx]:setVisible(false)
    self.ui["btn_kick_" .. idx]:setVisible(false)
    self.ui["btn_addFriend_" .. idx]:setVisible(false)
  end
end

function class:isMemberLeader(player)
  local userKey = player._user_key
  local leader = ed.AutoChessManager:getTeamLeader()
  return leader._user_id == userKey._user_id and leader._server_id == userKey._server_id
end

function class:isMemberSelf(memberKey)
  return ed.getUserid() == memberKey._user_id and tonumber(game_server_id) == memberKey._server_id
end

function class:showPlayerUI(i, player)
  local summary = player._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 1.55,
    lvoffset = {x = -45, y = -50}
  }
  self.ui["player_bg" .. i]:setVisible(true)
  local head = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(self.ui, "player_bg" .. i, "avatar" .. i, head)
  local node = self.ui["img_bg_" .. i]
  ed.setLabelStroke(self.ui["name" .. i], ed.toccc3(8606258), 1)
  ed.setString(self.ui["name" .. i], summary._name)
  local kickTag = self.ui["btn_kick_" .. i]
  local hostTag = self.ui["img_host_" .. i]
  local waitTag = self.ui["lab_wait_" .. i]
  local levelName = ed.AutoChessRankManager:getRankGradeInfoByScore(player._score or 0)
  ed.setString(self.ui["level" .. i], levelName.name)
  local state = player._status
  if state and state == "team_chess_matching" then
    waitTag:setVisible(true)
    ed.setString(waitTag, T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
  elseif state and state == "team_chess_gaming" then
    waitTag:setVisible(true)
    ed.setString(waitTag, T("\230\173\163\229\156\168\230\184\184\230\136\143\228\184\173"))
  else
    waitTag:setVisible(false)
  end
  hostTag:setVisible(self:isMemberLeader(player))
  local isShowKick = not self:isMemberSelf(player._user_key) and self:isSelfLeader()
  kickTag:setVisible(isShowKick)
end

function class:showEmptyUI(index)
  local kickTag = self.ui["btn_kick_" .. index]
  local hostTag = self.ui["img_host_" .. index]
  local addTag = self.ui["btn_add_" .. index]
  addTag:setZOrder(2)
  local imgBg = self.ui["player_bg" .. index]
  imgBg:setVisible(false)
  addTag:setVisible(true)
  kickTag:setVisible(false)
  hostTag:setVisible(false)
end

function class:updatePlayerUI()
  local playerList = ed.AutoChessManager:getTeamMembers()
  for i = 1, 4 do
    local player = playerList[i]
    if player then
      self:showPlayerUI(i, player)
    else
      self:showEmptyUI(i)
    end
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessRoomPrepare, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:initBaseInfo()
  self:resetPlayerUI()
  self:updatePlayerUI()
end

function class:onClickClose()
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  ed.showConfirmDialog({
    text = T("\229\189\147\229\137\141\230\173\163\229\156\168\231\173\137\229\190\133\231\142\169\229\174\182\239\188\140\230\152\175\229\144\166\231\161\174\229\174\154\233\128\128\229\135\186\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      local serverId, userId = game_server_id, ed.getUserid()
      ed.AutoChessNetwork:sendTeamQuit(serverId, userId)
      ed.AutoChessManager:setChessTeamInfo(false, 0)
      ed.isCanClickChatLink = false
      self:destroy({skipAnim = true})
    end
  })
end

function class:onInviteClick(index)
  if ed.player:getLevel() < 10 then
    ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\232\167\163\233\148\129\229\165\189\229\143\139\229\146\140\232\129\138\229\164\169\229\138\159\232\131\189"))
    return
  end
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local playerList = ed.AutoChessManager:getTeamMembers()
  if playerList[index] then
    return
  end
  self.invitePanel = ed.ui.AutoChessPlayerInviteWin.create({
    room_id = self.teamId,
    link_type = "chess_team",
    closeCallback = function()
      self.invitePanel = nil
    end
  })
end

function class:onKickClick(index)
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local playerList = ed.AutoChessManager:getTeamMembers()
  local player = playerList[index]
  if not player then
    return
  end
  if not self:isSelfLeader() then
    return
  end
  local memberKey = player._user_key
  local serverId, userId = tonumber(game_server_id), ed.getUserid()
  local targetSid, targetUid = memberKey._server_id, memberKey._user_id
  ed.AutoChessNetwork:sendTeamKick(serverId, userId, targetSid, targetUid)
end

function class:onClickBtnCopyWtr()
  local str = self.teamId
  if EDFLAGWIN32 then
    ed.showToast(T("\230\154\130\228\184\141\230\148\175\230\140\129win32\231\154\132copy\239\188\140\232\175\183\230\137\147\229\140\133\230\181\139\232\175\149"))
    return
  end
  if EDCopyStringToSystem then
    EDCopyStringToSystem(str)
    ed.showToast(T("\230\136\191\233\151\180\231\188\150\229\143\183\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\229\136\135\230\157\191"))
  else
    ed.showToast(T("\230\154\130\230\156\170\229\174\158\231\142\176"))
  end
end

function class:onClickStart()
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  if self:isSelfLeader() then
    local version = ed.storage.getString("current-version")
    ed.AutoChessNetwork:sendChessMatchStart(version, "casual")
  end
end

function class:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_close_wtr", function()
    self:onClickClose()
  end)
  for i = 1, 4 do
    ed.UITool.registerBtn(self, "btn_add_" .. i, function()
      self:onInviteClick(i)
    end)
    ed.UITool.registerBtn(self, "btn_kick_" .. i, function()
      self:onKickClick(i)
    end)
  end
  ed.UITool.registerBtn(self, "btn_copy_wtr", function()
    self:onClickBtnCopyWtr()
  end)
  ed.UITool.registerBtn(self, "btn_start", function()
    self:onClickStart()
  end)
end

function class:onEventEnterForeground()
  ed.AutoChessNetwork:sendTeamHeartBeat()
end

function class:onEventChessTeamQuitNotify(data)
  local kickMember = data._member_key
  local opMember = data._op_key
  local reason = data._reason
  local isSelf = self:isMemberSelf(kickMember)
  if isSelf then
    if reason == "self" then
    elseif reason == "kick" then
      ed.showToast(T("\228\189\160\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
      self:destroy({skipAnim = true})
    elseif reason == "dismiss" then
      ed.showToast(T("\233\152\159\228\188\141\229\183\178\232\167\163\230\149\163"))
    end
  elseif reason == "self" then
    self:resetPlayerUI()
    self:updatePlayerUI()
    ed.showToast(T("\231\142\169\229\174\182\233\128\128\229\135\186\233\152\159\228\188\141"))
  elseif reason == "kick" then
    self:resetPlayerUI()
    self:updatePlayerUI()
    ed.showToast(T("\231\142\169\229\174\182\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
  elseif reason == "dismiss" then
    ed.showToast(T("\233\152\159\228\188\141\229\183\178\232\167\163\230\149\163"))
  end
end

function class:onEventChessTeamLeaderNotify(data)
  if data._new_leader then
    self:resetPlayerUI()
    self:updatePlayerUI()
  end
  self.ui.btn_start:setVisible(self:isSelfLeader())
end

function class:onEventChessTeamStatusNotify()
  self:resetPlayerUI()
  self:updatePlayerUI()
end

function class:onEventChessTeamJoinNotify(member)
  if member then
    self:resetPlayerUI()
    self:updatePlayerUI()
  end
end

function class:destroy(param)
  base.destroy(self, param)
  if self.invitePanel then
    self.invitePanel:destroy(param.skipAnim)
    self.invitePanel = nil
  end
end

function class:registerEvents()
  self:listenEvent("EventChessMatchCancel", function()
    self.isMatching = false
  end)
  self:listenEvent("EventChessTeamQuit", function()
    ed.AutoChessNetwork:closeTeamConnection()
    ed.showToast(T("\233\128\128\229\135\186\229\189\147\229\137\141\233\152\159\228\188\141"))
  end)
  self:listenEvent("EventChessTeamJoinNotify", function(data)
    self:onEventChessTeamJoinNotify(data)
  end)
  self:listenEvent("EventChessTeamQuitNotify", function(data)
    self:onEventChessTeamQuitNotify(data)
  end)
  self:listenEvent("EventChessTeamLeaderNotify", function(data)
    self:onEventChessTeamLeaderNotify(data)
  end)
  self:listenEvent("EventChessCloseTeamPrepare", function()
    ed.isCanClickChatLink = false
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("EventChessMatchStart", function()
    self.isMatching = true
  end)
  self:listenEvent("EventChessTeamStatusNotify", function()
    self:onEventChessTeamStatusNotify()
  end)
  self:listenEvent("EventChessTeamNotAlive", function()
    ed.showToast(T("\228\189\160\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
    ed.isCanClickChatLink = false
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("EventMatchTimoutNotify", function()
    self.isMatching = false
  end)
  self:listenEvent("EventJoinTimoutNotify", function()
    self.isMatching = false
  end)
  self:listenEvent("applicationWillEnterForeground", function(...)
    self:onEventEnterForeground()
  end)
end

function class.create(data)
  local self = base.create("AutoChessRoomPrepare")
  setmetatable(self, class.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  return self
end
