module("accSystem", package.seeall)
NetWork = {}
NetWork.__index = NetWork
local acconutscope = {}

function NetWork:release()
  CloseScope(acconutscope)
end

function NetWork:init()
  local server = BindAccountMgr.getInstance():getAccountServer()
  genericNetwork.socketConnection:setServerIpAndPort(server)
  local connect = genericNetwork.connectionManager:getConnection(genericNetwork.NetMode.accsystem)
  self.proto = connect:getUpCsproto()
  self:RegisterListenEvent()
end

function NetWork:send(obj, type)
  print("network send: ", type)
  local server = BindAccountMgr.getInstance():getAccountServer()
  genericNetwork.socketConnection:setServerIpAndPort(server)
  local connect = genericNetwork.connectionManager:getConnection(genericNetwork.NetMode.accsystem)
  connect:send(obj, type)
end

function NetWork:onIDFAQuery()
  local msg = self.proto.idfa_query()
  msg.open_idfa = BindAccountMgr.getInstance():getOpenIDFA()
  print("-----------------------msg.open_idfa", msg.open_idfa)
  msg.plat_id = EDSDKType
  print("-----------------------EDSDKType:", EDSDKType)
  self:send(msg, "idfa_query")
end

function NetWork:onIDFABind()
  local msg = self.proto.idfa_bind()
  msg.open_idfa = EDGetParam("openIDFA") or ""
  msg.uin_new = EDGetParam("uin") or ""
  msg.uin_old = EDGetParam("uin") or ""
  self:send(msg, "idfa_bind")
end

function NetWork:onIDFAQueryReply(msg)
  ed.printTable(msg)
  BindAccountMgr.getInstance():setAccounts(msg.idfa_accounts)
  FireEvent("IDFAQueryReply")
end

function NetWork:onIDFABindRely(msg)
  ed.printTable(msg)
  BindAccountMgr.getInstance():updateAccountBindStatus(msg)
  FireEvent("IDFABindReply")
end

function NetWork:RegisterListenEvent()
  if self.isRegister then
    return
  end
  self.isRegister = true
  ListenEvent("idfa_query_reply", function(msg)
    self:onIDFAQueryReply(msg)
  end, acconutscope)
  ListenEvent("idfa_bind_reply", function(msg)
    self:onIDFABindRely(msg)
  end, acconutscope)
end
