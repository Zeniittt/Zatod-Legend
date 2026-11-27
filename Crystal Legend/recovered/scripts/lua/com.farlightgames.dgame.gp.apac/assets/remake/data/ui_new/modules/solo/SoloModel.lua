local SoloFaction = {}
SoloFaction.__index = SoloFaction
ed.SoloFaction = SoloFaction

function SoloFaction:initData(factionId)
  self.id = factionId
  self.cardList = {}
  self.tbData = ed.getDataTable("SoloCardTag")[self.id]
  self.exp = 0
  self.level = 0
end

function SoloFaction:getCardLevel(cardId)
  for k, v in ipairs(self.cardList) do
    if cardId == v.id then
      return v.level
    end
  end
  return 0
end

function SoloFaction:updateExpAndLevel(exp)
  local step = {
    8,
    16,
    24,
    40
  }
  local isChange = false
  if exp ~= self.exp then
    self.exp = exp
    isChange = true
  end
  local level = 0
  for i = 1, 4 do
    if exp >= step[i] then
      level = i
    end
  end
  if level ~= self.level then
    self.level = level
    FireEvent("SoloFactionLevelUp", self.id)
    isChange = true
  end
  if isChange then
    FireEvent("SoloUpdateFaction", self.id)
  end
end

function SoloFaction:addCard(data)
  local quality = ed.getDataTable("SoloCardSkill")[data._cid].Quality
  local isExist = false
  for k, v in ipairs(self.cardList) do
    if v.id == data._cid then
      v.level = v.level + data._level
      isExist = true
      break
    end
  end
  if not isExist then
    local card = {
      id = data._cid,
      level = data._level,
      quality = quality
    }
    table.insert(self.cardList, card)
  end
  table.sort(self.cardList, function(a, b)
    if a.quality == b.quality then
      return a.level > b.level
    else
      return a.quality > b.quality
    end
  end)
end

function SoloFaction.create(data)
  local object = {}
  setmetatable(object, SoloFaction)
  object:initData(data)
  return object
end

local SkillPlayer = {}
SkillPlayer.__index = SkillPlayer
ed.SkillPlayer = SkillPlayer

function SkillPlayer.create(data)
  local object = {}
  setmetatable(object, SkillPlayer)
  object:initData(data)
  return object
end

function SkillPlayer:initData(data)
  self._userKey = data._user_key
  self._userSummary = data._user_summary
  self._userPlatform = data._plat
  self._showServerId = data._show_server_id
  self._state = 1
  self._curHp = data._hp or 0
  self._level = data._level or 1
  self._totalHp = 30
  self._damage = data._damage or 0
  self._hero_id = data._hero_id or 0
  self._team = nil
end

function SkillPlayer:getUserKey()
  return self._userKey
end

function SkillPlayer:getUserSummary()
  return self._userSummary
end

function SkillPlayer:getUserPlatform()
  return self._userPlatform
end

function SkillPlayer:getUserShowServer()
  return self._showServerId
end

function SkillPlayer:getCurHp()
  return self._curHp
end

function SkillPlayer:updateCurHp(hp)
  self._curHp = hp
end

function SkillPlayer:getTotalHp()
  return self._totalHp
end

function SkillPlayer:updateTotalHp(totalHp)
  self._totalHp = totalHp
end

function SkillPlayer:updateBattleGroup(group)
  self._battle_group = group
end

function SkillPlayer:getBattleGroup()
  return self._battle_group or 0
end

function SkillPlayer:updateLevel(level)
  self._level = level
end

function SkillPlayer:getLevel()
  return self._level
end

function SkillPlayer:setDamage(damage)
  self._damage = damage
end

function SkillPlayer:getDamage()
  return self._damage or 0
end

function SkillPlayer:updateTeam(team)
  self._team = team
end

function SkillPlayer:getTeam()
  return self._team
end

function SkillPlayer:updateState(state)
  self._state = state
end

function SkillPlayer:getState()
  return self._state
end

function SkillPlayer:getHeroId()
  return self._hero_id
end

function SkillPlayer:setHeroId(heroId)
  self._hero_id = heroId
end

function SkillPlayer:setPowers(powers)
  self._powers = powers
end

function SkillPlayer:updatePower(power, pos)
  if 0 < pos then
    self._powers = self._powers or {}
    self._powers[pos] = power
  elseif self:isMySelf() then
    ed.SoloModel._powers[pos] = power
  end
end

