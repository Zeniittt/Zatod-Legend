local data = {}

function data:init()
  self.passItems = {}
  self.dailyPassReward = ed.getDataTable("DailyPassReward")
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
      reward_end_time = 0,
      timelyTitleRes = "UI/alpha/1080P/taskModel/day_task/day_task_title_str_img.png"
    }
  })
end

function data:getNewLvToExp()
  self.dailyPassReward = self.dailyPassReward or ed.getDataTable("DailyPassReward")
  local total_exp = self.passData.total_exp or 0
  local level = self.passData.level or 0
  local rows = self.dailyPassReward[self.passData.pass_id or 1] or {}
  local exp = rows[level - 1] and rows[level - 1].Exp or 0
  local toExp = rows[level] and rows[level].Exp or 0
  local maxPer = toExp - exp
  exp = total_exp - exp
  local per = exp / maxPer
  per = per == 1 and 0.01 or per
  return exp, maxPer, per
end

function data:getMaxLevel()
  self.dailyPassReward = self.dailyPassReward or ed.getDataTable("DailyPassReward")
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

function data:getDayPassInfo()
  self.dailyPassReward = self.dailyPassReward or ed.getDataTable("DailyPassReward")
  local csvTab, newTab = self.dailyPassReward[self.passData.pass_id or 1] or {}, {}
  
  local function getReward(row, prefix, dub)
    local type = row[prefix .. "Reward Type" .. dub]
    local id = row[prefix .. "Reward ID" .. dub]
    local amount = row[prefix .. "Reward Amount" .. dub]
    if type and amount then
      return {
        type = type,
        id = id,
        amount = amount
      }
    end
    return
  end
  
  for k, v in ipairs(csvTab) do
    local item = {
      level = v.Level,
      normalReward = {
        getReward(v, "", "")
      },
      advancedReward = {
        getReward(v, "Adv ", "1"),
        getReward(v, "Adv ", "2")
      },
      exp = v.Exp,
      highlight = v.Highlight
    }
    table.insert(newTab, item)
  end
  return newTab
end

function data:getAdvancedReward(notLv)
  local itemlight = {}
  for i, v in ipairs(self:getDayPassInfo()) do
    if not notLv or notLv ~= i then
      for e, m in ipairs(v.advancedReward) do
        table.insert(itemlight, m)
      end
    end
  end
  return ed.overlapping(itemlight)
end

function data:getAdvancedRewardToLevel(level)
  for i, v in ipairs(self:getDayPassInfo()) do
    if (level or 1) == v.level then
      return v.advancedReward
    end
  end
end

function data:getReceiveAllItems(level)
  if not (self.passItems and self.passItems.free_pass and self.passItems.advanced_pass) or not self.passData.level then
    return {}
  end
  local newLevel = level or self.passData.level
  local isAdv = self.passData.is_advanced > 0
  local itemAll = {}
  for i, v in ipairs(self:getDayPassInfo()) do
    if newLevel < v.level then
      break
    end
    for e, m in ipairs(v.normalReward) do
      if not ed.isElementInTable(e, self.passItems.free_pass[v.level]) then
        table.insert(itemAll, m)
      end
    end
    if isAdv then
      for e, m in ipairs(v.advancedReward) do
        if not ed.isElementInTable(e, self.passItems.advanced_pass[v.level]) then
          table.insert(itemAll, m)
        end
      end
    end
  end
  return itemAll
end

function data:getBuyLevelToTaskExp(buyLv)
  local eddTime = self.passData.exp_end_time
  local rows = self.dailyPassReward[self.passData.pass_id or 1] or {}
  local everyDayExp = 880
  everyDayExp = everyDayExp * (self.passData.bonus or 1)
  local maxLv = self:getMaxLevel()
  local newLv = self.passData.level + (buyLv or 0) - 1
  newLv = newLv < 1 and 1 or newLv
  local needExp = rows[maxLv].Exp - rows[newLv].Exp
  local needDay = math.ceil(needExp / everyDayExp)
  local dt = eddTime - ed.getServerTime()
  local d = 0
  if 0 < dt then
    d = math.ceil(dt / 86400)
  end
  return needDay > d
end

