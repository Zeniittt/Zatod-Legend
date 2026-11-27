local files = {
  "retrievalRewardDefine",
  "retrievalRewardNet",
  "retrievalRewardMgr"
}
for _, file in ipairs(files) do
  require("ui_new.modules.retrievalReward." .. file)
end
