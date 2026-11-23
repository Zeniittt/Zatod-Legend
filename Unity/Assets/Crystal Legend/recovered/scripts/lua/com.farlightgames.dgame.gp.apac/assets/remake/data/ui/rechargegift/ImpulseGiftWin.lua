local ImpulseGiftWin = {}
ImpulseGiftWin.__index = ImpulseGiftWin
local base = ed.ui.popwindow
setmetatable(ImpulseGiftWin, base.mt)
ed.ui.ImpulseGiftWin = ImpulseGiftWin
local ImpulseGiftScope = {}
local rechargeMgr = ed.RechargeManager
local rechargeNet = ed.RechargeNetwork

function ImpulseGiftWin.popNewOrGetInstance()
  if not ImpulseGiftWin.instance then
    local instance = ed.ui.ImpulseGiftWin.create()
    instance:popWindow()
    ImpulseGiftWin.instance = instance
  else
    ImpulseGiftWin.instance:refresh()
  end
  return ImpulseGiftWin.instance
end

function ImpulseGiftWin.create()
  local self = base.create("ImpulseGiftWin")
  setmetatable(self, ImpulseGiftWin)
  self:initData()
  self:initAppearence()
  self:registerTouchEvent()
  self:registerEvents()
  return self
end

function ImpulseGiftWin:recoverBunchGroupData(gifts)
  local groupId = 10000000
  for _, v in ipairs(gifts or {}) do
    if not v._bunch_group or v._bunch_group == 0 then
      v._bunch_group = groupId
      groupId = groupId + 1
    end
  end
end

function ImpulseGiftWin:refresh()
  self:initData()
  self:refreshUI()
end

