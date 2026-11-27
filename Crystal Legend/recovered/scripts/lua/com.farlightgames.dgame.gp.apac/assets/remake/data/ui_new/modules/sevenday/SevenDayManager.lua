local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class.isDebug()
  return false
end

function class:isOpen()
  return self.open
end

function class:setOpen(isOpen)
  self.open = isOpen
end

function class:initTaskList()
  self.dayOfTasks = {}
  local taskList = ed.getDataTable("SevenDayAssist")[1]["Task List"]
  local tb = ed.getDataTable("SevenDayAssistTask")
  for k, taskId in ipairs(taskList) do
    local v = tb[taskId]
    local item = {
      id = k,
      desc = v["Task Detail"],
      type = v["Task Progress Type"],
      progressId = v["Task Progress ID"],
      progress = 0,
      target = v["Task Target"],
      count = v["Add Task Count"] or 0,
      taskState = 2,
      rewards = {}
    }
    for i = 1, 2 do
      if v["Task Reward Type " .. i] then
        table.insert(item.rewards, {
          type = v["Task Reward Type " .. i],
          id = v["Task Reward ID " .. i],
          amount = v["Task Reward Amount " .. i]
        })
      end
    end
    if not self.dayOfTasks[v["Task Day"]] then
      self.dayOfTasks[v["Task Day"]] = {
        id = v["Task Day"],
        challengeTimes = 0,
        tasks = {},
        challengeTasks = {}
      }
    end
    if v["Duration Hour"] ~= 0 then
      table.insert(self.dayOfTasks[v["Task Day"]].challengeTasks, item)
    else
      table.insert(self.dayOfTasks[v["Task Day"]].tasks, item)
    end
  end
end

function class:initScoreRewards()
  self.progressRewards = {}
  local tb = ed.getDataTable("SevenDayAssistLine")
  for k, v in pairs(tb) do
    if type(k) == "number" then
      local item = {
        id = k,
        target = v["Require Task Count"],
        reward = {
          id = v["Reward ID 1"],
          type = v["Reward Type 1"],
          amount = v["Reward Amount 1"]
        },
        taskState = 2
      }
      table.insert(self.progressRewards, item)
    end
  end
  table.sort(self.progressRewards, function(a, b)
    return a.id < b.id
  end)
end

function class:initData()
  self.curProgress = 0
  self.maxProgress = 350
  self.curDay = 1
  self.maxDay = 7
  self.numOfCanGet = 0
  self:initTaskList()
  self:initScoreRewards()
end

function class:getTaskData(day, page)
  local dayData = self.dayOfTasks[day] or {}
  if page == 1 then
    return dayData.tasks or {}
  else
    return dayData.challengeTasks or {}
  end
end

function class:getChallengeTaskTime(day)
  local dayData = self.dayOfTasks[day] or {}
  return dayData.challengeTimes or 0
end

function class:getRedLight()
  return self.redLight or self.numOfCanGet > 0
end

function class:setRedLight(redLight)
  self.redLight = redLight
end

function class:getTabRedLight(day)
  local dayData = self.dayOfTasks[day] or {}
  local red1, red2 = false, false
  for k, v in ipairs(dayData.tasks) do
    if v.taskState == 1 then
      red1 = true
      break
    end
  end
  for k, v in ipairs(dayData.challengeTasks) do
    if v.taskState == 1 then
      red2 = true
      break
    end
  end
  return red1, red2
end

function class:setTaskState(id, state)
  local task = self:getTaskById(id)
  task.taskState = state
end

function class:setLineRewardState(id, state)
  for k, v in ipairs(self.progressRewards) do
    if v.id == id then
      v.taskState = state
    end
  end
end

function class:getTaskById(id)
  for day, value in ipairs(self.dayOfTasks) do
    for k, v in ipairs(value.tasks) do
      if v.id == id then
        return v, day
      end
    end
    for k, v in ipairs(value.challengeTasks) do
      if v.id == id then
        return v, day
      end
    end
  end
end

