local ahs = {}
ahs.Hints = {}
ahs.activityData = nil
ahs.openActId = nil
ahs.openUpdate = false
ahs.updata = {
  h = 5,
  m = 0,
  s = 0
}
ahs.reds = {
  [9999901] = 0,
  [9999902] = 0,
  [9999903] = 0
}
local ActivityRefreshTimerScope = {}

function ahs:addRefreshTime()
  local function doRefresh()
    self.network:activityPull()
    
    self.crossDays = true
    ed.GobackNetwork:sendOpenPanel()
    FireEvent("activityCrossDays")
  end
  
  if ed.useOldActivityRefresh then
    local function getTodayTime()
      local refTime = ed.getTimeByTodayHMSWithServer(ahs.updata)
      
      return refTime < ed.getServerTime() and refTime + 86400 or refTime
    end
    
    self.updataTime = getTodayTime()
    ListenTimer(Timer:Always(2), function()
      if ed.getServerTime() > self.updataTime then
        self.updataTime = ed.clamp(getTodayTime(), self.updataTime + 3600, self.updataTime + 86400)
        doRefresh()
      end
    end)
  else
    CloseScope(ActivityRefreshTimerScope)
    ListenEvent("FiveAmRefresh", function()
      doRefresh()
    end, ActivityRefreshTimerScope)
  end
end

function ahs:activityHint(num)
  if num and 0 < num and self.activityData then
    self.network:activityPull()
  end
end

function ahs:activityReward(ids)
  self.openUpdate = false
  if ids and 0 < #ids and self.activityData then
    for _, cfgId in ipairs(ids) do
      local data = ed.getDataTable("Activity")[cfgId]
      if data.Show then
        self.openUpdate = true
      elseif data["Activity Type"] == "dragon_boat" then
        ed.dragonBoatMgr.getInstance():updatePassTaskRedPoint(1)
      end
    end
  end
  local ButtonType = ed.ui.configs.mainButton.ButtonType
  FireEvent("MainRedTagChange", ButtonType.ACTIVITY)
end

function ahs:activityNotify(num)
  if num and type(num) == "table" then
    num = #num
  end
  if num and 0 < num and self.activityData then
    self.network:activityPull()
  end
end

function ahs:createHints(data)
  for i, v in ipairs(data or {}) do
    self.Hints[v._act_id] = {
      time = v._last_resolve_time,
      red = false
    }
  end
end

function ahs.addHints(data)
  ahs.Hints = ahs.Hints or {}
end

function ahs:activityHintReply(data)
  if data._pull then
    self.Hints = self.Hints or {}
    for i, v in ipairs(data._pull._records or {}) do
      self.Hints[v._act_id] = {
        time = v._last_resolve_time,
        red = false
      }
    end
  elseif data._resolve and data._resolve._result == "success" then
    self.Hints[ed.ActivityNetwork.HintId] = {
      time = ed.getServerTime(),
      red = false
    }
    ed.activityHints:updateReds({
      _act_id = ed.ActivityNetwork.HintId
    })
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
  end
end

