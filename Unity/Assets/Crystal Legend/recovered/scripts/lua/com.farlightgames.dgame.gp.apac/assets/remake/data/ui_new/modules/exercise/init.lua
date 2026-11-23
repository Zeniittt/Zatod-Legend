local files = {
  "exerciseMainScene",
  "exerciseManager",
  "exerciseNetWork",
  "exercisePreviewWin",
  "exerciseStageWin"
}
for _, file in ipairs(files) do
  require("ui_new.modules.exercise." .. file)
end
