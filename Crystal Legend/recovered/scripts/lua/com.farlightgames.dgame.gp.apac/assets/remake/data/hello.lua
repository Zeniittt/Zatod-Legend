pcall(function()
  if EDFLAGWIN32 then
    logfile = io.open("log_client.log", "w")
  end
  require("lollipop")
  require("publishconfig")
  require("resourceconfig")
  require("tools")
  require("util/localstorage")
  require("ui/loading/loading_uilist")
  require("edebug")
  require("display")
  require("maingameproject")
  require("sdkInitConfig")
  require("ui/sdk/sdkui")
  require("datatable")
  require("pb")
  require("genericnetwork/protoconfig")
  require("genericnetwork/csprotodata")
  require("genericnetwork/socketconnection")
  require("genericnetwork/connectionmanager")
  require("ykframework.init")
end)

function ed.reportHUE(info)
  if EDFLAGIOS then
    EDIOSExtra("reportHUE", ed.getJson(info))
  elseif EDFLAGANDROID then
    EDAndroidExtra("reportHUE", ed.getJson(info))
  else
    print("EDReportHUE", ed.getJson(info))
  end
end

ed.reportHUE({
  action_type = "script_load_finish"
})

function ed.reportClientHUE(info)
  if EDFLAGIOS then
    EDIOSExtra("reportClientHUE", ed.getJson(info))
  elseif EDFLAGANDROID then
    EDAndroidExtra("reportClientHUE", ed.getJson(info))
  else
    print("EDReportClientHUE", ed.getJson(info))
  end
end

if EDFLAGWIN32 then
  ed.profiler = require("profiler")
  CCDirector:sharedDirector():setDisplayStats(true)
end
ed.debug_mode = debug_mode
ed.gm_mod = gm_mod
__assert_ = assert

function assert(v, message)
  if not v then
    print(message)
  end
end

local function initMultiLanguage()
  require("multilanguage")
  EDLog("EDCurLanguage: " .. EDCurLanguage)
  EDLog("EDCurSoundLan: " .. EDCurSoundLan)
  EDLog("EDCurLilithLanguage: " .. EDCurLilithLanguage)
end

local function initMultFont()
  local platform = "default"
  if EDFLAGANDROID then
    platform = "android"
  end
  local curFont = ed.mult_fonts[platform][EDCurLanguage]
  if curFont == nil then
    curFont = ed.mult_fonts[platform].en
  end
  print("curFont", curFont)
  ed.font = curFont.normal
  ed.fontBold = curFont.bold
  ed.fontSystem = "dgame-system"
  ed.fontBoldSystem = "dgame-system-bold"
end

local function initFont()
  if EDGetEngineVersion and EDGetEngineVersion() > 13 then
    initMultFont()
    return
  end
  local font = resource_config.font or "DFYuanW7-GBK"
  local fontBold = resource_config.fontBold or "FZCuQian-M17S"
  if EDFLAGANDROID then
    font = resource_config.font or "remake/fonts/DFYuanW7-GB2312.ttf"
    fontBold = resource_config.fontBold or "remake/fonts/FZCQJW.ttf"
  end
  ed.font = font
  ed.fontBold = fontBold
  ed.fontSystem = font
  ed.fontBoldSystem = fontBold
end

function ed.loadAllFiles()
  for i, v in ipairs(ed.needLoadFiles) do
    require(v)
  end
end

function ed.enableFcaAutoRelease(flag)
  if EDFcaInfo.enableReleaseFcaInfo then
    EDFcaInfo:enableReleaseFcaInfo(flag)
  end
  if EDFcaSpInfo then
    EDFcaSpInfo:enableReleaseFcaInfo(flag)
  end
end

local scene_stack = {}
ed.scene_stack = scene_stack
ed.MessageType = {CURL_ERROR = 1}
local resume_timestamp

local function watchBugly(msg)
  if (EDFLAGANDROID or EDFLAGIOS) and buglyReportLuaException then
    buglyReportLuaException(tostring(msg), debug.traceback())
  end
end

local function combineSomeTables()
  local tb1 = ed.getDataTable("AnimDuration") or {}
  local tb2 = ed.getDataTable("AnimDurationSp") or {}
  for k, v in pairs(tb2) do
    tb1[k] = {}
    for k1, v1 in pairs(v) do
      tb1[k][k1] = v1
    end
  end
end

