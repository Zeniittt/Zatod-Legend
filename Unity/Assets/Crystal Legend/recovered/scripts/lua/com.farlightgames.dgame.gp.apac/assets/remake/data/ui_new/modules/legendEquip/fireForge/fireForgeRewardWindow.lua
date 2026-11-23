local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForgeRewardWindow = class
ed.UITool.registViewOpenFunc("fireForgeRewardWindow", function(params)
  params = params or {}
  local rewards = params.rewards or {}
  local realRewardList = {}
  local specialRewardId = ed.getDataTable("LegendEquipForgeParam")["Forge Produce"]["Param Content 1"]
  local specialRewardAmount = 0
  for index, reward in ipairs(rewards) do
    if reward._id == specialRewardId then
      specialRewardAmount = specialRewardAmount + reward._amount
    else
      table.insert(realRewardList, reward)
    end
  end
  params.rewards = realRewardList
  params.specialRewardAmount = specialRewardAmount
  local window = ed.ui.fireForgeRewardWindow.create(params)
  window:popWindow()
end)

function class.create(params)
  local self = base.create("fireForgeRewardWindow", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData(params or {})
  self:initView()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  return self
end

function class:initData(params)
  self.rewards = params.rewards or {}
  self.specialRewardAmount = params.specialRewardAmount or 0
  self.callback = params.callback
  self.noTips = params.noTips
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_reward_window)
  self.ui = ui
  self.container:addChild(container)
  self:adaptUI()
  self:initTips()
  self:initLabels()
  self:initRewardsView()
end

function class:adaptUI()
  self.col = 5
  local itemSize = CCSizeMake(200, 180)
  self.itemSize = itemSize
  local spaceSize = CCSizeMake(-50, 0)
  self.spaceSize = spaceSize
  local rewardsLen = #self.rewards
  local w, h = itemSize.width + spaceSize.width, itemSize.height + spaceSize.height
  local realCol = math.min(self.col, rewardsLen)
  local totalSize = CCSizeMake(realCol * itemSize.width + (realCol - 1) * spaceSize.width, h * math.ceil(rewardsLen / 5))
  self.totalSize = totalSize
  local oldHeight = self.ui.bg:getContentSize().height
  local oldWidth = self.ui.bg:getContentSize().width
  if 5 < #self.rewards then
    local newHeight = 459
    self.ui.bg:setContentSize(CCSizeMake(oldWidth, newHeight))
    local diffHeight = newHeight - oldHeight
    self.ui.image_title:setPositionY(self.ui.image_title:getPositionY() + diffHeight)
    self.ui.panel_tips:setPositionY(self.ui.panel_tips:getPositionY() + diffHeight)
    self.ui.btn_confirm:setPositionY(self.ui.btn_confirm:getPositionY() - diffHeight)
    ed.UITool.setPositionBy(self.ui.bg, ccp(0, -diffHeight * 0.5))
    local oldPanelSize = self.ui.panel_content:getContentSize()
    self.ui.panel_content:setContentSize(CCSizeMake(oldPanelSize.width, oldPanelSize.height + diffHeight))
    ed.UITool.setPositionBy(self.ui.panel_content, ccp(0, -diffHeight))
  else
    local newWidth = totalSize.width
    local oldPanelSize = self.ui.panel_content:getContentSize()
    self.ui.panel_content:setContentSize(CCSizeMake(newWidth, oldPanelSize.height))
    self.ui.panel_content:setPositionX(self.ui.panel_content:getPositionX() + (oldPanelSize.width - newWidth) / 2)
  end
end

