local GuildRaidNetwork = {}
GuildRaidNetwork.__index = GuildRaidNetwork
local instance
local printNetData = false

function GuildRaidNetwork.getInstance()
  if not instance then
    instance = GuildRaidNetwork.create()
  end
  return instance
end

function GuildRaidNetwork.create()
  local self = {}
  setmetatable(self, GuildRaidNetwork)
  return self
end

function GuildRaidNetwork:dispatchReply(msg)
  if printNetData then
    print("------------------------GuildRaidNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.GuildRaidManager:handleRaidOpenPanelReply(msg._open_panel)
  elseif msg._open_instance then
    ed.GuildRaidManager:handleRaidOpenInstanceReply(msg._open_instance)
  elseif msg._reset_instance then
    ed.GuildRaidManager:handleRaidResetInstanceReply(msg._reset_instance)
  elseif msg._query_instance then
    ed.GuildRaidManager:handleRaidQueryInstanceReply(msg._query_instance)
  elseif msg._query_stage then
    ed.GuildRaidManager:handleRaidQueryStageReply(msg._query_stage)
  elseif msg._prepare_battle then
    ed.GuildRaidManager:handleRaidPrepareBattleReply(msg._prepare_battle)
  elseif msg._start_battle then
    ed.GuildRaidManager:handleRaidStartBattleReply(msg._start_battle)
  elseif msg._end_battle then
    ed.GuildRaidManager:handleRaidEndBattleReply(msg._end_battle)
  elseif msg._view_members then
    ed.GuildRaidManager:handleRaidViewMembersReply(msg._view_members)
  elseif msg._member_rank then
    ed.GuildRaidManager:handleRaidMemberRankReply(msg._member_rank)
  elseif msg._stage_rank then
    ed.GuildRaidManager:handleRaidStageRankReply(msg._stage_rank)
  elseif msg._error_code then
    if msg._error_code == T("\229\189\147\229\137\141\229\183\178\228\184\141\229\156\168\229\133\172\228\188\154\228\184\173") then
      ed.popScene()
      ed.popScene()
      ed.popScene()
      ListenTimer(Timer:Once(0.5), function()
        ed.showToast(msg._error_code)
      end)
    else
      ed.showToast(msg._error_code)
    end
  end
end

function GuildRaidNetwork:doSendGuildRaidReq(msg)
  if printNetData then
    print("------------------------GuildRaidNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "guild_raid")
end

function GuildRaidNetwork:getGuildRaidReq()
  return ed.upmsg.guild_raid_req()
end

function GuildRaidNetwork:sendOpenPanel()
  local msg = self:getGuildRaidReq()
  msg._open_panel = {}
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendOpenInstance(rid, hasDiscount)
  local msg = self:getGuildRaidReq()
  msg._open_instance = {}
  msg._open_instance._raid_id = rid
  msg._open_instance._has_discount = hasDiscount and 1 or 0
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendResetInstance(rid, hasDiscount)
  local msg = self:getGuildRaidReq()
  msg._reset_instance = {}
  msg._reset_instance._raid_id = rid
  msg._reset_instance._has_discount = hasDiscount and 1 or 0
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendQueryInstance(rid)
  local msg = self:getGuildRaidReq()
  msg._query_instance = {}
  msg._query_instance._raid_id = rid
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendQueryStage(stageId)
  local msg = self:getGuildRaidReq()
  msg._query_stage = {}
  msg._query_stage._stage_id = stageId
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendPrepareBattle(stageId, progress)
  local msg = self:getGuildRaidReq()
  msg._prepare_battle = {}
  msg._prepare_battle._stage_id = stageId
  msg._prepare_battle._stage_progress = progress
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendStartBattle(stageId, lineup)
  local msg = self:getGuildRaidReq()
  msg._start_battle = {}
  msg._start_battle._stage_id = stageId
  msg._start_battle._lineup = lineup
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendEndBattle(params)
  local msg = self:getGuildRaidReq()
  msg._end_battle = {}
  msg._end_battle._operations = params.operations
  msg._end_battle._battle_result = params.battleResult
  msg._end_battle._wave = params.wave
  msg._end_battle._hp_list = params.hpList
  msg._end_battle._stage_progress = params.stageProgress
  msg._end_battle._damage = params.damage
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendViewMembers(rid)
  local msg = self:getGuildRaidReq()
  msg._view_members = {}
  msg._view_members._raid_id = rid
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendMemberRank(rid)
  local msg = self:getGuildRaidReq()
  msg._member_rank = {}
  msg._member_rank._raid_id = rid
  self:doSendGuildRaidReq(msg)
end

function GuildRaidNetwork:sendStageRank(stageId)
  local msg = self:getGuildRaidReq()
  msg._stage_rank = {}
  msg._stage_rank._stage_id = stageId
  self:doSendGuildRaidReq(msg)
end

ed.GuildRaidNetwork = GuildRaidNetwork.getInstance()
return GuildRaidNetwork
