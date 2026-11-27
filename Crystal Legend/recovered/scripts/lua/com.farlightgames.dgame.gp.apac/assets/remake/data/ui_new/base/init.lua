local files = {
  "basetouchnode",
  "basenode",
  "basescene",
  "popwindow",
  "basenode",
  "basescene",
  "popwindow",
  "shortcut",
  "statusbar",
  "commonscene",
  "commponents.init",
  "TransitionScene"
}
for _, file in ipairs(files) do
  require("ui_new.base." .. file)
end
