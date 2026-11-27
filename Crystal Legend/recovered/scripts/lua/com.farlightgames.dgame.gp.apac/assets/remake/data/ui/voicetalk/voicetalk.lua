local voicetalk = {}
local voicetalkScope = {}
ed.voicetalk = voicetalk
voicetalk.__index = voicetalk
local uiMode = {pair_mode = 1, battle_mode = 2}
local instance

function voicetalk:getInstance()
  if instance then
    return instance
  else
    instance = voicetalk.create()
    return instance
  end
end

function voicetalk.create()
  local object = {}
  setmetatable(object, voicetalk)
  object:initData()
  object:regitserEventHandler()
  return object
end

function voicetalk:initData()
  self.voicetalk_openChannel = false
  self.voicetalk_roomid = nil
  self.noPartner = false
  self.speakerSwitch = false
  self.microphoneSwitch = false
end

function voicetalk:createVoiceTalkUI(param)
  self.touchNode = param.touchNode
  self.touchPriority = param.priority
  self.uimode = param.uimode
  self.handerList = {}
  self.mainLyaer, self.ui = ed.editorui(ed.uieditor.voicetalk)
  self:initUIMode()
  self:initUISwitch()
  self:registerToucher()
  return self.mainLyaer
end

function voicetalk:initUIMode()
  if self.uimode == uiMode.battle_mode then
    self.ui.image_speaker:setScale(0.6)
    self.ui.image_speaker_close:setScale(0.6)
    self.ui.image_microphone:setScale(0.6)
    self.ui.image_microphone_close:setScale(0.6)
    self.ui.image_speaker:setPosition(ccp(70, 380))
    self.ui.image_speaker_close:setPosition(ccp(70, 380))
    self.ui.image_microphone:setPosition(ccp(70, 345))
    self.ui.image_microphone_close:setPosition(ccp(70, 345))
  end
end

function voicetalk:initUISwitch()
  if self.speakerSwitch then
    self.ui.image_speaker:setVisible(true)
    self.ui.image_speaker_close:setVisible(false)
  else
    self.ui.image_speaker:setVisible(false)
    self.ui.image_speaker_close:setVisible(true)
  end
  if self.microphoneSwitch then
    self.ui.image_microphone:setVisible(true)
    self.ui.image_microphone_close:setVisible(false)
  else
    self.ui.image_microphone:setVisible(false)
    self.ui.image_microphone_close:setVisible(true)
  end
end

function voicetalk:registerToucher()
  self:registerBtn("image_speaker", function()
    self:closeSpeaker()
  end)
  self:registerOpenBtn("image_speaker", function()
    self:openSpeaker()
  end)
  self:registerBtn("image_microphone", function()
    self:closeMicorphone()
  end)
  self:registerOpenBtn("image_microphone", function()
    self:openMicorphone()
  end)
  if self.touchNode == ed.scene then
    self.touchNode:addMianLayerTouchHandler(self:getMainTouchHandler())
  else
    self.touchNode:btRegisterMainTouchHandler({
      key = "voicetalkHandler",
      handler = self:getMainTouchHandler(),
      priority = self.touchPriority
    })
  end
end

function voicetalk:registerBtn(button, callBack)
  local ispress = false
  
  local function hander(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui[button], x, y) and self.ui[button .. "_close"]:isVisible() == false and self.ui[button]:isVisible() == true then
        ispress = true
      else
        ispress = false
      end
    elseif event == "ended" and ed.containsPoint(self.ui[button], x, y) and ispress then
      callBack()
    end
  end
  
  table.insert(self.handerList, hander)
end

function voicetalk:registerOpenBtn(button, callBack)
  local ispress = false
  
  local function hander(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui[button .. "_close"], x, y) and self.ui[button]:isVisible() == false and self.ui[button .. "_close"]:isVisible() == true then
        ispress = true
      else
        ispress = false
      end
    elseif event == "ended" and ed.containsPoint(self.ui[button .. "_close"], x, y) and ispress then
      callBack()
    end
  end
  
  table.insert(self.handerList, hander)
end

function voicetalk:getMainTouchHandler()
  local function mainTouchHandler(event, x, y)
    for _, hander in ipairs(self.handerList) do
      hander(event, x, y)
    end
  end
  
  return mainTouchHandler
end

function voicetalk:openSpeaker()
  self.speakerSwitch = true
  local result, error = self:canVoicetalk()
  if result then
    self:doOpenSpeaker()
  else
    self:disposeError(error)
  end
end

function voicetalk:closeSpeaker()
  self.speakerSwitch = false
  local result, error = self:canVoicetalk()
  if result then
    self:doCloseSpeaker()
  else
    self:disposeError(error)
  end
