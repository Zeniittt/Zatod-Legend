local class = newclass("g")
ed.TeamNetwork = class
class.isDebug = false

function class.getMyTeamMemberKey()
  local serverId = game_server_id
  local userId = ed.getUserid()
  local team_member_key = ed.commonmsg.team_member_key()
  team_member_key._server_id = tonumber(serverId)
  team_member_key._user_id = userId
  return team_member_key
end

function class.getVersion()
  local version = ed.storage.getString("current-version")
  return version
end

function class.createTeamHeartBeat()
  if class.team_timer_heart_beat then
    CloseTimer(class.team_timer_heart_beat.Name)
    class.team_timer_heart_beat = nil
  end
  class.team_timer_heart_beat = ListenTimer(Timer:Always(ed.socket_long.heart_beat_interval), function()
    class:sendTeamHeartBeat()
  end)
end

function class.resetTeamHeartBeat()
  class.notReceveCount = 0
end

function class.addTeamHeartBeat()
  class.notReceveCount = class.notReceveCount or 0
  class.notReceveCount = class.notReceveCount + 1
  if class.notReceveCount > 1 then
    class.openTeamConnection(class.team_ip, class.team_port, class.team_svrid)
    class.notReceveCount = 0
  end
end

function class.openTeamConnection(ip, port, svrid)
  class.team_ip, class.team_port, class.team_svrid = ip, port, svrid
  class.is_team_connected = true
  ed.socket_long.doConnection(ip, port, true, svrid)
end

function class.closeTeamConnection()
  if class.is_team_connected then
    class.is_team_connected = false
    ed.socket_long.doCloseConnection()
  end
  if class.team_timer_heart_beat then
    CloseTimer(class.team_timer_heart_beat.Name)
    class.team_timer_heart_beat = nil
  end
  class.team_ip, class.team_port, class.team_svrid = 0, 0, 0
end

function class.onDisconnectTeam()
  class.closeTeamConnection()
  if class.team_timer_heart_beat then
    CloseTimer(class.team_timer_heart_beat.Name)
    class.team_timer_heart_beat = nil
  end
end

function class.dispatch(reply)
  if class.isDebug then
    print("-------------TeamNetwork:dispatch--------------")
    ed.pt(reply)
  end
  local teamMgr = ed.TeamMgr.getInstance()
  if reply._create then
    teamMgr:handleTeamCreate(reply._create)
  elseif reply._query then
    teamMgr:handleTeamQuery(reply._query)
  elseif reply._apply then
    teamMgr:handleTeamApply(reply._apply)
  elseif reply._join then
    teamMgr:handleTeamJoin(reply._join)
  elseif reply._quit then
    class.onDisconnectTeam()
    teamMgr:handleTeamQuit(reply._quit)
  elseif reply._kick then
    teamMgr:handleTeamKick(reply._kick)
  elseif reply._heartbeat then
    class.resetTeamHeartBeat()
  elseif reply._room_status then
    teamMgr:handleRoomStatus(reply._room_status)
  elseif reply._error_code then
    teamMgr:handleTeamErrorCode(reply._error_code)
  end
end

function class.notify(notify)
  if class.isDebug then
    print("-------------TeamNetwork:notify--------------")
    ed.pt(notify)
  end
  local teamMgr = ed.TeamMgr.getInstance()
  teamMgr:handleNotify(notify)
end

function class.createReq()
  local req = ed.upmsg.team_req()
  return req
end

function class.sendReq(req)
  if class.isDebug then
    print("-------------TeamNetwork:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "team")
end

function class.sendLongReq(req)
  if class.isDebug then
    print("-------------TeamNetwork:sendLongReq--------------")
    ed.pt(req)
  end
  ed.socket_long.send(req, "team")
end

function class.sendTeamCreate(teamTarget, param1)
  local req = class.createReq()
  class.teamTarget = teamTarget
  req._create = {}
  req._create._target = teamTarget
  req._create._version = class.getVersion()
  req._create._param1 = param1
  class.sendReq(req)
end

function class.sendTeamQuery(teamTarget, teamId)
  local req = class.createReq()
  req._query = {}
  req._query._team_target = teamTarget
  req._query._team_id = teamId
  class.sendReq(req)
end

function class.sendTeamApply(teamTarget, teamId)
  class.teamTarget = teamTarget
  local req = class.createReq()
  req._apply = {}
  req._apply._team_target = teamTarget
  req._apply._team_id = teamId
  req._apply._version = class.getVersion()
  class.sendReq(req)
end

function class.sendTeamJoin()
  local req = class.createReq()
  req._join = {}
  req._join._member_key = class.getMyTeamMemberKey()
  req._join._version = class.getVersion()
  class.sendLongReq(req)
end

function class.sendTeamQuit()
  local req = class.createReq()
  req._quit = {}
  req._quit._member_key = class.getMyTeamMemberKey()
  class.sendLongReq(req)
end

function class.sendTeamKick(memberKey, targetKey)
  local req = class.createReq()
  req._kick = {}
  req._kick._member_key = memberKey
  req._kick._target_key = targetKey
  class.sendLongReq(req)
end

function class.sendTeamHeartBeat()
  print("<<< TeamNetwork Message Sent HeatBeat @ " .. ed.getYMDHMSTime())
  local msg = ed.upmsg.team_req()
  msg._heartbeat = ed.upmsg.team_heartbeat()
  msg._heartbeat._member_key = class.getMyTeamMemberKey()
  class.sendLongReq(msg)
  class.addTeamHeartBeat()
end

function class.sendTeamRoomStatus(memberKey, targetKey, roomStatus)
  local req = class.createReq()
  req._room_status = {}
  req._room_status._member_key = memberKey
  req._room_status._target_key = targetKey
  req._room_status._room_status = roomStatus
  class.sendLongReq(req)
end
