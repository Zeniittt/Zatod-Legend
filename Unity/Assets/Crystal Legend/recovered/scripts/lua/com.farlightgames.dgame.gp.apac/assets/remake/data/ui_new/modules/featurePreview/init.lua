local files = {
  "featurePreviewManager",
  "featurePreviewNetwork",
  "featurePreviewWindow"
}
for _, file in ipairs(files) do
  require("ui_new.modules.featurePreview." .. file)
end
