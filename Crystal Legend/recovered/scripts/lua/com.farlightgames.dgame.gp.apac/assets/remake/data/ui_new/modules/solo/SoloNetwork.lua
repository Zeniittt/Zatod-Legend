local SoloNetwork = {}
SoloNetwork.__index = SoloNetwork
SoloNetwork.SoloNetworkScope = {}

function SoloNetwork.isDebug()
  return true
end

function SoloNetwork.getInstance()
  if not SoloNetwork.instance then
    SoloNetwork.instance = SoloNetwork.create()
  end
  return SoloNetwork.instance
end

function SoloNetwork.create()
  local self = {}
  setmetatable(self, SoloNetwork)
  self:ListenEvent()
  return self
end

function SoloNetwork:ListenEvent()
  CloseScope(SoloNetwork.SoloNetworkScope)
  ListenEvent("SocketL_Solo_Error", function(error_code)
    if error_code == -1 then
      self:reConnection()
    end
  end, SoloNetwork.SoloNetworkScope)
  ListenEvent("SocketL_Solo_Succeed", function(ip, port)
    self.is_connected = true
    if ed.SoloManager:isJoinGame() then
      return
    end
    local version = ed.storage.getString("current-version")
    local gameId = ed.SoloManager:getGameId()
    print("SocketL_Solo_Connect_Succeed_" .. ip .. "_" .. port .. "_" .. gameId .. "_" .. version .. "_" .. tostring(self.isJoinSent))
    print("isReconnect", ed.SoloManager:isReconnectMode())
    local isReconnect = ed.SoloManager:isReconnectMode() and 1 or 0
    self:sendChessJoin(gameId, version, isReconnect)
  end, SoloNetwork.SoloNetworkScope)
end

function SoloNetwork:checkReconnect()
  if not ed.socket_long_solo.isSocketConnected() then
    ed.showToast("\233\135\141\230\150\176\232\191\158\230\142\165")
    self:reConnection()
  end
end

function SoloNetwork:reConnection(...)
  if self.ip and self.ip ~= 0 then
    self:doGameConnect(self.ip, self.port, self.svrid)
  end
end

function SoloNetwork:doGameConnect(ip, port, svrid)
  self.isJoinSent = false
  self.ip, self.port, self.svrid = ip, port, svrid
  ed.socket_long_solo.doConnection(self.ip, self.port, nil, self.svrid)
end

function SoloNetwork:doGameDisConnect()
  if self.is_connected then
    self.is_connected = false
    ed.socket_long_solo.doCloseConnection()
  end
  if self.timer_heart_beat then
    CloseTimer(self.timer_heart_beat.Name)
    self.timer_heart_beat = nil
  end
  self.gameId = 0
  self.ip, self.port = 0, 0
end

function SoloNetwork:handlerErrorCode(code)
  if code == "chess_is_maintaining" then
    ed.showAlertDialog({
      text = T("\230\173\163\229\156\168\231\187\180\230\138\164\228\184\173")
    })
  elseif code == "solo_game_over" then
    ed.SoloManager.isGameing = false
    if ed.getCurrentScene().identity == "SoloBattleScene" then
      ed.showAlertDialog({
        text = T("\230\184\184\230\136\143\229\183\178\231\187\143\231\187\147\230\157\159"),
        handler = function()
          ed.popScene()
        end
      })
    end
  elseif code == "solo_shop_refresh_times_limit" then
    ed.showToast(T("\229\183\178\232\190\190\229\136\176\229\155\158\229\144\136\229\136\183\230\150\176\228\184\138\233\153\144"))
  elseif code == "team_client_version_uncompared" then
    ed.showToast(T("\229\174\162\230\136\183\231\171\175\231\137\136\230\156\172\229\143\183\228\184\141\228\184\128\232\135\180"))
  elseif code == "chess_gold_not_enough" then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
  elseif code == "chess_game_type_not_open" then
    ed.showToast(T("\230\154\130\230\156\170\229\188\128\229\144\175"))
  elseif code == "solo_match_in_game" then
    ed.showToast(T("\229\143\150\230\182\136\229\140\185\233\133\141"))
    ed.popScene()
  else
    print(code)
  end
