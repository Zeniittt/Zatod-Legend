local UploadImageNetwork = {}
UploadImageNetwork.__index = UploadImageNetwork
local UploadImageNetworkScope = {}

function UploadImageNetwork.create()
  local net = {}
  setmetatable(net, UploadImageNetwork)
  net:registerEvent()
  return net
end

function UploadImageNetwork:registerEvent()
  ListenEvent("custom_photo_reply", function(replyInfo)
    self:dispatch(replyInfo)
  end, UploadImageNetworkScope)
end

function UploadImageNetwork:dispatch(data)
  if data._upload_token then
    local token = data._upload_token._token
    FireEvent("OnUploadToken", token)
  elseif data._set_photo then
    if data._set_photo == "success" then
      ed.player:setCustomPhoto(self.photoId, self.frameId, self.isOpen)
      FireEvent("refreshChatHead")
    end
  elseif data._report and data._report == "success" then
    ed.showToast(T("\228\184\190\230\138\165\230\136\144\229\138\159"))
  end
end

function UploadImageNetwork:getToken(bucket)
  local msg = ed.upmsg.custom_photo_req()
  msg._upload_token = ed.upmsg.cp_upload_token()
  msg._upload_token._bucket = bucket
  ed.send(msg, "custom_photo")
end

function UploadImageNetwork:setPhoto(photoId, frameId, isOpen)
  self.photoId = photoId
  self.frameId = frameId
  self.isOpen = isOpen
  local msg = ed.upmsg.custom_photo_req()
  msg._set_photo = ed.upmsg.cp_set_photo()
  msg._set_photo._photo = photoId
  msg._set_photo._frame_id = frameId
  msg._set_photo._open = isOpen and 1 or 0
  ed.send(msg, "custom_photo")
end

function UploadImageNetwork:reportPhoto(serverId, userId, deviceId)
  local msg = ed.upmsg.custom_photo_req()
  msg._report = ed.upmsg.cp_report()
  msg._report._svr_id = serverId
  msg._report._uid = userId
  msg._report._device_id = deviceId
  ed.send(msg, "custom_photo")
end

function UploadImageNetwork:muteUser(serverId, userId, barrage)
  local msg = ed.upmsg.outer_net_gm()
  msg._mute_user = ed.upmsg.ong_mute_user()
  msg._mute_user._user_key = ed.commonmsg.user_key()
  msg._mute_user._user_key._svr_id = serverId
  msg._mute_user._user_key._uid = userId
  msg._mute_user._content = barrage
  ed.send(msg, "outer_net_gm")
end

function UploadImageNetwork:shieldPhoto(serverId, userId)
  local msg = ed.upmsg.outer_net_gm()
  msg._photo_user = ed.upmsg.ban_photo_user()
  msg._photo_user._user_key = ed.commonmsg.user_key()
  msg._photo_user._user_key._svr_id = serverId
  msg._photo_user._user_key._uid = userId
  ed.send(msg, "outer_net_gm")
end

ed.UploadImageNetwork = UploadImageNetwork.create()
