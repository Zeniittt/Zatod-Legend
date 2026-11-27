local moduleNameList = {
  "AutoChessModel",
  "AutoChessNetwork",
  "AutoChessManager",
  "AutoChessShopWindow",
  "AutoChessPlayerItem",
  "AutoChessMainPanel",
  "AutoChessArenaScene",
  "AutoChessArenaRule",
  "AutoChessHeroDetailWin",
  "AutoChessEquipPetWin",
  "AutoChessPetBagWin",
  "AutoChessTagNode",
  "AutoChessStickerNode",
  "AutoChessLoadScene",
  "AutoChessResultScene",
  "AutoChessUITool",
  "AutoChessRaceWin",
  "AutoChessRaceDetailWin",
  "AutoChessTeachManager",
  "AutoChessDamageItem",
  "AutoChessMarqueeManager",
  "AutoChessRankManager",
  "AutoChessRankIconPanel",
  "AutoChessRankGradeListWindow",
  "AutoChessRoomSwitch",
  "AutoChessRoomPrepare",
  "AutoChessMatchWin",
  "multiplayerwarn",
  "AutoChessTestUI",
  "AutoChessTagPanel",
  "AutoChessPlayerInviteWin",
  "AutoChessSelectPowerWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/autoChess/" .. moduleName
end

local function canReload(name)
  return name ~= "AutoChessManager" and name ~= "AutoChessTeachManager" and name ~= "AutoChessRankManager"
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
