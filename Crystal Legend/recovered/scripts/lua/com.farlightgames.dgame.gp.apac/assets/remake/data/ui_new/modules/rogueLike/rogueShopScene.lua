local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueShopScene = class
class.bless_rarity_to_card_config = {
  [1] = {
    card_bg = "UI/alpha/1080P/rogue/bless/bless_shop_rank1.png",
    name_color = ccc3(255, 251, 236),
    stroke_color = ed.toccc3(3224418),
    typeStrokeColor = ed.toccc3(3439829)
  },
  [2] = {
    card_bg = "UI/alpha/1080P/rogue/bless/bless_shop_rank2.png",
    name_color = ccc3(255, 251, 236),
    stroke_color = ed.toccc3(5521032),
    typeStrokeColor = ed.toccc3(12596437)
  },
  [3] = {
    card_bg = "UI/alpha/1080P/rogue/bless/bless_shop_rank3.png",
    name_color = ccc3(255, 251, 236),
    stroke_color = ed.toccc3(10052441),
    typeStrokeColor = ed.toccc3(13995828)
  }
}
class.bless_rarity_to_reinforce_config = {
  [1] = {
    bg = "UI/alpha/1080P/rogue/bless/bless_shop_reinforce_rank1.png",
    nameBg = "UI/alpha/1080P/rogue/bless/bless_name_bg1.png"
  },
  [2] = {
    bg = "UI/alpha/1080P/rogue/bless/bless_shop_reinforce_rank2.png",
    nameBg = "UI/alpha/1080P/rogue/bless/bless_name_bg2.png"
  },
  [3] = {
    bg = "UI/alpha/1080P/rogue/bless/bless_shop_reinforce_rank3.png",
    nameBg = "UI/alpha/1080P/rogue/bless/bless_name_bg3.png"
  }
}
ed.UITool.registViewOpenFunc("rogueShopScene", function(param)
  local scene = ed.ui.rogueShopScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueShopScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.roomId = param.roomId
  self.goodsList = param.goods or {}
  self.type = param.type or "buy_shop"
  self.rogueBlessTB = ed.getDataTable("RogueBless")
  self.blessCardList = {}
  self.curSelectBless = nil
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.discount = self.rogueLikeMgr:getShopDiscount()
  self:initData()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initData()
  self.roomData = self.rogueLikeMgr:getRoomData(self.roomId)
  local boughtBlessIdList = {}
  if self.roomData then
    for _, rogueResult in ipairs(self.roomData.results or {}) do
      if rogueResult._type == "bought_bless" then
        for _, boughtBlessId in ipairs(rogueResult._params or {}) do
          table.insert(boughtBlessIdList, boughtBlessId)
        end
      end
    end
  end
  self.boughtBlessIdList = boughtBlessIdList
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBlessShop)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  self:initLabels()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\233\154\144\229\177\133\229\149\134\228\186\186"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:adaptUI()
  self:initDiscountTitle()
  self:initTableView()
  self:initBlessReinforceDragList()
  self:refreshTableView()
  self:refreshView()
end

