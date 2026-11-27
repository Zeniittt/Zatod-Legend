local base = ed.ui.basescene
local sweetPartyScene = newclass(base.mt)
ed.ui.sweetPartyScene = sweetPartyScene

function sweetPartyScene.create(param)
  return setmetatable(base.create("sweetPartyScene"), sweetPartyScene.mt):init(param)
end

function sweetPartyScene:init(param)
  self.param = param or {}
  self.index = self.param.index or 1
  self:initUI()
  self:registerEvents()
  return self
end

function sweetPartyScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.sweetPartyScene)
  self.ui, self.container = ui, container
  self.mainLayer:addChild(container)
  ed.UITool.createSceneTitle(T("\231\148\156\229\191\131\230\180\190\229\175\185"), self.ui.img_title_bg, {
    position = ccp(22, 18),
    maxWidth = 160
  })
  ed.layout.layoutWithMagin(self.ui.img_title_bg, {left = 80, top = 15})
  local titleScale = {
    ja = {scale = 0.95, offsetX = 25},
    en = {scale = 1, offsetX = 20},
    ko = {
      scale = 0.9,
      offsetX = 15,
      offsetY = 5
    },
    default = {scale = 1, offsetX = 0}
  }
  local titleConf = titleScale[EDCurLanguage] or titleScale.default
  self.ui.ImageView_304:setScale(titleConf.scale)
  ed.UITool.setPositionBy(self.ui.ImageView_304, ccp(titleConf.offsetX, titleConf.offsetY or 0))
  self:initRight()
  self:initLeft()
end

function sweetPartyScene:createLeftFashionName()
  local data = self.topRightItem.param.data
  local id = data["Reward ID 1"]
  local fashionId = ed.getDataTable("equip")[id] and ed.getDataTable("equip")[id]["Fashion ID"] or 0
  fashionId = fashionId or 0
  if fashionId == 0 then
    return print(T("\230\151\160\231\154\174\232\130\164\229\165\150\229\138\177\233\133\141\231\189\174\229\144\141\231\167\176(fashionId is nil)"))
  end
  if ed.isAreaZh() then
    local fashBg = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "fashionNameBg"),
      pos = ccp(125, 350),
      parent = self.ui.ImageView_bg,
      z = 999
    })
    local qualityLabel = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "qualityBg"),
      pos = ccp(22, 26),
      parent = fashBg
    }), ccp(28, 22), 18)
    qualityLabel:limitWidthByScale(45)
    local name = ed.lookupDataTable("Fashion", "Name", fashionId)
    local label = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(fashBg, ccp(24, 68), 19)
    ed.setLabelDimensions(label, CCSizeMake(22, 150))
    label:setString(name)
  else
    local posX = self.ui.ImageView_305:getPositionX()
    local fashBg = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "fashionNameBg_Globe"),
      pos = ccp(posX, self.ui.ImageView_305:getPositionY() + 40),
      parent = self.ui.ImageView_bg,
      z = 999
    })
    local qualityLabel = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "qualityBg"),
      pos = ccp(22, 26),
      parent = fashBg
    }), ccp(28, 22), 18)
    qualityLabel:limitWidthByScale(45)
    local name = ed.lookupDataTable("Fashion", "Name", fashionId)
    local label = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashion_id))(fashBg, ccp(110, 22), 19)
    label:setString(name)
    ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
  end
end

