local class = newclass("g")
ed.rogueLikeMgr = class
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
  self.roomData = {}
  self.allTechData = {}
  self.viewRogueResultData = {}
  self.viewBless = {}
  self.viewRevelation = {}
  self.blessRewardFlag = {}
  self.viewEvent = {}
  self.goldenRewardFlag = {}
  self.scriptData = {}
  self.weeklyPoint = 0
  self.goldenPoint = 0
  self.curChapterId = 0
  self.curRoundId = 0
  self.handleResultIndex = 1
  self.curHandleRogueResultList = {}
  self.revelationEnable = false
  self:initRedPointMgr()
  self:initRogueResultHandle()
  self:initRogueEventChoiceHandle()
end

function class:initRedPointMgr()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("rogue_entry", self, {
    handle = function(value)
      FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.Rogue)
    end
  })
  for bookId, bookCfg in ipairs(ed.getDataTable("RogueBook")) do
    local chapterId = bookCfg["Chapter Group"]
    self.redPointMgr:addNode("rogue_book_" .. bookId, {
      "rogue_entry"
    })
    self.redPointMgr:addNode("rogue_book_tech_" .. chapterId)
  end
end

function class:updateTechRedPoint(chapterId)
  local techData = self:getTechData(chapterId)
  local techPoint = techData.techPoint or 0
  local lightTechList = techData.lightTechList or {}
  local techTreeId = ed.getDataTable("RogueChapter")[chapterId][1]["Tech Tree ID"]
  if not techTreeId or techTreeId == 0 then
    return
  end
  local rogueTechCfg = ed.getDataTable("RogueTech")[techTreeId]
  local canLearnTech = false
  for techId, techCfg in ipairs(rogueTechCfg or {}) do
    local cost = techCfg["Tech Point Cost"]
    local isUnlock = true
    for index, preTechId in ipairs(techCfg["Require Tech"]) do
      if not ed.isElementInTable(preTechId, lightTechList) then
        isUnlock = false
        break
      end
    end
    if not ed.isElementInTable(techId, lightTechList) and techPoint >= cost and isUnlock then
      canLearnTech = true
      break
    end
  end
  self.redPointMgr:setNodeValue("rogue_book_tech_" .. chapterId, canLearnTech)
end

function class:updateCollectionRedPoint()
  local viewRevelationAmount = #self:getViewRevelation()
  local viewBlessAmount = #self:getViewBless()
  local totalViewAmount = viewBlessAmount + viewRevelationAmount
  local haveDestinyReward = false
  for id, blessCollectCfg in ipairs(ed.getDataTable("RogueBlessCollection")) do
    local requireAmount = blessCollectCfg["Require Bless Amount"]
    local flag = self:getBlessRewardFlagById(id)
    if not flag and totalViewAmount >= requireAmount then
      haveDestinyReward = true
      break
    end
  end
  self.redPointMgr:setNodeValue("rogue_collection_weekly_reward_entry", haveDestinyReward)
  local haveEventReward = false
  for eventId, eventCfg in ipairs(ed.getDataTable("RogueEvent")) do
    local flag = self:getEventRewardFlag(eventId)
    if flag == 0 then
      haveEventReward = true
      break
    end
  end
  self.redPointMgr:setNodeValue("rogue_collection_event_entry", haveEventReward)
end

function class:updateScriptRedPoint()
  local haveScriptReward = false
  for scriptId, _ in pairs(ed.getDataTable("RogueScript")) do
    local rogueScript = self:getScriptRewardData(scriptId)
    if not rogueScript._reward_time and rogueScript._complete_time then
      haveScriptReward = true
      break
    end
  end
  self.redPointMgr:setNodeValue("rogue_collection_script_entry", haveScriptReward)
end

function class:updateGoldenRewardRedPoint()
  local goldenPoint = self:getGoldenPoint()
  local goldenRedPoint = false
  for id, rewardCfg in ipairs(ed.getDataTable("RogueGoldenReward") or {}) do
    local requirePoint = rewardCfg.Point
    local flag = self:getGoldenRewardFlagById(id)
    if goldenPoint >= requirePoint and not flag then
      goldenRedPoint = true
      break
    end
  end
  self.redPointMgr:setNodeValue("rogue_golden_entry", goldenRedPoint)
end

function class:handleNotify(_rogue_notify)
  local newChapter = _rogue_notify._new_chapter
  local scriptReward = _rogue_notify._script_reward
  local goldenReward = _rogue_notify._golden_reward
  self.redPointMgr:setNodeValue("rogue_collection_script_entry", scriptReward == 1)
  self.redPointMgr:setNodeValue("rogue_golden_entry", goldenReward == 1)
  for bookId, bookCfg in ipairs(ed.getDataTable("RogueBook")) do
    local chapterId = bookCfg["Chapter Group"]
    local isNewBook = ed.isElementInTable(chapterId, newChapter or {})
    self.redPointMgr:setNodeValue("rogue_book_" .. chapterId, isNewBook)
  end
end

function class:handleOpenPanel(_open_panel)
  local userRogue = _open_panel._user_rogue
  self.curChapter = userRogue._cur_chapter
  self.passChapter = userRogue._pass_chapter
  self.viewBless = userRogue._view_bless or {}
  self.viewRevelation = userRogue._view_revelation or {}
  self.blessRewardFlag = userRogue._bless_reward_flag or {}
  self.viewEvent = userRogue._view_event or {}
  self.weeklyPoint = userRogue._weekly_point
  self.goldenPoint = userRogue._golden_point
  self.goldenRewardFlag = userRogue._golden_reward_flag or {}
  self.finishCallBackList = {}
  self:initChapterData()
  self:initViewRogueResultData()
  self:updateCollectionRedPoint()
  self:updateGoldenRewardRedPoint()
  FireEvent("rogueOpenPanel")
