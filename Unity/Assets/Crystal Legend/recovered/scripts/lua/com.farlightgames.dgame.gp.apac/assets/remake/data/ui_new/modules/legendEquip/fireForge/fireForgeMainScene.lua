local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.fireForgeMainScene = class
class.scope = {}
ed.UITool.registViewOpenFunc("fireForgeMainScene", function()
  local unlockLevel = ed.playerlimit:getModuleUnlockLevel("LegendEquipForge")
  if unlockLevel > ed.player:getLevel() then
    ed.showToast(string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%s\231\186\167\229\188\128\230\148\190"), unlockLevel))
    return
  end
  ed.legendEquipNet.sendForgePanel()
  CloseScope(class.scope)
  ListenEventOnce("FireForgeOpenPanel", function()
    local scene = ed.ui.fireForgeMainScene.create()
    ed.pushScene(scene)
  end, class.scope)
end)

function class.create()
  local self = base.create("fireForgeMainScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.forgeBoardOpen = false
  self.mgr = ed.legendEquipMgr.getInstance()
  self.payedMonthCardValid = ed.player:isMonthCardValid("payed")
  self:initData()
  self:initView()
  self:addTouchEvent()
  self:addEventListen()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_main_scene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.ui.image_arrow:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(3, 127), CCFadeTo:create(3, 255))))
  self:adaptUI()
  self:initLabels()
  self:initForgeDragList()
  self:initRedDot()
  self:initEffect()
  self:refreshUI()
end

function class:initData()
  self.unlockQueueList = {}
  self.unlockQueueItemList = {}
  for queueId, queue in pairs(self.mgr:getAllForgeQueue()) do
    self.unlockQueueList[queueId] = true
    local unlockPosList = queue._unlock_pos
    local unlockAmount = 0
    for index, unlockPos in ipairs(unlockPosList or {}) do
      if unlockPos == 1 then
        unlockAmount = unlockAmount + 1
      end
    end
    self.unlockQueueItemList[queueId] = unlockAmount
  end
end

