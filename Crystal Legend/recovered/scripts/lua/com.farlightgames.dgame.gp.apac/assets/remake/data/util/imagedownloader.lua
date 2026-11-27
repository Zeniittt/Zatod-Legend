local ImageDownloader = {}
ImageDownloader.__index = ImageDownloader
ed.ImageDownloader = ImageDownloader
ed.downloadByLua = false
local http = require("socket.http")

function ImageDownloader.send(request)
  local url = request:getUrl()
  local callback = request:getCallback()
  local cacheName = request:getCacheName()
  if EDGetImageByUrl then
    EDGetImageByUrl(url, callback, cacheName)
  else
  end
end

function ImageDownloader.downloadByLua(url, callback, cacheName)
  local r, c, h = http.request(url)
  if c == 200 and h["content-type"] == "image/jpeg" then
    local cachePath = ed.ImageCache.getCachePath()
    local fullPath = cachePath .. cacheName
    local file = io.open(fullPath, "wb")
    if file then
      file:write(r)
      file:close()
      if callback then
        callback(fullPath)
      end
    end
  else
    EDLog("download by lua error!!!")
  end
end

function ImageDownloader.asyncDownload(url, callback, cacheName)
  local params = LuaHttpParams:create()
  params:setUrl(url)
  
  local function func(result, data, tag)
    if result then
      local cachePath = ed.ImageCache.getCachePath()
      local fullPath = cachePath .. cacheName
      local file = io.open(fullPath, "wb")
      if file then
        file:write(data)
        file:close()
        if callback then
          callback(fullPath)
        end
      end
    end
  end
  
  params:setCallback(func)
  LuaHttpClient:getInstance():asyncGet(params)
end
