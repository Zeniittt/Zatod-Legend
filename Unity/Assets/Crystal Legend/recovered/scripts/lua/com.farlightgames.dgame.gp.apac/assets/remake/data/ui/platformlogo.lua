local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.platformlogo = class
local base = ed.ui.basescene
setmetatable(class, base.mt)

local function create()
  local self = {}
  setmetatable(self, class.mt)
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  local scene = CCDirector:sharedDirector():getRunningScene()
  scene:addChild(mainLayer)
  self:showFirstLogo()
end

class.create = create

local function getFadeAction(self, handler)
  handler = handler or function()
  end
  local fi = CCFadeIn:create(0.5)
  local d = CCDelayTime:create(1)
  local fo = CCFadeOut:create(0.5)
  local func = CCCallFunc:create(function()
    xpcall(handler, EDDebug)
  end)
  local s = CCSequence:create(ccArrayMake(fi, d, fo, func))
  return s
end

class.getFadeAction = getFadeAction

local function showFirstLogo(self)
  if self:getLogoRes() then
    self:showPlatformLogo()
  else
    self:getInGame()
  end
end

class.showFirstLogo = showFirstLogo

function class:showPlatformLogo()
  local logo = ed.createSprite(self:getLogoRes())
  logo:setPosition(ccp(400, 240))
  logo:registerScriptHandler(function(event)
    if "enter" == event then
      ListenTimer(Timer:Once(0.1), function()
        local fi = CCFadeIn:create(0.5)
        local d = CCDelayTime:create(1)
        local fo = CCFadeOut:create(0.5)
        local func = CCCallFunc:create(function()
          xpcall(function()
            self:getInGame()
          end, EDDebug)
        end)
        local s = CCSequence:create(ccArrayMake(fi, d, fo, func))
        logo:runAction(s)
      end)
    end
  end)
  self.mainLayer:addChild(logo)
  logo:setOpacity(0)
end

local function getInGame(self)
  if ed.checkFirstUncompress() == false then
    ed.replaceScene(ed.ui.firstuncompress.create())
  else
    ed.replaceScene(ed.ui.serverlogin.create())
  end
end

class.getInGame = getInGame

local function getLogoRes(self)
  local r2 = "installer/platform_logo.png"
  local r3 = "installer/platform_logo.jpg"
  if ed.isElementInTable(EDSDKType, {
    131,
    110,
    135,
    134,
    136,
    139,
    158
  }) then
    return r2
  end
  if ed.isElementInTable(EDSDKType, {
    112,
    157,
    159,
    133,
    109,
    143,
    124
  }) then
    return r3
  end
end

class.getLogoRes = getLogoRes
