local versionChangeView = ed.ui.versionChangeView

function versionChangeView:popWindow()
  ed.showAlertDialog({
    text = EDGetVersionName and EDGetVersionName() or "1.0.300761",
    buttonText = T("\231\161\174\229\174\154")
  })
end

local serviceSettingWin = ed.ui.serviceSettingWin

function serviceSettingWin:init()
  self.serviceSettingOption[7].show = false
  self.serviceSettingOption[8].click = function()
    ed.showToast(T("\232\175\183\230\156\159\229\190\133\229\164\167\228\188\154\229\145\152\229\138\159\232\131\189\229\188\128\230\148\190\239\188\129"))
  end
  self:initView()
  self:addEventListener()
end

local bottomButtons = ed.ui.playerInfoWindow.bottomButtons
bottomButtons[2].visible = false
local serverLogin = ed.ui.serverlogin
local old_initServer = serverLogin.initServer

function serverLogin:initServer()
  EDLog("Init Tishen Server")
  ed.storage.setValue(tostring(EDSDKType) .. "lastserverinfo", "")
  old_initServer(self)
end

function ed.ui.serverlogin.selectServer()
  ed.ui.serverlogin.showAllServerInfo()
end

account_svr_ip = "47.102.123.216"
account_svr_port = "8989"
return {
  {
    id = "21001",
    name = "\230\143\144\229\174\161\230\156\141",
    ip = "47.103.53.169",
    port = 10000,
    state = "\230\142\168\232\141\144",
    color = 15882506
  }
}
