local class = {}
ed.ui.activityRetrievalRewardPage = class

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.mgr = ed.retrievalRewardMgr.getInstance()
  self.uiList = {}
  self.totalCost = 0
  self:initView()
  self:setButtonClick()
  self:addTouchEvent()
  self:addListenEvent()
  ed.retrievalRewardNet.sendOpenPanel()
end

function class:setButtonClick()
end

function class:setVisibleCallBack(isVisible)
  self.dragList:setVisible(isVisible)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activityRetrievalRewardPage)
  self.container = container
  self.ui = ui
  ed.setLabelStroke(self.ui.label_all_cost, ed.toccc3(4925829), 1)
  ed.setLabelStroke(self.ui.label_all, ed.toccc3(4925829), 1)
  self.ui.label_all:limitWidthByScale(110)
  ed.layout.horizontalSortNode({
    self.ui.image_all_cost_icon,
    self.ui.label_all_cost,
    self.ui.label_all
  }, {
    5,
    5,
    0
  }, self.ui.btn_buy_all:getContentSize().width * 0.5)
  ed.setLabelStroke(self.ui.label_finish, ed.toccc3(4602713), 1)
  ed.setLabelStroke(self.ui.label_discount, ed.toccc3(16777215), 1)
  ed.setLabelStroke(self.ui.label_discount_percent, ed.toccc3(16777215), 1)
  self.ui.label_discount:setFontName(ed.fontBold)
  self.ui.label_discount_percent:setFontName(ed.fontBold)
  self:initDragList()
end

function class:refreshView()
  self:refreshDragList()
  self:refreshBtnBuy()
  self:refreshDiamondAmount()
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:cancelPressInList()
  })
end

function class:getPressInHandler()
  local function handler(x, y)
    for index, uiCfg in ipairs(self.uiList) do
      local ui = uiCfg.ui
      
      if ed.containsPoint(ui.btn_buy, x, y) and ui.btn_buy:isVisible() then
        ui.btn_buy:setScale(0.95)
        return uiCfg
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, uiCfg)
    local data = uiCfg.data
    
    self:onBuyRetrieval(data)
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, uiCfg)
    local ui = uiCfg.ui
    
    ui.btn_buy:setScale(1)
  end
  
  return handler
end

function class:refreshDragList()
  self.dragList:clearList()
  self.uiList = {}
  local rewardDetailList = self.mgr:getRewardDetail()
  local posY = 0
  local gapY = 14
  local totalCost = 0
  self.allFinish = false
  local listSize = self.ui.panel_list:getContentSize()
  for index, rewardDetail in ipairs(rewardDetailList) do
    local container, ui, isFinished = self:createRewardItem(rewardDetail)
    if not isFinished then
      totalCost = totalCost + rewardDetail._diamond or 0
    end
    local containerSize = container:getContentSize()
    self.dragList:addItem(container)
    container:setPosition(ccp(0, listSize.height - (containerSize.height + posY + 14)))
    posY = posY + containerSize.height + gapY
    table.insert(self.uiList, {ui = ui, data = rewardDetail})
  end
  self.dragList:initListHeight(posY)
  local discount = self.mgr:getCostDiscount()
  self.totalCost = math.ceil(totalCost * discount)
end

function class:refreshBtnBuy()
  local discount = self.mgr:getCostDiscount()
  self.ui.image_discount:setVisible(discount < 1)
  if self.totalCost <= 0 then
    self.ui.btn_finish:setVisible(true)
    self.ui.btn_buy_all:setVisible(false)
  else
    self.ui.btn_finish:setVisible(false)
    self.ui.btn_buy_all:setVisible(true)
    ed.setString(self.ui.label_all_cost, self.totalCost)
  end
end

function class:refreshDiamondAmount()
  ed.setString(self.ui.label_diamond_amount, ed.player:getDiamondAmount())
  local labelSize = self.ui.label_diamond_amount:getContentSize()
  local iconSize = self.ui.image_diamond:getContentSize()
  local left, right = 10, 10
  self.ui.diamond_amount_bg:setContentSize(CCSizeMake(labelSize.width + iconSize.width + left + right, 35.5))
  self.ui.image_diamond:setPositionX(iconSize.width / 2 + left)
  self.ui.label_diamond_amount:setPositionX(left + iconSize.width)
  ed.layout.layoutWithMagin(self.ui.diamond_amount_bg, {right = 200, top = 15}, false, true)
end

