local ed = ed
ed.ui = ed.ui or {}
ed.ui.announce = {}
local announce = ed.ui.announce
local param_notshade = false
local param_notshade_default = false
local param_container, param_container_default
local param_priority_default = -300
local param_priority = param_priority_default
local param_zorder_default = 300
local param_zorder = param_zorder_default
local fbHid
local class = {
  mt = {}
}
class.mt.__index = class
announce.base = class
class.config = {}
class.windowCache = {}

local function refreshWindowCache()
  for i, v in ipairs(class.windowCache) do
    if tolua.isnull(v.mainLayer) then
      table.remove(class.windowCache, i)
      refreshWindowCache()
      break
    end
  end
end

class.refreshWindowCache = refreshWindowCache

local function stopRefreshCliprect(self, scheduler, id)
  scheduler = scheduler or self.mainLayer:getScheduler()
  id = id or self.refreshCliprectid
  if scheduler and id then
    scheduler:unscheduleScriptEntry(id)
  end
  self.refreshCliprectid = nil
  if not tolua.isnull((self.draglist or {}).layer) then
    self.draglist:refreshClipRect(self.container:getScale())
  end
end

class.stopRefreshCliprect = stopRefreshCliprect

local function beginRefreshCliprect(self)
  self:stopRefreshCliprect()
  self.refreshCliprectid = self.mainLayer:getScheduler():scheduleScriptFunc(self:refreshCliprect(), 0, false)
end

class.beginRefreshCliprect = beginRefreshCliprect

local function refreshCliprect(self)
  local scheduler = self.mainLayer:getScheduler()
  local id
  
  local function handler()
    xpcall(function()
      if not id then
        id = self.refreshCliprectid
      end
      if tolua.isnull(self.mainLayer) then
        self:stopRefreshCliprect(scheduler, id)
        return
      end
      self.draglist:refreshClipRect(self.container:getScale())
    end, EDDebug)
  end
  
  return handler
end

class.refreshCliprect = refreshCliprect

local function create(type, withNoShade)
  local self = {}
  setmetatable(self, class.mt)
  refreshWindowCache()
  self.announceType = type
  local announce_config = class.config[type] or {}
  local mainLayer
  withNoShade = withNoShade or param_notshade
  if withNoShade then
    mainLayer = CCLayer:create()
  else
    mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  end
  self.mainLayer = mainLayer
  local container = CCLayer:create()
  self.container = container
  container:setAnchorPoint(ccp(0.5, 0.5))
  container:setPosition(ccp(ed.display.halfFixedWidth, ed.display.halfFixedHeight))
  mainLayer:addChild(container)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, param_priority, true)
  local scene = param_container or CCDirector:sharedDirector():getRunningScene()
  scene:addChild(mainLayer, param_zorder)
  return self
end

class.create = create

local function registerTouchHandler(self, handler, key)
  self.touchHandlerList = self.touchHandlerList or {}
  if not key then
    table.insert(self.touchHandlerList, handler)
  else
    self.touchHandlerList[key] = handler
  end
end

class.registerTouchHandler = registerTouchHandler

local function removeTouchHandler(self, key)
  self.touchHandlerList = self.touchHandlerList or {}
  self.touchHandlerList[key] = nil
end

class.removeTouchHandler = removeTouchHandler

local function doMainLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.touchHandlerList or {}) do
        v(event, x, y)
      end
      if event == "ended" and not self.notClickDestroy then
        self:destroy()
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function cancelTouchLayer(self)
  self.mainLayer:setTouchEnabled(false)
end

class.cancelTouchLayer = cancelTouchLayer

local function useTouchLayer(self)
  self.mainLayer:setTouchEnabled(true)
end

class.useTouchLayer = useTouchLayer

local function setClickDestroyEnabled(self, b)
  self.notClickDestroy = not b
end

class.setClickDestroyEnabled = setClickDestroyEnabled

local function show(self, handler)
  local container = self.container
  container:setScale(0)
  if self.preShowHandler then
    self.preShowHandler()
  end
  if self.hasCliprect then
    self:beginRefreshCliprect()
  end
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if handler then
        handler()
      end
      if self.hasCliprect then
        self:stopRefreshCliprect()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  container:runAction(s)
  if self.announceType == "getProp" and self.identity == "task" then
    self.lsr:report("createPopWindow")
  else
    ed.playEffect(ed.sound.announce.createannounce)
  end
