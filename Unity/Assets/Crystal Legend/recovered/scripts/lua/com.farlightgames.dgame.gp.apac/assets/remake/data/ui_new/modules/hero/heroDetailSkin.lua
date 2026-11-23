local SkinDetail = {}
local herodetail = ed.ui.heroDetailScene
local res = ed.heroDetailManager.resConfig
herodetail.newskin = SkinDetail
local acts = require("util.cocos2dx.actions")
local lsr = ed.heroDetailManager.listener.create()

function SkinDetail:initFashionData(hid)
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

function SkinDetail:initData(param)
  self.controller = param.controller
  self.pos = param.pos or ccp(0, 0)
  self.hero = param.hero
  self.hid = self.hero._tid
  self.curFashionIdx = 1
  self.skinList = {}
  self:initFashionData()
end

function SkinDetail:adaptUI()
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
  self.controller.mainLayer:addChild(layerColor, 999)
  self.cardLayerColor = layerColor
  local layer = ed.createSprite()
  self.controller.mainLayer:addChild(layer, 1011)
  self.cardLayer = layer
  self.controller.cardLayer[3] = layer
  local color = CCLayerColor:create(ccc4(0, 0, 0, 205))
  color:setPosition(-ed.display.winSize.width / 2, -ed.display.winSize.height / 2)
  layerColor:addChild(color)
  self.cardLayerColor:setVisible(false)
  self.controller:btRegisterButtonClick({
    button = self.cardLayerColor,
    key = "fashionPage_cardcolor",
    clickHandler = function()
      self.cardLayer:stopAllActions()
      local scale = self.cardLayer:getScale()
      local isOp = scale <= 1
      local fadeOut = CCRotateTo:create(0.3, isOp and -90 or 0)
      local scale = CCScaleTo:create(0.3, isOp and 1.96 or 1)
      local move = CCMoveTo:create(0.3, isOp and self.cradToPos or self.cradPos)
      local spawn = CCSpawn:create(ccArrayMake(scale, fadeOut, move))
      self.cardLayer:runAction(spawn)
      self.cardLayerColor:setVisible(false)
    end,
    priority = -995,
    clickInterval = 0.6,
    force = true
  })
  local cardLayerCollision = ed.createSprite()
  self.cardLayerCollision = cardLayerCollision
  self.cardLayer:addChild(cardLayerCollision)
  self.controller:btRegisterButtonClick({
    button = self.cardLayerCollision,
    key = "fashionPage_card",
    clickHandler = function()
      self.cardLayer:stopAllActions()
      local scale = self.cardLayer:getScale()
      local isOp = scale <= 1
      local fadeOut = CCRotateTo:create(0.3, isOp and -90 or 0)
      local scale = CCScaleTo:create(0.3, isOp and 1.96 or 1)
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

function SkinDetail:initLabels()
end

function SkinDetail:refreshUI(changeHero)
  self:refreshCard()
  self:refreshHeroFca()
  local frameRes
  if self.skinList[self.curFashionIdx].fashion_id and self.skinList[self.curFashionIdx].fashion_id > 0 then
    frameRes = ed.getFashionFrameRes(self.skinList[self.curFashionIdx].fashion_id, "nameFrame")
  else
    frameRes = "UI/alpha/1080P/skin/skin_name_frame.png"
  end
  ed.setString(self.ui.skin_name, self.skinList[self.curFashionIdx].name)
  local frameImg = ed.createScale9Sprite(frameRes, CCRectMake(50, 20, 134, 10))
  if frameImg then
    local frameSize = frameImg:getContentSize()
    frameImg:setContentSize(CCSizeMake(math.max(frameSize.width, self.ui.skin_name:getContentSize().width + 50), frameSize.height))
    ed.UITool.replaceUINew(self.ui, "bg_skin_name", frameImg)
  end
  if changeHero then
    self:createFashionList()
  end
end

function SkinDetail:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self.controller:removeUpdateHandler("checkFcaHandler")
    end
  end
  
  return handler
end

function SkinDetail:refreshHeroFca()
  if self.puppet then
    self.puppet:setVisible(false)
    self.puppet:removeFromParentAndCleanup(true)
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
  self.controller:addFca(puppet)
  self.puppet = puppet
  self.cha = row.Resource
  self.action_pre = "Idle"
  local isSpine = string.match(self.cha, "%.sp$")
  if not isSpine then
    self.cha = self.cha .. ".cha"
  end
end

function SkinDetail:refreshCard()
  self.ui.skin_card:setVisible(false)
  self.cardLayerCollision:retain()
  if self.cardLayer then
    self.cardLayer:removeAllChildrenWithCleanup(true)
  end
  self.cardLayer:addChild(self.cardLayerCollision, 3)
  self.cardLayerCollision:release()
  local card = ed.readhero.getHeroCard(self.hid, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = self.skinList[self.curFashionIdx].fashion_id or 0
  })
  local card_ui = card.container
  card_ui:setScale(0.99)
  self.cardLayer:addChild(card_ui)
  self.ui.skin_card = card_ui
  local cardSize = card.frame:getContentSize()
  self.cardLayer:setContentSize(cardSize)
  self.cardLayer:setPosition(self.cradPos)
  self.cardLayerCollision:setContentSize(CCSizeMake(cardSize.width * 0.9, cardSize.height * 0.85))
  self.cardLayerCollision:setPosition(ccp(cardSize.width * 0.45, 250))
  for fashion_id, effect_fca in pairs(card.card_fashion_effect or {}) do
    self.controller:addFca(effect_fca)
  end
  for fashion_id, plist in pairs(card.fashion_plist_res or {}) do
    self.controller:addFca(plist)
  end
end

function SkinDetail:isFashionUnlock(index)
  local fashionDatas = self.skinList
  if not fashionDatas then
    self:initFashionData()
  end
  local fashionData = fashionDatas[index]
  if not fashionData then
    return false
  end
  if fashionData.itemId and fashionData.itemId > 0 then
    if 0 < (ed.player.equip_qunty[fashionData.itemId] or 0) then
      return true
    else
      return false
    end
  else
    return true
  end
end

function SkinDetail:createFashionCardSmall(index)
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
    local isUnlock = self:isFashionUnlock(index)
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
    ui.label_weared:setVisible(isCurFashion)
    ui.btn_select:setVisible(isUnlock and isSelectFashion and not isCurFashion)
    ui.label_select:setVisible(isUnlock and isSelectFashion and not isCurFashion)
    self.controller:btRemoveMainTouchHandler({
      key = "choose" .. self.hid .. "_" .. index
    })
    self.controller:btRegisterButtonClick({
      button = ui.btn_select,
      key = "choose" .. self.hid .. "_" .. index,
      clickHandler = function()
        self:sendChangeHeroSkin(index)
      end
    })
    if not isUnlock then
      self.controller:btRemoveMainTouchHandler({
        key = "item" .. self.hid .. "_" .. index
      })
      local itemId = self.skinList[index].itemId
      self.controller:btRegisterButtonClick({
        button = ui.lock,
        key = "item" .. self.hid .. "_" .. index,
        clickHandler = function()
          ed.ui.packageDetailWin.create({id = itemId}):popWindow()
        end
      })
    end
  end
  return container, ui
end

function SkinDetail:createFashionList()
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

function SkinDetail:refreshData(hero)
  self.hero = hero
  self.hid = hero._tid
  self:initFashionData()
end

function SkinDetail:initUI()
  local layer, ui = ed.editorui(ed.uieditor.herodetailSkin, {
    ui = self.controller.ui
  })
  self.mainLayer = layer
  self.ui = ui
  self:adaptUI()
  self.ui.layer_skin:setPosition(self.pos)
  self:initLabels()
  self:createFashionList()
  self:refreshUI()
end

function SkinDetail:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local fashion_id = self.skinList[self.curFashionIdx].fashion_id
  local puppet, cha = ed.readhero.getActor(self.hid, "Idle", true, false, fashion_id, false)
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
  local caiDanAnim = ed.getDataTable("Puppet")[cha]["Action CaiDan"]
  if caiDanAnim then
    can_show_action_tbl[#can_show_action_tbl + 1] = caiDanAnim
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

function SkinDetail:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.hid,
      action = action,
      fashionId = self.skinList[self.curFashionIdx].fashion_id
    })
  end
  self.controller:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(action, duration))
