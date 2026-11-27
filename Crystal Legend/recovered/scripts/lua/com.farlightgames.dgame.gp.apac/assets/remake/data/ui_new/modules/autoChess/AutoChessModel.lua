local ChessPet = {}
ChessPet.__index = ChessPet
ed.ChessPet = ChessPet

function ChessPet:getChessPetInsid()
  return self.insid
end

function ChessPet:getChessPetId()
  return self.petId
end

function ChessPet:getChessPetState()
  return self.state
end

function ChessPet:setChessPetState(state)
  if state == "on" or state == "off" then
    self.state = state
  end
end

function ChessPet:setChessPetMaster(heroSid)
  self.master = heroSid
end

function ChessPet:getChessPetMaster()
  return self.master
end

function ChessPet:isEquiped()
  return self.state == "on"
end

function ChessPet:initData(petData)
  self.insid = petData._insid
  self.petId = petData._pid
  self.state = "off"
  self.master = nil
end

function ChessPet.create(petData)
  local object = {}
  setmetatable(object, ChessPet)
  object:initData(petData)
  return object
end

local ChessHero = {}
ChessHero.__index = ChessHero
ed.ChessHero = ChessHero

function ChessHero:getChessId()
  return self.hid
end

function ChessHero:updateHeroId(hid)
  self.hid = hid
end

function ChessHero:getHeroInsid()
  return self.insid
end

function ChessHero:getHeroStar()
  local rank = ed.getChessUnitStar(self.hid)
  return rank
end

function ChessHero:getHeroInitPrice()
  local unitInfo = ed.getDataTable("ChessUnit")[self.hid]
  local heroId = unitInfo["Hero ID"]
  local price = ed.getChessUnitBuyPrice(heroId)
  return price
end

function ChessHero:setState(state)
  self.state = state
end

function ChessHero:getState()
  return self.state
end

function ChessHero:equipChessPet(type, chessPet)
  if type == "on" then
    if chessPet then
      self.chessPet = chessPet
    end
  else
    self.chessPet = nil
  end
end

function ChessHero:getEquipChessPet()
  return self.chessPet
end

function ChessHero:getSoldPrice()
  local price = ed.getChessUnitBuyPrice(self.hid)
  return price
end

function ChessHero:setChessSold(isSold)
  self.isSold = isSold
end

function ChessHero:isChessSold()
  return self.isSold or false
end

function ChessHero:initData(hero, isShop)
  self.hid = hero._hid
  self.insid = hero._insid
  if not isShop then
    if hero._pet then
      local chessPet = ed.ChessPet.create(hero._pet)
      self.chessPet = chessPet
    end
    self.state = 1
  else
    self.isSold = hero._sold == 1 or false
  end
end

function ChessHero.create(hero, isShop)
  local object = {}
  setmetatable(object, ChessHero)
  object:initData(hero, isShop)
  return object
end

local ChessPlayer = {}
ChessPlayer.__index = ChessPlayer
ed.ChessPlayer = ChessPlayer

function ChessPlayer.create(data)
  local object = {}
  setmetatable(object, ChessPlayer)
  object:initData(data)
  return object
end

function ChessPlayer:initData(data)
  self._userKey = data._user_key
  self._userSummary = data._user_summary
  self._userPlatform = data._plat
  self._showServerId = data._show_server_id
  self._state = 1
  self._curHp = data._hp or 0
  self._level = data._level or 1
  self._totalHp = 50
  self._team = nil
end

function ChessPlayer:getUserKey()
  return self._userKey
end

function ChessPlayer:getUserSummary()
  return self._userSummary
end

function ChessPlayer:getUserPlatform()
  return self._userPlatform
end

function ChessPlayer:getUserShowServer()
  return self._showServerId
end

function ChessPlayer:getCurHp()
  return self._curHp
end

function ChessPlayer:updateCurHp(hp, isBy)
  if isBy then
    self._curHp = self._curHp + hp
  else
    self._curHp = hp
  end
end

function ChessPlayer:getTotalHp()
  return self._totalHp
end

function ChessPlayer:updateTotalHp(totalHp)
  self._totalHp = totalHp
end

function ChessPlayer:updateLevel(level)
  self._level = level
end

