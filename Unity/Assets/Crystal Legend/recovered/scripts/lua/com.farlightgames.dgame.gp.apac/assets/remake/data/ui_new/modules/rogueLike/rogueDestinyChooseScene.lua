local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueDestinyChooseScene = class
ed.UITool.registViewOpenFunc("rogueDestinyChooseScene", function(param)
  local scene = ed.ui.rogueDestinyChooseScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueDestinyChooseScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.chapterId = param.chapterId
  self.difficulty = param.difficulty
  self.crisisGroupId = param.crisisGroupId
  self.crisisDiff = param.crisisDiff
  self.selectDestinyId = nil
  self.selectIndex = nil
  self.offsetDistance = 0
  self.showActionAdapt = false
  self.dragListItemList = {}
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueDestinyChooseScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  self:initCircularList()
  self:initDestinyDescDragList()
  self.ui.destiny_info_bg:setVisible(false)
  self:reloadCard()
  ed.rogueGuide.getInstance():registerGuide("rogueDestinyChooseScene", self.ui.panel_destiny_choose)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(3085579), 1.5)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_left_arrow, {
    left = 15 + ed.display.getNotchHeight()
  }, true)
  ed.layout.layoutWithMagin(self.ui.image_right_arrow, {
    right = 15 + ed.display.getNotchHeight()
  }, true)
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
  local leftPosX, leftPosY = self.ui.image_left_arrow:getPosition()
  local lmove = CCMoveTo:create(1, ccp(leftPosX - 10, leftPosY))
  local lreverse = CCMoveTo:create(1, ccp(leftPosX, leftPosY))
  local lsequence = CCSequence:createWithTwoActions(lmove, lreverse)
  self.ui.image_left_arrow:runAction(CCRepeatForever:create(lsequence))
  local rightPosX, rightPosY = self.ui.image_right_arrow:getPosition()
  local rmove = CCMoveTo:create(1, ccp(rightPosX + 10, rightPosY))
  local rreverse = CCMoveTo:create(1, ccp(rightPosX, rightPosY))
  local rsequence = CCSequence:createWithTwoActions(rmove, rreverse)
  self.ui.image_right_arrow:runAction(CCRepeatForever:create(rsequence))
  local diffWidth = ed.display.winSize.width - 960
end

function class:initCircularList()
  local container = self.ui.panel_destiny_choose
  self.radius = 1000
  self.priority = -300
  self.offset = ccp(0, -100)
  self.pressScale = 0.85
  self.normalScale = 0.76
  local containerSize = container:getContentSize()
  local w = containerSize.width
  local h = containerSize.height
  self.w, self.h = w, h
  self.radius = math.max(self.radius, self.w / 2)
  local bg = CCSprite:create()
  container:addChild(bg)
  bg:setContentSize(containerSize)
  bg:setPosition(ccp(containerSize.width / 2, containerSize.height / 2))
  self.circularBg = bg
  container:setTouchEnabled(true)
  container:registerScriptTouchHandler(self:doMainLayerTouch(), false, self.priority, false)
end

function class:reloadCard()
  self.showDestiny = {}
  for destinyId, _ in ipairs(ed.getDataTable("RogueDestiny")) do
    table.insert(self.showDestiny, destinyId)
  end
  local amount = #self.showDestiny
  self.circularBg:removeAllChildrenWithCleanup(true)
  self.circularBg:setCascadeOpacityEnabled(true)
  local radius = self.radius
  radius = math.max(radius, self.w / 2)
  local theta = 2 * math.asin(self.w / 2 / (2 * radius))
  self.theta = theta
  self.cardList = {}
  self.cardPosNode = {}
  for index = 1, amount do
    local destinyId = self.showDestiny[index]
    local card, ui = ed.rogueLikeTool.createDestinyCard(destinyId)
    card:setCascadeOpacityEnabled(true)
    ui.image_bg:setCascadeOpacityEnabled(true)
    card:setScale(self.normalScale)
    card:setAnchorPoint(ccp(0.5, 0.5))
    local z = index
    self.circularBg:addChild(card, z)
    card.initZ = z
    card.index = index
    card.destinyId = destinyId
    table.insert(self.cardList, card)
    local rotation, pos = self:getTransform(index, amount, radius, theta, 1)
    card:setRotation(rotation)
    card:setPosition(pos)
    local node = CCNode:create()
    node:setScale(self.normalScale)
    node.originPosX = pos.x
    node.originPosY = pos.y
    node.originRota = rotation
    self.circularBg:addChild(node, z)
    table.insert(self.cardPosNode, node)
  end
  self.ui.btn_next:setVisible(false)
  self.ui.image_right_arrow:setVisible(false)
  self.ui.image_left_arrow:setVisible(false)
  self.dragList:setVisible(false)
  self:showOpenAction()
