local moduleNameList = {
  "SoloModel",
  "SoloManager",
  "SoloNetwork",
  "SoloArenaScene",
  "SoloMainPanel",
  "SoloRankManager",
  "SoloMatchWin",
  "SoloLoadScene",
  "SoloSelectHeroWin",
  "SoloShopWindow",
  "SoloArenaRule",
  "SoloStickerNode",
  "SoloResultWin",
  "SoloUITool",
  "SoloMarqueeManager",
  "SoloRoomSwitch",
  "SoloCreateRoomSwitchWin",
  "SoloRoomPrepare",
  "SoloMultiplayerwarn",
  "SoloPlayerInviteWin",
  "SoloSelectPowerWin",
  "SoloPlayerItem",
  "SoloGoldTip",
  "SoloStageTip",
  "SoloDataPanel",
  "SoloFactionPanel",
  "SoloBookWin",
  "SoloChooseFactionWin",
  "SoloPowerInfoPop",
  "SoloTabWin",
  "SoloRecordWin",
  "SoloResultDetailWin",
  "SoloTestWin",
  "SoloRankPop",
  "SoloSkillPop",
  "SoloGoldTip",
  "SoloAttrTip",
  "SoloFactionPop",
  "soloHistoryPop",
  "soloGradeRewardPop"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/solo/" .. moduleName
end

local function canReload(name)
  return name ~= "SoloManager" and name ~= "SoloRankManager" and name ~= "SoloNetwork"
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
