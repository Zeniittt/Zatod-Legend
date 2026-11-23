module("ed.loading", package.seeall)
scene = {}
scene.__index = scene

function scene.create(callback)
  local object = {}
  setmetatable(object, scene)
  object.callback = callback
  object:initAppearecne()
  return object
end

function scene:initAppearecne()
  local scene = CCScene:create()
  self.scene = scene
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer)
  mainLayer:registerScriptHandler(self:baseHandler())
  local imgBg = CCSprite:create("installer/splash.jpg")
  imgBg:setPosition(ccp(400, 240))
  imgBg:setScale(0.7804878048780488)
  mainLayer:addChild(imgBg)
  local bg = CCSprite:create("installer/loading_label_bg.png")
  bg:setScaleY(0.6)
  bg:setPosition(ccp(400, 60))
  mainLayer:addChild(bg)
  self:initLabels()
  self:initWaitLabels()
end

function scene:initLabels()
  local config = {
    {
      text = T("\230\173\163\229\156\168\229\138\160\232\189\189\229\136\157\229\167\139\229\140\150\232\181\132\230\186\144\239\188\140\232\175\183\231\168\141\231\173\137"),
      fontsize = 18,
      pos = ccp(260, 50)
    }
  }
  for _, v in pairs(config) do
    local node = self:createLabel(v.text, v.fontsize, v.pos)
    self.mainLayer:addChild(node)
  end
end

function scene:initWaitLabels()
  local config = {
    text = "...",
    fontsize = 18,
    pos = ccp(500, 50)
  }
  local waitLabel = self:createLabel(config.text, config.fontsize, config.pos)
  local dots = {
    ".",
    "..",
    "..."
  }
  local dotIndex = 1
  waitLabel:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(function(...)
    dotIndex = 3 < dotIndex and 1 or dotIndex
    waitLabel:setString(dots[dotIndex])
    dotIndex = dotIndex + 1
  end), CCDelayTime:create(0.5))))
  self.mainLayer:addChild(waitLabel)
end

function scene:createLabel(text, fontsize, pos)
  local node = CCLabelTTF:create(text, ed.font, fontsize)
  node:setColor(ccc3(251, 255, 255))
  node:setPosition(pos)
  node:setAnchorPoint(ccp(0, 0))
  return node
end

function scene:baseHandler(...)
  local function handler(event)
    xpcall(function()
      if event == "enter" then
        self:onEnter()
      elseif event == "exit" then
        self:onExit()
      end
    end, EDDebug)
  end
  
  return handler
end

local FILES_LOAD_PER_FRAME = 50

function scene:loadFiles()
  local function innerLoading(dt)
    xpcall(function()
      if not self._allFilesLoaded then
        self._loadIndex = self._loadIndex or 1
        
        for i = 1, FILES_LOAD_PER_FRAME do
          if self._loadIndex > #ed.needLoadFiles then
            self._allFilesLoaded = true
            break
          end
          require(ed.needLoadFiles[self._loadIndex])
          self._loadIndex = self._loadIndex + 1
        end
      else
        if self.loadId then
          CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.loadId)
          self.loadId = nil
        end
        ed.runmain()
      end
    end, EDDebug)
  end
  
  return innerLoading
end

function scene:onEnter(...)
  self.loadId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self:loadFiles(), 0, false)
end

function scene:onExit(...)
  if self.loadId then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.loadId)
    self.loadId = nil
  end
end

function scene:ccScene()
  return self.scene
end
