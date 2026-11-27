local base = ed.ui.popwindow
local shopSeleteListWin = {}
setmetatable(shopSeleteListWin, base.mt)
shopSeleteListWin.__index = shopSeleteListWin
ed.ui.shopSeleteListWin = shopSeleteListWin
local shop_list = {
  [1] = {
    name = "\231\153\190\232\180\167\229\176\143\229\186\151",
    headRes = "UI/alpha/HVGA/shop_head.png",
    pos = ccp(110, 104),
    show = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("shop")
      if ds then
        return false
      end
      return true
    end
  },
  [4] = {
    name = "\232\191\156\229\190\129\229\134\155\232\161\165\231\187\153\231\171\153",
    pos = ccp(113, 116.5),
    headRes = "UI/alpha/HVGA/shop_head_tb.png",
    redLightRes = "UI/alpha/HVGA/main_deal_tag.png",
    show = function()
      if ed.player:getLevel() >= 30 then
        return true
      end
      return false
    end
  },
  [5] = {
    name = "\231\171\158\230\138\128\229\156\186\229\134\155\233\156\128\229\149\134\229\186\151",
    headRes = "UI/alpha/HVGA/shop_head_panda.png",
    redLightRes = "UI/alpha/HVGA/main_deal_tag.png",
    pos = ccp(110, 106),
    show = function()
      if ed.player:getLevel() >= 10 then
        return true
      end
      return false
    end
  },
  [10] = {
    name = "\230\136\152\229\156\186\229\134\155\233\156\128\229\174\152\229\149\134\229\186\151",
    headRes = "UI/alpha/HVGA/shop_head_gvg.png",
    redLightRes = "UI/alpha/HVGA/main_deal_tag.png",
    pos = ccp(100, 143),
    show = function()
      if ed.player:getLevel() >= 32 and ed.player:getGuildId() ~= 0 then
        return true
      end
      return false
    end
  },
  [11] = {
    name = "\230\162\166\229\162\131\229\176\143\229\186\151",
    headRes = "UI/alpha/HVGA/shop_head_dreamland.png",
    redLightRes = "UI/alpha/HVGA/main_deal_tag.png",
    pos = ccp(95, 118),
    show = function()
      if ed.player:getLevel() >= 65 then
        return true
      end
      return false
    end
  },
  [15] = {
    name = "\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186",
    pos = ccp(103, 127.2),
    headRes = "UI/alpha/HVGA/legend_pvp/shop_head_legendpvp.png",
    redLightRes = "UI/alpha/HVGA/main_deal_tag.png",
    show = function()
      if ed.player:getLevel() >= 60 then
        return true
      end
      return false
    end
  },
  [20] = {
    name = "\233\153\144\230\151\182\228\188\152\230\131\160\229\149\134\229\186\151",
    pos = ccp(108, 145),
    checkOpen = true,
    headRes = "UI/alpha/HVGA/shop_head_diamond.png",
    discountRes = "UI/alpha/HVGA/discountShop/shop_head_diamond.png",
    show = function()
      if ed.player:getLevel() > 0 then
        return true
      end
      return false
    end
  }
}
ed.shopList = shop_list

function shopSeleteListWin.create()
  local self = base.create("shopSeleteListWin", {isShade = true})
  setmetatable(self, shopSeleteListWin)
  self:initData()
  self:initAppearence()
end

function shopSeleteListWin:initData()
  self.itemArray = {}
  self.currentOpenShopId = nil
  self.timerList = {}
end

function shopSeleteListWin:initAppearence()
  local mainLayer = self.mainLayer
  local layer = CCLayer:create()
  local container
  container, self.ui = ed.editorui(ed.uieditor.shopSeleteListWin)
  layer:addChild(container)
  self.layer = layer
  self:setContainer(layer)
  self:createListLayer()
  self:createItemList()
  CCDirector:sharedDirector():getRunningScene():addChild(mainLayer, 200)
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -500, true)
  self.mainLayer:setTouchEnabled(true)
end

