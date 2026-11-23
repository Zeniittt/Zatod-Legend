local uilist = {
  "ui/battleprepare/controller",
  "ui/battleprepare/dataresource",
  "ui/battleprepare/uiview",
  "ui/battleprepare/uichannel",
  "ui/battleprepare/uireturn",
  "ui/battleprepare/uiscrollbuttom",
  "ui/battleprepare/action",
  "ui/battleprepare/uienterbattle",
  "ui/battleprepare/eventstack",
  "ui/battleprepare/mercenaryMode",
  "ui/battleprepare/event",
  "ui/battleprepare/multiteamview",
  "ui/battleprepare/uiteamchannel",
  "ui/battleprepare/uiEnemyHeros",
  "ui/battleprepare/battleprepare_manager",
  "ui/battleprepare/uiheroselect/config",
  "ui/battleprepare/uiheroselect/heropool",
  "ui/battleprepare/uiheroselect/mercenary",
  "ui/battleprepare/uiheroselect/pay",
  "ui/battleprepare/uiheroselect/pool"
}
for _, ui in ipairs(uilist) do
  require(ui)
end
ed.battleprepare.uilist = uilist
