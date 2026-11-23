local class = {}
class.__index = class
ed.AutoChessDefine = {
  ColorParam = {
    color_1 = ed.toccc3(16776423),
    color_2 = ed.toccc3(9303158),
    color_3 = ed.toccc3(6797817),
    color_4 = ed.toccc3(15570943),
    color_5 = ed.toccc3(16700269)
  },
  ColorStrokeParam = {
    color_1 = ed.toccc3(2565412),
    color_2 = ed.toccc3(1912351),
    color_3 = ed.toccc3(1449265),
    color_4 = ed.toccc3(3873091),
    color_5 = ed.toccc3(3744789)
  },
  BaseParam = {
    base_1 = "UI/alpha/1080P/chess/battle/base_1.png",
    base_2 = "UI/alpha/1080P/chess/battle/base_2.png",
    base_3 = "UI/alpha/1080P/chess/battle/base_3.png",
    base_4 = "UI/alpha/1080P/chess/battle/base_4.png",
    base_5 = "UI/alpha/1080P/chess/battle/base_5.png"
  },
  LightParam = {
    light_1 = "UI/alpha/1080P/chess/battle/base_light_1.png",
    light_2 = "UI/alpha/1080P/chess/battle/base_light_2.png",
    light_3 = "UI/alpha/1080P/chess/battle/base_light_3.png",
    light_4 = "UI/alpha/1080P/chess/battle/base_light_4.png",
    light_5 = "UI/alpha/1080P/chess/battle/base_light_5.png"
  }
}

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
  OVER = 6
}
class.PLAYER_NUM = 4

function class:initData()
  self.countDown = 0
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
  self.refreshCost = 1
  self.teamMembers = {}
  self.teamLeader = nil
  self.teamStatus = {}
end

function class:enterStage(stage)
  self.stage = stage
end

function class:isPrepareStage()
  return self.stage == self.GAMESTAGE.PREPARE
end

function class:getChessStage()
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

function class:setCountDown(countDown)
  self.countDown = countDown
end

function class:getCountDown()
  return self.countDown
end

function class:isReconnectMode()
  return self.isReconnect
end

function class:isJoinGame()
  return self.joinGame
end

function class:setJoinGame(isJoin)
  self.joinGame = isJoin
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

function class:startBattleEndCheck()
  self.startCheck = true
end

function class:stopBattleEndCheck()
  self.startCheck = false
end

function class:getBattleEndCheck()
  return self.startCheck
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
  ed.AutoChessModel:clearData()
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
  if gameState == "gaming" then
    self.isReconnect = true
    ed.showConfirmDialog({
      text = T("\230\173\163\229\156\168\230\184\184\230\136\143\228\184\173\239\188\140\230\152\175\229\144\166\233\135\141\230\150\176\232\191\158\230\142\165\239\188\159"),
      leftHandler = function()
      end,
      rightHandler = function()
        local ip, port, svrid = ed.getIPPortFromString(self.gameAddr)
        print("--------AUTO CHESS---reconnect--.." .. ip .. "_" .. port .. "_" .. (svrid or "svrid") .. "_" .. self:getGameId())
        ed.AutoChessNetwork:doGameConnect(ip, port, svrid)
      end
    })
  elseif gameState == "free" then
    ReloadModule("ui_new/modules/autoChess/AutoChessModuleList")
    ed.pushScene(ed.ui.AutoChessArenaScene.create())
    local isTeamMode, teamId = self:getChessTeamInfo()
    if isTeamMode and teamId and 0 < teamId then
      ed.AutoChessNetwork:sendTeamQuery(teamId)
    end
  elseif gameState == "game_over" then
    local gameNotify = data._game_over_notify
    if type(gameNotify) == "table" then
      ed.pushScene(ed.ui.AutoChessResultScene.create(gameNotify._stats or {}))
    else
      ed.showToast(T("\230\149\176\230\141\174\229\188\130\229\184\184"))
    end
  end
end

function class:handlerMatchStart(data)
  FireEvent("EventChessMatchStart", data)
end

function class:handlerMatchCancel()
  FireEvent("EventChessMatchCancel")
end

function class:handlerMatchTimoutNotify()
  self:setJoinGame(false)
  ed.AutoChessNetwork:doGameDisConnect()
  FireEvent("EventMatchTimoutNotify")
end

function class:handlerJoinTimoutNotify()
  self:setJoinGame(false)
  ed.AutoChessNetwork:doGameDisConnect()
  FireEvent("EventJoinTimoutNotify")
end

function class:handlerJoinGame(data)
  self:initGameData()
  ed.AutoChessModel:clearData()
  local summary = data._summary
  local gameType = summary._game_type
  if gameType == "robot" then
    for _, v in pairs(summary._users) do
      v._user_summary._name = T(v._user_summary._name)
    end
  end
  ed.AutoChessModel:setTeamMaxHp(summary._max_hp or 50)
  if summary then
    local users = summary._users
    ed.AutoChessModel:setPlayerList(users)
  end
  self:setGameType(gameType)
  if ed.AutoChessManager:isReconnectMode() and not self.joinGame then
    ed.replaceScene(ed.ui.AutoChessLoadScene.create())
  else
    if ed.AutoChessTeachManager:isGuideFlag() then
      return
    end
    FireEvent("EventChessJoinReply")
  end
  self:setJoinGame(true)