end

function SoloNetwork:dispatchChessReply(reply)
  if reply._error_code then
    self:handlerErrorCode(reply._error_code)
    return
  end
  if reply._open_panel then
    ed.SoloManager:handlerOpenPanel(reply._open_panel)
  elseif reply._match_start then
    ed.SoloManager:handlerMatchStart(reply._match_start)
  elseif reply._match_cancel then
    ed.SoloManager:handlerMatchCancel()
  elseif reply._rookie_start then
  elseif reply._rookie_finish then
  elseif reply._resolve_rookie then
  elseif reply._query_records then
    ed.ui.soloHistoryPop.create(reply._query_records._records)
  elseif reply._record_detail then
    ed.ui.SoloTabWin.create(reply._record_detail._dashboard._users)
  elseif reply._grade_rewards then
    local rewards = reply._grade_rewards._rewards or {}
    local grade = reply._grade_rewards._grade
    if 0 < #rewards then
      ed.player:addRewards(rewards)
      ed.UITool.showRewardsFromServer(rewards)
      ed.SoloManager:setGradeRewardFlags(grade)
    end
  end
end

function SoloNetwork:dispatchChessGameReply(gameReply)
  print("--------------dispatchSoloGameReply---------------")
  if gameReply._error_code then
    self:handlerErrorCode(gameReply._error_code)
    return
  end
  if gameReply._join then
    ed.SoloManager:handlerJoinGame(gameReply._join)
  elseif gameReply._shop_refresh then
    ed.SoloManager:handlerShopRefresh(gameReply._shop_refresh)
  elseif gameReply._battle_confirm then
    ed.SoloManager:handlerBattleConfirmNet(gameReply._battle_confirm)
  elseif gameReply._choose_power then
    ed.SoloManager:handlerChoosePower(gameReply._choose_power)
  elseif gameReply._choose_hero then
    ed.SoloManager:handlerChooseHero(gameReply._choose_hero)
  elseif gameReply._use_power then
    ed.SoloManager:handlerUsePower(gameReply._use_power)
  elseif gameReply._buy_card then
    ed.SoloManager:handlerBuyCard(gameReply._buy_card)
  elseif gameReply._refresh_choices then
    ed.SoloManager:handlerRefreshChoice(gameReply._refresh_choices)
  elseif gameReply._monitor_player then
    ed.SoloManager:handlerMonitorPlayer(gameReply._monitor_player)
  elseif gameReply._quit then
  elseif gameReply._spectate_enter then
    ed.SoloManager:handlerSpectateEnter(gameReply._spectate_enter)
  elseif gameReply._emoji then
  elseif gameReply._view_journal then
    ed.SoloManager:handlerViewJournal(gameReply._view_journal)
  elseif gameReply._view_dashboard then
    ed.SoloManager:handlerViewDashboard(gameReply._view_dashboard)
  elseif gameReply._heartbeat then
    print("___________________chess heart beat ______________________")
  end
end

function SoloNetwork:dispatchChessNotify(notify)
  print("--------------dispatchChessNotify---------------")
  if notify._game_start then
    ed.SoloManager:handlerStartNotify(notify._game_start)
  elseif notify._match_timeout then
    ed.SoloManager:handlerMatchTimoutNotify()
  elseif notify._join_timeout then
    ed.SoloManager:handlerJoinTimoutNotify()
  elseif notify._loading_sync then
    ed.SoloManager:handlerLoadNotify(notify._loading_sync)
  elseif notify._wait_choose then
    ed.SoloManager:handlerWaitChooseNotify(notify._wait_choose)
  elseif notify._round_sync then
    ed.SoloManager:handlerRoundNotify(notify._round_sync)
  elseif notify._game_rank then
    ed.SoloManager:handlerRankNotify(notify._game_rank)
  elseif notify._game_over then
    ed.SoloManager:handlerSettleNotify(notify._game_over)
  elseif notify._user_status then
    ed.SoloManager:handlerStatusNotify(notify._user_status)
  elseif notify._level_up then
    ed.SoloManager:handlerLevelNotify(notify._level_up)
  elseif notify._event then
    ed.SoloManager:handlerEventNotify(notify._event)
  elseif notify._action then
    ed.SoloManager:handlerActionNotify(notify._action)
  elseif notify._effect then
    ed.SoloManager:handlerEffectNotify(notify._effect)
  end
