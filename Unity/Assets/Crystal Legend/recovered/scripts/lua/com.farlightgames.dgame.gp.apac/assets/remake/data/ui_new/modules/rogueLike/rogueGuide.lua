local class = newclass("g")
ed.rogueGuide = class
ed.rogueGuide.instance = nil
class.GuideBoxPath = "UI/alpha/1080P/rogue/rogue_guide.png"
class.RogueGuildConfig = {
  rogueMainScene = {
    sceneId = "rogueMainScene",
    storyKey = "RogueBookChoose",
    fixSize = CCSizeMake(300, 350)
  },
  rogueDestinyChooseScene = {
    sceneId = "rogueDestinyChooseScene",
    storyKey = "RogueDestinyChoose",
    fixSize = CCSizeMake(750, 300)
  },
  rogueBattlePrepare = {
    sceneId = "rogueBattlePrepare",
    storyKey = "RogueTeamPrepare"
  },
  rogueMapScene = {
    sceneId = "rogueMapScene",
    storyKey = "RogueGameStart",
    fixSize = CCSizeMake(150, 150)
  },
  rogueBlessChooseScene = {
    sceneId = "rogueBlessChooseScene",
    storyKey = "RogueBlessChoose",
    offsetPos = ccp(0, 10)
  },
  rogueRevelationUnlockWindow = {
    sceneId = "rogueRevelationUnlockWindow",
    storyKey = "RogueDestinyActivate",
    offsetPos = ccp(0, 10)
  },
  rogueBattlePrepareFull = {
    sceneId = "rogueBattlePrepare",
    storyKey = "RogueDestinyPrepare"
  },
  rogueExchangePetWindow = {
    sceneId = "rogueMapScene",
    storyKey = "RogueEggFound"
  },
  closeRogueExchangePetWindow = {
    sceneId = "rogueMapScene",
    storyKey = "RogueGuideEnd"
  }
}

function class.getInstance()
  if not ed.rogueGuide.instance then
    ed.rogueGuide.instance = ed.rogueGuide.create()
  end
  return ed.rogueGuide.instance
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self:initData()
end

function class:getShowTimes(guildKey)
  local storageKey = ed.getRoleKey(guildKey)
  local showTimes = ed.storage.getInt(storageKey)
  return showTimes or 0
end

function class:setShowTimes(guildKey, times)
  local storageKey = ed.getRoleKey(guildKey)
  ed.storage.setValue(storageKey, times)
end

function class:initData()
  self.guideNodeData = {}
end

function class:registerGuide(guildKey, node)
  local guideCfg = self.RogueGuildConfig[guildKey]
  if not guideCfg then
    return
  end
  self.guideNodeData[guildKey] = node
end

function class:getGuideNode(guildKey)
  return self.guideNodeData[guildKey]
end

function class:startGuide(guildKey, node)
  if node then
    self:registerGuide(guildKey, node)
  end
  local guideCfg = self.RogueGuildConfig[guildKey]
  if not guideCfg then
    return
  end
  local currentScene = ed.getCurrentScene()
  if currentScene and currentScene.identity ~= guideCfg.sceneId then
    return
  end
  local showTimes = guideCfg.showTimes or 1
  local localShowTimes = self:getShowTimes(guildKey)
  if showTimes <= localShowTimes then
    return
  end
  self:createGuide(guildKey)
  self:setShowTimes(guildKey, localShowTimes + 1)
end

function class:endGuide(guildKey)
  local guideCfg = self.RogueGuildConfig[guildKey]
  if not guideCfg then
    return
  end
  local guideNode = self:getGuideNode(guildKey)
  if not guideNode or tolua.isnull(guideNode) then
    return
  end
  local guideBox = guideNode.guideBox
  if guideBox and not tolua.isnull(guideNode) then
    guideBox:setVisible(false)
  end
end

function class:createGuide(guildKey)
  local guideNode = self:getGuideNode(guildKey)
  local guideCfg = self.RogueGuildConfig[guildKey]
  local storyKey = guideCfg.storyKey
  if not guideNode or tolua.isnull(guideNode) then
    if guideCfg.storyKey then
      ed.showStory(guideCfg.storyKey)
    end
    return
  end
  local nodeSize = CCSizeMake(100, 100)
  if guideCfg.fixSize then
    nodeSize = guideCfg.fixSize
  elseif guideNode.getContentSize then
    nodeSize = guideNode:getContentSize()
  end
  local box = self:createGuideBox(nodeSize)
  guideNode.guideBox = box
  guideNode:addChild(box, 999)
  ed.layout.centerInParent(box)
  local offsetPos = guideCfg.offsetPos or ccp(0, 0)
  local posX, posY = box:getPosition()
  box:setPosition(ccp(posX + offsetPos.x, posY + offsetPos.y))
  local delayTime = 7
  local isShowStory = false
  local callFunc = CCCallFunc:create(function()
    delayTime = delayTime - 1
    if delayTime <= 0 then
      box:setVisible(false)
    end
  end)
  local action = CCRepeatForever:create(CCSequence:create(ccArrayMake(CCFadeTo:create(0.5, 50), CCFadeTo:create(0.5, 255), callFunc)))
  box:runAction(action)
  if guideCfg.storyKey and not isShowStory then
    isShowStory = true
    local currentScene = ed.getCurrentScene()
    if currentScene and currentScene.identity ~= guideCfg.sceneId then
      return
    end
    ed.showStory(guideCfg.storyKey)
  end
end

function class:createGuideBox(size)
  local bg = ed.createSprite()
  bg:setCascadeOpacityEnabled(true)
  bg:setContentSize(size)
  local leftTop = ed.createSprite(self.GuideBoxPath)
  local leftBottom = ed.createSprite(self.GuideBoxPath)
  local rightTop = ed.createSprite(self.GuideBoxPath)
  local rightBottom = ed.createSprite(self.GuideBoxPath)
  local frameSize = leftTop:getContentSize()
  leftTop:setPosition(ccp(frameSize.width / 2, size.height - frameSize.height / 2))
  leftBottom:setPosition(ccp(frameSize.width / 2, frameSize.height / 2))
  rightTop:setPosition(ccp(size.width - frameSize.width / 2, size.height - frameSize.height / 2))
  rightBottom:setPosition(ccp(size.width - frameSize.width / 2, frameSize.height / 2))
  leftBottom:setScaleY(-1)
  rightTop:setScaleX(-1)
  rightBottom:setScale(-1)
  bg:addChild(leftTop)
  bg:addChild(leftBottom)
  bg:addChild(rightTop)
  bg:addChild(rightBottom)
  return bg
end