function class:handleOpenPanel(data)
  self.redLight = false
  self.numOfCanGet = 0
  local lineTasks = data._line_lists or {}
  self.curDay = data._cur_day
  local serverTime = ed.getServerTime()
  for k, v in ipairs(lineTasks) do
    self.curProgress = math.max(v._task_progress, self.curProgress)
    self.maxProgress = math.max(v._cond_target, self.maxProgress)
    local taskState = v._is_rewarded == 1 and 3 or v._cond_target <= v._task_progress and 1 or 2
    self:setLineRewardState(v._id, taskState)
    if taskState == 1 then
      self.numOfCanGet = self.numOfCanGet + 1
    end
  end
  local tasks = data._task_lists or {}
  for k, v in ipairs(tasks) do
    local task, day = self:getTaskById(v._id)
    if task and day <= self.curDay then
      task.progress = v._task_progress
      task.taskState = v._is_rewarded == 1 and 3 or task.progress < task.target and 2 or 1
      if v._expire_time ~= 0 and serverTime >= v._expire_time then
        task.isExpire = true
      end
      self.dayOfTasks[day].challengeTimes = math.max(v._expire_time or 0, self.dayOfTasks[day].challengeTimes)
      if task.taskState == 1 and day <= self.curDay then
        self.numOfCanGet = self.numOfCanGet + 1
      end
    end
  end
  for k, v in ipairs(self.dayOfTasks) do
    table.sort(v.tasks, function(a, b)
      if a.taskState == b.taskState then
        return a.id < b.id
      else
        return a.taskState < b.taskState
      end
    end)
    table.sort(v.challengeTasks, function(a, b)
      if a.taskState == b.taskState then
        return a.id < b.id
      else
        return a.taskState < b.taskState
      end
    end)
  end
  self.totalEndTime = data._active_time + 2592000
  if self.win then
    FireEvent("RefreshSevenDayScene")
  else
    ed.pushScene(ed.ui.SevenDayScene.create())
  end
end

function class:handleGetTaskRewards(data)
  if data._rewards then
    if ed.SevenDayNetwork.tmpTaskId then
      self:setTaskState(ed.SevenDayNetwork.tmpTaskId, 3)
      self.numOfCanGet = self.numOfCanGet - 1
      local task, day = self:getTaskById(ed.SevenDayNetwork.tmpTaskId)
      table.sort(self.dayOfTasks[day].tasks, function(a, b)
        if a.taskState == b.taskState then
          return a.id < b.id
        else
          return a.taskState < b.taskState
        end
      end)
      table.sort(self.dayOfTasks[day].challengeTasks, function(a, b)
        if a.taskState == b.taskState then
          return a.id < b.id
        else
          return a.taskState < b.taskState
        end
      end)
      if self.numOfCanGet == 0 then
        FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.SEVENDAY)
      end
    end
    self.curProgress = data._cur_line_progress
    for k, v in ipairs(self.progressRewards) do
      if v.taskState == 2 and self.curProgress >= v.target then
        v.taskState = 1
        self.numOfCanGet = self.numOfCanGet + 1
        FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.SEVENDAY)
      end
    end
    ed.player:addRewards(data._rewards)
    ed.UITool.showRewardsFromServer(data._rewards)
    FireEvent("SevenDayTaskReward")
  end
end

function class:handleGetLineRewards(data)
  if data._rewards then
    if ed.SevenDayNetwork.tmpLineId then
      self:setLineRewardState(ed.SevenDayNetwork.tmpLineId, 3)
      self.numOfCanGet = self.numOfCanGet - 1
      if self.numOfCanGet == 0 then
        FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.SEVENDAY)
      end
    end
    ed.player:addRewards(data._rewards)
    ed.UITool.showRewardsFromServer(data._rewards)
    FireEvent("SevenDayLineReward")
    ed.SevenDayNetwork.tmpLineId = nil
  end
end

ed.UITool.registViewOpenFunc("SevenDayScene", function(param)
  local cpl = ed.playerlimit.getAreaUnlockPrompt("SevenDayAssist")
  if cpl then
    ed.showToast(cpl)
    return
  end
  if ReloadModule then
    ReloadModule("ui_new/modules/sevenday/SevenDayModuleList")
  end
  ed.SevenDayNetwork:sendOpenPanel()
end)
ed.SevenDayManager = class.getInstance()
