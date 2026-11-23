local base = ed.ui.framework
local class = newclass(base.mt)
ed.ui.shop = class
local lsr = ed.ui.shoplsr.create()
local config = ed.ui.marketconfig

local function showTutorialHandler(self)
  local isSellout = true
  for k, v in pairs(self.goods) do
    if v.data.amount > 0 then
      isSellout = false
      break
    end
  end
  if isSellout then
    ed.teach("refreshShop", self.ui.refresh, self.mainLayer)
  end
end

class.showTutorialHandler = showTutorialHandler

local function showTalk(self, key, callback, str1)
  local str = str1 or ed.ui.market.getTalkContent(self.shop, key)
  if not str then
    return
  end
  if key == "Touch" and self.shop == config.shopName2IdTbl.soSpecial and not self.isSpecialShopVisited then
    return
  end
  if not tolua.isnull(self.talkBg) then
    self.talkBg:removeFromParentAndCleanup(true)
  end
  str = str or ""
  local bg = ed.createNode({
    t = "Sprite",
    config = {isCascadeOpacity = true}
  }, self.container, 60)
  self.talkBg = bg
  local frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = config.getuiConfig(self.shop).talkBgRes,
      capInsets = CCRectMake(30, 15, 110, 26)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(190, 360)
    },
    config = {isCascadeOpacity = true}
  }, bg)
  local talk = ed.createNode({
    t = "Label",
    base = {text = str, size = 20},
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, frame:getContentSize().height / 2)
    }
  }, frame)
  local size = talk:getContentSize()
  frame:setContentSize(CCSizeMake(size.width + 30, 56))
  local delay = CCDelayTime:create(1)
  local action = CCFadeOut:create(1)
  local remove = CCCallFunc:create(function()
    xpcall(function()
      if self then
        bg:removeFromParentAndCleanup(true)
        if callback then
          callback()
        end
      end
    end, EDDebug)
  end)
  bg:runAction(ed.readaction.create({
    t = "seq",
    delay,
    action,
    remove
  }))
end

class.showTalk = showTalk

local function refreshCostLabel(self)
  for k, v in pairs(self.goods or {}) do
    local data = v.data
    if not tolua.isnull(v.ui.costLabel) then
      local color = config.getuiConfig(self.shop).costLabelColor
      if data.amount >= 1 and not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
        color = ccc3(255, 0, 0)
      end
      ed.setLabelColor(v.ui.costLabel, color)
    end
  end
  for k, v in pairs(self.simpleGoods or {}) do
    local data = v.data
    if not tolua.isnull(v.ui.costLabel) and not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
      ed.setLabelColor(v.ui.costLabel, ccc3(255, 0, 0))
    end
  end
end

class.refreshCostLabel = refreshCostLabel

local function refreshCostHandler(self)
  local function handler()
    if self.buyLayer and not self.buyLayer:checknull() then
      self.buyLayer:refreshCostColor()
    end
    self:refreshCostLabel()
  end
  
  return handler
end

class.refreshCostHandler = refreshCostHandler

local function refreshSimpleGoods(self, result, index)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if result then
    lsr:report("buySuccess")
    if self.buyLayer and not self.buyLayer:checknull() then
      self.buyLayer:destroy()
    end
    local simpleGoods = self.simpleGoods[index]
    simpleGoods.data.cur_buy_times = simpleGoods.data.cur_buy_times + 1
    simpleGoods.ui.canBuy:setString(simpleGoods.data.cur_buy_times .. "/" .. simpleGoods.data.max_buy_times)
    if simpleGoods.data.cur_buy_times == simpleGoods.data.max_buy_times then
      simpleGoods.ui.noneTag:setVisible(true)
      simpleGoods.ui.noneLable:setVisible(true)
      ed.setLabelColor(simpleGoods.ui.canBuy, ccc3(255, 0, 0))
    end
    self:refreshCostLabel()
  else
    lsr:report("buyFailed")
  end
  self:showTalk("Purchase")
end

class.refreshSimpleGoods = refreshSimpleGoods

local function refreshGoods(self, result, index)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if result then
    lsr:report("buySuccess")
    if self.buyLayer and not self.buyLayer:checknull() then
      self.buyLayer:destroy()
    end
    local goods = self.goods[index]
    goods.data.amount = 0
    goods.ui.noneTag:setVisible(true)
    if goods.ui.noneLable then
      goods.ui.noneLable:setVisible(true)
    end
    self:refreshCostLabel()
    self:checkShowSoldoutTip()
    if config.hasRefreshButton(self.shop) then
      self:showTutorialHandler()
    end
  else
    lsr:report("buyFailed")
  end
  self:showTalk("Purchase")
  if config.willAutoExit(self.shop) and ed.player:checkShopGoodsEmpty(self.shop) then
    self:showTalk("Expire", function()
      ed.popScene()
    end)
  end
end

class.refreshGoods = refreshGoods

local function buyReply(self)
  local function refreshData(result, data)
    if result and data then
      local shop = data.shop
      
      local goods = data.goods
      ed.player:addEquip(goods.id, goods.amount)
      if self:isHideStarShop() then
        ed.player:consumeEquip(goods.payid, goods.cost)
      else
        ed.player:addPoint(goods.pay, -goods.cost)
      end
      ed.player:buyShopGoods(shop, goods.slot)
      ed.ShopMgr.getInstance():refreshBuyedOneItemInAllItemList(shop, goods.id)
    end
  end
  
  local function handler(result, data)
    refreshData(result, data)
    self:refreshGoods(result, data.goods.index)
  end
  
  return handler
end

class.buyReply = buyReply

local function buySimpleReply(self)
  local function refreshData(result, data)
    if result and data then
      local shop = data.shop
      
      local simpleGoods = data.simpleGoods
      ed.player:addEquip(simpleGoods.id, simpleGoods.amount)
      ed.player:addPoint(simpleGoods.pay, -simpleGoods.cost)
    end
  end
  
  local function handler(result, data)
    refreshData(result, data)
    self:refreshSimpleGoods(result, data.simpleGoods.index)
  end
  
  return handler
end

class.buySimpleReply = buySimpleReply

local function upBuy(self, data)
  if data.cur_buy_times == nil then
    ed.registerNetReply("shop_consume", self:buyReply(), {
      shop = self.shop,
      goods = data
    })
    local msg = ed.upmsg.shop_consume()
    msg._sid = self.shop
    msg._slotid = data.slot
    msg._itemid = data.id
    msg._amount = data.amount
    ed.send(msg, "shop_consume")
    if self.ssDestroy then
      self.ssDestroy()
    end
  else
    ed.registerNetReply("simple_shop_reply", self:buySimpleReply(), {
      shop = self.shop,
      simpleGoods = data
    })
    local msg = ed.upmsg.simple_shop_req()
    local simpleGoods = {}
    simpleGoods._goods_id = data.goodsID
    msg._simple_shop_buy = simpleGoods
    ed.send(msg, "simple_shop")
    if self.ssDestroy then
      self.ssDestroy()
    end
  end
end

class.upBuy = upBuy

