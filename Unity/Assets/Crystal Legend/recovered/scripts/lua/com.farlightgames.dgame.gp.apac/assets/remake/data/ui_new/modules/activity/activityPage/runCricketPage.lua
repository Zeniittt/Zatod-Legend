local runCricketPage = newclass("g")
ed.ui.runCricketPage = runCricketPage

function runCricketPage.create(base, param, pageKey)
  local this = {}
  setmetatable(runCricketPage, {__index = base})
  setmetatable(this, {__index = runCricketPage})
  local container, ui = ed.editorui(ed.uieditor.activity_runcricket_page)
  this.ui = ui
  this.pageKey = pageKey or ""
  this.container = container
  this.param = param
  this.index = 1
  this:initView()
  return this
end

function runCricketPage:initView()
  self.ui.ImageView_2668:setPositionX(self.ui.ImageView_2668:getPositionX() - ed.display.halfFixedWidth * 0.4)
  self.ui.ImageView_card:setPositionX(self.ui.ImageView_card:getPositionX() - ed.display.halfFixedWidth * 0.4)
  self.ui.ImageView_time:setPositionX(self.ui.ImageView_time:getPositionX() - ed.display.halfFixedWidth * 0.4)
  ed.setLabelStroke(self.ui.Label_2663, ed.toccc3(2524436), 2)
  ed.setLabelStroke(self.ui.Label_2663, ed.toccc3(2524436), 2)
  ed.setLabelStroke(self.ui.Label_time, ed.toccc3(2524436), 2)
  ed.setLabelStroke(self.ui.Label_2678, ed.toccc3(8608000), 2)
  ed.setLabelFontName(self.ui.Label_2678, ed.fontBold)
  self:initRight()
  self:initLeft()
  self:listenEvent("refreshrunCricketScene", function(data)
    self:refreshUI(data.type)
  end)
  self:registerOnEnterHandler("runCricketPageOnEnter", function()
    ed.ActivityNetwork:sendSoloOpenPanel()
  end)
  ed.ActivityNetwork:sendSoloOpenPanel()
  ed.UITool.registerBtn(self, "ImageView_goto", function()
    ed.UITool.openView("SoloArenaScene")
  end, {pressScale = 0.8, normalScale = 0.85})
end

function runCricketPage:refreshUI(type)
  if type == "openPanel" or type == "taskRewards" or type == "lineRewards" then
    local time = ed.runCricketManager.totalEndTime - ed.getServerTime()
    ed.setString(self.ui.Label_time, ed.time2dhms(time))
    if ed.runCricketManager.curDay <= 0 then
      local time = ed.getYMDHMS(ed.runCricketManager.activeTime)
      ed.setString(self.ui.Label_time, string.format("%d/%d/%d", time.year, time.month, time.day))
      self.ui.ImageView_end:setVisible(false)
      self.ui.ImageView_open:setVisible(true)
      self.ui.Label_shader:setString(T("\230\180\187\229\138\168%s\229\188\128\229\144\175 ", string.format("%d\230\156\136%d\229\143\183", time.month, time.day)))
      self.ui.ImageView_shader:setVisible(true)
    end
    self:refreshTop()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:refreshLeft()
  end
  if type == "openPanel" or type == "taskRewards" then
    self:refreshRight()
  end
  self:onSceneEnter()
end

function runCricketPage:refreshTop()
  local init
  if not self.progressBox then
    self:initTop()
    init = true
  end
  local curProgressMax
  for i, item in ipairs(self.lineItems) do
    local taskState = ed.runCricketManager:getLineItemsState(item.param.ID)
    item:update(taskState)
    if ed.runCricketManager.curProgress < item.param["Require Task Count"] and not curProgressMax then
      curProgressMax = item.param["Require Task Count"]
      local progresss = {
        58,
        73,
        100
      }
      local progress = ed.runCricketManager.curProgress / curProgressMax * progresss[i]
      if init then
        self.dayProgress:setPercentage(progress)
      else
        self.dayProgress:runAction(CCProgressTo:create(0.5, progress))
      end
    end
  end
end

