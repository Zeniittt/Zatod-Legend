local page = {}

function page.create(sceneSelf, dataObj)
  local container, ui = ed.editorui(ed.uieditor.roleTaskLaye)
  return setmetatable({
    sceneSelf = sceneSelf,
    dataObj = dataObj,
    container = container,
    ui = ui,
    index = 1,
    dailyItemSize = {width = 760, height = 70}
  }, {__index = page}):init()
end

function page:init()
  self:uiCreate()
  self:dragListCreate()
  self:registerEvents()
  self:registerBtnEvents()
  return self
end

function page:registerEvents()
  self.sceneSelf:listenEvent("roleTaskReply", function(refreshType)
    self:refreshpage(refreshType)
  end)
  self.sceneSelf:listenEvent("triggerTaskReply", function(data)
    self:triggerTaskReply(data)
  end)
end

function page:triggerTaskReply(data)
  self:refreshpage("triggerTaskReply")
end

function page:refreshpage(refreshType)
  if refreshType and refreshType == "netreplyRewards" then
    local list, msgTask = ed.taskData.taskList:refreshTaskList()
    if #msgTask == 0 then
      local task = {}
      for k, v in pairs(list) do
        local t = ed.taskData.taskList:initTaskListData(v)
        if t then
          t = ed.taskData.taskList:createTaskList(t)
          if t then
            table.insert(task, t)
          end
        end
      end
      task = ed.taskData.taskList:orderList(task)
      self.listData = task
      if 0 < #task then
        self:dragListRefresh()
      else
        self.items = {}
        self.allItems = {}
        self.dragList:clearList()
      end
    end
  else
    local list, msgTask = ed.taskData.taskList:refreshTaskList()
    local task = {}
    for k, v in pairs(list) do
      local t = ed.taskData.taskList:initTaskListData(v)
      if t then
        t = ed.taskData.taskList:createTaskList(t)
        if t then
          table.insert(task, t)
        end
      end
    end
    task = ed.taskData.taskList:orderList(task)
    self.listData = task
    if 0 < #task then
      self:dragListRefresh()
    else
      self.items = {}
      self.allItems = {}
      self.dragList:clearList()
    end
  end
end

function page:onEnterScene()
  self:refreshpage("triggerTaskReply")
end

