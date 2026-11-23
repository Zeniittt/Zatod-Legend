module("ed.bot", package.seeall)
package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("bot/tools")
require("tools")
require("socket")
require("pb")
require("bot/ipconfig")
local host = ipconfig.host
local port = ipconfig.port
local name = "shiyu"
local up = pb_loader("bot/up")()
local down = pb_loader("bot/down")()
local upmsg = up.pvp_parameter
local downmsg = down.pvp_resultData
print("upmsg", upmsg)
print("downmsg", downmsg)
local connection
local output_folder = "arean_pvp"
local pvp_bot_csv = "BotPVPTeams"
local highlight = {}
local comment = "100,aller"
local pvpParameter = {
  warschoolLevel = 0,
  bookReadingLevel = 0,
  max_rank = 16,
  arenaLevel = 100,
  generationNum = 3,
  maxHeroId = 10014,
  heroStar = 5,
  teamNumber = 3,
  variationProbability = 0.6,
  specifyHeroID = 87,
  heroAwake = {
    _status = 1,
    _str = 100,
    _int = 100,
    _agi = 100
  },
  heroSuperAwake = {_status = 1},
  cullHeroeIds = {
    [100] = true,
    [94] = true,
    [96] = true,
    [97] = true,
    [98] = true,
    [99] = true,
    [10003] = true,
    [10004] = true,
    [10005] = true,
    [10006] = true,
    [10007] = true,
    [10010] = true,
    [10019] = true
  }
}
local successful = false

local function getParamsMsg()
  local sendMsg = upmsg()
  sendMsg._warschoolLevel = pvpParameter.warschoolLevel
  sendMsg._bookReadingLevel = pvpParameter.bookReadingLevel
  sendMsg._maxRank = pvpParameter.max_rank
  sendMsg._arenaLevel = pvpParameter.arenaLevel
  sendMsg._generationNum = pvpParameter.generationNum
  sendMsg._maxHeroId = pvpParameter.maxHeroId
  sendMsg._heroStar = pvpParameter.heroStar
  sendMsg._teamNumber = pvpParameter.teamNumber
  sendMsg._variationProbability = pvpParameter.variationProbability
  sendMsg._specifyHeroID = pvpParameter.specifyHeroID
  sendMsg._awake = pvpParameter.heroAwake
  sendMsg._superAwake = pvpParameter.heroSuperAwake
  local cullHeroeIdList = {}
  for id, value in pairs(pvpParameter.cullHeroeIds) do
    table.insert(cullHeroeIdList, id)
  end
  sendMsg._cullHeroeIds = cullHeroeIdList
  sendMsg._name = name
  return sendMsg
end

local function connect()
  print("trying to connect ... ")
  local err
  connection, err = socket.connect(host, port)
  if not connection then
    print("socket.connect() failed. | " .. err)
    return
  end
  connection:settimeout(0)
  print("connectted success")
end

local function pack_size(code)
  local length = #code
  local second = string.char(length % 256)
  local first = string.char(math.floor(length / 256))
  return first .. second .. code
end

local function send(msg)
  if not connection then
    connect()
  end
  if not connection then
    return
  else
    local code = pack_size(msg:Serialize())
    local r1, r2 = connection:send(code)
    if not r1 then
      print("Send report failed|" .. r2)
    end
    print("client send report success")
  end
end

local function writeParams()
  os.execute("md " .. output_folder)
  local params_out = io.open(string.format(output_folder .. "/[params].txt"), "w+")
  params_out:write("max_rank=" .. pvpParameter.max_rank .. "\n")
  params_out:write("teamNumber=" .. pvpParameter.teamNumber .. "\n")
  params_out:write("level=" .. pvpParameter.arenaLevel .. "\n")
  params_out:write("heroStar=" .. pvpParameter.heroStar .. "\n")
  local heroAwake = pvpParameter.heroAwake
  params_out:write("heroAwake={_status=" .. heroAwake._status .. ",_str=" .. heroAwake._str .. ",_int=" .. heroAwake._int .. ",_agi=" .. heroAwake._agi .. "}\n")
  local heroSuperAwake = pvpParameter.heroSuperAwake
  params_out:write("heroSuperAwake = {_status=" .. heroSuperAwake._status .. "}\n")
  params_out:write("cullHeroeIds={")
  for id, b in pairs(pvpParameter.cullHeroeIds) do
    if b then
      params_out:write(id .. ",")
    end
  end
  params_out:write("}\n")
  if comment then
    params_out:write("comment=" .. comment .. "\n")
  end
  params_out:flush()
  params_out:close()
end

local roundData, totalData

local function openTotal()
  local totalDataFileName = string.format(output_folder .. "/arena_" .. pvpParameter.arenaLevel .. ".txt")
  totalData = tools.openFile(totalDataFileName)
end

local function closeTotal()
  if totalData then
    totalData:close()
  end
end

local function openRound()
  local roundDataFileName = string.format(output_folder .. "/[result].txt")
  roundData = tools.openFile(roundDataFileName)
end

local function closeRound()
  if roundData then
    roundData:close()
  end
end

