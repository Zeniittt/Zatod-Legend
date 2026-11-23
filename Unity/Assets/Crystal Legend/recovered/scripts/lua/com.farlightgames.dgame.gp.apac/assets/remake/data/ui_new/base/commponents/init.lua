local files = {
  "resourceBox",
  "mainButton"
}
for _, file in ipairs(files) do
  require("ui_new.base.commponents." .. file)
end
