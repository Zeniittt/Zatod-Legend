local base = ed.ui.basescene
local dayAwardsScene = newclass(base.mt)
ed.ui.dayAwardsScene = dayAwardsScene

function dayAwardsScene.create(param)
  return setmetatable(base.create("dayAwardsScene"), dayAwardsScene.mt):init(param)
end

function dayAwardsScene:init(param)
  self.param = param or {}
  self.index = self.param.index or 1
  self:initUI()
  self:registerEvents()
  return self
end

function dayAwardsScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.dayAwardsScene)
  self.ui, self.container = ui, container
  self.mainLayer:addChild(container)
  ed.UITool.createSceneTitle(T("\228\188\160\229\165\135\229\144\175\231\168\139"), self.ui.img_title_bg, {
    position = ccp(22, 18)
  })
  ed.layout.layoutWithMagin(self.ui.img_title_bg, {left = 80, top = 15})
  if ed.display.winSize.width <= 960 then
    self.ui.ImageView_bg:setScale(0.9)
    self.ui.Panel_top:setScale(0.9)
    self.ui.Panel_top:setPosition(ccpAdd(ccp(self.ui.Panel_top:getPosition()), ccp(18, -4)))
    local size = self.ui.panel_line_item:getContentSize()
    self.ui.panel_line_item:setContentSize(CCSizeMake(size.width * 0.95, size.height * 0.9))
    self.ui.hero_icon_bg:setPositionX(self.ui.hero_icon_bg:getPositionX() + 30)
    self.ui.ImageView_2488:setPositionX(self.ui.ImageView_2488:getPositionX() + 30)
    self.ui.Panel_left:setScale(0.9)
    local size = self.ui.Panel_left:getContentSize()
    self.ui.Panel_left:setContentSize(CCSizeMake(size.width, size.height * 0.95))
    self.ui.Panel_left:setPosition(ccpAdd(ccp(self.ui.Panel_left:getPosition()), ccp(10, 14)))
    self.ui.Panel_right:setPositionX(self.ui.Panel_right:getPositionX() - 30)
    self.zoom = true
  end
  self:initRight()
  self:initLeft()
end

function dayAwardsScene:createLeftFashionName()
  local label = ed.ui.gradientLabel.create({
    text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
    fontSize = 26,
    fontName = ed.fontBold,
    startColor = ed.toccc3(11435038),
    endColor = ed.toccc3(7494659),
    strokeColor = ed.toccc3(16776415),
    strokeSize = 3
  })
  label.node:setPosition(129.25, 43.75)
  self.ui.ImageView_2489:addChild(label.node, 9)
  local label = ed.ui.gradientLabel.create({
    text = T("\228\188\160\229\165\135\194\183\229\134\176\231\148\178"),
    fontSize = 29,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15202815),
    endColor = ed.toccc3(7657726),
    strokeStartColor = ed.toccc3(1998232),
    strokeEndColor = ed.toccc3(2508691),
    strokeSize = 3
  })
  label.node:setPosition(82.25, 50)
  self.ui.ImageView_2590:addChild(label.node, 9)
end

