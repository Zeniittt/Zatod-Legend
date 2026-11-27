local moduleNameList = {
  "GuildRaidConfig",
  "GuildRaidManager",
  "GuildRaidNetwork",
  "GuildSelectRaidWin",
  "GuildRaidMainScene",
  "GuildRaidStageDetailWin",
  "GuildRaidDamageRanklistWin",
  "GuildRaidStageRanklistWin",
  "GuildRaidVictoryWin",
  "GuildRaidHPBar"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/guild/guildraid/" .. moduleName
end

local function canReload(name)
  return name ~= "GuildRaidManager"
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
