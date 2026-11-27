local ShopMgr = {}
ed.ShopMgr = ShopMgr
local instance

function ShopMgr.getInstance()
  if instance == nil then
    instance = ShopMgr.create()
  end
  return instance
end

function ShopMgr.create()
  local self = {
    shopsData = {},
    allItemList = {}
  }
  setmetatable(self, ShopMgr)
  ShopMgr.__index = ShopMgr
  return self
end

function ShopMgr:initShopsData(data)
  if type(data) ~= "table" then
    assert(false, "Init shops data failed! ")
  end
  self.shopsData = data
  self:initItemList(self.shopsData)
end

function ShopMgr:refreshMultiShopData(datas)
  if type(datas) ~= "table" then
    assert(false, "Refresh multi shop data failed! ")
  end
  for _, oneData in pairs(datas) do
    self:refreshOneShopData(oneData, true)
  end
  self:initItemList(self.shopsData)
end

function ShopMgr:refreshOneShopData(data, isMutil)
  if type(data) ~= "table" then
    assert(false, "Refresh one shop data failed! ")
  end
  local shopCfg = ed.ui.marketconfig.getShopCfg(data._id)
  if not shopCfg then
    return
  end
  local isExist = false
  for k, oneShopData in pairs(self.shopsData) do
    if data._id == oneShopData._id then
      self.shopsData[k] = data
      isExist = true
    end
  end
  if isExist == false then
    table.insert(self.shopsData, data)
  end
  if not isMutil then
    self:initItemList(self.shopsData)
  end
end

function ShopMgr:getShopsData()
  return self.shopsData
end

function ShopMgr:getOneShopDataById(id)
  for _, oneShopData in pairs(self.shopsData) do
    if id == oneShopData._id then
      return oneShopData
    end
  end
end

function ShopMgr:reqRefreshMultiShopData(ids)
  ids = ids or self:getNeedRefreshShopIds()
  if 0 < #ids then
  end
end

function ShopMgr:getNeedRefreshShopIds()
  local ids = {}
  for _, oneShopData in pairs(self.shopsData) do
    local id = oneShopData._id
    local shopCfg = ed.ui.marketconfig.getShopCfg(id)
    if shopCfg and self:checkShopNeedRefresh(id) == true and self:getShopCountDown(id) and self:getShopCountDown(id) < 0 then
      table.insert(ids, id)
    end
  end
  return ids
end

function ShopMgr:checkShopNeedRefresh(id)
  local shopCfg = ed.ui.marketconfig.getShopCfg(id)
  if not shopCfg then
    return false
  end
  if not self:getOneShopDataById(id) then
    return false
  end
  local state = self:checkShopTimeType(id)
  if state == "refresh" then
    return true
  elseif state == "expire" then
    if self:getShopExpireTime(id) < 0 then
      return false
    else
      return true
    end
  end
  return false
end

function ShopMgr:checkShopTimeType(id)
  if id == ed.ui.marketconfig.toId.hideStar then
    local rt = self:getShopCountDown(id)
    if rt then
      return "refresh"
    end
  end
  local et = self:getShopExpireTime(id)
  if et then
    return "expire"
  end
  local rt = self:getShopCountDown(id)
  if rt then
    return "refresh"
  end
  return "unknown"
end

function ShopMgr:getShopExpireTime(id)
  local data = self:getOneShopDataById(id)
  if not data then
    return
  end
  local et = data._expire_time
  if et == 0 then
    return nil
  end
  local nt = ed.getServerTime()
  return et - nt
end

function ShopMgr:getShopCountDown(id)
  local nextTime, nextPoint = self:getShopNextAutoRefreshPoint(id)
  if not nextTime then
    return
  end
  local nt = ed.getServerTime()
  return nextPoint - nt
end

function ShopMgr:getShopNextAutoRefreshPoint(id)
  local data = self:getOneShopDataById(id)
  if not data then
    return
  end
  local rt = data._last_auto_refresh_time
  if rt == 0 then
    return nil
  end
  local tblcontent = ed.Player:getTblContent(id)
  local mts = tblcontent["Refresh Times"]
  local nt = ed.getServerTime()
  local minTime, minPoint
  for i = 1, #mts do
    local te = ed.getTimeByTodayHMS(mts[i])
    minPoint = minPoint or te
    minTime = minTime or mts[i]
    if nt >= te then
      if rt < te then
        return mts[i], te, "today"
      end
    else
      return mts[i], te, "today"
    end
    if te < minPoint then
      minPoint = te
      minTime = mts[i]
    end
  end
  return minTime, minPoint + 86400, "tomorrow"
end

function ShopMgr:getShopCountDownDes(id)
  local str = "00:00:00"
  local countDown = self:getShopCountDown(id)
  if countDown and 0 < countDown then
    str = ed.gethmsNString(countDown)
  end
  return str
