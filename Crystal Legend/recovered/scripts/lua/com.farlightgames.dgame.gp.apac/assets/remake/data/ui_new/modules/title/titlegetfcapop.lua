local base = ed.ui.popwindow
local TitleGetFcaPop = newclass(base.mt)
ed.ui.titlegetfcapop = TitleGetFcaPop

function TitleGetFcaPop:onDestroy()
  local m = CCMoveTo:create(0.2, ccp(-360, 190))
  m = CCEaseSineOut:create(m)
  local s = CCScaleTo:create(0.5, 0.2)
  s = CCEaseBackOut:create(s)
  s = CCSpawn:createWithTwoActions(m, s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      ed.TitleMgr.getInstance():setNewMedalId(nil)
      self.mainLayer:removeFromParentAndCleanup(true)
      if self.callback then
        self.callback()
      end
    end, EDDebug)
  end)
  local as = {
    t = "seq",
    s,
    func
  }
  if not tolua.isnull(self.titleContainer) then
    self.titleContainer:runAction(ed.readaction.create(as))
  end
end

function TitleGetFcaPop.pop(param)
  local window = TitleGetFcaPop.create(param)
  local scene = window:ccScene()
  scene:addChild(window.mainLayer, 499)
end

function TitleGetFcaPop.create(param)
  param = param or {}
  local self = base.create("titlegetfcapop")
  setmetatable(self, TitleGetFcaPop.mt)
  self.titleId = ed.TitleMgr.getInstance():getNewMedalId()
  self.callback = param.callback
  self:show()
  self:registerTouchHandler()
  return self
end

function TitleGetFcaPop:show()
  self.container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self:initGetTitleUI()
      self:playGetTitleAnim()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  self.container:runAction(s)
end

function TitleGetFcaPop:initGetTitleUI()
  local title = ed.TitleMgr.getInstance():getOneTitleById(self.titleId)
  local titleContainer = CCLayer:create()
  self.titleContainer = titleContainer
  self.container:addChild(titleContainer, 20)
  local titleTop = ed.createLabelWithFontInfo(T("\228\189\160\232\142\183\229\190\151\228\186\134\228\184\128\228\184\170\230\150\176\229\190\189\231\171\160"), "title_yellow")
  titleContainer:addChild(titleTop)
  titleTop:setPosition(ccp(400, 300))
  local nameLabel = ed.createLabelTTF(title.name, 18)
  titleContainer:addChild(nameLabel)
  nameLabel:setPosition(ccp(400, 190))
  local titleImage = ed.createSprite(title.image)
  titleContainer:addChild(titleImage)
  titleImage:setPosition(ccp(400, 240))
  self.titleImage = titleImage
end

function TitleGetFcaPop:playGetTitleAnim()
  self.titleImage:setScale(12)
  local s = CCScaleTo:create(0.2, 1.2)
  s = CCEaseBackOut:create(s)
  self.titleImage:runAction(s)
  local delay = CCDelayTime:create(0.1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      local box = ed.createFcaNode("eff_UI_medal_get")
      self.titleContainer:addChild(box)
      self:addFca(box)
      box:setPosition(ccp(400, 240))
      box:setScale(2.5)
      self.box = box
    end, EDDebug)
  end)
  local as = {
    t = "seq",
    delay,
    func
  }
  self.titleContainer:runAction(ed.readaction.create(as))
end

function TitleGetFcaPop:registerTouchHandler()
  local touchNode = ed.ui.basetouchnode.btCreate()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -200, true)
  touchNode:btRegisterHandler({
    key = "bgt",
    handler = function(event, x, y)
      if event == "began" then
      elseif event == "ended" then
        self:onDestroy()
      end
    end,
    force = true
  })
end
