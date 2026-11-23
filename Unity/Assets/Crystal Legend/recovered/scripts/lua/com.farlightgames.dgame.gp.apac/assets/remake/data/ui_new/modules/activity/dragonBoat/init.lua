local moduleNameList = {
  "dragonBoatMainScene",
  "dragonBoatMgr",
  "dragonBoatNetwork",
  "dragonBoatRewardScene",
  "dragonBoatPassPop",
  "dragonBoatPassReward",
  "dragonBoatPassTask",
  "dragonBoatUseZongziPop",
  "dragonBoatBoatPop",
  "dragonBoatRankScene",
  "dragonBoatGiveRecordPop",
  "dragonBoatUpLevelPop",
  "sceneElementClass/dragonBoatClass",
  "sceneElementClass/dragonBoatBGClass",
  "sceneElementClass/dragonBoatBoatMgrClass"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/activity/dragonBoat/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  if v ~= "dragonBoatMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