end

class.show = show

local function setDestroyHandler(self, handler)
  self.destroyHandler = handler
end

class.setDestroyHandler = setDestroyHandler

local function destroy(self, skipAnim)
  local container = self.container
  local handler = self.destroyHandler
  if self.preDestroyHandler then
    self.preDestroyHandler()
  end
  
  local function dealHandler()
    if handler then
      handler()
    end
    self.mainLayer:removeFromParentAndCleanup(true)
  end
  
  if not skipAnim then
    if self.hasCliprect then
      self:beginRefreshCliprect()
    end
    local s = CCEaseBackIn:create(CCScaleTo:create(0.2, 0))
    local f = CCCallFunc:create(function()
      xpcall(function()
        if self.hasCliprect then
          self:stopRefreshCliprect()
        end
        dealHandler()
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    container:runAction(s)
  else
    dealHandler()
  end
  if self.announceType == "getProp" and self.identity == "task" then
    self.lsr:report("closePopWindow")
  else
    ed.playEffect(ed.sound.announce.destroyannounce)
  end
  if self.shareScope then
    EDLog("announce Destroy Close ShareScope")
    CloseScope(self.shareScope)
  end
end

class.destroy = destroy

local function doCloseTouch(self)
  local isPress
  local button = self.ui.close
  local press = self.ui.close_press
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doCloseTouch = doCloseTouch

function class:getRequestPermissionsDesc()
  return T("\231\148\177\228\186\142\229\136\134\228\186\171\229\155\190\231\137\135\233\156\128\232\166\129\232\142\183\229\143\150\229\173\152\229\130\168\230\157\131\233\153\144\239\188\140\232\175\183\229\156\168\230\142\165\228\184\139\230\157\165\229\188\185\229\135\186\231\154\132\229\175\185\232\175\157\230\161\134\228\184\173\233\128\137\230\139\169\229\144\140\230\132\143\239\188\155\229\166\130\228\184\141\229\144\140\230\132\143\229\176\134\230\151\160\230\179\149\230\173\163\229\184\184\232\191\155\232\161\140\229\136\134\228\186\171\230\147\141\228\189\156")
end

function class:ShareToSocialWithQRAndHeadAsync(param)
  self.shareParam = param
  self.shareScope = self.shareScope or {}
  CloseScope(self.shareScope)
  local ShouldRequestPermissions = EDGetParam("ShouldRequestPermissions")
  EDLog("ShouldRequestPermissions=" .. tostring(ShouldRequestPermissions))
  if ShouldRequestPermissions == "true" then
    local desc = self:getRequestPermissionsDesc()
    ListenEvent("SetJavaToLua", function(key, value)
      self:OnSetJavaToLua(key, value)
    end, self.shareScope)
    EDAndroidExtra("ShowRequestPermissionsConfirmDialog", desc)
  else
    ed.ShareToSocialWithQRAndHead(param)
  end
end

function class:OnSetJavaToLua(key, value)
  EDLog(string.format("PetSharePanel:OnSetJavaToLua key=%s value=%s", key, value))
  if key == "RequestPermissionsResult" then
    EDLog("OnSetJavaToLua Timer")
    ListenTimer(Timer:Once(2), function()
      ed.ShareToSocialWithQRAndHead(self.shareParam)
    end, self.shareScope)
  end
end

local function ShareToSocialWithQRAndHead(param)
  local Res = param.Res
  local ui = param.ui
  local container = param.container
  local shareHeroAwakenSize = {width = 1024, height = 616}
  local shareHeroAwakenNode = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/share/background.jpg"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(shareHeroAwakenSize.width * 0.5, shareHeroAwakenSize.height * 0.5)
    }
  }, nil)
  local titlenode = ed.createNode({
    t = "Sprite",
    base = {res = Res},
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 400)
    }
  }, shareHeroAwakenNode)
  titlenode:setScale(1.4)
  local playerName = ed.player:getName()
  if playerName == "" then
    playerName = T("\229\144\141\229\173\151\229\164\170\229\184\133\230\151\160\230\179\149\230\152\190\231\164\186")
  end
  local headParam = {
    id = ed.player:getAvatar(),
    vip = ed.player:getvip(),
    name = playerName,
    level = ed.player:getLevel(),
    babelLevel = ed.player:getBabelLevel(),
    uid = ed.player:getPlayerUID(),
    rendertex = true
  }
  local headNode, headui = ed.createMainFrameHead(headParam)
  headNode:setAnchorPoint(ccp(0.5, 0.5))
  headNode:setPosition(ccp(80, 70))
  headui.name_bg:setVisible(false)
  headui.vip_bg:setVisible(false)
  headui.vip_icon:setVisible(false)
  headui.level:setVisible(false)
  headui.head_bg:setVisible(false)
  headNode:setScale(1.3)
  shareHeroAwakenNode:addChild(headNode)
  local head_info = {
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/HVGA/nightmare/nightmare_nextwave_bg.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(65, 38)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "nikename",
        text = tostring(playerName),
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(60, 40)
      },
      config = {}
    }
  }
  local head_ui = {}
  local readNode = ed.readnode.create(shareHeroAwakenNode, head_ui)
  readNode:addNode(head_info)
  head_ui.name_bg:setScaleX(0.8)
  head_ui.name_bg:setPosition(ccp(100, 30))
  head_ui.nikename:setPosition(ccp(100, 30))
  local filename = ""
  if EDFLAGANDROID then
    filename = EDGetExternalStoragePath() .. "/share_capture.png"
  elseif EDFLAGIOS then
    filename = CCFileUtils:sharedFileUtils():getWritablePath() .. "/share_capture.png"
  else
    filename = CCFileUtils:sharedFileUtils():getWritablePath() .. "/share_capture.png"
  end
  local scaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
  CCDirector:sharedDirector():setContentScaleFactor(1)
  local px, py = container:getPosition()
  container:setPosition(ccp(120, 85))
  ui.ok:setVisible(false)
  ui.socialShare:setVisible(false)
  ui.title:setVisible(false)
  ui.name_bg:setVisible(false)
  ui.light:setVisible(false)
  local y = ui.name:getPositionY()
  ui.name:setPositionY(y + 10)
  local scale = container:getScale()
  container:setScale(1.4)
  shareHeroAwakenNode:setScale(1.3)
  local re = ed.RenderTextureCreate(800, 480)
  re.rt:beginWithClear(0, 0, 0, 0)
  local actor = param.actor
  if actor.changeFcaBlendfunc then
    local blendFunc1 = ccBlendFunc()
    blendFunc1.src = GL_ONE
    blendFunc1.dst = GL_ONE_MINUS_SRC_ALPHA
    actor:changeFcaBlendfunc(blendFunc1)
  end
  ed.changeSpriteBlend(ui.name)
  shareHeroAwakenNode:visit()
  container:visit()
  re:endToLua()
  re.rt:saveToFile(filename)
  re.rt:release()
  container:setPosition(ccp(px, py))
  container:setScale(scale)
  ui.name:setPositionY(y)
  ui.ok:setVisible(true)
  ui.socialShare:setVisible(true)
  ui.title:setVisible(true)
  ui.name_bg:setVisible(true)
  ui.light:setVisible(true)
  CCDirector:sharedDirector():setContentScaleFactor(scaleFactor)
  local QR = {width = 128, height = 128}
  if EDShareToFriendsPoolQR then
    EDShareToFriendsPoolQR("", "", filename, shareHeroAwakenSize.width - QR.width * 1.2, shareHeroAwakenSize.height - QR.height * 1.3, QR.width, QR.height)
  end
end

ed.ShareToSocialWithQRAndHead = ShareToSocialWithQRAndHead
local class = {
  mt = {}
}
class.mt.__index = class
local base = announce.base
setmetatable(class, base.mt)
announce.announcement = class

local function create(param)
  param_notshade = true
  local self = base.create("announcement")
  setmetatable(self, class.mt)
  self:cancelTouchLayer()
  return self
end

class.create = create

function ed.announce(info)
  xpcall(function()
    local type = info.type
    local param = info.param or {}
    param_notshade = info.notshade or param_notshade_default
    param_container = info.container or param_container_default
    param_priority = (info.priority or 0) + param_priority_default
    param_zorder = info.z or param_zorder_default
    if not type then
      return
    end
    table.insert(class.windowCache, announce[type].create(param))
  end, EDDebug)
end
