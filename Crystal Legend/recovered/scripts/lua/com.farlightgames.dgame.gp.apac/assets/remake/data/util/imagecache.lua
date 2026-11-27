local ImageCache = {}
ed.ImageCache = ImageCache
local IMAGE_SUFFIX = ".jpg"

function ImageCache.getCachePath()
  local path = CCFileUtils:sharedFileUtils():getWritablePath()
  if EDGetImageCachePath then
    path = EDGetImageCachePath()
  end
  return path
end

function ImageCache.getCache(photoId, bSmall)
  local filename = photoId .. IMAGE_SUFFIX
  if bSmall then
    filename = photoId .. "-small" .. IMAGE_SUFFIX
  end
  local cachePath = ImageCache.getCachePath()
  local fullPath = cachePath .. filename
  if EDGetFileData(fullPath) then
    return fullPath
  end
  return nil
end

function ImageCache.setCache(tmpPath, photoId, params)
  EDLog("setCache photoId:" .. photoId)
  local cachePath = ImageCache.getCachePath()
  local imageSavePath = cachePath .. photoId .. IMAGE_SUFFIX
  local smallImageSavePath = cachePath .. photoId .. "-small" .. IMAGE_SUFFIX
  local scaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
  CCDirector:sharedDirector():setContentScaleFactor(1)
  local width = params.width or 400
  local height = params.height or 400
  CCTextureCache:sharedTextureCache():removeTextureForKey(tmpPath)
  local image = CCSprite:create(tmpPath)
  local contentSize = image:getContentSize()
  local factor = width / contentSize.width
  if factor < height / contentSize.height then
    factor = height / contentSize.height
  end
  image:setScale(factor)
  image:setAnchorPoint(ccp(0, 0))
  local re = ed.RenderTextureCreate(width, height)
  re:begin()
  image:visit()
  re:endToLua()
  re.rt:saveToFile(imageSavePath)
  re.rt:release()
  local width2 = params.width2 or 104
  local height2 = params.height2 or 104
  local factor2 = width2 / contentSize.width
  if factor2 < height2 / contentSize.height then
    factor2 = height2 / contentSize.height
  end
  image:setScale(factor2)
  local re = ed.RenderTextureCreate(width2, height2)
  re:begin()
  image:visit()
  re:endToLua()
  re.rt:saveToFile(smallImageSavePath)
  re.rt:release()
  CCDirector:sharedDirector():setContentScaleFactor(scaleFactor)
  return imageSavePath, smallImageSavePath
end
