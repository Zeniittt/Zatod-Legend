local SkillShard = newclass("g")
ed.ui.heroDetailScene.newShard = SkillShard

function SkillShard.create(param)
  local self = setmetatable({}, {__index = SkillShard})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  return self
end

function SkillShard:initData(param)
  self.controller = param.controller
  self.pos = param.pos
  self:refreshData(param.hero)
end

function SkillShard:initUI()
  self.skillDescNodes = {}
  local container, ui = ed.editorui(ed.uieditor.herodetailShard, {
    ui = self.controller.ui
  })
  self.mainLayer = container
  self.ui = ui
  local maxLevelLabel = ed.createttf(T("\229\183\178\232\190\190\229\136\176\230\156\128\229\164\167\231\173\137\231\186\167"), 20)
  ed.setLabelColor(maxLevelLabel, ccc3(242, 221, 191))
  ed.setLabelStroke(maxLevelLabel, ed.toccc3(7887680), 1.5)
  ed.setLabelStroke(self.ui.label_add_material1, ed.toccc3(2565412), 2)
  maxLevelLabel:setFontName(ed.fontBold)
  self.ui.img_lv_max:addChild(maxLevelLabel)
  maxLevelLabel:setPosition(ccp(126.75, 18))
  self:adaptUI()
  self.ui.layer_shard:setPosition(-30, -13)
  self:createFca()
  local thisCon = self.ui.panel_skil_txt:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_skil_txt,
    noshade = true,
    priority = -300,
    bar = {
      bgpos = ccp(thisCon.width - 1, thisCon.height / 2),
      barres = "UI/alpha/1080P/shard/skill_des_slide_1.png",
      bgres = "UI/alpha/1080P/shard/skill_des_slide_2.png",
      bgthick = 2,
      barthick = 2,
      alwaysShow = true
    }
  }
  self.skilDragList = ed.draglist.create(info)
  self:refreshUI(true)
end

function SkillShard:createFca()
  local arcanaLight = ed.createFcaNode("eff_UI_arcana_light")
  arcanaLight:setScale(2)
  arcanaLight:setPosition(ccp(209, 218))
  self.ui.ImageView_23548:addChild(arcanaLight)
  self.controller:addFca(arcanaLight)
  self.arcanaLight = arcanaLight
  local size = self.ui.ImageView_23548:getContentSize()
  local clipLayer = CCLayer:create()
  self.ui.ImageView_23548:addChild(clipLayer, 999)
  clipLayer:setClipRect(CCRectMake(0, 0, size.width, size.height))
  local equipUnlock = ed.createSpine("effect/eff_UI_Shard_EquipUnlock/eff_UI_Shard_EquipUnlock", 1)
  equipUnlock:setAnimation(0, "Idle", true)
  equipUnlock:setPosition(ccp(209, 218))
  clipLayer:addChild(equipUnlock, 999)
  self.equipUnlock = equipUnlock
  local equipUnlock2 = ed.createSpine("effect/eff_UI_Shard_EquipUnlock2/eff_UI_Shard_EquipUnlock2", 1)
  equipUnlock2:setAnimation(0, "Idle", false)
  equipUnlock2:setPosition(ccp(209, 218))
  clipLayer:addChild(equipUnlock2, 999)
  self.equipUnlock2 = equipUnlock2
  equipUnlock2:setVisible(false)
end

function SkillShard:refreshData(hero)
  self.heroInfo = hero
  self.heroInfo._tid = hero.data._tid
  self.heroData = ed.copyProto(self.heroInfo.data)
  if self.heroData._shard then
    self.newShardId = self.heroData._shard._id
    self.newShardLv = self.heroData._shard._level
  else
    local cfg = self.data.getHeroIsShard(self.heroInfo._tid) or {}
    self.newShardId = cfg["Shard ID"] or 0
    self.newShardLv = 0
  end
end

function SkillShard:refreshAll()
  local heroShardInfo = self.data.getHeroShardInfo(self.heroInfo._tid, self.newShardId) or {}
  self.ui.Label_23550:setString(heroShardInfo["Shard Name"] or "nil")
  self.ui.Label_23550:limitWidthByScale(200)
  ed.right2(self.ui.btn_rule, self.ui.Label_23552, 1)
  if self.shardIcon then
    self.shardIcon:removeFromParentAndCleanup(true)
  end
  local icon = ed.createSprite(heroShardInfo["Equip Icon"])
  icon:setPosition(ccp(205, 230))
  self.ui.ImageView_23548:addChild(icon, 5)
  
  local function runAct(time)
    icon:stopAllActions()
    local poxY = icon:getPositionY() >= 230 and math.random(7, 12) * -1 or math.random(7, 12)
    local pc = icon:getPositionY() - 230
    poxY = poxY - pc
    local poxX = icon:getPositionX() >= 205 and math.random(1, 3) * -1 or math.random(1, 3)
    pc = icon:getPositionX() - 205
    poxX = poxX - pc
    icon:runAction(CCSequence:create(ccArrayMake(CCMoveBy:create(time * 0.155, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.12, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.095, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.08, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.07, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.07, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.08, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.095, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.12, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.155, ccp(poxX * 0.1, poxY * 0.1)))))
    self.ui.ImageView_23548:stopAllActions()
    self.ui.ImageView_23548:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(time + 0.04), CCCallFunc:create(function()
      runAct(math.random(1.5, 2))
    end))))
  end
  
  if self.newShardLv <= 0 then
    EDLoadShader("GrayScalingShader_2")
    ed.setSpriteShader(icon, "GrayScalingShader_2")
    self.equipUnlock:setAnimation(0, "Idle", true)
  else
    runAct(1)
  end
  self.shardIcon = icon
  self.controller:btRemoveMainTouchHandler({
    key = "shard_touch_open"
  })
  self.controller:btRegisterButtonClick({
    button = icon,
    key = "shard_touch_open",
    param = {},
    clickHandler = function(param, x, y)
      if self.notTouch then
        return
      end
      if self.newShardLv <= 0 then
        ed.playEffect(ed.sound.deo.common_click_feedback)
        self.equipUnlock:setVisible(false)
        self.equipUnlock2:setVisible(true)
        self.equipUnlock2:setAnimation(0, "Idle", false)
        self.equipUnlock2:stopAllActions()
        self.equipUnlock2:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.8), CCCallFunc:create(function()
          self.equipUnlock:setAnimation(0, "Idle", true)
          self.equipUnlock:setVisible(true)
          self.equipUnlock2:setVisible(false)
        end))))
      end
    end
  })