function dayAwardsScene:initTop()
  local thisCon = self.ui.panel_line_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_line_item,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.lineItemList = ed.draglist.create(info)
  ed.createLabelTools({
    txt = T("\229\189\147\229\137\141\231\167\175\229\136\134"),
    size = 18,
    pos = ccp(51, 70),
    color = ccc3(ed.colorToStr("#FEFBE6")),
    stroke = {
      ccc3(ed.colorToStr("#412A11")),
      1.5
    },
    parent = self.ui.Panel_top,
    font = ed.fontBold
  })
  self.strawberry = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/point_small.png",
    pos = ccp(81, 32),
    parent = self.ui.Panel_top,
    scale = 0.9
  })
  self.scoreUI = ed.getNumberNode({
    text = ed.dayAwardsManager.curProgress,
    folder = "herohot_num",
    padding = 0
  })
  self.scoreUI.node:setPosition(36, 31)
  self.ui.Panel_top:addChild(self.scoreUI.node)
  local barBgImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/seven_day/seven_day_bar_2.png",
    pos = ccp(0, 32),
    anchor = ccp(0, 0.5),
    rectMake = CCRectMake(38, 2.75, 400, 20),
    sizeMake = CCSizeMake(476, 25.5),
    parent = self.lineItemList.listLayer
  })
  local barImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/sweet_party/sweet_party_bar_3.png",
    pos = ccp(1, 12.5),
    anchor = ccp(0, 0.5),
    rectMake = CCRectMake(6, 2.25, 431, 10),
    sizeMake = CCSizeMake(476, 15),
    parent = barBgImg
  })
  local barStarimg = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/sweet_party/sweet_party_bar_4.png",
    pos = ccp(0, 0),
    anchor = ccp(0, 0.5),
    parent = barBgImg,
    notShow = true
  })
  local barDeco = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/seven_day/seven_day_bar_4.png",
    pos = ccp(0, 7.5),
    anchor = ccp(0.5, 0.5),
    parent = barImg
  })
  local lineItem = ed.dayAwardsManager:getLineItems()
  lineItem = ed.copyTable(lineItem)
  table.sort(lineItem, function(a, b)
    return a["Require Task Count"] < b["Require Task Count"]
  end)
  local rightItem = {}
  self.lineItems = {}
  local addbarWidth = 0
  for index, data in ipairs(lineItem) do
    if addbarWidth ~= 0 then
      ed.createSpriteTools({
        res = "UI/alpha/1080P/activity/seven_day/seven_day_bar_3.png",
        pos = ccp(addbarWidth, 12.75),
        parent = barBgImg
      })
    end
    addbarWidth = addbarWidth + 76
    ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/seven_day/seven_day_point_bg.png",
      pos = ccp(addbarWidth, -4),
      parent = barBgImg
    })
    ed.createLabelTools({
      txt = data["Require Task Count"],
      size = 16,
      pos = ccp(addbarWidth, -4),
      color = ed.toccc3(16776423),
      parent = barBgImg,
      stroke = {
        ed.toccc3(3876115),
        1
      }
    })
    local item = ed.taskItemModule.new(self, {
      id = data["Reward ID 1"],
      type = data["Reward Type 1"],
      amount = data["Reward Amount 1"],
      data = data
    }, nil, index, false, false, false)
    item.icon:setScale(0.65)
    self.lineItemList:addItem(item.icon, ccp(index * 76, 70))
    local imgType = {
      [1] = 0,
      [3] = 1,
      [2] = 2
    }
    item:refresh(imgType[data.taskState])
    item.taskCount = data["Require Task Count"]
    self.lineItems[index] = item
    rightItem = data
  end
  barBgImg:setContentSize(CCSizeMake(addbarWidth + 10 + 5, 25.5))
  barImg:setContentSize(CCSizeMake(addbarWidth, 15))
  barStarimg:setPosition(addbarWidth - 22 + 5, 12.5)
  self.progressBox = ed.taskProModule.new(barImg, 15, barDeco, addbarWidth, 0.02)
  self.progressBox:setPro(0)
  self.progressBox.barStarimg = barStarimg
  self.lineItemList:initListWidth(#lineItem * 76 + 130 - (self.zoom and 60 or 0))
  local item = ed.taskItemModule.new(self, {
    id = rightItem["Reward ID 1"],
    type = rightItem["Reward Type 1"],
    amount = rightItem["Reward Amount 1"],
    data = rightItem
  }, nil, 99, false, false, true)
  item.icon:setScale(1)
  item.icon:setPosition(54.75, 51.5)
  self.ui.hero_icon_bg:addChild(item.icon)
  local imgType = {
    [1] = 0,
    [3] = 1,
    [2] = 2
  }
  item:refresh(imgType[rightItem.taskState])
  item.taskCount = rightItem["Require Task Count"]
  self.topRightItem = item
  self.topRightItem.icon:setVisible(false)
  self.lineItemNotInit = true
  local onlyTag = ed.ui.gradientLabel.create({
    text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
    fontSize = 13,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16776069)
  })
  onlyTag.node:setPosition(49.25, 15.25)
  self.ui.ImageView_2488:addChild(onlyTag.node)
end

