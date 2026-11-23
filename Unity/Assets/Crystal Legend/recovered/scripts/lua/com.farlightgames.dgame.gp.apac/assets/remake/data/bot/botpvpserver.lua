CCNode = {}
CCSprite = {}
module("ed.bot", package.seeall)

local function compatibilityBug()
  ed.HpBar = {}
end

local function initDir()
  os.execute("mkdir bclog")
end

package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("bot/tools")
require("tools")
compatibilityBug()
require("socket")
require("debug.dump")
require("bot/queue")
require("bot/botPvpBattle")
require("resource_manager")
require("datatable")
require("battle/edp")
require("pb")
require("battle/battle_engine")
require("gamedatatables/gamedatatables")
require("gamedatatables/unittable")
require("gamedatatables/rechargemetatable")
require("gamedatatables/herotasktable")
require("gamedatatables/challengetable")
require("gamedatatables/SkillGrouptable")
require("bot/ipconfig")
initDir()
local host = ipconfig.host
local port = ipconfig.port
local down = pb_loader("bot/up")()
local up = pb_loader("bot/down")()
local upmsg = up.pvp_resultData
local downmsg = down.pvp_parameter
local client, server
local queue = Quene.create(1024)

local function destory()
  if client then
    client:close()
    client = nil
  end
end

local function createServer()
  destory()
  print("trying to create server")
  local err
  server, err = socket.bind(host, port, 1)
  if not server then
    print("create server faild,err :", err)
  else
    print("create server success")
  end
end

local function acceptClient(timeout)
  print("acceptClient")
  if client then
    return
  end
  if not server then
    createServer()
  end
  if not server then
    return 0
  else
    server:settimeout(timeout)
    local accept, err = server:accept()
    if err then
      print("server accept client faild err:", err)
    end
    if accept then
      client = accept
      print("a client successfully connect!")
    end
  end
end

local function closeClient()
  client:close()
  client = nil
end

local function pack_size(code)
  local length = #code
  local second = string.char(length % 256)
  local first = string.char(math.floor(length / 256))
  return first .. second .. code
end

local function send()
  if not client then
    acceptClient(5)
  end
  if not client then
    return false
  end
  local msg = upmsg()
  msg._result = {}
  local count = queue.size
  for i = 1, count do
    msg._result[i] = queue:pull()
  end
  print("msg", msg)
  print("msg:Serialize()", msg:Serialize())
  local code = pack_size(msg:Serialize())
  local r1, err = client:send(code)
  if not r1 then
    print("Send report failed|" .. err)
    for i = 1, count do
      queue:push(msg._result[i])
    end
    if err == "closed" then
      closeClient()
    end
    return false
  end
  return true
end

local function ensureResultSuccess()
  print("ensureResultSuccess")
  if queue.size == 0 then
    queue:destory()
    closeClient()
    return
  end
  local state = false
  while true do
    state = send()
    if state then
      queue:destory()
      closeClient()
      return
    end
  end
end

local function dojob(msg)
  local pvpBattle = BotpvpBattle.create(msg)
  while true do
    local result = pvpBattle:startOneGenerationPvp()
    if result then
      local sendMsg = up.roundResult()
      sendMsg._teamList = result.teamList
      sendMsg._generation = result.generation
      sendMsg._totalTime = result.totalTime
      sendMsg._drawBout = result.drawBout
      sendMsg._totalBout = result.totalBout
      queue:push(sendMsg)
      send()
    else
      ensureResultSuccess()
      return
    end
  end
end

local function checkMsg()
  local buffer_size_str, err = client:receive(2)
  if err == "closed" then
    print("connection closed")
    closeClient()
    return nil
  end
  return buffer_size_str
end

local function recBuffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = client:receive(size_left)
  if err == "closed" then
    print("socket closed by client.")
    closeClient()
    return false
  elseif err == "timeout" then
    buffer = buffer .. partial
    return recBuffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return recBuffer(size_left - #content, buffer)
  end
end

local function receiveMsg()
  local buffer_size_str = checkMsg()
  if buffer_size_str then
    local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
    local buffer = recBuffer(buffer_size, "")
    if buffer then
      local msg, err = downmsg():Parse(buffer)
      if msg then
        dojob(msg)
      end
    end
  end
end

local function clientRead()
  local reads, writes, status = socket.select({client}, {nil}, 1)
  if reads and not status then
    receiveMsg()
  end
end

local function botpvpServerMain()
  createServer()
  while true do
    acceptClient(-1)
    clientRead()
  end
end

print(tools)
local debugMode = true
xpcall(function()
  local ed = ed
  ed.enableBotMode = true
  ed.enableMaxAttStrategy = true
  ed.run_with_scene = false
  botpvpServerMain()
end, function(msg)
  if debugMode then
    print("tools.BotDebug(msg)")
    EDDebug(msg)
  else
    tools.dumpErrorMsg()
  end
end)