end

function ShopMgr:isShopActive(shopData)
  if shopData._id == ed.ui.marketconfig.shopName2IdTbl.guild then
    return false
  end
  return true
end

function ShopMgr:initSimpleItemList(data)
  self.allItemList = {}
  for _, oneShop in pairs(data) do
    for _, oneGood in pairs(oneShop._current_goods or {}) do
      local good = {
        shopId = oneShop._id,
        itemId = oneGood._id,
        amount = oneGood._amount,
        pType = oneGood._type,
        price = oneGood._price,
        isSale = oneGood._discount_type,
        pValue = oneGood._price_value
      }
      if oneGood._amount > 0 then
        table.insert(self.allItemList, good)
      end
    end
  end
end

function ShopMgr:initItemList(data)
  self.allItemList = {}
  for _, oneShop in pairs(data) do
    if self:isShopActive(oneShop) then
      for _, oneGood in pairs(oneShop._current_goods or {}) do
        local good = {
          shopId = oneShop._id,
          itemId = oneGood._id,
          amount = oneGood._amount,
          pType = oneGood._type,
          price = oneGood._price,
          isSale = oneGood._discount_type,
          pValue = oneGood._price_value
        }
        if oneGood._amount > 0 then
          table.insert(self.allItemList, good)
        end
      end
    end
  end
end

function ShopMgr:refreshBuyedOneItemInSimpleList(shop, goodId)
  for k, oneItem in pairs(self.allItemList) do
    if shop == oneItem.shopId and goodId == oneItem.itemId then
      self.allItemList[k].amount = 0
      break
    end
  end
end

function ShopMgr:refreshBuyedOneItemInAllItemList(shop, goodId)
  for k, oneItem in pairs(self.allItemList) do
    if shop == oneItem.shopId and goodId == oneItem.itemId then
      self.allItemList[k].amount = 0
      break
    end
  end
end

function ShopMgr:refreshBuyedOneItemInShopsData(shop, goodId)
  for _, oneShop in pairs(self.shopsData) do
    if oneShop._id == shop then
      for k, oneGood in pairs(oneShop._current_goods) do
        if goodId == oneGood._id then
          oneShop._current_goods[k]._amount = 0
          break
        end
      end
      break
    end
  end
end

function ShopMgr:getItemsDataByItemids(itemids)
  if type(itemids) ~= "table" then
    assert(false, "getItemsDataByItemids failed! ")
  end
  local itemsData = {}
  for _, itemid in pairs(itemids) do
    local itemData = self:getItemDataByItemid(itemid)
    for _, oneItemData in pairs(itemData) do
      table.insert(itemsData, oneItemData)
    end
  end
  return itemsData
end

function ShopMgr:getItemDataByItemid(itemid)
  local itemData = {}
  for _, oneItem in pairs(self.allItemList) do
    if itemid == oneItem.itemId then
      table.insert(itemData, oneItem)
    end
  end
  return itemData
end

function ShopMgr:getOneItemTotalAmountByItemid(itemid)
  local totalAmount = 0
  local itemData = self:getItemDataByItemid(itemid)
  for _, oneItem in pairs(itemData) do
    if itemid == oneItem.itemId then
      totalAmount = totalAmount + oneItem.amount
    end
  end
  return totalAmount
end

function ShopMgr:isRefreshedShopByItemIds(itemids)
  local needRefreshShopIds = self:getNeedRefreshShopIds()
  if #(needRefreshShopIds or {}) == 0 then
    return false
  end
  local itemsData = self:getItemsDataByItemids(itemids)
  for _, oneData in pairs(itemsData) do
    if ed.isElementInTable(oneData.shopId, needRefreshShopIds) then
      return true
    end
  end
  return false
end

function ShopMgr:getShopState()
  local sshopOpen = ed.player:checkShopValid(2)
  local ssshopOpen = ed.player:checkShopValid(3)
  local diamondShopOpen = ed.player:checkShopValid(20)
  if not sshopOpen and not ssshopOpen and not diamondShopOpen then
    return "noDiamondState1"
  end
  if sshopOpen and not ssshopOpen and not diamondShopOpen then
    return "noDiamondState2"
  end
  if not sshopOpen and ssshopOpen and not diamondShopOpen then
    return "noDiamondState3"
  end
  if sshopOpen and ssshopOpen and not diamondShopOpen then
    return "noDiamondState4"
  end
  if not sshopOpen and not ssshopOpen and diamondShopOpen then
    return "diamondOpenState1"
  end
  if not sshopOpen and ssshopOpen and diamondShopOpen then
    return "diamondOpenState2"
  end
  if sshopOpen and not ssshopOpen and diamondShopOpen then
    return "diamondOpenState3"
  end
  if sshopOpen and ssshopOpen and diamondShopOpen then
    return "diamondOpenState4"
  end
end
