local activityData = {}
ed.activityData = activityData
activityData.pageConfig = {
  hero_gift = "activityHeroPage",
  days_login = "activityloginPage",
  first_recharge = "activityRechargePage",
  grow_plan = {
    init = "ActivityGrowPlanPage",
    wukong = "activityChooseWukongPage"
  },
  exchange = "ActivityExchangePage",
  ptr_rebate = "activityPtrRewardPage",
  stage_extra_drop = "activitystageExtraDrop",
  fancy_abyss = "fancyAbyssPage",
  lottery = "activityLotteryPage",
  jugg_exchange = "ActivityJuggPage",
  wechatofficial_jump = "activityWechatPage",
  pvp_reward = "ActivityArenaTaskPage",
  gift4_jump = "activityGift4JumpPage",
  cndota2025 = "cnDota2025Page",
  champion2025tb = "champion2025tbPage",
  champion2025xg = "champion2025xgPage",
  choose_reward = "activityChooseHeroPage",
  realarena_reward = "ActivityRealArenaTaskPage",
  legend_real_arena = "ActivityLegendRealArenaPage",
  hero_recycle = "activityHeroRecyclePage",
  specialactivity_show = "activityKingsPvpShow",
  three_kingdom = "threeKingdomsSkinPage",
  guild_contest = "activityArenaCompetitionPage",
  all_star = "activityAllStarPage",
  newyear_marketing = "activityMarketingPage",
  dreamland_new_year = "activityBbgsPage",
  smithing_plan = "smithingPlanPage",
  all_server_assist = "activityBanMagnusPage",
  other_activity_fundPass = "activityfundPassPage",
  other_activity_skin_sale = "skinSalePassPage",
  other_activity_physical = "activityphysicalPage",
  soul_exchange = "exchangeSoulPage",
  other_activity_retrievalReward = "activityRetrievalRewardPage",
  other_activity_petPass = "activityPetPassPage",
  other_activity_AllStar = "activityAllStarRankPage",
  other_temperingPassPage = "temperingPassPage",
  other_runCricketPage = "runCricketPage",
  hero_haggle = "heroHagglePage",
  other_peakDashPassPage = "peakDashPlanPage",
  other_riseStarPage = "riseStarPage"
}

function activityData:getActUIName(data)
  local config = self.pageConfig[data._type]
  if type(config) == "table" then
    if data._extend._tag then
      return config[data._extend._tag] or config.init
    else
      return config.init
    end
  end
  return config
end

activityData.getRedFuns = {
  lottery = function(self, actId)
    return function()
      local data = self:getActivityInfoToKey(actId)
      local lotteryMaximumUidKey = ed.getRoleKey("lottery_" .. data._id)
      if ed.storage.getBool(lotteryMaximumUidKey) then
        return 0
      end
      if ed.player.equip_qunty[ed.taskData.lotteryInfo[2]] and 0 < ed.player.equip_qunty[ed.taskData.lotteryInfo[2]] then
        return 1
      end
      local lotteryUidKey = ed.getRoleKey("lottery")
      if ed.storage.getBool(lotteryUidKey) then
        return 0
      end
      return 1
    end
  end,
  jugg_exchange = function(self, actId)
    return function()
      local data = self:getActivityInfoToKey(actId)
      local taskList = data._tasks
      for index, task in ipairs(taskList or {}) do
        if task._cond_type == "item_group_exchange" then
          local itemGroupCfg = ed.getDataTable("ActivityItemGroup")[task._cond_target]
          local hasAllItem = true
          local inTable = false
          for index, itemCfg in pairs(itemGroupCfg or {}) do
            inTable = true
            local needItemAmount = itemCfg["Item Amount"]
            local curAmount = ed.player:getEquipAmount(itemCfg["Item ID"])
            if needItemAmount > curAmount then
              hasAllItem = false
              break
            end
          end
          if hasAllItem and inTable then
            return 1
          end
        end
      end
      return 0
    end
  end,
  all_server_assist = function(self, actId)
    return function()
      local data = self:getActivityInfoToKey(actId)
      if data._end_time <= ed.getServerTime() then
        return 0
      end
      local taskList = data._tasks
      local haveNotReached = false
      for index, task in ipairs(taskList or {}) do
        local reached = task._progress >= task._cond_target
        local gotReward = task._cur_reward_times >= task._max_reward_times
        if reached and not gotReward then
          return 1
        end
        if task._cond_type == "assist_progress" and not reached then
          haveNotReached = true
        end
      end
      local banItemId = ed.getDataTable("Activity")[data._cfg_id]["Extra AN"][1]
      if 0 < ed.player:getEquipAmount(banItemId) and haveNotReached then
        return 1
      end
      return 0
    end
  end,
  dragon_boat = function(self, actId)
    return function()
      local data = self:getActivityInfoToKey(actId)
      local taskList = data._tasks
      local taskRed = 0
      for i, v in ipairs(taskList or {}) do
        local tsk = v or {}
        local isCompleted = tsk._progress >= tsk._cond_target
        local isFinished = tsk._cur_reward_times and tsk._cur_reward_times >= tsk._max_reward_times
        if not isFinished and isCompleted then
          taskRed = 1
          break
        end
      end
      ed.dragonBoatMgr.getInstance():updatePassTaskRedPoint(taskRed)
      return taskRed
    end
  end
}
activityData.isShowFun = {
  fancy_abyss = function(self, v)
    return function()
      local nt = ed.getServerTime()
      local isShow = v._start_time == -1 or v._end_time == -1 or nt >= v._start_time and nt <= v._expire_time and v._is_show == 1
      local levelLimit = ed.player:getLevel() >= 60
      return levelLimit and isShow
    end
  end
}