function SkillPlayer:getPowers()
  return self._powers
end

function SkillPlayer:isMySelf()
  return self._userKey._user_id == ed.getUserid() and self._userKey._server_id == tonumber(game_server_id)
end

function SkillPlayer.getMyUserKey()
  local userKey = ed.commonmsg.solo_user_key()
  userKey._user_id = ed.getUserid()
  userKey._server_id = tonumber(game_server_id)
  return userKey
end

function SkillPlayer.isUserKeyEqual(key1, key2)
  return key1._user_id == key2._user_id and key1._server_id == key2._server_id
end

local FactionBattleData = {}
FactionBattleData.__index = FactionBattleData

function FactionBattleData.create(id)
  local object = {}
  setmetatable(object, FactionBattleData)
  object:initData(id)
  return object
end

function FactionBattleData:addAmount(type, id)
  for k, v in ipairs(self.subData) do
    if v.type == type and v.id == id then
      v.amount = v.amount + 1
      return
    end
  end
end

function FactionBattleData:addValue(value, type, id)
  if self.id ~= 6 then
    self.totalValue = self.totalValue + value
  end
  for k, v in ipairs(self.subData) do
    if v.type == type and v.id == id then
      v.value = v.value + value
      if v.type ~= 2 then
        v.amount = v.amount + 1
      end
      table.sort(self.subData, function(a, b)
        return a.value > b.value
      end)
      return
    end
  end
  local data = {
    type = type,
    id = id,
    value = value,
    amount = 1
  }
  table.insert(self.subData, data)
  table.sort(self.subData, function(a, b)
    return a.value > b.value
  end)
end

function FactionBattleData:initData(id)
  self.totalValue = 0
  self.id = id
  self.subData = {}
end

local SoloModel = {}
SoloModel.__index = SoloModel

function SoloModel.create()
  local object = {}
  setmetatable(object, SoloModel)
  object:initData()
  return object
end

function SoloModel:initData()
  self.playerList = {}
  self.shopHeroList = {}
  self.level = 1
  self.exp = 0
  self.totalGold = 0
  self.isDead = false
  self.gainGold = {
    gainBase = 0,
    gainInst = 0,
    comboV = 0,
    comboD = 0
  }
  self.battleLimit = 0
  self.round = 1
  self.oppoType = "nobody"
  self.endTime = 0
  self.overEndTime = 0
  self.isLock = false
  self.teamMaxHp = 0
  self.battleEvents = {}
  self.allCardList = {}
  self.factions = {}
  self.playerBattleDataList = {}
  self.oppoBattleDataList = {}
  self.refreshCost = 20
  self.randomCost = 100
  self.heroId = nil
  self.hero = nil
  self.logs = {}
end

function SoloModel:getFactionBattleData(id, isPlayer)
  if isPlayer then
    return self.playerBattleDataList[id]
  else
    return self.oppoBattleDataList[id]
  end
end

function SoloModel:resetBattleDataList(pid, oid)
  self.playerBattleDataList = {}
  self.oppoBattleDataList = {}
  self.playerHeroId = pid
  for i = 0, 11 do
    if i ~= 4 then
      local factionBattleData = FactionBattleData.create(i)
      self.playerBattleDataList[i] = factionBattleData
    end
  end
  self.oppoHeroId = oid
  for i = 0, 11 do
    if i ~= 4 then
      local factionBattleData = FactionBattleData.create(i)
      self.oppoBattleDataList[i] = factionBattleData
    end
  end
end

function SoloModel:addCard(card)
  local isExist = false
  for k, v in ipairs(self.allCardList) do
    if v._cid == card._cid then
      v._level = v._level + card._level
      print("SoloModel:addCard card exist", v._level, card._cid, card._level)
      isExist = true
      break
    end
  end
  if not isExist then
    table.insert(self.allCardList, card)
  end
  local cid = card._cid
  local tbData = ed.getDataTable("SoloCardSkill")[cid]
  if tbData.Tag1 ~= 0 then
    self.factions[tbData.Tag1]:addCard(card)
  end
  if tbData.Tag2 ~= 0 then
    self.factions[tbData.Tag2]:addCard(card)
  end
end

function SoloModel:clearData()
  self:initData()
end

function SoloModel:setPlayerList(users)
  if type(users) ~= "table" then
    return
  end
  self.playerList = {}
  for i = 1, #users do
    local summary = users[i]
    local SkillPlayer = SkillPlayer.create(summary)
    table.insert(self.playerList, SkillPlayer)
  end
