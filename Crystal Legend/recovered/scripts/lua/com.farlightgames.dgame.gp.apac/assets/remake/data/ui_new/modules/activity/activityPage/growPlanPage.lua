local growPlanPage = {}
ed.ui.ActivityGrowPlanPage = growPlanPage
local TODO = "TODO"
local IS_COMPLETED = "IS_COMPLETED"
local IS_FINISHED = "IS_FINISHED"
local TASK_ITEM_BG1 = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_bg_todo.png"
local TASK_ITEM_BG2 = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_bg_fin.png"
local TASK_TYPE_DAILY = {
  bgPath = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_corner_daily.png",
  text = T("\230\156\172\230\151\165"),
  strokeColor = 5548617
}
growPlanPage.TASK_TYPE_DAILY = TASK_TYPE_DAILY
local TASK_TYPE_WEEKLY = {
  bgPath = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_corner_week.png",
  text = T("\230\156\172\229\145\168"),
  strokeColor = 5548617
}
growPlanPage.TASK_TYPE_WEEKLY = TASK_TYPE_WEEKLY
local TARGET_TASK_LABEL_BG1 = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_word_bg1.png"
local TARGET_TASK_LABEL_BG2 = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_word_bg2.png"
local TARGET_STATE_TO_BG = {
  TODO = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_todo.png",
  IS_COMPLETED = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_canget.png",
  IS_FINISHED = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_fin.png"
}
local TARGET_TASK_LABEL_COLOR1 = "ccc3(129,224,198)"
local TARGET_TASK_LABEL_COLOR2 = "ccc3(173,229,131)"
local TARGET_TASK_STROKE_COLOR1 = "ccc3(43,117,97)"
local TARGET_TASK_STROKE_COLOR2 = "ccc3(67,117,87)"
local TASK_CONDITION = T("<lable color=%s fontSize=f14 strokeColor=%s strokeSize=1>\229\174\140\230\136\144</lable>") .. T("<lable color=ccc3(255,252,231) fontSize=f16 strokeColor=ccc3(43,117,97) strokeSize=1>%s/%s</lable>")
local TASK_FINISHED = T("<lable color=ccc3(129,224,198) fontSize=f14 strokeColor=ccc3(43,117,97) strokeSize=1>\229\183\178\229\174\140\230\136\144</lable>")

function growPlanPage.create(base, param, pageKey)
  local self = {}
  setmetatable(growPlanPage, {__index = base})
  setmetatable(self, {__index = growPlanPage})
  self:init(param, pageKey)
  return self
end

function growPlanPage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.param = param
  self.allTaskList = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.progressTaskList = {}
  self.normalTaskList = {}
  self.isVisible = true
  self.objWork:activityPull(self.activityId)
  self:initView()
  self:addListenEvent()
end

function growPlanPage:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_grow_plan)
  self.container = container
  self.ui = ui
  ed.setLabelColor(self.ui.left_time, ed.toccc3(15531262))
  ed.setLabelStroke(self.ui.left_time, ed.toccc3(2524436), 1)
  self:adaptUI()
  self:initDragList()
  self:initHeroCard()
  self:startCountDown()
end

function growPlanPage:adaptUI()
  local offsetWidth = ed.display.winSize.width - 960
  local offsetHeight = ed.display.winSize.height - 540
  self.offsetWidth = offsetWidth
  self.offsetHeight = offsetHeight
  self.ui.layer_hero_card:setPositionX(self.ui.layer_hero_card:getPositionX() - offsetWidth * 0.4)
  self.ui.image_title:setPositionX(self.ui.image_title:getPositionX() - offsetWidth * 0.4)
  self.ui.task_list:setPositionX(self.ui.task_list:getPositionX() - offsetWidth * 0.33)
  local taskListSize = self.ui.task_list:getContentSize()
  self.ui.task_list:setContentSize(CCSizeMake(taskListSize.width + offsetWidth * 0.33, taskListSize.height))
end

function growPlanPage:initDragList()
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

function growPlanPage:initHeroCard()
  local activityTB = ed.getDataTable("Activity")
  local heroId = activityTB[self.cfgId]["Extra AN"][1]
  local heroArtPath = string.format("UI/art/card_bg_big_%s.jpg", heroId)
  local heroCard = CCSprite:create(heroArtPath)
  heroCard:setScale(0.67)
  local clipLayer = CCLayerColor:create(ccc4(255, 255, 255, 125))
  local frameSize = self.ui.hero_card_frame:getContentSize()
  clipLayer:setContentSize(self.ui.hero_card_frame:getContentSize())
  clipLayer:setClipRect(CCRectMake(6, 11, frameSize.width - 12, frameSize.height - 25))
  clipLayer:addChild(heroCard)
  ed.layout.centerInParent(heroCard)
  self.ui.layer_hero_card:addChild(clipLayer)
  ed.layout.centerInParent(clipLayer)
