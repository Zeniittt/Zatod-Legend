local UploadImage = {}
UploadImage.__index = UploadImage
local UploadImageScope = {}
ed.openUploadImage = true
ed.openCheckImage = true
local CDN_URL = "http://dotaimg.lilithcdn.com/"

function UploadImage.create()
  local self = {}
  setmetatable(self, UploadImage)
  self:registerEvent()
  return self
end

function UploadImage:destroy()
  CloseScope(UploadImageScope)
end

function UploadImage:registerEvent()
  ListenEvent("onCreateCustomizePhotoResult", function(path)
    self:onCreateCustomizePhotoResult(path)
  end, UploadImageScope)
  ListenEvent("onUploadPhotoResult", function(result, reason)
    self:onUploadPhotoResult(result, reason)
  end, UploadImageScope)
end

function UploadImage:onCreateCustomizePhotoResult(path)
  ListenTimer(Timer:Once(0.1), function()
    if path and path ~= "" then
      EDLog("onCreateCustomizePhotoResult path:" .. path)
      self.photoId = UploadImage.getImageMd5(path)
      self.cachePath = ed.ImageCache.setCache(path, self.photoId, {
        width = self.width,
        height = self.height
      })
      self:upload(self.cachePath, self.photoId .. ".jpg", self.token)
    end
  end, UploadImageScope)
end

function UploadImage:onUploadPhotoResult(result, reason)
  ListenTimer(Timer:Once(0.1), function()
    if result == "success" then
      local res = self.checkImage(self.photoId)
      if res then
        ed.showToast(T("\228\184\138\228\188\160\230\136\144\229\138\159"))
        EDLog("upload photo success")
        if self.callback then
          self.callback(self.cachePath, self.photoId)
        end
      else
        ed.showToast(T("\229\155\190\231\137\135\229\140\133\229\144\171\228\184\141\232\137\175\229\134\133\229\174\185\239\188\140\228\184\138\228\188\160\229\164\177\232\180\165"))
      end
    else
      ed.showToast(T("\228\184\138\228\188\160\229\164\177\232\180\165\239\188\154%s", reason))
      EDLog("upload photo failed, reason:" .. reason)
    end
  end, UploadImageScope)
end

function UploadImage.checkImage(photoId)
  if not ed.openCheckImage then
    return
  end
  local isOk = true
  local http = require("socket.http")
  local json = require("json/json")
  local url = CDN_URL .. photoId .. ".jpg"
  local r, c, h = http.request(url .. "?qpulp")
  if c == 200 and r then
    local jsonResponse = json.decode(r)
    if jsonResponse.code == 0 then
      if jsonResponse.result and jsonResponse.result.label then
        if jsonResponse.result.label == 2 or jsonResponse.result.label == 1 then
          isOk = true
        else
          isOk = false
        end
      end
    else
      EDLog("check image message: " .. jsonResponse.message)
    end
  else
    EDLog("check image error 1")
  end
  if isOk then
    local r, c, h = http.request(url .. "?qpolitician")
    if c == 200 and r then
      local jsonResponse = json.decode(r)
      if jsonResponse.code == 0 then
        if jsonResponse.result and jsonResponse.result.detections then
          if #jsonResponse.result.detections == 0 or jsonResponse.message == "No valid face info detected" then
            isOk = true
          elseif 0 < #jsonResponse.result.detections then
            for i, info in pairs(jsonResponse.result.detections) do
              if info.value.name then
                isOk = false
                break
              end
            end
          end
        end
      else
        EDLog("check image message: " .. jsonResponse.message)
      end
    else
      EDLog("check image error 2")
    end
  end
  return isOk
end

function UploadImage.getImageMd5(path)
  local file_content = EDGetFileData(path)
  local sum = md5.sum(file_content .. ed.getServerTime())
  return string.gsub(sum, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
end

function UploadImage:upload(path, name, token)
  if ed.openUploadImage then
    if EDFLAGWIN32 then
      FireEvent("onUploadPhotoResult", "success", "")
      return
    end
    EDLog("UploadImage:upload begin")
    if EDUploadPhoto then
      local param = {constant = 2}
      ed.showToast(T("\229\155\190\231\137\135\228\184\138\228\188\160\228\184\173"), param)
      EDUploadPhoto(path, name, token)
    end
  end
end

function UploadImage:createCustomizePhoto(width, height, token, callback)
  if EDSDKType == 158 then
    ed.showToast(T("\229\189\147\229\137\141\230\184\160\233\129\147\228\184\141\230\148\175\230\140\129\228\184\138\228\188\160\229\164\180\229\131\143"))
    return
  end
  if not EDCreateCustomizePhoto then
    ed.showToast(T("\232\175\183\229\137\141\229\190\128\229\186\148\231\148\168\229\149\134\229\186\151\228\184\139\232\189\189\230\156\128\230\150\176\231\137\136\230\156\172"))
    return
  end
  self.width = width
  self.height = height
  self.token = token
  self.callback = callback
  EDCreateCustomizePhoto(width, height)
end

function UploadImage:getImage(photoId, bSmall, callback)
  local cachePath = ed.ImageCache.getCache(photoId, bSmall)
  if cachePath then
    if callback then
      callback(cachePath)
    end
    return
  end
  self:downloadImage(photoId, bSmall, callback)
end

function UploadImage:downloadImage(photoId, bSmall, callback)
  local processStyle = ""
  if bSmall then
    processStyle = "-small"
  end
  local cacheName = photoId .. processStyle .. ".jpg"
  local url = CDN_URL .. photoId .. ".jpg" .. processStyle
  local urlRequest = UrlRequest.create(url, callback)
  urlRequest:setCacheName(cacheName)
  ed.ImageDownloader.send(urlRequest)
end

ed.UploadImage = UploadImage.create()
