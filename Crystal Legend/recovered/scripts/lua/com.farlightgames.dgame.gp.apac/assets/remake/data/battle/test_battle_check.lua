local ed = ed
local TestBattleCheck = {}
local config = {
  stageId = -1,
  battleSpeed = 2,
  dreamlandStageId = nil,
  guildStageid = nil
}
local heroWeight = {
  [1] = 100,
  [2] = 100,
  [3] = 100,
  [4] = 100,
  [5] = 100,
  [6] = 100,
  [7] = 100,
  [8] = 100,
  [9] = 100,
  [10] = 100,
  [11] = 100,
  [12] = 100,
  [13] = 100,
  [14] = 100,
  [15] = 100,
  [16] = 100,
  [17] = 100,
  [18] = 100,
  [19] = 100,
  [20] = 100,
  [21] = 100,
  [22] = 100,
  [23] = 100,
  [24] = 100,
  [25] = 100,
  [26] = 100,
  [27] = 100,
  [28] = 100,
  [29] = 100,
  [30] = 100,
  [31] = 100,
  [32] = 100,
  [33] = 100,
  [34] = 100,
  [35] = 100,
  [36] = 100,
  [37] = 100,
  [38] = 100,
  [39] = 100,
  [40] = 100,
  [41] = 100,
  [42] = 100,
  [43] = 100,
  [44] = 100,
  [45] = 100,
  [46] = 100,
  [47] = 100,
  [48] = 100,
  [49] = 100,
  [50] = 100,
  [51] = 100,
  [52] = 100,
  [53] = 100,
  [54] = 100,
  [55] = 100,
  [56] = 100,
  [57] = 100,
  [58] = 100,
  [59] = 100,
  [60] = 100,
  [61] = 100,
  [62] = 100,
  [63] = 100,
  [64] = 100,
  [65] = 100,
  [66] = 100,
  [67] = 100,
  [68] = 100,
  [69] = 100,
  [70] = 100,
  [71] = 100,
  [72] = 100,
  [73] = 100,
  [74] = 100,
  [75] = 100,
  [76] = 100,
  [77] = 100,
  [78] = 100,
  [79] = 100,
  [80] = 100,
  [81] = 100,
  [82] = 100,
  [83] = 100,
  [84] = 100,
  [85] = 100,
  [86] = 100,
  [87] = 100,
  [88] = 100,
  [89] = 100,
  [90] = 100,
  [91] = 100,
  [92] = 100,
  [93] = 100,
  [94] = 100,
  [95] = 100,
  [96] = 100,
  [97] = 100,
  [98] = 100,
  [99] = 100,
  [10001] = 100,
  [10002] = 100,
  [10003] = 100,
  [10004] = 100,
  [10005] = 100,
  [10006] = 100,
  [10007] = 100,
  [10008] = 100,
  [10009] = 100,
  [10010] = 100,
  [10011] = 100,
  [10012] = 100,
  [10013] = 100,
  [10014] = 100,
  [10015] = 100,
  [10016] = 100,
  [10017] = 100,
  [10018] = 100,
  [10019] = 100,
  [10020] = 100,
  [10021] = 100,
  [10022] = 100,
  [10023] = 100,
  [10024] = 100,
  [10025] = 100,
  [10026] = 100,
  [10027] = 100,
  [10028] = 100,
  [10029] = 100,
  [10030] = 100,
  [10031] = 100,
  [10032] = 100,
  [10033] = 100,
  [10034] = 100,
  [10035] = 100,
  [10036] = 100,
  [10037] = 100,
  [10038] = 100,
  [10039] = 100,
  [10040] = 100,
  [10041] = 100,
  [10042] = 100,
  [10043] = 100,
  [10044] = 100
}

local function sortHeroes(list)
  table.sort(list, function(a, b)
    return a.maxRange < b.maxRange
  end)
end

function TestBattleCheck:new()
  self:init()
  return self
end

function TestBattleCheck:init()
  math.randomseed(os.time())
  ed.battleCheckSpeed = config.speed
  self.mode = "pvp", self:initHeroList()
end

function TestBattleCheck:initHeroList()
  local heroList = {}
  local all = ed.readhero.classify("prepare", "position")
  local totalWeight = 0
  for _, hero in pairs(all) do
    local id = hero._tid
    local weight = heroWeight[id]
    if weight then
      totalWeight = totalWeight + weight
      table.insert(heroList, hero)
    end
  end
  self.totalWeight = totalWeight
  self.heroList = heroList