local function doBuy(self, data)
  local function handler(addition)
    if config.checkPackageFull(data.id, data.amount) then
      ed.showToast(T("\230\130\168\231\154\132\232\131\140\229\140\133\230\178\161\230\156\137\232\182\179\229\164\159\231\154\132\231\169\186\233\151\180"))
    elseif not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
      if data.pay == "gold" then
        ed.showHandyDialog("useMidas", {
          callback = self:refreshCostHandler(),
          refreshHandler = self:refreshCostHandler()
        })
      elseif data.pay == "diamond" then
        ed.showHandyDialog("toRecharge", {
          callback = self:refreshCostHandler()
        })
      elseif data.pay == "crusadepoint" then
        ed.showToast(T("\230\130\168\231\154\132\233\190\153\233\179\158\231\161\172\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "arenapoint" then
        ed.showToast(T("\230\130\168\231\154\132\232\167\146\230\150\151\229\163\171\231\161\172\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "guildpoint" then
        ed.showToast(T("\230\130\168\231\154\132\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "honourpoint" then
        ed.showToast(T("\230\130\168\231\154\132\229\183\133\229\179\176\231\161\172\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "gvgpoint" then
        ed.showToast(T("\230\130\168\231\154\132\229\190\129\230\156\141\231\161\172\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "dreampoint" then
        ed.showToast(T("\230\130\168\231\154\132\230\162\166\229\162\131\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "gcwpoint" then
        ed.showToast(T("\230\130\168\231\154\132\229\156\163\231\186\185\231\161\172\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "wood" then
        ed.showToast(T("\230\130\168\231\154\132\230\156\168\229\164\180\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "iron" then
        ed.showToast(T("\230\130\168\231\154\132\231\148\159\233\147\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "crystal" then
        ed.showToast(T("\230\130\168\231\154\132\230\176\180\230\153\182\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "soulstone" then
        ed.showToast(T("\230\130\168\231\154\132\231\129\181\233\173\130\231\159\179\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "item_2048" then
        ed.showToast(T("\230\130\168\231\154\132\231\129\181\233\173\130\231\159\179\229\133\145\230\141\162\229\136\184\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "legend_point" then
        ed.showToast(T("\230\130\168\231\154\132\228\188\160\229\165\135\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      elseif data.pay == "star_point" then
        ed.showToast(T("\230\130\168\231\154\132\230\152\159\229\184\129\230\149\176\231\155\174\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\232\180\173\228\185\176"))
      end
    else
      if addition then
        self.ssDestroy = addition.ssDestroy
      end
      self:upBuy(data)
    end
  end
  
  return handler
end

class.doBuy = doBuy

local function doPressInProduct(self)
  local function handler(x, y)
    ed.playEffect(ed.sound.deo.common_click_feedback)
    
    local parent = self.draglist.listLayer
    for i, v in ipairs(self.goods or {}) do
      local st = config.getBuyType(self.shop)
      if st == "coin" or self:isHideStarShop() then
        local panel = v.ui.panel
        if ed.containsPoint(panel, x, y, parent) then
          panel:setScale(0.95)
          return i
        end
      elseif st == "stone" then
        local panel = v.ui.item_bg
        if ed.containsPoint(panel, x, y, parent) then
          v.ui.item_press:setVisible(true)
          return i
        end
      end
    end
    for i, v in ipairs(self.simpleGoods or {}) do
      local panel = v.ui.panel
      if ed.containsPoint(panel, x, y, parent) then
        v.ui.redLight:setVisible(false)
        panel:setScale(0.95)
        return i + self.numOfNormalGoods
      end
    end
  end
  
  return handler
end

class.doPressInProduct = doPressInProduct

local function cancelPressInProduct(self)
  local function handler(x, y, id)
    local st = config.getBuyType(self.shop)
    
    local ui = {}
    if st == "stone" or id <= self.numOfNormalGoods then
      ui = self.goods[id].ui
    elseif self.simpleGoods then
      ui = self.simpleGoods[id - self.numOfNormalGoods].ui
    end
    if st == "coin" or self:isHideStarShop() then
      ui.panel:setScale(1)
    elseif st == "stone" and ui.item_press then
      ui.item_press:setVisible(false)
    end
  end
  
  return handler
end

class.cancelPressInProduct = cancelPressInProduct

local function cancelClickInProduct(self)
  local function handler(x, y, id)
    local st = config.getBuyType(self.shop)
    
    local ui = {}
    if st == "stone" or id <= self.numOfNormalGoods then
      ui = self.goods[id].ui
    else
      ui = self.simpleGoods[id - self.numOfNormalGoods].ui
    end
    if st == "coin" or self:isHideStarShop() then
      ui.panel:setScale(1)
    elseif st == "stone" and ui.item_press then
      ui.item_press:setVisible(false)
    end
  end
  
  return handler
end

class.cancelClickInProduct = cancelClickInProduct

local function doClickInProduct(self)
  local function handler(x, y, id)
    local st = config.getBuyType(self.shop)
    
    local layer = self.draglist.listLayer
    local ui = {}
    local data = {}
    if st == "stone" or id <= self.numOfNormalGoods then
      ui = self.goods[id].ui
      data = self.goods[id].data
      if data.amount <= 0 then
        self:showTalk("Soldout")
        return
      end
    elseif self.simpleGoods then
      ui = self.simpleGoods[id - self.numOfNormalGoods].ui
      data = self.simpleGoods[id - self.numOfNormalGoods].data
      if data.cur_buy_times >= data.max_buy_times then
        self:showTalk("Soldout")
        ui.panel:setScale(1)
        return
      end
    end
    if st == "coin" then
      local panel = ui.panel
      panel:setScale(1)
      if self.isAutoRefreshing then
        return
      end
      if id <= self.numOfNormalGoods then
        if ed.containsPoint(panel, x, y, layer) then
          self:openBuyPanel(id)
        end
      elseif ed.containsPoint(panel, x, y, layer) then
        self:openBuySimplePanel(id - self.numOfNormalGoods)
      end
    elseif self:isHideStarShop() then
      local panel = ui.panel
      panel:setScale(1)
      if self.isAutoRefreshing then
        return
      end
      if ed.containsPoint(panel, x, y, layer) then
        if not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
          if data.pay == "item_2048" then
            ed.showToast(T("\231\129\181\233\173\130\231\159\179\229\133\145\230\141\162\229\136\184\230\149\176\233\135\143\228\184\141\232\182\179,\230\151\160\230\179\149\232\180\173\228\185\176"))
          else
            ed.showToast(T("\231\129\181\233\173\130\231\159\179\230\149\176\233\135\143\228\184\141\232\182\179,\230\151\160\230\179\149\232\180\173\228\185\176"))
          end
        else
          ed.ui.starshopbuywindow.create({
            sid = self.shop,
            slotid = id,
            data = self.goods[id].data,
            addition = self.goods[id].addition,
            doBuy = self:doBuy(data),
            callback = function(result)
              self:refreshGoods(result, id)
            end
          })
        end
      end
    elseif st == "stone" then
      if ui.item_press then
        ui.item_press:setVisible(false)
      end
      if ed.containsPoint(ui.item_bg, x, y, layer) then
        if not config.checkMoneyEnough(data.pay, data.cost, data.payid) then
          if data.pay == "item_2048" then
            ed.showToast(T("\231\129\181\233\173\130\231\159\179\229\133\145\230\141\162\229\136\184\230\149\176\233\135\143\228\184\141\232\182\179,\230\151\160\230\179\149\232\180\173\228\185\176"))
          else
            ed.showToast(T("\231\129\181\233\173\130\231\159\179\230\149\176\233\135\143\228\184\141\232\182\179,\230\151\160\230\179\149\232\180\173\228\185\176"))
          end
        else
          ed.ui.starshopbuywindow.create({
            sid = self.shop,
            slotid = id,
            data = self.goods[id].data,
            addition = self.goods[id].addition,
            callback = function(result)
              self:refreshGoods(result, id)
            end
          })
        end
      end
    end
  end
  
  return handler
end

class.doClickInProduct = doClickInProduct

local function doSendRefresh(self)
  self:showTalk("Refresh")
  ed.registerNetReply("refresh_shop", self:refreshList({from = "refresh"}), {
    id = self.shop,
    type = 2
  })
end

class.doSendRefresh = doSendRefresh

local function doRefresh(self)
  local function handler()
    ed.endTeach("refreshShop")
    
    if config.canRefresh(self.shop) then
      self:doSendRefresh()
    end
  end
  
  return handler
end

class.doRefresh = doRefresh

local function doClickSwitch(self)
  lsr:report("doClickSwitch")
  for k, v in pairs(ed.ShopMgr.simple_shop_notify or {}) do
    if v[".data"]._shop_id == self.shop then
      v[".data"].isVisible = false
    end
  end
  ed.ui.shopSeleteListWin:create()
end

class.doClickSwitch = doClickSwitch

local function doClickRule(self)
  local content = {}
  if self.shop == config.toId.diamondShop then
    content = {
      T("<text|normalButton|1.\233\153\144\230\151\182\228\188\152\230\131\160\229\149\134\229\186\151\233\128\154\232\191\135\230\182\136\232\128\151\228\189\147\229\138\155\232\167\166\229\143\145\227\128\130|482>"),
      T("<text|normalButton|2.\233\153\144\230\151\182\228\188\152\230\131\160\229\149\134\229\186\151\230\175\143\229\164\169\229\143\170\232\144\165\228\184\154\228\184\128\230\172\161\239\188\140\228\184\128\230\172\161\230\140\129\231\187\173\230\151\182\233\151\18030\229\136\134\233\146\159\239\188\140\230\175\143\230\151\16505:00\230\129\162\229\164\141\232\144\165\228\184\154\230\172\161\230\149\176\227\128\130|482>"),
      T("<text|normalButton|3.\233\153\144\230\151\182\228\188\152\230\131\160\229\149\134\229\186\151\229\135\186\229\148\174\231\137\169\229\147\129\228\184\141\229\143\175\229\136\183\230\150\176\227\128\130|482>")
    }
  else
    content = {
      T("<text|normalButton|1.\229\149\134\229\186\151\232\180\167\231\137\169\229\136\134\228\184\186\233\153\144\230\151\182\229\133\145\230\141\162\229\146\140\229\184\184\232\167\132\229\133\145\230\141\162\228\184\164\231\167\141\231\177\187\229\158\139\227\128\130|482>"),
      T("<text|normalButton|2.\229\184\184\232\167\132\229\133\145\230\141\162\232\180\167\231\137\169\229\176\134\229\156\168\230\175\143\230\151\165\230\153\154\228\184\1389\231\130\185\229\136\183\230\150\176\239\188\140\231\142\169\229\174\182\229\143\175\228\187\165\228\189\191\231\148\168\229\149\134\229\186\151\229\175\185\229\186\148\232\180\167\229\184\129\232\191\155\232\161\140\230\137\139\229\138\168\229\136\183\230\150\176\227\128\130|482>"),
      T("<text|normalButton|3.\233\153\144\230\151\182\229\133\145\230\141\162\232\180\167\231\137\169\233\153\144\230\151\182\228\184\138\230\158\182\239\188\140\230\156\137\229\133\145\230\141\162\230\172\161\230\149\176\228\184\138\233\153\144\239\188\140\228\184\141\232\131\189\232\191\155\232\161\140\230\137\139\229\138\168\229\136\183\230\150\176\227\128\130|482>")
    }
  end
  local win = ed.ui.bookmapruleswindow.create(content)
  self.mainLayer:addChild(win.mainLayer, 100)
end

class.doClickRule = doClickRule

local function doClickDeadlineExchange(self)
  ed.ui.PvpUpgradeNoticeWin.create():DeadlineRules()
end

class.doClickDeadlineExchange = doClickDeadlineExchange

local function doClickRefresh(self)
  lsr:report("clickRefresh")
  local haveRefreshedTimes = ed.player:getRefreshShopTimes(self.shop) or 0
  if haveRefreshedTimes < 300 then
    local info = {
      text = T("\230\152\190\231\164\186\228\184\128\230\137\185\230\150\176\231\154\132\229\184\184\232\167\132\232\180\167\231\137\169\233\156\128\232\166\129\230\182\136\232\128\151%d%s\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159(\228\187\138\230\151\165\229\183\178\229\136\183\230\150\176%d\230\172\161)", ed.player:getShopRefreshCost(self.shop), config.getRefreshCoinName(self.shop), haveRefreshedTimes),
      rightHandler = self:doRefresh()
    }
    ed.showConfirmDialog(info)
  else
    local info = {
      text = T("\232\190\190\229\136\176\229\136\183\230\150\176\228\184\138\233\153\144\230\172\161\230\149\176\230\151\160\230\179\149\231\187\167\231\187\173\229\136\183\230\150\176"),
      buttonText = T("\231\161\174\229\174\154")
    }
    ed.showAlertDialog(info)
  end
end

class.doClickRefresh = doClickRefresh

local function openBuySimplePanel(self, id)
  local data = self.simpleGoods[id].data
  if self.buyLayer and not self.buyLayer:checknull() then
    self.buyLayer:destroy({skipAnim = true})
  end
  data.doBuy = self:doBuy(data)
  self.buyLayer = ed.ui.equipboard.init("ofbuy", data)
  self.scene:addChild(self.buyLayer.mainLayer, 110)
  self.buyLayer:show()
end

class.openBuySimplePanel = openBuySimplePanel

local function openBuyPanel(self, id)
  local data = self.goods[id].data
  if self.buyLayer and not self.buyLayer:checknull() then
    self.buyLayer:destroy({skipAnim = true})
  end
  data.doBuy = self:doBuy(data)
  self.buyLayer = ed.ui.equipboard.init("ofbuy", data)
  self.scene:addChild(self.buyLayer.mainLayer, 110)
  self.buyLayer:show()
end

class.openBuyPanel = openBuyPanel

local function createGoods(self)
  local goods = {}
  local container = self.listContainer
  local equipInfo = ed.getDataTable("equip")
  local shopData = ed.player:getShopGoods(self.shop)
  self.numOfNormalGoods = #shopData
  local simpleCol = math.floor((self.numOfSimpleGoods + 1) / 2)
  local col = math.floor((#shopData + 1) / 2)
  local dx = 0 < col and 78 or 68
  local pointx = dx + simpleCol * 187
  local normalGoodsBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/normal_goods_bg.png"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(pointx, 20)
    },
    config = {isCascadeOpacity = true}
  }, container)
  normalGoodsBg:setScaleX(col * 0.402)
  local refresh_info = {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(48, 48, 48, 48),
      res = "UI/alpha/HVGA/shop_refresh_new.png",
      name = "refresh",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(pointx + 10, 320)
    }
  }
  local refreshButton = ed.createNode(refresh_info, container)
  refreshButton:setScale(0.9)
  if refreshButton then
    self:btRegisterButtonClick({
      button = refreshButton,
      key = "refresh_button",
      force = true,
      clickHandler = function()
        self:doClickRefresh()
      end
    })
  end
  local timeTitle, timeTitleSuffix = self:getTimeTitle()
  local time_info = {
    {
      t = "HorizontalNode",
      base = {
        name = "time_title_node",
        nodeArray = ui
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(pointx + 50, 320)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "normal_exchange",
            text = "\229\184\184\232\167\132\229\133\145\230\141\162",
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(92, 229, 157)
          }
        },
        {
          t = "Label",
          base = {
            name = "time_title",
            text = timeTitle,
            size = 18,
            offset = 10
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "time",
            text = "00:00:00",
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(255, 234, 198)
          }
        },
        {
          t = "Label",
          base = {
            name = "time_suffix",
            text = timeTitleSuffix,
            size = 18,
            offset = 0
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        }
      }
    }
  }
  local ui = self.ui
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(time_info)
  for k, v in ipairs(shopData or {}) do
    local tag, slot
    local isShowHotTag = config.isShowHotTag(self.shop)
    if isShowHotTag == true then
      slot = v.slot
      tag = v.tag
      v = v.good
    elseif isShowHotTag == false then
      slot = v.slot
      v = v.good
    end
    local info = equipInfo[v._id]
    if info and info.Icon then
      local data = {
        data = {
          index = #goods + 1,
          id = v._id,
          pay = v._type,
          payid = v._price_value,
          price = v._price,
          amount = v._amount,
          cost = v._price * math.max(v._amount, 1),
          slot = slot or k,
          res = info.Icon,
          name = info.Name,
          tag = tag,
          category = info.Category,
          sale = v._discount_type,
          saleValue = v._discount_perct
        },
        addition = {
          name = info.Name
        },
        ui = {}
      }
      if v._type == "item_2048" then
        data.data.payid = 2048
      end
      table.insert(goods, data)
    end
  end
  local block = math.floor(#goods / 6)
  local remain = #goods % 6
  local isHideStar = self:isHideStarShop()
  local isStarGate = self:isStarGateShop()
  
  local function getItemPos(index)
    local ox = pointx + 5
    local oy = 236
    local dx, dy = 180, 135
    local row = index % 2
    local col = math.floor((index - 1) / 2)
    return ccp(ox + dx * col, oy - dy * row)
  end
  
  local function getListWidth()
    local dx = 185
    return dx * (#goods / 2 + math.floor((self.numOfSimpleGoods + 1) / 2))
  end
  
  for i = 1, #goods do
    local data = goods[i].data
    local ui = goods[i].ui
    local ox = 91
    local nameText = 1 < data.amount and data.name .. " x " .. data.amount or data.name
    ui.panel = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).productBgRes
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = getItemPos(i)
      },
      config = {isCascadeOpacity = true}
    }, container)
    if ed.isComplexText(nameText) then
      ui.name = ed.createNode({
        t = "ComplexLabel",
        base = {text = nameText, size = 15},
        layout = {
          position = ccp(ox, 120)
        },
        config = {
          color = ccc3(69, 59, 56)
        }
      }, ui.panel)
    else
      local info = {
        t = "Label",
        base = {text = nameText, size = 18},
        layout = {
          position = ccp(ox, 120)
        },
        config = {
          color = ccc3(69, 59, 56)
        }
      }
      ui.name = ed.createNode(info, ui.panel)
    end
    ui.icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIconWithAmount(data.id, nil, data.amount)
      },
      layout = {
        position = ccp(ox, 79)
      }
    }, ui.panel)
    ui.icon:setScale(0.75)
    ui.coinIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getCoinRes(data.pay)
      },
      layout = {
        position = ccp(40, 23)
      }
    }, ui.panel)
    ui.costLabel = ed.createNode({
      t = "Label",
      base = {
        text = tostring(data.cost),
        size = 20
      },
      layout = {
        position = ccp(ox, 23)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, ui.panel)
    if data.sale then
      self:createSaleIcon(data, ui)
    end
    local tagRes = config.getHotTagRes(data.tag)
    if tagRes then
      ui.tagIcon = ed.createNode({
        t = "Sprite",
        base = {res = tagRes},
        layout = {
          position = ccp(55, 55)
        }
      }, ui.panel)
    end
    ui.noneTag = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/shop_none_tag_1.png",
        z = 9
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        visible = 1 > data.amount
      }
    }, ui.panel)
    ui.noneLable = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/goods_sellout.png",
        z = 10
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(20, 60)
      },
      config = {
        visible = 1 > data.amount
      }
    }, ui.panel)
    local tag
    if ed.isPropEquipable(data.id) then
      tag = ed.createSprite("UI/alpha/HVGA/can_deal_tag.png")
      local size = ui.icon:getContentSize()
      local px = size.width - 8
      tag:setPosition(ccp(px, px))
      ui.icon:addChild(tag)
    end
  end
  if isHideStar then
    self:adjustForHideStarShop(goods)
  end
  if isStarGate then
    self:adjustForStarGateShop(goods)
  end
  self.draglist:initListWidth(getListWidth())
  return goods
end

class.createGoods = createGoods

local function createSimpleGoods(self)
  if self.numOfSimpleGoods <= 0 then
    return
  end
  local goods = {}
  local container = self.simpleListContainer
  local simpleGoodsBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/deadline_goods_bg.png"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(68, 20)
    },
    config = {isCascadeOpacity = true}
  }, container)
  local simpleExchange = ed.createNode({
    t = "Label",
    base = {
      text = "\233\153\144\230\151\182\229\133\145\230\141\162",
      size = 18
    },
    layout = {
      position = ccp(125, 320)
    },
    config = {
      color = ccc3(229, 92, 218)
    }
  }, container)
  local col = math.floor((self.numOfSimpleGoods + 1) / 2)
  simpleGoodsBg:setScaleX(0.08 + col * 0.9 + (col - 1) * 0.01)
  local equipInfo = ed.getDataTable("equip")
  local isRedVisible = false
  for k, v in pairs(ed.ShopMgr.simple_shop_notify or {}) do
    if v[".data"]._shop_id == self.shop then
      isRedVisible = v[".data"].isVisible
      break
    end
  end
  for k, v in ipairs(self.simpleInfo or {}) do
    if rawget(v, "good") or rawget(v[".data"] or {}, "good") then
      v = v.good
    end
    local info = equipInfo[v._item_id]
    if info and info.Icon then
      local data = {
        data = {
          index = #goods + 1,
          id = v._item_id,
          goodsID = v._id,
          amount = v._item_amount,
          pay = v._price_type,
          payid = nil,
          price = v._price_value,
          cost = v._item_amount * v._price_value,
          cur_buy_times = v._cur_buy_times,
          max_buy_times = v._max_buy_times,
          deadline = v._deadline,
          slot = slot or k,
          res = info.Icon,
          name = info.Name,
          category = info.Category
        },
        addition = {
          name = info.Name
        },
        ui = {}
      }
      table.insert(goods, data)
    end
  end
  
  local function getItemPos(index)
    local ox = 166
    local oy = 236
    local dx, dy = 180, 135
    return ccp(ox + math.floor((index - 1) / 2) * dx, oy - dy * ((index - 1) % 2))
  end
  
  local function getListWidth()
    local dx = 188
    local offset_x = 0
    return dx * math.floor((#goods + 1) / 2) + offset_x
  end
  
  for i = 1, #goods do
    local data = goods[i].data
    local ui = goods[i].ui
    local ox = 91
    local nameText = 1 < data.amount and data.name .. " x " .. data.amount or data.name
    local day = math.floor((data.deadline - ed.getServerTime()) / 86400)
    local hour = math.floor((data.deadline - ed.getServerTime()) / 3600)
    local minute = math.floor((data.deadline - ed.getServerTime()) / 60)
    local time
    if day < 1 then
      if hour < 1 then
        time = "\233\153\144\230\151\182\n" .. minute .. "\229\136\134"
      else
        time = "\233\153\144\230\151\182\n" .. hour .. "\230\151\182"
      end
    else
      time = "\233\153\144\230\151\182\n" .. day .. "\229\164\169"
    end
    local canBuy = data.cur_buy_times .. "/" .. data.max_buy_times
    ui.panel = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).simpleProductBgRes
      },
      layout = {
        position = getItemPos(i)
      },
      config = {isCascadeOpacity = true}
    }, container)
    if ed.isComplexText(nameText) then
      ui.name = ed.createNode({
        t = "ComplexLabel",
        base = {text = nameText, size = 15},
        layout = {
          position = ccp(ox, 120)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      }, ui.panel)
    else
      local info = {
        t = "Label",
        base = {text = nameText, size = 18},
        layout = {
          position = ccp(ox, 120)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      }
      ui.name = ed.createNode(info, ui.panel)
    end
    ui.icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIconWithAmount(data.id, nil, data.amount)
      },
      layout = {
        position = ccp(ox, 79)
      }
    }, ui.panel)
    ui.icon:setScale(0.75)
    ui.coinIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getCoinRes(data.pay)
      },
      layout = {
        position = ccp(40, 23)
      }
    }, ui.panel)
    ui.costLabel = ed.createNode({
      t = "Label",
      base = {
        text = tostring(data.cost),
        size = 20
      },
      layout = {
        position = ccp(ox, 23)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, ui.panel)
    ui.noneTag = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/shop_none_tag_2.png"
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        visible = data.cur_buy_times >= data.max_buy_times
      }
    }, ui.panel)
    ui.noneLable = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/goods_sellout.png",
        z = 10
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(100, 70)
      },
      config = {
        visible = data.cur_buy_times >= data.max_buy_times
      }
    }, ui.panel)
    ui.redLight = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/main_deal_tag.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(162, 135)
      },
      config = {visible = isRedVisible}
    }, ui.panel)
    ui.deadlingIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/deadline_icon.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(2, 58)
      },
      config = {rotation = -90, flip = "x"}
    }, ui.panel)
    ui.deadlineLabel = ed.createNode({
      t = "Label",
      base = {text = time, size = 15},
      layout = {
        anchor = ccp(0, 1),
        position = ccp(2, 95)
      },
      config = {
        horizontalAlignment = kCCTextAlignmentLeft,
        color = ccc3(255, 246, 0),
        shadow = {
          color = ccc3(6, 24, 59),
          offset = ccp(0, 2)
        }
      }
    }, ui.panel)
    ui.canBuyLabel = ed.createNode({
      t = "Label",
      base = {
        text = "\233\153\144\232\180\173\230\172\161\230\149\176\239\188\154",
        size = 11
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(ox - 10, 46)
      },
      config = {
        color = ccc3(255, 255, 255),
        scalexy = {y = 1, x = 1},
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, ui.panel)
    local canBuyColor = data.cur_buy_times < data.max_buy_times and ccc3(255, 255, 255) or ccc3(255, 0, 0)
    ui.canBuy = ed.createNode({
      t = "Label",
      base = {text = canBuy, size = 11},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(ox + 25, 46)
      },
      config = {
        color = canBuyColor,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2),
          scalexy = {y = 1, x = 1}
        }
      }
    }, ui.panel)
  end
  return goods
