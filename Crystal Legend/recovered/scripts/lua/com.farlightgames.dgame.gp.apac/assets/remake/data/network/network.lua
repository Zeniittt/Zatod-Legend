local ed = ed
require("lua_socket")
require("config")
require("mycrypto")
local connect = socket.connect
local connection
local connect_succ = false
local close
local use_long_con = true
local long_connection
local long_connect_succ = false
local long_close_func, long_connect_send_func
local long_connect_last_sendtime = 0
local long_waiting_retry = false
local long_failed_times = 0
local bSendblock = false
local currentMsg, currentMsgType
local netSequence = 0
local up = pb_loader("up")()
local down = pb_loader("down")()
local common = pb_loader("common")()
local upmsg = up.up_msg
local downmsg = down.down_msg
local insert = table.insert
local ipairs = ipairs
local up_code
ed.upmsg = up
ed.downmsg = down
ed.commonmsg = common
ed.connect_timeout = ed.connect_timeout or 5
local cryptkey = "182173557"
local user_id = ed.config.user_id
local role_id = ed.config.role_id
local ip_location
local device_id = ed.config.device_id or EDGetDeviceID()
local accessToken, rechargeURL, chargeEnv, is_adult
local Net = {}
ed.Net = Net
local instance
local net_queue = ed.network_queue.create()

function Net.getInstance()
  if instance == nil then
    local self = {}
    setmetatable(self, Net)
    Net.__index = Net
    instance = Net
    return self
  end
  return instance
end

local function getAccessToken()
  return accessToken
end

ed.getAccessToken = getAccessToken

local function setAccessToken(token)
  accessToken = token
end

ed.setAccessToken = setAccessToken

local function getRechargeURL()
  return rechargeURL
end

ed.getRechargeURL = getRechargeURL

local function getChargeENV()
  return chargeEnv or ""
end

ed.getChargeENV = getChargeENV

local function setDeviceId(id)
  device_id = id
end

ed.setDeviceId = setDeviceId

local function getDeviceId()
  return device_id
end

ed.getDeviceId = getDeviceId

local function setIsAdult(bAdult)
  is_adult = bAdult
end

ed.setIsAdult = setIsAdult

local function getIsAdult()
  if EDFLAGWIN32 then
    return false
  end
  return true
end

ed.getIsAdult = getIsAdult

