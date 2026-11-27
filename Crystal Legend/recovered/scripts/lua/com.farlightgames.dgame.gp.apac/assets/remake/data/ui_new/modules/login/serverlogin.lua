local serverLogin = {}
serverLogin.__index = serverLogin
local base = ed.ui.basescene
setmetatable(serverLogin, base.mt)
ed.ui.serverlogin = serverLogin
local InitFlag = false
local lastServerName = ""
local stateColor = {
  [T("\231\187\180\230\138\164")] = ccc3(183, 183, 183),
  [T("\231\136\134\230\187\161")] = ccc3(255, 81, 20),
  [T("\231\185\129\229\191\153")] = ccc3(255, 225, 20),
  [T("\230\142\168\232\141\144")] = ccc3(20, 255, 59),
  [T("\230\150\176\229\140\186")] = ccc3(238, 204, 119)
}
local clientVersion = ""
local isServerSDKLogin = false
local isClientSDKLogin = EDNativeDebug or EDFLAGWIN32
local currentAccount
local sessionId = ""
local user_id = ""
local jsonParms = ""
local oldDevideId = ""
local cryptKey = "182173557"
local initServerEvent, redoInitServerEvent, getBlackTechnologyEvenyt, serverloginScene
local initServerComplete = false
local serverListData = {}
local default_server_port = 10000
local default_server_state = T("\231\136\134\230\187\161")

local function getServerName(index)
  if serverListData[index] ~= nil then
    return serverListData[index].name
  end
  return ""
end

