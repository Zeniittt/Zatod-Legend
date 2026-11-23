local base = ed.ui.basescene
local shopLayer = newclass(base.mt)
ed.ui.shopMain = shopLayer
ed.ui.exteriorShopMain = require("ui_new.modules.shop.exteriorShop.exteriorShopMain")
ed.UITool.registViewOpenFunc("shopMain", function(param)
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Shop")
  if cpl then
    ed.showToast(cpl)
    return
  end
  local npcVis = ed.shopData:getShopOpenVis()
  if npcVis then
    ed.pushScene(ed.ui.shopMain.create(param))
    ListenTimer(Timer:Once(0.2), function()
      ed.UITool.openView("fastsell")
    end)
  else
    ed.showToast(T("\230\154\130\230\151\160\233\155\134\229\184\130\229\188\128\229\144\175"))
  end
end)
local shopBg = {
  [1] = {
    "shop_gold_bg_ipad",
    "shop_gold_bg_1920",
    "shop_gold_bg_2340"
  },
  [2] = {
    "shop_arena_bg_ipad",
    "shop_arena_bg_1920",
    "shop_arena_bg_2340"
  },
  [3] = {
    "shop_crusade_bg_ipad",
    "shop_crusade_bg_1920",
    "shop_crusade_bg_2340"
  },
  [4] = {
    "shop_dream_bg_ipad",
    "shop_dream_bg_1920",
    "shop_dream_bg_2340"
  },
  [5] = {
    "shop_guild_bg_ipad",
    "shop_guild_bg_1920",
    "shop_guild_bg_2340"
  },
  [6] = {
    "shop_cosmetic_bg_1920",
    "shop_cosmetic_bg_1920",
    "shop_cosmetic_bg_1920"
  },
  [7] = {
    "shop_guild_bg_ipad",
    "shop_guild_bg_1920",
    "shop_guild_bg_2340"
  }
}
local identityStr = {
  "shopGold",
  "shopArena",
  "shopCrusade",
  "shopDream",
  "shopGuild",
  "shopCosmetic",
  "shopTavern"
}