function dayAwardsScene:initLeft()
  local thisCon = self.ui.Panel_left:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 3, thisCon.width, thisCon.height - 3),
    container = self.ui.Panel_left,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.taskDragList = ed.draglist.create(info)
  self.thisCon = thisCon
end

function dayAwardsScene:initRight()
  local thisCon = self.ui.Panel_right:getContentSize()
  self.pageButList = ed.draglist.create({
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_right,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  })
  local btnInfos = ed.dayAwardsManager:getTaskTab()
  self.btnPages = {}
  for index, info in ipairs(btnInfos) do
    local button = ed.createSpriteTools({
      res = "UI/alpha/1080P/fireforge/DayAwards/tab_unselected.png",
      pos = ccp(78.5, thisCon.height - index * 56 + 19),
      parent = self.pageButList.listLayer,
      z = -1
    })
    ed.createLabelTools({
      txt = T(info["Tab Name"]),
      size = 18,
      pos = ccp(69.5, 22.5),
      color = ed.toccc3(13353958),
      stroke = {
        ccc3(ed.colorToStr("#524179")),
        2
      },
      parent = button
    })
    local buttonSelected = ed.createSpriteTools({
      res = "UI/alpha/1080P/fireforge/DayAwards/tab_selected.png",
      pos = ccp(74.5, thisCon.height - index * 56 + 19),
      parent = self.pageButList.listLayer,
      notShow = self.index ~= index,
      z = -1
    })
    ed.createLabelTools({
      txt = T(info["Tab Name"]),
      size = 18,
      pos = ccp(80.5, 28),
      color = ed.toccc3(6307604),
      stroke = {
        ccc3(ed.colorToStr("#ffef96")),
        2
      },
      parent = buttonSelected
    })
    local red = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      pos = ccp(138, thisCon.height - index * 56 + 40),
      parent = self.pageButList.listLayer,
      z = -1,
      notShow = true
    })
    self.btnPages[index] = {
      button = button,
      buttonSelected = buttonSelected,
      red = red,
      data = info
    }
  end
  self.pageButList:initListHeight(#btnInfos * 56)
end

function dayAwardsScene:registerEvents()
  ed.UITool.registerBtn(self, "img_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ed.dayAwardsManager.rule
    }):popWindow()
  end)
  ed.UITool.registerBtn(self, "img_close", function()
    ed.popScene()
    ed.dayAwardsManager:closeWindow()
  end, {normalScale = 0.8, pressScale = 0.75})
  self:listenEvent("refreshdayAwardsScene", function(data)
    self:refreshUI(data.type)
  end)
  self:registerOnEnterHandler("dayAwardsSceneOnEnter", function()
    ed.dayAwardsNetwork:sendOpenPanel()
  end)
  self:listenEvent("midas_reply", function(_)
    ed.dayAwardsNetwork:sendOpenPanel()
  end)
  self:listenEvent("CloseChatMainWin", function(_)
    ed.dayAwardsNetwork:sendOpenPanel()
  end)
end

function dayAwardsScene:refreshUI(type)
  if type == "openPanel" or type == "taskRewards" or type == "lineRewards" then
    local time = ed.dayAwardsManager.totalEndTime - ed.getServerTime()
    ed.setString(self.ui.Label_time, ed.time2dhms(time))
    self:refreshTop()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:refreshLeft()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:refreshRight()
  end
end

