local GuildRecruitNetwork = {}
GuildRecruitNetwork.__index = GuildRecruitNetwork
local instance
local printNetData = false

function GuildRecruitNetwork.getInstance()
  if not instance then
    instance = GuildRecruitNetwork.create()
  end
  return instance
end

function GuildRecruitNetwork.create()
  local self = {}
  setmetatable(self, GuildRecruitNetwork)
  ListenEvent("mainSceneEnter", function()
    if not self.initRed and ed.GuildManager.guildRecruitNotify and ed.GuildManager.guildRecruitNotify > 0 then
      self.initRed = true
      self:sendGuildRecruitOpenPanel()
    end
  end)
  return self
end

function GuildRecruitNetwork:dispatchReply(msg)
  if printNetData then
    print("------------------------GuildRecruitNetwork:dispatch------------------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.GuildManager:GuildRecruitOpenPanelReply(msg._open_panel)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Guild)
  elseif msg._entry then
    ed.GuildManager:GuildRecruitEntryReply(msg._entry)
  elseif msg._quit then
    ed.GuildManager:GuildRecruitQuitReply(msg._quit)
  elseif msg._sub then
    ed.GuildManager:GuildRecruitSubReply(msg._sub)
  elseif msg._query then
    ed.GuildManager:GuildRecruitQueryReply(msg._query)
  else
    print("what?")
  end
end

function GuildRecruitNetwork:doSendGuildRecruitReq(msg)
  if printNetData then
    print("------------------------GuildRecruitNetwork:send------------------------")
    ed.pt(msg)
  end
  ed.send(msg, "guild_enlist")
end

function GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  if ed.GuildManager.guildRecruitNotify and ed.GuildManager.guildRecruitNotify > 0 then
    local msg = ed.upmsg.guild_enlist_req()
    msg._open_panel = ed.upmsg.guild_enlist_open_panel()
    self:doSendGuildRecruitReq(msg)
  end
end

function GuildRecruitNetwork:sendGuildRecruitEntry()
  local msg = ed.upmsg.guild_enlist_req()
  msg._entry = {}
  self:doSendGuildRecruitReq(msg)
end

function GuildRecruitNetwork:sendGuildRecruitQuit()
  local msg = ed.upmsg.guild_enlist_req()
  msg._quit = {}
  self:doSendGuildRecruitReq(msg)
end

function GuildRecruitNetwork:sendGuildRecruitSub()
  local msg = ed.upmsg.guild_enlist_req()
  msg._sub = {}
  self:doSendGuildRecruitReq(msg)
end

function GuildRecruitNetwork:sendGuildRecruitQuery(start)
  if ed.GuildManager:GuildRecruitVersionIsPullAgain(start) then
    local msg = ed.upmsg.guild_enlist_req()
    msg._query = ed.upmsg.guild_enlist_query()
    msg._query._start = start or 1
    self:doSendGuildRecruitReq(msg)
  end
end

ed.GuildRecruitNetwork = GuildRecruitNetwork.getInstance()