function shopLayer.create(param)
  local self = base.create("shopMain")
  setmetatable(self, shopLayer.mt)
  param = param or {}
  self.param = param
  self.page = param.page or 1
  self.container, self.ui = ed.editorui(ed.uieditor.shopMain)
  self.mainLayer:addChild(self.container)
  self.identity = identityStr[self.page]
  self.locateItemId = param.itemId
  self.resourceBoxTouchKey = {}
  self.resourceBox = ed.ui.resourceBox.create(setmetatable({
    btRegisterButtonClick = function(_, _param)
      _param.key = "addbtn_" .. #self.resourceBoxTouchKey
      table.insert(self.resourceBoxTouchKey, {
        key = _param.key
      })
      self:btRegisterButtonClick(_param)
    end,
    btRegisterRectClick = function(_, _param)
      _param.key = "addbtn_" .. #self.resourceBoxTouchKey
      table.insert(self.resourceBoxTouchKey, {
        key = _param.key
      })
      self:btRegisterRectClick(_param)
    end
  }, {__index = self}))
  self.resourceBox:addTo(self.container)
  self.eventScope = {}
  self.timeToItemRes = {}
  self.resourceBox.container:setPositionY(self.resourceBox.container:getPositionY() - 20)
  self:listenEvent("ResourceNumChange", function(resType, id)
    self.resourceBox:updateResourceValue(resType, id)
  end, self.eventScope)
  self:listenEvent("MainBuildRedTagChange", function(buildType)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    if buildType == BuilddingType.Shop then
      self.ui.pan_shop_6_red:setVisible(ed.exteriorShopData.redNum and ed.exteriorShopData.redNum > 0)
    end
  end)
  self.ui.pan_shop_6_red:setVisible(ed.exteriorShopData.redNum and ed.exteriorShopData.redNum > 0)
  local bg, _ = ed.UITool.createSceneTitle(T("\229\149\134 \229\186\151"), self.ui.pan_title, {
    position = ccp(24, 20)
  })
  local rightX = bg:getPositionX() + (1 - bg:getAnchorPoint().x) * bg:getContentSize().width
  self.ui.btn_rule:setPositionX(math.max(self.ui.btn_rule:getPositionX(), rightX + 15))
  self:laySizeAndPos()
  self:createListView()
  self:setShopButton()
  self:setButtonClick()
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
    CloseScope(self.eventScope)
  end)
  self:listenEvent("shopMainUpdate", function(shopId)
    local newShopId = ed.shopData:getShopId(self.page)
    if newShopId == shopId then
      self:updateListView(shopId)
    end
  end, self.eventScope)
  self:listenEvent("shopMainItemUpData", function(data)
    local newShopId = ed.shopData:getShopId(self.page)
    if newShopId == data.shopId and self.passItem then
      local ui = self.passItem.ui
      local itemData = self.passItem.data
      local amount
      if itemData.amountMax and itemData.amountNew then
        amount = itemData.amountMax - itemData.amountNew
      end
      if amount and ui and ui.label_num and not tolua.isnull(ui.label_num) then
        ui.label_num:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", amount))
        ui.label_num:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
        ui.label_num:setColor(ccc3(ed.colorToStr(amount <= 0 and "#FF664B" or "#FFD790")))
        ui.img_nil:setVisible(amount <= 0)
        ui.soldout_shade:setVisible(amount <= 0)
      end
      if itemData.priceType then
        ed.player:subPoint(itemData.priceType, data.num * (itemData.price * (itemData.item.count or 1)) * -1)
      end
      self.passItem = nil
      self.buyIng = nil
    end
  end, self.eventScope)
  local serverTime = ed.getServerTime()
  
  local function timer_funBrk()
    if self.timeToItemRes.shopTime then
      local data = self.timeToItemRes.shopTime
      if not data.isDelete then
        data.time_s = data.time_s - 1
        if data.time_s < 0 then
          if self.passItem then
            return
          end
          ed.shop_network:shopRefresh(1, data.shopId)
          data.isDelete = true
        elseif data.shopId == 1 then
          data.label:setString(T("\228\184\139\230\172\161\229\136\183\230\150\176\230\151\182\233\151\180:") .. ed.serverTime2HMS(data.expireTime) .. ed.getUTCLabel())
          data.label:limitWidthByScale(200)
        else
          data.label:setString(T("\230\175\143\229\145\168\228\184\128  5:00\229\136\183\230\150\176") .. ed.getUTCLabel())
        end
      end
    end
    local shopId = ed.shopData:getShopId(self.page)
    local isUpList = false
    for k, v in pairs(self.timeToItemRes) do
      if k ~= "shopTime" and not v.isDelete then
        v.time_s = v.time_s - 1
        if v.time_s <= 0 then
          v.label:setString(T("\229\183\178\228\184\139\230\158\182"))
          ed.shopData:deleListShopItem(shopId, k)
          isUpList = true
          v.isDelete = true
        else
          v.label:setString(v.time_s .. T("\231\167\146\229\144\142\228\184\139\230\158\182"))
        end
      end
    end
    if isUpList then
      self:updateListView(shopId)
    end
  end
  
  self:listenTimer(Timer:Always(1), timer_funBrk)
  return self
end

function shopLayer:laySizeAndPos()
  local ui = self.ui
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local posx, posy = ui.pan_item:getPosition()
  ui.pan_item:setPosition(posx - newWid, -newHei)
  local size = ui.pan_item:getContentSize()
  size = CCSizeMake(size.width + newWid * 2, size.height + newHei * 2)
  ui.pan_item:setContentSize(size)
  self.thisConList = size
  local bl = widhtWin / heightWin
  if bl <= 1.4 then
    self.bgRes = 1
  elseif 1.77 <= bl then
    self.bgRes = 3
  else
    self.bgRes = 2
  end
  ui.pan_butt:setPosition(-newWid + ed.display.getNotchHeight(), newHei)
  posx, posy = ui.pan_title:getPosition()
  ui.pan_title:setPosition(posx - newWid, posy + newHei)
  posx, posy = ui.pan_updata:getPosition()
  ui.pan_updata:setPosition(posx + newWid - 125, posy + newHei)
  posx = ui.btn_updata:getPositionX()
  ui.btn_updata:setPositionX(posx - 240)
end

local getResType = ed.ui.configs.resType.getResType