function class:adaptUI()
  self.image_forge_bg_min_posY = self.ui.image_forge_bg:getPositionY()
  self.image_forge_bg_max_posY = self.image_forge_bg_min_posY + 320 + ed.display.halfFixedHeight
  self.forge_chain_min_posY = self.ui.image_forge_chain_left:getPositionY()
  self.forge_chain_max_posY = self.forge_chain_min_posY + 320 + ed.display.halfFixedHeight
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_shop, {
    left = 70 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_backbag, {
    left = 70 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_book, {
    left = 70 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.image_buff_icon_bg, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_record, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  self.ui.btn_record:setScale(0.76)
  self.ui.btn_record_icon:setScale(1.3157894736842106)
  self.ui.label_buff:setScale(1.3157894736842106)
  self.ui.btn_record:setPositionX(self.ui.image_buff_icon_bg:getPositionX())
  self.ui.btn_record:setPositionY(self.ui.image_buff_icon_bg:getPositionY() - 75)
  self.ui.label_buff:setPositionY(self.ui.label_buff:getPositionY() - 3)
  self.btn_recordPosY = self.ui.btn_record:getPositionY()
  local diffWidth = ed.display.winSize.width - 960
  local oldForgeBgSize = self.ui.image_forge_bg:getContentSize()
  self.ui.image_forge_bg:setContentSize(CCSizeMake(oldForgeBgSize.width + diffWidth, oldForgeBgSize.height))
  self.ui.btn_get_all:setPositionX(self.ui.btn_get_all:getPositionX() + diffWidth / 2)
  self.ui.btn_forge_all:setPositionX(self.ui.btn_forge_all:getPositionX() + diffWidth / 2)
  local oldTouchAreaSize = self.ui.panel_touch_area:getContentSize()
  self.ui.panel_touch_area:setContentSize(CCSizeMake(oldTouchAreaSize.width + diffWidth, oldTouchAreaSize.height))
  local oldPanelForgeListSize = self.ui.panel_forge_list:getContentSize()
  self.ui.panel_forge_list:setContentSize(CCSizeMake(oldPanelForgeListSize.width + diffWidth, oldPanelForgeListSize.height))
  self.ui.image_mustget_bg:setPositionX(self.ui.image_mustget_bg:getPositionX() + diffWidth)
end

function class:initRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("fire_forge_package_entry", self, {
    handle = function(value)
      self.ui.image_backbag_red:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange("fire_forge_overview_finish", self, {
    handle = function(value)
      self.ui.forge_success_amount_bg:setVisible(0 < value)
      ed.setLabelString(self.ui.label_forge_success_amount, value)
    end
  })
  self.redPointMgr:registerValueChange("fire_forge_overview_empty", self, {
    handle = function(value)
      local fireForgeOverviewFinish = self.redPointMgr:getNodeValue("fire_forge_overview_finish") > 0
      self.ui.image_empty_red:setVisible(not fireForgeOverviewFinish and 0 < value)
      self.ui.image_forge_all_red:setVisible(not fireForgeOverviewFinish and 0 < value)
    end
  })
  self.redPointMgr:registerValueChange("fire_forge_package_entry_new_equip", self, {
    handle = function(value)
      local fireForgePackageEntry = self.redPointMgr:getNodeValue("fire_forge_package_entry") > 0
      self.ui.image_backbag_new_equip_red:setVisible(not fireForgePackageEntry and 0 < value)
    end
  })
  self.redPointMgr:setNodeValue("fire_forge_first_open_panel", 0)
  self.ui.btn_shop_new:setVisible(ed.legendEquipTool.getIsShowLegendEquipShopNew())
end

function class:initEffect()
  local iron = ed.createSpine("effect/eff_UI_fireforge_iron/eff_UI_fireforge_iron", 0.5, function(event, spine)
    if event == "legendforge_make1" then
      ed.playEffect(ed.sound.deo.fire_forge_make1)
    elseif event == "legendforge_make2" then
      ed.playEffect(ed.sound.deo.fire_forge_make2)
    elseif event == "legendforge_idle" then
      ed.playEffect(ed.sound.deo.fire_forge_idle)
    elseif event == "legendforge_change" then
      ed.playEffect(ed.sound.deo.fire_forge_change)
    end
    if event == "complete" then
      self:refreshIronEffect()
    end
  end)
  self.iron = iron
  self.ui.image_bg:addChild(iron, 1)
  iron:setPosition(ccp(800, 300))
  self:refreshIronEffect()
  local smoke = ed.createSpine("effect/eff_UI_fireforge_smoke/eff_UI_fireforge_smoke", 0.5)
  self.ui.image_bg:addChild(smoke)
  smoke:setAnimation(0, "Idle", true)
  smoke:setPosition(ccp(600, 430))
end

function class:refreshIronEffect()
  local emptyForgeItemAmount, workingForgeItemAmount, finishForgeItemAmount = self.mgr:getForgeItemStateAmount()
  local actionList
  local loop = true
  if 0 < finishForgeItemAmount then
    actionList = {"Idle_ok", "Idle2_ok"}
    self.ironState = "ok"
  elseif 0 < workingForgeItemAmount then
    if self.ironState == "idle" then
      actionList = {"Idle_work"}
      loop = false
      self.ironState = "transition"
    else
      actionList = {"work", "work2"}
      self.ironState = "work"
    end
  elseif self.ironState ~= "idle" then
    actionList = {"Idle", "Idle2"}
    self.ironState = "idle"
  end
  if not actionList then
    return
  end
  local newAction = actionList[math.random(1, #actionList)]
  if newAction == self.oldIronAction then
    return
  end
  if self.oldIronAction then
    self.iron:setMix(self.oldIronAction, newAction, 0)
  end
  self.oldIronAction = newAction
  self.iron:setAnimation(1, newAction, loop)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_shop, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_backbag, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_book, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_buff_finish, ed.toccc3(1651731), 1)
  ed.setLabelStroke(self.ui.label_buff, ed.toccc3(4854547), 1)
  ed.setLabelStroke(self.ui.label_empty_red, ed.toccc3(10039070), 1)
  ed.UITool.createSceneTitle(T("\232\191\156\229\143\164\231\134\148\231\130\137"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.setLabelStroke(self.ui.label_wishlist_only_title, ed.toccc3(11357460), 1)
  ed.setLabelStroke(self.ui.label_wishlist_normal_title, ed.toccc3(2298379), 1)
  ed.setLabelFontName(self.ui.label_wishlist_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_wishlist_title, ed.toccc3(9056284), 1)
  ed.setLabelStroke(self.ui.label_redpoinit, ed.toccc3(9973283), 1)
  ed.setLabelStroke(self.ui.label_buff, ed.toccc3(0), 1)
  local label_forge_title = ed.ui.gradientLabel.create({
    text = T("\233\148\187\233\128\160\230\128\187\232\167\136"),
    fontSize = 24,
    startColor = ed.toccc3(16756540),
    endColor = ed.toccc3(16707251),
    strokeSize = 1,
    strokeColor = ed.toccc3(10039070)
  })
  self.ui.panel_forge_title:addChild(label_forge_title.node)
  ed.layout.centerInParent(label_forge_title.node)
  local label_get_all = ed.ui.gradientLabel.create({
    text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_get_all:addChild(label_get_all.node)
  ed.layout.centerInParent(label_get_all.node)
  local label_forge_all = ed.ui.gradientLabel.create({
    text = T("\228\184\128\233\148\174\233\148\187\233\128\160"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_forge_all:addChild(label_forge_all.node)
  ed.layout.centerInParent(label_forge_all.node)
end

function class:initForgeDragList()
  self.forgeSmelterItemList = {}
  local pressX, pressY
  self.forgeDragList = ed.UITool.createDraglist(self.ui.panel_forge_list, {
    priority = -300,
    swallow = false,
    doPressIn = function(x, y)
      for index, forgeSmelterItem in ipairs(self.forgeSmelterItemList) do
        local ui = forgeSmelterItem.ui
        pressX, pressY = x, y
        if ed.containsPoint(ui.image_bg, x, y) then
          if ed.containsPoint(ui.btn_forge, x, y) then
            ui.btn_forge:setScale(0.95)
          elseif ed.containsPoint(ui.btn_skip_all, x, y) then
            ui.btn_skip_all:setScale(0.95)
          elseif ed.containsPoint(ui.image_unlock_tips, x, y) then
            ui.image_unlock_tips:setScale(0.95)
          end
          return forgeSmelterItem
        end
      end
    end,
    doClickIn = function(x, y, forgeSmelterItem)
      if pressX and math.abs(pressX - x) > 20 or math.abs(pressY - y) > 20 then
        return
      end
      self:onClickForgeSmelterItem(x, y, forgeSmelterItem)
    end,
    cancelPressIn = function(x, y, forgeSmelterItem)
      local ui = forgeSmelterItem.ui
      ui.btn_forge:setScale(1)
      ui.btn_skip_all:setScale(1)
      ui.image_unlock_tips:setScale(1)
    end
  })
  self.forgeDragList.clipLayer:setAnchorPoint(ccp(0.5, 1))
  self:refreshForgeListClipRect()
end

function class:onClickForgeSmelterItem(x, y, forgeSmelterItem)
  local ui = forgeSmelterItem.ui
  local queue = forgeSmelterItem.queue
  local queueId = forgeSmelterItem.queueId
  if ed.containsPoint(ui.btn_forge, x, y) and ui.btn_forge:isVisible() then
    if self:checkForge(queueId) then
      self:showForgeAnim(queueId, forgeSmelterItem, function()
        ed.legendEquipNet.sendForgeEquip(queueId)
      end)
    end
  elseif ed.containsPoint(ui.btn_skip_all, x, y) and ui.btn_skip_all:isVisible() then
    self:showSpeedUpQueue(queue)
  elseif ed.containsPoint(ui.image_unlock_tips, x, y) and ui.image_unlock_tips:isVisible() and not queue then
    local cfg = ed.getDataTable("LegendEquipForgeParam")[string.format("Unlock Queue %s", queueId)]
    local costType = cfg["Param Content 1"]
    local price = cfg["Param Content 2"]
    local text, rightText, type, costAmount
    if costType == 1 then
      type = "diamond"
      costAmount = price
      text = string.format(T("\230\182\136\232\128\151<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=ccc3(141,244,118)>%s</lable>\232\167\163\233\148\129\232\191\156\229\143\164\231\134\148\231\130\137%s\233\152\159\229\136\151<br/>\230\152\175\229\144\166\232\167\163\233\148\129"), price, ed.numberToRoman(queueId))
    else
      text = string.format(T("\232\138\177\232\180\185<lable color=ccc3(141,244,118)>%s</lable>\232\167\163\233\148\129\232\191\156\229\143\164\231\134\148\231\130\137%s\233\152\159\229\136\151<br/>\230\152\175\229\144\166\232\167\163\233\148\129"), ed.RechargeManager:getCostDisplayByCNYCost(price), ed.numberToRoman(queueId))
      rightText = ed.RechargeManager:getCostDisplayByCNYCost(price)
    end
    ed.UITool.openView("fireForeConfirmWindow", {
      costType = type,
      costAmount = costAmount,
      title = T("\232\167\163\233\148\129\233\152\159\229\136\151"),
      rightText = rightText,
      desc = text,
      rightHandler = function()
        ed.RechargeManager:doRechargeForgeQueue(queueId)
      end
    })
  end
end

function class:showForgeAnim(queueId, forgeSmelterItem, callBack)
  if self.isShowForgeAnim then
    return
  end
  local queue = self.mgr:getForgeQueueByQueueId(queueId)
  local forgeList = queue._forge_list
  local emptyIndex = #forgeList + 1
  local forgeItemCfg = forgeSmelterItem.container.forgeItemList[emptyIndex]
  if forgeItemCfg and forgeItemCfg.item then
    local pos = ed.getWorldPos(forgeItemCfg.item, ccp(-8, 0))
    local mainLayerPos = ed.getWorldPos(self.mainLayer)
    local spine = ed.createSpine("effect/eff_UI_fireforge_forge/eff_UI_fireforge_forge", 0.6)
    self.mainLayer:addChild(spine)
    spine:setAnimation(0, "Idle", false)
    spine:setPosition(ccpSub(pos, mainLayerPos))
    local delay = CCDelayTime:create(0.1)
    local callFunc = CCCallFunc:create(function()
      self.isShowForgeAnim = false
      callBack()
    end)
    self.isShowForgeAnim = true
    self.mainLayer:runAction(CCSequence:create(ccArrayMake(delay, callFunc)))
  else
    self.isShowForgeAnim = false
    callBack()
  end
end

function class:showOneKeyForgeAnim(callBack)
  if self.isShowForgeAnim then
    return
  end
  local curItemAmount, needAmount = self.mgr:getForgeNeedItemAmount()
  local canForgeItemAmount = math.floor(curItemAmount / needAmount)
  local amount = 0
  for index = 1, 20 do
    for _, forgeSmelterItem in ipairs(self.forgeSmelterItemList) do
      local forgeItemList = forgeSmelterItem.container.forgeItemList
      local forgeItemCfg = forgeItemList[index]
      if not forgeItemCfg then
        break
      end
      local isUnlock = forgeItemCfg.isUnlock
      local forgeItem = forgeItemCfg.forgeItem
      local item = forgeItemCfg.item
      if not forgeItem and isUnlock and canForgeItemAmount > amount then
        local pos = ed.getWorldPos(item, ccp(-8, 0))
        local mainLayerPos = ed.getWorldPos(self.mainLayer)
        local spine = ed.createSpine("effect/eff_UI_fireforge_forge/eff_UI_fireforge_forge", 0.6)
        self.mainLayer:addChild(spine)
        spine:setVisible(false)
        spine:setPosition(ccpSub(pos, mainLayerPos))
        local delayTime = CCDelayTime:create(amount * 0.03)
        local callFunc = CCCallFunc:create(function()
          spine:setVisible(true)
          spine:setAnimation(0, "Idle", false)
        end)
        spine:runAction(CCSequence:create(ccArrayMake(delayTime, callFunc)))
        amount = amount + 1
      end
    end
  end
  local maxDelayTime = amount * 0.03
  local delay = CCDelayTime:create(0.1 + maxDelayTime)
  local callFunc = CCCallFunc:create(function()
    self.isShowForgeAnim = false
    callBack()
  end)
  self.isShowForgeAnim = true
  self.mainLayer:runAction(CCSequence:create(ccArrayMake(delay, callFunc)))
end

function class:refreshUI()
  self:refreshIronEffect()
  self:refreshForgeList()
  self:refreshWishList()
  self:refreshMustGet()
  self:refreshBuffIcon()
end

function class:refreshWishList()
  local onlyWishList = self.mgr:getWishByType("only")
  if onlyWishList then
    local wishInfo = onlyWishList[1]
    local typeId = wishInfo._equip_id
    local isSuccess = wishInfo._is_success
    if self.wishOnlyEquipIcon then
      self.wishOnlyEquipIcon:removeFromParentAndCleanup(true)
      self.wishOnlyEquipIcon = nil
    end
    if typeId and 0 < typeId then
      local icon = self:createWishEquipIcon(typeId, isSuccess)
      icon:setPosition(ccp(45, 45))
      self.ui.image_wish_only_equip:addChild(icon)
      self.wishOnlyEquipIcon = icon
    end
  end
  local normalWishList = self.mgr:getWishByType("normal")
  if normalWishList then
    for _, normalWishInfo in ipairs(normalWishList) do
      local index = normalWishInfo._index
      local typeId = normalWishInfo._equip_id
      local isSuccess = normalWishInfo._is_success
      local targetNode = self.ui["image_wish_normal_equip_" .. index]
      local icon = self["selectNormalEquipIcon" .. index]
      if icon then
        icon:removeFromParentAndCleanup(true)
        icon = nil
      end
      if typeId and 0 < typeId then
        icon = self:createWishEquipIcon(typeId, isSuccess)
        icon:setPosition(ccp(45, 45))
        targetNode:addChild(icon)
      end
      self["selectNormalEquipIcon" .. index] = icon
    end
  end
end

function class:createWishEquipIcon(typeId, isSuccess)
  local icon = ed.readequip.createBasicLegendEquipIcon(typeId)
  if isSuccess == 1 then
    ed.legendEquipTool.createSuccessMask(icon)
  end
  return icon
end

function class:refreshForgeList()
  self.forgeSmelterItemList = {}
  self.forgeDragList:clearList()
  CloseTimer("ForgeListUpdate")
  local panelSize = self.ui.panel_forge_list:getContentSize()
  local listPosX, listPosY = self.forgeDragList:getListPos()
  local totalHeight = 0
  for queueId, queueCfg in ipairs(ed.getDataTable("LegendEquipForgeQueue")) do
    local queue = self.mgr:getForgeQueueByQueueId(queueId)
    local container, ui = self:createForgeSmelter(queueId, panelSize.width)
    local size = container:getContentSize()
    self.forgeDragList:addItem(container)
    container:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight - size.height / 2))
    totalHeight = totalHeight + size.height
    table.insert(self.forgeSmelterItemList, {
      container = container,
      ui = ui,
      queue = queue,
      queueId = queueId
    })
    if not queue then
      break
    end
  end
  self.forgeDragList:initListHeight(totalHeight)
  if 0 < listPosY then
    self.forgeDragList:setListPos(ccp(listPosX, listPosY))
  end
  self:listenTimer(Timer:Always(1, "ForgeListUpdate"), function()
    self:refreshAllForgeSmelterTime()
  end)
  self:showForgeQueueUnlockAnim()
  self:showForgeItemUnlockAnim()
end

function class:showForgeQueueUnlockAnim()
  for index, forgeSmelterItem in ipairs(self.forgeSmelterItemList) do
    local queueId = forgeSmelterItem.queueId
    local queue = forgeSmelterItem.queue
    if not self.unlockQueueList[queueId] and queue then
      self.unlockQueueList[queueId] = true
      local ui = forgeSmelterItem.ui
      local unlock_eff = ed.createFcaNode("eff_UI_fireforge_Unlock_1")
      unlock_eff:setAction("Start")
      self:addFcaOnce(unlock_eff)
      ui.image_bg:addChild(unlock_eff)
      unlock_eff:setPosition(ccp(ui.image_unlock_tips:getPositionX() - 149, 52))
      ui.image_unlock_tips:setVisible(true)
      ui.image_unlock_tips:setCascadeOpacityEnabled(true)
      ui.image_unlock_tips:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCFadeTo:create(0.8, 0))))
      ui.btn_forge:setVisible(true)
      ui.btn_forge:setCascadeOpacityEnabled(true)
      ui.btn_forge:setOpacity(0)
      ui.btn_forge:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(1.1), CCFadeTo:create(0.5, 255))))
      ui.icon_cost:setVisible(true)
      ui.icon_cost:setCascadeOpacityEnabled(true)
      ui.icon_cost:setOpacity(0)
      ui.icon_cost:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(1.1), CCFadeTo:create(0.5, 255))))
      local forgeItemList = forgeSmelterItem.container.forgeItemList
      for _, forgeItemCfg in ipairs(forgeItemList or {}) do
        local forgeItemUI = forgeItemCfg.ui
        local isUnlock = forgeItemCfg.isUnlock
        local fieldID = forgeItemCfg.fieldID
        forgeItemUI.image_bg:setCascadeOpacityEnabled(true)
        forgeItemUI.image_bg:setOpacity(0)
        local delay = CCDelayTime:create(1.1)
        local fade = CCFadeTo:create(0.5, 255)
        local callFunc = CCCallFunc:create(function()
          self.unlockQueueItemList[queueId] = self.unlockQueueItemList[queueId] or 0
          if isUnlock then
            self.unlockQueueItemList[queueId] = self.unlockQueueItemList[queueId] + 1
          end
        end)
        forgeItemUI.image_bg:runAction(CCSequence:create(ccArrayMake(delay, fade, callFunc)))
      end
    end
  end
end

function class:showForgeItemUnlockAnim()
  for index, forgeSmelterItem in ipairs(self.forgeSmelterItemList) do
    local queueId = forgeSmelterItem.queueId
    local queue = forgeSmelterItem.queue
    if queue then
      local forgeItemList = forgeSmelterItem.container.forgeItemList
      local unlockAmount = 0
      for _, forgeItemCfg in ipairs(forgeItemList or {}) do
        local forgeItemUI = forgeItemCfg.ui
        local isUnlock = forgeItemCfg.isUnlock
        local fieldID = forgeItemCfg.fieldID
        if isUnlock then
          unlockAmount = unlockAmount + 1
        end
        local isNew
        if self.unlockQueueItemList[queueId] and unlockAmount > self.unlockQueueItemList[queueId] then
          isNew = true
        end
        if isNew and isUnlock then
          self.unlockQueueItemList[queueId] = self.unlockQueueItemList[queueId] + 1
          local forgeQueueItemCfg = ed.getDataTable("LegendEquipForgeQueue")[queueId][fieldID]
          local effName
          if forgeQueueItemCfg["Unlock Type"] == "Month Card" or forgeQueueItemCfg["Unlock Type"] == "Diamond" then
            effName = "eff_UI_fireforge_Unlock_3"
          else
            effName = "eff_UI_fireforge_Unlock_2"
          end
          forgeItemUI.image_lock:setVisible(false)
          local spine = ed.createSpine(string.format("effect/%s/%s", effName, effName), 0.5)
          forgeItemUI.image_bg:addChild(spine)
          spine:setAnimation(0, "Idle", false)
          spine:setPosition(ccp(47.5, 47.5))
        end
      end
    end
  end
end

function class:refreshAllForgeSmelterTime()
  for index, forgeSmelterItem in ipairs(self.forgeSmelterItemList) do
    forgeSmelterItem.container:refreshForgeSmelterTime()
  end
end

function class:createForgeSmelter(queueId, width)
  local container, ui = ed.editorui(ed.uieditor.fire_forge_smelter)
  ed.setLabelStroke(ui.label_title, ed.toccc3(0), 1)
  ed.setLabelStroke(ui.label_total_time, ed.toccc3(0), 1)
  local label_forge = ed.ui.gradientLabel.create({
    text = T("\233\148\187\233\128\160"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(10572575)
  })
  ui.btn_forge:addChild(label_forge.node)
  ed.layout.centerInParent(label_forge.node)
  local forgeItemList = {}
  
  local function refreshForgeSmelterTime()
    local totalTime = 0
    for index, itemCfg in ipairs(forgeItemList) do
      local leftTime, isNew = itemCfg.item:refreshForgeItem()
      totalTime = totalTime + (leftTime or 0)
      if isNew then
        ed.legendEquipNet.sendForgePanel()
      end
    end
    local hour = math.floor(totalTime % 86400 / 3600)
    local min = math.floor(totalTime % 3600 / 60)
    local second = math.floor(totalTime % 60)
    if hour < 1 then
      ed.setLabelString(ui.label_total_time, string.format(T("\233\148\187\233\128\160\230\128\187\230\151\182\233\149\191\239\188\154%s\229\136\134%s\231\167\146"), min, second))
    else
      ed.setLabelString(ui.label_total_time, string.format(T("\233\148\187\233\128\160\230\128\187\230\151\182\233\149\191\239\188\154%s\229\176\143\230\151\182%s\229\136\134"), hour, min))
    end
    ui.btn_skip_all:setVisible(totalTime ~= 0)
    ui.label_total_time:setVisible(totalTime ~= 0)
  end
  
  container.refreshForgeSmelterTime = refreshForgeSmelterTime
  container.forgeItemList = forgeItemList
  local bgSize = ui.image_bg:getContentSize()
  local changeWidth = width - bgSize.width
  ui.image_bg:setContentSize(CCSizeMake(width, bgSize.height))
  container:setContentSize(ui.image_bg:getContentSize())
  local oldPanelSize = ui.panel_list:getContentSize()
  ui.panel_list:setContentSize(CCSizeMake(oldPanelSize.width + changeWidth, oldPanelSize.height))
  ui.icon_cost:setPositionX(ui.icon_cost:getPositionX() + changeWidth)
  ui.btn_forge:setPositionX(ui.btn_forge:getPositionX() + changeWidth)
  ui.image_unlock_tips:setPositionX(ui.image_unlock_tips:getPositionX() + changeWidth / 2)
  ed.setLabelString(ui.label_title, string.format(T("\232\191\156\229\143\164\231\134\148\231\130\137")))
  local imageNum = ed.createSprite(string.format("UI/alpha/1080P/fireforge/%s.png", queueId))
  ui.label_title:addChild(imageNum)
  imageNum:setPosition(ccp(ui.label_title:getContentSize().width + imageNum:getContentSize().width / 2, 8))
  ed.right2(ui.label_total_time, ui.label_title, 40)
  ed.right2(ui.btn_skip_all, ui.label_total_time, 10)
  local curItemAmount, needAmount = self.mgr:getForgeNeedItemAmount()
  ed.setLabelString(ui.label_cost_amount, needAmount)
  ed.setLabelColor(ui.label_cost_amount, needAmount <= curItemAmount and ccc3(255, 252, 231) or ed.toccc3(16735324))
  local queue = self.mgr:getForgeQueueByQueueId(queueId)
  if queue then
    ui.image_unlock_tips:setVisible(false)
    local pressX, pressY
    local dragList = ed.UITool.createDraglist(ui.panel_list, {
      priority = -299,
      swallow = false,
      doPressIn = function(x, y)
        if not ed.containsPoint(self.ui.panel_forge_list, x, y) then
          return
        end
        if not ed.containsPoint(ui.panel_list, x, y) then
          return
        end
        pressX, pressY = x, y
        for _, forgeItemUI in ipairs(forgeItemList) do
          if ed.containsPoint(forgeItemUI.ui.image_bg, x, y) then
            return forgeItemUI
          end
        end
      end,
      doClickIn = function(x, y, item)
        if pressX and math.abs(pressX - x) > 20 or math.abs(pressY - y) > 20 then
          return
        end
        self:onClickForgeItem(x, y, item)
      end
    })
    local unlockPosList = queue._unlock_pos or {}
    local panelSize = ui.panel_list:getContentSize()
    local totalWidth = 0
    local forgeQueueItemCfgList = {}
    local lastUnlockPos = 1
    local realUnlockAmount = 0
    for fieldID, forgeQueueItemCfg in ipairs(ed.getDataTable("LegendEquipForgeQueue")[queueId]) do
      if unlockPosList[fieldID] == 1 or forgeQueueItemCfg["Unlock Type"] == "Month Card" and lastUnlockPos <= #queue._forge_list then
        table.insert(forgeQueueItemCfgList, lastUnlockPos, forgeQueueItemCfg)
        lastUnlockPos = lastUnlockPos + 1
      else
        table.insert(forgeQueueItemCfgList, forgeQueueItemCfg)
      end
      if unlockPosList[fieldID] == 1 then
        realUnlockAmount = realUnlockAmount + 1
      end
    end
    for index, forgeQueueItemCfg in ipairs(forgeQueueItemCfgList) do
      local fieldID = forgeQueueItemCfg["Field ID"]
      local isUnlock = unlockPosList[fieldID] == 1 or forgeQueueItemCfg["Unlock Type"] == "Month Card" and realUnlockAmount < #queue._forge_list
      local forgeItem = queue._forge_list[index]
      local item, itemUI = self:createForgeItem(forgeItem, forgeQueueItemCfg, isUnlock)
      local size = item:getContentSize()
      dragList:addItem(item)
      item:setPosition(ccp(totalWidth + size.width / 2, panelSize.height / 2))
      totalWidth = totalWidth + size.width + 8
      table.insert(forgeItemList, {
        item = item,
        fieldID = fieldID,
        ui = itemUI,
        isUnlock = isUnlock,
        forgeItem = forgeItem,
        queueId = queueId,
        queue = queue
      })
    end
    dragList:initListWidth(totalWidth)
    refreshForgeSmelterTime()
  else
    ui.image_unlock_tips:setVisible(true)
    ui.label_total_time:setVisible(false)
    ui.btn_forge:setVisible(false)
    ui.icon_cost:setVisible(false)
    ui.btn_skip_all:setVisible(false)
  end
  local autoText = ed.ui.autoText.new()
  local path = string.format("UI/alpha/1080P/fireforge/%s.png", queueId)
  autoText:initParam({
    context = string.format(T("\232\191\156\229\143\164\231\134\148\231\130\137<sprite src=%s>\239\188\136\231\130\185\229\135\187\229\143\175\232\180\173\228\185\176\239\188\137"), path),
    fontSize = 18,
    color = ed.toccc3(10585741),
    maxWidth = 999
  })
  local w, h = autoText:getCurContentSize()
  autoText.node:setCascadeOpacityEnabled(true)
  ui.image_unlock_tips:addChild(autoText.node)
  local unlockTipsBgSize = ui.image_unlock_tips:getContentSize()
  autoText.node:setPosition(ccp(unlockTipsBgSize.width / 2 - w / 2 + 20, unlockTipsBgSize.height / 2))
  return container, ui
end

function class:refreshMustGet()
  local normalTimes = self.mgr:getNormalTimes()
  self.ui.image_mustget_bg:removeAllChildrenWithCleanup(true)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format(T("\229\135\186\231\130\137<lable fontSize=f24 color=ccc3(254,206,119)> %s </lable>\230\172\161\229\191\133\229\135\186<lable fontSize=f24 color=ccc3(254,206,119)> \230\149\180\232\163\133</lable>"), normalTimes),
    maxWidth = 999,
    fontSize = 18,
    fontName = ed.fontBold,
    color = ed.toccc3(12994375),
    strokeColor = ed.toccc3(2819599),
    strokeSize = 1
  })
  self.ui.image_mustget_bg:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  local bgSize = self.ui.image_mustget_bg:getContentSize()
  autoText.node:setPosition(ccp(bgSize.width / 2 - w / 2 - 15, bgSize.height / 2 - 6))
end

function class:refreshBuffIcon()
  local targetTimes = ed.legendEquipDefine.Forge_Buff_Times
  local curTimes = self.mgr:getFirstOnlyTimes()
  if targetTimes <= curTimes then
    local finishTime = ed.storage.getInt(ed.getRoleKey("Forge_Buff_Finish_Time"))
    local serverTime = ed.getServerTime()
    if finishTime and 0 < finishTime and ed.checkTwoDateod(finishTime, serverTime) then
      self.ui.image_buff_icon_bg:setVisible(false)
      self.ui.btn_record:setPositionY(self.ui.image_buff_icon_bg:getPositionY())
    else
      self.ui.btn_record:setPositionY(self.btn_recordPosY)
      self.ui.image_buff_icon_bg:setVisible(true)
      self.ui.image_buff_icon:setColor(ccc3(127, 127, 127))
      ed.storage.setValue(ed.getRoleKey("Forge_Buff_Finish_Time"), serverTime)
      self.ui.image_buff_finish:setVisible(true)
    end
  else
    self.ui.image_buff_finish:setVisible(false)
  end
end

function class:onClickForgeItem(x, y, item)
  local queueId = item.queueId
  local queue = item.queue
  local forgeItem = item.forgeItem
  local isUnlock = item.isUnlock
  local ui = item.ui
  local fieldID = item.fieldID
  local forgeQueueCfg = ed.getDataTable("LegendEquipForgeQueue")[queueId][fieldID]
  if not isUnlock then
    local unlockType = forgeQueueCfg["Unlock Type"]
    local unlockCfg = ed.legendEquipTool.forge_item_unlock_cfg[unlockType]
    ed.UITool.openView("fireForeConfirmWindow", {
      costType = unlockCfg.costType,
      costAmount = type(unlockCfg.costAmount) == "function" and unlockCfg.costAmount(forgeQueueCfg) or unlockCfg.costAmount,
      costId = type(unlockCfg.costId) == "function" and unlockCfg.costId(forgeQueueCfg) or unlockCfg.costId,
      title = T("\232\167\163\233\148\129\230\160\143\228\189\141"),
      desc = type(unlockCfg.desc) == "function" and unlockCfg.desc(forgeQueueCfg) or unlockCfg.desc,
      rightHandler = function()
        unlockCfg.confirmHandler(forgeQueueCfg)
      end
    })
  elseif forgeItem then
    local serverTime = ed.getServerTime()
    if serverTime < forgeItem._start_time then
      ed.showToast(T("\231\173\137\229\190\133\233\148\187\233\128\160\228\184\173"))
    elseif serverTime < forgeItem._end_time then
      self:showSpeedUpForgeItem(forgeItem, queueId)
    else
      ed.legendEquipNet.sendLottery(queue._queue_id)
    end
  end
end

function class:showSpeedUpQueue(queue)
  ed.UITool.openView("fireForgeSpeedUpWindow", {
    queueId = queue._queue_id,
    type = "all"
  })
end

function class:showSpeedUpForgeItem(forgeItem, queueId)
  ed.UITool.openView("fireForgeSpeedUpWindow", {queueId = queueId, type = "one"})
end

function class:createForgeItem(forgeItem, forgeItemCfg, isUnlock)
  local container, ui = ed.editorui(ed.uieditor.fire_forge_smelter_item)
  container:setContentSize(ui.image_bg:getContentSize())
  container.isCompleted = false
  
  local function refreshForgeItem()
    if not forgeItem then
      return
    end
    local serverTime = ed.getServerTime()
    local totalTime = ed.getDataTable("LegendEquipForgeParam")["Forge Time"]["Param Content 1"]
    local itemLeftTime = 0
    local isNew = false
    if serverTime < forgeItem._start_time then
      itemLeftTime = totalTime
    elseif serverTime < forgeItem._end_time then
      local clipSize = ui.bar_clip:getContentSize()
      itemLeftTime = forgeItem._end_time - ed.getServerTime()
      ui.bar_clip:setClipRect(CCRectMake(0, 0, itemLeftTime / totalTime * clipSize.width, clipSize.height))
      local hour = math.floor(itemLeftTime % 86400 / 3600)
      local min = math.floor(itemLeftTime % 3600 / 60)
      local second = math.floor(itemLeftTime % 60)
      ed.setLabelString(ui.label_left_time, string.format("%.2d:%.2d:%.2d", hour, min, second))
      ui.btn_skip_one:setVisible(true)
      ui.image_bar_bg:setVisible(true)
    else
      ui.image_light:setVisible(true)
      ui.image_success_eff:setVisible(true)
      if not container.isCompleted then
        isNew = true
      end
      container.isCompleted = true
    end
    return itemLeftTime, isNew
  end
  
  container.refreshForgeItem = refreshForgeItem
  ui.bar_clip:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelStroke(ui.label_left_time, ed.toccc3(3364106), 1)
  local type = forgeItemCfg["Unlock Type"]
  if type == "Month Card" or type == "Diamond" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/fireforge/forge2_empty.png")
    ed.setTexture(ui.image_lock, "UI/alpha/1080P/fireforge/forge2_lock.png")
  end
  if isUnlock then
    ui.image_lock:setVisible(false)
    if forgeItem then
      local icon = ed.createSprite("UI/alpha/1080P/fireforge/art2.jpg")
      local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_orange.png")
      icon:addChild(frame)
      ed.layout.centerInParent(frame)
      ui.image_bg:addChild(icon)
      ed.layout.centerInParent(icon)
      ui.image_light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
      local image_success_eff = ed.createSprite("UI/alpha/1080P/fireforge/to_jpg_x_alpha/art.png")
      icon:addChild(image_success_eff)
      ed.layout.centerInParent(image_success_eff)
      ui.image_success_eff = image_success_eff
      image_success_eff:setVisible(false)
      local blendFunc = ccBlendFunc()
      blendFunc.src = GL_ONE
      blendFunc.dst = GL_ONE
      image_success_eff:setBlendFunc(blendFunc)
      image_success_eff:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCFadeTo:create(2.5, 0), CCFadeTo:create(1.5, 204)))))
      refreshForgeItem()
    end
  else
    ui.image_lock:setVisible(true)
    ui.image_forge_item:setVisible(false)
    ui.image_bar_bg:setVisible(false)
    ui.btn_skip_one:setVisible(false)
  end
  return container, ui
