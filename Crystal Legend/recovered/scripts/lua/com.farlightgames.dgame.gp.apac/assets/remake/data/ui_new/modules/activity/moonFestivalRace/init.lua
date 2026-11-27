local moduleNameList = {}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/activity/moonFestivalRace/" .. moduleName
end

for _, v in ipairs(moduleNameList) do
  if v ~= "moonFestivalMgr" then
    local fullPath = getModuleFullPath(v)
    package.loaded[fullPath] = nil
  end
end
for _, v in ipairs(moduleNameList) do
  local fullPath = getModuleFullPath(v)
  require(fullPath)
end
