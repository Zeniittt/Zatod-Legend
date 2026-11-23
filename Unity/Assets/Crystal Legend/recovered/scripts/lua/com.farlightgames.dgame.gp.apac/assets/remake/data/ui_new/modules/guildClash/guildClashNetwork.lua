local GuildClashNetwork = {}
GuildClashNetwork.__index = GuildClashNetwork

function GuildClashNetwork.isDebug()
  return false
end

function GuildClashNetwork.getInstance()
  if not GuildClashNetwork.instance then
    GuildClashNetwork.instance = GuildClashNetwork.create()
  end
  return GuildClashNetwork.instance
end

function GuildClashNetwork.create()
  local self = {}
  setmetatable(self, GuildClashNetwork)
  return self
end

function GuildClashNetwork:notify(msg)
  ed.GuildClashManager:handleNotify(msg)
end

function GuildClashNetwork:dispatch(reply)
  if self.isDebug() then
    print("---------------GuildClashNetwork:dispatchReply----------------")
    ed.pt(reply)
  end
  if reply._open_panel then
    ed.GuildClashManager:handleOpenPanel(reply._open_panel)
  elseif reply._user_team then
    ed.GuildClashManager:handleUserTeamInfo(reply._user_team)
  elseif reply._guild_team then
    ed.GuildClashManager:handleGuildUserTeam(reply._guild_team)
  elseif reply._add_team then
    ed.GuildClashManager:handleAddTeam(reply._add_team)
  elseif reply._del_team then
    if reply._del_team == "success" then
      FireEvent("GuildClashDelTeamSuccess")
    end
  elseif reply._edit_team then
    if reply._edit_team == "success" then
      FireEvent("GuildClashEditTeamSuccess")
    end
  elseif reply._change_line then
    if reply._change_line == "success" then
      FireEvent("GuildClashChangeLineSuccess")
    end
  elseif reply._chair_change_line then
    if reply._chair_change_line == "success" then
      FireEvent("GuildClashChairChangeTeam")
    end
  elseif reply._switch_line then
    if reply._switch_line == "success" then
      FireEvent("GuildClashChairSwitchLine")
    end
  elseif reply._summary_info then
    ed.GuildClashManager:handleSummaryInfo(reply._summary_info)
  elseif reply._query_line then
    ed.GuildClashManager:handleQueryLine(reply._query_line)
  elseif reply._sync_events then
    ed.GuildClashManager:handleSyncEvent(reply._sync_events)
  elseif reply._query_replay then
    ed.GuildClashManager:handleQueryReplay(reply._query_replay)
  elseif reply._query_battle_summary then
    ed.GuildClashManager:handleQueryBattleSummary(reply._query_battle_summary)
  elseif reply._query_rank then
    ed.GuildClashManager:handleQueryRank(reply._query_rank)
  elseif reply._query_rune_summary then
    ed.GuildClashManager:handleQueryRuneSummary(reply._query_rune_summary)
  elseif reply._query_battle_teams then
    ed.GuildClashManager:handleQueryBattleTeams(reply._query_battle_teams)
  elseif reply._set_declare then
    if reply._set_declare == "success" then
      FireEvent("GuildClashSetDeclareSuccess")
    end
  elseif reply._guild_liveness then
    ed.GuildClashManager:handleQueryGuildLiveness(reply._guild_liveness)
  elseif reply._query_history then
    ed.GuildClashManager:handleQueryHistory(reply._query_history)
  elseif reply._query_goods then
    ed.GuildClashManager:handleQueryGoods(reply._query_goods)
  elseif reply._buy_goods then
    ed.GuildClashManager:handleBuyGoods(reply._buy_goods)
  elseif reply._query_battle_info then
    ed.GuildClashManager:handleBattleInfo(reply._query_battle_info)
  elseif reply._query_last_summarys then
    ed.GuildClashManager:handleLastSummary(reply._query_last_summarys)
  elseif reply._start_chair_operate then
    if reply._start_chair_operate == "success" then
      FireEvent("GuildClashStartChairOperate")
    else
      ed.showToast(T("\229\133\182\228\187\150\228\186\186\230\173\163\229\156\168\232\176\131\230\149\180"))
    end
  elseif reply._end_chair_operate and reply._end_chair_operate == "success" then
    FireEvent("GuildClashEndChairOperate")
  end
end

function GuildClashNetwork:createReq()
  local req = ed.upmsg.guild_clash_req()
  return req
end