function class:initLabels()
  local label_confirm = ed.ui.gradientLabel.create({
    text = T("\231\161\174\229\174\154"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_confirm:addChild(label_confirm.node)
  local btnSize = self.ui.btn_confirm:getContentSize()
  label_confirm.node:setPosition(ccp(btnSize.width / 2, btnSize.height / 2))
end

function class:initTips()
  if self.noTips then
    return
  end
  if not self.specialRewardAmount or self.specialRewardAmount == 0 then
    return
  end
  local panelSize = self.ui.panel_tips:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format("\233\148\187\233\128\160\230\136\144\229\138\159%s\230\172\161\239\188\140\233\162\157\229\164\150\232\142\183\229\190\151<sprite src=UI/alpha/1080P/fireforge/art3.png>\231\165\158\231\129\171\228\189\153\231\131\172*%s", #self.rewards, self.specialRewardAmount),
    color = ccc3(255, 230, 154),
    shadowColor = ccc3(0, 0, 0),
    shadowOffset = ccp(0, 1.5),
    fontSize = 15,
    maxWidth = panelSize.width
  })
  self.ui.panel_tips:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(panelSize.width / 2 - w / 2, panelSize.height / 2))
end

function class:initRewardsView()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_content, {
    priority = -300,
    doPressIn = function(x, y)
      for index, rewardItemCfg in ipairs(self.rewardItemList or {}) do
        local icon = rewardItemCfg.icon
        if icon and ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          return rewardItemCfg
        end
      end
    end,
    doClickIn = function(x, y, rewardItemCfg)
      local reward = rewardItemCfg.reward
      ed.UITool.openView("packageDetail", {
        id = reward._id,
        type = reward._type
      })
    end,
    cancelPressIn = function(x, y, rewardItemCfg)
      local icon = rewardItemCfg.icon
      if icon then
        icon:setScale(1)
      end
    end
  })
  self:updateRewardsList()
end

function class:updateRewardsList()
  local col = self.col
  local panelSize = self.ui.panel_content:getContentSize()
  local itemSize = self.itemSize
  local spaceSize = self.spaceSize
  local totalSize = self.totalSize
  local offsetX = (panelSize.width - self.totalSize.width) / 2
  local posX = 0
  local posY = 0
  self.rewardItemList = {}
  for index, reward in ipairs(self.rewards) do
    local item, equipType = self:createRewardItem(reward)
    item:setPosition(ccp(posX + itemSize.width / 2 + offsetX, panelSize.height - posY - itemSize.height / 2))
    self.dragList:addItem(item)
    posX = posX + itemSize.width * 0.95 + spaceSize.width
    table.insert(self.rewardItemList, {
      item = item,
      reward = reward,
      icon = item.icon,
      equipType = equipType
    })
    if index % col == 0 then
      posX = 0
      posY = posY + itemSize.height + spaceSize.height
    end
  end
  self.dragList:initListHeight(totalSize.height)
  self:showRewardAction()
end

