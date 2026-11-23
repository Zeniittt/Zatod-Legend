local AutoChessNetwork = {}
AutoChessNetwork.__index = AutoChessNetwork
AutoChessNetwork.AutoChessNetworkScope = {}

function AutoChessNetwork.isDebug()
  return true
end

function AutoChessNetwork.getInstance()
  if not AutoChessNetwork.instance then
    AutoChessNetwork.instance = AutoChessNetwork.create()
  end
  return AutoChessNetwork.instance
end

function AutoChessNetwork.create()
  local self = {}
  setmetatable(self, AutoChessNetwork)
  self:ListenEvent()
  return self
end

function AutoChessNetwork:ListenEvent()
  CloseScope(AutoChessNetwork.AutoChessNetworkScope)
  ListenEvent("SocketL_Chess_Error", function(error_code)
    if error_code == -1 then
      self:reConnection()
    end
  end, AutoChessNetwork.AutoChessNetworkScope)
  ListenEvent("SocketL_Chess_Succeed", function(ip, port)
    self.is_connected = true
    if ed.AutoChessManager:isJoinGame() then
      return
    end
    local version = ed.storage.getString("current-version")
    local gameId = ed.AutoChessManager:getGameId()
    print("SocketL_Chess_Connect_Succeed_" .. ip .. "_" .. port .. "_" .. gameId .. "_" .. version .. "_" .. tostring(self.isJoinSent))
    local isReconnect = ed.AutoChessManager:isReconnectMode() and 1 or 0
    self:sendChessJoin(gameId, version, isReconnect)
  end, AutoChessNetwork.AutoChessNetworkScope)
end

function AutoChessNetwork:checkReconnect()
  if not ed.socket_long_chess.isSocketConnected() then
    ed.showToast("\233\135\141\230\150\176\232\191\158\230\142\165")
    self:reConnection()
  end
end

function AutoChessNetwork:reConnection(...)
  if self.ip and self.ip ~= 0 then
    self:doGameConnect(self.ip, self.port, self.svrid)
  end
end

function AutoChessNetwork:doGameConnect(ip, port, svrid)
  self.isJoinSent = false
  self.ip, self.port, self.svrid = ip, port, svrid
  ed.socket_long_chess.doConnection(self.ip, self.port, nil, self.svrid)
end

function AutoChessNetwork:doGameDisConnect()
  if self.is_connected then
    self.is_connected = false
    ed.socket_long_chess.doCloseConnection()
  end
  if self.timer_heart_beat then
    CloseTimer(self.timer_heart_beat.Name)
    self.timer_heart_beat = nil
  end
  self.gameId = 0
  self.ip, self.port = 0, 0
end

function AutoChessNetwork:handlerErrorCode(code)
  if code == "chess_is_maintaining" then
    ed.showAlertDialog({
      text = T("\230\173\163\229\156\168\231\187\180\230\138\164\228\184\173")
    })
  elseif code == "chess_game_over" then
    if ed.getCurrentScene().identity == "AutoChessBattleScene" and ed.IsAutoChessMode() then
      ed.showAlertDialog({
        text = T("\230\184\184\230\136\143\229\183\178\231\187\143\231\187\147\230\157\159"),
        handler = function()
          ed.popScene()
        end
      })
    end
  elseif code == "chess_hero_max" then
    ed.showToast(T("\230\151\160\230\179\149\230\139\165\230\156\137\230\155\180\229\164\154\232\139\177\233\155\132"))
  elseif code == "chess_level_max" then
    ed.showToast(T("\231\173\137\231\186\167\232\190\190\229\136\176\228\184\138\233\153\144"))
  elseif code == "chess_gold_not_enough" then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
  elseif code == "chess_game_type_not_open" then
    FireEvent("EventChessNotOpen")
  end
end

