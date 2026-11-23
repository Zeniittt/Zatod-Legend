ed.SoloTestMode = false
local class = {}
class.__index = class

function class.getInstance()
  local object = {}
  setmetatable(object, class)
  object:initData()
  object:initGameData()
  return object
end

class.GAMESTAGE = {
  START = 1,
  PREPARE = 2,
  LOCK = 3,
  BATTLE = 4,
  WAITTING = 5,
  OVER = 6,
  CHOOSE = 7,
  WAIT = 8
}
class.PLAYER_NUM = 4

function class:initData()
  self.stage = 0
  self.loadingData = {}
  self.joinGame = false
  self.startCheck = false
  self.gameId = 0
  self.gameAddr = ""
  self.openTypes = {}
  self.guideFlag = 0
  self.isReconnect = false
  self.actOpen = true
  self.teamMembers = {}
  self.teamLeader = nil
  self.teamStatus = {}
  self.lastHeroId = 69
  self.isGameing = false
end

function class:enterStage(stage)
  self.stage = stage
end

function class:isPrepareStage()
  return self.stage == self.GAMESTAGE.PREPARE
end

function class:getStage()
  return self.stage
end

function class:setArenaMode(mode)
  self.arenaMode = mode or "casual"
end

function class:getArenaMode()
  return self.arenaMode or "casual"
end

function class:initGameData()
  self.gameType = 0
  self.btStartTime = 0
  self._logcheckId = 0
  self._loggameId = 0
  self._loground = 0
  self._logIndex = 0
end

function class:setJoinGame(isJoin)
  self.joinGame = isJoin
end

function class:setMatching(isMatching)
  self.isMatching = isMatching
end

function class:getMatching()
  return self.isMatching
end

function class:getGameId()
  return self.gameId
end

function class:getGameAddr()
  return self.gameAddr
end

function class:isReconnectMode()
  return self.isReconnect
end

function class:isJoinGame()
  return self.joinGame
end

function class:updataLoadingData(data)
  for _, user in ipairs(data) do
    local userKey = user._user_key
    local keyStr = userKey._server_id .. "_" .. userKey._user_id
    local userData = self.loadingData[keyStr]
    if not userData then
      self.loadingData[userKey._server_id .. "_" .. userKey._user_id] = {progress = 0, isFinish = false}
    end
    self.loadingData[keyStr].progress = user._progress
    self.loadingData[keyStr].isFinish = user._is_finish
  end
end

function class:getLoadingDataByUser(key)
  return self.loadingData[key] or {progress = 0, isFinish = false}
end

function class:getLoadingData()
  return self.loadingData
end

function class:setGameType(gameType)
  self.gameType = gameType
end

function class:getGameType()
  return self.gameType
end

function class:isChessModeOpen(gameType)
  return ed.isElementInTable(gameType, self.openTypes)
end

function class:setIsOpen(isOpen)
  self.actOpen = isOpen
end

function class:isChessOpen()
  return self.actOpen
end

function class:setScore(score)
  self.score = score
end

function class:getScore()
  return self.score
end

function class:setBtStartTime()
  self.btStartTime = ed.getServerTime()
end

function class:getBtStartTime()
  return self.btStartTime
end

function class:clearGameData()
  self:initData()
  self:initGameData()
  ed.SoloModel:clearData()
end

