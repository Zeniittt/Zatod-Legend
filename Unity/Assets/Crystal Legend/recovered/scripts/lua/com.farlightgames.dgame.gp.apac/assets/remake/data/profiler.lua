local config = {
  outputFile = "profiler.lua",
  emptyToThis = "~",
  fW = 80,
  fnW = 28,
  lW = 7,
  tW = 7,
  rW = 6,
  cW = 5,
  reportSaved = "> Report saved to: "
}
local module = {}
local getTime = os.clock
local string, debug, table = string, debug, table
local reportCache = {}
local allReports = {}
local reportCount = 0
local startTime = 0
local stopTime = 0
local printFun
local verbosePrint = false
local outputHeader, formatHeader, outputTitle, formatOutput, formatTotalTime, formatFunLine, formatFunTime, formatFunRelative, formatFunCount, divider, nilTime

local function deepCopy(input)
  if type(input) == "table" then
    local output = {}
    for i, o in next, input, nil do
      output[deepCopy(i)] = deepCopy(o)
    end
    return output
  else
    return input
  end
end

local function charRepetition(n, character)
  local s = ""
  character = character or " "
  for _ = 1, n do
    s = s .. character
  end
  return s
end

local function singleSearchReturn(inputString, search)
  for _ in string.gmatch(inputString, search) do
    return true
  end
  return false
end

local function rebuildColumnPatterns()
  local c = config
  local str = "s: %-"
  outputHeader = "| %-" .. c.fW .. str .. c.fnW .. str .. c.lW .. str .. c.tW .. str .. c.rW .. str .. c.cW .. "s|\n"
  formatHeader = string.format(outputHeader, "FILE", "FUNCTION", "LINE", "TIME", "%", "#")
  outputTitle = "%-" .. c.fW .. "." .. c.fW .. str .. c.fnW .. "." .. c.fnW .. str .. c.lW .. "s"
  formatOutput = "| %s: %-" .. c.tW .. str .. c.rW .. str .. c.cW .. "s|\n"
  formatTotalTime = "Total time: %f s\n"
  formatFunLine = "%" .. c.lW - 2 .. "i"
  formatFunTime = "%04.4f"
  formatFunRelative = "%03.1f"
  formatFunCount = "%" .. c.cW - 1 .. "i"
  divider = charRepetition(#formatHeader - 1, "-") .. "\n"
  nilTime = "0.0000"
end

local function functionReport(information)
  local src = information.short_src
  if not src then
    src = "<C>"
  elseif string.sub(src, #src - 3, #src) == ".lua" then
    src = string.sub(src, 1, #src - 4)
  end
  local name = information.name
  if not name then
    name = "Anon"
  elseif string.sub(name, #name - 1, #name) == "_l" then
    name = string.sub(name, 1, #name - 2)
  end
  local title = string.format(outputTitle, src, name, string.format(formatFunLine, information.linedefined or 0))
  local report = reportCache[title]
  if not report then
    report = {
      title = string.format(outputTitle, src, name, string.format(formatFunLine, information.linedefined or 0)),
      count = 0,
      timer = 0
    }
    reportCache[title] = report
    reportCount = reportCount + 1
    allReports[reportCount] = report
  end
  return report
end

local function onDebugHook(hookType)
  local information = debug.getinfo(2, "nS")
  if hookType == "call" then
    local funcReport = functionReport(information)
    funcReport.callTime = getTime()
    funcReport.count = funcReport.count + 1
  elseif hookType == "return" then
    local funcReport = functionReport(information)
    if funcReport.callTime and funcReport.count > 0 then
      funcReport.timer = funcReport.timer + (getTime() - funcReport.callTime)
    end
  end
end

function module.attachPrintFunction(fn, verbose)
  printFun = fn
  verbosePrint = verbose or false
end

function module.start()
  if not outputHeader then
    rebuildColumnPatterns()
  end
  reportCache = {}
  allReports = {}
  reportCount = 0
  startTime = getTime()
  stopTime = nil
  debug.sethook(onDebugHook, "cr", 0)
end

function module.stop()
  stopTime = getTime()
  debug.sethook()
end

function module.report(filename)
  if not stopTime then
    module.stop()
  end
  filename = filename or "profiler.log"
  table.sort(allReports, function(a, b)
    return a.timer > b.timer
  end)
  local fileWriter = io.open(filename, "w+")
  local divide = false
  local totalTime = stopTime - startTime
  local totalTimeOutput = "> " .. string.format(formatTotalTime, totalTime)
  fileWriter:write(totalTimeOutput)
  if printFun ~= nil then
    printFun(totalTimeOutput)
  end
  fileWriter:write(divider)
  fileWriter:write(formatHeader)
  fileWriter:write(divider)
  for i = 1, reportCount do
    local funcReport = allReports[i]
    if funcReport.count > 0 and totalTime >= funcReport.timer then
      local printThis = true
      if config.outputFile ~= "" and singleSearchReturn(funcReport.title, config.outputFile) then
        printThis = false
      end
      if printThis and singleSearchReturn(funcReport.title, "[[C]]") then
        printThis = false
      end
      if printThis then
        local count = string.format(formatFunCount, funcReport.count)
        local timer = string.format(formatFunTime, funcReport.timer)
        local relTime = string.format(formatFunRelative, funcReport.timer / totalTime * 100)
        if not divide and timer == nilTime then
          fileWriter:write(divider)
          divide = true
        end
        if timer == nilTime then
          timer = config.emptyToThis
          relTime = config.emptyToThis
        end
        local output = string.format(formatOutput, funcReport.title, timer, relTime, count)
        fileWriter:write(output)
        if printFun ~= nil and verbosePrint then
          printFun(output)
        end
      end
    end
  end
  fileWriter:write(divider)
  fileWriter:close()
  if printFun ~= nil then
    printFun(config.reportSaved .. "'" .. filename .. "'")
  end
end

function module.configuration(overrides)
  local safe = deepCopy(overrides)
  for k, v in pairs(safe) do
    if config[k] == nil then
      print("error: override field '" .. k .. "' not found (configuration)")
    else
      config[k] = v
    end
  end
  rebuildColumnPatterns()
end

return module
