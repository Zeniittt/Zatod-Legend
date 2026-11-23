local class = {}
class.__index = class
class.rule = T("\228\188\160\229\165\135\229\144\175\231\168\139\230\180\187\229\138\168\232\167\132\229\136\153\232\175\180\230\152\142") .. T("<br/><sprite src=UI/alpha/1080P/common/rivet_big.png>\230\136\152\233\152\159\231\173\137\231\186\167\232\190\19080\231\186\167\231\154\132\233\152\159\233\149\191\239\188\140\229\176\134\229\188\128\229\144\175\228\188\160\229\165\135\229\144\175\231\168\139\230\180\187\229\138\168\239\188\140\228\188\160\229\165\135\229\144\175\231\168\139\232\135\170\229\188\128\229\144\175\229\144\142\229\176\134\230\140\129\231\187\17330\229\164\169\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\180\187\229\138\168\230\156\159\233\151\180\229\134\133\239\188\140\233\152\159\233\149\191\229\143\175\233\128\154\232\191\135\229\156\168\232\191\156\229\143\164\231\134\148\231\130\137\229\134\133\229\143\145\232\181\183\233\148\187\233\128\160\231\173\137\230\150\185\229\188\143\229\174\140\230\136\144\230\140\145\230\136\152\228\187\187\229\138\161\239\188\140\233\162\134\229\143\150\228\187\187\229\138\161\229\165\150\229\138\177\229\185\182\232\142\183\229\190\151\227\128\144\229\144\175\231\168\139\231\167\175\229\136\134\227\128\145\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\148\182\233\155\134\232\182\179\229\164\159\231\154\132\229\144\175\231\168\139\231\167\175\229\136\134\229\144\142\239\188\140\229\143\175\229\156\168\230\180\187\229\138\168\233\161\181\233\157\162\233\162\134\229\143\150\229\148\175\228\184\128\232\163\133\229\164\135\230\149\180\232\163\133\226\128\148\226\128\148\227\128\144\228\188\160\229\165\135\194\183\229\134\176\231\148\178\227\128\145\227\128\130")
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
    if v._type == "legend_begin" then
      data = v
      break
    end
  end
  print("legend_begin:")
  ed.pt(data)
  if not data._type then
    return
  end
  self.type = data._type
  self.isOpen = data._is_open and data._is_open == 1
  self.showRed = data._task or 0
  local dayAwardsUidKey = ed.storage.getBool(ed.getRoleKey("dayAwards"))
  self.showRed = not dayAwardsUidKey and 1 or self.showRed
  FireEvent("refreshdayAwardsScene", {type = "notify"})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.DAY_AWARDS)
  if self.isOpen then
    FireEvent("RefreshRightTopButtons")
  end
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
  local dayAwardsUidKey = ed.getRoleKey("dayAwards")
  if not ed.storage.getBool(dayAwardsUidKey) then
    ed.storage.setValue(dayAwardsUidKey, true)
  end
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.DAY_AWARDS)
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
    if info["Add Task Count"] and 0 < info["Add Task Count"] then
      table.insert(item, {
        type = "LegendPoint",
        amount = info["Add Task Count"]
      })
    end
    return item
  end
  
  self.dayAwardsTask = {}
  self.dayAwardsTaskKey = {}
  for _, v in pairs(ed.getDataTable("SimpleAssistTask")) do
    if v["Task Tab"] and v["Task Tab"] > 0 then
      print("Task Tab == ===== ", v["Task Tab"])
      self.dayAwardsTask[v["Task Tab"]] = self.dayAwardsTask[v["Task Tab"]] or {}
      local taskState = 0
      table.insert(self.dayAwardsTask[v["Task Tab"]], {
        id = v.ID,
        addTaskCount = v["Add Task Count"],
        tab = v["Task Tab"],
        target = v["Task Target"],
        progressId = v["Task Progress ID"],
        progressType = v["Task Progress Type"],
        detail = v["Task Detail"],
        items = func(v),
        progress = 0,
        taskState = taskState
      })
      self.dayAwardsTaskKey[v.ID] = {
        tab = v["Task Tab"],
        index = #self.dayAwardsTask[v["Task Tab"]]
      }
    end
  end