end

function class:handleEnterChapter(_enter_chapter)
  self.curChapter = _enter_chapter._cur_chapter
  self:initChapterData()
  self:initViewRogueResultData()
  ed.rogueLikeTool.jumpToMapScene()
end

function class:handleEnterRoom(_enter_room)
  local roomId = _enter_room._room_id
  local type = _enter_room._type
  local wave = _enter_room._wave_id
  local stageId = _enter_room._stage_id
  local event = _enter_room._event
  local goods = _enter_room._goods
  local results = _enter_room._results
  local heroInfos = _enter_room._hero_infos
  local pearl = _enter_room._pearl
  local desEnergy = _enter_room._des_energy
  local curChapter = self:getCurChapter()
  curChapter._cur_room_id = roomId
  curChapter._cur_wave = wave
  local roomData = self.roomData[self.curRoundId][roomId]
  roomData.type = type
  roomData.stageId = stageId
  roomData.event = event
  roomData.goods = goods
  roomData.passed = 1
  if results then
    roomData.results = results
  end
  local curChapter = self:getCurChapter()
  if heroInfos and 0 < #heroInfos then
    curChapter._heroes = heroInfos
  end
  self:setPearl(pearl)
  if desEnergy then
    curChapter._des_energy = desEnergy
  end
  ListenTimer(Timer:Once(1), function()
    self:handleRoom(roomId)
  end)
  FireEvent("rogueEnterRoom")
end

function class:handleStartBattle(_start_battle)
  local rseed = _start_battle._rseed
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.srand(rseed)
  local curWave = _start_battle._cur_wave
  local retryTimes = _start_battle._retry_times
  local canBattleStatus = _start_battle._can_battle_status
  local chapter = self:getCurChapter()
  local techList = chapter._tech_list or {}
  local heroIdList = self.battlePrepareInfo.heroIdList
  local stageId = self.battlePrepareInfo.stageId
  self:setRetryTimes(retryTimes)
  chapter._can_battle_status = canBattleStatus
  local stageInfo = ed.lookupDataTable("RogueStage", nil, stageId)
  local heroList = {}
  for _, heroId in ipairs(heroIdList or {}) do
    local hero = ed.player:getHero(heroId)
    table.insert(heroList, hero)
  end
  ed.engine:enterRogueBattle(stageInfo, heroList, {
    stageId = stageId,
    chapterId = chapter._chapter_id,
    destinyId = chapter._destiny,
    destinyEnergy = chapter._des_energy,
    blessList = chapter._bless_list,
    charmList = chapter._charm_list,
    techIdList = techList,
    dynaStart = chapter._heroes,
    chapterDiff = chapter._difficulty,
    crisisDiff = chapter._crisis,
    rogueWave = curWave
  })
  local battle = ed.lookupDataTable("RogueBattle", nil, stageId, 1)
  local bgPath = ed.getDataTable("RogueChapter")[chapter._chapter_id][chapter._difficulty]["Background Pic"]
  local extra_info = {
    rogueModeInfo = {},
    extra_ui_info = {background = bgPath}
  }
  ed.scene:reset(stageInfo, battle, extra_info)
  ed.replaceScene(ed.scene)
  FireEvent("rogueStartBattle")
end

function class:handleEndBattle(_end_battle)
  local result = _end_battle._battle_result
  local roomId = _end_battle._cur_room_id
  local results = _end_battle._result
  local heroInfos = _end_battle._hero_infos
  local desEnergy = _end_battle._des_energy
  local retryTimes = _end_battle._retry_times
  local canBattleStatus = _end_battle._can_battle_status
  local battleStatus = _end_battle._battle_status
  local pearl = _end_battle._pearl
  local heroRebornTimes = _end_battle._hero_reborn_times
  local curChapter = self:getCurChapter()
  if result == "unknown" then
    return
  end
  self:setRetryTimes(retryTimes)
  curChapter._can_battle_status = canBattleStatus
  curChapter._battle_status = battleStatus
  self:setPearl(pearl)
  self:setRebornTimes(heroRebornTimes)
  if desEnergy then
    curChapter._des_energy = desEnergy
  end
  local isVictory = result == "victory"
  if result == "canceled" then
    return
  end
  if results then
    self.roomData[self.curRoundId][roomId].results = results
  end
  if isVictory then
    for _, newHeroInfo in ipairs(heroInfos or {}) do
      local findIndex
      for index, oldHeroInfo in ipairs(curChapter._heroes) do
        if oldHeroInfo._heroid == newHeroInfo._heroid then
          findIndex = index
          break
        end
      end
      if findIndex then
        curChapter._heroes[findIndex] = newHeroInfo
      end
    end
  end
  if isVictory then
    ListenTimer(Timer:Once(1.5), function()
      ed.UITool.openView("rogueBattleWin", {
        heroInfos = heroInfos,
        results = results,
        closeCallBack = function()
          self:handleRogueResultList(results, 1, function()
          end)
        end
      })
      ed.playEffect(ed.sound.battle.pushResultScene)
    end)
    ed.playEffect(ed.sound.battle.win)
  else
    local stageId = self.battlePrepareInfo.stageId
    ListenTimer(Timer:Once(1.5), function()
      ed.UITool.openView("rogueBattleFail", {
        heroInfos = heroInfos,
        results = results,
        stageId = stageId,
        closeCallBack = function()
          self:handleRogueResultList(results, 1, function()
          end)
        end
      })
    end)
    ed.playEffect(ed.sound.battle.lose)
  end
  FireEvent("rogueEndBattle")
end

