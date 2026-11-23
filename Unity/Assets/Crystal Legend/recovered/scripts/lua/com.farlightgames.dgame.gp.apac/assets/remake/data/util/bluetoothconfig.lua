local bluetooth = {}
local deviceModeName = {
  [1] = T("\229\174\137\229\141\147\231\148\168\230\136\183"),
  [2] = T("\232\139\185\230\158\156\231\148\168\230\136\183")
}
local deviceMode = 1
local amIMaster = true
local bluetoothSocket

local function getDeviceMode()
  return deviceMode
end

bluetooth.getDeviceMode = getDeviceMode

local function setDeviceMode(mode)
  deviceMode = mode
end

bluetooth.setDeviceMode = setDeviceMode

local function getDeviceModeName()
  return deviceModeName[deviceMode]
end

bluetooth.getDeviceModeName = getDeviceModeName

local function switchMasterMode()
  amIMaster = not amIMaster
end

bluetooth.switchMasterMode = switchMasterMode

local function getMasterMode()
  return amIMaster
end

bluetooth.getMasterMode = getMasterMode
return bluetooth
