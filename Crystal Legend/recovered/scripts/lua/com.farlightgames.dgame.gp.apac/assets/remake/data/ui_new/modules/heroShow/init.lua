local files = {
  "heroShowPop",
  "layerBasePage",
  "layerSkillPage",
  "layerSkinPage",
  "layerShardPage"
}
for _, file in ipairs(files) do
  require("ui_new.modules.heroShow." .. file)
end
