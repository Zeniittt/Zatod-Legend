local moduleNameList = {
  "sweetPartyManager",
  "sweetPartyNetwork",
  "sweetPartyScene"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/sweetParty/" .. moduleName
end

local function canReload(name)
  return name ~= "sweetPartyManager"
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
