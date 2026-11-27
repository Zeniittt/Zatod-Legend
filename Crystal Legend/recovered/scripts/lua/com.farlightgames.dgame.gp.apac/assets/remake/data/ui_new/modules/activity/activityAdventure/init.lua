local files = {
  "actiAdventureMgr",
  "actiAdventureNet",
  "adventureDefine",
  "adventureRewardPanel",
  "adventureStageDetail",
  "heroAdditionPanel",
  "adventureStageScene"
}
for _, file in ipairs(files) do
  require("ui_new.modules.activity.activityAdventure." .. file)
end