end

function class:showOpenAction()
  self.fixCard = true
  self.offsetDistance = 8
  self.showActionAdapt = false
  local targetX = self.cardList[1]:getPositionX()
  for index, node in ipairs(self.cardPosNode) do
    local card = self.cardList[index]
    local targetPositionX, targetPositionY = card:getPosition()
    node:setPositionX(-500)
    local startAction = CCMoveTo:create(0.4166666666666667, ccp(targetX, 0))
    local callFunc = CCCallFunc:create(function()
      self.showActionAdapt = true
    end)
    local moveAction = CCEaseSineOut:create(CCMoveTo:create(0.5, ccp(targetPositionX, 0)))
    local finaAction = CCSequence:create(ccArrayMake(startAction, callFunc, moveAction))
    node:runAction(finaAction)
  end
  ed.playEffect(ed.sound.deo.rogue_tarot_card)
end

function class:getTransform(index, amount, radius, theta, k)
  local alpha = theta * k
  local r = index * 2 * alpha / (amount + 1) - alpha
  local rotation = r * 180 / 3.14
  local x = radius * math.sin(r) + self.w / 2
  local y = radius * math.cos(r) + (self.h / 2 - radius * math.cos(theta))
  local pos = ccpAdd(ccp(x, y), self.offset)
  return rotation, pos, r
end

function class:getTransformByX(x, radius, theta)
  local r = math.asin((x - self.w / 2) / radius)
  local rotation = r * 180 / 3.14
  local y = radius * math.cos(r) + (self.h / 2 - radius * math.cos(theta))
  local pos = ccpAdd(ccp(x, y), self.offset)
  return rotation, pos, r
end

function class:updateCard(dt)
  if not self.fixCard then
    return
  end
  local radius = self.radius
  local theta = self.theta
  for index, card in ipairs(self.cardList) do
    local node = self.cardPosNode[index]
    local scale = node:getScale()
    local posX = node:getPositionX()
    local posY = node:getPositionY()
    local rota, pos, r = self:getTransformByX(posX, radius, theta)
    if self.showActionAdapt then
      self.offsetDistance = self.offsetDistance - 0.04
      self.offsetDistance = math.max(self.offsetDistance, 0)
    end
    local offsetX = self.offsetDistance * (index - 1) * math.sin(r)
    local offsetY = self.offsetDistance * (index - 1) * math.cos(r)
    card:setPosition(ccp(pos.x + offsetX, pos.y + offsetY + posY))
    card:setRotation(rota)
    card:setScale(scale)
  end
end

function class:initDestinyDescDragList()
  local panelSize = self.ui.panel_desc:getContentSize()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_desc, {
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(panelSize.width + 5, panelSize.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    }
  })
end