end

function class:handlerReconnectGame()
end

function class:handlerBuyHero(data)
  local chess_hero = data._hero
  local gold = data._gold
  local buyHero = ed.ChessHero.create(chess_hero)
  ed.AutoChessModel:setTotalGold(gold)
  ed.AutoChessModel:updateShopHeroState(chess_hero._insid, true)
  local isSuccess, chessHero, slot = ed.AutoChessModel:updateTotalHero("new", buyHero)
  if isSuccess and chessHero then
    FireEvent("EventBuyChessHeroSuccess", chessHero, slot)
  end
  self:handlerComposeHero(data)
end

function class:handlerSellHero(data)
  local heroSid = data._hero_insid
  local gold = data._gold
  local chess_pet = data._pet
  ed.AutoChessModel:updateTotalHero("delete", heroSid)
  local diffGold = gold - ed.AutoChessModel:getTotalGold()
  ed.AutoChessModel:setTotalGold(gold)
  if chess_pet then
    ed.AutoChessModel:updateDropPetData(chess_pet._insid, "off")
  end
  FireEvent("EventChessSellHero", heroSid, diffGold)
end

function class:handlerComposeHero(data)
  local compose_rcds = data._compose_rcds or {}
  for _, compose in ipairs(compose_rcds) do
    local hero_insids = compose._hero_insids or {}
    local target_hero = compose._hero
    local chess_pets = compose._pets or {}
    for i, insid in ipairs(hero_insids) do
      if insid ~= target_hero._insid then
        ed.AutoChessModel:updateTotalHero("delete", insid)
      end
    end
    for _, pet in ipairs(chess_pets) do
      ed.AutoChessModel:updateDropPetData(pet._insid, "off")
    end
    local insid = target_hero._insid
    local targetHero = ed.AutoChessModel:getChessHeroBySid(insid)
    if targetHero then
      targetHero:updateHeroId(target_hero._hid)
      if target_hero._pet then
        local chessPet = ed.ChessPet.create(target_hero._pet)
        targetHero:equipChessPet("on", chessPet)
        ed.AutoChessModel:updateDropPetData(target_hero._pet._insid, "on", insid)
      end
    else
      local composeHero = ed.ChessHero.create(target_hero)
      ed.AutoChessModel:updateTotalHero("new", composeHero)
    end
    FireEvent("EventChessComposeHero", insid, hero_insids)
  end
end

function class:handlerShopRefresh(data)
  local shopData = data._shop
  local gold = data._gold
  ed.AutoChessModel:setTotalGold(gold)
  ed.AutoChessModel:setupShopHeroList(shopData._heroes)
  ed.AutoChessModel:setShopLock(shopData._is_locked == 1)
  FireEvent("EventShopDataRefresh", data)
end

function class:handlerShopLock(data)
  if data._result == "success" then
    ed.AutoChessModel:setShopLock(data._is_locked >= 1)
  else
    ed.AutoChessModel:setShopLock(false)
  end
  FireEvent("EventShopDataLock")
end

function class:handlerSetLineup(data)
  if data._result == "success" then
  else
  end
end

function class:handlerEquipPet(data)
  local chess_hero = data._hero
  local insid = chess_hero._insid
  local chessHero = ed.AutoChessModel:getChessHeroBySid(insid)
  if chessHero and chess_hero._pet then
    ed.AutoChessModel:updateDropPetData(chess_hero._pet._insid, "on", insid)
    local chessPet = ed.ChessPet.create(chess_hero._pet)
    chessHero:equipChessPet("on", chessPet)
    FireEvent("EventEquipChessPet", insid)
  end
end

function class:handlerReplacePet(data)
  local chess_hero = data._hero
  local insid = chess_hero._insid
  local chessHero = ed.AutoChessModel:getChessHeroBySid(insid)
  if chessHero then
    ed.AutoChessModel:updateDropPetData(chess_hero._pet._insid, "on", insid)
    local chessPet = ed.ChessPet.create(chess_hero._pet)
    chessHero:equipChessPet("on", chessPet)
    local chess_pet = data._pet
    if chess_pet then
      ed.AutoChessModel:updateDropPetData(chess_pet._insid, "off")
    end
    FireEvent("EventReplaceChessPet", insid)
  end
end

function class:handlerExchangePet(data)
  local from_hero = data._from_hero
  local to_hero = data._to_hero
  if from_hero and to_hero then
    local fromChessHero = ed.AutoChessModel:getChessHeroBySid(from_hero._insid)
    fromChessHero:equipChessPet("off")
    local chess_pet = data._pet
    if chess_pet then
      ed.AutoChessModel:updateDropPetData(chess_pet._insid, "off")
    end
    if to_hero._pet then
      local toChessHero = ed.AutoChessModel:getChessHeroBySid(to_hero._insid)
      ed.AutoChessModel:updateDropPetData(to_hero._pet._insid, "on", to_hero._insid)
      local chessPet = ed.ChessPet.create(to_hero._pet)
      toChessHero:equipChessPet("on", chessPet)
    end
    FireEvent("EventExchangeChessPet", from_hero._insid, to_hero._insid)
  end