end

function SkillShard:hideCallBack()
  self:closeMaterialSupplyWin()
  self.ui.btn_add_material1:stopAllActions()
  self.ui.icon_add_material1:stopAllActions()
  self.ui.label_add_material1:stopAllActions()
  self.ui.label_add_material1:setOpacity(255)
  self.ui.icon_add_material1:setOpacity(255)
end

function SkillShard:refreshLv(lv, isSupplyTrigger)
  local unlock = lv <= 0
  local isMax = lv >= self.data.getHeroShardMaxLv(self.newShardId)
  local shardType = unlock and 1 or isMax and 2 or 0
  if not self.shardType or self.shardType ~= shardType then
    self.ui.Label_23748:setString(isMax and T("\229\183\178\230\187\161\231\186\167") or unlock and T("\230\191\128\230\180\187") or T("\229\188\186\229\140\150"))
    ed.adaptLabel(self.ui.Label_23748, {
      maxWidth = self.ui.btn_qh:getContentSize().width - 4,
      minScale = 0.8
    })
    self.ui.img_lv_max:setVisible(isMax)
    self.ui.btn_qh:setVisible(not isMax)
    self.ui.panel_consume:setVisible(not isMax)
    self.ui.img_lock_bg:setVisible(unlock)
    self.ui.ImageView_23551:setVisible(not unlock)
    self.ui.btn_show_attr:setVisible(not unlock)
    self.arcanaLight:setVisible(not unlock)
  end
  self.shardType = shardType
  if unlock then
    self.ui.shard_label_level:setString(T("\230\156\170\232\167\137\233\134\146"))
  else
    self.ui.shard_label_level:setString(ed.formatLevel("lv.") .. lv)
  end
  if self.shardLv and self.shardLv == 0 and self.newShardLv ~= 0 then
    ed.resetSpriteShader(self.shardIcon)
    if self.hid and self.shardId and self.heroInfo._tid == self.hid and self.newShardId == self.shardId then
      ed.playEffect(ed.sound.shard.unlockEquip)
      self.equipUnlock:setAnimation(0, "Idle2", false)
    else
      self.equipUnlock:setVisible(unlock)
    end
  else
    self.equipUnlock:setVisible(unlock)
  end
  self.ui.panel_attr_txt:removeAllChildrenWithCleanup(true)
  self.ui.panel_consume_item:removeAllChildrenWithCleanup(true)
  local attrDesc = self.data.getHeroShardAttrByLevel(self.newShardId, lv)
  if #attrDesc <= 0 then
    self.notTouch = true
    ed.showToast("error: ShardAttribs not ShardId!")
    return
  end
  if 0 < lv then
    local width = self.ui.panel_attr_txt:getContentSize().width - 6
    for i = 1, ed.clamp(math.ceil(#attrDesc / 2), 0, 3) do
      local attrBg = ed.createScale9Sprite("UI/alpha/1080P/shard/img_shard_bg.png", CCRectMake(5, 5, 5, 5))
      attrBg:setContentSize(CCSizeMake(width, 28))
      attrBg:setPosition(ccp(width / 2 + 3, 122 - i * 29))
      attrBg:setOpacity(i % 2 == 0 and 20 or 50)
      self.ui.panel_attr_txt:addChild(attrBg)
      local attrIdx = 2 * (i - 1) + 1
      if attrDesc[attrIdx] then
        local star = ed.createSprite("UI/alpha/1080P/skill/new/skill_rankup_point.png")
        star:setPosition(ccp(30, 14))
        attrBg:addChild(star)
        star:setScale(0.9)
        local label = ed.createttf(attrDesc[attrIdx].name, 16)
        label:setPosition(ccp(45, 14))
        label:setColor(ccc3(255, 234, 198))
        label:setAnchorPoint(ccp(0, 0.5))
        attrBg:addChild(label)
        ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
        label = ed.createttf(attrDesc[attrIdx].num, 16)
        label:setPosition(ccp(width / 2 - 20, 14))
        label:setColor(ccc3(255, 234, 198))
        label:setAnchorPoint(ccp(1, 0.5))
        attrBg:addChild(label)
        ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
      end
      if attrDesc[attrIdx + 1] then
        local star = ed.createSprite("UI/alpha/1080P/skill/new/skill_rankup_point.png")
        star:setPosition(ccp(width / 2 + 30, 14))
        attrBg:addChild(star)
        star:setScale(0.9)
        local label = ed.createttf(attrDesc[attrIdx + 1].name, 16)
        label:setPosition(ccp(width / 2 + 45, 14))
        label:setColor(ccc3(255, 234, 198))
        label:setAnchorPoint(ccp(0, 0.5))
        attrBg:addChild(label)
        ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
        label = ed.createttf(attrDesc[attrIdx + 1].num, 16)
        label:setPosition(ccp(width - 30, 14))
        label:setColor(ccc3(255, 234, 198))
        label:setAnchorPoint(ccp(1, 0.5))
        attrBg:addChild(label)
        ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
      end
    end
  end
  self.attrDesc = attrDesc
  local skillDesc = self.data.getHeroLvShardSkill(self.newShardId, lv)
  if self.skillUnlock then
    self.skillUnlock:setVisible(false)
    self.skillUnlockA:setVisible(false)
  end
  local height = 20
  for i, v in ipairs(skillDesc) do
    local oldStar, oldAutoText
    if self.unlockLevel and self.unlockLevel == v.unlockLevel and self.skillDescNodes[v.unlockLevel] then
      oldStar = self.skillDescNodes[v.unlockLevel].star
      oldAutoText = self.skillDescNodes[v.unlockLevel].autoText.node
      local action = CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCFadeTo:create(0.5, 0), CCCallFunc:create(function()
        oldStar:removeFromParentAndCleanup(true)
        oldAutoText:removeFromParentAndCleanup(true)
      end)))
      oldAutoText:runAction(action)
      self.skillDescNodes[v.unlockLevel] = nil
      if not self.skillUnlock then
        local skillUnlock = ed.createFcaActor("eff_UI_Shard_SkillUnlock")
        skillUnlock:setLoop(false)
        self.skilDragList.listLayer:addChild(skillUnlock, 999)
        self.controller:addFca(skillUnlock)
        self.skillUnlock = skillUnlock
        local skillUnlockA = ed.createFcaActor("eff_UI_Shard_SkillUnlock_a")
        skillUnlockA:setLoop(false)
        self.skilDragList.listLayer:addChild(skillUnlockA, 999)
        self.controller:addFca(skillUnlockA)
        self.skillUnlockA = skillUnlockA
      end
      self.skillUnlock:setVisible(true)
      self.skillUnlockA:setVisible(true)
      local posx, posy = oldStar:getPosition()
      self.skillUnlock:setPosition(posx - 1, posy + 2)
      self.skillUnlock:setAction("Start")
      self.skillUnlockA:setPosition(posx - 1, posy + 2)
      self.skillUnlockA:setAction("Start")
      self.skillUnlockA:setScaleY(1)
      ed.playEffect(ed.sound.shard.unlockSkill)
    end
    if not self.skillDescNodes[v.unlockLevel] then
      local star = ed.createSprite(string.format("UI/alpha/1080P/shard/shard_%d.png", v.isUnlock and 1 or 2))
      self.skilDragList.listLayer:addChild(star)
      local size = self.ui.panel_skil_txt:getContentSize()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = v.isUnlock and v.description or string.gsub(v.description, "color=(%w+)", "color=ccc3(143,143,143)") .. string.format(T("<lable color=ccc3(245,107,105)>(%s\232\167\163\233\148\129)</lable>"), ed.formatLevel("lv") .. v.unlockLevel),
        fontSize = 16,
        maxWidth = size.width - 86,
        color = v.isUnlock and ccc3(255, 234, 198) or ccc3(143, 143, 143),
        strokeColor = ccc3(0, 0, 0),
        strokeSize = 1,
        lineSpacing = 0
      })
      self.skilDragList.listLayer:addChild(autoText.node)
      local _, sizeH = autoText:getContentSize()
      autoText.node:setPosition(ccp(60, 130 - height))
      star:setPosition(ccp(35, 137 - height - 7))
      height = height + sizeH + 20
      if self.skillUnlockA and 16.5 < sizeH then
        self.skillUnlockA:setPositionY(self.skillUnlockA:getPositionY() - (sizeH - 16.5) / 2)
        if 33 < sizeH then
          self.skillUnlockA:setScaleY(sizeH / 33)
        end
      end
      if oldAutoText then
        autoText.node:setPosition(ccp(oldAutoText:getPosition()))
        star:setPosition(ccp(oldStar:getPosition()))
      end
      autoText:addRegisterHandler("shardDetail", function(index, x, y)
        ed.UITool.openView("showDictInfoPop", {
          index = index,
          x = x,
          y = y
        })
      end)
      if self.unlockLevel and self.unlockLevel == v.unlockLevel then
        star:setOpacity(0)
        autoText.node:setOpacity(0)
        star:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCFadeTo:create(0.5, 255))))
        autoText.node:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCFadeTo:create(0.5, 255))))
      end
      self.skillDescNodes[v.unlockLevel] = {star = star, autoText = autoText}
    end
  end
  if self.skilDragList:getListHeight() == 0 then
    self.skilDragList:initListHeight(height + 10)
  end
  local consume = self.data.getHeroLvByConsume(self.newShardId, lv + 1)
  self.needItemIds = {}
  self.lackOfItemIds = {}
  local icon1 = ed.createItemIcon({
    id = consume[1].id,
    type = consume[1].type,
    amount = (consume[1].amount or 0) + 1
  })
  icon1:setPosition(91, 30)
  self.ui.panel_consume_item:addChild(icon1)
  if icon1.amountLabel then
    icon1.amountLabel:setAnchorPoint(ccp(0.5, 0))
    local bgsize = icon1:getContentSize()
    icon1.amountLabel:setPosition(bgsize.width / 2, 8)
    if ed.player._money < consume[1].amount then
      icon1.amountLabel:setColor(ccc3(246, 111, 112))
    end
    icon1.amountLabel:setString(consume[1].amount)
  end
  self.controller:btRemoveMainTouchHandler({
    key = "touch_items_1"
  })
  self.controller:btRegisterButtonClick({
    button = icon1,
    key = "touch_items_1",
    param = consume[1],
    clickHandler = function(param, x, y)
      ed.UITool.openView("packageDetail", param)
    end,
    pressScale = 0.6,
    normalScale = 0.65
  })
  local num = 0
  local icon2 = ed.createItemIcon({
    id = consume[2].id,
    type = consume[2].type,
    amount = 0
  })
  icon2:setPosition(159, 30)
  self.ui.panel_consume_item:addChild(icon2)
  local amountStr1, amountStr2, amountStr3
  local color = ccc3(255, 251, 231)
  num = ed.player.equip_qunty[consume[2].id] or 0
  if num then
    local bgsize = icon2:getContentSize()
    amountStr1 = string.format("%s", num)
    amountStr3 = string.format("/%s", consume[2].amount)
    if num < consume[2].amount then
      color = ed.toccc3(15806515)
      table.insert(self.lackOfItemIds, {
        id = consume[2].id,
        type = consume[2].type,
        wantageAmount = consume[2].amount - num
      })
    end
    table.insert(self.needItemIds, {
      id = consume[2].id,
      type = consume[2].type,
      wantageAmount = consume[2].amount - num
    })
    if self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() then
      local itemCount = self.materialSupplyWin:getItemAddCountByItemId(consume[2].id)
      if 0 < itemCount then
        amountStr2 = string.format("+%s", itemCount)
        if itemCount + num >= consume[2].amount then
          color = ccc3(255, 251, 231)
        end
      end
    end
  else
    amountStr3 = consume[2].amount
  end
  self.actionLabels = {}
  local labelWidth = 0
  local labelList = {}
  local amountLabel3 = ed.createttf(amountStr3, 16)
  ed.setLabelColor(amountLabel3, color)
  amountLabel3:setPosition(-labelWidth, 10)
  labelWidth = labelWidth + amountLabel3:getContentSize().width / icon2:getScale()
  table.insert(labelList, amountLabel3)
  local bgsize = icon2:getContentSize()
  if amountStr2 then
    local amountLabel2 = ed.createttf(amountStr2, 16)
    ed.setLabelColor(amountLabel2, ed.toccc3(7405396))
    amountLabel2:setPosition(-labelWidth, 10)
    labelWidth = labelWidth + amountLabel2:getContentSize().width / icon2:getScale()
    amountLabel2:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCCallFunc:create(function()
        amountLabel2:runAction(CCFadeTo:create(0.9, 255 - amountLabel2:getOpacity()))
      end),
      CCDelayTime:create(1)
    })))))
    table.insert(self.actionLabels, amountLabel2)
    table.insert(labelList, amountLabel2)
  end
  if amountStr1 then
    local amountLabel1 = ed.createttf(amountStr1, 16)
    ed.setLabelColor(amountLabel1, color)
    amountLabel1:setPosition(-labelWidth, 10)
    labelWidth = labelWidth + amountLabel1:getContentSize().width / icon2:getScale()
    table.insert(labelList, amountLabel1)
  end
  for k = 1, #labelList do
    local label = labelList[k]
    label:setPositionX(label:getPositionX() + bgsize.width / 2 + labelWidth / 2)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
    label:setScale(1 / icon2:getScale())
    label:setAnchorPoint(ccp(1, 0))
    icon2:addChild(label)
  end
  self.controller:btRemoveMainTouchHandler({
    key = "touch_items_2"
  })
  self.controller:btRegisterButtonClick({
    button = icon2,
    key = "touch_items_2",
    param = consume[2],
    clickHandler = function(param, x, y)
      ed.UITool.openView("packageDetail", param)
    end,
    pressScale = 0.6,
    normalScale = 0.65
  })
  self.consumeItems = {
    {
      icon = icon1,
      data = consume[1],
      isNot = ed.player._money < consume[1].amount,
      tip = T("\230\157\144\230\150\153\228\184\141\232\182\179")
    },
    {
      icon = icon2,
      data = consume[2],
      isNot = num < consume[2].amount,
      tip = T("\230\157\144\230\150\153\228\184\141\232\182\179")
    }
  }
  self.unlockLevel = nil
  if not isSupplyTrigger then
    self:refreshMatertialBtnVisible()
  end