function activityData.create()
  local object = {}
  setmetatable(object, {__index = activityData})
  object:createConfig()
  return object
end

function activityData:createConfig()
  if not self.activityConfig then
    self.activityConfig = {}
    local table = ed.getDataTable("Activity")
    for i, v in pairs(table) do
      self.activityConfig[v["Activity Id"]] = v
    end
  end
end

local function getEndTime(time)
  time = time - ed.getServerTime()
  if 0 < time then
    local h, m, s = ed.second2hms(time)
    local d = math.floor(h / 24)
    local h = h % 24
    return T("%d\229\164\169%d\230\151\182", d, h)
  else
    return T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159")
  end
end

activityData.getEndTime = getEndTime

function activityData:initActivityData(activityInfo, activityKey, ptrShow, othActConfig)
  self.activityInfo = ed.copyProto(activityInfo or {})
  self.activityKey = ed.copyProto(activityKey or {})
  self.othActConfig = ed.copyProto(othActConfig or {})
  self.ptrShow = ptrShow
end

function activityData:setActivityData(datas)
  local datas = ed.copyProto(datas or {})
  self.activityInfo = self.activityInfo or {}
  self.activityKey = self.activityKey or {}
  for i, v in ipairs(datas) do
    if self.activityKey[v._id] then
      self.activityInfo[self.activityKey[v._id]] = v
      self.activityInfo[self.activityKey[v._id]].endTimeStr = getEndTime(v._end_time)
    else
      v.endTimeStr = getEndTime(v._end_time)
      table.insert(self.activityInfo, v)
      self.activityKey[v._id] = #self.activityInfo
    end
    if self.getRedFuns[v._type] then
      v.getRed = self.getRedFuns[v._type](self, v._id)
    end
    if v._type == "hero_gift" and v._extend and v._extend._tag == "v2" then
      self.ptrShow = true
    end
    local cfgId = v._cfg_id
    local config = self.activityConfig[cfgId]
    if config and config["Activity Group"] == "system_settings" then
      local buffMgr = ed.activityBuffMgr.getInstance()
      local data = {
        buffId = cfgId,
        endTime = v._end_time
      }
      buffMgr:addBuff(cfgId, data)
    end
    if config and config["Activity Type"] == "daily_pass" then
      ed.taskData.showPassId = cfgId
    end
    if config and config["Activity Type"] == "lottery" then
      ed.taskData.lotteryInfo = config["Extra AN"]
    end
  end
  local newTabs = {}
  local othActConfig = self.othActConfig or {}
  for i, v in pairs(self.activityInfo) do
    if not othActConfig[v._id] then
      table.insert(newTabs, v)
      self.activityKey[v._id] = #newTabs
    end
  end
  self.othActConfig = {}
  for i, v in ipairs(ed.othActConfig().config) do
    table.insert(newTabs, v)
    self.activityKey[v._id] = #newTabs
    self.othActConfig[v._id] = true
  end
  self.activityInfo = newTabs
end

function activityData:getActivityInfoToKey(act_id)
  return self.activityKey[act_id] and self.activityInfo[self.activityKey[act_id]] or {}
end

function activityData:getActivityIdToIndex(act_id)
  for i, v in ipairs(self.newShowActivity) do
    if v._cfg_id == act_id then
      return i
    end
  end
end

function activityData:getActivityTypeToIndex(act_type)
  for i, v in ipairs(self.newShowActivity) do
    local config = self.activityConfig[v._cfg_id] or {}
    if config["Activity Type"] == act_type then
      return i
    end
  end
  return 1
end

