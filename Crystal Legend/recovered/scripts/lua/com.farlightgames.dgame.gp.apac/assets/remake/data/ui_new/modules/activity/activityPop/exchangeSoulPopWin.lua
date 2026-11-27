local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.ExchangeSoulPopWin = class
class.LOW_TOKEN_ID = 20142
class.HEIGHT_TOKEN_ID = 20143
class.STAR_TO_BAR_RES = {
  [1] = "UI/alpha/1080P/soulexchange/soulexchange_progress_blue.png",
  [2] = "UI/alpha/1080P/soulexchange/soulexchange_progress_purple.png",
  [3] = "UI/alpha/1080P/soulexchange/soulexchange_progress_orange.png"
}

function class.create(param)
  local self = base.create("ExchangeSoulPopWin")
  setmetatable(self, class.mt)
  self.soulExchangeGroup = param.soulExchangeGroup or 1
  self.closeCallBack = param.closeCallBack
  self.isRunningAction = false
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:addEventListener()
  self:popWindow()
  return self
end

function class:initData()
  self.data = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  self.isSelectAll = false
  self.selectStar = {
    [1] = false,
    [2] = false,
    [3] = false
  }
  self.starBtnEnable = {
    [1] = false,
    [2] = false,
    [3] = false
  }
  self.selectStarAmount = {}
  self.useList = {}
  local all = ed.readhero.classify(nil, "position")
  for index = 1, #all do
    local hero = all[index]
    if hero and hero._stars >= 5 then
      local tid = hero._tid
      local stoneId = ed.readhero.getStoneid(tid)
      local stoneAmount = ed.readhero.getStoneAmount(tid)
      if 0 < stoneAmount then
        local initStars = ed.readhero.getHeroInitStars(tid)
        self.starBtnEnable[initStars] = true
        table.insert(self.data[initStars], {
          id = stoneId,
          amount = stoneAmount,
          tid = tid,
          initStars = initStars
        })
      end
    end
  end
end

function class:doPressInList()
  local function handler(x, y)
    for k, ui in ipairs(self.uiList or {}) do
      local data = ui.data
      
      if ed.containsPoint(ui.btn_mul, x, y) and ui.btn_mul:isVisible() then
        ui.btn_mul:setScale(0.98)
        self:registerUpdateHandler("long_click_icon", self:keepeatHandler(data, -1))
        return ui
      end
      if ed.containsPoint(ui.icon, x, y) then
        ui.icon:setScale(0.98)
        self:registerUpdateHandler("long_click_icon", self:keepeatHandler(data, 1))
        return ui
      end
    end
    return nil
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, ui)
    local data = ui.data
    
    if ed.containsPoint(ui.btn_mul, x, y) and ui.btn_mul:isVisible() then
      self:addStone(data, -1)
      return
    end
    if ed.containsPoint(ui.icon, x, y) then
      self:addStone(data, 1)
      return
    end
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, ui)
    ui.icon:setScale(1)
    
    ui.btn_mul:setScale(1)
    self:removeUpdateHandler("long_click_icon")
  end
  
  return handler
end

function class:addStone(data, amount)
  local id = data.id
  local ownAmount = data.amount
  self.useList[id] = self.useList[id] or 0
  self.useList[id] = math.max(self.useList[id] + amount, 0)
  self.useList[id] = math.min(self.useList[id], ownAmount)
  self:refreshUI()
end

function class:keepeatHandler(data, amount)
  local count = 0
  local delay = 0.8
  local oriSpeed = 10
  local oriAccSpeed = 2
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  
  local function UpHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        self:addStone(data, amount)
        times = times - 1
      end
    end
  end
  
  return UpHandler
end