local function writeRound(pvpData)
  local totalTime = pvpData._totalTime
  local drawBout = pvpData._drawBout
  local totalBout = pvpData._totalBout
  local generation = pvpData._generation
  local buffer = "generation :" .. generation .. "\n" .. "Average Time: " .. totalTime / totalBout .. "\n" .. "Draw Times/Total:" .. drawBout .. "/" .. totalBout .. "(" .. drawBout / totalBout .. ") folder:" .. output_folder .. "|" .. comment .. [[


]]
  roundData:write(buffer)
  roundData:flush()
end

local function getTeamStatus(index, position)
  local teamStatus
  if not position then
    teamStatus = "new"
  elseif index == position then
    teamStatus = "="
  else
    teamStatus = string.format("%+i", position - index)
  end
  return teamStatus
end

local function getParas(index, team)
  local paras = {index}
  local rc = getTeamStatus(index, team._position)
  table.insert(paras, rc)
  for _, h in ipairs(team._heroes) do
    table.insert(paras, h._name)
  end
  table.insert(paras, team._score)
  return paras
end

local function writeTotal(pvpData)
  local generation = pvpData._generation
  local allformat = "%i,%s:(%s),%s,%s,%s,%s,%s,%s"
  local teamList = pvpData._teamList
  local buff = ""
  for index = 1, #teamList do
    local team = teamList[index]
    local paras = getParas(index, team)
    local str = string.format(allformat, generation, unpack(paras)) .. "\n"
    buff = buff .. str
  end
  totalData:write(buff)
  totalData:flush()
end

local function writeDataFile(pvpData)
  local generation = pvpData._generation
  local teamList = pvpData._teamList
  local buff = ""
  local format = "%s:(%s)\t %s %s %s %s %s score: %s"
  for index = 1, #teamList do
    local team = teamList[index]
    local paras = getParas(index, team)
    local str = string.format(format, unpack(paras)) .. "\n"
    buff = buff .. str
  end
  local outFileName = string.format(output_folder .. "/arena_%i_Genetation_%i.txt", pvpParameter.arenaLevel, generation)
  local out = tools.openFile(outFileName)
  out:write(buff)
  out:close()
end

local function normalization(paras)
  for i, ele in ipairs(paras) do
    local len = 10 - string.len(ele)
    for k = 1, len do
      paras[i] = paras[i] .. " "
    end
  end
end

local function resultConsoleOutput(teamList)
  local windowFormat = "%s%s%s%s%s%s"
  local printBuff = ""
  for index = 1, #teamList do
    local team = teamList[index]
    local status = getTeamStatus(index, team._position)
    local paras = {}
    paras[1] = index .. ":(" .. status .. ")"
    for _, h in ipairs(team._heroes) do
      local showName = h._name
      if highlight[h._name] then
        showName = showName .. highlight[h._name]
      end
      table.insert(paras, showName)
    end
    normalization(paras)
    local str = string.format(windowFormat, unpack(paras))
    printBuff = printBuff .. str .. " score: " .. team._score .. "\n"
  end
  return printBuff
end

local function consolePrint(pvpData)
  local generation = pvpData._generation
  print("Generation " .. generation)
  local teamList = pvpData._teamList
  local buff = resultConsoleOutput(teamList)
  print(buff)
  local totalTime = pvpData._totalTime
  local drawBout = pvpData._drawBout
  local totalBout = pvpData._totalBout
  print("Average Time: " .. totalTime / totalBout)
  print("Draw Times/Total:" .. drawBout .. "/" .. totalBout .. "(" .. drawBout / totalBout .. ") folder:" .. output_folder .. "|" .. comment)
end

local filesOpen = false

local function openFiles()
  writeParams()
  openTotal()
  openRound()
  filesOpen = true
end

local function closeFiles()
  closeTotal()
  closeRound()
end

local function analResult(resultData)
  print("receve data form server")
  local generation = resultData._generation
  if generation == 1 or not filesOpen then
    openFiles()
  end
  writeRound(resultData)
  writeTotal(resultData)
  writeDataFile(resultData)
  consolePrint(resultData)
  if generation == pvpParameter.generationNum then
    closeFiles()
    successful = true
    print("task in successful,you can close this windows")
  end
end

local function analBuffer(buffer)
  local pvp_resultData, err = downmsg():Parse(buffer)
  if pvp_resultData and pvp_resultData._result then
    for i, result in ipairs(pvp_resultData._result) do
      analResult(result)
    end
  end
end

local function recBuffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = connection:receive(size_left)
  if err == "closed" then
    print("socket closed by server.")
    connection:close()
    connection = nil
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
  if not connection then
    connect()
  end
  if connection then
    local buffer_size_str, err = connection:receive(2)
    if err == "closed" then
      print("connection closed")
      connection:close()
      connection = nil
    end
    if buffer_size_str then
      local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
      local buffer = recBuffer(buffer_size, "")
      analBuffer(buffer)
    end
  end
end

local function sleep(time)
  pcall(function()
    socket.select(nil, nil, time)
  end)
end

local function receiveResult()
  while true do
    if successful then
      sleep(100000)
    else
      receiveMsg()
      sleep(5)
    end
  end
end

local function setParams()
  local sendMsg = getParamsMsg()
  send(sendMsg)
  print("server bagin excute,palease wait a moment\n")
end

xpcall(function()
  setParams()
  receiveResult()
end, tools.BotDebug)
