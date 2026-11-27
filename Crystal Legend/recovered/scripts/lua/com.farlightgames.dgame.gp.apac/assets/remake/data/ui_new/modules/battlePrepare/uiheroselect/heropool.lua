module("ed.battleprepare", package.seeall)
HeroPool = {}
HeroPool.__index = HeroPool

function HeroPool:create(uiview, param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview, param)
  return obj
end

function HeroPool:release()
  self.ui = {}
  self:clearAll()
  self.dragList = nil
  self.mainLayer:removeFromParentAndCleanup(true)
  self.mainLayer = nil
  self.heroItems = {}
end

function HeroPool:initConfig()
  local config = config:getHeroPoolUiInfo(self.type)
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

function HeroPool:init(uiview, param)
  self.param = param
  self.uiview = uiview
  self.type = param.type or "normal"
  local controller = uiview:getController()
  self.controller = controller
  self.listData = controller:getModel():getListData()
  if param.sortHeroPoolHandler then
    param.sortHeroPoolHandler(self.listData)
  end
  self.forbidList = controller:getModel():getForbidList()
  self.firstList = controller:getModel():getFirstList()
  self.dispatchList = controller:getModel():getDispatchList()
  self.dispatchHash = controller:getModel():getDispatchHash()
  self.dispatchNum = controller:getModel():getDispatchNum()
  self.dispatchMercenaryHero = controller:getModel():getDispatchMercenaryHero()
  self.ui = {}
  self.heroItems = {}
  self.isEnableClick = false
  self.mainLayer = CCLayer:create()
  self:initConfig()
  self:createDragList()
  self.titleContext = param.title
  self.dispatchTitleText = param.dispatchTitle
  self.titleHeight = 0
  self.dispatchTitleHeight = 0
  self:initTitle()
  self.asyncCreate = ListenTimer(Timer:Always(0.01), self:asyncCreateList())
  self:createDispatchMercenaryHero()
  self:registerWaitEvent()
end

function HeroPool:onEnter()
end

function HeroPool:setSortHandler(handler)
  self.sortHandler = handler
end

function HeroPool:getDispatchHash()
  local hash = {}
  for _, id in ipairs(self.dispatchList) do
    hash[id] = true
  end
  return hash
end

function HeroPool:initTitle()
  if self.titleContext then
    local label, height = manager:createLabel(self.titleContext)
    label:setPosition(self.titlePos)
    self.dragList:addItem(label)
    self.titleLable = label
    self.titleHeight = height
  end
  if self.dispatchTitleText then
    local label, height = manager:createLabel(self.dispatchTitleText)
    label:setPosition(self.titlePos)
    self.dragList:addItem(label)
    self.dispatchTitleLabel = label
    self.dispatchTitleHeight = height
  end
end

function HeroPool:createDispatchMercenaryHero()
  if self.getDispatchMercenaryHero then
  end
end

function HeroPool:registerWaitEvent()
  WaitEvent("addHeroWithId", function(hid)
    self:addHero(hid)
  end)
  WaitEvent("removeHeroWithId", function(hid)
    self:removeHero(hid)
  end)
  WaitEvent("clearAllSelectHero", function()
    for hid, node in pairs(self.heroItems) do
      local hero = node.hero
      hero:deleteSelectTag()
    end
  end)
end

function HeroPool:addHero(hid)
  local hero = self.heroItems[hid].hero
  hero:showSelectTag()
end

function HeroPool:removeHero(hid)
  local hero = self.heroItems[hid].hero
  hero:deleteSelectTag()
end

function HeroPool:changeHeroTeam(hid, team)
  local hero = self.heroItems[hid].hero
  hero:addTeamInfo({team_index = team})
end

function HeroPool:RemoveTeamInfo(hid)
  local hero = self.heroItems[hid].hero
  hero:RemoveTeamInfo()
end

function HeroPool:getView()
  return self.mainLayer
end

function HeroPool:clearAll()
  self.listData = {}
  self.dragList:clearList()
end