function class:handleChooseReward(_choose_reward)
  local result = _choose_reward._result
  local roomId = _choose_reward._cur_room_id
  local rogueBlessList = _choose_reward._bless
  local rogueHeroInfoList = _choose_reward._heroes
  local results = _choose_reward._results
  local isDelete = _choose_reward._is_delete == 1
  local pearl = _choose_reward._pearl
  local desEnergy = _choose_reward._des_energy
  local curChapter = self:getCurChapter()
  self:setPearl(pearl)
  if isDelete then
    local newBlessList = {}
    for _, myRogueBless in ipairs(curChapter._bless_list or {}) do
      local needDelete = false
      for _, rogueBless in ipairs(rogueBlessList or {}) do
        if myRogueBless._bless == rogueBless._bless then
          needDelete = true
          break
        end
      end
      if not needDelete then
        table.insert(newBlessList, myRogueBless)
      end
    end
    curChapter._bless_list = newBlessList
  elseif curChapter._bless_list then
    for _, rogueBless in ipairs(rogueBlessList or {}) do
      table.insert(curChapter._bless_list, rogueBless)
    end
  else
    curChapter._bless_list = rogueBlessList
  end
  for index, rogueHeroInfo in ipairs(rogueHeroInfoList or {}) do
    table.insert(curChapter._heroes, rogueHeroInfo)
  end
  self:setDestinyEnergy(desEnergy)
  local roomData = self:getRoomData(roomId)
  roomData.results = results
  self.handleResultIndex = self.handleResultIndex + 1
  local event = roomData.event
  self:handleRogueResultList(results, self.handleResultIndex, function()
    self:handleEvent(event)
    self:checkRevelationUnlock()
  end)
  FireEvent("rogueChooseReward")
end

function class:handleChooseChoice(_choose_choice)
  local result = _choose_choice._result
  local roomId = _choose_choice._cur_room_id
  local event = _choose_choice._event
  local rogueResult = _choose_choice._rogue_result
  local heroInfos = _choose_choice._hero_infos
  local pearl = _choose_choice._pearl
  local desEnergy = _choose_choice._des_energy
  local retryTimes = _choose_choice._retry_times
  self.roomData[self.curRoundId][roomId].event = event
  self.roomData[self.curRoundId][roomId].results = rogueResult
  local curChapter = self:getCurChapter()
  if heroInfos and 0 < #heroInfos then
    curChapter._heroes = heroInfos
  end
  self:setPearl(pearl)
  self:setRetryTimes(retryTimes)
  self:setDestinyEnergy(desEnergy)
  self:handleRogueResultList(rogueResult, 1, function()
    self:handleEvent(event)
  end)
  FireEvent("rogueChooseChoice", event)
end

function class:handleBuyBless(_shop_buy_bless)
  local result = _shop_buy_bless._result
  local roomId = _shop_buy_bless._cur_room_id
  local rogueBless = _shop_buy_bless._bless
  local rogueResult = _shop_buy_bless._rogue_result
  local leftPearl = _shop_buy_bless._left_pearl
  local desEnergy = _shop_buy_bless._des_energy
  local curChapter = self:getCurChapter()
  self:setPearl(leftPearl)
  if curChapter._bless_list then
    local exist = false
    for index, myRogueBless in ipairs(curChapter._bless_list) do
      if myRogueBless._bless == rogueBless._bless then
        myRogueBless._level = rogueBless._level
        exist = true
        break
      end
    end
    if not exist then
      table.insert(curChapter._bless_list, rogueBless)
    end
  else
    curChapter._bless_list = {rogueBless}
  end
  self.roomData[self.curRoundId][roomId].results = rogueResult
  self:setDestinyEnergy(desEnergy)
  self:handleRogueResultList(rogueResult, 1, function()
    self:checkRevelationUnlock()
  end)
  FireEvent("rogueBuyBless")
end

function class:handleRefreshBless(_refresh_bless)
  local resultIndex = _refresh_bless._result_index
  local roomId = _refresh_bless._room_id
  local rogueResult = _refresh_bless._rogue_result
  local leftPearl = _refresh_bless._left_pearl
  self.roomData[self.curRoundId][roomId].results = rogueResult
  self:setPearl(leftPearl)
  local refreshResult = rogueResult[resultIndex]
  FireEvent("rogueRefreshBless", refreshResult)
end

function class:handleEnterNextRound(_enter_next_round)
  local result = _enter_next_round._result
  local nextRoundId = _enter_next_round._round_id
  local roomId = _enter_next_round._room_id
  local results = _enter_next_round._rogue_results
  local pearl = _enter_next_round._pearl
  local curChapter = self:getCurChapter()
  self.curRoundId = nextRoundId
  curChapter._cur_round_id = nextRoundId
  curChapter._cur_room_id = roomId
  self:setPearl(pearl)
  local roomData = self:getRoomData(roomId)
  roomData.results = results
  roomData.passed = 1
  FireEvent("rogueEnterNextRound")
end

function class:handleSkipBattle(_skip_battle)
  local curRoomId = _skip_battle._cur_room_id
  local results = _skip_battle._result
  local pearl = _skip_battle._pearl
  self:setPearl(pearl)
  local curChapter = self:getCurChapter()
  curChapter._cur_room_id = curRoomId
  self:handleRogueResultList(results, 1, function()
  end)
  FireEvent("rogueEndBattle")
end

function class:handleEndChapter(_end_chapter)
  local canBattleStatus = _end_chapter._can_battle_status
  local battleStatus = _end_chapter._battle_status
  local curChapter = self:getCurChapter()
  curChapter._can_battle_status = canBattleStatus
  curChapter._battle_status = battleStatus
  FireEvent("rogueEndChapter")
end

