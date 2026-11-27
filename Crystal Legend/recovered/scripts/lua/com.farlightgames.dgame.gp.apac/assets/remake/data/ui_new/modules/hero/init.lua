local moduleNameList = {
  "heroCardWindow",
  "heroDetailManager",
  "heroDetailListener",
  "heroDetailParam",
  "heroDetailScene",
  "heroDetailBase",
  "heroDetailAttrWin",
  "heroDetailEvolveWin",
  "upgradewindow",
  "heroDetailSkill",
  "heroDetailShard",
  "skillRankUpWin",
  "heroDetailSkin",
  "heroDetailShardPops",
  "materialSupplyWin",
  "heroDetailPet",
  "heroDetailChoosePet",
  "heroDetailAstrolabe",
  "heroAstrolabeAttWin",
  "heroDetailAstrolabeRulePop",
  "astrolabeAttDiffWin",
  "kaelSkillCombineWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/hero/" .. moduleName
end

local function canReload(name)
  return name ~= "heroDetailManager"
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
