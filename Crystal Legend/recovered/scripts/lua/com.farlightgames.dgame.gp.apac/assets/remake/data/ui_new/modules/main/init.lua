local files = {
  "mainScene",
  "preload_inmainscene"
}
for _, file in ipairs(files) do
  require("ui_new.modules.main." .. file)
end