function shopLayer:createListView()
  local function ClickInFun(isRight)
    return function(x, y, passItem)
      if not self.newTouch then
        return
      end
      if passItem then
        passItem.ui.img_bj:setScale(1)
      end
      if isRight then
        local amount = 999
        if passItem.data.amountMax and passItem.data.amountNew then
          amount = passItem.data.amountMax - passItem.data.amountNew
        end
        if amount <= 0 then
          ed.showToast(T("\229\141\150\229\133\137\228\186\134\239\188\129"))
          return
        end
        if passItem.data.time and (passItem.ui.timeDele or self.timeToItemRes[passItem.data.id] and 0 >= self.timeToItemRes[passItem.data.id].time_s) then
          ed.showToast(T("\232\175\165\229\149\134\229\147\129\229\183\178\228\184\139\230\158\182\239\188\129"))
          return
        end
        self.passItem = passItem
        local item = passItem.data.item
        local tabs = passItem.data
        local buyResourceBox = ed.ui.buyResourceBox.create({
          buyLimitNum = amount,
          defaultBuyNum = 1,
          goodsResType = getResType(item.type),
          goodsId = item.id,
          costResType = passItem.data.priceType,
          price = passItem.data.price * (item.count or 1),
          buyAction = function(num)
            self.buyIng = true
            local shopId = ed.shopData:getShopId(self.page)
            ed.shop_network:shopConsume(shopId, passItem.data, num)
          end,
          callback = function(num)
            if not self.buyIng then
              self.passItem = nil
            end
          end,
          item = item
        })
        buyResourceBox:setSurplusAmount(amount)
        buyResourceBox:popWindow()
      end
    end
  end
  
  self.draglistShop = ed.UITool.createDraglist(self.ui.pan_item, {
    doPressIn = function(x, y)
      local items = self.items or {}
      for i, v in ipairs(items) do
        if ed.containsPoint(v.ui.img_bj, x, y) then
          v.ui.img_bj:setScale(0.98)
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
end

function shopLayer:updateListView(newShopId)
  self.newTouch = false
  self.shopConfig = ed.shopData:getShoplistData()
  local shopId = ed.shopData:getShopId(self.page)
  local data = self.shopConfig[shopId] or {}
  local wid = self.thisConList.width
  local count = math.floor(wid / 170)
  local posx = wid % 170
  local list = self.draglistShop:getList()
  local listPosx, listPosy = list:getPosition()
  local listHeight = self.draglistShop.listHeight
  self.draglistShop:clearList()
  if #data <= 0 then
    ed.shop_network:checkOpenShop(shopId)
    return
  end
  self.timeToItemRes = {}
  self.shopPagefig = ed.shopData:getShopPageData()
  if self.shopPagefig then
    local data = self.shopPagefig[shopId]
    local time = ed.getFitServerTime()
    local timeRemove = (data.expireTime or 0) - time
    if timeRemove <= 0 then
      ed.shop_network:shopRefresh(1, shopId)
      return
    end
    if shopId == 1 then
      self.ui.Label_1084:setString(T("\228\184\139\230\172\161\229\136\183\230\150\176\230\151\182\233\151\180:") .. ed.serverTime2HMS(data.expireTime) .. ed.getUTCLabel())
      self.ui.Label_1084:limitWidthByScale(200)
    else
      local h, m = ed.time2HMS(data.expireTime)
      self.ui.Label_1084:setString(T("\230\175\143\229\145\168\228\184\128  5:00\229\136\183\230\150\176") .. ed.getUTCLabel())
    end
    self.timeToItemRes.shopTime = {}
    self.timeToItemRes.shopTime.label = self.ui.Label_1084
    self.timeToItemRes.shopTime.expireTime = data.expireTime
    self.timeToItemRes.shopTime.time_s = timeRemove
    self.timeToItemRes.shopTime.shopId = shopId
    self.timeToItemRes.shopTime.autoRefreshTime = data.autoRefreshTime
  end
  local deleTimeIt = {}
  self.items = {}
  local Height, handler, ui, tabs = 0, {}, {}, {}
  for i = 0, #data - 1 do
    tabs = data[i + 1]
    if not tabs then
      break
    end
    if i % count == 0 then
      Height = Height + 198
    end
    handler, ui = ed.editorui(ed.uieditor.shopitem)
    local soldout_label = ui.soldout_label
    ed.setLabelFontName(soldout_label, ed.fontBold)
    ed.setLabelStroke(soldout_label, ed.toccc3(2826261), 1.5)
    ed.adaptLabel(soldout_label, {maxWidth = 56, minScale = 0.65})
    ui.img_bg:setZOrder(-10)
    self.draglistShop:addItem(handler, ccp(i % count * 170 + posx / 2, self.thisConList.height - Height - 15))
    if tabs.item.id then
      local quality = ed.readequip.quality(tabs.item.id) or 1
      local bg_size = ui.img_bg:getContentSize()
      ui.img_bg:setSpriteFrame(ed.getSpriteFrame(string.format("UI/alpha/1080P/shop/shop_goods_bg_%d.png", quality == 4 and 5 or quality)))
      ui.img_bg:setContentSize(bg_size)
    end
    local config = ed.ui.configs.resBar.getResBarConfig(string.lower(tabs.priceType))
    if config then
      local res
      if type(config.smallIcon) == "function" then
        res = config.smallIcon()
      else
        res = config.smallIcon
      end
      ed.initSpriteWithFrame(ui.img_price, res)
      ui.img_price:setScale(config.scale or 1)
    end
    ui.label_name:setString("")
    local amount = 999
    if tabs.amountMax and tabs.amountNew then
      amount = tabs.amountMax - tabs.amountNew
    end
    ui.label_num:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", amount))
    ui.label_num:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
    ui.label_num:setColor(ccc3(ed.colorToStr(amount <= 0 and "#FF664B" or "#FFD790")))
    ui.img_nil:setVisible(amount <= 0)
    ui.soldout_shade:setVisible(amount <= 0)
    local wid = ui.img_bj:getContentSize()
    local icon, name = ed.createItemIcon(tabs.item, true)
    icon:setPosition(wid.width / 2, wid.height - 50)
    icon:setScale(1)
    ui.img_bj:addChild(icon)
    local multiFontSize = {
      cn = 14,
      en = 13,
      tw = 14,
      ko = 13,
      ja = 14,
      es = 13
    }
    local label = ed.createLabelTTF(T("\232\182\133\229\128\188\228\188\152\230\131\160"), multiFontSize[ed.getCurArea()] or 14, ed.fontBold)
    ed.setLabelColor(label, ed.toccc3(15093776))
    ed.setLabelStroke(label, ed.toccc3(16777215), 1.5)
    ed.UITool.replaceUINew(ui, "ImageView_126", label)
    if tabs.item.id == self.locateItemId then
      listPosy = Height - self.thisConList.height + 15
    end
    if ed.readequip.value(tabs.item.id, "Category") == T("\231\129\181\233\173\130\231\159\179") then
      if not ed.isAreaZh() then
        local str = name:getString()
        ed.setLabelString(name, str:gsub("%(", [[

%(]], 1))
      end
      local stoneId = tabs.item.id
      local heroid = ed.readhero.getMakeid(stoneId)
      local hero = ed.player:getHero(heroid)
      if hero and hero._stars == 5 then
        local starMaxTag = ed.createSprite("UI/alpha/1080P/summon/summon_hero_star_max.png")
        local label_star = ed.createttf(T("\229\183\178\230\187\161\230\152\159"), 18, ed.fontBold)
        label_star:limitWidthByScale(80)
        starMaxTag:addChild(label_star)
        ed.layout.centerInParent(label_star)
        ed.setLabelColor(label_star, ed.toccc3(16775796))
        ed.setLabelStroke(label_star, ed.toccc3(9978880), 1)
        starMaxTag:setScale(0.75)
        icon:addChild(starMaxTag)
        starMaxTag:setPosition(ccp(46, 72))
      end
    end
    name:setColor(ccc3(ed.colorToStr("#FFF1D7")))
    name:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
    name:setPositionY(name:getPositionY() - 8)
    ed.adaptLabel(name, {
      maxWidth = wid.width * 0.85,
      minScale = 0.8
    })
    local time = ed.getServerTime()
    local timeRemove = (tabs.time or 0) - time
    if tabs.time then
      if timeRemove < 3 then
        ui.label_time:setString(T("\229\183\178\228\184\139\230\158\182"))
        ui.timeDele = true
        table.insert(deleTimeIt, tabs.id)
      elseif timeRemove <= 600 then
        ui.label_time:setString(timeRemove .. T("\231\167\146\229\144\142\228\184\139\230\158\182"))
        self.timeToItemRes[tabs.id] = {}
        self.timeToItemRes[tabs.id].label = ui.label_time
        self.timeToItemRes[tabs.id].time_s = timeRemove
      elseif 86400 <= timeRemove then
        ui.label_time:setString(math.floor(timeRemove / 86400) .. T("\229\164\169\229\144\142\228\184\139\230\158\182"))
      elseif 3600 <= timeRemove then
        ui.label_time:setString(math.floor(timeRemove / 3600) .. T("\229\176\143\230\151\182\229\144\142\228\184\139\230\158\182"))
      else
        ui.label_time:setString(math.floor(timeRemove / 60) .. T("\229\136\134\233\146\159\229\144\142\228\184\139\230\158\182"))
      end
    else
      ui.pan_time:setVisible(false)
    end
    ui.line_long_price:setVisible(false)
    ui.label_long_price:setVisible(false)
    if tabs.zhe then
    else
      ui.pan_zhe:setVisible(false)
    end
    ui.label_price:setString(tabs.price * (tabs.item.count or 1))
    if tabs.limited and tabs.limited == 1 then
      ed.createLabelTools({
        txt = T("\231\187\136\232\186\171\233\153\144\232\180\173"),
        size = 14,
        pos = ccp(45.75, 11.75),
        color = ed.toccc3(14901535),
        stroke = {
          ccc3(ed.colorToStr("#ffffff")),
          1.3
        },
        font = ed.fontBold,
        parent = ed.createSpriteTools({
          res = "UI/alpha/1080P/newshop/foreverlimit_bg.png",
          pos = ccp(125, 170),
          parent = ui.img_bj,
          scale = 1
        })
      })
    end
    table.insert(self.items, {ui = ui, data = tabs})
  end
  for i, v in ipairs(deleTimeIt) do
    ed.shopData:deleListShopItem(shopId, v)
  end
  self.draglistShop:initListHeight(Height + 18)
  if newShopId and newShopId == shopId and listPosx and listPosy and listHeight then
    if listHeight <= self.draglistShop.listHeight then
      self.draglistShop:setListPos(ccp(listPosx, listPosy), true)
    else
      if self.draglistShop.listHeight <= self.draglistShop.height then
        return
      elseif listPosy > self.draglistShop.listHeight - self.draglistShop.height then
        listPosy = self.draglistShop.listHeight - self.draglistShop.height
      end
      self.draglistShop:setListPos(ccp(listPosx, listPosy), true)
    end
  end
end

function shopLayer:setShopButton()
  local buttIndex
  
  local function clickHandler(index)
    if buttIndex then
      self.ui["btn_shop_" .. buttIndex]:setVisible(true)
      self.ui["btn_shop_" .. buttIndex .. "_pass"]:setVisible(false)
      self.bg:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.1, 150), CCCallFunc:create(function()
        self:setBackground("UI/alpha/1080P/shop/bg/" .. shopBg[index][self.bgRes] .. ".jpg")
        self.bg:setOpacity(150)
      end), CCFadeTo:create(0.1, 255))))
    else
      self:setBackground("UI/alpha/1080P/shop/bg/" .. shopBg[index][self.bgRes] .. ".jpg")
    end
    buttIndex = index
    self.ui["btn_shop_" .. buttIndex]:setVisible(false)
    self.ui["btn_shop_" .. buttIndex .. "_pass"]:setVisible(true)
    self.page = index
    local shopId = ed.shopData:getShopId(self.page)
    self.ui.btn_updata:setVisible(shopId == 1)
    if ed.isElementInTable(shopId, {8, 201}) then
      self.ui.pan_updata:setVisible(false)
    else
      self.ui.pan_updata:setVisible(true)
    end
    if shopId == 201 then
      if self.exteriorShop then
        ed.exteriorShopData:setShopGoodsInfo(nil, true)
        self.exteriorShop:refreshPage()
        self.exteriorShop.layer:setVisible(true)
        self.exteriorShop.draglistShop:setVisible(true)
      else
        self.exteriorShop = ed.ui.exteriorShopMain.new(self)
      end
      self.draglistShop:setVisible(false)
    else
      self.draglistShop:setVisible(true)
      if self.exteriorShop then
        self.exteriorShop.layer:setVisible(false)
        self.exteriorShop.draglistShop:setVisible(false)
      end
      self.shopConfig = ed.shopData:getShoplistData()
      local data = self.shopConfig[shopId] or {}
      if #data <= 0 then
        ed.shop_network:checkOpenShop(shopId)
      else
        ed.shop_network:shopRefresh(1, shopId)
      end
    end
    for i, v in ipairs(self.resourceBoxTouchKey or {}) do
      self:btRemoveMainTouchHandler(v)
    end
    self.resourceBox.container:removeFromParentAndCleanup(true)
    self.identity = identityStr[self.page]
    self.resourceBoxTouchKey = {}
    self.resourceBox = ed.ui.resourceBox.create(setmetatable({
      btRegisterButtonClick = function(_, _param)
        _param.key = "addbtn_" .. #self.resourceBoxTouchKey
        table.insert(self.resourceBoxTouchKey, {
          key = _param.key
        })
        self:btRegisterButtonClick(_param)
      end,
      btRegisterRectClick = function(_, _param)
        _param.key = "addbtn_" .. #self.resourceBoxTouchKey
        table.insert(self.resourceBoxTouchKey, {
          key = _param.key
        })
        self:btRegisterRectClick(_param)
      end
    }, {__index = self}))
    self.resourceBox:addTo(self.container)
    self.resourceBox.container:setPositionY(self.resourceBox.container:getPositionY() - 20)
  end
  
  local vis = false
  local posy = 0
  local showIndex
  for i = 1, 7 do
    vis = ed.shopData:getShopVis(i)
    self.ui["pan_shop_" .. i]:setVisible(vis)
    posy = vis and posy or posy + 63
    self.ui["pan_shop_" .. i]:setPositionY(self.ui["pan_shop_" .. i]:getPositionY() + posy)
    ed.adaptLabel(self.ui["label_shop_" .. i], {maxWidth = 95, minScale = 0.7})
    ed.adaptLabel(self.ui["label_shop_" .. i .. "_pass"], {maxWidth = 95, minScale = 0.7})
    ed.adaptLabel(self.ui["label_shop_" .. i .. "_pass_shadow"], {maxWidth = 95, minScale = 0.7})
    if vis then
      self:btRegisterButtonClick({
        button = self.ui["btn_shop_" .. i],
        key = "btn_shop_" .. i,
        param = {index = i},
        force = true,
        mcpMode = true,
        pressScale = 0.98,
        clickHandler = function(param, x, y)
          clickHandler(param.index)
        end
      })
      showIndex = showIndex or i
      if self.page == i then
        showIndex = i
      end
    end
  end
  if showIndex then
    clickHandler(showIndex)
  end