end

function growPlanPage:startCountDown()
  self:refreshCountDown()
  self:listenTimer(Timer:Always(1), function()
    self:refreshCountDown()
  end)
end

function growPlanPage:refreshCountDown()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function growPlanPage:refreshTask()
  self.progressTaskList = {}
  self.normalTaskList = {}
  for i, taskData in ipairs(self.allTaskList or {}) do
    if taskData._cond_type == "task_progress" then
      table.insert(self.progressTaskList, taskData)
    else
      table.insert(self.normalTaskList, taskData)
    end
  end
  self:refreshDragList()
  self:refreshProgressTask()
  self:refreshProgressBar()
end

function growPlanPage:refreshDragList()
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

function growPlanPage:sortTaskList(allTaskList)
  table.sort(allTaskList, ed.cmpSort({
    {
      getValue = function(o)
        local taskState = self:getTaskState(o)
        if taskState == IS_COMPLETED then
          return 0
        elseif taskState == TODO then
          return 1
        end
        return 2
      end
    },
    {
      getValue = function(o)
        if o._extend then
          return o._extend._refresh_type == "weekly" and 0 or 1
        end
        return 2
      end
    },
    {key = "_id"}
  }))
end

function growPlanPage:getTaskState(taskData)
  local taskState = TODO
  local isCompleted = taskData._progress >= taskData._cond_target
  local isFinished = taskData._cur_reward_times and taskData._cur_reward_times >= taskData._max_reward_times
  if isFinished then
    taskState = IS_FINISHED
  elseif isCompleted then
    taskState = IS_COMPLETED
  end
  return taskState
end

function growPlanPage:createTaskItem(index, taskData)
  local container, ui = ed.editorui(ed.uieditor.activity_grow_plan_item)
  local labelColor
  local taskState = self:getTaskState(taskData)
  if taskState == TODO then
    labelColor = 4283460
  elseif taskState == IS_FINISHED then
    labelColor = 15201234
  else
    labelColor = 4819253
  end
  local bgRes = taskState == IS_FINISHED and TASK_ITEM_BG2 or TASK_ITEM_BG1
  ui.image_bg:setSpriteFrame(ed.getSpriteFrame(bgRes))
  ui.image_bg:setContentSize(CCSizeMake(self.ui.task_list:getContentSize().width - 15, ui.image_bg:getContentSize().height))
  container:setContentSize(ui.image_bg:getContentSize())
  local maginRight = 70
  ui.get_reward:setVisible(taskState == IS_COMPLETED)
  ui.get_reward:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  ui.completed:setVisible(taskState == IS_FINISHED)
  ui.completed:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  ui.ongoing:setVisible(taskState == TODO)
  ui.image_arrow:setVisible(taskState == TODO)
  local scaleAction1 = CCScaleTo:create(1, 0.8)
  local scaleAction2 = CCScaleTo:create(1, 1)
  local lsequence = CCSequence:createWithTwoActions(scaleAction1, scaleAction2)
  ui.image_arrow:runAction(CCRepeatForever:create(lsequence))
  ui.image_arrow:setPositionX(ui.image_bg:getContentSize().width - 20)
  local condType = taskData._cond_type
  if condType == "hero_upgrade" then
    local progress = taskState == TODO and 0 or 1
    ed.setLabelString(ui.ongoing, string.format("%s/%s", progress, 1))
  else
    ed.setLabelString(ui.ongoing, string.format("%s/%s", taskData._progress, taskData._cond_target))
  end
  ui.ongoing:setPositionX(ui.image_bg:getContentSize().width - maginRight)
  local refreshType = taskData._extend and taskData._extend._refresh_type
  local cornerConfig
  if refreshType == "daily" then
    ui.image_corner:setVisible(true)
    cornerConfig = TASK_TYPE_DAILY
  elseif refreshType == "weekly" then
    ui.image_corner:setVisible(true)
    cornerConfig = TASK_TYPE_WEEKLY
  else
    ui.image_corner:setVisible(false)
  end
  if cornerConfig then
    ed.setTexture(ui.image_corner, cornerConfig.bgPath)
    ed.setLabelString(ui.label_corner, cornerConfig.text)
    ed.setLabelStroke(ui.label_corner, ed.toccc3(cornerConfig.strokeColor), 1)
    ui.label_corner:setFontName(ed.fontBold)
  end
  local desc = ed.activityTaskTool.getTaskDesc(taskData)
  ed.setLabelDimensions(ui.task_desc, CCSizeMake(170, 0))
  ed.setLabelString(ui.task_desc, desc)
  ed.setLabelColor(ui.task_desc, ed.toccc3(labelColor))
  local rewardList = {}
  ui.reward_list:setContentSize(CCSizeMake(ui.reward_list:getContentSize().width + self.offsetWidth * 0.33, ui.reward_list:getContentSize().height))
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