function shopSeleteListWin:createListLayer()
  local contentSize = self.ui.node_list:getContentSize()
  self.contentSize = contentSize
  local info = {
    cliprect = CCRectMake(0, 0, contentSize.width, contentSize.height),
    container = self.ui.node_list,
    noshade = true,
    zorder = 5,
    priority = -501
  }
  self.draglist = ed.draglist.create(info)
  self.listlayer = self.draglist:getList()
end

function shopSeleteListWin:createItemList()
  local showShopTable = self:getShowShopTable()
  local ITEM_WIDTH = 130
  local ITEM_HEIGHT = 170
  for i, shopInfo in ipairs(showShopTable) do
    local posx = math.floor((i - 1) % 5) * ITEM_WIDTH
    local posy = self.contentSize.height - ITEM_HEIGHT * math.floor((i - 1) / 5 + 1)
    local item, ui = self:createItem(shopInfo)
    local head_sp = self:createItemHead(shopInfo)
    local red_light
    if shopInfo.redLightRes then
      local size = ui.shop_name:getContentSize()
      red_light = self:createItemRedLight(shopInfo, ccp(size.width, size.height))
    end
    ui.head = head_sp
    ui.container:addChild(head_sp, 3)
    if red_light then
      ui.redLight = red_light
      ui.shop_name:addChild(red_light)
    end
    ui.container:setPosition(ccp(posx, posy))
    ui.container:setScale(0.7)
    self.listlayer:addChild(item)
    table.insert(self.itemArray, {ui = ui, info = shopInfo})
  end
end

function shopSeleteListWin:createItem(shop_info)
  local item, ui = ed.editorui(ed.uieditor.shopSeleteHeadView)
  if shop_info.open then
    local shopId = shop_info.id
    local state = ed.player:checkShopTimeType(shopId)
    ed.setString(ui.shop_name, shop_info.name)
    if state == "refresh" or state == "unknown" then
      ed.setString(ui.refresh_count, shop_info.refresh_count)
      ed.setString(ui.Label_41, T("\229\183\178\229\136\183\230\150\176\230\172\161\230\149\176"))
      ui.Label_41:setPositionX(ui.title_mask:getContentSize().width / 2 - 20)
    else
      local time = ed.player:getShopShowTime(shopId)
      ed.setString(ui.refresh_count, ed.getmsNString(time))
      ed.setString(ui.Label_41, T("\229\137\169\228\189\153\230\151\182\233\151\180"))
      ui.Label_41:setPositionX(ui.title_mask:getContentSize().width / 2 - 25)
      self:startListenTimer(ui.refresh_count, shopId)
    end
  else
    ed.setString(ui.refresh_count, "")
    ed.setString(ui.Label_41, T("\230\156\170\229\188\128\229\144\175"))
    ui.Label_41:setPositionX(ui.title_mask:getContentSize().width / 2)
    ed.setString(ui.shop_name, shop_info.name)
  end
  return item, ui
end

function shopSeleteListWin:startListenTimer(label, shopId)
  local time = ed.player:getShopShowTime(shopId)
  ListenTimer(Timer:Always(1, "shop_timer_" .. shopId), function()
    time = time - 1
    if 0 < time then
      ed.setString(label, ed.getmsNString(time))
    else
      ed.setString(label, T("\230\156\170\229\188\128\229\144\175"))
      self:updateShopItem(shopId)
      CloseTimer("shop_timer_" .. shopId)
    end
  end, shopSeleteListWin)
end

function shopSeleteListWin:createItemRedLight(shop_info, pos)
  local redLight = ed.createSprite(shop_info.redLightRes)
  redLight:setPosition(pos)
  local isVisible = false
  for k, v in pairs(ed.ShopMgr.simple_shop_notify or {}) do
    if v[".data"]._shop_id == shop_info.id then
      isVisible = v[".data"].isVisible
    end
  end
  redLight:setVisible(isVisible)
  return redLight
end

function shopSeleteListWin:createItemHead(shop_info)
  local head_sp = ed.createSprite(shop_info.headRes)
  head_sp:setAnchorPoint(ccp(0.5, 0))
  head_sp:setPosition(ccp(shop_info.pos.x - 27, shop_info.pos.y - 50))
  if not shop_info.open then
    ed.setSpriteStone(head_sp)
  end
  return head_sp