end

function shopLayer:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.btn_updata,
    key = "btn_updata",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      self:showUpdatePopWin()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_rule,
    key = "btn_rule",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      self:showRulePopWin()
    end
  })
end

function shopLayer:consumeHandler()
  local point = ed.player:getPoint("diamond")
  if point < self.diam then
    ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
  else
    ed.player:subPoint("diamond", self.diam * -1)
    local shopId = ed.shopData:getShopId(self.page)
    ed.shop_network:shopRefresh(2, shopId)
  end
end

function shopLayer:showUpdatePopWin()
  if ed.isOpenConsumeTips() then
    self:showUpdatePopWinLimit()
  else
    self:showUpdatePopWinNormal()
  end
end

function shopLayer:showUpdatePopWinLimit()
  local shopId = ed.shopData:getShopId(self.page)
  local todayTimes = ed.shopData:getRefreshTime(shopId)
  self.diam = ed.shopData:getShopRefreshCost((todayTimes or 0) + 1)
  local str = T("\230\152\175\229\144\166\232\166\129\232\138\177\232\180\185 <sprite src=UI/alpha/1080P/icon/diamond.png>%s \229\136\183\230\150\176\232\180\167\231\137\169\239\188\159<br/>\230\156\172\230\151\165\229\183\178\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154", self.diam)
  str = str .. (todayTimes or 0)
  if ed.ui.consumeTipsWin.isEnableShowWin() then
    ed.UITool.openView("consumeTipsWin", {
      text = str,
      rightHandler = function()
        self:consumeHandler()
      end
    })
  else
    self:consumeHandler()
  end
