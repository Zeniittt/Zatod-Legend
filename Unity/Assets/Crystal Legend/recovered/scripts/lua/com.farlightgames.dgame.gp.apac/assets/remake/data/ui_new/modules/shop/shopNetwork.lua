local network = {}
network.__index = network
local newShopUp = {}

function network.create()
  local object = {}
  setmetatable(object, network)
  object:registerEventHandler()
  return object
end

function network:checkOpenShop(shopId)
  if not ed.shopData.shopListData[shopId] then
    local msg = ed.upmsg.open_shop()
    msg._shopid = shopId
    ed.send(msg, "open_shop")
  end
end

function network:openShopReply(shop)
  ed.shopData:addItemList(shop)
  FireEvent("shopMainUpdate", shop._id)
end

function network:shopRefresh(type, shopId)
  local msg = ed.upmsg.shop_refresh()
  msg._type = type
  msg._shop_id = shopId
  ed.send(msg, "shop_refresh")
end

function network.cosmeticSendOpenPanel()
  local msg = ed.upmsg.cosmetic_shop_req()
  msg._open_panel = {}
  ed.send(msg, "cosmetic_shop")
end

function network.cosmeticSendExchange(id, type)
  if ed.exteriorShopData.goodsInfo and ed.exteriorShopData.goodsInfo[id] then
    if type == 1 then
      local price = ed.exteriorShopData.goodsInfo[id]["Orange Price Discount"] > 0 and ed.exteriorShopData.goodsInfo[id]["Orange Price Discount"] or ed.exteriorShopData.goodsInfo[id]["Orange Price"]
      if price > ed.player:getEquipAmount(20269) then
        local item = ed.getDataTable("equip")[20269]
        return ed.showToast(T("%s\228\184\141\232\182\179", item.Name))
      end
    end
    if type == 2 then
      local price = 0 < ed.exteriorShopData.goodsInfo[id]["Blue Price Discount"] and ed.exteriorShopData.goodsInfo[id]["Blue Price Discount"] or ed.exteriorShopData.goodsInfo[id]["Blue Price"]
      if price > ed.player:getEquipAmount(20270) then
        local item = ed.getDataTable("equip")[20270]
        return ed.showToast(T("%s\228\184\141\232\182\179", item.Name))
      end
    end
  end
  local msg = ed.upmsg.cosmetic_shop_req()
  msg._exchange = ed.upmsg.cosmetic_shop_exchange()
  msg._exchange._goods_id = id
  msg._exchange._coin_type = type or 1
  ed.send(msg, "cosmetic_shop")
end

function network.cosmeticSendViewFlag(type)
  local msg = ed.upmsg.cosmetic_shop_req()
  msg._view_flag = ed.upmsg.cosmetic_shop_view_flag()
  msg._view_flag._type = type
  ed.send(msg, "cosmetic_shop")
end

function network:shopRefreshReply(shop)
  local shop = shop._user_shop
  if shop._last_auto_refresh_time then
    local data = ed.shopData:getShopPageData()
    if data[shop._id] and shop._id ~= 1 and data[shop._id].autoRefreshTime == shop._last_auto_refresh_time then
      print(" shop autoRefreshTime, Refresh failed ")
      data[shop._id].autoRefreshTime = ed.getServerTime()
    end
    ed.shopData:upDataItemList(shop)
    FireEvent("shopMainUpdate", shop._id)
  end
end

function network:shopConsume(shopId, data, num)
  local item = data.item
  newShopUp = {
    shopId = shopId,
    isTime = data.time ~= nil,
    IdOrIndex = data.time ~= nil and data.id or data.index,
    num = num,
    item = {
      {
        _id = item.id,
        _amount = item.count * num,
        _type = "item"
      }
    }
  }
  if data.time then
    local msg = ed.upmsg.simple_shop_req()
    local simpleGoods = {}
    simpleGoods._goods_id = data.id
    simpleGoods._buy_times = num
    msg._simple_shop_buy = simpleGoods
    ed.send(msg, "simple_shop")
  else
    local msg = ed.upmsg.shop_consume()
    msg._sid = shopId
    msg._slotid = data.index
    msg._itemid = item.id
    msg._buy_times = num
    ed.send(msg, "shop_consume")
  end
end

function network:shopConsumeReply(reply)
  local result
  if newShopUp.isTime then
    if reply._error_code then
      ed.showToast(reply._error_code)
      return
    end
    if reply._buy then
      result = true
      newShopUp.IdOrIndex = reply._buy._goods_id or newShopUp.IdOrIndex
    end
  else
    result = reply._result
    result = result == "success" or result == 0
  end
  if result then
    ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
    ed.player:addRewards(newShopUp.item or {})
    ed.shopData:upDataListShopItem(newShopUp.shopId, newShopUp.isTime, newShopUp.IdOrIndex, newShopUp.num)
    FireEvent("shopMainItemUpData", newShopUp)
    ed.player:increaseDailyjobCount({
      type = "ChooseShopToBuy",
      pid = newShopUp.shopId,
      add = 1
    })
  else
    ed.showToast(T("\232\180\173\228\185\176\229\164\177\232\180\165"))
  end
end

function network:cosmeticShopReply(reply)
  if reply._open_panel then
    ed.exteriorShopData:setShopShowGoods(reply._open_panel._show_goods_id or {})
    ed.exteriorShopData:setShopGoodsInfo(reply._open_panel._bough_goods_id or {}, true)
    FireEvent("cosmeticShopReplyShow", {isInit = true})
  elseif reply._exchange then
    if reply._exchange._result == "success" then
      ed.exteriorShopData:setShopGoodsInfo({
        reply._exchange._goods_id
      })
      FireEvent("cosmeticShopReplyShow")
      for _, v in ipairs(reply._exchange._cut_items or {}) do
        ed.player:consumeEquip(v._id, v._amount)
      end
      ed.player:addRewards(reply._exchange._rewards or {})
      ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
    else
      ed.showToast(T("\232\180\173\228\185\176\229\164\177\232\180\165"))
    end
  elseif not reply._view_flag or reply._view_flag._result == "success" then
  else
    ed.showToast(T("flag error"))
  end
end

function network:registerEventHandler()
  ListenEvent("open_shop_reply", function(info)
    self:openShopReply(info)
  end)
  ListenEvent("shop_consume_reply", function(info)
    self:shopConsumeReply(info)
  end)
  ListenEvent("shopRefreshReply", function(info)
    self:shopRefreshReply(info)
  end)
  ListenEvent("cosmeticShopReply", function(info)
    self:cosmeticShopReply(ed.copyProto(info))
  end)
end

ed.shop_network = network.create()
