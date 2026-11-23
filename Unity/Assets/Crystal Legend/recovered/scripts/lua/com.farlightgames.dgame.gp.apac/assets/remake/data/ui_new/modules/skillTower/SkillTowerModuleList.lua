local moduleNameList = {
  "SkillTowerManager",
  "SkillTowerRuleWin",
  "SkillTowerScene",
  "SkillTowerNetwork",
  "SkillTowerStageScene",
  "SkillTowerRewardWin",
  "SkillTowerBattleEndWin",
  "SkillTowerExStageScene",
  "SkillTowerExBattleEndWin",
  "SkillTowerAbyssRankWin",
  "SkillTowerAbyssRecordWin",
  "SkillTowerExRuleWin",
  "SkillTowerBuffDetailWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/skillTower/" .. moduleName
end

local function canReload(name)
  return name ~= "SkillTowerManager"
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
