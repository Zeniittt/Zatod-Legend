module("eddebug", package.seeall)
local userid = 0
local cryptkey = ""
local sceneIdentity = {}

local function printGarbageLog(log)
  local fmt = "%s[VM GCDebt: %f]"
  print(string.format(fmt, log, collectgarbage("count")))
end

local function printSceneStack()
  local fmt = "+++++++++++++"
  local count = #ed.scene_stack
  for idx = count, 1, -1 do
    print(fmt .. idx, ed.scene_stack[idx].identity)
  end
end

local function reloadFirstScene()
  local name = sceneIdentity[1]
  assert(nil ~= name, "invalid scene name!")
  local scene = ed.ui[name].create()
  CCDirector:sharedDirector():replaceScene(scene:ccScene())
  for idx in ipairs(ed.scene_stack) do
    ed.scene_stack[idx] = nil
  end
  ed.scene_stack[1] = scene
end

local filter = {
  "player/player",
  "player/playerlimit",
  "player/playerinfo",
  "network_l_c",
  "genericnetwork/protoconfig",
  "genericnetwork/csprotodata",
  "genericnetwork/socketconnection",
  "genericnetwork/connectionmanager"
}

local function unloadResFiles()
  local loaded = package.loaded
  for _, lua_flie in ipairs(ed.needLoadFiles) do
    if not ed.isElementInTable(lua_flie, filter) then
      _G[lua_flie] = nil
      loaded[lua_flie] = nil
    end
  end
end

local function reloadResFiles()
  ed.loadAllFiles()
end

local function clearOldScene()
  local count = #ed.scene_stack
  for _ = 1, count - 1 do
    ed.popScene()
  end
end

local function dumpUserid()
  userid = ed.getUserid()
end

local function dumpCryptKey()
  cryptkey = ed.getCryptKey()
end

local function dumpSceneIdentity()
  for _, scene in ipairs(ed.scene_stack) do
    if scene.identity ~= nil then
      local idx = #sceneIdentity + 1
      sceneIdentity[idx] = scene.identity
    end
  end
end

local function clearTexture()
  CCTextureCache:sharedTextureCache():removeAllTextures()
  CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
end

local function resetData()
  userid = 0
  sceneIdentity = {}
end

function reload(isClearTexture)
  printGarbageLog("begin reload:")
  printSceneStack()
  resetData()
  if isClearTexture then
    clearTexture()
  end
  dumpUserid()
  dumpCryptKey()
  dumpSceneIdentity()
  clearOldScene()
  unloadResFiles()
  reloadResFiles()
  ed.setUserid(userid)
  ed.setCryptKey(cryptkey)
  reloadFirstScene()
  ed.loadEnd()
  printGarbageLog("end reload: ")
  printSceneStack()
end