end

function SoloNetwork:doSend(output, msg, type, noprint)
  if not ed.debug_mode or not noprint then
  end
  output(msg, type)
end

function SoloNetwork:sendChessOpenPanel()
  local msg = ed.upmsg.solo_req()
  msg._open_panel = ed.upmsg.solo_open_panel()
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendChessMatchStart(version, type)
  local msg = ed.upmsg.solo_req()
  msg._match_start = ed.upmsg.solo_match_start()
  msg._match_start._version = version
  msg._match_start._game_type = type
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendChessMatchCancel()
  local msg = ed.upmsg.solo_req()
  msg._match_cancel = ed.upmsg.solo_match_cancel()
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendChessSkipGuide()
  local msg = ed.upmsg.solo_req()
  msg._resolve_rookie = ed.upmsg.solo_resolve_rookie()
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendChessStartGuide()
  local msg = ed.upmsg.solo_req()
  msg._rookie_start = ed.upmsg.solo_rookie_start()
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendChessFinishGuide(hids, positions)
  local msg = ed.upmsg.solo_req()
  msg._rookie_finish = ed.upmsg.solo_rookie_finish()
  local version = ed.storage.getString("current-version")
  msg._rookie_finish._version = version
  msg._rookie_finish._hero_ids = hids
  msg._rookie_finish._positions = positions
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendSoloQueryRecords()
  local msg = ed.upmsg.solo_req()
  msg._query_records = ed.upmsg.solo_query_records()
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendSoloRecordDetail(record_id)
  local msg = ed.upmsg.solo_req()
  msg._record_detail = ed.upmsg.solo_record_detail()
  msg._record_detail._record_id = record_id
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:sendSoloGradeRewards(grade)
  local msg = ed.upmsg.solo_req()
  msg._grade_rewards = ed.upmsg.solo_grade_rewards()
  msg._grade_rewards._grade = grade
  self:doSend(ed.send, msg, "solo")
end

function SoloNetwork:createHeartBeat()
  if self.timer_heart_beat then
    CloseTimer(self.timer_heart_beat.Name)
    self.timer_heart_beat = nil
  end
  self.timer_heart_beat = ListenTimer(Timer:Always(ed.socket_long_solo.heart_beat_interval), function()
    self:sendChessHeartBeat()
  end)
end

function SoloNetwork:sendChessHeartBeat()
  if not ed.SoloManager.isGameing then
    return
  end
  local up_msg = ed.upmsg.solo_game_req()
  up_msg._heartbeat = ed.upmsg.solo_heartbeat()
  local userKey = ed.SkillPlayer.getMyUserKey()
  up_msg._heartbeat._user_key = ed.commonmsg.solo_user_key()
  up_msg._heartbeat._user_key._server_id = userKey._server_id
  up_msg._heartbeat._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_solo.send, up_msg, "solo_game", true)
end

