local moduleNameList = {
  "fireForgeMainScene",
  "fireForgeWishWindow",
  "fireForgeConfirmWindow",
  "fireForgeBreakdownScene",
  "fireForgePackageScene",
  "fireForgeRewardWindow",
  "fireForgeComposeWin",
  "fireForgeFragmentSoldWinNew",
  "fireForgeSpeedUpWindow",
  "fireForgeLotteryEffectWindow",
  "fireForgeBuffTipsWindow",
  "fireForgeHandbookScene",
  "forgingRecordWindow",
  "fireForgeNewEquipWindow"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/legendEquip/fireForge/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  package.loaded[fullPath] = nil
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