local function main()
  if EDRegisterEventHandler then
    EDRegisterEventHandler(ed.MessageType.CURL_ERROR, function(a, b)
      errReport(a, b)
    end)
  end
  if EDGetEngineVersion then
    EDLog("------------->: Current Engine Version: " .. (EDGetEngineVersion() or "err unknown version"))
  end
  if EDFLAGANDROID or EDFLAGIOS then
    if EDGetDiskFreeSize then
      local diskFreeSize = EDGetDiskFreeSize()
      EDLog("------------->: getDiskFreeSize: " .. (diskFreeSize or "err unknown size"))
    end
    if EDSpine then
      EDSpine:SetSpineUseYK(true)
    end
  end
  EDLog("==========================================")
  for i, v in ipairs(dir_servers) do
    EDLog(string.format("Dir server %i: %s", i, v))
  end
  EDLog("Resource Resolution: " .. resource_resolution)
  EDLog("")
  EDLog("Current Version: " .. CCUserDefault:sharedUserDefault():getStringForKey("current-version"))
  if multi_definition then
    EDLog("")
    EDLog("Current definition: " .. ed.loadDefinition())
    EDLog("Current definition Version: " .. CCUserDefault:sharedUserDefault():getStringForKey("current-version-" .. ed.loadDefinition()))
  end
  EDLog("Current Load Path: " .. CCUserDefault:sharedUserDefault():getStringForKey("search_pathes"))
  EDLog("==========================================")
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  combineSomeTables()
  ed.getDamageNumType()
  ed.loadSoundSwitch()
  ed.loadTextCache()
  ed.loadFisrtScene()
  if ed.SoloTestMode then
    ed.SoloModel:setFactions({
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      9
    })
    ed.engine = ed.SoloBattleEngine
    ed.PopupCreate = ed.SoloPopupCreate
    ed.SoloBattleEngine:enterSolo()
    local scene = ed.SoloBattleScene.create()
    ed.pushScene(scene)
  end
  ed.loadLegendEquip()
end

ed.runmain = main
local FirstStartFile = {
  "pb",
  "util/utils",
  "util/delayprocessqueue",
  "datatable",
  "event/event",
  "event/systemevent",
  "network/network_queue",
  "network/network",
  "network/network_l",
  "network/network_l_c",
  "network/network_udp",
  "network/network_udp_multiplayer",
  "network/network_udp_multiarena",
  "network/network_udp_multistage",
  "network/network_recharge",
  "network/ipv6Manager",
  "network/network_l_chat",
  "genericnetwork/protoconfig",
  "genericnetwork/csprotodata",
  "genericnetwork/socketconnection",
  "genericnetwork/connectionmanager",
  "ui/reward",
  "ui/loadFlower",
  "ui/basetouchnode",
  "ui/basenode",
  "ui/basescene",
  "ui/notes",
  "ui/sdk/sdkui",
  "ui/sdk/sdknetwork",
  "ui/sdk/sdklogin",
  "ui/sdk/bindaccountmgr",
  "ui/sdk/accountnetwork",
  "ui/sdk/bindaccount",
  "ui/readconfig"
}

local function loadFisrtScene()
  local update_entry_id = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(ed.gameUpdate, 0, false)
  local nativeDebug = EDFLAGWIN32 or EDNativeDebug
  if nativeDebug then
    ed.pushScene(ed.ui.debuglogin.create())
  else
    ed.memeryGC(10)
    ed.pushScene(ed.ui.serverlogin.create())
  end
end

ed.loadFisrtScene = loadFisrtScene

local function loadInitScene()
  ed.pushScene(ed.loading.scene.create())
end

ed.loadInitScene = loadInitScene
local willShowScene

local function setWillShowScene(scene, method, params)
  if willShowScene and willShowScene[1].release then
    willShowScene[1]:release()
  end
  scene:ccScene():retain()
  willShowScene = {
    scene,
    method,
    params
  }
end

local function pushScene(scene)
  if not ed.asyncload.isCompleted then
    setWillShowScene(scene, "push")
    return
  end
  if #scene_stack == 0 then
    table.insert(scene_stack, scene)
    CCDirector:sharedDirector():runWithScene(scene:ccScene())
  else
    local idx = 0
    for i, v in ipairs(scene_stack) do
      if v.identity == scene.identity then
        idx = i
        break
      end
    end
    if 0 < idx then
      idx = #scene_stack - idx
      while 0 < idx do
        ed.popScene()
        idx = idx - 1
      end
      ed.replaceScene(scene)
    else
      table.insert(scene_stack, scene)
      CCDirector:sharedDirector():pushScene(scene:ccScene())
    end
  end
end

ed.pushScene = pushScene

