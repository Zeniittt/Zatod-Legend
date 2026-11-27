local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
ed.ui.newbie = class
local ui
local connect = socket.connect
local connection
local connect_succ = false
local close
local bSendblock = false
local currentMsg, currentMsgType, currentUi
local up = pb_loader("acc_up")()
local down = pb_loader("acc_down")()
local insert = table.insert
local ipairs = ipairs
local up_code
class.upmsg = up
class.downmsg = down
local cryptkey = "182173557"
local fadinlength = 0.2
local serverInfo, enterContainer
local loadLayer = {}
local loadFunc = {}

local function doTouchLoad()
  return true
end

local function setData(info)
  serverInfo = info
end

class.setData = setData

local function setContainer(container)
  enterContainer = container
end

class.setContainer = setContainer

local function doNext()
  close()
  if sdkLogin.isNewLoginMode() then
    FireEvent("requestAccountListReply", serverInfo)
  else
    local serverListWin = ed.getPopWindow("serverListWin")
    if serverListWin then
      serverListWin:refresh(serverInfo)
    else
      ed.ui.serverListWin.create(serverInfo):popWindow()
    end
  end
  ed.loadEnd()
  enterContainer:setVisible(false)
end

function class.setEnterContainerVisible(isVisible)
  enterContainer:setVisible(isVisible)
end

local function load(noflower, bReSend)
  local count = 0
  local countRotate = 0
  local count_gap = 0.1
  local resend = true
  if bReSend ~= nil then
    resend = bReSend
  end
  local isLoading
  
  local function handler(dt)
    dt = dt or 0
    count = count + dt
    countRotate = countRotate + dt
    if 5 < count and resend then
      loadFunc.loadEnd()
      close()
      if currentUi ~= nil then
        currentUi:setVisible(true)
        local action = CCFadeIn:create(fadinlength)
        currentUi:runAction(action)
      end
      doNext()
    end
    if noflower then
      return
    end
    local scene = CCDirector:sharedDirector():getRunningScene()
    if isLoading and tolua.isnull(loadLayer.layer) then
      return
    end
    if countRotate > count_gap then
      local flower = loadLayer.flower
      if not tolua.isnull(flower) then
        flower:setRotation((flower:getRotation() + 30) % 360)
      end
      countRotate = countRotate - count_gap
    end
  end
  
  return handler
end

local function loadBegin(noflower, bReSend)
  loadFunc.loadEnd()
  if not loadLayer.id then
    local loading = load(noflower, bReSend)
    local scene = CCDirector:sharedDirector():getRunningScene()
    if not tolua.isnull(scene) then
      loadLayer.scheduler = scene:getScheduler()
      loadLayer.id = loadLayer.scheduler:scheduleScriptFunc(loading, 0, false)
    end
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
  if msg.account_query_reply then
    if ed.SpanServerMgr.getInstance():getIsReqRoleData() == true then
      ed.SpanServerMgr.getInstance():setIsReqRoleData(false)
      ed.SpanServerMgr.getInstance():setServerListData(serverInfo.serverListData)
      ed.SpanServerMgr.getInstance():setRoleData(msg.account_query_reply.accounts)
      FireEvent("requestRoleDataReply")
      ed.loadEnd()
      return
    end
    if sdkLogin.isNewLoginMode() then
      FireEvent("requestAccountListReply", serverInfo, msg.account_query_reply.accounts)
    else
      local serverListWin = ed.getPopWindow("serverListWin")
      if serverListWin then
        serverListWin:refresh(serverInfo, msg.account_query_reply.accounts)
      else
        ed.ui.serverListWin.create(serverInfo, msg.account_query_reply.accounts):popWindow()
      end
    end
    ed.loadEnd()
    enterContainer:setVisible(false)
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
end

local function connect(block)
  if not account_svr_ip or not account_svr_port then
    doNext()
    return
  end
  connection, err = socket.tcp()
  if not connection then
    EDLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  connection:settimeout(block and 5 or 0)
  local err
  connect_succ, err = connection:connect(account_svr_ip, account_svr_port)
  if connect_succ then
    EDLog("    connect succ")
    connection:settimeout(0)
    local r1, r2 = connection:send(up_code)
    if r1 then
      EDLog("<<< Message Sent  @ " .. ed.getYMDTime())
    else
      EDLog(string.format("ERROR | connection:send failed | %s", err))
    end
    close()
  elseif block then
    EDLog(string.format("ERROR | Blocked Connect failed | %s", err))
    return false
  else
    EDLog("    connect start")
    local notShowFlower = true
    if not ed.isElementInTable(currentMsgType, {
      "reset_elite",
      "query_data"
    }) then
      notShowFlower = nil
    end
    loadBegin(true)
    return true
  end
end

local function connect_resume()
  if not account_svr_ip or not account_svr_port then
    doNext()
    return
  end
  if connect_succ or not connection then
    return
  end
  local r, w, e = socket.select({connection}, {connection}, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = connection:connect(account_svr_ip, account_svr_port)
  print("errstr", errstr)
  if errstr ~= "already connected" then
    return
  end
  connect_succ = true
  EDLog("    connect succ")
  local r1, r2 = connection:send(up_code)
  if not r1 then
    EDlog("send error check network setting")
    if currentUi ~= nil then
      currentUi:setVisible(true)
      local action = CCFadeIn:create(fadinlength)
      currentUi:runAction(action)
    end
    ed.showToast(T("\229\143\145\233\128\129\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\232\174\190\231\189\174") .. "(81)")
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
    loadEnd()
    local msg, err = down.acc_down_msg():Parse(buffer)
    if msg then
      dispatch(msg)
    else
      EDLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
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

class.delaySend = delaySend

local function pack_size(code, ttype)
  local length = #code
  EDLog("length:" .. tostring(length))
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

local function reSend()
  if nil == currentMsg then
    return
  end
  doSend(bSendblock, currentMsgType)
end

local function send(obj, ttype, block)
  if connection then
    return false
  end
  EDLog("<<< Sending msg: " .. ttype)
  currentMsg = nil
  currentMsg = up.acc_up_msg()
  currentMsg[ttype] = obj
  bSendblock = block or false
  currentMsgType = ttype
  for k, v in pairs(sendCache or {}) do
    currentMsg[k] = v
    if deleteCache[k] then
      sendCache[k] = nil
      deleteCache[k] = nil
    end
  end
  return doSend(block, ttype)
end

class.send = send

local function proc_net()
  connect_resume()
  recv()
end

class.proc_net = proc_net

local function updateNewbie(self)
  if account_svr_ip and account_svr_port then
    proc_net()
  end
end

class.updateNewbie = updateNewbie
