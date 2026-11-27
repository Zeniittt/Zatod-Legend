local files = {
  "announce",
  "getnewhero",
  "getprop",
  "heroevolve",
  "herofashion",
  "herofashionskillunlock",
  "heroupgrade",
  "npcupgrade",
  "playerlevelup",
  "popherocard",
  "popherofashion",
  "dialog",
  "toast",
  "confirmdialog",
  "prodexplain",
  "heroHint",
  "heroHintManager"
}
for _, file in ipairs(files) do
  require("ui_new.common.announce." .. file)
end
