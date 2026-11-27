local riseStarPage = {}
ed.ui.riseStarPage = riseStarPage

function riseStarPage.create(base, param, pageKey)
  local self = {}
  setmetatable(riseStarPage, {__index = base})
  setmetatable(self, {__index = riseStarPage})
  self:init(param, pageKey)
  return self
end

function riseStarPage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.activityId = param._id
  self:initView()
  self:onSendOpenPanel()
  self:addEventClick()
  self:addListenEvent()
end

function riseStarPage:sendRepeated()
  ed.riseStarNet:sendOpenPanel()
  ed.riseStarNet:sendQueryGoods()
end

function riseStarPage:onSendOpenPanel()
  self:sendRepeated()
end

function riseStarPage:onSceneEnter()
  ed.riseStarNet:sendOpenPanel()
end

function riseStarPage:pageUpDate(param)
end

function riseStarPage:adaptView()
  ed.layout.layoutWithMagin(self.ui.image_costIcon, {
    right = 190 + ed.display.halfFixedWidth,
    top = 15 + ed.display.halfFixedHeight
  })
  ed.layout.layoutWithMagin(self.ui.page_right, {
    right = 27 + ed.display.halfFixedWidth
  })
  if ed.isAreaOverSea() then
    ed.layout.layoutWithMagin(self.ui.image_title, {
      left = 300 - ed.display.halfFixedWidth
    })
    self.ui.image_title:setPositionY(self.ui.image_title:getPositionY() + 12)
  else
    ed.layout.layoutWithMagin(self.ui.image_title, {
      left = 300 - ed.display.halfFixedWidth
    })
  end
end

function riseStarPage:registerBtn(btn, key, func, params)
  local config = {
    button = btn,
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function riseStarPage:addEventClick()
  self:registerBtn(self.ui.btn_exchange, "btn_exchange", function()
    self:gotoShopView()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.btn_summon, "btn_summon", function()
    self:gotoSummon()
  end, {pressScale = 0.95})
end

function riseStarPage:addListenEvent()
  self:listenTimer(Timer:Always(1), function()
    self:updateLeftTime()
  end)
  self:listenEvent("EventRiseFiveAmRefresh", function()
    self:sendRepeated()
  end)
  self:listenEvent("EventUpdateGoodsByStore", function()
    self:updateViewByCost()
  end)
  self:listenEvent("EventRiseStarPageOpenPanel", function()
    self:updateViewData()
    self:refreshDragList()
  end)
  self:listenEvent("EventUpdateRiseStarTask", function(state)
    self:updateViewData()
    if state then
      self:staticSync(state)
    else
      self.ui.page_lay:stopAllActions()
      self.ui.page_lay:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCCallFunc:create(function()
        self:staticSync(state)
      end))))
    end
  end)
  self:listenEvent("EventQueryGoodsByMain", function()
    self:updateViewByCost()
    self:refreshRedPoint()
  end)
end

function riseStarPage:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_riseStar)
  self.container = container
  self.ui = ui
  self:adaptView()
  self:initLabel()
  self:updateLeftTime()
  self:dragListCreate()
end

function riseStarPage:initLabel()
  ed.setLabelFontName(self.ui.Label_38389, ed.fontBold)
  ed.setLabelColor(self.ui.Label_38389, ed.toccc3(7163143))
  ed.setLabelColor(self.ui.label_time, ccc3(236, 252, 254))
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(1269738), 1)
  local title_node = ed.ui.gradientLabel.create({
    text = T("\229\137\141\229\190\128\229\143\172\229\148\164"),
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16772778),
    endColor = ed.toccc3(16777215),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(19912)
  })
  self.ui.btn_summon:addChild(title_node.node, 2)
  title_node:setPosition(ccp(145, 40))
end

function riseStarPage:updateLeftTime()
  local endTime = ed.riseStarMgr:getEndTime()
  if endTime then
    local leftTime = endTime - ed.getServerTime()
    if 0 < leftTime then
      ed.setLabelString(self.ui.label_time, T("\229\137\169\228\189\153%s", ed.time2dhmsV2(leftTime)))
    else
      self.timeOutClick = true
    end
  end
end

function riseStarPage:gotoShopView()
  self.ui.image_redpoint:setVisible(false)
  ed.UITool.openView("OpenRiseStarShopWin")
end

function riseStarPage:gotoSummon()
  ed.UITool.openView("summonScene", {page = 5})
end

local TaskTypeOrderEnum = {Daily = 3, Infinite = 1}