end

function SkillShard:refreshUI(updateHero)
  self.notTouch = false
  if not self.hid or self.heroInfo._tid ~= self.hid then
    for k, v in pairs(self.skillDescNodes) do
      v.star:removeFromParentAndCleanup(true)
      v.autoText.node:removeFromParentAndCleanup(true)
    end
    self.skillDescNodes = {}
    self.skilDragList.listHeight = 0
    self:refreshAll()
    self:refreshLv(self.newShardLv)
  elseif not self.shardId or self.newShardId ~= self.shardId then
    for k, v in pairs(self.skillDescNodes) do
      v.star:removeFromParentAndCleanup(true)
      v.autoText.node:removeFromParentAndCleanup(true)
    end
    self.skillDescNodes = {}
    self.skilDragList.listHeight = 0
    self:refreshAll()
    self:refreshLv(self.newShardLv)
  elseif not self.shardLv or self.newShardLv ~= self.shardLv then
    if self.shardLv and self.shardLv == 0 and 0 < self.newShardLv then
      self:refreshAll()
    end
    self:refreshLv(self.newShardLv)
  end
  self:refreshSkillUpMaterials()
  self.shardLv = self.newShardLv
  self.shardId = self.newShardId
  self.hid = self.heroInfo._tid
end

function SkillShard:addAttrFloatingShow(addAttr)
  if not self.attrFloatingShowLay then
    local layer = CCLayer:create()
    layer:setPosition(self.ui.ImageView_23548:getPosition())
    self.ui.panel_left:addChild(layer, 999)
    self.attrFloatingShowLay = layer
  end
  self.attrFloatingShowLay:stopAllActions()
  self.attrFloatingShowLay:removeAllChildrenWithCleanup(true)
  local idx = 1
  
  local function addShow()
    local attrStr = addAttr[idx]
    if attrStr then
      self.attrFloatingShowLay:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCCallFunc:create(function()
        local txt = ed.createttf(attrStr.name .. "+" .. attrStr.num, 18)
        txt:setColor(ed.toccc3(7405396))
        ed.setLabelStroke(txt, ed.toccc3(1519903), 2)
        txt:setPosition(ccp(0, 10))
        self.attrFloatingShowLay:addChild(txt)
        local act1 = CCMoveTo:create(0.5, ccp(0, 35))
        local act2 = CCFadeOut:create(0.1)
        local act3 = CCCallFunc:create(function()
          txt:removeFromParentAndCleanup(true)
        end)
        txt:runAction(ed.readaction.create({
          t = "seq",
          act1,
          act2,
          act3
        }))
        idx = idx + 1
        addShow()
      end))))
    end
  end
  
  addShow()