function class:refreshDestinyDetail()
  self.dragList:clearList()
  self.dragListItemList = {}
  local panelSize = self.ui.panel_desc:getContentSize()
  local posY = 5
  local destinyCfg = ed.getDataTable("RogueDestiny")[self.selectDestinyId] or {}
  local descTitle, titleSize = self:createDescTitle(destinyCfg["Display Name"])
  table.insert(self.dragListItemList, descTitle)
  self.dragList:addItem(descTitle)
  descTitle:setPosition(ccp(0, panelSize.height - posY))
  posY = posY + titleSize.height + 15
  local descLabel, descSize = self:createDesc(destinyCfg.Description)
  table.insert(self.dragListItemList, descLabel)
  self.dragList:addItem(descLabel)
  descLabel:setPosition(ccp(0, panelSize.height - posY))
  posY = posY + descSize.height + 15
  local skillTitle, skillTitleSize = self:createDescTitle(T("\229\145\189\232\191\144\230\138\128\232\131\189"))
  table.insert(self.dragListItemList, skillTitle)
  self.dragList:addItem(skillTitle)
  skillTitle:setPosition(ccp(0, panelSize.height - posY))
  posY = posY + skillTitleSize.height + 5
  local extraRevelationDesc = string.format(T("\232\142\183\229\190\151<lable color=ccc3(243,123,27)>3</lable>\228\184\170\228\187\187\230\132\143\227\128\144%s\227\128\145\231\165\157\231\166\143\230\191\128\230\180\187\229\145\189\232\191\144\229\144\175\231\164\186"), destinyCfg["Display Name"])
  local revelationTitle, revelationTitleSize = self:createDestinySkillTitle(T("\229\145\189\232\191\144\229\144\175\231\164\186"), extraRevelationDesc)
  table.insert(self.dragListItemList, revelationTitle)
  self.dragList:addItem(revelationTitle)
  revelationTitle:setPosition(ccp(0, panelSize.height - posY))
  posY = posY + revelationTitleSize.height + 5
  local revelationDetailPanel, revelationDetailPanelSize = self:createRevelationDetail()
  table.insert(self.dragListItemList, revelationDetailPanel)
  self.dragList:addItem(revelationDetailPanel)
  revelationDetailPanel:setPosition(ccp(0, panelSize.height - posY))
  posY = posY + revelationDetailPanelSize.height + 5
  local revelationBlessList = destinyCfg.RevelationBless or {}
  if 0 < #revelationBlessList then
    local extraDeepDesc = string.format(T("\232\142\183\229\190\151\227\128\144%s\227\128\145\231\165\157\231\166\143\230\149\176\233\135\143\232\190\190\229\136\176<lable color=ccc3(243,123,27)>6/9/12</lable>\230\151\182\233\128\137\230\139\169<lable color=ccc3(243,123,27)>1</lable>\228\184\170\230\183\177\229\186\166\229\144\175\231\164\186"), destinyCfg["Display Name"])
    local deepTitle, deepTitleSize = self:createDestinySkillTitle(T("\230\183\177\229\186\166\229\144\175\231\164\186"), extraDeepDesc)
    table.insert(self.dragListItemList, deepTitle)
    self.dragList:addItem(deepTitle)
    deepTitle:setPosition(ccp(0, panelSize.height - posY))
    posY = posY + deepTitleSize.height + 5
    for index, revelationBlessId in ipairs(revelationBlessList) do
      local blessDetailPanel, blessDetailPanelSize = self:createBlessDetail(revelationBlessId)
      table.insert(self.dragListItemList, blessDetailPanel)
      self.dragList:addItem(blessDetailPanel)
      blessDetailPanel:setPosition(ccp(0, panelSize.height - posY))
      posY = posY + blessDetailPanelSize.height + 5
    end
  end
  self.dragList:initListHeight(posY)
end

function class:createDescTitle(text)
  local width = self.ui.panel_desc:getContentSize().width
  local label = ed.createttf(text, 15)
  label:setCascadeOpacityEnabled(true)
  local labelSize = label:getContentSize()
  ed.setLabelColor(label, ed.toccc3(11572936))
  ed.setLabelStroke(label, ed.toccc3(2368548), 1)
  label:setAnchorPoint(ccp(0, 1))
  local line = ed.createScale9Sprite("UI/alpha/1080P/rogue/bless/destiny_info_line.png")
  label:addChild(line)
  line:setAnchorPoint(ccp(0, 0.5))
  local offsetX = 7
  line:setContentSize(CCSizeMake(width - labelSize.width - offsetX, 2.5))
  line:setPosition(ccp(labelSize.width + offsetX, 7.5))
  return label, labelSize
