local moduleNameList = {
  "awakeDungeonBossStageDetail",
  "awakeDungeonChapterInfo",
  "awakeDungeonStageDetail",
  "awakeDungeonSpecialStageDetail",
  "awakeDungeonSpecialStageInfo",
  "awakeDungeonManager",
  "awakeDungeonDefine",
  "awakeDungeonStageScene",
  "awakeDungeonLevelScene",
  "awakeDungeonNetwork",
  "awakeDungeonBossDetailWin",
  "awakeDungeonLevelUpWin",
  "awakeDungeonBossReward",
  "awakeDungeonEndWin",
  "awakeDungeonSpecialEndWin",
  "awakeDungeonBuyEnergy",
  "awakeDungeonFirstBloodWin",
  "awakeDungeonBuffDetailWin",
  "awakeDungeonParagonExpWrap",
  "map/awakeDungeonGridMapScene",
  "map/awakeDungeonSpineModelItem",
  "map/awakeDungeonSpriteModelItem"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/awakeDungeonPVE/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
