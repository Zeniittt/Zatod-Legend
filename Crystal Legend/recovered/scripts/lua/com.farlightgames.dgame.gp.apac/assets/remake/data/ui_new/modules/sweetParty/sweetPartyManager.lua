local class = {}
class.__index = class
class.rule = T("\226\128\156\232\181\182\232\183\175\232\190\155\232\139\166\228\186\134\239\188\129\232\191\153\233\135\140\230\173\163\229\156\168\228\184\190\232\161\140\230\180\190\229\175\185\229\145\162\239\188\129\226\128\157\229\174\179\231\190\158\231\154\132\229\176\143\233\185\191\232\175\180\229\136\176\227\128\130") .. T("<br/><sprite src=UI/alpha/1080P/common/rivet_big.png>\232\190\190\229\136\17645\231\186\167\231\154\132\233\152\159\233\149\191\229\176\134\230\148\182\229\136\176\229\176\143\233\185\191\231\154\132\233\130\128\232\175\183\239\188\140\229\143\130\228\184\142\231\148\156\229\191\131\230\180\190\229\175\185\239\188\140\230\180\187\229\138\168\229\176\134\230\140\129\231\187\17314\229\164\169\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\180\187\229\138\168\230\156\159\233\151\180\229\134\133\239\188\140\233\152\159\233\149\191\229\143\175\229\176\189\230\131\133\229\156\168\229\164\167\233\153\134\230\142\162\231\180\162\239\188\140\229\174\140\230\136\144\230\136\152\233\152\159\230\143\144\229\141\135\228\187\187\229\138\161\229\146\140\230\140\145\230\136\152\228\187\187\229\138\161\229\157\135\229\143\175\233\162\134\229\143\150\229\165\150\229\138\177\239\188\140\229\185\182\232\142\183\229\190\151\227\128\144\229\165\182\230\178\185\232\141\137\232\142\147\227\128\145\239\188\140\229\138\169\229\138\155\233\152\159\233\149\191\229\139\135\233\151\175\228\188\160\229\165\135\229\164\167\233\153\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\148\182\233\155\134\229\164\154\229\164\154\231\154\132\229\165\182\230\178\185\232\141\137\232\142\147\239\188\140\229\143\175\229\156\168\230\180\187\229\138\168\233\161\181\233\157\162\233\162\134\229\143\150\232\139\177\233\155\132\231\154\174\232\130\164\227\128\144\229\176\143\233\185\191-\232\155\139\231\179\149\231\148\156\229\191\131\227\128\145\227\128\130")
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
  self.isOpen = data._is_open and data._is_open == 1
  self.showRed = data._task or 0
  local sweetPartyUidKey = ed.storage.getBool(ed.getRoleKey("sweetParty"))
  self.showRed = not sweetPartyUidKey and 1 or self.showRed
  FireEvent("refreshSweetPartyScene", {type = "notify"})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.SWEET_PARTY)
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
  local sweetPartyUidKey = ed.getRoleKey("sweetParty")
  if not ed.storage.getBool(sweetPartyUidKey) then
    ed.storage.setValue(sweetPartyUidKey, true)
  end
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.SWEET_PARTY)
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
        type = "Strawberry",
        amount = info["Add Task Count"]
      })
    end
    return item
  end
  
  self.sweetPartyTask = {}
  self.sweetPartyTaskKey = {}
  for _, v in pairs(ed.getDataTable("SweetPartyTask")) do
    self.sweetPartyTask[v["Task Tab"]] = self.sweetPartyTask[v["Task Tab"]] or {}
    local taskState = 0
    table.insert(self.sweetPartyTask[v["Task Tab"]], {
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
    self.sweetPartyTaskKey[v.ID] = {
      tab = v["Task Tab"],
      index = #self.sweetPartyTask[v["Task Tab"]]
    }
  end
end

function class:getSweetPartyTask()
  local showTable = {}
  for _, v in ipairs(self.sweetPartyTask) do
    if v.taskState ~= 0 then
      table.insert(showTable, v)
    end
  end
  return showTable
end

function class:setSweetPartyTaskState(state)
  for _, v in ipairs(state) do
    local key = self.sweetPartyTaskKey[v._id]
    local progress = v._task_progress or self.sweetPartyTask[key.tab][key.index].progress
    self.sweetPartyTask[key.tab][key.index].progress = progress
    local taskState = v._is_rewarded == 1 and 2 or progress >= self.sweetPartyTask[key.tab][key.index].target and 3 or 1
    local old = self.sweetPartyTask[key.tab][key.index].taskState
    self.sweetPartyTask[key.tab][key.index].taskState = taskState
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
  for _, v in pairs(ed.getDataTable("SweetPartyTaskTab")) do
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
  local tab = ed.copyTable(ed.getDataTable("SweetPartyLine"))
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
  self.totalEndTime = data._active_time + 1209600
  self.curProgress = data._cur_line_progress or 0
  self:setSweetPartyTaskState(data._task_lists)
  self:setLineItemsState(data._line_flags)
  FireEvent("refreshSweetPartyScene", {type = "openPanel"})
end

function class:handleGetTaskRewards(data)
  data._rewards = data._rewards or {}
  if data._rewards then
    self.curProgress = data._cur_line_progress
    self:setSweetPartyTaskState({
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
    if data._add_strawberry then
      table.insert(data._rewards, {
        _type = "strawberry",
        _amount = data._add_strawberry
      })
    end
    ed.UITool.showRewardsFromServer(data._rewards, nil, function()
      FireEvent("refreshSweetPartyScene", {
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
      FireEvent("refreshSweetPartyScene", {
        type = "lineRewards"
      })
    end)
  end
end

ed.UITool.registViewOpenFunc("sweetPartyScene", function(param)
  if not ed.sweetPartyManager.isOpen then
    return ed.showToast(T("\230\156\170\229\188\128\229\144\175"))
  end
  local cpl = ed.playerlimit.getAreaUnlockPrompt("sweetParty")
  if cpl then
    ed.showToast(cpl)
    return
  end
  if ReloadModule then
    ReloadModule("ui_new/modules/sweetParty/sweetPartyScene")
  end
  ed.pushScene(ed.ui.sweetPartyScene.create())
end)
ed.sweetPartyManager = class.getInstance()
