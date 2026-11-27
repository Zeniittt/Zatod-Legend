local layerSkin = {}
ed.ui.heroShowPop.heroMode.layerSkin = layerSkin
local lsr = ed.heroDetailManager.listener.create()

function layerSkin.create(popSelf, param)
  local container, ui = ed.editorui(ed.uieditor.herodetailSkin)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    container = container,
    ui = ui
  }, {__index = layerSkin}):init()
end

function layerSkin:init()
  self.hero = self.param
  self.hid = self.hero._tid
  self:adaptUI()
  self.skinList = {}
  self.curFashionIdx = #self.skinList
  self.ui.skin_card:setVisible(false)
  self:refresh()
  self.popSelf:btRegisterButtonClick({
    button = self.ui.arrow1,
    key = "skin_arrow1",
    clickHandler = function()
      if self.curFashionIdx <= 1 then
        ed.showToast(T("\229\183\166\228\190\167\229\183\178\231\187\143\230\178\161\230\156\137\231\154\174\232\130\164\228\186\134\239\188\129"))
        return
      else
        self.curFashionIdx = self.curFashionIdx - 1
        self:moveFashionRight()
        self:refreshCard()
        self:refreshHeroFca()
      end
    end,
    pressScale = 0.95,
    force = true
  })
  self.popSelf:btRegisterButtonClick({
    button = self.ui.arrow2,
    key = "skin_arrow2",
    clickHandler = function()
      if self.curFashionIdx >= #self.skinList then
        ed.showToast(T("\230\149\172\232\175\183\230\156\159\229\190\133"))
        return
      else
        self.curFashionIdx = self.curFashionIdx + 1
        self:moveFashionLeft()
        self:refreshCard()
        self:refreshHeroFca()
      end
    end,
    pressScale = 0.95,
    force = true
  })
  self.popSelf:btRegisterRectClick({
    rect = CCRectMake(230, 165, 140, 195),
    parent = self.ui.bg_skin,
    key = "skin_touch",
    clickHandler = function()
      self:changeFcaAction(nil, true)
    end,
    force = true
  })
  self.popSelf:btRegisterRectClick({
    rect = CCRectMake(10, 10, 70, 110),
    parent = self.ui.layer_skinlist,
    key = "skin_touch1",
    clickHandler = function()
      if self.curFashionIdx <= 1 then
        ed.showToast(T("\229\183\166\228\190\167\229\183\178\231\187\143\230\178\161\230\156\137\231\154\174\232\130\164\228\186\134\239\188\129"))
        return
      else
        self.curFashionIdx = self.curFashionIdx - 1
        self:moveFashionRight()
        self:refreshCard()
        self:refreshHeroFca()
      end
    end,
    force = true
  })
  self.popSelf:btRegisterRectClick({
    rect = CCRectMake(225, 10, 70, 110),
    parent = self.ui.layer_skinlist,
    key = "skin_touch2",
    clickHandler = function()
      if self.curFashionIdx >= #self.skinList then
        ed.showToast(T("\230\149\172\232\175\183\230\156\159\229\190\133"))
        return
      else
        self.curFashionIdx = self.curFashionIdx + 1
        self:moveFashionLeft()
        self:refreshCard()
        self:refreshHeroFca()
      end
    end,
    force = true
  })
  return self
end

function layerSkin:show(vis, param)
  self.container:setVisible(vis)
  self.cardLayer:setVisible(vis)
  if vis then
    self:refresh(param)
  end
end

function layerSkin:refresh(param)
  if param then
    self.hero = param
    self.hid = self.hero._tid
  end
  self:initFashionData()
  self:refreshCard()
  self:refreshHeroFca()
  self:createFashionList()
end

function layerSkin:refreshCard()
  self.cardLayer:removeAllChildrenWithCleanup(true)
  local card = ed.readhero.getHeroCard(self.hid, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = self.skinList[self.curFashionIdx].fashion_id or 0
  }, self.hero)
  local card_ui = card.container
  card_ui:setScale(0.99)
  card_ui:setZOrder(2)
  self.cardLayer:addChild(card_ui)
  self.ui.skin_card = card_ui
  self.cardLayer:setContentSize(card.frame:getContentSize())
  self.cardLayer:setPosition(self.cradPos)
  ed.setString(self.ui.skin_name, self.skinList[self.curFashionIdx].name)
  for _, effect_fca in pairs(card.card_fashion_effect or {}) do
    self.popSelf:addFca(effect_fca)
  end
  for _, plist in pairs(card.fashion_plist_res or {}) do
    self.popSelf:addFca(plist)
  end