end

function shopSeleteListWin:updateShopItem(shopId)
  for i, shopItem in ipairs(self.itemArray) do
    local info = shopItem.info
    if info.id == shopId and info.checkOpen and not ed.player:checkShopValid(shopId) then
      ed.setSpriteStone(shopItem.ui.head)
    end
  end
end

function shopSeleteListWin:getRefreshShopTimes(shop_data)
  local data = shop_data
  if not data then
    return
  end
  local lt = data._last_manual_refresh_time
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    return 0
  else
    return data._today_times
  end
end

function shopSeleteListWin:getShowShopTable()
  local showShopTable = {}
  for id, info in pairs(shop_list) do
    local shop_data = ed.ShopMgr.getInstance():getOneShopDataById(id)
    if shop_data or info.show() then
      local refreshNum = 0
      if shop_data then
        refreshNum = self:getRefreshShopTimes(shop_data)
      end
      local shop_l = {
        id = id,
        name = info.name,
        headRes = info.headRes,
        redLightRes = info.redLightRes or nil,
        refresh_count = refreshNum,
        pos = info.pos,
        open = self:shopIsOpen(id, info),
        checkOpen = info.checkOpen
      }
      table.insert(showShopTable, shop_l)
    end
  end
  table.sort(showShopTable, function(a, b)
    if a.id < b.id then
      return true
    end
    return false
  end)
  return showShopTable
end

function shopSeleteListWin:shopIsOpen(id, info)
  if info.checkOpen then
    return ed.player:checkShopValid(id)
  else
    return true
  end
end