function AutoChessNetwork:dispatchChessReply(reply)
  if self:isDebug() then
    ed.pt(reply)
  end
  if reply._error_code then
    self:handlerErrorCode(reply._error_code)
    return
  end
  if reply._open_panel then
    ed.AutoChessManager:handlerOpenPanel(reply._open_panel)
    ed.AutoChessRankManager:handleOpenPanel(reply._open_panel)
  elseif reply._match_start then
    ed.AutoChessManager:handlerMatchStart(reply._match_start)
  elseif reply._match_cancel then
    ed.AutoChessManager:handlerMatchCancel()
  elseif reply._rookie_start then
    ed.AutoChessTeachManager:handlerRookieStart(reply._rookie_start)
  elseif reply._rookie_finish then
    ed.AutoChessTeachManager:handlerRookieFinish(reply._rookie_finish)
  elseif reply._resolve_rookie then
    ed.AutoChessTeachManager:handlerRookieResolve(reply._resolve_rookie)
  elseif reply._weekly_reward then
    FireEvent("AutoChessTookWeeklyRewards", reply._weekly_reward._rewards or {})
  elseif reply._grade_reward then
    FireEvent("AutoChessTookGradeRewards", reply._grade_reward._grade, reply._grade_reward._rewards or {})
  end
end

function AutoChessNetwork:dispatchChessGameReply(gameReply)
  print("--------------dispatchChessGameReply---------------")
  if gameReply._error_code then
    self:handlerErrorCode(gameReply._error_code)
    return
  end
  ed.printTable(gameReply)
  if gameReply._join then
    ed.AutoChessManager:handlerJoinGame(gameReply._join)
  elseif gameReply._loading then
  elseif gameReply._buy_hero then
    ed.AutoChessManager:handlerBuyHero(gameReply._buy_hero)
  elseif gameReply._sell_hero then
    ed.AutoChessManager:handlerSellHero(gameReply._sell_hero)
  elseif gameReply._shop_refresh then
    ed.AutoChessManager:handlerShopRefresh(gameReply._shop_refresh)
  elseif gameReply._shop_lock then
    ed.AutoChessManager:handlerShopLock(gameReply._shop_lock)
  elseif gameReply._set_lineup then
    ed.AutoChessManager:handlerSetLineup(gameReply._set_lineup)
  elseif gameReply._equip_pet then
    ed.AutoChessManager:handlerEquipPet(gameReply._equip_pet)
  elseif gameReply._replace_pet then
    ed.AutoChessManager:handlerReplacePet(gameReply._replace_pet)
  elseif gameReply._switch_pet then
    ed.AutoChessManager:handlerExchangePet(gameReply._switch_pet)
  elseif gameReply._buy_exp then
    ed.AutoChessManager:handlerBuyExp(gameReply._buy_exp)
  elseif gameReply._battle_confirm then
    ed.AutoChessManager:handlerBattleConfirmNet(gameReply._battle_confirm)
  elseif gameReply._choose_hero_power then
    ed.AutoChessManager:handlerChooseHeroPower(gameReply._choose_hero_power)
  elseif gameReply._quit then
  elseif gameReply._heartbeat then
  end
end

function AutoChessNetwork:dispatchChessNotify(notify)
  if notify._game_start then
    ed.AutoChessManager:handlerStartNotify(notify._game_start)
  elseif notify._match_timeout then
    ed.AutoChessManager:handlerMatchTimoutNotify()
  elseif notify._join_timeout then
    ed.AutoChessManager:handlerJoinTimoutNotify()
  elseif notify._loading_sync then
    ed.AutoChessManager:handlerLoadNotify(notify._loading_sync)
  elseif notify._compose_hero then
    ed.AutoChessManager:handlerComposeNotify(notify._compose_hero)
  elseif notify._round_sync then
    ed.AutoChessManager:handlerRoundNotify(notify._round_sync)
  elseif notify._user_status then
    ed.AutoChessManager:handlerStatusNotify(notify._user_status)
  elseif notify._game_over then
    ed.AutoChessManager:handlerOverNotify(notify._game_over)
  elseif notify._level_up then
    ed.AutoChessManager:handlerLevelNotify(notify._level_up)
  elseif notify._event then
    ed.AutoChessManager:handlerEventNotify(notify._event)
  elseif notify._action then
    ed.AutoChessManager:handlerActionNotify(notify._action)
  elseif notify._effect then
    ed.AutoChessManager:handlerEffectNotify(notify._effect)
  end
end

function AutoChessNetwork:doSend(output, msg, type, noprint)
  if ed.debug_mode and not noprint then
    ed.printTable(msg)
  end
  output(msg, type)
end

