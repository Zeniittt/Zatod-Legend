local files = {
  "debugLogin",
  "logo",
  "patchRes",
  "serverlogin",
  "serverlist",
  "notes",
  "ageTips",
  "dirServers",
  "serverListWin",
  "noticeWindow",
  "versionchange",
  "netAlertDialog"
}
for _, file in ipairs(files) do
  require("ui_new.modules.login." .. file)
end
