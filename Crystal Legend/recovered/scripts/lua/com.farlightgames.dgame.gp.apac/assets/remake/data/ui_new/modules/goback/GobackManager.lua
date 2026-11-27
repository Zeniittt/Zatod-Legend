local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.isDebug()
  return false
end

function class:isActiving()
  return self.activing
end

function class:setActiving(isActiving)
  self.activing = isActiving
end

function class:initRedTree()
  self.redTree = {
    Main = {
      Notify = function()
        return self.notifyRedLight
      end,
      MailRed = function()
        return not self.onceFlag
      end,
      LoginPage = self:getLoginPageLight(),
      TaskPage = self:getTaskPageLight(),
      GiftPage = self:getGiftPageLight()
    }
  }
end

function class:getValue(data)
  local redLight = false
  if type(data) == "table" then
    for k, v in pairs(data) do
      redLight = redLight or self:getValue(v)
    end
  elseif type(data) == "function" then
    redLight = redLight or data()
  else
    redLight = redLight or data
  end
  return redLight
end

function class:getValueInTree(key, tree)
  local tree = tree or self.redTree
  for k, v in pairs(tree) do
    if k == key then
      return self:getValue(v)
    elseif type(v) == "table" then
      local ret = self:getValueInTree(key, v)
      if ret ~= nil then
        return ret
      end
    end
  end
end

function class:getRedLight()
  local redLight = self.notifyRedLight or not self.onceFlag
  redLight = redLight or self:getLoginPageLight()
  redLight = redLight or self:getTaskPageLight()
  redLight = redLight or self:getGiftPageLight()
  return redLight
end

function class:getLoginPageLight()
  local day = math.min(self.loginDays, 7)
  for i = 1, day do
    if not ed.isElementInTable(i, self.lineFlags) then
      return true
    end
  end
  return false
end

function class:getTaskPageLight()
  for k, v in ipairs(self.lineTasks or {}) do
    if v.progress <= self.taskLine and not ed.isElementInTable(k, self.taskLineFlags) then
      return true
    end
  end
  return false
end

function class:getGiftPageLight()
  for k, v in ipairs(self.giftList) do
    if v.price == 0 and v.buyTime == 0 then
      return true
    end
  end
  return false
end

function class:getViewFlag()
  return self.viewFlag
end

function class:setViewFlag(viewFlag)
  self.viewFlag = viewFlag
end

function class:setNotifyRedLight(flag)
  self.notifyRedLight = flag
end

function class:initData()
  self.notifyRedLight = false
  self.viewFlag = false
  self.taskRedLight = false
  self.activing = false
  self.loginDays = 0
  self.activityId = 0
  ListenEvent("GobackMailFirstOpen", function()
    self:setActiving(true)
    self:setViewFlag(true)
    self:setDailyTaskRedLight(true)
    FireEvent("RefreshRightTopButtons")
  end)
end

function class:getDailyTaskRedLight()
  return self.taskRedLight
end

function class:setDailyTaskRedLight(force)
  if force ~= nil then
    self.taskRedLight = force
    return
  end
  local lastLoginTime = ed.storage.getInt("LastLoginTime") or 99999
  local y, m, d = ed.time2YMDHMS(lastLoginTime - 18000)
  local ty, tm, td = ed.time2YMDHMS(ed.getServerTime() - 18000)
  if y ~= ty or m ~= tm or d ~= td then
    self.taskRedLight = true
    ed.storage.setValue("LastLoginTime", ed.getServerTime())
  end
end

function class:initServerData(data)
  if not data._act_id or data._act_id == 0 then
    self.activityId = 0
    ed.GobackManager:setActiving(false)
    FireEvent("RefreshRightTopButtons")
    return
  end
  ed.GobackManager:setActiving(data._view_flag == 1)
  self:setViewFlag(data._view_flag == 1)
  self.activityId = data._act_id
  self:setDailyTaskRedLight()
  self.startTime = data._active_time or 0
  local durationHour = ed.getDataTable("GobackAct")[self.activityId]["Duration Hour"]
  self.endTime = self.startTime + durationHour * 3600
  self.onceFlag = data._once_reward_flag == 1
  self.lineFlags = data._login_reward_flags or {}
  self.loginDays = data._login_day_acc or 0
  self:initLoginRewads()
  self.goodBuyFlags = {}
  for k, v in ipairs(data._goods_buy_flags or {}) do
    self.goodBuyFlags[v._goods_id] = v._buy_time
  end
  self:initGiftRewards()
  self.bonusList = data._bonus_list or {}
  self:initPrivilegeList()
  self.taskLine = data._task_line_progress or 0
  self.taskLineFlags = data._task_line_reward_flags or {}
  self:initLineTasks()
  self.leftDays = data._left_days or 1
  self:initBuffsForDisplay()
end

function class:initPrivilegeList()
  self.privilegeList = {}
  local tb = ed.getDataTable("GobackBonus")
  for k, v in ipairs(tb) do
    self.privilegeList[k] = {
      id = v.ID,
      type = v.Type,
      detail = v["Type Detail"],
      duration = v["Duration Hour"],
      param = v.Parameter,
      buffText = v["Buff Text"],
      bgRes = v["Buff Picture"],
      iconRes = v["Buff Icon"]
    }
  end
  for k, v in ipairs(self.bonusList) do
    local privilege = self.privilegeList[v._id]
    privilege.used = v._used
    privilege.endTime = self.startTime + privilege.duration * 3600
  end
end

