local arenaTaskPage = newclass("g")
ed.ui.ActivityLegendRealArenaPage = arenaTaskPage
local TODO = "TODO"
local IS_COMPLETED = "IS_COMPLETED"
local IS_FINISHED = "IS_FINISHED"

function arenaTaskPage.create(base, param, pageKey)
  local self = {}
  setmetatable(arenaTaskPage, {__index = base})
  setmetatable(self, {__index = arenaTaskPage})
  self:init(param, pageKey)
  return self
end

function arenaTaskPage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.param = param
  self.allTaskList = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.normalTaskList = {}
  self.isVisible = true
  self.objWork:activityPull(self.activityId)
  self:initView()
  self:addListenEvent()
end

function arenaTaskPage:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_real_arena_legend_equip)
  self.container = container
  self.ui = ui
  ed.setLabelStroke(self.ui.left_time, ed.toccc3(8664619), 1)
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(2302551), 1)
  ed.setLabelStroke(self.ui.label_act_name, ed.toccc3(6955040), 1)
  local titleLabel_1 = ed.ui.gradientLabel.create({
    text = T("\228\188\160\229\165\135"),
    fontSize = 65,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16772177),
    endColor = ed.toccc3(16777210),
    strokeSize = 2.5,
    strokeColor = ed.toccc3(15430942)
  })
  titleLabel_1.node:setSkewX(10)
  self.ui.image_title_fire:addChild(titleLabel_1.node)
  titleLabel_1.node:setPosition(ccp(100, 55))
  local titleLabel_2 = ed.ui.gradientLabel.create({
    text = T("\231\142\176\228\184\150 \232\175\184\231\142\139\229\134\179\230\136\152!"),
    fontSize = 50,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16764750),
    endColor = ed.toccc3(16776929),
    strokeSize = 2.5,
    strokeColor = ed.toccc3(10180625)
  })
  self.ui.image_title_fire:addChild(titleLabel_2.node)
  ed.right2(titleLabel_2.node, titleLabel_1.node)
  titleLabel_2.node:setPositionY(titleLabel_2.node:getPositionY() - 7.5)
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("\230\180\187\229\138\168\230\156\159\233\151\180\229\134\133\239\188\140\232\139\177\233\155\132\230\137\128\231\169\191\228\188\160\229\165\135\232\163\133\229\164\135\231\148\159\230\149\136\239\188\140\228\184\148\228\188\154\232\162\171\228\184\180\230\151\182\230\143\144\229\141\135\232\135\179<lable color=ccc3(255,191,18)>5\230\152\159</lable>"),
    fontSize = 15,
    maxWidth = panelSize.width,
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(2369048),
    strokeSize = 1
  })
  self.ui.panel_desc:addChild(autoText.node)
  autoText.node:setPosition(ccp(0, panelSize.height - 7.5))
  self:adaptUI()
  self:initDragList()
  self:startCountDown()
end

function arenaTaskPage:adaptUI()
  self.ui.card_bg:setPositionX(self.ui.card_bg:getPositionX() - math.min(ed.display.halfFixedWidth - ed.display.getNotchHeight() / 2, 34))
  local taskListSize = self.ui.task_list:getContentSize()
  self.taskListAddWidth = math.min(ed.display.halfFixedWidth - ed.display.getNotchHeight() / 2, 35)
  self.ui.task_list:setContentSize(CCSizeMake(taskListSize.width + self.taskListAddWidth, taskListSize.height))
  self.ui.task_list:setPositionX(self.ui.task_list:getPositionX() + self.taskListAddWidth * 0.3)
end

function arenaTaskPage:initDragList()
  self.taskDragList = ed.UITool.createDraglist(self.ui.task_list, {
    clickInterval = 0.5,
    doPressIn = function(x, y)
      for k, v in pairs(self.taskItemList or {}) do
        if not self.isVisible then
          return
        end
        local ui = v.ui
        if ed.containsPoint(ui.get_reward, x, y) and ui.get_reward:isVisible() then
          return
        end
        if ed.containsPoint(ui.image_bg, x, y) and not ed.containsPoint(ui.reward_list, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, config)
      local taskData = config.taskData
      local taskState = ed.activityTaskTool.getTaskState(taskData)
      if taskState == "TODO" then
        ed.activityTaskTool.taskSkip(taskData._cond_type, taskData._cond_id)
        self.objWork:setEnterHandler(self.activityId)
      end
    end,
    priority = -300
  })
end

function arenaTaskPage:startCountDown()
  self:refreshCountDown()
  self:listenTimer(Timer:Always(1), function()
    self:refreshCountDown()
  end)
end

function arenaTaskPage:refreshCountDown()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.left_time:setString(T(string.format(T("\229\137\169\228\189\153\230\151\182\233\151\180: %s\230\151\182%s\229\136\134"), hour, min)))
  else
    self.ui.left_time:setString(T(string.format(T("\229\137\169\228\189\153\230\151\182\233\151\180: %s\229\164\169%s\230\151\182"), day, hour)))
  end
end

function arenaTaskPage:refreshTask()
  self.normalTaskList = {}
  for i, taskData in ipairs(self.allTaskList or {}) do
    table.insert(self.normalTaskList, taskData)
  end
  self:refreshDragList()
end