end

function SkillShard:registerTouchHandlers()
  self.controller:listenEvent("ResourceNumChange", function(resType, id)
    local item = self.consumeItems[1]
    if item.data.type == resType then
      if ed.player._money < item.data.amount then
      else
      end
      self.consumeItems[1].isNot = ed.player._money < item.data.amount
    else
      item = self.consumeItems[2]
      if item.data.id == id then
        local num = ed.player.equip_qunty[id] or 0
        if num < item.data.amount then
        else
        end
        self.consumeItems[2].isNot = num < item.data.amount
      end
    end
  end)
  self.controller:listenEvent("shard_reply", function(info)
    local heros = info._unlock or info._level_up or info._wear
    ed.player:addMoney(-self.consumeItems[1].data.amount)
    ed.player:consumeEquip(self.consumeItems[2].data.id, self.consumeItems[2].data.amount)
    self.bLevelUpUpdate = true
    if info._level_up then
      self.unlockLevel = self.newShardLv + 1
    end
    self:refreshData({
      data = heros._hero
    })
    if info._level_up or info._unlock then
      local _, allAttrs = self.data.getHeroShardAttrByLevel(self.newShardId, self.newShardLv)
      local attrs = self.data.getHeroShardAllAttrLevel(self.newShardId)
      local newSkill = self.data.getHeroLvShardSkill(self.newShardId, self.newShardLv)
      local heroShardInfo = self.data.getHeroShardInfo(self.heroInfo._tid, self.newShardId) or {}
      local addAttr = attrs[self.newShardLv]
      local newUnlockSkill
      for _, v in ipairs(newSkill) do
        if v.isNewUnlock then
          newUnlockSkill = v
          break
        end
      end
      local arcanaLight2 = ed.createFcaNode("eff_UI_arcana_light2")
      arcanaLight2:setPosition(ccp(205, 240))
      self.ui.ImageView_23548:addChild(arcanaLight2, 6)
      self.controller:addFcaOnce(arcanaLight2)
      self.equipUnlock2:stopAllActions()
      arcanaLight2:setScale(1.2)
      self:refreshUI()
      self:addAttrFloatingShow(addAttr)
      self.equipUnlock2:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(2 >= self.newShardLv and 1.8 or 1.2), CCCallFunc:create(function()
        ed.UITool.openView("shardRankUpPop", {
          hero = {
            shardId = self.newShardId,
            shardLv = self.newShardLv,
            tid = self.heroInfo._tid
          },
          allAttrs = allAttrs,
          addAttr = addAttr,
          newUnlockSkill = newUnlockSkill,
          heroShardInfo = heroShardInfo,
          closeCallback = function()
          end
        })
      end))))
    end
  end)
  
  local function consumeFunc()
    for i, v in ipairs(self.consumeItems) do
      if v.isNot then
        ed.showToast(v.tip)
        return true
      end
    end
  end
  
  ed.UITool.registerBtn(self.controller, "btn_qh", function()
    if self.notTouch then
      return
    end
    local isOpen, txt = ed.heroDetailManager.getHeroShardIsOpen(self.heroInfo.data)
    if not isOpen then
      ed.showToast(txt or T("\230\156\170\229\188\128\229\144\175"))
      return
    end
    if self.newShardLv <= 0 then
      ed.UITool.openView("shardActivationPop", {
        hero = {
          shardId = self.newShardId,
          shardLv = self.newShardLv,
          tid = self.heroInfo._tid
        },
        callback = function()
          if consumeFunc() then
            return
          end
          self.notTouch = true
          self.network:shardReq(self.heroInfo._tid, self.newShardId)
        end
      })
    else
      if consumeFunc() then
        return
      end
      self.notTouch = true
      self.network:shardLevelUpReq(self.heroInfo._tid, self.newShardId, self.newShardLv + 1)
    end
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self.controller, "ImageView_23551", function()
    local attrs = self.data.getHeroShardAllAttrLevel(self.newShardId)
    ed.UITool.openView("shardLevelupPop", {
      hero = {
        shardId = self.newShardId,
        shardLv = self.newShardLv,
        tid = self.heroInfo._tid
      },
      allAttrs = attrs
    })
  end)
  ed.UITool.registerBtn(self.controller, "btn_show_attr", function()
    ed.UITool.openView("shardAttributesPop", {
      hero = {
        shardId = self.newShardId,
        shardLv = self.newShardLv,
        tid = self.heroInfo._tid,
        attrDesc = self.attrDesc
      }
    })
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.controller, "btn_add_material1", function()
    self:openMaterialSupplyWin()
  end, {})
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -300, true)
  self.mainLayer:setTouchEnabled(true)