function class:showRewardAction()
  if #self.rewardItemList > self.col then
    self.dragList:setListPos(ccp(0, 30))
  else
    self.dragList:setListPos(ccp(0, 10))
  end
  local totalDelayTime = 0
  local targetPos
  for index, rewardItemCfg in ipairs(self.rewardItemList) do
    local item = rewardItemCfg.item
    local icon = rewardItemCfg.icon
    local equipType = rewardItemCfg.equipType
    local light = item.light
    local light_2 = item.light_2
    local light_fragment_1 = item.light_fragment_1
    local lightParent = item.lightParent
    targetPos = self.container:convertToNodeSpace(ed.getWorldPos(item))
    if equipType == "only" then
      ed.playEffect(ed.sound.deo.fire_forge_surprise)
      item:setVisible(false)
      item:removeFromParentAndCleanup(false)
      self.container:addChild(item)
      ed.layout.centerInScreen(item)
      item:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCCallFunc:create(function()
        item:setVisible(true)
        light:setAction("Start")
        lightParent:setScale(2)
        lightParent:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.6666666666666666), CCScaleTo:create(0.4166666666666667, 1))))
        icon:setScale(3.5)
        icon:setCascadeOpacityEnabled(true)
        icon:setOpacity(0)
        icon:runAction(CCSequence:create(ccArrayMake(CCSpawn:create(ccArrayMake(CCScaleTo:create(0.16666666666666666, 1.36), CCFadeTo:create(0.16666666666666666, 255))), CCScaleTo:create(0.20833333333333334, 1.5), CCDelayTime:create(0.20833333333333334), CCScaleTo:create(0.4166666666666667, 1))))
      end), CCDelayTime:create(0.6666666666666666), CCEaseIn:create(CCMoveTo:create(0.4166666666666667, ccpAdd(targetPos, ccp(0, self.itemSize.height * math.floor((index - 1) / self.col)))), 4), CCCallFunc:create(function()
        local worldPos = ed.getWorldPos(item)
        item:removeFromParentAndCleanup(false)
        self.dragList.listLayer:addChild(item)
        item:setPosition(self.dragList.listLayer:convertToNodeSpace(worldPos))
      end))))
      totalDelayTime = totalDelayTime + 1.2916666666666667
    elseif equipType == "normal" then
      light:setAction("Start")
      item:setVisible(false)
      item:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCCallFunc:create(function()
        item:setVisible(true)
        icon:setCascadeOpacityEnabled(true)
        icon:setOpacity(0)
        local delay = CCDelayTime:create(0.20833333333333334)
        local fade = CCFadeTo:create(0.3333333333333333, 255)
        icon:runAction(CCSequence:create(ccArrayMake(delay, fade)))
      end))))
      totalDelayTime = totalDelayTime + 0.5833333333333334
    elseif equipType == "equip_fragment" then
      local fragmentParent = item.fragmentParent
      local fragment_label = item.fragment_label
      local item_icon = item.icon
      local fragment_icon = item.fragment_icon
      item:setVisible(false)
      item:removeFromParentAndCleanup(false)
      self.container:addChild(item)
      ed.layout.centerInScreen(item)
      fragmentParent:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCDelayTime:create(0.7916666666666666), CCCallFunc:create(function()
        light_fragment_1:setPosition(0, 3)
        light_fragment_1:setVisible(true)
        self:addFca(light_fragment_1)
      end), CCDelayTime:create(0.2916666666666667), CCCallFunc:create(function()
        item_icon:setVisible(false)
        fragment_icon:setScale(1.5)
        fragment_icon:setVisible(true)
        fragment_icon:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(1.125), CCScaleTo:create(0.5, 1))))
        fragment_label.node:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.041666666666666664), CCFadeTo:create(0.125, 255))))
        fragment_label.node:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(1), CCFadeTo:create(0.125, 0))))
      end), CCDelayTime:create(1.375), CCCallFunc:create(function()
        light_fragment_1:setVisible(false)
      end))))
      item:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCCallFunc:create(function()
        item:setVisible(true)
        light:setAction("Start")
        lightParent:setScale(2)
        lightParent:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(2.1666666666666665), CCScaleTo:create(0.4166666666666667, 1))))
        item_icon:setScale(3.5)
        item_icon:setCascadeOpacityEnabled(true)
        item_icon:setOpacity(0)
        item_icon:runAction(CCSequence:create(ccArrayMake(CCSpawn:create(ccArrayMake(CCScaleTo:create(0.16666666666666666, 1.36), CCFadeTo:create(0.16666666666666666, 255))), CCScaleTo:create(0.20833333333333334, 1.5))))
      end), CCDelayTime:create(2.1666666666666665), CCEaseIn:create(CCMoveTo:create(0.4166666666666667, ccpAdd(targetPos, ccp(0, self.itemSize.height * math.floor((index - 1) / self.col)))), 4), CCCallFunc:create(function()
        local worldPos = ed.getWorldPos(item)
        item:removeFromParentAndCleanup(false)
        self.dragList.listLayer:addChild(item)
        item:setPosition(self.dragList.listLayer:convertToNodeSpace(worldPos))
      end))))
      totalDelayTime = totalDelayTime + 2.6666666666666665
    else
      icon:setCascadeOpacityEnabled(true)
      icon:setOpacity(0)
      local delay = CCDelayTime:create(0.1 + totalDelayTime)
      local fade = CCFadeTo:create(0.2, 255)
      icon:runAction(CCSequence:create(ccArrayMake(delay, fade)))
      totalDelayTime = totalDelayTime + 0.3
    end
    if 1 < index and index < #self.rewardItemList and index % self.col == 0 then
      local delayAction = CCDelayTime:create(totalDelayTime)
      local actionMove = CCMoveBy:create(0.2, ccp(0, self.itemSize.height))
      self.dragList.listLayer:runAction(CCSequence:create(ccArrayMake(delayAction, actionMove)))
    end
  end
  self.ui.btn_confirm:setVisible(false)
  self.dragList:setTouchEnabled(false)
  self.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCCallFunc:create(function()
    self.actionEnd = true
    self.dragList:setTouchEnabled(true)
    self.ui.btn_confirm:setVisible(true)
  end))))