function class:handleExitChapter(_exit_chapter)
  local chapterId = _exit_chapter._chapter_id
  local weeklyPoint = _exit_chapter._weekly_point
  local tech = _exit_chapter._tech
  local totalPearl = _exit_chapter._total_pearl
  local maxBossDamage = _exit_chapter._max_boss_damage
  local damageHero = _exit_chapter._damage_hero
  local rewards = _exit_chapter._rewards or {}
  local newCharms = _exit_chapter._new_charm_list
  if rewards and 0 < #rewards then
    ed.player:addRewards(rewards)
  end
  ed.UITool.openView("rogueTallyWindow", {
    point = weeklyPoint,
    tech = tech,
    totalPearl = totalPearl,
    maxBossDamage = maxBossDamage,
    damageHero = damageHero,
    newCharms = newCharms,
    closeCallBack = function()
      FireEvent("rogueExitChapter", chapterId)
      if rewards and 0 < #rewards then
        ListenTimer(Timer:Once(0.3), function()
          ed.UITool.showRewardsFromServer(rewards)
        end)
      end
    end
  })
end

function class:handleOpenTech(_open_tech)
  local chapterId = _open_tech._chapter_id
  local techPoint = _open_tech._tech_point
  local lightTechList = _open_tech._light_tech_list
  self.allTechData[chapterId] = {
    chapterId = chapterId,
    techPoint = techPoint,
    lightTechList = lightTechList
  }
  self:updateTechRedPoint(chapterId)
  FireEvent("rogueOpenTech", chapterId)
end

function class:handleBuyTech(_buy_tech)
  local chapterId = _buy_tech._chapter_id
  local techId = _buy_tech._tech_id
  local techPoint = _buy_tech._tech_point
  local techData = self:getTechData(chapterId)
  if not techData.lightTechList then
    techData.lightTechList = {}
  end
  techData.techPoint = techPoint
  table.insert(techData.lightTechList, techId)
  self:updateTechRedPoint(chapterId)
  FireEvent("rogueBuyTech")
end

function class:handleGoldenReward(_golden_reward)
  local level = _golden_reward._level
  local rewards = _golden_reward._rewards
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  table.insert(self.goldenRewardFlag, level)
  self:updateGoldenRewardRedPoint()
  FireEvent("rogueGoldenReward")
end

function class:handleViewBlessReward(_view_bless_reward)
  local id = _view_bless_reward._index
  local rewards = _view_bless_reward._rewards or {}
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  table.insert(self.blessRewardFlag, id)
  self:updateCollectionRedPoint()
  FireEvent("rogueViewBlessReward")
end

function class:handleViewEventReward(_view_event_reward)
  local eventId = _view_event_reward._event_id
  local rewards = _view_event_reward._rewards or {}
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  local exist = false
  for index, viewEventData in ipairs(self.viewEvent) do
    if eventId == viewEventData._id then
      viewEventData._flag = 1
      exist = true
      break
    end
  end
  if not exist then
    table.insert(self.viewEvent, {_id = eventId, _flag = 1})
  end
  self:updateCollectionRedPoint()
  FireEvent("rogueViewEventReward")
end

function class:handleRankBoard(_query_rankboard)
  FireEvent("rogueRankBoard", _query_rankboard)
end

function class:handleOpenScript(_open_script)
  local scripts = _open_script._scripts or {}
  self.scriptData = {}
  for index, rogueScript in ipairs(scripts) do
    local scriptId = rogueScript._script_id
    self.scriptData[scriptId] = rogueScript
  end
  self:updateScriptRedPoint()
  FireEvent("rogueOpenScript")
end

function class:handleScriptReward(_script_reward)
  local script = _script_reward._script
  local rewards = _script_reward._rewards
  local scriptId = script._script_id
  self.scriptData[scriptId] = script
  ed.player:addRewards(rewards)
  ed.UITool.showRewardsFromServer(rewards)
  self:updateScriptRedPoint()
  FireEvent("rogueScriptReward")
end

function class:handleQueryCharm(_query_charm)
  FireEvent("rogueQueryCharm", _query_charm)
end

function class:handleRefreshRoom(_refresh_room)
  self.curChapter._refresh_room_times = math.max(0, self.curChapter._refresh_room_times - 1)
  local type = _refresh_room._type
  local roundId = _refresh_room._round_id
  local roomId = _refresh_room._room_id
  local roomData = self.roomData[roundId][roomId]
  if nil ~= roomData then
    roomData.type = type
  end
  FireEvent("rogueRefreshRoom", roomId)
end

function class:handleSyncHeroInfos(_sync_hero_infos)
  local heroInfos = _sync_hero_infos._hero_infos
  local curChapter = self:getCurChapter()
  if heroInfos and 0 < #heroInfos then
    curChapter._heroes = heroInfos
  end
end

function class:initChapterData()
  self.roomData = {}
  local curChapter = self:getCurChapter() or {}
  for _, waveInfo in ipairs(curChapter._waves or {}) do
    local roomId = waveInfo._room_id
    local routeId = waveInfo._round_id
    if not self.roomData[routeId] then
      self.roomData[routeId] = {}
    end
    self.roomData[routeId][roomId] = {
      roundId = waveInfo._round_id,
      roomId = waveInfo._room_id,
      waveId = waveInfo._wave_id,
      type = waveInfo._type,
      stageId = waveInfo._stage_id,
      event = waveInfo._event,
      goods = waveInfo._goods_list,
      results = waveInfo._results,
      passed = waveInfo._passed
    }
  end
  self.curChapterId = curChapter._chapter_id or 0
  self.curRoundId = curChapter._cur_round_id or 0
  if curChapter._destiny then
    self.revelationEnable = self:getRevelationEnable(curChapter._destiny)
  end
end

function class:initViewRogueResultData()
  self.viewRogueResultData = {}
  local curChapter = self:getCurChapter()
  for _, rogueViewResult in ipairs(curChapter._view_results or {}) do
    local roundId = rogueViewResult._round_id
    local roomId = rogueViewResult._room_id
    local resultIndexList = rogueViewResult._result_index or {}
    if not self.viewRogueResultData[roundId] then
      self.viewRogueResultData[roundId] = {}
    end
    self.viewRogueResultData[roundId][roomId] = resultIndexList
  end