end

function class:checkForge(queueId)
  local emptyForgeItemAmount = self.mgr:getForgeItemStateAmount(queueId)
  local curItemAmount, needAmount = self.mgr:getForgeNeedItemAmount()
  if emptyForgeItemAmount == 0 then
    ed.showToast(T("\229\183\178\230\151\160\231\169\186\231\154\132\233\148\187\233\128\160\230\160\143\228\189\141"))
    return false
  end
  if curItemAmount < needAmount then
    ed.showToast(T("\230\157\144\230\150\153\228\184\141\232\182\179"))
    local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Need"]["Param Content 1"]
    ed.UITool.openView("packageDetail", {id = itemId})
    return false
  end
  return true
end

function class:checkGetForge()
  local successAmount = 0
  local serverTime = ed.getServerTime()
  for _, queue in pairs(self.mgr:getAllForgeQueue()) do
    local forgeList = queue._forge_list
    for index, forgeItem in ipairs(forgeList) do
      if serverTime >= forgeItem._end_time then
        successAmount = successAmount + 1
      end
    end
  end
  if successAmount == 0 then
    ed.showToast(T("\230\154\130\230\151\160\229\143\175\233\162\134\229\143\150\231\154\132\233\148\187\233\128\160\231\187\147\230\158\156"))
    return false
  end
  return true