function ChessPlayer:getLevel()
  return self._level
end

function ChessPlayer:updateTeam(team)
  self._team = team
end

function ChessPlayer:getTeam()
  return self._team
end

function ChessPlayer:updateState(state)
  self._state = state
end

function ChessPlayer:getState()
  return self._state
end

function ChessPlayer:setPowers(powers)
  self._powers = powers
end

function ChessPlayer:updatePower(power, pos)
  self._powers = self._powers or {}
  self._powers[pos] = power
end

function ChessPlayer:getPowers()
  return self._powers
end

function ChessPlayer:isMySelf()
  return self._userKey._user_id == ed.getUserid() and self._userKey._server_id == tonumber(game_server_id)
end

function ChessPlayer.getMyUserKey()
  local userKey = ed.commonmsg.chess_user_key()
  userKey._user_id = ed.getUserid()
  userKey._server_id = tonumber(game_server_id)
  return userKey
end

function ChessPlayer.isUserKeyEqual(key1, key2)
  return key1._user_id == key2._user_id and key1._server_id == key2._server_id
end

local AutoChessModel = {LEVELEXP = 4, LEVELGOLD = 4}
AutoChessModel.__index = AutoChessModel

function AutoChessModel.create()
  local object = {}
  setmetatable(object, AutoChessModel)
  object:initData()
  return object
end

function AutoChessModel:initTagData()
  self.tagParam = {}
  for slot, groups in pairs(ed.getDataTable("ChessSkillGroup")[100001]) do
    for tag, group in pairs(groups) do
      if not self.tagParam[tag] then
        self.tagParam[tag] = {}
      end
      table.insert(self.tagParam[tag], {
        level = group["Chess Skill Level"],
        min = group["Tag Count"][1],
        max = group["Tag Count"][2],
        desc = group["Chess Growth 1 Summary"]
      })
    end
  end
  for _, tagList in pairs(self.tagParam) do
    table.sort(tagList, function(a, b)
      return a.level < b.level
    end)
  end
end

function AutoChessModel:initData()
  self.playerList = {}
  self.shopHeroList = {}
  self.chessHeroList = {
    slot_1 = nil,
    slot_2 = nil,
    slot_3 = nil,
    slot_4 = nil,
    slot_5 = nil,
    slot_6 = nil,
    slot_7 = nil,
    slot_8 = nil
  }
  self.totalHeroList = {}
  self.battleHeroData = {}
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
  self.selfTeamData = {
    heroes = {},
    positions = {}
  }
  self.oppoTeamData = {
    heroes = {},
    positions = {}
  }
  self.battleEvents = {}
  self.dropPetData = {}
  self.battleLootPets = {}
  if ed.chess_debug_mode then
    self:testPlayerList()
    self:testPetList()
    self:setupShopHeroList({
      {_insid = 1, _hid = 101},
      {_insid = 2, _hid = 101},
      {_insid = 3, _hid = 101},
      {_insid = 4, _hid = 101},
      {_insid = 5, _hid = 101}
    })
    self.totalGold = 100
  end
  self.tagParam = {}
  self:initTagData()
end

function AutoChessModel:getTagNumByType(type)
  return self.tagParam[type]
end

function AutoChessModel:clearData()
  self:initData()
end

function AutoChessModel:setPlayerList(users)
  if type(users) ~= "table" then
    return
  end
  self.playerList = {}
  for i = 1, #users do
    local summary = users[i]
    local chessPlayer = ChessPlayer.create(summary)
    table.insert(self.playerList, chessPlayer)
  end
  self:sortPlayerList()
end