end

class.createSimpleGoods = createSimpleGoods

local function createCommon(self)
  local goods = {}
  local container = self.listContainer
  local equipInfo = ed.getDataTable("equip")
  local shopData = ed.player:getShopGoods(self.shop)
  if shopData then
    self.numOfNormalGoods = #shopData
  else
    self.numOfNormalGoods = 0
  end
  for k, v in ipairs(shopData or {}) do
    local tag, slot
    local isShowHotTag = config.isShowHotTag(self.shop)
    if isShowHotTag == true then
      slot = v.slot
      tag = v.tag
      v = v.good
    elseif isShowHotTag == false then
      slot = v.slot
      v = v.good
    end
    local info = equipInfo[v._id]
    if info and info.Icon then
      local data = {
        data = {
          index = #goods + 1,
          id = v._id,
          pay = v._type,
          payid = v._price_value,
          price = v._price,
          amount = v._amount,
          cost = v._price * math.max(v._amount, 1),
          slot = slot or k,
          res = info.Icon,
          name = info.Name,
          tag = tag,
          category = info.Category,
          sale = v._discount_type,
          saleValue = v._discount_perct
        },
        addition = {
          name = info.Name
        },
        ui = {}
      }
      if v._type == "item_2048" then
        data.data.payid = 2048
      end
      table.insert(goods, data)
    end
  end
  local block = math.floor(#goods / 6)
  local remain = #goods % 6
  local isHideStar = self:isHideStarShop()
  local isStarGate = self:isStarGateShop()
  
  local function getItemPos(index)
    local idx_x
    local idx_y = 0
    if index <= block * 6 then
      index = index - 1
      local idx_block = math.floor(index / 6)
      local idx_num = index % 6
      if 3 <= idx_num then
        idx_y = 1
        idx_num = idx_num - 3
      end
      idx_x = idx_block * 3 + idx_num + 1
    else
      if index % 2 == 0 then
        idx_y = 1
      end
      idx_x = block * 3 + math.ceil((index - block * 6) / 2)
    end
    local ox = 6 < #goods and 180 or 195
    local oy = 256
    local dx, dy = 205, 145
    if isHideStar then
      dx = dx + 5
      dy = dy + 5
    end
    return ccp(ox + dx * (idx_x - 1), oy - dy * idx_y)
  end
  
  local function getListWidth()
    local ox = 200
    local dx = 205
    local offset_x = 20
    if isHideStar then
      dx = dx + 5
    end
    if #goods % 6 >= 3 then
      return ox + dx * 3 * math.floor((#goods - 1) / 6) + dx * 2 + offset_x
    else
      return dx * #goods / 2 + offset_x
    end
  end
  
  for i = 1, #goods do
    local data = goods[i].data
    local ui = goods[i].ui
    local nameText = 1 < data.amount and data.name .. " x " .. data.amount or data.name
    ui.panel = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).productBgRes
      },
      layout = {
        position = getItemPos(i)
      },
      config = {isCascadeOpacity = true}
    }, container)
    if ed.isComplexText(nameText) then
      ui.name = ed.createNode({
        t = "ComplexLabel",
        base = {text = nameText, size = 20},
        layout = {
          position = ccp(100, 125)
        },
        config = {
          color = ccc3(69, 59, 56)
        }
      }, ui.panel)
    else
      local info = {
        t = "Label",
        base = {text = nameText, size = 20},
        layout = {
          position = ccp(100, 125)
        },
        config = {
          color = ccc3(69, 59, 56)
        }
      }
      if isHideStar then
        info.config.shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      end
      ui.name = ed.createNode(info, ui.panel)
    end
    ui.icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIconWithAmount(data.id, nil, data.amount)
      },
      layout = {
        position = ccp(100, 75)
      }
    }, ui.panel)
    if isHideStar then
      ed.pt(data)
      ui.costBg = ed.createNode({
        t = "Sprite",
        base = {
          res = "UI/alpha/HVGA/shop_star_price_bg.png"
        },
        layout = {
          position = ccp(110, 28)
        }
      }, ui.panel)
    end
    if "soulstone" == data.pay and 0 ~= data.payid then
      ui.coinIcon = ed.createNode({
        t = "CCNode",
        base = {
          node = ed.readequip.createIcon(data.payid, 40)
        },
        layout = {
          position = ccp(42, 30)
        }
      }, ui.panel)
    elseif "item_2048" == data.pay then
      ui.coinIcon = ed.createNode({
        t = "CCNode",
        base = {
          node = ed.readequip.createIcon(2048, 40)
        },
        layout = {
          position = ccp(42, 30)
        }
      }, ui.panel)
    else
      ui.coinIcon = ed.createNode({
        t = "Sprite",
        base = {
          res = config.getCoinRes(data.pay)
        },
        layout = {
          position = ccp(40, 25)
        }
      }, ui.panel)
    end
    ui.costLabel = ed.createNode({
      t = "Label",
      base = {
        text = tostring(data.cost),
        size = 20
      },
      layout = {
        position = ccp(110, 25)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, ui.panel)
    if data.sale then
      self:createSaleIcon(data, ui)
    end
    local tagRes = config.getHotTagRes(data.tag)
    if tagRes then
      ui.tagIcon = ed.createNode({
        t = "Sprite",
        base = {res = tagRes},
        layout = {
          position = ccp(55, 55)
        }
      }, ui.panel)
    end
    ui.noneTag = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).noneTagRes
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        visible = 1 > data.amount
      }
    }, ui.panel)
    local tag
    if ed.isPropEquipable(data.id) then
      tag = ed.createSprite("UI/alpha/HVGA/can_deal_tag.png")
      local size = ui.icon:getContentSize()
      local px = size.width - 8
      tag:setPosition(ccp(px, px))
      ui.icon:addChild(tag)
    end
  end
  if isHideStar then
    self:adjustForHideStarShop(goods)
  end
  if isStarGate then
    self:adjustForStarGateShop(goods)
  end
  self.draglist:initListWidth(getListWidth())
  return goods