end

function class:getCurChapterId()
  return self.curChapterId
end

function class:getCurRoomId()
  local curChapter = self:getCurChapter() or {}
  return curChapter._cur_room_id or 0
end

function class:getCurRouteId()
  local curRoomId = self:getCurRoomId()
  local routeId = math.floor(curRoomId / 100)
  return routeId
end

function class:getSlotIdByRoomId(roomId)
  return roomId % 100
end

function class:getRoomIdBySlotId(slotId)
  local routeId = self:getCurRouteId()
  return routeId * 100 + slotId
end

function class:getRoomData(roomId)
  return self.roomData[self.curRoundId][roomId] or {}
end

function class:setBattleInfo(battlePrepareInfo)
  self.battlePrepareInfo = battlePrepareInfo
end

function class:getBattleInfo()
  return self.battlePrepareInfo or {}
end

function class:restartBattle()
  local heroIdList = self.battlePrepareInfo.heroIdList
  ed.rogueLikeNet.sendStartBattle(heroIdList)
end

function class:getCurChapter()
  return self.curChapter or {}
end

function class:getPearl()
  if self.curChapter then
    return self.curChapter._pearl
  end
  return 0
end

function class:setPearl(pearl)
  if self.curChapter and pearl then
    self.curChapter._pearl = pearl
    FireEvent("rogueUpdatePearlAmount")
  end
end

function class:getTechData(chapterId)
  return self.allTechData[chapterId] or {}
end

function class:getTechGs(chapterId)
  local techTreeId = ed.getDataTable("RogueChapter")[chapterId][1]["Tech Tree ID"]
  if not techTreeId or techTreeId == 0 then
    return 0
  end
  local rogueTechCfg = ed.getDataTable("RogueTech")[techTreeId]
  local techData = self:getTechData(chapterId)
  local totalGs = 0
  for index, techId in ipairs(techData.lightTechList or {}) do
    totalGs = totalGs + rogueTechCfg[techId].GS
  end
  return totalGs
end

function class:getTechPoint(chapterId)
  local techData = self:getTechData(chapterId)
  return techData.techPoint or 0
end

function class:getRetryTimes()
  local curChapter = self:getCurChapter()
  return curChapter._retry_times or 0
end

function class:setRetryTimes(retryTimes)
  local curChapter = self:getCurChapter()
  curChapter._retry_times = retryTimes or 0
  FireEvent("rogueUpdateRetryTimes")
end

function class:setRebornTimes(times)
  if times then
    local curChapter = self:getCurChapter()
    curChapter._hero_reborn_times = times
    FireEvent("rogueUpdateRebornTimes")
  end
end

function class:getRebornTimes()
  local curChapter = self:getCurChapter()
  return curChapter._hero_reborn_times or 0
end

function class:getCanBattle()
  local curChapter = self:getCurChapter()
  return curChapter._can_battle_status == 1
end

function class:getBlessById(blessId)
  local curChapter = self:getCurChapter()
  for index, rogueBless in ipairs(curChapter._bless_list or {}) do
    if rogueBless._bless == blessId then
      return rogueBless
    end
  end
  return nil
end

function class:addNewBlessList(idList, initLv)
  if nil == idList or nil == next(idList) then
    return
  end
  local curChapter = self:getCurChapter()
  if not curChapter._bless_list then
    curChapter._bless_list = {}
  end
  local existIdTab = {}
  for i, v in ipairs(curChapter._bless_list) do
    existIdTab[v._bless] = true
  end
  for i, v in ipairs(idList) do
    if nil == existIdTab[v] then
      table.insert(curChapter._bless_list, {
        _bless = v,
        _level = initLv or 1
      })
    end
  end
end

function class:getRoomState(roomId)
  local curChapter = self.curChapter
  if not curChapter then
    return
  end
  local curRoomId = curChapter._cur_room_id
  local curSlotId = self:getSlotIdByRoomId(curRoomId)
  local slotId = roomId % 100
  local routeId = self:getCurRouteId()
  local preSlotList = ed.getDataTable("RogueChapterRoute")[routeId][slotId]["Pre Slot"] or {}
  if self:getRoomIsPass(roomId) then
    return ed.rogueDefine.ROOM_STATE_LOCK
  end
  for _, preSlotId in ipairs(preSlotList) do
    local preRoomId = self:getRoomIdBySlotId(preSlotId)
    if self:getRoomIsShop(preRoomId) and preRoomId == curRoomId then
      return ed.rogueDefine.ROOM_STATE_UNLOCK
    end
  end
  if self:getRoomIsPass(curRoomId) and ed.isElementInTable(curSlotId, preSlotList) or curRoomId == roomId then
    return ed.rogueDefine.ROOM_STATE_UNLOCK
  end
  return ed.rogueDefine.ROOM_STATE_LOCK
end

function class:getChapterIsUnlock(chapterId, difficulty)
  difficulty = difficulty or 1
  if chapterId == 1 then
    return true
  elseif difficulty == 1 then
    if self:getChapterIsPass(1) then
      return true
    else
      return false, T("\233\128\154\229\133\179\230\150\176\230\137\139\230\157\145\229\144\142\232\167\163\233\148\129")
    end
  elseif self:getChapterIsPass(chapterId, 1) then
    return true
  else
    return false, T("\233\128\154\229\133\179\233\154\190\229\186\1661\229\144\142\232\167\163\233\148\129\229\133\182\228\187\150\233\154\190\229\186\166")
  end
  return false, T("\231\171\160\232\138\130\230\156\170\232\167\163\233\148\129")
