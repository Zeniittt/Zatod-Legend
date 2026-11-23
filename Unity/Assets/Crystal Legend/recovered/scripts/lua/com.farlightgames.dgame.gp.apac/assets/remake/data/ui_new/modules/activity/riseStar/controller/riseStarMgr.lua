local class = {}
class.__index = class
local FiveAmScope = {}
local ActivityTimeScope = {}

function class.getInstance(...)
  local object = {}
  setmetatable(object, class)
  object:initData()
  object:registerEvents()
  object:InitEvents()
  return object
end

function class:initData()
  self.passID = 4
  self.moduleName = "RiseStar"
  self.server_reds = 0
  self.delayUpdate = false
  self.initActive = false
  self.isTimerRunning = false
end

function class:registerEvents()
  ListenEvent("ActivityUpdateSuccess", function()
    self.initActive = true
    if self.delayUpdate then
      self:updateActivity()
      self.delayUpdate = false
    end
  end)
end

function class:InitEvents()
end

function class:handleNotifyTask(notifyMsg)
  if notifyMsg then
    self.open = notifyMsg._is_open
    self.server_reds = notifyMsg._task
    if self.initActive then
      self:updateActivity()
    else
      self.delayUpdate = true
    end
  end
end

function class:updateActivity()
  ed.activityHints:updateReds({_act_id = 9999909})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
end

function class:getTaskInfo(info)
  local item = {}
  table.insert(item, {
    id = 0,
    type = "riseStarPoint",
    amount = info["Add Shop Point"]
  })
  return item
end

function class:initTaskList()
  self.riseStarTask = {}
  local config = ed.getDataTable("SimpleAssist")[self.passID][self.moduleName]
  local taskList = config["Task List"]
  for _, v in pairs(taskList) do
    local taskId = v
    local taskConfig = ed.getDataTable("SimpleAssistTask")[taskId]
    local taskState = 0
    local data = {
      id = v,
      target = taskConfig["Task Target"],
      progressId = taskConfig["Task Progress ID"],
      progressType = taskConfig["Task Progress Type"],
      taskType = taskConfig["Task Refresh Type"],
      detail = taskConfig["Task Detail"],
      items = self:getTaskInfo(taskConfig),
      progress = 0,
      taskState = taskState
    }
    self.riseStarTask[data.id] = data
  end
end

function class:handleTaskOpenPanel(data)
  self:initTaskList()
  self.reds = 0
  CloseScope(FiveAmScope)
  ListenEvent("FiveAmRefresh", function()
    FireEvent("EventRiseFiveAmRefresh")
  end, FiveAmScope)
  data = ed.copyProto(data)
  data = data._simple_assist
  local hour = ed.getDataTable("SimpleAssist")[self.passID][self.moduleName]["Duration Hour"]
  self.totalEndTime = data._active_time + hour * 60 * 60
  self:setdayAwardsTaskState(data._task_lists, false)
  FireEvent("EventRiseStarPageOpenPanel")
  self:updateActivity()
  self:startActivityTimer()
end

function class:startActivityTimer()
  if self.isTimerRunning then
    return
  end
  self.isTimerRunning = true
  CloseScope(ActivityTimeScope)
  ListenTimer(Timer:Always(1), function()
    self:activityUpdate()
  end, ActivityTimeScope)
end

function class:stopActivityTimer()
  if not self.isTimerRunning then
    return
  end
  self.isTimerRunning = false
  CloseScope(ActivityTimeScope)
end

function class:activityUpdate()
  if ed.riseStarMgr.totalEndTime and ed.riseStarMgr.totalEndTime < ed.getServerTime() then
    self.open = 0
    ed.activityHints.network:activityPull()
    self:stopActivityTimer()
  end
end

