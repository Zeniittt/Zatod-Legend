local files = {
  "mapMainScene"
}
for _, file in ipairs(files) do
  require("ui_new.map." .. file)
end