function AutoChessNetwork:sendChessOpenPanel()
  local msg = ed.upmsg.chess_req()
  msg._open_panel = ed.upmsg.chess_open_panel()
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:sendChessMatchStart(version, type)
  local msg = ed.upmsg.chess_req()
  msg._match_start = ed.upmsg.chess_match_start()
  msg._match_start._version = version
  msg._match_start._game_type = type
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:sendChessMatchCancel()
  local msg = ed.upmsg.chess_req()
  msg._match_cancel = ed.upmsg.chess_match_cancel()
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:sendChessSkipGuide()
  local msg = ed.upmsg.chess_req()
  msg._resolve_rookie = ed.upmsg.chess_resolve_rookie()
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:sendChessStartGuide()
  local msg = ed.upmsg.chess_req()
  msg._rookie_start = ed.upmsg.chess_rookie_start()
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:sendChessFinishGuide(hids, positions)
  local msg = ed.upmsg.chess_req()
  msg._rookie_finish = ed.upmsg.chess_rookie_finish()
  local version = ed.storage.getString("current-version")
  msg._rookie_finish._version = version
  msg._rookie_finish._hero_ids = hids
  msg._rookie_finish._positions = positions
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:createHeartBeat()
  if self.timer_heart_beat then
    CloseTimer(self.timer_heart_beat.Name)
    self.timer_heart_beat = nil
  end
  self.timer_heart_beat = ListenTimer(Timer:Always(ed.socket_long_chess.heart_beat_interval), function()
    self:sendChessHeartBeat()
  end)
end

function AutoChessNetwork:sendChessHeartBeat()
  local up_msg = ed.upmsg.chess_game_req()
  up_msg._heartbeat = ed.upmsg.chess_heartbeat()
  local userKey = ed.ChessPlayer.getMyUserKey()
  up_msg._heartbeat._user_key = ed.commonmsg.chess_user_key()
  up_msg._heartbeat._user_key._server_id = userKey._server_id
  up_msg._heartbeat._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_chess.send, up_msg, "chess_game", true)
end

