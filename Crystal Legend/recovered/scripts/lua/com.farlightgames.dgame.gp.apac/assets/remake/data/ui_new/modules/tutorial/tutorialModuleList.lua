local moduleNameList = {
  "tutorialres",
  "tutorial",
  "tutorialcheck",
  "tutorialmaker"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/tutorial/" .. moduleName
end

local function canReload(name)
  return true
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
