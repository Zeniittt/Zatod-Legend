local data = {}
data.TaskState = {
  Complete = 1,
  Todo = 2,
  Finish = 3
}
data.ModuleType = {Guild = 1}

local function convertToModuleName(type)
  if type == data.ModuleType.Guild then
    return "Guild"
  else
    return ""
  end
end

local function convertToModuleType(name)
  if name == "Guild" then
    return data.ModuleType.Guild
  else
    return data.ModuleType.Guild
  end
end

function data:init()
  self.mTodoListTable = ed.getDataTable("Todolist")
  self.mModuleMap = {}
  self.mRedMap = {}
  return self
end

function data:getTaskList(type)
  return self.mModuleMap[type] or {}
end

function data:hasRed(type)
  return self.mRedMap[type]
end

local function GetTaskState(item)
  if item.value >= item.target then
    if 0 == item.lastRewardsTime or ed.checkTwoDateow(item.lastRewardsTime, ed.getServerTime()) then
      return data.TaskState.Complete
    else
      return data.TaskState.Finish
    end
  else
    return data.TaskState.Todo
  end
end

local function sortTaskList(list)
  table.sort(list, function(a, b)
    return a.taskState < b.taskState or a.taskState == b.taskState and a.id < b.id
  end)
end

function data:weeklyjobDataReply(info)
  if nil ~= info._dailyjob_open_panel then
    local type = data.ModuleType.Guild
    local _weeklyjobs = info._dailyjob_open_panel._weeklyjobs or {}
    local list = {}
    self.mModuleMap[type] = list
    for _, v in pairs(_weeklyjobs) do
      local row = self.mTodoListTable[v._id]
      if row and row["Module Type"] == "Guild" then
        local reward = {}
        local shardShow = ed.shopData:getShopOpenVis(6)
        for i = 1, 5 do
          local rewardType = row[string.format("Task Reward %d Type", i)]
          if rewardType and (rewardType ~= "ShardPointDaily" or shardShow) then
            local rewardId = row[string.format("Task Reward %d ID", i)]
            local rewardAmount = row[string.format("Task Reward %d Amount", i)]
            table.insert(reward, {
              type = rewardType,
              id = rewardId,
              amount = rewardAmount
            })
          end
        end
        local item = {
          id = v._id,
          name = row["Task Name"],
          detail = row["Task Detail"],
          trigger = row["Trigger ID"],
          type = row["Task Progress Type"],
          progressid = {
            row["Task Progress ID"]
          },
          target = row["Task Target"],
          reward = reward,
          orderNum = row["Order Num"],
          value = v._task_target,
          lastRewardsTime = v._last_rewards_time
        }
        item.value = math.min(item.value, item.target)
        item.taskState = GetTaskState(item)
        table.insert(list, item)
      end
    end
    sortTaskList(list)
    FireEvent("GuildWeeklyjobReply")
  end
end

function data:weeklyjobRewardReply(info)
  if nil ~= info._job_rewards_reply then
    if (info._result or "success") ~= "success" then
      ed.showToast(T("\230\143\144\228\186\164\229\164\177\232\180\165"))
      return
    end
    local rewardList = {}
    local _activity_reward = info._job_rewards_reply._activity_reward
    for k, v in pairs(_activity_reward or {}) do
      if v._type == "money" then
        v._type = "gold"
      end
      table.insert(rewardList, {
        id = v._id,
        type = v._type,
        amount = v._amount
      })
    end
    local todoTableData = self.mTodoListTable[info.newDaliyTaskId]
    local list = self.mModuleMap[convertToModuleType(todoTableData["Module Type"])]
    if nil ~= list then
      for _, v in ipairs(list) do
        if v.id == info.newDaliyTaskId then
          v.lastRewardsTime = ed.getServerTime()
          v.taskState = data.TaskState.Finish
          for _, rewardV in ipairs(v.reward) do
            if rewardV.type == "RaidPoint" then
              table.insert(rewardList, {
                id = rewardV.id,
                type = rewardV.type,
                amount = rewardV.amount
              })
            end
          end
          break
        end
      end
      sortTaskList(list)
    end
    if 0 < #rewardList then
      local geftItem, exceedItem, giveItemAll = ed.itemExceeds(rewardList)
      giveItemAll = ed.mailItemTidy(giveItemAll)
      ed.ui.maillocalbox.create({
        type = "addItem",
        item = giveItemAll or {}
      }):popWindow()
    end
    ed.player:resetDailyjobTime(info.newDaliyTaskId)
    FireEvent("GuildWeeklyjobReply")
  end
end

function data:convertToModuleTypeByServerType(type)
  if type == "weekly_job_guild" then
    return data.ModuleType.Guild
  else
    return data.ModuleType.Guild
  end
end

function data:convertToServerTypeByModuleType(type)
  if type == data.ModuleType.Guild then
    return "weekly_job_guild"
  else
    return nil
  end
end

function data:weeklyjobRedUpdate(info)
  local changedMap = self.mRedMap
  self.mRedMap = {}
  for k, v in pairs(info._weekly_job_module or {}) do
    local moduleType = self:convertToModuleTypeByServerType(v)
    if nil == self.mRedMap[moduleType] then
      if nil == changedMap[moduleType] then
        changedMap[moduleType] = true
      else
        changedMap[moduleType] = nil
      end
      self.mRedMap[moduleType] = true
    end
  end
  local redPointMgr = ed.redPointMgr.getInstance()
  if changedMap[data.ModuleType.Guild] then
    redPointMgr:setNodeValue(" guild_weeklyjob_enter", self:hasRed(data.ModuleType.Guild) and 1 or 0)
    FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.Guild)
  end
end

ed.weeklyjobData = setmetatable({}, {__index = data}):init()