function ImpulseGiftWin:initData()
  local impulseData = ed.RechargeNewMgr.getInstance():getImpulseGiftData()
  local gifts = impulseData or {}
  self.rewardDragList = {}
  self.giftData = {}
  self.giftBunch = ed.RechargeNewMgr.getInstance():getGiftBunchData(gifts)
  if self.bunchIndex then
    self.bunchIndex = math.min(self.bunchIndex, #self.giftBunch)
  else
    self.bunchIndex = 1
  end
  if self.bunchInnerIndex then
    self.bunchInnerIndex = math.min(self.bunchInnerIndex, #self.giftBunch[self.bunchIndex].list)
  else
    self.bunchInnerIndex = 1
  end
  self.rewardItems = {}
end

function ImpulseGiftWin:initAppearence()
  self.window = ed.createui("ImpulseGiftNewLayer", {
    mainLayer = self.mainLayer,
    touch_node = self
  })
  self:initLabelEffect()
  self:initGift()
  self:initGroupIndicator()
end

function ImpulseGiftWin:refreshUI()
  self:initGift()
  self:initGroupIndicator()
end

function ImpulseGiftWin:getCurGift()
  local list = self.giftBunch[self.bunchIndex].list
  local gift = list[self.bunchInnerIndex]
  return gift
end

function ImpulseGiftWin:makeNodesCenterAtX(keys, params)
  params = params or {}
  local nodes = {}
  for _, key in ipairs(keys) do
    table.insert(nodes, self.window.ui[key])
  end
  local node1 = nodes[1]
  local parent = node1:getParent()
  local pWid = parent:getContentSize().width
  local x = params.x or pWid / 2
  local gap = params.gap or 0
  local widAcc = 0
  for _, node in ipairs(nodes) do
    widAcc = widAcc + node:getContentSize().width * node:getScaleX()
  end
  widAcc = widAcc + math.max(#nodes - 1, 0) * gap
  local ox = x - widAcc / 2
  for _, node in ipairs(nodes) do
    local wid = node:getContentSize().width * node:getScaleX()
    node:setPositionX(ox + wid / 2)
    ox = ox + wid + gap
  end
end

function ImpulseGiftWin.createDigitsNode(number)
  number = tonumber(number) or 0
  local digits = {}
  if number <= 0 then
    digits = {0}
  else
    while number ~= 0 do
      local e = number % 10
      table.insert(digits, 1, e)
      number = math.floor(number / 10)
    end
  end
  local parent = CCSprite:create()
  local widAcc = 0
  local hei = 0
  local gap = -18
  local nodes = {}
  for _, digit in ipairs(digits) do
    local res = string.format("UI/alpha/HVGA/impulse/impulse_number_%d.png", digit)
    local node = ed.createSprite(res)
    table.insert(nodes, node)
    widAcc = widAcc + node:getContentSize().width
    hei = math.max(hei, node:getContentSize().height)
  end
  widAcc = widAcc + math.max(#nodes - 1, 0) * gap
  parent:setContentSize(CCSizeMake(widAcc, hei))
  local ox = 0
  for _, node in ipairs(nodes) do
    local wid = node:getContentSize().width
    node:setPosition(ccp(ox + wid / 2, hei / 2))
    parent:addChild(node)
    ox = ox + wid + gap
  end
  return parent
end

function ImpulseGiftWin:initLabelEffect()
  local ui = self.window.ui
  ed.setLabelStroke(ui.label_time, ccc3(0, 0, 0), 2)
  ed.setLabelShadow(ui.label_price, ccc3(0, 0, 0), ccp(0, 2))
  for i = 1, 3 do
    ed.setLabelShadow(ui["label_price_" .. i], ccc3(0, 0, 0), ccp(0, 2))
  end
end

function ImpulseGiftWin:initGift()
  self:initDiscountInfo()
  self:initRewards()
  self:initPriceTabs()
  self:initGiftTimer()
  self:initStoneDisplay()
end

function ImpulseGiftWin:initStoneDisplay()
  local ui = self.window.ui
  
  local function getPosAndHide(node)
    local x, y = node:getPosition()
    node:setVisible(false)
    return ccp(x, y)
  end
  
  local philstoneNumIcon = ed.getNumberNode({
    text = ed.player:getEquipAmount(910),
    folder = "white",
    padding = -1
  }).node
  philstoneNumIcon:setAnchorPoint(ccp(1, 0.5))
  philstoneNumIcon:setPosition(getPosAndHide(ui.img_philstone_num))
  ui.img_philstone_bg:addChild(philstoneNumIcon)
  ui.img_philstone_num = philstoneNumIcon
  local philstoneFragNumIcon = ed.getNumberNode({
    text = ed.player:getEquipAmount(2137),
    folder = "white",
    padding = -1
  }).node
  philstoneFragNumIcon:setAnchorPoint(ccp(1, 0.5))
  philstoneFragNumIcon:setPosition(getPosAndHide(ui.img_philstonefrag_num))
  ui.img_philstonefrag_bg:addChild(philstoneFragNumIcon)
  ui.img_philstonefrag_num = philstoneFragNumIcon
end

function ImpulseGiftWin:refreshCountDown()
  local curGift = self:getCurGift()
  local leftTime = curGift.deadline - ed.getServerTime()
  ed.setString(self.window.ui.label_time, ed.gethmsNString(leftTime) .. T("\229\144\142\231\164\188\229\140\133\230\182\136\229\164\177"))
  if leftTime <= 0 then
    self:closeGiftTimer()
  end
end

function ImpulseGiftWin:initGiftTimer()
  self:refreshCountDown()
  self:closeGiftTimer()
  self.giftTimer = ListenTimer(Timer:Always(1), function()
    self:refreshCountDown()
  end, ImpulseGiftScope)
end

function ImpulseGiftWin:closeGiftTimer()
  if self.giftTimer then
    CloseTimer(self.giftTimer.Name)
    self.giftTimer = nil
  end
end

function ImpulseGiftWin:initDiscountInfo()
  local curGift = self:getCurGift()
  local ui = self.window.ui
  local bg = ui.img_discount_bg
  if not tolua.isnull(ui.digitsNode) then
    ui.digitsNode:removeAllChildrenWithCleanup(true)
  end
  local digitsNode = self.createDigitsNode(curGift.discount)
  digitsNode:setPositionY(21.88)
  bg:addChild(digitsNode)
  ui.digitsNode = digitsNode
  self:makeNodesCenterAtX({
    "img_discount_1",
    "img_discount_2",
    "digitsNode",
    "img_discount_3"
  }, {gap = -12})
end

function ImpulseGiftWin:getItemIconWidth(data)
  return 50
end

function ImpulseGiftWin:initRewards()
  local curGift = self:getCurGift()
  local ui = self.window.ui
  local panel = ui.panel_rewards
  panel:removeAllChildrenWithCleanup(true)
  local rewardItems = {}
  local rewardDatas = curGift.rewardDatas
  local gap = 5
  local widAcc = 0
  for index, data in ipairs(rewardDatas) do
    local wid = self:getItemIconWidth(data)
    local icon = ed.SeasonTowerUITool.createItemIcon(data, wid)
    panel:addChild(icon)
    table.insert(rewardItems, {data = data, icon = icon})
    local wid = icon:getContentSize().width
    if 1 < index then
      widAcc = widAcc + gap
    end
    widAcc = widAcc + wid
  end
  local ox = -widAcc / 2
  for _, item in ipairs(rewardItems) do
    local icon = item.icon
    local wid = icon:getContentSize().width
    icon:setPositionX(ox + wid / 2)
    ox = ox + wid + gap
  end
  self.rewardItems = rewardItems
end

function ImpulseGiftWin:changePrice(index)
  local list = self.giftBunch[self.bunchIndex].list
  self.bunchInnerIndex = math.min(index, #list)
  self:initGift()
end

function ImpulseGiftWin:initPriceTabs()
  local list = self.giftBunch[self.bunchIndex].list
  local count = #list
  local ui = self.window.ui
  local gift = list[self.bunchInnerIndex]
  ed.setString(ui.label_price, gift.price)
  self:makeNodesCenterAtX({
    "img_price",
    "label_price"
  })
  for i = 1, 3 do
    local ggift = list[i]
    if 1 < count and ggift then
      ui["btn_price_" .. i]:setVisible(true)
      ui["btn_price_" .. i .. "_press"]:setVisible(true)
      ed.setString(ui["label_price_" .. i], ggift.price)
      local isCur = self.bunchInnerIndex == i
      ui["btn_price_" .. i .. "_press"]:setVisible(isCur)
      ui["label_price_" .. i]:setColor(isCur and ccc3(255, 242, 150) or ccc3(221, 220, 214))
      self:makeNodesCenterAtX({
        "img_price_" .. i,
        "label_price_" .. i
      })
    else
      ui["btn_price_" .. i]:setVisible(false)
      ui["btn_price_" .. i .. "_press"]:setVisible(false)
    end
  end
end

function ImpulseGiftWin:initGroupIndicator()
  local ui = self.window.ui
  local panel = ui.panel_pages
  panel:removeAllChildrenWithCleanup(true)
  local bunchCount = #self.giftBunch
  ui.btn_prev:setVisible(1 < bunchCount)
  ui.btn_next:setVisible(1 < bunchCount)
  if bunchCount <= 1 then
    return
  end
  local items = {}
  local gap = -8
  local widAcc = 0
  for i = 1, bunchCount do
    local isCur = self.bunchIndex == i
    local res = string.format("UI/alpha/HVGA/impulse/impulse_%s_point.png", isCur and "light" or "dark")
    local sprite = ed.createSprite(res)
    panel:addChild(sprite)
    table.insert(items, sprite)
    local wid = sprite:getContentSize().width
    if 1 < i then
      widAcc = widAcc + gap
    end
    widAcc = widAcc + wid
  end
  local ox = -widAcc / 2
  for _, item in ipairs(items) do
    local icon = item
    local wid = icon:getContentSize().width
    icon:setPositionX(ox + wid / 2)
    ox = ox + wid + gap
  end
end

function ImpulseGiftWin:registerBtn(key, func, params)
  local ui = self.window.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.5
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function ImpulseGiftWin:registerTouchEvent()
  local rect = ed.getNodeSize(self.window.ui.Panel_touch)
  self.window:registerOutofRectTouchHandler(rect, function()
    self:destroy()
  end)
  self:btRegisterButtonClick({
    button = self.window.ui.Panel_touch,
    name = "impulse_panel_touch",
    pressHandler = function()
      self:onClickPanelTouch()
    end,
    force = true,
    mcpMode = true
  })
  self:registerBtn("btn_buy", function()
    self:onClickBuy()
  end, {pressScale = 0.95})
  self:registerBtn("btn_prev", function()
    self:onClickPrev()
  end, {pressScale = 0.9})
  self:registerBtn("btn_next", function()
    self:onClickNext()
  end, {pressScale = 0.9})
  for i = 1, 3 do
    self:registerBtn("btn_price_" .. i, function()
      self:onClickPrice(i)
    end, {
      cancelPressHandler = function()
        self:initPriceTabs()
      end
    })
  end
  local clickedItem
  self:btRegisterClick({
    key = "click_rewards",
    checkClickHandler = function(x, y)
      for _, item in ipairs(self.rewardItems) do
        if ed.containsPoint(item.icon, x, y) then
          clickedItem = item
          return true
        end
      end
      return false
    end,
    pressHandler = function()
      self:showDetailCard(clickedItem)
    end,
    cancelPressHandler = function()
      self:removeDetailCard()
    end,
    clickHandler = function()
    end,
    force = true
  })
end

function ImpulseGiftWin:showDetailCard(rewardItem)
  self:removeDetailCard()
  local rewardDetailCard = ed.UITool.createFlyLayer(rewardItem.data)
  local iconPos = ed.getWorldPos(rewardItem.icon)
  ed.UITool.addFlyLayer(self.mainLayer, rewardDetailCard, ccpAdd(iconPos, ccp(0, 100)))
  self.rewardDetailCard = rewardDetailCard
end

function ImpulseGiftWin:removeDetailCard()
  if not tolua.isnull(self.rewardDetailCard) then
    self.rewardDetailCard:removeFromParentAndCleanup(true)
    self.rewardDetailCard = nil
  end
end

function ImpulseGiftWin:registerEvents()
  ListenEvent("EventBuyImpulseSuccess", function()
    self:onBuySuccess()
  end, ImpulseGiftScope)
end

function ImpulseGiftWin:destroy(param)
  CloseScope(ImpulseGiftScope)
  base.destroy(self, param)
  ImpulseGiftWin.instance = nil
end

function ImpulseGiftWin:onClickPanelTouch()
  self:removeDetailCard()
end

function ImpulseGiftWin:onClickBuy()
  local curGift = self:getCurGift()
  if ed.RechargeNewMgr.getInstance():isImpulseGiftActive() and curGift.deadline - ed.getServerTime() > 0 then
    ed.showConfirmDialog({
      text = T("\231\161\174\229\174\154\232\180\173\228\185\176\239\188\159"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        local goldNum = ed.player:getEquipAmount(910)
        local silverNum = ed.player:getEquipAmount(2137)
        local totalSilver = goldNum * 980 + silverNum
        if totalSilver < curGift.price then
          ed.showHandyDialog("toRecharge", {
            explaination = T("\232\180\164\232\128\133\228\185\139\231\159\179\228\184\141\232\182\179\239\188\140\230\152\175\229\144\166\229\137\141\229\190\128\232\180\173\228\185\176\239\188\159"),
            callback = function()
            end,
            page = "Diamonds",
            type = "stone"
          })
        else
          ed.RechargeNewNet:buyImpulseGift(curGift.giftId)
        end
      end
    })
  else
    ed.showToast(T("\231\164\188\229\140\133\229\183\178\230\182\136\229\164\177"))
    self:destroy({skipAnim = true})
  end
end

function ImpulseGiftWin:onClickPrice(index)
  self:changePrice(index)
end

function ImpulseGiftWin:changeBunch(offset)
  local bunchCount = #self.giftBunch
  local newIndex = self.bunchIndex + offset
  if newIndex < 1 then
    newIndex = bunchCount
  end
  if bunchCount < newIndex then
    newIndex = 1
  end
  self.bunchIndex = newIndex
  self.bunchInnerIndex = 1
  self:initGroupIndicator()
  self:initGift()
end

function ImpulseGiftWin:onClickPrev()
  self:changeBunch(-1)
end

function ImpulseGiftWin:onClickNext()
  self:changeBunch(1)
end

function ImpulseGiftWin:onBuySuccess()
  ed.showToast(T("\232\180\173\228\185\176\231\164\188\229\140\133\230\136\144\229\138\159\239\188\140\232\175\183\230\159\165\230\148\182\233\130\174\228\187\182"))
  ed.RechargeNewNet.getInstance():openImpulseGift()
end
