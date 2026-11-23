local class = {}
class.__index = class

function class.getInstance(...)
  local object = {}
  setmetatable(object, class)
  object:initData()
  object:registerEvents()
  object:InitEvents()
  return object
end

function class:isDebug()
  return false
end

function class:initData()
  self.isOpen = false
  self.isOpenPanel = false
  self.isOpenBattle = false
  self.isOpenTaskRewards = false
  self.activeTimeClose = false
  self.isStartClientTimeCount = false
  self.isTimerRunning = false
  self.next5AmTimerName = nil
end

local ActivityTimeScope = {}
local FiveAmScope = {}

function class:InitEvents()
end

function class:onFiveAmReached()
  FireEvent("EventCreviceDefendStageEnd")
end

function class:startActivityTimer()
  if self.isTimerRunning then
    return
  end
  self.isTimerRunning = true
  ListenTimer(Timer:Always(1), function()
    self:activityUpdate()
  end, ActivityTimeScope)
end

function class:stopActivityTimer()
  if not self.isTimerRunning then
    return
  end
  self.isTimerRunning = false
  CloseScope(ActivityTimeScope)
end

function class:checkActivityStatusAndManageTimer()
  local isActivityOpen = self:isActivityCurrentlyOpen()
  if isActivityOpen and not self.isTimerRunning then
    self:startActivityTimer()
  elseif not isActivityOpen and self.isTimerRunning then
    self:stopActivityTimer()
  end
end

function class:isActivityCurrentlyOpen()
  if not self.isStartClientTimeCount then
    return false
  end
  local creviceDefendSeasonConfig = ed.getDataTable("CreviceDefendSeason")
  local currentTime = ed.getServerTime()
  for i, v in pairs(creviceDefendSeasonConfig) do
    local startTimeStamp = ed.dateStringToTime(v["Start Time"])
    local endTimeStamp = ed.dateStringToTime(v["End Time"])
    if currentTime > startTimeStamp and currentTime < endTimeStamp then
      return true
    end
  end
  return false
end

function class:activityUpdate()
  self:refreshTimeCountState()
end

function class:getCurrentSeasonConfig()
  local creviceDefendSeasonConfig = ed.getDataTable("CreviceDefendSeason")
  local currentTime = ed.getServerTime()
  for i, v in pairs(creviceDefendSeasonConfig) do
    local startTimeStamp = ed.dateStringToTime(v["Start Time"])
    local endTimeStamp = ed.dateStringToTime(v["End Time"])
    if currentTime > startTimeStamp and currentTime < endTimeStamp then
      self.currentSeasonConfig = v
      break
    end
  end
end

function class:isInMainScene()
  local topScene = ed.scene_stack and ed.scene_stack[#ed.scene_stack]
  return topScene and topScene.identity == "mainScene"
end

function class:refreshTimeCountState()
  if not self.isStartClientTimeCount then
    return
  end
  if not self:isInMainScene() then
    return
  end
  local creviceDefendSeasonConfig = ed.getDataTable("CreviceDefendSeason")
  local current_creviceDefendSeasonConfig
  local currentTime = ed.getServerTime()
  for i, v in pairs(creviceDefendSeasonConfig) do
    local startTimeStamp = ed.dateStringToTime(v["Start Time"])
    local endTimeStamp = ed.dateStringToTime(v["End Time"])
    if currentTime > startTimeStamp and currentTime < endTimeStamp then
      current_creviceDefendSeasonConfig = v
      break
    end
  end
  if current_creviceDefendSeasonConfig == nil and self.activeTimeClose == false then
    self.activeTimeClose = true
    self:stopActivityTimer()
    FireEvent("MainRightTopActiveChange")
  end
  if current_creviceDefendSeasonConfig ~= nil and self.currentSeasonConfig == nil then
    self.activeTimeClose = false
    self.currentSeasonConfig = current_creviceDefendSeasonConfig
    self:startActivityTimer()
    FireEvent("MainRightTopActiveChange")
  end
end

function class:Destroy()
  CloseScope(ActivityTimeScope)
end

function class:registerEvents()
  ListenEvent("CREVICE_BATTLE_PREPARE_DONE", function(data)
    self:handleChallengeOppo(data)
  end)
end

function class:handleChallengeOppo(data)
  ed.ui.CreviceDefendBattleWin.create({
    selfCamp = data.attackTeams
  })
  ed.CreviceDefendNetWork:sendStartChallenge(data.attackTeams)
  ed.loadEnd()
  ed.openMemeryGC = false
end

function class:updateMessage()
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CREVICE_DEFEND)
  FireEvent("EventCreviceDefendUpdateRedPoint")
  FireEvent("MainRightTopActiveChange")
end

function class:handleNotify(notify)
  if notify then
    self.isStartClientTimeCount = true
    self.isOpen = notify._is_open
    self.isOpenBattle = notify._refresh_battle
    self.isOpenTaskRewards = notify._task_rewards
    self:checkActivityStatusAndManageTimer()
    self:updateMessage()
  end
end