local function getRandomServerName()
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  if 0 < #serverListData then
    local randomIndex = math.random(1, #serverListData)
    return getServerName(randomIndex)
  end
  return ""
end

local buttonHandle = {
  entergame = "enterGame",
  selectserver = "selectServer",
  changepass = "changepass",
  logout = "logout",
  changeAccount = "changeAccount"
}
local panelui = {}
local buttonList = {}
local enterContainer, wp8loginContainer
local initPushClient = false
serverLogin.changeType = nil

local function getServerInfo(name)
  for i, v in ipairs(serverListData) do
    if v.name == name then
      local serverData = v
      serverData.serverIndex = i
      return serverData
    end
  end
end

local function closeEvent()
  if initServerEvent then
    CloseTimer(initServerEvent.Name)
    initServerEvent = nil
  end
  if redoInitServerEvent then
    CloseTimer(redoInitServerEvent.Name)
    redoInitServerEvent = nil
  end
end

local function OnSDKInit()
  InitFlag = true
  
  local function openLogin()
    ed.network_diagnosis:finishInit()
    serverloginScene:OpenSDKLoginScene()
  end
  
  ListenTimer(Timer:Once(0.2), function()
    if not ed.ui.sdkRightsDisplayWindow.willOpen({sureCallback = openLogin}) then
      openLogin()
    end
  end)
  EDInitCustomerService(0)
end

local net_status_des = {
  initsdk = "SDK\229\136\157\229\167\139\229\140\150",
  sdklogin = "SDK\231\153\187\229\189\149",
  technology = "\230\139\137\229\143\150BD",
  initserver = "Ser\229\136\157\229\167\139\229\140\150",
  reqserver = "\232\175\183\230\177\130SerList",
  requestAcc = "\232\175\183\230\177\130Acc",
  sdk_login = "GamSDK\231\153\187\229\189\149"
}

function serverLogin:setNetStatus(state, status)
  if tolua.isnull(self.ui.netStatus) then
    return
  end
  state = net_status_des[state] or "null"
  status = status or 0
  self.ui.netStatus:setString(state .. status)
end

local buildType = {
  [0] = "[dev]",
  [301] = "[cn-ptr]",
  [302] = "[cn]",
  [303] = "[cn-dy]",
  [501] = "[global]"
}

function serverLogin:setBuildType()
  self.ui.buildType:setPositionX(ed.display.winSize.width - 155)
  local bt = buildType[EDSDKType] or tostring(EDSDKType)
  local version = EDGetVersionName() or "1.1.100001"
  self.ui.buildType:setString(bt .. " " .. version)
  self.record_version = " App:" .. version
end

function serverLogin:sdkLoginRefreshCurrentServerInfo(svrname, uid)
  self:refreshCurrentServerInfo(svrname)
  if game_server_id then
    local account = sdkLogin.logic.getCurrentServerAccount(game_server_id, uid)
    local vip = account.vip
    account.vip = ed.getVipLevel(vip)
    account.svr_ip = game_server_ip
    account.svr_port = game_server_port
    account.svr_name = game_server_name
    account.svr_id = game_server_id
    sdkLogin.loginLogic.initLastLoginAccount(account)
  end
end

function serverLogin:refreshCurrentServerInfo(svrname)
  local serverInfo = getServerInfo(svrname)
  if serverInfo then
    game_server_id = serverInfo.id
    game_server_ip = serverInfo.ip
    game_server_port = serverInfo.port or default_server_port
    game_server_name = serverInfo.name
    lastServerName = serverInfo.name
    enterContainer:setVisible(true)
    local serverID, serverName = ed.processServerName(svrname)
    if nil ~= serverID then
      self.ui.serverID:setVisible(true)
      ed.setString(self.ui.serverID, serverID)
      ed.setString(self.ui.servername, ed.getLocalServerName(serverName))
    else
      self.ui.serverID:setVisible(false)
      ed.setString(self.ui.servername, ed.getLocalServerName(serverName))
    end
  end
end

local function showAllServerInfo()
  local info = {
    serverListData = serverListData,
    currentServerName = lastServerName,
    userid = user_id,
    isServerSDKLogin = isServerSDKLogin,
    sessionId = sessionId
  }
  ed.ui.newbie.setContainer(enterContainer)
  ed.ui.newbie.setData(info)
  if EDFLAGWIN32 then
    ed.ui.serverListWin.create(info):popWindow()
    ed.loadEnd()
  else
    ed.ui.serverListWin.requestAccount()
  end
end

serverLogin.showAllServerInfo = showAllServerInfo

local function preprocessServerListData()
  for i, server_info in ipairs(serverListData) do
    server_info.port = server_info.port or default_server_port
    server_info.state = T(server_info.state or default_server_state)
    server_info.color = server_info.color and ed.toccc3(server_info.color) or stateColor[server_info.state]
  end
end

local function doInitServer()
  closeEvent()
  ed.loadBegin(false, false)
  FireEvent("NetStatus", "reqserver", 0)
  LoadResources:createServerListThread()
  initServerEvent = ListenTimer(Timer:Always(1), function()
    local file = LoadResources:getServer()
    if file ~= "waiting" then
      local func, err = loadstring(file)
      if type(func) ~= "function" or file == "" then
        EDDebug(err)
        return
      else
        FireEvent("NetStatus", "reqserver", 1)
        _, serverListData = xpcall(func, EDDebug)
        preprocessServerListData()
        showAllServerInfo()
        initServerComplete = false
        closeEvent()
      end
    end
  end)
end

ed.doInitServer = doInitServer

function serverLogin.changeAccount()
  print("change sdk account ")
  serverLogin.selectServer()
end

function serverLogin.selectServer()
  if not isClientSDKLogin then
    serverloginScene:OpenSDKLoginScene()
    return
  end
  if initServerComplete then
    ed.loadBegin(false, false)
    showAllServerInfo()
  else
    doInitServer()
  end
end

function serverLogin.changepass()
  print("do click changepass")
  currentAccount:setVisible(false)
  wp8loginContainer:setVisible(false)
  enterContainer:setVisible(false)
  local currentScene = ed.getCurrentScene()
  if currentScene.identity == "serverlogin" then
    currentScene.newbie.container:setTouchEnabled(true)
    currentScene.newbie.ui.updatepass:setVisible(true)
  end
end

function serverLogin.logout()
  print("do click logout")
  ed.ui.newbie.doLogout()
end

function serverLogin:doBeianBtnTouch()
  local isPress
  
  local function handler(self, event, x, y)
    if self.beianJumpLable == nil or not self.beianJumpLable:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(self.beianJumpLable, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(self.beianJumpLable, x, y) then
        ed.openURL("https://beian.miit.gov.cn/")
      end
      isPress = nil
    end
  end
  
  return handler
end

function serverLogin:doFixBtnTouch()
  local isPress
  
  local function handler(self, event, x, y)
    if not self.ui.fixLabel:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(self.ui.fixLabel, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(self.ui.fixLabel, x, y) then
        ed.fixClient()
      end
      isPress = nil
    end
  end
  
  return handler
end

function serverLogin:doVerisonTouch()
  local isPress
  
  local function handler(self, event, x, y)
    if not self.ui.version:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(self.ui.version, x, y) or ed.containsPoint(self.ui.buildType, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and (ed.containsPoint(self.ui.version, x, y) or ed.containsPoint(self.ui.buildType, x, y)) then
        ed.copyString(self.record_version)
        print("version", self.record_version)
      end
      isPress = nil
    end
  end
  
  return handler
end

function serverLogin:doMainLayerTouch()
  local fixTouch = serverLogin:doFixBtnTouch()
  local beianTouch = serverLogin:doBeianBtnTouch()
  local versionTouch = serverLogin:doVerisonTouch()
  local self = self
  
  local function handler(event, x, y)
    fixTouch(self, event, x, y)
    beianTouch(self, event, x, y)
    versionTouch(self, event, x, y)
    return true
  end
  
  return handler
end

function serverLogin:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.entergame,
    press = self.ui.entergame_press,
    pressScale = 0.9,
    key = "entergame",
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      self:enterGame()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.serverNameBg,
    press = self.ui.serverNameBg_press,
    pressScale = 0.95,
    key = "selectserver",
    force = true,
    clickHandler = function()
      self:selectServer()
    end,
    pressHandler = function()
      self.ui.selectserverbg:setVisible(true)
    end,
    cancelPressHandler = function()
      self.ui.selectserverbg:setVisible(false)
    end
  })
  for index, config in ipairs(self.sdkButtonsConfig) do
    self:btRegisterButtonClick({
      button = buttonList[config.key],
      press = buttonList[config.key .. "_press"],
      key = config.key,
      clickHandler = function()
        config.onClick()
      end
    })
  end
  self:listenEvent("sdkLoginRefreshCurrentServerInfo", function(svrname, uid)
    self:sdkLoginRefreshCurrentServerInfo(svrname, uid)
  end)
  self:listenEvent("refreshCurrentServerInfo", function(name)
    self:refreshCurrentServerInfo(name)
  end)
end

function serverLogin.getOldDeviceId()
  return oldDevideId
end

function serverLogin:doClickInServerHandler(clickHandler)
  local function handler(id)
    if serverListData[id] then
      self:refreshCurrentServerInfo(serverListData[id].name)
    end
  end
  
  return handler
end

function serverLogin.onExitFramework()
  if serverloginScene.notExitYet then
    serverloginScene.notExitYet = nil
    return
  end
  enterContainer = nil
  buttonList = {}
  panelui = {}
  serverListData = {}
  EDServerList = {}
  closeEvent()
end

function serverLogin.addServer(param)
  table.insert(serverListData, param)
end

function serverLogin:initServer()
  self:setNetStatus("initserver", 0)
  local lastServerInfo = ed.storage.getString(tostring(EDSDKType) .. "lastserverinfo")
  if lastServerInfo ~= "" then
    local name, ip, port, id = string.match(lastServerInfo, "name:([^,]*),ip:([^,]*),port:([^,]*),id:([^,]*)")
    lastServerName = name
    local param = {
      id = id,
      name = name,
      ip = ip,
      port = port
    }
    serverLogin.addServer(param)
  end
  preprocessServerListData()
  if lastServerName == "" then
    lastServerName = getRandomServerName()
  end
  if lastServerName ~= "" then
    local serverID, serverName = ed.processServerName(lastServerName)
    if nil ~= serverID then
      self.ui.serverID:setVisible(true)
      ed.setString(self.ui.serverID, serverID)
      ed.setString(self.ui.servername, ed.getLocalServerName(serverName))
    else
      self.ui.serverID:setVisible(false)
      ed.setString(self.ui.servername, ed.getLocalServerName(serverName))
    end
  end
  self:setNetStatus("initserver", 1)
end

function serverLogin:checkNeedUpdateBinary()
end

function serverLogin:setBackdoorVersion()
  if BACKDOORVERSION then
    ed.setString(self.ui.bdversion, BACKDOORVERSION)
  end
end

function serverLogin:openIpv6()
  if EDFLAGIOS and ed.ipv6Manager.open then
    local networkTyr = ed.ipv6Manager.create()
    networkTyr:openIpv6()
  end
end

local loadBlackDoorCount = 0

function serverLogin:getBlackTechnology()
  ed.reportHUE({
    action_type = "get_backdoor"
  })
  self.backdoor_finish = false
  self:setNetStatus("technology", 0)
  if getBlackTechnologyEvenyt then
    CloseTimer(getBlackTechnologyEvenyt.Name)
    getBlackTechnologyEvenyt = nil
  end
  if 5 < loadBlackDoorCount then
    local info = {
      text = T("\230\155\180\230\150\176\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\231\142\175\229\162\131"),
      buttonText = T("\231\161\174\229\174\154")
    }
    ed.showAlertDialog(info)
    return
  end
  ed.loadBegin(false, false)
  LoadResources:createBlackTechnologyThread()
  getBlackTechnologyEvenyt = ListenTimer(Timer:Always(1), function()
    local file = LoadResources:getBlackTechnology()
    if file ~= "waiting" then
      if EDFLAGWIN32 then
        local lfile = ed.readfile("backdoor.lua")
        if lfile then
          file = lfile
        end
      end
      local func, err = loadstring(file)
      ed.backdoor_string = file
      if type(func) ~= "function" or file == "" then
        ed.reportHUE({
          action_type = "get_backdoor_failed"
        })
        EDDebug(err)
        self:getBlackTechnology()
        return
      else
        _, serverListData = xpcall(func, EDDebug)
        self:setNetStatus("technology", 1)
        if not ed.debug_mode then
          function print(s)
          end
          
          function EDLog(s)
          end
          
          function ed.printTable()
          end
          
          function ed.pt()
          end
        end
        loadBlackDoorCount = 0
        self:setBackdoorVersion()
        self:openIpv6()
        self:initServer()
        self:checkNeedUpdateBinary()
        self:CheakNewPackageUpdate()
        if getBlackTechnologyEvenyt then
          CloseTimer(getBlackTechnologyEvenyt.Name)
          getBlackTechnologyEvenyt = nil
        end
        ed.loadEnd()
        ed.reportHUE({
          action_type = "get_backdoor_success"
        })
        self.backdoor_finish = true
        EDInitCustomerService(ed.customerServiceDebug and 1 or 0)
        FireEvent("BlackTech_Finish")
      end
    end
  end)
end

function serverLogin:checkBackupIP()
  if ed.useBackupIP and ed.backupIPs and #ed.backupIPs > 0 then
    if ed.backupIPIdx then
      ed.backupIPIdx = ed.backupIPIdx + 1
      if ed.backupIPIdx > #ed.backupIPs then
        ed.backupIPIdx = 1
      end
    else
      ed.backupIPIdx = 1
    end
    game_server_ip = ed.backupIPs[ed.backupIPIdx]
  end
end

function serverLogin:enterGame()
  EDLog(string.format("game_server_ip: %s", tostring(game_server_ip)))
  if not isClientSDKLogin then
    serverloginScene:OpenSDKLoginScene()
    return
  end
  self:refreshCurrentServerInfo(lastServerName)
  if game_server_ip == nil then
    return
  end
  self:checkBackupIP()
  local serverInfoStr = string.format("name:%s,ip:%s,port:%s,id:%s", tostring(lastServerName), game_server_ip, game_server_port, game_server_id)
  ed.storage.setValue(tostring(EDSDKType) .. "lastserverinfo", serverInfoStr)
  ed.reportHUE({
    action_type = "start_enter_game",
    game_server_ip = game_server_ip,
    server_info = serverInfoStr
  })
  if not isServerSDKLogin then
    serverLogin:requestSdkLogin()
  elseif ed.needPatchRes() then
    ed.replaceScene(ed.ui.patchRes.create(sessionId))
  else
    ed.replaceScene(ed.ui.logo.create(sessionId))
  end
end

function serverLogin.getRealPlatId()
  EDLog(string.format("[RealPlatId]PlatId: %s", EDSDKType))
  return EDSDKType
end

function serverLogin:getJsonParams()
  return jsonParms
end

function serverLogin:getSessionId()
  return sessionId
end

function serverLogin:setSessionId(newSessionId)
  sessionId = newSessionId
end

function serverLogin:getCryptKey()
  return cryptKey
end

function serverLogin:setCryptKey(newCryptKey)
  cryptKey = newCryptKey
end

function serverLogin:requestSdkLogin()
  ed.reportHUE({
    action_type = "gs_sdk_login"
  })
  FireEvent("NetStatus", "sdk_login", 0)
  local login = ed.upmsg.sdk_login()
  if sdkLogin.isNewLoginMode() then
    sessionId = sdkLogin.loginLogic.getToken()
    login._mobile_num = sdkLogin.loginLogic.getPhone()
  end
  login._session_key = sessionId
  EDLog("EDSDKType..." .. tostring(EDSDKType))
  EDLog("_session_key..." .. tostring(sessionId))
  login._plat_id = self.getRealPlatId()
  cryptKey = ed.createCryptKey(sessionId)
  login._crypt_key = cryptKey
  login._sdk_version = ""
  if jsonParms ~= "" then
    login._sdk_params = jsonParms
  end
  ed.send(login, "sdk_login")
end

function serverLogin:CheakIsHasNewUpdate()
  local key
  if multi_definition then
    key = ed.loadDefinition()
  end
  if key == nil then
    key = ""
  end
  local keyStr = "dt_advance_packge_" .. key
  local hasLoadPackage = ed.storage.getString(keyStr)
  local indexId = 1
  local testNewpackage = AdvanceLoadPackage
  if not testNewpackage or #testNewpackage < 1 then
    return 0
  end
  if #testNewpackage < 1 then
    indexId = 0
  end
  for i, v in ipairs(testNewpackage) do
    if hasLoadPackage == v then
      indexId = i + 1
      if testNewpackage[indexId] == nil then
        return 0
      end
    end
  end
  return indexId
end

function serverLogin:CheakNewPackageUpdate()
  local loadNewPackageIndex = self:CheakIsHasNewUpdate()
  print("loadNewPackageIndex:" .. loadNewPackageIndex)
  if loadNewPackageIndex ~= 0 then
    ListenTimer(Timer:Once(0.1), function()
      local info = {
        text = T("\230\156\137\230\150\176\231\154\132\228\184\139\232\189\189\232\181\132\230\186\144\229\140\133\239\188\140\230\152\175\229\144\166\228\184\139\232\189\189?"),
        leftText = T("\229\143\150\230\182\136"),
        rightHandler = function()
          xpcall(function()
            local loadIndex = loadNewPackageIndex
            self.advabceLoad = ed.ui.AdvanceLoad.create(loadIndex, self)
            self.mainLayer:setVisible(false)
            self.scene:addChild(self.advabceLoad.mainLayer)
            ListenEvent("advanceLoad_complete", function(selfNode)
              if selfNode == nil then
                return
              end
              selfNode.advabceLoad.mainLayer:removeFromParentAndCleanup(true)
              selfNode.mainLayer:setVisible(true)
              selfNode.advabceLoad = nil
            end)
          end, EDDebug)
        end,
        rightText = T("\228\184\139\232\189\189")
      }
      ed.showConfirmDialog(info)
    end)
  end
end

function serverLogin:onEnterFramework()
  local function handler()
    ed.reportHUE({
      action_type = "enter_login_scene"
    })
    ed.reportClientHUE({
      action_type = "enter_login_scene"
    })
    self.onEntered = true
    ed.playMusic(ed.music.map)
    ed.network_diagnosis:preInit()
    ed.gameCenter = true
    self:setNetStatus("initsdk", 0)
    if not InitFlag and not isClientSDKLogin then
      if EDFLAGIOS then
        EDSDKInit()
      elseif EDFLAGANDROID then
        EDAndroidExtra("sdkInit", "")
      end
    end
    if #serverListData == 0 and (EDSDKType == 0 or user_id ~= "") then
      self:getBlackTechnology()
    end
  end
  
  return handler
end

function serverLogin.getUserId()
  return user_id
end

local function loginSDK()
  local text = T("\231\153\187\229\189\149\229\164\177\232\180\165\239\188\140\232\175\183\233\135\141\232\175\149")
  local info = {
    text = text,
    buttonText = T("\233\135\141\232\175\149"),
    handler = function()
      xpcall(function()
        serverloginScene:OpenSDKLoginScene()
      end, EDDebug)
    end
  }
  ed.showAlertDialog(info)
end

function serverLogin.deCodeJavaToJason(jstring)
  local nInfo = {}
  if EDSDKType == 116 then
    local array = Split(jstring, ":")
    nInfo = {
      platformid = array[1],
      subplatformid = array[2],
      extra = array[3]
    }
    return ed.getJson(nInfo)
  elseif EDSDKType == 157 then
    local array = Split(jstring, ":")
    nInfo = {
      sign = array[1],
      logintime = array[2]
    }
    return ed.getJson(nInfo)
  elseif EDSDKType == 162 or EDSDKType == 159 then
    return jstring
  elseif EDSDKType == 114 then
    local array = Split(jstring, ":")
    nInfo = {
      ts = array[1],
      playerLevel = array[2],
      playerSSign = array[3],
      playerId = array[4]
    }
    return ed.getJson(nInfo)
  end
  return ""
end

function serverLogin:OnSDKLogin()
  local function handler(success, session, uin)
    CloseEvent("BlackTech_Finish")
    
    if success then
      if "error" == uin or "error" == session then
        ed.showAlertDialog({
          text = T("\230\130\168\231\154\132\232\180\166\229\143\183\229\188\130\229\184\184\239\188\140\232\175\183\232\129\148\231\179\187\229\174\162\230\156\141\239\188\129\n\233\148\153\232\175\175\228\187\163\231\160\129:error"),
          buttonText = T("\233\128\128\229\135\186"),
          handler = function()
            EDExit()
          end
        })
      end
      sessionId = session
      user_id = uin
      ed.network_diagnosis:setUserid(user_id)
      ed.third_pay:setAppUid_AppToken(uin, session)
      ed.setIsAdult(true)
      if ed.isPCCloneMode then
        ed.setDeviceId(string.format("%d-%s", EDSDKType or 1, uin or "nil"))
      else
        ed.setDeviceId(uin)
      end
      ed.setAccessToken(session)
      EDLog(string.format("MMM %s %s", uin or "nil", session or "nil"))
      isClientSDKLogin = true
      self:setNetStatus("sdklogin", 1)
      if EDFLAGIOS and ed.gameCenter then
        EDIOSExtra("GameCenterAuthenticate", "")
      end
    else
      loginSDK()
    end
  end
  
  return handler
end

function serverLogin.getClientVersion()
  return clientVersion
end

function serverLogin:setDirServer()
  if not custom_dirserver then
    ed.storage.setValue("cus_dir_servers", "")
    return
  end
  local dir = ed.getCurDirServer()
  print("use custom dirserver", dir)
  LoadResources:setDirServer(dir)
end

function serverLogin.create()
  ed.reportHUE({
    action_type = "create_login_scene"
  })
  local newscene = base.create("serverlogin")
  setmetatable(newscene, serverLogin)
  local scene = newscene.scene
  local mainLayer = CCLayer:create()
  newscene.mainLayer = mainLayer
  serverloginScene = newscene
  scene:addChild(mainLayer)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(newscene:doMainLayerTouch(), false, 0, false)
  newscene.backdoor_finish = false
  newscene.buttonPress = {}
  newscene.buttonLabel = {}
  if resource_config.splash_fca then
    local effect_fca = ed.createFcaActor(resource_config.splash_fca)
    effect_fca:setLoop(true)
    effect_fca:setPosition(ed.display.center)
    effect_fca:setAction("Loop")
    mainLayer:addChild(effect_fca)
    newscene:addFca(effect_fca)
    effect_fca:setVisible(true)
  else
    newscene:setBackground(ed.getSplash())
  end
  enterContainer = CCSprite:create()
  mainLayer:addChild(enterContainer)
  local loginContainer, ui = ed.editorui(ed.uieditor.login)
  newscene.ui = ui
  ui.selectserver:limitWidthByScale(110)
  ed.setLabelShadow(ui.entergame_label, ed.toccc3(0), ccp(1, 0))
  mainLayer:addChild(loginContainer)
  newscene:adaptUI()
  newscene:setDirServer()
  newscene:createSDKButtons()
  EDLog("EDCurLanguage=" .. tostring(EDCurLanguage))
  newscene:createAgeTips()
  newscene:createTipAndInfos()
  newscene:setBuildType()
  newscene:createVersionLabel()
  enterContainer:setVisible(true)
  newscene:registerOnEnterHandler("onEnterFramework", newscene:onEnterFramework())
  newscene:registerOnExitHandler("onExitFramework", newscene.onExitFramework)
  newscene.onEntered = false
  CloseEvent("NetStatus")
  ListenEvent("NetStatus", function(state, status)
    newscene:setNetStatus(state, status)
  end)
  CloseEvent("SDKLogin")
  ListenEvent("SDKLogin", newscene:OnSDKLogin())
  CloseEvent("SDKLoginRsp")
  ListenEvent("SDKLoginRsp", function(result)
    FireEvent("NetStatus", "sdk_login", 1)
    if result == "fail" then
      ed.reportHUE({
        action_type = "gs_sdk_login_failed"
      })
      loginSDK()
    elseif result == "success" then
      ed.reportHUE({
        action_type = "gs_sdk_login_success"
      })
      isServerSDKLogin = true
      ed.setCryptKey(cryptKey)
      if ed.needPatchRes() then
        ed.replaceScene(ed.ui.patchRes.create(sessionId))
      else
        ed.replaceScene(ed.ui.logo.create(sessionId))
      end
    end
  end)
  ed.asyncload.preloadInEnterGame()
  newscene:addEventListener()
  return newscene
end

function serverLogin:adaptUI()
  local ui = self.ui
  local winSizeWidth = ed.display.winSize.width
  local winSizeHeight = ed.display.winSize.height
  ui.entergame:setPosition(ccp(winSizeWidth / 2, winSizeHeight * 0.17))
  ui.serverNameBg:setPosition(ccp(winSizeWidth / 2, winSizeHeight * 0.33))
end

local sdkButtonsConfig = {
  {
    name = T("\229\174\162\230\156\141"),
    key = "customerService",
    icon = "installer/login/service.png",
    btnRes = "installer/login/frame.png",
    isOpen = true,
    onClick = function()
      if EDFLAGIOS or EDFLAGANDROID then
        if EDSDKType == 302 then
          EDOpenCustomerService(ed.getJson({bbx_region = "official"}))
        elseif EDSDKType == 301 then
          EDOpenCustomerService(ed.getJson({bbx_region = "cnptr"}))
        elseif EDSDKType == 303 then
          EDOpenCustomerService(ed.getJson({bbx_region = "official"}))
        elseif EDSDKType == 501 then
          EDOpenCustomerService(ed.getJson({
            bbx_region = "farlight%3Aglobal%3Aobt"
          }))
        else
          EDOpenCustomerService("")
        end
      end
    end
  },
  {
    name = T("\232\180\166\229\143\183"),
    key = "account",
    icon = "installer/login/account.png",
    btnRes = "installer/login/frame.png",
    isOpen = true,
    onClick = function()
      EDSwitchAccount()
    end
  },
  {
    name = T("\229\133\172\229\145\138"),
    key = "notice",
    icon = "installer/login/notice.png",
    btnRes = "installer/login/frame.png",
    isOpen = true,
    onClick = function()
      ed.popScrollDialog()
    end
  },
  {
    name = T("\231\189\145\231\187\156\230\163\128\230\181\139"),
    key = "nettest",
    icon = "installer/login/net.png",
    btnRes = "installer/login/frame.png",
    isOpen = ed.network_diagnosis:isSupport(),
    onClick = function()
      serverloginScene:refreshCurrentServerInfo(lastServerName)
      ed.showNetAlertDialog()
    end
  },
  {
    name = T("\231\137\136\230\156\172"),
    key = "mode",
    icon = "installer/login/switch_icon.png",
    btnRes = "installer/login/frame.png",
    isOpen = ed.isShowVersionChange(),
    onClick = function()
      ed.ui.versionChangeView.create():popWindow()
    end
  },
  {
    name = T("\232\175\173\232\168\128"),
    key = "language",
    icon = "installer/login/login_language.png",
    btnRes = "installer/login/frame.png",
    isOpen = EDSDKType == 0 or ed.isMultiLanguage(),
    onClick = function()
      ed.ui.languageSettingWin.create():popWindow()
    end
  }
}
serverLogin.sdkButtonsConfig = sdkButtonsConfig

function serverLogin:createSDKButtons()
  local sdkui = {}
  local count = 0
  local height = ed.display.winSize.height - 60
  for i, v in ipairs(sdkButtonsConfig) do
    if v.isOpen then
      local pos = ccp(ed.display.winSize.width - 60, height - 60 * count)
      table.insert(sdkui, {
        t = "Sprite",
        base = {
          name = v.key,
          array = buttonList,
          res = v.btnRes
        },
        layout = {position = pos}
      })
      table.insert(sdkui, {
        t = "Sprite",
        base = {
          name = v.key .. "_icon",
          res = v.icon
        },
        layout = {
          position = ccp(pos.x, pos.y)
        }
      })
      table.insert(sdkui, {
        t = "Scale9Sprite",
        base = {
          name = v.key .. "_textBg",
          res = "UI/alpha/1080P/common/Login_base.png",
          capInsets = CCRectMake(24, 13, 2, 2)
        },
        layout = {
          position = ccp(pos.x, pos.y - 20)
        }
      })
      table.insert(sdkui, {
        t = "Label",
        base = {
          name = v.key .. "_text",
          text = v.name,
          size = 12
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(pos.x, pos.y - 20)
        },
        config = {
          color = ccc3(235, 223, 207)
        }
      })
      count = count + 1
    end
  end
  local readNode = ed.readnode.create(enterContainer, panelui)
  readNode:addNode(sdkui)
  for i, v in ipairs(sdkButtonsConfig) do
    if panelui[v.key .. "_text"] then
      ed.adaptLabel(panelui[v.key .. "_text"], {maxWidth = 80, minScale = 0.9})
      panelui[v.key .. "_textBg"]:setContentSize(CCSizeMake(math.max(panelui[v.key .. "_text"]:getContentSize().width * panelui[v.key .. "_text"]:getScale(), 50), math.max(panelui[v.key .. "_text"]:getContentSize().height, 16)))
    end
  end
end

function serverLogin:createLabel(text, fontsize, pos)
  local node = CCLabelTTF:create(text, ed.font, fontsize)
  node:setColor(ccc3(170, 170, 170))
  node:setPosition(pos)
  return node
end

function serverLogin:createVersionLabel(...)
  self.ui.version:setPositionX(ed.display.winSize.width - 155)
  local version = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  if multi_definition then
    version = CCUserDefault:sharedUserDefault():getStringForKey("current-version-" .. ed.loadDefinition())
  end
  version = string.match(version, "%d+%.%d+%.%d+%.%d+%.zip$")
  if version ~= nil then
    clientVersion = string.sub(version, 0, -5)
    local versionStr = T("\231\137\136\230\156\172\229\143\183\239\188\154") .. clientVersion
    self.ui.version:setString(versionStr)
    self.record_version = "Game:" .. clientVersion .. self.record_version
  end
end

function serverLogin:createAgeTips()
  local isShow = not ed.isAreaOverSea()
  if not isShow then
    return
  end
  local touchNode = ed.ui.basetouchnode.btCreate()
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  layer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -200, false)
  self.mainLayer:addChild(layer)
  local imgTips = ed.createSprite("installer/age_tips.png")
  imgTips:setPosition(ccp(66, 88))
  layer:addChild(imgTips)
  touchNode:btRegisterButtonClick({
    button = imgTips,
    key = "AgeTipsClick",
    clickHandler = function()
      ed.ui.ageTipsWin.create():popWindow()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
end

function serverLogin:createTipAndInfos()
  local winSize = ed.display.winSize
  local isShow = not ed.isAreaOverSea()
  if isShow then
    local tipBg = ed.createScale9Sprite("installer/Headline_bg.png")
    tipBg:setContentSize(CCSizeMake(winSize.width, 20))
    tipBg:setOpacity(150)
    tipBg:setPosition(ed.display.center.x, winSize.height - 10)
    self.mainLayer:addChild(tipBg)
    local tips = {
      {
        text = "\230\138\181\229\136\182\228\184\141\232\137\175\230\184\184\230\136\143\239\188\140\230\139\146\231\187\157\231\155\151\231\137\136\230\184\184\230\136\143\227\128\130\230\179\168\230\132\143\232\135\170\230\136\145\228\191\157\230\138\164\239\188\140\232\176\168\233\152\178\229\143\151\233\170\151\228\184\138\229\189\147\227\128\130\233\128\130\229\186\166\230\184\184\230\136\143\231\155\138\232\132\145\239\188\140\230\178\137\232\191\183\230\184\184\230\136\143\228\188\164\232\186\171\227\128\130\229\144\136\231\144\134\229\174\137\230\142\146\230\151\182\233\151\180\239\188\140\228\186\171\229\143\151\229\129\165\229\186\183\231\148\159\230\180\187\227\128\130",
        fontsize = 10,
        pos = ccp(ed.display.center.x, 10)
      }
    }
    for _, v in ipairs(tips) do
      local node = self:createLabel(v.text, v.fontsize, v.pos)
      tipBg:addChild(node)
    end
  end
  local buttomBg = ed.createScale9Sprite("installer/Headline_bg.png")
  buttomBg:setContentSize(CCSizeMake(winSize.width, 50))
  buttomBg:setOpacity(200)
  buttomBg:setPosition(ed.display.center.x, 25)
  self.mainLayer:addChild(buttomBg)
  if isShow then
    local infos = {
      {
        text = "\229\174\161\230\137\185\230\150\135\229\143\183\239\188\154\230\150\176\229\185\191\229\135\186\229\174\161[2016]1086\229\143\183  \229\135\186\231\137\136\231\137\169\229\143\183\239\188\154ISBN  978-7-89988-909-1  \232\145\151\228\189\156\230\157\131\228\186\186\239\188\154\228\184\138\230\181\183\232\142\137\232\142\137\228\184\157\231\189\145\231\187\156\231\167\145\230\138\128\230\156\137\233\153\144\229\133\172\229\143\184",
        fontsize = 10,
        pos = ccp(ed.display.center.x, 40)
      },
      {
        text = "\232\191\144\232\144\165\229\141\149\228\189\141\239\188\154\228\184\138\230\181\183\232\142\137\232\142\137\228\184\157\231\189\145\231\187\156\231\167\145\230\138\128\230\156\137\233\153\144\229\133\172\229\143\184  \229\135\186\231\137\136\229\141\149\228\189\141\239\188\154\228\184\138\230\181\183\231\167\145\229\173\166\230\138\128\230\156\175\230\150\135\231\140\174\229\135\186\231\137\136\231\164\190\230\156\137\233\153\144\229\133\172\229\143\184  \229\164\135\230\161\136\229\143\183\239\188\154\230\178\170ICP\229\164\13515032795\229\143\183-16A",
        fontsize = 10,
        pos = ccp(ed.display.center.x, 25)
      }
    }
    for _, v in pairs(infos) do
      local node = self:createLabel(v.text, v.fontsize, v.pos)
      buttomBg:addChild(node)
      self.beianJumpLable = node
    end
  end
end

function serverLogin:SendSDKLoginExtra(addtion)
  EDAndroidExtra("SDKLoginAddtion", ed.getJson(addtion))
end

function serverLogin:OpenSDKLoginScene()
  local function doSdkLogin()
    self:setNetStatus("sdklogin", 0)
    
    EDSDKLogin()
  end
  
  if not self.backdoor_finish then
    CloseEvent("BlackTech_Finish")
    ListenEvent("BlackTech_Finish", function()
      doSdkLogin()
    end)
    self:getBlackTechnology()
  else
    doSdkLogin()
  end
end

function serverLogin.rewriteSDKFunc()
  function EDSDKLogin()
  end
  
  function EDEnableSDKUI()
  end
  
  function EDSDKInit()
  end
  
  if EDFLAGANDROID then
    function ed.sdk.sdkInit()
    end
  end
end

local function sendiPushClientId()
  if initPushClient then
    return
  end
  local jclientId
  if EDFLAGANDROID then
    jclientId = EDAndroidGetParam("jpushClientId")
  elseif EDFLAGIOS and EDJiGuangPushClientID then
    jclientId = EDJiGuangPushClientID()
  end
  if jclientId and jclientId ~= "" then
    EDLog("get jclientId " .. jclientId)
    local msg = ed.upmsg.push_notify()
    msg._client_id = "1"
    msg._jpush_client_id = jclientId
    ed.send(msg, "push_notify", true)
  end
  initPushClient = true
end

local function OnSystemSettingReply(msg)
  sendiPushClientId()
end

function ed.resetShareArgs()
  EDShareToFriends = nil
  EDShareToFriendsWeb = nil
  EDShareToFriendsText = nil
  EDShareToFriendsPool = nil
  EDShareToFriendsPoolQR = nil
end

ListenEvent("SDKInit", OnSDKInit)
ListenEvent("SystemSettingReply", OnSystemSettingReply)
