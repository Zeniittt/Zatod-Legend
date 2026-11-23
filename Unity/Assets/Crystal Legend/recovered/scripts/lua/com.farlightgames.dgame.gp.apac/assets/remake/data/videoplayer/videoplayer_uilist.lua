local uilist = {
  "videoplayer/videoplayer_manager",
  "videoplayer/videoplayer_network",
  "videoplayer/videoplayer_end",
  "videoplayer/videoplayer_panel",
  "videoplayer/videoplayer_barrage",
  "videoplayer/videoplayer_report"
}
for _, ui in ipairs(uilist) do
  require(ui)
end
ed.videoplayer.uilist = uilist