function class:handleOpenPanel(msg)
  self.seasonId = msg._season
  self.zoneId = msg._zone
  self.remainCount = msg._day_left_count
  self.day_buy_count = msg._day_buy_count
  self.end_time = msg._end_time
  self.bossDamageList = msg._boss_damage
  self.currentRank = msg._rank
  self.target_rank = msg._target_rank
  self.target_damage = msg._target_damage
  self.reward_task = msg._reward_task
  self.total_challenge_count = msg._total_challenge_count
  self:setOpenActiveRed()
  CloseScope(FiveAmScope)
  ListenEvent("FiveAmRefresh", function()
    self:onFiveAmReached()
  end, FiveAmScope)
  if not self.isOpenPanel then
    self.isOpenPanel = true
    local scene = ed.ui.CreviceDefendMainScene.create()
    ed.pushScene(scene)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CREVICE_DEFEND)
  else
    FireEvent("EventCreviceDefendUpdateView")
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CREVICE_DEFEND)
    FireEvent("EventCreviceDefendUpdateRedPoint")
  end
end

function class:handleZoneRank(msg)
  ed.UITool.openView("OpenCreviceDefendRankWin", msg)
end

function class:handleLineup(msg)
  local lineup = msg._lineup
  if nil == lineup then
    return
  end
  ed.ui.CreviceDefendStatisticWin.create(lineup)
end

function class:handleQuerySummary(msg)
  local summary = msg._summary
  if summary then
    ed.ui.BattleStaticsWin.create({
      _hero_data = summary._hero_data
    }, "common")
  end
end

function class:handleQueryRecords(msg)
  if msg._records then
    ed.UITool.openView("OpenCreviceDefendRecordDetailWin", msg)
  else
    ed.showToast(T("\230\154\130\230\151\160\229\189\149\229\131\143"))
  end
end

function class:handleBuyChallengeCount(msg)
  self.remainCount = msg._day_left_count
  self.day_buy_count = msg._day_buy_count
  FireEvent("UpdateCreviceDefendChallengeCount")
  local priceTable = ed.getDataTable("CreviceDefendBuyChallengeCount")
  local currentCount = ed.CreviceDefendManager:getBuyCount()
  local costConfig = priceTable[currentCount]
  local cost = 0
  if costConfig then
    cost = costConfig.Price
  else
    cost = 200
  end
  ed.player:addrmb(-cost)
end

function class:handleOpenTask(msg)
  self.reward_task = msg._reward_task
  msg._rewards = msg._rewards or {}
  if msg._rewards then
    local rewards = {}
    for _, v in ipairs(msg._rewards) do
      if v._type == "raid_point" then
        table.insert(rewards, {_type = "raid_point", _amount = 0})
      else
        table.insert(rewards, v)
      end
    end
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(msg._rewards, nil, function()
      FireEvent("refreshdayAwardsScene", {
        type = "taskRewards"
      })
    end)
  end
  FireEvent("EventCreviceDefendUpdateRedPoint")
  FireEvent("RefreshCreviceDefendTaskView")
end

function class:handleChallengeRecord(msg)
  ed.UITool.openView("OpenCreviceDefendRecordWin", msg)
end

function class:handleOpenRecommend(msg)
  ed.ui.CreviceDefendReCommendWin.create(msg)
end

function class:getState()
  if self.activeTimeClose then
    return false
  end
  return self.isOpen == 1
end

function class:getSeasonId()
  return self.seasonId
end

function class:getZoneId()
  return self.zoneId or 1
end

function class:getTotalDamage()
  local damage = 0
  for i, v in pairs(self.bossDamageList or {}) do
    damage = damage + v
  end
  return damage
end

function class:getCurrentDamage(index)
  if self.bossDamageList then
    return self.bossDamageList[index]
  end
  return 0
end

function class:getEndTime()
  return self.end_time or 0
end

function class:getSeasonRank()
  return self.currentRank or 1
end

function class:getTargetDamage()
  return self.target_damage or 1
end

function class:getTargetRank()
  return self.target_rank or 1
end

function class:getChallengeCount()
  if self.remainCount then
    return self.remainCount
  end
  return 0
end

function class:getTasks()
  return self.reward_task or {}
end

function class:getTotalCount()
  return self.total_challenge_count or 0
end

function class:updateRemainCount()
  self.remainCount = self.remainCount - 1
end

function class:getBuyCount()
  return self.day_buy_count or 1
end

function class:getChallengeCountRedFlag()
  if self.currentSeasonConfig then
    local timeStamp = ed.dateStringToTime(self.currentSeasonConfig["End Battle Time"])
    local currentTime = ed.getServerTime()
    if timeStamp < currentTime then
      return false
    end
    return self:getChallengeCount() > 0
  else
    return false
  end
end

function class:getRedFlag()
  local openBattle = self:getOpenActiveRed()
  local openTaskRewards = self:getOpenTaskRewards() == 1
  return openBattle or openTaskRewards
end

function class:setOpenActiveRed()
  ed.storage.setValue(ed.getRoleKey("CreviceDefendManager"), "true")
end

function class:getOpenActiveRed()
  local state = ed.storage.getValue("string", ed.getRoleKey("CreviceDefendManager"))
  if state and state == "true" then
    return false
  else
    return true
  end
end

function class:resetOpenPanel()
  self.isOpenPanel = false
end

function class:getOpenBattle()
  return self.isOpenBattle
end

function class:setOpenTaskRewards(state)
  self.isOpenTaskRewards = state
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.CREVICE_DEFEND)
end

function class:getOpenTaskRewards()
  return self.isOpenTaskRewards
end

ed.CreviceDefendManager = class.getInstance()