end

function class:handlerBuyExp(data)
  local level = data._level
  local exp = data._exp
  local gold = data._gold
  ed.AutoChessModel:setTotalGold(gold)
  local diffLv = level - ed.AutoChessModel:getTeamLevel()
  ed.AutoChessModel:setTeamLevel(level)
  ed.AutoChessModel:setTeamExp(exp)
  local userKey = ed.ChessPlayer.getMyUserKey()
  ed.AutoChessModel:updatePlayerLevel(userKey, level)
  FireEvent("EventChessBuyExp", diffLv)
end

function class:handlerStartNotify(data)
  self.joinGame = false
  self.gameId = data._game_id
  self.gameAddr = data._game_addr
  if self.gameId ~= 0 then
    local ip, port, svrid = ed.getIPPortFromString(self.gameAddr)
    print("--------AUTO CHESS---game-start-----conncting.." .. ip .. "_" .. port .. "_" .. (svrid or "svrid") .. "_" .. self:getGameId())
    ed.AutoChessNetwork:doGameConnect(ip, port, svrid)
  end
  FireEvent("EventChessGameStart")
end

function class:handlerLoadNotify(data)
  local loadData = data._users
  self:updataLoadingData(loadData)
  FireEvent("EventChessLoadNotify")
end

function class:handlerComposeNotify(data)
  FireEvent("EventChessComposeNotify", data)
end

