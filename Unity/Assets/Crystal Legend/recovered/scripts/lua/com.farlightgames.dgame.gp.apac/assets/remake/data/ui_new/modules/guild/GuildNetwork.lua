local GuildNetwork = {}
GuildNetwork.__index = GuildNetwork
local instance
local printNetData = false

function GuildNetwork.getInstance()
  if not instance then
    instance = GuildNetwork.create()
  end
  return instance
end

function GuildNetwork.create()
  local self = {}
  setmetatable(self, GuildNetwork)
  return self
end

function GuildNetwork:dispatchReply(msg)
  if printNetData then
    print("------------------------GuildNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._list then
    ed.GuildManager:handleSearchGuildToJoinReply(msg._list)
  elseif msg._create then
    ed.GuildManager:handleGuildCreateReply(msg._create)
    ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  elseif msg._search then
    ed.GuildManager:handleGuildSearchReply(msg._search)
  elseif msg._query then
    ed.GuildManager:handleGuildQueryReply(msg._query)
  elseif msg._dismiss then
    ed.GuildManager:handleGuildDismissReply(msg._dismiss)
    ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  elseif msg._join then
    ed.GuildManager:handleJoinGuildReply(msg._join)
    ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  elseif msg._set then
    ed.GuildManager:handleGuildSettingReply(msg._set)
  elseif msg._join_confirm then
    ed.GuildManager:handleJoinConfirmReply(msg._join_confirm)
    ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  elseif msg._query_hires then
    ed.GuildManager:handleQueryHiresReply(msg._query_hires)
  elseif msg._add_hire then
    ed.GuildManager:handleAddMercenaryReply(msg._add_hire)
  elseif msg._del_hire then
    ed.GuildManager:handleDelMercenaryReply(msg._del_hire)
  elseif msg._hire_hero then
    ed.GuildManager:handleHireHeroReply(msg._hire_hero)
  elseif msg._leave then
    ed.showToast(T("\229\183\178\231\166\187\229\188\128\229\133\172\228\188\154"))
    ed.player:setGuild(nil)
    ed.player:cancelAllMercenary()
    ed.GuildRaidManager:initData()
    ed.popScene()
    ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  elseif msg._worship_withdraw then
    ed.GuildManager:handleWorshipWithdrawReply(msg._worship_withdraw)
  elseif msg._worship_req then
    ed.GuildManager:handleWorshipReply(msg._worship_req)
  elseif msg._set_job then
    ed.GuildManager:handleSetJobReply(msg._set_job)
  elseif msg._kick then
    ed.GuildManager:handleKickMemberReply(msg._kick)
    ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  elseif msg._guild_send_mail_reply then
    if msg._guild_send_mail_reply == "success" then
      ed.showToast(T("\233\130\174\228\187\182\229\143\145\233\128\129\230\136\144\229\138\159"))
    elseif msg._guild_send_mail_reply == "fail" then
      ed.showToast(T("\233\130\174\228\187\182\229\143\145\233\128\129\229\164\177\232\180\165"))
    end
  elseif msg._set_recruit_del then
    if msg._set_recruit_del == "success" then
      ed.GuildManager.recruitDetail = self.tmpRecruit
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159!"))
    end
  elseif msg._guild_member_rank then
    ed.GuildManager:handleGameplayRankReply(msg._guild_member_rank)
  elseif msg._query_hh_detail then
    FireEvent("req_hero_info", msg._query_hh_detail._hero)
  end
end

function GuildNetwork:doSendGuildReq(msg)
  if printNetData then
    print("------------------------SkillTowerNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "guild")
end

function GuildNetwork:getGuildReq()
  return ed.upmsg.guild()
end

function GuildNetwork:sendCreateGuild(name, avatarId, frameId)
  local msg = self:getGuildReq()
  msg._create = {}
  msg._create._name = name
  msg._create._avatar = ed.packAvatar(frameId, avatarId)
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendSearchGuild(guildId)
  local msg = self:getGuildReq()
  msg._search = {}
  msg._search._guild_id = tonumber(guildId)
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendJoinGuild(id)
  local msg = self:getGuildReq()
  msg._join = {}
  msg._join._guild_id = id
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendQuitGuild()
  local msg = self:getGuildReq()
  msg._leave = {}
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendQueryGuildList()
  local msg = self:getGuildReq()
  msg._list = {}
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendDismissGuild()
  local msg = self:getGuildReq()
  msg._dismiss = {}
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendConfirmJoinGuild(yesOrNo, uid)
  local msg = self:getGuildReq()
  msg._join_confirm = {}
  msg._join_confirm._type = yesOrNo
  msg._join_confirm._uid = uid
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendQueryMercenary()
  local msg = self:getGuildReq()
  msg._query_hires = {}
  msg._query_hires._from = "guild"
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendGuildGameplayRank(type)
  local msg = self:getGuildReq()
  msg._guild_member_rank = {}
  msg._guild_member_rank._type = type
  self:doSendGuildReq(msg)
end

function GuildNetwork:sendDispatchHero(heroId)
  local msg = ed.upmsg.guild()
  msg._add_hire = {}
  msg._add_hire._heroid = heroId
  ed.send(msg, "guild")
end

function GuildNetwork:sendSetRecruit(recruit)
  self.tmpRecruit = recruit
  local msg = ed.upmsg.guild()
  msg._set_recuit_item = {}
  msg._set_recuit_item.recruit_del = recruit
  ed.send(msg, "guild")
end

function GuildNetwork:sendGuildEmail(title, message)
  local msg = ed.upmsg.guild()
  msg._guild_send_mail = ed.upmsg.guild_send_mail()
  msg._guild_send_mail.title = title
  msg._guild_send_mail.content = message
  ed.send(msg, "guild")
end

function GuildNetwork:sendQueryDetail(uid, heroid)
  local msg = self:getGuildReq()
  msg._query_hh_detail = ed.upmsg.guild_qurey_hh_detail()
  msg._query_hh_detail._hero_type = 1
  msg._query_hh_detail._uid = uid
  msg._query_hh_detail._heroid = heroid
  self:doSendGuildReq(msg)
end

ed.GuildNetwork = GuildNetwork.getInstance()
return GuildNetwork
