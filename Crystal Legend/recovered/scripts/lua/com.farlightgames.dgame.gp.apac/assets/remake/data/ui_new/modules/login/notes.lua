local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.notes = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
local FILES_LOAD_PER_FRAME = 3
local pageOneNodes = {}
local pageTwoNodes = {}

function class:onEnter()
  self:replaceScene()
end

function class.create()
  local self = base.create("notes")
  setmetatable(self, class.mt)
  self:registerOnEnterHandler("onEnterFramework", function()
    self:onEnter()
  end)
  return self
end

function class:createLabel(text, fontsize, pos)
  local node = CCLabelTTF:create(text, ed.font, fontsize)
  node:setColor(ccc3(65, 57, 54))
  node:setPosition(pos)
  return node
end

function class:createLabels()
  local config = {
    {
      text = T("\229\129\165\229\186\183\230\184\184\230\136\143\229\191\160\229\145\138"),
      fontsize = 24,
      pos = ccp(400, 330)
    },
    {
      text = T("\230\138\181\229\136\182\228\184\141\232\137\175\230\184\184\230\136\143\239\188\140\230\139\146\231\187\157\231\155\151\231\137\136\230\184\184\230\136\143\227\128\130"),
      fontsize = 20,
      pos = ccp(400, 280)
    },
    {
      text = T("\230\179\168\230\132\143\232\135\170\230\136\145\228\191\157\230\138\164\239\188\140\232\176\168\233\152\178\229\143\151\233\170\151\228\184\138\229\189\147\227\128\130"),
      fontsize = 20,
      pos = ccp(400, 240)
    },
    {
      text = T("\233\128\130\229\186\166\230\184\184\230\136\143\231\155\138\232\132\145\239\188\140\230\178\137\232\191\183\230\184\184\230\136\143\228\188\164\232\186\171\227\128\130"),
      fontsize = 20,
      pos = ccp(400, 200)
    },
    {
      text = T("\229\144\136\231\144\134\229\174\137\230\142\146\230\151\182\233\151\180\239\188\140\228\186\171\229\143\151\229\129\165\229\186\183\231\148\159\230\180\187\227\128\130"),
      fontsize = 20,
      pos = ccp(400, 160)
    }
  }
  for _, v in pairs(config) do
    local node = self:createLabel(v.text, v.fontsize, v.pos)
    node:setVisible(false)
    self.mainLayer:addChild(node)
    table.insert(pageOneNodes, node)
  end
  local config = {
    {
      text = T("\232\145\151\228\189\156\230\157\131\231\153\187\232\174\176\229\143\183\239\188\1542014SR006508"),
      fontsize = 20,
      pos = ccp(400, 320)
    },
    {
      text = T("\230\184\184\230\136\143\232\145\151\228\189\156\230\157\131\228\186\186\239\188\154\228\184\138\230\181\183\232\142\137\232\142\137\228\184\157\231\167\145\230\138\128\232\130\161\228\187\189\230\156\137\233\153\144\229\133\172\229\143\184"),
      fontsize = 20,
      pos = ccp(400, 290)
    },
    {
      text = T("\229\135\186\231\137\136\230\156\141\229\138\161\229\141\149\228\189\141\239\188\154\228\184\138\230\181\183\228\184\173\230\184\133\233\190\153\229\155\190\231\189\145\231\187\156\231\167\145\230\138\128\230\156\137\233\153\144\229\133\172\229\143\184"),
      fontsize = 20,
      pos = ccp(400, 260)
    },
    {
      text = T("\230\137\185\229\135\134\230\150\135\229\143\183\239\188\154\230\150\176\229\135\186\229\185\191\229\174\161\239\188\1362016\239\188\1371086\229\143\183"),
      fontsize = 20,
      pos = ccp(400, 230)
    },
    {
      text = T("\229\135\186\231\137\136\231\137\169\229\143\183\239\188\154ISBN 978-7-89988-909-1"),
      fontsize = 20,
      pos = ccp(400, 200)
    }
  }
  for _, v in pairs(config) do
    local node = self:createLabel(v.text, v.fontsize, v.pos)
    node:setVisible(false)
    self.mainLayer:addChild(node)
    table.insert(pageTwoNodes, node)
  end
end

function class:showText(array, bShow)
  for _, v in pairs(array) do
    if not tolua.isnull(v) then
      v:setVisible(bShow)
    end
  end
end

function class:delayHideText(array, time)
  time = time or 2.8
  self:showText(array, true)
  ListenTimer(Timer:Once(time), function()
    self:showText(array, false)
  end)
end

function class:getFadeAction(handler)
  handler = handler or function()
  end
  local array = CCArray:create()
  local fi = CCFadeIn:create(0.5)
  local d = CCDelayTime:create(2)
  local fo = CCFadeOut:create(0.5)
  local func = CCCallFunc:create(function()
    xpcall(handler, EDDebug)
  end)
  local action = {
    fi,
    d,
    fo,
    func
  }
  for i = 1, #action do
    array:addObject(action[i])
  end
  local s = CCSequence:create(array)
  return s
end

