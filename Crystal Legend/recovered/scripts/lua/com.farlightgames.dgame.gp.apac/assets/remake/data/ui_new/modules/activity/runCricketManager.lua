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

function class:initData()
  self.isOpen = false
  self.curProgress = 0
  self.reds = {}
  self.lineReds = 0
  self:initTaskList()
  self:initTaskTab()
  self:initLineItems()
end

function class:notify(data)
  data = ed.copyProto(data)
  for k, v in pairs(data._reward_hints or {}) do
    if v._type == "solo_seven" then
      data = v
      break
    end
  end
  if not data._type then
    return
  end
  self.type = data._type
  self.isOpen = false
  if data._is_open then
    self.isOpen = data._is_open == 1
  end
  self.showRed = data._task or 0
  if not self.isOpen then
    self.showRed = 0
  end
  FireEvent("refreshrunCricketScene", {type = "notify"})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
end

function class:getReds(id)
  return self.reds[id] or 0
end

function class:closeWindow(data)
  self.showRed = 0
  if self.lineReds and 0 < self.lineReds then
    self.showRed = 1
  else
    for _, v in pairs(self.reds) do
      if 0 < v then
        self.showRed = 1
        break
      end
    end
  end
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
end

function class:initTaskList()
  local function func(info)
    local item = {}
    
    for i = 1, 5 do
      if info["Task Reward ID " .. i] and info["Task Reward Amount " .. i] ~= 0 then
        table.insert(item, {
          id = info["Task Reward ID " .. i],
          type = info["Task Reward Type " .. i],
          amount = info["Task Reward Amount " .. i]
        })
      end
    end
    return item
  end
  
  self.runCricketTask = {}
  self.runCricketTaskKey = {}
  for _, v in pairs(ed.getDataTable("SimpleAssistTask")) do
    if v["Task Day"] and v["Task Day"] > 0 then
      self.runCricketTask[v["Task Day"]] = self.runCricketTask[v["Task Day"]] or {}
      local taskState = 0
      table.insert(self.runCricketTask[v["Task Day"]], {
        id = v.ID,
        addTaskCount = v["Add Task Count"],
        tab = v["Task Day"],
        target = v["Task Target"],
        progressId = v["Task Progress ID"],
        progressType = v["Task Progress Type"],
        detail = v["Task Detail"],
        items = func(v),
        progress = 0,
        taskState = taskState
      })
      self.runCricketTaskKey[v.ID] = {
        tab = v["Task Day"],
        index = #self.runCricketTask[v["Task Day"]]
      }
    end
  end
end

function class:getrunCricketTask()
  local showTable = {}
  for key, v in pairs(self.runCricketTask) do
    showTable[key] = {}
    for _, vv in ipairs(v) do
      if vv.taskState ~= 0 then
        table.insert(showTable[key], vv)
      end
    end
  end
  return showTable
end

function class:setrunCricketTaskState(state)
  for _, v in ipairs(state) do
    local key = self.runCricketTaskKey[v._id]
    if key then
      local progress = v._task_progress or self.runCricketTask[key.tab][key.index].progress
      self.runCricketTask[key.tab][key.index].progress = progress
      local taskState = v._is_rewarded == 1 and 2 or progress >= self.runCricketTask[key.tab][key.index].target and 3 or 1
      local old = self.runCricketTask[key.tab][key.index].taskState
      self.runCricketTask[key.tab][key.index].taskState = taskState
      self.reds[key.tab] = self.reds[key.tab] or 0
      if old == 3 and taskState == 2 then
        self.reds[key.tab] = self.reds[key.tab] - 1
      elseif (old == 1 or old == 0) and taskState == 3 then
        self.reds[key.tab] = self.reds[key.tab] + 1
      end
    else
      print("setrunCricketTaskState error  key ===", key)
      ed.pt(v)
    end
  end
end

function class:initTaskTab()
  self.taskTab = {}
  for tab, v in pairs(self.runCricketTask) do
    table.insert(self.taskTab, {
      ["Tab ID"] = tab,
      ["Tab Name"] = string.format("\231\172\172%d\229\164\169", tab)
    })
  end
  table.sort(self.taskTab, function(a, b)
    return a["Tab ID"] < b["Tab ID"]
  end)
end

