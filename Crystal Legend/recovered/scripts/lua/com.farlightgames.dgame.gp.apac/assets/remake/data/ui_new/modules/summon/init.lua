local files = {
  "summonManager",
  "summonNetwork",
  "summonScene",
  "summonWishWindow",
  "summonRewardsWindow",
  "summonRewardCardWindow",
  "summonRuleTips",
  "summonDestinyWindow",
  "summonDestinyRule",
  "summonTimelyRule",
  "summonRecordWin",
  "summonHeroHot",
  "summonNewbieRule",
  "summonNewbieSelectWin",
  "summonNewbieRecommendWin",
  "summonNewbieConfirmWin",
  "riseStar/summonRiseStarSelectWin",
  "riseStar/summonRiseStarConfirmWin",
  "riseStar/summonRiseStarRecommendWin"
}
for _, file in ipairs(files) do
  require("ui_new.modules.summon." .. file)
end
