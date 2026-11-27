local class = ed.Player
local config = ed.ui.marketconfig

local function refreshShopData(self, data, state)
  if not data then
    return
  end
  local id = data._id
  local hasRefresh
  for k, v in pairs(self._shop or {}) do
    if v._id == id then
      self._shop[k] = data
      hasRefresh = true
    end
  end
  if not hasRefresh then
    self._shop = self._shop or {}
    table.insert(self._shop, data)
  end
  self.lastTriggerShopid = id
  if state == "trigger" then
    self:setTriggerShopTag()
  end
  ed.ShopMgr.getInstance():refreshOneShopData(data)
end

class.refreshShopData = refreshShopData

local function refreshStarShopData(self, data, state)
  if not data._star_goods or next(data._star_goods) == nil then
    EDDebug("Star goods wrong!")
  end
  self._sshop = data
  self.lastTriggerShopid = "starshop"
  if state == "trigger" then
    self:setTriggerShopTag()
  end
end

class.refreshStarShopData = refreshStarShopData

local function refreshDiamondShopData(self, data, state)
  if not data._goods_list or next(data._goods_list) == nil then
    EDDebug("Star goods wrong!")
  end
  self._discount_shop = data
  self.lastTriggerShopid = config.toId.diamondShop
  if state == "trigger" then
    self:setTriggerShopTag()
  end
end

class.refreshDiamondShopData = refreshDiamondShopData

local function setTriggerShopTag(self)
  self.hasTriggerSpecialShop = true
end

class.setTriggerShopTag = setTriggerShopTag

local function resetTriggerShopTag(self)
  self.hasTriggerSpecialShop = nil
end

class.resetTriggerShopTag = resetTriggerShopTag

local function hasTriggerShop(self)
  local tag = self.hasTriggerSpecialShop
  self.hasTriggerSpecialShop = nil
  return tag
end

class.hasTriggerShop = hasTriggerShop

local function getShopData(self, id)
  if id == "starshop" then
    return self._sshop
  elseif id == config.toId.diamondShop then
    return self._discount_shop
  else
    for k, v in pairs(self._shop or {}) do
      if v._id == id then
        return v
      end
    end
  end
end

class.getShopData = getShopData

local function upsetShopGoods(self, id, goods)
  local gl = {}
  local seed = 0
  local isShowHotTag = config.isShowHotTag(id)
  if goods == nil then
    return
  end
  if isShowHotTag == true then
    for i = 1, #goods do
      gl[i] = {
        good = goods[i],
        tag = "",
        slot = i
      }
      seed = seed + goods[i]._id
    end
  elseif isShowHotTag == false then
    for i = 1, #goods do
      gl[i] = {
        good = goods[i],
        slot = i
      }
      seed = seed + goods[i]._id
    end
  else
    for i = 1, #goods do
      gl[i] = goods[i]
    end
    return gl
  end
  return gl
end

class.upsetShopGoods = upsetShopGoods

