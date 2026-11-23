local base = ed.ui.popwindow
local heroHaggleTaskWin = newclass(base.mt)
ed.ui.heroHaggleTaskWin = heroHaggleTaskWin
ed.UITool.registViewOpenFunc("OpenHeroHaggleTaskWin", function(data)
  ed.ui.heroHaggleTaskWin.create(data)
end)
local taskBg = {
  [3] = {
    bgPath = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_bar_2.png"
  },
  [2] = {
    bgPath = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_bar_3.png"
  },
  [1] = {
    bgPath = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_bar_1.png"
  }
}

function heroHaggleTaskWin.create(data)
  local self = base.create("heroHaggleTaskWin")
  setmetatable(self, heroHaggleTaskWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function heroHaggleTaskWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.heroHaggleTaskWin)
  self.ui = ui
  self.container:addChild(container)
  self:initLabel()
  self:dragListCreate()
end

function heroHaggleTaskWin:initData(data)
  self.initDone = false
  self:updateViewData()
end

function heroHaggleTaskWin:updateViewData()
  local mgr = ed.heroHaggleMgr.getInstance()
  local taskTemp = mgr:getTaskList()
  self.cur_task = {}
  for i, v in pairs(taskTemp) do
    table.insert(self.cur_task, v)
  end
  table.sort(self.cur_task, function(a, b)
    local priorityA = a.taskState == 3 and 1 or a.taskState == 2 and 3 or 2
    local priorityB = b.taskState == 3 and 1 or b.taskState == 2 and 3 or 2
    if priorityA ~= priorityB then
      return priorityA < priorityB
    else
      return a.id < b.id
    end
  end)
end

function heroHaggleTaskWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function heroHaggleTaskWin:registerEvents()
  self:listenEvent("EventUpdateHeroHaggleTask", function(state)
    self:updateViewData()
    if state then
      self:staticSync(state)
    else
      self.ui.bg:stopAllActions()
      self.ui.bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCCallFunc:create(function()
        self:staticSync(state)
      end))))
    end
  end)
end

function heroHaggleTaskWin:initLabel()
  ed.setLabelColor(self.ui.label_title, ed.toccc3(16709848))
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(9592892), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
end

function heroHaggleTaskWin:createTaskTableView()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.cur_task
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(578, 79)
    end,
    createCell = function(index)
      return self:createTaskItem(index, self.cur_task[index])
    end,
    syncCell = function(cell, index)
      local container, ui = self:createTaskItem(index, self.cur_task[index])
      return container
    end,
    doPressIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        if ui.btn_detail:isVisible() and ed.containsPoint(ui.btn_detail, x, y) then
          ui.btn_detail:setScale(0.95)
          return cell
        end
        if ui.layer_go:isVisible() and ed.containsPoint(ui.layer_go, x, y) then
          ui.ImageView_36585:setScale(0.95)
          return cell
        end
      end
    end,
    doClickIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        if ui.btn_detail:isVisible() and ed.containsPoint(ui.btn_detail, x, y) then
          local taskConfig = self.cur_task[cell.idx]
          self.targetIndex = cell.idx
          ui.bg:runAction(CCSequence:create(ccArrayMake(unpack({
            CCEaseExponentialIn:create(CCScaleTo:create(0.2, 0.9, 0.1)),
            CCCallFunc:create(function()
              if taskConfig then
                ed.heroHaggleNet:sendGetTaskReward(taskConfig.id)
                local config = ed.getDataTable("SimpleAssistTask")[taskConfig.id]
                self.taskGroupIndex = config["Task Group"]
              end
            end)
          }))))
        end
        if ui.layer_go:isVisible() and ed.containsPoint(ui.layer_go, x, y) then
          local taskConfig = self.cur_task[cell.idx]
          if taskConfig then
            ed.activityTaskTool.taskSkip(taskConfig.progressType, {})
          end
        end
      end
    end,
    cancelPressIn = function(cell)
      local ui = cell.data
      if ui then
        ui.btn_detail:setScale(1)
        ui.ImageView_36585:setScale(0.95)
      end
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 5, size.width, size.height),
    dragMode = 1,
    colNum = 1,
    zorder = 999,
    touchpriority = -300,
    noshade = true,
    padding = {0, height = 9},
    offset = {300, 30}
  }
  self.taskTableview = Tableview.create(param)
  self.taskTableview:reloadData()
  self.targetIndex = 0
