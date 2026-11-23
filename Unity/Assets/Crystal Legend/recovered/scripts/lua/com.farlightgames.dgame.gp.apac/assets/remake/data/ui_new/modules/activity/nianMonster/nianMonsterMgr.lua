local class = {}
ed.nianMonsterMgr = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self.selectItemId = nil
  self.nianMonsterActId = 0
  self.itemInfo = {}
  self.redPointMgr = ed.redPointMgr.getInstance()
  self:addEnventListen()
end

function class:handleNotify(data)
  local curSeasonId = data._cur_season_id
  local hasNewGoods = data._has_new_goods
  self.redPointMgr:setNodeValue("nian_monster_has_new_goods", hasNewGoods)
  self.nianMonsterActId = curSeasonId
  self:initSelectItem()
  FireEvent("RefreshRightTopButtons")
end

function class:handleOpenPanel(data)
  if not data then
    return
  end
  self.itemInfo = {}
  for index, item in ipairs(data._item_infos or {}) do
    self.itemInfo[item._item_id] = ed.copyProto(item)
  end
  FireEvent("nianMonsterOpenPanel")
end

function class:handleBuyItem(data)
  if not data then
    return
  end
  local boughtItem = data._bought_item
  ed.player:addRewards(boughtItem)
  ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
end

function class:getItemInfo(itemId)
  return self.itemInfo[itemId] or {}
end

function class:getGoodsGroupId()
  local nianMonsterActId = self:getNianMonsterActId()
  return ed.getDataTable("NianMonster")[nianMonsterActId]["Goods Group"]
end

function class:getHeatGroupId()
  local nianMonsterActId = self:getNianMonsterActId()
  return ed.getDataTable("NianMonster")[nianMonsterActId]["Heat Group"]
end

function class:getNianMonsterActId()
  return self.nianMonsterActId
end

function class:getEchoId(goodsGroupId, itemId)
  local goodsList = ed.getDataTable("NianMonsterGoods")[goodsGroupId]
  if not goodsList then
    return
  end
  local itemCfg = goodsList[itemId]
  if itemCfg then
    return itemCfg["Echo ID"]
  end
end

function class:setSelectItem(itemId)
  self.selectItemId = itemId
  self:saveSelectItem(itemId)
  FireEvent("nianMonsterSelectItem")
end

function class:getSelectItem()
  return self.selectItemId
end

function class:saveSelectItem(itemId)
  itemId = itemId or 0
  local nianMonsterActId = self:getNianMonsterActId()
  local key = ed.getRoleKey(string.format("LOCAL_FIREWORK_%s", nianMonsterActId))
  ed.storage.setValue(key, itemId)
end

function class:initSelectItem()
  if self.selectItemId then
    return
  end
  local nianMonsterActId = self:getNianMonsterActId()
  if not nianMonsterActId then
    return
  end
  local key = ed.getRoleKey(string.format("LOCAL_FIREWORK_%s", nianMonsterActId))
  local itemId = ed.storage.getInt(key)
  local goodsGroupId = self:getGoodsGroupId()
  local goodsItemList = ed.getDataTable("NianMonsterGoods")[goodsGroupId]
  if not goodsItemList then
    return
  end
  if itemId == 0 then
    return
  end
  if not goodsItemList[itemId] then
    return
  end
  local itemAmount = ed.player:getEquipAmount(itemId)
  if not itemAmount or itemAmount <= 0 then
    return
  end
  self.selectItemId = itemId
end

function class:getNianMonsterIsOpen()
  local nianMonsterActId = self:getNianMonsterActId()
  local nianMonsterActInfo = ed.getDataTable("NianMonster")[nianMonsterActId]
  if nianMonsterActInfo then
    local startTime = ed.dateStringToTime(nianMonsterActInfo["Start Time"])
    local endTime = ed.dateStringToTime(nianMonsterActInfo["End Time"])
    local showTime = ed.dateStringToTime(nianMonsterActInfo["Show Time"])
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and showTime >= serverTime then
      return true
    end
  end
  return false
end

function class:getActivityUIConfig()
  local nianMonsterActId = self:getNianMonsterActId()
  return ed.nianMonsterDefine.getActivityUIConfigByActId(nianMonsterActId)
end

function class:onResourceNumChange(resType, id)
  if id and id == self.selectItemId then
    local itemAmount = ed.player:getEquipAmount(id)
    if not itemAmount or itemAmount <= 0 then
      self:setSelectItem(nil)
    end
  end
end

function class:addEnventListen()
  ListenEvent("ResourceNumChange", function(resType, id)
    self:onResourceNumChange(resType, id)
  end)
end
