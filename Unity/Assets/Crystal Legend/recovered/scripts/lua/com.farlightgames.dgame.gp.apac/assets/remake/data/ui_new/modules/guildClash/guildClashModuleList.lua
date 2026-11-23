local moduleNameList = {
  "guildClashDefine",
  "guildClashManager",
  "guildClashNetwork",
  "guildClashMainScene",
  "guildClashRuleWin",
  "guildClashSetNoticeWin",
  "guildClashPrepareScene",
  "guildClashSetTeamWin",
  "guildClashChairSetTeam",
  "guildClashBattleInfoWin",
  "guildClashBattleRecordWin",
  "guildClashCourseWin",
  "guildClashRewardWin",
  "guildClashResultWin",
  "guildClashGradingScene",
  "guildClashGameGuideWin",
  "guildClashGradeResultScene",
  "guildClashMemberActiveWin",
  "guildClashRankWin",
  "guildClashBattlePop",
  "guildClashPreviewScene",
  "guildClashShopScene"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/guildClash/" .. moduleName
end

local function canReload(name)
  return name ~= "guildClashManager"
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