function class:handleGetTaskRewards(data)
  data._rewards = data._rewards or {}
  if data._rewards then
    self.curProgress = data._cur_line_progress
    self:setdayAwardsTaskState({
      {
        _id = data._task_id,
        _is_rewarded = 1
      }
    }, true)
    self.item_point = self.item_point + data._add_shop_point
    local rewards = {}
    table.insert(rewards, {
      _id = "riseStarPoint",
      _type = "riseStarPoint",
      _amount = data._add_shop_point
    })
    FireEvent("EventQueryGoodsByMain")
    ed.UITool.showRewardsFromServer(rewards, nil, function()
    end)
    FireEvent("EventUpdateRiseStarTask")
    self:updateActivity()
  end
end

function class:updateActivity()
  ed.activityHints:updateReds({_act_id = 9999909})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
end

function class:setdayAwardsTaskState(state, isGetReward)
  local canUpdate = false
  for _, v in ipairs(state) do
    local key = self.riseStarTask[v._id]
    local progress = v._task_progress
    if progress then
      self.riseStarTask[v._id].progress = progress
    end
    local taskType = self.riseStarTask[v._id].taskType
    local taskState
    if v._is_rewarded == 1 then
      if not isGetReward then
        if taskType == "Infinite" then
          if progress >= self.riseStarTask[v._id].target then
            taskState = 3
          else
            taskState = 1
          end
        else
          taskState = 2
        end
      elseif taskType == "Infinite" then
        self.riseStarTask[v._id].progress = self.riseStarTask[v._id].progress - self.riseStarTask[v._id].target
        if self.riseStarTask[v._id].progress >= self.riseStarTask[v._id].target then
          taskState = 3
        else
          taskState = 1
        end
      else
        taskState = 2
      end
    elseif progress >= self.riseStarTask[v._id].target then
      taskState = 3
    else
      taskState = 1
    end
    local old = self.riseStarTask[v._id].taskState
    self.riseStarTask[v._id].taskState = taskState
    if taskState == 2 then
      canUpdate = true
    end
    self.reds = self.reds or 0
    if taskType == "Infinite" and old == 3 and taskState == 1 then
      self.reds = self.reds - 1
    end
    if old == 3 and taskState == 2 then
      self.reds = self.reds - 1
    elseif (old == 1 or old == 0) and taskState == 3 then
      self.reds = self.reds + 1
    end
  end
  if self.reds <= 0 then
    self.server_reds = 0
  end
  if canUpdate then
    FireEvent("EventUpdateHeroHaggleTaskData")
  end
end

function class:handleQueryGoods(msg)
  self.plain_goods = {}
  if msg._shop then
    self.item_point = msg._shop._point
    self.plain_goods = msg._shop._goods_list
    table.sort(self.plain_goods, function(a, b)
      return a._order < b._order
    end)
    FireEvent("EventQueryGoodsByMain")
  end
end

function class:sortShopGoods()
end

function class:handleChooseGoods(msg)
  if msg then
    FireEvent("EventChooseGoodsByMain")
  end
end

function class:handleBuyGoods(msg)
  if msg then
    for i, v in pairs(self.plain_goods) do
      if v._group == msg._group_id and v._group_index == msg._group_index then
        v._buy_times = v._buy_times + msg._amount
      end
    end
    local rewards = {}
    for _, v in ipairs(msg._rewards) do
      if v._type == "raid_point" then
        table.insert(rewards, {_type = "raid_point", _amount = 0})
      else
        table.insert(rewards, v)
      end
    end
    self.item_point = self.item_point - ed.riseStarNet.temp_costNum
    ed.player:addRewards(rewards)
    self.closeHandler = true
    ed.UITool.showRewardsFromServer(msg._rewards, nil, function()
      self.closeHandler = false
    end)
    FireEvent("EventUpdateGoodsByStore", msg)
  end
end

function class:getOpenState()
  return self.open == 1
end

function class:getItemPoint()
  return self.item_point
end

function class:getShopData()
  return self.plain_goods
end

function class:getEndTime()
  return self.totalEndTime
end

function class:getTaskList()
  local showTask = ed.copyTable(self.riseStarTask)
  return showTask
end

function class:getRed()
  return self.server_reds > 0
end

ed.riseStarMgr = class.getInstance()
