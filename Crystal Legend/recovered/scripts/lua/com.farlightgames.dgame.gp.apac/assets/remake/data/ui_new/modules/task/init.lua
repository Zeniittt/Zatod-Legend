local files = {
  "taskBase",
  "taskNetwork",
  "taskSomeModule",
  "taskData.taskData",
  "taskData.weeklyjobData",
  "taskScene.taskScene",
  "taskScene.pages.psssPageShop",
  "taskScene.pages.achPagePoint",
  "taskScene.pages.psssPageBuyLevel"
}
for _, file in ipairs(files) do
  require("ui_new.modules.task." .. file)
end
