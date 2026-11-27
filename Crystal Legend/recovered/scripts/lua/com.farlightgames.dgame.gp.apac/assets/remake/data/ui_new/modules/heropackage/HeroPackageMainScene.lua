local lsr = ed.ui.heropackagelsr.create()
local base = ed.ui.commonscene
local HeroPackage = newclass(base.mt)
ed.ui.Heropackage = HeroPackage
local minScale = {
  cn = 1,
  ja = 0.672,
  tw = 1,
  en = 1,
  ko = 1,
  es = 0.65
}
local ESortPiorityType = {
  Default = 0,
  Shard = 1,
  Astrolabe = 2,
  Legend = 3
}

function HeroPackage:changeTab()
  self:refreshButtonDraglist()
  self:refreshMainDraglist()
end

function HeroPackage:changeSort(data)
  self.sortPiorityType = data.type
  ed.setTexture(self.ui.btn_sort, data.selectedSortRes, true)
  local btnSize = self.ui.btn_sort:getContentSize()
  if nil ~= self.ui.img_btn_sort_selected then
    self.ui.img_btn_sort_selected:setPosition(btnSize.width * 0.5, btnSize.height * 0.5)
  end
  self.ui.btn_sortlabel:setPosition(btnSize.width * 0.5, btnSize.height * 0.5)
  ed.setLabelColor(self.ui.btn_sortlabel, data.selectedSortNameColor or data.nameColor)
  ed.setLabelStroke(self.ui.btn_sortlabel, data.selectedSortNameStrokeColor or data.nameStrokeColor, 1)
  ed.setLabelString(self.ui.btn_sortlabel, data.selectedSortBtnName or data.nameStr, 1)
  self:refreshMainDraglist()
end

function HeroPackage:getBtnIndex(type)
  for i, v in ipairs(self.btnList) do
    if v.type == type then
      return i
    end
  end
  return 1
end

function HeroPackage:initClassifyBtnList()
  self.btnList = {
    {
      type = "all",
      btnName = T("\229\133\168\233\131\168"),
      handler = function()
        self.tabIndex = self:getBtnIndex("all")
        self:changeTab()
      end,
      uiName = "btn_all"
    },
    {
      type = "front",
      btnName = T("\229\137\141\230\142\146"),
      handler = function()
        self.tabIndex = self:getBtnIndex("front")
        self:changeTab()
      end,
      uiName = "btn_front"
    },
    {
      type = "middle",
      btnName = T("\228\184\173\230\142\146"),
      handler = function()
        self.tabIndex = self:getBtnIndex("middle")
        self:changeTab()
      end,
      uiName = "btn_middle"
    },
    {
      type = "back",
      btnName = T("\229\144\142\230\142\146"),
      handler = function()
        self.tabIndex = self:getBtnIndex("back")
        self:changeTab()
      end,
      uiName = "btn_back"
    },
    {
      type = "STR",
      btnName = T("\229\138\155\233\135\143"),
      handler = function()
        self.tabIndex = self:getBtnIndex("STR")
        self:changeTab()
      end,
      uiName = "btn_STR"
    },
    {
      type = "INT",
      btnName = T("\230\153\186\229\138\155"),
      handler = function()
        self.tabIndex = self:getBtnIndex("INT")
        self:changeTab()
      end,
      uiName = "btn_INT"
    },
    {
      type = "AGI",
      btnName = T("\230\149\143\230\141\183"),
      handler = function()
        self.tabIndex = self:getBtnIndex("AGI")
        self:changeTab()
      end,
      uiName = "btn_AGI"
    }
  }
  self.sortBtnList = {}
  if ed.playerlimit.checkAreaUnlock("Shard") then
    table.insert(self.sortBtnList, {
      type = ESortPiorityType.Shard,
      btnRes = "UI/alpha/1080P/herolist/bg_order_awaken.png",
      nameStr = T("\232\167\137\233\134\146"),
      nameColor = ed.toccc3(15437055),
      nameStrokeColor = ed.toccc3(2761774),
      selectedSortRes = "UI/alpha/1080P/herolist/bg_order_awaken_clicked.png"
    })
  end
  local playerLevel = ed.player:getLevel() or 0
  local shardCfg = ed.heroDetailManager.AstrolabeOpenConfig
  if playerLevel >= shardCfg.level then
    table.insert(self.sortBtnList, {
      type = ESortPiorityType.Astrolabe,
      btnRes = "UI/alpha/1080P/herolist/bg_order_astrolabe.png",
      nameStr = T("\230\152\159\231\155\152"),
      nameColor = ed.toccc3(10483199),
      nameStrokeColor = ed.toccc3(2040137),
      selectedSortRes = "UI/alpha/1080P/herolist/bg_order_astrolabe_clicked.png"
    })
  end
  local unlockConditions = ed.getDataTable("LegendEquipForgeParam")["Unlock Conditions"]
  local unlockLevel = unlockConditions["Param Content 1"]
  if playerLevel >= unlockLevel then
    table.insert(self.sortBtnList, {
      type = ESortPiorityType.Legend,
      btnRes = "UI/alpha/1080P/herolist/bg_order_legendary.png",
      nameStr = T("\228\188\160\229\165\135"),
      nameColor = ed.toccc3(16767838),
      nameStrokeColor = ed.toccc3(4007456),
      selectedSortRes = "UI/alpha/1080P/herolist/bg_order_legendary_clicked.png"
    })
  end
  if #self.sortBtnList > 0 and not ed.isAreaOverSea() then
    table.insert(self.sortBtnList, 1, {
      type = ESortPiorityType.Default,
      btnRes = "UI/alpha/1080P/herolist/bg_order_default.png",
      nameStr = T("\233\135\141\231\189\174"),
      nameColor = ed.toccc3(11577498),
      nameStrokeColor = ed.toccc3(5321499),
      selectedSortBtnName = T("\230\142\146\229\186\143"),
      selectedSortRes = "UI/alpha/1080P/herolist/bg_order_initial.png",
      selectedSortNameColor = ed.toccc3(16776423),
      selectedSortNameStrokeColor = ed.toccc3(0)
    })
    table.insert(self.btnList, 1, {
      type = "sort",
      btnName = T("\230\142\146\229\186\143"),
      handler = function()
        if self.ui.sortSelectionBg and self.ui.sortSelectionBg:isVisible() then
          self:hideSortToast()
        else
          self:showSortToast()
        end
      end,
      uiName = "btn_sort"
    })
  end
end

function HeroPackage:getHeroList()
  local all, front, middle, back = ed.readhero.classify("all", "position", nil, nil, true)
  local a, STR, AGI, INT = ed.readhero.classify("all", "type", nil, nil, true)
  local collect = {}
  for k, v in ipairs(ed.player:getCollectList()) do
    table.insert(collect, ed.player.heroes[v])
  end
  self.heroList = {
    all = all,
    front = front,
    middle = middle,
    back = back,
    STR = STR,
    AGI = AGI,
    INT = INT,
    collect = collect
  }