function AutoChessModel:testPlayerList()
  local userData = {
    {
      _user_key = {_server_id = 60001, _user_id = 10},
      _user_summary = {
        _avatar = 10,
        _vip = 0,
        _name = "\230\181\139\232\175\149\231\142\169\229\174\1821"
      },
      _plat = 1,
      _show_server_id = 1,
      _hp = 50
    },
    {
      _user_key = {_server_id = 60001, _user_id = 12},
      _user_summary = {
        _avatar = 10,
        _vip = 2,
        _name = "\230\181\139\232\175\149\231\142\169\229\174\1822"
      },
      _plat = 1,
      _show_server_id = 1,
      _hp = 50
    },
    {
      _user_key = {_server_id = 60001, _user_id = 13},
      _user_summary = {
        _avatar = 10,
        _name = "\230\181\139\232\175\149\231\142\169\229\174\1823",
        _vip = 10
      },
      _plat = 1,
      _show_server_id = 1,
      _hp = 50
    },
    {
      _user_key = {_server_id = 60001, _user_id = 14},
      _user_summary = {
        _avatar = 10,
        _name = "\230\181\139\232\175\149\231\142\169\229\174\1824",
        _vip = 10
      },
      _plat = 1,
      _show_server_id = 1,
      _hp = 50
    }
  }
  if type(userData) ~= "table" then
    return
  end
  self.playerList = {}
  for i = 1, #userData do
    local summary = userData[i]
    local chessPlayer = ChessPlayer.create(summary)
    table.insert(self.playerList, chessPlayer)
  end
  self:sortPlayerList()
end

function AutoChessModel:testPetList()
  if ed.chess_debug_mode then
    local testPetData = {
      {_insid = 100, _pid = 300001},
      {_insid = 101, _pid = 300002},
      {_insid = 102, _pid = 300003},
      {_insid = 103, _pid = 300004},
      {_insid = 104, _pid = 300005},
      {_insid = 105, _pid = 300006},
      {_insid = 106, _pid = 300007},
      {_insid = 107, _pid = 300008},
      {_insid = 108, _pid = 300009},
      {_insid = 109, _pid = 300010},
      {_insid = 110, _pid = 300011}
    }
    for _, petData in ipairs(testPetData) do
      local chessPet = ChessPet.create(petData)
      table.insert(self.dropPetData, chessPet)
    end
  end
end

function AutoChessModel:updatePlayerHp(userKey, hp, isBy)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:updateCurHp(hp, isBy)
      break
    end
  end
end

function AutoChessModel:updateTotalHp(userKey, hp)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      print("<<<<<<<<<<<<<<  AutoChessModel:updatePlayerHp >>>>>>>>>>> " .. hp)
      chessPlayer:updateTotalHp(hp)
      break
    end
  end
end

function AutoChessModel:checkPlayerHurt(userKey, hp)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      print("<<<<<<<<<<<<<<  AutoChessModel:checkPlayerHurt >>>>>>>>>>> " .. hp)
      local lastHp = chessPlayer:getCurHp()
      return hp < lastHp, lastHp - hp
    end
  end
  return false
end

function AutoChessModel:updatePlayerPower(userKey, power, pos)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:updatePower(power, pos)
      break
    end
  end
end

function AutoChessModel:getPlayerPowers(userKey)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      return chessPlayer:getPowers()
    end
  end
end

function AutoChessModel:updatePlayerLevel(userKey, level)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:updateLevel(level)
      break
    end
  end
end

function AutoChessModel:updatePlayerStatus(userKey, state)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:updateState(state)
      break
    end
  end
end

function AutoChessModel:updatePlayerPowers(userKey, powers)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:setPowers(powers)
      break
    end
  end
end

function AutoChessModel:updatePlayerTeam(userKey, team)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:updateTeam(team)
      break
    end
  end
end

function AutoChessModel:updatePlayerState(userKey, state)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      chessPlayer:updateState(state)
      break
    end
  end
end

function AutoChessModel:getChessPlayerByKey(userKey)
  for _, chessPlayer in ipairs(self.playerList) do
    local tempKey = chessPlayer:getUserKey()
    if ed.ChessPlayer.isUserKeyEqual(tempKey, userKey) then
      return chessPlayer
    end
  end
end

function AutoChessModel:sortPlayerList()
  table.sort(self.playerList, function(a, b)
    local hpA = a:getCurHp()
    local hpB = b:getCurHp()
    if hpA ~= hpB then
      return a:getCurHp() > b:getCurHp()
    else
      return a:getUserKey()._user_id > b:getUserKey()._user_id
    end
  end)
end

function AutoChessModel:getPlayerList()
  return self.playerList
end

function AutoChessModel:setTeamMaxHp(maxHp)
  self.maxHp = maxHp
end

function AutoChessModel:getTeamMaxHp()
  return self.maxHp or 50
end

