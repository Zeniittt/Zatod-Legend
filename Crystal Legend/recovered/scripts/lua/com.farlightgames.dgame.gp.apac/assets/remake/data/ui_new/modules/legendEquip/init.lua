local moduleNameList = {
  "legendEquipDefine",
  "legendEquipNet",
  "legendEquipMgr",
  "legendEquipTool",
  "legendEquipWindow",
  "legendEquipStarUpConfirm",
  "legendEquipRankUpConfirm",
  "legendEquipUnbindConfirm",
  "legendEquipResetConfirm",
  "legendEquipResetRewardWindow",
  "legendEquipBindHeroWindow",
  "legendEquipSelectWindow",
  "legendEquipShopScene",
  "legendEquipRuneDetailWindow",
  "legendEquipGetWayWindow",
  "legendEquipOnlyTips",
  "legendEquipTipPop",
  "legendEquipBindConfirmWindow",
  "fireForge/init"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/legendEquip/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  if v ~= "legendEquipMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
