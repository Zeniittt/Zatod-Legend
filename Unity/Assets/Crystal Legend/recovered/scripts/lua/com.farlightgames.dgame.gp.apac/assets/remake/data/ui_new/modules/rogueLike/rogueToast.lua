local class = newclass("g")
ed.rogueToast = class
ed.rogueToast.instance = nil

function class.getInstance()
  if not ed.rogueToast.instance then
    ed.rogueToast.instance = ed.rogueToast.create()
  end
  return ed.rogueToast.instance
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self.actionTipsRunning = false
  self.showRogueTipsIndex = 1
  self.showRogueTipsList = {}
  local topNode = ed.ui.basescene.getTopNode()
  self.rootPanel = CCLayerColor:create(ccc4(0, 0, 0, 0))
  topNode:addChild(self.rootPanel)
end

function class:getRogueResultTipsCfg(rogueResult)
  local rogueType = rogueResult._type
  local tipsCfg = ed.rogueDefine.ROGUE_RESULT_TO_TIPS[rogueType]
  if tipsCfg then
    tipsCfg = ed.copyTable(tipsCfg)
    tipsCfg.rogueResult = rogueResult
  end
  return tipsCfg
end

function class:checkAddRogueResultTips(rogueResult)
  local tipsCfg = self:getRogueResultTipsCfg(rogueResult)
  if not tipsCfg then
    return
  end
  table.insert(self.showRogueTipsList, tipsCfg)
  ListenTimer(Timer:Once(0.01), function(...)
    self:showRogueResultTips()
  end)
end

function class:showRogueResultTips()
  if self.actionTipsRunning then
    return
  end
  local tipsCfg = self.showRogueTipsList[self.showRogueTipsIndex]
  if not tipsCfg then
    return
  end
  local tips = self:createRogueResultTips(tipsCfg)
  self.rootPanel:addChild(tips, 99999)
  tips:setPosition(ccp(ed.display.fixDesignSize.width * 0.5, ed.display.fixDesignSize.height * 0.5 + 20))
  tips:setOpacity(0)
  local fadeIn = CCFadeIn:create(0.5)
  local move = CCMoveBy:create(0.5, ccp(0, 30))
  local delay = CCDelayTime:create(1)
  local fadeOut = CCFadeOut:create(0.5)
  local callFunc = CCCallFunc:create(function()
    self.showRogueTipsIndex = self.showRogueTipsIndex + 1
    self.actionTipsRunning = false
    self:showRogueResultTips()
    tips:removeFromParentAndCleanup(true)
  end)
  local finaAction = CCSequence:create(ccArrayMake(CCSpawn:create(ccArrayMake(fadeIn, move)), delay, fadeOut, callFunc))
  self.actionTipsRunning = true
  tips:runAction(finaAction)
end

function class:createRogueResultTips(tipsCfg)
  local cfg = tipsCfg
  local resultType = cfg.type
  local rogueResult = cfg.rogueResult
  local bgPath, labelColor, strokeColor
  if resultType == "good" then
    bgPath = "UI/alpha/1080P/rogue/instance/event/result_good.png"
    labelColor = ccc3(255, 245, 190)
    strokeColor = ed.toccc3(11090468)
  elseif resultType == "bad" then
    bgPath = "UI/alpha/1080P/rogue/instance/event/result_bad.png"
    labelColor = ed.toccc3(16753057)
    strokeColor = ed.toccc3(8134688)
  end
  local bg = ed.createSprite(bgPath)
  local tips = ""
  if type(cfg.tips) == "string" then
    tips = cfg.tips
  elseif type(cfg.tips) == "function" then
    tips = cfg.tips(rogueResult, cfg)
  end
  local labelTips = ed.createttf(tips, 27)
  ed.setLabelColor(labelTips, labelColor)
  ed.setLabelStroke(labelTips, strokeColor, 1)
  labelTips:setPosition(ccp(477, 164.75))
  bg:addChild(labelTips)
  bg:setCascadeOpacityEnabled(true)
  return bg
end