end

function SoloModel:getCardLevel(card)
  local tag = ed.getDataTable("SoloCardSkill")[card._cid].Tag1
  local faction = ed.SoloModel.factions[tag]
  local level = faction:getCardLevel(card._cid) or 0
  return level
end

function SoloModel:updateFaction(data)
  self.factions[data._faction]:updateExpAndLevel(data._exp, data._level)
end

function SoloModel:updateOppoUser(data)
  self:updatePlayerHp(data._user_key, data._hp)
  self:updatePlayerLevel(data._user_key, data._level)
  self:updatePlayerStatus(data._user_key, data._status)
  self:updateTotalHp(data._user_key, data._max_hp)
  self:updatePlayerDamage(data._user_key, data._damage)
  if data._hero_id then
    self:updatePlayerHeroId(data._user_key, data._hero_id)
  end
  self:updateBattleGroup(data._user_key, data._battle_group)
end

function SoloModel:updatePlayerHp(userKey, hp, isBy)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      if isBy then
        hp = skillPlayer:getCurHp() + hp
      end
      skillPlayer:updateCurHp(hp)
      break
    end
  end
end

function SoloModel:updateTotalHp(userKey, hp)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updateTotalHp(hp)
      break
    end
  end
end

function SoloModel:updateBattleGroup(userKey, group)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updateBattleGroup(group)
      break
    end
  end
end

function SoloModel:checkPlayerHurt(userKey, hp)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      local lastHp = skillPlayer:getCurHp()
      return hp < lastHp, lastHp - hp
    end
  end
  return false
end

function SoloModel:updatePlayerPower(userKey, power, pos)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updatePower(power, pos)
      break
    end
  end
end

function SoloModel:getPlayerPowers(userKey)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      return skillPlayer:getPowers()
    end
  end
end

function SoloModel:getMySelfLevel()
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, ed.SkillPlayer.getMyUserKey()) then
      return skillPlayer:getLevel()
    end
  end
end

function SoloModel:updatePlayerLevel(userKey, level)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updateLevel(level)
      break
    end
  end
end

function SoloModel:updatePlayerStatus(userKey, state)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updateState(state)
      break
    end
  end
end

function SoloModel:updatePlayerPowers(userKey, powers)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:setPowers(powers)
      break
    end
  end
end

function SoloModel:updatePlayerHeroId(userKey, heroId)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:setHeroId(heroId)
      break
    end
  end
end

function SoloModel:updatePlayerDamage(userKey, damage)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:setDamage(damage)
      break
    end
  end
end

function SoloModel:updatePlayerTeam(userKey, team)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updateTeam(team)
      break
    end
  end
end

function SoloModel:updatePlayerState(userKey, state)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      skillPlayer:updateState(state)
      break
    end
  end
end

function SoloModel:getsoloPlayerByKey(userKey)
  for _, skillPlayer in ipairs(self.playerList) do
    local tempKey = skillPlayer:getUserKey()
    if ed.SkillPlayer.isUserKeyEqual(tempKey, userKey) then
      return skillPlayer
    end
  end
end

function SoloModel:sortPlayerList()
  table.sort(self.playerList, ed.cmpSort({
    {
      getValue = function(player)
        return player:getBattleGroup()
      end,
      reverse = true
    },
    {
      getValue = function(player)
        return player:getCurHp()
      end,
      reverse = true
    },
    {
      getValue = function(player)
        return player:getUserKey()._user_id
      end
    }
  }))
  FireEvent("SoloPlayerUpdate")
end

function SoloModel:getPlayerList()
  return self.playerList
end

function SoloModel:setTeamMaxHp(maxHp)
  self.maxHp = maxHp
end

function SoloModel:setFactions(factions)
  self.factions = {}
  for k, fid in ipairs(factions) do
    self.factions[fid] = ed.SoloFaction.create(fid)
  end
end

function SoloModel:setFrozonFactions(factions)
  self.frozonFactions = factions
end

function SoloModel:getTeamMaxHp()
  return self.maxHp or 50
end

function SoloModel:setupShopCardList(data)
  self.shopCardList = data or {}
end

function SoloModel:setupRefreshCost(data)
  self.refreshCost = data
end

function SoloModel:setupRandomCost(data)
  self.randomCost = data
end

function SoloModel:getAllFactions()
  local cardFactions = {}
  for k, v in pairs(self.factions) do
    if v.level > 0 then
      table.insert(cardFactions, {
        _faction = v.id,
        _level = v.level
      })
    end
  end
  return cardFactions