end

function class:getChapterIsPass(chapterId, difficulty)
  difficulty = difficulty or 1
  for index, passChapter in ipairs(self.passChapter or {}) do
    local passChapterId = passChapter._chapter_id
    local passDiff = passChapter._difficulty or {}
    if chapterId == passChapterId and ed.isElementInTable(difficulty, passDiff) then
      return true
    end
  end
  return false
end

function class:getRoomIsShop(roomId)
  local roomInfo = self.roomData[self.curRoundId][roomId] or {}
  return ed.isElementInTable(roomInfo.type, {
    "buy_shop",
    "enhance_shop",
    "all_shop"
  })
end

function class:getShopDiscount()
  local curChapter = self:getCurChapter()
  local shopDiscount = curChapter._shop_discount or 100
  return shopDiscount / 100
end

function class:getRoomIsPass(roomId)
  local roomInfo = self.roomData[self.curRoundId][roomId] or {}
  local stageId = roomInfo.stageId
  local event = roomInfo.event
  local results = roomInfo.results
  if not self:getRoomIsChoose(roomId) then
    return false
  end
  local slotId = self:getSlotIdByRoomId(roomId)
  if slotId == 0 then
    return true
  end
  local routeId = self:getCurRouteId()
  local postSlot = ed.getDataTable("RogueChapterRoute")[routeId][slotId]["Post Slot"] or {}
  for _, postSlotId in ipairs(postSlot) do
    local postRoomId = self:getRoomIdBySlotId(postSlotId)
    local curChapter = self:getCurChapter() or {}
    if self:getRoomIsPass(postRoomId) or postRoomId == curChapter._cur_room_id then
      return true
    end
  end
  if self:getRoomIsShop(roomId) then
    return false
  end
  if stageId and 0 < stageId then
    local haveBattleEnd = false
    for _, rogueResult in ipairs(results or {}) do
      local resultType = rogueResult._type
      if resultType == "battle_end" then
        haveBattleEnd = true
      end
    end
    if not haveBattleEnd then
      return false
    end
  end
  if results and 0 < #results then
    for _, rogueResult in ipairs(results) do
      local resultType = rogueResult._type
      local needChoose = rogueResult._need_choose or 0
      local pos = rogueResult._pos or {}
      if resultType == "stage" then
        local haveBattleEnd = false
        for _, subRogueResult in ipairs(results or {}) do
          if subRogueResult._type == "battle_end" then
            haveBattleEnd = true
          end
        end
        if not haveBattleEnd then
          return false
        end
      elseif needChoose ~= 0 and needChoose > #pos then
        return false
      end
    end
  end
  if event then
    for index, rogueChoice in ipairs(event._choices) do
      local resultId = rogueChoice._result_id
      if not resultId or resultId == 0 then
        return false
      end
    end
  end
  return true
end

function class:getRoomIsChoose(roomId)
  local roomData = self:getRoomData(roomId)
  local pass = roomData.passed
  return pass == 1
end

function class:getCurMapIsEnd()
  local curChapter = self:getCurChapter()
  local routeId = self:getCurRouteId()
  for slotId, slotCfg in ipairs(ed.getDataTable("RogueChapterRoute")[routeId]) do
    if not slotCfg["Post Slot"] or #slotCfg["Post Slot"] == 0 then
      local curRoomId = curChapter._cur_room_id
      local curSlotId = self:getSlotIdByRoomId(curRoomId)
      if curSlotId == slotId and (self:getRoomIsPass(curRoomId) or self:getRoomIsShop(curRoomId)) then
        return true
      end
    end
  end
  return false
end

function class:getChapterIsEnd()
  local curChapter = self:getCurChapter()
  local curRoomId = curChapter._cur_room_id
  local roomData = self:getRoomData(curRoomId)
  local battleStatus = curChapter._battle_status
  if battleStatus == "finish" then
    return true
  end
  if roomData.type == "boss_battle" then
    return self:getRoomIsPass(curRoomId)
  end
  local endTime = curChapter._end_time
  if endTime - ed.getServerTime() <= 0 then
    return true
  end
  return false
end

function class:getBattleStatus()
  local curChapter = self:getCurChapter()
  return curChapter._battle_status
end

function class:getViewRevelation()
  return self.viewRevelation
end

function class:getViewBless()
  return self.viewBless or {}
end

function class:getBlessRewardFlag()
  return self.blessRewardFlag
end

function class:getBlessRewardFlagById(id)
  for index, idFlag in ipairs(self.blessRewardFlag or {}) do
    if id == idFlag then
      return true
    end
  end
  return false
end

function class:getViewEvent()
  return self.viewEvent
end

function class:getGoldenRewardFlagById(id)
  for index, idFlag in ipairs(self.goldenRewardFlag or {}) do
    if id == idFlag then
      return true
    end
  end
  return false
end

function class:getWeeklyPoint()
  return self.weeklyPoint
end

function class:getGoldenPoint()
  return self.goldenPoint or 0
end

function class:getBlessViewFlag(blessId)
  for index, viewBlessId in ipairs(self.viewBless) do
    if blessId == viewBlessId then
      return true
    end
  end
  return false
end

function class:getRevelationViewFlag(destinyId)
  for index, viewRevelationId in ipairs(self.viewRevelation or {}) do
    if destinyId == viewRevelationId then
      return true
    end
  end
  return false
end

function class:getEventRewardFlag(eventId)
  for index, viewEventData in ipairs(self.viewEvent) do
    if eventId == viewEventData._id then
      return viewEventData._flag
    end
  end
  return nil
end

function class:getDestinyEnergy()
  local curChapter = self:getCurChapter()
  local energy = curChapter._des_energy or 0
  return energy / 10000
end