function class:handlerRoundNotify(data)
  if ed.chess_debug_mode then
  end
  if data._round_num then
    ed.AutoChessModel:setBattleRound(data._round_num)
  end
  if data._round_start then
    self:enterStage(self.GAMESTAGE.START)
    local roundData = data._round_start
    local oppoDatas = roundData._oppos or {}
    for _, oppoData in ipairs(oppoDatas) do
      ed.AutoChessModel:updatePlayerHp(oppoData._user_key, oppoData._hp)
      ed.AutoChessModel:updatePlayerLevel(oppoData._user_key, oppoData._level)
      ed.AutoChessModel:updatePlayerStatus(oppoData._user_key, oppoData._status)
      ed.AutoChessModel:updatePlayerPowers(oppoData._user_key, oppoData._hero_powers)
      ed.AutoChessModel:updateTotalHp(oppoData._user_key, oppoData._max_hp)
    end
    ed.AutoChessModel:sortPlayerList()
    if ed.AutoChessModel:isMySelfDead() then
      ed.AutoChessModel:clearBattleEvents()
      FireEvent("EventChessRoundStart")
      return
    end
    local userKey = ed.ChessPlayer.getMyUserKey()
    ed.AutoChessModel:setMySelfDead(roundData._is_dead == 1 or false)
    ed.AutoChessModel:setHeroPowerCD(roundData._hero_power_cds)
    ed.AutoChessModel:updatePlayerHp(userKey, roundData._hp or 0)
    ed.AutoChessModel:updateTotalHp(userKey, roundData._max_hp)
    if roundData._hero_powers then
      ed.AutoChessModel:updatePlayerPowers(userKey, roundData._hero_powers)
    end
    ed.AutoChessModel:setTotalGold(roundData._gold or 0)
    ed.AutoChessModel:setCombo(roundData._combo or 0)
    ed.AutoChessModel:setTeamLevel(roundData._level or 1)
    ed.AutoChessModel:updatePlayerLevel(userKey, roundData._level)
    ed.AutoChessModel:setTeamExp(roundData._exp or 0)
    ed.AutoChessModel:setupDropPetList(roundData._pets)
    ed.AutoChessModel:setupTotalHeroList(roundData._heroes)
    ed.AutoChessModel:setBattleTeam(roundData._team)
    ed.AutoChessModel:setGainGold({
      gainBase = roundData._gain_base or 0,
      gainInst = roundData._gain_inst or 0,
      comboV = roundData._gain_combo_v or 0,
      comboD = roundData._gain_combo_d or 0
    })
    ed.AutoChessModel:clearBattleEvents()
    FireEvent("EventChessRoundStart")
    if roundData._is_dead == 1 then
      ed.showConfirmDialog({
        text = T("\228\189\160\229\183\178\232\162\171\230\183\152\230\177\176\239\188\140\230\152\175\229\144\166\232\191\148\229\155\158\228\184\187\231\149\140\233\157\162\239\188\159"),
        leftHandler = function()
        end,
        rightHandler = function()
          ed.AutoChessNetwork:sendChessQuit()
        end
      })
      FireEvent("EventChessPlayerDead")
    end
  elseif data._round_prepare then
    self:enterStage(self.GAMESTAGE.PREPARE)
    local roundData = data._round_prepare
    if ed.AutoChessModel:isMySelfDead() then
      ed.AutoChessModel:setPrepareEndTime(roundData._end_time)
      ed.AutoChessModel:clearBattleEvents()
      FireEvent("EventChessRoundPrepare")
      return
    end
    ed.AutoChessModel:setOppoType(roundData._oppo_type)
    ed.AutoChessModel:setPrepareEndTime(roundData._end_time)
    local shopData = roundData._hero_shop
    ed.AutoChessModel:setupShopHeroList(shopData._heroes)
    ed.AutoChessModel:setShopLock(shopData._is_locked == 1)
    ed.AutoChessModel:clearBattleEvents()
    FireEvent("EventChessRoundPrepare")
  elseif data._round_lock then
    self:enterStage(self.GAMESTAGE.LOCK)
    if ed.AutoChessModel:isMySelfDead() then
      FireEvent("EventChessRoundLock")
      return
    end
    local roundData = data._round_lock
    local teamData = roundData._team
    ed.AutoChessModel:setSelfTeamData(teamData)
    FireEvent("EventChessRoundLock")
  elseif data._round_battle then
    self:enterStage(self.GAMESTAGE.BATTLE)
    local roundData = data._round_battle
    local recordData = roundData._record
    ed.AutoChessModel:setBattleEvents(roundData._events)
    if ed.AutoChessModel:isMySelfDead() then
      FireEvent("EventChessRoundBattle")
      return
    end
    for k, event in pairs(roundData._events or {}) do
      if event._over then
        local eventData = event._over
        local myUserKey = ed.ChessPlayer.getMyUserKey()
        if ed.ChessPlayer.isUserKeyEqual(myUserKey, eventData._user_key) then
          ed.AutoChessModel:updatePlayerHp(myUserKey, eventData._hp or 0)
          ed.AutoChessModel:sortPlayerList()
          break
        end
      end
    end
    if recordData then
      ed.AutoChessModel:setBattleResult(recordData._result)
    end
    local oppoDatas = roundData._oppos or {}
    for _, oppoData in ipairs(oppoDatas) do
      ed.AutoChessModel:updatePlayerHp(oppoData._user_key, oppoData._hp)
      ed.AutoChessModel:updatePlayerLevel(oppoData._user_key, oppoData._level)
      ed.AutoChessModel:updatePlayerStatus(oppoData._user_key, oppoData._status)
      ed.AutoChessModel:updatePlayerPowers(oppoData._user_key, oppoData._hero_powers)
      ed.AutoChessModel:updateTotalHp(oppoData._user_key, oppoData._max_hp or 60)
    end
    ed.AutoChessModel:sortPlayerList()
    FireEvent("AutoChessUpdatePlayerLevel")
    ed.AutoChessModel:setBattleLootPets(roundData._loots)
    if not recordData then
      return
    end
    self._logcheckId = recordData._checkid or 0
    self._loggameId = recordData._gameid or 0
    self._loground = recordData._round or 0
    self._logIndex = (recordData._battle or {})._index
    FireEvent("EventChessRoundBattle", recordData)
  elseif data._round_over then
    self:enterStage(self.GAMESTAGE.OVER)
    local roundData = data._round_over
    if ed.AutoChessModel:isMySelfDead() then
      ed.AutoChessModel:setOverEndTime(roundData._end_time or 0)
      FireEvent("EventChessRoundOver")
      return
    end
    ed.AutoChessModel:setTotalGold(roundData._gold or 0)
    local userKey = ed.ChessPlayer.getMyUserKey()
    ed.AutoChessModel:updatePlayerHp(userKey, roundData._hp or 0)
    ed.AutoChessModel:sortPlayerList()
    ed.AutoChessModel:setOverEndTime(roundData._end_time or 0)
    ed.AutoChessModel:updateTotalHp(userKey, roundData._max_hp or 60)
    FireEvent("EventChessRoundOver")
    self:handlerComposeHero(roundData)
  end
end

function class:handlerStatusNotify(data)
  FireEvent("EventChessStatusNotify")
end

function class:handlerOverNotify(data)
  FireEvent("EventChessOverNotify")
  ed.pushScene(ed.ui.AutoChessResultScene.create(data._stats or {}))
end

function class:handlerEventNotify(data)
  local events = data._events or {}
  for k, event in pairs(events) do
    if event._over then
      local eventData = event._over
      local myUserKey = ed.ChessPlayer.getMyUserKey()
      if ed.ChessPlayer.isUserKeyEqual(myUserKey, eventData._user_key) then
      else
        local isHurt, diffHp = ed.AutoChessModel:checkPlayerHurt(eventData._user_key, eventData._hp)
        ed.AutoChessModel:updatePlayerHp(eventData._user_key, eventData._hp or 0)
        ed.AutoChessModel:sortPlayerList()
        FireEvent("ChessEventBattleOver", eventData._user_key, isHurt, diffHp)
      end
    end
  end
  local actions = data._actions or {}
  for k, action in pairs(actions) do
    if action._choose_hero_power then
      local data = action._choose_hero_power
      if data._hero_power then
        ed.AutoChessModel:updatePlayerPower(data._user_key, data._hero_power, data._hero_power._pos)
        FireEvent("EventChessSelectPowerNotify", data)
      end
      if data._effects then
        self:applyPowerEffect(data._user_key, data._effects)
      end
    elseif action._emoji then
      FireEvent("EventChessChatContentNotify", action._emoji)
    end
  end
