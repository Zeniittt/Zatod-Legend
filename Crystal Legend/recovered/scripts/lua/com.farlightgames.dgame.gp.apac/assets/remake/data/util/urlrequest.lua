UrlRequest = {}
UrlRequest.__index = UrlRequest

function UrlRequest.create(url, callback)
  local request = {}
  setmetatable(request, UrlRequest)
  request:setUrl(url)
  request:setCallback(callback)
  return request
end

function UrlRequest:setUrl(url)
  self.url = url
end

function UrlRequest:getUrl()
  return self.url
end

function UrlRequest:setCallback(callback)
  self.callback = callback
end

function UrlRequest:getCallback()
  return self.callback
end

function UrlRequest:setTag(tag)
  self.tag = tag
end

function UrlRequest:getTag()
  return self.tag
end

function UrlRequest:setCacheName(cacheName)
  self.cacheName = cacheName
end

function UrlRequest:getCacheName()
  return self.cacheName
end