function class:isInBuyVitDiscount()
  if not self.activing then
    return false
  end
  for k, bonus in ipairs(self.privilegeList or {}) do
    if bonus.type == "buy_vitality_discount" and bonus.used < bonus.param and bonus.endTime > ed.getServerTime() then
      return true, bonus.param
    end
  end
end

function class:initBuffsForDisplay()
  for k, bonus in ipairs(self.privilegeList) do
    if bonus.used < bonus.param then
      local buff = {
        icon = bonus.iconRes,
        content = bonus.detail,
        endTime = bonus.endTime,
        type = bonus.type
      }
      if bonus.type == "buy_vitality_discount" then
        buff.displayScene = {"MainScene"}
      elseif bonus.type == "elite_stage_item_multi" then
        buff.displayScene = {
          "MainScene",
          "stageselect"
        }
      elseif bonus.type == "cruspoint_multi" then
        buff.displayScene = {"MainScene", "crusade"}
      end
      ed.activityBuffMgr.getInstance():addExtraBuff(buff.type, buff)
    end
  end
end

function class:getPrivilegeList()
  return self.privilegeList
end

function class:getDayState(id)
  if ed.isElementInTable(id, self.lineFlags) then
    return "Got"
  elseif id <= self.loginDays then
    return "CanGet"
  else
    return "UnGet"
  end
end

function class:initLoginRewads()
  self.loginRewards = {}
  local numOfdays = 7
  local tb = ed.getDataTable("GobackLoginReward")
  for i = 1, numOfdays do
    local day = {
      reward = {
        type = tb[i]["Reward Type"],
        id = tb[i]["Reward ID"],
        amount = tb[i]["Reward Amount"]
      },
      state = self:getDayState(i)
    }
    table.insert(self.loginRewards, day)
  end
end

function class:getLoginRewads()
  return self.loginRewards or {}
end

function class:initGiftRewards()
  local tb = ed.getDataTable("GobackGoods")
  self.giftList = {}
  for k, v in ipairs(tb) do
    local item = {
      id = v.ID,
      price = v.Price,
      rewards = {},
      name = v["Goodsgroup Name"]
    }
    for i = 1, 4 do
      if v["Goods Amount " .. i] then
        table.insert(item.rewards, {
          type = v["Goods Type " .. i],
          amount = v["Goods Amount " .. i],
          id = v["Goods ID " .. i]
        })
      end
    end
    table.insert(self.giftList, item)
  end
  for k, v in ipairs(self.giftList) do
    v.buyTime = self.goodBuyFlags[v.id] or 0
  end
end

function class:getGiftRewads()
  table.sort(self.giftList, function(a, b)
    local abuy = a.buyTime > 0 and 1 or 0
    local bbuy = b.buyTime > 0 and 1 or 0
    if abuy == bbuy then
      return a.id < b.id
    else
      return abuy < bbuy
    end
  end)
  return self.giftList
end

function class:getTaskState(data)
  if ed.isElementInTable(data.id, self.taskLineFlags) then
    return "Got"
  elseif self.taskLine >= data.progress then
    return "CanGet"
  else
    return "UnGet"
  end
end

function class:initLineTasks()
  local tb = ed.getDataTable("GobackLineReward")
  local progress = 0
  local lineTasks = {}
  for k, v in ipairs(tb) do
    local task = {
      id = k,
      progress = v.Progress,
      reward = {
        type = v["Reward Type"],
        id = v["Reward ID"],
        amount = v["Reward Amount"]
      }
    }
    task.state = self:getTaskState(task)
    lineTasks[k] = task
  end
  self.lineTasks = lineTasks
end

function class:getLineTasks()
  return self.lineTasks
end

function class:handleOpenPanel(data)
  self:initServerData(data._goback)
  if ed.activityHints.crossDays then
    ed.activityHints.crossDays = nil
    return
  end
  if self.activityId > 0 then
    if self.scene then
      self.scene:refreshLayer()
    else
      ed.pushScene(ed.ui.GobackMainScene.create({}))
    end
  else
    self.endTime = ed.getServerTime()
    self:setActiving(false)
  end
end

function class:handleGetOnceReward(data)
  self.onceFlag = true
  FireEvent("GobackRedChange")
  ed.player:addRewards(data._rewards or {})
  FireEvent("GobackOnceRewardGot", data)
end

function class:handleGetLoginRewards(data)
  table.insert(self.lineFlags, data._index)
  self.loginRewards[data._index].state = "Got"
  ed.player:addRewards(data._rewards or {})
  ed.UITool.showRewardsFromServer(data._rewards)
  FireEvent("GobackRedChange")
  FireEvent("GobackGetLoginRewards", data._index)
end

function class:handleBuyGoods(data)
  for k, v in ipairs(self.giftList) do
    if v.id == data._goods_id then
      v.buyTime = ed.getServerTime()
    end
  end
  ed.player:subrmb(data._cost)
  ed.player:addRewards(data._rewards or {})
  ed.UITool.showRewardsFromServer(data._rewards)
  FireEvent("GobackRedChange")
  FireEvent("GobackBuyGiftSuccess", data)
end

function class:handleGetTaskRewards(data)
  table.insert(self.taskLineFlags, data._index)
  self.lineTasks[data._index].state = "Got"
  ed.player:addRewards(data._rewards or {})
  ed.UITool.showRewardsFromServer(data._rewards)
  FireEvent("GobackRedChange")
  FireEvent("GobackGetLineRewards", data._index)
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

ed.GobackManager = class.getInstance()
return class
