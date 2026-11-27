local moduleNameList = {
  "CrusadeManager",
  "CrusadeMainScene",
  "CrusadeNetwork",
  "CrusadeRuleWin",
  "CrusadeChallengeWin",
  "CrusadeReplayMainWin",
  "CrusadeBattleVictoryWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/crusade/" .. moduleName
end

local function canReload(name)
  return name ~= "CrusadeManager"
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