end

function shopLayer:showUpdatePopWinNormal()
  self.diam = 0
  local upYesBtn, upNobtn
  if not self.upDataContainer then
    local container = CCLayerColor:create(ccc4(0, 0, 0, 70))
    container:registerScriptTouchHandler(function(event, x, y)
      xpcall(function()
        if event == "began" then
          upYesBtn, upNobtn = nil, nil
          if ed.containsPoint(self.upDataContainer.ui.btn_no, x, y) then
            self.upDataContainer.ui.btn_no:setScale(0.95)
            upNobtn = self.upDataContainer.ui.btn_no
          end
          if ed.containsPoint(self.upDataContainer.ui.btn_yes, x, y) then
            self.upDataContainer.ui.btn_yes:setScale(0.95)
            upYesBtn = self.upDataContainer.ui.btn_yes
          end
        elseif event == "ended" then
          if not ed.containsPoint(self.upDataContainer.ui.Panel_1109, x, y) then
            self:closePopwin()
            return
          end
          if upNobtn then
            upNobtn:setScale(1)
          end
          if upYesBtn then
            upYesBtn:setScale(1)
          end
          if ed.containsPoint(self.upDataContainer.ui.btn_no, x, y) then
            self:closePopwin()
          end
          if ed.containsPoint(self.upDataContainer.ui.btn_yes, x, y) then
            if self.isTouch then
              return
            end
            self.isTouch = true
            self:listenTimer(Timer:Once(1), function()
              self.isTouch = false
            end)
            local point = ed.player:getPoint("diamond")
            if point < self.diam then
              ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
            else
              ed.player:subPoint("diamond", self.diam * -1)
              local shopId = ed.shopData:getShopId(self.page)
              ed.shop_network:shopRefresh(2, shopId)
            end
            self:closePopwin()
          end
        end
      end, EDDebug)
      return true
    end, false, -999, true)
    self.mainLayer:addChild(container, 999)
    self.upDataContainer = container
    local containerSca = CCLayer:create()
    container:addChild(containerSca, 999)
    self.upDataContainer.sca = containerSca
    local widhtWin = ed.display.winSize.width
    local heightWin = ed.display.winSize.height
    local newWid = ed.display.halfFixedWidth
    local newHei = ed.display.halfFixedHeight
    container:setPosition(-newWid, -newHei)
    local ui = {}
    local readnode = ed.readnode.create(containerSca, ui)
    readnode:addNode(ed.uieditor.shopPopWin)
    self.upDataContainer.ui = ui
    ui.line_l:setScaleX(-0.5)
    ui.line_l:setScaleY(0.5)
    ui.line_r:setScale(0.5)
    ui.Panel_1109:setPosition(widhtWin / 2 - 205, heightWin / 2 - 111)
  end
  local ui = self.upDataContainer.ui
  ui.txt_pos:removeAllChildrenWithCleanup(true)
  local shopId = ed.shopData:getShopId(self.page)
  local todayTimes = ed.shopData:getRefreshTime(shopId)
  local data = self.shopPagefig[shopId]
  self.diam = ed.shopData:getShopRefreshCost((todayTimes or 0) + 1)
  local str = T("\230\152\175\229\144\166\232\166\129\232\138\177\232\180\185 <sprite src=UI/alpha/1080P/icon/diamond.png>%s \229\136\183\230\150\176\232\180\167\231\137\169\239\188\159<br/>\230\156\172\230\151\165\229\183\178\229\136\183\230\150\176\230\172\161\230\149\176\239\188\154", self.diam)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = str .. (todayTimes or 0),
    fontSize = 19,
    lineSpacing = 4,
    maxWidth = ui.txt_pos:getContentSize().width,
    align = "CENTER"
  })
  ui.txt_pos:addChild(autoText.node)
  local _, height = autoText:getCurContentSize()
  autoText.node:setPosition(0, ui.txt_pos:getContentSize().height - 33)
  self.upDataContainer.sca:setScale(0)
  self.upDataContainer:setVisible(true)
  self.upDataContainer:setTouchEnabled(true)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  self.upDataContainer.sca:runAction(s)