function AutoChessModel:setupShopHeroList(data)
  if type(data) == "table" then
    self.shopHeroList = {}
    for i = 1, #data do
      local heroData = data[i]
      local chessHero = ChessHero.create(heroData, true)
      self.shopHeroList["slot_" .. i] = chessHero
    end
  end
end

function AutoChessModel:getShopHeroList()
  return self.shopHeroList
end

function AutoChessModel:updateShopHeroState(insid, sold)
  for k, shopHero in pairs(self.shopHeroList) do
    if shopHero:getHeroInsid() == insid then
      shopHero:setChessSold(sold)
      break
    end
  end
end

function AutoChessModel:getShopHeroBySlot(slot)
  return self.shopHeroList["slot_" .. slot]
end

function AutoChessModel:updateSlotHero(type, slot, insid)
  if type == "delete" then
    self.chessHeroList["slot_" .. slot] = nil
  elseif type == "update" or type == "new" then
    self.chessHeroList["slot_" .. slot] = insid
  end
end

function AutoChessModel:getChessHeroByIndex(index)
  return self.chessHeroList["slot_" .. index]
end

function AutoChessModel:isSlotExistSameChess(heroSid)
  for index = 1, 8 do
    local slotSid = self.chessHeroList["slot_" .. index]
    if slotSid and slotSid == heroSid then
      return true
    end
  end
  local battleData = self:getBattleHeroData()
  for _, battleHero in pairs(battleData) do
    if heroSid == battleHero.heroSid then
      return true
    end
  end
  return false
end

function AutoChessModel:getChessHeroList()
  return self.chessHeroList
end

function AutoChessModel:getChessHeroBySid(insid)
  for _, chessHero in pairs(self.totalHeroList) do
    if insid == chessHero:getHeroInsid() then
      return chessHero
    end
  end
  return nil
end

function AutoChessModel:setupTotalHeroList(data)
  if type(data) == "table" then
    self.totalHeroList = {}
    for i = 1, #data do
      local heroData = data[i]
      local chessHero = ChessHero.create(heroData, false)
      self.totalHeroList["sid_" .. heroData._insid] = chessHero
      if heroData._pet then
        local isValid = true
        local newPet = ChessPet.create(heroData._pet, false)
        local insid = newPet:getChessPetInsid()
        for _, chessPet in pairs(self.dropPetData) do
          if insid == chessPet:getChessPetInsid() then
            isValid = false
          end
        end
        if isValid then
          newPet:setChessPetState("on")
          newPet:setChessPetMaster(heroData._insid)
          table.insert(self.dropPetData, newPet)
        end
      end
    end
  end
end

function AutoChessModel:getTotalHeroList()
  return self.totalHeroList
end

function AutoChessModel:isSlotFull()
  for i = 1, 9 do
    if self.chessHeroList["slot_" .. i] == nil then
      return false
    end
  end
  return true
end

function AutoChessModel:getFreeSlot()
  for i = 1, 8 do
    if self.chessHeroList["slot_" .. i] == nil then
      return i
    end
  end
end

function AutoChessModel:updateTotalHero(type, hero)
  if type == "delete" then
    local heroSid = hero
    for sidKey, chessHero in pairs(self.totalHeroList) do
      if heroSid == chessHero:getHeroInsid() then
        self.totalHeroList[sidKey] = nil
        return true
      end
    end
  elseif type == "update" then
    for _, chessHero in pairs(self.totalHeroList) do
      if hero._insid == chessHero:getHeroInsid() then
        chessHero:updateHeroId(hero._hid)
        return false
      end
    end
  elseif type == "new" then
    local insid = hero:getHeroInsid()
    for _, chessHero in pairs(self.totalHeroList) do
      if insid == chessHero:getHeroInsid() then
        return false
      end
    end
    local freeSlot = self:getFreeSlot()
    self.totalHeroList["sid_" .. insid] = hero
    return true, hero, freeSlot
  end
  return false
end

function AutoChessModel:getDropPetBySid(insid)
  for i = 1, #self.dropPetData do
    local chessPet = self.dropPetData[i]
    if chessPet:getChessPetInsid() == insid then
      return chessPet
    end
  end
end

