local files = {
  "guideHelper",
  "guideEvent",
  "guideInterface",
  "guideData",
  "guideLayer",
  "guideManager",
  "guideDialogue",
  "5v5"
}
ed.guide = {}
for _, file in ipairs(files) do
  require("ui_new.modules.guide." .. file)
end