function arenaTaskPage:refreshDragList()
  local size = self.ui.task_list:getContentSize()
  self.taskDragList:clearList()
  local posY = 0
  local gapY = 4
  local offsetY = 3
  self:sortTaskList(self.normalTaskList)
  self.taskItemList = {}
  for index, task in ipairs(self.normalTaskList) do
    local container, ui = self:createTaskItem(index, task)
    local itemSize = container:getContentSize()
    self.taskDragList:addItem(container)
    container:setPosition(ccp(0, size.height - (posY + itemSize.height / 2 + offsetY)))
    posY = posY + itemSize.height + gapY
    table.insert(self.taskItemList, {
      container = container,
      taskData = task,
      ui = ui
    })
  end
  self.taskDragList:initListHeight(posY)
end

function arenaTaskPage:sortTaskList(allTaskList)
  table.sort(allTaskList, ed.cmpSort({
    {
      getValue = function(o)
        local taskState = ed.activityTaskTool.getTaskState(o)
        if taskState == IS_COMPLETED then
          return 0
        elseif taskState == TODO then
          return 1
        end
        return 2
      end
    },
    {key = "_id"}
  }))
end

function arenaTaskPage:createTaskItem(index, taskData)
  local container, ui = ed.editorui(ed.uieditor.activity_real_arena_task_item)
  ui.image_bg:setContentSize(CCSizeMake(self.ui.task_list:getContentSize().width + 17, ui.image_bg:getContentSize().height))
  ui.image_mask:setContentSize(CCSizeMake(self.ui.task_list:getContentSize().width, ui.image_mask:getContentSize().height))
  container:setContentSize(ui.image_bg:getContentSize())
  local maginRight = 100
  local taskState = ed.activityTaskTool.getTaskState(taskData)
  ui.get_reward:setVisible(taskState == IS_COMPLETED)
  ui.get_reward:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  ui.completed:setVisible(taskState == IS_FINISHED)
  ui.completed:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  ui.ongoing:setVisible(taskState == TODO)
  ui.image_arrow:setVisible(taskState == TODO)
  ui.image_mask:setVisible(taskState == IS_FINISHED)
  local scaleAction1 = CCScaleTo:create(1, 0.8)
  local scaleAction2 = CCScaleTo:create(1, 1)
  local lsequence = CCSequence:createWithTwoActions(scaleAction1, scaleAction2)
  ui.image_arrow:runAction(CCRepeatForever:create(lsequence))
  ui.image_arrow:setPositionX(ui.image_bg:getContentSize().width - 35)
  local condType = taskData._cond_type
  if condType == "hero_upgrade" then
    local progress = taskState == TODO and 0 or 1
    ed.setLabelString(ui.ongoing, string.format("%s/%s", progress, 1))
  else
    ed.setLabelString(ui.ongoing, string.format("%s/%s", taskData._progress, taskData._cond_target))
  end
  ui.ongoing:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  local desc = ed.activityTaskTool.getTaskDesc(taskData)
  ed.setLabelDimensions(ui.task_desc, CCSizeMake(155, 0))
  ed.setLabelString(ui.task_desc, desc)
  local rewardList = {}
  ui.reward_list:setContentSize(CCSizeMake(ui.reward_list:getContentSize().width + self.taskListAddWidth * 0.3, ui.reward_list:getContentSize().height))
  local rewardDragList = ed.UITool.createDraglist(ui.reward_list, {
    doPressIn = function(x, y)
      for k, v in pairs(rewardList or {}) do
        if not self.isVisible then
          return
        end
        if ed.containsPoint(v.icon, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, config)
      if not ed.containsPoint(self.ui.task_list, x, y) then
        return
      end
      local reward = config.reward
      ed.ui.packageDetailWin.create({
        id = reward._id,
        count = reward._amount,
        type = reward._type
      }):popWindow()
    end,
    priority = -300
  })
  local posX = 0
  for k, reward in ipairs(taskData._rewards or {}) do
    local icon = self:createItemIcon({
      rewardState = taskState,
      rewardId = reward._id,
      rewardType = reward._type,
      rewardAmount = reward._amount
    })
    icon:setScale(0.8)
    rewardDragList:addItem(icon)
    table.insert(rewardList, {icon = icon, reward = reward})
    local iconWidth = icon:getContentSize().width * 0.8
    icon:setPosition(ccp(iconWidth / 2 + posX, iconWidth / 2 - 5))
    posX = posX + iconWidth - 5
  end
  rewardDragList:initListWidth(posX)
  self:btRegisterButtonClick({
    button = ui.get_reward,
    press = ui.get_reward_press,
    key = "task" .. index,
    clickInterval = 0.2,
    force = true,
    pressHandler = function(event, x, y)
      if ed.containsPoint(self.ui.task_list, x, y) and ed.containsPoint(ui.get_reward, x, y) then
        ui.get_reward:setScale(0.75)
      end
    end,
    cancelPressHandler = function()
      ui.get_reward:setScale(0.8)
    end,
    clickHandler = function(param, x, y)
      if not ed.containsPoint(self.ui.task_list, x, y) then
        return
      end
      if taskState == IS_COMPLETED then
        self.objWork:activitySubmit(self.activityId, taskData._id)
        self.objWork:activityPull(self.activityId)
      end
    end
  })
  return container, ui
end

function arenaTaskPage:createItemIcon(rewardData)
  local id = rewardData.rewardId
  local rewardType = rewardData.rewardType
  local amount = rewardData.rewardAmount
  local rewardState = rewardData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = rewardType,
    amount = amount
  })
  if rewardState == IS_FINISHED then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == IS_COMPLETED then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  end
  return icon
end

function arenaTaskPage:pageUpDate(param)
  self.param = param
  self.allTaskList = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  self:refreshTask()
end

function arenaTaskPage:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
  self.taskDragList:setVisible(isVisible)
end

function arenaTaskPage:addListenEvent()
end
