ed.display = ed.display or {}
local resourceSize = CCSizeMake(1920, 1080)
local designSize = CCSizeMake(960, 540)
local director = CCDirector:sharedDirector()
director:setAnimationInterval(0.016666666666666666)
local glview = director:getOpenGLView()
local fixDesignSize = CCSizeMake(designSize.width, designSize.height)
local frameSize = glview:getFrameSize()
local scaleX, scaleY = frameSize.width / designSize.width, frameSize.height / designSize.height
local scale = 1
if scaleX < scaleY then
  scale = scaleX
  fixDesignSize.height = frameSize.height / scale
else
  scale = scaleY
  fixDesignSize.width = frameSize.width / scale
end
glview:setDesignResolutionSize(fixDesignSize.width, fixDesignSize.height, 1)
local winSize = director:getWinSize()
local halfFixedWidth = (fixDesignSize.width - designSize.width) / 2
local halfFixedHeight = (fixDesignSize.height - designSize.height) / 2
local scaleFactor = resourceSize.width / designSize.width
director:setContentScaleFactor(scaleFactor)
print("======================display===========================")
print(string.format("frameSize:(%f, %f)", frameSize.width, frameSize.height))
print(string.format("designSize:(%f, %f)", designSize.width, designSize.height))
print(string.format("scaleFactor:%f", scaleFactor))
print(string.format("winSize:(%f, %f)", winSize.width, winSize.height))
print(string.format("halfFixSize:(%f, %f)", halfFixedWidth, halfFixedHeight))
print(string.format("glViewScale:(%f, %f)", scale, scale))
print("======================display===========================")
ed.display.fixDesignSize = fixDesignSize
ed.display.resourceSize = resourceSize
ed.display.designSize = designSize
ed.display.frameSize = frameSize
ed.display.winSize = winSize
ed.display.scaleFactor = scaleFactor
ed.display.halfFixedWidth = halfFixedWidth
ed.display.halfFixedHeight = halfFixedHeight
ed.display.glViewScale = scale
local center = ccp(winSize.width / 2, winSize.height / 2)
ed.display.center = center
ed.display.centerTop = ccp(center.x, winSize.height)
ed.display.centerBottom = ccp(center.x, 0)
ed.display.centerLeft = ccp(0, center.y)
ed.display.centerRight = ccp(winSize.width, center.y)
ed.display.aspectRatio = designSize.height / designSize.width
local ration = frameSize.height / frameSize.width - ed.display.aspectRatio
ed.display.fit = "high"
if math.abs(ration) < 0.1 then
  ed.display.fit = "fit"
elseif ration < 0 then
  ed.display.fit = "wide"
end
ed.display.resFactor = 1.5625
local notchHeight

function ed.display.getNotchHeight()
  if notchHeight == nil then
    if EDFLAGIOS then
      local bottom_bounds = ed.display.getDeviceInfo("bottom_bounds")
      bottom_bounds = tonumber(bottom_bounds)
      bottom_bounds = bottom_bounds * designSize.height / frameSize.height
      local dModel = ed.display.deviceInfo.device_model
      if string.match(dModel, "Pad") then
        return 0
      end
      local iosnotchHeight = ed.display.getIosNotchHeight(dModel)
      notchHeight = bottom_bounds + iosnotchHeight
    end
    if EDFLAGANDROID then
      notchHeight = EDGetParam("notchHeight")
      notchHeight = tonumber(notchHeight)
      notchHeight = notchHeight * designSize.height / frameSize.height
      print("notch height: ", notchHeight)
    end
  end
  return notchHeight or 0
end

function ed.display.getIosNotchHeight(deviceModel)
  local devPoint = 812
  if deviceModel == "iPhone 11" then
    devPoint = 896
  end
  local notchHeight = 44 / devPoint * ed.display.winSize.height
  return notchHeight
end

ed.display.deviceInfo = nil

function ed.display.getDeviceInfo(key)
  local ret
  if ed.display.deviceInfo == nil then
    local infoStr = EDGetParam("getDeviceInfo")
    print("getDeviceInfo infoStr:", infoStr)
    local json = require("json/json")
    ed.display.deviceInfo = json.decode(infoStr)
  end
  if key == nil then
    ret = ed.display.deviceInfo
    print("getDeviceInfo info")
  else
    ret = ed.display.deviceInfo[key]
    print("getDeviceInfo key:", key, " ret:", ret)
  end
  return ret
end

require("layoutHelper")
