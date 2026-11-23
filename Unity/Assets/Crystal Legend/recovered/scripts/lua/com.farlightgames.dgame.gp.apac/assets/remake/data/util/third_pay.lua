local class = {}
ed.third_pay = class
local base_urls = {
  [0] = "https://pay.lilith.com/xiaobingbing",
  [301] = "https://pay.lilith.com/xiaobingbingptr",
  [302] = "https://pay.lilith.com/xiaobingbing",
  [501] = "https://store.farlightgames.com/cl"
}
local base_urls_test = {
  [0] = "https://pay-uat.lilith.com/xiaobingbing",
  [301] = "https://pay-uat.lilith.com/xiaobingbingptr",
  [302] = "https://pay-uat.lilith.com/xiaobingbing",
  [501] = "https://store-uat.farlightgames.com/cl"
}
local game_id = 10078
local app_ids = {
  [0] = 10002735,
  [301] = 10012226,
  [302] = 10002735,
  [501] = 10023581
}

local function ToBase64(source_str)
  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local s64 = ""
  local str = source_str
  while 0 < #str do
    local bytes_num = 0
    local buf = 0
    for byte_cnt = 1, 3 do
      buf = buf * 256
      if 0 < #str then
        buf = buf + string.byte(str, 1, 1)
        str = string.sub(str, 2)
        bytes_num = bytes_num + 1
      end
    end
    for group_cnt = 1, bytes_num + 1 do
      local b64char = math.fmod(math.floor(buf / 262144), 64) + 1
      s64 = s64 .. string.sub(b64chars, b64char, b64char)
      buf = buf * 64
    end
    for fill_cnt = 1, 3 - bytes_num do
      s64 = s64 .. "="
    end
  end
  return s64
end

local function url_encode(str)
  str = str:gsub("\n", "\r\n")
  str = str:gsub("([^%w%-_%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  return str
end

function class:setAppUid_AppToken(app_uid, app_token)
  self.app_uid = app_uid
  self.app_token = url_encode(ToBase64(app_token))
end

function class:goPay()
  _sdkType = EDSDKType
  if not base_urls[_sdkType] then
    ed.showToast(T("\232\175\165\230\184\160\233\129\147\228\184\141\230\148\175\230\140\129\228\184\137\230\150\185\230\148\175\228\187\152") .. _sdkType)
    return
  end
  local base_url = base_urls[_sdkType]
  if ed.third_pay_test then
    base_url = base_urls_test[_sdkType]
  end
  local app_id = app_ids[_sdkType]
  local url = string.format("%s?game_id=%d&app_id=%d&app_token=%s&app_uid=%s", base_url, game_id, app_id, self.app_token or "", self.app_uid or "")
  EDLog(url)
  ed.openURL(url)
end