end

function HeroPackage:initData()
  self.sortPiorityType = ESortPiorityType.Default
  self:initClassifyBtnList()
  self.tabIndex = self:getBtnIndex("all")
end

function HeroPackage:createButtonDraglist()
  self.btnDraglist = ed.UITool.createDraglist(self.ui.layer_btn, {priority = -131})
end

function HeroPackage:doDelCollectReply(info)
  ed.showToast(T("\228\189\160\229\143\150\230\182\136\231\189\174\233\161\182\228\186\134\232\175\165\232\139\177\233\155\132\239\188\129"))
  ed.player:delCollect(info._heroids or {})
end

function HeroPackage:doAddCollectReply(info)
  ed.showToast(T("\228\189\160\231\189\174\233\161\182\228\186\134\232\175\165\232\139\177\233\155\132\239\188\129"))
  ed.player:addCollect(info._heroids or {})
end

function HeroPackage:sendAddFavorite(heroids)
  local msg = ed.upmsg.herohot()
  msg._fav_add = ed.upmsg.hh_fav_add()
  msg._fav_add._heroids = heroids
  ed.send(msg, "herohot")
end

function HeroPackage:sendDelFavorite(heroids)
  local msg = ed.upmsg.herohot()
  msg._fav_del = ed.upmsg.hh_fav_add()
  msg._fav_del._heroids = heroids
  ed.send(msg, "herohot")
end

function HeroPackage:doSummonReply(tid)
  local function handler(result)
    if not result then
      lsr:report("summonFailed")
    else
      lsr:report("summonSuccess")
      if tolua.isnull(self.mainLayer) then
        return
      end
      self:refreshMainDraglist()
      ed.ui.SummonRewardCardWindow.create({
        rewards = {
          {
            id = tid,
            amount = 1,
            type = "hero"
          }
        },
        noRewards = true
      }):popWindow()
    end
  end
  
  return handler
end

function HeroPackage:doSummon(tid)
  local cost = ed.readhero.getSummonCost(tid)
  if cost > ed.player._money then
    ed.showHandyDialog("useMidas")
    return
  end
  ed.netdata.evolve = {
    cost = cost,
    id = ed.readhero.getStoneid(tid),
    amount = ed.readhero.getStoneNeed(tid),
    hid = tid
  }
  ed.netreply.evolve = self:doSummonReply(tid)
  local msg = ed.upmsg.hero_evolve()
  msg._heroid = tid
  ed.send(msg, "hero_evolve")
end

function HeroPackage:doClickInList()
  local function handler(cell, x, y)
    if self.rightBottomButtonOpened then
      return
    end
    if not cell or not cell.data then
      return
    end
    local v = cell.data.ui
    local bg = v.bg
    local collect = v.bg_collect
    local openShard = ed.containsPoint(v.shardEquipBg, x, y)
    local openLegendEquip = false
    if ed.containsPoint(collect, x, y) then
      local hero = cell.data.data
      local isCollect = v.icon_collect:isVisible()
      self.selectUI = v
      if isCollect then
        self:sendDelFavorite({
          hero._tid
        })
      else
        self:sendAddFavorite({
          hero._tid
        })
      end
    elseif ed.containsPoint(bg, x, y) then
      local hero = cell.data.data
      local tid = hero._tid
      if ed.player.heroes[tid] then
        local list = {}
        local listIndex = 1
        local tempIndex = 0
        local herotype = self.btnList[self.tabIndex].type
        local herolist = self.sortedHeroList
        for k, hero in ipairs(herolist) do
          if ed.player.heroes[hero._tid] then
            table.insert(list, hero)
            tempIndex = tempIndex + 1
          end
          if hero._tid == tid then
            listIndex = tempIndex
          end
        end
        
        local function destroyHandler()
          local function handler(index)
            if ed.heroDetailManager:checkUnlockAstrolabe(tid) then
              if ed.heroDetailManager:canAstrolabeUnlock(tid) then
                FireEvent("RefreshHeroRed", tid)
              end
            else
              ed.heroDetailManager:isShowPageAstrolabe(tid)
            end
          end
          
          return handler
        end
        
        self.lastPosX, self.lastPosY = self.heroTbView:getListPos()
        local scene = ed.ui.heroDetailScene.create({
          hero = hero,
          index = listIndex,
          list = list,
          openMode = "card",
          isShowUpgradeButton = true,
          destroyHandler = destroyHandler(),
          tabIndex = openShard and 4 or 1,
          isOpenLegendEquip = openLegendEquip
        })
        ed.pushScene(scene)
        if openShard then
          scene:refreshBtnState(1)
          scene:refreshBtnState(4)
        end
      else
        local eno = ed.readhero.checkStoneEnough(tid)
        if eno then
          local cost = ed.readhero.getSummonCost(tid)
          local info = {
            autoText = string.format(T("\229\143\172\229\148\164\232\139\177\233\155\132\233\156\128\232\166\129\232\138\177\232\180\185<lable color=headlineOrange>%d</lable>\233\135\145\229\184\129\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"), cost),
            rightHandler = function()
              self:doSummon(tid)
            end
          }
          ed.showConfirmDialog(info)
        else
          local stoneId = ed.readhero.getStoneid(tid)
          ed.ui.PackageSourceWin.create({id = stoneId})
        end
      end
    end
  end
  
  return handler
end

function HeroPackage:createButton(index)
  local btnScale = #self.btnList > 7 and 0.9 or 1
  local spaceY = #self.btnList > 7 and 3 or 5
  local contentSize = self.ui.layer_btn:getContentSize()
  local uiName = self.btnList[index].uiName
  local btnName = self.btnList[index].btnName
  local btn = ed.createSprite("UI/alpha/1080P/herolist/tab_unselected.png")
  local btnSize = btn:getContentSize()
  btn:setScale(btnScale)
  btn:setPosition(contentSize.width / 2 - 2, contentSize.height - 3 - (btnSize.height * btnScale + spaceY) * (index - 0.5) + spaceY * 0.5)
  local labelBtnName = ed.createLabelTTF(btnName, 20)
  local btnPress = ed.createSprite("UI/alpha/1080P/herolist/tab_selected.png")
  btnPress:setPosition(btnSize.width * 0.5, btnSize.height * 0.5 - 4)
  labelBtnName:setPosition(btnSize.width * 0.5, btnSize.height * 0.5)
  labelBtnName:setColor(ccc3(176, 168, 154))
  ed.setLabelStroke(labelBtnName, ccc3(81, 51, 27), 2)
  btn:addChild(btnPress)
  btn:addChild(labelBtnName)
  self.ui[uiName .. "label"] = labelBtnName
  self.ui[uiName] = btn
  self.ui[uiName .. "Press"] = btnPress
  return btn