function runCricketPage:initTop()
  local progress = CCProgressTimer:create(self.ui.progress_img)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setPosition(self.ui.progress_img:getPosition())
  self.ui.page_lay:addChild(progress)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  self.dayProgress = progress
  local lineItem = ed.runCricketManager:getLineItems()
  lineItem = ed.copyTable(lineItem)
  table.sort(lineItem, function(a, b)
    return a["Require Task Count"] < b["Require Task Count"]
  end)
  local rightItem = {}
  self.lineItems = {}
  local posx = 555
  for index, data in ipairs(lineItem) do
    local item = self.lineItemModule.create(self, data, index)
    item.ui.Layer:setPosition(posx, 450)
    self.ui.page_lay:addChild(item.ui.Layer)
    posx = posx + 135
    self.lineItems[index] = item
  end
end

function runCricketPage:refreshRight()
  for _, v in ipairs(self.btnPages) do
    v.buttonSelected:setVisible(v.data["Tab ID"] == self.index)
    v.red:setVisible(ed.runCricketManager:getReds(v.data["Tab ID"]) > 0)
    v.lock:setVisible(ed.runCricketManager:getTaskTabLock(v.data["Tab ID"]))
  end
end

function runCricketPage:initRight()
  self.pageBtnList = ed.UITool.createDraglist(self.ui.Panel_btns, {
    doPressIn = function(x, y)
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
    end,
    doClickIn = function(x, y, info)
      if info.fun then
        info.icon:setScale(1)
        info.fun(info.param or {})
      end
    end,
    cancelClickIn = function(x, y, info)
      info.icon:setScale(1)
    end,
    cancelPressIn = function(x, y, info)
      info.icon:setScale(1)
    end
  })
  local thisCon = self.ui.Panel_btns:getContentSize()
  local btnInfos = ed.runCricketManager:getTaskTab()
  self.btnPages = {}
  for index, info in ipairs(btnInfos) do
    local button = ed.createSpriteTools({
      res = "UI/alpha/1080P/chesscard/sevenday/button_1.png",
      pos = ccp(78.5, thisCon.height - index * 50 + 19),
      parent = self.pageBtnList.listLayer,
      z = -1
    })
    ed.createLabelTools({
      txt = T(info["Tab ID"]),
      size = 24,
      pos = ccp(64.5, 22.5),
      color = ed.toccc3(13151895),
      font = ed.fontBold,
      parent = button
    })
    ed.createLabelTools({
      txt = T("\231\172\172   \229\164\169"),
      size = 16,
      pos = ccp(64.5, 22.5),
      color = ed.toccc3(12229759),
      parent = button
    })
    local lock = ed.createSpriteTools({
      res = "UI/alpha/1080P/chesscard/sevenday/lock_2.png",
      pos = ccp(7, 36),
      parent = button,
      notShow = not info.islock
    })
    local buttonSelected = ed.createSpriteTools({
      res = "UI/alpha/1080P/chesscard/sevenday/button_2.png",
      pos = ccp(72.5, thisCon.height - index * 50 + 19),
      parent = self.pageBtnList.listLayer,
      notShow = self.index ~= index,
      z = -1
    })
    ed.createLabelTools({
      txt = T(info["Tab ID"]),
      size = 24,
      pos = ccp(78.5, 28),
      color = ed.toccc3(6962469),
      font = ed.fontBold,
      parent = buttonSelected
    })
    ed.createLabelTools({
      txt = T("\231\172\172   \229\164\169"),
      size = 16,
      pos = ccp(78.5, 28),
      color = ed.toccc3(7490068),
      parent = buttonSelected
    })
    local red = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      pos = ccp(138, thisCon.height - index * 50 + 40),
      parent = self.pageBtnList.listLayer,
      z = -1,
      notShow = true
    })
    self.btnPages[index] = {
      button = button,
      buttonSelected = buttonSelected,
      red = red,
      lock = lock,
      data = info
    }
  end
  self.pageBtnList:initListHeight(#btnInfos * 50 + 10)
end

function runCricketPage:initLeft()
  self.thisCon = self.ui.Panel_item:getContentSize()
  self.taskDragList = ed.UITool.createDraglist(self.ui.Panel_item, {
    doPressIn = function(x, y)
      for _, v in pairs(self.taskItems) do
        if v.ui.arrows:isVisible() and (ed.containsPoint(v.ui.arrows, x, y) or ed.containsPoint(v.ui.progress, x, y)) then
          return {
            icon = v.ui.arrows,
            fun = function(param)
              ed.UITool.openView("SoloArenaScene")
            end,
            param = v.param,
            normalScale = 1
          }
        else
          for _, vv in ipairs(v.items) do
            if ed.containsPoint(vv.icon, x, y) then
              vv.icon:setScale(0.75)
              return {
                icon = vv.icon,
                fun = function(param)
                  if param.param.taskState == 3 then
                    ed.ActivityNetwork:sendSoloGetTaskReward(param.param.id)
                  else
                    ed.ui.packageDetailWin.create(param.item):popWindow()
                  end
                end,
                param = {
                  item = vv.param,
                  param = v.param
                },
                normalScale = 0.8
              }
            end
          end
        end
      end
    end,
    doClickIn = function(x, y, info)
      if info.fun then
        info.icon:setScale(info.normalScale or 1)
        info.fun(info.param or {})
      end
    end,
    cancelClickIn = function(x, y, info)
      info.icon:setScale(info.normalScale or 1)
    end,
    cancelPressIn = function(x, y, info)
      info.icon:setScale(info.normalScale or 1)
    end,
    noshade = true,
    priority = -300
  })
end

function runCricketPage:refreshLeft()
  local data = ed.runCricketManager:getrunCricketTask()
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
  local posy = self.thisCon.height - 12 - 40
  local isInit = not self.oldIdx or self.oldIdx ~= self.index
  self.oldIdx = self.index
  if isInit or not self.taskItems then
    self.listOver = false
    self.taskItems = {}
    self.taskDragList:clearList()
    self.ui.Panel_item:stopAllActions()
    local index = 1
    local indexMax = 1
    ed.timeSchedule(self.ui.Panel_item, function()
      if not data[index] or 200 < indexMax then
        self.ui.Panel_item:stopAllActions()
        self.listOver = true
        return
      end
      indexMax = indexMax + 1
      local item = self.itemModule.create(self, data[index], index)
      self.taskDragList:addItem(item.ui.Layer, ccp(self.thisCon.width / 2 + 2, posy + 4))
      posy = posy - 80 - 4
      table.insert(self.taskItems, item)
      self.taskItems[data[index].id] = item
      index = index + 1
    end, 0.01)
    self.taskDragList:initListHeight(#data * 84 + 10)
  else
    for i, v in ipairs(data) do
      local item = self.taskItems[v.id]
      if item then
        local y = posy - 84 * (i - 1)
        if item.index ~= i then
          if i < item.index then
            item.ui.Layer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.5, ccp(self.thisCon.width / 2 + 2, y + 4))))
          else
            item.ui.Layer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.5, ccp(self.thisCon.width / 2 + 2, y + 4))))
          end
        end
        item:update(v, i)
      end
    end
  end
