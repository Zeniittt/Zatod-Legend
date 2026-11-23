local moduleNameList = {
  "pvpManager",
  "pvpNetwork",
  "pvp",
  "pvpRecordWin",
  "pvpRewardWin",
  "pvpBattleVictoryWin",
  "pvpBattleFailedWin",
  "pvpRuleTips",
  "shareGuildOrFriend",
  "pvpShareWin",
  "pvpOppoInfoWin",
  "pvpBackgroundPop",
  "pvpLegendEquipActTips"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/pvp/" .. moduleName
end

local function canReload(name)
  return name ~= "pvpManager"
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
