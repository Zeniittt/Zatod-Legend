local moduleNameList = {
  "redPointManager"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/redPointTree/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