function activityData:getNewActivityData()
  self.newShowActivity = {}
  local nt = ed.getServerTime()
  for i, v in pairs(self.activityInfo or {}) do
    local config = self.activityConfig[v._cfg_id] or {}
    v.openType = config["Open Type"] or ""
    local isShow
    if type(v._is_show) == "function" then
      isShow = v._is_show()
    elseif self.isShowFun[v._type] then
      isShow = self.isShowFun[v._type](self, v)()
    else
      isShow = v._start_time == -1 or v._end_time == -1 or nt >= v._start_time and nt <= v._expire_time and v._is_show == 1
    end
    if isShow then
      local head = v._head or {}
      head._title = head._title or config["Activity Name"]
      head._desc = head._desc or config.Rules
      head._rules = head._rules or config.Rules
      head._icon = head._icon or config["Title Picture"]
      head._banner = head._banner or config.Banner
      v._head = head
      table.insert(self.newShowActivity, v)
    end
  end
  table.sort(self.newShowActivity, function(a, b)
    return a._priority > b._priority
  end)
  return self.newShowActivity
end

function activityData:updateActivityData(data)
  for i, v in pairs(self.activityInfo) do
    if data._act_id == v._id then
      if v.getDataFun then
        v._tasks = v.getDataFun()
        break
      end
      for t, a in ipairs(v._tasks) do
        if data._task._id == a._id then
          v._tasks[t] = data._task
          break
        end
      end
      break
    end
  end
end

function activityData:getActivityInfoByType(type)
  local activityList = {}
  for i, activityData in pairs(self.activityInfo or {}) do
    if activityData._type == type then
      table.insert(activityList, activityData)
    end
  end
  return activityList
end

function activityData:getActivityInfoByTypeList(typeList)
  local activityList = {}
  for i, activityData in pairs(self.activityInfo or {}) do
    if ed.isElementInTable(activityData._type, typeList) then
      table.insert(activityList, activityData)
    end
  end
  return activityList
end

function activityData:getActivityIsOpenById(actId)
  for i, v in pairs(self.activityInfo) do
    if v._cfg_id == actId then
      local nt = ed.getServerTime()
      if v._start_time == -1 or v._end_time == -1 or nt >= v._start_time and nt <= v._end_time and v._is_show == 1 then
        return true
      else
        return false
      end
    end
  end
  return false
end

function activityData:getTimelySummonShow()
  local activityList = self:getActivityInfoByType("timely_summon_show")
  local summonHeroConfig = {}
  for i, activityData in ipairs(activityList or {}) do
    local serverTime = ed.getServerTime()
    local cfgId = activityData._cfg_id
    local config = self.activityConfig[cfgId]
    local taskData = activityData._tasks[1]
    if config and activityData._end_time ~= -1 and serverTime < activityData._end_time then
      local extraAN = config["Extra AN"]
      local extraStr = config["Extra Str"]
      local clickTimes = extraAN[1]
      local heroIdList = {}
      for index = 2, #extraAN do
        table.insert(heroIdList, extraAN[index])
      end
      table.insert(summonHeroConfig, {
        actiId = activityData._id,
        taskData = taskData,
        clickTimes = clickTimes,
        heroIdList = heroIdList,
        talkMsgList = extraStr
      })
    end
  end
  return summonHeroConfig
end

function activityData:getStageExtraDropItem()
  local activityList = self:getActivityInfoByType("stage_extra_drop")
  local specailLoopTb = ed.getDataTable("SpecialLoot")
  local extraLootIdList = {}
  for i, activityData in ipairs(activityList or {}) do
    local serverTime = ed.getServerTime()
    local cfgId = activityData._cfg_id
    local config = ed.getDataTable("Activity")[cfgId]
    if activityData._end_time ~= -1 and serverTime < activityData._end_time then
      local specailLootIdList = config["Extra AN"]
      for _, specailLootId in pairs(specailLootIdList or {}) do
        local lootCfg = specailLoopTb[specailLootId]
        if lootCfg then
          local itemId = lootCfg["Item Id"]
          table.insert(extraLootIdList, itemId)
        end
      end
    end
  end
  return extraLootIdList
end

function activityData:getLotteryLineReward(Progress, lineReward)
  local LotteryID = ed.taskData.lotteryInfo[1]
  local tables = ed.getDataTable("LotteryLineReward")
  local tabs = {}
  for i, v in pairs(tables[LotteryID]) do
    table.insert(tabs, {
      state = ed.isElementInTable(v.Progress, lineReward) and 3 or Progress >= v.Progress and 2 or 1,
      progress = v.Progress,
      index = 0,
      item = {
        id = v["Reward ID"],
        amount = v["Reward Amount"],
        type = v["Reward Type"]
      }
    })
  end
  table.sort(tabs, function(a, b)
    return a.progress < b.progress
  end)
  for i, v in ipairs(tabs) do
    v.index = i
  end
  return tabs
