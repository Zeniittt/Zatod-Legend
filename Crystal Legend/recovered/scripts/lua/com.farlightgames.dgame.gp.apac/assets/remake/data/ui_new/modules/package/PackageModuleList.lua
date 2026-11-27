local moduleNameList = {
  "PackageManager",
  "NewItemMultipleChoice",
  "Package",
  "PackageComposeWin",
  "PackageSoldoutWin",
  "PackageSourceWin",
  "BatchUse",
  "PackageExpireWin",
  "PackageDetailWin",
  "consumeTipsWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/package/" .. moduleName
end

local function canReload(name)
  return name ~= "PackageManager"
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
