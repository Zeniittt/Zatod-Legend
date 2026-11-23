local shopData = {}
shopData.__index = shopData
ed.shopData = shopData
shopData.shopVis = {
  {
    shopId = 1,
    name = "gold",
    vis = false
  },
  {
    shopId = 2,
    name = "arena",
    vis = false
  },
  {
    shopId = 3,
    name = "crusade",
    vis = false
  },
  {
    shopId = 4,
    name = "dream",
    vis = false
  },
  {
    shopId = 5,
    name = "guild",
    vis = false
  },
  {
    shopId = 201,
    name = "cosmetic",
    vis = true
  },
  {
    shopId = 8,
    name = "tavern",
    vis = false
  }
}

function shopData:getShopId(index)
  return self.shopVis[index].shopId
end

function shopData:getShopVis(index)
  return self.shopVis[index].vis
end

function shopData:setShopVis(index, vis)
  self.shopVis[index].vis = vis
end

function shopData:initShopsData(data)
  if type(data) ~= "table" then
    assert(false, "Init shops data failed! ")
  end
  self.shopsData = data
  self:initItemList()
end

function shopData:initItemList()
  if self.shopsData then
    self.shopListData = {}
    self.shopPageData = {}
    for i, v in ipairs(self.shopsData) do
      local items = {}
      for t, s in ipairs(v._simple_goods or {}) do
        local zhe = self:getGoodsZhe(s)
        table.insert(items, {
          item = {
            id = s._item_id,
            count = s._item_amount,
            type = "item"
          },
          id = s._id,
          price = s._price_value,
          priceType = s._price_type,
          amountNew = s._cur_buy_times,
          amountMax = s._max_buy_times or 1,
          time = s._deadline,
          zhe = zhe,
          limited = s._limited
        })
      end
      for t, s in ipairs(v._current_goods or {}) do
        local zhe = self:getGoodsZhe(s)
        table.insert(items, {
          item = {
            id = s._id,
            count = s._amount,
            type = "item"
          },
          price = s._price,
          priceType = s._type,
          amountNew = s._cur_buy_times,
          amountMax = s._max_buy_times or 1,
          index = t,
          zhe = zhe,
          limited = s._limited
        })
      end
      v._expire_time = self:getExpireTime(v._id, ed.time2Server(v._last_auto_refresh_time))
      self.shopListData[v._id] = items
      self.shopPageData[v._id] = {
        refreshTime = v._last_manual_refresh_time,
        expireTime = v._expire_time or 0,
        todayTimes = v._today_times,
        autoRefreshTime = v._last_auto_refresh_time
      }
    end
  end
end

function shopData:getRefreshTime(id)
  local oldTime = self.shopPageData[id].refreshTime
  local oldDayTime = self.shopPageData[id].todayTimes
  local time = ed.getFitServerTime()
  oldTime = ed.time2Server(oldTime)
  local d1 = tonumber(os.date("%d", oldTime))
  local d2 = tonumber(os.date("%d", time))
  local h1 = tonumber(os.date("%H", oldTime))
  local h2 = tonumber(os.date("%H", time))
  if time - (oldTime or 0) > 86400 then
    return 0
  end
  if 5 <= h2 then
    if d1 == d2 and 5 <= h1 then
      return oldDayTime
    end
    return 0
  else
    if d1 == d2 and h1 < 5 then
      return oldDayTime
    elseif d1 + 1 == d2 and 5 <= h1 then
      return oldDayTime
    elseif d2 == 1 and h2 < 5 and time - oldTime < 86400 and 5 <= h1 then
      return oldDayTime
    end
    return 0
  end
end

function shopData:upDataItemList(data)
  if self.shopsData then
    local key
    for i, v in ipairs(self.shopsData) do
      if v._id == data._id then
        key = i
      end
    end
    if key then
      self.shopsData[key] = data
    end
    local items = {}
    for t, s in ipairs(data._simple_goods or {}) do
      local zhe = self:getGoodsZhe(s)
      table.insert(items, {
        item = {
          id = s._item_id,
          count = s._item_amount,
          type = "item"
        },
        id = s._id,
        price = s._price_value,
        priceType = s._price_type,
        amountNew = s._cur_buy_times,
        amountMax = s._max_buy_times or 1,
        time = s._deadline,
        zhe = zhe,
        limited = s._limited
      })
    end
    for t, s in ipairs(data._current_goods or {}) do
      local zhe = self:getGoodsZhe(s)
      table.insert(items, {
        item = {
          id = s._id,
          count = s._amount,
          type = "item"
        },
        price = s._price,
        priceType = s._type,
        amountNew = s._cur_buy_times,
        amountMax = s._max_buy_times or 1,
        index = t,
        zhe = zhe,
        limited = s._limited
      })
    end
    data._expire_time = self:getExpireTime(data._id, ed.time2Server(data._last_auto_refresh_time))
    self.shopListData[data._id] = items
    self.shopPageData[data._id] = {
      refreshTime = data._last_manual_refresh_time,
      expireTime = data._expire_time or 0,
      todayTimes = data._today_times,
      autoRefreshTime = data._last_auto_refresh_time
    }
  end
end

