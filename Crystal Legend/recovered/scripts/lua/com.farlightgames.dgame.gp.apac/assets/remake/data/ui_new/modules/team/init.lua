local moduleNameList = {
  "teamNetwork",
  "teamManager",
  "team"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/team/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