function AutoChessModel:getDropPetByMaster(insid)
  for i = 1, #self.dropPetData do
    local chessPet = self.dropPetData[i]
    if chessPet:getChessPetMaster() == insid then
      return chessPet
    end
  end
end

function AutoChessModel:getDropPetData()
  return self.dropPetData
end

function AutoChessModel:updateDropPetBag(data)
  if type(data) ~= "table" then
    return
  end
  for k, petData in pairs(data) do
    local isValid = true
    local newPet = ChessPet.create(petData, false)
    local insid = newPet:getChessPetInsid()
    for _, chessPet in pairs(self.dropPetData) do
      if insid == chessPet:getChessPetInsid() then
        isValid = false
      end
    end
    if isValid then
      table.insert(self.dropPetData, newPet)
    end
  end
end

function AutoChessModel:setupDropPetList(data)
  self.dropPetData = {}
  if type(data) == "table" then
    for i = 1, #data do
      local petData = data[i]
      local newPet = ChessPet.create(petData)
      newPet:setChessPetState("off")
      newPet:setChessPetMaster()
      table.insert(self.dropPetData, newPet)
    end
  end
end

function AutoChessModel:setBattleLootPets(data)
  self.battleLootPets = {}
  if type(data) == "table" then
    for i, loot in ipairs(data) do
      local heroSid = loot._hero_insid
      local petData = loot._pet
      self.battleLootPets["loot_" .. heroSid] = {loot = petData, index = i}
    end
  end
end

function AutoChessModel:getBattleLootPet(insid)
  return self.battleLootPets["loot_" .. insid]
end

function AutoChessModel:getEquipPetNum()
  local equipNum = 0
  for i = 1, #self.dropPetData do
    local chessPet = self.dropPetData[i]
    if chessPet:isEquiped() then
      equipNum = equipNum + 1
    end
  end
  return equipNum
end

AutoChessModel.posTransform = {
  indexToPos = {
    id_1 = "1_3",
    id_2 = "2_3",
    id_3 = "3_3",
    id_4 = "4_3",
    id_5 = "1_2",
    id_6 = "2_2",
    id_7 = "3_2",
    id_8 = "4_2",
    id_9 = "1_1",
    id_10 = "2_1",
    id_11 = "3_1",
    id_12 = "4_1"
  },
  posToIndex = {
    ["1_1"] = 9,
    ["2_1"] = 10,
    ["3_1"] = 11,
    ["4_1"] = 12,
    ["1_2"] = 5,
    ["2_2"] = 6,
    ["3_2"] = 7,
    ["4_2"] = 8,
    ["1_3"] = 1,
    ["2_3"] = 2,
    ["3_3"] = 3,
    ["4_3"] = 4
  }
}

function AutoChessModel:setBattleTeam(data)
  if type(data) == "table" then
    local heroes = data._heroes or {}
    local positions = data._positions or {}
    self.battleHeroData = {}
    for i = 1, #heroes do
      local heroData = heroes[i]
      local posIndex = positions[i]
      local battleHero = ed.ChessHero.create(heroData, false)
      self:updateBattleHeroData("on", {
        pos = posIndex,
        heroSid = heroData._insid
      })
      battleHero:setState(2)
      self:updateTotalHero("new", battleHero)
      if heroData._pet then
        local isValid = true
        local newPet = ChessPet.create(heroData._pet, false)
        local insid = newPet:getChessPetInsid()
        for _, chessPet in pairs(self.dropPetData) do
          if insid == chessPet:getChessPetInsid() then
            isValid = false
          end
        end
        if isValid then
          newPet:setChessPetState("on")
          newPet:setChessPetMaster(heroData._insid)
          table.insert(self.dropPetData, newPet)
        end
      end
    end
  end
end

function AutoChessModel:updateBattleHeroData(type, data)
  local posIndex = data.pos
  local heroSid = data.heroSid
  if type == "on" then
    self.battleHeroData["id_" .. posIndex] = {heroSid = heroSid, posIndex = posIndex}
  else
    self.battleHeroData["id_" .. posIndex] = nil
  end
end

function AutoChessModel:getBattleHeroData()
  return self.battleHeroData
end

function AutoChessModel:getBattleHeroByPos(pos)
  local posIndex = pos
  return self.battleHeroData["id_" .. posIndex]