function shopSeleteListWin:doMainLayerTouch()
  local doTouchItem = self:doTouchItem()
  local doCloseHandler = self:doCloseHandler()
  local mainLayer = self.mainLayer
  
  local function handler(event, x, y)
    xpcall(function()
      if not mainLayer or not mainLayer:isVisible() then
        return
      end
      doTouchItem(event, x, y)
      doCloseHandler(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

function shopSeleteListWin:doCloseHandler(event, x, y)
  local isPress
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.close_btn, x, y) then
        isPress = true
        self.ui.close_btn_press:setVisible(true)
      end
    elseif event == "ended" then
      if ed.containsPoint(self.ui.close_btn, x, y) and isPress then
        self:exit()
      end
      self.ui.close_btn_press:setVisible(false)
      isPress = false
    end
  end
  
  return handler
end

function shopSeleteListWin:doTouchItem(event, x, y)
  local px, py
  local isClickOutSide = false
  local isPress = false
  local index
  local items = self.itemArray or {}
  
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #self.itemArray do
        local ic = self.itemArray[i]
        if ed.containsPoint(ic.ui.container, x, y) and ed.containsPoint(self.ui.view_bg, x, y) then
          isPress = true
          index = i
          ic.ui.container:setScale(0.65)
        end
      end
      if not ed.containsPoint(self.ui.view_bg, x, y) then
        isClickOutSide = true
      end
      px = x
      py = y
    elseif event == "moved" then
      local dis = ccpDistanceSQ(ccp(x, y), ccp(px or 0, py or 0))
      if 10 < dis then
        isClickOutSide = false
        isPress = false
        if index then
          items[index].ui.container:setScale(0.7)
        end
        index = nil
      end
    elseif event == "ended" then
      if isClickOutSide then
        self:exit()
      end
      if not index then
        return
      end
      local ic = items[index]
      if ed.containsPoint(ic.ui.container, x, y) and isPress then
        ic.ui.container:setScale(0.7)
        self:openShopHandler(ic.info)
      end
      isPress = false
      isClickOutSide = false
      index = nil
      px = nil
      py = nil
    end
  end
  
  return handler
end

function shopSeleteListWin:openShopHandler(shop_info)
  local isShopOpen = self:shopIsOpen(shop_info.id, shop_info)
  if isShopOpen then
    self:exit()
    ed.popScene()
    print("shop_id---->>>", shop_info.id)
    ed.pushScene(ed.ui.shop.create(shop_info.id))
  else
    local toId = ed.ui.marketconfig.toId
    if shop_info.id ~= toId.diamondShop then
      self:showShopSummonWindow(shop_info.id)
    else
      self:showExpiredTips(shop_info.id)
    end
  end
end

function shopSeleteListWin:showExpiredTips(shopId)
  if not ed.player:getShopData(shopId) then
    local text = ed.ui.marketconfig.getNotOpenExplaination(shopId) or T("\229\149\134\229\186\151\230\154\130\230\156\170\229\188\128\230\148\190")
    ed.showToast(text)
    return
  end
  local state = ed.player:checkShopTimeType(shopId)
  if state == "expire" then
    local showTime = ed.player:getShopShowTime(shopId)
    if showTime and showTime <= 0 then
      local data = ed.player:getShopData(shopId)
      local isCanTrigger = false
      if data then
        local createTime = data._create_time or 0
        local resetTime = ed.getTodayOriginTimeWithServer() + 18000 or 0
        if createTime < resetTime and resetTime <= ed.getServerTime() then
          isCanTrigger = true
        end
      end
      if isCanTrigger then
        local text = ed.ui.marketconfig.getNotOpenExplaination(shopId) or T("\229\149\134\229\186\151\230\154\130\230\156\170\229\188\128\230\148\190")
        ed.showToast(text)
      else
        local text = ed.ui.marketconfig.getLevelExplaination(shopId) or T("\231\165\158\231\167\152\229\149\134\228\186\186\229\183\178\231\187\143\233\163\152\231\132\182\232\128\140\229\142\187\239\188\140\228\184\139\230\172\161\228\185\176\228\184\156\232\165\191\229\138\168\228\189\156\232\166\129\229\191\171\229\147\166\239\188\129")
        ed.showToast(text)
      end
    end
  end
end

function shopSeleteListWin:showShopSummonWindow(shopid)
  local keys = {
    [2] = {
      name = T("\229\156\176\231\178\190\229\149\134\228\186\186"),
      key = "Summon Special Shop"
    },
    [3] = {
      name = T("\233\187\145\232\161\163\229\149\134\228\186\186"),
      key = "Summon So Special Shop"
    }
  }
  local price = ed.getDataTable("GradientPrice")[1][keys[shopid].key]
  local text = T("\228\189\160\231\161\174\229\174\154\232\138\177\232\180\185%d\233\146\187\231\159\179\229\143\172\229\148\164%s\229\144\151\239\188\159\n\229\143\172\229\148\164\228\185\139\229\144\142%s\229\176\134\228\184\141\229\134\141\231\166\187\229\188\128", price, keys[shopid].name, keys[shopid].name)
  
  local function rightHandler()
    self:summonShop(shopid, price)
  end
  
  local info = {text = text, rightHandler = rightHandler}
  ed.showConfirmDialog(info)
end

function shopSeleteListWin:summonShop(shopid, price)
  if price > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  self.currentOpenShopId = shopid
  ed.netdata.openShop = {cost = price}
  ed.netreply.openShop = self:openShopReply()
end

function shopSeleteListWin:openShopReply()
  local function handler(result)
    if not result then
      ed.showToast(T("\229\143\172\229\148\164\231\165\158\231\167\152\229\149\134\229\186\151\229\164\177\232\180\165"))
    else
      self:refreshShop()
    end
  end
  
  return handler
end

function shopSeleteListWin:refreshShop()
  for _, item in ipairs(self.itemArray) do
    local shopInfo = item.info
    local itemUI = item.ui
    if shopInfo.id == self.currentOpenShopId then
      shopInfo.open = true
      ed.resetSpriteShader(itemUI.head)
      ed.setString(itemUI.refresh_count, shopInfo.refresh_count)
      ed.setString(itemUI.Label_41, T("\229\183\178\229\136\183\230\150\176\230\172\161\230\149\176"))
    end
  end
end

function shopSeleteListWin:exit()
  FireEvent("shopNotifyData")
  CloseScope(shopSeleteListWin)
  self.itemArray = nil
  self:destroy({skipAnim = true})
end
