local files = {
  "timeCorridorMainScene",
  "timeCorridorMgr",
  "timeCorridorNet",
  "timeCorridorRecordWin",
  "timeCorridorPoolWin",
  "timeCorridorShopScene",
  "timeCorridorShopPop",
  "timeCorridorRewardsWin",
  "timeCorridorRewardCardWin"
}

local function getModuleListPrefix()
  return "ui_new.modules.activity.timeCorridor."
end

for _, file in ipairs(files) do
  if file ~= "timeCorridorMgr" then
    local filePath = getModuleListPrefix() .. file
    package.loaded[filePath] = nil
  end
end
for _, file in ipairs(files) do
  require(getModuleListPrefix() .. file)
end