end

function class:onClickBtnBack()
  if self.forgeBoardOpen then
    return
  end
  ed.popScene()
end

function class:onClickBtnShop()
  if self.forgeBoardOpen then
    return
  end
  ed.UITool.openView("legendEquipShopScene")
end

function class:onClickBtnBackBag()
  if self.forgeBoardOpen then
    return
  end
  ed.UITool.openView("fireForgePackageScene")
end

function class:onClickBtnBook()
  if self.forgeBoardOpen then
    return
  end
  ed.UITool.openView("fireForgeHandbookScene")
end

function class:onClickBtnWishChange()
  if self.forgeBoardOpen then
    return
  end
  ed.UITool.openView("fireForgeWishWindow")
end

function class:onClickForgeBoard()
  self.forgeBoardOpen = not self.forgeBoardOpen
  if self.forgeBoardOpen then
    ed.playEffect(ed.sound.deo.fire_forge_list1)
  else
    ed.playEffect(ed.sound.deo.fire_forge_list2)
  end
  self:showForgeBoardAnim()
end

function class:refreshForgeListClipRect()
  local panelSize = self.ui.panel_forge_list:getContentSize()
  local clipHeight = ed.getWorldPos(self.ui.panel_forge_list).y + panelSize.height
  clipHeight = math.min(clipHeight, panelSize.height)
  self.forgeDragList:setClipRect(CCRectMake(0, 0, panelSize.width, clipHeight))