function dayAwardsScene:refreshTop()
  if not self.progressBox then
    self:initTop()
    self:createLeftFashionName()
  end
  local curProgress = ed.dayAwardsManager.curProgress
  if self.oldCurProgress ~= curProgress then
    ed.refreshNumberNode(self.scoreUI, curProgress)
    self.scoreUI.node:setPosition(ccp(68 - self.scoreUI.node:getContentSize().width / 2, 31))
    if self.oldCurProgress then
      self.strawberry:runAction(CCShake:create(0.4, 2, 0.5))
    end
    self.oldCurProgress = curProgress
  else
    local imgType = {
      [1] = 0,
      [3] = 1,
      [2] = 2
    }
    for _, item in ipairs(self.lineItems) do
      local taskState = ed.dayAwardsManager:getLineItemsState(item.param.data.ID)
      item:refresh(imgType[taskState])
    end
    local taskState = ed.dayAwardsManager:getLineItemsState(self.topRightItem.param.data.ID)
    self.topRightItem:refresh(imgType[taskState])
    return
  end
  local maxCount = self.topRightItem.taskCount
  local oldPro = self.progressBox.pro * maxCount
  if self.lineItemNotInit then
    self.progressBox:setPro(curProgress / maxCount)
  else
    self.progressBox:addPro(curProgress / maxCount)
  end
  local newPro = self.progressBox.pro * maxCount
  
  local function maxfunc(progress)
    if progress.pro >= 1 then
      progress.barStarimg:setScale(0.1)
      progress.barStarimg:setVisible(true)
      progress.barStarimg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.1, 1)))
      progress.bardeco:setVisible(false)
      local imgType = {
        [1] = 0,
        [3] = 1,
        [2] = 2
      }
      local taskState = ed.dayAwardsManager:getLineItemsState(self.topRightItem.param.data.ID)
      self.topRightItem:refresh(imgType[taskState])
    end
  end
  
  if self.lineItemNotInit then
    local idx = 0
    for i, item in ipairs(self.lineItems) do
      if oldPro < item.taskCount and newPro >= item.taskCount then
        local imgType = {
          [1] = 0,
          [3] = 1,
          [2] = 2
        }
        local taskState = ed.dayAwardsManager:getLineItemsState(item.param.data.ID)
        item:refresh(imgType[taskState])
        idx = 0 < idx and i or idx
        if taskState == 3 and 0 < idx then
          idx = i * -1
        end
      end
    end
    if idx ~= 0 then
      idx = math.abs(idx)
      if 3 < idx then
        idx = idx > #self.lineItems - 3 and #self.lineItems - 3 or idx
        self.lineItemList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.3, ccp((idx - 3) * -76 - 30, 0))))
      end
    end
    maxfunc(self.progressBox)
    self.lineItemNotInit = false
    return
  end
  
  function self.progressBox.actionsFinishFun(progress)
    maxfunc(progress)
  end
  
  local updateItems = {}
  
  function self.progressBox.updateFun(progress)
    if updateItems[math.floor(progress.width)] then
      local function func(item)
        return function()
          local imgType = {
            [1] = 0,
            
            [3] = 1,
            [2] = 2
          }
          local taskState = ed.dayAwardsManager:getLineItemsState(item.param.data.ID)
          item:refresh(imgType[taskState])
        end
      end
      
      updateItems[math.floor(progress.width)].icon:runAction(CCSequence:create(ccArrayMake(CCEaseBackIn:create(CCMoveBy:create(0.3, ccp(0, 3))), CCCallFunc:create(func(updateItems[math.floor(progress.width)])), CCEaseBackOut:create(CCMoveBy:create(0.3, ccp(0, -3))))))
      updateItems[math.floor(progress.width)] = nil
    end
  end
  
  for _, item in ipairs(self.lineItems) do
    if oldPro < item.taskCount and newPro >= item.taskCount then
      local toPro = item.taskCount / maxCount * self.progressBox.widthMax
      toPro = math.floor(toPro / self.progressBox.upPs) * self.progressBox.upPs
      updateItems[math.floor(toPro)] = item
    end
  end
end

function dayAwardsScene:refreshLeft()
  local data = ed.dayAwardsManager:getdayAwardsTask()
  data = data[self.btnPages[self.index].data["Tab ID"]] or {}
  data = ed.copyTable(data)
  local sortPriority = {
    [3] = 9,
    [2] = 1,
    [1] = 5
  }
  table.sort(data, function(a, b)
    if sortPriority[a.taskState] == sortPriority[b.taskState] then
      return a.id < b.id
    else
      return sortPriority[a.taskState] > sortPriority[b.taskState]
    end
  end)
  local posy = self.thisCon.height - 12 - 33.25 + (self.zoom and 30 or 0)
  local isInit = not self.oldIdx or self.oldIdx ~= self.index
  self.oldIdx = self.index
  if isInit or not self.taskItems then
    self.listOver = false
    self.taskItems = {}
    self.taskDragList:clearList()
    self.ui.Panel_left:stopAllActions()
    local index = 1
    ed.timeSchedule(self.ui.Panel_left, function()
      if not data[index] then
        self.ui.Panel_left:stopAllActions()
        self.listOver = true
        return
      end
      local item = self.itemModule.create(self, data[index], index)
      self.taskDragList:addItem(item.ui.Layer, ccp(self.thisCon.width / 2 + 2, posy))
      posy = posy - 66.5 - 4
      table.insert(self.taskItems, item)
      self.taskItems[data[index].id] = item
      index = index + 1
    end, 0.01)
    self.taskDragList:initListHeight(#data * 70.5 + 12 - (self.zoom and 20 or 0))
  else
    for i, v in ipairs(data) do
      local item = self.taskItems[v.id]
      if item then
        local y = posy - 70.5 * (i - 1)
        if item.index ~= i then
          if i < item.index then
            item.ui.Layer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.5, ccp(self.thisCon.width / 2 + 2, y))))
          else
            item.ui.Layer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.5, ccp(self.thisCon.width / 2 + 2, y))))
          end
        end
        item:update(v, i)
      end
    end
  end