function class:setDestinyEnergy(energy)
  local curChapter = self:getCurChapter()
  curChapter._des_energy = energy
  FireEvent("rogueUpdateDestinyEnergy")
end

function class:getDestinyId()
  local curChapter = self:getCurChapter() or {}
  return curChapter._destiny
end

function class:getRevelationEnable(destinyId)
  local rogueDestinyCfg = ed.getDataTable("RogueDestiny")[destinyId]
  local destinyBlessList = rogueDestinyCfg.DestinyBless
  local curChapter = self:getCurChapter() or {}
  local requireBlessAmount = 3
  local satisfyAmount = 0
  for index, rogueBless in ipairs(curChapter._bless_list or {}) do
    local blessId = rogueBless._bless
    if ed.isElementInTable(blessId, destinyBlessList) then
      satisfyAmount = satisfyAmount + 1
    end
  end
  if requireBlessAmount <= satisfyAmount then
    return true, satisfyAmount
  end
  return false, satisfyAmount
end

function class:checkRevelationUnlock()
  if self.revelationEnable then
    return
  end
  local curChapter = self:getCurChapter()
  if not curChapter then
    return
  end
  local destinyId = curChapter._destiny
  local revelationEnable = self:getRevelationEnable(destinyId)
  if revelationEnable then
    ed.UITool.openView("rogueRevelationUnlockWindow", {destinyId = destinyId})
    self.revelationEnable = true
  end
end

function class:getAllHeroInfo()
  local curChapter = self:getCurChapter() or {}
  return curChapter._heroes or {}
end

function class:getRogueHeroInfo(heroId)
  local curChapter = self:getCurChapter()
  for index, heroInfo in ipairs(curChapter._heroes) do
    if heroInfo._heroid == heroId then
      return heroInfo
    end
  end
  return nil
end

function class:getCanSweepRoom(roomType)
  local curChapter = self:getCurChapter()
  local techList = curChapter._tech_list or {}
  local techTreeId
  for chapterId, rogueChapterCfg in ipairs(ed.getDataTable("RogueChapter")) do
    if chapterId == curChapter._chapter_id then
      techTreeId = rogueChapterCfg[1]["Tech Tree ID"]
    end
  end
  if not techTreeId then
    return false
  end
  local techTreeCfg = ed.getDataTable("RogueTech")[techTreeId]
  for index, techId in ipairs(techList) do
    local techCfg = techTreeCfg[techId]
    local category = techCfg.Category
    if roomType == "normal_battle" and category == "normal_battle_sweep" then
      return true
    end
  end
  return false
end

function class:handleRoom(roomId)
  local roomData = self:getRoomData(roomId)
  local curChapter = self:getCurChapter()
  local battleStatus = curChapter._battle_status
  local type = roomData.type
  local stageId = roomData.stageId
  local event = roomData.event
  local goods = roomData.goods
  local results = roomData.results
  if curChapter._cur_room_id ~= roomId then
    return false
  end
  print("handleRoom:", roomData)
  print("battle_status:", battleStatus)
  local findIndex = 1
  if type == "round_start" then
    self:handleRogueResultList(results, findIndex)
  elseif ed.isElementInTable(type, {
    "normal_battle",
    "elite_battle",
    "boss_battle",
    "ex_elite_battle"
  }) then
    if stageId and 0 < stageId then
      if battleStatus == "defeat" then
        ed.UITool.openView("rogueBattleFail", {stageId = stageId, showEndFailTips = true})
        return true
      end
      local isBattleEnd = false
      if results then
        for i, v in ipairs(results) do
          if v._type == "battle_end" then
            isBattleEnd = true
            break
          end
        end
      end
      self:handleRogueResultList(results, findIndex, function(...)
        if not isBattleEnd then
          local canSweep = self:getCanSweepRoom(type)
          if canSweep then
            ed.rogueLikeNet.sendSkipBattle()
          else
            ed.UITool.openView("rogueBattlePrepare", {
              mode = "fight",
              stageId = stageId,
              destinyId = curChapter._destiny,
              chapterId = curChapter._chapter_id,
              difficulty = curChapter._difficulty
            })
          end
        end
      end)
    end
  elseif type == "event" then
    if event then
      self:handleRogueResultList(results, findIndex, function()
        self:handleEvent(event)
      end)
    end
  elseif ed.isElementInTable(type, {
    "buy_shop",
    "enhance_shop",
    "all_shop"
  }) then
    self:handleRogueResultList(results, findIndex, function()
      ed.UITool.openView("rogueEventBusiness", {
        roomId = roomId,
        type = type,
        goods = goods
      })
    end)
  elseif type == "airdrop" then
    if event then
      self:handleRogueResultList(results, findIndex, function()
        self:handleEvent(event)
      end)
    end
  elseif type == "hot_spring" and event then
    self:handleRogueResultList(results, findIndex, function()
      self:handleEvent(event)
    end)
  end
  return true
end

function class:handleEvent(event)
  if not event then
    return
  end
  local handleChoiceIndex
  for index, rogueChoice in ipairs(event._choices or {}) do
    local resultId = rogueChoice._result_id
    if not resultId or resultId == 0 then
      handleChoiceIndex = index
      break
    end
  end
  if handleChoiceIndex then
    ed.UITool.openView("rogueEventScene", {event = event, choiceIndex = handleChoiceIndex})
  end
end

function class:handleRogueCallBackList()
  if #self.finishCallBackList == 0 then
    return
  end
  local callBack = table.remove(self.finishCallBackList, 1)
  local result = callBack()
  self:handleRogueCallBackList()
end

function class:handleRogueResultList(rogueResultList, startIndex, finishCallBack)
  if not rogueResultList or #rogueResultList == 0 then
    if finishCallBack then
      finishCallBack()
    end
    return
  end
  table.insert(self.finishCallBackList, finishCallBack)
  self.handleResultIndex = startIndex or 1
  self.curHandleRogueResultList = rogueResultList
  self:handleRogueResult()