end

function layerSkin:createFashionList()
  local container, preCardUi = self:createFashionCardSmall(self.curFashionIdx - 1)
  if preCardUi then
    preCardUi.icon:setScale(0.8)
    preCardUi.icon:setCascadeOpacityEnabled(true)
    self.preCard = preCardUi
    ed.UITool.replaceUI(self.ui, "layer_skinlist", "pre_skin", container)
  else
    self.ui.pre_skin:setVisible(false)
  end
  local container, curCardUi = self:createFashionCardSmall(self.curFashionIdx)
  if curCardUi then
    curCardUi.icon:setCascadeOpacityEnabled(true)
    self.curCard = curCardUi
    ed.UITool.replaceUI(self.ui, "layer_skinlist", "cur_skin", container)
  else
    self.ui.cur_skin:setVisible(false)
  end
  local container, nextCardUi = self:createFashionCardSmall(self.curFashionIdx + 1)
  if nextCardUi then
    nextCardUi.icon:setScale(0.8)
    nextCardUi.icon:setCascadeOpacityEnabled(true)
    self.nextCard = nextCardUi
    ed.UITool.replaceUI(self.ui, "layer_skinlist", "next_skin", container)
  else
    self.ui.next_skin:setVisible(false)
  end
end

function layerSkin:moveFashionLeft()
  self.popSelf.mainLayer:setTouchEnabled(false)
  local x, y = self.ui.next_skin:getPosition()
  if self.preCard then
    self.preCard.icon:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(-40, 0)), CCFadeOut:create(0.3))))
  end
  if self.curCard then
    self.curCard.icon:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(-100, 0)), CCScaleTo:create(0.3, 0.8))))
  end
  if self.nextCard then
    self.nextCard.icon:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(-100, 0)), CCScaleTo:create(0.3, 1))))
  end
  local container, nextCardUi = self:createFashionCardSmall(self.curFashionIdx + 1)
  if nextCardUi then
    nextCardUi.icon:setScale(0.8)
    nextCardUi.icon:setCascadeOpacityEnabled(true)
    nextCardUi.icon:setOpacity(0)
    container:setPosition(ccp(x + 40, y))
    self.ui.layer_skinlist:addChild(container)
    local spawn = CCSpawn:create(ccArrayMake(CCMoveBy:create(0.4, ccp(-40, 0)), CCFadeIn:create(0.4)))
    nextCardUi.icon:runAction(CCSequence:createWithTwoActions(spawn, CCCallFunc:create(function()
      self:createFashionList()
      container:removeFromParentAndCleanup(true)
      self.popSelf.mainLayer:setTouchEnabled(true)
    end)))
  end
end

function layerSkin:moveFashionRight()
  self.popSelf.mainLayer:setTouchEnabled(false)
  local x, y = self.ui.pre_skin:getPosition()
  if self.nextCard then
    self.nextCard.icon:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(40, 0)), CCFadeOut:create(0.3))))
  end
  if self.curCard then
    self.curCard.icon:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(100, 0)), CCScaleTo:create(0.3, 0.8))))
  end
  if self.preCard then
    self.preCard.icon:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(100, 0)), CCScaleTo:create(0.3, 1))))
  end
  local container, preCardUi = self:createFashionCardSmall(self.curFashionIdx - 1)
  if preCardUi then
    preCardUi.icon:setScale(0.8)
    preCardUi.icon:setCascadeOpacityEnabled(true)
    preCardUi.icon:setOpacity(0)
    container:setPosition(ccp(x - 40, y))
    self.ui.layer_skinlist:addChild(container)
    local spawn = CCSpawn:create(ccArrayMake(CCMoveBy:create(0.4, ccp(40, 0)), CCFadeIn:create(0.4)))
    preCardUi.icon:runAction(CCSequence:createWithTwoActions(spawn, CCCallFunc:create(function()
      self:createFashionList()
      self.popSelf.mainLayer:setTouchEnabled(true)
    end)))
  end
end

