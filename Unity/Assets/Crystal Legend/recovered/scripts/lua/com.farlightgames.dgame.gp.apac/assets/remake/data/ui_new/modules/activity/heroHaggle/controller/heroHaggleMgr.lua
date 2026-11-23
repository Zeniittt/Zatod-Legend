local class = newclass("g")
ed.heroHaggleMgr = class
class.instance = nil
ed.heroHaggleMgr.PassID = 2
ed.heroHaggleMgr.ModuleName = "HeroHaggle"

function class.getInstance()
  if not ed.heroHaggleMgr.instance then
    ed.heroHaggleMgr.instance = ed.heroHaggleMgr.create()
  end
  return ed.heroHaggleMgr.instance
end

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
  self.season_id = 1
  self.select_hero = 0
  self.haggle_num = 0
  self.buy_hero_Id = 0
  self.reds = 0
  self.closeHandler = false
  self.initActive = false
  self.haggleConfig = {}
  self.select_hero_state = false
  self:initTaskList()
  self:InitEvents()
end

function class:initCostItem()
  local seasonId = ed.heroHaggleMgr.getInstance().season_id
  local haggleConfig = ed.getDataTable("HeroHaggle")[seasonId]
  self.costItemId = haggleConfig["Item ID"]
  local costAmount = 0
  for haggleNum = 1, 5 do
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][haggleNum]
    costAmount = costAmount + lineConfig["Require Item Amount"]
    self.haggleConfig[haggleNum] = costAmount
  end
end

local TimeScope = {}

function class:InitEvents()
  ListenTimer(Timer:Always(1), function()
    self:Update(1)
  end, TimeScope)
  ListenEvent("ActivityUpdateSuccess", function()
    self.initActive = true
    if self.delayUpdate then
      self:updateActivity()
      self.delayUpdate = false
    end
  end)
end

function class:Update()
  if nil ~= ed.heroHaggleMgr.getInstance().totalEndTime then
    local leftTime = ed.heroHaggleMgr.getInstance().totalEndTime - ed.getServerTime()
    local state = ed.heroHaggleMgr.getInstance().open == 1
    if leftTime < 0 and state then
      ed.heroHaggleMgr.getInstance().open = 0
      self:updateActivity()
    end
  end
end

function class:handleOpenPanel(msg)
  self.season_id = msg._season_id
  self.select_hero = msg._select_hero
  self.haggle_num = msg._haggle_num
  self.buy_hero_Id = msg._buy_hero
  self:initCostItem()
  self:onHeroHaggleUpdateRed()
  FireEvent("EventHeroHaggleOpenPanel")
end

function class:handleSelectHero(msg)
  self.select_hero = ed.heroHaggleNet.selectHeroId
  self.select_hero_state = 1
  FireEvent("EventHeroHaggleSelectHero")
  self:onHeroHaggleUpdateRed()
end

function class:handlerHagglePrice(msg)
  self.haggle_num = msg.haggle_num
  self:onHeroHaggleUpdateRed()
  FireEvent("EventHeroHagglePrice")
  self:updateActivity()
end

function class:onHeroHaggleUpdateRed()
  local haveItemNum = ed.player:getEquipAmount(self.costItemId)
  local targetNum = self.haggle_num + 1
  if targetNum <= #self.haggleConfig then
    if haveItemNum >= self.haggleConfig[self.haggle_num + 1] then
      self.canHaggle = 1
    else
      self.canHaggle = 0
    end
  elseif targetNum > #self.haggleConfig then
    self.canHaggle = 0
  end
  FireEvent("EventHeroHaggleUpdateRed")
end

function class:handleBuyHero(msg)
  msg._rewards = msg._rewards or {}
  if msg._rewards then
    for _, v in ipairs(msg._rewards) do
      if v._type == "hero" then
        ed.player:addHero(v._id)
        self.buy_hero_Id = v._id
        ed.ui.SummonRewardCardWindow.create({
          rewards = {
            {
              id = v._id,
              amount = v._amount,
              type = "hero"
            }
          },
          noRewards = true,
          callback = function()
          end
        }):popWindow()
      elseif v._type == "item" then
        local id = v._id
        local amount = v._amount
        local hid = ed.readhero.getMakeid(id)
        self.buy_hero_Id = v._id
        ed.ui.SummonRewardCardWindow.create({
          rewards = {
            {
              id = hid,
              amount = amount,
              type = "hero"
            }
          },
          convertIdxs = {true},
          noRewards = true
        }):popWindow()
        ed.player:addRewards({
          {
            _type = "item",
            _id = id,
            _amount = amount
          }
        })
      end
    end
  end
  FireEvent("QueryDataRsp")
  FireEvent("EventHeroHaggleBuyHero")
