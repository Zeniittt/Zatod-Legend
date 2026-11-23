local uilist = {
  "ui/hothero/hothero_mgr"
}
for _, path in ipairs(uilist) do
  require(path)
end
ed.hothero.uilist = uilist
