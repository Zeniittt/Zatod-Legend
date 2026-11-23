module("accSystem", package.seeall)
BindAccountMgr = {}
local instance

function BindAccountMgr.getInstance()
  if instance == nil then
    instance = BindAccountMgr.create()
  end
  return instance
end

function BindAccountMgr.create()
  local self = {
    accounts = {},
    acc_server = {
      ip = "192.168.1.102",
      port = 8989
    }
  }
  setmetatable(self, BindAccountMgr)
  BindAccountMgr.__index = BindAccountMgr
  instance = self
  return self
end

function BindAccountMgr:getOpenIDFA()
  local idfa = EDGetParam("openIDFA") or ""
  if EDFLAGWIN32 then
    idfa = "0000-0000-0000-0000"
  end
  return idfa
end

function BindAccountMgr:setAccountServer(msg)
  if msg.svr_ip then
    self.acc_server.ip = msg.svr_ip
    self.acc_server.port = msg.svr_port
  end
end

function BindAccountMgr:getAccountServer()
  return self.acc_server
end

function BindAccountMgr:setAccounts(data)
  self.accounts = data
end

function BindAccountMgr:getAccounts()
  local function sortFunc(a, b)
    return a.last_login > b.last_login
  end
  
  table.sort(self.accounts, sortFunc)
  return self.accounts
end

function BindAccountMgr:updateAccountBindStatus(state)
end

function BindAccountMgr:getAccountByUin(uin)
  for _, v in pairs(self.accounts) do
    if v.uin == uin then
      return v
    end
  end
end

function BindAccountMgr:getRolesByUin(uin)
  local roles = {}
  for _, v in pairs(self.accounts) do
    if v.uin == uin then
      roles = v.accounts
    end
  end
  return roles
end

function BindAccountMgr:hasAccontBinded()
  for _, acc in pairs(self.accounts) do
    if acc.bind_status == "bind_status_already" then
      return true
    end
  end
  return false
end

function BindAccountMgr:hasAccontNotBinded()
  for _, acc in pairs(self.accounts) do
    if acc.bind_status == "bind_status_none" then
      return true
    end
  end
  return false
end

function BindAccountMgr:setSelectedUin(uin)
  self.selectedUin = uin
end

function BindAccountMgr:getSelectedUin()
  return self.selectedUin
end
