local class = newclass("g")
class.instance = nil
ed.TeamMgr = class

function class.getInstance()
  if not class.instance then
    class.instance = class.create()
  end
  return class.instance
end

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
  self.team = nil
end

function class:getTeam()
  return self.team
end

function class:handleNotify(_team_notify)
  if _team_notify._error_code then
    local errorCode = _team_notify._error_code
    if errorCode == "team_not_alive" then
      ed.TeamNetwork.onDisconnectTeam()
      self.team = nil
      ed.showToast(T("\228\189\160\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
      FireEvent("EventTeamNotAlive")
    elseif errorCode == "team_set_room_status_audience_full" then
      ed.showToast(T("\232\167\130\228\188\151\228\189\141\229\183\178\230\187\161"))
    else
      ed.showToast(errorCode)
    end
    return
  end
  local teamId = _team_notify._team_id
  if not self.team or self.team:getTeamId() ~= teamId then
    return
  end
  if _team_notify._quit then
    local kickMember = _team_notify._quit._member_key
    local isSelf = ed.getUserid() == kickMember._user_id and tonumber(game_server_id) == kickMember._server_id
    if isSelf then
      ed.TeamNetwork.onDisconnectTeam()
      FireEvent("TeamQuit", teamId)
      self.team = nil
      ed.showToast(T("\228\189\160\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
      return
    end
    self.team:delTeamMember(_team_notify._quit._member_key)
  end
  if _team_notify._join then
    self.team:addTeamMember(_team_notify._join._member)
    ed.TeamNetwork.createTeamHeartBeat()
  elseif _team_notify._leader_change then
    self.team:changeLeader(_team_notify._leader_change._new_leader)
  elseif _team_notify._member_status then
    self.team:changeMemberListStatus(_team_notify._member_status._member_keys, _team_notify._member_status._status)
  elseif _team_notify._room_status then
    self.team:changeAllMemberRoomStatus(_team_notify._room_status._member_key, _team_notify._room_status._room_status)
  end
  FireEvent("TeamMemberChange", teamId)
end

function class:handleTeamCreate(_create)
  local teamId = _create._team_id or 0
  local teamAddr = _create._team_addr
  local ip, port, svrid = ed.getIPPortFromString(teamAddr)
  ed.TeamNetwork.openTeamConnection(ip, port, svrid)
  ed.TeamNetwork.sendTeamJoin()
  FireEvent("TeamCreate")
end

function class:handleTeamQuery(_query)
  local teamSummary = _query._team_summary
  local teamId = teamSummary._id
  local teamTarget = teamSummary._team_target
  ed.TeamNetwork.sendTeamApply(teamTarget, teamId)
end

function class:handleTeamApply(_apply)
  local teamId = _apply._team_id or 0
  local teamAddr = _apply._team_addr
  local ip, port, svrid = ed.getIPPortFromString(teamAddr)
  ed.TeamNetwork.openTeamConnection(ip, port, svrid)
  ed.TeamNetwork.sendTeamJoin()
end

function class:handleTeamJoin(_join)
  local teamSummary = _join._team_summary
  local teamId = teamSummary._id
  local team = ed.Team.create(teamId, teamSummary)
  self.team = team
  ed.TeamNetwork.createTeamHeartBeat()
  FireEvent("TeamJoin", teamId)
end

function class:handleTeamQuit(_quit)
  ed.TeamNetwork.onDisconnectTeam()
  if self.team then
    local teamId = self.team:getTeamId()
    FireEvent("TeamQuit", teamId)
    self.team = nil
  end
end

function class:handleTeamKick(_kick)
  local result = _kick._result
end

function class:handleRoomStatus(_room_status)
  local result = _room_status._result
end

function class:handleTeamErrorCode(_error_code)
  local code = _error_code
  if code == "team_query_not_found" then
    ed.showToast(T("\233\152\159\228\188\141\228\184\141\229\173\152\229\156\168"))
  elseif code == "team_not_alive" then
    ed.TeamNetwork.closeTeamConnection()
    ed.TeamNetwork.onDisconnectTeam()
    self.team = nil
    ed.showToast(T("\228\189\160\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
    FireEvent("EventTeamNotAlive")
  elseif code == "team_member_full" then
    ed.showToast(T("\233\152\159\228\188\141\229\183\178\230\187\161"))
  elseif code == "team_not_exsits" then
    ed.showToast(T("\233\152\159\228\188\141\229\183\178\232\167\163\230\149\163"))
  else
    ed.showToast(code)
  end
  FireEvent("EventTeamErrorCode")
end
