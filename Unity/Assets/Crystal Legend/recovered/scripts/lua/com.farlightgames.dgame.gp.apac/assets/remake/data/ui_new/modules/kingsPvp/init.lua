local moduleNameList = {
  "kingsPvpNetwork",
  "kingsPvpMgr",
  "kingsPvpHeroMgr",
  "kingsPvpDefine",
  "kingsPvpMainScene",
  "kingsPvpCreateRoomWindow",
  "kingsPvpSelectModeWindow",
  "kingsPvpBanPickScene",
  "kingsPvpFindOppoWin",
  "kingsPvpRecordWin",
  "kingsRecordDetail1Win",
  "kingsRecordDetail3Win",
  "kingsLoadingWindow",
  "kingsBattleResultWindow",
  "kingsMatchingWindow",
  "kingsJoinRoomWindow",
  "localbattle",
  "localbattleteam",
  "kingsPvpShareWindow",
  "kingsRoomWindow",
  "kingsRoomMenuWin",
  "kingsInviteWindow",
  "kingsPlayerInviteWin",
  "kingsPvpRoomModeWin",
  "kingsRankMedalWin",
  "kingsGradeUpWin",
  "kingsGradeDownWin",
  "kingsNewSeasonWin",
  "kingsSeasonHistoryWin",
  "kingsRankRewardWin",
  "kingsBuffTipsWindow"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/kingsPvp/" .. moduleName
end

if ed.realarena and ed.realarena.network_mgr then
  ed.realarena.network_mgr:Destroy()
  ed.realarena.network_mgr = nil
end
for _, v in ipairs(moduleNameList) do
  if v ~= "kingsPvpMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
