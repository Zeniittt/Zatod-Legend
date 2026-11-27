local moduleNameList = {
  "RechargeManager",
  "RechargeNetwork",
  "RechargeScene",
  "RechargeBuyGiftWin",
  "SecretBoxScene",
  "SecretBoxRuleWin",
  "MinorBuyTipsWin"
}

local function getModuleFullPath(moduleName)
  return "ui_new/modules/recharge/" .. moduleName
end

local function canReload(name)
  return name ~= "RechargeManager"
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
if ReloadModule then
  local uis = {}
  for k, v in ipairs(uis) do
    ReloadModule(v)
  end
end
