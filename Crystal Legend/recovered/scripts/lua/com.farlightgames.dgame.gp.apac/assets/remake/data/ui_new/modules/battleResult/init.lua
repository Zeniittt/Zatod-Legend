local files = {
  "BattleResultConfig",
  "commonBattleFail",
  "commonBattleWin",
  "dreamLandBattleResult",
  "BattleStatics"
}
for _, file in ipairs(files) do
  require("ui_new.modules.battleResult." .. file)
end