function layerSkin:createFashionCardSmall(index)
  local heroFashionId = self.hero._fashion
  local container, ui = ed.editorui(ed.uieditor.skinItem)
  local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/skin/show/Coco_Skin_1.png")
  clippingNode:setPosition(41, 58.5)
  ui.icon:addChild(clippingNode)
  if index < 1 then
    container:setVisible(false)
    return container, ui
  elseif index > #self.skinList then
    ui.icon:setPositionY(84)
    ed.setTexture(ui.icon, "UI/alpha/1080P/skin/skin_comsoon.png")
  else
    local isUnlock = true
    local isCurFashion = heroFashionId == self.skinList[index].fashion_id
    local isSelectFashion = index == self.curFashionIdx
    if self.skinList[index].fashion_id and self.skinList[index].fashion_id > 0 then
      local res = ed.getDataTable("Fashion")[self.skinList[index].fashion_id]["Show Icon"]
      if res then
        ed.setTexture(ui.icon, res)
      end
      res = ed.getFashionFrameRes(self.skinList[index].fashion_id, "FrameMini")
      if res then
        ed.setTexture(ui.frame, res)
        ui.frame:setScale(1.072)
        ui.frame:setPosition(44.5, 63)
        ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", self.skinList[index].fashion_id))(ed.createSpriteTools({
          res = ed.getFashionFrameRes(self.skinList[index].fashion_id, "qualityBg"),
          pos = ccp(45, 25),
          parent = ui.frame
        }), ccp(28, 26), 18)
      end
    else
      local texture = ed.createSprite(ed.getUnitArt(self.hid))
      local contentSize = texture:getContentSize()
      local parentSize = ui.icon:getContentSize()
      local scale = math.max(parentSize.width / contentSize.width, parentSize.height / contentSize.height) + 0.02
      texture:setScale(scale)
      texture:setPositionY(-10)
      clippingNode:addChild(texture)
    end
    ui.title:setVisible(false)
    ed.setLabelStroke(ui.title, ed.toccc3(1711648), 1)
    ui.title:setFontName(ed.fontBold)
    ui.lock:setVisible(not isUnlock)
    ui.label_lock:setVisible(not isUnlock)
    ui.select:setVisible(isSelectFashion)
    ui.label_weared:setVisible(false)
    ui.btn_select:setVisible(false)
    ui.label_select:setVisible(false)
  end
  return container, ui
end

function layerSkin:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.hid]
  local can_show_action_tbl = {"Move"}
  for idx, skill_item in pairs(skill_items or {}) do
    for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
      if string.find(action, "special") == nil then
        can_show_action_tbl[#can_show_action_tbl + 1] = action
      end
    end
  end
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(actions, k)
        table.insert(dur, v.Duration)
      end
    elseif ed.isElementInTable(k, can_show_action_tbl) and k ~= self.action_pre then
      table.insert(actions, k)
      table.insert(dur, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #actions)
  end
  local action = actions[index]
  self.action_pre = action
  self.duration = dur[index]
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  return action, self.duration
end

function layerSkin:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.hid,
      action = action,
      fashionId = self.hero._fashion
    })
  end
  self.popSelf:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(action, duration))
end

function layerSkin:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self.popSelf:removeUpdateHandler("checkFcaHandler")
    end
  end
  
  return handler
end

function layerSkin:refreshHeroFca()
  if self.puppet then
    self.puppet:setVisible(false)
    self.puppet:removeFromParentAndCleanup(true)
  end
  if self.skinList[self.curFashionIdx].fashion_id and self.skinList[self.curFashionIdx].fashion_id > 0 then
    local ress = ed.getFashionFrameRes(self.skinList[self.curFashionIdx].fashion_id, "nameFrame")
    if ress then
      ed.setTexture(self.ui.bg_skin_name, ress)
    end
  else
    ed.setTexture(self.ui.bg_skin_name, "UI/alpha/1080P/skin/skin_name_frame.png")
  end
  local fashion_id = self.skinList[self.curFashionIdx].fashion_id
  local puppet, cha = ed.readhero.getActor(self.hid, "Idle", true, false, fashion_id, false)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = row.Scale * wscale
  end
  puppet:setScale(scale)
  puppet:setPosition(ccp(self.ui.bg_mid:getContentSize().width / 2, 190))
  self.ui.bg_mid:addChild(puppet, 10)
  self.popSelf:addFca(puppet)
  self.puppet = puppet
  self.action_pre = "Idle"
  self.cha = row.Resource
  local isSpine = string.match(self.cha, "%.sp$")
  if not isSpine then
    self.cha = self.cha .. ".cha"
  end
end

