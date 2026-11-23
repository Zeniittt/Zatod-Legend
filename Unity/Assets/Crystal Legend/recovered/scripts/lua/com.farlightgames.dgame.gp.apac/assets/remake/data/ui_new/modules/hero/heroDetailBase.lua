local BaseDetail = newclass("g")
local herodetail = ed.ui.heroDetailScene
herodetail.newbase = BaseDetail
local acts = require("util.cocos2dx.actions")
local lsr = ed.heroDetailManager.listener.create()
local res = ed.heroDetailManager.resConfig

function BaseDetail:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  local midPercent = 0.66
  self.ui.bg_mid1:setContentSize(CCSizeMake(self.ui.bg_mid1:getContentSize().width + fixWidth * midPercent, self.ui.bg_mid1:getContentSize().height))
  self.ui.bg_mid1:setPositionX(self.ui.bg_mid1:getPositionX() + fixWidth * midPercent / 2)
  self.ui.sep2:setPositionX(self.ui.sep2:getPositionX() + fixWidth * midPercent)
  self.ui.bg_name:setPositionX(self.ui.bg_name:getPositionX() + fixWidth * midPercent / 2)
  self.ui.equip1:setPositionX(self.ui.equip1:getPositionX() - fixWidth * midPercent / 4)
  self.ui.equip2:setPositionX(self.ui.equip2:getPositionX() - fixWidth * midPercent / 4)
  self.ui.equip3:setPositionX(self.ui.equip3:getPositionX() - fixWidth * midPercent / 4)
  self.ui.equip4:setPositionX(self.ui.equip4:getPositionX() + fixWidth * midPercent / 4)
  self.ui.equip5:setPositionX(self.ui.equip5:getPositionX() + fixWidth * midPercent / 4)
  self.ui.equip6:setPositionX(self.ui.equip6:getPositionX() + fixWidth * midPercent / 4)
  local rightPercent = 1 - midPercent
  self.ui.bg_attr:setContentSize(CCSizeMake(self.ui.bg_attr:getContentSize().width + fixWidth * rightPercent, self.ui.bg_attr:getContentSize().height))
  self.ui.bg_attr:setPositionX(self.ui.bg_attr:getPositionX() + fixWidth * (midPercent + rightPercent / 2))
  self.ui.bg_level:setContentSize(CCSizeMake(self.ui.bg_level:getContentSize().width + fixWidth * rightPercent, self.ui.bg_level:getContentSize().height))
  self.ui.bg_level:setPositionX(self.ui.bg_level:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.bg_star:setContentSize(CCSizeMake(self.ui.bg_star:getContentSize().width + fixWidth * rightPercent, self.ui.bg_star:getContentSize().height))
  self.ui.bg_star:setPositionX(self.ui.bg_star:getPositionX() + fixWidth * rightPercent / 2)
  local starPercent = 0.1
  self.ui.bg_star1:setPositionX(self.ui.bg_star1:getPositionX() + fixWidth * rightPercent * (0.5 - starPercent * 2))
  self.ui.bg_star2:setPositionX(self.ui.bg_star2:getPositionX() + fixWidth * rightPercent * (0.5 - starPercent))
  self.ui.bg_star3:setPositionX(self.ui.bg_star3:getPositionX() + fixWidth * rightPercent * 0.5)
  self.ui.bg_star4:setPositionX(self.ui.bg_star4:getPositionX() + fixWidth * rightPercent * (0.5 + starPercent))
  self.ui.bg_star5:setPositionX(self.ui.bg_star5:getPositionX() + fixWidth * rightPercent * (0.5 + starPercent * 2))
  self.ui.bg_info:setContentSize(CCSizeMake(self.ui.bg_info:getContentSize().width + fixWidth * rightPercent, self.ui.bg_info:getContentSize().height))
  self.ui.bg_info:setPositionX(self.ui.bg_info:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.btn_info:setPositionX(self.ui.btn_info:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.label_info:setPositionX(self.ui.label_info:getPositionX() + fixWidth * rightPercent * 0.2)
  self.ui.bg_element_attr:setContentSize(CCSizeMake(self.ui.bg_element_attr:getContentSize().width + fixWidth * rightPercent, self.ui.bg_element_attr:getContentSize().height))
  self.ui.bg_element_attr:setPositionX(self.ui.bg_element_attr:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.img_element_icon:setPositionX(self.ui.img_element_icon:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.label_element_attr:setPositionX(self.ui.label_element_attr:getPositionX() + fixWidth * rightPercent * 0.2)
  local attrContentSize = self.ui.bg_attrlist:getContentSize()
  self.ui.bg_attrlist:setContentSize(CCSizeMake(self.ui.bg_attrlist:getContentSize().width + fixWidth * rightPercent, self.ui.bg_attrlist:getContentSize().height))
  self.ui.bg_attrlist:setPositionX(self.ui.bg_attrlist:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.attr1:setPositionX(self.ui.attr1:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr2:setPositionX(self.ui.attr2:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr3:setPositionX(self.ui.attr3:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr4:setPositionX(self.ui.attr4:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr5:setPositionX(self.ui.attr5:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.num_attr1:setPositionX(self.ui.num_attr1:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr2:setPositionX(self.ui.num_attr2:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr3:setPositionX(self.ui.num_attr3:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr4:setPositionX(self.ui.num_attr4:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr5:setPositionX(self.ui.num_attr5:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.layer_collect:setPositionX(self.ui.layer_collect:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.deco1:setScaleX(0.9 * (attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.deco2:setScaleX(0.9 * (attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.bg_bar_exp:setScaleX((attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.label_exp:setScaleX(1 / self.ui.bg_bar_exp:getScaleX())
  self.ui.bg_bar_stone:setScaleX((attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.label_stone:setScaleX(1 / self.ui.bg_bar_stone:getScaleX())
  self.ui.btn_levelup:setPositionX(self.ui.btn_levelup:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.btn_evolve:setPositionX(self.ui.btn_evolve:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.bg_gsadd:setPositionX(self.ui.bg_gsadd:getPositionX() + ed.display.halfFixedWidth)
  self.ui.card:removeFromParentAndCleanup(true)
  self.cradPos = ccp(200 - ed.display.halfFixedWidth * 0.66, 250)
  self.cradToPos = ccp(ed.display.winSize.width / 2 - ed.display.halfFixedWidth + 10, ed.display.winSize.height / 2 + 30 - ed.display.halfFixedHeight)
  local layerColor = CCLayer:create()
  layerColor:setPosition(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight)
  self.controller.mainLayer:addChild(layerColor, 1000)
  self.cardLayerColor = layerColor
  local layer = ed.createSprite()
  self.controller.mainLayer:addChild(layer, 1001)
  self.cardLayer = layer
  self.controller.cardLayer[1] = layer
  local color = CCLayerColor:create(ccc4(0, 0, 0, 205))
  color:setPosition(-ed.display.winSize.width / 2, -ed.display.winSize.height / 2)
  layerColor:addChild(color)
  self.cardLayerColor:setVisible(false)
  self.controller:btRegisterButtonClick({
    button = self.cardLayerColor,
    key = "layerBasePage_cardcolor",
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
      self.controller.ui.arrow_left:setVisible(true)
      self.controller.ui.arrow_right:setVisible(true)
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
    key = "layerBasePage_card",
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
      self.controller.ui.arrow_left:setVisible(not isOp)
      self.controller.ui.arrow_right:setVisible(not isOp)
    end,
    priority = -998,
    clickInterval = 0.3,
    force = true
  })
end

function BaseDetail:initLabels()
  ed.setLabelStroke(self.ui.label_level, ccc3(0, 0, 0), 1)
  ed.setLabelShadow(self.ui.label_levelup, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_evolve, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_up, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelStroke(self.ui.label_exp, ccc3(47, 46, 47), 1)
  ed.setLabelStroke(self.ui.label_stone, ccc3(47, 46, 47), 1)
  ed.setLabelStroke(self.ui.label_info, ccc3(41, 27, 27), 1)
  ed.setLabelStroke(self.ui.label_gs, ed.toccc3(3611404), 1)
  ed.setLabelStroke(self.ui.label_element_attr, ed.toccc3(2693914), 1)
  for i = 1, 5 do
    ed.setLabelStroke(self.ui["attr" .. i], ccc3(41, 27, 27), 1)
    ed.setLabelStroke(self.ui["num_attr" .. i], ccc3(41, 27, 27), 1)
    ed.setLabelString(self.ui["num_attr" .. i], " ")
  end
  ed.adaptLabel(self.ui.label_levelup, {maxWidth = 60, minScale = 0.7})
  ed.adaptLabel(self.ui.label_evolve, {maxWidth = 60, minScale = 0.7})
  self.ui.label_levelup:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.label_evolve:setHorizontalAlignment(kCCTextAlignmentCenter)
end

function BaseDetail:refreshExpBar()
  local bar = self.ui.bar_exp
  local isMaxLevel = self.hero._level == ed.getHeroMaxLevel()
  local percent = 100
  if not isMaxLevel then
  end
  if self.hero._level == ed.getHeroMaxLevel() then
    bar:setScaleX(1)
    ed.setString(self.ui.label_exp, T("\229\183\178\229\141\135\232\135\179\230\187\161\231\186\167"))
    self.ui.label_exp:limitWidthByScale(self.ui.bg_bar_exp:getContentSize().width - 5)
    self.ui.label_exp:setScaleX(1 / self.ui.bg_bar_exp:getScaleX() * self.ui.label_exp:getScaleY())
    self.ui.btn_levelup:setVisible(false)
  else
    local percent = math.floor(self.hero._exp / ed.lookupDataTable("Levels", "Exp", self.hero._level) * 100)
    if 100 < percent then
      percent = 100
    end
    bar:setScaleX(percent / 100)
    ed.setString(self.ui.label_exp, string.format("%d%%", percent))
    self.ui.btn_levelup:setVisible(true)
  end
end

function BaseDetail.createProcessBar(res, parentUI, ccRect)
  local size = parentUI:getContentSize()
  local clippingNode = ed.createClippingNodeOnly(res, 0.5)
  clippingNode:setPosition(ccp(0.5, size.height / 2))
  local stencil = clippingNode:getStencil()
  stencil:setAnchorPoint(ccp(0, 0.5))
  local barScale = size.width / stencil:getContentSize().width
  stencil:setScaleX(barScale)
  local sprite = ed.createSprite()
  local bar = ed.createScale9Sprite(res, ccRect)
  bar:setContentSize(CCSizeMake(size.width - 3, size.height - 3))
  bar:setPosition(ccp(0.7, 0.5))
  bar:setAnchorPoint(ccp(0, 0.5))
  sprite:addChild(bar)
  clippingNode:addChild(sprite)
  parentUI:addChild(clippingNode)
  return sprite
end

function BaseDetail:createExpBar()
  self.ui.bar_exp = self.createProcessBar("UI/alpha/1080P/hero/hero_exp_progress.png", self.ui.bg_bar_exp, CCRectMake(45, 8, 45, 2))
  self:refreshExpBar()
end

function BaseDetail:refreshStoneBar()
  local bar = self.ui.bar_stone
  if ed.readhero.checkHeroMaxStar(self.hid) then
    bar:setScaleX(1)
    ed.setString(self.ui.label_stone, T("\229\183\178\232\191\155\229\140\150\232\135\179\233\161\182\231\186\167"))
    self.ui.label_stone:limitWidthByScale(self.ui.bg_bar_stone:getContentSize().width - 5)
    self.ui.label_stone:setScaleX(1 / self.ui.bg_bar_stone:getScaleX() * self.ui.label_stone:getScaleY())
  else
    local sa = ed.readhero.getStoneAmount(self.hid)
    local row = ed.getDataTable("HeroStars")[self.hero._stars + 1] or {}
    local sn = row["Upgrade Fragments"] or 99999
    if 1 <= sa / sn then
      self.barFca:setVisible(true)
      self.particleFca:setVisible(true)
      bar:setScaleX(1)
    else
      self.barFca:setVisible(false)
      self.particleFca:setVisible(false)
      bar:setScaleX(sa / sn)
    end
    ed.setString(self.ui.label_stone, string.format("%d/%d", sa, sn))
  end
end

function BaseDetail:createStoneBar()
  self.ui.bar_stone = ed.UITool.createProcessBar("UI/alpha/1080P/hero/hero_soulstone_progress.png", self.ui.bg_bar_stone, CCRectMake(45, 6.5, 45, 6.5))
  local barFca = ed.createFcaNode("eff_UI_starupline_light")
  barFca:setPosition(ccp(58, 11))
  self.ui.bg_bar_stone:addChild(barFca, -1)
  self.controller:addFca(barFca)
  self.barFca = barFca
  local particleFca = ed.createFcaNode("eff_UI_starupline_particle")
  particleFca:setPosition(ccp(60, 11))
  self.ui.bg_bar_stone:addChild(particleFca)
  self.controller:addFca(particleFca)
  self.particleFca = particleFca
  self:refreshStoneBar()
end

function BaseDetail:createCard()
  self.cardLayerCollision:retain()
  if self.cardLayer then
    self.cardLayer:removeAllChildrenWithCleanup(true)
  end
  self.cardLayer:addChild(self.cardLayerCollision, 3)
  self.cardLayerCollision:release()
  local card = ed.readhero.getHeroCard(self.hid, {
    hide_star = true,
    starType = "init",
    OriSize = true
  })
  local card_ui = card.container
  card_ui:setScale(0.99)
  card_ui:setZOrder(2)
  self.cardLayer:addChild(card_ui)
  self.ui.card = card_ui
  for fashion_id, effect_fca in pairs(card.card_fashion_effect or {}) do
    self.controller:addFca(effect_fca)
  end
  local cardSize = card.frame:getContentSize()
  self.cardLayer:setContentSize(cardSize)
  self.cardLayer:setPosition(self.cradPos)
  self.cardLayerCollision:setContentSize(CCSizeMake(cardSize.width * 0.9, cardSize.height * 0.85))
  self.cardLayerCollision:setPosition(ccp(cardSize.width * 0.45, 250))
end

function BaseDetail:createHeroName()
  local ui = self.ui
  local nb = ed.getCenterPos(ui.frame_name)
  ui.name:removeFromParentAndCleanup(true)
  local name, w, h = ed.readhero.createHeroNameByInfo({
    name = ed.getDataTable("Unit")[self.hid]["Display Name"],
    rank = self.hero._rank,
    tid = self.hero._tid
  })
  ed.setTexture(ui.frame_name, string.format("UI/alpha/1080P/hero/rank/hero_rank_%d.png", self.hero._rank))
  ui.name = name
  local wScale = 1
  if 190 < w then
    wScale = 190 / w
    ui.name:setScale(wScale)
  end
  name:setPosition(ccp(nb.x - w * wScale / 2, nb.y))
  ui.frame_name:addChild(name)
  ui.frame_name:setZOrder(1)
end

function BaseDetail:refreshHeroStars()
  for i = 1, 5 do
    self.ui["star" .. i]:setVisible(true)
  end
  for i = self.hero._stars + 1, 5 do
    self.ui["star" .. i]:setVisible(false)
  end
  if ed.readhero.checkHeroMaxStar(self.hid) then
    self.ui.btn_evolve:setVisible(false)
  else
    self.ui.btn_evolve:setVisible(true)
  end
end

function BaseDetail:createHeroFca()
  if self.puppet then
    self.puppet:removeFromParentAndCleanup(true)
    self.puppet = nil
  end
  local puppet, cha = ed.readhero.getActor(self.hid, "Idle", true, false, self.hero._fashion, false)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = scale * wscale
  end
  puppet:setScale(scale)
  puppet:setPosition(ccp(200, 165))
  self.ui.bg_equip:addChild(puppet, 10)
  self.controller:addFca(puppet)
  self.puppet = puppet
  self.cha = row.Resource
  self.action_pre = "Idle"
  local isSpine = string.match(self.cha, "%.sp$")
  if not isSpine then
    self.cha = self.cha .. ".cha"
  end
end

function BaseDetail:getEquipIdFromTb(hid, slot, rank)
  local rank = rank or ed.player.heroes[hid]._rank
  local slotStr = string.format("Equip%d ID", slot)
  return ed.getDataTable("hero_equip")[hid][rank][slotStr]
end

function BaseDetail:getHeroEquipState(hid, slot)
  local eid = self:getEquipIdFromTb(hid, slot)
  local ceid = ed.player.heroes[hid]:getEquipid(slot)
  local ea = ed.player.equip_qunty[eid] or 0
  if ceid == 0 then
    if ea == 0 then
      if ed.isEquipCraftable(eid) then
        if ed.canWearEquip(hid, eid) then
          return "canCraft", "wear", eid
        else
          return "canCraft", "cannotwear", eid
        end
      elseif ed.isCanGetFromChest(eid) then
        if ed.canWearEquip(hid, eid) then
          return "canUse", "wear", eid
        else
          return "canUse", "cannotwear", eid
        end
      else
        return "notHave"
      end
    elseif not ed.canWearEquip(hid, eid) then
      return "cannotwear", "cannotwear", eid
    else
      return "canWear", "wear", eid
    end
  else
    return "isEquiped"
  end
end

function BaseDetail:createEquipTag(i)
  local eui = self.equips[i]
  if not tolua.isnull(eui.tagText) then
    eui.tagText:removeFromParentAndCleanup(true)
  end
  if not tolua.isnull(eui.tagIcon) then
    eui.tagIcon:removeFromParentAndCleanup(true)
  end
  local ett, eti = self:getHeroEquipState(self.hid, i)
  local useItems = self.canWearEquipId
  if ett == "canWear" and eti == "wear" then
    local eid = self:getEquipIdFromTb(self.hid, i)
    if useItems[eid] then
      if useItems[eid] + 1 <= ed.player.equip_qunty[eid] then
        useItems[eid] = useItems[eid] + 1
        table.insert(self.canWearSlot, i)
      end
    else
      useItems[eid] = 1
      table.insert(self.canWearSlot, i)
    end
  end
  if ett ~= "isEquiped" then
    local equipTagCfg = res.equip_tag_text[ett]
    local labelTag = ed.createttf(equipTagCfg.text, 18)
    ed.adaptLabel(labelTag, {
      maxWidth = 66,
      singleLine = true,
      minScale = 0.65
    })
    ed.setLabelColor(labelTag, equipTagCfg.labelColor)
    ed.setLabelStroke(labelTag, equipTagCfg.strokeColor, equipTagCfg.strokeSize)
    eui.frame:addChild(labelTag)
    labelTag:setPosition(ccp(45, 25))
    eui.tagText = labelTag
  end
  if eti then
    eui.tagIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = res.equip_tag_icon[eti]
      },
      layout = {
        position = ccp(66, 66)
      },
      config = {scale = 1}
    }, eui.frame)
  end
  self.equips[i].isEquiped = ett == "isEquiped"
end

function BaseDetail:createEquipTags()
  self.canWearSlot = {}
  self.canWearEquipId = {}
  for i = 1, 6 do
    self:createEquipTag(i)
  end
end

function BaseDetail:runRefreshGsAction(param)
  self.ui.bg_gsadd:setVisible(true)
  self.ui.bg_gsadd:removeAllChildrenWithCleanup(true)
  local newgs = self.hero._gs > self.pregs
  local pregs = ed.getNumberNode({
    text = self.pregs,
    folder = "hero_gs",
    padding = -1
  }).node
  local addgs = ed.getNumberNode({
    text = math.abs(self.hero._gs - self.pregs),
    folder = "hero_gs_up",
    padding = -1
  }).node
  local gsText = ed.createSprite("UI/alpha/1080P/hero/hero_gs_up.png")
  local iconAdd = ed.createSprite(newgs and "UI/alpha/1080P/hero/hero_upgrade_add.png" or "UI/alpha/1080P/hero/hero_upgrade_sub.png")
  gsText:setPosition(130, 20)
  iconAdd:setPosition(260, 20)
  pregs:setPosition(210, 20)
  addgs:setPosition(300, 20)
  self.ui.bg_gsadd:addChild(gsText)
  self.ui.bg_gsadd:addChild(iconAdd)
  self.ui.bg_gsadd:addChild(pregs)
  self.ui.bg_gsadd:addChild(addgs)
  self.ui.bg_gsadd:runAction(acts.sequence({
    acts.spawn({
      CCFadeIn:create(0.1),
      CCMoveBy:create(0.1, ccp(0, 10))
    }),
    CCMoveBy:create(0.4, ccp(0, 3)),
    CCFadeOut:create(0.2),
    CCCallFunc:create(function()
      self.ui.bg_gsadd:setVisible(false)
      self.ui.bg_gsadd:setPosition(ccp(104, 0))
    end)
  }))
  local x, y = self.ui.num_gs:getPosition()
  local numgs = ed.getNumberNode({
    text = self.hero._gs,
    folder = "hero_gs",
    padding = -1
  }).node
  numgs:setPosition(ccp(x, y))
  self.ui.num_gs:removeFromParentAndCleanup(true)
  self.ui.num_gs = numgs
  self.ui.bg_gs:addChild(numgs)
  local s1 = CCEaseBackOut:create(CCScaleTo:create(0.2, 1.3))
  local s2 = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
  self.ui.num_gs:runAction(ed.readaction.create({
    t = "seq",
    s1,
    s2
  }))
end

function BaseDetail:updateGs()
  local gs = self.hero._gs
  if gs ~= self.pregs then
    self:runRefreshGsAction()
    self.pregs = gs
  end
end

function BaseDetail:refreshLegendEquip()
  self.ui.legend_equip_icon:removeAllChildrenWithCleanup(true)
  self.ui.legend_equip_bind_bg:setVisible(false)
  self.legendEquipState = nil
  local heroLegendEquip = self.hero._legend_equip
  local legendEquip = heroLegendEquip and heroLegendEquip._equip
  local state
  if not legendEquip then
    local legendEquipMgr = ed.legendEquipMgr.getInstance()
    local isUnlock = ed.heroDetailManager:getLegendEquipUnlock(self.hid)
    local unlockLevel = ed.heroDetailManager:getUnlockLevel()
    local tagPath
    if unlockLevel > self.hero._level then
      state = "hide"
    elseif not isUnlock then
      state = "lock"
      tagPath = "UI/alpha/1080P/legendequip/equip_unlock.png"
    else
      local canWearEquip = legendEquipMgr:getCanUseEquip()
      if 0 < #canWearEquip then
        state = "canWear"
        tagPath = "UI/alpha/1080P/hero/equip/equip_add_2.png"
      else
        state = "notHave"
        tagPath = "UI/alpha/1080P/legendequip/equip_noquip.png"
      end
    end
    self.legendEquipState = state
    if state == "hide" or ed.isAreaOverSea() then
      self.ui.bg_legend_equip:setVisible(false)
    else
      self.ui.bg_legend_equip:setVisible(true)
      local equipTagCfg = res.equip_tag_text[state]
      local labelTag = ed.createttf(equipTagCfg.text, 15)
      ed.adaptLabel(labelTag, {
        maxWidth = 66,
        singleLine = true,
        minScale = 0.65
      })
      ed.setLabelColor(labelTag, equipTagCfg.labelColor)
      ed.setLabelStroke(labelTag, equipTagCfg.strokeColor, equipTagCfg.strokeSize)
      self.ui.legend_equip_icon:addChild(labelTag)
      labelTag:setPosition(ccp(37.5, 17))
      local imageTag = ed.createSprite(tagPath)
      self.ui.legend_equip_icon:addChild(imageTag)
      imageTag:setPosition(ccp(37.5, 41))
    end
  else
    local icon = ed.readequip.createLegendEquipIcon(legendEquip)
    self.ui.legend_equip_icon:addChild(icon)
    icon:setScale(0.95)
    ed.layout.centerInParent(icon)
    if self.legendEquipUpdateReason == "equip" then
      local light = ed.createFcaNode("eff_UI_equipping_LegendEquip")
      self.controller:addFcaOnce(light)
      self.ui.legend_equip_icon:addChild(light)
      ed.layout.centerInParent(light)
      self.legendEquipUpdateReason = nil
    end
    if legendEquip and legendEquip._next_unequip_time then
      local serverTime = ed.getServerTime()
      local leftTime = legendEquip._next_unequip_time - serverTime
      if 0 < leftTime then
        self.ui.legend_equip_bind_bg:setVisible(true)
        local day = math.floor(leftTime / 86400)
        local hour = math.floor(leftTime % 86400 / 3600)
        local min = math.floor(leftTime % 3600 / 60)
        if 1 <= day then
          ed.setLabelString(self.ui.legend_equip_bind_time, string.format("%s\229\164\169%s\230\151\182\229\144\142\229\143\175\232\167\163\231\187\145", day, hour))
        else
          ed.setLabelString(self.ui.legend_equip_bind_time, string.format("%s\230\151\182%s\229\136\134\229\144\142\229\143\175\232\167\163\231\187\145", hour, min))
        end
      else
        self.ui.legend_equip_bind_bg:setVisible(false)
      end
    end
  end
end

function BaseDetail:createEquipIconByHero(hero, i, eid)
  local hid = hero._tid
  local ceid = hero._items[i]._item_id
  local frame, icon, light, level, exp
  if 0 < ceid then
    frame, icon = ed.readequip.createHeroItem(hid, i, nil, hero)
    level = ed.readequip.getEquipLevel(hid, i)
    exp = ed.readequip.getEquipExp(hid, i, hero)
  elseif 0 < eid then
    frame, icon = ed.readequip.createIcon(eid, nil, 1)
    ed.setSpriteGray(icon)
  else
    frame, icon, light = ed.readequip.getUnknownIcon()
    level = 0
  end
  local x, y = self.ui["frame_equip" .. i]:getPosition()
  frame:setPosition(x, y)
  self.ui["equip" .. i]:removeAllChildrenWithCleanup(true)
  self.ui["equip" .. i]:addChild(frame)
  self.ui["frame_equip" .. i] = frame
  self.equips[i] = {
    id = 0 < ceid and ceid or eid,
    frame = frame,
    icon = icon,
    level = level,
    exp = exp
  }
  self:createEquipTag(i)
  return frame, icon, light, level
end

function BaseDetail:doClickEquip(id)
  self.selectSlot = id
  local context = "herodetail"
  local isEquiped = self.equips[id].isEquiped
  local showUpgrade = false
  local config = {
    context = context,
    composeIcon = true,
    eid = self.equips[id].id,
    level = self.equips[id].level,
    titanEquipLevel = self.equips[id].exp,
    hid = self.hid,
    sid = id,
    isEquiped = isEquiped,
    showUpgrade = showUpgrade,
    callback = self:craftCallBack(),
    destroyCallback = self:refreshAfterEquip(),
    priority = -176
  }
  local craftLayer = ed.ui.equipcraft.create(config)
  self.craftLayer = craftLayer
  craftLayer:popWindow()
end

function BaseDetail:createEquipIcon(i)
  if not ed.player:isMyHero(self.hero) then
    self:createEquipIconByHero(self.hero, i)
    return
  end
  local eid = self:getEquipIdFromTb(self.hid, i)
  local frame, icon, light = self:createEquipIconByHero(self.hero, i, eid)
  self.controller:btRegisterButtonClick({
    button = icon,
    pressScale = 0.95,
    key = "equip_" .. i,
    clickHandler = function()
      self:doClickEquip(i)
    end,
    clickInterval = 0.5,
    force = true
  })
end

function BaseDetail:getAttChanged()
  local att = ed.readhero.getHeroAtt(self.hid)
  local patt = self.attInfo
  local clist = {}
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    if not att[k] then
      att[k] = {}
    end
    if not patt[k] then
      patt[k] = {}
    end
    local v = att[k]
    local pv = patt[k]
    local badd = (v.base or 0) - (pv.base or 0)
    local aadd = (v.add or 0) - (pv.add or 0)
    local add = badd + aadd
    if 0 < add then
      clist[k] = add
    end
  end
  self.attInfo = att
  return clist
end

function BaseDetail:playAttAdditionAnim(list)
  lsr:report("heroAttAnim")
  local index = 0
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    local v = list[k] or 0
    local attanimText = res.att_anim_name[k] or ""
    if type(v) == "number" and 0 < v then
      local label = ed.createNode({
        t = "Label",
        base = {
          text = attanimText .. "+" .. v,
          size = 20
        },
        layout = {
          position = ccp(200, 315)
        },
        config = {
          color = ccc3(0, 255, 0),
          stroke = {
            color = ccc3(0, 0, 0),
            size = 2
          },
          visible = false
        }
      }, self.ui.bg_equip)
      local delay = CCDelayTime:create(0.4 * index)
      local func = CCCallFunc:create(function()
        label:setVisible(true)
      end)
      local fade = CCFadeOut:create(0.8)
      local move = CCMoveTo:create(0.5, ccp(200, 365))
      label:runAction(ed.readaction.create({
        t = "seq",
        delay,
        func,
        {
          t = "sp",
          fade,
          move
        }
      }))
      index = index + 1
    end
  end
end

function BaseDetail:refreshElement()
  local posY = self.ui.bg_info:getPositionY() - self.ui.bg_info:getContentSize().height * 0.5 - 1
  local element = ed.getDataTable("Unit")[self.hid].Element
  if nil ~= element then
    ed.setTexture(self.ui.img_element_icon, string.format("UI/alpha/1080P/tag/Kael_%s.png", element))
    self.ui.bg_element_attr:setVisible(true)
    self.ui.bg_element_attr:setPositionY(posY - self.ui.bg_element_attr:getContentSize().height * 0.5)
    posY = posY - self.ui.bg_element_attr:getContentSize().height - 2
  else
    self.ui.bg_element_attr:setVisible(false)
  end
  self.ui.bg_attrlist:setPositionY(posY - self.ui.bg_attrlist:getContentSize().height * 0.5)
end

function BaseDetail:refreshAttr()
  self:playAttAdditionAnim(self:getAttChanged())
  local attrKeyList = {
    "HP",
    "AD",
    "AP",
    "ARM",
    "MR"
  }
  for index = 1, 5 do
    local parent = self.ui["num_attr" .. index]
    parent:removeAllChildrenWithCleanup(true)
    local attrLey = attrKeyList[index]
    local heroAttr = math.floor(self.attInfo[attrLey].all and self.attInfo[attrLey].all + 0.5 or 0)
    local awakeDungeonAttr
    if self.dungeonMgr:awakeDungeonIsOpen() and ed.storage.getBool("base_detail_dungeon_switch") then
      awakeDungeonAttr = math.floor(self.awakeDungeonAttrInfo[attrLey] and self.awakeDungeonAttrInfo[attrLey] + 0.5 or 0)
    end
    local attrAutoTextNode = self:createAttr(heroAttr, awakeDungeonAttr)
    parent:addChild(attrAutoTextNode)
    attrAutoTextNode:setPosition(ccp(-400, 7))
  end
end

function BaseDetail:createAttr(heroAttr, awakeDungeonAttr)
  local content = string.format("<lable color=ccc3(255,234,198) strokeColor=ccc3(41,27,27) strokeSize=1>%d</lable>", heroAttr)
  if awakeDungeonAttr and 0 < awakeDungeonAttr then
    content = content .. string.format("<lable color=ccc3(255,215,129) strokeColor=ccc3(120,65,35) strokeSize=1>+%d</lable>", awakeDungeonAttr)
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = content,
    fontSize = 15,
    align = "RIGHT"
  })
  return autoText.node
end

function BaseDetail:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local puppet, cha = ed.readhero.getActor(self.hid, "Idle", true, false, self.hero._fashion, false)
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

function BaseDetail:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self.controller:removeUpdateHandler("checkFcaHandler1")
    end
  end
  
  return handler
end

function BaseDetail:changeFcaAction(name, with_sound)
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
  self.controller:registerUpdateHandler("checkFcaHandler1", self:checkFcaHandler(action, duration))
end

function BaseDetail:playHeroCheer(isUpgrade)
  if self.cha then
    self:changeFcaAction("Cheer", not isUpgrade)
    if isUpgrade then
      local effect = ed.getUnitVoiceUpgrade(self.hid, self.hero._fashion)
      if effect then
        ed.playEffect(effect)
      end
    end
  end
end

function BaseDetail:wearEquips()
  lsr:report("equippingAnim")
  self:updateGs()
  self:refreshAttr()
  self:playHeroCheer()
  for k, v in ipairs(self.canWearSlot) do
    self:createEquipIcon(v)
  end
  for k, v in ipairs(self.canWearSlot) do
    local frame = self.equips[v].frame
    local spr = ed.createFcaNode("eff_UI_equipping")
    self.controller:addFca(spr)
    spr:setPosition(ed.getCenterPos(frame))
    frame:addChild(spr)
  end
  FireEvent("RefreshHeroRed", self.hid)
  self.canWearSlot = {}
end

function BaseDetail:wearEquip()
  lsr:report("equippingAnim")
  local id = self.selectSlot
  self:updateGs()
  self:createEquipIcon(id)
  local frame = self.equips[id].frame
  local spr = ed.createFcaNode("eff_UI_equipping")
  self.controller:addFca(spr)
  spr:setPosition(ed.getCenterPos(frame))
  frame:addChild(spr)
  self:refreshAttr()
  self:playHeroCheer()
  FireEvent("RefreshHeroRed", self.hid)
end

function BaseDetail:refreshUpgradeAnimHandler(node, items, hid)
  local function handler()
    local function showAnnounce()
      ed.announce({
        type = "heroUpgrade",
        
        param = {
          id = hid,
          preHero = self.heroBeforeUpgrade,
          handler = function()
            if 0 < #(items or {}) then
              ed.announce({
                type = "getProp",
                priority = -1,
                param = {
                  title = T("\232\163\133\229\164\135\233\153\132\233\173\148\232\191\148\232\191\152"),
                  items = items
                }
              })
            end
          end
        }
      })
      self.controller:removeUpdateHandler("refreshUpgradeAnim")
    end
    
    if tolua.isnull(self.mainLayer) then
      showAnnounce()
      return
    end
    if tolua.isnull(node) then
      showAnnounce()
      return
    end
    if node:isTerminated() then
      showAnnounce()
    end
  end
  
  return handler
end

function BaseDetail:canHeroUpgrade()
  local canUpgrade = ed.readhero.canUpgradeHeroWithId(self.hid, self.hero)
  self.canUpgrade = canUpgrade
  return canUpgrade
end

function BaseDetail:createEquipIcons()
  self.canWearSlot = {}
  self.canWearEquipId = {}
  for i = 1, 6 do
    self:createEquipIcon(i)
  end
end

function BaseDetail:upgradeReply()
  local function handler(result, items)
    if not self then
      return
    end
    if not result then
      ed.showToast(T("\232\191\155\233\152\182\229\164\177\232\180\165"))
    else
      lsr:report("upgradeReply")
      self:refreshAttr()
      self:createEquipIcons()
      self:createHeroName()
      self:refreshUpgradeButton()
      self:playEquipAnim()
      self:playHeroCheer(true)
      self:refreshLegendEquip()
      local rootPos = ccp(197, 165)
      local sprFront = ed.createFcaNode("eff_UI_hero_upgrade_2")
      sprFront:setPosition(rootPos)
      self.controller:addFca(sprFront)
      self.ui.bg_equip:addChild(sprFront, 11)
      self.controller:registerUpdateHandler("refreshUpgradeAnim", self:refreshUpgradeAnimHandler(sprFront, items, self.hid))
      self:updateGs()
      self:checkHeroUpgrade()
      FireEvent("RefreshHeroRed", self.hid)
    end
  end
  
  return handler
end

function BaseDetail:doUpgrade(isOneTime)
  lsr:report("clickUpgrade")
  ed.netreply.heroUpgradeReply = self:upgradeReply()
  self.heroBeforeUpgrade = ed.readhero.getHeroUpgradeInfo(self.hid)
  local msg = ed.upmsg.hero_upgrade()
  msg._hero_id = self.hid
  msg._is_one_time = "false"
  ed.send(msg, "hero_upgrade")
end

function BaseDetail:putonReply()
  local function handler(isSuccessful)
    if not self then
      return
    end
    if isSuccessful then
      self:wearEquips()
      self:refreshEquipTag()
      self:refreshUpgradeButton()
    end
  end
  
  return handler
end

function BaseDetail:putonEquip()
  if ed.netdata.putonReply then
    return
  end
  local equipIds = {}
  for k, v in ipairs(self.canWearSlot) do
    local ceid = self:getEquipIdFromTb(self.hid, v)
    table.insert(equipIds, ceid)
  end
  ed.netdata.putonReply = {
    hid = self.hid,
    sid = self.canWearSlot,
    eid = equipIds
  }
  ed.netreply.putonReply = self:putonReply()
  local msg = ed.upmsg.wear_equip()
  msg._hero_id = self.hid
  msg._item_pos = self.canWearSlot
  ed.send(msg, "wear_equip")
end

function BaseDetail:doClickUpgrade()
  if #self.canWearSlot > 0 then
    self:putonEquip()
    return
  end
  local text = T("\230\154\130\230\151\160\229\143\175\231\148\168\232\163\133\229\164\135")
  if self.hero._rank >= ed.parameter.unit_max_rank then
    text = T("\230\173\164\232\139\177\233\155\132\229\183\178\231\187\143\229\188\186\229\140\150\229\136\176\233\161\182\233\152\182")
  end
  if not self.canUpgrade then
    ed.showToast(text)
  else
    local showWarning = false
    local ifWearAWkEq = ed.readequip.checkIfWearAwakeEquip(self.hid)
    if ifWearAWkEq == false and ed.readequip.checkEquipEnchant(self.hid) then
      showWarning = true
    elseif ifWearAWkEq == true and ed.readequip.checkEquipEnchant(self.hid, 2) then
      showWarning = true
    end
    if showWarning then
      local temp = T("\230\152\175\229\144\166\231\161\174\229\174\154\232\166\129\232\191\155\233\152\182%s\239\188\159\n", ed.getDataTable("Unit")[self.hid]["Display Name"]) .. T("\232\191\155\233\152\182\229\144\142\230\173\164\232\139\177\233\155\132\231\154\132\232\163\133\229\164\135\233\153\132\233\173\148\230\149\136\230\158\156\229\176\134\230\182\136\229\164\177\239\188\140\229\185\182\232\191\148\232\191\152\228\184\128\233\131\168\229\136\134\233\153\132\233\173\148\230\157\144\230\150\153.")
      local info = {
        text = temp,
        leftText = T("\229\143\150\230\182\136"),
        rightText = T("\231\161\174\229\174\154"),
        rightHandler = function()
          self:doUpgrade()
        end
      }
      ed.showConfirmDialog(info)
    else
      self:doUpgrade()
    end
  end
end

function BaseDetail:playEquipAnim()
  local eIcons = {}
  local i = 1
  if not self.ui.bg_equip or tolua.isnull(self.ui.bg_equip) then
    return
  end
  
  local function addEquipIcon()
    local x, y = self.ui["equip" .. i]:getPosition()
    local hero = ed.getDataTable("hero_equip")[self.hid]
    local rak = hero[self.hero._rank - 1]
    local id = rak[string.format("Equip%d ID", i)]
    if id ~= 0 then
      local icon = ed.readequip.createIcon(id)
      if icon then
        icon:setPosition(ccp(x, y))
        self.ui.bg_equip:addChild(icon, 2)
        table.insert(eIcons, icon)
      end
    end
    i = i + 1
  end
  
  for k = 1, 6 do
    addEquipIcon()
  end
  ListenTimer(Timer:Once(0.5), function()
    for i = 1, #eIcons do
      local icon = eIcons[i]
      if not tolua.isnull(icon) then
        icon:runAction(ed.readaction.create({
          t = "seq",
          CCDelayTime:create(0.1 * (i - 1)),
          ed.readaction.create({
            t = "sp",
            CCEaseSineOut:create(CCMoveTo:create(0.5, ccp(200, 185))),
            CCFadeTo:create(0.5, 50),
            CCScaleTo:create(0.5, 0.5)
          }),
          CCCallFunc:create(function()
            xpcall(function()
              if not tolua.isnull(icon) then
                icon:removeFromParentAndCleanup(true)
              end
            end, EDDebug)
          end)
        }))
      end
    end
  end)
end

function BaseDetail:refreshEvolveAnimHandler(node)
  local id = self.hid
  
  local function handler()
    local function showAnnounce()
      ed.announce({
        type = "heroEvolve",
        
        param = {
          id = id,
          preAtt = self.attBeforeEvolve
        }
      })
      self.controller:removeUpdateHandler("refreshEvolveAnim")
    end
    
    if tolua.isnull(self.mainLayer) then
      showAnnounce()
      return
    end
    if tolua.isnull(node) then
      showAnnounce()
      return
    end
    if node:isTerminated() then
      showAnnounce()
    end
  end
  
  return handler
end

function BaseDetail:doEvolveRefresh()
  self:refreshHeroStars()
  self:refreshStoneBar()
end

function BaseDetail:refreshEquipTag()
  self:createEquipTags()
  self:checkHeroUpgrade()
end

function BaseDetail:craftCallBack()
  local function handler(instruction)
    xpcall(function()
      if tolua.isnull(self.mainLayer) then
        return
      end
      if instruction == "equip" then
        self:wearEquip()
        self:refreshEquipTag()
      elseif instruction == "update" then
        self:createEquipIcons()
        self:refreshEquipTag()
      end
    end, EDDebug)
  end
  
  return handler
end

function BaseDetail:doEvolveReply()
  local function handler(result)
    if not result then
      ed.showToast(T("\232\139\177\233\155\132\232\191\155\229\140\150\229\164\177\232\180\165"))
    else
      lsr:report("evolveReply")
      self:refreshEquipTag()
      self:refreshAttr()
      self:doEvolveRefresh()
      self:playHeroCheer()
      self:refreshLegendEquip()
      local rootPos = ccp(203, 165)
      lsr:report("evolveAnim")
      local sprFront = ed.createFcaNode("eff_UI_hero_starup_1")
      sprFront:setPosition(rootPos)
      self.controller:addFca(sprFront)
      self.ui.bg_equip:addChild(sprFront, 11)
      self.controller:registerUpdateHandler("refreshEvolveAnim", self:refreshEvolveAnimHandler(sprFront))
      self:updateGs()
      self.ui.evolve_redlight:setVisible(ed.readhero.canEvolve(self.hid))
      FireEvent("RefreshHeroRed", self.hid)
    end
  end
  
  return handler
end

function BaseDetail:doEvolveHandler(cost, stoneAmount)
  local function handler()
    if cost > ed.player._money then
      ed.showHandyDialog("useMidas")
      
      return
    end
    ed.netdata.evolve = {
      hid = self.hid,
      id = ed.readhero.getStoneid(self.hid),
      amount = stoneAmount,
      cost = cost
    }
    ed.netreply.evolve = self:doEvolveReply()
    self.attBeforeEvolve = ed.readhero.getHeroAtt(self.hid)
    ed.ui.heroDetailEvolveWin.create({
      hero = self.hero,
      callback = function()
        local msg = ed.upmsg.hero_evolve()
        msg._heroid = self.hid
        ed.send(msg, "hero_evolve")
      end
    })
  end
  
  return handler
end

function BaseDetail:doClickEvolve()
  lsr:report("clickEvolve")
  if ed.readhero.canEvolve(self.hid) then
    local sn = ed.getDataTable("HeroStars")[self.hero._stars + 1]["Upgrade Fragments"]
    local cost = ed.heroDetailManager:getHeroEvolveCost(self.hid)
    self:doEvolveHandler(cost, sn)()
  else
    ed.ui.PackageSourceWin.create({
      id = ed.readhero.getStoneid(self.hid)
    })
    return
  end
end

function BaseDetail:createGsNum()
  local numgs = ed.getNumberNode({
    text = self.hero._gs,
    folder = "hero_gs",
    padding = -1
  }).node
  self.pregs = self.hero._gs
  numgs:setPosition(ccp(230.5, 29.25))
  self.ui.num_gs:removeFromParentAndCleanup(true)
  self.ui.num_gs = numgs
  self.ui.bg_gs:addChild(numgs)
end

function BaseDetail:refreshUpgradeButton()
  local ui = self.ui
  if self.hero._rank < ed.parameter.unit_max_rank then
    ui.btn_up:setVisible(true)
  elseif self.hero._rank == ed.parameter.unit_max_rank then
    for i = 1, 6 do
      local ceid = ed.player.heroes[self.hid]:getEquipid(i)
      if ceid == 0 then
        ui.btn_up:setVisible(true)
        return
      end
    end
    ui.btn_up:setVisible(false)
  else
    ui.btn_up:setVisible(false)
  end
end

function BaseDetail:refreshAwakeDungeonButton()
  local dungeonIsOpen = self.dungeonMgr:awakeDungeonIsOpen()
  self.ui.dungeon_switch_bg:setVisible(dungeonIsOpen)
  local switchIsOpen = ed.storage.getBool("base_detail_dungeon_switch")
  if switchIsOpen then
    ed.setTexture(self.ui.dungeon_switch_bg, "UI/alpha/1080P/dungeon/dungeon_info_button_on.png")
    self.ui.dungeon_switch:setPosition(ccp(48, 15))
  else
    ed.setTexture(self.ui.dungeon_switch_bg, "UI/alpha/1080P/dungeon/dungeon_info_button_off.png")
    self.ui.dungeon_switch:setPosition(ccp(15, 15))
  end
  local switchIsOpen = ed.storage.getBool("base_detail_dungeon_switch")
  if dungeonIsOpen and switchIsOpen then
    ed.setLabelString(self.ui.label_info, T("\231\167\145\230\138\128\229\177\158\230\128\167"))
  else
    ed.setLabelString(self.ui.label_info, T("\228\186\186\231\137\169\229\177\158\230\128\167"))
  end
  self.ui.label_info:limitWidthByScale(80)
end

function BaseDetail:checkHeroUpgrade()
  if self:canHeroUpgrade() then
    ed.setString(self.ui.label_up, T("\232\191\155 \233\152\182"))
    FireEvent(ed.guide.eventNames.HERO_CAN_INCREASE_RANK)
  else
    ed.setString(self.ui.label_up, T("\228\184\128\233\148\174\232\163\133\229\164\135"))
  end
  self.ui.label_up:limitWidthByScale(85)
  self.ui.up_redlight:setVisible(self.canUpgrade)
end

function BaseDetail:refreshUI()
  self:createCard()
  self:createHeroName()
  self:refreshHeroStars()
  self:createHeroFca()
  self:refreshAttr()
  self:refreshElement()
  self:createEquipIcons()
  self:createGsNum()
  self:refreshExpBar()
  self:refreshStoneBar()
  self:refreshUpgradeButton()
  self:refreshAwakeDungeonButton()
  self:refreshPetIcon()
  ed.setString(self.ui.label_level, T("\231\173\137\231\186\167%d", self.hero._level))
  self.ui.icon_collect:setVisible(self.isCollect)
  self.ui.icon_uncollect:setVisible(not self.isCollect)
  self:checkHeroUpgrade()
  self.ui.evolve_redlight:setVisible(ed.readhero.canEvolve(self.hid))
  ed.setTexture(self.ui.icon_type, ed.readhero.getTypeRes(self.hid))
  self:createShardIcon()
  self:createAstrolabeIcon()
  self:refreshPetIcon()
  self:refreshLegendEquip()
end

function BaseDetail:refreshPetIcon()
  if self.hero._pet then
    self.ui.bg_pet:setVisible(true)
    local petIcon = ed.readpet.createIcon({
      type = self.hero._pet._type_id
    }).icon
    petIcon:setScale(0.52)
    ed.UITool.replaceUINew(self.ui, "icon_pet", petIcon)
    ed.setLabelStroke(self.ui.pet_level, ccc3(0, 0, 0), 1)
    ed.setString(self.ui.pet_level, self.hero._pet._level)
  else
    self.ui.bg_pet:setVisible(false)
  end
end

function BaseDetail:initHeroInfo(hero)
  self.hero = hero
  self.equipState = {}
  self.equips = {}
  self.hid = self.hero._tid
  self.attInfo = ed.readhero.getHeroAttByHero(self.hero)
  self.dungeonMgr = ed.awakeDungeonMgr:getInstance()
  self.awakeDungeonAttrInfo = ed.heroDetailManager:getDisPlayAwakeStageBonus(self.hid, {
    level = self.dungeonMgr:getParagonLevel(),
    maxLevel = self.dungeonMgr:getMaxParagonLevel(),
    groupId = self.dungeonMgr:getLevelGroup()
  })
  self.isCollect = false
  for k, v in ipairs(ed.player:getCollectList()) do
    if v == self.hid then
      self.isCollect = true
    end
  end
  self:canHeroUpgrade()
end

function BaseDetail:refreshData(hero)
  self:initHeroInfo(hero)
end

function BaseDetail:refreshAfterEquip(hero)
  self:refreshData(self.hero)
  self:createEquipIcons()
  self:createGsNum()
  self:refreshAttr()
  self:refreshUpgradeButton()
  self:checkHeroUpgrade()
  self.ui.evolve_redlight:setVisible(ed.readhero.canEvolve(self.hid))
end

function BaseDetail:initData(param)
  self.controller = param.controller
  self.pos = param.pos
  self:initHeroInfo(param.hero)
end

function BaseDetail:initUI()
  local container, ui = ed.editorui(ed.uieditor.herodetailNormal, {
    ui = self.controller.ui
  })
  self.container = container
  self.ui = ui
  self.ui.layer_normal:setPosition(self.pos)
  self.ui.bg_gsadd:setCascadeOpacityEnabled(true)
  self.ui.bg_gsadd:setVisible(false)
  self.ui.num_gs:setPositionY(self.ui.num_gs:getPositionY() - 1.5)
  self:adaptUI()
  self:initLabels()
  self:createExpBar()
  self:createStoneBar()
  self:refreshUI()
  self.mainLayer = container
  if self.controller.isOpenLegendEquip then
    self:onClickLegendEquip()
    self.controller.isOpenLegendEquip = false
  end
end

function BaseDetail:doDelCollectReply()
  ed.showToast(T("\228\189\160\229\143\150\230\182\136\231\189\174\233\161\182\228\186\134\232\175\165\232\139\177\233\155\132\239\188\129"))
  local heroids = {
    self.hid
  }
  ed.player:delCollect(heroids)
  self.isCollect = false
  self.ui.icon_collect:setVisible(self.isCollect)
  self.ui.icon_uncollect:setVisible(not self.isCollect)
end

function BaseDetail:doAddCollectReply()
  ed.showToast(T("\228\189\160\231\189\174\233\161\182\228\186\134\232\175\165\232\139\177\233\155\132\239\188\129"))
  local heroids = {
    self.hid
  }
  ed.player:addCollect(heroids)
  self.isCollect = true
  self.ui.icon_collect:setVisible(self.isCollect)
  self.ui.icon_uncollect:setVisible(not self.isCollect)
end

function BaseDetail:canRefreshEquipboard()
  for i = 1, 6 do
    if self.equipState[i] == "cannotwear" and self:getHeroEquipState(self.hid, i) == "canWear" then
      return true
    end
  end
  return false
end

function BaseDetail:onClickDungeonSwitch()
  local switchIsOpen = ed.storage.getBool("base_detail_dungeon_switch")
  switchIsOpen = not switchIsOpen
  if switchIsOpen then
    ed.setTexture(self.ui.dungeon_switch_bg, "UI/alpha/1080P/dungeon/dungeon_info_button_on.png")
    self.ui.dungeon_switch:runAction(CCMoveTo:create(0.2, ccp(48, 15)))
    ed.showToast(T("\229\183\178\230\152\190\231\164\186\231\159\174\228\186\186\231\167\145\230\138\128\229\177\158\230\128\167\229\138\160\230\136\144"))
  else
    ed.setTexture(self.ui.dungeon_switch_bg, "UI/alpha/1080P/dungeon/dungeon_info_button_off.png")
    self.ui.dungeon_switch:runAction(CCMoveTo:create(0.2, ccp(15, 15)))
  end
  ed.setLabelString(self.ui.label_info, switchIsOpen and T("\231\167\145\230\138\128\229\177\158\230\128\167") or T("\228\186\186\231\137\169\229\177\158\230\128\167"))
  self.ui.label_info:limitWidthByScale(80)
  ed.storage.setValue("base_detail_dungeon_switch", switchIsOpen)
  self:refreshAttr()
end

function BaseDetail:createShardIcon()
  local shard = self.hero._shard or {}
  if self.shardEquipBg then
    self.shardEquipBg:removeFromParentAndCleanup(true)
    self.shardEquipBg = nil
  end
  if shard and shard._level and shard._id and shard._level > 0 then
    local res
    for _, v in pairs(ed.getDataTable("ShardToHero")) do
      if shard._id == v["Shard ID"] and v["Hero ID"] == self.hid then
        res = v.Icon
      end
    end
    if not res then
      return
    end
    local shardEquipBg = ed.createSprite("UI/alpha/1080P/shard/shard_frame.png")
    shardEquipBg:setPosition(242, 18)
    self.ui.frame_name:addChild(shardEquipBg)
    local shardEquip = ed.createSprite(res)
    local size = shardEquipBg:getContentSize()
    shardEquip:setPosition(size.width / 2, size.height / 2)
    shardEquipBg:addChild(shardEquip)
    local labelBg = ed.createSprite("UI/alpha/1080P/skill/skill_rank_2.png")
    labelBg:setPosition(size.width / 2, 7)
    shardEquipBg:addChild(labelBg)
    labelBg:setScale(0.66)
    local label = ed.createttf(shard._level, 16)
    label:setPosition(size.width / 2, 7)
    label:setColor(ccc3(254, 255, 170))
    shardEquipBg:addChild(label)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
    self.shardEquipBg = shardEquipBg
  end
end

function BaseDetail:createAstrolabeIcon()
  local astrolabe = self.hero._astrolabe or {}
  if self.astrolabeEquipBg then
    self.astrolabeEquipBg:removeFromParentAndCleanup(true)
    self.astrolabeEquipBg = nil
  end
  if astrolabe and astrolabe._level then
    local res = ed.getDataTable("Astrolabe")[self.hid].Icon
    if not res then
      return
    end
    local astrolabeEquipBg = ed.createSprite("UI/alpha/1080P/shard/shard_frame.png")
    astrolabeEquipBg:setPosition(-30, 18)
    self.ui.frame_name:addChild(astrolabeEquipBg)
    local shardEquip = ed.createSprite(res)
    local size = astrolabeEquipBg:getContentSize()
    shardEquip:setPosition(size.width / 2, size.height / 2)
    astrolabeEquipBg:addChild(shardEquip)
    local labelBg = ed.createSprite("UI/alpha/1080P/skill/skill_rank_2.png")
    labelBg:setPosition(size.width / 2, 7)
    astrolabeEquipBg:addChild(labelBg)
    labelBg:setScale(0.66)
    local label = ed.createttf(astrolabe._level, 16)
    label:setPosition(size.width / 2, 7)
    label:setColor(ccc3(254, 255, 170))
    astrolabeEquipBg:addChild(label)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
    self.astrolabeEquipBg = astrolabeEquipBg
  end
end

function BaseDetail:popHeroUpgradeWindow()
  lsr:report("openUpgradeWindow")
  
  local function callback(heroLevel)
    ed.setString(self.ui.label_level, T("\231\173\137\231\186\167%d", self.hero._level))
    self:refreshExpBar()
    if heroLevel < self.hero._level then
      if self:canRefreshEquipboard() then
        self:createEquipIcons()
      end
      self:refreshAttr()
      self:playHeroCheer()
      self:updateGs()
      self:refreshLegendEquip()
    end
  end
  
  for i = 1, 6 do
    self.equipState[i] = self:getHeroEquipState(self.hid, i)
  end
  ed.ui.upgradewindow.create(self.hid, self.hero._level, callback):popWindow()
end

function BaseDetail:onClickLegendEquip()
  local heroLegendEquip = self.hero._legend_equip
  local legendEquipAmount = ed.legendEquipMgr.getInstance():getLegendEquipAmount()
  if self.legendEquipState == "lock" then
    ed.showToast(T("\232\139\177\233\155\132\232\190\190\229\136\17680\231\186\167\239\188\140\231\180\171+2\233\152\182\229\144\142\229\143\175\231\169\191\230\136\180\228\188\160\229\165\135\232\163\133\229\164\135"))
  elseif legendEquipAmount == 0 then
    ed.UITool.openView("legendEquipGetWayWindow")
  elseif self.legendEquipState == "canWear" or self.legendEquipState == "notHave" then
    ed.UITool.openView("legendEquipSelectWindow", {
      heroId = self.hid
    })
  elseif heroLegendEquip and heroLegendEquip._equip then
    ed.UITool.openView("legendEquipWindow", {
      legendEquip = heroLegendEquip._equip
    })
  end
end

function BaseDetail:onUpdateHeroLegendEquip(heroId, reason)
  if heroId ~= self.hid then
    return
  end
  self.legendEquipUpdateReason = reason
  self:updateGs()
  self:refreshUI()
end

function BaseDetail:registerTouchHandlers()
  ed.UITool.registerBtn(self.controller, "btn_levelup", function()
    self:popHeroUpgradeWindow()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self.controller, "btn_evolve", function()
    self:doClickEvolve()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self.controller, "btn_info", function()
    ed.ui.heroDetailAttrWin.create({
      hero = self.hero,
      awakeDungeonAttrInfo = self.awakeDungeonAttrInfo
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self.controller, "btn_up", function()
    self:doClickUpgrade()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self.controller, "icon_collect", function()
    local msg = ed.upmsg.herohot()
    msg._fav_del = ed.upmsg.hh_fav_add()
    msg._fav_del._heroids = {
      self.hid
    }
    ed.send(msg, "herohot")
  end, {})
  ed.UITool.registerBtn(self.controller, "icon_uncollect", function()
    local msg = ed.upmsg.herohot()
    msg._fav_add = ed.upmsg.hh_fav_add()
    msg._fav_add._heroids = {
      self.hid
    }
    ed.send(msg, "herohot")
  end, {})
  ed.UITool.registerBtn(self.controller, "bg_pet", function()
    if self.hero._pet then
      ed.ui.petAttrWin.create({
        pet = ed.player:getPet(self.hero._pet._id)
      })
    end
  end, {})
  ed.UITool.registerBtn(self.controller, "dungeon_switch_bg", function()
    self:onClickDungeonSwitch()
  end, {pressScale = 0.98})
  self.controller:btRegisterRectClick({
    rect = CCRectMake(130, 145, 165, 175),
    parent = self.ui.bg_equip,
    key = "hero_touch",
    clickHandler = function()
      if self.controller.tabIndex == 1 then
        self:changeFcaAction()
      end
    end,
    force = true
  })
  ed.UITool.registerBtn(self.controller, "legend_equip_icon", function()
    self:onClickLegendEquip()
  end)
end

function BaseDetail:registerEvents()
  self.controller:listenEvent("RefreshHeroRed", function()
    self:refreshStoneBar()
  end)
  self.controller:listenEvent("hh_fav_del_reply", function(info)
    self:doDelCollectReply(info)
  end)
  self.controller:listenEvent("hh_fav_add_reply", function(info)
    self:doAddCollectReply(info)
  end)
  self.controller:listenEvent("UpdateHeroLegendEquip", function(heroId, reason)
    self:onUpdateHeroLegendEquip(heroId, reason)
  end)
end

function BaseDetail:destroy()
  ed.netreply.heroUpgradeReply = nil
end

function BaseDetail.create(param)
  local self = {}
  setmetatable(self, {__index = BaseDetail})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
