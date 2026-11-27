module("ed.gmtools", package.seeall)
network = {}
network.__index = network
local test = true

function network.create()
  local object = {}
  setmetatable(object, network)
  return object
end

function network:dispatch(msg)
  local event, data
  if msg._query_replay then
    event = "query_replay_reply"
    data = msg._query_replay
  elseif msg._reset_activity_season then
    ed.SkillTowerManager.exTowerData = nil
    ed.showToast(T("\233\135\141\231\189\174\230\136\144\229\138\159"))
  elseif msg._server_full_version then
    local serverVersion = msg._server_full_version
    print("####################################################")
    print(string.format(T("\230\156\141\229\138\161\229\153\168\231\137\136\230\156\172\229\143\183:%s"), serverVersion))
    ed.showToast(string.format(T("\230\156\141\229\138\161\229\153\168\231\137\136\230\156\172\229\143\183:%s"), serverVersion))
    print("####################################################")
  elseif msg._upload_user_data then
    local uploadUserData = msg._upload_user_data
    print("####################################################")
    print(T("\228\184\138\228\188\160\231\142\169\229\174\182\230\149\176\230\141\174\230\136\144\229\138\159:"), uploadUserData)
    print("####################################################")
    ed.showToast(string.format(T("\228\184\138\228\188\160\231\142\169\229\174\182\230\149\176\230\141\174\230\136\144\229\138\159:%s"), uploadUserData))
  elseif msg._open_guild_enlist then
    ed.showToast(T("\230\137\147\229\188\128\229\133\172\228\188\154\230\139\155\229\139\159\229\164\167\229\142\133\230\136\144\229\138\159"))
  elseif msg._upload_guild_data then
    ed.showToast(T("\228\184\138\228\188\160\229\133\172\228\188\154\230\149\176\230\141\174\230\136\144\229\138\159:%s", msg._upload_guild_data))
    print(msg._upload_guild_data)
  elseif msg._download_guild_data then
    ed.showToast(T("\228\184\139\232\189\189%s\229\133\172\228\188\154\230\149\176\230\141\174\230\136\144\229\138\159,\232\180\166\229\143\183\231\153\187\229\189\149\230\160\188\229\188\143\239\188\154guild_GuildID_MemberIndex", msg._download_guild_data._guild_id))
    if msg._download_guild_data._user then
      local user = msg._download_guild_data._user
      ed.player:setup(user)
    end
  end
  if test then
    print("ed.gm.network dispatch", event)
  end
  FireEvent(event, data)
end

network = network.create()