function class:initDiscountTitle()
  if self.discount >= 1 then
    self.ui.image_discount_bg:setVisible(false)
    return
  end
  local panelSize = self.ui.panel_discount:getContentSize()
  local tips = ed.ui.gradientLabel.create({
    text = T("\229\133\168\229\156\186\230\138\152\230\137\163"),
    fontSize = 20,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15971327),
    endColor = ed.toccc3(16707839),
    strokeColor = ed.toccc3(5447810),
    strokeSize = 1
  })
  self.ui.panel_discount:addChild(tips.node)
  tips.node:setPosition(ccp(tips.node:getContentSize().width / 2, panelSize.height / 2))
  local discount = ed.ui.gradientLabel.create({
    text = string.format("-%s%%", math.floor(100 - self.discount * 100)),
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15849071),
    endColor = ed.toccc3(16777175),
    strokeColor = ed.toccc3(6307088),
    strokeSize = 1
  })
  self.ui.panel_discount:addChild(discount.node)
  discount.node:setPosition(ccp(tips.node:getPositionX() + tips.node:getContentSize().width / 2 + discount.node:getContentSize().width / 2, panelSize.height / 2))
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_buy, ed.toccc3(6562234), 1)
  ed.setLabelStroke(self.ui.label_bless, ed.toccc3(4535647), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_amount_bg, {right = 10}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_bless, {right = 120}, false, true)
  local diffWidth = ed.display.winSize.width - 960
  local diffHeight = ed.display.winSize.height - 540
  self.ui.image_reinforce_bg:setPositionX(self.ui.image_reinforce_bg:getPositionX() - diffWidth / 2)
  self.ui.panel_card:setPositionX(self.ui.panel_card:getPositionX() - diffWidth / 2)
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() - diffWidth / 2)
  self.ui.btn_buy:setPositionX(self.ui.btn_buy:getPositionX() - diffWidth / 2)
  local oldPanelList = self.ui.panel_list:getContentSize()
  self.ui.panel_list:setContentSize(CCSizeMake(oldPanelList.width + diffWidth, oldPanelList.height))
  self.ui.label_bless:limitSizeByScale(110, 30)
  self.ui.label_bless:setHorizontalAlignment(kCCTextAlignmentCenter)
end

function class:initBlessReinforceDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_bless_desc)
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.blessCardList
    end,
    cellSizeFromIndex = function(index)
      return self:getCardSize()
    end,
    createCell = function(index)
      local goods = self.blessCardList[index]
      local blessId = goods._bless_id
      local container, ui = self:createBlessCardItem(goods)
      return container, {goods = goods, ui = ui}
    end,
    doClickIn = function(cell)
      local data = cell.data
      local goods = data.goods
      local blessId = goods._bless_id
      local ui = data.ui
      self.curSelectBless = goods
      self:refreshCurPageTableView()
      self:refreshBlessCard()
      self:refreshBlessReinforceInfo()
      self:refreshBtnBuy()
    end
  }
  local itemSize = self:getCardSize()
  local gapX = 0
  local col = math.floor(size.width / itemSize.width)
  col = math.floor((size.width - (col - 1) * gapX) / itemSize.width)
  local offsetX = size.width - col * itemSize.width
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = col,
    dragMode = 1,
    touchpriority = -300,
    padding = {width = gapX, height = 0},
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width - offsetX / 2 - 3, size.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    },
    noshade = true
  }
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() + offsetX / 2)
  self.ui.image_reinforce_bg:setPositionX(self.ui.image_reinforce_bg:getPositionX() + offsetX / 2)
  self.ui.panel_card:setPositionX(self.ui.panel_card:getPositionX() + offsetX / 2)
  self.ui.btn_buy:setPositionX(self.ui.btn_buy:getPositionX() + offsetX / 2)
  self.tableView = Tableview.create(param)
end

function class:getCardSize()
  return CCSizeMake(150, 181.5)
end

