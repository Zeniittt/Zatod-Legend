local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.hadesTaskWindow = class
ed.UITool.registViewOpenFunc("hadesTaskWindow", function(param)
  local panel = ed.ui.hadesTaskWindow.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("hadesTaskWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.param = param or {}
  self.groupId = param.groupId or 1
  self.uiType = param.uiType or "Hell"
  self.uiEditorConfig = ed.nianMonsterDefine.TYPE_TO_UI[self.uiType]
  self.hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  self.startClickX = nil
  self.startClickY = nil
  self.heatTaskList = {}
  self.nextTaskOpenTime = nil
  self.selectTaskLineId = nil
  self.selectTaskId = nil
  self.traceTaskLineId, self.traceTaskId = self.hadesHeatMgr:getTraceTask()
  self:initView()
  self:registerTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.hades_task_window)
  self.container:addChild(container)
  self.ui = ui
  ed.setTexture(self.ui.image_bg, self.uiEditorConfig.taskWindowCfg.bgPath)
  self:initLabels()
  self:initTaskDetailDragList()
  self:initTableView()
  self:initTaskData()
  self:refreshTableView(false, true)
  self:refreshTaskDetail()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_total_heat_tips, ed.toccc3(6567450), 1)
  ed.setLabelStroke(self.ui.label_total_heat, ed.toccc3(9644819), 1)
  ed.setLabelStroke(self.ui.label_advance_tips, ed.toccc3(6567450), 1)
  local taskName = ed.ui.gradientLabel.create({
    fontSize = 26,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16701044),
    endColor = ed.toccc3(16749384),
    strokeSize = 1,
    strokeColor = ed.toccc3(4599845)
  })
  self.ui.image_bg:addChild(taskName.node)
  taskName.node:setPosition(self.ui.panel_task_name:getPosition())
  self.taskName = taskName
end

function class:isTaskCanTrace(taskLineId, taskId)
  local taskCfg = ed.getDataTable("HeatTask")[taskLineId][taskId]
  if ed.isElementInTable(taskCfg["Task Progress Type"], {
    "HeatChoose",
    "CombineHeatChoose"
  }) then
    return true
  end
  return false
end

function class:initTaskDetailDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_task_heat, {
    doPressIn = function(x, y)
      for _, cfg in ipairs(self.taskConditionItemList or {}) do
        local ui = cfg.ui
        if ed.containsPoint(ui.image_bg, x, y) then
          return cfg
        end
      end
    end,
    doClickIn = function(x, y, cfg)
      local heatId = cfg.heatId
      local ui = cfg.ui
      self:showOptionDetail(ui.image_bg, heatId)
    end
  })
end

function class:initTableView()
  local size = self.ui.panel_task_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.heatTaskList
    end,
    cellSizeFromIndex = function(index)
      return self:getTaskItemSize()
    end,
    createCell = function(index)
      local taskData = self.heatTaskList[index]
      local container, ui = self:createTaskItem(taskData)
      return container, {ui = ui, taskData = taskData}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      if ed.containsPoint(ui.image_bg, x, y) then
        ui.image_bg:setScale(0.95)
      end
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      local ui = data.ui
      ui.image_bg:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if not ed.containsPoint(ui.image_bg, x, y) then
        return
      end
      local taskData = data.taskData
      self:onClickTask(taskData)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_task_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    padding = {width = 0, height = 5},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:initTaskData()
  self.heatTaskList, self.nextTaskOpenTime = self.hadesHeatMgr:getShowTaskList(self.groupId)
  table.sort(self.heatTaskList, ed.cmpSort({
    {
      getValue = function(taskData)
        if taskData._task_progress >= taskData._cond_target and taskData._is_rewarded <= 0 then
          return 0
        elseif taskData._is_rewarded and taskData._is_rewarded > 0 then
          return 2
        end
        return 1
      end
    },
    {
      getValue = function(heatData)
        return heatData.isNewTask and 0 or 1
      end
    },
    {
      key = "_task_line_id"
    },
    {key = "_task_id"}
  }))
end

