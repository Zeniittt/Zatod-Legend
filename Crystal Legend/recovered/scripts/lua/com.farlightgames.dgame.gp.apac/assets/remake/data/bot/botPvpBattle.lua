module("ed.bot", package.seeall)
BotpvpBattle = {}
BotpvpBattle.__index = BotpvpBattle
notArousalState = {_status = 0}

local function sortHeroes(list)
  local function attackRange(hid)
    local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
    
    return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
  end
  
  table.sort(list, function(a, b)
    return attackRange(a._tid) < attackRange(b._tid)
  end)
end

local function sortHeroesByWeight(list)
  table.sort(list, function(a, b)
    return a.weight > b.weight
  end)
end

function BotpvpBattle.create(info)
  local botpvp = {}
  setmetatable(botpvp, BotpvpBattle)
  if info._maxRank then
    ed.parameter.unit_max_rank = info._maxRank
  end
  botpvp:initParameter(info)
  botpvp:initData()
  return botpvp
end

function BotpvpBattle:initParameter(info)
  self.warschoolLevel = info._warschoolLevel
  self.bookReadingLevel = info._bookReadingLevel
  self.arenaLevel = info._arenaLevel
  self.generationNum = info._generationNum
  self.maxHeroId = info._maxHeroId
  self.heroStar = info._heroStar
  self.teamNumber = info._teamNumber
  self.variationProbability = info._variationProbability
  self.specifyHeroID = info._specifyHeroID
  self.heroAwake = info._awake
  self.heroSuperAwake = info._superAwake
  local cullHeros = {}
  for i, heroID in ipairs(info._cullHeroeIds) do
    cullHeros[heroID] = true
  end
  self.cullHeroeIds = cullHeros
  self.currentGeneration = 0
end

function BotpvpBattle:initData()
  local arenaLevel = self.arenaLevel
  local generationNum = self.generationNum
  if not arenaLevel or not generationNum then
    error("Arena level and Generation Num can't be empty")
    return false
  end
  self:initHeroList()
  self:initTeamList()
end

function BotpvpBattle:initHeroList()
  local heroList = {}
  local cullHeroeIds = self.cullHeroeIds
  for id, info in pairs(ed.getDataTable("Unit")) do
    if type(id) == "number" and id < self.maxHeroId and (id <= 100 or 10001 < id) and not cullHeroeIds[id] then
      local hero = {
        _tid = id,
        _level = self.arenaLevel,
        _stars = self.heroStar,
        _arousal = info["Can Awake"] and self.heroAwake or notArousalState,
        _hero_rune = self.heroSuperAwake,
        _name = info.Name
      }
      table.insert(heroList, hero)
    end
  end
  self.heroList = heroList
end

function BotpvpBattle:initTeamList()
  local teamList = {}
  local heroList = self.heroList
  math.randomseed(os.time())
  for teamIndex = 1, self.teamNumber do
    for heroIndex = 1, #heroList do
      heroList[heroIndex].weight = math.random()
    end
    sortHeroesByWeight(heroList)
    local team = {
      heroes = {
        heroList[1],
        heroList[2],
        heroList[3],
        heroList[4],
        heroList[5]
      },
      position = teamIndex,
      score = 0
    }
    if self.specifyHeroID then
      self:insertSpecifyHero(team)
    end
    sortHeroes(team.heroes)
    table.insert(teamList, team)
  end
  self.teamList = teamList
  self:insertSpecifyTeams()
end

function BotpvpBattle:insertSpecifyHero(team)
  local specifyHeroID = self.specifyHeroID
  local hasSpecifyHero = false
  for k = 1, #team.heroes do
    if team.heroes[k]._tid == specifyHeroID then
      hasSpecifyHero = true
      break
    end
  end
  local unitinfo = ed.lookupDataTable("Unit", nil, specifyHeroID)
  if not hasSpecifyHero then
    local hero = {
      _tid = specifyHeroID,
      _level = self.arenaLevel,
      _stars = self.heroStar,
      _arousal = unitinfo["Can Awake"] and self.heroAwake or notArousalState,
      _hero_rune = self.heroSuperAwake,
      _name = unitinfo.Name
    }
    local index = math.random(5)
    team.heroes[index] = hero
  end
end

function BotpvpBattle:insertSpecifyTeams()
  for id, info in pairs(ed.getDataTable("BotPVPTeams")) do
    if type(id) == "number" then
      local pvpHeroes = {}
      for v = 1, 5 do
        local unitId = info["Hero ID " .. v]
        local unitInfo = ed.lookupDataTable("Unit", nil, unitId)
        local hero = {
          _tid = unitId,
          _level = self.arenaLevel,
          _star = self.heroStar,
          _arousal = unitInfo["Can Awake"] and self.heroAwake or notArousalState,
          _hero_rune = self.heroSuperAwake,
          _name = unitInfo.Name
        }
        table.insert(pvpHeroes, hero)
      end
      local team = {
        heroes = pvpHeroes,
        position = #self.teamList + 1,
        score = 0
      }
      sortHeroes(team.heroes)
      table.insert(self.teamList, team)
    end
  end