end

function SkillShard:refreshSkillUpMaterials(isSupplyTrigger)
  self:refreshLv(self.newShardLv, isSupplyTrigger)
end

function SkillShard:doOutLayerTouch()
  local isPressClose
  
  local function handler(event, x, y)
    local isClickInRange = self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() and not ed.containsPoint(self.materialSupplyWin.ui.bg_detail, x, y)
    isClickInRange = isClickInRange and not ed.containsPoint(self.ui.btn_skillup, x, y)
    local isClickWin = self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() and ed.containsPoint(self.materialSupplyWin.ui.bg_detail, x, y)
    local isClickOutBtn = ed.containsPoint(self.ui.skill1, x, y) or ed.containsPoint(self.ui.skill2, x, y) or ed.containsPoint(self.ui.skill3, x, y) or ed.containsPoint(self.ui.skill4, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.ui.btn_simple, x, y) or ed.containsPoint(self.ui.btn_detail, x, y) or ed.containsPoint(self.controller.ui.btn_back, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.controller.ui.arrow_left, x, y) or ed.containsPoint(self.controller.ui.arrow_right, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.controller.ui.btn1, x, y) or ed.containsPoint(self.controller.ui.btn2, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.controller.ui.btn3, x, y) or ed.containsPoint(self.controller.ui.btn4, x, y)
    if event == "began" then
      if isClickInRange then
        isPressClose = true
        return not isClickOutBtn
      end
    elseif event == "ended" then
      if isPressClose and isClickInRange then
        self:closeMaterialSupplyWin()
        self:refreshSkillUpMaterials()
        isPressClose = nil
        return not isClickOutBtn
      end
      isPressClose = nil
    end
    return isClickWin
  end
  
  return handler