function class:refreshTableView(isHoldPos, showTraceFocusEff)
  self.showTraceFocusEff = showTraceFocusEff
  local size = self.ui.panel_task_list:getContentSize()
  if self.nextTaskOpenTime then
    local y, m, d = ed.time2YMD(self.nextTaskOpenTime)
    ed.setLabelString(self.ui.label_advance_tips, string.format(T("\228\184\139\230\172\161\230\155\180\230\150\176\228\187\187\229\138\161\n%s\230\156\136%s\230\151\165"), m, d))
    self.ui.label_advance_tips:setHorizontalAlignment(kCCTextAlignmentCenter)
    self.ui.image_advance_tips:setVisible(true)
    self.tableView.dragList:initClipRect(CCRectMake(0, 0, size.width, size.height - 45))
  else
    self.ui.image_advance_tips:setVisible(false)
    self.tableView.dragList:initClipRect(CCRectMake(0, 0, size.width, size.height))
  end
  if isHoldPos then
    local listPosX, listPosY = self.tableView:getListPos()
    self.tableView:reloadData()
    self.tableView:setListPos(ccp(listPosX, listPosY))
  else
    local firstRewardIndex, traceTraceTaskIndex, targetTaskData
    for index, taskData in ipairs(self.heatTaskList or {}) do
      if taskData._task_progress >= taskData._cond_target and 0 >= taskData._is_rewarded and not firstRewardIndex then
        firstRewardIndex = index
      end
      if taskData._task_line_id == self.traceTaskLineId and taskData._task_id == self.traceTaskId then
        traceTraceTaskIndex = index
      end
    end
    local targetIndex
    if firstRewardIndex or traceTraceTaskIndex then
      targetIndex = firstRewardIndex or traceTraceTaskIndex
      targetTaskData = self.heatTaskList[targetIndex]
    end
    if not targetTaskData and 0 < #self.heatTaskList then
      targetTaskData = self.heatTaskList[1]
    end
    self.selectTaskLineId = targetTaskData._task_line_id
    self.selectTaskId = targetTaskData._task_id
    self.tableView:reloadData()
    local itemHeight = self:getTaskItemSize().height
    if targetIndex then
      targetTaskData = self.heatTaskList[targetIndex]
      local listHeight = self.tableView:getListHeight()
      local listY = math.min(listHeight - size.height, (targetIndex - 1) * (itemHeight + 5))
      self.tableView:setListPos(ccp(0, listY + size.height))
    end
  end
end

function class:getTaskItemSize()
  return CCSizeMake(255, 45.5)
end

function class:createTaskItem(taskData)
  local container = ed.createSprite()
  container:setContentSize(self:getTaskItemSize())
  local _, ui = ed.editorui(ed.uieditor.hades_task_item, {container = container})
  ed.layout.centerInParent(ui.image_bg)
  ed.setLabelFontName(ui.label_name, ed.fontBold)
  local taskLineId = taskData._task_line_id
  local taskId = taskData._task_id
  local isSelect = self.selectTaskLineId == taskLineId and self.selectTaskId == taskId
  local isTrace = false
  if self.traceTaskLineId == taskLineId and self.traceTaskId == taskId then
    isTrace = true
  end
  if isTrace then
    local eff_traceFocusBg = ed.createFcaNode("eff_UI_Main_Hades_focus_b")
    self:addFca(eff_traceFocusBg)
    ui.image_bg:addChild(eff_traceFocusBg, -1)
    eff_traceFocusBg:setPosition(ccp(-20, 23))
    eff_traceFocusBg:setStartAction(self.showTraceFocusEff and "Start" or "Loop")
    local eff_traceFocus = ed.createFcaNode("eff_UI_Main_Hades_focus")
    self:addFca(eff_traceFocus)
    ui.image_bg:addChild(eff_traceFocus)
    eff_traceFocus:setPosition(ccp(-20, 23))
    eff_traceFocus:setStartAction(self.showTraceFocusEff and "Start" or "Loop")
  end
  local taskCfg = ed.getDataTable("HeatTask")[taskLineId][taskId]
  local rewardState
  local bgPath = "UI/alpha/1080P/hades/hades_task_tab_unchoose.png"
  local labelColor = ed.toccc3(14199459)
  local strokeColor = ed.toccc3(3938836)
  if taskData._is_rewarded and taskData._is_rewarded > 0 then
    bgPath = "UI/alpha/1080P/hades/hades_task_tab_done.png"
    rewardState = "task_complete"
    labelColor = ed.toccc3(8217191)
    strokeColor = ed.toccc3(2101775)
    ui.image_finish:setVisible(true)
  elseif taskData._task_progress >= taskData._cond_target then
    ui.image_red_point:setVisible(true)
    rewardState = "task_available"
  end
  if isSelect then
    bgPath = "UI/alpha/1080P/hades/hades_task_tab_choose.png"
    labelColor = ed.toccc3(16776423)
    strokeColor = ed.toccc3(3680034)
  end
  ed.setTexture(ui.image_bg, bgPath)
  ed.setLabelString(ui.label_name, taskCfg["Task Name"])
  ed.setLabelColor(ui.label_name, labelColor)
  ed.setLabelStroke(ui.label_name, strokeColor, 1)
  return container, ui