function ahs.create()
  local self = {}
  setmetatable(self, {__index = ahs})
  self.data = ed.activityData.create()
  self.network = ed.ActivityNetwork.create()
  ListenEvent("mainSceneEnter", function()
    if not self.activityData then
      self.network:activityPull()
      self:addRefreshTime()
      return
    end
    if ahs.openActId then
      ahs.openActId = nil
    end
    local info = ed.player:getDailyVitalityRed()
    local num = (info.lunchFree or info.dinnerFree) and 1 or 0
    if num ~= self.reds[9999902] then
      self.reds[9999902] = num
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
      FireEvent("update_activity_reds", self.reds)
    end
  end)
  ListenEvent("scope_activity_reply", function(infos)
    local info = ed.copyProto(infos)
    if info._pull then
      self.openUpdate = false
      local data = info._pull._activity_list or {}
      self.data:setActivityData(data)
      self:createReds()
      local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
      FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
    elseif info._task_submit or info._choose_reward then
      info._task_submit = info._task_submit or info._choose_reward or {}
      self.data:updateActivityData(info._task_submit)
      self:updateReds(info._task_submit)
      self:mainHeroDisplay(info._task_submit)
    end
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.RECHARGE)
    FireEvent("MainActivityTips")
    FireEvent("ActivityUpdateSuccess")
  end)
  ListenEvent("UpdatePassRewardTips", function(info)
    if self.activityData then
      local passId = info.passId
      local rewardCount = info.rewardCount
      if passId == ed.passDefine.FUND_PASS then
        self.reds[9999901] = rewardCount
      elseif passId == ed.passDefine.PET_PASS then
        self.reds[9999904] = rewardCount
      elseif passId == ed.passDefine.TEMPERING_PASS then
        self.reds[9999905] = rewardCount
      elseif passId == ed.passDefine.PEAKDASH_PASS then
        self.reds[9999908] = rewardCount
      else
        self.reds[ed.SIMPLE_PASS_START_ID + passId] = rewardCount
      end
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
      FireEvent("update_activity_reds", self.reds)
    end
  end)
  ListenEvent("updateRetrievalRewardTips", function()
    local retrievalRewardMgr = ed.retrievalRewardMgr.getInstance()
    self.reds[9999903] = retrievalRewardMgr:hasRed() and 1 or 0
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
    FireEvent("update_activity_reds", self.reds)
  end)
  ListenEvent("daily_vitality_reply", function()
    local info = ed.player:getDailyVitalityRed()
    self.reds[9999902] = (info.lunchFree or info.dinnerFree) and 1 or 0
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
    FireEvent("update_activity_reds", self.reds)
  end)
  ListenEvent("ResourceNumChange", function(resType, id)
    if resType == "item" and ed.ui.activityLotteryPage.consumeId == id then
      for i, v in pairs(self.data.activityInfo or {}) do
        if v._type == "lottery" then
          self:updateReds({
            _act_id = v._id
          })
          FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
        end
      end
    elseif resType == "item" and 20704 == id then
      for i, v in pairs(self.data.activityInfo or {}) do
        if v._type == "all_server_assist" then
          self:updateReds({
            _act_id = v._id
          })
          FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
        end
      end
    end
  end)
  return self
end

function ahs:createReds()
  local nt = ed.getServerTime()
  local showAct = self.data.activityInfo
  local reds = 0
  for ii, vv in pairs(showAct) do
    reds = 0
    if vv.getRed then
      reds = vv.getRed()
    elseif nt >= vv._start_time and nt <= vv._end_time and vv._is_show == 1 then
      for i, v in ipairs(vv._tasks or {}) do
        if v._cond_type == "choose_reward" then
          local tsk = v or {}
          if tsk._progress == 0 then
            reds = 1
            break
          end
        elseif v._cond_type == "hero_recycle" then
          if ed.HeroRecycleMgr.getInstance():getRed(vv._id) then
            reds = 1
            break
          end
        else
          local tsk = v or {}
          local isCompleted = tsk._progress >= tsk._cond_target
          local isFinished = tsk._cur_reward_times and tsk._cur_reward_times >= tsk._max_reward_times
          if not isFinished and isCompleted then
            reds = 1
            break
          end
        end
      end
      if vv._type == "all_star" then
        self.allStarTaskRed = reds
        if reds == 0 then
          local pass
          for _, v in pairs(ed.passDataMgr:getDisplayPass()) do
            if v.type == "AllStar" then
              pass = v
              break
            end
          end
          if pass then
            reds = 0 < ed.passDataMgr:getPassRewardCount(pass.id) and 1 or 0
          end
        end
      end
    end
    if vv._hint_key and vv._hint_key ~= "" then
      local hintRed = 0
      if vv._hint_key == "Once" then
        if not self.Hints[vv._id] or self.Hints[vv._id].time == 0 then
          hintRed = 1
        end
      elseif vv._hint_key == "Daily" then
        if not self.Hints[vv._id] or self.Hints[vv._id].time == 0 then
          hintRed = 1
        else
          local nt, y, m, d = ed.getFitServerTime()
          local e = {
            year = y,
            month = m,
            day = d,
            hour = 5,
            min = 0,
            sec = 0
          }
          e = os.time(e)
          if e > self.Hints[vv._id].time then
            hintRed = 1
          end
        end
      else
        hintRed = reds
      end
      reds = hintRed
      self.Hints[vv._id] = {
        time = self.Hints[vv._id] and self.Hints[vv._id].time or 0,
        red = hintRed == 1
      }
    end
    self.reds[vv._id] = reds
  end
  self.activityData = showAct
  FireEvent("update_activity_reds", self.reds)