function page:dragListRefresh()
  if self.items then
    local function func(layer)
      return function()
        layer:removeFromParentAndCleanup(true)
      end
    end
    
    local function funcVis(layer)
      return function()
        layer:setVisible(true)
      end
    end
    
    local newShow, addShow = {}, {}
    for i, v in ipairs(self.listData) do
      local info = v.info
      newShow[info.chain] = newShow[info.chain] or {}
      newShow[info.chain][info.id] = info
    end
    local newAddItem = {}
    for i, v in ipairs(self.allItems) do
      local info = v.param
      if newShow[info.chain] and newShow[info.chain][info.id] then
        v.param = newShow[info.chain][info.id]
        table.insert(newAddItem, v)
      else
        self.items[info.chain][info.id] = nil
        table.remove(self.dragList.listItems, i)
        v.layer:runAction(CCSequence:create(ccArrayMake(unpack({
          CCEaseExponentialIn:create(CCScaleTo:create(0.2, 0.9, 0.1)),
          CCCallFunc:create(func(v.layer))
        }))))
      end
    end
    self.allItems = newAddItem
    local thisCon = self.ui.task_list_pos:getContentSize()
    for i, v in ipairs(self.listData) do
      local info = v.info
      if self.items[info.chain] and self.items[info.chain][info.id] then
      else
        local fb = ed.basetask.createFastButton(self.sceneSelf, info, {isNocreateButton = true})
        info.fastEntry = fb.handler
        info.indexNum = i
        local item = ed.taskListItemLayModule.new(self, info, self.dailyItemSize)
        self.dragList:addItem(item.layer, ccp(self.dailyItemSize.width / 2 + 10, thisCon.height - i * (self.dailyItemSize.height + 2) + self.dailyItemSize.height / 2 - 10))
        item.layer:setScaleX(0.9)
        item.layer:setScaleY(0.1)
        item.layer:setVisible(false)
        item.layer:runAction(CCSequence:create(ccArrayMake(unpack({
          CCDelayTime:create(0.2),
          CCCallFunc:create(funcVis(item.layer)),
          CCEaseExponentialOut:create(CCScaleTo:create(0.2, 1))
        }))))
        table.insert(self.allItems, i, item)
        table.insert(addShow, i, v)
        self.items[info.chain] = self.items[info.chain] or {}
        self.items[info.chain][info.id] = item
      end
    end
    for i, v in ipairs(self.allItems) do
      local fb = ed.basetask.createFastButton(self.sceneSelf, v.param, {isNocreateButton = true})
      v.param.fastEntry = fb.handler
      v.param.indexNum = i
      v:refresh(v.param)
      v.layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(self.dailyItemSize.width / 2 + 10, thisCon.height - i * (self.dailyItemSize.height + 2) + self.dailyItemSize.height / 2 - 10))))
    end
    local newHeight = #self.dragList.listItems * (self.dailyItemSize.height + 2) + 20
    if self.dragList.listHeight ~= newHeight then
      self.dragList:initListHeight(newHeight)
    end
  else
    self.dragList:clearList()
    local thisCon = self.ui.task_list_pos:getContentSize()
    self.items = {}
    self.allItems = {}
    for i, v in ipairs(self.listData) do
      local info = v.info
      local fb = ed.basetask.createFastButton(self.sceneSelf, info, {isNocreateButton = true})
      info.fastEntry = fb.handler
      info.indexNum = i
      local item = ed.taskListItemLayModule.new(self, info, self.dailyItemSize)
      self.dragList:addItem(item.layer, ccp(self.dailyItemSize.width / 2 + 10, thisCon.height - i * (self.dailyItemSize.height + 2) + self.dailyItemSize.height / 2 - 10))
      self.items[info.chain] = self.items[info.chain] or {}
      self.items[info.chain][info.id] = item
      self.allItems[i] = item
    end
    self.dragList:initListHeight(#self.dragList.listItems * (self.dailyItemSize.height + 2) + 20)
  end
  local minScale = 1
  for i, v in ipairs(self.allItems) do
    minScale = math.min(minScale, v:getDetailLabelScale())
  end
  if minScale < 1 then
    for k, v in ipairs(self.allItems) do
      v:adaptDetailLabelScale(minScale)
    end
  end
end

function page:uiCreate()
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local ui = self.ui
  newWid = newWid * 0.7
  newHei = newHei * 0
  
  local function posfunc(ui, isLeft, isDown)
    local newx, newy = isLeft and newWid / 2 * -1 or newWid / 2, isDown and newHei / 2 * -1 or newHei / 2
    local x, y = ui:getPosition()
    ui:setPosition(x + newx, y + newy)
  end
  
  local function sizefunc(ui)
    local size = ui:getContentSize()
    ui:setContentSize(CCSizeMake(size.width + newWid, size.height + newHei))
  end
  
  posfunc(ui.task_list_pos, true)
  sizefunc(ui.task_list_pos)
  self.dailyItemSize.halfFixedWidth = newWid
  self.dailyItemSize.width = self.dailyItemSize.width + newWid
end

function page:dragListCreate()
  local thisCon = self.ui.task_list_pos:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.task_list_pos,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 20
    end
  }
  self.dragList = ed.draglist.create(info)
  self.dragList:setUpdateListItemVisibleEnable(true)
  self:refreshpage()
end

function page:pushDailyjobReward(param)
  ed.taskNetwork:requireRewards(param.chain, param.id)
end

local function btRegisterButtonClickToListItems()
  return function(self, param)
    self.sceneSelf:btRegisterButtonClick({
      button = param.button,
      key = "role_page_items" .. self.index,
      radioGroupName = "items",
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.task_list_pos, x, y) then
          print("not list pos")
          return
        end
        if self.touch then
          local data = param.data or {}
          ed.ui.packageDetailWin.create(data):popWindow()
        end
      end,
      force = true,
      pressScale = 0.75,
      normalScale = 0.8
    })
    self.index = self.index + 1
  end
end

page.btRegisterButtonClickToListItems = btRegisterButtonClickToListItems()

function page:registerBtnEvents()
end

function page:getTaskRewardReceiveBtn(taskLine, taskID)
  if self.items and self.items[taskLine] and self.items[taskLine][taskID] and self.items[taskLine][taskID].param.refreshType == 3 then
    return self.items[taskLine][taskID].ui.buttonImg
  end
  return
end

function page:delete()
  CloseEvent("roleTaskReply")
  CloseEvent("triggerTaskReply")
end

return page
