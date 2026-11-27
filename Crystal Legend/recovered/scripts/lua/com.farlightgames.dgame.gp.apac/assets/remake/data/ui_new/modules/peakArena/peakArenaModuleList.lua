local moduleNameList = {
  "peakArenaDefine",
  "peakArenaManager",
  "peakArenaNetwork",
  "peakArenaUITool",
  "peakArenaPvpScene",
  "peakArenaBattleLogWin",
  "peakArenaRankListWin",
  "peakArenaRecordReview",
  "peakArenaRewardWin",
  "peakArenaSetTeamWin",
  "peakArenaEvolveRuleWin",
  "peakArenaGradeChangeWin",
  "peakArenaRuleWin",
  "peakArenaPvpBattlePrepareData",
  "peakArenaPvpBattlePrepareScene",
  "peakArenaBattlePanel",
  "peakArenaChallengeResultWin",
  "peakArenaOppoInfoWin",
  "peakArenaRedDotTree",
  "buyPeakArenaTicketBox",
  "peakArenaWeeklyWin",
  "peakArenaSummaryWin",
  "peakArenaShopScene",
  "peakArenaShopRuleWin",
  "peakArenaBanHeroWin",
  "peakArenaVoteWin",
  "peakArenaVoteResultWin",
  "peakArenaStarWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/peakArena/" .. moduleName
end

local function canReload(name)
  return name ~= "peakArenaManager" and name ~= "peakArenaRedDotTree"
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