function riseStarPage:updateViewData()
  local taskTemp = ed.riseStarMgr:getTaskList()
  self.cur_task = {}
  for i, v in pairs(taskTemp) do
    table.insert(self.cur_task, v)
  end
  table.sort(self.cur_task, function(a, b)
    local priorityA = a.taskState == 3 and 1 or a.taskState == 2 and 3 or 2
    local priorityB = b.taskState == 3 and 1 or b.taskState == 2 and 3 or 2
    local sort_value_a = TaskTypeOrderEnum[a.taskType] or 2
    local sort_value_b = TaskTypeOrderEnum[b.taskType] or 2
    if priorityA ~= priorityB then
      return priorityA < priorityB
    elseif sort_value_a ~= sort_value_b then
      return sort_value_a > sort_value_b
    else
      return a.id < b.id
    end
  end)
end

function riseStarPage:getPos(i)
  local size = self.ui.task_list:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 68
  local itemSpace = 1
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function riseStarPage:createTaskItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.activity_riseStar_item)
  if nil ~= ui.image_bg then
    container:setContentSize(ui.image_bg:getContentSize())
  end
  self:updateTaskItem(ui, index, data)
  return container, ui
end

local initHeight, initWidth

function riseStarPage:updateTaskItem(ui, index, data)
  ui.idx = index
  ed.setLabelFontName(ui.label_taskType, ed.fontBold)
  ed.setLabelString(ui.label_taskType, T("\230\175\143\230\151\165"))
  ed.setLabelColor(ui.label_taskType, ed.toccc3(16777215))
  ed.setLabelString(ui.label_taskName, data.detail)
  ed.setLabelColor(ui.label_taskName, ed.toccc3(1847705))
  if ed.isAreaOverSea() then
    ui.image_taskType:setScale(0.8)
    if nil == initHeight then
      initHeight = ui.image_taskType:getPositionY()
    end
    if nil == initWidth then
      initWidth = ui.image_taskType:getPositionX()
    end
    ui.image_taskType:setPositionY(initHeight + 5)
    ui.image_taskType:setPositionX(initWidth + 5)
    ed.setLabelString(ui.label_taskName, data.detail)
    ed.setLabelColor(ui.label_taskName, ed.toccc3(1847705))
    ed.setLabelDimensions(ui.label_taskName, CCSizeMake(230, 0))
  else
    ed.setLabelString(ui.label_taskName, data.detail)
    ed.setLabelColor(ui.label_taskName, ed.toccc3(1847705))
  end
  ed.setLabelColor(ui.Label_38397, ccc3(255, 252, 231))
  ed.setLabelStroke(ui.Label_38397, ed.toccc3(5321216), 1)
  ed.setLabelColor(ui.Label_38399, ccc3(255, 255, 255))
  ed.setLabelStroke(ui.Label_38399, ed.toccc3(6694365), 1)
  ed.setLabelColor(ui.Label_38397, ed.toccc3(16317695))
  ed.setLabelStroke(ui.Label_38397, ed.toccc3(793277), 1)
  if nil == data.progress then
    ed.setLabelString(ui.Label_38397, string.format("%s/%s", data.target, data.target))
    ui.image_process:setScaleX(1)
  else
    ed.setLabelString(ui.Label_38397, string.format("%s/%s", data.progress, data.target))
    ui.image_process:setScaleX(math.min(data.progress / data.target, 1))
  end
  ui.layer_goway:setVisible(data.taskState == 1)
  ui.btn_getReward:setVisible(data.taskState == 3)
  ui.btn_complate:setVisible(data.taskState == 2)
  ui.image_processmask:setVisible(data.taskState == 2)
  ed.setLabelColor(ui.Label_38401, ed.toccc3(11983611))
  if nil ~= ui.image_bg then
    if data.taskState == 1 then
      ed.setTexture(ui.image_bg, "UI/alpha/1080P/risestar/inglist.png")
    elseif data.taskState == 2 then
      ed.setTexture(ui.image_bg, "UI/alpha/1080P/risestar/over_button.png")
      ed.setLabelColor(ui.label_taskName, ccc3(136, 154, 205))
      ed.setLabelColor(ui.Label_38397, ed.toccc3(8092014))
    else
      ed.setTexture(ui.image_bg, "UI/alpha/1080P/risestar/completelist.png")
    end
  end
  if data.taskType == "Daily" then
    ed.setLabelString(ui.label_taskType, T("\230\175\143\230\151\165"))
    ed.setTexture(ui.image_taskType, "UI/alpha/1080P/risestar/daily_tag.png")
  elseif data.taskType == "Infinite" then
    ed.setLabelString(ui.label_taskType, T("\229\190\170\231\142\175"))
    ed.setTexture(ui.image_taskType, "UI/alpha/1080P/risestar/cycle_tag.png")
  else
    ed.setTexture(ui.image_taskType, "UI/alpha/1080P/risestar/challenge_tag.png")
  end
  ui.image_taskType:setVisible(nil ~= data.taskType)
  local icon = self:createItemIcon({
    id = data.items[1].id,
    type = data.items[1].type,
    amount = data.items[1].amount,
    rewardState = data.taskState
  })
  ui.reward_list:addChild(icon)
  icon:setPosition(ccp(30, 30))
  ui.reward_icon = icon
  ui.reward_icon.id = data.items[1].id
  ui.reward_icon.amount = data.items[1].amount
