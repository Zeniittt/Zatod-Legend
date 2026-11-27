local function formatReportServerId(serverId)
  local serverIdInt = tonumber(serverId)
  
  if 29000 < serverIdInt and serverIdInt < 30000 then
    serverId = "qa-" .. serverId
  elseif EDSDKType > 500 then
    serverId = "farlight:global:obt-" .. serverId
  else
    serverId = "official-" .. serverId
  end
  return serverId
end

ed.formatReportServerId = formatReportServerId
local _EDReportEvent = EDReportEvent

local function _y_getEventData(param1)
  local serverId = game_server_id or "0"
  local open_id = ed.getDeviceId() or "open_id"
  local role_id = ed.getRoleId() or "role_id"
  serverId = formatReportServerId(serverId)
  local nInfo = {
    event_value1 = param1 or serverId,
    event_value2 = role_id,
    event_value3 = {
      open_id = open_id,
      server_id = serverId,
      role_id = role_id
    }
  }
  local njson = ed.getJson(nInfo)
  return njson
end

function EDReportEvent(name, data)
  if name == "Purchase" then
    return
  elseif name == "acc_create" then
    if _EDReportEvent then
      _EDReportEvent(name, data)
    end
    return
  end
  local new_data = _y_getEventData(data)
  if _EDReportEvent then
    _EDReportEvent(name, new_data)
  end
  print("@@@@@@@@@EDReportEvent@@@@@@@@@", data)
end

function EDUrlInfoForWXMiniProgram()
  local urlInfo = {}
  local package_name = "com.lilithgame.dgame.official"
  local _sdkType = 302
  local app_id = "10002735"
  if EDSDKType == 301 or EDSDKType == 302 or EDSDKType == 303 then
    _sdkType = EDSDKType
  end
  if _sdkType == 301 then
    app_id = "10012226"
  end
  local app_uid = ed.getDeviceId() or "app_uid"
  local gm_openid = string.format("%s-%s", app_id, app_uid)
  if EDFLAGIOS then
    package_name = ed.lookupDataTable("ChannelPackage", "IOS Package Name", _sdkType)
  elseif EDFLAGANDROID then
    package_name = ed.lookupDataTable("ChannelPackage", "Android Package Name", _sdkType)
  end
  urlInfo.package_name = package_name
  urlInfo.app_id = app_id
  urlInfo.app_uid = app_uid
  urlInfo.gm_openid = gm_openid
  urlInfo.source = "app"
  urlInfo.t = ed.getSystemTime()
  urlInfo.url = string.format("xxx.com?package_name=%s&app_id=%s&app_uid=%s&gm_openid=%s&source=%s&t=%d", urlInfo.package_name, urlInfo.app_id, urlInfo.app_uid, urlInfo.gm_openid, urlInfo.source, urlInfo.t)
  print(urlInfo)
  return urlInfo
end
