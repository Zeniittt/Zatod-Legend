module("ed.sdk", package.seeall)
PlatformIDs = {lemanfat = 103}

function sdkInit()
  if ed.isElementInTable(EDSDKType, PlatformIDs) then
    EDAndroidExtra("sdkInit", "")
  end
end