end

function dayAwardsScene:refreshRight()
  for _, v in ipairs(self.btnPages) do
    v.buttonSelected:setVisible(v.data["Tab ID"] == self.index)
    v.red:setVisible(ed.dayAwardsManager:getReds(v.data["Tab ID"]) > 0)
  end
end

function dayAwardsScene:doPressInList()
  local function handler(x, y)
    for _, v in ipairs(self.btnPages) do
      if ed.containsPoint(v.button, x, y) and v.data["Tab ID"] ~= self.index then
        v.button:setScale(0.95)
        
        return {
          icon = v.button,
          fun = function(param)
            self.index = param["Tab ID"]
            self:refreshRight()
            self:refreshLeft()
          end,
          param = v.data
        }
      end
    end
    if ed.containsPoint(self.topRightItem.icon, x, y) then
      self.ui.hero_icon_bg:setScale(0.95)
      return {
        icon = self.ui.hero_icon_bg,
        fun = function(param)
          ed.ui.packageDetailWin.create(param):popWindow()
        end,
        param = self.topRightItem.param
      }
    else
      for _, v in ipairs(self.lineItems) do
        if ed.containsPoint(v.icon, x, y) then
          v.icon:setScale(0.6)
          return {
            icon = v.icon,
            fun = function(param)
              if param.state == 1 then
                ed.dayAwardsNetwork:sendGetLineReward(param.data.ID)
              else
                ed.ui.packageDetailWin.create(param):popWindow()
              end
            end,
            param = v.param,
            normalScale = 0.65
          }
        end
      end
    end
    for _, v in pairs(self.taskItems) do
      if not v.ui.getBtn:isVisible() and v.ui.goBtn:isVisible() and ed.containsPoint(v.ui.goBtn, x, y) then
        v.ui.goBtn:setScale(0.95)
        return {
          icon = v.ui.goBtn,
          fun = function(param)
            ed.activityTaskTool.taskSkip(param.progressType, {})
          end,
          param = v.param
        }
      elseif v.ui.getBtn:isVisible() and ed.containsPoint(v.ui.getBtn, x, y) then
        v.ui.getBtn:setScale(0.95)
        return {
          icon = v.ui.getBtn,
          fun = function(param)
            ed.dayAwardsNetwork:sendGetTaskReward(param.id)
          end,
          param = v.param
        }
      else
        for _, vv in ipairs(v.items) do
          if ed.containsPoint(vv.icon, x, y) then
            vv.icon:setScale(0.55)
            return {
              icon = vv.icon,
              fun = function(param)
                ed.ui.packageDetailWin.create(param):popWindow()
              end,
              param = vv.param,
              normalScale = 0.6
            }
          end
        end
      end
    end
  end
  
  return handler
end

function dayAwardsScene:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function dayAwardsScene:cancelClickInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function dayAwardsScene:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end

local itemModule = {}

function itemModule.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemModule})
  this:init(param)
  return this
end