end

function class:getdayAwardsTask()
  local showTable = {}
  for key, v in pairs(self.dayAwardsTask) do
    showTable[key] = {}
    for _, vv in ipairs(v) do
      if vv.taskState ~= 0 then
        table.insert(showTable[key], vv)
      end
    end
  end
  return showTable
end

function class:setdayAwardsTaskState(state)
  for _, v in ipairs(state) do
    local key = self.dayAwardsTaskKey[v._id]
    local progress = v._task_progress or self.dayAwardsTask[key.tab][key.index].progress
    self.dayAwardsTask[key.tab][key.index].progress = progress
    local taskState = v._is_rewarded == 1 and 2 or progress >= self.dayAwardsTask[key.tab][key.index].target and 3 or 1
    local old = self.dayAwardsTask[key.tab][key.index].taskState
    self.dayAwardsTask[key.tab][key.index].taskState = taskState
    self.reds[key.tab] = self.reds[key.tab] or 0
    if old == 3 and taskState == 2 then
      self.reds[key.tab] = self.reds[key.tab] - 1
    elseif (old == 1 or old == 0) and taskState == 3 then
      self.reds[key.tab] = self.reds[key.tab] + 1
    end
  end
end

function class:initTaskTab()
  self.taskTab = {}
  for _, v in pairs(ed.getDataTable("SimpleAssistTaskTab")) do
    table.insert(self.taskTab, v)
  end
  table.sort(self.taskTab, function(a, b)
    return a["Tab ID"] < b["Tab ID"]
  end)
end

function class:getTaskTab()
  return self.taskTab or {}
end

function class:initLineItems()
  self.lineItems = {}
  local tab = ed.copyTable(ed.getDataTable("SimpleAssistLine"))
  for _, v in pairs(tab) do
    table.insert(self.lineItems, v)
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
  for _, v in ipairs(self.lineItems) do
    if v.ID == id then
      return v.taskState
    end
  end
end

function class:handleOpenPanel(data)
  data = ed.copyProto(data)
  data = data._simple_assist
  local hour = ed.getDataTable("SimpleAssist")[1].LegendBegin["Duration Hour"]
  self.totalEndTime = data._active_time + hour * 60 * 60
  self.curProgress = data._cur_line_progress or 0
  self:setdayAwardsTaskState(data._task_lists)
  self:setLineItemsState(data._line_flags)
  FireEvent("refreshdayAwardsScene", {type = "openPanel"})
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
    })
    self:refreshLineItemsState()
    local rewards = {}
    for _, v in ipairs(data._rewards) do
      if v._type == "raid_point" then
        table.insert(rewards, {_type = "raid_point", _amount = 0})
      else
        table.insert(rewards, v)
      end
    end
    ed.player:addRewards(rewards)
    if data._add_line then
      table.insert(data._rewards, {
        _type = "LegendPoint",
        _amount = data._add_line
      })
    end
    ed.UITool.showRewardsFromServer(data._rewards, nil, function()
      FireEvent("refreshdayAwardsScene", {
        type = "taskRewards"
      })
    end)
  end
end

function class:handleGetLineRewards(data, tmpLineId)
  if data._rewards then
    if tmpLineId then
      for i, v in ipairs(self.lineItems) do
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
      FireEvent("refreshdayAwardsScene", {
        type = "lineRewards"
      })
    end)
  end
end

ed.UITool.registViewOpenFunc("dayAwardsScene", function(param)
  if not ed.dayAwardsManager.isOpen then
    return ed.showToast(T("\230\156\170\229\188\128\229\144\175"))
  end
  local cpl = ed.playerlimit.getAreaUnlockPrompt("dayAwards")
  if cpl then
    ed.showToast(cpl)
    return
  end
  if ReloadModule then
    ReloadModule("ui_new/modules/dayAwards/dayAwardsScene")
  end
  ed.pushScene(ed.ui.dayAwardsScene.create())
end)
ed.dayAwardsManager = class.getInstance()
