local arenaTaskPage = {}
ed.ui.ActivityArenaTaskPage = arenaTaskPage
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
  local container, ui = ed.editorui(ed.uieditor.activity_arena_task)
  self.container = container
  self.ui = ui
  local actiDataTable = ed.getDataTable("Activity")[self.cfgId]
  local nameStr = actiDataTable["Extra Str"][1] or "\229\129\135\233\157\162\231\139\130\230\172\162"
  local iconPath = actiDataTable["Extra Str"][2] or "UI/alpha/1080P/activity/pvptask/pvptask_shade.png"
  ed.setTexture(self.ui.act_icon, iconPath, true)
  ed.setLabelString(self.ui.act_name, nameStr)
  ed.setLabelStroke(self.ui.left_time, ed.toccc3(8664619), 1)
  ed.setLabelStroke(self.ui.act_name, ed.toccc3(13470720), 1)
  ed.setLabelShadow(self.ui.act_name, ccc3(0, 0, 0), ccp(0, 1))
  self.ui.act_name:setFontName(ed.fontBold)
  self.ui.act_name:limitWidthByScale(160)
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\232\182\163\229\145\179\231\171\158\230\138\128 \229\165\150\229\138\177\229\138\160\231\160\129"),
    fontSize = 46,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16775651),
    endColor = ed.toccc3(16773503),
    strokeSize = 3,
    strokeStartColor = ed.toccc3(10374656),
    strokeEndColor = ed.toccc3(13134848)
  })
  self.ui.title_panel:addChild(titleLabel.node)
  local titlePanelSize = self.ui.title_panel:getContentSize()
  titleLabel.node:setPosition(ccp(titlePanelSize.width / 2, titlePanelSize.height / 2))
  titleLabel.node:setScale(math.min(1, self.ui.title_panel:getContentSize().width / titleLabel.node:getContentSize().width))
  self:adaptUI()
  self:initDragList()
  self:refreshTask()
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
  local maxWidth = 0
  for i, v in ipairs(self.taskItemList) do
    maxWidth = math.max(maxWidth, v.ui.task_desc:getContentSize().width)
  end
  local limitWidth = 150
  if maxWidth > limitWidth then
    local limitScale = 0.7
    for i, v in ipairs(self.taskItemList) do
      v.ui.task_desc:setScale(limitScale)
      ed.setLabelDimensions(v.ui.task_desc, CCSizeMake(limitWidth / limitScale, 0))
    end
  end
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
  local container, ui = ed.editorui(ed.uieditor.activity_arena_task_item)
  ui.image_bg:setContentSize(CCSizeMake(self.ui.task_list:getContentSize().width, ui.image_bg:getContentSize().height))
  container:setContentSize(ui.image_bg:getContentSize())
  local maginRight = 74
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
  ui.image_arrow:setPositionX(ui.image_bg:getContentSize().width - 24)
  local condType = taskData._cond_type
  if condType == "hero_upgrade" then
    local progress = taskState == TODO and 0 or 1
    ed.setLabelString(ui.ongoing, string.format("%s/%s", progress, 1))
  else
    ed.setLabelString(ui.ongoing, string.format("%s/%s", taskData._progress, taskData._cond_target))
  end
  ui.ongoing:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  local desc = ed.activityTaskTool.getTaskDesc(taskData)
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