end

function SkinDetail:moveFashionLeft()
  self.controller.mainLayer:setTouchEnabled(false)
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
      self.controller.mainLayer:setTouchEnabled(true)
    end)))
  end
end

function SkinDetail:moveFashionRight()
  self.controller.mainLayer:setTouchEnabled(false)
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
      container:removeFromParentAndCleanup(true)
      self.controller.mainLayer:setTouchEnabled(true)
    end)))
  end
end

function SkinDetail:sendChangeHeroSkin(fashionIndex)
  local fashionId = self.skinList[fashionIndex].fashion_id
  local msg = ed.upmsg.fashion_req()
  msg._set_fashion = {}
  msg._set_fashion._hero_id = self.hid
  msg._set_fashion._fashion_id = fashionId
  ed.send(msg, "fashion")
end

function SkinDetail:registerTouchHandlers(level)
  ed.UITool.registerBtn(self.controller, "arrow1", function()
    if self.controller.tabIndex == 3 then
      if self.curFashionIdx <= 1 then
        ed.showToast(T("\229\183\166\228\190\167\229\183\178\231\187\143\230\178\161\230\156\137\231\154\174\232\130\164\228\186\134\239\188\129"))
        return
      else
        self.curFashionIdx = self.curFashionIdx - 1
        self:moveFashionRight()
        self:refreshUI()
      end
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.controller, "arrow2", function()
    if self.controller.tabIndex == 3 then
      if self.curFashionIdx >= #self.skinList then
        ed.showToast(T("\230\149\172\232\175\183\230\156\159\229\190\133"))
        return
      else
        self.curFashionIdx = self.curFashionIdx + 1
        self:moveFashionLeft()
        self:refreshUI()
      end
    end
  end, {pressScale = 0.95})
  self.controller:btRegisterRectClick({
    rect = CCRectMake(230, 165, 140, 195),
    parent = self.ui.bg_skin,
    key = "skin_touch",
    clickHandler = function()
      if self.controller.tabIndex == 3 and self.controller.tabIndex == 3 then
        self:changeFcaAction(nil, true)
      end
    end,
    force = true
  })
  self.controller:btRegisterRectClick({
    rect = CCRectMake(10, 10, 70, 110),
    parent = self.ui.layer_skinlist,
    key = "skin_touch1",
    clickHandler = function()
      if self.controller.tabIndex == 3 then
        if self.curFashionIdx <= 1 then
          ed.showToast(T("\229\183\166\228\190\167\229\183\178\231\187\143\230\178\161\230\156\137\231\154\174\232\130\164\228\186\134\239\188\129"))
          return
        else
          self.curFashionIdx = self.curFashionIdx - 1
          self:moveFashionRight()
          self:refreshUI()
        end
      end
    end,
    force = true
  })
  self.controller:btRegisterRectClick({
    rect = CCRectMake(225, 10, 70, 110),
    parent = self.ui.layer_skinlist,
    key = "skin_touch2",
    clickHandler = function()
      if self.controller.tabIndex == 3 then
        if self.curFashionIdx >= #self.skinList then
          ed.showToast(T("\230\149\172\232\175\183\230\156\159\229\190\133"))
          return
        else
          self.curFashionIdx = self.curFashionIdx + 1
          self:moveFashionLeft()
          self:refreshUI()
        end
      end
    end,
    force = true
  })
end

function SkinDetail.create(param)
  local self = {}
  setmetatable(self, {__index = SkinDetail})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self.controller:listenEvent("ChangeHeroSkin", function(data)
    if data == "success" then
      ed.showToast(T("\231\169\191\230\136\180\230\136\144\229\138\159"))
      self:createFashionList()
    else
      ed.showToast(T("\230\155\180\230\141\162\231\154\174\232\130\164\229\164\177\232\180\165"))
    end
  end)
  return self
end