end

function heroHaggleTaskWin:updateTaskItem(ui, index, data)
  ui.idx = index
  ed.setLabelColor(ui.label_task_name, ed.toccc3(16776423))
  ed.setLabelStroke(ui.label_task_name, ed.toccc3(9057072), 1)
  ed.setLabelColor(ui.Label_36584, ed.toccc3(16776423))
  ed.setLabelStroke(ui.Label_36584, ed.toccc3(9057072), 1)
  ed.setLabelColor(ui.label_des, ed.toccc3(16776423))
  ed.setLabelStroke(ui.label_des, ed.toccc3(9057072), 1)
  ed.setLabelString(ui.label_task_name, data.detail)
  ui.label_task_name:limitWidthBySize(230)
  self:createRewardItemList(ui, ui.layer_reward, data.items, data.taskState)
  local rewardState = data.taskState
  if ui.bg and taskBg[rewardState or 1] then
    ed.setTexture(ui.bg, taskBg[rewardState or 1].bgPath)
  end
  if rewardState == 2 then
    ed.createLabelTools({
      txt = T("\229\183\178\229\174\140\230\136\144"),
      size = 16,
      pos = ccp(50.75, 30),
      color = ccc3(111, 94, 71),
      parent = ed.createSpriteTools({
        res = "UI/alpha/1080P/taskModel/day_task/daily_task_pass.png",
        parent = ui.layer_task_done,
        pos = ccp(0, 0)
      })
    })
  elseif rewardState == 1 then
    ed.setString(ui.Label_36584, string.format("%d/%d", data.progress, data.target))
  end
  ui.layer_go:setVisible(rewardState == 1)
  ui.Label_36584:setVisible(rewardState == 1)
  ui.ImageView_36585:setVisible(rewardState == 1)
  ui.btn_detail:setVisible(rewardState == 3)
end

function heroHaggleTaskWin:createTaskItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.heroHaggleTaskItem)
  container:setContentSize(ui.bg:getContentSize())
  self:updateTaskItem(ui, index, data)
  return container, ui
end

function heroHaggleTaskWin:createRewardItemList(ui, container, rewardList, taskState)
  local itemList = {}
  if ui.rewardDragList == nil then
    ui.rewardDragList = ed.UITool.createDraglist(container, {
      doPressIn = function(x, y)
        if not ed.containsPoint2(self.ui.panel_record, x, y, 0.98) then
          return
        end
        if not ed.containsPoint(container, x, y) then
          return
        end
        for k, v in pairs(itemList) do
          if ed.containsPoint2(v.icon, x, y, 0.75) then
            return v
          end
        end
      end,
      doClickIn = function(x, y, v)
        local itemData = v.itemData
        if not ed.containsPoint(container, x, y) then
          return
        end
        if v.icon:isVisible() and ed.containsPoint(v.icon, x, y) then
          ed.ui.packageDetailWin.create({
            id = itemData.id,
            count = itemData.amount,
            type = itemData.type
          }):popWindow()
        end
      end,
      priority = -300
    })
    local posX, gapX = 0, -20
    for _, itemData in ipairs(rewardList) do
      local icon = self:createItemIcon({
        id = itemData.id,
        type = itemData.type,
        amount = itemData.amount,
        rewardState = taskState
      })
      local iconSize = icon:getContentSize()
      ui.rewardDragList:addItem(icon)
      icon:setPosition(ccp(iconSize.width / 2 + posX + 44, iconSize.height / 2 - 15))
      icon:setScale(0.75)
      posX = posX + iconSize.width + gapX
      table.insert(itemList, {icon = icon, itemData = itemData})
    end
    ui.rewardDragList:initListWidth(posX)
  else
    ui.rewardDragList:clearList()
    ui.rewardDragList = ed.UITool.createDraglist(container, {
      doPressIn = function(x, y)
        if not ed.containsPoint2(self.ui.panel_record, x, y, 0.98) then
          return
        end
        if not ed.containsPoint(container, x, y) then
          return
        end
        for k, v in pairs(itemList) do
          if ed.containsPoint2(v.icon, x, y, 0.75) then
            return v
          end
        end
      end,
      doClickIn = function(x, y, v)
        local itemData = v.itemData
        if ed.heroHaggleMgr.getInstance().closeHandler then
          return
        end
        if not ed.containsPoint(container, x, y) then
          return
        end
        if v.icon:isVisible() and ed.containsPoint(v.icon, x, y) then
          ed.ui.packageDetailWin.create({
            id = itemData.id,
            count = itemData.amount,
            type = itemData.type
          }):popWindow()
        end
      end,
      priority = -300
    })
    local posX, gapX = 0, -20
    for _, itemData in ipairs(rewardList) do
      local icon = self:createItemIcon({
        id = itemData.id,
        type = itemData.type,
        amount = itemData.amount,
        rewardState = taskState
      })
      local iconSize = icon:getContentSize()
      ui.rewardDragList:addItem(icon)
      icon:setPosition(ccp(iconSize.width / 2 + posX + 44, iconSize.height / 2 - 15))
      icon:setScale(0.75)
      posX = posX + iconSize.width + gapX
      table.insert(itemList, {icon = icon, itemData = itemData})
    end
    ui.rewardDragList:initListWidth(posX)
  end