function class:refreshTaskTab()
  self.locks = {}
  for i, v in ipairs(self.taskTab) do
    v.islock = self.curDay < v["Tab ID"]
    self.locks[v["Tab ID"]] = v.islock
  end
end

function class:getTaskTabLock(tabId)
  return self.locks[tabId]
end

function class:getTaskTab()
  return self.taskTab or {}
end

function class:initLineItems()
  local TaskLineList = ed.getDataTable("SimpleAssist")[3].SoloSeven["Task Line List"]
  local keys = {}
  for k, v in pairs(TaskLineList) do
    keys[v] = k
  end
  self.lineItems = {}
  local tab = ed.copyTable(ed.getDataTable("SimpleAssistLine"))
  for k, v in pairs(tab) do
    if keys[k] then
      table.insert(self.lineItems, v)
    end
  end
  table.sort(self.lineItems, function(a, b)
    return a.ID < b.ID
  end)
end

function class:getLineItems()
  local showTable = {}
  for _, v in ipairs(self.lineItems) do
    if v.taskState then
      table.insert(showTable, v)
    end
  end
  return showTable
end

function class:setLineItemsState(state)
  for i, v in pairs(state) do
    if self.lineItems[i] then
      self.lineItems[i]._is_rewarded = v
      local taskState = v == 1 and 2 or self.curProgress >= self.lineItems[i]["Require Task Count"] and 3 or 1
      local old = self.lineItems[i].taskState or 1
      self.lineItems[i].taskState = taskState
      if old == 3 and taskState == 2 then
        self.lineReds = self.lineReds - 1
      elseif old == 1 and taskState == 3 then
        self.lineReds = self.lineReds + 1
      end
    end
  end
end

function class:refreshLineItemsState()
  for _, v in pairs(self.lineItems) do
    if v.taskState then
      local taskState = v._is_rewarded == 1 and 2 or self.curProgress >= v["Require Task Count"] and 3 or 1
      local old = v.taskState or 1
      v.taskState = taskState
      if old == 3 and taskState == 2 then
        self.lineReds = self.lineReds - 1
      elseif old == 1 and taskState == 3 then
        self.lineReds = self.lineReds + 1
      end
    end
  end
end

function class:getLineItemsState(id)
  for _, v in pairs(self.lineItems) do
    if v.ID == id then
      return v.taskState
    end
  end
end

function class:handleOpenPanel(data)
  data = ed.copyProto(data)
  data = data._simple_assist
  if data._type ~= "solo_seven" then
    return
  end
  local hour = 0
  for i, v in ipairs(ed.getDataTable("SimpleAssist")) do
    if v.SoloSeven then
      hour = v.SoloSeven["Duration Hour"]
      break
    end
  end
  self.totalEndTime = data._active_time + hour * 60 * 60
  self.activeTime = data._active_time
  self.curDay = math.ceil((ed.getServerTime() - data._active_time) / 86400)
  self.curProgress = data._cur_line_progress or 0
  self:setrunCricketTaskState(data._task_lists)
  self:setLineItemsState(data._line_flags)
  self:refreshTaskTab()
  FireEvent("refreshrunCricketScene", {type = "openPanel"})
end

function class:handleGetTaskRewards(data)
  if data._type ~= "solo_seven" then
    return
  end
  data._rewards = data._rewards or {}
  if data._rewards then
    self.curProgress = data._cur_line_progress
    self:setrunCricketTaskState({
      {
        _id = data._task_id,
        _is_rewarded = 1
      }
    })
    self:refreshLineItemsState()
    local rewards = {}
    for _, v in ipairs(data._rewards) do
      table.insert(rewards, v)
    end
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(data._rewards, nil, function()
      FireEvent("refreshrunCricketScene", {
        type = "taskRewards"
      })
    end)
  end
end

function class:handleGetLineRewards(data, tmpLineId)
  if data._type ~= "solo_seven" then
    return
  end
  if data._rewards then
    if tmpLineId then
      for i, v in pairs(self.lineItems) do
        if v.ID == tmpLineId then
          self:setLineItemsState({
            [i] = 1
          })
          break
        end
      end
    end
    ed.player:addRewards(data._rewards)
    ed.UITool.showRewardsFromServer(data._rewards, nil, function()
      FireEvent("refreshrunCricketScene", {
        type = "lineRewards"
      })
    end)
  end
end

ed.runCricketManager = class.getInstance()
