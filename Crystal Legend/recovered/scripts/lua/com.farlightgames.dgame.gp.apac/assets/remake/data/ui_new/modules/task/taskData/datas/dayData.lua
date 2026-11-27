local data = {}

function data:init()
  self.todoListTable = ed.getDataTable("Todolist")
  self.todoTriggersTable = ed.getDataTable("TodoTriggers")
  self.pointChestTable = ed.getDataTable("ActPointChest")[6]
  self.dailyPassReward = ed.getDataTable("DailyPassReward")
  self.dayTaskData = {
    finish_daily_job_num = 0,
    finish_daily_job_num_max = self.pointChestTable["DailyJob Requirement"],
    toDayTaskPass = false,
    opened_chest_ids = {}
  }
  ListenEvent("mainSceneEnter", function()
    if not self.dayTaskList then
      self.dayTaskList = self:createTaskDataList()
    end
  end)
  self.passData = setmetatable({}, {
    __index = {
      act_id = 0,
      is_advanced = 0,
      pass_id = nil,
      level = 0,
      total_exp = 0,
      today_exp = 0,
      bonus = 0,
      exp_end_time = 0,
      reward_end_time = 0
    }
  })
  return self
end

function data:getDailyPassReward()
  local row = self:getActPointChestTable()
  local items = {}
  local shardShow = ed.shopData:getShopOpenVis(6)
  for i = 1, 7 do
    local itemType = row[string.format("ActPointChest %d Type", i)]
    if itemType and itemType ~= "" and (itemType ~= "ShardPointDaily" or shardShow) then
      local id = row[string.format("ActPointChest %d ID", i)]
      local amount = row[string.format("ActPointChest %d Amount", i)]
      table.insert(items, {
        id = id,
        type = itemType,
        amount = amount
      })
    end
  end
  return items
end

function data:getNewLvToExp()
  local total_exp = self.passData.total_exp or 0
  local level = self.passData.level or 0
  local rows = self.dailyPassReward[self.passData.pass_id or 1]
  local exp = rows[level - 1] and rows[level - 1].Exp or 0
  local toExp = rows[level] and rows[level].Exp or 0
  local maxPer = toExp - exp
  exp = total_exp - exp
  local per = exp / maxPer
  per = per == 1 and 0.01 or per
  return exp, maxPer, per
end

