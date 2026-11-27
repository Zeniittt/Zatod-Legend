local moduleNameList = {
  "authenticationMainPop",
  "authenticationConfirmPop",
  "authenticationNetwork",
  "authenticationMgr"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/authentication/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  if v ~= "authenticationMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