function HeroPool:getHeroIconPos(hid)
  local icon = self.heroItems[hid].hero.icon
  local pos = self.dragList:getItemWorldPos(ccp(icon:getPosition()))
  return pos
end

function HeroPool:createDragList()
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
  self.dragList = ed.draglist.create(info)
end

function HeroPool:canClick()
  return self.isEnableClick
end

function HeroPool:enableClick(bEnable)
  self.isEnableClick = bEnable
end

function HeroPool:doClickInList()
  local function handler(x, y, hid)
    local icon = self.heroItems[hid].hero.icon
    
    icon:setScale(1)
    if self:canClick() then
      self.uiview:clickHero(hid)
    end
  end
  
  return handler
end

function HeroPool:doPressInList()
  local function handler(x, y)
    if not self:isVisible() then
      return
    end
    for k, item in pairs(self.heroItems) do
      local hero = item.hero
      if hero.icon:isVisible() and ed.containsPoint(hero.icon, x, y) then
        hero.icon:setScale(0.95)
        return item.data._tid
      end
    end
  end
  
  return handler
end

function HeroPool:cancelClickInList()
  local function handler(x, y, k)
    self.heroItems[k].hero.icon:setScale(1)
  end
end

function HeroPool:cancelPressInList()
  local function handler(x, y, k)
    self.heroItems[k].hero.icon:setScale(1)
  end
  
  return handler
end

function HeroPool:asyncCreateList()
  local index = 1
  local step = "loadHero"
  local result
  self:changeChannel(allChannel or "all")
  
  local function handler(dt)
    xpcall(function()
      if step == "loadHero" then
        for i = index, index + 10 do
          step = self:loadHero(i) or "loadHero"
        end
        index = index + 11
      end
      if step == "loadHeroEnd" then
        index = 1
        step = "loadTeam"
      end
      if step == "loadTeam" then
        step = "loadTeamEnd"
        index = index + 1
      end
      if step == "loadTeamEnd" then
        EnqueueDelayProcess(function()
          SendEvent("onEnter")
          if self.asyncCreate then
            CloseTimer(self.asyncCreate.Name)
            self.asyncCreate = nil
          end
          self.loadEnd = true
        end)
      end
      self:refreshList(self.listData[allChannel or "all"])
      self.curClid = "all"
    end, EDDebug)
  end
  
  return handler
end

function HeroPool:isLoadEnd()
  return self.loadEnd
end

function HeroPool:changeChannel(clid)
  self.curClid = clid
  self:createList(self.listData[clid])
end

function HeroPool:changeTab(tab)
  self.curTab = tab
  if tab == "team" then
    self.listData = self.controller:getModel():getListData()
    self:refreshList(self.listData[self.curClid])
    if self.titleLable then
      ed.setString(self.titleLable, self.titleContext)
    end
  elseif tab == "recommend" then
    local recommendListData = self.controller:getModel():getRecommendListData()
    if recommendListData then
      self:createRecommendHeroIcon(recommendListData)
      self.listData = recommendListData
      self:refreshList(self.listData[self.curClid])
    end
    if self.titleLable then
      ed.setString(self.titleLable, "\232\175\165\229\133\179\229\141\161\229\184\184\232\131\156\232\139\177\233\155\132")
    end
  end
end

function HeroPool:createRecommendHeroIcon(recommendListData)
  for _, hero in ipairs(recommendListData.all) do
    if not self.heroItems[hero._tid] then
      self:createHeroIcon(hero)
    end
  end
end

function HeroPool:doRecommendReply()
  self:changeTab(self.curTab)
end

function HeroPool:setVisible(visible)
  self.mainLayer:setVisible(visible)
end

function HeroPool:isVisible()
  return self.mainLayer:isVisible()
end

