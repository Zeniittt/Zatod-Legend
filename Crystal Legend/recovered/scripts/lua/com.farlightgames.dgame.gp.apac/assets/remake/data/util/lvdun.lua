LvDun = {}
local json = require("json/json")
ed.openLvDun = false

function LvDun.msgCheck(msg, callback)
  local appId = "201802270003"
  LvDun.check(appId, msg, callback)
end

function LvDun.nameCheck(name, callback)
  local appId = "201802270004"
  LvDun.check(appId, name, callback)
end

function LvDun.check(appId, content, callback)
  if LuaHttpParams == nil or not ed.openLvDun then
    callback(true)
    return
  end
  local API_URL = "http://api.jiuanyun.cn:8080/v2/text"
  local secretKey = "AEC8939AC34B4F3D0878D82EC8DA9738"
  local postData = {}
  postData.appId = appId
  postData.timestamp = ed.getServerTime() * 1000
  postData.nonce = math.ceil(math.random())
  
  local function getSignature(data, secretKey)
    local sum = md5.sum(data .. "," .. secretKey)
    local md5_value = string.gsub(sum, ".", function(c)
      return string.format("%02x", string.byte(c))
    end)
    return md5_value
  end
  
  postData.signature = getSignature(postData.appId .. "," .. postData.timestamp, secretKey)
  postData.id = math.ceil(math.random())
  postData.content = content
  local params = LuaHttpParams:create()
  params:setUrl(API_URL)
  params:setHeader("Content-Type: application/json")
  params:setHeader("Content-Encoding: UTF-8")
  params:setPostData(ed.getJson(postData))
  
  local function func(result, data, tag)
    if result then
      local jsonResponse = json.decode(data)
      if jsonResponse.code == 200 then
        if jsonResponse.result.action == 1 then
          callback(true)
        else
          callback(false)
        end
      end
    else
      callback(true)
    end
  end
  
  params:setCallback(func)
  LuaHttpClient:getInstance():asyncPost(params)
end
