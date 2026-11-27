local moduleList = {
  "ui_new/modules/cuparena/CupArenaNetwork",
  "ui_new/modules/cuparena/CupArenaManager",
  "ui_new/modules/cuparena/CupArenaChooseCampWin",
  "ui_new/modules/cuparena/CupArenaMatchBaseScene",
  "ui_new/modules/cuparena/CupArenaMatchPlazaScene",
  "ui_new/modules/cuparena/CupArenaDefensiveWin",
  "ui_new/modules/cuparena/CupArenaBattleRecordWin",
  "ui_new/modules/cuparena/CupArenaChallengeScene",
  "ui_new/modules/cuparena/CupArenaBattleWin",
  "ui_new/modules/cuparena/CupArenaChallengeResultWin",
  "ui_new/modules/cuparena/CupArenaOppoInfoWin",
  "ui_new/modules/cuparena/CupArenaMatchHeadIcon",
  "ui_new/modules/cuparena/CupArenaOperateMenu",
  "ui_new/modules/cuparena/CupArenaAuditionSummaryWin",
  "ui_new/modules/cuparena/CupArenaKnockoutChallengeScene",
  "ui_new/modules/cuparena/CupArenaKnockoutFinalScheduleScene",
  "ui_new/modules/cuparena/CupArenaKnockoutGroupScheduleWin",
  "ui_new/modules/cuparena/CupArenaKnockoutFinalScheduleWin",
  "ui_new/modules/cuparena/CupArenaGambleScene",
  "ui_new/modules/cuparena/CupArenaGambleAmountWin",
  "ui_new/modules/cuparena/CupArenaGambleRecordWin",
  "ui_new/modules/cuparena/CupArenaTimelineWin",
  "ui_new/modules/cuparena/CupArenaBattlePrepareScene",
  "ui_new/modules/cuparena/CupArenaUITool",
  "ui_new/modules/cuparena/CupArenaSeasonHistoryWin",
  "ui_new/modules/cuparena/CupArenaFamousScene",
  "ui_new/modules/cuparena/CupArenaEffectPlayWin",
  "ui_new/modules/cuparena/CupArenaRankRewardPop",
  "ui_new/modules/cuparena/CupArenaTaskWin"
}
for i, v in ipairs(moduleList) do
  package.loaded[v] = nil
end
for i, v in ipairs(moduleList) do
  require(v)
end