function shopData:getGoodsZhe(data)
  if data._discount_type then
    if data._discount_type == "dynamic_discount" then
      return data._discount_perct / 10
    elseif data._discount_type == "six_discount" then
      return 0.6
    elseif data._discount_type == "eight_discount" then
      return 0.8
    end
  end
end

function shopData:addItemList(data)
  self.shopsData = self.shopsData or {}
  self.shopListData = self.shopListData or {}
  self.shopPageData = self.shopPageData or {}
  table.insert(self.shopsData, data)
  local items = {}
  for t, s in ipairs(data._simple_goods or {}) do
    local zhe = self:getGoodsZhe(s)
    table.insert(items, {
      item = {
        id = s._item_id,
        count = s._item_amount,
        type = "item"
      },
      id = s._id,
      price = s._price_value,
      priceType = s._price_type,
      amountNew = s._cur_buy_times,
      amountMax = s._max_buy_times or 1,
      time = s._deadline,
      zhe = zhe,
      limited = s._limited
    })
  end
  for t, s in ipairs(data._current_goods) do
    local zhe = self:getGoodsZhe(s)
    table.insert(items, {
      item = {
        id = s._id,
        count = s._amount,
        type = "item"
      },
      price = s._price,
      priceType = s._type,
      amountNew = s._cur_buy_times,
      amountMax = s._max_buy_times or 1,
      index = t,
      zhe = zhe,
      limited = s._limited
    })
  end
  data._expire_time = self:getExpireTime(data._id, ed.time2Server(data._last_auto_refresh_time))
  self.shopListData[data._id] = items
  self.shopPageData[data._id] = {
    refreshTime = data._last_manual_refresh_time,
    expireTime = data._expire_time,
    todayTimes = data._today_times,
    autoRefreshTime = data._last_auto_refresh_time
  }
end

function shopData:deleListShopItem(shopId, shopItemId)
  for i, v in ipairs(self.shopsData) do
    if v._id == shopId then
      local key
      for t, s in ipairs(v._simple_goods or {}) do
        if s._id == shopItemId then
          key = t
          break
        end
      end
      if key then
        table.remove(v._simple_goods, key)
      end
      break
    end
  end
  local key
  for i, v in ipairs(self.shopListData[shopId] or {}) do
    if v.id == shopItemId then
      key = i
      break
    end
  end
  if key then
    table.remove(self.shopListData[shopId], key)
  end
end

function shopData:upDataListShopItem(shopId, isTime, IdOrIndex, num)
  local num = num or 1
  for i, v in ipairs(self.shopsData) do
    if v._id == shopId then
      if isTime then
        for t, s in ipairs(v._simple_goods or {}) do
          if s._id == IdOrIndex then
            s._cur_buy_times = s._cur_buy_times + num
            break
          end
        end
        break
      end
      for t, s in ipairs(v._current_goods or {}) do
        if t == IdOrIndex then
          s._cur_buy_times = s._cur_buy_times + num
          break
        end
      end
      break
    end
  end
  for i, v in ipairs(self.shopListData[shopId] or {}) do
    if isTime then
      if v.id and v.id == IdOrIndex then
        v.amountNew = v.amountNew + num
        break
      end
    elseif v.index == IdOrIndex then
      v.amountNew = v.amountNew + num
      break
    end
  end
end

function shopData:getShopPageData()
  self.shopPageData = self.shopPageData or {}
  return self.shopPageData
end

function shopData:getShoplistData()
  self.shopListData = self.shopListData or {}
  return self.shopListData
end

function shopData:getShopOpenVis(shopId)
  if not ed.playerlimit:moduleIsOpened("Shop") then
    return false
  end
  local dayData = ed.taskData:getPageDataObj("day")
  local npcVis = false
  local config = ed.getDataTable("NewShop")
  for k, v in pairs(self.shopVis) do
    if config[v.shopId] then
      local vis = true
      for o, t in ipairs(config[v.shopId]["Open Triggers"]) do
        vis = dayData:checkTriggers(t)
        if not vis then
          break
        end
      end
      v.vis = vis
      npcVis = npcVis or vis
    end
  end
  if shopId then
    for i, v in ipairs(self.shopVis) do
      if v.shopId == shopId then
        return v.vis
      end
    end
  end
  return npcVis
end

shopData.weekAuto = 2

function shopData:getExpireTime(shopId, autoRefreshTime)
  local config = ed.getDataTable("NewShop")
  local time = ed.getFitServerTime()
  if config[shopId] then
    local AutoRefreshType = config[shopId]["Auto Refresh Type"]
    if AutoRefreshType == "Daily" then
      local autoRefTime
      for i, v in ipairs(config[shopId]["Auto Refresh Times"]) do
        local refTime = ed.getTimeByTodayHMSWithServer(v)
        if i == 1 then
          autoRefTime = refTime + 86400
        end
        if time < refTime and autoRefreshTime < refTime then
          autoRefTime = refTime
          break
        end
      end
      return autoRefTime
    elseif AutoRefreshType == "Weekly" then
      return time + 30
    end
  end
  return time + 30
end

function shopData:getShopRefreshCost(index)
  local cost = ed.lookupDataTable("GradientPrice", "Shop Refresh Price 1", index)
  return cost or 0
end
