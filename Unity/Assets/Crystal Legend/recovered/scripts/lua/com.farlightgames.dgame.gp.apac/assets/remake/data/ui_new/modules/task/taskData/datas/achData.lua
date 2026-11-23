local data = {}

function data:init()
end

function data:refreshData(msg)
  msg = ed.copyProto(msg)
  if msg._open_panel then
    msg = msg._open_panel
    self.pointReward = msg._take_point_reward or {}
    self.achievementtasks, self.types = self:initTasks(msg._tasks)
    self.achTasks = self:getShowTasks()
    self.achTitle = {
      point = msg._point or 0,
      total = msg._total or 0,
      progress = msg._progress or 0,
      cups = msg._cups or {}
    }
    return "open_panel"
  elseif msg._require_rewards then
    msg = msg._require_rewards
    local item = msg._rewards or {}
    if item and 0 < #item then
      ed.player:addRewards(item)
    end
    ed.ui.maillocalbox.create({
      type = "addItem",
      item = self.giveItemAll or {}
    }):popWindow()
    self.giveItemAll = {}
    return "require_rewards"
  elseif msg._point_rewards then
    ed.ui.maillocalbox.create({
      type = "addItem",
      item = self.giveItemAll or {}
    }):popWindow()
    self.giveItemAll = {}
    msg = msg._point_rewards
    local item = msg._rewards or {}
    if item and 0 < #item then
      ed.player:addRewards(item)
    end
    return "point_rewards"
  end
end

local targetmMax = {CompleteStage = 1, AppointHeroPass = 1}
local targetNum = {SummonLucky = 1, SummonTimelyLucky = 1}

function data:initTasks(data)
  local tasks = {}
  local types = {}
  local tb = ed.getDataTable("Achievement")
  for i, v in pairs(data) do
    local task = {}
    if tb[v._line_id] and tb[v._line_id][v._id] then
      local row = tb[v._line_id][v._id]
      task.line_id = v._line_id
      task.id = v._id
      task.progress = v._progress
      task.target = row.Target
      task.target = targetmMax[row["Progress Type"]] or task.target
      task.isComplete = task.progress >= task.target
      task.target = targetNum[row["Progress Type"]] or task.target
      task.progress = targetNum[row["Progress Type"]] and (task.isComplete and task.target or 0) or task.isComplete and task.target or task.progress
      if not row.Hide or row.Hide and task.isComplete then
        tasks[v._type] = tasks[v._type] or {}
        tasks[v._type][v._line_id] = tasks[v._type][v._line_id] or {}
        if v._reward_time ~= 0 then
          task.isRewarded = true
        end
        if v._done_time ~= 0 then
          task.reward_time = v._done_time
        end
        if v._id == 1 then
          task.isShow = true
        else
          local con = true
          for i = v._id - 1, 1, -1 do
            local tmp = tasks[v._type][v._line_id][i]
            if tmp and not tmp.isComplete then
              task.isShow = false
              task.isComplete = false
              con = false
              break
            end
          end
          if con then
            if task.isComplete then
              task.isShow = true
            else
              local tmp = tasks[v._type][v._line_id][v._id - 1]
              if tmp and tmp.isComplete then
                task.isShow = true
                if tmp.reward and not tmp.isRewarded then
                  task.isShow = false
                end
              else
                task.isShow = false
              end
            end
          end
        end
        if task.isComplete then
          task.done_time = v._done_time
        end
        task.type = v._type
        task.type_name = row["Type Name"]
        task.name = row.Name
        task.description = row.Description
        task.icon = row["Icon UI"]
        task.point = row["Achievement Point"]
        if row["Reward Type"] then
          task.reward = {}
          task.reward.type = row["Reward Type"]
          task.reward.id = row["Reward ID"]
          task.reward.count = row["Reward Count"]
        end
        types[task.type] = task.type_name
        tasks[v._type][v._line_id][v._id] = task
        if not task.isComplete or task.isShow then
        end
        task.prompt = row.Prompt
        task.ProgressType = row["Progress Type"]
        task.cupType = row["Cup Type"]
      end
    else
      print(" is nil _id : ", v._id)
      print(" is nil _line_id : ", v._line_id)
      ed.showToast(T("\230\136\144\229\176\177\230\149\176\230\141\174\233\148\153\232\175\175[") .. (v._line_id or "nil") .. "," .. (v._id or "nil") .. "]")
    end
  end
  local tmp = {}
  for k, v in pairs(types) do
    tmp[k] = tmp[k] or true
  end
  return tasks, tmp