end

function class:showForgeBoardAnim()
  self.forgeDragList.clipLayer:stopAllActions()
  self.ui.image_forge_bg:stopAllActions()
  self.ui.image_forge_chain_left:stopAllActions()
  self.ui.image_forge_chain_right:stopAllActions()
  self.ui.image_arrow:stopAllActions()
  local action = CCRepeatForever:create(CCSequence:create(ccArrayMake(CCCallFunc:create(function()
    self:refreshForgeListClipRect()
  end))))
  self.forgeDragList.clipLayer:runAction(action)
  local targetPosY1 = self.forgeBoardOpen and self.image_forge_bg_max_posY or self.image_forge_bg_min_posY
  local moveAction = CCEaseBackOut:create(CCMoveTo:create(0.5, ccp(self.ui.image_forge_bg:getPositionX(), targetPosY1)))
  local callFunc = CCCallFunc:create(function()
    self.forgeDragList.listLayer:stopAllActions()
  end)
  self.ui.image_forge_bg:runAction(CCSequence:create(ccArrayMake(moveAction, callFunc)))
  local targetPosY2 = self.forgeBoardOpen and self.forge_chain_max_posY or self.forge_chain_min_posY
  self.ui.image_forge_chain_left:runAction(CCEaseBackOut:create(CCMoveTo:create(0.5, ccp(self.ui.image_forge_chain_left:getPositionX(), targetPosY2))))
  self.ui.image_forge_chain_right:runAction(CCEaseBackOut:create(CCMoveTo:create(0.5, ccp(self.ui.image_forge_chain_right:getPositionX(), targetPosY2))))
  self.ui.image_arrow:runAction(CCSequence:create(ccArrayMake(CCRotateTo:create(0.2, self.forgeBoardOpen and 180 or 0), CCCallFunc:create(function()
    self.ui.image_arrow:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(3, 127), CCFadeTo:create(3, 255))))
  end))))