end

function class:handlerLevelNotify(msg)
  ed.AutoChessModel:updatePlayerLevel(msg._user_key, msg._level)
  FireEvent("AutoChessUpdatePlayerLevel")
end

function class:handlerActionNotify(msg)
  for k, action in ipairs(msg._actions or {}) do
    if action._choose_hero_power then
      local powerIds = action._choose_hero_power._power_ids
      local powerPos = action._choose_hero_power._power_pos
      ed.AutoChessModel:setSelectPowerIds(powerIds)
      ed.AutoChessModel.selectPowerPos = powerPos
      FireEvent("AutoChessSelectPowerWinPop")
    end
  end
end

function class:handlerEffectNotify(msg)
  local userKey = ed.ChessPlayer.getMyUserKey()
  if msg._effects then
    self:applyPowerEffect(userKey, msg._effects)
  end
end

function class:handlerBattleEvent(events)
  for k, event in pairs(events) do
    local type = event.type
    local content = event.event
    if type == 1 then
      ed.AutoChessModel:updatePlayerHp(content._user_key, content._hp or 0)
      ed.AutoChessModel:updatePlayerLevel(content._user_key, content._level or 0)
      ed.AutoChessModel:updatePlayerTeam(content._user_key, content._team)
      ed.AutoChessModel:sortPlayerList()
      FireEvent("ChessEventBattleStart", content._user_key)
    elseif type == 2 then
      local isHurt, diffHp = ed.AutoChessModel:checkPlayerHurt(content._user_key, content._hp)
      ed.AutoChessModel:updatePlayerHp(content._user_key, content._hp or 0)
      ed.AutoChessModel:updatePlayerLevel(content._user_key, content._level or 0)
      ed.AutoChessModel:sortPlayerList()
      FireEvent("ChessEventBattleOver", content._user_key, isHurt, diffHp)
      FireEvent("ChessEventBattleOverForMarquee", content._user_key, content._oppo_type, content._oppo_key, content._battle_result)
    elseif type == 3 then
      FireEvent("ChessEventBattleComboVictory", content._user_key, content._combo)
    elseif type == 4 then
      FireEvent("ChessEventBattleBlockVictory", content._user_key, content._oppo_key, content._combo)
    end
  end
end

function class:handlerBattleConfirm()
  if ed.AutoChessTeachManager:isGuideFlag() then
    return
  end
  local selfHeros, enemyHeros = ed.engine:getChessBattleResult()
  local battleResult = 0
  if 0 < ed.engine.alive_enemy_count and ed.engine.alive_alliance_count == 0 then
    battleResult = 1
  elseif ed.engine.alive_enemy_count == 0 and 0 <= ed.engine.alive_alliance_count then
    battleResult = 0
  end
  local curTime = ed.getServerTime()
  local startTime = self:getBtStartTime()
  local battleTime = curTime - startTime
  ed.AutoChessNetwork:sendChessBattleConfirm(battleResult, selfHeros, enemyHeros, battleTime)
end

function class:handlerBattleConfirmNet(data)
  local result = data._battle_result
  local gold = data._gain_gold
  local confirm = data._confirm_result
  local lootPets = data._loot_pets
  ed.AutoChessModel:setWinGold(gold or 0)
  local totalGold = ed.AutoChessModel:getTotalGold()
  ed.AutoChessModel:setTotalGold(totalGold + gold)
  ed.AutoChessModel:setBattleResult(result)
  ed.AutoChessModel:updateDropPetBag(lootPets)
  local userKey = ed.ChessPlayer.getMyUserKey()
  local isHurt, diffHp = ed.AutoChessModel:checkPlayerHurt(userKey, data._hp)
  self:handlerLogSave(confirm)
  ed.AutoChessModel:updatePlayerHp(userKey, data._hp or 0)
  ed.AutoChessModel:sortPlayerList()
  FireEvent("ChessEventBattleOver", userKey, isHurt, diffHp)
  FireEvent("EventChessBattleConfirm")
end

function class:applyPowerEffect(userKey, effects)
  for k, v in ipairs(effects) do
    if v._mod_hp then
      local data = v._mod_hp
      ed.AutoChessModel:updatePlayerHp(userKey, data._mod_hp or 0, true)
      ed.AutoChessModel:updateTotalHp(userKey, data._max_hp or 0)
      FireEvent("EventChessEventNotify")
    end
    print(ed.ChessPlayer.getMyUserKey(), userKey)
    if v._gain_heroes and self:isMemberEqual(ed.ChessPlayer.getMyUserKey(), userKey) then
      local data = v._gain_heroes
      local heroes = data._heroes
      for k, chess_hero in ipairs(heroes or {}) do
        local getHero = ed.ChessHero.create(chess_hero)
        local isSuccess, chessHero, slot = ed.AutoChessModel:updateTotalHero("new", getHero)
        print("ChessPowerGetHero ", isSuccess, "1111111")
        if isSuccess and chessHero then
          FireEvent("ChessPowerGetHero", chessHero, slot)
        end
      end
    end
    if v._gain_gold and self:isMemberEqual(ed.ChessPlayer.getMyUserKey(), userKey) then
      local data = v._gain_gold
      ed.AutoChessModel:setTotalGold(data._gold, true)
      FireEvent("ChessPowerGetGold")
    end
  end
