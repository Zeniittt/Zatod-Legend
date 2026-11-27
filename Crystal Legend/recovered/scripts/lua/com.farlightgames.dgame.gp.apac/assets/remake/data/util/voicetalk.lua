module("ed.Voice", package.seeall)
local ed = ed
VoiceTalk = {}
if EDFLAGIOS then
  ed.openVoicetalk = cc and cc.YTalk and true or false
else
  ed.openVoicetalk = EDFLAGANDROID_VOICE and cc and cc.YTalk and true or false
end
local yTalkInstance, pendingUserid, pendingRoomid, currentUserid, currentRoomid
local inChannel = false
local youmeAppId, youmeAppKey
local voiceInitHandlers = {}
local joinChannelHandlers = {}
local channelErrorHandlers = {}
local exitChannelHandlers = {}

local function toExpan(code)
  local codetbl = {
    [0] = "\230\136\144\229\138\159",
    [-1] = "\228\188\160\229\133\165\229\143\130\230\149\176\233\148\153\232\175\175",
    [-2] = "\229\183\178\231\187\143\229\136\157\229\167\139\229\140\150",
    [-3] = "\232\191\152\230\178\161\230\156\137\229\136\157\229\167\139\229\140\150\239\188\140\229\156\168\232\176\131\231\148\168\230\159\144\229\135\189\230\149\176\228\185\139\229\137\141\232\166\129\229\133\136\232\176\131\231\148\168\229\136\157\229\167\139\229\140\150\229\185\182\228\184\148\232\166\129\230\160\185\230\141\174\232\191\148\229\155\158\229\128\188\231\161\174\228\191\157\229\136\157\229\167\139\229\140\150\230\136\144\229\138\159",
    [-4] = "\229\134\133\229\173\152\233\148\153\232\175\175",
    [-5] = "\229\145\188\229\143\171\229\164\177\232\180\165",
    [-6] = "\229\144\175\229\138\168\229\188\149\230\147\142\229\164\177\232\180\165",
    [-7] = "\229\129\156\230\173\162\229\188\149\230\147\142\229\164\177\232\180\165",
    [-8] = "\233\157\158\230\179\149\228\189\191\231\148\168SDK",
    [-9] = "\231\138\182\230\128\129\233\148\153\232\175\175",
    [-10] = "\233\135\141\229\174\154\229\144\145\229\164\177\232\180\165",
    [-11] = "\230\173\163\229\156\168\229\136\157\229\167\139\229\140\150",
    [-12] = "\228\184\141\229\133\129\232\174\184\228\189\191\231\148\168\231\167\187\229\138\168\231\189\145\231\187\156",
    [-13] = "\230\178\161\230\156\137\229\138\160\229\133\165\232\175\173\233\159\179\233\162\145\233\129\147",
    [-14] = "\232\175\173\233\159\179\230\156\141\229\138\161\228\184\141\229\143\175\231\148\168",
    [-15] = "\231\189\145\231\187\156\233\148\153\232\175\175",
    [-16] = "\230\156\141\229\138\161\229\153\168\229\134\133\233\131\168\233\148\153\232\175\175",
    [-17] = "\229\143\130\230\149\176\233\148\153\232\175\175",
    [-18] = "\229\191\131\232\183\179\230\150\173\229\188\128",
    [-19] = "\229\189\149\233\159\179\230\168\161\229\157\151\229\136\157\229\167\139\229\140\150\229\164\177\232\180\165",
    [-20] = "\230\178\161\230\156\137\229\189\149\233\159\179\230\157\131\233\153\144",
    [-21] = "\232\153\189\231\132\182\229\136\157\229\167\139\229\140\150\230\136\144\229\138\159\239\188\140\228\189\134\230\178\161\230\156\137\233\159\179\233\162\145\230\149\176\230\141\174\232\190\147\229\135\186\239\188\140\230\175\148\229\166\130oppo\231\179\187\229\136\151\230\137\139\230\156\186\229\156\168\229\189\149\233\159\179\230\157\131\233\153\144\232\162\171\231\166\129\230\173\162\231\154\132\230\151\182\229\128\153",
    [-22] = "\229\133\182\228\187\150\229\189\149\233\159\179\230\168\161\229\157\151\231\154\132\233\148\153\232\175\175",
    [-23] = "\229\189\149\233\159\179\230\157\131\233\153\144\230\156\170\231\161\174\229\174\154\239\188\140iOS\230\152\190\231\164\186\230\152\175\229\144\166\229\133\129\232\174\184\229\189\149\233\159\179\230\157\131\233\153\144\229\175\185\232\175\157\230\161\134\230\151\182\239\188\140\232\191\148\229\155\158\231\154\132\230\152\175\232\191\153\228\184\170\233\148\153\232\175\175\231\160\129",
    [-24] = "\230\173\163\229\156\168\228\189\191\231\148\168\231\154\132SDK\228\184\141\230\148\175\230\140\129\231\137\185\229\174\154\231\154\132API",
    [-25] = "\229\134\133\229\173\152\228\184\141\229\164\159\231\148\168",
    [-1000] = "\230\156\170\231\159\165\233\148\153\232\175\175"
  }
  local ret = codetbl[code or -1000]
  if ret == nil then
    return "undefined error"
  else
    return ret
  end