end

class.createCommon = createCommon

function class:createSaleIcon(data, ui)
  local saleType = data.sale
  local sale = saleType == "dynamic_discount" and tostring(data.saleValue) or saleType
  local cost = data.cost
  local saleIconConfig = config.scaleIcon
  local res, bgRes
  local pos = ccp(0, 0)
  local discount = 100
  if self.shop == config.toId.diamondShop then
    res = saleIconConfig.diamond[sale] and saleIconConfig.diamond[sale].res or nil
    bgRes = saleIconConfig.diamond[sale] and saleIconConfig.diamond[sale].bgRes or nil
    discount = saleIconConfig.diamond[sale] and saleIconConfig.diamond[sale].discount or 100
    pos = ccp(30, 80)
  else
    res = saleIconConfig.common[sale] and saleIconConfig.common[sale].res or nil
    bgRes = saleIconConfig.common[sale] and saleIconConfig.common[sale].bgRes or nil
    discount = saleIconConfig.common[sale] and saleIconConfig.common[sale].discount or 100
    pos = ccp(75, 50)
  end
  if bgRes ~= nil then
    ui.saleIconBg = ed.createNode({
      t = "Sprite",
      base = {res = bgRes},
      layout = {position = pos}
    }, ui.panel)
  end
  if res ~= nil then
    ui.saleIcon = ed.createNode({
      t = "Sprite",
      base = {res = res},
      layout = {position = pos}
    }, ui.panel)
  end
  local initCost = math.floor(cost * 100 / discount)
  ui.initCostLabel = ed.createNode({
    t = "Label",
    base = {
      text = tostring(initCost),
      size = 20
    },
    layout = {
      position = ccp(80, 25)
    },
    config = {
      shadow = {
        color = ccc3(0, 0, 0),
        offset = ccp(0, 2)
      }
    }
  }, ui.panel)
  ui.initCostLine = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/red_line.png"
    },
    layout = {
      position = ccp(80, 25)
    },
    config = {
      rotation = -5,
      textureRect = CCRectMake(0, 0, 45, 3)
    }
  }, ui.panel)
  local costLabelPos = data.sale and ccp(130, 25) or ccp(110, 25)
  ui.costLabel:setPosition(costLabelPos)
end

function class:showDiscountInfo(ui, isShow)
  if ui.saleIcon then
    ui.saleIcon:setVisible(isShow)
  end
  if ui.saleIconBg then
    ui.saleIconBg:setVisible(isShow)
  end
end

function class:checkShowSoldoutTip()
  if config.willAutoExit(self.shop) then
    local soldoutExplaination = config.getSoldoutExplaination(self.shop)
    local isSoldout = true
    for k, v in pairs(self.goods) do
      if v.data.amount > 0 then
        isSoldout = false
        break
      end
    end
    if isSoldout and soldoutExplaination then
      ed.showToast(soldoutExplaination)
    end
  end
end

function class:getHeroId(id)
  local dataTable = ed.getDataTable("fragment")
  for equipId, row in pairs(dataTable) do
    if row["Fragment ID"] == id then
      return equipId
    end
  end
  return nil
end

function class:heroFullStars(id)
  local category = ed.readequip.value(id, "Category")
  if category == T("\231\129\181\233\173\130\231\159\179") then
    local heroid = self:getHeroId(id)
    local hero = ed.player:getHero(heroid)
    if hero and hero._stars == 5 then
      return true
    end
  end
  return false
end

function class:switchGoodsPosition(goods, a, b)
  goods[a], goods[b] = goods[b], goods[a]
  goods[a].data.index, goods[b].data.index = goods[b].data.index, goods[a].data.index
end

function class:sortCurrentGoods(goods)
  goods = goods or {}
  local b = 1
  local e = #goods
  while true do
    if b >= e then
      break
    end
    local good = goods[b]
    local fullStars = self:heroFullStars(good.data.id)
    if fullStars then
      self:switchGoodsPosition(goods, b, e)
      e = e - 1
    else
      b = b + 1
    end
  end
  return goods
end

function class:adjustForHideStarShop(goods)
  for i = 1, #goods do
    local ui = goods[i].ui
    local name = ui.name:getString()
    name = string.gsub(name, " ", "")
    ui.name:setString(name)
    ui.name:setColor(ccc3(206, 253, 255))
    ui.name:setFontSize(18)
    ui.icon:setPosition(ccp(103, 78))
    local cost = ui.costLabel:getString()
    ui.costLabel:setString("x" .. cost)
  end
end

function class:adjustForStarGateShop(goods)
  for i = 1, #goods do
    local ui = goods[i].ui
    local name = ui.name:getString()
    name = string.gsub(name, " ", "")
    ui.name:setString(name)
    ui.name:setColor(ccc3(224, 212, 255))
    ui.name:setFontSize(18)
    ui.costLabel:setPositionY(ui.costLabel:getPositionY() - 3)
  end
end