function class:handlerOpenPanel(data)
  self:clearGameData()
  self:clearTeamData()
  self.gameId = data._cur_game_id or 0
  self.gameAddr = data._cur_game_addr or ""
  local gameState = data._game_status
  self.openTypes = data._open_types or {}
  self.score = data._score
  self.guideFlag = data._is_rookie
  self.isReconnect = false
  self.joinGame = false
  if data._last_hero_id and data._last_hero_id ~= 0 then
    self.lastHeroId = data._last_hero_id
  end
  self.isShowEnd = false
  self.gradeRewardFlags = data._grade_reward_flags or {}
  if gameState == "gaming" then
    ed.showConfirmDialog({
      text = T("\230\173\163\229\156\168\230\184\184\230\136\143\228\184\173\239\188\140\230\152\175\229\144\166\233\135\141\230\150\176\232\191\158\230\142\165\239\188\159"),
      leftHandler = function()
      end,
      rightHandler = function()
        self.isReconnect = true
        local ip, port, svrid = ed.getIPPortFromString(self.gameAddr)
        print("--------Skill Solo---reconnect--.." .. ip .. "_" .. port .. "_" .. (svrid or "svrid") .. "_" .. self:getGameId())
        ed.SoloNetwork:doGameConnect(ip, port, svrid)
      end
    })
  elseif gameState == "free" then
    ed.pushScene(ed.ui.SoloArenaScene.create())
    local isTeamMode, teamId = self:getTeamInfo()
    if isTeamMode and teamId and 0 < teamId then
      ed.SoloNetwork:sendTeamQuery(teamId)
    end
  elseif gameState == "game_over" then
    local gameNotify = data._game_over_notify
    if type(gameNotify) == "table" then
      ed.replaceScene(ed.ui.SoloArenaScene.create())
    else
      ed.showToast(T("\230\149\176\230\141\174\229\188\130\229\184\184"))
    end
  end
end

function class:setGradeRewardFlags(grade)
  self.gradeRewardFlags = self.gradeRewardFlags or {}
  table.insert(self.gradeRewardFlags, grade)
  FireEvent("refreshGradeRewardFlags", grade)
end

function class:handlerMatchStart(data)
  FireEvent("SoloMatchStart", data)
end

function class:handlerMatchCancel()
  FireEvent("SoloMatchCancel")
end

function class:handlerMatchTimoutNotify()
  self:setJoinGame(false)
  ed.SoloNetwork:doGameDisConnect()
  FireEvent("SkillMatchTimoutNotify")
end

function class:handlerJoinTimoutNotify()
  self:setJoinGame(false)
  ed.showToast(T("\229\133\182\228\187\150\231\142\169\229\174\182\229\183\178\231\166\187\229\188\128"))
  ed.SoloNetwork:doGameDisConnect()
  FireEvent("SkillJoinTimoutNotify")
end

function class:handlerJoinGame(data)
  if self:isJoinGame() then
    return
  end
  self:initGameData()
  ed.SoloModel:clearData()
  local summary = data._summary
  local gameType = summary._game_type
  if gameType == "robot" then
    for _, v in pairs(summary._users) do
      v._user_summary._name = T(v._user_summary._name)
    end
  end
  if summary then
    local users = summary._users
    ed.SoloModel:setPlayerList(users)
  end
  self.isGameing = true
  local rule = summary._rules
  ed.SoloModel:setTeamMaxHp(rule._max_hp)
  ed.SoloModel:setFactions(rule._active_factions)
  ed.SoloModel:setFrozonFactions(rule._frozen_factions)
  self:setGameType(gameType)
  ed.showToast(T("\231\173\137\229\190\133\229\133\182\228\187\150\231\142\169\229\174\182\232\191\155\229\133\165..."))
  if ed.SoloManager:isReconnectMode() and not self:isJoinGame() then
    ed.pushScene(ed.ui.SoloLoadScene.create())
    self.isReconnect = false
  end
  self:setJoinGame(true)
end

function class:handlerReconnectGame()
end

function class:setUserShop(shopData)
  ed.SoloModel:setupShopCardList(shopData._cards)
  if shopData._refresh_cost then
    ed.SoloModel:setupRefreshCost(shopData._refresh_cost)
  end
  if shopData._random_cost then
    ed.SoloModel:setupRandomCost(shopData._random_cost)
  end
  FireEvent("SkillShopDataRefresh")
end

function class:handlerShopRefresh(data)
  ed.SoloModel:setTotalGold(data._gold)
  self:setUserShop(data._shop)
end