function class:createRewardItem(rewardDetail)
  local container, ui = ed.editorui(ed.uieditor.activityRetrievalRewardItem)
  container:setContentSize(ui.image_bg:getContentSize())
  local type = rewardDetail._type
  local rewards = rewardDetail._rewards
  local diamond = rewardDetail._diamond or 0
  local discount = self.mgr:getCostDiscount()
  local isFinished = self.mgr:checkRewardIsFinished(type)
  ed.setString(ui.label_title, ed.retrievalRewardDefine.REWARD_TITLE[type] or "")
  local labelTitleSize = ui.label_title:getContentSize()
  ui.title_bg:setContentSize(CCSizeMake(labelTitleSize.width + 35, 32.5))
  ed.setString(ui.label_cost, math.ceil(diamond * discount))
  ed.setLabelStroke(ui.label_cost, ed.toccc3(4925829), 1)
  ed.setLabelStroke(ui.label_buy, ed.toccc3(4925829), 1)
  local buy_width = ui.label_buy:getContentSize().width
  if 45 < buy_width then
    ui.label_buy:setScale(45 / buy_width)
  end
  ed.setLabelStroke(ui.label_finish, ed.toccc3(13616619), 1)
  ed.setLabelStroke(ui.label_discount, ed.toccc3(16777215), 1)
  ed.setLabelStroke(ui.label_discount_percent, ed.toccc3(16777215), 1)
  ui.label_discount:setFontName(ed.fontBold)
  ui.label_discount_percent:setFontName(ed.fontBold)
  self:createRewardItemList(ui.panel_reward, rewards, isFinished)
  if isFinished then
    ui.btn_finish:setVisible(true)
    ui.btn_buy:setVisible(false)
  else
    ui.btn_finish:setVisible(false)
    ui.btn_buy:setVisible(true)
    ui.image_discount:setVisible(discount < 1)
  end
  return container, ui, isFinished
end

function class:createRewardItemList(container, rewardDataList, isFinished)
  local itemList = {}
  local rewardDragList = ed.UITool.createDraglist(container, {
    doPressIn = function(x, y)
      self.startClickX = x
      self.startClickY = y
      for k, v in pairs(itemList) do
        if ed.containsPoint(v.icon, x, y) and ed.checkVisible(v.icon) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, v)
      if self.startClickX and self.startClickY and (math.abs(x - self.startClickX) > 10 or math.abs(y - self.startClickY) > 10) then
        return
      end
      local itemData = v.itemData
      if not ed.containsPoint(self.ui.panel_list, x, y) then
        return
      end
      ed.ui.packageDetailWin.create({
        id = itemData._id,
        count = itemData._amount,
        type = itemData._type
      }):popWindow()
    end,
    priority = -300
  })
  local posX, gapX = 0, 0
  for _, itemData in ipairs(rewardDataList or {}) do
    local icon = ed.createItemIcon({
      id = itemData._id,
      type = itemData._type,
      amount = itemData._amount
    })
    local scale = 0.7
    icon:setScale(scale)
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 * scale + posX, iconSize.height * scale / 2))
    posX = posX + iconSize.width * scale + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
    if isFinished then
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
      icon:addChild(mask, 1)
      icon:addChild(imageReceived, 2)
      imageReceived:setPosition(ccp(45, 40))
      mask:setPosition(ccp(45, 45))
    end
  end
  rewardDragList:initListWidth(posX)
  return rewardDragList
end

function class:buyReward(typeList, cost)
  local function consumeHandler()
    ed.retrievalRewardNet.sendTakeReward(typeList)
  end
  
  if cost > ed.player:getDiamondAmount() then
    ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
    return
  end
  ed.UITool.openView("consumeTipsWin", {
    text = T("<lable fontSize=f22 color=ccc3(25,2,3)>\230\152\175\229\144\166\232\138\177\232\180\185%s\233\146\187\231\159\179\230\137\190\229\155\158\229\165\150\229\138\177\239\188\159</lable><br/><lable fontSize=f22 color=ccc3(25,2,3)>\239\188\136\232\182\133\229\128\188\230\156\136\229\141\161\228\186\1716\230\138\152\228\188\152\230\131\160\239\188\137</lable>", cost),
    rightHandler = function()
      consumeHandler()
    end,
    notShowCheckBox = true
  })
end

function class:onBuyRetrieval(data)
  local type = data._type
  local isFinished = self.mgr:checkRewardIsFinished(type)
  if isFinished then
    ed.showToast(T("\229\165\150\229\138\177\229\183\178\233\162\134\229\143\150"))
    return
  end
  local diamond = data._diamond
  local discount = self.mgr:getCostDiscount()
  diamond = math.ceil(diamond * discount)
  self:buyReward({type}, diamond)
end

function class:onBuyAll()
  local rewardDetailList = self.mgr:getRewardDetail()
  local typeList = {}
  for index, rewardDetail in ipairs(rewardDetailList) do
    local type = rewardDetail._type
    local isFinished = self.mgr:checkRewardIsFinished(type)
    if not isFinished then
      table.insert(typeList, rewardDetail._type)
    end
  end
  if 0 < #typeList then
    self:buyReward(typeList, self.totalCost)
  end
end

function class:addTouchEvent()
  self:btRegisterButtonClick({
    button = self.ui.btn_buy_all,
    force = true,
    pressScale = 0.95,
    clickHandler = function()
      self:onBuyAll()
    end
  })
end

function class:addListenEvent()
  self:listenEvent("RetrievalRewardOpenPanel", function()
    self:refreshView()
  end)
  self:listenEvent("RetrievalRewardTakeReward", function()
    self:refreshView()
  end)
end