function AutoChessNetwork:sendChessQuit()
  local msg = ed.upmsg.chess_game_req()
  msg._quit = ed.upmsg.chess_quit()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._quit._user_key = ed.commonmsg.chess_user_key()
  msg._quit._user_key._server_id = userKey._server_id
  msg._quit._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessJoin(gameId, version, isReconnect)
  local msg = ed.upmsg.chess_game_req()
  msg._join = ed.upmsg.chess_join()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._join._user_key = ed.commonmsg.chess_user_key()
  msg._join._user_key._server_id = userKey._server_id
  msg._join._user_key._user_id = userKey._user_id
  msg._join._game_id = gameId
  msg._join._version = version
  msg._join._is_reconnect = isReconnect
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessLoading(progress, isFinish)
  local msg = ed.upmsg.chess_game_req()
  msg._loading = ed.upmsg.chess_loading()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._loading._user_key = ed.commonmsg.chess_user_key()
  msg._loading._user_key._server_id = userKey._server_id
  msg._loading._user_key._user_id = userKey._user_id
  msg._loading._progress = progress
  msg._loading._is_finish = isFinish
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessReconnect(gameId, version)
  local msg = ed.upmsg.chess_game_req()
  msg._reconnect = ed.upmsg.chess_reconnect()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._reconnect._user_key = ed.commonmsg.chess_user_key()
  msg._reconnect._user_key._server_id = userKey._server_id
  msg._reconnect._user_key._user_id = userKey._user_id
  msg._reconnect._game_id = gameId
  msg._reconnect._version = version
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessBuyHero(insid)
  local msg = ed.upmsg.chess_game_req()
  msg._buy_hero = ed.upmsg.chess_buy_hero()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._buy_hero._user_key = ed.commonmsg.chess_user_key()
  msg._buy_hero._user_key._server_id = userKey._server_id
  msg._buy_hero._user_key._user_id = userKey._user_id
  msg._buy_hero._goods_insid = insid
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessSellHero(insid)
  local msg = ed.upmsg.chess_game_req()
  msg._sell_hero = ed.upmsg.chess_sell_hero()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._sell_hero._user_key = ed.commonmsg.chess_user_key()
  msg._sell_hero._user_key._server_id = userKey._server_id
  msg._sell_hero._user_key._user_id = userKey._user_id
  msg._sell_hero._hero_insid = insid
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessComposeHero(insids)
  local msg = ed.upmsg.chess_game_req()
  msg._compose_hero = ed.upmsg.chess_compose_hero()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._compose_hero._user_key = ed.commonmsg.chess_user_key()
  msg._compose_hero._user_key._server_id = userKey._server_id
  msg._compose_hero._user_key._user_id = userKey._user_id
  msg._compose_hero._hero_insids = insids
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessShopRefresh()
  local msg = ed.upmsg.chess_game_req()
  msg._shop_refresh = ed.upmsg.chess_shop_refresh()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._shop_refresh._user_key = ed.commonmsg.chess_user_key()
  msg._shop_refresh._user_key._server_id = userKey._server_id
  msg._shop_refresh._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessShopLock(isLock)
  local msg = ed.upmsg.chess_game_req()
  msg._shop_lock = ed.upmsg.chess_shop_lock()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._shop_lock._user_key = ed.commonmsg.chess_user_key()
  msg._shop_lock._user_key._server_id = userKey._server_id
  msg._shop_lock._user_key._user_id = userKey._user_id
  msg._shop_lock._is_unlock = isLock
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessSetLineup(insids, positions)
  local msg = ed.upmsg.chess_game_req()
  msg._set_lineup = ed.upmsg.chess_set_lineup()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._set_lineup._user_key = ed.commonmsg.chess_user_key()
  msg._set_lineup._user_key._server_id = userKey._server_id
  msg._set_lineup._user_key._user_id = userKey._user_id
  msg._set_lineup._hero_insids = insids
  msg._set_lineup._positions = positions
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessEquipPet(insid, petSid)
  local msg = ed.upmsg.chess_game_req()
  msg._equip_pet = ed.upmsg.chess_equip_pet()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._equip_pet._user_key = ed.commonmsg.chess_user_key()
  msg._equip_pet._user_key._server_id = userKey._server_id
  msg._equip_pet._user_key._user_id = userKey._user_id
  msg._equip_pet._hero_insid = insid
  msg._equip_pet._pet_insid = petSid
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessReplacePet(insid, petSid)
  local msg = ed.upmsg.chess_game_req()
  msg._replace_pet = ed.upmsg.chess_replace_pet()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._replace_pet._user_key = ed.commonmsg.chess_user_key()
  msg._replace_pet._user_key._server_id = userKey._server_id
  msg._replace_pet._user_key._user_id = userKey._user_id
  msg._replace_pet._hero_insid = insid
  msg._replace_pet._pet_insid = petSid
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessExchangePet(fromSid, toSid)
  local msg = ed.upmsg.chess_game_req()
  msg._switch_pet = ed.upmsg.chess_switch_pet()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._switch_pet._user_key = ed.commonmsg.chess_user_key()
  msg._switch_pet._user_key._server_id = userKey._server_id
  msg._switch_pet._user_key._user_id = userKey._user_id
  msg._switch_pet._from_hero_insid = fromSid
  msg._switch_pet._to_hero_insid = toSid
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChooseHeroPower(powerPos, optionIndex)
  local msg = ed.upmsg.chess_game_req()
  msg._choose_hero_power = ed.upmsg.chess_choose_hero_power()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._choose_hero_power._user_key = ed.commonmsg.chess_user_key()
  msg._choose_hero_power._user_key._server_id = userKey._server_id
  msg._choose_hero_power._user_key._user_id = userKey._user_id
  msg._choose_hero_power._power_pos = powerPos
  msg._choose_hero_power._option_index = optionIndex
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChatContent(content)
  local msg = ed.upmsg.chess_game_req()
  msg._emoji = ed.upmsg.chess_emoji()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._emoji._user_key = ed.commonmsg.chess_user_key()
  msg._emoji._user_key._server_id = userKey._server_id
  msg._emoji._user_key._user_id = userKey._user_id
  msg._emoji._content = content
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
  FireEvent("EventChessChatContentNotify", msg._emoji)
end