end

function AutoChessModel:setTeamLevel(level)
  self.level = level
end

function AutoChessModel:getTeamLevel()
  return self.level
end

function AutoChessModel:getTeamLimit()
  local levelData = ed.getDataTable("ChessPlayer")[self.level]
  return levelData["Maximum Number"]
end

function AutoChessModel:getTeamNeedExp()
  local levelData = ed.getDataTable("ChessPlayer")[self.level]
  if levelData then
    return levelData["Exp Need For Up"]
  end
  return 0
end

function AutoChessModel:setTeamExp(exp)
  self.exp = exp
end

function AutoChessModel:getTeamExp()
  return self.exp
end

function AutoChessModel:setOppoType(type)
  self.oppoType = type
end

function AutoChessModel:getOppoType()
  return self.oppoType
end

function AutoChessModel:setPrepareEndTime(time)
  self.endTime = time or 0
end

function AutoChessModel:getPrepareEndTime()
  return self.endTime
end

function AutoChessModel:setOverEndTime(time)
  self.overEndTime = time or 0
end

function AutoChessModel:getOverEndTime()
  return self.overEndTime
end

function AutoChessModel:setCombo(combo)
  self.combo = combo
end

function AutoChessModel:getCombo()
  return self.combo or 0
end

function AutoChessModel:setTotalGold(gold, isBy)
  if isBy then
    self.totalGold = self.totalGold + gold
  else
    self.totalGold = gold
  end
end

function AutoChessModel:setHeroPowerCD(cd)
  self.heroPowerCD = cd
end

function AutoChessModel:setSelectPowerIds(powerIds)
  self.selectPowerIds = powerIds
end

function AutoChessModel:updateTotalGold(type, gold)
  if type == "add" then
    self.totalGold = self.totalGold + gold
  elseif type == "minus" then
    self.totalGold = math.max(0, self.totalGold - gold)
  end
end

function AutoChessModel:getTotalGold()
  return self.totalGold
end

function AutoChessModel:setShopLock(lock)
  self.isLock = lock
end

function AutoChessModel:getShopLock()
  return self.isLock
end

function AutoChessModel:setWinGold(winGold)
  self.winGold = winGold
end

function AutoChessModel:getWinGold()
  return self.winGold or 0
end

function AutoChessModel:setBattleLimit(limit)
  self.limit = limit
end

function AutoChessModel:getBattleLimit()
  return self.limit
end

function AutoChessModel:setBattleRound(round)
  self.round = round
end

function AutoChessModel:getBattleRound()
  return self.round
end

function AutoChessModel:setGainGold(gainGold)
  self.gainGold = gainGold
end

function AutoChessModel:getGainGold()
  return self.gainGold
end

function AutoChessModel:setSelfTeamData(data)
  self.selfTeamData.heroes = nil
  self.selfTeamData.positions = nil
  if type(data) == "table" then
    self.selfTeamData.heroes = data._heroes
    self.selfTeamData.positions = data._positions
  end
end

function AutoChessModel:getSelfTeamData()
  return self.selfTeamData
end

function AutoChessModel:setOppoTeamData(data)
  self.oppoTeamData.heroes = data._heroes
  self.oppoTeamData.positions = data._positions
end

function AutoChessModel:getOppoTeamData()
end

function AutoChessModel:setBattleEvents(events)
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
end

function AutoChessModel:clearBattleEvents()
  self.battleEvents = {}
end

function AutoChessModel:getBattleEventByTick(tick)
  return self.battleEvents["tick_" .. tick]
end

function AutoChessModel:setBattleResult(result)
  self.battleResult = result
end

function AutoChessModel:getBattleResult()
  return self.battleResult
end

function AutoChessModel:isMySelfDead()
  return self.isDead
end

function AutoChessModel:setMySelfDead(isDead)
  self.isDead = isDead
end

function AutoChessModel:updateDropPetData(insid, state, heroSid)
  for i = 1, #self.dropPetData do
    local chessPet = self.dropPetData[i]
    if chessPet:getChessPetInsid() == insid then
      chessPet:setChessPetState(state)
      chessPet:setChessPetMaster(heroSid)
      break
    end
  end
end

ed.AutoChessModel = AutoChessModel.create()