end

function TestBattleCheck:battleCheckEnterStage(arg)
  if arg == "1" then
    self.mode = "pvp"
  elseif arg == "2" then
    self.mode = "guild"
  elseif arg == "3" then
    self.mode = "dreamland"
  else
    self.mode = "pvp"
  end
  self:enterBattle()
end

function TestBattleCheck:enterBattle()
  if self.mode == "pvp" then
    self:enterPvp()
  elseif self.mode == "guild" then
    self:enterGuild()
  elseif self.mode == "dreamland" then
    self:enterDreamland()
  end
end

function TestBattleCheck:enterPvp()
  local selfTeam = self:getRandomTeam()
  local oppoTeam = self:getRandomTeam()
  self.selfTeam = selfTeam
  self.oppoTeam = oppoTeam
  local stage = ed.lookupDataTable("Stage", nil, config.stageId)
  local battle = ed.lookupDataTable("Battle", nil, config.stageId, 1)
  local warSchoolLevel = 1
  local warschool
  local bookReadingLevels = {selfBookReadingLevel = 1, oppoBookReadingLevel = 1}
  self:seedRandom()
  local param = {
    type = "pvp",
    selfTeam = selfTeam,
    oppoTeam = oppoTeam,
    warschool = warschool,
    bookReadingLevels = bookReadingLevels
  }
  ed.engine:battleCheck(param)
  local extraInfo = {}
  extraInfo.battleCheckInfo = {
    battleCheckMode = "battle_check"
  }
  ed.scene:reset(stage, battle, extraInfo)
  ed.scene:setSpeedRate(config.battleSpeed)
  ed.replaceScene(ed.scene)
end

function TestBattleCheck:enterGuild()
  local stageid = config.guildStageid
  stageid = stageid or self:randomGuildStageid()
  self.stageid = stageid
  local selfTeam = self:getRandomTeam()
  self.selfTeam = selfTeam
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local warSchoolLevel = 1
  local warschool
  local bookReadingLevels = {selfBookReadingLevel = 1, oppoBookReadingLevel = 1}
  self:seedRandom()
  local param = {
    type = "guild",
    stageInfo = stage,
    selfTeam = selfTeam,
    warschool = warschool,
    bookReadingLevels = bookReadingLevels
  }
  ed.engine:battleCheck(param)
  local extraInfo = {}
  extraInfo.battleCheckInfo = {
    battleCheckMode = "battle_check"
  }
  ed.scene:reset(stage, battle, extraInfo)
  ed.scene:setSpeedRate(config.battleSpeed)
  ed.replaceScene(ed.scene)
end