function class:handlerStartNotify(data)
  self.joinGame = false
  self.gameId = data._game_id
  self.gameAddr = data._game_addr
  if self.gameId ~= 0 then
    local ip, port, svrid = ed.getIPPortFromString(self.gameAddr)
    print("--------Solo---game-start-----conncting.." .. ip .. "_" .. port .. "_" .. (svrid or "svrid") .. "_" .. self:getGameId())
    ed.SoloNetwork:doGameConnect(ip, port, svrid)
  end
  FireEvent("SoloGameStart")
end

function class:handlerLoadNotify(data)
  local loadData = data._users
  self:updataLoadingData(loadData)
  FireEvent("SoloLoadNotify")
end

function class:handlerWaitChooseNotify(data)
  self:enterStage(self.GAMESTAGE.CHOOSE)
  ed.SoloModel:setWaitChooseTime(data._end_time)
  FireEvent("SoloWaitChoose")
end

function class:handlerRoundNotify(data)
  if data._round_num then
    ed.SoloModel:setBattleRound(data._round_num)
  end
  if data._round_start then
    self:enterStage(self.GAMESTAGE.START)
    ed.SoloModel:clearBattleEvents()
    local roundData = data._round_start
    local selfDetail = roundData._self_detail
    local income = roundData._income or {}
    local userKey = ed.SkillPlayer.getMyUserKey()
    ed.SoloModel:updateTotalHp(userKey, selfDetail._max_hp)
    ed.SoloModel:updatePlayerHp(userKey, selfDetail._hp)
    ed.SoloModel:setMySelfDead(selfDetail._is_dead == 1)
    ed.SoloModel:setTotalGold(selfDetail._gold)
    ed.SoloModel:setGainGold({
      gainBase = income._gold_base or 0,
      gainInst = income._gold_inst or 0,
      comboV = income._gold_combo_v or 0,
      comboD = income._gold_defeat or 0
    })
    ed.SoloModel:updatePlayerLevel(userKey, selfDetail._level)
    ed.SoloModel:setBattleTeam(selfDetail._team)
    ed.SoloModel:updateBattleGroup(userKey, nil)
    local oppoDatas = roundData._oppos or {}
    for _, oppoData in ipairs(oppoDatas) do
      ed.SoloModel:updateOppoUser(oppoData)
    end
    ed.SoloModel:sortPlayerList()
    ed.SoloModel:setCombo(selfDetail._combo or 0)
    if selfDetail._powers then
      ed.SoloModel:updatePlayerPowers(userKey, selfDetail._powers)
    end
    ed.SoloModel:updatePlayerDamage(userKey, selfDetail._damage)
    local team = selfDetail._team
    if team and team._hero then
      ed.SoloModel:updatePlayerHeroId(userKey, team._hero._hid)
      FireEvent("SoloUpdatePlayerIcon", ed.SkillPlayer.getMyUserKey())
    end
    if ed.SoloModel:isMySelfDead() and not self.isShowEnd then
      FireEvent("SoloPlayerDead")
      self.isShowEnd = true
    end
    FireEvent("SoloRoundStart")
  elseif data._round_wait then
    self:enterStage(self.GAMESTAGE.WAIT)
    local roundData = data._round_wait
    ed.SoloModel:setWaitEndTime(roundData._end_time)
    FireEvent("SoloRoundWait")
  elseif data._round_prepare then
    self:enterStage(self.GAMESTAGE.PREPARE)
    local roundData = data._round_prepare
    ed.SoloModel:setPrepareEndTime(roundData._end_time)
    ed.SoloModel:setOppoType(roundData._oppo_type)
    self:setUserShop(roundData._user_shop)
    FireEvent("SoloRoundPrepare")
  elseif data._round_lock then
    self:enterStage(self.GAMESTAGE.LOCK)
    FireEvent("SoloRoundLock")
  elseif data._round_battle then
    self:enterStage(self.GAMESTAGE.BATTLE)
    local roundData = data._round_battle
    ed.SoloModel:setBattleEvents(roundData._events)
    ed.SoloModel:updateBattleGroup(ed.SkillPlayer.getMyUserKey(), roundData._group)
    for _, oppoData in ipairs(roundData._oppos or {}) do
      ed.SoloModel:updateOppoUser(oppoData)
    end
    ed.SoloModel:sortPlayerList()
    local recordDatas = roundData._records
    self.recordDatas = recordDatas
    if not recordDatas or not recordDatas[roundData._group] then
      return
    end
    self._logcheckId = recordDatas[roundData._group]._checkid or 0
    self._loggameId = recordDatas[roundData._group]._gameid or 0
    self._loground = recordDatas[roundData._group]._round or 0
    self._logIndex = (recordDatas[roundData._group]._battle or {})._index
    FireEvent("SoloRoundBattle")
  elseif data._round_over then
    self:enterStage(self.GAMESTAGE.OVER)
    local roundData = data._round_over
    ed.SoloModel:setOverEndTime(roundData._end_time or 0)
    ed.SoloModel:setTotalGold(roundData._gold)
    local userKey = ed.SkillPlayer.getMyUserKey()
    ed.SoloModel:updatePlayerHp(userKey, roundData._hp)
    ed.SoloModel:updateTotalHp(userKey, roundData._max_hp)
    FireEvent("SoloRoundOver")
  end
