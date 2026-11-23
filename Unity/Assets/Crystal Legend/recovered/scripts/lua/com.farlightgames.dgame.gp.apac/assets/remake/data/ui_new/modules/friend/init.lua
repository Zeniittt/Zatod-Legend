local files = {
  "addFriendPanel",
  "friendMainWin",
  "friendPanel",
  "requestFriendPanel",
  "friendItem",
  "crossFriendDetailWin"
}
for _, file in ipairs(files) do
  require("ui_new.modules.friend." .. file)
end
