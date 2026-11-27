local exteriorShopData = {}

function exteriorShopData:init()
  self.shopInfo = {}
  self.goodsId = {}
  self.goodsInfo = {}
  for _, v in pairs(ed.getDataTable("CosmeticShop")) do
    if v["Goods Type"] then
      self.shopInfo[v["Goods Type"]] = self.shopInfo[v["Goods Type"]] or {}
      local tab = {isBuy = false}
      for kk, vv in pairs(v) do
        tab[kk] = vv
      end
      table.insert(self.shopInfo[v["Goods Type"]], tab)
      self.goodsInfo[v["Goods ID"]] = tab
    end
  end
  return self
end

function exteriorShopData:getShopInfo()
  return self.shopShowInfo or {}
end

function exteriorShopData:refreshShopInfo()
  for _, vv in pairs(self.shopInfo) do
    for _, v in pairs(vv) do
      if self.goodsId[v["Goods ID"]] then
        v.isBuy = self.goodsId[v["Goods ID"]]
      end
    end
  end
end

function exteriorShopData:setShopShowGoods(goods)
  self.showGoodsId = {}
  for _, v in ipairs(goods) do
    self.showGoodsId[v] = true
  end
end

function exteriorShopData:setShopGoodsInfo(goods, isInit)
  if goods then
    if isInit then
      self.goodsId = {}
    end
    for _, v in ipairs(goods) do
      self.goodsId[v] = true
    end
  end
  self:refreshShopInfo()
  if isInit then
    local function func(a, b)
      if a.isBuy == b.isBuy then
        local qualityA = ed.readequip.quality(a["Reward Item ID"]) or 1
        
        local qualityB = ed.readequip.quality(b["Reward Item ID"]) or 1
        if qualityA == qualityB then
          local onlineTimeA = ed.getTimeByYMDHMS(a["Online Time"])
          local onlineTimeB = ed.getTimeByYMDHMS(b["Online Time"])
          if onlineTimeA == onlineTimeB then
            return a["Goods ID"] > b["Goods ID"]
          else
            return onlineTimeA > onlineTimeB
          end
        else
          return qualityA > qualityB
        end
      else
        return (a.isBuy and 1 or 0) < (b.isBuy and 1 or 0)
      end
    end
    
    for _, v in pairs(self.shopInfo) do
      table.sort(v, func)
    end
    local newShopInfo = {}
    for k, v in pairs(self.shopInfo) do
      newShopInfo[k] = newShopInfo[k] or {}
      for _, vv in ipairs(v) do
        if self.showGoodsId[vv["Goods ID"]] then
          table.insert(newShopInfo[k], vv)
        end
      end
    end
    self.shopShowInfo = newShopInfo
  end
end

function exteriorShopData.getFashionName(fashionId)
  local fashionName = ed.lookupDataTable("Fashion", "Name", fashionId)
  local heroID = ed.lookupDataTable("Fashion", "Hero ID", fashionId)
  local heroName = ed.lookupDataTable("Unit", "Display Name", heroID)
  return T("%s \194\183 %s", heroName, fashionName)
end

function exteriorShopData.getInstance()
  if not exteriorShopData.instance then
    exteriorShopData.instance = setmetatable({}, {__index = exteriorShopData}):init()
  end
  return exteriorShopData.instance
end

function exteriorShopData:setCircleRed(num)
  self.red = {}
  local redNum = {}
  for i, v in ipairs(num) do
    redNum[v] = true
  end
  local num = 0
  for _, v in pairs(ed.getDataTable("CosmeticShop")) do
    if redNum[v["Goods ID"]] and not self.red[v["Goods Type"]] then
      self.red[v["Goods Type"]] = true
      num = num + 1
    end
  end
  self.redNum = num
end

ed.exteriorShopData = exteriorShopData.getInstance()
