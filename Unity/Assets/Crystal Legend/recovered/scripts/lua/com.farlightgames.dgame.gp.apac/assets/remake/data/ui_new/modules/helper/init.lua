local moduleNameList = {
  "speedHelperWindow",
  "speedHelperFloating",
  "speedHelperMgr"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/helper/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  if v ~= "speedHelperMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
