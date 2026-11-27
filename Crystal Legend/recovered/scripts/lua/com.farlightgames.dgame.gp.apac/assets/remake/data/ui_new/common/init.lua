local files = {
  "announce.init",
  "buyResourceBox",
  "dialog",
  "buyVitalityBox"
}
for _, file in ipairs(files) do
  require("ui_new.common." .. file)
end
