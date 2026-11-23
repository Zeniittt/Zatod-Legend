local moduleNameList = {
  "GuildManager",
  "GuildNetwork",
  "GuildJoinScene",
  "GuildMainScene",
  "GuildRuleWin",
  "GuildChangeHeadWin",
  "GuildManageWin",
  "GuildSetMercenaryWin",
  "GuildSettingWin",
  "GuildApplyMemberWin",
  "GuildChangeFrameWin",
  "GuildChangeNameWin",
  "GuildMercenaryRule",
  "GuildWorshipInfoWin",
  "GuildWorshipWin",
  "GuildMemberInfoWin",
  "GuildMemberManageWin",
  "GuildMemberAppointWin",
  "GuildMailWin",
  "GuildSetSloganWin",
  "GuildLogWin",
  "GuildSetRecruitWin",
  "guildraid/GuildRaidModuleList",
  "GuildManageMemWin",
  "GuildRecruitNetwork",
  "GuildRecruitPops",
  "GuildGameplayRanklistWin",
  "GuildWeeklyjobWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/guild/" .. moduleName
end

local function canReload(name)
  return name ~= "GuildManager"
end

for _, v in ipairs(moduleNameList) do
  if canReload(v) then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
if ReloadModule then
  local uis = {}
  for k, v in ipairs(uis) do
    ReloadModule(v)
  end
end
