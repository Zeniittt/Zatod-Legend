local modules = {
  "GuildMountManager",
  "GuildMountNetwork",
  "GuildMountMainScene",
  "GuildMountDetailWin",
  "GuildMountRuleWin",
  "GuildMountRankRewardWin",
  "GuildMountRewardDetailWin",
  "GuildMountShopScene",
  "GuildMountBattleEndWin",
  "GuildMountRewardWin",
  "GuildMountRankListWin",
  "GuildMountChangeActorWin",
  "GuildMountPracticeBattleEndWin"
}

local function canReload(vv)
  if vv == "GuildMountManager" then
    return false
  end
  return true
end

for _, v in ipairs(modules) do
  if canReload(v) then
    package.loaded["ui_new/modules/guildMount/" .. v] = nil
  end
end
for _, v in ipairs(modules) do
  require("ui_new/modules/guildMount/" .. v)
end
if ReloadModule then
  local uis = {}
  for k, v in ipairs(uis) do
    ReloadModule(v)
  end
end