end

function class:handlerStatusNotify(data)
end

function class:handlerRankNotify(data)
  ed.ui.SoloRankPop.create(data._rank or 1)
  if data._rank == 1 then
    FireEvent("SoloPlay1stAnim")
  end
end

function class:handlerSettleNotify(data)
  FireEvent("SoloOverNotify")
  ed.SoloManager:setScore(data._new_score or 0)
  ed.pushScene(ed.ui.SoloArenaScene.create())
  ed.ui.SoloResultWin.create(data)
end

function class:handlerEventNotify(data)
  local events = data._events or {}
  for k, event in pairs(events) do
    if event._over then
      local eventData = event._over
      local myUserKey = ed.SkillPlayer.getMyUserKey()
      if not ed.SkillPlayer.isUserKeyEqual(myUserKey, eventData._user_key) then
        local isHurt, diffHp = ed.SoloModel:checkPlayerHurt(eventData._user_key, eventData._hp)
        ed.SoloModel:updatePlayerHp(eventData._user_key, eventData._hp or 0)
        FireEvent("SoloBattleOver", eventData._user_key, isHurt, diffHp)
      end
    end
  end
  local actions = data._actions or {}
  for k, action in pairs(actions) do
    if action._choose_power then
      local data = action._choose_power
      if data._power then
        ed.SoloModel:updatePlayerPower(data._user_key, data._power, data._power._pos)
        FireEvent("SoloSelectPowerNotify", data)
      end
    elseif action._emoji then
      FireEvent("SoloChatContentNotify", action._emoji)
    elseif action._choose_hero then
      local userKey = action._choose_hero._user_key
      local hid = action._choose_hero._hero_id
      ed.SoloModel:updatePlayerHeroId(userKey, hid)
      FireEvent("SoloUpdatePlayerIcon", userKey)
    end
  end
  local effects = data._effects or {}
  for k, event in pairs(effects) do
    local userKey = event._user_key
    self:applyEffect(userKey, event._effects)
  end
end

function class:handlerLevelNotify(msg)
  ed.SoloModel:updatePlayerLevel(msg._user_key, msg._level)
end

function class:handlerActionNotify(msg)
  for k, action in ipairs(msg._actions or {}) do
    self:handlerAction(action)
  end
end

function class:handlerEffectNotify(msg)
  local userKey = ed.SkillPlayer.getMyUserKey()
  if msg._effects then
    self:applyEffect(userKey, msg._effects)
  end
end