end

function class:handlerChooseHeroPower(msg)
  local userKey = ed.ChessPlayer.getMyUserKey()
  if msg._is_auto == 1 then
  end
  if msg._option_index then
  end
  if msg._hero_power then
    ed.AutoChessModel:updatePlayerPower(userKey, msg._hero_power, msg._power_pos)
  end
  if msg._effects then
    self:applyPowerEffect(userKey, msg._effects)
  end
  FireEvent("AutoChessSelectPowerSuccess")
end

function class:handlerLogSave(confirm)
  if confirm == "conflict" then
    ed.engine:saveBattleLog("chess_" .. self._loggameId .. "_" .. self._loground .. "_" .. self._logIndex)
    ed.reportBattleLog(self._logcheckId, "chess_" .. self._loggameId .. "_" .. self._loground .. "_" .. self._logIndex)
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

function class:setChessTeamInfo(isTeamMode, teamId)
  self.teamMode = isTeamMode
  self.teamId = teamId
end

function class:getChessTeamInfo()
  return self.teamMode, self.teamId
end

function class:setChessTeamId(teamId)
  self.teamId = teamId
end

function class:getChessTeamId()
  return self.teamId
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

function class:getPreLoadUnitList()
  local list = {}
  local ChessUnits = ed.getDataTable("ChessUnit")
  for k, v in pairs(ChessUnits) do
    if type(k) == "number" and v["Unit Type"] == "Hero" and v["Is Available"] then
      table.insert(list, k)
    end
  end
  return list
end

function class:getAllHeroIdList()
  local list = {}
  local ChessUnits = ed.getDataTable("ChessUnit")
  for k, v in pairs(ChessUnits) do
    if type(k) == "number" and v["Unit Type"] == "Hero" and v["Is Available"] and not ed.isElementInTable(v["Hero ID"], list) then
      table.insert(list, v["Hero ID"])
    end
  end
  return list
end

function class:getChessUnitListByTag(tag)
  local heroIds = self:getAllHeroIdList()
  local ChessUnits = ed.getDataTable("ChessUnit")
  local list = {}
  for k, hid in pairs(heroIds) do
    local unit = ChessUnits[hid]
    if ed.isElementInTable(tag, unit["Race Tag"] or {}) or ed.isElementInTable(tag, unit["Ability Tag"] or {}) then
      table.insert(list, unit)
    end
  end
  table.sort(list, function(a, b)
    if a["Buy Price"] == b["Buy Price"] then
      return a["Hero ID"] < b["Hero ID"]
    else
      return a["Buy Price"] < b["Buy Price"]
    end
  end)
  return list
end