end

function ahs:updateReds(task_submit)
  local data = self.data:getActivityInfoToKey(task_submit._act_id)
  local nt = ed.getServerTime()
  local specialAct = ed.isElementInTable(data._type, {
    "dragon_boat",
    "hero_haggle"
  })
  if data._start_time ~= -1 and data._end_time ~= -1 and (not (nt >= data._start_time and nt <= data._end_time) or data._is_show ~= 1) and not specialAct then
    return
  end
  local reds = 0
  if data.getRed then
    reds = data.getRed()
  else
    for i, v in ipairs(data._tasks or {}) do
      if v._cond_type == "choose_reward" then
        local tsk = v or {}
        if tsk._progress == 0 then
          reds = 1
          break
        end
      elseif v._cond_type == "hero_recycle" then
        if ed.HeroRecycleMgr.getInstance():getRed(data._id) then
          reds = 1
          break
        end
      else
        local tsk = v or {}
        local isCompleted = tsk._progress >= tsk._cond_target
        local isFinished = tsk._cur_reward_times and tsk._cur_reward_times >= tsk._max_reward_times
        if not isFinished and isCompleted then
          reds = 1
          break
        end
      end
    end
    if data._type == "all_star" then
      self.allStarTaskRed = reds
      if reds == 0 then
        local pass
        for _, v in pairs(ed.passDataMgr:getDisplayPass()) do
          if v.type == "AllStar" then
            pass = v
            break
          end
        end
        if pass then
          reds = 0 < ed.passDataMgr:getPassRewardCount(pass.id) and 1 or 0
        end
      end
    end
  end
  if data._hint_key and data._hint_key ~= "" then
    local hintRed = 0
    if data._hint_key == "Once" then
      if not self.Hints[data._id] or self.Hints[data._id].time == 0 then
        hintRed = 1
      end
    elseif data._hint_key == "Daily" then
      if not self.Hints[data._id] or self.Hints[data._id].time == 0 then
        hintRed = 1
      else
        local nt, y, m, d = ed.getFitServerTime()
        local e = {
          year = y,
          month = m,
          day = d,
          hour = 5,
          min = 0,
          sec = 0
        }
        e = os.time(e)
        if e > self.Hints[data._id].time then
          hintRed = 1
        end
      end
    else
      hintRed = reds
    end
    reds = hintRed
    self.Hints[data._id] = {
      time = self.Hints[data._id] and self.Hints[data._id].time or 0,
      red = hintRed == 1
    }
  end
  self.reds[data._id] = reds
  FireEvent("update_activity_reds", self.reds)
end

function ahs:getActivityRedShow()
  if self.openUpdate then
    return true
  end
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Activity")
  if cpl then
    return false
  end
  for k, v in pairs(self.reds) do
    if 0 < v and (k < ed.SIMPLE_PASS_START_ID or 9999900 < k) then
      return true
    end
  end
  return false
end

function ahs:mainHeroDisplay(taskSubmit)
  if self.taskSubmitReplyActiId == taskSubmit._act_id then
    self.taskSubmitReplyActiId = nil
    ed.player:addRewards(taskSubmit._rewards or {})
    local items = {}
    for i, v in ipairs(taskSubmit._rewards or {}) do
      v._type = v._type == "free_monthcard" and "FreeMonthCard" or v._type
      if v._type ~= "hero" then
        table.insert(items, v)
      end
    end
    if 0 < #items then
      ed.UITool.showRewardsFromServer(items)
    end
  end
end

function ahs.getInstance()
  if not ahs.instance then
    ahs.instance = ahs.create()
  end
  return ahs.instance
end

ed.activityHints = ahs.getInstance()
