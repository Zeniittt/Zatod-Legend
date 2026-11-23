local files = {
  "riseStarPage",
  "riseStarShopWin",
  "controller/riseStarMgr",
  "controller/riseStarNet"
}
for _, file in ipairs(files) do
  if file ~= "controller/riseStarMgr" then
    package.loaded["ui_new/modules/activity/riseStar/" .. file] = nil
  end
end
for _, file in ipairs(files) do
  require("ui_new/modules/activity/riseStar/" .. file)
end
