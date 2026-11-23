local class = {}
class.__index = class
ed.moonFestivalMgr = class
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
  self:init()
  return self
end

function class:init()
  self.normalBgSpeed = 80
  self.bgSpeed = 80
  self.rewardTbl = ed.getDataTable("BubbyRaceReward")
  self.rewardsCnt = 0
  for _, v in pairs(self.rewardTbl) do
    self.rewardsCnt = self.rewardsCnt + 1
  end
  self:initRedPoint()
  self.scope = {}
  self.receivedRewards = {
    1,
    2,
    3,
    4
  }
  self.nextStageProgress = 750
  do return end
  ListenEvent("ActivityUpdateSuccess", function()
    local activityInfo = ed.activityHints.data:getmoonFestivalActivityInfo()
    if activityInfo and activityInfo._id then
      self.showActivity = true
      self.activityId = activityInfo._cfg_id
      self.endTime = activityInfo._end_time
      self.expireTime = activityInfo._expire_time
      self.startTime = activityInfo._start_time
      self.inRace = ed.getServerTime() <= self.endTime
      self.activityInfo = activityInfo
      self.passId = ed.lookupDataTable("Activity", "Extra AN", self.activityId)[1]
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.DRAGON_BOAT)
      FireEvent("RefreshRightTopButtons")
      FireEvent("RefreshmoonFestivalActivityTask")
    elseif self.showActivity then
      self.showActivity = false
      FireEvent("RefreshRightTopButtons")
    end
  end, self.scope)
  ListenEvent("UpdatePassRewardTips", function(info)
    local passId = info.passId
    if passId == self.passId then
      self:updatePassRewardRedPoint()
    end
  end, self.scope)
end

function class:initRedPoint()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("moon_festival_entry", self, {
    handle = function(value)
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.MOON_FESTIVAL)
    end
  })
end

function class:isInRace()
  if self.endTime then
    return ed.getServerTime() <= self.endTime and ed.getServerTime() >= self.startTime
  end
  return false
end

function class:IsExpire()
  if self.expireTime then
    return ed.getServerTime() > self.expireTime or ed.getServerTime() < self.startTime
  end
  return true
end

function class:updatePassRewardRedPoint()
  self.redPointMgr:setNodeValue("dragon_boat_pass_reward", ed.passDataMgr:getPassRewardCount(self.passId) > 0)
end

function class:updatePassTaskRedPoint(red)
  self.redPointMgr:setNodeValue("dragon_boat_pass_task", red)
end

function class:updateRewardRedPoint()
  local completeReward = false
  for ind, reward in ipairs(self.rewardTbl) do
    local feet = reward["Require Feet"]
    local reach = feet <= self.nextStageProgress
    if reach and not ed.isElementInTable(ind, self.receivedRewards) then
      completeReward = true
      break
    end
  end
  self.redPointMgr:setNodeValue("dragon_boat_reward_entry", completeReward)
end

function class:handleNotify(data)
  local start = data._start
  local give_num = data._give_num
  local is_reward = data._is_reward
  self.giveNum = give_num
  if (ed.player:getLevel() or 0) >= 10 then
    self.redPointMgr:setNodeValue("moon_festival_start", start == 1 and 0 or 1)
  end
  self.redPointMgr:setNodeValue("moon_festival_reward_entry", is_reward)
  FireEvent("moonFestivalNotify")
end

function class:handleOpenPanel(data)
  self.raceInfo = nil
  self.frontInfo = nil
  self.behindInfo = nil
  self.lastFrontInfo = nil
  self.lastBehindInfo = nil
  self.redPointMgr:setNodeValue("dragon_boat_start", 0)
  self:updatePassRewardRedPoint()
  self.season = data._cur_season
  self.zongziItemId = ed.lookupDataTable("moonFestival", "Item ID", self.season)
  self.zongziAddFeet = ed.lookupDataTable("moonFestival", "Add Feet", self.season)
  self.activityId = ed.lookupDataTable("moonFestival", "Activity ID", self.season)
  self.passId = ed.lookupDataTable("Activity", "Extra AN", self.activityId)[1]
  self.start = data._start == 1
  if self.start then
    self.skin = data._skin
    self.raceInfo = data._race._self
    self.frontInfo = data._race._front or nil
    self.behindInfo = data._race._behind or nil
    self.starRank = self.raceInfo._rank
  else
    self.bgSpeed = 0
  end
  self.topRank = data._rank_list
  if self.starRank and self.starRank > 5 then
    self.openMovie = true
  else
    self.topRank = nil
    self.openMovie = false
  end
  self.receivedRewards = data._period_rewards or {}
  self:refreshRewardInfo()
  ed.UITool.openView("moonFestivalMainScene")
  self:showNoticeQueue("ppenPanel")