local debugData = {
  roudData = {
    round = {
      start = {
        [1] = {
          _hp = 100,
          _gold = 12,
          _level = 1,
          _exp = 2
        },
        [2] = {
          _hp = 100,
          _gold = 12,
          _level = 1,
          _exp = 2
        },
        [3] = {
          _hp = 100,
          _gold = 12,
          _level = 1,
          _exp = 2
        },
        [4] = {
          _hp = 100,
          _gold = 12,
          _level = 1,
          _exp = 2
        }
      },
      prepare = {
        [1] = {
          _oppo_type = "monster",
          _hero_shop = {
            _heroes = {
              {
                _insid = 10,
                _hid = 101,
                _sold = 0
              },
              {
                _insid = 11,
                _hid = 101,
                _sold = 0
              },
              {
                _insid = 12,
                _hid = 101,
                _sold = 0
              },
              {
                _insid = 13,
                _hid = 901,
                _sold = 0
              },
              {
                _insid = 14,
                _hid = 1001,
                _sold = 0
              }
            },
            _is_locked = 0
          },
          _end_time = ed.getServerTime() + 30
        },
        [2] = {
          _oppo_type = "player",
          _hero_shop = {
            _heroes = {
              {
                _insid = 15,
                _hid = 101,
                _sold = 0
              },
              {
                _insid = 16,
                _hid = 201,
                _sold = 0
              },
              {
                _insid = 17,
                _hid = 601,
                _sold = 0
              },
              {
                _insid = 18,
                _hid = 901,
                _sold = 0
              },
              {
                _insid = 19,
                _hid = 1001,
                _sold = 0
              }
            },
            _is_locked = 0
          },
          _end_time = ed.getServerTime() + 30
        },
        [3] = {
          _oppo_type = "monster",
          _hero_shop = {
            _heroes = {
              {
                _insid = 20,
                _hid = 101,
                _sold = 0
              },
              {
                _insid = 21,
                _hid = 201,
                _sold = 0
              },
              {
                _insid = 22,
                _hid = 601,
                _sold = 0
              },
              {
                _insid = 23,
                _hid = 901,
                _sold = 0
              },
              {
                _insid = 24,
                _hid = 1001,
                _sold = 0
              }
            },
            _is_locked = 0
          },
          _end_time = ed.getServerTime() + 30
        }
      },
      lock = {
        [1] = {
          _team = {
            _heroes = {
              {_insid = 10, _hid = 101},
              {_insid = 11, _hid = 201}
            },
            _positions = {1, 6}
          }
        },
        [2] = {
          _team = {
            _heroes = {
              {_insid = 12, _hid = 601},
              {_insid = 13, _hid = 901}
            },
            _positions = {1, 6}
          }
        },
        [3] = {
          _team = {
            _heroes = {
              {_insid = 16, _hid = 201},
              {_insid = 19, _hid = 1001}
            },
            _positions = {1, 6}
          }
        }
      },
      battle = {
        [1] = {
          _record = {
            _checkid = 12440,
            _gamid = 10,
            _round = 1,
            _battle = {
              _index = 1,
              _self_user = {},
              _oppo_type = "monster",
              _oppo_user = {},
              _rseed = 462,
              _self_team = {
                _heroes = {
                  {_insid = 10, _hid = 101},
                  {_insid = 11, _hid = 101},
                  {_insid = 12, _hid = 301},
                  {_insid = 13, _hid = 401},
                  {_insid = 14, _hid = 501},
                  {_insid = 15, _hid = 602}
                },
                _positions = {
                  1,
                  6,
                  7,
                  9,
                  10,
                  11
                }
              },
              _oppo_team = {
                _heroes = {
                  {_insid = 30, _hid = 200001},
                  {_insid = 31, _hid = 200001},
                  {_insid = 32, _hid = 200002},
                  {_insid = 33, _hid = 200002},
                  {_insid = 34, _hid = 200001}
                },
                _positions = {
                  1,
                  6,
                  7,
                  9,
                  10,
                  11
                }
              }
            },
            _result = "victory",
            _time = 90
          },
          _events = {
            [1] = {
              _time = 3000,
              _start = {
                _user_key = {_user_id = 10, _server_id = 60001},
                _hp = 30
              }
            },
            [2] = {
              _time = 12000,
              _over = {
                _user_key = {_user_id = 10, _server_id = 60001},
                _hp = 10,
                _gold = 12
              }
            }
          },
          _loots = {
            {
              _hero_insid = 30,
              _pet = {_insid = 100, _pid = 300007}
            },
            {
              _hero_insid = 31,
              _pet = {_insid = 101, _pid = 300008}
            }
          }
        },
        [2] = {
          _record = {
            _checkid = 12440,
            _gamid = 10,
            _round = 1,
            _battle = {
              _index = 2,
              _self_user = {},
              _oppo_type = "player",
              _oppo_user = {},
              _rseed = 462,
              _self_team = {
                _heroes = {
                  {_insid = 10, _hid = 101},
                  {_insid = 11, _hid = 201}
                },
                _positions = {1, 6}
              },
              _oppo_team = {
                _heroes = {
                  {_insid = 30, _hid = 601},
                  {_insid = 31, _hid = 201}
                },
                _positions = {1, 6}
              }
            },
            _result = "victory",
            _time = 90
          },
          _events = {
            [1] = {
              _time = 3,
              _start = {
                _user_key = {_user_id = 10, _server_id = 60001},
                _hp = 10
              }
            },
            [2] = {
              _time = 56,
              _over = {
                _user_key = {_user_id = 10, _server_id = 60001},
                _hp = 10,
                _gold = 12
              }
            }
          }
        }
      },
      over = {
        [1] = {
          _hp = 10,
          _gold = 10,
          _end_time = 0
        },
        [2] = {
          _hp = 10,
          _gold = 10,
          _end_time = 0
        },
        [3] = {
          _hp = 10,
          _gold = 10,
          _end_time = 0
        }
      }
    }
  },
  replyData = {
    shoprefresh = {
      _shop = {
        _heroes = {
          {
            _insid = 50,
            _hid = 501,
            _sold = 0
          },
          {
            _insid = 51,
            _hid = 101,
            _sold = 0
          },
          {
            _insid = 52,
            _hid = 801,
            _sold = 0
          },
          {
            _insid = 53,
            _hid = 901,
            _sold = 0
          },
          {
            _insid = 54,
            _hid = 1201,
            _sold = 0
          }
        },
        _is_locked = 0
      },
      _gold = 100
    },
    battleConfirm = {
      _battle_result = "ok",
      _gain_gold = 1,
      _confirm_result = "victory",
      _loot_pets = {
        {_insid = 100, _pid = 300007},
        {_insid = 101, _pid = 300008}
      }
    }
  }
}