end

function SoloModel:updateHero(heroData)
  self.heroId = heroData._hid
  self._powers = heroData._powers
end

function SoloModel:getPowers()
  return self._powers or {}
end

function SoloModel:getHeroId()
  return self.heroId
end

function SoloModel:setBattleTeam(data)
  if type(data) == "table" then
    if data._hero then
      self:updateHero(data._hero)
    end
    for k, v in pairs(self.factions) do
      v.cardList = {}
    end
    self.allCardList = {}
    for k, v in ipairs(data._cards or {}) do
      self:addCard(v)
    end
    for k, v in ipairs(data._factions or {}) do
      self:updateFaction(v)
    end
  end
end

function SoloModel:setOppoType(type)
  self.oppoType = type
end

function SoloModel:getOppoType()
  return self.oppoType
end

function SoloModel:setPrepareEndTime(time)
  self.endTime = time or 0
end

function SoloModel:getWaitEndTime()
  return self.waitEndTime
end

function SoloModel:setWaitEndTime(time)
  self.waitEndTime = time or 0
end

function SoloModel:setWaitChooseTime(time)
  self.waitChooseTime = time or 0
end

function SoloModel:getPrepareEndTime()
  return self.endTime
end

function SoloModel:setOverEndTime(time)
  self.overEndTime = time or 0
end

function SoloModel:getOverEndTime()
  return self.overEndTime
end

function SoloModel:setCombo(combo)
  self.combo = combo
end

function SoloModel:getCombo()
  return self.combo or 0
end

function SoloModel:setTotalGold(gold)
  self.totalGold = gold
  FireEvent("SoloUpdateGold")
end

function SoloModel:setHeroPowerCD(cd)
  self.heroPowerCD = cd
end

function SoloModel:updateTotalGold(type, gold)
  if type == "add" then
    self.totalGold = self.totalGold + gold
  elseif type == "minus" then
    self.totalGold = math.max(0, self.totalGold - gold)
  end
end

function SoloModel:getTotalGold()
  return self.totalGold
end

function SoloModel:setShopLock(lock)
  self.isLock = lock
end

function SoloModel:getShopLock()
  return self.isLock
end

function SoloModel:setWinGold(winGold)
  self.winGold = winGold
end

function SoloModel:getWinGold()
  return self.winGold or 0
end

function SoloModel:setBattleLimit(limit)
  self.limit = limit
end

function SoloModel:getBattleLimit()
  return self.limit
end

function SoloModel:setBattleRound(round)
  self.round = round
end

function SoloModel:getBattleRound()
  return self.round
end

function SoloModel:setGainGold(gainGold)
  self.gainGold = gainGold
end

function SoloModel:getGainGold()
  return self.gainGold
end

function SoloModel:setBattleEvents(events)
  if type(events) ~= "table" then
    return
  end
  self:clearBattleEvents()
  for i = 1, #events do
    local event = events[i]
    local tick = math.floor(event._time / 1000)
    local key = "tick_" .. tick
    if not self.battleEvents[key] then
      self.battleEvents[key] = {
        events = {},
        isCasted = false
      }
    end
    if event._start then
      local startEvent = event._start
      table.insert(self.battleEvents[key].events, {type = 1, event = startEvent})
    elseif event._over then
      local overEvent = event._over
      table.insert(self.battleEvents[key].events, {type = 2, event = overEvent})
    elseif event._combo then
      local comboEvent = event._combo
      table.insert(self.battleEvents[key].events, {type = 3, event = comboEvent})
    elseif event._block then
      local blockEvent = event._block
      table.insert(self.battleEvents[key].events, {type = 4, event = blockEvent})
    end
  end
  ed.pt(self.battleEvents, nil, nil, nil, 5)
end

function SoloModel:clearBattleEvents()
  self.battleEvents = {}
end

function SoloModel:getBattleEventByTick(tick)
  return self.battleEvents["tick_" .. tick]
end

function SoloModel:setBattleResult(result)
  self.battleResult = result
end

function SoloModel:getBattleResult()
  return self.battleResult
end

function SoloModel:isMySelfDead()
  return self.isDead
end

function SoloModel:setMySelfDead(isDead)
  self.isDead = isDead
end

function SoloModel:getLogByRound(roundId)
  return self.logs[roundId]
end

ed.SoloModel = SoloModel.create()
