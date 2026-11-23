local files = {
  "heroHagglePage",
  "heroHaggleHeroWin",
  "heroHaggleTaskWin",
  "controller/heroHaggleMgr",
  "controller/heroHaggleNet"
}
for _, file in ipairs(files) do
  if file ~= "controller/heroHaggle" then
    package.loaded["ui_new/modules/activity/heroHaggle/" .. file] = nil
  end
end
for _, file in ipairs(files) do
  require("ui_new/modules/activity/heroHaggle/" .. file)
end