end

function class:handleStart(data)
  self.start = true
  self.allRaceInfo = data._race
  self.raceInfo = data._race._self
  self.frontInfo = data._race._front or nil
  self.behindInfo = data._race._behind or nil
  self.skin = self.raceInfo._skin
  self.starRank = self.raceInfo._rank
  self.bgSpeed = self.normalBgSpeed
  self.openMovie = false
  self.topRank = nil
  FireEvent("moonFestivalSetRegisterTime")
  FireEvent("moonFestivalRefreshBoat")
end

function class:handleUpgradeSkin(data)
  self.skin = data._skin
  local rewards = data._rewards or {}
  if 0 < #rewards then
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(rewards, nil, function()
      FireEvent("moonFestivalUpgrade", data._skin)
    end)
  else
    FireEvent("moonFestivalUpgrade", data._skin)
  end
end

function class:handleUse(data, useCnt)
  self.giveNum = self.giveNum + (useCnt or 0)
  self:refreshRaceData(data)
  self:refreshRewardInfo()
  FireEvent("moonFestivalUseZongziSuccess")
  FireEvent("moonFestivalSetRegisterTime")
  useCnt = useCnt or 0
  local time = 50 <= useCnt and 4 or 20 <= useCnt and 3 or 2
  FireEvent("moonFestivalRefreshBoat", time)
end

function class:handleRace(data)
  self:refreshRaceData(data)
  self:refreshRewardInfo()
  FireEvent("moonFestivalSetRegisterTime")
  FireEvent("moonFestivalRefreshBoat")
end

function class:handleGetReward(data)
  self.receivedRewards = data._period_awards or {}
  ed.UITool.showRewardsFromServer(data._rewards)
  ed.player:addRewards(data._rewards)
  self:updateRewardRedPoint()
  FireEvent("moonFestivalRefreshRewardList")
end

function class:handleGive(data)
  if ed.moonFestivalNet.getInstance().isGiveSelf then
    self.giveNum = self.giveNum + ed.moonFestivalNet.getInstance().giveSelfCnt
  end
  FireEvent("moonFestivalGiveReply", data)
end

function class:handleGiveRecord(data)
  ed.UITool.openView("moonFestivalGiveRecordPop", data)
end

function class:handleQueryGiveRecordRank(data)
  FireEvent("moonFestivalQueryGiveRecordRankReply", data._rank_list or {})
end

function class:handleQuerySkinEffect(data)
  FireEvent("moonFestivalQuerySkinEffect", data)
end

function class:handleQueryRank(data)
  FireEvent("moonFestivalQueryRankReply", data)
end

function class:handleQueryGiveStatus(data)
  FireEvent("moonFestivalQueryGiveStatus", data)
end

function class:refreshRewardInfo()
  local newProgress = self.start and self.raceInfo._feet or 0
  if not self.nextStageProgress or newProgress >= self.nextStageTotal and self.nextStageProgress < self.nextStageTotal then
    self.nextStageProgress = newProgress
    self.nextStageTotal = 0
    local noReach = false
    for ind, reward in ipairs(self.rewardTbl) do
      local target = reward["Require Feet"]
      if target <= self.nextStageProgress then
        self.nextStageTotal = target
      elseif not noReach then
        noReach = true
        self.nextStageTotal = target
      end
    end
    FireEvent("moonFestivalRefreshRewardStage")
  elseif newProgress ~= self.nextStageProgress then
    self.nextStageProgress = newProgress
    FireEvent("moonFestivalRefreshRewardStage")
  end
  self:updateRewardRedPoint()
end

function class.getBoatSpeed(skin)
  return ed.lookupDataTable("moonFestivalSkin", "Speed", skin) or 0
end

function class:setBGSpeed(speed)
  self.bgSpeed = speed
end

function class:resetBGSpeed()
  self.bgSpeed = self.normalBgSpeed
end

function class:sendRace()
  local frontId = self.frontInfo and self.frontInfo._user_summary._role_id or nil
  local behindId = self.behindInfo and self.behindInfo._user_summary._role_id or nil
  ed.moonFestivalNet.getInstance():sendRace(frontId, behindId)
