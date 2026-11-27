module("ed.battleprepare", package.seeall)
mercenary = {}
mercenary.__index = mercenary

function mercenary.create(uiview, param, data)
  local object = {}
  setmetatable(object, mercenary)
  object:initData(uiview, param, data)
  object:initAppearence()
  object:registerEventHandler()
  return object
end

function mercenary:initData(uiview, param, data)
  self.uiview = uiview
  self.param = param
  self.heroes = data
  self.type = param.type or "normal"
  self:initConfig()
  self:initListData()
end

function mercenary:initListData()
  self.listData = manager:classfiyMercenHeroes(self.heroes)
end

function mercenary:initConfig()
  local config = config:getMercenaryUiInfo(self.type)
  self.titlePos = config.titlePos
  self.colNum = config.colNum
  self.itemHeight = config.itemHeight
  self.hero_icon_ori_x = config.hero_icon_ori_x
  self.hero_icon_ori_y = config.hero_icon_ori_y
  self.hero_icon_gap_x = config.hero_icon_gap_x
  self.hero_icon_gap_y = config.hero_icon_gap_y
  self.cliprect = config.cliprect
  self.barpos = config.barpos
  self.barLen = config.barLen or 270
end

function mercenary:initAppearence()
  self.mainLayer = CCLayer:create()
  self:createDragList()
  self:initTitle()
  self:createHeads()
  self:changeChannel("all")
end

function mercenary:initTitle()
  local text = T("\228\189\163\229\133\181")
  self.titleHeight = 35
  local label, height = manager:createLabel(text)
  label:setPosition(self.titlePos)
  self.draglist:addItem(label)
  self.titleLable = label
  self.titleHeight = height
end

function mercenary:createHeads()
  self.heroItems = {}
  for _, hero in ipairs(self.listData.all) do
    local head = self:createHead(hero)
    self.draglist.listLayer:addChild(head.icon)
    local key = self:getHashKey(hero)
    self.heroItems[key] = head
  end
end

function mercenary:getHashKey(hero)
  local mercenaryInfo = hero:getMercenaryData()
  local uid = mercenaryInfo._uid
  local heroid = hero._tid
  return uid .. "head" .. heroid
end

function mercenary:createHead(hero)
  local mercenaryData = hero:getMercenaryData()
  local heroIcon = ed.readhero.createIconByHero(hero)
  return heroIcon
end

function mercenary:createDragList()
  local info = {
    cliprect = self.cliprect,
    container = self.mainLayer,
    zorder = 20,
    bar = {
      bglen = self.barLen,
      bgpos = self.barpos
    },
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.draglist = ed.draglist.create(info)
end

function mercenary:doClickInList()
  local function handler(x, y, key)
    local icon = self.heroItems[key].icon
    
    icon:setScale(1)
    if ed.containsPoint(icon, x, y) then
      self.uiview:clickMercenary(key)
    end
  end
  
  return handler
end

function mercenary:doPressInList()
  local function handler(x, y)
    if not self:isVisible() then
      return
    end
    for k, head in pairs(self.heroItems) do
      if head.icon:isVisible() and ed.containsPoint(head.icon, x, y) then
        head.icon:setScale(0.95)
        return k
      end
    end
  end
  
  return handler
end

function mercenary:cancelClickInList()
  local function handler(x, y, key)
    self.heroItems[key].icon:setScale(1)
  end
end

function mercenary:cancelPressInList()
  local function handler(x, y, key)
    self.heroItems[key].icon:setScale(1)
  end
  
  return handler
end

function mercenary:changeChannel(clid)
  self.curClid = clid
  self:createList(self.listData[clid])
end

function mercenary:createList(list)
  self.draglist.listLayer:setVisible(true)
  self.draglist:showScrollbar()
  self:refreshList(list)
end

function mercenary:refreshList(list)
  for k, head in pairs(self.heroItems) do
    head:hide()
  end
  if self.titleLable then
    local labelPosy = self.titlePos.y
    self.titleLable:setPositionY(labelPosy)
  end
  local items = self:getItems(list)
  for i, iteam in ipairs(items) do
    iteam:show()
    local offset = self.titleHeight + 40
    iteam.icon:setPosition(ccp(self.hero_icon_ori_x + self.hero_icon_gap_x * ((i - 1) % self.colNum), self.hero_icon_ori_y - offset - self.hero_icon_gap_y * math.floor((i - 1) / self.colNum)))
  end
  local row = math.ceil(#items / self.colNum)
  print("refreshList--->", row)
  self.draglist:initListHeight(row * self.itemHeight + self.titleHeight + 5)
end

function mercenary:getItems(list)
  local items = {}
  for _, hero in ipairs(list) do
    local key = self:getHashKey(hero)
    local item = self.heroItems[key]
    if item then
      items[#items + 1] = item
    end
  end
  return items
end

function mercenary:setVisible(value)
  self.mainLayer:setVisible(value)
end

function mercenary:isVisible()
  return self.mainLayer:isVisible()
end

function mercenary:getHeroIconPos(hid)
  local icon = self.heroItems[hid].icon
  local pos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
  return pos
end

function mercenary:registerEventHandler()
  WaitEvent("addMercenaryWithId", function(hid)
    if self:isVisible() then
      self:addMercenary(hid)
    end
  end)
  WaitEvent("removeMercenaryWithId", function(hid)
    if self:isVisible() then
      self:removeMercenary(hid)
    end
  end)
end

function mercenary:addMercenary(hid)
  local hero = self.heroItems[hid]
  hero:showSelectTag()
end

function mercenary:removeMercenary(hid)
  local hero = self.heroItems[hid]
  hero:deleteSelectTag()
end