end

function HeroPackage:sortHeroList(herolist)
  local heroList = {}
  local unHeroList = {}
  for k, v in ipairs(herolist) do
    local tid = v._tid
    local stoneAmount = ed.readhero.getStoneAmount(tid)
    local stoneNeed = ed.readhero.getStoneNeed(tid) or 9999999
    if stoneAmount >= stoneNeed then
      if ed.player.heroes[tid] then
        v.Order = 1
      else
        v.Order = 2
      end
      table.insert(heroList, v)
    else
      v.Order = 0
      if ed.player.heroes[tid] then
        table.insert(heroList, v)
      else
        table.insert(unHeroList, v)
      end
    end
    v.IsCollected = ed.player:isHeroCollect(tid) and 1 or 0
    v.SecondaryOrder = ESortPiorityType.Default
    if self.sortPiorityType == ESortPiorityType.Shard then
      if ed.player.heroes[tid] then
        local shardId = ed.heroDetailManager.shardList[tid] and (ed.heroDetailManager.shardList[tid][1] or 0) or 0
        local tableItem = ed.getDataTable("ShardToHero")[shardId]
        if tableItem then
          local onlineTime = ed.getTimeByYMDHMS(tableItem["Online Time"])
          if onlineTime <= ed.getServerTime() then
            v.SecondaryOrder = ESortPiorityType.Shard
            v.SecondarySortParam = {OnlineTime = onlineTime}
            if v._shard and 0 < v._shard._level then
              v.SecondarySortParam.unlock = 1
            else
              v.SecondarySortParam.unlock = 0
            end
          end
        end
      end
    elseif self.sortPiorityType == ESortPiorityType.Astrolabe then
      if ed.player.heroes[tid] and ed.heroDetailManager:isShowPageAstrolabe(tid, true) then
        v.SecondaryOrder = ESortPiorityType.Astrolabe
        local astrolabeInfo = ed.heroDetailManager.astrolabes[tid]
        if astrolabeInfo and astrolabeInfo._unlock == 1 then
          v.SecondarySortParam = {
            unlock = 1,
            Level = nil == v._astrolabe and 0 or v._astrolabe._level or 0,
            Gs = nil == v._astrolabe and 0 or v._astrolabe._gs or 0
          }
        else
          v.SecondarySortParam = {
            unlock = 0,
            Level = 0,
            Gs = 0
          }
        end
      end
    elseif self.sortPiorityType == ESortPiorityType.Legend then
      if ed.player.heroes[tid] then
        local heroLegendEquip = v._legend_equip or {}
        local legendEquip = heroLegendEquip._equip
        if legendEquip then
          local typeId = legendEquip._type_id
          local isOnly = ed.getDataTable("LegendEquip")[typeId]["Is Only"]
          v.SecondaryOrder = ESortPiorityType.Legend
          v.SecondarySortParam = {
            IsOnly = isOnly and 1 or 0,
            Star = legendEquip._star,
            Rank = legendEquip._rank
          }
        end
      end
    elseif 1 == v.IsCollected then
      v.Order = 999
    end
  end
  for _, hero in ipairs(heroList) do
    if ed.heroDetailManager:canShardUnlock(hero._tid) or ed.heroDetailManager:canAstrolabeUnlock(hero._tid) then
      hero.Order = 1000
    end
  end
  if 0 < #heroList then
    local UnitTable = ed.getDataTable("Unit")
    table.sort(heroList, function(a, b)
      local aTid = a._tid
      local bTid = b._tid
      local aInitStar = UnitTable[aTid]["Initial Stars"]
      local bInitStar = UnitTable[bTid]["Initial Stars"]
      if a.Order == b.Order then
        if a.Order == 2 then
          if aInitStar ~= bInitStar then
            return aInitStar > bInitStar
          end
          return aTid < bTid
        elseif a.SecondaryOrder == b.SecondaryOrder then
          if a.SecondaryOrder == ESortPiorityType.Default then
            if a.IsCollected ~= b.IsCollected then
              return a.IsCollected > b.IsCollected
            end
            if a._level ~= b._level then
              return a._level > b._level
            end
            if a._rank ~= b._rank then
              return a._rank > b._rank
            end
            if a._stars ~= b._stars then
              return a._stars > b._stars
            end
            if aInitStar ~= bInitStar then
              return aInitStar > bInitStar
            end
            if a._gs ~= b._gs then
              return a._gs > b._gs
            end
            return aTid < bTid
          elseif a.SecondaryOrder == ESortPiorityType.Shard then
            local aSortParam = a.SecondarySortParam
            local bSortParam = b.SecondarySortParam
            if aSortParam.unlock ~= bSortParam.unlock then
              return aSortParam.unlock > bSortParam.unlock
            end
            if a.IsCollected ~= b.IsCollected then
              return a.IsCollected > b.IsCollected
            end
            if aSortParam.OnlineTime ~= bSortParam.OnlineTime then
              return aSortParam.OnlineTime > bSortParam.OnlineTime
            end
            return aTid < bTid
          elseif a.SecondaryOrder == ESortPiorityType.Astrolabe then
            local aSortParam = a.SecondarySortParam
            local bSortParam = b.SecondarySortParam
            if aSortParam.unlock ~= bSortParam.unlock then
              return aSortParam.unlock > bSortParam.unlock
            end
            if a.IsCollected ~= b.IsCollected then
              return a.IsCollected > b.IsCollected
            end
            if aSortParam.Level ~= bSortParam.Level then
              return aSortParam.Level > bSortParam.Level
            end
            if aSortParam.Gs ~= bSortParam.Gs then
              return aSortParam.Gs > bSortParam.Gs
            end
            return aTid < bTid
          elseif a.SecondaryOrder == ESortPiorityType.Legend then
            if a.IsCollected ~= b.IsCollected then
              return a.IsCollected > b.IsCollected
            end
            local aSortParam = a.SecondarySortParam
            local bSortParam = b.SecondarySortParam
            if aSortParam.IsOnly ~= bSortParam.IsOnly then
              return aSortParam.IsOnly > bSortParam.IsOnly
            end
            if aSortParam.Star ~= bSortParam.Star then
              return aSortParam.Star > bSortParam.Star
            end
            if aSortParam.Rank ~= bSortParam.Rank then
              return aSortParam.Rank > bSortParam.Rank
            end
            return aTid < bTid
          else
            return aTid < bTid
          end
        else
          return a.SecondaryOrder > b.SecondaryOrder
        end
      else
        return a.Order > b.Order
      end
    end)
  end
  if 0 < #unHeroList then
    local UnitTable = ed.getDataTable("Unit")
    table.sort(unHeroList, function(a, b)
      local aInitStar = UnitTable[a._tid]["Initial Stars"]
      local bInitStar = UnitTable[b._tid]["Initial Stars"]
      if aInitStar == bInitStar then
        return a._tid < b._tid
      else
        return aInitStar > bInitStar
      end
    end)
  end
  return heroList, unHeroList
