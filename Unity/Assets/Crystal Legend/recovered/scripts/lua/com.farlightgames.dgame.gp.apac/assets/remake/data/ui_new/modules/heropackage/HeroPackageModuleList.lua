local moduleNameList = {
  "HeroPackageMainScene"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/heropackage/" .. moduleName
end

local function canReload(name)
  return name ~= "HeroPackageManager"
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
  local uis = {
    "ui_new/modules/hero/heroDetailAstrolabe",
    "ui_new/modules/hero/astrolabeAttDiffWin"
  }
  for k, v in ipairs(uis) do
    ReloadModule(v)
  end
end
EDLoadShader("GrayScalingShader_2")