function SoloNetwork:sendChessQuit()
  local msg = ed.upmsg.solo_game_req()
  msg._quit = ed.upmsg.solo_quit()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._quit._user_key = ed.commonmsg.solo_user_key()
  msg._quit._user_key._server_id = userKey._server_id
  msg._quit._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChessJoin(gameId, version, isReconnect)
  local msg = ed.upmsg.solo_game_req()
  msg._join = ed.upmsg.solo_join()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._join._user_key = ed.commonmsg.solo_user_key()
  msg._join._user_key._server_id = userKey._server_id
  msg._join._user_key._user_id = userKey._user_id
  msg._join._game_id = gameId
  msg._join._version = version
  msg._join._is_reconnect = isReconnect
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChessLoading(progress, isFinish)
  local msg = ed.upmsg.solo_game_req()
  msg._loading = ed.upmsg.solo_loading()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._loading._user_key = ed.commonmsg.solo_user_key()
  msg._loading._user_key._server_id = userKey._server_id
  msg._loading._user_key._user_id = userKey._user_id
  msg._loading._progress = progress
  msg._loading._is_finish = isFinish
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChessReconnect(gameId, version)
  local msg = ed.upmsg.solo_game_req()
  msg._reconnect = ed.upmsg.chess_reconnect()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._reconnect._user_key = ed.commonmsg.solo_user_key()
  msg._reconnect._user_key._server_id = userKey._server_id
  msg._reconnect._user_key._user_id = userKey._user_id
  msg._reconnect._game_id = gameId
  msg._reconnect._version = version
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChessShopRefresh()
  local msg = ed.upmsg.solo_game_req()
  msg._shop_refresh = ed.upmsg.solo_shop_refresh()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._shop_refresh._user_key = ed.commonmsg.solo_user_key()
  msg._shop_refresh._user_key._server_id = userKey._server_id
  msg._shop_refresh._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChessRandomBuy()
  local msg = ed.upmsg.solo_game_req()
  msg._buy_card = ed.upmsg.solo_buy_card()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._buy_card._user_key = ed.commonmsg.solo_user_key()
  msg._buy_card._user_key._server_id = userKey._server_id
  msg._buy_card._user_key._user_id = userKey._user_id
  msg._buy_card._random = 1
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChooseHeroPower(powerPos, optionIndex, isConfirmed)
  local msg = ed.upmsg.solo_game_req()
  msg._choose_power = ed.upmsg.solo_choose_power()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._choose_power._user_key = ed.commonmsg.solo_user_key()
  msg._choose_power._user_key._server_id = userKey._server_id
  msg._choose_power._user_key._user_id = userKey._user_id
  msg._choose_power._power_pos = powerPos
  msg._choose_power._option_index = optionIndex
  msg._choose_power._is_confirmed = isConfirmed
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChooseChessHero(chooseId, index, isConfirmed)
  local msg = ed.upmsg.solo_game_req()
  msg._choose_hero = ed.upmsg.solo_choose_hero()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._choose_hero._user_key = ed.commonmsg.solo_user_key()
  msg._choose_hero._user_key._server_id = userKey._server_id
  msg._choose_hero._user_key._user_id = userKey._user_id
  msg._choose_hero._choose_id = chooseId
  msg._choose_hero._option_index = index
  msg._choose_hero._is_confirmed = isConfirmed
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendUseHeroPower(id, pos, params)
  local msg = ed.upmsg.solo_game_req()
  msg._use_power = ed.upmsg.solo_use_power()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._use_power._user_key = ed.commonmsg.solo_user_key()
  msg._use_power._user_key._server_id = userKey._server_id
  msg._use_power._user_key._user_id = userKey._user_id
  msg._use_power._power_pos = pos
  msg._use_power._power_id = id
  msg._use_power._params = params
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendBuyCard(index)
  local msg = ed.upmsg.solo_game_req()
  msg._buy_card = ed.upmsg.solo_buy_card()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._buy_card._user_key = ed.commonmsg.solo_user_key()
  msg._buy_card._user_key._server_id = userKey._server_id
  msg._buy_card._user_key._user_id = userKey._user_id
  msg._buy_card._card_index = index
  msg._buy_card._random = 0
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendRefreshChoices(isPay)
  local msg = ed.upmsg.solo_game_req()
  msg._refresh_choices = ed.upmsg.solo_refresh_choices()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._refresh_choices._user_key = ed.commonmsg.solo_user_key()
  msg._refresh_choices._user_key._server_id = userKey._server_id
  msg._refresh_choices._user_key._user_id = userKey._user_id
  msg._refresh_choices._is_pay = isPay and 1 or 0
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendSpectateEnter(uid, sid)
  local msg = ed.upmsg.solo_game_req()
  msg._spectate_enter = ed.upmsg.solo_spectate_enter()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._spectate_enter._user_key = ed.commonmsg.solo_user_key()
  msg._spectate_enter._user_key._server_id = userKey._server_id
  msg._spectate_enter._user_key._user_id = userKey._user_id
  msg._spectate_enter._target_key = ed.commonmsg.solo_user_key()
  msg._spectate_enter._target_key._server_id = sid
  msg._spectate_enter._target_key._user_id = uid
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendMonitorPlayer(uid, sid)
  local msg = ed.upmsg.solo_game_req()
  msg._monitor_player = ed.upmsg.solo_monitor_player()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._monitor_player._user_key = ed.commonmsg.solo_user_key()
  msg._monitor_player._user_key._server_id = userKey._server_id
  msg._monitor_player._user_key._user_id = userKey._user_id
  msg._monitor_player._target_key = ed.commonmsg.solo_user_key()
  msg._monitor_player._target_key._server_id = sid
  msg._monitor_player._target_key._user_id = uid
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendChatContent(content)
  local msg = ed.upmsg.solo_game_req()
  msg._emoji = ed.upmsg.solo_emoji()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._emoji._user_key = ed.commonmsg.solo_user_key()
  msg._emoji._user_key._server_id = userKey._server_id
  msg._emoji._user_key._user_id = userKey._user_id
  msg._emoji._content = content
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
  FireEvent("SoloChatContentNotify", msg._emoji)
