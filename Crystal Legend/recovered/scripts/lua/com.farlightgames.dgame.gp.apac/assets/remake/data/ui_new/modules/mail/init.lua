local files = {
  "mailutil",
  "maillocalBox",
  "mailbox",
  "overfull"
}
for _, file in ipairs(files) do
  require("ui_new.modules.mail." .. file)
end
