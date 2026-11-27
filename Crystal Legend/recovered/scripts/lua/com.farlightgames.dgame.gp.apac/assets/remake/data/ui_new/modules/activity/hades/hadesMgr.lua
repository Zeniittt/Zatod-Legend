local class = {}
ed.hadesHeatMgr = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self.chooseHeatInfos = {}
  self.battlePrepareInfo = {}
  self.allHeatTaskList = {}
  self.heatNotify = {}
  self.redPointMgr = ed.redPointMgr.getInstance()
  self:registerRedPoint()
end

function class:registerRedPoint()
  self.redPointMgr:registerValueChange("nian_monster_entry", self, {
    handle = function(value)
      FireEvent("RefreshRightTopButtons")
    end
  })
end

function class:handleOpenPanel(data)
  if not data then
    return
  end
  self.chooseHeatInfos[data._group_id] = data
  self:initTaskLine(data._group_id, data._task_list)
  self:initTraceTask()
  FireEvent("hadesHeatOpenPanel", data._group_id)
end

function class:initTaskLine(groupId, taskList)
  local taskLineData = {}
  for index, taskData in ipairs(taskList or {}) do
    local taskLineId = taskData._task_line_id
    local taskId = taskData._task_id
    if not taskLineData[taskLineId] then
      taskLineData[taskLineId] = {}
    end
    taskLineData[taskLineId][taskId] = ed.copyProto(taskData)
  end
  self.allHeatTaskList[groupId] = taskLineData
end

function class:handleNotify(data)
  for index, singleNotify in ipairs(data._single_notifies or {}) do
    local groupId = singleNotify._group_id
    local hasRewardedTask = singleNotify._has_unrewarded_task
    local hasNewTask = singleNotify._has_new_task
    local moduleName = singleNotify._module_name
    self:setHeatNotifyData(groupId, singleNotify)
    if moduleName == "activity_adventure" then
      self.redPointMgr:setNodeValue("hades_heat_has_reward_task", hasRewardedTask and 0 < hasRewardedTask)
      self.redPointMgr:setNodeValue("hades_heat_new_task", hasNewTask and 0 < hasNewTask)
    elseif moduleName == "nian_monster" then
      self.redPointMgr:setNodeValue("nian_monster_has_reward", hasRewardedTask and 0 < hasRewardedTask)
      self.redPointMgr:setNodeValue("nian_monster_new_task", hasNewTask and 0 < hasNewTask)
    end
  end
end

function class:handleEnterStage(data)
  local rseed = data._rseed
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  local hero_list = {}
  for i, id in ipairs(self.battlePrepareInfo.team) do
    local hero = ed.player:getHero(id)
    table.insert(hero_list, hero)
  end
  local stageId = self.battlePrepareInfo.stageId
  local stageInfo = ed.lookupDataTable("HeatStage", nil, stageId)
  local battle = ed.lookupDataTable("HeatBattle", nil, stageId, 1)
  ed.srand(rseed)
  ed.engine:enterHadesHeat(stageInfo, hero_list, nil, nil, nil, nil, {
    chooseHeat = self.battlePrepareInfo.chooseHeat,
    groupId = self.battlePrepareInfo.groupId,
    echoId = self.battlePrepareInfo.echoId,
    difficultyRatio = self:getDifficultyRatio(self.battlePrepareInfo.groupId)
  })
  local extra_info = {}
  extra_info.hadesHeatInfo = {}
  ed.scene:reset(stageInfo, battle, extra_info)
  ed.replaceScene(ed.scene)
  local itemId = self.battlePrepareInfo.itemId
  if itemId then
    ed.player:consumeEquip(itemId, 1)
  end
end

function class:handleExitStage(data)
  local result = data._result
  local checkid = data._checkid
  if result == "unknown" and checkid and 0 < checkid and do_battle_log then
    ed.reportBattleLog(checkid, "hadesHeat")
    ed.showAlertDialog({
      text = T("\231\189\145\231\187\156\232\191\158\230\142\165\229\188\130\229\184\184\239\188\140\232\175\183\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\227\128\130"),
      buttonText = T("\233\128\128\229\135\186"),
      handler = function()
        EDExit()
      end
    })
    return
  end
  local isVictory = result == "victory"
  if result == "canceled" then
    return
  end
  local param = {
    isVictory = isVictory,
    isBreakRecord = data._is_break_record,
    maxHeat = data._max_heat,
    chooseHeat = data._cur_choose_heat,
    curHeat = data._cur_heat,
    curBattleTime = data._cur_battle_time,
    groupId = data._group_id
  }
  ListenTimer(Timer:Once(1.5), function()
    ed.UITool.openView("hadesBattleResult", param)
  end)
end

function class:handleRankboard(data)
  FireEvent("HeatRankboard", data)
end