function class:createBlessCardItem(goods)
  local blessId = goods._bless_id
  local price = goods._price or 0
  price = math.floor(price * self.discount)
  local container, ui = ed.editorui(ed.uieditor.rogueBlessShopItem)
  ed.setLabelStroke(ui.label_reinforced, ed.toccc3(2565412), 1)
  container:setContentSize(self:getCardSize())
  local blessCfg = self.rogueBlessTB[blessId]
  local rarity = blessCfg.Rarity or 1
  local rogueBless = self.rogueLikeMgr:getBlessById(blessId)
  local cardConfig = self.bless_rarity_to_card_config[rarity]
  local cardBgPath = cardConfig.card_bg
  ed.setTexture(ui.image_bg, cardBgPath)
  local icon = ed.rogueLikeTool.createBlessIcon(blessId)
  icon:setScale(0.65)
  ui.panel_icon:addChild(icon)
  ed.layout.centerInParent(icon)
  local iconShadow = ed.rogueLikeTool.createBlessIcon(blessId)
  ui.panel_icon:addChild(iconShadow)
  ed.layout.centerXInParent(iconShadow)
  iconShadow:setScaleX(0.65)
  iconShadow:setScaleY(-0.65)
  iconShadow:setOpacity(26)
  iconShadow:setPositionY(-6)
  ui.soldout_label:limitWidthByScale(56)
  local destinyTB = ed.getDataTable("RogueDestiny")
  local destinyId = blessCfg["Destiny ID"]
  local duoDestinyId = blessCfg["Duo Destiny ID"]
  local type
  if 0 < duoDestinyId then
    type = string.format("%s+%s", destinyTB[destinyId]["Display Name"], destinyTB[duoDestinyId]["Display Name"])
  else
    type = destinyTB[destinyId]["Display Name"]
  end
  ed.setLabelFontName(ui.label_bless_type, ed.fontBold)
  ed.setLabelString(ui.label_bless_type, type or "")
  ed.setLabelStroke(ui.label_bless_type, cardConfig.typeStrokeColor, 1)
  local typeLabelSize = ui.label_bless_type:getContentSize()
  local typeBgPath = string.format("UI/alpha/1080P/rogue/bless/bless_name_bg_%s.png", rarity)
  ui.image_bless_type_bg:setSpriteFrame(ed.getSpriteFrame(typeBgPath))
  ui.image_bless_type_bg:setContentSize(CCSizeMake(typeLabelSize.width + 29, 28))
  if self.type == "buy_shop" then
    ui.image_sold_out:setVisible(ed.isElementInTable(blessId, self.boughtBlessIdList))
  elseif self.type == "enhance_shop" then
    local isReinforced = rogueBless and 1 < rogueBless._level
    ui.image_reinforced:setVisible(isReinforced)
    ui.image_sold_out:setVisible(false)
  end
  ed.setLabelString(ui.label_name, blessCfg["Bless Name"])
  ed.setLabelColor(ui.label_name, cardConfig.name_color)
  ed.setLabelStroke(ui.label_name, cardConfig.stroke_color, 1)
  local pearl = self.rogueLikeMgr:getPearl()
  ed.setLabelString(ui.label_price, price)
  ed.setLabelColor(ui.label_price, price <= pearl and ed.toccc3(4294967000) or ccc3(255, 113, 69))
  ed.setLabelStroke(ui.label_price, ed.toccc3(2957855), 1)
  if self.curSelectBless and self.curSelectBless._bless_id == blessId then
    ui.image_select:setVisible(true)
  else
    ui.image_select:setVisible(false)
  end
  return container, ui
end

function class:refreshView()
  self:refreshBlessCard()
  self:refreshBlessReinforceInfo()
  self:refreshBtnBuy()
  self:refreshPearlAmount()
end

function class:refreshTableView(isHoldPos)
  self.blessCardList = {}
  if self.type == "buy_shop" then
    for index, goods in ipairs(self.goodsList) do
      table.insert(self.blessCardList, goods)
    end
  elseif self.type == "enhance_shop" then
    local curChapter = self.rogueLikeMgr:getCurChapter()
    local goods = {}
    for index, rogueBless in ipairs(curChapter._bless_list or {}) do
      local blessId = rogueBless._bless
      local blessLevel = rogueBless._level
      local rogueBlessCfg = ed.getDataTable("RogueBless")[blessId]
      local rarity = rogueBlessCfg.Rarity
      local canBeReinforced = rogueBlessCfg["Can Be Reinforced"]
      local key = string.format("NormalBless Rarity %s Reinforced Price", rarity)
      local reinforcePrice = ed.getDataTable("RogueBlessConfig")[key]
      if canBeReinforced then
        table.insert(goods, {
          _bless_id = rogueBless._bless,
          _price = reinforcePrice and reinforcePrice["Script Arg"][1] or 0
        })
      end
    end
    self.blessCardList = goods
  end
  table.sort(self.blessCardList, ed.cmpSort({
    {
      getValue = function(good)
        local blessId = good._bless_id
        return self.rogueBlessTB[blessId].Rarity
      end,
      reverse = true
    },
    {
      getValue = function(good)
        return good._price
      end,
      reverse = true
    }
  }))
  if #self.blessCardList > 0 and not self.curSelectBless then
    self.curSelectBless = self.blessCardList[1]
  end
  local listPosX, listPosY = self.tableView:getListPos()
  self.tableView:reloadData()
  if isHoldPos then
    self.tableView:setListPos(ccp(listPosX, listPosY))
  end