end

function activityData:getDungeonActivityInfo()
  local chapterGroup, levelGroup, dropsId, startTime, endTime, rules
  local activityList = self:getActivityInfoByType("awake_pve_dungeon")
  for _, activityData in ipairs(activityList or {}) do
    local cfgId = activityData._cfg_id
    local activityConfig = ed.getDataTable("Activity")[cfgId]
    local extraAN = activityConfig["Extra AN"]
    chapterGroup = extraAN[1]
    levelGroup = extraAN[2]
    dropsId = extraAN[3]
    startTime = activityData._start_time
    endTime = activityData._end_time
    rules = activityConfig.Rules
    break
  end
  return {
    chapterGroup = chapterGroup,
    levelGroup = levelGroup,
    dropsId = dropsId,
    startTime = startTime,
    endTime = endTime,
    rules = rules
  }
end

function activityData:getPvpActivityInfo()
  local activityList = self:getActivityInfoByTypeList({
    "arena_phantom",
    "ladder_buff"
  })
  for _, activityData in ipairs(activityList or {}) do
    local cfgId = activityData._cfg_id
    local activityConfig = ed.getDataTable("Activity")[cfgId]
    local extraStr = activityConfig["Extra Str"]
    local extraAn = activityConfig["Extra AN"]
    local startTime = activityData._start_time
    local endTime = activityData._end_time
    local serverTime = ed.getServerTime()
    if startTime < serverTime and endTime > serverTime then
      return {
        startTime = activityData._start_time,
        endTime = activityData._end_time,
        activityType = activityData._type,
        activityTag = activityConfig["Activity Tag"],
        pvpActivityId = extraAn[1],
        activityIcon = extraStr[1],
        bubbleText = extraStr[2],
        pvpActivityBuffBg = extraStr[3],
        battlePrepareHeroMask = extraStr[4],
        rules = activityConfig.Rules
      }
    end
  end
end

function activityData:getPvpActivityShow()
  local pvpActivityInfo = ed.activityHints.data:getPvpActivityInfo()
  if not pvpActivityInfo then
    return false
  end
  local startTime = pvpActivityInfo.startTime
  local endTime = pvpActivityInfo.endTime
  return startTime < ed.getServerTime() and endTime > ed.getServerTime()
end

function activityData:getTimeCorridorActivityInfo()
  local activityList = self:getActivityInfoByType("time_corridor")
  if not activityList then
    return nil
  end
  for _, activityData in ipairs(activityList or {}) do
    local startTime = activityData._start_time
    local endTime = activityData._end_time
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and endTime >= serverTime then
      return activityData
    end
  end
  return nil
end

function activityData:getDreamBuffActivityInfo()
  local activityList = self:getActivityInfoByType("dreamland_new_year")
  if not activityList then
    return nil
  end
  for _, activityData in ipairs(activityList or {}) do
    local startTime = activityData._start_time
    local endTime = activityData._end_time
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and endTime >= serverTime then
      return activityData
    end
  end
  return nil
end

function activityData:getDreamStageBuffId()
  local info = self:getDreamBuffActivityInfo()
  if info then
    local time = ed.getServerTime()
    local day = math.ceil((time - info._start_time) / 86400)
    local cfgId = info._cfg_id
    local activityConfig = ed.getDataTable("Activity")[cfgId]
    local extraAn = activityConfig["Extra AN"]
    local buffid = extraAn[day] or 71
    return buffid
  end
end

function activityData:getRealArenaAthleticsActInfo()
  local activityList = self:getActivityInfoByType("legend_real_arena")
  if not activityList then
    return nil
  end
  for _, actData in ipairs(activityList or {}) do
    local startTime = actData._start_time
    local endTime = actData._end_time
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and endTime >= serverTime then
      return actData
    end
  end
  return nil
end

function activityData:getDragonBoatActivityInfo()
  local activityList = self:getActivityInfoByType("dragon_boat")
  if not activityList then
    return nil
  end
  for _, activityData in ipairs(activityList or {}) do
    local startTime = activityData._start_time
    local endTime = activityData._expire_time
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and endTime >= serverTime then
      return activityData
    end
  end
  return nil
end

function activityData:getPvpLegendEquipActivityInfo()
  local activityList = self:getActivityInfoByType("arena_legendequip")
  if not activityList then
    return nil
  end
  for _, info in ipairs(activityList or {}) do
    local startTime = info._start_time
    local endTime = info._expire_time
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and endTime >= serverTime then
      return {
        startTime = info._start_time,
        endTime = info._end_time,
        legendEquipId = ed.getDataTable("Activity")[info._cfg_id]["Extra AN"][1]
      }
    end
  end
  return nil
end