function sweetPartyScene:initTop()
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
    color = ccc3(ed.colorToStr("#fffce7")),
    stroke = {
      ccc3(ed.colorToStr("#378386")),
      1.5
    },
    parent = self.ui.Panel_top,
    font = ed.fontBold
  })
  self.strawberry = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/sweet_party/sweet_party_strawberry_icon.png",
    pos = ccp(82, 31),
    parent = self.ui.Panel_top
  })
  self.scoreUI = ed.getNumberNode({
    text = ed.sweetPartyManager.curProgress,
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
  local lineItem = ed.sweetPartyManager:getLineItems()
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
  self.lineItemList:initListWidth(#lineItem * 76 + 130)
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
  self.lineItemNotInit = true
end

function sweetPartyScene:initLeft()
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

function sweetPartyScene:initRight()
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
  local btnInfos = ed.sweetPartyManager:getTaskTab()
  self.btnPages = {}
  for index, info in ipairs(btnInfos) do
    local button = ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/sweet_party/sweet_party_tab_unselected.png",
      pos = ccp(74.5, thisCon.height - index * 56 + 19),
      parent = self.pageButList.listLayer,
      z = -1
    })
    local tableName = ed.createLabelTools({
      txt = T(info["Tab Name"]),
      size = 20,
      pos = ccp(82.5, 30),
      color = ed.toccc3(10013898),
      parent = button
    })
    tableName:limitWidthByScale(80)
    local buttonSelected = ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/sweet_party/sweet_party_tab_selected.png",
      pos = ccp(74.5, thisCon.height - index * 56 + 19),
      parent = self.pageButList.listLayer,
      notShow = self.index ~= index,
      z = -1
    })
    local selectedTableName = ed.createLabelTools({
      txt = T(info["Tab Name"]),
      size = 20,
      pos = ccp(82.5, 30),
      color = ed.toccc3(7490068),
      parent = buttonSelected
    })
    selectedTableName:limitWidthByScale(100)
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

function sweetPartyScene:registerEvents()
  ed.UITool.registerBtn(self, "img_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ed.sweetPartyManager.rule
    }):popWindow()
  end)
  ed.UITool.registerBtn(self, "img_close", function()
    ed.popScene()
    ed.sweetPartyManager:closeWindow()
  end, {normalScale = 0.8, pressScale = 0.75})
  self:listenEvent("refreshSweetPartyScene", function(data)
    self:refreshUI(data.type)
  end)
  self:registerOnEnterHandler("sweetPartySceneOnEnter", function()
    ed.sweetPartyNetwork:sendOpenPanel()
  end)
  self:listenEvent("midas_reply", function(_)
    ed.sweetPartyNetwork:sendOpenPanel()
  end)
  self:listenEvent("CloseChatMainWin", function(_)
    ed.sweetPartyNetwork:sendOpenPanel()
  end)
end

function sweetPartyScene:refreshUI(type)
  if type == "openPanel" or type == "taskRewards" or type == "lineRewards" then
    local time = ed.sweetPartyManager.totalEndTime - ed.getServerTime()
    ed.setString(self.ui.Label_time, ed.time2dhms(time))
    self:refreshTop()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:refreshLeft()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:refreshRight()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:adjustLineRewardPos()
  end
end

function sweetPartyScene:refreshTop()
  if not self.progressBox then
    self:initTop()
    self:createLeftFashionName()
  end
  local curProgress = ed.sweetPartyManager.curProgress
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
      local taskState = ed.sweetPartyManager:getLineItemsState(item.param.data.ID)
      item:refresh(imgType[taskState])
    end
    local taskState = ed.sweetPartyManager:getLineItemsState(self.topRightItem.param.data.ID)
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
      local taskState = ed.sweetPartyManager:getLineItemsState(self.topRightItem.param.data.ID)
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
        local taskState = ed.sweetPartyManager:getLineItemsState(item.param.data.ID)
        item:refresh(imgType[taskState])
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
          local taskState = ed.sweetPartyManager:getLineItemsState(item.param.data.ID)
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

function sweetPartyScene:refreshLeft()
  local data = ed.sweetPartyManager:getSweetPartyTask()
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
  local posy = self.thisCon.height - 12 - 34.25
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
      posy = posy - 68.5 - 4
      table.insert(self.taskItems, item)
      self.taskItems[data[index].id] = item
      index = index + 1
    end, 0.01)
    self.taskDragList:initListHeight(#data * 72.5 + 12)
  else
    for i, v in ipairs(data) do
      local item = self.taskItems[v.id]
      local y = posy - 72.5 * (i - 1)
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

function sweetPartyScene:refreshRight()
  for _, v in ipairs(self.btnPages) do
    v.buttonSelected:setVisible(v.data["Tab ID"] == self.index)
    v.red:setVisible(ed.sweetPartyManager:getReds(v.data["Tab ID"]) > 0)
  end
end

function sweetPartyScene:adjustLineRewardPos()
  local idx = 0
  for i, item in ipairs(self.lineItems) do
    local imgType = {
      [1] = 0,
      [3] = 1,
      [2] = 2
    }
    local taskState = ed.sweetPartyManager:getLineItemsState(item.param.data.ID)
    if taskState == 3 and idx == 0 then
      idx = i
      break
    end
  end
  if idx ~= 0 and 5 < idx then
    idx = idx > #self.lineItems - 3 and #self.lineItems - 3 or idx
    self.lineItemList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.3, ccp((idx - 3) * -76 - 30, 0))))
  end