end

function class:refreshCurPageTableView()
  for _, item in ipairs(self.tableView:getUsedCell() or {}) do
    local ui = item.data.ui
    local goods = item.data.goods
    local blessId = goods._bless_id
    if self.curSelectBless and self.curSelectBless._bless_id == blessId then
      ui.image_select:setVisible(true)
    else
      ui.image_select:setVisible(false)
    end
    if self.type == "buy_shop" then
      local isSoldOut = ed.isElementInTable(blessId, self.boughtBlessIdList)
      ui.image_sold_out:setVisible(isSoldOut)
    elseif self.type == "enhance_shop" then
      local rogueBless = self.rogueLikeMgr:getBlessById(blessId)
      local isReinforced = rogueBless and rogueBless._level > 1
      ui.image_reinforced:setVisible(isReinforced)
    end
  end
end

function class:refreshBlessCard()
  if self.type ~= "buy_shop" then
    self.ui.panel_card:setVisible(false)
    return
  end
  if not self.curSelectBless then
    self.ui.panel_card:setVisible(false)
    return
  end
  self.ui.panel_card:setVisible(true)
  self.ui.panel_card:removeAllChildrenWithCleanup(true)
  local blessCard = ed.rogueLikeTool.createBlessCard(self.curSelectBless._bless_id)
  self.ui.panel_card:addChild(blessCard)
  ed.layout.centerInParent(blessCard)
end

function class:refreshBlessReinforceInfo()
  if self.type ~= "enhance_shop" then
    self.ui.image_reinforce_bg:setVisible(false)
    return
  end
  if not self.curSelectBless then
    self.ui.image_reinforce_bg:setVisible(false)
    return
  end
  self.ui.image_reinforce_bg:setVisible(true)
  local blessCfg = self.rogueBlessTB[self.curSelectBless._bless_id]
  local reinforceConfig = self.bless_rarity_to_reinforce_config[blessCfg.Rarity or 1]
  ed.setTexture(self.ui.image_reinforce_bg, reinforceConfig.bg)
  ed.setTexture(self.ui.bless_name_bg, reinforceConfig.nameBg)
  local icon = ed.rogueLikeTool.createBlessIcon(self.curSelectBless._bless_id)
  icon:setScale(0.55)
  self.ui.panel_bless_icon:removeAllChildrenWithCleanup(true)
  self.ui.panel_bless_icon:addChild(icon)
  ed.layout.centerInParent(icon)
  ed.setLabelString(self.ui.label_bless_name, blessCfg["Bless Name"])
  ed.setLabelFontName(self.ui.label_bless_name, ed.fontBold)
  ed.setLabelColor(self.ui.label_bless_name, ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.label_bless_name, ed.toccc3(2171169), 1)
  local panelSize = self.ui.panel_bless_desc:getContentSize()
  local posY = 0
  self.dragList:clearList()
  local autoTextOldDesc = ed.rogueLikeTool.parseAutoTextDesc(blessCfg["Full Description"], blessCfg, {
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    fontSize = 13,
    maxWidth = panelSize.width
  })
  self.dragList:addItem(autoTextOldDesc.node)
  autoTextOldDesc.node:setPosition(ccp(1, panelSize.height - posY - 7.5))
  local _, autoTextOldDescHeight = autoTextOldDesc:getCurContentSize()
  posY = posY + autoTextOldDescHeight + 10
  local line = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_reinforce_error.png")
  self.dragList:addItem(line)
  line:setPosition(ccp(panelSize.width / 2, panelSize.height - posY))
  posY = posY + line:getContentSize().height
  local autoTextNewDesc = ed.rogueLikeTool.parseAutoTextDesc(blessCfg["Reinforced Full Description"], blessCfg, {
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    fontSize = 13,
    maxWidth = panelSize.width
  })
  self.dragList:addItem(autoTextNewDesc.node)
  autoTextNewDesc.node:setPosition(ccp(1, panelSize.height - posY - 6.5))
  local _, autoTextNewDescHeight = autoTextNewDesc:getCurContentSize()
  posY = posY + autoTextNewDescHeight
  self.dragList:initListHeight(posY)