end

function class:getSelectTaskData()
  for index, taskData in ipairs(self.heatTaskList) do
    if taskData._task_line_id == self.selectTaskLineId and taskData._task_id == self.selectTaskId then
      return taskData
    end
  end
end

function class:refreshTaskDetail()
  local taskData = self:getSelectTaskData()
  local taskLineId = taskData._task_line_id
  local taskId = taskData._task_id
  local taskCfg = ed.getDataTable("HeatTask")[taskLineId][taskId]
  self.taskName:setString(taskCfg["Task Name"])
  self.taskName.node:setPositionX(self.ui.image_dec_left:getPositionX() + self.taskName:getContentSize().width / 2 + 8)
  self.ui.image_dec_right:setPositionX(self.taskName.node:getPositionX() + self.taskName:getContentSize().width / 2 + 8)
  local panelSize = self.ui.panel_task_heat:getContentSize()
  if taskCfg["Task Des"] then
    self.ui.image_desc_bg:setVisible(true)
    self.ui.image_line:setVisible(true)
    local descBgSize = self.ui.image_desc_bg:getContentSize()
    ed.setLabelString(self.ui.label_desc, taskCfg["Task Des"])
    ed.setLabelDimensions(self.ui.label_desc, CCSizeMake(descBgSize.width - 60, 0))
    local labelDescHeight = self.ui.label_desc:getContentSize().height
    if 29.5 < labelDescHeight then
      self.ui.label_desc:setHorizontalAlignment(kCCTextAlignmentLeft)
    else
      self.ui.label_desc:setHorizontalAlignment(kCCTextAlignmentCenter)
    end
    self.ui.image_desc_bg:setContentSize(CCSizeMake(528, math.max(labelDescHeight + 6.5, 29.5)))
    ed.layout.centerInParent(self.ui.label_desc)
    self.dragList:initClipRect(CCRectMake(0, 0, panelSize.width, panelSize.height))
    self.dragList.listLayer:setContentSize(CCSizeMake(panelSize.width, panelSize.height))
  else
    self.dragList:initClipRect(CCRectMake(0, 0, panelSize.width, panelSize.height + 60))
    self.dragList.listLayer:setContentSize(CCSizeMake(panelSize.width, panelSize.height + 60))
    self.ui.image_desc_bg:setVisible(false)
    self.ui.image_line:setVisible(false)
  end
  self:refreshTaskCondition(taskCfg)
  local itemList = {}
  for index = 1, 20 do
    local rewardType = taskCfg[string.format("Task Reward Type %s", index)]
    local rewardId = taskCfg[string.format("Task Reward ID %s", index)]
    local rewardAmount = taskCfg[string.format("Task Reward Amount %s", index)]
    if not rewardAmount or rewardAmount <= 0 then
      break
    end
    table.insert(itemList, {
      itemType = rewardType,
      itemId = rewardId,
      itemAmount = rewardAmount
    })
  end
  self:createRewardItemList(self.ui.panel_reward, itemList)
  if taskData._is_rewarded and 0 < taskData._is_rewarded then
    self.ui.image_task_finish:setVisible(true)
    self.ui.btn_get_reward:setVisible(false)
    self.ui.btn_trace:setVisible(false)
    ed.setTexture(self.ui.image_reward_bg, "UI/alpha/1080P/hades/hades_task_reward_1.png")
  elseif taskData._task_progress >= taskData._cond_target then
    self.ui.image_task_finish:setVisible(false)
    self.ui.btn_get_reward:setVisible(true)
    self.ui.btn_trace:setVisible(false)
    ed.setTexture(self.ui.image_reward_bg, "UI/alpha/1080P/hades/hades_task_reward_2.png")
  else
    ed.setTexture(self.ui.image_reward_bg, "UI/alpha/1080P/hades/hades_task_reward_1.png")
    self.ui.image_task_finish:setVisible(false)
    self.ui.btn_get_reward:setVisible(false)
    local canTrace = self:isTaskCanTrace(taskLineId, taskId)
    local isTracing = self.traceTaskLineId == taskLineId and self.traceTaskId == taskId
    self.ui.btn_trace:setVisible(canTrace)
    if isTracing then
      ed.setLabelString(self.ui.label_trace, T("\229\143\150\230\182\136\232\191\189\232\184\170"))
    else
      ed.setLabelString(self.ui.label_trace, T("\232\191\189\232\184\170\228\187\187\229\138\161"))
    end
  end
