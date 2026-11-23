local moduleNameList = {
  "tavernMainScene",
  "tavernDefine"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/tavern/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  package.loaded[fullPath] = nil
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
