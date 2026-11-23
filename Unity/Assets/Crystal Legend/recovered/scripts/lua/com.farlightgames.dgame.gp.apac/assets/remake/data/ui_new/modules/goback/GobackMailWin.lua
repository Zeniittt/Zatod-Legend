local base = ed.ui.popwindow
local GobackMailWin = newclass(base.mt)
ed.ui.GobackMailWin = GobackMailWin
local multiAreaFcaPosConfig = {
  en = {
    NamePos = ccp(140, 194),
    DatePos = ccp(0, -10),
    TimePos = ccp(270, 162),
    letterOffset = ccp(0, 20)
  },
  tw = {
    NamePos = ccp(140, 194),
    DatePos = ccp(0, -10),
    TimePos = ccp(317, 162),
    letterOffset = ccp(0, 20)
  },
  ja = {
    NamePos = ccp(210, 194),
    DatePos = ccp(20, -20),
    TimePos = ccp(323, 162),
    letterOffset = ccp(0, 25)
  },
  ko = {
    NamePos = ccp(110, 194),
    DatePos = ccp(0, -10),
    TimePos = ccp(372, 162),
    letterOffset = ccp(0, 25)
  }
}

function GobackMailWin:initData(actOpen)
  self.actOpen = actOpen
  self.leftDays = ed.GobackManager.leftDays
  if self.actOpen then
    FireEvent("GobackMailFirstOpen")
  end
end

function GobackMailWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.layer_outclick,
    clickHandler = function()
      self:onClose()
    end,
    priority = -1
  })
  self:btRegisterRectClick({
    rect = CCRectMake(0, 0, 143, 134),
    parent = self.ui.btn_reward,
    key = "btn_reward",
    clickHandler = function()
      if not ed.GobackManager.onceFlag then
        ed.GobackNetwork:sendGobackConfirm()
      end
    end,
    force = true
  })
end

function GobackMailWin:onClose()
  if self.actOpen then
    self:createMoveToPosAction()
  else
    self:destroy()
  end
end

function GobackMailWin:createMoveToPosAction()
  local node, pos
  for k, button in ipairs(ed.getCurrentScene().rightTopButtons or {}) do
    if button.config.type == ed.ui.configs.mainButton.ButtonType.GOBACK then
      node = button.node
      pos = ed.getWorldPos(button.node)
    end
  end
  if node and pos then
    local moveTo = CCMoveTo:create(0.4, ccp(pos.x - ed.display.winSize.width / 2, pos.y - ed.display.winSize.height / 2))
    local fadeOut = CCFadeOut:create(0.4)
    local scaleTo = CCScaleTo:create(0.4, 0.1)
    local action = CCSpawn:create(ccArrayMake(moveTo, fadeOut, scaleTo))
    local callfunc = CCCallFunc:create(function()
      self:destroy({skipAnim = true})
    end)
    self.container:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.1), action, callfunc)))
  else
    self:destroy()
    return
  end
end

function GobackMailWin:registerEvents()
  self:listenEvent("GobackOnceRewardGot", function(data)
    ed.UITool.showRewardsFromServer(data._rewards, "\229\155\158\229\189\146\229\165\150\229\138\177", function()
      self:onClose()
    end)
  end)
end

local function setFcaFadeIn(fca)
  local actionManager = CCDirector:sharedDirector():getActionManager()
  fca:setCascadeOpacityEnabled(true)
  fca:setOpacity(0)
  actionManager:addAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.167), CCFadeTo:create(0.25, 255)), fca, false)
end