end

function data:getShowTasks()
  local showtasks = {}
  local showPageRed = 0
  for type, typetasks in pairs(self.achievementtasks) do
    showtasks[type] = showtasks[type] or {}
    local top = {}
    local middle = {}
    local bottom = {}
    local reds = 0
    for lineId, linetasks in pairs(typetasks) do
      for id, task in pairs(linetasks) do
        if task.isShow then
          if task.isComplete then
            if task.reward and not task.isRewarded then
              table.insert(top, task)
              reds = reds + 1
            else
              table.insert(bottom, task)
            end
          else
            table.insert(middle, task)
          end
        end
      end
    end
    self:setModeRed(type, reds)
    showPageRed = showPageRed + reds
    table.sort(top, function(a, b)
      return a.id + a.line_id < b.id + b.line_id
    end)
    table.sort(middle, function(a, b)
      return a.id + a.line_id < b.id + b.line_id
    end)
    table.sort(bottom, function(a, b)
      return a.id + a.line_id < b.id + b.line_id
    end)
    for i, task in ipairs(top) do
      table.insert(showtasks[type], task)
    end
    for i, task in ipairs(middle) do
      table.insert(showtasks[type], task)
    end
    for i, task in ipairs(bottom) do
      table.insert(showtasks[type], task)
    end
  end
  self:setRed(showPageRed)
  return showtasks
end

function data:getPointReward()
  if self.pointRewardConfig then
    return self.pointRewardConfig
  end
  local tb = ed.getDataTable("AchievementPointReward")
  local newTab, tab = {}, {}
  for i, v in ipairs(tb) do
    tab = {}
    tab.id = v.ID
    tab.point = v["Achievement Point"]
    tab.item = {
      {
        id = v["Reward ID"],
        type = v["Reward Type"],
        amount = v["Reward Amount"]
      }
    }
    table.insert(newTab, tab)
  end
  self.pointRewardConfig = newTab
  return newTab
end

function data:getPointListItems()
  self.achTitle = self.achTitle or {}
  local point = self.achTitle.point or 0
  local pointReward = self.pointReward or {}
  local listItems = {}
  for i, v in ipairs(self:getPointReward()) do
    table.insert(listItems, setmetatable({
      isPass = ed.isElementInTable(v.id, pointReward),
      newPoint = point,
      index = i
    }, {__index = v}))
  end
  table.sort(listItems, function(a, b)
    if a == nil or b == nil or b == a then
      return false
    end
    return (a.isPass and 999 or a.index) < (b.isPass and 999 or b.index)
  end)
  return listItems
end

function data:getPointRedVis()
  self.achTitle = self.achTitle or {}
  local point = self.achTitle.point or 0
  local pointReward = self.pointReward or {}
  for i, v in ipairs(self:getPointReward()) do
    local isPass = ed.isElementInTable(v.id, pointReward)
    local vis = false
    if not isPass then
      vis = point >= v.point
    end
    if vis then
      return vis
    end
  end
  return false
end

function data:getAchName(line_id, id)
  local tb = ed.getDataTable("Achievement")
  local row = tb[line_id or 1][id or 1]
  return row.Name or "nil"
end

function data:getAchCupType(line_id, id)
  local tb = ed.getDataTable("Achievement")
  local row = tb[line_id or 1][id or 1]
  return row["Cup Type"] or "Copper Cup"
end

function data:setModeRed(mode, num)
  self.modeReds = self.modeReds or {}
  self.modeReds[mode] = num or 0
end

function data:getModeRed(mode)
  self.modeReds = self.modeReds or {}
  return self.modeReds[mode] or 0
end

function data:setRed(num)
  self.reds = num or 0
end

function data:getred()
  return self.reds and self.reds > 0 and self.reds or self:getPointRedVis() and 1 or 0
end

local function create()
  local object = {}
  setmetatable(object, {__index = data})
  object:init()
  return object
end

return create()