local function setCryptKey(key)
  print("setCryptKey", key, "len: " .. #key)
  cryptkey = string.sub(key, 1, 16)
end

ed.setCryptKey = setCryptKey

function ed.getCryptKey()
  return cryptkey
end

local function getUserid()
  return user_id
end

ed.getUserid = getUserid

local function setUserid(id)
  user_id = id
end

ed.setUserid = setUserid

local function setRoleId(roleId)
  role_id = roleId
end

ed.setRoleId = setRoleId

local function getRoleId()
  return role_id
end

ed.getRoleId = getRoleId

local function setIpLocation(ipLocation)
  ip_location = ipLocation
end

ed.setIpLocation = setIpLocation

local function getIpLocation()
  return ip_location or ""
end

ed.getIpLocation = getIpLocation
device_id = device_id or "visitor"
local configData = {}
local replyHandler = {}
ed.netdata = configData
ed.netreply = replyHandler
local loadLayer = {}
local loadFunc = {}

local function doTouchLoad()
  return true
end

local function load(noflower, bReSend, showFlowerTime)
  local count = 0
  local outTime = 5
  local countRotate = 0
  local count_gap = 0.8
  local resend = true
  if bReSend ~= nil then
    resend = bReSend
  end
  local isLoading
  local showFlowerTime = showFlowerTime or 1.5
  
  local function createFlower(scene)
    if not tolua.isnull(loadLayer.layer) then
      if count > showFlowerTime and not isLoading then
        loadLayer.flowerbg:setVisible(true)
        isLoading = true
      end
      return
    end
    local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(doTouchLoad, false, -5000, true)
    if scene.mainLayer then
      scene.mainLayer:addChild(layer, 600)
    elseif scene.content_layer then
      scene.content_layer:addChild(layer, 600)
    end
    loadLayer.layer = layer
    if not tolua.isnull(loadLayer.flower) then
      return true
    end
    local bg = CCLayerColor:create(ccc4(0, 0, 0, 50))
    layer:addChild(bg)
    bg:setVisible(false)
    loadLayer.flowerbg = bg
    ed.layout.centerInScreen(bg)
    local fca = ed.createFcaNode("eff_UI_Main_Loading")
    local img_load
    if ed.isAreaZhCn() then
      img_load = ed.createSprite("UI/alpha/1080P/common/dfgs.png")
    else
      img_load = ed.createSprite("UI/alpha/1080P/common/dfgs-global.png")
      img_load:setPositionX(-5)
    end
    local img_node = CCSprite:create()
    img_node:addChild(img_load)
    fca:addNodeToComponent(img_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    bg:addChild(fca)
    ed.layout.centerInScreen(fca)
    if scene.addFca then
      scene:addFca(fca)
    end
  end
  
  local numOfDot = 0
  
  local function handler(dt)
    dt = dt or 0
    count = count + dt
    if count > outTime and resend then
      loadFunc.loadEnd()
      if use_long_con then
        long_close_func()
      else
        close()
      end
      FireEvent("SendMsgFail")
    end
    if noflower then
      return
    end
    local scene = ed.getCurrentScene()
    if isLoading and tolua.isnull(loadLayer.layer) then
      return
    end
    createFlower(scene)
  end
  
  return handler
end

local function loadBegin(noflower, bReSend, showFlowerTime)
  loadFunc.loadEnd()
  if not loadLayer.id then
    local loading = load(noflower, bReSend, showFlowerTime)
    local scene = CCDirector:sharedDirector():getRunningScene()
    if not tolua.isnull(scene) then
      loadLayer.scheduler = scene:getScheduler()
      loadLayer.id = loadLayer.scheduler:scheduleScriptFunc(loading, 0, false)
    end
  end
end

loadFunc.loadBegin = loadBegin
ed.loadBegin = loadBegin

local function loadEnd()
  if loadLayer.id then
    loadLayer.scheduler:unscheduleScriptEntry(loadLayer.id)
    loadLayer.id = nil
  end
  if not tolua.isnull(loadLayer.layer) then
    loadLayer.layer:removeFromParentAndCleanup(true)
  end
  loadLayer = {}
end

loadFunc.loadEnd = loadEnd
ed.loadEnd = loadEnd

function ed.getNetPackDeviceId(ttype)
  local device = device_id
  if not ed.ui.debuglogin.isWin32 and not EDNativeDebug then
    if sdkLogin.isNewLoginMode() and ttype == "sdk_login" then
      device = device_id
    else
      device = string.format("%d-%s", ed.ui.serverlogin.getRealPlatId(), device_id)
    end
  end
  return device
end

local function pack_size(code, ttype)
  local device = ed.getNetPackDeviceId(ttype)
  local mode = 0
  if ttype == "sdk_login" then
    mode = 1
  elseif ttype == "keep_alive" then
    mode = 2
  end
  local newpack = true
  if newpack then
    local len = string.len(device) + string.len(tostring(game_server_id)) + 1
    local third = string.char(len % 256)
    local fourth = string.char(math.floor(len / 256))
    local t_len = #code + len + 2 + 1
    local _first, _second, _third, _fourth = ed.stringutil.split2Bytes(t_len)
    return _first .. _second .. _third .. _fourth .. string.char(mode) .. third .. fourth .. tostring(game_server_id) .. "#" .. device .. code
  else
    local device_len = string.len(device)
    local third = string.char(device_len % 256)
    local fourth = string.char(math.floor(device_len / 256))
    local length = #code + device_len + 2 + 1
    local _first, _second, _third, _fourth = ed.stringutil.split2Bytes(length)
    return _first .. _second .. _third .. _fourth .. string.char(mode) .. third .. fourth .. device .. code
  end
end

function close()
  if connection then
    connection:close()
  end
  connection = nil
  connect_succ = false
  up_code = nil
end

ed.close_net = close
local showFlowerTimeConfig = {
  exit_stage = 1.5,
  fancy_abyss = 1,
  5
}

local function connect(block)
  connection, err = socket.tcp()
  if not connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  connection:settimeout(block and ed.connect_timeout or 0)
  local err
  connect_succ, err = connection:connect(game_server_ip, game_server_port)
  if connect_succ then
    EDLog("    connect succ")
    local r1, r2 = connection:send(up_code)
    if r1 then
      EDLog("<<< Message Sent  @ " .. ed.getYMDHMSTime())
    elseif err then
      EDLog(string.format("ERROR | connection:send failed | %s", err))
    else
      EDLog(string.format("ERROR | connection:send failed ,but no err"))
    end
    close()
  elseif block then
    EDLog(string.format("ERROR | Blocked Connect failed | %s", err))
    return false
  else
    EDLog("    connect start", currentMsgType)
    local notShowFlower = true
    if not ed.isElementInTable(currentMsgType, {
      "reset_elite",
      "query_data"
    }) then
      notShowFlower = nil
    end
    if currentMsgType == "stargate" and currentMsg._stargate._challenge then
      notShowFlower = true
    end
    loadBegin(notShowFlower, nil, showFlowerTimeConfig[currentMsgType])
    return true
  end
end

local function sleep(time)
  pcall(function()
    socket.select(nil, nil, time)
  end)
end

local function block_send(conn, data)
  local retry_time = 10
  local sent = 0
  local ret, err
  repeat
    ret, err, sent = conn:send(data, sent + 1, -1)
    if err and err == "timeout" and type(sent) == "number" then
      print("block_send -- " .. sent .. "/" .. data:len() .. " retry:" .. retry_time)
    else
      return ret, err
    end
    retry_time = retry_time - 1
    sleep(0.1)
  until retry_time <= 0
end

local function connect_resume()
  if connect_succ or not connection then
    return
  end
  EDLog("connect_resume ")
  local r, w, e = socket.select({connection}, {connection}, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = connection:connect(game_server_ip, game_server_port)
  if errstr ~= "already connected" then
    EDLog("    send data:" .. up_code:len() .. " already connected")
    return
  end
  connect_succ = true
  EDLog("    connect succ")
  local r1, r2 = block_send(connection, up_code)
  if r2 then
    EDLog("    send data:" .. up_code:len() .. " error:" .. r2)
  else
    EDLog("    send data:" .. up_code:len() .. " success")
  end
  if not r1 then
    ed.showNetToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(11)")
    close()
    return
  end
  EDLog("<<< Message Sent  @ " .. ed.getYMDHMSTime())
end

local sendCache = {}
local deleteCache = {}

local function delaySend(obj, ttype, deleteOnSent)
  EDLog("<<< Delay send msg: " .. ttype)
  sendCache[ttype] = obj
  if deleteOnSent then
    deleteCache[ttype] = obj
  end
end

ed.delaySend = delaySend

local function doSend(block, ttype)
  if nil == currentMsg then
    return false
  end
  local code, err = currentMsg:Serialize()
  local cipher_code
  if code then
    cipher_code = mycrypto.encrypt(code, cryptkey)
  else
    EDDebug(err)
  end
  up_code = pack_size(cipher_code, ttype)
  if use_long_con then
    long_connect_send_func()
    return true
  else
    local r = false
    if block then
      r = connect(block)
    else
      r = connect()
      if not r then
        return r
      end
    end
    return true
  end
end

local function reSend()
  if nil == currentMsg then
    return
  end
  currentMsg._repeat = 1
  doSend(bSendblock, currentMsgType)
end

local function queueSend()
  if use_long_con and up_code then
    return false
  end
  if connection then
    return false
  end
  if net_queue:isEmpty() then
    return false
  end
  local msg_data = net_queue:outQueue()
  if not msg_data then
    return false
  end
  local obj = msg_data.obj
  local ttype = msg_data.ttype
  local block = msg_data.block
  EDLog("<<< Sending msg: " .. ttype)
  currentMsg = nil
  currentMsg = upmsg()
  currentMsg._repeat = 0
  currentMsg._user_id = user_id
  currentMsg._sequence = netSequence
  currentMsg["_" .. ttype] = obj
  bSendblock = block or false
  currentMsgType = ttype
  for k, v in pairs(sendCache or {}) do
    currentMsg["_" .. k] = v
    if deleteCache[k] then
      sendCache[k] = nil
      deleteCache[k] = nil
    end
  end
  return doSend(block, ttype)
end

local send_time_record = {}

local function checkSendIllegal()
  local gap = 15
  local frequency = 10
  local nt = ed.getSystemTime()
  if frequency > #send_time_record then
    table.insert(send_time_record, nt)
    return true
  else
    local t = send_time_record[1]
    if gap < nt - t then
      table.remove(send_time_record, 1)
      table.insert(send_time_record, nt)
      return true
    else
      return false
    end
  end
  return true
end

local function send(obj, ttype, block)
  if not game_server_ip then
    return
  end
  local lastObj = net_queue:findObj(net_queue:getlength())
  local targetObj = lastObj and lastObj.obj or nil
  if net_queue:checkDataIsSame(obj, targetObj) then
    EDLog("<<< data have same in then queue: " .. ttype)
    return false
  end
  local newData = {
    obj = obj,
    ttype = ttype,
    block = block
  }
  net_queue:enterQueue(newData)
  local bool = queueSend()
  return bool
end

ed.send = send

local function recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = connection:receive(size_left)
  if err == "closed" then
    EDLog("    socket closed")
    return nil
  elseif err == "timeout" then
    buffer = buffer .. partial
    EDLog("    socket timeout")
    return recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return recv_buffer(size_left - #content, buffer)
  end
end

local function recv()
  if not connection then
    return
  end
  local buffer_size_str, err = connection:receive(4)
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 * 256 * 256 + string.byte(buffer_size_str, 2) * 256 * 256 + string.byte(buffer_size_str, 3) * 256 + string.byte(buffer_size_str, 4)
  local buffer = recv_buffer(buffer_size, "")
  if buffer then
    EDLog("    --recv_buffer:" .. buffer:len())
  end
  close()
  if buffer then
    netSequence = netSequence + 1
    EDLog(">>> Data Received @ " .. ed.getYMDHMSTime())
    loadEnd()
    local plaincode = mycrypto.decrypt(buffer, cryptkey)
    local msg, err = downmsg():Parse(plaincode)
    if msg then
      ed.dispatch(msg)
      queueSend()
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end

local function setConnectionOption()
  long_connection:setoption("keepalive", true)
  local ret = long_connection:setoption("tcp-nodelay", true)
  if ret == 1 then
    print("long-tcp-nodelay", ret)
  end
end

local function long_close()
  print("long connection close", debug.traceback())
  if long_connection then
    long_connection:close()
  end
  long_connection = nil
  long_connect_succ = false
end

long_close_func = long_close

local function isLongConnected()
  if long_connect_succ then
    return true
  end
  if not long_connection then
    local err
    long_connection, err = socket.tcp()
    EDLog("    new long connection")
    if not long_connection then
      EDLog(string.format("ERROR | Connect failed when creating long connect socket | %s", err))
      return false
    end
    long_connection:settimeout(0)
    long_connect_succ, err = long_connection:connect(game_server_ip, game_server_port)
    if long_connect_succ then
      EDLog("    long connect succ directly")
      long_connection:settimeout(0)
      setConnectionOption()
      return true
    else
      loadBegin()
    end
  else
    local r, w, e = socket.select({long_connection}, {long_connection}, 0.02)
    if not w or e == "timeout" then
      return false
    end
    local ret, errstr = long_connection:connect(game_server_ip, game_server_port)
    if errstr ~= "already connected" then
      return false
    end
    long_connect_succ = true
    EDLog("    long connect succ")
    long_connection:settimeout(0)
    setConnectionOption()
    loadEnd()
    return true
  end
  return false
end

local function long_connect_keep_alive()
  if not long_connection then
    return
  end
  local cur_time = ed.getMillionTime()
  if cur_time - long_connect_last_sendtime < 10 then
    return
  end
  local isLongConned = isLongConnected()
  if not isLongConned then
    return
  end
  local keep_alive_code = pack_size("", "keep_alive")
  long_connect_last_sendtime = ed.getMillionTime()
  local r1, r2 = block_send(long_connection, keep_alive_code)
  if r2 then
    EDLog("    send data:" .. keep_alive_code:len() .. " error:" .. r2)
  else
  end
  if not r1 then
    ed.showNetToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(12)")
    long_close()
    return
  end
  EDLog("<<< Message Sent  @ " .. ed.getYMDHMSTime())
end

local function long_connect_send()
  queueSend()
  if up_code == nil then
    return
  end
  local isLongConned = isLongConnected()
  if not isLongConned then
    return
  end
  print("long_connection send start:", currentMsgType)
  local notShowFlower = true
  if not ed.isElementInTable(currentMsgType, {
    "reset_elite",
    "query_data"
  }) then
    notShowFlower = nil
  end
  loadBegin(notShowFlower, nil, showFlowerTimeConfig[currentMsgType])
  long_connect_last_sendtime = ed.getMillionTime()
  local r1, r2 = block_send(long_connection, up_code)
  if r2 then
    EDLog("    send data:" .. up_code:len() .. " error:" .. r2)
  else
    EDLog("    send data:" .. up_code:len() .. " success")
    up_code = nil
  end
  if not r1 then
    if currentMsgType == "sdk_login" or currentMsgType == "login" then
      ed.reportHUE({
        action_type = "send_msg_failed",
        message_type = currentMsgType or ""
      })
    end
    long_close()
    return
  end
  EDLog("<<< Message Sent  @ " .. ed.getYMDHMSTime())
end

long_connect_send_func = long_connect_send

local function long_recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = long_connection:receive(size_left)
  if err == "closed" then
    EDLog("    long socket closed")
    return nil
  elseif err == "timeout" then
    buffer = buffer .. partial
    EDLog("    long socket timeout")
    return long_recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return long_recv_buffer(size_left - #content, buffer)
  end
end

local function long_recv()
  if not long_connection then
    return
  end
  local buffer_size_str, err = long_connection:receive(4)
  if long_connect_succ and err == "closed" then
    print("get error \"socket closed\" when try receive data!")
    long_close()
    return
  end
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 * 256 * 256 + string.byte(buffer_size_str, 2) * 256 * 256 + string.byte(buffer_size_str, 3) * 256 + string.byte(buffer_size_str, 4)
  local buffer = long_recv_buffer(buffer_size, "")
  EDLog("    --recv_buffer:" .. buffer:len())
  local lag = ed.getMillionTime() - long_connect_last_sendtime
  if ed.ui.server_ping then
    ed.ui.server_ping:SetLag(math.floor(lag * 1000))
  end
  if buffer then
    netSequence = netSequence + 1
    EDLog(">>> Data Received @ " .. ed.getYMDHMSTime())
    loadEnd()
    local plaincode = mycrypto.decrypt(buffer, cryptkey)
    local msg, err = downmsg():Parse(plaincode)
    if msg then
      ed.dispatch(msg)
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end

local function proc_net()
  if not game_server_ip then
    return
  end
  if use_long_con then
    if long_waiting_retry then
      return
    end
    long_connect_send()
    long_recv()
    long_connect_keep_alive()
  else
    connect_resume()
    recv()
  end
end

ed.proc_net = proc_net

local function registerNetReply(key, handler, data)
  ed.netreply[key] = handler
  ed.netdata[key] = data
end

ed.registerNetReply = registerNetReply

local function getNetReply(key)
  if not key then
    print("getNetReply : no key , no return")
    return
  end
  local handler = ed.netreply[key]
  local data = ed.netdata[key]
  ed.netreply[key] = nil
  ed.netdata[key] = nil
  return handler, data
end

ed.getNetReply = getNetReply

local function dealPlatformData()
  local newplayer = not ed.guide.data:isCompleted(5)
  local newplayerFlag = newplayer and "1" or "0"
  local info = {
    deviceid = string.format("%s-%s", EDSDKType, ed.getDeviceId()),
    serverid = game_server_id,
    gameName = T("\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135"),
    userid = ed.getUserid(),
    uuid = ed.player:getUUID(),
    servername = game_server_name,
    vip = ed.player:getvip(),
    level = ed.player:getLevel(),
    roleName = ed.ignoreEmj(ed.player:getName()) or "",
    guildName = ed.ignoreEmj(ed.player:getGuildName()) or "",
    guilId = ed.player:getGuildId(),
    extra = "",
    new_player = newplayerFlag,
    rmb = ed.player._rmb,
    pay_rmb = ed.player._rmb_pay or 0,
    free_rmb = ed.player._rmb_free or 0
  }
  if EDFLAGANDROID then
    EDAndroidExtra("setGameData", ed.getJson(info))
  elseif EDFLAGIOS then
    EDIOSExtra("setGameData", ed.getJson(info))
  end
end

ed.dealPlatformData = dealPlatformData
ed.client_runtime_version = ed.client_runtime_version
local scene_white_list = {
  battlePrepare = true,
  battle = true,
  awake = true
}

local function dispatch(msg)
  for k, v in pairs(msg[".data"]) do
    EDLog(">>> down msg: " .. k)
  end
  if ed.gmNetReplyHander then
    ed.gmNetReplyHander()
  end
  ed.dispatch_part_one(msg)
  ed.dispatch_part_two(msg)
  ed.dispatch_part_three(msg)
  ed.dispatch_part_four(msg)
end

ed.dispatch = dispatch

local function dispatch_part_one(msg)
  local net = Net.getInstance()
  if msg._client_update_version then
    net:client_update_version(msg)
  end
  if msg._login_reply then
    net:login_reply(msg)
  end
  if msg._reset then
    EDLog("Client data reset by server!")
    local user = msg._reset._user
    user_id = user._userid
    role_id = user._role_id
    ed.player:setup(user)
    FireEvent("SetNameSuccess")
  end
  if msg._test_battle_check_reply then
    FireEvent("TestBattleCheckReply", msg._test_battle_check_reply)
  end
  if msg._svr_time then
    net:svr_time(msg)
  end
  if msg._sync_timestamps_reply then
    net:sync_timestamps_reply(msg)
  end
  if msg._btc_ctrl_notify then
    print("received btc_ctrl_notify")
    ed.btc_ctrl_notify = msg._btc_ctrl_notify
    do_battle_log = ed.btc_ctrl_notify._open_btlog == 1
  end
  if msg._enter_stage_reply then
    net:enter_stage_reply(msg)
  end
  if msg._exit_stage_reply then
    net:exit_stage_reply(msg)
  end
  if msg._consume_item_reply then
    net:consume_item_reply(msg)
  end
  if msg._equip_synthesis_reply then
    net:equip_synthesis_reply(msg)
  end
  if msg._wear_equip_reply then
    net:wear_equip_reply(msg)
  end
  if msg._shop_refresh_reply then
    FireEvent("shopRefreshReply", msg._shop_refresh_reply)
  end
  if msg._cosmetic_shop_reply then
    FireEvent("cosmeticShopReply", msg._cosmetic_shop_reply)
  end
  if msg._star_shop_refresh_reply then
    FireEvent("StarShopRefresh", msg._star_shop_refresh_reply._star_shop)
  end
  if msg._shop_consume_reply then
    FireEvent("shop_consume_reply", msg._shop_consume_reply)
  end
  if msg._simple_shop_reply then
    FireEvent("shop_consume_reply", msg._simple_shop_reply)
  end
  if msg._goback_reply then
    ed.GobackNetwork:dispatch(msg._goback_reply)
  end
  if msg._sell_item_reply then
    net:sell_item_reply(msg)
  end
  if msg._legend_equip_item_notify then
    ed.legendEquipNet.itemNotify(msg._legend_equip_item_notify)
  end
  if msg._fragment_compose_reply then
    net:fragment_compose_reply(msg)
  end
  if msg._hero_equip_upgrade_reply then
    net:hero_equip_upgrade_reply(msg)
  end
  if msg._hero_upgrade_reply then
    net:hero_upgrade_reply(msg)
  end
  if msg._open_shop_reply then
    net:open_shop_reply(msg)
  end
  if msg._shop_switch_reply then
    net:shop_switch_reply(msg)
  end
  if msg._error_info then
    ed.preprocessNetError(msg)
  end
  if msg._super_link then
    net:super_link(msg)
  end
  if msg._battle_check_fail then
    net:battle_check_fail(msg)
  end
  if msg._sync_vitality_reply then
    net:sync_vitality_reply(msg)
  end
  if msg._trigger_task_reply then
    net:trigger_task_reply(msg)
  end
  if msg._require_rewards_reply then
    net:require_rewards_reply(msg)
  end
  if msg._get_vip_gift_reply then
    net:get_vip_gift_reply(msg)
  end
  if msg._job_rewards_reply then
    net:job_rewards_reply(msg)
  end
  if msg._reset_elite_reply then
    net:reset_elite_reply(msg)
  end
  if msg._sweep_stage_reply then
    net:sweep_stage_reply(msg)
  end
  if msg._skill_levelup_reply then
    ed.heroDetailManager:dealSkillLevelup(msg._skill_levelup_reply)
  end
  if msg._astrolabe_reply then
    ed.heroDetailManager:handleAstrolabe(msg._astrolabe_reply)
  end
  if msg._hero_recycle_reply then
    ed.HeroRecycleNet.dispatch(msg._hero_recycle_reply)
  end
  if msg._daily_login_reward_reply then
    net:ask_daily_login_reply(msg)
  end
  if msg._recharge_polling_reply then
    net:recharge_polling_reply(msg)
  end
  if msg._query_act_stage_reply then
    local handler, data
    handler, data = ed.getNetReply("query_act_stage_equipcraft")
    if handler then
      handler(msg._query_act_stage_reply)
    end
    ed.exerciseNetWork:dispatch(msg)
  end
  if msg._ask_pred_stage_reply then
    FireEvent("futureActRsp", msg._ask_pred_stage_reply.stage_id)
  end
  if msg._select_stage_reward_reply then
    if msg._select_stage_reward_reply._result == "success" then
      ed.player:refreshStageSelectReward(msg._select_stage_reward_reply._stage_id, msg._select_stage_reward_reply._reward_id)
    end
    FireEvent("stageRewardReply", msg._select_stage_reward_reply)
  end
  if msg._all_star_reply then
    FireEvent("allStarReply", msg._all_star_reply)
  end
end

ed.dispatch_part_one = dispatch_part_one

local function dispatch_part_two(msg)
  local net = Net.getInstance()
  if msg._hero_evolve_reply then
    net:hero_evolve_reply(msg)
  end
  if msg._ladder_reply then
    net:ladder_reply(msg)
  end
  if msg._dreamland_reply then
    FireEvent("DreamlandRsp", msg._dreamland_reply)
  end
  if msg._tbc_reply then
    ed.CrusadeNetwork:dispatch(msg._tbc_reply)
  end
  if msg._set_name_reply then
    net:set_name_reply(msg)
  end
  if msg._set_avatar_reply then
    net:set_avatar_reply(msg)
  end
  if msg._remote_setting_reply then
    net:remote_setting_reply(msg)
  end
  if msg._medal_reply then
    ed.player:setMedal(msg._medal_reply)
    FireEvent("medal_reply", msg._medal_reply)
  end
  if msg._midas_reply then
    ed.ui.midasWin.dealUse(msg._midas_reply)
    FireEvent("midas_reply", msg._midas_reply)
  end
  if msg._get_maillist_reply then
    net:get_maillist_reply(msg)
  end
  if msg._read_mail_reply then
    net:read_mail_reply(msg)
  end
  if msg._cut_read_mail_reply then
    net:cut_read_mail_reply(msg)
  end
  if msg._sdk_login_reply then
    net:sdk_login_reply(msg)
  end
  if msg._cdkey_gift_reply then
    net:cdkey_gift_reply(msg)
  end
  if msg._notify_msg then
    net:notify_msg(msg)
  end
  if msg._monthcard_reply then
    FireEvent("GetMonthCardReward", msg._monthcard_reply)
  end
  if msg._chat_reply then
    FireEvent("ChatRsp", msg._chat_reply)
    ed.chatNetWork:dispatch(msg._chat_reply)
  end
  if msg._guild_reply then
    ed.GuildNetwork:dispatchReply(msg._guild_reply)
  end
  if msg._guild_raid_reply then
    ed.GuildRaidNetwork:dispatchReply(msg._guild_raid_reply)
  end
  if msg._query_replay then
    local reply = msg._query_replay
    local record = reply._record
    local handler, data = ed.getNetReply("query_replay")
    if handler then
      handler(record, (data or {}).mode)
    end
  end
  if msg._query_ranklist_reply then
    FireEvent("query_ranklistdata_reply", msg._query_ranklist_reply)
    local handler = ed.getNetReply("query_ranklist_reply")
    if handler then
      handler(msg._query_ranklist_reply)
    end
    if msg._query_ranklist_reply._rank_type == "dreamland_individual" then
      FireEvent("query_ranklist_dreamland_guild", msg._query_ranklist_reply)
    end
  end
  if msg._request_guild_log_reply then
    local handler = ed.getNetReply("query_guildlog")
    if handler then
      handler(msg._request_guild_log_reply)
    end
  end
  if msg._real_arena_reply then
    FireEvent("RealArenaRsp", msg._real_arena_reply)
  end
end

ed.dispatch_part_two = dispatch_part_two

local function dispatch_part_three(msg)
  local net = Net.getInstance()
  if msg._change_task_status_reply then
    net:change_task_status_reply(msg)
  end
  if msg._update_backdoor_reply then
    local reply = msg._update_backdoor_reply
    Backdoor.init(reply._version, reply._data)
  end
  if msg._tutorial_reply then
    local result = msg._tutorial_reply._result
    sendCache.tutorial = nil
    local handler = ed.netreply.tutorial
    if handler then
      handler()
      ed.netreply.tutorial = nil
    end
  end
  if msg._sync_vitality_reply then
    ed.player._vitality = msg._sync_vitality_reply._vitality
    sendCache.sync_vitality = nil
  end
  if msg._migrate_reply then
    ed.ui.changeServerNetwork.dispatch(msg._migrate_reply)
  end
  if msg._consume_exp_items_reply then
    FireEvent("ConsumeExpItemReply", msg._consume_exp_items_reply)
  end
  if msg._sort_item_reply and msg._sort_item_reply._result == "success" then
    local handler = ed.getNetReply("package_sort_item")
    if handler then
      handler()
    end
  end
  if msg._multiplayer_reply then
    FireEvent("MultiplayerDispatch", msg._multiplayer_reply)
  end
  if msg._monster_reply then
    FireEvent("monster_reply", msg._monster_reply)
  end
  if msg._fragment_compose_auto_reply then
    FireEvent("fragment_compose_auto", msg._fragment_compose_auto_reply)
  end
  if msg._multi_arena_reply then
    FireEvent("multi_arena_reply", msg._multi_arena_reply)
  end
  if msg._query_guild_members_reply then
    FireEvent("pvpGuildMembers", msg._query_guild_members_reply)
  end
  if msg._herohot_reply then
    ed.HeroRecommendNetwork:dispatch(msg._herohot_reply)
  end
end

ed.dispatch_part_three = dispatch_part_three

local function dispatch_part_four(msg)
  if msg._pet_reply then
    ed.PetNetwork:dispatch(msg._pet_reply)
  end
  if msg._personal_home_page_reply then
    FireEvent("player_info_reply", msg._personal_home_page_reply)
  end
  if msg._onekey_sweep_stage_reply then
    FireEvent("onekeySweepStageEvent", msg._onekey_sweep_stage_reply)
  end
  if msg._video_reply then
    ed.videoplayer.network:dispatch(msg._video_reply)
  end
  if msg._gm_ext_reply then
    ed.gmtools.network:dispatch(msg._gm_ext_reply)
  end
  if msg._binding_reply and ed.netreply.bingphone then
    ed.netreply.bingphone(msg._binding_reply)
    ed.netreply.bingphone = nil
  end
  if msg._chess_reply then
    ed.AutoChessNetwork:dispatchChessReply(msg._chess_reply)
  end
  if msg._solo_reply then
    ed.SoloNetwork:dispatchChessReply(msg._solo_reply)
  end
  if msg._team_reply then
    if ed.TeamNetwork.teamTarget == "chess" then
      ed.TeamNetwork.dispatch(msg._team_reply)
    else
      ed.SoloNetwork:dispatchChessTeamReply(msg._team_reply)
    end
  end
  if msg._impulse_gift_reply then
    ed.RechargeNetwork:dispatchEnjoyGift(msg._impulse_gift_reply)
  end
  if msg._cup_arena_reply then
    ed.CupArenaNetwork:dispatch(msg._cup_arena_reply)
  end
  if msg._mall_gift_reply then
    ed.RechargeNetwork:dispatchNewGift(msg._mall_gift_reply)
  end
  if msg._open_simple_chest_reply and ed.netreply.openSimpleChestReply then
    ed.netreply.openSimpleChestReply(msg._open_simple_chest_reply)
    ed.netreply.openSimpleChestReply = nil
  end
  if msg._activity_hint_reply then
    ed.activityHints:activityHintReply(msg._activity_hint_reply)
  end
  if msg._fancy_tower_reply then
    ed.SkillTowerNetwork:dispatchTowerReply(msg._fancy_tower_reply)
  end
  if msg._fancy_abyss_reply then
    ed.SkillTowerNetwork:dispatchExTowerReply(msg._fancy_abyss_reply)
  end
  if msg._peak_arena_reply then
    ed.PeakArenaNetwork:dispatch(msg._peak_arena_reply)
  end
  if msg._guild_clash_reply then
    ed.GuildClashNetwork:dispatch(msg._guild_clash_reply)
  end
  if msg._soul_exchange_reply then
    FireEvent("SoulExchangeReply", msg._soul_exchange_reply)
  end
  if msg._retrieval_reward_reply then
    ed.retrievalRewardNet.dispatch(msg._retrieval_reward_reply)
  end
  if msg._guild_mount_reply then
    ed.GuildMountNetwork:dispatchReply(msg._guild_mount_reply)
  end
  if msg._fast_equip_chest_use_reply then
    FireEvent("equipcraftUseChestSuccess", msg._fast_equip_chest_use_reply._result)
  end
  if msg._new_compose_reply then
    if msg._new_compose_reply._open_panel then
      FireEvent("NewComposeDataReady", msg._new_compose_reply._open_panel)
    end
    if msg._new_compose_reply._exchange then
      FireEvent("NewComposeExchange", msg._new_compose_reply._exchange)
    end
  end
  if msg._summon_circle_reply then
    ed.summonNet:dispatch(msg._summon_circle_reply)
  end
  if msg._timely_item_notify then
    ed.ui.package:dispatchTimelyGoods(msg._timely_item_notify)
    for index, timelyItem in ipairs(msg._timely_item_notify._new_timely_item or {}) do
      if not ed.player.expireTimelyItemList then
        ed.player.expireTimelyItemList = {}
      end
      table.insert(ed.player.expireTimelyItemList, timelyItem)
    end
  end
  if msg._achievement_notify then
    local achData = ed.taskData:getPageDataObj("ach")
    local data = msg._achievement_notify
    local num = 0
    for _, v in ipairs(data) do
      if ed.PeakArenaManager.peakArenaAchievementLineId == v._line_id then
        ed.PeakArenaManager:peakArenaAchFcaGroup("add", v)
      else
        ed.showAchFcaGroup(achData:getAchCupType(v._line_id, v._id), T("\230\136\144\229\176\177:%s", achData:getAchName(v._line_id, v._id)))
        num = num + 1
      end
    end
    ed.taskData:achievementRed(num)
  end
  if msg._stage_star_reward_reply then
    FireEvent("stageStarRewardFire", msg._stage_star_reward_reply)
  end
  if msg._resolve_expired_reply and msg._resolve_expired_reply._result == "success" then
    FireEvent("resolveExpiredReply")
  end
  if msg._dailyjob_reply then
    ed.taskNetwork:dailyjobReply(msg._dailyjob_reply)
  end
  if msg._daily_pass_reply then
    ed.taskNetwork:taskPassReply(msg._daily_pass_reply)
  end
  if msg._achievement_reply then
    ed.taskNetwork:achievementReply(msg._achievement_reply)
  end
  if msg._activity_reply then
    FireEvent("scope_activity_reply", msg._activity_reply)
  end
  if msg._act_adventure_reply then
    ed.actiAdventureNet.dispatch(msg._act_adventure_reply)
  end
  if msg._simple_pass_reply then
    ed.passNetWork:dispatch(msg._simple_pass_reply)
  end
  if msg._pull_hero_info_reply then
    for k, v in ipairs(msg._pull_hero_info_reply._heroes) do
      ed.player:resetHero(v)
    end
  end
  if msg._fashion_reply then
    local data = msg._fashion_reply._set_fashion
    if data._result == "success" then
      local hid = data._hero
      local hero = ed.player:getHero(hid)
      hero._gs = data._gs
      hero._fashion = data._fashion
    end
    FireEvent("ChangeHeroSkin", data._result)
  end
  if msg._daily_vitality_reply then
    ed.player:setDailyVitality(msg._daily_vitality_reply)
    FireEvent("daily_vitality_reply", msg._daily_vitality_reply)
  end
  if msg._charge_vault_reply then
    local data = msg._charge_vault_reply
    if data._open_panel then
      FireEvent("OpenSecretBox", data._open_panel)
    elseif data._gain_reward then
      local index = data._gain_reward._index
      FireEvent("ChangeSecretBoxState", index)
      ed.player:addRewards(data._gain_reward._rewards)
      ed.UITool.showRewardsFromServer(data._gain_reward._rewards)
    elseif data._infinite_reward then
      FireEvent("ChangeSecretCircle")
      ed.player:addRewards(data._infinite_reward._rewards)
      ed.UITool.showRewardsFromServer(data._infinite_reward._rewards)
    end
  end
  if msg._sevenday_assist_reply then
    ed.SevenDayNetwork:dispatch(msg._sevenday_assist_reply)
  end
  if msg._lottery_reply then
    FireEvent("activity_lottery_reply", msg._lottery_reply)
  end
  if msg._preset_lineup_reply then
    ed.presetNetwork.presetReply(msg._preset_lineup_reply)
  end
  if msg._awake_dungeon_reply then
    ed.AwakeDungeonNetwork.dispatch(msg._awake_dungeon_reply)
  end
  if msg._heat_reply then
    ed.hadesHeatNet.dispatch(msg._heat_reply)
  end
  if msg._nian_monster_reply then
    ed.nianMonsterNet.dispatch(msg._nian_monster_reply)
  end
  if msg._shard_reply then
    local info = msg._shard_reply
    local heros = info._unlock or info._level_up or info._wear
    ed.player:resetHero(heros._hero)
    FireEvent("shard_reply", info)
  end
  if msg._guild_enlist_reply then
    ed.GuildRecruitNetwork:dispatchReply(msg._guild_enlist_reply)
  end
  if msg._manual_trigger_reply then
    FireEvent("manual_trigger_reply", msg._manual_trigger_reply)
  end
  if msg._rogue_reply then
    ed.rogueLikeNet.dispatch(msg._rogue_reply)
  end
  if msg._sweet_party_reply then
    ed.sweetPartyNetwork:dispatch(msg._sweet_party_reply)
  end
  if msg._time_corridor_reply then
    ed.timeCorridorNet:dispatch(msg._time_corridor_reply)
  end
  if msg._point_sync_reply then
    ed.player:pointSync(msg._point_sync_reply)
  end
  if msg._guild_contest_reply then
    FireEvent("activity_arena_competition_reply", msg._guild_contest_reply)
  end
  if msg._dreamland_new_year_reply then
    FireEvent("activity_dreamland_new_year_reply", msg._dreamland_new_year_reply)
  end
  if msg._legend_equip_reply then
    ed.legendEquipNet.dispatch(msg._legend_equip_reply)
  end
  if msg._pirate_shop_reply then
    ed.pirateshopNetwork.dispatch(msg._pirate_shop_reply)
  end
  if msg._simple_assist_reply then
    ed.dayAwardsNetwork:dispatch(msg._simple_assist_reply)
    ed.ActivityNetwork:dispatch(msg._simple_assist_reply)
  end
  if msg._player_shift_reply then
    ed.authenticationNet:dispatch(msg._player_shift_reply)
  end
  if msg._collection_point_reply then
    local reply = msg._collection_point_reply
    if reply._role_info then
      ed.ui.collectionSummaryPop.create(ed.copyProto(reply._role_info))
    elseif reply._set_show then
      FireEvent("collection_point_reply_show", reply._set_show)
    end
  end
  if msg._dragon_boat_reply then
    ed.dragonBoatNet.getInstance():dispatch(msg._dragon_boat_reply)
  end
  if msg._crevice_defend_reply then
    ed.CreviceDefendNetWork:dispatch(msg._crevice_defend_reply)
  end
  if msg._hero_haggle_reply then
    ed.heroHaggleNet.dispatch(msg._hero_haggle_reply)
  end
  if msg._simple_assist_reply then
    ed.heroHaggleNet.taskDispatch(msg._simple_assist_reply)
  end
  if msg._feature_preview_reply then
    ed.featurePreviewNetwork.dispatch(msg._feature_preview_reply)
  end
  if msg._simple_assist_reply then
    ed.riseStarNet:dispatch(msg._simple_assist_reply)
  end
end

ed.dispatch_part_four = dispatch_part_four

function Net:client_update_version(msg)
  if ed.client_runtime_version == nil then
    ed.client_runtime_version = msg._client_update_version._version
    EDLog("initial runtime version:" .. ed.client_runtime_version)
  elseif ed.client_runtime_version ~= msg._client_update_version._version then
    local scene = ed.getCurrentScene()
    if not scene_white_list[tostring(scene.identity)] then
      EDLog("updated runtime version:" .. tostring(msg._client_update_version._version))
      local info = {
        text = T("\228\186\178\231\136\177\231\154\132\233\152\159\233\149\191\239\188\140\230\184\184\230\136\143\230\156\137\230\155\180\230\150\176\239\188\140\232\175\183\233\135\141\229\144\175\230\184\184\230\136\143\232\191\155\229\133\165\229\133\168\230\150\176\231\154\132\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\239\188\129"),
        buttonText = T("\233\128\128\229\135\186"),
        handler = function()
          EDExit()
        end
      }
      ed.showAlertDialog(info)
      ed.client_runtime_version = msg._client_update_version._version
    end
  end
end

function Net:login_reply(msg)
  if msg._login_reply._result == "fail" then
    ed.reportHUE({
      action_type = "gs_login_failed"
    })
    FireEvent("LoginFail")
    return
  end
  if ed.gmCheckPlayerData then
    if ed.netreply.gmCheckPlayerDataCallback then
      ed.netreply.gmCheckPlayerDataCallback(msg._login_reply._user)
      ed.netreply.gmCheckPlayerDataCallback = nil
    end
    return
  end
  ed.setServerTimeZone(msg._login_reply._svr_zone)
  ed.setServerTimestamp(msg._login_reply._server_timestamps)
  ed.player.mergeSvrList = msg._login_reply._merge_svr_list
  FireEvent("LoginReply", msg._login_reply._rt_notify_addr)
  local userId = ed.ui.serverlogin.getUserId()
  EDLog("####_login_reply:userId" .. tostring(userId))
  local firstLogin = ed.storage.getString(userId)
  local user = msg._login_reply._user
  user_id = user._userid
  role_id = user._role_id
  if EDBuglySetUser then
    EDBuglySetUser(role_id)
  end
  ed.player:setup(user)
  if user._shops then
    ed.shopData:initShopsData(user._shops)
  end
  FireEvent("SystemSettingReply", user._system_setting_item)
  local globalConfig = msg._login_reply._cfg
  ed.player:setGlobalConfig(globalConfig)
  local resourceMd5BlackList = msg._login_reply._fca_md5 or {}
  local resourceNameBlackList = msg._login_reply._fca_name or {}
  ed.ResourceMd5BlackList = {}
  ed.ResourceNameBlackList = {}
  for _, md5_string in ipairs(resourceMd5BlackList) do
    ed.ResourceMd5BlackList[md5_string] = true
  end
  for _, name in ipairs(resourceNameBlackList) do
    ed.ResourceNameBlackList[name] = true
  end
  local currentEULAUsers = ed.storage.getString("EULA" .. ed.getDeviceId())
  local array = Split(currentEULAUsers, ":")
  local currentEULA = array[1] or ""
  local currentUser = array[2] or ""
  
  local function doLogin()
    if ed.netreply.loginReply then
      ed.netreply.loginReply()
      ed.netreply.loginReply = nil
    end
    FireEvent("LoginSuc", msg._login_reply._rt_lobby_addr)
  end
  
  if msg._login_reply._migrate_info then
    local data = msg._login_reply._migrate_info
    ed.showAlertDialog({
      text = T("\232\175\165\230\156\141\229\138\161\229\153\168\228\184\139\232\167\146\232\137\178%s\229\183\178\232\191\129\232\135\179%s\229\140\186", data._user_name, data._server_display_id),
      handler = function()
        doLogin()
      end,
      skipDestroyAnim = true
    })
  else
    doLogin()
  end
  ed.dealPlatformData()
  if ed.dreamland.network_mgr == nil then
    ed.dreamland.network_mgr = ed.dreamland.NetworkMgr.Create()
  else
    ed.dreamland.network_mgr:Destroy()
    ed.dreamland.network_mgr = ed.dreamland.NetworkMgr.Create()
  end
  ed.dreamland.mgr = ed.dreamland.DreamlandMgr.Create(msg._login_reply._dreamland)
  if user._goback then
    ed.GobackManager:initServerData(user._goback)
  end
  if msg._login_reply._activity_hints then
    ed.activityHints:createHints(msg._login_reply._activity_hints)
  end
  real_game_server_id = msg._login_reply._real_game_server_id
  real_game_server_name = msg._login_reply._real_game_server_name
  if msg._login_reply._is_new_acc == 1 then
    self:reportAccCreate()
  end
end

function Net:reportAccCreate()
  local serverId = tostring(game_server_id)
  local serverIdInt = tonumber(game_server_id)
  if 29000 < serverIdInt and serverIdInt < 30000 then
    serverId = "qa-" .. serverId
  elseif EDSDKType > 500 then
    serverId = "farlight:global:obt-" .. serverId
  else
    serverId = "official-" .. serverId
  end
  local nInfo = {
    event_value1 = ed.ui.serverlogin.getUserId(),
    event_value2 = ed.getRoleId(),
    event_value3 = {
      open_id = ed.ui.serverlogin.getUserId(),
      server_id = serverId,
      role_id = ed.getRoleId()
    }
  }
  local json = ed.getJson(nInfo)
  if EDReportEvent and EDSDKType > 301 then
    EDReportEvent("acc_create", json)
  end
end

function Net:svr_time(msg)
  local reply = msg._svr_time
  ed.player:initNativeTimeDiff(reply)
  local handler = ed.netreply.syncTime
  if handler then
    handler()
    ed.netreply.syncTime = nil
  end
end

function Net:sync_timestamps_reply(msg)
  local _timestamps = msg._sync_timestamps_reply._timestamps
  ed.setServerTimestamp(_timestamps)
end

function Net:enter_stage_reply(msg)
  ed.srand(msg._enter_stage_reply._rseed)
  if ed.netreply.enterStage then
    ed.netreply.enterStage()
    ed.netreply.enterStage = nil
  end
  ed.player.loots = msg._enter_stage_reply._loots or {}
end

function Net:exit_stage_reply(msg)
  local reply = msg._exit_stage_reply
  local shop = reply._shop
  local dshop = reply._dshop
  local result = reply._result == "known"
  local medal = reply._medal_item
  if reply._exp_bonus and reply._exp_bonus > 0 then
    local bonuxExp = reply._exp_bonus
    ed.player:addExp(bonuxExp)
  end
  if shop then
    local state
    if shop._id > 1 then
      state = "trigger"
    end
    ed.player:refreshShopData(shop, state)
  end
  if dshop then
    ed.player:refreshDiamondShopData(dshop, "trigger")
  end
  local data = ed.netdata.exitStageReply
  if data then
    local stage = data.stage
    local r = data.result
    if result then
      ed.record:chaosFarmStage(stage)
      if r == 0 then
        ed.record:successFarmStage(stage)
        ed.record:successWinBattle(stage)
      end
    end
    ed.netdata.exitStageReply = nil
  end
  if ed.netreply.exitStageReply then
    ed.netreply.exitStageReply(result)
    ed.netreply.exitStageReply = nil
  end
end

function Net:consume_item_reply(msg)
  local reply = msg._consume_item_reply
  if reply._error_code then
    if reply._error_code == "item_is_expire" then
      ed.showToast(T("\232\175\165\233\129\147\229\133\183\229\183\178\231\187\143\232\191\135\230\156\159\239\188\140\230\151\160\230\179\149\228\189\191\231\148\168!"))
    else
      ed.showToast(T("\230\156\170\231\159\165\228\189\191\231\148\168\233\148\153\232\175\175"))
    end
    return
  end
  FireEvent("ConsumeItemSuccess")
  if reply._hero then
    ed.player:resetHero(reply._hero)
    FireEvent("EatExpSuccess")
  end
  if reply._vitality and reply._vitality > ed.player:getVitality() then
    ed.player:addVitality(reply._vitality - ed.player:getVitality())
    FireEvent("EatVitalitySuccess")
  end
  if reply._user_point then
    local user_point = reply._user_point
    for k, v in pairs(user_point) do
      ed.player:addPoint(v._type, v._value)
    end
    FireEvent("EatResSuccess", reply._user_point)
  end
  if reply._items then
    for k, v in pairs(reply._items) do
      ed.player:addEquip(v._id, v._amount)
    end
    FireEvent("ConsumeAddNewitems", reply._items)
  end
end

function Net:equip_synthesis_reply(msg)
  local reply = msg._equip_synthesis_reply
  local result = reply._result == "success"
  local data = ed.netdata.equipCraft
  if result and data.immediate then
    ed.player:addMoney(-data.expense)
    local na = data.consume
    for k, v in pairs(data.node) do
      ed.player:consumeEquip(v, na[k] or 1)
    end
    ed.player:addEquip(data.id)
    FireEvent("composeActivity")
  end
  if ed.netreply.craftReply then
    ed.netreply.craftReply(result)
    ed.netreply.craftReply = nil
  end
end

function Net:wear_equip_reply(msg)
  local reply = msg._wear_equip_reply
  local result = reply._result == "success"
  local gs = reply._gs
  local items = reply._items
  if ed.netdata.putonReply then
    local data = ed.netdata.putonReply
    local hid = data.hid
    local sid = data.sid
    local eid = data.eid
    for k, v in ipairs(eid or {}) do
      ed.player:consumeEquip(v, 1)
    end
    for k, v in ipairs(sid or {}) do
      ed.player.heroes[hid]:equip(v)
    end
    ed.player.heroes[hid]:resetgs(gs)
    ed.netdata.putonReply = nil
  end
  if ed.netreply.putonReply then
    ed.netreply.putonReply(result)
    ed.netreply.putonReply = nil
  end
  if ed.netreply.artifactRewardsReply then
    ed.netreply.artifactRewardsReply(items)
    ed.netreply.artifactRewardsReply = nil
  end
end

function Net:sell_item_reply(msg)
  local reply = msg._sell_item_reply
  local result = reply._result
  local handler, data = ed.getNetReply("sell_item")
  if result then
    local income_list = data.income_list
    for k, v in pairs(income_list) do
      ed.player:addPoint(string.lower(k), v)
    end
    for k, v in pairs(data.items) do
      local id = v._id
      local amount = v._amount
      local insid = v.insid
      ed.player:consumeEquip(id, amount, insid)
    end
  end
  if handler then
    handler(result, data.amount)
  end
end

function Net:fragment_compose_reply(msg)
  local reply = msg._fragment_compose_reply
  local result = reply._result == "success"
  local info = ed.netdata.fragmentCompose
  if result then
    ed.player:addMoney(-info.cost)
    ed.player:consumeEquip(info.id, info.fragmentAmount, info.insid)
    if info.makeId > 100 then
      ed.player:addEquip(info.makeId, info.composeResultAmount)
    else
      ed.player:addHero(info.makeId)
    end
    if ed.netreply.composeFragmentReply then
      ed.netreply.composeFragmentReply(result, info.fragmentAmount)
      ed.netreply.composeFragmentReply = nil
    end
  end
end

function Net:hero_equip_upgrade_reply(msg)
  local reply = msg._hero_equip_upgrade_reply
  local result = reply._result == "success"
  local hero = reply._hero
  local handler = ed.netreply.equipUpgrade
  local data = ed.netdata.equipUpgrade
  if data then
    local hid = data.hid
    local sid = data.slot
    local pree = ed.player.heroes[hid]._items[sid]._exp
    local e = hero._items[sid]._exp
    local prel = ed.readequip.getEquipLevel(hid, sid, pree)
    local l = ed.readequip.getEquipLevel(hid, sid, e)
    if prel < l then
      ed.record:refreshCommonRecord("enhanceLevelup")
    end
  end
  if result then
    ed.player:resetHero(hero)
  end
  if handler then
    handler(result)
    ed.netreply.equipUpgrade = nil
  end
  if data then
    local type = data.type
    local cost = data.cost
    local mts = data.mts
    if type == "rmb" then
      ed.player:addrmb(-cost)
    elseif type == "money" then
      ed.player:addMoney(-cost)
      for k, v in pairs(mts) do
        ed.player:consumeEquip(v.id, v.amount, v.insid)
      end
    end
  end
end

function Net:hero_upgrade_reply(msg)
  local reply = msg._hero_upgrade_reply
  local result = reply._result == "success"
  local hero = reply._hero
  local items = reply._items
  local props = {}
  for i = 1, #(items or {}) do
    local item = items[i]
    local itemInfo = ed.analyzeItem(item)
    local id = itemInfo.id
    local amount = itemInfo.amount
    ed.player:addEquip(id, amount)
    props[i] = {id = id, amount = amount}
  end
  if result then
    ed.player:resetHero(hero)
    ed.player:clearSuperTaskEquip()
  end
  FireEvent("heroupgradereplay", msg._hero_upgrade_reply)
  if ed.netreply.heroUpgradeReply then
    ed.netreply.heroUpgradeReply(result, props)
    ed.netreply.heroUpgradeReply = nil
  end
end

function Net:open_shop_reply(msg)
  local reply = msg._open_shop_reply
  local result = reply._result
  local shop = reply._shop
  result = result == "success" or result == 0
  if shop then
    FireEvent("open_shop_reply", shop)
  end
end

function Net:shop_switch_reply(msg)
  local reply = msg._shop_switch_reply
  local handler = ed.netreply.switchShop
  if handler then
    handler(reply)
    ed.netreply.switchShop = nil
  end
end

function Net:super_link(msg)
  local reply = msg._super_link
  local info = reply._info
  info = EDTables.errorinfo[info] or info
  local addr = reply._addr
  ed.popSuperLinkAlertDialog(info, addr)
end

function Net:battle_check_fail(msg)
  local check_id = msg._battle_check_fail._checkid
  local mode = ed.engine:ctMode2String()
  print("=================================== >>> ", check_id)
  if ed.debug_mode then
    ed.reportBattleLog(check_id, mode)
  else
    local force = ed.storage.getBool("FORCE_BATTLE_REPORT_FLAG")
    if force or check_id % 10 == 1 then
      ed.reportBattleLog(check_id, mode)
    end
  end
  ed.showAlertDialog({
    text = T("\231\189\145\231\187\156\232\191\158\230\142\165\229\188\130\229\184\184\239\188\140\232\175\183\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\227\128\130"),
    buttonText = T("\233\128\128\229\135\186"),
    handler = function()
      EDExit()
    end
  })
end

function Net:sync_vitality_reply(msg)
  local reply = msg._sync_vitality_reply
  ed.player._vitality = reply._vitality
  FireEvent("ResourceNumChange", "vitality")
  ed.player:increaseDailyjobCount({type = "BuyVit", add = 1})
  local data = ed.netdata.buyVitality
  if data and data.isBuy then
    local cost = data.cost
    ed.player:subrmb(cost)
    if ed.netreply.buyVitalityReply then
      ed.netreply.buyVitalityReply()
      ed.netreply.buyVitalityReply = nil
    end
    ed.netdata.buyVitality = nil
  end
end

function Net:trigger_task_reply(msg)
  local reply = msg._trigger_task_reply
  local result = reply._result
  if ed.netreply.triggerTask then
    ed.netreply.triggerTask(result)
    ed.netreply.triggerTask = nil
  end
  if ed.netreply.popherotask then
    ed.netreply.popherotask()
    ed.netreply.popherotask = nil
  end
  if ed.netreply.popherosuperawaketask then
    ed.netreply.popherosuperawaketask()
    ed.netreply.popherosuperawaketask = nil
  end
  FireEvent("triggercallbacktask", result)
  FireEvent("triggerinvitetask", result)
  FireEvent("triggermentortask", result)
end

function Net:require_rewards_reply(msg)
  local reply = msg._require_rewards_reply
  local result = reply._result
  if reply._exp_bonus and reply._exp_bonus > 0 then
    local bonuxExp = reply._exp_bonus
    ed.player:addExp(bonuxExp)
  end
  result = result == "success" or result == 0
  if ed.netreply.requireRewards then
    ed.netreply.requireRewards(reply, ed.netdata.requireRewards)
    ed.netreply.requireRewards = nil
    ed.netdata.requireRewards = nil
  end
  FireEvent("callbacktaskreply", reply)
  FireEvent("invitetaskreply", reply)
  FireEvent("mentortaskreply", reply)
end

function Net:get_vip_gift_reply(msg)
  local reply = msg._get_vip_gift_reply
  local result = reply._result
  result = result == "success" or result == 0
  local handler = ed.netreply.getvipGift
  local data = ed.netdata.getvipGift
  if result then
    local vip = data.vip
    ed.player:addvipGift(vip)
  end
  if handler then
    handler(result)
  end
  ed.netreply.getvipGift = nil
  ed.netdata.getvipGift = nil
end

function Net:job_rewards_reply(msg)
  local reply = msg._job_rewards_reply
  local result = reply._result
  if reply._exp_bonus and reply._exp_bonus > 0 then
    local bonuxExp = reply._exp_bonus
    ed.player:addExp(bonuxExp)
  end
  result = result == "success" or result == 0
  ed.taskNetwork:dailyjobReply(msg)
end

function Net:reset_elite_reply(msg)
  ed.player:resetEliteRequest_Reply()
  local reply = msg._reset_elite_reply
  local result = reply._result
  result = result == "success" or result == 0
  if result then
    local data = ed.netdata.resetElite
    local isPay, cost, stage
    if data then
      isPay = data.isPay
      cost = data.cost
      stage = data.stage
    end
    ed.player:refreshEliteResetTime()
    if not isPay then
      ed.player:resetEliteLimit()
    else
      ed.player:refreshStageEliteLimit(stage)
      ed.player:addrmb(-cost)
    end
  end
  if ed.netreply.resetElite then
    ed.netreply.resetElite(result)
    ed.netreply.resetElite = nil
    ed.netdata.resetElite = nil
  end
end

function Net:sweep_stage_reply(msg)
  local reply = msg._sweep_stage_reply
  local shop = reply._shop
  local dshop = reply._dshop
  
  local function addSweepLoot(info)
    local wave = info._loot
    for k, v in pairs(wave) do
      if v._exp_bonus and v._exp_bonus > 0 then
        local bonuxExp = v._exp_bonus
        ed.player:addExp(bonuxExp)
      end
      ed.player:addExp(v._exp, "sweep")
      ed.player:addMoney(v._money)
      for ck, cv in pairs(v._items or {}) do
        local itemInfo = ed.analyzeItem(cv)
        ed.player:addEquip(itemInfo.id, itemInfo.amount)
      end
    end
    for k, v in pairs(info._items or {}) do
      local itemInfo = ed.analyzeItem(v)
      ed.player:addEquip(itemInfo.id, itemInfo.amount)
    end
  end
  
  if ed.netreply.sweepReply then
    ed.netreply.sweepReply()
    ed.netreply.sweepReply = nil
  end
  addSweepLoot(reply)
  local data = ed.netdata.sweep
  if data then
    local st = data.type
    local times = data.times
    local power = data.power
    local cost = data.cost
    local stage = data.stage
    ed.player:addVitality(-power * times)
    if st == "free" then
      ed.player:useSweepTimes(times)
    else
      ed.player:subrmb(cost)
    end
    if ed.stageType(stage) == "elite" then
      ed.player:addStageLimit(ed.elite2NormalStage(stage), times)
    end
    ed.netdata.sweep = nil
    ed.record:successFarmStage(stage, times)
    ed.record:successWinBattle(stage, times)
  end
  if ed.netreply.sweep then
    ed.netreply.sweep(reply)
    ed.netreply.sweep = nil
  end
  if shop then
    local type
    local id = shop._id
    if 1 < id then
      type = "trigger"
    end
    ed.player:refreshShopData(shop, type)
  end
  if dshop then
    ed.player:refreshDiamondShopData(dshop)
  end
  FireEvent("sweepStageReply")
end

function Net:ask_daily_login_reply(msg)
  local reply = msg._daily_login_reward_reply
  local handler = ed.netreply.dailylogin
  if handler then
    handler(reply)
    ed.netreply.dailylogin = nil
  end
end

function Net:recharge_polling_reply(msg)
  local reply = msg._recharge_polling_reply
  local heroes = reply._heroes
  for i = 1, #(heroes or {}) do
    local h = heroes[i]
    ed.player:resetHero(h)
  end
  FireEvent("rechargePollingReply", reply)
  if reply._recharge_limits then
    ed.player:syncRechargeLimit(reply._recharge_limits)
  end
  local rewards = {}
  if reply._diamond then
    local oldRmb = ed.player._rmb
    ed.player:setrmb(reply._diamond)
    local addNum = ed.player._rmb - oldRmb
    if 0 < addNum then
      table.insert(rewards, {type = "Diamond", amount = addNum})
    end
  end
  if reply._vip_exp then
    ed.player:setRechargeSum(reply._vip_exp)
  end
  if reply._monthcards then
    for k, v in pairs(reply._monthcards) do
      ed.player:refreshMonthCardData(v)
    end
  end
  if reply._items then
    for _, v in pairs(reply._items) do
      local addNum = v._amount - (ed.player:getEquipAmount(v._id) or 0)
      if 0 < addNum then
        table.insert(rewards, {
          type = "item",
          id = v._id,
          amount = addNum
        })
      end
      ed.player:addEquip(v._id, addNum)
    end
  end
  if 0 < #rewards then
    ed.announce({
      type = "getProp",
      param = {
        title = T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
        items = rewards,
        callback = function()
        end
      }
    })
  end
  if 0 < #rewards or reply._to_gift_ticket == 1 then
    FireEvent("QueryDataRsp", reply)
    if reply._to_gift_ticket == 1 then
      ed.showAlertDialog({
        text = T("\230\130\168\232\180\173\228\185\176\231\154\132\229\149\134\229\147\129\228\187\165\228\187\163\233\135\145\229\136\184\231\154\132\229\189\162\229\188\143\231\187\153\230\130\168\229\136\176\232\180\166\239\188\140\233\186\187\231\131\166\230\130\168\228\189\191\231\148\168\228\187\163\233\135\145\229\136\184\229\134\141\230\172\161\232\180\173\228\185\176\229\149\134\229\147\129")
      })
    end
  end
end

function Net:hero_evolve_reply(msg)
  local reply = msg._hero_evolve_reply
  local result = reply._result
  local hero = reply._hero
  result = result == "success" or result == 0
  local data = ed.netdata.evolve
  if data and result then
    local cost = data.cost or 0
    local id = data.id
    local amount = data.amount
    local hid = data.hid
    ed.player:addMoney(-cost)
    ed.player:consumeEquip(id, amount)
    if not ed.player.heroes[hid] then
      ed.player:addHero(hid)
    end
    ed.player:resetHero(hero)
    ed.netdata.evolve = nil
  end
  local handler = ed.netreply.evolve
  if handler then
    handler(result)
    ed.netreply.evolve = nil
  end
end

function Net:ladder_reply(msg)
  if msg._ladder_reply and msg._ladder_reply._query_rankborad then
    FireEvent("query_rankpvpdata_reply", msg._ladder_reply._query_rankborad)
    local handler = ed.getNetReply("query_ranklist_reply")
    if handler then
      handler(msg._ladder_reply._query_rankborad)
    end
  end
  ed.pvpNetwork:dispatchReply(msg._ladder_reply)
  if ed.netreply.gotoPvpBattleReply and (msg._ladder_reply._start_battle or msg._ladder_reply._start_fight) then
    local start_battle = msg._ladder_reply._start_battle or msg._ladder_reply._start_fight
    local enemyList = start_battle._heroes
    local selfList = start_battle._self_heroes
    local isBot = start_battle._is_robot
    local pvpActivityId = start_battle._ladder_buff_id
    local backgroundId = start_battle._background_id
    local background = {
      backgroundId = start_battle._background_id,
      homeGround = start_battle._home_ground
    }
    if start_battle._bt_st then
      ed.startBattleTime = start_battle._bt_st
    end
    isBot = isBot and 0 < isBot
    ed.srand(start_battle._rseed)
    ed.netreply.gotoPvpBattleReply(enemyList, isBot, selfList, nil, nil, nil, 0, nil, pvpActivityId, {
      selfBonus = start_battle._self_bonus,
      oppoBonus = start_battle._oppo_bonus
    }, nil, background)
    FireEvent("StartPVPBattle")
  end
end

function Net:top_arena_reply(msg)
  FireEvent("TopPvpRsp", msg._top_arena_reply)
  if msg._top_arena_reply._query_rankborad then
    local handler = ed.getNetReply("top_arena")
    if handler then
      handler(msg._top_arena_reply._query_rankborad)
    end
  end
  if msg._top_arena_reply._query_oppo then
    local handler = ed.getNetReply("query_toppvp_oppo")
    if handler then
      handler(msg._top_arena_reply._query_oppo._user)
    end
  end
  if msg._top_arena_reply._query_summary then
    local handler = ed.getNetReply("query_toppvp_Statistics")
    if handler then
      handler(msg._top_arena_reply._query_summary)
    end
  end
end

function Net:set_name_reply(msg)
  local reply = msg._set_name_reply
  local result = reply._result
  local data = ed.netdata.setname
  if result == "success" and data then
    local name = data.name or ""
    local cost = data.cost or 0
    ed.player:setName(name)
    ed.player:addrmb(-cost)
    ed.player:refreshSetNameTime()
    ed.netdata.setname = nil
    FireEvent("SetNameSuccess")
  end
  local handler = ed.netreply.setname
  if handler then
    handler(result)
    ed.netreply.setname = nil
  end
end

function Net:set_avatar_reply(msg)
  local reply = msg._set_avatar_reply
  local result = reply._result
  result = result == "success" or result == 0
  local data = ed.netdata.setAvatar
  if data and result then
    local id = data.id
    ed.player:setAvatar(id)
    FireEvent("setAvatarReply", result)
  end
  local handler = ed.netreply.setAvatar
  if handler then
    handler(result)
  end
  FireEvent("setAvatarFrame", result)
  FireEvent("refreshChatHead")
end

function Net:remote_setting_reply(msg)
  if msg._remote_setting_reply._get_remote_items then
    ed.SpanServerMgr.getInstance():setEleData(msg._remote_setting_reply._get_remote_items)
    FireEvent("_get_remote_items")
  end
  local result = msg._remote_setting_reply._set_remote_item
  result = result == "success" or result == 0
  if result then
    FireEvent("_set_remote_item", result)
  end
end

function Net:get_maillist_reply(msg)
  local reply = msg._get_maillist_reply
  local data = reply._sys_mail_list
  local handler = ed.netreply.getMail
  ed.player:refreshMailData(data)
  if handler then
    handler()
  end
end

function Net:read_mail_reply(msg)
  local reply = msg._read_mail_reply
  local result = reply._result
  result = result == "success" or result == 0
  local handler, data = ed.getNetReply("readMail")
  if result then
    ed.player:readMail(data, reply)
  end
  if handler then
    handler(reply)
  end
end

function Net:cut_read_mail_reply(msg)
  local reply = msg._cut_read_mail_reply
  local result = reply._result
  result = result == "success" or result == 0
  local handler, data = ed.getNetReply("cut_read_mail")
  if result then
    for k, v in pairs(data) do
      ed.player:deleMail(v)
    end
  end
  if handler then
    handler(reply)
  end
end

local function genSvridData()
  local gs_first, gs_second, gs_third, gs_fourth = ed.stringutil.split2Bytes(game_server_id)
  ed.svridData = "svrid" .. gs_first .. gs_second .. gs_third .. gs_fourth
end

ed.genSvridData = genSvridData

function Net:sdk_login_reply(msg)
  local uin = msg._sdk_login_reply._uin
  if uin and msg._sdk_login_reply._result == "success" then
    if ed.isPCCloneMode then
      ed.setDeviceId(string.format("%d-%s", EDSDKType or 1, uin or "nil"))
    else
      ed.setDeviceId(uin)
    end
  end
  if msg._sdk_login_reply._enable_net_svrid then
    ed.use_gate = true
    ed.genSvridData()
  end
  EDLog("-->>uin is : " .. (uin or "Unknown"))
  FireEvent("SDKLoginRsp", msg._sdk_login_reply._result)
  if EDFLAGANDROID then
    rechargeURL = msg._sdk_login_reply._recharge_url
  end
  chargeEnv = msg._sdk_login_reply._charge_env
  Backdoor.init(msg._sdk_login_reply._bd_ver, msg._sdk_login_reply._bd_data)
end

function Net:cdkey_gift_reply(msg)
  local reply = msg._cdkey_gift_reply
  local result = reply._result
  local pack = reply._pack
  local handler = ed.netreply.cdkeyGift
  if handler then
    handler(result, pack)
  end
end

function Net:notify_msg(msg)
  FireEvent("NotifyMsgRsp", msg._notify_msg)
  local reply = msg._notify_msg
  local newMail = reply._new_mail or 0
  ed.player:setNewMailAmount(newMail)
  local expireMail = reply._expire_mail or 0
  ed.player:setExpireMailAmount(expireMail)
  ed.player:releaseHeroes(reply._release_heroes)
  if reply._bd_version then
    Backdoor.setTargetVersion(reply._bd_version)
    Backdoor.load()
  end
  if reply._vitality then
    local currVitality = ed.player:getVitality()
    local addVitality = reply._vitality - currVitality
    ed.player:addVitality(addVitality, false)
  end
  if reply._is_open_arena_foothold then
    FireEvent("ChangePvpFca", reply._is_open_arena_foothold)
  end
  if reply._dreamland_summary and ed.dreamland.dreamland_object then
    ed.dreamland.dreamland_object:ResetSummary(reply._dreamland_summary)
  end
end

function Net:require_arousal_reply(msg)
  local reply = msg._require_arousal_reply
  local result = reply._result == "success"
  local _hero = reply._hero
  if result then
    FireEvent("getArousalReply", reply or {})
  else
    print("_require_arousal_Failed")
  end
end

function Net:change_task_status_reply(msg)
  local reply = msg._change_task_status_reply
  local result = reply._result == "success"
  if result then
    if ed.netreply.changeTaskStatusReply then
      for k, v in pairs(ed.player._tasks or {}) do
        if v._line == reply._line then
          if reply._operation == 1 then
            ed.player._tasks[k]._status = "suspend"
            ed.player._tasks[k]._sweepStages = {}
            ed.player._tasks[k]._task_target = 0
            local heroTaskTable = ed.getDataTable("HeroTask")
            if heroTaskTable[ed.player._tasks[k]._line][ed.player._tasks[k]._id]["Task Progress Type"] == "EquipItem" then
              for k, v in pairs(heroTaskTable[ed.player._tasks[k]._line][ed.player._tasks[k]._id]["Task Recycle ID"] or {}) do
                if v ~= 0 and 0 < ed.player:getEquipAmount(v) then
                  ed.player.equip_qunty[v] = 0
                end
              end
            end
          elseif reply._operation == 2 then
            ed.player._tasks[k]._status = "working"
            local stage_id = ed.netreply.item_stage_id
            if stage_id then
              ed.player._tasks[k]._item_stage = stage_id
              ed.netreply.item_stage_id = nil
            end
          end
        end
      end
      ed.netreply.changeTaskStatusReply(reply)
      ed.netreply.changeTaskStatusReply = nil
      if not ed.getDataTable("HeroTask")[reply._line][reply._id]["Is Artifact"] then
        FireEvent("HeroTaskStatusChanged")
      elseif ed.getDataTable("HeroTask")[reply._line][reply._id]["Is Artifact"] then
        FireEvent("HeroSuperTaskStatusChanged", reply)
      end
    end
  else
    print("change_task_status_reply_Failed")
  end
end

function Net:uback_reply(msg)
  if msg._uback_reply._open_panel then
    FireEvent("usersRefluxBaseMsg", msg._uback_reply._open_panel)
  end
  if msg._uback_reply._job_rewards then
    FireEvent("usersRefluxGetAwardMsg", msg._uback_reply._job_rewards)
  end
  if msg._uback_reply._bind then
    FireEvent("URBindCodeEvent", msg._uback_reply._bind)
  end
  if msg._uback_reply._trans_svr_list then
    FireEvent("URSerListEvent", msg._uback_reply._trans_svr_list)
  end
  if msg._uback_reply._trans_hero then
    FireEvent("URTranHeroEvent", msg._uback_reply._trans_hero)
  end
end

function ed.preprocessNetError(msg)
  local reply = msg._error_info
  local error = reply._info
  FireEvent("NetworkError", reply)
  if EDTables.errorinfo[error] then
    error = EDTables.errorinfo[error]
  end
  if reply._type == "quit" then
    ed.showAlertDialog({
      text = error,
      buttonText = T("\233\128\128\229\135\186"),
      handler = function()
        EDExit()
      end
    })
  elseif reply._info == "chair_kick_set_job_time_limit" or reply._info == "guild_kick_reach_limit" then
    ed.showToast(T("\228\187\138\230\151\165\228\186\186\229\145\152\231\174\161\231\144\134\230\147\141\228\189\156\230\172\161\230\149\176\229\183\178\232\190\190\228\184\138\233\153\144"))
  elseif reply._type == "tip" then
    if reply._info == "awake_dungeon_coor_not_exist" then
      FireEvent("awakeDungeonCoorNotExist")
      return
    end
    if error ~= T("\230\173\164\229\138\159\232\131\189\230\154\130\230\151\182\228\184\141\229\188\128\230\148\190") then
      ed.showToast(error)
    else
      print(error)
    end
    if reply._info == "peak_arena_out_of_challengetime" then
      ed.PeakArenaNetwork:sendOpenPanel()
    end
  elseif reply._info == "target_already_in_blacklist" then
    ed.showToast(T("\232\175\165\231\142\169\229\174\182\229\183\178\229\136\151\229\133\165\233\187\145\229\144\141\229\141\149"))
  elseif reply._info == "target_in_blacklist" then
    ed.showToast(T("\232\175\165\231\142\169\229\174\182\229\156\168\233\187\145\229\144\141\229\141\149\228\184\173"))
  elseif error == "sevenday_assist_not_open" then
    ed.showToast(T("\232\175\165\230\180\187\229\138\168\229\183\178\232\191\135\230\156\159"))
    if ed.getCurrentScene().identity == "SevenDayScene" then
      ed.popScene()
    end
    ed.SevenDayManager:setOpen(false)
    FireEvent("RefreshRightTopButtons")
  else
    ed.showAlertDialog({text = error})
  end
end

local function OnSendMsgFail()
  long_failed_times = long_failed_times + 1
  if 2 <= long_failed_times and use_long_con then
    long_failed_times = 0
    if ed.getCurrentScene().identity == "serverlogin" then
      up_code = nil
      ed.showToast(T("\229\187\186\232\174\174\231\161\174\232\174\164\231\189\145\231\187\156\233\128\154\231\149\133\229\144\142\233\135\141\232\175\149"))
      ed.useBackupIP = true
      return
    end
  end
  long_waiting_retry = true
  errorNet.showError(function()
    long_waiting_retry = false
    reSend()
  end)
end

ListenEvent("SendMsgFail", OnSendMsgFail)