end

function class:onClickBtnGetAll()
  if self:checkGetForge() then
    ed.legendEquipNet.sendOneKeyLottery()
  end
end

function class:onClickBtnForgeAll()
  if self:checkForge() then
    self:showOneKeyForgeAnim(function()
      ed.legendEquipNet.sendOneKeyForge()
    end)
  end
end

function class:onClickBuffIcon()
  if self.forgeBoardOpen then
    return
  end
  local targetTimes = ed.legendEquipDefine.Forge_Buff_Times
  local curTimes = self.mgr:getFirstOnlyTimes()
  if targetTimes <= curTimes then
    ed.showToast(T("\229\183\178\229\135\186\231\130\137\232\191\135\229\148\175\228\184\128\232\163\133\229\164\135\230\149\180\232\163\133\239\188\140\231\165\157\231\166\143\230\182\136\229\164\177"))
    return
  end
  local tipsPanel = ed.ui.fireForgeBuffTipsWindow.create()
  tipsPanel:popWindow()
  ed.layout.relateLayout(self.ui.image_buff_icon_bg, tipsPanel.bg, {
    left = self.ui.image_buff_icon_bg:getContentSize().width + 50,
    bottom = 50
  }, true)
end

function class:onClickBtnRule()
  if self.forgeBoardOpen then
    return
  end
  ed.ui.commonRulePop.create({
    title = T("\232\175\180\230\152\142"),
    txt = ed.legendEquipDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickBtnRecord()
  ed.UITool.openView("forgingRecordWindow")
end

function class:getPressHandler()
  local function handler(param, x, y)
    if ed.containsPoint(self.ui.panel_touch_area, x, y) then
      self.pressInTouchArea = true
      
      self.startPressY = y
      self.start_forge_bg_Y = self.ui.image_forge_bg:getPositionY()
      self.start_chain_left_Y = self.ui.image_forge_chain_left:getPositionY()
      self.start_chain_right_Y = self.ui.image_forge_chain_right:getPositionY()
    end
  end
  
  return handler
end

function class:getMoveHandler()
  local function handler(param, x, y)
    if self.startPressY then
      local offsetY = y - self.startPressY
      
      local targetPosY = self.start_forge_bg_Y + offsetY
      targetPosY = math.min(targetPosY, self.image_forge_bg_max_posY)
      targetPosY = math.max(targetPosY, self.image_forge_bg_min_posY)
      self.ui.image_forge_bg:setPositionY(targetPosY)
      self.ui.image_forge_chain_left:setPositionY(self.start_chain_left_Y + targetPosY - self.start_forge_bg_Y)
      self.ui.image_forge_chain_right:setPositionY(self.start_chain_right_Y + targetPosY - self.start_forge_bg_Y)
      self:refreshForgeListClipRect()
    end
  end
  
  return handler
end

function class:getCancelPressHandler()
  local function handler(param, x, y)
    self.startPressY = nil
    
    self.startY = nil
    local curPosY = self.ui.image_forge_bg:getPositionY()
    if curPosY < self.image_forge_bg_min_posY + (self.image_forge_bg_max_posY - self.image_forge_bg_min_posY) * 3 / 4 and self.forgeBoardOpen then
      self.forgeBoardOpen = false
    elseif curPosY > self.image_forge_bg_min_posY + (self.image_forge_bg_max_posY - self.image_forge_bg_min_posY) / 4 and not self.forgeBoardOpen then
      self.forgeBoardOpen = true
    end
    self:showForgeBoardAnim()
  end
  
  return handler
end

function class:addTouchEvent()
  self:btRegisterClick({
    key = "panel_touch_area",
    pressHandler = self:getPressHandler(),
    moveHandler = self:getMoveHandler(),
    cancelPressHandler = self:getCancelPressHandler(),
    force = true
  })
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_shop", function()
    self:onClickBtnShop()
  end, {pressScale = 0.85, normalScale = 0.9})
  ed.UITool.registerBtn(self, "btn_backbag", function()
    self:onClickBtnBackBag()
  end, {pressScale = 0.85, normalScale = 0.9})
  ed.UITool.registerBtn(self, "btn_book", function()
    self:onClickBtnBook()
  end, {pressScale = 0.85, normalScale = 0.9})
  ed.UITool.registerBtn(self, "btn_wishlist_change", function()
    self:onClickBtnWishChange()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_wish_only_equip", function()
    self:onClickBtnWishChange()
  end, {normalScale = 0.8, pressScale = 0.75})
  for index = 1, ed.legendEquipDefine.Wish_Normal_Equip_Amount do
    ed.UITool.registerBtn(self, "image_wish_normal_equip_" .. index, function()
      self:onClickBtnWishChange()
    end, {normalScale = 0.8, pressScale = 0.75})
  end
  ed.UITool.registerBtn(self, "image_arrow", function()
    self:onClickForgeBoard()
  end)
  ed.UITool.registerBtn(self, "panel_forge_title", function()
    self:onClickForgeBoard()
  end)
  ed.UITool.registerBtn(self, "btn_get_all", function()
    self:onClickBtnGetAll()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_forge_all", function()
    self:onClickBtnForgeAll()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_buff_icon_bg", function()
    self:onClickBuffIcon()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95, priority = -2})
  ed.UITool.registerBtn(self, "btn_record", function()
    self:onClickBtnRecord()
  end, {pressScale = 0.85, normalScale = 0.8})