end

function voicetalk:openMicorphone()
  self.microphoneSwitch = true
  local result, error = self:canVoicetalk()
  if result then
    self:doOpenMicorphone()
  else
    self:disposeError(error)
  end
end

function voicetalk:closeMicorphone()
  self.microphoneSwitch = false
  local result, error = self:canVoicetalk()
  if result then
    self:doCloseMicorphone()
  else
    self:disposeError(error)
  end
end

function voicetalk:doOpenSpeaker()
  EDLog("\230\137\147\229\188\128\230\137\172\229\163\176\229\153\168\239\188\129")
  self:initUISwitch()
  ed.Voice.VoiceTalk.MuteSpeaker(false)
end

function voicetalk:doCloseSpeaker()
  EDLog("\229\133\179\233\151\173\230\137\172\229\163\176\229\153\168\239\188\129")
  self:initUISwitch()
  ed.Voice.VoiceTalk.MuteSpeaker(true)
  self:doCloseMicorphone()
end

function voicetalk:doOpenMicorphone()
  EDLog("\230\137\147\229\188\128\233\186\166\229\133\139\233\163\142\239\188\129")
  self:initUISwitch()
  ed.Voice.VoiceTalk.MuteMicrophone(false)
  self:doOpenSpeaker()
end

function voicetalk:doCloseMicorphone()
  EDLog("\229\133\179\233\151\173\233\186\166\229\133\139\233\163\142\239\188\129")
  self:initUISwitch()
  ed.Voice.VoiceTalk.MuteMicrophone(true)
end

function voicetalk:canVoicetalk()
  if not ed.openVoicetalk then
    return false, "notOpen"
  elseif self.noPartner then
    return false, "noPartner"
  elseif not self.voicetalk_openChannel then
    return false, "notEnterRoom"
  end
  return true
end

function voicetalk:disposeError(error)
  if error == "notOpen" then
    ed.showToast(T("\229\189\147\229\137\141\231\137\136\230\156\172\228\184\141\230\148\175\230\140\129\232\175\173\233\159\179"))
  elseif error == "noPartner" then
    ed.showToast(T("\233\152\159\229\143\139\230\184\184\230\136\143\231\137\136\230\156\172\232\191\135\228\189\142\239\188\140\228\184\141\230\148\175\230\140\129\232\175\173\233\159\179"))
  elseif error == "notEnterRoom" then
    self:joinConference()
  end
end

function voicetalk:joinConference()
  local userid = ed.getUserUniquenStr()
  if self.voicetalk_roomid and userid then
    ed.Voice.VoiceTalk.TryJoinConference(userid, self.voicetalk_roomid, function()
      self:handlerOfJoinConference()
    end)
  else
    ed.showToast(T("\229\189\147\229\137\141\231\137\136\230\156\172\228\184\141\230\148\175\230\140\129\232\175\173\233\159\179"))
  end
end

function voicetalk:handlerOfJoinConference()
  self.voicetalk_openChannel = true
  if self.speakerSwitch then
    self:openSpeaker()
  end
  if self.microphoneSwitch then
    self:openMicorphone()
  end
end

function voicetalk:openVoicetalk(partners)
  local partnersMsg = {}
  for _, p in ipairs(partners or {}) do
    local partnerMsg = ed.upmsg.partner_info()
    partnerMsg.partner_svr_id = p._svr_id
    partnerMsg.partner_uid = p._uid
    table.insert(partnersMsg, partnerMsg)
  end
  local msg = ed.upmsg.voice_room()
  msg._request_start = ed.upmsg.voice_room_request_start()
  msg._request_start._partner_info = partnersMsg
  EDLog("voicetalk openVoicetalk msg:" .. tostring(msg))
  ed.send(msg, "voice_room")
end

function voicetalk:regitserEventHandler()
  ListenEvent("voice_room_joinchannel", function(data)
    if data._request_start_reply == 2 then
      self.voicetalk_roomid = data._channel_id
      self.voicetalk_openChannel = false
    elseif data._request_start_reply == 1 then
      EDLog("My team member can't use voice")
      self.noPartner = true
    elseif data._request_start_reply == 0 then
    end
  end, voicetalkScope)
end

function voicetalk:closeVoicetalk()
  EDLog("================== ShutDownConference ===================")
  ed.Voice.VoiceTalk.ShutDownConference()
  self.voicetalk_openChannel = false
  self.voicetalk_roomid = nil
  self.noPartner = false
  self.speakerSwitch = false
  self.microphoneSwitch = false
end
