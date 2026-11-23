local moduleNameList = {
  "dayAwardsManager",
  "dayAwardsNetwork",
  "dayAwardsScene"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/dayAwards/" .. moduleName
end

local function canReload(name)
  return name ~= "dayAwardsManager"
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
