package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("tools")
require("ui/awake/runetools")
local getRuneInfoFunction = require("battle/bot_rune")
math.randomseed(os.time())
ed.enableBotMode = true
ed.enableMaxAttStrategy = true
ed.warschool = 0
ed.bookReadingLevel = 0
local output_folder = "PVP_PetFirstTime"
local arenaLevel = 100
local heroStar = 5
local arousal = {
  _status = 1,
  _str = 100,
  _int = 100,
  _agi = 100
}
local superAwake = {
  _status = 1,
  _sun = 0,
  _moon = 0,
  _star = 0
}
local pk_times = 100
local halloffameNum = 100
local magic_number = 0.3
local teamNum = 10
local bot_parameter_list = {
  max_rank = 16,
  pvp = {
    arenaLevel = arenaLevel,
    generationNum = 10000,
    maxHeroId = 10041,
    heroStar = heroStar,
    teamNumber = teamNum,
    heroAwake = arousal,
    heroSuperAwake = superAwake,
    heroPet = {
      _type_id = 100016,
      _heart = 5,
      _skill_levels = {100, 100}
    },
    enemyTeam = {
      {
        _tid = "DK",
        _level = arenaLevel,
        _stars = heroStar,
        _arousal = arousal,
        _hero_rune = superAwake
      },
      {
        _tid = "NW",
        _level = arenaLevel,
        _stars = heroStar,
        _arousal = arousal,
        _hero_rune = superAwake
      },
      {
        _tid = "Puck",
        _level = arenaLevel,
        _stars = heroStar,
        _arousal = arousal,
        _hero_rune = superAwake
      },
      {
        _tid = "WW",
        _level = arenaLevel,
        _stars = heroStar,
        _arousal = arousal,
        _hero_rune = superAwake
      },
      {
        _tid = "Sniper",
        _level = arenaLevel,
        _stars = heroStar,
        _arousal = arousal,
        _hero_rune = superAwake
      }
    },
    cullHeroeIds = {
      [47] = true,
      [10034] = true,
      [10038] = true,
      [10039] = true,
      [82] = true,
      [96] = true,
      [97] = true,
      [99] = true,
      [100] = true,
      [10003] = true,
      [10004] = true,
      [10005] = true,
      [10006] = true,
      [10007] = true,
      [10010] = true
    },
    highlight = {}
  },
  comment = "100,aller",
  stage = {}
}
local multiplier = 3125
local moder = 34359738337
local random_seed = 1

local function rand()
  local next_seed = random_seed * multiplier % moder
  local ret = next_seed / moder
  random_seed = next_seed
  if do_battle_log then
    btlog("Rand:" .. ret)
  end
  return ret
end

ed.rand = rand

local function srand(seed)
  if seed == 0 then
    print("Error:srand(0)")
    seed = 1
  elseif do_battle_log then
    btlog("srand(" .. seed .. ")")
  end
  random_seed = seed
  if ed.run_with_scene then
    ed.battleshare.getRseed(seed)
  end
end

ed.srand = srand

local function descFrame(info)
  local funcname = info.name or "?"
  local short_src = info.short_src or "nil"
  local linedefined = info.linedefined or -1
  local currentline = info.currentline or -1
  if funcname ~= "?" then
    funcname = "'" .. funcname .. "'"
  else
    funcname = string.format("<%s:%i>", short_src, linedefined)
  end
  return string.format("%s:%i: in function %s", short_src, currentline, funcname)
end

function BotDebug(msg)
  if enable_dump then
    if senddumpfile then
      local text = tostring(msg) .. "\n" .. debug.traceback()
      senddumpfile(text)
    end
    enable_dump = false
  end
  local p = EDLog and EDLog or print
  if ed.enableBotMode then
    p = print
  end
  if ed.debug_mode and not EDFLAGWIN32 then
    local _p = p
    
    function p(msg)
      _p(msg)
      debugError.showError(msg)
    end
  end
  if ed.BattleParams then
    for k = 1, 2 do
      local infoStr = ""
      for i = 1, #ed.BattleParams[k] do
        infoStr = infoStr .. ed.BattleParams[k][i].name .. " "
      end
      p(infoStr)
    end
    print("Rand Seed", ed.BattleParams[3])
    print("Tick Num", ed.BattleParams[4])
  end
  p("----------------------------------------")
  p(tostring(msg))
  if msg then
    p("LUA ERROR: " .. tostring(msg))
  end
  local i = 2
  local info = debug.getinfo(i)
  p("Stack traceback:")
  repeat
    p(string.format("[%i]\t%s", i - 2, descFrame(info)))
    i = i + 1
    info = debug.getinfo(i)
  until not info
  p("----------------------------------------")
  if EDFLAGWIN32 then
    EDConsoleEnable(0)
    debug.debug()
    EDConsoleEnable(1)
  elseif EDFLAGSVR then
    debug.debug()
  end