end

function class:updateState(msg)
  if msg then
    self.open = msg._open
    self.canHaggle = msg._can_haggle
    self.select_hero_state = msg._is_select
  end
end

function class:getTaskInfo(info)
  local item = {}
  for i = 1, 2 do
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

function class:initTaskList()
  self.heroHaggleTask = {}
  local config = ed.getDataTable("SimpleAssist")[ed.heroHaggleMgr.PassID][ed.heroHaggleMgr.ModuleName]
  local taskList = config["Task List"]
  for _, v in ipairs(taskList) do
    local taskId = v
    local taskConfig = ed.getDataTable("SimpleAssistTask")[taskId]
    local taskState = 0
    local data = {
      id = v,
      target = taskConfig["Task Target"],
      progressId = taskConfig["Task Progress ID"],
      progressType = taskConfig["Task Progress Type"],
      detail = taskConfig["Task Detail"],
      items = self:getTaskInfo(taskConfig),
      progress = 0,
      taskState = taskState
    }
    self.heroHaggleTask[data.id] = data
  end
  table.sort(self.heroHaggleTask, function(a, b)
    return a.id < b.id
  end)
end

function class:getTaskList()
  local showTask = {}
  local taskLineMap = {}
  for key, data in pairs(self.heroHaggleTask) do
    local taskConfig = ed.getDataTable("SimpleAssistTask")[key]
    local taskGroup = taskConfig["Task Group"]
    if taskGroup then
      if taskLineMap[taskGroup] then
        table.insert(taskLineMap[taskGroup], data)
      else
        taskLineMap[taskGroup] = {}
        table.insert(taskLineMap[taskGroup], data)
      end
    else
      table.insert(showTask, data)
    end
  end
  for i, v in pairs(taskLineMap) do
    table.sort(v, function(a, b)
      if a.id < b.id then
        return true
      end
      return false
    end)
  end
  for i, v in pairs(taskLineMap) do
    local addFirstTask = false
    for i, data in ipairs(v) do
      if data.taskState ~= 2 then
        addFirstTask = true
        showTask[data.id] = data
        break
      end
    end
    if not addFirstTask then
      local lastTask = v[#v]
      showTask[lastTask.id] = lastTask
    end
  end
  return showTask
end

function class:handleTaskOpenPanel(data)
  data = ed.copyProto(data)
  data = data._simple_assist
  local hour = ed.getDataTable("SimpleAssist")[ed.heroHaggleMgr.PassID].HeroHaggle["Duration Hour"]
  self.totalEndTime = data._active_time + hour * 60 * 60
  self:setdayAwardsTaskState(data._task_lists)
  FireEvent("EventUpdateHeroHaggleTask", true)
  FireEvent("EventUpdateHeroHaggleTaskNum")
  self:updateActivity()
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
    local rewards = {}
    for _, v in ipairs(data._rewards) do
      if v._type == "raid_point" then
        table.insert(rewards, {_type = "raid_point", _amount = 0})
      else
        table.insert(rewards, v)
      end
    end
    ed.player:addRewards(rewards)
    self.closeHandler = true
    ed.UITool.showRewardsFromServer(data._rewards, nil, function()
      self.closeHandler = false
    end)
    FireEvent("EventUpdateHeroHaggleTask")
    FireEvent("EventUpdateHeroHaggleTaskNum")
    self:onHeroHaggleUpdateRed()
    self:updateActivity()
  end
end

function class:updateActivity()
  ed.activityHints:updateReds({_act_id = 9999906})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
end

function class:setdayAwardsTaskState(state)
  local canUpdate = false
  for _, v in ipairs(state) do
    local key = self.heroHaggleTask[v._id]
    local progress = v._task_progress
    self.heroHaggleTask[v._id].progress = progress
    local taskState
    if v._is_rewarded == 1 then
      taskState = 2
    elseif progress >= self.heroHaggleTask[v._id].target then
      taskState = 3
    else
      taskState = 1
    end
    local old = self.heroHaggleTask[v._id].taskState
    self.heroHaggleTask[v._id].taskState = taskState
    if taskState == 2 then
      canUpdate = true
    end
    self.reds = self.reds or 0
    if old == 3 and taskState == 2 then
      self.reds = self.reds - 1
    elseif (old == 1 or old == 0) and taskState == 3 then
      self.reds = self.reds + 1
    end
  end
  if self.reds <= 0 then
    self.server_reds = false
  end
  if canUpdate then
    FireEvent("EventUpdateHeroHaggleTaskData")
  end
end

function class:doRechargeByHeroHaggle()
  local seasonId = self:getCurrentSeasonId()
  local haggleNum = self:getHaggleNum() + 1
  if ed.heroHaggleMgr.getInstance().select_hero == 0 then
    return
  end
  local price, rechargeId
  if 5 < haggleNum then
    haggleNum = 5
    local lineCfg = ed.getDataTable("HeroHaggleLine")[seasonId][haggleNum]
    price = lineCfg["Price After"]
  else
    local lineCfg = ed.getDataTable("HeroHaggleLine")[seasonId][haggleNum]
    price = lineCfg["Price Before"]
  end
  local rt = ed.getDataTable("Recharge")
  for id, row in pairs(rt) do
    if type(id) == "number" then
      local type = row.Type
      if type == "GiftTicket" and row.Cost == price then
        rechargeId = row.ID
      end
    end
  end
  if not rechargeId then
    error("unsupported gift ticket price: " .. price)
    return
  end
  local v = ed.getDataTable(resource_config.rechargecsv or "Recharge")[rechargeId]
  local cost
  if resource_config.recharge_use_locale_cost then
    local localeData = ed.localepurchase.getLocaleProduct(v.ID)
    cost = localeData.cost
  end
  local rechargeItem = {
    id = v.ID,
    pid = v[ed.getIAPTitle()],
    title = v["Display Name"],
    type = v.Type,
    order = v.Order,
    CNYCost = v.Cost,
    USDCost = v["Cost USD"],
    icon = v.Icon,
    limit = v.Limit,
    itemId = v["Item ID"],
    giftType = "hero_haggle_buy_hero",
    hero_id = self.select_hero,
    canUseTicket = true
  }
  ed.RechargeManager:doRecharge(rechargeItem)
end

function class:setTaskRed(reds)
  self.server_reds = 0 < reds
  if self.initActive then
    self:updateActivity()
    FireEvent("EventUpdateHeroHaggleTaskMsg")
  else
    self.delayUpdate = true
  end
end

function class:getEndTime()
  return ed.heroHaggleMgr.getInstance().totalEndTime
end

function class:getCostItem()
  return ed.heroHaggleMgr.getInstance().costItemId
end

function class:getCurrentSeasonId()
  return ed.heroHaggleMgr.getInstance().season_id
end

function class:getSelectHero()
  return ed.heroHaggleMgr.getInstance().select_hero
end

function class:getHaggleNum()
  return ed.heroHaggleMgr.getInstance().haggle_num
end

function class:getHaggleBuyHeroId()
  return ed.heroHaggleMgr.getInstance().buy_hero_Id
end

function class:getState()
  return ed.heroHaggleMgr.getInstance().open == 1
end

function class:getTaskState()
  local reds = ed.heroHaggleMgr.getInstance().reds
  return 0 < reds
end

function class:getRed()
  local select_hero_red = ed.heroHaggleMgr.getInstance().select_hero_state == 0
  local server_reds = ed.heroHaggleMgr.getInstance().server_reds
  local serverRed = ed.heroHaggleMgr.getInstance().canHaggle == 1
  local taskRed = ed.heroHaggleMgr.getInstance():getTaskState()
  local openState = ed.heroHaggleMgr.getInstance().open == 1
  local buy_hero = ed.heroHaggleMgr.getInstance().buy_hero_Id
  if openState then
    if buy_hero ~= 0 then
      return taskRed or server_reds
    else
      return serverRed or taskRed or server_reds or select_hero_red
    end
  else
    return false
  end
end