end

function class:continueHandleRogueResult()
  local rogueResult = self.curHandleRogueResultList[self.handleResultIndex]
  if rogueResult then
    local index = rogueResult._index
    local isView = self:getCurRoomViewRogueResult(index)
    if not isView then
      self:saveCurRoomViewRogueResult(index)
    end
  end
  self.handleResultIndex = self.handleResultIndex + 1
  return self:handleRogueResult()
end

function class:saveViewRogueResult(roundId, roomId, index)
  print("saveViewRogueResult:", roundId, roomId, index)
  ed.rogueLikeNet.sendRogueViewResult(roundId, roomId, {index})
  if self.viewRogueResultData[roundId] then
    if self.viewRogueResultData[roundId][roomId] then
      table.insert(self.viewRogueResultData[roundId][roomId], index)
    else
      self.viewRogueResultData[roundId][roomId] = {index}
    end
  else
    self.viewRogueResultData[roundId] = {}
    self.viewRogueResultData[roundId][roomId] = {index}
  end
end

function class:getViewRogueResult(roundId, roomId, index)
  local roomViewResult = self.viewRogueResultData[roundId] or {}
  local viewIndexList = roomViewResult[roomId] or {}
  return ed.isElementInTable(index, viewIndexList)
end

function class:saveCurRoomViewRogueResult(index)
  local curChapter = self:getCurChapter()
  local curRoundId = curChapter._cur_round_id
  local curRoomId = curChapter._cur_room_id
  self:saveViewRogueResult(curRoundId, curRoomId, index)
end

function class:getCurRoomViewRogueResult(index)
  local curChapter = self:getCurChapter()
  local curRoundId = curChapter._cur_round_id
  local curRoomId = curChapter._cur_room_id
  return self:getViewRogueResult(curRoundId, curRoomId, index)
end

function class:getScriptRewardData(scriptId)
  return self.scriptData[scriptId] or {}
end

function class:getScript()
  return self.scriptData
end

function class:handleRogueResult()
  if self.handleResultIndex > #self.curHandleRogueResultList then
    FireEvent("rogueHandleResultFinish")
    self:handleRogueCallBackList()
    return
  end
  local rogueResult = self.curHandleRogueResultList[self.handleResultIndex]
  local type = rogueResult._type
  local index = rogueResult._index
  local isView = self:getCurRoomViewRogueResult(index)
  print("handleRogueResult:", type, index, isView, rogueResult)
  local handleFunction = self.rogueLikeResultHandle:getHandleFunc(type)
  if isView then
    self:continueHandleRogueResult()
  elseif handleFunction then
    FireEvent("rogueHandleResultStart", rogueResult)
    local handleResult = handleFunction(self, rogueResult)
    if handleResult == "success" then
      ed.rogueToast.getInstance():checkAddRogueResultTips(rogueResult)
      FireEvent("rogueHandleResultSuccess", rogueResult)
      self:continueHandleRogueResult()
    end
  else
    self:continueHandleRogueResult()
  end
end

function class:sendRogueChooseReward(posList)
  local rogueResult = self.curHandleRogueResultList[self.handleResultIndex]
  if not rogueResult then
    return
  end
  local index = rogueResult._index
  ed.rogueLikeNet.sendChooseReward(index, posList)
end

function class:sendRogueRefreshBless()
  local rogueResult = self.curHandleRogueResultList[self.handleResultIndex]
  if not rogueResult then
    return
  end
  local index = rogueResult._index
  ed.rogueLikeNet.sendRefreshBless(index)
end

function class:initRogueResultHandle()
  self.rogueLikeResultHandle = ed.rogueLikeResultHandle.create(self)
end

function class:initRogueEventChoiceHandle()
  self.rogueEventChoiceEnableHandle = ed.rogueEventChoiceEnableHandle.create(self)
end

function class:getRogueEventChoiceEnable(rewardType, param)
  local handle = self.rogueEventChoiceEnableHandle:getHandleFunc(rewardType)
  if handle then
    local enable, tips = handle(self, param)
    tips = tips or T("\228\184\141\231\172\166\229\144\136\233\128\137\230\139\169\230\157\161\228\187\182")
    return enable, tips
  end
  return true
end

function class:getCharmStarNum(exp, tableItem)
  local levelArr = tableItem["Level Up Require"] or {}
  local index = 0
  for i = #levelArr, 1, -1 do
    if exp >= levelArr[i] then
      index = i
      break
    end
  end
  local starNum = index + 1
  local lastRquire = 0 == index and 0 or levelArr[index + 1]
  local nextRequire = #levelArr == index and 0 or levelArr[index + 1]
  return starNum, lastRquire, nextRequire
end

function class:getCharmIdListFromBag(bookId)
  if nil == self.charmIdListInBags then
    self.charmIdListInBags = {}
  end
  local list = self.charmIdListInBags[bookId]
  if nil == list then
    list = {}
    local key = ed.getRoleKey("charm_list_inbags_" .. bookId)
    local str = ed.storage.getString(key) or ""
    for s in string.gfind(str, "%d+,") do
      local id = string.gsub(s, ",", "")
      table.insert(list, tonumber(id))
    end
    self.charmIdListInBags[bookId] = list
  end
  return list
end

function class:saveCharmIdListToBag(bookId, list)
  if nil == self.charmIdListInBags then
    self.charmIdListInBags = {}
  end
  self.charmIdListInBags[bookId] = list
  local str = ""
  for i = 1, #(list or {}) do
    str = str .. list[i] .. ","
  end
  local key = ed.getRoleKey("charm_list_inbags_" .. bookId)
  ed.storage.setValue(key, str)
end