function class:handlerBattleEvent(events)
  for k, event in pairs(events) do
    local type = event.type
    local content = event.event
    if type == 1 then
      ed.SoloModel:updatePlayerHp(content._user_key, content._hp or 0)
      ed.SoloModel:updatePlayerLevel(content._user_key, content._level or 0)
      ed.SoloModel:updatePlayerTeam(content._user_key, content._team)
      FireEvent("ChessSkillBattleStart", content._user_key)
    elseif type == 2 then
      local isHurt, diffHp = ed.SoloModel:checkPlayerHurt(content._user_key, content._hp)
      ed.SoloModel:updatePlayerHp(content._user_key, content._hp or 0)
      FireEvent("SoloBattleOver", content._user_key, isHurt, diffHp, content._battle_result)
      FireEvent("SoloBattleOverForMarquee", content._user_key, content._oppo_type, content._oppo_key, content._battle_result)
    elseif type == 3 then
      FireEvent("ChessSkillBattleComboVictory", content._user_key, content._combo)
    elseif type == 4 then
      FireEvent("ChessSkillBattleBlockVictory", content._user_key, content._oppo_key, content._combo)
    end
  end
end

function class:handlerBattleConfirmNet(data)
  local gold = data._gain_gold or 0
  ed.SoloModel:setWinGold(gold)
  ed.SoloModel:setTotalGold(ed.SoloModel:getTotalGold() + gold)
  ed.SoloModel:setBattleResult(data._battle_result)
  self:handlerLogSave(data._confirm_result)
  local userKey = ed.SkillPlayer.getMyUserKey()
  local isHurt, diffHp = ed.SoloModel:checkPlayerHurt(userKey, data._hp)
  ed.SoloModel:updatePlayerHp(userKey, data._hp or 0)
  FireEvent("SoloBattleOver", userKey, isHurt, diffHp)
  FireEvent("SoloRoundResult")
end

function class:applyEffect(userKey, effects)
  for k, effect in ipairs(effects) do
    local power = effect._power
    if effect._mod_hp then
      local data = effect._mod_hp
      ed.SoloModel:updatePlayerHp(userKey, data._mod_hp, true)
      ed.SoloModel:updateTotalHp(userKey, data._max_hp)
      FireEvent("EffectUpdatePlayerHP", userKey, data, power)
    end
    if effect._gain_gold and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      local data = effect._gain_gold
      ed.SoloModel:setTotalGold(ed.SoloModel:getTotalGold() + data._gold)
      FireEvent("EffectUpdatePlayerGold", data._gold, power)
    end
    if effect._user_shop and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      self:setUserShop(effect._user_shop._shop)
    end
    if effect._gain_cards and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      local data = effect._gain_cards
      for k, card in ipairs(data._cards or {}) do
        ed.SoloModel:addCard(card)
        FireEvent("EffectGainCard", card, power)
      end
      ed.SoloModel:updatePlayerLevel(userKey, data._level)
      for k, faction in ipairs(data._factions or {}) do
        ed.SoloModel:updateFaction(faction)
      end
    end
    if effect._gain_faction_exp and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      local data = effect._gain_faction_exp
      ed.SoloModel:updatePlayerLevel(userKey, data._level)
      for k, faction in ipairs(data._factions or {}) do
        ed.SoloModel:updateFaction(faction)
      end
      FireEvent("EffectUpdateFactionExp", data._faction, data._exp, power)
    end
    if effect._cost_gold and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      local data = effect._cost_gold
      local gold = ed.SoloModel:getTotalGold() - data._gold
      ed.SoloModel:setTotalGold(gold)
      FireEvent("EffectUpdatePlayerGold", data._gold * -1, power)
    end
    if effect._new_power and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      local data = effect._power
      ed.SoloModel:updatePlayerPower(userKey, data, data._pos)
      FireEvent("SkillUpdateSelfPower", data)
    end
    if effect._user_damage then
      local data = effect._user_damage
      ed.SoloModel:updatePlayerDamage(userKey, data._damage)
      FireEvent("SoloPlayerUpdate")
    end
    if effect._power and self:isMemberEqual(ed.SkillPlayer.getMyUserKey(), userKey) then
      local data = effect._power
      ed.SoloModel:updatePlayerPower(userKey, data, data._pos)
      FireEvent("SkillUpdateSelfPower", data)
    end
  end
end

function class:handlerChoosePower(msg)
  if msg._is_confirmed == 1 then
    FireEvent("SoloChoosePower", msg._power)
  end
end

function class:handlerChooseHero(msg)
  if msg._is_confirmed == 1 then
  end
end

function class:handlerUsePower(msg)
end