end

function heroHaggleTaskWin:createItemIcon(itemData)
  local id = itemData.id
  local itemType = itemData.type
  local amount = itemData.amount
  local rewardState = itemData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = itemType,
    amount = amount
  })
  if rewardState == 3 then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  elseif rewardState == 2 then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  end
  return icon
end

function heroHaggleTaskWin:getHaggleTaskNewIndex(id)
  for i, v in ipairs(self.cur_task) do
    if v.id == id then
      return i
    end
  end
end

function heroHaggleTaskWin:getHaggleTaskNewIndexByGroup()
  for i, v in ipairs(self.cur_task) do
    local newConfig = ed.getDataTable("SimpleAssistTask")[v.id]
    local newGroupIndex = newConfig["Task Group"]
    if newGroupIndex == self.taskGroupIndex then
      return i
    end
  end
end

function heroHaggleTaskWin:getPos(i)
  local size = self.ui.panel_record:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 79
  local itemSpace = 3
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy - 10)
end

function heroHaggleTaskWin:refreshDragList()
  self.uiList = {}
  self.allItems = {}
  self.instanceItem = {}
  local uiList = {}
  self.dragList:clearList()
  local posY = 0
  for index = 1, #self.cur_task do
    local taskData = self.cur_task[index]
    local container, ui = self:createTaskItem(index, taskData)
    local iconSize = container:getContentSize()
    posY = iconSize.height + posY
    ui.data = taskData
    table.insert(uiList, ui)
    self.dragList:addItem(container)
    container:setPosition(self:getPos(index))
    self.allItems[taskData.id] = {ui = ui, container = container}
    self.instanceItem[index] = {container = container, data = taskData}
  end
  self.dragList:initListHeight(posY + 40)
  self.uiList = uiList
end

function heroHaggleTaskWin:dragListCreate()
  local thisCon = self.ui.panel_record:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 5, thisCon.width, thisCon.height),
    container = self.ui.panel_record,
    noshade = true,
    zorder = 10,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    priority = -300
  }
  self.dragList = ed.draglist.create(info)
  self:staticSync(true)
  self.initDone = true
end