end

local lineItemModule = {}

function lineItemModule.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = lineItemModule})
  this:init(param)
  return this
end

function lineItemModule:init(param)
  local Layer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0)
  })
  local item = ed.taskItemModule.new(self, {
    id = self.param["Reward ID 1"],
    type = self.param["Reward Type 1"],
    amount = self.param["Reward Amount 1"],
    data = self.param
  }, nil, self.index, false, false, true)
  item.icon:setScale(0.8)
  item.icon:setPosition(0, 0)
  Layer:addChild(item.icon)
  self.item = item
  local stateLayer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0),
    parent = Layer
  })
  self.ui = {Layer = Layer, stateLayer = stateLayer}
  self:update(param.taskState)
end

lineItemModule.detailColor = {
  {
    color = ed.toccc3(16773603),
    stroke = {
      ccc3(ed.colorToStr("#144034")),
      1.5
    }
  },
  {
    color = ed.toccc3(9624493),
    stroke = {
      ccc3(ed.colorToStr("#144034")),
      1.5
    }
  },
  {
    color = ed.toccc3(16773786),
    stroke = {
      ccc3(ed.colorToStr("#a26b0b")),
      1.5
    }
  }
}

function lineItemModule:update(taskState)
  self.param.taskState = taskState
  local imgType = {
    [1] = 0,
    [3] = 1,
    [2] = 2
  }
  self.item:refresh(imgType[self.param.taskState or 1])
  local imgType = {
    [1] = 1,
    [3] = 2,
    [2] = 3
  }
  self.ui.stateLayer:removeAllChildrenWithCleanup(true)
  ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/chesscard/sevenday/text_%d.png", self.param.taskState == 3 and 2 or 1),
    pos = ccp(0, -48),
    parent = self.ui.stateLayer
  })
  ed.createLabelTools({
    txt = string.format("\229\174\140\230\136\144%d/%d", ed.runCricketManager.curProgress, self.param["Require Task Count"]),
    size = 16,
    pos = ccp(0, -48),
    color = self.detailColor[self.param.taskState].color,
    parent = self.ui.stateLayer,
    stroke = self.detailColor[self.param.taskState].stroke,
    font = ed.fontBold
  })
  ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/chesscard/sevenday/decoration_%d.png", imgType[self.param.taskState or 1]),
    pos = ccp(0, 0),
    parent = self.ui.stateLayer
  })
