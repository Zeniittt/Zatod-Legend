local files = {
  "presetData",
  "presetSceneModule",
  "presetNetwork",
  "presetScene"
}
for _, file in ipairs(files) do
  require("ui_new.modules.preset." .. file)
end