end

function SoloNetwork:sendChessBattleConfirm(result, battleTime, round)
  local msg = ed.upmsg.solo_game_req()
  msg._battle_confirm = ed.upmsg.solo_battle_confirm()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._battle_confirm._user_key = ed.commonmsg.solo_user_key()
  msg._battle_confirm._user_key._server_id = userKey._server_id
  msg._battle_confirm._user_key._user_id = userKey._user_id
  msg._battle_confirm._round = round
  msg._battle_confirm._result = ed.upmsg.solo_battle_result()
  msg._battle_confirm._result._result = result
  msg._battle_confirm._result._battle_time = battleTime
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendViewJournal(round)
  local msg = ed.upmsg.solo_game_req()
  msg._view_journal = ed.upmsg.solo_view_journal()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._view_journal._user_key = ed.commonmsg.solo_user_key()
  msg._view_journal._user_key._server_id = userKey._server_id
  msg._view_journal._user_key._user_id = userKey._user_id
  msg._view_journal._begin_round = round
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:sendViewDashboard()
  local msg = ed.upmsg.solo_game_req()
  msg._view_dashboard = ed.upmsg.solo_view_dashboard()
  local userKey = ed.SkillPlayer.getMyUserKey()
  msg._view_dashboard._user_key = ed.commonmsg.solo_user_key()
  msg._view_dashboard._user_key._server_id = userKey._server_id
  msg._view_dashboard._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_solo.send, msg, "solo_game")
end

function SoloNetwork:openTeamConnection(ip, port, svrid)
  self.team_ip, self.team_port, self.team_svrid = ip, port, svrid
  self.is_team_connected = true
  ed.socket_long.doConnection(ip, port, true, svrid)
end

function SoloNetwork:closeTeamConnection()
  if self.is_team_connected then
    self.is_team_connected = false
    ed.socket_long.doCloseConnection()
  end
  if self.team_timer_heart_beat then
    CloseTimer(self.team_timer_heart_beat.Name)
    self.team_timer_heart_beat = nil
  end
  self.team_ip, self.team_port = 0, 0
end

function SoloNetwork:createTeamHeartBeat()
  if self.team_timer_heart_beat then
    CloseTimer(self.team_timer_heart_beat.Name)
    self.team_timer_heart_beat = nil
  end
  self.team_timer_heart_beat = ListenTimer(Timer:Always(ed.socket_long.heart_beat_interval), function()
    self:sendTeamHeartBeat()
  end)
end

function SoloNetwork:sendTeamHeartBeat()
  local msg = ed.upmsg.team_req()
  msg._heartbeat = ed.upmsg.team_heartbeat()
  msg._heartbeat._member_key = ed.commonmsg.team_member_key()
  local serverId, userId = game_server_id, ed.getUserid()
  msg._heartbeat._member_key._server_id = tonumber(serverId)
  msg._heartbeat._member_key._user_id = userId
  self:doSend(ed.socket_long.send, msg, "team", true)
  self:addTeamHeartBeat()
end

function SoloNetwork:addTeamHeartBeat()
  self.notReceveCount = self.notReceveCount or 0
  self.notReceveCount = self.notReceveCount + 1
  if self.notReceveCount > 1 then
    self:openTeamConnection(self.team_ip, self.team_port)
    self.notReceveCount = 0
  end