function class:createStoneIcon(data)
  local container, ui = ed.editorui(ed.uieditor.exchangeSoulPopItem)
  local icon = ed.readequip.createIcon(data.id)
  ui.frame:addChild(icon)
  ed.layout.centerInParent(icon)
  ui.icon = icon
  ed.setString(ui.amount, string.format("0/%d", data.amount))
  local barRes = class.STAR_TO_BAR_RES[data.initStars]
  if barRes then
    ed.setTexture(ui.bar, barRes)
  end
  ui.bar:setScaleX(0)
  self.useList[data.id] = 0
  return container, ui
end

function class:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  
  local function getPos(i)
    local ox = -45
    local oy = self.ui.layer_item:getContentSize().height
    local dx, dy = 90, 106
    local row = math.floor((i + 6) / 7)
    local col = (i - 1) % 7 + 1
    return ccp(ox + col * dx, oy - row * dy)
  end
  
  local num = 0
  for star, stones in ipairs(self.data) do
    for i, stone in ipairs(stones) do
      local container, ui = self:createStoneIcon(stone)
      num = num + 1
      container:setPosition(getPos(num))
      self.draglist:addItem(container)
      ui.data = stone
      table.insert(uiList, ui)
    end
  end
  self.uiList = uiList
  self.draglist:initListHeight(106 * math.floor((num + 6) / 7))
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.exchangeSoulPopWin)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelStroke(self.ui.num1, ed.toccc3(1448753), 1)
  ed.setLabelStroke(self.ui.num2, ed.toccc3(4137550), 1)
  ed.setLabelStroke(self.ui.num3, ed.toccc3(3744533), 1)
  ed.setLabelStroke(self.ui.label_empty, ed.toccc3(2306108), 1)
  ed.setLabelStroke(self.ui.label_all, ed.toccc3(5126949), 1)
  ed.setLabelStroke(self.ui.label_resolve, ed.toccc3(757887), 1.5)
  self.ui.btn_resolve:setVisible(false)
  local eff_soulExchange = ed.createFcaActor("eff_UI_Main_SoulExchange")
  local soul_label = ed.createLabelTTF(T("\231\134\148\231\130\188"), 21, ed.fontBold)
  ed.setLabelColor(soul_label, ed.toccc3(16776423))
  ed.setLabelStroke(soul_label, ed.toccc3(295033), 1)
  local soul_label_bg = ed.createSprite("UI/alpha/1080P/soulexchange/soulexchange_button1.png")
  soul_label_bg:addChild(soul_label)
  soul_label:limitWidthByScale(soul_label_bg:getContentSize().width * 0.9)
  ed.layout.centerInParent(soul_label)
  local soul_node = CCSprite:create()
  soul_node:addChild(soul_label_bg)
  eff_soulExchange:addNodeToComponent(soul_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  self.eff_soulExchange = eff_soulExchange
  self:addFca(eff_soulExchange)
  self.eff_soulExchange:setPosition(self.ui.btn_resolve:getPosition())
  self.ui.panel_eff_resolve:ignoreAnchorPointForPosition(false)
  self.ui.panel_eff_resolve:setAnchorPoint(ccp(0.5, 0.5))
  self.ui.panel_eff_resolve:addChild(eff_soulExchange)
  ed.layout.centerInParent(eff_soulExchange)
  eff_soulExchange:setAction("Loop")
  eff_soulExchange:setLoop(true)
  self.ui.Label_4340:limitWidthByScale(60)
  self.ui.Label_4340_Copy0:limitWidthByScale(60)
  self.ui.Label_4340_Copy1:limitWidthByScale(60)
  self:initRewardIcon()
  self:initDragList()
  self:refreshDraglist()
  self:refreshUI()
end

function class:initRewardIcon()
  local itemIcon1, _, amount1 = ed.readequip.createIconWithAmount(class.LOW_TOKEN_ID, 80, 2)
  local tokenPanel = self.ui.panel_token_1
  self.initPosX1, _ = tokenPanel:getPosition()
  tokenPanel:removeAllChildrenWithCleanup(true)
  tokenPanel:addChild(itemIcon1)
  ed.layout.centerInParent(itemIcon1)
  self.amount1 = amount1
  self.itemIcon1 = itemIcon1
  local itemIcon2, _, amount2 = ed.readequip.createIconWithAmount(class.HEIGHT_TOKEN_ID, 80, 2)
  local tokenPanel = self.ui.panel_token_2
  self.initPosX2, _ = tokenPanel:getPosition()
  tokenPanel:removeAllChildrenWithCleanup(true)
  tokenPanel:addChild(itemIcon2)
  ed.layout.centerInParent(itemIcon2)
  self.amount2 = amount2
  self.itemIcon2 = itemIcon2
end

function class:initDragList()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function class:refreshUI()
  self:refreshAllStone()
  self:refreshExchangeToken()
  self:refreshSelectStarBtn()
  self:refreshSelectAllBtn()
  self:refreshEmptyTips()
end

function class:refreshSelectStarBtn()
  for star = 1, 3 do
    local isSelect = self.selectStar[star]
    local isEnable = self.starBtnEnable[star]
    self.ui["tick" .. star]:setVisible(isEnable and isSelect)
    self.ui["btn_unable" .. star]:setVisible(not isEnable)
  end
end

function class:refreshSelectAllBtn()
  self.isSelectAll = true
  for star = 1, 3 do
    local isSelectStar = self.selectStar[star]
    local isEnable = self.starBtnEnable[star]
    if isEnable then
      self.isSelectAll = self.isSelectAll and isSelectStar
    end
  end
  if self.isSelectAll then
    ed.setLabelString(self.ui.label_all, T("\229\143\150\230\182\136\229\133\168\233\128\137"))
  else
    ed.setLabelString(self.ui.label_all, T("\229\133\168\233\128\137"))
  end
end

function class:refreshEmptyTips()
  local isEmpty = true
  for star, enable in pairs(self.starBtnEnable) do
    if enable then
      isEmpty = false
      break
    end
  end
  self.ui.image_empty:setVisible(isEmpty)
  self.ui.btn_all:setVisible(not isEmpty)
end

function class:calcStoneSelectAmount(star)
  local refreshStarList
  if star then
    refreshStarList = {
      [star] = self.selectStar[star]
    }
  else
    refreshStarList = self.selectStar
  end
  for star, isSelectStar in pairs(refreshStarList) do
    for index, ui in ipairs(self.uiList) do
      local data = ui.data
      if data.initStars == star then
        local amount
        if isSelectStar then
          amount = data.amount
        else
          amount = 0
        end
        self.useList[data.id] = amount
      end
    end
  end
  self:refreshAllStone()
end

function class:refreshAllStone()
  self.selectStarAmount = {}
  local selectStar = {}
  for index, ui in ipairs(self.uiList) do
    local data = ui.data
    local ownAmount = data.amount
    local initStars = data.initStars
    local selectAmount = self.useList[data.id]
    local isSelectThisAll = ownAmount <= selectAmount
    if selectStar[initStars] == nil then
      selectStar[initStars] = isSelectThisAll
    else
      selectStar[initStars] = selectStar[initStars] and isSelectThisAll
    end
    ui.bar:setScaleX(selectAmount / ownAmount)
    ed.setString(ui.amount, string.format("%d/%d", selectAmount, ownAmount))
    ui.btn_mul:setVisible(0 < selectAmount)
    self.selectStarAmount[initStars] = (self.selectStarAmount[initStars] or 0) + selectAmount
  end
  for initStars = 1, 3 do
    ed.setLabelString(self.ui["num" .. initStars], self.selectStarAmount[initStars] or 0)
    if selectStar[initStars] ~= nil then
      self.selectStar[initStars] = selectStar[initStars]
    end
  end
end

function class:refreshExchangeToken()
  local soulExchangeTB = ed.getDataTable("SoulExchange")
  local rewardAmount = {}
  for star, selectAmount in pairs(self.selectStarAmount) do
    local soulExchangeCfg = soulExchangeTB[self.soulExchangeGroup][star]
    local fixedRewardID = soulExchangeCfg["Fixed Reward ID"]
    local fixAmount = soulExchangeCfg["Fixed Amount"]
    rewardAmount[fixedRewardID] = (rewardAmount[fixedRewardID] or 0) + fixAmount * selectAmount
  end
  local amount1 = rewardAmount[class.LOW_TOKEN_ID] or 0
  local amount2 = rewardAmount[class.HEIGHT_TOKEN_ID] or 0
  ed.setLabelString(self.amount1, amount1)
  ed.setLabelString(self.amount2, amount2)
  self.itemIcon1:setVisible(0 < amount1)
  self.itemIcon2:setVisible(0 < amount2)
  if 0 < amount1 and 0 < amount2 then
    self.ui.panel_token_1:setPositionX(self.initPosX1)
    self.ui.panel_token_2:setPositionX(self.initPosX2)
  elseif 0 < amount1 then
    self.ui.panel_token_1:setPositionX(self.initPosX1 + 35)
  elseif 0 < amount2 then
    self.ui.panel_token_2:setPositionX(self.initPosX2 - 35)
  end
end

function class:onClickStarLevel(star)
  if self.isRunningAction then
    return
  end
  self.selectStar[star] = not self.selectStar[star]
  self:calcStoneSelectAmount(star)
  self:refreshUI()
end

function class:onClickBtnAll()
  if self.isRunningAction then
    return
  end
  self.isSelectAll = not self.isSelectAll
  for star, _ in ipairs(self.selectStar) do
    self.selectStar[star] = self.isSelectAll
  end
  self:calcStoneSelectAmount()
  self:refreshUI()
end

function class:runResolveAction(endCallBack)
  local targetPosX, targetPosY = self.ui.btn_resolve:getPosition()
  local col = 7
  local maxDirection = 0
  local resolveCount = 0
  for index, ui in ipairs(self.uiList) do
    local data = ui.data
    local amount = data.amount
    local id = data.id
    local resolveAmount = self.useList[id] or 0
    if 0 < resolveAmount then
      resolveCount = resolveCount + 1
      if amount <= resolveAmount then
        ui.icon:setVisible(false)
      end
      local actionNode = self:createActionNode(ui.frame, self.ui.bg:getParent(), data)
      local directionToCenter = math.abs((index - 1) % col + 1 - math.ceil(col / 2))
      maxDirection = math.max(maxDirection, directionToCenter)
      local delayAction = CCDelayTime:create(0.02 + 0.08 * directionToCenter)
      local action1 = CCEaseSineInOut:create(CCMoveBy:create(0.2, ccp(2, 20)))
      local action2 = CCScaleTo:create(0.2, 1.05)
      local spawnAction = CCSpawn:create(ccArrayMake(action1, action2))
      local time = 0.2 + 0.1 * directionToCenter
      local moveToTarget = CCEaseSineInOut:create(CCMoveTo:create(time, ccp(targetPosX + 20, targetPosY + 35)))
      local scaleTo = CCScaleTo:create(time, 0.5)
      local fadeTo = CCFadeTo:create(time, 0)
      local moveToTargetAction = CCSpawn:create(ccArrayMake(moveToTarget, scaleTo, fadeTo))
      local endAction = CCCallFunc:create(function()
        actionNode:removeFromParentAndCleanup(true)
      end)
      actionNode:runAction(ed.readaction.create({
        t = "seq",
        delayAction,
        spawnAction,
        moveToTargetAction,
        endAction
      }))
    end
  end
  if 0 < resolveCount then
    self.isRunningAction = true
    local eff_delay = CCDelayTime:create(0.1 + 0.12 * maxDirection)
    local eff_callBack = CCCallFunc:create(function()
      self.eff_soulExchange:stopAllActions()
      self.eff_soulExchange:setAction("Start2")
      self.eff_soulExchange:setNextAction("Loop")
    end)
    self.eff_soulExchange:runAction(ed.readaction.create({
      t = "seq",
      eff_delay,
      eff_callBack
    }))
    local delay = CCDelayTime:create(1.2 + 0.08 * maxDirection)
    local callBack = CCCallFunc:create(function()
      self.isRunningAction = false
      if endCallBack then
        endCallBack()
      end
    end)
    self.ui.btn_resolve:runAction(ed.readaction.create({
      t = "seq",
      delay,
      callBack
    }))
  else
    local tips = ed.showToast(T("\230\156\170\233\128\137\230\139\169\233\156\128\232\166\129\232\158\141\232\167\163\231\154\132\231\129\181\233\173\130\231\159\179"))
    tips:setPositionY(tips:getPositionY() + 90)
  end
end

function class:createActionNode(node, parent, data)
  local worldPos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
  local icon = ed.readequip.createIcon(data.id)
  icon:setCascadeOpacityEnabled(true)
  parent:addChild(icon)
  icon:setPosition(icon:convertToNodeSpace(worldPos))
  return icon
end

function class:sendResolveData()
  local items = {}
  for id, amount in pairs(self.useList or {}) do
    if 0 < amount then
      table.insert(items, {_id = id, _amount = amount})
    end
  end
  if #items <= 0 then
    return
  end
  local msg = ed.upmsg.soul_exchange_req()
  msg._item_convert = {}
  msg._item_convert._items = items
  ed.send(msg, "soul_exchange")
end

function class:onClickBtnResolve()
  if self.isRunningAction then
    return
  end
  self:runResolveAction(function()
    self:sendResolveData()
  end)
end

function class:onDeductStone()
  for id, amount in pairs(self.useList or {}) do
    if 0 < amount then
      ed.player:consumeEquip(id, amount)
    end
  end
  self:initData()
  self:refreshDraglist()
  self:refreshUI()
end

function class:onClickBtnClose()
  if self.closeCallBack then
    self.closeCallBack()
  end
  if self.isRunningAction then
    return
  end
  self:destroy()
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn1", function()
    self:onClickStarLevel(1)
  end)
  ed.UITool.registerBtn(self, "btn2", function()
    self:onClickStarLevel(2)
  end)
  ed.UITool.registerBtn(self, "btn3", function()
    self:onClickStarLevel(3)
  end)
  ed.UITool.registerBtn(self, "btn_all", function()
    self:onClickBtnAll()
  end)
  ed.UITool.registerBtn(self, "panel_eff_resolve", function()
    self:onClickBtnResolve()
  end, {pressScale = 0.98})
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.panel_click_area, x, y) and not ed.containsPoint(self.ui.panel_click_area2, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.panel_click_area, x, y) and not ed.containsPoint(self.ui.panel_click_area2, x, y) and self.clickOutSide then
        self:onClickBtnClose()
      end
      return false
    end,
    key = "close"
  })
end

function class:addEventListener()
  self:listenEvent("SoulExchangeReply", function(data)
    self:onDeductStone()
    local itemConvert = data._item_convert
    local exchangeItems = itemConvert._exchange_items
    local extraItems = itemConvert._extra_items
    local items = {}
    for _, item in ipairs(exchangeItems or {}) do
      table.insert(items, {
        id = item._id,
        amount = item._amount
      })
      ed.player:addEquip(item._id, item._amount)
    end
    for _, item in ipairs(extraItems or {}) do
      table.insert(items, {
        id = item._id,
        amount = item._amount,
        cornerTag = "extraSoul"
      })
      ed.player:addEquip(item._id, item._amount)
    end
    ed.announce({
      type = "getProp",
      param = {
        title = T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
        items = items,
        closeWhenClickOut = true
      }
    })
  end)
end