function GobackMailWin:createMainFca()
  if ed.isAreaZhCn() then
    local name = ed.createttf(ed.player:getName(), 15)
    name:setColor(ccc3(99, 141, 243))
    local name1 = CCLayer:create()
    name:setPosition(ccp(1.5, 2))
    name1:addChild(name)
    local day = ed.createttf(self.leftDays, 19)
    day:setColor(ccc3(248, 80, 95))
    local day1 = CCLayer:create()
    day:setPosition(ccp(2.8, 2))
    day1:addChild(day)
    local riqi = ed.createttf(ed.getYMDHMSTime(ed.time2Server(ed.GobackManager.startTime), "goback"), 16)
    riqi:setColor(ed.toccc3(16273503))
    local riqi1 = CCLayer:create()
    riqi1:addChild(riqi)
    if self.actOpen then
      local fca1 = ed.createFcaNode("eff_UI_Main_Goback")
      self.container:addChild(fca1, 1)
      fca1:setPosition(ccp(480, 270))
      self:addFca(fca1)
      fca1:addNodeToComponent(name1, "mingzi", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(day1, "tianshu", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(riqi1, "riqi", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      local fca2 = ed.createFcaNode("eff_UI_Main_Goback_up")
      self.container:addChild(fca2, 2)
      fca2:setPosition(ccp(480, 270))
      self:addFca(fca2)
    else
      local fca1 = ed.createFcaNode("eff_UI_Main_Goback")
      self.container:addChild(fca1, 1)
      fca1:setPosition(ccp(480, 270))
      self:addFca(fca1)
      if ed.GobackManager.onceFlag then
        fca1:setStartAction("Loop2")
        fca1:setLoopAction("Loop2")
      else
        fca1:setStartAction("Loop")
      end
      fca1:addNodeToComponent(name1, "mingzi", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(day1, "tianshu", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(riqi1, "riqi", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    end
  else
    local config = multiAreaFcaPosConfig[ed.getCurArea()]
    local riqi = ed.createttf(ed.getYMDHMSTime(ed.time2Server(ed.GobackManager.startTime), "goback"), 16)
    riqi:setColor(ed.toccc3(16273503))
    riqi:setPosition(config.DatePos)
    local riqi1 = CCSprite:create()
    riqi1:addChild(riqi)
    local title = ed.createSprite("UI/alpha/1080P/goback/goback_mail_welcomeback.png")
    local titleNode = CCSprite:create()
    titleNode:addChild(title)
    local name = ed.createttf(ed.player:getName(), 15)
    name:setAnchorPoint(ccp(0, 0.5))
    name:setColor(ccc3(99, 141, 243))
    name:setPosition(config.NamePos)
    local nameNode = CCSprite:create()
    nameNode:addChild(name)
    local day = ed.createttf(self.leftDays, 19)
    day:setColor(ccc3(248, 80, 95))
    day:setPosition(config.TimePos)
    local dayNode = CCSprite:create()
    dayNode:addChild(day)
    local letterContent = ed.createSprite("UI/alpha/1080P/goback/goback_mail_text.png")
    letterContent:addChild(nameNode)
    letterContent:addChild(dayNode)
    letterContent:setPosition(config.letterOffset)
    local letterNode = CCSprite:create()
    letterNode:addChild(letterContent)
    local reward_title = ed.createSprite("UI/alpha/1080P/goback/goback_mail_claim.png")
    local rewardNode = CCLayer:create()
    rewardNode:addChild(reward_title)
    if self.actOpen then
      setFcaFadeIn(riqi1)
      setFcaFadeIn(titleNode)
      setFcaFadeIn(nameNode)
      setFcaFadeIn(dayNode)
      setFcaFadeIn(letterNode)
      local fca1 = ed.createFcaNode("eff_UI_Main_Goback_globe")
      self.container:addChild(fca1, 1)
      fca1:setPosition(ccp(480, 270))
      self:addFca(fca1)
      fca1:addNodeToComponent(letterNode, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(riqi1, "Node4", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(rewardNode, "Node3", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(titleNode, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      local fca2 = ed.createFcaNode("eff_UI_Main_Goback_up_globe")
      self.container:addChild(fca2, 2)
      fca2:setPosition(ccp(480, 270))
      self:addFca(fca2)
    else
      local fca1 = ed.createFcaNode("eff_UI_Main_Goback_globe")
      self.container:addChild(fca1, 1)
      fca1:setPosition(ccp(480, 270))
      self:addFca(fca1)
      if ed.GobackManager.onceFlag then
        fca1:setStartAction("Loop2")
        fca1:setLoopAction("Loop2")
      else
        fca1:setStartAction("Loop")
      end
      fca1:addNodeToComponent(letterNode, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(riqi1, "Node4", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(rewardNode, "Node3", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca1:addNodeToComponent(titleNode, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    end
  end
end

function GobackMailWin:initUI()
  ed.editorui(ed.uieditor.GobackMailWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(16711156), 2)
  self:createMainFca()
end

function GobackMailWin.create(actOpen)
  local self = base.create("GobackMailWin")
  setmetatable(self, GobackMailWin.mt)
  self:initData(actOpen)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end
