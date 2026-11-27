local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.fireworkShopScene = class
local getResType = ed.ui.configs.resType.getResType
ed.UITool.registViewOpenFunc("fireworkShopScene", function(param)
  ed.nianMonsterNet.sendOpenPanel()
  ListenEventOnce("nianMonsterOpenPanel", function()
    local scene = class.create(param)
    ed.pushScene(scene)
  end)
end)

function class.create(param)
  local self = base.create("fireworkShopScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.goodsGroupId = param.goodsGroupId or 1
  self.nianMonsterActId = param.nianMonsterActId or 1
  self.nianMonsterGoodsTB = ed.getDataTable("NianMonsterGoods")
  self.mgr = ed.nianMonsterMgr.getInstance()
  self.uiEditorConfig = self.mgr:getActivityUIConfig()
  self.uiType = self.uiEditorConfig.type
  self.uiList = {}
  self:initUI()
  self:adaptUI()
  self:refreshUI()
  self:addTouchEvent()
  self:addListenEvent()
  ed.redPointMgr.getInstance():setNodeValue("nian_monster_has_new_goods", 0)
end

function class:initUI()
  local container, ui = ed.editorui(self.uiEditorConfig.shopSceneCfg.sceneUIEditor)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  self:setBackground()
  self:initHero()
  self:initDragList()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(13794820), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  local offsetX = 8
  local breathAction1 = CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(offsetX, 0)), CCMoveBy:create(1, ccp(-offsetX, 0))))
  self.ui.image_arrow_left:runAction(CCRepeatForever:create(breathAction1))
  local breathAction2 = CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(-offsetX, 0)), CCMoveBy:create(1, ccp(offsetX, 0))))
  self.ui.image_arrow_right:runAction(CCRepeatForever:create(breathAction2))
end

function class:initHero()
  if self.uiType == "Nian" then
    local lamp1 = ed.createSpine("effect/eff_UI_Nian_shop_lamp/eff_UI_Nian_shop_lamp", 0.5)
    lamp1:setAnimation(0, "Idle", true)
    self.ui.image_bg:addChild(lamp1)
    lamp1:setPosition(ccp(327.5, 596.5))
    local lamp2 = ed.createSpine("effect/eff_UI_Nian_shop_lamp/eff_UI_Nian_shop_lamp", 0.5)
    lamp2:setScaleX(-1)
    lamp2:setAnimation(0, "Idle", true)
    self.ui.image_bg:addChild(lamp2)
    lamp2:setPosition(ccp(1028.5, 596.5))
    local actionList = {
      {
        action = "Idle",
        bubbleText = T("\232\137\186\230\156\175\229\176\177\230\152\175\231\136\134\231\130\184")
      },
      {action = "Idle2"},
      {
        action = "Idle3",
        bubbleText = T("\232\175\180\233\131\189\230\152\175\228\184\138\231\173\137\232\180\167\239\188\140\232\181\176\232\191\135\232\183\175\232\191\135\228\184\141\232\166\129\233\148\153\232\191\135\229\147\166")
      }
    }
    self.actionList = actionList
    local puppet = ed.createSpine("effect/eff_UI_Nian_shop_Lina/eff_UI_Nian_shop_Lina", 0.7)
    self.puppet = puppet
    self.ui.panel_hero:addChild(puppet, 10)
    puppet:setPosition(ccp(-225, -135))
    puppet:setAnimation(0, "Idle", true)
  else
    local actionList = {
      {
        action = "Idle",
        bubbleText = T("\230\172\162\232\191\142\230\157\165\229\136\176\229\156\176\231\139\177\227\128\130")
      },
      {
        action = "Idle2",
        bubbleText = T("\230\156\137\229\147\129\229\145\179\239\188\129")
      },
      {
        action = "Idle3",
        bubbleText = T("\229\165\189\229\165\189\231\158\167\231\158\167\239\188\140\229\133\168\230\152\175\231\130\188\231\139\177\228\184\173\230\183\152\230\157\165\231\154\132\229\176\150\232\180\167\239\188\129")
      }
    }
    self.actionList = actionList
    local puppet = ed.createSpine("effect/eff_UI_Nian_shop_TB/eff_UI_Nian_shop_TB", 0.5)
    self.puppet = puppet
    self.ui.panel_hero:addChild(puppet, 10)
    puppet:setPosition(ccp(50, 0))
    puppet:setAnimation(0, "Idle", true)
  end
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 17})
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    doScroll = function()
      self:refreshArrow()
    end,
    priority = -300
  })
end

function class:getPressInHandler()
  local function handler(x, y)
    for _, ui in ipairs(self.uiList or {}) do
      if ed.containsPoint(ui.btn_buy, x, y) or ed.containsPoint(ui.panel_item, x, y) then
        return ui
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, ui)
    local itemId = ui.itemId
    
    if ed.containsPoint(ui.btn_buy, x, y) and ed.checkVisible(ui.btn_buy) then
      self:onClickBuyBtn(itemId)
    elseif ed.containsPoint(ui.panel_item, x, y) then
      self:onClickBuyBtn(itemId)
    end
  end
  
  return handler
