local base = ed.ui.commonscene
local timeCorridorShopScene = newclass(base.mt)
ed.ui.timeCorridorShopScene = timeCorridorShopScene

function timeCorridorShopScene.create()
  local self = base.create("timeCorridorShopScene", {noBottomButton = true})
  setmetatable(self, timeCorridorShopScene.mt)
  self:initData()
  self:initUI()
  self:adaptUI()
  self:initDraglist()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end

function timeCorridorShopScene:initData()
  self.endTime = ed.timeCorridorMgr.endTime
end

function timeCorridorShopScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.timeCorridorShopScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackground("UI/alpha/1080P/timecorridor/timecorridor_shop_bg_1.jpg")
  self.bg:setAnchorPoint(ccp(0.5, 0))
  ed.layout.centerInScreen(self.bg)
  local shop_bg_front = ed.createSprite("UI/alpha/1080P/timecorridor/timecorridor_shop_bg_2.png")
  shop_bg_front:setScale(self.bg:getScaleX())
  shop_bg_front:setAnchorPoint(ccp(0.5, 0))
  shop_bg_front:setPosition(self.bg:getPosition())
  self.scene:addChild(shop_bg_front)
  shop_bg_front:setZOrder(5)
  self.frontBG = shop_bg_front
  ed.layout.layoutWithMagin(self.ui.left_time_bg, {top = 50})
  ed.layout.layoutWithMagin(self.ui.back_btn, {left = 0, top = 0})
  local title = ed.ui.gradientLabel.create({
    text = T("\230\152\159\232\190\137\228\186\164\230\152\147\230\137\128"),
    fontName = ed.fontBold,
    fontSize = 30,
    startColor = ed.toccc3(16180991),
    endColor = ed.toccc3(16711167),
    strokeColor = ed.toccc3(9387182),
    strokeSize = 1
  })
  self.ui.bg:addChild(title.node)
  ed.right2(title.node, self.ui.back_btn, 0)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(4992908), 1)
end

function timeCorridorShopScene:adaptUI()
  local ui = self.ui
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local posx, posy = ui.panel_goods:getPosition()
  ui.panel_goods:setPosition(posx - newWid, posy - newHei)
  local size = ui.panel_goods:getContentSize()
  size = CCSizeMake(size.width + newWid * 2, size.height + newHei * 2)
  ui.panel_goods:setContentSize(size)
  self.panel_size = size
  self.frontBG:setPositionY(self.frontBG:getPositionY() - newHei)
  self.frontBG:setPositionX(self.frontBG:getPositionX() - newHei)
end

function timeCorridorShopScene.doClickIn(item)
  if item.status == "soldOut" then
    ed.showToast(item.isShow and T("\229\183\178\230\139\165\230\156\137") or T("\229\141\150\229\133\137\228\186\134\239\188\129"))
  else
    local isFashion = ed.getDataTable("equip")[item.rewardId]["Fashion ID"]
    if isFashion and 0 < isFashion then
      ed.ui.timeCorridorBuyFashionPop.create({
        fashionId = isFashion,
        tokenAmount = item.tokenAmount,
        progress = item.left_progress,
        goodId = item.ind
      })
    elseif ed.readequip.value(item.rewardId, "Category") == T("\231\171\158\230\138\128\229\156\186\232\131\140\230\153\175") then
      local row = ed.getDataTable("equip")[item.rewardId]
      local backTbl = ed.getDataTable("ArenaBackground")
      local picRes = "UI/alpha/1080P/battle_bg/bbg_arena.jpg"
      for _, val in pairs(backTbl) do
        if val["Item ID"] == item.rewardId then
          picRes = val.Picture
          break
        end
      end
      local itemPop = ed.ui.pvpBackgroundPop.lookBackgroundPop.create({
        name = row.Name,
        Picture = picRes,
        Description = row.Description
      })
      local ui = itemPop.ui
      ui.descriptionNode:setVisible(false)
      ui.title_name:setString(T("\231\171\158\230\138\128\229\156\186\232\131\140\230\153\175") .. "-" .. ui.title_name:getString())
      local btn_buy = ed.createSpriteTools({
        res = "UI/alpha/1080P/common/button_big_common.png",
        parent = ui.bg,
        scale = 0.7,
        pos = ccp(327, 45)
      })
      local icon = ed.createSprite(item.res)
      btn_buy:addChild(icon)
      local price_lab = ed.createLabelTools({
        txt = item.tokenAmount,
        size = 24,
        color = ccc3(ed.colorToStr("#FCF1A5")),
        shadow = {
          ccc3(69, 46, 29),
          ccp(0, 2)
        },
        parent = btn_buy
      })
      icon:setPositionY(btn_buy:getContentSize().height * 0.5)
      price_lab:setPositionY(btn_buy:getContentSize().height * 0.5)
      ed.layout.horizontalSortNode({icon, price_lab}, {5, 0}, btn_buy:getContentSize().width * 0.5)
      itemPop:btRegisterButtonClick({
        button = btn_buy,
        key = "buy_btn",
        clickHandler = function()
          ed.showConfirmDialog({
            autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185%s \229\133\145\230\141\162%s\239\188\159", string.format("<sprite src=%s scale=0.9><lable color=ccc3(189,116,0)>%d</lable>", item.res, item.tokenAmount), row.Name),
            rightHandler = function()
              ed.timeCorridorNet:sendBuyGoods(item.ind, 1)
              itemPop:destroy()
            end
          })
        end,
        force = true,
        pressScale = 0.75,
        normalScale = 0.8,
        clickInterval = 0.2
      })
      itemPop:popWindow()
    elseif item.isShow then
      ed.ui.timeCorridorBuyItemPop.create({
        itemId = item.rewardId,
        tokenAmount = item.tokenAmount,
        smallIconRes = item.res,
        goodId = item.ind
      })
    else
      local panel = ed.ui.buyResourceBox.create({
        buyLimitNum = item.maxBuyTimes - item.curBuyTimes,
        defaultBuyNum = 1,
        goodsResType = ed.ui.configs.resType.getResType(item.rewardType),
        goodsId = item.rewardId,
        costResType = item.tokenType,
        costId = ed.timeCorridorMgr.tokenId,
        price = item.tokenAmount,
        groupAmount = 1,
        costIconConfig = {
          smallIcon = item.res
        },
        buyAction = function(num)
          if 0 < num then
            ed.timeCorridorNet:sendBuyGoods(item.ind, num)
          end
        end
      })
      panel.ui.icon_parent:removeAllChildrenWithCleanup(true)
      local icon = ed.createItemIcon({
        id = item.rewardId
      })
      panel.ui.icon_parent:addChild(icon)
      ed.layout.centerInParent(icon)
      icon:setScale(0.94)
      panel:setSurplusAmount(item.maxBuyTimes - item.curBuyTimes)
      panel:popWindow()
      panel.ui.title_text:setString(T("\229\133\145\230\141\162%s", ed.getDataTable("equip")[item.rewardId].Name))
      panel.ui.label_buy:setString(T("\229\133\145\230\141\162"))
    end
  end
