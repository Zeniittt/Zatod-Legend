local moduleNameList = {
  "PetManager",
  "PetNetwork",
  "PetGainWin",
  "PetAddSpeedWin",
  "PetChooseHatchWin",
  "PetAttrWin",
  "PetInfoWin",
  "PetMainScene",
  "PetModel",
  "PetLevelUpTip",
  "PetRuleTips",
  "PetChooseMasterWin",
  "PetQuitHeroWin",
  "PetEggProbWin",
  "PetLuckRuleTip"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/pet/" .. moduleName
end

local function canReload(name)
  return name ~= "PetManager"
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
