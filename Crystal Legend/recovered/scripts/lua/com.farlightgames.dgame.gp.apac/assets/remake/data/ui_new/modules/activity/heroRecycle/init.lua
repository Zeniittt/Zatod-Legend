local files = {
  "heroRecycleMgr",
  "heroRecycleNet"
}
for _, file in ipairs(files) do
  if file ~= "heroRecycleMgr" then
    package.loaded["ui_new/modules/activity/heroRecycle/" .. file] = nil
  end
end
for _, file in ipairs(files) do
  require("ui_new/modules/activity/heroRecycle/" .. file)
end