local function createStarList(self)
  local goods = {}
  local ox, oy = 90, 35
  local dx, dy = 212, 282
  
  local function getItemPos(index)
    return ccp(ox + dx * (index - 1), oy)
  end
  
  local function getListWidth()
    local len = #goods
    if len <= 3 then
      if len == 1 then
        goods[1].ui.container:setPosition(ccp(ox + dx, oy))
      elseif len == 2 then
        goods[1].ui.container:setPosition(ccp(ox + dx * 0.5, oy))
        goods[2].ui.container:setPosition(ccp(ox + dx * 1.5, oy))
      end
      return 0
    else
      return dx * len + 40
    end
  end
  
  local layer = self.listContainer
  local gd = ed.player:getShopGoods(self.shop)
  for i, v in ipairs(gd) do
    goods[i] = {
      data = {
        pay = "stone",
        box = v._type,
        payid = v._stone_id,
        price = v._stone_amount,
        cost = v._stone_amount,
        amount = v._amount
      },
      addition = {
        name = config.getStarGoodsName(v._type)
      },
      ui = {}
    }
    local ctn = CCSprite:create()
    ctn:setCascadeOpacityEnabled(true)
    local container, ui = ed.editorui(ed.uieditor.itemstarshop, {container = ctn})
    goods[i].ui = ui
    container:setPosition(getItemPos(i))
    layer:addChild(container)
    ui.item_icon_container:setCascadeOpacityEnabled(true)
    ui.stone_container:setCascadeOpacityEnabled(true)
    ui.item_bg:setCascadeOpacityEnabled(true)
    ui.item_icon = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getStarGoodsRes(v._type)
      },
      layout = {
        anchor = ccp(0, 0)
      }
    }, ui.item_icon_container)
    ui.stone_icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIcon(v._stone_id, 46)
      },
      layout = {
        anchor = ccp(0, 0)
      }
    }, ui.stone_container)
    ui.noneTag = ed.createNode({
      t = "Sprite",
      base = {
        res = config.getuiConfig(self.shop).noneTagRes
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {
        visible = v._amount < 1
      }
    }, ui.item_bg, 10)
    local stoneName = ui.stone_name
    ed.setString(stoneName, "x" .. v._stone_amount)
    stoneName:setPosition(ccpAdd(ccp(stoneName:getPosition()), ccp(30, 0)))
    ui.costLabel = stoneName
    ed.setString(ui.item_name, config.getStarGoodsName(v._type))
  end
  self.draglist:initListWidth(getListWidth())
  return goods
end

class.createStarList = createStarList

local function listCreate(self, shop, addition)
  addition = addition or {}
  local from = addition.from
  local cx, cy = self.draglist:getListPos()
  if self.preNumOfSimpleGoods == self.numOfSimpleGoods then
    local element = self.listContainer
    if from == "refresh" then
      local action = CCFadeOut:create(0.5)
      local remove = CCCallFunc:create(function()
        xpcall(function()
          element:removeFromParentAndCleanup(true)
          if self.listContainer then
            self.listContainer:runAction(CCFadeIn:create(0.2))
          end
        end, EDDebug)
      end)
      local sequence = CCSequence:createWithTwoActions(action, remove)
      element:runAction(sequence)
    else
      self.listNeedFade = nil
      if not tolua.isnull(element) then
        element:removeFromParentAndCleanup(true)
      end
    end
  elseif not tolua.isnull(self.draglist.listLayer) then
    self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  end
  if self.simpleListContainer then
    local element = self.simpleListContainer
    self.simpleListContainer = nil
    if not tolua.isnull(element) then
      element:removeFromParentAndCleanup(true)
    end
  end
  if config.isNewUI(self.shop) then
    local commonContainer = CCSprite:create()
    commonContainer:setCascadeOpacityEnabled(true)
    self.draglist.listLayer:addChild(commonContainer)
    self.listContainer = commonContainer
    if self.numOfSimpleGoods > 0 then
      local simpleContainer = CCSprite:create()
      simpleContainer:setCascadeOpacityEnabled(true)
      self.draglist.listLayer:addChild(simpleContainer)
      self.simpleListContainer = simpleContainer
      self.simpleGoods = self:createSimpleGoods()
    end
    self.goods = self:createGoods()
    self.draglist:setListPos(ccp(cx, cy))
    self:refreshCostLabel()
  else
    local container = CCSprite:create()
    container:setCascadeOpacityEnabled(true)
    self.draglist.listLayer:addChild(container)
    self.listContainer = container
    local goodsType = config.getGoodsType(self.shop)
    if goodsType == "coin" or self:isHideStarShop() then
      self.goods = self:createCommon()
    elseif goodsType == "stone" then
      self.goods = self:createStarList()
    end
    self:refreshCostLabel()
    if self.listNeedFade then
      container:setOpacity(0)
    else
      self.listNeedFade = true
    end
    if (self.shop == "starshop" or self:isHideStarShop()) and from ~= "refresh" and not self.enter then
      self.enter = false
      container:setOpacity(0)
      container:runAction(CCFadeIn:create(0.5))
    end
  end
end

class.listCreate = listCreate

local function timeRefresh(self)
  local count = 0
  local tc = 0
  local tcgap = 0
  self.isAutoRefreshing = nil
  local timeType = ed.player:checkShopTimeType(self.shop)
  
  local function time(dt)
    count = count + dt
    if 1 <= count then
      count = count - 1
      local time = ed.player:getShopShowTime(self.shop)
      if not time then
        return
      end
      tc = time + tcgap
      time = math.max(time, 0)
      if timeType == "expire" then
        ed.setString(self.ui.time, ed.gethmsNString(time))
      end
      local state = ed.player:checkShopTimeType(self.shop)
      if state == "refresh" then
        if tc <= 0 then
          if not self.isAutoRefreshing and self.buyLayer and not self.buyLayer:checknull() then
            self.buyLayer:destroy()
          end
          self.isAutoRefreshing = true
          if tc < -2 then
            tcgap = tcgap + 60
            ed.registerNetReply("refresh_shop", self:refreshList({from = "refresh"}), {
              id = self.shop,
              state = 1
            })
          end
        else
          self.isAutoRefreshing = nil
        end
      end
      if tc < 0 and state == "expire" then
        self:showTalk("Expire")
        
        local function handler()
          ed.popScene()
        end
        
        local text = config.getLevelExplaination(self.shop) or T("\231\165\158\231\167\152\229\149\134\228\186\186\229\183\178\231\187\143\233\163\152\231\132\182\232\128\140\229\142\187\239\188\140\228\184\139\230\172\161\228\185\176\228\184\156\232\165\191\229\138\168\228\189\156\232\166\129\229\191\171\229\147\166\239\188\129")
        ed.showAlertDialog({text = text, handler = handler})
        self:removeUpdateHandler("refreshTime")
      end
    end
  end
  
  return time
end

class.timeRefresh = timeRefresh

local function enterRefresh(self)
  ed.registerNetReply("refresh_shop", self:refreshList(), {
    id = self.shop,
    type = 1,
    firstRefresh = true
  })
  local msg = ed.upmsg.shop_refresh()
  msg._type = 1
  msg._shop_id = self.shop
  ed.send(msg, "shop_refresh")
end

class.enterRefresh = enterRefresh

local function refreshList(self, addition)
  local function handler(canswitch, firstRefresh)
    if config.isNewUI(self.shop) then
      self.simpleInfo = ed.player:getSimpleShopGoods(self.shop) or {}
    else
      self.simpleInfo = {}
    end
    self.numOfSimpleGoods = #self.simpleInfo
    if tolua.isnull(self.mainLayer) then
      return
    end
    self.firstRefresh = firstRefresh
    local switch = canswitch and canswitch == 0
    if self.shop == "starshop" or self.shop == config.shopName2IdTbl.starGate or self.shop == config.shopName2IdTbl.hideStar or self.shop == config.shopName2IdTbl.hideSpecial then
      switch = true
    end
    self.ui.left_arrow:setVisible(not switch)
    self.ui.right_arrow:setVisible(not switch)
    addition = addition or {}
    local from = addition.from
    if not self then
      return
    end
    self:listCreate(self.shop, addition)
    self.preNumOfSimpleGoods = self.numOfSimpleGoods
    local timeType = ed.player:checkShopTimeType(self.shop)
    if timeType == "refresh" then
      local nextTime = ed.player:getShopNextAutoRefreshPointDesc(self.shop)
      ed.setString(self.ui.time, nextTime)
    elseif timeType == "expire" then
      local time = ed.player:getShopShowTime(self.shop)
      time = math.max(time, 0)
      ed.setString(self.ui.time, ed.gethmsNString(time))
    end
    self:registerUpdateHandler("refreshTime", self:timeRefresh())
    if not ed.isElementInTable(self.shop, {
      "starshop",
      config.toId.diamondShop
    }) then
      self:showTutorialHandler()
    end
  end
  
  return handler
end

class.refreshList = refreshList

local function createNewListLayer(self)
  local info = {
    cliprect = CCRectMake(65, 25, 668, 310),
    container = self.container,
    noshade = true,
    doClickIn = self:doClickInProduct(),
    cancelClickIn = self:cancelClickInProduct(),
    doPressIn = self:doPressInProduct(),
    cancelPressIn = self:cancelPressInProduct()
  }
  self.draglist = ed.draglist.create(info)
end

class.createNewListLayer = createNewListLayer

local function createListLayer(self)
  local left, right
  if self.shop == 14 then
    left = "UI/alpha/HVGA/list_shade_star_shop_left.png"
    right = "UI/alpha/HVGA/list_shade_star_shop_left.png"
  end
  local info = {
    cliprect = CCRectMake(65, 35, 670, 325),
    container = self.container,
    leftShade = left,
    rightShade = right,
    bar = {
      bglen = 630,
      bgpos = ccp(400, 33),
      direction = "horizontal"
    },
    doClickIn = self:doClickInProduct(),
    cancelClickIn = self:cancelClickInProduct(),
    doPressIn = self:doPressInProduct(),
    cancelPressIn = self:cancelPressInProduct()
  }
  self.draglist = ed.draglist.create(info)
end

class.createListLayer = createListLayer

local function getTimeTitle(self)
  local state = ed.player:checkShopTimeType(self.shop)
  local timeTitle = T("\228\184\139\230\172\161\232\135\170\229\138\168\229\136\183\230\150\176\230\151\182\233\151\180\239\188\154")
  local timeTitleSuffix = ""
  if state == "refresh" then
    timeTitle = T("\228\184\139\230\172\161\232\135\170\229\138\168\229\136\183\230\150\176\230\151\182\233\151\180\239\188\154")
    timeTitleSuffix = ""
  elseif state == "expire" then
    timeTitle = T("\229\149\134\228\186\186\229\176\134\228\186\142")
    timeTitleSuffix = T("\229\144\142\231\166\187\229\188\128")
  end
  return timeTitle, timeTitleSuffix
end

class.getTimeTitle = getTimeTitle
local clickStarShopHeadCounter = 0
local defaultHideStarShopClickTime = 0

local function create(id, param)
  id = id or 1
  local self = base.create("shop", {
    shopName = config.getShopName(id)
  })
  setmetatable(self, class.mt)
  self.rootshop = id
  self.shop = id
  if param then
    self.enter = param.enter
  end
  local mainLayer = self.mainLayer
  local _id = "starshop" == id and config.toId.star or id
  local cnt = ed.getDataTable("Shop")[_id][1]["Hidden Shop Click Time"] or 0
  defaultHideStarShopClickTime = cnt or 10
  clickStarShopHeadCounter = 0
  self.preNumOfSimpleGoods = -1
  self.numOfSimpleGoods = 0
  self.numOfNormalGoods = 0
  self:initUI()
  self:registerOnEnterHandler("enterShop", self:onEnterShop())
  return self
end

class.create = create

local function switchShopReplyHandler(self)
  local function handler(result)
    if result then
      self.draglist:resetScrollbar()
      
      ed.popScene()
      print("switch to" .. result._shop_id)
      ed.pushScene(ed.ui.shop.create(result._shop_id))
    end
  end
  
  return handler
end

class.switchShopReplyHandler = switchShopReplyHandler

local function sendSwitchShop(self, switch_type)
  ed.netreply.switchShop = self:switchShopReplyHandler()
  local msg = ed.upmsg.shop_switch()
  msg._type = switch_type
  msg._cur_shop_id = self.shop
  ed.send(msg, "shop_switch")
end

class.sendSwitchShop = sendSwitchShop

local function doStarShopPromptDisappearAction(self)
  if not tolua.isnull(self.starShopPrompt) then
    self.starShopPrompt:setAction("Dissapear")
  end
  local count = 0
  self:registerUpdateHandler("starShopPromptLeave", function(dt)
    count = count + dt
    if 0.2 < count and not tolua.isnull(self.starShopPrompt) then
      self.starShopPrompt:setVisible(false)
      self:removeUpdateHandler("starShopPromptLeave")
    end
  end)
end

class.doStarShopPromptDisappearAction = doStarShopPromptDisappearAction

function class:checkStarShopCanOpen()
  local heroes = ed.player.heroes
  local fragmentTbl = ed.getDataTable("fragment")
  for k, v in pairs(heroes) do
    if v.data._stars == 5 then
      local fragInfo = fragmentTbl[k]
      if fragInfo then
        local fragId = fragInfo["Fragment ID"]
        local fragCount = ed.player.equip_qunty[fragId] or 0
        if 0 < fragCount then
          return true
        end
      end
    end
  end
  return false
end

local function starShopHeadClick(self)
  if "starshop" == self.shop and self.firstClick then
    self.firstClick = false
    self:doStarShopPromptDisappearAction()
  elseif "starshop" == self.shop then
    self:showTalk("Touch")
    return
  end
  clickStarShopHeadCounter = clickStarShopHeadCounter + 1
  if defaultHideStarShopClickTime >= clickStarShopHeadCounter then
    clickStarShopHeadCounter = 0
    
    local function doSwitch()
      local fo = CCFadeOut:create(0.5)
      local cf = CCCallFunc:create(function()
        self:doClickBack()
        if self.shop == "starshop" then
          ed.pushScene(ed.ui.shop.create(config.shopName2IdTbl.hideStar))
        elseif self:isHideStarShop() then
          local msg = ed.upmsg.star_shop_refresh()
          ed.send(msg, "star_shop_refresh")
          ListenEvent("StarShopRefresh", function(starShopData)
            ed.player._sshop = starShopData
            ed.pushScene(ed.ui.shop.create("starshop"))
            CloseEvent("StarShopRefresh")
          end)
        end
      end)
      local se = CCSequence:createWithTwoActions(fo, cf)
      self.listContainer:runAction(se)
    end
    
    local info = {
      starshopStyle = true,
      spriteLabel = "",
      sprite = CCSprite:create(),
      leftRes = "UI/alpha/HVGA/shop_star_button_1.png",
      leftPressRes = "UI/alpha/HVGA/shop_star_button_2.png",
      rightRes = "UI/alpha/HVGA/shop_star_button_1.png",
      rightPressRes = "UI/alpha/HVGA/shop_star_button_2.png",
      rightHandler = doSwitch
    }
    if self:isHideStarShop() then
      if not self:checkStarShopCanOpen() then
        ed.showToast(T("\230\139\165\230\156\137\229\164\154\228\189\153\233\173\130\231\159\179\232\167\163\233\148\129\230\152\159\233\153\133\229\174\157\231\174\177\232\180\173\228\185\176"))
        return
      end
      info.spriteLabel = T("\229\137\141\229\190\128\232\180\173\228\185\176\230\152\159\233\153\133\229\174\157\231\174\177\239\188\159")
    elseif self.shop == "starshop" then
      info.spriteLabel = T("\232\191\148\229\155\158\230\152\159\233\153\133\230\151\133\232\161\140\229\149\134\229\186\151\239\188\159")
    end
    ed.showConfirmDialog(info)
  else
    self:showTalk("Touch")
  end
end

class.starShopHeadClick = starShopHeadClick

local function specialShopHeadClick(self)
  if self.shop ~= config.shopName2IdTbl.soSpecial and not self:isHideSpecialShop() then
    return
  end
  if self.isSpecialShopVisited then
    return
  end
  
  local function doSwitch()
    local fo = CCFadeOut:create(0.5)
    local cf = CCCallFunc:create(function()
      self:doClickBack()
      if self.shop == config.shopName2IdTbl.soSpecial then
        ed.replaceScene(ed.ui.shop.create(config.shopName2IdTbl.hideSpecial))
      elseif self:isHideSpecialShop() then
        ed.replaceScene(ed.ui.shop.create(config.shopName2IdTbl.soSpecial))
        self.specialShopFirstClick = false
      end
    end)
    local se = CCSequence:createWithTwoActions(fo, cf)
    self.listContainer:runAction(se)
    self.isSpecialShopVisited = true
    if self.specialShopTalkBg then
      self.specialShopTalkBg:removeFromParentAndCleanup(true)
      self.specialShopTalkBg = nil
    end
    ed.storage.setValue("special_shop_first_tip", 1)
  end
  
  local function doCancel()
    self.isSpecialShopVisited = true
    if self.specialShopTalkBg then
      self.specialShopTalkBg:removeFromParentAndCleanup(true)
      self.specialShopTalkBg = nil
    end
    self:showTalk("Touched", nil, "......")
  end
  
  if config.shopName2IdTbl.soSpecial == self.shop then
    local record = ed.storage.getInt("special_shop_first_tip")
    if record ~= 1 then
      local win = ShopSpecialTip.create(doSwitch, doCancel)
      win:popWindow()
    elseif not self.isSpecialShopVisited then
      local info = {
        spriteLabel = T("\230\136\145\232\191\153\233\135\140\230\156\137\228\184\128\228\186\155\231\165\158\231\167\152\231\154\132\232\180\167\231\137\169\232\166\129\229\135\186\229\148\174\239\188\140\232\166\129\228\184\141\232\166\129\231\156\139\228\184\128\231\156\139\239\188\159"),
        sprite = CCSprite:create(),
        rightHandler = doSwitch,
        leftHandler = doCancel
      }
      ed.showConfirmDialog(info)
    end
  else
    local info = {
      spriteLabel = T("  \229\134\141\231\156\139\231\156\139\229\133\182\228\187\150\231\154\132\232\180\167\231\137\169\239\188\159"),
      sprite = CCSprite:create(),
      rightHandler = doSwitch
    }
    ed.showConfirmDialog(info)
  end
end

class.specialShopHeadClick = specialShopHeadClick

local function getRuleConfig(self)
  local uiConfig = {
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(67, 67)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
        res = "UI/alpha/HVGA/shop_refresh_button.png",
        name = "rule",
        z = 10
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(698, 375)
      }
    },
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = false,
        scaleSize = CCSizeMake(67, 67)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
        res = "UI/alpha/HVGA/shop_refresh_button_down.png",
        name = "rule_down",
        parent = "rule",
        z = 0
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        mediate = true
      }
    },
    {
      t = "Label",
      base = {
        name = "rule_label_name",
        text = T("\232\167\132\229\136\153"),
        size = 20,
        parent = "rule",
        z = 5
      },
      layout = {
        position = ccp(34, 35)
      },
      config = {
        color = ccc3(234, 225, 205),
        visible = true
      }
    },
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(67, 67)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
        res = "UI/alpha/HVGA/shop_refresh_button.png",
        name = "switch",
        z = 10
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(630, 375)
      }
    },
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = false,
        scaleSize = CCSizeMake(67, 67)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
        res = "UI/alpha/HVGA/shop_refresh_button_down.png",
        name = "switch_down",
        parent = "switch",
        z = 0
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        mediate = true
      }
    },
    {
      t = "Sprite",
      base = {
        name = "switch_label",
        res = "UI/alpha/HVGA/shop_switch_button.png",
        parent = "switch",
        z = 3
      },
      layout = {mediate = true}
    },
    {
      t = "Sprite",
      base = {
        name = "switch_label_down",
        res = "UI/alpha/HVGA/shop_switch_button_press.png",
        parent = "switch",
        z = 3
      },
      layout = {mediate = true},
      config = {visible = false}
    }
  }
  return uiConfig