end

function class:createDesc(text)
  local width = self.ui.panel_desc:getContentSize().width
  local label = ed.createttf(text, 15)
  label:setAnchorPoint(ccp(0, 1))
  label:setStroke(ed.toccc3(2368548), 1)
  label:setDimensions(CCSizeMake(width, 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  return label, label:getContentSize()
end

function class:createActivation()
  local width = self.ui.panel_desc:getContentSize().width
  local destinyCfg = ed.getDataTable("RogueDestiny")[self.selectDestinyId] or {}
  local destinyName = destinyCfg["Display Name"]
  local text = string.format(T("<lable color=ccc3(255,252,231)>\232\142\183\229\190\151</lable><lable color=ccc3(243,123,27)>3</lable><lable color=ccc3(255,252,231)>\228\184\170\228\187\187\230\132\143\227\128\144%s\227\128\145\231\154\132\231\165\157\231\166\143\229\144\142\229\143\175\230\191\128\230\180\187\229\145\189\232\191\144\229\144\175\231\164\186\239\188\140\232\142\183\229\190\151\227\128\144%s\227\128\145\231\165\157\231\166\143\230\149\176\233\135\143\232\190\190</lable><lable color=ccc3(243,123,27)>6/9/12</lable><lable color=ccc3(255,252,231)>\230\151\182\229\143\175\233\128\137\230\139\169</lable><lable color=ccc3(243,123,27)>1</lable><lable color=ccc3(255,252,231)>\228\184\170\230\183\177\229\186\166\229\144\175\231\164\186\228\187\165\229\188\186\229\140\150\229\145\189\232\191\144\229\144\175\231\164\186\230\149\136\230\158\156\227\128\130</lable>"), destinyName, destinyName)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    maxWidth = width,
    strokeColor = ed.toccc3(2368548),
    strokeSize = 1,
    fontSize = 15
  })
  local textWidth, textHeight = autoText:getCurContentSize()
  return autoText.node, textHeight
end

function class:createDestinySkillTitle(text, tipText)
  local width = self.ui.panel_desc:getContentSize().width
  local container = ed.createSprite()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 1))
  container:setContentSize(CCSizeMake(width, 24.5))
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/bless/destiny_info_bg1.png")
  bg:setContentSize(CCSizeMake(width, 24.5))
  container:addChild(bg)
  ed.layout.centerInParent(bg)
  local label = ed.createttf(text, 15)
  ed.setLabelColor(label, ed.toccc3(16377855))
  ed.setLabelStroke(label, ed.toccc3(2368548), 1)
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(ccp(23, 12.5))
  container:addChild(label)
  if tipText then
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = tipText,
      fontSize = 15,
      color = ed.toccc3(11440056),
      strokeColor = ed.toccc3(2368548),
      strokeSize = 1
    })
    container:addChild(autoText.node)
    autoText.node:setPositionX(label:getPositionX() + label:getContentSize().width + 5)
    autoText.node:setPositionY(label:getPositionY())
  end
  return container, container:getContentSize()
end