end

function timeCorridorShopScene:initDraglist()
  local function ClickInFun(isRight)
    return function(x, y, passItem)
      if not self.newTouch then
        return
      end
      if passItem then
        passItem.ui.bg:setScale(1)
      end
      if isRight then
        self.doClickIn(passItem)
      end
    end
  end
  
  local draglist = ed.UITool.createDraglist(self.ui.panel_goods, {
    doPressIn = function(x, y)
      local items = self.goodsList
      for i, v in ipairs(items) do
        if ed.containsPoint(v.ui.bg, x, y) then
          v.ui.bg:setScale(0.95)
          self.newTouch = true
          return v
        end
      end
    end,
    doClickIn = ClickInFun(true),
    cancelPressIn = ClickInFun(),
    cancelClickIn = ClickInFun(),
    priority = -200
  })
  self.draglist = draglist
  local size = self.panel_size
  self.colNum = math.min(math.max(math.floor(size.width / 170), 1), 5)
  self.delX = 171
  self.delY = 213
  self.oriPosX = (size.width - self.delX * self.colNum) * 0.5 + 86
  self.oriPosY = size.height - 110
  self:updateDraglist()
end

function timeCorridorShopScene:calcPosition(index)
  local row = math.floor((index - 1) / self.colNum)
  local col = (index - 1) % self.colNum
  return ccp(self.oriPosX + col * self.delX, self.oriPosY - row * self.delY)
end

