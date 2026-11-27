local files = {"dailylogin"}
for _, file in ipairs(files) do
  require("ui_new.modules.dailylogin." .. file)
end
