local moduleNameList = {
  "ui_new/common/parameter/parameter",
  "ui_new/common/parameter/baseres",
  "ui_new/common/parameter/uires",
  "ui_new/common/parameter/eventres",
  "ui_new/common/parameter/packageres",
  "ui_new/common/parameter/loadingres",
  "ui_new/common/parameter/exerciseres"
}
for _, v in ipairs(moduleNameList) do
  require(v)
end
