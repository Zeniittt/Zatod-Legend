local uilist = {
  "gmtools/battlereplay",
  "gmtools/commandconfig",
  "gmtools/gm",
  "gmtools/newgm",
  "gmtools/gm_network",
  "gmtools/server_ping"
}
for _, ui in ipairs(uilist) do
  require(ui)
end
ed.gmtools.uilist = uilist
