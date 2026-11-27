module("sdkLogin", package.seeall)
loginPanel = nil
loginLogic = {}
scope = nil
success = "success"
faild = "faild"
sdk_id = "sdk_id"
loginMode = "old"
loginType = "loginType"
lastLoginAccount = nil
deviceIdList = {}
isInitLastAccount = false
loginDeviceId = ""
loginToken = ""
loginPhone = ""

local function changeViewState(blogin, bregister)
  loginPanel.loginLayer:setVisible(blogin)
  loginPanel.registerLayer:setVisible(bregister)
end

local function checkPhoneValid(phone)
  if phone == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\137\139\230\156\186\229\143\183"))
    return false
  end
  if not tonumber(phone) or string.len(phone) ~= 11 then
    ed.showToast(T("\230\137\139\230\156\186\230\160\188\229\188\143\228\184\141\229\175\185\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
    return false
  end
  return true
end

local function checkLoginPhoneValid()
  local phone = loginPanel.loginLayer.phoneNumEdit:getString()
  return checkPhoneValid(phone)
end

local function checkRegisterPhoneValid(id)
  local phone = id or loginPanel.registerLayer.phoneNumEdit:getString()
  return checkPhoneValid(phone)
end

function loginLogic.setPhone(phone)
  loginPhone = phone
end

function loginLogic.getPhone()
  return loginPhone
end

function loginLogic.setDeviceId(id)
  loginDeviceId = id
end

function loginLogic.setToken(token)
  loginToken = token
end

function loginLogic.getDeviceId()
  return loginDeviceId
end

function loginLogic.getToken()
  return loginToken
end

function loginLogic.requestAccountList()
  NetWork:requestAccountList()
end

function loginLogic.registerLocalAccount()
  if not loginPanel then
    return
  end
  local id = loginPanel.loginLayer.phoneNumEdit:getString()
  ed.storage.setValue(sdk_id, id)
end

function loginLogic.getLocalAccount()
  local uid = ed.storage.getString(sdk_id)
  return uid
end

function loginLogic.setDefaultAccount(phone, pwd)
  if phone then
    loginPanel.loginLayer.phoneNumEdit:setString(phone)
  end
end

local function initPanel()
  changeViewState(true, false)
  local phone = loginLogic.getLocalAccount()
  loginLogic.setDefaultAccount(phone)
end

local function checkPWDValid()
  local secret = loginPanel.loginLayer.secretEdit:getString()
  if secret == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\229\175\134\231\160\129"))
    return false
  end
  return true
end

local function checkUserInfoValid()
  if not checkLoginPhoneValid() then
    return
  end
  if not checkPWDValid() then
    return
  end
  return true
end

local function exit()
  loginPanel:getRootLayer():removeFromParentAndCleanup(true)
  loginPanel = nil
  CloseScope(scope)
end

function loginLogic.initLastLoginAccount(msg)
  if not msg then
    return
  end
  local temp = {
    _user_summary = {
      _avatar = msg.avatar,
      _name = msg.name,
      _vip = msg.vip,
      _uid = msg.user_id,
      _level = msg.level
    },
    _server_name = msg.svr_name,
    _device_id = msg.device_id,
    _svr_id = msg.svr_id
  }
  if not isInitLastAccount then
    FireEvent("syneLastLoginAccount", msg)
  end
  FireEvent("changeAccount", temp)
  isInitLastAccount = true
end

function loginLogic.getLastLoginAccount()
  return lastLoginAccount
end

function loginLogic.hasLastLogionAccount()
  return loginLogic.getLastLoginAccount()
end

function loginLogic.isLastLoginAccount(deviceid, severid)
  local account = loginLogic.getLastLoginAccount()
  if not account then
    return false
  end
  return deviceid == account.device_id and severid == account.svr_id
end

function loginLogic.saveDeviceIdList(fetch)
  if fetch.device then
    deviceIdList = fetch.device
  end
end

function loginLogic.getDeviceIdList()
  return deviceIdList
end

function loginLogic.refreshCurrentServerInfo()
  if lastLoginAccount then
    local id = lastLoginAccount.svr_id
    local name = lastLoginAccount.svr_name
    local ip = lastLoginAccount.svr_ip
    local port = lastLoginAccount.svr_port
    local param = {
      id = id,
      name = name,
      ip = ip,
      port = port
    }
    ed.ui.serverlogin.addServer(param)
    FireEvent("refreshCurrentServerInfo", name)
  end
end

function loginLogic.initDefaultDeviceId(msg)
  local list = msg.fetch_reply.device
  for k, device in ipairs(list) do
    if not string.find(device, "mobile") then
      return device
    end
  end
  return list[1]
end

local function onLoginReply(msg)
  loginLogic.registerLocalAccount()
  lastLoginAccount = msg.account
  local device_id = msg.account and msg.account.device_id or loginLogic.initDefaultDeviceId(msg)
  if not EDFLAGWIN32 then
    FireEvent("SDKLogin", "success", msg.token, device_id)
  end
  loginLogic.refreshCurrentServerInfo()
  loginLogic.initLastLoginAccount(lastLoginAccount)
  loginLogic.saveDeviceIdList(msg.fetch_reply)
  loginLogic.setDeviceId(device_id)
  loginLogic.setToken(msg.token)
  local phone = loginPanel.loginLayer.phoneNumEdit:getString()
  loginLogic.setPhone(phone)
  exit()
end

function loginLogic.onLogin()
  if not checkUserInfoValid() then
    return
  end
  print("onLogin")
  local uid = loginPanel.loginLayer.phoneNumEdit:getString()
  local pwd = loginPanel.loginLayer.secretEdit:getString()
  pwd = loginLogic.md5(pwd)
  NetWork:onLogin(uid, pwd)
end

function loginLogic.onRegister()
  changeViewState(false, true)
end

function loginLogic.onRequestKey()
  print("requestKey")
  local id = loginPanel.registerLayer.phoneNumEdit:getString()
  if not checkRegisterPhoneValid(id) then
    return false
  end
  local getKey = loginPanel.registerLayer.getKey
  getKey:enable(false)
  ListenTimer(Timer:Once(30), function()
    getKey:enable(true)
  end, scope)
  NetWork:onRequestKey(id)
end

function loginLogic.RegisterReply(msg)
  local regiseter = loginPanel.registerLayer
  local phone = regiseter.phoneNumEdit:getString()
  loginLogic.setDefaultAccount(phone)
  regiseter.keyEdit:setString(" ")
  regiseter.phoneNumEdit:setString(" ")
  regiseter.sercretEdit:setString(" ")
  changeViewState(true, false)
end

local function checkKeyValid()
  local secret = loginPanel.registerLayer.keyEdit:getString()
  if secret == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\233\170\140\232\175\129\231\160\129"))
    return false
  end
  return true
end

local function checkRegisterInfoValid()
  local id = loginPanel.registerLayer.phoneNumEdit:getString()
  if id == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\137\139\230\156\186\229\143\183"))
    return false
  end
  local id = loginPanel.registerLayer.sercretEdit:getString()
  if id == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\229\175\134\231\160\129"))
    return false
  end
  if not checkKeyValid() then
    return false
  end
  return true
end

function loginLogic.onCancel()
  changeViewState(true, false)
end

function loginLogic.md5(num)
  local pwd = md5.sum(num)
  pwd = string.gsub(pwd, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
  return pwd
end

function loginLogic.onConfirm()
  print("onConfirm")
  if not checkRegisterInfoValid() then
    return
  end
  local panel = loginPanel.registerLayer
  local key = panel.keyEdit:getString()
  local phone = panel.phoneNumEdit:getString()
  local pwd = panel.sercretEdit:getString()
  pwd = loginLogic.md5(pwd)
  NetWork:Register(phone, key, pwd)
end

function initLoginMode()
  local type = ed.storage.getString(T("%s-%s", EDSDKType, loginType))
  EDLog("login type :: " .. type)
  if type ~= "" then
    loginMode = type
  end
end

function setLoginMode(mode)
  loginMode = mode
  EDLog("setLoginMode :: " .. mode)
  ed.storage.setValue(T("%s-%s", EDSDKType, loginType), loginMode)
  if mode == "openllh" and EDOpenLLHSYS then
    EDOpenLLHSYS(1)
  end
  if mode == "new" then
    ed.ui.serverlogin.rewriteSDKFunc()
  end
end

function getLoginMode()
  return loginMode
end

function isNewLoginMode()
  return loginMode == "new"
end

function showSDKUI(parent)
  if loginMode == "openllh" then
    local function doBindFunc()
      local hasNotBind = accSystem.BindAccountMgr.getInstance():hasAccontNotBinded()
      
      if EDSetLLHBindState then
        EDSetLLHBindState(hasNotBind)
      end
      local accData = accSystem.BindAccountMgr.getInstance():getAccounts() or {}
      if #accData == 0 or accSystem.BindAccountMgr.getInstance():hasAccontBinded() then
        EDSDKLogin()
      elseif parent then
        parent:addChild(accSystem.BindAccount:create().mainLayer, 500)
      end
    end
    
    local function opneBindAcc()
      if parent then
        parent:addChild(accSystem.BindAccount:create().mainLayer, 500)
      end
    end
    
    ListenEvent("OpenBindAccount", opneBindAcc, scope)
    ListenEvent("IDFAQueryReply", doBindFunc, scope)
    accSystem.NetWork:init()
    return
  end
  if loginMode ~= "new" then
    return
  end
  scope = {}
  if loginPanel == nil then
    loginPanel = panelMeta:new2(loginLogic, EDTables.sdkConfig.UIRes)
    ListenEvent("sdkLoginReply", function(msg)
      onLoginReply(msg)
    end, scope)
    ListenEvent("sdkRegisterReply", function(msg)
      loginLogic.RegisterReply(msg)
    end, scope)
  end
  NetWork:init()
  if parent then
    parent:addChild(loginPanel:getRootLayer(), 500)
  end
  initPanel()
end