end

function class:onEnter()
  base.onEnter(self)
  if ed.storage.getBool(ed.getRoleKey("FireForgeStory")) then
    if ed.guide.data:isCanGuide(54) then
      ed.guide.manager:tryStartGuide(54)
    end
    if ed.guide.data:isCompleted(60) then
      self:checkNewLegendEquip()
    end
  else
    ed.showStory("FireForgeStory")
    self.mgr:saveNewLegendEquipTypeList("FireForgeNewEquipTipsWindow")
  end
  local valid = ed.player:isMonthCardValid("payed")
  if self.payedMonthCardValid ~= valid then
    self.payedMonthCardValid = valid
    ed.legendEquipNet.sendForgePanel()
  end
  self.ui.btn_shop_new:setVisible(ed.legendEquipTool.getIsShowLegendEquipShopNew())
end

function class:checkNewLegendEquip()
  local key = "FireForgeNewEquipTipsWindow"
  if self.mgr:checkNewLegendEquip(key) then
    ed.UITool.openView("fireForgeNewEquipWindow")
    self.mgr:saveNewLegendEquipTypeList(key)
  end
end

function class:onStoryEnd(storyName)
  if storyName == "FireForgeStory" and ed.guide.data:isCanGuide(54) then
    ed.guide.manager:tryStartGuide(54)
  end
end

function class:addEventListen()
  self:listenEvent("StoryEnd", function(name)
    self:onStoryEnd(name)
  end)
  self:listenEvent("FireForgeForgeEquip", function()
    self:refreshUI()
  end)
  self:listenEvent("FireForgeLottery", function()
    self:refreshUI()
  end)
  self:listenEvent("FireForgeSetWish", function()
    self:refreshWishList()
  end)
  self:listenEvent("FireForgeUpdateQueue", function()
    self:refreshUI()
  end)
end

function class:getGuideNode(nodeKey)
  if nodeKey == "btn_forge" then
    return self.forgeSmelterItemList[1].ui.btn_forge
  elseif nodeKey == "btn_speed_up" then
    return self.forgeSmelterItemList[1].container.forgeItemList[1].item
  elseif nodeKey == "btn_get" then
    return self.forgeSmelterItemList[1].container.forgeItemList[1].item
  elseif nodeKey == "btn_wish" then
    return self.ui.btn_wishlist_change
  end
  return base.getGuideNode(self, nodeKey)
end