function TestBattleCheck:randomGuildStageid()
  if not self.guildStageids then
    self.guildStageids = {}
    local battleTable = ed.getDataTable("Battle")
    for _, battles in pairs(battleTable) do
      if battles[1] and battles[1]["Stage Type"] == "guild" then
        table.insert(self.guildStageids, battles[1]["Stage ID"])
      end
    end
  end
  local random = math.random(1, #self.guildStageids)
  local stageid = self.guildStageids[random]
  return stageid
end

function TestBattleCheck:enterDreamland()
  local stageid = config.dreamlandStageId
  stageid = stageid or self:randomDreamlandStageid()
  self.stageid = stageid
  local selfTeam = self:getRandomTeam()
  self.selfTeam = selfTeam
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local warSchoolLevel = 1
  local warschool
  local bookReadingLevels = {selfBookReadingLevel = 1, oppoBookReadingLevel = 1}
  self:seedRandom()
  local param = {
    type = "dreamland",
    stageInfo = stage,
    selfTeam = selfTeam,
    warschool = warschool,
    bookReadingLevels = bookReadingLevels
  }
  ed.engine:battleCheck(param)
  local extraInfo = {}
  extraInfo.battleCheckInfo = {
    battleCheckMode = "battle_check"
  }
  ed.scene:reset(stage, battle, extraInfo)
  ed.scene:setSpeedRate(config.battleSpeed)
  ed.replaceScene(ed.scene)
end

function TestBattleCheck:randomDreamlandStageid()
  local dreamlandStageids = {
    20100,
    20101,
    20102,
    20103,
    20104,
    20105,
    20106,
    20107
  }
  local random = math.random(1, #dreamlandStageids)
  local stageid = dreamlandStageids[random]
  return stageid
end

function TestBattleCheck:seedRandom()
  local seed = math.random(1, 1000)
  self.seed = seed
  ed.srand(seed)
end

function TestBattleCheck:getRandomTeam()
  local team = {}
  local teamLen = 0
  while true do
    local hero = self:getRandomHero()
    local iscontain = false
    for _, teamHero in ipairs(team) do
      if teamHero._tid == hero._tid then
        iscontain = true
      end
    end
    if not iscontain then
      table.insert(team, hero)
      teamLen = teamLen + 1
    end
    if teamLen == 5 then
      break
    end
  end
  return team
end

function TestBattleCheck:getRandomHero()
  local randomWeight = math.random(1, self.totalWeight)
  local reduceWeight = 0
  for _, hero in ipairs(self.heroList) do
    local weight = heroWeight[hero._tid]
    local random = randomWeight - reduceWeight
    if weight >= random then
      return hero
    end
    reduceWeight = reduceWeight + weight
  end
end

ListenEvent("BattleCheckEnd", function(args)
  local mode = ed.testBattleCheck.mode
  if mode == "pvp" then
    local msg = ed.upmsg.test_battle_check()
    msg._type = "pvp"
    msg._result = args.result
    msg._rseed = ed.testBattleCheck.seed
    msg._self_heroes = {}
    msg._oppo_heroes = {}
    for _, hero in pairs(ed.testBattleCheck.selfTeam) do
      table.insert(msg._self_heroes, hero.data)
    end
    for _, hero in pairs(ed.testBattleCheck.oppoTeam) do
      table.insert(msg._oppo_heroes, hero.data)
    end
    msg._operations = args.operations
    msg._self_demage = args.selfDamage
    msg._oppo_demage = args.targetDamage
    msg._self_hero_hp_mp = args.selfHeroHpMp
    msg._oppo_hero_hp_mp = args.enemyHeroHpMp
    ed.send(msg, "test_battle_check")
  elseif mode == "guild" then
    local msg = ed.upmsg.test_battle_check()
    msg._type = "guild"
    msg._result = args.result
    msg._rseed = ed.testBattleCheck.seed
    msg._stage_id = ed.testBattleCheck.stageid
    msg._self_heroes = {}
    for _, hero in pairs(ed.testBattleCheck.selfTeam) do
      table.insert(msg._self_heroes, hero.data)
    end
    msg._operations = args.operations
    msg._self_demage = args.selfDamage
    msg._oppo_demage = args.targetDamage
    msg._self_hero_hp_mp = args.selfHeroHpMp
    msg._oppo_hero_hp_mp = args.enemyHeroHpMp
    ed.send(msg, "test_battle_check")
  elseif mode == "dreamland" then
    local msg = ed.upmsg.test_battle_check()
    msg._type = "dreamland"
    msg._result = args.result
    msg._rseed = ed.testBattleCheck.seed
    msg._stage_id = ed.testBattleCheck.stageid
    msg._self_heroes = {}
    for _, hero in pairs(ed.testBattleCheck.selfTeam) do
      table.insert(msg._self_heroes, hero.data)
    end
    msg._operations = args.operations
    msg._self_demage = args.selfDamage
    msg._oppo_demage = args.targetDamage
    msg._self_hero_hp_mp = args.selfHeroHpMp
    msg._oppo_hero_hp_mp = args.enemyHeroHpMp
    ed.send(msg, "test_battle_check")
  end
end)
ListenEvent("TestBattleCheckReply", function(params)
  print("====================TestBattleCheckReply=======================")
  if params._result == "honest" then
    print(">>>honest")
    ed.testBattleCheck:enterBattle()
  elseif params._result == "cheat" then
    print(">>>cheat")
    local msg_id = msg._battle_check_fail._checkid
    local mode = ed.engine:ctMode2String()
    ed.reportBattleLog(msg_id, mode)
    ed.showAlertDialog({
      text = "battle check result: cheat",
      buttonText = T("\233\128\128\229\135\186"),
      handler = function()
        ed.popScene()
      end
    })
  end
end)
return TestBattleCheck