function class:showPageOne()
  self:delayHideText(pageOneNodes)
  self.mainLayer:setOpacity(0)
  self.mainLayer:runAction(self:getFadeAction(function()
    self:showPageTwo()
  end))
end

function class:showPageTwo()
  self:delayHideText(pageTwoNodes)
  self:showText(pageTwoNodes, true)
  self.mainLayer:setOpacity(0)
  self.mainLayer:runAction(self:getFadeAction(function()
    if not ed.overrideSdk then
      self:replaceScene()
    end
  end))
end

local function replaceWithMod(self, key)
  local mode = {
    replace = ed.replaceScene,
    push = ed.pushScene
  }
  EDLuaReset = EDLuaReset or 0
  local nativeDebug = EDFLAGWIN32 and EDFLAGWIN32 or EDNativeDebug
  if not nativeDebug then
    if EDFLAGANDROID and EDLuaReset == 0 then
      require("ui/platformlogo")
      ed.ui.platformlogo.create()
    else
      EDLog("============Notes WE CLEAN THE SPRITE ALL==================")
      EDFcaInfo:removeUnusedInfo()
      CCTextureCache:sharedTextureCache():removeAllTextures()
      CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames()
      mode[key](ed.ui.serverlogin.create())
    end
  else
    mode[key](ed.ui.debuglogin.create())
  end
end

class.replaceWithMod = replaceWithMod

local function replaceScene(self, func)
  self:replaceWithMod("replace")
end

class.replaceScene = replaceScene

local function pushNextScene(self)
  self:replaceWithMod("push")
end

class.pushNextScene = pushNextScene

function class:loadAllFiles()
  for i, v in ipairs(ed.needLoadFiles) do
    require(v)
  end
end

function class:loadFiles()
  self._loadIndex = self._loadIndex or 1
  for i = 1, FILES_LOAD_PER_FRAME do
    if self._loadIndex > #ed.needLoadFiles then
      self._allFilesLoaded = true
      break
    end
    require(ed.needLoadFiles[self._loadIndex])
    self._loadIndex = self._loadIndex + 1
  end
  if self._allFilesLoaded then
    self:replaceScene()
  end
end

local waringLogic = {}
ed.dataWaring = waringLogic
local waringPanel, isCreate
local savekey = "datawaring"
local currentFuncHandler
local UIRes = {
  {
    layerName = "errornetLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 0),
    touchInfo = {
      iPriority = -2000,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "errorBg",
          res = "UI/alpha/1080P/common/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 260)
        },
        config = {
          scaleSize = CCSizeMake(310, 200)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T("\230\173\163\229\156\168\228\189\191\231\148\168\231\189\145\231\187\156\232\191\158\230\142\165"),
          fontinfo = "normalButton",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 180)
        },
        listData = true
      },
      {
        t = "Sprite",
        base = {
          name = "uiline",
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 145)
        },
        config = {scale = 0.8}
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T("\228\189\191\231\148\168\231\167\187\229\138\168\231\189\145\231\187\156\231\153\187\229\189\149/\231\142\169\230\156\172\230\184\184\230\136\143\229\176\134\228\188\154\228\186\167\231\148\159\230\181\129\233\135\143\232\180\185\231\148\168"),
          fontinfo = "normalButton",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 130)
        },
        config = {
          horizontalAlignment = kCCTextAlignmentLeft,
          dimensions = CCSizeMake(260, 0)
        },
        listData = true
      },
      {
        t = "Scale9Button",
        base = {
          name = "notWaring",
          parent = "errorBg",
          buttonName = {
            text = T("\228\184\141\229\134\141\230\143\144\231\164\186"),
            fontInfo = "title_yellow"
          },
          res = {
            normal = "UI/alpha/1080P/common/tavern_button_normal_1.png",
            press = "UI/alpha/1080P/common/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "notWaringAgain"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(90, 45)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "tryAgain",
          parent = "errorBg",
          buttonName = {
            text = T("\228\184\139\230\172\161\230\143\144\231\164\186"),
            fontInfo = "title_yellow"
          },
          res = {
            normal = "UI/alpha/1080P/common/tavern_button_normal_1.png",
            press = "UI/alpha/1080P/common/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "waringNext"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(220, 45)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      }
    }
  }
}

function waringLogic.create(currentFunc)
  EDLog("===============  waring logic create ")
  if nil == currentFunc then
    return
  end
  currentFuncHandler = currentFunc
  waringPanel = panelMeta:new2(waringLogic, UIRes)
  if not isCreate then
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(waringPanel:getRootLayer(), 5000)
    end
    isCreate = true
  end
end

function waringLogic.exit()
  if waringPanel == nil then
    return
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:removeChild(waringPanel:getRootLayer(), true)
    waringPanel = nil
  end
  isCreate = nil
end

function waringLogic.enterGame()
  currentFuncHandler()
  waringLogic.exit()
end

function waringLogic.waringNext()
  waringLogic.enterGame()
end

function waringLogic.notWaringAgain()
  ed.storage.setValue(savekey, "yes")
  waringLogic.enterGame()
end

function waringLogic:isWaring()
  EDLog("===============  waring logic iswaring ")
  return ed.storage.getString(savekey) ~= "yes"
end
