local files = {
  "hadesMgr",
  "hadesNet",
  "hadesRank",
  "hadesMainScene",
  "hadesBossDetail",
  "hadesAllHeat",
  "hadesBattleResult",
  "hadesDefine",
  "hadesReward",
  "hadesTaskWindow"
}
for _, file in ipairs(files) do
  require("ui_new.modules.activity.hades." .. file)
end