end

function class:refreshTaskCondition(taskCfg)
  self.taskConditionItemList = {}
  self.dragList:clearList()
  local panelSize = self.dragList.listLayer:getContentSize()
  local posY = 0
  local taskType = taskCfg["Task Progress Type"]
  local taskParam = taskCfg["Task Parameter"]
  local conditionIndex = 0
  local totalHeatAmount = 0
  local itemSize = CCSizeMake(560.5, 32)
  if taskType == "CombineHeatChoose" then
    for index = 1, #taskParam, 2 do
      local heatId = taskParam[index]
      local level = taskParam[index + 1]
      local conditionItem, ui, heatAmount = self:createHeatConditionItem(conditionIndex, heatId, level)
      table.insert(self.taskConditionItemList, {ui = ui, heatId = heatId})
      totalHeatAmount = totalHeatAmount + heatAmount
      self.dragList:addItem(conditionItem)
      conditionItem:setPosition(ccp(panelSize.width / 2, panelSize.height - itemSize.height / 2 - posY))
      posY = posY + itemSize.height
      conditionIndex = conditionIndex + 1
    end
  elseif taskType == "HeatChoose" then
    local heatId = taskParam[1]
    local level = taskParam[2]
    local conditionItem, ui, heatAmount = self:createHeatConditionItem(conditionIndex, heatId, level)
    table.insert(self.taskConditionItemList, {ui = ui, heatId = heatId})
    totalHeatAmount = totalHeatAmount + heatAmount
    self.dragList:addItem(conditionItem)
    conditionItem:setPosition(ccp(panelSize.width / 2, panelSize.height - itemSize.height / 2 - posY))
    posY = posY + itemSize.height
  elseif taskType == "HeroUseHeat" then
    local conditionItem = self:createHeroUseHeatConditionItem(conditionIndex, taskCfg)
    self.dragList:addItem(conditionItem)
    conditionItem:setPosition(ccp(panelSize.width / 2, panelSize.height - itemSize.height / 2 - posY))
    posY = posY + itemSize.height
  elseif taskType == "HighestHeat" then
    local conditionItem = self:createHighestHeatConditionItem(conditionIndex, taskCfg)
    self.dragList:addItem(conditionItem)
    conditionItem:setPosition(ccp(panelSize.width / 2, panelSize.height - itemSize.height / 2 - posY))
    posY = posY + itemSize.height
  elseif taskType == "EchoChoose" then
    local conditionItem = self:createEchoConditionItem(conditionIndex, taskCfg)
    self.dragList:addItem(conditionItem)
    conditionItem:setPosition(ccp(panelSize.width / 2, panelSize.height - itemSize.height / 2 - posY))
    posY = posY + itemSize.height
  end
  self.dragList:initListHeight(posY)
  ed.setLabelString(self.ui.label_total_heat, totalHeatAmount)
  local showTotalHeat = 0 < totalHeatAmount
  self.ui.label_total_heat_tips:setVisible(showTotalHeat)
  self.ui.image_heat_icon:setVisible(showTotalHeat)
  self.ui.label_total_heat:setVisible(showTotalHeat)
end

function class:createHeatConditionItem(conditionIndex, heatId, level)
  local container, ui = ed.editorui(ed.uieditor.hades_task_condition_item)
  container:setContentSize(ui.image_bg:getContentSize())
  if conditionIndex % 2 == 0 then
    ui.image_bg:setOpacity(0)
  end
  local heatCfg = ed.getDataTable("Heat")[heatId]
  local icon = ed.createSprite(heatCfg.Icon)
  icon:setScale(0.7)
  ui.panel_icon:addChild(icon)
  ed.layout.centerInParent(icon)
  local name = ed.createttf(heatCfg.HeatName, 20)
  name:setColor(ed.toccc3(16776423))
  name:setStroke(ed.toccc3(3744789), 1)
  name:setAnchorPoint(ccp(0, 0.5))
  ui.panel_desc:addChild(name)
  name:setPosition(ccp(0, ui.panel_desc:getContentSize().height / 2))
  local heatAmount = heatCfg.HeatValue1 * level
  ed.setLabelString(ui.label_heat_amount, heatAmount)
  return container, ui, heatAmount