end

function class:refreshBtnBuy()
  local price = 0
  local pearl = self.rogueLikeMgr:getPearl()
  if self.curSelectBless then
    price = self.curSelectBless._price or 0
  end
  price = math.floor(price * self.discount)
  ed.setLabelString(self.ui.label_buy_price, price)
  if self.type == "buy_shop" then
    local isSoldOut = ed.isElementInTable(self.curSelectBless._bless_id, self.boughtBlessIdList)
    self.ui.btn_buy:setVisible(not isSoldOut)
    ed.setLabelString(self.ui.label_buy, T("\232\180\173\228\185\176"))
  elseif self.type == "enhance_shop" then
    local rogueBless = self.rogueLikeMgr:getBlessById(self.curSelectBless._bless_id)
    local isReinforced = rogueBless and rogueBless._level > 1
    self.ui.btn_buy:setVisible(not isReinforced)
    ed.setLabelString(self.ui.label_buy, T("\229\188\186\229\140\150"))
  end
  if pearl < price then
    ed.setLabelColor(self.ui.label_buy_price, ccc3(255, 113, 69))
    ed.setLabelStroke(self.ui.label_buy_price, ed.toccc3(4063498), 1)
  else
    ed.setLabelColor(self.ui.label_buy_price, ed.toccc3(4294572523))
    ed.setLabelStroke(self.ui.label_buy_price, ed.toccc3(6562234), 1)
  end
  local btnWidth = self.ui.btn_buy:getContentSize().width
  local labelPriceWidth = self.ui.label_buy_price:getContentSize().width
  local labelBuyWidth = self.ui.label_buy:getContentSize().width
  local iconWidth = self.ui.image_token_buy:getContentSize().width
  self.ui.image_token_buy:setPositionX((btnWidth - labelPriceWidth - labelBuyWidth - iconWidth) / 2 + iconWidth / 2)
  self.ui.label_buy_price:setPositionX(self.ui.image_token_buy:getPositionX() + iconWidth / 2)
  self.ui.label_buy:setPositionX(self.ui.label_buy_price:getPositionX() + labelPriceWidth)
end

function class:refreshPearlAmount()
  local pearl = self.rogueLikeMgr:getPearl()
  ed.setLabelString(self.ui.label_amount, pearl)
end

function class:onClickBtnBuy()
  if self.curSelectBless then
    local blessId = self.curSelectBless._bless_id
    local price = self.curSelectBless._price
    price = math.floor(price * self.discount)
    local pearl = self.rogueLikeMgr:getPearl()
    if self.type == "buy_shop" then
      local isSoldOut = ed.isElementInTable(blessId, self.boughtBlessIdList)
      if isSoldOut then
        ed.showToast(T("\229\183\178\229\148\174\231\189\132"))
        return
      end
    elseif self.type == "enhance_shop" then
      local rogueBless = self.rogueLikeMgr:getBlessById(blessId)
      local isReinforced = rogueBless and rogueBless._level > 1
      if isReinforced then
        ed.showToast(T("\231\165\157\231\166\143\229\183\178\229\188\186\229\140\150"))
        return
      end
    end
    if price > pearl then
      ed.showToast(T("\231\143\141\231\143\160\230\149\176\233\135\143\228\184\141\232\182\179"))
      return
    end
    if self.type == "enhance_shop" then
      ed.UITool.openView("rogueBlessReinforceWindow", {
        blessIdList = {blessId}
      })
    end
    ed.rogueLikeNet.sendShopBuyBless(self.type, blessId)
  end
end

function class:onClickBtnBless()
  ed.UITool.openView("rogueBlessScene")
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.rogueDefine.RULES_TEXT
  }):popWindow()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_buy", function()
    self:onClickBtnBuy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_bless", function()
    self:onClickBtnBless()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("rogueBuyBless", function()
    self:initData()
    self:refreshView()
    self:refreshTableView(true)
  end)
  self:listenEvent("rogueUpdatePearlAmount", function()
    self:refreshPearlAmount()
  end)
end