function class:createRevelationDetail()
  local width = self.ui.panel_desc:getContentSize().width
  local bg = ed.createSprite()
  bg:setCascadeOpacityEnabled(true)
  bg:setAnchorPoint(ccp(0, 1))
  local destinyCfg = ed.getDataTable("RogueDestiny")[self.selectDestinyId]
  local iconBg = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_prepare_echo_lock.png")
  iconBg:setCascadeOpacityEnabled(true)
  local iconEcho = ed.createSprite("UI/alpha/1080P/rogue/bless/destiny_echo_icon.png")
  iconEcho:setCascadeOpacityEnabled(true)
  local revelationIcon = ed.createSprite(string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", destinyCfg.Icon))
  revelationIcon:setCascadeOpacityEnabled(true)
  iconEcho:setScale(1.72)
  iconBg:addChild(iconEcho, 1)
  iconBg:addChild(revelationIcon, 2)
  revelationIcon:setScale(0.95)
  ed.layout.centerInParent(iconEcho)
  ed.layout.centerInParent(revelationIcon)
  iconBg:setScale(0.4)
  bg:addChild(iconBg)
  local iconSize = iconBg:getContentSize()
  local iconWidth = iconSize.width * 0.4
  local iconHeight = iconSize.height * 0.4
  local nameBg = ed.createScale9Sprite("UI/alpha/1080P/rogue/bless/destiny_choose_name_bg.png")
  nameBg:setCascadeOpacityEnabled(true)
  nameBg:setAnchorPoint(ccp(0, 0.5))
  local offset = ccp(15, 0)
  local labelName = ed.createttf(destinyCfg["Revelation Name"], 15)
  ed.setLabelColor(labelName, ed.toccc3(16377855))
  ed.setLabelStroke(labelName, ed.toccc3(2368548), 1)
  labelName:setAnchorPoint(ccp(0, 0.5))
  nameBg:addChild(labelName)
  local nameSize = labelName:getContentSize()
  nameBg:setContentSize(CCSizeMake(math.max(nameSize.width + 20, 92), 23.5))
  local nameBgSize = nameBg:getContentSize()
  labelName:setPosition(ccp(10, 11.25))
  bg:addChild(nameBg)
  local autoText = ed.rogueLikeTool.parseAutoTextDesc(destinyCfg["Revelation Description"], destinyCfg, {
    color = ed.toccc3(16377855),
    strokeColor = ed.toccc3(2368548),
    strokeSize = 1,
    maxWidth = width - iconWidth - offset.x,
    fontSize = 15
  })
  bg:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  local bgSize = CCSizeMake(width, math.max(h + nameBgSize.height, iconHeight))
  bg:setContentSize(bgSize)
  nameBg:setPosition(ccp(iconWidth + offset.x - 10, (bgSize.height + h) / 2))
  autoText.node:setPositionX(iconWidth + offset.x)
  autoText.node:setPositionY((bgSize.height + h) / 2 - 7.5 - nameSize.height)
  iconBg:setPositionX(iconWidth / 2)
  ed.layout.centerYInParent(iconBg)
  return bg, bg:getContentSize()
end

function class:createBlessDetail(blessId)
  local width = self.ui.panel_desc:getContentSize().width
  local bg = ed.createSprite()
  bg:setCascadeOpacityEnabled(true)
  bg:setAnchorPoint(ccp(0, 1))
  local blessCfg = ed.getDataTable("RogueBless")[blessId]
  local iconBg = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_prepare_echo_lock.png")
  iconBg:setCascadeOpacityEnabled(true)
  local iconEcho = ed.createSprite("UI/alpha/1080P/rogue/bless/destiny_echo_icon.png")
  iconEcho:setCascadeOpacityEnabled(true)
  iconEcho:setScale(1.72)
  local blessIcon = ed.rogueLikeTool.createBlessIcon(blessId)
  iconBg:addChild(iconEcho, 1)
  iconBg:addChild(blessIcon, 2)
  blessIcon:setScale(0.95)
  ed.layout.centerInParent(iconEcho)
  ed.layout.centerInParent(blessIcon)
  iconBg:setScale(0.4)
  bg:addChild(iconBg)
  local iconSize = iconBg:getContentSize()
  local iconWidth = iconSize.width * 0.4
  local iconHeight = iconSize.height * 0.4
  local nameBg = ed.createScale9Sprite("UI/alpha/1080P/rogue/bless/destiny_choose_name_bg.png")
  nameBg:setCascadeOpacityEnabled(true)
  nameBg:setAnchorPoint(ccp(0, 0.5))
  local labelName = ed.createttf(blessCfg["Bless Name"], 15)
  ed.setLabelColor(labelName, ed.toccc3(16377855))
  ed.setLabelStroke(labelName, ed.toccc3(2368548), 1)
  labelName:setAnchorPoint(ccp(0, 0.5))
  labelName:setPosition(ccp(10, 11.25))
  nameBg:addChild(labelName)
  local nameSize = labelName:getContentSize()
  nameBg:setContentSize(CCSizeMake(math.max(nameSize.width + 20, 92), 23.5))
  local nameBgSize = nameBg:getContentSize()
  bg:addChild(nameBg)
  local offset = ccp(15, 0)
  local autoText = ed.rogueLikeTool.parseAutoTextDesc(blessCfg.Description, blessCfg, {
    color = ed.toccc3(16377855),
    strokeColor = ed.toccc3(2368548),
    strokeSize = 1,
    maxWidth = width - iconWidth - offset.x,
    fontSize = 15
  })
  bg:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  local bgSize = CCSizeMake(width, math.max(h + nameBgSize.height, iconHeight))
  bg:setContentSize(bgSize)
  nameBg:setPosition(ccp(iconWidth + offset.x - 10, (bgSize.height + h) / 2))
  autoText.node:setPositionX(iconWidth + offset.x)
  autoText.node:setPositionY((bgSize.height + h) / 2 - 7.5 - nameSize.height)
  iconBg:setPositionX(iconWidth / 2)
  ed.layout.centerYInParent(iconBg)
  return bg, bg:getContentSize()
end

function class:onSelectDestinyCard(index)
  self.selectDestinyId = self.showDestiny[index]
  self.selectIndex = index
  self.ui.panel_destiny_choose:setVisible(true)
  self.ui.destiny_info_bg:setVisible(true)
  self.showCardDetail = true
  ed.rogueGuide.getInstance():endGuide("rogueDestinyChooseScene")
  self:refreshDestinyDetail()
end

function class:showSelectCardAction(selectIndex)
  self.fixCard = false
  self.clickCardIndex = nil
  local panelSize = self.ui.panel_destiny_choose:getContentSize()
  local targetPosX, targetPosY = self.ui.panel_destiny_card:getPosition()
  local panelDestinyCardSize = self.ui.panel_destiny_card:getContentSize()
  local leftOutPosX = -300
  local centerPosX = panelSize.width / 2
  local centerPosY = panelSize.height / 2
  local rightOutPosX = panelSize.width + 300
  for index, card in ipairs(self.cardList) do
    local adaptAction
    if index < selectIndex then
      adaptAction = CCMoveTo:create(0.1, ccp(leftOutPosX, panelSize.width / (selectIndex + 1) * index))
    elseif index == selectIndex then
      local scaleAction = CCScaleTo:create(0.1, 1)
      local rotationAction = CCRotateTo:create(0.1, 0)
      local moveAction = CCMoveTo:create(0.1, ccp(centerPosX, centerPosY))
      local moveToCenterAction = CCSpawn:create(ccArrayMake(scaleAction, rotationAction, moveAction))
      local delay = CCDelayTime:create(0.1)
      local moveAction2 = CCMoveTo:create(0.2, ccp(targetPosX + panelDestinyCardSize.width / 2, targetPosY + panelDestinyCardSize.height / 2))
      local call = CCCallFunc:create(function()
        self:onSelectDestinyCard(selectIndex)
        self:showDestinyDetailAction()
        self.ui.btn_next:setVisible(true)
        self.ui.image_right_arrow:setVisible(true)
        self.ui.image_left_arrow:setVisible(true)
        self.dragList:setVisible(true)
      end)
      adaptAction = CCSequence:create(ccArrayMake(moveToCenterAction, delay, moveAction2, call))
    elseif selectIndex < index then
      adaptAction = CCMoveTo:create(0.1, ccp(rightOutPosX, panelSize.width - panelSize.width / (#self.cardList - selectIndex + 1) * (index - selectIndex)))
    end
    card:stopAllActions()
    card:runAction(adaptAction)
  end
  ed.playEffect(ed.sound.deo.rogue_tarot_choose)
end

function class:closeSelectCardAction()
  local selectIndex = self.selectIndex
  self.selectIndex = nil
  self.selectDestinyId = nil
  self.showCardDetail = false
  local panelSize = self.ui.panel_destiny_choose:getContentSize()
  local leftOutPosX = -300
  local rightOutPosX = panelSize.width + 300
  for index, card in ipairs(self.cardList) do
    local node = self.cardPosNode[index]
    local originPosX = node.originPosX
    local originPosY = node.originPosY
    local originRota = node.originRota
    local adaptAction
    if index < selectIndex then
      card:setScale(self.normalScale)
      card:setPosition(ccp(leftOutPosX, panelSize.width / (selectIndex + 1) * index))
      local moveAction = CCMoveTo:create(0.2, ccp(originPosX, originPosY))
      local rotaAction = CCRotateTo:create(0.2, originRota)
      adaptAction = CCSpawn:create(ccArrayMake(rotaAction, moveAction))
    elseif index == selectIndex then
      local offsetDistance = 130
      local r = originRota * 3.14 / 180
      local offsetX = offsetDistance * math.sin(r)
      local offsetY = offsetDistance * math.cos(r)
      local scaleAction = CCScaleTo:create(0.1, self.normalScale)
      local rotationAction = CCRotateTo:create(0.1, originRota)
      local moveAction = CCSpawn:create(ccArrayMake(scaleAction, rotationAction))
      local moveAction2 = CCMoveTo:create(0.2, ccp(originPosX + offsetX, originPosY + offsetY))
      local moveAction3 = CCMoveTo:create(0.2, ccp(originPosX, originPosY))
      local call = CCCallFunc:create(function()
        self.fixCard = true
      end)
      adaptAction = CCSequence:create(ccArrayMake(moveAction, moveAction2, moveAction3, call))
    elseif index > selectIndex then
      card:setScale(self.normalScale)
      card:setPosition(ccp(rightOutPosX, panelSize.width - panelSize.width / (#self.cardList - selectIndex + 1) * (index - selectIndex)))
      local rotaAction = CCRotateTo:create(0.1, originRota)
      local moveAction = CCMoveTo:create(0.1, ccp(originPosX, originPosY))
      adaptAction = CCSpawn:create(ccArrayMake(rotaAction, moveAction))
    end
    node:setScale(self.normalScale)
    node:setPosition(ccp(originPosX, 0))
    node:setRotation(originRota)
    card:setOpacity(255)
    card:stopAllActions()
    card:runAction(adaptAction)
  end
end

function class:showDestinyDetailAction()
  for index, detailItem in ipairs(self.dragListItemList) do
    detailItem:setOpacity(0)
    local offsetX = 50
    detailItem:setPositionX(detailItem:getPositionX() - offsetX)
    local delay = CCDelayTime:create((index - 1) * 0.05)
    local moveAction = CCMoveBy:create(0.1, ccp(offsetX, 0))
    local fadeAction = CCFadeIn:create(0.1)
    local showAction = CCSpawn:create(ccArrayMake(moveAction, fadeAction))
    detailItem:runAction(CCSequence:create(ccArrayMake(delay, showAction)))
  end
end

function class:closeDestinyDetailAction(callBack)
  for index, detailItem in ipairs(self.dragListItemList) do
    local offsetX = 50
    local delay = CCDelayTime:create((index - 1) * 0.05)
    local moveAction = CCMoveBy:create(0.1, ccp(-offsetX, 0))
    local fadeAction = CCFadeOut:create(0.1)
    local showAction = CCSpawn:create(ccArrayMake(moveAction, fadeAction))
    local callFunc
    if index == #self.dragListItemList and callBack then
      callFunc = CCCallFunc:create(function()
        callBack()
      end)
    end
    if callFunc then
      detailItem:runAction(CCSequence:create(ccArrayMake(delay, showAction, callFunc)))
    else
      detailItem:runAction(CCSequence:create(ccArrayMake(delay, showAction)))
    end
  end
end

function class:showCardChangeAction(direction, oldIndex, newIndex)
  local oldCard = self.cardList[oldIndex]
  local newCard = self.cardList[newIndex]
  if not oldCard or not newCard then
    return
  end
  local offset
  if direction == "left" then
    offset = -100
  elseif direction == "right" then
    offset = 100
  end
  oldCard:setRotation(0)
  oldCard:setScale(1)
  local moveAction1 = CCMoveBy:create(0.3, ccp(offset, 0))
  local fadeAction1 = CCFadeOut:create(0.15)
  oldCard:runAction(CCSpawn:create(ccArrayMake(moveAction1, fadeAction1)))
  newCard:setPosition(ccp(oldCard:getPositionX() - offset, oldCard:getPositionY()))
  newCard:setScale(1)
  newCard:setOpacity(0)
  newCard:setRotation(0)
  local moveAction2 = CCMoveBy:create(0.3, ccp(offset, 0))
  local fadeAction2 = CCFadeIn:create(0.15)
  newCard:runAction(CCSpawn:create(ccArrayMake(moveAction2, fadeAction2)))
end

function class:doListLayerTouch(event, x, y)
  if self.showCardDetail then
    return
  end
  if event == "began" then
    for index = #self.cardList, 1, -1 do
      local card = self.cardList[index]
      if ed.containsPoint(card, x, y) then
        self.pressCard = card
        break
      end
    end
  elseif event == "ended" then
    if self.pressCard and ed.containsPoint(self.pressCard, x, y) then
      self:showSelectCardAction(self.pressCard.index)
    end
    self.pressCard = nil
  end
end

function class:doMainLayerTouch()
  local function handler(event, x, y)
    self:doListLayerTouch(event, x, y)
    
    return true
  end
  
  return handler
end

function class:onClickLeftBtn()
  local oldIndex = self.selectIndex
  self.selectIndex = self.selectIndex - 1
  if self.selectIndex < 1 then
    self.selectIndex = #self.showDestiny
  end
  self.selectDestinyId = self.showDestiny[self.selectIndex]
  self:showCardChangeAction("left", oldIndex, self.selectIndex)
  self:closeDestinyDetailAction(function()
    self:refreshDestinyDetail()
    self:showDestinyDetailAction()
  end)
  ed.playEffect(ed.sound.deo.rogue_tarot_choose)
end

function class:onClickRightBtn()
  local oldIndex = self.selectIndex
  self.selectIndex = self.selectIndex + 1
  if self.selectIndex > #self.showDestiny then
    self.selectIndex = 1
  end
  self.selectDestinyId = self.showDestiny[self.selectIndex]
  self:showCardChangeAction("right", oldIndex, self.selectIndex)
  self:closeDestinyDetailAction(function()
    self:refreshDestinyDetail()
    self:showDestinyDetailAction()
  end)
  ed.playEffect(ed.sound.deo.rogue_tarot_choose)
end

function class:onClickNextBtn()
  local rogueBattlePrepareScene = ed.ui.rogueBattlePrepare.create({
    destinyId = self.selectDestinyId,
    chapterId = self.chapterId,
    difficulty = self.difficulty,
    crisisGroupId = self.crisisGroupId,
    crisisDiff = self.crisisDiff
  })
  ed.rogueLikeTool.showTransformEffect(rogueBattlePrepareScene)
end

function class:onClickBtnBack()
  if self.selectDestinyId then
    self.selectDestinyId = nil
    self:closeDestinyDetailAction(function()
      self:closeSelectCardAction()
      self.ui.btn_next:setVisible(false)
      self.ui.image_right_arrow:setVisible(false)
      self.ui.image_left_arrow:setVisible(false)
      self.dragList:setVisible(false)
    end)
  else
    ed.popScene()
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "image_left_arrow", function()
    self:onClickLeftBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_right_arrow", function()
    self:onClickRightBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_next", function()
    self:onClickNextBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function class:addEventListener()
  self:listenEvent("rogueEnterChapter", function()
    self.isEnterChapter = true
  end)
  self:registerOnEnterHandler("onEnter", function()
    if self.isEnterChapter then
      ed.popScene()
    end
    ed.rogueGuide.getInstance():startGuide("rogueDestinyChooseScene")
  end)
  self:registerUpdateHandler("updateCard", function()
    self:updateCard()
  end)
end