end

function HeroPackage:refreshMainDraglist()
  self:getHeroList()
  self.uiList = {}
  local bgSize = self.ui.layer_item:getContentSize()
  local cellSize = CCSizeMake(bgSize.width / 2, 125)
  local herotype = self.btnList[self.tabIndex].type
  local herolist = self.heroList[herotype]
  local heroList, unherolist = self:sortHeroList(herolist)
  self.sortedHeroList = heroList
  local data = {}
  for i = 1, #heroList do
    data[i] = heroList[i]
  end
  if #heroList % 2 == 1 then
    data[#data + 1] = {type = "empty"}
  end
  if 0 < #heroList and 0 < #unherolist then
    data[#data + 1] = {type = "sepUi", show = true}
    data[#data + 1] = {type = "sepUi", show = false}
  end
  for i = 1, #unherolist do
    data[#data + 1] = unherolist[i]
  end
  local size = self.ui.layer_item:getContentSize()
  local sepUi = {}
  local delegate = {
    numberOfCells = function()
      return #data
    end,
    cellSizeFromIndex = function(index)
      if data[index].type == "sepUi" then
        return CCSizeMake(bgSize.width / 2, 30)
      else
        return CCSizeMake(bgSize.width / 2, 125)
      end
    end,
    createCell = function(index)
      if data[index].type == "sepUi" then
        local node = CCNode:create()
        node:setVisible(data[index].show)
        local sepContainer = CCNode:create()
        node:addChild(sepContainer)
        node:setContentSize(CCSizeMake(bgSize.width / 2, 30))
        local readnode = ed.readnode.create(sepContainer, sepUi)
        sepContainer:setPosition(ccp(bgSize.width / 4, -46))
        readnode:addNode(ed.uieditor.package_stone_deco)
        return node
      elseif data[index].type == "empty" then
        return CCNode:create()
      else
        local heroItem, ui = self:createHeroItem(data[index])
        heroItem:setContentSize(CCSizeMake(bgSize.width / 2, 125))
        self.uiList[index] = ui
        return heroItem, {
          data = data[index],
          ui = ui
        }
      end
    end,
    doClickIn = self:doClickInList()
  }
  if self.heroTbView then
    self.heroTbView:setDelegate(delegate)
    self.heroTbView:reloadData()
    if self.lastPosX then
      self.heroTbView:setListPos(ccp(self.lastPosX, self.lastPosY))
      self.lastPosX = nil
      self.lastPosY = nil
    end
  else
    local params = {
      delegate = delegate,
      cliprect = CCRectMake(0, 0, size.width, size.height),
      container = self.ui.layer_item,
      offset = {
        cellSize.width / 2 + 2,
        cellSize.height / 2
      },
      touchpriority = -1,
      noshade = true,
      zorder = 10,
      dragMode = 1,
      colNum = 2,
      message = false
    }
    self.heroTbView = ed.UITool.createTableView(params, self)
  end
end

function HeroPackage:createHeroItem(hero)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local tid = hero._tid
  
  local function getPosAndHide(key)
    local node = ui[key]
    local x, y = node:getPosition()
    node:setVisible(false)
    return ccp(x, y)
  end
  
  local amount = ed.readhero.getStoneAmount(tid)
  local need = ed.readhero.getStoneNeed(tid) or 9999999
  local bgSize = self.ui.layer_item:getContentSize()
  if ed.player.heroes[tid] then
    local readnode = ed.readnode.create(container, ui)
    readnode:addNode(ed.uieditor.HeroItem)
    ui.bg:setContentSize(CCSizeMake(bgSize.width / 2 - 2, 122))
    ui.icon_skillup:setVisible(false)
    ui.layer_mid:setPositionX(self.heroItemAdaptConfig.equipParentPosX)
    ed.setLabelStroke(ui.name, ccc3(0, 0, 0), 2)
    ui.Label_32232:limitWidthByScale(30)
    local unit = ed.getDataTable("Unit")
    local tid = hero._tid
    local name = unit[tid]["Display Name"]
    ed.setString(ui.name, name)
    if ed.readhero.canUpgradeHeroWithId(tid) or ed.heroDetailManager:canAstrolabeUnlock(tid) then
      local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
      redLight:setPosition(ccp(15, 103))
      ui.bg:addChild(redLight, 3)
    end
    local head = ed.readhero.createIconByID(tid, {state = "idle"})
    local headIcon = head.icon
    headIcon:setScale(1.2)
    headIcon:setPosition(getPosAndHide("icon"))
    ui.bg:addChild(headIcon, 1)
    ui.icon = headIcon
    if amount >= need then
      head.stars[1]:getParent():setZOrder(10)
      local effect3 = ed.createFcaNode("eff_UI_bag_evolve_bg")
      effect3:setPosition(ccp(35.5, 13.4))
      headIcon:addChild(effect3)
      self:addFca(effect3)
      local effect2
      if ed.isAreaZh() then
        effect2 = ed.createFcaNode("eff_UI_bag_evolve_title")
      else
        effect2 = ed.createFcaNode("eff_UI_bag_evolve_title_Globe")
        local label = ed.createLabelTTF(T("\229\143\175\229\141\135\230\152\159"), 15, ed.fontBold)
        ed.setLabelColor(label, ed.toccc3(16776073))
        ed.setLabelStroke(label, ed.toccc3(10113285), 1)
        label:limitWidthByScale(80)
        local label_node = CCSprite:create()
        label_node:addChild(label)
        effect2:addNodeToComponent(label_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      end
      headIcon:addChild(effect2, 6)
      effect2:setPosition(ccp(35, 59))
      self:addFca(effect2)
    end
    ed.setTexture(ui.icon_type, ed.readhero.getTypeRes(tid))
    local isCollect = false
    for k, id in ipairs(ed.player:getCollectList()) do
      if id == tid then
        isCollect = true
      end
    end
    ui.icon_collect:setVisible(isCollect)
    local equipParentPosX = ui.layer_mid:getPositionX()
    ui.bg_collect:setPositionX(self.heroItemAdaptConfig.collectPosX + equipParentPosX)
    for i = 1, 6 do
      local node = ui["equip" .. i]
      node:setScale(self.heroItemAdaptConfig.equipAdaptScale)
      node:setPositionX(self.heroItemAdaptConfig["equipPosX" .. i])
      if hero:hasEquipment(i) then
        local eid = ed.readequip.getHeroItem(tid, i)
        local res = ed.getDataTable("equip")[eid].Icon
        local equipIcon = ed.createSprite(res)
        local size = node:getContentSize()
        equipIcon:setPosition(ccp(size.width / 2, size.height / 2 + 1.2))
        equipIcon:setScale(0.33)
        node:addChild(equipIcon)
      else
        local grade = hero._rank
        local eid = ed.getDataTable("hero_equip")[hero._tid][grade]["Equip" .. i .. " ID"]
        if ed.isEquipCraftable(eid) then
          local sr = "UI/alpha/1080P/herolist/icon_compose.png"
          if ed.canWearEquip(hero._tid, eid) then
            sr = "UI/alpha/1080P/herolist/icon_equip.png"
            ui.heroWearable = true
          end
          ed.setTexture(node, sr)
          self.equipCraftable = true
        end
      end
    end
    local nameBgSize = ui.bg_name:getContentSize()
    local nameBgLeftPosX = ui.bg_name:getPositionX() - nameBgSize.width * 0.5
    nameBgSize.width = math.max(self.heroItemAdaptConfig.nameBgWidth, nameBgSize.width)
    ui.bg_name:setContentSize(nameBgSize)
    ui.bg_name:setPositionX(nameBgLeftPosX + nameBgSize.width * 0.5)
    ui.name:setPositionX(nameBgSize.width * 0.5 + 3)
    self:shardIconCreate(tid, ui, self.heroItemAdaptConfig.shardIconPosX + equipParentPosX)
    self:AstrolabeIconCreate(tid, ui, hero, nameBgSize.width + 15)
    self:legendEquipIconCreate(tid, ui, hero, self.heroItemAdaptConfig.legendEquipPosX + equipParentPosX)
  else
    local eno = ed.readhero.checkStoneEnough(tid)
    local unit = ed.getDataTable("Unit")
    local name = unit[tid]["Display Name"]
    if eno then
      local readnode = ed.readnode.create(container, ui)
      readnode:addNode(ed.uieditor.HeroItemSummon)
      ui.bg:setContentSize(CCSizeMake(bgSize.width / 2 + 5, 122))
      ui.layer_mid:setPositionX(self.heroItemAdaptConfig.equipParentPosX)
      ui.light:setContentSize(CCSizeMake(bgSize.width / 2 + 2, 122))
      ui.light:setPositionX(bgSize.width / 4 - 5)
      ed.setLabelStroke(ui.name, ccc3(0, 0, 0), 2)
      ed.setString(ui.name, name)
      ed.setTexture(ui.icon_type, ed.readhero.getTypeRes(tid))
      local sn = ed.readhero.getStoneNeed(tid) or 9999999
      local stars = 1
      if sn == 80 then
        stars = 3
      elseif sn == 30 then
        stars = 2
      end
      ed.setString(ui.num, string.format("%d/%d", amount, need))
      local scale = amount / need
      if 1 < scale then
        scale = 1
      end
      ui.bar:setScaleX(scale)
      local head = ed.readhero.createIcon({
        id = tid,
        rank = 1,
        stars = stars,
        withShade = true
      })
      local headIcon = head.icon
      headIcon:setScale(1.2)
      headIcon:setPosition(getPosAndHide("icon"))
      ui.bg:addChild(headIcon, 1)
      ui.icon = headIcon
      local nameBgSize = ui.bg_name:getContentSize()
      local nameBgLeftPosX = ui.bg_name:getPositionX() - nameBgSize.width * 0.5
      nameBgSize.width = math.max(self.heroItemAdaptConfig.nameBgWidth, nameBgSize.width)
      ui.bg_name:setContentSize(nameBgSize)
      ui.bg_name:setPositionX(nameBgLeftPosX + nameBgSize.width * 0.5)
      ui.name:setPositionX(nameBgSize.width * 0.5 + 3)
      local barBgSize = ui.bg_bar:getContentSize()
      barBgSize.width = nameBgLeftPosX + nameBgSize.width - ui.bg_bar:getPositionX()
      ui.bg_bar:setContentSize(barBgSize)
      ui.bar:setContentSize(barBgSize)
      ui.num:setPositionX(barBgSize.width * 0.5 - 10)
      head.stars[1]:getParent():setZOrder(11)
      local effect
      if ed.isAreaZh() then
        effect = ed.createFcaNode("eff_UI_bag_summon")
      else
        effect = ed.createFcaNode("eff_UI_bag_summon_Globe")
        local label = ed.createLabelTTF(T("\229\143\175\229\143\172\229\148\164"), 15, ed.fontBold)
        ed.setLabelColor(label, ed.toccc3(16769529))
        ed.setLabelStroke(label, ed.toccc3(10559136), 1)
        ed.adaptLabel(label, {maxWidth = 80, minScale = 0.8})
        local label_node = CCSprite:create()
        label_node:addChild(label)
        effect:addNodeToComponent(label_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      end
      effect:setPosition(ccp(36.5, 32.2))
      effect:setZOrder(10)
      headIcon:addChild(effect)
      self:addFca(effect)
      ui.heroCallable = true
    else
      local readnode = ed.readnode.create(container, ui)
      readnode:addNode(ed.uieditor.HeroItemUnGet)
      ui.bg:setContentSize(CCSizeMake(bgSize.width / 2 - 2, 122))
      ui.layer_mid:setPositionX(self.heroItemAdaptConfig.equipParentPosX)
      ui.light:setVisible(false)
      ed.setLabelStroke(ui.name, ccc3(0, 0, 0), 2)
      ed.setString(ui.name, name)
      ed.setTexture(ui.icon_type, ed.readhero.getTypeRes(tid))
      local sn = ed.readhero.getStoneNeed(tid) or 9999999
      local stars = 1
      if sn == 80 then
        stars = 3
      elseif sn == 30 then
        stars = 2
      end
      ed.setLabelStroke(ui.num, ccc3(0, 0, 0), 1)
      ed.setString(ui.num, string.format("%d/%d", amount, need))
      local scale = amount / need
      if 1 < scale then
        scale = 1
      end
      ui.bar:setScaleX(scale)
      ui.num:setColor(ccc3(255, 252, 231))
      local nameBgSize = ui.bg_name:getContentSize()
      local nameBgLeftPosX = ui.bg_name:getPositionX() - nameBgSize.width * 0.5
      nameBgSize.width = math.max(self.heroItemAdaptConfig.nameBgWidth, nameBgSize.width)
      ui.bg_name:setContentSize(nameBgSize)
      ui.bg_name:setPositionX(nameBgLeftPosX + nameBgSize.width * 0.5)
      ui.name:setPositionX(nameBgSize.width * 0.5 + 3)
      local barBgSize = ui.bg_bar:getContentSize()
      barBgSize.width = nameBgLeftPosX + nameBgSize.width - ui.bg_bar:getPositionX()
      ui.bg_bar:setContentSize(barBgSize)
      ui.bar:setContentSize(barBgSize)
      ui.num:setPositionX(barBgSize.width * 0.5 - 10)
      local head = ed.readhero.createIcon({
        id = tid,
        rank = 1,
        stars = stars,
        withShade = true
      }).icon
      head:setScale(1.2)
      head:setPosition(getPosAndHide("icon"))
      ui.bg:addChild(head, 1)
      ui.icon = head
    end
  end
  ui.icon:setPositionX(ui.icon:getPositionX() / 373 * (bgSize.width / 2 - 10))
  ui.name:setScale(minScale[EDCurLanguage] or 1)
  return container, ui
end

function HeroPackage:createButtons()
  self.btnDraglist.listLayer:removeAllChildrenWithCleanup(true)
  for k, v in ipairs(self.btnList) do
    local heroItem = self:createButton(k)
    self.btnDraglist:addItem(heroItem)
  end
  self.btnDraglist:initListHeight(#self.btnList * 45)
  self:refreshButtonDraglist()
end

function HeroPackage:refreshButtonDraglist()
  for k, v in ipairs(self.btnList) do
    if v.type ~= "sort" then
      local btn = self.ui[v.uiName]
      local label = self.ui[v.uiName .. "label"]
      local btnPress = self.ui[v.uiName .. "Press"]
      if k == self.tabIndex then
        btnPress:setVisible(true)
        label:setColor(ccc3(255, 252, 231))
        ed.setLabelStroke(label, ccc3(0, 0, 0), 2)
      else
        btnPress:setVisible(false)
        label:setColor(ccc3(176, 168, 154))
        ed.setLabelStroke(label, ccc3(81, 51, 27), 2)
      end
    else
      local btnPress = self.ui[v.uiName .. "Press"]
      btnPress:setVisible(false)
    end
  end
end

function HeroPackage:initUI()
  local readnode = ed.readnode.create(self.mainLayer, self.ui)
  readnode:addNode(ed.uieditor.HeroPackageMainWin)
  self:adaptUI()
  ed.UITool.createSceneTitle(T("\232\139\177\233\155\132\229\144\141\229\189\149"), self.ui.bg_title, {
    position = ccp(5, 18)
  })
  self:setBackground("UI/alpha/1080P/bg/herolist_bg.jpg")
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
  end)
  self:createButtonDraglist()
  self:createButtons()
end

function HeroPackage:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg, {left = 45, bottom = 0})
  ed.UITool.setContentSizeBy(self.ui.bg, ed.display.halfFixedWidth, ed.display.halfFixedHeight)
  ed.UITool.setPositionBy(self.ui.bg, ccp(ed.display.halfFixedWidth / 2, ed.display.halfFixedHeight / 2))
  ed.UITool.setContentSizeBy(self.ui.layer_item, ed.display.halfFixedWidth, ed.display.halfFixedHeight)
  ed.layout.layoutWithParentMagin(self.ui.layer_btn, {right = 10, top = 15})
  self.ui.line:setScaleY((self.ui.bg:getContentSize().height - 30) / 450)
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  local legendEquipWidth = 45
  local normalEquipWidth = 31.5
  local normalEquipScale = 0.84
  local equip1PosX = 18.5
  local equip6PosX = 161
  local nameBgLeftPosX = 20.75
  local bgSize = self.ui.layer_item:getContentSize()
  local equipParentPosX = 0.29088471849865954 * (bgSize.width / 2 - 10)
  local collectPosX = 0.9276139410187667 * (bgSize.width / 2 - 10) - equipParentPosX
  local totalEndPosX = collectPosX + legendEquipWidth * 0.5
  local equipDesignWidth = normalEquipWidth * normalEquipScale
  local equipDesignStartX = equip1PosX - equipDesignWidth * 0.5
  local equipDesignEndX = equip6PosX + equipDesignWidth * 0.5
  local equipRealEndX = totalEndPosX - legendEquipWidth * 2
  local equipAdaptScale = (equipRealEndX - equipDesignStartX) / (equipDesignEndX - equipDesignStartX)
  equipAdaptScale = math.min(equipAdaptScale, 1.14)
  local equipRealWidth = equipDesignWidth * equipAdaptScale
  local spaceX = (totalEndPosX - equipDesignStartX - 6 * equipRealWidth - legendEquipWidth * 2) / 7
  local curPosX = equipDesignStartX
  self.heroItemAdaptConfig = {}
  self.heroItemAdaptConfig.equipParentPosX = equipParentPosX
  self.heroItemAdaptConfig.collectPosX = collectPosX
  self.heroItemAdaptConfig.equipAdaptScale = equipAdaptScale * normalEquipScale
  for i = 1, 6 do
    self.heroItemAdaptConfig["equipPosX" .. i] = curPosX + equipRealWidth * 0.5
    curPosX = curPosX + equipRealWidth + spaceX
  end
  local legendEquipPosX = curPosX + legendEquipWidth * 0.5
  self.heroItemAdaptConfig.legendEquipPosX = legendEquipPosX
  curPosX = curPosX + legendEquipWidth + spaceX
  local shardIconPosX = curPosX + legendEquipWidth * 0.5
  self.heroItemAdaptConfig.shardIconPosX = shardIconPosX
  self.heroItemAdaptConfig.nameBgWidth = legendEquipPosX - nameBgLeftPosX + legendEquipWidth * 0.5 - 4
end

function HeroPackage:registerTouchEvents()
  for k, v in ipairs(self.btnList) do
    ed.UITool.registerBtn(self, v.uiName, v.handler, {})
  end
end

function HeroPackage:registerEvents()
  self:listenEvent("hh_fav_del_reply", function(info)
    self:doDelCollectReply(info)
    if self.selectUI then
      local isCollect = self.selectUI.icon_collect:isVisible()
      self.selectUI.icon_collect:setVisible(not isCollect)
      self.selectUI = nil
    end
  end)
  self:listenEvent("hh_fav_add_reply", function(info)
    self:doAddCollectReply(info)
    if self.selectUI then
      local isCollect = self.selectUI.icon_collect:isVisible()
      self.selectUI.icon_collect:setVisible(not isCollect)
      self.selectUI = nil
    end
  end)
end

function HeroPackage:shardIconCreate(tid, ui, posX)
  local canOpen = ed.playerlimit.checkAreaUnlock("Shard")
  if not canOpen then
    return
  end
  local state = ed.heroDetailManager:getShardStateByID(tid)
  if state == "UnConfig" then
    return
  end
  local shardEquipBg, shardEquip
  local shardId = ed.heroDetailManager.shardList[tid][1]
  shardEquipBg = ed.createSprite("UI/alpha/1080P/shard/shard_frame.png")
  shardEquipBg:setScale(0.84)
  shardEquipBg:setPosition(posX, 32)
  ui.bg:addChild(shardEquipBg)
  local res = ""
  for k, v in pairs(ed.getDataTable("ShardToHero")) do
    if shardId == v["Shard ID"] and v["Hero ID"] == tid then
      res = v.Icon
    end
  end
  shardEquip = ed.createSprite(res)
  local size = shardEquipBg:getContentSize()
  shardEquip:setPosition(size.width / 2, size.height / 2)
  shardEquipBg:addChild(shardEquip)
  local hero = ed.player.heroes[tid]
  if hero.data._shard and hero.data._shard._level > 0 then
    local labelBg = ed.createSprite("UI/alpha/1080P/skill/skill_rank_2.png")
    labelBg:setPosition(size.width / 2, 7)
    shardEquipBg:addChild(labelBg)
    labelBg:setScale(0.66)
    local label = ed.createttf(hero.data._shard._level, 16)
    label:setPosition(size.width / 2, 7)
    label:setColor(ccc3(254, 255, 170))
    shardEquipBg:addChild(label)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
  end
  
  local function addEffAct()
    local size = shardEquipBg:getContentSize()
    local shardEquipEff = ed.createSprite("UI/alpha/1080P/shard/shard_frame_1.png")
    shardEquipEff:setPosition(size.width / 2, size.height / 2)
    shardEquipBg:addChild(shardEquipEff)
    shardEquipEff:setVisible(false)
    local action = CCSequence:createWithTwoActions(CCFadeTo:create(0.8, 100), CCFadeTo:create(0.8, 255))
    shardEquipEff:runAction(CCRepeatForever:create(action))
    shardEquipEff:setVisible(true)
    local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    red:setPosition(size.width - 4, size.height - 5)
    shardEquipBg:addChild(red)
  end
  
  if state == "CanLevelUp" then
    local size = shardEquipBg:getContentSize()
    local lvUpImg = ed.createSprite("UI/alpha/1080P/shard/lv_up2.png")
    lvUpImg:setPosition(size.width / 2 + 0.5, size.height / 2 - 2)
    shardEquipBg:addChild(lvUpImg)
    local action = CCSequence:createWithTwoActions(CCMoveBy:create(0.8, ccp(0, 5)), CCMoveBy:create(0.8, ccp(0, -5)))
    lvUpImg:runAction(CCRepeatForever:create(action))
  elseif state == "Equiped" then
  elseif state == "notActive" then
    ed.setSpriteShader(shardEquip, "GrayScalingShader_2")
  elseif state == "CanActive" then
    ed.setSpriteShader(shardEquip, "GrayScalingShader_2")
    addEffAct()
  elseif state == "Locked" then
    ed.setSpriteShader(shardEquip, "GrayScalingShader_2")
  end
  ui.shardEquipBg = shardEquipBg
end

local function getColorFunc(v, tid)
  if not v then
    return "astrolabe_herolist_color_0"
  end
  local attrInfo = ed.getDataTable("AstrolabeRandomAttr")[ed.getDataTable("Astrolabe")[tid]["Level Group"]][v._id]
  for i = 1, 4 do
    if v._value <= attrInfo["Value Quality " .. i][2] then
      return "astrolabe_herolist_color_" .. i, 4 <= i
    end
  end
end

function HeroPackage:AstrolabeIconCreate(tid, ui, hero, bgWidth)
  local bgHeight = 17
  if ed.heroDetailManager:isShowPageAstrolabe(tid, true) then
    if ed.heroDetailManager.astrolabes[tid] and ed.heroDetailManager.astrolabes[tid]._unlock == 1 then
      local equipBg = ed.createSpriteTools({
        res = "UI/alpha/1080P/astrolabe/astrolabe_herolist_bg_1.png",
        rectMake = CCRectMake(60, 0, 60, 1),
        sizeMake = CCSizeMake(bgWidth, 17),
        pos = ccp(5 + bgWidth * 0.5, 45),
        parent = ui.layer_mid
      })
      local hero = ed.copyProto(hero)
      local stars = hero.data._astrolabe and (hero.data._astrolabe._stars or {}) or {}
      local tops = 0
      local spriteArr = {}
      local spaceArr = {}
      for i = 1, 5 do
        local res, top = getColorFunc(stars[i], tid)
        local sprite = ed.createSpriteTools({
          res = "UI/alpha/1080P/astrolabe/" .. res .. ".png",
          pos = ccp(0, bgHeight * 0.5),
          parent = equipBg
        })
        table.insert(spriteArr, sprite)
        table.insert(spaceArr, 2)
        tops = top and tops + 1 or tops
      end
      if 5 <= tops then
        ed.setScale9SpriteTexture(equipBg, "UI/alpha/1080P/astrolabe/astrolabe_herolist_bg_2.png")
        equipBg:setContentSize(CCSizeMake(bgWidth, 17))
        for i, v in ipairs(spriteArr) do
          v:removeFromParentAndCleanup(true)
        end
        spriteArr = {}
        spaceArr = {}
        for i = 1, 5 do
          local star = ed.createSpriteTools({
            res = "UI/alpha/1080P/astrolabe/astrolabe_herolist_color_5.png",
            pos = ccp(0, bgHeight * 0.5),
            parent = equipBg
          })
          star:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(math.random(1, 10) / 10), CCCallFunc:create(function()
            local itemSatr = ed.createFcaNode("eff_UI_astrolabe_hero_list_light")
            itemSatr:setLoop(true)
            itemSatr:setLoopAction("Loop")
            itemSatr:setPosition(ccp(5.7, 6.7))
            self:addFca(itemSatr)
            star:addChild(itemSatr, 999)
          end))))
          table.insert(spriteArr, star)
          table.insert(spaceArr, 2)
        end
      end
      ed.layout.horizontalSortNode(spriteArr, spaceArr, bgWidth * 0.5)
    else
      local bgHeight = 17
      local equipBg = ed.createSpriteTools({
        res = "UI/alpha/1080P/astrolabe/astrolabe_herolist_bg_1.png",
        rectMake = CCRectMake(60, 0, 60, 17),
        sizeMake = CCSizeMake(bgWidth, 17),
        pos = ccp(5 + bgWidth * 0.5, 45),
        parent = ui.layer_mid
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/astrolabe/astrolabe_herolist_lock.png",
        pos = ccp(bgWidth * 0.5, bgHeight * 0.5),
        parent = equipBg
      })
    end
  end
end

function HeroPackage:legendEquipIconCreate(tid, ui, hero, posX)
  local icon
  local isUnlock = ed.heroDetailManager:getLegendEquipUnlock(tid) and not ed.isAreaOverSea()
  if not isUnlock then
    icon = ed.createSprite("UI/alpha/1080P/herolist/bg_locked_shade.png")
    ui.lockIcon = icon
  else
    local heroLegendEquip = hero._legend_equip or {}
    local legendEquip = heroLegendEquip._equip
    if not legendEquip then
      icon = ed.createSprite("UI/alpha/1080P/herolist/bg_unequip_shade.png")
    else
      icon = ed.createSprite("UI/alpha/1080P/herolist/bg_legendequip_shade.png")
      local typeId = legendEquip._type_id
      local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
      local legendEquipSmallIcon = ed.createSprite(legendEquipCfg["Special Icon"])
      icon:addChild(legendEquipSmallIcon)
      ed.layout.centerInParent(legendEquipSmallIcon)
    end
    ui.unlockIcon = icon
  end
  icon:setPosition(ccp(posX, 32))
  ui.bg:addChild(icon)
end

function HeroPackage.create()
  local self = base.create("heroPackage")
  setmetatable(self, HeroPackage.mt)
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnEnterHandler("heroPackageOnEnter", function()
    if #self.sortBtnList > 0 and not ed.isAreaOverSea() then
      for i, v in ipairs(self.sortBtnList) do
        if self.sortPiorityType == v.type then
          self:changeSort(v)
          break
        end
      end
    else
      self:refreshMainDraglist()
    end
  end)
  return self
end

function HeroPackage:getWearableHeroIcon()
  for i, v in pairs(self.uiList) do
    if v.heroWearable then
      return v.bg
    end
  end
end

function HeroPackage:getCallableHeroIcon()
  for i, v in pairs(self.uiList) do
    if v.heroCallable then
      return v.bg
    end
  end
end

function HeroPackage:getCallableHeroIcon()
  for i, v in pairs(self.uiList) do
    if v.heroCallable then
      return v.bg
    end
  end
end

function HeroPackage:getSkillUpgradeableIcon()
  return self.uiList[1].bg
end

function HeroPackage:getGuideNode(nodeKey)
  if nodeKey == "wearable_hero" then
    return self:getWearableHeroIcon()
  elseif nodeKey == "callable_hero" then
    return self:getCallableHeroIcon()
  elseif nodeKey == "skill_upgradeable_hero" then
    return self:getSkillUpgradeableIcon()
  end
  return base.getGuideNode(self, nodeKey)
end

function HeroPackage:createSortBtnTouchHandler()
  local pressIndex = -1
  
  local function handler(event, x, y)
    local _, result = xpcall(function()
      if event == "began" then
        pressIndex = -1
      end
      if self.ui.sortSelectionBg:isVisible() then
        if event == "began" then
          if not ed.containsPoint(self.ui.sortSelectionBg, x, y) then
            if not ed.containsPoint(self.ui.btn_sort, x, y) then
              self:hideSortToast()
            end
            return false
          else
            for i, v in ipairs(self.sortSelectionUIArr) do
              if v.btn:isVisible() and ed.containsPoint(v.btn, x, y) then
                pressIndex = i
                break
              end
            end
            return true
          end
        elseif event == "ended" then
          if 0 < pressIndex then
            local itemUI = self.sortSelectionUIArr[pressIndex]
            local data = self.sortBtnList[pressIndex]
            if nil ~= itemUI and ed.containsPoint(itemUI.btn, x, y) and nil ~= data then
              self:hideSortToast()
              self:changeSort(data)
            end
          end
          pressIndex = -1
        end
      end
      return false
    end, EDDebug)
    return result
  end
  
  return handler
end

function HeroPackage:showSortToast()
  if nil == self.ui.img_btn_sort_selected then
    self.ui.img_btn_sort_selected = ed.createSprite("UI/alpha/1080P/herolist/bg_order_highlight.png")
    self.ui.btn_sort:addChild(self.ui.img_btn_sort_selected)
    local btnSize = self.ui.btn_sort:getContentSize()
    self.ui.img_btn_sort_selected:setPosition(btnSize.width * 0.5, btnSize.height * 0.5)
  else
    self.ui.img_btn_sort_selected:setVisible(true)
  end
  if nil == self.ui.sortSelectionBg then
    self.ui.sortSelectionBg = ed.createScale9Sprite("UI/alpha/1080P/herolist/bg_order_tab.png", CCRectMake(50, 0, 133, 1))
    self.ui.bg:addChild(self.ui.sortSelectionBg)
    self.sortSelectionUIArr = {}
    local touchLayer = CCLayer:create()
    touchLayer:setTouchEnabled(true)
    touchLayer:registerScriptTouchHandler(self:createSortBtnTouchHandler(), false, -10, true)
    self.ui.sortSelectionBg:addChild(touchLayer)
  else
    self.ui.sortSelectionBg:setVisible(true)
  end
  local bgSize = self.ui.sortSelectionBg:getContentSize()
  for i, v in ipairs(self.sortBtnList) do
    local itemUI = self.sortSelectionUIArr[i]
    if nil == itemUI then
      itemUI = {}
      itemUI.btn = ed.createSprite(v.btnRes)
      self.ui.sortSelectionBg:addChild(itemUI.btn)
      itemUI.btn:setPositionY(bgSize.height * 0.5 + 4)
      local btnSize = itemUI.btn:getContentSize()
      itemUI.name = ed.createLabelTTF(v.nameStr, 18)
      itemUI.name:setPosition(btnSize.width * 0.5, btnSize.height * 0.5)
      itemUI.btn:addChild(itemUI.name)
      ed.setLabelColor(itemUI.name, v.nameColor)
      ed.setLabelStroke(itemUI.name, v.nameStrokeColor, 1)
      self.sortSelectionUIArr[i] = itemUI
    else
      itemUI.btn:setVisible(true)
      ed.setTexture(itemUI.btn, v.btnRes)
      ed.setLabelString(itemUI.name, v.nameStr)
      ed.setLabelColor(itemUI.name, v.nameColor)
      ed.setLabelStroke(itemUI.name, v.nameStrokeColor, 1)
    end
  end
  local nodeArr = {}
  local spaceArr = {}
  local totalWidth = 0
  local lastSpace = 0
  for i = 1, #self.sortSelectionUIArr do
    local btn = self.sortSelectionUIArr[i].btn
    table.insert(spaceArr, 0)
    table.insert(nodeArr, btn)
    if i > #self.sortBtnList or not btn:isVisible() then
      btn:setVisible(false)
    else
      totalWidth = totalWidth + lastSpace + btn:getContentSize().width * btn:getScale()
      lastSpace = spaceArr[i]
    end
  end
  bgSize.width = totalWidth + 50
  self.ui.sortSelectionBg:setContentSize(bgSize)
  ed.layout.horizontalSortNode(nodeArr, spaceArr, bgSize.width * 0.5)
  local pos = ccp(self.ui.btn_sort:getPosition())
  pos.x = 0
  pos = self.ui.btn_sort:getParent():convertToWorldSpace(pos)
  pos = self.ui.bg:convertToNodeSpace(pos)
  pos.x = pos.x - bgSize.width * 0.5 + 7
  self.ui.sortSelectionBg:setPosition(pos)
end

function HeroPackage:hideSortToast()
  if nil ~= self.ui.sortSelectionBg then
    self.ui.sortSelectionBg:setVisible(false)
  end
  if nil ~= self.ui.img_btn_sort_selected then
    self.ui.img_btn_sort_selected:setVisible(false)
  end
end