function heroHaggleTaskWin:staticSync(force)
  if force then
    self:refreshDragList()
    self.playAnimation = false
    return
  end
  if self.uiList and self.initDone then
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
    
    if nil ~= self.targetIndex and self.targetIndex ~= 0 then
      local cell = self.uiList[self.targetIndex]
      local data = self.cur_task[cell.idx]
      local config = ed.getDataTable("SimpleAssistTask")[data.id]
      local newTaskGroupIndex = config["Task Group"]
      local newIndex = self:getHaggleTaskNewIndexByGroup()
      if self.taskGroupIndex == newTaskGroupIndex and newIndex == self.targetIndex then
        cell.bg:stopAllActions()
        cell.bg:runAction(CCSequence:create(ccArrayMake(unpack({
          CCEaseExponentialIn:create(CCScaleTo:create(0.2, 0.9, 0.1)),
          CCCallFunc:create(function()
            self:updateTaskItem(cell, self.targetIndex, data)
            self.playAnimation = false
          end),
          CCEaseExponentialOut:create(CCScaleTo:create(0.2, 1))
        }))))
      else
        local newShow = {}
        for i, v in ipairs(self.cur_task) do
          newShow[v.id] = v
        end
        local newAddItem = {}
        for i, v in ipairs(self.instanceItem) do
          if newShow[v.data.id] then
            table.insert(newAddItem, v)
          else
            self.allItems[v.data.id] = nil
            table.remove(self.dragList.listItems, i)
            cell.bg:runAction(CCSequence:create(ccArrayMake(unpack({
              CCEaseExponentialIn:create(CCScaleTo:create(0.2, 0.9, 0.1)),
              CCCallFunc:create(func(cell.bg))
            }))))
          end
        end
        self.instanceItem = newAddItem
        for i, v in ipairs(self.cur_task) do
          if not self.allItems[v.id] then
            self.newIndex = i
            local container, ui = self:createTaskItem(i, v)
            self.dragList:addItem(container)
            container:setPosition(self:getPos(i))
            ui.bg:setVisible(false)
            ui.bg:runAction(CCSequence:create(ccArrayMake(unpack({
              CCDelayTime:create(0.2),
              CCCallFunc:create(funcVis(ui.bg)),
              CCEaseExponentialOut:create(CCScaleTo:create(0.2, 1))
            }))))
            self.allItems[v.id] = {ui = ui, container = container}
            self.uiList[i] = ui
          else
            self:updateTaskItem(self.allItems[v.id].ui, i, self.cur_task[i])
            self.allItems[v.id].ui.idx = i
            self.uiList[i] = self.allItems[v.id].ui
          end
        end
        for i, v in ipairs(self.instanceItem) do
          local _index = self:getHaggleTaskNewIndex(v.data.id)
          v.container:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, self:getPos(_index))))
        end
        self.ui.panel_record:stopAllActions()
        self.ui.panel_record:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCCallFunc:create(function()
          self.playAnimation = false
        end))))
        for index = 1, #self.cur_task do
          self.instanceItem[index] = {
            container = self.allItems[self.cur_task[index].id].container,
            data = self.cur_task[index]
          }
        end
        self.dragList:initListHeight(#self.dragList.listItems * 79 + 40)
      end
    end
  end
end

function heroHaggleTaskWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.btn_detail and ed.containsPoint(v.btn_detail, x, y) and v.btn_detail:isVisible() then
      if self.playAnimation then
        return
      end
      local taskConfig = self.cur_task[v.idx]
      self.targetIndex = v.idx
      if taskConfig then
        local config = ed.getDataTable("SimpleAssistTask")[taskConfig.id]
        self.taskGroupIndex = config["Task Group"]
        self.playAnimation = true
        ed.heroHaggleNet:sendGetTaskReward(taskConfig.id)
      end
    end
    if v.layer_go and ed.containsPoint(v.layer_go, x, y) and v.layer_go:isVisible() then
      local taskConfig = self.cur_task[v.idx]
      if taskConfig then
        ed.activityTaskTool.taskSkip(taskConfig.progressType, {})
      end
    end
  end
  
  return handler
end

function heroHaggleTaskWin:cancelPressInList()
  local function handler(x, y, info)
    if info and info.btn_detail and info.ImageView_36585 then
      info.btn_detail:setScale(1)
      
      info.ImageView_36585:setScale(0.95)
    end
  end
  
  return handler
end

function heroHaggleTaskWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if v and v.btn_detail and v.btn_detail:isVisible() and ed.containsPoint(v.btn_detail, x, y) then
        v.btn_detail:setScale(0.95)
        
        return v
      end
      if v and v.layer_go and v.layer_go:isVisible() and ed.containsPoint(v.layer_go, x, y) then
        v.ImageView_36585:setScale(0.95)
        return v
      end
    end
    return nil
  end
  
  return handler
end