end

function lineItemModule:btRegisterButtonClickToListItems(param)
  self.mainSelf:btRegisterButtonClick({
    button = param.button,
    key = "runCricketPageItem_" .. param.index,
    param = param,
    clickInterval = 1,
    clickHandler = function(param, x, y)
      if self.param.taskState == 3 then
        ed.ActivityNetwork:sendSoloGetLineReward(self.param.ID)
      else
        ed.UITool.openView("packageDetail", param.data or {})
      end
    end,
    force = true,
    pressScale = 0.78,
    normalScale = 0.8
  })
end

runCricketPage.lineItemModule = lineItemModule
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
    res = "UI/alpha/1080P/chesscard/sevenday/task_1.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local highlightBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/sevenday/task_2.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local shieldImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/sevenday/task_3.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local progress = ed.createLabelTools({
    txt = T("%d/%d", self.param.progress, self.param.target),
    size = 15,
    pos = ccp(117, 0),
    color = ed.toccc3(3177540),
    parent = Layer,
    z = 99
  })
  local arrows = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/sevenday/arrow.png",
    pos = ccp(150, 0),
    parent = Layer,
    z = 99
  })
  arrows:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(-5, 0)), CCMoveBy:create(0.7, ccp(5, 0)))))
  self.items = {}
  for i, v in ipairs(param.items) do
    local item = ed.taskItemModule.new(self, {
      id = v.id,
      type = v.type,
      amount = v.amount
    }, nil, param._id, false, false, true)
    item.icon:setPosition(-40 + 83 * i, 0)
    Layer:addChild(item.icon, 99)
    table.insert(self.items, item)
  end
  self.ui = {
    Layer = Layer,
    bg = bg,
    highlightBg = highlightBg,
    shieldImg = shieldImg,
    arrows = arrows,
    progress = progress
  }
  self:update(param)
end

function itemModule:update(param, index)
  self.param = param
  self.index = index or self.index
  self.ui.bg:setVisible(param.taskState == 1)
  self.ui.shieldImg:setVisible(param.taskState == 2)
  self.ui.highlightBg:setVisible(param.taskState == 3)
  local imgType = {
    [1] = 0,
    [3] = 1,
    [2] = 2
  }
  for _, v in ipairs(self.items) do
    v:refresh(imgType[param.taskState])
  end
  self.ui.arrows:setVisible(param.taskState ~= 2)
  self.ui.progress:setVisible(param.taskState ~= 2)
  self.ui.progress:setString(T("%d/%d", self.param.progress, self.param.target))
  self.ui.progress:setColor(param.taskState == 1 and ed.toccc3(3810067) or ed.toccc3(3177540))
  if self.ui.detaillabel then
    self.ui.detaillabel.node:removeFromParentAndCleanup(true)
  end
  local color = param.taskState == 2 and ed.toccc3(2758925) or ed.toccc3(4467224)
  local detaillabel = ed.ui.autoText.new()
  detaillabel:initParam({
    context = ed.activityTaskTool.getRunCricketTaskDesc(param),
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = 155,
    color = color
  })
  self.ui.Layer:addChild(detaillabel.node, 99)
  local w, h = detaillabel:getCurContentSize()
  detaillabel.node:setPosition(-150, h / 2 - 12)
  self.ui.detaillabel = detaillabel
end

runCricketPage.itemModule = itemModule

function runCricketPage:pageUpDate(param)
end

function runCricketPage:onSceneEnter()
  ed.runCricketManager:closeWindow()
  ed.activityHints:updateReds({
    _act_id = self.param._id
  })
end
