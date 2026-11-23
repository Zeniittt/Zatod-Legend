local uilist = {
  "ui/loading/loading_manager",
  "ui/loading/loading_scene"
}
for _, ui in ipairs(uilist) do
  require(ui)
end
