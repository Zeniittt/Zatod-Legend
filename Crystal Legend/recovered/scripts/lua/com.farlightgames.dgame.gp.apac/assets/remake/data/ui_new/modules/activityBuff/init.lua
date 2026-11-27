local files = {
  "activityBuffMgr",
  "buffTipsPanel"
}
for _, file in ipairs(files) do
  require("ui_new.modules.activityBuff." .. file)
end
