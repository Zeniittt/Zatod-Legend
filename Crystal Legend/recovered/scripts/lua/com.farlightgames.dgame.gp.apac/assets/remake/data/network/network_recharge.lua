local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.rechargeNetwork = class
local connect = socket.connect
local connection
local connect_succ = false
local close
local bSendblock = false
local currentMsg, currentMsgType
local up = pb_loader("ms_up")()
local down = pb_loader("ms_down")()
local insert = table.insert
local ipairs = ipairs
local up_code
class.upmsg = up
class.downmsg = down
local serverIp = "csw.dota.lilith.sh"
local serverPort = "7777"
local loadLayer = {}
local loadFunc = {}

local function load()
  local count = 0
  local isLoading
  
  local function handler(dt)
    dt = dt or 0
    local timeoutLimit = 5
    count = count + dt
    if timeoutLimit < count then
      close()
    end
  end
  
  return handler
end

local function loadBegin()
  loadFunc.loadEnd()
  if not loadLayer.id then
    local loading = load()
    local scene = CCDirector:sharedDirector():getRunningScene()
    if not tolua.isnull(scene) then
      loadLayer.scheduler = scene:getScheduler()
      loadLayer.id = loadLayer.scheduler:scheduleScriptFunc(loading, 0, false)
    end
    local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
    layer:setTouchEnabled(true)
    
    local function doTouchLoad()
      return true
    end
    
    layer:registerScriptTouchHandler(doTouchLoad, false, -240, true)
    scene:addChild(layer, 600)
    loadLayer.layer = layer
  end
end

loadFunc.loadBegin = loadBegin
class.loadBegin = loadBegin

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
class.loadEnd = loadEnd

local function dispatch(msg)
  for k, v in pairs(msg[".data"]) do
    EDLog(">>> down msg: " .. k)
  end
  if msg.charge_query_reply then
    FireEvent("chargeQueryResult", msg.charge_query_reply)
  end
  if msg.login_query_reply then
    if msg.login_query_reply.status == "update" then
      ed.overrideSdk = true
      ed.showAlertDialog({
        text = msg.login_query_reply.show_text,
        buttonText = T("\229\137\141\229\190\128"),
        handler = function()
          if msg.login_query_reply.url then
            ed.openURL(msg.login_query_reply.url)
          end
        end
      })
    else
      sdkLogin.setLoginMode(msg.login_query_reply.status)
      accSystem.BindAccountMgr.getInstance():setAccountServer(msg.login_query_reply)
      ed.sdk.sdkInit()
    end
  end
end

class.dispatch = dispatch

function close()
  if connection then
    connection:close()
  end
  connection = nil
  connect_succ = false
  up_code = nil
  loadFunc.loadEnd()
end

local function connect(block)
  connection, err = socket.tcp()
  if not connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  connection:settimeout(block and 5 or 0)
  local err
  connect_succ, err = connection:connect(serverIp, serverPort)
  loadBegin(true)
  if connect_succ then
    EDLog("    connect succ")
    connection:settimeout(0)
    local r1, r2 = connection:send(up_code)
    if r1 then
      EDLog("<<< Message Sent  @ " .. ed.getYMDTime())
    else
      EDLog(string.format("ERROR | connection:send failed | %s", err))
      close()
    end
  elseif block then
    EDLog(string.format("ERROR | Blocked Connect failed | %s", err))
    close()
    return false
  else
    EDLog("    connect start")
    return true
  end
end

local function connect_resume()
  if connect_succ or not connection then
    return
  end
  local r, w, e = socket.select({connection}, {connection}, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = connection:connect(serverIp, serverPort)
  print("errstr", errstr)
  if errstr ~= "already connected" then
    return
  end
  connect_succ = true
  EDLog("    connect succ")
  local r1, r2 = connection:send(up_code)
  if not r1 then
    EDlog("send error check network setting")
    ed.showNetToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(71)")
    close()
    return
  end
  EDLog("<<< Message Sent  @ " .. ed.getYMDTime())
end

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
  local buffer_size_str, err = connection:receive(2)
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
  local buffer = recv_buffer(buffer_size, "")
  close()
  if buffer then
    EDLog(">>> Data Received @ " .. ed.getYMDTime())
    local msg, err = down.ms_down_msg():Parse(buffer)
    if msg then
      dispatch(msg)
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end

local function pack_size(code, ttype)
  local length = #code
  local second = string.char(length % 256)
  local first = string.char(math.floor(length / 256))
  return first .. second .. code
end

local function doSend(block, ttype)
  if nil == currentMsg then
    return false
  end
  local code, err = currentMsg:Serialize()
  local cipher_code
  up_code = pack_size(code, ttype)
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

local function send(obj, ttype, block)
  if connection then
    return false
  end
  EDLog("<<< Sending msg: " .. ttype)
  currentMsg = nil
  currentMsg = up.ms_up_msg()
  currentMsg[ttype] = obj
  bSendblock = block or false
  currentMsgType = ttype
  return doSend(block, ttype)
end

class.send = send

function class.send()
end

local function proc_net()
  connect_resume()
  recv()
end

class.proc_net = proc_net

function class.proc_net()
end