end

function sweetPartyScene:doPressInList()
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
      self.topRightItem.icon:setScale(0.95)
      return {
        icon = self.topRightItem.icon,
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
                ed.sweetPartyNetwork:sendGetLineReward(param.data.ID)
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
            ed.sweetPartyNetwork:sendGetTaskReward(param.id)
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

function sweetPartyScene:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function sweetPartyScene:cancelClickInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function sweetPartyScene:doClickInList()
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
    res = "UI/alpha/1080P/activity/sweet_party/sweet_party_task_bg_2.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local highlightBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/sweet_party/sweet_party_task_bg_1.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local shieldImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/sweet_party/sweet_party_shield.png",
    pos = ccp(0, 0),
    rectMake = CCRectMake(6.5, 6.25, 20, 56),
    sizeMake = CCSizeMake(492, 68.5),
    parent = Layer,
    opacity = 102
  })
  local getBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    parent = highlightBg,
    pos = ccp(422, 34.25)
  })
  ed.createLabelTools({
    txt = T("\233\162\134\229\143\150"),
    size = 18,
    pos = ccp(50.75, 20.75),
    color = ed.toccc3(16776678),
    parent = getBtn
  })
  local goBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_mini_sys.png",
    parent = bg,
    pos = ccp(422, 34.25)
  })
  ed.createLabelTools({
    txt = T("\229\137\141\229\190\128"),
    size = 18,
    pos = ccp(50.75, 20.75),
    color = ed.toccc3(16776678),
    parent = goBtn
  })
  ed.createLabelTools({
    txt = T("\229\183\178\229\174\140\230\136\144"),
    size = 16,
    pos = ccp(50.75, 30),
    color = ccc3(111, 94, 71),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/sweet_party/sweet_party_task done.png",
      parent = shieldImg,
      pos = ccp(422, 34.25)
    })
  })
  local desc = ed.createLabelTools({
    txt = T(param.detail),
    size = 16,
    pos = ccp(-230, 15),
    color = ed.toccc3(16776423),
    parent = Layer,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#433B38")),
      1
    }
  })
  desc:limitSizeByScale(240, 50)
  desc:setHorizontalAlignment(kCCTextAlignmentLeft)
  local progresslabel = ed.createLabelTools({
    txt = T("\229\174\140\230\136\144\232\191\155\229\186\166(%d/%d)", param.progress, param.target),
    size = 14,
    pos = ccp(-230, -14),
    color = ed.toccc3(4406072),
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
    item.icon:setPosition(-20 + 55 * i, 0)
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
    progresslabel = progresslabel
  }
  self:update(param)
end

function itemModule:update(param, index)
  self.param = param
  self.index = index or self.index
  self.ui.bg:setVisible(param.taskState ~= 3)
  self.ui.highlightBg:setVisible(param.taskState == 3)
  self.ui.shieldImg:setVisible(param.taskState == 2)
  self.ui.goBtn:setVisible(param.taskState ~= 2)
  self.ui.getBtn:setVisible(param.taskState == 3)
  self.ui.progresslabel:setString(T("\229\174\140\230\136\144\232\191\155\229\186\166(%d/%d)", param.progress, param.target))
  local imgType = {
    [1] = 0,
    [3] = 1,
    [2] = 2
  }
  for _, v in ipairs(self.items) do
    v:refresh(imgType[param.taskState])
  end
end

function itemModule:btRegisterButtonClickToListItems(param)
end

sweetPartyScene.itemModule = itemModule