function HeroPool:loadHero(index)
  if index < 1 then
    return
  end
  if index > #self.listData.all then
    return "loadHeroEnd"
  end
  local data = self.listData.all[index]
  local state = ed.isElementInTable(data._tid, self.firstList) and "first" or "Idle"
  state = ed.isElementInTable(data._tid, self.forbidList) and "banned" or state
  local hero = ed.readhero.createIconByID(data._tid, {
    state = state,
    mealMode = self.type,
    hmMode = self.type
  })
  self:setHeroItemData(hero, data)
  hero:hide()
  self.dragList:addItem(hero.icon)
  self.dragList:setFrameRect(hero.icon, hero.icon:getTextureRect())
  self.dragList:setParentClipNode(hero.icon, self.dragList.listLayer)
end

function HeroPool:createHeroIcon(data)
  local state = ed.isElementInTable(data._tid, self.firstList) and "first" or "Idle"
  state = ed.isElementInTable(data._tid, self.forbidList) and "banned" or state
  local hero = ed.readhero.createIconByID(data._tid, {awake = true, state = state})
  if not ed.player.heroes[data._tid] then
    hero:addStateInfo("own")
  end
  self:setHeroItemData(hero, data)
  hero:hide()
  self.dragList:addItem(hero.icon)
  self.dragList:setFrameRect(hero.icon, hero.icon:getTextureRect())
  self.dragList:setParentClipNode(hero.icon, self.dragList.listLayer)
end

function HeroPool:setHeroItemData(hero, data)
  self.heroItems[data._tid] = {hero = hero, data = data}
end

function HeroPool:createList(list)
  self.dragList.listLayer:setVisible(true)
  self.dragList:showScrollbar()
  self:refreshList(list)
end

function HeroPool:refreshList(list)
  for k, v in pairs(self.heroItems) do
    v.hero:hide()
  end
  local dItems = self:getDispatchItems()
  local dLen = #dItems
  if self.dispatchTitleLabel then
    if dLen == 0 then
      self.dispatchTitleLabel:setVisible(false)
      self.dispatchTitleHeight = 0
    else
      self.dispatchTitleLabel:setVisible(true)
      self.dispatchTitleHeight = self.dispatchTitleLabel:getContentSize().height
    end
  end
  for i, iteam in ipairs(dItems) do
    iteam.hero:show()
    local offset = self.dispatchTitleHeight + 15
    iteam.hero.icon:setPosition(ccp(self.hero_icon_ori_x + self.hero_icon_gap_x * ((i - 1) % 5), self.hero_icon_ori_y - offset - self.hero_icon_gap_y * math.floor((i - 1) / 5)))
  end
  if self.titleLable then
    local labelPosy = self.titlePos.y - (math.ceil(dLen / self.colNum) * self.itemHeight + self.dispatchTitleHeight)
    self.titleLable:setPositionY(labelPosy)
  end
  local dispatchOver = self.dispatchNum ~= 0 and dLen >= self.dispatchNum
  local items = self:getItems(list)
  for i, iteam in ipairs(items) do
    iteam.hero:show()
    if dispatchOver then
      iteam.hero:addShade()
    end
    local offset = self.titleHeight + self.dispatchTitleHeight + math.ceil(dLen / self.colNum) * self.itemHeight + 15
    iteam.hero.icon:setPosition(ccp(self.hero_icon_ori_x + self.hero_icon_gap_x * ((i - 1) % 5), self.hero_icon_ori_y - offset - self.hero_icon_gap_y * math.floor((i - 1) / 5)))
  end
  local row = math.ceil(#items / self.colNum) + math.ceil(dLen / self.colNum)
  self.dragList:initListHeight(row * self.itemHeight + self.titleHeight + self.dispatchTitleHeight + 5)
end

function HeroPool:getDispatchItems()
  local dIteams = {}
  for _, id in ipairs(self.dispatchList) do
    local iteam = self.heroItems[id]
    dIteams[#dIteams + 1] = iteam
  end
  return dIteams
end

function HeroPool:getItems(list)
  local items = {}
  for i = 1, #list do
    local id = list[i]._tid
    local item = self.heroItems[id]
    if item and not self.dispatchHash[id] then
      items[#items + 1] = item
    end
  end
  return items
end
