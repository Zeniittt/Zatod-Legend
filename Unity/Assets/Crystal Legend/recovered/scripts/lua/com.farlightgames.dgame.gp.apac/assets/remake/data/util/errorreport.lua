ed.errorReportUrl = "http://bugreport.dgame.lilithgame.com:9999/report/do"
local errUrl = ed.errorReportUrl
errTimeTable = {
  dir_fetch = {time = 0},
  back_fetch = {time = 0},
  update_fetch = {time = 0},
  login = {time = 0},
  crash_dump = {time = 0}
}

function errFrequency(code)
  local timeNow = os.time()
  if code == "dir_fetch" or code == "back_fetch" then
    if timeNow - errTimeTable[code].time > 15 then
      errTimeTable[code].time = timeNow
      return true
    else
      return false
    end
  end
  if code == "update_fetch" or code == "login" then
    if timeNow - errTimeTable[code].time > 15 then
      errTimeTable[code].time = timeNow
      return true
    else
      return false
    end
  end
  if code == "crash_dump" then
    if timeNow - errTimeTable[code].time > 15 then
      errTimeTable[code].time = timeNow
      return true
    else
      return false
    end
  end
end

function httpPost(msg, errurl)
  local http = require("socket.http")
  local requestBody = msg
  local responseBody = {}
  res, code, responseHeader = http.request({
    url = errurl,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = #requestBody
    },
    source = ltn12.source.string(requestBody),
    sink = ltn12.sink.table(responseBody)
  })
  EDLog("connection status:" .. code)
  EDLog("http responseheader:")
  if responseHeader then
    EDLog("post operation succceed!")
    EDLog(requestBody)
  else
    EDLog("failed!")
    EDLog(requestBody)
  end
end

function errReport(code, msg)
  if EDFLAGWP8 then
    EDLog("this platform cannot support errReport function")
    return
  end
  if not EDFLAGIOS and not EDFLAGANDROID then
    return
  end
  if errFrequency(code) then
    local url = errUrl
    local trbk = debug.traceback() or ""
    local text = tostring(msg) .. "\n" .. trbk
    text = string.gsub(text, "\"", "'")
    text = string.gsub(text, [=[
[
	]]=], "|")
    local table = getCrashMessage(code, text)
    jsonStr = jsonStrEncode(table)
    httpPost(jsonStr, url)
  end
end

function getSDKType(edsdktype)
  local sdk = EDSDKType
  if sdk == 104 then
    return "360"
  elseif sdk == 105 then
    return "uc"
  elseif sdk == 113 then
    return "s37wan"
  elseif sdk == 115 then
    return "lenovo"
  elseif sdk == 116 then
    return "pptv"
  elseif sdk == 119 then
    return "jinshan"
  elseif sdk == 121 then
    return "kugou"
  elseif sdk == 132 then
    return "kuwo"
  elseif sdk == 133 then
    return "putao"
  elseif sdk == 139 then
    return "kugou"
  elseif sdk == 143 then
    return "duowan"
  elseif sdk == 153 then
    return "yingyongbao"
  elseif sdk == 154 then
    return "meizu"
  else
    return "unknown"
  end
end

function getCrashMessage(errCode, errMsg)
  local osType = "null"
  local osVersion = "null"
  if EDFLAGWIN32 then
    osType = "win32"
  elseif EDFLAGANDROID then
    osType = "android"
    if EDGetAndroidVersion then
      osVersion = EDGetAndroidVersion()
    end
  elseif EDFLAGIOS then
    osType = "ios"
    if EDGetIosVersion then
      osVersion = EDGetIosVersion()
    end
  elseif EDFLAGWP8 then
    osType = "wp8"
  else
    osType = "unknown"
  end
  local platform = "null"
  platform = getSDKType()
  local netType = "null"
  if EDGetNetworkType then
    netType = EDGetNetworkType()
  end
  local userid = ed.getUserid()
  local gameVersion = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  local binaryVersion = CCUserDefault:sharedUserDefault():getStringForKey("bundle-version") or ""
  local messTable = {
    error_code = errCode or "",
    os_type = osType or "",
    os_version = osVersion or "",
    net_type = netType or "",
    platform = platform or "",
    binary_version = binaryVersion or "",
    game_version = gameVersion or "",
    uid = userid or "",
    svrid = game_server_id or "",
    url = game_server_ip or "",
    mesg = errMsg or ""
  }
  return messTable
end

function jsonStrEncode(table)
  local jsonString = ""
  jsonString = jsonString .. "{"
  local symbol = ""
  for k, v in pairs(table) do
    jsonString = jsonString .. symbol .. "\"" .. k .. "\"" .. ":" .. "\"" .. v .. "\""
    symbol = ","
  end
  jsonString = jsonString .. "}"
  return jsonString
end