end

function class:refreshRaceData(data)
  self.lastFrontInfo = data._front
  self.lastBehindInfo = data._behind
  self.allRaceInfo = data._new_race
  self.raceInfo = data._new_race._self
  self.frontInfo = data._new_race._front or nil
  self.behindInfo = data._new_race._behind or nil
  self.starRank = self.raceInfo._rank
  self:showNoticeQueue("refresh")
end

function class:doRechargeBoatUpgrade(priceType, price, skin)
  local rechargeId
  if priceType == "Diamond" then
    local point = ed.player:getPoint("diamond")
    if price > point then
      ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
      return
    end
    ed.showConfirmDialog({
      text = T("\231\161\174\229\174\154\230\182\136\232\128\151%s\233\146\187\231\159\179\229\141\135\231\186\167\233\190\153\232\136\159\239\188\159", price),
      rightHandler = function()
        ed.moonFestivalNet.getInstance():sendUpgradeSkin(skin)
      end
    })
  else
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
      giftType = "dragon_boat_upgrade",
      skin = skin,
      canUseTicket = true
    }
    ed.RechargeManager:doRecharge(rechargeItem)
  end
end

function class:getActivityTask()
  local task = self.activityInfo._tasks or {}
  for i, v in ipairs(task) do
    local taskState = 0
    local isCompleted = v._progress >= v._cond_target
    local isFinished = v._cur_reward_times and v._cur_reward_times >= v._max_reward_times
    if isFinished then
      taskState = 2
    elseif isCompleted then
      taskState = 1
    end
    v.taskState = taskState
  end
  table.sort(task, function(a, b)
    local sortType = {
      [0] = 2,
      [1] = 3,
      [2] = 1
    }
    if sortType[a.taskState] == sortType[b.taskState] then
      return a._id < b._id
    else
      return sortType[a.taskState] > sortType[b.taskState]
    end
  end)
  for i, v in ipairs(task) do
    if v._cond_type == "act_item_expire" then
      table.remove(task, i)
      break
    end
  end
  return task
end

function class:getActivityCfg()
  local cfgId = self.activityInfo._cfg_id
  return ed.getDataTable("Activity")[cfgId]
end

function class:showNoticeQueue(showType, prams)
  if showType == "ppenPanel" then
    if self.raceInfo then
      local txt = ""
      if self.raceInfo._forward_feet and self.raceInfo._forward_feet > 0 then
        txt = T("\231\166\187\231\186\191\230\156\159\233\151\180\239\188\140\232\135\170\231\132\182\229\137\141\232\161\140 %d \229\176\186 ", self.raceInfo._forward_feet)
      end
      local names, idx = "", #(self.raceInfo._give_user or {})
      for i, v in ipairs(self.raceInfo._give_user or {}) do
        names = names .. T(" %s ", v._name)
      end
      if 3 <= idx then
        txt = txt .. T("\230\156\159\233\151\180\239\188\140%s \231\173\137\229\133\177\232\181\160\231\145\158\231\178\189\239\188\140\229\144\136\232\174\161\229\138\169\229\138\155 %d \229\176\186", names, self.raceInfo._give_num)
      elseif 0 < idx then
        txt = txt .. T("\230\156\159\233\151\180\239\188\140%s \229\133\177\232\181\160\231\145\158\231\178\189\239\188\140\229\144\136\232\174\161\229\138\169\229\138\155 %d \229\176\186", names, self.raceInfo._give_num)
      end
      if txt ~= "" then
        FireEvent("moonFestivalNoticeQueue", txt)
      end
    end
  elseif showType == "refresh" then
    local txt = ""
    for i, v in ipairs(self.raceInfo._give_user or {}) do
      txt = txt .. T(" %s \232\181\160\233\128\129\231\145\158\231\178\189\239\188\140\229\138\169\228\189\160\229\137\141\232\161\140 %d \229\176\186 ", v._name, v._give_num)
    end
    if txt ~= "" then
      FireEvent("moonFestivalNoticeQueue", txt)
    end
  elseif showType == "zongziSuccess" then
    FireEvent("moonFestivalNoticeQueue", T("\228\189\191\231\148\168\231\145\158\231\178\189\233\129\147\229\133\183\239\188\140\229\137\141\232\161\140 %d \229\176\186\239\188\129", prams or "nil"))
  end
end
