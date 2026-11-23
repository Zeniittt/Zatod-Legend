local authenticationNet = {}
authenticationNet.__index = authenticationNet
local printData = false
local instance

function authenticationNet.getInstance()
  if not instance then
    instance = authenticationNet.create()
  end
  return instance
end

function authenticationNet.create()
  local net = {}
  setmetatable(net, authenticationNet)
  return net
end

function authenticationNet:dispatch(data)
  if printData then
    print("----------------authenticationNet:dispatch-------------------")
    ed.pt(data)
  end
  if data._open_panel_reply then
    ed.authenticationMgr:handleOpenPanel(data._open_panel_reply)
  elseif data._server_list_reply then
    FireEvent("PlayerShiftServerReply", data._server_list_reply._server_list)
  elseif data._select_server_reply then
    FireEvent("PlayerShiftSelectServerReply", data._select_server_reply._server_info)
  elseif data._send_code_reply then
    FireEvent("PlayerShiftGetCodeReply", data._send_code_reply._result)
  elseif data._auth_code_reply then
    FireEvent("PlayerShiftAuthCodeReply", data._auth_code_reply)
  elseif data._gain_reward_reply then
    FireEvent("PlayerShiftGainRewardReply", data._gain_reward_reply)
  end
end

function authenticationNet:createReq()
  local req = ed.upmsg.player_shift_req()
  return req
end

function authenticationNet:doReq(req)
  if printData then
    print("-------------authenticationNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "player_shift")
end

function authenticationNet:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = ed.upmsg.player_shift_open_panel()
  self:doReq(req)
end

function authenticationNet:sendServerList(zone)
  local req = self:createReq()
  req._server_list = ed.upmsg.player_shift_server_list()
  req._server_list._zone = zone
  self:doReq(req)
end

function authenticationNet:sendSelectServer(serverId)
  local req = self:createReq()
  req._select_server = ed.upmsg.player_shift_select_server()
  req._select_server._server_id = serverId
  self:doReq(req)
end

function authenticationNet:sendGetCode(userId)
  local req = self:createReq()
  req._send_code = ed.upmsg.player_shift_send_code()
  req._send_code._user_id = userId
  self:doReq(req)
end

function authenticationNet:sendAuthCode(code)
  local req = self:createReq()
  req._auth_code = ed.upmsg.player_shift_auth_code()
  req._auth_code._code = code
  self:doReq(req)
end

function authenticationNet:sendGainReward()
  local req = self:createReq()
  req._gain_reward = ed.upmsg.player_shift_gain_reward()
  self:doReq(req)
end

ed.authenticationNet = authenticationNet.getInstance()
