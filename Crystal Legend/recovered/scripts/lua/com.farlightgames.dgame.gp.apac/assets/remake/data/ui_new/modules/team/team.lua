local class = newclass("g")
ed.Team = class

function class.create(teamId, teamSummary)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(teamId, teamSummary)
  return self
end

function class:init(teamId, teamSummary)
  self.teamId = teamId
  self.teamSummary = teamSummary or {}
end

function class:getTeamId()
  return self.teamId
end

function class:setTeamSummary(teamSummary)
  self.teamSummary = teamSummary
end

function class:getTeamSuSummary()
  return self.teamSummary
end

function class:getTeamTarget()
  return self.teamSummary._target
end

function class:getTeamMembers()
  return self.teamSummary._members
end

function class:addTeamMember(member)
  table.insert(self.teamSummary._members, member)
end

function class:delTeamMember(memberKey)
  local delIndex
  for index, member in ipairs(self.teamSummary._members) do
    if self:checkMemberKeyIsEquality(member._user_key, memberKey) then
      delIndex = index
      break
    end
  end
  if delIndex then
    table.remove(self.teamSummary._members, delIndex)
  end
end

function class:changeMemberRoomStatus(memberKey, newStatus)
  for index, member in ipairs(self.teamSummary._members) do
    if self:checkMemberKeyIsEquality(member._user_key, memberKey) then
      member._room_status = newStatus
      break
    end
  end
end

function class:changeAllMemberRoomStatus(memberKeyList, newStatusList)
  if not memberKeyList or not newStatusList then
    return
  end
  for index = 1, #memberKeyList do
    local memberKey = memberKeyList[index]
    local newStatus = newStatusList[index]
    self:changeMemberRoomStatus(memberKey, newStatus)
  end
end

function class:changeMemberListStatus(memberKeys, newStatus)
  for index, memberKey in ipairs(memberKeys) do
    for _, member in ipairs(self.teamSummary._members) do
      if self:checkMemberKeyIsEquality(member._user_key, memberKey) then
        member._status = newStatus
        break
      end
    end
  end
end

function class:getLeaderKey()
  return self.teamSummary._leader
end

function class:changeLeader(newLeaderKey)
  self.teamSummary._leader = newLeaderKey
end

function class:getLeader()
  for index, member in ipairs(self:getTeamMembers() or {}) do
    if self:checkMemberKeyIsEquality(self:getLeaderKey(), member._user_key) then
      return member
    end
  end
end

function class:checkMemberIsLeader(member)
  return self:checkMemberKeyIsEquality(self:getLeaderKey(), member._user_key)
end

function class:isLeader()
  return self:checkMemberKeyIsEquality(self:getLeaderKey(), self:getMyTeamMemberKey())
end

function class:checkMemberKeyIsEquality(memberKey1, memberKey2)
  if not memberKey1 or not memberKey2 then
    return false
  end
  if memberKey1._server_id == memberKey2._server_id and memberKey1._user_id == memberKey2._user_id then
    return true
  end
  return false
end

function class:getMyTeamMemberKey()
  local team_member_key = ed.commonmsg.team_member_key()
  team_member_key._server_id = tonumber(game_server_id)
  team_member_key._user_id = ed.getUserid()
  return team_member_key
end