function class:handlerBuyCard(msg)
  ed.SoloModel:updatePlayerLevel(ed.SkillPlayer.getMyUserKey(), msg._level)
  for k, v in ipairs(msg._factions or {}) do
    ed.SoloModel:updateFaction(v)
  end
  ed.SoloModel:addCard(msg._card)
  FireEvent("SoloBuyCard", msg._card)
  ed.SoloModel:setTotalGold(msg._gold)
end

function class:handlerAction(action)
  self.actionData = action
  if action._choose_power then
    ed.player:setEquipAmount(20688, action._choose_power._pay_coin_num)
    FireEvent("SoloPopChoosePower", action._choose_power)
  elseif action._choose_hero then
    ed.player:setEquipAmount(20688, action._choose_hero._pay_coin_num)
    FireEvent("SoloPopChooseHero", action._choose_hero)
  end
end

function class:handlerRefreshChoice(msg)
  self:handlerAction(msg._action)
end

function class:handlerMonitorPlayer(msg)
  FireEvent("SoloMonitorPlayer", msg)
end

function class:handlerSpectateEnter(msg)
  ed.SoloManager.specMode = true
  ed.SoloManager.specModeUserKey = msg._user_key
  FireEvent("SoloSpectateEnter", msg)
end

function class:handlerViewJournal(msg)
  if msg._journals then
    local logs = ed.SoloModel.logs
    for k, v in ipairs(msg._journals) do
      local round = v._round
      local log = {
        {},
        {}
      }
      local step = 1
      for _, entry in ipairs(v._entries) do
        if entry._battle then
          step = 2
        end
        table.insert(log[step], entry)
      end
      logs[round] = log
    end
  end
  FireEvent("SoloViewJournal")
end

function class:handlerViewDashboard(msg)
  local dashboard = msg._dashboard
  FireEvent("SoloViewDashboard", dashboard._users)
end

function class:handlerLogSave(confirm)
  if confirm == "conflict" then
    ed.engine:saveBattleLog("solo_" .. self._loggameId .. "_" .. self._loground .. "_" .. self._logIndex)
    ed.reportBattleLog(self._logcheckId, "solo_" .. self._loggameId .. "_" .. self._loground .. "_" .. self._logIndex)
  end
end

function class:setTeamMembers(members)
  self.teamMembers = {}
  members = members or {}
  for i, member in ipairs(members) do
    table.insert(self.teamMembers, member)
  end
end

function class:isMemberEqual(keyA, keyB)
  return keyA._user_id == keyB._user_id and keyA._server_id == keyB._server_id
end

function class:updateTeamMember(member, opcode)
  if member then
    if opcode == "kick" then
      for i, player in ipairs(self.teamMembers) do
        if self:isMemberEqual(player._user_key, member) then
          table.remove(self.teamMembers, i)
          break
        end
      end
    elseif opcode == "join" then
      table.insert(self.teamMembers, member)
    end
  end
end

function class:updateTeamLeader(newLeader)
  self.teamLeader = newLeader
end

function class:getTeamLeader()
  return self.teamLeader
end

function class:getTeamMembers()
  return self.teamMembers
end

function class:clearTeamData()
  self.teamMembers = {}
  self.teamLeader = nil
end

function class:setTeamInfo(isTeamMode, teamId)
  self.teamMode = isTeamMode
  self.teamId = teamId
end

function class:getTeamInfo()
  return self.teamMode, self.teamId
end

function class:setTeamId(teamId)
  self.teamId = teamId
end

function class:setTeamMemberStatus(uid, sid, status)
  for _, member in ipairs(self.teamMembers) do
    local userKey = member._user_key
    if userKey._user_id == uid and userKey._server_id == sid then
      member._status = status
    end
  end
end

function class:updateTeamMemberStatus(memberKeys, status)
  for _, memberKey in ipairs(memberKeys) do
    local uid = memberKey._user_id
    local sid = memberKey._server_id
    self:setTeamMemberStatus(uid, sid, status)
  end
end

ed.SoloManager = class.getInstance()