end

function SoloNetwork:resetTeamHeartBeat()
  self.notReceveCount = 0
end

function SoloNetwork:sendTeamOpenPanel()
  local msg = ed.upmsg.team_req()
  msg._open_panel = ed.upmsg.team_open_panel()
  self:doSend(ed.send, msg, "team")
end

function SoloNetwork:sendTeamCreate(target)
  local msg = ed.upmsg.team_req()
  msg._create = ed.upmsg.team_create()
  msg._create._target = target
  local version = ed.storage.getString("current-version")
  msg._create._version = version
  ed.TeamNetwork.teamTarget = target
  self:doSend(ed.send, msg, "team")
end

function SoloNetwork:sendTeamQuery(teamId)
  local msg = ed.upmsg.team_req()
  msg._query = ed.upmsg.team_query()
  msg._query._team_id = teamId
  ed.TeamNetwork.teamTarget = "solo_casual"
  self:doSend(ed.send, msg, "team")
end

function SoloNetwork:sendTeamApply(teamTarget, teamId)
  local msg = ed.upmsg.team_req()
  msg._apply = ed.upmsg.team_apply()
  msg._apply._team_target = teamTarget
  msg._apply._team_id = teamId
  local version = ed.storage.getString("current-version")
  msg._apply._version = version
  ed.TeamNetwork.teamTarget = teamTarget
  self:doSend(ed.send, msg, "team")
end

function SoloNetwork:sendTeamJoin(serverId, userId)
  serverId = tonumber(serverId)
  local msg = ed.upmsg.team_req()
  msg._join = ed.upmsg.team_join()
  msg._join._member_key = ed.commonmsg.team_member_key()
  msg._join._member_key._server_id = serverId
  msg._join._member_key._user_id = userId
  local version = ed.storage.getString("current-version")
  msg._join._version = version
  self:doSend(ed.socket_long.send, msg, "team")
end

function SoloNetwork:sendTeamQuit(serverId, userId)
  serverId = tonumber(serverId)
  local msg = ed.upmsg.team_req()
  msg._quit = ed.upmsg.team_quit()
  msg._quit._member_key = ed.commonmsg.team_member_key()
  msg._quit._member_key._server_id = serverId
  msg._quit._member_key._user_id = userId
  self:doSend(ed.socket_long.send, msg, "team")
end

function SoloNetwork:sendTeamKick(serverId, userId, targetSid, targetUid)
  local msg = ed.upmsg.team_req()
  msg._kick = ed.upmsg.team_kick()
  msg._kick._member_key = ed.commonmsg.team_member_key()
  msg._kick._member_key._server_id = serverId
  msg._kick._member_key._user_id = userId
  msg._kick._target_key = ed.commonmsg.team_member_key()
  msg._kick._target_key._server_id = targetSid
  msg._kick._target_key._user_id = targetUid
  self:doSend(ed.socket_long.send, msg, "team")
end

function SoloNetwork:onDisconnectTeam(...)
  self:closeTeamConnection()
  if self.team_timer_heart_beat then
    CloseTimer(self.team_timer_heart_beat.Name)
    self.team_timer_heart_beat = nil
  end
end

