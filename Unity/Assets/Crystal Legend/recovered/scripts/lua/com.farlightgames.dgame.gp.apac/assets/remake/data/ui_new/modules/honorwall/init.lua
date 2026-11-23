local files = {
  "grids",
  "playerinfopanel",
  "playersignpanel",
  "medalinfopanel",
  "avatarinfopanel",
  "playeraddhonorpanel"
}
for _, file in ipairs(files) do
  require("ui_new.modules.honorwall." .. file)
end