end

function class:onClickBuyBtn(itemId)
  local itemCfg = self.nianMonsterGoodsTB[self.goodsGroupId][itemId]
  local itemInfo = self.mgr:getItemInfo(itemId)
  local buyTime = itemInfo._buy_time or 0
  local price = itemCfg.Price
  local buyLimit = itemCfg["Daily Buy Times"]
  local launchTime = itemInfo._launch_time or 0
  local isUnlock = launchTime <= ed.getServerTime()
  if buyLimit - buyTime <= 0 then
    self:showBubble(T("\229\141\150\229\133\137\228\186\134\239\188\140\230\152\142\229\164\169\229\134\141\230\157\165\229\144\167"))
    return
  end
  if not isUnlock then
    ed.showToast(T("\229\176\154\230\156\170\229\188\128\230\148\190\232\180\173\228\185\176"))
    return
  end
  local buyResourceBox = ed.ui.buyResourceBox.create({
    buyLimitNum = math.max(buyLimit - buyTime, 0),
    defaultBuyNum = 1,
    goodsResType = getResType("item"),
    goodsId = itemId,
    costResType = getResType(itemCfg["Price Type"]),
    price = price,
    buyAction = function(num)
      if num > math.max(buyLimit - buyTime, 0) then
        ed.showToast(T("\232\182\133\229\135\186\232\180\173\228\185\176\230\172\161\230\149\176\228\184\138\233\153\144"))
        return
      end
      ed.nianMonsterNet.sendBuyItem(itemId, num)
      ed.nianMonsterNet.sendOpenPanel()
      if itemCfg["Price Type"] == "Gold" then
        ed.player:addMoney(-num * price)
      elseif itemCfg["Price Type"] == "Diamond" then
        ed.player:subrmb(num * price)
      end
      self.puppet:setAnimation(0, "Idle2", true)
      self.puppet:addAnimation(0, "Idle", true)
    end
  })
  buyResourceBox:popWindow()
end

function class:refreshUI()
  self:refreshDraglist()
  self:refreshArrow()
end

function class:refreshDraglist()
  local listPosX, listPosY = self.dragList:getListPos()
  self.dragList:clearList()
  local row = 2
  local itemAmount = 0
  local offsetY = 37
  local size = CCSizeMake(0, 0)
  self.uiList = {}
  local itemList = {}
  for itemId, itemCfg in pairs(self.nianMonsterGoodsTB[self.goodsGroupId] or {}) do
    table.insert(itemList, {itemId = itemId, itemCfg = itemCfg})
  end
  table.sort(itemList, ed.cmpSort({
    {
      getValue = function(t)
        return t.itemCfg["Launch Time"]
      end
    },
    {key = "itemId"}
  }))
  for _, cfg in pairs(itemList) do
    local itemId = cfg.itemId
    local itemCfg = cfg.itemCfg
    itemAmount = itemAmount + 1
    local item, ui = self:createFireworkItem(itemId, itemCfg)
    ui.itemId = itemId
    table.insert(self.uiList, ui)
    self.dragList:addItem(item)
    size = item:getContentSize()
    local x = math.floor((itemAmount - 1) / row) * size.width + size.width / 2
    local y = itemAmount % row * size.height + offsetY
    item:setPosition(ccp(x, y))
  end
  local totalWidth = size.width * math.ceil(itemAmount / row)
  self.dragList:initListWidth(totalWidth)
  self.dragList:setListPos(ccp(listPosX, listPosY))
end

function class:createFireworkItem(itemId, itemCfg)
  local container, ui = ed.editorui(self.uiEditorConfig.shopSceneCfg.itemUIEditor)
  container:setContentSize(CCSizeMake(185, 185))
  local itemInfo = self.mgr:getItemInfo(itemId)
  local buyTime = itemInfo._buy_time or 0
  local launchTime = itemInfo._launch_time or 0
  ui.image_mask:setVisible(false)
  local buyLimit = itemCfg["Daily Buy Times"]
  local isSaleout = buyTime >= buyLimit
  local autoText = ed.ui.autoText.new()
  local labelColor = isSaleout and "ccc3(255,108,108)" or "ccc3(112,255,84)"
  local context = string.format(T("\228\187\138\230\151\165\233\153\144\232\180\173\239\188\154<lable color=%s>%s</lable>/%s"), labelColor, buyTime, buyLimit)
  autoText:initParam({
    context = context,
    color = ed.toccc3(16771782),
    fontSize = 15
  })
  ui.image_buy_limit_bg:addChild(autoText.node)
  autoText.node:setPosition(ccp(20, 10))
  ui.image_saleout:setVisible(isSaleout)
  local icon = ed.readequip.createIconWithAmount(itemId, nil, itemCfg["Item Amount"])
  ui.icon = icon
  ui.panel_item:addChild(icon)
  ed.layout.centerInParent(icon)
  local itemName = ed.getDataTable("equip")[itemId].Name
  ed.setLabelString(ui.label_name, itemName)
  ui.label_name:setFontName(ed.fontBold)
  local tokenIconPath = ed.readequip.getResourceRes(itemCfg["Price Type"])
  ed.setTexture(ui.image_cost_type, tokenIconPath, true)
  ed.setLabelString(ui.label_cost, itemCfg.Price)
  ed.setLabelStroke(ui.label_cost, ed.toccc3(10045188), 1)
  local isUnlock = launchTime <= ed.getServerTime()
  if isUnlock then
    ui.image_lock:setVisible(false)
    ui.btn_buy:setVisible(true)
    ui.label_unlock_time:setVisible(false)
  else
    ui.image_lock:setVisible(true)
    ui.btn_buy:setVisible(false)
    local year, month, day, hour, min, sec = ed.time2YMDHMS(launchTime)
    ui.label_unlock_time:setVisible(true)
    ed.setLabelString(ui.label_unlock_time, string.format(T("%s\230\156\136%s\230\151\165%.2d\230\151\182\232\167\163\233\148\129"), month, day, hour))
    ed.setLabelStroke(ui.label_unlock_time, ed.toccc3(6556672), 1)
  end
  if isSaleout or not isUnlock then
    ui.image_firework_shadow:setVisible(true)
  else
    ui.image_firework_shadow:setVisible(false)
  end
  return container, ui