end

function SkillShard:doMainLayerTouch()
  local outLayerTouch = self:doOutLayerTouch()
  
  local function handler(event, x, y)
    local isPress
    xpcall(function()
      isPress = outLayerTouch(event, x, y)
    end, EDDebug)
    return isPress
  end
  
  return handler
end

function SkillShard:closeMaterialSupplyWin()
  if self.materialSupplyWin then
    self.materialSupplyWin.mainLayer:setVisible(false)
    self:refreshMatertialBtnVisible()
  end
end

function SkillShard:refreshMatertialBtnVisible()
  local isVisible = #self.lackOfItemIds > 0
  local isShining = self.materialSupplyWin == nil or not self.materialSupplyWin.mainLayer:isVisible()
  local chestList = {}
  local enoughLevelUp = true
  if #self.lackOfItemIds > 0 or self.bLevelUpUpdate then
    self.bLevelUpUpdate = false
    chestList, enoughLevelUp = self:getBoxItemsByMetarail(self.lackOfItemIds)
    if #chestList <= 0 or not enoughLevelUp then
      isVisible = false
    end
    if self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() then
      if #chestList <= 0 then
        chestList = self:getBoxItemsByMetarail(self.lackOfItemIds, true)
      end
      if #chestList <= 0 then
        chestList = self:getBoxItemsByMetarail(self.needItemIds)
      end
      if #chestList <= 0 then
        chestList = self:getBoxItemsByMetarail(self.needItemIds, true)
      end
      self.materialSupplyWin:refreshDragList(chestList)
      if #chestList <= 0 then
        self.materialSupplyWin.mainLayer:setVisible(false)
      end
    end
  end
  if self.newShardLv >= 25 then
    isVisible = false
  end
  self.ui.btn_add_material1:setVisible(isVisible)
  if self.materialSupplyWin and not isVisible then
    self.materialSupplyWin.mainLayer:setVisible(false)
  end
  self.ui.btn_add_material1:stopAllActions()
  self.ui.icon_add_material1:stopAllActions()
  self.ui.label_add_material1:stopAllActions()
  self.ui.label_add_material1:setOpacity(255)
  self.ui.icon_add_material1:setOpacity(255)
  if isVisible and isShining then
    self.ui.btn_add_material1:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCCallFunc:create(function()
        self.ui.icon_add_material1:runAction(CCFadeTo:create(0.9, 255 - self.ui.icon_add_material1:getOpacity()))
        self.ui.label_add_material1:runAction(CCFadeTo:create(0.9, 255 - self.ui.label_add_material1:getOpacity()))
      end),
      CCDelayTime:create(1)
    })))))
  end
