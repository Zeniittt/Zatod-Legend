local files = {
  "fireworkShopScene",
  "nianMonsterMainScene",
  "nianMonsterMgr",
  "nianMonsterNet",
  "nianMonsterDefine",
  "nianMonsterRank",
  "nianMonsterReward"
}
for _, file in ipairs(files) do
  require("ui_new.modules.activity.nianMonster." .. file)
end
