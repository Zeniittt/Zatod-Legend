local moduleNameList = {
  "rogueLikeDefine",
  "rogueLikeNet",
  "rogueLikeMgr",
  "rogueToast",
  "rogueResultHandle",
  "rogueEventChoiceEnableHandle",
  "rogueMainScene",
  "rogueMapScene",
  "rogueRoomDetailWindow",
  "rogueEventScene",
  "rogueEventBusiness",
  "rogueLikeTool",
  "rogueDestinyChooseScene",
  "rogueBlessScene",
  "rogueShopScene",
  "rogueBattlePrepare",
  "rogueGlobalBuffWindow",
  "rogueCollectScene",
  "rogueCollectDestinyScene",
  "rogueCollectEventScene",
  "rogueCollectRewardWindow",
  "rogueBookWindow",
  "rogueTechTreeScene",
  "rogueBattleWin",
  "rogueBattleFail",
  "rogueBlessChooseScene",
  "rogueRevelationUnlockWindow",
  "rogueTeamWindow",
  "rogueBlessReinforceWindow",
  "rogueTallyWindow",
  "rogueExchangePetWindow",
  "rogueExitChapterWindow",
  "rogueRevelationDetailWindow",
  "rogueRewardWindow",
  "rogueExitBattleTipsWindow",
  "rogueGuide",
  "rogueBossDetailWindow",
  "rogueGoldenScene",
  "rogueRankWindow",
  "rogueCollectScriptScene",
  "rogueCrisisRuleWindow",
  "rogueCharmBagScene",
  "rogueCharmShowWindow"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/rogueLike/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  if v ~= "rogueLikeMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