end

function SkillShard:getBoxItemsByMetarail(needItemIds, countZeroAmount)
  local chestTable = ed.getDataTable("ChestCombination")
  local chestList = {}
  local enoughLevelUp = true
  for i = 1, #needItemIds do
    local itemInfo = needItemIds[i]
    local totalAmount = 0
    for chestId, chestInfo in pairs(chestTable) do
      local itemSetList = chestInfo["Item Set"]
      local itemSetCountList = chestInfo["Item Set Count"]
      local chestItemId = chestInfo["Item Id"]
      for k = 1, #itemSetList do
        local itemSetId = itemSetList[k]
        if itemSetId == itemInfo.id then
          local amount = ed.player:getEquipAmount(chestItemId) or 0
          totalAmount = totalAmount + amount * itemSetCountList[k]
          if 0 < amount or countZeroAmount then
            local cfg = {
              ui = nil,
              chestInfo = chestInfo,
              useAmountLimit = amount,
              needItemId = itemInfo.id,
              callBack = function()
                self:refreshSkillUpMaterials(true)
              end,
              priority = 0,
              itemOpenCount = itemSetCountList[k]
            }
            table.insert(chestList, cfg)
          end
          break
        end
      end
    end
    if totalAmount < itemInfo.wantageAmount then
      enoughLevelUp = false
    end
  end
  table.sort(chestList, function(a, b)
    return a.priority > b.priority
  end)
  return chestList, enoughLevelUp
end

function SkillShard:openMaterialSupplyWin()
  if self.materialSupplyWin then
    self.materialSupplyWin.mainLayer:setVisible(true)
  else
    self.materialSupplyWin = ed.ui.MaterialSupplyWin.create({
      controller = self.controller
    })
    self.controller.mainLayer:addChild(self.materialSupplyWin.mainLayer, 400)
  end
  local chestList = self:getBoxItemsByMetarail(self.lackOfItemIds)
  if 0 < #chestList then
    chestList = self:getBoxItemsByMetarail(self.lackOfItemIds, true)
  end
  self.materialSupplyWin:refreshDragList(chestList, true)
  self:refreshMatertialBtnVisible()
end

local network = {}
SkillShard.network = network

function network:shardReq(heroId, shardId)
  local msg = ed.upmsg.shard_req()
  msg._unlock = ed.upmsg.shard_unlock()
  msg._unlock._hero_id = heroId
  msg._unlock._shard_id = shardId
  ed.send(msg, "shard")
end

function network:shardLevelUpReq(heroId, shardId, toLevel)
  local msg = ed.upmsg.shard_req()
  msg._level_up = ed.upmsg.shard_level_up()
  msg._level_up._hero_id = heroId
  msg._level_up._shard_id = shardId
  msg._level_up._to_level = toLevel
  ed.send(msg, "shard")
end

function network:shardWearReq(heroId, shardId)
end

local data = {}
SkillShard.data = data
data.shardAttribs = {
  "STR",
  "INT",
  "AGI",
  "HP",
  "MP",
  "AD",
  "AP",
  "ARM",
  "MR",
  "CRIT",
  "MCRIT",
  "HPS",
  "MPS",
  "HIT",
  "DODG",
  "ARMP",
  "MRI",
  "LFS",
  "HEAL",
  "HealRatio",
  "DOTRES"
}

function data.getHeroIsShard(hid)
  local shardId = ed.heroDetailManager.shardList[hid] and (ed.heroDetailManager.shardList[hid][1] or 0) or 0
  if 0 < shardId and ed.heroDetailManager:isShardOnlineTime(shardId) then
    return ed.getDataTable("ShardToHero")[shardId]
  end
  return false
end

function data.getHeroShardInfo(id, shardId)
  for k, v in pairs(ed.getDataTable("ShardToHero")) do
    if shardId == v["Shard ID"] and v["Hero ID"] == id then
      return v
    end
  end
  return false
end

function data.getHeroShardMaxLv(shardId)
  local maxLv = 0
  for k, v in pairs(ed.getDataTable("ShardAttribs")[shardId] or {}) do
    maxLv = maxLv < v.Level and v.Level or maxLv
  end
  return maxLv
end

function data.getHeroLvByConsume(skilId, lv)
  local cfg = ed.getDataTable("ShardAttribs")[skilId][lv or 1] or ed.getDataTable("ShardAttribs")[skilId][1]
  return {
    {
      id = nil,
      amount = cfg.Gold,
      type = "gold"
    },
    {
      id = cfg["Item ID"],
      amount = cfg["Item Amount"],
      type = "item"
    }
  }
end

function data.getHeroShardAttrByLevel(shardId, level)
  level = level <= 0 and 1 or level
  local tb = ed.getDataTable("ShardAttribs")[shardId]
  if not tb then
    return {}
  end
  local attrs = {}
  for k, v in pairs(tb) do
    if level >= v.Level then
      for k, attrName in ipairs(data.shardAttribs) do
        if 0 < v[attrName] then
          attrs[attrName] = v[attrName] + (attrs[attrName] or 0)
        end
      end
    end
  end
  local attrDesc = {}
  for i, v in ipairs(data.shardAttribs) do
    if attrs[v] then
      table.insert(attrDesc, {
        key = v,
        num = attrs[v],
        name = ed.heroDetailManager.resConfig.att_anim_name[v]
      })
    end
  end
  return attrDesc, attrs
