module("sdkLogin", package.seeall)
globalScope = {}
NetWork = {}
NetWork.__index = NetWork
success = 0
proto = nil
scope = {}
codehandler = {
  T("\230\179\168\229\134\140\230\136\144\229\138\159"),
  T("\229\143\130\230\149\176\233\148\153\232\175\175"),
  T("\230\156\170\231\159\165\230\147\141\228\189\156"),
  T("\233\170\140\232\175\129\231\160\129\233\148\153\232\175\175"),
  T("\230\156\141\229\138\161\229\153\168\229\191\153\239\188\140\232\175\183\231\168\141\229\128\153\229\134\141\232\175\149"),
  T("\230\156\141\229\138\161\230\178\161\230\156\137\229\174\158\231\142\176"),
  T("\229\175\134\231\160\129\228\184\141\229\140\185\233\133\141"),
  T("token\230\151\160\230\149\136"),
  T("\232\180\166\230\136\183\228\184\141\229\173\152\229\156\168")
}

function NetWork:send(obj, type)
  print("network send :: ", type)
  local connect = genericNetwork.connectionManager:getConnection(genericNetwork.NetMode.sdklogin)
  connect:send(obj, type)
end

function NetWork:onLogin(phone, pwd)
  local msg = proto.login()
  msg.tel = phone
  msg.passwd = pwd
  msg.plat = tostring(EDSDKType)
  self:send(msg, "login")
end

function NetWork:onLoginReply(msg)
  if msg.rslt == success then
    FireEvent("sdkLoginReply", msg)
    ed.showToast(T("\231\153\187\233\153\134\230\136\144\229\138\159"))
  elseif codehandler[msg.rslt] then
    ed.showToast(codehandler[msg.rslt])
  end
end

function NetWork:onRequestKey(phone)
  local msg = proto.prepare()
  msg.tel = phone
  self:send(msg, "prepare")
end

function NetWork:onRequestKeyRely(msg)
  if msg.rslt == success then
    ed.showToast(T("\233\170\140\232\175\129\231\160\129\229\183\178\229\143\145\233\128\129\239\188\140\232\175\183\230\179\168\230\132\143\230\159\165\230\148\182"))
  elseif codehandler[msg.rslt] then
    ed.showToast(codehandler[msg.rslt])
  end
end

function NetWork:Register(phone, key, pwd)
  local msg = proto.create()
  msg.tel = phone
  msg.passwd = pwd
  msg.code = key
  self:send(msg, "create")
end

function NetWork:RegisterReply(msg)
  if msg.rslt == success then
    ed.showToast(T("\230\179\168\229\134\140\230\136\144\229\138\159"))
    FireEvent("sdkRegisterReply", msg)
  elseif codehandler[msg.rslt] then
    ed.showToast(codehandler[msg.rslt])
  end
end

function NetWork:requestAccountListReply(serverList, accountList)
  sdkLogin.ChangeAccount:create(serverList, accountList)
end

function NetWork:reportLoginAccount()
  local msg = proto.report_login_account()
  msg.avatar = ed.player:getAvatar()
  msg.name = ed.player:getName()
  msg.vip = ed.player:getvip()
  msg.level = ed.player:getLevel()
  msg.svr_name = game_server_name
  msg.user_id = tostring(ed.getUserid())
  msg.svr_id = tostring(game_server_id)
  if EDFLAGWIN32 then
    msg.device_id = ed.getDeviceId()
  else
    msg.device_id = string.format("%d-%s", EDSDKType, ed.getDeviceId())
  end
  msg.svr_ip = game_server_ip
  msg.svr_port = tostring(game_server_port)
  msg.tel = sdkLogin.loginLogic.getPhone()
  msg.token = sdkLogin.loginLogic.getToken()
  self:send(msg, "report_login_account")
end

function NetWork:reportLoginAccountReply(msg)
  if msg.rslt == success then
    CloseScope(scope)
    EDLog("report success")
  else
    ListenTimer(Timer:Always(300), function()
      self:reportLoginAccount()
    end, scope)
    EDLog(msg.msg)
  end
end

function NetWork:RegisterListenEvent()
  if self.isRegister then
    return
  end
  self.isRegister = true
  ListenEvent("login_reply", function(msg)
    self:onLoginReply(msg)
  end, globalScope)
  ListenEvent("prepare_reply", function(msg)
    self:onRequestKeyRely(msg)
  end, globalScope)
  ListenEvent("create_reply", function(msg)
    self:RegisterReply(msg)
  end, globalScope)
  ListenEvent("report_login_account_reply", function(msg)
    self:reportLoginAccountReply(msg)
  end, globalScope)
  ListenEvent("requestAccountListReply", function(serverList, accountList)
    self:requestAccountListReply(serverList, accountList)
  end, globalScope)
end

function NetWork:init()
  local connect = genericNetwork.connectionManager:getConnection(genericNetwork.NetMode.sdklogin)
  proto = connect:getUpCsproto()
  self:RegisterListenEvent()
end

function NetWork:release()
  CloseScope(globalScope)
end
