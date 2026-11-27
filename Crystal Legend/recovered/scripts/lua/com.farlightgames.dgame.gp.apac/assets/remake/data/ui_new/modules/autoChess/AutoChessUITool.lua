module("ed.ui", package.seeall)
AutoChessUITool = {}
AutoChessUITool.__index = AutoChessUITool
local RankMap = {
  price_1 = 1,
  price_2 = 2,
  price_3 = 4,
  price_4 = 7,
  price_5 = 12
}

function AutoChessUITool.createTagNode(tag, num, level, target)
  local container, ui = ed.editorui(ed.uieditor.AutoChessTagItem)
  ui.layer1:setVisible(target == 1)
  ui.layer2:setVisible(target == 2)
  ui.layer3:setVisible(target == 3)
  ed.setTexture(ui.icon, ed.getDataTable("ChessTags")[tag].Sign)
  ed.setLabelStroke(ui.level, ed.toccc3(1312776), 1)
  ed.setString(ui.level, num)
  ui.level:setVisible(1 < level)
  for i = 1, target do
    local uiName = string.format("light%d_%d", target, i)
    ui[uiName]:setVisible(level >= i)
  end
  container:setContentSize(CCSizeMake(45, 50))
  return container, ui
end

function AutoChessUITool.createRaceHeroNode(heroData)
  local rootNode = CCSprite:create()
  rootNode:setContentSize(CCSizeMake(70, 97))
  rootNode:setAnchorPoint(ccp(0, 0))
  local unitInfo = ed.getDataTable("ChessUnit")[heroData.hid]
  local heroId = unitInfo["Hero ID"]
  local price = ed.getChessUnitBuyPrice(heroId)
  local param = {
    id = heroData.hid,
    level = false,
    rank = RankMap["price_" .. price]
  }
  local heroIcon = ed.readhero.createChessIcon(param)
  heroIcon.icon:setScale(0.9)
  heroIcon.icon:setAnchorPoint(ccp(0, 0))
  heroIcon.icon:setPosition(ccp(6, 26))
  rootNode:addChild(heroIcon.icon)
  local tagNode = CCNode:create()
  local raceTags = ed.getChessUnitRaceTags(heroData.hid)
  local offsetX = 2
  local scale = 0.6
  for _, tag in pairs(raceTags) do
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, 0))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
  end
  local abilityTags = ed.getChessUnitAbilityTags(heroData.hid)
  for _, tag in pairs(abilityTags) do
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, 0))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
  end
  tagNode:setPosition(ccp(-offsetX / 2 + 36, -1))
  rootNode:addChild(tagNode, 20)
  return rootNode
end

function AutoChessUITool.playScaleTipAction(node)
  if tolua.isnull(node) then
    return
  end
  node:stopAllActions()
  local scaleTo1 = CCScaleTo:create(0.3, 1.7)
  scaleTo1 = CCEaseIn:create(scaleTo1, 0.3)
  local scaleTo2 = CCScaleTo:create(0.2, 1)
  scaleTo2 = CCEaseOut:create(scaleTo2, 0.2)
  local seqAction = CCSequence:create(ccArrayMake(scaleTo1, scaleTo2))
  node:runAction(seqAction)
end

function AutoChessUITool.addFloatActionTip(targetNode, param)
  if tolua.isnull(targetNode) then
    return
  end
  local rootNode = CCNode:create()
  local labelTip = ed.createLabelTTF(param.text, param.size or 20)
  ed.setLabelColor(labelTip, param.color or ccc3(0, 255, 0))
  rootNode:addChild(labelTip)
  local moveAction1 = CCMoveBy:create(1, ccp(4, 6))
  local fadeAction1 = CCFadeOut:create(param.duration or 1)
  moveAction1 = CCSpawn:create(ccArrayMake(moveAction1, fadeAction1))
  local final = CCCallFunc:create(function()
    rootNode:removeFromParentAndCleanup(true)
  end)
  local seqAction = CCSequence:create(ccArrayMake(moveAction1, final))
  labelTip:runAction(seqAction)
  local offsetX, offsetY = param.offsetX or 10, param.offsetY or 10
  rootNode:setPosition(ccp(offsetX, offsetY))
  targetNode:addChild(rootNode)
end

function AutoChessUITool.playBlinkTipAction(node)
  if tolua.isnull(node) then
    return
  end
  local scale = node:getScale()
  node:stopAllActions()
  local blink1 = CCFadeOut:create(0.2)
  local blink2 = CCFadeIn:create(0.2)
  local scaleTo1 = CCScaleTo:create(0.2, 1)
  local spawnAction = CCSpawn:create(ccArrayMake(blink2, scaleTo1))
  local scaleTo2 = CCScaleTo:create(0.1, scale)
  local seqAction = CCSequence:create(ccArrayMake(blink1, spawnAction, scaleTo2))
  node:runAction(seqAction)
end

function AutoChessUITool.createLootNode(pos, loot)
  local rootNode = CCNode:create()
  rootNode.lootData = loot
  local shine = ed.createSprite("UI/alpha/1080P/common/shine.png")
  shine:setScale(1.5)
  rootNode:addChild(shine)
  local blink = CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 255), CCFadeTo:create(0.5, 0))
  local rotate = CCRotateBy:create(1, 60)
  local action = CCSpawn:create(ccArrayMake(blink, rotate))
  shine:runAction(CCRepeatForever:create(action))
  local petId = loot.loot._pid
  local boxFca = {
    "eff_UI_box_bronze",
    "eff_UI_box_bronze",
    "eff_UI_box_bronze",
    "eff_UI_box_silver",
    "eff_UI_box_gold"
  }
  local color = ed.getDataTable("ChessUnit")[petId]["Sell Price"]
  local fca = ed.createFcaNode(boxFca[color])
  ed.getCurrentScene():addFca(fca)
  fca:setScale(0.5)
  fca:setAction("Shake")
  rootNode.boxfca = fca
  rootNode:addChild(fca)
  rootNode:setPosition(pos)
  local moveAction = CCMoveTo:create(0.3, ccp(pos.x - 80 + 40 * loot.index, 200))
  rootNode:runAction(CCEaseOut:create(moveAction, 0.5))
  return rootNode
end