end

function shopLayer:closePopwin()
  if self.upDataContainer then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self.upDataContainer:setVisible(false)
        self.upDataContainer:setTouchEnabled(false)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    self.upDataContainer.sca:runAction(s)
  end
end

local strPage = T("\226\128\156\230\172\162\232\191\142\229\133\137\228\184\180\239\188\140\230\136\145\230\152\175\229\149\134\229\186\151\231\174\161\231\144\134\229\145\152\229\184\140\229\168\156\227\128\130\228\184\186\230\142\168\229\138\168\230\150\135\230\152\142\230\160\145\230\150\176\233\163\142\226\128\157\230\180\187\229\138\168\239\188\140\230\156\172\229\186\151\231\142\176\233\135\135\231\148\168\230\151\160\230\142\165\232\167\166\229\188\143\232\180\173\231\137\169\230\168\161\229\188\143\239\188\140\230\130\168\229\143\170\233\156\128\229\156\168\233\128\137\228\184\173\229\191\131\228\187\170\232\180\167\231\137\169\229\144\142\232\135\170\229\138\169\231\187\147\232\180\166\229\141\179\229\143\175\227\128\130\228\184\141\232\191\135\239\188\140\229\129\135\229\166\130\230\156\137\228\186\186\232\131\134\230\149\162\230\136\145\231\156\188\231\154\174\229\186\149\228\184\139\231\155\151\231\170\131\231\154\132\232\175\157......\226\128\157<br/>") .. T("                                        \226\128\148\226\128\148 \231\172\145\229\174\185\231\148\156\231\190\142\228\189\134\231\163\168\229\136\128\233\156\141\233\156\141\231\154\132\229\184\140\229\168\156<br/>") .. T("<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\153\190\232\180\167\229\149\134\229\186\151\229\176\134\229\156\168\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\144\142\232\167\163\233\148\129\239\188\140\229\133\182\228\189\153\229\149\134\229\186\151\229\176\134\229\156\168\229\175\185\229\186\148\229\138\159\232\131\189\229\188\128\230\148\190\229\144\142\232\167\163\233\148\129\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\153\190\232\180\167\229\149\134\229\186\151\229\176\134\229\156\168\230\175\143\230\151\1659\231\130\185\239\188\14012\231\130\185\239\188\14018\231\130\185\239\188\14021\231\130\185\229\136\183\230\150\176\232\180\167\231\137\169\239\188\140\231\142\169\229\174\182\228\185\159\229\143\175\228\187\165\230\182\136\232\128\151\233\146\187\231\159\179\232\191\155\232\161\140\230\137\139\229\138\168\229\136\183\230\150\176\227\128\130\229\133\182\228\189\153\229\149\134\229\186\151\229\176\134\229\156\168\230\175\143\229\145\168\228\184\1285\231\130\185\229\136\183\230\150\176\232\180\167\231\137\169\239\188\140\228\184\141\229\143\175\230\137\139\229\138\168\229\136\183\230\150\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\189\191\231\148\168\233\135\145\229\184\129\229\146\140\233\146\187\231\159\179\239\188\140\229\143\175\229\156\168\231\153\190\232\180\167\229\149\134\229\186\151\228\184\173\232\180\173\228\185\176\232\180\167\231\137\169\239\188\140\231\153\190\232\180\167\229\149\134\229\186\151\231\154\132\232\180\167\231\137\169\229\147\129\231\177\187\229\176\134\233\154\143\231\142\169\229\174\182\230\136\152\233\152\159\231\173\137\231\186\167\231\154\132\230\136\144\233\149\191\232\128\140\228\184\176\229\175\140\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\189\191\231\148\168\229\175\185\229\186\148\228\187\163\229\184\129\239\188\140\229\143\175\229\156\168\229\133\182\228\189\153\229\149\134\229\186\151\228\184\173\232\180\173\228\185\176\232\180\167\231\137\169\239\188\140\230\175\143\231\167\141\228\187\163\229\184\129\231\154\132\230\140\129\230\156\137\228\184\138\233\153\144\229\157\135\228\184\18610\228\184\135\227\128\130<br/>")

function shopLayer:showRulePopWin()
  ed.ui.commonRulePop.create({
    title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
    txt = strPage
  }):popWindow()
end

function shopLayer:closeRulePopwin()
  if self.ruleContainer then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self.ruleContainer:setVisible(false)
        self.ruleContainer:setTouchEnabled(false)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    self.ruleContainer.sca:runAction(s)
  end
end