function AutoChessNetwork:sendChessBuyExp()
  local msg = ed.upmsg.chess_game_req()
  msg._buy_exp = ed.upmsg.chess_buy_exp()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._buy_exp._user_key = ed.commonmsg.chess_user_key()
  msg._buy_exp._user_key._server_id = userKey._server_id
  msg._buy_exp._user_key._user_id = userKey._user_id
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessBattleConfirm(result, selfTeam, oppoTeam, battleTime)
  local msg = ed.upmsg.chess_game_req()
  msg._battle_confirm = ed.upmsg.chess_battle_confirm()
  local userKey = ed.ChessPlayer.getMyUserKey()
  msg._battle_confirm._user_key = ed.commonmsg.chess_user_key()
  msg._battle_confirm._user_key._server_id = userKey._server_id
  msg._battle_confirm._user_key._user_id = userKey._user_id
  msg._battle_confirm._round = ed.AutoChessModel:getBattleRound()
  msg._battle_confirm._result = ed.upmsg.chess_battle_result()
  msg._battle_confirm._result._result = result
  msg._battle_confirm._result._battle_time = battleTime
  msg._battle_confirm._result._self_alives = selfTeam
  msg._battle_confirm._result._oppo_alives = oppoTeam
  self:doSend(ed.socket_long_chess.send, msg, "chess_game")
end

function AutoChessNetwork:sendChessWeeklyReward()
  local msg = ed.upmsg.chess_req()
  msg._weekly_reward = ed.upmsg.chess_weekly_reward()
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:sendChessGradeReward(gradeId)
  local msg = ed.upmsg.chess_req()
  msg._grade_reward = ed.upmsg.chess_grade_reward()
  msg._grade_reward._grade = gradeId
  self:doSend(ed.send, msg, "chess")
end

function AutoChessNetwork:openTeamConnection(ip, port, svrid)
  self.team_ip, self.team_port, self.team_svrid = ip, port, svrid
  self.is_team_connected = true
  ed.socket_long.doConnection(ip, port, true, svrid)
end

function AutoChessNetwork:closeTeamConnection()
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

function AutoChessNetwork:createTeamHeartBeat()
  if self.team_timer_heart_beat then
    CloseTimer(self.team_timer_heart_beat.Name)
    self.team_timer_heart_beat = nil
  end
  self.team_timer_heart_beat = ListenTimer(Timer:Always(ed.socket_long.heart_beat_interval), function()
    self:sendTeamHeartBeat()
  end)
end

function AutoChessNetwork:sendTeamHeartBeat()
  local msg = ed.upmsg.team_req()
  msg._heartbeat = ed.upmsg.team_heartbeat()
  msg._heartbeat._member_key = ed.commonmsg.team_member_key()
  local serverId, userId = game_server_id, ed.getUserid()
  msg._heartbeat._member_key._server_id = tonumber(serverId)
  msg._heartbeat._member_key._user_id = userId
  self:doSend(ed.socket_long.send, msg, "team", true)
  self:addTeamHeartBeat()
end

function AutoChessNetwork:addTeamHeartBeat()
  self.notReceveCount = self.notReceveCount or 0
  self.notReceveCount = self.notReceveCount + 1
  if self.notReceveCount > 1 then
    self:openTeamConnection(self.team_ip, self.team_port)
    self.notReceveCount = 0
  end
end

function AutoChessNetwork:resetTeamHeartBeat()
  self.notReceveCount = 0
end

function AutoChessNetwork:sendTeamCreate(target)
  local msg = ed.upmsg.team_req()
  msg._create = ed.upmsg.team_create()
  msg._create._target = target
  local version = ed.storage.getString("current-version")
  msg._create._version = version
  ed.TeamNetwork.teamTarget = target
  self:doSend(ed.send, msg, "team")
end

function AutoChessNetwork:sendTeamQuery(teamId)
  local msg = ed.upmsg.team_req()
  msg._query = ed.upmsg.team_query()
  msg._query._team_id = teamId
  ed.TeamNetwork.teamTarget = "chess"
  self:doSend(ed.send, msg, "team")
end

function AutoChessNetwork:sendTeamApply(teamTarget, teamId)
  local msg = ed.upmsg.team_req()
  msg._apply = ed.upmsg.team_apply()
  msg._apply._team_target = teamTarget
  msg._apply._team_id = teamId
  local version = ed.storage.getString("current-version")
  msg._apply._version = version
  ed.TeamNetwork.teamTarget = teamTarget
  self:doSend(ed.send, msg, "team")