end

function class:createRewardItem(reward)
  local id = reward._id
  local type = reward._type or "item"
  local amount = reward._amount
  local bg = ed.createSprite()
  bg:setContentSize(self.itemSize)
  local icon, equipType
  if type == "legend_equip" then
    icon = ed.readequip.createBasicLegendEquipIcon(id)
    local legendEquipCfg = ed.getDataTable("LegendEquip")[id]
    local labelName = ed.createttf(legendEquipCfg["Equip Name"], 16)
    icon:addChild(labelName)
    ed.setLabelColor(labelName, ed.toccc3(16748591))
    ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
    labelName:setPosition(ccp(45, -10))
    ed.adaptLabel(labelName, {maxWidth = 120, minScale = 0.8})
    local isOnly = legendEquipCfg["Is Only"]
    if isOnly then
      equipType = "only"
      local imageOnlyTag = ed.createSprite("UI/alpha/1080P/legendequip/onlyequip_board2.png")
      icon:addChild(imageOnlyTag)
      imageOnlyTag:setPosition(ccp(45, 95))
      local onlyTag = ed.ui.gradientLabel.create({
        text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
        fontSize = 13,
        startColor = ed.toccc3(16777215),
        endColor = ed.toccc3(16776069)
      })
      imageOnlyTag:addChild(onlyTag.node)
      imageOnlyTag:setCascadeOpacityEnabled(true)
      ed.layout.centerInParent(onlyTag.node)
      imageOnlyTag:setScale(0.85)
      local lightParent = ed.createSprite()
      local light = ed.createFcaNode("eff_UI_legendequip_Get_light2")
      lightParent:addChild(light)
      self:addFca(light)
      bg:addChild(lightParent, -1)
      ed.layout.centerInParent(lightParent)
      local light_2 = ed.createFcaNode("eff_UI_legendequip_Get_light2_1")
      self:addFca(light_2)
      bg:addChild(light_2, 2)
      ed.layout.centerInParent(light_2)
      bg.light = light
      bg.light_2 = light_2
      bg.lightParent = lightParent
    else
      equipType = "normal"
      local lightParent = ed.createSprite()
      local light = ed.createFcaNode("eff_UI_legendequip_Get_light")
      lightParent:addChild(light)
      self:addFca(light)
      bg:addChild(lightParent, -1)
      ed.layout.centerInParent(lightParent)
      bg.light = light
      bg.lightParent = lightParent
    end
  elseif type == "item" then
    local convertState, equip_id = self:revertLegendEquip(reward._id, reward._amount)
    if convertState then
      equipType = "equip_fragment"
      id = equip_id
      icon = ed.readequip.createBasicLegendEquipIcon(id)
      local legendEquipCfg = ed.getDataTable("LegendEquip")[id]
      local labelName = ed.createttf(legendEquipCfg["Equip Name"], 16)
      icon:addChild(labelName)
      ed.setLabelColor(labelName, ed.toccc3(16748591))
      ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
      labelName:setPosition(ccp(45, -10))
      ed.adaptLabel(labelName, {maxWidth = 120, minScale = 0.8})
      local imageOnlyTag = ed.createSprite("UI/alpha/1080P/legendequip/onlyequip_board2.png")
      icon:addChild(imageOnlyTag)
      imageOnlyTag:setPosition(ccp(45, 95))
      local onlyTag = ed.ui.gradientLabel.create({
        text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
        fontSize = 13,
        startColor = ed.toccc3(16777215),
        endColor = ed.toccc3(16776069)
      })
      imageOnlyTag:addChild(onlyTag.node)
      imageOnlyTag:setCascadeOpacityEnabled(true)
      ed.layout.centerInParent(onlyTag.node)
      imageOnlyTag:setScale(0.85)
      local lightParent = ed.createSprite()
      local light = ed.createFcaNode("eff_UI_legendequip_Get_light3")
      lightParent:addChild(light)
      self:addFca(light)
      bg:addChild(lightParent, -1)
      ed.layout.centerInParent(lightParent)
      local fragmentParent = ed.createSprite()
      local light_fragment_1 = ed.createFcaNode("eff_UI_legendequip_Get_light3_1")
      fragmentParent:addChild(light_fragment_1)
      light_fragment_1:setVisible(false)
      bg:addChild(fragmentParent, 2)
      ed.layout.centerInParent(fragmentParent)
      local fragment_icon = ed.readequip.createIconWithAmount(reward._id, 90, reward._amount)
      local name = ed.lookupDataTable("equip", "Name", reward._id)
      if not ed.isAreaZh() then
        name = name:gsub("%(", [[

%(]], 1)
      end
      local labelName = ed.createttf(name, 16)
      ed.setLabelColor(labelName, ed.toccc3(16776423))
      ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
      labelName:setPosition(ccp(45, -10))
      ed.adaptLabel(labelName, {maxWidth = 120, minScale = 0.8})
      fragment_icon:addChild(labelName)
      bg:addChild(fragment_icon)
      ed.layout.centerInParent(fragment_icon)
      fragment_icon:setVisible(false)
      local content = string.format(T("\229\183\178\230\156\137%s,\232\189\172\229\140\150\228\184\186%s\228\184\170\231\162\142\231\137\135"), legendEquipCfg["Equip Name"], reward._amount)
      local fragment_label = ed.ui.gradientLabel.create({
        text = content,
        fontSize = 11,
        startColor = ed.toccc3(16777215),
        endColor = ed.toccc3(16776069)
      })
      fragment_icon:addChild(fragment_label.node)
      ed.layout.centerInParent(fragment_label.node)
      fragment_label:setPosition(ccp(45, -40))
      fragment_label.node:setOpacity(0)
      bg.light = light
      bg.fragmentParent = fragmentParent
      bg.light_fragment_1 = light_fragment_1
      bg.fragment_icon = fragment_icon
      bg.fragment_label = fragment_label
      bg.lightParent = lightParent
    else
      icon = ed.readequip.createIconWithAmount(id, 90, amount)
      local name = ed.lookupDataTable("equip", "Name", id)
      if not ed.isAreaZh() then
        name = name:gsub("%(", [[

%(]], 1)
      end
      local labelName = ed.createttf(name, 16)
      ed.setLabelColor(labelName, ed.toccc3(16776423))
      ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
      labelName:setPosition(ccp(45, -10))
      ed.adaptLabel(labelName, {maxWidth = 120, minScale = 0.8})
      icon:addChild(labelName)
    end
  end
  if icon then
    bg:addChild(icon)
    icon:setPosition(ccp(self.itemSize.width / 2, self.itemSize.height / 2))
  end
  bg.icon = icon
  return bg, equipType
end

function class:createRewardItem1(reward, isConvert)
  local item = CCLayer:create()
  item:setAnchorPoint(ccp(0.5, 0.5))
  item:ignoreAnchorPointForPosition(false)
  item:setContentSize(itemSize)
  local center = ccp(itemSize.width / 2, itemSize.height / 2)
  if reward.type == "item" then
    local icon = ed.readequip.createIconWithAmount(reward.id, itemSize.width, reward.amount)
    icon:setPosition(center.x, center.y + 10)
    item:addChild(icon)
    local name = ed.lookupDataTable("equip", "Name", reward.id)
    if not ed.isAreaZh() then
      name = name:gsub("%(", [[

%(]], 1)
    end
    local label = createItemName(name, ccp(center.x, -10))
    ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
    item:addChild(label, 1)
  elseif reward.type == "hero" then
    local starNum = ed.lookupDataTable("Unit", "Initial Stars", reward.id)
    if self.tabName == "normal" then
      local fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
      fca:setScale(0.5)
      local color = ed.ui.summonScene.QualityColors[starNum + 1] or "gold"
      fca:setStartAction("Start_" .. color)
      fca:setLoopAction("Loop_" .. color)
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca)
      if 3 <= starNum then
        fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
        fca:setScale(0.5)
        fca:setStartAction("Start_" .. color .. "_star")
        fca:setLoopAction("Loop_" .. color .. "_star")
        self:addFca(fca)
        fca:setPosition(center.x, 60)
        item:addChild(fca, 1)
      end
      local actor = ed.readhero.getActor(reward.id)
      actor:setContentSize(itemSize)
      actor:setPosition(center.x + 20, 40)
      local template = ed.lookupDataTable("Unit", nil, reward.id)
      local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
      actor:setScale(scale * 0.6)
      self:addFca(actor)
      item:addChild(actor)
      local name = ed.lookupDataTable("Unit", "Display Name", reward.id)
      local label = createItemName(name, ccp(center.x, -10))
      ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
      item:addChild(label)
      if isConvert then
        local num = ed.summonMgr:getFragmentNumByStar(starNum)
        item:addChild(createHeroStone(num, ccp(center.x, 10)), 1)
      else
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag)
      end
    elseif self.tabName == "destiny" then
      local fca = ed.createFcaNode("eff_UI_SummonDestiny_Light")
      fca:setScale(0.5)
      fca:setStartAction("Start_gold")
      fca:setLoopAction("Loop_gold")
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca)
      fca = ed.createFcaNode("eff_UI_SummonDestiny_Light")
      fca:setScale(0.5)
      fca:setStartAction("Start_gold_star")
      fca:setLoopAction("Loop_color_star")
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca, 1)
      local actor = ed.readhero.getActor(reward.id)
      actor:setContentSize(itemSize)
      actor:setPosition(center.x + 20, 40)
      local template = ed.lookupDataTable("Unit", nil, reward.id)
      local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
      actor:setScale(scale * 0.6)
      self:addFca(actor)
      item:addChild(actor)
      local name = ed.lookupDataTable("Unit", "Display Name", reward.id)
      local label = createItemName(name, ccp(center.x, -10))
      ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
      item:addChild(label)
      local sum = 90
      if isConvert and isConvert == 90 then
        item:addChild(createHeroStone(isConvert, ccp(center.x, 10)), 1)
      elseif isConvert and isConvert < 90 then
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag, 1)
        item:addChild(createHeroStone(isConvert, ccp(center.x, -30)), 1)
      else
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag)
      end
    elseif self.tabName == "timely" or self.tabName == "newbie" then
      local fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
      fca:setScale(0.5)
      local color = ed.ui.summonScene.QualityColors[starNum + 1] or "gold"
      fca:setStartAction("Start_" .. color)
      fca:setLoopAction("Loop_" .. color)
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca)
      if 3 <= starNum then
        fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
        fca:setScale(0.5)
        fca:setStartAction("Start_" .. color .. "_star")
        fca:setLoopAction("Loop_" .. color .. "_star")
        self:addFca(fca)
        fca:setPosition(center.x, 60)
        item:addChild(fca, 1)
      end
      local actor = ed.readhero.getActor(reward.id)
      actor:setContentSize(itemSize)
      actor:setPosition(center.x + 20, 40)
      local template = ed.lookupDataTable("Unit", nil, reward.id)
      local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
      actor:setScale(scale * 0.6)
      self:addFca(actor)
      item:addChild(actor)
      local name = ed.lookupDataTable("Unit", "Display Name", reward.id)
      local label = createItemName(name, ccp(center.x, -10))
      ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
      item:addChild(label)
      if isConvert then
        local num = ed.summonMgr:getFragmentNumByStar(starNum)
        item:addChild(createHeroStone(num, ccp(center.x, 10)), 1)
      else
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag)
      end
    end
  end
  return item
end

function class:revertLegendEquip(equipFragment_id, amount)
  local config = ed.getDataTable("LegendEquip")
  for i, v in pairs(config) do
    if v["Fragment Item"] == equipFragment_id and v["Fragment Amount"] == amount then
      return true, v["Equip ID"]
    end
  end
  return false, nil
end

function class:getGuideNode(nodeKey)
  if nodeKey == "btn_confirm" then
    return self.ui.btn_confirm
  end
  return base.getGuideNode(self, nodeKey)
end

function class:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      if self.actionEnd then
        self:destroy()
      end
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.83, normalScale = 0.88})
end

function class:onDestroy()
  if self.callback then
    self.callback()
  end
  if self.closeAction then
    self.closeAction()
  end
end