end

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
  if bot_parameter_list.max_rank then
    ed.parameter.unit_max_rank = bot_parameter_list.max_rank
  end
  
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
    end
    
    table.sort(list, function(a, b)
      return attackRange(a._tid) < attackRange(b._tid)
    end)
  end
  
  local function challenge(teamheroes1, teamheroes2, pktimes)
    local wintimes = 0
    local winrate = 0
    for i = 1, pktimes do
      ed.srand(i)
      ed.engine:enterArena(teamheroes1, teamheroes2, true, true)
      local tickNum = 0
      while ed.engine.running do
        ed.engine:tick()
        tickNum = tickNum + 1
      end
      if 720 <= tickNum then
      elseif 0 < ed.engine.result_stars then
        wintimes = wintimes + 1
      end
    end
    winrate = wintimes / pktimes
    return winrate
  end
  
  local function pvp_cracker(arenaLevel, generationNum)
    local totalTime = 0
    local totalTimes2 = 0
    if not arenaLevel then
      print("Arena level = ? ")
      arenaLevel = io.read("*n")
    end
    if not generationNum then
      print("Generation Num = ? ")
      generationNum = io.read("*n")
    end
    ed.srand(os.time())
    print("==========May take a few minutes,please wait==========")
    local enemyTeam = bot_parameter_list.pvp.enemyTeam
    for i = 1, #enemyTeam do
      enemyTeam[i]._hero_rune = getRuneInfoFunction(enemyTeam[i]._tid, superAwake)
      if not ed.lookupDataTable("Unit", "Can Awake", enemyTeam[i]._tid) then
        enemyTeam[i]._arousal = {_status = 0}
      end
      if not ed.lookupDataTable("Unit", "Can Awake2", enemyTeam[i]._tid) then
        enemyTeam[i]._hero_rune = {_status = 0}
      end
    end
    sortHeroes(enemyTeam)
    local halloffame = {}
    local heroList = {}
    local specifyHero = {}
    if specifyHeroID then
      specifyHero = {
        _tid = specifyHeroID,
        _level = arenaLevel,
        _stars = bot_parameter_list.pvp.heroStar,
        _arousal = bot_parameter_list.pvp.heroAwake,
        _hero_rune = bot_parameter_list.pvp.heroSuperAwake,
        _pet = bot_parameter_list.pvp.heroPet,
        name = ed.lookupDataTable("Unit", "Name", specifyHeroID)
      }
      if not ed.lookupDataTable("Unit", "Can Awake", specifyHeroID) then
        specifyHero._arousal = {_status = 0}
      end
      if not ed.lookupDataTable("Unit", "Can Awake2", specifyHeroID) then
        specifyHero._hero_rune = {_status = 0}
      end
    end
    for id, info in pairs(ed.getDataTable("Unit")) do
      if type(id) == "number" and id <= bot_parameter_list.pvp.maxHeroId and (id <= 100 or 10001 <= id) and not bot_parameter_list.pvp.cullHeroeIds[id] then
        local hero = {
          _tid = id,
          _level = arenaLevel,
          _stars = bot_parameter_list.pvp.heroStar,
          _arousal = bot_parameter_list.pvp.heroAwake,
          _hero_rune = bot_parameter_list.pvp.heroSuperAwake,
          _pet = bot_parameter_list.pvp.heroPet,
          name = ed.lookupDataTable("Unit", "Name", id)
        }
        if not ed.lookupDataTable("Unit", "Can Awake", id) then
          hero._arousal = {_status = 0}
        end
        if not ed.lookupDataTable("Unit", "Can Awake2", id) then
          hero._hero_rune = {_status = 0}
        end
        table.insert(heroList, hero)
      end
    end
    local teams = bot_parameter_list.pvp.teamNumber + 10
    local teamList = {}
    for i = 1, teams do
      for k = 1, #heroList do
        heroList[k].weight = math.random()
      end
      table.sort(heroList, function(a, b)
        return a.weight > b.weight
      end)
      local IdenticalNum = heroList[1]._tid ^ 2 + heroList[2]._tid ^ 2 + heroList[3]._tid ^ 2 + heroList[4]._tid ^ 2 + heroList[5]._tid ^ 2
      local team = {
        heroes = {
          heroList[1],
          heroList[2],
          heroList[3],
          heroList[4],
          heroList[5]
        },
        winrate = 0,
        teamID = IdenticalNum
      }
      sortHeroes(team.heroes)
      table.insert(teamList, team)
    end
    for i = 1, #teamList do
      teamList[i].winrate = challenge(teamList[i].heroes, enemyTeam, pk_times)
    end
    table.sort(teamList, function(a, b)
      return a.winrate > b.winrate
    end)
    halloffame = teamList
    os.execute("md " .. output_folder)
    for g = 1, generationNum do
      local challengeTeamNum = 0
      local challengeteamList = {}
      for i = 1, #halloffame do
        local son = {
          heroes = {}
        }
        for k = 1, 5 do
          local dice = math.random()
          if dice < magic_number then
            local new = math.floor(math.random() * #heroList) + 1
            son.heroes[k] = heroList[new]
          else
            son.heroes[k] = halloffame[i].heroes[k]
          end
        end
        if specifyHeroID then
          local alreadyhas = false
          for j = 1, #son.heroes do
            if son.heroes[j]._tid == specifyHeroID then
              alreadyhas = true
              break
            end
          end
          if not alreadyhas then
            son.heroes[1] = specifyHero
          end
        end
        son.winrate = 0
        son.teamID = son.heroes[1]._tid ^ 2 + son.heroes[2]._tid ^ 2 + son.heroes[3]._tid ^ 2 + son.heroes[4]._tid ^ 2 + son.heroes[5]._tid ^ 2
        sortHeroes(son.heroes)
        local checkself = true
        local checkhof = true
        local checkchallenge = true
        for j = 1, #son.heroes do
          for k = j + 1, #son.heroes do
            if son.heroes[j]._tid == son.heroes[k]._tid then
              checkself = false
              break
            end
          end
          if checkself == false then
            break
          end
        end
        if checkself then
          for i = 1, #halloffame do
            if son.teamID == halloffame[i].teamID then
              checkhof = false
              break
            end
          end
          if checkhof then
            if 1 <= #challengeteamList then
              for i = 1, #challengeteamList do
                if son.teamID == challengeteamList[i].teamID then
                  checkchallenge = false
                  break
                end
              end
            end
            if checkchallenge then
              table.insert(challengeteamList, son)
              challengeTeamNum = challengeTeamNum + 1
            end
          end
        end
        if challengeTeamNum == bot_parameter_list.pvp.teamNumber then
          break
        end
      end
      for i = 1, #challengeteamList do
        challengeteamList[i].winrate = challenge(challengeteamList[i].heroes, enemyTeam, pk_times)
        table.insert(halloffame, challengeteamList[i])
      end
      table.sort(halloffame, function(a, b)
        return a.winrate > b.winrate
      end)
      for i = #halloffame, halloffameNum + 1, -1 do
        halloffame[i] = nil
      end
      local out = io.open(string.format(output_folder .. "/Cracker_%i_Genetation_%i.txt", arenaLevel, g), "w+")
      print("=====================Gen " .. g .. "====================")
      for i = 1, #halloffame do
        local team = halloffame[i]
        local format = "%s:\t %s %s %s %s %s"
        local paras = {i}
        local windowFormat = "%s%s%s%s%s%s"
        local windowParas = {
          tostring(i)
        }
        team.position = i
        for _, h in ipairs(team.heroes) do
          local _str = h.name
          if bot_parameter_list.pvp.highlight[h.name] then
            _str = _str .. bot_parameter_list.pvp.highlight[h.name]
          end
          table.insert(paras, h.name)
          table.insert(windowParas, _str)
        end
        for i, ele in ipairs(windowParas) do
          local len = 10 - string.len(ele)
          for k = 1, len do
            windowParas[i] = windowParas[i] .. " "
          end
        end
        local specificStr = string.format(windowFormat, unpack(windowParas))
        print(specificStr .. " winrate: " .. team.winrate)
        local str = string.format(format, unpack(paras))
        if out then
          out:write(str .. " winrate: " .. team.winrate)
          out:write("\n")
        end
      end
      if out then
        out:flush()
        out:close()
      end
    end
  end
  
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  if not arg then
    arg = {"-pvp"}
    arg = {"-pvp"}
  end
  if arg[1] == "-pvp" then
    local time = os.time()
    pvp_cracker(bot_parameter_list.pvp.arenaLevel, bot_parameter_list.pvp.generationNum)
    print("Time: " .. os.time() - time)
  else
    print("hehe")
  end
end, BotDebug)