end

function VoiceTalk.WaitForJoinChannel(userid, roomid)
  pendingUserid = userid
  pendingRoomid = roomid
end

function VoiceTalk.inited()
  return yTalkInstance ~= nil
end

function VoiceTalk.inChannel()
  return inChannel
end

function VoiceTalk.registerInitHandler(func)
  if func and voiceInitHandlers then
    table.insert(voiceInitHandlers, func)
  end
end

function VoiceTalk.init(AppId, AppKey)
  youmeAppId = AppId or "YOUME077C7C43556DA87838E092BF910B1312AC58DD68"
  youmeAppKey = AppKey or "xmPuDFKrKrDeizTfPqb9TJxtm6iNYk8ypAxDo8XXLZlSIWJlhdqQG1ju2MbO1TUMNv73E45TP2bK9xUg1zU3NK6l7sD1yWOISGPZHlj3GMJz2hPAONCpvGWzWi57RHO1pMJkY/DrBbWddwy81i3hck+JIS9EL7jPQgEFG/lum/sBAAE="
  yTalkInstance = cc.YTalk:create()
  
  function yTalkInstance.OnInit(eventType, errcode)
    if eventType == 0 and errcode == 0 then
      for k, handler in pairs(voiceInitHandlers or {}) do
        voiceInitHandlers[k]()
        voiceInitHandlers[k] = nil
      end
      print("YOUME_OnInit Ok: event:" .. eventType .. "  code:" .. errcode)
    else
      local eventTypeTbl = {
        [0] = "SDK\233\170\140\232\175\129\230\136\144\229\138\159",
        [1] = "SDK\233\170\140\232\175\129\229\164\177\232\180\165"
      }
      print(string.format("YOUME_OnInit with error:%s  %d  %s", eventTypeTbl[eventType], errcode, toExpan(errcode)))
    end
  end
  
  function yTalkInstance.OnCall(eventType, errcode)
    if eventType == 3 then
      print("YOUME_OnCall: event: \229\138\160\229\133\165\232\175\173\233\159\179\233\162\145\233\129\147\230\136\144\229\138\159" .. "  code:" .. errcode)
      VoiceTalk.MuteSpeaker(false)
      VoiceTalk.MuteMicrophone(false)
      VoiceTalk.setVolume(100)
      for k, handler in pairs(joinChannelHandlers or {}) do
        joinChannelHandlers[k]()
        joinChannelHandlers[k] = nil
      end
      inChannel = true
    elseif eventType == 5 then
      print("YOUME_OnCall: event: \231\166\187\229\188\128\230\136\191\233\151\180\230\136\144\229\138\159\239\188\140\230\136\150\230\150\173\231\189\145\233\135\141\232\191\158\229\164\177\232\180\165" .. "  code:" .. errcode)
      if pendingUserid and pendingRoomid then
        VoiceTalk.JoinChannel(pendingUserid, pendingRoomid)
        currentUserid = pendingUserid
        currentRoomid = pendingRoomid
        pendingUserid = nil
        pendingRoomid = nil
      end
      for k, handler in pairs(exitChannelHandlers or {}) do
        exitChannelHandlers[k]()
        exitChannelHandlers[k] = nil
      end
      inChannel = false
    elseif eventType == 7 then
      print("YOUME_OnCall: event: \233\128\154\231\159\165\229\189\149\233\159\179\229\164\177\232\180\165" .. "  code:" .. errcode)
    else
      print("YOUME_OnCall: event:" .. eventType .. "  code:" .. errcode)
    end
    print(string.format("YOUME_OnCall with error:%s  %d  %s", eventType, errcode, toExpan(errcode)))
  end
  
  function yTalkInstance.OnCommonStatus(eventType, userID, status)
    if eventType == 0 then
      print(string.format("YOUME_OnCommonStatus \230\136\144\229\145\152\233\186\166\229\133\139\233\163\142\231\138\182\230\128\129 userID:%s  status:%s", eventType, userID, status))
    elseif eventType == 1 then
      print(string.format("YOUME_OnCommonStatus \230\136\144\229\145\152\230\137\172\229\163\176\229\153\168\231\138\182\230\128\129 userID:%s  status:%s", eventType, userID, status))
    else
      print(string.format("YOUME_OnCommonStatus with :event:%s  userID:%s  status:%s", eventType, userID, status))
    end
  end
  
  function yTalkInstance.OnMemberChange(userIDs)
    print(string.format("YOUME_OnCommonStatus with error: userID:%s", userIDs))
    print("YOUME_OnMemberChange: userIDs:" .. userIDs)
  end
  
  yTalkInstance:registerScriptHandler(yTalkInstance.OnInit, yTalkInstance.OnCall, yTalkInstance.OnCommonStatus, yTalkInstance.OnMemberChange)
  VoiceTalk.initKey()