function GuildClashNetwork:sendReq(req)
  if self.isDebug() then
    print("-------------GuildClashNetwork:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "guild_clash")
end

function GuildClashNetwork:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = ed.upmsg.guild_clash_open_panel()
  self:sendReq(req)
end

function GuildClashNetwork:sendUserTeam()
  local req = self:createReq()
  req._user_team = ed.upmsg.guild_clash_user_team_info()
  self:sendReq(req)
end

function GuildClashNetwork:sendGuildTeam()
  local req = self:createReq()
  req._guild_team = ed.upmsg.guild_clash_guild_team_info()
  self:sendReq(req)
end

function GuildClashNetwork:sendAddTeam(data)
  local req = self:createReq()
  req._add_team = ed.upmsg.guild_clash_add_team()
  req._add_team._hero_ids = data.heroIds
  req._add_team._line_id = data.lineId
  self:sendReq(req)
end

function GuildClashNetwork:sendDelTeam(teamId)
  local req = self:createReq()
  req._del_team = ed.upmsg.guild_clash_del_team()
  req._del_team._team_id = teamId
  self:sendReq(req)
end

function GuildClashNetwork:sendEditTeam(data)
  local req = self:createReq()
  req._edit_team = ed.upmsg.guild_clash_edit_team()
  req._edit_team._team_id = data.id
  req._edit_team._hero_ids = data.heroIds
  self:sendReq(req)
end

function GuildClashNetwork:sendChangeLine(teamId, lineId)
  local req = self:createReq()
  req._change_line = ed.upmsg.guild_clash_change_line()
  req._change_line._team_id = teamId
  req._change_line._line_id = lineId
  self:sendReq(req)
end

function GuildClashNetwork:sendChairChangeLine(data)
  local req = self:createReq()
  req._chair_change_line = ed.upmsg.guild_clash_chair_change_line()
  local list = {}
  for k, v in ipairs(data) do
    table.insert(list, {
      _team_id = v.teamId,
      _user_id = v.userId,
      _line_id = v.lineId
    })
  end
  req._chair_change_line._change_line_infos = list
  self:sendReq(req)
end

function GuildClashNetwork:sendChairSwithcLine(from, to)
  local req = self:createReq()
  req._switch_line = ed.upmsg.guild_clash_switch_line()
  req._switch_line._line_id_one = from
  req._switch_line._line_id_two = to
  self:sendReq(req)
end

function GuildClashNetwork:sendSummaryInfo(type)
  local req = self:createReq()
  req._summary_info = ed.upmsg.guild_clash_summary_info()
  req._summary_info._type = type
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryLine(lineIds)
  local req = self:createReq()
  req._query_line = ed.upmsg.guild_clash_query_line()
  req._query_line._line_id = lineIds
  self:sendReq(req)
end

function GuildClashNetwork:sendSyncEvents(lastId)
  local req = self:createReq()
  req._sync_events = ed.upmsg.guild_clash_sync_events()
  req._sync_events._last_id = lastId
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryReplay(replayId)
  local req = self:createReq()
  req._query_replay = ed.upmsg.guild_clash_query_replay()
  req._query_replay._replay_id = replayId
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryBattleSummary(replayId)
  local req = self:createReq()
  req._query_battle_summary = ed.upmsg.guild_clash_query_battle_summary()
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryRank(type)
  local req = self:createReq()
  req._query_rank = ed.upmsg.guild_clash_query_rank()
  req._query_rank._type = type
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryRuneSummary(wave)
  local req = self:createReq()
  req._query_rune_summary = ed.upmsg.guild_clash_query_rune_summary()
  req._query_rune_summary._wave = wave
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryBattleTeams(lineId)
  local req = self:createReq()
  req._query_battle_teams = ed.upmsg.guild_clash_query_battle_teams()
  req._query_battle_teams._line_id = lineId
  self:sendReq(req)
end

function GuildClashNetwork:sendSetDeclare(declare)
  local req = self:createReq()
  req._set_declare = ed.upmsg.guild_clash_set_declare()
  req._set_declare._declare = declare
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryGuildLiveness()
  local req = self:createReq()
  req._guild_liveness = ed.upmsg.guild_clash_guild_liveness()
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryHistory()
  local req = self:createReq()
  req._query_history = ed.upmsg.guild_clash_query_history()
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryGoods()
  local req = self:createReq()
  req._query_goods = ed.upmsg.guild_clash_query_goods()
  self:sendReq(req)
end

function GuildClashNetwork:sendBuyGoods(groupId, goodsIndex, amount)
  local req = self:createReq()
  req._buy_goods = ed.upmsg.guild_clash_buy_goods()
  req._buy_goods._amount = amount
  req._buy_goods._group_id = groupId
  req._buy_goods._goods_index = goodsIndex
  self:sendReq(req)
end

function GuildClashNetwork:sendQueryBattleInfo()
  local req = self:createReq()
  req._query_battle_info = ed.upmsg.guild_clash_query_battle_info()
  self:sendReq(req)
end

function GuildClashNetwork:setQueryLastSummarys()
  local req = self:createReq()
  req._query_last_summarys = ed.upmsg.guild_clash_query_last_summarys()
  self:sendReq(req)
end

function GuildClashNetwork:startChairOperate()
  local req = self:createReq()
  req._start_chair_operate = ed.upmsg.guild_clash_start_chair_operate()
  self:sendReq(req)
end

function GuildClashNetwork:endChairOperate()
  local req = self:createReq()
  req._end_chair_operate = ed.upmsg.guild_clash_end_chair_operate()
  self:sendReq(req)
end

ed.GuildClashNetwork = GuildClashNetwork.getInstance()