end

function riseStarPage:createItemIcon(itemData)
  local id = itemData.id
  local itemType = itemData.type
  local amount = itemData.amount
  local rewardState = itemData.rewardState
  local icon = ed.createItemIcon({
    id = itemData.type,
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

function riseStarPage:refreshDragList()
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
  self.dragList:initListHeight(posY - 120)
  self.uiList = uiList
  self.initDone = true
end

function riseStarPage:dragListCreate()
  self.initDone = false
  local thisCon = self.ui.task_list:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 5, thisCon.width, thisCon.height),
    container = self.ui.task_list,
    noshade = true,
    zorder = 10,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    priority = -300
  }
  self.dragList = ed.draglist.create(info)
end

function riseStarPage:getTaskNewIndexByGroup()
  for i, v in ipairs(self.cur_task) do
    if v.id == self.sendTaskId then
      return i
    end
  end
end

function riseStarPage:getTaskNewIndex(id)
  for i, v in ipairs(self.cur_task) do
    if v.id == id then
      return i
    end
  end
end

function riseStarPage:staticSync(force)
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
      local newIndex = self:getTaskNewIndexByGroup()
      if newIndex == self.targetIndex then
        cell.image_bg:stopAllActions()
        cell.image_bg:runAction(CCSequence:create(ccArrayMake(unpack({
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
            cell.image_bg:runAction(CCSequence:create(ccArrayMake(unpack({
              CCEaseExponentialIn:create(CCScaleTo:create(0.2, 0.9, 0.1)),
              CCCallFunc:create(func(cell.image_bg))
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
            ui.image_bg:setVisible(false)
            ui.image_bg:runAction(CCSequence:create(ccArrayMake(unpack({
              CCDelayTime:create(0.2),
              CCCallFunc:create(funcVis(ui.image_bg)),
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
          local _index = self:getTaskNewIndex(v.data.id)
          v.container:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, self:getPos(_index))))
        end
        self.ui.task_list:stopAllActions()
        self.ui.task_list:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCCallFunc:create(function()
          self.playAnimation = false
        end))))
        for index = 1, #self.cur_task do
          self.instanceItem[index] = {
            container = self.allItems[self.cur_task[index].id].container,
            data = self.cur_task[index]
          }
        end
      end
    end
  end
end

function riseStarPage:updateViewByCost()
  local itemPoint = ed.riseStarMgr:getItemPoint()
  ed.setString(self.ui.label_num, itemPoint)
end

function riseStarPage:refreshRedPoint()
  local itemPoint = ed.riseStarMgr:getItemPoint()
  self.shopData = ed.riseStarMgr:getShopData()
  local show_state = false
  for i, v in pairs(self.shopData) do
    if itemPoint >= v._price_value then
      show_state = true
      break
    end
  end
  self.ui.image_redpoint:setVisible(show_state)
end

function riseStarPage:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.btn_getReward, x, y) and v.btn_getReward:isVisible() then
      if self.playAnimation then
        return
      end
      local taskConfig = self.cur_task[v.idx]
      self.targetIndex = v.idx
      self.sendTaskId = taskConfig.id
      if taskConfig then
        self.playAnimation = true
        ed.riseStarNet:sendGetTaskReward(taskConfig.id)
      end
    end
    if ed.containsPoint(v.layer_goway, x, y) and v.layer_goway:isVisible() then
      local taskConfig = self.cur_task[v.idx]
      if taskConfig then
        ed.activityTaskTool.taskSkip(taskConfig.progressType, {})
      end
    end
    if ed.containsPoint(v.reward_icon, x, y) and v.reward_icon:isVisible() then
      ed.ui.packageDetailWin.create({
        id = v.reward_icon.id,
        count = v.reward_icon.amount,
        type = "riseStarPoint"
      }):popWindow()
    end
  end
  
  return handler
end

function riseStarPage:cancelPressInList()
  local function handler(x, y, info)
    if info.icon then
      info.btn_getReward:setScale(1)
      
      info.layer_goway:setScale(0.95)
      info.reward_icon:setScale(0.67)
    end
  end
  
  return handler
end

function riseStarPage:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if v.btn_getReward:isVisible() and ed.containsPoint(v.btn_getReward, x, y) then
        v.btn_getReward:setScale(0.95)
        
        return v
      end
      if v.layer_goway:isVisible() and ed.containsPoint(v.layer_goway, x, y) then
        v.layer_goway:setScale(0.95)
        return v
      end
      if v.reward_icon:isVisible() and ed.containsPoint(v.reward_icon, x, y) then
        v.reward_icon:setScale(0.6365)
        return v
      end
    end
    return nil
  end
  
  return handler
end
