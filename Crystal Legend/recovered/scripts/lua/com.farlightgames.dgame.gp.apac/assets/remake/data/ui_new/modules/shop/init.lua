local files = {
  "shopNetwork",
  "shopData",
  "shopMain",
  "fastsell",
  "exteriorShop.exteriorShopData",
  "exteriorShop.exteriorShopPops"
}
for _, file in ipairs(files) do
  require("ui_new.modules.shop." .. file)
end
