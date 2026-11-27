local moduleNameList = {
  "ui_new/common/controllers/loadFlower",
  "ui_new/common/controllers/action",
  "ui_new/common/controllers/button",
  "ui_new/common/controllers/panel",
  "ui_new/common/controllers/listview",
  "ui_new/common/controllers/tableview",
  "ui_new/common/controllers/editttf",
  "ui_new/common/controllers/superlink",
  "ui_new/common/controllers/richtext",
  "ui_new/common/controllers/newrichtext",
  "ui_new/common/controllers/editbox",
  "ui_new/common/controllers/progressbar",
  "ui_new/common/controllers/energy_bar",
  "ui_new/common/controllers/heroiconwidget",
  "ui_new/common/controllers/herowaitwidget",
  "ui_new/common/controllers/draglist",
  "ui_new/common/controllers/autoDragList",
  "ui_new/common/controllers/scrollview",
  "ui_new/common/controllers/readaction"
}
for _, v in ipairs(moduleNameList) do
  require(v)
end