end

function AutoChessNetwork:sendTeamJoin(serverId, userId)
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

function AutoChessNetwork:sendTeamQuit(serverId, userId)
  serverId = tonumber(serverId)
  local msg = ed.upmsg.team_req()
  msg._quit = ed.upmsg.team_quit()
  msg._quit._member_key = ed.commonmsg.team_member_key()
  msg._quit._member_key._server_id = serverId
  msg._quit._member_key._user_id = userId
  self:doSend(ed.socket_long.send, msg, "team")
end

function AutoChessNetwork:sendTeamKick(serverId, userId, targetSid, targetUid)
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

function AutoChessNetwork:onDisconnectTeam(...)
  self:closeTeamConnection()
  if self.team_timer_heart_beat then
    CloseTimer(self.team_timer_heart_beat.Name)
    self.team_timer_heart_beat = nil
  end
end

function AutoChessNetwork:dispatchChessTeamReply(reply)
  print("-----------dispatchChessTeamReply--------------")
  if not reply._heartbeat then
    ed.printTable(reply)
  end
  if reply._error_code then
    local code = reply._error_code
    if code == "team_query_not_found" then
      ed.showToast(T("\233\152\159\228\188\141\228\184\141\229\173\152\229\156\168"))
    elseif code == "team_not_alive" then
      self:closeTeamConnection()
      self:onDisconnectTeam()
      ed.AutoChessManager:clearTeamData()
      ed.AutoChessManager:setChessTeamInfo(false, 0)
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
  if reply._create then
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
    ed.AutoChessManager:setTeamMembers(data._team_summary._members)
    ed.AutoChessManager:updateTeamLeader(data._team_summary._leader)
    FireEvent("EventChessTeamJoin", reply._join, self.team_id)
  elseif reply._quit then
    self:onDisconnectTeam()
    ed.AutoChessManager:setChessTeamInfo(false, 0)
    ed.AutoChessManager:clearTeamData()
    FireEvent("EventChessTeamQuit")
  elseif reply._kick then
    FireEvent("EventChessTeamKick")
  end
  if reply._heartbeat then
    self:resetTeamHeartBeat()
  end
end

function AutoChessNetwork:dispatchChessTeamNotify(notify)
  print("-----------dispatchChessTeamNotify--------------")
  ed.printTable(notify)
  if notify._error_code then
    if notify._error_code == "team_not_alive" then
      self:onDisconnectTeam()
      ed.AutoChessManager:clearTeamData()
      ed.AutoChessManager:setChessTeamInfo(false, 0)
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
    ed.AutoChessManager:updateTeamMember(teamMember, "join")
    FireEvent("EventChessTeamJoinNotify", teamMember)
  elseif notify._quit then
    local data = notify._quit
    local kickMember = data._member_key
    local isSelf = ed.getUserid() == kickMember._user_id and tonumber(game_server_id) == kickMember._server_id
    if isSelf then
      self:onDisconnectTeam()
    end
    ed.AutoChessManager:updateTeamMember(kickMember, "kick")
    FireEvent("EventChessTeamQuitNotify", data)
  elseif notify._leader_change then
    local data = notify._leader_change
    local newLeader = data._new_leader
    ed.AutoChessManager:updateTeamLeader(newLeader)
    FireEvent("EventChessTeamLeaderNotify", notify._leader_change)
  elseif notify._member_status then
    local data = notify._member_status
    local memberKeys = data._member_keys
    local status = data._status
    ed.AutoChessManager:updateTeamMemberStatus(memberKeys, status)
    FireEvent("EventChessTeamStatusNotify")
  end
end

ed.AutoChessNetwork = AutoChessNetwork.create()

function ed.showAutoChessInvite(reply)
  ed.printTable(reply)
  local teamId = reply._team_id
  if ed.getCurrentScene().identity ~= "AutoChessArenaScene" then
    ed.AutoChessManager:setChessTeamInfo(true, teamId)
    ed.AutoChessNetwork:sendChessOpenPanel()
  else
    ed.AutoChessNetwork:sendTeamQuery(teamId)
  end
end