end

class.getRuleConfig = getRuleConfig

local function initUI(self)
  if self.container then
    self.container:removeFromParentAndCleanup(true)
  end
  local container = CCLayer:create()
  self.container = container
  self.infoLayer:addChild(container, 20)
  self.ui = {}
  local ui = self.ui
  local timeTitle, timeTitleSuffix = self:getTimeTitle()
  local ui_config = config.getuiConfig(self.shop)
  local readNode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = ui_config.frameRes
      },
      layout = {
        position = ui_config.framePos
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title",
        res = ui_config.titleRes,
        z = 5
      },
      layout = {
        position = ui_config.titlePos
      }
    },
    {
      t = "Sprite",
      base = {
        name = "left_arrow",
        res = "UI/alpha/1080P/common/herodetail_arrow_left.png",
        z = 16
      },
      layout = {
        position = ccp(50, 180)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "right_arrow",
        res = "UI/alpha/1080P/common/herodetail_arrow_right.png",
        z = 16
      },
      layout = {
        position = ccp(750, 180)
      },
      config = {visible = false}
    }
  }
  if ui_config.headBgRes then
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "headbg",
        res = ui_config.headBgRes,
        z = 19
      },
      layout = {
        position = ccp(148, 382)
      }
    })
  end
  if ui_config.headRes then
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "head",
        res = ui_config.headRes,
        z = 20
      },
      layout = {
        position = ui_config.headPos
      }
    })
  end
  if ui_config.titleBgRes then
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = ui_config.titleBgRes
      },
      layout = {
        position = ccp(400, 380)
      }
    })
  end
  if ui_config.exchangeDeadlineRes then
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "exchange_deadline",
        res = ui_config.exchangeDeadlineRes
      },
      layout = {
        position = ccp(300, 420)
      }
    })
  end
  if config.isNewUI(self.shop) then
    local temp_info = self:getRuleConfig()
    for i = 1, #temp_info do
      table.insert(ui_info, temp_info[i])
    end
  else
    local time_info = {
      t = "HorizontalNode",
      base = {
        name = "time_title_node",
        nodeArray = ui
      },
      layout = {
        position = ccp(400, 340)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "time_title",
            text = timeTitle,
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "time",
            text = "00:00:00",
            size = 16,
            offset = 10
          },
          layout = {},
          config = {
            color = ccc3(219, 199, 168)
          }
        },
        {
          t = "Label",
          base = {
            name = "time_suffix",
            text = timeTitleSuffix,
            size = 18,
            offset = 10
          },
          layout = {},
          config = {
            color = ccc3(241, 193, 113)
          }
        }
      }
    }
    table.insert(ui_info, time_info)
    local temp_info = {}
    if config.hasRefreshButton(self.shop) then
      if self:isStarGateShop() then
        temp_info = {
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = true,
              scaleSize = CCSizeMake(120, 50)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(23.44, 7.81, 78.13, 31.25),
              res = "UI/alpha/HVGA/stargate/stargate_button.png",
              name = "refresh",
              z = 10
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(670, 393)
            }
          },
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = false,
              scaleSize = CCSizeMake(120, 50)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(23.44, 7.81, 78.13, 31.25),
              res = "UI/alpha/HVGA/stargate/stargate_button.png",
              name = "refresh_down",
              parent = "refresh",
              z = 0
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              mediate = true
            }
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_label",
              res = "UI/alpha/HVGA/stargate/stargate_refresh_button.png",
              parent = "refresh",
              z = 3
            },
            layout = {
              position = ccp(35, 25)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_label_down",
              res = "UI/alpha/HVGA/stargate/stargate_refresh_button.png",
              parent = "refresh",
              z = 3
            },
            layout = {
              position = ccp(35, 25)
            },
            config = {visible = false}
          },
          {
            t = "Label",
            base = {
              name = "refresh_label_name",
              text = T("\229\136\183\230\150\176"),
              size = 18,
              parent = "refresh",
              z = 5
            },
            layout = {
              position = ccp(70, 25)
            },
            config = {
              color = ccc3(255, 255, 255),
              visible = true
            }
          },
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = true,
              scaleSize = CCSizeMake(67, 67)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
              res = "UI/alpha/HVGA/shop_refresh_button.png",
              name = "switch",
              z = 10
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(630, 375)
            }
          },
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = false,
              scaleSize = CCSizeMake(67, 67)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
              res = "UI/alpha/HVGA/shop_refresh_button_down.png",
              name = "switch_down",
              parent = "switch",
              z = 0
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              mediate = true
            }
          },
          {
            t = "Sprite",
            base = {
              name = "switch_label",
              res = "UI/alpha/HVGA/shop_switch_button.png",
              parent = "switch",
              z = 3
            },
            layout = {mediate = true}
          },
          {
            t = "Sprite",
            base = {
              name = "switch_label_down",
              res = "UI/alpha/HVGA/shop_switch_button_press.png",
              parent = "switch",
              z = 3
            },
            layout = {mediate = true},
            config = {visible = false}
          }
        }
      elseif not self:isHideStarShop() then
        temp_info = {
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = true,
              scaleSize = CCSizeMake(67, 67)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
              res = "UI/alpha/HVGA/shop_refresh_button.png",
              name = "refresh",
              z = 10
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(698, 375)
            }
          },
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = false,
              scaleSize = CCSizeMake(67, 67)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
              res = "UI/alpha/HVGA/shop_refresh_button_down.png",
              name = "refresh_down",
              parent = "refresh",
              z = 0
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              mediate = true
            }
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_label",
              res = "UI/alpha/HVGA/shop_refresh.png",
              parent = "refresh",
              z = 3
            },
            layout = {mediate = true}
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_label_down",
              res = "UI/alpha/HVGA/shop_refresh_press.png",
              parent = "refresh",
              z = 3
            },
            layout = {mediate = true},
            config = {visible = false}
          },
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = true,
              scaleSize = CCSizeMake(67, 67)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
              res = "UI/alpha/HVGA/shop_refresh_button.png",
              name = "switch",
              z = 10
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(630, 375)
            }
          },
          {
            config = {
              rotation = 0,
              flip = "",
              opacity = 255,
              visible = false,
              scaleSize = CCSizeMake(67, 67)
            },
            t = "Scale9Sprite",
            base = {
              capInsets = CCRectMake(21.09, 22.66, 47.66, 22.66),
              res = "UI/alpha/HVGA/shop_refresh_button_down.png",
              name = "switch_down",
              parent = "switch",
              z = 0
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              mediate = true
            }
          },
          {
            t = "Sprite",
            base = {
              name = "switch_label",
              res = "UI/alpha/HVGA/shop_switch_button.png",
              parent = "switch",
              z = 3
            },
            layout = {mediate = true}
          },
          {
            t = "Sprite",
            base = {
              name = "switch_label_down",
              res = "UI/alpha/HVGA/shop_switch_button_press.png",
              parent = "switch",
              z = 3
            },
            layout = {mediate = true},
            config = {visible = false}
          }
        }
      else
        temp_info = {
          {
            t = "Sprite",
            base = {
              name = "refresh",
              res = "UI/alpha/HVGA/shop_star_button_1.png"
            },
            layout = {
              position = ccp(655, 375)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_down",
              res = "UI/alpha/HVGA/shop_star_button_2.png",
              parent = "refresh"
            },
            layout = {mediate = true},
            config = {visible = false}
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_label",
              res = "UI/alpha/HVGA/shop_refresh_label_star_1.png",
              parent = "refresh",
              z = 3
            },
            layout = {mediate = true}
          },
          {
            t = "Sprite",
            base = {
              name = "refresh_label_down",
              res = "UI/alpha/HVGA/shop_refresh_label_star_2.png",
              parent = "refresh",
              z = 3
            },
            layout = {mediate = true},
            config = {visible = false}
          },
          {
            t = "Sprite",
            base = {
              name = "wish",
              res = "UI/alpha/HVGA/shop_star_button_1.png",
              z = 5
            },
            layout = {
              position = ccp(250, 380)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "wish_down",
              res = "UI/alpha/HVGA/shop_star_button_2.png",
              parent = "wish"
            },
            layout = {mediate = true},
            config = {visible = false}
          },
          {
            t = "Sprite",
            base = {
              name = "wish_label",
              res = "UI/alpha/HVGA/shop/shop_star_wishBtn.png",
              parent = "wish",
              z = 3
            },
            layout = {mediate = true}
          },
          {
            t = "Sprite",
            base = {
              name = "wish_label_down",
              res = "UI/alpha/HVGA/shop/shop_star_wishBtn_pressed.png",
              parent = "wish",
              z = 3
            },
            layout = {mediate = true},
            config = {visible = false}
          }
        }
      end
    end
    if config.hasRuleButton(self.shop) then
      temp_info = self:getRuleConfig()
    end
    for i = 1, #temp_info do
      table.insert(ui_info, temp_info[i])
    end
  end
  readNode:addNode(ui_info)
  for k, v in ipairs({
    ui.left_arrow,
    ui.right_arrow
  }) do
    local fo = CCFadeOut:create(1)
    local fi = CCFadeIn:create(1)
    local s = ed.readaction.create({
      t = "seq",
      fo,
      fi
    })
    v:runAction(CCRepeatForever:create(s))
  end
  if config.isNewUI(self.shop) then
    self:createNewListLayer()
  else
    self:createListLayer()
  end
  if "starshop" == self.shop then
    self.firstClick = true
  elseif self.shop == config.shopName2IdTbl.soSpecial then
    self:createSpecialShopPrompt()
  elseif self:isHideSpecialShop() then
    local record = ed.storage.getInt("hide_special_shop_first_tip")
    if record ~= 1 then
      self:showTalk("Touched", nil, T("\228\189\160\229\176\177\230\152\175\228\188\160\232\175\180\228\184\173\230\157\145\229\167\145\231\154\132\231\148\183\228\186\186!"))
      ed.storage.setValue("hide_special_shop_first_tip", 1)
    else
      self:showTalk("Touched", nil, T("\232\135\170\229\183\177\228\186\186\233\154\143\228\190\191\230\140\145!"))
    end
  else
    self:showTalk("Welcome")
  end
  if self.shop == 1 then
    ed.tutorial.tell("aboutShop", self.mainLayer)
    ed.endTeach("aboutShop")
  else
    ed.tutorial.tell("aboutSpecialShop", self.mainLayer)
    ed.endTeach("aboutSpecialShop")
  end
  local isStarGate = self:isStarGateShop()
  if isStarGate then
    self.sb_ui.back:removeFromParentAndCleanup(true)
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "back",
          res = "UI/alpha/HVGA/stargate/backbtn.png"
        },
        layout = {
          position = ccp(70, 435)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "back_press",
          res = "UI/alpha/HVGA/stargate/backbtn-disabled.png",
          parent = "back"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      }
    }
    local readNode = ed.readnode.create(self.frameworkLayer, self.sb_ui)
    readNode:addNode(ui_info)
    self:btRegisterButtonClick({
      button = self.sb_ui.back,
      press = self.sb_ui.back_press,
      key = "back_button",
      clickHandler = function()
        self:doClickBack()
        if self.what == "StageSelectPanel" then
          ed.stopMusic()
        end
      end,
      force = true,
      priority = -16
    })
    ed.setTexture(self.bg, "UI/alpha/HVGA/stargate/stargate_shop_bg.png")
    self.ui.switch:setVisible(false)
    self.ui.time_title:setColor(ccc3(0, 255, 255))
    self.ui.time:setColor(ccc3(0, 255, 255))
    self.ui.time_suffix:setColor(ccc3(0, 255, 255))
  end
  if self.ui.refresh then
    self:btRegisterButtonClick({
      button = self.ui.refresh,
      press = {
        self.ui.refresh_down,
        self.ui.refresh_label_down
      },
      key = "refresh_button",
      force = true,
      clickHandler = function()
        self:doClickRefresh()
      end
    })
  end
  if self:isHideStarShop() then
    self.ui.refresh:setScale(0.9)
    self.ui.refresh:setPositionX(self.ui.refresh:getPositionX() + 20)
    self.ui.wish:setScale(0.9)
    self:btRegisterButtonClick({
      button = self.ui.wish,
      press = {
        self.ui.wish_down,
        self.ui.wish_label_down
      },
      key = "wish_button",
      force = true,
      clickHandler = function()
        self:requestWishData()
      end
    })
  end
  if self.ui.switch then
    self:btRegisterButtonClick({
      button = self.ui.switch,
      press = {
        self.ui.switch_down,
        self.ui.switch_label_down
      },
      key = "switch_button",
      force = true,
      clickHandler = function()
        self:doClickSwitch()
      end
    })
  end
  if self.ui.rule then
    self:btRegisterButtonClick({
      button = self.ui.rule,
      press = self.ui.rule_down,
      key = "rule_button",
      force = true,
      clickHandler = function()
        self:doClickRule()
      end
    })
  end
  if self.ui.exchange_deadline then
    print("deadline exchange")
    self:btRegisterButtonClick({
      button = self.ui.exchange_deadline,
      key = "exchange_deadline_button",
      force = true,
      clickHandler = function()
        self:doClickDeadlineExchange()
      end
    })
  end
  self:btRegisterButtonClick({
    button = self.ui.head,
    key = "head_button",
    force = true,
    clickHandler = function()
      self:showTalk("Touch")
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.left_arrow,
    key = "left_arrow",
    force = true,
    clickHandler = function()
      self:sendSwitchShop(2)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.right_arrow,
    key = "right_arrow",
    force = true,
    clickHandler = function()
      self:sendSwitchShop(1)
    end
  })
  if self.shop == "starshop" or self:isHideStarShop() then
    self:btRegisterRectClick({
      rect = CCRectMake(95, 330, 110, 100),
      key = "head_rect",
      force = true,
      clickInterval = 0.3,
      clickHandler = function()
        self:starShopHeadClick()
      end
    })
  end
  self:btRegisterRectClick({
    rect = CCRectMake(95, 330, 110, 100),
    key = "head_rect1",
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      self:specialShopHeadClick()
    end
  })
