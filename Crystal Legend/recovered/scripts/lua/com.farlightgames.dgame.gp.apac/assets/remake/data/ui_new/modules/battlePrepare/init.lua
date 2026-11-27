local files = {
  "battleprepare",
  "controller",
  "dataresource",
  "uiview",
  "uichannel",
  "uireturn",
  "uiscrollbuttom",
  "action",
  "uienterbattle",
  "eventstack",
  "mercenaryMode",
  "event",
  "multiteamview",
  "uiteamchannel",
  "uiEnemyHeros",
  "battleprepare_manager",
  "uiheroselect/config",
  "uiheroselect/heropool",
  "uiheroselect/mercenary",
  "uiheroselect/pay",
  "uiheroselect/pool",
  "heroPayWin",
  "heroReliveWin"
}
for _, file in ipairs(files) do
  require("ui_new.modules.battlePrepare." .. file)
end