function layerSkin:initFashionData(hid)
  hid = hid or self.hid
  local fashionData = {
    {
      fashion_id = nil,
      name = ed.getDataTable("Unit")[hid]["Display Name"]
    }
  }
  local fashionTb = ed.getDataTable("Fashion")
  local serverTime = ed.getServerTime()
  for k, v in pairs(fashionTb) do
    if type(k) == "number" and v["Online Time"] and v["Hero ID"] == self.hid and serverTime > ed.getTimeByYMDHMS(v["Online Time"]) then
      table.insert(fashionData, {
        fashion_id = k,
        itemId = v["Item ID"],
        name = v.Name
      })
    end
  end
  self.skinList = fashionData
  if self.hero._fashion then
    for k, v in ipairs(fashionData) do
      if v.fashion_id == self.hero._fashion then
        self.curFashionIdx = k
      end
    end
  else
    self.curFashionIdx = 1
  end
end

function layerSkin:adaptUI()
  self.ui.layer_skin:setPosition(ccp(433.75, 239.75))
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.fixWidth = fixWidth
  self.ui.bg_skin:setPositionX(self.ui.bg_skin:getPositionX() + fixWidth / 2)
  local width = self.ui.bg_skin:getContentSize().width
  self.ui.bg_skin:setScaleX((width + fixWidth) / width)
  self.ui.deco_right:setPositionX(self.ui.deco_right:getPositionX() + fixWidth)
  self.ui.layer_skinlist:setPositionX(self.ui.layer_skinlist:getPositionX() + fixWidth / 2)
  self.ui.arrow2:setPositionX(self.ui.arrow2:getPositionX() + fixWidth)
  self.ui.skin_name_g:setPositionX(self.ui.skin_name_g:getPositionX() + fixWidth / 2)
  local size = self.ui.bg_mid:getContentSize()
  self.ui.bg_mid:setContentSize(CCSizeMake(size.width + fixWidth, size.height))
  self.cradPos = ccp(200 - ed.display.halfFixedWidth * 0.66, 250)
  self.cradToPos = ccp(ed.display.winSize.width / 2 - ed.display.halfFixedWidth + 10, ed.display.winSize.height / 2 + 30 - ed.display.halfFixedHeight)
  local layerColor = CCLayer:create()
  layerColor:setPosition(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight)
  self.popSelf.containers:addChild(layerColor, 999)
  self.cardLayerColor = layerColor
  local layer = ed.createSprite()
  self.popSelf.containers:addChild(layer, 1011)
  self.cardLayer = layer
  layer:setScale(0.99)
  local color = CCLayerColor:create(ccc4(0, 0, 0, 205))
  color:setPosition(-ed.display.winSize.width / 2, -ed.display.winSize.height / 2)
  layerColor:addChild(color)
  self.cardLayerColor:setVisible(false)
  self.popSelf:btRegisterButtonClick({
    button = self.cardLayerColor,
    key = "fashionPage_cardcolor",
    clickHandler = function()
      self.cardLayer:stopAllActions()
      local scale = self.cardLayer:getScale()
      local isOp = scale <= 1
      local fadeOut = CCRotateTo:create(0.3, isOp and -90 or 0)
      local scale = CCScaleTo:create(0.3, isOp and 1.96 or 0.99)
      local move = CCMoveTo:create(0.3, isOp and self.cradToPos or self.cradPos)
      local spawn = CCSpawn:create(ccArrayMake(scale, fadeOut, move))
      self.cardLayer:runAction(spawn)
      self.cardLayerColor:setVisible(false)
    end,
    priority = -995,
    clickInterval = 0.6,
    force = true
  })
  self.popSelf:btRegisterButtonClick({
    button = self.cardLayer,
    key = "fashionPage_card",
    clickHandler = function()
      self.cardLayer:stopAllActions()
      local scale = self.cardLayer:getScale()
      local isOp = scale <= 1
      local fadeOut = CCRotateTo:create(0.3, isOp and -90 or 0)
      local scale = CCScaleTo:create(0.3, isOp and 1.96 or 0.99)
      local move = CCMoveTo:create(0.3, isOp and self.cradToPos or self.cradPos)
      local spawn = CCSpawn:create(ccArrayMake(scale, fadeOut, move))
      self.cardLayer:runAction(spawn)
      self.cardLayerColor:setVisible(isOp)
    end,
    priority = -998,
    clickInterval = 0.3,
    force = true
  })
end