function data:getExpToLevel()
  local total_exp = self.passData.total_exp or 0
  local rows = self.dailyPassReward[self.passData.pass_id or 1]
  for i, v in ipairs(rows) do
    if total_exp < v.Exp then
      return rows[i].Level
    end
  end
  return rows[#rows].Level
end

function data:getMaxLevel()
  self.oldPassId = self.oldPassId or self.passData.pass_id or 1
  if not self.maxLevel or self.oldPassId ~= (self.passData.pass_id or 0) then
    local maxLevel = 1
    local rows = self.dailyPassReward[self.passData.pass_id or 1]
    for i, v in ipairs(rows) do
      maxLevel = maxLevel < v.Level and v.Level or maxLevel
    end
    self.maxLevel = maxLevel
    self.oldPassId = self.passData.pass_id
  end
  return self.maxLevel
end

function data:getTodayTaskPass(openedChestIds)
  local groupId = 1
  for actPointChestId, cfg in pairs(ed.getDataTable("ActPointChest")) do
    if cfg["Group ID"] == groupId and cfg["ActPoint Chest"] == "DailyJob" and ed.isElementInTable(actPointChestId, openedChestIds) then
      return true
    end
  end
  return false
end

function data:getActPointChestTable()
  local unlockMaxLevel = 0
  local findChestCfg = {}
  print("111111111")
  ed.pt(self.dayTaskData.opened_chest_ids)
  for actPointChestId, cfg in pairs(ed.getDataTable("ActPointChest")) do
    if ed.isElementInTable(actPointChestId, self.dayTaskData.opened_chest_ids) then
      return cfg
    end
    if cfg["ActPoint Chest"] == "DailyJob" then
      local unlockLevel = cfg["Unlock Level"]
      if unlockLevel <= ed.player:getLevel() and unlockMaxLevel < unlockLevel then
        unlockMaxLevel = unlockLevel
        findChestCfg = cfg
      end
    end
  end
  return findChestCfg
end

function data:refreshData(msg)
  msg = ed.copyProto(msg)
  if msg._dailyjob_open_panel then
    msg = msg._dailyjob_open_panel
    self.dayTaskData = {
      finish_daily_job_num = msg._finish_daily_job_num,
      finish_daily_job_num_max = self.pointChestTable["DailyJob Requirement"],
      toDayTaskPass = self:getTodayTaskPass(msg._opened_chest_ids or {}),
      opened_chest_ids = msg._opened_chest_ids or {}
    }
    self.dayTaskList = self:createTaskDataList()
    if msg._daily_pass_daily then
      msg = msg._daily_pass_daily
      self.passData = self.passData or {}
      self.passData.level = msg._level or self.passData.level
      self.passData.is_advanced = msg._is_advanced or self.passData.is_advanced
      local refreshType = ed.taskData:taskReply("pass", {_dayTask_refresh = msg})
      FireEvent("passReply", refreshType)
    end
    self.timelyTitleRes = ed.getDataTable("Activity")[ed.taskData.showPassId] and ed.getDataTable("Activity")[ed.taskData.showPassId]["Title Picture"] or self.timelyTitleRes
    self.titleText = ed.getDataTable("Activity")[ed.taskData.showPassId] and ed.getDataTable("Activity")[ed.taskData.showPassId]["Extra Str"][1] or ""
    local num = self.dayTaskData.toDayTaskPass and 0 or self.dayTaskData.finish_daily_job_num >= self.dayTaskData.finish_daily_job_num_max and 1 or 0
    self:setRed(self:getred() + num)
    local dt = self.passData.exp_end_time - ed.getServerTime()
    self.timeOver = dt <= 0
    self.isToMax = self.passData.level >= self:getMaxLevel()
    self.passData.level = self.passData.level > self:getMaxLevel() and self:getMaxLevel() or self.passData.level
    return "_open_panel"
  elseif msg._dailyjob_open_chest then
    msg = msg._dailyjob_open_chest
    msg._result = msg._result or "success"
    if msg._result ~= "success" then
      ed.showToast(T("\230\143\144\228\186\164\229\164\177\232\180\165"))
      return
    else
      local item = msg._chest_reward or {}
      if item and 0 < #item then
        local rewards = {}
        for i, v in ipairs(item) do
          table.insert(rewards, {
            id = v._id,
            type = v._type,
            amount = v._amount
          })
        end
        local geftItem, exceedItem, giveItemAll = ed.itemExceeds(rewards)
        giveItemAll = ed.mailItemTidy(giveItemAll)
        ed.ui.maillocalbox.create({
          type = "addItem",
          item = giveItemAll or {}
        }):popWindow()
        ed.player:addRewards(item)
      end
      self.dayTaskData.toDayTaskPass = true
      self.dayTaskData.opened_chest_ids = msg._opened_chest_ids or {}
      self:setRed(ed.clamp(self:getred() - 1, 0, self:getred()))
    end
    FireEvent("DailyJobBoxGot")
    return "open_box_chest"
  elseif msg._job_rewards_reply then
    FireEvent("DailyJobRewardGot")
    local newDaliyTaskId = msg.newDaliyTaskId
    msg = msg._job_rewards_reply
    msg._result = msg._result or "success"
    if msg._result ~= "success" then
      ed.showToast(T("\230\143\144\228\186\164\229\164\177\232\180\165"))
      return
    end
    local bonus = self.passData.bonus or 0
    local rewards = msg._activity_reward
    local dt = self.passData.exp_end_time - ed.getServerTime()
    self.timeOver = dt <= 0
    bonus = self.timeOver and 0 or bonus
    self.isToMax = self.passData.level >= self:getMaxLevel()
    if self.isToMax then
      bonus = 0
    end
    local addActpoint = 0
    local item = {}
    for k, v in pairs(rewards or {}) do
      if v._type == "money" then
        v._type = "gold"
      end
      if v._type == "actpoint" then
        v._amount = v._amount * bonus
        addActpoint = addActpoint + v._amount
      end
      table.insert(item, v)
    end
    if item and 0 < #item then
      local allrewards = {}
      for i, v in ipairs(item) do
        table.insert(allrewards, {
          id = v._id,
          type = v._type,
          amount = v._amount
        })
      end
      local geftItem, exceedItem, giveItemAll = ed.itemExceeds(allrewards)
      giveItemAll = ed.mailItemTidy(giveItemAll)
      ed.ui.maillocalbox.create({
        type = "addItem",
        item = giveItemAll or {}
      }):popWindow()
      ed.player:addRewards(item)
    end
    if 0 < addActpoint then
      self.passData = self.passData or {}
      self.passData.total_exp = self.passData.total_exp and self.passData.total_exp + addActpoint or addActpoint
      self.passData.level = self:getExpToLevel()
      self.passData.level = self.passData.level > self:getMaxLevel() and self:getMaxLevel() or self.passData.level
      local refreshType = ed.taskData:taskReply("pass", {
        _dayTask_refresh = {
          _level = self.passData.level,
          _total_exp = self.passData.total_exp
        }
      })
      FireEvent("passReply", refreshType)
    end
    ed.player:resetDailyjobTime(newDaliyTaskId)
    self.dayTaskData.finish_daily_job_num = (self.dayTaskData.finish_daily_job_num or 0) + 1
    self.dayTaskList = self:createTaskDataList()
    if msg._daily_pass_daily then
      local refreshType = ed.taskData:taskReply("pass", {
        _dayTask_refresh = msg._daily_pass_daily
      })
      FireEvent("passReply", refreshType)
    end
    local num = self.dayTaskData.toDayTaskPass and 0 or self.dayTaskData.finish_daily_job_num >= self.dayTaskData.finish_daily_job_num_max and 1 or 0
    self:setRed(self:getred() + num)
    return "job_rewards_reply"
  elseif msg._daily_pass then
    self.passData = msg._daily_pass
    self.passData.level = self.passData.level > self:getMaxLevel() and self:getMaxLevel() or self.passData.level
    return
  elseif msg._increaseDailyjobCount then
    self.dayTaskList = self:createTaskDataList()
    local num = self.dayTaskData.toDayTaskPass and 0 or self.dayTaskData.finish_daily_job_num >= self.dayTaskData.finish_daily_job_num_max and 1 or 0
    self:setRed(self:getred() + num)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
    return "increase_dailyjobCount"
  elseif msg._dailyjob_onekey then
    FireEvent("DailyJobRewardGot")
    msg = msg._dailyjob_onekey
    msg._result = msg._result or "success"
    if msg._result ~= "success" then
      ed.showToast(T("\230\143\144\228\186\164\229\164\177\232\180\165"))
      return
    end
    if msg._exp_bonus and 0 < msg._exp_bonus then
      local bonuxExp = msg._exp_bonus
      ed.player:addExp(bonuxExp)
    end
    local bonus = self.passData.bonus or 0
    local rewards = msg._activity_reward
    local dt = self.passData.exp_end_time - ed.getServerTime()
    self.timeOver = dt <= 0
    bonus = self.timeOver and 0 or bonus
    self.isToMax = self.passData.level >= self:getMaxLevel()
    if self.isToMax then
      bonus = 0
    end
    local addActpoint = 0
    local item = {}
    for k, v in pairs(rewards or {}) do
      if v._type == "money" then
        v._type = "gold"
      end
      if v._type == "actpoint" then
        v._amount = v._amount * bonus
        addActpoint = addActpoint + v._amount
      end
      table.insert(item, v)
    end
    if item and 0 < #item then
      local allrewards = {}
      for i, v in ipairs(item) do
        table.insert(allrewards, {
          id = v._id,
          type = v._type,
          amount = v._amount
        })
      end
      local geftItem, exceedItem, giveItemAll = ed.itemExceeds(allrewards)
      giveItemAll = ed.mailItemTidy(giveItemAll)
      ed.ui.maillocalbox.create({
        type = "addItem",
        item = giveItemAll or {}
      }):popWindow()
      ed.player:addRewards(item)
    end
    if 0 < addActpoint then
      self.passData = self.passData or {}
      self.passData.total_exp = self.passData.total_exp and self.passData.total_exp + addActpoint or addActpoint
      self.passData.level = self:getExpToLevel()
      self.passData.level = self.passData.level > self:getMaxLevel() and self:getMaxLevel() or self.passData.level
      local refreshType = ed.taskData:taskReply("pass", {
        _dayTask_refresh = {
          _level = self.passData.level,
          _total_exp = self.passData.total_exp
        }
      })
      FireEvent("passReply", refreshType)
    end
    for i, v in ipairs(self.oneKeys) do
      ed.player:resetDailyjobTime(v)
    end
    self.dayTaskData.finish_daily_job_num = (self.dayTaskData.finish_daily_job_num or 0) + #self.oneKeys
    self.dayTaskList = self:createTaskDataList()
    if msg._daily_pass_daily then
      local refreshType = ed.taskData:taskReply("pass", {
        _dayTask_refresh = msg._daily_pass_daily
      })
      FireEvent("passReply", refreshType)
    end
    local num = self.dayTaskData.toDayTaskPass and 0 or self.dayTaskData.finish_daily_job_num >= self.dayTaskData.finish_daily_job_num_max and 1 or 0
    self:setRed(self:getred() + num)
    return "job_rewards_reply"
  elseif msg._error_code then
    ed.showAlertDialog({
      text = msg._error_code
    })
  end
end

function data:setRed(num)
  self.reds = num or 0
end

function data:getred()
  if ed.GobackManager:getDailyTaskRedLight() then
    return 1
  end
  return self.reds or 0
end

function data:createTaskDataList()
  local taskDataList = {}
  local dailyjobData = ed.player._dailyjobs or {}
  local dailyRed = 0
  local oneKeys = {}
  for _, data in pairs(dailyjobData) do
    local taskData = self:initTaskData(data)
    if taskData then
      table.insert(taskDataList, taskData)
      if not taskData.isPass and taskData.isCompleted then
        dailyRed = dailyRed + 1
        table.insert(oneKeys, taskData.id)
      end
    end
  end
  self.oneKeys = oneKeys
  self:setRed(dailyRed)
  
  local function orderTaskList(tasksList)
    local function concatTwoTable(source, target)
      for _, data in ipairs(target) do
        table.insert(source, data)
      end
    end
    
    local function sort(task1, task2)
      if task1.orderNum == task2.orderNum then
        return task1.id < task2.id
      else
        return task1.orderNum < task2.orderNum
      end
    end
    
    table.sort(tasksList, sort)
    local topList = {}
    local completedList = {}
    local otherList = {}
    local passList = {}
    for _, task in ipairs(tasksList) do
      local info = task
      if info.isPass then
        table.insert(passList, task)
      elseif info.isCompleted then
        table.insert(completedList, task)
      elseif info.topTrigger then
        table.insert(topList, task)
      else
        table.insert(otherList, task)
      end
    end
    concatTwoTable(completedList, topList)
    concatTwoTable(completedList, otherList)
    concatTwoTable(completedList, passList)
    return completedList
  end
  
  return orderTaskList(ed.copyTable(taskDataList))
end

function data:initTaskData(info)
  local id = info._id
  local row = self.todoListTable[id]
  if row and row["Mission Type"] ~= "WeeklyMission" then
    local pid = {
      row["Task Progress ID"]
    }
    local name = row["Task Name"]
    local trigger = row["Trigger ID"]
    local detail = row["Task Detail"]
    local target = row["Task Target"]
    local taskprocessType = row["Task Progress Type"]
    local lastTime = info._last_rewards_time
    local count = ed.player:getDailyjobCount(id)
    local orderNum = row["Order Num"]
    local reward = self:getTaskReward(id)
    local task = {
      kind = "daily",
      id = id,
      type = taskprocessType,
      name = name,
      trigger = trigger,
      detail = detail,
      target = target,
      progress = math.min(count, target),
      progressid = pid,
      isCompleted = target <= count,
      lastTime = lastTime,
      reward = reward,
      orderNum = orderNum,
      topTrigger = ed.isElementInTable(id, self.topTriggerIds)
    }
    if taskprocessType == "Login" then
      return nil
    elseif self:isShow(task) then
      return task
    else
      return nil
    end
  end
end

function data:isShow(task)
  local lt = task.lastTime
  local nt = ed.getServerTime()
  if not ed.isElementInTable(task.type, {
    "MonthlyCardPeriod",
    "SuperMonthlyCardPeriod"
  }) then
    task.isPass = not ed.checkTwoDateod(lt, nt) and lt ~= 0
    if task.isPass then
      return true
    end
  end
  if self:checkDailyjobTrigger(task.id) and self:checkDailyjobDisplay(task.id) then
    return true
  else
    return false
  end
end

function data:getTaskReward(id)
  local row = self.todoListTable[id]
  local reward = {}
  local shardShow = ed.shopData:getShopOpenVis(6)
  for i = 1, 5 do
    local type = row[string.format("Task Reward %d Type", i)]
    if type and (type ~= "ShardPointDaily" or shardShow) then
      local id = row[string.format("Task Reward %d ID", i)]
      local amount = row[string.format("Task Reward %d Amount", i)]
      table.insert(reward, {
        type = type,
        id = id,
        amount = amount
      })
    end
  end
  return reward
end

function data:checkDailyjobTrigger(id)
  local tdt = ed.getDataTable("Todolist")
  local tdrow = tdt[id]
  if not tdrow then
    return
  end
  local tg = tdrow["Trigger ID"]
  local ids = {}
  tg = tg or {}
  if #tg < 1 then
    return true
  end
  for k, v in pairs(tg) do
    if 0 < v then
      table.insert(ids, v)
    end
  end
  for k, v in pairs(ids or {}) do
    local isTrger = self:checkTriggers(v)
    if not isTrger then
      return false
    end
  end
  return true
end

function data:checkDailyjobDisplay(id)
  local row = ed.getDataTable("Todolist")[id]
  if not row then
    return false
  end
  local dts = row["Display Time"]
  if #(dts or {}) == 0 then
    return true
  else
    return ed.checkTimeBetween({rangeString = dts})
  end
  return false
end

function data:checkTriggers(id)
  local row = self.todoTriggersTable[id]
  local type = row["Trigger Type"]
  local condition = row["Trigger Condition"]
  local notes = row["Notice Info"]
  if type == "VIPLevel" then
    if condition > ed.player:getvip() then
      return false
    end
  elseif type == "VIPLevelLessThan" then
    if condition <= ed.player:getvip() then
      return false
    end
  elseif type == "DailyTimeAfter" then
    if not ed.isTimeAfter(condition) then
      return false
    end
  elseif type == "DailyTimeBefore" then
    if not ed.isTimeBefore(condition) then
      return false
    end
  elseif type == "VIPLevelEqual" then
    if ed.player:getvip() ~= condition then
      return false
    end
  elseif type == "TopLevelNotReach" then
    local maxLevel = ed.parameter.team_level_max
    if maxLevel <= ed.player:getLevel() then
      return false
    end
  elseif type == "TopLevelReach" then
    local maxLevel = ed.parameter.team_level_max
    if maxLevel > ed.player:getLevel() then
      return false
    end
  elseif type == "NotVitalityActivity" then
    if self.dailyJobInfo == 1 then
      return false
    end
  elseif type == "VitalityActivity" then
    if self.dailyJobInfo == 0 then
      return false
    end
  elseif type == "TodayNotCompleteTodotaskID" then
    for k, n in pairs(ed.player._dailyjobs) do
      if n._id == condition and not ed.checkTwoDateod(n._last_rewards_time, ed.getServerTime()) then
        return false
      end
    end
  elseif type == "NotSameMonth" then
    local lastTime = ed.player._dailyjobs[condition]._last_rewards_time
    local curTime = ed.getServerTime()
    local lastYMDHMS = ed.getYMDHMS(lastTime)
    local curYMDHMS = ed.getYMDHMS(curTime)
    if lastTime ~= 0 and lastYMDHMS.year >= curYMDHMS.year and curYMDHMS.month <= lastYMDHMS.month then
      return false
    end
  elseif type == "ServerLevelLimitID" then
    local limitid = ed.monsterseal.monsterseal_object:getLimitID()
    local milestoneid = ed.monsterseal.monsterseal_object:getMileStoneID()
    if condition > limitid or limitid == condition and milestoneid ~= 0 then
      return false
    end
  elseif type == "GuildHeroTopLevelNotReach" then
    if self.guildhero_cur_level then
      if self.guildhero_cur_level == self.guildhero_max_level then
        return false
      end
    else
      return false
    end
  elseif type == "GuildHeroTopLevelReach" then
    if self.guildhero_cur_level then
      if self.guildhero_cur_level ~= self.guildhero_max_level then
        return false
      end
    else
      return false
    end
  elseif type == "Weekday" then
    local week = ed.getRefreshWeek()
    if condition ~= week then
      return false
    end
  elseif type == "HaveGuild" then
    if 0 == ed.player:getGuildId() then
      return false
    end
  elseif type == "NotHaveGuildMonthCard" then
    local guildleftdays = ed.player:getMonthCardLeftTimes(ed.parameter.guild_month_card)
    if 0 < guildleftdays and ed.player:getGuildId() ~= 0 then
      return false
    end
  elseif type == "RegionNotAppstore" then
    if big_area == "appstore" then
      return false
    end
  elseif type == "AwakeHeroNum" then
    if condition > ed.player:getAwakeHeroAmount() then
      return false
    end
  elseif type == "PlayerLevelLessThan" then
    if condition <= ed.player:getLevel() then
      return false
    end
  elseif type == "CompleteStage" then
    if 0 >= ed.player:getStageStar(condition) then
      return false
    end
  elseif type == "PlayerLevel" then
    if condition > ed.player:getLevel() then
      return false
    end
  elseif type == "HaveItem" then
    if ed.player:getEquipAmount(condition) == 0 then
      return false
    end
  elseif type == "TowerComplete" then
    if condition > ed.player:getLevel() then
      return false
    end
  elseif type == "StartTime" then
    if condition > ed.getServerTime() then
      return false
    end
  elseif type == "EndTime" then
    if condition < ed.getServerTime() then
      return false
    end
  elseif type == "QuestBoardLevel" then
    if condition > ed.player:getQuestBuildingLevel() then
      return false
    end
  elseif type == "Mentorship" then
    if condition > ed.player:getLevel() then
      return false
    end
  elseif type == "PlatformID" then
    if EDSDKType ~= condition then
      return false
    end
  elseif type == "CompleteStageID" then
    if 1 > ed.player:getStageStar(condition) then
      return false, notes
    end
  elseif type == "Titan98Star8" then
    local count = 0
    local tbl = ed.getDataTable("TitanToHeros")
    for id, info in pairs(tbl) do
      if id ~= "name" and tonumber(id) and 0 == info.MatrixHeroID1 then
        local hero = ed.player:getHero(id)
        if hero and hero._stars >= 8 then
          count = count + 1
        end
      end
    end
    return condition <= count
  elseif type == "TitanStar7" then
    local count = 0
    local tbl = ed.getDataTable("TitanToHeros")
    for id, info in pairs(tbl) do
      if id ~= "name" and tonumber(id) and 0 ~= info.MatrixHeroID1 then
        local hero = ed.player:getHero(id)
        if hero and hero._stars >= 7 then
          count = count + 1
        end
      end
    end
    return condition <= count
  elseif type == "DungeonOpen" then
    return ed.awakeDungeonMgr:awakeDungeonIsOpen()
  end
  return true
end

return setmetatable({}, {__index = data}):init()