end

function class:createHeroUseHeatConditionItem(conditionIndex, taskCfg)
  local container, ui = ed.editorui(ed.uieditor.hades_task_condition_item)
  container:setContentSize(ui.image_bg:getContentSize())
  if conditionIndex % 2 == 0 then
    ui.image_bg:setOpacity(0)
  end
  local heroId = taskCfg["Task Parameter"][1]
  local heroIcon = ed.readhero.createIcon({
    id = heroId or 1
  }).icon
  heroIcon:setScale(0.4)
  ui.panel_icon:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  local desc = ed.createttf(taskCfg["Task Detail"], 20)
  desc:setColor(ed.toccc3(16776423))
  desc:setStroke(ed.toccc3(3744789), 1)
  desc:setAnchorPoint(ccp(0, 0.5))
  ui.panel_desc:addChild(desc)
  desc:setPosition(ccp(0, ui.panel_desc:getContentSize().height / 2))
  ui.image_heat_icon:setVisible(false)
  ui.label_heat_amount:setVisible(false)
  return container
end

function class:createHighestHeatConditionItem(conditionIndex, taskCfg)
  local container, ui = ed.editorui(ed.uieditor.hades_task_condition_item)
  container:setContentSize(ui.image_bg:getContentSize())
  if conditionIndex % 2 == 0 then
    ui.image_bg:setOpacity(0)
  end
  local desc = ed.createttf(taskCfg["Task Detail"], 20)
  desc:setColor(ed.toccc3(16776423))
  desc:setStroke(ed.toccc3(3744789), 1)
  desc:setAnchorPoint(ccp(0, 0.5))
  ui.panel_desc:addChild(desc)
  desc:setPosition(ccp(-43.5, ui.panel_desc:getContentSize().height / 2))
  ui.image_heat_icon:setVisible(false)
  ui.label_heat_amount:setVisible(false)
  return container
end

function class:createEchoConditionItem(conditionIndex, taskCfg)
  local container, ui = ed.editorui(ed.uieditor.hades_task_condition_item)
  container:setContentSize(ui.image_bg:getContentSize())
  if conditionIndex % 2 == 0 then
    ui.image_bg:setOpacity(0)
  end
  local itemId = taskCfg["Task Parameter"][1]
  local itemIcon = ed.createItemIcon({id = itemId})
  itemIcon:setScale(0.4)
  ui.panel_icon:addChild(itemIcon)
  ed.layout.centerInParent(itemIcon)
  local desc = ed.createttf(taskCfg["Task Detail"], 20)
  desc:setColor(ed.toccc3(16776423))
  desc:setStroke(ed.toccc3(3744789), 1)
  desc:setAnchorPoint(ccp(0, 0.5))
  ui.panel_desc:addChild(desc)
  desc:setPosition(ccp(0, ui.panel_desc:getContentSize().height / 2))
  ui.image_heat_icon:setVisible(false)
  ui.label_heat_amount:setVisible(false)
  return container
end

function class:createRewardItemList(container, rewardDataList)
  local itemList = {}
  container:removeAllChildrenWithCleanup(true)
  local rewardDragList = ed.UITool.createDraglist(container, {
    doPressIn = function(x, y)
      self.startClickX = x
      self.startClickY = y
      for k, v in pairs(itemList) do
        if ed.containsPoint(v.icon, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, v)
      if self.startClickX and self.startClickY and (math.abs(x - self.startClickX) > 10 or math.abs(y - self.startClickY) > 10) then
        return
      end
      local itemData = v.itemData
      if not ed.containsPoint(container, x, y) then
        return
      end
      ed.ui.packageDetailWin.create({
        id = itemData.itemId,
        count = itemData.itemAmount,
        type = itemData.itemType
      }):popWindow()
    end,
    priority = -300
  })
  local posX, gapX = 0, 0
  for _, itemData in ipairs(rewardDataList or {}) do
    local id = itemData.itemId
    local itemType = itemData.itemType
    local amount = itemData.itemAmount
    local icon = ed.createItemIcon({
      id = id,
      type = itemType,
      amount = amount
    })
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    local scale = icon:getScale()
    icon:setPosition(ccp(iconSize.width * scale / 2 + posX + gapX, container:getContentSize().height / 2))
    posX = posX + iconSize.width * scale + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
  return rewardDragList
end