function SoloNetwork:dispatchChessTeamReply(reply)
  if not reply._heartbeat then
  end
  if reply._error_code then
    local code = reply._error_code
    if code == "team_query_not_found" then
      ed.showToast(T("\233\152\159\228\188\141\228\184\141\229\173\152\229\156\168"))
    elseif code == "team_not_alive" then
      self:closeTeamConnection()
      self:onDisconnectTeam()
      ed.SoloManager:clearTeamData()
      ed.SoloManager:setTeamInfo(false, 0)
      FireEvent("EventChessTeamNotAlive")
    elseif code == "team_member_full" then
      ed.showToast(T("\233\152\159\228\188\141\229\183\178\230\187\161"))
    elseif code == "team_not_exsits" then
      ed.showToast(T("\233\152\159\228\188\141\229\183\178\232\167\163\230\149\163"))
    elseif code == "team_target_not_match" then
      ed.showToast(T("\233\152\159\228\188\141\228\184\141\229\173\152\229\156\168"))
    end
    FireEvent("EventChessTeamErrorCode")
    return
  end
  if reply._open_panel then
    local data = reply._apply or {}
    if reply._open_panel._is_in_team and reply._open_panel._is_in_team ~= 0 then
      local teamSummary = reply._open_panel._team_summary
      local teamId = teamSummary._id
      local teamTarget = teamSummary._target
      self:sendTeamApply(teamTarget, teamId)
    else
      return
    end
  elseif reply._create then
    local data = reply._create
    self.team_id = data._team_id or 0
    local ip, port, svrid = ed.getIPPortFromString(data._team_addr)
    self:openTeamConnection(ip, port, svrid)
    local serverId, userId = game_server_id, ed.getUserid()
    self:sendTeamJoin(serverId, userId)
  elseif reply._query then
    local queryData = reply._query
    local teamSummary = queryData._team_summary
    local teamId = teamSummary._id
    local teamTarget = queryData._team_target
    self:sendTeamApply(teamTarget, teamId)
    FireEvent("EventChessTeamQuery")
  elseif reply._apply then
    local data = reply._apply
    self.team_id = data._team_id or 0
    local ip, port, svrid = ed.getIPPortFromString(data._team_addr)
    self:openTeamConnection(ip, port, svrid)
    local serverId, userId = game_server_id, ed.getUserid()
    self:sendTeamJoin(serverId, userId)
    FireEvent("EventChessTeamApply")
  elseif reply._join then
    local data = reply._join
    ed.SoloManager:setTeamMembers(data._team_summary._members)
    ed.SoloManager:updateTeamLeader(data._team_summary._leader)
    FireEvent("SoloTeamJoin", reply._join, self.team_id)
  elseif reply._quit then
    self:onDisconnectTeam()
    ed.SoloManager:setTeamInfo(false, 0)
    ed.SoloManager:clearTeamData()
    FireEvent("EventChessTeamQuit")
  elseif reply._kick then
    FireEvent("EventChessTeamKick")
  end
  if reply._heartbeat then
    self:resetTeamHeartBeat()
  end
end

function SoloNetwork:dispatchChessTeamNotify(notify)
  if notify._error_code then
    if notify._error_code == "team_not_alive" then
      self:onDisconnectTeam()
      ed.SoloManager:clearTeamData()
      ed.SoloManager:setTeamInfo(false, 0)
      FireEvent("EventChessTeamNotAlive")
    end
    FireEvent("EventChessNotifyErrorCode")
    return
  end
  local teamId = notify._team_id
  if teamId ~= self.team_id then
    return
  end
  if notify._join then
    local data = notify._join
    local teamMember = data._member
    ed.SoloManager:updateTeamMember(teamMember, "join")
    FireEvent("EventChessTeamJoinNotify", teamMember)
  elseif notify._quit then
    local data = notify._quit
    local kickMember = data._member_key
    local isSelf = ed.getUserid() == kickMember._user_id and tonumber(game_server_id) == kickMember._server_id
    if isSelf then
      self:onDisconnectTeam()
    end
    ed.SoloManager:updateTeamMember(kickMember, "kick")
    FireEvent("EventChessTeamQuitNotify", data)
  elseif notify._leader_change then
    local data = notify._leader_change
    local newLeader = data._new_leader
    ed.SoloManager:updateTeamLeader(newLeader)
    FireEvent("EventChessTeamLeaderNotify", notify._leader_change)
  elseif notify._member_status then
    local data = notify._member_status
    local memberKeys = data._member_keys
    local status = data._status
    ed.SoloManager:updateTeamMemberStatus(memberKeys, status)
    FireEvent("EventChessTeamStatusNotify")
  end
end

ed.SoloNetwork = SoloNetwork.create()

function ed.showAutoChessInvite(reply)
  local teamId = reply._team_id
  if ed.getCurrentScene().identity ~= "SoloArenaScene" then
    ed.SoloManager:setTeamInfo(true, teamId)
    ed.SoloNetwork:sendChessOpenPanel()
  else
    ed.SoloNetwork:sendTeamQuery(teamId)
  end
end