end

function VoiceTalk.initKey()
  local ierrorcode = yTalkInstance:init(youmeAppId, youmeAppKey)
  print("YOUME\229\136\157\229\167\139\229\140\150Key\231\138\182\230\128\129:" .. ierrorcode)
end

function VoiceTalk.unInit()
  if yTalkInstance == nil then
    return
  end
  yTalkInstance:UnInit()
end

function VoiceTalk.JoinChannel(username, channel)
  if yTalkInstance == nil then
    return
  end
  print(string.format("%s user try to enter channel :%s ", username, channel))
  local ierrorcode2 = yTalkInstance:joinConference2(username, channel, true, true, true, true)
  if ierrorcode2 == 0 then
    print("joinConference2: succeed!" .. ierrorcode2)
  else
    print("joinConference2: failed:" .. ierrorcode2 .. toExpan(ierrorcode2))
  end
end

function VoiceTalk.ExitChannel(channel)
  if yTalkInstance == nil then
    return
  end
  local exitcode = yTalkInstance:leaveConference(channel or "")
  if exitcode == 0 then
    print("exit conference succeed!")
  else
    print("exit conference failed!")
  end
  return exitcode
end

function VoiceTalk.MuteSpeaker(mute)
  if yTalkInstance == nil then
    return
  end
  yTalkInstance:setSpeakerMute(mute)
  if not mute then
    yTalkInstance:setVolume(100)
  end
end

function VoiceTalk.MuteMicrophone(mute)
  if yTalkInstance == nil then
    return
  end
  yTalkInstance:setMicrophoneMute(mute)
end

function VoiceTalk.setVolume(volume)
  if yTalkInstance == nil then
    return
  end
  yTalkInstance:setVolume(volume)
end

function VoiceTalk.GetVolume()
  if yTalkInstance == nil then
    return
  end
  return yTalkInstance:GetVolume()
end

function VoiceTalk.GetUseMobileNetworkEnabled()
  if yTalkInstance == nil then
    return
  end
  yTalkInstance:getUseMobileNetworkEnabled()
end

function VoiceTalk.SetUseMobileNetworkEnabled(isOn)
  if yTalkInstance == nil then
    return
  end
  yTalkInstance:setUseMobileNetworkEnabled(isOn)
end

function VoiceTalk.GetMicrophoneMute()
  if yTalkInstance == nil then
    return
  end
  return yTalkInstance:getMicrophoneMute()
end

function VoiceTalk.PauseConference()
  if yTalkInstance == nil then
    return
  end
  return yTalkInstance:pauseConference()
end

function VoiceTalk.ResumeConference()
  if yTalkInstance == nil then
    return
  end
  return yTalkInstance:resumeConference()
end

function VoiceTalk.TryJoinConference(username, roomid, handler)
  if yTalkInstance == nil then
    return
  end
  local exitCode = VoiceTalk.ExitChannel("")
  if exitCode == 0 then
    VoiceTalk.WaitForJoinChannel(username, roomid)
  else
    VoiceTalk.JoinChannel(username, roomid)
  end
  if handler and joinChannelHandlers then
    table.insert(joinChannelHandlers, handler)
  end
  if EDFLAGWIN32 then
    currentUserid = username
    currentRoomid = roomid
    for k, handler in pairs(joinChannelHandlers or {}) do
      joinChannelHandlers[k]()
      joinChannelHandlers[k] = nil
    end
  end
end

function VoiceTalk.ShutDownConference(handler)
  if yTalkInstance == nil then
    return
  end
  if currentRoomid then
    VoiceTalk.ExitChannel(currentRoomid)
  else
    VoiceTalk.ExitChannel("")
  end
  currentUserid = nil
  currentRoomid = nil
  if handler and exitChannelHandlers then
    table.insert(exitChannelHandlers, handler)
  end
end

function VoiceTalk.applicationWillEnterForeground()
  if yTalkInstance == nil then
    return
  end
  if not currentUserid or not currentRoomid then
    return
  end
  VoiceTalk.ResumeConference()
end

function VoiceTalk.applicationDidEnterBackground()
  if yTalkInstance == nil then
    return
  end
  if not currentRoomid then
    return
  end
  VoiceTalk.PauseConference()
end
