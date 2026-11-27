local files = {
  "funOpenWindow",
  "funOpenMgr",
  "playerInfoWindow",
  "headSettingWindow",
  "renameWindow",
  "headUtil",
  "checkOthersHeroWindow",
  "pushNotificationWin",
  "redeemCodeWin",
  "serviceSettingWin",
  "languageSettingWin",
  "currencyDetailWin",
  "sdkRightsDisplayWindow",
  "sdkRightsSettingWindow",
  "communityWin",
  "medalPop"
}
for _, file in ipairs(files) do
  require("ui_new.modules.player." .. file)
end