function class:showOptionDetail(parent, heatId)
  if self.optionDetail then
    self.optionDetail:removeFromParentAndCleanup(true)
  end
  local heatCfg = ed.getDataTable("Heat")[heatId]
  if not heatCfg then
    return
  end
  local heatName = heatCfg.HeatName
  local iconPath = heatCfg.Icon
  local optionDetail = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  self.mainLayer:addChild(optionDetail, 999)
  optionDetail:setAnchorPoint(ccp(0.5, 1))
  local icon = ed.createSprite(iconPath)
  icon:setScale(0.6)
  optionDetail:addChild(icon)
  local nameLabel = ed.createLabelTTF(heatName, 20)
  ed.setLabelColor(nameLabel, ed.toccc3(16776423))
  ed.setLabelStroke(nameLabel, ed.toccc3(2565412), 1)
  optionDetail:addChild(nameLabel)
  local line = ed.createSprite("UI/alpha/1080P/hades/hades_boss_line.png")
  optionDetail:addChild(line)
  local desc = heatCfg.FrontDescription .. (heatCfg.BackDescription or "")
  local scriptArg = heatCfg.ScriptArg1
  local heatValue = heatCfg.HeatValue1
  if scriptArg then
    desc = string.gsub(desc, "%%ScriptArg&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", scriptArg))
  end
  desc = string.gsub(desc, "%%HeatValue&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", heatValue))
  desc = string.gsub(desc, "#p#", "%%")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16113079),
    strokeColor = ed.toccc3(1774610),
    strokeSize = 1,
    maxWidth = 300,
    fontSize = 16
  })
  optionDetail:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local bgWidth = 330
  local bgHeight = nameLabel:getContentSize().height + autoTextH + 35
  optionDetail:setContentSize(CCSizeMake(bgWidth, bgHeight))
  ed.layout.layoutWithParentMagin(icon, {left = 8, top = 7})
  ed.layout.layoutWithParentMagin(nameLabel, {left = 40, top = 15})
  ed.layout.layoutWithParentMagin(line, {left = 24, top = 45})
  ed.layout.layoutWithParentMagin(autoText.node, {left = 15, top = 60})
  local parentSize = parent:getContentSize()
  ed.layout.relateLayout(parent, optionDetail, {
    left = parentSize.width / 2 - bgWidth,
    top = parentSize.height / 2 + bgHeight
  })
  self.optionDetail = optionDetail
end

function class:onClickTask(taskData)
  if self.selectTaskLineId == taskData._task_line_id and self.selectTaskId == taskData._task_id then
    return
  end
  self.selectTaskLineId = taskData._task_line_id
  self.selectTaskId = taskData._task_id
  self:refreshTaskDetail()
  self:refreshTableView(true)
end

function class:onClickBtnTrace()
  local taskData = self:getSelectTaskData()
  if taskData then
    if self.traceTaskLineId == taskData._task_line_id and self.traceTaskId == taskData._task_id then
      self.traceTaskLineId = nil
      self.traceTaskId = nil
      self.hadesHeatMgr:clearTraceTask()
    elseif self:isTaskCanTrace(taskData._task_line_id, taskData._task_id) then
      self.traceTaskLineId = taskData._task_line_id
      self.traceTaskId = taskData._task_id
      self.hadesHeatMgr:setTraceTask(self.traceTaskLineId, self.traceTaskId)
      self:destroy()
    end
  end
  self:refreshTableView(true, true)
  self:refreshTaskDetail()
end

function class:onClickBtnGetReward()
  local taskData = self:getSelectTaskData()
  if not taskData then
    return
  end
  if taskData._is_rewarded and taskData._is_rewarded > 0 then
    return
  end
  if taskData._task_progress >= taskData._cond_target then
    ed.hadesHeatNet.sendTaskRewards(self.groupId, taskData._task_line_id, taskData._task_id)
    ed.hadesHeatNet.sendOpenPanel(self.groupId)
  end
end

function class:registerTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
  ed.UITool.registerBtn(self, "btn_trace", function()
    self:onClickBtnTrace()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_get_reward", function()
    self:onClickBtnGetReward()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.panel_task_heat,
    clickHandler = function()
      if self.optionDetail then
        self.optionDetail:removeFromParentAndCleanup(true)
        self.optionDetail = nil
      end
    end,
    priority = -1
  })
end

function class:addEventListener()
  self:listenEvent("hadesHeatOpenPanel", function(groupId)
    if self.groupId == groupId then
      self:initTaskData()
      self:refreshTableView(true, true)
      self:refreshTaskDetail()
    end
  end)
end
