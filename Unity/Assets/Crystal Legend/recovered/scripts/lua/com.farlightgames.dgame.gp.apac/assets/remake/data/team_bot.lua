package.path = package.path .. ";./lib/?.lua;./lua/?.lua"

function ccc3()
end

require("edebug")
require("tools")
require("ui/awake/runetools")
require("pet/pet")
require("hero")
ed.enableBotMode = true
ed.enableMaxAttStrategy = true
ed.warschool = 9
ed.bookReadingLevel = 40
local getRuneInfoFunction = require("battle/bot_rune")
local getPetBagFunction = require("battle/bot_pet")
local arousal = {
  _status = 1,
  _str = 100,
  _int = 100,
  _agi = 100
}
local arousal2 = {
  _status = 0,
  _str = 100,
  _int = 100,
  _agi = 100
}
local arenaLevel = 100
local heroStar = 5
local useFieldId = 26
local _rune_info = {_status = 1}
local _pet_info1 = {
  _type_id = 100051,
  _evolve = 5,
  _heart = 5,
  _skill_levels = {100, 100}
}
local _pet_info2 = {
  _type_id = 100050,
  _evolve = 5,
  _heart = 5,
  _skill_levels = {100, 100}
}
local defaultSuperAwake = {
  _status = 1,
  _sun = 0,
  _moon = 0,
  _star = 0
}
local bot_parameter_list = {
  max_rank = 16,
  pvp = {
    arenaLevel = arenaLevel,
    heroAwake = arousal,
    heroStar = heroStar,
    tryTimes = 10000,
    inverse = 0,
    heroSuperAwake = defaultSuperAwake,
    myTeam = {
      {
        _tid = "ESTitan",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info1
      },
      {
        _tid = "TitanMS",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info1
      },
      {
        _tid = "TitanLoong",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info1
      },
      {
        _tid = "TitanJM",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info1
      },
      {
        _tid = "TitanHagibis",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info1
      }
    },
    enemyTeam = {
      {
        _tid = "ESTitan",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info2
      },
      {
        _tid = "TitanMS",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info2
      },
      {
        _tid = "TitanLoong",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info2
      },
      {
        _tid = "TitanJM",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info2
      },
      {
        _tid = "TitanHagibis",
        _level = arenaLevel,
        _stars = 10,
        _arousal = arousal2,
        _hero_rune = _rune_info,
        _pet = _pet_info2
      }
    }
  }
}
xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  CCNode = {}
  CCSprite = {}
  ed.HpBar = {}
  EDLog = log
  require("resource_manager")
  require("datatable")
  require("battle/edp")
  require("battle/battle_engine")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/unittable")
  require("gamedatatables/rechargemetatable")
  require("gamedatatables/herotasktable")
  require("gamedatatables/challengetable")
  require("gamedatatables/SkillGrouptable")
  require("ui/tarot/TarotModel")
  require("asyncload")
  if bot_parameter_list.max_rank then
    ed.parameter.unit_max_rank = bot_parameter_list.max_rank
  end
  
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
    end
    
    local function sortCondition(a, b)
      if a._tid ~= b._tid and attackRange(a._tid) == attackRange(b._tid) then
        print("id:" .. a._tid .. " and id:" .. b._tid .. " has equal attack range.")
        debug.debug()
      end
      return attackRange(a._tid) < attackRange(b._tid)
    end
    
    table.sort(list, sortCondition)
  end
  
  local function pvp_main(arenaLevel, tryTimes)
    if not arenaLevel then
      print("Arena level = ? ")
      arenaLevel = io.read("*n")
    end
    if not tryTimes then
      print("Try Times = ? ")
      tryTimes = io.read("*n")
    end
    local myTeam = {
      heroes = bot_parameter_list.pvp.myTeam
    }
    local enemyTeam = {
      heroes = bot_parameter_list.pvp.enemyTeam
    }
    for id, info in pairs(ed.getDataTable("Unit")) do
      for i = 1, #myTeam do
        if myTeam[i]._tid == ed.lookupDataTable("Unit", "Name", id) then
          myTeam[i]._hero_rune = getRuneInfoFunction(myTeam[i]._tid, _rune_info)
          if not ed.lookupDataTable("Unit", "Can Awake", id) then
            myTeam[i]._arousal = {_status = 0}
          end
          if not ed.lookupDataTable("Unit", "Can Awake2", id) then
            myTeam[i]._hero_rune = {_status = 0}
          end
          if myTeam[i]._pet then
            myTeam[i]._pet_bag = getPetBagFunction(myTeam[i]._tid)
          end
        end
      end
      for i = 1, #enemyTeam do
        if enemyTeam[i]._tid == ed.lookupDataTable("Unit", "Name", id) then
          enemyTeam[i]._hero_rune = getRuneInfoFunction(enemyTeam[i]._tid, _rune_info)
          if not ed.lookupDataTable("Unit", "Can Awake", id) then
            enemyTeam[i]._arousal = {_status = 0}
          end
          if not ed.lookupDataTable("Unit", "Can Awake2", id) then
            enemyTeam[i]._hero_rune = {_status = 0}
          end
          if myTeam[i]._pet then
            myTeam[i]._pet_bag = getPetBagFunction(myTeam[i]._tid)
          end
        end
      end
    end
    if bot_parameter_list.pvp.inverse == 1 then
      local temp = myTeam
      myTeam = enemyTeam
      enemyTeam = temp
    end
    myTeam.score = 0
    enemyTeam.score = 0
    sortHeroes(myTeam.heroes)
    sortHeroes(enemyTeam.heroes)
    local winSeeds = {}
    local loseSeeds = {}
    local drawSeeds = {}
    local startSeed = bot_parameter_list.pvp.specifyRandSeed
    if startSeed then
      ed.srand(startSeed)
    else
      ed.srand(os.time())
    end
    local seed_list = {}
    for t = 1, tryTimes do
      seed_list[t] = math.floor(t / tryTimes * 1000)
    end
    for t = 1, tryTimes do
      local curSeed = seed_list[t]
      ed.srand(curSeed)
      local teamA = myTeam
      local teamB = enemyTeam
      ed.engine:enterArena(teamA.heroes, teamB.heroes, true, true, nil, 0, nil, useFieldId)
      local tickNum = 0
      while ed.engine.running do
        ed.engine:tick()
        tickNum = tickNum + 1
      end
      local result
      if 720 <= tickNum then
        result = "draw"
        drawSeeds[#drawSeeds + 1] = curSeed
      elseif 0 < ed.engine.result_stars then
        result = "win"
        teamA.score = teamA.score + 1
        winSeeds[#winSeeds + 1] = curSeed
      else
        result = "lose"
        teamB.score = teamB.score + 1
        loseSeeds[#loseSeeds + 1] = curSeed
      end
      print(t .. " " .. result .. " | " .. myTeam.score / t * 100 .. "% : " .. enemyTeam.score / t * 100 .. "%")
    end
    print()
    print("Win Seeds(" .. #winSeeds .. "):")
    local str = ""
    for i = 1, #winSeeds do
      str = str .. winSeeds[i] .. ","
    end
    print(str .. "\n")
    print("Lose Seeds(" .. #loseSeeds .. "):")
    str = ""
    for i = 1, #loseSeeds do
      str = str .. loseSeeds[i] .. ","
    end
    print(str .. "\n")
    print("Draw Seeds(" .. #drawSeeds .. "):")
    str = ""
    for i = 1, #drawSeeds do
      str = str .. drawSeeds[i] .. ","
    end
    print(str .. "\n")
    local infoStr = ""
    for i = #myTeam.heroes, 1, -1 do
      infoStr = infoStr .. myTeam.heroes[i]._tid .. " "
    end
    infoStr = infoStr .. "==VS== "
    for i = 1, #enemyTeam.heroes do
      infoStr = infoStr .. enemyTeam.heroes[i]._tid .. " "
    end
    print(infoStr)
    print("(" .. tryTimes .. " times) " .. myTeam.score / tryTimes * 100 .. "% ==||== " .. enemyTeam.score / tryTimes * 100 .. "%")
  end
  
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  if not arg then
    arg = {"-pvp"}
  end
  pvp_main(bot_parameter_list.pvp.arenaLevel, bot_parameter_list.pvp.tryTimes)
end, EDDebug)