function data:refreshData(msg)
  msg = ed.copyProto(msg)
  if msg._open_panel then
    msg = msg._open_panel
    if self.passData.is_advanced and self.passData.is_advanced == 0 and msg._daily_pass and msg._daily_pass._is_advanced == 1 then
      FireEvent("QueryDataRsp", true)
    end
    self.passData = {
      exp_end_time = msg._exp_end_time,
      reward_end_time = msg._reward_end_time,
      bonus = msg._bonus
    }
    self:setRed(msg._reward_count)
    msg = msg._daily_pass or {}
    self.passData.act_id = msg._act_id or 0
    self.passData.is_advanced = msg._is_advanced or 0
    self.passData.pass_id = msg._pass_id or 1
    self.passData.level = msg._level or 0
    self.passData.total_exp = msg._total_exp or 0
    self.passData.today_exp = msg._today_exp or 0
    if self.passData.bonus then
      local refreshType = ed.taskData:taskReply("day", {
        _daily_pass = self.passData
      })
      FireEvent("passReply", refreshType)
    end
    self.timelyTitleRes = ed.getDataTable("Activity")[ed.taskData.showPassId] and ed.getDataTable("Activity")[ed.taskData.showPassId]["Title Picture"] or self.timelyTitleRes
    self.titleText = ed.getDataTable("Activity")[ed.taskData.showPassId] and ed.getDataTable("Activity")[ed.taskData.showPassId]["Extra Str"][1] or ""
    self.passItems = {}
    local tab = {}
    for i, v in ipairs(msg._free_pass_flags or {}) do
      tab[v._index] = v._reward_idx
    end
    self.passItems.free_pass = tab
    tab = {}
    for i, v in ipairs(msg._advanced_pass_flags or {}) do
      tab[v._index] = v._reward_idx
    end
    self.passItems.advanced_pass = tab
    self.isToMax = self.passData.level >= self:getMaxLevel()
    self.passData.level = self.passData.level > self:getMaxLevel() and self:getMaxLevel() or self.passData.level
    return "open_panel"
  elseif msg._level_reward then
    msg = msg._level_reward
    local flageTab = msg._is_advanced and msg._is_advanced == 1 and self.passItems.advanced_pass or self.passItems.free_pass
    local tab = flageTab[msg._index] or {}
    if not ed.isElementInTable(msg._reward_index, tab) then
      table.insert(tab, msg._reward_index)
    end
    flageTab[msg._index] = tab
    self:setRed(msg._reward_count)
    local allrewards = {}
    for i, v in ipairs(msg._rewards) do
      table.insert(allrewards, {
        id = v._id,
        type = v._type,
        amount = v._amount
      })
    end
    local geftItem, exceedItem, giveItemAll = ed.itemExceeds(allrewards)
    ed.ui.maillocalbox.create({
      type = "addItem",
      item = giveItemAll or {}
    }):popWindow()
    ed.player:addRewards(msg._rewards or {})
    self.levelRewardIndex = msg._index
    return "level_reward"
  elseif msg._sweep_reward then
    msg = msg._sweep_reward
    local tab = {}
    for i, v in ipairs(msg._free_pass_flags or {}) do
      tab[v._index] = v._reward_idx
    end
    self.passItems.free_pass = tab
    tab = {}
    for i, v in ipairs(msg._advanced_pass_flags or {}) do
      tab[v._index] = v._reward_idx
    end
    self.passItems.advanced_pass = tab
    self:setRed(msg._reward_count or 0)
    ed.ui.maillocalbox.create({
      type = "addItem",
      item = self.giveItemAll or {}
    }):popWindow()
    local items = {}
    for _, reward in ipairs(self.geftItem or {}) do
      table.insert(items, {
        _type = reward.type,
        _id = reward.id,
        _amount = reward.amount
      })
    end
    ed.player:addRewards(items)
    return "sweep_reward"
  elseif msg._dayTask_refresh then
    msg = msg._dayTask_refresh
    self.passData = self.passData or {}
    self.passData.level = msg._level or self.passData.level
    self.passData.is_advanced = msg._is_advanced or self.passData.is_advanced
    self.passData.total_exp = msg._total_exp or self.passData.total_exp
    self.passData.level = self.passData.level > self:getMaxLevel() and self:getMaxLevel() or self.passData.level
    self:setRed(msg._reward_count)
  elseif msg._buy_level then
    msg = msg._buy_level
    ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159\239\188\129"))
    self.passData.level = msg._level or 0
    self.passData.total_exp = msg._total_exp or 0
    self.passData.today_exp = msg._today_exp or 0
    ed.player:setrmb(msg._diamond)
    self.isToMax = self.passData.level >= self:getMaxLevel()
    self:setRed(self:getred() + 1)
    return "buy_level"
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
  return self.reds or 0
end

local function create()
  local object = {}
  setmetatable(object, {__index = data})
  object:init()
  return object
end

return create()