end

class.initUI = initUI

local function initCallBack(self)
end

class.initCallBack = initCallBack
local starshopfca_cofig = {
  res = "eff_UI_starshop_hint",
  pos = ccp(205, 363.3333333333333)
}

local function createStarShopPrompt(self)
  local cfg = starshopfca_cofig
  local node = ed.createFcaNode(cfg.res)
  node:setPosition(cfg.pos)
  self:addFca(node)
  node:setStartAction("Start")
  node:setLoopAction("Loop")
  self.container:addChild(node)
  self.starShopPrompt = node
end

class.createStarShopPrompt = createStarShopPrompt

local function createSpecialShopPrompt(self)
  local record = ed.storage.getInt("special_shop_first_tip")
  local str = T("\230\154\151\229\143\183:\229\164\169\231\142\139\231\155\150\229\156\176\232\153\142\239\188\129")
  if record == 1 then
    str = "   !   "
  end
  local bg = ed.createNode({
    t = "Sprite",
    config = {isCascadeOpacity = true},
    layout = {
      position = ccp(190, 360)
    }
  }, self.container, 60)
  self.specialShopTalkBg = bg
  local frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = config.getuiConfig(self.shop).talkBgRes,
      capInsets = CCRectMake(30, 15, 110, 26)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, bg)
  local talk = ed.createNode({
    t = "Label",
    base = {text = str, size = 20},
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, frame:getContentSize().height / 2)
    }
  }, frame)
  local size = talk:getContentSize()
  frame:setContentSize(CCSizeMake(size.width + 30, 56))
  self:btRegisterButtonClick({
    button = frame,
    key = "special_shop_prompt",
    force = true,
    clickHandler = function()
      self:specialShopHeadClick()
    end,
    force = true
  })
  local delay = CCDelayTime:create(1)
  local scale1 = CCScaleTo:create(0.5, 0.9)
  local scale2 = CCScaleTo:create(0.5, 1)
  local action = CCRepeatForever:create(ed.readaction.create({
    t = "seq",
    delay,
    scale1,
    scale2
  }))
  bg:runAction(action)
end

class.createSpecialShopPrompt = createSpecialShopPrompt

local function openShopReplyHandler(self)
  local function handler(result)
    if result then
      local handler = self:refreshList()
      
      handler()
    else
      local info = {
        text = T("\229\149\134\229\186\151\229\176\154\230\156\170\229\188\128\229\144\175"),
        handler = function()
          ed.popScene()
        end
      }
      self.showAlertDialog(info)
    end
  end
  
  return handler
end

class.openShopReplyHandler = openShopReplyHandler

local function checkOpenShop(self)
end

class.checkOpenShop = checkOpenShop

local function onEnterShop(self)
  local function handler()
    self:checkOpenShop()
    
    self:checkShowSoldoutTip()
    if config.needEnterRefresh(self.shop) then
      self:enterRefresh()
    end
    if config.needFastSell(self.shop) then
      ed.ui.fastsell.pop({
        callback = self:refreshCostHandler()
      }, 200)
    end
  end
  
  return handler
end

class.onEnterShop = onEnterShop