end

function data.getHeroShardAllAttrLevel(shardId)
  local tb = ed.getDataTable("ShardAttribs")[shardId]
  if not tb then
    return {}
  end
  local attrs = {}
  for k, v in pairs(tb) do
    attrs[v.Level] = {}
    for k, attrName in ipairs(data.shardAttribs) do
      if 0 < v[attrName] then
        table.insert(attrs[v.Level], {
          key = attrName,
          num = v[attrName],
          name = ed.heroDetailManager.resConfig.att_anim_name[attrName]
        })
      end
    end
  end
  return attrs
end

function data.getHeroLvShardSkill(skilId, newLv)
  local cfg = ed.getDataTable("ShardSkill")[skilId]
  if not cfg then
    cfg = {}
    ed.showToast("ShardSkill skilIdId nil :" .. skilId)
  end
  local dictTb = ed.getDataTable("Dictionary")
  local shardSkills = {}
  for i, v in ipairs(cfg) do
    local text = v.Description
    for ii = 1, 4 do
      local num = v["Script Arg" .. ii]
      if num ~= 0 and string.find(text, "Script Arg&" .. ii) then
        text = string.gsub(text, "%%Script Arg&" .. ii .. "%%", math.abs(num))
      end
    end
    local tmpStr = text
    local args = {}
    while true do
      local pos1, pos2 = string.find(tmpStr, "<#%d+#.-#>")
      if not pos1 then
        break
      else
        local paramName = string.sub(tmpStr, pos1, pos2)
        local pos3, pos4 = string.find(paramName, "%d+")
        local paramIndex = tonumber(string.sub(paramName, pos3, pos4))
        local paramValue = string.sub(paramName, pos4 + 2, -3)
        local value = string.format("<lable color=ccc3(255,251,231) clickhandler=%s data=%d>%s</lable>", "shardDetail", paramIndex, paramValue)
        table.insert(args, value)
        tmpStr = string.sub(tmpStr, pos2 + 1)
      end
    end
    if 0 < #args then
      text = string.gsub(text, "<#%d+#.-#>", "%%s")
      text = string.format(text, unpack(args))
    end
    text = string.gsub(text, "#p#", "%%")
    table.insert(shardSkills, {
      description = text,
      unlockLevel = v["Unlock Level"],
      ShardSkillRank = v["Shard Skill Rank"],
      isUnlock = newLv >= v["Unlock Level"],
      isNewUnlock = newLv == v["Unlock Level"]
    })
  end
  return shardSkills
end

function SkillShard:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.img_right_bg:setContentSize(CCSizeMake(self.ui.img_right_bg:getContentSize().width + fixWidth, self.ui.img_right_bg:getContentSize().height))
  self.ui.img_right_bg:setPositionX(self.ui.img_right_bg:getPositionX() + fixWidth / 2)
  self.ui.img_lv_bg:setContentSize(CCSizeMake(self.ui.img_lv_bg:getContentSize().width + fixWidth, self.ui.img_lv_bg:getContentSize().height))
  self.ui.btn_add_material1:setPositionX(self.ui.btn_add_material1:getPositionX() + fixWidth / 2)
  self.ui.img_lv_bg:setPositionX(self.ui.img_lv_bg:getPositionX() + fixWidth / 2)
  self.ui.img_title:setPositionX(self.ui.img_title:getPositionX() + fixWidth / 2)
  self.ui.panel_attr_txt:setContentSize(CCSizeMake(self.ui.panel_attr_txt:getContentSize().width + fixWidth, self.ui.panel_attr_txt:getContentSize().height))
  self.ui.img_title_2:setPositionX(self.ui.img_title_2:getPositionX() + fixWidth / 2)
  self.ui.img_fa_bg:setContentSize(CCSizeMake(self.ui.img_fa_bg:getContentSize().width + fixWidth, self.ui.img_fa_bg:getContentSize().height))
  self.ui.img_fa_bg:setPositionX(self.ui.img_fa_bg:getPositionX() + fixWidth / 2)
  local size = self.ui.panel_fa:getContentSize()
  self.ui.panel_fa:setContentSize(CCSizeMake(size.width + fixWidth, size.height))
  self.ui.panel_fa:setClipRect(CCRectMake(0, 0, size.width + fixWidth, size.height))
  local size = self.ui.panel_skil_txt:getContentSize()
  self.ui.panel_skil_txt:setContentSize(CCSizeMake(size.width + fixWidth, size.height))
  for i = 1, 25 + math.ceil(fixWidth / 20) do
    local fa = ed.createSprite("UI/alpha/1080P/shard/img_shard_fa.png")
    fa:setPosition(ccp(i * 20 - 8, 215))
    fa:setOpacity(80)
    self.ui.panel_fa:addChild(fa)
  end
  self.ui.panel_consume:setPositionX(self.ui.panel_consume:getPositionX() + fixWidth / 2)
  self.ui.btn_qh:setPositionX(self.ui.btn_qh:getPositionX() + fixWidth / 2)
  self.ui.img_lock_bg:setPositionX(self.ui.img_lock_bg:getPositionX() + fixWidth / 2)
  self.ui.img_lv_max:setPositionX(self.ui.img_lv_max:getPositionX() + fixWidth / 2)
  ed.setLabelStroke(self.ui.Label_23550, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.shard_label_level, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_23755, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_23743, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_23750, ccc3(39, 37, 36), 1)
  self.ui.Label_23755:limitWidthByScale(176)
end