local function popScene()
  if #scene_stack < 2 then
    return
  end
  if scene_stack[#scene_stack].identity == "mainScene" then
    return
  end
  local scene = table.remove(scene_stack, #scene_stack)
  if scene.onPopScene then
    scene:onPopScene()
  end
  CCDirector:sharedDirector():popScene()
  ed.memeryGC(10)
end

ed.popScene = popScene

local function replaceScene(scene, skipCheckBattleScene)
  if not ed.asyncload.isCompleted then
    setWillShowScene(scene, "replace", skipCheckBattleScene)
    return
  end
  if 0 < #scene_stack then
    if scene_stack[#scene_stack].identity == "mainScene" then
      if scene.identity == "mainScene" then
        return
      end
      pushScene(scene)
      return
    end
    local scene = table.remove(scene_stack, #scene_stack)
    if scene.onPopScene then
      scene:onPopScene()
    end
  end
  table.insert(scene_stack, scene)
  CCDirector:sharedDirector():replaceScene(scene:ccScene())
  ed.memeryGC(10)
end

ed.replaceScene = replaceScene

local function clearScene(scene)
  for i = 2, #scene_stack do
    ed.popScene()
  end
  ed.memeryGC(10)
  ed.replaceScene(scene, true)
end

ed.clearScene = clearScene
local isNeedReconnect = false

local function applicationDidEnterBackground()
  if ed.player.initialized then
    ed.localnotify.refresh()
  end
  if resume_timestamp and game_server_ip and ed.getUserid() then
    local msg = ed.upmsg.suspend_report()
    msg._gametime = ed.getMillionTime() - resume_timestamp
    resume_timestamp = nil
    ed.send(msg, "suspend_report", true)
  end
  FireEvent("applicationDidEnterBackground")
  if ed.realarena and ed.realarena.mgr and ed.realarena.mgr:IsMatching() then
    ed.realarena.network_mgr:RequestCancelMatch()
    ed.realarena.mgr:LeaveMatching()
  end
  if ed.realarena and ed.realarena.mgr and ed.realarena.mgr.battle then
    ed.socket_long_realarena.recv()
    ed.socket_long_chat.recv()
    local scene = ed.getCurrentScene()
    if (scene.identity == "KingsPvpBanPickScene" or scene.identity == "battle") and not ed.socket_long_realarena.isSocketConnected() and not ed.realarena.mgr:HasNewResult() then
      ed.popScene()
      ListenTimer(Timer:Once(1), function()
        ed.showToast(T("\228\189\160\229\183\178\231\187\143\229\146\140\230\156\141\229\138\161\229\153\168\230\150\173\229\188\128\232\191\158\230\142\165"))
      end)
    end
  end
  if ed.SoloManager then
    ed.socket_long_solo.recv()
    ed.socket_long_chat.recv()
    local scene = ed.getCurrentScene()
    if (scene.identity == "SoloArenaScene" or scene.identity == "SoloBattleScene") and not ed.socket_long_solo.isSocketConnected() then
      ed.popScene()
      ListenTimer(Timer:Once(1), function()
        ed.showToast(T("\228\189\160\229\183\178\231\187\143\229\146\140\230\156\141\229\138\161\229\153\168\230\150\173\229\188\128\232\191\158\230\142\165"))
      end)
    end
  end
  ed.reportClientHUE({
    action_type = "app_enter_background"
  })
end

ed.applicationDidEnterBackground = applicationDidEnterBackground

local function applicationWillEnterForeground()
  ed.socket_long_connection.register()
  resume_timestamp = ed.getMillionTime()
  if ed.checkSoundSwitch then
    ed.checkSoundSwitch()
  end
  SimpleAudioEngine:sharedEngine():stopAllEffects()
  ListenTimer(Timer:Once(0), function()
    FireEvent("applicationWillEnterForeground")
  end)
  if isNeedReconnect and ed.realarena.network_mgr then
    ed.realarena.network_mgr:RequestReconnectHouse()
    isNeedReconnect = false
  end
end

ed.applicationWillEnterForeground = applicationWillEnterForeground

local function runScriptString()
  if not EDFLAGWIN32 then
    return
  end
  local temp = EDGetScriptString()
  if temp ~= nil then
    local func = loadstring(temp)
    if func ~= nil then
      xpcall(func, EDDebug)
    end
  end
end

ed.runScriptString = runScriptString

local function printMemery()
  if not ed.debug_mode then
    return
  end
  CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end

ed.openMemeryGC = false
local gcPassTime = 0

local function memeryGC(fDelTime)
  if not ed.openMemeryGC then
    return
  end
  gcPassTime = gcPassTime + fDelTime
  if ed.getCurrentScene() and ed.getCurrentScene().identity == "battle" then
    return
  end
  if 10 <= gcPassTime then
    EDFcaInfo:removeUnusedInfo()
    if EDFcaSpInfo then
      EDFcaSpInfo:removeUnusedInfo()
    end
    CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
    gcPassTime = 0
  end
end

ed.memeryGC = memeryGC

local function getCurrentScene()
  return scene_stack[#scene_stack]
end

ed.getCurrentScene = getCurrentScene

local function getCurrentSceneCnt()
  return #scene_stack
end

ed.getCurrentSceneCnt = getCurrentSceneCnt
local DEFAULT_TICK_INTERVAL = 0.125
ed.tick_interval = ed.tick_interval or DEFAULT_TICK_INTERVAL
local game_update_handler_list = {}

local function gameUpdate(dt)
  xpcall(function()
    if willShowScene and ed.asyncload.isCompleted then
      if willShowScene[2] == "replace" then
        replaceScene(willShowScene[1], willShowScene[3])
      elseif willShowScene[2] == "push" then
        pushScene(willShowScene[1])
      end
      willShowScene[1]:ccScene():release()
      willShowScene = nil
    end
    if not resume_timestamp then
      resume_timestamp = ed.getMillionTime()
    end
    dt = math.min(dt, ed.tick_interval)
    if ed.socket_udp then
      ed.socket_udp:Update(dt)
    end
    if ed.multiarena_udp then
      ed.multiarena_udp:update(dt)
    end
    if ed.multiplayer_udp then
      ed.multiplayer_udp:update(dt)
    end
    if ed.multistage_udp then
      ed.multistage_udp:update(dt)
    end
    ed.proc_net()
    if ed.ui.newbie then
      ed.ui.newbie:updateNewbie()
    end
    ed.socket_long.proc_net()
    ed.rechargeNetwork.proc_net()
    ed.socket_long_chess.proc_net()
    ed.socket_long_realarena.proc_net()
    ed.socket_long_solo.proc_net()
    genericNetwork.connectionManager:update(dt)
    if not resource_config.LongConnection_close then
      ed.socket_long_connection.proc_net(dt)
    end
    local scene = scene_stack[#scene_stack] or {}
    if scene.update then
      scene:update(dt)
    end
    runScriptString()
    UpdateEventSystem(dt)
    ed.datatableGC(dt)
    for k, v in pairs(game_update_handler_list or {}) do
      v(dt)
    end
    ed.asyncload.update()
  end, EDDebug)
end

ed.gameUpdate = gameUpdate

local function registerGameUpdateHandler(key, handler)
  game_update_handler_list = game_update_handler_list or {}
  game_update_handler_list[key] = handler
end

ed.registerGameUpdateHandler = registerGameUpdateHandler

local function removeGameUpdateHandler(key)
  game_update_handler_list = game_update_handler_list or {}
  game_update_handler_list[key] = nil
end

ed.removeGameUpdateHandler = removeGameUpdateHandler

local function loadTranslationCache()
  if EDCurLanguage == "cn" then
    return
  end
  local list = {
    "datatable",
    "gamedatatables/gamedatatables"
  }
  for i, v in ipairs(list) do
    require(v)
  end
  ed.loadTextCache()
end

function _g_checkLatestVersion()
  if ed.ui.logo and ed.ui.logo.checkLatestVersion then
    ed.ui.logo.checkLatestVersion()
  else
    EDLog("ed.ui.logo.checkLatestVersion is nil!!!")
  end
end

local function cleanSpriteAll()
  print("EDLuaReset", EDLuaReset)
  if EDLuaReset and EDLuaReset == 1 then
    EDLog("============Notes WE CLEAN THE SPRITE ALL==================")
    EDFcaInfo:removeUnusedInfo()
    if EDFcaSpInfo then
      EDFcaSpInfo:removeUnusedInfo()
    end
    CCTextureCache:sharedTextureCache():removeAllTextures()
    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
  end
end

local function initGameData()
  loadTranslationCache()
  ed.loadAllFiles()
  sdkLogin:initLoginMode()
  ed.initDatatableGCGap(60)
  ed.initDatatableReleaseGap(600)
  genericNetwork.connectionManager:init()
  main()
end

xpcall(function()
  local ed = ed
  ed.run_with_scene = true
  cleanSpriteAll()
  initMultiLanguage()
  initFont()
  initGameData()
end, EDDebug)

function NeoDebugPrint()
  for i, k in ipairs(ed.scene_stack) do
    print("Neo print: Scene", i, ": ", k.identity)
  end
end

ed.nd = NeoDebugPrint

local function showNodeTree(...)
  if EDFLAGWIN32 then
    require("debug/nodetree/init")
  end
end

ed.snt = showNodeTree
