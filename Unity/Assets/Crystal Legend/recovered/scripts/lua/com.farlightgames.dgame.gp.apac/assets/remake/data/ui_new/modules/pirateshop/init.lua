local files = {
  "pirateshopManager",
  "pirateshopNetwork",
  "pirateshopScene",
  "pirateshopGoodsPop"
}
for _, file in ipairs(files) do
  require("ui_new.modules.pirateshop." .. file)
end