local function doClickBack(self)
  FireEvent("shopNotifyData")
  if self:isHideStarShop() or "starshop" == self.shop then
  else
    lsr:report("clickBack")
  end
  for k, v in pairs(ed.ShopMgr.simple_shop_notify or {}) do
    if v[".data"]._shop_id == self.shop then
      v[".data"].isVisible = false
    end
  end
  if self.rootshop == self.shop then
    ed.popScene()
  else
    local scene = ed:getCurrentScene()
    while scene.identity ~= "main" do
      if scene.identity == "guildWar" then
        scene:onClickExit()
      else
        ed.popScene()
      end
      scene = ed:getCurrentScene()
    end
  end
end

class.doClickBack = doClickBack

function class:isHideStarShop()
  return self.shop == config.shopName2IdTbl.hideStar
end

function class:isStarGateShop()
  return self.shop == config.shopName2IdTbl.starGate
end

function class:isHideSpecialShop()
  return self.shop == config.shopName2IdTbl.hideSpecial
end

function class:isPvpShop()
  return self.shop == config.shopName2IdTbl.pvp
end

function class:isDreamlandShop()
  return self.shop == config.shopName2IdTbl.dreamland
end

function class:requestWishData()
  function ed.netreply.requestWishHandler(data)
    if not data._hero_ids or #data._hero_ids < 1 then
      ed.showToast("\230\139\165\230\156\137\231\154\132\232\139\177\233\155\132\229\183\178\229\133\168\233\131\1685\230\152\159\239\188\140\230\151\160\230\179\149\229\134\141\232\174\184\230\132\191")
      
      return
    end
    ed.ui.shopWish.create(data)
  end
  
  local msg = ed.upmsg.hero_wish()
  msg._open_panel = {}
  ed.send(msg, "hero_wish")
end

function class:getStarShopRedFlag()
  return self.starShopRedFlag
end

function class:isNeedStones()
  local heroes = ed.player.heroes
  local unitTbl = ed.getDataTable("Unit")
  for k, v in pairs(heroes) do
    if v.data._stars < unitTbl[k]["Max Stars"] then
      return true
    end
  end
  return false
end

function class:setStarShopRedFlag(flag)
  self.starShopRedFlag = flag
  if not self:isNeedStones() then
    self.starShopRedFlag = false
  end
  FireEvent("StarShopRedFlagChanged")
end

function class:initPvpUpgradeNotice()
  local bg = ed.createSprite("UI/alpha/HVGA/pvp/upgrade_notice.png")
  bg:setPosition(ccp(268, 415))
  self.container:addChild(bg, 999)
  local btn = ed.createSprite("UI/alpha/HVGA/pvp/upgrade_notice_button.png")
  btn:setPosition(ccp(95, 72))
  bg:addChild(btn)
  self:btRegisterButtonClick({
    button = btn,
    key = "PvpUpgradeNoticeButton",
    clickHandler = function()
      self:doClickPvpUpgradeNoticeButton()
    end,
    force = true,
    priority = -20,
    pressScale = 0.9
  })
end

function class:doClickPvpUpgradeNoticeButton()
  ed.ui.PvpUpgradeNoticeWin.create():baseRules()
end

local PvpUpgradeNoticeWin = {}
PvpUpgradeNoticeWin.__index = PvpUpgradeNoticeWin
ed.ui.PvpUpgradeNoticeWin = PvpUpgradeNoticeWin

function PvpUpgradeNoticeWin.create()
  local self = {}
  setmetatable(self, PvpUpgradeNoticeWin)
  self:closeRuleInfo()
  return self
end

function PvpUpgradeNoticeWin:baseRules()
  self:initListView(T("\230\162\166\229\162\131\229\176\143\229\186\151\232\176\131\230\149\180\233\128\154\231\159\165"))
  self:addBody(" ")
  self:addBody(T("\239\188\1361\239\188\137\230\162\166\229\162\131\229\176\143\229\186\151\229\176\134\228\186\142\228\186\148\230\156\136\228\184\139\230\151\172\231\137\136\230\156\172\230\155\180\230\150\176\230\151\182\232\191\155\232\161\140\232\176\131\230\149\180\239\188\140\229\177\138\230\151\182\229\176\134\228\184\138\230\158\182\230\150\176\232\180\167\231\137\169\239\188\140\229\185\182\229\176\134\230\162\166\229\162\131\229\184\129\231\154\132\230\140\129\230\156\137\228\184\138\233\153\144\232\176\131\230\149\180\228\184\18610\228\184\135\227\128\130"))
  self:addBody(T("\239\188\1362\239\188\137\228\184\186\229\184\174\229\138\169\233\152\159\233\149\191\229\164\167\229\164\167\229\133\145\230\141\162\232\182\133\233\162\157\233\131\168\229\136\134\239\188\140\230\162\166\229\162\131\229\176\143\229\186\151\230\156\172\230\172\161\230\155\180\230\150\176\229\144\142\233\153\144\230\151\182\228\184\138\230\158\182\229\149\134\229\186\151\231\155\178\231\155\146\239\188\140\229\188\128\229\144\175\229\144\142\229\143\175\233\154\143\230\156\186\232\142\183\229\190\151\228\184\128\228\187\189\231\164\188\231\137\169\227\128\130"))
  self:addBody(T("\239\188\1363\239\188\137\228\186\148\230\156\136\228\184\139\230\151\172\231\137\136\230\156\172\230\155\180\230\150\176\230\151\182\229\149\134\229\186\151\231\155\178\231\155\146\229\176\134\228\187\142\230\162\166\229\162\131\229\176\143\229\186\151\228\184\139\230\158\182\239\188\140\232\175\183\229\156\1685\230\156\13631\230\151\16523:59\229\136\134\229\137\141\228\189\191\231\148\168\231\155\178\231\155\146\227\128\130"))
  self:show()
end

function PvpUpgradeNoticeWin:DeadlineRules()
  self:initListView(T("\229\133\172\228\188\154\229\149\134\229\186\151\229\141\179\229\176\134\229\129\156\232\191\144\233\128\154\231\159\165"))
  self:addBody(" ")
  self:addBody(T("\239\188\1361\239\188\137\229\133\172\228\188\154\229\149\134\229\186\151\229\176\134\228\186\142\229\133\173\230\156\136\228\184\139\230\151\172\231\137\136\230\156\172\230\155\180\230\150\176\230\151\182\229\176\134\230\154\130\229\129\156\232\144\165\228\184\154\239\188\140\229\177\138\230\151\182\231\142\169\229\174\182\229\176\134\228\184\141\229\134\141\232\131\189\228\187\142\230\156\172\229\149\134\229\186\151\228\184\173\229\133\145\230\141\162\229\149\134\229\147\129\227\128\130"))
  self:addBody(T("\239\188\1362\239\188\137\228\184\186\229\184\174\229\138\169\233\152\159\233\149\191\229\164\167\229\164\167\229\133\145\230\141\162\228\189\153\233\162\157\239\188\140\229\133\172\228\188\154\229\149\134\229\186\151\230\156\172\230\172\161\230\155\180\230\150\176\229\144\142\233\153\144\230\151\182\228\184\138\230\158\182\230\184\133\228\187\147\231\155\178\231\155\146\239\188\140\229\188\128\229\144\175\229\144\142\229\143\175\233\154\143\230\156\186\232\142\183\229\190\151\228\184\128\228\187\189\231\164\188\231\137\169\227\128\130"))
  self:addBody(T("\239\188\1363\239\188\137\230\184\133\228\187\147\231\155\178\231\155\146\229\176\134\228\186\1426\230\156\13621\229\143\1830:00:00\228\187\142\229\133\172\228\188\154\229\149\134\229\186\151\228\184\139\230\158\182\239\188\140\232\175\183\229\156\1686\230\156\13630\230\151\16523:59\229\136\134\229\137\141\228\189\191\231\148\168\231\155\178\231\155\146\227\128\130"))
  self:addBody(T("\239\188\1364\239\188\137\229\133\173\230\156\136\228\184\139\230\151\172\231\137\136\230\156\172\230\155\180\230\150\176\229\144\142\231\142\169\229\174\182\230\140\145\230\136\152\229\155\162\233\152\159\229\137\175\230\156\172\239\188\140\229\174\140\230\136\144\230\175\143\230\151\165\228\187\187\229\138\161\229\176\134\228\184\141\229\134\141\232\142\183\229\143\150\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129\227\128\130"))
  self:show()
end

function PvpUpgradeNoticeWin:show()
  local parent = ed.getCurrentScene():ccScene()
  parent:addChild(PvpUpgradeNoticeWin.panel:getRootLayer(), 1001)
end

function PvpUpgradeNoticeWin:closeRuleInfo()
  if PvpUpgradeNoticeWin.panel then
    PvpUpgradeNoticeWin.panel:getRootLayer():removeFromParentAndCleanup(true)
    PvpUpgradeNoticeWin.panel = nil
  end
end

function PvpUpgradeNoticeWin:initListView(title)
  local uiConfig = self:getUIConfig(title)
  local panel = panelMeta:new2(self, uiConfig)
  PvpUpgradeNoticeWin.panel = panel
  self:getListView():clear()
end

function PvpUpgradeNoticeWin:getListView()
  return PvpUpgradeNoticeWin.panel.ruleLayer.listview
end

function PvpUpgradeNoticeWin:addTextItem(text, color)
  local width = 520
  local richText = string.format("<text|%s|%s|%d>", color, text, width)
  self:getListView():addItem({richText})
end

function PvpUpgradeNoticeWin:addTitle(text)
  self:addTextItem(text, "dark_white")
end

function PvpUpgradeNoticeWin:addBody(text)
  self:addTextItem(text, "normalButton")
end

function PvpUpgradeNoticeWin:getUIConfig(title)
  local config = {
    {
      layerName = "ruleLayer",
      iPriority = 999,
      layerColor = ccc4(0, 0, 0, 190),
      touchInfo = {
        iPriority = -600,
        bSwallowsTouches = true,
        alert = true
      },
      uiRes = {
        {
          t = "Scale9Sprite",
          base = {
            name = "ruleInfo",
            res = "UI/alpha/1080P/common/main_vit_tips.png",
            capInsets = CCRectMake(15, 20, 45, 15)
          },
          layout = {
            anchor = ccp(0.5, 0.5),
            position = ccp(400, 240)
          },
          config = {
            scaleSize = CCSizeMake(590, 360)
          }
        },
        {
          t = "Label",
          base = {
            name = "ui",
            text = title,
            size = 22,
            parent = "ruleInfo"
          },
          layout = {
            anchor = ccp(0.5, 0.5),
            position = ccp(295, 320)
          },
          config = {
            color = ccc3(251, 206, 16)
          }
        },
        {
          t = "Sprite",
          base = {
            name = "heroInfo",
            parent = "ruleInfo",
            res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
          },
          layout = {
            anchor = ccp(0.5, 0.5),
            position = ccp(295, 320)
          },
          config = {
            scalexy = {x = 1.5, y = 1.1}
          }
        },
        {
          t = "SpriteButton",
          base = {
            name = "closeRuleInfo",
            sound = "sound_menu/common_close_popup_window.mp3",
            res = {
              normal = "UI/alpha/1080P/common/common_tips_button_close_1.png"
            },
            parent = "ruleInfo",
            handleName = "closeRuleInfo"
          },
          layout = {
            anchor = ccp(0.5, 0.5),
            position = ccp(574, 340)
          }
        },
        {
          t = "ListView",
          base = {
            name = "listview",
            cliprect = CCRectMake(120, 90, 560, 250),
            priority = -600
          },
          itemConfig = {
            {
              t = "RichText",
              base = {name = "name", text = ""},
              layout = {
                anchor = ccp(0, 1),
                position = ccp(20, 10)
              },
              listData = true
            }
          }
        }
      }
    }
  }
  return config
end
