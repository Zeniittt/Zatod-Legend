local files = {
  "stageselectres",
  "stagedetailres",
  "stageselect",
  "stagedetail",
  "legendaryContinent",
  "stageRepeatReward",
  "stageChooseLootPop",
  "stageLineupPop"
}
for _, file in ipairs(files) do
  require("ui_new.modules.stage." .. file)
end