function timeCorridorShopScene:updateDraglist()
  local ox, oy = self.draglist:getListPos()
  self.draglist:clearList()
  self.goodsList = ed.timeCorridorMgr:getGoodsList()
  for i, k in ipairs(self.goodsList) do
    local container, ui = self:createShopItem(k)
    self.draglist:addItem(container)
    ui.bg:setPosition(self:calcPosition(i))
  end
  local rowNum = math.ceil(#self.goodsList / self.colNum)
  self.draglist:initListHeight(self.delY * rowNum + 60)
  self.draglist:setListPos(ccp(ox, oy))
end

function timeCorridorShopScene:createShopItem(item)
  local container, ui = ed.editorui(ed.uieditor.timeCorridorShopItem)
  ed.setLabelStroke(ui.label_name, ed.toccc3(0), 1)
  local quality = math.max(ed.lookupDataTable("equip", "Quality", item.rewardId), 2)
  ed.setTexture(ui.bg, ed.getFashionFrameResByQuality(quality, "fashionShopItemBg"))
  local isFashion = ed.getDataTable("equip")[item.rewardId]["Fashion ID"]
  if isFashion ~= nil and 0 < isFashion then
    local fashionID = isFashion
    local card = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionID, "show"),
      parent = ui.icon_pos
    })
    local Frame = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionID, "FrameMini"),
      parent = ui.icon_pos
    })
    ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionID))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionID, "qualityBg"),
      pos = ccp(0, -38),
      parent = ui.icon_pos
    }), ccp(28, 26), 16)
    local nameStr = ed.exteriorShopData.getFashionName(fashionID)
    if EDCurLanguage == "en" or EDCurLanguage == "ja" then
      nameStr = string.gsub(nameStr, " \194\183 ", "\n")
    end
    ui.label_name:setString(nameStr)
    ui.label_name:limitSizeByScale(140, 30)
  else
    local card = ed.createItemIcon({
      id = item.rewardId,
      type = item.rewardType,
      amount = item.rewardAmount
    }, nil, 1)
    ui.icon_pos:addChild(card)
    ui.label_name:setString(ed.lookupDataTable("equip", "Name", item.rewardId))
    ui.label_name:limitSizeByScale(140, 30)
    if item.status == "onSale" and not item.isShow then
      ui.buy_limit_bg:setVisible(true)
      ed.setLabelStroke(ui.label_buy_limit, ed.toccc3(5255955), 1)
      ui.label_buy_limit:setString(T("\233\153\144\232\180\173\239\188\154%s", item.curBuyTimes .. "/" .. item.maxBuyTimes))
    end
  end
  ui.label_name:setHorizontalAlignment(kCCTextAlignmentCenter)
  local priceType = "timecorridortoken"
  if item.tokenType == "Diamond" then
    priceType = "Diamond"
  end
  local config = ed.ui.configs.resBar.getResBarConfig(string.lower(priceType))
  local res
  if config then
    if type(config.smallIcon) == "function" then
      res = config.smallIcon()
    else
      res = config.smallIcon
    end
    local icon = ed.createSprite(res)
    icon:setScale(ui.icon_price:getContentSize().width / icon:getContentSize().width)
    ed.UITool.replaceUINew(ui, "icon_price", icon)
  end
  item.res = res
  ui.label_price:setString(item.tokenAmount)
  if item.status == "soldOut" then
    ui.layer_own:setVisible(true)
    if item.isShow then
      local tip_lab = ed.createLabelTTF(T("\229\183\178\230\139\165\230\156\137"), 18)
      ed.setLabelColor(tip_lab, ed.toccc3(16767593))
      ui.img_own:addChild(tip_lab)
      ed.layout.centerInParent(tip_lab)
    else
      local img = ed.createSprite("UI/alpha/1080P/newshop/over_tf.png")
      ed.UITool.replaceUINew(ui, "img_own", img)
      local soldout_lab = ed.createLabelTTF(T("\229\148\174\231\189\132"), 20, ed.fontBold)
      ed.setLabelColor(soldout_lab, ed.toccc3(16735838))
      ed.setLabelStroke(soldout_lab, ed.toccc3(2826261), 1.5)
      soldout_lab:limitWidthByScale(56)
      ui.img_own:addChild(soldout_lab)
      ed.layout.centerInParent(soldout_lab)
      ed.UITool.setPositionBy(soldout_lab, ccp(0, 2))
      img:setRotation(-15)
    end
  end
  local token = 0
  if item.tokenType == "Item" then
    token = ed.player:getEquipAmount(ed.timeCorridorMgr.tokenId)
  elseif item.tokenType == "Diamond" then
    token = ed.player._rmb
  else
    token = ed.player:getPoint(item.tokenType) or 0
  end
  local needToken = item.tokenAmount
  item.left_progress = needToken - token
  if item.status == "onSale" and item.showProgress then
    ui.progress:setVisible(true)
    local str = token < needToken and T("\232\191\152\233\156\128%s\229\143\175\229\133\145\230\141\162", "<lable color=ccc3(191,44,44)>" .. needToken - token .. "</lable>") or T("\229\183\178\232\190\190\229\133\145\230\141\162\230\157\161\228\187\182\239\188\129")
    local atxt = ed.ui.autoText.new()
    atxt:initParam({
      context = str,
      fontSize = 13,
      color = ccc3(92, 58, 14)
    })
    ed.UITool.replaceUINew(ui, "label_progress", atxt.node)
  end
  item.ui = ui
  return container, ui
end

function timeCorridorShopScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "back_btn", function()
    ed.popScene()
    FireEvent("refreshTimeCorridorMainScene")
  end, {pressScale = 0.9})
end

function timeCorridorShopScene:registerEvents()
  self:listenEvent("timeCorridorShopReply", function()
    ed.showToast(T("\229\133\145\230\141\162\230\136\144\229\138\159"))
    self:updateDraglist()
  end)
  self:refreshLastTimeStr()
  self:listenTimer(Timer:Always(0.3), function()
    self:refreshLastTimeStr()
  end)
end

function timeCorridorShopScene:refreshLastTimeStr()
  local leftTime = self.endTime - ed.getServerTime()
  if leftTime <= 0 then
    ed.timeCorridorMgr.isOpen = false
    ed.popScene()
    FireEvent("timeCorridorActivityClose")
  end
  leftTime = math.max(0, leftTime)
  self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s", ed.time2dhmsV2(leftTime)))
end