end

function BotpvpBattle:multiply()
  local teamList = self.teamList
  local sonTeamList = {}
  for i = 1, #teamList do
    local team = teamList[i]
    team.score = 0
    local son = self:breedGeneration(team)
    if not self:checkTeamEqual(son) then
      table.insert(sonTeamList, son)
    end
  end
  for i = 1, #sonTeamList do
    table.insert(teamList, sonTeamList[i])
  end
end

function BotpvpBattle:breedGeneration(team)
  local heroList = self.heroList
  local son = {
    heroes = {},
    score = 0
  }
  for j = 1, #team.heroes do
    local dice = math.random()
    if dice < self.variationProbability then
      local newHeroIndex = math.random(#heroList)
      son.heroes[j] = heroList[newHeroIndex]
    else
      son.heroes[j] = team.heroes[j]
    end
  end
  if self.specifyHeroID then
    self:insertSpecifyHero(son)
  end
  sortHeroes(son.heroes)
  return son
end

function BotpvpBattle:checkTeamEqual(team)
  local equal = false
  local teamList = self.teamList
  for j = 1, #team.heroes do
    for k = j + 1, #team.heroes do
      if team.heroes[j]._tid == team.heroes[k]._tid then
        equal = true
      end
    end
  end
  for t = 1, #teamList do
    local sum1 = 0
    local sum2 = 0
    for tt = 1, 5 do
      sum1 = sum1 + team.heroes[tt]._tid * team.heroes[tt]._tid
      sum2 = sum2 + teamList[t].heroes[tt]._tid * teamList[t].heroes[tt]._tid
    end
    if sum1 == sum2 then
      equal = true
      break
    end
  end
  return equal
end

function BotpvpBattle:amendTeamPosition()
  local teamList = self.teamList
  for i = 1, #teamList do
    teamList[i].position = i
  end
end

function BotpvpBattle:startOneGenerationPvp()
  self.currentGeneration = self.currentGeneration + 1
  if self.currentGeneration > self.generationNum then
    return nil
  end
  local teamList = self.teamList
  local teamA, teamB
  self:amendTeamPosition()
  self:multiply()
  local totalTime = 0
  local drawBout = 0
  local totalBout = 0
  for i = 1, #teamList do
    teamA = teamList[i]
    for j = i + 1, #teamList do
      teamB = teamList[j]
      local tickNum = self:startBattle(teamA, teamB)
      if 720 <= tickNum then
        drawBout = drawBout + 1
      end
      totalTime = totalTime + tickNum / 8
      totalBout = totalBout + 1
      print("startBattle ", i, j)
    end
  end
  table.sort(teamList, function(a, b)
    return a.score > b.score
  end)
  for i = #teamList, self.teamNumber + 1, -1 do
    teamList[i] = nil
  end
  local resultTeamList = self:serializeTeamList(teamList)
  local resultData = {
    teamList = resultTeamList,
    generation = self.currentGeneration,
    totalTime = totalTime,
    drawBout = drawBout,
    totalBout = totalBout
  }
  return resultData
end

function BotpvpBattle:serializeTeamList(teamList)
  local list = {}
  for i, team in ipairs(teamList) do
    local newTeam = self:serializeTeam(team)
    table.insert(list, newTeam)
  end
  return list
end

function BotpvpBattle:serializeTeam(team)
  local newTeam = {}
  local heroes = {}
  for i, hero in ipairs(team.heroes) do
    local newHero = self:serializeHero(hero)
    table.insert(heroes, newHero)
  end
  newTeam._heroes = heroes
  newTeam._position = team.position
  newTeam._score = team.score
  return newTeam
end

function BotpvpBattle:serializeHero(hero)
  local newHero = {}
  newHero._tid = hero._tid
  newHero._level = hero._level
  newHero._star = hero._stars
  newHero._awake = hero._arousal
  newHero._superAwake = hero._hero_rune
  newHero._name = hero._name
  return newHero
end

function BotpvpBattle:startBattle(teamA, teamB)
  local warschoolLevel = self.warschoolLevel
  local bookReadingLevel = self.bookReadingLevel
  local warschool
  local bookReadingLevel = {selfBookReadingLevel = bookReadingLevel, oppoBookReadingLevel = bookReadingLevel}
  ed.srand(os.time())
  ed.BattleParams = {
    teamB.heroes,
    teamA.heroes,
    os.time(),
    0
  }
  ed.engine:enterArena(teamB.heroes, teamA.heroes, true, true, warschool, bookReadingLevel)
  local tickNum = 0
  while ed.engine.running do
    ed.BattleParams[4] = tickNum
    ed.engine:tick()
    tickNum = tickNum + 1
  end
  local result = ed.engine.result_stars
  local winner = 0 < result and teamB or teamA
  winner.score = winner.score + 1
  return tickNum
end
