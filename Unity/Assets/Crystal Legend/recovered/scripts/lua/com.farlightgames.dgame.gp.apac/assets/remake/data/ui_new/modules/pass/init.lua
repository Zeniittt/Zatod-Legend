local files = {
  "passDefine",
  "passNetWork",
  "passManager"
}
for _, file in ipairs(files) do
  require("ui_new.modules.pass." .. file)
end