function itemModule:init(param)
  local Layer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0)
  })
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/task_board1.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local highlightBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/task_board3.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local shieldImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/task_board2.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local getBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/get_button.png",
    parent = highlightBg,
    pos = ccp(421, 33.25)
  })
  ed.createLabelTools({
    txt = T("\233\162\134\229\143\150"),
    size = 18,
    pos = ccp(54.25, 29.5),
    color = ed.toccc3(16776423),
    parent = getBtn,
    stroke = {
      ccc3(ed.colorToStr("#965123")),
      3
    }
  })
  local goBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/go_button.png",
    parent = bg,
    pos = ccp(421, 33.25)
  })
  ed.createLabelTools({
    txt = T("\229\137\141\229\190\128"),
    size = 18,
    pos = ccp(54.25, 29.5),
    color = ed.toccc3(16776423),
    parent = goBtn,
    stroke = {
      ccc3(ed.colorToStr("#A23631")),
      3
    }
  })
  ed.createLabelTools({
    txt = T("\229\183\178\229\174\140\230\136\144"),
    size = 17,
    pos = ccp(54.25, 30),
    color = ed.toccc3(13817561),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/fireforge/DayAwards/alreadydone_board.png",
      parent = shieldImg,
      pos = ccp(421, 33.25)
    })
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/task_title1.png",
    pos = ccp(108, 46),
    parent = bg
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/task_title2.png",
    pos = ccp(108, 46),
    parent = highlightBg
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/DayAwards/task_title3.png",
    pos = ccp(108, 46),
    parent = shieldImg
  })
  local detaillabel = ed.createLabelTools({
    txt = T(param.detail),
    size = 16,
    pos = ccp(-220, 12),
    color = ed.toccc3(16777215),
    parent = Layer,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#23120B")),
      1
    }
  })
  local progresslabel = ed.createLabelTools({
    txt = T("\229\189\147\229\137\141\232\191\155\229\186\166(%d/%d)", param.progress, param.target),
    size = 14,
    pos = ccp(-220, -14),
    color = ed.toccc3(2694941),
    parent = Layer,
    anchor = ccp(0, 0.5)
  })
  self.items = {}
  for i, v in ipairs(param.items) do
    local item = ed.taskItemModule.new(self, {
      id = v.id,
      type = v.type,
      amount = v.amount
    }, nil, param._id, false, false, true)
    item.icon:setPosition(-70 + 53 * i, 0)
    Layer:addChild(item.icon)
    item.icon:setScale(0.6)
    table.insert(self.items, item)
  end
  self.ui = {
    Layer = Layer,
    bg = bg,
    highlightBg = highlightBg,
    shieldImg = shieldImg,
    getBtn = getBtn,
    goBtn = goBtn,
    progresslabel = progresslabel,
    detaillabel = detaillabel
  }
  self:update(param)
end

itemModule.detailColor = {
  {
    color1 = ed.toccc3(16776423),
    stroke1 = {
      ccc3(ed.colorToStr("#23120b")),
      2
    },
    color2 = ed.toccc3(2494738)
  },
  {
    color1 = ed.toccc3(10919102),
    stroke1 = {
      ccc3(ed.colorToStr("#141829")),
      2
    },
    color2 = ed.toccc3(1117973)
  },
  {
    color1 = ed.toccc3(16777215),
    stroke1 = {
      ccc3(ed.colorToStr("#23120b")),
      2
    },
    color2 = ed.toccc3(2694941)
  }
}

function itemModule:update(param, index)
  self.param = param
  self.index = index or self.index
  self.ui.detaillabel:setColor(self.detailColor[param.taskState].color1)
  self.ui.progresslabel:setColor(self.detailColor[param.taskState].color2)
  self.ui.bg:setVisible(param.taskState == 1)
  self.ui.shieldImg:setVisible(param.taskState == 2)
  self.ui.highlightBg:setVisible(param.taskState == 3)
  self.ui.goBtn:setVisible(param.taskState ~= 2)
  self.ui.getBtn:setVisible(param.taskState == 3)
  self.ui.progresslabel:setString(T("\229\189\147\229\137\141\232\191\155\229\186\166(%d/%d)", param.progress, param.target))
  local imgType = {
    [1] = 0,
    [3] = 1,
    [2] = 2
  }
  for _, v in ipairs(self.items) do
    v:refresh(imgType[param.taskState])
  end
end

dayAwardsScene.itemModule = itemModule