end

function class:refreshArrow()
  local listX, listY = self.dragList:getListPos()
  local listWidth = self.dragList.listWidth
  if -20 < listX then
    self.ui.image_arrow_left:setVisible(false)
  else
    self.ui.image_arrow_left:setVisible(true)
  end
  if listX < self.ui.layer_item:getContentSize().width - listWidth + 20 then
    self.ui.image_arrow_right:setVisible(false)
  else
    self.ui.image_arrow_right:setVisible(true)
  end
end

function class:showBubble(text)
  if self.talkFrame then
    self.talkFrame:removeFromParentAndCleanup(true)
    self.talkFrame = nil
  end
  local param = {
    text = text,
    fontSize = 18,
    fontColor = ed.toccc3(16776423),
    res = "UI/alpha/1080P/nianmonster/nian_goods_shop_dialog.png",
    scale9rectMake = CCRectMake(40, 60, 20, 20),
    scale = 1,
    bubbleDelayTime = 2,
    bubbleFadeOutTime = 1,
    labelDelayTime = 2,
    labelFadeOutTime = 1,
    magin = {
      left = 10,
      right = 10,
      top = 10,
      bottom = 10
    },
    fadeOutEndCallBack = function()
      if not tolua.isnull(self.talkFrame) then
        self.talkFrame:removeFromParentAndCleanup(true)
        self.talkFrame = nil
      end
    end
  }
  local frame = ed.createDialogBubble(param)
  self.talkFrame = frame
  local parent = self.ui.image_bg
  parent:addChild(frame, 999)
  frame:setPosition(ccp(298, 435))
end

function class:onClickHero()
  local index = math.random(1, #self.actionList)
  local cfg = self.actionList[index]
  local actionName = cfg.action
  local bubbleText = cfg.bubbleText
  self.puppet:setAnimation(0, actionName, true)
  if actionName ~= "Idle" then
    self.puppet:addAnimation(0, "Idle", true)
  end
  if bubbleText then
    self:showBubble(bubbleText)
  end
end

function class:onClickArrowLeft()
  self.dragList.listLayer:stopAllActions()
  local posX, posY = self.dragList:getListPos()
  local moveDis = 234
  local targetPosX = math.min(posX + moveDis, 0)
  local moveAction = CCMoveTo:create(1, ccp(targetPosX, posY))
  local callFunc = CCCallFunc:create(function()
    self:refreshArrow()
  end)
  self.dragList.listLayer:runAction(CCSequence:create(ccArrayMake(moveAction, callFunc)))
end

function class:onClickArrowRight()
  self.dragList.listLayer:stopAllActions()
  local posX, posY = self.dragList:getListPos()
  local containerWidth = self.ui.layer_item:getContentSize().width
  local listWidth = self.dragList.listWidth
  local moveDis = 234
  local targetPosX = math.max(posX - moveDis, containerWidth - listWidth)
  local moveAction = CCMoveTo:create(1, ccp(targetPosX, posY))
  local callFunc = CCCallFunc:create(function()
    self:refreshArrow()
  end)
  self.dragList.listLayer:runAction(CCSequence:create(ccArrayMake(moveAction, callFunc)))
end

function class:addTouchEvent()
  self:btRegisterButtonClick({
    button = self.ui.panel_hero,
    key = "clickHero",
    clickHandler = function()
      self:onClickHero()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.ui.image_arrow_left,
    key = "image_arrow_left",
    clickHandler = function()
      self:onClickArrowLeft()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.ui.image_arrow_right,
    key = "image_arrow_right",
    clickHandler = function()
      self:onClickArrowRight()
    end,
    force = true
  })
end

function class:addListenEvent()
  self:listenEvent("nianMonsterOpenPanel", function()
    self:refreshUI()
  end)
end