function growPlanPage:refreshProgressTask()
  table.sort(self.progressTaskList, ed.cmpSort({
    {key = "_id"}
  }))
  for index, taskData in ipairs(self.progressTaskList) do
    local rewardState = self:getTaskState(taskData)
    local reward = taskData._rewards[1]
    local icon = self:createItemIcon({
      rewardState = rewardState,
      rewardId = reward._id,
      rewardType = reward._type,
      rewardAmount = reward._amount
    })
    local bg = self.ui["target_reward" .. index]
    bg:removeAllChildrenWithCleanup(true)
    local flower = ed.createSprite(TARGET_STATE_TO_BG[rewardState])
    bg:addChild(flower)
    ed.layout.centerInParent(flower)
    local iconScale, labelColor, strokeColor, labelBg
    if rewardState == IS_COMPLETED then
      iconScale = 0.8
      labelColor = TARGET_TASK_LABEL_COLOR2
      strokeColor = TARGET_TASK_STROKE_COLOR2
      labelBg = TARGET_TASK_LABEL_BG2
    else
      iconScale = 0.53
      labelColor = TARGET_TASK_LABEL_COLOR1
      strokeColor = TARGET_TASK_STROKE_COLOR1
      labelBg = TARGET_TASK_LABEL_BG1
    end
    icon:setScale(iconScale)
    bg:addChild(icon)
    ed.setTexture(self.ui["target_label_bg" .. index], labelBg)
    ed.layout.centerInParent(icon)
    local autoTextDesc = ed.ui.autoText.new()
    local tips
    if rewardState == TODO then
      tips = string.format(TASK_CONDITION, labelColor, strokeColor, taskData._progress, taskData._cond_target)
    else
      tips = TASK_FINISHED
    end
    autoTextDesc:initParam({context = tips})
    local target_label_bg = self.ui["target_label_bg" .. index]
    target_label_bg:removeAllChildrenWithCleanup(true)
    target_label_bg:addChild(autoTextDesc.node)
    local textWidth, textHeight = autoTextDesc:getCurContentSize()
    local x = (target_label_bg:getContentSize().width - textWidth) / 2
    local y = target_label_bg:getContentSize().height / 2
    autoTextDesc.node:setPosition(ccp(x, y))
    self:btRegisterButtonClick({
      button = icon,
      key = "targetReward" .. index,
      force = true,
      clickHandler = function()
        if rewardState == IS_COMPLETED then
          self.objWork:activitySubmit(self.activityId, taskData._id)
          self.objWork:activityPull(self.activityId)
        else
          ed.ui.packageDetailWin.create({
            id = reward._id,
            count = reward._amount,
            type = reward._type
          }):popWindow()
        end
      end
    })
  end
end

function growPlanPage:refreshProgressBar()
  if #self.progressTaskList < 1 then
    return
  end
  local lastProgressTask = self.progressTaskList[#self.progressTaskList]
  local condTarget1 = 5
  local progress = lastProgressTask._progress
  local defaultProgress = 28
  local ignoreLastProgress = 7
  if progress >= lastProgressTask._cond_target then
    ignoreLastProgress = 0
  end
  local maxProgress = lastProgressTask._cond_target
  local ratio = 1
  if condTarget1 >= progress then
    defaultProgress = 28 - 33 * (ed.display.winSize.width - 960) / 960
    ratio = ed.display.winSize.width / 480 - 1
    ratio = math.max(1, ratio)
  end
  maxProgress = maxProgress + defaultProgress + ignoreLastProgress
  local currentProgress = progress * ratio + defaultProgress
  if not self.bar then
    local config = {
      base = {
        currentProgress = currentProgress,
        maxProgress = maxProgress,
        bg = {
          res = "UI/alpha/1080P/activity/grow_plan/grow_plan_bar1.png",
          layout = {
            anchor = ccp(0, 0),
            position = ccp(0, 0)
          }
        },
        progress = {
          res = "UI/alpha/1080P/activity/grow_plan/grow_plan_bar2.png",
          layout = {
            anchor = ccp(0, 0),
            position = ccp(0, 0)
          }
        }
      }
    }
    self.bar = ProgressBar:new(config)
    self.ui.progress_bar_bg:addChild(self.bar.node)
  else
    self.bar:setMaxProgress(maxProgress)
    self.bar:setProgress(currentProgress)
  end
end

function growPlanPage:createItemIcon(rewardData)
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

function growPlanPage:pageUpDate(param)
  self.param = param
  self.allTaskList = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  self:refreshTask()
end

function growPlanPage:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
  self.taskDragList:setVisible(isVisible)
end

function growPlanPage:addListenEvent()
  self:listenEvent("midas_reply", function(msgReply)
    self.objWork:activityPull(self.activityId)
  end)
end