function class:handleGetTaskRewards(data)
  local rewards = data._rewards
  if rewards then
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(rewards)
  end
end

function class:getAllHeatInfo()
  return self.chooseHeatInfos
end

function class:setBattlePrepareInfo(info)
  self.battlePrepareInfo = info
end

function class:getBattlePrepareInfo()
  return self.battlePrepareInfo
end

function class:getHeatInfoByGroup(groupId)
  return self.chooseHeatInfos[groupId] or {}
end

function class:getMaxHeat(groupId)
  local heatInfo = self:getHeatInfoByGroup(groupId)
  return heatInfo._max_heat or 0
end

function class:getShowTaskList(groupId)
  local heatTaskList = self.allHeatTaskList[groupId]
  local showTaskList = {}
  local nextTaskOpenTime
  for taskLineId, taskDataList in pairs(heatTaskList or {}) do
    local hasInserted = false
    for taskId, taskData in ipairs(taskDataList or {}) do
      local isRewarded = taskData._is_rewarded and taskData._is_rewarded > 0
      local taskIsOpen = false
      local isNewTask = false
      local key = ed.getRoleKey(string.format("showHadesTaskNew_%s_%s_%s", groupId, taskLineId, taskId))
      if not ed.storage.getBool(key) then
        isNewTask = true
      else
        isNewTask = false
      end
      taskData.isNewTask = isNewTask
      if taskData._start_time and taskData._expire_time then
        taskIsOpen = taskData._start_time < ed.getServerTime() and taskData._expire_time > ed.getServerTime()
      elseif taskData._start_time then
        taskIsOpen = taskData._start_time < ed.getServerTime()
      end
      if taskIsOpen then
        if isRewarded then
          table.insert(showTaskList, taskData)
          ed.storage.setValue(key, true)
        elseif not hasInserted then
          hasInserted = true
          if isNewTask then
            ed.storage.setValue(key, true)
          end
          table.insert(showTaskList, taskData)
        end
      else
        nextTaskOpenTime = nextTaskOpenTime and math.min(nextTaskOpenTime, taskData._start_time) or taskData._start_time
      end
    end
  end
  return showTaskList, nextTaskOpenTime
end

function class:setHeatNotifyData(groupId, singleNotify)
  self.heatNotify[groupId] = singleNotify
end

function class:getHeatNotify(groupId)
  return self.heatNotify[groupId] or {}
end

function class:getChallengeLevel(groupId)
  local heatInfo = self:getHeatInfoByGroup(groupId)
  return heatInfo._challenge_level or 0
end

function class:getDifficultyRatio(groupId)
  local challengeLevel = self:getChallengeLevel(groupId)
  local heatGroupCfg = ed.getDataTable("HeatGroup")[groupId]
  if not heatGroupCfg then
    return 0
  end
  local minDay = heatGroupCfg["Min day"]
  local maxDay = heatGroupCfg["Max day"]
  challengeLevel = math.max(challengeLevel, minDay)
  challengeLevel = math.min(challengeLevel, maxDay)
  local k = (challengeLevel - minDay) / (maxDay - minDay)
  return k
end

function class:setTraceTask(taskLineId, taskId)
  self.traceTaskLineId = taskLineId
  self.traceTaskId = taskId
  self:saveTraceTask()
  FireEvent("HeatTraceTask")
end

function class:clearTraceTask()
  self.traceTaskLineId = 0
  self.traceTaskId = 0
  ed.storage.setValue(ed.getRoleKey("heat_trace_task_line_id"), 0)
  ed.storage.setValue(ed.getRoleKey("heat_trace_task_id"), 0)
  FireEvent("HeatClearTraceTask")
end

function class:getTraceTask()
  return self.traceTaskLineId, self.traceTaskId
end

function class:initTraceTask()
  local traceTaskLineId = ed.storage.getInt(ed.getRoleKey("heat_trace_task_line_id"))
  local traceTaskId = ed.storage.getInt(ed.getRoleKey("heat_trace_task_id"))
  for groupId, taskLineData in pairs(self.allHeatTaskList or {}) do
    if not taskLineData[traceTaskLineId] then
      traceTaskLineId = nil
      break
    end
  end
  if traceTaskLineId and 0 < traceTaskLineId and traceTaskId and 0 < traceTaskId then
    self.traceTaskLineId = traceTaskLineId
    self.traceTaskId = traceTaskId
  else
    self.traceTaskLineId = 0
    self.traceTaskId = 0
  end
end

function class:saveTraceTask()
  if self.traceTaskLineId and self.traceTaskId then
    ed.storage.setValue(ed.getRoleKey("heat_trace_task_line_id"), self.traceTaskLineId)
    ed.storage.setValue(ed.getRoleKey("heat_trace_task_id"), self.traceTaskId)
  end
end