function class:dispatchDebugNotify(type, subtype, round)
  if type == "start" then
  elseif type == "load" then
  elseif type == "round" then
    local data = {}
    data._round_num = round
    local roundData = debugData.roudData
    if subtype == "start" then
      data._round_start = roundData.round.start[round]
      self:handlerRoundNotify(data)
    elseif subtype == "prepare" then
      data._round_prepare = roundData.round.prepare[round]
      data._round_prepare._end_time = ed.getServerTime() + 30
      self:handlerRoundNotify(data)
    elseif subtype == "lock" then
      data._round_lock = roundData.round.lock[round]
      self:handlerRoundNotify(data)
    elseif subtype == "battle" then
      data._round_battle = roundData.round.battle[round]
      self:handlerRoundNotify(data)
    elseif subtype == "over" then
      data._round_over = roundData.round.over[round]
      data._round_over._end_time = ed.getServerTime() + 30
      self:handlerRoundNotify(data)
    end
  elseif type == "status" then
  elseif type == "over" then
    self:handlerOverNotify({
      {
        _user_key = {_server_id = 60004, _user_id = 10},
        _rank = 1,
        _is_win = true,
        _base_score = 10,
        _extra_score = 1,
        _hp = 20,
        _level = 5,
        _victory_cnt = 20,
        _defeat_count = 2,
        _team = {
          _heroes = {
            {_insid = 1, _hid = 101},
            {_insid = 2, _hid = 201},
            {_insid = 3, _hid = 301},
            {_insid = 4, _hid = 401},
            {_insid = 5, _hid = 501},
            {_insid = 6, _hid = 601}
          },
          _positions = {
            1,
            2,
            3,
            4,
            5,
            6
          }
        }
      },
      {
        _user_key = {_server_id = 60004, _user_id = 12},
        _rank = 2,
        _is_win = false,
        _base_score = 10,
        _extra_score = 1,
        _hp = 20,
        _level = 5,
        _victory_cnt = 20,
        _defeat_count = 2,
        _team = {
          _heroes = {
            {_insid = 1, _hid = 101},
            {_insid = 2, _hid = 201},
            {_insid = 3, _hid = 301},
            {_insid = 4, _hid = 401},
            {_insid = 5, _hid = 501},
            {_insid = 6, _hid = 601}
          },
          _positions = {
            1,
            2,
            3,
            4,
            5,
            6
          }
        }
      },
      {
        _user_key = {_server_id = 60004, _user_id = 13},
        _rank = 3,
        _is_win = false,
        _base_score = 10,
        _extra_score = 1,
        _hp = 20,
        _level = 5,
        _victory_cnt = 20,
        _defeat_count = 2,
        _team = {
          _heroes = {
            {_insid = 1, _hid = 101},
            {_insid = 2, _hid = 201},
            {_insid = 3, _hid = 301},
            {_insid = 4, _hid = 401},
            {_insid = 5, _hid = 501},
            {_insid = 6, _hid = 601}
          },
          _positions = {
            1,
            2,
            3,
            4,
            5,
            6
          }
        }
      },
      {
        _user_key = {_server_id = 60004, _user_id = 14},
        _rank = 4,
        _is_win = false,
        _base_score = 10,
        _extra_score = 1,
        _hp = 20,
        _level = 5,
        _victory_cnt = 20,
        _defeat_count = 2,
        _team = {
          _heroes = {
            {_insid = 1, _hid = 101},
            {_insid = 2, _hid = 201},
            {_insid = 3, _hid = 301},
            {_insid = 4, _hid = 401},
            {_insid = 5, _hid = 501},
            {_insid = 6, _hid = 601}
          },
          _positions = {
            1,
            2,
            3,
            4,
            5,
            6
          }
        }
      }
    })
  elseif type == "" then
  elseif type == "" then
  end
end

function class:dispatchDebugReply(type, data)
  if type == "buyhero" then
    self:handlerBuyHero(data)
  elseif type == "sellhero" then
    self:handlerSellHero(data)
  elseif type == "compose" then
    self:handlerComposeHero(data)
  elseif type == "shoprefresh" then
    local shopdata = debugData.replyData.shoprefresh
    self:handlerShopRefresh(shopdata)
  elseif type == "shoplock" then
  elseif type == "setline" then
  elseif type == "equippet" then
  elseif type == "replacepet" then
  elseif type == "battleconfirm" then
    local confirmData = debugData.replyData.battleConfirm
    self:handlerBattleConfirmNet(confirmData)
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

function class:getTeamMembers()
  return self.teamMembers
end

function class:clearTeamData()
  self.teamMembers = {}
  self.teamLeader = nil
end

function class:setChessTeamInfo(isTeamMode, teamId)
  self.teamMode = isTeamMode
  self.teamId = teamId
end

function class:getChessTeamInfo()
  return self.teamMode, self.teamId
end

function class:setChessTeamId(teamId)
  self.teamId = teamId
end

function class:getChessTeamId()
  return self.teamId
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

ed.AutoChessManager = class.getInstance()
ed.AutoChessManager = class.getInstance()