local function getSimpleShopGoods(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  return self:upsetShopGoods(id, data._simple_goods)
end

class.getSimpleShopGoods = getSimpleShopGoods

local function getShopGoods(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  if config.getGoodsType(id) == "stone" and id == "starshop" then
    return self:upsetShopGoods(id, data._star_goods)
  elseif config.getGoodsType(id) == "coin" or id == config.shopName2IdTbl.hideStar then
    if id == config.toId.diamondShop then
      return self:upsetShopGoods(id, data._goods_list)
    else
      return self:upsetShopGoods(id, data._current_goods)
    end
  end
end

class.getShopGoods = getShopGoods

local function buyShopGoods(self, id, slot)
  local data = self:getShopData(id)
  if not data then
    return
  end
  local goods
  if config.getGoodsType(id) == "coin" or id == config.shopName2IdTbl.hideStar then
    if id == config.toId.diamondShop then
      goods = data._goods_list
    else
      goods = data._current_goods
    end
  elseif config.getGoodsType(id) == "stone" then
    goods = data._star_goods
  end
  goods[slot]._amount = 0
end

class.buyShopGoods = buyShopGoods

local function checkShopGoodsEmpty(self, id)
  local goods = self:getShopGoods(id)
  for k, v in pairs(goods) do
    if v._amount > 0 then
      return false
    end
  end
  return true
end

class.checkShopGoodsEmpty = checkShopGoodsEmpty

local function getShopCountDown(self, id)
  local nextTime, nextPoint = self:getShopNextAutoRefreshPoint(id)
  if not nextTime then
    return
  end
  local nt = ed.getServerTime()
  return nextPoint - nt
end

class.getShopCountDown = getShopCountDown

local function getShopNextAutoRefreshPoint(self, id)
  local data = self:getShopData(id)
  if not data then
    return
  end
  local rt = data._last_auto_refresh_time
  if rt == 0 then
    return nil
  end
  if "starshop" == id then
    id = ed.ui.marketconfig.toId.star
  end
  local tblcontent = self:getTblContent(id)
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

class.getShopNextAutoRefreshPoint = getShopNextAutoRefreshPoint

local function getShopNextAutoRefreshPointDesc(self, id)
  local time, point, ps = self:getShopNextAutoRefreshPoint(id)
  local desc = ""
  local h, m, s = ed.hmsNString2HMS(time, resource_config.date_fit_2_zone)
  local pre = ""
  if ps == "tomorrow" then
    pre = T("\230\152\142\230\151\165")
  elseif ps == "today" then
    pre = T("\228\187\138\230\151\165")
  end
  desc = desc .. pre .. h .. T("\231\130\185<key:time>")
  if 0 < m then
    desc = desc .. m .. T("\229\136\134")
  end
  return desc
end

class.getShopNextAutoRefreshPointDesc = getShopNextAutoRefreshPointDesc

local function getShopExpireTime(self, id)
  local data = self:getShopData(id)
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

class.getShopExpireTime = getShopExpireTime

local function getShopShowTime(self, id)
  local et = self:getShopExpireTime(id)
  if et then
    return et
  end
  local rt = self:getShopCountDown(id)
  return rt
end

class.getShopShowTime = getShopShowTime

local function checkShopTimeType(self, id)
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

class.checkShopTimeType = checkShopTimeType

local function checkShopValid(self, id)
  if not self:getShopData(id) then
    return false
  end
  local state = self:checkShopTimeType(id)
  if state == "refresh" then
    return true
  elseif state == "expire" then
    if self:getShopExpireTime(id) <= 0 then
      return false
    else
      return true
    end
  end
  return false
end

class.checkShopValid = checkShopValid

local function getRefreshShopTimes(self, id)
  local data = self:getShopData(id)
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

class.getRefreshShopTimes = getRefreshShopTimes

local function getShopRefreshCost(self, id)
  local t = self:getRefreshShopTimes(id) + 1
  local gradientInfo = self:getTblContent(id)
  local gprow = ed.getDataTable("GradientPrice")[t]
  return gprow[string.format("Shop Refresh Price %d", gradientInfo["Refresh Gradient Price ID"])]
end

class.getShopRefreshCost = getShopRefreshCost

local function getLastTriggerShopid(self)
  return self.lastTriggerShopid
end

class.getLastTriggerShopid = getLastTriggerShopid

local function getTblContent(self, id, level)
  local level = level or 1
  return ed.getDataTable("Shop")[id][level]
end

class.getTblContent = getTblContent
local class = newclass("g")
ed.ui.market = class
setfenv(1, class)
preTalkKey = nil
preTalkID = nil

function getTalkContent(id, key)
  ed.initSeed()
  local bi, ei = 1, 6
  if ed.isElementInTable(id, {2, 3}) and ed.player:checkShopTimeType(id) == "refresh" then
    bi, ei = 7, 12
  end
  if id == "starshop" then
    id = 6
  end
  local talkInfo = ed.getDataTable("MerchantTalk")
  if not talkInfo[id] then
    return
  end
  local talks = {}
  for i = bi, ei do
    local str = talkInfo[id][key]["Talk " .. i]
    if str ~= nil then
      table.insert(talks, str)
    end
  end
  if EDFLAGANDROID and EDSDKType == 104 then
    table.insert(talks, T("\229\156\168\230\156\172\229\186\151\232\180\173\231\137\169\229\143\151360\229\174\137\229\133\168\229\141\171\229\163\171\228\191\157\230\138\164\239\188\140\232\175\183\230\148\190\229\191\131\230\182\136\232\180\185\227\128\130"))
  end
  local talk
  if 0 < #talks then
    math.random(#talks)
    local id = math.random(#talks)
    if key == preTalkKey and id == preTalkID and 1 < #talks then
      if id == #talks and 1 < #talks then
        id = id - 1
      else
        id = id + 1
      end
    end
    talk = talks[id]
    preTalkKey = key
    preTalkID = id
  end
  return talk
end
