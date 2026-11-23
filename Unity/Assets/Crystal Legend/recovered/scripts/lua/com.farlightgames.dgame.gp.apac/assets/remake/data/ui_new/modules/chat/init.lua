local files = {
  "chatBattleReplay",
  "chatEmoji",
  "chatEntrance",
  "chatMainWin",
  "chatManager",
  "chatMsgList",
  "chatNetWork",
  "delChatMemberWin",
  "chatLadderFight",
  "KingsPvpChatSelectionWrap",
  "chatSettingWin"
}
for _, file in ipairs(files) do
  require("ui_new.modules.chat." .. file)
end
