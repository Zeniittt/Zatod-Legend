local files = {
  "accordion",
  "ranklistNetwork",
  "ranklistData",
  "ranklistBase",
  "ranklistMain",
  "summary.userPvpSummaryWin",
  "summary.guildSummaryWin",
  "summary.collectionSummaryPop"
}
for _, file in ipairs(files) do
  require("ui_new.modules.ranklist." .. file)
end
